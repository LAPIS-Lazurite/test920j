#! /usr/bin/ruby

require '/home/pi/test920j/rf_test/subghz.rb'

class Rftp::Test
    def begin_subghz
        sbg = Subghz.new()
        # it's dummy, for wakeup
        sbg.setup(24,100,20)
    end

    def e2p_base(dev)
        sbg = Subghz.new()
        # it's dummy, for wakeup
        sbg.setup(24,100,20)
        sbg.com("ewp 0")

				# eeprom write :My addrress-------
				if dev != "MJ2001" then
					p sbg.com("ewr 32 0")	#0x00
					p sbg.com("ewr 33 29")	#0x1D
					p sbg.com("ewr 34 18")	#0x12
					p sbg.com("ewr 35 208")	#0xD0
					p sbg.com("ewr 36 4")	#0x04
					p sbg.com("ewr 37 0")	#0x00
				end

			 # init eeprom :0x28 -0x2f
				if dev == "MK74040" then
					p sbg.com("ewr 40 255")
					p sbg.com("ewr 41 255")
					p sbg.com("ewr 42 255")
					p sbg.com("ewr 43 255")
					p sbg.com("ewr 44 255")
					p sbg.com("ewr 45 255")
					p sbg.com("ewr 46 255")
					p sbg.com("ewr 47 255")
				else
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
				 #p sbg.com("ewr 130 19")	#RF_CNTRL_SET
					p sbg.com("ewr 130 00")	#RF_CNTRL_SET
				end

			 # init eeprom :0x80 -0xA0
				if dev == "MJ2001" then
					p sbg.com("ewr 160 05")
				elsif dev == "MK74040" then
					p sbg.com("ewr 128 255")
					p sbg.com("ewr 129 255")
					p sbg.com("ewr 130 255")
					p sbg.com("ewr 131 255")
					p sbg.com("ewr 132 255")
					p sbg.com("ewr 133 255")
					p sbg.com("ewr 134 255")
					p sbg.com("ewr 135 255")
					p sbg.com("ewr 160 160")
				else
					p sbg.com("ewr 160 255")
				end

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
    end

    def e2p_read
        sbg = Subghz.new()
        # it's dummy, for wakeup
        sbg.setup(24,100,20)
        sbg.com("ewp 0")

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
