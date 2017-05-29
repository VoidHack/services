<? session_start(); ?>
<? include("settings/header.php"); ?>
<TABLE BORDER=0 CELLSPACING=1 CELLPADDING=0 WIDTH=700>
  <TR>
   <TD WIDTH=700 ALIGN=RIGHT><A HREF=index.php><IMG SRC=settings/buttons/index.jpg WIDTH=80 HEIGHT=15 BORDER=0></A></TD>
  </TR>
  <TR>
   <TD CLASS=header>&nbsp;&nbsp;Delete Post</TD>
  </TR>
   <TD CLASS=Alt1 HEIGHT=100 VALIGN=TOP>
<?
global $post;
if (!isset($mode)) {
  $mode = 'index';
}

/* stop ../ style path-traversal */
$topic = preg_replace("/\.\./", "", $topic);
/* stop absolute paths (those beginning with a forwardslash) */
$topic = preg_replace("/^\//", "", $topic);

$files = array();           
$msg = file($postdir . '/' . $post . '.txt');
$msg[] = $value;
for (reset ($msg); list ($key, $value) = each ($msg); ) {
  if ($key == "0") { /* Subject */
    $subject = $value;
  }
  if ($key == "1") { /* Author */
  $author = $value;
  }
  if ($key == "3") { /* Date */
    $date = $value;
  }
}

switch($mode) {
case 'index':

if (!session_is_registered("status")) {
  echo "<DIV CLASS=normal>You must be logged in to perform this operation. <A HREF=login.php>Click Here</A> to log in.";
} 
elseif ((!session_is_registered("admin") || $admin != $unique_str)) {
  echo "Invalid Admin ID.";
}

if (session_is_registered("admin")) {
echo "&nbsp;&nbsp;Delete Confirmation:<P>";
echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B>$subject</B><BR>";
echo "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Posted by: $author, on: $date.";
echo "<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF=$PHP_SELF?mode=delete&post=$post>Delete Post</A> | <A HREF=index.php>Cancel</A>";
}

elseif (session_is_registered("user")) {
  echo "Only Admins can delete posts.";
}
break;

case 'delete':

if (strstr($post, '-') != false) {
  echo "&nbsp;&nbsp;<B>$subject</B>&nbsp;(TopicID: $post)<P>&nbsp;&nbsp;Deleted successfully.";
  unlink("$postdir/$post.txt");
}

elseif (strstr($post, '-') == false) {
  echo "&nbsp;&nbsp;<B>$subject</B><BR>&nbsp;(TopicID: $post)<BR>&nbsp;Deleted successfully.";
  unlink("$postdir/$post.txt");
  $entries=opendir("$postdir");
  // Load files into an array  
  $files = array();           
  while ($file = readdir($entries)) {
    if ($file != "." && $file != "..") {
      if (strstr($file, '-' . $post) != false) {
        $files[] = $file; 
      }
    }  
  }
  if (count($files) > 0) {
//   unlink("$postdir/$post.txt");
     rename("data/$files[0]", "data/" . $post . ".txt");
  }
}  
break;

}
?>
  </TD>
 </TR>
</TABLE>

<? include("settings/footer.php"); ?>
