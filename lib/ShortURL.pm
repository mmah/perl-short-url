package ShortURL;

use strict;
use warnings;
use WWW::Curl::Easy;

sub new {
   my ($class) = @_;

   my $self = {
      curl    => WWW::Curl::Easy->new,
      retcode => 0
   };
   bless $self, $class;

   return $self;
}
#=======================================================================


sub Get {
   my ($self, $LongURL) = @_;
   
   $self->{curl}->setopt(CURLOPT_HEADER,1);
   $self->{curl}->setopt(CURLOPT_HTTPHEADER,['Content-Type: application/json']);
   $self->{curl}->setopt(CURLOPT_POST, 1);
   $self->{curl}->setopt(CURLOPT_POSTFIELDS,'{"longUrl": "' . $LongURL . '"}');
   $self->{curl}->setopt(CURLOPT_URL, 'https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyDzXn5c4Pp5El0oRVy32hwD_KMwO3RU5gs');

   my $response_body;
   $self->{curl}->setopt(CURLOPT_WRITEDATA,\$response_body);

   # Starts the actual request
   my $retcode = $self->{curl}->perform;
   $self->{retcode} = $retcode;

   # Looking at the results...
   if ($retcode == 0) {
      #print("Transfer went ok\n");
      my $response_code = $self->{curl}->getinfo(CURLINFO_HTTP_CODE);
      # judge result and next action based on $response_code
      #print("Received response: $response_body\n");
      # We expect to find the short URL in the json result in the form "id": "http://goo.gl/fbsS"
      $response_body =~ m/"id":\s*"([^"]*)"/;
      return $1;
   } else {
      # Error code, type of error, error message
      print("An error happened: $retcode " . $self->{curl}->strerror($retcode) . " " . $self->{curl}->errbuf."\n");
      return undef;
   }
}
#=======================================================================


sub ReturnCode {
   my ($self) = @_;
   
   return $self->{curl}->strerror($self->{retcode});
}
#=======================================================================


sub ErrorText {
   my ($self) = @_;
   
   return $self->{curl}->errbuf;
}
#=======================================================================


1;

