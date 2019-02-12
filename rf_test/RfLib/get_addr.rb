#! /usr/bin/ruby

require '/home/pi/test920j/rf_test/subghz.rb'

class Rftp::Test
	def get_addr
        sbg = Subghz.new()

        # it's dummy, for wakeup
        sbg.setup(24,100,20)

        myaddr = sbg.ra()
        printf("My address: %#2.4x\n", myaddr[1])
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
