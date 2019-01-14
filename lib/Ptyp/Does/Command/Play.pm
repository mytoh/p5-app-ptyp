
package Ptyp::Does::Command::Play;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use true;
use Type::Params;
use Types::Standard -types;
use Type::Utils qw<compile_match_on_type union>;
use Types::Tcl::pTk -types;
use Types::Tcl -types;

use Mu::Role;
use MooX::LvalueAttribute;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean;

requires 'state';
requires 'presenter';

sub command_play ($self, $entry, $name) {
  state $c = compile(Object, union([TclpTkttkTreeview, TclList]), Str); $c->(@_);

  state $match = compile_match_on_type (
    TclpTkttkTreeview() => sub {
      shift->selection;
    },
    TclList() => sub {
      shift->[1];                # Tcl::List [cell I002 #1]
    },
   );
  my $id = $match->($entry);
  my $player = MPV->new;
  my $channel = $self->state->get_channel($name, $id);
  $player->play_channel($self->presenter->get_config, $channel);
}
