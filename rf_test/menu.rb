#! /usr/bin/ruby

class Top_menu

	ATT = "7"
	LOAD_FILE = "bin/test.bin mini"
#	LOAD_FILE = "bin/Read_SubGHz.bin"
#	LOAD_FILE = "bin/test_debug.bin mini"
#	LOAD_FILE = "bin/test_FIRST.bin mini"
#	LOAD_FILE = "bin/test_for_BP3596A.bin Rev3"
#	LOAD_FILE = "bin/test_for_BP3596A.bin Rev3"

	def self.telec_menu
		Dir.chdir "./TELEC-T245"
		while 1
			print("====================== TELEC MENU =======================\n")
			p = Dir.glob("*")
			p.sort.each{|d| puts "" + d + "\n" }
			print("99.exit\n")
			print("=========================================================\n")
			print("input number => ")
			input = gets().to_s

			if input == "99\n" then
				Dir.chdir "./.."
				break
			elsif input == "\n" then
				p "ignore input"
			else
				p p.sort[input.to_i]
				com = "./" + p.sort[input.to_i]
				system(com)
			end
		end
	end

	def self.top_menu
		while 1
			system("pwd")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("1: Load boot loader\n")
			print("2: Load test program\n")
			print("3: Install basic parameter to E2P\n")
			print("4: Execute calibration\n")
			print("5: TELEC-T245 sub menu\n")
			print("10: Continuous Wave\n")
			print("11: Send packet\n")
			print("12: Carrier Sense\n")
			print("20: Set my address\n")
			print("21: Get my address\n")
			print("22: Direct Command mode\n")
			print("99: exit\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("input number => ")
			input = gets().to_i

			case input
			when 1
				system("./boot_wr.rb")
			when 2
				system("./load_prog.rb " + LOAD_FILE)
			when 3
				system("./e2p_base.rb")
			when 4
				system("./cal.rb " + ATT)
			when 5
				telec_menu()
			when 10
				system("./cw.rb")
			when 11
				system("./snd.rb")
			when 12
				system("./cca.rb")
			when 20
				system("./set_addr.rb")
			when 21
				system("./get_addr.rb")
			when 22
				system("./command.rb")
			when 99
				break
			end
		end
	end

	top_menu()
end
