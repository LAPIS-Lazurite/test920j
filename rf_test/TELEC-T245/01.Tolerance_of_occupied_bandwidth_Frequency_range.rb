#!/usr/bin/ruby
#
# ���g���΍��i�ϒ��j�A��L�ш摪��
#
require '../socket.rb'
require '../subghz.rb'

#setup DUT --------------------------------------
POW = 20
MOD = "0x03"
DEV = 20 * (10**-6)

class Tolera_of_occupied
	def self.mas(ra,ch)
		sbg = Subghz.new()
		sbg.setup(ch, ra, POW)
		sbg.rw("8 0x0c ",MOD)
		sbg.txon()

#setup TESTER --------------------------------------
		$sock.puts("INST SPECT")                                #SA���[�h�ł͉��L�̃R�}���h���g�p  INST SIGANA
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("syst:lang scpi")
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SYST:PRES") 
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS:STAT ON")
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS 0")
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("INIT:CONT ON")                              #�A���|���ݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("FREQ:CENT " + $frq[ra][ch])                #���S���g���ݒ� ���̗�ł͒��S���g����920MHz�ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("FREQ:SPAN 500KHZ")                          #SPAN�ݒ�   ���̗�ł�Span=500kHz�ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("CALC:MARK:MODE OFF")                        #�}�[�J�[OFF�ݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("BAND 1KHZ")                                 #RBW�ݒ�    ���̗�ł�RBW=1kHz�ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("BAND:VID 1KHZ")                             #VBW�ݒ�    SA���[�h�ł͎g�p���Ȃ�  ���̗�ł�VBW=1kHz�ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SWE:POIN 1001")                             #�g���[�X�|�C���g�ݒ�   SA���[�h�ł͎g�p���Ȃ�  ���̗�ł�1001�|�C���g�ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("DET POS")                                   #���g���[�h��ݒ�   ���̗�ł̓|�W�e�B�u�s�[�N�ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("TRAC1:STOR:MODE MAXH")                      #�\�����[�h���}�b�N�X�z�[���h�ݒ�   SA���[�h�ł͉��L�R�}���h���g�p����  TRAC:STOR:MODE MAXH"
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("OBW:METH NPERcent")                         #Method��N%�ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("OBW:PERC 99.00")                            #N% Ratio��99%�ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("AVER:COUN 5")                               #Average�񐔐ݒ�    ���̗�ł̓A�x���[�W�񐔂��T��ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SWE:TIME:AUTO:MODE FAST")                   #�|�����[�h�ݒ� SA���[�h�ł͎g�p���Ȃ�  ���̗�ł͑|�����[�h��fast�ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SWE:TIME 5.46s")                            #�|�����Ԃ̐ݒ� SA���[�h�ł͉��L�R�}���h���g�p����  CALC:ATIM:LENG 2MS  ���̗�ł�5.46s�ɐݒ�"
		$sock.puts("*OPC?")
		$sock.gets

#$sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #Reference Level    ���̗�ł̓��t�@�����X���x����-10dBm�ɐݒ�
		$sock.puts("DISP:WIND:TRAC:Y:RLEV 10")                 #Reference Level    ���̗�ł̓��t�@�����X���x����-10dBm�ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("OBW ON")                                    #Occupied Bandwidth ��������s
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("INIT:MODE:SING")
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("FETC:OBW?")                                 #OBW�A���g���΍��̑��茋�ʖ₢���킹
		$sock.puts("*OPC?")
		result = $sock.gets.split(",")
		center = result[1].to_i
		lower = result[2].to_i
		upper = result[3].to_i
		frequency = $frq[ra][ch].to_i

		sbg.trxoff()

		printf("+++++++++++ SUMMARY ++++++++++\n")
		printf("Subject: Tolerance of occupied bandwidth Frequency rangen]\n")
		printf("Center Frequencey: %d\n",frequency)
		printf("OBW Center: %d\n",center)
		printf("OBW Lower: %d\n",lower)
		printf("OBW Upper: %d\n",upper)
		printf("Deviation: %d\n",DEV * $frq[ra][ch].to_i)
		if (frequency - center).abs > (DEV * frequency) then
			printf("Judgement: %s\n", "FAIL")
			raise StandardError, "FAIL\n"
		else
			printf("Judgement: %s\n", "PASS")
		end
	end
#	mas(50,24)
	mas(100,42)
#	mas(50,61)
	$sock.close
end
