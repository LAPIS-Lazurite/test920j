#! /usr/bin/ruby

require '/home/pi/test920j/rf_test/socket.rb'
require '/home/pi/test920j/rf_test/subghz.rb'
#require "serialport"

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
			@@com_set_rx_status = "rfw 8 0x6c 0x06"
			@@com_set_tx_status = "rfw 8 0x6c 0x09"
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
			@@com_set_rx_status = "rfw 0 0x0b 0x06"
			@@com_set_tx_status = "rfw 0 0x0b 0x09"
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
			# ML7404 get freq_adj
			@@com_get_freq_adj_h = "rfr 1 0x42"
			@@com_get_freq_adj_l = "rfr 1 0x43"
			# ML7404 set command
			@@com_set_gc_ctrl = "rfw 1 0x15 0x86"
			@@com_set_gain_lm = "rfw 2 0x7b 0x3c"			# 50kbps only
			@@com_set_gain_ml = "rfw 2 0x7a 0x8c"
			@@com_set_gain_mh = "rfw 2 0x79 0x3c"			# 50kbps only
			@@com_set_gain_hm = "rfw 2 0x78 0x8c"
			@@com_set_gain_h_hh = "rfw 2 0x77 0x3c"		# 50kbps only
			@@com_set_gain_hh_h = "rfw 2 0x76 0x8c"
			@@com_set_rssi_adj_h = "rfw 2 0x7c "
			@@com_set_rssi_adj_m = "rfw 2 0x7d "
			@@com_set_rssi_adj_l = "rfw 2 0x7e "
			@@com_set_rssi_adj = "rfw 0 0x66 "
			@@com_set_rssi_mag_adj = "rfw 1 0x13 "
			# ML7404 set freq_adj
			@@com_set_freq_adj_h = "rfw 1 0x42 "
			@@com_set_freq_adj_l = "rfw 1 0x43 "
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
					$sp.puts(@@com_set_rssi_adj + $RSSI_ADJ_100K)
					p $sp.gets()
					$sp.puts(@@com_set_rssi_mag_adj + $RSSI_MAG_ADJ_100K)
					p $sp.gets()
				else
					$sp.puts(@@com_set_rssi_adj_h + "0x2f")
					p $sp.gets()
					$sp.puts(@@com_set_rssi_adj_m + "0x55")
					p $sp.gets()
					$sp.puts(@@com_set_rssi_adj_l + "0x7f")
					p $sp.gets()
					$sp.puts(@@com_set_rssi_adj + $RSSI_ADJ_50K)
					p $sp.gets()
					$sp.puts(@@com_set_rssi_mag_adj + $RSSI_MAG_ADJ_50K)
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

	def subghz_setting(ch,rate,trx)
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
			if trx == "tx" then
				$sp.puts(@@com_set_tx_status)
			else
				$sp.puts(@@com_set_rx_status)
			end
			p $sp.gets()
			sleep 0.1
			$sp.puts(@@com_get_rf_status)
			p $sp.gets()
			sleep 0.1
	end

	$BASE_PW_LEVEL = -20
	$LEVEL_STEP = 2
	$RSSI_ADJ_100K = "0x99"
	$RSSI_MAG_ADJ_100K = "0x0e"
	$RSSI_ADJ_50K = "0x00"
	$RSSI_MAG_ADJ_50K = "0x0e"
	$PA_20_ADJ_H = "0x00"
	$PA_20_ADJ_L = "0xE4"
	$PA_1_ADJ_H = "0x00"
	$PA_1_ADJ_L = "0x2E"

	def rssi_adj
			$RF = sel_dev()
			p $RF
			set_command()

			print("--------------< 100kbps >---------------\n")
			ch = 42
			rate = 100
			searching(ch,rate)
			print("--------------< 50kbps >---------------\n")
			ch = 43
			rate = 50
			searching(ch,rate)

			$sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) 
			$sp.puts(@@com_set_rssi_adj)
			p $sp.gets()
			$sp.puts(@@com_set_rssi_mag_adj)
			p $sp.gets()
			$sp.puts("ewp 0")
			p $sp.gets()
			$sp.puts("erd,0x81,1")
			p $sp.gets()
			$sp.puts("erd,0x82,1")
			p $sp.gets()
			$sp.puts("erd,0x83,1")
			p $sp.gets()
			$sp.puts("erd,0x84,1")
			p $sp.gets()
			$sp.puts("ewr,0x81," + $RSSI_ADJ_100K)
			p $sp.gets()
			$sp.puts("ewr,0x82," + $RSSI_MAG_ADJ_100K)
			p $sp.gets()
			$sp.puts("ewr,0x83," + $RSSI_ADJ_50K)
			p $sp.gets()
			$sp.puts("ewr,0x84," + $RSSI_MAG_ADJ_50K)
			p $sp.gets()
			$sp.puts("erd,0x81,1")
			p $sp.gets()
			$sp.puts("erd,0x82,1")
			p $sp.gets()
			$sp.puts("erd,0x83,1")
			p $sp.gets()
			$sp.puts("erd,0x84,1")
			p $sp.gets()
			$sp.puts("ewp 0")
			p $sp.gets()
			$sp.close
	end

	def searching(ch,rate)
			ms2830a_setting(ch,rate)
			att = att_checker(ch,rate)
		 	subghz_setting(ch,rate,"rx")
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

	def frq_adj(freq_dev)
		printf("Frequency deviation: %s Hz\n",freq_dev)
		p freq_dev
		fadj = (freq_dev.to_f/1000000)
		p fadj.to_f
		freq_adj = fadj.to_f/(36/1)*(2**20).to_i
		p freq_adj.round
		if freq_adj.round > 0 then
			adj_h = "0x80"
		else
			adj_h = "0x00"
		end
		printf("FREQ_ADJ_H:B1 0x42: %s\n",adj_h)
		adj_l = sprintf("%s","%#x"%freq_adj.round.abs)
		printf("FREQ_ADJ_L:B1 0x43: %s\n",adj_l)
		$sp.puts(@@com_get_freq_adj_h)
		p $sp.gets()
		$sp.puts(@@com_get_freq_adj_l)
		p $sp.gets()
		$sp.puts(@@com_set_freq_adj_h + adj_h)
		p $sp.gets()
		$sp.puts(@@com_set_freq_adj_l + adj_l)
		p $sp.gets()
		$sp.puts("ewp 0")
		p $sp.gets()
		$sp.puts("erd,0x85,1")
		p $sp.gets()
		$sp.puts("erd,0x86,1")
		p $sp.gets()
		$sp.puts("ewr,0x85," + adj_h)
		p $sp.gets()
		$sp.puts("ewr,0x86," + adj_l)
		p $sp.gets()
		$sp.puts("erd,0x85,1")
		p $sp.gets()
		$sp.puts("erd,0x86,1")
		p $sp.gets()
		$sp.puts("ewp 1")
		p $sp.gets()
	end

	def pow_adj_4k
		$sp.puts("rfw,0,0x67," + $PA_20_ADJ_H)
		p $sp.gets()
		$sp.puts("rfw,0,0x68," + $PA_20_ADJ_L)
		p $sp.gets()
		print("Check 20mW power mode::")
		gets().to_i
		$sp.puts("rfw,0,0x67," + $PA_1_ADJ_H)
		p $sp.gets()
		$sp.puts("rfw,0,0x68," + $PA_1_ADJ_L)
		p $sp.gets()
		print("Check 1mW power mode::")
		gets().to_i

		$sp.puts("ewp 0")
		p $sp.gets()
		$sp.puts("erd,0x29,1")
		p $sp.gets()
		$sp.puts("erd,0x2A,1")
		p $sp.gets()
		$sp.puts("erd,0x2B,1")
		p $sp.gets()
		$sp.puts("erd,0x2C,1")
		p $sp.gets()

		$sp.puts("ewr,0x29," + $PA_20_ADJ_H)
		p $sp.gets()
		$sp.puts("ewr,0x2A," + $PA_20_ADJ_L)
		p $sp.gets()
		$sp.puts("ewr,0x2B," + $PA_1_ADJ_H)
		p $sp.gets()
		$sp.puts("ewr,0x2C," + $PA_1_ADJ_L)
		p $sp.gets()

		$sp.puts("erd,0x29,1")
		p $sp.gets()
		$sp.puts("erd,0x2A,1")
		p $sp.gets()
		$sp.puts("erd,0x2B,1")
		p $sp.gets()
		$sp.puts("erd,0x2C,1")
		p $sp.gets()
		$sp.puts("ewp 1")
		p $sp.gets()
	end
end
