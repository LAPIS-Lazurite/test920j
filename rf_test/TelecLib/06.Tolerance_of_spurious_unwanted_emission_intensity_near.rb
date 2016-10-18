#!/usr/bin/ruby

#
# ���ر����˖��͕s�v���˂̋��x�i�ߖT�ȊO�j
#


require './socket.rb'
require './subghz.rb'

#setup DUT --------------------------------------
class Telectp::Test
	def _06_Tolerance_of_spurious_unwanted_emission_intensity_near
#	mas(50,24)
		_06_mas(100,42)
#	mas(50,61)
#		$sock.close
	end

	def _06_mas(ra,ch)
		sbg = Subghz.new()
		sbg.setup(ch, ra, POW)
		sbg.txon()

#setup TESTER --------------------------------------
		center = $frq[ra][ch] 
		lower  = center.to_i - 300000
		upper  = center.to_i + 300000

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

		$sock.puts("INIT:CONT OFF")
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SPUR:SEGM:STAT ON,ON,ON,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF")                                  #�Z�O�����g��On/Off ��ݒ�
		$sock.puts("*OPC?")
		$sock.gets

#$sock.puts("SPUR:FREQ:STAR 915MHZ,920.3MHZ,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")      #�e�Z�O�����g�̊J�n���g����ݒ�
		$sock.puts("SPUR:FREQ:STAR 915MHZ,920.3MHZ," + upper.to_s + ",1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")      #�e�Z�O�����g�̊J�n���g����ݒ�
		$sock.puts("*OPC?")
		$sock.gets
			
#$sock.puts("SPUR:FREQ:STOP 919.7MHZ,930MHZ,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")      #�e�Z�O�����g�̏I�[���g����ݒ�
		$sock.puts("SPUR:FREQ:STOP 919.7MHZ," + lower.to_s + ",930MHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")      #�e�Z�O�����g�̏I�[���g����ݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("DISP:SPUR:VIEW:WIND:TRAC:Y:RLEV 10DBM,10DBM,10DBM,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0")                                               #�e�Z�O�����g��Reference Level ��ݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SPUR:DET POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS")                                      #�e�Z�O�����g�̔g�`�p�^�[���̌��g������I��
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SPUR:BAND:AUTO OFF,OFF,OFF,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")                                                  #�e�Z�O�����g��RBW ��Auto/Manual ��ݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SPUR:BAND 3KHZ,3KHZ,3KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ") #�e�Z�O�����g�̕���\�ш敝�iRBW�j��ݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SPUR:BAND:VID:AUTO OFF,OFF,OFF,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")                                              #�e�Z�O�����g�̕���\�ш敝�������ݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SPUR:BAND:VID 3KHZ,3KHZ,3KHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ")             #�e�Z�O�����g�̃r�f�I�ш敝��ݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SPUR:SWE:TIME 5.46S,5.46S,5.46S,5.46S,5.46S,5.46S,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1")                     #�e�Z�O�����g��Sweep Time ��ݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SPUR:SWE:TIME:AUTO OFF,OFF,OFF,OFF,OFF,OFF,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")                                          #�e�Z�O�����g��Sweep Time ��Auto/Manual ��ݒ�
		$sock.puts("*OPC?")
		$sock.gets

#�e�Z�O�����g�̃g���[�X�\���̃|�C���g����ݒ�
		$sock.puts("SPUR:SWE:POIN 1001,1001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001")
		$sock.puts("*OPC?")
		$sock.gets

#Limit��ݒ�
		$sock.puts("CALC:SPUR:LIM:ABS:DATA -36DBM,-36DBM,-36DBM,-10DBM,-13DBM,-13DBM,-10DBM,-10DBM,-13DBM,-13DBM,-13DBM,-13DBM,-13DBM,-13DBM,-10DBM,-10DBM,-13DBM,-13DBM,-13DBM,-13DBM")
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("SPUR:TDOM:SPAN:ZERO OFF")       #�X�v���A�X�d�͂��^�C���h���C��(Span=0Hz)�ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("CONF:SPUR")                     #Spurious Emission �����On �ɐݒ�
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("INIT:SPUR")                     #Spurious ������J�n
		$sock.puts("*OPC?")
		$sock.gets

		$sock.puts("FETC:SPUR?")                    #Spurious Emission ����̑��茋�ʂ��擾
		$sock.puts("*OPC?")
		r = $sock.gets.split(",")

		sbg.trxoff()

		i=0
		printf("+++++++++++ SUMMARY ++++++++++\n")
		printf("Subject: 06 Tolerance of spurious unwanted emission intensity near\n")
		printf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", "No","Segment","frequency","peak","margin","limit","jude")
		printf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1])
		printf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1])
		printf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1])
		if r[0].to_i == 1 then
			printf("Judgement: %s\n", "FAIL")
			raise StandardError, "FAIL\n"
		else
			printf("Judgement: %s\n", "PASS")
		end
	end
end
