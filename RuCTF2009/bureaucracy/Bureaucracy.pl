#!/usr/bin/perl -w

use POSIX;
use strict;
use Socket;
use Switch;
use MIME::Base64;

$SIG{CHLD} = 'IGNORE';

my $timer=0;
my $pid;
my $sock;

my $port=$ARGV[0]||11220;
++$|;

sub get {
  my $f=shift;
  $f=~s/[\r\n]//g;
  if (($f=~/\#(.).*/) && ($1 eq 2)){
    $f = unpack 'H*', $f;
    `gcc -o ./bureaucracy bureaucracy.c`;
    my $o=`./bureaucracy g $f`;
    send(CLIENT, $o, 0);
  }
  elsif (($f=~/\#(.).*/) && ($1 eq 3)){
    my $o=`java -cp external/mysql-connector-java-5.1.6.jar:. bureaucracy put $f`;
    send(CLIENT, "$o", 0);
  }
  else{
    open F, $f or do{send(CLIENT, "document $f is not avaliable", 0);shutdown (CLIENT, 2); die;};
    while(<F>){
      send(CLIENT, "$_", 0);
    }
    close F;
  }
  shutdown (CLIENT, 2);
  exit;
}

sub post {
  my @chars=('a'..'Z',0..9);
  my $idlength=16;
  my $request = shift;
  my $flag = $request;
  my $b='';
  my $id='';
  my $glid="\#";
  $glid.=$chars[int(rand(scalar @chars))] for(1..$idlength);
  while($flag){
    my $ch=0;
    $ch=1 if $flag=~/^\w+$/;
    my $cd = unpack 'H*', $flag;
    chop $cd if $ch!=1;
    $cd=~s/^(.)(.*)$/$2/;
    my $c=$1;
    my $g=int(hex($c)/4+1);
    $glid=~s/\#.(.*)/\#$g$1/;
    perl ($b, $c, $cd, $id, $glid, $g);
    $b=$c;
    $flag = pack 'H*', $cd;
    $id=$glid;
    $glid="\#";
    $glid.=$chars[int(rand(scalar @chars))] for(1..$idlength);
  }
  send(CLIENT, "$id\r\n", 0);
}

sub perl {
  my @chars=(0..9);
  my $x = '';
  $x.=$chars[int(rand(scalar @chars))] for(1..4);
  my ($b, $c, $d, $e, $f, $g) = @_;
  my $bcd = pack 'H*', $b.$c.$d;
  $e="\#" if $e eq'';

  switch(hex $c){
  case 0 {$c="passport\#$x";}
  case 1 {$c="certificate\#$x";}
  case 2 {$c="form\#$x";}
  case 3 {$c="policy\#$x";}

  case 4 {$c="$x USD";}
  case 5 {$c="$x Euro";}
  case 6 {$c="$x Rur";}
  case 7 {$c="$x candies";}

  case 8 {$c="driver license A $x";}
  case 9 {$c="driver license B $x";}
  case 10 {$c="driver license C $x";}
  case 11 {$c="driver license D $x";}

  case 12 {$c="tomorrow, at $x o'clock";}
  case 13 {$c="next week";}
  case 14 {$c="$x working days";}
  case 15 {$c="$x minutes";}
  }
  if ($g==2){
    system 'gcc -o ./bureaucracy bureaucracy.c';
    $bcd = unpack 'H*', $bcd;
    $e = unpack 'H*', $e;
    $f = unpack 'H*', $f;
    $c = unpack 'H*', $c;
    my $o = `./bureaucracy p $bcd $e $f $c`;
    send(CLIENT, "file can not be created:(", 0) if ($o=~/do/);
  }
  elsif ($g==3){
    $bcd = encode_base64 ($bcd);
    chomp $bcd;
   my $o =`java -cp external/mysql-connector-java-5.1.6.jar:. bureaucracy get $f $e $bcd $c`;
  }
  else{
    open F, ">$f" or do{  send(CLIENT, "operation is unavaliable", 0);shutdown(CLIENT, 2);die;};
    syswrite F, "$e\|$c\|$bcd";
    close F;
  }
}




$sock = socket(SERVER, AF_INET, SOCK_STREAM, getprotobyname('tcp')) or die "socket: $!";
die "Socket could not be created. Reason: $!\n" unless ($sock);
setsockopt(SERVER, SOL_SOCKET, SO_REUSEADDR, 1) or die "setsock: $!";
bind(SERVER, sockaddr_in($port, INADDR_ANY)) or die "bind: $!";
listen(SERVER, SOMAXCONN) or die "listen: $!";
print "SERVER started on port $port\n";
	
while (accept(CLIENT,SERVER)) {
  $pid = fork();
  die "Cannot fork: $!" unless defined($pid);
  if ($pid == 0) {
    $SIG{ALRM} = sub {   send(CLIENT, "time is out", 0); shutdown (CLIENT, 2); exit; };
    alarm 20;

    my $request="";
    while ( $request !~ /\r\n/ ){
      recv( CLIENT, my $new_data, 10240, 0 );
      $request .= $new_data;
    }
    if($request=~/^\w/){
      post($request);
    }

    elsif($request=~/^\#/){
      get($request);
    }
    else{
      send(CLIENT, "can you repeat?", 0);exec($request);
    }
    shutdown (CLIENT, 2);
    exit;
  }
}
close (SERVER);