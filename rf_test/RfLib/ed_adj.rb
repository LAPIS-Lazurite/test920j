#! /usr/bin/ruby

require '/home/pi/test920j/rf_test/socket.rb'
require "serialport"

$finish_flag=0
Signal.trap(:INT){
	$finish_flag=1
}

class Rftp::Test

	def sel_dev
		sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) 
		sp.puts("sgi")
		sp.gets()
		sleep 0.1
		sp.puts("erd 0xa0 1")
		val = sp.gets()
		sel = val[11,1]
		p sel
		sp.close
		if sel == "5" then
			$RF = "ML7396"
		else
			$RF = "ML7404"
		end

		if $RF == "ML7396" then
			@@com_ed_val = "rfr 8 0x16"
			@@com_set_rf_status = "rfw 8 0x6c 0x06"
			@@com_get_rf_status = "rfr 8 0x6c"
			@@com_get_gain_ml = "rfr 8 0x1c"
			@@com_get_gain_lm = "rfr 8 0x1d"
			@@com_get_gain_hm = "rfr 8 0x1e"
			@@com_get_gain_mh = "rfr 8 0x1f"
			@@com_get_lna_gain_adj_m = "rfr 9 0x49"
			@@com_get_lna_gain_adj_l = "rfr 9 0x4a"
			@@com_get_mix_gain_adj_m = "rfr 9 0x4e"
			@@com_get_mix_gain_adj_l = "rfr 9 0x4f"
			@@com_get_rssi_adj_m = "rfr 8 0x20"
			@@com_get_rssi_adj_l = "rfr 8 0x21"
			@@com_get_rssi_val_adj = "rfr 8 0x23"
		else # ML7404
			@@com_ed_val = "rfr 0 0x3a"
			@@com_set_rf_status = "rfw 0 0x0b 0x06"
			@@com_get_rf_status = "rfr 0 0x0b"
			@@com_get_gain_lm = "rfr 2 0x7b"
			@@com_get_gain_ml = "rfr 2 0x7a"
			@@com_get_gain_mh = "rfr 2 0x79"
			@@com_get_gain_hm = "rfr 2 0x78"
			@@com_get_gain_h_hh = "rfr 2 0x77"
			@@com_get_gain_hh_h = "rfr 2 0x76"
			@@com_get_rssi_adj_h = "rfr 2 0x7c"
			@@com_get_rssi_adj_m = "rfr 2 0x7d"
			@@com_get_rssi_adj_l = "rfr 2 0x7e"
			@@com_get_rssi_adj = "rfr 0 0x66"
			@@com_get_rssi_mag_adj = "rfr 1 0x13"
			# ML7404 set command
			@@com_set_gain_lm = "rfw 2 0x7b "
			@@com_set_gain_ml = "rfw 2 0x7a 0x8c"
			@@com_set_gain_mh = "rfw 2 0x79"
			@@com_set_gain_hm = "rfw 2 0x78 0x8c"
			@@com_set_gain_h_hh = "rfw 2 0x77"
			@@com_set_gain_hh_h = "rfw 2 0x76 0x8c"
			@@com_set_rssi_adj_h = "rfw 2 0x7c 0x2a"
			@@com_set_rssi_adj_m = "rfw 2 0x7d 0x52"
			@@com_set_rssi_adj_l = "rfw 2 0x7e 0x7f"
			@@com_set_rssi_adj = "rfw 0 0x66 0x2b" #0x00
			@@com_set_rssi_mag_adj = "rfw 1 0x13 0x10" # 0x0f 0x0d
		end
	end

	def rf_setting
			if $RF == "ML7404" then
				$sp.puts(@@com_set_gain_ml)
				p $sp.gets()
				$sp.puts(@@com_set_gain_hm)
				p $sp.gets()
				$sp.puts(@@com_set_gain_hh_h)
				p $sp.gets()
				$sp.puts(@@com_set_rssi_adj_h)
				p $sp.gets()
				$sp.puts(@@com_set_rssi_adj_m)
				p $sp.gets()
				$sp.puts(@@com_set_rssi_adj_l)
				p $sp.gets()
				$sp.puts(@@com_set_rssi_adj)
				p $sp.gets()
				$sp.puts(@@com_set_rssi_mag_adj)
				p $sp.gets()
			end
	end

	def rf_read
			$sp.puts(@@com_get_gain_ml)
			p $sp.gets()
			$sp.puts(@@com_get_gain_lm)
			p $sp.gets()
			$sp.puts(@@com_get_gain_hm)
			p $sp.gets()
			$sp.puts(@@com_get_gain_mh)
			p $sp.gets()
			if $RF == "ML7396" then
				$sp.puts(@@com_get_lna_gain_adj_m)
				p $sp.gets()
				$sp.puts(@@com_get_lna_gain_adj_l)
				p $sp.gets()
				$sp.puts(@@com_get_mix_gain_adj_m)
				p $sp.gets()
				$sp.puts(@@com_get_mix_gain_adj_l)
				p $sp.gets()
				$sp.puts(@@com_get_rssi_adj_m)
				p $sp.gets()
				$sp.puts(@@com_get_rssi_adj_l)
				p $sp.gets()
				$sp.puts(@@com_get_rssi_val_adj)
				p $sp.gets()
		else
				$sp.puts(@@com_get_gain_h_hh)
				p $sp.gets()
				$sp.puts(@@com_get_gain_hh_h)
				p $sp.gets()
				$sp.puts(@@com_get_rssi_adj_h)
				p $sp.gets()
				$sp.puts(@@com_get_rssi_adj_m)
				p $sp.gets()
				$sp.puts(@@com_get_rssi_adj_l)
				p $sp.gets()
				$sp.puts(@@com_get_rssi_adj)
				p $sp.gets()
				$sp.puts(@@com_get_rssi_mag_adj)
				p $sp.gets()
		end
	end

	def subghz_setting
			$sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) 
			sleep 0.1
			$sp.puts("sgi")
			p $sp.gets()
			sleep 0.1
			$sp.puts("sgb 42 0xabcd 100 20")
			p $sp.gets()
			sleep 0.1
			$sp.puts(@@com_set_rf_status)
			p $sp.gets()
			sleep 0.1
			$sp.puts(@@com_get_rf_status)
			p $sp.gets()
			sleep 0.1
	end

	def ms2830a_setting 
			ch = 42
			rate = 100
			offset = [0, -100000, 100000]

			# setup SPA
			$sock.puts("*RST")
			$sock.puts("*OPC?")
			$sock.gets

			$sock.puts("inst spect")
			$sock.puts("*OPC?")
			$sock.gets

			$sock.puts("spf 10mhz")
			$sock.puts("*OPC?")
			$sock.gets

			$sock.puts("rlv 0")
			$sock.puts("*OPC?")
			$sock.gets

			$sock.puts("cnf " + $frq[rate][ch].to_s)
			$sock.puts("*OPC?")
			$sock.gets

			# setup SG
			$sock.puts("inst sg")
			$sock.puts("*OPC?")
			$sock.gets

			$sock.puts("outp 1") 				#SG out 1:ON  0:OFF
			$sock.puts("*OPC?")
			$sock.gets

			$sock.puts("freq " + ($frq[rate][ch].to_i + offset[0]).to_s)
			$sock.puts("*OPC?")
			$sock.gets
	end

	def att_checker
			ms2830a_setting()
			$sock.puts("pow 0")
			$sock.puts("*OPC?")
			p $sock.gets
			$sock.puts("INST SPECT")
			$sock.puts("*OPC?")
			$sock.gets
			$sock.puts("mkpk")
			$sock.puts("*OPC?")
			$sock.gets
			$sock.puts("mkl?")
			val = $sock.gets.delete("-\r\n")
			return val 
	end

	def ed_adj()
			sel_dev()
			att = att_checker()
			ms2830a_setting()
			subghz_setting()
			rf_setting()
			rf_read()
			sg_pow_level = att.to_i
			max_ed = 0

			while $finish_flag == 0 do
				$sock.puts("pow " + sg_pow_level.to_s)
				$sock.puts("*OPC?")
				$sock.gets
				$sock.puts("pow?")
				pw = $sock.gets.delete("\r\n") 

				$sp.puts(@@com_ed_val) # dummy
				val = $sp.gets()
				$sp.puts(@@com_ed_val)
				val = $sp.gets()
				ed = val[11,4]

				printf("pow=%s dBm, ed=%s\n",pw,ed)

				if max_ed == 0 then
					max_ed = ed
				end

				if ed.to_s =~ /0x0\r/ then
					break
				end

				sg_pow_level = sg_pow_level.to_i - 2
				sleep 0.5
			end
			$sp.close

			printf("-------- summary ----------\n")
			printf("ATTENETA: %s\n",att.to_s)
			printf("MAX: pow=%s  ed=%s\n",att.to_s,max_ed.to_s)
			printf("MIN: pow=%s  ed=%s\n",sg_pow_level.to_s,ed.to_s)
	end

end
