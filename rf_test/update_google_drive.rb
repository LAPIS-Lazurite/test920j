#! /usr/bin/ruby

require './RfCom.rb'
#require './Rftp.rb'
#require './Telectp.rb'
require 'logger'
require 'fileutils'
#require 'easy-google-drive'
require_relative '../../easy-google-drive/lib/easy-google-drive'

@@rftp = Rftp::Test.new
#@@telectp = Telectp::Test.new
myDrive = EasyGoogleDrive::Drive.new


if File.exist?("temp.log") == true then
    File.delete("temp.log")
end
$log = Logger.new("| tee temp.log")


t = Time.now
date    = sprintf("%04d%02d%02d%02d%02d_",t.year,t.mon,t.mday,t.hour,t.min)
address = @@rftp.set_addr()
#sleep(2)
#address = "ABCDEF"
logfilename = date + address + ".log"
File.rename('temp.log',"/home/pi/test920j/Log/" + logfilename)
gFolder = sprintf("%04d%02d%02d_LOG",t.year,t.mon,t.mday)
printf("Folder name :   %s\n",gFolder)
printf("Log file name : %s\n",logfilename)


system("sudo if down eth0")
# ------------ Search folder
myDrive.cd("Lazurite920j_log")
list = myDrive.ls()
detect = 0
if list != nil
    list.each do |file|
        if file.name.to_s.match(gFolder) != nil then
            detect = 1
            break
        end
    end
end

if detect == 0 then
    myDrive.mkdir(gFolder)
end


# ------------ Search logfile
myDrive.cd(gFolder)
list = myDrive.ls()

if list != nil
    list.each do |file|
        if file.name.to_s.match(logfilename) != nil then
            @@myDrive.rm(logfilename)
            break
        end
    end
end

myDrive.send("/home/pi/test920j/Log/" + logfilename,logfilename)
system("sudo if up eth0")
