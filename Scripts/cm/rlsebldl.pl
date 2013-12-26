#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   rlsebld.pl  $
#*               $Revision:   1.0  $
#*               $Date:   Jun 02 1998 17:55:06  $
#*
#* DESCRIPTION:  Script used to release the build to the world.
#*
#* TARGET:       NT
#*
#* MODIFICATION/REV HISTORY:
#* $Log:   P:/vcs/cm/rlsebld.plv  $
#*  
#*     Rev 1.1   Aug 24 2010  David. Gindler
#*  Added support for Office 2007 and 2010
#*
#*     Rev 1.0   Jun 02 1998 17:55:06   BrettL
#*  Initial revision.
#* 
#*
#*****************************************************************************
# end extraction 

require 'p:\cm\bldutils.pl';

if ($#ARGV < 2 || $#ARGV > 3 || $ARGV[0] eq '-h' || $ARGV[0] eq '-H')
{
print <<HelpSection;

 Usage:  RLSEBLD <project> <bldlabel> <bldname> [swsn template file]

 This utility updates the release.num file information in the
 build summary file located in p:\latest to show 'released'.

 <project> identifies which drive will be used for linking to a
 particular project.  One of nbase, nshell, nbp, nchevron etc.

 <bldlabel> identifies which build release label to relate to.
 Ex. base22 shell22.

 <bldname> identifies which build the build notes will be created for
 and build summary updated for.  Ex. n0220ar sh0221a

 [template file] identifies the SWSN template file.  The standard
 template filename is used if no file is specified.

 Ex:  rlsebld nbase base22 n0220ar
 Ex:  rlsebld nbase base22 n0220ar SH05SSN.DOT

HelpSection
exit;
}

$project = "\U@ARGV[0]";
$bldLabel = "\U@ARGV[1]";
$bldName = "\U@ARGV[2]";
$bldStatus = "RELEASED";
&getProjectDrive(*drive, $project);

if ( $#ARGV == 3 ) # template specified explicitly
{
   $templateFile = "\U@ARGV[3]";
}
else #generate standard template filename
{
  $templateFile = $bldName;
  $templateFile =~ s/([A-Z]*\d\d\d).*$/\1SSN\.DOT/;
}

$templatePath = "$drive\\SWSN\\$templateFile";


#release the build
`perl -Ip:\\cm p:\\cm\\bldsmry.pl $project $bldLabel $bldName $bldStatus`;

$Office2003 = $ENV{'OFFICE2003'};

$Office2007 = $ENV{'OFFICE2007'};

$Office2010 = $ENV{'OFFICE2010'};
#$WordPath = "C:\\Program Files\\Microsoft Office\\Office11"
#if( !$Office2003 )
#{
#   $WordPath = "C:\\Program Files\\Microsoft Office\\Office10"
#}
#generate the swsn
#`\"$WordPath\\WINWORD.EXE " /t $templatePath /mAutoSWSN`

if( $Office2003 == 1)
{
`\"C:\\Program Files\\Microsoft Office\\Office11\\WINWORD.EXE\" /t $templatePath /mAutoSWSN`;
}
else 
{
   if ( $Office2007 == 1 )
   {
      `\"C:\\Program Files\\Microsoft Office\\Office12\\WINWORD.EXE\" /t $templatePath /mAutoSWSN`;
   }
   else
   {
        if ( $Office2010 == 1 )
        {
            `\"C:\\Program Files\\Microsoft Office\\Office14\\WINWORD.EXE\" /t $templatePath /mAutoSWSN`;
        }
        else
        {
        `\"C:\\Program Files\\Microsoft Office\\Office10\\WINWORD.EXE\" /t $templatePath /mAutoSWSN`;
        }
   }
}



