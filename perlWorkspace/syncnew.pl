#!/usr/bin/perl
# sync.pl - Tom Cameron
# A script for automating a CCC/Harvest 5.x synchronous checkout
# usage from UDP: perl.exe sync.pl -b Broker -p ProjectName -s StateName -v Viewpath -d Directory
# check out the latest versions of all items in State's view, starting in Viewpath
# example: perltest.exe -S sync.pl -b "[broker]" -pr "[project]" -s "[state]" -v "\Sample Repository" -d "C:\app1\build" -usr "[user]" -pw "[password]"
# Modification of original Tom Cameron script by Jerry Richardson
# In order to work Oracle Password option must be set:
#(update hartableinfo set SYSVARPW='Y'; 
#commit;)
# Notes:
# The first checkout process listed in the State is the one that gets invoked.

use Getopt::Long;


$_ = 1;

GetOptions('broker=s','project=s','state=s','vp=s','dir=s', 'usr=s', 'pw=s');

if (!$opt_broker)  { exiterror ("Sync error: Broker Name must be specified.\n"); }
if (!$opt_project) { exiterror ("Sync error: Project Name must be specified.\n"); }
if (!$opt_state)   { exiterror ("Sync error: State Name must be specified.\n"); }
if (!$opt_vp)      { exiterror ("Sync error: Viewpath must be specified.\n"); }
if (!$opt_dir)     { exiterror ("Sync error: Directory must be specified.\n"); }
if (!$opt_usr)      { exiterror ("Sync error: Username must be specified.\n"); }
if (!$opt_pw)     { exiterror ("Sync error: Password must be specified.\n"); }

chdir $opt_dir || exiterror("Can't cd to $opt_dir.");

# delete the log file rather than appending to it
unlink "hco.log" || exiterror("Can't delete hco.log.");

print "Synchronizing $opt_dir...\n";
print "hco -o hco.log -b \"$opt_broker\" -rm \"$rhost\" -rusr \"$rusr\" -rpw \"*****\" -usr $opt_usr -pw \"*****\" -en \"$opt_project\" -st \"$opt_state\" -pn \"$cop\" -sy -op pc -r -vp \"$vp\" -cp \"$refdir\" -s \"*\" \n";
# do the checkout.  Leaves hco.log in the target dir
system "hco -o hco.log -b \"$opt_broker\" -usr \"$opt_usr\" -pw \"$opt_pw\" -en \"$opt_project\" -st \"$opt_state\" -sy -op pc -r -vp \"$opt_vp\" -s \"*\" ";

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
