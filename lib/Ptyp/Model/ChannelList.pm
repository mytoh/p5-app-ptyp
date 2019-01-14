
package Ptyp::Model::ChannelList;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use Package::Alias
  YP           => 'PeerCast::YP';
use true;
use Types::Standard -types;
use PeerCast::Types::YP -types;
use Mojo::Promise;
use Unicode::UCD qw<charscript>;
use List::AllUtils qw<first reduce extract_by>;

use Mus;
use MooX::LvalueAttribute;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean -except => [qw<new meta>];

ro 'configuration';

rw yp_list => (required => 0,
              isa => ArrayRef[YP],
              builder => '_build_yp_list',
              lvalue => 1);

rw header_columns => (required => 0,
                     default => sub ($self)
                     {
                       $self->configuration->config->{'header_columns'};
                     }
                     ,
                     lvalue => 1 );

rw current_channels => (required => 0,
                       default => sub { [] },
                       lvalue => 1);

rw new_channels => (required => 0,
                   default => sub { [] },
                   predicate => 1,
                   lvalue => 1);

sub _build_yp_list ($self) {
  [
    map {
      my $name = $_->[0];
      my $url = $_->[1];
      YP->new(name => $name,
             url => $url);

    }
    $self->configuration->config->{'yp_list'}->@*
   ];
}

sub filter_by_language ($self, $list, $lang) {
  [
    grep {
      my $channel = $_;
      state $regex = qr/\P{$lang}/;
      my $flag = $channel->name =~ $regex &&
        $channel->description =~ $regex;
      # say 'Filtered channel: ' . $channel->name if ! $flag;
      $flag;
    }
    $list->@*
   ];
}

sub filter_by_languages ($self, $list, $langs) {
  reduce
    {
      my $channels = $a;
      my $lang = $b;
      $self->filter_by_language($channels, $lang);
    }
    $list, $langs->@*
  }

sub get_all_channels  ($self) {
  $self->current_channels;
}

sub refresh_channels_p ($self) {
  my @channels = $self->get_all_channels->@*;
  my $old_channels =  @channels ? $self->get_all_channels : undef;

  my @promises = map { $_->get_channel_p } $self->yp_list->@*;
  my $results;
  Mojo::Promise->all(@promises)
      ->then(sub (@all) {
              $results = [map { map {my $y = $_; $y->@*} $_->@*} @all];
            }
           )
      ->wait;
  $self->current_channels = $self->filter_by_languages($results, $self->configuration->config->{'ignore_languages'});
  $self->new_channels = $self->make_new_channels($old_channels, $self->current_channels);
}

sub refresh_channels ($self) {
  my @channels = $self->get_all_channels->@*;
  my $old_channels =  @channels ? $self->get_all_channels : undef;
  foreach my $yp ($self->yp_list->@*) {
    $yp->get_channel;
  }

  $self->current_channels = $self->get_all_channels;
  $self->new_channels = $self->make_new_channels($old_channels, $self->current_channels);
}

sub make_new_channels ($self, $old, $current) {
  if (defined $old) {
    my @new = grep { ! $self->find_channel($_, $old) } $current->@*;
    if (@new) {
      [@new]
    } else {
      undef;
    }
  } else {
    $current;
  }
}

sub find_channel ($self, $channel, $list) {
  my $name = $channel->name;
  my $result = first { $name eq $_->name } $list->@*;
  if ($result) {
    $channel;
  } else {
    undef;
  }
}
