#!/usr/bin/ruby
#
# ｷｬﾘｱｾﾝｽ機能
#

require '../socket.rb'
require '../subghz.rb'

	sbg = Subghz.new()
	sbg.setup(42, 100, 20)
	sbg.wf("Welcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductor")
#	sbg.rw("8 0x13 ","0x00")

	snd_thread = Thread.new do
		while 1
			p sbg.com("sgs 0xffff 0xffff")
			if @send_flg == 1 then
				break
			end
		end
	end

	tester_thread = Thread.new do
		@send_flg = 0
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
		
		$sock.puts("INST SG")                                   #アクティブなアプリケーションをSGに設定
		$sock.puts("*OPC?")
		$sock.gets
		
		$sock.puts("OUTP OFF")                                  #SGのレベル出力OFF
		$sock.puts("*OPC?")
		$sock.gets
		
		$sock.puts("INST SPECT")                                #アクティブなアプリケーションをSPECTに設定
		$sock.puts("*OPC?") 
		$sock.gets
		
		$sock.puts("INIT:CONT OFF")                             #連続掃引OFF設定
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("FREQ:CENT 924.3MHZ")                          #中心周波数設定 この例では中心周波数を920MHzに設定
		$sock.puts("*OPC?")
		$sock.gets
		
		$sock.puts("FREQ:SPAN 12.2MHZ")                     #SPAN設定SAモードでは下記のコマンドを使用   FREQ:SPAN 25MHZ この例ではSpan=12.5MHzに設定"
		$sock.puts("*OPC?") 
		$sock.gets
		
		$sock.puts("CALC:MARK:MODE OFF")                        #マーカーOFF
		$sock.puts("*OPC?") 
		$sock.gets
		
		$sock.puts("BAND 100KHZ")                               #RBW設定    この例ではRBW=100kHzに設定
		$sock.puts("*OPC?")    
		$sock.gets
			
#		$sock.puts("BAND:VID 300KHZ")                           #VBW設定    SAモードでは使用しない  この例ではVBW=300kHzに設定
#		$sock.puts("*OPC?")
#		$sock.gets
			
		$sock.puts("TRIG OFF")                                  #TriggerSwitch設定
		$sock.puts("*OPC?")
		$sock.gets
			
		$sock.puts("DET POS")                                   #検波モードをポジティブピーク設定   この例ではポジティブピークに設定
		$sock.puts("*OPC?")
		$sock.gets
			
#    	$sock.puts("SWE:POIN 1001")                             #トレースポイント数を設定   SAモードでは使用しない  この例では1001ポイントに設定
#    	$sock.puts("*OPC?")
#    	$sock.gets
			
#    	$sock.puts("SWE:TIME:AUTO:MODE FAST")                   #掃引モード設定 SAモードでは使用しない  掃引モードをfastに設定
#    	$sock.puts("*OPC?")
#    	$sock.gets
			
		$sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #Reference Level    この例ではリファレンスレベルを-10dBmに設定
		$sock.puts("*OPC?") 
		$sock.gets

		$sock.puts("INIT:CONT ON")                              #連続掃引ON設定
		$sock.puts("*OPC?")
			$sock.gets

		$sock.puts("INST SPECT")                                #アクティブなアプリケーションをSPECTに設定  SAモードでは下記のコマンドを使用    INST SIGANA"
		$sock.puts("*OPC?") 
		$sock.gets

		$sock.puts("FREQ:CENT 924.3MHZ")                          #中心周波数を設定
		$sock.puts("*OPC?") 
		$sock.gets

		$sock.puts("FREQ:SPAN 0HZ")     #SPANを設定 SAモードでは下記のコマンドを使用    (Trace ModeをPwer vs Timeに設定)    TRAC:MODE PVTゼロスパンに設定
		$sock.puts("*OPC?")  

		$sock.puts("CALC:MARK:MODE OFF")                        #マーカーをOFFに設定
		$sock.puts("*OPC?")   
		$sock.gets

		$sock.puts("SWE:TIME 500MS")                            #Time DomainのSweep Timeを設定
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("INST SG")                                   #アクティブなアプリケーションをSGに設定
		$sock.puts("*OPC?")  
		$sock.gets

		$sock.puts("FREQ 924.3MHZ")                               #SGの中心周波数を設定する   この例では中心周波数を920MHzに設定
		$sock.puts("*OPC?")    
		$sock.gets

		$sock.puts("POWer -10DBM")                              #SGのレベルを設定する   この例では-10dBmに設定する。
		$sock.puts("*OPC?")  
		$sock.gets

 		$sock.puts("MMEM:Load:WAV 'WiSUN-TxDemo','WiSUN_FET_D100F2_P08'")       #SGの波形メモリに波形をロードする   この例ではPackage名が'WiSUN-TxDemo、パターン名がWiSUN_FET_D100F2_P08の波形をロード
 		$sock.puts("*OPC?")   
 		$sock.gets
		
 		$sock.puts("SOUR:RAD:ARB:WAV 'WiSUN-TxDemo','WiSUN_FET_D100F2_P08'")    #SGの波形を選択する この例ではPackage名が'WiSUN-TxDemo、パターン名がWiSUN_FET_D100F2_P08の波形を選択
		$sock.puts("*OPC?")
		$sock.gets
		
		$sock.puts("OUTP ON")                                   #SGの信号出力をONに設定
		$sock.puts("*OPC?")    
		$sock.gets
		
#		$sock.puts("OUTP:MOD ON")                               #SGの変調をONに設定
		$sock.puts("OUTP:MOD OFF")                               #SGの変調をONに設定
		$sock.puts("*OPC?")    
		$sock.gets
		
		sleep 5
		@send_flg = 1

		$sock.puts("INST SPECT")                                #アクティブなアプリケーションをスペアナに設定   SAモードでは下記のコマンドを使用    INST SIGANA"
		$sock.puts("*OPC")   
#		$sock.gets
		
		$sock.close
	end

	tester_thread.join
	snd_thread.join
