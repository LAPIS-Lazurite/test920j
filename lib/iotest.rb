# encoding: utf-8
require 'serialport'

class Lazurite::Test
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
		sp=SerialPort.new(@@com_target,115200)

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