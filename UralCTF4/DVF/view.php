<? session_start(); ?>
<? include("settings/header.php"); ?>

<?

if (!isset($mode)) {
  $mode = 'index';
}

/* stop ../ style path-traversal */
$topic = preg_replace("/\.\./", "", $topic);
/* stop absolute paths (those beginning with a forwardslash) */
$topic = preg_replace("/^\//", "", $topic);

$getID = explode(".", $topic);

$TopicID = $getID[0];

switch($mode) {
case 'index': /* Display entries by default */

$files = array();           
$msg = file($postdir . '/' . $topic);
$msg[] = $value;
for (reset ($msg); list ($key, $value) = each ($msg); )
{

	if ($key == "0")
	{ /* Subject */
		echo "<TABLE BORDER=0 CELLSPACING=1 CELLPADDING=0>";
		echo "<TR>";
		echo "<TD WIDTH=700 ALIGN=RIGHT COLSPAN=2><A HREF=reply.php?TopicID=$TopicID><IMG SRC=settings/buttons/reply.jpg WIDTH=80 HEIGHT=15 BORDER=0></A> <A HREF=index.php><IMG SRC=settings/buttons/index.jpg WIDTH=80 HEIGHT=15 BORDER=0></A> </TD>";
		echo "</TR>";
		echo "<TR>";
		echo "<TD COLSPAN=2 CLASS=header ALIGN=LEFT>";
		$value = addslashes($value);
		echo "&nbsp;&nbsp;$value";
		echo "</TD></TR>";
	}
	if ($key == "1")
	{ /* Author */
		echo "<TR><TD WIDTH=175 VALIGN=TOP CLASS=Alt1>";
		echo "&nbsp;&nbsp;<B>Author:</B> $value";
		$author = $value;
		$author = ereg_replace(" ", "", $author);
		$author = chop($author);
		echo "<BR>";
	}
	if ($key == "2")
	{ /* Email */
		$email = $value;
	}

	if ($key == "3")
	{ /* Date */
		echo "&nbsp;&nbsp;<B>Date:</B> $value<P>";
		$author = chop($author);

		echo "&nbsp;&nbsp;";GetMageGlyph($author);
		echo "&nbsp;&nbsp;<A CLASS=mail HREF=mailto:$email><IMG SRC=settings/buttons/sendemail.gif BORDER=0 ALT='E-Mail User'></A>&nbsp;";
		echo "&nbsp;<A HREF=# onclick=NewWindow('profile.php?theUser=$author','UserBio','500','400','auto')><IMG SRC=settings/buttons/profile.gif BORDER=0></A>&nbsp;";
		echo "<!--";
		$ICQ = GetICQ($author);
		$ICQ = chop($ICQ);
		$URL = GetURL($author);
		$URL = chop($URL);
		echo "-->";
		if ($URL)
		{
			echo "<A HREF=$URL TARGET=_new><IMG SRC=settings/buttons/homepage.gif BORDER=0></A>&nbsp;";
		}
		if ($ICQ)
		{ 
			echo "<A HREF=http://wwp.icq.com/$ICQ#pager TARGET=_blank><img alt=ICQ Status src=http://wwp.icq.com/scripts/online.dll?icq=$ICQ&img=5 border=0></a>&nbsp;<BR>";
		}

		echo "<P>";
		if (session_is_registered("admin") && $admin = $unique_str) {
			echo "&nbsp;&nbsp;<A HREF=edit.php?post=$TopicID>Edit</A> | <A HREF=delete.php?post=$TopicID>Delete</A>";
		}
		elseif (session_is_registered("user") && $author == $username) {
			echo "&nbsp;&nbsp;<A HREF=edit.php?post=$TopicID>Edit</A>";
		}
		echo "</TD>\n\n";
		echo "<TD WIDTH=525 VALIGN=TOP CLASS=Alt1><DIV STYLE=margin-left:5px>\n\n";

	}

	if ($key == "4")
	{
		$tsmilies = chop($value);
	}

	if ($key >= "5")
	{ /* Fill it up */


		if ($AllowHTML == "0")
		{
			$value = ereg_replace("<", "&lt;", $value);
			$value = ereg_replace(">", "&gt;", $value);
		}
		//Simple Codes [b][/b] - [i][/i] - [quote][/quote]
		$value = str_replace("[img]", "<img src=", $value);
		$value = str_replace("[/img]", ">", $value);
		$value = str_replace("[b]", "<b>", $value);
		$value = str_replace("[u]", "<u>", $value);
		$value = str_replace("[i]", "<i>", $value);
		$value = str_replace("[/b]", "</b>", $value);
		$value = str_replace("[/u]", "</u>", $value);
		$value = str_replace("[/i]", "</i>", $value);
		$value = str_replace("[ul]", "<ul>", $value);
		$value = str_replace("[/ul]", "</ul>", $value);
		$value = str_replace("[li]", "<li>", $value);
		$value = str_replace("[/li]", "</li>", $value);
		$value = str_replace("[ol]", "<ol>", $value);
		$value = str_replace("[/ol]", "</ol>", $value);
		$value = str_replace("[code]", "<pre style='font-size:10px'>", $value);
		$value = str_replace("[/code]", "</pre>", $value);
		$value = str_replace("[quote]", "<blockquote>", $value);
		$value = str_replace("[/quote]", "</blockquote>", $value);

		$value = str_replace("[IMG]", "<img src=", $value);
		$value = str_replace("[/IMG]", ">", $value);
		$value = str_replace("[B]", "<b>", $value);
		$value = str_replace("[U]", "<u>", $value);
		$value = str_replace("[I]", "<i>", $value);
		$value = str_replace("[/B]", "</b>", $value);
		$value = str_replace("[/U]", "</u>", $value);
		$value = str_replace("[/I]", "</i>", $value);
		$value = str_replace("[UL]", "<ul>", $value);
		$value = str_replace("[/UL]", "</ul>", $value);
		$value = str_replace("[LI]", "<li>", $value);
		$value = str_replace("[/LI]", "</li>", $value);
		$value = str_replace("[OL]", "<ol>", $value);
		$value = str_replace("[/OL]", "</ol>", $value);
		$value = str_replace("[CODE]", "<pre style='font-size:10px'>", $value);
		$value = str_replace("[/CODE]", "</pre>", $value);
		$value = str_replace("[QUOTE]", "<blockquote>", $value);
		$value = str_replace("[/QUOTE]", "</blockquote>", $value);

		if ($tsmilies == "on")
		{
			$SmiliesCodes = array(":)", ":(", ";)", ":o", ":p", ":|", ":x", "8)", ":{");
			$c = count($SmiliesCodes);
			for ($i = 0; $i < $c; $i++)
			{
				$value = str_replace("$SmiliesCodes[$i]", '<img src=settings/smilies/s'.$i.'.gif>', $value);
			}
		}
	
		$value = eregi_replace("[^src=\"](http://(([A-Za-z0-9~&=;\?%_#./\-])*)([a-zA-Z0-9/]))", " [url=\\1]\\1[/url]",$value);
		$value = eregi_replace("[^http://](www\.(([A-Za-z0-9~&=;\?%_#./\-])*)([a-zA-Z0-9/]))", " [url=http://\\1]\\1[/url]",$value);
		$value = eregi_replace("^(http://(([A-Za-z0-9~&=;\?%_.#/\-])*)([a-zA-Z0-9/]))", " [url=\\1]\\1[/url]",$value);
	
		$value = eregi_replace("(\[url=)([A-Za-z0-9_~&=;\?:%@#./\-]+[A-Za-z0-9/])(\])", "<a href=\"\\2\" target=_blank>",$value);
		$value = eregi_replace("(\[/url\])", "</a>",$value);

		echo "$value<br>";
	}
}

echo "<P>--</BR>";
@GetSig($author);
echo "</DIV></TD></TR></TABLE><P>";

$entries=opendir("$postdir");
// Load files into an array  
$files = array();           
while ($file = readdir($entries))
{
	if ($file != "." && $file != "..")
	{
		if (strstr($file, '-' . $TopicID) == true)
		{
			$files[] = $file; 
		}
	}
}

for (reset ($files); list ($key, $value) = each ($files); )
{
	$reply = file("$postdir/$value");
	$getreplyID = explode(".", $value);
	$ReplyID = $getreplyID[0];
	for (reset ($reply); list ($key, $value) = each ($reply); )
	{
		if ($key == "0")
		{ /* Subject */
			echo "<TABLE BORDER=0 CELLSPACING=1 CELLPADDING=0 WIDTH=700>";
			echo "<TR>";
			echo "<TD COLSPAN=2 CLASS=header ALIGN=LEFT>";
			$value = addslashes($value);
			echo "&nbsp;&nbsp;$value";
			echo "</TD></TR>";
		}
		if ($key == "1")
		{ /* Author */
			echo "<TR><TD WIDTH=175 VALIGN=TOP Class=Alt1>";
			echo "&nbsp;&nbsp;<B>Author:</B> $value";
			$author = $value;
		        $author = ereg_replace(" ", "", $author);
		        $author = chop($author);
		        echo "<BR>";
		}

		if ($key == "2")
		{ /* Email */
			$email = $value;
		}

		if ($key == "3")
		{ /* Date */
			echo "&nbsp;&nbsp;<B>Date:</B> $value<P>";
			$author = chop($author);
  
			echo "&nbsp;&nbsp;";GetMageGlyph($author);
			echo "&nbsp;&nbsp;<A CLASS=mail HREF=mailto:$email><IMG SRC=settings/buttons/sendemail.gif BORDER=0 ALT='E-Mail User'></A>";
			echo "&nbsp;<A HREF=# onclick=NewWindow('profile.php?theUser=$author','UserBio','500','400','auto')><IMG SRC=settings/buttons/profile.gif BORDER=0></A>&nbsp;";
			echo "<!--";
		        $ICQ = GetICQ($author);
		        $ICQ = chop($ICQ);
		        $URL = GetURL($author);
		        $URL = chop($URL);
			echo "-->";
		        if ($URL)
			{
				echo "<A HREF=$URL TARGET=_new><IMG SRC=settings/buttons/homepage.gif BORDER=0></A>&nbsp;";
			}
			if ($ICQ)
			{ 
				echo "<A HREF=http://wwp.icq.com/$ICQ#pager TARGET=_blank><img alt=ICQ Status src=http://wwp.icq.com/scripts/online.dll?icq=$ICQ&img=5 border=0></a>&nbsp;<BR>";
			}
			echo "<P>";

			if (session_is_registered("admin") && $admin = $unique_str)
			{
				echo "&nbsp;&nbsp;<A HREF=edit.php?post=$ReplyID>Edit</A> | <A HREF=delete.php?post=$TopicID>Delete</A>";
			}
			elseif (session_is_registered("user") && $author == $username)
			{
				echo "&nbsp;&nbsp;<A HREF=edit.php?post=$ReplyID>Edit</A>";
			}
			echo "</TD>";
			echo "<TD WIDTH=525 VALIGN=TOP CLASS=Alt1><DIV STYLE=margin-left:5px>";

		}

		if ($key == "4")
		{
			$tsmilies = chop($value);
		}
  
		if ($key >= "5")
		{ /* Fill it up */
			if ($AllowHTML == "0")
			{
				$value = ereg_replace("<", "&lt;", $value);
				$value = ereg_replace(">", "&gt;", $value);
			}
			//Simple Codes [b][/b] - [i][/i] - [quote][/quote]
			$value = str_replace("[img]", "<img src=", $value);
			$value = str_replace("[/img]", ">", $value);
			$value = str_replace("[b]", "<b>", $value);
			$value = str_replace("[u]", "<u>", $value);
			$value = str_replace("[i]", "<i>", $value);
			$value = str_replace("[/b]", "</b>", $value);
			$value = str_replace("[/u]", "</u>", $value);
			$value = str_replace("[/i]", "</i>", $value);
			$value = str_replace("[ul]", "<ul>", $value);
			$value = str_replace("[/ul]", "</ul>", $value);
			$value = str_replace("[li]", "<li>", $value);
			$value = str_replace("[/li]", "</li>", $value);
			$value = str_replace("[ol]", "<ol>", $value);
			$value = str_replace("[/ol]", "</ol>", $value);
			$value = str_replace("[code]", "<pre style='font-size:10px'>", $value);
			$value = str_replace("[/code]", "</pre>", $value);				$value = str_replace("[quote]", "<ul><i>", $value);
			$value = str_replace("[quote]", "<blockquote>", $value);
			$value = str_replace("[/quote]", "</blockquote>", $value);

			$value = str_replace("[IMG]", "<img src=", $value);
			$value = str_replace("[/IMG]", ">", $value);
			$value = str_replace("[B]", "<b>", $value);
			$value = str_replace("[U]", "<u>", $value);
			$value = str_replace("[I]", "<i>", $value);
			$value = str_replace("[/B]", "</b>", $value);
			$value = str_replace("[/U]", "</u>", $value);
			$value = str_replace("[/I]", "</i>", $value);
			$value = str_replace("[UL]", "<ul>", $value);
			$value = str_replace("[/UL]", "</ul>", $value);
			$value = str_replace("[LI]", "<li>", $value);
			$value = str_replace("[/LI]", "</li>", $value);
			$value = str_replace("[OL]", "<ol>", $value);
			$value = str_replace("[/OL]", "</ol>", $value);
			$value = str_replace("[CODE]", "<pre style='font-size:10px'>", $value);
			$value = str_replace("[/CODE]", "</pre>", $value);
			$value = str_replace("[QUOTE]", "<blockquote>", $value);
			$value = str_replace("[/QUOTE]", "</blockquote>", $value);
	
			if ($tsmilies == "on")
			{
				$SmiliesCodes = array(":)", ":(", ";)", ":o", ":p", ":|", ":x", "8)", ":{");
				$c = count($SmiliesCodes);
				for ($i = 0; $i < $c; $i++)
				{
					$value = str_replace("$SmiliesCodes[$i]", '<img src=settings/smilies/s'.$i.'.gif>', $value);
				}
			}
	
			$value = eregi_replace("[^src=\"](http://(([A-Za-z0-9~&=;\?%_#./\-])*)([a-zA-Z0-9/]))", " [url=\\1]\\1[/url]",$value);
			$value = eregi_replace("[^http://](www\.(([A-Za-z0-9~&=;\?%_#./\-])*)([a-zA-Z0-9/]))", " [url=http://\\1]\\1[/url]",$value);
			$value = eregi_replace("^(http://(([A-Za-z0-9~&=;\?%_.#/\-])*)([a-zA-Z0-9/]))", " [url=\\1]\\1[/url]",$value);
	
			$value = eregi_replace("(\[url=)([A-Za-z0-9_~&=;\?:%@#./\-]+[A-Za-z0-9/])(\])", "<a href=\"\\2\" target=_blank>",$value);
			$value = eregi_replace("(\[/url\])", "</a>",$value);
			
			echo "$value<br>";
		}
	}    
	echo "<P>";
	@GetSig($author);
	echo "</DIV></TD></TR></TABLE><P>";
	unset($tsmilies);

}

echo "<TABLE BORDER=0 CELLSPACING=0 CELLPADDING=0 WIDTH=700><TR><TD ALIGN=RIGHT><A HREF=reply.php?TopicID=$TopicID><IMG SRC=settings/buttons/reply.jpg WIDTH=80 HEIGHT=15 BORDER=0> <A HREF=index.php><IMG SRC=settings/buttons/index.jpg WIDTH=80 HEIGHT=15 BORDER=0></A></TD></TR></TABLE><P>";

}

?>

<? include("settings/footer.php"); ?>
