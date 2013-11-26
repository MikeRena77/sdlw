    ########################################################################
    # $Header: hrReportsDllCkOut.pl,v 1.0 2008/02/28 07:18:00 mha Exp $
    #
    # Written
    #    by Michael Andrews (MHA)
    #    for AAFES HQ
    #
    #  This Perl script performs the Harvest Check Out for Update on the hrReports.dll file
    #        http://machine/h3_beta/hrReports
    #        on MACHINE
    #  This script Checks Out the DLL for Update before running the OpenMake build
    #  The package name is read from the temporary file PKG
    #
    #  Command line usage:
    #    perl hrReportsDllCkOut.pl [state] [web] [package] 
    #
    #    Parameter passed in:
    #      $state = state => which state is the source of our update
    #      $web = web => which web are we targetting (i.e. h3_beta, h3_alpha, etc)
    #      $package = [package] => the Harvest work package
    #
    #    Version    Date       by   Change Description
    #      1.0      2/28/2008  MHA  Script rewritten in Perl to Check Out for Update the DLL before build
    #      1.1      2/28/2008  MHA  Modified to get hci log to output to &STDOUT
    #      1.2      2/29/2008  MHA  Modified error handling
    #      1.3      3/04/2008  MHA  Major changes to run from HRefresh as one of PreCmds
    #      1.4      3/17/2008  MHA  Added web parameter to allow handling different web locations
    #      1.5      5/21/2008  MHA  Modified to handle the passing of multiple package names
    #      1.6      5/29/2008  MHA  Removed a premature command to unset Read-Only attribute
    #      1.7      7/28/2008  MHA  Rewrote function to internally time-stamp log file
    #
    ########################################################################
    my $scripDir    = "C:\\hScripts";
    my $state       = $ARGV[0]; shift;
    my $web         = $ARGV[0]; shift;
    my $package     = $ARGV[0]; shift;

    chomp($web);
    chomp($state);
    chomp($package);
    
    # redirect STDOUT and STDERR to hrReportsDllCkOut$$.log
    open SAVEOUT, ">&STDOUT";
    open SAVEERR, ">&STDERR";

    open STDOUT, ">$scripDir/logs/hrReportsDllCkOut$$.log" or die "Can't redirect stdout $!\n";
    open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

    select STDERR; $| = 1;     # make unbuffered
    select STDOUT; $| = 1;     # make unbuffered

    print scalar localtime;
    print "\n";
    print("-----BEGIN CHECK OUT REPORT------------------------------\n");
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

        print ("hco \"bin\\hrReports.dll\" -b \"PRODSWA\" -en \"HR-Reports-Prod\" -st \"$state\" -vp \"\\HR-Reports\" -p \"$package\" -up -replace all -ced -op pc -cp \"c:\\inetpub\\$web\\hrReports\" -pn \"Engineering Build CheckOut\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
        $error_exit=system("hco \"bin\\hrReports.dll\" -b \"PRODSWA\" -en \"HR-Reports-Prod\" -st \"$state\" -vp \"\\HR-Reports\" -p \"$package\" -up -replace all -ced -op pc -cp \"c:\\inetpub\\$web\\hrReports\" -pn \"Engineering Build CheckOut\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
        if ($error_exit != 0){ print "Error: $error_exit\n"};

    print("-----END CHECK OUT REPORT--------------------------------\n");
    print scalar localtime;
    print "\n";

    close STDOUT;
    close STDERR;
    exit $error_exit;
