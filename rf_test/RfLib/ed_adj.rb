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
		printf("sel_dev: %s\n",sel)
		sp.close
		if sel == "5" then
			rf = "ML7396"
		else
			rf = "ML7404"
		end
		return rf
	end

	def set_command
		if $RF == "ML7396" then
			@@com_set_trxoff = "rfw 8 0x6c 0x03"
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
		else
			# ML7404 get command
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
			@@com_set_gc_ctrl = "rfw 1 0x15 0x86"
			@@com_set_gain_lm = "rfw 2 0x7b 0x3c"			# 50kbps only
			@@com_set_gain_ml = "rfw 2 0x7a 0x8c"
			@@com_set_gain_mh = "rfw 2 0x79	0x3c"			# 50kbps only
			@@com_set_gain_hm = "rfw 2 0x78 0x8c"
			@@com_set_gain_h_hh = "rfw 2 0x77 0x3c"		# 50kbps only
			@@com_set_gain_hh_h = "rfw 2 0x76 0x8c"
			@@com_set_rssi_adj_h = "rfw 2 0x7c "
			@@com_set_rssi_adj_m = "rfw 2 0x7d "
			@@com_set_rssi_adj_l = "rfw 2 0x7e "
			@@com_set_rssi_adj = "rfw 0 0x66 "
			@@com_set_rssi_mag_adj = "rfw 1 0x13 "
		end
	end

	def rf_setting(rate)
			if $RF == "ML7404" then
				# gc_ctrl setting
				$sp.puts(@@com_set_gc_ctrl)
				p $sp.gets()
				# gain setting
				$sp.puts(@@com_set_gain_ml)
				p $sp.gets()
				$sp.puts(@@com_set_gain_hm)
				p $sp.gets()
				$sp.puts(@@com_set_gain_h_hh)
				p $sp.gets()
				if rate == 50 then
					$sp.puts(@@com_set_gain_lm)
					p $sp.gets()
					$sp.puts(@@com_set_gain_mh)
					p $sp.gets()
					$sp.puts(@@com_set_gain_hh_h)
					p $sp.gets()
				end

				# rssi adjustment
				if rate == 100 then
					$sp.puts(@@com_set_rssi_adj_h + "0x2a")
					p $sp.gets()
					$sp.puts(@@com_set_rssi_adj_m + "0x52")
					p $sp.gets()
					$sp.puts(@@com_set_rssi_adj_l + "0x7f")
					p $sp.gets()
					$sp.puts(@@com_set_rssi_adj + "0x90")			# 0x00 -> 0x95 -> 0x93
					p $sp.gets()
					$sp.puts(@@com_set_rssi_mag_adj + "0x0d")	# 0x0d
					p $sp.gets()
				else
					$sp.puts(@@com_set_rssi_adj_h + "0x2f")
					p $sp.gets()
					$sp.puts(@@com_set_rssi_adj_m + "0x55")
					p $sp.gets()
					$sp.puts(@@com_set_rssi_adj_l + "0x7f")
					p $sp.gets()
					$sp.puts(@@com_set_rssi_adj + "0x0f")		# 0x00
					p $sp.gets()
					$sp.puts(@@com_set_rssi_mag_adj + "0x0e")	# 0x0e
					p $sp.gets()
				end
			end #$RF
	end

	def rf_getting
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

	def subghz_setting(ch,rate)
			$sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) 
			sleep 0.1
			$sp.puts("sgi")
			p $sp.gets()
			sleep 0.1
			if $RF == "ML7396" then
					$sp.puts("sgansw,1")
					$sp.gets()
			end
			$sp.puts("sgb " + ch.to_s + " 0xabcd " + rate.to_s + " 20")
			p $sp.gets()
			sleep 0.1
			$sp.puts(@@com_set_rf_status)
			p $sp.gets()
			sleep 0.1
			$sp.puts(@@com_get_rf_status)
			p $sp.gets()
			sleep 0.1
	end

	def ed_adj
			$RF = sel_dev()
			p $RF
			set_command()
			print("--------------< 100kbps >---------------\n")
			ch = 42
			rate = 100
			searching(ch,rate)
#			print("--------------< 50kbps >---------------\n")
#			ch = 43
#			rate = 50
#			searching(ch,rate)
	end

	$BASE_PW_LEVEL = -20
	$LEVEL_STEP = 2

	def searching(ch,rate)
			ms2830a_setting(ch,rate)
			att = att_checker()
		 	subghz_setting(ch,rate)
			rf_setting(rate)
			rf_getting()

			#SG out 1:ON  0:OFF
			$sock.puts("outp 1") 
			$sock.puts("*OPC?")
			$sock.gets

			pw_level = $BASE_PW_LEVEL + att.to_i
			max_pw_level = pw_level
			max_ed = 0
			while $finish_flag == 0 do
				$sock.puts("pow " + pw_level.to_s)
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

				pw_level = pw_level.to_i - $LEVEL_STEP
				sleep 0.5
			end
			$sp.puts("sgi")
			$sp.gets()
			$sp.close

			printf("-------- summary ----------\n")
			printf("CH: %s, Data rate: %s\n",ch,rate)
			printf("ATTENETA(dBm): %s\n",att.to_s)
			printf("MAX(dBm): pow=%s  ed=%s\n",max_pw_level.to_s,max_ed.to_s)
			printf("MIN(dBm): pow=%s  ed=%s\n",pw_level.to_s,ed.to_s)
	end

end
