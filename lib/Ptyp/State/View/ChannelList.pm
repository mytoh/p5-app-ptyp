
package Ptyp::State::View::ChannelList;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use Type::Params;
use Types::Standard -types;
use PeerCast::Types::Channel -types;
use true;

use Mus;
use MooX::LvalueAttribute;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean -except => [qw<new meta>];

rw channel_to_item_id_mappings => (
  required => 0,
  default  => sub { +{} },
  lvalue   => 1
 );

sub add_channel ($self, $name, $id, $channel) {
  $self->channel_to_item_id_mappings->{$name}{$id} = $channel;
}

sub get_channel ($self, $name, $id) {
  $self->channel_to_item_id_mappings->{$name}{$id};
}

sub get_channels_by_name ($self, $name) {
  $self->channel_to_item_id_mappings->{$name};
}

sub clear_channels ($self, $name) {
  delete $self->channel_to_item_id_mappings->{$name}; # "undef $self->value()" might be better
  $self->channel_to_item_id_mappings->{$name} = +{};
}

sub delete_channels_by_id ($self, $name, @ids) {
  delete $self->get_channels_by_name($name)->@{@ids};
}
