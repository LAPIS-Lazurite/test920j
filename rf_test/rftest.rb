#! /usr/bin/ruby

require './Rftp.rb'
require './Telectp.rb'
require 'logger'
require 'fileutils'

@@rftp = Rftp::Test.new
@@telectp = Telectp::Test.new

class Rftest
#	@@ATT = "7.9"   #2nd lots was 6.1
	@@ATT = "4.9"   # atenneta UPD-2XB1
    def led
        @@rftp.led("blue");
    end

    def setlog
        if File.exist?("temp.log") == true then
            File.delete("temp.log")
        end
        $log = Logger.new("| tee temp.log")
#       $log = Logger.new(STDOUT)
#       $log.level = Logger::INFO
    end

    def calib
        @@rftp.e2p_base()
        val = @@rftp.calibration(@@ATT)
        return val
    end

	def pretest
        @@telectp._00_MS2830A_init()
        val = @@telectp._09_Career_sense(@@ATT)
#       system("mpg321 ../mp3/beep.mp3")
        return val
	end
    

	def postest
#       @@rftp.begin_subghz()
        @@telectp._00_MS2830A_init()
        val = @@telectp._01_Tolerance_of_occupied_bandwidth_Frequency_range()
        if val != nil then
            return val
        end
        val = @@telectp._02_Tolerance_of_frequency()
        if val != nil then
            return val
        end
        val = @@telectp._03_Antenna_power_point(@@ATT)
        if val != nil then
            return val
        end
        val = @@telectp._04_Antenna_power_ave(@@ATT)
        if val != nil then
            return val
        end
#       @@telectp._05_Tolerance_of_spurious_unwanted_emission_intensity_far()
        val = @@telectp._06_Tolerance_of_spurious_unwanted_emission_intensity_near()
        if val != nil then
            return val
        end
        val = @@telectp._07_Tolerance_off_adjacent_channel_leakage_power()
        if val != nil then
            return val
        end
#       @@telectp._08_Limit_of_secondary_radiated_emissions()
        val = @@telectp._09_Career_sense(@@ATT)
        if val != nil then
            return val
        end
        val = @@telectp._10_Spectrum_emission_mask()
        if val != nil then
            return val
        end
#       system("mpg321 -q ../mp3/beep.mp3")
        return
    end

	def trialtest
#       @@rftp.begin_subghz()
        @@telectp._00_MS2830A_init()
#       val = @@telectp._01_Tolerance_of_occupied_bandwidth_Frequency_range()
#       if val != nil then
#           return val
#       end
#       val = @@telectp._02_Tolerance_of_frequency()
#       if val != nil then
#           return val
#       end
        val = @@telectp._03_Antenna_power_point(@@ATT)
        if val != nil then
            return val
        end
#       val = @@telectp._04_Antenna_power_ave(@@ATT)
#       if val != nil then
#           return val
#       end
#       @@telectp._05_Tolerance_of_spurious_unwanted_emission_intensity_far()
        val = @@telectp._06_Tolerance_of_spurious_unwanted_emission_intensity_near()
        if val != nil then
            return val
        end
        val = @@telectp._07_Tolerance_off_adjacent_channel_leakage_power()
        if val != nil then
            return val
        end
#       @@telectp._08_Limit_of_secondary_radiated_emissions()
        val = @@telectp._09_Career_sense(@@ATT)
        if val != nil then
            return val
        end
#       val = @@telectp._10_Spectrum_emission_mask()
#       if val != nil then
#           return val
#       end
#       system("mpg321 -q ../mp3/beep.mp3")
        return
    end

	def setbarcode
        t = Time.now
        date = sprintf("%04d%02d%02d%02d%02d_",t.year,t.mon,t.mday,t.hour,t.min)
        logfilename = @@rftp.set_addr()
        logfilename = "/home/pi/test920j/Log/" + date + logfilename + ".log"
        File.rename('temp.log',logfilename)
#       system("mpg321 ../mp3/beep.mp3")
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
        return
	end


	def createLogFile
        t = Time.now
        date = sprintf("%04d%02d%02d%02d%02d_",t.year,t.mon,t.mday,t.hour,t.min)
        logfilename = @@rftp.get_shortAddr()
        logfilename = "/home/pi/test920j/Log/" + date + logfilename + ".log"
        File.rename('temp.log',logfilename)
        return
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
			print("~~~~~~~~~~~~~~ RF COMMAND ~~~~~~~~~~~\n")
			print("[1]  To Write basic parameter on E2P\n")
			print("[2]  Calibration\n")
			print("[3]  Continuous Wave\n")
			print("[4]  Send packet\n")
			print("[5]  Carrier Sense\n")
			print("[10] Set my address\n")
			print("[11] Get my address\n")
			print("[20] Direct Command(ex: rfr 8 0x6c)\n")
			print("[99] Exit\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
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
