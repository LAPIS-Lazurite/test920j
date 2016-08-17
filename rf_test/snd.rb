#! /usr/bin/ruby

require './openif.rb'
require ("tk")

#! /usr/bin/ruby
# -*- coding: utf-8; mode: ruby -*-
# Function:
#   Lazurite Sub-GHz/Lazurite Pi Gateway Sample program
#   SerialMonitor.rb
#require '../lib/LazGem'




require("tk")
root = TkRoot.new
root.title("TK sample widget")

label = TkLabel.new
label.text("test")
label.pack("ipadx"=>1000, "ipady"=>100)
label.background("#000080")
label.foreground("#ffff00")

TkButton.new do
	command do
		Tk.messageBox("type" => "yesno",
			"title" => "wwwww","message" => "sssss")
#		Tk.getOpenFile("filetype" = > ["all", ".*"],"defaultextension" => ".rb")
	end
	pack
end
Tk.mainloop

# TESTER control -----------------------------
$sock.puts("*RST")
$sock.puts("*OPC?")
$sock.gets

$sock.puts("cnf 923.1mhz")
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

# DUT control -----------------------------
#print("Input loop count(ex:10)= ")
#loop=gets().to_i
loop=30

$sp.puts("sgi")
p $sp.gets()
$sp.puts("sgb,36,0xabcd,100,20")
p $sp.gets()
$sp.puts("w,Welcome_SubGHz_LAPIS_semiconductor")
p $sp.gets()

for i in 1..loop
	$sp.puts("sgs 0xabcd 0x0007")
	p $sp.gets()
	sleep(0.1)
end

$sock.close
$sp.close
