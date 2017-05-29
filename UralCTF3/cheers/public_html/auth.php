<?php
include_once './functions/user_functions.php';
include_once './functions/disp_functions.php';

if (!($username=parse_username($_POST['username'])))	{include 'header.php';dispError("Couldn't authorize: Bad username.");}
elseif (!($userpass=parse_userpass($_POST['userpass'])))	{include 'header.php';dispError("Couldn't authorize: Bad userpass.");}
elseif (!userpass_match($username,$userpass))		{include 'header.php';dispError("Couldn't authorize: username and password do not match.");}
else
{
	session_start();
	$old_sessionid = session_id();
	session_regenerate_id();
	$_SESSION['user']=$username;
	$_SESSION['level']=db_getlevel($username);

	$new_sessionid = session_id();
	include 'header.php';

	dispEvent("You have been authorized successfully!");
}
include 'footer.php';
?>