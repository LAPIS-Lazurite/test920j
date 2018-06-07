#! /usr/bin/ruby

Dir.chdir "./io_test"
require "./iotest.rb"
iotest = Iotest.new()
$SERIAL_PORT = iotest.setCom()
p $SERIAL_PORT
Dir.chdir "../rf_test"
#require "./rftest_no_telec.rb"
require "./rftest.rb"
rftest = Rftest.new()


while 1
#   print("Please choose the next action Continue(Enter),Exit(x) :")
    print("続ける場合は[Enter]を終了する場合[x]を入力してください：")
    rep = gets().to_s
    if rep =~ /x/ then
        exit
    end

    Dir.chdir "../io_test"
    iotest.alltest(0)

    Dir.chdir "../rf_test"
    rftest.menu()

#   Dir.chdir "../io_test"
#	iotest.shutdown()
end
