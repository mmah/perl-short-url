#!/usr/local/bin/perl
use strict;
use warnings;
use Test::More;
use Method::Signatures;
use lib '../../Library';
use lib "../lib";
use Logger;
use DB_Connect;
use ShortURL;

my $short_url = undef;
my $db_connection = undef;
my $logger = undef;


Given qr/a usable Logger module/, sub {
   $logger = Logger->GetLogger( {name => "ShortURL_Test.log", traps => 0 } );
   use_ok( 'Logger' );
};

Given qr/a usable database connection/, sub {
   $db_connection = DB_Connect->GetConnection (
                                       {
                                         DB_Host     => 'ya-vsdbtest-02-nat', 
                                         DB_Name     => 'vidb05',         
                                         DB_User     => 'perl_app',       
                                         DB_Password => 'Titus3:2'
                                       }
                                    );
   ok "database connected";
};

Given qr/a usable ShortURL module/, sub {
   $short_url = ShortURL->new({ creator=>'HCRE', DBH=>$db_connection->DBH() });
   use_ok( 'ShortURL' );
};

When qr/encode the long URL "([^"]*)" I get the short code "([^"]*)"/, func($c) {
   my $long_url = $1;
   my $expected_short_code = $2;
   #print "long_url = '$long_url'\n";
   #print "expected_short_code = '$expected_short_code'\n";
   my $short_code = $short_url->Get($long_url);
   $c->stash->{scenario}->{long_url} = $long_url;
   #print "short_code = $short_code\n";
   unless ($short_code eq "$expected_short_code") {
      fail "The received short code does not match the expected short code ($short_code)";
   }
   my $inquiry = substr($short_code, 0, 15);
   my $command = "curl http://vst.vet/*" . $short_code . " 2>&1";
   #print "command = $command\n";
   my $result = `$command`;
   #print $result;
   if (grep(qr/Target of '([^']*)' is '([^']*)'/, split(/\n/, $result))) {
      #print "1 = $1\n";
      #print "2 = $2\n";
      unless ($1 eq $long_url) {
         fail "The returned URL does not match expected ($1)";
      }
      ok $short_code, "got correct short code";
   } else {
      fail "Unrecognized response from web service";
   }

};
