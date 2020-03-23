#! /usr/bin/ruby

require './Rftp.rb'
require './Telectp.rb'
require 'logger'
require 'fileutils'


class Rftest
	@@rftp = Rftp::Test.new
	@@telectp = Telectp::Test.new

	@@dev = @@rftp.sel_dev()
	if @@dev == "ML7396" then
		$ANT_SW_OUT=1
	end

#	@@ATT = "7.9"		#2nd lots was 6.1
#	@@ATT = "6.9"		#2nd lots was 6.1
#	@@ATT = "10.4"	 #2nd lots was 6.1

#	@@rftp.ms2830a_setting(42,100,10) 
#	@@rftp.subghz_setting(ch,rate,"trxoff") 
#	@@ATT = @@rftp.att_checker(42,100)

		def led
				@@rftp.led("blue");
		end

		def setlog
				if File.exist?("temp.log") == true then
						File.delete("temp.log")
				end
				$log = Logger.new("| tee temp.log")
#				$log = Logger.new(STDOUT)
#				$log.level = Logger::INFO
		end

		def calib
				@@rftp.e2p_base("Lazurite920j")
				val = @@rftp.calibration(@@ATT)
				return val
		end

	def pretest
				@@telectp._00_MS2830A_init()
				val = @@telectp._09_Career_sense(@@ATT)
#				system("mpg321 ../mp3/beep.mp3")
				return val
	end
		

	def postest
#				@@rftp.begin_subghz()
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
#				@@telectp._05_Tolerance_of_spurious_unwanted_emission_intensity_far()
				val = @@telectp._06_Tolerance_of_spurious_unwanted_emission_intensity_near()
				if val != nil then
						return val
				end
				val = @@telectp._07_Tolerance_off_adjacent_channel_leakage_power()
				if val != nil then
						return val
				end
#				@@telectp._08_Limit_of_secondary_radiated_emissions()
				val = @@telectp._09_Career_sense(@@ATT)
				if val != nil then
						return val
				end
				val = @@telectp._10_Spectrum_emission_mask()
				if val != nil then
						return val
				end
#				system("mpg321 -q ../mp3/beep.mp3")
				return
		end

	def trialtest
#				@@rftp.begin_subghz()
				@@telectp._00_MS2830A_init()
#				val = @@telectp._01_Tolerance_of_occupied_bandwidth_Frequency_range()
#				if val != nil then
#						return val
#				end
#				val = @@telectp._02_Tolerance_of_frequency()
#				if val != nil then
#						return val
#				end
				val = @@telectp._03_Antenna_power_point(@@ATT)
				if val != nil then
						return val
				end
#				val = @@telectp._04_Antenna_power_ave(@@ATT)
#				if val != nil then
#						return val
#				end
#				@@telectp._05_Tolerance_of_spurious_unwanted_emission_intensity_far()
				val = @@telectp._06_Tolerance_of_spurious_unwanted_emission_intensity_near()
				if val != nil then
						return val
				end
				val = @@telectp._07_Tolerance_off_adjacent_channel_leakage_power()
				if val != nil then
						return val
				end
#				@@telectp._08_Limit_of_secondary_radiated_emissions()
				val = @@telectp._09_Career_sense(@@ATT)
				if val != nil then
						return val
				end
#				val = @@telectp._10_Spectrum_emission_mask()
#				if val != nil then
#						return val
#				end
#				system("mpg321 -q ../mp3/beep.mp3")
				return
		end

	def setbarcode
				t = Time.now
				date = sprintf("%04d%02d%02d%02d%02d_",t.year,t.mon,t.mday,t.hour,t.min)
				logfilename = @@rftp.set_addr()
				logfilename = "/home/pi/test920j/Log/" + date + logfilename + ".log"
				File.rename('temp.log',logfilename)
#				system("mpg321 ../mp3/beep.mp3")
#				led_thread = Thread.new(&method(:led))
#				endmsg = Thread.new do
#				printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
#				printf("!!! 正常に終了しました																					 !!!\n")
#				printf("!!! 基盤上のリセットスイッチを押して赤色LED点灯を確認して下さい。!!!\n")
#				printf("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n")
#				gets()
#				Thread.kill(led_thread)
#				end
#				led_thread.join
#				endmsg.join
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



	def telec_menu
		if File.exist?("temp.log") == true then
				File.delete("temp.log")
		end
		#$log = Logger.new("| tee temp.log")
		$log = Logger.new("temp.log")
		Dir.chdir "./TelecLib"
		ch=42
		rate=100
		span=10
		@@rftp.ms2830a_setting(ch,rate,span) 
		@@ATT = @@rftp.att_checker(ch,rate)
		p @@ATT

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

	def Rftp_menu
		while 1
			system("pwd")
			print("~~~~~~~~~~~~~~ RF COMMAND ~~~~~~~~~~\n")
			print("[1] Write basic parameter on E2P\n")
			print("[2] Read E2P\n")
			print("[3] Continuous Wave\n")
			print("[4] Send packet\n")
			print("[5] Carrier Sense\n")
			print("[6] Calibration for MJ2001/Lazurite920j\n")
			print("~~~~~~~~~ MK7404 calibration ~~~~~~~\n")
			print("[21] Atteneta checker\n")
			print("[22] Power adjustment\n")
			print("[23] RSSI adjustment\n")
			print("[24] Frequency deviation adjustment\n")
			print("[25] Read ED value\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("[31] Set my address\n")
			print("[32] Get my address\n")
			print("[33] Direct Command(ex: rfr 8 0x6c)\n")
			print("[99] Exit\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("input number => ")
			input = gets().to_i

			case input
				when 1
					print("Input number(1:Lazurite920j, 2:MJ2001, 3:MK74040): ")
					input = gets().to_i
					if input == 1 then
						@@rftp.e2p_base("Lazurite920j")
					elsif input == 2 then
						@@rftp.e2p_base("MJ2001")
					elsif input == 3 then
						@@rftp.e2p_base("MK74040")
					end
				when 2
					@@rftp.e2p_read()
				when 3
					@@rftp.cw()
				when 4
					@@rftp.snd()
				when 5
					@@rftp.cca()
				when 6
					if File.exist?("temp.log") == true then
							File.delete("temp.log")
					end
					$log = Logger.new("temp.log")
					print("Input number(1:Lazurite920j, 2:MJ2001:): ")
					input = gets().to_i
					if input == 1 then
						@@rftp.e2p_base("Lazurite920j")
					elsif input == 2 then
						@@rftp.e2p_base("MJ2001")
					end
					ch=42
					rate=100
					span=10
					@@rftp.ms2830a_setting(ch,rate,span) 
					att = @@rftp.att_checker(ch,rate)
					@@rftp.calibration(att)
					File.delete("temp.log")
				when 21
					ch=42
					rate=100
					span=10
					@@rftp.ms2830a_setting(ch,rate,span) 
					@@rftp.set_command(@@dev)
					@@rftp.subghz_setting(ch,rate,"trxoff") 
					@@ATT = @@rftp.att_checker(ch,rate)
					printf("ATT level: %s dB\n",@@ATT)
				when 22
					ch=42
					rate=100
					span=10
					@@rftp.ms2830a_setting(ch,rate,span) 
					@@rftp.set_command(@@dev)
					@@rftp.subghz_setting(ch,rate,"trxoff") 
					@@ATT = @@rftp.att_checker(ch,rate)
					@@rftp.ms2830a_setting(ch,rate,span) 
					@@rftp.subghz_setting(ch,rate,"tx") 
					@@rftp.pow_adj_4k(ch,rate,@@ATT)
				when 23
					@@rftp.rssi_adj(@@dev)
				when 24
					print("Input ch: ")
					ch = gets().to_i
					print("Input rate: ")
					rate = gets().to_i
					@@rftp.ms2830a_setting(ch,rate,1) 
					@@rftp.set_command(@@dev)
					@@rftp.subghz_setting(ch,rate,"tx") 
					@@rftp.freq_dev_adj(ch,rate)
				when 25
					print("Input ch: ")
					ch = gets().to_i
					print("Input rate: ")
					rate = gets().to_i
					@@rftp.ms2830a_setting(ch,rate,100) 
					@@rftp.set_command(@@dev)
					@@rftp.subghz_setting(ch,rate,"rx") 
					@@rftp.read_ed_value(ch,rate)
				when 31
					@@rftp.set_addr()
				when 32
					@@rftp.get_addr()
				when 33
					@@rftp.command()
				else
					break
				end
		end
	end
end

def top_menu
	rftest = Rftest.new()
	while 1
			system("pwd")
			print("~~~~~~~~~~~ TOP MENU ~~~~~~~~~~~\n")
			print("[1] Verify\n")
			print("[2] Reliability test\n")
			print("[3] Rftp menu\n")
			print("[4] Telec menu\n")
			print("[99] Exit\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("番号を入力してください：")
			input = gets().to_i

			case input
			when 1
					Dir.chdir "../rf_test"
					rftest.setlog()
					if rftest.postest() != nil then
							raise RuntimeError, "ERRR\n"
					end
			when 2
					while 1
							Dir.chdir "../rf_test"
							rftest.setlog()
							if rftest.trialtest() != nil then
									raise RuntimeError, "ERRR\n"
							end
							rftest.createLogFile()
							print("\n続ける場合は[Enter]を終了する場合[x]を入力してください：")
							rep = gets().to_s
							if rep =~ /x/ then
									break
							end
					end
			when 3
					Dir.chdir "../rf_test"
					rftest.Rftp_menu()
			when 4
					Dir.chdir "../rf_test"
					rftest.telec_menu()
			else
				break
		end
	end # while
end
if $TOP_MENU == nil then
top_menu()
end