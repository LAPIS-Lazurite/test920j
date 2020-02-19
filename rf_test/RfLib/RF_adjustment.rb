#! /usr/bin/ruby

require '/home/pi/test920j/rf_test/socket.rb'
require '/home/pi/test920j/rf_test/subghz.rb'

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

	def subghz_setting(ch,rate,trx)
			sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) 
			sleep 0.1
			sp.puts("sgi")
			p sp.gets()
			sleep 0.1
			if $RF == "ML7396" then
					sp.puts("sgansw,1")
					sp.gets()
			end
			sp.puts("sgb " + ch.to_s + " 0xabcd " + rate.to_s + " 20")
			p sp.gets()
			sleep 0.1
			if trx == "tx" then
				sp.puts($com_set_tx_status)
			elsif trx == "rx" then
				sp.puts($com_set_rx_status)
			else
				sp.puts($com_set_trxoff_status)
			end
			p sp.gets()
			sleep 0.1
			sp.puts($com_get_rf_status)
			p sp.gets()
			sleep 0.1
			sp.close
	end

	$BASE_PW_LEVEL = -20
	$LEVEL_STEP = 2
	$RSSI_ADJ_100K = "0x99"
	$RSSI_MAG_ADJ_100K = "0x0e"
	$RSSI_ADJ_50K = "0x00"
	$RSSI_MAG_ADJ_50K = "0x0e"
	$PA_20_ADJ_H = "0x82"
	$PA_20_ADJ_L = "0xE4"
	$PA_1_ADJ_H = "0x80"
	$PA_1_ADJ_L = "0x2E"
	$MAX_PA_20 = 13
	$MAX_PA_1 = 0
	$PA_GAP = 0.5

	def rssi_adj(dev)

			set_command(dev)

			print("--------------< 100kbps >---------------\n")
			ch = 42
			rate = 100
			rssi_searching(ch,rate,dev)
			print("--------------< 50kbps >---------------\n")
			ch = 43
			rate = 50
			rssi_searching(ch,rate,dev)

			sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) 
			sp.puts("ewp 0")
			p sp.gets()
			sp.puts("erd,0x88,1")
			p sp.gets()
			sp.puts("erd,0x89,1")
			p sp.gets()
			sp.puts("erd,0x8a,1")
			p sp.gets()
			sp.puts("erd,0x8b,1")
			p sp.gets()
			sp.puts("ewr,0x88," + $RSSI_ADJ_100K)
			p sp.gets()
			sp.puts("ewr,0x89," + $RSSI_MAG_ADJ_100K)
			p sp.gets()
			sp.puts("ewr,0x8a," + $RSSI_ADJ_50K)
			p sp.gets()
			sp.puts("ewr,0x8b," + $RSSI_MAG_ADJ_50K)
			p sp.gets()
			sp.puts("erd,0x88,1")
			p sp.gets()
			sp.puts("erd,0x89,1")
			p sp.gets()
			sp.puts("erd,0x8a,1")
			p sp.gets()
			sp.puts("erd,0x8b,1")
			p sp.gets()
			sp.puts("ewp 0")
			p sp.gets()
			sp.close
	end

	def rssi_searching(ch,rate,dev)
			ms2830a_setting(ch,rate,100)
			att = att_checker(ch,rate)
		 	subghz_setting(ch,rate,"rx")
			rf_setting(rate,dev)
			rf_getting(dev)

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

				sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) 
				sp.puts($com_ed_val) # dummy
				val = sp.gets()
				sp.puts($com_ed_val)
				val = sp.gets()
				sp.close
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

			printf("-------- summary ----------\n")
			printf("CH: %s, Data rate: %s\n",ch,rate)
			printf("ATTENETA(dBm): %s\n",att.to_s)
			printf("MAX(dBm): pow=%s  ed=%s\n",max_pw_level.to_s,max_ed.to_s)
			printf("MIN(dBm): pow=%s  ed=%s\n",pw_level.to_s,ed.to_s)
			printf("---------------------------\n")
	end

	def freq_dev_adj(ch,rate)
		freq_dev = freq_dev_checker(ch,rate)
		sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) 
		fadj = (freq_dev.to_f/1000000)
		freq_adj = fadj.to_f/(36/1)*(2**20).to_i
		if freq_adj.round > 0 then
			adj_h = "0x80"
		else
			adj_h = "0x00"
		end
		printf("--------------------------------------\n")
		printf("FREQ_ADJ_H:B1 0x42: %s\n",adj_h)
		adj_l = sprintf("%s","%#x"%freq_adj.round.abs)
		printf("FREQ_ADJ_L:B1 0x43: %s\n",adj_l)
		printf("--------------------------------------\n")
		sp.puts($com_get_freq_adj_h)
		p sp.gets()
		sp.puts($com_get_freq_adj_l)
		p sp.gets()
		sp.puts($com_set_freq_adj_h + adj_h)
		p sp.gets()
		sp.puts($com_set_freq_adj_l + adj_l)
		p sp.gets()
		sp.puts("ewp 0")
		p sp.gets()
		sp.puts("erd,0x81,1")
		p sp.gets()
		sp.puts("erd,0x82,1")
		p sp.gets()
		sp.puts("ewr,0x81," + adj_h)
		p sp.gets()
		sp.puts("ewr,0x82," + adj_l)
		p sp.gets()
		sp.puts("erd,0x81,1")
		p sp.gets()
		sp.puts("erd,0x82,1")
		p sp.gets()
		sp.puts("ewp 1")
		p sp.gets()
		sp.close
	end

	def pa_search(ch,rate,mode,att)
		p att

		if mode == 20 then
			adj_h = $PA_20_ADJ_H.to_i(16)
			adj_l = $PA_20_ADJ_L.to_i(16)
			max_pa = $MAX_PA_20
		else
			adj_h = $PA_1_ADJ_H.to_i(16)
			adj_l = $PA_1_ADJ_L.to_i(16)
			max_pa = $MAX_PA_1
		end

		num=0
		while $finish_flag == 0 do
			num=1
			$sock.puts("cnf " + $frq[rate][ch].to_s)
			$sock.puts("*OPC?")
			$sock.gets

			$sock.puts("mkpk")
			$sock.puts("*OPC?")
			$sock.gets

			$sock.puts("mkl?")
			value = $sock.gets

			printf("Pow adj:target:%.2f,meas:%.2f,ATT:%.2f,reg_data:%d,num:%d\n",
						 max_pa, value, att.to_f, adj_l, num)

			if value.to_i + att.to_f < max_pa - $PA_GAP then 
				adj_l = adj_l.to_f + 5
			elsif value.to_i + att.to_f > max_pa + $PA_GAP then 
				adj_l = adj_l.to_f - 5
			else
				p "OK"
				break
			end

			if (adj_l > 255 || adj_l < 0) then
				p "NG"
				break
			end
	
			$sp.puts("rfw,0,0x67," + "%#x"%adj_h)
			p $sp.gets()
			$sp.puts("rfw,0,0x68," + "%#x"%adj_l)
			p $sp.gets()
		end # for

		if mode == 20 then
			$sp.puts("ewr,0x29," + "%#x"%adj_h)
			p $sp.gets()
			$sp.puts("ewr,0x2A," + "%#x"%adj_l)
			p $sp.gets()
		else
			$sp.puts("ewr,0x2B," + "%#x"%adj_h)
			p $sp.gets()
			$sp.puts("ewr,0x2C," + "%#x"%adj_l)
			p $sp.gets()
		end
	end

	def pow_adj_4k(ch,rate,att)
		$sp = SerialPort.new('/dev/ttyUSB0', 115200, 8, 1, 0) 

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

		pa_search(ch,rate,20,att)
		pa_search(ch,rate,1,att)

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

		$sp.close
	end

end
