package PeerCast::Channel;

use strictures 2;
use PeerCast::Types::Channel -types;
use Types::Standard -types;
use true;


use Mus;
use MooX::StrictConstructor;
use namespace::clean -except => [qw<new meta>];

ro name         => (isa => ChannelName);
ro channel_id   => (isa => ChannelId);
ro tracker      => (isa => ChannelTracker);
ro contact_url  => (isa => ChannelContactUrl);
ro genre        => (isa => ChannelGenre);
ro description  => (isa => ChannelDescription);
ro listeners    => (isa => ChannelListeners);
ro relays       => (isa => ChannelRelays);
ro bitrate      => (isa => ChannelBitrate);
ro content_type => (isa => ChannelContentType);
ro artist       => (isa => ChannelArtist);
ro album        => (isa => ChannelAlbum);
ro track_title  => (isa => ChannelTrackTitle);
ro track_url    => (isa => ChannelTrackUrl);
ro uptime       => (isa => ChannelUptime);
ro comment      => (isa => ChannelComment);
ro yp_name      => (isa => ChannelYPName);
