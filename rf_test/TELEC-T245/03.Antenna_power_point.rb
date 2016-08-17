
    #
    # 空中線電力（尖頭電力）
    #

#!/usr/bin/ruby

require '../openif.rb'


    $sock.puts("INST SPECT")                                #SAモードでは下記のコマンドを使用  INST SIGANA"
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
    
    $sock.puts("FREQ:CENT 920MHZ")                          #中心周波数設定  この例では中心周波数を920MHzに設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("FREQ:SPAN 500KHZ")                          #SPAN設定  この例ではSpan=500kHzに設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("CALC:MARK:MODE OFF")                        #マーカーOFF設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("BAND 1MHZ")                                 #RBW設定  この例ではRBW=1MHzに設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("BAND:VID 3MHZ")                             #VBW設定  SAモードでは使用しない  この例ではVBW=1MHzに設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:POIN 1001")                             #トレースポイント設定  SAモードでは使用しない この例では1001ポイントに設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("DET POS")                                   #検波モードを設定  この例ではポジティブピークに設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("TRAC1:STOR:MODE MAXH")                      #表示モードをマックスホールド設定  SAモードでは下記コマンドを使用する  TRAC:STOR:MODE MAXH
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("AVER:COUN 5")                               #Average回数を設定  この例ではアベレージ回数を５回に設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:TIME:AUTO:MODE FAST")                   #トレースデータのストレージ方法を設定  SAモードでは使用しない  この例では掃引モードをfastに設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #リファレンスレベル設定(dBm)  この例ではリファレンスレベルを-10dBmに設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":UNIT:POWer W")                             #表示をWに変換
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":CALC:MARK:MODE NORM")                      #マーカをNORMALに設定する。
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":CALCulate:MARKer:CENTer")                  #マーカ周波数をセンタ周波数に設定する。
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:TIME 5.46s")                            #掃引時間を設定  SAモードでは下記コマンドを使用する  CALC:ATIM:LENG 2MS  この例では5.46秒に設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":CALCulate:MARKer:WIDTh:POINt 1001")        #ゾーンマーカの幅を表示ポイントで設定  SAモードでは使用しない
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("INIT:MODE:SING")                            #掃引を実行する。  この例では指定したアベレージ回数である5回、掃引する。
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":CALCulate:MARKer:MAX")                     #ピークサーチ
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":CALCulate:MARKer:CENTer")                  #マーカ周波数をセンタ周波数に設定する。
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":CALCulate:MARKer:WIDTh:POINt 1001")        #ゾーン幅をSPANに設定する。  SAモードでは使用しない
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":CALCulate:MARKer:Y?")                      #マーカ点のレベルを読み出します。
    $sock.puts("*OPC?")
    $sock.gets
    
