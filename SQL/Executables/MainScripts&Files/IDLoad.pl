#!C:\perl\bin\perl.exe 
# ImportExport.pl   
# Jerry Richardson 9Nov02
# This script is for importing or exporting files into or out of Harvest.
# This script works with Harvest 5.1+
# See Harref document for description of switches used in this script


print "This program allows you to load a file containing user IDs\n";
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

print "Enter Userlist File (enter for default of $CC500userlist): ";
$CC500userlist = <STDIN>;
chomp $CC500userlist;
if ($CC500userlist eq "") {$CC500userlist = "haruserCC200.lst"};

print "Installing UserIDs \n\n";
   
system " husrmgr -b \"$broker\" -usr \"$username\" -pw \"$password\" -ow \"$CC500userlist\" ";

print "\n\n";
print "IDs Installed \n\n";
goodbye();


sub goodbye {
print "\n\n\n\n";
print "Goodbye, visit again real soon! \n";
sleep(2);
exit(1);
}
