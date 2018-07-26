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
    Dir.chdir "../io_test"
    iotest.startup()

    system("pwd")
    print("~~~~~~~~~~~ TOP MENU ~~~~~~~~~~~\n")
    print("[1]  Pre-test\n")
    print("[2]  Post-test\n")
    print("[3]  Verify\n")
    print("[4]  Write program\n")
    print("[5]  Rf command\n")
    print("[6]  Telec nemu\n")
    print("[10] Post-test for LazuriteFly\n")
    print("[99] Exit\n")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
    print("番号を入力してください：")
    input = gets().to_i

    sleep(0.3)

    case input
    when 1
        while 1
            Dir.chdir "../io_test"
            iotest.writeprog()
            iotest.alltest()
            Dir.chdir "../rf_test"
            rftest.calib()
            rftest.pretest()
            print("\n続ける場合は[Enter]を終了する場合[x]を入力してください：")
            rep = gets().to_s
            if rep =~ /x/ then
                break
            end
        end
    when 2
        while 1
            Dir.chdir "../io_test"
            iotest.alltest()
            Dir.chdir "../rf_test"
            rftest.calib()
            rftest.postest()
            rftest.setbarcode()
            print("\n続ける場合は[Enter]を終了する場合[x]を入力してください：")
            rep = gets().to_s
            if rep =~ /x/ then
                break
            end
        end
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
        Dir.chdir "../io_test"
        iotest.shutdown()
        break
    end
    
end
