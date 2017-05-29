<? session_start(); ?>
<HEAD>
<TITLE>Forum</TITLE>
<? include("settings/style.php"); ?>
</HEAD>
<BODY BGCOLOR=<? echo $BGColor; ?>>
<? include("settings/functions.php"); ?>
<?
global $theUser;
?>
<DIV ALIGN=CENTER>

<TABLE BORDER=0 CELLSPACING=1 CELLPADDING=0 WIDTH=430>
  <TR>
   <TD CLASS=header COLSPAN=3>&nbsp;&nbsp;User Profile</TD>
  </TR>
   <TD WIDTH=280 VALIGN=TOP>
    <TABLE BORDER=0 CELLSPACING=1 CELLPADDING=0 WIDTH=350>
     <TR>
      <TD CLASS=Alt1 WIDTH=80 VALIGN=TOP>&nbsp;&nbsp;&nbsp;<B>Name:</B></TD>
      <TD CLASS=Alt1 WIDTH=350 VALIGN=TOP><? echo GetUserName($theUser); ?></TD>
     </TR>
     </TR>
      <TD CLASS=Alt1 WIDTH=80 VALIGN=TOP>&nbsp;&nbsp;&nbsp;<B>E-Mail:</B></TD>
      <TD CLASS=Alt1 WIDTH=350 VALIGN=TOP><A HREF=mailto:<? echo GetUserEmail($theUser); ?>><? echo GetUserEmail($theUser); ?></A></TD>
     </TR>
     </TR>
      <TD CLASS=Alt1 WIDTH=80 VALIGN=TOP>&nbsp;&nbsp;&nbsp;<B>Homepage:</B></TD>
      <TD CLASS=Alt1 WIDTH=350 VALIGN=TOP><A HREF=<? echo GetURL($theUser); ?> TARGET=_blank><? echo GetURL($theUser); ?></A></TD>
     </TR>
     </TR>
      <TD CLASS=Alt1 WIDTH=80 VALIGN=TOP>&nbsp;&nbsp;&nbsp;<B>ICQ:</B></TD>
      <TD CLASS=Alt1 WIDTH=350 VALIGN=TOP><? echo GetICQ($theUser); ?></TD>
     </TR>
     <TR>
      <TD CLASS=Alt1 WIDTH=80 VALIGN=TOP>&nbsp;&nbsp;&nbsp;<B>Bio:</B></TD>
      <TD CLASS=Alt1 WIDTH=350 VALIGN=TOP><? if (session_is_registered("user") && $author == $username) {echo GetUserBio($theUser);} else {echo "Sorry, that's private";} ?></TD>
     </TR>
    </TABLE>
   </TD>
   <TD WIDTH=80 VALIGN=TOP CLASS=ALT1>&nbsp;&nbsp;<? $glyph = GetMageGlyph2($theUser); if ($glyph != "") { echo "<IMG SRC=$glyph>"; } ?>&nbsp;</TD>
  <TR>
  </TR>

</TABLE>