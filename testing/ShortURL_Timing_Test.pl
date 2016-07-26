#!/usr/bin/perl -w

use strict;
use lib "../lib";
use ShortURL;
use Time::HiRes;

my $shortener = ShortURL->new();

my $start_time = Time::HiRes::gettimeofday();

my $ask_for = 100;
for (my $i = 0; $i < $ask_for; ++$i) {
   my $long_url = "http://www.google$i.com/";
   my $short_url = $shortener->Get($long_url);

   unless (defined $short_url) {
      print "Unable to get short URL\n";
      last;
   } else {
      print "The shortened version of '$long_url' is '$short_url'\n";
   }
}

print
   sprintf("The time for acquiring $ask_for short URLs is %.3f",
      Time::HiRes::gettimeofday() - $start_time);


exit()

# The time for acquiring 10 short URLs is 7.674
# The time for acquiring 100 short URLs is 67.185
