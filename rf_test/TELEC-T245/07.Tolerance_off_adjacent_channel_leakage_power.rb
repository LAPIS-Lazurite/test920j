#!/usr/bin/ruby
#
# �א�����٘R�k�d��
#

require '../socket.rb'
require '../subghz.rb'

sbg = Subghz.new()
sbg.setup(42, 50, 20)
sbg.rw("8 0x0c ","0x03")
sbg.txon()

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

$sock.puts("INIT:CONT OFF")                              #�A���|��OFF�ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("FREQ:CENT 924.2MHZ")                          #���S���g���ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("FREQ:SPAN 1MHZ")                            #SPAN�ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("BAND 1KHZ")                                 #RBW�ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("BAND:VID 3KHZ")                             #VBW�ݒ�    SA���[�h�ł͎g�p���Ȃ�
$sock.puts("*OPC?")
$sock.gets
	
$sock.puts("SWE:POIN 1001")                             #�g���[�X�|�C���g�ݒ�   SA���[�h�ł͎g�p���Ȃ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("DET POS")                                   #���g���[�h�ݒ�
$sock.puts("*OPC?")
$sock.gets

#    $sock.puts("TRIG ON")                                   #SA���[�h�ł͖{�R�}���h��ǉ�
#    $sock.puts("*OPC?")
#    $sock.gets

#    $sock.puts("TRIG:VID:LEV -30")                          #SA���[�h�ł͖{�R�}���h��ǉ�
#    $sock.puts("*OPC?")
#    $sock.gets

$sock.puts("TRAC1:STOR:MODE OFF")                       #�\�����[�h�ݒ�     SA���[�h�ł͉��L�R�}���h�ɕύX  TRAC:STOR:MODE OFF"
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SWE:TIME:AUTO:MODE FAST")                   #FAST/NORM      SA���[�h�ł͎g�p���Ȃ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("SWE:TIME 5.46s")                            #�|�����Ԃ̐ݒ�     SA���[�h�ł͉��L�R�}���h�ɕύX  CALC:ATIM:LENG 2MS"
$sock.puts("*OPC?")
$sock.gets

$sock.puts("DISP:WIND:TRAC:Y:RLEV -30")                 #Reference Level
$sock.puts("*OPC?")
$sock.gets

$sock.puts("ACP ON")                                    #ACP����ON
$sock.puts("*OPC?")
$sock.gets

$sock.puts("ACP:CARR:RCAR:METH BSIDes")                 #���΃��x���\���̊��ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("ACP:CARR:LIST:WIDT 200000")                 #�L�����A�̎��g���Ԋu��ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("ACP:CARR:LIST:BAND 200KHZ")                 #�L�����A�̑���ш敝��ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("ACP:CARR:FILT:TYPE RECT")                   #�L�����A�̃t�B���^��ނ�ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("ACP:OFFS:BAND 200KHZ")                      #Offset Channel �ш敝��ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("ACP:OFFS:FILT:TYPE RECT")                   #�I�t�Z�b�g�̃t�B���^��ނ�ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("ACP:OFFS:LIST 200KHZ,0,0")                  #�I�t�Z�b�g�`���l���̃I�t�Z�b�g���g����ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("ACP:OFFS:LIST:STAT ON,OFF,OFF")             #�I�t�Z�b�g�`���l����ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("INIT:MODE:SING")                            #Single��������s   
$sock.puts("*OPC?")
$sock.gets

$sock.puts("FETC:ACP?")                                 #ACP����l��₢���킹
$sock.puts("*OPC?")
p $sock.gets

sbg.trxoff()
$sock.close
