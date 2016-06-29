package ShortURL;

use strict;
use warnings;
use URI::Escape;
use Math::BaseCalc;
use DBI;
use Time::HiRes;

my $hash_code  = 9036507220;
my $ShortURL_Table = 'sandbox.short_urls';


sub new {
   my ($class, $Parameters) = @_;
   
   my $DB_Name     = 'vidb05'; 
   my $DB_User     = 'perl_app';
   my $DB_Password = 'Titus3:2';
   
   my $self = {
      basecalc => new Math::BaseCalc(digits=>[0..9, 'a'..'z', 'A'..'Z']),
      retcode  => 0
   };
   bless $self, $class;

   if (exists($Parameters->{db_conn})) {
      $self->{db_conn} = $Parameters->{db_conn};
   } elsif (exists($Parameters->{db_host})) {
      local $@; # Don't step on other code.
      my $result = undef;
      eval {
         local $SIG{__DIE__}; # No sigdie handler
         $self->{db_conn} =  DBI->connect("dbi:Pg:dbname=$DB_Name;" .
                                          "host=$Parameters->{db_host}",
                                          $DB_User,
                                          $DB_Password)
                     or die "Could not connect: $DBI::errstr";
      };
   } else {
      die "Database information not supplied";
   }
   
   if (exists($Parameters->{time_to_live})) {
      $self->{expires} = "$Parameters->{time_to_live} days";
   } else {
      $self->{expires} = '90 days';
   }
   
   return $self;
}
#=======================================================================


sub Get {
   my ($self, $LongURL) = @_;
   
   $LongURL = uri_escape($LongURL);
   
   my $short_url = undef;
   
   while (1) {
      # Make a short url code...
      $short_url = $self->basecalc->to_base(int(Time::HiRes::time()*1000) ^ $hash_code);
      
      # Make sure we haven't used this short code before...
      my $sql = <<"END_SQL";
      select count(*) as count from $ShortURL_Table where short_url = $short_url;
END_SQL

      my $sth = $self->{db_conn}->prepare($sql) ||
          die "Unable to prepare $sql, $self->{db_conn}->errstr";
          
      if (my $datarow = $sth->fetchrow_hashref()) {
         # We got a row...check the count...
         if ($datarow > 0) {
            next;
         }
      }
      
      # If we didn't find the code in the table, we can use this code, so exit...
      last;
   }
   
   # Install the new code in the table...
   my $sql = <<"END_SQL";
insert into $ShortURL_Table
   (short_url, long_url, expire_date)
   values
   ($short_url, $LongURL, now()::date+'$self->{expires}'::interval);
END_SQL

   my $result = $self->{db_conn}->do($sql) or die "Unable to do $sql, $self->{db_conn}->errstr";
   
   # Return the short code to the caller...
   return $short_url;
}
#=======================================================================


1;

