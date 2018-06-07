#! /usr/bin/ruby

Dir.chdir "./io_test"
require "./iotest.rb"
iotest = Iotest.new()
$SERIAL_PORT = iotest.setCom()
p $SERIAL_PORT
Dir.chdir "../rf_test"
require "./rftest.rb"
rftest = Rftest.new()

if ARGV[0] == nil then
    io_mode = 1
else
    io_mode = ARGV[0]
end

while 1
#   print("Please choose the next action Continue(Enter),Exit(x) :")
    print("続ける場合は[Enter]を終了する場合[x]を入力してください：")
    rep = gets().to_s
    if rep =~ /x/ then
        exit
    end
    sleep(0.3)

    Dir.chdir "../io_test"
#   iotest.alltest(1)
    iotest.alltest(io_mode)

    Dir.chdir "../rf_test"
	rftest.pretest()

    Dir.chdir "../io_test"
	iotest.shutdown()
end
