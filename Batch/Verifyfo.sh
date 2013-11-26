#! /bin/sh
# verifyform.sh
#
# This is a template script that demonstrates a method used to
# verify that chosen fields of a Harvest form are filled in.  When properly
# modified, this script can be used to prevent the promotion of a package
# when its associated form is not filled out properly.
#
# An additional feature of this script is that it allows you to verify
# different fields depending on the state the form is in.  A different
# check function can be called in each state, and each check function
# can check the same or different fields.
#
# This script is based on the Harvest Problem Report.  To modify it for your
# own form, 1) replace all instances of "harProblemReport" with the table name
# of your own form.  Do this in all select statements. 2) In each function,
# change the line following "SELECT" to show the field names of the fields
# in your form that you want to check.  Always retain "formname" because you
# want to include this in your error message.  3) In each function, change
# each grep statement below FORMNAME to show the name of the field you are
# looking for.  Put them in all caps, as this is the way that hsql reports
# them (alternatively, # use the -i option of grep). 4) In each function,
# set the stateErrorString to the correct field name.  If the field name
# is two or more words, use an underscore between the words instead of
# a space so that the error message will be parsed correctly on printout.
# 5) Add a new function for each state in which you want to check the form.
# 6) In the case statement at the end of the script, add a new function call
# for each new function you add.
#
# UDP Program line: verifyform.sh "[environment]" "[nextstate]" "[package]"
#

#------------------------------------------------------------------------------
# Functions Definitions
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# FUNC_CHECK_DEV 
#    Checks the fields of the Problem Report form that must be filled in before
#    the package is promoted to Test.  Guarentees a failure exit value
#    if any of the fields are blank.
#------------------------------------------------------------------------------
FUNC_CHECK_DEV()
{
   # Check the field(s) in the state Initiate
   hsql -s <<EOF >temp2
   SELECT
      formname, problemdescr, keyword
   FROM
      harProblemReport P, harForm F
   WHERE
      P.formobjid = '$form_id'
      and F.formobjid = P.formobjid 
EOF
   # Get the formname
   form_name=`grep FORMNAME temp2 | awk '{print $3}'`

   # Get the contents of the fields you want to check
   #
   # Problem Description ------------------------------------
   field_contents=`grep PROBLEMDESCR temp2 | awk '{print $3}'`
   if test `echo "$field_contents" | wc -c` -le 1
   then
      stateErrorString=$stateErrorString'\tProblem_Description\n'
      exit_code=1
   fi
   #
   # Key Word -----------------------------------------------
   field_contents=`grep KEYWORD temp2 | awk '{print $3}'`
   if test `echo "$field_contents" | wc -c` -le 1
   then
      stateErrorString=$stateErrorString'\tKeyword\n'
      exit_code=1
   fi

   if [ $exit_code -ne 0 ]
   then
      FUNC_PROMOTE_ERROR              # print an error message
   fi
   #Clean up
   rm -f temp1
   rm -f temp2
}

#------------------------------------------------------------------------------
# FUNC_CHECK_TEST 
#    Checks the fields of the Problem Report form that must be filled in before
#    the package is promoted to Production.
#    Guarentees a failure exit value if any of the fields are blank.
#------------------------------------------------------------------------------
FUNC_CHECK_TEST()
{
   # Check the field(s) in the state Initiate
   hsql -s <<EOF >temp2
   SELECT
      formname, severity 
   FROM
      harProblemReport P, harForm F
   WHERE
      P.formobjid = '$form_id'
      and F.formobjid = P.formobjid 
EOF
   # Get the formname
   form_name=`grep FORMNAME temp2 | awk '{print $3}'`

   # Get the contents of the fields you want to check
   #
   # Severity -----------------------------------------------
   field_contents=`grep SEVERITY temp2 | awk '{print $3}'`
   if test `echo "$field_contents" | wc -c` -le 1
   then
      stateErrorString=$stateErrorString'\tSeverity\n'
      exit_code=1
   fi

   if [ $exit_code -ne 0 ]
   then
      FUNC_PROMOTE_ERROR              # print an error message
   fi

   #Clean up
   rm -f temp1
   rm -f temp2
}


#------------------------------------------------------------------------------
# FUNC_PROMOTE_ERROR
#    Implements a standard error message for errors generated in each state.
#
# Global Variables:
#
#    stateErrorString - An array of strings that each check function appends to
#                       when it detects an empty field in the form.
#    form_name        - The name of the form being checked.  Each check function
#                       sets its value based on the function's SQL query.
#    pkg              - The name of the package being promoted.  This is passed
#                       in to the shell on the command line.
#------------------------------------------------------------------------------
FUNC_PROMOTE_ERROR()
{
   echo "\nThe following field(s) must be filled in:"
   for i in $stateErrorString
   do
      echo $i
   done
   echo "on form $form_name before you can promote package $pkg.\n"
   stateErrorString=
}
#------------------------------------------------------------------------------
# End of function definitions
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variable Initializations
#------------------------------------------------------------------------------
display=
export display

stateErrorString=
env=$1
state=$2

# Set the exit code to pass
exit_code=0

# Set the command line argument pointer to the package
shift 2
#
#------------------------------------------------------------------------------
# Program Entry Point is Here ---------|
#--------------------------------------V----------------------------------------
#
# Loop through and do each package
while [ $# -ge 1 ]
do
   pkg=$1

   hsql -nh -s <<EOF >temp1
   SELECT
      A.formobjid
   FROM
      harAssocPkg A, harPackage P, harForm F, harEnvironment E, harFormType T
   WHERE
      F.formtypeobjid=T.formtypeobjid
      and T.formtablename='harProblemReport'
      and F.formobjid=A.formobjid
      and A.assocpkgid=P.packageobjid
      and P.packagename='$pkg'
      and P.envobjid=E.envobjid
      and E.environmentname like '$env%'
EOF

   form_id=`awk '{print}' temp1`

   # Exit if no form found ---------------------------------------
   if [ ! -s temp1 ]
   then
      echo "\n**** PROMOTION FAILURE\n**** There is no form associated with package $pkg ****\n"
      exit 1
   fi
   # --------------------------------------------------------------

   case $state in 
      Dev)               FUNC_CHECK_DEV; exit $exit_code;;
      test)              FUNC_CHECK_TEST; exit $exit_code;;
      *)                 exit $exit_code;;
   esac

   shift
done
