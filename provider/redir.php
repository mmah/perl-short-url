<?php
   $url = $_SERVER['REQUEST_URI'];
   $url_param = explode ("/", $url, 3);
   $short_code = $url_param[2];

   $table_name = "short_urls";

   $dbhost = "ya-test-02";
   //$dbhost = "ya-dbprod-01";
   $dbuser = "perl_app";
   $dbpass = "titus3:2";
   $dbname = "vidb05";
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

   $sql = "select long_url from $table_name where short_code = '$short_code';";
   $result = pg_exec($db_conn, $sql);

   $num_rows = pg_numrows($result);
   if ($num_rows == 0) {
      echo <<<END_HTML
<html>
   <head>
   </head>
   <body>
      Error: Unable to recognize the link you entered.
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
   $redir = "Location: $long_url";
   header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
   header("Cache-Control: post-check=0, pre-check=0", false);
   header("Pragma: no-cache");   header($redir, true, 301);
   exit();
?>
