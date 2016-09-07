#! /usr/bin/ruby

require './subghz.rb'

sbg = Subghz.new()

sbg.com("ewp 0")

# eeprom write :My addrress-------
p sbg.com("ewr 32 0")	#0x00
p sbg.com("ewr 33 29")	#0x1D
p sbg.com("ewr 34 18")	#0x12
p sbg.com("ewr 35 208")	#0xD0
p sbg.com("ewr 36 4")	#0x04
p sbg.com("ewr 37 0")	#0x00


print("Fly:  0x001D12D00400001E <-> 0x001D12D004003FFF\n")
print("Mini: 0x001D12D004004000 <-> 0x001D12D004007FFF\n")
print("Input own addres LSB 16bits (ex:10 0A)= ")
val = gets().split(" ")
cmd = "ewr 38 0x" + val[0].to_s
p sbg.com(cmd)	#short addr H
cmd = "ewr 39 0x" + val[1].to_s
p sbg.com(cmd)	#short addr L

sleep 1

# eeprom write :power & Frequencey ---------
#p sbg.com("ewr 41 167")	#PA_ADJ3
p sbg.com("ewr 41 119")	#PA_ADJ3
p sbg.com("ewr 42 24")	#PA_REG_FINE_ADJ3
#p sbg.com("ewr 43 123")	#PA_ADJ1
p sbg.com("ewr 43 119")	#PA_ADJ1
p sbg.com("ewr 44 27")	#PA_REG_FINE_ADJ1
p sbg.com("ewr 45 48")	#OSC_ADJ
p sbg.com("ewr 46 39")	#PA_ADJ2
p sbg.com("ewr 47 24")	#PA_REG_FINE_ADJ2
p sbg.com("ewr 128 8")	#OSC_ADJ2
p sbg.com("ewr 129 7")	#PA_REG_ADJ3
p sbg.com("ewr 130 19")	#RF_CNTRL_SET

sleep 1

# eeprom read -------------------
p sbg.com("erd 0 32")
p sbg.com("erd 32 32")
p sbg.com("erd 64 32")
p sbg.com("erd 96 32")
p sbg.com("erd 128 32")
p sbg.com("erd 160 32")
p sbg.com("erd 192 32")
p sbg.com("erd 224 32")
p sbg.com("erd 256 32")

sbg.com("ewp 1")
