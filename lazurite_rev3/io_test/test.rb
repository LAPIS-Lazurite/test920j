#! /usr/bin/ruby
#
# Halt process when CTRL+C is pushed.

require 'serialport'
require './lib/Lazurite'

@finish_flag=0
Signal.trap(:INT){
	@finish_flag=1
	test.set_halt()
}

test = Lazurite::Test.new

printf("step1: writing authorization code in USB device\n");
result = test.auth_write("LAPIS","LAZURITE Sub-GHz Rev3")
p result
if(result != "OK") then
	p result[0],result[1],result[3]
	exit 0
end


printf("\n");
printf("step2: writing boot loader\n");

result = test.boot_write("LAZURITE Sub-GHz Rev3","bin/ML620Q504_000RA.bin")
p result
if(result != "OK") then
	p result[0],result[1],result[3]
	exit 0
end

printf("\n");
printf("step3: writing program for io test\n");
result = test.prog_write("LAZURITE Sub-GHz Rev3","bin/rev3_iotest.bin")
if(result != "OK") then
	p result[0],result[1],result[3]
else
	p result
end

printf("\n");
printf("step4: io test\n");
result = test.iotest("LAZURITE Sub-GHz Rev3")
if(result != "OK") then
	p result[0],result[1],result[3]
else
	p result
end

printf("\n");
printf("step5: writing initial program\n");
result = test.prog_write("LAZURITE Sub-GHz Rev3","bin/blue_led.bin")
if(result != "OK") then
	p result[0],result[1],result[3]
else
	printf("success!!\n");
	p result
end
