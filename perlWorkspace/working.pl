BLOCK STARTS AT LINE NUMBER 768
                     # Get the idcounter for the new user
                     open (USERLIST, ">$logdir\\userlist$$.sql") or die "Can't open $logdir\\userlist$$.sql: $!\n";
                     print USERLIST ( "select idcounter from harobjidgen where hartablename = \'harUser\'\n");
                     close USERLIST;

                     system ("hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" ") == 0
                        or die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed getting user id counter: $?\n";
                     
                     # parse the log file for the idcounter
                     open (FILEUSER, "$logdir\\userlist$$.log") or die "Can't open $logdir\\userlist$$.log: $!\n";
                     @status = <FILEUSER>;
                     close FILEUSER;
                     
                     # check for Oracle warnings/errors
                     if (grep /^E([0-9]){4} /, @status)
                     {
                        die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle error: $?\n";
                     }
                     if (grep /^W([0-9]){4} /, @status)
                     {
                        die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle warning: $?\n";
                     }

                     foreach $entry (@status)
                     {
                        if ($entry =~ /^IDCOUNTER /)
                        {
                           if (($F1, $F2, $change_user_id) = split(' ', $entry, 3))
                           {
                              chomp($change_user_id);
                           }
                        }
                     }
                     print "The user id is $change_user_id\n";

                     # Bump the idcounter for users
                     open (USERLIST, ">$logdir\\userlist$$.sql") or die "Can't open $logdir\\userlist$$.sql: $!\n";
                     print USERLIST ( "update harobjidgen set idcounter = idcounter + 1 where hartablename = \'harUser\';\n");
                     print USERLIST ( "exit" );
                     close USERLIST;

                     system ("sqlplus $ousr/$opw\@$ohost @\"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" ") == 0
                        or die "sqlplus $ousr/$opw\@$ohost @\"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed while updating harversions: $?\n";


                     # parse the log file for errors/warnings
                     open (FILEUSER, "$logdir\\userlist$$.log") or die "Can't open $logdir\\userlist$$.log: $!\n";
                     @status = <FILEUSER>;
                     close FILEUSER;

                     # check for Oracle warnings/errors
                     if (grep /^E([0-9]){4} /, @status)
                     {
                        die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle error: $?\n";
                     }
                     if (grep /^W([0-9]){4} /, @status)
                     {
                        die "hsql -b \"$broker\" -usr \"$husr\" -pw \"$hpw\" -f \"$logdir\\userlist$$.sql\" -o \"$logdir\\userlist$$.log\" failed Oracle warning: $?\n";
                     }
BLOCK ENDS AT LINE NUMBER 827