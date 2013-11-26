################################################################################
# $Header: mySCMLinkChecker.pl, v1.0, 4/01/2008 mha      Exp $                                                                           *
# Perl script used to run the link checker command on the test site
#    http://web/scManagment
#    on HARDEV2
#
# This script expects to find the Python Linkchecker already installed
#    It should be run after its respective Harvest Check Out or HRefresh process
#
#
# Command line usage:
#    perl mySCMLinkChecker.pl webPath
#      where:
#          web = the specific web under \Inetpub
#                i.e. h3_alpha; h3_beta; OR wwwroot
#
# Written 3-27-2008
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
#    Version    Date       by   Change Description
#       1.0     4/01/2008  MHA  Created Perl script to run the new Python LinkChecker
#       1.1     7/28/2008  MHA  Rewrote function to internally time-stamp log file
#       1.2     9/05/2008  MHA  A HARDEV2 version for HARDEV2 web site
#       1.3     7/15/2009  MHA  Quality check and cleanup
#
################################################################################
use Env;
$webPath  = $ARGV[0]; shift;
$scripDir= "C:\\hScripts\\logs";

chomp ($webPath);
# removed STDOUT and STDERR redirection
# STDOUT and STDERR logging is being handled by calling script


$PYTHON="c:\\Python25;c:\\python25\\scripts";
$PATH="$PYTHON;$PATH";
# check for webPath and target from the args passed in
print "$webPath\n";
print scalar localtime;
print "\n";
print("-----BEGIN mySCMLinkChecker REPORT------------------------------\n");
if ($webPath eq "h3_alpha")
{
    $webSite="http://hardev2:8088/SCManagement/";
};
if ($webPath eq "h3_beta")
{
    $webSite="http://hardev2:8098/SCManagement/";
};
if ($webPath eq "wwwroot")
{
    $webSite="http://hardev2:80/SCManagement/";
};

$error_exit=system("linkchecker.bat -v -o text \"$webSite\"");
print("-----END mySCMLinkChecker REPORT--------------------------------\n");
print scalar localtime;
print "\n";

exit $error_exit;