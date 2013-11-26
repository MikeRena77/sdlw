      ########################################################################
      # $Header: unsetRead-Only.pl,v 1.0 2008/03/18 11:35:00 mha Exp $
      #
      # Written
      #    by Michael Andrews (MHA)
      #    for AAFES HQ
      #
      # This Perl script runs the DOS attrib command against a set of
      #    file extensions spelled out in the file <files.ext> to set
      #    the Read-Only attribute off
      #    Arguments are passed in to spell out:
      #      - $target  => target folder for the web site
      #      - $webPath => full path, like C:\Inetpub\wwwroot
      #
      # Command line usage:
      #    perl setRead-Only.pl $target $webPath
      #
      #    Version    Date       by   Change Description
      #      1.0      3/18/2008  MHA  Script rewritten for setting Read-Only off
      #      1.1      5/22/2008  MHA  Changed $scripDir for consistency across scripting
      #      1.2      7/28/2008  MHA  Rewrote function to internally time-stamp log file
      #
      ########################################################################
       $target        = $ARGV[0]; shift;
       $webPath       = $ARGV[0]; shift;
       $scripDir      = "C:\\hScripts";

      chomp ($target);
      chomp ($webPath);
      # redirect STDOUT and STDERR to unsetRead-Only$$.log
      open SAVEOUT, ">&STDOUT";
      open SAVEERR, ">&STDERR";

      open STDOUT, ">$scripDir/logs/unset-$target-Read-Only$$.log"
          or die "Can't redirect stdout $!\n";
      open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

      select STDERR; $| = 1;     # make unbuffered
      select STDOUT; $| = 1;     # make unbuffered
      
      print scalar localtime;
      print "\n";
      print("-----BEGIN UNSET READ-ONLY REPORT------------------------------\n");

      # check for webPath and target from the args passed in
      if ($webPath eq "")
      {
	print "Usage: perl setRead-Only.pl target webPath\n";
	print "    where target is the target directory\n";
	print "    and webPath is the absolute path to the target directory\n";
        print "webPath = $webPath\n";
        die "You must provide the path to the target directory as the second argument: $?: $!\n";
      }
      if ($target eq "")
      {
	print "Usage: perl setRead-Only.pl target webPath\n";
	print "    where target is the target directory\n";
	print "    and webPath is the absolute path to the target directory\n";
        print "target = $target\n";
        die "You must provide a target directory as the first argument: $?: $!\n";
      }
      $target = $webPath . "\\" . $target;
      print "target = $target\n";

      open (FILEXT, "C:\\hScripts\\files.ext") or die "Can't find the file $FILEXT $!\n";
      @extens = <FILEXT>;
      close FILEXT;
      LINE: foreach $ext (@extens)
      {
        chomp($ext);
        print ("attrib -r /s \"$target\\*.$ext\" \n");
        $error_exit=system("attrib -r /s \"$target\\*.$ext\"");
        if ($error_exit != 0){ print "Error: $error_exit: $! \n"};
        next LINE;
       }

      print("-----END UNSET READ-ONLY REPORT--------------------------------\n");
      print scalar localtime;
      print "\n";
      close STDOUT;
      close STDERR;

      exit $error_exit;
