
	$sock.puts("outp 1") 				#SG out 1:ON  0:OFF
	$sock.puts("*OPC?")
	$sock.gets

	$sock.puts("freq 923.1mhz")			#周波数設定
	$sock.puts("*OPC?")
	$sock.gets

	$sock.puts("pow -40")				#output level 
	$sock.puts("*OPC?")
	$sock.gets

	$sock.puts("pow: ref?")
	$sock.puts("*OPC?")
	$sock.gets
