#!/usr/bin/ruby
#
# 周波数偏差（変調）、占有帯域測定
#
require '/home/pi/test920j/rf_test/socket.rb'
require '/home/pi/test920j/rf_test/subghz.rb'

#setup DUT --------------------------------------
class Telectp::Test
	def _01_Tolerance_of_occupied_bandwidth_Frequency_range
	#	_01_mas(50,24)
	#	_01_mas(50,61)
		val = _01_mas(100,42)
        return val
	end

	def _01_mas(ra,ch)
        begin
            sbg = Subghz.new()
            sbg.setup(ch, ra, POW)
            sbg.mod(1)
            sbg.txon()

    #setup TESTER --------------------------------------
            $sock.puts("INST SPECT")                                #SAモードでは下記のコマンドを使用  INST SIGANA
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("syst:lang scpi")
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SYST:PRES") 
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS:STAT ON")
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS 0")
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("INIT:CONT ON")                              #連続掃引設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("FREQ:CENT " + $frq[ra][ch])                #中心周波数設定 この例では中心周波数を920MHzに設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("FREQ:SPAN 500KHZ")                          #SPAN設定   この例ではSpan=500kHzに設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("CALC:MARK:MODE OFF")                        #マーカーOFF設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("BAND 1KHZ")                                 #RBW設定    この例ではRBW=1kHzに設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("BAND:VID 1KHZ")                             #VBW設定    SAモードでは使用しない  この例ではVBW=1kHzに設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SWE:POIN 1001")                             #トレースポイント設定   SAモードでは使用しない  この例では1001ポイントに設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("DET POS")                                   #検波モードを設定   この例ではポジティブピークに設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("TRAC1:STOR:MODE MAXH")                      #表示モードをマックスホールド設定   SAモードでは下記コマンドを使用する  TRAC:STOR:MODE MAXH"
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("OBW:METH NPERcent")                         #MethodをN%に設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("OBW:PERC 99.00")                            #N% Ratioを99%に設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("AVER:COUN 5")                               #Average回数設定    この例ではアベレージ回数を５回に設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SWE:TIME:AUTO:MODE FAST")                   #掃引モード設定 SAモードでは使用しない  この例では掃引モードをfastに設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SWE:TIME 5.46s")                            #掃引時間の設定 SAモードでは下記コマンドを使用する  CALC:ATIM:LENG 2MS  この例では5.46sに設定"
            $sock.puts("*OPC?")
            $sock.gets

    #$sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #Reference Level    この例ではリファレンスレベルを-10dBmに設定
            $sock.puts("DISP:WIND:TRAC:Y:RLEV 10")                 #Reference Level    この例ではリファレンスレベルを-10dBmに設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("OBW ON")                                    #Occupied Bandwidth 測定を実行
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("INIT:MODE:SING")
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("FETC:OBW?")                                 #OBW、周波数偏差の測定結果問い合わせ
            $sock.puts("*OPC?")
            result = $sock.gets.split(",")
            center = result[1].to_i
            lower = result[2].to_i
            upper = result[3].to_i
            frequency = $frq[ra][ch].to_i

            sbg.trxoff()

            $log.info("+++++++++++ SUMMARY ++++++++++")
            $log.info("Subject: 01 Tolerance of occupied bandwidth Frequency rangen")
            $log.info(sprintf("Center Frequencey: %d",frequency))
            $log.info(sprintf("OBW Center: %d",center))
            $log.info(sprintf("OBW Lower: %d",lower))
            $log.info(sprintf("OBW Upper: %d",upper))
            $log.info(sprintf("Deviation: %d",DEV * $frq[ra][ch].to_i))
#           if (frequency - center).abs > (DEV * frequency) then
            if ((upper - lower) < 200000 && (upper - lower) > 170000) then
                $log.info("Judgement: FAIL")
                raise StandardError, "FAIL\n"
            else
                $log.info("Judgement: PASS")
            end
        rescue StandardError
            printf("Error: program stop\n")
            return "Error"
        end
        return nil
	end
end
