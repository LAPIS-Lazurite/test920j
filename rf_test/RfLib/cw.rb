#! /usr/bin/ruby

require './socket.rb'
require './subghz.rb'

class Rftp::Test
	def cw
        # DUT setup ------------------------------------
        print("input ch[24-61] => ")
        ch = gets().to_i
#       ch = 24
        print("input rate[100,50] => ")
        rate = gets().to_i
#       rate = 100
        print("input mode[20,1] => ")
        mode = gets().to_i
#       mode = 20
        print("input test mode[CW=21, PN9=03, non=00 => ")
        test = gets().to_s
#       test = "00".to_s

        pow_param = Struct.new(:mode, :level, :pa_addr, :pa_bit, :pa_max, :ep_addr)
        p1mW_mode = pow_param.new(1, 0, PA_ADJ1_ADDR, 0x01, 0x0f, "ewr 43 ")
        p20mW_mode = pow_param.new(20, 1300, PA_ADJ3_ADDR, 0x10, 0xf0, "ewr 41 ")
        @pow = {1  => p1mW_mode, 20 => p20mW_mode}

        sbg = Subghz.new()
        sbg.setup(ch, rate, mode)
        sbg.rw("8 0x0c ","0x" + test)
        sbg.txon()

        # TESTER setup ----------------------------------
        $sock.puts("*RST")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("INST SPECT")

        $sock.puts("spf 500khz")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("rlv 20")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("cnf " + $frq[rate][ch].to_s)
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("mkpk")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("mkf?")
        $sock.puts("*OPC?")
        value = $sock.gets
        p value

#       $sock.close
    end
end
