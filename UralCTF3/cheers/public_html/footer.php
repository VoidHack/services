   <div id='navMain'>
	<div id='accManage'>
<?php
if (isset($_SESSION['user']))	echo 'Hello, <strong>'.$_SESSION['user'].'</strong>.<br><a href="index.php?goto=profile">Profile</a>';
//else					echo 'Welcome, <strong>guest</strong>!<br>';
?>
	<a href='index.php?goto=login'>Login</a>
	<a href='index.php?goto=logout'>Logout</a><br>
	<span>Not registered yet?</span>
	<a href='index.php?goto=register'>Register</a>
	</div>

       <a href='index.php'>Main</a><br>
	<a href='index.php?goto=teams'>Teams</a><br>
	<a href='index.php?goto=discussion'>Discussion</a><br>
    </div>

</body>
</html>