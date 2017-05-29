<?php
include_once './functions/disp_functions.php';
include_once './functions/user_functions.php';
include 'header.php';

$author=$_SESSION['user'];

if (!($content=parse_content($_POST['rcont'])))			dispError("Couldn't reply: Bad subject.");
elseif (!($id=parse_id($_GET['id'])))				dispError("Couldn't reply: Bad id.");
elseif (!db_addmessage($id,db_getuser($author),$content))	dispError("You cannot reply anything.");
else dispEvent('Your reply has been added to discussion successfully! <a href="index.php?goto=topic&id='.$id.'">Check it!</a>');

include 'footer.php';
?>