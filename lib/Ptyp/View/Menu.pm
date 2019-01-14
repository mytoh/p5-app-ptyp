
package Ptyp::View::Menu;

use Mus;
use v5.28;
use utf8;
use strictures 2;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use re 'strict';
use Types::Standard -types;
use true;

use namespace::clean -except => [qw<new meta>];

ro 'master';
ro 'views';

with 'Ptyp::Does::View::Create';

sub create ($self) {
  my $master = $self->master;
  my $menubar = $master->Menu(-type => 'menubar', -tearoff => 0,);
  $master->configure(-menu => $menubar);

  my $menu_file = $menubar->cascade(-label => 'File', -tearoff => 0);
  # $menu_file->separator();
  $menu_file->command(-label => 'Quit',
                     -command => sub {$master->destroy});

  $self->create_menu_refresh($menubar);
  $self->create_menu_notification($menubar);

  my $menu_display = $menubar->cascade(-label => 'Display', -tearoff => 0);
  my $menu_option = $menubar->cascade(-label => 'Option', -tearoff => 0);
}

sub create_menu_notification ($self, $menubar) {

  my $checkvar_notify_new_channel;
  my $checkvar_notify_new_channel_filter;
  my $checkvar_notify_refresh_success;
  my $checkvar_notify_refresh_failure;
  my $checkvar_make_all_channel_new;
  my $checkvar_make_all_channel_broadcasting;
  my @colors = (-foreground => '#eceff4', -background => '#3B4252');
  my @background_color = (-background => '#3B4252');
  $menubar->Cascade(-label => 'Notification', -tearoff => 0,
                   -menuitems => [
                     [Button => "Open Notification Log",
                      -command => sub { say "Open Notfication Log Window"}],
                     [Separator => '.'],
                     [Checkbutton => 'New Channel', -variable => \$checkvar_notify_new_channel],
                     [Checkbutton => 'New Channel for Filters', -variable => \$checkvar_notify_new_channel_filter],
                     [Separator => '.'],
                     [Checkbutton => 'Channel List Refresh Success',-variable => \$checkvar_notify_refresh_success],
                     [Checkbutton => 'Channel List Refresh Failure',-variable => \$checkvar_notify_refresh_failure],
                     [Separator => '.'],
                     [Checkbutton => 'Make All Channels as New when First Refresh', -variable => \$checkvar_make_all_channel_new],
                     [Checkbutton => 'Make All Channels which is still Broadcasting', -variable => \$checkvar_make_all_channel_broadcasting],
                    ]);
}

sub create_menu_refresh ($self, $menubar) {
  # my $menu_refresh = $menubar->cascade(-label => 'Refresh', -tearoff => 0);
  # $menu_refresh->command(-label => 'Refresh Channel List',
  #                       -command => sub { $_->refresh for $self->views->@* });

  my $checkvar_auto_refresh;
  my $checkvar_auto_refresh_interval;
  my $checkvar_enabel_auto_refresh_on_startup;
  my $checkvar_endded_channel_method;
  my $checkvar_auto_cleanup_ended_channels;
  my @colors = (-foreground => '#eceff4', -background => '#3B4252');
  my @background_color = (-background => '#3B4252');
  $menubar->Cascade(-label => '~Refrsh', -tearoff => 0,
                   -menuitems => [
                     [Button => 'Refresh Channel List',
                      -command => sub {$_->refresh for $self->views->@*}],
                     [Separator => '',  -background => '#000000'],
                     [Checkbutton => 'Auto Refresh',          -variable => \$checkvar_auto_refresh],
                     [Separator => ''],
                     [Cascade => 'Auto Refresh Interval',     -tearoff => 0,
                      -menuitems =>
                      [
                        map {
                          [Radiobutton => "$_ minute(s)", -variable => \$checkvar_auto_refresh_interval,
                           -value => $_,
                          ]
                        }
                        (qw<1 2 3 4 5 10 15 20 25 30>),
                       ]
                     ],
                     [Checkbutton => 'Enable Auto Refresh on Startup', -variable => \$checkvar_enabel_auto_refresh_on_startup],
                     [Separator => ''],
                     [Cascade => 'How to Check Ended Channel',     -tearoff => 0,
                      -menuitems =>
                      [
                        [Radiobutton => "Not on Channel List when Refresh", -variable => \$checkvar_endded_channel_method,
                         -value => 'not_on_channel_list',
                        ],
                        [Radiobutton => "Not on Channel List for 2 refresh", -variable => \$checkvar_endded_channel_method,
                         -value => 'not_on_channel_list_2_refresh',
                        ],
                        [Radiobutton => "more than 3 times", -variable => \$checkvar_endded_channel_method,
                         -value => 'not_on_channel_list_3_refresh',
                        ],
                        [Radiobutton => "more than 4 times", -variable => \$checkvar_endded_channel_method,
                         -value => 'not_on_channel_list_4_refresh',
                        ],
                        [Radiobutton => "more than 5 times", -variable => \$checkvar_endded_channel_method,
                         -value => 'not_on_channel_list_5_refresh',
                        ],
                       ]
                     ],
                     [Cascade => 'Auto-Cleanup Ended Channel List', -tearoff => 0,
                      -menuitems =>
                      [
                        [Radiobutton => "Delete All Channels", -variable => \$checkvar_auto_cleanup_ended_channels,
                         -value => 'delete_all_chanels',
                        ],
                        [Radiobutton => "Detected as Ended more than 2 times", -variable => \$checkvar_auto_cleanup_ended_channels,
                         -value => 'detected_ended_2',
                        ],
                        [Radiobutton => "more than 3 times", -variable => \$checkvar_auto_cleanup_ended_channels,
                         -value => 'detected_ended_3',
                        ],
                        [Radiobutton => "more than 4 times", -variable => \$checkvar_auto_cleanup_ended_channels,
                         -value => 'detected_ended_4',
                        ],
                        [Radiobutton => "more than 5 times", -variable => \$checkvar_auto_cleanup_ended_channels,
                         -value => 'detected_ended_5',
                        ],
                        [Radiobutton => "more than 10 times", -variable => \$checkvar_auto_cleanup_ended_channels,
                         -value => 'detected_ended_10',
                        ],
                        [Radiobutton => "more than 50 times", -variable => \$checkvar_auto_cleanup_ended_channels,
                         -value => 'detected_ended_50',
                        ],
                        [Radiobutton => "more than 100 times", -variable => \$checkvar_auto_cleanup_ended_channels,
                         -value => 'detected_ended_100',
                        ],
                        [Radiobutton => "Don't delete Ended Channels", -variable => \$checkvar_auto_cleanup_ended_channels,
                         -value => 'dont_delete',
                        ],
                       ]
                     ],
                     [Button => 'Cleaer Ended Channel List',
                      -command => sub { say "Clear Ended Channels"}]

                    ]);
}


# my $c = $menubar->Cascade(qw/-label ~Cascades -tearoff 0 -menuitems/ =>
#     [
#  [Button => 'Print ~hello',   -command => sub {print "Hello\n"},
#   -accelerator => 'Control+a'],
#  [Button => 'Print ~goodbye', -command => sub {print "Goodbye\n"},
#   -accelerator => 'Control+b'],
#  [Cascade => $menu_cb, -tearoff => 0, -menuitems =>
#   [
#    [Checkbutton => 'Oil checked',          -variable => \$OIL],
#    [Checkbutton => 'Transmission checked', -variable => \$TRANS],
#    [Checkbutton => 'Brakes checked',       -variable => \$BRAKES],
#    [Checkbutton => 'Lights checked',       -variable => \$LIGHTS],
#    [Separator => ''],
#    [Button => 'See current values', -command =>
#     [\&see_vars, $TOP, [
# 			['oil',     \$OIL],
# 			['trans',   \$TRANS],
# 			['brakes',  \$BRAKES],
# 			['lights',  \$LIGHTS],
# 			],
#         ], # end see_vars
#    ], # end button
#   ], # end checkbutton menuitems
#  ], # end checkbuttons cascade
#  [Cascade => $menu_rb, -tearoff => 0, -menuitems =>
#   [
#    map (
# 	[Radiobutton => "$_ point", -variable => \$POINT_SIZE,
# 	 -value => $_,
# 	 ],
# 	(qw/10 14 18 24 32/),
# 	),
#    [Separator => ''],
#    map (
# 	[Radiobutton => "$_", -variable => \$FONT_STYLE,
# 	 -value => $_,
# 	 ],
# 	(qw/Roman Bold Italic/),
# 	),
#    [Separator => ''],
#    [Button => 'See current values', -command =>
#     [\&see_vars, $TOP, [
# 			['point size', \$POINT_SIZE],
# 			['font style', \$FONT_STYLE],
# 			],
#      ], # end see_vars
#     ], # end button
#    ], # end radiobutton menuitems
#   ], # end radiobuttons cascade
#      ],
# );
