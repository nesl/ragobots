#################################################################################
# RAGOBOT:IRMAN MAKEFILE
# ------------------------------------------------------------------------------
# Builds code for the integrated controller of the RAGOBOT Robot
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
# Networked and Embedded Systems Laboratory (NESL)
# University of California, Los Angeles (UCLA)
#
# REVISION HISTORY
# ------------------------------------------------------------------------------
# Original AVR-GCC makefile from Andreas Savvides                                
# Modified by Vlasios Tsiatsis, UCLA                                            
# Modified for RAGOBOT:IRMAN by Jonathan Friedman, UCLA (jf@ee.ucla.edu)
# Modified for RAGOBOT.B2:IRMAN by David Lee, UCLA (davidlee@ee.ucla.edu) 		
#################################################################################

MICRO		:= atmega168
AS          := avr-as
LD          := avr-gcc
CC          := avr-gcc 
CPP         := avr-cpp
OBJCOPY     := avr-objcopy
OBJDUMP		:= avr-objdump

####
# Begin by grabbing the platform we are building for
####
PLATLIST = B1 B2
PLATFORM = $(filter $(PLATLIST), $(MAKECMDGOALS))
ifeq ($(PLATFORM), B2)
DEFS = -D_B2_
endif

CFLAGS      := -c -g -O3 -Wall -Wa,-adhlmsn=ram.lst -D__AVR_CODE__ -I$(PREFIX)/avr/include -mmcu=$(MICRO) -D$(MICRO) $(DEFS)
C_SRC_DIR   := ../src

SFLAGS      := -g -S -Os -I$(PREFIX)/avr/include -mmcu=$(MICRO)
LDFLAGS     := -L$(PREFIX)/lib/gcc-lib/avr/3.0 
LIBS        := -lgcc  
PROGRAMER   := uisp

EXEC        := irman
EXTENSION   := elf

C_FILES     :=  $(EXEC).c motor.c cb4.c ircomm.c uart0.c i2c.c eeprom1.c

OBJ_FILES   := $(C_FILES:.c=.o)  
C_SRC_FILES := $(addprefix $(C_SRC_DIR)/,  $(C_FILES))



 
#%.s: %.S
#	$(CPP) $< $@ 

#%.o : %.s
#	$(AS) $< -o $@ 

#%.s : %.c
#	$(CC) $(SFLAGS) -o $@ $<

%.o : $(C_SRC_DIR)/%.c 
	$(CC) $(CFLAGS) -o $make@ $<

#%: %.o
#	$(LD) $< -o $@ $(LIBS)

all: clean $(EXEC).$(EXTENSION)

B2: clean $(EXEC).$(EXTENSION)
	@echo "Compiling for B2";
	
	
%.srec : %.$(EXTENSION)
	$(OBJCOPY) --output-target=srec $< $@
		
install: $(EXEC).srec
	@echo  "Trying to install on Mica ..."
	-dt_sck=15
	$(PROGRAMER) -dprog=stk200 -dlpt=0x378 -dno-poll -dt_sck=10 -dpart=$(MICRO) --erase ; sleep 3
	$(PROGRAMER) -dprog=stk200 -dlpt=0x378 -dno-poll -dt_sck=10 -dpart=$(MICRO) --upload if=$<; sleep 2
	$(PROGRAMER) -dprog=stk200 -dlpt=0x378 -dno-poll -dt_sck=10 -dpart=$(MICRO) --verify if=$<
	$(PROGRAMER) -dprog=stk200 -dlpt=0x378 -dno-poll -dt_sck=10 -dpart=$(MICRO) --version

$(EXEC).$(EXTENSION): $(OBJ_FILES)
	$(CC) -Xlinker -M -o $@  -mmcu=$(MICRO) $(OBJ_FILES) > img.file
	grep _e img.file | grep =\.   
	#$(OBJCOPY) --debugging -O coff-ext-avr --change-section-address .data-0x800000 --change-section-address .bss-0x800000 --change-section-address .noinit-0x800000 --change-section-address .eeprom-0x810000 $(EXEC).$(EXTENSION) $(EXEC).cof
	$(OBJCOPY) -O ihex $(EXEC).$(EXTENSION) $(EXEC).hex
	$(OBJDUMP) -h -S $(EXEC).elf > $(EXEC).asm

	
clean:
	rm -f *.s *.o $(EXEC).$(EXTENSION) $(EXEC).srec img.file $(EXEC).hex


