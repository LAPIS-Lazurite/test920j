#!/usr/bin/ruby

require './socket.rb'
require './subghz.rb'

class Telectp::Test
	def _00_MS2830A_init()
		$sock.puts("INST CONFIG")                        #画面に移動 
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("MMEM:STOR:SCR:MODE PNG")
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SYST:BEEP ON")                             #ビープ音をOFFに設定    
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SYST:LANG SCPI")                            #リモートの言語モードをSCPIに設定   
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("INST SPECT")                                #アクティブなアプリケーションをスペアナに設定   
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SYST:PRES")                                 #スペアナを初期化   
		$sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS:STAT ON")        #リファレンスレベルオフセット機能をOn にする    
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS 0")              #リファレンスレベルオフセット値を設定する   
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("DISP:WIND:TRAC:Y:RLEV -10DBM")              #リファレンスレベルを設定する   
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SWE:RUL OSW")                               #測定時の掃引/FFT の切り替えルールを設定    掃引のみ使用します。
		$sock.puts("*OPC?")
		$sock.gets

#		$sock.close
	end
end
