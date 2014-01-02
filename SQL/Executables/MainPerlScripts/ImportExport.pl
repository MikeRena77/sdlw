#!C:\perl\bin\perl.exe 
# ImportExport.pl   
# Jerry Richardson 9Nov02
# This script is for importing or exporting files into or outof Harvest.
# See Harref document for description of switches used in this script


print "This program allows you to import or export projects \n";
print "Do you wish to continue? \n";
print"Enter no to stop, or just hit enter to continue: ";
$continue = <STDIN>;
chomp ($continue);
$continue ne "no" ||  goodbye();

print "\n";
print "Do you wish to import or export  \n";
print "\n";
print "Enter import or export  : ";
$action = <STDIN>;
chomp ($action);

print "\n";
print "Enter Broker Name: ";

$broker = <STDIN>;
chomp $broker;

print "Enter Harvest Username: ";
$username = <STDIN>;
chomp $username;

print "Enter Harvest Password: ";
$password = <STDIN>;
chomp $password;

if ($action eq "import") {import()};
if ($action eq "export") {export()};

print " \n"; 

sub import {
	$another = "go";
	until ($another eq "quit") {
	print "Enter Harvest project to be imported      :";
	$externalname = <STDIN>;
	chomp $externalname;
	system " himpenv -b \"$broker\" -f \"$externalname\" -usr \"$username\" -pw \"$password\" " ;
	print " \n"; 
	print "Project $externalname imported into Harvest. \n";
	print "Do another? \n";
	print "Enter quit to stop \n";
	print "Hit enter to continue: \n";
	$another = <STDIN>;
	chomp($another);
}
if ($another eq "quit") {goodbye()};
}


sub export {
	$another = "go";
	until ($another eq "quit") {
	print "Enter Harvest project to be exported      :";
	$internalname = <STDIN>;
	chomp $internalname;
	print "Enter name of project to copy project into:";
	$externalname = <STDIN>;
	chomp $externalname;
	system " hexpenv -b \"$broker\" -en \"$internalname\" -f \"$externalname\" -usr \"$username\" -pw \"$password\" " ;
	print " \n"; 
	print "Project $internalname copied into $externalname. \n";
	print "Do another? \n";
	print "Enter quit to stop \n";
	print "Hit enter to continue: \n";
	$another = <STDIN>;
	chomp($another);
	}
if ($another eq "quit") {goodbye()};
}



sub goodbye {
print "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
print "Goodbye, visit again real soon! \n";
sleep(2);
exit(1);
}

$stop = <STDIN>;

