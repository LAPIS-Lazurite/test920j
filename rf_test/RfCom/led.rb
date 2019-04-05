#! /usr/bin/ruby

require './subghz.rb'


class Rftp::Test
	def led(clr)
        clr ="blue"
        sbg = Subghz.new()
        loop do
        if clr == "blue" then
            sbg.com("dw,25,1")
            sbg.com("dw,20,1")
            sbg.com("pm,26,o")
            sbg.com("dw,26,0")
        elsif clr == "org" then
            sbg.com("pm,25,o")
            sbg.com("dw,25,0")
            sbg.com("dw,20,1")
        end
        sleep(1)
        sbg.com("dw,26,1")
        sbg.com("dw,25,1")
        sleep(1)
        end
    end
end
