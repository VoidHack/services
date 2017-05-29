<?php
define("SQL_USER", "root");
define("SQL_PASS", "");
define("SQL_GUEST", "guest");
define("SQL_HOST", "localhost");
define("SQL_DB", "cheers");
define("SQL_TEAMS", "teams");
define("SQL_USERS", "users");
define("SQL_TOPICS", "topics");
define("SQL_MESSAGES", "messages");

function db_connect() {
	$link = mysql_connect(SQL_HOST, SQL_USER, SQL_PASS) or die("Could not connect: " . mysql_error());
	mysql_query("use ".SQL_DB);

	return $link;
}

function db_escape($string) {
	return mysql_escape_string($string);
}

function db_fetch_array($result) {
	return mysql_fetch_array($result);
}

function db_close($link) {
	if ($link) mysql_close($link);
	return;
}

function db_dropDB() {
	if (!db_connect()) return NULL;
	return mysql_query("drop database ".SQL_DB.";");
}

function db_createDB() {
	if (!db_connect()) return NULL;
	return mysql_query("CREATE database ".SQL_DB.";");
}

function db_createTable_teams() {
	if (!db_connect()) return false;
	
	$query="CREATE TABLE ".SQL_TEAMS." (
		Id int			NOT NULL PRIMARY KEY  AUTO_INCREMENT,
		Name varchar(50)	NOT NULL,

		CONSTRAINT teamsNamesAreUnique UNIQUE(Name)
		);";
	
	if (!mysql_query($query)) {printf ("Error creating teams: %s\n", mysql_error());  exit(1);}

}

function db_createTable_users() {
	if (!db_connect()) return false;
	
	$query="CREATE TABLE ".SQL_USERS." (
		Id	int		NOT NULL PRIMARY KEY AUTO_INCREMENT,
		Name	varchar(50)	NOT NULL,
		Pass	varchar(32)	NOT NULL,
		Level	int		,
		Fav	int		,

		CONSTRAINT usersNamesAreUnique UNIQUE(Name)

		) ENGINE=InnoDB;";
	
	if (!mysql_query($query)) {printf ("Error creating users: %s\n", mysql_error());  exit(1);}
}

function db_createTable_topics() {
	if (!db_connect()) return false;
	
	$query="CREATE TABLE ".SQL_TOPICS." (
		Id		int		NOT NULL PRIMARY KEY AUTO_INCREMENT,
		Subject	varchar(150)	NOT NULL,
		Author		int		NOT NULL, 
		Level		int		,
		
		INDEX( Author ),
		CONSTRAINT Author_ReferencesUsername
			FOREIGN KEY (Author) REFERENCES ".SQL_USERS."(Id)
		) ENGINE=InnoDB;";

	if (!mysql_query($query)) {printf ("Error creating topics: %s\n", mysql_error());  exit(1);}
}

function db_createTable_messages() {
	if (!db_connect()) return false;
	
	$query="CREATE TABLE ".SQL_MESSAGES." (
		Id		int	NOT NULL PRIMARY KEY AUTO_INCREMENT,
		Topic		int	NOT NULL,
		Author		int	NOT NULL, 
		Content	blob	,

		INDEX( Topic ),
		CONSTRAINT Topic_ReferencesTopic
			FOREIGN KEY (Topic) REFERENCES ".SQL_TOPICS."(Id)
		) ENGINE=InnoDB;";

	if (!mysql_query($query)) {printf ("Error creating topics: %s\n", mysql_error());  exit(1);}
}

function db_getpass($username) {
	if (!$username) return NULL;
	if (!$link=db_connect()) return NULL;

	$query = "SELECT Pass FROM ".SQL_USERS." WHERE Name=\"$username\";";
	$result = mysql_query($query);

	if (!mysql_affected_rows($link)) return NULL;

	return mysql_result($result,0);

}

function db_getlevel($username) {
	if (!$username) return 2;
	if (!$link=db_connect()) return 2;

	$query = "SELECT Level FROM ".SQL_USERS." WHERE Name=\"$username\";";
	$result = mysql_query($query);

	if (!mysql_affected_rows($link)) return 2;

	return mysql_result($result,0);

}

function db_getlmesg($user) {
	if (!$user)return NULL;
	if (!$link=db_connect()) return NULL;
	
	$query = "SELECT Id FROM ".SQL_MESSAGES." WHERE Author=$user;";
	if (!mysql_query($query)) return NULL;

	return mysql_affected_rows($link);	
}

function db_getfavteam($user) {
	if (!$user)return NULL;
	if (!$link=db_connect()) return NULL;

	$query="SELECT Fav FROM ".SQL_USERS." WHERE Id=$user;";
	$result = mysql_query($query);

	if (!$result=mysql_result($result,0)) return NULL;

	$query="SELECT Name FROM ".SQL_TEAMS." WHERE Id=$result;";
	$result = mysql_query($query);

	return $result=mysql_result($result,0);
}

function db_getuser($username) {
	if (!$username) return NULL;
	if (!$link=db_connect()) return NULL;

	$query = "SELECT Id FROM ".SQL_USERS." WHERE Name=\"$username\";";
	$result = mysql_query($query);

	if (!mysql_affected_rows($link)) return NULL;

	return mysql_result($result,0);
}

function db_getteamschunk() {
	if (!db_connect()) return NULL;
	return mysql_query("SELECT * FROM ".SQL_TEAMS.";");
}

function db_gettopicschunk() {
	if (!db_connect()) return NULL;
	return mysql_query("SELECT t1.Id, Subject, Name FROM ".SQL_TOPICS." t1, ".SQL_USERS." t2 WHERE t2.Id=Author AND t1.Level>=".$_SESSION['level'].";");
}

function db_getmesgchunk($id) {
	if (!$id) return NULL;

	if (!db_connect()) return NULL;
	return mysql_query("SELECT t3.Name, Content FROM ".SQL_TOPICS." t1, ".SQL_MESSAGES." t2, ".SQL_USERS." t3 WHERE t1.Id=t2.Topic AND t2.Author=t3.Id AND t1.Id= $id ORDER BY t2.Id ASC;");
}

function db_getusermesgchunk($id) {
	if (!$id) return NULL;

	if (!db_connect()) return NULL;
	return mysql_query("SELECT t1.Subject, Content FROM ".SQL_TOPICS." t1, ".SQL_MESSAGES." t2, ".SQL_USERS." t3 WHERE t1.Id=t2.Topic AND t2.Author=t3.Id AND t3.Id= $id");
}

function db_gettopic($id) {
	if (!$id) return NULL;

	if (!$link=db_connect()) return NULL;
	$result=mysql_query("SELECT Subject FROM ".SQL_TOPICS." WHERE Id=$id");
	
	if (!mysql_affected_rows($link)) return NULL;
	
	return mysql_result($result,0);
}

function db_addteam($teamname) {
	if (!$teamname) return NULL;

	if (!$link=db_connect()) return NULL;

	$query = "INSERT INTO ".SQL_TEAMS." (Name) VALUES (\"$teamname\");";
	return mysql_query($query);
}

function db_adduser($username,$userpass,$m) {
	if ((!$username)||(!$userpass)) return NULL;

	if(!$link=db_connect()) return NULL;

	$m= (int)$m>=2? 1:$m;

	$query = "INSERT INTO ".SQL_USERS." (Name,Pass,Level) VALUES (\"$username\", \"$userpass\", $m);";
	return mysql_query($query);
}

function db_addtopic($subject,$author,$level,$content) {
	if ((!$subject)||(!$author)||(!$content)) return NULL;
	$level%=3;

	if (!$link=db_connect()) return false;

	$query = "INSERT INTO ".SQL_TOPICS." (Subject,Author,Level) VALUES (\"$subject\", $author, $level);";
	mysql_query($query);

	$query = "SELECT Id FROM ".SQL_TOPICS." WHERE Subject= \"$subject\";";

	$result = mysql_query($query);
	
	$topic=mysql_result($result,0);

	if (!db_addmessage($topic,$author,$content)) return false;
	
	return true;
}

function db_addmessage($topic,$author,$content) {
	if ((!$topic)||(!$author)||(!$content)) return false;

	if (!$link=db_connect()) return false;
	
	$query = "INSERT INTO ".SQL_MESSAGES." (Topic,Author,Content) VALUES ($topic, $author, \"$content\")";
	mysql_query($query);

	return true;
}

function db_changepass($user,$pass) {
	if ((!$user)||(!$pass)) return NULL;

	if (!$link=db_connect()) return NULL;

	$query = "UPDATE ".SQL_USERS." SET Pass=\"$pass\" WHERE Name= \"$user\";";
	return mysql_query($query);
}

function db_changeteam($user,$team) {
	if ((!$user)||(!$team)) return NULL;
	if (!$link=db_connect()) return NULL;

	$query = "UPDATE ".SQL_USERS." SET Fav=\"$team\" WHERE Id= \"$user\";";

	return mysql_query($query);
}
?>