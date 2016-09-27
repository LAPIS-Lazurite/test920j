# encoding: utf-8
require 'serialport'

class Lazurite::Test
	def targetOpen()
		@@testBin = @@testBin + 1
		funcNum = 0

		cmd = "sudo insmod "+@@kernel+"/kernel/drivers/usb/serial/usbserial.ko"
		system(cmd)

		funcNum = funcNum + 1
		cmd = "sudo insmod "+@@kernel+"/kernel/drivers/usb/serial/ftdi_sio.ko"
		system(cmd)

		funcNum = funcNum + 1
		p @@com_tester
		sp=SerialPort.new(@@com_tester,115200)
		#sp.read_timeout = 100
		dummy = sp.gets()
		p dummy
		dummy = sp.gets()
		p dummy

		sleep(0.010)

		for i in 2..8 do
			cmd = sprintf("pm,%d,o\r\n",i)
			sp.puts(cmd)
			dummy = sp.gets()
			p dummy
			if dummy == nil then
				return @@testBin,funcNum,0
			end

			sleep(0.001)

			cmd = sprintf("dw,%d,0\r\n",i)
			p cmd
			sp.puts(cmd)
			dummy = sp.gets()
			p dummy
			if dummy == nil then
				return @@testBin,funcNum,0
			end
			sleep(0.001)
		end

		sp.close()

		return "OK"
	end
end
