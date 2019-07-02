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

class Iotest

	def shutdown()
		result = $test.pwr(false)
	end

	def startup()
		$test.setTestBin(0)
		result = $test.pwr(true)
		if(result != "OK") then
			print(" Power on fail%d %d %d!!\n",result[0],result[1],result[2])
			return result
		else
			p result
		end
        return
	end

	def writeprog

        sleep(0.5)

        result = $test.boot_write("LAZURITE mini series","../bin/ML620Q504_000RA.bin")
        p result
        if(result != "OK") then
            printf(" Bootloader program Fail %d %d %d!!\n",result[0],result[1],result[2])
            return result
        end
        
        sleep(1)
        
        result = $test.prog_write("LAZURITE mini series","../bin/test.bin")
        if(result != "OK") then
            printf(" Program write Fail %d %d %d!!\n",result[0],result[1],result[2])
            return result
        else
            p result
        end
        return
	end


	def alltest

        system("mpg321 ../mp3/beep.mp3")

		result = $test.iotest()
		if(result != "OK") then
			printf(" IO Test Fail %d pin error!!\n",result[2])
			return result
		else
			p result
		end
		
        printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
        printf("!!! 基盤上のリセットスイッチを押して赤色LED点灯を確認して下さい。!!!\n")
        printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
        gets()

		result = $test.baud(115200)
		if(result != "OK") then
			p result[0],result[1],result[3]
			printf(" Set baudrate fail %d %d %d!!\n",result[0],result[1],result[2])
			return result
		else
			p result
		end
		
#    	result = $test.pwr(false)
#		if(result != "OK") then
#			printf(" Power off fail %d %d %d!!\n",result[0],result[1],result[2])
#			return result
#		else
#           printf("#############################################\n")
#           printf("###########      PASS!!           ###########\n")
#           printf("###########      End of TEST      ###########\n")
#           printf("#############################################\n")
#		end
        return
	end

	def setCom
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
		return result[1]
	end
end
