#! /usr/bin/ruby

require './openif.rb'

$sp.puts("sggma")
myaddr = $sp.gets().split(",")
printf("My addrress:%s", myaddr[1])
sleep(1)

$sock.close
$sp.close
