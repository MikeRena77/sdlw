#/* begin extraction */
#/****************************************************************************
#* NAME:         $Workfile:   details.pl  $
#*               $Revision:   1.1  $
#*               $Date:   Aug 21 1997 14:56:52  $
#*
#* DESCRIPTION:  Lists the changes impact of  the SCRs in scrfiles.lst
#*               
#* 
#*****************************************************************************
#/* end extraction */

if ($#ARGV != 1 || $ARGV[0] eq '-h' || $ARGV[0] eq '-H')
{
print <<HelpSection;
tool: prmtlst
description: This tool creates a file listing all the changes due to the SCRs 

usage:
details <input file, i.e. scr-list file> <output file i.e detail file>

example:
details q:\\scr\\build\\n0700a\\scrfiles.lst q:\\scr\\build\\n0700a\\details.lst
HelpSection
exit 1;
}

# This script opens each file in the input list(ie scrfiles.lst) and converts 
# each file into a string.  It then extracts the necessary sections and puts
# it into a list.  Finally it prints the necessary information from the list
# into the output file (ie details.lst)



$scrListFile = $ARGV[0];
$detailFile = $ARGV[1];

open (SCR_LIST_FILE, "<$scrListFile") || die "cannot open $scrListFile" ;
open (DETAIL_FILE, ">$detailFile") || die "cannot open $detailFile";

#These are the variables used:
$user  = "1. Changes with User Impact" ;
$cavnet = "2. Changes with Cavnet/SST Impact" ;
$developer = "3. Changes with Developer Impact" ;
$internal = "4. Changes with Internal Impact" ;
$endtag = "Change Comments from Module Headers" ;
$count = 0;

while ($scrFile = <SCR_LIST_FILE>)
{
    
    @dirparts  = split( /\\/, $scrFile);
    $theSCRFile = @dirparts[$#dirparts];
    chomp($theSCRFile);
    $fileName[$count] = $theSCRFile;  #stores the name of the SCR

    open (THIS_SCR, "<$scrFile") || die "could not open $scrFile = $!" ;
    
    undef $/;                          #convert file into a string
    $buffer = <THIS_SCR>;
    $/ = "\n";      #redefine end of line 
    
#split the file into approp sections and store in an array

    @field1  = split( /$user/, $buffer);
    @field2 = split (/$cavnet/, $field1[1]);
    $userList[$count] = $field2[0];
    
    
    @field1 = split(/$cavnet/, $buffer);
    @field2 = split(/$developer/, $field1[1]);
    $cavnetList[$count] = $field2[0];
    
    @field1 = split(/$developer/, $buffer);
    @field2 = split(/$internal/, $field1[1]);
    $developerList[$count] = $field2[0];
    
    @field1 = split(/$internal/, $buffer);
    @field2 = split(/$endtag/, $field1[1]);
    $internalList[$count] = $field2[0];


    $count++;
    
    close (THIS_SCR);    
    
    
}

close (SCR_LIST_FILE);

$count = 0;
print DETAIL_FILE "$user: \n";
foreach (@userList)
{
    
    if(/\S/)    #while string is not empty......
    {
	print DETAIL_FILE "\n:::$fileName[$count]:\n";
	s/\s+$//g;      
	print DETAIL_FILE " $_ \n";
    }
    $count++;
    
}

$count = 0;
print DETAIL_FILE "\n\n$cavnet: \n";
foreach (@cavnetList){
    if (/\S/)
    {
	print DETAIL_FILE "\n:::$fileName[$count]:\n";
	s/\s+$//g;
	print DETAIL_FILE "$_ \n";
    }
    $count++;
}

$count = 0;
print DETAIL_FILE "\n\n$developer :  \n";
foreach (@developerList)
{
    if(/\S/ )
    {
	print DETAIL_FILE "\n:::$fileName[$count]:";
	s/\s+$//g;
	print DETAIL_FILE "$_ \n";
    }
    $count++;
}

$count = 0;
print DETAIL_FILE "\n\n$internal : \n";
foreach (@internalList)
{
    if (/\S/ )
    {
	print DETAIL_FILE "\n:::$fileName[$count]:";
	s/\s+$//g;
	print DETAIL_FILE "$_ \n";
    }
    $count++;
}


close (DETAIL_FILE);

    


