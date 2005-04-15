package Catalyst::Plugin::Pluggable;

use strict;

our $VERSION = '0.02';

=head1 NAME

Catalyst::Plugin::Pluggable - Plugin for Pluggable Catalyst applications

=head1 SYNOPSIS

    # use it
    use Catalyst qw/Pluggable/;

    $c->forward_all('do_stuff');

=head1 DESCRIPTION

Pluggable Catalyst applications. 

=head2 METHODS

=head3 $c->forward_all($action,[$sortref])

    Like C<forward>, but executes all actions with the same name in the
    whole application, ordered by class name by default.
    The optional $sortref parameter allows you to pass a code reference
    to a function that will be used in the sort function. The default
    here is { $a->[0]->[0] cmp $b->[0]->[0] }

=cut

sub forward_all {
    my ( $c, $action, $sort ) = @_;
    my @results;
    for my $uid ( keys %{ $c->actions->{private} } ) {
        if ( my $result = $c->actions->{private}->{$uid}->{$action} ) {
            push @results, [$result];
        }
    }
    $sort ||= sub { $a->[0]->[0] cmp $b->[0]->[0] };
    @results = sort $sort @results if @results;
    for my $result ( @results ) {
        $c->execute( @{ $result->[0] } );
        return if scalar @{ $c->error };
        last unless $c->state;
    }
    return $c->state;
}

=head1 SEE ALSO

L<Catalyst::Manual>, L<Catalyst::Test>, L<Catalyst::Request>,
L<Catalyst::Response>, L<Catalyst::Helper>

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 LICENSE

This library is free software . You can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;
