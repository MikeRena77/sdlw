########################################################################
# $Header: globalDupe.pl,v 1.0 2008/07/09 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script performs a simple xcopy command on BANE (for ALPHA, BETA and QA)
#    and GALACTUS (for GOLD)  in order to
#   update the files on odin_alpha (_beta, _qa, etc) and performs a command-line
#   check out to BULLSEYE (for ALPHA) to keep the files
#   in sync between the 3 web locations
#    NOTE:  This script must reside on both BANE and GALACTUS under c:\hScripts
#
#   Two arguments are necessary to be passed in to the script:
#   - $project = the specific project
#   - $state = the specific AAFES.HR.Workers app being built
#
# Command line usage:
#    perl globalDupe.pl project state
#
#  Version    Date       by   Change Description
#   1.0       7/09/2008  MHA  Duplicate the updates for global or HR_Images over to odin_alpha, etc
#   1.1       7/09/2008  MHA  Perform a command-line checkout to BULLSEYE
#   1.2       7/28/2008  MHA  Rewrote function to internally time-stamp log file
#   1.3       7/28/2008  MHA  Expanded handling for Galactus handling of global and HR-Images
#   1.4       7/30/2008  MHA  Added handling for duplicating POPs to the additional sites
#   1.5      12/16/2008  MAJ  Duplicate the updates for global, pops and hr_images over to H3.
#   1.6      01/13/2009  MHA  Add new web to globalDupe's exercise
#
########################################################################
use Env;
$scripDir       = "C:\\hScripts";
$project = $ARGV[0]; shift;
$state = $ARGV[0]; shift;
chomp($project);
chomp($state);

if ($project eq "HR-Global-2008")
    { 
        $clientpath = "c:\\inetpub\\h3_$state\\global";
        $viewpath   = "\\HRGlobal";
        $web        = "global";
        $bullseyePath = "c:\\inetpub\\wwwroot\\global";
        $targetDir  = "c:\\inetpub\\odin_$state\\global";
    }
if ($project eq "HR-Global-Prod")
    { 
        if ($state eq "QA")
            {
                $clientpath = "c:\\inetpub\\h3_$state\\global";
                $targetDir  = "c:\\inetpub\\odin_$state\\global";
            }
        if ($state eq "Gold")
            {
                $clientpath = "c:\\inetpub\\wwwroot\\global";
                $targetDir  = "c:\\inetpub\\odin\\global";
				$h3TargetDir = "c:\\inetpub\\h3\\global";
            }
    }
if ($project eq "HR-Images-2008")
    { 
        $clientpath = "c:\\inetpub\\h3_$state\\HR_Images";
        $viewpath   = "\\HR_Images";
        $web        = "HR_Images";
        $bullseyePath = "c:\\inetpub\\wwwroot\\HR_Images";
        $targetDir  = "c:\\inetpub\\odin_$state\\HR_Images";
    }
if ($project eq "HR-Images-Prod")
    { 
        if ($state eq "QA")
            {
                $clientpath = "c:\\inetpub\\h3_$state\\HR_Images";
                $targetDir  = "c:\\inetpub\\odin_$state\\HR_Images";
            }
        if ($state eq "Gold")
            {
                $clientpath = "c:\\inetpub\\wwwroot\\HR_Images";
                $targetDir  = "c:\\inetpub\\odin\\HR_Images";
				$h3TargetDir = "c:\\inetpub\\h3\\HR_Images";
            }
    }
if ($project eq "HR-POPs-2008")
    { 
        $clientpath = "c:\\inetpub\\h3_$state\\POPs";
        $viewpath   = "\\HRPOPs";
        $web        = "POPs";
        $bullseyePath = "c:\\inetpub\\wwwroot\\POPs";
        $targetDir  = "c:\\inetpub\\odin_$state\\POPs";
    }
if ($project eq "HR-POPs-Prod")
    { 
        if ($state eq "QA")
            {
                $clientpath = "c:\\inetpub\\h3_$state\\POPs";
                $targetDir  = "c:\\inetpub\\odin_$state\\POPs";
            }
        if ($state eq "Gold")
            {
                $clientpath = "c:\\inetpub\\wwwroot\\POPs";
                $targetDir  = "c:\\inetpub\\odin\\POPs";
				$h3TargetDir = "c:\\inetpub\\h3\\POPs";
            }
    }

if ($project eq "HR-PMW-2008")
    { 
        $clientpath = "c:\\inetpub\\h3_$state\\hrPMW";
        $viewpath   = "\\HRPOPs";
        $web        = "hrPMW";
        $bullseyePath = "c:\\inetpub\\wwwroot\\hrPMW";
        $targetDir  = "c:\\inetpub\\odin_$state\\hrPMW";
    }
if ($project eq "HR-PMW-Prod")
    { 
        if ($state eq "QA")
            {
                $clientpath = "c:\\inetpub\\h3_$state\\hrPMW";
                $targetDir  = "c:\\inetpub\\odin_$state\\hrPMW";
            }
        if ($state eq "Gold")
            {
                $clientpath = "c:\\inetpub\\wwwroot\\hrPMW";
                $targetDir  = "c:\\inetpub\\odin\\hrPMW";
				$h3TargetDir = "c:\\inetpub\\h3\\hrPMW";
            }
    }

# redirect STDOUT and STDERR to globalDupe$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/globalDupe$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN globalDupe.pl REPORT------------------------------\n");

if ($state eq "Alpha")
    { 
        print("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\setRead-Only.pl \"$web\" c:\\inetpub\\wwwroot\" -m BULLSEYE -syn -er \"%HARVESTHOME%\\bullseye.dfo\" -wts \n");
        $error_exit=system("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\setRead-Only.pl \"$web\" c:\\inetpub\\wwwroot\" -m BULLSEYE -syn -er \"%HARVESTHOME%\\bullseye.dfo\" -wts");
        if ($error_exit != 0){print "Set Read-Only Error: $error_exit => $! $? \n\n"};

        print("hco \"*.*\" -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"$bullseyePath\" -pn \"Check Out for Browse\" -rm BULLSEYE -eh \"%HARVESTHOME%\\hsync.dfo\" -er \"%HARVESTHOME%\\bullseye.dfo\" -oa \">>&STDOUT\" -wts \n");
        $error_exit=system("hco \"*.*\" -b \"PRODSWA\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"$bullseyePath\" -pn \"Check Out for Browse\" -rm BULLSEYE -eh \"%HARVESTHOME%\\hsync.dfo\" -er \"%HARVESTHOME%\\bullseye.dfo\" -oa \">>&STDOUT\" -wts");
        if ($error_exit != 0){ print "Check Out Error: $error_exit: $! \n"};
    }
        
print "We are copying the $project files from: $clientpath to: $targetDir \n"; 

if ($project ne "HR-PMW-2008")
    { 
        # The following 3 lines keep the h3 and odin sites for alpha, beta and qa in sync
        print("xcopy $clientpath\\*.* $targetDir /s /c /f /r /y \n");
        $error_exit=system("xcopy  $clientpath\\*.* $targetDir /s /c /f /r /y");
        if ($error_exit != 0){print "XCopy Error: $error_exit => $! :$? \n\n"};
    }

if ($state eq "Gold")
	{
    print "We are copying the $project files from: $clientpath to: $h3TargetDir \n"; 
	# The following 3 lines keep the h3 site for gold in sync
    print("xcopy $clientpath\\*.* $h3TargetDir /s /c /f /r /y \n");
    $error_exit=system("xcopy  $clientpath\\*.* $h3TargetDir /s /c /f /r /y");
    if ($error_exit != 0){print "XCopy Error: $error_exit => $! :$? \n\n"};
	}

print("-----END globalDupe.pl REPORT--------------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
