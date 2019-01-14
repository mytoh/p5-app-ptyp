
package Ptyp::Resource;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use Type::Params;
use Types::Standard -types;
use true;
use File::Share qw<dist_dir dist_file>;
use Path::Tiny;

use Mus;
use MooX::LvalueAttribute;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean -except => [qw<new meta>];


has 'icon' => (is => 'lazy');

sub _build_icon ($self) {
  # my $dir = path(dist_file('App-Ptyp', 'ptyp/icon'));
  my $dir = path("/usr/local/share/icons/oxygen/16x16/actions");
  +{
    refresh => $dir->child('view-refresh.png')->stringify,
    notification => $dir->child('help-hint.png')->stringify,
    sort         => $dir->child('view-sort-ascending.png')->stringify,
    template     => $dir->child('window-duplicate.png')->stringify,
    display      => $dir->child('view-process-system.png')->stringify,
    option       => $dir->child('configure.png')->stringify,
    theme        => $dir->child('format-fill-color.png')->stringify,
  }
    # + {
    #   refresh      => $dir->child('icon1.png')->stringify,
    #   notification => $dir->child('icon2.png')->stringify,
    #   sort         => $dir->child('icon3.png')->stringify,
    #   template     => $dir->child('icon4.png')->stringify,
    #   display      => $dir->child('icon5.png')->stringify,
    #   option       => $dir->child('icon6.png')->stringify,
    #   theme        => $dir->child('icon7.png')->stringify,
    # }

}
