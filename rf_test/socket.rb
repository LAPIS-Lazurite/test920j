#! /usr/bin/ruby

require 'socket'


  # Process at the time of SIGINT Receiving
  Signal.trap(:INT){
    finish_flag=1
  }

$sock=TCPSocket.open("192.168.11.6",49153)
$sock.puts("*IDN?")
p $sock.gets
$sock.puts("syst:lang nat")
