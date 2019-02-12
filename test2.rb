#!/usr/bin/ruby
require "timeout"
require "socket"
require "json"
require "serialport"
require "date"
require "net/http"
require "uri"

require 'logger'
require './rf_test/subghz.rb'
require './rf_test/Rftp.rb'
@@rftp = Rftp::Test.new

#
####### PARAMETERS ########
$V3_PWR_ON_VIN	= 3.0
$V3_PWR_ON_MIN	= 2.5
$V3_PWR_ON_MAX	= 3.005
$I_PWR_ON_MIN = 0.0
$I_PWR_ON_MAX = 0.1

####### COMMON FUNC ########
def diffDateTime(b,a)
	(b - a)                       # => (1/17500)
	(b - a).class                 # => Rational
	(b - a) * 24 * 60 * 60        # => (5/1)
	return ((b - a) * 24 * 60 * 60).to_i # => 5
end

def testEndProcess(pass,log)
	if $sp  != nil then
		$sp.close
	end
	$sp = nil
	`rmmod ftdi_sio`
	`rmmod usbserial`
	$pmx18a.puts("OUTP OFF")
	log[:ongoing] = false
	log[:end] = DateTime.now
	log[:message] = "試験機を開けてデバイスをセットしてください"
	log[:optime] = diffDateTime(log[:end],log[:st])
	if pass == true
		log[:success] = true
		`gpio -g write #{$PASS_LED} 1`
		`gpio -g write #{$FAIL_LED} 0`
		`gpio -g write #{$RLED} 0`
		`gpio -g write #{$YLED} 0`
		`gpio -g write #{$BLED} 0`
		`lib/cpp/reset/reset "LAZURITE mini series"`
	else
		log[:success] = false
		`gpio -g write #{$PASS_LED} 0`
		`gpio -g write #{$FAIL_LED} 1`
		`gpio -g write #{$RLED} 0`
		`gpio -g write #{$YLED} 0`
		`gpio -g write #{$BLED} 0`
		`lib/cpp/reset/reset "LAZURITE mini series"`
	end
	#puts JSON.pretty_generate(log)
	payload = {payload: log}
	$req.body = payload.to_json
	$res = $http.request($req)
end
def txVerifyTimeout(cmd,period)
	begin
		timeout(period) do 
			$sp.puts(cmd);
			tmp = $sp.readline.chomp.strip.downcase # こっちだと空白とか余分な情報をそぎ落としてくれる
			if cmd == tmp then
				return true
			end
			puts "txVerifyTimeout cmd:#{cmd}  rx:#{tmp}"
			return "txVerifyTimeout cmd:#{cmd}  rx:#{tmp}"
		end
	rescue Timeout::Error
		puts "txVerifyTimeout timeout"
		return "txVerifyTimeout timeout"
	end
end


####### INITIALIZE ########
$uri = URI.parse("http://10.9.20.1:1880/callback/test1")
$http = Net::HTTP.new($uri.host, $uri.port)
$req = Net::HTTP::Post.new($uri.request_uri)
$req["Content-Type"] = "application/json"

$sp = nil

log = {}
log[:testNum] = 1;
log[:process] = "init"
log[:st] = DateTime.now
log[:ongoing] = true
payload = {:payload => log}
$req.body = payload.to_json
$res = $http.request($req)

begin
	timeout(5) do
		$pmx18a=TCPSocket.open("10.9.20.6",5025)
		$pmx18a.puts("*IDN?")
		if $pmx18a.gets().chop != "KIKUSUI,PMX18-2A,YK000141,IFC01.52.0011 IOC01.10.0070" then
			log[:pmx18a] = {
				:status => false,
				:log => "error"
			}
		else 
			log[:pmx18a] = {
				:status => true
            }
        end
		$pmx18a.puts("CURR:PROT 0.2")
		$pmx18a.puts("CURR:PROT?")
		if $pmx18a.gets().to_f != 0.2 then
			log[:pmx18a] = {
				:status => false,
				:log => "Current protection error"
			}
		end
		$pmx18a.puts("VOLT 2.0")
		$pmx18a.puts("VOLT?")
		if $pmx18a.gets().to_f != 2 then
			log[:pmx18a] = {
				:status => false,
				:log => "output voltage set error"
			}
		end
	end
rescue Timeout::Error
	log[:pmx18a] = {
		:status => false,
		:log => "not found"
	}
end

log[:process] = "init"
log[:ongoing] = false
log[:end] = DateTime.now
log[:optime] = diffDateTime(log[:end],log[:st])
log[:message] = "試験機を開けてデバイスをセットしてください"
puts log.to_json
payload = {:payload => log}
$req.body = payload.to_json
$res = $http.request($req)

if log[:pmx18a][:status] != true then
	exit
end
#
####### TEST FUNC ########
loop do
  log[:process] = "setting"
  log[:ongoing] = false
  log[:st] = DateTime.now
  log[:message] = "試験機を閉じてください"
  # post message
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  #POWER OUTPUT
  $pmx18a.puts("VOLT #{$V3_PWR_ON_VIN}")
  $pmx18a.puts("OUTP ON")

  $pmx18a.puts("MEASure:CURRent?")
  val = $pmx18a.gets().to_f
  p val
  if val > $I_PWR_ON_MAX then
      log[:device][:pmx18a] = {
      :status => false,
      :log => "error"
   }
  end  

  sleep 1
  
  # RESET
  puts "reset MJ2001"
  `rmmod ftdi_sio`
  `rmmod usbserial`
  `lib/cpp/reset/reset "LAZURITE mini series"`

  `modprobe ftdi_sio`
  `modprobe usbserial`

=begin
  $sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # device, rate, data, stop, parity
  sleep(1);
=end

    t = Time.now
    date = sprintf("%04d%02d%02d%02d%02d_",t.year,t.mon,t.mday,t.hour,t.min)
    logfilename = @@rftp.get_shortAddr()
    logfilename = "/home/pi/test920j/Log/" + date + logfilename + ".log"
    $log = Logger.new(logfilename)
#   $log = Logger.new("| tee temp.log")
    $log.info("+++++++++++ SUMMARY ++++++++++")

    @sbg = Subghz.new()
=begin
    @@rftp.e2p_base()
    @@rftp.calibration(@@ATT)
    @@telectp._00_MS2830A_init()
    val = @@telectp._01_Tolerance_of_occupied_bandwidth_Frequency_range()
    if val != nil then
        return val
    end
    val = @@telectp._02_Tolerance_of_frequency()
    if val != nil then
        return val
    end
    val = @@telectp._03_Antenna_power_point(@@ATT)
    if val != nil then
        return val
    end
    val = @@telectp._04_Antenna_power_ave(@@ATT)
    if val != nil then
        return val
    end
    #    @@telectp._05_Tolerance_of_spurious_unwanted_emission_intensity_far()
    val = @@telectp._06_Tolerance_of_spurious_unwanted_emission_intensity_near()
    if val != nil then
        return val
    end
    val = @@telectp._07_Tolerance_off_adjacent_channel_leakage_power()
    if val != nil then
        return val
    end
    #     @@telectp._08_Limit_of_secondary_radiated_emissions()
    val = @@telectp._09_Career_sense(@@ATT)
    if val != nil then
        return val
    end
    val = @@telectp._10_Spectrum_emission_mask()
    if val != nil then
        return val
    end
=end

    p @sbg.trxoff
    p @sbg.setup(24,100,20)
    p @sbg.txon
    p @sbg.rr("8 0x6c")

    $sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # device, rate, data, stop, parity
    sleep(1);
    $sp.puts("sgi")
    p $sp.gets()
    sleep 0.05
    $sp.puts("sgb 24 0xabcd 100 20")
    p $sp.gets()
    sleep 0.05
    $sp.puts("rfw 8 0x6c 0x09")
    p $sp.gets()
    sleep 0.05
    $sp.puts("rfr 8 0x6c")
    p $sp.gets()

  $pmx18a.puts("OUTP OFF")

  p logfilename
  system("sshpass -p pwsjuser01 scp " + logfilename + " sjuser01@10.9.20.1:~/test920j/Log/.")

  log[:ongoing] = true
  log[:message] == ""
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  exit

  sleep 1000

  testEndProcess(true,log)
end

