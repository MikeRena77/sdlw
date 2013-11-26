########################################################################
# $Header: updateBane.pl,v 1.0 2008/03/03 12:28:00 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script updates updates Bane under the direction
#    of OpenMake using the r12 Harvest Check Out for Browse with "-replace all"
#
# Command line usage:
#    perl updateHrReports.pl [state] website
#
#    Parameter passed in:
#      $state = state => which state is the source of our update
#      $website = website => which website are we targetting (i.e. hrCRB, hrPMW, etc)
#
#    Version    Date by   Change Description
#      1.0      10/05/2009  MHA   Script written for updating source files on Bane
#      1.1      10/09/2009  MHA   Script revised to provide coverage for all states - on both BANE  and GALACTUS
#
########################################################################

$scripDir= "C:\\hScripts";
my $project = $ARGV[0]; shift;
my $state = $ARGV[0]; shift;
my $viewpath = $ARGV[0]; shift;
my $website = $ARGV[0]; shift;

chomp($project);
chomp($state);
chomp($viewpath);
chomp($website);

# redirect STDOUT and STDERR to updateBane$state$$.log

open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/updateBane$state$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print("updateBane.pl \"$project\" \"$state\" \"$viewpath\" \"$website\" \n");

print scalar localtime;
print "\n";
print("-----BEGIN UPDATE BANE------------------------------\n");

if ($state eq "Alpha")
    { 
        $machine =   "BANE";
        $web     =   "h3_alpha";
    }
if ($state eq "Beta")
    { 
        $machine =   "BANE";
        $web     =   "h3_beta";
    }
if ($state eq "QA")
    { 
        $machine =   "BANE";
        $web     =   "h3_qa";
    }

if ($state eq "Gold")
    { 
        $machine =   "GALACTUS";
        $web     =   "h3";
    }
    
print("MACHINE: \"$machine\" WEB: \"$web\" \n");

print("hco \"*.*\" -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"\\$viewpath\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"c:\\inetpub\\$web\\$website\" -pn \"Check Out for Browse\" -rm $machine -eh \"%CA_SCM_HOME%\\hsync.dfo\" -er \"%CA_SCM_HOME%\\$machine.dfo\" -oa \">>&STDOUT\" -wts \n");
$error_exit=system("hco \"*.*\" -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"\\$viewpath\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"c:\\inetpub\\$web\\$website\" -pn \"Check Out for Browse\" -rm $machine -eh \"%CA_SCM_HOME%\\hsync.dfo\" -er \"%CA_SCM_HOME%\\$machine.dfo\" -oa \">>&STDOUT\" -wts");
if ($error_exit != 0){ print "Error: $error_exit: $! | $? \n"};
print("-----END UPDATE BANE--------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
