#! /usr/bin/ruby

Dir.chdir "./io_test"
require "./iotest.rb"
iotest = Iotest.new()
$SERIAL_PORT = iotest.setCom()
p $SERIAL_PORT


while 1
#   print("Please choose the next action Continue(Enter),Exit(x) :")
    print("続ける場合は[Enter]を終了する場合[x]を入力してください：")
    rep = gets().to_s
    if rep =~ /x/ then
        exit
    end

    Dir.chdir "../io_test"
    iotest.alltest(1)

	iotest.shutdown()

end
