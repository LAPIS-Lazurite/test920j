#!/usr/bin/ruby
require "timeout"
require "socket"
require "json"
require "serialport"
require "date"
require "net/http"
require "uri"
require 'LazGem'

# checkDb
require 'net/http'
require 'uri'
require 'json'

require 'logger'
require './rf_test/subghz.rb'
require './rf_test/Rftp.rb'
require './rf_test/Telectp.rb'


@rftp = Rftp::Test.new
@sbg = Subghz::new
@laz = LazGem::Device.new
@telectp = Telectp::Test.new

@ATT = "6.9"

finish_flag=0
Signal.trap(:INT){
	finish_flag=1
}

@TEST_MODE = 3 # 1: Local test, 2: RSSI only, 3: calibration + RSSI

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
$ANT_SW_OUT=1

####### SUB FUNC ########
def checkDb(mac)
	payload = {}
	payload[:mac] = mac;
	$req.body = payload.to_json
	$res = $http.request($req)
	body = JSON.parse($res.body);
	return body["result"]
end

def diffDateTime(b,a)
	(b - a)												# => (1/17500)
	(b - a).class									# => Rational
	(b - a) * 24 * 60 * 60				# => (5/1)
	return ((b - a) * 24 * 60 * 60).to_i # => 5
end

def aribTest
		p "ARIB T108 TEST"
		@rftp.e2p_base_MJ2001()
		p @sbg.trxoff
#		p @sbg.setup(36,100,20)
#		p @sbg.rr("8 0x6c")
#		p @sbg.rw("8 0x71 ","0x02")
#		p @sbg.rr("8 0x71")
		val = @rftp.calibration(@ATT)
		if val != nil then
				return val
		end
		@telectp._00_MS2830A_init()
		val = @telectp._01_Tolerance_of_occupied_bandwidth_Frequency_range()
		if val != nil then
				return val
		end
#		val = @telectp._02_Tolerance_of_frequency()
#		if val != nil then
#				return val
#		end
		val = @telectp._03_Antenna_power_point(@ATT)
		if val != nil then
				return val
		end
#		val = @telectp._04_Antenna_power_ave(@ATT)
#		if val != nil then
#				return val
#		end
#		val = @telectp._05_Tolerance_of_spurious_unwanted_emission_intensity_far()
#		if val != nil then
#				return val
#		end
		val = @telectp._06_Tolerance_of_spurious_unwanted_emission_intensity_near()
		if val != nil then
				return val
		end
		val = @telectp._07_Tolerance_off_adjacent_channel_leakage_power()
		if val != nil then
				return val
		end
#		@telectp._08_Limit_of_secondary_radiated_emissions()
#		if val != nil then
#				return val
#		end
		val = @telectp._09_Career_sense(@ATT)
		if val != nil then
				return val
		end
#		val = @telectp._10_Spectrum_emission_mask()
#		if val != nil then
#				return val
#		end
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
		$sp.puts("rfw 8 0x71 0x06")
		p $sp.gets()
		sleep 0.05
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
#				@laz.send(panid,dst_short_addr,"LAPIS Lazurite RF system")
				@laz.rxEnable()
				sleep 0.1
				# TX setting
				sbgSend()
				# Receive
				@laz.available() 
				rcv = @laz.read()
				p rcv["rssi"]
				if rcv == 0 then
						$log.info("error: Anntena test: no receiving")
						@laz.remove()
						sleep 1.000
						return "Error"
				else
						$log.info("+++++++++++ SUMMARY ++++++++++")
						$log.info(sprintf("Rx rssi: %d\n",rcv["rssi"]))
						$log.info("Subject: Anntena test")
						$log.info("Judgement: PASS")
						p rcv
				end
		rescue Exception => e
				p e
				sleep 1
		end
#		@laz.close()
		@laz.remove()
		sleep 1.000
		return nil
end

####### MAIN LOOP Start ########
loop do
	begin 
			for index in 0..3 do
					sleep 0.5
					# MJ2001 firmware checking
					$sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) 
					sleep 0.1
					$sp.puts("sgi")
					sleep 0.1
					val = $sp.gets()
					$sp.close
					if val =~ /sgi/ then
							break
					end
			end

			if val !~ /sgi/ then
					p "error: firmware or device not found"
					`gpio -g write #{$RLED} 1`
					next
			end

			val = @sbg.com("erd 32 8")
			addr64 = val[11,val.length - 11 - 1].split(",")
			for index in 0..addr64.length - 1 do
					if addr64[index].length == 1 then
							addr64[index].insert(0,"0")
					end
					#		p addr64[index]
			end
			addr64_str = addr64[0]+addr64[1]+addr64[2]+addr64[3]+addr64[4]+addr64[5]+addr64[6]+addr64[7]
			p addr64_str

=begin
				$sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # device, rate, data, stop, parity
				sleep 0.1
				$sp.puts("ewp 0")
				p $sp.gets()
				$sp.puts("erd 32 8")
				val = $sp.gets()
				addr64 = val[11,val.length - 11 - 1].split(",")
				for index in 0..addr64.length - 1 do
						if addr64[index].length == 1 then
								addr64[index].insert(0,"0")
						end
						p addr64[index]
				end
				addr64_str = addr64[0]+addr64[1]+addr64[2]+addr64[3]+addr64[4]+addr64[5]+addr64[6]+addr64[7]
				p addr64_str
=end
=begin
#			"sshpass -p pwsjuser01 ssh sjuser01@10.9.20.1 grep 151517 /home/share/MJ2001/log/test1.csv"
#			system("sshpass -p pwsjuser01 scp " + logfilename + " sjuser01@10.9.20.1:/home/share/MJ2001/log2/.")
=end

			#CREATE LOG FILE
			t = Time.now
			date = sprintf("%04d%02d%02d%02d%02d_",t.year,t.mon,t.mday,t.hour,t.min)
			#			logfilename = @rftp.get_shortAddr()
			logfilename = addr64_str
			logfilename = "/home/pi/test920j/Log/" + date + logfilename + ".log"
			if File.exist?(logfilename) == true then
					p "duplicate log file name"
			end
			$log = Logger.new(logfilename)
			# $log = Logger.new("| tee temp.log")

			if @TEST_MODE == 0 then
					if $dbResult == false then
							msg = "error: device is not registered in log.db"
							$log.info(msg)
							p msg
							raise RuntimeError, "ERRR\n"
					end
			end

			if @TEST_MODE < 2 then
					val = aribTest()
					if val == "Error" then
							msg = "error: arib test error"
							$log.info(msg)
							p msg
							raise RuntimeError, "ERRR\n"
					end  
			end

			if @TEST_MODE == 3 then
#				for num in 1..3 do
				@rftp.e2p_base_MJ2001()
			  @sbg.trxoff
				@rftp.calibration(@ATT)
#				end
			end

#			val = anntenaTest()
#			if val == "Error" then
#					msg = "error: anntena test error"
#					$log.info(msg)
#					p msg
#					raise RuntimeError, "ERRR\n"
#			end  

			$log.info("+++++++++++ SUMMARY ++++++++++\n")
			$log.info("Subject: read eeprom\n")
			$log.info(@sbg.com("erd 0 32"))
			$log.info(@sbg.com("erd 0 32"))
			$log.info(@sbg.com("erd 32 32"))
			$log.info(@sbg.com("erd 64 32"))
			$log.info(@sbg.com("erd 96 32"))
			$log.info(@sbg.com("erd 128 32"))
			$log.info(@sbg.com("erd 160 32"))
			$log.info(@sbg.com("erd 192 32"))
			$log.info(@sbg.com("erd 224 32"))
			$log.info(@sbg.com("erd 256 32"))

			$log.info("########################")
			$log.info(sprintf("Device ID: %s",addr64_str))
			$log.info("RF test finished: PASS")
			$log.info("########################")
			p logfilename

			if @TEST_MODE == 0 then
					system("sshpass -p pwsjuser01 scp " + logfilename + " sjuser01@10.9.20.1:/home/share/MJ2001/log2/.")
					File.delete(logfilename)
			end
			`gpio -g write #{$GLED} 1`

	rescue RuntimeError

			$log.info("########################")
			$log.info(sprintf("Device ID: %s",addr64_str))
			$log.info("RF test finish: NG")
			$log.info("########################")
			p logfilename
			system("sshpass -p pwsjuser01 scp " + logfilename + " sjuser01@10.9.20.1:/home/share/MJ2001/log2/.")
			File.delete(logfilename)
			`gpio -g write #{$RLED} 1`
			next
	end # begin
	exit
end # main loop 
