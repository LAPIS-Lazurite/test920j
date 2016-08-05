require 'serialport'

class Lazurite::Test
	@@testBin = 0
	@@halt = 0
	@@miniPortName = nil
	@@subgPortName = nil
	kern = `uname -r`
	@@kernel = "/lib/modules/"+kern.chomp
	p @@kernel

	def getMiniPortName()
		return @@miniPortName
	end

	def set_halt()
		@halt = 1
	end
	def boot_write(devName,program)
		@@testBin = @@testBin + 1
		funcNum = 0
		cmd = "sudo rmmod ftdi_sio"
		system(cmd)

		cmd = "sudo rmmod usbserial"
		system(cmd)

		funcNum = funcNum+1
		cmd = sprintf("sudo ./lib/cpp/bootwriter/bootwriter 0 LAPIS \"%s\" %s 0xf000 0xfc4f",devName,program)
		system(cmd)
		ret = $?.exitstatus
		if ret == 0 then
			return "OK"
		end
		return @@testBin,funcNum,ret
	end
	def prog_write(devName,program)
		@@testBin = @@testBin + 1
		p "prog_write"
		funcNum = 0
		cmd = "sudo rmmod ftdi_sio"
		system(cmd)
		ret = $?.exitstatus

		funcNum = funcNum + 1
		cmd = "sudo rmmod usbserial"
		system(cmd)
		ret = $?.exitstatus

		funcNum = funcNum + 1
		cmd = sprintf("sudo ./lib/cpp/bootmode/bootmode \"%s\"",devName);
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

		funcNum = funcNum + 1
		@@miniPortName,@@subgPortName = getComPortName()
		print @@testBin,",",funcNum,",","miniPortName=",@@miniPortName,"\n"
		print @@testBin,",",funcNum,",","subgPortName=",@@subgPortName,"\n"
		if @@miniPortName ==nil then 
			p @@testBin,funcNum,ret
			return @@testBin,funcNum,ret
		end

		funcNum = funcNum + 1
		sleep(0.1)
		cmd = sprintf("sudo stty -F %s 115200",@@miniPortName)
		system(cmd)
		ret = $?.exitstatus
		print @@testBin,",",funcNum,",",cmd,",",ret,"\n"
		if ret != 0 then
			p @@testBin,funcNum,ret
			return @@testBin,funcNum,ret
		end

		funcNum = funcNum + 1
		cmd = sprintf("sudo sx -b %s > %s < %s",program,@@miniPortName,@@miniPortName)
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
		cmd = sprintf("sudo ./lib/cpp/reset/reset \"%s\"",devName);
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
	def set_bootmode(devName)
		@@testBin = @@testBin + 1
		funcNum = 0
		cmd = "sudo rmmod ftdi_sio"
		system(cmd)
		ret = $?.exitstatus

		funcNum = funcNum + 1
		cmd = "sudo rmmod usbserial"
		system(cmd)
		ret = $?.exitstatus

		funcNum = funcNum + 1
		cmd = sprintf("sudo ./lib/cpp/bootmode/bootmode \"%s\"",devName);
		system(cmd)
		ret = $?.exitstatus
		print @@testBin,",",funcNum,",",cmd,",",ret,"\n"
		if ret != 0 then
			p @@testBin,funcNum,ret
			return @@testBin,funcNum,ret
		end
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

	def set_reset(devName)
		@@testBin = @@testBin + 1
		funcNum = 0
		cmd = "sudo rmmod ftdi_sio"
		system(cmd)
		ret = $?.exitstatus

		funcNum = funcNum + 1
		cmd = "sudo rmmod usbserial"
		system(cmd)
		ret = $?.exitstatus

		funcNum = funcNum + 1
		cmd = sprintf("sudo ./lib/cpp/reset/reset \"%s\"",devName);
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
		return "OK"
	end

end
