#!E:\perl\bin\perl.exe 
# UserReport.pl
# 
use warnings;


$broker = "hotx-jerry2";
$username = "harvest";
$password = "harvest";
$internalname = "report.txt";
$externalname = "output.txt";

print " \n\n"; 



system "hsql -t -b \"$broker\" -usr \"$username\"  -pw \"$password\"  -f  \"$internalname\"  -o \"$externalname\"  ";



open(REPORT, $externalname);
chomp(@file = <REPORT>);
foreach $line (@file) {
	print "$line \n";
}
close (REPORT);


my $stop = <STDIN>;