#! /usr/bin/ruby

require './subghz.rb'
class Certification

    @sbg = Subghz.new()

    def self.addr
        myaddr = @sbg.ra()
        printf("My address:%s", myaddr[1])
        p @sbg.com("erd,32,8")
    end

    def self.setup
		print("Data Rate [100,50] => ")
		rate = gets().to_i
		print("CH [100kbps: 24/42/60, 50kbps:24/43/61 => ")
		ch = gets().to_i
        pa = 20
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

    def self.e2p_base
        @sbg = Subghz.new()

        @sbg.com("ewp 0")

# eeprom write :My addrress-------
        p @sbg.com("ewr 32 0")	#0x00
        p @sbg.com("ewr 33 29")	#0x1D
        p @sbg.com("ewr 34 18")	#0x12
        p @sbg.com("ewr 35 208")	#0xD0
        p @sbg.com("ewr 36 4")	#0x04
        p @sbg.com("ewr 37 0")	#0x00

#-----------------------------------------------------
#print("Fly:  0x001D12D00400001E <-> 0x001D12D004003FFF\n")
#print("Mini: 0x001D12D004004000 <-> 0x001D12D004007FFF\n")
#if ARGV.length == 0 then
#	print("Input own addres LSB 16bits (ex:10 0A)= ")
#	val = gets().split(" ")
#else
#	val = ARGV
#end
#cmd = "ewr 38 0x" + val[0].to_s
#p sbg.com(cmd)	#short addr H
#cmd = "ewr 39 0x" + val[1].to_s
#p sbg.com(cmd)	#short addr L
#
#sleep 1
#-----------------------------------------------------

# eeprom write :power & Frequencey ---------
#p @sbg.com("ewr 41 167")	#PA_ADJ3
        p @sbg.com("ewr 41 119")	#PA_ADJ3
        p @sbg.com("ewr 42 24")	#PA_REG_FINE_ADJ3
#p @sbg.com("ewr 43 123")	#PA_ADJ1
        p @sbg.com("ewr 43 119")	#PA_ADJ1
        p @sbg.com("ewr 44 27")	#PA_REG_FINE_ADJ1
        p @sbg.com("ewr 45 48")	#OSC_ADJ
        p @sbg.com("ewr 46 39")	#PA_ADJ2
        p @sbg.com("ewr 47 24")	#PA_REG_FINE_ADJ2
        p @sbg.com("ewr 128 8")	#OSC_ADJ2
        p @sbg.com("ewr 129 7")	#PA_REG_ADJ3
#p @sbg.com("ewr 130 19")	#RF_CNTRL_SET
        p @sbg.com("ewr 130 00")	#RF_CNTRL_SET

        sleep 1

# eeprom read -------------------
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

	def self.top_menu
        while 1
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("1: Get my address\n")
			print("2: Setup SubGHz\n")
			print("3: Continuous Wave\n")
			print("4: RxOn\n")
			print("5: Read register\n")
			print("6: Write register\n")
			print("10: Send packet\n")
			print("11: Send continue\n")
			print("12: Load basic E2P param\n")
			print("99: exit\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("input number => ")
			input = gets().to_i

			case input
			when 1
                addr()
			when 2
                setup()
			when 3
				txon()
			when 4
				rxon()
			when 5
				rr()
			when 6
				rw()
			when 10
				snd()
			when 11
                fast()
			when 12
                e2p_base()
			when 99
				break
            end
        end
    end

    top_menu()
end
