      ########################################################################
      # compareProdLAG.pl
      #
      # This UDP script runs a compare between the latest and greatest (LAG)
      #    version in production and the version being checked out
      #
      #
      # Command line usage:
      #    perl -S compareProdLAG.pl "[broker]" "[project]" "[state]" "[view]" "[viewpath]" "[user]" "[password]"
      #
      #
      #
      #
      ########################################################################
      
      ($broker, $project, $state, $view, $viewpath, $user, $password) = @ARGV;

      $udpdir= "$ENV{'HARVESTHOME'}";
      
      $error_exit=0;

      print("hcmpview -b \"$broker\" -en1 \"$project\" -en2 \"$project\" -st1 \"$state\" -vn1 \"$view\" -vn2 \"Completed\" -vp1 \"$viewpath\" -vp2 \"$viewpath\" -usr \"$user\" -pw \"$password\" -cidc -s –o \"cmpView$$.log\" -wts\n\n");

      $error_exit=system("hcmpview -b \"$broker\" -en1 \"$project\" -en2 \"$project\" -st1 \"$state\" -vn1 \"$view\" -vn2 \"Completed\" -vp1 \"$viewpath\" -vp2 \"$viewpath\" -usr \"$user\" -pw \"$password\" -cidc -s –o \"cmpView$$.log\" -wts");
      print "Error Exit Code:    $error_exit\n\n";
      
      unlink("cmpView$$.log");
      
      exit $error_exit;
