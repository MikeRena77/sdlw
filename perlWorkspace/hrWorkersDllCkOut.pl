    ########################################################################
    # $Header: hrWorkersDllCkOut.pl,v 1.0 2008/06/17 mha Exp $
    #
    # Written
    #    by Michael Andrews (MHA)
    #    for AAFES HQ
    #
    #  This Perl script performs the Harvest Check Out for Update on the AAFES.HR.Workers.dll file
    #  This script Checks Out the DLL for Update before running the OpenMake build
    #  The package name is read from the temporary file PKG
    #
    #  Command line usage:
    #    perl hrWorkersDllCkOut.pl [state] [bldDir] [package] 
    #
    #    Parameters passed in:
    #      $state = state => which state is the source of our update
    #      $bldDir = bldDir => which bldDir are we targetting (i.e. QA, etc)
    #      $package = [package] => the Harvest work package
    #
    #    Version    Date       by   Change Description
    #      1.0      6/17/2008  MHA  Script written in Perl to Check Out for Update the DLL before build
    #      1.1      6/26/2008  MHA  Mod because difference between $state and $bldDir is too confusing
    #      1.2      7/28/2008  MHA  Rewrote function to internally time-stamp log file
    #
    ########################################################################
    my $scripDir    = "C:\\hScripts";
    my $state       = $ARGV[0]; shift;
    my $bldDir         = $ARGV[0]; shift;
    my $package     = $ARGV[0]; shift;

    chomp($bldDir);
    chomp($state);
    chomp($package);
    my $project     = "AAFES.HR.Workers.Prod";
    my $viewpath    = "HRWorkers";
    my $clientpath  = "c:\\HarvestApps\\$state\\AAFES.HR.Workers";
    
    # redirect STDOUT and STDERR to hrWorkersDllCkOut$$.log
    open SAVEOUT, ">&STDOUT";
    open SAVEERR, ">&STDERR";

    open STDOUT, ">$scripDir/logs/hrWorkersDllCkOut$$.log" or die "Can't redirect stdout $!\n";
    open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

    select STDERR; $| = 1;     # make unbuffered
    select STDOUT; $| = 1;     # make unbuffered

    print scalar localtime;
    print "\n";
    print("-----BEGIN AAFES.HR.Workers.dll CHECK OUT REPORT------------------------------\n");
    open (ENVLIST, "$scripDir\\pkg") or die "Can't open $scripDir\\pkg: $!\n";
    ITEM: while (<ENVLIST>)
    {
        $/ = " \n";
        $package = $_;
        chomp ($package);
        $ENV{'PACKAGE'} = $package;
        next ITEM;
    }
    close (ENVLIST);

        print ("hco \"bin\\Release\\AAFES.HR.Workers.dll\" -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"\\$viewpath\" -p \"$package\" -up -replace all -ced -op pc -cp \"$clientpath\" -pn \"Engineering Build CheckOut\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
        $error_exit=system("hco \"bin\\Release\\AAFES.HR.Workers.dll\" -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"\\$viewpath\" -p \"$package\" -up -replace all -ced -op pc -cp \"$clientpath\" -pn \"Engineering Build CheckOut\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
        if ($error_exit != 0){ print "Error: $error_exit\n"};

    print("-----END AAFES.HR.Workers.dll CHECK OUT REPORT--------------------------------\n");
    print scalar localtime;
    print "\n";

    close STDOUT;
    close STDERR;
    exit $error_exit;
