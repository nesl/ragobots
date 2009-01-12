# Jonathan Friedman, GSR
# NESL, UCLA
#
# RAGOBOT PROJECT; MANUALLY-TUNED SPECCTRA CONFIG FILE
#
# Cadence Design Systems, Inc.
# SPECCTRA ShapeBased Automation Software Automatic Router
# SPECCTRA ShapeBased Automation Software V15.1 made 2003/11/17 at 23:03:32
# Running on host 

# Use Python syntax hilighting

#BOOT!
	select_product  SPECCTRAQuest SI expert
	zoom all

#RESET (because we want to preserve all of the manual routing, we can not run this multiple times)
# protect all wires	

forget class MPL_NETS
forget class SIO_NETS
forget class I2C_NETS
forget class CB2C_NETS
forget class BRAIN_CB2_NETS 
forget class NERVE_CB2_NETS
forget class DIFF_PAIRS
forget class ANALOG_NETS
forget class AUDIO_NETS
	
###############################################################################
# INIT, DEFAULTS, AND GLOBAL
###############################################################################

# Units 
	unit mil

# Paths
	status_file $/SpecctraWithinLayout.STS
	bestsave on $/SpecctraWithinLayout.WBEST


# Fix PAN_TILT Keepout Area that shouldn't be there
	mode delete keepout
	edit_delete_keepout 2167 1348 2396 1208

# Default wire width
	rule PCB (width 6)

# Layer use penalties	
cost layer TOP medium  (type length)
cost layer BOTTOM medium  (type length)
cost layer INNER2 low  (type length)
cost layer INNER3 low  (type length)
cost layer INNER4 low  (type length)

#Layer directions
direction TOP orthogonal
direction BOTTOM orthogonal
direction INNER2 horizontal
direction INNER3 vertical
direction INNER4 horizontal

	
	
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
#Priority
circuit class MPL_NETS (priority 200)

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

#### COMPASS_SR
define (class SR_NETS SENS_NOT*)
define (pair (nets SENS_NOT_A SENS_NOT_Y))
# Diff_Pair Rules
rule class SR_NETS (ignore_gather_length unspecified)
rule class SR_NETS  (neck_down_width 5)
rule class SR_NETS (neck_down_gap 5)
rule class SR_NETS (diffpair_line_width 8)
rule class SR_NETS (edge_primary_gap 6)

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
#rule class ANALOG_NETS (shield_tie_down_interval 2000)
#rule class ANALOG_NETS (shield_gap 5)
#circuit class ANALOG_NETS (shield on (type parallel) (use_net  DGND_CN))
#Priority
circuit class ANALOG_NETS (priority 190)


###############################################################################
# ROUTE ME BABY!
###############################################################################

#PRE-ROUTE
	sh echo +++++
	sh echo PRE-ROUTE
	sh echo +++++
	select all nets
	select all components
	fanout 4 (direction   in_out) (location anywhere) (max_len -1)  (pin_type power) (pin_type signal)    (pin_share on (maximum_connections 2)) (via_share on (maximum_connections 2)) (smd_share on (maximum_connections 2)) (share_len -1)   
	seedvia 1000 -force

#ROUTE!

unit mil
status_file $/SpecctraWithinLayout.STS
bestsave on $/SpecctraWithinLayout.WBEST

 tax cross 1.2
 tax squeeze .5

sh echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxDEBUG!
sh echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxDEBUG!
sh echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxDEBUG!
sh echo WHILE_LOOP!................................................................................................................................

#select all routing

#################################
#### Initial Route phase

route 1
if (complete_wire < 100)
      then (clean 2)

#### Route phase 1
#
setexpr count (3)
	
while (count >0 && complete_wire < 100) 
      (
      
       setexpr comp_rate (complete_wire)
       route 5 11
       if (complete_wire < 100 && complete_wire > comp_rate)
          then (
                setexpr count (count - 1)
               )
          else (setexpr count (0))
      )
sh echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
delete conflicts -segment
sh echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sh echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sh echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#### Route phase 2
#
if (complete_wire < 100)
      then (clean 2)
setexpr count2 (5)
while (count2 >0 && complete_wire < 100) 
      (       
       setexpr comp_rate2 (complete_wire)
       route 5 16
       if (complete_wire > comp_rate2)
          then (
                setexpr count2 (count2 - 1)
               )
          else (
                setexpr count2 (0)
               )
      )
sh echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sh echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
delete conflicts -segment
sh echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sh echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#### Route phase 3
#
if (complete_wire < 100)
      then (clean 3)
setexpr count3 (10)
while (count3 >0 && complete_wire < 100) 
      (       
       setexpr comp_rate3 (complete_wire)
       route 5 16
       if (complete_wire > comp_rate3)
          then (
                setexpr count3 (count3 - 1)
               )
          else (
                filter 5
                limit cross 0
                route 25 16
                setexpr count3 (0)
               )
      )
#
#### Final Cleanup
#
#delete conflicts
critic 5
clean 5
#
# uncomment out the miter commands below to miter your corners
#
 unit mil
 miter (slant 1000)
 miter (pin 50)
 miter (bend 32 2)
#
write routes $/SpecctraWithinLayout.RTE
report status

sh echo DONE!	