// $Id: TestLocalizationM.nc,v 1.3 2004/10/20 21:30:24 parixit Exp $
// $Log: TestLocalizationM.nc,v $
// Revision 1.3  2004/10/20 21:30:24  parixit
// Updated to use new Localization interface.
//

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
  * @author Parixit Aghera parixit@cs.ucla.edu
  **/

module TestLocalizationM {
	provides{
		interface StdControl;
	}
	uses {
	  interface Localization;
	}
}

implementation {

	command result_t StdControl.init(){
		return SUCCESS;
	}

	command result_t StdControl.start(){
	  call Localization.getLocation();
	  return SUCCESS;
	}

	command result_t StdControl.stop(){
	  return SUCCESS;
	}

	event void Localization.location(LocalizationInfo *l)
	  {
	    return;
	  }
      
}
