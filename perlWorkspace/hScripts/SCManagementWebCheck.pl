########################################################################
# $Header: SCManagementWebCheck.pl,v 1.0 2008/04/01 14::00 mha Exp $
# Perl script used to launch link checker Perl script and web check batch on the test site
#    http://web/scManagment
#    on HARDEV3
#
# This script expects to find the Python Linkchecker already installed
#    It should be run after its respective Harvest Check Out or HRefresh process
#
#
# Command line usage:
#    perl mySCManagementWebCheck.pl webPath
#      where:
#          webPath = the specific web under \Inetpub
#
# Written 3-27-2008
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
#    Version    Date       by   Change Description
#       1.0     4/01/2008  MHA  Created launcher for the new Python LinkChecker followed by web check
#       1.1     4/10/2008  MHA  Switched launching the webcheck.bat from direct to "call" and moved call back into STDOUT handling
#
########################################################################
 $webPath  = $ARGV[0]; shift;
 $scripDir= "C:\\hScripts\\logs";

chomp ($webPath);

# redirect STDOUT and STDERR to SCManagementWebCheck$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/SCManagementWebCheck$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

# Launch Perl script to run linkchecker.bat for all links
print("perl c:\\hScripts\\mySCMLinkChecker.pl \"$webPath\" \n");
system("c:\\perl\\bin\\perl.exe c:\\hScripts\\mySCMLinkChecker.pl \"$webPath\"");

# Run the FP command-line utilities to "CHECK" and "INSTALL/PUBLISH" the <SCManagement> web site
print ("call c:\\hScripts\\webCheck.bat SCManagement \"$webPath\"");
$error_exit=system("call c:\\hScripts\\webCheck.bat SCManagement \"$webPath\"");

close STDOUT;
close STDERR;

exit $error_exit;