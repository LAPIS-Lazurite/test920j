#!/usr/bin/ruby

require '../openif.rb'

p "test"

class MS2830a_init
    $sock.puts("INST CONFIG Config")                        #��ʂɈړ� 
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("MMEM:STOR:SCR:MODE PNG")
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("MMEM:STOR:SCR:MODE PNG")
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("SYST:BEEP OFF")                             #�r�[�v����OFF�ɐݒ�    
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("SYST:LANG SCPI")                            #�����[�g�̌��ꃂ�[�h��SCPI�ɐݒ�   
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("INST SPECT")                                #�A�N�e�B�u�ȃA�v���P�[�V�������X�y�A�i�ɐݒ�   
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("SYST:PRES")                                 #�X�y�A�i��������   
    $sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS:STAT ON")        #���t�@�����X���x���I�t�Z�b�g�@�\��On �ɂ���    
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("DISP:WIND:TRAC:Y:RLEV:OFFS 0")              #���t�@�����X���x���I�t�Z�b�g�l��ݒ肷��   
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("DISP:WIND:TRAC:Y:RLEV -10DBM")              #���t�@�����X���x����ݒ肷��   
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("SWE:RUL OSW")                               #���莞�̑|��/FFT �̐؂�ւ����[����ݒ�    �|���̂ݎg�p���܂��B
    $sock.puts("*OPC?")
    $sock.gets
end
