#! /usr/bin/ruby

require './subghz.rb'

class Rftp::Test
	def set_addr
        sbg = Subghz.new()

        sbg.com("ewp 0")

        print("Fly:  0x001D12D00400001E <-> 0x001D12D004003FFF\n")
        print("Mini: 0x001D12D004004000 <-> 0x001D12D004007FFF\n")
        print("Input own addres LSB 16bits (ex:10 0A)= ")
        val = gets().split(" ")
        cmd = "ewr 38 0x" + val[0].to_s
        p sbg.com(cmd)	#short addr H
        cmd = "ewr 39 0x" + val[1].to_s
        p sbg.com(cmd)	#short addr L

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
    end
end
