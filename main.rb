#! /usr/bin/ruby

Dir.chdir "./io_test"
require "./iotest.rb"
iotest = Iotest.new()
$SERIAL_PORT = iotest.setCom()
p $SERIAL_PORT


while 1
    print("Please choose the next action Continue(0),Exit(1) :")
    rep = gets().to_i
    if rep == 1 then
        exit
    end

    print("Please choose the verification level of number 0(Light), 1(Middle), 2(Heavy) :")
    level = gets().to_i

    iotest = iotest.alltest()
    Dir.chdir "../."
    Dir.chdir "./rf_test"
    require "./rftest.rb"
    rftest = Rftest.new()
    rftest.alltest(level)
    Dir.chdir "../."
end
