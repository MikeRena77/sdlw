########################################################################
# $Header: X-hsyncUDP_createFolderWithPkgName.pl,v 1.0 2008/08/08 Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This experimental Windows-side Perl script checks out the active versions for a package
#    into a directory created to bear the same name as the package
#
# Command line usage:
#    X-hsyncUDP_createFolderWithPkgName.pl [project] [state]  [user] [package]
#
#    Parameter passed in:
#      $project => which project are we targetting (i.e. development or production, etc)
#      $state   => which state is the source of our update
#      $package => name of the package targetted
#
#    Version    Date by   Change Description
#       1.0      8/08/2008  MHA   Preliminary design
#       1.1       8/18/2008  MHA   Added package handling for multiple packages
#       1.2      1/08/2009  MAJ    Modified for the XPS-Endevor project
#       1.3      2/03/2009  MHA    Moved "email" routine to here from runXPSjob.bat
#       1.4      2/12/2009  MHA   Modified from HSYNC to HCO for package item checkout handling
#
########################################################################
use ENV;

$project = $ARGV[0];
shift;

$state = $ARGV[0];
shift;

$user = $ARGV[0];
shift;

$package = $ARGV[0];
shift;

$viewpath    = "\\XPS-Endevor";
$clientpath = "C:\\XPS\\";
$scripDir = "C:\\hScripts";

$harvesthome = $ENV{'HARVESTHOME'};

chomp($project);
chomp($state);
chomp($user);
chomp($package);
chomp($harvesthome);

$sed = "C:\\Progra~1\\UnxUtils\\usr\\local\\wbin\\sed.exe";

# redirect STDOUT and STDERR to update$project$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir\\logs\\update$package$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered


print scalar localtime;
print "\n";
print("-----BEGIN update$package Log------------------------------\n");

# This series of print statements serve as a debugging tool and can be commented out
print ("The project name is: \"$project\" \n");
print ("The state name is: \"$state\" \n");
print ("The user name is: \"$user\" \n");
print ("The package name is: \"$package\" \n");
print ("The viewpath name is: \"$viewpath\" \n");
print ("The clientpath name is: \"$clientpath\" \n");
print ("The scripts directory name is: \"$scripDir\" \n");
print ("The Harvest program directory name is: \"$harvesthome\" \n");

    open (ENVLIST, "$scripDir\\pkg") or die "Can't open $scripDir\\pkg: $!\n";
    ITEM: while (<ENVLIST>)
    {
        $/ = " \n";
        $package = $_;
        chomp ($package);
        $ENV{'PACKAGE'} = $package;

        $clientpath = $clientpath . $package;
        print ("Now the ClientPath is: \"$clientpath\" \n");

        # We need to
        if (!(-e $clientpath))
        {
            mkdir ("$clientpath") || die "Couldn't make directory!\n";
        }

        print             ("hco -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -br -r -nt -s * -pf \"$package\"  -cp \"$clientpath\" -op as -eh \"$harvesthome\\hsync.dfo\" \n");
        $error_exit=system("hco -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -br -r -nt -s * -pf \"$package\"  -cp \"$clientpath\" -op as -eh \"$harvesthome\\hsync.dfo\" -o \"$scripDir\\logs\\hcoLog$$.log");
        if ($error_exit != 0){ print "Error: $error_exit: $! \n"};

        print ("$user \n");
        print ("\"$sed\" \"s/myname/\"$user\"/g\" $scripDir\\userEmail.sql.sav \n");
        system("\"$sed\" \"s/myname/\"$user\"/g\" $scripDir\\userEmail.sql.sav > $scripDir\\userEmail.sql");
        print ("$scripDir\\userEmail.sql \n");

        print ("hsql -b PRODSWA -f $scripDir\\userEmail.sql -nh -o \"$clientpath\"\\email \n");
        system("hsql -b PRODSWA -f $scripDir\\userEmail.sql -nh -eh \"$harvesthome\\hsync.dfo\" -o \"$clientpath\"\\email");

        
        next ITEM;
    }
    close (ENVLIST);

    print             ("del \"$scripDir\\pkg\" \n");
    $error_exit=system("del \"$scripDir\\pkg\" ");
    if ($error_exit != 0){ print "Error: $error_exit: $! \n"};


print("-----END update$package Log--------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
