#!/usr/bin/perl
#----------------------------#
#  PROGRAM:  Client.pl       #
#  BY: Margheriti Romain     #
#  DATE: 9th, November, 2016 #
#----------------------------#

#Libaries
use Getopt::Long;
use IO::Socket;

#Default variables
$protocol = 'tcp';

#Arguments check
my %args;
GetOptions(\%args,
           "d=s" => \$host,
           "p=s" => \$port,
           "help",
           "h",
) or die "Invalid arguments.\nUsage : Client.pl -d host -p port [-h|-help].\n";
die "Missing -d. -h or -help to see usage\n" unless $host;
die "Missing -p. -h or -help to see usage\n" unless $port;

if ($args{h} != null || $args{help} != null) {
  print "Usage : Client.pl -d host -p port\n";
}

# auto-flush on socket
$| = 1;

# create a connecting socket
my $socket = new IO::Socket::INET (
    PeerHost => $host,
    PeerPort => $port,
    Proto => $protocol,
);
die "cannot connect to the server $!\n" unless $socket;
print "connected to the server\n";

  my $response = "";
  $socket->recv($response, 1024);
  my $timestamp = getLoggingTime();
  print "$timestamp: response from server: $response\n";

  while (1) {
    print "|>";
    $message = <>;
    $socket->send($message);

    # receive a response of up to 1024 characters from server
    my $response = "";
    $socket->recv($response, 1024);
    my $timestamp = getLoggingTime();
    print "\n$timestamp: response from server: $response\n";
  }

$socket->close();

#catch Ctrl-c
$SIG{INT} = sub {
  shutdown($socket, 2);
  die "Caught a sigint $!"
};

#timestamp
sub getLoggingTime {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
    my $nice_timestamp = sprintf ( "%02dh%02dm%02ds",$hour,$min,$sec);
    return $nice_timestamp;
}
