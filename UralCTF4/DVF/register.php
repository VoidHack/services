<?
session_start();
if (!isset($mode))
{
	$mode = 'index';
}


switch($mode)
{

	case 'index':
	include("settings/header.php");
	echo "<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH=100% HEIGHT=90%>\n";
	echo " <TR>\n";
	echo "  <TD WIDTH=100% HEIGHT=90% ALIGN=CENTER VALIGN=MIDDLE>\n";
	echo "<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0>\n";
	echo " <TR>\n";
	echo "  <TD COLSPAN=2 CLASS=HEADER>&nbsp;&nbsp;&nbsp;New User Registration</TD>\n";
	echo " </TR>\n";
	echo " <TR>\n";
	echo "  <TD CLASS=ALT1 WIDTH=85><B>&nbsp;&nbsp;&nbsp;Username:</B></TD>\n";
	echo "  <TD CLASS=ALT1><FORM ACTION=$PHP_SELF?mode=registration_confirm METHOD=post><INPUT TYPE=TEXT SIZE=20 NAME=uname>&nbsp;&nbsp;&nbsp;</TD>\n";
	echo " </TR>\n";
	echo " <TR>\n";
	echo "  <TD CLASS=ALT1><B>&nbsp;&nbsp;&nbsp;Password:</B></TD><TD CLASS=ALT1><INPUT TYPE=password SIZE=20 NAME=passwd>&nbsp;&nbsp;&nbsp;</TD>\n";
	echo " </TR>\n";
	echo " <TR>\n";
	echo " <TD CLASS=ALT1>&nbsp;&nbsp;<B>Password:</B></TD><TD CLASS=ALT1><INPUT TYPE=password SIZE=20 NAME=passwd1>&nbsp;&nbsp;&nbsp;</TD>\n";
	echo " </TR>\n";
	echo " <TR>\n";
	echo "  <TD CLASS=ALT1><B>&nbsp;&nbsp;&nbsp;E-Mail:</B></TD><TD CLASS=ALT1><INPUT TYPE=TEXT SIZE=20 NAME=email>&nbsp;&nbsp;&nbsp;</TD>\n";
	echo " </TR>\n";
	echo " <TR>\n";
	echo "  <TD COLSPAN=2 CLASS=ALT1 ALIGN=RIGHT><INPUT TYPE=submit NAME=Register VALUE=submit>&nbsp;&nbsp;&nbsp;</TD>\n";
	echo " </TR>\n";
	echo "</TABLE>\n";
	echo "<P>&nbsp;</P><P><TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH=400>\n";
	echo "<TR><TD WIDTH=400 ALIGN=JUSTIFY><i>* NOTE:</i> No spaces are allowed in your username, password, or email.  Any spaces you add will automatically be removed.</TD></TR></TABLE>";
	echo "  </TD>\n";
	echo " </TR>\n";
	echo "</TABLE>\n";
	break;

	case 'registration_confirm':
	// what to do with the form data 

	include("settings/header.php");

	if ($uname && $passwd && $passwd1 && $email)
	{
		$uname = stripslashes($uname);
		$uname = ereg_replace(" ", "", $uname);
		$usrfile = "$userdir/$uname";
		$email = stripslashes($email);
		$passwd = stripslashes($passwd);
		$passwd1 = stripslashes($passwd1);
		$usrfile = "$userdir/$uname";
		$email = ereg_replace(" ", "", $email);
		$passwd = ereg_replace(" ", "", $passwd);
		$passwd1 = ereg_replace(" ", "", $passwd1);

		if ($passwd == $passwd1)
		{
			$passwd = md5($passwd);
			$usrdata = "$uname:$passwd\n$email";
			if (!is_file($usrfile))
			{
				if ($fp = fopen("$usrfile", 'w'))
				{
					fwrite ($fp, $usrdata);
					$fp = fopen($usrfile, "r");
					$file_contents = fread($fp, filesize($usrfile));
					fclose($fp);
			         }
				echo "<DIV CLASS=normal>Thank you for registering.<P>";
				echo "<DIV CLASS=normal><A HREF=index.php>Back To Topics</A>";
			}
		}
	else
	{
		echo "<DIV CLASS=normal>There was an error in registering. Username already exists.";
		echo "<P><A HREF=$PHP_SELF?mode=index>Click Here</A> to go back.";
	}
}

else
{
	echo "<DIV CLASS=normal>There was an error in registering. Your passwords did not match.";
	echo "<P><A HREF=$PHP_SELF?mode=index>Click Here</A> to go back.";
}

break;

}
?>

<? include("settings/footer.php"); ?>
