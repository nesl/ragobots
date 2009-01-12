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
forget class USB_NETS
forget class I2C_NETS
	
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
	rule PCB (width 7)

# Layer use penalties	
cost layer TOP low  (type length)
cost layer INNER1 low  (type length)
cost layer INNER2 low  (type length)
cost layer BOTTOM medium  (type length)

#Layer directions
direction TOP orthogonal
direction INNER1 horizontal
direction INNER2 vertical
direction BOTTOM orthogonal


###############################################################################
# DIFFERENTIAL/BALANCED WIRING
###############################################################################

#### VIDEO BUS
define (class MPL_NETS DB* LCD_A0 LCD_E* LCD_R*)
# Diff_Pair Rules
circuit class MPL_NETS (match_net_length on (tolerance 20))
circuit class MPL_NETS (length 1.01 .99 (type ratio))
rule class MPL_NETS (accordion_amplitude 50 14)
rule class MPL_NETS (accordion_gap 7 )
rule class MPL_NETS (patterns_allowed   accordion )
#Priority
circuit class MPL_NETS (priority 100)

#### USB
define (class USB_NETS USB_A0 USB_B0 USB_A1 USB_B1)
define (pair (nets USB_A0 USB_B0))
define (pair (nets USB_A1 USB_B1))
# Diff_Pair Rules
rule class USB_NETS (ignore_gather_length unspecified)
rule class USB_NETS  (neck_down_width 7)
rule class USB_NETS (neck_down_gap 7)
rule class USB_NETS (diffpair_line_width 12)
rule class USB_NETS (edge_primary_gap 7)

#### I2C
define (class I2C_NETS INTERNAL_I2C_* I2C_*)
define (pair (nets I2C_SDA I2C_SCL))
define (pair (nets INTERNAL_I2C_SDA INTERNAL_I2C_SCL))
# Diff_Pair Rules
rule class I2C_NETS (ignore_gather_length unspecified)
rule class I2C_NETS  (neck_down_width 7)
rule class I2C_NETS (neck_down_gap 7)
rule class I2C_NETS (diffpair_line_width 8)
rule class I2C_NETS (edge_primary_gap 7)



###############################################################################
# SHIELDED WIRING
###############################################################################

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