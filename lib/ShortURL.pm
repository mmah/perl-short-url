package ShortURL;

use strict;
use warnings;
use WWW::Curl::Easy;
use URI::Escape;

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

## javascript:void(location.href='http://tinyurl.com/create.php?url='+encodeURIComponent(location.href))
sub Get {
   my ($self, $LongURL) = @_;
   
   $LongURL = uri_escape($LongURL);
   
   #$self->{curl}->setopt(CURLOPT_HEADER,1);
   #$self->{curl}->setopt(CURLOPT_HTTPHEADER,['Content-Type: application/text']);
   #$self->{curl}->setopt(CURLOPT_POST, 1);
   #$self->{curl}->setopt(CURLOPT_POSTFIELDS,'url=' . $LongURL);
#   $self->{curl}->setopt(CURLOPT_URL, 'http://tinyurl.com/create.php');
   $self->{curl}->setopt(CURLOPT_URL, 'http://tinyurl.com/create.php?url=' . $LongURL);

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
      $response_body =~ m/\<a\ href="(http:\/\/tinyurl\.com\/[^"]*)"/;
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
=cut
Received response: <!DOCTYPE html>
<html>
<head>
	<title>TinyURL.com - shorten that long URL into a tiny URL</title>
	<base href="http://tinyurl.com/">

	<meta name="google-site-verification" content="FKj2fbrOEwHQ0EKE74gNhtLt1VS1PRKbCxdthSDk5tk" />

	<link rel="shortcut icon" href="/siteresources/images/favicon.ico" type="image/gif">
	<link href="/siteresources/css/tinyurl_style.7.css" rel="stylesheet" type="text/css" />

    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script type="text/javascript">
    function tt(){var t = new Image();t.src='http://rc.rlcdn.com/333201.gif?n=1';}
    document.write('<script async type="text/javascript" src="/siteresources/js/common.js"></sc'+'ript>');
    </script>
    <!--<script type='text/javascript'>
    var googletag = googletag || {};
    googletag.cmd = googletag.cmd || [];
    (function() {
    var gads = document.createElement('script');
    gads.async = true;
    gads.type = 'text/javascript';
    var useSSL = 'https:' == document.location.protocol;
    gads.src = (useSSL ? 'https:' : 'http:') +
    '//www.googletagservices.com/tag/js/gpt.js';
    var node = document.getElementsByTagName('script')[0];
    node.parentNode.insertBefore(gads, node);
    })();
    </script>
    <script type='text/javascript'>
    googletag.cmd.push(function() {
    googletag.defineSlot('/34718310/TEST_300x600_Homepage', [300, 600], 'div-gpt-ad-1361894497480-0').addService(googletag.pubads());
    googletag.pubads().enableSingleRequest();
    googletag.enableServices();
    });
    </script>-->
</head>
<body onload="tt();">
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-6779119-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script><div class="wrapper">
<div class="header">
    <h1><a class="baselink" href="http://tinyurl.com/">TinyURL.com</a></h1>
    Making over a billion long URLs usable! Serving billions of redirects per month.</div>
<div class="body">
    <div class="leftpane">
        <div class="sidebar">
            <div><a class="baselink" href="http://tinyurl.com/">Home</a></div>
        	<div><a href="/#example">Example</a></div>
        	<div><a href="/#toolbar">Make Toolbar Button</a></div>
        	<div><a href="/#redirect">Redirection</a></div>
        	<div><a href="/#hide">Hide URLs</a></div>
        	        	<div><a href="/preview.php">Preview Feature</a><sup><small style="font-weight: bold">cool!</small></sup></div>
        	        	<div><a href="/#link">Link to Us!</a></div>
        	<div><a href="/#terms">Terms of use</a></div>
        	<div><a href="/cdn-cgi/l/email-protection#45363035352a3731636673717e312c2b3c3037296b262a28">Contact Us!</a></div>
        </div>
        <div id="donate">
                        <form action="https://www.paypal.com/cgi-bin/webscr" method="post">
            <input type="hidden" name="cmd" value="_s-xclick">
            <input type="hidden" name="hosted_button_id" value="TJDXGVAJXC9M6">
            <input type="image" src="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
            <img alt="" border="0" src="https://www.paypal.com/en_US/i/scr/pixel.gif" width="1" height="1">
            </form>
        </div>
    </div>
    <div class="mainpane">
                <div class="topbanner">
            <div class="topad">
        	        		<script type="text/javascript"><!--
        			e9 = new Object();
        		    e9.size = "728x90,468x60";
        		//--></script>
        		<script type="text/javascript" src="http://tags.expo9.exponential.com/tags/TinyURLcom/Backfill/tags.js"></script>
        	        	</div>
    	</div>
                <div class="maincontent">
            <div class="rightad">
        		        		<script type="text/javascript"><!--
        			e9 = new Object();
        		    e9.size = "300x250,120x600,160x600,300x600";
        		//--</script>
        		<script type="text/javascript" src="http://tags.expo9.exponential.com/tags/TinyURLcom/Backfill/tags.js"></script>
        		    		</div>
            <div id="contentcontainer">
	    <h1>TinyURL was created!</h1>
                <p>The following URL:
        <div class="indent longurl"><b>http://www.google.com</b></div>
        has a length of 21 characters and resulted in the following TinyURL which has a length of 22 characters:
        <div class="indent"><b>http://tinyurl.com/1c2</b><div id="success"></div><br><small>[<a href="http://tinyurl.com/1c2" target="_blank">Open in new window</a>]</small><div id="copy_div"></div></div>
        Or, give your recipients confidence with a preview TinyURL:
        <div class="indent"><b>http://preview.tinyurl.com/1c2</b><br><small>[<a href="http://preview.tinyurl.com/1c2" target="_blank">Open in new window</a>]</small>
        </div></p>
    
                <div id="copyinfo" data-clipboard-text="http://tinyurl.com/1c2"></div>
        <script type="text/javascript" src="/siteresources/js/ZeroClipboard.js"></script>
        <script type="text/javascript" src="/siteresources/js/tinyurl_copy.js"></script>
        <script type="text/javascript">setupCopy();</script>
        
		<form action="create.php" method="post" class="create-form">
            <b>Enter a long URL to make tiny:</b><br />
            <input type="text" id="url" name="url">
            <input id="submit" type="submit" name="submit" value="Make TinyURL!">
            <hr>Custom alias (optional):<br />
            <tt class="basecontent">http://tinyurl.com/</tt>
            <input type="text" id="alias" name="alias" maxlength="30"><br />
            <small>May contain letters, numbers, and dashes.</small>
        </form>
            </div>
            <div style="clear:both"></div>
        </div>
    </div>
</div>
<div class="push"></div>
</div>
<div class="footer">
    <div class="privacy"><a id="privacy" href="/privacy.php">Privacy</a></div>
    <div id="copyright"><i>Copyright &copy; 2002-2016 TinyURL, LLC. All rights reserved.</i><br />
TinyURL is a trademark of TinyURL, LLC.</div>
        <script type="text/javascript">
    var _qevents = _qevents || [];

    (function() {
    var elem = document.createElement('script');
    elem.src = (document.location.protocol == "https:" ? "https://secure" : "http://edge") + ".quantserve.com/quant.js";
    elem.async = true;
    elem.type = "text/javascript";
    var scpt = document.getElementsByTagName('script')[0];
    scpt.parentNode.insertBefore(elem, scpt);
    })();

    _qevents.push({
    qacct:"p-85Tqni4j2acvI"
    });
    </script>

    <noscript>
    <div style="display:none;">
    <img src="//pixel.quantserve.com/pixel/p-85Tqni4j2acvI.gif" border="0" height="1" width="1" alt="Quantcast"/>
    </div>
    </noscript>
    </div>
<script type="text/javascript">/* <![CDATA[ */(function(d,s,a,i,j,r,l,m,t){try{l=d.getElementsByTagName('a');t=d.createElement('textarea');for(i=0;l.length-i;i++){try{a=l[i].href;s=a.indexOf('/cdn-cgi/l/email-protection');m=a.length;if(a&&s>-1&&m>28){j=28+s;s='';if(j<m){r='0x'+a.substr(j,2)|0;for(j+=2;j<m&&a.charAt(j)!='X';j+=2)s+='%'+('0'+('0x'+a.substr(j,2)^r).toString(16)).slice(-2);j++;s=decodeURIComponent(s)+a.substr(j,m-j)}t.innerHTML=s.replace(/</g,'&lt;').replace(/>/g,'&gt;');l[i].href='mailto:'+t.value}}catch(e){}}}catch(e){}})(document);/* ]]> */</script></body>
</html>

Unable to get short URL


------------------
(program exited with code: 0)
Press return to continue
=cut


1;

