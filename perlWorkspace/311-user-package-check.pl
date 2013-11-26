#!/usr/bin/perl
#
# user-package-check.pl
#
# PURPOSE:  Prevent a user from checking out files within a package unless
#           the user is the package assignee, or the user is part of the 
#           "Administrator" or "CM Administrator" group.
#
# Usage from UDP: perl.exe -S user-package-check.pl -broker [broker] -usr [user] -pw [password] -pkg "[package]"
#
# NOTE:  [package] may be a list.  This UDP will run on Check Out, so we really
# only expect one entry, and this script is coded accordingly.
#
# REVISION HISTORY
# 	29 OCT 2004	Greg Fischer	Created
# 	29 DEC 2004	Greg Fischer	Re-arrange logic, check for <REQUEST_ID>
# 	04 JAN 2005	Greg Fischer	Remove check for <REQUEST_ID> (moved to
# 	                                its own script)
#

use Getopt::Long;
use File::Spec;

$_ = 1;

GetOptions("broker=s","usr=s","pw=s","pkg=s");

# NOTE:  If a user has changed the default context "Check Out" to "Check Out
# for Update", this gets called on file compares, etc.  But "package" is a 
# blank argument.  So if package isn't passed in, exit 0
if (!$opt_pkg)
{
	exit (0);
}

if (!$opt_broker || !$opt_usr || !$opt_pw)	{exiterror ("Usage:  user-package-check.pl -broker [broker] -usr [user] -pw [password] -pkg \"[package]\"");}

# Create our temporary log files
# Since "tempfile()" doesn't delete the files when its done,
# create the files with a date-timestamp.
my $day = (localtime)[3];
my $month = (JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC)[(localtime)[4]];
my $year = (localtime)[5] + 1900;
my $hour = (localtime)[2];
$hour = sprintf("%02d", $hour);
my $min = (localtime)[1];
$min = sprintf("%02d", $min);
my $sec = (localtime)[0];
$sec = sprintf("%02d", $sec);

my $tempdir = $ENV{TEMP};

my $sqlfile = File::Spec->catfile($tempdir,"sqlfile1-$day$month$year-$hour$min$sec.txt");
my $resultsfile = File::Spec->catfile($tempdir,"resultsfile1-$day$month$year-$hour$min$sec.txt");
my $sqlfile1 = File::Spec->catfile($tempdir,"sqlfile2-$day$month$year-$hour$min$sec.txt");
my $resultsfile1 = File::Spec->catfile($tempdir,"resultsfile2-$day$month$year-$hour$min$sec.txt");
my $sqlfile2 = File::Spec->catfile($tempdir,"sqlfile3-$day$month$year-$hour$min$sec.txt");
my $resultsfile2 = File::Spec->catfile($tempdir,"resultsfile3-$day$month$year-$hour$min$sec.txt");

# Check the package and make sure the user is the package assignee
$opt_pkg =~ s/^\s+\t//;	# Discard first <SPACE TAB> pair
$opt_pkg =~ s/\s+$//;	# Discard any ending whitespace

my $assignok = 0;

# Exit with an error if the user is not the package assignee
# NOTE:  Harvest sometimes "hiccups" and won't run the HSQL correctly,
# causing this script to incorrectly exit with an error.  So we'll try 
# 3 times just to be safe if the HSQL statement fails.

my $errmsg = "";
my $hsqlerrmsg = "";

for (my $iret = -1, my $lcount = 0; $iret !=0 && $lcount < 3; $lcount++)
{
	my $assigneeid = -1;
	open(SQLFILE, "> $sqlfile");
	print SQLFILE "SELECT\n";
	print SQLFILE "assigneeid\n";
	print SQLFILE "FROM\n";
	print SQLFILE "harpackage hp\n";
	print SQLFILE "WHERE\n";
	print SQLFILE "hp.packagename = '$opt_pkg'\n";
	close SQLFILE;

	system("hsql -b $opt_broker -usr $opt_usr -pw $opt_pw -o $resultsfile -f $sqlfile -nh");
	$iret = $?;

	if ($iret == 0)
	{
		open(RESULTS, "< $resultsfile");
		$assigneeid = readline RESULTS;
		close RESULTS;
		$assigneeid =~ s/\s+$//;	# Discard any ending whitespace

		if ($assigneeid == -1)
		{
			# Package has NO assignee
			$assignok = -1;
			$errmsg = "USER PACKAGE CHECK ERROR: Package \"$opt_pkg\" is not assigned!  \nCheck out not allowed!\n";
		}
	}
	else
	{
		# Get the HSQL error message

		open(RESULTS,"< $resultsfile");
		while (<RESULTS>)
		{
			$hsqlerrmsg = $hsqlerrmsg . $_;
		}
		close RESULTS;
	}

	# If OK so far, query to see if the user is the assignee
	if ($iret == 0 && $assignok == 0)
	{
		open(SQLFILE, "> $sqlfile1");
		print SQLFILE "SELECT\n";
		print SQLFILE "username\n";
		print SQLFILE "FROM\n";
		print SQLFILE "haruser hu\n";
		print SQLFILE "WHERE\n";
		print SQLFILE "hu.usrobjid = $assigneeid\n";
		close SQLFILE;

		system("hsql -b $opt_broker -usr $opt_usr -pw $opt_pw -o $resultsfile1 -f $sqlfile1 -nh");
		$iret = $?;

		if ($iret == 0)
		{
			open(RESULTS,"< $resultsfile1");
			$line = readline RESULTS;
			close RESULTS;
			$line =~ s/\s+$//;	# Discard any ending whitespace
			if ($line ne $opt_usr)
			{
				# User is not the package assignee
				$assignok = -1;
				$errmsg = "USER PACKAGE CHECK ERROR: User <$opt_usr> is not the assignee for package \"$opt_pkg\".\nCheck out not allowed!\n";
			}
		}
		else
		{
			# Get the HSQL error message

			open(RESULTS,"< $resultsfile1");
			while (<RESULTS>)
			{
				$hsqlerrmsg = $hsqlerrmsg . $_;
			}
			close RESULTS;
		}
	}
}

# Check if the user is part of the "Administrator" or "CM Administrator" group.
# If so, let the check out take place.
if ($assignok != 0)
{
	for ($iret = -1, $lcount = 0; $iret != 0 && $lcount < 3; $lcount++)
	{
		open(SQLFILE,"> $sqlfile2");
		print SQLFILE "SELECT\n";
		print SQLFILE "usergroupname\n";
		print SQLFILE "FROM\n";
		print SQLFILE "haruser hu, harusergroup hg, harusersingroup hig\n";
		print SQLFILE "WHERE\n";
		print SQLFILE "hu.username = '$opt_usr' AND\n";
		print SQLFILE "hig.usrobjid = hu.usrobjid AND\n";
		print SQLFILE "hg.usrgrpobjid = hig.usrgrpobjid\n";

		system("hsql -b $opt_broker -usr $opt_usr -pw $opt_pw -o $resultsfile2 -f $sqlfile2 -nh");
		$iret = $?;

		if ($iret == 0)
		{
			open(RESULTS,"< $resultsfile2");
			while (<RESULTS>)
			{
				if ($_ =~ /Administrator/)
				{
					#  User is an admin - allow checkout
					$assignok = 0;
					$errmsg = "";
					last;
				}
			}
			close RESULTS;
		}
		else
		{
			# Get the HSQL error message
			open(RESULTS,"< $resultsfile");
			while (<RESULTS>)
			{
				$hsqlerrmsg = $hsqlerrmsg . $_;
			}
			close RESULTS;
		}
	}
}

unlink $sqlfile;
unlink $resultsfile;
unlink $sqlfile1;
unlink $resultsfile1;
unlink $sqlfile2;
unlink $resultsfile2;

#  See if we have an error.
if ($errmsg eq "" and $hsqlerrmsg ne "")
{
	exiterror ($hsqlerrmsg);
}
if ($errmsg ne "")
{
	exiterror ($errmsg);
}

exit(0);

sub exiterror 
{
    print STDERR ("@_\n");
    exit(1);
}
