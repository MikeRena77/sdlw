########################################################################
# $Header: approveHrWorkers2k8ToQA.pl,v 1.0 2009/01/29 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script runs the hap command for the HrWorkers2k8-Prod
#    to approve promotion from Merge to QA
#
# Command line usage:
#    perl approveHrWorkers2k8ToQA.pl
#
#    Version    Date       by   Change Description
#       1.0     1/29/2009  MHA  Script to handle approving promotion from Merge to QA after the OM Formal Build
#
########################################################################
use Env;

$scripDir       = "C:\\hScripts";
$project     = "AAFES.HR.Workers.2k8.Prod";

# redirect STDOUT and STDERR to approveHrWorkers2k8ToQA$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/approveHrWorkers2k8ToQA$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN approveHrWorkers2k8ToQA------------------------------\n");

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

print("-----END approveHrWorkers2k8ToQA--------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
