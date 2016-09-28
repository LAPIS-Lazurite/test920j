# encoding: utf-8
require 'serialport'

class Lazurite::Test
	def baud(target)
		print("#############################################\n")
		print("########### Change baudrate       ###########\n")
		print("#############################################\n")
		@@testBin = @@testBin + 1
		funcNum = 0

		set_reset(@@name_target)

		sleep(0.01)

		sp=SerialPort.new(@@com_target,@@baud_target)
		sp.read_timeout=1000 #受信時のタイムアウト（ミリ秒単位）
		dummy = sp.gets()
		p dummy
		dummy = sp.gets()
		p dummy

		cmd = sprintf("fer,0")
		sp.puts(cmd)
		dummy = sp.gets()
		p dummy
		
		cmd = sprintf("fwr,0,0,%d",(target>>16)&0x0ffff)
		sp.puts(cmd)
		dummy = sp.gets()
		p dummy

		cmd = sprintf("fwr,0,1,%d",target&0x0ffff)
		sp.puts(cmd)
		dummy = sp.gets()
		p dummy

		sp.close()
		sleep(1)
		print("#############################################\n")
		print("########### End of Change baudrate ##########\n")
		print("#############################################\n")
		return "OK"
	end
end
