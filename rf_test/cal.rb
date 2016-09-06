#! /usr/bin/ruby

require './socket.rb'
require './subghz.rb'

class Calibration

# DUT setup ------------------------------------
	RF_STATUS_ADDR	= "8 0x6c "
	OSC_ADJ2_ADDR	= "8 0x0a "
	PA_ADJ1_ADDR 	= "9 0x04 "
	PA_ADJ3_ADDR 	= "9 0x06 "
	ATT = 6

	rate50  = {24 => "920600000",33 => "922400000", 36 => "923000000", 60 => "927800000" }
	rate100 = {24 => "920700000",33 => "922500000", 36 => "923100000", 60 => "927900000" }
	rate50.store(61,"928000000") # Extended
	@frq = {50 => rate50, 100 => rate100}

	pow_param = Struct.new(:mode, :level, :pa_addr, :pa_bit, :pa_max, :ep_addr)
	p1mW_mode = pow_param.new(1, 0, PA_ADJ1_ADDR, 0x01, 0x0f, "ewr 43 ")
	p20mW_mode = pow_param.new(20, 1300, PA_ADJ3_ADDR, 0x10, 0xf0, "ewr 41 ")
	@pow = {1  => p1mW_mode, 20 => p20mW_mode}

	Summary = Struct.new(:frq, :lv20mw, :lv1mw, :myaddr, :macaddr)
	summary = Summary.new(923100000, 13, 0, 0x0000, 0x0000000000000000)

	@max_num=9

	@sbg = Subghz.new()

# TESTER setup ----------------------------------
	$sock.puts("*RST")
	$sock.puts("*OPC?")
	$sock.gets

    $sock.puts("INST SPECT")

	$sock.puts("spf 500khz")
	$sock.puts("*OPC?")
	$sock.gets

	$sock.puts("rlv 20")
	$sock.puts("*OPC?")
	$sock.gets


# Frequency adjustment ------------------------
	def self.frq_adj(rate,ch)
		begin
			@sbg.setup(ch, rate, 20)
			@sbg.txon()

			for num in 1..10
				$sock.puts("cnf " + @frq[rate][ch].to_s)
				$sock.puts("*OPC?")
				$sock.gets

				$sock.puts("mkpk")
				$sock.puts("*OPC?")
				$sock.gets

				$sock.puts("mkf?")
				$sock.puts("*OPC?")
				value = $sock.gets
				p value

				diff = @frq[rate][ch].to_i - value.to_i
				diff = diff/1000
				printf("%s\n",diff)

				reg = @sbg.rr(OSC_ADJ2_ADDR)
				p reg

				if (diff) < -10 then
					i = reg.hex + 1
					@sbg.rw(OSC_ADJ2_ADDR,"0x0" + i.to_s)
				elsif (diff) > 10 then
					i = reg.hex - 1
					@sbg.rw(OSC_ADJ2_ADDR,"0x0" + i.to_s)
				else
					i = reg.hex
					com = "ewr 128 " + i.to_s
					p @sbg.com(com)
					print("Frequency adjustment completed\n")
					break
				end

				if num > @max_num then
					raise RuntimeError, "ERRR\n"
				end
			end
		rescue RuntimeError
			print ("Error: stoped adjustment\n")
			ret_val = 0
			return ret_val
		end

		ret_val = (value.to_f/1000000).round(3)
		printf("Fixed to %s MHz\n",ret_val)
		return ret_val
	end


# Power adjustment ------------------------
	def self.pow_adj(mode)
		begin
			@sbg.setup(36, 100, mode.to_s)
			@sbg.txon()

			for num in 1..10
				$sock.puts("cnf " + @frq[100][36].to_s)
				$sock.puts("*OPC?")
				$sock.gets

				$sock.puts("mkpk")
				$sock.puts("*OPC?")
				$sock.gets

				$sock.puts("mkl?")
				$sock.puts("*OPC?")
				value = $sock.gets
				p value

				diff = @pow[mode].level.to_i - (value.to_f * 100) - ATT
				printf("%d %d %d\n",diff,@pow[mode].level.to_i,value.to_i * 100)

				reg = @sbg.rr(@pow[mode].pa_addr)
				p reg

				if (diff.to_i) < 0 then
					i = reg.hex - @pow[mode].pa_bit
					@sbg.rw(@pow[mode].pa_addr,"0x" + i.to_s(16))
				elsif (diff.to_i) > 100 then
					i = reg.hex + @pow[mode].pa_bit
					@sbg.rw(@pow[mode].pa_addr,"0x" + i.to_s(16))
				else
					i = reg.hex
					com = @pow[mode].ep_addr + i.to_s
					p @sbg.com(com)
					print ("Power adjustment completed\n")
					break
				end

				if (i.to_s(16).hex & @pow[mode].pa_max) == @pow[mode].pa_max then
					raise StandardError, "ERRR\n"
				end

				if num > @max_num then
					raise RuntimeError, "ERRR\n"
				end
			end
		rescue RuntimeError
			printf("Error: stoped adjustment %s dBm\n",value.chop)
			return value.chop
		rescue StandardError
			printf("Error: not enough adjustment %s dBm\n",value.chop)
			return value.chop
		end

		printf("Fixed to %s dBm\n",value.chop)
		return value.chop
	end

#	frq_adj(50,61)
#	frq_adj(100,33)
	summary.frq = frq_adj(100,36)
#	frq_adj(100,60)

	summary.lv20mw = pow_adj(20)
	summary.lv1mw = pow_adj(1)

	summary.myaddr = @sbg.ra
	summary.macaddr = @sbg.com("erd 32 8").split(",")

	printf("############ Calibration Summary #############\n")
	printf("Frequency: %s\n",summary.frq)
	printf("Output level: 20mW=%s, 1mW=%s\n",summary.lv20mw,summary.lv1mw)
	printf("MY Address: %s\n",summary.myaddr[1])
	printf("MAC Address: %s\n",summary.macaddr[3...11])
	if summary.frq == 0 then
		printf("Result: !!!ERROR!!!\n")
	elsif summary.lv20mw.to_i.between?(12-ATT,13-ATT) == false then
		printf("Result: !!!ERROR!!!\n")
	elsif summary.lv1mw.to_i.between?(0-ATT,-1-ATT) == false then
		printf("Result: !!!WARNIG!!!\n")
	else
		printf("Result: !!!SUCCESS!!!\n")
	end
	printf("##############################################\n")

	$sock.close
end
