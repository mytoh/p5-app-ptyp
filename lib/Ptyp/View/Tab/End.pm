
package Ptyp::View::Tab::End;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use true;

use Mus;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean -except => [qw<new meta>];

ro 'master';
ro 'notebook';
ro 'presenter';

with 'Ptyp::Does::View::Refresh',
  'Ptyp::Does::View::Create';

sub create ($self) {
  my $note = $self->notebook;
  my $note_end_frame = $note->ttkFrame;
  $note->add($note_end_frame, -text => 'End');
}

sub refresh ($self) {
}
