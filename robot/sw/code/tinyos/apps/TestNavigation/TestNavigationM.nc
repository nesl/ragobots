// $Id: 
// $Log:

/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

 /**
  *
  * @author Anitha Vijayakumar avijayak@ee.ucla.edu
  **/

module TestNavigationM {
	provides{
		interface StdControl;
	}
	uses {
	  interface Navigation;
          interface Timer;
	}
}

implementation {
  uint16_t path[10][2];
  uint8_t i;
  
  task void  navigate(){
    call Navigation.moveTo(path[i][0],path[i][1]);
    i++;
    if(i == 9){
      i = 0;
    }
    return;
  }
  
	command result_t StdControl.init(){
	  path[0][0] = 100; path[0][1] = 100;
	  path[1][0] = 600; path[1][1] = 100;
	  path[2][0] = 600; path[2][1] = 200;
	  path[3][0] = 100; path[3][1] = 200;
	  path[4][0] = 100; path[4][1] = 300;
	  path[5][0] = 600; path[5][1] = 300;
	  path[6][0] = 600; path[6][1] = 400;
	  path[7][0] = 100; path[7][1] = 400;
	  path[8][0] = 100; path[8][1] = 450;
	  path[9][0] = 600; path[9][1] = 450;

	  i = 0;
	  call Navigation.init();
		return SUCCESS;
	}

	command result_t StdControl.start(){
	  call Timer.start(TIMER_ONE_SHOT ,5000);
	  return SUCCESS;
	}

	command result_t StdControl.stop(){
	  return SUCCESS;
	}
        event void Navigation.moveDone(uint16_t x, uint16_t y)
	{
	  call Timer.start(TIMER_ONE_SHOT ,10000);
	  return;
	}
        event result_t Timer.fired() {
	  post navigate();
	  return SUCCESS;
	}
}
