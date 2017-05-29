<?

function FindInArray($array,$searchvalue) {
  for ($i = 0; $i < count($array); $i++) {
    if (stristr($array[$i],$searchvalue)) return true;
  }
  return false;
}

function GetUserName($username) {
  global $userdir;
  if (!file_exists("$userdir/$username")) {
  echo "(undefined)";
  }
  else {
    $files = array();           
    $user = file("$userdir/$username");
    $user[] = $value;
    for (reset ($user); list ($key, $value) = each ($user);) {
      if ($key == "0") { /* User Name */
        $split = explode(":", $value);
        return("$split[0]");
      }
    }
  }
}

function GetPass($username)
{
	global $userdir;
	$ruser = file("$userdir/$username");
	$ufile = "$userdir/$username";
	for (reset ($ruser); list ($key, $value) = each ($ruser); )
	{
		if ($key == "0")         /* username:password */
		{
			list ($user, $pass) = explode(':', $value);
			$pass = chop($pass);
		}
	}
	return $pass;
}

function GetUserEmail($username) {
  global $userdir;
  if (!file_exists("$userdir/$username")) {
  echo "(undefined)";
  }
  else {
    $files = array();           
    $user = file("$userdir/$username");
    $user[] = $value;
    for (reset ($user); list ($key, $value) = each ($user);) {
      if ($key == "1") { /* User Email */
        return("$value");
      }
    }
  }
}

function GetURL($username) {
  global $userdir;
  if (!file_exists("$userdir/$username")) {
  echo "(undefined)";
  }
  else {
    $files = array();           
    $user = file("$userdir/$username");
    $user[] = $value;
    for (reset ($user); list ($key, $value) = each ($user);) {
      if ($key == "2") { /* User URL */
        return("$value");
      }
    }
  }
}

function GetICQ($username) {
  global $userdir;
  if (!file_exists("$userdir/$username")) {
  echo "(undefined)";
  }
  else {
    $files = array();           
    $user = file("$userdir/$username");
    $user[] = $value;
    for (reset ($user); list ($key, $value) = each ($user);) {
      if ($key == "3") { /* User ICQ */
        return("$value");
      }
    }
  }
}

function GetAdminStatus($username) {
  global $userdir;
  if (!file_exists("$userdir/$username")) {
  echo "(undefined)";
  }
  else {
    $files = array();           
    $user = file("$userdir/$username");
    $user[] = $value;
    for (reset ($user); list ($key, $value) = each ($user);) {
      if ($key == "5") { /* User Email */
        return("$value");
      }
    }
  }
}

function GetMageGlyph($username) {
  global $userdir;
  $files = array();           
  $user = @file("$userdir/$username");
  $user[] = $value;
  for (reset ($user); list ($key, $value) = each ($user);) {
    if ($key == "4") { /* User Glyph */
      $value = chop($value);
      if ($value != "") {
        echo "<IMG SRC=$value WIDTH=60 HEIGHT=60><P>";
      }
    }
  }
}

function GetMageGlyph2($username) {
  global $userdir;
  $files = array();           
  $user = file("$userdir/$username");
  $user[] = $value;
  for (reset ($user); list ($key, $value) = each ($user);) {
    if ($key == "4") { /* User Glyph */
      $value = chop($value);
      if ($value != "") {
        return($value);
      }
    }
  }
}


function GetSig($username) {
  global $userdir, $admin, $user;
  if (!file_exists("$userdir/$username")) {
  echo "(undefined)";
  }
  else {
    $files = array();           
    $user = file("$userdir/$username");
    $user[] = $value;
    for (reset ($user); list ($key, $value) = each ($user);) {
      if ($key >= "6") { /* User Bio */
        echo "$value<BR>";
      }
    }
  }
}

function GetSig2($username) {
  global $userdir, $admin, $user;
  if (!file_exists("$userdir/$username")) {
  echo "(undefined)";
  }
  else {
    $files = array();           
    $user = file("$userdir/$username");
    $user[] = $value;
    for (reset ($user); list ($key, $value) = each ($user);) {
      if ($key >= "6") { /* User Bio */
        echo $value;
      }
    }
  }
}


function GetUserBio($username) {
  global $userdir, $biodir;
  if (!file_exists("$biodir/$username")) {
  echo "";
  }
  else {
    $tsig = array();           
    $user = file("$biodir/$username");
    $user[] = $value;
    for (reset ($user); list ($key, $value) = each ($user);) {
      if ($key <= count($user)) { 
        echo "$value<BR>";
      }
    }
  }
}

function GetUserBio2($username) {
  global $userdir, $biodir;
  if (!file_exists("$biodir/$username")) {
  echo "";
  }
  else {
    $tsig = array();           
    $user = file("$biodir/$username");
    $user[] = $value;
    for (reset ($user); list ($key, $value) = each ($user);) {
      if ($key <= count($user)) { 
        echo "$value";
      }
    }
  }
}
global $userdir;
$usrcount=opendir("$userdir");
// Load files into an array
$files = array();
while ($file = readdir($usrcount)) {
  if ($file != "." && $file != "..") {
    $files[] = $file;
  }
}

$registered = count($files);
global $postdir;
$postcount2=opendir("$postdir");
// Load files into an array
$files2 = array();
$files3 = array();
while ($file2 = readdir($postcount2)) {
  if ($file2 != "." && $file2 != "..") {
    $files2[] = $file2;
    if (strstr($file2, '-') == false) {
      $files3[] = $file2;
    }
  }
}

$posts = count($files2);
$totalthreads = count($files3);

?>
