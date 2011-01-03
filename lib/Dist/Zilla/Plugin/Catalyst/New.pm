use strict;
use warnings;
package Dist::Zilla::Plugin::Catalyst::New;
BEGIN {
	our $VERSION = 0.09;# VERSION
}
use Moose;
use Dist::Zilla::Catalyst::Helper;
with qw( Dist::Zilla::Role::ModuleMaker );

use Dist::Zilla::File::FromCode;

sub make_module {
	my ( $self ) = @_;

	if ( $Catalyst::Helper::VERSION <= 1.28 ) {
		$self->log('getting authors from ENV variable AUTHOR not dzil');
	}

	# format $name to what C::Helper wants
	my $name = $self->zilla->name;
	$name =~ s/-/::/g;

	# turn authors into a scalar it's what C::Helper wants
	my $authors = join( ',', @{$self->zilla->authors} );

	my $helper
		= Dist::Zilla::Catalyst::Helper->new({
			name            => $name,
			author          => $authors,
			_zilla_gatherer => $self,
		});

	# $name here is for backcompat in older versions of C::Devel
	$helper->mk_app( $name );
}
__PACKAGE__->meta->make_immutable;
no Moose;
1;
# ABSTRACT: create a new catalyst project with dzil new


__END__
=pod

=head1 NAME

Dist::Zilla::Plugin::Catalyst::New - create a new catalyst project with dzil new

=head1 VERSION

version 0.09

=head1 SYNOPSIS

in C<{home}/.dzil/profiles/{profile}/profile.ini>

	[Catalyst::New / :DefaultModuleMaker]

=head1 DESCRIPTION

this plugin is used to generate the same files L<Catalyst::Helper> does when
C<catalyst.pl App::Name> is run.

=head1 EXAMPLE

You probably want more than just the bare minimum profile.ini, here's a more
functional one. I suggest putting it in
C<{home}/.dzil/profiles/catalyst/profile.ini>

	[DistINI]
	[Catalyst::New / :DefaultModuleMaker]
	[Git::Init]

Now you can run the following command to create a skeleton catalyst app.

	dzil new -p catalyst MyApp

Obviously C<MyApp> is arbitrary and can be named whatever you like.

=head1 METHODS

=over

=item * make_module

required see L<Dist::Zilla::Role::ModuleMaker>

=back

=head1 BUGS

or features depending on your opinion and the nature of the issue. The
following are known "issue's".

=over

=item * Doesn't create all the files catalyst.pl does

Some files like README, Makefile.PL and some of the tests, etc, are better
generated by C<dzil>. Use existing dzil plugins to generate these.

=back

For all other problems use the bug tracker

=head1 AUTHORS

=over 4

=item *

Caleb Cushing <xenoterracide@gmail.com>

=item *

Tomas Doran <bobtfish@bobtfish.net>

=back

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

