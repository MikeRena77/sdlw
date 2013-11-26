#!/usr/bin/perl -w
# ----------------------------------------------------------------------
# Filename    : processHBroker.pl
# Description : This script has effectively, 2 modes, the first, when
#               executed with '-f', it will mimic the standard
#               UNIX tail (with -f) and top program using Perl on the
#               YYYYMMDDHBroker.log file and processes the entries in real
#               time to find the current list of active users.
#               When called as processHBroker.pl, it just processes the whole
#               YYYYMMDDHBroker.log file to find when users have last logged
#               in and when they logged out (if they have logged out that
#               is!). This way of running it is more as an end-of-day job.
# Notes       : The format of a login is expected to be -
#                   - Default: On User register -   HH:MM:SS
#                   From  : /pt_HClient://<machine>/<number>
#                   User  : <Harvest ID>
#               The format of the log out comes as -
#                   - On Process Dies -     HH:MM:SS
#                   Process: /pt_HClient://<machine>/<number>
#               Note that the values for <machine> and <number> are the
#               same.
# Usage       : See Usage.
# Created     : Kevin Lew 2003/11/12
# Modified    : Kevin Lew 2003/11/13
#               Added timestamp.
# ----------------------------------------------------------------------

use strict;

use Time::localtime;

$| = 1;

#############
# VARIABLES #
#############
my $gBrokerLog = shift;   # $1
my $gDoTail    = 0;
my $gProgName  = "$0";
my %gUserIn    = ();
my %gUserList  = ();
my %gUserOut   = ();

###############
# SUBROUTINES #
###############
# INPUTS: $1 = "tail" - Display a real time list of users currently logged in
#         $1 = "all"  - Display all logins and logouts
sub DisplayUsers
{
    my $isTail  = shift;
    my $key     = "";
    my %sortList= ();   # Create a sorted list by login time.

    foreach ( keys %gUserList )
    {
        # Use the login timestamp as the key to the sort list. This way we
        # can sort on time the user logged in...
        $key = $gUserIn{$_};

        if ( exists $gUserOut{$_} )
        {
            $sortList{"$key"} = sprintf "%-10s %-10s %-15s %s",
                      $gUserList{$_}, $gUserIn{$_}, $gUserOut{$_}, $_;
        }
        else
        {
            if ( $isTail =~ /tail/ )
            {
                $sortList{"$key"} = sprintf "%-10s %-10s %s",
                      $gUserList{$_}, $gUserIn{$_}, $_;
            }
            else
            {
                $sortList{"$key"} = sprintf "%-10s %-10s Still Logged In %s",
                      $gUserList{$_}, $gUserIn{$_}, $_;
            }
        }
    }

    if ( $isTail =~ /tail/ )
    {
        system("clear");
        my $tm = localtime;

        printf "USER       IN TIME    RT CLIENT                     (Updated - %02d:%02d:%02d)\n", $tm->hour, $tm->min, $tm->sec;
        print "========== ========== ==================================================\n";
    }
    else
    {
        print <<EOT;
USER       IN TIME    OUT TIME        RT CLIENT
========== ========== =============== ========================================
EOT
    }

    foreach ( sort keys %sortList )
    {
        print "$sortList{$_}\n";
    }

    if ( $isTail =~ /tail/ )
    {
        printf "\nTotal Number of Users: %d\n", scalar keys %sortList;
    }
}

sub ProcessBroker
{
    local *BLOG = shift;

    my $client = "";
    my $cTime  = "";
    my @fields = ();
    my $key    = "";
    my $machine= "";

    while (<BLOG>)
    {
        # - Default: On User register -   07:27:51
        # From  : /pt_HClient://harvest/13739
        # User  : NCON7KL
        if ( /On User register/ )
        {
            @fields = split;
            $cTime = $fields[$#fields];
            # Grab the next line since it should be the "From:" line...
            $_ = <BLOG>;

            if ( /From  :/ )
            {
                @fields = split;
                $machine= $fields[$#fields];
            }
            else
            {
                # If we're here, we didn't find what we're looking for
                # so exit out and look for the next line...
                $cTime   = "";
                $machine = "";
                next;
            }

            # Grab the next line since it should be the "User:" line...
            $_ = <BLOG>;

            if ( /User  :/ )
            {
                @fields = split;

                # HASH key = machine name.
                $gUserList{$machine} = "$fields[$#fields]";
                $gUserIn{$machine} = "$cTime";
            }
            else
            {
                # If we're here, we didn't find what we're looking for
                # so exit out and look for the next line...
                $cTime   = "";
                $machine = "";
                next;
            }
        }

        # - On Process Dies -     01:21:20
        # Process: /pt_HClient://harvest/13739
        if ( /On Process Dies/ )
        {
            @fields = split;
            $cTime = $fields[$#fields];

            # Grab the next line since it should be the "Process:" line...
            $_ = <BLOG>;
            @fields = split;

            if ( exists $gUserList{$fields[$#fields]} )
            {
                # HASH key = machine name.
                $gUserOut{$fields[$#fields]} = "$cTime";
            }
        }

        if ( /---- Started ----/ )
        {
            @fields = split;
            $cTime = $fields[3];
            $key = sprintf "*** SERVER STARTED \@ %s ***", $cTime;
            $gUserList{$key} = "ALERT";
            $gUserOut{$key} = "$cTime";
            $gUserIn{$key} = "$cTime";
        }

        if ( /---- stopped ----/ )
        {
            @fields = split;
            $cTime = $fields[3];
            $key = sprintf "*** SERVER STOPPED \@ %s ***", $cTime;
            $gUserList{$key} = "ALERT";
            $gUserOut{$key} = "$cTime";
            $gUserIn{$key} = "$cTime";
        }
    }

    DisplayUsers("all");
}

sub TailBroker
{
    local *BLOG = shift;

    my $cTime   = "";
    my @fields  = ();
    my $machine = "";

    # Note that this will start processing from the beginning of the file.
    # So if the file is particularly parge, there maybe a delay as to when
    # the first screen of information will appear...
    for (;;)
    {
        while (<BLOG>)
        {
            if ( /On User register/ )
            {
                @fields = split;
                $cTime = $fields[$#fields];
            }

            if ( /From  :/ )
            {
                @fields = split;
                $machine= $fields[$#fields];
            }

            if ( /User  :/ )
            {
                @fields = split;

                $gUserList{$machine} = $fields[$#fields];
                $gUserIn{$machine} = $cTime;
            }

            if ( /On Process Dies/ )
            {
                @fields = split;
                $cTime = $fields[$#fields];
            }

            if ( /^Process:/ )
            {
                @fields = split;
                delete $gUserList{$fields[$#fields]}
                    if ( exists $gUserList{$fields[$#fields]} );
                delete $gUserIn{$fields[$#fields]}
                    if ( exists $gUserIn{$fields[$#fields]} );
            }
        }
        DisplayUsers("tail");
        sleep 10;
    }
}

sub Usage
{
    print <<EOT;

Usage: $gProgName [-f] <YYYYMMDDHBroker.log>

where -f will give a "real-time" tally of who is logged
         in and who has recently logged out.

EOT

    exit(1);
}

################
# MAIN PROGRAM #
################
if ( "$gBrokerLog" eq "-f" )
{
    $gDoTail = 1;
    $gBrokerLog = shift;
}

Usage unless ( "$gBrokerLog" );

open(BLOG, "< $gBrokerLog") or
    die "Cannot open file ($gBrokerLog) for reading: $!\n";

( $gDoTail ) ? TailBroker(\*BLOG) : ProcessBroker(\*BLOG);

close(BLOG);
