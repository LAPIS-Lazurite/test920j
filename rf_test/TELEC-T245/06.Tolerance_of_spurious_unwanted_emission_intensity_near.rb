#!/usr/bin/ruby

#
# ｽﾌﾟﾘｱｽ発射又は不要発射の強度（近傍以外）
#


require '../socket.rb'
require '../subghz.rb'

#setup DUT --------------------------------------
CH = 42
RATE = 100
POW = 20
MOD = "0x00"

sbg = Subghz.new()
sbg.setup(CH, RATE, POW)
sbg.rw("8 0x0c ",MOD)
sbg.txon()

#setup TESTER --------------------------------------
CENTER = $frq[RATE][CH] 
LOWER  = CENTER.to_i - 300000
UPPER  = CENTER.to_i + 300000

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

$sock.puts("INIT:CONT OFF")
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SPUR:SEGM:STAT ON,ON,ON,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF")                                  #セグメントのOn/Off を設定
$sock.puts("*OPC?")
$sock.gets

#$sock.puts("SPUR:FREQ:STAR 915MHZ,920.3MHZ,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")      #各セグメントの開始周波数を設定
$sock.puts("SPUR:FREQ:STAR 915MHZ,920.3MHZ," + UPPER.to_s + ",1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")      #各セグメントの開始周波数を設定
$sock.puts("*OPC?")
$sock.gets
	
#$sock.puts("SPUR:FREQ:STOP 919.7MHZ,930MHZ,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")      #各セグメントの終端周波数を設定
$sock.puts("SPUR:FREQ:STOP 919.7MHZ," + LOWER.to_s + ",930MHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")      #各セグメントの終端周波数を設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("DISP:SPUR:VIEW:WIND:TRAC:Y:RLEV 10DBM,10DBM,10DBM,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0")                                               #各セグメントのReference Level を設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SPUR:DET POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS")                                      #各セグメントの波形パターンの検波方式を選択
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SPUR:BAND:AUTO OFF,OFF,OFF,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")                                                  #各セグメントのRBW のAuto/Manual を設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SPUR:BAND 3KHZ,3KHZ,3KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ") #各セグメントの分解能帯域幅（RBW）を設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SPUR:BAND:VID:AUTO OFF,OFF,OFF,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")                                              #各セグメントの分解能帯域幅を自動設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SPUR:BAND:VID 3KHZ,3KHZ,3KHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ")             #各セグメントのビデオ帯域幅を設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SPUR:SWE:TIME 5.46S,5.46S,5.46S,5.46S,5.46S,5.46S,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1")                     #各セグメントのSweep Time を設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SPUR:SWE:TIME:AUTO OFF,OFF,OFF,OFF,OFF,OFF,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")                                          #各セグメントのSweep Time のAuto/Manual を設定
$sock.puts("*OPC?")
$sock.gets

#各セグメントのトレース表示のポイント数を設定
$sock.puts("SPUR:SWE:POIN 1001,1001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001")
$sock.puts("*OPC?")
$sock.gets

#Limitを設定
$sock.puts("CALC:SPUR:LIM:ABS:DATA -36DBM,-36DBM,-36DBM,-10DBM,-13DBM,-13DBM,-10DBM,-10DBM,-13DBM,-13DBM,-13DBM,-13DBM,-13DBM,-13DBM,-10DBM,-10DBM,-13DBM,-13DBM,-13DBM,-13DBM")
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SPUR:TDOM:SPAN:ZERO OFF")       #スプリアス電力をタイムドメイン(Span=0Hz)に設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("CONF:SPUR")                     #Spurious Emission 測定をOn に設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("INIT:SPUR")                     #Spurious 測定を開始
$sock.puts("*OPC?")
$sock.gets

$sock.puts("FETC:SPUR?")                    #Spurious Emission 測定の測定結果を取得
$sock.puts("*OPC?")
result = $sock.gets.split(",")

printf("######################## SUMMARY #####################\n")
printf("Tatol: Tolerance of spurious unwanted emission intensity near\n")
printf("Judged flag : %d\n",result[0].to_i)
if result[0].to_i == 1 then
	printf("!!!FAIL!!!\n")
else
	printf("!!!PASS!!!\n")
end
printf("######################################################\n")

sbg.trxoff()
$sock.close
