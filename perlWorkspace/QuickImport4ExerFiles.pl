#!C:\perl\bin\perl.exe 
# ImportExport.pl   
# Jerry Richardson 9Nov02
# This script is for importing or exporting files into or out of Harvest.
# This script works with Harvest 5.1+
# See Harref document for description of switches used in this script


print "This program allows you to import 4 specific projects \n";
print "The 4 projects are Linear, Concurrent, Parallel, and RBC Application \n";
print "Do you wish to continue? \n";
print"Enter no to stop, or just hit enter to continue: ";
$continue = <STDIN>;
chomp ($continue);
$continue ne "no" ||  goodbye();



print "\n";
print "     Enter Broker Name (Hit Enter for default) : ";
$broker = <STDIN>;
chomp $broker;
if ($broker eq "") {$broker = "hotx-jerry2"};

print "Enter Harvest Username (Hit Enter for default) : ";
$username = <STDIN>;
chomp $username;
if ($username eq "") {$username = "harvest"};

print "Enter Harvest Password (Hit Enter for default) : ";
$password = <STDIN>;
chomp $password;
if ($password eq "") {$password = "harvest"};

import();


sub import {
	print "\n\n\n\n";
	system " himpenv -b \"$broker\" -f \"Linear\" -usr \"$username\" -pw \"$password\" " ;
	system " himpenv -b \"$broker\" -f \"Concurrent\" -usr \"$username\" -pw \"$password\" " ;
	system " himpenv -b \"$broker\" -f \"Parallel\" -usr \"$username\" -pw \"$password\" " ;
	# system " himpenv -b \"$broker\" -f \"RBC Application\" -usr \"$username\" -pw \"$password\" " ;
	print "\n\n\n\n"; 
	print "Projects Linear, Concurrent, Parallel, and RBC Application are  imported into Harvest. \n\n";
	goodbye();
}








sub goodbye {
print "\n\n\n\n";
print "Goodbye, visit again real soon! \n";
sleep(2);
exit(1);
}
