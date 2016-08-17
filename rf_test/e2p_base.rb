#! /usr/bin/ruby

require './openif.rb'

$sp.puts("ewp 0")
p $sp.gets()

# eeprom write :My addrress-------
$sp.puts("ewr 32 0")	#0x00
p $sp.gets()
$sp.puts("ewr 33 29")	#0x1D
p $sp.gets()
$sp.puts("ewr 34 18")	#0x12
p $sp.gets()
$sp.puts("ewr 35 208")	#0xD0
p $sp.gets()
$sp.puts("ewr 36 4")	#0x04
p $sp.gets()
$sp.puts("ewr 37 0")	#0x00
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

# eeprom write :power & Frequencey ---------
#$sp.puts("ewr 41 167")	#PA_ADJ3
$sp.puts("ewr 41 119")	#PA_ADJ3
p $sp.gets()
$sp.puts("ewr 42 24")	#PA_REG_FINE_ADJ3
p $sp.gets()
#$sp.puts("ewr 43 123")	#PA_ADJ1
$sp.puts("ewr 43 119")	#PA_ADJ1
p $sp.gets()
$sp.puts("ewr 44 27")	#PA_REG_FINE_ADJ1
p $sp.gets()
$sp.puts("ewr 45 48")	#OSC_ADJ
p $sp.gets()
$sp.puts("ewr 46 39")	#PA_ADJ2
p $sp.gets()
$sp.puts("ewr 47 24")	#PA_REG_FINE_ADJ2
p $sp.gets()
$sp.puts("ewr 128 8")	#OSC_ADJ2
p $sp.gets()
$sp.puts("ewr 129 7")	#PA_REG_ADJ3
p $sp.gets()
$sp.puts("ewr 130 19")	#RF_CNTRL_SET
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
