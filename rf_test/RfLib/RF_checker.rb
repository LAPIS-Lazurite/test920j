#! /usr/bin/ruby

require '/home/pi/test920j/rf_test/socket.rb'

class Rftp::Test
	def ms2830a_setting(ch,rate) 
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
	end

	def att_checker(ch,rate)
			# setup SG
			$sock.puts("inst sg")
			$sock.puts("*OPC?")
			$sock.gets

			$sock.puts("freq " + $frq[rate][ch])
			$sock.puts("*OPC?")
			$sock.gets

			$sock.puts("pow 0")
			$sock.puts("*OPC?")
			$sock.gets
			#SG out 1:ON  0:OFF
			$sock.puts("outp 1") 
			$sock.puts("*OPC?")
			$sock.gets
			# setup SPA
			$sock.puts("INST SPECT")
			$sock.puts("*OPC?")
			$sock.gets
			$sock.puts("mkpk")
			$sock.puts("*OPC?")
			$sock.gets
			$sock.puts("mkl?")
			val = $sock.gets.delete("-\r\n")
			# setup SG
			$sock.puts("inst sg")
			$sock.puts("*OPC?")
			$sock.gets
 			$sock.puts("outp 0") 
 			$sock.puts("*OPC?")
 			$sock.gets
			return val 
	end

	def freq_dev_checker(ch,rate)
			# setup SPA
			$sock.puts("INST SPECT")
			$sock.puts("*OPC?")
			$sock.gets
			$sock.puts("mkpk")
			$sock.puts("*OPC?")
			$sock.gets
			$sock.puts("mkf?")
			val = $sock.gets.delete("\r\n")
			p val.to_i
			dev = $frq[rate][ch].to_i - val.to_i
			printf("Target: %s kHz\n",$frq[rate][ch].to_i)
			printf("Measurement: %s kHz\n",val.to_i)
			printf("Deviation: %s Hz\n",dev)
			return dev.to_i
	end
end
