
package Ptyp::Does::Command::CopyStreamUrl;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use Type::Params;
use Types::Standard -types;
use Type::Utils qw<compile_match_on_type union>;
use Types::Tcl::pTk -types;
use Types::Tcl -types;
use Function::Return;

use Mu::Role;

use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use true;
use namespace::clean;


requires 'state';
requires 'presenter';

sub command_copy_stream_url :Return(Any) ($self, $entry, $yp_name) {
  state $c = compile(Object, union([TclpTkttkTreeview,
                                    TclList]), Str); $c->(@_);

  state $match = compile_match_on_type (
    TclpTkttkTreeview() => sub {
      shift->selection;
    },
    TclList() => sub {
      shift->[1];                # Tcl::List [cell I002 #1]
    },
   );
  my $id = $match->($entry);
  my $channel = $self->state->get_channel($yp_name, $id);

  my $val = sprintf("http://%s:%s/stream/%s.%s?tip=%s",
                    $self->presenter->get_config->{'host'},
                    $self->presenter->get_config->{'port'},
                    $channel->channel_id,
                    lc $channel->content_type,
                    $channel->tracker);

  $self->master->call('clipboard', 'clear');
  $self->master->call('clipboard', 'append', $val);
  say "Coped value: " . $val;
}
