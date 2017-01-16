#!/usr/bin/ruby
#
# �󒆐��d�́i���ϓd�́j
#

require './socket.rb'
require './subghz.rb'

#setup DUT --------------------------------------

class Telectp::Test

	def _04_Antenna_power_ave(att)
        _04_mas(100,24,att)
        _04_mas(100,42,att)
        _04_mas(100,60,att)
    end

    def _04_mas(rate,ch,att)
        sbg = Subghz.new()
        sbg.setup(ch, rate, POW)
        sbg.wf()

#setup TESTER --------------------------------------
        @@ATT = att.to_f.round(2)
        $sock.puts("INST SPECT")                                #SA���[�h�ł͉��L�̃R�}���h���g�p   INST SIGANA"
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("SYST:PRES")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("syst:lang scpi")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS:STAT ON")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS 0")
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("INIT:CONT OFF")                             #�A���|��OFF�ݒ�
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("FREQ:CENT " + $frq[rate][ch])                          #���S���g���ݒ�     ���̗�ł͒��S���g����920MHz�ɐݒ�
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("FREQ:SPAN 500KHZ")                          #SPAN�ݒ�   ���̗�ł�Span=500kHz�ɐݒ�
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("BAND 1MHZ")                                 #RBW�ݒ�    ���̗�ł�RBW=1MHz�ɐݒ�
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("BAND:VID 3MHZ")                             #VBW�ݒ�    SA���[�h�ł͎g�p���Ȃ�  ���̗�ł�VBW=1MHz�ɐݒ�
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("SWE:POIN 1001")                             #�g���[�X�|�C���g�ݒ�   SA���[�h�ł͎g�p���Ȃ�  ���̗�ł�1001�|�C���g�ɐݒ�
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("DET SAMP")                                  #���g���[�h�ݒ�     ���̗�ł̓|�W�e�B�u�s�[�N�ɐݒ�
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("BPOW ON")                                   #BurstAveragePower�����ON�ɐݒ�
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("SWE:TIME 5.46MS")                           #SweepTime��ݒ�    SA���[�h�ł͉��L�R�}���h�ɕύX  CALC:ATIM:LENG 2MS  ���̗�ł�Sweep Time��5.46s�ɐݒ�
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("TRIG:EXT:SLOP POS")                         #�g���K�̃G�b�W��ݒ肷��   SA���[�h�ł͉��L�R�}���h���g�p  TRIG:SLOP POS   ���̗�ł͗����オ��G�b�W�ɐݒ肷��
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("TRIG:VID:LEV -40DBM")                       #TriggerLevel�ݒ�   ���̗�ł̓g���K���x����-40dBm�ɐݒ肷��B
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("TRIG ON")                                   #TriggerSwitch�ݒ�
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("BPOW:BURS:STAR 0S")                         #StartTime�ݒ�  SA���[�h�ł͉��L�R�}���h���g�p  CALC:ATIM:STAR 0S   ���̗�ł�Start Time��0s�ɐݒ肷��"
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("SWE:TIME:AUTO:MODE FAST")                   #�|�����[�h�ݒ�     SA���[�h�ł͎g�p���Ȃ�  ���̗�ł͑|�����[�h��fast�ɐݒ肷��
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                #���t�@�����X���x���ݒ�(dBm)    ���̗�ł̓��t�@�����X���x����-10dBm�ɐݒ肷��B
        $sock.puts("*OPC?")
        $sock.gets

#$sock.puts(":UNIT:POWer W")                             #�\����W�ɕϊ�
        $sock.puts(":UNIT:POWer DBM")                             #�\����W�ɕϊ�
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("CALC:MARK:MODE OFF")                        #�}�[�J�[OFF�ݒ�
        $sock.puts("*OPC?")
        $sock.gets

#$sock.puts("INIT:MODE:SING")                            #SA���[�h�ł̓g���[�X���[�h��ύX���Ă��炩�炱�̃R�}���h�𑗂�(6�s�����Q��)
#$sock.puts("*OPC?")
#$sock.gets

        $sock.puts("TRAC? TRAC1")                               #�g���[�X�f�[�^��ǂݏo��
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("BPOW:BURS:STOP 2.67818181818182MS")         #Burst Average Power ����̏I���ʒu�i���ԁj��ݒ�   SA���[�h�ł͉��L�R�}���h���g�p      TRAC:MODE PVT"
        $sock.puts("*OPC?")
        $sock.gets

        $sock.puts("INIT:MODE:SING")                            #SA���[�h�ł̓g���[�X���[�h��ύX���Ă��炩�炱�̃R�}���h�𑗂�(6�s�����Q��)
        $sock.puts("*OPC?")
        $sock.puts("*WAI")

        for i in 1..10
            p sbg.com("sgs 0xffff 0xffff")
        end

#$sock.puts("INIT:MODE:SING")                             #SA���[�h�ł͖{�R�}���h��}��
#$sock.puts("*OPC?")
#$sock.gets

        $sock.puts("FETC:BPOW?")                                #BurstAveragePower�̑��茋�ʂ�ǂݎ��
        $sock.puts("*OPC?")
        result = $sock.gets.to_f + @@ATT
        p result

        $sock.puts("TRIG OFF")
        $sock.puts("*OPC?")
        $sock.gets

#		$sock.close

        printf("+++++++++++ SUMMARY ++++++++++\n")
        printf("Subject: 04 Antenna power average\n")
        printf("Frequency: %s\n", $frq[rate][ch])
        printf("Attenuate: %d dB\n",@@ATT)
        printf("Result: %3.2f dBm\n",result)
        if result.between?(9,13) == false then
            printf("Judgement: %s\n", "FAIL")
            raise StandardError, "FAIL\n"
        else
            printf("Judgement: %s\n", "PASS")
        end
	end
end
