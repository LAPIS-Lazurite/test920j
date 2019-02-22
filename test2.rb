#!/usr/bin/ruby
require "timeout"
require "socket"
require "json"
require "serialport"
require "date"
require "net/http"
require "uri"
require 'LazGem'


require 'logger'
require './rf_test/subghz.rb'
require './rf_test/Rftp.rb'
require './rf_test/Telectp.rb'
@rftp = Rftp::Test.new
@sbg = Subghz::new
@laz = LazGem::Device.new
@telectp = Telectp::Test.new

@ATT = "9.9"

finish_flag=0
Signal.trap(:INT){
	finish_flag=1
}
#
####### PARAMETERS ########
$V3_PWR_ON_VIN	= 3.0
$V3_PWR_ON_MIN	= 2.5
$V3_PWR_ON_MAX	= 3.005
$I_PWR_ON_MIN = 0.0
$I_PWR_ON_MAX = 0.1
$GLED=26
$RLED=19
$TRG_BUTTON=6

####### SUB FUNC ########
def diffDateTime(b,a)
	(b - a)                       # => (1/17500)
	(b - a).class                 # => Rational
	(b - a) * 24 * 60 * 60        # => (5/1)
	return ((b - a) * 24 * 60 * 60).to_i # => 5
end

def aribTest
    p "ARIB T108 TEST"
    p @sbg.trxoff
    p @sbg.setup(36,100,20)
    p @sbg.rr("8 0x6c")
    p @sbg.rw("8 0x71 ","0x02")
    p @sbg.rr("8 0x71")
#=begin
    @rftp.e2p_base()
    val = @rftp.calibration(@ATT)
    if val != nil then
        return val
    end
    @telectp._00_MS2830A_init()
    val = @telectp._01_Tolerance_of_occupied_bandwidth_Frequency_range()
    if val != nil then
        return val
    end
    val = @telectp._02_Tolerance_of_frequency()
    if val != nil then
        return val
    end
    val = @telectp._03_Antenna_power_point(@ATT)
    if val != nil then
        return val
    end
    val = @telectp._04_Antenna_power_ave(@ATT)
    if val != nil then
        return val
    end
    #    @telectp._05_Tolerance_of_spurious_unwanted_emission_intensity_far()
    val = @telectp._06_Tolerance_of_spurious_unwanted_emission_intensity_near()
    if val != nil then
        return val
    end
    val = @telectp._07_Tolerance_off_adjacent_channel_leakage_power()
    if val != nil then
        return val
    end
    #     @telectp._08_Limit_of_secondary_radiated_emissions()
    val = @telectp._09_Career_sense(@ATT)
    if val != nil then
        return val
    end
    val = @telectp._10_Spectrum_emission_mask()
    if val != nil then
        return val
    end
#=end
    p @sbg.rw("8 0x71 ","0x06")
    p @sbg.rr("8 0x71")
end

def sbgSend
    $sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # device, rate, data, stop, parity
    sleep 0.1
    $sp.puts("sgi")
    p $sp.gets()
    sleep 0.05
    $sp.puts("sgb 36 0xabcd 100 20")
    p $sp.gets()
    sleep 0.05
#   $sp.puts("rfw 8 0x6c 0x09")
#   p $sp.gets()
#   sleep 0.05
    $sp.puts("rfr 8 0x6c")
    p $sp.gets()
    $sp.puts("w LAPIS MJ2001 test")
    p $sp.gets()
    $sp.puts("sgs 0xabcd 0xac48")
    p $sp.gets()
    $sp.close
end

def anntenaTest
    @laz.init()

    dst_short_addr = 0xffff
    ch = 36
    panid = 0xabcd
    baud = 100
    pwr = 20

    begin
    @laz.begin(ch,panid,baud,pwr)
    rescue Exception => e
        p "file io error!! reset driver"
        @laz.remove()
        @laz.init()
        `gpio -g write #{$RLED} 1`
    end
    begin
        p "Anntena TEST"
        # RX setting
#       @laz.send(panid,dst_short_addr,"LAPIS Lazurite RF system")
        @laz.rxEnable()
        sleep 0.01
        # TX setting
        sbgSend()
        # Receive
        @laz.available() 
        rcv = @laz.read()
        if rcv == 0 then
            $log.info("error: Anntena test: no receiving")
            return "Error"
        else
            $log.info("+++++++++++ SUMMARY ++++++++++")
            $log.info("Subject: Anntena test")
            $log.info("Judgement: PASS")
            p rcv
        end
    rescue Exception => e
        p e
        sleep 1
    end
#   @laz.close()
    @laz.remove()
    sleep 1.000
    return nil
end

####### INITIALIZE ########
begin
	timeout(5) do
 		$pmx18a=TCPSocket.open("10.9.20.6",5025) #141
#		$pmx18a=TCPSocket.open("10.9.20.2",5025) #148
		$pmx18a.puts("*IDN?")
 		if $pmx18a.gets().chop != "KIKUSUI,PMX18-2A,YK000141,IFC01.52.0011 IOC01.10.0070" then #10.9.20.6
#       if $pmx18a.gets().chop != "KIKUSUI,PMX18-2A,YK000148,IFC01.52.0011 IOC01.10.0070" then #10.9.20.2
            $log.info("error: PMX18-2A not found")
            `gpio -g write #{$RLED} 1`
        end
		$pmx18a.puts("CURR:PROT 0.2")
		$pmx18a.puts("CURR:PROT?")
		if $pmx18a.gets().to_f != 0.2 then
            $log.info("error: Current protection error")
            `gpio -g write #{$RLED} 1`
		end
		$pmx18a.puts("VOLT 2.0")
		$pmx18a.puts("VOLT?")
		if $pmx18a.gets().to_f != 2 then
            $log.info("error: output voltage set error")
		end
=begin
		$ms2830a=TCPSocket.open("10.9.20.6",5025)
		$pmx18a.puts("*IDN?")
		if $ms2830a.gets().chop != "MS2830A" then
            $log.info("error: MS2830A not found")
            `gpio -g write #{$RLED} 1`
        end
=end
	end
rescue StandardError
   `gpio -g write #{$RLED} 1`
end

####### MAIN LOOP ########
loop do
  begin 
     `gpio -g mode #{$TRG_BUTTON} in`
     `gpio -g mode #{$GLED} out`
     `gpio -g mode #{$RLED} out`

     `gpio -g write #{$GLED} 1`

      print("試験機を開けてデバイスをセットしてください\n")
      
      loop do
        button_state = `gpio -g read #{$TRG_BUTTON}`.chop.to_i
        if button_state == 1 then
          break
        end
        sleep(0.01)

        if finish_flag == 1 then
            exit
        end
      end

     `gpio -g write #{$GLED} 0`
     `gpio -g write #{$RLED} 0`

      #POWER OUTPUT
      $pmx18a.puts("VOLT #{$V3_PWR_ON_VIN}")
      $pmx18a.puts("OUTP ON")
      sleep 1
      $pmx18a.puts("MEASure:CURRent?")
      val = $pmx18a.gets().to_f
      p val
      if val > $I_PWR_ON_MAX then
          p "error: Current error"
          raise RuntimeError, "ERRR\n"
      end  

      #CREATE LOG FILE
      t = Time.now
      date = sprintf("%04d%02d%02d%02d%02d_",t.year,t.mon,t.mday,t.hour,t.min)
      logfilename = @rftp.get_shortAddr()
      logfilename = "/home/pi/test920j/Log/" + date + logfilename + ".log"
      if File.exist?(logfilename) == true then
        p "duplicate log file name"
      end
      $log = Logger.new(logfilename)
    # $log = Logger.new("| tee temp.log")

      val = aribTest()
      if val == "Error" then
          p "error: arib test error"
          raise RuntimeError, "ERRR\n"
      end  
      val = anntenaTest()
      if val == "Error" then
          p "error: arib test error"
          raise RuntimeError, "ERRR\n"
      end  

      $pmx18a.puts("OUTP OFF")

      p logfilename
      system("sshpass -p pwsjuser01 scp " + logfilename + " sjuser01@10.9.20.1:~/test920j/Log/.")
      File.delete(logfilename)

      rescue RuntimeError
           $pmx18a.puts("OUTP OFF")
          `gpio -g write #{$RLED} 1`
          next
      next
  end
end
