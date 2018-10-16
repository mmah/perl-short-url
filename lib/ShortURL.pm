package ShortURL;

use strict;
use DBI;
use lib '../..';
use Logger;
use DB_Connect;
use Time::HiRes;

use constant TRUE => 1;
use constant FALSE => 0;

my $TableName = ' short_url_lookup';

my $DB_Connection;
my $Logger;
my $ShortURL;


sub new {
   my ($class, $params) = @_;

   # Return the logger object if already created...
   if (defined($ShortURL)) {
      return $ShortURL;
   }

   # Get the logger object which should have been created by the host
   #    applicaion.
   $Logger = Logger->GetLogger();

   # Get a database object.  We would normally expect the host program to
   #    have created a database object but if not, we will pass along the
   #    the parameters given us in case the host application wants us to
   #    make the DB connection.
   $DB_Connection = DB_Connect->GetConnection($params);

   my $self = {

              };

   bless $self, $class;

   # Capture the creator identity if specified...
   if (exists($params->{creator})) {
      $self->{creator} = $params->{creator};
   } else {
      $self->{creator} = 'HCRE';
      # die "Fatal: The short URL requestor was not supplied";
   }

   # Capture the creator identity if specified...
   if (exists($params->{ttl})) {
      $self->{ttl} = $params->{ttl};
   } else {
      $self->{ttl} = '1 year';
   }

   return $self;
}
#=======================================================================


sub Get {
   my ($self, $LongURL) = @_;

   if (lc(substr($LongURL, 0, 4)) != "http") {
      $LongURL = "http://" . $LongURL;
   }
   my $short_code;
   my $sql = "select short_url from $TableName where long_url = '$LongURL';";
   my $result = $DB_Connection->Execute($sql);
   if (my $row = $result->fetchrow_hashref()) {
      # we've already see this url, return the existing value...
      $short_code = $row->{"short_url"};
   } else {
      # There was no existing short code, we must create one...
      # Loop and create another code if the new code is not unique...
      while (TRUE) {
         $short_code = encode_base36(time());
         #print "converted to $short_url\n"; exit(0);
         # does the code already exist...
         $result = $DB_Connection->Execute("select long_url from $TableName where short_url = '$short_code';");
         last unless ($result->fetchrow_hashref());
      }
      # Now we have a unique code...insert it...
      $DB_Connection->DoIO("insert into $TableName (long_url, short_url, app_name, expire_date) values ('$LongURL', '$short_code', '$self->{creator}', now()+'$self->{ttl}'::interval);");
   }

   return "http://vst.vet/" . $short_code;
}
#=======================================================================


sub encode_base36 {
    my ($number) = @_;

    die 'Invalid base10 number'  if $number    =~ m{\D};

    #print "number in = '$number'\n";
    my $result = '';
    while ( $number ) {
        my $remainder = $number % 36;
        $result .= $remainder <= 9 ? $remainder : chr( 55 + $remainder );
        $number = int $number / 36;
    }

    return reverse( $result );
}
#=======================================================================


1;

