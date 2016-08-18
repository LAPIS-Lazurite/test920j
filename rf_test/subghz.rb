#! /usr/bin/ruby

require './openif.rb'

RF_STATUS_ADDR	= "8 0x6c "
OSC_ADJ2_ADDR	= "8 0x0a "
PA_ADJ1_ADDR 	= "9 0x04 "
PA_ADJ3_ADDR 	= "9 0x06 "

# DUT setup ------------------------------------
	ch=36
	rate=100
	mode=20

	rate50  = {24 => "920600000",33 => "922400000", 36 => "923000000", 60 => "927800000" }
	rate100 = {24 => "920700000",33 => "922500000", 36 => "923100000", 60 => "927900000" }
	rate50.store(61,"928000000") # Extended
	@frq = {50 => rate50, 100 => rate100}

	pow_param = Struct.new(:mode, :level, :pa_addr, :pa_bit, :pa_max, :ep_addr)
	p1mW_mode = pow_param.new(1, 0, PA_ADJ1_ADDR, 0x01, 0x0f, "ewr 43 ")
	p20mW_mode = pow_param.new(20, 1300, PA_ADJ3_ADDR, 0x10, 0xf0, "ewr 41 ")
	@pow = {1  => p1mW_mode, 20 => p20mW_mode}

	$sp.puts("sgi")
	p $sp.gets()
	$sp.puts("sgb," + ch.to_s + ",0xabcd," + rate.to_s + "," + mode.to_s)
	p $sp.gets()
	$sp.puts("rfw " + RF_STATUS_ADDR + "0x09")
	p $sp.gets()


# TESTER setup ----------------------------------
	$sock.puts("*RST")
	$sock.puts("*OPC?")
	$sock.gets

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


