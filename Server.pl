#!/usr/bin/perl
#----------------------------#
#  PROGRAM:  tp.pl           #
#  BY: Margheriti Romain     #
#  DATE: 9th, November, 2016 #
#----------------------------#

#Libaries
use Getopt::Long;
use IO::Socket;

#Default variables
$host = '0.0.0.0';
$port = '4242';
$protocol = 'tcp';
$listen = 5;
$reuse = 1;

#Arguments check
my %args;
GetOptions(\%args,
           "p=s" => \$port,
           "help",
           "h",
);

if ($args{h} != null || $args{help} != null) {
  print "Usage : Server.pl [-p] [PORT]\n";
}
# flush after every write
$| = 1;

# creating a listening socket
my $socket = new IO::Socket::INET (
    LocalHost => $host,
    LocalPort => $port,
    Proto => $protocol,
    Listen => $listen,
    Reuse => $reuse
);
die "cannot create socket $!\n" unless $socket;
print "server waiting for client connection on port $port\n";

while(1)
{
    # waiting for a new client connection
    my $client_socket = $socket->accept();

    # get information about a newly connected client
    my $client_address = $client_socket->peerhost();
    my $client_port = $client_socket->peerport();
    print "connection from $client_address:$client_port\n";

    # read up to 1024 characters from the connected client
    my $data = "";
    $client_socket->recv($data, 1024);
    print "received data: $data\n";

    # write response data to the connected client
    $data = "ok";
    $client_socket->send($data);

    # notify client that response has been sent
    shutdown($client_socket, 1);
}

$socket->close();
