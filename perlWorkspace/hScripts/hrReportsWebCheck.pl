########################################################################
# $Header: hrReportsWebCheck.pl,v 1.0 2008/04/01 14::00 mha Exp $
# Perl script used to launch link checker Perl script and web check batch on the test site
#    http://web/scManagment
#    on HARDEV3
#
# This script expects to find the Python Linkchecker already installed
#    It should be run after its respective Harvest Check Out or HRefresh process
#
#
# Command line usage:
#    perl hrReportsWebCheck.pl web
#      where:
#          web = the specific web under \Inetpub
#
# Original coding 3-27-2008; Modified for HRReports 4-15-2008
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
#    Version    Date       by   Change Description
#       1.0     4/15/2008  MHA  Created hrReports webChecker from original SCM web check
#       1.1     5/22/2008  MHA  Mod to standardize $web and $scripDir across scripts
#       1.2     6/03/2008  MHA  Added banners to better identify report log
#       1.3     7/28/2008  MHA  Rewrote function to internally time-stamp log file
#
########################################################################
 $web  = $ARGV[0]; shift;
 $scripDir= "C:\\hScripts";

chomp ($web);

# redirect STDOUT and STDERR to hrReportsWebCheck$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/hrReportsWebCheck$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN hrReportsWebCheck REPORT------------------------------\n");
# Launch Perl script to run linkchecker.bat for all links
print("perl c:\\hScripts\\myhrReportsLinkChecker.pl \"$web\" \n");
system("c:\\perl\\bin\\perl.exe c:\\hScripts\\myhrReportsLinkChecker.pl \"$web\"");

# Run the FP command-line utilities to "CHECK" and "INSTALL/PUBLISH" the <SCManagement> web site
print ("call c:\\hScripts\\webCheck.bat hrReports \"$web\"");
$error_exit=system("call c:\\hScripts\\webCheck.bat hrReports \"$web\"");

print("-----END hrReportsWebCheck REPORT--------------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
