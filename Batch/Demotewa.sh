#! /bin/sh
# DemoteWarn
# This script should be added as a pre-link to a demote process.  It checks to see if
# any other package in the last state has a later version of one of the same files.  If so,
# it prints out a warning message. 
#
# UDP Program line: DemoteWarn [environment] [state] [nextstate] [package]
#
display=
export display

env=$1
state=$2
laststate=$3
exitVal=0

# Now point at the package(s)
shift
shift
shift

while test $# -gt 0
do
   # get the file names
   hsql -nh -s <<EOF >files
   select
      itemname
   from
      harPackage P, harVersion V, harItem I, harEnvironment E, harState S
   where
      E.environmentname='$env' and
      P.envobjid=E.envobjid and
      S.statename='$state' and
      P.stateobjid=S.stateobjid and
      P.packagename='$1' and
      V.packageobjid=P.packageobjid and
      I.itemobjid=V.itemobjid
   order by
      1
EOF

   rm -f sqlout

   filenames=`awk '{print $1 $2 $3}' files`

   for i in $filenames
   do
      pkg=$1
      hsql -nh -s <<EOF >sqlout
      select 
         mappedversion
      from
         harPackage P, harVersion V, harItem I, harEnvironment E, harState S
      where
         E.environmentname='$env' and
         P.envobjid=E.envobjid and
         S.statename='$laststate' and
         P.stateobjid=S.stateobjid and
         V.packageobjid=P.packageobjid and
         P.packagename != '$pkg' and
         I.itemobjid=V.itemobjid and
         I.itemname='$i'
EOF
      if test -s sqlout
      then
         otherVersion=`awk '{printf "%d", $1}' sqlout`

         hsql -nh -s <<EOF >sqlout
         select 
            mappedversion
         from
            harPackage P, harVersion V, harItem I, harEnvironment E, harState S
         where
            E.environmentname='$env' and
            P.envobjid=E.envobjid and
            S.statename='$state' and
            P.stateobjid=S.stateobjid and
            V.packageobjid=P.packageobjid and
            P.packagename = '$pkg' and
            I.itemobjid=V.itemobjid and
            I.itemname='$i'
EOF
         thisVersion=`awk '{printf "%d", $1}' sqlout`
         if test $otherVersion -gt $thisVersion
         then
            rm -f sqlout
            echo "\n*****************************************************************************************************\n"
            echo "WARNING - NEWER VERSION EXISTS:"
            echo "There is a newer version of $i in $laststate.  Updates must be made to the"
            echo "latest version by either checking it out for update, or through a cross-environment"
            echo "merge from a temporary environment linked to a snapshot of $laststate."
            echo "\n*****************************************************************************************************\n"
         fi
      fi
   done
   shift
done
rm -f sqlout
rm -f files

exit $exit_val

