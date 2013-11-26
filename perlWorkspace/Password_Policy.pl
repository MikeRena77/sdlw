# Password_policy.pl - Trey White
#
# This script generates a report of the current password policies. 

# usage: perl -S Password_policy.pl "[broker]" "[user]" "[password]"

($broker, $user, $password) = @ARGV;

open(SQLFILE, ">tmp$$.sql");
print SQLFILE <<END_SQL;
SELECT
  maxage,
  minage,
  minlen,
  reuserule,
  maxfailures,
  allowusrchgexp,
  warningage,
  chrepetition,
  minnumeric,
  lowercase,
  uppercase,
  nonalphanum,
  allowusername,
  username,   
  hpp.modifiedtime   
FROM
  harpasswordpolicy hpp,
  haruser hu
WHERE
  hpp.modifierid=hu.usrobjid
END_SQL

close(SQLFILE);
system("hsql -b \"$broker\" -usr \"$user\" -pw \"$password\" -f tmp$$.sql -o tmp$$.log");
 
open (LOG, "<tmp$$.log") || die "cannot open tmp$$.log: $!";
while (<LOG>) 
  { 
	$equalsign = index($_, "=");
	$before = $equalsign - 1;
	$after = $equalsign + 2;
	$lengthofdata = length($_);
	$lengthofvalue = $lengthofdata - $after;
	$ruletitle = substr($_, 0, $before);
	chomp $ruletitle;
	$rulevalue = substr($_, $after, $lengthofvalue);
	chomp $rulevalue;
	
	if ($ruletitle eq "MAXAGE") # If the password is older than this, the user must change their password.
	  {
		 if ($rulevalue le 0) { $MAXAGE = "Not Enabled"; }
		 else { $MAXAGE = $rulevalue; }
      }
    elsif ($ruletitle eq "MINAGE") # User must have this many days between attempts to change the password.
      {
	     if ($rulevalue le 0) { $MINAGE = "Not Enabled"; }
	     else { $MINAGE = $rulevalue; }
      } 
	elsif ($ruletitle eq "MINLEN") # Minimum character length of passwords.
      {
	     if ($rulevalue le 0) { $MINLEN = "Not Enabled"; }
	     else { $MINLEN = $rulevalue; }
      } 
    elsif ($ruletitle eq "REUSERULE") # Number of unique passwords that must be used before a password may be repeated
      {
	     if ($rulevalue le 0) { $REUSERULE = "Not Enabled"; }
	     else { $REUSERULE = $rulevalue; }
      }  
    elsif ($ruletitle eq "MAXFAILURES") # Number of invalid password attempts before the account is locked out.
      {
	     if ($rulevalue le 0) { $MAXFAILURES = "Not Enabled"; }
	     else { $MAXFAILURES = $rulevalue; }
      } 
    elsif ($ruletitle eq "ALLOWUSRCHGEXP") # Boolean value to determine whether users can change a password after it has expired.
      {
	     if ($rulevalue eq "Y") { $USRCHGEXP = "Yes"; }
	     else { $USRCHGEXP = "No"; }
      }
    elsif ($ruletitle eq "WARNINGAGE") # Password Age at which Harvest will start issuing warnings that the password will expire.
      {
	     if ($rulevalue le 0) { $WARNINGAGE = "Not Enabled"; }
	     else { $WARNINGAGE = $rulevalue; }
      }
    elsif ($ruletitle eq "CHREPETITION") # Maximum length of string in password made up of a single repeated character
      {
	     if ($rulevalue le 0) { $CHREPETITION = "Not Enabled"; }
	     else { $CHREPETITION = $rulevalue; }
      }
    elsif ($ruletitle eq "MINNUMERIC") # Minimum number of numeric characters that must be in the password.
      {
	     if ($rulevalue le 0) { $MINNUMERIC = "Not Enabled"; }
	     else { $MINNUMERIC = $rulevalue; }
      }
    elsif ($ruletitle eq "LOWERCASE") # Minimum number of lowercase characters that must be in the password.
      {
	     if ($rulevalue le 0) { $LOWERCASE = "Not Enabled"; }
	     else { $LOWERCASE = $rulevalue; }
      } 
    elsif ($ruletitle eq "UPPERCASE") # Minimum number of uppercase characters that must be in the password.
      {
	     if ($rulevalue le 0) { $UPPERCASE = "Not Enabled"; }
	     else { $UPPERCASE = $rulevalue; }
      }  
    elsif ($ruletitle eq "NONALPHANUM") # Minimum number of nonalphanumeric characters that must be in the password.
      {
	     if ($rulevalue le 0) { $NONALPHANUM = "Not Enabled"; }
	     else { $NONALPHANUM = $rulevalue; }
      }
    elsif ($ruletitle eq "ALLOWUSERNAME") # Boolean value to determine if the user’s password may match their own username. 
      {
	     if ($rulevalue eq "Y") { $ALLOWUSERNAME = "Yes"; }
	     else { $ALLOWUSERNAME = "No"; }
      }
    elsif ($ruletitle eq "USERNAME") # Name of User that last modified the Password Policies
      {
	     $USERNAME = $rulevalue;
      }
    elsif ($ruletitle eq "MODIFIEDTIME") # Date and Time that a User last modified the Password Policies
      {
	     $MODIFIEDTIME = $rulevalue;
      }         
  } # End of While Loop

close (LOG);

$where = rindex($0, "\\");
$tmpdir = substr($0, 0, $where);

open (REPORT, ">$tmpdir\\PasswordPolicy.rpt") || die "cannot open PasswordPolicy.rpt: $!";

$old_filehandle = select(REPORT);

format MSGHEADER1 =


				Password Policy Report
															
Maximum     Minimum     Minimum     Count Before Max Fail    Allow Change Maximum    
Age         Age         Length      Reusable     Before Lock After Expire Repeatable 
----------- ----------- ----------- ------------ ----------- ------------ -----------
.

$~ = "MSGHEADER1";
write;

format MSGDETAIL1 =
@<<<<<<<<<< @<<<<<<<<<< @<<<<<<<<<< @<<<<<<<<<<< @<<<<<<<<<<      @<<<    @<<<<<<<<<<
$MAXAGE     $MINAGE     $MINLEN	    $REUSERULE   $MAXFAILURES  $USRCHGEXP $CHREPETITION
            

.

$~ = "MSGDETAIL1";
write;

format MSGHEADER2 =



				Password Policy Report (Continued)
										
Expiration  Minimum     Minimum     Minimum     Minimum     Allow Username Modification Modification
Warning Age Numeric     Lower       Upper       NonNumeric  As Password    User Name    Date and Time										
----------- ----------- ----------- ----------- ----------- -------------- ------------ -------------------
.

$~ = "MSGHEADER2";
write;

format MSGDETAIL2 =
@<<<<<<<<<< @<<<<<<<<<< @<<<<<<<<<< @<<<<<<<<<< @<<<<<<<<<<      @<<<      @<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<
$WARNINGAGE $MINNUMERIC $LOWERCASE  $UPPERCASE  $MINNUMERIC $ALLOWUSERNAME $USERNAME    $MODIFIEDTIME




.

$~ = "MSGDETAIL2";
write;

format MSGFOOTER =

Policy Descriptions
-------------------
MaximumPasswordAge: Maximum age in days for a password. 
                    If the password is older than this, the user must change their password. 
                    To disable Maximum Password Age checking, set value to 0.
MinimumPasswordAge: Minimum age in days for a password. 
                    User must have this many days between attempts to change the password. 
                    To disable Minimum Password Age checking, set value to 0.
MinimumPasswordLength: Minimum character length of passwords. 
                       To disable MinimumPasswordLength checking, set value to 0.
PasswordCountBeforeReusable: Number of unique passwords that must be used before a password may be repeated. 
                             Maximum count allowed is 24. 
                             To disable Password Counting, set value to 0.
MaxFailAttemptBeforeLockout: Number of invalid password attempts before the account is locked out. 
                             Administrators must unlock the account after that. 
                             To disable Maximum Failing Attempts checking, set value to 0.
AllowChangeAfterExpire: Boolean value to determine whether users can change a password after it has expired. 
                        If not, then after it has expired the account must be unlocked by an Administrator. 
                        To always allow changes, set to true.
MaximumRepeatableCharacter: Maximum length of string in password made up of a single repeated character. 
                            To allow any length of repeating characters, set to 0.
ExpirationWarningAge: Password Age at which Harvest will start issuing warnings that the password will expire. 
                      To have no warning, set to 0.
MinimumNumericCharacter: Minimum number of numeric characters that must be in the password. 
MinimumLowercaseCharacter: Minimum number of lowercase characters that must be in the password.
MinimumUppercaseCharacter: Minimum number of uppercase characters that must be in the password.
MinimumNonalphanumericCharacter: Minimum number of nonalphanumeric characters that must be in the password.
AllowUsernameAsPassword: Boolean value to determine if the user’s password may match their own username. 
                         To always allow username as password, set to true.
.

$~ = "MSGFOOTER";
write;

select($old_filehandle);

close(REPORT);
print " \n";
print "Report PasswordPolicy.rpt was created in $tmpdir \n";
print " \n";

unlink "tmp$$.log";
unlink "tmp$$.sql";
