
#
# 周波数偏差（CW)
#

    $sock.puts(""INST SPECT"")                              #SAモードでは下記のコマンドを使用  INST SIGANA"
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
    
    $sock.puts("FREQ:CENT 920MHZ")                          #中心周波数設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("FREQ:SPAN 500KHZ")                          #SPAN設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("BAND 1KHZ")                                 #RBW設定
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("BAND:VID 1KHZ")                             #VBW設定SAモードでは使用しない
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:POIN 1001")                             #トレースポイント設定SAモードでは使用しない
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("DET POS")                                   #検波モードを設定ポジティブピーク
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("TRAC1:STOR:MODE MAXH")                      #表示モードをマックスホールド設定TRAC:STOR:MODE MAXH
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(""CALC:MARK:FCO ON"")                        #周波数カウンタをON設定SAモードでは下記のコマンドを使用する  CALC:MARK1:STAT"
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("TRAC1:STOR:MODE OFF")                       #トレースデータのストレージ方法を設定
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("AVER:COUN 5")                               #Average回数を設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:TIME:AUTO:MODE FAST")                   #掃引モード設定SAモードでは使用しない
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(""SWE:TIME 1s"")                             #掃引時間の設定SAモード時は下記のコマンドを使用する  CALC:ATIM:LENG 2MS"
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #Reference Level
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("INIT:MODE:SING")                            #シングル掃引を開始する
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(""CALC:MARK:FCO:X?"")                        #周波数カウンタの値を読み取るSAモードでは下記のコマンドを使用する  CALC:MARK:Y?"
    $sock.puts("*OPC")
    $sock.gets
