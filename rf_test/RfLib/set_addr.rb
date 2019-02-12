#! /usr/bin/ruby

require '/home/pi/test920j/rf_test/subghz.rb'


class Rftp::Test
	def set_addr
        sbg = Subghz.new()

        sbg.com("ewp 0")

		print("\n")
#       print("Fly:  0x001D12D00400001E <-> 0x001D12D004003FFF\n")
#       print("Mini: 0x001D12D004004000 <-> 0x001D12D004007FFF\n")
#		print("Please input an address using a bar-code reader:")
		print("個体識別コードをバーコードリーダーで読み取って下さい：")
        val = gets()
        cmd = "ewr 32 0x" + val[0,2]
        p sbg.com(cmd)
        cmd = "ewr 33 0x" + val[2,2]
        p sbg.com(cmd)
        cmd = "ewr 34 0x" + val[4,2]
        p sbg.com(cmd)
        cmd = "ewr 35 0x" + val[6,2]
        p sbg.com(cmd)
        cmd = "ewr 36 0x" + val[8,2]
        p sbg.com(cmd)
        cmd = "ewr 37 0x" + val[10,2]
        p sbg.com(cmd)
        cmd = "ewr 38 0x" + val[12,2]
        p sbg.com(cmd)
        cmd = "ewr 39 0x" + val[14,2]
        p sbg.com(cmd)
#       print("Input own addres LSB 16bits (ex:10 0A)= ")
#       val = gets().split(" ")
#       cmd = "ewr 38 0x" + val[0].to_s
#       p sbg.com(cmd)	#short addr H
#       cmd = "ewr 39 0x" + val[1].to_s
#       p sbg.com(cmd)	#short addr L

		$log.info("+++++++++++ SUMMARY ++++++++++\n")
		$log.info("Subject: read eeprom\n")
        $log.info(sbg.com("erd 0 32"))
        $log.info(sbg.com("erd 32 32"))
        $log.info(sbg.com("erd 64 32"))
        $log.info(sbg.com("erd 96 32"))
        $log.info(sbg.com("erd 128 32"))
        $log.info(sbg.com("erd 160 32"))
        $log.info(sbg.com("erd 192 32"))
        $log.info(sbg.com("erd 224 32"))
        $log.info(sbg.com("erd 256 32"))

		printf("++++++++++++++++++++++++++++++++++++++++++++\n")
		printf("  下6桁が %s のシールを貼ってください \n",val[10,6])
		printf("++++++++++++++++++++++++++++++++++++++++++++\n")

        sbg.com("ewp 1")

        return val[10,6] 
    end
end
