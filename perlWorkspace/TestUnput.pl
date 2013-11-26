#!E:\perl\bin\perl.exe 
# UserReport.pl
# 
print "Input Standard SQL search request: " ;
$sql = <STDIN>;
#chomp($sql);
print "\n";
print "$sql";


$report = ">report.txt";
open (OUTPUT, $report);
print OUTPUT "$sql";
close (OUTPUT);


$stop = <STDIN>;