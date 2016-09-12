#!/usr/bin/ruby
#
# 8.副次的に発する電波などの限度
#

require '../socket.rb'
require '../subghz.rb'


#setup DUT --------------------------------------
CH = 42
RATE = 100
POW = 20
MOD = "0x00"

rate50  = {24 => "920600000",33 => "922400000", 36 => "923000000", 60 => "927800000", 43 => "924400000" }
rate100 = {24 => "920700000",33 => "922500000", 36 => "923100000", 60 => "927900000", 42 => "924300000" }
frq = {50 => rate50, 100 => rate100}

sbg = Subghz.new()
sbg.setup(CH, RATE, POW)
sbg.rw("8 0x0c ",MOD)
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
result = $sock.gets.split(",")

printf("######################## SUMMARY #####################\n")
printf("Tatol: Limit of secondary radiated emissionsn\n")
printf("Judged flag : %d\n",result[0].to_i)
if result[0].to_i == 1 then
	printf("!!!FAIL!!!\n")
else
	printf("!!!PASS!!!\n")
end
printf("######################################################\n")


sbg.trxoff()
$sock.close
