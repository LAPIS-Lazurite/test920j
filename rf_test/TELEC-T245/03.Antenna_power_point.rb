#!/usr/bin/ruby

#
# 空中線電力（尖頭電力）
#


require '../socket.rb'
require '../subghz.rb'

#setup DUT --------------------------------------
CH = 42
RATE = 100
POW = 20
MOD = "0x03"

sbg = Subghz.new()
sbg.setup(CH, RATE, POW)
sbg.rw("8 0x0c ",MOD)
sbg.txon()

#setup TESTER --------------------------------------
ATT = ARGV[0].to_f.round(2)
MAKER = "DELTA" # NORM(mW) or DELTA(dBm) When using ATT, set DELTA
normal = {"lower" => 18, "upper" => 20, "unit" => "mW"}
delta  = {"lower" => 11, "upper" => 13, "unit" => "dBm"}
range  = {"NORM" => normal, "DELTA" => delta}

$sock.puts("INST SPECT")                                #SAモードでは下記のコマンドを使用  INST SIGANA"
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

$sock.puts("INIT:CONT ON")                              #連続掃引設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("FREQ:CENT " + $frq[RATE][CH])                #中心周波数設定  この例では中心周波数を920MHzに設定
$sock.puts("*OPC?")
$sock.gets

#$sock.puts("FREQ:SPAN 10MHZ")                          #SPAN設定  この例ではSpan=500kHzに設定
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

#$sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #リファレンスレベル設定(dBm)  この例ではリファレンスレベルを-10dBmに設定
$sock.puts("DISP:WIND:TRAC:Y:RLEV 10")                 #リファレンスレベル設定(dBm)  この例ではリファレンスレベルを-10dBmに設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts(":UNIT:POWer W")                             #表示をWに変換
$sock.puts("*OPC?")
$sock.gets

$sock.puts(":CALC:MARK:MODE " + MAKER)                      #マーカをNORMAL or DELTAに設定する。
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

if MAKER == "NORM" then
	$sock.puts(":CALCulate:MARKer:Y?")                      #マーカ点のレベルを読み出します。
	$sock.puts("*OPC?")
	result = $sock.gets.to_f * 1000
else
	$sock.puts(":CALCulate:MARKer:Y:DELT?")                 #マーカ点の相対値を読み出します。
	$sock.puts("*OPC?")
	result = $sock.gets.to_f + ATT
end
p result

sbg.trxoff()
$sock.close

printf("+++++++++++ SUMMARY ++++++++++\n")
printf("Subject: Antenna power pointn\n")
printf("Makeer mode: %s\n",MAKER)
printf("Attenuate: %d dB\n",ATT)
printf("Result: %3.2f%s\n",result,range[MAKER]["unit"])
if result.between?(range[MAKER]["lower"].to_i,range[MAKER]["upper"].to_i) == false then
	printf("Judgement: %s\n", "FAIL")
	raise StandardError, "FAIL\n"
else
	printf("Judgement: %s\n", "PASS")
end
