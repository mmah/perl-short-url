Feature: Create a short URL which can represent a longer URL.  This version is specific
         to the self-hosted version of the software.

  Background:
    Given a usable Logger module
      And a usable database connection
      And a usable ShortURL module.

  Scenario: Code and decode previously defined short codes
    When I encode the long URL "<long_url>" I get the short code "<code>" and get the original URL back when I decode it.
    Examples:
      | long_url               |          code            |
      | https://www.google.com |  http://vst.vet/OFPNF6   |


