#!/usr/bin/perl
 
#--------------------------------------------------------------
# ReserveItems.pl                                             |
#                                                             |
# This server side UDP reads a list of files from stdin and   |
# reserves the corresponding versions in the Harvest          |
# respository.  When run as a pre-link to a checkin process,  |
# it will reserve the necessary items so that an explicit     |
# reserve or checkout is not required.                        |
#                                                             |
# To setup:                                                   |
#                                                             |
# 1) Create a server side pre-link to a checkin process.      |
#                                                             |
# 2) In the pre-link "program" field type:                    |
#    perl d:ReserveItems.pl                                   |
#         -b   [broker]                                       |
#         -en  [environment]                                  |
#         -st  [state]                                        |
#         -vp "[viewpath]"                                    |
#         -cp "[clientpath]"                                  |
#         -p  ["package"]                                     |
#         -usr [user]                                         |
#         -pw  [password]                                     |
#         -pn  "Checkout for update"                          |
#         -o   "c:\temp\log.txt"                              |
#         -cl  nnn                                            |
#         -ro                                                 |
#                                                             |
# For the [password] system variable to work, you must have   |
# sysvarpw = 'Y' in the Oracle harTableInfo table.            | 
#                                                             |
# -pn signifies a standard checkout process with at least the |
# "reserve only" box checked.  This process is used to reserve|
# the items prior to checkin.                                 |
#                                                             |
# -cl signifies the command line limit on the client machine. |
# If the list of files exceeds this limit, then the hco       |
# command to reserve the items is split into two or more      |
# separate commands.  eg. -cl 2048                            |
# If not passed, defaults to 1024                             |
#                                                             |
# -ro signifies that you want to stop once the reserve is     |
# complete.  This option will cause the script to exit with a |
# non zero return code, so that the checkin doesn't go ahead. |
#                                                             |
# 3) In the input field type:                                 |
# [file]                                                      |
#                                                             |
# This script requires at least Harvest 5.1.1 with service    |
# pack 2.                                                     |
#                                                             |
# This script has been tested on both a Unix and Windows      |
# server.                                                     |
#--------------------------------------------------------------
# V0 10/04/2004 Gavin Barrett                                 |
#--------------------------------------------------------------

#--------------------------------------------------------------
# Mainline                                                    |
#                                                             |
# - Define Global variables                                   |
# - Do initialisation                                         |
# - Get command line and system variables                     |
# - Process stdin (contains list of files to be reserved).    |
#   - Build the viewpath for each file                        |
#   - Store the itemnames for each unique viewpath in an array|
#   - On change of viewpath, reserve all items in array       |
# - Perform final checkout for reserve                        |
# - Do finalisation                                           |
# - If the -ro option was passed, exit with a -1              |
#--------------------------------------------------------------

my($Log);
my($ProcessName);
my(@InfoMsgs);
my(@ErrorMsgs);
my(@Items);
my($FullViewpath);
my($ItemName);

Initialise();

my($Broker,$Environment,$State,$Viewpath,$Clientpath,$Package,$User,$MaxCmdLine,$Password,$ProcessName,$Log,$ReserveOnly,$debug) = GetSystemVariables();

while (<STDIN>) {
   chomp;
   print "\nfrom stdin: $_ \n" if $debug;
   next if $_ eq "";
   ($FullViewpath, $ItemName) = GetVersionDetails($_);
   if (($FullViewpath ne $PreviousFullViewpath) 
   and ($PreviousFullViewpath ne "")) {
      ReserveItems($PreviousFullViewpath);
   }
   $PreviousFullViewpath = $FullViewpath;
   push (@Items, $ItemName);
   next if /^\s*$/;
}

ReserveItems();

Finalise();

if ($ReserveOnly) {
   print ".\n";
   print "Ignore the following error messages - they are intentional \n";
   print "\n.";
   exit(-1);
}
else {
   exit(0);
}

##################
#                #
 sub Initialise {
#                #
##################

use Getopt::Long;
use File::Basename;
use strict;

push (@InfoMsgs,".\n");

}

##########################
#                        #
 sub GetSystemVariables {
#                        #
##########################

#----------------------------------------------------------------
# Reads the Harvest system variables that were passed on the    |
# command line.                                                 |
#----------------------------------------------------------------

GetOptions('b=s', 'en=s','st=s', 'vp=s', 'cp=s', 'p=s', 'usr=s', 'pw=s', 'pn=s', 'o=s', 'cl=s', 'ro', 'debug');

my($Broker)            = $opt_b;
my($Environment)       = $opt_en;
my($State)             = $opt_st;
my($Viewpath)          = $opt_vp;
my($Clientpath)        = $opt_cp;
my($Package)           = $opt_p;
my($User)              = $opt_usr;
my($MaxCmdLine)        = $opt_cl;
my($Password)          = $opt_pw;
my($ProcessName)       = $opt_pn;
my($Log)               = $opt_o;
my($ReserveOnly)       = $opt_ro;
my($debug)             = $opt_debug;

if ($debug == 1) {
   print "\n";
   print "Broker:       $Broker \n";
   print "Environment:  $Environment \n";
   print "State      :  $State \n";
   print "Viewpath   :  $Viewpath \n";
   print "Clientpath :  $Clientpath \n";
   print "Package    :  $Package \n";
   print "User       :  $User \n";
   print "MaxCmdLine :  $MaxCmdLine \n";
   print "Password   :  $Password \n";  
   print "ProcessName:  $ProcessName \n";
   print "Log        :  $Log \n";
   print "ReserveOnly:  $ReserveOnly \n";
   print "debug      :  $debug \n";
   print "\n";
}

# Set default max command line value if one is not passed to this script
if ($MaxCmdLine eq "") {
   $MaxCmdLine = 1024;
}

# Stop if a mandatory variable is not passed
if (($Broker      eq "")
or  ($Environment eq "")
or  ($State       eq "")
or  ($Viewpath    eq "")
or  ($Clientpath  eq "")
or  ($Package     eq "")
or  ($User        eq "")
or  ($Password    eq "")
or  ($ProcessName eq "")
or  ($Log         eq "")) { 
    print "Usage:                        \n";
    print " perl d:\\ReserveItems.pl     \n";                                 
    print " -b   [broker]                \n";                                     
    print " -en  \"[environment]\"       \n";                                 
    print " -st  \"[state]\"             \n";                                       
    print " -vp \"[viewpath]\"           \n";                                   
    print " -cp \"[clientpath]\"         \n";                                
    print " -p  [\"package\"]            \n";                                  
    print " -usr [user]                  \n";                                     
    print " -pw  [password]              \n";                                 
    print " -pn \"Checkout processname\" \n";
    print " -o \"c:\\temp\\log.txt\"     \n";
    exit(1);
}

return ($Broker, $Environment, $State, $Viewpath, $Clientpath, $Package, $User, $MaxCmdLine, $Password, $ProcessName, $Log, $ReserveOnly, $debug);

}

#########################
#                       #
 sub GetVersionDetails {
#                       # 
#########################

#----------------------------------------------------------------
# Formulates the fullviewpath and itemname based on the         |
# [file] passed by Harvest and also the [viewpath] and          |
# [clientpath].  For example:                                   |
#                                                               |
#   $File       = "mymachine\\c:\dir1\dir2\a.txt"               |
#   $Clientpath = "mymachine\\c:\dir1"                          |
#   $Viewpath   = "/myrepos/dir1"                               |
# Produces:                                                     |
#   $Fullviewpath = "/myrepos/dir1/dir2                         |
#   $ItemName     = "a.txt"                                     |
#----------------------------------------------------------------
my($File) = $_;
my ($FullViewpath);
my($ItemName);
my($Ext);
print "File: $File \n" if $debug;

# Split fullpathname into base directory and filename
$File =~ s/\\/\//g; # change back to forward slash
@parts = split("/",$File);
my($Filename) = pop(@parts);
print "Filename: $Filename \n" if $debug;
my($BaseDir) = join("/",@parts);
print "BaseDir: $BaseDir \n" if $debug;

# Get part of filename that extends beyond the clientpath and add it to end of viewpath
$Ext = substr($BaseDir,length($Clientpath)+1,length($BaseDir)-length($Clientpath)-1);
print "Ext: $Ext \n" if $debug;
$FullViewpath = "$Viewpath" . "$Ext";
print "FullViewpath: $FullViewpath \n" if $debug;

# return the viewpath and itemname
$ItemName = "\"$Filename\"";
print "ItemName: $ItemName \n" if $debug;
return($FullViewpath, $ItemName);
}

####################
#                  #
 sub ReserveItems {
#                  # 
####################

#----------------------------------------------------------------
# Executes a hco reserve command for each unique viewpath.  If  |
# the number of items to be reserved causes the command line    |
# limit to be exceeded, then the hco command is split into two  |
# or more separate commands.                                    |
#----------------------------------------------------------------

my($PreviousFullViewPath) = $_;

print "\n\nProcessing hco for: $PreviousFullViewpath \n" if $debug;
my($initial_cmd) = "hco -b $Broker -en \"$Environment\" -st \"$State\" -vp \"$PreviousFullViewpath\" -p \"$Package\" -pn \"$ProcessName\" -usr $User -pw $Password -ro -o $Log ";
my($cmd) = $initial_cmd;
my($ItemList) = "";
my($i);
my($TotalLength);
for ($i=0;$i<@Items;$i++) {
    $TotalLength = length($cmd) + length($ItemList);
    if ($TotalLength >= $MaxCmdLine) {
        $cmd = $cmd . " " . $ItemList;
        print "cmd1: $cmd\n" if $debug;
        `$cmd`;
        $cmd = $initial_cmd;;
        StoreLog();
        $ItemList = "";
    }
    $ItemList = $ItemList . " " . $Items[$i];
}

$cmd = $cmd . " " . $ItemList;
print "cmd2: $cmd\n" if $debug;
`$cmd`;  
StoreLog();
@Items = ();

}


################
#              #
 sub StoreLog {
#              # 
################

# Store the log entries
open (LOG,"<$Log");
@LogList = <LOG>;
close (LOG);
push (@InfoMsgs,grep { /reserved/ } @LogList);
push (@ErrorMsgs,grep { /E0/ } @LogList);

}

################
#              #
 sub Finalise {
#              # 
################

#----------------------------------------------------------------
#  Display the information messages from the reserve to the log.|
#  Display any error messages last so they are obvious.         |
#----------------------------------------------------------------

foreach (@InfoMsgs) {
    print "$_";
}

foreach (@ErrorMsgs) {
    if (substr($_,0,11) ne "E03060019: ") {
       print "$_";
    }
}

chmod 0744, $log;
unlink($log) unless $debug;

}