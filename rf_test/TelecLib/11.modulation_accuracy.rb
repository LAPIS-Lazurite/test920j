#!/usr/bin/ruby

#
# 11.�ϒ����x
#

require './socket.rb'
require './subghz.rb'

class Telectp::Test
	def _11_modulation_accuracy
		print("!!!unsupported test!!!\n")
		exit

		sbg = Subghz.new()
		sbg.setup(42, 100, 1)
		sbg.mod(1)
		sbg.txon()

		$sock.puts("INST VMA")  
		$sock.puts("*OPC?")
		$sock.gets
		
		$sock.puts("SYST:PRES")   
		$sock.puts("*OPC?")  
		$sock.gets
		
#$sock.puts("syst:lang scpi")
#$sock.puts("*OPC?")
#$sock.gets
		
		$sock.puts("FREQ:CENT 924.3MHZ")                          #���S���g���ݒ� ���̗�ł͒��S���g����920MHz�ɐݒ�
		$sock.puts("*OPC?")    
		$sock.gets
		
		$sock.puts("POW:RANG:ILEV -10DBM")                      #���̓��x���ݒ� ���̗�ł͓��̓��x����-10dBm�ɐݒ�
		$sock.puts("*OPC?") 
		$sock.gets
		
		$sock.puts("MMEM:LOAD:COMM 'D:\Anritsu Corporation\Signal Analyzer\User Data\Parameter Setting\VMA\Dialog Param\T96.xml'")    #Common Setting�Ɏw�肵���p�����[�^�t�@�C�������[�h
		$sock.puts("*OPC?")    
		$sock.gets
		
		$sock.puts("EVM:AVER ON")                               #�A�x���[�W�ݒ�
		$sock.puts("*OPC?") 
		$sock.gets
		
		$sock.puts("EVM:AVER:COUNT 10")                         #�A�x���[�W�񐔂̐ݒ�   ���̗�ł̓A�x���[�W�񐔂��P�O��ɐݒ�
		$sock.puts("*OPC?")    
		$sock.gets
		
		$sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS:STAT ON")        #���̓��x���̃I�t�Z�b�g�l��L���ɂ���
		$sock.puts("*OPC?") 
		$sock.gets
		
		$sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS 0")              #�I�t�Z�b�g���x���l�ݒ�     ���̗�ł̓I�t�Z�b�g���x���l��0dB�ɐݒ肷��
		$sock.puts("*OPC?")    
		$sock.gets
		
		$sock.puts("DISP:TRAC:ZOOM")                            #�g���[�X�\�����P��ʂɐݒ�
		$sock.puts("*OPC?")   
		$sock.gets
		
		$sock.puts("INIT:MODE:SING")                            #1��̑�������s
		$sock.puts("*OPC?")  
		$sock.gets
		
		$sock.puts("FETC:EVM?")                                 #EVM�̑���l�̖₢���킹
		$sock.puts("*OPC")  
		$sock.gets
		
#		$sock.close
	end
end
