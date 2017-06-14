# encoding: utf-8
module Telectp; end
require_relative "./TelecLib/00.MS2830A_init"
require_relative "./TelecLib/01.Tolerance_of_occupied_bandwidth_Frequency_range"
require_relative "./TelecLib/02.Tolerance_of_frequency"
require_relative "./TelecLib/03.Antenna_power_point"
require_relative "./TelecLib/04.Antenna_power_ave"
require_relative "./TelecLib/05.Tolerance_of_spurious_unwanted_emission_intensity_far"
require_relative "./TelecLib/06.Tolerance_of_spurious_unwanted_emission_intensity_near"
require_relative "./TelecLib/07.Tolerance_off_adjacent_channel_leakage_power"
require_relative "./TelecLib/08.Limit_of_secondary_radiated_emissions"
require_relative "./TelecLib/09.Career_sense"
require_relative "./TelecLib/10.Spectrum_emission_mask"
require_relative "./TelecLib/11.modulation_accuracy"
require_relative "./TelecLib/12.BER"
require_relative "./TelecLib/13.PER"
POW = 20
DEV = 20 * (10**-6)
#DEV = 17 * (10**-6)
#DEV = 5 * (10**-6)
