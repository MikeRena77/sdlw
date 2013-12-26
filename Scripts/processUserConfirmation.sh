# Just an example from an AIX KShell script of processing user confirmation
# Prompt user to confirm
#
echo "Do you want to apply: ${PATCHNUMBER}? [y/n]"
unset KEY
while [ -z "${KEY}" ]; do
    read KEY
    case "${KEY}" in
        "Y" | "y") break;;
        "N" | "n") exit 0;;
        *) echo "Please answer [y/n]."; unset KEY;;
    esac
done 
#
