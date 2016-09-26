#!/usr/bin/ruby
#
# 8.�����I�ɔ�����d�g�Ȃǂ̌��x
#

require '../socket.rb'
require '../subghz.rb'


#setup DUT --------------------------------------
CH = 42
RATE = 100
POW = 20
MOD = "0x00"

sbg = Subghz.new()
sbg.setup(CH, RATE, POW)
sbg.rw("8 0x0c ",MOD)
sbg.rxon()

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

$sock.puts("INIT:CONT OFF")                                                                                 #�A���|��OFF�ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SPUR:SEGM:STAT ON,ON,ON,ON,ON,ON,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF,OFF")      #�Z�O�����g��On/Off ��ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SPUR:FREQ:STAR 30MHz,710MHz,900MHz,915MHZ,930MHZ,1000MHZ,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")    #�e�Z�O�����g�̊J�n���g����ݒ�
$sock.puts("*OPC?") 
$sock.gets

#$sock.puts("SPUR:FREQ:STOP 710MHZ,900MHZ,915MHZ,930MHZ,1000MHZ,5000MHZ,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")  #�e�Z�O�����g�̏I�[���g����ݒ�
$sock.puts("SPUR:FREQ:STOP 710MHZ,900MHZ,915MHZ,930MHZ,1000MHZ,3000MHZ,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz,1GHz")  #�e�Z�O�����g�̏I�[���g����ݒ�
$sock.puts("*OPC?")  
$sock.gets

$sock.puts("DISP:SPUR:VIEW:WIND:TRAC:Y:RLEV 10DBM,10DBM,10DBM,10DBM,10DBM,10DBM,0,0,0,0,0,0,0,0,0,0,0,0,0,0")                                   #�e�Z�O�����g��Reference Level ��ݒ�
$sock.puts("*OPC?")  
$sock.gets

$sock.puts("SPUR:DET POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS")      #�e�Z�O�����g�̔g�`�p�^�[���̌��g������ݒ�
$sock.puts("*OPC?")    
$sock.gets

$sock.puts("SPUR:BAND:AUTO OFF,OFF,OFF,OFF,OFF,OFF,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")              #�e�Z�O�����g��RBW ��Auto/Manual ��ݒ�
$sock.puts("*OPC?")  
$sock.gets

$sock.puts("SPUR:BAND 100KHZ,1MHZ,100KHZ,100KHZ,100KHZ,1MHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ")  #�e�Z�O�����g�̕���\�ш敝�iRBW�j��ݒ�
$sock.puts("*OPC?") 
$sock.gets

$sock.puts("SPUR:BAND:VID:AUTO OFF,OFF,OFF,OFF,OFF,OFF,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")          #�e�Z�O�����g�̕���\�ш敝�������ݒ肷��
$sock.puts("*OPC?")    
$sock.gets

$sock.puts("SPUR:BAND:VID 100KHZ,1MHZ,100KHZ,100KHZ,100KHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ,1MHZ")             #�e�Z�O�����g�̃r�f�I�ш敝��ݒ�
$sock.puts("*OPC?") 
$sock.gets

$sock.puts("SPUR:SWE:TIME 10ms,10ms,10ms,10ms,10ms,10ms,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1")                                   #�|�����Ԃ�ݒ�
$sock.puts("*OPC?") 
$sock.gets

$sock.puts("SPUR:SWE:TIME:AUTO ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON,ON")                #Auto�̏ꍇ�A���g���h���C���ł̓f�t�H���g��10ms��ݒ�
$sock.puts("*OPC?")  
$sock.gets

$sock.puts("SPUR:SWE:POIN 1001,1001,1001,1001,1001,1001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001,10001")        #�e�Z�O�����g�̃g���[�X�\���̃|�C���g����ݒ�
$sock.puts("*OPC?") 
$sock.gets

$sock.puts("SPUR:TDOM:SPAN:ZERO OFF")   
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SPUR:TDOM:DET SAMP,SAMP,SAMP,SAMP,SAMP,SAMP,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS,POS")                                   #Time Domain Measurement �̔g�`�p�^�[���̌��g������ݒ�
$sock.puts("*OPC?") 
$sock.gets

$sock.puts("SPUR:TDOM:BAND 100KHZ,1MHZ,100KHZ,100KHZ,1MHZ,1MHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ,10KHZ")   #Time Domain Measurement ��RBW ��ݒ�
$sock.puts("*OPC?")    
$sock.gets

$sock.puts("SPUR:TDOM:BAND:VID 100KHZ,1MHZ,100KHZ,100KHZ,1MHZ,1MHZ,1,1,1,1,1,1,1,1,1,1,1,1,1,1")            #Time Domain Measurement ��VBW ��ݒ�
$sock.puts("*OPC?")  
$sock.gets

$sock.puts("SPUR:TDOM:SWE:TIME 5.46ms,5.46ms,5.46ms,5.46ms,5.46ms,5.46ms,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1")                  #Time Domain Measurement �̑|�����Ԃ�ݒ�
$sock.puts("*OPC?")  
$sock.gets

$sock.puts("CALC:SPUR:LIM:ABS:DATA -54DBM,-55DBM,-55DBM,-54DBM,-55DBM,-47DBM,-10DBM,-10DBM,-13DBM,-13DBM,-13DBM,-13DBM,-13DBM,-13DBM,-10DBM,-10DBM,-13DBM,-13DBM,-13DBM,-13DBM")    #Limit��ݒ�
$sock.puts("*OPC?")   
$sock.gets

$sock.puts("CONF:SPUR")                                                                                     #Spurious Emission �����On �ɐݒ�
$sock.puts("*OPC?")  
$sock.gets

$sock.puts("INIT:SPUR")                                                                                     #Spurious ������J�n
$sock.puts("*OPC?")
$sock.gets

$sock.puts("FETC:SPUR?")                                                                                  #Spurious Emission ����̑��茋�ʂ��擾
$sock.puts("*OPC?")
r = $sock.gets.split(",")

sbg.trxoff()
$sock.close

i=0
printf("######################## SUMMARY #####################\n")
printf("Tatol: Limit of secondary radiated emissionsn\n")
printf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", "No","Segment","frequency","peak","margin","limit","jude")
printf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1])
printf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1])
printf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1])
printf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1])
printf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1])
printf("%-3s %-7s %-15s %-10s %-10s %-10s %-10s\n", r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1],r[i+=1])
if r[0].to_i == 1 then
	printf("!!!FAIL!!!\n")
else
	printf("!!!PASS!!!\n")
end
printf("######################################################\n")
