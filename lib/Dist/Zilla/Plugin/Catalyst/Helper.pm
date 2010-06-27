use strict;
use warnings;
package Dist::Zilla::Plugin::Catalyst::Helper;
BEGIN {
  $Dist::Zilla::Plugin::Catalyst::Helper::VERSION = '0.01';
}
use Moose;
use Dist::Zilla::File::InMemory;

extends 'Catalyst::Helper';

has _zilla_gatherer => (
	is       => 'ro',
	required => 1,
	handles  => {
		_zilla_add_file => 'add_file',
	},
);

# we don't want these to do anything
sub _mk_makefile {};
sub _mk_readme {};
sub _mk_apptest {};

sub mk_file {
	my ( $self, $file_obj , $output ) = @_;

	# unfortunately the stringified $file_obj includes a prepended
	# {dist_repo} name which dzil already creates if we don't regex it out we
	# end up with {dist_repo}/{dist_repo}/{files} instead of just
	# {dist_repo}/{files}
	my $name = "$file_obj";
	$name =~ s{[\w-]+/}{};

	my $file
		= Dist::Zilla::File::InMemory->new({
			name    => $name,
			content => $output,
		});

	$self->_zilla_add_file($file);
}
__PACKAGE__->meta->make_immutable;
no Moose;
1;
# ABSTRACT: a subclass of Catalyst::Helper


__END__
=pod

=head1 NAME

Dist::Zilla::Plugin::Catalyst::Helper - a subclass of Catalyst::Helper

=head1 VERSION

version 0.01

=head1 DESCRIPTION

this is used to override methods in L<Catalyst::Helper> so that it works
better with dzil.

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

  The Artistic License 2.0

=cut
