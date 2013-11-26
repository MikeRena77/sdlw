# set_check.pl - David Cavanaugh - PLATINUM technology inc
# CCC/Harvest UDP to check for package sets upon promote.
# The philosophy is that you can promote a package forward if you are promoting all of
# the packages contained within the set that the package belongs to.  A package cannot 
# promote ahead of its' set.  A package can however catch up to a set if it had been 
# demoted back.
# In other words, a set bind packages together upon promote, but not upon demote.
# UDP program line: 
# NT Harvest 3.x    perl.exe set_check.pl " [environment] " " [state] "  " [package] "
# NT Harvest 4.x    perl.exe set_check.pl  "[environment]"   "[state]"    "[package]"
# The username/password for sqlplus requires read permission on the harvest tables
# Package names must not include whitespace

# specify the username and password for the read-only Oracle account
$username = HARREP;
$userpass = HARVEST;

# specify the username and password for a harvest account
$husername = harvest;
$huserpass = harvest;

# specify the location of the UDP files
$harvesthome = "$ENV{'HARVESTHOME'}";
$udpdir = "$harvesthome\\bin";

# read the arguments
# Harvest 3 with NT
# $env =     substr($ARGV[0],1,length($ARGV[0])-2); shift;
# $st =     substr($ARGV[0],1,length($ARGV[0])-2); shift;
# Harvest 4 with NT
$env = $ARGV[0]; shift;
$st =  $ARGV[0]; shift;

print "Checking package set in environment $env, and state $st...\n";

$stat = 0;

foreach $pkg (@ARGV)
{
  $pkgset = substr $pkg, -2;
  print "Processing package $pkg with set $pkgset\n";
  if ($pkgset eq "-1" )
  {
    @all_pkgsets = substr($pkg, 0, -2);
  }
  elsif ($pkgset eq "-2" )
  {
     print "Error, invalid package $pkg for this state!\n";
     $stat = -1;
  }
  else
  {
     push @all_pkgsets, $pkg;
  }
}

chomp(@all_pkgsets);

# build the sorted distinct array of set names
$prev = '';
@pkgsets = grep($_ ne $prev && ($prev = $_), sort(@all_pkgsets));

# build an array of packages in this state
@pkgs = `plus33.exe -s $username/$userpass \@'$udpdir\\pkg_state.sql' '$env' '$st'`; 
chomp(@pkgs);

foreach $pkgset (@pkgsets)
{
   $pkg0 = "$pkgset";
   $pkg1 = "$pkgset" . "-1";
   
   $detect_pkg0 = 0;
   $detect_pkg1 = 0;
   foreach $pkg (@pkgs)
   {
      print "Evaluating $pkg0 $pkg1 $pkg\n";
      if ("$pkg0" eq "$pkg")
      {
         print "Match on $pkg0 and $pkg\n";
         $detect_pkg0 = 1;
      }
      if ("$pkg1" eq "$pkg")
      {
         print "Match on $pkg1 and $pkg\n";
         $detect_pkg1 = 1;
      }
   }
   
   if ($detect_pkg0 && $detect_pkg1)
   {
      print "Promoting Packages $pkg0 and $pkg1.\n";
      system "hpp -usr \"$husername\" -pw \"$huserpass\" -en \"$env\" -st \"$st\" -pn \"Promote\" \"$pkg0\" ";
      system "hpp -usr \"$husername\" -pw \"$huserpass\" -en \"$env\" -st \"$st\" -pn \"Promote\" \"$pkg1\" ";
      # do an error check
      system "del hpp.log";
   }
   elsif ($detect_pkg0)
   {
      print "Package $pkg1 is missing from state $st\n";
      $stat = -2;
   }
   elsif ($detect_pkg1)
   {
      print "Package $pkg0 is missing from state $st\n";
      $stat = -2;
   }
   else
   {
      print "Danger Will Robinson!!!\n";
      $stat = -2;
   }
}
        
if ($stat == 0 )
{
  print "Package set verification passed.\n\n";
}
else
{
  print "Package set verification failed.\n\n";
}

exit $stat;
