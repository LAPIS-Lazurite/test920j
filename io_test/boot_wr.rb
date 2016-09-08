#! /usr/bin/ruby
#
# Halt process when CTRL+C is pushed.

require 'serialport'
require '../lib/Lazurite'

@finish_flag=0
Signal.trap(:INT){
	@finish_flag=1
	test.set_halt()
}

test = Lazurite::Test.new
result = test.boot_write("LAZURITE mini series","bin/ML620Q504_000RA.bin")
p result
if(result != "OK") then
	p result[0],result[1],result[3]
	exit 0
end
