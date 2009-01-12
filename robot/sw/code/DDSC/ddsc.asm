
ddsc.elf:     file format elf32-avr

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .data         00000000  00800100  0000123e  000012d2  2**0
                  CONTENTS, ALLOC, LOAD, DATA
  1 .text         0000123e  00000000  00000000  00000094  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  2 .bss          000000fd  00800100  00800100  000012d2  2**0
                  ALLOC
  3 .noinit       00000000  008001fd  008001fd  000012d2  2**0
                  CONTENTS
  4 .eeprom       00000000  00810000  00810000  000012d2  2**0
                  CONTENTS
  5 .debug_aranges 00000050  00000000  00000000  000012d2  2**0
                  CONTENTS, READONLY, DEBUGGING
  6 .debug_pubnames 000001fe  00000000  00000000  00001322  2**0
                  CONTENTS, READONLY, DEBUGGING
  7 .debug_info   00000ce4  00000000  00000000  00001520  2**0
                  CONTENTS, READONLY, DEBUGGING
  8 .debug_abbrev 0000037d  00000000  00000000  00002204  2**0
                  CONTENTS, READONLY, DEBUGGING
  9 .debug_line   0000097e  00000000  00000000  00002581  2**0
                  CONTENTS, READONLY, DEBUGGING
 10 .debug_str    000001eb  00000000  00000000  00002eff  2**0
                  CONTENTS, READONLY, DEBUGGING
Disassembly of section .text:

00000000 <__vectors>:
       0:	0c 94 34 00 	jmp	0x68
       4:	0c 94 4f 00 	jmp	0x9e
       8:	0c 94 4f 00 	jmp	0x9e
       c:	0c 94 4f 00 	jmp	0x9e
      10:	0c 94 4f 00 	jmp	0x9e
      14:	0c 94 4f 00 	jmp	0x9e
      18:	0c 94 4f 00 	jmp	0x9e
      1c:	0c 94 4f 00 	jmp	0x9e
      20:	0c 94 4f 00 	jmp	0x9e
      24:	0c 94 4f 00 	jmp	0x9e
      28:	0c 94 4f 00 	jmp	0x9e
      2c:	0c 94 4f 00 	jmp	0x9e
      30:	0c 94 4f 00 	jmp	0x9e
      34:	0c 94 4f 00 	jmp	0x9e
      38:	0c 94 4f 00 	jmp	0x9e
      3c:	0c 94 4f 00 	jmp	0x9e
      40:	0c 94 4f 00 	jmp	0x9e
      44:	0c 94 4f 00 	jmp	0x9e
      48:	0c 94 4f 00 	jmp	0x9e
      4c:	0c 94 4f 00 	jmp	0x9e
      50:	0c 94 4f 00 	jmp	0x9e
      54:	0c 94 4f 00 	jmp	0x9e
      58:	0c 94 4f 00 	jmp	0x9e
      5c:	0c 94 4f 00 	jmp	0x9e
      60:	0c 94 88 08 	jmp	0x1110
      64:	0c 94 4f 00 	jmp	0x9e

00000068 <__ctors_end>:
      68:	11 24       	eor	r1, r1
      6a:	1f be       	out	0x3f, r1	; 63
      6c:	cf ef       	ldi	r28, 0xFF	; 255
      6e:	d4 e0       	ldi	r29, 0x04	; 4
      70:	de bf       	out	0x3e, r29	; 62
      72:	cd bf       	out	0x3d, r28	; 61

00000074 <__do_copy_data>:
      74:	11 e0       	ldi	r17, 0x01	; 1
      76:	a0 e0       	ldi	r26, 0x00	; 0
      78:	b1 e0       	ldi	r27, 0x01	; 1
      7a:	ee e3       	ldi	r30, 0x3E	; 62
      7c:	f2 e1       	ldi	r31, 0x12	; 18
      7e:	02 c0       	rjmp	.+4      	; 0x84

00000080 <.do_copy_data_loop>:
      80:	05 90       	lpm	r0, Z+
      82:	0d 92       	st	X+, r0

00000084 <.do_copy_data_start>:
      84:	a0 30       	cpi	r26, 0x00	; 0
      86:	b1 07       	cpc	r27, r17
      88:	d9 f7       	brne	.-10     	; 0x80

0000008a <__do_clear_bss>:
      8a:	11 e0       	ldi	r17, 0x01	; 1
      8c:	a0 e0       	ldi	r26, 0x00	; 0
      8e:	b1 e0       	ldi	r27, 0x01	; 1
      90:	01 c0       	rjmp	.+2      	; 0x94

00000092 <.do_clear_bss_loop>:
      92:	1d 92       	st	X+, r1

00000094 <.do_clear_bss_start>:
      94:	ad 3f       	cpi	r26, 0xFD	; 253
      96:	b1 07       	cpc	r27, r17
      98:	e1 f7       	brne	.-8      	; 0x92
      9a:	0c 94 6b 00 	jmp	0xd6

0000009e <__bad_interrupt>:
      9e:	0c 94 00 00 	jmp	0x0

000000a2 <init_mcu>:
  // 4)		PGM/DDSC_ALERT; output; default 0 (inactive)
  // 3)		PGM/Nerve_EN; output; default disabled
  // 2,1)	Enable lines for various; outputs; default disabled
  // 0)		HEAD electrical fault; input; pull-up enabled
  PORTB = B8(00100001);
      a2:	41 e2       	ldi	r20, 0x21	; 33
      a4:	45 b9       	out	0x05, r20	; 5
  DDRB =  B8(11011110);
      a6:	3e ed       	ldi	r19, 0xDE	; 222
      a8:	34 b9       	out	0x04, r19	; 4

  // Port C initialization
  // 7-4)	DNC, Reset, I2C; inputs or overridden; no pull-up
  // 3-0)	Electrical fault; inputs; pull-up enabled
  PORTC= B8(00001111);
      aa:	2f e0       	ldi	r18, 0x0F	; 15
      ac:	28 b9       	out	0x08, r18	; 8
  DDRC = B8(00000000);
      ae:	17 b8       	out	0x07, r1	; 7

  // Port D initialization
  // 7-2)	Device Discovery inputs; externally pulled-up
  // 1-0)	Enable lines for FOOT0, FOOT1 interfaces; output; no pull-up
  PORTD= B8(00000000);
      b0:	1b b8       	out	0x0b, r1	; 11
  DDRD = B8(00000011);
      b2:	83 e0       	ldi	r24, 0x03	; 3
      b4:	8a b9       	out	0x0a, r24	; 10
      b6:	08 95       	ret

000000b8 <stall>:
		
} //init_MCU

void stall(uint16_t limit){
  uint16_t blah, i, j;
  blah=0;
      b8:	40 e0       	ldi	r20, 0x00	; 0
      ba:	50 e0       	ldi	r21, 0x00	; 0
  for(i=0;i<0xFFFF;i++){
    for(j=0;j<limit;j++){
      bc:	00 97       	sbiw	r24, 0x00	; 0
      be:	21 f0       	breq	.+8      	; 0xc8
      c0:	9c 01       	movw	r18, r24
      c2:	21 50       	subi	r18, 0x01	; 1
      c4:	30 40       	sbci	r19, 0x00	; 0
      c6:	e9 f7       	brne	.-6      	; 0xc2
      c8:	4f 5f       	subi	r20, 0xFF	; 255
      ca:	5f 4f       	sbci	r21, 0xFF	; 255
      cc:	2f ef       	ldi	r18, 0xFF	; 255
      ce:	4f 3f       	cpi	r20, 0xFF	; 255
      d0:	52 07       	cpc	r21, r18
      d2:	a1 f7       	brne	.-24     	; 0xbc
      d4:	08 95       	ret

000000d6 <main>:
      blah++;
    }
  }	
}

int main(void){
      d6:	cf ef       	ldi	r28, 0xFF	; 255
      d8:	d4 e0       	ldi	r29, 0x04	; 4
      da:	de bf       	out	0x3e, r29	; 62
      dc:	cd bf       	out	0x3d, r28	; 61
      de:	41 e2       	ldi	r20, 0x21	; 33
      e0:	45 b9       	out	0x05, r20	; 5
      e2:	3e ed       	ldi	r19, 0xDE	; 222
      e4:	34 b9       	out	0x04, r19	; 4
      e6:	2f e0       	ldi	r18, 0x0F	; 15
      e8:	28 b9       	out	0x08, r18	; 8
      ea:	17 b8       	out	0x07, r1	; 7
      ec:	1b b8       	out	0x0b, r1	; 11
      ee:	83 e0       	ldi	r24, 0x03	; 3
      f0:	8a b9       	out	0x0a, r24	; 10
	uint8_t blah; //xxx DEBUG ONLY DELETE ME!
	
	init_mcu();
	init_serial(UART); //debugging only (will override FOOT enable lines)
      f2:	8c e0       	ldi	r24, 0x0C	; 12
      f4:	0e 94 9e 00 	call	0x13c
	init_I2C_slave();
      f8:	0e 94 7b 08 	call	0x10f6
	sei(); //enable interrupts (go live)
      fc:	78 94       	sei
  
	while(1)
	{
		if (i2c_count() > 0){
      fe:	0e 94 3e 08 	call	0x107c
     102:	88 23       	and	r24, r24
     104:	e1 f3       	breq	.-8      	; 0xfe
			//send_byte_serial(10);
			//send_byte_serial(13);
			//send_byte_serial(i2c_count()+0x30);
			send_byte_serial('-');
     106:	8d e2       	ldi	r24, 0x2D	; 45
     108:	0e 94 c6 00 	call	0x18c
			blah = i2c_dequeue();
     10c:	0e 94 68 08 	call	0x10d0
     110:	c8 2f       	mov	r28, r24
			if (blah == 0x7F) tpl(TOGGLE);
     112:	8f 37       	cpi	r24, 0x7F	; 127
     114:	79 f0       	breq	.+30     	; 0x134
		 	UART_send_HEX8(blah);
     116:	8c 2f       	mov	r24, r28
     118:	0e 94 f9 07 	call	0xff2
     11c:	0e 94 3e 08 	call	0x107c
     120:	88 23       	and	r24, r24
     122:	69 f3       	breq	.-38     	; 0xfe
     124:	8d e2       	ldi	r24, 0x2D	; 45
     126:	0e 94 c6 00 	call	0x18c
     12a:	0e 94 68 08 	call	0x10d0
     12e:	c8 2f       	mov	r28, r24
     130:	8f 37       	cpi	r24, 0x7F	; 127
     132:	89 f7       	brne	.-30     	; 0x116
     134:	83 e0       	ldi	r24, 0x03	; 3
     136:	0e 94 dd 08 	call	0x11ba
     13a:	ed cf       	rjmp	.-38     	; 0x116

0000013c <init_serial>:
#include "uart0.h"

//USRT MODE! MASTER
void init_serial(uint8_t mode){
	switch (mode){
     13c:	8d 30       	cpi	r24, 0x0D	; 13
     13e:	81 f0       	breq	.+32     	; 0x160
		case(USRT):
			// USRT initialization
			UCSR0A=0x00;//just flags in this register
			UCSR0C=B8(01000110);//SYNCHRONOUS; N,8-bit data,1 frame format; Clock polarity = data delta on rising, sample on falling edge
			UBRR0H=0x00;
			UBRR0L=3; //2.67 Mbps (megabits per second) from 16MHz clock
			sbi(DDRD,1); //TXD is output pin (data line)
			sbi(DDRD,4); //XCK is output pin (USRT clock line)
			UCSR0B=0x08;//No Rx; TX enabled - last line because operation begins on this flag
			break;
		case(UART):	
		default:
			// UART initialization
			UCSR0A=0x00;//just flags in this register
     140:	10 92 c0 00 	sts	0x00C0, r1
			UCSR0C=B8(01000110);//SYNCHRONOUS (but ignore clock line because less error at BRG); N,8-bit data,1 frame format
     144:	26 e4       	ldi	r18, 0x46	; 70
     146:	20 93 c2 00 	sts	0x00C2, r18
			UBRR0H = 0;
     14a:	10 92 c5 00 	sts	0x00C5, r1
			UBRR0L = 34; //115.2k bps from 8MHz clock
     14e:	82 e2       	ldi	r24, 0x22	; 34
     150:	80 93 c4 00 	sts	0x00C4, r24
			sbi(DDRD,1); //TXD is output pin (data line)
     154:	51 9a       	sbi	0x0a, 1	; 10
			sbi(DDRD,4); //XCK is output pin (USRT clock line)
     156:	54 9a       	sbi	0x0a, 4	; 10
			UCSR0B=0x08;//No Rx; TX enabled - last line because operation begins on this flag		
     158:	38 e0       	ldi	r19, 0x08	; 8
     15a:	30 93 c1 00 	sts	0x00C1, r19
     15e:	08 95       	ret
     160:	10 92 c0 00 	sts	0x00C0, r1
     164:	86 e4       	ldi	r24, 0x46	; 70
     166:	80 93 c2 00 	sts	0x00C2, r24
     16a:	10 92 c5 00 	sts	0x00C5, r1
     16e:	83 e0       	ldi	r24, 0x03	; 3
     170:	80 93 c4 00 	sts	0x00C4, r24
     174:	51 9a       	sbi	0x0a, 1	; 10
     176:	54 9a       	sbi	0x0a, 4	; 10
     178:	38 e0       	ldi	r19, 0x08	; 8
     17a:	30 93 c1 00 	sts	0x00C1, r19
     17e:	08 95       	ret
     180:	08 95       	ret

00000182 <USRT_send_2bytes>:
	}
}

//dataA is sent first
//this function built for speed, no safety checking. UART shift and buffer registers should be empty.
//The first write falls through to the actual output register freeing the buffer for byte 2.
void inline USRT_send_2bytes(unsigned char dataA, unsigned char dataB){
	// XXX
	UDR0 = dataA;
     182:	80 93 c6 00 	sts	0x00C6, r24
	UDR0 = dataB;
     186:	60 93 c6 00 	sts	0x00C6, r22
     18a:	08 95       	ret

0000018c <send_byte_serial>:
	/*
	//DEBUG code to test the buffer ready for new data flag
	if(UCSR0A & B8(00100000)){ //true != 0, freeze on buffer avail
		stk_ledon(0xAA);
		while(1);
	}
	*/
}

void inline send_byte_serial(unsigned char dataB){
     18c:	48 2f       	mov	r20, r24
     18e:	21 e0       	ldi	r18, 0x01	; 1
     190:	30 e0       	ldi	r19, 0x00	; 0
	while ((UCSR0A & _BV(5)) != B8(00100000));
     192:	80 91 c0 00 	lds	r24, 0x00C0
     196:	99 27       	eor	r25, r25
     198:	96 95       	lsr	r25
     19a:	87 95       	ror	r24
     19c:	92 95       	swap	r25
     19e:	82 95       	swap	r24
     1a0:	8f 70       	andi	r24, 0x0F	; 15
     1a2:	89 27       	eor	r24, r25
     1a4:	9f 70       	andi	r25, 0x0F	; 15
     1a6:	89 27       	eor	r24, r25
     1a8:	81 70       	andi	r24, 0x01	; 1
     1aa:	90 70       	andi	r25, 0x00	; 0
     1ac:	82 17       	cp	r24, r18
     1ae:	93 07       	cpc	r25, r19
     1b0:	81 f7       	brne	.-32     	; 0x192
	UDR0 = dataB;
     1b2:	40 93 c6 00 	sts	0x00C6, r20
     1b6:	08 95       	ret

000001b8 <uart0_force_byte>:
}

void inline uart0_force_byte(unsigned char dataB){
	UDR0 = dataB;
     1b8:	80 93 c6 00 	sts	0x00C6, r24
     1bc:	08 95       	ret

000001be <UART_send_BIN4>:
}

//Most Significant Bit first
void UART_send_BIN4(uint8_t lowb){
	switch(lowb){
     1be:	99 27       	eor	r25, r25
     1c0:	87 30       	cpi	r24, 0x07	; 7
     1c2:	91 05       	cpc	r25, r1
     1c4:	09 f4       	brne	.+2      	; 0x1c8
     1c6:	cb c0       	rjmp	.+406    	; 0x35e
     1c8:	88 30       	cpi	r24, 0x08	; 8
     1ca:	91 05       	cpc	r25, r1
     1cc:	0c f0       	brlt	.+2      	; 0x1d0
     1ce:	65 c0       	rjmp	.+202    	; 0x29a
     1d0:	83 30       	cpi	r24, 0x03	; 3
     1d2:	91 05       	cpc	r25, r1
     1d4:	09 f4       	brne	.+2      	; 0x1d8
     1d6:	d4 c1       	rjmp	.+936    	; 0x580
     1d8:	84 30       	cpi	r24, 0x04	; 4
     1da:	91 05       	cpc	r25, r1
     1dc:	0c f0       	brlt	.+2      	; 0x1e0
     1de:	14 c1       	rjmp	.+552    	; 0x408
     1e0:	81 30       	cpi	r24, 0x01	; 1
     1e2:	91 05       	cpc	r25, r1
     1e4:	09 f4       	brne	.+2      	; 0x1e8
     1e6:	6c c3       	rjmp	.+1752   	; 0x8c0
     1e8:	82 30       	cpi	r24, 0x02	; 2
     1ea:	91 05       	cpc	r25, r1
     1ec:	0c f4       	brge	.+2      	; 0x1f0
     1ee:	ae c4       	rjmp	.+2396   	; 0xb4c
     1f0:	21 e0       	ldi	r18, 0x01	; 1
     1f2:	30 e0       	ldi	r19, 0x00	; 0
     1f4:	80 91 c0 00 	lds	r24, 0x00C0
     1f8:	99 27       	eor	r25, r25
     1fa:	96 95       	lsr	r25
     1fc:	87 95       	ror	r24
     1fe:	92 95       	swap	r25
     200:	82 95       	swap	r24
     202:	8f 70       	andi	r24, 0x0F	; 15
     204:	89 27       	eor	r24, r25
     206:	9f 70       	andi	r25, 0x0F	; 15
     208:	89 27       	eor	r24, r25
     20a:	81 70       	andi	r24, 0x01	; 1
     20c:	90 70       	andi	r25, 0x00	; 0
     20e:	82 17       	cp	r24, r18
     210:	93 07       	cpc	r25, r19
     212:	81 f7       	brne	.-32     	; 0x1f4
     214:	70 e3       	ldi	r23, 0x30	; 48
     216:	70 93 c6 00 	sts	0x00C6, r23
     21a:	21 e0       	ldi	r18, 0x01	; 1
     21c:	30 e0       	ldi	r19, 0x00	; 0
     21e:	80 91 c0 00 	lds	r24, 0x00C0
     222:	99 27       	eor	r25, r25
     224:	96 95       	lsr	r25
     226:	87 95       	ror	r24
     228:	92 95       	swap	r25
     22a:	82 95       	swap	r24
     22c:	8f 70       	andi	r24, 0x0F	; 15
     22e:	89 27       	eor	r24, r25
     230:	9f 70       	andi	r25, 0x0F	; 15
     232:	89 27       	eor	r24, r25
     234:	81 70       	andi	r24, 0x01	; 1
     236:	90 70       	andi	r25, 0x00	; 0
     238:	82 17       	cp	r24, r18
     23a:	93 07       	cpc	r25, r19
     23c:	81 f7       	brne	.-32     	; 0x21e
     23e:	90 e3       	ldi	r25, 0x30	; 48
     240:	90 93 c6 00 	sts	0x00C6, r25
     244:	21 e0       	ldi	r18, 0x01	; 1
     246:	30 e0       	ldi	r19, 0x00	; 0
     248:	80 91 c0 00 	lds	r24, 0x00C0
     24c:	99 27       	eor	r25, r25
     24e:	96 95       	lsr	r25
     250:	87 95       	ror	r24
     252:	92 95       	swap	r25
     254:	82 95       	swap	r24
     256:	8f 70       	andi	r24, 0x0F	; 15
     258:	89 27       	eor	r24, r25
     25a:	9f 70       	andi	r25, 0x0F	; 15
     25c:	89 27       	eor	r24, r25
     25e:	81 70       	andi	r24, 0x01	; 1
     260:	90 70       	andi	r25, 0x00	; 0
     262:	82 17       	cp	r24, r18
     264:	93 07       	cpc	r25, r19
     266:	81 f7       	brne	.-32     	; 0x248
     268:	a1 e3       	ldi	r26, 0x31	; 49
     26a:	a0 93 c6 00 	sts	0x00C6, r26
     26e:	21 e0       	ldi	r18, 0x01	; 1
     270:	30 e0       	ldi	r19, 0x00	; 0
     272:	80 91 c0 00 	lds	r24, 0x00C0
     276:	99 27       	eor	r25, r25
     278:	96 95       	lsr	r25
     27a:	87 95       	ror	r24
     27c:	92 95       	swap	r25
     27e:	82 95       	swap	r24
     280:	8f 70       	andi	r24, 0x0F	; 15
     282:	89 27       	eor	r24, r25
     284:	9f 70       	andi	r25, 0x0F	; 15
     286:	89 27       	eor	r24, r25
     288:	81 70       	andi	r24, 0x01	; 1
     28a:	90 70       	andi	r25, 0x00	; 0
     28c:	82 17       	cp	r24, r18
     28e:	93 07       	cpc	r25, r19
     290:	81 f7       	brne	.-32     	; 0x272
     292:	80 e3       	ldi	r24, 0x30	; 48
     294:	80 93 c6 00 	sts	0x00C6, r24
     298:	08 95       	ret
     29a:	8b 30       	cpi	r24, 0x0B	; 11
     29c:	91 05       	cpc	r25, r1
     29e:	09 f4       	brne	.+2      	; 0x2a2
     2a0:	1d c1       	rjmp	.+570    	; 0x4dc
     2a2:	8c 30       	cpi	r24, 0x0C	; 12
     2a4:	91 05       	cpc	r25, r1
     2a6:	0c f0       	brlt	.+2      	; 0x2aa
     2a8:	09 c1       	rjmp	.+530    	; 0x4bc
     2aa:	89 30       	cpi	r24, 0x09	; 9
     2ac:	91 05       	cpc	r25, r1
     2ae:	09 f4       	brne	.+2      	; 0x2b2
     2b0:	57 c3       	rjmp	.+1710   	; 0x960
     2b2:	0a 97       	sbiw	r24, 0x0a	; 10
     2b4:	0c f0       	brlt	.+2      	; 0x2b8
     2b6:	b6 c1       	rjmp	.+876    	; 0x624
     2b8:	21 e0       	ldi	r18, 0x01	; 1
     2ba:	30 e0       	ldi	r19, 0x00	; 0
     2bc:	80 91 c0 00 	lds	r24, 0x00C0
     2c0:	99 27       	eor	r25, r25
     2c2:	96 95       	lsr	r25
     2c4:	87 95       	ror	r24
     2c6:	92 95       	swap	r25
     2c8:	82 95       	swap	r24
     2ca:	8f 70       	andi	r24, 0x0F	; 15
     2cc:	89 27       	eor	r24, r25
     2ce:	9f 70       	andi	r25, 0x0F	; 15
     2d0:	89 27       	eor	r24, r25
     2d2:	81 70       	andi	r24, 0x01	; 1
     2d4:	90 70       	andi	r25, 0x00	; 0
     2d6:	82 17       	cp	r24, r18
     2d8:	93 07       	cpc	r25, r19
     2da:	81 f7       	brne	.-32     	; 0x2bc
     2dc:	81 e3       	ldi	r24, 0x31	; 49
     2de:	80 93 c6 00 	sts	0x00C6, r24
     2e2:	21 e0       	ldi	r18, 0x01	; 1
     2e4:	30 e0       	ldi	r19, 0x00	; 0
     2e6:	80 91 c0 00 	lds	r24, 0x00C0
     2ea:	99 27       	eor	r25, r25
     2ec:	96 95       	lsr	r25
     2ee:	87 95       	ror	r24
     2f0:	92 95       	swap	r25
     2f2:	82 95       	swap	r24
     2f4:	8f 70       	andi	r24, 0x0F	; 15
     2f6:	89 27       	eor	r24, r25
     2f8:	9f 70       	andi	r25, 0x0F	; 15
     2fa:	89 27       	eor	r24, r25
     2fc:	81 70       	andi	r24, 0x01	; 1
     2fe:	90 70       	andi	r25, 0x00	; 0
     300:	82 17       	cp	r24, r18
     302:	93 07       	cpc	r25, r19
     304:	81 f7       	brne	.-32     	; 0x2e6
     306:	20 e3       	ldi	r18, 0x30	; 48
     308:	20 93 c6 00 	sts	0x00C6, r18
     30c:	21 e0       	ldi	r18, 0x01	; 1
     30e:	30 e0       	ldi	r19, 0x00	; 0
     310:	80 91 c0 00 	lds	r24, 0x00C0
     314:	99 27       	eor	r25, r25
     316:	96 95       	lsr	r25
     318:	87 95       	ror	r24
     31a:	92 95       	swap	r25
     31c:	82 95       	swap	r24
     31e:	8f 70       	andi	r24, 0x0F	; 15
     320:	89 27       	eor	r24, r25
     322:	9f 70       	andi	r25, 0x0F	; 15
     324:	89 27       	eor	r24, r25
     326:	81 70       	andi	r24, 0x01	; 1
     328:	90 70       	andi	r25, 0x00	; 0
     32a:	82 17       	cp	r24, r18
     32c:	93 07       	cpc	r25, r19
     32e:	81 f7       	brne	.-32     	; 0x310
     330:	30 e3       	ldi	r19, 0x30	; 48
     332:	30 93 c6 00 	sts	0x00C6, r19
     336:	21 e0       	ldi	r18, 0x01	; 1
     338:	30 e0       	ldi	r19, 0x00	; 0
     33a:	80 91 c0 00 	lds	r24, 0x00C0
     33e:	99 27       	eor	r25, r25
     340:	96 95       	lsr	r25
     342:	87 95       	ror	r24
     344:	92 95       	swap	r25
     346:	82 95       	swap	r24
     348:	8f 70       	andi	r24, 0x0F	; 15
     34a:	89 27       	eor	r24, r25
     34c:	9f 70       	andi	r25, 0x0F	; 15
     34e:	89 27       	eor	r24, r25
     350:	81 70       	andi	r24, 0x01	; 1
     352:	90 70       	andi	r25, 0x00	; 0
     354:	82 17       	cp	r24, r18
     356:	93 07       	cpc	r25, r19
     358:	81 f7       	brne	.-32     	; 0x33a
     35a:	80 e3       	ldi	r24, 0x30	; 48
     35c:	9b cf       	rjmp	.-202    	; 0x294
     35e:	21 e0       	ldi	r18, 0x01	; 1
     360:	30 e0       	ldi	r19, 0x00	; 0
     362:	80 91 c0 00 	lds	r24, 0x00C0
     366:	99 27       	eor	r25, r25
     368:	96 95       	lsr	r25
     36a:	87 95       	ror	r24
     36c:	92 95       	swap	r25
     36e:	82 95       	swap	r24
     370:	8f 70       	andi	r24, 0x0F	; 15
     372:	89 27       	eor	r24, r25
     374:	9f 70       	andi	r25, 0x0F	; 15
     376:	89 27       	eor	r24, r25
     378:	81 70       	andi	r24, 0x01	; 1
     37a:	90 70       	andi	r25, 0x00	; 0
     37c:	82 17       	cp	r24, r18
     37e:	93 07       	cpc	r25, r19
     380:	81 f7       	brne	.-32     	; 0x362
     382:	b0 e3       	ldi	r27, 0x30	; 48
     384:	b0 93 c6 00 	sts	0x00C6, r27
     388:	21 e0       	ldi	r18, 0x01	; 1
     38a:	30 e0       	ldi	r19, 0x00	; 0
     38c:	80 91 c0 00 	lds	r24, 0x00C0
     390:	99 27       	eor	r25, r25
     392:	96 95       	lsr	r25
     394:	87 95       	ror	r24
     396:	92 95       	swap	r25
     398:	82 95       	swap	r24
     39a:	8f 70       	andi	r24, 0x0F	; 15
     39c:	89 27       	eor	r24, r25
     39e:	9f 70       	andi	r25, 0x0F	; 15
     3a0:	89 27       	eor	r24, r25
     3a2:	81 70       	andi	r24, 0x01	; 1
     3a4:	90 70       	andi	r25, 0x00	; 0
     3a6:	82 17       	cp	r24, r18
     3a8:	93 07       	cpc	r25, r19
     3aa:	81 f7       	brne	.-32     	; 0x38c
     3ac:	e1 e3       	ldi	r30, 0x31	; 49
     3ae:	e0 93 c6 00 	sts	0x00C6, r30
     3b2:	21 e0       	ldi	r18, 0x01	; 1
     3b4:	30 e0       	ldi	r19, 0x00	; 0
     3b6:	80 91 c0 00 	lds	r24, 0x00C0
     3ba:	99 27       	eor	r25, r25
     3bc:	96 95       	lsr	r25
     3be:	87 95       	ror	r24
     3c0:	92 95       	swap	r25
     3c2:	82 95       	swap	r24
     3c4:	8f 70       	andi	r24, 0x0F	; 15
     3c6:	89 27       	eor	r24, r25
     3c8:	9f 70       	andi	r25, 0x0F	; 15
     3ca:	89 27       	eor	r24, r25
     3cc:	81 70       	andi	r24, 0x01	; 1
     3ce:	90 70       	andi	r25, 0x00	; 0
     3d0:	82 17       	cp	r24, r18
     3d2:	93 07       	cpc	r25, r19
     3d4:	81 f7       	brne	.-32     	; 0x3b6
     3d6:	f1 e3       	ldi	r31, 0x31	; 49
     3d8:	f0 93 c6 00 	sts	0x00C6, r31
     3dc:	21 e0       	ldi	r18, 0x01	; 1
     3de:	30 e0       	ldi	r19, 0x00	; 0
     3e0:	80 91 c0 00 	lds	r24, 0x00C0
     3e4:	99 27       	eor	r25, r25
     3e6:	96 95       	lsr	r25
     3e8:	87 95       	ror	r24
     3ea:	92 95       	swap	r25
     3ec:	82 95       	swap	r24
     3ee:	8f 70       	andi	r24, 0x0F	; 15
     3f0:	89 27       	eor	r24, r25
     3f2:	9f 70       	andi	r25, 0x0F	; 15
     3f4:	89 27       	eor	r24, r25
     3f6:	81 70       	andi	r24, 0x01	; 1
     3f8:	90 70       	andi	r25, 0x00	; 0
     3fa:	82 17       	cp	r24, r18
     3fc:	93 07       	cpc	r25, r19
     3fe:	81 f7       	brne	.-32     	; 0x3e0
     400:	81 e3       	ldi	r24, 0x31	; 49
     402:	80 93 c6 00 	sts	0x00C6, r24
     406:	08 95       	ret
     408:	85 30       	cpi	r24, 0x05	; 5
     40a:	91 05       	cpc	r25, r1
     40c:	09 f4       	brne	.+2      	; 0x410
     40e:	fa c2       	rjmp	.+1524   	; 0xa04
     410:	06 97       	sbiw	r24, 0x06	; 6
     412:	0c f0       	brlt	.+2      	; 0x416
     414:	ad c1       	rjmp	.+858    	; 0x770
     416:	21 e0       	ldi	r18, 0x01	; 1
     418:	30 e0       	ldi	r19, 0x00	; 0
     41a:	80 91 c0 00 	lds	r24, 0x00C0
     41e:	99 27       	eor	r25, r25
     420:	96 95       	lsr	r25
     422:	87 95       	ror	r24
     424:	92 95       	swap	r25
     426:	82 95       	swap	r24
     428:	8f 70       	andi	r24, 0x0F	; 15
     42a:	89 27       	eor	r24, r25
     42c:	9f 70       	andi	r25, 0x0F	; 15
     42e:	89 27       	eor	r24, r25
     430:	81 70       	andi	r24, 0x01	; 1
     432:	90 70       	andi	r25, 0x00	; 0
     434:	82 17       	cp	r24, r18
     436:	93 07       	cpc	r25, r19
     438:	81 f7       	brne	.-32     	; 0x41a
     43a:	80 e3       	ldi	r24, 0x30	; 48
     43c:	80 93 c6 00 	sts	0x00C6, r24
     440:	21 e0       	ldi	r18, 0x01	; 1
     442:	30 e0       	ldi	r19, 0x00	; 0
     444:	80 91 c0 00 	lds	r24, 0x00C0
     448:	99 27       	eor	r25, r25
     44a:	96 95       	lsr	r25
     44c:	87 95       	ror	r24
     44e:	92 95       	swap	r25
     450:	82 95       	swap	r24
     452:	8f 70       	andi	r24, 0x0F	; 15
     454:	89 27       	eor	r24, r25
     456:	9f 70       	andi	r25, 0x0F	; 15
     458:	89 27       	eor	r24, r25
     45a:	81 70       	andi	r24, 0x01	; 1
     45c:	90 70       	andi	r25, 0x00	; 0
     45e:	82 17       	cp	r24, r18
     460:	93 07       	cpc	r25, r19
     462:	81 f7       	brne	.-32     	; 0x444
     464:	21 e3       	ldi	r18, 0x31	; 49
     466:	20 93 c6 00 	sts	0x00C6, r18
     46a:	21 e0       	ldi	r18, 0x01	; 1
     46c:	30 e0       	ldi	r19, 0x00	; 0
     46e:	80 91 c0 00 	lds	r24, 0x00C0
     472:	99 27       	eor	r25, r25
     474:	96 95       	lsr	r25
     476:	87 95       	ror	r24
     478:	92 95       	swap	r25
     47a:	82 95       	swap	r24
     47c:	8f 70       	andi	r24, 0x0F	; 15
     47e:	89 27       	eor	r24, r25
     480:	9f 70       	andi	r25, 0x0F	; 15
     482:	89 27       	eor	r24, r25
     484:	81 70       	andi	r24, 0x01	; 1
     486:	90 70       	andi	r25, 0x00	; 0
     488:	82 17       	cp	r24, r18
     48a:	93 07       	cpc	r25, r19
     48c:	81 f7       	brne	.-32     	; 0x46e
     48e:	30 e3       	ldi	r19, 0x30	; 48
     490:	30 93 c6 00 	sts	0x00C6, r19
     494:	21 e0       	ldi	r18, 0x01	; 1
     496:	30 e0       	ldi	r19, 0x00	; 0
     498:	80 91 c0 00 	lds	r24, 0x00C0
     49c:	99 27       	eor	r25, r25
     49e:	96 95       	lsr	r25
     4a0:	87 95       	ror	r24
     4a2:	92 95       	swap	r25
     4a4:	82 95       	swap	r24
     4a6:	8f 70       	andi	r24, 0x0F	; 15
     4a8:	89 27       	eor	r24, r25
     4aa:	9f 70       	andi	r25, 0x0F	; 15
     4ac:	89 27       	eor	r24, r25
     4ae:	81 70       	andi	r24, 0x01	; 1
     4b0:	90 70       	andi	r25, 0x00	; 0
     4b2:	82 17       	cp	r24, r18
     4b4:	93 07       	cpc	r25, r19
     4b6:	81 f7       	brne	.-32     	; 0x498
     4b8:	80 e3       	ldi	r24, 0x30	; 48
     4ba:	ec ce       	rjmp	.-552    	; 0x294
     4bc:	8d 30       	cpi	r24, 0x0D	; 13
     4be:	91 05       	cpc	r25, r1
     4c0:	09 f4       	brne	.+2      	; 0x4c4
     4c2:	f2 c2       	rjmp	.+1508   	; 0xaa8
     4c4:	8d 30       	cpi	r24, 0x0D	; 13
     4c6:	91 05       	cpc	r25, r1
     4c8:	0c f4       	brge	.+2      	; 0x4cc
     4ca:	ff c0       	rjmp	.+510    	; 0x6ca
     4cc:	8e 30       	cpi	r24, 0x0E	; 14
     4ce:	91 05       	cpc	r25, r1
     4d0:	09 f4       	brne	.+2      	; 0x4d4
     4d2:	40 c3       	rjmp	.+1664   	; 0xb54
     4d4:	0f 97       	sbiw	r24, 0x0f	; 15
     4d6:	09 f4       	brne	.+2      	; 0x4da
     4d8:	9e c1       	rjmp	.+828    	; 0x816
     4da:	08 95       	ret
     4dc:	21 e0       	ldi	r18, 0x01	; 1
     4de:	30 e0       	ldi	r19, 0x00	; 0
     4e0:	80 91 c0 00 	lds	r24, 0x00C0
     4e4:	99 27       	eor	r25, r25
     4e6:	96 95       	lsr	r25
     4e8:	87 95       	ror	r24
     4ea:	92 95       	swap	r25
     4ec:	82 95       	swap	r24
     4ee:	8f 70       	andi	r24, 0x0F	; 15
     4f0:	89 27       	eor	r24, r25
     4f2:	9f 70       	andi	r25, 0x0F	; 15
     4f4:	89 27       	eor	r24, r25
     4f6:	81 70       	andi	r24, 0x01	; 1
     4f8:	90 70       	andi	r25, 0x00	; 0
     4fa:	82 17       	cp	r24, r18
     4fc:	93 07       	cpc	r25, r19
     4fe:	81 f7       	brne	.-32     	; 0x4e0
     500:	b1 e3       	ldi	r27, 0x31	; 49
     502:	b0 93 c6 00 	sts	0x00C6, r27
     506:	21 e0       	ldi	r18, 0x01	; 1
     508:	30 e0       	ldi	r19, 0x00	; 0
     50a:	80 91 c0 00 	lds	r24, 0x00C0
     50e:	99 27       	eor	r25, r25
     510:	96 95       	lsr	r25
     512:	87 95       	ror	r24
     514:	92 95       	swap	r25
     516:	82 95       	swap	r24
     518:	8f 70       	andi	r24, 0x0F	; 15
     51a:	89 27       	eor	r24, r25
     51c:	9f 70       	andi	r25, 0x0F	; 15
     51e:	89 27       	eor	r24, r25
     520:	81 70       	andi	r24, 0x01	; 1
     522:	90 70       	andi	r25, 0x00	; 0
     524:	82 17       	cp	r24, r18
     526:	93 07       	cpc	r25, r19
     528:	81 f7       	brne	.-32     	; 0x50a
     52a:	e0 e3       	ldi	r30, 0x30	; 48
     52c:	e0 93 c6 00 	sts	0x00C6, r30
     530:	21 e0       	ldi	r18, 0x01	; 1
     532:	30 e0       	ldi	r19, 0x00	; 0
     534:	80 91 c0 00 	lds	r24, 0x00C0
     538:	99 27       	eor	r25, r25
     53a:	96 95       	lsr	r25
     53c:	87 95       	ror	r24
     53e:	92 95       	swap	r25
     540:	82 95       	swap	r24
     542:	8f 70       	andi	r24, 0x0F	; 15
     544:	89 27       	eor	r24, r25
     546:	9f 70       	andi	r25, 0x0F	; 15
     548:	89 27       	eor	r24, r25
     54a:	81 70       	andi	r24, 0x01	; 1
     54c:	90 70       	andi	r25, 0x00	; 0
     54e:	82 17       	cp	r24, r18
     550:	93 07       	cpc	r25, r19
     552:	81 f7       	brne	.-32     	; 0x534
     554:	f1 e3       	ldi	r31, 0x31	; 49
     556:	f0 93 c6 00 	sts	0x00C6, r31
     55a:	21 e0       	ldi	r18, 0x01	; 1
     55c:	30 e0       	ldi	r19, 0x00	; 0
     55e:	80 91 c0 00 	lds	r24, 0x00C0
     562:	99 27       	eor	r25, r25
     564:	96 95       	lsr	r25
     566:	87 95       	ror	r24
     568:	92 95       	swap	r25
     56a:	82 95       	swap	r24
     56c:	8f 70       	andi	r24, 0x0F	; 15
     56e:	89 27       	eor	r24, r25
     570:	9f 70       	andi	r25, 0x0F	; 15
     572:	89 27       	eor	r24, r25
     574:	81 70       	andi	r24, 0x01	; 1
     576:	90 70       	andi	r25, 0x00	; 0
     578:	82 17       	cp	r24, r18
     57a:	93 07       	cpc	r25, r19
     57c:	81 f7       	brne	.-32     	; 0x55e
     57e:	40 cf       	rjmp	.-384    	; 0x400
     580:	21 e0       	ldi	r18, 0x01	; 1
     582:	30 e0       	ldi	r19, 0x00	; 0
     584:	80 91 c0 00 	lds	r24, 0x00C0
     588:	99 27       	eor	r25, r25
     58a:	96 95       	lsr	r25
     58c:	87 95       	ror	r24
     58e:	92 95       	swap	r25
     590:	82 95       	swap	r24
     592:	8f 70       	andi	r24, 0x0F	; 15
     594:	89 27       	eor	r24, r25
     596:	9f 70       	andi	r25, 0x0F	; 15
     598:	89 27       	eor	r24, r25
     59a:	81 70       	andi	r24, 0x01	; 1
     59c:	90 70       	andi	r25, 0x00	; 0
     59e:	82 17       	cp	r24, r18
     5a0:	93 07       	cpc	r25, r19
     5a2:	81 f7       	brne	.-32     	; 0x584
     5a4:	b0 e3       	ldi	r27, 0x30	; 48
     5a6:	b0 93 c6 00 	sts	0x00C6, r27
     5aa:	21 e0       	ldi	r18, 0x01	; 1
     5ac:	30 e0       	ldi	r19, 0x00	; 0
     5ae:	80 91 c0 00 	lds	r24, 0x00C0
     5b2:	99 27       	eor	r25, r25
     5b4:	96 95       	lsr	r25
     5b6:	87 95       	ror	r24
     5b8:	92 95       	swap	r25
     5ba:	82 95       	swap	r24
     5bc:	8f 70       	andi	r24, 0x0F	; 15
     5be:	89 27       	eor	r24, r25
     5c0:	9f 70       	andi	r25, 0x0F	; 15
     5c2:	89 27       	eor	r24, r25
     5c4:	81 70       	andi	r24, 0x01	; 1
     5c6:	90 70       	andi	r25, 0x00	; 0
     5c8:	82 17       	cp	r24, r18
     5ca:	93 07       	cpc	r25, r19
     5cc:	81 f7       	brne	.-32     	; 0x5ae
     5ce:	e0 e3       	ldi	r30, 0x30	; 48
     5d0:	e0 93 c6 00 	sts	0x00C6, r30
     5d4:	21 e0       	ldi	r18, 0x01	; 1
     5d6:	30 e0       	ldi	r19, 0x00	; 0
     5d8:	80 91 c0 00 	lds	r24, 0x00C0
     5dc:	99 27       	eor	r25, r25
     5de:	96 95       	lsr	r25
     5e0:	87 95       	ror	r24
     5e2:	92 95       	swap	r25
     5e4:	82 95       	swap	r24
     5e6:	8f 70       	andi	r24, 0x0F	; 15
     5e8:	89 27       	eor	r24, r25
     5ea:	9f 70       	andi	r25, 0x0F	; 15
     5ec:	89 27       	eor	r24, r25
     5ee:	81 70       	andi	r24, 0x01	; 1
     5f0:	90 70       	andi	r25, 0x00	; 0
     5f2:	82 17       	cp	r24, r18
     5f4:	93 07       	cpc	r25, r19
     5f6:	81 f7       	brne	.-32     	; 0x5d8
     5f8:	f1 e3       	ldi	r31, 0x31	; 49
     5fa:	f0 93 c6 00 	sts	0x00C6, r31
     5fe:	21 e0       	ldi	r18, 0x01	; 1
     600:	30 e0       	ldi	r19, 0x00	; 0
     602:	80 91 c0 00 	lds	r24, 0x00C0
     606:	99 27       	eor	r25, r25
     608:	96 95       	lsr	r25
     60a:	87 95       	ror	r24
     60c:	92 95       	swap	r25
     60e:	82 95       	swap	r24
     610:	8f 70       	andi	r24, 0x0F	; 15
     612:	89 27       	eor	r24, r25
     614:	9f 70       	andi	r25, 0x0F	; 15
     616:	89 27       	eor	r24, r25
     618:	81 70       	andi	r24, 0x01	; 1
     61a:	90 70       	andi	r25, 0x00	; 0
     61c:	82 17       	cp	r24, r18
     61e:	93 07       	cpc	r25, r19
     620:	81 f7       	brne	.-32     	; 0x602
     622:	ee ce       	rjmp	.-548    	; 0x400
     624:	21 e0       	ldi	r18, 0x01	; 1
     626:	30 e0       	ldi	r19, 0x00	; 0
     628:	80 91 c0 00 	lds	r24, 0x00C0
     62c:	99 27       	eor	r25, r25
     62e:	96 95       	lsr	r25
     630:	87 95       	ror	r24
     632:	92 95       	swap	r25
     634:	82 95       	swap	r24
     636:	8f 70       	andi	r24, 0x0F	; 15
     638:	89 27       	eor	r24, r25
     63a:	9f 70       	andi	r25, 0x0F	; 15
     63c:	89 27       	eor	r24, r25
     63e:	81 70       	andi	r24, 0x01	; 1
     640:	90 70       	andi	r25, 0x00	; 0
     642:	82 17       	cp	r24, r18
     644:	93 07       	cpc	r25, r19
     646:	81 f7       	brne	.-32     	; 0x628
     648:	71 e3       	ldi	r23, 0x31	; 49
     64a:	70 93 c6 00 	sts	0x00C6, r23
     64e:	21 e0       	ldi	r18, 0x01	; 1
     650:	30 e0       	ldi	r19, 0x00	; 0
     652:	80 91 c0 00 	lds	r24, 0x00C0
     656:	99 27       	eor	r25, r25
     658:	96 95       	lsr	r25
     65a:	87 95       	ror	r24
     65c:	92 95       	swap	r25
     65e:	82 95       	swap	r24
     660:	8f 70       	andi	r24, 0x0F	; 15
     662:	89 27       	eor	r24, r25
     664:	9f 70       	andi	r25, 0x0F	; 15
     666:	89 27       	eor	r24, r25
     668:	81 70       	andi	r24, 0x01	; 1
     66a:	90 70       	andi	r25, 0x00	; 0
     66c:	82 17       	cp	r24, r18
     66e:	93 07       	cpc	r25, r19
     670:	81 f7       	brne	.-32     	; 0x652
     672:	90 e3       	ldi	r25, 0x30	; 48
     674:	90 93 c6 00 	sts	0x00C6, r25
     678:	21 e0       	ldi	r18, 0x01	; 1
     67a:	30 e0       	ldi	r19, 0x00	; 0
     67c:	80 91 c0 00 	lds	r24, 0x00C0
     680:	99 27       	eor	r25, r25
     682:	96 95       	lsr	r25
     684:	87 95       	ror	r24
     686:	92 95       	swap	r25
     688:	82 95       	swap	r24
     68a:	8f 70       	andi	r24, 0x0F	; 15
     68c:	89 27       	eor	r24, r25
     68e:	9f 70       	andi	r25, 0x0F	; 15
     690:	89 27       	eor	r24, r25
     692:	81 70       	andi	r24, 0x01	; 1
     694:	90 70       	andi	r25, 0x00	; 0
     696:	82 17       	cp	r24, r18
     698:	93 07       	cpc	r25, r19
     69a:	81 f7       	brne	.-32     	; 0x67c
     69c:	a1 e3       	ldi	r26, 0x31	; 49
     69e:	a0 93 c6 00 	sts	0x00C6, r26
     6a2:	21 e0       	ldi	r18, 0x01	; 1
     6a4:	30 e0       	ldi	r19, 0x00	; 0
     6a6:	80 91 c0 00 	lds	r24, 0x00C0
     6aa:	99 27       	eor	r25, r25
     6ac:	96 95       	lsr	r25
     6ae:	87 95       	ror	r24
     6b0:	92 95       	swap	r25
     6b2:	82 95       	swap	r24
     6b4:	8f 70       	andi	r24, 0x0F	; 15
     6b6:	89 27       	eor	r24, r25
     6b8:	9f 70       	andi	r25, 0x0F	; 15
     6ba:	89 27       	eor	r24, r25
     6bc:	81 70       	andi	r24, 0x01	; 1
     6be:	90 70       	andi	r25, 0x00	; 0
     6c0:	82 17       	cp	r24, r18
     6c2:	93 07       	cpc	r25, r19
     6c4:	81 f7       	brne	.-32     	; 0x6a6
     6c6:	80 e3       	ldi	r24, 0x30	; 48
     6c8:	e5 cd       	rjmp	.-1078   	; 0x294
     6ca:	21 e0       	ldi	r18, 0x01	; 1
     6cc:	30 e0       	ldi	r19, 0x00	; 0
     6ce:	80 91 c0 00 	lds	r24, 0x00C0
     6d2:	99 27       	eor	r25, r25
     6d4:	96 95       	lsr	r25
     6d6:	87 95       	ror	r24
     6d8:	92 95       	swap	r25
     6da:	82 95       	swap	r24
     6dc:	8f 70       	andi	r24, 0x0F	; 15
     6de:	89 27       	eor	r24, r25
     6e0:	9f 70       	andi	r25, 0x0F	; 15
     6e2:	89 27       	eor	r24, r25
     6e4:	81 70       	andi	r24, 0x01	; 1
     6e6:	90 70       	andi	r25, 0x00	; 0
     6e8:	82 17       	cp	r24, r18
     6ea:	93 07       	cpc	r25, r19
     6ec:	81 f7       	brne	.-32     	; 0x6ce
     6ee:	81 e3       	ldi	r24, 0x31	; 49
     6f0:	80 93 c6 00 	sts	0x00C6, r24
     6f4:	21 e0       	ldi	r18, 0x01	; 1
     6f6:	30 e0       	ldi	r19, 0x00	; 0
     6f8:	80 91 c0 00 	lds	r24, 0x00C0
     6fc:	99 27       	eor	r25, r25
     6fe:	96 95       	lsr	r25
     700:	87 95       	ror	r24
     702:	92 95       	swap	r25
     704:	82 95       	swap	r24
     706:	8f 70       	andi	r24, 0x0F	; 15
     708:	89 27       	eor	r24, r25
     70a:	9f 70       	andi	r25, 0x0F	; 15
     70c:	89 27       	eor	r24, r25
     70e:	81 70       	andi	r24, 0x01	; 1
     710:	90 70       	andi	r25, 0x00	; 0
     712:	82 17       	cp	r24, r18
     714:	93 07       	cpc	r25, r19
     716:	81 f7       	brne	.-32     	; 0x6f8
     718:	21 e3       	ldi	r18, 0x31	; 49
     71a:	20 93 c6 00 	sts	0x00C6, r18
     71e:	21 e0       	ldi	r18, 0x01	; 1
     720:	30 e0       	ldi	r19, 0x00	; 0
     722:	80 91 c0 00 	lds	r24, 0x00C0
     726:	99 27       	eor	r25, r25
     728:	96 95       	lsr	r25
     72a:	87 95       	ror	r24
     72c:	92 95       	swap	r25
     72e:	82 95       	swap	r24
     730:	8f 70       	andi	r24, 0x0F	; 15
     732:	89 27       	eor	r24, r25
     734:	9f 70       	andi	r25, 0x0F	; 15
     736:	89 27       	eor	r24, r25
     738:	81 70       	andi	r24, 0x01	; 1
     73a:	90 70       	andi	r25, 0x00	; 0
     73c:	82 17       	cp	r24, r18
     73e:	93 07       	cpc	r25, r19
     740:	81 f7       	brne	.-32     	; 0x722
     742:	30 e3       	ldi	r19, 0x30	; 48
     744:	30 93 c6 00 	sts	0x00C6, r19
     748:	21 e0       	ldi	r18, 0x01	; 1
     74a:	30 e0       	ldi	r19, 0x00	; 0
     74c:	80 91 c0 00 	lds	r24, 0x00C0
     750:	99 27       	eor	r25, r25
     752:	96 95       	lsr	r25
     754:	87 95       	ror	r24
     756:	92 95       	swap	r25
     758:	82 95       	swap	r24
     75a:	8f 70       	andi	r24, 0x0F	; 15
     75c:	89 27       	eor	r24, r25
     75e:	9f 70       	andi	r25, 0x0F	; 15
     760:	89 27       	eor	r24, r25
     762:	81 70       	andi	r24, 0x01	; 1
     764:	90 70       	andi	r25, 0x00	; 0
     766:	82 17       	cp	r24, r18
     768:	93 07       	cpc	r25, r19
     76a:	81 f7       	brne	.-32     	; 0x74c
     76c:	80 e3       	ldi	r24, 0x30	; 48
     76e:	92 cd       	rjmp	.-1244   	; 0x294
     770:	21 e0       	ldi	r18, 0x01	; 1
     772:	30 e0       	ldi	r19, 0x00	; 0
     774:	80 91 c0 00 	lds	r24, 0x00C0
     778:	99 27       	eor	r25, r25
     77a:	96 95       	lsr	r25
     77c:	87 95       	ror	r24
     77e:	92 95       	swap	r25
     780:	82 95       	swap	r24
     782:	8f 70       	andi	r24, 0x0F	; 15
     784:	89 27       	eor	r24, r25
     786:	9f 70       	andi	r25, 0x0F	; 15
     788:	89 27       	eor	r24, r25
     78a:	81 70       	andi	r24, 0x01	; 1
     78c:	90 70       	andi	r25, 0x00	; 0
     78e:	82 17       	cp	r24, r18
     790:	93 07       	cpc	r25, r19
     792:	81 f7       	brne	.-32     	; 0x774
     794:	70 e3       	ldi	r23, 0x30	; 48
     796:	70 93 c6 00 	sts	0x00C6, r23
     79a:	21 e0       	ldi	r18, 0x01	; 1
     79c:	30 e0       	ldi	r19, 0x00	; 0
     79e:	80 91 c0 00 	lds	r24, 0x00C0
     7a2:	99 27       	eor	r25, r25
     7a4:	96 95       	lsr	r25
     7a6:	87 95       	ror	r24
     7a8:	92 95       	swap	r25
     7aa:	82 95       	swap	r24
     7ac:	8f 70       	andi	r24, 0x0F	; 15
     7ae:	89 27       	eor	r24, r25
     7b0:	9f 70       	andi	r25, 0x0F	; 15
     7b2:	89 27       	eor	r24, r25
     7b4:	81 70       	andi	r24, 0x01	; 1
     7b6:	90 70       	andi	r25, 0x00	; 0
     7b8:	82 17       	cp	r24, r18
     7ba:	93 07       	cpc	r25, r19
     7bc:	81 f7       	brne	.-32     	; 0x79e
     7be:	91 e3       	ldi	r25, 0x31	; 49
     7c0:	90 93 c6 00 	sts	0x00C6, r25
     7c4:	21 e0       	ldi	r18, 0x01	; 1
     7c6:	30 e0       	ldi	r19, 0x00	; 0
     7c8:	80 91 c0 00 	lds	r24, 0x00C0
     7cc:	99 27       	eor	r25, r25
     7ce:	96 95       	lsr	r25
     7d0:	87 95       	ror	r24
     7d2:	92 95       	swap	r25
     7d4:	82 95       	swap	r24
     7d6:	8f 70       	andi	r24, 0x0F	; 15
     7d8:	89 27       	eor	r24, r25
     7da:	9f 70       	andi	r25, 0x0F	; 15
     7dc:	89 27       	eor	r24, r25
     7de:	81 70       	andi	r24, 0x01	; 1
     7e0:	90 70       	andi	r25, 0x00	; 0
     7e2:	82 17       	cp	r24, r18
     7e4:	93 07       	cpc	r25, r19
     7e6:	81 f7       	brne	.-32     	; 0x7c8
     7e8:	a1 e3       	ldi	r26, 0x31	; 49
     7ea:	a0 93 c6 00 	sts	0x00C6, r26
     7ee:	21 e0       	ldi	r18, 0x01	; 1
     7f0:	30 e0       	ldi	r19, 0x00	; 0
     7f2:	80 91 c0 00 	lds	r24, 0x00C0
     7f6:	99 27       	eor	r25, r25
     7f8:	96 95       	lsr	r25
     7fa:	87 95       	ror	r24
     7fc:	92 95       	swap	r25
     7fe:	82 95       	swap	r24
     800:	8f 70       	andi	r24, 0x0F	; 15
     802:	89 27       	eor	r24, r25
     804:	9f 70       	andi	r25, 0x0F	; 15
     806:	89 27       	eor	r24, r25
     808:	81 70       	andi	r24, 0x01	; 1
     80a:	90 70       	andi	r25, 0x00	; 0
     80c:	82 17       	cp	r24, r18
     80e:	93 07       	cpc	r25, r19
     810:	81 f7       	brne	.-32     	; 0x7f2
     812:	80 e3       	ldi	r24, 0x30	; 48
     814:	3f cd       	rjmp	.-1410   	; 0x294
     816:	21 e0       	ldi	r18, 0x01	; 1
     818:	30 e0       	ldi	r19, 0x00	; 0
     81a:	80 91 c0 00 	lds	r24, 0x00C0
     81e:	99 27       	eor	r25, r25
     820:	96 95       	lsr	r25
     822:	87 95       	ror	r24
     824:	92 95       	swap	r25
     826:	82 95       	swap	r24
     828:	8f 70       	andi	r24, 0x0F	; 15
     82a:	89 27       	eor	r24, r25
     82c:	9f 70       	andi	r25, 0x0F	; 15
     82e:	89 27       	eor	r24, r25
     830:	81 70       	andi	r24, 0x01	; 1
     832:	90 70       	andi	r25, 0x00	; 0
     834:	82 17       	cp	r24, r18
     836:	93 07       	cpc	r25, r19
     838:	81 f7       	brne	.-32     	; 0x81a
     83a:	b1 e3       	ldi	r27, 0x31	; 49
     83c:	b0 93 c6 00 	sts	0x00C6, r27
     840:	21 e0       	ldi	r18, 0x01	; 1
     842:	30 e0       	ldi	r19, 0x00	; 0
     844:	80 91 c0 00 	lds	r24, 0x00C0
     848:	99 27       	eor	r25, r25
     84a:	96 95       	lsr	r25
     84c:	87 95       	ror	r24
     84e:	92 95       	swap	r25
     850:	82 95       	swap	r24
     852:	8f 70       	andi	r24, 0x0F	; 15
     854:	89 27       	eor	r24, r25
     856:	9f 70       	andi	r25, 0x0F	; 15
     858:	89 27       	eor	r24, r25
     85a:	81 70       	andi	r24, 0x01	; 1
     85c:	90 70       	andi	r25, 0x00	; 0
     85e:	82 17       	cp	r24, r18
     860:	93 07       	cpc	r25, r19
     862:	81 f7       	brne	.-32     	; 0x844
     864:	e1 e3       	ldi	r30, 0x31	; 49
     866:	e0 93 c6 00 	sts	0x00C6, r30
     86a:	21 e0       	ldi	r18, 0x01	; 1
     86c:	30 e0       	ldi	r19, 0x00	; 0
     86e:	80 91 c0 00 	lds	r24, 0x00C0
     872:	99 27       	eor	r25, r25
     874:	96 95       	lsr	r25
     876:	87 95       	ror	r24
     878:	92 95       	swap	r25
     87a:	82 95       	swap	r24
     87c:	8f 70       	andi	r24, 0x0F	; 15
     87e:	89 27       	eor	r24, r25
     880:	9f 70       	andi	r25, 0x0F	; 15
     882:	89 27       	eor	r24, r25
     884:	81 70       	andi	r24, 0x01	; 1
     886:	90 70       	andi	r25, 0x00	; 0
     888:	82 17       	cp	r24, r18
     88a:	93 07       	cpc	r25, r19
     88c:	81 f7       	brne	.-32     	; 0x86e
     88e:	f1 e3       	ldi	r31, 0x31	; 49
     890:	f0 93 c6 00 	sts	0x00C6, r31
     894:	21 e0       	ldi	r18, 0x01	; 1
     896:	30 e0       	ldi	r19, 0x00	; 0
     898:	80 91 c0 00 	lds	r24, 0x00C0
     89c:	99 27       	eor	r25, r25
     89e:	96 95       	lsr	r25
     8a0:	87 95       	ror	r24
     8a2:	92 95       	swap	r25
     8a4:	82 95       	swap	r24
     8a6:	8f 70       	andi	r24, 0x0F	; 15
     8a8:	89 27       	eor	r24, r25
     8aa:	9f 70       	andi	r25, 0x0F	; 15
     8ac:	89 27       	eor	r24, r25
     8ae:	81 70       	andi	r24, 0x01	; 1
     8b0:	90 70       	andi	r25, 0x00	; 0
     8b2:	82 17       	cp	r24, r18
     8b4:	93 07       	cpc	r25, r19
     8b6:	81 f7       	brne	.-32     	; 0x898
     8b8:	81 e3       	ldi	r24, 0x31	; 49
     8ba:	80 93 c6 00 	sts	0x00C6, r24
     8be:	08 95       	ret
     8c0:	9c 01       	movw	r18, r24
     8c2:	80 91 c0 00 	lds	r24, 0x00C0
     8c6:	99 27       	eor	r25, r25
     8c8:	96 95       	lsr	r25
     8ca:	87 95       	ror	r24
     8cc:	92 95       	swap	r25
     8ce:	82 95       	swap	r24
     8d0:	8f 70       	andi	r24, 0x0F	; 15
     8d2:	89 27       	eor	r24, r25
     8d4:	9f 70       	andi	r25, 0x0F	; 15
     8d6:	89 27       	eor	r24, r25
     8d8:	82 27       	eor	r24, r18
     8da:	93 27       	eor	r25, r19
     8dc:	80 fd       	sbrc	r24, 0
     8de:	f1 cf       	rjmp	.-30     	; 0x8c2
     8e0:	40 e3       	ldi	r20, 0x30	; 48
     8e2:	40 93 c6 00 	sts	0x00C6, r20
     8e6:	21 e0       	ldi	r18, 0x01	; 1
     8e8:	30 e0       	ldi	r19, 0x00	; 0
     8ea:	80 91 c0 00 	lds	r24, 0x00C0
     8ee:	99 27       	eor	r25, r25
     8f0:	96 95       	lsr	r25
     8f2:	87 95       	ror	r24
     8f4:	92 95       	swap	r25
     8f6:	82 95       	swap	r24
     8f8:	8f 70       	andi	r24, 0x0F	; 15
     8fa:	89 27       	eor	r24, r25
     8fc:	9f 70       	andi	r25, 0x0F	; 15
     8fe:	89 27       	eor	r24, r25
     900:	81 70       	andi	r24, 0x01	; 1
     902:	90 70       	andi	r25, 0x00	; 0
     904:	82 17       	cp	r24, r18
     906:	93 07       	cpc	r25, r19
     908:	81 f7       	brne	.-32     	; 0x8ea
     90a:	50 e3       	ldi	r21, 0x30	; 48
     90c:	50 93 c6 00 	sts	0x00C6, r21
     910:	21 e0       	ldi	r18, 0x01	; 1
     912:	30 e0       	ldi	r19, 0x00	; 0
     914:	80 91 c0 00 	lds	r24, 0x00C0
     918:	99 27       	eor	r25, r25
     91a:	96 95       	lsr	r25
     91c:	87 95       	ror	r24
     91e:	92 95       	swap	r25
     920:	82 95       	swap	r24
     922:	8f 70       	andi	r24, 0x0F	; 15
     924:	89 27       	eor	r24, r25
     926:	9f 70       	andi	r25, 0x0F	; 15
     928:	89 27       	eor	r24, r25
     92a:	81 70       	andi	r24, 0x01	; 1
     92c:	90 70       	andi	r25, 0x00	; 0
     92e:	82 17       	cp	r24, r18
     930:	93 07       	cpc	r25, r19
     932:	81 f7       	brne	.-32     	; 0x914
     934:	60 e3       	ldi	r22, 0x30	; 48
     936:	60 93 c6 00 	sts	0x00C6, r22
     93a:	21 e0       	ldi	r18, 0x01	; 1
     93c:	30 e0       	ldi	r19, 0x00	; 0
     93e:	80 91 c0 00 	lds	r24, 0x00C0
     942:	99 27       	eor	r25, r25
     944:	96 95       	lsr	r25
     946:	87 95       	ror	r24
     948:	92 95       	swap	r25
     94a:	82 95       	swap	r24
     94c:	8f 70       	andi	r24, 0x0F	; 15
     94e:	89 27       	eor	r24, r25
     950:	9f 70       	andi	r25, 0x0F	; 15
     952:	89 27       	eor	r24, r25
     954:	81 70       	andi	r24, 0x01	; 1
     956:	90 70       	andi	r25, 0x00	; 0
     958:	82 17       	cp	r24, r18
     95a:	93 07       	cpc	r25, r19
     95c:	81 f7       	brne	.-32     	; 0x93e
     95e:	50 cd       	rjmp	.-1376   	; 0x400
     960:	21 e0       	ldi	r18, 0x01	; 1
     962:	30 e0       	ldi	r19, 0x00	; 0
     964:	80 91 c0 00 	lds	r24, 0x00C0
     968:	99 27       	eor	r25, r25
     96a:	96 95       	lsr	r25
     96c:	87 95       	ror	r24
     96e:	92 95       	swap	r25
     970:	82 95       	swap	r24
     972:	8f 70       	andi	r24, 0x0F	; 15
     974:	89 27       	eor	r24, r25
     976:	9f 70       	andi	r25, 0x0F	; 15
     978:	89 27       	eor	r24, r25
     97a:	81 70       	andi	r24, 0x01	; 1
     97c:	90 70       	andi	r25, 0x00	; 0
     97e:	82 17       	cp	r24, r18
     980:	93 07       	cpc	r25, r19
     982:	81 f7       	brne	.-32     	; 0x964
     984:	41 e3       	ldi	r20, 0x31	; 49
     986:	40 93 c6 00 	sts	0x00C6, r20
     98a:	21 e0       	ldi	r18, 0x01	; 1
     98c:	30 e0       	ldi	r19, 0x00	; 0
     98e:	80 91 c0 00 	lds	r24, 0x00C0
     992:	99 27       	eor	r25, r25
     994:	96 95       	lsr	r25
     996:	87 95       	ror	r24
     998:	92 95       	swap	r25
     99a:	82 95       	swap	r24
     99c:	8f 70       	andi	r24, 0x0F	; 15
     99e:	89 27       	eor	r24, r25
     9a0:	9f 70       	andi	r25, 0x0F	; 15
     9a2:	89 27       	eor	r24, r25
     9a4:	81 70       	andi	r24, 0x01	; 1
     9a6:	90 70       	andi	r25, 0x00	; 0
     9a8:	82 17       	cp	r24, r18
     9aa:	93 07       	cpc	r25, r19
     9ac:	81 f7       	brne	.-32     	; 0x98e
     9ae:	50 e3       	ldi	r21, 0x30	; 48
     9b0:	50 93 c6 00 	sts	0x00C6, r21
     9b4:	21 e0       	ldi	r18, 0x01	; 1
     9b6:	30 e0       	ldi	r19, 0x00	; 0
     9b8:	80 91 c0 00 	lds	r24, 0x00C0
     9bc:	99 27       	eor	r25, r25
     9be:	96 95       	lsr	r25
     9c0:	87 95       	ror	r24
     9c2:	92 95       	swap	r25
     9c4:	82 95       	swap	r24
     9c6:	8f 70       	andi	r24, 0x0F	; 15
     9c8:	89 27       	eor	r24, r25
     9ca:	9f 70       	andi	r25, 0x0F	; 15
     9cc:	89 27       	eor	r24, r25
     9ce:	81 70       	andi	r24, 0x01	; 1
     9d0:	90 70       	andi	r25, 0x00	; 0
     9d2:	82 17       	cp	r24, r18
     9d4:	93 07       	cpc	r25, r19
     9d6:	81 f7       	brne	.-32     	; 0x9b8
     9d8:	60 e3       	ldi	r22, 0x30	; 48
     9da:	60 93 c6 00 	sts	0x00C6, r22
     9de:	21 e0       	ldi	r18, 0x01	; 1
     9e0:	30 e0       	ldi	r19, 0x00	; 0
     9e2:	80 91 c0 00 	lds	r24, 0x00C0
     9e6:	99 27       	eor	r25, r25
     9e8:	96 95       	lsr	r25
     9ea:	87 95       	ror	r24
     9ec:	92 95       	swap	r25
     9ee:	82 95       	swap	r24
     9f0:	8f 70       	andi	r24, 0x0F	; 15
     9f2:	89 27       	eor	r24, r25
     9f4:	9f 70       	andi	r25, 0x0F	; 15
     9f6:	89 27       	eor	r24, r25
     9f8:	81 70       	andi	r24, 0x01	; 1
     9fa:	90 70       	andi	r25, 0x00	; 0
     9fc:	82 17       	cp	r24, r18
     9fe:	93 07       	cpc	r25, r19
     a00:	81 f7       	brne	.-32     	; 0x9e2
     a02:	fe cc       	rjmp	.-1540   	; 0x400
     a04:	21 e0       	ldi	r18, 0x01	; 1
     a06:	30 e0       	ldi	r19, 0x00	; 0
     a08:	80 91 c0 00 	lds	r24, 0x00C0
     a0c:	99 27       	eor	r25, r25
     a0e:	96 95       	lsr	r25
     a10:	87 95       	ror	r24
     a12:	92 95       	swap	r25
     a14:	82 95       	swap	r24
     a16:	8f 70       	andi	r24, 0x0F	; 15
     a18:	89 27       	eor	r24, r25
     a1a:	9f 70       	andi	r25, 0x0F	; 15
     a1c:	89 27       	eor	r24, r25
     a1e:	81 70       	andi	r24, 0x01	; 1
     a20:	90 70       	andi	r25, 0x00	; 0
     a22:	82 17       	cp	r24, r18
     a24:	93 07       	cpc	r25, r19
     a26:	81 f7       	brne	.-32     	; 0xa08
     a28:	40 e3       	ldi	r20, 0x30	; 48
     a2a:	40 93 c6 00 	sts	0x00C6, r20
     a2e:	21 e0       	ldi	r18, 0x01	; 1
     a30:	30 e0       	ldi	r19, 0x00	; 0
     a32:	80 91 c0 00 	lds	r24, 0x00C0
     a36:	99 27       	eor	r25, r25
     a38:	96 95       	lsr	r25
     a3a:	87 95       	ror	r24
     a3c:	92 95       	swap	r25
     a3e:	82 95       	swap	r24
     a40:	8f 70       	andi	r24, 0x0F	; 15
     a42:	89 27       	eor	r24, r25
     a44:	9f 70       	andi	r25, 0x0F	; 15
     a46:	89 27       	eor	r24, r25
     a48:	81 70       	andi	r24, 0x01	; 1
     a4a:	90 70       	andi	r25, 0x00	; 0
     a4c:	82 17       	cp	r24, r18
     a4e:	93 07       	cpc	r25, r19
     a50:	81 f7       	brne	.-32     	; 0xa32
     a52:	51 e3       	ldi	r21, 0x31	; 49
     a54:	50 93 c6 00 	sts	0x00C6, r21
     a58:	21 e0       	ldi	r18, 0x01	; 1
     a5a:	30 e0       	ldi	r19, 0x00	; 0
     a5c:	80 91 c0 00 	lds	r24, 0x00C0
     a60:	99 27       	eor	r25, r25
     a62:	96 95       	lsr	r25
     a64:	87 95       	ror	r24
     a66:	92 95       	swap	r25
     a68:	82 95       	swap	r24
     a6a:	8f 70       	andi	r24, 0x0F	; 15
     a6c:	89 27       	eor	r24, r25
     a6e:	9f 70       	andi	r25, 0x0F	; 15
     a70:	89 27       	eor	r24, r25
     a72:	81 70       	andi	r24, 0x01	; 1
     a74:	90 70       	andi	r25, 0x00	; 0
     a76:	82 17       	cp	r24, r18
     a78:	93 07       	cpc	r25, r19
     a7a:	81 f7       	brne	.-32     	; 0xa5c
     a7c:	60 e3       	ldi	r22, 0x30	; 48
     a7e:	60 93 c6 00 	sts	0x00C6, r22
     a82:	21 e0       	ldi	r18, 0x01	; 1
     a84:	30 e0       	ldi	r19, 0x00	; 0
     a86:	80 91 c0 00 	lds	r24, 0x00C0
     a8a:	99 27       	eor	r25, r25
     a8c:	96 95       	lsr	r25
     a8e:	87 95       	ror	r24
     a90:	92 95       	swap	r25
     a92:	82 95       	swap	r24
     a94:	8f 70       	andi	r24, 0x0F	; 15
     a96:	89 27       	eor	r24, r25
     a98:	9f 70       	andi	r25, 0x0F	; 15
     a9a:	89 27       	eor	r24, r25
     a9c:	81 70       	andi	r24, 0x01	; 1
     a9e:	90 70       	andi	r25, 0x00	; 0
     aa0:	82 17       	cp	r24, r18
     aa2:	93 07       	cpc	r25, r19
     aa4:	81 f7       	brne	.-32     	; 0xa86
     aa6:	ac cc       	rjmp	.-1704   	; 0x400
     aa8:	21 e0       	ldi	r18, 0x01	; 1
     aaa:	30 e0       	ldi	r19, 0x00	; 0
     aac:	80 91 c0 00 	lds	r24, 0x00C0
     ab0:	99 27       	eor	r25, r25
     ab2:	96 95       	lsr	r25
     ab4:	87 95       	ror	r24
     ab6:	92 95       	swap	r25
     ab8:	82 95       	swap	r24
     aba:	8f 70       	andi	r24, 0x0F	; 15
     abc:	89 27       	eor	r24, r25
     abe:	9f 70       	andi	r25, 0x0F	; 15
     ac0:	89 27       	eor	r24, r25
     ac2:	81 70       	andi	r24, 0x01	; 1
     ac4:	90 70       	andi	r25, 0x00	; 0
     ac6:	82 17       	cp	r24, r18
     ac8:	93 07       	cpc	r25, r19
     aca:	81 f7       	brne	.-32     	; 0xaac
     acc:	41 e3       	ldi	r20, 0x31	; 49
     ace:	40 93 c6 00 	sts	0x00C6, r20
     ad2:	21 e0       	ldi	r18, 0x01	; 1
     ad4:	30 e0       	ldi	r19, 0x00	; 0
     ad6:	80 91 c0 00 	lds	r24, 0x00C0
     ada:	99 27       	eor	r25, r25
     adc:	96 95       	lsr	r25
     ade:	87 95       	ror	r24
     ae0:	92 95       	swap	r25
     ae2:	82 95       	swap	r24
     ae4:	8f 70       	andi	r24, 0x0F	; 15
     ae6:	89 27       	eor	r24, r25
     ae8:	9f 70       	andi	r25, 0x0F	; 15
     aea:	89 27       	eor	r24, r25
     aec:	81 70       	andi	r24, 0x01	; 1
     aee:	90 70       	andi	r25, 0x00	; 0
     af0:	82 17       	cp	r24, r18
     af2:	93 07       	cpc	r25, r19
     af4:	81 f7       	brne	.-32     	; 0xad6
     af6:	51 e3       	ldi	r21, 0x31	; 49
     af8:	50 93 c6 00 	sts	0x00C6, r21
     afc:	21 e0       	ldi	r18, 0x01	; 1
     afe:	30 e0       	ldi	r19, 0x00	; 0
     b00:	80 91 c0 00 	lds	r24, 0x00C0
     b04:	99 27       	eor	r25, r25
     b06:	96 95       	lsr	r25
     b08:	87 95       	ror	r24
     b0a:	92 95       	swap	r25
     b0c:	82 95       	swap	r24
     b0e:	8f 70       	andi	r24, 0x0F	; 15
     b10:	89 27       	eor	r24, r25
     b12:	9f 70       	andi	r25, 0x0F	; 15
     b14:	89 27       	eor	r24, r25
     b16:	81 70       	andi	r24, 0x01	; 1
     b18:	90 70       	andi	r25, 0x00	; 0
     b1a:	82 17       	cp	r24, r18
     b1c:	93 07       	cpc	r25, r19
     b1e:	81 f7       	brne	.-32     	; 0xb00
     b20:	60 e3       	ldi	r22, 0x30	; 48
     b22:	60 93 c6 00 	sts	0x00C6, r22
     b26:	21 e0       	ldi	r18, 0x01	; 1
     b28:	30 e0       	ldi	r19, 0x00	; 0
     b2a:	80 91 c0 00 	lds	r24, 0x00C0
     b2e:	99 27       	eor	r25, r25
     b30:	96 95       	lsr	r25
     b32:	87 95       	ror	r24
     b34:	92 95       	swap	r25
     b36:	82 95       	swap	r24
     b38:	8f 70       	andi	r24, 0x0F	; 15
     b3a:	89 27       	eor	r24, r25
     b3c:	9f 70       	andi	r25, 0x0F	; 15
     b3e:	89 27       	eor	r24, r25
     b40:	81 70       	andi	r24, 0x01	; 1
     b42:	90 70       	andi	r25, 0x00	; 0
     b44:	82 17       	cp	r24, r18
     b46:	93 07       	cpc	r25, r19
     b48:	81 f7       	brne	.-32     	; 0xb2a
     b4a:	5a cc       	rjmp	.-1868   	; 0x400
     b4c:	89 2b       	or	r24, r25
     b4e:	09 f4       	brne	.+2      	; 0xb52
     b50:	54 c0       	rjmp	.+168    	; 0xbfa
     b52:	08 95       	ret
     b54:	21 e0       	ldi	r18, 0x01	; 1
     b56:	30 e0       	ldi	r19, 0x00	; 0
     b58:	80 91 c0 00 	lds	r24, 0x00C0
     b5c:	99 27       	eor	r25, r25
     b5e:	96 95       	lsr	r25
     b60:	87 95       	ror	r24
     b62:	92 95       	swap	r25
     b64:	82 95       	swap	r24
     b66:	8f 70       	andi	r24, 0x0F	; 15
     b68:	89 27       	eor	r24, r25
     b6a:	9f 70       	andi	r25, 0x0F	; 15
     b6c:	89 27       	eor	r24, r25
     b6e:	81 70       	andi	r24, 0x01	; 1
     b70:	90 70       	andi	r25, 0x00	; 0
     b72:	82 17       	cp	r24, r18
     b74:	93 07       	cpc	r25, r19
     b76:	81 f7       	brne	.-32     	; 0xb58
     b78:	71 e3       	ldi	r23, 0x31	; 49
     b7a:	70 93 c6 00 	sts	0x00C6, r23
     b7e:	21 e0       	ldi	r18, 0x01	; 1
     b80:	30 e0       	ldi	r19, 0x00	; 0
     b82:	80 91 c0 00 	lds	r24, 0x00C0
     b86:	99 27       	eor	r25, r25
     b88:	96 95       	lsr	r25
     b8a:	87 95       	ror	r24
     b8c:	92 95       	swap	r25
     b8e:	82 95       	swap	r24
     b90:	8f 70       	andi	r24, 0x0F	; 15
     b92:	89 27       	eor	r24, r25
     b94:	9f 70       	andi	r25, 0x0F	; 15
     b96:	89 27       	eor	r24, r25
     b98:	81 70       	andi	r24, 0x01	; 1
     b9a:	90 70       	andi	r25, 0x00	; 0
     b9c:	82 17       	cp	r24, r18
     b9e:	93 07       	cpc	r25, r19
     ba0:	81 f7       	brne	.-32     	; 0xb82
     ba2:	91 e3       	ldi	r25, 0x31	; 49
     ba4:	90 93 c6 00 	sts	0x00C6, r25
     ba8:	21 e0       	ldi	r18, 0x01	; 1
     baa:	30 e0       	ldi	r19, 0x00	; 0
     bac:	80 91 c0 00 	lds	r24, 0x00C0
     bb0:	99 27       	eor	r25, r25
     bb2:	96 95       	lsr	r25
     bb4:	87 95       	ror	r24
     bb6:	92 95       	swap	r25
     bb8:	82 95       	swap	r24
     bba:	8f 70       	andi	r24, 0x0F	; 15
     bbc:	89 27       	eor	r24, r25
     bbe:	9f 70       	andi	r25, 0x0F	; 15
     bc0:	89 27       	eor	r24, r25
     bc2:	81 70       	andi	r24, 0x01	; 1
     bc4:	90 70       	andi	r25, 0x00	; 0
     bc6:	82 17       	cp	r24, r18
     bc8:	93 07       	cpc	r25, r19
     bca:	81 f7       	brne	.-32     	; 0xbac
     bcc:	a1 e3       	ldi	r26, 0x31	; 49
     bce:	a0 93 c6 00 	sts	0x00C6, r26
     bd2:	21 e0       	ldi	r18, 0x01	; 1
     bd4:	30 e0       	ldi	r19, 0x00	; 0
     bd6:	80 91 c0 00 	lds	r24, 0x00C0
     bda:	99 27       	eor	r25, r25
     bdc:	96 95       	lsr	r25
     bde:	87 95       	ror	r24
     be0:	92 95       	swap	r25
     be2:	82 95       	swap	r24
     be4:	8f 70       	andi	r24, 0x0F	; 15
     be6:	89 27       	eor	r24, r25
     be8:	9f 70       	andi	r25, 0x0F	; 15
     bea:	89 27       	eor	r24, r25
     bec:	81 70       	andi	r24, 0x01	; 1
     bee:	90 70       	andi	r25, 0x00	; 0
     bf0:	82 17       	cp	r24, r18
     bf2:	93 07       	cpc	r25, r19
     bf4:	81 f7       	brne	.-32     	; 0xbd6
     bf6:	80 e3       	ldi	r24, 0x30	; 48
     bf8:	4d cb       	rjmp	.-2406   	; 0x294
     bfa:	21 e0       	ldi	r18, 0x01	; 1
     bfc:	30 e0       	ldi	r19, 0x00	; 0
     bfe:	80 91 c0 00 	lds	r24, 0x00C0
     c02:	99 27       	eor	r25, r25
     c04:	96 95       	lsr	r25
     c06:	87 95       	ror	r24
     c08:	92 95       	swap	r25
     c0a:	82 95       	swap	r24
     c0c:	8f 70       	andi	r24, 0x0F	; 15
     c0e:	89 27       	eor	r24, r25
     c10:	9f 70       	andi	r25, 0x0F	; 15
     c12:	89 27       	eor	r24, r25
     c14:	81 70       	andi	r24, 0x01	; 1
     c16:	90 70       	andi	r25, 0x00	; 0
     c18:	82 17       	cp	r24, r18
     c1a:	93 07       	cpc	r25, r19
     c1c:	81 f7       	brne	.-32     	; 0xbfe
     c1e:	80 e3       	ldi	r24, 0x30	; 48
     c20:	80 93 c6 00 	sts	0x00C6, r24
     c24:	21 e0       	ldi	r18, 0x01	; 1
     c26:	30 e0       	ldi	r19, 0x00	; 0
     c28:	80 91 c0 00 	lds	r24, 0x00C0
     c2c:	99 27       	eor	r25, r25
     c2e:	96 95       	lsr	r25
     c30:	87 95       	ror	r24
     c32:	92 95       	swap	r25
     c34:	82 95       	swap	r24
     c36:	8f 70       	andi	r24, 0x0F	; 15
     c38:	89 27       	eor	r24, r25
     c3a:	9f 70       	andi	r25, 0x0F	; 15
     c3c:	89 27       	eor	r24, r25
     c3e:	81 70       	andi	r24, 0x01	; 1
     c40:	90 70       	andi	r25, 0x00	; 0
     c42:	82 17       	cp	r24, r18
     c44:	93 07       	cpc	r25, r19
     c46:	81 f7       	brne	.-32     	; 0xc28
     c48:	20 e3       	ldi	r18, 0x30	; 48
     c4a:	20 93 c6 00 	sts	0x00C6, r18
     c4e:	21 e0       	ldi	r18, 0x01	; 1
     c50:	30 e0       	ldi	r19, 0x00	; 0
     c52:	80 91 c0 00 	lds	r24, 0x00C0
     c56:	99 27       	eor	r25, r25
     c58:	96 95       	lsr	r25
     c5a:	87 95       	ror	r24
     c5c:	92 95       	swap	r25
     c5e:	82 95       	swap	r24
     c60:	8f 70       	andi	r24, 0x0F	; 15
     c62:	89 27       	eor	r24, r25
     c64:	9f 70       	andi	r25, 0x0F	; 15
     c66:	89 27       	eor	r24, r25
     c68:	81 70       	andi	r24, 0x01	; 1
     c6a:	90 70       	andi	r25, 0x00	; 0
     c6c:	82 17       	cp	r24, r18
     c6e:	93 07       	cpc	r25, r19
     c70:	81 f7       	brne	.-32     	; 0xc52
     c72:	30 e3       	ldi	r19, 0x30	; 48
     c74:	30 93 c6 00 	sts	0x00C6, r19
     c78:	21 e0       	ldi	r18, 0x01	; 1
     c7a:	30 e0       	ldi	r19, 0x00	; 0
     c7c:	80 91 c0 00 	lds	r24, 0x00C0
     c80:	99 27       	eor	r25, r25
     c82:	96 95       	lsr	r25
     c84:	87 95       	ror	r24
     c86:	92 95       	swap	r25
     c88:	82 95       	swap	r24
     c8a:	8f 70       	andi	r24, 0x0F	; 15
     c8c:	89 27       	eor	r24, r25
     c8e:	9f 70       	andi	r25, 0x0F	; 15
     c90:	89 27       	eor	r24, r25
     c92:	81 70       	andi	r24, 0x01	; 1
     c94:	90 70       	andi	r25, 0x00	; 0
     c96:	82 17       	cp	r24, r18
     c98:	93 07       	cpc	r25, r19
     c9a:	81 f7       	brne	.-32     	; 0xc7c
     c9c:	80 e3       	ldi	r24, 0x30	; 48
     c9e:	fa ca       	rjmp	.-2572   	; 0x294

00000ca0 <UART_send_BIN8>:
	case(0):
		send_byte_serial('0');
		send_byte_serial('0');
		send_byte_serial('0');
		send_byte_serial('0');
		break;
	case(1):
		send_byte_serial('0');
		send_byte_serial('0');
		send_byte_serial('0');
		send_byte_serial('1');
		break;
	case(2):
		send_byte_serial('0');
		send_byte_serial('0');
		send_byte_serial('1');
		send_byte_serial('0');
		break;
	case(3):
		send_byte_serial('0');
		send_byte_serial('0');
		send_byte_serial('1');
		send_byte_serial('1');
		break;
	case(4):
		send_byte_serial('0');
		send_byte_serial('1');
		send_byte_serial('0');
		send_byte_serial('0');
		break;
	case(5):
		send_byte_serial('0');
		send_byte_serial('1');
		send_byte_serial('0');
		send_byte_serial('1');
		break;
	case(6):
		send_byte_serial('0');
		send_byte_serial('1');
		send_byte_serial('1');
		send_byte_serial('0');
		break;
	case(7):
		send_byte_serial('0');
		send_byte_serial('1');
		send_byte_serial('1');
		send_byte_serial('1');
		break;
	case(8):
		send_byte_serial('1');
		send_byte_serial('0');
		send_byte_serial('0');
		send_byte_serial('0');
		break;
	case(9):
		send_byte_serial('1');
		send_byte_serial('0');
		send_byte_serial('0');
		send_byte_serial('1');
		break;
	case(10):
		send_byte_serial('1');
		send_byte_serial('0');
		send_byte_serial('1');
		send_byte_serial('0');
		break;
	case(11):
		send_byte_serial('1');
		send_byte_serial('0');
		send_byte_serial('1');
		send_byte_serial('1');
		break;
	case(12):
		send_byte_serial('1');
		send_byte_serial('1');
		send_byte_serial('0');
		send_byte_serial('0');
		break;
	case(13):
		send_byte_serial('1');
		send_byte_serial('1');
		send_byte_serial('0');
		send_byte_serial('1');
		break;
	case(14):
		send_byte_serial('1');
		send_byte_serial('1');
		send_byte_serial('1');
		send_byte_serial('0');
		break;
	case(15):
		send_byte_serial('1');
		send_byte_serial('1');
		send_byte_serial('1');
		send_byte_serial('1');
		break;
	}	
}

//Sends out tosend as ASCII text in 'b01101010' format
void UART_send_BIN8(uint8_t lowb){
     ca0:	cf 93       	push	r28
     ca2:	c8 2f       	mov	r28, r24
     ca4:	21 e0       	ldi	r18, 0x01	; 1
     ca6:	30 e0       	ldi	r19, 0x00	; 0
     ca8:	80 91 c0 00 	lds	r24, 0x00C0
     cac:	99 27       	eor	r25, r25
     cae:	96 95       	lsr	r25
     cb0:	87 95       	ror	r24
     cb2:	92 95       	swap	r25
     cb4:	82 95       	swap	r24
     cb6:	8f 70       	andi	r24, 0x0F	; 15
     cb8:	89 27       	eor	r24, r25
     cba:	9f 70       	andi	r25, 0x0F	; 15
     cbc:	89 27       	eor	r24, r25
     cbe:	81 70       	andi	r24, 0x01	; 1
     cc0:	90 70       	andi	r25, 0x00	; 0
     cc2:	82 17       	cp	r24, r18
     cc4:	93 07       	cpc	r25, r19
     cc6:	81 f7       	brne	.-32     	; 0xca8
     cc8:	82 e6       	ldi	r24, 0x62	; 98
     cca:	80 93 c6 00 	sts	0x00C6, r24
	send_byte_serial('b');
	UART_send_BIN4(lowb>>4);
     cce:	8c 2f       	mov	r24, r28
     cd0:	82 95       	swap	r24
     cd2:	8f 70       	andi	r24, 0x0F	; 15
     cd4:	0e 94 df 00 	call	0x1be
	UART_send_BIN4(lowb & 0x0F);
     cd8:	8c 2f       	mov	r24, r28
     cda:	8f 70       	andi	r24, 0x0F	; 15
     cdc:	0e 94 df 00 	call	0x1be
     ce0:	cf 91       	pop	r28
     ce2:	08 95       	ret

00000ce4 <UART_send_HEX4>:
}
	
void UART_send_HEX4(uint8_t lowb){
	switch(lowb){
     ce4:	99 27       	eor	r25, r25
     ce6:	87 30       	cpi	r24, 0x07	; 7
     ce8:	91 05       	cpc	r25, r1
     cea:	09 f4       	brne	.+2      	; 0xcee
     cec:	4a c0       	rjmp	.+148    	; 0xd82
     cee:	88 30       	cpi	r24, 0x08	; 8
     cf0:	91 05       	cpc	r25, r1
     cf2:	24 f5       	brge	.+72     	; 0xd3c
     cf4:	83 30       	cpi	r24, 0x03	; 3
     cf6:	91 05       	cpc	r25, r1
     cf8:	09 f4       	brne	.+2      	; 0xcfc
     cfa:	9a c0       	rjmp	.+308    	; 0xe30
     cfc:	84 30       	cpi	r24, 0x04	; 4
     cfe:	91 05       	cpc	r25, r1
     d00:	0c f0       	brlt	.+2      	; 0xd04
     d02:	55 c0       	rjmp	.+170    	; 0xdae
     d04:	81 30       	cpi	r24, 0x01	; 1
     d06:	91 05       	cpc	r25, r1
     d08:	09 f4       	brne	.+2      	; 0xd0c
     d0a:	fa c0       	rjmp	.+500    	; 0xf00
     d0c:	82 30       	cpi	r24, 0x02	; 2
     d0e:	91 05       	cpc	r25, r1
     d10:	0c f4       	brge	.+2      	; 0xd14
     d12:	44 c1       	rjmp	.+648    	; 0xf9c
     d14:	21 e0       	ldi	r18, 0x01	; 1
     d16:	30 e0       	ldi	r19, 0x00	; 0
     d18:	80 91 c0 00 	lds	r24, 0x00C0
     d1c:	99 27       	eor	r25, r25
     d1e:	96 95       	lsr	r25
     d20:	87 95       	ror	r24
     d22:	92 95       	swap	r25
     d24:	82 95       	swap	r24
     d26:	8f 70       	andi	r24, 0x0F	; 15
     d28:	89 27       	eor	r24, r25
     d2a:	9f 70       	andi	r25, 0x0F	; 15
     d2c:	89 27       	eor	r24, r25
     d2e:	81 70       	andi	r24, 0x01	; 1
     d30:	90 70       	andi	r25, 0x00	; 0
     d32:	82 17       	cp	r24, r18
     d34:	93 07       	cpc	r25, r19
     d36:	81 f7       	brne	.-32     	; 0xd18
     d38:	82 e3       	ldi	r24, 0x32	; 50
     d3a:	36 c0       	rjmp	.+108    	; 0xda8
     d3c:	8b 30       	cpi	r24, 0x0B	; 11
     d3e:	91 05       	cpc	r25, r1
     d40:	09 f4       	brne	.+2      	; 0xd44
     d42:	60 c0       	rjmp	.+192    	; 0xe04
     d44:	8c 30       	cpi	r24, 0x0C	; 12
     d46:	91 05       	cpc	r25, r1
     d48:	0c f0       	brlt	.+2      	; 0xd4c
     d4a:	4c c0       	rjmp	.+152    	; 0xde4
     d4c:	89 30       	cpi	r24, 0x09	; 9
     d4e:	91 05       	cpc	r25, r1
     d50:	09 f4       	brne	.+2      	; 0xd54
     d52:	e8 c0       	rjmp	.+464    	; 0xf24
     d54:	0a 97       	sbiw	r24, 0x0a	; 10
     d56:	0c f0       	brlt	.+2      	; 0xd5a
     d58:	81 c0       	rjmp	.+258    	; 0xe5c
     d5a:	21 e0       	ldi	r18, 0x01	; 1
     d5c:	30 e0       	ldi	r19, 0x00	; 0
     d5e:	80 91 c0 00 	lds	r24, 0x00C0
     d62:	99 27       	eor	r25, r25
     d64:	96 95       	lsr	r25
     d66:	87 95       	ror	r24
     d68:	92 95       	swap	r25
     d6a:	82 95       	swap	r24
     d6c:	8f 70       	andi	r24, 0x0F	; 15
     d6e:	89 27       	eor	r24, r25
     d70:	9f 70       	andi	r25, 0x0F	; 15
     d72:	89 27       	eor	r24, r25
     d74:	81 70       	andi	r24, 0x01	; 1
     d76:	90 70       	andi	r25, 0x00	; 0
     d78:	82 17       	cp	r24, r18
     d7a:	93 07       	cpc	r25, r19
     d7c:	81 f7       	brne	.-32     	; 0xd5e
     d7e:	88 e3       	ldi	r24, 0x38	; 56
     d80:	13 c0       	rjmp	.+38     	; 0xda8
     d82:	21 e0       	ldi	r18, 0x01	; 1
     d84:	30 e0       	ldi	r19, 0x00	; 0
     d86:	80 91 c0 00 	lds	r24, 0x00C0
     d8a:	99 27       	eor	r25, r25
     d8c:	96 95       	lsr	r25
     d8e:	87 95       	ror	r24
     d90:	92 95       	swap	r25
     d92:	82 95       	swap	r24
     d94:	8f 70       	andi	r24, 0x0F	; 15
     d96:	89 27       	eor	r24, r25
     d98:	9f 70       	andi	r25, 0x0F	; 15
     d9a:	89 27       	eor	r24, r25
     d9c:	81 70       	andi	r24, 0x01	; 1
     d9e:	90 70       	andi	r25, 0x00	; 0
     da0:	82 17       	cp	r24, r18
     da2:	93 07       	cpc	r25, r19
     da4:	81 f7       	brne	.-32     	; 0xd86
     da6:	87 e3       	ldi	r24, 0x37	; 55
     da8:	80 93 c6 00 	sts	0x00C6, r24
     dac:	08 95       	ret
     dae:	85 30       	cpi	r24, 0x05	; 5
     db0:	91 05       	cpc	r25, r1
     db2:	09 f4       	brne	.+2      	; 0xdb6
     db4:	cb c0       	rjmp	.+406    	; 0xf4c
     db6:	06 97       	sbiw	r24, 0x06	; 6
     db8:	0c f0       	brlt	.+2      	; 0xdbc
     dba:	78 c0       	rjmp	.+240    	; 0xeac
     dbc:	21 e0       	ldi	r18, 0x01	; 1
     dbe:	30 e0       	ldi	r19, 0x00	; 0
     dc0:	80 91 c0 00 	lds	r24, 0x00C0
     dc4:	99 27       	eor	r25, r25
     dc6:	96 95       	lsr	r25
     dc8:	87 95       	ror	r24
     dca:	92 95       	swap	r25
     dcc:	82 95       	swap	r24
     dce:	8f 70       	andi	r24, 0x0F	; 15
     dd0:	89 27       	eor	r24, r25
     dd2:	9f 70       	andi	r25, 0x0F	; 15
     dd4:	89 27       	eor	r24, r25
     dd6:	81 70       	andi	r24, 0x01	; 1
     dd8:	90 70       	andi	r25, 0x00	; 0
     dda:	82 17       	cp	r24, r18
     ddc:	93 07       	cpc	r25, r19
     dde:	81 f7       	brne	.-32     	; 0xdc0
     de0:	84 e3       	ldi	r24, 0x34	; 52
     de2:	e2 cf       	rjmp	.-60     	; 0xda8
     de4:	8d 30       	cpi	r24, 0x0D	; 13
     de6:	91 05       	cpc	r25, r1
     de8:	09 f4       	brne	.+2      	; 0xdec
     dea:	c4 c0       	rjmp	.+392    	; 0xf74
     dec:	8d 30       	cpi	r24, 0x0D	; 13
     dee:	91 05       	cpc	r25, r1
     df0:	0c f4       	brge	.+2      	; 0xdf4
     df2:	48 c0       	rjmp	.+144    	; 0xe84
     df4:	8e 30       	cpi	r24, 0x0E	; 14
     df6:	91 05       	cpc	r25, r1
     df8:	09 f4       	brne	.+2      	; 0xdfc
     dfa:	d3 c0       	rjmp	.+422    	; 0xfa2
     dfc:	0f 97       	sbiw	r24, 0x0f	; 15
     dfe:	09 f4       	brne	.+2      	; 0xe02
     e00:	69 c0       	rjmp	.+210    	; 0xed4
     e02:	08 95       	ret
     e04:	21 e0       	ldi	r18, 0x01	; 1
     e06:	30 e0       	ldi	r19, 0x00	; 0
     e08:	80 91 c0 00 	lds	r24, 0x00C0
     e0c:	99 27       	eor	r25, r25
     e0e:	96 95       	lsr	r25
     e10:	87 95       	ror	r24
     e12:	92 95       	swap	r25
     e14:	82 95       	swap	r24
     e16:	8f 70       	andi	r24, 0x0F	; 15
     e18:	89 27       	eor	r24, r25
     e1a:	9f 70       	andi	r25, 0x0F	; 15
     e1c:	89 27       	eor	r24, r25
     e1e:	81 70       	andi	r24, 0x01	; 1
     e20:	90 70       	andi	r25, 0x00	; 0
     e22:	82 17       	cp	r24, r18
     e24:	93 07       	cpc	r25, r19
     e26:	81 f7       	brne	.-32     	; 0xe08
     e28:	82 e4       	ldi	r24, 0x42	; 66
     e2a:	80 93 c6 00 	sts	0x00C6, r24
     e2e:	08 95       	ret
     e30:	21 e0       	ldi	r18, 0x01	; 1
     e32:	30 e0       	ldi	r19, 0x00	; 0
     e34:	80 91 c0 00 	lds	r24, 0x00C0
     e38:	99 27       	eor	r25, r25
     e3a:	96 95       	lsr	r25
     e3c:	87 95       	ror	r24
     e3e:	92 95       	swap	r25
     e40:	82 95       	swap	r24
     e42:	8f 70       	andi	r24, 0x0F	; 15
     e44:	89 27       	eor	r24, r25
     e46:	9f 70       	andi	r25, 0x0F	; 15
     e48:	89 27       	eor	r24, r25
     e4a:	81 70       	andi	r24, 0x01	; 1
     e4c:	90 70       	andi	r25, 0x00	; 0
     e4e:	82 17       	cp	r24, r18
     e50:	93 07       	cpc	r25, r19
     e52:	81 f7       	brne	.-32     	; 0xe34
     e54:	83 e3       	ldi	r24, 0x33	; 51
     e56:	80 93 c6 00 	sts	0x00C6, r24
     e5a:	08 95       	ret
     e5c:	21 e0       	ldi	r18, 0x01	; 1
     e5e:	30 e0       	ldi	r19, 0x00	; 0
     e60:	80 91 c0 00 	lds	r24, 0x00C0
     e64:	99 27       	eor	r25, r25
     e66:	96 95       	lsr	r25
     e68:	87 95       	ror	r24
     e6a:	92 95       	swap	r25
     e6c:	82 95       	swap	r24
     e6e:	8f 70       	andi	r24, 0x0F	; 15
     e70:	89 27       	eor	r24, r25
     e72:	9f 70       	andi	r25, 0x0F	; 15
     e74:	89 27       	eor	r24, r25
     e76:	81 70       	andi	r24, 0x01	; 1
     e78:	90 70       	andi	r25, 0x00	; 0
     e7a:	82 17       	cp	r24, r18
     e7c:	93 07       	cpc	r25, r19
     e7e:	81 f7       	brne	.-32     	; 0xe60
     e80:	81 e4       	ldi	r24, 0x41	; 65
     e82:	92 cf       	rjmp	.-220    	; 0xda8
     e84:	21 e0       	ldi	r18, 0x01	; 1
     e86:	30 e0       	ldi	r19, 0x00	; 0
     e88:	80 91 c0 00 	lds	r24, 0x00C0
     e8c:	99 27       	eor	r25, r25
     e8e:	96 95       	lsr	r25
     e90:	87 95       	ror	r24
     e92:	92 95       	swap	r25
     e94:	82 95       	swap	r24
     e96:	8f 70       	andi	r24, 0x0F	; 15
     e98:	89 27       	eor	r24, r25
     e9a:	9f 70       	andi	r25, 0x0F	; 15
     e9c:	89 27       	eor	r24, r25
     e9e:	81 70       	andi	r24, 0x01	; 1
     ea0:	90 70       	andi	r25, 0x00	; 0
     ea2:	82 17       	cp	r24, r18
     ea4:	93 07       	cpc	r25, r19
     ea6:	81 f7       	brne	.-32     	; 0xe88
     ea8:	83 e4       	ldi	r24, 0x43	; 67
     eaa:	7e cf       	rjmp	.-260    	; 0xda8
     eac:	21 e0       	ldi	r18, 0x01	; 1
     eae:	30 e0       	ldi	r19, 0x00	; 0
     eb0:	80 91 c0 00 	lds	r24, 0x00C0
     eb4:	99 27       	eor	r25, r25
     eb6:	96 95       	lsr	r25
     eb8:	87 95       	ror	r24
     eba:	92 95       	swap	r25
     ebc:	82 95       	swap	r24
     ebe:	8f 70       	andi	r24, 0x0F	; 15
     ec0:	89 27       	eor	r24, r25
     ec2:	9f 70       	andi	r25, 0x0F	; 15
     ec4:	89 27       	eor	r24, r25
     ec6:	81 70       	andi	r24, 0x01	; 1
     ec8:	90 70       	andi	r25, 0x00	; 0
     eca:	82 17       	cp	r24, r18
     ecc:	93 07       	cpc	r25, r19
     ece:	81 f7       	brne	.-32     	; 0xeb0
     ed0:	86 e3       	ldi	r24, 0x36	; 54
     ed2:	6a cf       	rjmp	.-300    	; 0xda8
     ed4:	21 e0       	ldi	r18, 0x01	; 1
     ed6:	30 e0       	ldi	r19, 0x00	; 0
     ed8:	80 91 c0 00 	lds	r24, 0x00C0
     edc:	99 27       	eor	r25, r25
     ede:	96 95       	lsr	r25
     ee0:	87 95       	ror	r24
     ee2:	92 95       	swap	r25
     ee4:	82 95       	swap	r24
     ee6:	8f 70       	andi	r24, 0x0F	; 15
     ee8:	89 27       	eor	r24, r25
     eea:	9f 70       	andi	r25, 0x0F	; 15
     eec:	89 27       	eor	r24, r25
     eee:	81 70       	andi	r24, 0x01	; 1
     ef0:	90 70       	andi	r25, 0x00	; 0
     ef2:	82 17       	cp	r24, r18
     ef4:	93 07       	cpc	r25, r19
     ef6:	81 f7       	brne	.-32     	; 0xed8
     ef8:	86 e4       	ldi	r24, 0x46	; 70
     efa:	80 93 c6 00 	sts	0x00C6, r24
     efe:	08 95       	ret
     f00:	9c 01       	movw	r18, r24
     f02:	80 91 c0 00 	lds	r24, 0x00C0
     f06:	99 27       	eor	r25, r25
     f08:	96 95       	lsr	r25
     f0a:	87 95       	ror	r24
     f0c:	92 95       	swap	r25
     f0e:	82 95       	swap	r24
     f10:	8f 70       	andi	r24, 0x0F	; 15
     f12:	89 27       	eor	r24, r25
     f14:	9f 70       	andi	r25, 0x0F	; 15
     f16:	89 27       	eor	r24, r25
     f18:	82 27       	eor	r24, r18
     f1a:	93 27       	eor	r25, r19
     f1c:	80 fd       	sbrc	r24, 0
     f1e:	f1 cf       	rjmp	.-30     	; 0xf02
     f20:	81 e3       	ldi	r24, 0x31	; 49
     f22:	42 cf       	rjmp	.-380    	; 0xda8
     f24:	21 e0       	ldi	r18, 0x01	; 1
     f26:	30 e0       	ldi	r19, 0x00	; 0
     f28:	80 91 c0 00 	lds	r24, 0x00C0
     f2c:	99 27       	eor	r25, r25
     f2e:	96 95       	lsr	r25
     f30:	87 95       	ror	r24
     f32:	92 95       	swap	r25
     f34:	82 95       	swap	r24
     f36:	8f 70       	andi	r24, 0x0F	; 15
     f38:	89 27       	eor	r24, r25
     f3a:	9f 70       	andi	r25, 0x0F	; 15
     f3c:	89 27       	eor	r24, r25
     f3e:	81 70       	andi	r24, 0x01	; 1
     f40:	90 70       	andi	r25, 0x00	; 0
     f42:	82 17       	cp	r24, r18
     f44:	93 07       	cpc	r25, r19
     f46:	81 f7       	brne	.-32     	; 0xf28
     f48:	89 e3       	ldi	r24, 0x39	; 57
     f4a:	2e cf       	rjmp	.-420    	; 0xda8
     f4c:	21 e0       	ldi	r18, 0x01	; 1
     f4e:	30 e0       	ldi	r19, 0x00	; 0
     f50:	80 91 c0 00 	lds	r24, 0x00C0
     f54:	99 27       	eor	r25, r25
     f56:	96 95       	lsr	r25
     f58:	87 95       	ror	r24
     f5a:	92 95       	swap	r25
     f5c:	82 95       	swap	r24
     f5e:	8f 70       	andi	r24, 0x0F	; 15
     f60:	89 27       	eor	r24, r25
     f62:	9f 70       	andi	r25, 0x0F	; 15
     f64:	89 27       	eor	r24, r25
     f66:	81 70       	andi	r24, 0x01	; 1
     f68:	90 70       	andi	r25, 0x00	; 0
     f6a:	82 17       	cp	r24, r18
     f6c:	93 07       	cpc	r25, r19
     f6e:	81 f7       	brne	.-32     	; 0xf50
     f70:	85 e3       	ldi	r24, 0x35	; 53
     f72:	1a cf       	rjmp	.-460    	; 0xda8
     f74:	21 e0       	ldi	r18, 0x01	; 1
     f76:	30 e0       	ldi	r19, 0x00	; 0
     f78:	80 91 c0 00 	lds	r24, 0x00C0
     f7c:	99 27       	eor	r25, r25
     f7e:	96 95       	lsr	r25
     f80:	87 95       	ror	r24
     f82:	92 95       	swap	r25
     f84:	82 95       	swap	r24
     f86:	8f 70       	andi	r24, 0x0F	; 15
     f88:	89 27       	eor	r24, r25
     f8a:	9f 70       	andi	r25, 0x0F	; 15
     f8c:	89 27       	eor	r24, r25
     f8e:	81 70       	andi	r24, 0x01	; 1
     f90:	90 70       	andi	r25, 0x00	; 0
     f92:	82 17       	cp	r24, r18
     f94:	93 07       	cpc	r25, r19
     f96:	81 f7       	brne	.-32     	; 0xf78
     f98:	84 e4       	ldi	r24, 0x44	; 68
     f9a:	06 cf       	rjmp	.-500    	; 0xda8
     f9c:	89 2b       	or	r24, r25
     f9e:	a9 f0       	breq	.+42     	; 0xfca
     fa0:	08 95       	ret
     fa2:	21 e0       	ldi	r18, 0x01	; 1
     fa4:	30 e0       	ldi	r19, 0x00	; 0
     fa6:	80 91 c0 00 	lds	r24, 0x00C0
     faa:	99 27       	eor	r25, r25
     fac:	96 95       	lsr	r25
     fae:	87 95       	ror	r24
     fb0:	92 95       	swap	r25
     fb2:	82 95       	swap	r24
     fb4:	8f 70       	andi	r24, 0x0F	; 15
     fb6:	89 27       	eor	r24, r25
     fb8:	9f 70       	andi	r25, 0x0F	; 15
     fba:	89 27       	eor	r24, r25
     fbc:	81 70       	andi	r24, 0x01	; 1
     fbe:	90 70       	andi	r25, 0x00	; 0
     fc0:	82 17       	cp	r24, r18
     fc2:	93 07       	cpc	r25, r19
     fc4:	81 f7       	brne	.-32     	; 0xfa6
     fc6:	85 e4       	ldi	r24, 0x45	; 69
     fc8:	ef ce       	rjmp	.-546    	; 0xda8
     fca:	21 e0       	ldi	r18, 0x01	; 1
     fcc:	30 e0       	ldi	r19, 0x00	; 0
     fce:	80 91 c0 00 	lds	r24, 0x00C0
     fd2:	99 27       	eor	r25, r25
     fd4:	96 95       	lsr	r25
     fd6:	87 95       	ror	r24
     fd8:	92 95       	swap	r25
     fda:	82 95       	swap	r24
     fdc:	8f 70       	andi	r24, 0x0F	; 15
     fde:	89 27       	eor	r24, r25
     fe0:	9f 70       	andi	r25, 0x0F	; 15
     fe2:	89 27       	eor	r24, r25
     fe4:	81 70       	andi	r24, 0x01	; 1
     fe6:	90 70       	andi	r25, 0x00	; 0
     fe8:	82 17       	cp	r24, r18
     fea:	93 07       	cpc	r25, r19
     fec:	81 f7       	brne	.-32     	; 0xfce
     fee:	80 e3       	ldi	r24, 0x30	; 48
     ff0:	db ce       	rjmp	.-586    	; 0xda8

00000ff2 <UART_send_HEX8>:
	case(0):
		send_byte_serial('0');
		break;
	case(1):
		send_byte_serial('1');
		break;
	case(2):
		send_byte_serial('2');
		break;
	case(3):
		send_byte_serial('3');
		break;
	case(4):
		send_byte_serial('4');
		break;
	case(5):
		send_byte_serial('5');
		break;
	case(6):
		send_byte_serial('6');
		break;
	case(7):
		send_byte_serial('7');
		break;
	case(8):
		send_byte_serial('8');
		break;
	case(9):
		send_byte_serial('9');
		break;
	case(10):
		send_byte_serial('A');
		break;
	case(11):
		send_byte_serial('B');
		break;
	case(12):
		send_byte_serial('C');
		break;
	case(13):
		send_byte_serial('D');
		break;
	case(14):
		send_byte_serial('E');
		break;
	case(15):
		send_byte_serial('F');
		break;
	}	
}

void UART_send_HEX8(uint8_t lowb){
     ff2:	1f 93       	push	r17
     ff4:	18 2f       	mov	r17, r24
	UART_send_HEX4(lowb>>4);
     ff6:	82 95       	swap	r24
     ff8:	8f 70       	andi	r24, 0x0F	; 15
     ffa:	0e 94 72 06 	call	0xce4
	UART_send_HEX4(lowb & 0x0F);
     ffe:	81 2f       	mov	r24, r17
    1000:	8f 70       	andi	r24, 0x0F	; 15
    1002:	0e 94 72 06 	call	0xce4
    1006:	1f 91       	pop	r17
    1008:	08 95       	ret

0000100a <UART_send_HEX16b>:
}

void UART_send_HEX16b(uint8_t highb, uint8_t lowb){
    100a:	0f 93       	push	r16
    100c:	1f 93       	push	r17
    100e:	18 2f       	mov	r17, r24
    1010:	06 2f       	mov	r16, r22
    1012:	82 95       	swap	r24
    1014:	8f 70       	andi	r24, 0x0F	; 15
    1016:	0e 94 72 06 	call	0xce4
    101a:	81 2f       	mov	r24, r17
    101c:	8f 70       	andi	r24, 0x0F	; 15
    101e:	0e 94 72 06 	call	0xce4
    1022:	80 2f       	mov	r24, r16
    1024:	82 95       	swap	r24
    1026:	8f 70       	andi	r24, 0x0F	; 15
    1028:	0e 94 72 06 	call	0xce4
    102c:	80 2f       	mov	r24, r16
    102e:	8f 70       	andi	r24, 0x0F	; 15
    1030:	0e 94 72 06 	call	0xce4
    1034:	1f 91       	pop	r17
    1036:	0f 91       	pop	r16
    1038:	08 95       	ret

0000103a <UART_send_HEX16>:
	UART_send_HEX8(highb);
	UART_send_HEX8(lowb);
}

void UART_send_HEX16(uint16_t highb){
    103a:	ef 92       	push	r14
    103c:	ff 92       	push	r15
    103e:	1f 93       	push	r17
    1040:	7c 01       	movw	r14, r24
	uint8_t blah;
	blah = (uint8_t)(highb>>8);
    1042:	89 2f       	mov	r24, r25
    1044:	99 27       	eor	r25, r25
    1046:	f8 2e       	mov	r15, r24
    1048:	82 95       	swap	r24
    104a:	8f 70       	andi	r24, 0x0F	; 15
    104c:	0e 94 72 06 	call	0xce4
    1050:	8f 2d       	mov	r24, r15
    1052:	8f 70       	andi	r24, 0x0F	; 15
    1054:	0e 94 72 06 	call	0xce4
    1058:	8e 2d       	mov	r24, r14
    105a:	82 95       	swap	r24
    105c:	8f 70       	andi	r24, 0x0F	; 15
    105e:	0e 94 72 06 	call	0xce4
    1062:	8e 2d       	mov	r24, r14
    1064:	8f 70       	andi	r24, 0x0F	; 15
    1066:	0e 94 72 06 	call	0xce4
    106a:	1f 91       	pop	r17
    106c:	ff 90       	pop	r15
    106e:	ef 90       	pop	r14
    1070:	08 95       	ret

00001072 <init_i2c_buffer>:
volatile uint8_t i2c_head;
volatile uint8_t i2c_tail;

void init_i2c_buffer(void){
	i2c_head = 0;
    1072:	10 92 02 01 	sts	0x0102, r1
	i2c_tail = 0;
    1076:	10 92 01 01 	sts	0x0101, r1
    107a:	08 95       	ret

0000107c <i2c_count>:
}

inline uint8_t i2c_count(void){
	if (i2c_head >= i2c_tail){	
    107c:	90 91 02 01 	lds	r25, 0x0102
    1080:	80 91 01 01 	lds	r24, 0x0101
    1084:	98 17       	cp	r25, r24
    1086:	38 f0       	brcs	.+14     	; 0x1096
		return (i2c_head - i2c_tail);
    1088:	80 91 02 01 	lds	r24, 0x0102
    108c:	20 91 01 01 	lds	r18, 0x0101
    1090:	82 1b       	sub	r24, r18
    1092:	99 27       	eor	r25, r25
    1094:	08 95       	ret
	}
	else {
		return ((MAX_BUFFER_LEN-i2c_tail)+i2c_head);
    1096:	80 91 02 01 	lds	r24, 0x0102
    109a:	30 91 01 01 	lds	r19, 0x0101
    109e:	83 1b       	sub	r24, r19
    10a0:	86 50       	subi	r24, 0x06	; 6
    10a2:	99 27       	eor	r25, r25
	}
}
    10a4:	08 95       	ret
    10a6:	08 95       	ret

000010a8 <i2c_enqueue>:

inline void i2c_enqueue(uint8_t datain){
	i2c_buffer[i2c_head] = datain;
    10a8:	30 91 02 01 	lds	r19, 0x0102
    10ac:	e3 2f       	mov	r30, r19
    10ae:	ff 27       	eor	r31, r31
    10b0:	ed 5f       	subi	r30, 0xFD	; 253
    10b2:	fe 4f       	sbci	r31, 0xFE	; 254
    10b4:	80 83       	st	Z, r24
	i2c_head++;
    10b6:	20 91 02 01 	lds	r18, 0x0102
    10ba:	2f 5f       	subi	r18, 0xFF	; 255
    10bc:	20 93 02 01 	sts	0x0102, r18
	if (i2c_head >= MAX_BUFFER_LEN){
    10c0:	80 91 02 01 	lds	r24, 0x0102
    10c4:	8a 3f       	cpi	r24, 0xFA	; 250
    10c6:	10 f0       	brcs	.+4      	; 0x10cc
		i2c_head = 0;
    10c8:	10 92 02 01 	sts	0x0102, r1
    10cc:	08 95       	ret
    10ce:	08 95       	ret

000010d0 <i2c_dequeue>:
	}
}

inline uint8_t i2c_dequeue(void){
	uint8_t oldtail;
	oldtail = i2c_tail;
    10d0:	e0 91 01 01 	lds	r30, 0x0101
	i2c_tail++;
    10d4:	20 91 01 01 	lds	r18, 0x0101
    10d8:	2f 5f       	subi	r18, 0xFF	; 255
    10da:	20 93 01 01 	sts	0x0101, r18
	if (i2c_tail >= MAX_BUFFER_LEN){
    10de:	80 91 01 01 	lds	r24, 0x0101
    10e2:	8a 3f       	cpi	r24, 0xFA	; 250
    10e4:	10 f0       	brcs	.+4      	; 0x10ea
		i2c_tail = 0;
    10e6:	10 92 01 01 	sts	0x0101, r1
	}
	return i2c_buffer[oldtail];
    10ea:	ff 27       	eor	r31, r31
    10ec:	ed 5f       	subi	r30, 0xFD	; 253
    10ee:	fe 4f       	sbci	r31, 0xFE	; 254
    10f0:	80 81       	ld	r24, Z
}
    10f2:	99 27       	eor	r25, r25
    10f4:	08 95       	ret

000010f6 <init_I2C_slave>:
    10f6:	10 92 02 01 	sts	0x0102, r1
    10fa:	10 92 01 01 	sts	0x0101, r1

//FYI:
//	SOS default seems to be TWBR = 0x0A; TWSR1:0 = b00 (prescaler = 1) 
//	for clock = 205.3 kHz

void init_I2C_slave()
{
	init_i2c_buffer();
  	TWCR = B8(01000101); //control register
    10fe:	25 e4       	ldi	r18, 0x45	; 69
    1100:	20 93 bc 00 	sts	0x00BC, r18
  	TWAR = (DDSC_ADDRESS <<1) + 1; //address register (disable broadcast receive)
    1104:	81 e6       	ldi	r24, 0x61	; 97
    1106:	80 93 ba 00 	sts	0x00BA, r24
  	TWAMR = 0x00; //address mask register (use entire address space)
    110a:	10 92 bd 00 	sts	0x00BD, r1
    110e:	08 95       	ret

00001110 <__vector_24>:
}

//we respond to general call and specific address call the same way

SIGNAL(SIG_TWI){
    1110:	1f 92       	push	r1
    1112:	0f 92       	push	r0
    1114:	0f b6       	in	r0, 0x3f	; 63
    1116:	0f 92       	push	r0
    1118:	11 24       	eor	r1, r1
    111a:	2f 93       	push	r18
    111c:	3f 93       	push	r19
    111e:	4f 93       	push	r20
    1120:	5f 93       	push	r21
    1122:	6f 93       	push	r22
    1124:	7f 93       	push	r23
    1126:	8f 93       	push	r24
    1128:	9f 93       	push	r25
    112a:	af 93       	push	r26
    112c:	bf 93       	push	r27
    112e:	ef 93       	push	r30
    1130:	ff 93       	push	r31
  //if (TWSR != 0x60) while(1);
  if (TWSR == 0x60 || TWSR == 0x70){
    1132:	80 91 b9 00 	lds	r24, 0x00B9
    1136:	80 36       	cpi	r24, 0x60	; 96
    1138:	41 f1       	breq	.+80     	; 0x118a
    113a:	20 91 b9 00 	lds	r18, 0x00B9
    113e:	20 37       	cpi	r18, 0x70	; 112
    1140:	21 f1       	breq	.+72     	; 0x118a
    //general call or I'm specifically being addressed	
    //TWCR = B8(10000101); //receive and NACK (i.e. end of data payload after 1 byte rx)
    TWCR = B8(11000101); //always return ACK after data (accept infinite transfer length from master!)
    
  }
  else if (TWSR == 0x80 || TWSR == 0x90){
    1142:	30 91 b9 00 	lds	r19, 0x00B9
    1146:	30 38       	cpi	r19, 0x80	; 128
    1148:	61 f0       	breq	.+24     	; 0x1162
    114a:	40 91 b9 00 	lds	r20, 0x00B9
    114e:	40 39       	cpi	r20, 0x90	; 144
    1150:	41 f0       	breq	.+16     	; 0x1162
	  	//ACK was just returned
	  	//	receive byte
  		i2c_enqueue(TWDR);
  		TWCR = B8(11000101); //always return ACK after data (accept infinite transfer length from master!)
  }
  else if (TWSR == 0x88 || TWSR == 0x98){
    1152:	50 91 b9 00 	lds	r21, 0x00B9
    1156:	58 38       	cpi	r21, 0x88	; 136
    1158:	21 f0       	breq	.+8      	; 0x1162
    115a:	60 91 b9 00 	lds	r22, 0x00B9
    115e:	68 39       	cpi	r22, 0x98	; 152
    1160:	a1 f4       	brne	.+40     	; 0x118a
    1162:	a0 91 bb 00 	lds	r26, 0x00BB
    1166:	b0 91 02 01 	lds	r27, 0x0102
    116a:	eb 2f       	mov	r30, r27
    116c:	ff 27       	eor	r31, r31
    116e:	ed 5f       	subi	r30, 0xFD	; 253
    1170:	fe 4f       	sbci	r31, 0xFE	; 254
    1172:	a0 83       	st	Z, r26
    1174:	90 91 02 01 	lds	r25, 0x0102
    1178:	9f 5f       	subi	r25, 0xFF	; 255
    117a:	90 93 02 01 	sts	0x0102, r25
    117e:	70 91 02 01 	lds	r23, 0x0102
    1182:	7a 3f       	cpi	r23, 0xFA	; 250
    1184:	10 f0       	brcs	.+4      	; 0x118a
    1186:	10 92 02 01 	sts	0x0102, r1
	//NACK was just returned
    //receive byte
    i2c_enqueue(TWDR);
    //switch to the no-longer addressed slave mode (waiting on new bus transfer to address me)
    TWCR = B8(11000101);
  }
  else {
    //if error or unrecognized bus condition, abort current transfer and await next packet
    //switch to the no-longer addressed slave mode (waiting on new bus transfer to address me)
    TWCR = B8(11000101);
    118a:	f5 ec       	ldi	r31, 0xC5	; 197
    118c:	f0 93 bc 00 	sts	0x00BC, r31
    1190:	ff 91       	pop	r31
    1192:	ef 91       	pop	r30
    1194:	bf 91       	pop	r27
    1196:	af 91       	pop	r26
    1198:	9f 91       	pop	r25
    119a:	8f 91       	pop	r24
    119c:	7f 91       	pop	r23
    119e:	6f 91       	pop	r22
    11a0:	5f 91       	pop	r21
    11a2:	4f 91       	pop	r20
    11a4:	3f 91       	pop	r19
    11a6:	2f 91       	pop	r18
    11a8:	0f 90       	pop	r0
    11aa:	0f be       	out	0x3f, r0	; 63
    11ac:	0f 90       	pop	r0
    11ae:	1f 90       	pop	r1
    11b0:	18 95       	reti

000011b2 <init_tp>:
//- INIT ROUTINES
//----------------------------------------------------------------

inline void init_tp(){
	sbi(DDRB, 1);
    11b2:	21 9a       	sbi	0x04, 1	; 4
	sbi(DDRD, 5);
    11b4:	55 9a       	sbi	0x0a, 5	; 10
	sbi(DDRD, 6);	
    11b6:	56 9a       	sbi	0x0a, 6	; 10
    11b8:	08 95       	ret

000011ba <tpl>:
}

//----------------------------------------------------------------
//- COMMAND ROUTINES
//----------------------------------------------------------------

//Test Point LED (D_DDSC)
inline void tpl(uint8_t cmd){
	switch(cmd){
    11ba:	99 27       	eor	r25, r25
    11bc:	82 30       	cpi	r24, 0x02	; 2
    11be:	91 05       	cpc	r25, r1
    11c0:	69 f0       	breq	.+26     	; 0x11dc
    11c2:	83 30       	cpi	r24, 0x03	; 3
    11c4:	91 05       	cpc	r25, r1
    11c6:	1c f4       	brge	.+6      	; 0x11ce
    11c8:	01 97       	sbiw	r24, 0x01	; 1
    11ca:	51 f0       	breq	.+20     	; 0x11e0
    11cc:	08 95       	ret
    11ce:	03 97       	sbiw	r24, 0x03	; 3
    11d0:	e9 f7       	brne	.-6      	; 0x11cc
		case ON:
			sbi(PORTB, 6);
			break;
		case OFF:
			cbi(PORTB, 6);
			break;
		case TOGGLE:
			tbi(PORTB, 6);
    11d2:	85 b1       	in	r24, 0x05	; 5
    11d4:	90 e4       	ldi	r25, 0x40	; 64
    11d6:	89 27       	eor	r24, r25
    11d8:	85 b9       	out	0x05, r24	; 5
    11da:	08 95       	ret
    11dc:	2e 98       	cbi	0x05, 6	; 5
    11de:	08 95       	ret
    11e0:	2e 9a       	sbi	0x05, 6	; 5
    11e2:	08 95       	ret
    11e4:	08 95       	ret

000011e6 <tp7>:
			break;
		default:
			break;
	}
}

//Test Point 7
inline void tp7(uint8_t cmd){
	switch(cmd){
    11e6:	99 27       	eor	r25, r25
    11e8:	82 30       	cpi	r24, 0x02	; 2
    11ea:	91 05       	cpc	r25, r1
    11ec:	69 f0       	breq	.+26     	; 0x1208
    11ee:	83 30       	cpi	r24, 0x03	; 3
    11f0:	91 05       	cpc	r25, r1
    11f2:	1c f4       	brge	.+6      	; 0x11fa
    11f4:	01 97       	sbiw	r24, 0x01	; 1
    11f6:	51 f0       	breq	.+20     	; 0x120c
    11f8:	08 95       	ret
    11fa:	03 97       	sbiw	r24, 0x03	; 3
    11fc:	e9 f7       	brne	.-6      	; 0x11f8
		case ON:
			sbi(PORTD, 0);
			break;
		case OFF:
			cbi(PORTD, 0);
			break;
		case TOGGLE:
			tbi(PORTD, 0);
    11fe:	8b b1       	in	r24, 0x0b	; 11
    1200:	91 e0       	ldi	r25, 0x01	; 1
    1202:	89 27       	eor	r24, r25
    1204:	8b b9       	out	0x0b, r24	; 11
    1206:	08 95       	ret
    1208:	58 98       	cbi	0x0b, 0	; 11
    120a:	08 95       	ret
    120c:	58 9a       	sbi	0x0b, 0	; 11
    120e:	08 95       	ret
    1210:	08 95       	ret

00001212 <tp8>:
			break;
		default:
			break;
	}
}

//Test Point 8
inline void tp8(uint8_t cmd){
	switch(cmd){
    1212:	99 27       	eor	r25, r25
    1214:	82 30       	cpi	r24, 0x02	; 2
    1216:	91 05       	cpc	r25, r1
    1218:	69 f0       	breq	.+26     	; 0x1234
    121a:	83 30       	cpi	r24, 0x03	; 3
    121c:	91 05       	cpc	r25, r1
    121e:	1c f4       	brge	.+6      	; 0x1226
    1220:	01 97       	sbiw	r24, 0x01	; 1
    1222:	51 f0       	breq	.+20     	; 0x1238
    1224:	08 95       	ret
    1226:	03 97       	sbiw	r24, 0x03	; 3
    1228:	e9 f7       	brne	.-6      	; 0x1224
		case ON:
			sbi(PORTD, 1);
			break;
		case OFF:
			cbi(PORTD, 1);
			break;
		case TOGGLE:
			tbi(PORTD, 1);
    122a:	8b b1       	in	r24, 0x0b	; 11
    122c:	92 e0       	ldi	r25, 0x02	; 2
    122e:	89 27       	eor	r24, r25
    1230:	8b b9       	out	0x0b, r24	; 11
    1232:	08 95       	ret
    1234:	59 98       	cbi	0x0b, 1	; 11
    1236:	08 95       	ret
    1238:	59 9a       	sbi	0x0b, 1	; 11
    123a:	08 95       	ret
    123c:	08 95       	ret
