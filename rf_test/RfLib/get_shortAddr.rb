#! /usr/bin/ruby

require '/home/pi/test920j/rf_test/subghz.rb'


class Rftp::Test
	def get_shortAddr
        sbg = Subghz.new()

        # it's dummy, for wakeup
        sbg.setup(24,100,20)
        myaddr = sbg.ra()
        printf("My address: %#2.4x\n", myaddr[1])
        sleep(1)
#       return  "fadfadf"
        val = myaddr[1]
        return  "00" + val[2,4].to_s
    end
end
