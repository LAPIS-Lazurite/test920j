#! /usr/bin/ruby

require 'serialport'

devName ="LAZURITE mini series"
program = "bin/test.bin"

kern = `uname -r`
@@kernel = "/lib/modules/"+kern.chomp

cmd = "sudo rmmod ftdi_sio"
system(cmd)
p $?.exitstatus

cmd = "sudo rmmod usbserial"
system(cmd)
p $?.exitstatus

cmd = sprintf("sudo lib/cpp/bootmode/bootmode \"%s\"",devName);
system(cmd)
p $?.exitstatus

cmd = "sudo insmod "+@@kernel+"/kernel/drivers/usb/serial/usbserial.ko"
system(cmd)
p $?.exitstatus

cmd = "sudo insmod "+ @@kernel+"/kernel/drivers/usb/serial/ftdi_sio.ko"
system(cmd)
p $?.exitstatus

cmd = "sudo stty -F /dev/ttyUSB0 115200"
system(cmd)
p $?.exitstatus

cmd = sprintf("sudo sx -b %s > /dev/ttyUSB0 < /dev/ttyUSB0",program)
system(cmd)
p $?.exitstatus

cmd = "sudo rmmod ftdi_sio"
system(cmd)
p $?.exitstatus

cmd = "sudo rmmod usbserial"
system(cmd)
p $?.exitstatus

cmd = sprintf("sudo lib/cpp/reset/reset \"%s\"",devName);
system(cmd)
p $?.exitstatus

cmd = "sudo insmod "+@@kernel+"/kernel/drivers/usb/serial/usbserial.ko"
system(cmd)
p $?.exitstatus

cmd = "sudo insmod "+@@kernel+"/kernel/drivers/usb/serial/ftdi_sio.ko"
system(cmd)
p $?.exitstatus
