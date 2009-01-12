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
	unprotect all wires
	delete all wires
	
#INIT, DEFAULTS, AND GLOBAL
	unit mil
	status_file $/SpecctraWithinLayout.STS
	bestsave on $/SpecctraWithinLayout.WBEST

#Setup Power Distribution Nets
	assign_supply 5_VCC_CN (pin NECK-9)	
	assign_supply 5_VCC_CN (pin NECK-1)	
	assign_supply 5_VCC_CN (pin BODY-30)	
	assign_supply 3.3_VCC_CN (pin NECK-2)	
	assign_supply 3.3_VCC_CN (pin BODY-31)	
	assign_supply 5_AVCC_CN (pin NECK-6)	
	assign_supply VBAT_VCC_CN (pin BODY-33)	

#FANOUT THE CONNECTORS BECAUSE THIS IS PROBLEM AREA
	select component BODY
#fanout 10 (direction  in_out ) (location anywhere) (max_len -1) (pin_type all)  (pin_share on) (via_share on) (smd_share on) (share_len -1)   (smart_via_grid two_wire_between preferred)
	fanout 5 (smart_via_grid two_wire_between) (location anywhere)
	fanout 5 (smart_via_grid one_wire_between preferred) (location anywhere)
	grid via .100
	fanout 5 (via_grid .025) (location outside)

unselect all components
select component NECK
#fanout 10 (direction  in_out ) (location anywhere) (max_len -1) (pin_type all)  (pin_share on) (via_share on) (smd_share on) (share_len -1)   (smart_via_grid two_wire_between preferred)
	fanout 5 (smart_via_grid two_wire_between) (location anywhere)
	fanout 5 (smart_via_grid one_wire_between preferred) (location anywhere)
	grid via .100
	fanout 5 (via_grid .025) (location outside)

	
	unselect all nets
	unselect all components
	
		
#PRE-ROUTE
	sh echo +++++
	sh echo PRE-ROUTE
	sh echo +++++
#select all nets
#select all components
	bus diagonal
	fanout 4 (direction   in_out) (location anywhere) (max_len -1)  (pin_type power) (pin_type signal)    (pin_share on (maximum_connections 2)) (via_share on (maximum_connections 2)) (smd_share on (maximum_connections 2)) (share_len -1)   
	seedvia 1000 -force

#ROUTE!
	do route_me.do