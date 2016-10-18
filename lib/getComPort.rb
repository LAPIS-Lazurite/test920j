#! /usr/bin/ruby

require 'serialport'
class Lazurite::Test
###
#		find target device
#		return nil = can't find device
###
	def getComPort(target,tester)
		@@name_target = target
		@@name_tester = tester
		set_bootmode(@@name_tester)
		cycle = 0
		serial_baudrate = 115200
		#シリアルポート通信設定
		spName=["/dev/ttyUSB0","/dev/ttyUSB1"]
		sleep(0.1)
		sp0 = SerialPort.new(spName[0], serial_baudrate)
		sp1 = SerialPort.new(spName[1], serial_baudrate)
		sp = [sp0,sp1]
		sp[0].read_timeout=1000 #受信時のタイムアウト（ミリ秒単位）
		sp[1].read_timeout=1000 #受信時のタイムアウト（ミリ秒単位）
		i=0
		while (cycle < 100) && (@@halt == 0) do
			i=0
			data = sp[i].gets()
			if data == "C" then 
				break
			end
			cycle = cycle + 1
			i=1
			data = sp[i].gets()
			if data == "C" then 
				break
			end
			cycle = cycle + 1
		end
		if (cycle >= 100) || ( @@halt != 0) then 
			set_reset(target)
			set_reset(tester)
			return nil
		end
		sp[0].close()
		sp[1].close()

		set_reset(target)
		set_reset(tester)

		if i == 0 then
			@@com_tester = spName[0]
			@@com_target = spName[1]
#			return spName[0],spName[1]
		else
			@@com_tester = spName[1]
			@@com_target = spName[0]
#			return spName[1],spName[0]
		end
		return @@com_tester,@@com_target 
	end
end

