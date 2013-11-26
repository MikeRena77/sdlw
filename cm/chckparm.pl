#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   chckparm.pl  $
#*               $Revision:   1.24  $
#*               $Date:   27 Jan 2006 14:32:22  $
#*
#* DESCRIPTION:  Check parameters
#*               
#* MODIFICATION/REV HISTORY:
#* $Log:   P:/vcs/cm/chckparm.plv  $
#* 
#*    Rev 1.24   27 Jan 2006 14:32:22   SMcBrayer
#* Added new project:  BP EPS.
#* 
#*    Rev 1.23   01 Feb 2005 15:28:28   SMcBrayer
#* Add support for Marathon (MAP) project.
#* 
#*    Rev 1.22   15 Apr 2004 16:51:52   GraceL
#* Added "S:" for Buypass project.
#* 
#*    Rev 1.21   13 Apr 2004 13:29:16   GraceL
#* Added "NBuypass" into the project list.
#* 
#*    Rev 1.20   03 Sep 2002 11:08:52   gracel
#* Added NBPAMOCO for BP RESPONS release1.
#* 
#*    Rev 1.19   05 Aug 2002 09:33:16   CraigL
#* Changes for new server.
#* 
#*    Rev 1.18   Dec 12 2001 12:41:02   GraceP
#* Added a blank entry for PL for Canada Project also added
#* a drive letter S:
#* 
#*    Rev 1.17   Nov 28 2001 11:23:38   GraceP
#* added nshell and ncanada
#* 
#*    Rev 1.16   Oct 01 2001 11:13:02   GraceP
#* Add NTEquiva project
#* 
#*    Rev 1.15   Sep 11 2001 08:55:04   JACIC
#* Added NCITGO, NADS, updated PE names.
#* 
#*    Rev 1.14   Aug 14 2000 09:45:08   GraceP
#* Add GraceP to SUN project.
#* 
#*    Rev 1.13   Jun 22 2000 11:32:28   BMASTER
#* Added Sun into project list
#* 
#*    Rev 1.12   Mar 13 2000 17:18:00   brettl
#* added BP, updated PEs to reflect current assignments
#* 
#*    Rev 1.11   Aug 11 1999 17:39:50   brettl
#* Changed Chevron PE from jaci to brett
#* 
#*    Rev 1.10   Dec 04 1998 13:18:32   seanl
#* Added simdev, nsim to project list.
#* 
#*    Rev 1.9   Sep 03 1998 16:52:50   brettl
#* added uppercase translation of project and label, on os/2 the command
#* shell did this for us.
#* 
#*    Rev 1.8   Aug 31 1998 19:12:48   brettl
#* Added Base 8.0, changed default base PE to BrettL, added support for
#* base release specific PEs. Set MajeedA as Base 7.0's PE.
#* 
#*    Rev 1.7   Jul 25 1998 16:12:20   brettl
#* changed mobil pe to carlJ
#* 
#*    Rev 1.6   Jul 21 1998 16:41:58   GraceP
#* Change Chevron PE to Jaci
#* 
#*    Rev 1.5   Mar 10 1998 14:53:08   JimL
#* Added Texaco project
#* 
#*    Rev 1.4   Oct 30 1997 08:54:16   BrettL
#* Changed PE for base, starter to MajeedA
#* 
#*    Rev 1.3   26 Jun 1997 14:39:36   BrettL
#* 
#* Removed assumption that project name and network sharename are
#* always the same.  Starting with Base70 they are not (NTBASE share, NBASE
#* project name)
#* 
#*    Rev 1.2   26 Jun 1997 14:02:08   BrettL
#* Change NTBASE and NTSTART to the standard NBASE and NSTARTER.
#* Adde NCHEVRON/nancyn
#* 
#*    Rev 1.1   12 Jun 1997 18:58:58   BrettL
#* 
#* Changed Base PE to brettl and added Mobil project (PE=craigl)
#* 
#*    Rev 1.0   12 Jun 1997 18:56:02   BrettL
#* Initial revision.
#*
#*****************************************************************************
#/* end extraction */

require 'p:\cm\GetServerName.pl';

####this file should be reworked
####these lookup tables should be added to associated arrays in bldutils.pl
####this file can be greatly simplified by using associative arrays

#!!!!UPDATE THE DATA IN BLDUTILS.PL TOO!!!!
# AUS111W0025 = David Gindler
# AUS111L0096 = Grace Pena
# AUS111W0039 = Henry Gbedemah
# AUS111W0041 = Jaci Collins

@defaultpelist = ("Grace.Pena,Jaci.Collins,Henry.Gbedemah","Grace.Pena", "Henry.Gbedemah", "Jaci.Collins,Julio.Carvallo", "Grace.Li", "Tim.Green", "Grace.Li", "Jaci.Collins", "", "Jaci.Collins", "David.Gindler", "Grace.Li", "Grace.Li","Stephen.McBrayer", "Stephen.McBrayer", "Baolin.Li" );
@projlist =      ("NBASE", "NSTARTER", "NMOBIL", "NCHEVRON", "NSIM", "NSUN", "NCITGO",  "NCANADA", "NADS", "NSHELL", "NBPAMOCO", "NBuypass", "NMAP", "NBPEPS", "NFD" );
@sharenamelist = ("NTBASE", "NTSTART", "NMOBIL", "NCHEVRON", "SIMDEV", "NSUN", "NCITGO", "NCANADA", "NADS","NTSHELL", "NBPAMOCO", "NBuypass", "NMAP", "NBPEPS", "NFD" );
@drlist = ("Q:","S:","S:","S:", "Q:", "S:", "S:", "S:", "S:", "S:", "S:", "S:", "S:", "S:", "S:" );

%pelist =
(
  "BASE70"    => "ThomasN",
  "STARTER70" => "ThomasN",
);

$project = shift(@ARGV);
$project =~ tr/a-z/A-Z/;

$count = 0;
$isokay = 0;
foreach $isproj (@projlist) {
   if ($project =~ /^$isproj/i) {
      $drive = "@drlist[$count]";
      # is $drive set to correct $project
      # ex. if Q: is not set to \\$ServerName\nbase, die
      foreach $usline (`net use $drive`) {
         if ($usline =~ /@sharenamelist[$count]/i) {
            $isokay = 1;
         }
      }
      if (!($isokay)) {
         die "$drive is not set to \\\\$ServerName\\@sharenamelist[$count]\n";
      }
      $pe = @defaultpelist[$count];
   }
   $count = $count + 1;
} 

if (!($isokay)) {
   die "invalid project parameter";
}

$label = shift(@ARGV);
$label =~ tr/a-z/A-Z/;

# is the label valid??
if (!(length($label))) {
   die "build label must be specified\n";
}

#use the default PE unless there's a PE assigned to the specific release
if ($pelist{$label})
{
  $pe = $pelist{$label};
}

return 1;
