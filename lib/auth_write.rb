# encoding: utf-8
require 'serialport'

class Lazurite::Test
	def auth_write(manuName,devName)
		@@testBin = @@testBin + 1
		funcNum = 0
		cmd = "sudo rmmod ftdi_sio"
		system(cmd)

		cmd = "sudo rmmod usbserial"
		system(cmd)

		funcNum = funcNum+1
		cmd = sprintf("sudo ../lib/cpp/auth/auth %s \"%s\"",manuName,devName)
		system(cmd)
		ret = $?.exitstatus
		if ret != 0 then
			return @@testBin,funcNum,ret
		end

		sleep(3)
		print "USBデバイスを一度抜いて、再度挿入してください。\n終了したらリターンを押してください。\n"
		STDOUT.flush
		result = gets.to_s.chop
		sleep(1)

		cmd = "sudo insmod "+@@kernel+"/kernel/drivers/usb/serial/usbserial.ko"
		system(cmd)
		cmd = "sudo insmod "+@@kernel+"/kernel/drivers/usb/serial/ftdi_sio.ko"
		system(cmd)

		return "OK"
	end
end
