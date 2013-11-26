########################################################################
# $Header: xxxxxxxxxxxx.pl,v 1.0 2008/mm/dd hh:mm:00 mha Exp $
#
# This is a template for future Perl scripts originally derived from one
#    of the original automation scripts
#
#    Arguments are passed in to spell out:
#- $  =>
#- $  =>
#
#
# Command line usage:
#    perl xxxxxxxxxxxx.pl $ $
#
#    Version    Date       by   Change Description
#       1.0     m/dd/2008  MHA  Template for future Perl scripting
#       1.1     3/18/2008  MHA  Added description for error-handling
#       1.2    7/28/2008  MHA  Rewrote function to internally time-stamp log file
#
########################################################################
 use Env;
  
 $trial  = $ARGV[0]; shift;
 $trial2 = $ARGV[0]; shift;
 $scripDir= "C:\\hScripts\\logs";

chomp ($trial);
chomp ($trial2);
# redirect STDOUT and STDERR to setRead-Only$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logStamp$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

system("echo %DATE% %TIME%");

$myDate = $ENV{'DATE'};
$myTime = $ENV{'TIME'};
# Let's just use the simple built-in Perl time
print scalar localtime;
print "\n";

print("-----HereWeGo--------------------------------\n");
$logStamp=test.log;
print "logStamp = $logStamp\n";
system("echo %DATE% %TIME%");
open TSTOUT, ">$scripDir/$logstamp";
print TSTOUT ("myDate = $myDate\n");
print TSTOUT ("myTime = $myTime\n");
print TSTOUT ("Did this work?\n");
close TSTOUT;


close STDOUT;
close STDERR;

exit $error_exit;
