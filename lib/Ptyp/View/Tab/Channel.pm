
package Ptyp::View::Tab::Channel;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use List::AllUtils qw<reduce first>;
use Package::Alias MPV => 'PeerCast::Player::Mpv';
use true;
use Proc::Daemon;
use Tcl::pTk;
use Type::Params;
use Types::Standard -types;
use Type::Utils qw<compile_match_on_type union>;
use PeerCast::Types::YP -types;
use PeerCast::Types::Channel -types;
use Types::Tcl::pTk -types;
use Ptyp::State::View::ChannelList;
use Function::Return;

use Mus;
use MooX::LvalueAttribute;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean -except => [qw<new meta>];

ro 'master';

ro 'notebook';

ro 'presenter';

rw 'state' => (
  required => 0,
  isa => InstanceOf['Ptyp::State::View::ChannelList'],
  default => sub { Ptyp::State::View::ChannelList->new }
 );

rw page => (
  required => 0,
  isa => Map[Str, Maybe[TclpTkttkTreeview]],
  default  => sub {
    +{ 'All' => undef };
  }
 );

ro tab_name => (
  required => 0,
  default  => 'All'
 );

rw pagebar_state => (
  required => 0,
  isa => Map[Str, ScalarRef],
  lvalue => 1,
  default => sub { +{} }
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

sub refresh ($self) {
  my $state = $self->state;
  my $presenter = $self->presenter;
  my $page = $self->page;
  my @ids_all = keys $state->get_channels_by_name($self->tab_name)->%*;
  my $treeview = $page->{$self->tab_name};

  $treeview->delete($_) for @ids_all;
  $presenter->refresh_channels_p;
  $self->fill_channels(
    $treeview,
    $self->tab_name, $presenter->get_all_channels
   );

  foreach my $yp_name (keys $state->channel_to_item_id_mappings->%*) {
    if ($yp_name ne $self->tab_name) {
      my @ids = keys $state->get_channels_by_name($yp_name)->%*;
      my $yp = first {$_->name eq $yp_name} $presenter->get_yp_list->@*;
      my $target_treeview = $page->{$yp_name};
      $target_treeview->delete($_) for @ids;
      my $channels = $presenter->find_channel_by_yp_name($yp->name);
      $self->fill_channels($target_treeview, $yp->name, $channels);
    }
  }
}

sub create ($self) {

  my $note = $self->notebook;
  my $note_channel_frame = $note->ttkFrame;
  my $page_bar           = $note_channel_frame->ttkLabel;
  my $page_frame         = $note_channel_frame->ttkFrame;
  my $presenter = $self->presenter;

  $presenter->refresh_channels_p;
  $self->create_page(
    $page_frame, $page_bar, $self->tab_name,
    $presenter->get_all_channels
   );
  foreach my $yp ($presenter->get_yp_list->@*) {
    my $channels = $presenter->find_channel_by_yp_name($yp->name);
    $self->create_page($page_frame, $page_bar, $yp->name, $channels) ;
  }

  $page_bar->pack(-side => 'top', -fill => 'x');
  $page_frame->pack(-fill => 'both', -expand => 1);
  $page_frame->gridRowconfigure(0, -weight => 1);
  $page_frame->gridColumnconfigure(0, -weight => 1);

  my $tab_text = $self->make_text_with_total_channels(
    'Channel',
    $presenter->get_all_channels
   );
  $note->add($note_channel_frame, -text => $tab_text);

}

sub make_text_with_total_channels :Return(Str) ($self, $text, $channels) {
  state $c = compile(Object, Str, ArrayRef[Channel]);
  $c->(@_);
  my $channel_total = defined($channels) ? $channels->@* : 0;
  $channel_total ? $text . '(' . $channel_total . ')' : $text;
}

sub create_page ($self, $parent, $page_bar, $yp_name, $channels) {
  state $c = compile(Object, TclpTkttkFrame, TclpTkttkLabel, ChannelYPName, ArrayRef[Channel]);
  $c->(@_);
  my $page_frame = $parent->ttkFrame;
  my $page       = $page_frame->Scrolled(
    'ttkTreeview',
    -columns    => $self->presenter->get_header_columns,
    -show       => 'headings',
    -scrollbars => 'sw',
   );
  $self->page->{$yp_name} = $page;
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
  $page_frame->grid(-row => 0, -sticky => 'wens');
  $page->pack(-fill => 'both', -expand => 1);

  $self->create_page_button($page_frame, $page_bar, $yp_name, $channels);
  $self->create_page_separator($page_frame, $page_bar);

  $self->fill_channels($page, $yp_name, $channels);
}

sub create_page_button ($self, $parent, $page_bar, $yp_name, $channels) {
  state $c = compile(Object, TclpTkFrame, Object, YPName, ArrayRef[Channel]);
  my $check_var;
  my $check_var_ref = \$check_var;
  my $button_text = $self->make_text_with_total_channels(uc($yp_name), $channels);
  my $page_button = $page_bar->ttkCheckbutton(
    -text     => $button_text,
    -variable => $check_var_ref,
    -style    => 'Toolbutton',
    -command  => [
      sub ($name) {
        foreach my $k (sort keys $self->pagebar_state->%*) {
          $self->pagebar_state->{$k}->$* = 0  if $k ne $name;
        }
        $parent->raise;
      }
      ,
      $yp_name]);

  $self->pagebar_state->{$yp_name} = $check_var_ref;

  $page_button->pack(-side => 'left', -padx => 2);
}

sub create_page_separator($self, $parent, $page_bar) {
  my $sep = $page_bar->ttkSeparator(-orient => 'vertical');
  $sep->pack(-side => 'left', -fill => 'y', -padx => 1);
}

sub fill_channels ($self, $parent, $name, $channels) {
  state $c = compile(Object, TclpTkFrame, ChannelYPName, ArrayRef[Channel]);
  $c->(@_);
  if ($channels->@*) {
    $self->state->clear_channels($name);
    $parent->tagConfigure('channel', -background => 'black');
    foreach my $channel ($channels->@*) {
      my $item_id = $parent->insert('', 'end',
                                   -tags => 'channel',
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
    }
    $parent->bind('<Double-1>', sub { $self->command_play($_[0], $name) });
    $parent->bind('<Button-3>', sub { $self->command_select($_[0], $name) });
    $parent->bind('<ButtonRelease-3>', sub { $self->command_popup($_[0], $name) });

  }
}
