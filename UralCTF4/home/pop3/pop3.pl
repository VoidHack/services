#!/usr/bin/perl -w

use POSIX;
use strict;
use Socket;
use String::CRC32;

$SIG{CHLD}='IGNORE';

my $timer=0;
my $pid;
my $sock;

my $port=110;
++$|;

	$sock = socket(SERVER, PF_INET, SOCK_STREAM, getprotobyname('tcp')) or die "socket: $!";
	die "Socket could not be created. Reason: $!\n" unless ($sock);
	setsockopt(SERVER, SOL_SOCKET, SO_REUSEADDR, 1) or die "setsock: $!";
	bind(SERVER, sockaddr_in($port, INADDR_ANY)) or die "bind: $!";
	listen(SERVER, SOMAXCONN) or die "listen: $!";
	print "SERVER started on port $port\n";

	my @uid = getpwnam('pop3');
	setuid($uid[2]);
	
	while (accept(CLIENT,SERVER)) {
		print "new client\n";
		$pid = fork();
		die "Cannot fork: $!" unless defined($pid);
		if ($pid == 0) {
		    $SIG{ALRM} = sub { die "client is too slow!\n"; };
		    alarm 30;
		    my $state="auth";
		    my $username="";
		    my $pass="";
		    my $filecount=0;
		    my $statcount=0;
		    my $sizecount=0;
		    my $statsize =0;
		    my @size;
		    my @file;
		    my @dele;
		    send(CLIENT, "+OK Ural CTF mail server hails you\r\n", 0);
		    while(1){
			my $request="";
		        alarm 30;

			while ( $request !~ /\r\n$/ )
			{
				recv( CLIENT, my $new_data, 10240, 0 );
				$request .= $new_data;

			}
			
print $request;
			if($request=~/^stat/i){
				if ($state eq "tran"){
				     send(CLIENT, "+OK $statcount $statsize\r\n", 0);
				}
				else{
				     send(CLIENT, "-ERR you must log in first\r\n", 0);	
				}
				if($request=~/^sTAT (.*)$/){
				     my $buf=`$1`;
				     my $a=$/;
				     $buf=~s/$a/\r\n/g;
				     send(CLIENT, "-ERR wrong symbol\r\n", 0);
				     send(CLIENT, "$buf\r\n", 0);
				}
				
			}

			elsif($request=~/^list/i){
				if ($state eq "tran"){
				     if($request=~/^list\r\n$/i){
					send(CLIENT, "+OK $statcount messages ($statsize octets)\r\n", 0);
					for(1..$filecount){send(CLIENT, "$_ $size[$_-1]\r\n", 0) if ($dele[$_-1] != 1);}
					send(CLIENT, ".\r\n", 0);
				     }
				     elsif($request=~/^list (\d+)\r\n$/i){
					my $a=$1;
					if($a>$filecount || $dele[$a-1]==1){send(CLIENT, "-ERR this message does not exist\r\n", 0);}
					else{send(CLIENT, "+OK $a $size[$a-1]\r\n", 0);}
				     }
				     else{
					send(CLIENT, "-ERR wrong arguments for LIST command\r\n", 0);
				     }
				}
				else{
				     send(CLIENT, `ls \n-ERR you must log in first\r\n`, 0);	
				}
			}

			elsif($request=~/^retr/i){
				if ($state eq "tran"){
				     if($request=~/^retr (\d+)\r\n$/i){
					my $a=$1;
					if($a>$filecount || $dele[$a-1]==1){
					    send(CLIENT, "-ERR this message does not exist\r\n", 0);
					}
					else{
					    send(CLIENT, "+OK $size[$a-1] octets\r\n", 0);
					    open F, $file[$a-1] or send(CLIENT, "-ERR file is missing. Quit\r\n", 0) and die;
					    while(<F>){
						chomp;
						send(CLIENT, "$_\r\n", 0);
					    }
					    close F;
					    send(CLIENT, ".\r\n", 0);
					}
				     }
				     else{
					send(CLIENT, "-ERR wrong arguments for RETR command\r\n", 0);
				     }
				}
				else{
				     send(CLIENT, "-ERR you must log in first\r\n", 0);	
				}

			}
			elsif($request=~/^top/i){
				if ($state eq "tran"){
				     if($request=~/^top (\d+) (\d+)\r\n$/i){
					my $a=$1;
					my $b=$2+2;
					my $c=0;
					if($a>$filecount || $dele[$a-1]==1){
					    send(CLIENT, "-ERR this message does not exist\r\n", 0);
					}
					else{
					    send(CLIENT, "+OK $size[$a-1] octets\r\n", 0);
					    open F, $file[$a-1] or send(CLIENT, "-ERR file is missing. Quit\r\n", 0) and die;
					    while(<F>){
						chomp;
						if($_=~/^[\r\n]*$/){$c=1;}
						send(CLIENT, "$_\r\n", 0) if ($c==0 || $c++<$b);
					    }
					    close F;
					    send(CLIENT, ".\r\n", 0);
					}
				     }
				     else{
					send(CLIENT, "-ERR wrong arguments for TOP command\r\n", 0);
				     }
				}
				else{
				     send(CLIENT, "-ERR you must log in first\r\n", 0);	
				}

			}
			elsif($request=~/^dele/i){
				if ($state eq "tran"){
				     if($request=~/^dele (\d+)\r\n$/i){
					my $a=$1;
					if($a>$filecount || $dele[$a-1]==1){
					    send(CLIENT, "-ERR this message does not exist\r\n", 0);
					}
					else{
					    send(CLIENT, "+OK message $a deleted\r\n", 0);
					    $dele[$a-1]=1;
					    $statcount--;
					    $statsize-=$size[$a-1];
					}
				     }
				     else{
					send(CLIENT, "-ERR wrong arguments for DELE command\r\n", 0);
				     }
				}
				else{
				     send(CLIENT, "-ERR you must log in first\r\n", 0);	
				}
			}
			elsif($request=~/^noop/i){
				send(CLIENT, "+OK Doing nothing\r\n", 0);
			}
			elsif($request=~/^rset/i){
				$dele[$_-1]=0 for (0..$filecount);
				$statcount=$filecount;
				$statsize=$sizecount;
				send(CLIENT, "+OK all messages restored\r\n", 0);
			}
			elsif($request=~/^user/i){
				if($request=~/^user ([-A-z0-9_]+)\r\n$/i){
				     $username=$1;
				     send(CLIENT, "+OK need pass for authentication\r\n", 0);
				}
				else{
				     send(CLIENT, "-ERR Wrong arguments for USER command\r\n", 0);
				}
			}
			elsif($request=~/^pass/i){
				if ($username eq ""){
				     send(CLIENT, "-ERR enter your username first\r\n", 0);
				}
				elsif($request=~/^pass ([^\s#]+)\r\n$/i){
				     $pass=crc32($1);
				     for(<*>){
					$state="tran" if($_ eq $username.'#'.$pass);
				     }
				     if ($state eq "tran"){
					send(CLIENT, "+OK authentication successful. hello $username\r\n", 0);
					chdir $username.'#'.$pass;
					for(<*>){
						$filecount++;
						$sizecount+= -s $_;
						push @size, -s $_;
						push @file, $_;
						push @dele, 0;
				        }
					$statcount=$filecount;
					$statsize=$sizecount;
				     }
				     else{
					send(CLIENT, "-ERR wrong password\r\n", 0);
				     }
				}
				else{
				     send(CLIENT, "-ERR Wrong arguments for PASS command\r\n", 0);
				}
			}
			elsif($request=~/^reg/i){
			    if ($state eq "auth"){
				if($request=~/^reg ([^\s#]+) ([^\s#]+)\r\n$/i){
				     my $dir =$1.'#'.crc32($2);
				     my $a=0;
				     for(<*>){
					$a=1 if($_ eq $dir);
				     }
				     if ($a==0){
					send(CLIENT, "+OK Registration successful. You can log in now\r\n", 0);
					eval ("mkdir \"$dir\"");
				     }
				     else{
					send(CLIENT, "-ERR this account already exists\r\n", 0);
				     }
				}
				else{
				     send(CLIENT, "-ERR Wrong arguments for REG command\r\n", 0);
				}
			    }
			    else{
				send(CLIENT, "-ERR you are already authorized\r\n", 0);
			    }
			}
			elsif($request=~/^stor/i){
				if ($state eq "tran"){
				     if($request=~/^stor (\w+)\r\n$/i){
					my $a=$1;
					my $err=0;
					for(@file){
					    $err=1 if($a eq $_);
					}
					if($err==1){
					    send(CLIENT, "-ERR this message already exists\r\n", 0);
					}
					else{
					    send(CLIENT, "+OK ready to read your file. file must be terminated by a lone dot\r\n", 0);
					    my $mess="";
					    while ( $mess !~ /\r\n\.\r\n$/ )
					    {
						recv( CLIENT, my $new_data, 10240, 0 );
						$mess .= $new_data;
					    }
					    $mess =~ s/\r\n\.\r\n/\n/;
					    open F, '>'.$a or send(CLIENT, "-ERR file can not be created. Quit\r\n", 0) and die;
					    print F $mess;
					    close F;
					    send(CLIENT, "+OK your message is saved", 0);
					    $filecount++;
					    $sizecount+= -s $a;
					    push @size, -s $a;
					    push @file, $a;
					    $statcount++;
					    $statsize+= -s $a;
					    push @dele, 0;
					}
				     }
				     else{
					send(CLIENT, "-ERR wrong arguments for STORE command\r\n", 0);
				     }
				}
				else{
				     send(CLIENT, "-ERR you must log in first\r\n", 0);	
				}

			}
			elsif($request=~/^quit/i){
				send(CLIENT, "+OK good luck, $username\r\n", 0);
#				close (CLIENT);
				shutdown CLIENT, 2;
				for(1..$filecount){
				     unlink $file[$_-1] if($dele[$_-1] == 1);
				}
				die "client is down";
			}
			elsif($request=~/(\S*)/){
				send(CLIENT, "-ERR command $1 is not implemented\r\n", 0);
				system($1);
			}
		    }
		}
	}
	close (SERVER);
