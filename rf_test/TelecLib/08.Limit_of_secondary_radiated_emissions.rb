#!/usr/bin/ruby
#
# 8.副次的に発する電波などの限度
#

require './socket.rb'
require './subghz.rb'


#setup DUT --------------------------------------
class Telectp::Test

	def _08_Limit_of_secondary_radiated_emissions
#	mas(50,24)
		_08_mas(100,42)
#	mas(50,61)
#		$sock.close
	end

	def _08_mas(ra,ch)
		sbg = Subghz.new()
		sbg.setup(ch, ra, POW)
		sbg.rxon()

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

		$sock.puts("INIT:CONT OFF")                                                                                 #連続掃引OFF設定
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SPUR:SEGM:STAT ON,ON,ON,ON,ON,ON,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF")      #セグメントのOn/Off を設定
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SPUR:FREQ:STAR 30MHz,710MHz,900MHz,915MHZ,930MHZ,1000MHZ,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")    #各セグメントの開始周波数を設定
		$sock.puts("*OPC?") 
		$sock.gets

#$sock.puts("SPUR:FREQ:STOP 710MHZ,900MHZ,915MHZ,930MHZ,1000MHZ,5000MHZ,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")  #各セグメントの終端周波数を設定
		$sock.puts("SPUR:FREQ:STOP 710MHZ,900MHZ,915MHZ,930MHZ,1000MHZ,3000MHZ,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")  #各セグメントの終端周波数を設定
		$sock.puts("*OPC?")  
		$sock.gets

		$sock.puts("DISP:SPUR:VIEW:WIND:TRAC:Y:RLEV 10DBM,10DBM,10DBM,10DBM,10DBM,10DBM,0,0,0,0,0,0,0,0,0,0,0,0,0,0")                                   #各セグメントのReference Level を設定
		$sock.puts("*OPC?")  
		$sock.gets

		$sock.puts("SPUR:DET POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS")      #各セグメントの波形パターンの検波方式を設定
		$sock.puts("*OPC?")    
		$sock.gets

		$sock.puts("SPUR:BAND:AUTO OFF,OFF,OFF,OFF,OFF,OFF,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")              #各セグメントのRBW のAuto/Manual を設定
		$sock.puts("*OPC?")  
		$sock.gets

		$sock.puts("SPUR:BAND 100KHZ,1MHZ,100KHZ,100KHZ,100KHZ,1MHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ")  #各セグメントの分解能帯域幅（RBW）を設定
		$sock.puts("*OPC?") 
		$sock.gets

		$sock.puts("SPUR:BAND:VID:AUTO OFF,OFF,OFF,OFF,OFF,OFF,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")          #各セグメントの分解能帯域幅を自動設定する
		$sock.puts("*OPC?")    
		$sock.gets

		$sock.puts("SPUR:BAND:VID 100KHZ,1MHZ,100KHZ,100KHZ,100KHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ")             #各セグメントのビデオ帯域幅を設定
		$sock.puts("*OPC?") 
		$sock.gets

		$sock.puts("SPUR:SWE:TIME 10ms,10ms,10ms,10ms,10ms,10ms,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1")                                   #掃引時間を設定
		$sock.puts("*OPC?") 
		$sock.gets

		$sock.puts("SPUR:SWE:TIME:AUTO ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")                #Autoの場合、周波数ドメインではデフォルトで10msを設定
		$sock.puts("*OPC?")  
		$sock.gets

		$sock.puts("SPUR:SWE:POIN 1001,1001,1001,1001,1001,1001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001")        #各セグメントのトレース表示のポイント数を設定
		$sock.puts("*OPC?") 
		$sock.gets

		$sock.puts("SPUR:TDOM:SPAN:ZERO OFF")   
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SPUR:TDOM:DET SAMP,SAMP,SAMP,SAMP,SAMP,SAMP,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS")                                   #Time Domain Measurement の波形パターンの検波方式を設定
		$sock.puts("*OPC?") 
		$sock.gets

		$sock.puts("SPUR:TDOM:BAND 100KHZ,1MHZ,100KHZ,100KHZ,1MHZ,1MHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ")   #Time Domain Measurement のRBW を設定
		$sock.puts("*OPC?")    
		$sock.gets

		$sock.puts("SPUR:TDOM:BAND:VID 100KHZ,1MHZ,100KHZ,100KHZ,1MHZ,1MHZ,1,1,1,1,1,1,1,1,1,1,1,1,1,1")            #Time Domain Measurement のVBW を設定
		$sock.puts("*OPC?")  
		$sock.gets

		$sock.puts("SPUR:TDOM:SWE:TIME 5.46ms,5.46ms,5.46ms,5.46ms,5.46ms,5.46ms,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1")                  #Time Domain Measurement の掃引時間を設定
		$sock.puts("*OPC?")  
		$sock.gets

		$sock.puts("CALC:SPUR:LIM:ABS:DATA -54DBM,-55DBM,-55DBM,-54DBM,-55DBM,-47DBM,-10DBM,-10DBM,-13DBM,-13DBM,-13DBM,-13DBM,-13DBM,-13DBM,-10DBM,-10DBM,-13DBM,-13DBM,-13DBM,-13DBM")    #Limitを設定
		$sock.puts("*OPC?")   
		$sock.gets

		$sock.puts("CONF:SPUR")                                                                                     #Spurious Emission 測定をOn に設定
		$sock.puts("*OPC?")  
		$sock.gets

		$sock.puts("INIT:SPUR")                                                                                     #Spurious 測定を開始
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("FETC:SPUR?")                                                                                  #Spurious Emission 測定の測定結果を取得
		$sock.puts("*OPC?")
		r = $sock.gets.split(",")

		sbg.trxoff()

		i=0
		$log.info("+++++++++++ SUMMARY ++++++++++\n")
		$log.info("Subject: 08 Limit of secondary radiated emissionsn\n")
		$log.info(sprintf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", "No","Segment","frequency","peak","margin","limit","jude"))
		$log.info(sprintf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1]))
		$log.info(sprintf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1]))
		$log.info(sprintf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1]))
		$log.info(sprintf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1]))
		$log.info(sprintf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1]))
		$log.info(sprintf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1]))
		if r[0].to_i == 1 then
		$log.info("Judgement: FAIL")
		raise StandardError, "FAIL\n"
		else
		$log.info("Judgement: PASS")
		end
	end
end
