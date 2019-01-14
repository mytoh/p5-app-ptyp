package PeerCast::Types::Channel;

use Type::Library
  -base,
  -declare => qw<
                 Channel
                 ChannelName
                 ChannelId
                 ChannelTracker
                 ChannelContactUrl
                 ChannelGenre
                 ChannelDescription
                 ChannelListeners
                 ChannelRelays
                 ChannelBitrate
                 ChannelContentType
                 ChannelArtist
                 ChannelAlbum
                 ChannelTrackTitle
                 ChannelTrackUrl
                 ChannelUptime
                 ChannelComment
                 ChannelYPName
               >;

use Type::Utils -all;
use Types::Standard -types, 'slurpy';
use Types::URI -all;
use Types::Common::Numeric -types;
use v5.28;
use strict;
use warnings;
use true;

class_type Channel, {class => 'PeerCast::Channel'};

declare ChannelName, as Str;
declare ChannelId, as Str;
declare ChannelTracker, as Str;
declare ChannelContactUrl, as Str;
declare ChannelGenre, as Str;
declare ChannelDescription, as Str;
declare ChannelListeners, as Str;
declare ChannelRelays, as Str;
declare ChannelBitrate, as Str;
declare ChannelContentType, as Str;
declare ChannelArtist, as Str;
declare ChannelAlbum, as Str;
declare ChannelTrackTitle, as Str;
declare ChannelTrackUrl, as Str;
declare ChannelUptime, as Str;
declare ChannelComment, as Str;
declare ChannelYPName, as Str;
