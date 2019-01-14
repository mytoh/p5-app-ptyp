
package Ptyp::Presenter::Tab::New;

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

sub get_new_channels ($self) {
  $self->model->new_channels;
}

sub get_header_columns ($self) {
  $self->model->header_columns;
}

sub get_channels ($self) {
  $self->model->get_channels;
}
