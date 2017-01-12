#! /usr/bin/ruby

require './Rftp.rb'
require './Telectp.rb'

@@rftp = Rftp::Test.new
@@telectp = Telectp::Test.new

class Rftest

	@@ATT = "6"

	def alltest(level)
        @@rftp.e2p_base()
        @@rftp.calibration(@@ATT)
        if level >= 2 then
            @@telectp._00_MS2830A_init()
            @@telectp._01_Tolerance_of_occupied_bandwidth_Frequency_range()
            @@telectp._02_Tolerance_of_frequency()
            @@telectp._03_Antenna_power_point(@@ATT)
            @@telectp._04_Antenna_power_ave(@@ATT)
        end
		if level >= 3 then
			@@telectp._05_Tolerance_of_spurious_unwanted_emission_intensity_far()
			@@telectp._06_Tolerance_of_spurious_unwanted_emission_intensity_near()
			@@telectp._07_Tolerance_off_adjacent_channel_leakage_power()
			@@telectp._08_Limit_of_secondary_radiated_emissions()
        end
        if level >= 2 then
		    @@telectp._09_Career_sense(@@ATT)
		    @@telectp._10_Spectrum_emission_mask()
        end
		@@rftp.set_addr()
		printf("++++++++++++++++++++++++++++++++++++++++++++\n")
		printf("!!!    All the verification was pass     !!!\n")
		printf("++++++++++++++++++++++++++++++++++++++++++++\n")
	end

	def telec_menu
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
			when 99
				break
			end
		end
	end

	def menu
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
