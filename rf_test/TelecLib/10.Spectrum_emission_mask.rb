#!/usr/bin/ruby

#
# ��߸��ѴЯ���Ͻ�
#

require '/home/pi/test920j/rf_test/socket.rb'
require '/home/pi/test920j/rf_test/subghz.rb'

#setup DUT --------------------------------------
class Telectp::Test

	def _10_Spectrum_emission_mask
#	    mas(50,24)
#	m   as(100,42)
		val = _10_mas(50,61)
        return val
	end

	def _10_mas(ra,ch)
        begin
		    sbg = Subghz.new()
            sbg.setup(ch, ra, POW)
            sbg.mod(1)
            sbg.txon()

    #setup TESTER --------------------------------------
            pow = {20 => "13", 1 => "0"}
            band= {50 => "200", 100 => "400"}

            $sock.puts("INST SPECT")    
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

            $sock.puts("INIT:CONT OFF")                             #�A���|����OFF�ݒ�
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("FREQ:CENT " + $frq[ra][ch])                #���S���g����ݒ�
            $sock.puts("*OPC?")  
            $sock.gets

            $sock.puts("SEM:BAND:CHAN " + band[ra] + "KHZ")                      #Channel BW���`���l���ш敝�~�L�����A���ɐݒ�   �`���l���ш敝�͎������g�����画�肷��
            $sock.puts("*OPC?")    
            $sock.gets

    #		when useing to 100kbps
    #		$sock.puts("SEM:OFFS:LIST:STAR:ABS1 " + pow[POW] + "DBM,-36DBM,0,0,0,0")                           #Limit Start���x����ݒ�
            $sock.puts("SEM:OFFS:LIST:STAR:ABS1 0DBM,-36DBM,0,0,0,0")                           #Limit Start���x����ݒ�
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:STOP:ABS1 -36DBM,-36DBM,0,0,0,0")                         #Limit Stop���x����ݒ�
            $sock.puts("*OPC?")    
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:FREQ:STAR 100KHZ,300KHZ,0HZ,0HZ,0HZ,0HZ")                 #Offset Start���g����ݒ�
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:FREQ:STOP 300KHZ,500KHZ,300KHZ,300KHZ,300KHZ,300KHZ")     #Offset Stop���g����ݒ�
            $sock.puts("*OPC?")    
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:STAT ON,ON,OFF,OFF,OFF,OFF")                              #Offset ��ON�ɐݒ�
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("SEM:LOG:OFFS:LIST:TEST ABS,ABS,ABS,ABS,ABS,ABS")                        #Offset�̔�����@��ABS(��Βl)�ɐݒ�
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("SEM:BAND 100KHZ")                           #RBW�ݒ�    ���̗�ł�RBW=100kHz�ɐݒ�
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("SEM:BAND:VID 100KHZ")                       #VBW�ݒ�    ���̗�ł�VBW=100kHz�ɐݒ�
            $sock.puts("*OPC?")    
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:BAND 100KHZ,100KHZ,100KHZ,100KHZ,100KHZ,100KHZ")          #RBW�ݒ�iOffset���j
            $sock.puts("*OPC?")  
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:BAND:VID 100KHZ,100KHZ,100KHZ,100KHZ,100KHZ,100KHZ")      #VBW�ݒ�iOffset���j
            $sock.puts("*OPC?")  
            $sock.gets

            $sock.puts("SEM:SWE:TIME:AUTO ON")                      #��p���[���莞�̑|�����Ԃ������ݒ�ɂ���
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:SWE:TIME:AUTO ON,ON,ON,ON,ON,ON")                         #�|������ Auto or Manual�̔���Ɛݒ�ioffset�j
            $sock.puts("*OPC?")  
            $sock.gets

            $sock.puts("SEM:DET POS")                               #���g���[�h��ݒ�   ���̗�ł̓|�W�e�B�u�s�[�N�ɐݒ�
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("SEM:OFFS:LIST:DET POS,POS,POS,POS,POS,POS") #�I�t�Z�b�g�̌��g������ݒ� ���̗�ł̓|�W�e�B�u�s�[�N�ɐݒ�
            $sock.puts("*OPC?")    
            $sock.gets

            $sock.puts("TRAC1:STOR:MODE MAXH")                      #�\�����[�h���}�b�N�X�z�[���h�ݒ�
            $sock.puts("*OPC?")    
            $sock.gets

            $sock.puts("AVER:COUN 10")                              #�|���񐔂̐ݒ� ���̗�ł͕��ω񐔂��P�O��ɐݒ�
            $sock.puts("*OPC?")
            $sock.gets

    #		when useing to 100kbps
    #		$sock.puts("DISP:WIND:TRAC:Y:RLEV " + pow[POW])         #Reference Level    ���̗�ł̓��t�@�����X���x����0dBm�ɐݒ�
            $sock.puts("DISP:WIND:TRAC:Y:RLEV 0")                   #Reference Level    ���̗�ł̓��t�@�����X���x����0dBm�ɐݒ�
            $sock.puts("*OPC?") 
            $sock.gets

            $sock.puts("CONF:SEM")                                  #Spurious Emmision Mask�����ON����
            $sock.puts("*OPC?")    
            $sock.gets

            $sock.puts("SEM:RAC ON")                                #Reference Level ��Attenuator �̐ݒ苤�L��On �ɂ���"
            $sock.puts("*OPC?")  
            $sock.gets

            $sock.puts(":READ:SEMask?")                             #���茋�ʂ�ǂݍ���
            $sock.puts("*OPC") 

            $sock.puts("FETC:SEM?")                                #Spectrum Emission ����̑��茋�ʂ��擾
            $sock.puts("*OPC?")
            r = $sock.gets.split(",")

            sleep 2
            sbg.trxoff()

            i=0
            $log.info("+++++++++++ SUMMARY ++++++++++")
            $log.info("Subject: 10 Spectrum emission mask")
            $log.info(sprintf("Reference power: %s\n",r[1]))
            $log.info(sprintf("%-16s %-16s %-16s %-16s %-16s %-16s","Lower peak","Lower margin","Lower frequency","Upper peak"," Upper margin","Upper frequency"))
            $log.info(sprintf("%-16s %-16s %-16s %-16s %-16s %-16s",r[i+=2],r[i+=1],r[i+=1],r[i+=2],r[i+=1],r[i+=1]))
            $log.info(sprintf("%-16s %-16s %-16s %-16s %-16s %-16s",r[i+=2],r[i+=1],r[i+=1],r[i+=2],r[i+=1],r[i+=1]))
            if r[0].to_i == 1 then
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
