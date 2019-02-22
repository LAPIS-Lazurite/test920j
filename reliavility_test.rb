#! /usr/bin/ruby

p $SERIAL_PORT
Dir.chdir "./rf_test"
require "./rftest.rb"
rftest = Rftest.new()

#system("sudo modprobe snd-bcm2835")
#system("amixer cset numid=3 1")
#system("amixer cset numid=1 -- 80%")

while 1
    begin
        system("pwd")
        while 1
            rftest.setlog()
            if rftest.trialtest() != nil then
                raise RuntimeError, "ERRR\n"
            end
            rftest.createLogFile()
            print("\n続ける場合は[Enter]を終了する場合[x]を入力してください：")
            rep = gets().to_s
            if rep =~ /x/ then
                exit
            end
        end
    rescue RuntimeError
	    system('zenity --info --text="エラーが発生したため試験を中断しました。"')
        break
    end
end
