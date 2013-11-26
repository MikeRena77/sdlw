#!/usr/local/bin/perl
use Time::Local;

$USAGE = "\n\tUSAGE: rmdos.pl [DO_expiration_period] (30 days, by default)\n\n";

    # Change this for a different number of default days #
$default = 30;
    # assign a number of days after which the DO can be marked for deletion (default = $default days) #
$expired = (scalar(@ARGV) < 1) ? $default : shift(@ARGV);
($expired !~ /^\d+$/)? &usage : undef(@ARGV);

    # Here's the ClearCase executable to remove unwanted DO's #
$atriahome = "/usr/atria";
$ctool = "$atriahome/bin/cleartool";
$lsdo = "lsdo -l -r";
$rmdo = "rmdo"; 

    # assign cardinals to the months for passing as arguments to timelocal() #
%CARD = (
	 Jan => 0,
	 Feb => 1,
	 Mar => 2,
	 Apr => 3,
	 May => 4,
	 Jun => 5,
	 Jul => 6,
	 Aug => 7,
	 Sep => 8,
	 Oct => 9,
	 Nov => 10,
	 Dec => 11,
	 );

    # Get today's date, in particular, the current year and the day of the current year #
($null, $null, $null, $null, $null, $YEAR, $null, $TODAY, $null) = localtime(time);
    # Determine whether or not this is a leap year, and assign ENDDAY to hold this information #
($null, $null, $null, $null, $null, $null, $null, $ENDDAY, $h) = localtime(timelocal(59, 59, 23, 31, 11, $YEAR));

open(LSDO, "$ctool $lsdo |") || die "Can't invoke $ctool $lsdo for pipe.";
while(<LSDO>){ # parse input of lsdo -l -r line by line #
    chomp;
    if (/^cleartool/){next;} # ignore errors/warnings returned by cleartool and move on to next input #
    if (/^\d\d\-/){          # find the date stamp #
	split(/\s+/, $_);    # separate input line containing DO date stamp #
	$date = $_[0];       # assign DO's date stamp #
	($_ = <LSDO>) =~ s/^\s+//;
	split(/\"/, $_);     # separate input line containing DO extended name #
	$_[1] =~ s/\"//g;
	$ename = $_[1];      # assign  DO extended name #
	($_ = <LSDO>) =~ s/^\s+//;
	split(/\s+/, $_);    # separate input line containing DO reference count #
	$refcnt = $_[1];     # assign DO reference count #
	if ($refcnt >= 1){   # if the reference count is >= 1, run the DO through the removal filter #
	    &delete($ename, $date);
	}
    }
}
close(LSDO);

    # subroutine for computing difference in today's date and DO's reference date #
sub delete{
    my ($do, $ddate) = @_;
    # chop up the date into pieces that can be fed to time utilities #
    ($md, $mth, $yr, $hr, $mn, $sc) = split(/[\-\.:]/, $ddate);
    # Convert the DO's date/time data; in particular capture the day of the year to compare with today #
    ($null, $null, $null, $null, $null, $null, $null, $YDAY, $null) = localtime(timelocal($sc, $mn, $hr, $md, $CARD{$mth}, $yr));
    # if the difference is >= the stated expiration value, remove the DO #
    if (($diff = ($TODAY - $YDAY) % $ENDDAY) >= $expired) {
	print "Number of days = $diff: $do\n";
	@sysargs = ($ctool, $rmdo, $do);
	!system(@sysargs) || warn "Can't remove $do from VOB";
    }
    return;
}

sub usage {
    print $USAGE;
    exit(0);
}

__END__
