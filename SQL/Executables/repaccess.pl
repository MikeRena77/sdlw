###################################################################################################
#       Programmer:-    Vibhav Mehrotra
#       File:-          RepAccess.pl
#       Function:-      To display the repository access.
#       Command line:-  perl repaccess.pl [user]
#	Setup:-		This script will run as a stand alone UDP.
#	Requirements:-	The script requires the user to enter a valid repository name (Case Sensitove).
#	Perl:-		/export/local/bin/perl
####################################################################################################

####################################################################################################
### Defining Variables. 
####################################################################################################

$oracle_user="tescocm";		# Oracle read only account.
$oracle_passwd="harvest";	# Password for the read only account.
$sqlplus="sqlplus -s $oracle_user\/$oracle_passwd";	# Oracles SQLPlus.
@replist="";			# Result of the sql script
$reppath="";
$oldreppath="";			# Old Repository Path
$repaccess="";
$user = "$ARGV[0]";		# User executing the harvest process.
shift;				# Shifting to the repository name
$repname = "";
foreach $i (0 .. $#ARGV) {
$repname = "$repname $ARGV[$i]"; # Repository Name
	}
$repname = substr($repname,1);		# Remove the extra space at the end

$sqlfile = "\/tmp\/$user.sql";

####################################################################################################
# Setting the UNIX variables.
system "DISPLAY=";
system "OPENWINHOME=\/usr\/openwin";
system "export OPENWINHOME DISPLAY";

####################################################################################################
### Check to see if the repository name is valid.
####################################################################################################

if (length($repname) <= 0) {

print "Please enter a valid repository name (case sensitive) in the \"Additional Parameter\" field.\n\n";
exit 1;
}
else { # We have a repository name passed

####################################################################################################
### Creating the SQL file which will get us the required values to link the form to the package

open(sqlf,">$sqlfile");
print sqlf "set pagesize 0;\nset linesize 100;\nset trimspool on;\nset heading off;\n";
print sqlf "set headsep off;\nset verify on;";
print sqlf "\nset feedback off;\n--set termout off;\n";
print sqlf "select p.pathfullname as \"Repository Path\", 
LTRIM(RTRIM(ug.usergroupname,\' \'),\' \') as \"Edit Access\"
from harpathfullname p, harrepository r, harusergroup ug, haritempath ip
where
ip.pathobjid = p.pathobjid and
ip.repositobjid = r.repositobjid and
r.repositname = \'$repname\'
   and mod( trunc( ascii( substrb( ip.edititempath,trunc( (ug.usrgrpobjid-1) / 7 ) + 1, 1)) / power(2, mod( ug.usrgrpobjid - 1, 7))), 2) = 1
order by p.pathfullname;\nexit;\n";

close(sqlf);

####################################################################################################
### Running the SQL statement through Oracle SQLPlus

@replist = `$sqlplus \@$sqlfile`;

####################################################################################################
### Print the result to the session log.

print "\nThe Edit Access for the $repname Repository is:\n\n";

$a = 0;

while ($reppath = "$replist[$a]") {

 chomp($reppath);

 if ($oldreppath eq $reppath) {
	 $repaccess = "$replist[$a+1]";
	  chomp($repaccess);
	 $junk = "$replist[$a+2]";
	 print "\t\t$repaccess\n";
	 shift @replist;
	 shift @replist;
	 shift @replist;
        }
 else {

	$oldreppath = "$reppath";
	print "\n------------------------------------------------------------\n";
	print "\nREPOSITORY PATH: $reppath\n\n";

	 $repaccess = "$replist[$a+1]";
	  chomp($repaccess);
	 $junk = "$replist[$a+2]";
	 print "\t\t$repaccess\n";
	 shift @replist;
	 shift @replist;
	 shift @replist;
        }



} # End of the For Loop
exit 0;

}

unlink($sqlfile);
