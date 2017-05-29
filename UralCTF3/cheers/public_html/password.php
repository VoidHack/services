<?php
include_once './functions/user_functions.php';
include_once './functions/disp_functions.php';
include 'header.php';

if (!($username=parse_username($_POST['user'])))	dispError("Could not change password: bad username.");
elseif (!($userpass=parse_userpass($_POST['paswd'])))	dispError("Could not change password: bad password.");
elseif (!change_password($username,$userpass))		dispError("Could not change password.");
else dispEvent("You have changed password successfully!");
include 'footer.php';
?>