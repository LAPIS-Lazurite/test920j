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

	def getMiniPortName()
		return @@miniPortName
	end

	def set_halt()
		@halt = 1
	end
end
