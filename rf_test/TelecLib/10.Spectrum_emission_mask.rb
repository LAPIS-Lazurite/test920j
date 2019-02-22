#!/usr/bin/ruby

#
# ｽﾍﾟｸﾄﾗﾑｴﾐｯｼｮﾝﾏｽｸ
#

require '/home/pi/test920j/rf_test/socket.rb'
require '/home/pi/test920j/rf_test/subghz.rb'

#setup DUT --------------------------------------
class Telectp::Test

	def _10_Spectrum_emission_mask
#	    mas(50,24)
#	m   as(100,42)
		val = _10_mas(50,61)
        return val
	end

	def _10_mas(ra,ch)
        begin
		    sbg = Subghz.new()
            sbg.setup(ch, ra, POW)
            sbg.mod(1)
            sbg.txon()

    #setup TESTER --------------------------------------
            pow = {20 => "13", 1 => "0"}
            band= {50 => "200", 100 => "400"}

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

            $sock.puts("INIT:CONT OFF")                             #連続掃引をOFF設定
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("FREQ:CENT " + $frq[ra][ch])                #中心周波数を設定
            $sock.puts("*OPC?")  
            $sock.gets

            $sock.puts("SEM:BAND:CHAN " + band[ra] + "KHZ")                      #Channel BWをチャネル帯域幅×キャリア数に設定   チャネル帯域幅は試験周波数から判定する
            $sock.puts("*OPC?")    
            $sock.gets

    #		when useing to 100kbps
    #		$sock.puts("SEM:OFFS:LIST:STAR:ABS1 " + pow[POW] + "DBM,-36DBM,0,0,0,0")                           #Limit Startレベルを設定
            $sock.puts("SEM:OFFS:LIST:STAR:ABS1 0DBM,-36DBM,0,0,0,0")                           #Limit Startレベルを設定
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:STOP:ABS1 -36DBM,-36DBM,0,0,0,0")                         #Limit Stopレベルを設定
            $sock.puts("*OPC?")    
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:FREQ:STAR 100KHZ,300KHZ,0HZ,0HZ,0HZ,0HZ")                 #Offset Start周波数を設定
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:FREQ:STOP 300KHZ,500KHZ,300KHZ,300KHZ,300KHZ,300KHZ")     #Offset Stop周波数を設定
            $sock.puts("*OPC?")    
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:STAT ON,ON,OFF,OFF,OFF,OFF")                              #Offset をONに設定
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("SEM:LOG:OFFS:LIST:TEST ABS,ABS,ABS,ABS,ABS,ABS")                        #Offsetの判定方法をABS(絶対値)に設定
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("SEM:BAND 100KHZ")                           #RBW設定    この例ではRBW=100kHzに設定
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("SEM:BAND:VID 100KHZ")                       #VBW設定    この例ではVBW=100kHzに設定
            $sock.puts("*OPC?")    
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:BAND 100KHZ,100KHZ,100KHZ,100KHZ,100KHZ,100KHZ")          #RBW設定（Offset側）
            $sock.puts("*OPC?")  
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:BAND:VID 100KHZ,100KHZ,100KHZ,100KHZ,100KHZ,100KHZ")      #VBW設定（Offset側）
            $sock.puts("*OPC?")  
            $sock.gets

            $sock.puts("SEM:SWE:TIME:AUTO ON")                      #基準パワー測定時の掃引時間を自動設定にする
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:SWE:TIME:AUTO ON,ON,ON,ON,ON,ON")                         #掃引時間 Auto or Manualの判定と設定（offset）
            $sock.puts("*OPC?")  
            $sock.gets

            $sock.puts("SEM:DET POS")                               #検波モードを設定   この例ではポジティブピークに設定
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:DET POS,POS,POS,POS,POS,POS") #オフセットの検波方式を設定 この例ではポジティブピークに設定
            $sock.puts("*OPC?")    
            $sock.gets

            $sock.puts("TRAC1:STOR:MODE MAXH")                      #表示モードをマックスホールド設定
            $sock.puts("*OPC?")    
            $sock.gets

            $sock.puts("AVER:COUN 10")                              #掃引回数の設定 この例では平均回数を１０回に設定
            $sock.puts("*OPC?")
            $sock.gets

    #		when useing to 100kbps
    #		$sock.puts("DISP:WIND:TRAC:Y:RLEV " + pow[POW])         #Reference Level    この例ではリファレンスレベルを0dBmに設定
            $sock.puts("DISP:WIND:TRAC:Y:RLEV 0")                   #Reference Level    この例ではリファレンスレベルを0dBmに設定
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("CONF:SEM")                                  #Spurious Emmision Mask測定をONする
            $sock.puts("*OPC?")    
            $sock.gets

            $sock.puts("SEM:RAC ON")                                #Reference Level とAttenuator の設定共有をOn にする"
            $sock.puts("*OPC?")  
            $sock.gets

            $sock.puts(":READ:SEMask?")                             #測定結果を読み込む
            $sock.puts("*OPC") 

            $sock.puts("FETC:SEM?")                                #Spectrum Emission 測定の測定結果を取得
            $sock.puts("*OPC?")
            r = $sock.gets.split(",")

            sleep 2
            sbg.trxoff()

            i=0
            $log.info("+++++++++++ SUMMARY ++++++++++")
            $log.info("Subject: 10 Spectrum emission mask")
            $log.info(sprintf("Reference power: %s\n",r[1]))
            $log.info(sprintf("%-16s %-16s %-16s %-16s %-16s %-16s","Lower peak","Lower margin","Lower frequency","Upper peak"," Upper margin","Upper frequency"))
            $log.info(sprintf("%-16s %-16s %-16s %-16s %-16s %-16s",r[i+=2],r[i+=1],r[i+=1],r[i+=2],r[i+=1],r[i+=1]))
            $log.info(sprintf("%-16s %-16s %-16s %-16s %-16s %-16s",r[i+=2],r[i+=1],r[i+=1],r[i+=2],r[i+=1],r[i+=1]))
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
