#!/usr/bin/ruby
#
# ���g���΍��i�ϒ��j�A��L�ш摪��
#
require '/home/pi/test920j/rf_test/socket.rb'
require '/home/pi/test920j/rf_test/subghz.rb'

#setup DUT --------------------------------------
class Telectp::Test
	def _01_Tolerance_of_occupied_bandwidth_Frequency_range
	#	_01_mas(50,24)
	#	_01_mas(50,61)
		val = _01_mas(100,42)
        return val
	end

	def _01_mas(ra,ch)
        begin
            sbg = Subghz.new()
            sbg.setup(ch, ra, POW)
            sbg.mod(1)
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

            $log.info("+++++++++++ SUMMARY ++++++++++")
            $log.info("Subject: 01 Tolerance of occupied bandwidth Frequency rangen")
            $log.info(sprintf("Center Frequencey: %d",frequency))
            $log.info(sprintf("OBW Center: %d",center))
            $log.info(sprintf("OBW Lower: %d",lower))
            $log.info(sprintf("OBW Upper: %d",upper))
            $log.info(sprintf("Deviation: %d",DEV * $frq[ra][ch].to_i))
#           if (frequency - center).abs > (DEV * frequency) then
            if ((upper - lower) < 200000 && (upper - lower) > 170000) then
                $log.info("Judgement: FAIL")
                raise StandardError, "FAIL\n"
            else
                $log.info("Judgement: PASS")
            end
        rescue StandardError
            printf("Error: program stop\n")
            return "Error"
        end
        return nil
	end
end
