package ShortURL;

use strict;
use DBI;
use lib '../..';
use Logger;
use Time::HiRes;

use constant TRUE => 1;
use constant FALSE => 0;



my $DB_Connection;
my $Logger;
my $ShortURL;


sub new {
   my ($class, $params) = @_;
   
   if (defined($ShortURL)) {
      return $ShortURL;
   }
   
   $Logger = Logger->GetLogger();

   $DB_Connection = GetConnection($params);
}


sub Get {
   my ($self, $LongURL) = @_;
   
   if (strtolower(substr($LongURL, 0, 4)) != "http") {
      $LongURL = "http://" . $LongURL;
   }

   my $short_code;
   my $sql = "select short_code from short_urls where long_url = '$LongURL';";
   my $result = DB_Connection->Execute($sql);
   if (my $row = $result->fetchrow_hashref()) {
      # we've already see this url, return the existing value...
      $short_code = $row->["short_code"];
   } else {
      # There was no existing short code, we must create one...
      # Loop and create another code if the new code is not unique...
      while (1) {
         $short_code = base_convert(time(), 10, 36);
         # does the code already exist...
         $result = $DB_Connection->Execute("select long_url from short_urls where short_code = '$short_code';");
         last unless ($result->fetchrow_hashref());
      }
      # Now we have a unique code...insert it...
      $DB_Connection->DoIO("insert into short_urls (long_url, short_code) values ('$LongURL', '$short_code');");
   }
   
   return $short_code;
}
#=======================================================================

1;

