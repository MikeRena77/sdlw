rem Check Ins
rem MODEL hci -b HARDEV1 -en "Release Model Test" -st "Development" -p "DEVSWA reload" -vp "\Release" -pn "CkIn" -ur -d -de "Reload from DEVDBS to HARDEV1" -s "*.*" -op pc -cp "C:\Documents and Settings\AndrewsMic\My Documents\harvest projects\Archives\Release" -if ne -eh hardev1.dfo –oa "hardev1.reload"
rem hcp packagename {-b name -en name -st name -usr username -pw password} [-v] [-pn name] [-at username] [-prompt] [-i inputfile.txt | -di inputfile.txt] [-eh filename] [-o filename | –oa filename] [-arg] [-wts] [-h]
hcp "DEVSWA reload CMEW" -b HARDEV1 -en "CMEW Testing" -st "Development" -pn "Create Package" -eh hardev1.dfo -o "hardev1.reload" -wts
hcp "DEVSWA reload Training" -b HARDEV1 -en "Harvest Training" -st "Development" -pn "Create Package" -eh hardev1.dfo -oa "hardev1.reload" -wts
hcp "DEVSWA reload wwwroot" -b HARDEV1 -en "Deployment" -st "Development" -pn "Create Package" -eh hardev1.dfo -oa "hardev1.reload" -wts

pause
hci -b HARDEV1 -en "CMEW Testing" -st "Development" -p "DEVSWA reload CMEW" -vp "\Testing" -pn "Check In Modified Files" -ur -de "Reload from DEVDBS to HARDEV1" -s "*.*" -op pc -cp "C:\Documents and Settings\AndrewsMic\My Documents\harvest projects\Archives\Testing" -if ne -eh hardev1.dfo –oa "hardev1.reload" -wts
hci -b HARDEV1 -en "Harvest Training" -st "Development" -p "DEVSWA reload Training" -vp "\Training" -pn "Check In New Items" -ur -d -de "Reload from DEVDBS to HARDEV1" -s "*.*" -op pc -cp "C:\Documents and Settings\AndrewsMic\My Documents\harvest projects\Archives\Training" -if ne -eh hardev1.dfo –oa "hardev1.reload" -wts
hci -b HARDEV1 -en "Deployment" -st "Development" -p "DEVSWA reload wwwroot" -vp "\wwwroot" -pn "Check In Files" -ur -d -de "Reload from DEVDBS to HARDEV1" -s "*.*" -op pc -cp "C:\Documents and Settings\AndrewsMic\My Documents\harvest projects\Archives\wwwroot" -if ne -eh hardev1.dfo –oa "hardev1.reload" -wts