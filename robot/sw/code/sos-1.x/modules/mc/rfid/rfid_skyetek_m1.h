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

/*
 * This header files defines the constants used in the Skyetek M1 RFID protocol
 */

/* Tag Types */
#define 	AUTO_DETECT	0x00
#define 	ISO15693        0x01
#define 	I_CODE1		0x02
#define 	TAG_IT_HF	0x03
#define		ISO14443A	0x04
#define		ISO14443B	0x05
#define 	PICOTAG		0x06
#define		GEMWAVE		0x08

/* system commands */
#define         SELECT_TAG      0x14
#define         READ_MEM        0x21    /* reads */
#define         READ_SYS        0x22
#define         READ_TAG        0x24
#define         WRITE_MEM       0x41    /* writes */
#define         WRITE_SYS       0x42
#define         WRITE_TAG       0x44

/* flags */
/* NOTE: CRC_F must be set in binary mode */
#define         RW_TAG_SS       0x28
#define         RW_TAG_TID      0x60
#define         LOCK_TAG_SS     0x2C
#define         LOCK_TAG_TID    0x64

/* select tag flags for selectTag function */

/* selects a tag without a unique tag ID provided*/
#define         SEL_TAG         0x20
/* selects a tag with a unique tag Id and puts it in selected state */
#define         SEL_TAG_TID     0x68
/* find all available tags in the rf field of the reader */
#define		SEL_TAG_INV	0x22
/*  poll continuously for all tags in the rf field of the reader */
#define	 	SEL_TAG_INV_LOOP	0x23
/* select a tag by AFI value */
#define			SEL_TAG_AFI		0x30
/* find all available tags with AFI value specified in the rf field of the reader */
#define		SEL_TAG_INV_AFI		0x32
/* poll continuously for all tags with AFI value specified in the rf field of the reader */
#define		SEL_TAG_INV_AFI_LOOP	0x33

/* read tag flags for readTag function */

#define         STX             0x02

/* Response */
#define         SEL_TAG_PASS          0x14
#define         SEL_TAG_LOOP_ACTIV    0x1C
#define         SEL_TAG_FAIL          0x94
#define         SEL_TAG_LOOP_CANCEL   0x9C
#define         READ_MEM_PASS         0x21
#define         READ_SYS_PASS         0x22
#define         READ_TAG_PASS         0x24
#define         READ_MEM_FAIL         0xA1
#define         READ_SYS_FAIL         0xA2
#define         READ_TAG_FAIL         0xA4
#define         WRITE_MEM_PASS        0x41
#define         WRITE_SYS_PASS        0x42
#define         WRITE_TAG_PASS        0x44
#define         WRITE_MEM_FAIL        0xC1
#define         WRITE_SYS_FAIL        0xC2
#define         WRITE_TAG_FAIL        0xC4


