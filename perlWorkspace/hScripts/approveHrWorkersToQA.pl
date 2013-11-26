########################################################################
# $Header: approveHrWorkersToQA.pl,v 1.0 2008/06/17 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script runs the hap command for the HrWorkers-Prod
#    to approve promotion from Merge to QA
#
# Command line usage:
#    perl approveHrWorkersToQA.pl
#
#    Version    Date       by   Change Description
#       1.0     6/17/2008  MHA  Script to handle approving promotion from Merge to QA after the OM Formal Build
#       1.1     6/26/2008  MHA  Modified for approval process name change
#       1.2     7/28/2008  MHA  Rewrote function to internally time-stamp log file
#
########################################################################
use Env;

$scripDir       = "C:\\hScripts";
$project     = "AAFES.HR.Workers.Prod";

# redirect STDOUT and STDERR to approveHrWorkersToQA$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/approveHrWorkersToQA$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN approveHrWorkersToQA------------------------------\n");

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

print("-----END approveHrWorkersToQA--------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
