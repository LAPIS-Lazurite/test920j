#! /usr/bin/ruby

require './socket.rb'
require './subghz.rb'

class Rftp::Test

	RATE = 100
	CH = 42
    Summary = Struct.new(:frq, :lv20mw, :lv1mw, :myaddr, :macaddr)
    FRQ_RENGE_MIN = -4   # version 1.0 is -10
    FRQ_RENGE_MAX = 4    # version 1.0 is 10

    FRQ_RENGE_FINE_MIN = -2
    FRQ_RENGE_FINE_MAX = 2
    # Frequency adjustment ------------------------
    def frq_fine_adj(rate,ch)
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
                printf("Frequency adjustment: diff:%s, tartget:%d, current:%d\n",
                       diff,$frq[rate][ch].to_i,value.to_i)
                diff = diff/1000

                reg = @sbg.rr(OSC_ADJ_ADDR)
                p reg

                if (diff) < FRQ_RENGE_FINE_MIN then
                    i = reg.hex + 1
                    @sbg.rw(OSC_ADJ_ADDR,"0x" + i.to_s)
                elsif (diff) > FRQ_RENGE_FINE_MAX then
                    i = reg.hex - 1
                    @sbg.rw(OSC_ADJ_ADDR,"0x" + i.to_s)
                else
                    i = reg.hex
                    com = "ewr 45 " + i.to_s
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

    # Frequency adjustment ------------------------
    def frq_adj(rate,ch)
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
                printf("Frequency adjustment: diff:%s, tartget:%d, current:%d\n",
                       diff,$frq[rate][ch].to_i,value.to_i)
                diff = diff/1000

                reg = @sbg.rr(OSC_ADJ2_ADDR)
                p reg

                if (diff) < FRQ_RENGE_MIN then
                    i = reg.hex + 1
                    @sbg.rw(OSC_ADJ2_ADDR,"0x0" + i.to_s)
                elsif (diff) > FRQ_RENGE_MAX then
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
    def pow_adj(mode)
        begin
            @sbg.setup(CH, RATE, mode.to_s)
            @sbg.txon()

            for num in 1..12
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

                diff = (@pow[mode].level.to_i * 100) - (value.to_f * 100) - (@@att * 100)
                printf("Power adjustment: diff:%.2f, target level:%.2f, current level:%.2f(ATT:%.2f)\n",
                                    (diff/100).to_f,@pow[mode].level.to_i,value.to_f,@@att.to_f)

		# MJ2001 2nd lots
                get_val = (value.to_f + @@att) * 100
                exp_val = @pow[mode].level.to_i * 100

                reg = @sbg.rr(@pow[mode].pa_addr)
                p reg

#               if (diff.to_i) < 0 then #MJ2001 1st lots
                if get_val > exp_val then
                    i = reg.hex - @pow[mode].pa_bit
                    @sbg.rw(@pow[mode].pa_addr,"0x" + i.to_s(16))
                # 100ー＞150に変更：03空中戦電力Fail回避
#               elsif (diff.to_i) > 150 then    # MJ2001 1st lots
               elsif get_val < (exp_val - 300) then
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
            return 0 # value.chop # MJ2001 1st lots
        rescue StandardError
            printf("Error: not enough adjustment %s dBm\n",value.chop)
            return 0 # value.chop # MJ2001 1st lots
        end
        printf("Fixed to %s dBm\n",value.chop)
        return value.chop
    end


	def calibration(att)

        begin
            @@att = att.to_f.round(2)
            p "ATT:" + @@att.to_s

            # DUT setup ------------------------------------
            pow_param = Struct.new(:mode, :level, :pa_addr, :pa_bit, :pa_max, :ep_addr)
            p1mW_mode = pow_param.new(1, -1, PA_ADJ1_ADDR, 0x01, 0x0f, "ewr 43 ")
#           p20mW_mode = pow_param.new(20, 12, PA_ADJ3_ADDR, 0x10, 0xf0, "ewr 41 ")
            # MJ2001
#           p20mW_mode = pow_param.new(20, 12.5, PA_ADJ3_ADDR, 0x10, 0xf0, "ewr 41 ")
            p20mW_mode = pow_param.new(20, 12.8, PA_ADJ3_ADDR, 0x10, 0xf0, "ewr 41 ")
            @pow = {1  => p1mW_mode, 20 => p20mW_mode}
            @max_num=9
            @sbg = Subghz.new()

            summary = Summary.new($frq[RATE][CH], 13, 0, 0x0000, 0x0000000000000000)

            # TESTER setup ----------------------------------
            $sock.puts("*RST")
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("INST SPECT")

            $sock.puts("SYST:LANG nat")
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("spf 500khz")
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("rlv 20")
            $sock.puts("*OPC?")
            $sock.gets

            @sbg.com("ewp 0")

            summary.frq = frq_adj(RATE,CH)
            summary.frq = frq_fine_adj(RATE,CH)
            summary.lv20mw = pow_adj(20)
            summary.lv1mw = pow_adj(1)

            summary.myaddr = @sbg.ra()
            summary.macaddr = @sbg.com("erd 32 8").split(",")

            @sbg.trxoff()
            @sbg.com("ewp 1")
#           $sock.close

            $log.info("############ Calibration Summary #############")
            $log.info(sprintf("Frequency: %s MHz",summary.frq))
            $log.info(sprintf("Power level: 20mW=%2.2fdBm, 1mW=%2.2fdBm",summary.lv20mw.to_i + @@att, summary.lv1mw.to_i + @@att))
            $log.info(sprintf("RF Reg: PA_ADJ1=0x%x,PA_ADJ3=0x%x,OSC_ADJ=0x%x,OSC_ADJ2=0x%x", @sbg.rr(PA_ADJ1_ADDR), @sbg.rr(PA_ADJ3_ADDR), @sbg.rr(OSC_ADJ_ADDR), @sbg.rr(OSC_ADJ2_ADDR)))
            $log.info(sprintf("Attenuate: %2.2f dB",@@att))
            $log.info(sprintf("My Address: %#2.4x",summary.myaddr[1]))
            $log.info(sprintf("MAC Address: %s",summary.macaddr[3...11]))

=begin MJ2001 1st lots
            max_pow = @pow[20].level.to_i-@@att+1
            min_pow = @pow[20].level.to_i-@@att-2
=end
            if summary.frq == 0 then
                $log.info("!!!ERROR!!!n")
                raise StandardError, "FAIL"
#           elsif summary.lv20mw.to_i.between?(min_pow,max_pow) == false then # MJ2001 1st lots
            elsif summary.lv20mw.to_i == 0 then
                $log.info("!!!ERROR!!!")
                raise StandardError, "FAIL"
            elsif summary.lv1mw.to_i.between?(-1-@@att,0-@@att) == false then
                $log.info("!!!WARNIG!!!")
            elsif summary.myaddr[1].to_i(16) == 0xFFFF then
                $log.info("!!!ERROR!!!\n")
                raise StandardError, "FAIL"
            else
                $log.info("!!!PASS!!!")
            end
            $log.info("##############################################")

        rescue StandardError
            printf("Error: stoped adjustment\n")
            return "Error"
        end
        return nil
    end
end
