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

        p @sbg.wf("welcome_SubGHz_LAPIS_semiconductor welcome_SubGHz_LAPIS_semiconductor welcome_SubGHz_LAPIS_semiconductor welcome_SubGHz_LAPIS_semiconductor welcome_SubGHz_LAPIS_semiconductor welcome_SubGHz_LAPIS_semiconductor welcome_SubGHz_LAPIS")
        for i in 1..loop
            p @sbg.com("sgs 0xffff 0xffff")
          # p @sbg.com("sgs 0xabcd 0x0004")
        end
    end


    # sending interval 80msec
    def self.fast
	    @sbg.com("sgcs 230 10000")
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
			when 99
				break
            end
        end
    end

    top_menu()
end
