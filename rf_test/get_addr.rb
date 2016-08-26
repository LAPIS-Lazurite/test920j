#! /usr/bin/ruby

require './openif.rb'

$sp.puts("sggma")
myaddr = $sp.gets().split(",")
printf("My address:%s", myaddr[1])
sleep(1)


# eeprom read -------------------
$sp.puts("erd 0 32")
p $sp.gets()
$sp.puts("erd 32 32")
p $sp.gets()
$sp.puts("erd 64 32")
p $sp.gets()
$sp.puts("erd 96 32")
p $sp.gets()
$sp.puts("erd 128 32")
p $sp.gets()
$sp.puts("erd 160 32")
p $sp.gets()
$sp.puts("erd 192 32")
p $sp.gets()
$sp.puts("erd 224 32")
p $sp.gets()
$sp.puts("erd 256 32")
p $sp.gets()


$sock.close
$sp.close
