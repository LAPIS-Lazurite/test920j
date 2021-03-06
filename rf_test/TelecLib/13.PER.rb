#!/usr/bin/ruby

#
# 12-2.受信試験（PER測定）
#

require './socket.rb'

class Telectp::Test
	def _13_PER
		print("!!!unsupported test!!!\n")
		exit

# TESTER SPA section ------------------
		$sock.puts("inst spect")
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SYST:PRES")                                 #スペアナを初期化   
		$sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS:STAT ON")        #リファレンスレベルオフセット機能をOn にする    
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("cnf 924.3MHZ")
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("zerospan")
		$sock.puts("*OPC?")
		$sock.gets

# TESTER SG section ------------------
		$sock.puts("INST SG")                       #アクティブなアプリケーションをSGに設定する
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("INST:DEF")                      #現在選択しているアプリケーションの設定と状態を初期化する   SGを初期化する
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("syst:lang scpi")
		$sock.puts("*OPC?")
		$sock.gets

#波形パターンをロードする    この例ではPackage名がWiSUN-TxDemo、パターン名がWiSUN_FET_D100F2_P08の波形をロードする
#   $sock.puts("MMEM:LOAD:WAV 'WiSUN-TxDemo','WiSUN_FET_D100F2_P08'")
		$sock.puts("MMEM:LOAD:WAV 'TDMA_IQproducer','initial_Burst'")
		$sock.puts("*OPC?")
		$sock.gets

#波形パターンを選択する  この例ではPackage名がWiSUN-TxDemo、パターン名がWiSUN_FET_D100F2_P08の波形を選択する
#   $sock.puts("RAD:ARB:WAV 'WiSUN-TxDemo','WiSUN_FET_D100F2_P08'")
		$sock.puts("RAD:ARB:WAV 'TDMA_IQproducer','initial_Burst'")
		$sock.puts("*OPC?") 
		$sock.gets

		$sock.puts("FREQ 924.3MHZ")                 #周波数を920MHzに設定する   この例では周波数を920MHzに設定する。
		$sock.puts("*OPC?") 
		$sock.gets

		$sock.puts("RAD:ARB:TRIG ON")               #SGのトリガ入力を設定する   トリガ入力をONに設定する。
		$sock.puts("*OPC?")  
		$sock.puts("RAD:ARB:TRIG:TYPE FRAM")        #外部トリガの動作モードを設定する   パケット数を指定するために、Frameに設定する。
		$sock.puts("*OPC?")  
		$sock.puts("RAD:ARB:TRIG:SOUR BUS")         #外部トリガのソースを設定する   外部PCによるトリガ入力を行うため、BUSに設定する。
		$sock.puts("*OPC?")  
		$sock.puts("RAD:ARB:TRIG:FRAM:COUN 1000")   #出力フレーム数を設定する   この例では出力するパケット数は1000に設定する。
		$sock.puts("*OPC?")  
		$sock.puts("OUTP ON")                       #RF OutputをOnに設定する
		$sock.puts("*OPC?")  
		$sock.gets

		$sock.puts("POW -20.00")                    #出力レベルを設定するレベルを-50.00dBmに設定する。
		$sock.puts("*OPC?") 
		$sock.gets

		$sock.puts("OUTP:MOD ON")                   #ModをOnに設定する

		$sock.puts("RAD:ARB:TRIG:GEN")              #波形パターンの出力を開始する。 指定したパケット数の信号出力を開始する。

#		$sock.close
	end
end
