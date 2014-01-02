#k:\perl\bin\perl
# harlabinstall.pl
# This perl script prompts the user for Broker Name, Harvest Administrator
# Username, Harvest Administrator Password, Course Number, and Lab File Directory.
# Based on the information provided, the script will build the necessary Harvest 
# Projects, Usernames, and User Groups.
#
# Version History:
#   Date  		  Description		   	 			Author	 		Version
#	7/21/02		  Corrected Student11 Project Access		   	Trey White		5.1.0.0
#	6/5/02		  Incorporated 5.1 Command Lines to load	   	Trey White		5.1.0.0
#				  Repository, Connect Baselines, and correct
#				  Project Access issues
#	3/25/02		  Converted from batch file to Perl script 	   	Trey White		5.0.2.0
#

 
print "Enter Broker Name: ";
$broker = <STDIN>;
chomp $broker;

print "Enter Harvest Administrator Username: ";
$username = <STDIN>;
chomp $username;

print "Enter Harvest Administrator Password: ";
$password = <STDIN>;
chomp $password;

print "Enter Harvest Course Number (ex. CC500 or CC510): ";
$coursenum = <STDIN>;
chomp $coursenum;

print "Enter Location of Project Files (ex. c:\\labfiles): ";
$hardirectory = <STDIN>;
chomp $hardirectory;
opendir (NT, $hardirectory) || die "Cannot opendir $hardirectory: $!";

$repositoryname = "RBC Repository";
$repositoryfiles = "$hardirectory\\work";
$CC500userlist = "haruserCC500.lst";
$CC510userlist = "haruserCC510.lst";

print " \n"; 

chdir($hardirectory) || die "Invalid directory $hardirectory: $! ";

if ($coursenum eq "CC500") 
  {
  print "Installing Project Template \n";
  print " \n";
    
  system " himpenv -b \"$broker\" -f \"RBC Application Template.har\" -usr \"$username\" -pw \"$password\" " ;
  
  print "Installing Administrator Usernames for Course Number $coursenum \n";
  print " \n";
   
  system " husrmgr -b $broker -usr $username -pw $password -ow $CC500userlist ";
  
    } 
elsif ($coursenum eq "CC510") 
  {
  print "Do you want to load the Repository (ex. yes or no): ";
  $loadrepository = <STDIN>;
  chomp $loadrepository;

  if ($loadrepository eq "yes")
  {
    system " hlr -b \"$broker\" -cp \"$repositoryfiles\" -rp \"$repositoryname\" -f * -r -usr \"$username\" -pw \"$password\" ";
  }
  foreach (sort <*.har>) 
    { 
	$length = index($_, ".har");
	$projectname = substr($_, 0, $length);
    print "Installing Project $projectname for Course Number $coursenum \n";
	print " \n";
	system " himpenv -b \"$broker\" -f \"$projectname\" -usr \"$username\" -pw \"$password\" " ;
	
	$projecttype = index ($projectname, "2.0");
	if ($projecttype eq -1)
	{
	  system " hcbl -b \"$broker\" -en \"$projectname\" -rp \"$repositoryname\" -add -rw -usr \"$username\" -pw \"$password\" ";
	}
	
	print " \n";
    }
  print "Installing End User Usernames for Course Number $coursenum \n";
  print " \n";
  system " husrmgr -b \"$broker\" -usr \"$username\" -pw \"$password\" -ow $CC510userlist ";
  }
else
  {
  print "Invalid Course Number. Please retry. \n";
  print " \n"; 
  }