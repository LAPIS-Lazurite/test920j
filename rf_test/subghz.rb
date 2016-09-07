#! /usr/bin/ruby

require 'serialport'

SERIAL_PORT ='/dev/ttyUSB0'
SERIAL_BAUDRATE=115200

class Subghz

	def setup(ch, rate, mode)
		sp = SerialPort.new(SERIAL_PORT,SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("sgi")
		p sp.gets()
		sp.puts("sgb," + ch.to_s + ",0xabcd," + rate.to_s + "," + mode.to_s)
		p sp.gets()
		sp.close
	end

	def txon
		sp = SerialPort.new(SERIAL_PORT,SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("rfw 8 0x6c 0x09")
		p sp.gets()
		sp.close
	end

	def trxoff
		sp = SerialPort.new(SERIAL_PORT,SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("rfw 8 0x6c 0x08")
		p sp.gets()
		sp.close
	end

	def rxon
		sp = SerialPort.new(SERIAL_PORT,SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("rfw 8 0x6c 0x08")
		p sp.gets()
		sp.close
	end

	def com(s)
		sp = SerialPort.new(SERIAL_PORT,SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts(s)
		val = sp.gets()
		sp.close
		return val
	end

	def rr(addr)
		sp = SerialPort.new(SERIAL_PORT,SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("rfr " + addr)
		val = sp.gets().split(",")
		sp.close
		return val[val.size - 1]
	end

	def rw(addr,data)
		sp = SerialPort.new(SERIAL_PORT,SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("rfw " + addr.to_s + data.to_s)
		p sp.gets()
		sp.close
	end

	def wf(payload)
		sp = SerialPort.new(SERIAL_PORT,SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("w," + payload)
	end

	def ra
		sp = SerialPort.new(SERIAL_PORT,SERIAL_BAUDRATE)
		sp.read_timeout=500
		sp.puts("sggma")
		val = sp.gets().split(",")
		sp.close
		return val
	end

end
