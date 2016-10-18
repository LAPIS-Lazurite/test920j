#!/usr/bin/ruby

#
# 12-1.受信試験（BER測定）
#

require './socket.rb'

class Telectp::Test
	def _12_BER
		print("!!!unsupported test!!!\n")
		exit
		$sock.puts("INST BER")
		$sock.puts("INP:BERT:CLOC:POL NEG")             #Clock Edgeを設定する   この例ではNegativeに設定する
		$sock.puts("INP:BERT:DATA:POL POS")             #Data Polarityを設定する    この例ではPositiveに設定する
		$sock.puts("INP:BERT:CGAT:POL POS")             #Enable Activeを設定する    この例ではPositiveに設定する
		$sock.puts("BERT:STOP:CRIT NONE Single")        #BER測定をビット数モードに設定する
		$sock.puts("INIT:MODE:SING")                    #BER測定をSingle測定に設定する
		$sock.puts("BERT:TBIT 100000")                  #BERの測定ビット数を設定する    この例ではBER測定のビット数を100000ビットに設定する
		$sock.puts("BERT:PRBS PN9")                     #BER測定のデータ種別を設定する  この例ではBER測定のデータ種別をPN9に設定する
		
		$sock.puts("INST SG")                           #アクティブなアプリケーションをSGに設定する
		$sock.puts("INST:DEF")                          #現在選択しているアプリケーションの設定と状態を初期化する   SGを初期化する
		$sock.puts("MMEM:LOAD:WAV 'WiSUN-TxDemo','WiSUN_FET_D100F2_P08'")   #波形パターンをロードする   この例ではPackage名がWiSUN-TxDemo、パターン名がWiSUN_FET_D100F2_P08の波形をロードする
		$sock.puts("*OPC?")
		$sock.gets
		
		$sock.puts("RAD:ARB:WAV 'WiSUN-TxDemo','WiSUN_FET_D100F2_P08'")     #波形パターンを選択する この例ではPackage名がWiSUN-TxDemo、パターン名がWiSUN_FET_D100F2_P08の波形を選択する
		
		$sock.puts("INST SG")                           #２回目以降の測定ではこの行より下のコマンドを実行する。
		$sock.puts("FREQ 920MHZ")                       #周波数を920MHzに設定する   この例では周波数を920MHzに設定する。
		$sock.puts("POW -30.00")                        #出力レベルを設定する   この例では出力レベルを-30dBmに設定する。
		$sock.puts("OUTP:MOD ON")                       #ModをOnに設定する
		$sock.puts("OUTP ON")                           #RF OutputをOnに設定する
		$sock.puts("POW -50.00")                        #出力レベルを設定する   まずは確実に接続状態になるレベルを出力し、接続状態になったら試験するレベルに変更する。
		$sock.puts("BERT:RSYN OFF")                     #自動再同期の状態をOFFに設定

		$sock.puts("INST BER")                          #アクティブなアプリケーションをBERTSに設定する
		$sock.puts("INIT:MODE:SING")                    #シングルモードでBER測定を開始する
		$sock.puts("STAT:BERT:MEAS?")                   #現在の動作状態を読み出す   戻り値が1（測定中）でなくなるまでこのコマンドを繰り返し送る。
		$sock.puts("CALC:BERT:BER? ER")                 #BERの測定結果を取得する

#		$sock.close
	end
end 
