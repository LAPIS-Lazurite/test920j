#!/usr/bin/ruby

#
# ���g���΍��iCW)
#

require '../socket.rb'
require '../subghz.rb'

#setup DUT --------------------------------------
CH = 42
RATE = 100
POW = 20
MOD = "0x00"
DEV = 20 * (10**-6)

sbg = Subghz.new()
sbg.setup(CH, RATE, POW)
sbg.rw("8 0x0c ",MOD)
sbg.txon()

#setup TESTER --------------------------------------
$sock.puts("INST SPECT")
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

$sock.puts("FREQ:CENT " + $frq[RATE][CH])                #���S���g���ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("FREQ:SPAN 500KHZ")                          #SPAN�ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("BAND 1KHZ")                                 #RBW�ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("BAND:VID 1KHZ")                             #VBW�ݒ�    SA���[�h�ł͎g�p���Ȃ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SWE:POIN 1001")                             #�g���[�X�|�C���g�ݒ�   SA���[�h�ł͎g�p���Ȃ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("DET POS")                                   #���g���[�h��ݒ�   �|�W�e�B�u�s�[�N
$sock.puts("*OPC?")
$sock.gets

$sock.puts("TRAC1:STOR:MODE MAXH")                      #�\�����[�h���}�b�N�X�z�[���h�ݒ�   TRAC:STOR:MODE MAXH
$sock.puts("*OPC?")
$sock.gets

$sock.puts("CALC:MARK:FCO ON")                          #���g���J�E���^��ON     �ݒ�SA���[�h�ł͉��L�̃R�}���h���g�p����  CALC:MARK1:STAT"
$sock.puts("*OPC?")
$sock.gets

$sock.puts("TRAC1:STOR:MODE OFF")                       #�g���[�X�f�[�^�̃X�g���[�W���@��ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("AVER:COUN 5")                               #Average�񐔂�ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SWE:TIME:AUTO:MODE FAST")                   #�|�����[�h�ݒ� SA���[�h�ł͎g�p���Ȃ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SWE:TIME 1s")                               #�|�����Ԃ̐ݒ� SA���[�h���͉��L�̃R�}���h���g�p����    CALC:ATIM:LENG 2MS"
$sock.puts("*OPC?")
$sock.gets

#$sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #Reference Level
$sock.puts("DISP:WIND:TRAC:Y:RLEV 10")                 #Reference Level
$sock.puts("*OPC?")
$sock.gets

$sock.puts("INIT:MODE:SING")                            #�V���O���|�����J�n����
$sock.puts("*OPC?")
$sock.gets

$sock.puts("CALC:MARK:FCO:X?")                          #���g���J�E���^�̒l��ǂݎ��   SA���[�h�ł͉��L�̃R�}���h���g�p����    CALC:MARK:Y?"
$sock.puts("*OPC?")
result = $sock.gets.to_i
frequency = $frq[RATE][CH].to_i

sbg.trxoff()
$sock.close

printf("######################## SUMMARY #####################\n")
printf("Tatol: Tolerance of frequency\n")
printf("Center Frequencey: %d\n",frequency)
printf("Frequency counter: %d\n",result)
if (frequency - result).abs > (DEV * frequency) then
	printf("!!!FAIL!!!\n")
else
	printf("!!!PASS!!!\n")
end
printf("######################################################\n")
