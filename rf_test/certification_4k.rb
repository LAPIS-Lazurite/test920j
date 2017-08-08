#! /usr/bin/ruby


if RUBY_PLATFORM ==  "x64-mingw32" then
    require 'rubygems'
    require 'serialport'

	print("input COM number => ")
    com = gets().to_i
    com = "COM" + com.to_s

    $SERIAL_PORT =com
    $SERIAL_BAUDRATE=115200
#   sp = SerialPort.new(SERIAL_PORT, SERIAL_BAUDRATE)
#   sp.read_timeout=500
#   sp.puts("sggma")
#   p sp.gets()
#   SERIAL_BAUDRATE="115200, 8, 1, 0"
#   SerialPort.new(serial_port, 115200, 8, 1, 0)
else
    require 'serialport'
    if $SERIAL_PORT == nil then
        $SERIAL_PORT ='/dev/ttyUSB0'
        print "Replace SERIAL_PORT"
    end
    $SERIAL_BAUDRATE=115200
end

##############################################
# subghz class
##############################################
class Subghz

	def setup(len, ch, rate, mode)
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
        if rate == 200 then
		    sp.puts("sgi,1," + len.to_s)
        else
		    sp.puts("sgi,0," + len.to_s)
        end
		p sp.gets()
		sp.puts("sgb," + ch.to_s + ",0xabcd," + rate.to_s + "," + mode.to_s)
		p sp.gets()
		sp.close
	end

	def set_trx(state)
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("rfw 0 0x0b " + state)
		p sp.gets()
		sp.close
	end

	def com(s)
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts(s)
		val = sp.gets()
		sp.close
		return val
	end

	def rr(addr)
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("rfr " + addr)
		val = sp.gets().split(",")
		sp.close
		return val[val.size - 1]
	end

	def rw(addr,data)
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("rfw " + addr.to_s + data.to_s)
		p sp.gets()
		sp.close
	end

	def wf(payload)
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
 		sp.puts("w," + payload.to_s)
#       sp.puts("w," + "lazuriteLazurite")
		p sp.gets()
		sp.close
	end

	def ra
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("sggma")
		val = sp.gets().split(",")
		sp.close
		return val
	end

	def mod(val)
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		if val then
			sp.puts("rfw " + "8 0x0c " + "0x03")
		else
			sp.puts("rfw " + "8 0x0c " + "0x00")
		end
		p sp.gets()
		sp.close
	end
end

##############################################
# certification menu class
##############################################
class Certification

    @sbg = Subghz.new()
    @rate = 100

    def self.e2p_base
        @sbg.com("ewp 0")

# eeprom write :My addrress-------
        p @sbg.com("ewr 32 0")	#0x00
        p @sbg.com("ewr 33 29")	#0x1D
        p @sbg.com("ewr 34 18")	#0x12
        p @sbg.com("ewr 35 208")	#0xD0
        p @sbg.com("ewr 36 4")	#0x04
        p @sbg.com("ewr 37 0")	#0x00
# eeprom write :power & Frequencey ---------
        p @sbg.com("ewr 41 119")	#PA_ADJ3
        p @sbg.com("ewr 42 24")	#PA_REG_FINE_ADJ3
        p @sbg.com("ewr 43 119")	#PA_ADJ1
        p @sbg.com("ewr 44 27")	#PA_REG_FINE_ADJ1
        p @sbg.com("ewr 45 48")	#OSC_ADJ
        p @sbg.com("ewr 46 39")	#PA_ADJ2
        p @sbg.com("ewr 47 24")	#PA_REG_FINE_ADJ2
        p @sbg.com("ewr 128 8")	#OSC_ADJ2
        p @sbg.com("ewr 129 7")	#PA_REG_ADJ3
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

	def self.get_addr
        myaddr = @sbg.ra()
        printf("My address:%#10.4x\n", myaddr[1])
        sleep(1)
        # eeprom read -------------------
        p @sbg.com("erd,0,32")
        p @sbg.com("erd,32,32")
        p @sbg.com("erd,64,32")
        p @sbg.com("erd,96,32")
        p @sbg.com("erd,128,32")
        p @sbg.com("erd,160,32")
        p @sbg.com("erd,192,32")
        p @sbg.com("erd,224,32")
        p @sbg.com("erd,256,32")
    end

    def self.set_addr
        @sbg.com("ewp 0")

		print("\n")
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
		print("Data Rate [50,100,200] => ")
		@rate = gets().to_i
		print("CH [100kbps: 24/36/42/60, 50kbps:24//36/43/61 => ")
		ch = gets().to_i
		print("Power [1,20] => ")
		pa = gets().to_i
		print("Data length => ")
		len = gets().to_i
        p @sbg.setup(len,ch,@rate,pa)
    end

    def self.txon
		print("TEST mode [PN9:03, non:00] => ")
		mode = gets()
        p @sbg.rw("0 0x76 ",mode)  # TESTƒ‚[ƒh
        p @sbg.set_trx("0x09")
        p @sbg.rr("0 0x0b")
    end

    def self.rxon
        p @sbg.set_trx("0x06")
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
    
    def self.data_payload
       if @rate < 200
	        data = "Welcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductor"
       else
	        data = "lazuriteLAZURITE"
       end
       p @sbg.wf(data)
    end


    # sending interval 650msec
    def self.snd
		print("CCA level[00-ff:(default 0x5c)] => ")
		level = gets()
		print("PANID => ")
		panid = gets()
		print("ADDR => ")
		addr = gets()
        p @sbg.rw("0 0x37 ",level)
		print("Input loop number => ")
		loop = gets().to_i

        for i in 1..loop
            p @sbg.com("sgs " + panid.to_s + addr.to_s)
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
			print("4: Payload\n")
			print("5: Send packet\n")
			print("6: Send continue\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
			print("10: Read register\n")
			print("11: Write register\n")
			print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
            print("20: Load boot loader\n")
			print("21: Load test program\n")
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
			when 4
				data_payload()
			when 5
				snd()
			when 6
                fast()
			when 10
				rr()
			when 11
				rw()
			when 20
				system("./boot_wr_rev3.rb")
			when 21
			     system("./load_prog.rb " + "bin/test920j_for_4k.bin Rev3")
			when 22
				e2p_base()
			when 23
                set_addr()
			when 24
                get_addr()
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
