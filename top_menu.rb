#! /usr/bin/ruby

Dir.chdir "./io_test"
require "./iotest.rb"
iotest = Iotest.new()
$SERIAL_PORT = iotest.setCom()
p $SERIAL_PORT
Dir.chdir "../rf_test"
require "./rftest.rb"
rftest = Rftest.new()

#system("sudo modprobe snd-bcm2835")
#system("amixer cset numid=3 1")
#system("amixer cset numid=1 -- 80%")

while 1
    system("pwd")
    print("+++++++++++ Top Menu ++++++++++\n")
    print("1: pre_test\n")
    print("2: post_test\n")
    print("3: verify\n")
    print("4: write program\n")
    print("5: rf command\n")
    print("6: telec nemu\n")
    print("10: post_test for LazuriteFly\n")
    print("99: Exit\n")
    print("+++++++++++++++++++++++++++++++\n")
#   print("Please choose the next action Continue(Enter),Exit(x) :")
#   print("続ける場合は[Enter]を終了する場合[x]を入力してください：")
    print("番号を入力してください：")
    input = gets().to_i

    sleep(0.3)

    case input
    when 1
        Dir.chdir "../io_test"
        iotest.writeprog()
        iotest.alltest()
        Dir.chdir "../rf_test"
        rftest.calib()
        rftest.pretest()
    when 2
        Dir.chdir "../io_test"
        iotest.alltest()
        Dir.chdir "../rf_test"
        rftest.calib()
        rftest.postest()
        rftest.barcode()
    when 3
        Dir.chdir "../io_test"
        iotest.alltest()
        Dir.chdir "../rf_test"
        rftest.postest()
    when 4
        Dir.chdir "../io_test"
        iotest.writeprog()
    when 5
        Dir.chdir "../rf_test"
        rftest.menu()
    when 6
        Dir.chdir "../rf_test"
        rftest.telec()
    when 10 # for LazuriteFly
        Dir.chdir "../io_test"
        iotest.writeprog()
        Dir.chdir "../rf_test"
        rftest.calib()
        rftest.postest()
        rftest.barcode()
    else
        break
    end
    
    Dir.chdir "../io_test"
	iotest.shutdown()
end
