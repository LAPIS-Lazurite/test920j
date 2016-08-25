#! /usr/bin/ruby

require './openif.rb'
#require ("tk")

#root = TkRoot.new
#root.title("TK sample widget")

#label = TkLabel.new
#label.text("test")
#label.pack("ipadx"=>1000, "ipady"=>100)
#label.background("#000080")
#label.foreground("#ffff00")
#
#TkButton.new do
#	command do
#		Tk.messageBox("type" => "yesno",
#			"title" => "wwwww","message" => "sssss")
#		Tk.getOpenFile("filetype" = > ["all", ".*"],"defaultextension" => ".rb")
#	end
#	pack
#end
#Tk.mainloop

RF_STATUS_ADDR	= "8 0x6c "
OSC_ADJ2_ADDR	= "8 0x0a "
PA_ADJ1_ADDR 	= "9 0x04 "
PA_ADJ3_ADDR 	= "9 0x06 "

# DUT setup ------------------------------------
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


# TESTER control -----------------------------
$sock.puts("*RST")
$sock.puts("*OPC?")
$sock.gets

$sock.puts("cnf " + @frq[rate][ch].to_s)
$sock.puts("*OPC?")
$sock.gets

$sock.puts("zerospan")
$sock.puts("*OPC?")
$sock.gets

$sock.puts("rlv 20")
$sock.puts("*OPC?")
$sock.gets

$sock.puts("trglvl -30")
$sock.puts("*OPC?")
$sock.gets

$sock.puts("tdly -10")
$sock.puts("*OPC?")
$sock.gets

$sock.puts("swe:time 0.2")
$sock.puts("*OPC?")
$sock.gets

# DUT send ------------------------------------
$sp.puts("sgi")
p $sp.gets()
$sp.puts("sgb," + ch.to_s + ",0xabcd," + rate.to_s + "," + mode.to_s)
p $sp.gets()
$sp.puts("w,Welcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductor")
p $sp.gets()

for i in 1..loop
	$sp.puts("sgs 0xffff 0xffff")
	p $sp.gets()
end

$sock.close
$sp.close
