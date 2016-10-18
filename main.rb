#! /usr/bin/ruby

Dir.chdir "./io_test"
require "./iotest.rb"
iotest = IoTest.new()
$SERIAL_PORT = iotest.setCom()
p $SERIAL_PORT
iotest = iotest.alltest()


Dir.chdir "../rf_test"
require "./rftest.rb"
rftest = RfTest.new()
rftest.alltest()
