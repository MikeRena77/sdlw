#/*****************************************************************************
#* NAME:         $Workfile:   deltree.pl  $
#*               $Revision:   1.0  $
#*               $Date:   Feb 18 1999 16:55:30  $
#* DESCRIPTION:  See usage help below
#* TARGET:       NT
#*
#* MODIFICATION/REV HISTORY:
#*$Log:   P:/vcs/cm/deltree.plv  $
#*  
#*  Handle directories with spaces like the My Project in wayne.net
#*
#*     Rev 1.0   Feb 18 1999 16:55:30   DavidC
#*  Initial revision.
#*****************************************************************************/

$dir = shift(@ARGV);

#/* Handle usage request */
if ( (!(length($dir))) || ($dir =~ /\?/) || ($dir =~ /-H/i) || ($dir =~ /HELP/i) ) {
   #/* then this is a usage help request */
   print "\n";
   print "Usage:  DELTREE <directory>\n";
   print " \n";
   print "The write protection, system, and hidden attributes, if any, of all files\n";
   print "in the directory <directory> and subdirectories to all levels are removed.\n";
   print "Then, all files and subdirectories under <directory> as well as the <directory>\n";
   print "directory itself are deleted.\n";
   print " \n";
   print "Returns the number of directories that remain undeleted so that a return of\n";
   print "0 means it completed normally.\n";
   exit (0);
} #/* THEN usage */

# strip any form of \*.* from end of $dir
$dir =~ s/\\\*\.\*//;
$dir =~ s/\\\*\.//;
$dir =~ s/\\\*//;
if (reverse($dir) =~ /^\\/) {
   chop($dir);
}

#/* see if the directory to be deleted exists */
if ($dir =~ /:$/) {
   print "\U$dir\E is a root\n";
}
else {
   (-e $dir) || die "Directory \U$dir\E does not exist.\nDELTREE completed normally.\n";
}

print "Recording directories in \U$dir\E...\n";
@dirs = `dir /ad/b/s $dir`;
$dircount = @dirs + 1;
print "$dircount directories found.\n";  #/* +1 includes the root directory */

#/* Unprotect the entire tree */
print "Removing write protection from all files in \U$dir\E...\n";
`attrib -S -H -R $dir\\*.* /s`;  #1> NUL 2> NUL

print "Deleting directories...\n";
$failed_count = 0;
$count = 0;
@dirs = reverse(@dirs);  # need to traverse it backwards
foreach $thisdir (@dirs) {
   chop($thisdir);  #remove carriage return
   $rmdir_rc = 0;
   $count = $count + 1;
   $displaycount = @dirs - $count +2;
   print "$displaycount  \U$thisdir\E\n";
   $deldir = "$thisdir\\*.*";
   `del "$deldir" /q 1> NUL 2> NUL`;  # /n 1> NUL 2> NUL
   `rd "$thisdir"`;
   if (-e $thisdir) {
      #/* then rd failed, so mention it */
      $failed_count = $failed_count + 1;
      print "remove dir \U$thisdir\E dir failed.\n";
   }
} #/* DO all directories */

#/* delete contents of DIR, the root directory */
`del $dir /q 1> NUL 2> NUL`;  # /n 1> NUL 2> NUL

#/* Delete <directory> itself if it is not the root directory */
if (!(reverse($dir) =~ /^:/)) {
   #/* then DIR is not a root directory, so delete it */
   print "1  $dir\n";
   `rd "$dir"`;
   if (-e $dir) {
      #/* then rd failed, so mention it */
      $failed_count = $failed_count + 1;
      print "remove dir \U$dir\E dir failed.\n";
   }
} #/* THEN not root */

#/* report results */
if (!($failed_count)) {
   #/* then all deleted */
   print "Deletion of the $dir tree complete.  All $dircount directories deleted.\n";
}
else {
   #/* else one or more directories were not deleted */
   print "DELTREE complete:  $failed_count of $dircount directories in \U$dir\E were NOT deleted.\n";
   #CALL err_beep
} #/* ELSE some not deleted */

exit ($failed_count);
#/*=========================================================================*/