#! /usr/bin/ruby

require './openif.rb'

$sp.puts("sggma")
myaddr = $sp.gets().split(",")
printf("My address:%s", myaddr[1])
sleep(1)

$sock.close
$sp.close
