#!/usr/bin/perl -w

use strict;
use lib "../lib";
use ShortURL;

my $shortener = ShortURL->new();

my $long_url = "http://www.google101.com/";
$long_url = 'https://appointments.vetstoria.com/HHHHHHH/UmFuZG9tSVaIUZlMs4hT5WyShFongYxCcWsyhcCkhebQkh3ZPbO0PfDv01WW6uQ_UnHGXu09Xk3g2ADmKu8oGhiA0xXGdZLA';
my $short_url = $shortener->Get($long_url);

unless (defined $short_url) {
   print "Unable to get short URL\n";
} else {
   print "The shortened version of '$long_url' is '$short_url'\n";
}

exit()

