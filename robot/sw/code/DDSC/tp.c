/*
  #################################################################################
  # RAGOBOT: DDSC TEST POINT AND LED CONTROL
  # ------------------------------------------------------------------------------
  # Controls and processes the IR sensors of IRMAN
  # 
  # APPLIES TO (Ragobot Part Numbers):
  # ------------------------------------------------------------------------------
  # RBTBDYB
  #
  # COPYRIGHT NOTICE
  # ------------------------------------------------------------------------------
  # "Copyright (c) 2000-2003 The Regents of the University  of California.
  # All rights reserved.
  # Permission to use, copy, modify, and distribute this software and its
  # documentation for any purpose, without fee, and without written agreement is
  # hereby granted, provided that the above copyright notice, the following
  # two paragraphs and the author appear in all copies of this software.
  # IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
  # DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
  # OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
  # CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  # THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
  # INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
  # AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
  # ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
  # PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
  #
  # DEVELOPED BY
  # ------------------------------------------------------------------------------
  # Jonathan Friedman, GSR
  # Networked and Embedded Systems Laboratory (NESL)
  # University of California, Los Angeles (UCLA)
  #
  # REVISION HISTORY
  # ------------------------------------------------------------------------------
  # <see CVS for additional comments and dates of revisions> 
  # Original by Jonathan Friedman, UCLA (jf@ee.ucla.edu)
  #################################################################################
*/

#include <inttypes.h>
#include <avr/io.h>
#include "tp.h"
#include "utilities.h"

//----------------------------------------------------------------
//- INIT ROUTINES
//----------------------------------------------------------------

inline void init_tp(){
	sbi(DDRB, 1);
	sbi(DDRD, 5);
	sbi(DDRD, 6);	
}

//----------------------------------------------------------------
//- COMMAND ROUTINES
//----------------------------------------------------------------

//Test Point LED (D_DDSC)
inline void tpl(uint8_t cmd){
	switch(cmd){
		case ON:
			sbi(PORTB, 6);
			break;
		case OFF:
			cbi(PORTB, 6);
			break;
		case TOGGLE:
			tbi(PORTB, 6);
			break;
		default:
			break;
	}
}

//Test Point 7
inline void tp7(uint8_t cmd){
	switch(cmd){
		case ON:
			sbi(PORTD, 0);
			break;
		case OFF:
			cbi(PORTD, 0);
			break;
		case TOGGLE:
			tbi(PORTD, 0);
			break;
		default:
			break;
	}
}

//Test Point 8
inline void tp8(uint8_t cmd){
	switch(cmd){
		case ON:
			sbi(PORTD, 1);
			break;
		case OFF:
			cbi(PORTD, 1);
			break;
		case TOGGLE:
			tbi(PORTD, 1);
			break;
		default:
			break;
	}
}
