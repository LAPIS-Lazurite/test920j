#!/usr/bin/ruby
#
# ��ر�ݽ�@�\
#

require '../socket.rb'
require '../subghz.rb'

POW = 20
MOD = "0x03"

class Career_sense
	#setup method --------------------------------------
	def self.snd(ra,ch)
		sbg = Subghz.new()
		sbg.setup(ch, ra, POW)
		sbg.wf()

		while 1
			confirm = sbg.com("sgs 0xffff 0xffff")
			#`split': invalid byte sequence in UTF-8 (ArgumentError) 
			#str = confirm.split(",")
			if /nil/ !~ confirm
				confirm.encode("UTF-8",:invalid => :replace, :undef => :replace, :replace => '?') #.encode("UTF-8")
				str = confirm.split(",")
				p str
				@status = str[3]
			end
			if @send_flg == 1 then
				break
			end
		end
	end

	def self.tester(ra,ch)
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

		$sock.puts("FREQ:CENT " + $frq[ra][ch])                          #���S���g���ݒ� ���̗�ł͒��S���g����920MHz�ɐݒ�
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

		$sock.puts("FREQ:CENT " + $frq[ra][ch])                          #���S���g����ݒ�
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

		$sock.puts("FREQ " + $frq[ra][ch])                               #SG�̒��S���g����ݒ肷��   ���̗�ł͒��S���g����920MHz�ɐݒ�
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
		
		sleep 2
		@send_flg = 1
		sleep 3

		$sock.puts("OUTP OFF")                                   #SG�̐M���o�͂�ON�ɐݒ�
		$sock.puts("*OPC?")    
		$sock.gets

		$sock.puts("INST SPECT")                                #�A�N�e�B�u�ȃA�v���P�[�V�������X�y�A�i�ɐݒ�   SA���[�h�ł͉��L�̃R�}���h���g�p    INST SIGANA"
		$sock.puts("*OPC")   
#		$sock.gets
	end

	#setup THREAD --------------------------------------
	def self.func_thread(ra,ch)
		tester_thread = Thread.new(ra,ch, &method(:tester))
		snd_thread = Thread.new(ra,ch, &method(:snd))
		tester_thread.join
		snd_thread.join

#	printf("Send status : %d\n",@status.to_i)
		if @status.to_i != 9 then
			raise StandardError, "FAIL\n"
		end
	end

#	func_thread(50,24)
	func_thread(100,42)
#	func_thread(50,61)
	$sock.close
	printf("Career sense is PASS!!!\n")
end
