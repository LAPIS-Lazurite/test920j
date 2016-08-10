#! /usr/bin/ruby

class Top_menu
	def self.menu
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
			print("    =================== Sub MENU ============================\n")
			Dir.chdir "./TELEC-T245"
			p = Dir.glob("*")
			p.sort.each{|d| puts "    " + d + "\n" }
			print("    =========================================================\n")
			print("    input number => ")
			input = gets().to_i
			p p.sort[input]
			com = "./" + p.sort[input]
			system(com)
			Dir.chdir "./.."
		when 9
			exit
		end
	end

	while 1
		menu()
	end
end
