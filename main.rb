#! /usr/bin/ruby

Dir.chdir "./io_test"
require "./iotest.rb"
iotest = Iotest.new()
$SERIAL_PORT = iotest.setCom()
p $SERIAL_PORT
Dir.chdir "../rf_test"
require "./rftest.rb"
rftest = Rftest.new()


while 1
    print("Please choose the next action Continue(Enter),Exit(x) :")
    rep = gets().to_s
    if rep =~ /x/ then
        exit
    end

    print("Please choose the verification level of number 0(Menu), 1(Default:1minute), 2(Half:3.5minute), 3(All:over 5 minute) :")
    level = gets().to_i

    Dir.chdir "../io_test"
    iotest.alltest(level)

    Dir.chdir "../rf_test"
	case level
	when 0
    	rftest.menu()
	else
		rftest.alltest(level)
	end
end
