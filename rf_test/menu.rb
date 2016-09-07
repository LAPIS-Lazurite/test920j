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
			print("3: Load test program for BP3596A\n")
			print("4: Install basic parameter to E2P\n")
			print("5: Execute calibration\n")
			print("6: TELEC-T245 sub menu\n")
			print("7: Continuous Wave\n")
			print("8: Send packet\n")
			print("9: Carrier Sense\n")
			print("10: Set my address\n")
			print("11: Get my address\n")
			print("12: Direct Command mode\n")
			print("99: exit\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("input number => ")
			input = gets().to_i

			case input
			when 1
				system("./boot_wr.rb")
			when 2
				system("./load_prog.rb bin/test.bin mini")
#				system("./load_prog.rb bin/test_debug.bin mini")
#				system("./load_prog.rb bin/test_FIRST.bin mini")
			when 3
				system("./load_prog.rb bin/test_for_BP3596A.bin Rev3")
			when 4
				system("./e2p_base.rb")
			when 5
				system("./cal.rb")
			when 6
				telec_menu()
			when 7
				system("./cw.rb")
			when 8
				system("./snd.rb")
			when 9
				system("./cca.rb")
			when 10
				system("./set_addr.rb")
			when 11
				system("./get_addr.rb")
			when 12
				system("./command.rb")
			when 99
				break
			end
		end
	end

	top_menu()
end
