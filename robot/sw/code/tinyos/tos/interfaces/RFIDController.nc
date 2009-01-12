// $Id: RFIDController.nc,v 1.1 2004/06/11 00:53:23 davidlee Exp $
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
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 */
/* 
 * @author David Lee
 */

/**
 * This interface provides control to an RFID reader. 
 */
interface RFIDController 
{
  
  /**
   * Initialize the RFID reader.
   *
   * @return SUCCESS/FAIL.
   */
  command result_t init();


  /**
   * Tries to read a numTags number of tags. It returns 
   * FAIL if the numTags exceeds the maximum number of 
   * readable tags, or the reader is busy handling a 
   * a previous request. Otherwise, it returns SUCCESS.
   * @return SUCCESS/FAIL 
   */
 command result_t findTags(int8_t numTags);

  /**
   * Triggered by RFID reader when the tag ids are reader to be
   * read.
   * @param uint8_t numTagsFound tells how many tags were read
   */
 event result_t findTagsDone(uint8_t numTagsFound);

 /**
   * Returns the ID held in the array at idnum. The number of
   * available IDs are returned in the findTagsDone function.
   * Returns NULL if the idnum is a bad index. Returns a byte
   * array of the tag id if idnum is valid. 
   * @param uint8_t idnum is the index of the tag
   * @return a byte array of the tag id
   */
 command uint8_t* getIDs(uint8_t idnum);

 /**
   * Tries to read the data stored on the tag with an id. 
   * It returns FAIL if the reader is busy handling a 
   * a previous request. Otherwise, it returns SUCCESS.
   * @param  uint8_t idnum is the index of the tag
   * @param void* bufptr is the pointer to the buffer which
   *  the data from the tag will be copied to
   * @param int length is the number of bytes requested from the tag
   * @return SUCCESS/FAIL 
   */
 command result_t readTag(uint8_t idnum, void* bufptr, int length);

  /**
   * Triggered by RFID reader when the tag data is read.
   * @param uint8_t numBytesRead is the number of bytes read
   */
 event result_t readTagDone(uint8_t numBytesRead);

 /**
   * Tries to write the data stored to the tag with an id.
   * It returns FAIL if the reader is busy handling a 
   * a previous request. Otherwise, it returns SUCCESS.
   * @param  uint8_t idnum is the index of the tag
   * @param void* bufptr is the pointer to the data being written
   * @param int length is the number of bytes to be written from the tag
   * @return SUCCESS/FAIL 
   */
 command result_t writeTag(uint8_t idnum, void* bufptr, int length);

  /**
   * Triggered by RFID reader when the tag data is written.
   * @param uint8_t numBytesRead is the number of bytes written
   */
 event result_t writeTagDone(bool isWriteSuccess);

}


