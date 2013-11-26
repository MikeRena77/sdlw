########################################################################
# $Header: updateHrReports.pl,v 1.0 2008/03/03 12:28:00 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script updates all the hrReports source files from Harvest
#    using the standard Harvest Check Out for Browse
#
# Command line usage:
#    perl updateHrReports.pl [state] web
#
#    Parameter passed in:
#      $state = state => which state is the source of our update
#      $web = web => which web are we targetting (i.e. h3_beta, h3_alpha, etc)
#
#    Version    Date by   Change Description
#      1.0      1/18/2008  MHA   Script written for updating source files on build server
#      1.1      3/14/2008  MHA   Modified for more debug info with PRINT and $error_exit and added web parameter
#      1.2      3/17/2008  MHA   Added a new checkout to grab the solution file out of Harvest and the $state variable to expand use
#      1.3      3/18/2008  MHA  Added new line mod for separator
#      1.4      4/17/2008  MHA  Port to PRODSWA and HARDEV2
#      1.5      4/18/2008  MHA  Fix required because solution file is now stored under $web
#      1.6      5/14/2008  MHA  Moved final checkout for webinfo and vspscc files to after the hrefresh
#      1.7      5/27/2008  MHA  Mod to get the correct project for specific web (e.g. h3_qa or h3 get HR-Reports-Prod)
#      1.8      5/28/2008  MHA  Had to make corrections to Perl conditional handling in checking web parameter (eq NOT =)
#      1.9      7/28/2008  MHA  Rewrote function to internally time-stamp log file
#
########################################################################

$scripDir= "C:\\hScripts";
my $state = $ARGV[0]; shift;
my $web = $ARGV[0]; shift;

chomp($state);
chomp($web);

$project = "HR-Reports-2003";
if ($web eq "h3_qa"){ $project = "HR-Reports-Prod"};

if ($web eq "h3"){ $project = "HR-Reports-Prod"};

# redirect STDOUT and STDERR to updateHrReports$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/updateHrReports$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print("updateHrReports.pl \"$state\" \"$web\" \n");

print scalar localtime;
print "\n";
print("-----BEGIN UPDATE HRREPORTS------------------------------\n");

print("hco \"*.*\" -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"\\HR-Reports\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"c:\\inetpub\\$web\\hrReports\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
$error_exit=system("hco \"*.*\" -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"\\HR-Reports\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"c:\\inetpub\\$web\\hrReports\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
if ($error_exit != 0){ print "Error: $error_exit: $! \n"};

print("-----END UPDATE HRREPORTS--------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
