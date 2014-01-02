######################################################################
# vss2h.pl
# --------
# A utility to convert Visual Source Safe projects into CCC/Harvest
# repository items.
#
# Originally written by David Cavanaugh of Platinum technology Professional
#                       Services Group. (Let's call that version 1)
# Modified for Halifax by Phil Gibbs/Trinem Consulting Limited (Let's call that version 2)
#          EMAIL: pgibbs@trinem.co.uk
#          WEB:   www.trinem.co.uk
# Revised and updated for Harvest r7.1 by Michael Andrews (Let's call that version 3.0 - dated 29 Aug 2007)
# -- Many of these changes were actually necessitated at the introduction of the new database with the introduction of Harvest r 5.x
# -- At that time actual files and deltas were moved from the file system into the database itself using the BLOB
# -- Tables and columns changed and several old Harvest functions changed dramatically or disappeared entirely while
# -- other new functions were introduced
#  Version    Date     by   Change Description
#    3.0    8/29/2007  MHA  Converted old vss2h for use with the new Harvest r 7.1
#    3.1    6/17/2008  MHA  Made fixes for the File Modification Time and the Modifier ID
# --------------------------------------------------------------------
# 1) Replaced old Harvest “husql” commands with r7.1 “hsql” for queries
#    and Oracle sqlplus for actual updates to the Harvest DB
# 2) File structure reflects Harvest r7.1 default installation
#    (executables are no longer found under %HARVESTHOME%\bin for the
#    Windows 2003 server.  Use the <-harhome> in <vss2h.ini> to point directly
#    to the location of the executables.
# 3) Corrected <hsql> and <sqlplus> calls to reflect latest changes in usage
#    and changes to the r7.1 Harvest DB table and column names
# 4) Corrected <hci> calls to reflect latest changes in usage for Harvest r7.1
# 5) Replaced old Oracle <plus33.exe> calls with new <sqlplus.exe> calls
# 6) Provided additional internal documentation for the <vss2h.ini> file
# 7) Made changes to update Oracle’s <NEW_TIME(TO_DATE())> function
# 8) Added $broker (-br broker) variable for Harvest broker to the
#    <vss2h.ini> file
# 9) Added new Harvest "Create Empty Path" <hcrtpath> command to create the
#    repository structure in Harvest while processing
#
# Note, this is a CLIENT script which requires access to the following client
#    PC applications:
# a) Visual Source Safe (command line option: ss)
# b) hsql               (Harvest Client)
# c) sqlplus            (client side SQL*Plus)
# d) perl               (command line Perl version 5.6.1)
#
# This script expects the Visual SourceSafe DB to be found as dictated by the
#    <srcsafe.ini> file in the <-ssloc> location (specified in <vss2h.ini>)
#
# Usage:  >perl vss2h.pl
# To use this script, modify the <vss2h.ini> file to provide specifics for your
# Harvest and Visual SourceSafe installations and execute the <vss2h.pl) Perl
# script from the command-line with no other parameters furnished:
# --------------------------------------------------------------------

#
# Scan vss2h.ini file for initial setting of logdir.
#
$logdir = "";
open VSS2H, "vss2h.ini" or die "Can't open vss2h.ini $!\n";
LINE: while (<VSS2H>)
{
#  check for server flag
   if (/^-logdir /)
   {
      if (($F1, $logdir) = split(' ', $_, 2))
      {
         chomp($logdir);
      }
   }
}
# Close the ini file
close VSS2H;
die "Unable to close vss2h.ini\n" if $?;
if ($logdir eq "")
{
    # logdir not specified in .ini file - use working directory
    $logdir=".";
}

# Put out a final message to "normal" standard out to tell the
# operator the location of the log file.
#
print "log file = \"$logdir\\vss2h$$.log\"\n";
# redirect STDOUT and STDERR to vss2h$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$logdir/vss2h$$.log" or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

# initialize the .ini file variables 
$keep_logs        = 0;  # keep log files (1)
$keep_files       = 0;  # keep items on local system (1)
$error_exit       = 0;  # error code
$need_history     = 0;  # get all history (1)
$need_repository  = 0;  # create repository structure only (1)
$take_snapshot_only = 0;  # associate VSS labels to snapshots (1), no HCI
$take_snapshot    = 0;  # associate VSS labels to snapshots (1)
$attempts         = 1;  # number of HCI attempts
$time_out         = 1;  # time to wait between attempts (seconds)

$time_zone        = ""; # Time zone for VSS dates
$broker           = ""; # Harvest broker
$server           = ""; # CCC/Harvest server type (WINDOWS or UNIX)
$husr             = ""; # CCC/Harvest user name
$hpw              = ""; # CCC/Harvest user password
$vusr             = ""; # Visual Source Safe user name
$vpw              = ""; # Visual Source Safe user password
$ousr             = ""; # Oracle User Name
$opw              = ""; # Oracle Password
$ohost            = ""; # Oracle Host
$harhome          = ""; # Harvest Home Directory
$ssloc            = ""; # Source Safe Binary Directory
$sqlloc           = ""; # Location of SQL scripts

$env              = ""; # CCC/Harvest environment
$view             = ""; # CCC/Harvest view
$state            = ""; # CCC/Harvest state
$pkg              = ""; # CCC/Harvest package
$viewpath         = ""; # CCC/Harvest view path
$ciproc           = "Check In"; # CCC/Harvest Check In Process
$wdir             = ""; # Visual Source Safe working directory


print "Starting VSS to Harvest conversion\n";
print "Start time:";
$systime=system ("time /T");
print $systime "\n";

# Open the vss2h.ini file
print "Reading Configuration settings from vss2h.ini\n";
open VSS2H, "vss2h.ini" or die "Can't open vss2h.ini $!\n";
LINE: while (<VSS2H>)
{
   next LINE if /^#/;      # skip comments
   next LINE if /^$/;      # skip blank lines

#  check for history flag
   if (/^-h$/)
   {
      $need_history = 1;
   }

#  check for repository flag
   if (/^-r$/)
   {
      $need_repository = 1;
   }
#  check for take snapshot only flag
   if (/^-tso$/)
   {
      $take_snapshot_only = 1;
      $take_snapshot = 1;
   }
#  check for take snapshot flag
   if (/^-ts$/)
   {
      $take_snapshot = 1;
   }

#  check for keep files flag
   if (/^-files$/)
   {
      $keep_files = 1;
   }

#  check for debug flag
   if (/^-debug$/)
   {
      $keep_logs = 1;
   }

   #  check for VSS flag
   if (/^-VSS /)
   {
      if (($F1, $VSS) = split(' ', $_, 2))
      {
         chomp($VSS);
         push @vss_projects, $VSS;
      }
   }

#  check for server flag
   if (/^-server /)
   {
      if (($F1, $server) = split(' ', $_, 2))
      {
         chomp($server);
         if (($server eq "WINDOWS") or ($server eq "UNIX"))
         {
         }
         else
         {
            die "Invalid -server parameter $server, must be WINDOWS or UNIX\n";
         }
      }
   }

#  check for time zone flag
   if (/^-tz /)
   {
      if (($F1, $time_zone) = split(' ', $_, 2))
      {
         chomp($time_zone);
         if (($time_zone eq "AST") or  # Atlantic Standard or Daylight Time   
             ($time_zone eq "ADT") or
             ($time_zone eq "BST") or  # Bering Standard or Daylight Time  
             ($time_zone eq "BDT") or
             ($time_zone eq "CST") or  # Central Standard or Daylight Time  
             ($time_zone eq "CDT") or
             ($time_zone eq "EST") or  # Eastern Standard or Daylight Time  
             ($time_zone eq "EDT") or
             ($time_zone eq "GMT") or  # Greenwich Mean Time  
             ($time_zone eq "HST") or  # Alaska-Hawaii Standard Time or Daylight Time.  
             ($time_zone eq "HDT") or
             ($time_zone eq "MST") or  # Mountain Standard or Daylight Time  
             ($time_zone eq "MDT") or
             ($time_zone eq "NST") or  # Newfoundland Standard Time  
             ($time_zone eq "PST") or  # Pacific Standard or Daylight Time  
             ($time_zone eq "PDT") or
             ($time_zone eq "YST") or  # Yukon Standard or Daylight Time  
             ($time_zone eq "YDT"))
         {
         }
         else
         {
            die "Invalid -tz parameter $time_zone, see man pages for correct values.\n";
         }
      }
   }

#  check for attempts flag
   if (/^-at /)
   {
      if (($F1, $attempts) = split(' ', $_, 2))
      {
         chomp($attempts);
         if ($attempts < 1)
         {
            die "Invalid -at parameter $attempts, must be greater than or equal to 1\n";
         }
      }
   }

#  check for time out flag
   if (/^-to /)
   {
      if (($F1, $time_out) = split(' ', $_, 2))
      {
         chomp($time_out);
         if ($time_out < 1)
         {
            die "Invalid -to parameter $time_out, must be greater than or equal to 1\n";
         }
      }
   }

#  check for broker flag
   if (/^-br /)
   {
      if (($F1, $broker) = split(' ', $_, 2))
      {
         chomp($broker);
      }
   }
#  check for husr flag
   if (/^-husr /)
   {
      if (($F1, $husr) = split(' ', $_, 2))
      {
         chomp($husr);
      }
   }

#  check for hpw flag
   if (/^-hpw /)
   {
      if (($F1, $hpw) = split(' ', $_, 2))
      {
         chomp($hpw);
      }
   }

#  check for ousr flag
   if (/^-ousr /)
   {
      if (($F1, $ousr) = split(' ', $_, 2))
      {
         chomp($ousr);
      }
   }

#  check for opw flag
   if (/^-opw /)
   {
      if (($F1, $opw) = split(' ', $_, 2))
      {
         chomp($opw);
      }
   }

#  check for ohost flag
   if (/^-ohost /)
   {
      if (($F1, $ohost) = split(' ', $_, 2))
      {
         chomp($ohost);
      }
   }

#  check for sqlloc flag
   if (/^-sqlloc /)
   {
      if (($F1, $sqlloc) = split(' ', $_, 2))
      {
         chomp($sqlloc);
      }
   }

#  check for ssloc
   if (/^-ssloc /)
   {
      if (($F1, $ssloc) = split(' ', $_, 2))
      {
         chomp($ssloc);
      }
   }

#  check for harvesthome
   if (/^-harhome /)
   {
      if (($F1, $harhome) = split(' ', $_, 2))
      {
         chomp($harhome);
      }
   }

#  check for vusr flag
   if (/^-vusr /)
   {
      if (($F1, $vusr) = split(' ', $_, 2))
      {
         chomp($vusr);
      }
   }

#  check for vpw flag
   if (/^-vpw /)
   {
      if (($F1, $vpw) = split(' ', $_, 2))
      {
         chomp($vpw);
      }
   }

#  check for env flag
   if (/^-en /)
   {
      if (($F1, $env) = split(' ', $_, 2))
      {
         chomp($env);
      }
   }

#  check for view flag
   if (/^-vw /)
   {
      if (($F1, $view) = split(' ', $_, 2))
      {
         chomp($view);
      }
   }

   #  check for st flag
   if (/^-st /)
   {
      if (($F1, $state) = split(' ', $_, 2))
      {
         chomp($state);
      }
   }

#  check for p flag
   if (/^-p /)
   {
      if (($F1, $pkg) = split(' ', $_, 2))
      {
         chomp($pkg);
      }
   }

#  check for vp flag
   if (/^-vp /)
   {
      if (($F1, $viewpath) = split(' ', $_, 2))
      {
         chomp($viewpath);
      }
   }

#  check for wdir flag
   if (/^-wdir /)
   {
      if (($F1, $wdir) = split(' ', $_, 2))
      {
         chomp($wdir);
      }
   }

#  check for check in process flag
   if (/^-ci /)
   {
      if (($F1, $ciproc) = split(' ', $_, 2))
      {
         chomp($ciproc);
      }
   }

}


# Close the ini file
close VSS2H;
die "Unable to close vss2h.ini\n" if $?;

#
# Set up PATH for access to various bits and pieces
#
if ($harhome ne "")
{
	$ENV{'PATH'}="$harhome;$ENV{'PATH'}";
}

if ($ssloc ne "")
{
	$ENV{'PATH'}="$ssloc;$ENV{'PATH'}";
}

# 
# Set up the ORACLE username/password@hostname
# --------------------------------------------
# Note - if Oracle user and password are missing then we will connect
# with "/" and assume there is an appropriate "IDENTIFIED EXTERNAL"
# Oracle user. Similarly, if Oracle Host has not been specified then
# we will be connecting to a local DB.
#
$OraConnect="$ousr/$opw";
if ($ohost ne "")
{
	$OraConnect="$OraConnect\@$ohost";
}

# Display the .ini file settings
print "Conversion settings are:\n";
print "Need History = $need_history\n";
print "Time Zone = $time_zone\n";
print "Keep Files = $keep_files\n";
print "Need Repository = $need_repository\n";
print "Take Snapshot Only = $take_snapshot_only\n";
print "Take Snapshot = $take_snapshot\n";
print "Number of HCI attempts is $attempts\n";
print "Keep log files is $keep_logs\n";
print "Time between HCI attempts is $time_out\n";
print "VSS = @vss_projects\n";
print "Harvest server = $server\n";
print "Harvest User = $husr\n";
print "Harvest password = $hpw\n";
print "Harvest Home Dir = $harhome\n";
print "VSS User = $vusr\n";
print "VSS password = $vpw\n";
print "VSS bin dir  = $ssloc\n";
print "ohost = $ohost\n";
print "Oracle Connection = $OraConnect\n";
print "SQL scripts location = $sqlloc\n";
print "Harvest Environment = $env\n";
print "Harvest View = $view\n";
print "Harvest State = $state\n";
print "Harvest Check In process = $ciproc\n";
print "Harvest Package = $pkg\n";
print "Harvest Viewpath = $viewpath\n";
print "Working directory = $wdir\n";
print "\n";

# validate the .ini file settings
if ($server eq "")
{
   die "Empty or missing -server parameter, must have a value\n";
}
if ($husr eq "")
{
   die "Empty or missing -husr parameter, must have a value\n";
}
if ($vusr eq "")
{
   die "Empty or missing -vusr parameter, must have a value\n";
}
if ($env eq "")
{
   die "Empty or missing -en parameter, must have a value\n";
}
if (($view eq "") and $take_snapshot and $take_snapshot_only )
{
   die "Empty or missing -vw parameter, must have a value\n";
}
if (($view eq "") and $take_snapshot)
{
   die "Empty or missing -vw parameter, must have a value\n";
}
if (($time_zone eq "") and $need_history)
{
   die "Empty or missing -tz parameter, must have a value\n";
}
if ($state eq "")
{
   die "Empty or missing -st parameter, must have a value\n";
}
if ($pkg eq "")
{
   die "Empty or missing -p parameter, must have a value\n";
}
if ($sqlloc eq "")
{
   die "Empty or missing -sqlloc parameter, must have a value\n";
}

#if ($viewpath eq "")
#{
#   die "Empty or missing -vp parameter, must have a value\n";
#}
if ($wdir eq "")
{
   die "Empty or missing -wdir parameter, must have a value\n";
}

# Get the Harvest id for the person doing the conversion
open (USERLIST, ">$logdir\\userlist$$.sql") or die "Can't open $logdir\\userlist$$.sql: $!\n";
print USERLIST ( "select usrobjid from harallusers where username = \'$husr\'\n");
close USERLIST;

system ("hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" ") == 0
   or die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed getting user $husr: $?\n";

# parse the log file for the idcounter
open (FILEUSER, "$logdir\\userlist$$.log") or die "Can't open $logdir\\userlist$$.log: $!\n";
@status = <FILEUSER>;
close FILEUSER;

# check for Oracle warnings/errors
if (grep /^E([0-9]){4} /, @status)
{
   die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle error: $?\n";
}
if (grep /^W([0-9]){4} /, @status)
{
   die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle warning: $?\n";
}

foreach $entry (@status)
{
   if ($entry =~ /^USROBJID /)
   {
      if (($F1, $F2, $creator_id) = split(' ', $entry, 3))
      {
         chomp($creator_id);
      }
   }
}
open(PROGRESSFILE,">$logdir\\progress$$.log") or die "Can't open $logdir\\progress$$.log: $!\n";

print "The creator id is $creator_id\n";

# Migrate each -VSS project
foreach $VSS (@vss_projects)
{
   $project = "";
   # create the base used for directories in the working directory
   @baseproj = reverse(split( /\//, $VSS));
   $projbase = $baseproj[0];
   print "Projectbase is $projbase\n";

   # get the list of files and projects to convert
   print "Creating project listing file\n";
   system ("ss Dir -R \"-O$logdir\\filelist$$.log\" -I-Y \"\\$VSS\" -Y$vusr,$vpw") == 0
      or die "ss Dir -R \"-O$logdir\\filelist$$.log\" -I-Y \"\\$VSS\" -Y$vusr,$vpw failed: $?\n";

   # create the directory structure for check outs
   chdir "$wdir" or die "Can't cd to $wdir: $!\n";
   mkdir ("$projbase", 0711) or warn "Can't mkdir $projbase: $!\n";
   open (FILELIST,"$logdir\\filelist$$.log") or die "Can't open $logdir\\filelist$$.log: $!\n";
   ITEM: while (<FILELIST>)
   {
      next ITEM if /^$/;                     # skip blank lines
      next ITEM if /^No items found under/;  # skip empty projects
      next ITEM if /^[0-9]+ +item/;          # skip count of returned items
      next ITEM if /^$projbase.dll$/;       # skip all the builds of the binary (there are thousands)
      next ITEM if /^$projbase.pdb$/;       # skip all the builds of the binary (there are thousands)
      chomp;                                 # remove the newline

      if (/^\$\/.*:$/)                       # project directory in form of $/project/subproj:
      {
         $project = $_;
         chop $project;                      # remove trailing :
         # need to remove everything before project base name
         # can have form of $/projbase
         #                  $/projbase/subproj
         #                  $/other/kinds/of/stuff/projbase
         #                  $/other/kinds/of/stuff/projbase/subproj
         #
         # what we want is /projbase or /projbase/subproj
         $subproj = "";
         ($F1, $subproj) = split (/\Q$VSS/, $project, 2 );
         if ($subproj eq "\/bin")
         {
            next ITEM;
         }
         print "Subproject is \"$subproj\"\n";
         print "The trimmed project is \"$projbase$subproj\"\n";
         $newwdir = $wdir . "/" . $projbase . $subproj;
         #  This is original - I don't want to propogate the SourceSafe project name into the repository
         #$newviewpath = $viewpath . "/" . $projbase . $subproj;
         $newviewpath = $viewpath . "/" . $subproj;
         
         #  if we're at the root level of the VSS project, let's skip creating a new item path in the repository for it
         #if ($newviewpath eq $projbase)
         #{
         #   next ITEM;
         #}
         
         print ("hcrtpath -b \"$broker\" -en \"$env\" -st \"$state\" -rp \"$newviewpath\" -usr \"$husr\" -pw \"$hpw\" -cipn \"$ciproc\" -oa \"$logdir\\fileNewPath$$.log\" \n");
               system ("hcrtpath -b \"$broker\" -en \"$env\" -st \"$state\" -rp \"$newviewpath\" -usr \"$husr\" -pw \"$hpw\" -cipn \"$ciproc\" -oa \"$logdir\\fileNewPath$$.log\" ") == 0
                  or warn "hcrtpath -b \"$broker\" -en \"$env\" -st \"$state\" -rp \"$newviewpath\" -usr \"$husr\" -pw \"$hpw\" -cipn \"$ciproc\" -oa \"$logdir\\fileNewPath$$.log\" failed: $?\n";
                           
         if ($server eq "UNIX")
         {
            # $newviewpath format is /xxx/yyy/zzz
            $newviewpath =~ s/\\|\//\//g;
            $newdir =~ s/\\|\//\//g;
         }
         elsif ($server eq "WINDOWS")
         {
            # $newviewpath format is \xxx\yyy\zzz
            $newviewpath =~ s/\\|\//\\/g;
            $newwdir =~ s/\\|\//\\/g;
         }
         else
         {
            die "Invalid server type $server.\n";
         }
         print "New working directory is \"$newwdir\"\n";
         print "New view path is \"$newviewpath\"\n";
         chdir "$newwdir" or die "Can't cd to \"$newwdir\": $!\n";
         next ITEM;
      }

      if (/^\$(?!\/).*(?!:)$/)               # subproject directory in form of $subproj
      {
         substr($_, 0, 1) = "";              # remove the leading $
         $newdir = $_;
         print "New directory to create is \"$newdir\"\n";
         mkdir ("$newdir", 0711) or warn "Can't mkdir \"$newdir\": $!\n";
         next ITEM;
      }

      next ITEM if $need_repository;         # skip files if only creating repository structure

      if ($need_history)
      {
         print "Processing history of file $project/$_\n";
         system ("ss History \"$project/$_\" -I-Y \"-O$logdir\\filehist$$.log\" -Y$vusr,$vpw") == 0
            or die "ss History \"$project/$_\" -I-Y \"-O$logdir\\filehist$$.log\" -Y$vusr,$vpw failed: $?\n";
      }
      else
      {
         print "Processing history of file $project/$_\n";
	 print "ss History \"$project/$_\" -I-Y -#1 \"-O$logdir\\filehist$$.log\" -Y$vusr,$vpw\n";
         system ("ss History \"$project/$_\" -I-Y -#1 \"-O$logdir\\filehist$$.log\" -Y$vusr,$vpw") == 0
            or die "ss History \"$project/$_\" -I-Y -#1 \"-O$logdir\\filehist$$.log\" -Y$vusr,$vpw failed: $?\n";
      }
   
      # reverse the order of items in the history since VSS returns most recent first
      open (FILEHIST, "$logdir\\filehist$$.log") or die "Can't open $logdir\\filehist$$.log: $!\n";
      @all_lines = <FILEHIST>;
      @lines_all = reverse @all_lines;
      close FILEHIST;

      # remove the history file for the next pass
      system ("del /F \"$logdir\\filehist$$.log\"") == 0
         or warn "Can't delete \"$logdir\\filehist$$.log\": $!\n";
      $change_user = "";
      $change_date = "";
      $change_time = "";
      $comment = "";
      $label = "";
      $label_comment = "";
      $version = -99;
      $version_count = 0;
      $identical_versions = 0;
      LINE: foreach $line (@lines_all)
      {
         if ($line=~/^$/)  # skip blank lines
         {
            next LINE;
         }

         if ($line=~/^History of /) # skip title
         {
            next LINE;
         }

         #  check for comment
         if ($line =~ /^Comment:/)
         {
            if (($F1, $comment) = split(' ', $line, 2))
            {
               chomp($comment);
               $comment =~ s|\"|:|g;
               $comment =~ s|\'|:|g;
               next LINE;
            }
         }

         #  check for label comment
         if ($line =~ /^Label comment:/)
         {
            # BUG FIX (PAG) - "Label comment" is 2 fields!
            if (($F1, $F2, $label_comment) = split(' ', $line, 3))
            {
               chomp($label_comment);
               $label_comment =~ s|\"|:|g;
               $label_comment =~ s|\'|:|g;
               next LINE;
            }
         }

         #  check for label 
         if ($line =~ /^Label:/)
         {
            if (($F1, $label) = split(' ', $line, 2))
            {
               chomp($label);
               $label;
               next LINE;
            }       
         }

         #  check for User/Date/Time 
         if ($line =~ /^User:/)
         {
            if (($F1, $change_user, $F2, $change_date, $F3, $change_time) = split(' ', $line, 6))
            {
               chomp($change_user);
               chomp($change_date);
               chomp($change_time);
               chop($change_time);

               if ($take_snapshot_only == 0)
               {

                  # see if the user exists as a Harvest user
                  open (USERLIST, ">$logdir\\userlist$$.sql") or die "Can't open $logdir\\userlist$$.sql: $!\n";
                  print USERLIST ( "select usrobjid from harallusers where username = \'$change_user\'\n");
                  close USERLIST;

                  system ("hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" ") == 0
                     or die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed getting user: $?\n";

                  # parse the log file for errors
                  open (FILEUSER, "$logdir\\userlist$$.log") or die "Can't open $logdir\\userlist$$.log: $!\n";
                  @status = <FILEUSER>;
                  close FILEUSER;
                  $num_errors = 0;
                  $num_errors = grep /^W0009 /, @status;
                  print "The user who made the change is $change_user\n";
                  if ($num_errors > 0)
                  {
                     print "Creating a CCC/Harvest account for $change_user\n";

                     # Get the idcounter for the new user
                     open (USERLIST, ">$logdir\\userlist$$.sql") or die "Can't open $logdir\\userlist$$.sql: $!\n";
                     print USERLIST ( "select idcounter from harobjidgen where hartablename = \'harUser\'\n");
                     close USERLIST;

                     system ("hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" ") == 0
                        or die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed getting user id counter: $?\n";
                     
                     # parse the log file for the idcounter
                     open (FILEUSER, "$logdir\\userlist$$.log") or die "Can't open $logdir\\userlist$$.log: $!\n";
                     @status = <FILEUSER>;
                     close FILEUSER;
                     
                     # check for Oracle warnings/errors
                     if (grep /^E([0-9]){4} /, @status)
                     {
                        die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle error: $?\n";
                     }
                     if (grep /^W([0-9]){4} /, @status)
                     {
                        die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle warning: $?\n";
                     }

                     foreach $entry (@status)
                     {
                        if ($entry =~ /^IDCOUNTER /)
                        {
                           if (($F1, $F2, $change_user_id) = split(' ', $entry, 3))
                           {
                              chomp($change_user_id);
                           }
                        }
                     }
                     print "The user id is $change_user_id\n";

                     # Bump the idcounter for users
                     open (USERLIST, ">$logdir\\userlist$$.sql") or die "Can't open $logdir\\userlist$$.sql: $!\n";
                     print USERLIST ( "update harobjidgen set idcounter = idcounter + 1 where hartablename = \'harUser\';\n");
                     print USERLIST ( "exit" );
                     close USERLIST;

                     system ("sqlplus $ousr/$opw\@$ohost @\"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" ") == 0
                        or die "sqlplus $ousr/$opw\@$ohost @\"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed while updating harversions: $?\n";


                     # parse the log file for errors/warnings
                     open (FILEUSER, "$logdir\\userlist$$.log") or die "Can't open $logdir\\userlist$$.log: $!\n";
                     @status = <FILEUSER>;
                     close FILEUSER;

                     # check for Oracle warnings/errors
                     if (grep /^E([0-9]){4} /, @status)
                     {
                        die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle error: $?\n";
                     }
                     if (grep /^W([0-9]){4} /, @status)
                     {
                        die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle warning: $?\n";
                     }

                     # Create the new user
                     open (USERLIST, ">$logdir\\userlist$$.sql") or die "Can't open $logdir\\userlist$$.sql: $!\n";
                     print USERLIST ( "insert into haruser ");
                     print USERLIST ( "(usrobjid,username,realname,loggedin,encryptpsswd,");
                     print USERLIST ( "creationtime,creatorid) ");
                     print USERLIST ( "values ($change_user_id,\'$change_user\',\'$change_user\',\'N\',\'FgtNrhy\',sysdate,$creator_id);\n");
                     print USERLIST ( "exit");
                     close USERLIST;

                     system ("sqlplus $ousr/$opw\@$ohost @\"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" ") == 0
                        or die "sqlplus $ousr/$opw\@$ohost @\"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed while updating harversions: $?\n";


                     # parse the log file for errors/warnings
                     open (FILEUSER, "$logdir\\userlist$$.log") or die "Can't open $logdir\\userlist$$.log: $!\n";
                     @status = <FILEUSER>;
                     close FILEUSER;

                     # check for Oracle warnings/errors
                     if (grep /^E([0-9]){4} /, @status)
                     {
                        die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle error: $?\n";
                     }
                     if (grep /^W([0-9]){4} /, @status)
                     {
                        die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle warning: $?\n";
                     }

                     # Continue creating the new user
                     open (USERLIST, ">$logdir\\userlist$$.sql") or die "Can't open $logdir\\userlist$$.sql: $!\n";
                     print USERLIST ( "insert into harallusers ");
                     print USERLIST ( "(usrobjid,username,realname,loggedin,encryptpsswd,");
                     print USERLIST ( "creationtime,creatorid) ");
                     print USERLIST ( "values ($change_user_id,\'$change_user\',\'$change_user\',\'N\',\'FgtNrhy\',sysdate,$creator_id)");
                     close USERLIST;

                     print ("sqlplus \"$ousr\"/\"$opw\"@\"ohost\" @\"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" ");
                     system ("sqlplus \"$ousr\"/\"$opw\"@\"ohost\" @\"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" ") == 0
                        or die "sqlplus \"$ousr\"/\"$opw\"@\"ohost\" @\"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed while inserting harallusers: $?\n";

                     # parse the log file for errors/warnings
                     open (FILEUSER, "$logdir\\userlist$$.log") or die "Can't open $logdir\\userlist$$.log: $!\n";
                     @status = <FILEUSER>;
                     close FILEUSER;

                     # check for Oracle warnings/errors
                     if (grep /^E([0-9]){4} /, @status)
                     {
                        die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle error: $?\n";
                     }
                     if (grep /^W([0-9]){4} /, @status)
                     {
                        die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle warning: $?\n";
                     }
                  }
               }
               next LINE;
            }       
         }

         #  check for field that doesn't have a version, it must be a labeled version
         if ($line =~ /^\*+$/)
         {
            print "Labeled version detected\n";
            if ($take_snapshot)
            {
               # if the label hasn't been detected, then create a new snapshot
               $my_label = $label;
               $my_label =~ s/\"//g;    #remove quotes
               $labeled = grep /\Q$my_label/, @labels;
               if ($labeled == 0)
               {
                  push @labels, $my_label;
                  print "Creating new snapshot view $label of $view in $env by $huser...\n";
                  system "sqlplus.exe -s $OraConnect \@'$sqlloc\\takesnapshots.sql' '$husr' '$env' '$view' '$label' ";
               }
               else
               {
                  print "Existing snapshot $label detected\n";
               }

               # if a version hasn't been loaded, then do nothing
               if ($version != -99)
               {
                  print "Adding the current version to the snapshot $label\n";

                  # adjust the version number down by one since Harvest starts with version 0
                  # and VSS starts with version 1
                  $this_version = $version_count - 1;

                  # change $reppath from the form /xxx/xxx to the form xxx/xxx/
                  $reppath = substr($newviewpath,1,length($newviewpath)-1) . "/";
                  print "reppath is $reppath\n";
                  if ($server eq "UNIX")
                  {
                     # $reppath format is xxx/yyy/zzz/
                     $reppath =~ s/\\|\//\//g;
                  }
                  elsif ($server eq "WINDOWS")
                  {
                     # $newviewpath format is xxx\yyy\zzz\
                     $reppath =~ s/\\|\//\\/g;
                  }
                  else
                  {
                     die "Invalid server type $server.\n";
                  }

                  system "sqlplus.exe -s $OraConnect \@'$sqlloc\\version_snapper.sql' '$env' '$label' '$reppath' '$_' '$this_version' ";
               }
               else
               {
                  print "No initial version available for shapshot $label\n";
               }
            }
            $comment = "";
            $label = "";
            $label_comment = "";
            next LINE;
         }

         #  check for version
         if ($line =~ /^\*+ +Version +([0-9]+) +\*+$/)
         {
            if (($F1, $F2, $version, $F3) = split(' ', $line, 4))
            {
               $version_count++;
            
               if ($take_snapshot_only == 0)
               {
                  chomp ($version);
                  if ($comment ne "")
                  {
                       print "Comment for version $version of $_ : $comment\n";
                  }
                  if (($label ne "") or ($label_comment ne ""))
                  {
                       print "Label is $label with comment: $label_comment\n";
                  }

                  # check out the item from Source Safe
                  print "ss Get \"$project/$_\" \"-GWRL$newwdir\" -V$version -I-Y \"-O$logdir\\fileget$$.log\"\n";
                  system ("ss Get \"$project/$_\" \"-GWRL$newwdir\" -V$version -I-Y \"-O$logdir\\fileget$$.log\" -Y$vusr,$vpw") == 0
                     or die "ss Get \"$project/$_\" \"-GWRL$newwdir\" -V$version -I-Y \"-O$logdir\\fileget$$.log\" -Y$vusr,$vpw failed: $?\n";

                  # remove the get log file for the next pass
                  if ($keep_logs == 0)
                  {
                     system ("del /F \"$logdir\\fileget$$.log\"") == 0
                        or warn "Can't delete \"$logdir\\fileget$$.log\": $!\n";
                  }

                  #check if the file actually got checked out
                  print "The test is on : '$newwdir\\$_' \n";
                  if (-e "$newwdir\\$_")
                  {
                     $skip_version = 0;
		     print PROGRESSFILE ("GET: $reppath\\$_;$version\n");

                     $hci_count = $attempts; #maximum number of attempts
                     HCI1: while ($hci_count > 0)
                     {                          
                        # check all the item versions to Harvest using update and keep checked out options
                        print ("A: hci \"$_\" -b \"$broker\" -en \"$env\" -st \"$state\" -p \"$pkg\" -vp \"$newviewpath\" -pn \"$ciproc\" -op pc -uk -de \"$comment.\" -usr \"$husr\" -pw \"$hpw\" -oa \"$logdir\\filehci$$.log\" \n");
                        system ("hci \"$_\" -b \"$broker\" -en \"$env\" -st \"$state\" -p \"$pkg\" -vp \"$newviewpath\" -pn \"$ciproc\" -op pc -uk -de \"$comment.\" -usr \"$husr\" -pw \"$hpw\" -oa \"$logdir\\filehci$$.log\" ") == 0
                           or warn "hci \"$_\" -b \"$broker\" -en \"$env\" -st \"$state\" -p \"$pkg\" -vp \"$newviewpath\" -pn \"$ciproc\" -op pc -uk -de \"$comment.\" -usr \"$husr\" -pw \"$hpw\" -oa \"$logdir\\filehci$$.log\" failed: $?\n";

                        # parse the log file for errors
                        open (FILEHCI, "$logdir\\filehci$$.log") or die "Can't open $logdir\\filehci$$.log: $!\n";
                        @status = <FILEHCI>;
                        close FILEHCI;
                        $num_errors = 0;
                        $num_errors = grep /^E([0-9]){4} /, @status;
			#
			# Check for info message reporting no differences found.
			#
			$no_delta = grep /^I0209/, @status;
                        print "Number of HCI attempts is $hci_count\n";
                        print "Number of HCI errors is $num_errors\n";
                        if ($num_errors > 0)
                        {
                           $no_server = 0;
                           $no_server = grep /^E07([0-9]){2} /, @status;
                           if ($no_server)
                           {
                              $hci_count--;
                              if ($hci_count == 0)
                              {
                              die "Can't connect to Harvest Server after $attempts attempts.\n";
                              }
                              sleep $time_out;
                           }
                           else
                           {
                              die "HCI error, see $logdir\\filehci$$.log for details: $!\n";
                           }
                        }
                        elsif ($no_delta == 0)
                        {
			   # We have NOT had an I0209 (no difference found) error message.
			   # Therefore, we have created a delta that needs processing.
			   #
                           # remove the hci log file for the next pass
                           system ("del /F \"$logdir\\filehci$$.log\"") == 0
                              or warn "Can't delete \"$logdir\\filehci$$.log\": $!\n";

                           # adjust the version number down by one since Harvest starts with version 0
                           # and VSS starts with version 1
                           $this_version = ($version_count - $identical_versions) - 1;
		           print PROGRESSFILE ("INIT PUT $this_version\n");

                           # change $reppath from the form /xxx/xxx to the form xxx/xxx/
                           $reppath = substr($newviewpath,0,length($newviewpath));
                           print "reppath is $reppath\n";
                           if ($server eq "UNIX")
                           {
                              # $reppath format is xxx/yyy/zzz/
                              $reppath =~ s/\\|\//\//g;
                           }
                           elsif ($server eq "WINDOWS")
                           {
                              # $newviewpath format is xxx\yyy\zzz\
                              $reppath =~ s/\\|\//\\/g;
                           }
                           else
                           {
                              die "Invalid server type $server.\n";
                           }

                           # get the user id from Harvest
                           open (USERLIST, ">$logdir\\userlist$$.sql") or die "Can't open $logdir\\userlist$$.sql: $!\n";
                           print USERLIST ( "select usrobjid from harallusers where username = \'$change_user\'\n");
                           close USERLIST;

                           system ("hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" ") == 0
                              or die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed getting user: $?\n";

                           # parse the log file for the userobjid
                           open (FILEUSER, "$logdir\\userlist$$.log") or die "Can't open $logdir\\userlist$$.log: $!\n";
                           @status = <FILEUSER>;
                           close FILEUSER;

                           # check for Oracle warnings/errors
                           if (grep /^E([0-9]){4} /, @status)
                           {
                              die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle error: $?\n";
                           }
                           if (grep /^W([0-9]){4} /, @status)
                           {
                              die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle warning: $?\n";
                           }

                           foreach $entry (@status)
                           {
                              if ($entry =~ /^USROBJID /)
                              {
                                 if (($F1, $F2, $user_obj_id) = split(' ', $entry, 3))
                                 {
                                    chomp($user_obj_id);
                                 }
                              }
                           }
                           
                           print "The userobjid is $user_obj_id\n";
			                             
                           # get the versioned object id
                           open (USERLIST, ">$logdir\\userlist$$.sql") or die "Can't open $logdir\\userlist$$.sql: $!\n";
                           print USERLIST ( "SELECT DISTINCT V.versionobjid \n");
                           print USERLIST ( "FROM \n");
                           print USERLIST ( "harpathfullname T,");
                           print USERLIST ( "haritems I,");
                           print USERLIST ( "harversions V,");
                           print USERLIST ( "harversioninview W,");
                           print USERLIST ( "harstate S,");
                           print USERLIST ( "harenvironment E \n");
                           print USERLIST ( "WHERE \n");
                           print USERLIST ( "E.environmentname = \'$env\' and \n");
                           print USERLIST ( "T.pathfullname = \'$reppath\' and \n");
                           print USERLIST ( "I.itemname = \'$_\' and \n");
                           print USERLIST ( "V.mappedversion = \'$this_version\' and \n");
                           print USERLIST ( "E.envobjid = S.envobjid and \n");
                           print USERLIST ( "S.viewobjid = W.viewobjid and \n");
                           print USERLIST ( "W.versionobjid = V.versionobjid and \n");
                           print USERLIST ( "V.itemobjid = I.itemobjid and \n");
                           print USERLIST ( "I.parentobjid = T.itemobjid ");
                           close USERLIST;

                           system ("hsql -b \"$broker\" -f \"$logdir\\userlist$$.sql\" -usr \"$husr\" -pw \"$hpw\" -o \"$logdir\\userlist$$.log\" ") == 0
                              or die "hsql -b \"$broker\" -f \"$logdir\\userlist$$.sql\" -usr \"$husr\" -pw \"$hpw\" -o \"$logdir\\userlist$$.log\" failed while getting versionobjid: $?\n";

                           # parse the log file for the versionobjid
                           open (FILEUSER, "$logdir\\userlist$$.log") or die "Can't open $logdir\\userlist$$.log: $!\n";
                           @status = <FILEUSER>;
                           close FILEUSER;

                           # check for Oracle warnings/errors
                           if (grep /^E([0-9]){4} /, @status)
                           {
                              die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle error: $?\n";
                           }
                           if (grep /^W([0-9]){4} /, @status)
                           {
                              warn "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle warning: $?\n";
                           }

                           foreach $entry (@status)
                           {
                              if ($entry =~ /^VERSIONOBJID /)
                              {
                                 if (($F1, $F2, $version_obj_id) = split(' ', $entry, 3))
                                 {
                                    chomp($version_obj_id);
                                 }
                              }
                           }
                           print "The versionobjid is $version_obj_id\n";

                           # update the version's creator id, creation (checkin)
                           # time, and file mod time
                           # 06-18-2008 | data was split out into 2 tables in recent 
                           #--------------------updates (probably Harvest 5.x - when blob was introduced)
                           #--------------------These changes now require 2 updates to process
                           #--------------------first update to creatorid and modifierid to reflect original VSS user
                           #-------------------- - - - - these changes occur in the table HARVERSIONS
                           #--------------------second update to createtime and modifytime use another table
                           #-------------------- - - - - these changes occur in the table HARVERSIONDATA
                           open (USERLIST, ">$logdir\\userlist$$.sql") or die "Can't open $logdir\\userlist$$.sql: $!\n";
                           print USERLIST ( "update harversions ");
                           print USERLIST ( "set ");
                           print USERLIST ( "creatorid = \'$user_obj_id\', ");
                           print USERLIST ( "modifierid = \'$user_obj_id\' ");
                           print USERLIST ( "where ");
                           print USERLIST ( "versionobjid = \'$version_obj_id\';\n");
                           print USERLIST ( "commit; \n");
                           print USERLIST ( "update harversiondata ");
                           print USERLIST ( "set ");
                           print USERLIST ( "createtime = NEW_TIME(TO_DATE(\'$change_date $change_time");
                           print USERLIST ( "\',\'MM/DD/YY HH24:MI\'),\'$time_zone\',\'GMT\'),");
                           print USERLIST ( "modifytime = NEW_TIME(TO_DATE(\'$change_date $change_time");
                           print USERLIST ( "\',\'MM/DD/YY HH24:MI\'),\'$time_zone\',\'GMT\') ");
                           print USERLIST ( "where ");
                           print USERLIST ( "versiondataobjid= ");
                           print USERLIST ( "(select versiondataobjid ");
                           print USERLIST ( "from harversions ");
                           print USERLIST ( "where ");
                           print USERLIST ( "versionobjid = \'$version_obj_id\');\n");
                           print USERLIST ( "commit; \n");
                           print USERLIST ( "exit");
                           close USERLIST;

                           print ("sqlplus $ousr/$opw\@$ohost @\"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" ");
                           system ("sqlplus $ousr/$opw\@$ohost @\"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" ") == 0
                              or die "sqlplus $ousr/$opw\@$ohost @\"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed while updating harversions: $?\n";

                           # parse the log file for errors/warnings
                           open (FILEUSER, "$logdir\\userlist$$.log") or die "Can't open $logdir\\userlist$$.log: $!\n";
                           @status = <FILEUSER>;
                           close FILEUSER;

                           # check for Oracle warnings/errors
                           if (grep /^E([0-9]){4} /, @status)
                           {
                              die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle error: $?\n";
                           }
                           if (grep /^W([0-9]){4} /, @status)
                           {
                              warn "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle warning: $?\n";
                           }

			   # All okay. Record the filename (full path) and the version number
			   # in our progress file. If we are rerunning a migration then we will
			   # ignore all file versions recorded in this file.
			   #
			   print "Logging: $reppath\\$_;$this_version\n";
			   print PROGRESSFILE ("PUT: $reppath\\$_;$this_version\n");
			   
                           last HCI1;
                        }
			else
			{
				# $no_delta must be non zero
				#
				print "No differences found from previous version - not checked in\n";
				$skip_version = 1;
				$identical_versions++;
				last HCI1;		# next version.
			}

                        # remove the hci log file for the next pass
                        system ("del /F \"$logdir\\filehci$$.log\"") == 0
                           or warn "Can't delete \"$logdir\\filehci$$.log\": $!\n";
                     }
                  }
                  else
                  {
                     $skip_version = 1;
                     print "Unable to retrieve a version from VSS\n";
                  }
               }
               $comment = "";
               $label = "";
               $label_comment = "";
#               $version = -99;
               next LINE;
            }
         }
      }

      if (($take_snapshot_only == 0) and $skip_version == 0)
      {
         $hci_count = $attempts;  #maximum number of attempts
         HCI2: while ($hci_count > 0)
         {                          
            # check in the last version of an item to Harvest using update and release option
            print ("B: hci \"$_\" -b \"$broker\" -en \"$env\" -st \"$state\" -p \"$pkg\" -vp \"$newviewpath\" -pn \"$ciproc\" -op pc -ur -de \"$comment.\" -usr \"$husr\" -pw \"$hpw\" -oa \"$logdir\\filehci$$.log\" \n");
            system ("hci \"$_\" -b \"$broker\" -en \"$env\" -st \"$state\" -p \"$pkg\" -vp \"$newviewpath\" -pn \"$ciproc\" -op pc -ur -de \"$comment.\" -usr \"$husr\" -pw \"$hpw\" -oa \"$logdir\\filehci$$.log\" ") == 0
               or warn "hci \"$_\" -b \"$broker\" -en \"$env\" -st \"$state\" -p \"$pkg\" -vp \"$newviewpath\" -pn \"$ciproc\" -op pc -ur -de \"$comment.\" -usr \"$husr\" -pw \"$hpw\" -oa \"$logdir\\filehci$$.log\" failed: $?\n";

            # parse the log file for errors
            open (FILEHCI, "$logdir\\filehci$$.log") or die "Can't open $logdir\\filehci$$.log: $!\n";
            @status = <FILEHCI>;
            close FILEHCI;

            $num_errors = 0;
            $num_errors = grep /^E([0-9]){4} /, @status;
            print "Number of HCI errors is $num_errors\n";
            if ($num_errors > 0)
            {
               $no_server = 0;
               $no_server = grep /^E07([0-9]){2} /, @status;
               if ($no_server)
               {
                  $hci_count--;
                  if ($hci_count == 0)
                  {
                  die "Can't connect to Harvest Server after $attempts attempts.\n";
                  }
                  sleep $time_out;
               }
               else
               {
                  die "HCI error, see $logdir\\filehci$$.log for details: $!\n";
               }
            }
            else
            {
               # remove the hci log file for the next pass
               system ("del /F \"$logdir\\filehci$$.log\"") == 0
                  or warn "Can't delete \"$logdir\\filehci$$.log\": $!\n";

               last HCI2;
            }

            # remove the hci log file for the next pass
            system ("del /F \"$logdir\\filehci$$.log\"") == 0
               or warn "\"Can't delete $logdir\\filehci$$.log\": $!\n";
         }
      }
      # remove the file for the next pass
      if ($keep_files == 1)
      {
         print "Deleting item $_\n";
         system ("del /F \"$_\"") == 0
            or warn "Can't delete \"$_\": $!\n";
      }

   }

   close FILELIST;
   close PROGRESSFILE;
   chdir "$logdir" or die "Can't cd to $logdir: $!\n";
   if ($need_repository eq 0)
   {
        # filehist only created if need_repository is 0
        system ("del /F filehist$$.log") == 0 or warn "del filehist$$.log failed: $!\n";
   }
   system ("del /F filelist$$.log") == 0 or warn "del filelist$$.log failed: $!\n";
   system ("del /F userlist$$.log") == 0 or warn "del userlist$$.log failed: $!\n";
   system ("del /F userlist$$.sql") == 0 or warn "del userlist$$.sql failed: $!\n";
}
if ($need_repository eq 0)
{
	print "Done VSS to Harvest conversion.\n";
}
else
{
	print "Done Creating Empty Repository.\n";
}

print "error code = $error_exit\n";


print "Stop time:";
$systime=system ("time /T");
print $systime "\n";

# reset STDOUT and STDERR back to normal

close STDOUT;
close STDERR;

open STDOUT, ">&SAVEOUT";
open STDERR, ">&SAVEERR";

#remove the log files
if ($keep_logs == 0)
{
   system ("del /F vss2h$$.log")    == 0 or warn "del vss2h$$.log failed: $!\n";
}

if ($need_repository eq 1)
{
	print "Created Empty Repository Structure in $wdir\n";
	print "Use the Repository Editor tool of Harvest Admin\n";
	print "to LOAD this repository before attempting to\n";
	print "to populate.\n";
}

print "Done.\n";
system("pause");
exit $error_exit;
