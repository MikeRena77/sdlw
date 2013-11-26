#!/usr/bin/perl
# sync.pl - Tom Cameron
# A script for automating a CCC/Harvest 5.x synchronous checkout
# usage from UDP: perl.exe sync.pl -b Broker -p ProjectName -s StateName -v Viewpath -d Directory
# check out the latest versions of all items in State's view, starting in Viewpath
# example: perl.exe -S sync.pl -b "[broker]" -p "[project]" -s "[state]" -v "\Sample Repository" -d "C:\app1\build"
#
# Notes:
# Set up an account with access to the desired checkout process.  Specify username and password below.
# The first checkout process listed in the State is the one that gets invoked.

use Getopt::Long;

# specify the username and password for a Harvest account
$username = harvest;
$userpass = harvest;

$_ = 1;

GetOptions('broker=s','project=s','state=s','vp=s','dir=s');

if (!$opt_broker)  { exiterror ("Sync error: Broker Name must be specified.\n"); }
if (!$opt_project) { exiterror ("Sync error: Project Name must be specified.\n"); }
if (!$opt_state)   { exiterror ("Sync error: State Name must be specified.\n"); }
if (!$opt_vp)      { exiterror ("Sync error: Viewpath must be specified.\n"); }
if (!$opt_dir)     { exiterror ("Sync error: Directory must be specified.\n"); }

chdir $opt_dir || exiterror("Can't cd to $opt_dir.");

# delete the log file rather than appending to it
unlink "hco.log" || exiterror("Can't delete hco.log.");

print "Synchronizing $opt_dir...\n";

# do the checkout.  Leaves hco.log in the target dir
system "hco -o hco.log -b \"$opt_broker\" -usr $username -pw $userpass -en \"$opt_project\" -st \"$opt_state\" -sy -op pc -r -vp \"$opt_vp\" -s \"*\" ";

# display the results
open (DATA, "<hco.log");
while (<DATA>) { print; }
close (DATA);

print "Checkout complete.\n";
exit(0);

sub exiterror {
    print ("@_\nExiting...\n");
    sleep (10);
    exit(1);
}
