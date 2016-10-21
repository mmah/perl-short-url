#!/usr/bin/perl -w

use strict;
use lib "../..";
use lib "../lib";
use Logger;
use DB_Connect;
use ShortURL;

my $Logger = Logger->GetLogger('test.log');
print "Logger created\n";

my $DB_Connection = DB_Connect->GetConnection({
                                                  DB_Host     => 'ya-vsdbtest-02-nat', 
                                                  DB_Name     => 'vidb05',         
                                                  DB_User     => 'perl_app',       
                                                  DB_Password => 'Titus3:2'
                                              });
print "DB Connection opened\n";

my $shortener = ShortURL->new({creator=>'test', DBH=>$DB_Connection->DBH()});
print "Shortener created\n";

my $long_url = "http://www.google101.com/";
$long_url = 'https://appointments.vetstoria.com/HHHHHHH/UmFuZG9tSVaIUZlMs4hT5WyShFongYxCcWsyhcCkhebQkh3ZPbO0PfDv01WW6uQ_UnHGXu09Xk3g2ADmKu8oGhiA0xXGdZLA';
my $short_url = $shortener->Get($long_url);

unless (defined $short_url) {
   print "Unable to get short URL\n";
} else {
   print "The shortened version of '$long_url' is '$short_url'\n";
}

exit()
#=======================================================================


