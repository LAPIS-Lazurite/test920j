#!/usr/bin/ruby
#
# ��ر�ݽ�@�\
#

require '../socket.rb'
require '../subghz.rb'

#setup DUT --------------------------------------
CH = 42
RATE = 100
POW = 20
MOD = "0x03"

rate50  = {24 => "920600000",33 => "922400000", 36 => "923000000", 60 => "927800000", 43 => "924400000" }
rate100 = {24 => "920700000",33 => "922500000", 36 => "923100000", 60 => "927900000", 42 => "924300000" }
frq = {50 => rate50, 100 => rate100}

sbg = Subghz.new()
sbg.setup(CH, RATE, POW)
sbg.wf("Welcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductorWelcome_SubGHz_LAPIS_semiconductor")


#setup THREAD --------------------------------------
	snd_thread = Thread.new do
		while 1
			confirm = sbg.com("sgs 0xffff 0xffff")
			p confirm.split(",")
			@status = confirm.split(",")[3]
			if @send_flg == 1 then
				break
			end
		end
	end

	tester_thread = Thread.new do
		@send_flg = 0
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
		
		$sock.puts("INST SG")                                   #�A�N�e�B�u�ȃA�v���P�[�V������SG�ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets
		
		$sock.puts("OUTP OFF")                                  #SG�̃��x���o��OFF
		$sock.puts("*OPC?")
		$sock.gets
		
		$sock.puts("INST SPECT")                                #�A�N�e�B�u�ȃA�v���P�[�V������SPECT�ɐݒ�
		$sock.puts("*OPC?") 
		$sock.gets
		
		$sock.puts("INIT:CONT OFF")                             #�A���|��OFF�ݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("FREQ:CENT " + frq[RATE][CH])                          #���S���g���ݒ� ���̗�ł͒��S���g����920MHz�ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets
		
		$sock.puts("FREQ:SPAN 12.2MHZ")                     #SPAN�ݒ�SA���[�h�ł͉��L�̃R�}���h���g�p   FREQ:SPAN 25MHZ ���̗�ł�Span=12.5MHz�ɐݒ�"
		$sock.puts("*OPC?") 
		$sock.gets
		
		$sock.puts("CALC:MARK:MODE OFF")                        #�}�[�J�[OFF
		$sock.puts("*OPC?") 
		$sock.gets
		
		$sock.puts("BAND 100KHZ")                               #RBW�ݒ�    ���̗�ł�RBW=100kHz�ɐݒ�
		$sock.puts("*OPC?")    
		$sock.gets
			
#		$sock.puts("BAND:VID 300KHZ")                           #VBW�ݒ�    SA���[�h�ł͎g�p���Ȃ�  ���̗�ł�VBW=300kHz�ɐݒ�
#		$sock.puts("*OPC?")
#		$sock.gets
			
		$sock.puts("TRIG OFF")                                  #TriggerSwitch�ݒ�
		$sock.puts("*OPC?")
		$sock.gets
			
		$sock.puts("DET POS")                                   #���g���[�h���|�W�e�B�u�s�[�N�ݒ�   ���̗�ł̓|�W�e�B�u�s�[�N�ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets
			
#    	$sock.puts("SWE:POIN 1001")                             #�g���[�X�|�C���g����ݒ�   SA���[�h�ł͎g�p���Ȃ�  ���̗�ł�1001�|�C���g�ɐݒ�
#    	$sock.puts("*OPC?")
#    	$sock.gets
			
#    	$sock.puts("SWE:TIME:AUTO:MODE FAST")                   #�|�����[�h�ݒ� SA���[�h�ł͎g�p���Ȃ�  �|�����[�h��fast�ɐݒ�
#    	$sock.puts("*OPC?")
#    	$sock.gets
			
		$sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #Reference Level    ���̗�ł̓��t�@�����X���x����-10dBm�ɐݒ�
		$sock.puts("*OPC?") 
		$sock.gets

		$sock.puts("INIT:CONT ON")                              #�A���|��ON�ݒ�
		$sock.puts("*OPC?")
			$sock.gets

		$sock.puts("INST SPECT")                                #�A�N�e�B�u�ȃA�v���P�[�V������SPECT�ɐݒ�  SA���[�h�ł͉��L�̃R�}���h���g�p    INST SIGANA"
		$sock.puts("*OPC?") 
		$sock.gets

		$sock.puts("FREQ:CENT " + frq[RATE][CH])                          #���S���g����ݒ�
		$sock.puts("*OPC?") 
		$sock.gets

		$sock.puts("FREQ:SPAN 0HZ")     #SPAN��ݒ� SA���[�h�ł͉��L�̃R�}���h���g�p    (Trace Mode��Pwer vs Time�ɐݒ�)    TRAC:MODE PVT�[���X�p���ɐݒ�
		$sock.puts("*OPC?")  

		$sock.puts("CALC:MARK:MODE OFF")                        #�}�[�J�[��OFF�ɐݒ�
		$sock.puts("*OPC?")   
		$sock.gets

		$sock.puts("SWE:TIME 500MS")                            #Time Domain��Sweep Time��ݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("INST SG")                                   #�A�N�e�B�u�ȃA�v���P�[�V������SG�ɐݒ�
		$sock.puts("*OPC?")  
		$sock.gets

		$sock.puts("FREQ " + frq[RATE][CH])                               #SG�̒��S���g����ݒ肷��   ���̗�ł͒��S���g����920MHz�ɐݒ�
		$sock.puts("*OPC?")    
		$sock.gets

		$sock.puts("POWer -10DBM")                              #SG�̃��x����ݒ肷��   ���̗�ł�-10dBm�ɐݒ肷��B
		$sock.puts("*OPC?")  
		$sock.gets

# 		$sock.puts("MMEM:Load:WAV 'WiSUN-TxDemo','WiSUN_FET_D100F2_P08'")       #SG�̔g�`�������ɔg�`�����[�h����   ���̗�ł�Package����'WiSUN-TxDemo�A�p�^�[������WiSUN_FET_D100F2_P08�̔g�`�����[�h
# 		$sock.puts("*OPC?")   
# 		$sock.gets
		
# 		$sock.puts("SOUR:RAD:ARB:WAV 'WiSUN-TxDemo','WiSUN_FET_D100F2_P08'")    #SG�̔g�`��I������ ���̗�ł�Package����'WiSUN-TxDemo�A�p�^�[������WiSUN_FET_D100F2_P08�̔g�`��I��
#		$sock.puts("*OPC?")
#		$sock.gets
		
		$sock.puts("OUTP ON")                                   #SG�̐M���o�͂�ON�ɐݒ�
		$sock.puts("*OPC?")    
		$sock.gets
		
#		$sock.puts("OUTP:MOD ON")                               #SG�̕ϒ���ON�ɐݒ�
		$sock.puts("OUTP:MOD OFF")                              #SG�̕ϒ���ON�ɐݒ�
		$sock.puts("*OPC?")    
		$sock.gets
		
		sleep 5
		@send_flg = 1
		sleep 3

		$sock.puts("OUTP OFF")                                   #SG�̐M���o�͂�ON�ɐݒ�
		$sock.puts("*OPC?")    
		$sock.gets

		$sock.puts("INST SPECT")                                #�A�N�e�B�u�ȃA�v���P�[�V�������X�y�A�i�ɐݒ�   SA���[�h�ł͉��L�̃R�}���h���g�p    INST SIGANA"
		$sock.puts("*OPC")   
#		$sock.gets
		
		$sock.close
	end

tester_thread.join
snd_thread.join


printf("######################## SUMMARY #####################\n")
printf("Tatol: Career sense\n")
printf("Judged send status : %d\n",@status.to_i)
if @status.to_i != 9 then
	printf("!!!FAIL!!!\n")
else
	printf("!!!PASS!!!\n")
end
printf("######################################################\n")

