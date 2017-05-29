<?
session_start();

?>

<? include("settings/header.php"); ?>

<?
if (!isset($mode))
{
	$mode = 'index';
}
// global $GPosting;

global $TopicID;

switch($mode) {

case 'index':
if ($GPosting == "0" && !(session_is_registered("status") && $status == "1"))
{
	echo "<DIV CLASS=normal>You must be logged in to post. <A HREF=login.php>Click Here</A> to log in.";
}

else
{

	if ($TopicID)
	{
		$files = array();           
		$msg = file($postdir . '/' . $TopicID . '.txt');
		$msg[] = $value;
		for (reset ($msg); list ($key, $value) = each ($msg); )
		{
			if ($key == "0")
			{ /* Subject */
				$subj = "Re: $value";
			}
		}
	}

	echo "<DIV ALIGN=CENTER>";
	echo "<TABLE BORDER=0 CELLSPACING=1 CELLPADDING=0>";
	echo "<TR>";
	echo "<TD COLSPAN=2 ALIGN=RIGHT><A HREF=index.php><IMG SRC=settings/buttons/index.jpg WIDTH=80 HEIGHT=15 BORDER=0></A></TD>";
	echo "</TR>";
	echo "<TR>";
	echo "<TD COLSPAN=2 CLASS=header>&nbsp;&nbsp;Add A New Topic</TD>";
	echo "</TR>";
	echo "<TR><TD WIDTH=90 CLASS=Alt1>";
	echo "<FORM NAME=add action=$PHP_SELF?mode=addentry_confirm method=post>";
	if ($GPosting == "0")
	{
		echo "<DIV CLASS=normal>&nbsp;&nbsp;<b>Name:</b></TD><TD CLASS=Alt1>&nbsp;&nbsp;<INPUT name=name type=text value='$username' size=40 onFocus=document.reply.name.blur()></TD></TR><TR>";
	}
	elseif (session_is_registered("status") && $status == "1")
	{
		echo "<DIV CLASS=normal>&nbsp;&nbsp;<b>Name:</b></TD><TD CLASS=Alt1>&nbsp;&nbsp;<INPUT name=name type=text value='$username' size=40></TD></TR><TR>";
	}
	else
	{
		echo "<DIV CLASS=normal>&nbsp;&nbsp;<b>Name:</b></TD><TD CLASS=Alt1>&nbsp;&nbsp;<INPUT name=name type=text value='$username' size=40></TD></TR><TR>";
		echo "<TD CLASS=Alt1><DIV CLASS=normal>&nbsp;&nbsp;<b>Password:</b></TD><TD CLASS=Alt1>&nbsp;&nbsp;<INPUT name=password type=password size=40> <i>* For Registered Users</i></TD></TR><TR>";
	}
	echo "<TD CLASS=Alt1><DIV CLASS=normal>&nbsp;&nbsp;<b>E-Mail:</b></TD><TD CLASS=Alt1>&nbsp;&nbsp;<INPUT name=temail value='$usermail' type=text size=40></TD></TR><TR>";
	echo "<TD CLASS=Alt1><DIV CLASS=normal>&nbsp;&nbsp;<b>Subject:</b></TD><TD CLASS=Alt1>&nbsp;&nbsp;<INPUT name=subject type=text size=55 value=\"$subj\"></TD></TR><TR>";
	echo "<TD CLASS=Alt1 VALIGN=TOP><DIV CLASS=normal>&nbsp;&nbsp;<b>Post Text:</b></TD><TD CLASS=Alt1>&nbsp;&nbsp;<TEXTAREA name=message rows=10 cols=55 wrap=none>";
	echo "</TEXTAREA>&nbsp;&nbsp;</TD></TR><TR>";
	echo "<TD CLASS=Alt1>&nbsp;</TD><TD ALIGN=LEFT CLASS=Alt1><INPUT TYPE=checkbox NAME=smilies VALUE=off>Disable <a href=# onclick=NewWindow('smiles_def.php','Smilies','350','400','no')>Smilies</A></INPUT></TD></TR><TR>";
	echo "<TD COLSPAN=2 ALIGN=RIGHT CLASS=Alt1><INPUT name=submit type=submit value='Add Reply'>&nbsp;&nbsp;";
	echo "<INPUT TYPE=hidden NAME=TopicID VALUE=$TopicID>";
	echo "</FORM></DIV></TD></TR>";
	echo "</TABLE>";
}

break;
	
// Confirm that a post has been added and write to disk.
case 'addentry_confirm':

// what to do with the form data 
if ($message && $name && $subject && $temail)
{

	$entries=opendir("$userdir");
	// Load files into an array
	$files = array();
	while ($file = readdir($entries))
	{
		if ($file != "." && $file != "..")
		{
			$files[] = $file;
		}
	}
 
	if ($GPosting == '1')
	{
		if (session_is_registered("status"))
		{
			$poststatus = "Ok";
		}
		elseif (FindInArray($files, $name))
		{

			for (reset ($files); list ($key, $value) = each ($files); )
			{
				$ruser = file("$userdir/$value");
				$ufile = "$userdir/$value";
				$ruser[] = $value;
				for (reset ($ruser); list ($key, $value) = each ($ruser); )
				{
					if ($key == "0")
					{ /* username:password */
						list ($user, $pass) = explode(':', $value);
						$pass = chop($pass);
						$encpass = md5($password);
						if ($user == $name && $encpass == $pass)
						{
							$poststatus = "Ok";
						}
					}
				}
			}
		}
		else
		{
			$poststatus = "Ok";
		}
	}
   
	if ($poststatus == "Ok") {

	$topicdate = date("YmdHis");
	$filename = "$topicdate-$TopicID.txt";
	$postfile = "$postdir/$filename";

	$name = stripslashes($name);
	$temail = stripslashes($temail);
	$subject = stripslashes($subject);
	$message = stripslashes($message);
	$subject = ereg_replace("'", "", $subject);
	
	$date = date("d-m-Y, H:i ");

	if (!$smilies)
	{
		$smilies = "on";
	}

	$postdata = "$subject\n$name\n$temail\n$date\n$smilies\n$message";

	if ($fp = fopen("$postfile", 'w'))
	{
		fwrite ($fp, $postdata);
		echo "<DIV CLASS=normal>Your post has been added. You are now being taken to the topic index.<P>";
		echo "<DIV CLASS=normal>If you are not automatically redirected, <A HREF=index.php>click here</A>.";
		echo "<SCRIPT LANGUAGE='JavaScript'>";
		echo "window.location='index.php';";
		echo "</script>";
	}

}

	else
{
	echo "<DIV CLASS=normal>There was an error in posting. Please be sure you filled in the entire form<P>Click <A HREF=# onClick='history.go(-1)'>here</A> to go back.";
}
}
else {
    echo "<DIV CLASS=normal>There was an error in posting. Please be sure you filled in the entire form<P>Click <A HREF=# onClick='history.go(-1)'>here</A> to go back.";
}
break;
}

?>

<? include("settings/footer.php"); ?>
