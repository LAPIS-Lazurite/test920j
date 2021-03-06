#! /usr/bin/ruby
#
# Halt process when CTRL+C is pushed.

require 'serialport'
require '../lib/Lazurite'

@finish_flag=0
Signal.trap(:INT){
	@finish_flag=1
	$test.set_halt()
}

$test = Lazurite::Test.new

def iotest()
	$test.setTestBin(0)
	result = $test.pwr(true)
	if(result != "OK") then
		print(" Power on fail%d %d %d!!\n",result[0],result[1],result[2])
		return
	else
		p result
	end
	
	sleep(1)

	result = $test.prog_write("LAZURITE mini series","../bin/test.bin")
	if(result != "OK") then
		printf(" Program write Fail %d %d %d!!\n",result[0],result[1],result[2])
		return
	else
		p result
	end
	
	result = $test.iotest()
	if(result != "OK") then
		printf(" IO Test Fail %d pin error!!\n",result[2])
		return
	else
		p result
	end
	
	result = $test.baud(9600)
	if(result != "OK") then
		p result[0],result[1],result[3]
		printf(" Set baudrate fail %d %d %d!!\n",result[0],result[1],result[2])
		return
	else
		p result
	end
	
	result = $test.pwr(false)
	if(result != "OK") then
		printf(" Power off fail %d %d %d!!\n",result[0],result[1],result[2])
		return
	else
				printf("#############################################\n")
				printf("###########      PASS!!           ###########\n")
				printf("###########      End of TEST      ###########\n")
				printf("#############################################\n")
	end
end
def alltest()
	$test.setTestBin(0)
	result = $test.pwr(true)
	if(result != "OK") then
		print(" Power on fail%d %d %d!!\n",result[0],result[1],result[2])
		return
	else
		p result
	end
	
	sleep(1)
	
	result = $test.boot_write("LAZURITE mini series","../bin/ML620Q504_000RA.bin")
	p result
	if(result != "OK") then
		printf(" Bootloader program Fail %d %d %d!!\n",result[0],result[1],result[2])
		return
	end
	
	sleep(0.1)
	
	result = $test.prog_write("LAZURITE mini series","../bin/test.bin")
	if(result != "OK") then
		printf(" Program write Fail %d %d %d!!\n",result[0],result[1],result[2])
		return
	else
		p result
	end
	
	result = $test.iotest()
	if(result != "OK") then
		printf(" IO Test Fail %d pin error!!\n",result[2])
		return
	else
		p result
	end
	
	result = $test.baud(9600)
	if(result != "OK") then
		p result[0],result[1],result[3]
		printf(" Set baudrate fail %d %d %d!!\n",result[0],result[1],result[2])
		return
	else
		p result
	end
	
	result = $test.pwr(false)
	if(result != "OK") then
		printf(" Power off fail %d %d %d!!\n",result[0],result[1],result[2])
		return
	else
				printf("#############################################\n")
				printf("###########      PASS!!           ###########\n")
				printf("###########      End of TEST      ###########\n")
				printf("#############################################\n")
	end
end

# main 
printf("#################################################\n")
printf("################ Start IO test program ##########\n")
printf("#################################################\n")
printf(" getting usbserial information. Please wait......\n")
printf("\n")
printf("\n")
printf("\n")
result = $test.getComPort("LAZURITE mini series","LAZURITE Sub-GHz Rev3")
if(result == nil) then
	exit
else
	p result
end

while 1
	printf(" Ready for test!!!\n ")
	printf("test menue.......\n")
	printf("    1:  all test\n")
	printf("    2:  io test\n")
	printf("   10:  set baudrate\n")
	printf("   99:  exit\n")
	printf("Please input number:")
	input = gets().to_s
	printf("\n")
	if input == "1\n" then
		alltest()
	elsif input == "2\n" then
		iotest()
	elsif input == "10\n" then
		printf("please input baudrate: ")
		input = gets().to_s
		$test.setBaud(input.to_i)
	elsif input == "99\n" then
		break
	end
end


