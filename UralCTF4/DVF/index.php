<?
if ($mode == "logout") { 
  session_start();
  session_unregister('admin');
  unset($admin);
  session_unregister('user');
  unset($user);
  $logout = "1";
  $mode = 'index';
  session_destroy();
}
else {
  session_start();
}
?>

<? include("settings/header.php"); ?>
 
<?

if (!isset($mode)) {
  $mode = 'index';
}

if (!isset($page)) {
  $page = "1";
}

switch($mode) {

case 'index':
  if ($logout) { echo "<DIV CLASS=normal>You are now logged out.<P>"; }
  echo "<TABLE BORDER=0 CELLSPACING=1 CELLPADDING=1><TR>";
  echo "<TD COLSPAN=4 ALIGN=RIGHT><B>$registered</B> registered users.<BR><B>$posts</B> total posts in <B>$totalthreads</B> topics.<P></TD>";
  echo "</TR><TR>";
  echo "<TD COLSPAN=3 ALIGN=left>Threads sorted by order of activity.</TD>";
  echo "<TD ALIGN=RIGHT><A HREF=addtopic.php><IMG SRC=settings/buttons/new.jpg WIDTH=80 HEIGHT=15 BORDER=0></A></TD></TR><TR CLASS=header>";
  echo "<TD WIDTH=310 ALIGN=LEFT CLASS=header>&nbsp;&nbsp;<B>Topic:</B></TD>";
  echo "<TD WIDTH=80 ALIGN=LEFT CLASS=header>&nbsp;&nbsp;<B>Replies:</B></TD>";
  echo "<TD WIDTH=140 ALIGN=LEFT CLASS=header>&nbsp;&nbsp;<B>Posted On:</B></TD>";
  echo "<TD WIDTH=170 ALIGN=LEFT CLASS=header>&nbsp;&nbsp;<B>Author:</B></TD></TR>";
  $entries=opendir("$postdir");
  // Load files into an array  
  $files = array(); 
  $replies = array();         
  $tmpfiles = array();
  while ($file = readdir($entries)) {
    $tmpFiles[] = $file;
  }

  rsort($tmpFiles);

  foreach ($tmpFiles as $file) {
    if ($file != "." && $file != "..") {
      if (strstr($file, '-') != false) {
        list ($rdate, $parent) = explode('-', $file);
        if (!in_array($parent, array_keys($replies))) {
          $replies[$parent] = 1;
        }
        else {
          $replies[$parent]++;
        }
        if (!in_array($parent, $files)) {
          $files[] = $parent;
        }
      }
      else {
        if (!in_array($file, array_keys($replies))) {
          $replies[$file] = 0;
        }
        if (!in_array($file, $files)) {
          $files[] = $file;
        }
      }
    }
  }

  $threads = count($files);

  if ($page == "1") {
    $min = "0";
  }
  else {
    $p = $page - 1;
    $min = ($p * $split) - $p;
  }

  $max = $page * $split;

  $t_count = $min + 1;

//  echo "Page $page<BR>Min: $min<BR>Max: $max<BR>Starting t_count: $t_count";


  for (reset ($files); list ($key, $value) = each ($files); ) {
  if ($t_count <= $max && $t_count <= $threads) {
    while ($key >= $min) {
      if ($key % 2 != 1) { echo "<TR CLASS=Alt1>"; }
      else { echo "<TR CLASS=Alt>"; }
      $modify = $value;
      $msg = array();
      $msg = file("$postdir/$value");
      $msg[] = $value;
      for (reset ($msg); list ($key, $value) = each ($msg); ) {
        if ($key == "0") { /* Title */
	  $value = addslashes($value);
          echo "<TD>&nbsp;&nbsp;<A HREF=view.php?topic=$modify>$value</A></TD>\n";
          echo "<TD>&nbsp;&nbsp;&nbsp;$replies[$modify]</TD>\n";
        }
      }
      for (reset ($msg); list ($key, $value) = each ($msg); ) {
        if ($key == "3") { /* Date */
          echo "<TD>&nbsp;&nbsp;$value</TD>\n";
        } 
      }
      for (reset ($msg); list ($key, $value) = each ($msg); ) {
        if ($key == "1") { /* Author */
          echo "<TD>&nbsp;&nbsp;$value</TD></TR>\n";
        } 
      }
    $t_count++;
    }
  }
}
  echo "<TR><TD COLSPAN=4>";
  echo "<div class=small align=center>Page: ";
  for ($i = 1; $i <= ceil($threads / $split); $i++) {
   echo "<A HREF=$PHP_SELF?page=$i>$i</A> ";
  }
  echo "</div></TD>";
  echo "</TR></TABLE>";
//  echo "Final t_count: $t_count";
  // Finish things off
  closedir($entries);

  break; 
}


?>

<? include("settings/footer.php"); ?>
