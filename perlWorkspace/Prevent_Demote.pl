# Prevent_Demote.pl - Trey White
# 
# This script checks to see if there are any trunk versions in the
# packages that are being demoted.  If there are any trunk version, 
# this script returns an exit code 1 causing the demote process to fail.  
# 
# Usage: Perl Prevent_Demote.pl "[broker]" "[user]" "[password]" "[project]" ["package"]
#
# Load the Argument list into variables
($broker, $user, $password, $project, @packagelist) = @ARGV;

# Set additional variables and open the version report
$error_exit=0;
open(RPT, ">>tmp$$.rpt") || die "cannot create tmp$$.rpt: $!";

# Interrogate the list of Packages and determin if there are any associated trunk versions
foreach $package (@packagelist)
{
open(SQLFILE, ">tmp$$.sql");
print SQLFILE <<END_SQL;
select
   rtrim(he.environmentname),
   rtrim(hp.packagename),
   rtrim(hi.itemname),
   rtrim(hv.mappedversion)
from
  harversions hv,
  haritems hi,
  harpackage hp,
  harenvironment he
where
  hp.envobjid = he.envobjid and
  hp.packageobjid = hv.packageobjid and
  hv.itemobjid = hi.itemobjid and
  he.environmentname = '$project' and
  hp.packagename = '$package' and
  hv.mappedversion not like '%.%.%'
ORDER BY
  hi.itemname, hv.mappedversion
END_SQL

close(SQLFILE);
system("hsql -nh -t -b \"$broker\" -usr \"$user\" -pw \"$password\" -f tmp$$.sql -o tmp$$.log");

  open(LOG, "<tmp$$.log") || die "cannot open tmp$$.log: $!";
  while (<LOG>) 
  { 
    $filecheck = substr($_, 0, 4);
    chomp $filecheck;
    next if /^HSQL/; # ignore comment lines
    next if /^\s*$/; # ignore blank lines and lines with only whitespace
	print RPT $_; 
  }
  close(LOG) || die "cannot close tmp$$.log: $!";
  
}
close(RPT) || die "cannot close tmp$$.rpt: $!";

if (-s "tmp$$.rpt")
{
  
  ###############################################################################
  # A Trunk version was found in an current package. Return an exit code 1 to  #
  # fail the Demote process and display an error message to the session log.    #
  ###############################################################################
  $error_exit=1;

format MSGHEADER =
*******************************************************************************
YOU ARE ATTEMPTING TO DEMOTE ONE OR MORE PACKAGES CONTAINING A TRUNK VERSION!

IF YOU WOULD LIKE TO PROCEED, YOU MUST FIRST DELETE THE TRUNK VERSIONS.
*******************************************************************************

Project                                  Package              Item                 Version
---------------------------------------- -------------------- -------------------- ----------
.

$~ = "MSGHEADER";
write;

format MSGDETAIL =
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<
$rptproject                              $rptpackage          $rptitem             $rptversion
.

  open(IN, "<tmp$$.rpt") || die "cannot open tmp$$.rpt: $!";
  while (<IN>)
  {

    $tab = "\t";
  
    $project_start_index = 0;
    $project_end_index = index($_,$tab, 1);
    $project_length = $project_end_index - $project_start_index;
    
    $package_start_index = $project_end_index + 1;
    $package_end_index = index($_,$tab,$package_start_index);
    $package_length = $package_end_index - $package_start_index;
    
    $item_start_index = $package_end_index + 1;
    $item_end_index = index($_,$tab,$item_start_index);
    $item_length = $item_end_index - $item_start_index;
    
    $version_start_index = $item_end_index + 1;
    $version_end_index = index($_,$tab,$version_start_index);
    $version_length = $version_end_index - $version_start_index;
    
    $rptproject = substr($_, $project_start_index, $project_length);
    chomp($rptproject); 
    $rptpackage = substr($_, $package_start_index, $package_length);
    chomp($rptpackage);
    $rptitem = substr($_, $item_start_index, $item_length);
    chomp($rptitem);
    $rptversion = substr($_, $version_start_index, $version_length);
    chomp($rptversion);
   
 
    $~ = "MSGDETAIL";
    write;
  }
  close(IN) || die "cannot close tmp$$.rpt: $!";
}
else
{
  $error_exit=0;
}  

unlink "tmp$$.sql";
unlink "tmp$$.log";
unlink "tmp$$.rpt";

exit $error_exit