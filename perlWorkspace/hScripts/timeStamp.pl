      ########################################################################
      # $Header: timeStamp.pl,v 1.0 2008/mm/dd hh:mm:00 mha Exp $
      #
      # This Perl script was originally written to test printing out
      #    date time information from within the Perl script to the
      #    STDOUT log.
      #
      #    Arguments are passed in to spell out:
      #      - $  =>
      #      - $  =>
      #
      #
      # Command line usage:
      #    perl timeStamp.pl $ $
      #
      #    Version    Date       by   Change Description
      #      1.0      m/dd/2008  MHA  Script written for testing time-stamp
      #      1.1      7/28/2008  MHA  Added another function to internally time-stamp log file
      ########################################################################
      my $scripDir      = "C:\\hScripts";

      # redirect STDOUT and STDERR to setRead-Only$$.log
      open SAVEOUT, ">&STDOUT";
      open SAVEERR, ">&STDERR";

      open STDOUT, ">$scripDir/logs/timeStamp$$.log"
          or die "Can't redirect stdout $!\n";
      open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

      select STDERR; $| = 1;     # make unbuffered
      select STDOUT; $| = 1;     # make unbuffered
      

        print ("date /t >> \">>&STDOUT\" && time /t >> \">>&STDOUT\"\n");
        error_exit=system("date /t && time /t" "\n");     
        # only works with DOS command extensions enabled and recognized
        print scalar localtime;
        print "\n";


      close STDOUT;
      close STDERR;
      exit $error_exit;
