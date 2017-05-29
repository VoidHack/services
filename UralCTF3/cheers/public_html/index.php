<?php
/*HAVE A NICE DAY! :)*/

include_once 'header.php';
include_once './functions/disp_functions.php';

$goto=$_GET['goto'];

if (isset($goto))
{
    if ($goto == 'teams')		dispTeams();
    elseif ($goto == 'discussion')	dispDiscuss();
    elseif ($goto == 'topic')	dispTopic($_GET['id']);   
    elseif ($goto == 'newdiscuss')	dispNewDiscuss(); 
    elseif ($goto == 'register')	dispRegister();
    elseif ($goto == 'login')	dispLogin();
    elseif ($goto == 'logout')	dispLogout();
    elseif ($goto == 'profile')	dispProfile();
    else	    			dispError("error");

	include 'footer.php'; exit();
}

dispMain();
include 'footer.php';
?>