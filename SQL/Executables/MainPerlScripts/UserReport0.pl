#!E:\perl\bin\perl.exe 
# UserReport.pl
# 
print "Input Standard SQL search request: " ;
$sql = <STDIN>;
#chomp($sql);

$report = ">report.txt";
open (OUTPUT, $report);
print OUTPUT "$sql";
close (OUTPUT);

print "Enter Broker Name: ";
$broker = <STDIN>;
chomp $broker;


print "Enter Harvest Username: ";
$username = <STDIN>;
chomp $username;


print "Enter Harvest Password: ";
$password = <STDIN>;
chomp $password;



$internalname = "report.txt";


$externalname = "output.txt";

print " \n"; 


system "hsql  -t -b \"$broker\" -usr \"$username\"  -pw \"$password\"  -f  \"$internalname\"  -o \"$externalname\"";


open(REPORT, $externalname);
chomp(@file = <REPORT>);
foreach $line (@file) {
	print "$line \n";
}
close (REPORT);


$stop = <STDIN>;
