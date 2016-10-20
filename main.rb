#! /usr/bin/ruby

Dir.chdir "./io_test"
require "./iotest.rb"
iotest = Iotest.new()
$SERIAL_PORT = iotest.setCom()
p $SERIAL_PORT


while 1
    print("Do you continue test? y or n :")
    rep = gets().to_s
    if rep =~ /n/ then
        exit
    end

    print("Please choose a execute form of Production[0] or Complete[1] :")
    typ = gets().to_i

    iotest = iotest.alltest()
    Dir.chdir "../."
    Dir.chdir "./rf_test"
    require "./rftest.rb"
    rftest = Rftest.new()
    rftest.alltest(typ)
    Dir.chdir "../."
end
