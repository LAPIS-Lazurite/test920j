#!/usr/bin/ruby
#
# 空中線電力（平均電力）
#

require './socket.rb'
require './subghz.rb'

#setup DUT --------------------------------------

class Telectp::Test

	def _04_Antenna_power_ave(att)
        _04_mas(100,24,att)
        _04_mas(100,42,att)
        _04_mas(100,60,att)
    end

    def _04_mas(rate,ch,att)
        sbg = Subghz.new()
        sbg.setup(ch, rate, POW)
        sbg.wf()

#setup TESTER --------------------------------------
        @@ATT = att.to_f.round(2)
        $sock.puts("INST SPECT")                                #SAモードでは下記のコマンドを使用   INST SIGANA"
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

        $sock.puts("INIT:CONT OFF")                             #連続掃引OFF設定
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("FREQ:CENT " + $frq[rate][ch])                          #中心周波数設定     この例では中心周波数を920MHzに設定
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("FREQ:SPAN 500KHZ")                          #SPAN設定   この例ではSpan=500kHzに設定
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("BAND 1MHZ")                                 #RBW設定    この例ではRBW=1MHzに設定
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("BAND:VID 3MHZ")                             #VBW設定    SAモードでは使用しない  この例ではVBW=1MHzに設定
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("SWE:POIN 1001")                             #トレースポイント設定   SAモードでは使用しない  この例では1001ポイントに設定
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("DET SAMP")                                  #検波モード設定     この例ではポジティブピークに設定
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("BPOW ON")                                   #BurstAveragePower測定をONに設定
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("SWE:TIME 5.46MS")                           #SweepTimeを設定    SAモードでは下記コマンドに変更  CALC:ATIM:LENG 2MS  この例ではSweep Timeを5.46sに設定
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("TRIG:EXT:SLOP POS")                         #トリガのエッジを設定する   SAモードでは下記コマンドを使用  TRIG:SLOP POS   この例では立ち上がりエッジに設定する
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("TRIG:VID:LEV -40DBM")                       #TriggerLevel設定   この例ではトリガレベルを-40dBmに設定する。
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("TRIG ON")                                   #TriggerSwitch設定
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("BPOW:BURS:STAR 0S")                         #StartTime設定  SAモードでは下記コマンドを使用  CALC:ATIM:STAR 0S   この例ではStart Timeを0sに設定する"
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("SWE:TIME:AUTO:MODE FAST")                   #掃引モード設定     SAモードでは使用しない  この例では掃引モードをfastに設定する
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                #リファレンスレベル設定(dBm)    この例ではリファレンスレベルを-10dBmに設定する。
        $sock.puts("*OPC?")
        $sock.gets

#$sock.puts(":UNIT:POWer W")                             #表示をWに変換
        $sock.puts(":UNIT:POWer DBM")                             #表示をWに変換
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("CALC:MARK:MODE OFF")                        #マーカーOFF設定
        $sock.puts("*OPC?")
        $sock.gets

#$sock.puts("INIT:MODE:SING")                            #SAモードではトレースモードを変更してからからこのコマンドを送る(6行下を参照)
#$sock.puts("*OPC?")
#$sock.gets

        $sock.puts("TRAC? TRAC1")                               #トレースデータを読み出す
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("BPOW:BURS:STOP 2.67818181818182MS")         #Burst Average Power 測定の終了位置（時間）を設定   SAモードでは下記コマンドを使用      TRAC:MODE PVT"
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("INIT:MODE:SING")                            #SAモードではトレースモードを変更してからからこのコマンドを送る(6行下を参照)
        $sock.puts("*OPC?")
        $sock.puts("*WAI")

        for i in 1..10
            p sbg.com("sgs 0xffff 0xffff")
        end

#$sock.puts("INIT:MODE:SING")                             #SAモードでは本コマンドを挿入
#$sock.puts("*OPC?")
#$sock.gets

        $sock.puts("FETC:BPOW?")                                #BurstAveragePowerの測定結果を読み取る
        $sock.puts("*OPC?")
        result = $sock.gets.to_f + @@ATT
        p result

        $sock.puts("TRIG OFF")
        $sock.puts("*OPC?")
        $sock.gets

#		$sock.close

        printf("+++++++++++ SUMMARY ++++++++++\n")
        printf("Subject: 04 Antenna power average\n")
        printf("Frequency: %s\n", $frq[rate][ch])
        printf("Attenuate: %d dB\n",@@ATT)
        printf("Result: %3.2f dBm\n",result)
        if result.between?(9,13) == false then
            printf("Judgement: %s\n", "FAIL")
            raise StandardError, "FAIL\n"
        else
            printf("Judgement: %s\n", "PASS")
        end
	end
end
