#! /usr/bin/ruby

require './subghz.rb'
require './RfCom.rb'
@@rftp = Rftp::Test.new

class Certification

    @sbg = Subghz.new()

    def self.set_addr
        @sbg.com("ewp 0")

		print("\n")
#       print("Fly:  0x001D12D00400001E <-> 0x001D12D004003FFF\n")
#       print("Mini: 0x001D12D004004000 <-> 0x001D12D004007FFF\n")
#		print("Please input an address using a bar-code reader:")
##		print("¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿")
##      val = gets()
##      cmd = "ewr 32 0x" + val[0,2]
##      p sbg.com(cmd)
##      cmd = "ewr 33 0x" + val[2,2]
##      p sbg.com(cmd)
##      cmd = "ewr 34 0x" + val[4,2]
##      p sbg.com(cmd)
##      cmd = "ewr 35 0x" + val[6,2]
##      p sbg.com(cmd)
##      cmd = "ewr 36 0x" + val[8,2]
##      p sbg.com(cmd)
##      cmd = "ewr 37 0x" + val[10,2]
##      p sbg.com(cmd)
##      cmd = "ewr 38 0x" + val[12,2]
##      p sbg.com(cmd)
##      cmd = "ewr 39 0x" + val[14,2]
##      p sbg.com(cmd)
        print("Input own addres LSB 16bits (ex:10 0A)= ")
        val = gets().split(" ")
        cmd = "ewr 38 0x" + val[0].to_s
        p @sbg.com(cmd)	#short addr H
        cmd = "ewr 39 0x" + val[1].to_s
        p @sbg.com(cmd)	#short addr L

        p @sbg.com("erd 0 32")
        p @sbg.com("erd 32 32")
        p @sbg.com("erd 64 32")
        p @sbg.com("erd 96 32")
        p @sbg.com("erd 128 32")
        p @sbg.com("erd 160 32")
        p @sbg.com("erd 192 32")
        p @sbg.com("erd 224 32")
        p @sbg.com("erd 256 32")

        @sbg.com("ewp 1")
    end

    def self.setup
		print("Data Rate [100,50] => ")
		rate = gets().to_i
		print("CH [100kbps: 24/36/42/60, 50kbps:24//36/43/61 => ")
		ch = gets().to_i
		print("Power [1,20] => ")
		pa = gets().to_i
    #   pa = 20
        p @sbg.setup(ch,rate,pa)
    end

    def self.txon
		print("TEST mode [PN9:03, non:00] => ")
		mode = gets()
    #	print("CCA level [defualt:0x30] => ")
    #	cca = gets()
        cca = "0x30"

        p @sbg.trxoff
        p @sbg.rw("8 0x0C ",mode)  # TESTƒ‚[ƒh
        p @sbg.rw("8 0x13 ",cca)  # CCAè‡’l
        p @sbg.txon
        p @sbg.rr("8 0x6c")
    end

    def self.rxon
        p @sbg.rxon
    end

    def self.rr
		print("Read addr[8 0x6c] => ")
		addr = gets()
        p @sbg.rr(addr)
    end

    def self.rw
		print("Write addr[8 0x6c, 0x09] => ")
		data = gets().split(",")
        p @sbg.rw(data[0],data[1])
    end
    
    # sending interval 650msec
    def self.snd
		print("Input loop number => ")
		loop = gets().to_i

        p @sbg.wf()
        for i in 1..loop
            p @sbg.com("sgs 0xffff 0xffff")
          # p @sbg.com("sgs 0xabcd 0x0004")
        end
    end


    # sending interval 80msec
    def self.fast
	    @sbg.com("sgcs 230 10000")
    end

    def self.adj_frq
        while 1
            sleep 1
            p @sbg.rr("8 0x0a")
			print("input val [00-ff] :")
			val = gets().to_s
            p @sbg.rw("8 0x0a"," 0x" + val)

			print("complete ? [y/n] :")
			input = gets().to_s
            if /^[yY]/ =~ input then
                p val[0,1]
                @sbg.com("ewp 0")
                p @sbg.com("ewr 128 " + val)	#OSC_ADJ2_ADDR
                p @sbg.com("erd 128 1")
                @sbg.com("ewp 1")
                break
            end
        end
    end

    def self.adj_pow
        while 1
            sleep 1
            p @sbg.rr("9 0x06")
			print("input val [00-ff] :")
			val = gets().to_s
            p @sbg.rw("9 0x06"," 0x" + val)

			print("complete ? [y/n] :")
			input = gets().to_s
            if /^[yY]/ =~ input then
                p val[0,1]
                @sbg.com("ewp 0")
                p @sbg.com("ewr 41 0x" + val)	#PA_ADJ3
                p @sbg.com("erd 41 1")
                @sbg.com("ewp 1")
                break
            end
        end
    end

	def self.top_menu
        while 1
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("                   TOP Menu                    \n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("1: Setup SubGHz\n")
			print("2: TxOn (Wave option)\n")
			print("3: RxOn\n")
			print("5: Send packet\n")
			print("6: Send continue\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("10: Read register\n")
			print("11: Write register\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
            print("19: Load boot loader\n")
			print("20: Load test program\n")
			print("22: Load basic E2P param\n")
			print("23: Set my address\n")
			print("24: Get my address\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("30: Adjust Frequency\n")
			print("31: Adjust Power\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("input number => ")
			input = gets().to_i

			case input
			when 1
                setup()
			when 2
				txon()
			when 3
				rxon()
			when 5
				snd()
			when 6
                fast()
			when 10
				rr()
			when 11
				rw()
			when 19
				system("../common/boot_wr.rb")
			when 20
				system("../common/load_prog.rb " + "../bin/test.bin mini")
			when 22
				@@rftp.e2p_base()
			when 23
#               @@rftp.set_addr()
                set_addr()
			when 24
                @@rftp.get_addr()
			when 30
                adj_frq()
			when 31
                adj_pow()
            else
				break
            end
        end
    end

    top_menu()
end
