
irman.elf:     file format elf32-avr

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .data         0000001e  00800100  00000bc0  00000c54  2**0
                  CONTENTS, ALLOC, LOAD, DATA
  1 .text         00000bc0  00000000  00000000  00000094  2**1
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  2 .bss          0000003a  0080011e  0080011e  00000c72  2**0
                  ALLOC
  3 .noinit       00000000  00800158  00800158  00000c72  2**0
                  CONTENTS
  4 .eeprom       00000000  00810000  00810000  00000c72  2**0
                  CONTENTS
  5 .stab         000025a4  00000000  00000000  00000c74  2**2
                  CONTENTS, READONLY, DEBUGGING
  6 .stabstr      00000c64  00000000  00000000  00003218  2**0
                  CONTENTS, READONLY, DEBUGGING
Disassembly of section .text:

00000000 <__vectors>:
   0:	29 c0       	rjmp	.+82     	; 0x54
   2:	42 c0       	rjmp	.+132    	; 0x88
   4:	41 c0       	rjmp	.+130    	; 0x88
   6:	40 c0       	rjmp	.+128    	; 0x88
   8:	3f c0       	rjmp	.+126    	; 0x88
   a:	3e c0       	rjmp	.+124    	; 0x88
   c:	3d c0       	rjmp	.+122    	; 0x88
   e:	67 c3       	rjmp	.+1742   	; 0x6de
  10:	3b c0       	rjmp	.+118    	; 0x88
  12:	3a c0       	rjmp	.+116    	; 0x88
  14:	39 c0       	rjmp	.+114    	; 0x88
  16:	38 c0       	rjmp	.+112    	; 0x88
  18:	37 c0       	rjmp	.+110    	; 0x88
  1a:	36 c0       	rjmp	.+108    	; 0x88
  1c:	35 c0       	rjmp	.+106    	; 0x88
  1e:	34 c0       	rjmp	.+104    	; 0x88
  20:	33 c0       	rjmp	.+102    	; 0x88
  22:	32 c0       	rjmp	.+100    	; 0x88
  24:	31 c0       	rjmp	.+98     	; 0x88
  26:	30 c0       	rjmp	.+96     	; 0x88
  28:	2f c0       	rjmp	.+94     	; 0x88
  2a:	2e c0       	rjmp	.+92     	; 0x88
  2c:	2d c0       	rjmp	.+90     	; 0x88
  2e:	2c c0       	rjmp	.+88     	; 0x88
  30:	5a c5       	rjmp	.+2740   	; 0xae6
  32:	2a c0       	rjmp	.+84     	; 0x88

00000034 <__ctors_end>:
  34:	03 c5       	rjmp	.+2566   	; 0xa3c
  36:	ee c4       	rjmp	.+2524   	; 0xa14
  38:	d9 c4       	rjmp	.+2482   	; 0x9ec
  3a:	c4 c4       	rjmp	.+2440   	; 0x9c4
  3c:	af c4       	rjmp	.+2398   	; 0x99c
  3e:	9a c4       	rjmp	.+2356   	; 0x974
  40:	85 c4       	rjmp	.+2314   	; 0x94c
  42:	70 c4       	rjmp	.+2272   	; 0x924
  44:	5b c4       	rjmp	.+2230   	; 0x8fc
  46:	46 c4       	rjmp	.+2188   	; 0x8d4
  48:	31 c4       	rjmp	.+2146   	; 0x8ac
  4a:	1c c4       	rjmp	.+2104   	; 0x884
  4c:	07 c4       	rjmp	.+2062   	; 0x85c
  4e:	f2 c3       	rjmp	.+2020   	; 0x834
  50:	db c3       	rjmp	.+1974   	; 0x808
  52:	c4 c3       	rjmp	.+1928   	; 0x7dc

00000054 <__init>:
  54:	11 24       	eor	r1, r1
  56:	1f be       	out	0x3f, r1	; 63
  58:	cf ef       	ldi	r28, 0xFF	; 255
  5a:	d2 e0       	ldi	r29, 0x02	; 2
  5c:	de bf       	out	0x3e, r29	; 62
  5e:	cd bf       	out	0x3d, r28	; 61

00000060 <__do_copy_data>:
  60:	11 e0       	ldi	r17, 0x01	; 1
  62:	a0 e0       	ldi	r26, 0x00	; 0
  64:	b1 e0       	ldi	r27, 0x01	; 1
  66:	e0 ec       	ldi	r30, 0xC0	; 192
  68:	fb e0       	ldi	r31, 0x0B	; 11
  6a:	02 c0       	rjmp	.+4      	; 0x70

0000006c <.do_copy_data_loop>:
  6c:	05 90       	lpm	r0, Z+
  6e:	0d 92       	st	X+, r0

00000070 <.do_copy_data_start>:
  70:	ae 31       	cpi	r26, 0x1E	; 30
  72:	b1 07       	cpc	r27, r17
  74:	d9 f7       	brne	.-10     	; 0x6c

00000076 <__do_clear_bss>:
  76:	11 e0       	ldi	r17, 0x01	; 1
  78:	ae e1       	ldi	r26, 0x1E	; 30
  7a:	b1 e0       	ldi	r27, 0x01	; 1
  7c:	01 c0       	rjmp	.+2      	; 0x80

0000007e <.do_clear_bss_loop>:
  7e:	1d 92       	st	X+, r1

00000080 <.do_clear_bss_start>:
  80:	a8 35       	cpi	r26, 0x58	; 88
  82:	b1 07       	cpc	r27, r17
  84:	e1 f7       	brne	.-8      	; 0x7e
  86:	21 c0       	rjmp	.+66     	; 0xca

00000088 <__bad_interrupt>:
  88:	bb cf       	rjmp	.-138    	; 0x0

0000008a <init_mcu>:
	
  // Port D initialization
  // Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
  // State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
  PORTC=0x00;
  8a:	18 b8       	out	0x08, r1	; 8
  DDRC = 0xFE;
  8c:	2e ef       	ldi	r18, 0xFE	; 254
  8e:	27 b9       	out	0x07, r18	; 7
  PORTD=0x00;
  90:	1b b8       	out	0x0b, r1	; 11
  DDRD=0x00;
  92:	1a b8       	out	0x0a, r1	; 10
		
  // Timer/Counter 0 initialization
  // Clock source: System Clock
  // Clock value: Timer 0 Stopped
  // Mode: Normal top=FFh
  // OC0 output: Disconnected
  ASSR=0x00;
  94:	10 92 b6 00 	sts	0x00B6, r1
  TCNT0=0x00;
  98:	16 bc       	out	0x26, r1	; 38
	
	
	
  // External Interrupt(s) initialization
  // INT0: Off
  // INT1: Off
  // INT2: Off
  // INT3: Off
  // INT4: Off
  // INT5: Off
  // INT6: Off
  // INT7: Off
  EIMSK=0x00;
  9a:	1d ba       	out	0x1d, r1	; 29
	
  // Analog Comparator initialization
  // Analog Comparator: Off
  // Analog Comparator Input Capture by Timer/Counter 1: Off
  // Analog Comparator Output: Off
  ACSR=0x80;
  9c:	80 e8       	ldi	r24, 0x80	; 128
  9e:	80 bf       	out	0x30, r24	; 48
  a0:	08 95       	ret

000000a2 <stall>:
} //init_MCU


void stall(uint16_t limit){
  uint16_t blah, i, j;
  blah=0;
  a2:	40 e0       	ldi	r20, 0x00	; 0
  a4:	50 e0       	ldi	r21, 0x00	; 0
  for(i=0;i<0xFFFF;i++){
    for(j=0;j<limit;j++){
  a6:	00 97       	sbiw	r24, 0x00	; 0
  a8:	21 f0       	breq	.+8      	; 0xb2
  aa:	9c 01       	movw	r18, r24
  ac:	21 50       	subi	r18, 0x01	; 1
  ae:	30 40       	sbci	r19, 0x00	; 0
  b0:	e9 f7       	brne	.-6      	; 0xac
  b2:	4f 5f       	subi	r20, 0xFF	; 255
  b4:	5f 4f       	sbci	r21, 0xFF	; 255
  b6:	2f ef       	ldi	r18, 0xFF	; 255
  b8:	4f 3f       	cpi	r20, 0xFF	; 255
  ba:	52 07       	cpc	r21, r18
  bc:	a1 f7       	brne	.-24     	; 0xa6
  be:	08 95       	ret

000000c0 <stk_ledon>:
      blah++;
    }
  }	
}


void stk_ledon(uint8_t num){
  c0:	98 2f       	mov	r25, r24
	DDRB = 0xFF;
  c2:	8f ef       	ldi	r24, 0xFF	; 255
  c4:	84 b9       	out	0x04, r24	; 4
	PORTB = num;
  c6:	95 b9       	out	0x05, r25	; 5
  c8:	08 95       	ret

000000ca <main>:
}

int main(void){
  ca:	ce ef       	ldi	r28, 0xFE	; 254
  cc:	d2 e0       	ldi	r29, 0x02	; 2
  ce:	de bf       	out	0x3e, r29	; 62
  d0:	cd bf       	out	0x3d, r28	; 61
  d2:	18 b8       	out	0x08, r1	; 8
  d4:	3e ef       	ldi	r19, 0xFE	; 254
  d6:	37 b9       	out	0x07, r19	; 7
  d8:	1b b8       	out	0x0b, r1	; 11
  da:	1a b8       	out	0x0a, r1	; 10
  dc:	10 92 b6 00 	sts	0x00B6, r1
  e0:	16 bc       	out	0x26, r1	; 38
  e2:	1d ba       	out	0x1d, r1	; 29
  e4:	20 e8       	ldi	r18, 0x80	; 128
  e6:	20 bf       	out	0x30, r18	; 48
	volatile uint8_t dq_p;
	init_mcu();
	init_serial();
  e8:	44 d3       	rcall	.+1672   	; 0x772
	//sei(); //enable interrupts (go live)
	cli();
  ea:	f8 94       	cli
	//init_irclock();
	//air_led_medium();
	sbi(DDRC,5); //RTOS timing indicator
  ec:	3d 9a       	sbi	0x07, 5	; 7
	cbi(DDRC,3); //pushbutton
  ee:	3b 98       	cbi	0x07, 3	; 7
	start_irclock();
  f0:	23 d1       	rcall	.+582    	; 0x338
  f2:	8f ef       	ldi	r24, 0xFF	; 255
  f4:	84 b9       	out	0x04, r24	; 4
  f6:	85 b9       	out	0x05, r24	; 5
	stk_ledon(0xFF); //LED's off
	air_init();
  f8:	4c d1       	rcall	.+664    	; 0x392
	dq_p = 0;
  fa:	19 82       	std	Y+1, r1	; 0x01
  	while(1){
		sbi(PORTC,5);
  fc:	45 9a       	sbi	0x08, 5	; 8
		air_sample();
  fe:	61 d1       	rcall	.+706    	; 0x3c2
		dq_p++;
 100:	59 81       	ldd	r21, Y+1	; 0x01
 102:	5f 5f       	subi	r21, 0xFF	; 255
 104:	59 83       	std	Y+1, r21	; 0x01
		air_read_channel(0);//0
 106:	80 e0       	ldi	r24, 0x00	; 0
 108:	db d1       	rcall	.+950    	; 0x4c0
		air_read_channel(1);//1
 10a:	81 e0       	ldi	r24, 0x01	; 1
 10c:	d9 d1       	rcall	.+946    	; 0x4c0
		air_read_channel(2);//2
 10e:	82 e0       	ldi	r24, 0x02	; 2
 110:	d7 d1       	rcall	.+942    	; 0x4c0
		air_read_channel(3);//3
 112:	83 e0       	ldi	r24, 0x03	; 3
 114:	d5 d1       	rcall	.+938    	; 0x4c0
		air_read_channel(4);//4
 116:	84 e0       	ldi	r24, 0x04	; 4
 118:	d3 d1       	rcall	.+934    	; 0x4c0
		air_read_channel(5);//5
 11a:	85 e0       	ldi	r24, 0x05	; 5
 11c:	d1 d1       	rcall	.+930    	; 0x4c0
		air_read_channel(6);//6
 11e:	86 e0       	ldi	r24, 0x06	; 6
 120:	cf d1       	rcall	.+926    	; 0x4c0
		if (dq_p == DQ_PERIOD){
 122:	49 81       	ldd	r20, Y+1	; 0x01
 124:	41 30       	cpi	r20, 0x01	; 1
 126:	39 f0       	breq	.+14     	; 0x136
			dq_p = 0;
			air_dequeue();
		}
		cbi(PORTC,5);
 128:	45 98       	cbi	0x08, 5	; 8
		//stk_ledon(TIFR0);
		
		while(TIFR0 == B8(00000101)); // wait for loop timer to expire
 12a:	65 b3       	in	r22, 0x15	; 21
 12c:	65 30       	cpi	r22, 0x05	; 5
 12e:	e9 f3       	breq	.-6      	; 0x12a
		TIFR0 = B8(00000010); //clear OCR0A flag (by writing 1 to it - Atmel's wackiness), but leave others set
 130:	72 e0       	ldi	r23, 0x02	; 2
 132:	75 bb       	out	0x15, r23	; 21
 134:	e3 cf       	rjmp	.-58     	; 0xfc
 136:	19 82       	std	Y+1, r1	; 0x01
 138:	a3 d1       	rcall	.+838    	; 0x480
 13a:	f6 cf       	rjmp	.-20     	; 0x128

0000013c <init_motor>:
 13c:	55 9a       	sbi	0x0a, 5	; 10
 13e:	56 9a       	sbi	0x0a, 6	; 10
 140:	20 9a       	sbi	0x04, 0	; 4
 142:	21 9a       	sbi	0x04, 1	; 4
 144:	24 b5       	in	r18, 0x24	; 36
 146:	2d 7f       	andi	r18, 0xFD	; 253
 148:	24 bd       	out	0x24, r18	; 36
 14a:	84 b5       	in	r24, 0x24	; 36
 14c:	81 60       	ori	r24, 0x01	; 1
 14e:	84 bd       	out	0x24, r24	; 36
 150:	08 95       	ret

00000152 <move>:
		
		/*
		UART_send_HEX8(i2c_buffer);
		send_byte_serial(10);
		send_byte_serial(13);*/
	}
} //main
 152:	99 27       	eor	r25, r25
 154:	84 30       	cpi	r24, 0x04	; 4
 156:	91 05       	cpc	r25, r1
 158:	61 f1       	breq	.+88     	; 0x1b2
 15a:	85 30       	cpi	r24, 0x05	; 5
 15c:	91 05       	cpc	r25, r1
 15e:	e4 f4       	brge	.+56     	; 0x198
 160:	82 30       	cpi	r24, 0x02	; 2
 162:	91 05       	cpc	r25, r1
 164:	09 f4       	brne	.+2      	; 0x168
 166:	69 c0       	rjmp	.+210    	; 0x23a
 168:	83 30       	cpi	r24, 0x03	; 3
 16a:	91 05       	cpc	r25, r1
 16c:	0c f0       	brlt	.+2      	; 0x170
 16e:	5f c0       	rjmp	.+190    	; 0x22e
 170:	01 97       	sbiw	r24, 0x01	; 1
 172:	09 f4       	brne	.+2      	; 0x176
 174:	77 c0       	rjmp	.+238    	; 0x264
 176:	84 b5       	in	r24, 0x24	; 36
 178:	8f 77       	andi	r24, 0x7F	; 127
 17a:	84 bd       	out	0x24, r24	; 36
 17c:	5e 98       	cbi	0x0b, 6	; 11
 17e:	77 27       	eor	r23, r23
 180:	64 30       	cpi	r22, 0x04	; 4
 182:	71 05       	cpc	r23, r1
 184:	11 f5       	brne	.+68     	; 0x1ca
 186:	29 9a       	sbi	0x05, 1	; 5
 188:	80 ea       	ldi	r24, 0xA0	; 160
 18a:	88 bd       	out	0x28, r24	; 40
 18c:	64 b5       	in	r22, 0x24	; 36
 18e:	60 62       	ori	r22, 0x20	; 32
 190:	64 bd       	out	0x24, r22	; 36
 192:	55 e0       	ldi	r21, 0x05	; 5
 194:	55 bd       	out	0x25, r21	; 37
 196:	08 95       	ret
 198:	86 30       	cpi	r24, 0x06	; 6
 19a:	91 05       	cpc	r25, r1
 19c:	09 f4       	brne	.+2      	; 0x1a0
 19e:	50 c0       	rjmp	.+160    	; 0x240
 1a0:	86 30       	cpi	r24, 0x06	; 6
 1a2:	91 05       	cpc	r25, r1
 1a4:	0c f4       	brge	.+2      	; 0x1a8
 1a6:	46 c0       	rjmp	.+140    	; 0x234
 1a8:	07 97       	sbiw	r24, 0x07	; 7
 1aa:	29 f7       	brne	.-54     	; 0x176
 1ac:	28 98       	cbi	0x05, 0	; 5
 1ae:	8f ef       	ldi	r24, 0xFF	; 255
 1b0:	02 c0       	rjmp	.+4      	; 0x1b6
 1b2:	28 98       	cbi	0x05, 0	; 5
 1b4:	80 ea       	ldi	r24, 0xA0	; 160
 1b6:	87 bd       	out	0x27, r24	; 39
 1b8:	34 b5       	in	r19, 0x24	; 36
 1ba:	30 68       	ori	r19, 0x80	; 128
 1bc:	34 bd       	out	0x24, r19	; 36
 1be:	25 e0       	ldi	r18, 0x05	; 5
 1c0:	25 bd       	out	0x25, r18	; 37
 1c2:	77 27       	eor	r23, r23
 1c4:	64 30       	cpi	r22, 0x04	; 4
 1c6:	71 05       	cpc	r23, r1
 1c8:	f1 f2       	breq	.-68     	; 0x186
 1ca:	65 30       	cpi	r22, 0x05	; 5
 1cc:	71 05       	cpc	r23, r1
 1ce:	64 f4       	brge	.+24     	; 0x1e8
 1d0:	62 30       	cpi	r22, 0x02	; 2
 1d2:	71 05       	cpc	r23, r1
 1d4:	09 f4       	brne	.+2      	; 0x1d8
 1d6:	40 c0       	rjmp	.+128    	; 0x258
 1d8:	63 30       	cpi	r22, 0x03	; 3
 1da:	71 05       	cpc	r23, r1
 1dc:	fc f4       	brge	.+62     	; 0x21c
 1de:	61 30       	cpi	r22, 0x01	; 1
 1e0:	71 05       	cpc	r23, r1
 1e2:	59 f4       	brne	.+22     	; 0x1fa
 1e4:	29 98       	cbi	0x05, 1	; 5
 1e6:	d0 cf       	rjmp	.-96     	; 0x188
 1e8:	66 30       	cpi	r22, 0x06	; 6
 1ea:	71 05       	cpc	r23, r1
 1ec:	61 f1       	breq	.+88     	; 0x246
 1ee:	66 30       	cpi	r22, 0x06	; 6
 1f0:	71 05       	cpc	r23, r1
 1f2:	5c f0       	brlt	.+22     	; 0x20a
 1f4:	67 30       	cpi	r22, 0x07	; 7
 1f6:	71 05       	cpc	r23, r1
 1f8:	91 f1       	breq	.+100    	; 0x25e
 1fa:	44 b5       	in	r20, 0x24	; 36
 1fc:	4f 7d       	andi	r20, 0xDF	; 223
 1fe:	44 bd       	out	0x24, r20	; 36
 200:	04 b4       	in	r0, 0x24	; 36
 202:	07 fe       	sbrs	r0, 7
 204:	15 bc       	out	0x25, r1	; 37
 206:	5e 98       	cbi	0x0b, 6	; 11
 208:	08 95       	ret
 20a:	29 9a       	sbi	0x05, 1	; 5
 20c:	8e eb       	ldi	r24, 0xBE	; 190
 20e:	88 bd       	out	0x28, r24	; 40
 210:	64 b5       	in	r22, 0x24	; 36
 212:	60 62       	ori	r22, 0x20	; 32
 214:	64 bd       	out	0x24, r22	; 36
 216:	55 e0       	ldi	r21, 0x05	; 5
 218:	55 bd       	out	0x25, r21	; 37
 21a:	08 95       	ret
 21c:	29 98       	cbi	0x05, 1	; 5
 21e:	8f ef       	ldi	r24, 0xFF	; 255
 220:	88 bd       	out	0x28, r24	; 40
 222:	64 b5       	in	r22, 0x24	; 36
 224:	60 62       	ori	r22, 0x20	; 32
 226:	64 bd       	out	0x24, r22	; 36
 228:	55 e0       	ldi	r21, 0x05	; 5
 22a:	55 bd       	out	0x25, r21	; 37
 22c:	08 95       	ret
 22e:	28 9a       	sbi	0x05, 0	; 5
 230:	8f ef       	ldi	r24, 0xFF	; 255
 232:	c1 cf       	rjmp	.-126    	; 0x1b6
 234:	28 98       	cbi	0x05, 0	; 5
 236:	8e eb       	ldi	r24, 0xBE	; 190
 238:	be cf       	rjmp	.-132    	; 0x1b6
 23a:	28 9a       	sbi	0x05, 0	; 5
 23c:	87 ed       	ldi	r24, 0xD7	; 215
 23e:	bb cf       	rjmp	.-138    	; 0x1b6
 240:	28 98       	cbi	0x05, 0	; 5
 242:	87 ed       	ldi	r24, 0xD7	; 215
 244:	b8 cf       	rjmp	.-144    	; 0x1b6
 246:	29 9a       	sbi	0x05, 1	; 5
 248:	87 ed       	ldi	r24, 0xD7	; 215
 24a:	88 bd       	out	0x28, r24	; 40
 24c:	64 b5       	in	r22, 0x24	; 36
 24e:	60 62       	ori	r22, 0x20	; 32
 250:	64 bd       	out	0x24, r22	; 36
 252:	55 e0       	ldi	r21, 0x05	; 5
 254:	55 bd       	out	0x25, r21	; 37
 256:	08 95       	ret
 258:	29 98       	cbi	0x05, 1	; 5
 25a:	87 ed       	ldi	r24, 0xD7	; 215
 25c:	f6 cf       	rjmp	.-20     	; 0x24a
 25e:	29 9a       	sbi	0x05, 1	; 5
 260:	8f ef       	ldi	r24, 0xFF	; 255
 262:	de cf       	rjmp	.-68     	; 0x220
 264:	28 9a       	sbi	0x05, 0	; 5
 266:	a6 cf       	rjmp	.-180    	; 0x1b4

00000268 <motor_parse>:
 268:	68 2f       	mov	r22, r24
 26a:	80 7c       	andi	r24, 0xC0	; 192
 26c:	09 f0       	breq	.+2      	; 0x270
 26e:	08 95       	ret
 270:	86 2f       	mov	r24, r22
 272:	99 27       	eor	r25, r25
 274:	88 73       	andi	r24, 0x38	; 56
 276:	90 70       	andi	r25, 0x00	; 0
 278:	95 95       	asr	r25
 27a:	87 95       	ror	r24
 27c:	95 95       	asr	r25
 27e:	87 95       	ror	r24
 280:	95 95       	asr	r25
 282:	87 95       	ror	r24
 284:	67 70       	andi	r22, 0x07	; 7
 286:	65 df       	rcall	.-310    	; 0x152
 288:	08 95       	ret
 28a:	08 95       	ret

0000028c <init_CB4>:
 28c:	41 9a       	sbi	0x08, 1	; 8
 28e:	39 9a       	sbi	0x07, 1	; 7
 290:	3b 9a       	sbi	0x07, 3	; 7
 292:	57 9a       	sbi	0x0a, 7	; 10
 294:	3a 9a       	sbi	0x07, 2	; 7
 296:	10 92 3e 01 	sts	0x013E, r1
 29a:	08 95       	ret

0000029c <reset_CB4>:
 29c:	41 98       	cbi	0x08, 1	; 8
	...
 2a6:	41 9a       	sbi	0x08, 1	; 8
 2a8:	08 95       	ret

000002aa <update_CB2_1B>:
 2aa:	98 2f       	mov	r25, r24
 2ac:	27 e0       	ldi	r18, 0x07	; 7
 2ae:	02 c0       	rjmp	.+4      	; 0x2b4
 2b0:	5f 98       	cbi	0x0b, 7	; 11
 2b2:	06 c0       	rjmp	.+12     	; 0x2c0
 2b4:	43 98       	cbi	0x08, 3	; 8
 2b6:	89 2f       	mov	r24, r25
 2b8:	80 78       	andi	r24, 0x80	; 128
 2ba:	80 38       	cpi	r24, 0x80	; 128
 2bc:	c9 f7       	brne	.-14     	; 0x2b0
 2be:	5f 9a       	sbi	0x0b, 7	; 11
 2c0:	99 0f       	add	r25, r25
 2c2:	43 9a       	sbi	0x08, 3	; 8
	...
 2cc:	21 50       	subi	r18, 0x01	; 1
 2ce:	27 ff       	sbrs	r18, 7
 2d0:	f1 cf       	rjmp	.-30     	; 0x2b4
 2d2:	08 95       	ret

000002d4 <load_CB4>:
 2d4:	41 98       	cbi	0x08, 1	; 8
	...
 2de:	41 9a       	sbi	0x08, 1	; 8
 2e0:	42 98       	cbi	0x08, 2	; 8
 2e2:	90 91 3e 01 	lds	r25, 0x013E
 2e6:	27 e0       	ldi	r18, 0x07	; 7
 2e8:	0a c0       	rjmp	.+20     	; 0x2fe
 2ea:	5f 98       	cbi	0x0b, 7	; 11
 2ec:	99 0f       	add	r25, r25
 2ee:	43 9a       	sbi	0x08, 3	; 8
	...
 2f8:	21 50       	subi	r18, 0x01	; 1
 2fa:	27 fd       	sbrc	r18, 7
 2fc:	07 c0       	rjmp	.+14     	; 0x30c
 2fe:	43 98       	cbi	0x08, 3	; 8
 300:	89 2f       	mov	r24, r25
 302:	80 78       	andi	r24, 0x80	; 128
 304:	80 38       	cpi	r24, 0x80	; 128
 306:	89 f7       	brne	.-30     	; 0x2ea
 308:	5f 9a       	sbi	0x0b, 7	; 11
 30a:	f0 cf       	rjmp	.-32     	; 0x2ec
	...
 314:	43 98       	cbi	0x08, 3	; 8
	...
 31e:	42 9a       	sbi	0x08, 2	; 8
 320:	08 95       	ret

00000322 <init_array>:
static uint8_t q_sym[7][4] = {{0x00,0x01,0x02,0x03},{0x00,0x04,0x05,0x06},{0x00,0x07,0x08,0x09},{0x00,0x0A,0x0B,0x0C},{0x00,0x01,0x02,0x03},{0x00,0x04,0x05,0x06},{0x00,0x07,0x08,0x09}};

void init_array(uint8_t* toinit, uint8_t size, uint8_t init_val){
	uint8_t i;
	for (i=0;i<size;i++){
 322:	66 23       	and	r22, r22
 324:	21 f0       	breq	.+8      	; 0x32e
 326:	fc 01       	movw	r30, r24
		toinit[i] = init_val;
 328:	41 93       	st	Z+, r20
 32a:	61 50       	subi	r22, 0x01	; 1
 32c:	e9 f7       	brne	.-6      	; 0x328
 32e:	08 95       	ret

00000330 <debug_pb>:
	}
}

void inline debug_pb(){
	while((PINC & B8(00001000)) != 0x00);	
 330:	33 99       	sbic	0x06, 3	; 6
 332:	fe cf       	rjmp	.-4      	; 0x330
 334:	08 95       	ret

00000336 <reset_irclock>:
}

//----------------------------------------------------------------
//- IR CLOCK
//----------------------------------------------------------------

inline void reset_irclock(){
 336:	08 95       	ret

00000338 <start_irclock>:
	
}

//NEW: jonathan
inline void start_irclock(){
	//8MHz:: OCR0A = 120; //1/8e6MHz * 8 (prescale) * OCR0A = period in seconds (for these values 8/8=1, so OCR0A = period in uS)
	//OCR0A = 180; //for 16MHz clock; 180= 90uS period
	OCR0A = 140; //for 16MHz clock; 100 = 50uS period; 140 = 70uS period
 338:	3c e8       	ldi	r19, 0x8C	; 140
 33a:	37 bd       	out	0x27, r19	; 39
	OCR0B = 0x00; //min out the compare registers so that the interrupt flag register is easier for GCC to read (bits will always be 1 so TIFR0 = B4(0110) if no overflow)
 33c:	18 bc       	out	0x28, r1	; 40
	TCNT0 = 0xFF; //start with overflow flag set to make GCC processing of byte easier
 33e:	2f ef       	ldi	r18, 0xFF	; 255
 340:	26 bd       	out	0x26, r18	; 38
	TCCR0A = B8(00000010); //CTC MODE, NO I/O BEHAVIORS
 342:	82 e0       	ldi	r24, 0x02	; 2
 344:	84 bd       	out	0x24, r24	; 36
	TCCR0B = B8(00000010); //8MHZ CLOCK / 8 = 256uS PER PERIOD
 346:	85 bd       	out	0x25, r24	; 37
 348:	08 95       	ret

0000034a <stop_irclock>:
}

//NEW: jonathan
inline void stop_irclock(){
	TCCR0B = B8(00000000); //NO CLOCK SOURCE = STOPPED
 34a:	15 bc       	out	0x25, r1	; 37
 34c:	08 95       	ret

0000034e <disable_output_irclock>:
}

inline void disable_output_irclock(){
  TCCR2A = B8(00100010); //OC2A=off,OC2B=clear on compare,Mode = CTC
 34e:	82 e2       	ldi	r24, 0x22	; 34
 350:	80 93 b0 00 	sts	0x00B0, r24
 354:	08 95       	ret

00000356 <enable_output_irclock>:
}

inline void enable_output_irclock(){
  TCCR2A = B8(00010010); //OC2A=off,OC2B=toggle on compare,Mode = CTC
 356:	82 e1       	ldi	r24, 0x12	; 18
 358:	80 93 b0 00 	sts	0x00B0, r24
 35c:	08 95       	ret

0000035e <init_irclock>:
}

//This init routine actually begins operation (as soon as interrupts get enabled)
//LED_ENCODE is OC2B
void init_irclock() 
{
  cbi(PORTD, 3); //so that disabled OCR2B = 0 on output
 35e:	5b 98       	cbi	0x0b, 3	; 11
  cbi(ASSR, 5); //clock from MCU mainline clock (8MHz)
 360:	50 91 b6 00 	lds	r21, 0x00B6
 364:	5f 7d       	andi	r21, 0xDF	; 223
 366:	50 93 b6 00 	sts	0x00B6, r21
 36a:	42 e1       	ldi	r20, 0x12	; 18
 36c:	40 93 b0 00 	sts	0x00B0, r20
  enable_output_irclock();
  TCCR2B = B8(00000001); //enable timer with 128 prescaler = 62.5kHz
 370:	31 e0       	ldi	r19, 0x01	; 1
 372:	30 93 b1 00 	sts	0x00B1, r19
  OCR2A = 98; //toggle after 12.5mS -> 25mS period = 40kHz freq
 376:	22 e6       	ldi	r18, 0x62	; 98
 378:	20 93 b3 00 	sts	0x00B3, r18
  TIMSK2 = B8(00000010); //enable OCR2B interrupt
 37c:	82 e0       	ldi	r24, 0x02	; 2
 37e:	80 93 70 00 	sts	0x0070, r24
  TIFR2;
 382:	87 b3       	in	r24, 0x17	; 23
  sbi(DDRD, 3); //OCR2B as output
 384:	53 9a       	sbi	0x0a, 3	; 10
 386:	08 95       	ret

00000388 <air_led_low>:
}	


//----------------------------------------------------------------
//- IR RING DETECTOR - AIR SYSTEM
//----------------------------------------------------------------

void air_led_low()
{
 388:	08 95       	ret

0000038a <air_led_medium>:

}

void air_led_medium()
{
 38a:	08 95       	ret

0000038c <air_led_high>:
 
}

void air_led_high()
{
 38c:	08 95       	ret

0000038e <air_led_fire>:

}

//"weapon" led on HEAD module
void air_led_fire()
{
 38e:	08 95       	ret

00000390 <air_led_off>:
 
}

void air_led_off()
{
 390:	08 95       	ret

00000392 <air_init>:
 
}


//----------------------------------------------------------------
//- PHYS/MAC LAYERS - AIR SYSTEM
//----------------------------------------------------------------

#define PORTAIR PINC
//the maximum period of a good symbol in number of samples
#define AIR_MAX_VALID_PERIOD 30

inline void air_init(){
 392:	e8 e2       	ldi	r30, 0x28	; 40
 394:	f1 e0       	ldi	r31, 0x01	; 1
 396:	86 e0       	ldi	r24, 0x06	; 6
 398:	11 92       	st	Z+, r1
 39a:	81 50       	subi	r24, 0x01	; 1
 39c:	87 ff       	sbrs	r24, 7
 39e:	fc cf       	rjmp	.-8      	; 0x398
 3a0:	ef e2       	ldi	r30, 0x2F	; 47
 3a2:	f1 e0       	ldi	r31, 0x01	; 1
 3a4:	86 e0       	ldi	r24, 0x06	; 6
 3a6:	11 92       	st	Z+, r1
 3a8:	81 50       	subi	r24, 0x01	; 1
 3aa:	87 ff       	sbrs	r24, 7
 3ac:	fc cf       	rjmp	.-8      	; 0x3a6
 3ae:	e1 e2       	ldi	r30, 0x21	; 33
 3b0:	f1 e0       	ldi	r31, 0x01	; 1
 3b2:	86 e0       	ldi	r24, 0x06	; 6
 3b4:	11 92       	st	Z+, r1
 3b6:	81 50       	subi	r24, 0x01	; 1
 3b8:	87 ff       	sbrs	r24, 7
 3ba:	fc cf       	rjmp	.-8      	; 0x3b4
	init_array(p_state, NUM__OF_CHANNELS, S0);
	init_array(m_state, NUM__OF_CHANNELS, S0);
	init_array(air_buffer, NUM__OF_CHANNELS, 0x00);
	q_level = 0x00; //all enqueue-ing begins at level 0
 3bc:	10 92 20 01 	sts	0x0120, r1
 3c0:	08 95       	ret

000003c2 <air_sample>:
}

inline void air_sample(){
	air_capture = PORTAIR;
	
	//DEBUG - clone channels
	if ((air_capture & _BV(0)) == 0x00) {
 3c2:	30 99       	sbic	0x06, 0	; 6
 3c4:	03 c0       	rjmp	.+6      	; 0x3cc
		air_capture = 0x00;
 3c6:	10 92 1f 01 	sts	0x011F, r1
 3ca:	08 95       	ret
	}
	else {
		air_capture = 0xFF;
 3cc:	8f ef       	ldi	r24, 0xFF	; 255
 3ce:	80 93 1f 01 	sts	0x011F, r24
 3d2:	08 95       	ret
 3d4:	08 95       	ret

000003d6 <air_enqueue>:
	}
	//stk_ledon(air_capture);
}

inline void air_enqueue(uint8_t channel_num, uint8_t symbol){
	if (channel_num < 4) {
 3d6:	84 30       	cpi	r24, 0x04	; 4
 3d8:	c8 f4       	brcc	.+50     	; 0x40c
	//for channels 0-3
		if (m_state[channel_num] == 0x00){
 3da:	e8 2f       	mov	r30, r24
 3dc:	ff 27       	eor	r31, r31
 3de:	df 01       	movw	r26, r30
 3e0:	a1 5d       	subi	r26, 0xD1	; 209
 3e2:	be 4f       	sbci	r27, 0xFE	; 254
 3e4:	8c 91       	ld	r24, X
 3e6:	88 23       	and	r24, r24
 3e8:	d1 f5       	brne	.+116    	; 0x45e
		//Write to buffer level 0
			m_state[channel_num] = 0x01; //move pointer to next buffer level
 3ea:	31 e0       	ldi	r19, 0x01	; 1
 3ec:	3c 93       	st	X, r19
			air_buffer[0] |= q_sym[channel_num][symbol]; //table look-up implementation for both bytes; assumes buffer cleared to INVD (0x00) and buffer overwrite can't occur except over INVD
 3ee:	ee 0f       	add	r30, r30
 3f0:	ff 1f       	adc	r31, r31
 3f2:	ee 0f       	add	r30, r30
 3f4:	ff 1f       	adc	r31, r31
 3f6:	e6 0f       	add	r30, r22
 3f8:	f1 1d       	adc	r31, r1
 3fa:	e0 50       	subi	r30, 0x00	; 0
 3fc:	ff 4f       	sbci	r31, 0xFF	; 255
 3fe:	20 91 21 01 	lds	r18, 0x0121
 402:	90 81       	ld	r25, Z
 404:	29 2b       	or	r18, r25
 406:	20 93 21 01 	sts	0x0121, r18
 40a:	08 95       	ret
		}
		else{
		//Write to buffer level 1
			m_state[channel_num] = 0x00; //move pointer to next buffer level
			air_buffer[2] |= q_sym[channel_num][symbol]; //table look-up implementation for both bytes; assumes buffer cleared to INVD (0x00) and buffer overwrite can't occur except over INVD
		}
	} //if channels 0-3
	else {
	//Channels 4-7 (4-6 for Ragobot B1,B2)
		if (m_state[channel_num] == 0x00){
 40c:	e8 2f       	mov	r30, r24
 40e:	ff 27       	eor	r31, r31
 410:	df 01       	movw	r26, r30
 412:	a1 5d       	subi	r26, 0xD1	; 209
 414:	be 4f       	sbci	r27, 0xFE	; 254
 416:	7c 91       	ld	r23, X
 418:	77 23       	and	r23, r23
 41a:	89 f4       	brne	.+34     	; 0x43e
		//Write to buffer level 0
			m_state[channel_num] = 0x01; //move pointer to next buffer level
 41c:	81 e0       	ldi	r24, 0x01	; 1
 41e:	8c 93       	st	X, r24
			air_buffer[1] |= q_sym[channel_num][symbol]; //table look-up implementation for both bytes; assumes buffer cleared to INVD (0x00) and buffer overwrite can't occur except over INVD
 420:	ee 0f       	add	r30, r30
 422:	ff 1f       	adc	r31, r31
 424:	ee 0f       	add	r30, r30
 426:	ff 1f       	adc	r31, r31
 428:	e6 0f       	add	r30, r22
 42a:	f1 1d       	adc	r31, r1
 42c:	e0 50       	subi	r30, 0x00	; 0
 42e:	ff 4f       	sbci	r31, 0xFF	; 255
 430:	60 91 22 01 	lds	r22, 0x0122
 434:	a0 81       	ld	r26, Z
 436:	6a 2b       	or	r22, r26
 438:	60 93 22 01 	sts	0x0122, r22
 43c:	08 95       	ret
		}
		else{
		//Write to buffer level 1
			m_state[channel_num] = 0x00; //move pointer to next buffer level
 43e:	1c 92       	st	X, r1
			air_buffer[3] |= q_sym[channel_num][symbol]; //table look-up implementation for both bytes; assumes buffer cleared to INVD (0x00) and buffer overwrite can't occur except over INVD
 440:	ee 0f       	add	r30, r30
 442:	ff 1f       	adc	r31, r31
 444:	ee 0f       	add	r30, r30
 446:	ff 1f       	adc	r31, r31
 448:	e6 0f       	add	r30, r22
 44a:	f1 1d       	adc	r31, r1
 44c:	e0 50       	subi	r30, 0x00	; 0
 44e:	ff 4f       	sbci	r31, 0xFF	; 255
 450:	b0 91 24 01 	lds	r27, 0x0124
 454:	20 81       	ld	r18, Z
 456:	b2 2b       	or	r27, r18
 458:	b0 93 24 01 	sts	0x0124, r27
 45c:	08 95       	ret
 45e:	1c 92       	st	X, r1
 460:	ee 0f       	add	r30, r30
 462:	ff 1f       	adc	r31, r31
 464:	ee 0f       	add	r30, r30
 466:	ff 1f       	adc	r31, r31
 468:	e6 0f       	add	r30, r22
 46a:	f1 1d       	adc	r31, r1
 46c:	e0 50       	subi	r30, 0x00	; 0
 46e:	ff 4f       	sbci	r31, 0xFF	; 255
 470:	40 91 23 01 	lds	r20, 0x0123
 474:	50 81       	ld	r21, Z
 476:	45 2b       	or	r20, r21
 478:	40 93 23 01 	sts	0x0123, r20
 47c:	08 95       	ret
 47e:	08 95       	ret

00000480 <air_dequeue>:
		}
	}// channels 4-7
}

//RELIES ON UART0.C FUNCTIONS!!!
inline void air_dequeue(){
 480:	cf 93       	push	r28
	if (q_level == 0x00){
 482:	c0 91 20 01 	lds	r28, 0x0120
 486:	cc 23       	and	r28, r28
 488:	71 f4       	brne	.+28     	; 0x4a6
		q_level++;
 48a:	cf 5f       	subi	r28, 0xFF	; 255
 48c:	c0 93 20 01 	sts	0x0120, r28
 490:	c1 50       	subi	r28, 0x01	; 1
		USRT_send_2bytes(air_buffer[0], air_buffer[1]);
 492:	60 91 22 01 	lds	r22, 0x0122
 496:	80 91 21 01 	lds	r24, 0x0121
 49a:	7b d1       	rcall	.+758    	; 0x792
		air_buffer[0] = 0x00;
 49c:	c0 93 21 01 	sts	0x0121, r28
		air_buffer[1] = 0x00;
 4a0:	c0 93 22 01 	sts	0x0122, r28
 4a4:	0b c0       	rjmp	.+22     	; 0x4bc
	}
	else{
		q_level = 0x00;
 4a6:	10 92 20 01 	sts	0x0120, r1
		USRT_send_2bytes(air_buffer[2], air_buffer[3]);
 4aa:	60 91 24 01 	lds	r22, 0x0124
 4ae:	80 91 23 01 	lds	r24, 0x0123
 4b2:	6f d1       	rcall	.+734    	; 0x792
		air_buffer[2] = 0x00;
 4b4:	10 92 23 01 	sts	0x0123, r1
		air_buffer[3] = 0x00;
 4b8:	10 92 24 01 	sts	0x0124, r1
 4bc:	cf 91       	pop	r28
 4be:	08 95       	ret

000004c0 <air_read_channel>:
	}
}

inline void air_read_channel(uint8_t channel_num){
 4c0:	1f 93       	push	r17
 4c2:	cf 93       	push	r28
 4c4:	df 93       	push	r29
 4c6:	18 2f       	mov	r17, r24
	uint8_t new_bit;
	new_bit = air_capture & _BV(channel_num);
 4c8:	c8 2f       	mov	r28, r24
 4ca:	dd 27       	eor	r29, r29
 4cc:	81 e0       	ldi	r24, 0x01	; 1
 4ce:	90 e0       	ldi	r25, 0x00	; 0
 4d0:	0c 2e       	mov	r0, r28
 4d2:	02 c0       	rjmp	.+4      	; 0x4d8
 4d4:	88 0f       	add	r24, r24
 4d6:	99 1f       	adc	r25, r25
 4d8:	0a 94       	dec	r0
 4da:	e2 f7       	brpl	.-8      	; 0x4d4
 4dc:	20 91 1f 01 	lds	r18, 0x011F
 4e0:	28 23       	and	r18, r24
	switch (p_state[channel_num]){
 4e2:	fe 01       	movw	r30, r28
 4e4:	e8 5d       	subi	r30, 0xD8	; 216
 4e6:	fe 4f       	sbci	r31, 0xFE	; 254
 4e8:	80 81       	ld	r24, Z
 4ea:	99 27       	eor	r25, r25
 4ec:	81 30       	cpi	r24, 0x01	; 1
 4ee:	91 05       	cpc	r25, r1
 4f0:	51 f0       	breq	.+20     	; 0x506
 4f2:	82 30       	cpi	r24, 0x02	; 2
 4f4:	91 05       	cpc	r25, r1
 4f6:	0c f4       	brge	.+2      	; 0x4fa
 4f8:	41 c0       	rjmp	.+130    	; 0x57c
 4fa:	02 97       	sbiw	r24, 0x02	; 2
 4fc:	81 f0       	breq	.+32     	; 0x51e
		case S0: //Look for rising edge (assuming inverter)
			if (new_bit != 0x00){ //found rising edge (inverted)
				z_count[channel_num] = 1; //found the first one (assumes inverter)
				p_state[channel_num] = S1;	
			}
			break;	
		case S1: //Count the ones (assuming inverter)
			if (new_bit != 0x00){
				if (z_count[channel_num] != 0xFF){ //error case of channel noise producing extended "white-out", do not roll-over count!
					z_count[channel_num]++;
				}
			}
			else {
				p_state[channel_num] = S2;	//if detected falling edge, counting is done (next state) (assumes inverter)
			}	
			break;
		case S2: //Counted ones --> symbols; interpret symbols (assuming inverter)
			if ((z_count[channel_num] >= SYM_1) && (z_count[channel_num] <= SYM_1+SYM_MARGIN)){
				//LOGIC 1
				stk_ledon(1);
				air_enqueue(channel_num, SYM_1_Q);
			}
			else if ((z_count[channel_num] >= SYM_0) && (z_count[channel_num] <= SYM_0+SYM_MARGIN)){
				//LOGIC 0
				stk_ledon(2);
				air_enqueue(channel_num, SYM_0_Q);
			}
			else if ((z_count[channel_num] >= SYM_START) && (z_count[channel_num] <= SYM_START+SYM_MARGIN)){
				//START!
				stk_ledon(4);
				air_enqueue(channel_num, SYM_START_Q);
			}
			p_state[channel_num] = S0;
			break;
		default:
			p_state[channel_num] = S0;
 4fe:	c8 5d       	subi	r28, 0xD8	; 216
 500:	de 4f       	sbci	r29, 0xFE	; 254
 502:	18 82       	st	Y, r1
 504:	e8 c0       	rjmp	.+464    	; 0x6d6
 506:	22 23       	and	r18, r18
 508:	b1 f1       	breq	.+108    	; 0x576
 50a:	fe 01       	movw	r30, r28
 50c:	ea 5c       	subi	r30, 0xCA	; 202
 50e:	fe 4f       	sbci	r31, 0xFE	; 254
 510:	80 81       	ld	r24, Z
 512:	8f 3f       	cpi	r24, 0xFF	; 255
 514:	09 f4       	brne	.+2      	; 0x518
 516:	df c0       	rjmp	.+446    	; 0x6d6
 518:	8f 5f       	subi	r24, 0xFF	; 255
 51a:	80 83       	st	Z, r24
 51c:	dc c0       	rjmp	.+440    	; 0x6d6
 51e:	fe 01       	movw	r30, r28
 520:	ea 5c       	subi	r30, 0xCA	; 202
 522:	fe 4f       	sbci	r31, 0xFE	; 254
 524:	e0 81       	ld	r30, Z
 526:	8e 2f       	mov	r24, r30
 528:	84 50       	subi	r24, 0x04	; 4
 52a:	82 30       	cpi	r24, 0x02	; 2
 52c:	98 f1       	brcs	.+102    	; 0x594
 52e:	5e 2f       	mov	r21, r30
 530:	56 50       	subi	r21, 0x06	; 6
 532:	52 30       	cpi	r21, 0x02	; 2
 534:	08 f4       	brcc	.+2      	; 0x538
 536:	43 c0       	rjmp	.+134    	; 0x5be
 538:	e2 50       	subi	r30, 0x02	; 2
 53a:	e2 30       	cpi	r30, 0x02	; 2
 53c:	00 f7       	brcc	.-64     	; 0x4fe
 53e:	84 e0       	ldi	r24, 0x04	; 4
 540:	bf dd       	rcall	.-1154   	; 0xc0
 542:	14 30       	cpi	r17, 0x04	; 4
 544:	08 f0       	brcs	.+2      	; 0x548
 546:	93 c0       	rjmp	.+294    	; 0x66e
 548:	fe 01       	movw	r30, r28
 54a:	e1 5d       	subi	r30, 0xD1	; 209
 54c:	fe 4f       	sbci	r31, 0xFE	; 254
 54e:	90 81       	ld	r25, Z
 550:	99 23       	and	r25, r25
 552:	09 f0       	breq	.+2      	; 0x556
 554:	ae c0       	rjmp	.+348    	; 0x6b2
 556:	a1 e0       	ldi	r26, 0x01	; 1
 558:	a0 83       	st	Z, r26
 55a:	fe 01       	movw	r30, r28
 55c:	ee 0f       	add	r30, r30
 55e:	ff 1f       	adc	r31, r31
 560:	ee 0f       	add	r30, r30
 562:	ff 1f       	adc	r31, r31
 564:	ed 5f       	subi	r30, 0xFD	; 253
 566:	fe 4f       	sbci	r31, 0xFE	; 254
 568:	b0 91 21 01 	lds	r27, 0x0121
 56c:	80 81       	ld	r24, Z
 56e:	b8 2b       	or	r27, r24
 570:	b0 93 21 01 	sts	0x0121, r27
 574:	c4 cf       	rjmp	.-120    	; 0x4fe
 576:	82 e0       	ldi	r24, 0x02	; 2
 578:	80 83       	st	Z, r24
 57a:	ad c0       	rjmp	.+346    	; 0x6d6
 57c:	89 2b       	or	r24, r25
 57e:	09 f0       	breq	.+2      	; 0x582
 580:	be cf       	rjmp	.-132    	; 0x4fe
 582:	22 23       	and	r18, r18
 584:	09 f4       	brne	.+2      	; 0x588
 586:	a7 c0       	rjmp	.+334    	; 0x6d6
 588:	ca 5c       	subi	r28, 0xCA	; 202
 58a:	de 4f       	sbci	r29, 0xFE	; 254
 58c:	81 e0       	ldi	r24, 0x01	; 1
 58e:	88 83       	st	Y, r24
 590:	80 83       	st	Z, r24
 592:	a1 c0       	rjmp	.+322    	; 0x6d6
 594:	81 e0       	ldi	r24, 0x01	; 1
 596:	94 dd       	rcall	.-1240   	; 0xc0
 598:	14 30       	cpi	r17, 0x04	; 4
 59a:	30 f5       	brcc	.+76     	; 0x5e8
 59c:	fe 01       	movw	r30, r28
 59e:	e1 5d       	subi	r30, 0xD1	; 209
 5a0:	fe 4f       	sbci	r31, 0xFE	; 254
 5a2:	10 81       	ld	r17, Z
 5a4:	11 23       	and	r17, r17
 5a6:	09 f0       	breq	.+2      	; 0x5aa
 5a8:	44 c0       	rjmp	.+136    	; 0x632
 5aa:	21 e0       	ldi	r18, 0x01	; 1
 5ac:	20 83       	st	Z, r18
 5ae:	fe 01       	movw	r30, r28
 5b0:	ee 0f       	add	r30, r30
 5b2:	ff 1f       	adc	r31, r31
 5b4:	ee 0f       	add	r30, r30
 5b6:	ff 1f       	adc	r31, r31
 5b8:	ee 5f       	subi	r30, 0xFE	; 254
 5ba:	fe 4f       	sbci	r31, 0xFE	; 254
 5bc:	d5 cf       	rjmp	.-86     	; 0x568
 5be:	82 e0       	ldi	r24, 0x02	; 2
 5c0:	7f dd       	rcall	.-1282   	; 0xc0
 5c2:	91 e0       	ldi	r25, 0x01	; 1
 5c4:	14 30       	cpi	r17, 0x04	; 4
 5c6:	30 f5       	brcc	.+76     	; 0x614
 5c8:	fe 01       	movw	r30, r28
 5ca:	e1 5d       	subi	r30, 0xD1	; 209
 5cc:	fe 4f       	sbci	r31, 0xFE	; 254
 5ce:	60 81       	ld	r22, Z
 5d0:	66 23       	and	r22, r22
 5d2:	09 f0       	breq	.+2      	; 0x5d6
 5d4:	65 c0       	rjmp	.+202    	; 0x6a0
 5d6:	90 83       	st	Z, r25
 5d8:	fe 01       	movw	r30, r28
 5da:	ee 0f       	add	r30, r30
 5dc:	ff 1f       	adc	r31, r31
 5de:	ee 0f       	add	r30, r30
 5e0:	ff 1f       	adc	r31, r31
 5e2:	ef 5f       	subi	r30, 0xFF	; 255
 5e4:	fe 4f       	sbci	r31, 0xFE	; 254
 5e6:	c0 cf       	rjmp	.-128    	; 0x568
 5e8:	fe 01       	movw	r30, r28
 5ea:	e1 5d       	subi	r30, 0xD1	; 209
 5ec:	fe 4f       	sbci	r31, 0xFE	; 254
 5ee:	30 81       	ld	r19, Z
 5f0:	33 23       	and	r19, r19
 5f2:	71 f5       	brne	.+92     	; 0x650
 5f4:	41 e0       	ldi	r20, 0x01	; 1
 5f6:	40 83       	st	Z, r20
 5f8:	fe 01       	movw	r30, r28
 5fa:	ee 0f       	add	r30, r30
 5fc:	ff 1f       	adc	r31, r31
 5fe:	ee 0f       	add	r30, r30
 600:	ff 1f       	adc	r31, r31
 602:	ee 5f       	subi	r30, 0xFE	; 254
 604:	fe 4f       	sbci	r31, 0xFE	; 254
 606:	50 91 22 01 	lds	r21, 0x0122
 60a:	60 81       	ld	r22, Z
 60c:	56 2b       	or	r21, r22
 60e:	50 93 22 01 	sts	0x0122, r21
 612:	75 cf       	rjmp	.-278    	; 0x4fe
 614:	fe 01       	movw	r30, r28
 616:	e1 5d       	subi	r30, 0xD1	; 209
 618:	fe 4f       	sbci	r31, 0xFE	; 254
 61a:	70 81       	ld	r23, Z
 61c:	77 23       	and	r23, r23
 61e:	b9 f5       	brne	.+110    	; 0x68e
 620:	90 83       	st	Z, r25
 622:	fe 01       	movw	r30, r28
 624:	ee 0f       	add	r30, r30
 626:	ff 1f       	adc	r31, r31
 628:	ee 0f       	add	r30, r30
 62a:	ff 1f       	adc	r31, r31
 62c:	ef 5f       	subi	r30, 0xFF	; 255
 62e:	fe 4f       	sbci	r31, 0xFE	; 254
 630:	ea cf       	rjmp	.-44     	; 0x606
 632:	10 82       	st	Z, r1
 634:	fe 01       	movw	r30, r28
 636:	ee 0f       	add	r30, r30
 638:	ff 1f       	adc	r31, r31
 63a:	ee 0f       	add	r30, r30
 63c:	ff 1f       	adc	r31, r31
 63e:	ee 5f       	subi	r30, 0xFE	; 254
 640:	fe 4f       	sbci	r31, 0xFE	; 254
 642:	10 91 23 01 	lds	r17, 0x0123
 646:	20 81       	ld	r18, Z
 648:	12 2b       	or	r17, r18
 64a:	10 93 23 01 	sts	0x0123, r17
 64e:	57 cf       	rjmp	.-338    	; 0x4fe
 650:	10 82       	st	Z, r1
 652:	fe 01       	movw	r30, r28
 654:	ee 0f       	add	r30, r30
 656:	ff 1f       	adc	r31, r31
 658:	ee 0f       	add	r30, r30
 65a:	ff 1f       	adc	r31, r31
 65c:	ee 5f       	subi	r30, 0xFE	; 254
 65e:	fe 4f       	sbci	r31, 0xFE	; 254
 660:	70 91 24 01 	lds	r23, 0x0124
 664:	90 81       	ld	r25, Z
 666:	79 2b       	or	r23, r25
 668:	70 93 24 01 	sts	0x0124, r23
 66c:	48 cf       	rjmp	.-368    	; 0x4fe
 66e:	fe 01       	movw	r30, r28
 670:	e1 5d       	subi	r30, 0xD1	; 209
 672:	fe 4f       	sbci	r31, 0xFE	; 254
 674:	30 81       	ld	r19, Z
 676:	33 23       	and	r19, r19
 678:	29 f5       	brne	.+74     	; 0x6c4
 67a:	41 e0       	ldi	r20, 0x01	; 1
 67c:	40 83       	st	Z, r20
 67e:	fe 01       	movw	r30, r28
 680:	ee 0f       	add	r30, r30
 682:	ff 1f       	adc	r31, r31
 684:	ee 0f       	add	r30, r30
 686:	ff 1f       	adc	r31, r31
 688:	ed 5f       	subi	r30, 0xFD	; 253
 68a:	fe 4f       	sbci	r31, 0xFE	; 254
 68c:	bc cf       	rjmp	.-136    	; 0x606
 68e:	10 82       	st	Z, r1
 690:	fe 01       	movw	r30, r28
 692:	ee 0f       	add	r30, r30
 694:	ff 1f       	adc	r31, r31
 696:	ee 0f       	add	r30, r30
 698:	ff 1f       	adc	r31, r31
 69a:	ef 5f       	subi	r30, 0xFF	; 255
 69c:	fe 4f       	sbci	r31, 0xFE	; 254
 69e:	e0 cf       	rjmp	.-64     	; 0x660
 6a0:	10 82       	st	Z, r1
 6a2:	fe 01       	movw	r30, r28
 6a4:	ee 0f       	add	r30, r30
 6a6:	ff 1f       	adc	r31, r31
 6a8:	ee 0f       	add	r30, r30
 6aa:	ff 1f       	adc	r31, r31
 6ac:	ef 5f       	subi	r30, 0xFF	; 255
 6ae:	fe 4f       	sbci	r31, 0xFE	; 254
 6b0:	c8 cf       	rjmp	.-112    	; 0x642
 6b2:	10 82       	st	Z, r1
 6b4:	fe 01       	movw	r30, r28
 6b6:	ee 0f       	add	r30, r30
 6b8:	ff 1f       	adc	r31, r31
 6ba:	ee 0f       	add	r30, r30
 6bc:	ff 1f       	adc	r31, r31
 6be:	ed 5f       	subi	r30, 0xFD	; 253
 6c0:	fe 4f       	sbci	r31, 0xFE	; 254
 6c2:	bf cf       	rjmp	.-130    	; 0x642
 6c4:	10 82       	st	Z, r1
 6c6:	fe 01       	movw	r30, r28
 6c8:	ee 0f       	add	r30, r30
 6ca:	ff 1f       	adc	r31, r31
 6cc:	ee 0f       	add	r30, r30
 6ce:	ff 1f       	adc	r31, r31
 6d0:	ed 5f       	subi	r30, 0xFD	; 253
 6d2:	fe 4f       	sbci	r31, 0xFE	; 254
 6d4:	c5 cf       	rjmp	.-118    	; 0x660
 6d6:	df 91       	pop	r29
 6d8:	cf 91       	pop	r28
 6da:	1f 91       	pop	r17
 6dc:	08 95       	ret

000006de <__vector_7>:
			break;
	}
}


//----------------------------------------------------------------
//- INTERRUPT SERVICE ROUTINES
//----------------------------------------------------------------

#define t400us 50   //40 //actually 336us
#define t150us 40 //16 //actually 156us
#define t200us 30 //actually 232us

#define t350us 32 //actually 336us


SIGNAL(SIG_OUTPUT_COMPARE2A){
 6de:	1f 92       	push	r1
 6e0:	0f 92       	push	r0
 6e2:	0f b6       	in	r0, 0x3f	; 63
 6e4:	0f 92       	push	r0
 6e6:	11 24       	eor	r1, r1
 6e8:	2f 93       	push	r18
 6ea:	3f 93       	push	r19
 6ec:	4f 93       	push	r20
 6ee:	5f 93       	push	r21
 6f0:	6f 93       	push	r22
 6f2:	8f 93       	push	r24
 6f4:	9f 93       	push	r25
  static volatile uint8_t	cpp=0;
  static volatile uint8_t	active=t400us; 
  cpp++;
 6f6:	20 91 1e 01 	lds	r18, 0x011E
 6fa:	2f 5f       	subi	r18, 0xFF	; 255
 6fc:	20 93 1e 01 	sts	0x011E, r18
  if (cpp == active){
 700:	90 91 1e 01 	lds	r25, 0x011E
 704:	80 91 1c 01 	lds	r24, 0x011C
 708:	98 17       	cp	r25, r24
 70a:	b1 f0       	breq	.+44     	; 0x738
    disable_output_irclock();	
  }
  else if (cpp >= 80){  //should be 80
 70c:	30 91 1e 01 	lds	r19, 0x011E
 710:	30 35       	cpi	r19, 0x50	; 80
 712:	18 f1       	brcs	.+70     	; 0x75a
    cpp = 0;
 714:	10 92 1e 01 	sts	0x011E, r1
    if (active == t400us) active=t150us;
 718:	40 91 1c 01 	lds	r20, 0x011C
 71c:	42 33       	cpi	r20, 0x32	; 50
 71e:	c9 f0       	breq	.+50     	; 0x752
    else if (active == t150us) active=t200us;
 720:	50 91 1c 01 	lds	r21, 0x011C
 724:	58 32       	cpi	r21, 0x28	; 40
 726:	61 f0       	breq	.+24     	; 0x740
    else if (active == t200us) active=t400us; 
 728:	60 91 1c 01 	lds	r22, 0x011C
 72c:	6e 31       	cpi	r22, 0x1E	; 30
 72e:	69 f0       	breq	.+26     	; 0x74a
 730:	82 e1       	ldi	r24, 0x12	; 18
 732:	80 93 b0 00 	sts	0x00B0, r24
 736:	11 c0       	rjmp	.+34     	; 0x75a
 738:	82 e2       	ldi	r24, 0x22	; 34
 73a:	80 93 b0 00 	sts	0x00B0, r24
 73e:	0d c0       	rjmp	.+26     	; 0x75a
 740:	8e e1       	ldi	r24, 0x1E	; 30
 742:	80 93 1c 01 	sts	0x011C, r24
 746:	82 e1       	ldi	r24, 0x12	; 18
 748:	f4 cf       	rjmp	.-24     	; 0x732
 74a:	82 e3       	ldi	r24, 0x32	; 50
 74c:	80 93 1c 01 	sts	0x011C, r24
 750:	fa cf       	rjmp	.-12     	; 0x746
 752:	88 e2       	ldi	r24, 0x28	; 40
 754:	80 93 1c 01 	sts	0x011C, r24
 758:	f6 cf       	rjmp	.-20     	; 0x746
 75a:	9f 91       	pop	r25
 75c:	8f 91       	pop	r24
 75e:	6f 91       	pop	r22
 760:	5f 91       	pop	r21
 762:	4f 91       	pop	r20
 764:	3f 91       	pop	r19
 766:	2f 91       	pop	r18
 768:	0f 90       	pop	r0
 76a:	0f be       	out	0x3f, r0	; 63
 76c:	0f 90       	pop	r0
 76e:	1f 90       	pop	r1
 770:	18 95       	reti

00000772 <init_serial>:

//USRT MODE! MASTER
void init_serial(){
	// USART initialization
	UCSR0A=0x00;//just flags in this register
 772:	10 92 c0 00 	sts	0x00C0, r1
	UCSR0C=B8(01000110);//N,8-bit data,1 frame format; Clock polarity = data delta on rising, sample on falling edge
 776:	36 e4       	ldi	r19, 0x46	; 70
 778:	30 93 c2 00 	sts	0x00C2, r19
	UBRR0H=0x00;
 77c:	10 92 c5 00 	sts	0x00C5, r1
	UBRR0L=3; //2.67 Mbps (megabits per second) from 16MHz clock
 780:	23 e0       	ldi	r18, 0x03	; 3
 782:	20 93 c4 00 	sts	0x00C4, r18
	sbi(DDRD,1); //TXD is output pin (data line)
 786:	51 9a       	sbi	0x0a, 1	; 10
	sbi(DDRD,4); //XCK is output pin (USRT clock line)
 788:	54 9a       	sbi	0x0a, 4	; 10
	UCSR0B=0x08;//No Rx; TX enabled - last line because operation begins on this flag
 78a:	88 e0       	ldi	r24, 0x08	; 8
 78c:	80 93 c1 00 	sts	0x00C1, r24
 790:	08 95       	ret

00000792 <USRT_send_2bytes>:
}

//dataA is sent first
//this function built for speed, no safety checking. UART shift and buffer registers should be empty.
//The first write falls through to the actual output register freeing the buffer for byte 2.
void inline USRT_send_2bytes(unsigned char dataA, unsigned char dataB){
	// XXX
	UDR0 = dataA;
 792:	80 93 c6 00 	sts	0x00C6, r24
	UDR0 = dataB;
 796:	60 93 c6 00 	sts	0x00C6, r22
 79a:	08 95       	ret

0000079c <send_byte_serial>:
	/*
	//DEBUG code to test the buffer ready for new data flag
	if(UCSR0A & B8(00100000)){ //true != 0, freeze on buffer avail
		stk_ledon(0xAA);
		while(1);
	}
	*/
}

void inline send_byte_serial(unsigned char dataB){
 79c:	48 2f       	mov	r20, r24
 79e:	21 e0       	ldi	r18, 0x01	; 1
 7a0:	30 e0       	ldi	r19, 0x00	; 0
	while ((UCSR0A & _BV(5)) != B8(00100000));
 7a2:	80 91 c0 00 	lds	r24, 0x00C0
 7a6:	99 27       	eor	r25, r25
 7a8:	96 95       	lsr	r25
 7aa:	87 95       	ror	r24
 7ac:	92 95       	swap	r25
 7ae:	82 95       	swap	r24
 7b0:	8f 70       	andi	r24, 0x0F	; 15
 7b2:	89 27       	eor	r24, r25
 7b4:	9f 70       	andi	r25, 0x0F	; 15
 7b6:	89 27       	eor	r24, r25
 7b8:	81 70       	andi	r24, 0x01	; 1
 7ba:	90 70       	andi	r25, 0x00	; 0
 7bc:	82 17       	cp	r24, r18
 7be:	93 07       	cpc	r25, r19
 7c0:	81 f7       	brne	.-32     	; 0x7a2
	UDR0 = dataB;
 7c2:	40 93 c6 00 	sts	0x00C6, r20
 7c6:	08 95       	ret

000007c8 <UART_send_HEX4>:
}
	
void UART_send_HEX4(uint8_t lowb){
	switch(lowb){
 7c8:	99 27       	eor	r25, r25
 7ca:	aa 27       	eor	r26, r26
 7cc:	bb 27       	eor	r27, r27
 7ce:	80 31       	cpi	r24, 0x10	; 16
 7d0:	91 05       	cpc	r25, r1
 7d2:	c8 f4       	brcc	.+50     	; 0x806
 7d4:	fc 01       	movw	r30, r24
 7d6:	e6 5e       	subi	r30, 0xE6	; 230
 7d8:	ff 4f       	sbci	r31, 0xFF	; 255
 7da:	09 94       	ijmp
 7dc:	21 e0       	ldi	r18, 0x01	; 1
 7de:	30 e0       	ldi	r19, 0x00	; 0
 7e0:	80 91 c0 00 	lds	r24, 0x00C0
 7e4:	99 27       	eor	r25, r25
 7e6:	96 95       	lsr	r25
 7e8:	87 95       	ror	r24
 7ea:	92 95       	swap	r25
 7ec:	82 95       	swap	r24
 7ee:	8f 70       	andi	r24, 0x0F	; 15
 7f0:	89 27       	eor	r24, r25
 7f2:	9f 70       	andi	r25, 0x0F	; 15
 7f4:	89 27       	eor	r24, r25
 7f6:	81 70       	andi	r24, 0x01	; 1
 7f8:	90 70       	andi	r25, 0x00	; 0
 7fa:	82 17       	cp	r24, r18
 7fc:	93 07       	cpc	r25, r19
 7fe:	81 f7       	brne	.-32     	; 0x7e0
 800:	86 e4       	ldi	r24, 0x46	; 70
 802:	80 93 c6 00 	sts	0x00C6, r24
 806:	08 95       	ret
 808:	21 e0       	ldi	r18, 0x01	; 1
 80a:	30 e0       	ldi	r19, 0x00	; 0
 80c:	80 91 c0 00 	lds	r24, 0x00C0
 810:	99 27       	eor	r25, r25
 812:	96 95       	lsr	r25
 814:	87 95       	ror	r24
 816:	92 95       	swap	r25
 818:	82 95       	swap	r24
 81a:	8f 70       	andi	r24, 0x0F	; 15
 81c:	89 27       	eor	r24, r25
 81e:	9f 70       	andi	r25, 0x0F	; 15
 820:	89 27       	eor	r24, r25
 822:	81 70       	andi	r24, 0x01	; 1
 824:	90 70       	andi	r25, 0x00	; 0
 826:	82 17       	cp	r24, r18
 828:	93 07       	cpc	r25, r19
 82a:	81 f7       	brne	.-32     	; 0x80c
 82c:	85 e4       	ldi	r24, 0x45	; 69
 82e:	80 93 c6 00 	sts	0x00C6, r24
 832:	08 95       	ret
 834:	21 e0       	ldi	r18, 0x01	; 1
 836:	30 e0       	ldi	r19, 0x00	; 0
 838:	80 91 c0 00 	lds	r24, 0x00C0
 83c:	99 27       	eor	r25, r25
 83e:	96 95       	lsr	r25
 840:	87 95       	ror	r24
 842:	92 95       	swap	r25
 844:	82 95       	swap	r24
 846:	8f 70       	andi	r24, 0x0F	; 15
 848:	89 27       	eor	r24, r25
 84a:	9f 70       	andi	r25, 0x0F	; 15
 84c:	89 27       	eor	r24, r25
 84e:	81 70       	andi	r24, 0x01	; 1
 850:	90 70       	andi	r25, 0x00	; 0
 852:	82 17       	cp	r24, r18
 854:	93 07       	cpc	r25, r19
 856:	81 f7       	brne	.-32     	; 0x838
 858:	84 e4       	ldi	r24, 0x44	; 68
 85a:	e9 cf       	rjmp	.-46     	; 0x82e
 85c:	21 e0       	ldi	r18, 0x01	; 1
 85e:	30 e0       	ldi	r19, 0x00	; 0
 860:	80 91 c0 00 	lds	r24, 0x00C0
 864:	99 27       	eor	r25, r25
 866:	96 95       	lsr	r25
 868:	87 95       	ror	r24
 86a:	92 95       	swap	r25
 86c:	82 95       	swap	r24
 86e:	8f 70       	andi	r24, 0x0F	; 15
 870:	89 27       	eor	r24, r25
 872:	9f 70       	andi	r25, 0x0F	; 15
 874:	89 27       	eor	r24, r25
 876:	81 70       	andi	r24, 0x01	; 1
 878:	90 70       	andi	r25, 0x00	; 0
 87a:	82 17       	cp	r24, r18
 87c:	93 07       	cpc	r25, r19
 87e:	81 f7       	brne	.-32     	; 0x860
 880:	83 e4       	ldi	r24, 0x43	; 67
 882:	d5 cf       	rjmp	.-86     	; 0x82e
 884:	21 e0       	ldi	r18, 0x01	; 1
 886:	30 e0       	ldi	r19, 0x00	; 0
 888:	80 91 c0 00 	lds	r24, 0x00C0
 88c:	99 27       	eor	r25, r25
 88e:	96 95       	lsr	r25
 890:	87 95       	ror	r24
 892:	92 95       	swap	r25
 894:	82 95       	swap	r24
 896:	8f 70       	andi	r24, 0x0F	; 15
 898:	89 27       	eor	r24, r25
 89a:	9f 70       	andi	r25, 0x0F	; 15
 89c:	89 27       	eor	r24, r25
 89e:	81 70       	andi	r24, 0x01	; 1
 8a0:	90 70       	andi	r25, 0x00	; 0
 8a2:	82 17       	cp	r24, r18
 8a4:	93 07       	cpc	r25, r19
 8a6:	81 f7       	brne	.-32     	; 0x888
 8a8:	82 e4       	ldi	r24, 0x42	; 66
 8aa:	c1 cf       	rjmp	.-126    	; 0x82e
 8ac:	21 e0       	ldi	r18, 0x01	; 1
 8ae:	30 e0       	ldi	r19, 0x00	; 0
 8b0:	80 91 c0 00 	lds	r24, 0x00C0
 8b4:	99 27       	eor	r25, r25
 8b6:	96 95       	lsr	r25
 8b8:	87 95       	ror	r24
 8ba:	92 95       	swap	r25
 8bc:	82 95       	swap	r24
 8be:	8f 70       	andi	r24, 0x0F	; 15
 8c0:	89 27       	eor	r24, r25
 8c2:	9f 70       	andi	r25, 0x0F	; 15
 8c4:	89 27       	eor	r24, r25
 8c6:	81 70       	andi	r24, 0x01	; 1
 8c8:	90 70       	andi	r25, 0x00	; 0
 8ca:	82 17       	cp	r24, r18
 8cc:	93 07       	cpc	r25, r19
 8ce:	81 f7       	brne	.-32     	; 0x8b0
 8d0:	81 e4       	ldi	r24, 0x41	; 65
 8d2:	ad cf       	rjmp	.-166    	; 0x82e
 8d4:	21 e0       	ldi	r18, 0x01	; 1
 8d6:	30 e0       	ldi	r19, 0x00	; 0
 8d8:	80 91 c0 00 	lds	r24, 0x00C0
 8dc:	99 27       	eor	r25, r25
 8de:	96 95       	lsr	r25
 8e0:	87 95       	ror	r24
 8e2:	92 95       	swap	r25
 8e4:	82 95       	swap	r24
 8e6:	8f 70       	andi	r24, 0x0F	; 15
 8e8:	89 27       	eor	r24, r25
 8ea:	9f 70       	andi	r25, 0x0F	; 15
 8ec:	89 27       	eor	r24, r25
 8ee:	81 70       	andi	r24, 0x01	; 1
 8f0:	90 70       	andi	r25, 0x00	; 0
 8f2:	82 17       	cp	r24, r18
 8f4:	93 07       	cpc	r25, r19
 8f6:	81 f7       	brne	.-32     	; 0x8d8
 8f8:	89 e3       	ldi	r24, 0x39	; 57
 8fa:	99 cf       	rjmp	.-206    	; 0x82e
 8fc:	21 e0       	ldi	r18, 0x01	; 1
 8fe:	30 e0       	ldi	r19, 0x00	; 0
 900:	80 91 c0 00 	lds	r24, 0x00C0
 904:	99 27       	eor	r25, r25
 906:	96 95       	lsr	r25
 908:	87 95       	ror	r24
 90a:	92 95       	swap	r25
 90c:	82 95       	swap	r24
 90e:	8f 70       	andi	r24, 0x0F	; 15
 910:	89 27       	eor	r24, r25
 912:	9f 70       	andi	r25, 0x0F	; 15
 914:	89 27       	eor	r24, r25
 916:	81 70       	andi	r24, 0x01	; 1
 918:	90 70       	andi	r25, 0x00	; 0
 91a:	82 17       	cp	r24, r18
 91c:	93 07       	cpc	r25, r19
 91e:	81 f7       	brne	.-32     	; 0x900
 920:	88 e3       	ldi	r24, 0x38	; 56
 922:	85 cf       	rjmp	.-246    	; 0x82e
 924:	21 e0       	ldi	r18, 0x01	; 1
 926:	30 e0       	ldi	r19, 0x00	; 0
 928:	80 91 c0 00 	lds	r24, 0x00C0
 92c:	99 27       	eor	r25, r25
 92e:	96 95       	lsr	r25
 930:	87 95       	ror	r24
 932:	92 95       	swap	r25
 934:	82 95       	swap	r24
 936:	8f 70       	andi	r24, 0x0F	; 15
 938:	89 27       	eor	r24, r25
 93a:	9f 70       	andi	r25, 0x0F	; 15
 93c:	89 27       	eor	r24, r25
 93e:	81 70       	andi	r24, 0x01	; 1
 940:	90 70       	andi	r25, 0x00	; 0
 942:	82 17       	cp	r24, r18
 944:	93 07       	cpc	r25, r19
 946:	81 f7       	brne	.-32     	; 0x928
 948:	87 e3       	ldi	r24, 0x37	; 55
 94a:	71 cf       	rjmp	.-286    	; 0x82e
 94c:	21 e0       	ldi	r18, 0x01	; 1
 94e:	30 e0       	ldi	r19, 0x00	; 0
 950:	80 91 c0 00 	lds	r24, 0x00C0
 954:	99 27       	eor	r25, r25
 956:	96 95       	lsr	r25
 958:	87 95       	ror	r24
 95a:	92 95       	swap	r25
 95c:	82 95       	swap	r24
 95e:	8f 70       	andi	r24, 0x0F	; 15
 960:	89 27       	eor	r24, r25
 962:	9f 70       	andi	r25, 0x0F	; 15
 964:	89 27       	eor	r24, r25
 966:	81 70       	andi	r24, 0x01	; 1
 968:	90 70       	andi	r25, 0x00	; 0
 96a:	82 17       	cp	r24, r18
 96c:	93 07       	cpc	r25, r19
 96e:	81 f7       	brne	.-32     	; 0x950
 970:	86 e3       	ldi	r24, 0x36	; 54
 972:	5d cf       	rjmp	.-326    	; 0x82e
 974:	21 e0       	ldi	r18, 0x01	; 1
 976:	30 e0       	ldi	r19, 0x00	; 0
 978:	80 91 c0 00 	lds	r24, 0x00C0
 97c:	99 27       	eor	r25, r25
 97e:	96 95       	lsr	r25
 980:	87 95       	ror	r24
 982:	92 95       	swap	r25
 984:	82 95       	swap	r24
 986:	8f 70       	andi	r24, 0x0F	; 15
 988:	89 27       	eor	r24, r25
 98a:	9f 70       	andi	r25, 0x0F	; 15
 98c:	89 27       	eor	r24, r25
 98e:	81 70       	andi	r24, 0x01	; 1
 990:	90 70       	andi	r25, 0x00	; 0
 992:	82 17       	cp	r24, r18
 994:	93 07       	cpc	r25, r19
 996:	81 f7       	brne	.-32     	; 0x978
 998:	85 e3       	ldi	r24, 0x35	; 53
 99a:	49 cf       	rjmp	.-366    	; 0x82e
 99c:	21 e0       	ldi	r18, 0x01	; 1
 99e:	30 e0       	ldi	r19, 0x00	; 0
 9a0:	80 91 c0 00 	lds	r24, 0x00C0
 9a4:	99 27       	eor	r25, r25
 9a6:	96 95       	lsr	r25
 9a8:	87 95       	ror	r24
 9aa:	92 95       	swap	r25
 9ac:	82 95       	swap	r24
 9ae:	8f 70       	andi	r24, 0x0F	; 15
 9b0:	89 27       	eor	r24, r25
 9b2:	9f 70       	andi	r25, 0x0F	; 15
 9b4:	89 27       	eor	r24, r25
 9b6:	81 70       	andi	r24, 0x01	; 1
 9b8:	90 70       	andi	r25, 0x00	; 0
 9ba:	82 17       	cp	r24, r18
 9bc:	93 07       	cpc	r25, r19
 9be:	81 f7       	brne	.-32     	; 0x9a0
 9c0:	84 e3       	ldi	r24, 0x34	; 52
 9c2:	35 cf       	rjmp	.-406    	; 0x82e
 9c4:	21 e0       	ldi	r18, 0x01	; 1
 9c6:	30 e0       	ldi	r19, 0x00	; 0
 9c8:	80 91 c0 00 	lds	r24, 0x00C0
 9cc:	99 27       	eor	r25, r25
 9ce:	96 95       	lsr	r25
 9d0:	87 95       	ror	r24
 9d2:	92 95       	swap	r25
 9d4:	82 95       	swap	r24
 9d6:	8f 70       	andi	r24, 0x0F	; 15
 9d8:	89 27       	eor	r24, r25
 9da:	9f 70       	andi	r25, 0x0F	; 15
 9dc:	89 27       	eor	r24, r25
 9de:	81 70       	andi	r24, 0x01	; 1
 9e0:	90 70       	andi	r25, 0x00	; 0
 9e2:	82 17       	cp	r24, r18
 9e4:	93 07       	cpc	r25, r19
 9e6:	81 f7       	brne	.-32     	; 0x9c8
 9e8:	83 e3       	ldi	r24, 0x33	; 51
 9ea:	21 cf       	rjmp	.-446    	; 0x82e
 9ec:	21 e0       	ldi	r18, 0x01	; 1
 9ee:	30 e0       	ldi	r19, 0x00	; 0
 9f0:	80 91 c0 00 	lds	r24, 0x00C0
 9f4:	99 27       	eor	r25, r25
 9f6:	96 95       	lsr	r25
 9f8:	87 95       	ror	r24
 9fa:	92 95       	swap	r25
 9fc:	82 95       	swap	r24
 9fe:	8f 70       	andi	r24, 0x0F	; 15
 a00:	89 27       	eor	r24, r25
 a02:	9f 70       	andi	r25, 0x0F	; 15
 a04:	89 27       	eor	r24, r25
 a06:	81 70       	andi	r24, 0x01	; 1
 a08:	90 70       	andi	r25, 0x00	; 0
 a0a:	82 17       	cp	r24, r18
 a0c:	93 07       	cpc	r25, r19
 a0e:	81 f7       	brne	.-32     	; 0x9f0
 a10:	82 e3       	ldi	r24, 0x32	; 50
 a12:	0d cf       	rjmp	.-486    	; 0x82e
 a14:	21 e0       	ldi	r18, 0x01	; 1
 a16:	30 e0       	ldi	r19, 0x00	; 0
 a18:	80 91 c0 00 	lds	r24, 0x00C0
 a1c:	99 27       	eor	r25, r25
 a1e:	96 95       	lsr	r25
 a20:	87 95       	ror	r24
 a22:	92 95       	swap	r25
 a24:	82 95       	swap	r24
 a26:	8f 70       	andi	r24, 0x0F	; 15
 a28:	89 27       	eor	r24, r25
 a2a:	9f 70       	andi	r25, 0x0F	; 15
 a2c:	89 27       	eor	r24, r25
 a2e:	81 70       	andi	r24, 0x01	; 1
 a30:	90 70       	andi	r25, 0x00	; 0
 a32:	82 17       	cp	r24, r18
 a34:	93 07       	cpc	r25, r19
 a36:	81 f7       	brne	.-32     	; 0xa18
 a38:	81 e3       	ldi	r24, 0x31	; 49
 a3a:	f9 ce       	rjmp	.-526    	; 0x82e
 a3c:	21 e0       	ldi	r18, 0x01	; 1
 a3e:	30 e0       	ldi	r19, 0x00	; 0
 a40:	80 91 c0 00 	lds	r24, 0x00C0
 a44:	99 27       	eor	r25, r25
 a46:	96 95       	lsr	r25
 a48:	87 95       	ror	r24
 a4a:	92 95       	swap	r25
 a4c:	82 95       	swap	r24
 a4e:	8f 70       	andi	r24, 0x0F	; 15
 a50:	89 27       	eor	r24, r25
 a52:	9f 70       	andi	r25, 0x0F	; 15
 a54:	89 27       	eor	r24, r25
 a56:	81 70       	andi	r24, 0x01	; 1
 a58:	90 70       	andi	r25, 0x00	; 0
 a5a:	82 17       	cp	r24, r18
 a5c:	93 07       	cpc	r25, r19
 a5e:	81 f7       	brne	.-32     	; 0xa40
 a60:	80 e3       	ldi	r24, 0x30	; 48
 a62:	e5 ce       	rjmp	.-566    	; 0x82e

00000a64 <UART_send_HEX8>:
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
 a64:	1f 93       	push	r17
 a66:	18 2f       	mov	r17, r24
	UART_send_HEX4(lowb>>4);
 a68:	82 95       	swap	r24
 a6a:	8f 70       	andi	r24, 0x0F	; 15
 a6c:	ad de       	rcall	.-678    	; 0x7c8
	UART_send_HEX4(lowb & 0x0F);
 a6e:	81 2f       	mov	r24, r17
 a70:	8f 70       	andi	r24, 0x0F	; 15
 a72:	aa de       	rcall	.-684    	; 0x7c8
 a74:	1f 91       	pop	r17
 a76:	08 95       	ret

00000a78 <UART_send_HEX16b>:
}

void UART_send_HEX16b(uint8_t highb, uint8_t lowb){
 a78:	0f 93       	push	r16
 a7a:	1f 93       	push	r17
 a7c:	18 2f       	mov	r17, r24
 a7e:	06 2f       	mov	r16, r22
 a80:	82 95       	swap	r24
 a82:	8f 70       	andi	r24, 0x0F	; 15
 a84:	a1 de       	rcall	.-702    	; 0x7c8
 a86:	81 2f       	mov	r24, r17
 a88:	8f 70       	andi	r24, 0x0F	; 15
 a8a:	9e de       	rcall	.-708    	; 0x7c8
 a8c:	80 2f       	mov	r24, r16
 a8e:	82 95       	swap	r24
 a90:	8f 70       	andi	r24, 0x0F	; 15
 a92:	9a de       	rcall	.-716    	; 0x7c8
 a94:	80 2f       	mov	r24, r16
 a96:	8f 70       	andi	r24, 0x0F	; 15
 a98:	97 de       	rcall	.-722    	; 0x7c8
 a9a:	1f 91       	pop	r17
 a9c:	0f 91       	pop	r16
 a9e:	08 95       	ret

00000aa0 <UART_send_HEX16>:
	UART_send_HEX8(highb);
	UART_send_HEX8(lowb);
}

void UART_send_HEX16(uint16_t highb){
 aa0:	ef 92       	push	r14
 aa2:	ff 92       	push	r15
 aa4:	1f 93       	push	r17
 aa6:	7c 01       	movw	r14, r24
	uint8_t blah;
	blah = (uint8_t)(highb>>8);
 aa8:	89 2f       	mov	r24, r25
 aaa:	99 27       	eor	r25, r25
 aac:	f8 2e       	mov	r15, r24
 aae:	82 95       	swap	r24
 ab0:	8f 70       	andi	r24, 0x0F	; 15
 ab2:	8a de       	rcall	.-748    	; 0x7c8
 ab4:	8f 2d       	mov	r24, r15
 ab6:	8f 70       	andi	r24, 0x0F	; 15
 ab8:	87 de       	rcall	.-754    	; 0x7c8
 aba:	8e 2d       	mov	r24, r14
 abc:	82 95       	swap	r24
 abe:	8f 70       	andi	r24, 0x0F	; 15
 ac0:	83 de       	rcall	.-762    	; 0x7c8
 ac2:	8e 2d       	mov	r24, r14
 ac4:	8f 70       	andi	r24, 0x0F	; 15
 ac6:	80 de       	rcall	.-768    	; 0x7c8
 ac8:	1f 91       	pop	r17
 aca:	ff 90       	pop	r15
 acc:	ef 90       	pop	r14
 ace:	08 95       	ret

00000ad0 <init_I2C_slave>:
 ad0:	25 e4       	ldi	r18, 0x45	; 69
 ad2:	20 93 bc 00 	sts	0x00BC, r18
 ad6:	85 e5       	ldi	r24, 0x55	; 85
 ad8:	80 93 ba 00 	sts	0x00BA, r24
 adc:	10 92 bd 00 	sts	0x00BD, r1
 ae0:	44 9a       	sbi	0x08, 4	; 8
 ae2:	45 9a       	sbi	0x08, 5	; 8
 ae4:	08 95       	ret

00000ae6 <__vector_24>:
 ae6:	1f 92       	push	r1
 ae8:	0f 92       	push	r0
 aea:	0f b6       	in	r0, 0x3f	; 63
 aec:	0f 92       	push	r0
 aee:	11 24       	eor	r1, r1
 af0:	2f 93       	push	r18
 af2:	3f 93       	push	r19
 af4:	4f 93       	push	r20
 af6:	5f 93       	push	r21
 af8:	6f 93       	push	r22
 afa:	7f 93       	push	r23
 afc:	8f 93       	push	r24
 afe:	9f 93       	push	r25
 b00:	af 93       	push	r26
 b02:	bf 93       	push	r27
 b04:	ef 93       	push	r30
 b06:	ff 93       	push	r31
 b08:	2b 9a       	sbi	0x05, 3	; 5
 b0a:	82 e5       	ldi	r24, 0x52	; 82
 b0c:	47 de       	rcall	.-882    	; 0x79c
 b0e:	80 91 b9 00 	lds	r24, 0x00B9
 b12:	a8 df       	rcall	.-176    	; 0xa64
 b14:	8a e0       	ldi	r24, 0x0A	; 10
 b16:	42 de       	rcall	.-892    	; 0x79c
 b18:	8d e0       	ldi	r24, 0x0D	; 13
 b1a:	40 de       	rcall	.-896    	; 0x79c
 b1c:	80 91 b9 00 	lds	r24, 0x00B9
 b20:	80 36       	cpi	r24, 0x60	; 96
 b22:	99 f0       	breq	.+38     	; 0xb4a
 b24:	20 91 b9 00 	lds	r18, 0x00B9
 b28:	20 37       	cpi	r18, 0x70	; 112
 b2a:	79 f0       	breq	.+30     	; 0xb4a
 b2c:	30 91 b9 00 	lds	r19, 0x00B9
 b30:	38 38       	cpi	r19, 0x88	; 136
 b32:	31 f0       	breq	.+12     	; 0xb40
 b34:	40 91 b9 00 	lds	r20, 0x00B9
 b38:	48 39       	cpi	r20, 0x98	; 152
 b3a:	11 f0       	breq	.+4      	; 0xb40
 b3c:	85 ec       	ldi	r24, 0xC5	; 197
 b3e:	06 c0       	rjmp	.+12     	; 0xb4c
 b40:	50 91 bb 00 	lds	r21, 0x00BB
 b44:	50 93 3d 01 	sts	0x013D, r21
 b48:	f9 cf       	rjmp	.-14     	; 0xb3c
 b4a:	85 e8       	ldi	r24, 0x85	; 133
 b4c:	80 93 bc 00 	sts	0x00BC, r24
 b50:	ff 91       	pop	r31
 b52:	ef 91       	pop	r30
 b54:	bf 91       	pop	r27
 b56:	af 91       	pop	r26
 b58:	9f 91       	pop	r25
 b5a:	8f 91       	pop	r24
 b5c:	7f 91       	pop	r23
 b5e:	6f 91       	pop	r22
 b60:	5f 91       	pop	r21
 b62:	4f 91       	pop	r20
 b64:	3f 91       	pop	r19
 b66:	2f 91       	pop	r18
 b68:	0f 90       	pop	r0
 b6a:	0f be       	out	0x3f, r0	; 63
 b6c:	0f 90       	pop	r0
 b6e:	1f 90       	pop	r1
 b70:	18 95       	reti

00000b72 <init_CB3>:
 b72:	2c 98       	cbi	0x05, 4	; 5
 b74:	2d 98       	cbi	0x05, 5	; 5
 b76:	24 9a       	sbi	0x04, 4	; 4
 b78:	25 9a       	sbi	0x04, 5	; 4
 b7a:	52 98       	cbi	0x0a, 2	; 10
 b7c:	e0 e5       	ldi	r30, 0x50	; 80
 b7e:	f1 e0       	ldi	r31, 0x01	; 1
 b80:	87 e0       	ldi	r24, 0x07	; 7
 b82:	11 92       	st	Z+, r1
 b84:	81 50       	subi	r24, 0x01	; 1
 b86:	87 ff       	sbrs	r24, 7
 b88:	fc cf       	rjmp	.-8      	; 0xb82
 b8a:	08 95       	ret

00000b8c <read_CB3_1B>:
 b8c:	e7 e5       	ldi	r30, 0x57	; 87
 b8e:	f1 e0       	ldi	r31, 0x01	; 1
 b90:	97 e0       	ldi	r25, 0x07	; 7
 b92:	89 b1       	in	r24, 0x09	; 9
 b94:	80 83       	st	Z, r24
 b96:	2d 9a       	sbi	0x05, 5	; 5
 b98:	2d 98       	cbi	0x05, 5	; 5
 b9a:	91 50       	subi	r25, 0x01	; 1
 b9c:	31 97       	sbiw	r30, 0x01	; 1
 b9e:	97 ff       	sbrs	r25, 7
 ba0:	f8 cf       	rjmp	.-16     	; 0xb92
 ba2:	08 95       	ret

00000ba4 <read_CB3>:
 ba4:	2c 9a       	sbi	0x05, 4	; 5
 ba6:	e7 e5       	ldi	r30, 0x57	; 87
 ba8:	f1 e0       	ldi	r31, 0x01	; 1
 baa:	97 e0       	ldi	r25, 0x07	; 7
 bac:	89 b1       	in	r24, 0x09	; 9
 bae:	80 83       	st	Z, r24
 bb0:	2d 9a       	sbi	0x05, 5	; 5
 bb2:	2d 98       	cbi	0x05, 5	; 5
 bb4:	91 50       	subi	r25, 0x01	; 1
 bb6:	31 97       	sbiw	r30, 0x01	; 1
 bb8:	97 ff       	sbrs	r25, 7
 bba:	f8 cf       	rjmp	.-16     	; 0xbac
 bbc:	2c 98       	cbi	0x05, 4	; 5
 bbe:	08 95       	ret
