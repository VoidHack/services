<?php
include_once './functions/db_functions.php';

$link = mysql_connect(SQL_HOST, SQL_USER, SQL_PASS)
        or die("Could not connect: " . mysql_error());
print ("Connected successfully\n<br>");

db_dropDB();
db_createDB();

db_createTable_teams();
$teams=array(
		"North Carolina Central",
		"Santa Ana Vikings",
		"USS Reuben",
		"SongGirls",
		"Georgia All Stars"
		);

foreach ($teams as $t) db_addteam($t);

db_createTable_users();
$users=array(
		"Administrator" => md5("administrator"),
		"Admin" => md5("admin"),
		"Captain" => md5("hca"),
		"Jackie" => md5("jackrabbit"),
		"Director" => md5("hack")
		);

foreach ($users as $su => $pass) db_adduser($su,$pass,0);

$users=array(
		"Champ" => md5("champ"),
		"Stuntman" => md5("mike"),
		"Cheerleader" => md5("cheer"),
		"Mike" => md5("pass"),
		"Stefani" => md5("pass")
		);

foreach ($users as $u => $pass) db_adduser($u,$pass,1);

db_createTable_topics();
db_createTable_messages();

db_addtopic("The 2007 Cheerleading & Dance Worlds",1,0,"Dates Prelims: Saturday, April 21, 2007. Finals:  Sunday, April 22, 2007. Location: Walt Disney World Resort®, Orlando, Florida, USA. Have fun! :)");
db_addtopic("November - 22th Basic Skills Course", 4,1,"It's Level2 course, and Crewe will be all over it :-P");
db_addtopic("Looking for a team?",8,2,"Join SongGirls, we worth it!");
db_addtopic("Shedule changes",10,1,"Our cap'n said we need more trainings, so shall we set up a friday workout?");

db_addmessage(4,6,"Oh no, not friday! x_X");

db_close($link);
?>