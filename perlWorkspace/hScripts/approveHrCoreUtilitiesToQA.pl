########################################################################
# $Header: approveHrCoreUtilitiesToQA.pl,v 1.0 2009/05/14 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script runs the hap command for AAFES.Hr.Core.Utilities.Prod
#    to approve promotion from Merge to QA
#
# Command line usage:
#    perl approveHrFunctionsToQA.pl
#
#    Version    Date       by   Change Description
#       1.0     5/14/2009  MHA  Script derived from approveHrFunctionsToQA.pl for HR.Core.Utilities
#
########################################################################
use Env;

$scripDir       = "C:\\hScripts";
$project     = "AAFES.HR.Core.Utilities.Prod";

# redirect STDOUT and STDERR to approveHrFunctionsToQA$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/approveHrCoreUtilitiesToQA$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN approveHrCoreUtilitiesToQA------------------------------\n");

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

print("-----END approveHrCoreUtilitiesToQA--------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
