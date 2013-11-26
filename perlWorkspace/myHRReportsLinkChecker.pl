########################################################################
# $Header: hrReportsWebCheck.pl,v 1.0 2008/04/14 14:50 mha Exp $
# Perl script used to run the link checker command on the test site
#    http://web/hrReports
#    on HARDEV2
#
# This script expects to find the Python Linkchecker already installed
#    It should be run after its respective Harvest Check Out or HRefresh process
#
#
# Command line usage:
#    perl myhrReportsWebCheck.pl web
#      where:
#          web = the specific web under \Inetpub
#
# Original coding 3-27-2008; Modified for HRReports 4-14-2008
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
#    Version    Date       by   Change Description
#       1.0     4/14/2008  MHA  Created Perl script to run the new Python LinkChecker
#       1.1     4/30/2008  MHA  Revisions to point to the actual h3_alpha, h3_beta, h3_qa
#       1.2     5/19/2008  MHA  Another revision to point to gold
#       1.3     5/22/2008  MHA  Standardizing $scripDir and $web across scripts
#       1.4     7/28/2008  MHA  Rewrote function to internally time-stamp log file
#
########################################################################
use Env;
 $web  = $ARGV[0]; shift;
 $scripDir= "C:\\hScripts";

chomp ($web);
# removed STDOUT and STDERR redirection
# STDOUT and STDERR logging is being handled by calling script

$PYTHON="c:\\Python25;c:\\python25\\scripts";
$PATH="$PYTHON;$PATH";
# check for web and target from the args passed in
print "$web\n";
print scalar localtime;
print "\n";
system("echo %PATH%");
print("-----BEGIN myHRReportsLinkChecker REPORT------------------------------\n");
if ($web eq "h3_alpha")
{
    $webSite="http://bane-h3-alpha.aafes.com/hrReports/";
};
if ($web eq "h3_beta")
{
    $webSite="http://bane-h3-beta.aafes.com/hrReports/";
};
if ($web eq "h3_qa")
{
    $webSite="http://bane-h3-qa.aafes.com/hrReports/";
};
if ($web eq "h3")
{
    $webSite="http://galactus-h3-gold.aafes.com/hrReports/";
};

$error_exit=system("linkchecker.bat -v -o text \"$webSite\"");
print("-----END myHRReportsLinkChecker REPORT--------------------------------\n");
print scalar localtime;
print "\n";

exit $error_exit;