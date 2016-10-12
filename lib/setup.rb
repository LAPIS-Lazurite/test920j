# encoding: utf-8
require 'serialport'

class Lazurite::Test
	@@testBin = 0
	@@halt = 0
	kern = `uname -r`
	@@kernel = "/lib/modules/"+kern.chomp
	p @@kernel
	@@com_tester = nil 
	@@name_tester = nil 
	@@com_target = nil 
	@name_target =  nil
	@@baud_target =  115200

	def getMiniPortName()
		return @@miniPortName
	end

	def set_halt()
		@@halt = 1
	end

	def setTarget(comPort)
		@@com_target = comPort
	end
	def setBaud(baud)
		@@baud_target = baud
	end
	def setTestBin(bin)
		@@testBin = bin
	end
end
