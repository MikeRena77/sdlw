########################################################################
# $Header: grabHrFunctionsDll.pl,v 1.0 2008/03/10 13:58:00 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script runs the hco command for the AAFES.HR.Functions.dll
#    to support the many web projects that rely on it 
#
# Command line usage:
#    perl grabHrFunctionsDll.pl [clientpath] [package] 
#    $project = "AAFES.HR.Functions"
#    $item = "*.dll"
#    $state = "Closed"
#    $viewpath = "\AAFES.HR.Functions\bin\Release"
#    $clientpath = ["clientpath"]
#
#    Version    Date       by   Change Description
#       1.0     3/10/2008  MHA  Script to checkout the AAFES.HR.Functions.dll
#       1.1     3/11/2008  MHA  Added/modified some comments
#       1.2     4/14/2008  MHA  Script revised for PRODSWA
#       1.3     4/25/2008  MHA  Reversed the order of the parameters since $package should be dealt with last
#       1.4     5/22/2008  MHA  Added -nt (no tag) to check out process; changed $scripDir for consistency
#       1.5     6/30/2008  MHA  First-step change - state name to reflect changes bringing Functions in-line with other HarvestApps
#       1.6     7/28/2008  MHA  Rewrote function to internally time-stamp log file
#       1.7     8/21/2008  MHA  Changes to point to Gold in the production lifecycle to grab the DLL rather than development
#       1.8     5/14/2009  MHA  Changes to add AAFES.HR.CoreUtilities dll to the grab
#       1.9     7/14/2009  MHA  Changed to get AAFES.HR.CoreUtilities dll from Release
#       1.10    9/11/2009  MHA  Added routine to clear problems in the FrontPage _vti_pvt\service.lck
#       1.11   10/05/2009  MHA  Modified the hco commands to use new r12 "-replace all" for overwrite
#
########################################################################
use Env;
my $clientpath       = $ARGV[0]; shift;
my $package        = $ARGV[0]; shift;
chomp ($package);
chomp ($clientpath);

my $scripDir= "C:\\hScripts";
my $project = "AAFES.HR.Functions.Prod";
my $item = "*.dll";
my $state = "Gold";       # change to Release for PRODSWA
my $viewpath = "\\AAFES.HR.Functions\\bin\\Release";
my $bin = "\\Bin";
my $target = $clientpath;
$clientpath = $clientpath . $bin;

# redirect STDOUT and STDERR to grabHrFunctionsDll$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/grabHrFunctionsDll$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN grabHrFunctionsDll------------------------------\n");

print("hco -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -br -replace all -nt -s \"*.dll\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"$HARVESTHOME\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
$error_exit=system("hco -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -br -replace all -nt -s \"*.dll\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"$HARVESTHOME\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
if ($error_exit != 0){ print "Error: $error_exit: $! \n"};

print("-----END grabHrFunctionsDll--------------------------\n");

print("-----BEGIN grabHrCoreUtilitiesDll------------------------------\n");
my $project = "AAFES.HR.Core.Utilities.Prod";
my $viewpath = "\\AAFES.HR.Core.Utilities\\bin\\Release";

print("hco -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -br -replace all -nt -s \"*.dll\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"$HARVESTHOME\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
$error_exit=system("hco -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -br -replace all -nt -s \"*.dll\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"$HARVESTHOME\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
if ($error_exit != 0){ print "Error: $error_exit: $! \n"};

{
chdir $target . "\\_vti_pvt";
print ("attrib -r /s \"service.lck\" \n");
$error_exit=system("attrib -r /s \"service.lck\"");
if ($error_exit != 0){ print "Error: $error_exit: $! \n"};
}

print("-----END grabHrCoreUtilitiesDll--------------------------\n");

print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
