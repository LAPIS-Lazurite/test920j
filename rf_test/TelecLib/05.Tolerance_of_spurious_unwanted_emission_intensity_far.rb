#!/usr/bin/ruby

#
# ｽﾌﾟﾘｱｽ発射又は不要発射の強度（近傍）
#

require './socket.rb'
require './subghz.rb'

#setup DUT --------------------------------------
class Telectp::Test
	def _05_Tolerance_of_spurious_unwanted_emission_intensity_far
#	mas(50,24)
#	mas(50,61)
		val = _05_mas(100,42)
        return val
	end

	def _05_mas(ra,ch)
        begin
            sbg = Subghz.new()
            sbg.setup(ch, ra, POW)
            sbg.mod(1)
            sbg.txon()

    #setup TESTER --------------------------------------
            $sock.puts("INST SPECT")
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SYST:PRES")
            $sock.puts("*OPC?")
            $sock.gets
                
            $sock.puts("syst:lang scpi")
            $sock.puts("*OPC?")
            $sock.gets
                
            $sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS:STAT ON")
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS 0")
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("INIT:CONT OFF")                                                                                                                         #連続掃引OFF設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:SEGM:STAT ON,ON,ON,ON,ON,ON,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF")                                              #セグメントのOn/Off を設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:FREQ:STAR 30MHz,710MHz,900MHz,930MHz,1000MHZ,1215MHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")       #各セグメントの開始周波数を設定
            $sock.puts("*OPC?")
            $sock.gets

    #$sock.puts("SPUR:FREQ:STOP 710MHZ,900MHZ,915MHZ,1000MHZ,1215MHZ,5000MHZ,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")     #各セグメントの終端周波数を設定
            $sock.puts("SPUR:FREQ:STOP 710MHZ,900MHZ,915MHZ,1000MHZ,1215MHZ,3000MHZ,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")     #各セグメントの終端周波数を設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("DISP:SPUR:VIEW:WIND:TRAC:Y:RLEV -10,-10,-10,-10,-10,-10,0,0,0,0,0,0,0,0,0,0,0,0,0,0")                                                   #各セグメントのReference Level を設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:ATT AUTO,AUTO,AUTO,AUTO,AUTO,AUTO,AUTO,AUTO,AUTO,AUTO,AUTO,AUTO,AUTO,AUTO,AUTO,AUTO,AUTO,AUTO,AUTO,AUTO")                          #各セグメントのATT のAuto or Level を設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:BAND:AUTO OFF,OFF,OFF,OFF,OFF,OFF,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")                                                      #各セグメントのRBW のAuto/Manual を設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:BAND 100KHZ,1MHZ,100KHZ,100KHZ,1MHZ,1MHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ")     #各セグメントの分解能帯域幅（RBW）を設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:BAND:VID:AUTO OFF,OFF,OFF,OFF,OFF,OFF,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")                                                  #各セグメントの分解能帯域幅を自動設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:BAND:VID 100KHZ,1MHZ,100KHZ,100KHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ")               #各セグメントのビデオ帯域幅を設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:SWE:TIME 5.46S,5.46S,5.46S,5.46S,5.46S,5.46S,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1")                             #掃引時間を設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:SWE:TIME:AUTO OFF,OFF,OFF,OFF,OFF,OFF,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")                                                  #各セグメントのSweep Time のAuto/Manual を設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:DET POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS")                                              #各セグメントの波形パターンの検波方式を選択
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:SWE:POIN 1001,1001,1001,1001,1001,1001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001")       #各セグメントのトレース表示のポイント数を設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:TDOM:SPAN:ZERO OFF")                                                                                                               #スプリアス電力をタイムドメインで測定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:TDOM:BAND 100KHZ,1MHZ,100KHZ,100KHZ,1MHZ,1MHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ")   #Time Domain Measurement のRBW を設定
            $sock.puts("*OPC?")
            $sock.gets
                
            $sock.puts("SPUR:TDOM:DET SAMP,SAMP,SAMP,SAMP,SAMP,SAMP,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS")                                   #Time Domain Measurement の波形パターンの検波方式を選択
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:TDOM:BAND:VID 100KHZ,1MHZ,100KHZ,100KHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ")          #Time Domain Measurement のVBW を設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SPUR:TDOM:SWE:TIME 5.46S,5.46S,5.46S,5.46S,5.46S,5.46S,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1")                        #Time Domain Measurement の掃引時間を設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("CALC:SPUR:LIM:ABS:DATA -36DBM,-55DBM,-55DBM,-55DBM,-45DBM,-30DBM,-10DBM,-10DBM,-13DBM,-13DBM,-13DBM,-13DBM,-13DBM,-13DBM,-10DBM,-10DBM,-13DBM,-13DBM,-13DBM,-13DBM")  #Limitを設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("CONF:SPUR")                                                                                                                             #Spurious Emission 測定をOn に設定
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("INIT:SPUR")                                                                                                                             #Spurious 測定を開始
            $sock.puts("*OPC?")
            $sock.gets

    #Spurious Emission 測定の測定結果を取得
            $sock.puts("FETC:SPUR?")
            $sock.puts("*OPC?")
            r = $sock.gets.split(",")

            sbg.trxoff()

            i=0
            $log.info("+++++++++++ SUMMARY ++++++++++")
            $log.info("Subject: 05 Tolerance of spurious unwanted emission intensity far")
            $log.info(sprintf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s", "No","Segment","frequency","peak","margin","limit","jude"))
            $log.info(sprintf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1]))
            $log.info(sprintf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1]))
            $log.info(sprintf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1]))
            $log.info(sprintf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1]))
            $log.info(sprintf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1]))
            $log.info(sprintf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1]))
            if r[0].to_i == 1 then
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
