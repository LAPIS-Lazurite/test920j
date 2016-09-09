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
		p dummy
		p dummy
		for i in 2..8
			print(sprintf("port num = %d\n",i))
			cmd = sprintf("pm,%d,o",i)
			sp.puts(cmd)
			dummy = sp.gets()
			p dummy
			for j in 0..1000
				cmd = sprintf("dw,%d,0",i)
				sp.puts(cmd)
				dummy = sp.gets()
				sleep(0.01)
			end
		end
		for i in 2..8
			cmd = sprintf("pm,%d,o",i)
			p cmd
			sp.puts(cmd)
			dummy = sp.gets()
			p dummy
			if(enable)
				cmd = sprintf("dw,%d,0",i)
			else
				cmd = sprintf("dw,%d,1",i)
			end
			p cmd
			sp.puts(cmd)
			dummy = sp.gets()
			p dummy
			cmd = sprintf("dr,%d",i)
			p cmd
			sp.puts(cmd)
			dummy = sp.gets()
			p dummy
		end
		sp.close()
		sleep(1)
		return "OK"
	end
end
