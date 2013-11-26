########################################################################
# $Header: approveHrReportsToQA.pl,v 1.0 2008/06/04 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script runs the hap command for the HRReports-Prod
#    to approve promotion from Merge to QA
#
# Command line usage:
#    perl approveHrReportsToQA.pl
#
#    Version    Date       by   Change Description
#       1.0     6/05/2008  MHA  Script to handle approving promotion from Merge to QA after the OM Formal Build
#       1.1     7/28/2008  MHA  Rewrote function to internally time-stamp log file
#
########################################################################
use Env;

$scripDir       = "C:\\hScripts";

# redirect STDOUT and STDERR to approveHrReportsToQA$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/approveHrReportsToQA$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN approveHrReportsToQA------------------------------\n");

open (ENVLIST, "$scripDir\\pkg") or die "Can't open $scripDir\\pkg: $!\n";
ITEM: while (<ENVLIST>)
    {
        $/ = " \n";
        $package = $_;
        chomp ($package);
        $ENV{'PACKAGE'} = $package;
        
        print ("hap \"$package\" -b \"PRODSWA\" -en \"HR-Reports-Prod\" -st \"Merge\" -pn \"Approve Package for Promotion to QA\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
        $error_exit=system("hap \"$package\" -b \"PRODSWA\" -en \"HR-Reports-Prod\" -st \"Merge\" -pn \"Approve Package for Promotion to QA\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
        if ($error_exit != 0){ print "Error: $error_exit\n"};
        
        next ITEM;
    }
close (ENVLIST);

print("-----END approveHrReportsToQA--------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
