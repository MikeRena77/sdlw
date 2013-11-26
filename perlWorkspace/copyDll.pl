########################################################################
# $Header: copyDll.pl,v 1.0 2008/mm/dd hh:mm:00 mha Exp $
#
# This is a Perl script to copy the DLL generated through OpenMake Meister
#    over to the deployment web site (e.g. Alpha, Beta)
#
#    Arguments are passed in to spell out:
#- $web  =>
#- $target  =>
#
# Command line usage:
#    perl copyDll.pl web target
#
#    Version    Date       by   Change Description
#       1.0     3/19/2008  MHA  Template for future Perl scripting
#       1.1     7/28/2008  MHA  Rewrote function to internally time-stamp log file
#
########################################################################
 $web  = $ARGV[0]; shift;
 $target = $ARGV[0]; shift;
 $scripDir= "C:\\hScripts\\logs";

chomp ($web);
chomp ($target);

# redirect STDOUT and STDERR to copyDll$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/copyDll$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN COPYDLL REPORT------------------------------\n");

# check for webPath and target from the args passed in
if ($web eq "")
{
  print "Usage: perl copyDll.pl web target \n";
	print "    where web is the specific web (e.g. h3_alpha, h3_beta)\n";
	print "    and target is the website folder (e.g. hrReports) \n";
  print "web = $web and\n";
  print "target = $target\n";

        die "You must provide the web name as the first argument: $?: $!\n";
  
}
if ($target eq "")
{
  print "Usage: perl copyDll.pl web target \n";
	print "    where web is the specific web (e.g. h3_alpha, h3_beta)\n";
	print "    and target is the website folder (e.g. hrReports) \n";
  print "web = $web and\n";
  print "target = $target\n";

        die "You must provide the target as the second argument: $?: $!\n";
}

$sourceDir = "c:\\Inetpub\\" . $web . "\\" . "$target\\" . "bin";
$targetDir = "x:\\Inetpub\\" . $web . "\\" . "$target\\" . "bin";

print "source directory = $sourceDir\n";
print "target directory = $targetDir\n";

print("dir x:\\ \n");
system("dir x:\\ \n");

print("xcopy $sourceDir\\hrReports.dll $targetDir\\hrreports.dll /R /Y /C /F \n");
$error_exit=system("xcopy $sourceDir\\hrReports.dll $targetDir\\hrreports.dll /R /Y /C /F ");

print("-----END COPYDLL REPORT--------------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
