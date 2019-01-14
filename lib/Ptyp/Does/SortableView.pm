
package Ptyp::Does::SortableView;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use Type::Params;
use Types::Standard -types;
use Unicode::Collate;
use true;

use Mu::Role;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';

sub sort_by ($self, $tree, $col, $direction) {
  state $uc = Unicode::Collate->new;

  # Build something we can sort
  my @data;
  my @rows = $tree->children('');
  push @data, [$tree->set($_, $col), $_] for @rows;
  my @indexes = (0..$#rows);

  my @sorted_indices;
  if ( $direction ) {           # forward sort #
    my @sorted = sort {
      if ($col eq 'Viewer') {
        $a->[0] <=> $b->[0]
      } else {
        #$a->[0] cmp $b->[0]
        $uc->cmp($a->[0],$b->[0]);
      }
    } @data;
    @sorted_indices = map $_->[1], @sorted;
  } else {
    my @sorted = sort {
      if ($col eq 'Viewer') {
        $b->[0] <=> $a->[0]
      } else {
        #  $b->[0] cmp $a->[0]
        $uc->cmp($b->[0], $a->[0]);
      }
    } @data;
    @sorted_indices = map $_->[1], @sorted;
  }

  # Now reshuffle the rows into the sorted order
  my $r = 0;
  foreach my $index (@sorted_indices) {
    $tree->move($index, '', $r);
    $r++;
  }

  # Switch the heading so that it will sort in the opposite direction
  $tree->heading($col, -command => [sub ($tree, $col, $dir){$self->sort_by($tree, $col, $dir)},
                                  $tree, $col, !$direction]);
}
