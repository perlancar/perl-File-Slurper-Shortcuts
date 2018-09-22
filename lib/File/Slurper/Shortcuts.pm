package File::Slurper::Shortcuts;

# DATE
# VERSION

use strict;
use warnings;
use Carp;

use File::Slurper ();

use Exporter qw(import);
our @EXPORT_OK = qw(replace_text replace_binary);

sub replace_text {
    my ($filename, $code, $encoding, $crlf) = @_;

    local $_ = File::Slurper::read_text($filename, $encoding, $crlf);

    my $res = $code->($_);
    croak "replace_text(): Code does not return true" unless $res;

    File::Slurper::write_text($filename, $_, $encoding, $crlf);
}

sub replace_binary {
    return replace_text(@_[0,1], 'latin-1');
}

1;
# ABSTRACT: Some convenience additions for File::Slurper

=head1 SYNOPSIS

 use File::Slurper::Shortcuts qw(replace_text replace_binary);
 replace_text("dist.ini", sub { s/One/Two/ });


=head1 DESCRIPTION


=head1 FUNCTIONS

=head2 replace_text

Usage:

 replace_text($filename, $code, $encoding, $crlf);

This is like L<File::Slurper>'s C<write_text> except that instead of C<$content>
in the second argument, this routine accepts C<$code>. Code will be have the
file's content in C<$_>, modify it, and return true. This routine will die if:
file can't be read with C<read_text()>, code does not return true, file can't be
written to with C<write_text()>.

=head2 replace_binary


=head1 SEE ALSO

L<File::Slurper>
