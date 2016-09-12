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

rate50  = {24 => "920600000",33 => "922400000", 36 => "923000000", 60 => "927800000", 43 => "924400000" }
rate100 = {24 => "920700000",33 => "922500000", 36 => "923100000", 60 => "927900000", 42 => "924300000" }
frq = {50 => rate50, 100 => rate100}

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

$sock.puts("FREQ:CENT " + frq[RATE][CH])                #���S���g���ݒ�
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

$sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #Reference Level
$sock.puts("*OPC?")
$sock.gets

$sock.puts("INIT:MODE:SING")                            #�V���O���|�����J�n����
$sock.puts("*OPC?")
$sock.gets

$sock.puts("CALC:MARK:FCO:X?")                          #���g���J�E���^�̒l��ǂݎ��   SA���[�h�ł͉��L�̃R�}���h���g�p����    CALC:MARK:Y?"
$sock.puts("*OPC")

sbg.trxoff()
$sock.close
