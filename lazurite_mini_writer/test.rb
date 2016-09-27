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

printf("step1: writing authorization code in USB device\n");
result = test.auth_write("LAPIS","LAZURITE mini series")
p result
if(result != "OK") then
	p result[0],result[1],result[3]
	exit 0
end


printf("\n");
printf("step2: writing boot loader\n");

result = test.boot_write("LAZURITE mini series","bin/ML620Q504_000RA.bin")
p result
if(result != "OK") then
	p result[0],result[1],result[3]
	exit 0
end

test.setTarget("/dev/ttyUSB0")

printf("\n");
printf("step3: writing program for io test\n");
result = test.prog_write("LAZURITE mini series","bin/blue_led.bin")
if(result != "OK") then
	p result[0],result[1],result[3]
else
	p result
end

printf("ok\n");
