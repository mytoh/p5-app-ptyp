
package Ptyp::View::Toolbar;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use Type::Params;
use Types::Standard -types;
use true;

use Mus;
use MooX::LvalueAttribute;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean -except => [qw<new meta>];

ro 'master';
ro 'views';
ro 'resource';

with 'Ptyp::Does::View::Create';

sub create ($self) {
  my $master = $self->master;
  my $toolbar_frame = $master->ttkFrame;
  my $resource = $self->resource;

  my $refresh_icon      = $master->Photo(-file => $resource->icon->{'refresh'});
  my $notification_icon = $master->Photo(-file => $resource->icon->{ 'notification' });
  my $sort_icon         = $master->Photo(-file => $resource->icon->{ 'sort' });
  my $template_icon     = $master->Photo(-file => $resource->icon->{ 'template' });
  my $display_icon      = $master->Photo(-file => $resource->icon->{ 'display' });
  my $option_icon       = $master->Photo(-file => $resource->icon->{ 'option' });
  my $theme_icon        = $master->Photo(-file => $resource->icon->{ 'theme' });

  # -style => 'TMenubutton.Toolbutton'
  my $menubutton_refresh = $toolbar_frame->ttkMenubutton( -image => $refresh_icon,
                                                         -direction => 'below',);
  my $menubutton_notification = $toolbar_frame->ttkMenubutton( -image => $notification_icon,
                                                              -direction => 'below');
  my $menubutton_sort = $toolbar_frame->ttkMenubutton( -image => $sort_icon,
                                                      -direction => 'below');
  my $menubutton_template = $toolbar_frame->ttkMenubutton( -image => $template_icon,
                                                          -direction => 'below');
  my $menubutton_display = $toolbar_frame->ttkMenubutton( -image => $display_icon,
                                                         -direction => 'below');
  my $menubutton_option = $toolbar_frame->ttkMenubutton( -image => $option_icon,
                                                        -direction => 'below');
  my $menubutton_theme = $toolbar_frame->ttkMenubutton( -image => $theme_icon,
                                                       -direction => 'below');


  my $menu_refresh = $menubutton_refresh->Menu(-tearoff => 0);
  $menubutton_refresh->configure(-menu => $menu_refresh);
  $menu_refresh->add('command', -label => 'Refresh Channel List', -command => sub {  $_->refresh for $self->views->@* });
  $menubutton_refresh->pack(-side => 'left', -padx => 4);


  my $menubuttons = [$menubutton_notification,
                     $menubutton_sort,
                     $menubutton_template,
                     $menubutton_display,
                     $menubutton_option,
                     $menubutton_theme];

  foreach my $mb ($menubuttons->@*) {
    my $menu = $mb->Menu(-tearoff => 0);
    $mb->configure(-menu => $menu);
    foreach my $theme ( $master->ttkThemes ) {
      $menu->add('command', -label, $theme, -command => sub{ $master->ttkSetTheme($theme) });
    }
    $mb->pack(-side => 'left', -padx => 4);
  }

  $toolbar_frame->pack(-fill => 'x', -side => 'top');

  # my $menubar = $master->Menu(-type => 'menubar', -tearoff => 0);
  # $master->configure(-menu => $menubar);

  # my $menu_file = $menubar->cascade(-label => 'File', -tearoff => 0);
  # $menu_file->separator;
  # $menu_file->command(-label => 'Quit',
  #   -command => sub {$master->destroy});

  # my $menu_refresh = $menubar->cascade(-label => 'Refresh', -tearoff => 0);
  # $menu_refresh->command(-label => 'Refresh Channel List',
  #   -command => sub { $_->refresh for $self->views->@* });

  # my $menu_notification = $menubar->cascade(-label => 'Notification', -tearoff => 0);
  # my $menu_display = $menubar->cascade(-label => 'Display', -tearoff => 0);
  # my $menu_option = $menubar->cascade(-label => 'Option', -tearoff => 0);
}
