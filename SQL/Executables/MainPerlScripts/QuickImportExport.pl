#!C:\perl\bin\perl.exe 
# ImportExport.pl   
# Jerry Richardson 9Nov02
# This script is for importing or exporting files into or out of Harvest.
# This script works with Harvest 5.1+
# See Harref document for description of switches used in this script


print "This program allows you to import or export projects \n";
print "Do you wish to continue? \n";
print"Enter no to stop, or just hit enter to continue: ";
$continue = <STDIN>;
chomp ($continue);
$continue ne "no" ||  goodbye();


top:
print "\n\n\n\n";
print "Do you wish to import or export  \n";
print "\n";
print "Enter import or export (Enter for Default of export): ";
$action = <STDIN>;
chomp ($action);
if ($action eq "") {$action = "export"};

print "\n";
print "     Enter Broker Name (Hit Enter for default) : ";
$broker = <STDIN>;
chomp $broker;
if ($broker eq "") {$broker = "HOODDBOTC86"};



print "Enter Harvest Username (Hit Enter for default) : ";
$username = <STDIN>;
chomp $username;
if ($username eq "") {$username = "harvest"};


print "Enter Harvest Password (Hit Enter for default) : ";
$password = <STDIN>;
chomp $password;
if ($password eq "") {$password = "harvest"};


if ($action eq "import") {import()};
if ($action eq "export") {export()};

print " \n"; 

sub import {
	$another = "go";
	$externalname = "";
	until ($another eq "quit" || $another eq "top") {
	print "\n\n\n\n";
	print "Last project imported: $externalname \n\n";
	print "Enter Harvest project to be imported: ";
	$externalname = <STDIN>;
	chomp $externalname;
	system " himpenv -b \"$broker\" -f \"$externalname\" -usr \"$username\" -pw \"$password\" " ;
	print "\n\n\n\n"; 
	print "Project $externalname imported into Harvest. \n\n";
	print "Enter quit to quit; top to restart;  Hit enter to continue: ";
	$another = <STDIN>;
	chomp($another);
}
if ($another eq "quit") {goodbye()};
if ($another eq "top") {goto top};
}


sub export {
	$another = "go";
	$externalname = "";
	until ($another eq "quit" || $another eq "top") {
	print "\n\n\n\n";
	print "Last project exported: $externalname \n\n";
	print "Enter Harvest project to be exported: ";
	$internalname = <STDIN>;
	chomp $internalname;
	print "\n\n";
	print "Enter name of project to copy project into \n\n";
	print "Hit enter for default: $internalname: ";
	$externalname = <STDIN>;
	chomp $externalname;
	if ($externalname eq "") {$externalname = $internalname};
	system " hexpenv -b \"$broker\" -en \"$internalname\" -f \"$externalname\" -usr \"$username\" -pw \"$password\" ";
	print "\n\n\n\n";
	print "Project $internalname copied into $externalname. \n\n";
	print "Enter quit to quit; top to restart;  Hit enter to continue: ";
	$another = <STDIN>;
	chomp($another);
	}
if ($another eq "quit") {goodbye()};
if ($another eq "top") {goto top};

}



sub goodbye {
print "\n\n\n\n";
print "Goodbye, visit again real soon! \n";
sleep(2);
exit(1);
}
