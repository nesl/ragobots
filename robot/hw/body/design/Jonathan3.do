# Jonathan Friedman, GSR
# NESL, UCLA
#
# RAGOBOT PROJECT; MANUALLY-TUNED SPECCTRA CONFIG FILE
#
# Cadence Design Systems, Inc.
# SPECCTRA ShapeBased Automation Software Automatic Router
# SPECCTRA ShapeBased Automation Software V15.1 made 2003/11/17 at 23:03:32
# Running on host 

#BOOT!
	select_product  SPECCTRAQuest SI expert

#RESET (in case running this multiple times in a row
	forget class IRMAN_NETS
#	delete all wires
	
#INIT, DEFAULTS, AND GLOBAL
	unit mil
	status_file $/SpecctraWithinLayout.STS
	bestsave on $/SpecctraWithinLayout.WBEST

#Select IRMAN
	unselect all nets
	unselect all components
	select component U11 

#Fix PAN_TILT Keepout Area that shouldn't be there
	mode delete keepout
	edit_delete_keepout 1865 2098 2698 221
	
#Add IRMAN interior Via Keepout
	mode edit keepout
	area init_pt 2516.4 1226.6
	area add_pt 2666.3 1078.1
	area close_poly
	define (via_keepout keepout1 (digitize (layer  signal)))

#Fanout IRMAN
	sh echo +++++
	sh echo PRE-FAN IRMAN
	sh echo +++++
	fanout 2 (direction  out ) (location anywhere) (max_len -1) (pin_type all)  (pin_share on (maximum_connections 2)) (via_share on (maximum_connections 2)) (smd_share on (maximum_connections 2)) (share_len -1)   	
	clean 4
	
#IRMAN routing priority set to very high
	define (class IRMAN_NETS irman_hi motor_dir0 motor_dir1 ir_cliff0 ir_cliff1 cb3_load x_irman_cb4reset x_irman_cb4select x_irman_cbxclock i2c_scl i2c_sda irman_reset ir_cliff_analog0 ir_cliff_analog1 x_irman_uart_rx x_irman_uart_tx cb3_dataout led_encode_40khz at_base motor_pwm0 motor_pwm1 x_irman_cb4data 3.3_VCC_CN)
	circuit class IRMAN_NETS (priority 255)

#PRE-ROUTE
	sh echo +++++
	sh echo PRE-ROUTE
	sh echo +++++
	select all nets
	select all components
	bus diagonal
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

select all routing

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

