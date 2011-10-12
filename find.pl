use File::Find;
use Tie::File;
use FindBin qw($Bin);

print "$0 Requires atleast two arguments. Directory and Pattern to find.\n3 Arguments for a find and replace.\n" if (@ARGV < 2 || @ARGV > 3);

my ($sec,$min,$hour,$mday,$month,$year,@rest) =   localtime(time);
$mon += 1;
$year += 1900;
$mday = sprintf("%02d",$mday);
my $timestamp = "$year-$month-$mday ".sprintf("%02d",$hour).":".sprintf("%02d",$min).":".sprintf("%02d",$sec);

if (@ARGV eq 2)
{
    my $dir = shift;
    our $pattern = shift;
    $dir = &convert_dir($dir);
    &log("Grep","\nGrep at time: $timestamp\nLooking for $pattern recursively starting with $dir");
    &File::Find::finddepth({ wanted => \&grepc, no_chdir},"$dir");
}
elsif (@ARGV eq 3)
{
    my $dir = shift;
    our $pattern = shift; 
    our $replace = shift;
    $dir = &convert_dir($dir);
    &log("Replace","\nReplace at time: $timestamp\nReplacing $pattern with $replace recursively starting with $dir");    
    &verify();
    &File::Find::find(\&find_and_replace,"$dir");
}
else
{
    print "Unknown number of Argumments\n";
    exit;
}

sub grepc
{
    my $file = $File::Find::name;
    return if (-d $file);
    open(FILE, "<$file");
    @lines = <FILE>;
    close (FILE);
    my $match_cnt =0;

    for (@lines)
    {
        if( $_ =~ m/$pattern/g)
        {
            $match_cnt++;
        }     
    }
    &log("Grep","$file has $match_cnt matches to $pattern") if ($match_cnt > 0);
    return;
}

sub convert_dir
{
    my $dir = shift;
    $dir =~ s/\\/\//gi;
    return $dir;
}

sub find_and_replace
{
    my $pattern = shift;
    my $replace = shift;
    my $replace_cnt =0;
    my $file = $File::Find::name; 
    return if (-d $file);

    tie @lines, 'Tie::File', $File::Find::name or die;
    for(@lines)
    {
        if ($_ =~ /$pattern/ig)
        {
            s/$pattern/$replace/g;
            $replace_cnt++;
        }
    }
    untie @lines;
    &log("Replace","Replaced $pattern with $replace $replace_cnt times in $file") if ($replace_cnt > 0);
}

sub log
{
    my $type = shift;
    my $msg = shift;
    open(LOG,">>$Bin\\$type.log");
    print LOG "$msg\n";
    close(LOG);
    return;
}
sub verify
{
    my $dir = shift;
    print "Warning! This will modify all files in $dir that have $pattern and replace it with $replace\n";
    chomp (my $response = <>);
    
    if ($response =~ /y/i)
    {
        return;
    }
    else
    {
        print "Nothing was done.\n";
        exit;
    }
}
