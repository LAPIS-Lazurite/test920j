#! /usr/bin/ruby

require 'socket'
require 'serialport'


  # Process at the time of SIGINT Receiving
  Signal.trap(:INT){
    finish_flag=1
  }

$sock=TCPSocket.open("192.168.11.6",49153)
$sock.puts("*IDN?")
p $sock.gets
$sock.puts("syst:lang nat")


serial_port ='/dev/ttyUSB0'
serial_baudrate=115200
$sp = SerialPort.new(serial_port,serial_baudrate)
$sp.read_timeout=500
$sp.puts("sggma")
p $sp.gets()

