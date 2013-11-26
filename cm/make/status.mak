# Test
# NMAKE Special macro definitions from MSDN
# $*  Current target's path and base name minus file extension.
# $** All dependents of the current target.
# $?  All dependents with a later timestamp than the current target.
# $@  Current target's full name (path, base name, extension), as currently specified.

FD_A=text1.txt
FD_B=text2.txt
FD_C=text3.txt

all: Status.dat

Status.dat: $(FD_A) $(FD_B) $(FD_C)
	echo Updated $?>>Status.dat

$(FD_A) $(FD_B) $(FD_C): 
	type $**>$@
