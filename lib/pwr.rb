# encoding: utf-8
require 'serialport'

class Lazurite::Test
	def pwr(enable)
		@@testBin = @@testBin + 1
		funcNum = 0

		set_reset(@@name_tester)

		sp=SerialPort.new(@@com_tester,115200)
		sp.read_timeout=1000 #受信時のタイムアウト（ミリ秒単位）
		dummy = sp.gets()
		dummy = sp.gets()
		for i in 2..8
			cmd = sprintf("pm,%d,o",i)
			sp.puts(cmd)
			dummy = sp.gets()
			if(enable)
				cmd = sprintf("dw,%d,0",i)
			else
				cmd = sprintf("dw,%d,1",i)
			end
			sp.puts(cmd)
			dummy = sp.gets()
		end
		sp.close()
		sleep(1)
		return "OK"
	end
end
