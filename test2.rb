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
		if $pmx18a.gets().chop != "KIKUSUI,PMX18-2A,YK000148,IFC01.52.0011 IOC01.10.0070" then
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

#if log[:pmx18a][:status] != true then
#	exit
#end
#
####### TEST FUNC ########
loop do
	$mac=nil
	button_loop_count=0
	# 試験機がOPENになるのを待つ
#	loop do
#		button_state = `gpio -g read #{$TRG_BUTTON}`.chop.to_i
#		if button_state == 1 then
#			break
#		end
#		sleep(0.01)
#	end

#  begin
#    timeout(1) do
#      loop do
#        dummy = gets
#      end
#    end
#    rescue Timeout::Error
#  end

  log[:process] = "setting"
  log[:ongoing] = false
  log[:st] = DateTime.now
  log[:message] = "デバイスをセットし、MACアドレスのバーコードを読み込んでください"

  # post message
  payload = {payload: log}

  led_state = 0
  log = {}
# loop do
#   begin
#     led_state = led_state==0?1:0
#     timeout(1) do
#       $mac = nil;
#       rdata = gets.chop
#       $mac = {str:"",addr:[]}
#       $mac[:str] = rdata
#       if rdata.length == 16 && rdata.gsub(/[0-9A-Fa-f]/,"") == "" then	#文字列の長さと使用文字の確認
#         for i in 0..7 do
#           data = "0x"+rdata.slice(i*2,2)
#           $mac[:addr].push(data.hex)
#         end
#         break
#       end
#     end
#     if $mac[:addr].length == 8 then
#       break
#     end
#     log[:process] = "setting"
      log[:message] = "MACアドレスが異常です"
#     log[:details] = $mac[:str]
#     payload = {payload: log}
#     $req.body = payload.to_json
#     $res = $http.request($req)
#   rescue Timeout::Error
#   end
# end

  log[:process] = "setting"
  log[:ongoing] = false
  log[:st] = DateTime.now
  log[:message] = "試験機を閉じてください"
  # post message
  payload = {payload: log}
# $req.body = payload.to_json
# $res = $http.request($req)

  button_loop_count = 0
  @buttun_chat = nil

  #POWER OUTPUT
  $pmx18a.puts("VOLT #{$V3_PWR_ON_VIN}")
  $pmx18a.puts("OUTP ON")

  $pmx18a.puts("MEASure:CURRent?")
  val = $pmx18a.gets().to_f
  p val
  if val > $I_PWR_ON_MAX then
      p "NG"
###   log[:device][:pmx18a] = {
###     :status => false,
###     :log => "error"
###   }
  else
      p "OK"
  end  


  sleep 1
  
  # RESET
  puts "reset MJ2001"
  `rmmod ftdi_sio`
  `rmmod usbserial`
  `lib/cpp/reset/reset "LAZURITE mini series"`

  `modprobe ftdi_sio`
  `modprobe usbserial`

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

# $sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # device, rate, data, stop, parity
# sleep(1);
# $sp.puts("sgi")
# p $sp.gets()
# sleep 0.05
# $sp.puts("sgb 24 0xabcd 100 20")
# p $sp.gets()
# sleep 0.05
# $sp.puts("rfw 8 0x6c 0x09")
# p $sp.gets()
# sleep 0.05
# $sp.puts("rfr 8 0x6c")
# p $sp.gets()






# # [3]Initialize MJ2001
# $testNum=10
# puts "[#{$testNum}] Initialize MJ2001"
# begin
#   timeout(1) do 
#     $sp.puts("sgi")
#     loop do
#       tmp = $sp.readline.chomp.strip # こっちだと空白とか余分な情報をそぎ落としてくれる
#       puts tmp
#       if tmp == "sgi" then
#         log[:details] += "[#{$testNum}] send sgi: OK\n"
#         break
#       end
#     end
#   end
# rescue Timeout::Error
#   log[:details] += "[#{$testNum}] send sgi: FAIL\n"
#   testEndProcess(false,log)
#   next
# end
# payload = {payload: log}
# $req.body = payload.to_json
# $res = $http.request($req)

  # [4] release EEPROM write protection
# $testNum=20
# puts "[#{$testNum}] release EEPROM Write Protetion"
# if txVerifyTimeout("ewp,0",1) == true then
#   log[:details] += "[#{$testNum}] release write protection: OK\n"
# else
#   log[:details] += "[#{$testNum}] release write protection: FAIL\n"
#   testEndProcess(false,log)
#   next
# end

  $pmx18a.puts("OUTP OFF")

  p logfilename
  syscom = "sshpass -p pwsjuser01 scp " + logfilename + " sjuser01@10.9.20.1:"
  system(syscom)

  exit # --------------------

  # [5-12] write MAC ADDRESS
  $testNum = 21
  prog_state = true
  for i in 0..7 do
    #cmd = "ewr,#{(32+i)},0x#{$mac[:addr][i].to_s(16)}"
    cmd = "ewr,0x#{(32+i).to_s(16)},0x#{$mac[:addr][i].to_s(16)}"
    if txVerifyTimeout(cmd,1) == true then
    else
      log[:details] += "[#{$testNum}] write MAC address(#{i}): FAIL\n"
      prog_state = false
      break;
    end
  end
  if prog_state == false then
    testEndProcess(false,log)
    next
  end
  log[:details] += "[#{$testNum}] write MAC address: OK\n"
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  # [13] release EEPROM write protection
  $testNum = 22
  puts "[#{$testNum}] set EEPROM Write Protetion"
  if txVerifyTimeout("ewp,0",1) == true then
    log[:details] += "[#{$testNum}] set write protection: OK\n"
  else
    log[:details] += "[#{$testNum}] set write protection: FAIL\n"
    testEndProcess(false,log)
    next
  end
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  # [14] checke written data in EEPROM
  $testNum = 23

  prog_state = true
  begin
    timeout(2) do
      $sp.puts("erd,32,8");
      rdata = $sp.readline.chomp.strip
      tmp = rdata.split(",")
      tmp = tmp[3..10]
      raddr = []
      tmp.each {|a|
        raddr.push(a.hex)
      }
      for i in 0..7 do
        if raddr[i] != $mac[:addr][i] then
          prog_state = false
          log[:details] += sprintf("[%d] verigy MAC address: FAIL %02x%02x%02x%02x%02x%02x%02x%02x\n",$testNum, raddr[0], raddr[1], raddr[2], raddr[3], raddr[4], raddr[5], raddr[6], raddr[7])
          break
        end
      end
    end
  rescue Timeout::Error
    log[:details] += "[#{$testNum}] verify MAC address : FAIL timeout\n"
  end
  if prog_state == true then
    log[:details] += "[#{$testNum}] verify MAC address : OK\n"
  end
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  # IO TEST

  # [] start RF then V MEASURE & I MEASURE
  $testNum = 40
  puts "[#{$testNum}] start RF then V MEASURE & I MEASURE"
  if txVerifyTimeout("sgb,36,0xabcd,100,20,0",1) == true then
    log[:details] += "[#{$testNum}] SubGHz begin: PASS\n"
  else
    log[:details] += "[#{$testNum}] SubGHz begin: FAIL\n"
    testEndProcess(false,log)
    next
  end
  $testNum = 41
  if txVerifyTimeout("sgre",1) == true then
    log[:details] += "[#{$testNum}] SubGHz rxEnable: PASS\n"
  else
    log[:details] += "[#{$testNum}] SubGHz rxEnable: FAIL\n"
    testEndProcess(false,log)
    next
  end

  # wait release button
  loop do 
    sleep 0.05
    if (`gpio -g read #{$OK_BUTTON}`).chop.to_i == 0 then
      next
    end
    if (`gpio -g read #{$NG_BUTTON}`).chop.to_i == 0 then
      next
    end
    break;
  end


  prog_state = false;
  loop do
    ok = (`gpio -g read #{$OK_BUTTON}`).chop.to_i
    ng = (`gpio -g read #{$NG_BUTTON}`).chop.to_i
    if ok == 0 then
      log[:details] += "[#{$testNum}] ORANGE LED ON: PASS\n"
      prog_state = true;
      break
    end
    if ng == 0 then
      log[:details] += "[#{$testNum}] ORANGE LED ON: FAIL\n"
      prog_state = false;
      break
    end
    sleep 0.01
  end
  if prog_state == false then
    testEndProcess(false,log)
    next
  end
  if txVerifyTimeout("dw,25,1",0) != true then
    log[:details] += "[#{$testNum}] dw,25,0: FAIL\n"
    testEndProcess(false,log)
    next;
  end
  `gpio -g write #{$YLED} 0`

  # wait release button
  loop do 
    sleep 0.05
    if (`gpio -g read #{$OK_BUTTON}`).chop.to_i == 0 then
      next
    end
    if (`gpio -g read #{$NG_BUTTON}`).chop.to_i == 0 then
      next
    end
    break;
  end

  prog_state = false;

  if prog_state == false then
    testEndProcess(false,log)
    next
  end
  if txVerifyTimeout("dw,26,1",1) != true then
    log[:details] += "[#{$testNum}] dw,25,0: FAIL\n"
    testEndProcess(false,log)
    next;
  end
  `gpio -g write #{$BLED} 0`

  log[:ongoing] = true
  log[:message] == ""
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  sleep 1000

  testEndProcess(true,log)
end

