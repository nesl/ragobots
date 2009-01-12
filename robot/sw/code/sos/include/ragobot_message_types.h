/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4 shiftwidth=4 softtabstop=4 cindent: */
/*
 * Copyright (c) 2003 The Regents of the University of California.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above
 *    copyright notice, this list of conditions and the following
 *    disclaimer in the documentation and/or other materials provided
 *    with the distribution.
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgement:
 *       This product includes software developed by Networked &
 *       Embedded Systems Lab at UCLA
 * 4. Neither the name of the University nor that of the Laboratory
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 */
/**
 * @brief Ragobot Message related types and defines
 * @author David Lee
 */
#ifndef _RAGOBOT_MESSAGE_TYPES_H
#define _RAGOBOT_MESSAGE_TYPES_H

#include <pid.h>
#include <message_types.h>


enum {
	MSG_PUSHBUTTON_PRESSED =(KER_MSG_START + 15), //!< Pushbutton Pressed
	MSG_HIPRI_INT         = (KER_MSG_START + 16), //!< HIPRI_INT received
	MSG_ONE_WIRE_READ_DONE =(KER_MSG_START + 17), //!< ONE_WIRE finished reading
    MSG_IRRANGER_FINISHED = (KER_MSG_START + 18), //!< IR Rander finished reading
	MSG_UART0_READ_DONE =   (KER_MSG_START + 19),
	MSG_UART1_READ_DONE =   (KER_MSG_START + 20)
};

#endif
