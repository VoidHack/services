#!/usr/bin/perl
BEGIN{print "Server initialization...\n";}
use constant PORT=>10555;use constant TIMEDELTA=>70;
use threads;
use threads::shared;
my @houses;
share(@main::houses);
%dict=('contact'=>{'en'=>"Everything about us is said by our houses:",'ru'=>"За нас говорят наши дома:"},'take'=>{'en'=>"Take the house",'ru'=>"Забрать дом"},'taken'=>{'en'=>"House is cut from registry",'ru'=>"Дом выписан из реестра"},'nodesign'=>{'en'=>"Your house's design cannot be prepared",'ru'=>"Чертеж вашего дома не возможно построить"},'design'=>{'en'=>"Your house's design is prepared:",'ru'=>"Чертеж вашего дома подготовлен:"},'designcheck'=>{'en'=>"If you already have a house, you may order it's design",'ru'=>"Если у вас уже есть дом, вы можете заказать его чертеж"},'menu_main'=>{'en'=>"Home",'ru'=>"Главная"},'menu_contact'=>{'en'=>"Contacts",'ru'=>"Контакты"},'order'=>{'en'=>"Order",'ru'=>"Заказать"},'designoffer'=>{'en'=>"If you want to order a house, send us your desired design",'ru'=>"Если вы хотите заказать дом, пришлите нам ваш чертеж с желаемым домом"},'houseoffer'=>{'en'=>"If you have already order a house, type in your order ID to get it",'ru'=>"Если вы уже заказали дом, введите свой ID заказа, чтобы получить его"},'get'=>{'en'=>"Get house",'ru'=>"Получить дом"},'ordered'=>{'en'=>"Your design is accepted. Your can receive your house by ID:",'ru'=>"Ваш чертеж принят. Вы можете получить свой дом по ID:"},'noorder'=>{'en'=>"Order system failed to operate your design",'ru'=>"Система заказа не смогла обработать ваш чертеж"},'nohouse'=>{'en'=>"Such a house was never ordered or already bought",'ru'=>"Такой дом никогда не заказывали или уже выкупили"},'waiting'=>{'en'=>"Thank you for waiting. Your house is ready",'ru'=>"Спасибо за ожидание. Ваш дом готов"},'notfound'=>{'en'=>"I don't known what you wanna get from me! Enjoy your 404",'ru'=>"Чего тебе надобно старче? Тут такого нет. Вот тебе 404"},'acronym'=>{'en'=>"RUCTFBC",'ru'=>"РУЦТФСК"},'title'=>{'en'=>"Regional Universal Centralized Territorially Fixed Building Company",'ru'=>"Региональная Универсальная Централизованная Территориально Фиксированная Строительная Компания"});
{package Core;
BEGIN{print "Core initiated\n";}
1;

package Core::Task;
use Digest::MD5 qw(md5_hex);
sub mindblower{my($v,$y,$line,$m,$m2)=@_;my @commands=('|','+','-',' ','[','=','_',']','*','^','~');my @opcommands=();for(my $i=0;$i<@commands;$i++){for(0..$i*2){push @opcommands,$commands[-$i-1];}};my $symbol=int(rand(scalar(@opcommands)));if($m){$symbol=1;if($m2){my %conv=('0'=>'_','1'=>'+','2'=>'++','3'=>'+++','4'=>'+[_','5'=>'+[_+','6'=>'+[--','7'=>'+[-','8'=>'+[','9'=>'+[+','A'=>'+[++','B'=>'+[+++','C'=>'-[+[','D'=>'--[__','E'=>'++[--','F'=>'++[-','G'=>'++[','H'=>'++[+','I'=>'++[++','J'=>'++[+++','K'=>'-[++[','L'=>'---[-_','M'=>'---[_','N'=>'+++[-','O'=>'+++[','P'=>'+++[+','Q'=>'--[_','R'=>'--[_+','S'=>'+[-[_','T'=>'-[-_','U'=>'-[_','V'=>'-_--','W'=>'-_-','X'=>'-_','Y'=>'-_+','Z'=>'-_++','a'=>'+[[[','b'=>'+[[[+','c'=>'+[[[++','d'=>'+[-[[-','e'=>'+[-[[','f'=>'+[-[[+','g'=>'---[--','h'=>'---[-','i'=>'---[','j'=>'---[+','k'=>'---[++','l'=>'+[--[-','m'=>'+[--[','n'=>'+[--[+','o'=>'--[--','p'=>'--[-','q'=>'--[','r'=>'--[+','s'=>'--[++','t'=>'+[-[-','u'=>'+[-[','v'=>'+[-[+','w'=>'-[--','x'=>'-[-','y'=>'-[','z'=>'-[+','+'=>'-[++','-'=>'+[[-','\\'=>'+[[','/'=>'---','='=>'--','_'=>'-');my $l=join('',@$line);my ($part)=($l=~/.*\^(.*)/);my($res,$s)=($conv{$alphabet[$v]},' ');if(length($part) < length($res)){$s=(split(//,$res))[length($part)];};for(0..$#opcommands){if($opcommands[$_] eq $s){$symbol=$_;}}};};return $opcommands[$symbol];}
sub Build{$design=shift;$house="";@alphabet=('0'..'9','A'..'Z','a'..'z','+','-','\\','/','=','_');$design=~s/\s+//g;my$n=int(rand(5));my($space,@v)=(' 'x$n);for(split(//,$design)){for(my $v=0;$v<@alphabet;$v++){push @v,$v if($_ eq $alphabet[$v]);}};my($width,$style,@line)=((int(rand(11))+5)*2+9,0);for(my $i=0;$i<@v;$i++){my $prev=$v[$i-1]||0;my $v=$v[$i];for(0..$width-1){$line[$i][$_]=($style && abs($_-int($width/2))>$i?' ':($_ && $_-$width+1?($i?($style && $_-int($width/2)==-$i?'/':($style && $_-int($width/2)==$i?'\\':mindblower($v[$i],$i,$line[$i],($_>$width-9?1:0),($_>$width-8?1:0)))):($style && $_-int($width/2)==$i?'^':mindblower($v[$i],$i,$line[$i],($_>$width-9?1:0),($_>$width-8?1:0)))):'|'));}};for my $l (@line){$house.=$space;for(@$l){$house.=$_;};$house.="\n";};return $house;}
sub Review{print "<b>Feature will be implemented in a year</b>";}
sub TotalRecheck{$time=0;for(reverse((localtime(time))[0..5])){$time=$time*60+$_;};$i=0;for(@main::houses){if($_->{created}+TIMEDELTA<=$time){$main::houses[$i]=threads::shared::shared_clone($_);$i++;}else{warn $_->{created}.'~'.$time.':'.$_->{id}.' -> '.$_->{house};}};if($i<@main::houses){delete $main::houses[$#main::houses];};}
sub SendHouse{$cgi=shift;return if !ref $cgi;$id=$cgi->param('designid');TotalRecheck();for(0..$#main::houses){if($main::houses[$_]->{id}=~/$id/){$cgi->param(-name=>'house',-value=>$main::houses[$_]->{house});last;};};}
sub CutHouse{$cgi=shift;return if !ref $cgi;$id=$cgi->param('designid');TotalRecheck();$i=0;for(0..$#main::houses){if($main::houses[$_]->{id}!~/$id/){$main::houses[$i]=threads::shared::shared_clone($main::houses[$_]);$i++};};if($i<@main::houses){delete $main::houses[$#main::houses];};}
sub ReceiveDesign{$cgi=shift;return if !ref $cgi;$design=$cgi->param('design');if($design=~/[=_a-zA-Z0-9\+\-\/\\]+/){$house=Build($design);$designid=md5_hex($design.$house.join('',localtime(time)));TotalRecheck();$time=0;for(reverse((localtime(time))[0..5])){$time=$time*60+$_;};$main::houses[@main::houses]=threads::shared::shared_clone({id=>$designid,house=>$house,created=>$time});$cgi->param(-name=>'designid',-value=>$designid);}}
BEGIN{print "Core::Task initiated\n";}
1;

package Core::Visual;
sub header{$title=shift;return <<HEAD;
	<head>
		<title>
			$title
		</title>
		<style>
			* {font-family:"Arial";font-size:12px;color:#00ff00;}
			.restyle * {font-family:"Arial";font-size:12px;color:#003300;}
			body{background-color:#000000;text-align:center;}
			body.restyle{background-color:#aaaaff;text-align:center;}
			.logo {font-size:24px;font-family:"Arial Black";}
			.companytitle {font-size:16px;}
			.restyle input,.restyle textarea,.restyle table,.restyle td {border:1px dashed #664400;border-spacing:0px;border-collapse:collapse;vertical-align:top;}
			div,input,textarea,table,tr,td {border:1px dashed #00ff00;border-spacing:0px;border-collapse:collapse;vertical-align:top;}
			table.frame {width:800px;}
			td.logo {width:50px;height:50px;}
			.restyle input,.restyle textarea{background-color:#aa8800;width:400px}
			input,textarea{background-color:#004400;width:400px}
			textarea{height:300px}
			.maintable{border:0px}
			.sky{height:100px;border:0px}
			.land{height:100px}
			.restyle .land{background-color:#66ff66}
			pre{font-family:"Courier New"}
			.restyle .sky pre{color:#ffdd00}
			.restyle pre{font-family:"Courier New"}
			.house * {height:100%;vertical-align:bottom}
		</style>
	</head>
HEAD
}
sub builds{my$n=int(rand(5))+2;my@h=();my$k=90;for(0..$n-2){my$l=int(rand($k));push@h,{w=>$l,h=>int(rand(400))+100};$k-=$l;};push@h,{w=>$k,h=>int(rand(400))+100};my$str='';for(@h){my $c=$_->{h}/20;my $c2=$_->{w}/20;my $row="<td>&nbsp;</td>"x$c2;my $win="			<tr>$row</tr>\n"x$c;$str.=<<DIV;
	<td class="maintable" style="vertical-align:bottom;height:100%">
	<div style="width:$_->{w}\%;height:$_->{h}px;display:inline">
		<table width="100%" class="house">
			$win
		</table>
	</div>
	</td>
DIV
};return <<TAB;
	<table width="100%" style="height:100%;vertical-align:bottom;border:0px">
		<tr class="maintable">
			$str
		</tr>
	</table>
TAB
}
sub menu{$lang=shift;$language=($lang eq "en"?"<a href=\"?lang=ru\">Русский</a>":"<a href=\"?lang=en\">English</a>");return <<MENU;
						<a href="/?lang=$lang">
							$main::dict{'menu_main'}->{$lang}
						</a>
						<br>
						<a href="/Contact?lang=$lang">
							$main::dict{'menu_contact'}->{$lang}
						</a>
						<br>
						|$language|
MENU
}
sub title{($lang,$count)=(shift,scalar(@main::houses));return <<TITLE;
				<tr>
					<td class="logo">
						$main::dict{'acronym'}->{$lang}
					</td>
					<td align="center">
						<span class="companytitle">$main::dict{'title'}->{$lang}</span><br><span style="color:#000000">$count</span>
					</td>
				</tr>
TITLE
}
sub footer{return <<FOOT;
				<tr>
					<td colspan="2" align="center">
						CopyLeft \&copy; 2009. <a href="/Pocket">Powered by PocketSite</a>
					</td>
				</tr>
FOOT
}
sub topleft{my$url=shift;my$rnd1=builds;return <<TOP;
			<table width="100%" class="maintable" style="height:100%" cellspacing="0" cellpadding="0">
				<tr class="maintable">
					<td colspan="3" class="sky">
						<pre alt="sun and cloud">
  ---    /        /  /###\\ -
\\       /----\\      /\\###/ -
 -------      ------  ---
                    /  |  \\
					 
						</pre>
					</td>
				</tr>
				<tr class="maintable">
					<td colspan="3" align="center" class="maintable">
						<object title="Баннерная сеть &quot;Слоник&quot;" width="120" height="90" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0">
							<param name="movie" value="http://$url:316/">
							<param name="allowScriptAccess" value="always">
							<param name="wmode" value="transparent">
							<embed title="Баннерная сеть &quot;Слоник&quot;" src="http://$url:316/" wmode="transparent" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="120" height="90" allowScriptAccess="always"></embed>
						</object>
					</td>
				</tr>
				<tr class="maintable">
					<td width="50%" class="maintable" valign="bottom">
						$rnd1
					</td>
					<td class="maintable">
TOP
}
sub bottomright{my$url=shift;my$rnd2=builds;return <<FOOT;
					</td>
					<td width="50%" class="maintable" valign="bottom">
						$rnd2
					</td>
				</tr>
				<tr class="maintable">
					<td colspan="3" class="land">
						&nbsp;
					</td>
				</tr>
			</table>
FOOT
}
sub CutHouse{$cgi=shift;$lang=$cgi->param('lang')||'ru';($header,$title,$menu)=(header($main::dict{'acronym'}->{$lang}.' - '.$main::dict{'title'}->{$lang}),title($lang),menu($lang));$url=$cgi->url();$url=~s/^http\:\/\/|[\/:].*$/$1/gsi;($topleft,$bottomright)=(topleft($url),bottomright($url));return if !ref $cgi;print <<PAGE;
<hmtl>
	$header
	<body>
		$topleft
			<table class="frame">
				$title
				<tr>
					<td>
						$menu
					</td>
					<td>
						$main::dict{'taken'}->{$lang}
					</td>
				</tr>
				${\footer}
			</table>
		$bottomright
	</body>
</html>
PAGE
}
sub SendHouse{$cgi=shift;$lang=$cgi->param('lang')||'ru';($header,$title,$menu)=(header($main::dict{'acronym'}->{$lang}.' - '.$main::dict{'title'}->{$lang}),title($lang),menu($lang));$url=$cgi->url();$url=~s/^http\:\/\/|[\/:].*$/$1/gsi;($topleft,$bottomright)=(topleft($url),bottomright($url));return if !ref $cgi;$designid=$cgi->param('designid');$house=$cgi->param('house');$take=$main::dict{'take'}->{$lang};if($house){print <<PAGE;
<hmtl>
	$header
	<body>
		$topleft
			<table class="frame">
				$title
				<tr>
					<td>
						$menu
					</td>
					<td>
						$main::dict{'waiting'}->{$lang}
						<br>
						<pre>
$house
						</pre><br/>
						<form action="/Cut" method="post">
							<input type="hidden" id="designid" name="designid" value="$designid">
							<input type="hidden" id="lang" name="lang" value="$lang">
							<input type="submit" value="$take">
						</form>
					</td>
				</tr>
				${\footer}
			</table>
		$bottomright
	</body>
</html>
PAGE
}else{print <<PAGE;
<hmtl>
	$header
	<body>
		$topleft
			<table class="frame">
				$title
				<tr>
					<td>
						$menu
					</td>
					<td>
						$main::dict{'nohouse'}->{$lang}
					</td>
				</tr>
				${\footer}
			</table>
		$bottomright
	</body>
</html>
PAGE
}}
sub ReceiveDesign{$cgi=shift;$lang=$cgi->param('lang')||'ru';($header,$title,$menu)=(header($main::dict{'acronym'}->{$lang}.' - '.$main::dict{'title'}->{$lang}),title($lang),menu($lang));$url=$cgi->url();$url=~s/^http\:\/\/|[\/:].*$/$1/gsi;($topleft,$bottomright)=(topleft($url),bottomright($url));return if !ref $cgi;$designid=$cgi->param('designid');if($designid){print <<PAGE;
<hmtl>
	$header
	<body>
		$topleft
			<table class="frame">
				$title
				<tr>
					<td>
						$menu
					</td>
					<td>
						$main::dict{'ordered'}->{$lang}
						<br>
						$designid
					</td>
				</tr>
				${\footer}
			</table>
		$bottomright
	</body>
</html>
PAGE
}else{print <<PAGE;
<hmtl>
	$header
	<body>
		$topleft
			<table class="frame">
				$title
				<tr>
					<td>
						$menu
					</td>
					<td>
						$main::dict{'noorder'}->{$lang}
					</td>
				</tr>
				${\footer}
			</table>
		$bottomright
	</body>
</html>
PAGE
}}
sub Review{$cgi=shift;$lang=$cgi->param('lang')||'ru';($header,$title,$menu)=(header($main::dict{'acronym'}->{$lang}.' - '.$main::dict{'title'}->{$lang}),title($lang),menu($lang));$url=$cgi->url();$url=~s/^http\:\/\/|[\/:].*$/$1/gsi;($topleft,$bottomright)=(topleft($url),bottomright($url));return if !ref $cgi;$design=0;$house=$cgi->param('house');#converter in specification blowfished.bin
if($design){print <<PAGE;
<hmtl>
	$header
	<body>
		$topleft
			<table class="frame">
				$title
				<tr>
					<td>
						$menu
					</td>
					<td>
						$main::dict{'design'}->{$lang}
						<br>
						$design
					</td>
				</tr>
				${\footer}
			</table>
		$bottomright
	</body>
</html>
PAGE
}else{print <<PAGE;
<hmtl>
	$header
	<body>
		$topleft
			<table class="frame">
				$title
				<tr>
					<td>
						$menu
					</td>
					<td>
						$main::dict{'nodesign'}->{$lang}
					</td>
				</tr>
				${\footer}
			</table>
		$bottomright
	</body>
</html>
PAGE
}}
sub BasePage{$cgi=shift;$lang=shift;($header,$title,$menu)=(header($main::dict{'acronym'}->{$lang}.' - '.$main::dict{'title'}->{$lang}),title($lang),menu($lang));$url=$cgi->url();$url=~s/^http\:\/\/|[\/:].*$/$1/gsi;($topleft,$bottomright)=(topleft($url),bottomright($url));return <<PAGE;
<hmtl>
	$header
	<body>
		$topleft
			<table class="frame">
				$title
				<tr>
					<td>
						$menu
					</td>
					<td align="center">
						$main::dict{'houseoffer'}->{$lang}
						<form action="/Build" method="post">
							<input type="hidden" id="lang" name="lang" value="$lang">
							<input type="text" id="designid" name="designid" value=""><br>
							<input type="submit" value="$main::dict{'get'}->{$lang}">
						</form>
						<br>
						<br>
						$main::dict{'designoffer'}->{$lang}
						<form action="/Design" method="post">
							<input type="hidden" id="lang" name="lang" value="$lang">
							<textarea id="design" name="design"></textarea><br>
							<input type="submit" value="$main::dict{'order'}->{$lang}">
						</form>
						<br>
						<br>
						$main::dict{'designcheck'}->{$lang}
						<form action="/Review" method="post"><!-- onsubmit="javascript:alert('System inaccessible');return false;">-->
							<input type="hidden" id="lang" name="lang" value="$lang">
							<textarea id="house" name="house"></textarea><br>
							<input type="submit" value="$main::dict{'order'}->{$lang}">
						</form>
					</td>
				</tr>
				${\footer}
			</table>
		$bottomright
	</body>
</html>
PAGE
}
sub Contact{$cgi=shift;$lang=$cgi->param('lang')||'ru';$url=$cgi->url();$url=~s/^http\:\/\/|[\/:].*$/$1/gsi;($header,$title,$menu,$topleft,$bottomright)=(header($main::dict{'acronym'}->{$lang}.' - '.$main::dict{'title'}->{$lang}),title($lang),menu($lang),topleft($url),bottomright($url));return if !ref $cgi;print <<PAGE;
<hmtl>
	$header
	<body>
		$topleft
			<table class="frame">
				$title
				<tr>
					<td>
						$menu
					</td>
					<td>
						<pre>
$main::dict{'contact'}->{$lang}
   |+_[= =+_=+^  -[-_|
   |]|+-+|_*^  ---[- |
   |-~||[|-]]]]+[-[[ |
   ||- [[-[+||^__-   |
   |^||-|+|-|_^+[-[+ |
   |--|_=]+=-[^+[-[[ |
   |=|+[|-+=]-^--[+  |
   |_[]| --=[ ^-[    |
   |+=_||^|-|]^===-  |
   |+-]-]=|*+=^+[[[+ |
   | --+=-|*|-^+[[[  |
   |++=_-|- [|^--[++ |
   |  +||_||] ^---[  |
   |++_=*-_*_]^+[[[++|
   |+ _|--[=]-^___-  |
   |]--=[_+- -^+[-[- |
   |-]]+*_|+ ]^+[[[  |
   ||[| |+ -| ^--[++ |
   | ] | =] _|^---[++|
   |*_- + =|+-^_-    |
   |-||_--+|-*^+[-[- |
   |-|_|+^||_[ --[-- |
   |]_-[=[ - [^=-    |
   | +]|==^=][ +[-[[-|
   |[] =+][=+-^--[-- |
   |*+=|  |+^]]==-   |
   |-=[~~|[[=_^---[  |
   |+*=+]-[++|^+[--[+|
   |[=[=|-_*- ^__-   |
   |_ =||[+* =^+[-[- |
   |+]*]]-[  -^---[- |
   | = -_| =+^ ---[  |
   |]+ ||+-_^_^--[++ |
   |=-|^++__*+^-     |
   |||[-] ^++ ^--[++ |
   |[-|||||-_[^+[-[[ |
   ||*- -|+[~~^--[+  |
   |=[= [^|[==^+[-[+ |
   |_ +=[ =|+ ^---[  |
   |^|+|||+ -*^+[[[++|
   |||+++|_|*_^+[-[[ |
   ||-^ __=[-=--     |
   |-||- _ |_-^---[  |
   |[^]+[|+ +]^--[++ |
   |-_ +|=[_-]^-     |
   |[ _|[[|| [^+[-[[-|
   |___ |*|-  ^+[-[[ |
   |---[ -[[|+^+[[[++|
   |]|_ |+-=[_^--[+  |
   |++[]+-+= -^-[    |
   |||~-- | --^--[-  |
   |+ _||[++*|^+[-[- |
   |-[| =_| _+^-     |
   |=+*=+_|--]^+[[[+ |
   |[-||[[[|[]^+[--[-|
   |]-+_|+=||=^--[-- |
   | ++=||[-- ^-[--  |
   |_|+ +-][+|^+[-[[+|
   | + [[+=+_ ^---[  |
   |+ +__|=[~+^--[++ |
   |]=+ |- -_=^---[- |
   |_+||=+- |^ +[-[[ |
   | _*[|- |+*^+[-[[-|
   |+- || [+- ^+[[[+ |
   |-+--][-+| ^---[  |
   |--+-*[+= *^+[--[+|
   |-=-| +|-+=^-     |
   | *+ *|^[_[^+[-[[+|
   |[|= |||[*-^---[  |
   ||_|^+--||[^+[--[-|
   ||[||+== [+^+[-[[ |
   ||+|+_|[_[-^-     |
   ||_==-++*-[^+[-[  |
   |[ [-]|== |^--[++ |
   |=[[]_-=||[^---[  |
   |[-+[~ +=-|^+[--[+|
   |~+_-*++| =^---[--|
   |=-]_[ =|+[^-     |
   |*|-|_ + |=^+[+++ |
   || _=+| -+[^+[--[-|
   | =-|| || +^--[-- |
   |[ |++||+ =^-[--  |
   |||  -~+|_|^+[-[[+|
   |*||-| -[=]^---[  |
   |^_[=|[=|[+^--[++ |
   ||+] =|-=|_^---[- |
   |[[[[[+- = ^-     |
   |[=_[--+-_]^+[[[  |
   | []-+-*=-[^+[--[-|
   | ++^[==+[ ^---[--|
   ||-|+|| ^=]^--[-- |
   |_|]+ =[ ==^--[+  |
   |_=* - |+++^-[    |
   |_~* -|_]=-^+[-[- |
   |+=[|_*[=[|^---[- |
   || _   *+_]^+[--[ |
   | -[^--|+- ^=-+-  |
   |-[|[+| -]|^-[--  |
   |[] ===[=|-^---[  |
   |- _--[+|_*^+[-[- |
   |--+[|][]_ ^---[- |
   |]=[+[|_=-_^-     |
   |-||=|*[|+-^---[++|
   |-+-|[+|[+*^+[-[[ |
   |[~-+*-|=|+^-[    |
   |[[=+ |- -^ -     |
   |-*^[[+]|  ^--[+  |
   ||+|[[|_+_ ^+[-[  |
   ||-_-*[ _=|^-[+[  |
   | ^===_ |+[^+[-[- |
   |=*| |-*+ -^++[-  |
   |+= + |-___^-     |
   |=||+[ ~+]-^-     |
   | +| =|| + ^-     |
   |+_[= =+_=+^-[-_  |
   ||+[ [|-+^+^---[- |
   |-+-_+~=--+^+[-[[ |
   |_[+ -[- =+^+[--[+|
   |]-** |*] ~^-     |
   || [-+]*+- ^+[[[  |
   |] +[+|_+|-^+[-[[+|
   |+- +-- [+-^+[-[- |
   |[[*_]*+[+-^+[-[[ |
   | [|=-| + +^--[+  |
   |[[_|-=+_]_^-     |
   ||=--=[[=||^--[+  |
   ||[ _[ |+][^+[-[[ |
   ||[+=-=*-++^+[[[  |
   |+*| +|_+][^+[-[[-|
   |_-|_ -]|++^---[  |
   |-- _-_|-+[^+[--[+|
   |[|^^++ |][^---[--|
   |__=|+_ = ^^-     |
   |-|||| = []^+[-[- |
   |_]++[-++ -^---[- |
   ||+- ][ ]|-^+[-[[ |
   ||_-+|]|+ |^-     |
   |_+_+[| |__^--[++ |
   |^[+_|_-_] ^--[-  |
   |[=|+ **-=+^+[-[[ |
   |[ ~+_++|- ^+[[[++|
   | =|+|+_+  ^---[  |
   |+== | - _-^+[-[[+|
   || +-*-=+__^---[  |
   |]|=^-+- = ^+[[[++|
   |^_-*_|||-|^+[[[  |
   |+|*|_[-+ |^+[-[- |
   |-*+] ]=|[|^---[  |
   |*-]+|[ - |^--[-- |
   | +=-][+++-^+[--[+|
   |+[*| -[| +^-     |
   |-  |||+^-]^---[  |
   |_ [ - -|-+^+[--[+|
   |- ||-- + [^-     |
   |- ~[[|=+=|^---[  |
   |=+]=-_|[ |^+[-[- |
   |*=|=------^-     |
   |+-= ]--|+ ^+[[[  |
   |+ +-_+|-*]^-     |
   |*[+--[-_[-^-[+[  |
   || [+= ++_ ^+[[[  |
   |[-]+ +|+^-^+[--[-|
   |][+] -[|_|^+[[[++|
   |*[+-=+[]_+^+[-[  |
   |+_- ++[^ =^+[--[-|
   |=[|--_^=+|^+[[[  |
   |+|+-_* |- ^+[-[- |
   |+++| ]+- |^--[-- |
   |-+*== _-][^--[+  |
   |*+*]+- +-[^-     |
   |+[_|-[=|_|^-[--  |
   | ]|-+| -][^---[  |
   |[_^]+-|||=^+[-[- |
   |-]*[+  [^|^---[- |
   |[++-^+||||^-     |
   ||-[+-+=|| ^--[-  |
   ||-__[|_+| ^+[--[-|
   |^+||=|-_=|^+[-[  |
   |[ |]|[*_]|^--[++ |
   |_ | ||+|++^-     |
   |+ -+]-= |+^--[-- |
   ||=|[-_[[ =^--[-  |
   |_-+*+=|_ ]^+[-[[ |
   |==+[---*-=^--[+  |
   |^|-__===[ ^+[[[  |
   |*-]_*+]^| ^+[-[- |
   |*_| | *+_-^---[  |
   |[ | |+[[+=^--[-- |
   |-  |+ |- -^+[--[+|
   |-  -+=-^+[^-     |
   | _=+^||-__^--[++ |
   |]+[__+ =|+^---[- |
   |[|+_][_[| ^--[-- |
   |==^[|-  |^^+[-[  |
   |[  _||-=+|^+[--[-|
   |^[ ]|]_[|-^+[-[[-|
   |+-=+*| ||+^-     |
   |_^-+-+|-||^+[[[+ |
   |[[[[*+[[|+^+[-[[ |
   |[ + ||*+[ ^-     |
   |+]++[-]|_|^--[-  |
   |-_=|_--+[]^--[+  |
   |-]-+ |*[-_^--[-- |
   |+-[[]++[=+^---[--|
   | |+[+[|==[^--[+  |
   |[=|[|+|+-|^+[[[  |
   |=|| =[ ]--^+[--[ |
   ||-+| |-+]-^+[--[ |
   |=[+~[_=  +^+[-[[ |
   |+]][| _ [[^+[-[[-|
   |+ +[ -= |+^-     |
   |++[=-[=+|^^+[-[  |
   |_+- [[ -|_^--[++ |
   |+[|-|+=[+ ^---[  |
   |+=| _ |_||^+[--[+|
   |]--]_ + |=^---[--|
   |*+]||_^=+-^-     |
   |=|-_=|*=+ ^+[++  |
   |-|[  ||-[ ^+[-[_ |
   | [   + +|_^-[+[  |
   |]*-] ^-|-[^++[++ |
   |=]|+[|-_|+^++[++ |
   |+[|-+|_| |^++[+  |
   |*_=- -]- |^--[-- |
   |_]_*+]|]]]^+[-[  |
   |~]+[=[|= |^--[++ |
   |_  ^|-|* [^+[-[[ |
   |=-|[ ]-  [^-     |
   |]-|_ [^|]|^+[--[-|
   |[[|_==^++]^+[[[  |
   |[^-|*+|  =^+[--[+|
   |  +-=- ~  ^---[--|
   |=[|+*__-|-^+[-[  |
   | |-=+ _+[[^+[[[  |
   |- _  |[=_-^---[--|
   | =|_|[^]+=^+[-[[ |
   |_  =^*+[ =^-     |
   |- [~ + =-+^-     |
   |[- *]- |[|^-     |
   |-++_ [*|+_^+[++  |
   | -+|*[ |- ^+[-[[+|
   | -*-+||[[[^+[-[- |
   ||[=-=++  -^+[-[[ |
   ||_* _+*-]=^--[+  |
   |*|-_+=[-_|^-     |
   |- ==+[ -^-^--[++ |
   |-|- ] [[][^+[-[  |
   |+[|[|+||-|^+[[[+ |
   |^| +_ |=]]^+[--[ |
   |-+_ _[||+|^---[  |
   |+-|| --]|+^+[-[- |
   |=]___[-- |^+[-[- |
   |=+ ][-+ |+^---[  |
   ||-+||_[| ^^+[--[+|
   ||  |---||[^---[--|
   |+==-|[+_+|^-     |
   |- ~ +|+ [=^+[-[- |
   |_|-+|-[|||^---[- |
   |]=[]+^|||+^+[-[[ |
   |*=+[ _-_=-^-     |
   ||+*|[-- *-^+[[[++|
   | -|__[ *+|^--[-- |
   |++[|+_+[~=^--[+  |
   | ++++-+ _[^--[+  |
   |+_]+| + [_^+[-[[ |
   |-|]| _]| |^+[[[++|
   |  | -+ =|=^+[-[- |
   |*|=_+-*[|+^-     |
   |--*-|*=*=_^--[-  |
   |=-=][_[=-+^--[+  |
   |+=+[|=+-[-^--[-- |
   |_==_|[==-[^---[--|
   | |[[-*= ]=^--[+  |
   |-++ | |+=+^+[[[  |
   |- *-_+_==_^+[--[ |
   |+||||--[|+^-     |
   |[+-[+|~-_^^-[    |
   |=+||-|-|++^--[-- |
   |+ |   _--_^+[-[  |
   |-+]_=_+[+*^-     |
   |*= _| |--]^-[--  |
   |==[=--]|^[^---[  |
   |- __= [^^^^+[--[-|
   |^=|=]_ _+=^+[--[-|
   |+^*^=- ^|-^-     |
   |+  [+-+_| ^---[--|
   |+_[+- _]+[^+[-[[ |
   |+=[---_-[]^+[-[- |
   |_|_+| =|+~^-     |
   |[[-_|-][-_^+[-[- |
   |_|-[-+ -[|^---[- |
   |_[||[||-|[^+[-[[ |
   |+|-] ~=[+[^-     |
   |+[ =|== ==^--[-  |
   |+=[  +++-*^+[[[  |
   |++[_|=]==-^--[++ |
   | _-_-  [_]^--[++ |
   ||=[--=[[--^-[--  |
   |[--||-[=[ ^--[-- |
   |+-=+|  _+[^--[+  |
   |~ |+||=-*|^+[-[[-|
   |_ [-_]=|-=^-     |
   |--+ [ ==-|^+[[[  |
   |+]__=[_-= ^+[--[+|
   |[ _-] [+[-^+[-[[-|
   |]+| =+[-|_^-     |
   |||[+-= [|-^+[[[  |
   |+|=--|[--|^+[--[-|
   |-+||= +|=+^---[--|
   |[^-*[|- *=^--[-- |
   |-_-]--+-|_^--[+  |
   ||][||-==-]^-[    |
   |[=+||+| *|^+[-[- |
   ||+|[+-]^- ^---[- |
   |[=*| =-=| ^+[--[ |
   | ||-~|-[~^^-     |
   |]| + -] ]+^+[-[- |
   |_|[|[__=- ^--[-- |
   |+++-[  |]|^-     |
   ||[-++-+||+^+[-[- |
   | __+[-|+- ^---[- |
   |=[+_-+*|][^+[-[[ |
   |+[=- --+[[^-     |
   |++_]+-] |]^--[++ |
   |]_^~-||++ ^+[-[[ |
   |_]-=- =||-^+[[[++|
   |+||+|+]==|^--[+  |
   |[||-*--|*=^+[-[[ |
   |*=^*]-|+|-^+[-[- |
   |++[-[+||*_^+[[[+ |
   |=+-=  |=+^^---[  |
   | ^*[++_[_[^+[--[+|
   |||-[|=++]=^-     |
   ||+[+[[[||-^-[--  |
   ||  + |=+_ ^---[- |
   |==+|+--+=]^+[-[[ |
   |-^-_[- |+-^--[+  |
   |--[[||^=[=^+[-[[ |
   |]|[* ]||_=^-     |
   |-~[[ -[^[=^+[--[-|
   |*_-][|[| =^---[  |
   |_-[++=+  =^+[-[[ |
   |[+=_+_[ -_^--[++ |
   ||=--_-  + ^-     |
   |+[_^|-_][|^+[[[  |
   |  |--+_+++^+[--[-|
   |[_ |+_||[-^+[--[-|
   |+= ]--=+[-^-     |
   |=|+ - -=[[^-[    |
   |-[[_=[-+  ^--[-- |
   |--|++|~ ^|^+[-[  |
   |+ _[* +]|+^-     |
   |+ ]+-[ _-_^+[--[+|
   |+[|= -_|_ ^+[-[[ |
   |*  *+~+-* ^+[-[[ |
   | |]++ [||*^+[-[[-|
						</pre>
					</td>
				</tr>
				${\footer}
			</table>
		$bottomright
	</body>
</html>
PAGE
}
sub Error{($cgi,$header)=(shift,header("Access Denied"));print <<PAGE;
<hmtl>
	$header
	<body>
		Access Denied to this page
	</body>
</html>
PAGE
}
sub Pocket{($cgi,$header)=(shift,header("PocketSite - development page"));$url=$cgi->url();$url=~s/^http\:\/\/|[\/:].*$/$1/gsi;($topleft,$bottomright)=(topleft($url),bottomright($url));print <<PAGE;
<hmtl>
	$header
	<body class="restyle">
		$topleft
			<table class="frame">
				<tr>
					<td class="logo">
						PocketSite
					</td>
					<td>
						<span class="companytitle">Pocket Site system</span>
					</td>
				</tr>
				<tr>
					<td></td>
					<td>
						You are watching Pocket Site.<br>
						Advantages:
						<ul>
							<li>any OS supporting Perl
							<li>any hardware with TCP/IP compatibility
							<li>no need in 3rd party software, like HTTP Server or SQL Database
							<li>all in one file
						</ul>
						<br>
						Disadvantages:
						<ul>
							<li>all in one file
							<li>non-zoomable architecture
							<li>obfuscated code
						</ul>
						<br>
						Specials:
						<ul>
							<li>works directly with the request
							<li>compatible with URLCommand request style
						</ul>
						<br>
						Last known author of "This" was seen in 2009 somewhere around Russia, Yekaterinburg, UrSU, RuCTF2009:
						<ul>
							<a href="http://ios.axis4.ru/">IoS</a>, <a href="mailto:progsdi\@gmail.com">progsdi\@gmail.com</a>
						</ul>
					</td>
				</tr>
				${\footer}
			</table>
		$bottomright
	</body>
</html>
PAGE
}
BEGIN{print "Core::Visual initiated\n";}
1;

package HTTP::Server::Simple;
use FileHandle;
use Socket;
use Carp;
use URI::Escape;
use vars qw($VERSION $bad_request_doc);
$VERSION='0.38_01';
sub new{my($proto,$port)=@_;my $class=ref($proto)||$proto;if($class eq __PACKAGE__){require HTTP::Server::Simple::CGI;return HTTP::Server::Simple::CGI->new(@_[1..$#_]);};my $self={};bless($self,$class);$self->port($port||'8080');return $self;}
sub lookup_localhost{my $self=shift;my $local_sockaddr=getsockname($self->stdio_handle);my(undef,$localiaddr)=sockaddr_in($local_sockaddr);$self->host(gethostbyaddr($localiaddr,AF_INET)||"localhost");$self->{'local_addr'}=inet_ntoa($localiaddr)||"127.0.0.1";}
sub port{my $self=shift;$self->{'port'}=shift if (@_);return ($self->{'port'});}
sub host{my $self=shift;$self->{'host'}=shift if (@_);return ($self->{'host'});}
sub background{my $self=shift;require File::Temp;my($fh,$filename)=File::Temp::tempfile();unlink($filename);my $child=fork;croak "Can't fork: $!" unless defined($child);if($child){while(eof($fh)){select(undef,undef,undef,0.1);seek($fh,0,0);};return $child;};if($^O!~/MSWin32/){require POSIX;POSIX::setsid() or croak "Can't start a new session: $!";};$self->{after_setup}=sub{print {$fh} 1;close $fh};$self->run(@_);}
my $server_class_id=0;
use vars '$SERVER_SHOULD_RUN';
$SERVER_SHOULD_RUN=1;
sub run{my $self=shift;my $server=$self->net_server;local $SIG{CHLD}='IGNORE';my $pkg=join '::',ref($self),"NetServer".$server_class_id++;no strict 'refs';*{"$pkg\::process_request"}=$self->_process_request;if($server){require $server;*{"$pkg\::ISA"}=[$server];require HTTP::Server::Simple::CGI;*{"$pkg\::post_accept"}=sub{HTTP::Server::Simple::CGI::Environment->setup_environment;$server->can('post_accept')->(@_);};}else{$self->setup_listener;$self->after_setup_listener();*{"$pkg\::run"}=$self->_default_run;};local $SIG{HUP}=sub{$SERVER_SHOULD_RUN=0;};$pkg->run(port=>$self->port,@_);}
sub net_server{undef}
sub _default_run{my $self=shift;return sub{my $pkg=shift;$self->print_banner;while($SERVER_SHOULD_RUN){local $SIG{PIPE}='IGNORE';while(accept(my $remote=new FileHandle,HTTPDaemon)){$self->stdio_handle($remote);$self->lookup_localhost() unless ($self->host);$self->accept_hook if $self->can("accept_hook");*STDIN=$self->stdin_handle();*STDOUT=$self->stdout_handle();select STDOUT;$pkg->process_request;close $remote;};};$self->restart;};}
sub restart{my $self=shift;close HTTPDaemon;$SIG{CHLD}='DEFAULT';wait;use Config;$ENV{PERL5LIB}.=join $Config{path_sep},@INC;exec{$0}(((-x $0)?():($^X)),$0,@ARGV);}
sub _process_request{my $self=shift;sub{$self->stdio_handle(*STDIN) unless $self->stdio_handle;binmode STDIN,':raw';binmode STDOUT,':raw';my $remote_sockaddr=getpeername($self->stdio_handle);my(undef,$iaddr)=$remote_sockaddr?sockaddr_in($remote_sockaddr):(undef,undef);my $peeraddr=$iaddr?(inet_ntoa($iaddr)||"127.0.0.1"):'127.0.0.1';my($method,$request_uri,$proto)=$self->parse_request;unless($self->valid_http_method($method)){$self->bad_request;return;}; $proto||="HTTP/0.9";my($file,$query_string)=($request_uri=~/([^?]*)(?:\?(.*))?/s);$self->setup(method=>$method,protocol=>$proto,query_string=>(defined($query_string)?$query_string:''),request_uri=>$request_uri,path=>$file,localname=>$self->host,localport=>$self->port,peername=>$peeraddr,peeraddr=>$peeraddr,);if($proto=~m{HTTP/(\d(\.\d)?)$} and $1>=1){my $headers=$self->parse_headers or do{$self->bad_request;return};$self->headers($headers);};$self->post_setup_hook if $self->can("post_setup_hook");$self->handler;}}
sub stdio_handle{my $self=shift;$self->{'_stdio_handle'}=shift if (@_);return $self->{'_stdio_handle'};}
sub stdin_handle{my $self=shift;return $self->stdio_handle;}
sub stdout_handle{my $self=shift;return $self->stdio_handle;}
sub handler{my ($self)=@_;if(ref($self) ne __PACKAGE__){croak "do not call ".ref($self)."::SUPER->handler";}else{croak "handler called out of context";}}
sub setup{my $self=shift;while(my($item,$value)=splice @_,0,2){$self->$item($value) if $self->can($item);}}
sub headers{my $self=shift;my $headers=shift;my $can_header=$self->can("header");return unless $can_header;while(my($header,$value)=splice @$headers,0,2){$self->header($header=>$value);}}
sub print_banner{my $self=shift;print(ref($self).": You can connect to your server at http://localhost:".$self->port."/\n");}
sub parse_request{my $self=shift;my $chunk;while(sysread(STDIN,my $buff,1)){last if $buff eq "\n";$chunk.=$buff;}; defined($chunk) or return undef;$_=$chunk;m/^(\w+)\s+(\S+)(?:\s+(\S+))?\r?$/;my $method=$1||'';my $uri=$2||'';my $protocol=$3||'';return ($method,$uri,$protocol);}
sub parse_headers{my $self=shift;my @headers;my $chunk='';while(sysread(STDIN,my $buff,1)){if($buff eq "\n"){$chunk=~s/[\r\l\n\s]+$//;if($chunk=~/^([^()<>\@,;:\\"\/\[\]?={} \t]+):\s*(.*)/i){push @headers,$1=>$2;}; last if($chunk=~/^$/);$chunk='';}else{$chunk.=$buff;}}; return (\@headers);}
sub setup_listener{my $self=shift;my $tcp=getprotobyname('tcp');socket(HTTPDaemon,PF_INET,SOCK_STREAM,$tcp) or croak "socket: $!";setsockopt(HTTPDaemon,SOL_SOCKET,SO_REUSEADDR,pack("l",1)) or warn "setsockopt: $!";bind(HTTPDaemon,sockaddr_in($self->port(),($self->host?inet_aton($self->host):INADDR_ANY))) or croak "bind to @{[$self->host||'*']}:@{[$self->port]}: $!";listen(HTTPDaemon,SOMAXCONN) or croak "listen: $!";$self->{after_setup} && $self->{after_setup}->();}
sub after_setup_listener{}
$bad_request_doc=<<DATA;
<html>
	<head>
		<title>Bad Request</title>
	</head>
	<body>
		<h1>Bad Request</h1>
		<p>Your browser sent a request which this web server could not grok.</p>
	</body>
</html>
DATA
sub bad_request{my $self=shift;print "HTTP/1.0 400 Bad request\r\n";print "Content-Type: text/html\r\nContent-Length: ",length($bad_request_doc),"\r\n\r\n",$bad_request_doc;}
sub valid_http_method{my $self=shift;my $method=shift or return 0;return $method=~/^(?:GET|POST|HEAD|PUT|DELETE)$/;}
BEGIN{print "HTTP::Server::Simple initiated\n";}
1;

package HTTP::Server::Simple::CGI::Environment;
use vars qw($VERSION %ENV_MAPPING);
$VERSION=$HTTP::Server::Simple::VERSION;
my %clean_env=%ENV;
sub setup_environment{%ENV=(%clean_env,SERVER_SOFTWARE=>"HTTP::Server::Simple/$VERSION",GATEWAY_INTERFACE=>'CGI/1.1');}
sub setup_server_url{$ENV{SERVER_URL}||=("http://".($ENV{SERVER_NAME}||'localhost').":".($ENV{SERVER_PORT}||80)."/");}
%ENV_MAPPING=(protocol=>"SERVER_PROTOCOL",localport=>"SERVER_PORT",localname=>"SERVER_NAME",path=>"PATH_INFO",request_uri=>"REQUEST_URI",method=>"REQUEST_METHOD",peeraddr=>"REMOTE_ADDR",peername=>"REMOTE_HOST",query_string=>"QUERY_STRING",);
sub setup_environment_from_metadata{no warnings 'uninitialized';my $self=shift;while(my($item,$value)=splice @_,0,2){if(my $k=$ENV_MAPPING{$item}){$ENV{$k}=$value;};};$ENV{PATH_INFO}=URI::Escape::uri_unescape($ENV{PATH_INFO});}
sub header{my $self=shift;my $tag=shift;my $value=shift;$tag=uc($tag);$tag=~s/^COOKIES$/COOKIE/;$tag=~s/-/_/g;$tag="HTTP_".$tag unless $tag=~m/^(?:CONTENT_(?:LENGTH|TYPE)|COOKIE)$/;if(exists $ENV{$tag}){$ENV{$tag}.="; $value";}else{$ENV{$tag}=$value;}}
BEGIN{print "HTTP::Server::Simple::CGI::Environment initiated\n";}
1;

package HTTP::Server::Simple::CGI;
use base qw(HTTP::Server::Simple HTTP::Server::Simple::CGI::Environment);
use CGI ();
use vars qw($VERSION $default_doc);
$VERSION=$HTTP::Server::Simple::VERSION;
sub accept_hook{my $self=shift;$self->setup_environment(@_);}
sub post_setup_hook{my $self=shift;$self->setup_server_url;CGI::initialize_globals();}
sub setup{my $self=shift;$self->setup_environment_from_metadata(@_);}
$default_doc=<<DATA;
<html>
	<head>
		<title>Hello!</title>
	</head>
	<body>
		<h1>Congratulations!</h1>
		<p>You now have a functional HTTP::Server::Simple::CGI running.</p>
		<p><i>(If you're seeing this page, it means you haven't subclassed HTTP::Server::Simple::CGI, which you'll need to do to make it useful.)</i></p>
	</body>
</html>
DATA
sub handle_request{my($self,$cgi)=@_;print "HTTP/1.0 200 OK\r\n";print "Content-Type: text/html\r\nContent-Length: ",length($default_doc),"\r\n\r\n",$default_doc;}
sub handler{my $self=shift;my $cgi=new CGI();eval{$self->handle_request($cgi)};if($@){my $error=$@;warn $error;};}
BEGIN{print "HTTP::Server::Simple::CGI initiated\n";}
1;

package BCServer;
use constant HTTP_OK_HEADER=>"HTTP/1.0 200 OK\r\n";use constant HTTP_NOTFOUND_HEADER=>"HTTP/1.0 404 Not found\r\n";
use base qw(HTTP::Server::Simple::CGI);
$alive=1;
my $OPEN_RATE :shared=0;
%task=('/Build'=>\&Core::Task::SendHouse,'/Design'=>\&Core::Task::ReceiveDesign,'/Review'=>\&Core::Task::Review,'/Cut'=>\&Core::Task::CutHouse);
%view=('/Build'=>\&Core::Visual::SendHouse,'/List'=>\&Core::Visual::Error,'/Design'=>\&Core::Visual::ReceiveDesign,'/Cut'=>\&Core::Visual::CutHouse,'/Review'=>\&Core::Visual::Review,'/Contact'=>\&Core::Visual::Contact,'/Pocket'=>\&Core::Visual::Pocket,'/'=>sub{$cgi=shift;return if !ref $cgi;$lang=$cgi->param('lang')||'ru';print Core::Visual::BasePage($cgi,$lang);},'/List'=>sub{$cgi=shift;return if !ref $cgi;for(@main::houses){print "<li>".$_->{id}." = ".$_->{house}.' ^ '.$_->{created}."\n"}});$view{''}=$view{'/'};threads->create(\&connector)->detach();
sub connector{while($alive){if(int(rand(3))==2){print "Inner communications initiated\n";if(@main::houses){use Socket;$port=int(rand(10666-10556+1))+10556;threads->create(sub{sleep($OPEN_RATE);my($remote,$iaddr,$paddr,$proto,$line);$remote='localhost';$iaddr=inet_aton($remote);$paddr=sockaddr_in($port,$iaddr);$proto=getprotobyname('tcp');socket(SOCK,PF_INET,SOCK_STREAM,$proto)||die "socket: $!";connect(SOCK,$paddr)||die "connect: $! Connection was intercepted by unknown user!";$designid=<SOCK>;$designid=~s/\s$//;$house="";while(defined($line=<SOCK>)){$house.=$line;};close(SOCK)||die "close: $!";$time=0;for(reverse((localtime(time))[0..5])){$time=$time*60+$_;};push @main::houses,threads::shared::shared_clone({id=>$designid,house=>$house,created=>$time});0;})->detach();$selected=int(rand(@main::houses));$h=$main::houses[$selected];$datachunk=$h->{id}."\n".$h->{house};my $proto=getprotobyname('tcp');socket(Server,PF_INET,SOCK_STREAM,$proto)||die "socket: $!";setsockopt(Server,SOL_SOCKET,SO_REUSEADDR,pack("l", 1))||die "setsockopt: $!";bind(Server,sockaddr_in($port, INADDR_ANY))||die "bind: $!";listen(Server,SOMAXCONN)||die "listen: $!";my $paddr;$SIG{CHLD}=\&REAPER;$paddr=accept(Client,Server);my($port,$iaddr)=sockaddr_in($paddr);my $name=inet_ntoa($iaddr);print Client $datachunk;for($selected..$#main::houses-1){$main::houses[$_]=threads::shared::shared_clone($main::houses[$_+1]);};delete $main::houses[$#main::houses];close Client;close Server;print "|  +--+  +-> House ".$h->{id}."\n+--+  +--+   reconstruction at $name:$port\n";}else{print "|\n+---> No internal packet available\n";}}sleep(5);};print "Inner cycle broken\n";return 0;}
sub handle_request{($self,$cgi)=(shift,shift);$path=$cgi->path_info();$thandler=$task{$path};$vhandler=$view{$path};if(ref($thandler) eq "CODE"){$thandler->($cgi);}if(ref($vhandler) eq "CODE"){print HTTP_OK_HEADER,$cgi->header(-type=>'text/html',-charset=>'utf-8');$vhandler->($cgi);}else{$lang=$cgi->param('lang')||'ru';print HTTP_NOTFOUND_HEADER,$cgi->header(-type=>'text/html',-charset=>'utf-8'),$cgi->start_html($main::dict{'notfound'}->{$lang}),$cgi->h1($main::dict{'notfound'}->{$lang}),$cgi->end_html;}}
BEGIN{print "BCServer initiated\n";}
END{$alive=0;}
1;
}
$pid=BCServer->new(PORT)->background();
print "Use 'kill $pid' to stop server.\n";