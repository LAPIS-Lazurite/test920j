#! /usr/bin/ruby

#Dir.chdir "./io_test"
#require "./iotest.rb"
#iotest = Iotest.new()
#$SERIAL_PORT = iotest.setCom()
#p $SERIAL_PORT
Dir.chdir "./rf_test"
require "./rftest.rb"
rftest = Rftest.new()

#system("sudo modprobe snd-bcm2835")
#system("amixer cset numid=3 1")
#system("amixer cset numid=1 -- 80%")

while 1
    begin
#       Dir.chdir "../io_test"
#       iotest.startup()

        system("pwd")
        print("~~~~~~~~~~~ TOP MENU ~~~~~~~~~~~\n")
        print("[1]  Pre-test\n")
        print("[2]  Post-test\n")
        print("[3]  Verify\n")
        print("[4]  CS 600\n")
        print("[5]  Reliability test\n")
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
        print("[10] Write program\n")
        print("[11] I/O check\n")
        print("[12] Rf command\n")
        print("[13] Telec nemu\n")
        print("[20] Post-test for LazuriteFly\n")
        print("[99] Exit\n")
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
        print("番号を入力してください：")
        input = gets().to_i

        sleep(0.3)

        case input
        when 1
            while 1
                Dir.chdir "../io_test"
                if iotest.writeprog() != nil then
                    raise RuntimeError, "ERRR\n"
                end
                if iotest.alltest() != nil then
                    raise RuntimeError, "ERRR\n"
                end
                Dir.chdir "../rf_test"
                rftest.setlog()
                if rftest.calib() != nil then
                    raise RuntimeError, "ERRR\n"
                end
                if rftest.pretest() != nil then
                    raise RuntimeError, "ERRR\n"
                end
                print("\n続ける場合は[Enter]を終了する場合[x]を入力してください：")
                rep = gets().to_s
                if rep =~ /x/ then
                    break
                end
            end
        when 2
            while 1
                Dir.chdir "../io_test"
                if iotest.alltest() != nil then
                    raise RuntimeError, "ERRR\n"
                end
                Dir.chdir "../rf_test"
                rftest.setlog()
                if rftest.calib() != nil then
                    raise RuntimeError, "ERRR\n"
                end
                if rftest.postest() != nil then
                    raise RuntimeError, "ERRR\n"
                end
                rftest.setbarcode()
                print("\n続ける場合は[Enter]を終了する場合[x]を入力してください：")
                rep = gets().to_s
                if rep =~ /x/ then
                    break
                end
            end
        when 3
            Dir.chdir "../rf_test"
            rftest.setlog()
            if rftest.postest() != nil then
                raise RuntimeError, "ERRR\n"
            end
        when 4
            while 1
                Dir.chdir "../io_test"
                if iotest.writeprog() != nil then
                    raise RuntimeError, "ERRR\n"
                end
                if iotest.alltest() != nil then
                    raise RuntimeError, "ERRR\n"
                end
                Dir.chdir "../rf_test"
                rftest.setlog()
                if rftest.calib() != nil then
                    raise RuntimeError, "ERRR\n"
                end
                if rftest.trialtest() != nil then
                    raise RuntimeError, "ERRR\n"
                end
                rftest.setbarcode()
                print("\n続ける場合は[Enter]を終了する場合[x]を入力してください：")
                rep = gets().to_s
                if rep =~ /x/ then
                    break
                end
            end
        when 5
            while 1
                Dir.chdir "../rf_test"
                rftest.setlog()
                if rftest.trialtest() != nil then
                    raise RuntimeError, "ERRR\n"
                end
                rftest.createLogFile()
                print("\n続ける場合は[Enter]を終了する場合[x]を入力してください：")
                rep = gets().to_s
                if rep =~ /x/ then
                    break
                end
            end
        when 10
            Dir.chdir "../io_test"
            if iotest.writeprog() != nil then
                raise RuntimeError, "ERRR\n"
            end
        when 11
            Dir.chdir "../io_test"
            if iotest.alltest() != nil then
                raise RuntimeError, "ERRR\n"
            end
        when 12
            Dir.chdir "../rf_test"
            rftest.menu()
        when 13
            Dir.chdir "../rf_test"
            rftest.telec()
        when 20 # for LazuriteFly
            Dir.chdir "../io_test"
            if iotest.writeprog() != nil then
                raise RuntimeError, "ERRR\n"
            end
            Dir.chdir "../rf_test"
            rftest.setlog()
            if rftest.calib() != nil then
                raise RuntimeError, "ERRR\n"
            end
            if rftest.postest() != nil then
                raise RuntimeError, "ERRR\n"
            end
            rftest.setbarcode()
        else
            Dir.chdir "../io_test"
            iotest.shutdown()
            break
        end
    rescue RuntimeError
	#system("mpg321 -q ../mp3/se4.mp3")
	system('zenity --info --text="エラーが発生したため試験を中断しました。"')
        next
    end
end
