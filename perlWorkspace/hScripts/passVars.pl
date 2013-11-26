      ########################################################################
      # $Header: setVars.pl,v 1.0 2008/02/27 14:00:00 mha Exp $
      #
      # This Perl script processes a simple PKG file
      #    that loads ENVIRONMENT variable from  the file <pkg>
      #    Arguments are passed in to spell out:
      #      - $target  => target folder for the web site
      #      - $webPath => if other than C:\Inetpub\wwwroot
      #
      #
      # Command line usage:
      #    perl setVars.pl
      #
      #    Version    Date       by   Change Description
      #      1.0      2/27/2008  MHA  Script written for passing variables from Harvest to OM activities
      #      1.1      7/28/2008  MHA  Rewrote function to internally time-stamp log file
      #
      ########################################################################
      my $scripDir      = "C:\\hScripts";

      # redirect STDOUT and STDERR to setRead-Only$$.log
      open SAVEOUT, ">&STDOUT";
      open SAVEERR, ">&STDERR";

      open STDOUT, ">$scripDir/logs/setVars$$.log" or die "Can't redirect stdout $!\n";
      open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

      select STDERR; $| = 1;     # make unbuffered
      select STDOUT; $| = 1;     # make unbuffered
      
      open (ENVLIST, "$scripDir\\pkg") or die "Can't open $scripDir\\pkg: $!\n";
      
      ITEM: while (<ENVLIST>)
      {
	      $/ = " \n"
	      $package = $_;
	      chomp ($package);
	      $ENV{'PACKAGE'} = $package;
	      next ITEM;
      }
      close (ENVLIST);
      print scalar localtime;
      print "\n";

      system("set");
      close STDOUT;
      close STDERR;
exit;