#!C:\perl\bin\perl.exe 
# HarvestSecurity.pl   
# Jerry Richardson 8Nov02
# Perl Script for reading or writing Harvest Security Configurations.
#This script will only work for Harvest 5.1.1 or later.  Previous Harvest versions do not support
#CLI for password security.
# See Harref document for description of switches used in this script
#Writing the security configuration requires a file similar to the following:
=BEGIN
		# Harvest Password Policy Configuration changes by Jerry Richardon
		# Password Policy Last Modified on 8Nov02
		AllowChangeAfterExpire = true
		AllowUsernameAsPassword = true
		ExpirationWarningAge = 0
		MaxFailAttemptBeforeLockout = 0
		MaximumPasswordAge = 10
		MaxiumumRepeatableCharacter = 0
		MinimumLowercaseCharacter = 0
		MinimumNonalphanumericCharacter = 0
		MinimumNumericCharacter = 0
		MinimumPasswordAge = 0
		MinimumPasswordLength = 6
		MinimumUppercaseCharacter = 0
		PasswordCountBeforeReusable = 0
		ExpirationWarningAge=1
		AllowUsernameAsPassword=true
		# User Level Overrides
		harvest.passwordneverexpire=true
		jkr.passwordneverexpire=true
		admin01.passwordchangenextlogon=true
		admin02.passwordchangenextlogon=true			
=cut



print "Caution, this program will either copy harvest security configuration or change it \n";
print "Do you wish to continue? \n";
print"Enter no to stop, or just hit enter to continue: ";
$continue = <STDIN>;
chomp ($continue);
$continue ne "no" ||  goodbye();


top:
print "\n\n\n\n";
print "Do you wish to copy the harvest security configuration or change it? \n";
print "\n";
print "Enter change or copy (Enter for Default of copy): ";
$action = <STDIN>;
chomp ($action);
if ($action eq "") {$action = "copy"};

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

if ($action eq "change") {change()};
if ($action eq "copy") {copy()};

print " \n"; 

sub change{
	print "\n\n";
	print "Enter policy file name to be written into Harvest: ";
	$externalname = <STDIN>;
	chomp $externalname;
	print "\n\n";
	system "hppolset  -b \"$broker\" -usr \"$username\"  -pw \"$password\"  -f  \"$externalname\" " ;
	print "\n\n\n\n";
	print "Project Configuration $externalname copied into Harvest. \n\n";
	goodbye ();
}



sub copy{
	print "\n\n";
	print "Enter name of file to copy Configuration into: ";
	$externalname = <STDIN>;
	chomp $externalname;
	print "\n\n";
	system "hppolget  -b \"$broker\" -usr \"$username\"  -pw \"$password\"  -f  \"$externalname\" ";
	print "\n\n\n\n";
	print "Project Configuration copied into $externalname. \n\n";
	goodbye ();
}



sub goodbye {
print "\n\n\n\n";
print "Goodbye, visit again real soon! \n";
sleep(4);
exit(1);
}
