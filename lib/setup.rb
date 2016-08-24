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

		funcNum = funcNum + 1
		sleep(0.1)
		cmd = "sudo stty -F /dev/ttyUSB0 115200"
		system(cmd)
		ret = $?.exitstatus
		print @@testBin,",",funcNum,",",cmd,",",ret,"\n"
		if ret != 0 then
			p @@testBin,funcNum,ret
			return @@testBin,funcNum,ret
		end

		funcNum = funcNum + 1
		cmd = sprintf("sudo sx -b %s > /dev/ttyUSB0 < /dev/ttyUSB0",program)
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
		cmd = sprintf("sudo ../lib/cpp/bootmode/bootmode \"%s\"",devName);
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
		cmd = sprintf("sudo ../lib/cpp/reset/reset \"%s\"",devName);
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
	def iotest(devName)
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
		cmd = sprintf("sudo ../lib/cpp/reset/reset \"%s\"",devName);
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

		sleep(0.1)
		funcNum = funcNum + 1
		sp=SerialPort.new('/dev/ttyUSB0',115200)

		funcNum = funcNum + 1
		sp.puts("pm,25,o")
		dummy = sp.gets()
		sp.puts("dw,25,0")
		dummy = sp.gets()
		puts("赤とオレンジのLEDが点灯していますか？")
		puts("y または nを入力してください")
		loop {
			msg = gets.to_s.chop
			if msg == "y" or msg == "Y" then
				break
			end
			if msg == "n" or msg == "N" then
				return @@testBin,funcNum,ret
			end
		}
		funcNum = funcNum + 1
		sp.puts("dw,25,1")
		dummy = sp.gets()
		sp.puts("dw,20,1")
		dummy = sp.gets()
		sp.puts("pm,26,o")
		dummy = sp.gets()
		sp.puts("dw,26,0")
		dummy = sp.gets()
		puts("青のLEDのみが点灯していますか？")
		puts("y または nを入力してください")
		loop {
			msg = gets.to_s.chop
			if msg == "y" or msg == "Y" then
				break
			end
			if msg == "n" or msg == "N" then
				return @@testBin,funcNum,ret
			end
		}

		input_pins =[2,3,4,5,6,7,8,14,15]
		eva_pins =  [17,16,9,10,11,12,13,18,19]

		funcNum = funcNum + 1
		for pin in input_pins
			cmd = sprintf("pm,%d,o",pin)
			sp.puts(cmd)
			dummy = sp.gets()
			cmd = sprintf("dw,%d,1",pin)
			sp.puts(cmd)
			dummy = sp.gets()
		end
		funcNum = funcNum + 1
		for pin in eva_pins
			cmd = sprintf("pm,%d,i",pin)
			sp.puts(cmd)
			dummy = sp.gets()
		end

		funcNum = funcNum + 1
		for i in 0..8
			cmd = sprintf("pm,%d,pd",input_pins[i])
			sp.puts(cmd)
			dummy = sp.gets()
			for j in 0..8
				cmd = sprintf("dr,%d",eva_pins[j])
				sp.puts(cmd)
				dummy = sp.gets().to_s.chop.split(",")
				if j==i and dummy[2]=="0" then
					next
				elsif dummy[2] == "1" then
					next
				else
					return @@testBin,funcNum,ret
				end
			end
			cmd = sprintf("pm,%d,o",input_pins[i])
			sp.puts(cmd)
			dummy = sp.gets()
		end

		funcNum = funcNum + 1
		for pin in input_pins
			cmd = sprintf("dw,%d,0",pin)
			sp.puts(cmd)
			dummy = sp.gets()
		end
		funcNum = funcNum + 1
		for i in 0..8
			cmd = sprintf("pm,%d,pu",input_pins[i])
			sp.puts(cmd)
			dummy = sp.gets()
			for j in 0..8
				cmd = sprintf("dr,%d",eva_pins[j])
				sp.puts(cmd)
				dummy = sp.gets().to_s.chop.split(",")
				if j==i and dummy[2]=="1" then
					next
				elsif dummy[2] == "0" then
					next
				else
					return @@testBin,funcNum,ret
				end
			end
			cmd = sprintf("pm,%d,o",input_pins[i])
			sp.puts(cmd)
			dummy = sp.gets()
		end
		sp.close()
		return "OK"
	end
end
