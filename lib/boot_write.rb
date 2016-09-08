require 'serialport'

class Lazurite::Test
	def boot_write(devName,program)
		@@testBin = @@testBin + 1
		funcNum = 0
		cmd = "sudo rmmod ftdi_sio"
		system(cmd)

		cmd = "sudo rmmod usbserial"
		system(cmd)

		funcNum = funcNum+1
		cmd = sprintf("sudo ../lib/cpp/bootwriter/bootwriter 0 LAPIS \"%s\" %s 0xf000 0xfc4f",devName,program)
		system(cmd)
		ret = $?.exitstatus
		if ret == 0 then
			return "OK"
		end
		return @@testBin,funcNum,ret
	end
end
