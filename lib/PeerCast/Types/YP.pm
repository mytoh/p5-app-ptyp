package PeerCast::Types::YP;

use Type::Library
  -base,
  -declare => qw<YP
                YPName
                YPUrl>;
use Type::Utils -all;
use Types::Standard -types;
use Types::Common::Numeric -types;
use v5.28;
use strict;
use warnings;
use true;

class_type YP, { class => 'PeerCast::YP' };

declare YPName, as Str;
declare YPUrl, as Str;
