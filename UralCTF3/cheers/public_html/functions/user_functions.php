<?php
include_once './functions/db_functions.php';

function parse_username($username) {
    if (!isset($username)) return "";
     
    return db_escape($username);
}

function parse_userpass($userpass) {
    if (!isset($userpass)) return $userpass;
    
    return db_escape($userpass);
}

function parse_userteam($userteam) {
    if (!isset($userteam)) return $userteam; 
    
    return db_escape($userteam);
}

function parse_id($userid) {
    if (!isset($userid)) return $userid;
    
    return db_escape($userid);
}

function parse_subject($subject) {
    if (!isset($subject)) return "";
     
    return db_escape($subject);
}

function parse_content($content) {
    if (!isset($content)) return "";
     
    return db_escape($content);
}

function parse_level($level) {
    if (($level==0)||($level==2)||($level==1)) return true;

    return $false;
}

function userpass_match($username, $userpass) {
    $pass = db_getpass($username);

    if ($pass&&$pass==md5($userpass)) return true;
    
    return false;
}

function change_password($username, $userpass) {
    return db_changepass($username, md5($userpass));
}

function change_favteam($username, $userteam) {
    return db_changeteam(db_getuser($username), $userteam);
}

function user_exists($username) {
    return $user = db_getuser($username);
}

function adduser($username, $userpass) {
	return db_adduser($username, md5($userpass),1);
}

function can_favteam($username) {
	$mesg=db_getlmesg(db_getuser($username));
	return $mesg>10;
}

function getfavteam($username) {
	return db_getfavteam(db_getuser($username));
}
?>