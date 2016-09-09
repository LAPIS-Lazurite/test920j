#! /usr/bin/ruby
# encoding: utf-8
require 'serialport'


sp=SerialPort.new("/dev/ttyUSB0",115200)
sp.read_timeout=1000 #受信時のタイムアウト（ミリ秒単位）
dummy = sp.gets()
p dummy
dummy = sp.gets()
p dummy
for i in 2..8
	print(sprintf("port num = %d\n",i))
	cmd = sprintf("pm,%d,o",i)
	p cmd
	sp.puts(cmd)
	dummy = sp.gets()
	for j in 0..1000
		cmd = sprintf("dw,%d,0",i)
		p cmd
		sp.puts(cmd)
		dummy = sp.gets()
		p dummy
		cmd = sprintf("dw,%d,1",i)
		p cmd
		sp.puts(cmd)
		dummy = sp.gets()
		p dummy
		sleep(0.01)
	end
end
for i in 2..8
	cmd = sprintf("pm,%d,o",i)
	p cmd
	sp.puts(cmd)
	dummy = sp.gets()
	p dummy
	if(enable)
		cmd = sprintf("dw,%d,0",i)
	else
		cmd = sprintf("dw,%d,1",i)
	end
	p cmd
	sp.puts(cmd)
	dummy = sp.gets()
	p dummy
	cmd = sprintf("dr,%d",i)
	p cmd
	sp.puts(cmd)
	dummy = sp.gets()
	p dummy
end
sp.close()
sleep(1)
return "OK"
