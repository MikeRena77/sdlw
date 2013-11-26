########################################################################
# $Header: takeHrSnapShots.pl,v 1.0 2008/06/04 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script runs the htakess command for the HR projects
#
# Command line usage:
#    perl takeHrSnapShots.pl
#
#    Version    Date        by   Change Description
#       1.0     11/02/2009  MHA  Script to take Harvest Snapshots for a Project list ("prj")
#
########################################################################
use Env;

$scripDir       =   "C:\\hScripts";
$project        =   "";
$snapshot       =   "";
# print $scripDir;
# redirect STDOUT and STDERR to takeHrSnapShots$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/takeHrSnapShots$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN takeHrSnapShots$$------------------------------\n");

open (ENVLIST, "$scripDir\\prj") or die "Can't open $scripDir\\prj: $!\n";
ITEM: while (<ENVLIST>)
    {
        $/ = "\n";
        $project = $_;
        chomp ($project);
        $ENV{'PROJECT'} = $project;
        ($second, $minutes, $hours, $monthdays, $monthOffSet, $yearOffSet, $weekdays, $yeardays, $daylightSavings) = localtime();
        $years      =   1900 + $yearOffSet;
        $months     =   1   +   $monthOffSet;
        $timetsamp  =   $years . "-" . $months . "-" . $monthdays . "_" . $hours . $minutes;
        print $timetsamp "\n";
        $snapshot   =   $project . "_" . $timetsamp;
        print $snapshot "\n";
        print             ("htakess -b \"PRODSWA\" -en \"$project\" -st \"Alpha\" -ss \"$snapshot\" -ve -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
        $error_exit=system("htakess -b \"PRODSWA\" -en \"$project\" -st \"Alpha\" -ss \"$snapshot\" -ve -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts ");
        if ($error_exit != 0){ print "Error: $error_exit => $! $?  \n\n"};
        
        next ITEM;
    }
close (ENVLIST);

print("-----END takeHrSnapShots$$--------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
