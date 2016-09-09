# encoding: utf-8
require 'serialport'

class Lazurite::Test
	def prog_write(devName,program,setting=true)
		@@testBin = @@testBin + 1
		funcNum = 0
		if setting == true then
			cmd = "sudo rmmod ftdi_sio"
			system(cmd)
			ret = $?.exitstatus

			funcNum = funcNum + 1
			cmd = "sudo rmmod usbserial"
			system(cmd)
			ret = $?.exitstatus

			funcNum = funcNum + 1
			cmd = sprintf("sudo ../lib/cpp/bootmode/bootmode \"%s\"",devName);
			system(cmd)
			ret = $?.exitstatus
			print @@testBin,",",funcNum,",",cmd,",",ret,"\n"
			if ret != 0 then
				p @@testBin,funcNum,ret
				return @@testBin,funcNum,ret
			end

			funcNum = funcNum + 1
			cmd = "sudo insmod "+@@kernel+"/kernel/drivers/usb/serial/usbserial.ko"
			system(cmd)
			ret = $?.exitstatus
			print @@testBin,",",funcNum,",",cmd,",",ret,"\n"
			if ret != 0 then
				p @@testBin,funcNum,ret
				return @@testBin,funcNum,ret
			end

			funcNum = funcNum + 1
			cmd = "sudo insmod "+@@kernel+"/kernel/drivers/usb/serial/ftdi_sio.ko"
			system(cmd)
			ret = $?.exitstatus
			print @@testBin,",",funcNum,",",cmd,",",ret,"\n"
			if ret != 0 then
				p @@testBin,funcNum,ret
				return @@testBin,funcNum,ret
			end
		end

		funcNum = funcNum + 1
		sleep(0.1)
		cmd = "sudo stty -F " + @@com_target + " 115200"
		system(cmd)
		ret = $?.exitstatus
		print @@testBin,",",funcNum,",",cmd,",",ret,"\n"
		if ret != 0 then
			p @@testBin,funcNum,ret
			return @@testBin,funcNum,ret
		end

		funcNum = funcNum + 1
		cmd = sprintf("sudo sx -b %s > %s < %s",program,@@com_target,@@com_target)
		system(cmd)
		ret = $?.exitstatus
		print @@testBin,",",funcNum,",",cmd,",",ret,"\n"
		if ret != 0 then
			p @@testBin,funcNum,ret
			return @@testBin,funcNum,ret
		end

		funcNum = funcNum + 1
		cmd = "sudo rmmod ftdi_sio"
		system(cmd)
		ret = $?.exitstatus
		print @@testBin,",",funcNum,",",cmd,",",ret,"\n"
		if ret != 0 then
			p @@testBin,funcNum,ret
			return @@testBin,funcNum,ret
		end

		funcNum = funcNum + 1
		cmd = "sudo rmmod usbserial"
		system(cmd)
		ret = $?.exitstatus
		print @@testBin,",",funcNum,",",cmd,",",ret,"\n"
		if ret != 0 then
			p @@testBin,funcNum,ret
			return @@testBin,funcNum,ret
		end

		funcNum = funcNum + 1
		cmd = sprintf("sudo ../lib/cpp/reset/reset \"%s\"",devName);
		system(cmd)
		ret = $?.exitstatus
		print @@testBin,",",funcNum,",",cmd,",",ret,"\n"
		if ret != 0 then
			p @@testBin,funcNum,ret
			return @@testBin,funcNum,ret
		end

		funcNum = funcNum + 1
		cmd = "sudo insmod "+@@kernel +"/kernel/drivers/usb/serial/usbserial.ko"
		system(cmd)
		ret = $?.exitstatus
		print @@testBin,",",funcNum,",",cmd,",",ret,"\n"
		if ret != 0 then
			p @@testBin,funcNum,ret
			return @@testBin,funcNum,ret
		end

		funcNum = funcNum + 1
		cmd = "sudo insmod "+@@kernel+"/kernel/drivers/usb/serial/ftdi_sio.ko"
		system(cmd)
		ret = $?.exitstatus
		print @@testBin,",",funcNum,",",cmd,",",ret,"\n"
		if ret != 0 then
			p @@testBin,funcNum,ret
			return @@testBin,funcNum,ret
		end
		return "OK"
	end
end
