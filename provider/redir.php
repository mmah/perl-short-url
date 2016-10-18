<?php
   $url = $_SERVER['REQUEST_URI'];
   $url_param = explode ("/", $url, 3);                                                                                       
   $short_code = $url_param[2];  
                                                                                                                                        
   $dbhost = "ya-dbprod-01";                                                                                                                                                       
   $dbuser = "perl_app";                                                                                                                                                   
   $dbpass = "titus3:2";                                                                                                                                                
   $dbname = "vidb05";                                                                                                                                                 
   $db_conn = pg_Connect("host=$dbhost dbname=$dbname user=$dbuser password=$dbpass");                                                                                   
   if(!$db_conn){                                                                                                                                                        
      echo "Error: Unable to open database\n";                                                                                                                          
      exit();                                                                                                                                                            
   }       
                                                                                                                                                              
   $sql = "select long_url from short_urls where short_code = '$short_code';";                                                                                             
   $result = pg_exec($db_conn, $sql);    
                                                                                                                                
   $num_rows = pg_numrows($result);                                                                                                                                      
   if ($num_rows == 0) { 
      $long_url = "www.google.com/#q=$short_code";                                                                                                                                                
   } else {                                                                                                                                                              
      $row = pg_fetch_array($result, 0);                                                                                                                                 
      $long_url = $row["long_url"];                                                                                                                                  
   }                                                                                                                                                                     
   $redir = "Location: $long_url";                                                               
   header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
   header("Cache-Control: post-check=0, pre-check=0", false);
   header("Pragma: no-cache");   header($redir, true, 301);
   exit();
