#! /usr/bin/ruby

class Top_menu

	def self.telec_menu
		Dir.chdir "./TELEC-T245"
		while 1
			print("====================== TELEC MENU =======================\n")
			p = Dir.glob("*")
			p.sort.each{|d| puts "" + d + "\n" }
			print("99.exit\n")
			print("=========================================================\n")
			print("input number => ")
			input = gets().to_i

			if input == 99 then
				Dir.chdir "./.."
				break
			else
				p p.sort[input]
				com = "./" + p.sort[input]
				system(com)
			end
		end
	end

	def self.top_menu
		while 1
			system("pwd")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("1: load Boot loader\n")
			print("2: load test program\n")
			print("3: load test program for BP3596A\n")
			print("4: install basic parameter to E2P\n")
			print("5: execute calibration\n")
			print("6: TELEC-T245 sub menu\n")
			print("7: SubGHz TXON\n")
			print("9: exit\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("input number => ")
			input = gets().to_i

			case input
			when 1
				Dir.chdir "../io_test"
				system("./test.rb")
				Dir.chdir "../rf_test"
			when 2
				system("./load_prog.rb bin/test.bin mini")
			when 3
				system("./load_prog.rb bin/test_for_BP3596A.bin Rev3")
			when 4
				system("./e2p_base.rb")
			when 5
				system("./cal.rb")
			when 6
				telec_menu()
			when 7
				system("./subghz.rb")
			when 9
				break
			end
		end
	end

	top_menu()
end
