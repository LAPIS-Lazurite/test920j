#! /usr/bin/ruby

require './subghz.rb'

class Rftp::Test
	def get_addr
        sbg = Subghz.new()

        myaddr = sbg.ra()
        printf("My address:%#10.4x\n", myaddr[1])
        sleep(1)

        # eeprom read -------------------
        p sbg.com("erd,0,32")
        p sbg.com("erd,32,32")
        p sbg.com("erd,64,32")
        p sbg.com("erd,96,32")
        p sbg.com("erd,128,32")
        p sbg.com("erd,160,32")
        p sbg.com("erd,192,32")
        p sbg.com("erd,224,32")
        p sbg.com("erd,256,32")
    end
end
