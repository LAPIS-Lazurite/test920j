#! /usr/bin/ruby

print("Please choose a execute form of Production[0] or Complete[1]  => ")
typ = gets().to_i


Dir.chdir "./io_test"
require "./iotest.rb"
iotest = Iotest.new()
$SERIAL_PORT = iotest.setCom()
p $SERIAL_PORT
iotest = iotest.alltest()
Dir.chdir "../."


Dir.chdir "./rf_test"
require "./rftest.rb"
rftest = Rftest.new()
rftest.alltest(typ)
Dir.chdir "../."
