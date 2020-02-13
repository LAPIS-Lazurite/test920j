#! /usr/bin/ruby

require '/home/pi/test920j/rf_test/subghz.rb'
require 'serialport'

class Rftp::Test

	def command
        while 1
            print("input command[exit:Enter]: ")
            s = gets().to_s
            if s.eql?("\n") == true then
                break
            else
                sbg = Subghz.new()
                p sbg.com(s)
            end
        end
	end

	def set_command(dev_sel)
		if dev_sel == "ML7396" then
			$com_set_trxoff = "rfw 8 0x6c 0x03"
			$com_ed_val = "rfr 8 0x16"
			$com_set_rx_status = "rfw 8 0x6c 0x06"
			$com_set_tx_status = "rfw 8 0x6c 0x09"
			$com_get_rf_status = "rfr 8 0x6c"
			$com_get_gain_ml = "rfr 8 0x1c"
			$com_get_gain_lm = "rfr 8 0x1d"
			$com_get_gain_hm = "rfr 8 0x1e"
			$com_get_gain_mh = "rfr 8 0x1f"
			$com_get_lna_gain_adj_m = "rfr 9 0x49"
			$com_get_lna_gain_adj_l = "rfr 9 0x4a"
			$com_get_mix_gain_adj_m = "rfr 9 0x4e"
			$com_get_mix_gain_adj_l = "rfr 9 0x4f"
			$com_get_rssi_adj_m = "rfr 8 0x20"
			$com_get_rssi_adj_l = "rfr 8 0x21"
			$com_get_rssi_val_adj = "rfr 8 0x23"
		else
			# ML7404 get command
			$com_ed_val = "rfr 0 0x3a"
			$com_set_rx_status = "rfw 0 0x0b 0x06"
			$com_set_tx_status = "rfw 0 0x0b 0x09"
			$com_get_rf_status = "rfr 0 0x0b"
			$com_get_gain_lm = "rfr 2 0x7b"
			$com_get_gain_ml = "rfr 2 0x7a"
			$com_get_gain_mh = "rfr 2 0x79"
			$com_get_gain_hm = "rfr 2 0x78"
			$com_get_gain_h_hh = "rfr 2 0x77"
			$com_get_gain_hh_h = "rfr 2 0x76"
			$com_get_rssi_adj_h = "rfr 2 0x7c"
			$com_get_rssi_adj_m = "rfr 2 0x7d"
			$com_get_rssi_adj_l = "rfr 2 0x7e"
			$com_get_rssi_adj = "rfr 0 0x66"
			$com_get_rssi_mag_adj = "rfr 1 0x13"
			# ML7404 get freq_adj
			$com_get_freq_adj_h = "rfr 1 0x42"
			$com_get_freq_adj_l = "rfr 1 0x43"
			# ML7404 set command
			$com_set_gc_ctrl = "rfw 1 0x15 0x86"
			$com_set_gain_lm = "rfw 2 0x7b 0x3c"			# 50kbps only
			$com_set_gain_ml = "rfw 2 0x7a 0x8c"
			$com_set_gain_mh = "rfw 2 0x79 0x3c"			# 50kbps only
			$com_set_gain_hm = "rfw 2 0x78 0x8c"
			$com_set_gain_h_hh = "rfw 2 0x77 0x3c"		# 50kbps only
			$com_set_gain_hh_h = "rfw 2 0x76 0x8c"
			$com_set_rssi_adj_h = "rfw 2 0x7c "
			$com_set_rssi_adj_m = "rfw 2 0x7d "
			$com_set_rssi_adj_l = "rfw 2 0x7e "
			$com_set_rssi_adj = "rfw 0 0x66 "
			$com_set_rssi_mag_adj = "rfw 1 0x13 "
			# ML7404 set freq_adj
			$com_set_freq_adj_h = "rfw 1 0x42 "
			$com_set_freq_adj_l = "rfw 1 0x43 "
		end
	end

	def rf_setting(rate,dev)
			$sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) 
			if dev == "ML7404" then
				# gc_ctrl setting
				$sp.puts($com_set_gc_ctrl)
				p $sp.gets()
				# gain setting
				$sp.puts($com_set_gain_ml)
				p $sp.gets()
				$sp.puts($com_set_gain_hm)
				p $sp.gets()
				$sp.puts($com_set_gain_h_hh)
				p $sp.gets()
				if rate == 50 then
					$sp.puts($com_set_gain_lm)
					p $sp.gets()
					$sp.puts($com_set_gain_mh)
					p $sp.gets()
					$sp.puts($com_set_gain_hh_h)
					p $sp.gets()
				end

				# rssi adjustment
				if rate == 100 then
					$sp.puts($com_set_rssi_adj_h + "0x2a")
					p $sp.gets()
					$sp.puts($com_set_rssi_adj_m + "0x52")
					p $sp.gets()
					$sp.puts($com_set_rssi_adj_l + "0x7f")
					p $sp.gets()
					$sp.puts($com_set_rssi_adj + $RSSI_ADJ_100K)
					p $sp.gets()
					$sp.puts($com_set_rssi_mag_adj + $RSSI_MAG_ADJ_100K)
					p $sp.gets()
				else
					$sp.puts($com_set_rssi_adj_h + "0x2f")
					p $sp.gets()
					$sp.puts($com_set_rssi_adj_m + "0x55")
					p $sp.gets()
					$sp.puts($com_set_rssi_adj_l + "0x7f")
					p $sp.gets()
					$sp.puts($com_set_rssi_adj + $RSSI_ADJ_50K)
					p $sp.gets()
					$sp.puts($com_set_rssi_mag_adj + $RSSI_MAG_ADJ_50K)
					p $sp.gets()
				end
			end 
			$sp.close
	end

	def rf_getting(dev)
			$sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) 
			$sp.puts($com_get_gain_ml)
			p $sp.gets()
			$sp.puts($com_get_gain_lm)
			p $sp.gets()
			$sp.puts($com_get_gain_hm)
			p $sp.gets()
			$sp.puts($com_get_gain_mh)
			p $sp.gets()
			if dev == "ML7396" then
				$sp.puts($com_get_lna_gain_adj_m)
				p $sp.gets()
				$sp.puts($com_get_lna_gain_adj_l)
				p $sp.gets()
				$sp.puts($com_get_mix_gain_adj_m)
				p $sp.gets()
				$sp.puts($com_get_mix_gain_adj_l)
				p $sp.gets()
				$sp.puts($com_get_rssi_adj_m)
				p $sp.gets()
				$sp.puts($com_get_rssi_adj_l)
				p $sp.gets()
				$sp.puts($com_get_rssi_val_adj)
				p $sp.gets()
		else
				$sp.puts($com_get_gain_h_hh)
				p $sp.gets()
				$sp.puts($com_get_gain_hh_h)
				p $sp.gets()
				$sp.puts($com_get_rssi_adj_h)
				p $sp.gets()
				$sp.puts($com_get_rssi_adj_m)
				p $sp.gets()
				$sp.puts($com_get_rssi_adj_l)
				p $sp.gets()
				$sp.puts($com_get_rssi_adj)
				p $sp.gets()
				$sp.puts($com_get_rssi_mag_adj)
				p $sp.gets()
		end
		$sp.close
	end
end
