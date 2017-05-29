<?php
include_once './functions/user_functions.php';
include_once './functions/disp_functions.php';
include 'header.php';

if (!($username=parse_username($_POST['user'])))	{dispError("Couldn't choose fav team: Bad username");}
elseif (!($userteam=parse_userteam($_POST['tfav'])))	{dispError("Couldn't choose fav team: Bad userpass");}
elseif (!change_favteam($username,$userteam))		{dispError("Could not choose favourite team.");}
else
{
	dispEvent("You have choosed favourite team successfully!");
}
include 'footer.php';
?>