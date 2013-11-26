      ####################################################################
      # diffrTool.pl
      #
      # This UDP script runs a compare between the latest and greatest (LAG)
      #    version in production and the version being checked out
      #
      # Version 1.2 of this script
      #
      # Command line usage:
      #    perl -S diffrTool.pl "[file]" "[broker]" "[project]" "[state]" "[viewpath]" "[user]" "[password]" "[clientpath]" "[version]"
      #
      #
      #
      #
      ####################################################################
      ($file, $broker, $project, $state, $viewpath, $user, $password, $clientpath, $version) = @ARGV;

      # Put out a final message to "normal" standard out to tell the
      # operator the location of the log file.

      $udpdir= "$ENV{'HARVESTHOME'}";
      $tmpdir= "$ENV{'TEMP'}";
      $logdir = "";
      $broker = uc($broker);
      $error_exit=0;
      $left_side_version = $version;
      if ($logdir eq "")
      {
          # logdir not specified - use temp directory
          $logdir= $tmpdir;
      }

      print "log file = \"$logdir\\diffrTool$$.log\"\n";

      # redirect STDOUT and STDERR to diffrTool$$.log
      open SAVEOUT, ">&STDOUT";
      open SAVEERR, ">&STDERR";

      open STDOUT, ">$logdir/diffrTool$$.log" or die "Can't redirect stdout $!\n";
      open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

      select STDERR; $| = 1;     # make unbuffered
      select STDOUT; $| = 1;     # make unbuffered
      
      print "Initial setting of file: \"$file\"\n";

      @mypath = split(m"\\\\", $clientpath, 2);
      {
        print "My path is: \"@mypath[1]\"\n";
      }

      @myfile = split(m"\\\\", $file, 2);
      {
        chop(@myfile);
        print "My file is: \"@myfile[1]\"\n";
      }

      @testfile = reverse(split(m"\\", $file));
      {
        chop(@testfile);
        print "Test file is: \"@testfile[0]\"\n";
      }
      
      if ($broker =~ /DEVSWA/)
      {
        if ($project =~ /^HR-Test$/)
        {
          $project = "HR-Deployment-Production";
          $state = "Production";
          $viewpath = "\Deployment";
        }
      }
#---------------working-----------------------------------------------------------


 # hlv filename {-b name -en name -st name -vp path} {-usr username -pw password} [-v] [-vn version] [-pn name] [-s filename | pattern] [-cd] [-ac] [-prompt] [-ss name] [-i inputfile.txt | -di inputfile.txt] [-eh filename] [-o filename | -oa filename] [-arg] [-wts] [-h]
 # hlv \"@testfile[0]\" -b \"$broker\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -eh \"%HARVESTHOME%\\devswa.dfo\" -o -wts
      #print("hco \"@testfile[0]\" -b \"$broker\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -br -to -r -wts -eh \"%HARVESTHOME%\\devswa.dfo\"\n\n");
      #$error_exit=system("hco \"$testfile[0]\" -b \"$broker\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -br -to -r -wts -eh \"%HARVESTHOME%\\devswa.dfo\" ");
      #print "Error Exit Code:    $error_exit\n";

#---------------working-----------------------------------------------------------
      print "File is: \"$file\"\n";
      print "Broker is: \"$broker\"\n";
      print "Project is: \"$project\"\n";
      print "State is: \"$state\"\n";
      print "Viewpath is: \"$viewpath\"\n";
      print "User is: \"$user\"\n";
      print "Password is: xxxxxxxxxxxx\n";
      print "Client path is: \"$clientpath\"\n";
      print "My path is: \"@mypath[1]\"\n";
      print "My file is: \"@myfile[1]\"\n";
      print "\n-----------------------------------------------------------------\n";

      # initialize variables for left and right files

      chdir @mypath[1] or die "Can't cd to @mypath[1]: $!\n";
      
      $devfile= (@myfile[1]) . ".mine";
      $bkupFile= (@myfile[1] . ".bak");
      print "Current value of file is: \"@myfile[1]\"\n";
      print "Compare file on the left should be: \"$devfile\"\n";

      print("copy \"@myfile[1]\" \"$devfile\"\n");
      $error_exit=system("copy \"@myfile[1]\" \"$devfile\"");
      print "Error Exit Code: $error_exit\n";
      
      print("copy \"@myfile[1]\" \"$bkupFile\"\n");
      $error_exit=system("copy \"@myfile[1]\" \"$bkupFile\"");
      print "Error Exit Code: $error_exit\n";
      
      #system("dir");
      #print("\n");
      
      #hco filename | pattern {-b name -en name -st name -vp path -p name} {-up | -br | -ro | -sy | -cu} {-usr username -pw password} [-vn] [-nvs] [-r ] [-v] [-nt] [-ss name] [-s filename | pattern] [-pf name [-po]] [-bo -to -tb] [-ced] [-dvp path] [-dcp path] [-cp path] [-op option] [-pn name] [-rm name] [-rusr username] [-rpw password] [-prompt] [-i inputfile.txt | -di inputfile.txt] [-eh filename] [-er filename] [-o filename | –oa filename] [-arg] [-wts] [-h]
      print("hco \"@testfile[0]\" -b \"$broker\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -br -to -r -wts -eh \"%HARVESTHOME%\\devswa.dfo\"\n\n");
      $error_exit=system("hco \"$testfile[0]\" -b \"$broker\" -en \"$project\" -st \"$state\" -vp \"$viewpath\" -br -to -r -wts -eh \"%HARVESTHOME%\\devswa.dfo\" ");
      print "Error Exit Code:    $error_exit\n";

      $prodfile= (@testfile[0]) . ".prod";

      print "\nCompare file on the right should be: \"$prodfile\"\n";

      print("ren \"@myfile[1]\" \"$prodfile\"\n");
      $error_exit=system("ren \"@myfile[1]\" \"$prodfile\"");
      print "Error Exit Code:    $error_exit\n\n";
      
      print("vdiff2 \"$devfile\" \"$prodfile\"\n");
        $error_exit=system("vdiff2 \"$devfile\" \"$prodfile\"");
      print "Error Exit Code:    $error_exit\n\n";

      print("Restoring original checkout file \"@testfile[0]\"\n");
      $error_exit=system("ren \"$bkupFile\" \"@testfile[0]\"");
      print "Error Exit Code:    $error_exit\n\n";
      system("dir");
      system("attrib +r \"@testfile[0]\"");
      print("\n");
      
     # reset STDOUT and STDERR back to normal

      close STDOUT;
      close STDERR;

      open STDOUT, ">&SAVEOUT";
      open STDERR, ">&SAVEERR";
      print "Done.\n";
      system("pause");
      exit $error_exit;
