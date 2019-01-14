
package Ptyp::Does::Command::Select;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use Type::Params;
use Types::Standard -types;
use true;

use Mu::Role;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean;

requires 'xevent_identify';

sub command_select ($self, $tree, $yp_name) {
  my $item = $self->xevent_identify($tree);
  my $iid = $item->[1];
  $tree->selectionSet($iid);
}
