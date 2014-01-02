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

#print "Enter Broker Name: ";
#$broker = <STDIN>;
#chomp $broker;
$broker = "da1pct1";

#print "Enter Harvest Username: ";
#$username = <STDIN>;
#chomp $username;
$username = "harvest";

#print "Enter Harvest Password: ";
#$password = <STDIN>;
#chomp $password;
$password = "harvest";

#print "Enter file name to be read): ";
#$internalname = <STDIN>;
#chomp $internalname;
$internalname = "report.txt";

#print "Enter Total path for external file to be written ): ";
#$externalname = <STDIN>;
#chomp $externalname;
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
