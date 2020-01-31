#! /usr/bin/ruby

require '/home/pi/test920j/rf_test/socket.rb'
require "serialport"

$finish_flag=0
Signal.trap(:INT){
	$finish_flag=1
}

class Rftp::Test

	def read_ed_value
			$sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) 
			sleep 0.1
			$sp.puts("sgi")
			p $sp.gets()
			sleep 0.1
			$sp.puts("sgb 42 0xabcd 100 20")
			p $sp.gets()
			sleep 0.1
			$sp.puts("rfw 8 0x6c 0x06")
			p $sp.gets()
			sleep 0.1
			$sp.puts("rfr 8 0x6c")
			p $sp.gets()
			sleep 0.1
			$sp.puts("rfr 8 0x16")
			p $sp.gets()
			sleep 0.1
			$sp.close
	end

	def add_wave 
			ch = 42
			rate = 100
      sg_amp = "-25"
			offset = [0, -100000, 100000]

			# setup SPA
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

			# setup SG
			$sock.puts("inst sg")
			$sock.puts("*OPC?")
			$sock.gets

			$sock.puts("outp 1") 				#SG out 1:ON  0:OFF
			$sock.puts("*OPC?")
			$sock.gets

			$sock.puts("freq " + ($frq[rate][ch].to_i + offset[0]).to_s)
			$sock.puts("*OPC?")
			$sock.gets

			$sock.puts("pow " + sg_amp)				#output level 
			$sock.puts("*OPC?")
			$sock.gets

			$sock.puts("pow?")
			$sock.puts("*OPC?")
			p $sock.gets
	end

	def ed_adj
			add_wave()
			while $finish_flag == 0 do
				read_ed_value()
				sleep 1
			end
	end

end
