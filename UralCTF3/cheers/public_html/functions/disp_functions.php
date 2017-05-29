<?php
include_once './functions/db_functions.php';
include_once './functions/user_functions.php';

function dispMain() {
	include 'main.html';
	return ;
}

function dispTeams() {
	include 'teams.html';
	return ;
}

function dispDiscuss() {
	$result=db_gettopicschunk();
	if (!$result) dispError("Couldn't get discussions.");
?>
	<div id='viewDiv'>
		<h1>Discussions on Cheerleading</h1>
		<p>
That's right, we've recently made up a discussion board to reflect the changes in cheerleading.  Cheerleading has become more athletic, more powerful and dynamic. Cheerleading has increasingly become a larger influence in the media today. The individual cheerleader is an instantly recognized figure representing youthful attractiveness and leadership. It's popular and it's hot.  It's not only about competiting. It's about living. <strong>So speak up and cheerlead!</strong> 
		</p>
		<h2>Latest discussions</h2>
<?php
	if ($_SESSION['level']<2)
	{
?>
		<p><a href="index.php?goto=newdiscuss">Start new discussion</a></p>
<?php
	}

	$row =  db_fetch_array($result);
	if (!$row) echo "<p>No discussions to join.</p>";

	while ($row)
	{
		$id=$row[0];
		$subject=$row[1];
		$author=$row[2];

?>
		<div class='topicDiv'>
			<a href='index.php?goto=topic&id=<?php echo $id ?>'><?php echo $subject ?></a>
			<span>(by <?php echo $author ?>)</span>
		</div>
<?php
	    $row = db_fetch_array($result);
	}
?>
	</div>
	</div>
<?php
    return ;
}

function dispTopic($id) {
	$topic=db_gettopic($id);
	
	if (!$topic) {dispError("No such topic."); exit(1);}
?>
	<div id='viewDiv'>
		<h1><?php echo $topic ?></h1>
<?php
	$result = db_getmesgchunk($id);
	if (!$result) dispError("Couldn't show discussions.");

	while ($row = db_fetch_array($result))
	{
		$author=$row[0];
		$content=$row[1];	
?>
		<div class='replyDiv'>
			<strong><?php echo $author ?>:</strong><br>
			<p><?php echo $content ?></p>
		</div>
<?php
	}
	dispNewReply($id);
?>
	</div>
<?php	
    return ;
}

function dispNewReply($id) {
?>
	<h2>Add a new comment</h2>
	<div class='formMesgDiv'>
    <form id='newDiscussReplyForm' action='reply.php?id=<?php echo $id ?>' method="post">
	<label for='rcont'>Content:</label><br>
	<textarea name='rcont' rows='5' cols='40'></textarea><br>
	<input type='submit' value='Comment'>	    
    </form>
	</div>
<?php	
	return;
}

function dispNewDiscuss() {
?>
<div id='viewDiv'>
	<h1>Add a new Discussion</h1>
	<p>Fill in the form to launch a new discussion on cheerleading.</p>
	<div class='formMesgDiv'>
    <form id='newDiscussReplyForm' action='discuss.php' method="post">
	<label for='dsubj'>Subject:</label><br>
	<input type='text' name='dsubj' size='54'><br>
	<label for='dcont'>Content:</label><br>
	<textarea name='dcont' rows='5' cols='40'></textarea><br>
	<label for='dlevel'>Show to:</label><br>
	<input type="radio" name="dlevel" value="2" checked="checked"><label for='dlevel'>everyone</label><br>
<?php
	if ($_SESSION['level']<=1)
	{
?>
	<input type="radio" name="dlevel" value="1"><label for='dlevel'>registered users only</label><br>
<?php
	if ($_SESSION['level']<=0)
	{
?>
	<input type="radio" name="dlevel" value="0"><label for='dlevel'>superusers only</label><br>
<?php
	}}
?>
	<input type='submit' value='Discuss'>	    
    </form>
	</div>
</div>
<?php	
	return;
}

function dispProfile() {
    if ($_SESSION['level']>=2) {dispError("You don't have a profile."); return;}

?>
	<div id='viewDiv'>
		<h1>Profile for <?php echo $user=$_SESSION['user']?> </h1>
		<h2>Settings</h2>
		<div class='settingsDiv'>
			<h3>Password</h3>
			<div class='formUserDiv'>
				<form id='accPasswordForm' action='password.php' method='post'>
					<label for='paswd'>Change pass:</label>
					<input type="text" name='paswd' size='25'>
					<input type='hidden' name='user' value='<?php echo $user?>'>
					<input type='submit' value='Change'>
				</form>
			</div>
			<h3>Favourite team</h3>
<?php
if (!can_favteam($user)) echo "Feature is not enabled yet. Sorry :(";
else
{
	if ($team=getfavteam($user))	{echo "Your favourite team is <strong>$team</strong><br>";}
	else
	{
		echo "You have no favourite team.<br>";

		$result=db_getteamschunk();
		if (($result)&&($row =  db_fetch_array($result)))
		{
?>
			<form id='accFavForm' action="favourite.php" method="post">
				<label for='tfav'>Change team:</label>
				<select name="tfav">
<?php
			while ($row)
			{
				$id=$row[0];
				$name=$row[1];
?>
					<option value='<?php echo $id?>'label="<?php echo $name?>" selected="selected"><?php echo $name?></option>
<?php
	    			$row = db_fetch_array($result);
			}		
?>
				</select>
				<input type='submit' value='Choose'>
				<input type='hidden' name = 'user'value='<?php echo $user?>'>
			</form>
<?php
		}
	}
}
?>
		</div>
		<h2>Messages you posted</h2>
<?php
	$result = db_getusermesgchunk(db_getuser($user));
	if (!result) dispError("Couldn't get messages for that user.");

	$row =  db_fetch_array($result);
	if (!$row) echo "<p>You didn't post anything.</p>";

	while ($row)
	{
		$topic=$row[0];
		$content=$row[1];
		$row = db_fetch_array($result)
?>
		<div class='replyDiv'>
			<strong><?php echo $topic ?> discussion:</strong><br>
			<p><?php echo $content ?></p>
		</div>

<?php
	}
?>
	</div>
<?php
    return true;
}

function dispRegister() {
?>
<div id='viewDiv'>
	<h1>Registration page</h1>
	<p>Enter desirable account login and password to sign into Association Database.</p>
	<div class='formUserDiv'>
    <form id='accLoginRegisterForm' action='register.php' method="post">
	<label for='username'>Login:</label>
	<input type='text' name='username' size='25'><br>
	<label for='userpass'>Password:</label>
	<input type='text' name='userpass' size='25'><br>
	<input type='submit' value='Register'>	    
    </form>
	</div>
</div>
<?php
    return ;
}

function dispLogin() {
?>
<div id='viewDiv'>
	<h1>Authorization page</h1>
	<p>Enter your account login and password to sign in.</p>
	<div class='formUserDiv'>
    <form id='accLoginRegisterForm' action='auth.php' method="post">
	<label for='username'>Login:</label><br>
	<input type='text' name='username' size='25'><br>
	<label for='userpass'>Password:</label><br>
	<input type='text' name='userpass' size='25'><br>
	<input type='submit' value='Login'>	    
    </form>
	</div>
</div>
<?php	
    return ;
}

function dispLogout() {
    $_SESSION['user']=NULL;
    $_SESSION['level']=2;
    dispEvent("You have successfully logged out!");
    return ;
}

function dispEvent($event) {
    echo "<div id='viewDiv'>".$event."</div>";
    return ;
}

function dispError($mesg) {
    dispEvent("<strong>Error occured:</strong> ".$mesg);
    return ;
}
?>