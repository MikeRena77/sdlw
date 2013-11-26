# ProductionModelFirewall.pl - Trey White
 
# This script runs as a pre-link UDP process to the Promote process. 
# The script is designed to remove the Package being promoted from the 
# Package Group defined as a argument and then test if there are any other
# Packages in the Package Group. If so, fail the Promote Process.

# usage: perl -S ProductionModelFirewall.pl "[project]" "PkgGrpName" ["package"]

# Definitions: PkgGrpName = the Package Group Name that you have created for Emergency Fixes (e.g. EMR)


# get the project name and package group name from the argument list
$project = $ARGV[0];
shift;
$pkggrp = $ARGV[0];
shift;

# get HARVESTHOME from the environment space
$where = rindex($0, "\\");
$harvesthome = substr($0, 0, $where);
$stat = 0;

# Check each package to determine if it is in the specified package group. 
# If so delete it from the package group.

# Loop through each package
foreach $pkg (@ARGV)
{
  @sqlout = `sqlplus.exe -s harvest/harvest \@\"$harvesthome\\CheckPkgGrp.sql\" \'$project\' \'$pkg\' \'$pkggrp\' `;
    
  if (@sqlout)
  {
  system " sqlplus.exe -s harvest/harvest \@\"$harvesthome\\DeletePkgGrp.sql\" \'$project\' \'$pkg\' ";
  }
}

# Check for other packages in the defined package group
@sqlout = `sqlplus.exe -s harvest/harvest \@\"$harvesthome\\CheckOtherPkgs.sql\" \'$project\' \'$pkggrp\' `;

# If there are other packages in the defined package group, fail the promote
if (@sqlout)
  { 
  print "The Production Firewall located active Emergency Fixes \n";	  	  
  print "\n";
  print "##################################################################\n";
  print "## There are other Emergency Fixes that must be resolved prior to Promoting to the next State. ##\n";
  print "##################################################################\n";
  $stat = 1;
  }
exit $stat;