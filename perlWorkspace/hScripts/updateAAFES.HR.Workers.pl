########################################################################
# $Header: updateAAFES.HR.Workers.pl,v 1.0 2008/06/11 Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script updates all the AAFES.HR.Workers source files from Harvest
#    using the standard Harvest Check Out for Browse
#
# Command line usage:
#    perl updateAAFES.HR.Workers.pl [state] [project]
#
#    Parameter passed in:
#      $state => which state is the source of our update
#      $project => which project are we targetting (i.e. development or production, etc)
#
#    Version    Date by   Change Description
#      1.0      6/11/2008  MHA   Script written for updating source files on build server
#      1.1      6/13/2008  MHA   Mods to further abstract script for better use of $project
#      1.2      6/18/2008  MHA   Corrections to add $clientpath since it could be different from $project
#      1.3      7/28/2008  MHA   Rewrote function to internally time-stamp log file
#
########################################################################

$scripDir= "C:\\hScripts";
my $state = $ARGV[0]; shift;
my $project = $ARGV[0]; shift;

chomp($state);
chomp($project);
my $clientpath = "C:\\HarvestApps\\$state\\AAFES.HR.Workers";

# redirect STDOUT and STDERR to update$project$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/update$project$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print("update$project.pl \"$state\" \"$project\" \n");

print scalar localtime;
print "\n";
print("-----BEGIN update$project Log------------------------------\n");

print("hco \"*.*\" -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"\\HRWorkers\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
$error_exit=system("hco \"*.*\" -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"\\HRWorkers\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
if ($error_exit != 0){ print "Error: $error_exit: $! \n"};

print("-----END update$project Log--------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
