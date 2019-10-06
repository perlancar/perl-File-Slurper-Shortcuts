#!perl

use strict;
use warnings;
use Test::Exception;
use Test::More 0.98;

use File::Slurper qw(read_text write_text);
use File::Slurper::Shortcuts qw(modify_text modify_binary);
use File::Temp qw(tempdir);

my $dir = tempdir(CLEANUP => 1);

write_text("$dir/1", "foo");

is(modify_text("$dir/1", sub { s/o/u/g }), "foo");
is(read_text("$dir/1"), "fuu");

done_testing;
