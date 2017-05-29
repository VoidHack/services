<? session_start(); ?>

<? include("settings/header.php"); ?>


<?

if (!isset($mode)) {
  $mode = 'index';
}

global $post;

/* stop ../ style path-traversal */
$post = preg_replace("/\.\./", "", $post);
/* stop absolute paths (those beginning with a forwardslash) */
$post = preg_replace("/^\//", "", $post);

switch($mode) {

case 'index':

  $files = array();           
  $msg = file($postdir . '/' . $post . '.txt');
  $msg[] = $value;
  for (reset ($msg); list ($key, $value) = each ($msg); ) {
    if ($key == "0") { /* Subject */
	$subject = stripslashes($value);
    }
    if ($key == "1") { /* Author */
	$author = $value;
    }
    if ($key == "2") { /* Email */
	$temail = $value;
    }
    if ($key == "3") { /* Date */
	$date = $value;
    }
  }

  if (!session_is_registered("status")) {
    echo "<DIV CLASS=normal>You must be logged in to perform this operation. <A HREF=login.php>Click Here</A> to log in.";
  } 
  elseif (session_is_registered("status") && chop($author) != $username) {
    echo "You can only edit posts authored by you.";
  }

  else {
  echo "<DIV ALIGN=CENTER>";
  echo "<TABLE BORDER=0 CELLSPACING=1 CELLPADDING=0>";
  echo "<TR>";
  echo "<TD COLSPAN=2 ALIGN=RIGHT><A HREF=index.php><IMG SRC=settings/buttons/index.jpg WIDTH=80 HEIGHT=15 BORDER=0></A></TD>";
  echo "</TR>";
  echo "<TR>";
  echo "<TD COLSPAN=2 CLASS=header>&nbsp;&nbsp;Edit Post</TD>";
  echo "</TR>";
  echo "<TR><TD WIDTH=90 CLASS=Alt1>";
  echo "<FORM NAME=reply action=$PHP_SELF?mode=addentry_confirm&TopicID=$TopicID method=post>";
  echo "<DIV CLASS=normal>&nbsp;&nbsp;<b>Name:</b></TD><TD BGCOLOR=E6E6E6>&nbsp;&nbsp;<INPUT name=name type=text value='$author' size=40 onFocus=document.reply.name.blur()></TD></TR><TR>";
  echo "<TD CLASS=Alt1><DIV CLASS=normal>&nbsp;&nbsp;<b>E-Mail:</b></TD><TD CLASS=Alt1>&nbsp;&nbsp;<INPUT name=temail value='$temail' type=text size=40></TD></TR><TR>";
  echo "<TD CLASS=Alt1><DIV CLASS=normal>&nbsp;&nbsp;<b>Subject:</b></TD><TD CLASS=Alt1>&nbsp;&nbsp;<INPUT name=subject type=text value='$subject' size=55></TD></TR><TR>";
  echo "<TD CLASS=Alt1 VALIGN=TOP><DIV CLASS=normal>&nbsp;&nbsp;<b>Post Text:</b></TD><TD CLASS=Alt1>&nbsp;&nbsp;<TEXTAREA name=message rows=10 cols=55 wrap=none>";


  $files = array();           
  $msg = file($postdir . '/' . $post . '.txt');
  $msg[] = $value;
  for (reset ($msg); list ($key, $value) = each ($msg); ) {
    if ($key >= "5") { /* Subject */
      echo "$value";
    }
  }
  echo "</TEXTAREA>&nbsp;&nbsp;</TD></TR><TR>";
  echo "<TD CLASS=Alt1>&nbsp;</TD><TD ALIGN=LEFT CLASS=Alt1><INPUT TYPE=checkbox NAME=smilies VALUE=off>Disable <a href=# onclick=NewWindow('smiles_def.php','Smilies','350','400','no')>Smilies</A></INPUT></TD></TR><TR>";
  echo "<INPUT name=post type=hidden value=$post>";
  echo "<INPUT name=date type=hidden value='$date'>";
  echo "<TD COLSPAN=2 ALIGN=RIGHT CLASS=Alt1><INPUT name=submit type=submit value='Edit Post'>&nbsp;&nbsp;";
  echo "</FORM></DIV></TD></TR>";
  echo "</TABLE>";
  }
  break;
	
// Confirm that a post has been added and write to disk.
case 'addentry_confirm':
  // what to do with the form data 
  if ($message && $name && subject && email) {

    $filename = "$post.txt";
    $postfile = "$postdir/$filename";

    $name = stripslashes($name);
    $temail = stripslashes($temail);
    $subject = stripslashes($subject);
    $message = stripslashes($message);
    $date = chop($date);

    $message = chop($message);
    
    $thisdate = date("d-m-Y, H:i");

    if (!$smilies)
    {
	$smilies = "on";

    }
    $postdata = "$subject\n$name\n$temail\n$date\n$smilies\n$message\n\n[Edited by: $username on $thisdate]";

    if ($fp = fopen("$postfile", 'w')) {
      fwrite ($fp, $postdata);
      if (strstr($filename, '-') != false) {
        $tID = explode("-", $filename);
        $topic_ID = $tID[1];
      }
      else {
        $topic_ID = $filename;
      }
      echo "<DIV CLASS=normal>Post Edited.<P>";
      echo "<DIV CLASS=normal><A HREF=view.php?topic=$topic_ID.txt>View Post</A> | <A HREF=index.php>Back To Topics</A>";
      echo "<SCRIPT LANGUAGE='JavaScript'>";
      echo "window.location='view.php?topic=$topic_ID';";
      echo "</script>";

    }
  }
  else {
    echo "<DIV CLASS=normal>There was an error in posting. Please be sure you filled in the entire form";
  }
  break;

}

?>

<? include("settings/footer.php"); ?>
