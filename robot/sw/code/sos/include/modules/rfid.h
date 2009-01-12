//$Id: 
//$Log:

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
#ifndef __RFID__H__
#define __RFID__H__

#define MAXNUMTAGS  	   3
#define MAXIDLENGTH        9

//MESSAGE TYPES
enum 
{
  //Find the RFID tags in the region and return their IDs
  MSG_RFID_FINDTAGS = (MOD_MSG_START+0),
  //Read from the tag with a specific ID
  MSG_RFID_READTAGS = (MOD_MSG_START+1),
  //Write to the tag with a specific ID
  MSG_RFID_WRITETAGS = (MOD_MSG_START+2),
  //Find the RFID tags in the region and return their IDs FINISHED SUCCESSFUL
  MSG_RFID_FINDTAGS_DONE = (MOD_MSG_START+8),
  //Read from the tag with a specific ID FINISHED SUCCESSFUL
  MSG_RFID_READTAGS_DONE = (MOD_MSG_START+9),
  //Write to the tag with a specific ID FINISHED SUCCESSFUL
  MSG_RFID_WRITETAGS_DONE = (MOD_MSG_START+10), 

  //Find the RFID tags in the region FAILED
  MSG_RFID_FINDTAGS_FAIL = (MOD_MSG_START+11),
  //Read from the tag with a specific ID FAILED
  MSG_RFID_READTAGS_FAIL = (MOD_MSG_START+12),
  //Write to the tag with a specific ID FAILED
  MSG_RFID_WRITETAGS_FAIL = (MOD_MSG_START+13), 

  MSG_RFID_PARSE_DATA = (MOD_MSG_START+14)
};

typedef struct
{
  uint8_t datalen;
  uint8_t id[MAXIDLENGTH];
  uint8_t *data;
} rfid_data_t;

typedef struct
{
  uint8_t numids;
  uint8_t ids[MAXNUMTAGS][MAXIDLENGTH];
} idtable_t;

int8_t rfid_module_init();	
#endif
