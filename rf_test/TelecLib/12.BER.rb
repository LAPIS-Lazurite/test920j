#!/usr/bin/ruby

#
# 12-1.��M�����iBER����j
#

require './socket.rb'

class Telectp::Test
	def _12_BER
		print("!!!unsupported test!!!\n")
		exit
		$sock.puts("INST BER")
		$sock.puts("INP:BERT:CLOC:POL NEG")             #Clock Edge��ݒ肷��   ���̗�ł�Negative�ɐݒ肷��
		$sock.puts("INP:BERT:DATA:POL POS")             #Data Polarity��ݒ肷��    ���̗�ł�Positive�ɐݒ肷��
		$sock.puts("INP:BERT:CGAT:POL POS")             #Enable Active��ݒ肷��    ���̗�ł�Positive�ɐݒ肷��
		$sock.puts("BERT:STOP:CRIT NONE Single")        #BER������r�b�g�����[�h�ɐݒ肷��
		$sock.puts("INIT:MODE:SING")                    #BER�����Single����ɐݒ肷��
		$sock.puts("BERT:TBIT 100000")                  #BER�̑���r�b�g����ݒ肷��    ���̗�ł�BER����̃r�b�g����100000�r�b�g�ɐݒ肷��
		$sock.puts("BERT:PRBS PN9")                     #BER����̃f�[�^��ʂ�ݒ肷��  ���̗�ł�BER����̃f�[�^��ʂ�PN9�ɐݒ肷��
		
		$sock.puts("INST SG")                           #�A�N�e�B�u�ȃA�v���P�[�V������SG�ɐݒ肷��
		$sock.puts("INST:DEF")                          #���ݑI�����Ă���A�v���P�[�V�����̐ݒ�Ə�Ԃ�����������   SG������������
		$sock.puts("MMEM:LOAD:WAV 'WiSUN-TxDemo','WiSUN_FET_D100F2_P08'")   #�g�`�p�^�[�������[�h����   ���̗�ł�Package����WiSUN-TxDemo�A�p�^�[������WiSUN_FET_D100F2_P08�̔g�`�����[�h����
		$sock.puts("*OPC?")
		$sock.gets
		
		$sock.puts("RAD:ARB:WAV 'WiSUN-TxDemo','WiSUN_FET_D100F2_P08'")     #�g�`�p�^�[����I������ ���̗�ł�Package����WiSUN-TxDemo�A�p�^�[������WiSUN_FET_D100F2_P08�̔g�`��I������
		
		$sock.puts("INST SG")                           #�Q��ڈȍ~�̑���ł͂��̍s��艺�̃R�}���h�����s����B
		$sock.puts("FREQ 920MHZ")                       #���g����920MHz�ɐݒ肷��   ���̗�ł͎��g����920MHz�ɐݒ肷��B
		$sock.puts("POW -30.00")                        #�o�̓��x����ݒ肷��   ���̗�ł͏o�̓��x����-30dBm�ɐݒ肷��B
		$sock.puts("OUTP:MOD ON")                       #Mod��On�ɐݒ肷��
		$sock.puts("OUTP ON")                           #RF Output��On�ɐݒ肷��
		$sock.puts("POW -50.00")                        #�o�̓��x����ݒ肷��   �܂��͊m���ɐڑ���ԂɂȂ郌�x�����o�͂��A�ڑ���ԂɂȂ����玎�����郌�x���ɕύX����B
		$sock.puts("BERT:RSYN OFF")                     #�����ē����̏�Ԃ�OFF�ɐݒ�

		$sock.puts("INST BER")                          #�A�N�e�B�u�ȃA�v���P�[�V������BERTS�ɐݒ肷��
		$sock.puts("INIT:MODE:SING")                    #�V���O�����[�h��BER������J�n����
		$sock.puts("STAT:BERT:MEAS?")                   #���݂̓����Ԃ�ǂݏo��   �߂�l��1�i���蒆�j�łȂ��Ȃ�܂ł��̃R�}���h���J��Ԃ�����B
		$sock.puts("CALC:BERT:BER? ER")                 #BER�̑��茋�ʂ��擾����

#		$sock.close
	end
end 
