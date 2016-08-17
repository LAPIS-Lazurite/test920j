#
# ｷｬﾘｱｾﾝｽ機能
#

    $sock.puts("INST SPECT")                                #SAモードでは下記のコマンドを使用   INST SIGANA"
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

    $sock.puts("FREQ:CENT 922MHZ")                          #中心周波数設定 この例では中心周波数を920MHzに設定
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
    
    $sock.puts("BAND:VID 300KHZ")                           #VBW設定    SAモードでは使用しない  この例ではVBW=300kHzに設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("TRIG OFF")                                  #TriggerSwitch設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("DET POS")                                   #検波モードをポジティブピーク設定   この例ではポジティブピークに設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:POIN 1001")                             #トレースポイント数を設定   SAモードでは使用しない  この例では1001ポイントに設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:TIME:AUTO:MODE FAST")                   #掃引モード設定 SAモードでは使用しない  掃引モードをfastに設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #Reference Level    この例ではリファレンスレベルを-10dBmに設定
    $sock.puts("*OPC?") 
    $sock.gets
    
    $sock.puts("INIT:CONT ON")                              #連続掃引ON設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("INST SPECT")                                #アクティブなアプリケーションをSPECTに設定  SAモードでは下記のコマンドを使用    INST SIGANA"
    $sock.puts("*OPC?") 
    $sock.gets
    
    $sock.puts("FREQ:CENT 920MHZ")                          #中心周波数を設定
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
    
    $sock.puts("FREQ 920MHZ")                               #SGの中心周波数を設定する   この例では中心周波数を920MHzに設定
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
    
    $sock.puts("OUTP:MOD ON")                               #SGの変調をONに設定
    $sock.puts("*OPC?")    
    $sock.gets
    
    $sock.puts("INST SPECT")                                #アクティブなアプリケーションをスペアナに設定   SAモードでは下記のコマンドを使用    INST SIGANA"
    $sock.puts("*OPC")   
    $sock.gets
    
