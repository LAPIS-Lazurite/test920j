
#
# 12-2.��M�����iPER����j
#

    $sock.puts("INST SG")                       #�A�N�e�B�u�ȃA�v���P�[�V������SG�ɐݒ肷��
    $sock.puts("INST:DEF")                      #���ݑI�����Ă���A�v���P�[�V�����̐ݒ�Ə�Ԃ�����������   SG������������
    $sock.puts("MMEM:LOAD:WAV 'WiSUN-TxDemo','WiSUN_FET_D100F2_P08'")  #�g�`�p�^�[�������[�h����    ���̗�ł�Package����WiSUN-TxDemo�A�p�^�[������WiSUN_FET_D100F2_P08�̔g�`�����[�h����
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("RAD:ARB:WAV 'WiSUN-TxDemo','WiSUN_FET_D100F2_P08'")    #�g�`�p�^�[����I������  ���̗�ł�Package����WiSUN-TxDemo�A�p�^�[������WiSUN_FET_D100F2_P08�̔g�`��I������
    $sock.puts("*OPC?") 
    $sock.gets
    
    $sock.puts("FREQ 920MHZ")                   #���g����920MHz�ɐݒ肷��   ���̗�ł͎��g����920MHz�ɐݒ肷��B
    $sock.puts("*OPC?") 
    $sock.gets
    
    $sock.puts("RAD:ARB:TRIG ON")               #SG�̃g���K���͂�ݒ肷��   �g���K���͂�ON�ɐݒ肷��B
    $sock.puts("RAD:ARB:TRIG:TYPE FRAM")        #�O���g���K�̓��샂�[�h��ݒ肷��   �p�P�b�g�����w�肷�邽�߂ɁAFrame�ɐݒ肷��B
    $sock.puts("RAD:ARB:TRIG:SOUR BUS")         #�O���g���K�̃\�[�X��ݒ肷��   �O��PC�ɂ��g���K���͂��s�����߁ABUS�ɐݒ肷��B
    $sock.puts("RAD:ARB:TRIG:FRAM:COUN 1000")   #�o�̓t���[������ݒ肷��   ���̗�ł͏o�͂���p�P�b�g����1000�ɐݒ肷��B
    $sock.puts("OUTP ON")                       #RF Output��On�ɐݒ肷��
    $sock.puts("*OPC?")  
    $sock.gets
    
    $sock.puts("POW -50.00")                    #�o�̓��x����ݒ肷�郌�x����-50.00dBm�ɐݒ肷��B
    $sock.puts("*OPC?") 
    $sock.gets
    
    $sock.puts("OUTP:MOD ON")                   #Mod��On�ɐݒ肷��
    
    $sock.puts("RAD:ARB:TRIG:GEN")              #�g�`�p�^�[���̏o�͂��J�n����B �w�肵���p�P�b�g���̐M���o�͂��J�n����B
