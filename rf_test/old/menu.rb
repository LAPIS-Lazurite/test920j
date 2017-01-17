#! /usr/bin/ruby

class Top_menu

	$ATT = "6"
	LOAD_FILE = "bin/test.bin mini"

	def self.exe_all_telec
		system("./load_prog.rb " + LOAD_FILE)
	    system("./e2p_base.rb")
		system("./cal.rb " + $ATT)
		Dir.chdir "./TELEC-T245"
		p = Dir.glob("*")
		n = p.count
		for i in 0 ..(n-1)
			com = "./" + p.sort[i] + " " + $ATT
			print("---------------------------------------------\n")
			p com
			ret = system(com)
			p ret
			if ret == false then
				printf("!!!STOP!!!: Let's check this subject\n")
				break
			end
		end
		Dir.chdir "./.."
		if (i == n-1) then
			printf("!!!Verification for TELEC-T245 was normalend\n")
			system("./get_addr.rb")
		end
	end

	def self.telec_menu
		Dir.chdir "./TELEC-T245"
		while 1
			print("====================== TELEC MENU =======================\n")
			p = Dir.glob("*")
			p.sort.each{|d| puts "" + d + "\n" }
			print("99.Exit\n")
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
				com = "./" + p.sort[input.to_i] + " " + $ATT
				system(com)
			end
		end
	end

	def self.top_menu
		while 1
			system("pwd")
			print("~~~~~~~~~~~~~~~~~~~~ Main Menu ~~~~~~~~~~~~~~~~\n")
			print("1: Load boot loader\n")
			print("2: Load test program\n")
			print("3: Write basic parameter for E2P\n")
			print("4: Execute calibration\n")
			print("5: Continue from 1 to 4\n")
			print("10: Sub menu for TELEC-T245 certification\n")
			print("11: Execute all TELEC-T245 certification\n")
			print("20: Continuous Wave\n")
			print("21: Send packet\n")
			print("22: Carrier Sense\n")
			print("30: Set my address\n")
			print("31: Get my address\n")
			print("32: Direct Command\n")
			print("99: Exit\n")
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
				system("./cal.rb " + $ATT)
			when 5
				print("Input own addres LSB 16bits (ex:10 0A)= ")
				addr = gets()
				system("./boot_wr.rb")
				system("./load_prog.rb " + LOAD_FILE)
				sleep 1
				system("./e2p_base.rb " + addr.to_s)
				system("./cal.rb " + $ATT)
			when 10
				telec_menu()
			when 11
				exe_all_telec()
			when 20
				system("./cw.rb")
			when 21
				system("./snd.rb")
			when 22
				system("./cca.rb")
			when 30
				system("./set_addr.rb")
			when 31
				system("./get_addr.rb")
			when 32
				system("./command.rb")
			when 99
				break
			end
		end
	end

	top_menu()
end