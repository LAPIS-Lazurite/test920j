
#
# 12-2.受信試験（PER測定）
#

    $sock.puts("INST SG")                       #アクティブなアプリケーションをSGに設定する
    $sock.puts("INST:DEF")                      #現在選択しているアプリケーションの設定と状態を初期化する   SGを初期化する
    $sock.puts("MMEM:LOAD:WAV 'WiSUN-TxDemo','WiSUN_FET_D100F2_P08'")  #波形パターンをロードする    この例ではPackage名がWiSUN-TxDemo、パターン名がWiSUN_FET_D100F2_P08の波形をロードする
    $sock.puts("*OPC?")
    $sock.gets
    
    $sock.puts("RAD:ARB:WAV 'WiSUN-TxDemo','WiSUN_FET_D100F2_P08'")    #波形パターンを選択する  この例ではPackage名がWiSUN-TxDemo、パターン名がWiSUN_FET_D100F2_P08の波形を選択する
    $sock.puts("*OPC?") 
    $sock.gets
    
    $sock.puts("FREQ 920MHZ")                   #周波数を920MHzに設定する   この例では周波数を920MHzに設定する。
    $sock.puts("*OPC?") 
    $sock.gets
    
    $sock.puts("RAD:ARB:TRIG ON")               #SGのトリガ入力を設定する   トリガ入力をONに設定する。
    $sock.puts("RAD:ARB:TRIG:TYPE FRAM")        #外部トリガの動作モードを設定する   パケット数を指定するために、Frameに設定する。
    $sock.puts("RAD:ARB:TRIG:SOUR BUS")         #外部トリガのソースを設定する   外部PCによるトリガ入力を行うため、BUSに設定する。
    $sock.puts("RAD:ARB:TRIG:FRAM:COUN 1000")   #出力フレーム数を設定する   この例では出力するパケット数は1000に設定する。
    $sock.puts("OUTP ON")                       #RF OutputをOnに設定する
    $sock.puts("*OPC?")  
    $sock.gets
    
    $sock.puts("POW -50.00")                    #出力レベルを設定するレベルを-50.00dBmに設定する。
    $sock.puts("*OPC?") 
    $sock.gets
    
    $sock.puts("OUTP:MOD ON")                   #ModをOnに設定する
    
    $sock.puts("RAD:ARB:TRIG:GEN")              #波形パターンの出力を開始する。 指定したパケット数の信号出力を開始する。
