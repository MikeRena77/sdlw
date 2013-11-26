#!C:\perl\bin\perl.exe 
# ImportExport.pl   
# Jerry Richardson 9Nov02
# This script is for importing or exporting files into or out of Harvest.
# This script works with Harvest 5.1+
# See Harref document for description of switches used in this script


print "This program allows you to import 3 specific projects \n";
print "The 3 projects are Linear, Concurrent, Paralle \n";
print "Do you wish to continue? \n";
print"Enter no to stop, or just hit enter to continue: ";
$continue = <STDIN>;
chomp ($continue);
$continue ne "no" ||  goodbye();



print "\n";
print "     Enter Broker Name: ";

$broker = <STDIN>;
chomp $broker;

print "Enter Harvest Username: ";
$username = <STDIN>;
chomp $username;

print "Enter Harvest Password: ";
$password = <STDIN>;
chomp $password;

$action = "import";

if ($action eq "import") {import()};


print " \n"; 

sub import {
	print "\n\n\n\n";
	system " himpenv -b \"$broker\" -f \"Linear\" -usr \"$username\" -pw \"$password\" " ;
	system " himpenv -b \"$broker\" -f \"Concurrent\" -usr \"$username\" -pw \"$password\" " ;
	system " himpenv -b \"$broker\" -f \"Parallel\" -usr \"$username\" -pw \"$password\" " ;
	# system " himpenv -b \"$broker\" -f \"RBC Application\" -usr \"$username\" -pw \"$password\" " ;
	print "\n\n\n\n"; 
	print "Projects Linear, Concurrent, and Parallel  imported into Harvest. \n\n";
	goodbye();
}








sub goodbye {
print "\n\n\n\n";
print "Goodbye, visit again real soon! \n";
sleep(2);
exit(1);
}
