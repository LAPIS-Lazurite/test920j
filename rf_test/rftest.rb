#! /usr/bin/ruby

require './Rftp.rb'
require './Telectp.rb'
require 'logger'
require 'fileutils'

@@rftp = Rftp::Test.new
@@telectp = Telectp::Test.new

class Rftest

    # 2017.10.4  6.1->7.9
	@@ATT = "7.9"

    def led
        @@rftp.led("blue");
    end


    def calib
        if File.exist?("temp.log") == true then
            File.delete("temp.log")
        end
        $log = Logger.new("| tee temp.log")
#       $log = Logger.new(STDOUT)
#       $log.level = Logger::INFO
        @@rftp.e2p_base()
        @@rftp.calibration(@@ATT)
    end

	def pretest
        @@telectp._00_MS2830A_init()
        @@telectp._09_Career_sense(@@ATT)
        system("mpg321 ../mp3/beep.mp3")
	end
    

	def postest
        if File.exist?("temp.log") == true then
            File.delete("temp.log")
        end
        $log = Logger.new("| tee temp.log")
#       @@rftp.begin_subghz()
        @@telectp._00_MS2830A_init()
        @@telectp._01_Tolerance_of_occupied_bandwidth_Frequency_range()
        @@telectp._02_Tolerance_of_frequency()
        @@telectp._03_Antenna_power_point(@@ATT)
        @@telectp._04_Antenna_power_ave(@@ATT)
#       @@telectp._05_Tolerance_of_spurious_unwanted_emission_intensity_far()
        @@telectp._06_Tolerance_of_spurious_unwanted_emission_intensity_near()
        @@telectp._07_Tolerance_off_adjacent_channel_leakage_power()
#       @@telectp._08_Limit_of_secondary_radiated_emissions()
        # 2017.10.4  @@ATT -> 6.5
#       @@telectp._09_Career_sense(@@ATT)
        @@telectp._09_Career_sense(6.5)
        @@telectp._10_Spectrum_emission_mask()
    end

	def setbarcode
        t = Time.now
        date = sprintf("%04d%02d%02d%02d%02d_",t.year,t.mon,t.mday,t.hour,t.min)
        logfilename = @@rftp.set_addr()
        logfilename = "/home/pi/test920j/Log/" + date + logfilename + ".log"
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



	def telec
        if File.exist?("temp.log") == true then
            File.delete("temp.log")
        end
        $log = Logger.new("| tee temp.log")
		Dir.chdir "./TelecLib"
		while 1
			print("====================== TELEC MENU =======================\n")
			p = Dir.glob("*")
			p.sort.each{|d| puts "" + d + "\n" }
			print("99.Exit\n")
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
			when 11
			    print("unsupported\n")
			when 12
			    print("unsupported\n")
			when 13
			    print("unsupported\n")
            else
				break
			end
		end
		Dir.chdir "../"
	end

	def menu

        if File.exist?("temp.log") == true then
            File.delete("temp.log")
        end
        $log = Logger.new("| tee temp.log")

		while 1
			system("pwd")
			print("~~~~~~~~~~~~~~~~~~~ rf command ~~~~~~~~~~~~~~~~\n")
			print("1:   Write basic parameter to E2P\n")
			print("2:   Calibration\n")
			print("3:   Continuous Wave\n")
			print("4:   Send packet\n")
			print("5:   Carrier Sense\n")
			print("10:  Set my address\n")
			print("11:  Get my address\n")
			print("20:  Direct Command\n")
			print("99:  Exit\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("input number => ")
			input = gets().to_i

			case input
			when 1
				@@rftp.e2p_base()
			when 2
				@@rftp.calibration(@@ATT)
			when 3
				@@rftp.cw()
			when 4
				@@rftp.snd()
			when 5
				@@rftp.cca()
			when 10
				@@rftp.set_addr()
			when 11
				@@rftp.get_addr()
			when 20
				@@rftp.command()
            else
				break
			end
		end
	end

end
