my $opt = {};

use FileHandle;
use Getopt::Long;

main();

sub main
{
    GetOptions
        (
                $opt, "--site:s", "--filelist:s", "--expect:s", "--ftp:s",
                        "--user:s", "--pass:s", "--type:s", "--ftpfile:s", 
                        "--debug"
        );

    _modifyDefaults($opt);
    my $code = _genFtpCode($opt);
    _execFtpCode($opt, $code);
}


sub _modifyDefaults
{
    my ($opt) = @_;

    my $fileopt = _parseFtpFile($opt) if ($opt->{'ftpfile'});
    %$opt = (%$fileopt, %$opt);

    $opt->{'expect'} = $opt->{'expect'} || $ENV{'EXPECT_EXEC'} ||
                                        "/usr/local/bin/expect -i"; 

    $opt->{'user'}     = $opt->{'user'} || $ENV{'EXPECT_USER'} || "anonymous";
    $opt->{'pass'}     = $opt->{'pass'} || $ENV{'EXPECT_PASS'} || "me@"; 
    $opt->{'ftp'}      = $opt->{'ftp'}    || $ENV{'FTP'}         || "ftp";
    $opt->{'type'}     = $opt->{'type'}   || $ENV{'EXPECT_TYPE'} || "bin";

    if ($opt->{'filelist'})
    {
        @{$opt->{'files'}} = split(' ', $opt->{'filelist'});
    }

    push( @{$opt->{'files'}}, @{$fileopt->{'files'}});
}

sub _parseFtpFile
{
    my ($opt) = @_;
    my $return = {}; 
    
    my $fh = new FileHandle("$opt->{'ftpfile'}") 
                                || die "Couldn't open $opt->{'ftpfile'}\n";

    my $line;
    while (defined ($line = <$fh>))
    {
        next if ($line !~ m"\w");
        if ($line =~ m":") { _addopt($return, $line);  }
        else               { _addfile($return, $line); }
    }
    $return;
}

sub _addopt
{
    my ($return, $line) = @_;
    my ($key, $val) = ($line =~ m"^\s*(.*?)\s*:\s*(.*?)\s*$");
    $return->{$key} = $val;
}
sub _addfile
{
    my ($return, $line) = @_;

    my ($val) = ($line =~ m"^\s*(.*)\s*");
    push (@{$return->{'files'}}, $val);
}

sub _genFtpCode
{
    my ($opt) = @_;    

    my $line = '';

    foreach $key ('user', 'pass') { $opt->{$key} =~ s"[\$\\]"\\$1"g; }

$line .=<<"EOL"
set timeout -1

spawn $opt->{'ftp'} $opt->{'site'}
expect {
    "Name*):*" { send "$opt->{'user'}\\r" }
    "failed" { send "quit\\r"; exit 1; }
    "error*" { send "quit\\r"; exit 1; }
    timeout  { puts "Timed Out\\n"; exit 1; }
    "Service not available" { puts "Connection Dropped\\n"; exit 1; }
    "ftp>*" { send "quit\\r"; exit 1 }
}

expect {
    "assword:" { send "$opt->{'pass'}\\r" }
    "failed" { send "quit\\r"; exit 1; }
    "error*" { send "quit\\r"; exit 1; }
    "Service not available" { puts "Connection Dropped\\n"; exit 1; }
    timeout  { puts "Timed Out\\n"; exit 1; }
}

expect {
    "logged in" { send "\\r" }
    "onnected to*" { send "\\r" }
    "ftp>*" { send "\\r" }
    "failed" { send "quit\\r"; exit 1; }
    "error*" { send "quit\\r"; exit 1; }
    "Service not available" { puts "Connection Dropped\\n"; exit 1; }
    timeout { puts "Timed Out\\n"; exit 1; }
}

expect {
    "successful" { send "$opt->{'type'}\\r" }
    "onnected to*" { send "$opt->{'type'}\\r" }
    "ftp>" { send "$opt->{'type'}\\r" }
    "failed" { send "quit\\r"; exit 1; }
    "error*" { send "quit\\r"; exit 1; }
    "Service not available" { puts "Connection Dropped\\n"; exit 1; }
    timeout { puts "Timed Out\\n"; exit 1; }
}
EOL
;

foreach $file (@{$opt->{'files'}})
{
    $file =~ s"[\$\\]"\\$1"g; 
    my ($dir, $filename) = ($file =~ m"(.*)[/\\](.*)");
    $dir = $dir || "/";
    $filename = $filename || $file;

    $line .=<<"EOL"
    expect {
        "failed" { send "quit\\r"; exit 1; }
        "error*" { send "quit\\r"; exit 1; }
        "ftp>"  { send "cd $dir\\r" }
        Service not available" { puts "Connection Dropped\\n"; exit 1; }
        timeout { puts "Timed Out\\n"; exit 1; }
    }
    expect {
        "failed" { send "quit\\r"; exit 1; }
        "error*" { send "quit\\r"; exit 1; }
        "ftp>"  { send "get $filename\\r" }
        Service not available" { puts "Connection Dropped\\n"; exit 1; }
        timeout { puts "Timed Out\\n"; exit 1; }
    }
EOL
;
}

$line .=<<"EOL"
expect {
       "failed" { send "quit\\r"; exit 1; }
       "error*" { send "quit\\r"; exit 1; }
       "ftp>"  { send "quit\\r"; exit 0; }
    Service not available" { puts "Connection Dropped\\n"; exit 1; }
       timeout { puts "Timed Out\\n"; exit 1; }
}
EOL
;    
    $line;
}

sub _execFtpCode
{
    my ($opt, $code) = @_;

    my $exec = $opt->{'expect'};
    if ($opt->{'debug'})
    { 
        print "Generated code:\n$code\n"; 
    }
    else 
    { 
        open (EXPECT, "| $exec"); 
        print EXPECT $code;
        close(EXPECT);
    }
}
