
package PeerCast::Player::Mpv;

use Mus;
use v5.28;
use experimental qw<signatures>;
use Proc::Daemon;
use namespace::clean -except => [qw<new meta>];
use true;

sub play_channel ($self, $config, $data) {

  state $twitch = qr{www\.twitch\.tv};
  if ($data->{'contact_url'} =~ $twitch) {
    my $url = $data->{'contact_url'};
    my $daemon = Proc::Daemon->new(
      exec_command => "mpv --force-window=immediate --speed=1 $url",
      # exec_command => "mpv --ytdl-raw-options=format=480p --force-window=immediate $url",
     );
    my $pid = $daemon->Init();
    say "Player started with PID $pid";
  } else {
    my $daemon = Proc::Daemon->new(
      exec_command => sprintf("mpv --force-window=immediate --speed=1 --no-ytdl http://%s:%s/stream/%s.%s?tip=%s",
                             $config->{'host'},
                             $config->{'port'},
                             $data->channel_id,
                             lc $data->content_type,
                             $data->tracker)
     );
    my $pid = $daemon->Init();

  }
}
