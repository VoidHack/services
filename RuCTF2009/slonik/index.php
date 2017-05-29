<?php

$dbname = "00.swf";

$db = sqlite3_open($dbname) or die("Cannot select the database: ".$sqliteerror);

$query = "select file from banners where shows>0;";
$result = sqlite3_query($db, $query) or die("Cannot perform query: ".$query.sqlite3_error($db)); 

$rows = array();
while ($r = sqlite3_fetch($result)) {$rows[] = $r;}

$flag = array_rand($rows);
$flag = $rows[$flag][0];

$query = "update banners set shows=shows-1 where file='".$flag."' and shows<>999999;";
sqlite3_exec($db, $query);
@sqlite3_close($db);

header("HTTP/1.1 301 Moved permanently");
header("Location: ".$flag.".swf");

?>
