package File::Slurper::Shortcuts;

# DATE
# VERSION

use strict 'subs', 'vars';
use warnings;
no warnings 'once';
use Carp;

use File::Slurper ();

use Exporter qw(import);
our @EXPORT_OK = qw(
                       modify_text
                       modify_binary
                       replace_text
                       replace_binary
               );

sub modify_text {
    my ($filename, $code, $encoding, $crlf) = @_;

    local $_ = File::Slurper::read_text($filename, $encoding, $crlf);
    my $orig = $_;

    my $res = $code->($_);
    croak "replace_text(): Code does not return true" unless $res;

    return if $orig eq $_;

    File::Slurper::write_text($filename, $_, $encoding, $crlf);
    $orig;
}

sub modify_binary {
    return modify_text(@_[0,1], 'latin-1');
}

# old names, deprecated and will be removed in the future
*replace_text = \&modify_text;
*replace_binary = \&modify_binary;

1;
# ABSTRACT: Some convenience additions for File::Slurper

=head1 SYNOPSIS

 use File::Slurper::Shortcuts qw(modify_text modify_binary);
 modify_text("dist.ini", sub { s/One/Two/ });


=head1 DESCRIPTION


=head1 FUNCTIONS

=head2 modify_text

Usage:

 $orig_content = modify_text($filename, $code, $encoding, $crlf);

This is like L<File::Slurper>'s C<write_text> except that instead of C<$content>
in the second argument, this routine accepts C<$code>. Code should modify C<$_>
(which contains the content of the file) B<and return true>. This routine will
die if: file can't be read with C<read_text()>, code does not return true, file
can't be written to with C<write_text()>.

If content (C<$_>) does not change, file will not be written.

Return the original content of file.

=head2 modify_binary


=head1 SEE ALSO

L<File::Slurper>
