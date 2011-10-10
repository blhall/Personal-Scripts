#!perl
# This file will recursivley move through directory trees and delete directories that are empty.
#
use File::Path;
use File::Find;
use Win32::File;

my $dir = "E:/TVshows";

&main();

sub main
{
    &File::Find::find(\&process_hidden,"$dir");
    &finddepth(sub{rmdir},"$dir");
	exit;
}
sub process_hidden
{
	if ((-f $_) && (Win32::File::GetAttributes($_,$attr)) && ($attr & HIDDEN))
    { 
        if (unlink($File::Find::name))
        {
            return;
        }
        else
        {
            chmod 0777, $File::Find::name;
            unlink($File::Find::name);    
        };
    }
}
