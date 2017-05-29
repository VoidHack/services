<HEAD>
<TITLE>DamnVulnerableForum</TITLE>
<? include("settings/style.php"); ?>
</HEAD>

<script language="javascript" type="text/javascript">
var win = null;
function NewWindow(mypage,myname,w,h,scroll){
LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
settings =
'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',scrollbars='+scroll+',resizable'
win = window.open(mypage,myname,settings)
if(win.window.focus){win.window.focus();}
}
</script>

<BODY BGCOLOR=<? echo $BGColor; ?>>
<? include("settings/functions.php"); ?>

<DIV ALIGN=CENTER>

<DIV CLASS=headline2><? echo $ForumTitle; ?></DIV>
