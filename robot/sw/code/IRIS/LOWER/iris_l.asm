
iris_l.elf:     file format elf32-avr

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .data         00000002  00800100  00001e38  00001ecc  2**0
                  CONTENTS, ALLOC, LOAD, DATA
  1 .text         00001e38  00000000  00000000  00000094  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  2 .bss          0000012a  00800102  00800102  00001ece  2**0
                  ALLOC
  3 .noinit       00000000  0080022c  0080022c  00001ece  2**0
                  CONTENTS
  4 .eeprom       00000000  00810000  00810000  00001ece  2**0
                  CONTENTS
  5 .debug_aranges 00000064  00000000  00000000  00001ece  2**0
                  CONTENTS, READONLY, DEBUGGING
  6 .debug_pubnames 000003f1  00000000  00000000  00001f32  2**0
                  CONTENTS, READONLY, DEBUGGING
  7 .debug_info   0000196f  00000000  00000000  00002323  2**0
                  CONTENTS, READONLY, DEBUGGING
  8 .debug_abbrev 000005f3  00000000  00000000  00003c92  2**0
                  CONTENTS, READONLY, DEBUGGING
  9 .debug_line   00001371  00000000  00000000  00004285  2**0
                  CONTENTS, READONLY, DEBUGGING
 10 .debug_str    000003f8  00000000  00000000  000055f6  2**0
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
      1c:	0c 94 4e 02 	jmp	0x49c
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
      48:	0c 94 e1 0e 	jmp	0x1dc2
      4c:	0c 94 4f 00 	jmp	0x9e
      50:	0c 94 4f 00 	jmp	0x9e
      54:	0c 94 4f 00 	jmp	0x9e
      58:	0c 94 4f 00 	jmp	0x9e
      5c:	0c 94 4f 00 	jmp	0x9e
      60:	0c 94 ee 05 	jmp	0xbdc
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
      7a:	e8 e3       	ldi	r30, 0x38	; 56
      7c:	fe e1       	ldi	r31, 0x1E	; 30
      7e:	02 c0       	rjmp	.+4      	; 0x84

00000080 <.do_copy_data_loop>:
      80:	05 90       	lpm	r0, Z+
      82:	0d 92       	st	X+, r0

00000084 <.do_copy_data_start>:
      84:	a2 30       	cpi	r26, 0x02	; 2
      86:	b1 07       	cpc	r27, r17
      88:	d9 f7       	brne	.-10     	; 0x80

0000008a <__do_clear_bss>:
      8a:	12 e0       	ldi	r17, 0x02	; 2
      8c:	a2 e0       	ldi	r26, 0x02	; 2
      8e:	b1 e0       	ldi	r27, 0x01	; 1
      90:	01 c0       	rjmp	.+2      	; 0x94

00000092 <.do_clear_bss_loop>:
      92:	1d 92       	st	X+, r1

00000094 <.do_clear_bss_start>:
      94:	ac 32       	cpi	r26, 0x2C	; 44
      96:	b1 07       	cpc	r27, r17
      98:	e1 f7       	brne	.-8      	; 0x92
      9a:	0c 94 68 00 	jmp	0xd0

0000009e <__bad_interrupt>:
      9e:	0c 94 00 00 	jmp	0x0

000000a2 <init_mcu>:
//----------------------------------------------------------------

inline void init_mcu(void) {
	// Input/Output Ports initialization
		cbi(PORTD, 2); //output 0 on IRIS_CNTRL to signal to IRISU that we are not ready	
      a2:	5a 98       	cbi	0x0b, 2	; 11
  		DDRD = B8(10101110); //UART, IRIS TX DATA, ALERT, CB2, IRIS VCC
      a4:	3e ea       	ldi	r19, 0xAE	; 174
      a6:	3a b9       	out	0x0a, r19	; 10
		
  		DDRC = B8(00001101); //Transmitter Power Level Control, I2C, Reset, TP6
      a8:	2d e0       	ldi	r18, 0x0D	; 13
      aa:	27 b9       	out	0x07, r18	; 7
  							//BUGFIX: PC1 is configured as an input to protect it because it is incorrectly shorted to PC2; all control in this code is done from PC2.  		
  		DDRB = B8(11101011); //debug LED, BLED, Clock-out, PGM I/F, XO
      ac:	8b ee       	ldi	r24, 0xEB	; 235
      ae:	84 b9       	out	0x04, r24	; 4
      b0:	08 95       	ret

000000b2 <stall>:
} //init_MCU


void stall(uint16_t limit){
  uint16_t blah, i, j;
  blah=0;
      b2:	40 e0       	ldi	r20, 0x00	; 0
      b4:	50 e0       	ldi	r21, 0x00	; 0
  for(i=0;i<0xFFFF;i++){
    for(j=0;j<limit;j++){
      b6:	00 97       	sbiw	r24, 0x00	; 0
      b8:	21 f0       	breq	.+8      	; 0xc2
      ba:	9c 01       	movw	r18, r24
      bc:	21 50       	subi	r18, 0x01	; 1
      be:	30 40       	sbci	r19, 0x00	; 0
      c0:	e9 f7       	brne	.-6      	; 0xbc
      c2:	4f 5f       	subi	r20, 0xFF	; 255
      c4:	5f 4f       	sbci	r21, 0xFF	; 255
      c6:	2f ef       	ldi	r18, 0xFF	; 255
      c8:	4f 3f       	cpi	r20, 0xFF	; 255
      ca:	52 07       	cpc	r21, r18
      cc:	a1 f7       	brne	.-24     	; 0xb6
      ce:	08 95       	ret

000000d0 <main>:
      blah++;
    }
  }	
}




//----------------------------------------------------------------
//- MAIN PROGRAM
//----------------------------------------------------------------

int main(void){
      d0:	cf ef       	ldi	r28, 0xFF	; 255
      d2:	d4 e0       	ldi	r29, 0x04	; 4
      d4:	de bf       	out	0x3e, r29	; 62
      d6:	cd bf       	out	0x3d, r28	; 61
	//VAR
		
	//INIT
		cli(); //disable interrupts (in case function is called multiple times)
      d8:	f8 94       	cli
      da:	5a 98       	cbi	0x0b, 2	; 11
      dc:	2e ea       	ldi	r18, 0xAE	; 174
      de:	2a b9       	out	0x0a, r18	; 10
      e0:	1d e0       	ldi	r17, 0x0D	; 13
      e2:	17 b9       	out	0x07, r17	; 7
      e4:	8b ee       	ldi	r24, 0xEB	; 235
      e6:	84 b9       	out	0x04, r24	; 4
		init_mcu();
		init_I2C();
      e8:	0e 94 4a 05 	call	0xa94
		init_serial(USRT);
      ec:	81 2f       	mov	r24, r17
      ee:	0e 94 31 07 	call	0xe62
		init_tp();
      f2:	0e 94 ca 00 	call	0x194
		init_iris();
      f6:	0e 94 1a 01 	call	0x234
		init_irtx(); //turn on tx encoder
      fa:	0e 94 41 01 	call	0x282
		iris_tx(HIGH); //turn on tx output
      fe:	82 e0       	ldi	r24, 0x02	; 2
     100:	0e 94 01 01 	call	0x202
		iris_rx(ON); //turn on receivers
     104:	81 e0       	ldi	r24, 0x01	; 1
     106:	0e 94 f5 00 	call	0x1ea
		tpl(OFF); //LED to OFF state
     10a:	83 e0       	ldi	r24, 0x03	; 3
     10c:	0e 94 9e 00 	call	0x13c
		tp6(LOW); //TP to LOW state
     110:	84 e0       	ldi	r24, 0x04	; 4
     112:	0e 94 b4 00 	call	0x168
		sei(); //enable interrupts (go live)
     116:	78 94       	sei
		sbi(PORTD, 2); //signal IRISU that we are ready to go!
     118:	5a 9a       	sbi	0x0b, 2	; 11

	//PGM	
	  	while(1)
		{
		  	tp6(TOGGLE);
     11a:	85 e0       	ldi	r24, 0x05	; 5
     11c:	0e 94 b4 00 	call	0x168
		  	if (i2c_count() > 0) {
     120:	0e 94 63 05 	call	0xac6
     124:	88 23       	and	r24, r24
     126:	c9 f3       	breq	.-14     	; 0x11a
			  	I2C_send();
     128:	0e 94 dd 05 	call	0xbba
     12c:	85 e0       	ldi	r24, 0x05	; 5
     12e:	0e 94 b4 00 	call	0x168
     132:	0e 94 63 05 	call	0xac6
     136:	88 23       	and	r24, r24
     138:	81 f3       	breq	.-32     	; 0x11a
     13a:	f6 cf       	rjmp	.-20     	; 0x128

0000013c <tpl>:
//----------------------------------------------------------------

//Test Point LED (D_IRISL)
inline void tpl(uint8_t cmd){
	switch(cmd){
     13c:	99 27       	eor	r25, r25
     13e:	83 30       	cpi	r24, 0x03	; 3
     140:	91 05       	cpc	r25, r1
     142:	69 f0       	breq	.+26     	; 0x15e
     144:	84 30       	cpi	r24, 0x04	; 4
     146:	91 05       	cpc	r25, r1
     148:	1c f4       	brge	.+6      	; 0x150
     14a:	01 97       	sbiw	r24, 0x01	; 1
     14c:	51 f0       	breq	.+20     	; 0x162
     14e:	08 95       	ret
     150:	05 97       	sbiw	r24, 0x05	; 5
     152:	e9 f7       	brne	.-6      	; 0x14e
		case ON:
			sbi(PORTB, 1);
			break;
		case OFF:
			cbi(PORTB, 1);
			break;
		case TOGGLE:
			tbi(PORTB, 1);
     154:	85 b1       	in	r24, 0x05	; 5
     156:	92 e0       	ldi	r25, 0x02	; 2
     158:	89 27       	eor	r24, r25
     15a:	85 b9       	out	0x05, r24	; 5
     15c:	08 95       	ret
     15e:	29 98       	cbi	0x05, 1	; 5
     160:	08 95       	ret
     162:	29 9a       	sbi	0x05, 1	; 5
     164:	08 95       	ret
     166:	08 95       	ret

00000168 <tp6>:
			break;
		default:
			break;
	}
}

//Test Point 6
inline void tp6(uint8_t cmd){
	switch(cmd){
     168:	99 27       	eor	r25, r25
     16a:	84 30       	cpi	r24, 0x04	; 4
     16c:	91 05       	cpc	r25, r1
     16e:	69 f0       	breq	.+26     	; 0x18a
     170:	85 30       	cpi	r24, 0x05	; 5
     172:	91 05       	cpc	r25, r1
     174:	1c f4       	brge	.+6      	; 0x17c
     176:	02 97       	sbiw	r24, 0x02	; 2
     178:	51 f0       	breq	.+20     	; 0x18e
     17a:	08 95       	ret
     17c:	05 97       	sbiw	r24, 0x05	; 5
     17e:	e9 f7       	brne	.-6      	; 0x17a
		case HIGH:
			sbi(PORTC, 3);
			break;
		case LOW:
			cbi(PORTC, 3);
			break;
		case TOGGLE:
			tbi(PORTC, 3);
     180:	88 b1       	in	r24, 0x08	; 8
     182:	98 e0       	ldi	r25, 0x08	; 8
     184:	89 27       	eor	r24, r25
     186:	88 b9       	out	0x08, r24	; 8
     188:	08 95       	ret
     18a:	43 98       	cbi	0x08, 3	; 8
     18c:	08 95       	ret
     18e:	43 9a       	sbi	0x08, 3	; 8
     190:	08 95       	ret
     192:	08 95       	ret

00000194 <init_tp>:
			break;
		default:
			break;
	}
}

//----------------------------------------------------------------
//- INIT ROUTINES
//----------------------------------------------------------------

inline void init_tp(){
	sbi(DDRB, 1); //LED
     194:	21 9a       	sbi	0x04, 1	; 4
	sbi(DDRC, 3); //TP6
     196:	3b 9a       	sbi	0x07, 3	; 7
     198:	29 98       	cbi	0x05, 1	; 5
     19a:	43 98       	cbi	0x08, 3	; 8
     19c:	08 95       	ret

0000019e <init_array>:
//----------------------------------------------------------------

void init_array(uint8_t* toinit, uint8_t size, uint8_t init_val){
	uint8_t i;
	for (i=0;i<size;i++){
     19e:	66 23       	and	r22, r22
     1a0:	21 f0       	breq	.+8      	; 0x1aa
     1a2:	fc 01       	movw	r30, r24
		toinit[i] = init_val;
     1a4:	41 93       	st	Z+, r20
     1a6:	61 50       	subi	r22, 0x01	; 1
     1a8:	e9 f7       	brne	.-6      	; 0x1a4
     1aa:	08 95       	ret

000001ac <init_iris_sm>:
	}
}

//reset the state machine logic that drives the byte assembly process
inline void init_iris_sm(void){
     1ac:	e3 e0       	ldi	r30, 0x03	; 3
     1ae:	f1 e0       	ldi	r31, 0x01	; 1
     1b0:	86 e0       	ldi	r24, 0x06	; 6
     1b2:	11 92       	st	Z+, r1
     1b4:	81 50       	subi	r24, 0x01	; 1
     1b6:	87 ff       	sbrs	r24, 7
     1b8:	fc cf       	rjmp	.-8      	; 0x1b2
     1ba:	ea e0       	ldi	r30, 0x0A	; 10
     1bc:	f1 e0       	ldi	r31, 0x01	; 1
     1be:	86 e0       	ldi	r24, 0x06	; 6
     1c0:	11 92       	st	Z+, r1
     1c2:	81 50       	subi	r24, 0x01	; 1
     1c4:	87 ff       	sbrs	r24, 7
     1c6:	fc cf       	rjmp	.-8      	; 0x1c0
     1c8:	e8 e1       	ldi	r30, 0x18	; 24
     1ca:	f1 e0       	ldi	r31, 0x01	; 1
     1cc:	86 e0       	ldi	r24, 0x06	; 6
     1ce:	11 92       	st	Z+, r1
     1d0:	81 50       	subi	r24, 0x01	; 1
     1d2:	87 ff       	sbrs	r24, 7
     1d4:	fc cf       	rjmp	.-8      	; 0x1ce
     1d6:	e1 e1       	ldi	r30, 0x11	; 17
     1d8:	f1 e0       	ldi	r31, 0x01	; 1
     1da:	86 e0       	ldi	r24, 0x06	; 6
     1dc:	11 92       	st	Z+, r1
     1de:	81 50       	subi	r24, 0x01	; 1
     1e0:	87 ff       	sbrs	r24, 7
     1e2:	fc cf       	rjmp	.-8      	; 0x1dc
	init_array(p_symbol, NUM__OF_CHANNELS, SYM_INVD_Q);
	init_array(p_state, NUM__OF_CHANNELS, S0);
	init_array(p_data, NUM__OF_CHANNELS, 0);
	init_array(p_count, NUM__OF_CHANNELS, 0);
	out_direction = 0x00;
     1e4:	10 92 1f 01 	sts	0x011F, r1
     1e8:	08 95       	ret

000001ea <iris_rx>:
}

//physical pin setup take care of in init_mcu();
inline void init_iris(){
	iris_rx(OFF);
	iris_tx(OFF);
	iris_weapon(OFF);	
	init_iris_sm();
}

//This init routine actually begins operation (as soon as interrupts get enabled)
//LED_ENCODE is OC2B
void init_irtx(){
	//TIMER 2: 40kHz 50% Square Wave Generator
		cbi(PORTD, 3); //so that disabled OCR2B = 0 on output
  		cbi(ASSR, 5); //clock from MCU mainline clock (16MHz)
  		enable_output_irclock();
  		TCCR2B = B8(00000001); //enable timer with no prescaler = 16MHz
  		OCR2A = 200; //toggle after 12.5mS -> 25mS period = 40kHz freq (16MHz clock)
  		TIMSK2 = B8(00000010); //OC2A match interrupt enabled
  		TIFR2; //Timer interrupt flag register
  		sbi(DDRD, 3); //OCR2B as output  		
}		

//----------------------------------------------------------------
//- IR TRANSMISSION POWER ROUTING
//----------------------------------------------------------------

//enable/disable power to the IR receivers
//usage: iris_rx(ON) / iris_rx(OFF)
extern void iris_rx(uint8_t cmd){
	switch(cmd){
     1ea:	99 27       	eor	r25, r25
     1ec:	81 30       	cpi	r24, 0x01	; 1
     1ee:	91 05       	cpc	r25, r1
     1f0:	29 f0       	breq	.+10     	; 0x1fc
     1f2:	03 97       	sbiw	r24, 0x03	; 3
     1f4:	09 f0       	breq	.+2      	; 0x1f8
     1f6:	08 95       	ret
	case ON:
		sbi(PORTD, 7);
		break;
	case OFF:
		cbi(PORTD, 7);
     1f8:	5f 98       	cbi	0x0b, 7	; 11
     1fa:	08 95       	ret
     1fc:	5f 9a       	sbi	0x0b, 7	; 11
     1fe:	08 95       	ret
     200:	08 95       	ret

00000202 <iris_tx>:
		break;
	default:
		break;	
	}	
}

//Due to a bug the two control lines are shorted together. This precludes any power setting except HIGH from functioning.
extern void iris_tx(uint8_t cmd){
	switch(cmd){
     202:	99 27       	eor	r25, r25
     204:	84 30       	cpi	r24, 0x04	; 4
     206:	91 05       	cpc	r25, r1
     208:	39 f0       	breq	.+14     	; 0x218
     20a:	85 30       	cpi	r24, 0x05	; 5
     20c:	91 05       	cpc	r25, r1
     20e:	2c f4       	brge	.+10     	; 0x21a
     210:	02 97       	sbiw	r24, 0x02	; 2
     212:	31 f0       	breq	.+12     	; 0x220
	case LOW:
		//for future use		
		break;
	case MED:
		//for future use
		break;
	case HIGH:
		sbi(PORTC, 2);
		break;
	case OFF:
		//fall through to default
	default:
		//OFF
		cbi(PORTC, 2);
     214:	42 98       	cbi	0x08, 2	; 8
		cbi(PORTC, 1);	
     216:	41 98       	cbi	0x08, 1	; 8
     218:	08 95       	ret
     21a:	06 97       	sbiw	r24, 0x06	; 6
     21c:	d9 f7       	brne	.-10     	; 0x214
     21e:	08 95       	ret
     220:	42 9a       	sbi	0x08, 2	; 8
     222:	08 95       	ret
     224:	08 95       	ret

00000226 <iris_weapon>:
	} //switch
}

extern void iris_weapon(uint8_t cmd){
	switch(cmd){
     226:	87 30       	cpi	r24, 0x07	; 7
     228:	11 f0       	breq	.+4      	; 0x22e
	case FIRE:
		sbi(PORTC, 0);
		break;
	case OFF:
		//fall through to default
	default:
		//OFF
		cbi(PORTC, 0);
     22a:	40 98       	cbi	0x08, 0	; 8
     22c:	08 95       	ret
     22e:	40 9a       	sbi	0x08, 0	; 8
     230:	08 95       	ret
     232:	08 95       	ret

00000234 <init_iris>:
     234:	5f 98       	cbi	0x0b, 7	; 11
     236:	42 98       	cbi	0x08, 2	; 8
     238:	41 98       	cbi	0x08, 1	; 8
     23a:	40 98       	cbi	0x08, 0	; 8
     23c:	e3 e0       	ldi	r30, 0x03	; 3
     23e:	f1 e0       	ldi	r31, 0x01	; 1
     240:	86 e0       	ldi	r24, 0x06	; 6
     242:	11 92       	st	Z+, r1
     244:	81 50       	subi	r24, 0x01	; 1
     246:	87 ff       	sbrs	r24, 7
     248:	fc cf       	rjmp	.-8      	; 0x242
     24a:	ea e0       	ldi	r30, 0x0A	; 10
     24c:	f1 e0       	ldi	r31, 0x01	; 1
     24e:	86 e0       	ldi	r24, 0x06	; 6
     250:	11 92       	st	Z+, r1
     252:	81 50       	subi	r24, 0x01	; 1
     254:	87 ff       	sbrs	r24, 7
     256:	fc cf       	rjmp	.-8      	; 0x250
     258:	e8 e1       	ldi	r30, 0x18	; 24
     25a:	f1 e0       	ldi	r31, 0x01	; 1
     25c:	86 e0       	ldi	r24, 0x06	; 6
     25e:	11 92       	st	Z+, r1
     260:	81 50       	subi	r24, 0x01	; 1
     262:	87 ff       	sbrs	r24, 7
     264:	fc cf       	rjmp	.-8      	; 0x25e
     266:	e1 e1       	ldi	r30, 0x11	; 17
     268:	f1 e0       	ldi	r31, 0x01	; 1
     26a:	86 e0       	ldi	r24, 0x06	; 6
     26c:	11 92       	st	Z+, r1
     26e:	81 50       	subi	r24, 0x01	; 1
     270:	87 ff       	sbrs	r24, 7
     272:	fc cf       	rjmp	.-8      	; 0x26c
     274:	10 92 1f 01 	sts	0x011F, r1
     278:	08 95       	ret

0000027a <enable_output_irclock>:
	} //switch
}


//----------------------------------------------------------------
//- IR TRANSMISSION CLOCKS
//----------------------------------------------------------------

inline void reset_irclock(){
	
}

//NEW: jonathan
inline void start_irclock(){
	//8MHz:: OCR0A = 120; //1/8e6MHz * 8 (prescale) * OCR0A = period in seconds (for these values 8/8=1, so OCR0A = period in uS)
	//OCR0A = 180; //for 16MHz clock; 180= 90uS period
	OCR0A = 140; //for 16MHz clock; 100 = 50uS period; 140 = 70uS period
	OCR0B = 0x00; //min out the compare registers so that the interrupt flag register is easier for GCC to read (bits will always be 1 so TIFR0 = B4(0110) if no overflow)
	TCNT0 = 0xFF; //start with overflow flag set to make GCC processing of byte easier
	TCCR0A = B8(00000010); //CTC MODE, NO I/O BEHAVIORS
	TCCR0B = B8(00000010); //8MHZ CLOCK / 8 = 256uS PER PERIOD
}

//NEW: jonathan
inline void stop_irclock(){
	TCCR0B = B8(00000000); //NO CLOCK SOURCE = STOPPED
}

inline void disable_output_irclock(){
  TCCR2A = B8(00100010); //OC2A=off,OC2B=clear on compare,Mode = CTC
}

inline void enable_output_irclock(){
  TCCR2A = B8(00010010); //OC2A=off,OC2B=toggle on compare,Mode = CTC
     27a:	82 e1       	ldi	r24, 0x12	; 18
     27c:	80 93 b0 00 	sts	0x00B0, r24
     280:	08 95       	ret

00000282 <init_irtx>:
     282:	5b 98       	cbi	0x0b, 3	; 11
     284:	50 91 b6 00 	lds	r21, 0x00B6
     288:	5f 7d       	andi	r21, 0xDF	; 223
     28a:	50 93 b6 00 	sts	0x00B6, r21
     28e:	42 e1       	ldi	r20, 0x12	; 18
     290:	40 93 b0 00 	sts	0x00B0, r20
     294:	31 e0       	ldi	r19, 0x01	; 1
     296:	30 93 b1 00 	sts	0x00B1, r19
     29a:	28 ec       	ldi	r18, 0xC8	; 200
     29c:	20 93 b3 00 	sts	0x00B3, r18
     2a0:	82 e0       	ldi	r24, 0x02	; 2
     2a2:	80 93 70 00 	sts	0x0070, r24
     2a6:	87 b3       	in	r24, 0x17	; 23
     2a8:	53 9a       	sbi	0x0a, 3	; 10
     2aa:	08 95       	ret

000002ac <reset_irclock>:
     2ac:	08 95       	ret

000002ae <start_irclock>:
     2ae:	3c e8       	ldi	r19, 0x8C	; 140
     2b0:	37 bd       	out	0x27, r19	; 39
     2b2:	18 bc       	out	0x28, r1	; 40
     2b4:	2f ef       	ldi	r18, 0xFF	; 255
     2b6:	26 bd       	out	0x26, r18	; 38
     2b8:	82 e0       	ldi	r24, 0x02	; 2
     2ba:	84 bd       	out	0x24, r24	; 36
     2bc:	85 bd       	out	0x25, r24	; 37
     2be:	08 95       	ret

000002c0 <stop_irclock>:
     2c0:	15 bc       	out	0x25, r1	; 37
     2c2:	08 95       	ret

000002c4 <disable_output_irclock>:
     2c4:	82 e2       	ldi	r24, 0x22	; 34
     2c6:	80 93 b0 00 	sts	0x00B0, r24
     2ca:	08 95       	ret

000002cc <iris_unpack>:
}



//----------------------------------------------------------------
//- IRIS BYTE ASSEMBLY
//----------------------------------------------------------------

//unpack the byte into a single channel
//position range is 0-3
inline uint8_t iris_unpack(uint8_t position, uint8_t datain){
	datain = datain >> position;
     2cc:	26 2f       	mov	r18, r22
     2ce:	33 27       	eor	r19, r19
     2d0:	02 c0       	rjmp	.+4      	; 0x2d6
     2d2:	35 95       	asr	r19
     2d4:	27 95       	ror	r18
     2d6:	8a 95       	dec	r24
     2d8:	e2 f7       	brpl	.-8      	; 0x2d2
     2da:	82 2f       	mov	r24, r18
	datain = datain & B8(00000011);
     2dc:	83 70       	andi	r24, 0x03	; 3
	return datain;
}
     2de:	99 27       	eor	r25, r25
     2e0:	08 95       	ret

000002e2 <iris_xfr_receive>:

//unpack; xfr0 was received first
inline void iris_xfr_receive(uint8_t sym_xfr0, uint8_t sym_xfr1){
     2e2:	e6 2f       	mov	r30, r22
     2e4:	28 2f       	mov	r18, r24
     2e6:	33 27       	eor	r19, r19
     2e8:	62 e0       	ldi	r22, 0x02	; 2
     2ea:	70 e0       	ldi	r23, 0x00	; 0
     2ec:	c9 01       	movw	r24, r18
     2ee:	06 2e       	mov	r0, r22
     2f0:	02 c0       	rjmp	.+4      	; 0x2f6
     2f2:	95 95       	asr	r25
     2f4:	87 95       	ror	r24
     2f6:	0a 94       	dec	r0
     2f8:	e2 f7       	brpl	.-8      	; 0x2f2
     2fa:	83 70       	andi	r24, 0x03	; 3
     2fc:	80 93 09 01 	sts	0x0109, r24
     300:	41 e0       	ldi	r20, 0x01	; 1
     302:	50 e0       	ldi	r21, 0x00	; 0
     304:	c9 01       	movw	r24, r18
     306:	04 2e       	mov	r0, r20
     308:	02 c0       	rjmp	.+4      	; 0x30e
     30a:	95 95       	asr	r25
     30c:	87 95       	ror	r24
     30e:	0a 94       	dec	r0
     310:	e2 f7       	brpl	.-8      	; 0x30a
     312:	83 70       	andi	r24, 0x03	; 3
     314:	80 93 08 01 	sts	0x0108, r24
     318:	32 2f       	mov	r19, r18
     31a:	33 70       	andi	r19, 0x03	; 3
     31c:	30 93 07 01 	sts	0x0107, r19
     320:	2e 2f       	mov	r18, r30
     322:	33 27       	eor	r19, r19
     324:	c9 01       	movw	r24, r18
     326:	96 95       	lsr	r25
     328:	87 95       	ror	r24
     32a:	96 95       	lsr	r25
     32c:	87 95       	ror	r24
     32e:	96 95       	lsr	r25
     330:	87 95       	ror	r24
     332:	83 70       	andi	r24, 0x03	; 3
     334:	80 93 06 01 	sts	0x0106, r24
     338:	c9 01       	movw	r24, r18
     33a:	02 c0       	rjmp	.+4      	; 0x340
     33c:	95 95       	asr	r25
     33e:	87 95       	ror	r24
     340:	6a 95       	dec	r22
     342:	e2 f7       	brpl	.-8      	; 0x33c
     344:	83 70       	andi	r24, 0x03	; 3
     346:	80 93 05 01 	sts	0x0105, r24
     34a:	c9 01       	movw	r24, r18
     34c:	02 c0       	rjmp	.+4      	; 0x352
     34e:	95 95       	asr	r25
     350:	87 95       	ror	r24
     352:	4a 95       	dec	r20
     354:	e2 f7       	brpl	.-8      	; 0x34e
     356:	83 70       	andi	r24, 0x03	; 3
     358:	80 93 04 01 	sts	0x0104, r24
     35c:	82 2f       	mov	r24, r18
     35e:	83 70       	andi	r24, 0x03	; 3
     360:	80 93 03 01 	sts	0x0103, r24
     364:	08 95       	ret

00000366 <S1>:
	p_symbol[6] = iris_unpack(2, sym_xfr0);
	p_symbol[5] = iris_unpack(1, sym_xfr0);
	p_symbol[4] = iris_unpack(0, sym_xfr0);
	p_symbol[3] = iris_unpack(3, sym_xfr1);
	p_symbol[2] = iris_unpack(2, sym_xfr1);
	p_symbol[1] = iris_unpack(1, sym_xfr1);
	p_symbol[0] = iris_unpack(0, sym_xfr1);
}

//the missing virtual state 1 from the diagram
inline void S1(uint8_t channel_num){
	//This code in here is the function of State S1 from the 
			//	diagram in my thesis (not a real state, but made 
			//	diagram easier to read)
			p_state[channel_num] = S2;
     366:	a8 2f       	mov	r26, r24
     368:	bb 27       	eor	r27, r27
     36a:	fd 01       	movw	r30, r26
     36c:	e6 5f       	subi	r30, 0xF6	; 246
     36e:	fe 4f       	sbci	r31, 0xFE	; 254
     370:	82 e0       	ldi	r24, 0x02	; 2
     372:	80 83       	st	Z, r24
			p_count[channel_num] = 0;
     374:	fd 01       	movw	r30, r26
     376:	ef 5e       	subi	r30, 0xEF	; 239
     378:	fe 4f       	sbci	r31, 0xFE	; 254
     37a:	10 82       	st	Z, r1
			p_data[channel_num] = 0x00;
     37c:	a8 5e       	subi	r26, 0xE8	; 232
     37e:	be 4f       	sbci	r27, 0xFE	; 254
     380:	1c 92       	st	X, r1
     382:	08 95       	ret

00000384 <S3>:
}

inline void S3(uint8_t channel_num){
	//This code in here is the function of State S3 from the diagram
			//	in my thesis.
			//COMPRESS AND REPORT!
			//mark direction
			sbi(out_direction, channel_num);
     384:	e8 2f       	mov	r30, r24
     386:	ff 27       	eor	r31, r31
     388:	81 e0       	ldi	r24, 0x01	; 1
     38a:	90 e0       	ldi	r25, 0x00	; 0
     38c:	0e 2e       	mov	r0, r30
     38e:	02 c0       	rjmp	.+4      	; 0x394
     390:	88 0f       	add	r24, r24
     392:	99 1f       	adc	r25, r25
     394:	0a 94       	dec	r0
     396:	e2 f7       	brpl	.-8      	; 0x390
     398:	20 91 1f 01 	lds	r18, 0x011F
     39c:	28 2b       	or	r18, r24
     39e:	20 93 1f 01 	sts	0x011F, r18
			p_state[channel_num] = S0; //reset for next byte
     3a2:	e6 5f       	subi	r30, 0xF6	; 246
     3a4:	fe 4f       	sbci	r31, 0xFE	; 254
     3a6:	10 82       	st	Z, r1
     3a8:	08 95       	ret

000003aa <iris_byte_assembly>:
}

//process each channel
inline void iris_byte_assembly(uint8_t channel_num){
     3aa:	cf 93       	push	r28
     3ac:	df 93       	push	r29
	switch(p_state[channel_num]){
     3ae:	c8 2f       	mov	r28, r24
     3b0:	dd 27       	eor	r29, r29
     3b2:	ae 01       	movw	r20, r28
     3b4:	46 5f       	subi	r20, 0xF6	; 246
     3b6:	5e 4f       	sbci	r21, 0xFE	; 254
     3b8:	fa 01       	movw	r30, r20
     3ba:	80 81       	ld	r24, Z
     3bc:	99 27       	eor	r25, r25
     3be:	00 97       	sbiw	r24, 0x00	; 0
     3c0:	29 f0       	breq	.+10     	; 0x3cc
     3c2:	02 97       	sbiw	r24, 0x02	; 2
     3c4:	a9 f0       	breq	.+42     	; 0x3f0
	case S0:
		//LOOK FOR START SYMBOL
		if (p_symbol[channel_num] == SYM_START_Q){
			S1(channel_num);
		}
		break;
	
//	case S1: implemented as a function call above
	
	case S2:
		//COLLECT DATA BITS
		switch(p_symbol[channel_num]){
		
			case SYM_0_Q:
				//p_data[channel_num] is wiped to 0x00 during START detection
				//	this allows us to make the optimization of not testing or 
				//	writing the data byte now (since the bit position is already 0)
				//	just increase the bit pointer to indicate that we have seen 
				//	this valid bit already
				p_count[channel_num]++;	
				
				//END DETECTION (found valid data byte)
				if (p_count[channel_num] >= 8){
					S3(channel_num);
				}
				break;
			
			case SYM_1_Q:
				//write a 1 to the current bit position
				//remember that bits arrive MSb first, but count goes up
				//i.e. bit position 7 arrives first, when p_count = 0
				//so we need a bit of inversion logic here
				p_data[channel_num] |= (0x80 >> p_count[channel_num]);
				p_count[channel_num]++;	
				
				//END DETECTION (found valid data byte)
				if (p_count[channel_num] >= 8){
					S3(channel_num);
				}
				break;
			
			case SYM_START_Q:
				S1(channel_num);
				break;
			
			default: //SYM_INVALID_Q
				p_state[channel_num] = S0;
				break;
		}
		break;
		
	default:
		p_state[channel_num] = S0; //error recovery	
     3c6:	ea 01       	movw	r28, r20
     3c8:	18 82       	st	Y, r1
     3ca:	65 c0       	rjmp	.+202    	; 0x496
     3cc:	fe 01       	movw	r30, r28
     3ce:	ed 5f       	subi	r30, 0xFD	; 253
     3d0:	fe 4f       	sbci	r31, 0xFE	; 254
     3d2:	80 81       	ld	r24, Z
     3d4:	83 30       	cpi	r24, 0x03	; 3
     3d6:	09 f0       	breq	.+2      	; 0x3da
     3d8:	5e c0       	rjmp	.+188    	; 0x496
     3da:	82 e0       	ldi	r24, 0x02	; 2
     3dc:	fa 01       	movw	r30, r20
     3de:	80 83       	st	Z, r24
     3e0:	fe 01       	movw	r30, r28
     3e2:	ef 5e       	subi	r30, 0xEF	; 239
     3e4:	fe 4f       	sbci	r31, 0xFE	; 254
     3e6:	10 82       	st	Z, r1
     3e8:	c8 5e       	subi	r28, 0xE8	; 232
     3ea:	de 4f       	sbci	r29, 0xFE	; 254
     3ec:	18 82       	st	Y, r1
     3ee:	53 c0       	rjmp	.+166    	; 0x496
     3f0:	fe 01       	movw	r30, r28
     3f2:	ed 5f       	subi	r30, 0xFD	; 253
     3f4:	fe 4f       	sbci	r31, 0xFE	; 254
     3f6:	60 81       	ld	r22, Z
     3f8:	26 2f       	mov	r18, r22
     3fa:	33 27       	eor	r19, r19
     3fc:	22 30       	cpi	r18, 0x02	; 2
     3fe:	31 05       	cpc	r19, r1
     400:	29 f1       	breq	.+74     	; 0x44c
     402:	23 30       	cpi	r18, 0x03	; 3
     404:	31 05       	cpc	r19, r1
     406:	3c f4       	brge	.+14     	; 0x416
     408:	21 30       	cpi	r18, 0x01	; 1
     40a:	31 05       	cpc	r19, r1
     40c:	51 f0       	breq	.+20     	; 0x422
     40e:	c6 5f       	subi	r28, 0xF6	; 246
     410:	de 4f       	sbci	r29, 0xFE	; 254
     412:	18 82       	st	Y, r1
     414:	40 c0       	rjmp	.+128    	; 0x496
     416:	23 30       	cpi	r18, 0x03	; 3
     418:	31 05       	cpc	r19, r1
     41a:	f9 f2       	breq	.-66     	; 0x3da
     41c:	c6 5f       	subi	r28, 0xF6	; 246
     41e:	de 4f       	sbci	r29, 0xFE	; 254
     420:	f8 cf       	rjmp	.-16     	; 0x412
     422:	fe 01       	movw	r30, r28
     424:	ef 5e       	subi	r30, 0xEF	; 239
     426:	fe 4f       	sbci	r31, 0xFE	; 254
     428:	70 81       	ld	r23, Z
     42a:	7f 5f       	subi	r23, 0xFF	; 255
     42c:	70 83       	st	Z, r23
     42e:	78 30       	cpi	r23, 0x08	; 8
     430:	90 f1       	brcs	.+100    	; 0x496
     432:	02 c0       	rjmp	.+4      	; 0x438
     434:	22 0f       	add	r18, r18
     436:	33 1f       	adc	r19, r19
     438:	ca 95       	dec	r28
     43a:	e2 f7       	brpl	.-8      	; 0x434
     43c:	30 91 1f 01 	lds	r19, 0x011F
     440:	32 2b       	or	r19, r18
     442:	30 93 1f 01 	sts	0x011F, r19
     446:	ea 01       	movw	r28, r20
     448:	18 82       	st	Y, r1
     44a:	25 c0       	rjmp	.+74     	; 0x496
     44c:	fe 01       	movw	r30, r28
     44e:	e8 5e       	subi	r30, 0xE8	; 232
     450:	fe 4f       	sbci	r31, 0xFE	; 254
     452:	de 01       	movw	r26, r28
     454:	af 5e       	subi	r26, 0xEF	; 239
     456:	be 4f       	sbci	r27, 0xFE	; 254
     458:	6c 91       	ld	r22, X
     45a:	80 e8       	ldi	r24, 0x80	; 128
     45c:	90 e0       	ldi	r25, 0x00	; 0
     45e:	06 2e       	mov	r0, r22
     460:	02 c0       	rjmp	.+4      	; 0x466
     462:	95 95       	asr	r25
     464:	87 95       	ror	r24
     466:	0a 94       	dec	r0
     468:	e2 f7       	brpl	.-8      	; 0x462
     46a:	90 81       	ld	r25, Z
     46c:	98 2b       	or	r25, r24
     46e:	90 83       	st	Z, r25
     470:	26 2f       	mov	r18, r22
     472:	2f 5f       	subi	r18, 0xFF	; 255
     474:	2c 93       	st	X, r18
     476:	28 30       	cpi	r18, 0x08	; 8
     478:	70 f0       	brcs	.+28     	; 0x496
     47a:	81 e0       	ldi	r24, 0x01	; 1
     47c:	90 e0       	ldi	r25, 0x00	; 0
     47e:	02 c0       	rjmp	.+4      	; 0x484
     480:	88 0f       	add	r24, r24
     482:	99 1f       	adc	r25, r25
     484:	ca 95       	dec	r28
     486:	e2 f7       	brpl	.-8      	; 0x480
     488:	b0 91 1f 01 	lds	r27, 0x011F
     48c:	b8 2b       	or	r27, r24
     48e:	b0 93 1f 01 	sts	0x011F, r27
     492:	ea 01       	movw	r28, r20
     494:	18 82       	st	Y, r1
     496:	df 91       	pop	r29
     498:	cf 91       	pop	r28
     49a:	08 95       	ret

0000049c <__vector_7>:
		break;
	}	
}


//----------------------------------------------------------------
//- INTERRUPT SERVICE ROUTINES
//----------------------------------------------------------------

//30 = 350uS

#define t400us 15   //40 //actually 336us
#define t200us 23 //actually 232us
#define t150us 14 //16 //actually 156us

//#define t350us 32 //actually 336us


SIGNAL(SIG_OUTPUT_COMPARE2A){
     49c:	1f 92       	push	r1
     49e:	0f 92       	push	r0
     4a0:	0f b6       	in	r0, 0x3f	; 63
     4a2:	0f 92       	push	r0
     4a4:	11 24       	eor	r1, r1
     4a6:	2f 93       	push	r18
     4a8:	3f 93       	push	r19
     4aa:	4f 93       	push	r20
     4ac:	5f 93       	push	r21
     4ae:	6f 93       	push	r22
     4b0:	7f 93       	push	r23
     4b2:	8f 93       	push	r24
     4b4:	9f 93       	push	r25
  static volatile uint8_t	cpp=0;
  static volatile uint8_t	active=t400us; 
  
  cpp++;
     4b6:	20 91 02 01 	lds	r18, 0x0102
     4ba:	2f 5f       	subi	r18, 0xFF	; 255
     4bc:	20 93 02 01 	sts	0x0102, r18
  if (cpp == active){
     4c0:	90 91 02 01 	lds	r25, 0x0102
     4c4:	80 91 00 01 	lds	r24, 0x0100
     4c8:	98 17       	cp	r25, r24
     4ca:	c9 f0       	breq	.+50     	; 0x4fe
    disable_output_irclock();	
  }
  else if (cpp >= 80){  //should be 80
     4cc:	30 91 02 01 	lds	r19, 0x0102
     4d0:	30 35       	cpi	r19, 0x50	; 80
     4d2:	28 f1       	brcs	.+74     	; 0x51e
    cpp = 0;
     4d4:	10 92 02 01 	sts	0x0102, r1
    if (active == t400us) active=t150us;
     4d8:	40 91 00 01 	lds	r20, 0x0100
     4dc:	4f 30       	cpi	r20, 0x0F	; 15
     4de:	b9 f0       	breq	.+46     	; 0x50e
    else if (active == t150us) active=t200us;
     4e0:	50 91 00 01 	lds	r21, 0x0100
     4e4:	5e 30       	cpi	r21, 0x0E	; 14
     4e6:	79 f0       	breq	.+30     	; 0x506
    else if (active == t200us) active=t400us; 
     4e8:	60 91 00 01 	lds	r22, 0x0100
     4ec:	67 31       	cpi	r22, 0x17	; 23
     4ee:	99 f0       	breq	.+38     	; 0x516
    active = t400us; //xxx
     4f0:	7f e0       	ldi	r23, 0x0F	; 15
     4f2:	70 93 00 01 	sts	0x0100, r23
     4f6:	82 e1       	ldi	r24, 0x12	; 18
     4f8:	80 93 b0 00 	sts	0x00B0, r24
     4fc:	10 c0       	rjmp	.+32     	; 0x51e
     4fe:	82 e2       	ldi	r24, 0x22	; 34
     500:	80 93 b0 00 	sts	0x00B0, r24
     504:	0c c0       	rjmp	.+24     	; 0x51e
     506:	87 e1       	ldi	r24, 0x17	; 23
     508:	80 93 00 01 	sts	0x0100, r24
     50c:	f1 cf       	rjmp	.-30     	; 0x4f0
     50e:	8e e0       	ldi	r24, 0x0E	; 14
     510:	80 93 00 01 	sts	0x0100, r24
     514:	ed cf       	rjmp	.-38     	; 0x4f0
     516:	8f e0       	ldi	r24, 0x0F	; 15
     518:	80 93 00 01 	sts	0x0100, r24
     51c:	e9 cf       	rjmp	.-46     	; 0x4f0
     51e:	9f 91       	pop	r25
     520:	8f 91       	pop	r24
     522:	7f 91       	pop	r23
     524:	6f 91       	pop	r22
     526:	5f 91       	pop	r21
     528:	4f 91       	pop	r20
     52a:	3f 91       	pop	r19
     52c:	2f 91       	pop	r18
     52e:	0f 90       	pop	r0
     530:	0f be       	out	0x3f, r0	; 63
     532:	0f 90       	pop	r0
     534:	1f 90       	pop	r1
     536:	18 95       	reti

00000538 <USRT_DATA_RX_ISR>:
    enable_output_irclock();
    //tpl(TOGGLE);
    //disable_output_irclock();//xxx	
  }
}

//make sure that this interrupt is interruptable
//data0 was received first
inline void USRT_DATA_RX_ISR(uint8_t data0, uint8_t data1){
     538:	ef 92       	push	r14
     53a:	ff 92       	push	r15
     53c:	1f 93       	push	r17
     53e:	cf 93       	push	r28
     540:	52 e0       	ldi	r21, 0x02	; 2
     542:	28 2f       	mov	r18, r24
     544:	33 27       	eor	r19, r19
     546:	c9 01       	movw	r24, r18
     548:	05 2e       	mov	r0, r21
     54a:	02 c0       	rjmp	.+4      	; 0x550
     54c:	95 95       	asr	r25
     54e:	87 95       	ror	r24
     550:	0a 94       	dec	r0
     552:	e2 f7       	brpl	.-8      	; 0x54c
     554:	83 70       	andi	r24, 0x03	; 3
     556:	80 93 09 01 	sts	0x0109, r24
     55a:	c9 01       	movw	r24, r18
     55c:	95 95       	asr	r25
     55e:	87 95       	ror	r24
     560:	83 70       	andi	r24, 0x03	; 3
     562:	80 93 08 01 	sts	0x0108, r24
     566:	12 2f       	mov	r17, r18
     568:	13 70       	andi	r17, 0x03	; 3
     56a:	10 93 07 01 	sts	0x0107, r17
     56e:	26 2f       	mov	r18, r22
     570:	33 27       	eor	r19, r19
     572:	c9 01       	movw	r24, r18
     574:	95 95       	asr	r25
     576:	87 95       	ror	r24
     578:	95 95       	asr	r25
     57a:	87 95       	ror	r24
     57c:	95 95       	asr	r25
     57e:	87 95       	ror	r24
     580:	83 70       	andi	r24, 0x03	; 3
     582:	80 93 06 01 	sts	0x0106, r24
     586:	c9 01       	movw	r24, r18
     588:	05 2e       	mov	r0, r21
     58a:	02 c0       	rjmp	.+4      	; 0x590
     58c:	95 95       	asr	r25
     58e:	87 95       	ror	r24
     590:	0a 94       	dec	r0
     592:	e2 f7       	brpl	.-8      	; 0x58c
     594:	83 70       	andi	r24, 0x03	; 3
     596:	80 93 05 01 	sts	0x0105, r24
     59a:	c9 01       	movw	r24, r18
     59c:	95 95       	asr	r25
     59e:	87 95       	ror	r24
     5a0:	83 70       	andi	r24, 0x03	; 3
     5a2:	80 93 04 01 	sts	0x0104, r24
     5a6:	82 2f       	mov	r24, r18
     5a8:	83 70       	andi	r24, 0x03	; 3
     5aa:	28 2f       	mov	r18, r24
     5ac:	33 27       	eor	r19, r19
     5ae:	20 93 03 01 	sts	0x0103, r18
     5b2:	80 91 0a 01 	lds	r24, 0x010A
     5b6:	99 27       	eor	r25, r25
     5b8:	00 97       	sbiw	r24, 0x00	; 0
     5ba:	09 f4       	brne	.+2      	; 0x5be
     5bc:	8b c0       	rjmp	.+278    	; 0x6d4
     5be:	02 97       	sbiw	r24, 0x02	; 2
     5c0:	09 f4       	brne	.+2      	; 0x5c4
     5c2:	fe c0       	rjmp	.+508    	; 0x7c0
     5c4:	10 92 0a 01 	sts	0x010A, r1
     5c8:	80 91 0b 01 	lds	r24, 0x010B
     5cc:	99 27       	eor	r25, r25
     5ce:	00 97       	sbiw	r24, 0x00	; 0
     5d0:	09 f4       	brne	.+2      	; 0x5d4
     5d2:	8f c0       	rjmp	.+286    	; 0x6f2
     5d4:	02 97       	sbiw	r24, 0x02	; 2
     5d6:	09 f4       	brne	.+2      	; 0x5da
     5d8:	9c c1       	rjmp	.+824    	; 0x912
     5da:	10 92 0b 01 	sts	0x010B, r1
     5de:	22 e0       	ldi	r18, 0x02	; 2
     5e0:	80 91 0c 01 	lds	r24, 0x010C
     5e4:	99 27       	eor	r25, r25
     5e6:	00 97       	sbiw	r24, 0x00	; 0
     5e8:	09 f4       	brne	.+2      	; 0x5ec
     5ea:	96 c0       	rjmp	.+300    	; 0x718
     5ec:	02 97       	sbiw	r24, 0x02	; 2
     5ee:	09 f4       	brne	.+2      	; 0x5f2
     5f0:	58 c1       	rjmp	.+688    	; 0x8a2
     5f2:	10 92 0c 01 	sts	0x010C, r1
     5f6:	80 91 0d 01 	lds	r24, 0x010D
     5fa:	99 27       	eor	r25, r25
     5fc:	00 97       	sbiw	r24, 0x00	; 0
     5fe:	09 f4       	brne	.+2      	; 0x602
     600:	9c c0       	rjmp	.+312    	; 0x73a
     602:	02 97       	sbiw	r24, 0x02	; 2
     604:	09 f4       	brne	.+2      	; 0x608
     606:	69 c1       	rjmp	.+722    	; 0x8da
     608:	10 92 0d 01 	sts	0x010D, r1
     60c:	80 91 0e 01 	lds	r24, 0x010E
     610:	99 27       	eor	r25, r25
     612:	00 97       	sbiw	r24, 0x00	; 0
     614:	09 f4       	brne	.+2      	; 0x618
     616:	a3 c0       	rjmp	.+326    	; 0x75e
     618:	02 97       	sbiw	r24, 0x02	; 2
     61a:	09 f4       	brne	.+2      	; 0x61e
     61c:	26 c1       	rjmp	.+588    	; 0x86a
     61e:	10 92 0e 01 	sts	0x010E, r1
     622:	80 91 0f 01 	lds	r24, 0x010F
     626:	99 27       	eor	r25, r25
     628:	00 97       	sbiw	r24, 0x00	; 0
     62a:	09 f4       	brne	.+2      	; 0x62e
     62c:	aa c0       	rjmp	.+340    	; 0x782
     62e:	02 97       	sbiw	r24, 0x02	; 2
     630:	09 f4       	brne	.+2      	; 0x634
     632:	ff c0       	rjmp	.+510    	; 0x832
     634:	10 92 0f 01 	sts	0x010F, r1
     638:	80 91 10 01 	lds	r24, 0x0110
     63c:	99 27       	eor	r25, r25
     63e:	00 97       	sbiw	r24, 0x00	; 0
     640:	09 f4       	brne	.+2      	; 0x644
     642:	b1 c0       	rjmp	.+354    	; 0x7a6
     644:	02 97       	sbiw	r24, 0x02	; 2
     646:	09 f4       	brne	.+2      	; 0x64a
     648:	d8 c0       	rjmp	.+432    	; 0x7fa
     64a:	10 92 10 01 	sts	0x0110, r1
	uint8_t j;
	uint8_t processed;
	uint8_t matched;
	uint8_t k;

	//Receive & Unpack
		iris_xfr_receive(data0, data1);
	//Process Channels
		iris_byte_assembly(0);
		iris_byte_assembly(1);
		iris_byte_assembly(2);
		iris_byte_assembly(3);
		iris_byte_assembly(4);
		iris_byte_assembly(5);
		iris_byte_assembly(6);
		//iris_byte_assembly(7); //enable if you ever add the 7th channel
	//Check if any channels finished
i2c_enqueue(0x90); //xxx
     64e:	80 e9       	ldi	r24, 0x90	; 144
     650:	0e 94 79 05 	call	0xaf2
i2c_enqueue(out_direction); //xxx
     654:	80 91 1f 01 	lds	r24, 0x011F
     658:	0e 94 79 05 	call	0xaf2
		
		processed = out_direction;
     65c:	c0 91 1f 01 	lds	r28, 0x011F
		while (processed != 0x00){
tpl(ON); //xxx
			matched = 0x00;
			k = NUM__OF_CHANNELS+1;
			//somebody finished
			for(j=0;j<NUM__OF_CHANNELS;j++){
				if ((processed & _BV(j)) > 0){
					//channel j finished collecting data this cycle
					//check if other channels carry this data
					if (k > NUM__OF_CHANNELS){
						k = j; //lock data target
						matched |= _BV(k); //set bit for this channel in DIRECTION output
					}
					else {
						//found second or additional channel with the same data at the same time
						matched |= _BV(j); //set bit for this channel in DIRECTION output
					}
					processed &= ~(_BV(j)); //clear this channels bit to mark as seen
				}	
			}
			//enqueue matched data
			cli(); 	// CRITICAL SECTION!
					//		We mark this critical because it weighs on our analysis of the i2c
					//		outgoing data queue; Outgoing data is always two-byte aligned so we
					//		can use a mod2 function over the remaining bytes to be sent to infer
					//		that we are still in alignment.
				i2c_enqueue(matched);
				i2c_enqueue(p_data[k]);
			sei(); //END CRITICAL SECTION!
     660:	cc 23       	and	r28, r28
     662:	09 f4       	brne	.+2      	; 0x666
     664:	06 c2       	rjmp	.+1036   	; 0xa72
     666:	61 e0       	ldi	r22, 0x01	; 1
     668:	e6 2e       	mov	r14, r22
     66a:	f1 2c       	mov	r15, r1
     66c:	81 e0       	ldi	r24, 0x01	; 1
     66e:	0e 94 9e 00 	call	0x13c
     672:	70 e0       	ldi	r23, 0x00	; 0
     674:	18 e0       	ldi	r17, 0x08	; 8
     676:	67 2f       	mov	r22, r23
     678:	ac 2f       	mov	r26, r28
     67a:	bb 27       	eor	r27, r27
     67c:	46 2f       	mov	r20, r22
     67e:	55 27       	eor	r21, r21
     680:	97 01       	movw	r18, r14
     682:	04 2e       	mov	r0, r20
     684:	02 c0       	rjmp	.+4      	; 0x68a
     686:	22 0f       	add	r18, r18
     688:	33 1f       	adc	r19, r19
     68a:	0a 94       	dec	r0
     68c:	e2 f7       	brpl	.-8      	; 0x686
     68e:	a2 23       	and	r26, r18
     690:	b3 23       	and	r27, r19
     692:	1a 16       	cp	r1, r26
     694:	1b 06       	cpc	r1, r27
     696:	64 f4       	brge	.+24     	; 0x6b0
     698:	18 30       	cpi	r17, 0x08	; 8
     69a:	08 f0       	brcs	.+2      	; 0x69e
     69c:	16 2f       	mov	r17, r22
     69e:	72 2b       	or	r23, r18
     6a0:	c7 01       	movw	r24, r14
     6a2:	02 c0       	rjmp	.+4      	; 0x6a8
     6a4:	88 0f       	add	r24, r24
     6a6:	99 1f       	adc	r25, r25
     6a8:	4a 95       	dec	r20
     6aa:	e2 f7       	brpl	.-8      	; 0x6a4
     6ac:	80 95       	com	r24
     6ae:	c8 23       	and	r28, r24
     6b0:	6f 5f       	subi	r22, 0xFF	; 255
     6b2:	67 30       	cpi	r22, 0x07	; 7
     6b4:	08 f3       	brcs	.-62     	; 0x678
     6b6:	f8 94       	cli
     6b8:	87 2f       	mov	r24, r23
     6ba:	0e 94 79 05 	call	0xaf2
     6be:	e1 2f       	mov	r30, r17
     6c0:	ff 27       	eor	r31, r31
     6c2:	e8 5e       	subi	r30, 0xE8	; 232
     6c4:	fe 4f       	sbci	r31, 0xFE	; 254
     6c6:	80 81       	ld	r24, Z
     6c8:	0e 94 79 05 	call	0xaf2
     6cc:	78 94       	sei
     6ce:	cc 23       	and	r28, r28
     6d0:	69 f6       	brne	.-102    	; 0x66c
     6d2:	cf c1       	rjmp	.+926    	; 0xa72
     6d4:	23 30       	cpi	r18, 0x03	; 3
     6d6:	09 f0       	breq	.+2      	; 0x6da
     6d8:	77 cf       	rjmp	.-274    	; 0x5c8
     6da:	50 93 0a 01 	sts	0x010A, r21
     6de:	10 92 11 01 	sts	0x0111, r1
     6e2:	10 92 18 01 	sts	0x0118, r1
     6e6:	80 91 0b 01 	lds	r24, 0x010B
     6ea:	99 27       	eor	r25, r25
     6ec:	00 97       	sbiw	r24, 0x00	; 0
     6ee:	09 f0       	breq	.+2      	; 0x6f2
     6f0:	71 cf       	rjmp	.-286    	; 0x5d4
     6f2:	60 91 04 01 	lds	r22, 0x0104
     6f6:	63 30       	cpi	r22, 0x03	; 3
     6f8:	09 f0       	breq	.+2      	; 0x6fc
     6fa:	71 cf       	rjmp	.-286    	; 0x5de
     6fc:	a2 e0       	ldi	r26, 0x02	; 2
     6fe:	a0 93 0b 01 	sts	0x010B, r26
     702:	10 92 12 01 	sts	0x0112, r1
     706:	10 92 19 01 	sts	0x0119, r1
     70a:	22 e0       	ldi	r18, 0x02	; 2
     70c:	80 91 0c 01 	lds	r24, 0x010C
     710:	99 27       	eor	r25, r25
     712:	00 97       	sbiw	r24, 0x00	; 0
     714:	09 f0       	breq	.+2      	; 0x718
     716:	6a cf       	rjmp	.-300    	; 0x5ec
     718:	b0 91 05 01 	lds	r27, 0x0105
     71c:	b3 30       	cpi	r27, 0x03	; 3
     71e:	09 f0       	breq	.+2      	; 0x722
     720:	6a cf       	rjmp	.-300    	; 0x5f6
     722:	20 93 0c 01 	sts	0x010C, r18
     726:	10 92 13 01 	sts	0x0113, r1
     72a:	10 92 1a 01 	sts	0x011A, r1
     72e:	80 91 0d 01 	lds	r24, 0x010D
     732:	99 27       	eor	r25, r25
     734:	00 97       	sbiw	r24, 0x00	; 0
     736:	09 f0       	breq	.+2      	; 0x73a
     738:	64 cf       	rjmp	.-312    	; 0x602
     73a:	80 91 06 01 	lds	r24, 0x0106
     73e:	83 30       	cpi	r24, 0x03	; 3
     740:	09 f0       	breq	.+2      	; 0x744
     742:	64 cf       	rjmp	.-312    	; 0x60c
     744:	22 e0       	ldi	r18, 0x02	; 2
     746:	20 93 0d 01 	sts	0x010D, r18
     74a:	10 92 14 01 	sts	0x0114, r1
     74e:	10 92 1b 01 	sts	0x011B, r1
     752:	80 91 0e 01 	lds	r24, 0x010E
     756:	99 27       	eor	r25, r25
     758:	00 97       	sbiw	r24, 0x00	; 0
     75a:	09 f0       	breq	.+2      	; 0x75e
     75c:	5d cf       	rjmp	.-326    	; 0x618
     75e:	50 91 07 01 	lds	r21, 0x0107
     762:	53 30       	cpi	r21, 0x03	; 3
     764:	09 f0       	breq	.+2      	; 0x768
     766:	5d cf       	rjmp	.-326    	; 0x622
     768:	92 e0       	ldi	r25, 0x02	; 2
     76a:	90 93 0e 01 	sts	0x010E, r25
     76e:	10 92 15 01 	sts	0x0115, r1
     772:	10 92 1c 01 	sts	0x011C, r1
     776:	80 91 0f 01 	lds	r24, 0x010F
     77a:	99 27       	eor	r25, r25
     77c:	00 97       	sbiw	r24, 0x00	; 0
     77e:	09 f0       	breq	.+2      	; 0x782
     780:	56 cf       	rjmp	.-340    	; 0x62e
     782:	a0 91 08 01 	lds	r26, 0x0108
     786:	a3 30       	cpi	r26, 0x03	; 3
     788:	09 f0       	breq	.+2      	; 0x78c
     78a:	56 cf       	rjmp	.-340    	; 0x638
     78c:	e2 e0       	ldi	r30, 0x02	; 2
     78e:	e0 93 0f 01 	sts	0x010F, r30
     792:	10 92 16 01 	sts	0x0116, r1
     796:	10 92 1d 01 	sts	0x011D, r1
     79a:	80 91 10 01 	lds	r24, 0x0110
     79e:	99 27       	eor	r25, r25
     7a0:	00 97       	sbiw	r24, 0x00	; 0
     7a2:	09 f0       	breq	.+2      	; 0x7a6
     7a4:	4f cf       	rjmp	.-354    	; 0x644
     7a6:	f0 91 09 01 	lds	r31, 0x0109
     7aa:	f3 30       	cpi	r31, 0x03	; 3
     7ac:	09 f0       	breq	.+2      	; 0x7b0
     7ae:	4f cf       	rjmp	.-354    	; 0x64e
     7b0:	32 e0       	ldi	r19, 0x02	; 2
     7b2:	30 93 10 01 	sts	0x0110, r19
     7b6:	10 92 17 01 	sts	0x0117, r1
     7ba:	10 92 1e 01 	sts	0x011E, r1
     7be:	47 cf       	rjmp	.-370    	; 0x64e
     7c0:	82 2f       	mov	r24, r18
     7c2:	99 27       	eor	r25, r25
     7c4:	82 30       	cpi	r24, 0x02	; 2
     7c6:	91 05       	cpc	r25, r1
     7c8:	09 f4       	brne	.+2      	; 0x7cc
     7ca:	dc c0       	rjmp	.+440    	; 0x984
     7cc:	83 30       	cpi	r24, 0x03	; 3
     7ce:	91 05       	cpc	r25, r1
     7d0:	0c f0       	brlt	.+2      	; 0x7d4
     7d2:	ba c0       	rjmp	.+372    	; 0x948
     7d4:	01 97       	sbiw	r24, 0x01	; 1
     7d6:	09 f0       	breq	.+2      	; 0x7da
     7d8:	f5 ce       	rjmp	.-534    	; 0x5c4
     7da:	80 91 11 01 	lds	r24, 0x0111
     7de:	8f 5f       	subi	r24, 0xFF	; 255
     7e0:	80 93 11 01 	sts	0x0111, r24
     7e4:	88 30       	cpi	r24, 0x08	; 8
     7e6:	08 f4       	brcc	.+2      	; 0x7ea
     7e8:	ef ce       	rjmp	.-546    	; 0x5c8
     7ea:	50 91 1f 01 	lds	r21, 0x011F
     7ee:	51 60       	ori	r21, 0x01	; 1
     7f0:	50 93 1f 01 	sts	0x011F, r21
     7f4:	10 92 0a 01 	sts	0x010A, r1
     7f8:	e7 ce       	rjmp	.-562    	; 0x5c8
     7fa:	80 91 09 01 	lds	r24, 0x0109
     7fe:	99 27       	eor	r25, r25
     800:	82 30       	cpi	r24, 0x02	; 2
     802:	91 05       	cpc	r25, r1
     804:	09 f4       	brne	.+2      	; 0x808
     806:	e0 c0       	rjmp	.+448    	; 0x9c8
     808:	83 30       	cpi	r24, 0x03	; 3
     80a:	91 05       	cpc	r25, r1
     80c:	0c f0       	brlt	.+2      	; 0x810
     80e:	a2 c0       	rjmp	.+324    	; 0x954
     810:	01 97       	sbiw	r24, 0x01	; 1
     812:	09 f0       	breq	.+2      	; 0x816
     814:	1a cf       	rjmp	.-460    	; 0x64a
     816:	80 91 17 01 	lds	r24, 0x0117
     81a:	8f 5f       	subi	r24, 0xFF	; 255
     81c:	80 93 17 01 	sts	0x0117, r24
     820:	88 30       	cpi	r24, 0x08	; 8
     822:	08 f4       	brcc	.+2      	; 0x826
     824:	14 cf       	rjmp	.-472    	; 0x64e
     826:	80 91 1f 01 	lds	r24, 0x011F
     82a:	80 64       	ori	r24, 0x40	; 64
     82c:	80 93 1f 01 	sts	0x011F, r24
     830:	0c cf       	rjmp	.-488    	; 0x64a
     832:	80 91 08 01 	lds	r24, 0x0108
     836:	99 27       	eor	r25, r25
     838:	82 30       	cpi	r24, 0x02	; 2
     83a:	91 05       	cpc	r25, r1
     83c:	09 f4       	brne	.+2      	; 0x840
     83e:	b3 c0       	rjmp	.+358    	; 0x9a6
     840:	83 30       	cpi	r24, 0x03	; 3
     842:	91 05       	cpc	r25, r1
     844:	0c f0       	brlt	.+2      	; 0x848
     846:	8e c0       	rjmp	.+284    	; 0x964
     848:	01 97       	sbiw	r24, 0x01	; 1
     84a:	09 f0       	breq	.+2      	; 0x84e
     84c:	f3 ce       	rjmp	.-538    	; 0x634
     84e:	80 91 16 01 	lds	r24, 0x0116
     852:	8f 5f       	subi	r24, 0xFF	; 255
     854:	80 93 16 01 	sts	0x0116, r24
     858:	88 30       	cpi	r24, 0x08	; 8
     85a:	08 f4       	brcc	.+2      	; 0x85e
     85c:	ed ce       	rjmp	.-550    	; 0x638
     85e:	c0 91 1f 01 	lds	r28, 0x011F
     862:	c0 62       	ori	r28, 0x20	; 32
     864:	c0 93 1f 01 	sts	0x011F, r28
     868:	e5 ce       	rjmp	.-566    	; 0x634
     86a:	80 91 07 01 	lds	r24, 0x0107
     86e:	99 27       	eor	r25, r25
     870:	82 30       	cpi	r24, 0x02	; 2
     872:	91 05       	cpc	r25, r1
     874:	09 f4       	brne	.+2      	; 0x878
     876:	ec c0       	rjmp	.+472    	; 0xa50
     878:	83 30       	cpi	r24, 0x03	; 3
     87a:	91 05       	cpc	r25, r1
     87c:	0c f0       	brlt	.+2      	; 0x880
     87e:	7a c0       	rjmp	.+244    	; 0x974
     880:	01 97       	sbiw	r24, 0x01	; 1
     882:	09 f0       	breq	.+2      	; 0x886
     884:	cc ce       	rjmp	.-616    	; 0x61e
     886:	80 91 15 01 	lds	r24, 0x0115
     88a:	8f 5f       	subi	r24, 0xFF	; 255
     88c:	80 93 15 01 	sts	0x0115, r24
     890:	88 30       	cpi	r24, 0x08	; 8
     892:	08 f4       	brcc	.+2      	; 0x896
     894:	c6 ce       	rjmp	.-628    	; 0x622
     896:	70 91 1f 01 	lds	r23, 0x011F
     89a:	70 61       	ori	r23, 0x10	; 16
     89c:	70 93 1f 01 	sts	0x011F, r23
     8a0:	be ce       	rjmp	.-644    	; 0x61e
     8a2:	80 91 05 01 	lds	r24, 0x0105
     8a6:	99 27       	eor	r25, r25
     8a8:	82 30       	cpi	r24, 0x02	; 2
     8aa:	91 05       	cpc	r25, r1
     8ac:	09 f4       	brne	.+2      	; 0x8b0
     8ae:	bf c0       	rjmp	.+382    	; 0xa2e
     8b0:	83 30       	cpi	r24, 0x03	; 3
     8b2:	91 05       	cpc	r25, r1
     8b4:	0c f0       	brlt	.+2      	; 0x8b8
     8b6:	5a c0       	rjmp	.+180    	; 0x96c
     8b8:	01 97       	sbiw	r24, 0x01	; 1
     8ba:	09 f0       	breq	.+2      	; 0x8be
     8bc:	9a ce       	rjmp	.-716    	; 0x5f2
     8be:	80 91 13 01 	lds	r24, 0x0113
     8c2:	8f 5f       	subi	r24, 0xFF	; 255
     8c4:	80 93 13 01 	sts	0x0113, r24
     8c8:	88 30       	cpi	r24, 0x08	; 8
     8ca:	08 f4       	brcc	.+2      	; 0x8ce
     8cc:	94 ce       	rjmp	.-728    	; 0x5f6
     8ce:	f0 91 1f 01 	lds	r31, 0x011F
     8d2:	f4 60       	ori	r31, 0x04	; 4
     8d4:	f0 93 1f 01 	sts	0x011F, r31
     8d8:	8c ce       	rjmp	.-744    	; 0x5f2
     8da:	80 91 06 01 	lds	r24, 0x0106
     8de:	99 27       	eor	r25, r25
     8e0:	82 30       	cpi	r24, 0x02	; 2
     8e2:	91 05       	cpc	r25, r1
     8e4:	09 f4       	brne	.+2      	; 0x8e8
     8e6:	92 c0       	rjmp	.+292    	; 0xa0c
     8e8:	83 30       	cpi	r24, 0x03	; 3
     8ea:	91 05       	cpc	r25, r1
     8ec:	0c f0       	brlt	.+2      	; 0x8f0
     8ee:	46 c0       	rjmp	.+140    	; 0x97c
     8f0:	01 97       	sbiw	r24, 0x01	; 1
     8f2:	09 f0       	breq	.+2      	; 0x8f6
     8f4:	89 ce       	rjmp	.-750    	; 0x608
     8f6:	80 91 14 01 	lds	r24, 0x0114
     8fa:	8f 5f       	subi	r24, 0xFF	; 255
     8fc:	80 93 14 01 	sts	0x0114, r24
     900:	88 30       	cpi	r24, 0x08	; 8
     902:	08 f4       	brcc	.+2      	; 0x906
     904:	83 ce       	rjmp	.-762    	; 0x60c
     906:	30 91 1f 01 	lds	r19, 0x011F
     90a:	38 60       	ori	r19, 0x08	; 8
     90c:	30 93 1f 01 	sts	0x011F, r19
     910:	7b ce       	rjmp	.-778    	; 0x608
     912:	80 91 04 01 	lds	r24, 0x0104
     916:	99 27       	eor	r25, r25
     918:	82 30       	cpi	r24, 0x02	; 2
     91a:	91 05       	cpc	r25, r1
     91c:	09 f4       	brne	.+2      	; 0x920
     91e:	65 c0       	rjmp	.+202    	; 0x9ea
     920:	83 30       	cpi	r24, 0x03	; 3
     922:	91 05       	cpc	r25, r1
     924:	dc f4       	brge	.+54     	; 0x95c
     926:	01 97       	sbiw	r24, 0x01	; 1
     928:	09 f0       	breq	.+2      	; 0x92c
     92a:	57 ce       	rjmp	.-850    	; 0x5da
     92c:	80 91 12 01 	lds	r24, 0x0112
     930:	8f 5f       	subi	r24, 0xFF	; 255
     932:	80 93 12 01 	sts	0x0112, r24
     936:	88 30       	cpi	r24, 0x08	; 8
     938:	08 f4       	brcc	.+2      	; 0x93c
     93a:	51 ce       	rjmp	.-862    	; 0x5de
     93c:	90 91 1f 01 	lds	r25, 0x011F
     940:	92 60       	ori	r25, 0x02	; 2
     942:	90 93 1f 01 	sts	0x011F, r25
     946:	49 ce       	rjmp	.-878    	; 0x5da
     948:	03 97       	sbiw	r24, 0x03	; 3
     94a:	09 f4       	brne	.+2      	; 0x94e
     94c:	c6 ce       	rjmp	.-628    	; 0x6da
     94e:	10 92 0a 01 	sts	0x010A, r1
     952:	3a ce       	rjmp	.-908    	; 0x5c8
     954:	03 97       	sbiw	r24, 0x03	; 3
     956:	09 f0       	breq	.+2      	; 0x95a
     958:	78 ce       	rjmp	.-784    	; 0x64a
     95a:	2a cf       	rjmp	.-428    	; 0x7b0
     95c:	03 97       	sbiw	r24, 0x03	; 3
     95e:	09 f0       	breq	.+2      	; 0x962
     960:	3c ce       	rjmp	.-904    	; 0x5da
     962:	cc ce       	rjmp	.-616    	; 0x6fc
     964:	03 97       	sbiw	r24, 0x03	; 3
     966:	09 f0       	breq	.+2      	; 0x96a
     968:	65 ce       	rjmp	.-822    	; 0x634
     96a:	10 cf       	rjmp	.-480    	; 0x78c
     96c:	03 97       	sbiw	r24, 0x03	; 3
     96e:	09 f0       	breq	.+2      	; 0x972
     970:	40 ce       	rjmp	.-896    	; 0x5f2
     972:	d7 ce       	rjmp	.-594    	; 0x722
     974:	03 97       	sbiw	r24, 0x03	; 3
     976:	09 f0       	breq	.+2      	; 0x97a
     978:	52 ce       	rjmp	.-860    	; 0x61e
     97a:	f6 ce       	rjmp	.-532    	; 0x768
     97c:	03 97       	sbiw	r24, 0x03	; 3
     97e:	09 f0       	breq	.+2      	; 0x982
     980:	43 ce       	rjmp	.-890    	; 0x608
     982:	e0 ce       	rjmp	.-576    	; 0x744
     984:	e0 90 11 01 	lds	r14, 0x0111
     988:	80 e8       	ldi	r24, 0x80	; 128
     98a:	90 e0       	ldi	r25, 0x00	; 0
     98c:	0e 2c       	mov	r0, r14
     98e:	02 c0       	rjmp	.+4      	; 0x994
     990:	95 95       	asr	r25
     992:	87 95       	ror	r24
     994:	0a 94       	dec	r0
     996:	e2 f7       	brpl	.-8      	; 0x990
     998:	20 91 18 01 	lds	r18, 0x0118
     99c:	28 2b       	or	r18, r24
     99e:	20 93 18 01 	sts	0x0118, r18
     9a2:	8e 2d       	mov	r24, r14
     9a4:	1c cf       	rjmp	.-456    	; 0x7de
     9a6:	f0 90 16 01 	lds	r15, 0x0116
     9aa:	80 e8       	ldi	r24, 0x80	; 128
     9ac:	90 e0       	ldi	r25, 0x00	; 0
     9ae:	0f 2c       	mov	r0, r15
     9b0:	02 c0       	rjmp	.+4      	; 0x9b6
     9b2:	95 95       	asr	r25
     9b4:	87 95       	ror	r24
     9b6:	0a 94       	dec	r0
     9b8:	e2 f7       	brpl	.-8      	; 0x9b2
     9ba:	b0 91 1d 01 	lds	r27, 0x011D
     9be:	b8 2b       	or	r27, r24
     9c0:	b0 93 1d 01 	sts	0x011D, r27
     9c4:	8f 2d       	mov	r24, r15
     9c6:	45 cf       	rjmp	.-374    	; 0x852
     9c8:	40 91 17 01 	lds	r20, 0x0117
     9cc:	80 e8       	ldi	r24, 0x80	; 128
     9ce:	90 e0       	ldi	r25, 0x00	; 0
     9d0:	04 2e       	mov	r0, r20
     9d2:	02 c0       	rjmp	.+4      	; 0x9d8
     9d4:	95 95       	asr	r25
     9d6:	87 95       	ror	r24
     9d8:	0a 94       	dec	r0
     9da:	e2 f7       	brpl	.-8      	; 0x9d4
     9dc:	10 91 1e 01 	lds	r17, 0x011E
     9e0:	18 2b       	or	r17, r24
     9e2:	10 93 1e 01 	sts	0x011E, r17
     9e6:	84 2f       	mov	r24, r20
     9e8:	18 cf       	rjmp	.-464    	; 0x81a
     9ea:	f0 90 12 01 	lds	r15, 0x0112
     9ee:	80 e8       	ldi	r24, 0x80	; 128
     9f0:	90 e0       	ldi	r25, 0x00	; 0
     9f2:	0f 2c       	mov	r0, r15
     9f4:	02 c0       	rjmp	.+4      	; 0x9fa
     9f6:	95 95       	asr	r25
     9f8:	87 95       	ror	r24
     9fa:	0a 94       	dec	r0
     9fc:	e2 f7       	brpl	.-8      	; 0x9f6
     9fe:	70 91 19 01 	lds	r23, 0x0119
     a02:	78 2b       	or	r23, r24
     a04:	70 93 19 01 	sts	0x0119, r23
     a08:	8f 2d       	mov	r24, r15
     a0a:	92 cf       	rjmp	.-220    	; 0x930
     a0c:	40 91 14 01 	lds	r20, 0x0114
     a10:	80 e8       	ldi	r24, 0x80	; 128
     a12:	90 e0       	ldi	r25, 0x00	; 0
     a14:	04 2e       	mov	r0, r20
     a16:	02 c0       	rjmp	.+4      	; 0xa1c
     a18:	95 95       	asr	r25
     a1a:	87 95       	ror	r24
     a1c:	0a 94       	dec	r0
     a1e:	e2 f7       	brpl	.-8      	; 0xa18
     a20:	10 91 1b 01 	lds	r17, 0x011B
     a24:	18 2b       	or	r17, r24
     a26:	10 93 1b 01 	sts	0x011B, r17
     a2a:	84 2f       	mov	r24, r20
     a2c:	66 cf       	rjmp	.-308    	; 0x8fa
     a2e:	c0 91 13 01 	lds	r28, 0x0113
     a32:	80 e8       	ldi	r24, 0x80	; 128
     a34:	90 e0       	ldi	r25, 0x00	; 0
     a36:	0c 2e       	mov	r0, r28
     a38:	02 c0       	rjmp	.+4      	; 0xa3e
     a3a:	95 95       	asr	r25
     a3c:	87 95       	ror	r24
     a3e:	0a 94       	dec	r0
     a40:	e2 f7       	brpl	.-8      	; 0xa3a
     a42:	e0 91 1a 01 	lds	r30, 0x011A
     a46:	e8 2b       	or	r30, r24
     a48:	e0 93 1a 01 	sts	0x011A, r30
     a4c:	8c 2f       	mov	r24, r28
     a4e:	39 cf       	rjmp	.-398    	; 0x8c2
     a50:	e0 90 15 01 	lds	r14, 0x0115
     a54:	80 e8       	ldi	r24, 0x80	; 128
     a56:	90 e0       	ldi	r25, 0x00	; 0
     a58:	0e 2c       	mov	r0, r14
     a5a:	02 c0       	rjmp	.+4      	; 0xa60
     a5c:	95 95       	asr	r25
     a5e:	87 95       	ror	r24
     a60:	0a 94       	dec	r0
     a62:	e2 f7       	brpl	.-8      	; 0xa5c
     a64:	60 91 1c 01 	lds	r22, 0x011C
     a68:	68 2b       	or	r22, r24
     a6a:	60 93 1c 01 	sts	0x011C, r22
     a6e:	8e 2d       	mov	r24, r14
     a70:	0c cf       	rjmp	.-488    	; 0x88a
		}
	//Cleanup and Reset
		out_direction = 0x00;			
     a72:	10 92 1f 01 	sts	0x011F, r1
     a76:	cf 91       	pop	r28
     a78:	1f 91       	pop	r17
     a7a:	ff 90       	pop	r15
     a7c:	ef 90       	pop	r14
     a7e:	08 95       	ret

00000a80 <init_i2c_buffer>:
//no protection is provided for buffer overflow! Be carefull!


void init_i2c_buffer(void){
	i2c_head = 0;
     a80:	10 92 2e 01 	sts	0x012E, r1
	i2c_tail = 0;
     a84:	10 92 2d 01 	sts	0x012D, r1
     a88:	08 95       	ret

00000a8a <init_i2c_ibuffer>:
}

inline uint8_t i2c_count(void){
	if (i2c_head >= i2c_tail){	
		return (i2c_head - i2c_tail);
	}
	else {
		return ((MAX_BUFFER_LEN-i2c_tail)+i2c_head);
	}
}

inline void i2c_enqueue(uint8_t datain){
	i2c_buffer[i2c_head] = datain;
	i2c_head++;
	if (i2c_head >= MAX_BUFFER_LEN){
		i2c_head = 0;
	}
}

inline uint8_t i2c_dequeue(void){
	uint8_t oldtail;
	oldtail = i2c_tail;
	i2c_tail++;
	if (i2c_tail >= MAX_BUFFER_LEN){
		i2c_tail = 0;
	}
	return i2c_buffer[oldtail];
}

//----------------------------------------------------------------
//- I2C INCOMING DATA QUEUE
//----------------------------------------------------------------

//insert from head
//read from tail
//the goal is to be fast (very fast) and light
//no protection is provided for buffer overflow! Be carefull!


void init_i2c_ibuffer(void){
	i2c_ihead = 0;
     a8a:	10 92 2c 01 	sts	0x012C, r1
	i2c_itail = 0;
     a8e:	10 92 20 01 	sts	0x0120, r1
     a92:	08 95       	ret

00000a94 <init_I2C>:
     a94:	40 e2       	ldi	r20, 0x20	; 32
     a96:	40 93 b8 00 	sts	0x00B8, r20
     a9a:	35 e4       	ldi	r19, 0x45	; 69
     a9c:	30 93 bc 00 	sts	0x00BC, r19
     aa0:	22 e5       	ldi	r18, 0x52	; 82
     aa2:	20 93 ba 00 	sts	0x00BA, r18
     aa6:	10 92 bd 00 	sts	0x00BD, r1
     aaa:	44 98       	cbi	0x08, 4	; 8
     aac:	45 98       	cbi	0x08, 5	; 8
     aae:	10 92 2e 01 	sts	0x012E, r1
     ab2:	10 92 2d 01 	sts	0x012D, r1
     ab6:	10 92 2c 01 	sts	0x012C, r1
     aba:	10 92 20 01 	sts	0x0120, r1
     abe:	81 e0       	ldi	r24, 0x01	; 1
     ac0:	80 93 21 01 	sts	0x0121, r24
     ac4:	08 95       	ret

00000ac6 <i2c_count>:
     ac6:	90 91 2e 01 	lds	r25, 0x012E
     aca:	80 91 2d 01 	lds	r24, 0x012D
     ace:	98 17       	cp	r25, r24
     ad0:	38 f0       	brcs	.+14     	; 0xae0
     ad2:	80 91 2e 01 	lds	r24, 0x012E
     ad6:	20 91 2d 01 	lds	r18, 0x012D
     ada:	82 1b       	sub	r24, r18
     adc:	99 27       	eor	r25, r25
     ade:	08 95       	ret
     ae0:	80 91 2e 01 	lds	r24, 0x012E
     ae4:	30 91 2d 01 	lds	r19, 0x012D
     ae8:	83 1b       	sub	r24, r19
     aea:	86 50       	subi	r24, 0x06	; 6
     aec:	99 27       	eor	r25, r25
     aee:	08 95       	ret
     af0:	08 95       	ret

00000af2 <i2c_enqueue>:
     af2:	30 91 2e 01 	lds	r19, 0x012E
     af6:	e3 2f       	mov	r30, r19
     af8:	ff 27       	eor	r31, r31
     afa:	e1 5d       	subi	r30, 0xD1	; 209
     afc:	fe 4f       	sbci	r31, 0xFE	; 254
     afe:	80 83       	st	Z, r24
     b00:	20 91 2e 01 	lds	r18, 0x012E
     b04:	2f 5f       	subi	r18, 0xFF	; 255
     b06:	20 93 2e 01 	sts	0x012E, r18
     b0a:	80 91 2e 01 	lds	r24, 0x012E
     b0e:	8a 3f       	cpi	r24, 0xFA	; 250
     b10:	10 f0       	brcs	.+4      	; 0xb16
     b12:	10 92 2e 01 	sts	0x012E, r1
     b16:	08 95       	ret
     b18:	08 95       	ret

00000b1a <i2c_dequeue>:
     b1a:	e0 91 2d 01 	lds	r30, 0x012D
     b1e:	20 91 2d 01 	lds	r18, 0x012D
     b22:	2f 5f       	subi	r18, 0xFF	; 255
     b24:	20 93 2d 01 	sts	0x012D, r18
     b28:	80 91 2d 01 	lds	r24, 0x012D
     b2c:	8a 3f       	cpi	r24, 0xFA	; 250
     b2e:	10 f0       	brcs	.+4      	; 0xb34
     b30:	10 92 2d 01 	sts	0x012D, r1
     b34:	ff 27       	eor	r31, r31
     b36:	e1 5d       	subi	r30, 0xD1	; 209
     b38:	fe 4f       	sbci	r31, 0xFE	; 254
     b3a:	80 81       	ld	r24, Z
     b3c:	99 27       	eor	r25, r25
     b3e:	08 95       	ret

00000b40 <i2c_icount>:
}

inline uint8_t i2c_icount(void){
	if (i2c_ihead >= i2c_itail){	
     b40:	90 91 2c 01 	lds	r25, 0x012C
     b44:	80 91 20 01 	lds	r24, 0x0120
     b48:	98 17       	cp	r25, r24
     b4a:	38 f0       	brcs	.+14     	; 0xb5a
		return (i2c_ihead - i2c_itail);
     b4c:	80 91 2c 01 	lds	r24, 0x012C
     b50:	20 91 20 01 	lds	r18, 0x0120
     b54:	82 1b       	sub	r24, r18
     b56:	99 27       	eor	r25, r25
     b58:	08 95       	ret
	}
	else {
		return ((MAX_IBUFFER_LEN-i2c_itail)+i2c_ihead);
     b5a:	80 91 2c 01 	lds	r24, 0x012C
     b5e:	30 91 20 01 	lds	r19, 0x0120
     b62:	83 1b       	sub	r24, r19
     b64:	86 5f       	subi	r24, 0xF6	; 246
     b66:	99 27       	eor	r25, r25
	}
}
     b68:	08 95       	ret
     b6a:	08 95       	ret

00000b6c <i2c_ienqueue>:

inline void i2c_ienqueue(uint8_t datain){
	i2c_ibuffer[i2c_ihead] = datain;
     b6c:	30 91 2c 01 	lds	r19, 0x012C
     b70:	e3 2f       	mov	r30, r19
     b72:	ff 27       	eor	r31, r31
     b74:	ee 5d       	subi	r30, 0xDE	; 222
     b76:	fe 4f       	sbci	r31, 0xFE	; 254
     b78:	80 83       	st	Z, r24
	i2c_ihead++;
     b7a:	20 91 2c 01 	lds	r18, 0x012C
     b7e:	2f 5f       	subi	r18, 0xFF	; 255
     b80:	20 93 2c 01 	sts	0x012C, r18
	if (i2c_ihead >= MAX_IBUFFER_LEN){
     b84:	80 91 2c 01 	lds	r24, 0x012C
     b88:	8a 30       	cpi	r24, 0x0A	; 10
     b8a:	10 f0       	brcs	.+4      	; 0xb90
		i2c_ihead = 0;
     b8c:	10 92 2c 01 	sts	0x012C, r1
     b90:	08 95       	ret
     b92:	08 95       	ret

00000b94 <i2c_idequeue>:
	}
}

inline uint8_t i2c_idequeue(void){
	uint8_t oldtail;
	oldtail = i2c_itail;
     b94:	e0 91 20 01 	lds	r30, 0x0120
	i2c_itail++;
     b98:	20 91 20 01 	lds	r18, 0x0120
     b9c:	2f 5f       	subi	r18, 0xFF	; 255
     b9e:	20 93 20 01 	sts	0x0120, r18
	if (i2c_itail >= MAX_IBUFFER_LEN){
     ba2:	80 91 20 01 	lds	r24, 0x0120
     ba6:	8a 30       	cpi	r24, 0x0A	; 10
     ba8:	10 f0       	brcs	.+4      	; 0xbae
		i2c_itail = 0;
     baa:	10 92 20 01 	sts	0x0120, r1
	}
	return i2c_ibuffer[oldtail];
     bae:	ff 27       	eor	r31, r31
     bb0:	ee 5d       	subi	r30, 0xDE	; 222
     bb2:	fe 4f       	sbci	r31, 0xFE	; 254
     bb4:	80 81       	ld	r24, Z
}
     bb6:	99 27       	eor	r25, r25
     bb8:	08 95       	ret

00000bba <I2C_send>:


//----------------------------------------------------------------
//- USER ROUTINES
//----------------------------------------------------------------

//sent in this order: ADDR, datain, datain2
inline void I2C_send(){
	//check for logical state is IDLE and stop condition from last attempt has completed transmission
	if (i2c_state == IDLE && ((TWCR & _BV(4)) == 0x00)){ 
     bba:	80 91 21 01 	lds	r24, 0x0121
     bbe:	81 30       	cpi	r24, 0x01	; 1
     bc0:	09 f0       	breq	.+2      	; 0xbc4
     bc2:	08 95       	ret
     bc4:	20 91 bc 00 	lds	r18, 0x00BC
     bc8:	24 fd       	sbrc	r18, 4
     bca:	fb cf       	rjmp	.-10     	; 0xbc2
		//TAKE CONTROL OF BUS	
			i2c_state = BUSY;
     bcc:	42 e0       	ldi	r20, 0x02	; 2
     bce:	40 93 21 01 	sts	0x0121, r20
			TWCR = B8(11100101); //send START on bus
     bd2:	35 ee       	ldi	r19, 0xE5	; 229
     bd4:	30 93 bc 00 	sts	0x00BC, r19
     bd8:	08 95       	ret
     bda:	08 95       	ret

00000bdc <__vector_24>:
	}	
}

//----------------------------------------------------------------
//- INTERRUPT SERVICE ROUTINES
//----------------------------------------------------------------

// we respond to general call and specific address call the same way
// we only make 1 attempt to receive the intended receiver 
//		located at (IRIS_REPORTING_ADDRESS).
SIGNAL(SIG_TWI){
     bdc:	1f 92       	push	r1
     bde:	0f 92       	push	r0
     be0:	0f b6       	in	r0, 0x3f	; 63
     be2:	0f 92       	push	r0
     be4:	11 24       	eor	r1, r1
     be6:	2f 93       	push	r18
     be8:	3f 93       	push	r19
     bea:	4f 93       	push	r20
     bec:	5f 93       	push	r21
     bee:	6f 93       	push	r22
     bf0:	7f 93       	push	r23
     bf2:	8f 93       	push	r24
     bf4:	9f 93       	push	r25
     bf6:	af 93       	push	r26
     bf8:	bf 93       	push	r27
     bfa:	ef 93       	push	r30
     bfc:	ff 93       	push	r31
	tp6(HIGH); //xxx
     bfe:	82 e0       	ldi	r24, 0x02	; 2
     c00:	0e 94 b4 00 	call	0x168
	/*
	//DEBUG!!!
		send_byte_serial('R');
		UART_send_HEX8(TWSR);
		send_byte_serial(10);
		send_byte_serial(13);
	//END DEBUG!!!
	*/
	
	
	
	//-------------------------
	//- I2C MASTER TRANSMIT
	//-------------------------
	
	if (TWSR == 0x08){
     c04:	80 91 b9 00 	lds	r24, 0x00B9
     c08:	88 30       	cpi	r24, 0x08	; 8
     c0a:	09 f4       	brne	.+2      	; 0xc0e
     c0c:	6e c0       	rjmp	.+220    	; 0xcea
		//finished transmitting a START condition; I am now master of the bus
		//write ADDR+W
		TWDR = ((IRIS_REPORTING_ADDRESS<<1) + WRITE);
		TWCR = B8(11000101);
	}
	
	else if (TWSR == 0x18 || TWSR == 0x28){
     c0e:	20 91 b9 00 	lds	r18, 0x00B9
     c12:	28 31       	cpi	r18, 0x18	; 24
     c14:	09 f4       	brne	.+2      	; 0xc18
     c16:	45 c0       	rjmp	.+138    	; 0xca2
     c18:	30 91 b9 00 	lds	r19, 0x00B9
     c1c:	38 32       	cpi	r19, 0x28	; 40
     c1e:	09 f4       	brne	.+2      	; 0xc22
     c20:	40 c0       	rjmp	.+128    	; 0xca2
		//address or data sent, received ACK
		if (i2c_count() > 0){
			TWDR = i2c_dequeue();
			TWCR = B8(11000101); //transmit the data
		}
		else {
			//although we received ACK we have nothing left to send!
			i2c_state = IDLE;
			TWCR = B8(11010101); //transmit the STOP condition (to release bus)
		}
	}
	
	else if (TWSR == 0x20){
     c22:	b0 91 b9 00 	lds	r27, 0x00B9
     c26:	b0 32       	cpi	r27, 0x20	; 32
     c28:	09 f4       	brne	.+2      	; 0xc2c
     c2a:	a1 c0       	rjmp	.+322    	; 0xd6e
		//address sent, received NACK
		//Throw data away (it will get old)
		if (i2c_count() >= 2){
			if (i2c_count() %2	== 1){
				i2c_dequeue();
			}
			else {
				i2c_dequeue();
				i2c_dequeue();
			}
		}
		//Transmit the STOP condition and release bus
			i2c_state = IDLE;
			TWCR = B8(11010101);			
	}
	else if (TWSR == 0x30){
     c2c:	a0 91 b9 00 	lds	r26, 0x00B9
     c30:	a0 33       	cpi	r26, 0x30	; 48
     c32:	09 f4       	brne	.+2      	; 0xc36
     c34:	6b c0       	rjmp	.+214    	; 0xd0c
		//data sent, received NACK
		
		//Are we finished? Then this is correct!
		if (i2c_count() == 0){
			//Transmit the STOP condition and release bus
			i2c_state = IDLE;
			TWCR = B8(11010101);	
		}
		
		//Error: NACK received, but we still have data to send!
		else {
			if (i2c_count() %2 == 1){
				//error! drop 1 byte to restore alignment
					i2c_dequeue();
			}
			//Transmit the STOP condition and release bus
				i2c_state = IDLE;
				TWCR = B8(11010101);	
		}
	}

	else if (TWSR == 0x38){
     c36:	70 91 b9 00 	lds	r23, 0x00B9
     c3a:	78 33       	cpi	r23, 0x38	; 56
     c3c:	09 f4       	brne	.+2      	; 0xc40
     c3e:	c7 c0       	rjmp	.+398    	; 0xdce
		//lost arbitration, give up!
		i2c_state = IDLE;
		TWCR = B8(11000101);
		
		//******************
		//* WRITE ME SOON!!!
		//******************
		//handle state = 0x68; lost arbitration because other master is talking to ME!!!
	}
	
	
	
	//-------------------------
	//- I2C SLAVE RECEIVE
	//-------------------------
	
	else if (TWSR == 0x60 || TWSR == 0x70){
     c40:	b0 91 b9 00 	lds	r27, 0x00B9
     c44:	b0 36       	cpi	r27, 0x60	; 96
     c46:	59 f1       	breq	.+86     	; 0xc9e
     c48:	e0 91 b9 00 	lds	r30, 0x00B9
     c4c:	e0 37       	cpi	r30, 0x70	; 112
     c4e:	39 f1       	breq	.+78     	; 0xc9e
		//general call or I'm specifically being addressed	
		TWCR = B8(11000101); //receive and ACK (commands are always 2-bytes fixed)
	}
	else if (TWSR == 0x80 || TWSR == 0x90){
     c50:	f0 91 b9 00 	lds	r31, 0x00B9
     c54:	f0 38       	cpi	r31, 0x80	; 128
     c56:	09 f4       	brne	.+2      	; 0xc5a
     c58:	d1 c0       	rjmp	.+418    	; 0xdfc
     c5a:	20 91 b9 00 	lds	r18, 0x00B9
     c5e:	20 39       	cpi	r18, 0x90	; 144
     c60:	09 f4       	brne	.+2      	; 0xc64
     c62:	cc c0       	rjmp	.+408    	; 0xdfc
		//received first byte	
		i2c_ienqueue(TWDR);
		//NACK incoming second byte to signal end of command
		TWCR = B8(10000101); //receive and NACK (commands are always 2-bytes fixed)
	}
	else if (TWSR == 0x88 || TWSR == 0x98){
     c64:	50 91 b9 00 	lds	r21, 0x00B9
     c68:	58 38       	cpi	r21, 0x88	; 136
     c6a:	29 f0       	breq	.+10     	; 0xc76
     c6c:	60 91 b9 00 	lds	r22, 0x00B9
     c70:	68 39       	cpi	r22, 0x98	; 152
     c72:	09 f0       	breq	.+2      	; 0xc76
     c74:	46 c0       	rjmp	.+140    	; 0xd02
     c76:	b0 91 bb 00 	lds	r27, 0x00BB
     c7a:	20 91 2c 01 	lds	r18, 0x012C
     c7e:	e2 2f       	mov	r30, r18
     c80:	ff 27       	eor	r31, r31
     c82:	ee 5d       	subi	r30, 0xDE	; 222
     c84:	fe 4f       	sbci	r31, 0xFE	; 254
     c86:	b0 83       	st	Z, r27
     c88:	a0 91 2c 01 	lds	r26, 0x012C
     c8c:	af 5f       	subi	r26, 0xFF	; 255
     c8e:	a0 93 2c 01 	sts	0x012C, r26
     c92:	70 91 2c 01 	lds	r23, 0x012C
     c96:	7a 30       	cpi	r23, 0x0A	; 10
     c98:	10 f0       	brcs	.+4      	; 0xc9e
     c9a:	10 92 2c 01 	sts	0x012C, r1
     c9e:	85 ec       	ldi	r24, 0xC5	; 197
     ca0:	ca c0       	rjmp	.+404    	; 0xe36
     ca2:	90 91 2e 01 	lds	r25, 0x012E
     ca6:	40 91 2d 01 	lds	r20, 0x012D
     caa:	94 17       	cp	r25, r20
     cac:	10 f5       	brcc	.+68     	; 0xcf2
     cae:	80 91 2e 01 	lds	r24, 0x012E
     cb2:	60 91 2d 01 	lds	r22, 0x012D
     cb6:	86 1b       	sub	r24, r22
     cb8:	86 50       	subi	r24, 0x06	; 6
     cba:	99 27       	eor	r25, r25
     cbc:	88 23       	and	r24, r24
     cbe:	09 f1       	breq	.+66     	; 0xd02
     cc0:	e0 91 2d 01 	lds	r30, 0x012D
     cc4:	a0 91 2d 01 	lds	r26, 0x012D
     cc8:	af 5f       	subi	r26, 0xFF	; 255
     cca:	a0 93 2d 01 	sts	0x012D, r26
     cce:	70 91 2d 01 	lds	r23, 0x012D
     cd2:	7a 3f       	cpi	r23, 0xFA	; 250
     cd4:	10 f0       	brcs	.+4      	; 0xcda
     cd6:	10 92 2d 01 	sts	0x012D, r1
     cda:	ff 27       	eor	r31, r31
     cdc:	e1 5d       	subi	r30, 0xD1	; 209
     cde:	fe 4f       	sbci	r31, 0xFE	; 254
     ce0:	80 81       	ld	r24, Z
     ce2:	99 27       	eor	r25, r25
     ce4:	80 93 bb 00 	sts	0x00BB, r24
     ce8:	da cf       	rjmp	.-76     	; 0xc9e
     cea:	80 e6       	ldi	r24, 0x60	; 96
     cec:	80 93 bb 00 	sts	0x00BB, r24
     cf0:	d6 cf       	rjmp	.-84     	; 0xc9e
     cf2:	80 91 2e 01 	lds	r24, 0x012E
     cf6:	50 91 2d 01 	lds	r21, 0x012D
     cfa:	85 1b       	sub	r24, r21
     cfc:	99 27       	eor	r25, r25
     cfe:	88 23       	and	r24, r24
     d00:	f9 f6       	brne	.-66     	; 0xcc0
		//receive second byte
		i2c_ienqueue(TWDR);
		//switch to the no-longer addressed slave mode (waiting on new bus transfer to address me)
		TWCR = B8(11000101);
	}
	else {
		//if error or unrecognized bus condition, abort current transfer and await next packet
		//switch to the no-longer addressed slave mode (waiting on new bus transfer to address me)
		i2c_state = IDLE;
     d02:	f1 e0       	ldi	r31, 0x01	; 1
     d04:	f0 93 21 01 	sts	0x0121, r31
		TWCR = B8(11010101);
     d08:	85 ed       	ldi	r24, 0xD5	; 213
     d0a:	95 c0       	rjmp	.+298    	; 0xe36
     d0c:	e0 91 2e 01 	lds	r30, 0x012E
     d10:	b0 91 2d 01 	lds	r27, 0x012D
     d14:	eb 17       	cp	r30, r27
     d16:	08 f0       	brcs	.+2      	; 0xd1a
     d18:	65 c0       	rjmp	.+202    	; 0xde4
     d1a:	80 91 2e 01 	lds	r24, 0x012E
     d1e:	20 91 2d 01 	lds	r18, 0x012D
     d22:	82 1b       	sub	r24, r18
     d24:	86 50       	subi	r24, 0x06	; 6
     d26:	99 27       	eor	r25, r25
     d28:	88 23       	and	r24, r24
     d2a:	59 f3       	breq	.-42     	; 0xd02
     d2c:	80 91 2e 01 	lds	r24, 0x012E
     d30:	30 91 2d 01 	lds	r19, 0x012D
     d34:	83 17       	cp	r24, r19
     d36:	08 f4       	brcc	.+2      	; 0xd3a
     d38:	77 c0       	rjmp	.+238    	; 0xe28
     d3a:	80 91 2e 01 	lds	r24, 0x012E
     d3e:	40 91 2d 01 	lds	r20, 0x012D
     d42:	84 1b       	sub	r24, r20
     d44:	99 27       	eor	r25, r25
     d46:	80 ff       	sbrs	r24, 0
     d48:	dc cf       	rjmp	.-72     	; 0xd02
     d4a:	e0 91 2d 01 	lds	r30, 0x012D
     d4e:	60 91 2d 01 	lds	r22, 0x012D
     d52:	6f 5f       	subi	r22, 0xFF	; 255
     d54:	60 93 2d 01 	sts	0x012D, r22
     d58:	50 91 2d 01 	lds	r21, 0x012D
     d5c:	5a 3f       	cpi	r21, 0xFA	; 250
     d5e:	10 f0       	brcs	.+4      	; 0xd64
     d60:	10 92 2d 01 	sts	0x012D, r1
     d64:	ff 27       	eor	r31, r31
     d66:	e1 5d       	subi	r30, 0xD1	; 209
     d68:	fe 4f       	sbci	r31, 0xFE	; 254
     d6a:	80 81       	ld	r24, Z
     d6c:	ca cf       	rjmp	.-108    	; 0xd02
     d6e:	f0 91 2e 01 	lds	r31, 0x012E
     d72:	e0 91 2d 01 	lds	r30, 0x012D
     d76:	fe 17       	cp	r31, r30
     d78:	70 f1       	brcs	.+92     	; 0xdd6
     d7a:	80 91 2e 01 	lds	r24, 0x012E
     d7e:	20 91 2d 01 	lds	r18, 0x012D
     d82:	82 1b       	sub	r24, r18
     d84:	99 27       	eor	r25, r25
     d86:	82 30       	cpi	r24, 0x02	; 2
     d88:	08 f4       	brcc	.+2      	; 0xd8c
     d8a:	bb cf       	rjmp	.-138    	; 0xd02
     d8c:	40 91 2e 01 	lds	r20, 0x012E
     d90:	80 91 2d 01 	lds	r24, 0x012D
     d94:	48 17       	cp	r20, r24
     d96:	60 f5       	brcc	.+88     	; 0xdf0
     d98:	80 91 2e 01 	lds	r24, 0x012E
     d9c:	50 91 2d 01 	lds	r21, 0x012D
     da0:	85 1b       	sub	r24, r21
     da2:	86 50       	subi	r24, 0x06	; 6
     da4:	99 27       	eor	r25, r25
     da6:	80 fd       	sbrc	r24, 0
     da8:	d0 cf       	rjmp	.-96     	; 0xd4a
     daa:	e0 91 2d 01 	lds	r30, 0x012D
     dae:	70 91 2d 01 	lds	r23, 0x012D
     db2:	7f 5f       	subi	r23, 0xFF	; 255
     db4:	70 93 2d 01 	sts	0x012D, r23
     db8:	60 91 2d 01 	lds	r22, 0x012D
     dbc:	6a 3f       	cpi	r22, 0xFA	; 250
     dbe:	10 f0       	brcs	.+4      	; 0xdc4
     dc0:	10 92 2d 01 	sts	0x012D, r1
     dc4:	ff 27       	eor	r31, r31
     dc6:	e1 5d       	subi	r30, 0xD1	; 209
     dc8:	fe 4f       	sbci	r31, 0xFE	; 254
     dca:	80 81       	ld	r24, Z
     dcc:	be cf       	rjmp	.-132    	; 0xd4a
     dce:	a1 e0       	ldi	r26, 0x01	; 1
     dd0:	a0 93 21 01 	sts	0x0121, r26
     dd4:	64 cf       	rjmp	.-312    	; 0xc9e
     dd6:	80 91 2e 01 	lds	r24, 0x012E
     dda:	30 91 2d 01 	lds	r19, 0x012D
     dde:	83 1b       	sub	r24, r19
     de0:	86 50       	subi	r24, 0x06	; 6
     de2:	d0 cf       	rjmp	.-96     	; 0xd84
     de4:	80 91 2e 01 	lds	r24, 0x012E
     de8:	f0 91 2d 01 	lds	r31, 0x012D
     dec:	8f 1b       	sub	r24, r31
     dee:	9b cf       	rjmp	.-202    	; 0xd26
     df0:	80 91 2e 01 	lds	r24, 0x012E
     df4:	90 91 2d 01 	lds	r25, 0x012D
     df8:	89 1b       	sub	r24, r25
     dfa:	d4 cf       	rjmp	.-88     	; 0xda4
     dfc:	40 91 bb 00 	lds	r20, 0x00BB
     e00:	90 91 2c 01 	lds	r25, 0x012C
     e04:	e9 2f       	mov	r30, r25
     e06:	ff 27       	eor	r31, r31
     e08:	ee 5d       	subi	r30, 0xDE	; 222
     e0a:	fe 4f       	sbci	r31, 0xFE	; 254
     e0c:	40 83       	st	Z, r20
     e0e:	80 91 2c 01 	lds	r24, 0x012C
     e12:	8f 5f       	subi	r24, 0xFF	; 255
     e14:	80 93 2c 01 	sts	0x012C, r24
     e18:	30 91 2c 01 	lds	r19, 0x012C
     e1c:	3a 30       	cpi	r19, 0x0A	; 10
     e1e:	10 f0       	brcs	.+4      	; 0xe24
     e20:	10 92 2c 01 	sts	0x012C, r1
     e24:	85 e8       	ldi	r24, 0x85	; 133
     e26:	07 c0       	rjmp	.+14     	; 0xe36
     e28:	80 91 2e 01 	lds	r24, 0x012E
     e2c:	90 91 2d 01 	lds	r25, 0x012D
     e30:	89 1b       	sub	r24, r25
     e32:	86 50       	subi	r24, 0x06	; 6
     e34:	87 cf       	rjmp	.-242    	; 0xd44
     e36:	80 93 bc 00 	sts	0x00BC, r24
	}	
	
	tp6(LOW); //xxx
     e3a:	84 e0       	ldi	r24, 0x04	; 4
     e3c:	0e 94 b4 00 	call	0x168
     e40:	ff 91       	pop	r31
     e42:	ef 91       	pop	r30
     e44:	bf 91       	pop	r27
     e46:	af 91       	pop	r26
     e48:	9f 91       	pop	r25
     e4a:	8f 91       	pop	r24
     e4c:	7f 91       	pop	r23
     e4e:	6f 91       	pop	r22
     e50:	5f 91       	pop	r21
     e52:	4f 91       	pop	r20
     e54:	3f 91       	pop	r19
     e56:	2f 91       	pop	r18
     e58:	0f 90       	pop	r0
     e5a:	0f be       	out	0x3f, r0	; 63
     e5c:	0f 90       	pop	r0
     e5e:	1f 90       	pop	r1
     e60:	18 95       	reti

00000e62 <init_serial>:
//= IRIS LOWER PROCESSOR
//==================================

void init_serial(uint8_t mode){
	switch (mode){
     e62:	8d 30       	cpi	r24, 0x0D	; 13
     e64:	89 f0       	breq	.+34     	; 0xe88
		case(RUN_MODE):
			// USRT initialization (RX ONLY)
			UCSR0A=0x02;//just flags in this register; Double-speed mode ON!
			UCSR0C=B8(00000110);//ASYNCHRONOUS; N,8-bit data,1 frame format; Clock polarity = data delta on rising, sample on falling edge
			UBRR0H=0x00;
			UBRR0L=0; //ignored since we are synchronous receiver (use clock rate from master)
			sbi(DDRD,1); //TXD is output pin (data line)
			cbi(DDRD,0); //RXD is input pin (data line)
			cbi(DDRD,4); //XCK is INPUT pin (USRT clock line)
			usrt_rx_count = 0;
			UCSR0B=B8(10010000);//Rx enabled; interrupt on RX enabled; no TX  - last line because operation begins on this flag		
			break;
		case(DEBUG_MODE):	
		default:
			// UART initialization (TX ONLY)
			UCSR0A=0x00;//just flags in this register
     e66:	10 92 c0 00 	sts	0x00C0, r1
			UCSR0C=B8(01000110);//SYNCHRONOUS (but ignore clock line because less error at BRG); N,8-bit data,1 frame format
     e6a:	46 e4       	ldi	r20, 0x46	; 70
     e6c:	40 93 c2 00 	sts	0x00C2, r20
			UBRR0H = 0;
     e70:	10 92 c5 00 	sts	0x00C5, r1
			UBRR0L = 68; //115.2k bps from 16MHz clock
     e74:	34 e4       	ldi	r19, 0x44	; 68
     e76:	30 93 c4 00 	sts	0x00C4, r19
			sbi(DDRD,1); //TXD is output pin (data line)
     e7a:	51 9a       	sbi	0x0a, 1	; 10
			cbi(DDRD,4); //XCK is not used so make input (with pull-up) for safety (USRT clock line)
     e7c:	54 98       	cbi	0x0a, 4	; 10
			sbi(PORTD, 4);
     e7e:	5c 9a       	sbi	0x0b, 4	; 11
			UCSR0B=0x08;//No Rx; TX enabled - last line because operation begins on this flag
     e80:	88 e0       	ldi	r24, 0x08	; 8
     e82:	80 93 c1 00 	sts	0x00C1, r24
     e86:	08 95       	ret
     e88:	22 e0       	ldi	r18, 0x02	; 2
     e8a:	20 93 c0 00 	sts	0x00C0, r18
     e8e:	86 e0       	ldi	r24, 0x06	; 6
     e90:	80 93 c2 00 	sts	0x00C2, r24
     e94:	10 92 c5 00 	sts	0x00C5, r1
     e98:	10 92 c4 00 	sts	0x00C4, r1
     e9c:	51 9a       	sbi	0x0a, 1	; 10
     e9e:	50 98       	cbi	0x0a, 0	; 10
     ea0:	54 98       	cbi	0x0a, 4	; 10
     ea2:	10 92 29 02 	sts	0x0229, r1
     ea6:	80 e9       	ldi	r24, 0x90	; 144
     ea8:	80 93 c1 00 	sts	0x00C1, r24
     eac:	08 95       	ret
     eae:	08 95       	ret

00000eb0 <USRT_send_2bytes>:
			break;
	}
}

//dataA is sent first
//this function built for speed, no safety checking. UART shift and buffer registers should be empty.
//The first write falls through to the actual output register freeing the buffer for byte 2.
void inline USRT_send_2bytes(unsigned char dataA, unsigned char dataB){
	// XXX
	UDR0 = dataA;
     eb0:	80 93 c6 00 	sts	0x00C6, r24
	UDR0 = dataB;
     eb4:	60 93 c6 00 	sts	0x00C6, r22
     eb8:	08 95       	ret

00000eba <send_byte_serial>:
	/*
	//DEBUG code to test the buffer ready for new data flag
	if(UCSR0A & B8(00100000)){ //true != 0, freeze on buffer avail
		stk_ledon(0xAA);
		while(1);
	}
	*/
}

void inline send_byte_serial(unsigned char dataB){
     eba:	48 2f       	mov	r20, r24
     ebc:	21 e0       	ldi	r18, 0x01	; 1
     ebe:	30 e0       	ldi	r19, 0x00	; 0
	while ((UCSR0A & _BV(5)) != B8(00100000));
     ec0:	80 91 c0 00 	lds	r24, 0x00C0
     ec4:	99 27       	eor	r25, r25
     ec6:	96 95       	lsr	r25
     ec8:	87 95       	ror	r24
     eca:	92 95       	swap	r25
     ecc:	82 95       	swap	r24
     ece:	8f 70       	andi	r24, 0x0F	; 15
     ed0:	89 27       	eor	r24, r25
     ed2:	9f 70       	andi	r25, 0x0F	; 15
     ed4:	89 27       	eor	r24, r25
     ed6:	81 70       	andi	r24, 0x01	; 1
     ed8:	90 70       	andi	r25, 0x00	; 0
     eda:	82 17       	cp	r24, r18
     edc:	93 07       	cpc	r25, r19
     ede:	81 f7       	brne	.-32     	; 0xec0
	UDR0 = dataB;
     ee0:	40 93 c6 00 	sts	0x00C6, r20
     ee4:	08 95       	ret

00000ee6 <uart0_force_byte>:
}

void inline uart0_force_byte(unsigned char dataB){
	UDR0 = dataB;
     ee6:	80 93 c6 00 	sts	0x00C6, r24
     eea:	08 95       	ret

00000eec <UART_send_BIN4>:
}

//Most Significant Bit first
void UART_send_BIN4(uint8_t lowb){
	switch(lowb){
     eec:	99 27       	eor	r25, r25
     eee:	87 30       	cpi	r24, 0x07	; 7
     ef0:	91 05       	cpc	r25, r1
     ef2:	09 f4       	brne	.+2      	; 0xef6
     ef4:	cb c0       	rjmp	.+406    	; 0x108c
     ef6:	88 30       	cpi	r24, 0x08	; 8
     ef8:	91 05       	cpc	r25, r1
     efa:	0c f0       	brlt	.+2      	; 0xefe
     efc:	65 c0       	rjmp	.+202    	; 0xfc8
     efe:	83 30       	cpi	r24, 0x03	; 3
     f00:	91 05       	cpc	r25, r1
     f02:	09 f4       	brne	.+2      	; 0xf06
     f04:	d4 c1       	rjmp	.+936    	; 0x12ae
     f06:	84 30       	cpi	r24, 0x04	; 4
     f08:	91 05       	cpc	r25, r1
     f0a:	0c f0       	brlt	.+2      	; 0xf0e
     f0c:	14 c1       	rjmp	.+552    	; 0x1136
     f0e:	81 30       	cpi	r24, 0x01	; 1
     f10:	91 05       	cpc	r25, r1
     f12:	09 f4       	brne	.+2      	; 0xf16
     f14:	6c c3       	rjmp	.+1752   	; 0x15ee
     f16:	82 30       	cpi	r24, 0x02	; 2
     f18:	91 05       	cpc	r25, r1
     f1a:	0c f4       	brge	.+2      	; 0xf1e
     f1c:	ae c4       	rjmp	.+2396   	; 0x187a
     f1e:	21 e0       	ldi	r18, 0x01	; 1
     f20:	30 e0       	ldi	r19, 0x00	; 0
     f22:	80 91 c0 00 	lds	r24, 0x00C0
     f26:	99 27       	eor	r25, r25
     f28:	96 95       	lsr	r25
     f2a:	87 95       	ror	r24
     f2c:	92 95       	swap	r25
     f2e:	82 95       	swap	r24
     f30:	8f 70       	andi	r24, 0x0F	; 15
     f32:	89 27       	eor	r24, r25
     f34:	9f 70       	andi	r25, 0x0F	; 15
     f36:	89 27       	eor	r24, r25
     f38:	81 70       	andi	r24, 0x01	; 1
     f3a:	90 70       	andi	r25, 0x00	; 0
     f3c:	82 17       	cp	r24, r18
     f3e:	93 07       	cpc	r25, r19
     f40:	81 f7       	brne	.-32     	; 0xf22
     f42:	70 e3       	ldi	r23, 0x30	; 48
     f44:	70 93 c6 00 	sts	0x00C6, r23
     f48:	21 e0       	ldi	r18, 0x01	; 1
     f4a:	30 e0       	ldi	r19, 0x00	; 0
     f4c:	80 91 c0 00 	lds	r24, 0x00C0
     f50:	99 27       	eor	r25, r25
     f52:	96 95       	lsr	r25
     f54:	87 95       	ror	r24
     f56:	92 95       	swap	r25
     f58:	82 95       	swap	r24
     f5a:	8f 70       	andi	r24, 0x0F	; 15
     f5c:	89 27       	eor	r24, r25
     f5e:	9f 70       	andi	r25, 0x0F	; 15
     f60:	89 27       	eor	r24, r25
     f62:	81 70       	andi	r24, 0x01	; 1
     f64:	90 70       	andi	r25, 0x00	; 0
     f66:	82 17       	cp	r24, r18
     f68:	93 07       	cpc	r25, r19
     f6a:	81 f7       	brne	.-32     	; 0xf4c
     f6c:	90 e3       	ldi	r25, 0x30	; 48
     f6e:	90 93 c6 00 	sts	0x00C6, r25
     f72:	21 e0       	ldi	r18, 0x01	; 1
     f74:	30 e0       	ldi	r19, 0x00	; 0
     f76:	80 91 c0 00 	lds	r24, 0x00C0
     f7a:	99 27       	eor	r25, r25
     f7c:	96 95       	lsr	r25
     f7e:	87 95       	ror	r24
     f80:	92 95       	swap	r25
     f82:	82 95       	swap	r24
     f84:	8f 70       	andi	r24, 0x0F	; 15
     f86:	89 27       	eor	r24, r25
     f88:	9f 70       	andi	r25, 0x0F	; 15
     f8a:	89 27       	eor	r24, r25
     f8c:	81 70       	andi	r24, 0x01	; 1
     f8e:	90 70       	andi	r25, 0x00	; 0
     f90:	82 17       	cp	r24, r18
     f92:	93 07       	cpc	r25, r19
     f94:	81 f7       	brne	.-32     	; 0xf76
     f96:	a1 e3       	ldi	r26, 0x31	; 49
     f98:	a0 93 c6 00 	sts	0x00C6, r26
     f9c:	21 e0       	ldi	r18, 0x01	; 1
     f9e:	30 e0       	ldi	r19, 0x00	; 0
     fa0:	80 91 c0 00 	lds	r24, 0x00C0
     fa4:	99 27       	eor	r25, r25
     fa6:	96 95       	lsr	r25
     fa8:	87 95       	ror	r24
     faa:	92 95       	swap	r25
     fac:	82 95       	swap	r24
     fae:	8f 70       	andi	r24, 0x0F	; 15
     fb0:	89 27       	eor	r24, r25
     fb2:	9f 70       	andi	r25, 0x0F	; 15
     fb4:	89 27       	eor	r24, r25
     fb6:	81 70       	andi	r24, 0x01	; 1
     fb8:	90 70       	andi	r25, 0x00	; 0
     fba:	82 17       	cp	r24, r18
     fbc:	93 07       	cpc	r25, r19
     fbe:	81 f7       	brne	.-32     	; 0xfa0
     fc0:	80 e3       	ldi	r24, 0x30	; 48
     fc2:	80 93 c6 00 	sts	0x00C6, r24
     fc6:	08 95       	ret
     fc8:	8b 30       	cpi	r24, 0x0B	; 11
     fca:	91 05       	cpc	r25, r1
     fcc:	09 f4       	brne	.+2      	; 0xfd0
     fce:	1d c1       	rjmp	.+570    	; 0x120a
     fd0:	8c 30       	cpi	r24, 0x0C	; 12
     fd2:	91 05       	cpc	r25, r1
     fd4:	0c f0       	brlt	.+2      	; 0xfd8
     fd6:	09 c1       	rjmp	.+530    	; 0x11ea
     fd8:	89 30       	cpi	r24, 0x09	; 9
     fda:	91 05       	cpc	r25, r1
     fdc:	09 f4       	brne	.+2      	; 0xfe0
     fde:	57 c3       	rjmp	.+1710   	; 0x168e
     fe0:	0a 97       	sbiw	r24, 0x0a	; 10
     fe2:	0c f0       	brlt	.+2      	; 0xfe6
     fe4:	b6 c1       	rjmp	.+876    	; 0x1352
     fe6:	21 e0       	ldi	r18, 0x01	; 1
     fe8:	30 e0       	ldi	r19, 0x00	; 0
     fea:	80 91 c0 00 	lds	r24, 0x00C0
     fee:	99 27       	eor	r25, r25
     ff0:	96 95       	lsr	r25
     ff2:	87 95       	ror	r24
     ff4:	92 95       	swap	r25
     ff6:	82 95       	swap	r24
     ff8:	8f 70       	andi	r24, 0x0F	; 15
     ffa:	89 27       	eor	r24, r25
     ffc:	9f 70       	andi	r25, 0x0F	; 15
     ffe:	89 27       	eor	r24, r25
    1000:	81 70       	andi	r24, 0x01	; 1
    1002:	90 70       	andi	r25, 0x00	; 0
    1004:	82 17       	cp	r24, r18
    1006:	93 07       	cpc	r25, r19
    1008:	81 f7       	brne	.-32     	; 0xfea
    100a:	81 e3       	ldi	r24, 0x31	; 49
    100c:	80 93 c6 00 	sts	0x00C6, r24
    1010:	21 e0       	ldi	r18, 0x01	; 1
    1012:	30 e0       	ldi	r19, 0x00	; 0
    1014:	80 91 c0 00 	lds	r24, 0x00C0
    1018:	99 27       	eor	r25, r25
    101a:	96 95       	lsr	r25
    101c:	87 95       	ror	r24
    101e:	92 95       	swap	r25
    1020:	82 95       	swap	r24
    1022:	8f 70       	andi	r24, 0x0F	; 15
    1024:	89 27       	eor	r24, r25
    1026:	9f 70       	andi	r25, 0x0F	; 15
    1028:	89 27       	eor	r24, r25
    102a:	81 70       	andi	r24, 0x01	; 1
    102c:	90 70       	andi	r25, 0x00	; 0
    102e:	82 17       	cp	r24, r18
    1030:	93 07       	cpc	r25, r19
    1032:	81 f7       	brne	.-32     	; 0x1014
    1034:	20 e3       	ldi	r18, 0x30	; 48
    1036:	20 93 c6 00 	sts	0x00C6, r18
    103a:	21 e0       	ldi	r18, 0x01	; 1
    103c:	30 e0       	ldi	r19, 0x00	; 0
    103e:	80 91 c0 00 	lds	r24, 0x00C0
    1042:	99 27       	eor	r25, r25
    1044:	96 95       	lsr	r25
    1046:	87 95       	ror	r24
    1048:	92 95       	swap	r25
    104a:	82 95       	swap	r24
    104c:	8f 70       	andi	r24, 0x0F	; 15
    104e:	89 27       	eor	r24, r25
    1050:	9f 70       	andi	r25, 0x0F	; 15
    1052:	89 27       	eor	r24, r25
    1054:	81 70       	andi	r24, 0x01	; 1
    1056:	90 70       	andi	r25, 0x00	; 0
    1058:	82 17       	cp	r24, r18
    105a:	93 07       	cpc	r25, r19
    105c:	81 f7       	brne	.-32     	; 0x103e
    105e:	30 e3       	ldi	r19, 0x30	; 48
    1060:	30 93 c6 00 	sts	0x00C6, r19
    1064:	21 e0       	ldi	r18, 0x01	; 1
    1066:	30 e0       	ldi	r19, 0x00	; 0
    1068:	80 91 c0 00 	lds	r24, 0x00C0
    106c:	99 27       	eor	r25, r25
    106e:	96 95       	lsr	r25
    1070:	87 95       	ror	r24
    1072:	92 95       	swap	r25
    1074:	82 95       	swap	r24
    1076:	8f 70       	andi	r24, 0x0F	; 15
    1078:	89 27       	eor	r24, r25
    107a:	9f 70       	andi	r25, 0x0F	; 15
    107c:	89 27       	eor	r24, r25
    107e:	81 70       	andi	r24, 0x01	; 1
    1080:	90 70       	andi	r25, 0x00	; 0
    1082:	82 17       	cp	r24, r18
    1084:	93 07       	cpc	r25, r19
    1086:	81 f7       	brne	.-32     	; 0x1068
    1088:	80 e3       	ldi	r24, 0x30	; 48
    108a:	9b cf       	rjmp	.-202    	; 0xfc2
    108c:	21 e0       	ldi	r18, 0x01	; 1
    108e:	30 e0       	ldi	r19, 0x00	; 0
    1090:	80 91 c0 00 	lds	r24, 0x00C0
    1094:	99 27       	eor	r25, r25
    1096:	96 95       	lsr	r25
    1098:	87 95       	ror	r24
    109a:	92 95       	swap	r25
    109c:	82 95       	swap	r24
    109e:	8f 70       	andi	r24, 0x0F	; 15
    10a0:	89 27       	eor	r24, r25
    10a2:	9f 70       	andi	r25, 0x0F	; 15
    10a4:	89 27       	eor	r24, r25
    10a6:	81 70       	andi	r24, 0x01	; 1
    10a8:	90 70       	andi	r25, 0x00	; 0
    10aa:	82 17       	cp	r24, r18
    10ac:	93 07       	cpc	r25, r19
    10ae:	81 f7       	brne	.-32     	; 0x1090
    10b0:	b0 e3       	ldi	r27, 0x30	; 48
    10b2:	b0 93 c6 00 	sts	0x00C6, r27
    10b6:	21 e0       	ldi	r18, 0x01	; 1
    10b8:	30 e0       	ldi	r19, 0x00	; 0
    10ba:	80 91 c0 00 	lds	r24, 0x00C0
    10be:	99 27       	eor	r25, r25
    10c0:	96 95       	lsr	r25
    10c2:	87 95       	ror	r24
    10c4:	92 95       	swap	r25
    10c6:	82 95       	swap	r24
    10c8:	8f 70       	andi	r24, 0x0F	; 15
    10ca:	89 27       	eor	r24, r25
    10cc:	9f 70       	andi	r25, 0x0F	; 15
    10ce:	89 27       	eor	r24, r25
    10d0:	81 70       	andi	r24, 0x01	; 1
    10d2:	90 70       	andi	r25, 0x00	; 0
    10d4:	82 17       	cp	r24, r18
    10d6:	93 07       	cpc	r25, r19
    10d8:	81 f7       	brne	.-32     	; 0x10ba
    10da:	e1 e3       	ldi	r30, 0x31	; 49
    10dc:	e0 93 c6 00 	sts	0x00C6, r30
    10e0:	21 e0       	ldi	r18, 0x01	; 1
    10e2:	30 e0       	ldi	r19, 0x00	; 0
    10e4:	80 91 c0 00 	lds	r24, 0x00C0
    10e8:	99 27       	eor	r25, r25
    10ea:	96 95       	lsr	r25
    10ec:	87 95       	ror	r24
    10ee:	92 95       	swap	r25
    10f0:	82 95       	swap	r24
    10f2:	8f 70       	andi	r24, 0x0F	; 15
    10f4:	89 27       	eor	r24, r25
    10f6:	9f 70       	andi	r25, 0x0F	; 15
    10f8:	89 27       	eor	r24, r25
    10fa:	81 70       	andi	r24, 0x01	; 1
    10fc:	90 70       	andi	r25, 0x00	; 0
    10fe:	82 17       	cp	r24, r18
    1100:	93 07       	cpc	r25, r19
    1102:	81 f7       	brne	.-32     	; 0x10e4
    1104:	f1 e3       	ldi	r31, 0x31	; 49
    1106:	f0 93 c6 00 	sts	0x00C6, r31
    110a:	21 e0       	ldi	r18, 0x01	; 1
    110c:	30 e0       	ldi	r19, 0x00	; 0
    110e:	80 91 c0 00 	lds	r24, 0x00C0
    1112:	99 27       	eor	r25, r25
    1114:	96 95       	lsr	r25
    1116:	87 95       	ror	r24
    1118:	92 95       	swap	r25
    111a:	82 95       	swap	r24
    111c:	8f 70       	andi	r24, 0x0F	; 15
    111e:	89 27       	eor	r24, r25
    1120:	9f 70       	andi	r25, 0x0F	; 15
    1122:	89 27       	eor	r24, r25
    1124:	81 70       	andi	r24, 0x01	; 1
    1126:	90 70       	andi	r25, 0x00	; 0
    1128:	82 17       	cp	r24, r18
    112a:	93 07       	cpc	r25, r19
    112c:	81 f7       	brne	.-32     	; 0x110e
    112e:	81 e3       	ldi	r24, 0x31	; 49
    1130:	80 93 c6 00 	sts	0x00C6, r24
    1134:	08 95       	ret
    1136:	85 30       	cpi	r24, 0x05	; 5
    1138:	91 05       	cpc	r25, r1
    113a:	09 f4       	brne	.+2      	; 0x113e
    113c:	fa c2       	rjmp	.+1524   	; 0x1732
    113e:	06 97       	sbiw	r24, 0x06	; 6
    1140:	0c f0       	brlt	.+2      	; 0x1144
    1142:	ad c1       	rjmp	.+858    	; 0x149e
    1144:	21 e0       	ldi	r18, 0x01	; 1
    1146:	30 e0       	ldi	r19, 0x00	; 0
    1148:	80 91 c0 00 	lds	r24, 0x00C0
    114c:	99 27       	eor	r25, r25
    114e:	96 95       	lsr	r25
    1150:	87 95       	ror	r24
    1152:	92 95       	swap	r25
    1154:	82 95       	swap	r24
    1156:	8f 70       	andi	r24, 0x0F	; 15
    1158:	89 27       	eor	r24, r25
    115a:	9f 70       	andi	r25, 0x0F	; 15
    115c:	89 27       	eor	r24, r25
    115e:	81 70       	andi	r24, 0x01	; 1
    1160:	90 70       	andi	r25, 0x00	; 0
    1162:	82 17       	cp	r24, r18
    1164:	93 07       	cpc	r25, r19
    1166:	81 f7       	brne	.-32     	; 0x1148
    1168:	80 e3       	ldi	r24, 0x30	; 48
    116a:	80 93 c6 00 	sts	0x00C6, r24
    116e:	21 e0       	ldi	r18, 0x01	; 1
    1170:	30 e0       	ldi	r19, 0x00	; 0
    1172:	80 91 c0 00 	lds	r24, 0x00C0
    1176:	99 27       	eor	r25, r25
    1178:	96 95       	lsr	r25
    117a:	87 95       	ror	r24
    117c:	92 95       	swap	r25
    117e:	82 95       	swap	r24
    1180:	8f 70       	andi	r24, 0x0F	; 15
    1182:	89 27       	eor	r24, r25
    1184:	9f 70       	andi	r25, 0x0F	; 15
    1186:	89 27       	eor	r24, r25
    1188:	81 70       	andi	r24, 0x01	; 1
    118a:	90 70       	andi	r25, 0x00	; 0
    118c:	82 17       	cp	r24, r18
    118e:	93 07       	cpc	r25, r19
    1190:	81 f7       	brne	.-32     	; 0x1172
    1192:	21 e3       	ldi	r18, 0x31	; 49
    1194:	20 93 c6 00 	sts	0x00C6, r18
    1198:	21 e0       	ldi	r18, 0x01	; 1
    119a:	30 e0       	ldi	r19, 0x00	; 0
    119c:	80 91 c0 00 	lds	r24, 0x00C0
    11a0:	99 27       	eor	r25, r25
    11a2:	96 95       	lsr	r25
    11a4:	87 95       	ror	r24
    11a6:	92 95       	swap	r25
    11a8:	82 95       	swap	r24
    11aa:	8f 70       	andi	r24, 0x0F	; 15
    11ac:	89 27       	eor	r24, r25
    11ae:	9f 70       	andi	r25, 0x0F	; 15
    11b0:	89 27       	eor	r24, r25
    11b2:	81 70       	andi	r24, 0x01	; 1
    11b4:	90 70       	andi	r25, 0x00	; 0
    11b6:	82 17       	cp	r24, r18
    11b8:	93 07       	cpc	r25, r19
    11ba:	81 f7       	brne	.-32     	; 0x119c
    11bc:	30 e3       	ldi	r19, 0x30	; 48
    11be:	30 93 c6 00 	sts	0x00C6, r19
    11c2:	21 e0       	ldi	r18, 0x01	; 1
    11c4:	30 e0       	ldi	r19, 0x00	; 0
    11c6:	80 91 c0 00 	lds	r24, 0x00C0
    11ca:	99 27       	eor	r25, r25
    11cc:	96 95       	lsr	r25
    11ce:	87 95       	ror	r24
    11d0:	92 95       	swap	r25
    11d2:	82 95       	swap	r24
    11d4:	8f 70       	andi	r24, 0x0F	; 15
    11d6:	89 27       	eor	r24, r25
    11d8:	9f 70       	andi	r25, 0x0F	; 15
    11da:	89 27       	eor	r24, r25
    11dc:	81 70       	andi	r24, 0x01	; 1
    11de:	90 70       	andi	r25, 0x00	; 0
    11e0:	82 17       	cp	r24, r18
    11e2:	93 07       	cpc	r25, r19
    11e4:	81 f7       	brne	.-32     	; 0x11c6
    11e6:	80 e3       	ldi	r24, 0x30	; 48
    11e8:	ec ce       	rjmp	.-552    	; 0xfc2
    11ea:	8d 30       	cpi	r24, 0x0D	; 13
    11ec:	91 05       	cpc	r25, r1
    11ee:	09 f4       	brne	.+2      	; 0x11f2
    11f0:	f2 c2       	rjmp	.+1508   	; 0x17d6
    11f2:	8d 30       	cpi	r24, 0x0D	; 13
    11f4:	91 05       	cpc	r25, r1
    11f6:	0c f4       	brge	.+2      	; 0x11fa
    11f8:	ff c0       	rjmp	.+510    	; 0x13f8
    11fa:	8e 30       	cpi	r24, 0x0E	; 14
    11fc:	91 05       	cpc	r25, r1
    11fe:	09 f4       	brne	.+2      	; 0x1202
    1200:	40 c3       	rjmp	.+1664   	; 0x1882
    1202:	0f 97       	sbiw	r24, 0x0f	; 15
    1204:	09 f4       	brne	.+2      	; 0x1208
    1206:	9e c1       	rjmp	.+828    	; 0x1544
    1208:	08 95       	ret
    120a:	21 e0       	ldi	r18, 0x01	; 1
    120c:	30 e0       	ldi	r19, 0x00	; 0
    120e:	80 91 c0 00 	lds	r24, 0x00C0
    1212:	99 27       	eor	r25, r25
    1214:	96 95       	lsr	r25
    1216:	87 95       	ror	r24
    1218:	92 95       	swap	r25
    121a:	82 95       	swap	r24
    121c:	8f 70       	andi	r24, 0x0F	; 15
    121e:	89 27       	eor	r24, r25
    1220:	9f 70       	andi	r25, 0x0F	; 15
    1222:	89 27       	eor	r24, r25
    1224:	81 70       	andi	r24, 0x01	; 1
    1226:	90 70       	andi	r25, 0x00	; 0
    1228:	82 17       	cp	r24, r18
    122a:	93 07       	cpc	r25, r19
    122c:	81 f7       	brne	.-32     	; 0x120e
    122e:	b1 e3       	ldi	r27, 0x31	; 49
    1230:	b0 93 c6 00 	sts	0x00C6, r27
    1234:	21 e0       	ldi	r18, 0x01	; 1
    1236:	30 e0       	ldi	r19, 0x00	; 0
    1238:	80 91 c0 00 	lds	r24, 0x00C0
    123c:	99 27       	eor	r25, r25
    123e:	96 95       	lsr	r25
    1240:	87 95       	ror	r24
    1242:	92 95       	swap	r25
    1244:	82 95       	swap	r24
    1246:	8f 70       	andi	r24, 0x0F	; 15
    1248:	89 27       	eor	r24, r25
    124a:	9f 70       	andi	r25, 0x0F	; 15
    124c:	89 27       	eor	r24, r25
    124e:	81 70       	andi	r24, 0x01	; 1
    1250:	90 70       	andi	r25, 0x00	; 0
    1252:	82 17       	cp	r24, r18
    1254:	93 07       	cpc	r25, r19
    1256:	81 f7       	brne	.-32     	; 0x1238
    1258:	e0 e3       	ldi	r30, 0x30	; 48
    125a:	e0 93 c6 00 	sts	0x00C6, r30
    125e:	21 e0       	ldi	r18, 0x01	; 1
    1260:	30 e0       	ldi	r19, 0x00	; 0
    1262:	80 91 c0 00 	lds	r24, 0x00C0
    1266:	99 27       	eor	r25, r25
    1268:	96 95       	lsr	r25
    126a:	87 95       	ror	r24
    126c:	92 95       	swap	r25
    126e:	82 95       	swap	r24
    1270:	8f 70       	andi	r24, 0x0F	; 15
    1272:	89 27       	eor	r24, r25
    1274:	9f 70       	andi	r25, 0x0F	; 15
    1276:	89 27       	eor	r24, r25
    1278:	81 70       	andi	r24, 0x01	; 1
    127a:	90 70       	andi	r25, 0x00	; 0
    127c:	82 17       	cp	r24, r18
    127e:	93 07       	cpc	r25, r19
    1280:	81 f7       	brne	.-32     	; 0x1262
    1282:	f1 e3       	ldi	r31, 0x31	; 49
    1284:	f0 93 c6 00 	sts	0x00C6, r31
    1288:	21 e0       	ldi	r18, 0x01	; 1
    128a:	30 e0       	ldi	r19, 0x00	; 0
    128c:	80 91 c0 00 	lds	r24, 0x00C0
    1290:	99 27       	eor	r25, r25
    1292:	96 95       	lsr	r25
    1294:	87 95       	ror	r24
    1296:	92 95       	swap	r25
    1298:	82 95       	swap	r24
    129a:	8f 70       	andi	r24, 0x0F	; 15
    129c:	89 27       	eor	r24, r25
    129e:	9f 70       	andi	r25, 0x0F	; 15
    12a0:	89 27       	eor	r24, r25
    12a2:	81 70       	andi	r24, 0x01	; 1
    12a4:	90 70       	andi	r25, 0x00	; 0
    12a6:	82 17       	cp	r24, r18
    12a8:	93 07       	cpc	r25, r19
    12aa:	81 f7       	brne	.-32     	; 0x128c
    12ac:	40 cf       	rjmp	.-384    	; 0x112e
    12ae:	21 e0       	ldi	r18, 0x01	; 1
    12b0:	30 e0       	ldi	r19, 0x00	; 0
    12b2:	80 91 c0 00 	lds	r24, 0x00C0
    12b6:	99 27       	eor	r25, r25
    12b8:	96 95       	lsr	r25
    12ba:	87 95       	ror	r24
    12bc:	92 95       	swap	r25
    12be:	82 95       	swap	r24
    12c0:	8f 70       	andi	r24, 0x0F	; 15
    12c2:	89 27       	eor	r24, r25
    12c4:	9f 70       	andi	r25, 0x0F	; 15
    12c6:	89 27       	eor	r24, r25
    12c8:	81 70       	andi	r24, 0x01	; 1
    12ca:	90 70       	andi	r25, 0x00	; 0
    12cc:	82 17       	cp	r24, r18
    12ce:	93 07       	cpc	r25, r19
    12d0:	81 f7       	brne	.-32     	; 0x12b2
    12d2:	b0 e3       	ldi	r27, 0x30	; 48
    12d4:	b0 93 c6 00 	sts	0x00C6, r27
    12d8:	21 e0       	ldi	r18, 0x01	; 1
    12da:	30 e0       	ldi	r19, 0x00	; 0
    12dc:	80 91 c0 00 	lds	r24, 0x00C0
    12e0:	99 27       	eor	r25, r25
    12e2:	96 95       	lsr	r25
    12e4:	87 95       	ror	r24
    12e6:	92 95       	swap	r25
    12e8:	82 95       	swap	r24
    12ea:	8f 70       	andi	r24, 0x0F	; 15
    12ec:	89 27       	eor	r24, r25
    12ee:	9f 70       	andi	r25, 0x0F	; 15
    12f0:	89 27       	eor	r24, r25
    12f2:	81 70       	andi	r24, 0x01	; 1
    12f4:	90 70       	andi	r25, 0x00	; 0
    12f6:	82 17       	cp	r24, r18
    12f8:	93 07       	cpc	r25, r19
    12fa:	81 f7       	brne	.-32     	; 0x12dc
    12fc:	e0 e3       	ldi	r30, 0x30	; 48
    12fe:	e0 93 c6 00 	sts	0x00C6, r30
    1302:	21 e0       	ldi	r18, 0x01	; 1
    1304:	30 e0       	ldi	r19, 0x00	; 0
    1306:	80 91 c0 00 	lds	r24, 0x00C0
    130a:	99 27       	eor	r25, r25
    130c:	96 95       	lsr	r25
    130e:	87 95       	ror	r24
    1310:	92 95       	swap	r25
    1312:	82 95       	swap	r24
    1314:	8f 70       	andi	r24, 0x0F	; 15
    1316:	89 27       	eor	r24, r25
    1318:	9f 70       	andi	r25, 0x0F	; 15
    131a:	89 27       	eor	r24, r25
    131c:	81 70       	andi	r24, 0x01	; 1
    131e:	90 70       	andi	r25, 0x00	; 0
    1320:	82 17       	cp	r24, r18
    1322:	93 07       	cpc	r25, r19
    1324:	81 f7       	brne	.-32     	; 0x1306
    1326:	f1 e3       	ldi	r31, 0x31	; 49
    1328:	f0 93 c6 00 	sts	0x00C6, r31
    132c:	21 e0       	ldi	r18, 0x01	; 1
    132e:	30 e0       	ldi	r19, 0x00	; 0
    1330:	80 91 c0 00 	lds	r24, 0x00C0
    1334:	99 27       	eor	r25, r25
    1336:	96 95       	lsr	r25
    1338:	87 95       	ror	r24
    133a:	92 95       	swap	r25
    133c:	82 95       	swap	r24
    133e:	8f 70       	andi	r24, 0x0F	; 15
    1340:	89 27       	eor	r24, r25
    1342:	9f 70       	andi	r25, 0x0F	; 15
    1344:	89 27       	eor	r24, r25
    1346:	81 70       	andi	r24, 0x01	; 1
    1348:	90 70       	andi	r25, 0x00	; 0
    134a:	82 17       	cp	r24, r18
    134c:	93 07       	cpc	r25, r19
    134e:	81 f7       	brne	.-32     	; 0x1330
    1350:	ee ce       	rjmp	.-548    	; 0x112e
    1352:	21 e0       	ldi	r18, 0x01	; 1
    1354:	30 e0       	ldi	r19, 0x00	; 0
    1356:	80 91 c0 00 	lds	r24, 0x00C0
    135a:	99 27       	eor	r25, r25
    135c:	96 95       	lsr	r25
    135e:	87 95       	ror	r24
    1360:	92 95       	swap	r25
    1362:	82 95       	swap	r24
    1364:	8f 70       	andi	r24, 0x0F	; 15
    1366:	89 27       	eor	r24, r25
    1368:	9f 70       	andi	r25, 0x0F	; 15
    136a:	89 27       	eor	r24, r25
    136c:	81 70       	andi	r24, 0x01	; 1
    136e:	90 70       	andi	r25, 0x00	; 0
    1370:	82 17       	cp	r24, r18
    1372:	93 07       	cpc	r25, r19
    1374:	81 f7       	brne	.-32     	; 0x1356
    1376:	71 e3       	ldi	r23, 0x31	; 49
    1378:	70 93 c6 00 	sts	0x00C6, r23
    137c:	21 e0       	ldi	r18, 0x01	; 1
    137e:	30 e0       	ldi	r19, 0x00	; 0
    1380:	80 91 c0 00 	lds	r24, 0x00C0
    1384:	99 27       	eor	r25, r25
    1386:	96 95       	lsr	r25
    1388:	87 95       	ror	r24
    138a:	92 95       	swap	r25
    138c:	82 95       	swap	r24
    138e:	8f 70       	andi	r24, 0x0F	; 15
    1390:	89 27       	eor	r24, r25
    1392:	9f 70       	andi	r25, 0x0F	; 15
    1394:	89 27       	eor	r24, r25
    1396:	81 70       	andi	r24, 0x01	; 1
    1398:	90 70       	andi	r25, 0x00	; 0
    139a:	82 17       	cp	r24, r18
    139c:	93 07       	cpc	r25, r19
    139e:	81 f7       	brne	.-32     	; 0x1380
    13a0:	90 e3       	ldi	r25, 0x30	; 48
    13a2:	90 93 c6 00 	sts	0x00C6, r25
    13a6:	21 e0       	ldi	r18, 0x01	; 1
    13a8:	30 e0       	ldi	r19, 0x00	; 0
    13aa:	80 91 c0 00 	lds	r24, 0x00C0
    13ae:	99 27       	eor	r25, r25
    13b0:	96 95       	lsr	r25
    13b2:	87 95       	ror	r24
    13b4:	92 95       	swap	r25
    13b6:	82 95       	swap	r24
    13b8:	8f 70       	andi	r24, 0x0F	; 15
    13ba:	89 27       	eor	r24, r25
    13bc:	9f 70       	andi	r25, 0x0F	; 15
    13be:	89 27       	eor	r24, r25
    13c0:	81 70       	andi	r24, 0x01	; 1
    13c2:	90 70       	andi	r25, 0x00	; 0
    13c4:	82 17       	cp	r24, r18
    13c6:	93 07       	cpc	r25, r19
    13c8:	81 f7       	brne	.-32     	; 0x13aa
    13ca:	a1 e3       	ldi	r26, 0x31	; 49
    13cc:	a0 93 c6 00 	sts	0x00C6, r26
    13d0:	21 e0       	ldi	r18, 0x01	; 1
    13d2:	30 e0       	ldi	r19, 0x00	; 0
    13d4:	80 91 c0 00 	lds	r24, 0x00C0
    13d8:	99 27       	eor	r25, r25
    13da:	96 95       	lsr	r25
    13dc:	87 95       	ror	r24
    13de:	92 95       	swap	r25
    13e0:	82 95       	swap	r24
    13e2:	8f 70       	andi	r24, 0x0F	; 15
    13e4:	89 27       	eor	r24, r25
    13e6:	9f 70       	andi	r25, 0x0F	; 15
    13e8:	89 27       	eor	r24, r25
    13ea:	81 70       	andi	r24, 0x01	; 1
    13ec:	90 70       	andi	r25, 0x00	; 0
    13ee:	82 17       	cp	r24, r18
    13f0:	93 07       	cpc	r25, r19
    13f2:	81 f7       	brne	.-32     	; 0x13d4
    13f4:	80 e3       	ldi	r24, 0x30	; 48
    13f6:	e5 cd       	rjmp	.-1078   	; 0xfc2
    13f8:	21 e0       	ldi	r18, 0x01	; 1
    13fa:	30 e0       	ldi	r19, 0x00	; 0
    13fc:	80 91 c0 00 	lds	r24, 0x00C0
    1400:	99 27       	eor	r25, r25
    1402:	96 95       	lsr	r25
    1404:	87 95       	ror	r24
    1406:	92 95       	swap	r25
    1408:	82 95       	swap	r24
    140a:	8f 70       	andi	r24, 0x0F	; 15
    140c:	89 27       	eor	r24, r25
    140e:	9f 70       	andi	r25, 0x0F	; 15
    1410:	89 27       	eor	r24, r25
    1412:	81 70       	andi	r24, 0x01	; 1
    1414:	90 70       	andi	r25, 0x00	; 0
    1416:	82 17       	cp	r24, r18
    1418:	93 07       	cpc	r25, r19
    141a:	81 f7       	brne	.-32     	; 0x13fc
    141c:	81 e3       	ldi	r24, 0x31	; 49
    141e:	80 93 c6 00 	sts	0x00C6, r24
    1422:	21 e0       	ldi	r18, 0x01	; 1
    1424:	30 e0       	ldi	r19, 0x00	; 0
    1426:	80 91 c0 00 	lds	r24, 0x00C0
    142a:	99 27       	eor	r25, r25
    142c:	96 95       	lsr	r25
    142e:	87 95       	ror	r24
    1430:	92 95       	swap	r25
    1432:	82 95       	swap	r24
    1434:	8f 70       	andi	r24, 0x0F	; 15
    1436:	89 27       	eor	r24, r25
    1438:	9f 70       	andi	r25, 0x0F	; 15
    143a:	89 27       	eor	r24, r25
    143c:	81 70       	andi	r24, 0x01	; 1
    143e:	90 70       	andi	r25, 0x00	; 0
    1440:	82 17       	cp	r24, r18
    1442:	93 07       	cpc	r25, r19
    1444:	81 f7       	brne	.-32     	; 0x1426
    1446:	21 e3       	ldi	r18, 0x31	; 49
    1448:	20 93 c6 00 	sts	0x00C6, r18
    144c:	21 e0       	ldi	r18, 0x01	; 1
    144e:	30 e0       	ldi	r19, 0x00	; 0
    1450:	80 91 c0 00 	lds	r24, 0x00C0
    1454:	99 27       	eor	r25, r25
    1456:	96 95       	lsr	r25
    1458:	87 95       	ror	r24
    145a:	92 95       	swap	r25
    145c:	82 95       	swap	r24
    145e:	8f 70       	andi	r24, 0x0F	; 15
    1460:	89 27       	eor	r24, r25
    1462:	9f 70       	andi	r25, 0x0F	; 15
    1464:	89 27       	eor	r24, r25
    1466:	81 70       	andi	r24, 0x01	; 1
    1468:	90 70       	andi	r25, 0x00	; 0
    146a:	82 17       	cp	r24, r18
    146c:	93 07       	cpc	r25, r19
    146e:	81 f7       	brne	.-32     	; 0x1450
    1470:	30 e3       	ldi	r19, 0x30	; 48
    1472:	30 93 c6 00 	sts	0x00C6, r19
    1476:	21 e0       	ldi	r18, 0x01	; 1
    1478:	30 e0       	ldi	r19, 0x00	; 0
    147a:	80 91 c0 00 	lds	r24, 0x00C0
    147e:	99 27       	eor	r25, r25
    1480:	96 95       	lsr	r25
    1482:	87 95       	ror	r24
    1484:	92 95       	swap	r25
    1486:	82 95       	swap	r24
    1488:	8f 70       	andi	r24, 0x0F	; 15
    148a:	89 27       	eor	r24, r25
    148c:	9f 70       	andi	r25, 0x0F	; 15
    148e:	89 27       	eor	r24, r25
    1490:	81 70       	andi	r24, 0x01	; 1
    1492:	90 70       	andi	r25, 0x00	; 0
    1494:	82 17       	cp	r24, r18
    1496:	93 07       	cpc	r25, r19
    1498:	81 f7       	brne	.-32     	; 0x147a
    149a:	80 e3       	ldi	r24, 0x30	; 48
    149c:	92 cd       	rjmp	.-1244   	; 0xfc2
    149e:	21 e0       	ldi	r18, 0x01	; 1
    14a0:	30 e0       	ldi	r19, 0x00	; 0
    14a2:	80 91 c0 00 	lds	r24, 0x00C0
    14a6:	99 27       	eor	r25, r25
    14a8:	96 95       	lsr	r25
    14aa:	87 95       	ror	r24
    14ac:	92 95       	swap	r25
    14ae:	82 95       	swap	r24
    14b0:	8f 70       	andi	r24, 0x0F	; 15
    14b2:	89 27       	eor	r24, r25
    14b4:	9f 70       	andi	r25, 0x0F	; 15
    14b6:	89 27       	eor	r24, r25
    14b8:	81 70       	andi	r24, 0x01	; 1
    14ba:	90 70       	andi	r25, 0x00	; 0
    14bc:	82 17       	cp	r24, r18
    14be:	93 07       	cpc	r25, r19
    14c0:	81 f7       	brne	.-32     	; 0x14a2
    14c2:	70 e3       	ldi	r23, 0x30	; 48
    14c4:	70 93 c6 00 	sts	0x00C6, r23
    14c8:	21 e0       	ldi	r18, 0x01	; 1
    14ca:	30 e0       	ldi	r19, 0x00	; 0
    14cc:	80 91 c0 00 	lds	r24, 0x00C0
    14d0:	99 27       	eor	r25, r25
    14d2:	96 95       	lsr	r25
    14d4:	87 95       	ror	r24
    14d6:	92 95       	swap	r25
    14d8:	82 95       	swap	r24
    14da:	8f 70       	andi	r24, 0x0F	; 15
    14dc:	89 27       	eor	r24, r25
    14de:	9f 70       	andi	r25, 0x0F	; 15
    14e0:	89 27       	eor	r24, r25
    14e2:	81 70       	andi	r24, 0x01	; 1
    14e4:	90 70       	andi	r25, 0x00	; 0
    14e6:	82 17       	cp	r24, r18
    14e8:	93 07       	cpc	r25, r19
    14ea:	81 f7       	brne	.-32     	; 0x14cc
    14ec:	91 e3       	ldi	r25, 0x31	; 49
    14ee:	90 93 c6 00 	sts	0x00C6, r25
    14f2:	21 e0       	ldi	r18, 0x01	; 1
    14f4:	30 e0       	ldi	r19, 0x00	; 0
    14f6:	80 91 c0 00 	lds	r24, 0x00C0
    14fa:	99 27       	eor	r25, r25
    14fc:	96 95       	lsr	r25
    14fe:	87 95       	ror	r24
    1500:	92 95       	swap	r25
    1502:	82 95       	swap	r24
    1504:	8f 70       	andi	r24, 0x0F	; 15
    1506:	89 27       	eor	r24, r25
    1508:	9f 70       	andi	r25, 0x0F	; 15
    150a:	89 27       	eor	r24, r25
    150c:	81 70       	andi	r24, 0x01	; 1
    150e:	90 70       	andi	r25, 0x00	; 0
    1510:	82 17       	cp	r24, r18
    1512:	93 07       	cpc	r25, r19
    1514:	81 f7       	brne	.-32     	; 0x14f6
    1516:	a1 e3       	ldi	r26, 0x31	; 49
    1518:	a0 93 c6 00 	sts	0x00C6, r26
    151c:	21 e0       	ldi	r18, 0x01	; 1
    151e:	30 e0       	ldi	r19, 0x00	; 0
    1520:	80 91 c0 00 	lds	r24, 0x00C0
    1524:	99 27       	eor	r25, r25
    1526:	96 95       	lsr	r25
    1528:	87 95       	ror	r24
    152a:	92 95       	swap	r25
    152c:	82 95       	swap	r24
    152e:	8f 70       	andi	r24, 0x0F	; 15
    1530:	89 27       	eor	r24, r25
    1532:	9f 70       	andi	r25, 0x0F	; 15
    1534:	89 27       	eor	r24, r25
    1536:	81 70       	andi	r24, 0x01	; 1
    1538:	90 70       	andi	r25, 0x00	; 0
    153a:	82 17       	cp	r24, r18
    153c:	93 07       	cpc	r25, r19
    153e:	81 f7       	brne	.-32     	; 0x1520
    1540:	80 e3       	ldi	r24, 0x30	; 48
    1542:	3f cd       	rjmp	.-1410   	; 0xfc2
    1544:	21 e0       	ldi	r18, 0x01	; 1
    1546:	30 e0       	ldi	r19, 0x00	; 0
    1548:	80 91 c0 00 	lds	r24, 0x00C0
    154c:	99 27       	eor	r25, r25
    154e:	96 95       	lsr	r25
    1550:	87 95       	ror	r24
    1552:	92 95       	swap	r25
    1554:	82 95       	swap	r24
    1556:	8f 70       	andi	r24, 0x0F	; 15
    1558:	89 27       	eor	r24, r25
    155a:	9f 70       	andi	r25, 0x0F	; 15
    155c:	89 27       	eor	r24, r25
    155e:	81 70       	andi	r24, 0x01	; 1
    1560:	90 70       	andi	r25, 0x00	; 0
    1562:	82 17       	cp	r24, r18
    1564:	93 07       	cpc	r25, r19
    1566:	81 f7       	brne	.-32     	; 0x1548
    1568:	b1 e3       	ldi	r27, 0x31	; 49
    156a:	b0 93 c6 00 	sts	0x00C6, r27
    156e:	21 e0       	ldi	r18, 0x01	; 1
    1570:	30 e0       	ldi	r19, 0x00	; 0
    1572:	80 91 c0 00 	lds	r24, 0x00C0
    1576:	99 27       	eor	r25, r25
    1578:	96 95       	lsr	r25
    157a:	87 95       	ror	r24
    157c:	92 95       	swap	r25
    157e:	82 95       	swap	r24
    1580:	8f 70       	andi	r24, 0x0F	; 15
    1582:	89 27       	eor	r24, r25
    1584:	9f 70       	andi	r25, 0x0F	; 15
    1586:	89 27       	eor	r24, r25
    1588:	81 70       	andi	r24, 0x01	; 1
    158a:	90 70       	andi	r25, 0x00	; 0
    158c:	82 17       	cp	r24, r18
    158e:	93 07       	cpc	r25, r19
    1590:	81 f7       	brne	.-32     	; 0x1572
    1592:	e1 e3       	ldi	r30, 0x31	; 49
    1594:	e0 93 c6 00 	sts	0x00C6, r30
    1598:	21 e0       	ldi	r18, 0x01	; 1
    159a:	30 e0       	ldi	r19, 0x00	; 0
    159c:	80 91 c0 00 	lds	r24, 0x00C0
    15a0:	99 27       	eor	r25, r25
    15a2:	96 95       	lsr	r25
    15a4:	87 95       	ror	r24
    15a6:	92 95       	swap	r25
    15a8:	82 95       	swap	r24
    15aa:	8f 70       	andi	r24, 0x0F	; 15
    15ac:	89 27       	eor	r24, r25
    15ae:	9f 70       	andi	r25, 0x0F	; 15
    15b0:	89 27       	eor	r24, r25
    15b2:	81 70       	andi	r24, 0x01	; 1
    15b4:	90 70       	andi	r25, 0x00	; 0
    15b6:	82 17       	cp	r24, r18
    15b8:	93 07       	cpc	r25, r19
    15ba:	81 f7       	brne	.-32     	; 0x159c
    15bc:	f1 e3       	ldi	r31, 0x31	; 49
    15be:	f0 93 c6 00 	sts	0x00C6, r31
    15c2:	21 e0       	ldi	r18, 0x01	; 1
    15c4:	30 e0       	ldi	r19, 0x00	; 0
    15c6:	80 91 c0 00 	lds	r24, 0x00C0
    15ca:	99 27       	eor	r25, r25
    15cc:	96 95       	lsr	r25
    15ce:	87 95       	ror	r24
    15d0:	92 95       	swap	r25
    15d2:	82 95       	swap	r24
    15d4:	8f 70       	andi	r24, 0x0F	; 15
    15d6:	89 27       	eor	r24, r25
    15d8:	9f 70       	andi	r25, 0x0F	; 15
    15da:	89 27       	eor	r24, r25
    15dc:	81 70       	andi	r24, 0x01	; 1
    15de:	90 70       	andi	r25, 0x00	; 0
    15e0:	82 17       	cp	r24, r18
    15e2:	93 07       	cpc	r25, r19
    15e4:	81 f7       	brne	.-32     	; 0x15c6
    15e6:	81 e3       	ldi	r24, 0x31	; 49
    15e8:	80 93 c6 00 	sts	0x00C6, r24
    15ec:	08 95       	ret
    15ee:	9c 01       	movw	r18, r24
    15f0:	80 91 c0 00 	lds	r24, 0x00C0
    15f4:	99 27       	eor	r25, r25
    15f6:	96 95       	lsr	r25
    15f8:	87 95       	ror	r24
    15fa:	92 95       	swap	r25
    15fc:	82 95       	swap	r24
    15fe:	8f 70       	andi	r24, 0x0F	; 15
    1600:	89 27       	eor	r24, r25
    1602:	9f 70       	andi	r25, 0x0F	; 15
    1604:	89 27       	eor	r24, r25
    1606:	82 27       	eor	r24, r18
    1608:	93 27       	eor	r25, r19
    160a:	80 fd       	sbrc	r24, 0
    160c:	f1 cf       	rjmp	.-30     	; 0x15f0
    160e:	40 e3       	ldi	r20, 0x30	; 48
    1610:	40 93 c6 00 	sts	0x00C6, r20
    1614:	21 e0       	ldi	r18, 0x01	; 1
    1616:	30 e0       	ldi	r19, 0x00	; 0
    1618:	80 91 c0 00 	lds	r24, 0x00C0
    161c:	99 27       	eor	r25, r25
    161e:	96 95       	lsr	r25
    1620:	87 95       	ror	r24
    1622:	92 95       	swap	r25
    1624:	82 95       	swap	r24
    1626:	8f 70       	andi	r24, 0x0F	; 15
    1628:	89 27       	eor	r24, r25
    162a:	9f 70       	andi	r25, 0x0F	; 15
    162c:	89 27       	eor	r24, r25
    162e:	81 70       	andi	r24, 0x01	; 1
    1630:	90 70       	andi	r25, 0x00	; 0
    1632:	82 17       	cp	r24, r18
    1634:	93 07       	cpc	r25, r19
    1636:	81 f7       	brne	.-32     	; 0x1618
    1638:	50 e3       	ldi	r21, 0x30	; 48
    163a:	50 93 c6 00 	sts	0x00C6, r21
    163e:	21 e0       	ldi	r18, 0x01	; 1
    1640:	30 e0       	ldi	r19, 0x00	; 0
    1642:	80 91 c0 00 	lds	r24, 0x00C0
    1646:	99 27       	eor	r25, r25
    1648:	96 95       	lsr	r25
    164a:	87 95       	ror	r24
    164c:	92 95       	swap	r25
    164e:	82 95       	swap	r24
    1650:	8f 70       	andi	r24, 0x0F	; 15
    1652:	89 27       	eor	r24, r25
    1654:	9f 70       	andi	r25, 0x0F	; 15
    1656:	89 27       	eor	r24, r25
    1658:	81 70       	andi	r24, 0x01	; 1
    165a:	90 70       	andi	r25, 0x00	; 0
    165c:	82 17       	cp	r24, r18
    165e:	93 07       	cpc	r25, r19
    1660:	81 f7       	brne	.-32     	; 0x1642
    1662:	60 e3       	ldi	r22, 0x30	; 48
    1664:	60 93 c6 00 	sts	0x00C6, r22
    1668:	21 e0       	ldi	r18, 0x01	; 1
    166a:	30 e0       	ldi	r19, 0x00	; 0
    166c:	80 91 c0 00 	lds	r24, 0x00C0
    1670:	99 27       	eor	r25, r25
    1672:	96 95       	lsr	r25
    1674:	87 95       	ror	r24
    1676:	92 95       	swap	r25
    1678:	82 95       	swap	r24
    167a:	8f 70       	andi	r24, 0x0F	; 15
    167c:	89 27       	eor	r24, r25
    167e:	9f 70       	andi	r25, 0x0F	; 15
    1680:	89 27       	eor	r24, r25
    1682:	81 70       	andi	r24, 0x01	; 1
    1684:	90 70       	andi	r25, 0x00	; 0
    1686:	82 17       	cp	r24, r18
    1688:	93 07       	cpc	r25, r19
    168a:	81 f7       	brne	.-32     	; 0x166c
    168c:	50 cd       	rjmp	.-1376   	; 0x112e
    168e:	21 e0       	ldi	r18, 0x01	; 1
    1690:	30 e0       	ldi	r19, 0x00	; 0
    1692:	80 91 c0 00 	lds	r24, 0x00C0
    1696:	99 27       	eor	r25, r25
    1698:	96 95       	lsr	r25
    169a:	87 95       	ror	r24
    169c:	92 95       	swap	r25
    169e:	82 95       	swap	r24
    16a0:	8f 70       	andi	r24, 0x0F	; 15
    16a2:	89 27       	eor	r24, r25
    16a4:	9f 70       	andi	r25, 0x0F	; 15
    16a6:	89 27       	eor	r24, r25
    16a8:	81 70       	andi	r24, 0x01	; 1
    16aa:	90 70       	andi	r25, 0x00	; 0
    16ac:	82 17       	cp	r24, r18
    16ae:	93 07       	cpc	r25, r19
    16b0:	81 f7       	brne	.-32     	; 0x1692
    16b2:	41 e3       	ldi	r20, 0x31	; 49
    16b4:	40 93 c6 00 	sts	0x00C6, r20
    16b8:	21 e0       	ldi	r18, 0x01	; 1
    16ba:	30 e0       	ldi	r19, 0x00	; 0
    16bc:	80 91 c0 00 	lds	r24, 0x00C0
    16c0:	99 27       	eor	r25, r25
    16c2:	96 95       	lsr	r25
    16c4:	87 95       	ror	r24
    16c6:	92 95       	swap	r25
    16c8:	82 95       	swap	r24
    16ca:	8f 70       	andi	r24, 0x0F	; 15
    16cc:	89 27       	eor	r24, r25
    16ce:	9f 70       	andi	r25, 0x0F	; 15
    16d0:	89 27       	eor	r24, r25
    16d2:	81 70       	andi	r24, 0x01	; 1
    16d4:	90 70       	andi	r25, 0x00	; 0
    16d6:	82 17       	cp	r24, r18
    16d8:	93 07       	cpc	r25, r19
    16da:	81 f7       	brne	.-32     	; 0x16bc
    16dc:	50 e3       	ldi	r21, 0x30	; 48
    16de:	50 93 c6 00 	sts	0x00C6, r21
    16e2:	21 e0       	ldi	r18, 0x01	; 1
    16e4:	30 e0       	ldi	r19, 0x00	; 0
    16e6:	80 91 c0 00 	lds	r24, 0x00C0
    16ea:	99 27       	eor	r25, r25
    16ec:	96 95       	lsr	r25
    16ee:	87 95       	ror	r24
    16f0:	92 95       	swap	r25
    16f2:	82 95       	swap	r24
    16f4:	8f 70       	andi	r24, 0x0F	; 15
    16f6:	89 27       	eor	r24, r25
    16f8:	9f 70       	andi	r25, 0x0F	; 15
    16fa:	89 27       	eor	r24, r25
    16fc:	81 70       	andi	r24, 0x01	; 1
    16fe:	90 70       	andi	r25, 0x00	; 0
    1700:	82 17       	cp	r24, r18
    1702:	93 07       	cpc	r25, r19
    1704:	81 f7       	brne	.-32     	; 0x16e6
    1706:	60 e3       	ldi	r22, 0x30	; 48
    1708:	60 93 c6 00 	sts	0x00C6, r22
    170c:	21 e0       	ldi	r18, 0x01	; 1
    170e:	30 e0       	ldi	r19, 0x00	; 0
    1710:	80 91 c0 00 	lds	r24, 0x00C0
    1714:	99 27       	eor	r25, r25
    1716:	96 95       	lsr	r25
    1718:	87 95       	ror	r24
    171a:	92 95       	swap	r25
    171c:	82 95       	swap	r24
    171e:	8f 70       	andi	r24, 0x0F	; 15
    1720:	89 27       	eor	r24, r25
    1722:	9f 70       	andi	r25, 0x0F	; 15
    1724:	89 27       	eor	r24, r25
    1726:	81 70       	andi	r24, 0x01	; 1
    1728:	90 70       	andi	r25, 0x00	; 0
    172a:	82 17       	cp	r24, r18
    172c:	93 07       	cpc	r25, r19
    172e:	81 f7       	brne	.-32     	; 0x1710
    1730:	fe cc       	rjmp	.-1540   	; 0x112e
    1732:	21 e0       	ldi	r18, 0x01	; 1
    1734:	30 e0       	ldi	r19, 0x00	; 0
    1736:	80 91 c0 00 	lds	r24, 0x00C0
    173a:	99 27       	eor	r25, r25
    173c:	96 95       	lsr	r25
    173e:	87 95       	ror	r24
    1740:	92 95       	swap	r25
    1742:	82 95       	swap	r24
    1744:	8f 70       	andi	r24, 0x0F	; 15
    1746:	89 27       	eor	r24, r25
    1748:	9f 70       	andi	r25, 0x0F	; 15
    174a:	89 27       	eor	r24, r25
    174c:	81 70       	andi	r24, 0x01	; 1
    174e:	90 70       	andi	r25, 0x00	; 0
    1750:	82 17       	cp	r24, r18
    1752:	93 07       	cpc	r25, r19
    1754:	81 f7       	brne	.-32     	; 0x1736
    1756:	40 e3       	ldi	r20, 0x30	; 48
    1758:	40 93 c6 00 	sts	0x00C6, r20
    175c:	21 e0       	ldi	r18, 0x01	; 1
    175e:	30 e0       	ldi	r19, 0x00	; 0
    1760:	80 91 c0 00 	lds	r24, 0x00C0
    1764:	99 27       	eor	r25, r25
    1766:	96 95       	lsr	r25
    1768:	87 95       	ror	r24
    176a:	92 95       	swap	r25
    176c:	82 95       	swap	r24
    176e:	8f 70       	andi	r24, 0x0F	; 15
    1770:	89 27       	eor	r24, r25
    1772:	9f 70       	andi	r25, 0x0F	; 15
    1774:	89 27       	eor	r24, r25
    1776:	81 70       	andi	r24, 0x01	; 1
    1778:	90 70       	andi	r25, 0x00	; 0
    177a:	82 17       	cp	r24, r18
    177c:	93 07       	cpc	r25, r19
    177e:	81 f7       	brne	.-32     	; 0x1760
    1780:	51 e3       	ldi	r21, 0x31	; 49
    1782:	50 93 c6 00 	sts	0x00C6, r21
    1786:	21 e0       	ldi	r18, 0x01	; 1
    1788:	30 e0       	ldi	r19, 0x00	; 0
    178a:	80 91 c0 00 	lds	r24, 0x00C0
    178e:	99 27       	eor	r25, r25
    1790:	96 95       	lsr	r25
    1792:	87 95       	ror	r24
    1794:	92 95       	swap	r25
    1796:	82 95       	swap	r24
    1798:	8f 70       	andi	r24, 0x0F	; 15
    179a:	89 27       	eor	r24, r25
    179c:	9f 70       	andi	r25, 0x0F	; 15
    179e:	89 27       	eor	r24, r25
    17a0:	81 70       	andi	r24, 0x01	; 1
    17a2:	90 70       	andi	r25, 0x00	; 0
    17a4:	82 17       	cp	r24, r18
    17a6:	93 07       	cpc	r25, r19
    17a8:	81 f7       	brne	.-32     	; 0x178a
    17aa:	60 e3       	ldi	r22, 0x30	; 48
    17ac:	60 93 c6 00 	sts	0x00C6, r22
    17b0:	21 e0       	ldi	r18, 0x01	; 1
    17b2:	30 e0       	ldi	r19, 0x00	; 0
    17b4:	80 91 c0 00 	lds	r24, 0x00C0
    17b8:	99 27       	eor	r25, r25
    17ba:	96 95       	lsr	r25
    17bc:	87 95       	ror	r24
    17be:	92 95       	swap	r25
    17c0:	82 95       	swap	r24
    17c2:	8f 70       	andi	r24, 0x0F	; 15
    17c4:	89 27       	eor	r24, r25
    17c6:	9f 70       	andi	r25, 0x0F	; 15
    17c8:	89 27       	eor	r24, r25
    17ca:	81 70       	andi	r24, 0x01	; 1
    17cc:	90 70       	andi	r25, 0x00	; 0
    17ce:	82 17       	cp	r24, r18
    17d0:	93 07       	cpc	r25, r19
    17d2:	81 f7       	brne	.-32     	; 0x17b4
    17d4:	ac cc       	rjmp	.-1704   	; 0x112e
    17d6:	21 e0       	ldi	r18, 0x01	; 1
    17d8:	30 e0       	ldi	r19, 0x00	; 0
    17da:	80 91 c0 00 	lds	r24, 0x00C0
    17de:	99 27       	eor	r25, r25
    17e0:	96 95       	lsr	r25
    17e2:	87 95       	ror	r24
    17e4:	92 95       	swap	r25
    17e6:	82 95       	swap	r24
    17e8:	8f 70       	andi	r24, 0x0F	; 15
    17ea:	89 27       	eor	r24, r25
    17ec:	9f 70       	andi	r25, 0x0F	; 15
    17ee:	89 27       	eor	r24, r25
    17f0:	81 70       	andi	r24, 0x01	; 1
    17f2:	90 70       	andi	r25, 0x00	; 0
    17f4:	82 17       	cp	r24, r18
    17f6:	93 07       	cpc	r25, r19
    17f8:	81 f7       	brne	.-32     	; 0x17da
    17fa:	41 e3       	ldi	r20, 0x31	; 49
    17fc:	40 93 c6 00 	sts	0x00C6, r20
    1800:	21 e0       	ldi	r18, 0x01	; 1
    1802:	30 e0       	ldi	r19, 0x00	; 0
    1804:	80 91 c0 00 	lds	r24, 0x00C0
    1808:	99 27       	eor	r25, r25
    180a:	96 95       	lsr	r25
    180c:	87 95       	ror	r24
    180e:	92 95       	swap	r25
    1810:	82 95       	swap	r24
    1812:	8f 70       	andi	r24, 0x0F	; 15
    1814:	89 27       	eor	r24, r25
    1816:	9f 70       	andi	r25, 0x0F	; 15
    1818:	89 27       	eor	r24, r25
    181a:	81 70       	andi	r24, 0x01	; 1
    181c:	90 70       	andi	r25, 0x00	; 0
    181e:	82 17       	cp	r24, r18
    1820:	93 07       	cpc	r25, r19
    1822:	81 f7       	brne	.-32     	; 0x1804
    1824:	51 e3       	ldi	r21, 0x31	; 49
    1826:	50 93 c6 00 	sts	0x00C6, r21
    182a:	21 e0       	ldi	r18, 0x01	; 1
    182c:	30 e0       	ldi	r19, 0x00	; 0
    182e:	80 91 c0 00 	lds	r24, 0x00C0
    1832:	99 27       	eor	r25, r25
    1834:	96 95       	lsr	r25
    1836:	87 95       	ror	r24
    1838:	92 95       	swap	r25
    183a:	82 95       	swap	r24
    183c:	8f 70       	andi	r24, 0x0F	; 15
    183e:	89 27       	eor	r24, r25
    1840:	9f 70       	andi	r25, 0x0F	; 15
    1842:	89 27       	eor	r24, r25
    1844:	81 70       	andi	r24, 0x01	; 1
    1846:	90 70       	andi	r25, 0x00	; 0
    1848:	82 17       	cp	r24, r18
    184a:	93 07       	cpc	r25, r19
    184c:	81 f7       	brne	.-32     	; 0x182e
    184e:	60 e3       	ldi	r22, 0x30	; 48
    1850:	60 93 c6 00 	sts	0x00C6, r22
    1854:	21 e0       	ldi	r18, 0x01	; 1
    1856:	30 e0       	ldi	r19, 0x00	; 0
    1858:	80 91 c0 00 	lds	r24, 0x00C0
    185c:	99 27       	eor	r25, r25
    185e:	96 95       	lsr	r25
    1860:	87 95       	ror	r24
    1862:	92 95       	swap	r25
    1864:	82 95       	swap	r24
    1866:	8f 70       	andi	r24, 0x0F	; 15
    1868:	89 27       	eor	r24, r25
    186a:	9f 70       	andi	r25, 0x0F	; 15
    186c:	89 27       	eor	r24, r25
    186e:	81 70       	andi	r24, 0x01	; 1
    1870:	90 70       	andi	r25, 0x00	; 0
    1872:	82 17       	cp	r24, r18
    1874:	93 07       	cpc	r25, r19
    1876:	81 f7       	brne	.-32     	; 0x1858
    1878:	5a cc       	rjmp	.-1868   	; 0x112e
    187a:	89 2b       	or	r24, r25
    187c:	09 f4       	brne	.+2      	; 0x1880
    187e:	54 c0       	rjmp	.+168    	; 0x1928
    1880:	08 95       	ret
    1882:	21 e0       	ldi	r18, 0x01	; 1
    1884:	30 e0       	ldi	r19, 0x00	; 0
    1886:	80 91 c0 00 	lds	r24, 0x00C0
    188a:	99 27       	eor	r25, r25
    188c:	96 95       	lsr	r25
    188e:	87 95       	ror	r24
    1890:	92 95       	swap	r25
    1892:	82 95       	swap	r24
    1894:	8f 70       	andi	r24, 0x0F	; 15
    1896:	89 27       	eor	r24, r25
    1898:	9f 70       	andi	r25, 0x0F	; 15
    189a:	89 27       	eor	r24, r25
    189c:	81 70       	andi	r24, 0x01	; 1
    189e:	90 70       	andi	r25, 0x00	; 0
    18a0:	82 17       	cp	r24, r18
    18a2:	93 07       	cpc	r25, r19
    18a4:	81 f7       	brne	.-32     	; 0x1886
    18a6:	71 e3       	ldi	r23, 0x31	; 49
    18a8:	70 93 c6 00 	sts	0x00C6, r23
    18ac:	21 e0       	ldi	r18, 0x01	; 1
    18ae:	30 e0       	ldi	r19, 0x00	; 0
    18b0:	80 91 c0 00 	lds	r24, 0x00C0
    18b4:	99 27       	eor	r25, r25
    18b6:	96 95       	lsr	r25
    18b8:	87 95       	ror	r24
    18ba:	92 95       	swap	r25
    18bc:	82 95       	swap	r24
    18be:	8f 70       	andi	r24, 0x0F	; 15
    18c0:	89 27       	eor	r24, r25
    18c2:	9f 70       	andi	r25, 0x0F	; 15
    18c4:	89 27       	eor	r24, r25
    18c6:	81 70       	andi	r24, 0x01	; 1
    18c8:	90 70       	andi	r25, 0x00	; 0
    18ca:	82 17       	cp	r24, r18
    18cc:	93 07       	cpc	r25, r19
    18ce:	81 f7       	brne	.-32     	; 0x18b0
    18d0:	91 e3       	ldi	r25, 0x31	; 49
    18d2:	90 93 c6 00 	sts	0x00C6, r25
    18d6:	21 e0       	ldi	r18, 0x01	; 1
    18d8:	30 e0       	ldi	r19, 0x00	; 0
    18da:	80 91 c0 00 	lds	r24, 0x00C0
    18de:	99 27       	eor	r25, r25
    18e0:	96 95       	lsr	r25
    18e2:	87 95       	ror	r24
    18e4:	92 95       	swap	r25
    18e6:	82 95       	swap	r24
    18e8:	8f 70       	andi	r24, 0x0F	; 15
    18ea:	89 27       	eor	r24, r25
    18ec:	9f 70       	andi	r25, 0x0F	; 15
    18ee:	89 27       	eor	r24, r25
    18f0:	81 70       	andi	r24, 0x01	; 1
    18f2:	90 70       	andi	r25, 0x00	; 0
    18f4:	82 17       	cp	r24, r18
    18f6:	93 07       	cpc	r25, r19
    18f8:	81 f7       	brne	.-32     	; 0x18da
    18fa:	a1 e3       	ldi	r26, 0x31	; 49
    18fc:	a0 93 c6 00 	sts	0x00C6, r26
    1900:	21 e0       	ldi	r18, 0x01	; 1
    1902:	30 e0       	ldi	r19, 0x00	; 0
    1904:	80 91 c0 00 	lds	r24, 0x00C0
    1908:	99 27       	eor	r25, r25
    190a:	96 95       	lsr	r25
    190c:	87 95       	ror	r24
    190e:	92 95       	swap	r25
    1910:	82 95       	swap	r24
    1912:	8f 70       	andi	r24, 0x0F	; 15
    1914:	89 27       	eor	r24, r25
    1916:	9f 70       	andi	r25, 0x0F	; 15
    1918:	89 27       	eor	r24, r25
    191a:	81 70       	andi	r24, 0x01	; 1
    191c:	90 70       	andi	r25, 0x00	; 0
    191e:	82 17       	cp	r24, r18
    1920:	93 07       	cpc	r25, r19
    1922:	81 f7       	brne	.-32     	; 0x1904
    1924:	80 e3       	ldi	r24, 0x30	; 48
    1926:	4d cb       	rjmp	.-2406   	; 0xfc2
    1928:	21 e0       	ldi	r18, 0x01	; 1
    192a:	30 e0       	ldi	r19, 0x00	; 0
    192c:	80 91 c0 00 	lds	r24, 0x00C0
    1930:	99 27       	eor	r25, r25
    1932:	96 95       	lsr	r25
    1934:	87 95       	ror	r24
    1936:	92 95       	swap	r25
    1938:	82 95       	swap	r24
    193a:	8f 70       	andi	r24, 0x0F	; 15
    193c:	89 27       	eor	r24, r25
    193e:	9f 70       	andi	r25, 0x0F	; 15
    1940:	89 27       	eor	r24, r25
    1942:	81 70       	andi	r24, 0x01	; 1
    1944:	90 70       	andi	r25, 0x00	; 0
    1946:	82 17       	cp	r24, r18
    1948:	93 07       	cpc	r25, r19
    194a:	81 f7       	brne	.-32     	; 0x192c
    194c:	80 e3       	ldi	r24, 0x30	; 48
    194e:	80 93 c6 00 	sts	0x00C6, r24
    1952:	21 e0       	ldi	r18, 0x01	; 1
    1954:	30 e0       	ldi	r19, 0x00	; 0
    1956:	80 91 c0 00 	lds	r24, 0x00C0
    195a:	99 27       	eor	r25, r25
    195c:	96 95       	lsr	r25
    195e:	87 95       	ror	r24
    1960:	92 95       	swap	r25
    1962:	82 95       	swap	r24
    1964:	8f 70       	andi	r24, 0x0F	; 15
    1966:	89 27       	eor	r24, r25
    1968:	9f 70       	andi	r25, 0x0F	; 15
    196a:	89 27       	eor	r24, r25
    196c:	81 70       	andi	r24, 0x01	; 1
    196e:	90 70       	andi	r25, 0x00	; 0
    1970:	82 17       	cp	r24, r18
    1972:	93 07       	cpc	r25, r19
    1974:	81 f7       	brne	.-32     	; 0x1956
    1976:	20 e3       	ldi	r18, 0x30	; 48
    1978:	20 93 c6 00 	sts	0x00C6, r18
    197c:	21 e0       	ldi	r18, 0x01	; 1
    197e:	30 e0       	ldi	r19, 0x00	; 0
    1980:	80 91 c0 00 	lds	r24, 0x00C0
    1984:	99 27       	eor	r25, r25
    1986:	96 95       	lsr	r25
    1988:	87 95       	ror	r24
    198a:	92 95       	swap	r25
    198c:	82 95       	swap	r24
    198e:	8f 70       	andi	r24, 0x0F	; 15
    1990:	89 27       	eor	r24, r25
    1992:	9f 70       	andi	r25, 0x0F	; 15
    1994:	89 27       	eor	r24, r25
    1996:	81 70       	andi	r24, 0x01	; 1
    1998:	90 70       	andi	r25, 0x00	; 0
    199a:	82 17       	cp	r24, r18
    199c:	93 07       	cpc	r25, r19
    199e:	81 f7       	brne	.-32     	; 0x1980
    19a0:	30 e3       	ldi	r19, 0x30	; 48
    19a2:	30 93 c6 00 	sts	0x00C6, r19
    19a6:	21 e0       	ldi	r18, 0x01	; 1
    19a8:	30 e0       	ldi	r19, 0x00	; 0
    19aa:	80 91 c0 00 	lds	r24, 0x00C0
    19ae:	99 27       	eor	r25, r25
    19b0:	96 95       	lsr	r25
    19b2:	87 95       	ror	r24
    19b4:	92 95       	swap	r25
    19b6:	82 95       	swap	r24
    19b8:	8f 70       	andi	r24, 0x0F	; 15
    19ba:	89 27       	eor	r24, r25
    19bc:	9f 70       	andi	r25, 0x0F	; 15
    19be:	89 27       	eor	r24, r25
    19c0:	81 70       	andi	r24, 0x01	; 1
    19c2:	90 70       	andi	r25, 0x00	; 0
    19c4:	82 17       	cp	r24, r18
    19c6:	93 07       	cpc	r25, r19
    19c8:	81 f7       	brne	.-32     	; 0x19aa
    19ca:	80 e3       	ldi	r24, 0x30	; 48
    19cc:	fa ca       	rjmp	.-2572   	; 0xfc2

000019ce <UART_send_BIN8>:
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
    19ce:	cf 93       	push	r28
    19d0:	c8 2f       	mov	r28, r24
    19d2:	21 e0       	ldi	r18, 0x01	; 1
    19d4:	30 e0       	ldi	r19, 0x00	; 0
    19d6:	80 91 c0 00 	lds	r24, 0x00C0
    19da:	99 27       	eor	r25, r25
    19dc:	96 95       	lsr	r25
    19de:	87 95       	ror	r24
    19e0:	92 95       	swap	r25
    19e2:	82 95       	swap	r24
    19e4:	8f 70       	andi	r24, 0x0F	; 15
    19e6:	89 27       	eor	r24, r25
    19e8:	9f 70       	andi	r25, 0x0F	; 15
    19ea:	89 27       	eor	r24, r25
    19ec:	81 70       	andi	r24, 0x01	; 1
    19ee:	90 70       	andi	r25, 0x00	; 0
    19f0:	82 17       	cp	r24, r18
    19f2:	93 07       	cpc	r25, r19
    19f4:	81 f7       	brne	.-32     	; 0x19d6
    19f6:	82 e6       	ldi	r24, 0x62	; 98
    19f8:	80 93 c6 00 	sts	0x00C6, r24
	send_byte_serial('b');
	UART_send_BIN4(lowb>>4);
    19fc:	8c 2f       	mov	r24, r28
    19fe:	82 95       	swap	r24
    1a00:	8f 70       	andi	r24, 0x0F	; 15
    1a02:	0e 94 76 07 	call	0xeec
	UART_send_BIN4(lowb & 0x0F);
    1a06:	8c 2f       	mov	r24, r28
    1a08:	8f 70       	andi	r24, 0x0F	; 15
    1a0a:	0e 94 76 07 	call	0xeec
    1a0e:	cf 91       	pop	r28
    1a10:	08 95       	ret

00001a12 <UART_send_HEX4>:
}
	
void UART_send_HEX4(uint8_t lowb){
	switch(lowb){
    1a12:	99 27       	eor	r25, r25
    1a14:	87 30       	cpi	r24, 0x07	; 7
    1a16:	91 05       	cpc	r25, r1
    1a18:	09 f4       	brne	.+2      	; 0x1a1c
    1a1a:	4a c0       	rjmp	.+148    	; 0x1ab0
    1a1c:	88 30       	cpi	r24, 0x08	; 8
    1a1e:	91 05       	cpc	r25, r1
    1a20:	24 f5       	brge	.+72     	; 0x1a6a
    1a22:	83 30       	cpi	r24, 0x03	; 3
    1a24:	91 05       	cpc	r25, r1
    1a26:	09 f4       	brne	.+2      	; 0x1a2a
    1a28:	9a c0       	rjmp	.+308    	; 0x1b5e
    1a2a:	84 30       	cpi	r24, 0x04	; 4
    1a2c:	91 05       	cpc	r25, r1
    1a2e:	0c f0       	brlt	.+2      	; 0x1a32
    1a30:	55 c0       	rjmp	.+170    	; 0x1adc
    1a32:	81 30       	cpi	r24, 0x01	; 1
    1a34:	91 05       	cpc	r25, r1
    1a36:	09 f4       	brne	.+2      	; 0x1a3a
    1a38:	fa c0       	rjmp	.+500    	; 0x1c2e
    1a3a:	82 30       	cpi	r24, 0x02	; 2
    1a3c:	91 05       	cpc	r25, r1
    1a3e:	0c f4       	brge	.+2      	; 0x1a42
    1a40:	44 c1       	rjmp	.+648    	; 0x1cca
    1a42:	21 e0       	ldi	r18, 0x01	; 1
    1a44:	30 e0       	ldi	r19, 0x00	; 0
    1a46:	80 91 c0 00 	lds	r24, 0x00C0
    1a4a:	99 27       	eor	r25, r25
    1a4c:	96 95       	lsr	r25
    1a4e:	87 95       	ror	r24
    1a50:	92 95       	swap	r25
    1a52:	82 95       	swap	r24
    1a54:	8f 70       	andi	r24, 0x0F	; 15
    1a56:	89 27       	eor	r24, r25
    1a58:	9f 70       	andi	r25, 0x0F	; 15
    1a5a:	89 27       	eor	r24, r25
    1a5c:	81 70       	andi	r24, 0x01	; 1
    1a5e:	90 70       	andi	r25, 0x00	; 0
    1a60:	82 17       	cp	r24, r18
    1a62:	93 07       	cpc	r25, r19
    1a64:	81 f7       	brne	.-32     	; 0x1a46
    1a66:	82 e3       	ldi	r24, 0x32	; 50
    1a68:	36 c0       	rjmp	.+108    	; 0x1ad6
    1a6a:	8b 30       	cpi	r24, 0x0B	; 11
    1a6c:	91 05       	cpc	r25, r1
    1a6e:	09 f4       	brne	.+2      	; 0x1a72
    1a70:	60 c0       	rjmp	.+192    	; 0x1b32
    1a72:	8c 30       	cpi	r24, 0x0C	; 12
    1a74:	91 05       	cpc	r25, r1
    1a76:	0c f0       	brlt	.+2      	; 0x1a7a
    1a78:	4c c0       	rjmp	.+152    	; 0x1b12
    1a7a:	89 30       	cpi	r24, 0x09	; 9
    1a7c:	91 05       	cpc	r25, r1
    1a7e:	09 f4       	brne	.+2      	; 0x1a82
    1a80:	e8 c0       	rjmp	.+464    	; 0x1c52
    1a82:	0a 97       	sbiw	r24, 0x0a	; 10
    1a84:	0c f0       	brlt	.+2      	; 0x1a88
    1a86:	81 c0       	rjmp	.+258    	; 0x1b8a
    1a88:	21 e0       	ldi	r18, 0x01	; 1
    1a8a:	30 e0       	ldi	r19, 0x00	; 0
    1a8c:	80 91 c0 00 	lds	r24, 0x00C0
    1a90:	99 27       	eor	r25, r25
    1a92:	96 95       	lsr	r25
    1a94:	87 95       	ror	r24
    1a96:	92 95       	swap	r25
    1a98:	82 95       	swap	r24
    1a9a:	8f 70       	andi	r24, 0x0F	; 15
    1a9c:	89 27       	eor	r24, r25
    1a9e:	9f 70       	andi	r25, 0x0F	; 15
    1aa0:	89 27       	eor	r24, r25
    1aa2:	81 70       	andi	r24, 0x01	; 1
    1aa4:	90 70       	andi	r25, 0x00	; 0
    1aa6:	82 17       	cp	r24, r18
    1aa8:	93 07       	cpc	r25, r19
    1aaa:	81 f7       	brne	.-32     	; 0x1a8c
    1aac:	88 e3       	ldi	r24, 0x38	; 56
    1aae:	13 c0       	rjmp	.+38     	; 0x1ad6
    1ab0:	21 e0       	ldi	r18, 0x01	; 1
    1ab2:	30 e0       	ldi	r19, 0x00	; 0
    1ab4:	80 91 c0 00 	lds	r24, 0x00C0
    1ab8:	99 27       	eor	r25, r25
    1aba:	96 95       	lsr	r25
    1abc:	87 95       	ror	r24
    1abe:	92 95       	swap	r25
    1ac0:	82 95       	swap	r24
    1ac2:	8f 70       	andi	r24, 0x0F	; 15
    1ac4:	89 27       	eor	r24, r25
    1ac6:	9f 70       	andi	r25, 0x0F	; 15
    1ac8:	89 27       	eor	r24, r25
    1aca:	81 70       	andi	r24, 0x01	; 1
    1acc:	90 70       	andi	r25, 0x00	; 0
    1ace:	82 17       	cp	r24, r18
    1ad0:	93 07       	cpc	r25, r19
    1ad2:	81 f7       	brne	.-32     	; 0x1ab4
    1ad4:	87 e3       	ldi	r24, 0x37	; 55
    1ad6:	80 93 c6 00 	sts	0x00C6, r24
    1ada:	08 95       	ret
    1adc:	85 30       	cpi	r24, 0x05	; 5
    1ade:	91 05       	cpc	r25, r1
    1ae0:	09 f4       	brne	.+2      	; 0x1ae4
    1ae2:	cb c0       	rjmp	.+406    	; 0x1c7a
    1ae4:	06 97       	sbiw	r24, 0x06	; 6
    1ae6:	0c f0       	brlt	.+2      	; 0x1aea
    1ae8:	78 c0       	rjmp	.+240    	; 0x1bda
    1aea:	21 e0       	ldi	r18, 0x01	; 1
    1aec:	30 e0       	ldi	r19, 0x00	; 0
    1aee:	80 91 c0 00 	lds	r24, 0x00C0
    1af2:	99 27       	eor	r25, r25
    1af4:	96 95       	lsr	r25
    1af6:	87 95       	ror	r24
    1af8:	92 95       	swap	r25
    1afa:	82 95       	swap	r24
    1afc:	8f 70       	andi	r24, 0x0F	; 15
    1afe:	89 27       	eor	r24, r25
    1b00:	9f 70       	andi	r25, 0x0F	; 15
    1b02:	89 27       	eor	r24, r25
    1b04:	81 70       	andi	r24, 0x01	; 1
    1b06:	90 70       	andi	r25, 0x00	; 0
    1b08:	82 17       	cp	r24, r18
    1b0a:	93 07       	cpc	r25, r19
    1b0c:	81 f7       	brne	.-32     	; 0x1aee
    1b0e:	84 e3       	ldi	r24, 0x34	; 52
    1b10:	e2 cf       	rjmp	.-60     	; 0x1ad6
    1b12:	8d 30       	cpi	r24, 0x0D	; 13
    1b14:	91 05       	cpc	r25, r1
    1b16:	09 f4       	brne	.+2      	; 0x1b1a
    1b18:	c4 c0       	rjmp	.+392    	; 0x1ca2
    1b1a:	8d 30       	cpi	r24, 0x0D	; 13
    1b1c:	91 05       	cpc	r25, r1
    1b1e:	0c f4       	brge	.+2      	; 0x1b22
    1b20:	48 c0       	rjmp	.+144    	; 0x1bb2
    1b22:	8e 30       	cpi	r24, 0x0E	; 14
    1b24:	91 05       	cpc	r25, r1
    1b26:	09 f4       	brne	.+2      	; 0x1b2a
    1b28:	d3 c0       	rjmp	.+422    	; 0x1cd0
    1b2a:	0f 97       	sbiw	r24, 0x0f	; 15
    1b2c:	09 f4       	brne	.+2      	; 0x1b30
    1b2e:	69 c0       	rjmp	.+210    	; 0x1c02
    1b30:	08 95       	ret
    1b32:	21 e0       	ldi	r18, 0x01	; 1
    1b34:	30 e0       	ldi	r19, 0x00	; 0
    1b36:	80 91 c0 00 	lds	r24, 0x00C0
    1b3a:	99 27       	eor	r25, r25
    1b3c:	96 95       	lsr	r25
    1b3e:	87 95       	ror	r24
    1b40:	92 95       	swap	r25
    1b42:	82 95       	swap	r24
    1b44:	8f 70       	andi	r24, 0x0F	; 15
    1b46:	89 27       	eor	r24, r25
    1b48:	9f 70       	andi	r25, 0x0F	; 15
    1b4a:	89 27       	eor	r24, r25
    1b4c:	81 70       	andi	r24, 0x01	; 1
    1b4e:	90 70       	andi	r25, 0x00	; 0
    1b50:	82 17       	cp	r24, r18
    1b52:	93 07       	cpc	r25, r19
    1b54:	81 f7       	brne	.-32     	; 0x1b36
    1b56:	82 e4       	ldi	r24, 0x42	; 66
    1b58:	80 93 c6 00 	sts	0x00C6, r24
    1b5c:	08 95       	ret
    1b5e:	21 e0       	ldi	r18, 0x01	; 1
    1b60:	30 e0       	ldi	r19, 0x00	; 0
    1b62:	80 91 c0 00 	lds	r24, 0x00C0
    1b66:	99 27       	eor	r25, r25
    1b68:	96 95       	lsr	r25
    1b6a:	87 95       	ror	r24
    1b6c:	92 95       	swap	r25
    1b6e:	82 95       	swap	r24
    1b70:	8f 70       	andi	r24, 0x0F	; 15
    1b72:	89 27       	eor	r24, r25
    1b74:	9f 70       	andi	r25, 0x0F	; 15
    1b76:	89 27       	eor	r24, r25
    1b78:	81 70       	andi	r24, 0x01	; 1
    1b7a:	90 70       	andi	r25, 0x00	; 0
    1b7c:	82 17       	cp	r24, r18
    1b7e:	93 07       	cpc	r25, r19
    1b80:	81 f7       	brne	.-32     	; 0x1b62
    1b82:	83 e3       	ldi	r24, 0x33	; 51
    1b84:	80 93 c6 00 	sts	0x00C6, r24
    1b88:	08 95       	ret
    1b8a:	21 e0       	ldi	r18, 0x01	; 1
    1b8c:	30 e0       	ldi	r19, 0x00	; 0
    1b8e:	80 91 c0 00 	lds	r24, 0x00C0
    1b92:	99 27       	eor	r25, r25
    1b94:	96 95       	lsr	r25
    1b96:	87 95       	ror	r24
    1b98:	92 95       	swap	r25
    1b9a:	82 95       	swap	r24
    1b9c:	8f 70       	andi	r24, 0x0F	; 15
    1b9e:	89 27       	eor	r24, r25
    1ba0:	9f 70       	andi	r25, 0x0F	; 15
    1ba2:	89 27       	eor	r24, r25
    1ba4:	81 70       	andi	r24, 0x01	; 1
    1ba6:	90 70       	andi	r25, 0x00	; 0
    1ba8:	82 17       	cp	r24, r18
    1baa:	93 07       	cpc	r25, r19
    1bac:	81 f7       	brne	.-32     	; 0x1b8e
    1bae:	81 e4       	ldi	r24, 0x41	; 65
    1bb0:	92 cf       	rjmp	.-220    	; 0x1ad6
    1bb2:	21 e0       	ldi	r18, 0x01	; 1
    1bb4:	30 e0       	ldi	r19, 0x00	; 0
    1bb6:	80 91 c0 00 	lds	r24, 0x00C0
    1bba:	99 27       	eor	r25, r25
    1bbc:	96 95       	lsr	r25
    1bbe:	87 95       	ror	r24
    1bc0:	92 95       	swap	r25
    1bc2:	82 95       	swap	r24
    1bc4:	8f 70       	andi	r24, 0x0F	; 15
    1bc6:	89 27       	eor	r24, r25
    1bc8:	9f 70       	andi	r25, 0x0F	; 15
    1bca:	89 27       	eor	r24, r25
    1bcc:	81 70       	andi	r24, 0x01	; 1
    1bce:	90 70       	andi	r25, 0x00	; 0
    1bd0:	82 17       	cp	r24, r18
    1bd2:	93 07       	cpc	r25, r19
    1bd4:	81 f7       	brne	.-32     	; 0x1bb6
    1bd6:	83 e4       	ldi	r24, 0x43	; 67
    1bd8:	7e cf       	rjmp	.-260    	; 0x1ad6
    1bda:	21 e0       	ldi	r18, 0x01	; 1
    1bdc:	30 e0       	ldi	r19, 0x00	; 0
    1bde:	80 91 c0 00 	lds	r24, 0x00C0
    1be2:	99 27       	eor	r25, r25
    1be4:	96 95       	lsr	r25
    1be6:	87 95       	ror	r24
    1be8:	92 95       	swap	r25
    1bea:	82 95       	swap	r24
    1bec:	8f 70       	andi	r24, 0x0F	; 15
    1bee:	89 27       	eor	r24, r25
    1bf0:	9f 70       	andi	r25, 0x0F	; 15
    1bf2:	89 27       	eor	r24, r25
    1bf4:	81 70       	andi	r24, 0x01	; 1
    1bf6:	90 70       	andi	r25, 0x00	; 0
    1bf8:	82 17       	cp	r24, r18
    1bfa:	93 07       	cpc	r25, r19
    1bfc:	81 f7       	brne	.-32     	; 0x1bde
    1bfe:	86 e3       	ldi	r24, 0x36	; 54
    1c00:	6a cf       	rjmp	.-300    	; 0x1ad6
    1c02:	21 e0       	ldi	r18, 0x01	; 1
    1c04:	30 e0       	ldi	r19, 0x00	; 0
    1c06:	80 91 c0 00 	lds	r24, 0x00C0
    1c0a:	99 27       	eor	r25, r25
    1c0c:	96 95       	lsr	r25
    1c0e:	87 95       	ror	r24
    1c10:	92 95       	swap	r25
    1c12:	82 95       	swap	r24
    1c14:	8f 70       	andi	r24, 0x0F	; 15
    1c16:	89 27       	eor	r24, r25
    1c18:	9f 70       	andi	r25, 0x0F	; 15
    1c1a:	89 27       	eor	r24, r25
    1c1c:	81 70       	andi	r24, 0x01	; 1
    1c1e:	90 70       	andi	r25, 0x00	; 0
    1c20:	82 17       	cp	r24, r18
    1c22:	93 07       	cpc	r25, r19
    1c24:	81 f7       	brne	.-32     	; 0x1c06
    1c26:	86 e4       	ldi	r24, 0x46	; 70
    1c28:	80 93 c6 00 	sts	0x00C6, r24
    1c2c:	08 95       	ret
    1c2e:	9c 01       	movw	r18, r24
    1c30:	80 91 c0 00 	lds	r24, 0x00C0
    1c34:	99 27       	eor	r25, r25
    1c36:	96 95       	lsr	r25
    1c38:	87 95       	ror	r24
    1c3a:	92 95       	swap	r25
    1c3c:	82 95       	swap	r24
    1c3e:	8f 70       	andi	r24, 0x0F	; 15
    1c40:	89 27       	eor	r24, r25
    1c42:	9f 70       	andi	r25, 0x0F	; 15
    1c44:	89 27       	eor	r24, r25
    1c46:	82 27       	eor	r24, r18
    1c48:	93 27       	eor	r25, r19
    1c4a:	80 fd       	sbrc	r24, 0
    1c4c:	f1 cf       	rjmp	.-30     	; 0x1c30
    1c4e:	81 e3       	ldi	r24, 0x31	; 49
    1c50:	42 cf       	rjmp	.-380    	; 0x1ad6
    1c52:	21 e0       	ldi	r18, 0x01	; 1
    1c54:	30 e0       	ldi	r19, 0x00	; 0
    1c56:	80 91 c0 00 	lds	r24, 0x00C0
    1c5a:	99 27       	eor	r25, r25
    1c5c:	96 95       	lsr	r25
    1c5e:	87 95       	ror	r24
    1c60:	92 95       	swap	r25
    1c62:	82 95       	swap	r24
    1c64:	8f 70       	andi	r24, 0x0F	; 15
    1c66:	89 27       	eor	r24, r25
    1c68:	9f 70       	andi	r25, 0x0F	; 15
    1c6a:	89 27       	eor	r24, r25
    1c6c:	81 70       	andi	r24, 0x01	; 1
    1c6e:	90 70       	andi	r25, 0x00	; 0
    1c70:	82 17       	cp	r24, r18
    1c72:	93 07       	cpc	r25, r19
    1c74:	81 f7       	brne	.-32     	; 0x1c56
    1c76:	89 e3       	ldi	r24, 0x39	; 57
    1c78:	2e cf       	rjmp	.-420    	; 0x1ad6
    1c7a:	21 e0       	ldi	r18, 0x01	; 1
    1c7c:	30 e0       	ldi	r19, 0x00	; 0
    1c7e:	80 91 c0 00 	lds	r24, 0x00C0
    1c82:	99 27       	eor	r25, r25
    1c84:	96 95       	lsr	r25
    1c86:	87 95       	ror	r24
    1c88:	92 95       	swap	r25
    1c8a:	82 95       	swap	r24
    1c8c:	8f 70       	andi	r24, 0x0F	; 15
    1c8e:	89 27       	eor	r24, r25
    1c90:	9f 70       	andi	r25, 0x0F	; 15
    1c92:	89 27       	eor	r24, r25
    1c94:	81 70       	andi	r24, 0x01	; 1
    1c96:	90 70       	andi	r25, 0x00	; 0
    1c98:	82 17       	cp	r24, r18
    1c9a:	93 07       	cpc	r25, r19
    1c9c:	81 f7       	brne	.-32     	; 0x1c7e
    1c9e:	85 e3       	ldi	r24, 0x35	; 53
    1ca0:	1a cf       	rjmp	.-460    	; 0x1ad6
    1ca2:	21 e0       	ldi	r18, 0x01	; 1
    1ca4:	30 e0       	ldi	r19, 0x00	; 0
    1ca6:	80 91 c0 00 	lds	r24, 0x00C0
    1caa:	99 27       	eor	r25, r25
    1cac:	96 95       	lsr	r25
    1cae:	87 95       	ror	r24
    1cb0:	92 95       	swap	r25
    1cb2:	82 95       	swap	r24
    1cb4:	8f 70       	andi	r24, 0x0F	; 15
    1cb6:	89 27       	eor	r24, r25
    1cb8:	9f 70       	andi	r25, 0x0F	; 15
    1cba:	89 27       	eor	r24, r25
    1cbc:	81 70       	andi	r24, 0x01	; 1
    1cbe:	90 70       	andi	r25, 0x00	; 0
    1cc0:	82 17       	cp	r24, r18
    1cc2:	93 07       	cpc	r25, r19
    1cc4:	81 f7       	brne	.-32     	; 0x1ca6
    1cc6:	84 e4       	ldi	r24, 0x44	; 68
    1cc8:	06 cf       	rjmp	.-500    	; 0x1ad6
    1cca:	89 2b       	or	r24, r25
    1ccc:	a9 f0       	breq	.+42     	; 0x1cf8
    1cce:	08 95       	ret
    1cd0:	21 e0       	ldi	r18, 0x01	; 1
    1cd2:	30 e0       	ldi	r19, 0x00	; 0
    1cd4:	80 91 c0 00 	lds	r24, 0x00C0
    1cd8:	99 27       	eor	r25, r25
    1cda:	96 95       	lsr	r25
    1cdc:	87 95       	ror	r24
    1cde:	92 95       	swap	r25
    1ce0:	82 95       	swap	r24
    1ce2:	8f 70       	andi	r24, 0x0F	; 15
    1ce4:	89 27       	eor	r24, r25
    1ce6:	9f 70       	andi	r25, 0x0F	; 15
    1ce8:	89 27       	eor	r24, r25
    1cea:	81 70       	andi	r24, 0x01	; 1
    1cec:	90 70       	andi	r25, 0x00	; 0
    1cee:	82 17       	cp	r24, r18
    1cf0:	93 07       	cpc	r25, r19
    1cf2:	81 f7       	brne	.-32     	; 0x1cd4
    1cf4:	85 e4       	ldi	r24, 0x45	; 69
    1cf6:	ef ce       	rjmp	.-546    	; 0x1ad6
    1cf8:	21 e0       	ldi	r18, 0x01	; 1
    1cfa:	30 e0       	ldi	r19, 0x00	; 0
    1cfc:	80 91 c0 00 	lds	r24, 0x00C0
    1d00:	99 27       	eor	r25, r25
    1d02:	96 95       	lsr	r25
    1d04:	87 95       	ror	r24
    1d06:	92 95       	swap	r25
    1d08:	82 95       	swap	r24
    1d0a:	8f 70       	andi	r24, 0x0F	; 15
    1d0c:	89 27       	eor	r24, r25
    1d0e:	9f 70       	andi	r25, 0x0F	; 15
    1d10:	89 27       	eor	r24, r25
    1d12:	81 70       	andi	r24, 0x01	; 1
    1d14:	90 70       	andi	r25, 0x00	; 0
    1d16:	82 17       	cp	r24, r18
    1d18:	93 07       	cpc	r25, r19
    1d1a:	81 f7       	brne	.-32     	; 0x1cfc
    1d1c:	80 e3       	ldi	r24, 0x30	; 48
    1d1e:	db ce       	rjmp	.-586    	; 0x1ad6

00001d20 <UART_send_HEX8>:
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
    1d20:	1f 93       	push	r17
    1d22:	18 2f       	mov	r17, r24
	UART_send_HEX4(lowb>>4);
    1d24:	82 95       	swap	r24
    1d26:	8f 70       	andi	r24, 0x0F	; 15
    1d28:	0e 94 09 0d 	call	0x1a12
	UART_send_HEX4(lowb & 0x0F);
    1d2c:	81 2f       	mov	r24, r17
    1d2e:	8f 70       	andi	r24, 0x0F	; 15
    1d30:	0e 94 09 0d 	call	0x1a12
    1d34:	1f 91       	pop	r17
    1d36:	08 95       	ret

00001d38 <UART_send_HEX16b>:
}

void UART_send_HEX16b(uint8_t highb, uint8_t lowb){
    1d38:	0f 93       	push	r16
    1d3a:	1f 93       	push	r17
    1d3c:	18 2f       	mov	r17, r24
    1d3e:	06 2f       	mov	r16, r22
    1d40:	82 95       	swap	r24
    1d42:	8f 70       	andi	r24, 0x0F	; 15
    1d44:	0e 94 09 0d 	call	0x1a12
    1d48:	81 2f       	mov	r24, r17
    1d4a:	8f 70       	andi	r24, 0x0F	; 15
    1d4c:	0e 94 09 0d 	call	0x1a12
    1d50:	80 2f       	mov	r24, r16
    1d52:	82 95       	swap	r24
    1d54:	8f 70       	andi	r24, 0x0F	; 15
    1d56:	0e 94 09 0d 	call	0x1a12
    1d5a:	80 2f       	mov	r24, r16
    1d5c:	8f 70       	andi	r24, 0x0F	; 15
    1d5e:	0e 94 09 0d 	call	0x1a12
    1d62:	1f 91       	pop	r17
    1d64:	0f 91       	pop	r16
    1d66:	08 95       	ret

00001d68 <UART_send_HEX16>:
	UART_send_HEX8(highb);
	UART_send_HEX8(lowb);
}

void UART_send_HEX16(uint16_t highb){
    1d68:	ef 92       	push	r14
    1d6a:	ff 92       	push	r15
    1d6c:	1f 93       	push	r17
    1d6e:	7c 01       	movw	r14, r24
	uint8_t blah;
	blah = (uint8_t)(highb>>8);
    1d70:	89 2f       	mov	r24, r25
    1d72:	99 27       	eor	r25, r25
    1d74:	f8 2e       	mov	r15, r24
    1d76:	82 95       	swap	r24
    1d78:	8f 70       	andi	r24, 0x0F	; 15
    1d7a:	0e 94 09 0d 	call	0x1a12
    1d7e:	8f 2d       	mov	r24, r15
    1d80:	8f 70       	andi	r24, 0x0F	; 15
    1d82:	0e 94 09 0d 	call	0x1a12
    1d86:	8e 2d       	mov	r24, r14
    1d88:	82 95       	swap	r24
    1d8a:	8f 70       	andi	r24, 0x0F	; 15
    1d8c:	0e 94 09 0d 	call	0x1a12
    1d90:	8e 2d       	mov	r24, r14
    1d92:	8f 70       	andi	r24, 0x0F	; 15
    1d94:	0e 94 09 0d 	call	0x1a12
    1d98:	1f 91       	pop	r17
    1d9a:	ff 90       	pop	r15
    1d9c:	ef 90       	pop	r14
    1d9e:	08 95       	ret

00001da0 <USRT_VIA_I2C>:
	UART_send_HEX8(blah);
	blah = (uint8_t)(highb & 0x00FF);
	UART_send_HEX8(blah);
}

inline void USRT_VIA_I2C(void){
	if ((usrt_rx_buffer[0] != 0x00) || (usrt_rx_buffer[1] != 0x00)){
    1da0:	90 91 2a 02 	lds	r25, 0x022A
    1da4:	99 23       	and	r25, r25
    1da6:	21 f4       	brne	.+8      	; 0x1db0
    1da8:	80 91 2b 02 	lds	r24, 0x022B
    1dac:	88 23       	and	r24, r24
    1dae:	39 f0       	breq	.+14     	; 0x1dbe
		i2c_enqueue(usrt_rx_buffer[0]);
    1db0:	89 2f       	mov	r24, r25
    1db2:	0e 94 79 05 	call	0xaf2
		i2c_enqueue(usrt_rx_buffer[1]);	
    1db6:	80 91 2b 02 	lds	r24, 0x022B
    1dba:	0e 94 79 05 	call	0xaf2
    1dbe:	08 95       	ret
    1dc0:	08 95       	ret

00001dc2 <__vector_18>:
	}
}

//Handle this event but immediately re-enable the interrupt so 
//	that we don't kill other real-time stuff like the data transmit encoder
SIGNAL(SIG_USART_RECV){
    1dc2:	1f 92       	push	r1
    1dc4:	0f 92       	push	r0
    1dc6:	0f b6       	in	r0, 0x3f	; 63
    1dc8:	0f 92       	push	r0
    1dca:	11 24       	eor	r1, r1
    1dcc:	2f 93       	push	r18
    1dce:	3f 93       	push	r19
    1dd0:	4f 93       	push	r20
    1dd2:	5f 93       	push	r21
    1dd4:	6f 93       	push	r22
    1dd6:	7f 93       	push	r23
    1dd8:	8f 93       	push	r24
    1dda:	9f 93       	push	r25
    1ddc:	af 93       	push	r26
    1dde:	bf 93       	push	r27
    1de0:	ef 93       	push	r30
    1de2:	ff 93       	push	r31

	if (usrt_rx_count > 0){
    1de4:	80 91 29 02 	lds	r24, 0x0229
    1de8:	88 23       	and	r24, r24
    1dea:	41 f4       	brne	.+16     	; 0x1dfc
		usrt_rx_buffer[1] = UDR0;
		usrt_rx_count = 0; //reset
		
		//USRT_VIA_I2C(); //xxx
		
		sei(); //re-enable interrupts since we aren't data sensitive anymore
		USRT_DATA_RX_ISR(usrt_rx_buffer[0], usrt_rx_buffer[1]);
	}
	else {
		usrt_rx_count++;
    1dec:	8f 5f       	subi	r24, 0xFF	; 255
    1dee:	80 93 29 02 	sts	0x0229, r24
		usrt_rx_buffer[0] = UDR0;
    1df2:	20 91 c6 00 	lds	r18, 0x00C6
    1df6:	20 93 2a 02 	sts	0x022A, r18
    1dfa:	0d c0       	rjmp	.+26     	; 0x1e16
    1dfc:	80 91 c6 00 	lds	r24, 0x00C6
    1e00:	80 93 2b 02 	sts	0x022B, r24
    1e04:	10 92 29 02 	sts	0x0229, r1
    1e08:	78 94       	sei
    1e0a:	60 91 2b 02 	lds	r22, 0x022B
    1e0e:	80 91 2a 02 	lds	r24, 0x022A
    1e12:	0e 94 9c 02 	call	0x538
    1e16:	ff 91       	pop	r31
    1e18:	ef 91       	pop	r30
    1e1a:	bf 91       	pop	r27
    1e1c:	af 91       	pop	r26
    1e1e:	9f 91       	pop	r25
    1e20:	8f 91       	pop	r24
    1e22:	7f 91       	pop	r23
    1e24:	6f 91       	pop	r22
    1e26:	5f 91       	pop	r21
    1e28:	4f 91       	pop	r20
    1e2a:	3f 91       	pop	r19
    1e2c:	2f 91       	pop	r18
    1e2e:	0f 90       	pop	r0
    1e30:	0f be       	out	0x3f, r0	; 63
    1e32:	0f 90       	pop	r0
    1e34:	1f 90       	pop	r1
    1e36:	18 95       	reti
