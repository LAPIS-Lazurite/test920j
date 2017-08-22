#! /usr/bin/ruby

require './Rftp.rb'
require './Telectp.rb'
require 'logger'
require 'fileutils'

@@rftp = Rftp::Test.new
@@telectp = Telectp::Test.new

class Rftest

	@@ATT = "6.1"

    def led
        @@rftp.led("blue");
    end


	def pretest
        if File.exist?("temp.log") == true then
            File.delete("temp.log")
        end
        printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
        printf("!!! 基盤上のリセットスイッチを押して赤色LED点灯を確認して下さい。!!!\n")
        printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
        gets()
        $log = Logger.new("| tee temp.log")
#       $log = Logger.new(STDOUT)
#       $log.level = Logger::INFO

        @@rftp.e2p_base()
        @@rftp.calibration(@@ATT)
        @@telectp._00_MS2830A_init()
        @@telectp._09_Career_sense(@@ATT)

        system("mpg321 ../mp3/beep.mp3")
#       led_thread = Thread.new(&method(:led))
#       endmsg = Thread.new do
#       printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
#       printf("!!! 正常に終了しました                                           !!!\n")
#       printf("!!! 基盤上のリセットスイッチを押して赤色LED点灯を確認して下さい。!!!\n")
#       printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
#       gets()
#       Thread.kill(led_thread)
#       end
#       led_thread.join
#       endmsg.join
	end
    

	def postest(cal_flg)

        if File.exist?("temp.log") == true then
            File.delete("temp.log")
        end
        printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
        printf("!!! 基盤上のリセットスイッチを押して赤色LED点灯を確認して下さい。!!!\n")
        printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
        gets()
        $log = Logger.new("| tee temp.log")
#       $log = Logger.new(STDOUT)
#       $log.level = Logger::INFO

        @@rftp.e2p_base()
        if cal_flg == 1 then @@rftp.calibration(@@ATT) end
        @@telectp._00_MS2830A_init()
        @@telectp._01_Tolerance_of_occupied_bandwidth_Frequency_range()
        @@telectp._02_Tolerance_of_frequency()
        @@telectp._03_Antenna_power_point(@@ATT)
        @@telectp._04_Antenna_power_ave(@@ATT)
#       @@telectp._05_Tolerance_of_spurious_unwanted_emission_intensity_far()
        @@telectp._06_Tolerance_of_spurious_unwanted_emission_intensity_near()
        @@telectp._07_Tolerance_off_adjacent_channel_leakage_power()
#       @@telectp._08_Limit_of_secondary_radiated_emissions()
        @@telectp._09_Career_sense(@@ATT)
        @@telectp._10_Spectrum_emission_mask()
        t = Time.now
        date = sprintf("%04d%02d%02d%02d%02d_",t.year,t.mon,t.mday,t.hour,t.min)
        logfilename = @@rftp.set_addr()
        logfilename = "Log/" + date + logfilename + ".log"
        File.rename('temp.log',logfilename)

        system("mpg321 ../mp3/beep.mp3")
#       led_thread = Thread.new(&method(:led))
#       endmsg = Thread.new do
#       printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
#       printf("!!! 正常に終了しました                                           !!!\n")
#       printf("!!! 基盤上のリセットスイッチを押して赤色LED点灯を確認して下さい。!!!\n")
#       printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
#       gets()
#       Thread.kill(led_thread)
#       end
#       led_thread.join
#       endmsg.join
	end


	def alltest(cal_flg)
        if File.exist?("temp.log") == true then
            File.delete("temp.log")
        end
        $log = Logger.new("| tee temp.log")
#       $log = Logger.new(STDOUT)
#       $log.level = Logger::INFO

        @@rftp.e2p_base()
        if cal_flg == 1 then @@rftp.calibration(@@ATT) end
        @@telectp._00_MS2830A_init()
        @@telectp._01_Tolerance_of_occupied_bandwidth_Frequency_range()
        @@telectp._02_Tolerance_of_frequency_full()
        @@telectp._03_Antenna_power_point_full(@@ATT)
        @@telectp._04_Antenna_power_ave(@@ATT)
#       @@telectp._05_Tolerance_of_spurious_unwanted_emission_intensity_far()
        @@telectp._06_Tolerance_of_spurious_unwanted_emission_intensity_near()
        @@telectp._07_Tolerance_off_adjacent_channel_leakage_power()
#       @@telectp._08_Limit_of_secondary_radiated_emissions()
        @@telectp._09_Career_sense(@@ATT)
        @@telectp._10_Spectrum_emission_mask()
        t = Time.now
        date = sprintf("%04d%02d%02d%02d%02d_",t.year,t.mon,t.mday,t.hour,t.min)
        logfilename = @@rftp.set_addr()
        logfilename = "Log/" + date + logfilename + ".log"
        File.rename('temp.log',logfilename)

        system("mpg321 ../mp3/beep.mp3")
#       led_thread = Thread.new(&method(:led))
#       endmsg = Thread.new do
        printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
#	    printf("!!! All the verification was pass                                !!!\n")
	    printf("!!! 正常に終了しました                                           !!!\n")
        printf("!!! 基盤上のリセットスイッチを押して赤色LED点灯を確認して下さい。!!!\n")
#       printf("!!! 青色LEDが点滅していることを確認しEnterしてください           !!!\n")
        printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
#       gets()
#       Thread.kill(led_thread)
#       end
#       led_thread.join
#       endmsg.join
	end


	def telec_menu
		Dir.chdir "./TelecLib"
#		while 1
			print("====================== TELEC MENU =======================\n")
			p = Dir.glob("*")
			p.sort.each{|d| puts "" + d + "\n" }
#			print("99.Exit\n")
			print("=========================================================\n")
			print("input number => ")
			input = gets().to_i

			case input
			when 0
				@@telectp._00_MS2830A_init()
			when 1
				@@telectp._01_Tolerance_of_occupied_bandwidth_Frequency_range()
			when 2
				@@telectp._02_Tolerance_of_frequency()
			when 3
				@@telectp._03_Antenna_power_point(@@ATT)
			when 4
				@@telectp._04_Antenna_power_ave(@@ATT)
			when 5
				@@telectp._05_Tolerance_of_spurious_unwanted_emission_intensity_far()
			when 6
				@@telectp._06_Tolerance_of_spurious_unwanted_emission_intensity_near()
			when 7
				@@telectp._07_Tolerance_off_adjacent_channel_leakage_power()
			when 8
				@@telectp._08_Limit_of_secondary_radiated_emissions()
			when 9
				@@telectp._09_Career_sense(@@ATT)
			when 10
				@@telectp._10_Spectrum_emission_mask()
#			when 99
#				break
			end
#		end
	end

	def menu

        if File.exist?("temp.log") == true then
            File.delete("temp.log")
        end
        $log = Logger.new("| tee temp.log")

#		while 1
			system("pwd")
			print("~~~~~~~~~~~~~~~~~~~~ Main Menu ~~~~~~~~~~~~~~~~\n")
			print("1: Load boot loader\n")
			print("2: Load test program\n")
			print("3: Write basic parameter for E2P\n")
			print("4: Execute calibration\n")
			print("10: Sub menu for TELEC-T245 certification\n")
			print("11: Execute all test\n")
			print("20: Continuous Wave\n")
			print("21: Send packet\n")
			print("22: Carrier Sense\n")
			print("30: Set my address\n")
			print("31: Get my address\n")
			print("32: Direct Command\n")
#			print("99: Exit\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("input number => ")
			input = gets().to_i

			case input
			when 1
				system("./boot_wr.rb")
			when 2
				system("./load_prog.rb " + "bin/test.bin mini")
			when 3
				@@rftp.e2p_base()
			when 4
				@@rftp.calibration(@@ATT)
			when 10
				telec_menu()
			when 11
				alltest(1)
			when 20
				@@rftp.cw()
			when 21
				@@rftp.snd()
			when 22
				@@rftp.cca()
			when 30
				@@rftp.set_addr()
			when 31
				@@rftp.get_addr()
			when 32
				@@rftp.command()
			when 99
#				break
			end
#		end
	end

end
