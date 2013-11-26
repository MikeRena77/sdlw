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
#       1.2     7/28/2008  MHA  Rewrote function to internally time-stamp log file
#
########################################################################
 $  = $ARGV[0]; shift;
 $ = $ARGV[0]; shift;
 $scripDir= "C:\\hScripts\\logs";

chomp ($);
chomp ($);
# redirect STDOUT and STDERR to setRead-Only$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/xxxxxxxxxxxx$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN xxxxxxxxxxxx REPORT------------------------------\n");

# check for webPath and target from the args passed in
if ($webPath eq "")
{
  $webPath = "C:\\Inetpub\\wwwroot\\";
}
if ($target eq "")
{
  print "target = $target\n";
  die "You must at least provide a target directory: $!\n";
}
$target = $webPath . "\\" . $target;
print "target = $target\n";

open (FILEXT, "files.ext") or die "Can't find the file $FILEXT $!\n";
@extens = <FILEXT>;
close FILEXT;
LINE: foreach $ext (@extens)
{
  chomp($ext);
  print ("attrib +r /s \"$target\\*.$ext\" \n");
  $error_exit=system("attrib +r /s \"$target\\*.$ext\"");
  if ($error_exit != 0){ print "Error: $error_exit: $! \n"};
  next LINE;
 }

print("-----END xxxxxxxxxxxx REPORT--------------------------------\n");
print scalar localtime;
print "\n";


close STDOUT;
close STDERR;

exit $error_exit;
