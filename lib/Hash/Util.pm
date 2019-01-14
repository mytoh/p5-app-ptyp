
package Hash::Util;

use v5.28;
use utf8;
use strictures 2;
use autodie ':all';
use utf8::all;
use open qw<:std :encoding(UTF-8)>;
use Type::Params;
use true;
use Unicode::UTF8 qw<encode_utf8 decode_utf8>;
use Type::Utils qw<match_on_type>;
use List::AllUtils qw<reduce>;
use Types::Standard -types;
use Function::Return;

use Mus;
use MooX::LvalueAttribute;
use experimental qw<signatures re_strict refaliasing declared_refs script_run alpha_assertions regex_sets const_attr>;
use re 'strict';
use namespace::clean -except => [qw<new meta>];


sub encode_hash_utf8 ($self, $hash) {
  match_on_type $hash => (
    HashRef() => sub ($data) {
      $self->_encode_hash($data);
    }
    ,
    ArrayRef() => sub ($data) {
      $self->_encode_array($data);
    }
    ,
    Str() => sub ($data) {
      $self->_encode_str($data);
    }
    ,
    Any() => sub ($data) {
      $data
    }
   );
}

sub decode_hash_utf8 ($self, $hash) {
  match_on_type $hash => (
    HashRef() => sub {
      $self->_decode_hash($_);
    },
    ArrayRef() => sub {
      $self->_decode_array($_);
    },
    Str() => sub {
      $self->_decode_str($_);
    },
    Any() => sub {
      $_
    }
   );
}

sub _decode_str :Return(Str) ($self,$str) {
  decode_utf8($str);
}

sub _decode_array :Return(ArrayRef) ($self, $array) {
  [
    map {
      $self->decode_hash_utf8($_);
    } $array->@*
   ]
}

sub _decode_hash :Return(HashRef) ($self, $hash) {
  my $keys = [sort keys $hash->%*];

  reduce {
    match_on_type $b => (
      Str() => sub {
        $a->{decode_utf8($b)} = $self->decode_hash_utf8($hash->{$b});
        $a;
      },
      Any() => sub {
        $a->{$b} = $self->decode_hash_utf8($hash->{$b});
        $a;
      },
     )
  }  +{}, $keys->@*
}


sub _encode_str :Return(Str) ($self,$str) {
  encode_utf8($str);
}

sub _encode_array :Return(ArrayRef) ($self, $array) {
  [
    map {
      $self->encode_hash_utf8($_);
    } $array->@*
   ]
}

sub _encode_hash :Return(HashRef) ($self, $hash) {
  my $keys = [sort keys $hash->%*];

  reduce {
    match_on_type $b => (
      Str() => sub {
        $a->{encode_utf8($b)} = $self->encode_hash_utf8($hash->{$b});
        $a;
      },
      Any() => sub {
        $a->{$b} = $self->encode_hash_utf8($hash->{$b});
        $a;
      },
     )
  }  +{}, $keys->@*
}
