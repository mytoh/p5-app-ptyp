
package Config::Hash;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use Type::Params;
use Types::Standard -types;
use true;
use Path::Tiny;
use Config::PL;
use Data::Dumper::AutoEncode;
use Unicode::UTF8 qw<encode_utf8 decode_utf8>;
use Hash::Util;

use Mus;
use MooX::LvalueAttribute;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean -except => [qw<new meta>];

sub read_config ($self, $file_name) {
  my $data = config_do($file_name);
  my $hu = Hash::Util->new;
  $hu->decode_hash_utf8($data);
}

sub write_config ($self, $file_name, $data) {
  path($file_name)->spew_utf8($self->_serialize($data));
}

sub _serialize ($self, $data) {
  my $hu = Hash::Util->new;
  local $Data::Dumper::Terse = 1;
  my $serialized = "+" . decode_utf8(eDumper($data));
  $serialized;
}
