########################################################################
# $Header: approveHrFunctionsToQA.pl,v 1.0 2008/07/01 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script runs the hap command for AAFES.Hr.Functions.Prod
#    to approve promotion from Merge to QA
#
# Command line usage:
#    perl approveHrFunctionsToQA.pl
#
#    Version    Date       by   Change Description
#       1.0     7/01/2008  MHA  Script derived from approveHrWorkersToQA.pl
#       1.1     7/28/2008  MHA  Rewrote function to internally time-stamp log file
#       1.2     8/21/2008  MHA  Mod to move build functions over to the Prod lifecycle
#
########################################################################
use Env;

$scripDir       = "C:\\hScripts";
$project     = "AAFES.HR.Functions.Prod";

# redirect STDOUT and STDERR to approveHrFunctionsToQA$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/approveHrFunctionsToQA$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN approveHrFunctionsToQA------------------------------\n");

open (ENVLIST, "$scripDir\\pkg") or die "Can't open $scripDir\\pkg: $!\n";
ITEM: while (<ENVLIST>)
    {
        $/ = " \n";
        $package = $_;
        chomp ($package);
        $ENV{'PACKAGE'} = $package;
        
        print ("hap \"$package\" -b \"PRODSWA\" -en \"$project\" -st \"Merge\" -pn \"Approve Package for Promotion to QA (Sync)\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
        $error_exit=system("hap \"$package\" -b \"PRODSWA\" -en \"$project\" -st \"Merge\" -pn \"Approve Package for Promotion to QA (Sync)\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
        if ($error_exit != 0){ print "Error: $error_exit\n"};
        
        next ITEM;
    }
close (ENVLIST);

print("-----END approveHrFunctionsToQA--------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
