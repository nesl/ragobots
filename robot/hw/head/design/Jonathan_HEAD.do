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
	forget class CAM_NETS
	forget class 5V_NETS
	forget class 3V_NETS
	forget class AUD_NETS
	delete all wires
	
#INIT, DEFAULTS, AND GLOBAL
	unit mil
	status_file $/SpecctraWithinLayout.STS
	bestsave on $/SpecctraWithinLayout.WBEST

#Fix PAN_TILT Keepout Area that shouldn't be there
	mode delete keepout
	edit_delete_keepout -35 589 1867 -37

#Setup Power Distribution Nets
#5V Net Trunking
	assign_pin source J2 (pins 33)
	assign_pin terminator R1 (pins 1)
	assign_pin terminator R2 (pins 1)
	assign_pin terminator IRDAR1 (pins 3)
	assign_pin terminator MIC1 (pins 1)
	assign_pin terminator AMP1 (pins 4)
	assign_pin load C1 (pins 1)
	assign_pin load C6 (pins 1)
	assign_pin terminator U1 (pins 7)
	assign_supply VCC_CN (pin J2-33)	
	forget class 5V_NETS
	define (class 5V_NETS VCC_CN)
	rule class 5V_NETS (power_fanout (order pin_via_cap))
	
#3.3V Net Trunking
	assign_supply VCC_3.3_CN (pin J2-29)	
	forget class 3V_NETS
	define (class 3V_NETS VCC_3.3_CN)
	rule class 3V_NETS (power_fanout (order pin_via_cap))
	
#Camera Nets
	forget class CAM_NETS
	define (class CAM_NETS CAM_Y0 CAM_Y1 CAM_Y2 CAM_Y3 CAM_Y4 CAM_Y5 CAM_Y6 CAM_Y7 CAM_PCLK CAM_VSYNC CAM_HSYNC)
	circuit class CAM_NETS (priority 255)	
	unselect all nets
	select class CAM_NETS
#fence 113 950 1520 333
	zoom 113 950 1520 333
	
#Phase-matching
	rule class CAM_NETS (accordion_amplitude -1 7)
	rule class CAM_NETS (accordion_gap 7 )
	circuit class CAM_NETS (match_net_length on (tolerance 20))
	circuit class CAM_NETS (length 1300 1280 (type actual))
	rule class CAM_NETS (width 10)
	rule class CAM_NETS (ignore_gather_length off)

#route CAM_NETS	
	do route_me.do
	zoom all
	unselect all nets
	unselect all components
	delete fences
	
#dif-pair the audio
#shield the the audio

	forget class AUD_NETS
	define (class AUD_NETS N10585 N10682 N10643 N10614 MIC_OUT)
	rule class AUD_NETS (shield_tie_down_interval -1)
	rule class AUD_NETS (shield_gap 7)
	rule class AUD_NETS (shield_width 10)
	circuit class AUD_NETS (shield on (type parallel) (use_net  GND_CN))
	

	
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
	do route_me.do