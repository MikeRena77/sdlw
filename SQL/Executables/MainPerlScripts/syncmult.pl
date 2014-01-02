#!/usr/bin/perl -w
# sync.pl - Tom Cameron
# A script for automating a CCC/Harvest 5.x local or remote synchronous checkout
# usage from UDP: perl sync.pl -b Broker -p ProjectName -st StateName 
# check out the latest versions of all items in State's view, starting in Viewpath
# example: perl -S sync.pl -b "[broker]" -u "[user]" -pw "[password]" -pr "[project]" -s "[state]"
#
# Notes:
# Set up an account with access to the desired checkout process.  Specify username and password below.
# The first checkout process listed in the State is the one that gets invoked.

use Getopt::Long;
use strict;

my ($slashes, $proj, $st, $cop, $vp, $refdir, $rhost, $rusr, $rpw);
use vars qw($opt_broker $opt_usr $opt_pw $opt_project $opt_state);

open STDERR, ">&STDOUT"; # redirect STDERR channel to STDOUT channel
select STDERR; $| = 1;
select STDOUT; $| = 1;

GetOptions('broker=s','project=s','state=s','usr=s','pw=s');

if (!$opt_broker)  { exiterror ("Sync error: Broker Name must be specified.\n"); }
if (!$opt_usr)     { exiterror ("Sync error: User Name must be specified.\n"); }
if (!$opt_pw)      { exiterror ("Sync error: Password must be specified.\n"); }
if (!$opt_project) { exiterror ("Sync error: Project Name must be specified.\n"); }
if (!$opt_state)   { exiterror ("Sync error: State Name must be specified.\n"); }

if(substr($^O, 0, 5) eq 'MSWin')  {
  $slashes="\\";
}
else
{
  $slashes="/";
}

# get the HARVESTHOME value from the environment, and set the path
my $configfile = "$ENV{'HARVESTHOME'}" . $slashes . "sync.cfg";
if (! -f "$configfile") {exiterror("Cannot find $configfile.");}
if (! -r "$configfile") {exiterror("Cannot read $configfile.");}

open (CONFIG, "<$configfile") || exiterror("Can't open $configfile for read.");
while (<CONFIG>) # loop through lines in config file
{
  next if /^#/; # ignore comment lines
  next if /^\s*$/; # ignore blank lines and lines with only whitespace
  ($proj,$st,$cop,$vp,$refdir,$rhost,$rusr,$rpw) = split(/,/);
  if ($proj eq $opt_project && $st eq $opt_state)
  {
    chomp($refdir);
    chomp($rpw) if $rpw;
    unlink "hco.log" || exiterror("Can't delete hco.log.");
    if ($rhost) # remote host is specified - use remote agent for checkout
    {
      print "\nSynchronizing $refdir on $rhost...\n";
      print "hco -o hco.log -b \"$opt_broker\" -rm \"$rhost\" -rusr \"$rusr\" -rpw \"*****\" -usr $opt_usr -pw \"*****\" -en \"$opt_project\" -st \"$opt_state\" -pn \"$cop\" -sy -op pc -r -vp \"$vp\" -cp \"$refdir\" -s \"*\" \n";
      system "hco -o hco.log -b \"$opt_broker\" -rm \"$rhost\" -rusr \"$rusr\" -rpw \"$rpw\" -usr $opt_usr -pw $opt_pw -en \"$opt_project\" -st \"$opt_state\" -pn \"$cop\" -sy -op pc -r -vp \"$vp\" -cp \"$refdir\" -s \"*\" ";
    }
    else # remote host is not specified - use local machine for checkout
    {
      print "\nSynchronizing $refdir...\n";
      print "hco -o hco.log -b \"$opt_broker\" -usr $opt_usr -pw \"*****\" -en \"$opt_project\" -st \"$opt_state\" -pn \"$cop\" -sy -op pc -r -vp \"$vp\" -cp \"$refdir\" -s \"*\" \n";
      system "hco -o hco.log -b \"$opt_broker\" -usr $opt_usr -pw $opt_pw -en \"$opt_project\" -st \"$opt_state\" -pn \"$cop\" -sy -op pc -r -vp \"$vp\" -cp \"$refdir\" -s \"*\" ";
    }
      
    my $exitcode = ($? >> 8);
     
    # display the results
    open (DATA, "<hco.log");
    while (<DATA>) { print; }
    close (DATA);
     
    if ($exitcode != 0)
    {
      if ($rhost)
      {
        print ("\nThe checkout to $refdir on $rhost failed with error code $exitcode.\n\n");
      }
      else
      {
        print ("\nThe checkout to $refdir failed with error code $exitcode.\n\n");
      }
    }

  }

}
close (CONFIG);

print "Checkout complete.\n";
exit(0);

sub exiterror {
    print ("@_\nExiting...\n");
    exit(1);
}
