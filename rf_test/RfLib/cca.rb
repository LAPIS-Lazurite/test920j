#! /usr/bin/ruby

require './socket.rb'
require './subghz.rb'

class Rftp::Test

	def cca

#print("input sg amp(ex:-74):")
#sg_amp = gets().to_s
        sg_amp = "-75"

        print("input cca level(default:0x55):")
        cca_lvl = gets().to_s

# setup DUT -------------------------------------------------
        print("Input loop count(ex:10)= ")
        loop=gets().to_i
        print("input ch[24-61] => ")
        ch = gets().to_i
        print("input rate[100,50] => ")
        rate = gets().to_i
#print("input mode[20,1] => ")
#mode = gets().to_i
        mode = 20

        pow_param = Struct.new(:mode, :level, :pa_addr, :pa_bit, :pa_max, :ep_addr)
        p1mW_mode = pow_param.new(1, 0, PA_ADJ1_ADDR, 0x01, 0x0f, "ewr 43 ")
        p20mW_mode = pow_param.new(20, 1300, PA_ADJ3_ADDR, 0x10, 0xf0, "ewr 41 ")
        @pow = {1  => p1mW_mode, 20 => p20mW_mode}


        offset = [0, -100000, 100000]

        sbg = Subghz.new()

# setup SPA --------------------------------------------------
        $sock.puts("*RST")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("inst spect")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("spf 10mhz")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("rlv 0")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("cnf " + $frq[rate][ch].to_s)
        $sock.puts("*OPC?")
        $sock.gets

# setup SG --------------------------------------------------
        for offset_loop in 0..2 

            $sock.puts("inst sg")
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("outp 1") 				#SG out 1:ON  0:OFF
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("freq " + ($frq[rate][ch].to_i + offset[offset_loop]).to_s)
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("pow " + sg_amp)				#output level 
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("pow?")
            $sock.puts("*OPC?")
            p $sock.gets


# Send Packet ------------------------------------------------
            sbg.setup(ch.to_s,rate.to_s,mode.to_s)
            sbg.rw("8 0x13 ",cca_lvl)

#sbg.rw("8 0x71 ","0x02")
#sbg.rw("8 0x75 ","0x23")

            sbg.wf()

            for i in 1..loop
                p sbg.com("sgs 0xffff 0xffff")
                sleep(0.5)
            end

            if rate.eql?(100) == false then
                break
            end
        end
    end
end
