#! /usr/bin/ruby

class Top_menu

	def self.telec_menu
		while 1
			print("=================== TELEC MENU ============================\n")
			Dir.chdir "./TELEC-T245"
			p = Dir.glob("*")
			p.sort.each{|d| puts "" + d + "\n" }
			print("99.exit\n")
			print("=========================================================\n")
			print("input number => ")
			input = gets().to_i

			if input == 99 then
				break
			else
				p p.sort[input]
				com = "./" + p.sort[input]
				system(com)
				Dir.chdir "./.."
			end
		end
	end

	def self.top_menu
		while 1
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("1: load Boot loader\n")
			print("2: load test program\n")
			print("3: install basic parameter to E2P\n")
			print("4: execute calibration\n")
			print("5: TELEC-T245 sub menu\n")
			print("9: exit\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("input number => ")
			input = gets().to_i

			case input
			when 1
				system("./load_prog.rb bin/ML620Q504_000RA.bin")
			when 2
				system("./load_prog.rb bin/test.bin")
			when 3
				system("./e2p_base.rb")
			when 4
				system("./cal.rb")
			when 5
				telec_menu()
			when 9
				break
			end
		end
	end

	top_menu()
end
