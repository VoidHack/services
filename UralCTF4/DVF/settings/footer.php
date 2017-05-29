<DIV ALIGN=CENTER><P>
<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=2>
 <TR>
  <TD CLASS=Alt1>
   <DIV STYLE="font-family:arial, helvetica, sans-seriv; font-size:8pt; font-color:<? echo '$FontColor'; ?>;">
    <A HREF=login.php STYLE="font-size:8pt; font-weight:normal;">LogIn</A> | 
    <A HREF=index.php?mode=logout STYLE="font-size:8pt; font-weight:normal;">LogOut</A> | 
    <A HREF=register.php STYLE="font-size:8pt; font-weight:normal;">Register</A> | 
    <A HREF=preferences.php STYLE="font-size:8pt; font-weight:normal;">Preferences</A> | 
    <A HREF=index.php STYLE="font-size:8pt; font-weight:normal;">Topic Index</A> |
    HTML is <? if ($AllowHTML == "0") { echo "OFF"; } else { echo "ON"; } ?>. <A HREF=# onclick=NewWindow('codes_def.php','ForumCodes','600','500','no') STYLE="font-size:8pt; font-weight:bold;">Forum Codes</A> are enabled. | Guest Posting is <? if ($GPosting == "0") { echo "OFF"; } else { echo "ON"; } ?>.
   </DIV>
  </TD>
 </TR>
</TABLE>

<?

echo "<DIV CLASS=small ALIGN=CENTER>";
if (session_is_registered("status"))
{
	if ($username) {
		echo "Logged in as: <B>$username</B>";
		if (session_is_registered("admin") && $admin = $unique_str)
		{
			echo " (Forum Admin)";
		}
	}
}
else
{
	echo "You are not currently logged in.";
}
echo "</DIV><P>";
?>

</DIV>
<DIV ALIGN=CENTER CLASS=normal>
<HR WIDTH=700>
Forum Administrator: <A HREF=mailto:<? echo $AdminEmail; ?>><? echo $ForumAdmin; ?></A>
</DIV>

