
#
# �󒆐��d�́i���ϓd�́j
#

    $sock.puts("INST SPECT")                                #SA���[�h�ł͉��L�̃R�}���h���g�p   INST SIGANA"
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
    
    $sock.puts("INIT:CONT OFF")                             #�A���|��OFF�ݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("FREQ:CENT 920MHZ")                          #���S���g���ݒ�     ���̗�ł͒��S���g����920MHz�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("FREQ:SPAN 500KHZ")                          #SPAN�ݒ�   ���̗�ł�Span=500kHz�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("BAND 1MHZ")                                 #RBW�ݒ�    ���̗�ł�RBW=1MHz�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("BAND:VID 3MHZ")                             #VBW�ݒ�    SA���[�h�ł͎g�p���Ȃ�  ���̗�ł�VBW=1MHz�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:POIN 1001")                             #�g���[�X�|�C���g�ݒ�   SA���[�h�ł͎g�p���Ȃ�  ���̗�ł�1001�|�C���g�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("DET SAMP")                                  #���g���[�h�ݒ�     ���̗�ł̓|�W�e�B�u�s�[�N�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("BPOW ON")                                   #BurstAveragePower�����ON�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:TIME 5.46MS")                           #SweepTime��ݒ�    SA���[�h�ł͉��L�R�}���h�ɕύX  CALC:ATIM:LENG 2MS  ���̗�ł�Sweep Time��5.46s�ɐݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("TRIG:EXT:SLOP POS")                         #�g���K�̃G�b�W��ݒ肷��   SA���[�h�ł͉��L�R�}���h���g�p  TRIG:SLOP POS   ���̗�ł͗����オ��G�b�W�ɐݒ肷��
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("TRIG:VID:LEV -40DBM")                       #TriggerLevel�ݒ�   ���̗�ł̓g���K���x����-40dBm�ɐݒ肷��B
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("TRIG ON")                                   #TriggerSwitch�ݒ�
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("BPOW:BURS:STAR 0S")                         #StartTime�ݒ�  SA���[�h�ł͉��L�R�}���h���g�p  CALC:ATIM:STAR 0S   ���̗�ł�Start Time��0s�ɐݒ肷��"
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:TIME:AUTO:MODE FAST")                   #�|�����[�h�ݒ�     SA���[�h�ł͎g�p���Ȃ�  ���̗�ł͑|�����[�h��fast�ɐݒ肷��
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #���t�@�����X���x���ݒ�(dBm)    ���̗�ł̓��t�@�����X���x����-10dBm�ɐݒ肷��B
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(":UNIT:POWer W")                             #�\����W�ɕϊ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("CALC:MARK:MODE OFF")                        #�}�[�J�[OFF�ݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("INIT:MODE:SING")                            #SA���[�h�ł̓g���[�X���[�h��ύX���Ă��炩�炱�̃R�}���h�𑗂�(6�s�����Q��)
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("TRAC? TRAC1")                               #�g���[�X�f�[�^��ǂݏo��
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("BPOW:BURS:STOP 2.67818181818182MS")         #Burst Average Power ����̏I���ʒu�i���ԁj��ݒ�   SA���[�h�ł͉��L�R�}���h���g�p      TRAC:MODE PVT"
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("INIT:MODE:SING")                             #SA���[�h�ł͖{�R�}���h��}��
    $sock.puts("*OPC?")
    $sock.gets
 
    $sock.puts("FETC:BPOW?")                                #BurstAveragePower�̑��茋�ʂ�ǂݎ��
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("TRIG OFF")
    $sock.puts("*OPC?")
    $sock.gets
    
