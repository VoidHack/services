<?php
include_once './functions/disp_functions.php';
include_once './functions/user_functions.php';
include 'header.php';

$author=$_SESSION['user'];
if (!($subject=parse_subject($_POST['dsubj'])))		{dispError("Couldn't start discussion: Bad subject.");}
elseif (!($content=parse_content($_POST['dcont'])))	{dispError("Couldn't start discussion: Bad content.");}
elseif (!($level=parse_level($_POST['dlevel'])))	{dispError("Couldn't start discussion: Bad level.");}
elseif (!db_addtopic($subject,db_getuser($author),$level,$content))	{dispError("You cannot post anything.");}
else dispEvent("You have started a new discussion!");

include 'footer.php';
?>