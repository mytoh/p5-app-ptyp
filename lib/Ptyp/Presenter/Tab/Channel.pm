
package Ptyp::Presenter::Tab::Channel;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use Ptyp::Configuration;
use PeerCast::Types::YP -types;
use PeerCast::Types::Channel -types;
use Return::Type;
use true;

use Mus;
use MooX::LvalueAttribute;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean -except => [qw<new meta>];

ro 'model';

sub get_yp_list ($self) {
  $self->model->yp_list;
}

sub get_header_columns ($self) {
  $self->model->header_columns;
}

sub get_all_channels ($self) {
  $self->model->current_channels;
}

sub refresh_channels ($self) {
  $self->model->refresh_channels;
}

sub refresh_channels_p ($self) {
  $self->model->refresh_channels_p;
}

sub find_channel_by_yp_name ($self, $name) {
  [grep { fc $_->yp_name eq fc $name } $self->get_all_channels->@*];
}

sub get_config ($self) {
  $self->model->configuration->config;
}
