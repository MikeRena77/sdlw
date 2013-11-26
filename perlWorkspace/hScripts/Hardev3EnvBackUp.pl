    ########################################################################
    # $Header: Hardev3EnvBackUp.pl,v 1.0 2008/10/22 mha Exp $
    #
    # Written
    #    by Michael Andrews (MHA)
    #    for AAFES HQ
    #
    #  This Perl script performs a DOS "reg export..." command and checks in the 
    #       resultant file to Harvest for tracking and control of the Hardev3 environment
    #  No changes to the configuration will yield no updated check-in
    #
    #  Command line usage:
    #    perl Hardev3EnvBackUp.pl
    #
    #    No parameters passed in
    #
    #    Version    Date        by   Change Description
    #    1.0        10/22/2008  MHA  Script written to be scheduled for routine ENVIRONMENT configuration check
    #
    ########################################################################
    my $scripDir    =   "\\hscripts";
    my $bkup        =   "\\hscripts\\conf\\backup.tmp";
    my $filename    =   "\\hScripts\\conf\\Hardev3EnvBkup.config";
    my $project     =   "AAFES Administrative Support";
    my $state       =   "HarvestAdmin";
    my $viewpath    =   "\\SCMAdmin\\windows\\conf";
    my $clientpath  =   "c:\\hScripts\\conf";
    my $package     =   "Hardev3EnvironmentConfiguration";

    # redirect STDOUT and STDERR to Hardev3EnvBackUp$$.log
    open SAVEOUT, ">&STDOUT";
    open SAVEERR, ">&STDERR";

    open STDOUT, ">$scripDir/logs/Hardev3EnvBackUp$$.log"
        or die "Can't redirect stdout $!\n";
    open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

    select STDERR; $| = 1;     # make unbuffered
    select STDOUT; $| = 1;     # make unbuffered
    
    print scalar localtime;
    print "\n";	
    print("-----BEGIN CONFIG SAVE TESTING REPORT------------------------------\n");

    print ("reg export \"HKLM\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment\" \"$bkup\" /y \n");
    $error_exit=system("reg export \"HKLM\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment\" \"$bkup\" /y");
    if ($error_exit != 0){print "Registry export ended with error: $error_exit \n"};

    open (FHO, ">$filename") or die "Can't open $filename: $!\n";
        open (FHI, "<:encoding(UCS2-LE)", $bkup) or die "Can't open $bkup: $!\n";
        ITEM: while (<FHI>)
        {
            $line = $_;
            chomp($line);
            print FHO ("$line");
            next ITEM;
        }
        close (FHI);
    close (FHO);

    print ("hci \"Hardev3EnvBkup.config\" -b \"HARDEV1\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -p \"$package\" -uk -op p -cp \"$clientpath\" -pn \"Engineering Build CheckIn\" -eh \"%CA_SCM_HOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
    $error_exit=system("hci \"Hardev3EnvBkup.config\" -b \"HARDEV1\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -p \"$package\" -uk -op p -cp \"$clientpath\" -pn \"Engineering Build CheckIn\" -eh \"%CA_SCM_HOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
    if ($error_exit != 0){print "Error: $error_exit\n"};
    
    print("-----END CONFIG SAVE TESTING REPORT--------------------------------\n");
    print scalar localtime;
    print "\n";	
    
    close STDOUT;
    close STDERR;
    exit $error_exit;
