#!/usr/bin/perl

sub show_reg {

    my $form=<<END;
    <h3 class="header">Registration:</h3>
    <form name='registry_form' ><br>
    <div class="reg">
    <table class="reg">
    <tr><td>Login:</td><td><input type='text' name='login' size=25></td></tr>
    <tr><td>First Name:</td><td><input type='text' name='fname' size=25></td></tr>
    <tr><td>Second Name:</td><td><input type='text' name='sname' size=25></td></tr>
    <tr><td>Password:</td><td><input type='password' name='password' size=25></td></tr>
    <tr><td>Email:</td><td><input type='text' name='mail' size=25></td></tr>
    <tr><td>Credit card:</td><td><input type='text' name='card' size=25></td</tr>
    </table>
    </div>
    <div class="reg_submit"><input type='button' onclick='do_reg()' value='Register'></div>
    </form>
END

    send_answer($form);
}

sub do_reg {

    if ($ENV{CONTENT_LENGTH}>0 && $ENV{CONTENT_LENGTH}<2000 && $ENV{REQUEST_METHOD} eq "POST"){

	read STDIN, $data, $ENV{CONTENT_LENGTH};
	my %param=$data=~/(\w+)=([^&]*)&?/g;
	
	# Check for the empty field & clear input.
	for (keys %param){
	
	    if ($param{$_} eq ""){
		send_answer ("<h3 class='header'>Field $_ can't be an empty</h3><br>");
		exit 0;
	    }
	    
	}

	if ($param{login}=~/[<>%;\/\\&\$ ]/){
	    send_answer("<h3 class='header'>Login name shold not contain special characters & white spaces.\n</h3>");
	}

	send_answer ("<h3 class='header'>Invalid e-mail address</h3><br>\n") if ($param{'mail'}!~/^\w+@.+\./);
	send_answer ("<h3 class='header'>Invalid card number</h3><br>\n") if ($param{'card'}!~/^\d{4}-\d{4}-\d{4}-\d{4}$/);

	insert_user (\%param);
	send_cookie(\%param);
	send_answer("<h3 class='header'>Registration is successful</h3><br>");
    
    } else {send_aswer("<h3 class='header'>Man, what is that?!</h3>\n");}

}


sub show_user {

    if ($ENV{HTTP_COOKIE}=~/ganja-shop=([^; ]+);?/) {
        
	# Get cookie name
	my $cookie_file=$1;

	# You can't hack me :)
	$cookie_file=~s#/##;
	$cookie_file=~s#\.##;

	send_answer("<h3 class='header'>You are not logged in</h3>") if ! -e $cookie_dir.$cookie_file;
	
	# Get user details
	open F, $cookie_dir.$cookie_file or die "open cookie file: $!\n";
	
	$_=<F>;
	filter(\$_);
	/(.+?):(.*?):(.*?):(.*?):(.*?):(\d{4}-\d{4}-\d{4}-\d{4}):(\d)/;

	my $username=$1;

	my $form=<<END;
        <h3 class="header">Users account:</h3>
	<form id='users_form'><br><table align='center'>
	<tr><td>Login:</td><td>$username</td></tr>
	<tr><td>First Name:</td><td>$2</td></tr>
	<tr><td>Second Name:</td><td>$3</td></tr>
	<tr><td>Password:</td><td>$4</td></tr>
	<tr><td>Email:</td><td>$5</td></tr>
	<tr><td>Credit card:</td><td>$6</td</tr>
	</table><br>
	</form>
END

	close F;	
	
	my %items;
	
	# Get user orders
	open F, "$orders_file" or die "open $orders_file: $!\n";
	while (<F>){
	    
	    /(.*):(.*)/;
	    $items{$2}++ if ($username eq $1);
	
	}
	close F;
	
	my $orders=<<END;
	<h3 class="header">You make the following order:</h3>
	<table class="orders" align="center" cellspacing="0" cellpadding="0">
END

	open F, "$ganja_file" or die "open $ganja_file: $!\n";
	my @ganja=<F>;
	close F;
    
	for (keys %items){
	
	    my $key=$_;

	    for (@ganja){
		
		/(.*):(.*):\d+/;

		if ($key eq $1){
		
		    $orders.=<<END;
		    <tr>
		    <td class="orders_image" width="30%">
		    <img src="./images/$1.jpg">
		    </td>
		    <td class="orders_text" width="60%">
		    <h4 class="header">$1</h4>
		    $2<br><br>
		    </td>
		    <td class="orders_amount" width="10%">
		    <h3 class="header">$items{$key}</h3>
		    </td>
		    </tr>
END
		    last;
		}
	    }		
	}    	
		
	$orders.="</table>";
	send_answer($form.$orders);
	
    }

    send_answer("<h3 class='header'>You are not logged in</h3>")
}

sub show_allusers
{
    # Only admin can use it!
    if ($ENV{HTTP_COOKIE}=~/ganja-admin/) {
    
	my $users=<<END;
	<h3 class="header">Users list</h3><br>
	<table class="all_users" align="center" cellspacing="0" cellpadding="0">
	<tr>
	<td><h4 class="header">Login</h4></td>
	<td><h4 class="header">First name</h4></td>
	<td><h4 class="header">Second name</h4></td>
	<td><h4 class="header">E-mail</h4></td>
	<td><h4 class="header">Credit card</h4></td>
	<td><h4 class="header">Admin status</h4></td>
	</tr>
END

	    
	open F, "$users_file" or die "open $suers_file: $!\n";
	while (<F>){
	    filter(\$_);
	    /(.+?):(.+?):(.+?):(.+?):(.+?):(.+?):(\d+)/;
	    $users.=<<END;
	    <tr>
	    <td>$1</td><td>$4</td><td>$3</td><td>$5</td><td>$6</td>
END
	    if ($7){
		$users.="<td>Yes</td></tr>";
	    } else {
		$users.="<td>No</td></tr>";
	    }
	
	}	
	close F;
	
	$users.="</table><br><br>";
	
	send_answer($users);
    
    } else { send_answer("<h3 class='header'>You are not admin</h3>");}

}

sub do_login {

    if ($ENV{CONTENT_LENGTH}>0 && $ENV{CONTENT_LENGTH}<2000 && $ENV{REQUEST_METHOD} eq "POST"){

	read STDIN, $data, $ENV{CONTENT_LENGTH};
        my %param=$data=~/(\w+)=([^&]*)&?/g;
	
	# Check for the empty field & clear input
	for (keys %param){
	
	    if ($param{$_} eq ""){
		send_answer ("<h3 class='header'>Field $_ can't be an empty</h3><br>");
		exit 0;
	    }
	    
	}

	open F, "$users_file" or die "open $users_file: $!\n";
	
	while (<F>){
	
	    # What a F**K?
	    next if (!/(.+?):(.*?):(.*?):(.*?):(.*?):(\d{4}-\d{4}-\d{4}-\d{4}):(\d)/);
	    
	    if ($param{login} eq $1 && $param{password} eq $2){    
	    
		my $cookie="$param{login}_".time;
		open C, ">", $cookie_dir.$cookie or die "Can't create cookie file: $!\n";
		print C "$1:$2:$3:$4:$5:$6:$7\n";
		close C;
		close F;
		print "Set-Cookie: ganja-shop=$cookie; path=$home_dir\n";
		print "Set-Cookie: ganja-admin=1; path=$home_dir\n" if $7;
		send_answer("<h3 class='header'>Login is successful</h3>");
	    } 
	}
	
	close F;
	send_answer ("<h3 class='header'>Incorrect username or password</h3>");
	
    } else {send_answer ("<h3 class='header'>Man, what is that?!</h3>\n");}

} 

sub do_logout {
    
    if ($ENV{HTTP_COOKIE}=~/ganja-shop=([^; ]+);?/) {
        
	# Get cookie name
	my $cookie_file=$1;

	# You can't hack me :)
	$cookie_file=~s#/##;
	$cookie_file=~s#\.##;

	#Yeah!! rm -fr world
	unlink $cookie_dir.$cookie_file;
    
	print "Set-Cookie: ganja-shop=0; expires=Sun, 11 Oct 1987 18:30:26 GMT;\n";
	print "Set-Cookie: ganja-admin=0; expires=Sun, 11 Oct 1987 18:30:26 GMT;\n";
	send_answer("<h3 class='header'>Logging off</h3>");
    }
    
}

sub show_stock {

    my $status=0;
    my $stock="";

    # Are we logged in ?
    if ($ENV{HTTP_COOKIE}=~/ganja-shop=([^; ]+);?/) {

	# Get cookie name
        my $cookie_file=$1;

	# You can't hack me :)
        $cookie_file=~s#/##;
	$cookie_file=~s#\.##;

        # Well, if we are logged in we've got a cookie file, right?
	$status=1 if -e $cookie_dir.$cookie_file;
	
    }
    
    if ($status){

	$stock=<<END;
	<h3 class="header">Here you are! Make you mind quickly & enjoy :)</h3><br>
	<table class="ganja" align="center" cellspacing="0" cellpadding="0">
END
	
	open F, "$ganja_file" or die "open $ganja_file: $!\n";
	
	while (<F>){

	    /(.+):(.+):(\d+)/;

	    $stock.=<<END;
	    <tr>
	    <td class="ganja_image" width="30%">
	    <img src="./images/$1.jpg">
	    </td>
	    <td class="ganja_text" width="70%">
	    <h4 align="center">$1</h4>
	    $2<br><br>
	    <table width="100%" border="0">
	    <tr>
	    <td width="50%">
	    <b align="left">Price (in Gulden): $3</b>
	    </td>
	    <td width="50%">
	    <input type="image" align="right" class="buy"  src="./images/button_buy_now.gif" onclick="do_buy('$1')">
	    </td>
	    </tr>
	    </table>
	    </td>
	    </tr>
END
	}
	
	close F;
    
	$stock.="</table>";
    
    } else {
    
	$stock=<<END;
	<h3 class="header">We can present you the following tulips:</h3><br>
	<table class="tulip" align="center" cellspacing="0" cellpadding="0">
END
	
	open F, "$tulip_file" or die "open $tulip_file: $!\n";
	
	while (<F>){

	    /(.+):(.+):(\d+)/;

	    $stock.=<<END;
	    <tr>
	    <td class="tulip_image" width="30%">
	    <img src="./images/$1-tg.jpg">
	    </td>
	    <td class="tulip_text" width="70%">
	    <h4 align="center">$1</h4>
	    $2<br><br>
	    <table width="100%" border="0">
	    <tr>
	    <td width="50%">
	    <b align="left">Price (in Gulden): $3</b>
	    </td>
	    <td width="50%">
	    <input type="image" align="right" class="buy" src="./images/button_buy_now.gif" onclick="do_buy('$1')">
	    </td>
	    </tr>
	    </table>
	    </td>
	    </tr>
END
	}
	
	close F;
	$stock.="</table>";
    
    }
    
    send_answer($stock);
}

sub filter {

    my $f=shift;

    # No XSS
    $$f=~s/</\&lt;/g;
    $$f=~s/>/\&gt;/g;
    $$f=~s/\"/\&\#34;/g;
    $$f=~s/\'/\&\#39;/g;
}

sub buy_drug {

    # Only registered user can buy drugs!
    if ($ENV{HTTP_COOKIE}=~/ganja-shop=([^; ]+);?/) {
    
	# Get cookie name
        my $cookie_file=$1;

	# You can't hack me :)
        $cookie_file=~s#/##;
	$cookie_file=~s#\.##;

        # Well, if we are really logged we've got a cookie file, right?
	send_answer("<h3 class='header'>Register please!</h3>") if ! -e $cookie_dir.$cookie_file;
	
	# Ok, we are here!
        my $data;
        my $found=0;
	my $drug;
    
	# Read drug name.
	if ($ENV{CONTENT_LENGTH}>0 && $ENV{CONTENT_LENGTH}<2000 && $ENV{REQUEST_METHOD} eq "POST"){
        
	    read STDIN, $data, $ENV{CONTENT_LENGTH};
    	    $data=~/drug_name=(.*)&?/g;
	    $drug=$1;
	
	    #Drug should be listed
	    open F, "$ganja_file" or die "open $ganja_file: $!\n";

	    while (<F>){
	
		/(.+?):/;

		do{$found=1;last} if $1 eq $drug;
	
	    }

	    close F;

	    send_answer("<h3 class='header'>No such item</h3><br>") if !$found;
    
	} else {send_answer("<h3 class='header'>What is that?!</h3>\n");}
	
	# Go on.... Get username
	$cookie_file=~/(.+)_/;
	my $username=$1;
	
	if( ! -e "$orders_file"){
	    open F, ">", "$orders_file";
	    close F;
	}
	
	# One user can't get more than 10 orders!
	open F, "+<", "$orders_file" or die "open $orders_file: $!\n";
    
	my $count=0;
	my $orders="Your current orders\n\n";

	while (<F>){

	    /(.+):(.+)/;
	    
	    if ($username eq $1){
		$count++;
		$orders.="$count) $2\n";
	    }
		
	    if ($count>=10){
		$orders.="\nYou can't buy more than 10 item at once\n";
		send_answer($orders);
	    }
	}

	print F "$username:$drug\n";
	close F;
	
	send_answer("<h3 class='header'>Done!</h3>");
    }

send_answer("<h3 class='header'>Register please!</h3>");
}

sub send_cookie {

	my $user=shift;
	
	# Well, it's seems ok.
	# Create cookie. Yaammmyy! :)
	
	my $cookie="$$user{login}_".time;
	open F, ">", $cookie_dir.$cookie or die "Can't create cookie file: $!\n";
	print F "$$user{'login'}:$$user{'password'}:$$user{'sname'}:$$user{'fname'}:$$user{'mail'}:$$user{'card'}:0\n";
	close F;
	
	print "Set-Cookie: ganja-shop=$cookie; path=$home_dir\n";
}

sub insert_user {

    my $user=shift;
    
    open F, "+<", "$users_file" or die "open $users_file: $!\n";

    while(<F>){

	/(\w+?)\:/;
	
	if ($$user{"login"} eq $1){
		send_answer("<h3 class='header'>This login already exist.</h3>");
		close F;
		exit 0;
	}
    }

    # Ok, no such login, write it down.
    print F "$$user{'login'}:$$user{'password'}:$$user{'sname'}:$$user{'fname'}:$$user{'mail'}:$$user{'card'}:0\n";
    close  F;
}

sub send_answer {

    print "Cache-Control: no-cache\r\n";
    print "Content-type: text/html\n\n";
    print @_;
    exit 0;
}

local $home_dir="";
local $cookie_dir=$home_dir."tmp/";
local $users_file=$home_dir."data/users";
local $tulip_file=$home_dir."data/tulip";
local $ganja_file=$home_dir."data/ganja";
local $orders_file=$home_dir."data/orders";

$ENV{QUERY_STRING}=~/action\=(.+)&?/;&$1;
