#! /usr/bin/ruby

if RUBY_PLATFORM ==  "x64-mingw32" then
    require 'rubygems'
    require 'serialport'

	print("input COM number => ")
    com = gets().to_i
    com = "COM" + com.to_s

    $SERIAL_PORT =com
    $SERIAL_BAUDRATE=115200
#   sp = SerialPort.new(SERIAL_PORT, SERIAL_BAUDRATE)
#   sp.read_timeout=500
#   sp.puts("sggma")
#   p sp.gets()
#   SERIAL_BAUDRATE="115200, 8, 1, 0"
#   SerialPort.new(serial_port, 115200, 8, 1, 0)
else
    require 'serialport'
    if $SERIAL_PORT == nil then
        $SERIAL_PORT ='/dev/ttyUSB0'
        print "Replace SERIAL_PORT"
    end
    $SERIAL_BAUDRATE=115200
end

rate50  = {24 => "920600000",33 => "922400000",36 => "923000000",39=>"923600000",40=> "923800000",41=>"924000000",43 => "924400000",61 => "928000000" }
rate100 = {24 => "920700000",33 => "922500000",36 => "923100000",39=>"923700000",40=> "923900000",41=>"924100000",42 => "924300000",60 => "927900000" }
$frq = {50 => rate50, 100 => rate100}

class Subghz

	def setup(ch, rate, mode)
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("sgi")
		p sp.gets()
		sp.puts("sgb," + ch.to_s + ",0xabcd," + rate.to_s + "," + mode.to_s)
		p sp.gets()
		sp.close
	end

	def txon
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("rfw 8 0x6c 0x09")
		p sp.gets()
		sp.close
	end

	def trxoff
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("rfw 8 0x6c 0x08")
		p sp.gets()
		sp.close
	end

	def rxon
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("rfw 8 0x6c 0x06")
		p sp.gets()
		sp.close
	end

	def com(s)
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts(s)
		val = sp.gets()
		sp.close
		return val
	end

	def rr(addr)
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("rfr " + addr)
		val = sp.gets().split(",")
		sp.close
		return val[val.size - 1]
	end

	def rw(addr,data)
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("rfw " + addr.to_s + data.to_s)
		p sp.gets()
		sp.close
	end

	def wf()
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		payload = "Welcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductor"
		sp.puts("w," + payload)
		sp.close
	end

	def ra
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("sggma")
		val = sp.gets().split(",")
		sp.close
		return val
	end

	def mod(val)
		sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
		sp.read_timeout=500
		if val then
			sp.puts("rfw " + "8 0x0c " + "0x03")
		else
			sp.puts("rfw " + "8 0x0c " + "0x00")
		end
		p sp.gets()
		sp.close
	end
end
