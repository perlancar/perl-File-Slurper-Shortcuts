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

=for Pod::Coverage ^(replace_text|replace_binary)$

=head1 SYNOPSIS

 use File::Slurper::Shortcuts qw(modify_text modify_binary);
 modify_text("dist.ini", sub { s/One/Two/ });


=head1 DESCRIPTION


=head1 FUNCTIONS

=head2 modify_text

Usage:

 $orig_content = modify_text($filename, $code, $encoding, $crlf);

This is L<File::Slurper>'s C<read_text> and C<write_text> combined. First,
C<read_text> is performed then the content of file is put into C<$_>. Then
C<$code> will be called and should modify C<$_> to modify the content of file.
Finally, C<write_text> is called to write the new content. If content (C<$_>)
does not change, file will not be written.

If file can't be read with C<read_text()> an exception will be thrown by
File::Slurper.

This function will also die if code does not return true.

If file can't be written with C<write_text()> an exception will be thrown by
File::Slurper.

Return the original content of file.

Note that no locking is performed and file is opened twice, so there might be
race condition etc.


=head2 modify_binary


=head1 SEE ALSO

L<File::Slurper>
