#!/usr/bin/ruby

#
# ��߸��ѴЯ���Ͻ�
#

require '../socket.rb'
require '../subghz.rb'

#setup DUT --------------------------------------
CH = 42
RATE = 100
POW = 1
MOD = "0x03"

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

$sock.puts("FREQ:CENT " + frq[RATE][CH])                #���S���g����ݒ�
$sock.puts("*OPC?")  
$sock.gets

$sock.puts("SEM:BAND:CHAN 200KHZ")                      #Channel BW���`���l���ш敝�~�L�����A���ɐݒ�   �`���l���ш敝�͎������g�����画�肷��
$sock.puts("*OPC?")    
$sock.gets

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
result = $sock.gets.split(",")

printf("######################## SUMMARY #####################\n")
printf("Tatol: Spectrum emission mask\n")
printf("Judged flag : %d\n",result[0].to_i)
if result[0].to_i == 1 then
	printf("!!!FAIL!!!\n")
else
	printf("!!!PASS!!!\n")
end
printf("######################################################\n")

sleep 5
sbg.trxoff()
$sock.close
