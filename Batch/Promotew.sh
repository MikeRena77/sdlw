#! /bin/sh
# promoteWarning
# This script should be added as a pre-link to a promote process.  It checks to see if
# any other package in the state has an earlier version of one of the same files.  If so,
# this would result in the promotion of the earlier version along with the later one which
# could destabilize the build in the next state.
#
# UDP Program line: promoteWarning [environment] [state] [package]
#
display=
export display

env=$1
state=$2
exitVal=0

# Now point at the package(s)
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
         S.statename='$state' and
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
         if test $otherVersion -lt $thisVersion
         then
            rm -f sqlout
            exit_val=1
            echo "\n****************************************************************************************\n"
            echo "PROMOTION FAILURE:"
            echo "Promotion of $pkg failed because it would promote an earlier version of"
            echo "$i.  An override promotion must be performed to advance"
            echo "this version, or promote the earlier version first.\n"
            echo "\n****************************************************************************************\n"
         fi
      fi
   done
   shift
done
rm -f sqlout
rm -f files

exit $exit_val

