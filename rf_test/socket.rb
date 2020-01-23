#! /usr/bin/ruby

require 'socket'


  # Process at the time of SIGINT Receiving
  Signal.trap(:INT){
    finish_flag=1
  }

begin
	$sock=TCPSocket.open("10.9.20.8",49153)
rescue Exception => e
	$sock=TCPSocket.open("192.168.11.6",49153)
end
$sock.puts("*IDN?")
p $sock.gets
$sock.puts("syst:lang nat")
