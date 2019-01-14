
package App::Ptyp;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use Tcl::pTk;
use Tcl::pTk::Tile;
use Package::Alias
  MainView           =>  'Ptyp::View::Main';

use true;

use Mus;
use MooX::LvalueAttribute;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean -except => [qw<new meta>];

ro 'master';

sub run ($self) {
  my $top            = $self->master;
  my $view = MainView->new(master => $top);
  $view->create;
  MainLoop;
}
