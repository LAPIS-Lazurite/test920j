#!/usr/bin/ruby
require "timeout"
require "socket"
require "json"
require "serialport"
require "date"
require "net/http"
require "uri"
#
####### PARAMETERS ########
$ENB_BOOT_WRITE=true
$ENB_PROG_WRITE=true
$ENB_LED_TEST  =true

$TRG_BUTTON=6
$OK_BUTTON=12
$NG_BUTTON=13
$PASS_LED=21
$FAIL_LED=20
$BLED=26
$YLED=16
$RLED=19

$V3_PWR_ON_VIN	= 3.0
$V3_PWR_ON_MIN	= 2.5
$V3_PWR_ON_MAX	= 3.005
$I_PWR_ON_MIN = 0.0
$I_PWR_ON_MAX = 0.1

$V3_RX_ENABLE_VIN	= 3.0
$V3_RX_ENABLE_MIN	= 2.5
$V3_RX_ENABLE_MAX	= 3
$I_RX_ENABLE_MIN = 0.0
$I_RX_ENABLE_MAX = 0.1

$V3_RX_DISABLE_VIN	= 3.0
$V3_RX_DISABLE_MIN	= 2.5
$V3_RX_DISABLE_MAX	= 3.0
$I_RX_DISABLE_MIN = 0.0
$I_RX_DISABLE_MAX = 0.1

$V5_HALT_VIN = 5.00
$V5_HALT_MIN = 3.25
$V5_HALT_MAX = 3.35
$I_V5_HALT_MIN = 0.0
$I_V5_HALT_MAX = 0.005

$V2_HALT_VIN = 3.0
$V2_HALT_MIN = 2.5
$V2_HALT_MAX = 3.005
$I_V2_HALT_MIN = 0.0
$I_V2_HALT_MAX = 0.005

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

def changeLedAll(on)
  `gpio -g write #{$PASS_LED} #{on}`
  `gpio -g write #{$FAIL_LED} #{on}`
  `gpio -g write #{$RLED} #{on}`
  `gpio -g write #{$YLED} #{on}`
  `gpio -g write #{$BLED} #{on}`
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
log[:device] = {}
payload = {:payload => log}
$req.body = payload.to_json
$res = $http.request($req)

begin
  timeout(5) do
    $pmx18a=TCPSocket.open("10.9.20.2",5025)
    $pmx18a.puts("*IDN?")
    if $pmx18a.gets().chop != "KIKUSUI,PMX18-2A,YK000148,IFC01.52.0011 IOC01.10.0070" then
      log[:device][:pmx18a] = {
        :status => false,
        :log => "error"
      }
    else 
      log[:device][:pmx18a] = {
        :status => true
      }
    end
    cmd = "VOLT #{$V3_PWR_ON_VIN}"
    puts cmd
    $pmx18a.puts(cmd)
    $pmx18a.puts("VOLT?")
    if $pmx18a.gets().to_f != $V3_PWR_ON_VIN then
      log[:device][:pmx18a] = {
        :status => false,
        :log => "output voltage set error"
      }
    end
    $pmx18a.puts("CURR:PROT 0.2")
    $pmx18a.puts("CURR:PROT?")
    if $pmx18a.gets().to_f != 0.2 then
      log[:device][:pmx18a] = {
        :status => false,
        :log => "Current protection error"
      }
    end
  end
rescue Timeout::Error
  log[:device][:pmx18a] = {
    :status => false,
    :log => "not found"
  }
end
begin
  timeout(5) do
    $ky34461a_v=TCPSocket.open("10.9.20.3",5025)
    $ky34461a_v.puts("*IDN?")
    if $ky34461a_v.gets().chop != "Keysight Technologies,34461A,MY57224851,A.02.17-02.40-02.17-00.52-04-02" then
      log[:device][:ky34461a_v] = {
        :status => false,
        :log => "error"
      }
    else 
      log[:device][:ky34461a_v] = {
        :status => true
      }
    end
    $ky34461a_v.puts("CONF:VOLT:DC 10V")
  end
rescue Timeout::Error
  log[:device][:ky34461a_v] = {
    :status => false,
    :log => "not found"
  }
end
begin
  timeout(5) do
    $ky34465a_i=TCPSocket.open("10.9.20.4",5025)
    $ky34465a_i.puts("*IDN?")
    if $ky34465a_i.gets().chop != "Keysight Technologies,34465A,MY57515053,A.02.17-02.40-02.17-00.52-04-01" then
      log[:device][:ky34465a_i] = {
        :status => false,
        :log => "error"
      }
    else 
      log[:device][:ky34465a_i] = {
        :status => true
      }
    end
    $ky34465a_i.puts("CONF:CURR:DC 100mA")
    $ky34465a_i.puts("CONF?")
    puts $ky34465a_i.gets.chop
  end
rescue Timeout::Error
  log[:device][:ky34465a_i] = {
    :status => false,
    :log => "not found"
  }
end
log[:process] = "init"
log[:ongoing] = false
log[:end] = DateTime.now
log[:optime] = diffDateTime(log[:end],log[:st])
log[:message] = "試験機を開けてデバイスをセットしてください"
log[:details] = JSON.pretty_generate(log[:device])
#puts log.to_json
payload = {:payload => log}
$req.body = payload.to_json
$res = $http.request($req)

if log[:device][:pmx18a][:status] != true  || log[:device][:ky34461a_v][:status] != true || log[:device][:ky34465a_i][:status] != true then
  exit
end

`gpio -g mode #{$TRG_BUTTON} in`
`gpio -g mode #{$OK_BUTTON} in`
`gpio -g mode #{$NG_BUTTON} in`
`gpio -g mode #{$PASS_LED} out`
`gpio -g mode #{$FAIL_LED} out`
`gpio -g mode #{$RLED} out`
`gpio -g mode #{$YLED} out`
`gpio -g mode #{$BLED} out`

####### TEST FUNC ########
loop do
  $mac=nil
  button_loop_count=0
  # 試験機がOPENになるのを待つ
  loop do
    button_state = `gpio -g read #{$TRG_BUTTON}`.chop.to_i
    if button_state == 1 then
      break
    end
    sleep(0.01)
  end

  begin
    timeout(1) do
      loop do
        dummy = gets
      end
    end
  rescue Timeout::Error
  end

  log[:process] = "setting"
  log[:ongoing] = false
  log[:st] = DateTime.now
  log[:message] = "デバイスをセットし、MACアドレスのバーコードを読み込んでください"

  # post message
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  led_state = 0
  log = {}
  loop do
    begin
      led_state = led_state==0?1:0
      changeLedAll(led_state)
      timeout(1) do
        $mac = nil;
        rdata = gets.chop
        $mac = {str:"",addr:[]}
        $mac[:str] = rdata
        if rdata.length == 16 && rdata.gsub(/[0-9A-Fa-f]/,"") == "" then	#文字列の長さと使用文字の確認
          for i in 0..7 do
            data = "0x"+rdata.slice(i*2,2)
            $mac[:addr].push(data.hex)
          end
          break
        end
      end
      if $mac[:addr].length == 8 then
        break
      end
      log[:process] = "setting"
      log[:message] = "MACアドレスが異常です"
      log[:details] = $mac[:str]
      payload = {payload: log}
      $req.body = payload.to_json
      $res = $http.request($req)
    rescue Timeout::Error
    end
  end

  log[:process] = "setting"
  log[:ongoing] = false
  log[:st] = DateTime.now
  log[:message] = "試験機を閉じてください"
  # post message
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  button_loop_count = 0
  @buttun_chat = nil
  loop do
    button_state = `gpio -g read #{$TRG_BUTTON}`.chop.to_i
    if @button_chat == 0 && button_state == 0 then
      break
    end
    @button_chat = button_state
    button_loop_count +=1
    if button_loop_count  == 20 then
      changeLedAll(1)
    elsif button_loop_count  > 40 then
      changeLedAll(0)
      button_loop_count  = 0
    end
    sleep(0.01)
  end
  changeLedAll(0)
  log = {}
  log[:process] = "testing"
  log[:ongoing] = true
  log[:st] = DateTime.now
  log[:mac] = $mac;
  log[:message] = ""
  log[:details] = "[0] MAC ADDRESS: #{$mac[:str]}\n"
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  #POWER OUTPUT
  $pmx18a.puts("VOLT #{$V3_PWR_ON_VIN}")
  $pmx18a.puts("OUTP ON")

  # Measure 3V3
  $testNum = 1
  puts "[#{$testNum}] POWER ON TEST"
  $ky34461a_v.puts("MEAS:VOLT:DC?")
  $ky34465a_i.puts("MEAS:CURR:DC?")
  vmeas = $ky34461a_v.gets.to_f
  if vmeas < $V3_PWR_ON_MIN || vmeas > $V3_PWR_ON_MAX then
    log[:details] += "[#{$testNum}] IV CHECK: FAIL V(#{vmeas}) MIN(#{$V3_PWR_ON_MIN}), MAX(#{$V3_PWR_ON_MAX})\n"
    testEndProcess(false,log)
    next
  end
  imeas = $ky34465a_i.gets.to_f
  if imeas < $I_PWR_ON_MIN || imeas > $I_PWR_ON_MAX then
    log[:details] += "[#{$testNum}] IV CHECK: FAIL V(#{imeas}) MIN(#{$I_PWR_ON_MIN}), MAX(#{$I_PWR_ON_MAX})\n"
    testEndProcess(false,log)
    next
  end
  log[:details] += "[#{$testNum}] IV CHECK: PASS V(#{vmeas}),I(#{imeas})\n"
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  sleep 0.4

  # BOOT Program Write
  if $ENB_BOOT_WRITE == true then
    $testNum = 2
    puts "[#{$testNum}] boot program write"
    `rmmod ftdi_sio`
    `rmmod usbserial`
    `./lib/cpp/bootwriter/bootwriter 0 LAPIS "LAZURITE mini series" ./lib/cpp/bootwriter/ML620Q504_000RA.bin 0xf000 0xfc4f`
    if $?.exitstatus == 0 then
      log[:details] += "[#{$testNum}] boot write: OK\n"
    else
      log[:details] += "[#{$testNum}] boot write: FAIL\n"
      testEndProcess(false,log)
      next
    end
    payload = {payload: log}
    $req.body = payload.to_json
    $res = $http.request($req)
  end

  # マイコンプログラム書き込み
  #`sudo rmmod ftdi_sio`
  #`sudo rmmod usbserial`
  if $ENB_PROG_WRITE == true then
    $testNum=3
    puts "[#{$testNum}]MCU program write"
    `lib/cpp/bootmode/bootmode "LAZURITE mini series"`
    `modprobe ftdi_sio`
    `modprobe usbserial`
    `stty -F /dev/ttyUSB0 115200`
    #sxは成功/失敗が捉えられないので45秒でtimeout
    begin
      timeout(30) do
        `sx -b bin/test.bin > /dev/ttyUSB0 < /dev/ttyUSB0`
        log[:details] += "[#{$testNum}] program write: OK\n"
      end
    rescue Timeout::Error
      #sxは処理が常駐されてしまうため、強制終了する
      ps = `ps -aux |grep sx | grep -v grep`
      lines = ps.split("\n")
      lines.each {|line|
        pid = line.split(" ")[1]
        `kill -9 #{pid}`
      }
      log[:details] += "[#{$testNum}] program write: FAIL\n"
      testEndProcess(false,log)
      next
    end
    payload = {payload: log}
    $req.body = payload.to_json
    $res = $http.request($req)
  end

  # RESET
  puts "reset MJ2001"
  `rmmod ftdi_sio`
  `rmmod usbserial`
  `lib/cpp/reset/reset "LAZURITE mini series"`

  `modprobe ftdi_sio`
  `modprobe usbserial`

  $sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) # device, rate, data, stop, parity
  sleep(1);


  # [3]Initialize MJ2001
  $testNum=10
  puts "[#{$testNum}] Initialize MJ2001"
  begin
    timeout(1) do 
      $sp.puts("sgi")
      loop do
        tmp = $sp.readline.chomp.strip # こっちだと空白とか余分な情報をそぎ落としてくれる
        puts tmp
        if tmp == "sgi" then
          log[:details] += "[#{$testNum}] send sgi: OK\n"
          break
        end
      end
    end
  rescue Timeout::Error
    log[:details] += "[#{$testNum}] send sgi: FAIL\n"
    testEndProcess(false,log)
    next
  end
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  # [4] release EEPROM write protection
  $testNum=20
  puts "[#{$testNum}] release EEPROM Write Protetion"
  if txVerifyTimeout("ewp,0",1) == true then
    log[:details] += "[#{$testNum}] release write protection: OK\n"
  else
    log[:details] += "[#{$testNum}] release write protection: FAIL\n"
    testEndProcess(false,log)
    next
  end

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
  if txVerifyTimeout("ewp,1",1) == true then
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

  sleep 0.1					#wait until rxEnable
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  $testNum = 42
  puts "[#{$testNum}] IV MEASURE ON rxEnable"
  $pmx18a.puts("VOLT #{$V3_RX_ENABLE_VIN}")
  $ky34461a_v.puts("MEAS:VOLT:DC?")
  $ky34465a_i.puts("MEAS:CURR:DC?")
  vmeas = $ky34461a_v.gets.to_f
  if vmeas < $V3_RX_ENABLE_MIN || vmeas > $V3_RX_ENABLE_MAX then
    log[:details] += "[#{$testNum}] IV CHECK: FAIL V(#{vmeas}) MIN(#{$V3_RX_ENABLE_MIN}), MAX(#{$V3_RX_ENABLE_MAX})\n"
    testEndProcess(false,log)
    next
  end
  imeas = $ky34465a_i.gets.to_f
  if imeas < $I_RX_ENABLE_MIN || imeas > $I_RX_ENABLE_MAX then
    log[:details] += "[#{$testNum}] IV CHECK: FAIL I(#{imeas}) MIN(#{$I_RX_ENABLE_MIN}), MAX(#{$I_RX_ENABLE_MAX})\n"
    testEndProcess(false,log)
    next
  end
  log[:details] += "[#{$testNum}] IV CHECK: PASS V(#{vmeas}),I(#{imeas})\n"
  puts "[#{$testNum}] IV CHECK: PASS V(#{vmeas}),I(#{imeas})\n"

  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  $testNum = 43
  if txVerifyTimeout("sgrd",1) == true then
    log[:details] += "[#{$testNum}] SubGHz rxDisable: PASS\n"
  else
    log[:details] += "[#{$testNum}] SubGHz rxDisable: FAIL\n"
    testEndProcess(false,log)
    next
  end

  $testNum = 44
  if txVerifyTimeout("sgc,0",1) == true then
    log[:details] += "[#{$testNum}] SubGHz close: PASS\n"
  else
    log[:details] += "[#{$testNum}] SubGHz close: FAIL\n"
    testEndProcess(false,log)
    next
  end

  $testNum = 45
  puts "[#{$testNum}] IV MEASURE ON rxDisable"
  $pmx18a.puts("VOLT #{$V3_RX_DISABLE_VIN}")
  $ky34461a_v.puts("MEAS:VOLT:DC?")
  $ky34465a_i.puts("MEAS:CURR:DC?")
  vmeas = $ky34461a_v.gets.to_f
  if vmeas < $V3_RX_DISABLE_MIN || vmeas > $V3_RX_DISABLE_MAX then
    log[:details] += "[#{$testNum}] IV CHECK: FAIL V(#{vmeas}) MIN(#{$V3_RX_DISABLE_MIN}), MAX(#{$V3_RX_DISABLE_MAX})\n"
    testEndProcess(false,log)
    next;
  end
  imeas = $ky34465a_i.gets.to_f
  if imeas < $I_RX_DISABLE_MIN || imeas > $I_RX_DISABLE_MAX then
    log[:details] += "[#{$testNum}] IV CHECK: FAIL I(#{imeas}) MIN(#{$I_RX_DISABLE_MIN}), MAX(#{$I_RX_DISABLE_MAX})\n"
    testEndProcess(false,log)
    next;
  end
  log[:details] += "[#{$testNum}] IV CHECK: PASS V(#{vmeas}),I(#{imeas})\n"
  puts "[#{$testNum}] IV CHECK: PASS V(#{vmeas}),I(#{imeas})\n"


  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)
  $pmx18a.puts("VOLT 3.0")

  $testNum = 50
=begin
  if txVerifyTimeout("pm,20,o",1) != true then
    log[:details] += "[#{$testNum}] pm,20,o: FAIL\n"
    testEndProcess(false,log)
    next;
  end
  if txVerifyTimeout("dw,20,1",0) != true then
    log[:details] += "[#{$testNum}] dw,20,1: FAIL\n"
    testEndProcess(false,log)
    next;
  end
=end
  `gpio -g write #{$RLED} 1`
  prog_state = false;
  log[:ongoing] = false
  log[:message] = "赤のLEDがのみ点灯していたらOK、それ以外はNGを押してください。"
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  loop do
    ok = (`gpio -g read #{$OK_BUTTON}`).chop.to_i
    ng = (`gpio -g read #{$NG_BUTTON}`).chop.to_i
    if ok == 0 then
      log[:details] += "[#{$testNum}] RED LED ON: PASS\n"
      prog_state = true;
      break
    end
    if ng == 0 then
      log[:details] += "[#{$testNum}] RED LED ON: FAIL\n"
      prog_state = false;
      break
    end
    sleep 0.01
  end
  if prog_state == false then
    testEndProcess(false,log)
    next
  end
  if txVerifyTimeout("dw,20,1",1) != true then
    log[:details] += "[#{$testNum}] dw,20,0: FAIL\n"
    testEndProcess(false,log)
    next;
  end
  `gpio -g write #{$RLED} 0`

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


  $testNum = 51
  puts "[#{$testNum}] ORANGE LED ON test"
  if txVerifyTimeout("pm,25,o",1) != true then
    log[:details] += "[#{$testNum}] pm,25,o: FAIL\n"
    testEndProcess(false,log)
    next;
  end
  if txVerifyTimeout("dw,25,0",1) != true then
    log[:details] += "[#{$testNum}] dw,25,1: FAIL\n"
    testEndProcess(false,log)
    next;
  end
  `gpio -g write #{$YLED} 1`
  log[:ongoing] = false
  log[:message] = "オレンジのLEDがのみ点灯していたらOK、それ以外はNGを押してください。"
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

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


  $testNum = 52
  if txVerifyTimeout("pm,26,o",1) != true then
    log[:details] += "[#{$testNum}] pm,25,o: FAIL\n"
    testEndProcess(false,log)
    next;
  end
  if txVerifyTimeout("dw,26,0",1) != true then
    log[:details] += "[#{$testNum}] dw,25,1: FAIL\n"
    testEndProcess(false,log)
    next;
  end
  `gpio -g write #{$BLED} 1`
  log[:message] = "青のLEDがのみ点灯していたらOK、それ以外はNGを押してください。"
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  prog_state = false;
  loop do
    ok = (`gpio -g read #{$OK_BUTTON}`).chop.to_i
    ng = (`gpio -g read #{$NG_BUTTON}`).chop.to_i
    if ok == 0 then
      log[:details] += "[#{$testNum}] BLUE LED ON: PASS\n"
      prog_state = true;
      break
    end
    if ng == 0 then
      log[:details] += "[#{$testNum}] BLUE LED ON: FAIL\n"
      prog_state = false;
      break
    end
    sleep 0.01
  end
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

  $testNum = 60
  $sp.puts("dh")
  sleep 0.01

  $pmx18a.puts("VOLT #{$V5_HALT_VIN}")
  sleep 1
  $ky34461a_v.puts("MEAS:VOLT:DC?")
  $ky34465a_i.puts("MEAS:CURR:DC?")
  vmeas = $ky34461a_v.gets.to_f
  if vmeas < $V5_HALT_MIN || vmeas > $V5_HALT_MAX then
    log[:details] += "[#{$testNum}] IV CHECK: FAIL V(#{vmeas}) MIN(#{$V5_HALT_MIN}), MAX(#{$V5_HALT_MAX})\n"
    testEndProcess(false,log)
    next
  end
  imeas = $ky34465a_i.gets.to_f
  if imeas < $I_V5_HALT_MIN || imeas > $I_V5_HALT_MAX then
    log[:details] += "[#{$testNum}] IV CHECK: FAIL V(#{imeas}) MIN(#{$I_V5_HALT_MIN}), MAX(#{$I_V5_HALT_MAX})\n"
    testEndProcess(false,log)
    next
  end
  log[:details] += "[#{$testNum}] IV CHECK: PASS V(#{vmeas}),I(#{imeas})\n"
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  $testNum = 61
  $pmx18a.puts("VOLT #{$V2_HALT_VIN}")
  sleep 1
  $ky34461a_v.puts("MEAS:VOLT:DC?")
  $ky34465a_i.puts("MEAS:CURR:DC?")
  vmeas = $ky34461a_v.gets.to_f
  if vmeas < $V2_HALT_MIN || vmeas > $V2_HALT_MAX then
    log[:details] += "[#{$testNum}] IV CHECK: FAIL V(#{vmeas}) MIN(#{$V2_HALT_MIN}), MAX(#{$V2_HALT_MAX})\n"
    testEndProcess(false,log)
    next
  end
  imeas = $ky34465a_i.gets.to_f
  if imeas < $I_V5_HALT_MIN || imeas > $I_V5_HALT_MAX then
    log[:details] += "[#{$testNum}] IV CHECK: FAIL V(#{imeas}) MIN(#{$I_V2_HALT_MIN}), MAX(#{$I_V2_HALT_MAX})\n"
    testEndProcess(false,log)
    next
  end
  log[:details] += "[#{$testNum}] IV CHECK: PASS V(#{vmeas}),I(#{imeas})\n"
  payload = {payload: log}
  $req.body = payload.to_json
  $res = $http.request($req)

  testEndProcess(true,log)
end

