
package Ptyp::Does::Command::OpenContactUrl;

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

use Mu::Role;

use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use true;
use namespace::clean;

requires 'state';

sub command_open_contact_url ($self, $entry, $yp_name) {
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
  my $url = $channel->contact_url;
  say $url;
  my $daemon = Proc::Daemon->new(
    exec_command => "ptresbrowser.pl $url",
   );
  my $pid = $daemon->Init();
  say "BBS Browser started with PID $pid";
}
