#! /usr/bin/ruby

require './Rftp_serial.rb'
#require './Rftp.rb'
#require './Telectp.rb'
require 'logger'
require 'fileutils'
require 'easy-google-drive'
#require_relative '../../easy-google-drive/lib/easy-google-drive'

@@rftp = Rftp::Test.new
#@@telectp = Telectp::Test.new
myDrive = EasyGoogleDrive::Drive.new


if File.exist?("temp.log") == true then
    File.delete("temp.log")
end
$log = Logger.new("| tee temp.log")


t = Time.now
date = sprintf("%04d%02d%02d%02d%02d_",t.year,t.mon,t.mday,t.hour,t.min)
logfilename = @@rftp.set_addr()
logfilename = "Log/" + date + logfilename + ".log"
File.rename('temp.log',logfilename)

gFolder = sprintf("%04d%02d%02d_LOG",t.year,t.mon,t.mday)

myDrive.cd("Lazurite920j_log")
list = myDrive.ls()
list.each {|file|
    p file.name
    if file.name.to_s.match(gFolder) != nil then
        break
    end
}

if list.to_s.match(gFolder) == nil then
    myDrive.mkdir(gFolder)
else
   printf("%s is alread.",gFolder)
end


#@@myDrive.cd("~")
#@@myDrive.cd("test")
#@@myDrive.rm("test/test.log")
#@@myDrive.send("Log/test.log","test/test.log")
#@@myDrive.get("~/gdrive.dat","./gdrive.dat")
