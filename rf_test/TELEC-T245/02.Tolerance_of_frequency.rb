#!/usr/bin/ruby

#
# 周波数偏差（CW)
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
    
$sock.puts("syst:lang scpi")
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

$sock.puts("FREQ:CENT " + frq[RATE][CH])                #中心周波数設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("FREQ:SPAN 500KHZ")                          #SPAN設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("BAND 1KHZ")                                 #RBW設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("BAND:VID 1KHZ")                             #VBW設定    SAモードでは使用しない
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SWE:POIN 1001")                             #トレースポイント設定   SAモードでは使用しない
$sock.puts("*OPC?")
$sock.gets

$sock.puts("DET POS")                                   #検波モードを設定   ポジティブピーク
$sock.puts("*OPC?")
$sock.gets

$sock.puts("TRAC1:STOR:MODE MAXH")                      #表示モードをマックスホールド設定   TRAC:STOR:MODE MAXH
$sock.puts("*OPC?")
$sock.gets

$sock.puts("CALC:MARK:FCO ON")                          #周波数カウンタをON     設定SAモードでは下記のコマンドを使用する  CALC:MARK1:STAT"
$sock.puts("*OPC?")
$sock.gets

$sock.puts("TRAC1:STOR:MODE OFF")                       #トレースデータのストレージ方法を設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("AVER:COUN 5")                               #Average回数を設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SWE:TIME:AUTO:MODE FAST")                   #掃引モード設定 SAモードでは使用しない
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SWE:TIME 1s")                               #掃引時間の設定 SAモード時は下記のコマンドを使用する    CALC:ATIM:LENG 2MS"
$sock.puts("*OPC?")
$sock.gets

$sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #Reference Level
$sock.puts("*OPC?")
$sock.gets

$sock.puts("INIT:MODE:SING")                            #シングル掃引を開始する
$sock.puts("*OPC?")
$sock.gets

$sock.puts("CALC:MARK:FCO:X?")                          #周波数カウンタの値を読み取る   SAモードでは下記のコマンドを使用する    CALC:MARK:Y?"
$sock.puts("*OPC")

sbg.trxoff()
$sock.close
