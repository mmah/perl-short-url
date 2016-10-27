<?php
   $echo_only = false;
   $short_code = "";
   if (@$_GET['file']) {
      $short_code = @$_GET['file']; 
   }
  
   //$short_code = "test";

   if(strlen($short_code) == 0){
      echo <<<END_HTML
<html>
   <head>
   </head>
   <body>
      Error: Missing short code to be translated.  Please check that you have entered the address correctly.
   </body>
</html>
END_HTML;
      exit();
   }

   // Is this a test command?
   if (substr($short_code, 0, 1) == "*") {
      $echo_only = true;
      $short_code = substr($short_code, 1, strlen($short_code)-1);
   }

   $table_name = "short_url_lookup";

   $dbhost = "ya-vsdbtest-02";
   //$dbhost = "ya-dbprod-01";
   $dbuser = "perl_app";
   $dbpass = "Titus3:2";
   $dbname = "vidb05";

   //echo "Connecting to DB\n";

   $db_conn = pg_Connect("host=$dbhost dbname=$dbname user=$dbuser password=$dbpass");
   if(!$db_conn){
      echo <<<END_HTML
<html>
   <head>
   </head>
   <body>
      Error: Unable to connect to the database.  Please make your request later.
   </body>
</html>
END_HTML;
      exit();
   }

   //echo "Connected to DB\n";

   $sql = "select long_url from $table_name where short_url = '$short_code';";
   $result = pg_exec($db_conn, $sql);

   $num_rows = pg_numrows($result);
   if ($num_rows == 0) {
      echo <<<END_HTML
<html>
   <head>
   </head>
   <body>
      Error: Unable to recognize the link you entered ('$short_code').
      Please check the spelling to make sure it is entered correctly.
      If it is entered correctly, the link may be too old to be recognized.
   </body>
</html>
END_HTML;
      exit();
   } else {
      $row = pg_fetch_array($result, 0);
      $long_url = $row["long_url"];
   }

   if ($echo_only) {
      echo <<<END_HTML
<html>
   <head>
   </head>
   <body>
      Target of '$short_code' is '$long_url'.
   </body>
</html>
END_HTML;
      exit();
   }

   $redir = "Location: $long_url";
   header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
   header("Cache-Control: post-check=0, pre-check=0", false);
   header("Pragma: no-cache");   header($redir, true, 301);

   //echo "Redirecting to $long_url\n";

   exit();
?>
