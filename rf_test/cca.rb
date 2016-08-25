#! /usr/bin/ruby

require './openif.rb'

RF_STATUS_ADDR	= "8 0x6c "
OSC_ADJ2_ADDR	= "8 0x0a "
PA_ADJ1_ADDR 	= "9 0x04 "
PA_ADJ3_ADDR 	= "9 0x06 "

print("input sg amp(ex:-75):")
sg_amp = gets().to_s

print("input cca level(default:0x55):")
cca_lvl = gets().to_s
$sp.puts("rfw 8 0x13 " + cca_lvl)
p $sp.gets()

# setup DUT -------------------------------------------------
print("Input loop count(ex:10)= ")
loop=gets().to_i
print("input ch[24-61] => ")
ch = gets().to_i
print("input rate[100,50] => ")
rate = gets().to_i
print("input mode[20,1] => ")
mode = gets().to_i

rate50  = {24 => "920600000",33 => "922400000", 36 => "923000000", 60 => "927800000" }
rate100 = {24 => "920700000",33 => "922500000", 36 => "923100000", 60 => "927900000" }
rate50.store(61,"928000000") # Extended
@frq = {50 => rate50, 100 => rate100}

pow_param = Struct.new(:mode, :level, :pa_addr, :pa_bit, :pa_max, :ep_addr)
p1mW_mode = pow_param.new(1, 0, PA_ADJ1_ADDR, 0x01, 0x0f, "ewr 43 ")
p20mW_mode = pow_param.new(20, 1300, PA_ADJ3_ADDR, 0x10, 0xf0, "ewr 41 ")
@pow = {1  => p1mW_mode, 20 => p20mW_mode}

# setup SPA --------------------------------------------------
$sock.puts("*RST")
$sock.puts("*OPC?")
$sock.gets

$sock.puts("inst spect")
$sock.puts("*OPC?")
p $sock.gets

$sock.puts("spf 5mhz")
$sock.puts("*OPC?")
$sock.gets

$sock.puts("rlv 0")
$sock.puts("*OPC?")
$sock.gets

$sock.puts("cnf " + @frq[rate][ch].to_s)
$sock.puts("*OPC?")
p $sock.gets

# setup SG --------------------------------------------------
$sock.puts("inst sg")
$sock.puts("*OPC?")
$sock.gets

$sock.puts("outp 1") 				#SG out 1:ON  0:OFF
$sock.puts("*OPC?")
$sock.gets

$sock.puts("freq " + @frq[rate][ch].to_s)
$sock.puts("*OPC?")
$sock.gets

$sock.puts("pow " + sg_amp)				#output level 
$sock.puts("*OPC?")
$sock.gets

$sock.puts("pow?")
$sock.puts("*OPC?")
p $sock.gets


# Send Packet ------------------------------------------------
for i in 1..loop
	$sp.puts("sgs 0xffff 0xffff")
	p $sp.gets()
	sleep(1)
end


$sock.close
$sp.close
