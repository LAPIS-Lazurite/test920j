#! /usr/bin/ruby

require '/home/pi/test920j/rf_test/socket.rb'
require '/home/pi/test920j/rf_test/subghz.rb'

class Rftp::Test

  PA_ADJ_UNIT = 100
  PA_TARGET_LOW = 300 # 3dB
  KHZ_UINT = 1000
  MHZ_UINT = 1000000
  RATE = 100
  CH = 42

  FRQ_RENGE_MIN = -4
  FRQ_RENGE_MAX = 4
  FRQ_RENGE_FINE_MIN = -2
  FRQ_RENGE_FINE_MAX = 2

  
  Summary= Struct.new(:frq, :lv20mw, :lv1mw, :myaddr, :macaddr)

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
                value = $sock.gets
                p value

                diff = $frq[rate][ch].to_i - value.to_i
                printf("Frequency adjustment: diff:%s, tartget:%d, current:%d\n",
                       diff,$frq[rate][ch].to_i,value.to_i)
                diff = diff/KHZ_UINT

                reg_data = @sbg.rr(OSC_ADJ_ADDR)
                p reg_data

                if (diff) < FRQ_RENGE_FINE_MIN then
                    i = reg_data.hex + 1
                    @sbg.rw(OSC_ADJ_ADDR,"0x" + i.to_s)
                elsif (diff) > FRQ_RENGE_FINE_MAX then
                    i = reg_data.hex - 1
                    @sbg.rw(OSC_ADJ_ADDR,"0x" + i.to_s)
                else
                    i = reg_data.hex
                    com = "ewr 45 " + i.to_s
                    p @sbg.com(com)
                    print("Frequency fine adjustment completed\n")
                    break
                end

                if num > @max_num then
                    raise RuntimeError, "ERRR\n"
                end
            end
        rescue RuntimeError
            print ("Error: stop freq fine adjustment\n")
            ret_val = 0
            return ret_val
        end

        ret_val = (value.to_f/MHZ_UINT).round(3)
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
                value = $sock.gets
                p value

                diff = $frq[rate][ch].to_i - value.to_i
                printf("Frequency adjustment: diff:%s, tartget:%d, current:%d\n",
                       diff,$frq[rate][ch].to_i,value.to_i)
                diff = diff/KHZ_UINT

                reg_data = @sbg.rr(OSC_ADJ2_ADDR)
                p reg_data


                if (diff) < FRQ_RENGE_MIN then
                    i = reg_data.hex + 1
                    @sbg.rw(OSC_ADJ2_ADDR,"0x0" + i.to_s)
                elsif (diff) > FRQ_RENGE_MAX then
                    i = reg_data.hex - 1
                    @sbg.rw(OSC_ADJ2_ADDR,"0x0" + i.to_s)
                else
                    i = reg_data.hex
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
            print ("Error: stop freq adjustment\n")
            ret_val = 0
            return ret_val
        end

        ret_val = (value.to_f/MHZ_UINT).round(3)
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
                value = $sock.gets
                p value

                target_level =@pow[mode].level.to_i * PA_ADJ_UNIT
                measurement = (value.to_f + @@att) * PA_ADJ_UNIT
                reg_data = @sbg.rr(@pow[mode].pa_addr)
                printf("Power adjustment: target:%.2f, measurement:%.2f, ATT:%.2f, pa_addr:0x%x\n",target_level, measurement, @@att.to_f, reg_data)

                if measurement > target_level then
                    set_data = reg_data.hex - @pow[mode].pa_bit
                    @sbg.rw(@pow[mode].pa_addr,"0x" + set_data.to_s(16))
                    print("Power over limit: set to %x\n",set_data.hex)
                elsif measurement < (target_level - PA_TARGET_LOW) then
                    set_data = reg_data.hex + @pow[mode].pa_bit
                    @sbg.rw(@pow[mode].pa_addr,"0x" + set_data.to_s(16))
                    print("Power under limit: set to %x\n",set_data.hex)
                else
                    set_data = reg_data.hex
                    com = @pow[mode].ep_addr + set_data.to_s
                    p @sbg.com(com)
                    print("Power adjustment completed\n")
                    break
                end

                if (set_data.to_s(16).hex & @pow[mode].pa_max) == @pow[mode].pa_max then
                    raise StandardError, "ERRR\n"
                end

                if num > @max_num then
                    raise RuntimeError, "ERRR\n"
                end
            end
        rescue RuntimeError
            printf("Error: stop power adjustment %s dBm\n",value.chop)
            return 0
        rescue StandardError
            printf("Error: adjustment under than limit %s dBm\n",value.chop)
            return 0
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
            p1mW_mode = pow_param.new(1, 0, PA_ADJ1_ADDR, 0x01, 0x0f, "ewr 43 ")
            p20mW_mode = pow_param.new(20, 13, PA_ADJ3_ADDR, 0x10, 0xf0, "ewr 41 ")
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
#            $sock.close

            $log.info("############ Calibration Summary #############")
            $log.info(sprintf("Frequency: %s MHz",summary.frq))
            $log.info(sprintf("Power level: 20mW=%2.2fdBm, 1mW=%2.2fdBm",summary.lv20mw.to_i + @@att, summary.lv1mw.to_i + @@att))
            $log.info(sprintf("Attenuate: %2.2f dB",@@att))
            $log.info(sprintf("My Address: %#2.4x",summary.myaddr[1]))
            $log.info(sprintf("MAC Address: %s",summary.macaddr[3...11]))

            if summary.frq == 0 then
                $log.info("!!!ERROR!!!n")
                raise StandardError, "FAIL"
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
            printf("Error: stop calibration\n")
            return "Error"
        end
        return nil
    end
end # class
