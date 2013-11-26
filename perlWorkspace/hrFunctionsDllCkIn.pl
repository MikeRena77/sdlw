    ########################################################################
    # $Header: hrFunctionsDllCkIn.pl,v 1.0 2008/07/01 mha Exp $
    #
    # Written
    #    by Michael Andrews (MHA)
    #    for AAFES HQ
    #
    #  This Perl script performs the Harvest Check In on the AAFES.HR.Functions.dll file
    #  This script Checks In the DLL after the OpenMake build has been run
    #  The package name is read from the temporary file PKG
    #
    #  Command line usage:
    #    perl hrFunctionsDllCkIn.pl [state] [package] 
    #
    #    Parameters passed in:
    #    $state = state => which state is the source of our update
    #    $package = [package] => the Harvest work package
    #
    #    Version    Date       by   Change Description
    #    1.0        7/01/2008  MHA  Script derived from hrWorkersDllCkIn.pl
    #    1.1        7/28/2008  MHA  Rewrote function to internally time-stamp log file
    #    1.2        8/21/2008  MHA  Mod to move build functions over to the Prod lifecycle
    #
    ########################################################################
    my $scripDir    = "C:\\hScripts";
    my $state       = $ARGV[0]; shift;
    my $package     = $ARGV[0]; shift;
    
    chomp($state);
    chomp($package);
    my $project     = "AAFES.HR.Functions.Prod";
    my $viewpath    = "AAFES.HR.Functions";
    my $clientpath  = "c:\\HarvestApps\\$state\\AAFES.HR.Functions";

    # redirect STDOUT and STDERR to hrFunctionsDllCkIn$$.log
    open SAVEOUT, ">&STDOUT";
    open SAVEERR, ">&STDERR";

    open STDOUT, ">$scripDir/logs/hrFunctionsDllCkIn$$.log"
        or die "Can't redirect stdout $!\n";
    open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

    select STDERR; $| = 1;     # make unbuffered
    select STDOUT; $| = 1;     # make unbuffered
    
    print scalar localtime;
    print "\n";	
    print("-----BEGIN AAFES.HR.Functions.dll CHECK IN REPORT------------------------------\n");
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

    print ("hci \"bin\\Release\\AAFES.HR.Functions.dll\" -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"\\$viewpath\" -p \"$package\" -ur -op p -cp \"$clientpath\" -pn \"Engineering Build CheckIn\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
    $error_exit=system("hci \"bin\\Release\\AAFES.HR.Functions.dll\" -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"\\$viewpath\" -p \"$package\" -ur -op p -cp \"$clientpath\" -pn \"Engineering Build CheckIn\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
    if ($error_exit != 0){print "Error: $error_exit\n"};
    
    print("-----END AAFES.HR.Functions.dll CHECK IN REPORT--------------------------------\n");
    print scalar localtime;
    print "\n";	
    
    close STDOUT;
    close STDERR;
    exit $error_exit;
