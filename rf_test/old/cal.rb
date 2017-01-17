#! /usr/bin/ruby

require './socket.rb'
require './subghz.rb'

class Calibration

# DUT setup ------------------------------------
	RF_STATUS_ADDR	= "8 0x6c "
	OSC_ADJ2_ADDR	= "8 0x0a "
	PA_ADJ1_ADDR 	= "9 0x04 "
	PA_ADJ3_ADDR 	= "9 0x06 "
	ATT = ARGV[0].to_f.round(2)
	p "ATT:" + ATT.to_s
	RATE = 100
	CH = 42

	pow_param = Struct.new(:mode, :level, :pa_addr, :pa_bit, :pa_max, :ep_addr)
	p1mW_mode = pow_param.new(1, 0, PA_ADJ1_ADDR, 0x01, 0x0f, "ewr 43 ")
	p20mW_mode = pow_param.new(20, 13, PA_ADJ3_ADDR, 0x10, 0xf0, "ewr 41 ")
	@pow = {1  => p1mW_mode, 20 => p20mW_mode}
	@max_num=9
	@sbg = Subghz.new()

	Summary = Struct.new(:frq, :lv20mw, :lv1mw, :myaddr, :macaddr)
	summary = Summary.new($frq[RATE][CH], 13, 0, 0x0000, 0x0000000000000000)

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
	@sbg.com("ewp 0")

	def self.frq_adj(rate,ch)
		begin
			@sbg.setup(ch, rate, 20)
			@sbg.txon()

			for num in 1..10
				$sock.puts("cnf " + $frq[rate][ch].to_s)
				$sock.puts("*OPC?")
				$sock.gets

				$sock.puts("mkpk")
				$sock.puts("*OPC?")
				$sock.gets

				$sock.puts("mkf?")
				$sock.puts("*OPC?")
				value = $sock.gets
				p value

				diff = $frq[rate][ch].to_i - value.to_i
				diff = diff/1000
				printf("diff:%s\n",diff)

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
			@sbg.setup(CH, RATE, mode.to_s)
			@sbg.txon()

			for num in 1..10
				$sock.puts("cnf " + $frq[RATE][CH].to_s)
				$sock.puts("*OPC?")
				$sock.gets

				$sock.puts("mkpk")
				$sock.puts("*OPC?")
				$sock.gets

				$sock.puts("mkl?")
				$sock.puts("*OPC?")
				value = $sock.gets
				p value

				diff = (@pow[mode].level.to_i * 100) - (ATT * 100)  - (value.to_f * 100)
				printf("diff:%d, base:%d, value:%d, ATT:%d\n",diff,@pow[mode].level.to_i,value.to_i * 100, ATT * 100)

				reg = @sbg.rr(@pow[mode].pa_addr)
				p reg

				if (diff.to_i) < 0 then
					i = reg.hex - @pow[mode].pa_bit
					@sbg.rw(@pow[mode].pa_addr,"0x" + i.to_s(16))
			    # 100�[��150�ɕύX�F03�󒆐�d��Fail���
				elsif (diff.to_i) > 150 then
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

	summary.frq = frq_adj(RATE,CH)
	summary.lv20mw = pow_adj(20)
	summary.lv1mw = pow_adj(1)

	summary.myaddr = @sbg.ra
	summary.macaddr = @sbg.com("erd 32 8").split(",")

	printf("############ Calibration Summary #############\n")
	printf("Frequency: %s\n",summary.frq)
	printf("Output level: 20mW=%s, 1mW=%s\n",summary.lv20mw,summary.lv1mw)
	printf("My Address: %s",summary.myaddr[1])
	printf("MAC Address: %s\n",summary.macaddr[3...11])
	
	max_pow = @pow[20].level.to_i-ATT
	min_pow = @pow[20].level.to_i-ATT-2

	if summary.frq == 0 then
		printf("!!!ERROR!!!\n")
		raise StandardError, "FAIL\n"
	elsif summary.lv20mw.to_i.between?(min_pow,max_pow) == false then
		printf("!!!ERROR!!!\n")
		raise StandardError, "FAIL\n"
	elsif summary.lv1mw.to_i.between?(-1-ATT,0-ATT) == false then
		printf("!!!WARNIG!!!\n")
	elsif summary.myaddr[1].to_i(16) == 0xFFFF then
		printf("!!!ERROR!!!\n")
		raise StandardError, "FAIL\n"
	else
		printf("!!!PASS!!!\n")
	end
	printf("##############################################\n")

	@sbg.com("ewp 1")
	$sock.close
end