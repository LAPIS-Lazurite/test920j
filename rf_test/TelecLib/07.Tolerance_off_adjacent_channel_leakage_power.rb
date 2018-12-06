#!/usr/bin/ruby
#
# �א�����٘R�k�d��
#

require './socket.rb'
require './subghz.rb'

#setup DUT --------------------------------------
class Telectp::Test
	def _07_Tolerance_off_adjacent_channel_leakage_power
#	mas(50,24)
#	mas(50,61)
		val = _07_mas(100,42)
        return val
	end

	def _07_mas(ra, ch)
        begin
            sbg = Subghz.new()
            sbg.setup(ch, ra, POW)
            sbg.mod(1)
            sbg.txon()

            band = {50 =>"200", 100 =>"400"}

    #setup TESTER --------------------------------------
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

            $sock.puts("INIT:CONT OFF")                              #�A���|��OFF�ݒ�
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("FREQ:CENT " + $frq[ra][ch])                          #���S���g���ݒ�
            $sock.puts("*OPC?")
            $sock.gets

    #$sock.puts("FREQ:SPAN 1MHZ")                            #SPAN�ݒ�
            $sock.puts("FREQ:SPAN 1.25MHZ")                            #SPAN�ݒ�
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("BAND 1KHZ")                                 #RBW�ݒ�
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("BAND:VID 3KHZ")                             #VBW�ݒ�    SA���[�h�ł͎g�p���Ȃ�
            $sock.puts("*OPC?")
            $sock.gets
                
            $sock.puts("SWE:POIN 1001")                             #�g���[�X�|�C���g�ݒ�   SA���[�h�ł͎g�p���Ȃ�
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("DET POS")                                   #���g���[�h�ݒ�
            $sock.puts("*OPC?")
            $sock.gets

    #    $sock.puts("TRIG ON")                                   #SA���[�h�ł͖{�R�}���h��ǉ�
    #    $sock.puts("*OPC?")
    #    $sock.gets

    #    $sock.puts("TRIG:VID:LEV -30")                          #SA���[�h�ł͖{�R�}���h��ǉ�
    #    $sock.puts("*OPC?")
    #    $sock.gets

            $sock.puts("TRAC1:STOR:MODE OFF")                       #�\�����[�h�ݒ�     SA���[�h�ł͉��L�R�}���h�ɕύX  TRAC:STOR:MODE OFF"
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SWE:TIME:AUTO:MODE FAST")                   #FAST/NORM      SA���[�h�ł͎g�p���Ȃ�
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("SWE:TIME 5.46s")                            #�|�����Ԃ̐ݒ�     SA���[�h�ł͉��L�R�}���h�ɕύX  CALC:ATIM:LENG 2MS"
            $sock.puts("*OPC?")
            $sock.gets

    #$sock.puts("DISP:WIND:TRAC:Y:RLEV -30")                 #Reference Level
            $sock.puts("DISP:WIND:TRAC:Y:RLEV 0")                 #Reference Level
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("ACP ON")                                    #ACP����ON
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("ACP:CARR:RCAR:METH BSIDes")                 #���΃��x���\���̊��ݒ�
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("ACP:CARR:LIST:WIDT 200000")                 #�L�����A�̎��g���Ԋu��ݒ�
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("ACP:CARR:LIST:BAND " + band[ra].to_s + "KHZ")                 #�L�����A�̑���ш敝��ݒ�
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("ACP:CARR:FILT:TYPE RECT")                   #�L�����A�̃t�B���^��ނ�ݒ�
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("ACP:OFFS:BAND " + band[ra].to_s + "KHZ")                      #Offset Channel �ш敝��ݒ�
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("ACP:OFFS:FILT:TYPE RECT")                   #�I�t�Z�b�g�̃t�B���^��ނ�ݒ�
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("ACP:OFFS:LIST " + band[ra] + "KHZ,0,0")                  #�I�t�Z�b�g�`���l���̃I�t�Z�b�g���g����ݒ�
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("ACP:OFFS:LIST:STAT ON,OFF,OFF")             #�I�t�Z�b�g�`���l����ݒ�
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("INIT:MODE:SING")                            #Single��������s   
            $sock.puts("*OPC?")
            $sock.gets

            $sock.puts("FETC:ACP?")                                 #ACP����l��₢���킹
            $sock.puts("*OPC?")
            result = $sock.gets.split(",")
            p result
            spec = -26
            upper = result[3].to_f
            lower = result[5].to_f

            sbg.trxoff()

            $log.info("+++++++++++ SUMMARY ++++++++++")
            $log.info("Subject: 07 Tolerance off adjacent channel leakage power")
            $log.info(sprintf("Specification: %ddBm less",spec))
            $log.info(sprintf("Upper: %3.2fdBm, Lower: %3.2fdBm",upper,lower))
            if upper > spec || lower > spec then
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
