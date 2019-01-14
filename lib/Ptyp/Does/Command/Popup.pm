
package Ptyp::Does::Command::Popup;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use Type::Params;
use Types::Standard -types;
use Types::Tcl::pTk -types;
use true;

use Mu::Role;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean;

requires 'command_play';
requires 'command_open_contact_url';
requires 'command_copy_contact_url';
requires 'command_copy_playlist_url';
requires 'command_copy_stream_url';
requires 'master';
requires 'xevent_identify';

sub command_popup($self, $tree, $yp_name) {
  state $c = compile(Object, TclpTkttkTreeview, Str); $c->(@_);

  my $item = $self->xevent_identify($tree);

  my sub play {
    $self->command_play($item,$yp_name)
  }

  my sub open_contact_url {
    $self->command_open_contact_url($item, $yp_name)
  }

  my sub copy_contact_url {
    $self->command_copy_contact_url($item, $yp_name);
  }

  my sub copy_playlist_url {
    $self->command_copy_playlist_url($item, $yp_name);
  }

  my sub copy_stream_url {
    $self->command_copy_stream_url($item, $yp_name);
  }

  my $popup = $self->master->Menu(-tearoff => 0);
  $popup->configure(-popover);
  $popup->command(-label => "Play",
                 -command => \&play);
  $popup->command(-label => "Tool Settings");
  $popup->separator;
  $popup->command(-label => "Open Contact URL with BBS Browser",
                 -command => \&open_contact_url);
  $popup->command(-label => "Open Contact URL");
  $popup->command(-label => "Open Chat URL");
  $popup->command(-label => "Open Statistics URL");
  $popup->separator;
  $popup->command(-label => "Copy Contact URL",
                 -command => \&copy_contact_url);
  $popup->command(-label => "Copy Playlist URL",
                 -command => \&copy_playlist_url);
  $popup->command(-label => "Copy Stream URL",
                 -command => \&copy_stream_url);
  $popup->separator;
  $popup->command(-label => "Add Channel Name to Filters");
  $popup->separator;
  $popup->command(-label => "Add to Farorites");

  $popup->Popup(-popover => 'cursor', -popanchor => 'nw');
}
