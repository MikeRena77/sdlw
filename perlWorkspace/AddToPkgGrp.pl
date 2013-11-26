# AddToPkgGrp.pl - Trey White
 
# This script runs as a post-link UDP process on the Create Package process. 
# The script is designed to add the Package being created to a Package Group defined as a variable.

# usage: perl -S AddToPkgGrp.pl "[broker]" "[user]" "[password]" "[project]" "PkgGrpName" "[package]"

# Definitions: PkgGrpName = the Package Group Name that you have created for Emergency Fixes (e.g. EMR)

$bkr = $ARGV[0];
shift;
$usr = $ARGV[0];
shift;
$pswd = $ARGV[0];
shift;
$project = $ARGV[0];
shift;
$pkggrp = $ARGV[0];
shift;
$pkg = $ARGV[0];


# Invoke the Update Package CLI
print "hup -b \"$bkr\" -usr \"$usr\" -pw \"$pswd\" -en \"$project\" -p \"$pkg\" -apg \"$pkggrp\" \n"; 
system "hup -b \"$bkr\" -usr \"$usr\" -pw \"$pswd\" -en \"$project\" -p \"$pkg\" -apg \"$pkggrp\" "; 