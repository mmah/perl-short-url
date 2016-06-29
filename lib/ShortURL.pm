package ShortURL;

########################################################################
#
# ShortURL Module skeleton
#
########################################################################

use strict;
use warnings;



sub new {
   my ($class, $Parameters) = @_;
   
   
   my $self = {
   };
   bless $self, $class;

   return $self;
}
#=======================================================================


sub Get {
   my ($self, $LongURL) = @_;
   
   $LongURL = uri_escape($LongURL);
   
   my $short_url = undef;
   
   # Return the short code to the caller...
   return $short_url;
}
#=======================================================================


1;
