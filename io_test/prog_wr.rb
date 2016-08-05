#! /usr/bin/ruby

require 'serialport'

devName ="LAZURITE Sub-GHz Rev2"
program = "bin/blue_led.bin"

cmd = "sudo rmmod ftdi_sio"
system(cmd)
p $?.exitstatus

cmd = "sudo rmmod usbserial"
system(cmd)
p $?.exitstatus

cmd = sprintf("sudo lib/cpp/bootmode/bootmode \"%s\"",devName);
system(cmd)
p $?.exitstatus

cmd = "sudo insmod /lib/modules/4.4.8-v7+/kernel/drivers/usb/serial/usbserial.ko"
system(cmd)
p $?.exitstatus

cmd = "sudo insmod /lib/modules/4.4.8-v7+/kernel/drivers/usb/serial/ftdi_sio.ko"
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

cmd = "sudo insmod /lib/modules/4.4.8-v7+/kernel/drivers/usb/serial/usbserial.ko"
system(cmd)
p $?.exitstatus

cmd = "sudo insmod /lib/modules/4.4.8-v7+/kernel/drivers/usb/serial/ftdi_sio.ko"
system(cmd)
p $?.exitstatus
