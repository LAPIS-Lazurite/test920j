#!/usr/bin/ruby

#
# �󒆐��d�́i�듪�d�́j
#


require '../socket.rb'
require '../subghz.rb'

#setup DUT --------------------------------------
CH = 42
RATE = 100
POW = 20
MOD = "0x03"

sbg = Subghz.new()
sbg.setup(CH, RATE, POW)
sbg.rw("8 0x0c ",MOD)
sbg.txon()

#setup TESTER --------------------------------------
ATT = ARGV[0].to_f.round(2)
MAKER = "DELTA" # NORM(mW) or DELTA(dBm) When using ATT, set DELTA
normal = {"lower" => 18, "upper" => 20, "unit" => "mW"}
delta  = {"lower" => 11, "upper" => 13, "unit" => "dBm"}
range  = {"NORM" => normal, "DELTA" => delta}

$sock.puts("INST SPECT")                                #SA���[�h�ł͉��L�̃R�}���h���g�p  INST SIGANA"
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

$sock.puts("INIT:CONT ON")                              #�A���|���ݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts("FREQ:CENT " + $frq[RATE][CH])                #���S���g���ݒ�  ���̗�ł͒��S���g����920MHz�ɐݒ�
$sock.puts("*OPC?")
$sock.gets

#$sock.puts("FREQ:SPAN 10MHZ")                          #SPAN�ݒ�  ���̗�ł�Span=500kHz�ɐݒ�
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

#$sock.puts("DISP:WIND:TRAC:Y:RLEV -10")                 #���t�@�����X���x���ݒ�(dBm)  ���̗�ł̓��t�@�����X���x����-10dBm�ɐݒ�
$sock.puts("DISP:WIND:TRAC:Y:RLEV 10")                 #���t�@�����X���x���ݒ�(dBm)  ���̗�ł̓��t�@�����X���x����-10dBm�ɐݒ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts(":UNIT:POWer W")                             #�\����W�ɕϊ�
$sock.puts("*OPC?")
$sock.gets

$sock.puts(":CALC:MARK:MODE " + MAKER)                      #�}�[�J��NORMAL or DELTA�ɐݒ肷��B
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

if MAKER == "NORM" then
	$sock.puts(":CALCulate:MARKer:Y?")                      #�}�[�J�_�̃��x����ǂݏo���܂��B
	$sock.puts("*OPC?")
	result = $sock.gets.to_f * 1000
else
	$sock.puts(":CALCulate:MARKer:Y:DELT?")                 #�}�[�J�_�̑��Βl��ǂݏo���܂��B
	$sock.puts("*OPC?")
	result = $sock.gets.to_f + ATT
end
p result

sbg.trxoff()
$sock.close

printf("+++++++++++ SUMMARY ++++++++++\n")
printf("Subject: Antenna power pointn\n")
printf("Makeer mode: %s\n",MAKER)
printf("Attenuate: %d dB\n",ATT)
printf("Result: %3.2f%s\n",result,range[MAKER]["unit"])
if result.between?(range[MAKER]["lower"].to_i,range[MAKER]["upper"].to_i) == false then
	printf("Judgement: %s\n", "FAIL")
	raise StandardError, "FAIL\n"
else
	printf("Judgement: %s\n", "PASS")
end
