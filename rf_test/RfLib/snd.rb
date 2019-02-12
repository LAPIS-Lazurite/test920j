#! /usr/bin/ruby

require '/home/pi/test920j/rf_test/socket.rb'
require '/home/pi/test920j/rf_test/subghz.rb'


class Rftp::Test

	def snd
        sbg = Subghz.new()
#require ("tk")

#root = TkRoot.new
#root.title("TK sample widget")

#label = TkLabel.new
#label.text("test")
#label.pack("ipadx"=>1000, "ipady"=>100)
#label.background("#000080")
#label.foreground("#ffff00")
#
#TkButton.new do
#	command do
#		Tk.messageBox("type" => "yesno",
#			"title" => "wwwww","message" => "sssss")
#		Tk.getOpenFile("filetype" = > ["all", ".*"],"defaultextension" => ".rb")
#	end
#	pack
#end
#Tk.mainloop

        # DUT setup ------------------------------------
        print("Input loop count(ex:10)= ")
        loop=gets().to_i
        print("input ch[24-61] => ")
        ch = gets().to_i
        print("input rate[100,50] => ")
        rate = gets().to_i
        print("input mode[20,1] => ")
        mode = gets().to_i

        pow_param = Struct.new(:mode, :level, :pa_addr, :pa_bit, :pa_max, :ep_addr)
        p1mW_mode = pow_param.new(1, 0, PA_ADJ1_ADDR, 0x01, 0x0f, "ewr 43 ")
        p20mW_mode = pow_param.new(20, 1300, PA_ADJ3_ADDR, 0x10, 0xf0, "ewr 41 ")
        @pow = {1 => p1mW_mode, 20 => p20mW_mode}

        # TESTER control -----------------------------
        $sock.puts("*RST")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("inst spect")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("cnf " + $frq[rate][ch].to_s)
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("zerospan")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("rlv 20")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("trglvl -30")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("tdly -10")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("swe:time 0.2")
        $sock.puts("*OPC?")
        $sock.gets

# DUT send ------------------------------------
        sbg.setup(ch.to_s,rate.to_s,mode.to_s)
        sbg.wf()

        for i in 1..loop
            p sbg.com("sgs 0xffff 0xffff")
        end

#       $sock.close
    end
end
