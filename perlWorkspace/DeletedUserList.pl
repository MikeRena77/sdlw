# DeletedUserList.pl - Trey White
#
# This script generates a report of the current password policies. 

# usage: perl -S DeletedUserList.pl "[broker]" "[user]" "[password]"

($broker, $user, $password) = @ARGV;

open(SQLFILE, ">tmp$$.sql");
print SQLFILE <<END_SQL;
SELECT hau.username, hau.realname, TO_CHAR(hau.modifiedtime-5/24, 'DY MM/DD/YY HH24:MI:SS')
FROM harallusers hau
where hau.usrobjid > 0 and
      hau.usrobjid NOT IN (SELECT hu.usrobjid FROM haruser hu)
END_SQL

close(SQLFILE);

system("hsql -nh -t -b \"$broker\" -usr \"$user\" -pw \"$password\" -f tmp$$.sql -o tmp$$.log");

$where = rindex($0, "\\");
$tmpdir = substr($0, 0, $where);
 
open (REPORT, ">$tmpdir\\DeletedUserAudit.rpt") || die "cannot open DeletedUserAudit.rpt: $!";
$old_filehandle = select(REPORT);

format MSGHEADER =

			          Deleted User Audit Report

				 				 
User Name            Real Name                      Modified Date & Time														 
-------------------- ------------------------------ ---------------------
.

$~ = "MSGHEADER";
write;
 
open (LOG, "<tmp$$.log") || die "cannot open tmp$$.log: $!";
while (<LOG>) 
   { 
     $tab = "\t";
  
     $username_start_index = 0;
     $username_end_index = index($_,$tab, 1);
     $username_length = $username_end_index - $username_start_index;
     
     $realname_start_index = $username_end_index + 1;
     $realname_end_index = index($_,$tab,$realname_start_index);
     $realname_length = $realname_end_index - $realname_start_index;
    
     $datetime_start_index = $realname_end_index + 1;
     $datetime_end_index = index($_,$tab,$datetime_start_index);
     $datetime_length = $datetime_end_index - $datetime_start_index;      
	 
     $rptusername = substr($_, $username_start_index, $username_length);
     chomp($rptusername); 
     $rptrealname = substr($_, $realname_start_index, $realname_length);
     chomp($rptrealname);
     $rptdatetime = substr($_, $datetime_start_index, $datetime_length);
     chomp($rptdatetime);       
	   
format MSGDETAIL =
@<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<< 
$rptusername         $rptrealname                   $rptdatetime  
.

      $~ = "MSGDETAIL";
      write;
               
   } # End of While Loop
 
close (LOG);
 
select($old_filehandle);
 
close(REPORT);
print " \n";
print "Report DeletedUserAudit.rpt was created in $tmpdir \n";
print " \n";
 
unlink "tmp$$.log";
unlink "tmp$$.sql";
