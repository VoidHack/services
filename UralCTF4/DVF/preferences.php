<? session_start(); ?>
<? include("settings/header.php"); ?>

<TABLE BORDER=0 CELLSPACING=1 CELLPADDING=0>
 <TR>
  <TD ALIGN=RIGHT COLSPAN=2><A HREF=index.php><IMG SRC=settings/buttons/index.jpg WIDTH=80 HEIGHT=15 BORDER=0></A></TD>
 </TR>
 <TR>
  <TD COLSPAN=2 CLASS=header ALIGN=LEFT>User Preferences</TD>
 </TR>
 <TR>

<?
if (!isset($mode)) {
  $mode = 'index';
}

global $userdir;

// Now, Display the form to enter/change data and put any existing data on the
// user into it.

switch($mode) {
  case 'index':

if (!(session_is_registered("admin") || session_is_registered("user")))
{
	echo "<TD WIDTH=600 CLASS=ALT1>You must be logged in to edit your profile. <A HREF=login.php>Click Here</A> to log in.</TD>";
}

else {
	echo "<FORM ACTION=$PHP_SELF?mode=update METHOD=post>";
	echo "<TD CLASS=Alt1 WIDTH=100><B>&nbsp;&nbsp;&nbsp;User Name:</B></TD><TD CLASS=Alt1>";
	$name = @GetUserName($username);
	echo $name;
	echo "</TD>";
	echo "</TR>";
	echo "<TR>";
	echo "<TD CLASS=Alt1 WIDTH=100><B>&nbsp;&nbsp;&nbsp;Email Address:</B></TD><TD CLASS=Alt1><INPUT TYPE=text NAME=temail SIZE=30 VALUE=";
	echo @GetUserEmail($username);
	echo"></TD>";
	echo "</TR>";
	echo "<TR>";
	echo "<TD CLASS=Alt1 WIDTH=100 valign=top><B>&nbsp;&nbsp;&nbsp;Password:</B></TD><TD CLASS=Alt1><INPUT TYPE=password NAME=password SIZE=30><div style='font-size:9px;'><i>* NOTE: Only fill out this field if you are changing your password.</i?</div></TD>";
	echo "</TR>";
	echo "<TR>";
	echo "<TD CLASS=Alt1 WIDTH=100><B>&nbsp;&nbsp;&nbsp;Homepage:</B></TD><TD CLASS=Alt1><INPUT TYPE=text NAME=url SIZE=30 VALUE=";
	echo @GetURL($username);
	echo"></TD>";
	echo "</TR>";
	echo "<TR>";
	echo "<TD CLASS=Alt1 WIDTH=100><B>&nbsp;&nbsp;&nbsp;ICQ Number:</B></TD><TD CLASS=Alt1><INPUT TYPE=text NAME=icq SIZE=30 VALUE=";
	echo @GetICQ($username);
	echo"></TD>";
	echo "</TR>";
	echo "<TR>";
	echo "<TD CLASS=Alt1 WIDTH=100><B>&nbsp;&nbsp;&nbsp;Photo:</B></TD><TD CLASS=Alt1><INPUT TYPE=text NAME=glyph SIZE=30 VALUE=";
	echo @GetMageGlyph2($username);
	echo"></TD>";
	echo "</TR>";
	echo "<TR>";
	echo "<TD WIDTH=100 CLASS=Alt1 VALIGN=TOP><B>&nbsp;&nbsp;&nbsp;Boigraphy:</B></TD><TD CLASS=Alt1><TEXTAREA NAME=bio ROWS=10 COLS=40 WRAP=virtual>"; @GetUserBio2($username); echo"</TEXTAREA></TD>";
	echo "<INPUT TYPE=hidden NAME=adminstatus VALUE=";
	echo chop(@GetAdminStatus($username));
	echo ">";
	echo "</TR>";
	echo "<TR>";
	echo "<TD WIDTH=100 CLASS=Alt1 VALIGN=TOP><B>&nbsp;&nbsp;&nbsp;Signature:</B></TD><TD CLASS=Alt1><TEXTAREA NAME=sig ROWS=4 COLS=40 WRAP=virtual>"; GetSig2($username); echo"</TEXTAREA></TD>";
	echo "</TR>";
 
	echo "<TR>";
	echo "<TD COLSPAN=2 CLASS=Alt1 ALIGN=RIGHT><INPUT TYPE=submit NAME=Update VALUE=Update></INPUT></TD>";
}
break;

case 'update':
if ($username)
{
	$bio = stripslashes($bio);
	$temail = stripslashes($temail);
	$url = stripslashes($url);
	$icq = stripslashes($icq);
	$glyph = stripslashes($glyph);
	$bio = ereg_replace("<", "&lt;", $bio);
	$bio = ereg_replace(">", "&gt;", $bio);
	$bio = stripslashes($bio);

	$sig = ereg_replace("<", "&lt;", $sig);
	$sig = ereg_replace(">", "&gt;", $sig);
	$sig = stripslashes($sig);


	if ($password)
	{
		$password = md5($password);
	}
	else
	{
		$password = GetPass($username);
	}

	if (session_is_registered("admin") && $admin = $unique_str)
	{
		$profile = "$username:$password\n$temail\n$url\n$icq\n$glyph\nadmin\n$sig";
	}
	else
	{   
		$profile = "$username:$password\n$temail\n$url\n$icq\n$glyph\n\n$sig";
	}

	if ($fp = fopen("$userdir/$username", 'w'))
	{
		fwrite ($fp, $profile);
	}

	if ($fp = fopen("$biodir/$username", 'w'))
	{
		fwrite ($fp, $bio);
	}

	echo " <TR><TD COLSPAN=2 WIDTH=600 CLASS=Alt1 ALIGN=LEFT>&nbsp;&nbsp;&nbsp;Your profile has been updated.</TD></TR>";
}
break;
}
?>
 </TR>
</TABLE>
</FORM>
<P>

<? include("settings/footer.php"); ?>
