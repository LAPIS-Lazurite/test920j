#!/usr/bin/ruby

#
# 11.変調精度
#

require './socket.rb'
require './subghz.rb'

class Telectp::Test
	def _11_modulation_accuracy
		print("!!!unsupported test!!!\n")
		exit

		sbg = Subghz.new()
		sbg.setup(42, 100, 1)
		sbg.mod(1)
		sbg.txon()

		$sock.puts("INST VMA")  
		$sock.puts("*OPC?")
		$sock.gets
		
		$sock.puts("SYST:PRES")   
		$sock.puts("*OPC?")  
		$sock.gets
		
#$sock.puts("syst:lang scpi")
#$sock.puts("*OPC?")
#$sock.gets
		
		$sock.puts("FREQ:CENT 924.3MHZ")                          #中心周波数設定 この例では中心周波数を920MHzに設定
		$sock.puts("*OPC?")    
		$sock.gets
		
		$sock.puts("POW:RANG:ILEV -10DBM")                      #入力レベル設定 この例では入力レベルを-10dBmに設定
		$sock.puts("*OPC?") 
		$sock.gets
		
		$sock.puts("MMEM:LOAD:COMM 'D:\Anritsu Corporation\Signal Analyzer\User Data\Parameter Setting\VMA\Dialog Param\T96.xml'")    #Common Settingに指定したパラメータファイルをロード
		$sock.puts("*OPC?")    
		$sock.gets
		
		$sock.puts("EVM:AVER ON")                               #アベレージ設定
		$sock.puts("*OPC?") 
		$sock.gets
		
		$sock.puts("EVM:AVER:COUNT 10")                         #アベレージ回数の設定   この例ではアベレージ回数を１０回に設定
		$sock.puts("*OPC?")    
		$sock.gets
		
		$sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS:STAT ON")        #入力レベルのオフセット値を有効にする
		$sock.puts("*OPC?") 
		$sock.gets
		
		$sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS 0")              #オフセットレベル値設定     この例ではオフセットレベル値を0dBに設定する
		$sock.puts("*OPC?")    
		$sock.gets
		
		$sock.puts("DISP:TRAC:ZOOM")                            #トレース表示を１画面に設定
		$sock.puts("*OPC?")   
		$sock.gets
		
		$sock.puts("INIT:MODE:SING")                            #1回の測定を実行
		$sock.puts("*OPC?")  
		$sock.gets
		
		$sock.puts("FETC:EVM?")                                 #EVMの測定値の問い合わせ
		$sock.puts("*OPC")  
		$sock.gets
		
#		$sock.close
	end
end
