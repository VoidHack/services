<?

// Set the default mode to index if it isn't set
if (!isset($mode))
{
	$mode = 'index';
}

switch($mode) {

	case 'index':
	session_start();
	if (session_is_registered("status") && $status == "1")
	{
		header("Location: index.php");
		exit;
	}
	else
	{
		require_once("settings/header.php");
		echo "<P>&nbsp;</P><P>&nbsp;</P><P>&nbsp;</P>";
		echo "<TABLE CELLSPACING=0 BORDER=0 CELLPADDING=0>";
		echo "<TR><TD COLSPAN=2 CLASS=header>&nbsp;&nbsp;&nbsp;Forum Login</TD></TR>";
		echo "<TR CLASS=Alt1>";
		echo "<TD WIDTH=80>";
		echo "<FORM ACTION=$PHP_SELF?mode=dologin METHOD=post>";
		echo "&nbsp;&nbsp;&nbsp;Username:</TD>"; 
		echo "<TD><INPUT TYPE=text NAME=uname WIDTH=30>&nbsp;&nbsp;&nbsp;</TD>";
		echo "</TR><TR CLASS=Alt1>";
		echo "<TD WIDTH=80>&nbsp;&nbsp;&nbsp;Password:</TD>"; 
		echo "<TD><INPUT TYPE=password NAME=passwd WIDTH=30>&nbsp;&nbsp;&nbsp;</TD>";
		echo "</TR><TR CLASS=Alt1>";
		echo "<TD COLSPAN=2><DIV ALIGN=RIGHT><INPUT TYPE=submit NAME=Login VALUE=Login>&nbsp;&nbsp;&nbsp;</DIV></TD>";
		echo "</TR>";
		echo "</TABLE><P>&nbsp;</P>";
		include("settings/footer.php");
	}
	break;

	case 'dologin':

	$passwd = md5($passwd);

	require_once("settings/theme.php");

	$entries=opendir("$userdir");
	
	// Load user files into an array
	$files = array();
	while ($file = readdir($entries))
	{
		if ($file != "." && $file != "..")
		{
			$files[] = $file;
		}
	}

	for (reset ($files); list ($key, $value) = each ($files); )
	{
		$ruser = file("$userdir/$value");
		$ufile = "$userdir/$value";
		for (reset ($ruser); list ($key, $value) = each ($ruser); )
		{
			if ($key == "0")
			{ /* username:password */
				list ($user, $pass) = explode(':', $value);
				$pass = chop($pass);

				if (($user == "$uname") && ($pass == "$passwd"))
				{	
					$fp = fopen($ufile, "r");
					$file_contents = fread($fp, filesize($ufile));
					fclose($fp);
					
					$line = explode("\n", $file_contents);
	  				
					$email = $line[1];
					
					srand((double)microtime()*1000000); 
					
					session_start();
					
					session_register("unique_str");
						$unique_str = md5(rand(1,999)); 
					
					if (chop($line[5]) == 'admin')
					{
						session_register("admin");
							$admin = "$unique_str";
					}
					
					else
					{
						session_register("user");
							$user = "#unique_str";
					}
					
					session_register("username");
						$username = $uname;
					
					session_register("usermail");
						$usermail = $email;
					
					session_register("status");
						$status = "1";
					
					header("Location: index.php");
					
					exit;
				}
			}
		}
	}
	closedir($entries);
//	header("Location: $PHP_SELF?mode=index");

	break;
}

?>