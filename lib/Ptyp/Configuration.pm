
package Ptyp::Configuration;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use true;
use File::Share qw<dist_dir dist_file>;
use Path::Tiny;
use Config::Hash;
use Hash::Merge::Simple qw<merge>;

use Mus;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean -except => [qw<new meta>];

has 'config' => (is => 'lazy');

rw default_config => (required => 0,
                     default =>
                     sub {
                       +{
                         yp_list => [
                           ['sp',      'http://bayonet.ddo.jp/sp/'],
                           ['tp',      'http://temp.orz.hm/yp/'],
                           ['hktv',    'http://games.himitsukichi.com/hktv/'],
                           ['shiba',   'http://peercast.takami98.net/turf-page/'],
                           ['op',      'http://oekakiyp.appspot.com/'],
                           ['eyp',     'http://eventyp.xrea.jp/'],
                           ['msg',     'http://peercast.takami98.net/message-yp/'],
                           ['tjyp',    'http://gerogugu.web.fc2.com/tjyp/'],
                           ['twitch',  'http://yp.kymt.me/twitch/'],
                           ['ie',      'http://ie.pcgw.pgw.jp/'],
                          ],
                         header_columns => [qw<Name
                                              Genre
                                              Description
                                              Message
                                              Viewer
                                              Contact
                                              Yp>],
                         host => "localhost",
                         port => "7144",
                         ignore_languages => [],
                       };
                     });

rw file_name => (required => 0,
                default => sub {
                  my $home_config = $ENV{'HOME'} . '/.config/ptyp/config.pl';
                  if ($home_config) {
                    $home_config;
                  } else {
                    dist_file('App-Ptyp', 'ptyp/config.pl') ;
                  }
                });

ro _config_accessor => (required => 0,
                       default => sub { Config::Hash->new });

sub _build_config ($self) {
  my $file = $self->file_name;
  my $config;
  if ( -e $file ) {
    my $user_config = $self->_config_accessor->read_config($file);
    merge $self->default_config, $user_config;
  } else {
    $self->default_config
  }
}

sub save ($self) {
  $self->_config_accessor->write_config($self->file_name, $self->config);
}
