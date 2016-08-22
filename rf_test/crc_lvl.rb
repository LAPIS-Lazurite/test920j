#! /usr/bin/ruby

require './openif.rb'

print("input sg power:")
sg_pow = gets().to_s

print("input cca level(default:0x55):")
cca_lvl = gets().to_s

# setup DUT -------------------------------------------------
$sp.puts("sgi")
p $sp.gets()
$sp.puts("sgb,36,0xabcd,100,20")
p $sp.gets()
$sp.puts("w,Welcome_SubGHz_LAPIS_semiconductor")
p $sp.gets()
$sp.puts("rfw 8 0x13 0x" + cca_lvl)
p $sp.gets()


# setup ZOROSPAN --------------------------------------------
$sock.puts("inst spect")
$sock.puts("*OPC?")
$sock.gets
$sock.puts("zerospn")
$sock.puts("trglvl -60")
$sock.puts("tdly -50")


# setup SG --------------------------------------------------
$sock.puts("inst sg")
$sock.puts("*OPC?")
$sock.gets

$sock.puts("outp 1") 				#SG out 1:ON  0:OFF
$sock.puts("*OPC?")
$sock.gets

$sock.puts("freq 923.1mhz")			#周波数設定
$sock.puts("*OPC?")
$sock.gets

$sock.puts("pow -" + sg_pow)				#output level 
$sock.puts("*OPC?")
$sock.gets

$sock.puts("pow?")
$sock.puts("*OPC?")
p $sock.gets


# Send Packet ------------------------------------------------
sleep 1
$sp.puts("sgs 0xffff 0xffff")
p $sp.gets()


$sock.close
$sp.close
