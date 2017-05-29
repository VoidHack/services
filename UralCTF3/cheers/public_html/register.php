<?php
include_once './functions/user_functions.php';
include_once './functions/disp_functions.php';
include 'header.php';

if (!($username=parse_username($_POST['username'])))		dispError("Couldn't register user: Bad username.");
elseif (!($userpass=parse_userpass($_POST['userpass'])))	dispError("Couldn't register user: Bad userpass.");
elseif (user_exists($username))					dispError("Couldn't register user: Such user already exists!");
else
{
	if (adduser($username,$userpass))	dispEvent("You have been registered successfully!");
	else dispError("Couldn't register user.");
}
include 'footer.php';
?>