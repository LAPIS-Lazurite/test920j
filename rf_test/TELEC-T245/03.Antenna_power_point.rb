
    #
    # �󒆐��d�́i�듪�d�́j
    #

#!/usr/bin/ruby

require '../openif.rb'


    $sock.puts("INST SPECT")                                #SA���[�h�ł͉��L�̃R�}���h���g�p  INST SIGANA"
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
    
    $sock.puts("FREQ:CENT 920MHZ")                          #���S���g���ݒ�  ���̗�ł͒��S���g����920MHz�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("FREQ:SPAN 500KHZ")                          #SPAN�ݒ�  ���̗�ł�Span=500kHz�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("CALC:MARK:MODE OFF")                        #�}�[�J�[OFF�ݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("BAND 1MHZ")                                 #RBW�ݒ�  ���̗�ł�RBW=1MHz�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("BAND:VID 3MHZ")                             #VBW�ݒ�  SA���[�h�ł͎g�p���Ȃ�  ���̗�ł�VBW=1MHz�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:POIN 1001")                             #�g���[�X�|�C���g�ݒ�  SA���[�h�ł͎g�p���Ȃ� ���̗�ł�1001�|�C���g�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("DET POS")                                   #���g���[�h��ݒ�  ���̗�ł̓|�W�e�B�u�s�[�N�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("TRAC1:STOR:MODE MAXH")                      #�\�����[�h���}�b�N�X�z�[���h�ݒ�  SA���[�h�ł͉��L�R�}���h���g�p����  TRAC:STOR:MODE MAXH
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("AVER:COUN 5")                               #Average�񐔂�ݒ�  ���̗�ł̓A�x���[�W�񐔂��T��ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:TIME:AUTO:MODE FAST")                   #�g���[�X�f�[�^�̃X�g���[�W���@��ݒ�  SA���[�h�ł͎g�p���Ȃ�  ���̗�ł͑|�����[�h��fast�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #���t�@�����X���x���ݒ�(dBm)  ���̗�ł̓��t�@�����X���x����-10dBm�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":UNIT:POWer W")                             #�\����W�ɕϊ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":CALC:MARK:MODE NORM")                      #�}�[�J��NORMAL�ɐݒ肷��B
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":CALCulate:MARKer:CENTer")                  #�}�[�J���g�����Z���^���g���ɐݒ肷��B
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:TIME 5.46s")                            #�|�����Ԃ�ݒ�  SA���[�h�ł͉��L�R�}���h���g�p����  CALC:ATIM:LENG 2MS  ���̗�ł�5.46�b�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":CALCulate:MARKer:WIDTh:POINt 1001")        #�]�[���}�[�J�̕���\���|�C���g�Őݒ�  SA���[�h�ł͎g�p���Ȃ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("INIT:MODE:SING")                            #�|�������s����B  ���̗�ł͎w�肵���A�x���[�W�񐔂ł���5��A�|������B
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":CALCulate:MARKer:MAX")                     #�s�[�N�T�[�`
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":CALCulate:MARKer:CENTer")                  #�}�[�J���g�����Z���^���g���ɐݒ肷��B
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":CALCulate:MARKer:WIDTh:POINt 1001")        #�]�[������SPAN�ɐݒ肷��B  SA���[�h�ł͎g�p���Ȃ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":CALCulate:MARKer:Y?")                      #�}�[�J�_�̃��x����ǂݏo���܂��B
    $sock.puts("*OPC?")
    $sock.gets
    
