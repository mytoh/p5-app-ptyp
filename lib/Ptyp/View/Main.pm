
package Ptyp::View::Main;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;

use Ptyp::Model::ChannelList;
use Package::Alias
  TabChannel        => 'Ptyp::View::Tab::Channel',
  TabFavorite       => 'Ptyp::View::Tab::Favorite',
  TabNew            => 'Ptyp::View::Tab::New',
  TabPlay           => 'Ptyp::View::Tab::Play',
  TabIgnore         => 'Ptyp::View::Tab::Ignore',
  TabEnd            => 'Ptyp::View::Tab::End',
  TabSearch         => 'Ptyp::View::Tab::Search',
  TabDownload       => 'Ptyp::View::Tab::Download',
  TabFilter         => 'Ptyp::View::Tab::Filter',
  Menu              => 'Ptyp::View::Menu',
  Toolbar           => 'Ptyp::View::Toolbar',
  ChannelPresenter  => 'Ptyp::Presenter::Tab::Channel',
  NewPresenter      => 'Ptyp::Presenter::Tab::New',
  FavoritePresenter => 'Ptyp::Presenter::Tab::Favorite',
  PlayPresenter     => 'Ptyp::Presenter::Tab::Play',
  IgnorePresenter   => 'Ptyp::Presenter::Tab::Ignore',
  EndPresenter      => 'Ptyp::Presenter::Tab::End',
  SearchPresenter   => 'Ptyp::Presenter::Tab::Search',
  DownloadPresenter => 'Ptyp::Presenter::Tab::Download',
  FilterPresenter   => 'Ptyp::Presenter::Tab::Filter',
  Resource          => 'Ptyp::Resource';

use true;

use Mus;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean -except => [qw<new meta>];

ro 'master';

sub set_styles ($self) {
  $self->master->ttkSetTheme('alt');

  # $self->master->fontCreate("SmallFont",                   -family => 'Sans Regular', -size => 10);
  $self->master->fontCreate("SmallFont",                    -family => 'Arial',         -size => 10);
  # $self->master->fontCreate("SmallFont",                   -family => 'miscfixed',    -size => 9);
  $self->master->ttkStyleConfigure('.',                     -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('.',                     -background => '#3B4252');
  $self->master->ttkStyleConfigure('TFrame',                -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('TFrame',                -background => '#3B4252');
  $self->master->ttkStyleConfigure('TButton',               -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('TButton',               -background => '#3B4252');
  $self->master->ttkStyleConfigure('TCheckButton',          -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('TCheckButton',          -background => '#3B4252');
  $self->master->ttkStyleConfigure('TLabel',                -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('TLabel',                -background => '#3B4252');
  $self->master->ttkStyleConfigure('TMenu',                 -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('TMenu',                 -background => '#3B4252');
  $self->master->ttkStyleConfigure('TMenuButton',           -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('TMenuButton',           -background => '#3B4252');
  $self->master->ttkStyleConfigure('TMenuButton',           -padding  => 0);
  $self->master->ttkStyleConfigure('Horizontal.TScrollbar', -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('Horizontal.TScrollbar', -background => '#3B4252');
  $self->master->ttkStyleConfigure('Vertical.TScrollbar',   -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('Vertical.TScrollbar',   -background => '#3B4252');
  $self->master->ttkStyleConfigure('TSeparator',            -background => '#3B4252');

  $self->master->ttkStyleConfigure('TNotebook',             -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('TNotebook',             -background => '#3B4252');

  # [[http://page.sourceforge.net/html/themes.html][Styles and Themes — PAGE 4.15 documentation]]
  $self->master->ttkStyleConfigure('TNotebook.Tab',       -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('TNotebook.Tab',       -background => '#3B4252');
  # $self->master->ttkStyleConfigure('TNotebook.Tab.focus', -foreground => '#eceff4');
  # $self->master->ttkStyleConfigure('TNotebook.Tab.focus', -background => '#3B4252');
  $self->master->ttkStyleConfigure('TNotebook.Tab.selected', -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('TNotebook.Tab.selected', -background => '#3B4252');
  $self->master->ttkStyleMap('TNotebook.Tab', -background => ['active', '#eceff4']);
  # $self->master->ttkStyleMap('TNotebook.Tab', -background => ['selected', '#eceff4']);

  $self->master->ttkStyleConfigure('Treeview',         -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('Treeview',         -background => '#3B4252');
  $self->master->ttkStyleConfigure('Treeview',         -fieldbackground => '#3B4252');
  $self->master->ttkStyleConfigure('Treeview',         -font => 'SmallFont');

  $self->master->ttkStyleConfigure('Treeview.Heading', -foreground => '#3B4252');
  $self->master->ttkStyleConfigure('Treeview.Heading', -background => '#eceff4');
  $self->master->ttkStyleMap('Treeview.Heading', -foreground => ['active', '#eceff4']);
  $self->master->ttkStyleMap('Treeview.Heading', -foreground => ['!active', '#eceff4']);
  $self->master->ttkStyleMap('Treeview.Heading', -background => ['active', '#3b4252']);
  $self->master->ttkStyleMap('Treeview.Heading', -background => ['!active', '#3b4252']);

  $self->master->ttkStyleConfigure('Treeview.Row', -background => '#3B4252');
  $self->master->ttkStyleConfigure('Treeview.Row', -fieldbackground => '#3B4252');
  $self->master->ttkStyleMap('Treeview.Row', -background => ['active','#3B4252']);
  $self->master->ttkStyleMap('Treeview.Row', -background => ['!active','#3B4252']);

  $self->master->ttkStyleConfigure('Treeview.Item', -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('Treeview.Item', -background =>   '#3B4252');
  $self->master->ttkStyleConfigure('Treeview.Item', -fieldbackground =>   '#3B4252');
  $self->master->ttkStyleMap('Treeview.Item', -foreground => ['active', '#eceff4']);
  $self->master->ttkStyleMap('Treeview.Item', -foreground => ['!active', '#eceff4']);
  $self->master->ttkStyleMap('Treeview.Item', -background => ['active', '#3B4252']);
  $self->master->ttkStyleMap('Treeview.Item', -background => ['!active', '#3B4252']);

  $self->master->ttkStyleConfigure('Treeview.Cell', -foreground => '#eceff4');
  $self->master->ttkStyleConfigure('Treeview.Cell', -background =>   '#3B4252');
  $self->master->ttkStyleConfigure('Treeview.Cell', -fieldbackground =>   '#3B4252');
  $self->master->ttkStyleMap('Treeview.Cell', -foreground => ['active', '#eceff4']);
  $self->master->ttkStyleMap('Treeview.Cell', -foreground => ['!active', '#eceff4']);
  $self->master->ttkStyleMap('Treeview.Cell', -background => ['active',  '#3B4252']);
  $self->master->ttkStyleMap('Treeview.Cell', -background => ['!active',  '#3B4252']);
  # use DDP; p  $self->master->ttkStyleLayout('TButton');
}

sub create ($self) {

  my $top = $self->master;

  my $main_frame     = $top->ttkFrame;

  $top->configure(-width => 400, -height => 400);

  my $note           = $main_frame->ttkNotebook;

  $note->call('ttk::notebook::enableTraversal', $note);

  my $config = Ptyp::Configuration->new;
  my $model = Ptyp::Model::ChannelList->new(configuration => $config);

  my $views = [
    TabChannel->new(master => $top,
                   notebook => $note,
                   presenter => ChannelPresenter->new(model => $model)),
    TabNew->new(master => $top,
               notebook => $note,
               presenter => NewPresenter->new(model => $model)),
    TabFavorite->new(master => $top,
                    notebook => $note,
                    presenter => FavoritePresenter->new(model => $model),),
    TabPlay->new(master => $top,
                notebook => $note,
                presenter => PlayPresenter->new(model => $model),),
    TabIgnore->new(master => $top,
                  notebook => $note,
                  presenter => IgnorePresenter->new(model => $model),),
    TabEnd->new(master => $top,
               notebook => $note,
               presenter => EndPresenter->new(model => $model),),
    TabSearch->new(master => $top,
                  notebook => $note,
                  presenter => SearchPresenter->new(model => $model),),
    TabDownload->new(master => $top,
                    notebook => $note,
                    presenter => DownloadPresenter->new(model => $model),),
    TabFilter->new(master => $top,
                  notebook => $note,
                  presenter => FilterPresenter->new(model => $model),)
   ];

  foreach my $view ($views->@*) {
    $view->create;
  }

  $self->create_menu($views);

  $self->create_toolbar($views);

  $self->set_styles;

  $note->pack(-expand => 'true', -fill => 'both');
  $main_frame->pack(-fill => 'both', -expand => 1);
}

sub create_menu($self, $views) {
  my $menu = Menu->new(
    master => $self->master,
    views => $views
   );
  $menu->create;
}

sub create_toolbar($self, $views) {
  my $toolbar = Toolbar->new(master => $self->master,
                            views => $views,
                            resource => Resource->new);
  $toolbar->create;
}
