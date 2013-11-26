#!p:\perl
#
# $Workfile:   chkspace.pl  $
# $Revision:   1.1  $ $Date:   Nov 12 1997 15:20:16  $
# $Logfile:   P:/vcs/cm/chkspace.plv  $
#
#  chkspace perl script
#
#  this script will get the available space on a network drive
#       and verify if there is enough space for a build
#
#  chkspace <project> <bldlabel>
#  ex. chkspace nbase base22

require 'p:\cm\chckparm.pl';

$listdir = "$drive\\";

if ($project =~ /base/i) {
    $minsize = 200000000; # minimum space required for a base and nstarter build
}
else {
    $minsize = 100000000; # minimum space required for an application build
}

@a = `dir $listdir`;   # do a directory listing on the drive
foreach $i (@a) {
    print $i;
    if ($i =~ /bytes free/i) {  # look for the line that has "bytes free"
	
	$dirsize = $`; 
	$dirsize =~ s/\s//g;
	$dirsize =~ s/,//g;
     
	print "dir size is: $dirsize \n";
	if ($i =~ /k bytes free/i){
	    $dirsize = $dirsize*1024;
	}
	
    }
}


# check if there is enough space available
print "\n($dirsize)";
if ($dirsize > $minsize) {  
    print " Sufficient space is available for a \U$project\E build\n";
}
else {
    print " INsufficient space for a \U$project\E build - run makspace\n";
}









