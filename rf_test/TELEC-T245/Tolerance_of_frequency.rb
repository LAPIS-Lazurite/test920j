
#
# ���g���΍��iCW)
#

    $sock.puts(""INST SPECT"")                              #SA���[�h�ł͉��L�̃R�}���h���g�p  INST SIGANA"
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
    
    $sock.puts("FREQ:CENT 920MHZ")                          #���S���g���ݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("FREQ:SPAN 500KHZ")                          #SPAN�ݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("BAND 1KHZ")                                 #RBW�ݒ�
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("BAND:VID 1KHZ")                             #VBW�ݒ�SA���[�h�ł͎g�p���Ȃ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:POIN 1001")                             #�g���[�X�|�C���g�ݒ�SA���[�h�ł͎g�p���Ȃ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("DET POS")                                   #���g���[�h��ݒ�|�W�e�B�u�s�[�N
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("TRAC1:STOR:MODE MAXH")                      #�\�����[�h���}�b�N�X�z�[���h�ݒ�TRAC:STOR:MODE MAXH
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(""CALC:MARK:FCO ON"")                        #���g���J�E���^��ON�ݒ�SA���[�h�ł͉��L�̃R�}���h���g�p����  CALC:MARK1:STAT"
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("TRAC1:STOR:MODE OFF")                       #�g���[�X�f�[�^�̃X�g���[�W���@��ݒ�
    $sock.puts("*OPC?")
    $sock.gets

    $sock.puts("AVER:COUN 5")                               #Average�񐔂�ݒ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("SWE:TIME:AUTO:MODE FAST")                   #�|�����[�h�ݒ�SA���[�h�ł͎g�p���Ȃ�
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(""SWE:TIME 1s"")                             #�|�����Ԃ̐ݒ�SA���[�h���͉��L�̃R�}���h���g�p����  CALC:ATIM:LENG 2MS"
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #Reference Level
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("INIT:MODE:SING")                            #�V���O���|�����J�n����
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts(""CALC:MARK:FCO:X?"")                        #���g���J�E���^�̒l��ǂݎ��SA���[�h�ł͉��L�̃R�}���h���g�p����  CALC:MARK:Y?"
    $sock.puts("*OPC")
    $sock.gets
