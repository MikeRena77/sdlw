    ########################################################################
    # $Header: hrReportsDllCkIn.pl,v 1.0 2008/02/28 08:39:00 mha Exp $
    #
    # Written
    #    by Michael Andrews (MHA)
    #    for AAFES HQ
    #
    #  This Perl script performs the Harvest Check In on the hrReports.dll file
    #      http://machine/h3_beta/hrReports
    #      on MACHINE
    #  This script Checks In the DLL after the OpenMake build has been run
    #  The package name is read from the temporary file PKG
    #
    #  Command line usage:
    #    perl -S hrReportsDllCkIn.pl [state] web [package] 
    #    Parameters passed in:
    #    $state = state => which state is the source of our update
    #    $web = web => which web are we targetting (i.e. h3_beta, h3_alpha, etc)
    #    $package = [package] => the Harvest work package
    #
    #    Version    Date     by   Change Description
    #    1.0    2/28/2008  MHA  Script rewritten in Perl to Check In the DLL after build
    #    1.1    2/28/2008  MHA  Modified to get hci log to output to &STDOUT
    #    1.2    2/29/2008  MHA  Modified error handling
    #    1.3    3/04/2008  MHA  Converted script to run directly from hrefresh
    #    1.4    3/17/2008  MHA  Edited some comments and added new "$web" variable
    #    1.5    5/21/2008  MHA  Modified to handle the passing of multiple package names
    #    1.6    7/28/2008  MHA  Rewrote function to internally time-stamp log file
    #
    ########################################################################
    my $scripDir    = "C:\\hScripts";
    my $state       = $ARGV[0]; shift;
    my $web         = $ARGV[0]; shift;
    my $package     = $ARGV[0]; shift;
    
    chomp($package);
    chomp($state);
    chomp($web);

    # redirect STDOUT and STDERR to hrReportsDllCkIn$$.log
    open SAVEOUT, ">&STDOUT";
    open SAVEERR, ">&STDERR";

    open STDOUT, ">$scripDir/logs/hrReportsDllCkIn$$.log"
        or die "Can't redirect stdout $!\n";
    open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

    select STDERR; $| = 1;     # make unbuffered
    select STDOUT; $| = 1;     # make unbuffered
    
    print scalar localtime;
    print "\n";
    print("-----BEGIN CHECK IN REPORT------------------------------\n");
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

    print ("hci \"bin\\hrReports.dll\" -b \"PRODSWA\" -en \"HR-Reports-Prod\" -st \"$state\" -vp \"\\HR-Reports\" -p \"$package\" -ur -op p -cp \"c:\\inetpub\\$web\\hrReports\" -pn \"Engineering Build CheckIn\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
    $error_exit=system("hci \"bin\\hrReports.dll\" -b \"PRODSWA\" -en \"HR-Reports-Prod\" -st \"$state\" -vp \"\\HR-Reports\" -p \"$package\" -ur -op p -cp \"c:\\inetpub\\$web\\hrReports\" -pn \"Engineering Build CheckIn\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
    if ($error_exit != 0){print "Error: $error_exit\n"};
    
    print ("\\hScripts\\unsetRead.bat hrReports $web \n");
    $error_exit=system("\\hScripts\\unsetRead.bat hrReports $web");
    if ($error_exit != 0){ print "Error: $error_exit\n"};

    print("-----END CHECK IN REPORT--------------------------------\n");
    print scalar localtime;
    print "\n";
    
    close STDOUT;
    close STDERR;
    exit $error_exit;
