#! /usr/bin/ruby

require './openif.rb'

  # Process at the time of SIGINT Receiving
  Signal.trap(:INT){
    finish_flag=1
  }

msg = $sock.puts("REBOOT")
p msg

$sock.close
$sp.close
