#!perl
# WhiteSpace.pl
# This script will recursivley remove trailing spaces from all lines in all specified files.
# You can specifiy extensions in Subtoutine remove_ws.
#
use File::Path;
use File::Find;
use Tie::File;

my $dir = shift;

if ($dir ne '')
{
    &main();
    exit;
}
else
{   
    print "WhiteSpace.pl should be called like\"WhiteSpace.pl C:/Path/To/Directory\"";
    exit;
}

sub main
{
    &File::Find::finddepth(\&remove_ws,"$dir");
    exit;
}
sub remove_ws
{
    print "Checking $File::Find::name\n";
    return if (-d $File::Find::name);

    # Check Extension Here.
    if ($File::Find::name =~ /^.*\.(php|js)$/)
    {
        print "$File::Find::name is a PHP or JS file. Removing WS.\n";
        tie @lines, 'Tie::File', $File::Find::name or die;
        for(@lines)
        {
            s/^(.*?)\s+$/$1/g;
        }
        untie @lines;
    }
    return;
}
