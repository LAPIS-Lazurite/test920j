#!/usr/bin/ruby
#
# 隣接ﾁｬﾝﾈﾙ漏洩電力
#

require '../openif.rb'

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
    
    $sock.puts("INIT:CONT OFF")                              #連続掃引OFF設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("FREQ:CENT 920MHZ")                          #中心周波数設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("FREQ:SPAN 1MHZ")                            #SPAN設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("BAND 1KHZ")                                 #RBW設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("BAND:VID 3KHZ")                             #VBW設定    SAモードでは使用しない
    $sock.puts("*OPC?")
    $sock.gets
        
    $sock.puts("SWE:POIN 1001")                             #トレースポイント設定   SAモードでは使用しない
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("DET POS")                                   #検波モード設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("TRIG ON")                                   #SAモードでは本コマンドを追加
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("TRIG:VID:LEV -30")                          #SAモードでは本コマンドを追加
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("TRAC1:STOR:MODE OFF")                       #表示モード設定     SAモードでは下記コマンドに変更  TRAC:STOR:MODE OFF"
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:TIME:AUTO:MODE FAST")                   #FAST/NORM      SAモードでは使用しない
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:TIME 5.46s")                            #掃引時間の設定     SAモードでは下記コマンドに変更  CALC:ATIM:LENG 2MS"
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #Reference Level
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("ACP ON")                                    #ACP測定ON
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("ACP:CARR:RCAR:METH BSIDes")                 #相対レベル表示の基準を設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("ACP:CARR:LIST:WIDT 200000")                 #キャリアの周波数間隔を設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("ACP:CARR:LIST:BAND 200KHZ")                 #キャリアの測定帯域幅を設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("ACP:CARR:FILT:TYPE RECT")                   #キャリアのフィルタ種類を設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("ACP:OFFS:BAND 200KHZ")                      #Offset Channel 帯域幅を設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("ACP:OFFS:FILT:TYPE RECT")                   #オフセットのフィルタ種類を設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("ACP:OFFS:LIST 200KHZ,0,0")                  #オフセットチャネルのオフセット周波数を設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("ACP:OFFS:LIST:STAT ON,OFF,OFF")             #オフセットチャネルを設定
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("INIT:MODE:SING")                            #Single測定を実行   
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("FETC:ACP?")                                 #ACP測定値を問い合わせ
    $sock.puts("*OPC?")
    $sock.gets
    
