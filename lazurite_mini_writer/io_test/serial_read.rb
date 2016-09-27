#! /usr/bin/ruby
#
# Halt process when CTRL+C is pushed.

require 'serialport'
require './lib/Lazurite'

@finish_flag=0
Signal.trap(:INT){
	@finish_flag=1
}

test = Lazurite::Test.new
result = test.set_bootmode("LAZURITE mini series")
sleep(0.1)
#シリアルポート通信設定
serial_port = "/dev/ttyUSB0"
serial_baudrate = 115200

##シリアルポートを開く
sp = SerialPort.new(serial_port, serial_baudrate)
sp.read_timeout=100 #受信時のタイムアウト（ミリ秒単位）

#送信（例えばこんな感じ）
#sp.puts "ARM:COUNt 1#{$serial_delimiter}"
#sp.write "INIT#{$serial_delimiter}"

#受信（例えばこんな感じ）
#デリミターを引数として渡しておくとgetsはデリミターが受信されるまで
#あるいは設定されたタイムアウトになるまで待ちます

while @finish_flag ==0 do
	line = sp.gets()
	p line
end
sp.close

#シリアルポートを閉じる
result = test.set_reset("LAZURITE Sub-GHz Rev2")

