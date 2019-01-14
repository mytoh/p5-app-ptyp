
package Ptyp::View::Tab::New;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use true;
use Tcl::pTk;
use Type::Params;
use Types::Standard -types;
use Type::Utils qw<compile_match_on_type union>;
use PeerCast::Types::YP -types;
use Types::Tcl -types;
use Types::Tcl::pTk -types;
use PeerCast::Types::Channel -types;
use List::AllUtils qw<reduce>;
use Ptyp::State::View::ChannelList;

use Mus;
use MooX::LvalueAttribute;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean -except => [qw<new meta>];

ro 'master';
ro 'notebook';
ro 'presenter';

rw note => (required =>0);

rw 'state' => (
  required => 0,
  isa => InstanceOf['Ptyp::State::View::ChannelList'],
  default => sub { Ptyp::State::View::ChannelList->new }
 );

rw page => (
  required => 0,
  default => sub {
    +{
      'New' => undef,
    };
  }
 );
ro tab_name => (
  required => 0,
  default => 'New'
 );

with 'Ptyp::Does::SortableView',
  'Ptyp::Does::Command::Popup',
  'Ptyp::Does::Command::OpenContactUrl',
  'Ptyp::Does::Command::Select',
  'Ptyp::Does::Command::Play',
  'Ptyp::Does::Command::CopyContactUrl',
  'Ptyp::Does::Command::CopyStreamUrl',
  'Ptyp::Does::Command::CopyPlaylistUrl',
  'Ptyp::Does::View::Refresh',
  'Ptyp::Does::View::Create',
  'Does::Tcl::pTk::XEventIdentifiable';

sub create ($self) {
  my $note = $self->notebook;
  $self->note($note);
  my $note_channel_frame = $note->ttkFrame;
  my $page_frame = $note_channel_frame->ttkFrame;

  # $self->presenter->refresh_channels;
  $self->create_page($page_frame);

  $page_frame->pack(-fill => 'both', -expand => 1);
  $page_frame->gridRowconfigure(0, -weight => 1);
  $page_frame->gridColumnconfigure(0,  -weight => 1);

  my $tab_text =$self->make_text_with_total_channels(
    $self->tab_name,
    $self->presenter->get_new_channels
   );
  $note->add($note_channel_frame, -text => $tab_text);
}

sub make_text_with_total_channels ($self, $text, $channels) {
  my $channel_total =  defined($channels) ? $channels->@* : 0;
  $channel_total ? $text . '(' . $channel_total . ')' : $text;
}

sub create_page ($self, $parent) {
  my $page_frame = $parent->ttkFrame;
  my $page       = $page_frame->Scrolled(
    'ttkTreeview',
    -columns => $self->presenter->get_header_columns,
    -show => 'headings',
    -scrollbars => 'sw',
   );
  $self->page->{$self->tab_name} = $page;

  foreach my $col ($self->presenter->get_header_columns->@*) {
    $page->heading(
      $col,
      -command => [
        sub ($tree, $col, $dir) {
          $self->sort_by($tree, $col, $dir);
        }
        ,
        $page->Subwidget('scrolled'),
        $col,
        0
       ],
      -text => $col
     );
  }

  my $channels = $self->presenter->get_new_channels;
  $self->fill_channel($page, $self->tab_name, $channels);

  $page_frame->grid(-row => 0, -sticky => 'wens');
  $page->pack(-fill => 'both', -expand => 1);

  $page_frame->raise;
}

sub fill_channel ($self, $parent, $name, $channels) {
  state $c = compile(Object, TclpTkFrame, Str, Maybe[ArrayRef[Channel]]);
  $c->(@_);
  if (defined $channels) {
    $self->state->clear_channels($name);

    foreach my $channel ($channels->@*) {
      my $item_id = $parent->insert(
        '', 'end',
        -values => [
          $channel->name,
          $channel->genre,
          $channel->description,
          $channel->comment,
          $channel->listeners,
          $channel->contact_url,
          $channel->yp_name
         ]
       );
      $self->state->add_channel($name, $item_id, $channel);
      $parent->bind('<Double-1>', sub {$self->command_play($_[0], $name)});
      $parent->bind('<Button-3>', sub {$self->command_select($_[0], $name)});
      $parent->bind('<ButtonRelease-3>', sub {$self->command_popup($_[0], $name)});
    }
  } else {
    my @ids_new = keys $self->state->get_channels_by_name($name)->%*;
    $self->page->{$name}->delete($_) for @ids_new;
    $self->state->delete_channels_by_id($name, @ids_new);
  }
}

sub refresh ($self) {
  my @ids_new = keys $self->state->get_channels_by_name($self->tab_name)->%*;
  $self->page->{$self->tab_name}->delete($_) for @ids_new;
  $self->state->delete_channels_by_id($self->tab_name, @ids_new);

  $self->note->tab(
    '1',
    -text => $self->make_text_with_total_channels($self->tab_name, $self->presenter->get_new_channels)
   );
  $self->fill_channel($self->page->{$self->tab_name}, $self->tab_name, $self->presenter->get_new_channels);
}
