#!p:\perl
#
#  bldnotes perl script
#  this script will create an internal release note text file
#  from the scrs that were promoted for a particular build and
#  from the output files from the build.  All are stored in
#  the \\drive\scr\build\bldname directory
#
#  bldnotes <project> <bldlabel> <bldname>
#  ex. bldnotes nbase base22 n0220an
#  ex. bldnotes nstarter starter01 st0100ab

#unshift(@INC,'.');
require 'p:\cm\chckparm.pl';
require 'p:\cm\GetServerName.pl';

$bldname = shift(@ARGV);

# is the bldname valid??
if (!(length($bldname))) {
   die "build name must be specified\n";
}

$bldpath = "$drive\\scr\\build\\$bldname";
$realbldpath = "$drive\\build\\$bldname";

#print "$bldpath\n";
#print "$realbldpath\n";

if (!(-e $bldpath)) { 
   die "build output directory $bldpath does not exist\n"; 
}
if (!(-e $realbldpath)) { 
   die "build directory $realbldpath does not exist\n"; 
}

# create the changes.lst file from the scrs
$file = "$bldpath\\scrfiles.lst";
$changes = "$bldpath\\changes.lst";
$outfile = "$bldpath\\$bldname.txt";

if (-e $outfile) { 
   print "$outfile already exists.  Do you want to overwrite it?\n";
   if (!(<STDIN> =~ /^y/i)) { 
      die "build notes file $outfile already exists\n"; 
   }
}

`perl -Ip:\\cm p:\\cm\\changes.pl $file $changes`;

# open the output text file
open(NOTEFILE,">$outfile") || die "cannot open $outfile = $!";
 
# create the header
print NOTEFILE "The \U$bldname\E build is complete.\n";
print NOTEFILE "The build is available on the network server  \\\\$ServerName\\\U$bldname\E.\n";
print NOTEFILE "\n";
print NOTEFILE "#########################################################\n";
print NOTEFILE "NOTE:   If  you want to do refresh builds of these builds,\n";
print NOTEFILE "xxcopy \\\\$ServerName\\\U$bldname\E\\*.* /s/e/r/v into D:\\\U$project\E.\n";
print NOTEFILE "Otherwise, everything recompiles!\n";
print NOTEFILE "#########################################################\n";
print NOTEFILE "\n";

print NOTEFILE "The contents of the release.num file is as follows:\n";
print NOTEFILE "===================================================================\n";
print NOTEFILE "\n";
close(NOTEFILE);

# insert the release number
$tmpfile = "$realbldpath\\release.num";
`copy $outfile + $tmpfile $outfile`;

# copy release.num to build info directory
`copy $tmpfile $bldpath`;

open(NOTEFILE,">>$outfile") || die "cannot open $outfile = $!";
print NOTEFILE "\n";
print NOTEFILE "The following SCRs were promoted for this build:\n";
print NOTEFILE "===================================================================\n";
print NOTEFILE "\n";
close(NOTEFILE);

# insert the scrfiles.lst contents
`copy $outfile + $file $outfile`;

open(NOTEFILE,">>$outfile") || die "cannot open $outfile = $!";
print NOTEFILE "\n";
print NOTEFILE "The following DNs were fixed or features added/modified for this build:\n";
print NOTEFILE "===================================================================\n";
print NOTEFILE "\n";
close(NOTEFILE);

# insert the changes.lst contents
`copy $outfile + $changes $outfile`;

open(NOTEFILE,">>$outfile") || die "cannot open $outfile = $!";
print NOTEFILE "\n";
print NOTEFILE "The promoted Files and reported changes were as follows:\n";
print NOTEFILE "===================================================================\n";
print NOTEFILE "\n";
close(NOTEFILE);

# insert the promote.txt contents
$tmpfile = "$bldpath\\promote.lst";
`copy $outfile + $tmpfile $outfile`;

open(NOTEFILE,">>$outfile") || die "cannot open $outfile = $!";
print NOTEFILE "\n";
print NOTEFILE "NOTTIP results after the promote to the base were as follows:\n";
print NOTEFILE "===================================================================\n";
print NOTEFILE "\n";
close(NOTEFILE);

# insert the nottip.txt contents
$tmpfile = "$bldpath\\nottip.out";
`copy $outfile + $tmpfile $outfile`;
