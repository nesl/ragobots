# Use Python syntax hilighting

forget class MPL_NETS
forget class SIO_NETS
forget class I2C_NETS
forget class CB2C_NETS
forget class BRAIN_CB2_NETS 
forget class NERVE_CB2_NETS
forget class DIFF_PAIRS
forget class ANALOG_NETS
forget class AUDIO_NETS

#Fix PAN_TILT Keepout Area that shouldn't be there
	mode delete keepout
	edit_delete_keepout 2167 1348 2396 1208
	

###############################################################################
# DIFFERENTIAL/BALANCED WIRING
###############################################################################

#### MPL
define (class MPL_NETS MPL*)
define (bundle MPL_BUNDLE (nets MPL*))
# Diff_Pair Rules
rule class MPL_NETS (ignore_gather_length unspecified)
rule class MPL_NETS  (neck_down_width 5)
rule class MPL_NETS (neck_down_gap 5)
rule class MPL_NETS (diffpair_line_width 8)
rule class MPL_NETS (edge_primary_gap 30)

#### SIO
define (class SIO_NETS SIOC SIOD)
define (pair (nets SIOC SIOD))
# Diff_Pair Rules
rule class SIO_NETS (ignore_gather_length unspecified)
rule class SIO_NETS  (neck_down_width 5)
rule class SIO_NETS (neck_down_gap 5)
rule class SIO_NETS (diffpair_line_width 8)
rule class SIO_NETS (edge_primary_gap 15)

#### I2C
define (class I2C_NETS I2C_SDA* I2C_SCL*)
define (pair (nets I2C_SDA_5 I2C_SCL_5))
define (pair (nets I2C_SDA I2C_SCL))
# Diff_Pair Rules
rule class I2C_NETS (ignore_gather_length unspecified)
rule class I2C_NETS  (neck_down_width 5)
rule class I2C_NETS (neck_down_gap 5)
rule class I2C_NETS (diffpair_line_width 8)
rule class I2C_NETS (edge_primary_gap 15)

#### AUDIO
define (class AUDIO_NETS AUDIO*)
define (pair (nets AUDIO?+ AUDIO?-))
# Nets AUDIOn+ and AUDIOn- have been defined as a balanced pair.
# Covers all nets in AUDIO0+,- format
# Diff_Pair Rules
rule class AUDIO_NETS (ignore_gather_length unspecified)
rule class AUDIO_NETS  (neck_down_width 5)
rule class AUDIO_NETS (neck_down_gap 5)
rule class AUDIO_NETS (diffpair_line_width 8)
rule class AUDIO_NETS (edge_primary_gap 6)

#### CB2 CONTROL
define (class CB2C_NETS CB2_Reset CB2_Clock CB2_Update)
define (bundle CB2C_BUNDLE (nets CB2_Reset CB2_Clock CB2_Update))
# Diff_Pair Rules
rule class CB2C_NETS (ignore_gather_length unspecified)
rule class CB2C_NETS  (neck_down_width 5)
rule class CB2C_NETS (neck_down_gap 5)
rule class CB2C_NETS (diffpair_line_width 8)
rule class CB2C_NETS (edge_primary_gap 15)

define (class BRAIN_CB2_NETS BRAIN_CB2*)
define (bundle BRAIN_CB2_BUNDLE (nets BRAIN_CB2*))
# Diff_Pair Rules
rule class BRAIN_CB2_NETS (ignore_gather_length unspecified)
rule class BRAIN_CB2_NETS  (neck_down_width 5)
rule class BRAIN_CB2_NETS (neck_down_gap 5)
rule class BRAIN_CB2_NETS (diffpair_line_width 8)
rule class BRAIN_CB2_NETS (edge_primary_gap 15)

define (class NERVE_CB2_NETS NERVE_CB2*)
define (bundle NERVE_CB2_BUNDLE (nets NERVE_CB2*))
# Diff_Pair Rules
rule class NERVE_CB2_NETS (ignore_gather_length unspecified)
rule class NERVE_CB2_NETS  (neck_down_width 5)
rule class NERVE_CB2_NETS (neck_down_gap 5)
rule class NERVE_CB2_NETS (diffpair_line_width 8)
rule class NERVE_CB2_NETS (edge_primary_gap 15)


###############################################################################
# SHIELDED WIRING
###############################################################################

define (class ANALOG_NETS ANALOG*)
rule class ANALOG_NETS (shield_tie_down_interval 2000)
rule class ANALOG_NETS (shield_gap 5)
circuit class ANALOG_NETS (shield on (type parallel) (use_net  DGND_CN))



sh echo DONE!