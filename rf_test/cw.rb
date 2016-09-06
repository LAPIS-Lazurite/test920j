#! /usr/bin/ruby

require './socket.rb'
require './subghz.rb'

RF_STATUS_ADDR	= "8 0x6c "
OSC_ADJ2_ADDR	= "8 0x0a "
PA_ADJ1_ADDR 	= "9 0x04 "
PA_ADJ3_ADDR 	= "9 0x06 "

# DUT setup ------------------------------------
	print("input ch[24-61] => ")
	ch = gets().to_i
	print("input rate[100,50] => ")
	rate = gets().to_i
	print("input mode[20,1] => ")
	mode = gets().to_i

#	rate50  = {24 => "920600000",33 => "922400000", 36 => "923000000", 60 => "927800000" }
#	rate100 = {24 => "920700000",33 => "922500000", 36 => "923100000", 60 => "927900000" }
#	rate50.store(61,"928000000") # Extended
	rate50  = {24 => "920600000",36 => "923000000",39=>"923600000",40=> "923800000",41=>"924000000",43 => "924400000",61 => "928000000" }
	rate100 = {24 => "920700000",36 => "923100000",39=>"923700000",40=> "923900000",41=>"924100000",42 => "924300000",60 => "927900000" }
	@frq = {50 => rate50, 100 => rate100}

	pow_param = Struct.new(:mode, :level, :pa_addr, :pa_bit, :pa_max, :ep_addr)
	p1mW_mode = pow_param.new(1, 0, PA_ADJ1_ADDR, 0x01, 0x0f, "ewr 43 ")
	p20mW_mode = pow_param.new(20, 1300, PA_ADJ3_ADDR, 0x10, 0xf0, "ewr 41 ")
	@pow = {1  => p1mW_mode, 20 => p20mW_mode}

	sbg = Subghz.new()
	sbg.setup(ch, rate, mode)
	sbg.txon()

# TESTER setup ----------------------------------
	$sock.puts("*RST")
	$sock.puts("*OPC?")
	$sock.gets

    $sock.puts("INST SPECT")

	$sock.puts("spf 500khz")
	$sock.puts("*OPC?")
	$sock.gets

	$sock.puts("rlv 20")
	$sock.puts("*OPC?")
	$sock.gets

	$sock.puts("cnf " + @frq[rate][ch].to_s)
	$sock.puts("*OPC?")
	$sock.gets

	$sock.puts("mkpk")
	$sock.puts("*OPC?")
	$sock.gets

	$sock.puts("mkf?")
	$sock.puts("*OPC?")
	value = $sock.gets
	p value

$sock.close
