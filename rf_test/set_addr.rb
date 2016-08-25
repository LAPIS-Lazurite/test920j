#! /usr/bin/ruby

require './openif.rb'

$sp.puts("ewp 0")
p $sp.gets()

print("Fly:  0x001D12D00400001E <-> 0x001D12D004003FFF\n")
print("Mini: 0x001D12D004004000 <-> 0x001D12D004007FFF\n")
print("Input own addres LSB 16bits (ex:10 0A)= ")
val = gets().split(" ")
cmd = "ewr 38 0x" + val[0].to_s
$sp.puts(cmd)	#short addr H
p $sp.gets()
cmd = "ewr 39 0x" + val[1].to_s
$sp.puts(cmd)	#short addr L
p $sp.gets()

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

$sp.puts("ewp 1")
p $sp.gets()

$sock.close
$sp.close
