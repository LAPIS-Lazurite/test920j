# encoding: utf-8
require 'serialport'

class Lazurite::Test
	def pwr(enable)
		print("#############################################\n")
		print("###########      Power Sequence   ###########\n")
		print("#############################################\n")
		@@testBin = @@testBin + 1
		funcNum = 0

		set_reset(@@name_tester)

		sleep(0.100)

		sp=SerialPort.new(@@com_tester,115200)
		sp.read_timeout=1000 #受信時のタイムアウト（ミリ秒単位）
		dummy = sp.gets()
		p dummy
		dummy = sp.gets()
		p dummy
		for i in 2..8
			cmd = sprintf("pm,%d,o",i)
			sp.puts(cmd)
			dummy = sp.gets()
			p dummy
			if(enable)
				cmd = sprintf("dw,%d,0",i)
			else
				cmd = sprintf("dw,%d,1",i)
			end
			sp.puts(cmd)
			dummy = sp.gets()
			p dummy
		end
		sp.close()
		if enable then
			print("#############################################\n")
			print("###########      Power ON         ###########\n")
			print("#############################################\n")
		else 
			print("#############################################\n")
			print("###########      Power OFF        ###########\n")
			print("#############################################\n")
		end
		return "OK"
	end
end
