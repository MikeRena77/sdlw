#! /bin/sh
# on_branch_chk.sh
# This script checks to see if there are any branch versions in the
# packages that are being promoted.  If there are, this script returns
# a failure status.  
# This script should be pre-linked to a Demote process.
# The input parameters for this script are the environment and list of packages
# UDP Program line: on_branch_chk.sh [environment] [package]
#
display=
export display
env=$1
shift
rm -f sqlout
while [ $#  -ge  1  ]
do
    hsql -nh -s <<EOF >sqlout
    select
      rpad(rtrim(T.pathfullname)||rtrim(I.itemname)||';'||V.versionstatus,58)
    from
      harpathfullname T,
      haritem I,
      harversion V,
      harpackage P,
      harenvironment E,
      harallusers U
    where
      E.environmentname = '$env' and
      P.packagename = '$1' and
      P.envobjid = E.envobjid and
      V.packageobjid = P.packageobjid and
      V.itemobjid = I.itemobjid and
      I.pathobjid = T.pathobjid and
      V.mappedversion not like '%.%.%'
    ORDER BY
	pathfullname,itemname,mappedversion
EOF

    if [ -s sqlout ]
    then 
        echo "\nCan't demote $1 with file on main trunk:\n"
        cat sqlout | while read line
        do
           echo "$line"
        done
        echo "\n*** Retrieve branch before demoting. ***\n"
        sleep 1
        rm -f sqlout
        exit 1
    else
        echo "Package OK to demote."
    fi
    shift
done
# cleanup
rm -f sqlout
exit 0

