#!/usr/bin/ruby

#
# ｽﾍﾟｸﾄﾗﾑｴﾐｯｼｮﾝﾏｽｸ
#

require '../socket.rb'
require '../subghz.rb'

#setup DUT --------------------------------------
CH = 42
RATE = 100
POW = 1
MOD = "0x03"

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

$sock.puts("INIT:CONT OFF")                             #連続掃引をOFF設定
$sock.puts("*OPC?") 
$sock.gets

$sock.puts("FREQ:CENT " + frq[RATE][CH])                #中心周波数を設定
$sock.puts("*OPC?")  
$sock.gets

$sock.puts("SEM:BAND:CHAN 200KHZ")                      #Channel BWをチャネル帯域幅×キャリア数に設定   チャネル帯域幅は試験周波数から判定する
$sock.puts("*OPC?")    
$sock.gets

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
result = $sock.gets.split(",")

printf("######################## SUMMARY #####################\n")
printf("Tatol: Spectrum emission mask\n")
printf("Judged flag : %d\n",result[0].to_i)
if result[0].to_i == 1 then
	printf("!!!FAIL!!!\n")
else
	printf("!!!PASS!!!\n")
end
printf("######################################################\n")

sleep 5
sbg.trxoff()
$sock.close
