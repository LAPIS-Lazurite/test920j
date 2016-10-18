# encoding: utf-8
module Rftp; end
require_relative "./RfLib/e2p_base"
require_relative "./RfLib/calibration"
require_relative "./RfLib/cw"
require_relative "./RfLib/snd"
require_relative "./RfLib/cca"
require_relative "./RfLib/set_addr"
require_relative "./RfLib/get_addr"
require_relative "./RfLib/command"
RF_STATUS_ADDR	= "8 0x6c "
OSC_ADJ2_ADDR	= "8 0x0a "
PA_ADJ1_ADDR 	= "9 0x04 "
PA_ADJ3_ADDR 	= "9 0x06 "
