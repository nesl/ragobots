
iris_u.elf:     file format elf32-avr

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .data         00000000  00800100  0000145a  000014ee  2**0
                  CONTENTS, ALLOC, LOAD, DATA
  1 .text         0000145a  00000000  00000000  00000094  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  2 .bss          00000013  00800100  00800100  000014ee  2**0
                  ALLOC
  3 .noinit       00000000  00800113  00800113  000014ee  2**0
                  CONTENTS
  4 .eeprom       00000000  00810000  00810000  000014ee  2**0
                  CONTENTS
  5 .debug_aranges 00000050  00000000  00000000  000014ee  2**0
                  CONTENTS, READONLY, DEBUGGING
  6 .debug_pubnames 00000226  00000000  00000000  0000153e  2**0
                  CONTENTS, READONLY, DEBUGGING
  7 .debug_info   00000ecb  00000000  00000000  00001764  2**0
                  CONTENTS, READONLY, DEBUGGING
  8 .debug_abbrev 000003cc  00000000  00000000  0000262f  2**0
                  CONTENTS, READONLY, DEBUGGING
  9 .debug_line   00000b20  00000000  00000000  000029fb  2**0
                  CONTENTS, READONLY, DEBUGGING
 10 .debug_str    0000028c  00000000  00000000  0000351b  2**0
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
      60:	0c 94 4f 00 	jmp	0x9e
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
      7a:	ea e5       	ldi	r30, 0x5A	; 90
      7c:	f4 e1       	ldi	r31, 0x14	; 20
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
      94:	a3 31       	cpi	r26, 0x13	; 19
      96:	b1 07       	cpc	r27, r17
      98:	e1 f7       	brne	.-8      	; 0x92
      9a:	0c 94 76 00 	jmp	0xec

0000009e <__bad_interrupt>:
      9e:	0c 94 00 00 	jmp	0x0

000000a2 <init_mcu>:
//----------------------------------------------------------------

void init_mcu(void) {
	// Input/Output Ports initialization
  		sbi(DDRB, 1); //IRIS_LED1 as ouput
      a2:	21 9a       	sbi	0x04, 1	; 4
		DDRB = B8(10010110); //DNC pins are outputs; 
      a4:	26 e9       	ldi	r18, 0x96	; 150
      a6:	24 b9       	out	0x04, r18	; 4
		sbi(PORTB, 5); //enable pull-up resistor on PGM_CLK input
      a8:	2d 9a       	sbi	0x05, 5	; 5
						//xxx check if there is a master pull-up enable or something that needs to be turned on
		//PORTC init is controlled by iris_init() in ircomm.c
		DDRD = B8(11111010); //DNC pins are outputs; TP are outputs; IRIS_CTRL is input
      aa:	8a ef       	ldi	r24, 0xFA	; 250
      ac:	8a b9       	out	0x0a, r24	; 10
		sbi(PORTD, 2); //enable pull-up resistor on IRIS_CTRL
      ae:	5a 9a       	sbi	0x0b, 2	; 11
      b0:	08 95       	ret

000000b2 <init_clock>:
		
} //init_MCU

//Configures 16-bit timer and starts it running; non-interrupt mode of operation
void init_clock(void){
	TCCR1A = B8(00000000);	
      b2:	10 92 80 00 	sts	0x0080, r1
	TCCR1B = B8(00001001);
      b6:	39 e0       	ldi	r19, 0x09	; 9
      b8:	30 93 81 00 	sts	0x0081, r19
	TCCR1C = B8(00000000);
      bc:	10 92 82 00 	sts	0x0082, r1
	OCR1AH = 0x03; //number of 16MHz cycles to run the timer for before interrupt flag is set
      c0:	23 e0       	ldi	r18, 0x03	; 3
      c2:	20 93 89 00 	sts	0x0089, r18
	OCR1AL = 0x80; //d640 = 40uS period
      c6:	80 e8       	ldi	r24, 0x80	; 128
      c8:	80 93 88 00 	sts	0x0088, r24
      cc:	08 95       	ret

000000ce <stall>:
}

void stall(uint16_t limit){
  uint16_t blah, i, j;
  blah=0;
      ce:	40 e0       	ldi	r20, 0x00	; 0
      d0:	50 e0       	ldi	r21, 0x00	; 0
  for(i=0;i<0xFFFF;i++){
    for(j=0;j<limit;j++){
      d2:	00 97       	sbiw	r24, 0x00	; 0
      d4:	21 f0       	breq	.+8      	; 0xde
      d6:	9c 01       	movw	r18, r24
      d8:	21 50       	subi	r18, 0x01	; 1
      da:	30 40       	sbci	r19, 0x00	; 0
      dc:	e9 f7       	brne	.-6      	; 0xd8
      de:	4f 5f       	subi	r20, 0xFF	; 255
      e0:	5f 4f       	sbci	r21, 0xFF	; 255
      e2:	2f ef       	ldi	r18, 0xFF	; 255
      e4:	4f 3f       	cpi	r20, 0xFF	; 255
      e6:	52 07       	cpc	r21, r18
      e8:	a1 f7       	brne	.-24     	; 0xd2
      ea:	08 95       	ret

000000ec <main>:
      blah++;
    }
  }	
}



//----------------------------------------------------------------
//- MAIN PROGRAM
//----------------------------------------------------------------

int main(void){
      ec:	cf ef       	ldi	r28, 0xFF	; 255
      ee:	d4 e0       	ldi	r29, 0x04	; 4
      f0:	de bf       	out	0x3e, r29	; 62
      f2:	cd bf       	out	0x3d, r28	; 61
	//VAR
		uint8_t xfr_timer;
	//INIT
		cli(); //disable interrupts (in case function is called multiple times)
      f4:	f8 94       	cli
		init_tp();
      f6:	0e 94 e7 09 	call	0x13ce
      fa:	21 9a       	sbi	0x04, 1	; 4
      fc:	56 e9       	ldi	r21, 0x96	; 150
      fe:	54 b9       	out	0x04, r21	; 4
     100:	2d 9a       	sbi	0x05, 5	; 5
     102:	4a ef       	ldi	r20, 0xFA	; 250
     104:	4a b9       	out	0x0a, r20	; 10
     106:	5a 9a       	sbi	0x0b, 2	; 11
		init_mcu();
		init_air();
     108:	0e 94 e6 00 	call	0x1cc
		init_iris();
     10c:	0e 94 f4 00 	call	0x1e8
		init_serial(USRT);
     110:	8d e0       	ldi	r24, 0x0D	; 13
     112:	0e 94 4c 02 	call	0x498
     116:	10 92 80 00 	sts	0x0080, r1
     11a:	39 e0       	ldi	r19, 0x09	; 9
     11c:	30 93 81 00 	sts	0x0081, r19
     120:	10 92 82 00 	sts	0x0082, r1
     124:	23 e0       	ldi	r18, 0x03	; 3
     126:	20 93 89 00 	sts	0x0089, r18
     12a:	80 e8       	ldi	r24, 0x80	; 128
     12c:	80 93 88 00 	sts	0x0088, r24
		init_clock();
		tpl(OFF); //debug led off		
     130:	82 e0       	ldi	r24, 0x02	; 2
     132:	0e 94 eb 09 	call	0x13d6
		sbi(TIFR1, 1); //reset clock interrupt
     136:	b1 9a       	sbi	0x16, 1	; 22
		xfr_timer = 0;
     138:	c0 e0       	ldi	r28, 0x00	; 0
     13a:	80 e0       	ldi	r24, 0x00	; 0
     13c:	90 e0       	ldi	r25, 0x00	; 0
     13e:	01 96       	adiw	r24, 0x01	; 1
     140:	2f ef       	ldi	r18, 0xFF	; 255
     142:	8f 3f       	cpi	r24, 0xFF	; 255
     144:	92 07       	cpc	r25, r18
     146:	d9 f7       	brne	.-10     	; 0x13e

	//WAIT FOR IRISL TO BOOT
		stall(3); //let pull-up resistor have some time to charge the input
		while(PIND & _BV(2) == 0x00); //wait for IRISL to boot up
     148:	89 b1       	in	r24, 0x09	; 9
		
	//PGM	
	  	while(1){ 	
		  	//Timing loop indicator
		  		tp5(HIGH); //RTOS timing indicator xxx
     14a:	81 e0       	ldi	r24, 0x01	; 1
     14c:	0e 94 17 0a 	call	0x142e
			//Wait for arriving bytes
		  		air_get_channels();
     150:	0e 94 f7 00 	call	0x1ee
		  		/*
		  		if (get_air_capture() != 0x00) {
			  		UART_send_BIN8(get_air_capture());
					send_byte_serial(10);
			  		send_byte_serial(13);
		  		}
		  		*/
		  		//DEBUG: CLONE CHANNEL TO EXTRAPOLATE WORST CASE PROCESSING SCENARIO
		  		/*
		  		if ((get_air_capture() & B8(00100000)) == 0x00){
			  		set_air_capture(0x00);	
		  		}
		  		else {
			  		set_air_capture(0xFF);
		  		}
		  		*/
		  		set_air_capture(0x00);
     154:	80 e0       	ldi	r24, 0x00	; 0
     156:	0e 94 0b 01 	call	0x216
		  		
		  	//Process each new symbol through its channel machine
				air_proc_channel(0);//0
     15a:	80 e0       	ldi	r24, 0x00	; 0
     15c:	0e 94 36 01 	call	0x26c
				air_proc_channel(1);//1
     160:	81 e0       	ldi	r24, 0x01	; 1
     162:	0e 94 36 01 	call	0x26c
				air_proc_channel(2);//2
     166:	82 e0       	ldi	r24, 0x02	; 2
     168:	0e 94 36 01 	call	0x26c
				air_proc_channel(3);//3
     16c:	83 e0       	ldi	r24, 0x03	; 3
     16e:	0e 94 36 01 	call	0x26c
				air_proc_channel(4);//4
     172:	84 e0       	ldi	r24, 0x04	; 4
     174:	0e 94 36 01 	call	0x26c
				air_proc_channel(5);//5
     178:	85 e0       	ldi	r24, 0x05	; 5
     17a:	0e 94 36 01 	call	0x26c
				air_proc_channel(6);//6
     17e:	86 e0       	ldi	r24, 0x06	; 6
     180:	0e 94 36 01 	call	0x26c
			
			//Manage the XFR queue (to IRISL)
				xfr_timer++;
     184:	cf 5f       	subi	r28, 0xFF	; 255
				//1000uS period over 56uS interval = 17 (952uS)
				//PIND.2 is a control line from IRISL effectively implementing flow control.
				if (xfr_timer >= 17 && ((PIND & _BV(2)) > 0)){ 
     186:	c1 31       	cpi	r28, 0x11	; 17
     188:	28 f0       	brcs	.+10     	; 0x194
     18a:	4a 9b       	sbis	0x09, 2	; 9
     18c:	03 c0       	rjmp	.+6      	; 0x194
					xfr_timer = 0;
     18e:	c0 e0       	ldi	r28, 0x00	; 0
					//transfer_sym();	
					transfer_sym_debug();	
     190:	0e 94 f9 01 	call	0x3f2
				}
				
				//debug_transfer_sym();
				//tpl(TOGGLE);	
				
			//Close timing loop
				tp5(LOW); //RTOS timing indicator xxx
     194:	82 e0       	ldi	r24, 0x02	; 2
     196:	0e 94 17 0a 	call	0x142e
     19a:	21 e0       	ldi	r18, 0x01	; 1
     19c:	30 e0       	ldi	r19, 0x00	; 0
				
			//Constant sample time
				while((TIFR1 & 2) == 0x00);
     19e:	86 b3       	in	r24, 0x16	; 22
     1a0:	99 27       	eor	r25, r25
     1a2:	96 95       	lsr	r25
     1a4:	87 95       	ror	r24
     1a6:	81 70       	andi	r24, 0x01	; 1
     1a8:	90 70       	andi	r25, 0x00	; 0
     1aa:	82 17       	cp	r24, r18
     1ac:	93 07       	cpc	r25, r19
     1ae:	b9 f7       	brne	.-18     	; 0x19e
				sbi(TIFR1, 1);
     1b0:	b1 9a       	sbi	0x16, 1	; 22
     1b2:	cb cf       	rjmp	.-106    	; 0x14a

000001b4 <init_array>:
//----------------------------------------------------------------

void init_array(uint8_t* toinit, uint8_t size, uint8_t init_val){
	uint8_t i;
	for (i=0;i<size;i++){
     1b4:	66 23       	and	r22, r22
     1b6:	21 f0       	breq	.+8      	; 0x1c0
     1b8:	fc 01       	movw	r30, r24
		toinit[i] = init_val;
     1ba:	41 93       	st	Z+, r20
     1bc:	61 50       	subi	r22, 0x01	; 1
     1be:	e9 f7       	brne	.-6      	; 0x1ba
     1c0:	08 95       	ret

000001c2 <reset_sym_xfr>:
	}
}

//logical state setup
inline void init_air(){
	init_array(p_state, NUM__OF_CHANNELS, S0);
	reset_sym_xfr();
	q_level = 0x00; //all enqueue-ing begins at level 0
}

//physical pin setup
inline void init_iris(){
	cbi(DDRB,0); //IR_RX_CHNL6 as input
	DDRC = 0x00; //IR_RX_CHNL[0-5] as inputs
}


//----------------------------------------------------------------
//- IRIS SIGNAL-TO-SYMBOL DECODER
//----------------------------------------------------------------

inline void air_get_channels(){
	air_capture = PINC | (PINB << 6); //This works because..
	//..PC6 will read as zero because fused to be reset line (i.e. GPIO is disabled); 
	//..PB0 is the 6th channel so left shift by 6 get is from 0 bit position to 6th position;
	//..PC7 is potentially corrupted, but we'll never analyze that bit so we don't care!
}

//return the air_Capture data for debugging
inline uint8_t get_air_capture(void){
	return air_capture;	
}

inline void set_air_capture(uint8_t newval){
	air_capture = newval;	
}
		
inline void air_proc_channel(uint8_t channel_num){
	uint8_t new_bit;
	new_bit = air_capture & _BV(channel_num);
	switch (p_state[channel_num]){
		
		//Look for rising edge (assuming inverter)
		case S0: 
			if (new_bit != 0x00){
				z_count[channel_num] = 1; //found the first one (assumes inverter)
				p_state[channel_num] = S1;	
			}
			break;	
		
		//Count the ones (assuming inverter)
		case S1: 
			if (new_bit != 0x00){
				if (z_count[channel_num] != 0xFF){ //error case of channel noise producing extended "white-out", do not roll-over count!
					z_count[channel_num]++;
				}
			}
			else {
				p_state[channel_num] = S2;	//if detected falling edge, counting is done (next state) (assumes inverter)
			}	
			break;
		
		//Counted ones --> symbols; interpret symbols (assuming inverter)
		case S2: 
			if ((z_count[channel_num] >= SYM_1) && (z_count[channel_num] <= SYM_1+SYM_1_MARGIN)){
				//FOUND LOGIC ONE
				load_sym_xfr(channel_num, QSYM_1);
			}
			else if ((z_count[channel_num] >= SYM_0) && (z_count[channel_num] <= SYM_0+SYM_0_MARGIN)){
				//FOUND LOGIC ZERO
				load_sym_xfr(channel_num, QSYM_0);
			}
			else if ((z_count[channel_num] >= SYM_START) && (z_count[channel_num] <= SYM_START+SYM_START_MARGIN)){
				//FOUND START
				load_sym_xfr(channel_num, QSYM_START);
			}
			p_state[channel_num] = S0;
			break;
			
		default:
			p_state[channel_num] = S0;
			break;
	}
}


//----------------------------------------------------------------
//- IRIS SYMBOL TRANSFER SYSTEM (IRISU-to-IRISL)
//----------------------------------------------------------------

//symbol is one of the QSYM values
void load_sym_xfr(uint8_t channel_num, uint8_t symbol){
	if 	(channel_num < 4){
		sym_xfr[0] = sym_xfr[0] | (symbol<<(channel_num*2));
	}
	else if (channel_num < NUM__OF_CHANNELS){
		sym_xfr[1] = sym_xfr[1] | (symbol<<((channel_num-4)*2));
	}
	//else do nothing
}

//transfer the sym_xfr queue to IRISL
//uses forced transfers which means that the UART buffer is assumed to be empty
//no safety checking is performed.
void transfer_sym(void){
	uart0_force_byte(sym_xfr[1]);	
	uart0_force_byte(sym_xfr[0]);	
	reset_sym_xfr();
}

void transfer_sym_debug(void){
	static uint8_t vector_counter = 0;
	vector_counter++;
	
	//vector_counter = 2; //xxx
	
	switch (vector_counter){
	case 1:
		//START
		send_byte_serial(0xFF);	
		send_byte_serial(0xFF);	
		break;
	case 2:
		//D0
		send_byte_serial(0x55);	
		send_byte_serial(0x55);	
		break;
	case 3:
		//D1
		send_byte_serial(0xAA);	
		send_byte_serial(0xAA);	
		break;
	case 4:
		//D1
		send_byte_serial(0xAA);	
		send_byte_serial(0xAA);	
		break;
	case 5:
		//D0
		send_byte_serial(0x55);	
		send_byte_serial(0x55);	
		break;
	case 6:
		//D1
		send_byte_serial(0xAA);	
		send_byte_serial(0xAA);	
		break;
	case 7:
		//D0
		send_byte_serial(0x55);	
		send_byte_serial(0x55);	
		break;
	case 8:
		//D1
		send_byte_serial(0xAA);	
		send_byte_serial(0xAA);	
		break;
	case 9:
		//D0
		send_byte_serial(0x55);	
		send_byte_serial(0x55);	
tpl(ON); //xxx
		break;
	default:
		if (vector_counter > 250) {
			vector_counter = 200;	
		}
	}
	reset_sym_xfr();
}
/*
void debug_transfer_sym(void){
	if ((sym_xfr[1] != 0x00) || (sym_xfr[0] != 0x00)){
		send_byte_serial('r');
		UART_send_BIN8(sym_xfr[1]);	
		send_byte_serial('-');
		UART_send_BIN8(sym_xfr[0]);	
		send_byte_serial(10);
		send_byte_serial(13);
	}
	reset_sym_xfr();
}
*/
//reset sym_xfr queue
inline void reset_sym_xfr(void){
	sym_xfr[1]=0x00;
     1c2:	10 92 04 01 	sts	0x0104, r1
	sym_xfr[0]=0x00;
     1c6:	10 92 03 01 	sts	0x0103, r1
     1ca:	08 95       	ret

000001cc <init_air>:
     1cc:	e5 e0       	ldi	r30, 0x05	; 5
     1ce:	f1 e0       	ldi	r31, 0x01	; 1
     1d0:	86 e0       	ldi	r24, 0x06	; 6
     1d2:	11 92       	st	Z+, r1
     1d4:	81 50       	subi	r24, 0x01	; 1
     1d6:	87 ff       	sbrs	r24, 7
     1d8:	fc cf       	rjmp	.-8      	; 0x1d2
     1da:	10 92 04 01 	sts	0x0104, r1
     1de:	10 92 03 01 	sts	0x0103, r1
     1e2:	10 92 02 01 	sts	0x0102, r1
     1e6:	08 95       	ret

000001e8 <init_iris>:
     1e8:	20 98       	cbi	0x04, 0	; 4
     1ea:	17 b8       	out	0x07, r1	; 7
     1ec:	08 95       	ret

000001ee <air_get_channels>:
     1ee:	83 b1       	in	r24, 0x03	; 3
     1f0:	99 27       	eor	r25, r25
     1f2:	00 24       	eor	r0, r0
     1f4:	96 95       	lsr	r25
     1f6:	87 95       	ror	r24
     1f8:	07 94       	ror	r0
     1fa:	96 95       	lsr	r25
     1fc:	87 95       	ror	r24
     1fe:	07 94       	ror	r0
     200:	98 2f       	mov	r25, r24
     202:	80 2d       	mov	r24, r0
     204:	26 b1       	in	r18, 0x06	; 6
     206:	28 2b       	or	r18, r24
     208:	20 93 01 01 	sts	0x0101, r18
     20c:	08 95       	ret

0000020e <get_air_capture>:
     20e:	80 91 01 01 	lds	r24, 0x0101
     212:	99 27       	eor	r25, r25
     214:	08 95       	ret

00000216 <set_air_capture>:
     216:	80 93 01 01 	sts	0x0101, r24
     21a:	08 95       	ret

0000021c <load_sym_xfr>:
     21c:	28 2f       	mov	r18, r24
     21e:	84 30       	cpi	r24, 0x04	; 4
     220:	80 f4       	brcc	.+32     	; 0x242
     222:	86 2f       	mov	r24, r22
     224:	99 27       	eor	r25, r25
     226:	33 27       	eor	r19, r19
     228:	22 0f       	add	r18, r18
     22a:	33 1f       	adc	r19, r19
     22c:	02 c0       	rjmp	.+4      	; 0x232
     22e:	88 0f       	add	r24, r24
     230:	99 1f       	adc	r25, r25
     232:	2a 95       	dec	r18
     234:	e2 f7       	brpl	.-8      	; 0x22e
     236:	20 91 03 01 	lds	r18, 0x0103
     23a:	28 2b       	or	r18, r24
     23c:	20 93 03 01 	sts	0x0103, r18
     240:	08 95       	ret
     242:	87 30       	cpi	r24, 0x07	; 7
     244:	88 f4       	brcc	.+34     	; 0x268
     246:	86 2f       	mov	r24, r22
     248:	99 27       	eor	r25, r25
     24a:	33 27       	eor	r19, r19
     24c:	22 0f       	add	r18, r18
     24e:	33 1f       	adc	r19, r19
     250:	28 50       	subi	r18, 0x08	; 8
     252:	30 40       	sbci	r19, 0x00	; 0
     254:	02 c0       	rjmp	.+4      	; 0x25a
     256:	88 0f       	add	r24, r24
     258:	99 1f       	adc	r25, r25
     25a:	2a 95       	dec	r18
     25c:	e2 f7       	brpl	.-8      	; 0x256
     25e:	30 91 04 01 	lds	r19, 0x0104
     262:	38 2b       	or	r19, r24
     264:	30 93 04 01 	sts	0x0104, r19
     268:	08 95       	ret
     26a:	08 95       	ret

0000026c <air_proc_channel>:
     26c:	58 2f       	mov	r21, r24
     26e:	a8 2f       	mov	r26, r24
     270:	bb 27       	eor	r27, r27
     272:	61 e0       	ldi	r22, 0x01	; 1
     274:	70 e0       	ldi	r23, 0x00	; 0
     276:	cb 01       	movw	r24, r22
     278:	0a 2e       	mov	r0, r26
     27a:	02 c0       	rjmp	.+4      	; 0x280
     27c:	88 0f       	add	r24, r24
     27e:	99 1f       	adc	r25, r25
     280:	0a 94       	dec	r0
     282:	e2 f7       	brpl	.-8      	; 0x27c
     284:	40 91 01 01 	lds	r20, 0x0101
     288:	48 23       	and	r20, r24
     28a:	fd 01       	movw	r30, r26
     28c:	eb 5f       	subi	r30, 0xFB	; 251
     28e:	fe 4f       	sbci	r31, 0xFE	; 254
     290:	80 81       	ld	r24, Z
     292:	28 2f       	mov	r18, r24
     294:	33 27       	eor	r19, r19
     296:	26 17       	cp	r18, r22
     298:	37 07       	cpc	r19, r23
     29a:	51 f0       	breq	.+20     	; 0x2b0
     29c:	62 17       	cp	r22, r18
     29e:	73 07       	cpc	r23, r19
     2a0:	8c f5       	brge	.+98     	; 0x304
     2a2:	22 30       	cpi	r18, 0x02	; 2
     2a4:	31 05       	cpc	r19, r1
     2a6:	79 f0       	breq	.+30     	; 0x2c6
     2a8:	ab 5f       	subi	r26, 0xFB	; 251
     2aa:	be 4f       	sbci	r27, 0xFE	; 254
     2ac:	1c 92       	st	X, r1
     2ae:	08 95       	ret
     2b0:	44 23       	and	r20, r20
     2b2:	29 f1       	breq	.+74     	; 0x2fe
     2b4:	fd 01       	movw	r30, r26
     2b6:	e4 5f       	subi	r30, 0xF4	; 244
     2b8:	fe 4f       	sbci	r31, 0xFE	; 254
     2ba:	80 81       	ld	r24, Z
     2bc:	8f 3f       	cpi	r24, 0xFF	; 255
     2be:	b9 f3       	breq	.-18     	; 0x2ae
     2c0:	8f 5f       	subi	r24, 0xFF	; 255
     2c2:	80 83       	st	Z, r24
     2c4:	08 95       	ret
     2c6:	fd 01       	movw	r30, r26
     2c8:	e4 5f       	subi	r30, 0xF4	; 244
     2ca:	fe 4f       	sbci	r31, 0xFE	; 254
     2cc:	e0 81       	ld	r30, Z
     2ce:	4e 2f       	mov	r20, r30
     2d0:	44 50       	subi	r20, 0x04	; 4
     2d2:	42 30       	cpi	r20, 0x02	; 2
     2d4:	08 f5       	brcc	.+66     	; 0x318
     2d6:	54 30       	cpi	r21, 0x04	; 4
     2d8:	08 f4       	brcc	.+2      	; 0x2dc
     2da:	4b c0       	rjmp	.+150    	; 0x372
     2dc:	57 30       	cpi	r21, 0x07	; 7
     2de:	a8 f5       	brcc	.+106    	; 0x34a
     2e0:	cd 01       	movw	r24, r26
     2e2:	8a 0f       	add	r24, r26
     2e4:	9b 1f       	adc	r25, r27
     2e6:	08 97       	sbiw	r24, 0x08	; 8
     2e8:	02 c0       	rjmp	.+4      	; 0x2ee
     2ea:	22 0f       	add	r18, r18
     2ec:	33 1f       	adc	r19, r19
     2ee:	8a 95       	dec	r24
     2f0:	e2 f7       	brpl	.-8      	; 0x2ea
     2f2:	80 91 04 01 	lds	r24, 0x0104
     2f6:	82 2b       	or	r24, r18
     2f8:	80 93 04 01 	sts	0x0104, r24
     2fc:	26 c0       	rjmp	.+76     	; 0x34a
     2fe:	82 e0       	ldi	r24, 0x02	; 2
     300:	80 83       	st	Z, r24
     302:	08 95       	ret
     304:	23 2b       	or	r18, r19
     306:	81 f6       	brne	.-96     	; 0x2a8
     308:	44 23       	and	r20, r20
     30a:	89 f2       	breq	.-94     	; 0x2ae
     30c:	a4 5f       	subi	r26, 0xF4	; 244
     30e:	be 4f       	sbci	r27, 0xFE	; 254
     310:	81 e0       	ldi	r24, 0x01	; 1
     312:	8c 93       	st	X, r24
     314:	80 83       	st	Z, r24
     316:	08 95       	ret
     318:	2e 2f       	mov	r18, r30
     31a:	26 50       	subi	r18, 0x06	; 6
     31c:	22 30       	cpi	r18, 0x02	; 2
     31e:	c8 f0       	brcs	.+50     	; 0x352
     320:	e2 50       	subi	r30, 0x02	; 2
     322:	e2 30       	cpi	r30, 0x02	; 2
     324:	90 f4       	brcc	.+36     	; 0x34a
     326:	54 30       	cpi	r21, 0x04	; 4
     328:	08 f0       	brcs	.+2      	; 0x32c
     32a:	42 c0       	rjmp	.+132    	; 0x3b0
     32c:	83 e0       	ldi	r24, 0x03	; 3
     32e:	90 e0       	ldi	r25, 0x00	; 0
     330:	9d 01       	movw	r18, r26
     332:	2a 0f       	add	r18, r26
     334:	3b 1f       	adc	r19, r27
     336:	02 c0       	rjmp	.+4      	; 0x33c
     338:	88 0f       	add	r24, r24
     33a:	99 1f       	adc	r25, r25
     33c:	2a 95       	dec	r18
     33e:	e2 f7       	brpl	.-8      	; 0x338
     340:	30 91 03 01 	lds	r19, 0x0103
     344:	38 2b       	or	r19, r24
     346:	30 93 03 01 	sts	0x0103, r19
     34a:	ab 5f       	subi	r26, 0xFB	; 251
     34c:	be 4f       	sbci	r27, 0xFE	; 254
     34e:	1c 92       	st	X, r1
     350:	08 95       	ret
     352:	54 30       	cpi	r21, 0x04	; 4
     354:	e0 f4       	brcc	.+56     	; 0x38e
     356:	cd 01       	movw	r24, r26
     358:	8a 0f       	add	r24, r26
     35a:	9b 1f       	adc	r25, r27
     35c:	02 c0       	rjmp	.+4      	; 0x362
     35e:	66 0f       	add	r22, r22
     360:	77 1f       	adc	r23, r23
     362:	8a 95       	dec	r24
     364:	e2 f7       	brpl	.-8      	; 0x35e
     366:	80 91 03 01 	lds	r24, 0x0103
     36a:	86 2b       	or	r24, r22
     36c:	80 93 03 01 	sts	0x0103, r24
     370:	ec cf       	rjmp	.-40     	; 0x34a
     372:	cd 01       	movw	r24, r26
     374:	8a 0f       	add	r24, r26
     376:	9b 1f       	adc	r25, r27
     378:	02 c0       	rjmp	.+4      	; 0x37e
     37a:	22 0f       	add	r18, r18
     37c:	33 1f       	adc	r19, r19
     37e:	8a 95       	dec	r24
     380:	e2 f7       	brpl	.-8      	; 0x37a
     382:	80 91 03 01 	lds	r24, 0x0103
     386:	82 2b       	or	r24, r18
     388:	80 93 03 01 	sts	0x0103, r24
     38c:	de cf       	rjmp	.-68     	; 0x34a
     38e:	57 30       	cpi	r21, 0x07	; 7
     390:	e0 f6       	brcc	.-72     	; 0x34a
     392:	cd 01       	movw	r24, r26
     394:	8a 0f       	add	r24, r26
     396:	9b 1f       	adc	r25, r27
     398:	08 97       	sbiw	r24, 0x08	; 8
     39a:	02 c0       	rjmp	.+4      	; 0x3a0
     39c:	66 0f       	add	r22, r22
     39e:	77 1f       	adc	r23, r23
     3a0:	8a 95       	dec	r24
     3a2:	e2 f7       	brpl	.-8      	; 0x39c
     3a4:	80 91 04 01 	lds	r24, 0x0104
     3a8:	86 2b       	or	r24, r22
     3aa:	80 93 04 01 	sts	0x0104, r24
     3ae:	cd cf       	rjmp	.-102    	; 0x34a
     3b0:	57 30       	cpi	r21, 0x07	; 7
     3b2:	58 f6       	brcc	.-106    	; 0x34a
     3b4:	83 e0       	ldi	r24, 0x03	; 3
     3b6:	90 e0       	ldi	r25, 0x00	; 0
     3b8:	9d 01       	movw	r18, r26
     3ba:	2a 0f       	add	r18, r26
     3bc:	3b 1f       	adc	r19, r27
     3be:	28 50       	subi	r18, 0x08	; 8
     3c0:	30 40       	sbci	r19, 0x00	; 0
     3c2:	02 c0       	rjmp	.+4      	; 0x3c8
     3c4:	88 0f       	add	r24, r24
     3c6:	99 1f       	adc	r25, r25
     3c8:	2a 95       	dec	r18
     3ca:	e2 f7       	brpl	.-8      	; 0x3c4
     3cc:	50 91 04 01 	lds	r21, 0x0104
     3d0:	58 2b       	or	r21, r24
     3d2:	50 93 04 01 	sts	0x0104, r21
     3d6:	b9 cf       	rjmp	.-142    	; 0x34a

000003d8 <transfer_sym>:
     3d8:	80 91 04 01 	lds	r24, 0x0104
     3dc:	0e 94 8a 02 	call	0x514
     3e0:	80 91 03 01 	lds	r24, 0x0103
     3e4:	0e 94 8a 02 	call	0x514
     3e8:	10 92 04 01 	sts	0x0104, r1
     3ec:	10 92 03 01 	sts	0x0103, r1
     3f0:	08 95       	ret

000003f2 <transfer_sym_debug>:
     3f2:	20 91 00 01 	lds	r18, 0x0100
     3f6:	2f 5f       	subi	r18, 0xFF	; 255
     3f8:	82 2f       	mov	r24, r18
     3fa:	99 27       	eor	r25, r25
     3fc:	85 30       	cpi	r24, 0x05	; 5
     3fe:	91 05       	cpc	r25, r1
     400:	41 f1       	breq	.+80     	; 0x452
     402:	86 30       	cpi	r24, 0x06	; 6
     404:	91 05       	cpc	r25, r1
     406:	8c f0       	brlt	.+34     	; 0x42a
     408:	87 30       	cpi	r24, 0x07	; 7
     40a:	91 05       	cpc	r25, r1
     40c:	11 f1       	breq	.+68     	; 0x452
     40e:	87 30       	cpi	r24, 0x07	; 7
     410:	91 05       	cpc	r25, r1
     412:	b4 f0       	brlt	.+44     	; 0x440
     414:	88 30       	cpi	r24, 0x08	; 8
     416:	91 05       	cpc	r25, r1
     418:	99 f0       	breq	.+38     	; 0x440
     41a:	09 97       	sbiw	r24, 0x09	; 9
     41c:	69 f1       	breq	.+90     	; 0x478
     41e:	2b 3f       	cpi	r18, 0xFB	; 251
     420:	40 f1       	brcs	.+80     	; 0x472
     422:	88 ec       	ldi	r24, 0xC8	; 200
     424:	80 93 00 01 	sts	0x0100, r24
     428:	32 c0       	rjmp	.+100    	; 0x48e
     42a:	82 30       	cpi	r24, 0x02	; 2
     42c:	91 05       	cpc	r25, r1
     42e:	89 f0       	breq	.+34     	; 0x452
     430:	83 30       	cpi	r24, 0x03	; 3
     432:	91 05       	cpc	r25, r1
     434:	ac f0       	brlt	.+42     	; 0x460
     436:	83 30       	cpi	r24, 0x03	; 3
     438:	91 05       	cpc	r25, r1
     43a:	11 f0       	breq	.+4      	; 0x440
     43c:	04 97       	sbiw	r24, 0x04	; 4
     43e:	79 f7       	brne	.-34     	; 0x41e
     440:	20 93 00 01 	sts	0x0100, r18
     444:	8a ea       	ldi	r24, 0xAA	; 170
     446:	0e 94 74 02 	call	0x4e8
     44a:	8a ea       	ldi	r24, 0xAA	; 170
     44c:	0e 94 74 02 	call	0x4e8
     450:	1e c0       	rjmp	.+60     	; 0x48e
     452:	20 93 00 01 	sts	0x0100, r18
     456:	85 e5       	ldi	r24, 0x55	; 85
     458:	0e 94 74 02 	call	0x4e8
     45c:	85 e5       	ldi	r24, 0x55	; 85
     45e:	f6 cf       	rjmp	.-20     	; 0x44c
     460:	01 97       	sbiw	r24, 0x01	; 1
     462:	e9 f6       	brne	.-70     	; 0x41e
     464:	20 93 00 01 	sts	0x0100, r18
     468:	8f ef       	ldi	r24, 0xFF	; 255
     46a:	0e 94 74 02 	call	0x4e8
     46e:	8f ef       	ldi	r24, 0xFF	; 255
     470:	ed cf       	rjmp	.-38     	; 0x44c
     472:	20 93 00 01 	sts	0x0100, r18
     476:	0b c0       	rjmp	.+22     	; 0x48e
     478:	20 93 00 01 	sts	0x0100, r18
     47c:	85 e5       	ldi	r24, 0x55	; 85
     47e:	0e 94 74 02 	call	0x4e8
     482:	85 e5       	ldi	r24, 0x55	; 85
     484:	0e 94 74 02 	call	0x4e8
     488:	81 e0       	ldi	r24, 0x01	; 1
     48a:	0e 94 eb 09 	call	0x13d6
     48e:	10 92 04 01 	sts	0x0104, r1
     492:	10 92 03 01 	sts	0x0103, r1
     496:	08 95       	ret

00000498 <init_serial>:
//==================================

//USRT MODE! MASTER
void init_serial(uint8_t mode){
	switch (mode){
     498:	8d 30       	cpi	r24, 0x0D	; 13
     49a:	81 f0       	breq	.+32     	; 0x4bc
		case(USRT):
			// USRT initialization
			UCSR0A=0x02;//just flags in this register; DOUBLE SPEED MODE ON!
			UCSR0C=B8(00000110);//ASYNCHRONOUS; N,8-bit data,1 frame format; Clock polarity = data delta on rising, sample on falling edge
			UBRR0H=0x00;
			UBRR0L=0; //3 = 2.67 Mbps (megabits per second) from 16MHz clock
			sbi(DDRD,1); //TXD is output pin (data line)
			sbi(DDRD,4); //XCK is output pin (USRT clock line)
			UCSR0B=0x08;//No Rx; TX enabled - last line because operation begins on this flag
			break;
		case(UART):	
		default:
			// UART initialization
			UCSR0A=0x00;//just flags in this register
     49c:	10 92 c0 00 	sts	0x00C0, r1
			UCSR0C=B8(01000110);//SYNCHRONOUS (but ignore clock line because less error at BRG); N,8-bit data,1 frame format
     4a0:	46 e4       	ldi	r20, 0x46	; 70
     4a2:	40 93 c2 00 	sts	0x00C2, r20
			UBRR0H = 0;
     4a6:	10 92 c5 00 	sts	0x00C5, r1
			UBRR0L = 68; //115.2k bps from 16MHz clock
     4aa:	34 e4       	ldi	r19, 0x44	; 68
     4ac:	30 93 c4 00 	sts	0x00C4, r19
			sbi(DDRD,1); //TXD is output pin (data line)
     4b0:	51 9a       	sbi	0x0a, 1	; 10
			sbi(DDRD,4); //XCK is output pin (USRT clock line)
     4b2:	54 9a       	sbi	0x0a, 4	; 10
			UCSR0B=0x08;//No Rx; TX enabled - last line because operation begins on this flag		
     4b4:	58 e0       	ldi	r21, 0x08	; 8
     4b6:	50 93 c1 00 	sts	0x00C1, r21
     4ba:	08 95       	ret
     4bc:	22 e0       	ldi	r18, 0x02	; 2
     4be:	20 93 c0 00 	sts	0x00C0, r18
     4c2:	86 e0       	ldi	r24, 0x06	; 6
     4c4:	80 93 c2 00 	sts	0x00C2, r24
     4c8:	10 92 c5 00 	sts	0x00C5, r1
     4cc:	10 92 c4 00 	sts	0x00C4, r1
     4d0:	51 9a       	sbi	0x0a, 1	; 10
     4d2:	54 9a       	sbi	0x0a, 4	; 10
     4d4:	58 e0       	ldi	r21, 0x08	; 8
     4d6:	50 93 c1 00 	sts	0x00C1, r21
     4da:	08 95       	ret
     4dc:	08 95       	ret

000004de <USRT_send_2bytes>:
			break;
	}
}

//dataA is sent first
//this function built for speed, no safety checking. UART shift and buffer registers should be empty.
//The first write falls through to the actual output register freeing the buffer for byte 2.
void inline USRT_send_2bytes(unsigned char dataA, unsigned char dataB){
	// XXX
	UDR0 = dataA;
     4de:	80 93 c6 00 	sts	0x00C6, r24
	UDR0 = dataB;
     4e2:	60 93 c6 00 	sts	0x00C6, r22
     4e6:	08 95       	ret

000004e8 <send_byte_serial>:
	/*
	//DEBUG code to test the buffer ready for new data flag
	if(UCSR0A & B8(00100000)){ //true != 0, freeze on buffer avail
		stk_ledon(0xAA);
		while(1);
	}
	*/
}

void inline send_byte_serial(unsigned char dataB){
     4e8:	48 2f       	mov	r20, r24
     4ea:	21 e0       	ldi	r18, 0x01	; 1
     4ec:	30 e0       	ldi	r19, 0x00	; 0
	while ((UCSR0A & _BV(5)) != B8(00100000));
     4ee:	80 91 c0 00 	lds	r24, 0x00C0
     4f2:	99 27       	eor	r25, r25
     4f4:	96 95       	lsr	r25
     4f6:	87 95       	ror	r24
     4f8:	92 95       	swap	r25
     4fa:	82 95       	swap	r24
     4fc:	8f 70       	andi	r24, 0x0F	; 15
     4fe:	89 27       	eor	r24, r25
     500:	9f 70       	andi	r25, 0x0F	; 15
     502:	89 27       	eor	r24, r25
     504:	81 70       	andi	r24, 0x01	; 1
     506:	90 70       	andi	r25, 0x00	; 0
     508:	82 17       	cp	r24, r18
     50a:	93 07       	cpc	r25, r19
     50c:	81 f7       	brne	.-32     	; 0x4ee
	UDR0 = dataB;
     50e:	40 93 c6 00 	sts	0x00C6, r20
     512:	08 95       	ret

00000514 <uart0_force_byte>:
}

void inline uart0_force_byte(unsigned char dataB){
	UDR0 = dataB;
     514:	80 93 c6 00 	sts	0x00C6, r24
     518:	08 95       	ret

0000051a <UART_send_BIN4>:
}

//Most Significant Bit first
void UART_send_BIN4(uint8_t lowb){
	switch(lowb){
     51a:	99 27       	eor	r25, r25
     51c:	87 30       	cpi	r24, 0x07	; 7
     51e:	91 05       	cpc	r25, r1
     520:	09 f4       	brne	.+2      	; 0x524
     522:	cb c0       	rjmp	.+406    	; 0x6ba
     524:	88 30       	cpi	r24, 0x08	; 8
     526:	91 05       	cpc	r25, r1
     528:	0c f0       	brlt	.+2      	; 0x52c
     52a:	65 c0       	rjmp	.+202    	; 0x5f6
     52c:	83 30       	cpi	r24, 0x03	; 3
     52e:	91 05       	cpc	r25, r1
     530:	09 f4       	brne	.+2      	; 0x534
     532:	d4 c1       	rjmp	.+936    	; 0x8dc
     534:	84 30       	cpi	r24, 0x04	; 4
     536:	91 05       	cpc	r25, r1
     538:	0c f0       	brlt	.+2      	; 0x53c
     53a:	14 c1       	rjmp	.+552    	; 0x764
     53c:	81 30       	cpi	r24, 0x01	; 1
     53e:	91 05       	cpc	r25, r1
     540:	09 f4       	brne	.+2      	; 0x544
     542:	6c c3       	rjmp	.+1752   	; 0xc1c
     544:	82 30       	cpi	r24, 0x02	; 2
     546:	91 05       	cpc	r25, r1
     548:	0c f4       	brge	.+2      	; 0x54c
     54a:	ae c4       	rjmp	.+2396   	; 0xea8
     54c:	21 e0       	ldi	r18, 0x01	; 1
     54e:	30 e0       	ldi	r19, 0x00	; 0
     550:	80 91 c0 00 	lds	r24, 0x00C0
     554:	99 27       	eor	r25, r25
     556:	96 95       	lsr	r25
     558:	87 95       	ror	r24
     55a:	92 95       	swap	r25
     55c:	82 95       	swap	r24
     55e:	8f 70       	andi	r24, 0x0F	; 15
     560:	89 27       	eor	r24, r25
     562:	9f 70       	andi	r25, 0x0F	; 15
     564:	89 27       	eor	r24, r25
     566:	81 70       	andi	r24, 0x01	; 1
     568:	90 70       	andi	r25, 0x00	; 0
     56a:	82 17       	cp	r24, r18
     56c:	93 07       	cpc	r25, r19
     56e:	81 f7       	brne	.-32     	; 0x550
     570:	70 e3       	ldi	r23, 0x30	; 48
     572:	70 93 c6 00 	sts	0x00C6, r23
     576:	21 e0       	ldi	r18, 0x01	; 1
     578:	30 e0       	ldi	r19, 0x00	; 0
     57a:	80 91 c0 00 	lds	r24, 0x00C0
     57e:	99 27       	eor	r25, r25
     580:	96 95       	lsr	r25
     582:	87 95       	ror	r24
     584:	92 95       	swap	r25
     586:	82 95       	swap	r24
     588:	8f 70       	andi	r24, 0x0F	; 15
     58a:	89 27       	eor	r24, r25
     58c:	9f 70       	andi	r25, 0x0F	; 15
     58e:	89 27       	eor	r24, r25
     590:	81 70       	andi	r24, 0x01	; 1
     592:	90 70       	andi	r25, 0x00	; 0
     594:	82 17       	cp	r24, r18
     596:	93 07       	cpc	r25, r19
     598:	81 f7       	brne	.-32     	; 0x57a
     59a:	90 e3       	ldi	r25, 0x30	; 48
     59c:	90 93 c6 00 	sts	0x00C6, r25
     5a0:	21 e0       	ldi	r18, 0x01	; 1
     5a2:	30 e0       	ldi	r19, 0x00	; 0
     5a4:	80 91 c0 00 	lds	r24, 0x00C0
     5a8:	99 27       	eor	r25, r25
     5aa:	96 95       	lsr	r25
     5ac:	87 95       	ror	r24
     5ae:	92 95       	swap	r25
     5b0:	82 95       	swap	r24
     5b2:	8f 70       	andi	r24, 0x0F	; 15
     5b4:	89 27       	eor	r24, r25
     5b6:	9f 70       	andi	r25, 0x0F	; 15
     5b8:	89 27       	eor	r24, r25
     5ba:	81 70       	andi	r24, 0x01	; 1
     5bc:	90 70       	andi	r25, 0x00	; 0
     5be:	82 17       	cp	r24, r18
     5c0:	93 07       	cpc	r25, r19
     5c2:	81 f7       	brne	.-32     	; 0x5a4
     5c4:	a1 e3       	ldi	r26, 0x31	; 49
     5c6:	a0 93 c6 00 	sts	0x00C6, r26
     5ca:	21 e0       	ldi	r18, 0x01	; 1
     5cc:	30 e0       	ldi	r19, 0x00	; 0
     5ce:	80 91 c0 00 	lds	r24, 0x00C0
     5d2:	99 27       	eor	r25, r25
     5d4:	96 95       	lsr	r25
     5d6:	87 95       	ror	r24
     5d8:	92 95       	swap	r25
     5da:	82 95       	swap	r24
     5dc:	8f 70       	andi	r24, 0x0F	; 15
     5de:	89 27       	eor	r24, r25
     5e0:	9f 70       	andi	r25, 0x0F	; 15
     5e2:	89 27       	eor	r24, r25
     5e4:	81 70       	andi	r24, 0x01	; 1
     5e6:	90 70       	andi	r25, 0x00	; 0
     5e8:	82 17       	cp	r24, r18
     5ea:	93 07       	cpc	r25, r19
     5ec:	81 f7       	brne	.-32     	; 0x5ce
     5ee:	80 e3       	ldi	r24, 0x30	; 48
     5f0:	80 93 c6 00 	sts	0x00C6, r24
     5f4:	08 95       	ret
     5f6:	8b 30       	cpi	r24, 0x0B	; 11
     5f8:	91 05       	cpc	r25, r1
     5fa:	09 f4       	brne	.+2      	; 0x5fe
     5fc:	1d c1       	rjmp	.+570    	; 0x838
     5fe:	8c 30       	cpi	r24, 0x0C	; 12
     600:	91 05       	cpc	r25, r1
     602:	0c f0       	brlt	.+2      	; 0x606
     604:	09 c1       	rjmp	.+530    	; 0x818
     606:	89 30       	cpi	r24, 0x09	; 9
     608:	91 05       	cpc	r25, r1
     60a:	09 f4       	brne	.+2      	; 0x60e
     60c:	57 c3       	rjmp	.+1710   	; 0xcbc
     60e:	0a 97       	sbiw	r24, 0x0a	; 10
     610:	0c f0       	brlt	.+2      	; 0x614
     612:	b6 c1       	rjmp	.+876    	; 0x980
     614:	21 e0       	ldi	r18, 0x01	; 1
     616:	30 e0       	ldi	r19, 0x00	; 0
     618:	80 91 c0 00 	lds	r24, 0x00C0
     61c:	99 27       	eor	r25, r25
     61e:	96 95       	lsr	r25
     620:	87 95       	ror	r24
     622:	92 95       	swap	r25
     624:	82 95       	swap	r24
     626:	8f 70       	andi	r24, 0x0F	; 15
     628:	89 27       	eor	r24, r25
     62a:	9f 70       	andi	r25, 0x0F	; 15
     62c:	89 27       	eor	r24, r25
     62e:	81 70       	andi	r24, 0x01	; 1
     630:	90 70       	andi	r25, 0x00	; 0
     632:	82 17       	cp	r24, r18
     634:	93 07       	cpc	r25, r19
     636:	81 f7       	brne	.-32     	; 0x618
     638:	81 e3       	ldi	r24, 0x31	; 49
     63a:	80 93 c6 00 	sts	0x00C6, r24
     63e:	21 e0       	ldi	r18, 0x01	; 1
     640:	30 e0       	ldi	r19, 0x00	; 0
     642:	80 91 c0 00 	lds	r24, 0x00C0
     646:	99 27       	eor	r25, r25
     648:	96 95       	lsr	r25
     64a:	87 95       	ror	r24
     64c:	92 95       	swap	r25
     64e:	82 95       	swap	r24
     650:	8f 70       	andi	r24, 0x0F	; 15
     652:	89 27       	eor	r24, r25
     654:	9f 70       	andi	r25, 0x0F	; 15
     656:	89 27       	eor	r24, r25
     658:	81 70       	andi	r24, 0x01	; 1
     65a:	90 70       	andi	r25, 0x00	; 0
     65c:	82 17       	cp	r24, r18
     65e:	93 07       	cpc	r25, r19
     660:	81 f7       	brne	.-32     	; 0x642
     662:	20 e3       	ldi	r18, 0x30	; 48
     664:	20 93 c6 00 	sts	0x00C6, r18
     668:	21 e0       	ldi	r18, 0x01	; 1
     66a:	30 e0       	ldi	r19, 0x00	; 0
     66c:	80 91 c0 00 	lds	r24, 0x00C0
     670:	99 27       	eor	r25, r25
     672:	96 95       	lsr	r25
     674:	87 95       	ror	r24
     676:	92 95       	swap	r25
     678:	82 95       	swap	r24
     67a:	8f 70       	andi	r24, 0x0F	; 15
     67c:	89 27       	eor	r24, r25
     67e:	9f 70       	andi	r25, 0x0F	; 15
     680:	89 27       	eor	r24, r25
     682:	81 70       	andi	r24, 0x01	; 1
     684:	90 70       	andi	r25, 0x00	; 0
     686:	82 17       	cp	r24, r18
     688:	93 07       	cpc	r25, r19
     68a:	81 f7       	brne	.-32     	; 0x66c
     68c:	30 e3       	ldi	r19, 0x30	; 48
     68e:	30 93 c6 00 	sts	0x00C6, r19
     692:	21 e0       	ldi	r18, 0x01	; 1
     694:	30 e0       	ldi	r19, 0x00	; 0
     696:	80 91 c0 00 	lds	r24, 0x00C0
     69a:	99 27       	eor	r25, r25
     69c:	96 95       	lsr	r25
     69e:	87 95       	ror	r24
     6a0:	92 95       	swap	r25
     6a2:	82 95       	swap	r24
     6a4:	8f 70       	andi	r24, 0x0F	; 15
     6a6:	89 27       	eor	r24, r25
     6a8:	9f 70       	andi	r25, 0x0F	; 15
     6aa:	89 27       	eor	r24, r25
     6ac:	81 70       	andi	r24, 0x01	; 1
     6ae:	90 70       	andi	r25, 0x00	; 0
     6b0:	82 17       	cp	r24, r18
     6b2:	93 07       	cpc	r25, r19
     6b4:	81 f7       	brne	.-32     	; 0x696
     6b6:	80 e3       	ldi	r24, 0x30	; 48
     6b8:	9b cf       	rjmp	.-202    	; 0x5f0
     6ba:	21 e0       	ldi	r18, 0x01	; 1
     6bc:	30 e0       	ldi	r19, 0x00	; 0
     6be:	80 91 c0 00 	lds	r24, 0x00C0
     6c2:	99 27       	eor	r25, r25
     6c4:	96 95       	lsr	r25
     6c6:	87 95       	ror	r24
     6c8:	92 95       	swap	r25
     6ca:	82 95       	swap	r24
     6cc:	8f 70       	andi	r24, 0x0F	; 15
     6ce:	89 27       	eor	r24, r25
     6d0:	9f 70       	andi	r25, 0x0F	; 15
     6d2:	89 27       	eor	r24, r25
     6d4:	81 70       	andi	r24, 0x01	; 1
     6d6:	90 70       	andi	r25, 0x00	; 0
     6d8:	82 17       	cp	r24, r18
     6da:	93 07       	cpc	r25, r19
     6dc:	81 f7       	brne	.-32     	; 0x6be
     6de:	b0 e3       	ldi	r27, 0x30	; 48
     6e0:	b0 93 c6 00 	sts	0x00C6, r27
     6e4:	21 e0       	ldi	r18, 0x01	; 1
     6e6:	30 e0       	ldi	r19, 0x00	; 0
     6e8:	80 91 c0 00 	lds	r24, 0x00C0
     6ec:	99 27       	eor	r25, r25
     6ee:	96 95       	lsr	r25
     6f0:	87 95       	ror	r24
     6f2:	92 95       	swap	r25
     6f4:	82 95       	swap	r24
     6f6:	8f 70       	andi	r24, 0x0F	; 15
     6f8:	89 27       	eor	r24, r25
     6fa:	9f 70       	andi	r25, 0x0F	; 15
     6fc:	89 27       	eor	r24, r25
     6fe:	81 70       	andi	r24, 0x01	; 1
     700:	90 70       	andi	r25, 0x00	; 0
     702:	82 17       	cp	r24, r18
     704:	93 07       	cpc	r25, r19
     706:	81 f7       	brne	.-32     	; 0x6e8
     708:	e1 e3       	ldi	r30, 0x31	; 49
     70a:	e0 93 c6 00 	sts	0x00C6, r30
     70e:	21 e0       	ldi	r18, 0x01	; 1
     710:	30 e0       	ldi	r19, 0x00	; 0
     712:	80 91 c0 00 	lds	r24, 0x00C0
     716:	99 27       	eor	r25, r25
     718:	96 95       	lsr	r25
     71a:	87 95       	ror	r24
     71c:	92 95       	swap	r25
     71e:	82 95       	swap	r24
     720:	8f 70       	andi	r24, 0x0F	; 15
     722:	89 27       	eor	r24, r25
     724:	9f 70       	andi	r25, 0x0F	; 15
     726:	89 27       	eor	r24, r25
     728:	81 70       	andi	r24, 0x01	; 1
     72a:	90 70       	andi	r25, 0x00	; 0
     72c:	82 17       	cp	r24, r18
     72e:	93 07       	cpc	r25, r19
     730:	81 f7       	brne	.-32     	; 0x712
     732:	f1 e3       	ldi	r31, 0x31	; 49
     734:	f0 93 c6 00 	sts	0x00C6, r31
     738:	21 e0       	ldi	r18, 0x01	; 1
     73a:	30 e0       	ldi	r19, 0x00	; 0
     73c:	80 91 c0 00 	lds	r24, 0x00C0
     740:	99 27       	eor	r25, r25
     742:	96 95       	lsr	r25
     744:	87 95       	ror	r24
     746:	92 95       	swap	r25
     748:	82 95       	swap	r24
     74a:	8f 70       	andi	r24, 0x0F	; 15
     74c:	89 27       	eor	r24, r25
     74e:	9f 70       	andi	r25, 0x0F	; 15
     750:	89 27       	eor	r24, r25
     752:	81 70       	andi	r24, 0x01	; 1
     754:	90 70       	andi	r25, 0x00	; 0
     756:	82 17       	cp	r24, r18
     758:	93 07       	cpc	r25, r19
     75a:	81 f7       	brne	.-32     	; 0x73c
     75c:	81 e3       	ldi	r24, 0x31	; 49
     75e:	80 93 c6 00 	sts	0x00C6, r24
     762:	08 95       	ret
     764:	85 30       	cpi	r24, 0x05	; 5
     766:	91 05       	cpc	r25, r1
     768:	09 f4       	brne	.+2      	; 0x76c
     76a:	fa c2       	rjmp	.+1524   	; 0xd60
     76c:	06 97       	sbiw	r24, 0x06	; 6
     76e:	0c f0       	brlt	.+2      	; 0x772
     770:	ad c1       	rjmp	.+858    	; 0xacc
     772:	21 e0       	ldi	r18, 0x01	; 1
     774:	30 e0       	ldi	r19, 0x00	; 0
     776:	80 91 c0 00 	lds	r24, 0x00C0
     77a:	99 27       	eor	r25, r25
     77c:	96 95       	lsr	r25
     77e:	87 95       	ror	r24
     780:	92 95       	swap	r25
     782:	82 95       	swap	r24
     784:	8f 70       	andi	r24, 0x0F	; 15
     786:	89 27       	eor	r24, r25
     788:	9f 70       	andi	r25, 0x0F	; 15
     78a:	89 27       	eor	r24, r25
     78c:	81 70       	andi	r24, 0x01	; 1
     78e:	90 70       	andi	r25, 0x00	; 0
     790:	82 17       	cp	r24, r18
     792:	93 07       	cpc	r25, r19
     794:	81 f7       	brne	.-32     	; 0x776
     796:	80 e3       	ldi	r24, 0x30	; 48
     798:	80 93 c6 00 	sts	0x00C6, r24
     79c:	21 e0       	ldi	r18, 0x01	; 1
     79e:	30 e0       	ldi	r19, 0x00	; 0
     7a0:	80 91 c0 00 	lds	r24, 0x00C0
     7a4:	99 27       	eor	r25, r25
     7a6:	96 95       	lsr	r25
     7a8:	87 95       	ror	r24
     7aa:	92 95       	swap	r25
     7ac:	82 95       	swap	r24
     7ae:	8f 70       	andi	r24, 0x0F	; 15
     7b0:	89 27       	eor	r24, r25
     7b2:	9f 70       	andi	r25, 0x0F	; 15
     7b4:	89 27       	eor	r24, r25
     7b6:	81 70       	andi	r24, 0x01	; 1
     7b8:	90 70       	andi	r25, 0x00	; 0
     7ba:	82 17       	cp	r24, r18
     7bc:	93 07       	cpc	r25, r19
     7be:	81 f7       	brne	.-32     	; 0x7a0
     7c0:	21 e3       	ldi	r18, 0x31	; 49
     7c2:	20 93 c6 00 	sts	0x00C6, r18
     7c6:	21 e0       	ldi	r18, 0x01	; 1
     7c8:	30 e0       	ldi	r19, 0x00	; 0
     7ca:	80 91 c0 00 	lds	r24, 0x00C0
     7ce:	99 27       	eor	r25, r25
     7d0:	96 95       	lsr	r25
     7d2:	87 95       	ror	r24
     7d4:	92 95       	swap	r25
     7d6:	82 95       	swap	r24
     7d8:	8f 70       	andi	r24, 0x0F	; 15
     7da:	89 27       	eor	r24, r25
     7dc:	9f 70       	andi	r25, 0x0F	; 15
     7de:	89 27       	eor	r24, r25
     7e0:	81 70       	andi	r24, 0x01	; 1
     7e2:	90 70       	andi	r25, 0x00	; 0
     7e4:	82 17       	cp	r24, r18
     7e6:	93 07       	cpc	r25, r19
     7e8:	81 f7       	brne	.-32     	; 0x7ca
     7ea:	30 e3       	ldi	r19, 0x30	; 48
     7ec:	30 93 c6 00 	sts	0x00C6, r19
     7f0:	21 e0       	ldi	r18, 0x01	; 1
     7f2:	30 e0       	ldi	r19, 0x00	; 0
     7f4:	80 91 c0 00 	lds	r24, 0x00C0
     7f8:	99 27       	eor	r25, r25
     7fa:	96 95       	lsr	r25
     7fc:	87 95       	ror	r24
     7fe:	92 95       	swap	r25
     800:	82 95       	swap	r24
     802:	8f 70       	andi	r24, 0x0F	; 15
     804:	89 27       	eor	r24, r25
     806:	9f 70       	andi	r25, 0x0F	; 15
     808:	89 27       	eor	r24, r25
     80a:	81 70       	andi	r24, 0x01	; 1
     80c:	90 70       	andi	r25, 0x00	; 0
     80e:	82 17       	cp	r24, r18
     810:	93 07       	cpc	r25, r19
     812:	81 f7       	brne	.-32     	; 0x7f4
     814:	80 e3       	ldi	r24, 0x30	; 48
     816:	ec ce       	rjmp	.-552    	; 0x5f0
     818:	8d 30       	cpi	r24, 0x0D	; 13
     81a:	91 05       	cpc	r25, r1
     81c:	09 f4       	brne	.+2      	; 0x820
     81e:	f2 c2       	rjmp	.+1508   	; 0xe04
     820:	8d 30       	cpi	r24, 0x0D	; 13
     822:	91 05       	cpc	r25, r1
     824:	0c f4       	brge	.+2      	; 0x828
     826:	ff c0       	rjmp	.+510    	; 0xa26
     828:	8e 30       	cpi	r24, 0x0E	; 14
     82a:	91 05       	cpc	r25, r1
     82c:	09 f4       	brne	.+2      	; 0x830
     82e:	40 c3       	rjmp	.+1664   	; 0xeb0
     830:	0f 97       	sbiw	r24, 0x0f	; 15
     832:	09 f4       	brne	.+2      	; 0x836
     834:	9e c1       	rjmp	.+828    	; 0xb72
     836:	08 95       	ret
     838:	21 e0       	ldi	r18, 0x01	; 1
     83a:	30 e0       	ldi	r19, 0x00	; 0
     83c:	80 91 c0 00 	lds	r24, 0x00C0
     840:	99 27       	eor	r25, r25
     842:	96 95       	lsr	r25
     844:	87 95       	ror	r24
     846:	92 95       	swap	r25
     848:	82 95       	swap	r24
     84a:	8f 70       	andi	r24, 0x0F	; 15
     84c:	89 27       	eor	r24, r25
     84e:	9f 70       	andi	r25, 0x0F	; 15
     850:	89 27       	eor	r24, r25
     852:	81 70       	andi	r24, 0x01	; 1
     854:	90 70       	andi	r25, 0x00	; 0
     856:	82 17       	cp	r24, r18
     858:	93 07       	cpc	r25, r19
     85a:	81 f7       	brne	.-32     	; 0x83c
     85c:	b1 e3       	ldi	r27, 0x31	; 49
     85e:	b0 93 c6 00 	sts	0x00C6, r27
     862:	21 e0       	ldi	r18, 0x01	; 1
     864:	30 e0       	ldi	r19, 0x00	; 0
     866:	80 91 c0 00 	lds	r24, 0x00C0
     86a:	99 27       	eor	r25, r25
     86c:	96 95       	lsr	r25
     86e:	87 95       	ror	r24
     870:	92 95       	swap	r25
     872:	82 95       	swap	r24
     874:	8f 70       	andi	r24, 0x0F	; 15
     876:	89 27       	eor	r24, r25
     878:	9f 70       	andi	r25, 0x0F	; 15
     87a:	89 27       	eor	r24, r25
     87c:	81 70       	andi	r24, 0x01	; 1
     87e:	90 70       	andi	r25, 0x00	; 0
     880:	82 17       	cp	r24, r18
     882:	93 07       	cpc	r25, r19
     884:	81 f7       	brne	.-32     	; 0x866
     886:	e0 e3       	ldi	r30, 0x30	; 48
     888:	e0 93 c6 00 	sts	0x00C6, r30
     88c:	21 e0       	ldi	r18, 0x01	; 1
     88e:	30 e0       	ldi	r19, 0x00	; 0
     890:	80 91 c0 00 	lds	r24, 0x00C0
     894:	99 27       	eor	r25, r25
     896:	96 95       	lsr	r25
     898:	87 95       	ror	r24
     89a:	92 95       	swap	r25
     89c:	82 95       	swap	r24
     89e:	8f 70       	andi	r24, 0x0F	; 15
     8a0:	89 27       	eor	r24, r25
     8a2:	9f 70       	andi	r25, 0x0F	; 15
     8a4:	89 27       	eor	r24, r25
     8a6:	81 70       	andi	r24, 0x01	; 1
     8a8:	90 70       	andi	r25, 0x00	; 0
     8aa:	82 17       	cp	r24, r18
     8ac:	93 07       	cpc	r25, r19
     8ae:	81 f7       	brne	.-32     	; 0x890
     8b0:	f1 e3       	ldi	r31, 0x31	; 49
     8b2:	f0 93 c6 00 	sts	0x00C6, r31
     8b6:	21 e0       	ldi	r18, 0x01	; 1
     8b8:	30 e0       	ldi	r19, 0x00	; 0
     8ba:	80 91 c0 00 	lds	r24, 0x00C0
     8be:	99 27       	eor	r25, r25
     8c0:	96 95       	lsr	r25
     8c2:	87 95       	ror	r24
     8c4:	92 95       	swap	r25
     8c6:	82 95       	swap	r24
     8c8:	8f 70       	andi	r24, 0x0F	; 15
     8ca:	89 27       	eor	r24, r25
     8cc:	9f 70       	andi	r25, 0x0F	; 15
     8ce:	89 27       	eor	r24, r25
     8d0:	81 70       	andi	r24, 0x01	; 1
     8d2:	90 70       	andi	r25, 0x00	; 0
     8d4:	82 17       	cp	r24, r18
     8d6:	93 07       	cpc	r25, r19
     8d8:	81 f7       	brne	.-32     	; 0x8ba
     8da:	40 cf       	rjmp	.-384    	; 0x75c
     8dc:	21 e0       	ldi	r18, 0x01	; 1
     8de:	30 e0       	ldi	r19, 0x00	; 0
     8e0:	80 91 c0 00 	lds	r24, 0x00C0
     8e4:	99 27       	eor	r25, r25
     8e6:	96 95       	lsr	r25
     8e8:	87 95       	ror	r24
     8ea:	92 95       	swap	r25
     8ec:	82 95       	swap	r24
     8ee:	8f 70       	andi	r24, 0x0F	; 15
     8f0:	89 27       	eor	r24, r25
     8f2:	9f 70       	andi	r25, 0x0F	; 15
     8f4:	89 27       	eor	r24, r25
     8f6:	81 70       	andi	r24, 0x01	; 1
     8f8:	90 70       	andi	r25, 0x00	; 0
     8fa:	82 17       	cp	r24, r18
     8fc:	93 07       	cpc	r25, r19
     8fe:	81 f7       	brne	.-32     	; 0x8e0
     900:	b0 e3       	ldi	r27, 0x30	; 48
     902:	b0 93 c6 00 	sts	0x00C6, r27
     906:	21 e0       	ldi	r18, 0x01	; 1
     908:	30 e0       	ldi	r19, 0x00	; 0
     90a:	80 91 c0 00 	lds	r24, 0x00C0
     90e:	99 27       	eor	r25, r25
     910:	96 95       	lsr	r25
     912:	87 95       	ror	r24
     914:	92 95       	swap	r25
     916:	82 95       	swap	r24
     918:	8f 70       	andi	r24, 0x0F	; 15
     91a:	89 27       	eor	r24, r25
     91c:	9f 70       	andi	r25, 0x0F	; 15
     91e:	89 27       	eor	r24, r25
     920:	81 70       	andi	r24, 0x01	; 1
     922:	90 70       	andi	r25, 0x00	; 0
     924:	82 17       	cp	r24, r18
     926:	93 07       	cpc	r25, r19
     928:	81 f7       	brne	.-32     	; 0x90a
     92a:	e0 e3       	ldi	r30, 0x30	; 48
     92c:	e0 93 c6 00 	sts	0x00C6, r30
     930:	21 e0       	ldi	r18, 0x01	; 1
     932:	30 e0       	ldi	r19, 0x00	; 0
     934:	80 91 c0 00 	lds	r24, 0x00C0
     938:	99 27       	eor	r25, r25
     93a:	96 95       	lsr	r25
     93c:	87 95       	ror	r24
     93e:	92 95       	swap	r25
     940:	82 95       	swap	r24
     942:	8f 70       	andi	r24, 0x0F	; 15
     944:	89 27       	eor	r24, r25
     946:	9f 70       	andi	r25, 0x0F	; 15
     948:	89 27       	eor	r24, r25
     94a:	81 70       	andi	r24, 0x01	; 1
     94c:	90 70       	andi	r25, 0x00	; 0
     94e:	82 17       	cp	r24, r18
     950:	93 07       	cpc	r25, r19
     952:	81 f7       	brne	.-32     	; 0x934
     954:	f1 e3       	ldi	r31, 0x31	; 49
     956:	f0 93 c6 00 	sts	0x00C6, r31
     95a:	21 e0       	ldi	r18, 0x01	; 1
     95c:	30 e0       	ldi	r19, 0x00	; 0
     95e:	80 91 c0 00 	lds	r24, 0x00C0
     962:	99 27       	eor	r25, r25
     964:	96 95       	lsr	r25
     966:	87 95       	ror	r24
     968:	92 95       	swap	r25
     96a:	82 95       	swap	r24
     96c:	8f 70       	andi	r24, 0x0F	; 15
     96e:	89 27       	eor	r24, r25
     970:	9f 70       	andi	r25, 0x0F	; 15
     972:	89 27       	eor	r24, r25
     974:	81 70       	andi	r24, 0x01	; 1
     976:	90 70       	andi	r25, 0x00	; 0
     978:	82 17       	cp	r24, r18
     97a:	93 07       	cpc	r25, r19
     97c:	81 f7       	brne	.-32     	; 0x95e
     97e:	ee ce       	rjmp	.-548    	; 0x75c
     980:	21 e0       	ldi	r18, 0x01	; 1
     982:	30 e0       	ldi	r19, 0x00	; 0
     984:	80 91 c0 00 	lds	r24, 0x00C0
     988:	99 27       	eor	r25, r25
     98a:	96 95       	lsr	r25
     98c:	87 95       	ror	r24
     98e:	92 95       	swap	r25
     990:	82 95       	swap	r24
     992:	8f 70       	andi	r24, 0x0F	; 15
     994:	89 27       	eor	r24, r25
     996:	9f 70       	andi	r25, 0x0F	; 15
     998:	89 27       	eor	r24, r25
     99a:	81 70       	andi	r24, 0x01	; 1
     99c:	90 70       	andi	r25, 0x00	; 0
     99e:	82 17       	cp	r24, r18
     9a0:	93 07       	cpc	r25, r19
     9a2:	81 f7       	brne	.-32     	; 0x984
     9a4:	71 e3       	ldi	r23, 0x31	; 49
     9a6:	70 93 c6 00 	sts	0x00C6, r23
     9aa:	21 e0       	ldi	r18, 0x01	; 1
     9ac:	30 e0       	ldi	r19, 0x00	; 0
     9ae:	80 91 c0 00 	lds	r24, 0x00C0
     9b2:	99 27       	eor	r25, r25
     9b4:	96 95       	lsr	r25
     9b6:	87 95       	ror	r24
     9b8:	92 95       	swap	r25
     9ba:	82 95       	swap	r24
     9bc:	8f 70       	andi	r24, 0x0F	; 15
     9be:	89 27       	eor	r24, r25
     9c0:	9f 70       	andi	r25, 0x0F	; 15
     9c2:	89 27       	eor	r24, r25
     9c4:	81 70       	andi	r24, 0x01	; 1
     9c6:	90 70       	andi	r25, 0x00	; 0
     9c8:	82 17       	cp	r24, r18
     9ca:	93 07       	cpc	r25, r19
     9cc:	81 f7       	brne	.-32     	; 0x9ae
     9ce:	90 e3       	ldi	r25, 0x30	; 48
     9d0:	90 93 c6 00 	sts	0x00C6, r25
     9d4:	21 e0       	ldi	r18, 0x01	; 1
     9d6:	30 e0       	ldi	r19, 0x00	; 0
     9d8:	80 91 c0 00 	lds	r24, 0x00C0
     9dc:	99 27       	eor	r25, r25
     9de:	96 95       	lsr	r25
     9e0:	87 95       	ror	r24
     9e2:	92 95       	swap	r25
     9e4:	82 95       	swap	r24
     9e6:	8f 70       	andi	r24, 0x0F	; 15
     9e8:	89 27       	eor	r24, r25
     9ea:	9f 70       	andi	r25, 0x0F	; 15
     9ec:	89 27       	eor	r24, r25
     9ee:	81 70       	andi	r24, 0x01	; 1
     9f0:	90 70       	andi	r25, 0x00	; 0
     9f2:	82 17       	cp	r24, r18
     9f4:	93 07       	cpc	r25, r19
     9f6:	81 f7       	brne	.-32     	; 0x9d8
     9f8:	a1 e3       	ldi	r26, 0x31	; 49
     9fa:	a0 93 c6 00 	sts	0x00C6, r26
     9fe:	21 e0       	ldi	r18, 0x01	; 1
     a00:	30 e0       	ldi	r19, 0x00	; 0
     a02:	80 91 c0 00 	lds	r24, 0x00C0
     a06:	99 27       	eor	r25, r25
     a08:	96 95       	lsr	r25
     a0a:	87 95       	ror	r24
     a0c:	92 95       	swap	r25
     a0e:	82 95       	swap	r24
     a10:	8f 70       	andi	r24, 0x0F	; 15
     a12:	89 27       	eor	r24, r25
     a14:	9f 70       	andi	r25, 0x0F	; 15
     a16:	89 27       	eor	r24, r25
     a18:	81 70       	andi	r24, 0x01	; 1
     a1a:	90 70       	andi	r25, 0x00	; 0
     a1c:	82 17       	cp	r24, r18
     a1e:	93 07       	cpc	r25, r19
     a20:	81 f7       	brne	.-32     	; 0xa02
     a22:	80 e3       	ldi	r24, 0x30	; 48
     a24:	e5 cd       	rjmp	.-1078   	; 0x5f0
     a26:	21 e0       	ldi	r18, 0x01	; 1
     a28:	30 e0       	ldi	r19, 0x00	; 0
     a2a:	80 91 c0 00 	lds	r24, 0x00C0
     a2e:	99 27       	eor	r25, r25
     a30:	96 95       	lsr	r25
     a32:	87 95       	ror	r24
     a34:	92 95       	swap	r25
     a36:	82 95       	swap	r24
     a38:	8f 70       	andi	r24, 0x0F	; 15
     a3a:	89 27       	eor	r24, r25
     a3c:	9f 70       	andi	r25, 0x0F	; 15
     a3e:	89 27       	eor	r24, r25
     a40:	81 70       	andi	r24, 0x01	; 1
     a42:	90 70       	andi	r25, 0x00	; 0
     a44:	82 17       	cp	r24, r18
     a46:	93 07       	cpc	r25, r19
     a48:	81 f7       	brne	.-32     	; 0xa2a
     a4a:	81 e3       	ldi	r24, 0x31	; 49
     a4c:	80 93 c6 00 	sts	0x00C6, r24
     a50:	21 e0       	ldi	r18, 0x01	; 1
     a52:	30 e0       	ldi	r19, 0x00	; 0
     a54:	80 91 c0 00 	lds	r24, 0x00C0
     a58:	99 27       	eor	r25, r25
     a5a:	96 95       	lsr	r25
     a5c:	87 95       	ror	r24
     a5e:	92 95       	swap	r25
     a60:	82 95       	swap	r24
     a62:	8f 70       	andi	r24, 0x0F	; 15
     a64:	89 27       	eor	r24, r25
     a66:	9f 70       	andi	r25, 0x0F	; 15
     a68:	89 27       	eor	r24, r25
     a6a:	81 70       	andi	r24, 0x01	; 1
     a6c:	90 70       	andi	r25, 0x00	; 0
     a6e:	82 17       	cp	r24, r18
     a70:	93 07       	cpc	r25, r19
     a72:	81 f7       	brne	.-32     	; 0xa54
     a74:	21 e3       	ldi	r18, 0x31	; 49
     a76:	20 93 c6 00 	sts	0x00C6, r18
     a7a:	21 e0       	ldi	r18, 0x01	; 1
     a7c:	30 e0       	ldi	r19, 0x00	; 0
     a7e:	80 91 c0 00 	lds	r24, 0x00C0
     a82:	99 27       	eor	r25, r25
     a84:	96 95       	lsr	r25
     a86:	87 95       	ror	r24
     a88:	92 95       	swap	r25
     a8a:	82 95       	swap	r24
     a8c:	8f 70       	andi	r24, 0x0F	; 15
     a8e:	89 27       	eor	r24, r25
     a90:	9f 70       	andi	r25, 0x0F	; 15
     a92:	89 27       	eor	r24, r25
     a94:	81 70       	andi	r24, 0x01	; 1
     a96:	90 70       	andi	r25, 0x00	; 0
     a98:	82 17       	cp	r24, r18
     a9a:	93 07       	cpc	r25, r19
     a9c:	81 f7       	brne	.-32     	; 0xa7e
     a9e:	30 e3       	ldi	r19, 0x30	; 48
     aa0:	30 93 c6 00 	sts	0x00C6, r19
     aa4:	21 e0       	ldi	r18, 0x01	; 1
     aa6:	30 e0       	ldi	r19, 0x00	; 0
     aa8:	80 91 c0 00 	lds	r24, 0x00C0
     aac:	99 27       	eor	r25, r25
     aae:	96 95       	lsr	r25
     ab0:	87 95       	ror	r24
     ab2:	92 95       	swap	r25
     ab4:	82 95       	swap	r24
     ab6:	8f 70       	andi	r24, 0x0F	; 15
     ab8:	89 27       	eor	r24, r25
     aba:	9f 70       	andi	r25, 0x0F	; 15
     abc:	89 27       	eor	r24, r25
     abe:	81 70       	andi	r24, 0x01	; 1
     ac0:	90 70       	andi	r25, 0x00	; 0
     ac2:	82 17       	cp	r24, r18
     ac4:	93 07       	cpc	r25, r19
     ac6:	81 f7       	brne	.-32     	; 0xaa8
     ac8:	80 e3       	ldi	r24, 0x30	; 48
     aca:	92 cd       	rjmp	.-1244   	; 0x5f0
     acc:	21 e0       	ldi	r18, 0x01	; 1
     ace:	30 e0       	ldi	r19, 0x00	; 0
     ad0:	80 91 c0 00 	lds	r24, 0x00C0
     ad4:	99 27       	eor	r25, r25
     ad6:	96 95       	lsr	r25
     ad8:	87 95       	ror	r24
     ada:	92 95       	swap	r25
     adc:	82 95       	swap	r24
     ade:	8f 70       	andi	r24, 0x0F	; 15
     ae0:	89 27       	eor	r24, r25
     ae2:	9f 70       	andi	r25, 0x0F	; 15
     ae4:	89 27       	eor	r24, r25
     ae6:	81 70       	andi	r24, 0x01	; 1
     ae8:	90 70       	andi	r25, 0x00	; 0
     aea:	82 17       	cp	r24, r18
     aec:	93 07       	cpc	r25, r19
     aee:	81 f7       	brne	.-32     	; 0xad0
     af0:	70 e3       	ldi	r23, 0x30	; 48
     af2:	70 93 c6 00 	sts	0x00C6, r23
     af6:	21 e0       	ldi	r18, 0x01	; 1
     af8:	30 e0       	ldi	r19, 0x00	; 0
     afa:	80 91 c0 00 	lds	r24, 0x00C0
     afe:	99 27       	eor	r25, r25
     b00:	96 95       	lsr	r25
     b02:	87 95       	ror	r24
     b04:	92 95       	swap	r25
     b06:	82 95       	swap	r24
     b08:	8f 70       	andi	r24, 0x0F	; 15
     b0a:	89 27       	eor	r24, r25
     b0c:	9f 70       	andi	r25, 0x0F	; 15
     b0e:	89 27       	eor	r24, r25
     b10:	81 70       	andi	r24, 0x01	; 1
     b12:	90 70       	andi	r25, 0x00	; 0
     b14:	82 17       	cp	r24, r18
     b16:	93 07       	cpc	r25, r19
     b18:	81 f7       	brne	.-32     	; 0xafa
     b1a:	91 e3       	ldi	r25, 0x31	; 49
     b1c:	90 93 c6 00 	sts	0x00C6, r25
     b20:	21 e0       	ldi	r18, 0x01	; 1
     b22:	30 e0       	ldi	r19, 0x00	; 0
     b24:	80 91 c0 00 	lds	r24, 0x00C0
     b28:	99 27       	eor	r25, r25
     b2a:	96 95       	lsr	r25
     b2c:	87 95       	ror	r24
     b2e:	92 95       	swap	r25
     b30:	82 95       	swap	r24
     b32:	8f 70       	andi	r24, 0x0F	; 15
     b34:	89 27       	eor	r24, r25
     b36:	9f 70       	andi	r25, 0x0F	; 15
     b38:	89 27       	eor	r24, r25
     b3a:	81 70       	andi	r24, 0x01	; 1
     b3c:	90 70       	andi	r25, 0x00	; 0
     b3e:	82 17       	cp	r24, r18
     b40:	93 07       	cpc	r25, r19
     b42:	81 f7       	brne	.-32     	; 0xb24
     b44:	a1 e3       	ldi	r26, 0x31	; 49
     b46:	a0 93 c6 00 	sts	0x00C6, r26
     b4a:	21 e0       	ldi	r18, 0x01	; 1
     b4c:	30 e0       	ldi	r19, 0x00	; 0
     b4e:	80 91 c0 00 	lds	r24, 0x00C0
     b52:	99 27       	eor	r25, r25
     b54:	96 95       	lsr	r25
     b56:	87 95       	ror	r24
     b58:	92 95       	swap	r25
     b5a:	82 95       	swap	r24
     b5c:	8f 70       	andi	r24, 0x0F	; 15
     b5e:	89 27       	eor	r24, r25
     b60:	9f 70       	andi	r25, 0x0F	; 15
     b62:	89 27       	eor	r24, r25
     b64:	81 70       	andi	r24, 0x01	; 1
     b66:	90 70       	andi	r25, 0x00	; 0
     b68:	82 17       	cp	r24, r18
     b6a:	93 07       	cpc	r25, r19
     b6c:	81 f7       	brne	.-32     	; 0xb4e
     b6e:	80 e3       	ldi	r24, 0x30	; 48
     b70:	3f cd       	rjmp	.-1410   	; 0x5f0
     b72:	21 e0       	ldi	r18, 0x01	; 1
     b74:	30 e0       	ldi	r19, 0x00	; 0
     b76:	80 91 c0 00 	lds	r24, 0x00C0
     b7a:	99 27       	eor	r25, r25
     b7c:	96 95       	lsr	r25
     b7e:	87 95       	ror	r24
     b80:	92 95       	swap	r25
     b82:	82 95       	swap	r24
     b84:	8f 70       	andi	r24, 0x0F	; 15
     b86:	89 27       	eor	r24, r25
     b88:	9f 70       	andi	r25, 0x0F	; 15
     b8a:	89 27       	eor	r24, r25
     b8c:	81 70       	andi	r24, 0x01	; 1
     b8e:	90 70       	andi	r25, 0x00	; 0
     b90:	82 17       	cp	r24, r18
     b92:	93 07       	cpc	r25, r19
     b94:	81 f7       	brne	.-32     	; 0xb76
     b96:	b1 e3       	ldi	r27, 0x31	; 49
     b98:	b0 93 c6 00 	sts	0x00C6, r27
     b9c:	21 e0       	ldi	r18, 0x01	; 1
     b9e:	30 e0       	ldi	r19, 0x00	; 0
     ba0:	80 91 c0 00 	lds	r24, 0x00C0
     ba4:	99 27       	eor	r25, r25
     ba6:	96 95       	lsr	r25
     ba8:	87 95       	ror	r24
     baa:	92 95       	swap	r25
     bac:	82 95       	swap	r24
     bae:	8f 70       	andi	r24, 0x0F	; 15
     bb0:	89 27       	eor	r24, r25
     bb2:	9f 70       	andi	r25, 0x0F	; 15
     bb4:	89 27       	eor	r24, r25
     bb6:	81 70       	andi	r24, 0x01	; 1
     bb8:	90 70       	andi	r25, 0x00	; 0
     bba:	82 17       	cp	r24, r18
     bbc:	93 07       	cpc	r25, r19
     bbe:	81 f7       	brne	.-32     	; 0xba0
     bc0:	e1 e3       	ldi	r30, 0x31	; 49
     bc2:	e0 93 c6 00 	sts	0x00C6, r30
     bc6:	21 e0       	ldi	r18, 0x01	; 1
     bc8:	30 e0       	ldi	r19, 0x00	; 0
     bca:	80 91 c0 00 	lds	r24, 0x00C0
     bce:	99 27       	eor	r25, r25
     bd0:	96 95       	lsr	r25
     bd2:	87 95       	ror	r24
     bd4:	92 95       	swap	r25
     bd6:	82 95       	swap	r24
     bd8:	8f 70       	andi	r24, 0x0F	; 15
     bda:	89 27       	eor	r24, r25
     bdc:	9f 70       	andi	r25, 0x0F	; 15
     bde:	89 27       	eor	r24, r25
     be0:	81 70       	andi	r24, 0x01	; 1
     be2:	90 70       	andi	r25, 0x00	; 0
     be4:	82 17       	cp	r24, r18
     be6:	93 07       	cpc	r25, r19
     be8:	81 f7       	brne	.-32     	; 0xbca
     bea:	f1 e3       	ldi	r31, 0x31	; 49
     bec:	f0 93 c6 00 	sts	0x00C6, r31
     bf0:	21 e0       	ldi	r18, 0x01	; 1
     bf2:	30 e0       	ldi	r19, 0x00	; 0
     bf4:	80 91 c0 00 	lds	r24, 0x00C0
     bf8:	99 27       	eor	r25, r25
     bfa:	96 95       	lsr	r25
     bfc:	87 95       	ror	r24
     bfe:	92 95       	swap	r25
     c00:	82 95       	swap	r24
     c02:	8f 70       	andi	r24, 0x0F	; 15
     c04:	89 27       	eor	r24, r25
     c06:	9f 70       	andi	r25, 0x0F	; 15
     c08:	89 27       	eor	r24, r25
     c0a:	81 70       	andi	r24, 0x01	; 1
     c0c:	90 70       	andi	r25, 0x00	; 0
     c0e:	82 17       	cp	r24, r18
     c10:	93 07       	cpc	r25, r19
     c12:	81 f7       	brne	.-32     	; 0xbf4
     c14:	81 e3       	ldi	r24, 0x31	; 49
     c16:	80 93 c6 00 	sts	0x00C6, r24
     c1a:	08 95       	ret
     c1c:	9c 01       	movw	r18, r24
     c1e:	80 91 c0 00 	lds	r24, 0x00C0
     c22:	99 27       	eor	r25, r25
     c24:	96 95       	lsr	r25
     c26:	87 95       	ror	r24
     c28:	92 95       	swap	r25
     c2a:	82 95       	swap	r24
     c2c:	8f 70       	andi	r24, 0x0F	; 15
     c2e:	89 27       	eor	r24, r25
     c30:	9f 70       	andi	r25, 0x0F	; 15
     c32:	89 27       	eor	r24, r25
     c34:	82 27       	eor	r24, r18
     c36:	93 27       	eor	r25, r19
     c38:	80 fd       	sbrc	r24, 0
     c3a:	f1 cf       	rjmp	.-30     	; 0xc1e
     c3c:	40 e3       	ldi	r20, 0x30	; 48
     c3e:	40 93 c6 00 	sts	0x00C6, r20
     c42:	21 e0       	ldi	r18, 0x01	; 1
     c44:	30 e0       	ldi	r19, 0x00	; 0
     c46:	80 91 c0 00 	lds	r24, 0x00C0
     c4a:	99 27       	eor	r25, r25
     c4c:	96 95       	lsr	r25
     c4e:	87 95       	ror	r24
     c50:	92 95       	swap	r25
     c52:	82 95       	swap	r24
     c54:	8f 70       	andi	r24, 0x0F	; 15
     c56:	89 27       	eor	r24, r25
     c58:	9f 70       	andi	r25, 0x0F	; 15
     c5a:	89 27       	eor	r24, r25
     c5c:	81 70       	andi	r24, 0x01	; 1
     c5e:	90 70       	andi	r25, 0x00	; 0
     c60:	82 17       	cp	r24, r18
     c62:	93 07       	cpc	r25, r19
     c64:	81 f7       	brne	.-32     	; 0xc46
     c66:	50 e3       	ldi	r21, 0x30	; 48
     c68:	50 93 c6 00 	sts	0x00C6, r21
     c6c:	21 e0       	ldi	r18, 0x01	; 1
     c6e:	30 e0       	ldi	r19, 0x00	; 0
     c70:	80 91 c0 00 	lds	r24, 0x00C0
     c74:	99 27       	eor	r25, r25
     c76:	96 95       	lsr	r25
     c78:	87 95       	ror	r24
     c7a:	92 95       	swap	r25
     c7c:	82 95       	swap	r24
     c7e:	8f 70       	andi	r24, 0x0F	; 15
     c80:	89 27       	eor	r24, r25
     c82:	9f 70       	andi	r25, 0x0F	; 15
     c84:	89 27       	eor	r24, r25
     c86:	81 70       	andi	r24, 0x01	; 1
     c88:	90 70       	andi	r25, 0x00	; 0
     c8a:	82 17       	cp	r24, r18
     c8c:	93 07       	cpc	r25, r19
     c8e:	81 f7       	brne	.-32     	; 0xc70
     c90:	60 e3       	ldi	r22, 0x30	; 48
     c92:	60 93 c6 00 	sts	0x00C6, r22
     c96:	21 e0       	ldi	r18, 0x01	; 1
     c98:	30 e0       	ldi	r19, 0x00	; 0
     c9a:	80 91 c0 00 	lds	r24, 0x00C0
     c9e:	99 27       	eor	r25, r25
     ca0:	96 95       	lsr	r25
     ca2:	87 95       	ror	r24
     ca4:	92 95       	swap	r25
     ca6:	82 95       	swap	r24
     ca8:	8f 70       	andi	r24, 0x0F	; 15
     caa:	89 27       	eor	r24, r25
     cac:	9f 70       	andi	r25, 0x0F	; 15
     cae:	89 27       	eor	r24, r25
     cb0:	81 70       	andi	r24, 0x01	; 1
     cb2:	90 70       	andi	r25, 0x00	; 0
     cb4:	82 17       	cp	r24, r18
     cb6:	93 07       	cpc	r25, r19
     cb8:	81 f7       	brne	.-32     	; 0xc9a
     cba:	50 cd       	rjmp	.-1376   	; 0x75c
     cbc:	21 e0       	ldi	r18, 0x01	; 1
     cbe:	30 e0       	ldi	r19, 0x00	; 0
     cc0:	80 91 c0 00 	lds	r24, 0x00C0
     cc4:	99 27       	eor	r25, r25
     cc6:	96 95       	lsr	r25
     cc8:	87 95       	ror	r24
     cca:	92 95       	swap	r25
     ccc:	82 95       	swap	r24
     cce:	8f 70       	andi	r24, 0x0F	; 15
     cd0:	89 27       	eor	r24, r25
     cd2:	9f 70       	andi	r25, 0x0F	; 15
     cd4:	89 27       	eor	r24, r25
     cd6:	81 70       	andi	r24, 0x01	; 1
     cd8:	90 70       	andi	r25, 0x00	; 0
     cda:	82 17       	cp	r24, r18
     cdc:	93 07       	cpc	r25, r19
     cde:	81 f7       	brne	.-32     	; 0xcc0
     ce0:	41 e3       	ldi	r20, 0x31	; 49
     ce2:	40 93 c6 00 	sts	0x00C6, r20
     ce6:	21 e0       	ldi	r18, 0x01	; 1
     ce8:	30 e0       	ldi	r19, 0x00	; 0
     cea:	80 91 c0 00 	lds	r24, 0x00C0
     cee:	99 27       	eor	r25, r25
     cf0:	96 95       	lsr	r25
     cf2:	87 95       	ror	r24
     cf4:	92 95       	swap	r25
     cf6:	82 95       	swap	r24
     cf8:	8f 70       	andi	r24, 0x0F	; 15
     cfa:	89 27       	eor	r24, r25
     cfc:	9f 70       	andi	r25, 0x0F	; 15
     cfe:	89 27       	eor	r24, r25
     d00:	81 70       	andi	r24, 0x01	; 1
     d02:	90 70       	andi	r25, 0x00	; 0
     d04:	82 17       	cp	r24, r18
     d06:	93 07       	cpc	r25, r19
     d08:	81 f7       	brne	.-32     	; 0xcea
     d0a:	50 e3       	ldi	r21, 0x30	; 48
     d0c:	50 93 c6 00 	sts	0x00C6, r21
     d10:	21 e0       	ldi	r18, 0x01	; 1
     d12:	30 e0       	ldi	r19, 0x00	; 0
     d14:	80 91 c0 00 	lds	r24, 0x00C0
     d18:	99 27       	eor	r25, r25
     d1a:	96 95       	lsr	r25
     d1c:	87 95       	ror	r24
     d1e:	92 95       	swap	r25
     d20:	82 95       	swap	r24
     d22:	8f 70       	andi	r24, 0x0F	; 15
     d24:	89 27       	eor	r24, r25
     d26:	9f 70       	andi	r25, 0x0F	; 15
     d28:	89 27       	eor	r24, r25
     d2a:	81 70       	andi	r24, 0x01	; 1
     d2c:	90 70       	andi	r25, 0x00	; 0
     d2e:	82 17       	cp	r24, r18
     d30:	93 07       	cpc	r25, r19
     d32:	81 f7       	brne	.-32     	; 0xd14
     d34:	60 e3       	ldi	r22, 0x30	; 48
     d36:	60 93 c6 00 	sts	0x00C6, r22
     d3a:	21 e0       	ldi	r18, 0x01	; 1
     d3c:	30 e0       	ldi	r19, 0x00	; 0
     d3e:	80 91 c0 00 	lds	r24, 0x00C0
     d42:	99 27       	eor	r25, r25
     d44:	96 95       	lsr	r25
     d46:	87 95       	ror	r24
     d48:	92 95       	swap	r25
     d4a:	82 95       	swap	r24
     d4c:	8f 70       	andi	r24, 0x0F	; 15
     d4e:	89 27       	eor	r24, r25
     d50:	9f 70       	andi	r25, 0x0F	; 15
     d52:	89 27       	eor	r24, r25
     d54:	81 70       	andi	r24, 0x01	; 1
     d56:	90 70       	andi	r25, 0x00	; 0
     d58:	82 17       	cp	r24, r18
     d5a:	93 07       	cpc	r25, r19
     d5c:	81 f7       	brne	.-32     	; 0xd3e
     d5e:	fe cc       	rjmp	.-1540   	; 0x75c
     d60:	21 e0       	ldi	r18, 0x01	; 1
     d62:	30 e0       	ldi	r19, 0x00	; 0
     d64:	80 91 c0 00 	lds	r24, 0x00C0
     d68:	99 27       	eor	r25, r25
     d6a:	96 95       	lsr	r25
     d6c:	87 95       	ror	r24
     d6e:	92 95       	swap	r25
     d70:	82 95       	swap	r24
     d72:	8f 70       	andi	r24, 0x0F	; 15
     d74:	89 27       	eor	r24, r25
     d76:	9f 70       	andi	r25, 0x0F	; 15
     d78:	89 27       	eor	r24, r25
     d7a:	81 70       	andi	r24, 0x01	; 1
     d7c:	90 70       	andi	r25, 0x00	; 0
     d7e:	82 17       	cp	r24, r18
     d80:	93 07       	cpc	r25, r19
     d82:	81 f7       	brne	.-32     	; 0xd64
     d84:	40 e3       	ldi	r20, 0x30	; 48
     d86:	40 93 c6 00 	sts	0x00C6, r20
     d8a:	21 e0       	ldi	r18, 0x01	; 1
     d8c:	30 e0       	ldi	r19, 0x00	; 0
     d8e:	80 91 c0 00 	lds	r24, 0x00C0
     d92:	99 27       	eor	r25, r25
     d94:	96 95       	lsr	r25
     d96:	87 95       	ror	r24
     d98:	92 95       	swap	r25
     d9a:	82 95       	swap	r24
     d9c:	8f 70       	andi	r24, 0x0F	; 15
     d9e:	89 27       	eor	r24, r25
     da0:	9f 70       	andi	r25, 0x0F	; 15
     da2:	89 27       	eor	r24, r25
     da4:	81 70       	andi	r24, 0x01	; 1
     da6:	90 70       	andi	r25, 0x00	; 0
     da8:	82 17       	cp	r24, r18
     daa:	93 07       	cpc	r25, r19
     dac:	81 f7       	brne	.-32     	; 0xd8e
     dae:	51 e3       	ldi	r21, 0x31	; 49
     db0:	50 93 c6 00 	sts	0x00C6, r21
     db4:	21 e0       	ldi	r18, 0x01	; 1
     db6:	30 e0       	ldi	r19, 0x00	; 0
     db8:	80 91 c0 00 	lds	r24, 0x00C0
     dbc:	99 27       	eor	r25, r25
     dbe:	96 95       	lsr	r25
     dc0:	87 95       	ror	r24
     dc2:	92 95       	swap	r25
     dc4:	82 95       	swap	r24
     dc6:	8f 70       	andi	r24, 0x0F	; 15
     dc8:	89 27       	eor	r24, r25
     dca:	9f 70       	andi	r25, 0x0F	; 15
     dcc:	89 27       	eor	r24, r25
     dce:	81 70       	andi	r24, 0x01	; 1
     dd0:	90 70       	andi	r25, 0x00	; 0
     dd2:	82 17       	cp	r24, r18
     dd4:	93 07       	cpc	r25, r19
     dd6:	81 f7       	brne	.-32     	; 0xdb8
     dd8:	60 e3       	ldi	r22, 0x30	; 48
     dda:	60 93 c6 00 	sts	0x00C6, r22
     dde:	21 e0       	ldi	r18, 0x01	; 1
     de0:	30 e0       	ldi	r19, 0x00	; 0
     de2:	80 91 c0 00 	lds	r24, 0x00C0
     de6:	99 27       	eor	r25, r25
     de8:	96 95       	lsr	r25
     dea:	87 95       	ror	r24
     dec:	92 95       	swap	r25
     dee:	82 95       	swap	r24
     df0:	8f 70       	andi	r24, 0x0F	; 15
     df2:	89 27       	eor	r24, r25
     df4:	9f 70       	andi	r25, 0x0F	; 15
     df6:	89 27       	eor	r24, r25
     df8:	81 70       	andi	r24, 0x01	; 1
     dfa:	90 70       	andi	r25, 0x00	; 0
     dfc:	82 17       	cp	r24, r18
     dfe:	93 07       	cpc	r25, r19
     e00:	81 f7       	brne	.-32     	; 0xde2
     e02:	ac cc       	rjmp	.-1704   	; 0x75c
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
     e28:	41 e3       	ldi	r20, 0x31	; 49
     e2a:	40 93 c6 00 	sts	0x00C6, r20
     e2e:	21 e0       	ldi	r18, 0x01	; 1
     e30:	30 e0       	ldi	r19, 0x00	; 0
     e32:	80 91 c0 00 	lds	r24, 0x00C0
     e36:	99 27       	eor	r25, r25
     e38:	96 95       	lsr	r25
     e3a:	87 95       	ror	r24
     e3c:	92 95       	swap	r25
     e3e:	82 95       	swap	r24
     e40:	8f 70       	andi	r24, 0x0F	; 15
     e42:	89 27       	eor	r24, r25
     e44:	9f 70       	andi	r25, 0x0F	; 15
     e46:	89 27       	eor	r24, r25
     e48:	81 70       	andi	r24, 0x01	; 1
     e4a:	90 70       	andi	r25, 0x00	; 0
     e4c:	82 17       	cp	r24, r18
     e4e:	93 07       	cpc	r25, r19
     e50:	81 f7       	brne	.-32     	; 0xe32
     e52:	51 e3       	ldi	r21, 0x31	; 49
     e54:	50 93 c6 00 	sts	0x00C6, r21
     e58:	21 e0       	ldi	r18, 0x01	; 1
     e5a:	30 e0       	ldi	r19, 0x00	; 0
     e5c:	80 91 c0 00 	lds	r24, 0x00C0
     e60:	99 27       	eor	r25, r25
     e62:	96 95       	lsr	r25
     e64:	87 95       	ror	r24
     e66:	92 95       	swap	r25
     e68:	82 95       	swap	r24
     e6a:	8f 70       	andi	r24, 0x0F	; 15
     e6c:	89 27       	eor	r24, r25
     e6e:	9f 70       	andi	r25, 0x0F	; 15
     e70:	89 27       	eor	r24, r25
     e72:	81 70       	andi	r24, 0x01	; 1
     e74:	90 70       	andi	r25, 0x00	; 0
     e76:	82 17       	cp	r24, r18
     e78:	93 07       	cpc	r25, r19
     e7a:	81 f7       	brne	.-32     	; 0xe5c
     e7c:	60 e3       	ldi	r22, 0x30	; 48
     e7e:	60 93 c6 00 	sts	0x00C6, r22
     e82:	21 e0       	ldi	r18, 0x01	; 1
     e84:	30 e0       	ldi	r19, 0x00	; 0
     e86:	80 91 c0 00 	lds	r24, 0x00C0
     e8a:	99 27       	eor	r25, r25
     e8c:	96 95       	lsr	r25
     e8e:	87 95       	ror	r24
     e90:	92 95       	swap	r25
     e92:	82 95       	swap	r24
     e94:	8f 70       	andi	r24, 0x0F	; 15
     e96:	89 27       	eor	r24, r25
     e98:	9f 70       	andi	r25, 0x0F	; 15
     e9a:	89 27       	eor	r24, r25
     e9c:	81 70       	andi	r24, 0x01	; 1
     e9e:	90 70       	andi	r25, 0x00	; 0
     ea0:	82 17       	cp	r24, r18
     ea2:	93 07       	cpc	r25, r19
     ea4:	81 f7       	brne	.-32     	; 0xe86
     ea6:	5a cc       	rjmp	.-1868   	; 0x75c
     ea8:	89 2b       	or	r24, r25
     eaa:	09 f4       	brne	.+2      	; 0xeae
     eac:	54 c0       	rjmp	.+168    	; 0xf56
     eae:	08 95       	ret
     eb0:	21 e0       	ldi	r18, 0x01	; 1
     eb2:	30 e0       	ldi	r19, 0x00	; 0
     eb4:	80 91 c0 00 	lds	r24, 0x00C0
     eb8:	99 27       	eor	r25, r25
     eba:	96 95       	lsr	r25
     ebc:	87 95       	ror	r24
     ebe:	92 95       	swap	r25
     ec0:	82 95       	swap	r24
     ec2:	8f 70       	andi	r24, 0x0F	; 15
     ec4:	89 27       	eor	r24, r25
     ec6:	9f 70       	andi	r25, 0x0F	; 15
     ec8:	89 27       	eor	r24, r25
     eca:	81 70       	andi	r24, 0x01	; 1
     ecc:	90 70       	andi	r25, 0x00	; 0
     ece:	82 17       	cp	r24, r18
     ed0:	93 07       	cpc	r25, r19
     ed2:	81 f7       	brne	.-32     	; 0xeb4
     ed4:	71 e3       	ldi	r23, 0x31	; 49
     ed6:	70 93 c6 00 	sts	0x00C6, r23
     eda:	21 e0       	ldi	r18, 0x01	; 1
     edc:	30 e0       	ldi	r19, 0x00	; 0
     ede:	80 91 c0 00 	lds	r24, 0x00C0
     ee2:	99 27       	eor	r25, r25
     ee4:	96 95       	lsr	r25
     ee6:	87 95       	ror	r24
     ee8:	92 95       	swap	r25
     eea:	82 95       	swap	r24
     eec:	8f 70       	andi	r24, 0x0F	; 15
     eee:	89 27       	eor	r24, r25
     ef0:	9f 70       	andi	r25, 0x0F	; 15
     ef2:	89 27       	eor	r24, r25
     ef4:	81 70       	andi	r24, 0x01	; 1
     ef6:	90 70       	andi	r25, 0x00	; 0
     ef8:	82 17       	cp	r24, r18
     efa:	93 07       	cpc	r25, r19
     efc:	81 f7       	brne	.-32     	; 0xede
     efe:	91 e3       	ldi	r25, 0x31	; 49
     f00:	90 93 c6 00 	sts	0x00C6, r25
     f04:	21 e0       	ldi	r18, 0x01	; 1
     f06:	30 e0       	ldi	r19, 0x00	; 0
     f08:	80 91 c0 00 	lds	r24, 0x00C0
     f0c:	99 27       	eor	r25, r25
     f0e:	96 95       	lsr	r25
     f10:	87 95       	ror	r24
     f12:	92 95       	swap	r25
     f14:	82 95       	swap	r24
     f16:	8f 70       	andi	r24, 0x0F	; 15
     f18:	89 27       	eor	r24, r25
     f1a:	9f 70       	andi	r25, 0x0F	; 15
     f1c:	89 27       	eor	r24, r25
     f1e:	81 70       	andi	r24, 0x01	; 1
     f20:	90 70       	andi	r25, 0x00	; 0
     f22:	82 17       	cp	r24, r18
     f24:	93 07       	cpc	r25, r19
     f26:	81 f7       	brne	.-32     	; 0xf08
     f28:	a1 e3       	ldi	r26, 0x31	; 49
     f2a:	a0 93 c6 00 	sts	0x00C6, r26
     f2e:	21 e0       	ldi	r18, 0x01	; 1
     f30:	30 e0       	ldi	r19, 0x00	; 0
     f32:	80 91 c0 00 	lds	r24, 0x00C0
     f36:	99 27       	eor	r25, r25
     f38:	96 95       	lsr	r25
     f3a:	87 95       	ror	r24
     f3c:	92 95       	swap	r25
     f3e:	82 95       	swap	r24
     f40:	8f 70       	andi	r24, 0x0F	; 15
     f42:	89 27       	eor	r24, r25
     f44:	9f 70       	andi	r25, 0x0F	; 15
     f46:	89 27       	eor	r24, r25
     f48:	81 70       	andi	r24, 0x01	; 1
     f4a:	90 70       	andi	r25, 0x00	; 0
     f4c:	82 17       	cp	r24, r18
     f4e:	93 07       	cpc	r25, r19
     f50:	81 f7       	brne	.-32     	; 0xf32
     f52:	80 e3       	ldi	r24, 0x30	; 48
     f54:	4d cb       	rjmp	.-2406   	; 0x5f0
     f56:	21 e0       	ldi	r18, 0x01	; 1
     f58:	30 e0       	ldi	r19, 0x00	; 0
     f5a:	80 91 c0 00 	lds	r24, 0x00C0
     f5e:	99 27       	eor	r25, r25
     f60:	96 95       	lsr	r25
     f62:	87 95       	ror	r24
     f64:	92 95       	swap	r25
     f66:	82 95       	swap	r24
     f68:	8f 70       	andi	r24, 0x0F	; 15
     f6a:	89 27       	eor	r24, r25
     f6c:	9f 70       	andi	r25, 0x0F	; 15
     f6e:	89 27       	eor	r24, r25
     f70:	81 70       	andi	r24, 0x01	; 1
     f72:	90 70       	andi	r25, 0x00	; 0
     f74:	82 17       	cp	r24, r18
     f76:	93 07       	cpc	r25, r19
     f78:	81 f7       	brne	.-32     	; 0xf5a
     f7a:	80 e3       	ldi	r24, 0x30	; 48
     f7c:	80 93 c6 00 	sts	0x00C6, r24
     f80:	21 e0       	ldi	r18, 0x01	; 1
     f82:	30 e0       	ldi	r19, 0x00	; 0
     f84:	80 91 c0 00 	lds	r24, 0x00C0
     f88:	99 27       	eor	r25, r25
     f8a:	96 95       	lsr	r25
     f8c:	87 95       	ror	r24
     f8e:	92 95       	swap	r25
     f90:	82 95       	swap	r24
     f92:	8f 70       	andi	r24, 0x0F	; 15
     f94:	89 27       	eor	r24, r25
     f96:	9f 70       	andi	r25, 0x0F	; 15
     f98:	89 27       	eor	r24, r25
     f9a:	81 70       	andi	r24, 0x01	; 1
     f9c:	90 70       	andi	r25, 0x00	; 0
     f9e:	82 17       	cp	r24, r18
     fa0:	93 07       	cpc	r25, r19
     fa2:	81 f7       	brne	.-32     	; 0xf84
     fa4:	20 e3       	ldi	r18, 0x30	; 48
     fa6:	20 93 c6 00 	sts	0x00C6, r18
     faa:	21 e0       	ldi	r18, 0x01	; 1
     fac:	30 e0       	ldi	r19, 0x00	; 0
     fae:	80 91 c0 00 	lds	r24, 0x00C0
     fb2:	99 27       	eor	r25, r25
     fb4:	96 95       	lsr	r25
     fb6:	87 95       	ror	r24
     fb8:	92 95       	swap	r25
     fba:	82 95       	swap	r24
     fbc:	8f 70       	andi	r24, 0x0F	; 15
     fbe:	89 27       	eor	r24, r25
     fc0:	9f 70       	andi	r25, 0x0F	; 15
     fc2:	89 27       	eor	r24, r25
     fc4:	81 70       	andi	r24, 0x01	; 1
     fc6:	90 70       	andi	r25, 0x00	; 0
     fc8:	82 17       	cp	r24, r18
     fca:	93 07       	cpc	r25, r19
     fcc:	81 f7       	brne	.-32     	; 0xfae
     fce:	30 e3       	ldi	r19, 0x30	; 48
     fd0:	30 93 c6 00 	sts	0x00C6, r19
     fd4:	21 e0       	ldi	r18, 0x01	; 1
     fd6:	30 e0       	ldi	r19, 0x00	; 0
     fd8:	80 91 c0 00 	lds	r24, 0x00C0
     fdc:	99 27       	eor	r25, r25
     fde:	96 95       	lsr	r25
     fe0:	87 95       	ror	r24
     fe2:	92 95       	swap	r25
     fe4:	82 95       	swap	r24
     fe6:	8f 70       	andi	r24, 0x0F	; 15
     fe8:	89 27       	eor	r24, r25
     fea:	9f 70       	andi	r25, 0x0F	; 15
     fec:	89 27       	eor	r24, r25
     fee:	81 70       	andi	r24, 0x01	; 1
     ff0:	90 70       	andi	r25, 0x00	; 0
     ff2:	82 17       	cp	r24, r18
     ff4:	93 07       	cpc	r25, r19
     ff6:	81 f7       	brne	.-32     	; 0xfd8
     ff8:	80 e3       	ldi	r24, 0x30	; 48
     ffa:	fa ca       	rjmp	.-2572   	; 0x5f0

00000ffc <UART_send_BIN8>:
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
     ffc:	cf 93       	push	r28
     ffe:	c8 2f       	mov	r28, r24
    1000:	21 e0       	ldi	r18, 0x01	; 1
    1002:	30 e0       	ldi	r19, 0x00	; 0
    1004:	80 91 c0 00 	lds	r24, 0x00C0
    1008:	99 27       	eor	r25, r25
    100a:	96 95       	lsr	r25
    100c:	87 95       	ror	r24
    100e:	92 95       	swap	r25
    1010:	82 95       	swap	r24
    1012:	8f 70       	andi	r24, 0x0F	; 15
    1014:	89 27       	eor	r24, r25
    1016:	9f 70       	andi	r25, 0x0F	; 15
    1018:	89 27       	eor	r24, r25
    101a:	81 70       	andi	r24, 0x01	; 1
    101c:	90 70       	andi	r25, 0x00	; 0
    101e:	82 17       	cp	r24, r18
    1020:	93 07       	cpc	r25, r19
    1022:	81 f7       	brne	.-32     	; 0x1004
    1024:	82 e6       	ldi	r24, 0x62	; 98
    1026:	80 93 c6 00 	sts	0x00C6, r24
	send_byte_serial('b');
	UART_send_BIN4(lowb>>4);
    102a:	8c 2f       	mov	r24, r28
    102c:	82 95       	swap	r24
    102e:	8f 70       	andi	r24, 0x0F	; 15
    1030:	0e 94 8d 02 	call	0x51a
	UART_send_BIN4(lowb & 0x0F);
    1034:	8c 2f       	mov	r24, r28
    1036:	8f 70       	andi	r24, 0x0F	; 15
    1038:	0e 94 8d 02 	call	0x51a
    103c:	cf 91       	pop	r28
    103e:	08 95       	ret

00001040 <UART_send_HEX4>:
}
	
void UART_send_HEX4(uint8_t lowb){
	switch(lowb){
    1040:	99 27       	eor	r25, r25
    1042:	87 30       	cpi	r24, 0x07	; 7
    1044:	91 05       	cpc	r25, r1
    1046:	09 f4       	brne	.+2      	; 0x104a
    1048:	4a c0       	rjmp	.+148    	; 0x10de
    104a:	88 30       	cpi	r24, 0x08	; 8
    104c:	91 05       	cpc	r25, r1
    104e:	24 f5       	brge	.+72     	; 0x1098
    1050:	83 30       	cpi	r24, 0x03	; 3
    1052:	91 05       	cpc	r25, r1
    1054:	09 f4       	brne	.+2      	; 0x1058
    1056:	9a c0       	rjmp	.+308    	; 0x118c
    1058:	84 30       	cpi	r24, 0x04	; 4
    105a:	91 05       	cpc	r25, r1
    105c:	0c f0       	brlt	.+2      	; 0x1060
    105e:	55 c0       	rjmp	.+170    	; 0x110a
    1060:	81 30       	cpi	r24, 0x01	; 1
    1062:	91 05       	cpc	r25, r1
    1064:	09 f4       	brne	.+2      	; 0x1068
    1066:	fa c0       	rjmp	.+500    	; 0x125c
    1068:	82 30       	cpi	r24, 0x02	; 2
    106a:	91 05       	cpc	r25, r1
    106c:	0c f4       	brge	.+2      	; 0x1070
    106e:	44 c1       	rjmp	.+648    	; 0x12f8
    1070:	21 e0       	ldi	r18, 0x01	; 1
    1072:	30 e0       	ldi	r19, 0x00	; 0
    1074:	80 91 c0 00 	lds	r24, 0x00C0
    1078:	99 27       	eor	r25, r25
    107a:	96 95       	lsr	r25
    107c:	87 95       	ror	r24
    107e:	92 95       	swap	r25
    1080:	82 95       	swap	r24
    1082:	8f 70       	andi	r24, 0x0F	; 15
    1084:	89 27       	eor	r24, r25
    1086:	9f 70       	andi	r25, 0x0F	; 15
    1088:	89 27       	eor	r24, r25
    108a:	81 70       	andi	r24, 0x01	; 1
    108c:	90 70       	andi	r25, 0x00	; 0
    108e:	82 17       	cp	r24, r18
    1090:	93 07       	cpc	r25, r19
    1092:	81 f7       	brne	.-32     	; 0x1074
    1094:	82 e3       	ldi	r24, 0x32	; 50
    1096:	36 c0       	rjmp	.+108    	; 0x1104
    1098:	8b 30       	cpi	r24, 0x0B	; 11
    109a:	91 05       	cpc	r25, r1
    109c:	09 f4       	brne	.+2      	; 0x10a0
    109e:	60 c0       	rjmp	.+192    	; 0x1160
    10a0:	8c 30       	cpi	r24, 0x0C	; 12
    10a2:	91 05       	cpc	r25, r1
    10a4:	0c f0       	brlt	.+2      	; 0x10a8
    10a6:	4c c0       	rjmp	.+152    	; 0x1140
    10a8:	89 30       	cpi	r24, 0x09	; 9
    10aa:	91 05       	cpc	r25, r1
    10ac:	09 f4       	brne	.+2      	; 0x10b0
    10ae:	e8 c0       	rjmp	.+464    	; 0x1280
    10b0:	0a 97       	sbiw	r24, 0x0a	; 10
    10b2:	0c f0       	brlt	.+2      	; 0x10b6
    10b4:	81 c0       	rjmp	.+258    	; 0x11b8
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
    10da:	88 e3       	ldi	r24, 0x38	; 56
    10dc:	13 c0       	rjmp	.+38     	; 0x1104
    10de:	21 e0       	ldi	r18, 0x01	; 1
    10e0:	30 e0       	ldi	r19, 0x00	; 0
    10e2:	80 91 c0 00 	lds	r24, 0x00C0
    10e6:	99 27       	eor	r25, r25
    10e8:	96 95       	lsr	r25
    10ea:	87 95       	ror	r24
    10ec:	92 95       	swap	r25
    10ee:	82 95       	swap	r24
    10f0:	8f 70       	andi	r24, 0x0F	; 15
    10f2:	89 27       	eor	r24, r25
    10f4:	9f 70       	andi	r25, 0x0F	; 15
    10f6:	89 27       	eor	r24, r25
    10f8:	81 70       	andi	r24, 0x01	; 1
    10fa:	90 70       	andi	r25, 0x00	; 0
    10fc:	82 17       	cp	r24, r18
    10fe:	93 07       	cpc	r25, r19
    1100:	81 f7       	brne	.-32     	; 0x10e2
    1102:	87 e3       	ldi	r24, 0x37	; 55
    1104:	80 93 c6 00 	sts	0x00C6, r24
    1108:	08 95       	ret
    110a:	85 30       	cpi	r24, 0x05	; 5
    110c:	91 05       	cpc	r25, r1
    110e:	09 f4       	brne	.+2      	; 0x1112
    1110:	cb c0       	rjmp	.+406    	; 0x12a8
    1112:	06 97       	sbiw	r24, 0x06	; 6
    1114:	0c f0       	brlt	.+2      	; 0x1118
    1116:	78 c0       	rjmp	.+240    	; 0x1208
    1118:	21 e0       	ldi	r18, 0x01	; 1
    111a:	30 e0       	ldi	r19, 0x00	; 0
    111c:	80 91 c0 00 	lds	r24, 0x00C0
    1120:	99 27       	eor	r25, r25
    1122:	96 95       	lsr	r25
    1124:	87 95       	ror	r24
    1126:	92 95       	swap	r25
    1128:	82 95       	swap	r24
    112a:	8f 70       	andi	r24, 0x0F	; 15
    112c:	89 27       	eor	r24, r25
    112e:	9f 70       	andi	r25, 0x0F	; 15
    1130:	89 27       	eor	r24, r25
    1132:	81 70       	andi	r24, 0x01	; 1
    1134:	90 70       	andi	r25, 0x00	; 0
    1136:	82 17       	cp	r24, r18
    1138:	93 07       	cpc	r25, r19
    113a:	81 f7       	brne	.-32     	; 0x111c
    113c:	84 e3       	ldi	r24, 0x34	; 52
    113e:	e2 cf       	rjmp	.-60     	; 0x1104
    1140:	8d 30       	cpi	r24, 0x0D	; 13
    1142:	91 05       	cpc	r25, r1
    1144:	09 f4       	brne	.+2      	; 0x1148
    1146:	c4 c0       	rjmp	.+392    	; 0x12d0
    1148:	8d 30       	cpi	r24, 0x0D	; 13
    114a:	91 05       	cpc	r25, r1
    114c:	0c f4       	brge	.+2      	; 0x1150
    114e:	48 c0       	rjmp	.+144    	; 0x11e0
    1150:	8e 30       	cpi	r24, 0x0E	; 14
    1152:	91 05       	cpc	r25, r1
    1154:	09 f4       	brne	.+2      	; 0x1158
    1156:	d3 c0       	rjmp	.+422    	; 0x12fe
    1158:	0f 97       	sbiw	r24, 0x0f	; 15
    115a:	09 f4       	brne	.+2      	; 0x115e
    115c:	69 c0       	rjmp	.+210    	; 0x1230
    115e:	08 95       	ret
    1160:	21 e0       	ldi	r18, 0x01	; 1
    1162:	30 e0       	ldi	r19, 0x00	; 0
    1164:	80 91 c0 00 	lds	r24, 0x00C0
    1168:	99 27       	eor	r25, r25
    116a:	96 95       	lsr	r25
    116c:	87 95       	ror	r24
    116e:	92 95       	swap	r25
    1170:	82 95       	swap	r24
    1172:	8f 70       	andi	r24, 0x0F	; 15
    1174:	89 27       	eor	r24, r25
    1176:	9f 70       	andi	r25, 0x0F	; 15
    1178:	89 27       	eor	r24, r25
    117a:	81 70       	andi	r24, 0x01	; 1
    117c:	90 70       	andi	r25, 0x00	; 0
    117e:	82 17       	cp	r24, r18
    1180:	93 07       	cpc	r25, r19
    1182:	81 f7       	brne	.-32     	; 0x1164
    1184:	82 e4       	ldi	r24, 0x42	; 66
    1186:	80 93 c6 00 	sts	0x00C6, r24
    118a:	08 95       	ret
    118c:	21 e0       	ldi	r18, 0x01	; 1
    118e:	30 e0       	ldi	r19, 0x00	; 0
    1190:	80 91 c0 00 	lds	r24, 0x00C0
    1194:	99 27       	eor	r25, r25
    1196:	96 95       	lsr	r25
    1198:	87 95       	ror	r24
    119a:	92 95       	swap	r25
    119c:	82 95       	swap	r24
    119e:	8f 70       	andi	r24, 0x0F	; 15
    11a0:	89 27       	eor	r24, r25
    11a2:	9f 70       	andi	r25, 0x0F	; 15
    11a4:	89 27       	eor	r24, r25
    11a6:	81 70       	andi	r24, 0x01	; 1
    11a8:	90 70       	andi	r25, 0x00	; 0
    11aa:	82 17       	cp	r24, r18
    11ac:	93 07       	cpc	r25, r19
    11ae:	81 f7       	brne	.-32     	; 0x1190
    11b0:	83 e3       	ldi	r24, 0x33	; 51
    11b2:	80 93 c6 00 	sts	0x00C6, r24
    11b6:	08 95       	ret
    11b8:	21 e0       	ldi	r18, 0x01	; 1
    11ba:	30 e0       	ldi	r19, 0x00	; 0
    11bc:	80 91 c0 00 	lds	r24, 0x00C0
    11c0:	99 27       	eor	r25, r25
    11c2:	96 95       	lsr	r25
    11c4:	87 95       	ror	r24
    11c6:	92 95       	swap	r25
    11c8:	82 95       	swap	r24
    11ca:	8f 70       	andi	r24, 0x0F	; 15
    11cc:	89 27       	eor	r24, r25
    11ce:	9f 70       	andi	r25, 0x0F	; 15
    11d0:	89 27       	eor	r24, r25
    11d2:	81 70       	andi	r24, 0x01	; 1
    11d4:	90 70       	andi	r25, 0x00	; 0
    11d6:	82 17       	cp	r24, r18
    11d8:	93 07       	cpc	r25, r19
    11da:	81 f7       	brne	.-32     	; 0x11bc
    11dc:	81 e4       	ldi	r24, 0x41	; 65
    11de:	92 cf       	rjmp	.-220    	; 0x1104
    11e0:	21 e0       	ldi	r18, 0x01	; 1
    11e2:	30 e0       	ldi	r19, 0x00	; 0
    11e4:	80 91 c0 00 	lds	r24, 0x00C0
    11e8:	99 27       	eor	r25, r25
    11ea:	96 95       	lsr	r25
    11ec:	87 95       	ror	r24
    11ee:	92 95       	swap	r25
    11f0:	82 95       	swap	r24
    11f2:	8f 70       	andi	r24, 0x0F	; 15
    11f4:	89 27       	eor	r24, r25
    11f6:	9f 70       	andi	r25, 0x0F	; 15
    11f8:	89 27       	eor	r24, r25
    11fa:	81 70       	andi	r24, 0x01	; 1
    11fc:	90 70       	andi	r25, 0x00	; 0
    11fe:	82 17       	cp	r24, r18
    1200:	93 07       	cpc	r25, r19
    1202:	81 f7       	brne	.-32     	; 0x11e4
    1204:	83 e4       	ldi	r24, 0x43	; 67
    1206:	7e cf       	rjmp	.-260    	; 0x1104
    1208:	21 e0       	ldi	r18, 0x01	; 1
    120a:	30 e0       	ldi	r19, 0x00	; 0
    120c:	80 91 c0 00 	lds	r24, 0x00C0
    1210:	99 27       	eor	r25, r25
    1212:	96 95       	lsr	r25
    1214:	87 95       	ror	r24
    1216:	92 95       	swap	r25
    1218:	82 95       	swap	r24
    121a:	8f 70       	andi	r24, 0x0F	; 15
    121c:	89 27       	eor	r24, r25
    121e:	9f 70       	andi	r25, 0x0F	; 15
    1220:	89 27       	eor	r24, r25
    1222:	81 70       	andi	r24, 0x01	; 1
    1224:	90 70       	andi	r25, 0x00	; 0
    1226:	82 17       	cp	r24, r18
    1228:	93 07       	cpc	r25, r19
    122a:	81 f7       	brne	.-32     	; 0x120c
    122c:	86 e3       	ldi	r24, 0x36	; 54
    122e:	6a cf       	rjmp	.-300    	; 0x1104
    1230:	21 e0       	ldi	r18, 0x01	; 1
    1232:	30 e0       	ldi	r19, 0x00	; 0
    1234:	80 91 c0 00 	lds	r24, 0x00C0
    1238:	99 27       	eor	r25, r25
    123a:	96 95       	lsr	r25
    123c:	87 95       	ror	r24
    123e:	92 95       	swap	r25
    1240:	82 95       	swap	r24
    1242:	8f 70       	andi	r24, 0x0F	; 15
    1244:	89 27       	eor	r24, r25
    1246:	9f 70       	andi	r25, 0x0F	; 15
    1248:	89 27       	eor	r24, r25
    124a:	81 70       	andi	r24, 0x01	; 1
    124c:	90 70       	andi	r25, 0x00	; 0
    124e:	82 17       	cp	r24, r18
    1250:	93 07       	cpc	r25, r19
    1252:	81 f7       	brne	.-32     	; 0x1234
    1254:	86 e4       	ldi	r24, 0x46	; 70
    1256:	80 93 c6 00 	sts	0x00C6, r24
    125a:	08 95       	ret
    125c:	9c 01       	movw	r18, r24
    125e:	80 91 c0 00 	lds	r24, 0x00C0
    1262:	99 27       	eor	r25, r25
    1264:	96 95       	lsr	r25
    1266:	87 95       	ror	r24
    1268:	92 95       	swap	r25
    126a:	82 95       	swap	r24
    126c:	8f 70       	andi	r24, 0x0F	; 15
    126e:	89 27       	eor	r24, r25
    1270:	9f 70       	andi	r25, 0x0F	; 15
    1272:	89 27       	eor	r24, r25
    1274:	82 27       	eor	r24, r18
    1276:	93 27       	eor	r25, r19
    1278:	80 fd       	sbrc	r24, 0
    127a:	f1 cf       	rjmp	.-30     	; 0x125e
    127c:	81 e3       	ldi	r24, 0x31	; 49
    127e:	42 cf       	rjmp	.-380    	; 0x1104
    1280:	21 e0       	ldi	r18, 0x01	; 1
    1282:	30 e0       	ldi	r19, 0x00	; 0
    1284:	80 91 c0 00 	lds	r24, 0x00C0
    1288:	99 27       	eor	r25, r25
    128a:	96 95       	lsr	r25
    128c:	87 95       	ror	r24
    128e:	92 95       	swap	r25
    1290:	82 95       	swap	r24
    1292:	8f 70       	andi	r24, 0x0F	; 15
    1294:	89 27       	eor	r24, r25
    1296:	9f 70       	andi	r25, 0x0F	; 15
    1298:	89 27       	eor	r24, r25
    129a:	81 70       	andi	r24, 0x01	; 1
    129c:	90 70       	andi	r25, 0x00	; 0
    129e:	82 17       	cp	r24, r18
    12a0:	93 07       	cpc	r25, r19
    12a2:	81 f7       	brne	.-32     	; 0x1284
    12a4:	89 e3       	ldi	r24, 0x39	; 57
    12a6:	2e cf       	rjmp	.-420    	; 0x1104
    12a8:	21 e0       	ldi	r18, 0x01	; 1
    12aa:	30 e0       	ldi	r19, 0x00	; 0
    12ac:	80 91 c0 00 	lds	r24, 0x00C0
    12b0:	99 27       	eor	r25, r25
    12b2:	96 95       	lsr	r25
    12b4:	87 95       	ror	r24
    12b6:	92 95       	swap	r25
    12b8:	82 95       	swap	r24
    12ba:	8f 70       	andi	r24, 0x0F	; 15
    12bc:	89 27       	eor	r24, r25
    12be:	9f 70       	andi	r25, 0x0F	; 15
    12c0:	89 27       	eor	r24, r25
    12c2:	81 70       	andi	r24, 0x01	; 1
    12c4:	90 70       	andi	r25, 0x00	; 0
    12c6:	82 17       	cp	r24, r18
    12c8:	93 07       	cpc	r25, r19
    12ca:	81 f7       	brne	.-32     	; 0x12ac
    12cc:	85 e3       	ldi	r24, 0x35	; 53
    12ce:	1a cf       	rjmp	.-460    	; 0x1104
    12d0:	21 e0       	ldi	r18, 0x01	; 1
    12d2:	30 e0       	ldi	r19, 0x00	; 0
    12d4:	80 91 c0 00 	lds	r24, 0x00C0
    12d8:	99 27       	eor	r25, r25
    12da:	96 95       	lsr	r25
    12dc:	87 95       	ror	r24
    12de:	92 95       	swap	r25
    12e0:	82 95       	swap	r24
    12e2:	8f 70       	andi	r24, 0x0F	; 15
    12e4:	89 27       	eor	r24, r25
    12e6:	9f 70       	andi	r25, 0x0F	; 15
    12e8:	89 27       	eor	r24, r25
    12ea:	81 70       	andi	r24, 0x01	; 1
    12ec:	90 70       	andi	r25, 0x00	; 0
    12ee:	82 17       	cp	r24, r18
    12f0:	93 07       	cpc	r25, r19
    12f2:	81 f7       	brne	.-32     	; 0x12d4
    12f4:	84 e4       	ldi	r24, 0x44	; 68
    12f6:	06 cf       	rjmp	.-500    	; 0x1104
    12f8:	89 2b       	or	r24, r25
    12fa:	a9 f0       	breq	.+42     	; 0x1326
    12fc:	08 95       	ret
    12fe:	21 e0       	ldi	r18, 0x01	; 1
    1300:	30 e0       	ldi	r19, 0x00	; 0
    1302:	80 91 c0 00 	lds	r24, 0x00C0
    1306:	99 27       	eor	r25, r25
    1308:	96 95       	lsr	r25
    130a:	87 95       	ror	r24
    130c:	92 95       	swap	r25
    130e:	82 95       	swap	r24
    1310:	8f 70       	andi	r24, 0x0F	; 15
    1312:	89 27       	eor	r24, r25
    1314:	9f 70       	andi	r25, 0x0F	; 15
    1316:	89 27       	eor	r24, r25
    1318:	81 70       	andi	r24, 0x01	; 1
    131a:	90 70       	andi	r25, 0x00	; 0
    131c:	82 17       	cp	r24, r18
    131e:	93 07       	cpc	r25, r19
    1320:	81 f7       	brne	.-32     	; 0x1302
    1322:	85 e4       	ldi	r24, 0x45	; 69
    1324:	ef ce       	rjmp	.-546    	; 0x1104
    1326:	21 e0       	ldi	r18, 0x01	; 1
    1328:	30 e0       	ldi	r19, 0x00	; 0
    132a:	80 91 c0 00 	lds	r24, 0x00C0
    132e:	99 27       	eor	r25, r25
    1330:	96 95       	lsr	r25
    1332:	87 95       	ror	r24
    1334:	92 95       	swap	r25
    1336:	82 95       	swap	r24
    1338:	8f 70       	andi	r24, 0x0F	; 15
    133a:	89 27       	eor	r24, r25
    133c:	9f 70       	andi	r25, 0x0F	; 15
    133e:	89 27       	eor	r24, r25
    1340:	81 70       	andi	r24, 0x01	; 1
    1342:	90 70       	andi	r25, 0x00	; 0
    1344:	82 17       	cp	r24, r18
    1346:	93 07       	cpc	r25, r19
    1348:	81 f7       	brne	.-32     	; 0x132a
    134a:	80 e3       	ldi	r24, 0x30	; 48
    134c:	db ce       	rjmp	.-586    	; 0x1104

0000134e <UART_send_HEX8>:
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
    134e:	1f 93       	push	r17
    1350:	18 2f       	mov	r17, r24
	UART_send_HEX4(lowb>>4);
    1352:	82 95       	swap	r24
    1354:	8f 70       	andi	r24, 0x0F	; 15
    1356:	0e 94 20 08 	call	0x1040
	UART_send_HEX4(lowb & 0x0F);
    135a:	81 2f       	mov	r24, r17
    135c:	8f 70       	andi	r24, 0x0F	; 15
    135e:	0e 94 20 08 	call	0x1040
    1362:	1f 91       	pop	r17
    1364:	08 95       	ret

00001366 <UART_send_HEX16b>:
}

void UART_send_HEX16b(uint8_t highb, uint8_t lowb){
    1366:	0f 93       	push	r16
    1368:	1f 93       	push	r17
    136a:	18 2f       	mov	r17, r24
    136c:	06 2f       	mov	r16, r22
    136e:	82 95       	swap	r24
    1370:	8f 70       	andi	r24, 0x0F	; 15
    1372:	0e 94 20 08 	call	0x1040
    1376:	81 2f       	mov	r24, r17
    1378:	8f 70       	andi	r24, 0x0F	; 15
    137a:	0e 94 20 08 	call	0x1040
    137e:	80 2f       	mov	r24, r16
    1380:	82 95       	swap	r24
    1382:	8f 70       	andi	r24, 0x0F	; 15
    1384:	0e 94 20 08 	call	0x1040
    1388:	80 2f       	mov	r24, r16
    138a:	8f 70       	andi	r24, 0x0F	; 15
    138c:	0e 94 20 08 	call	0x1040
    1390:	1f 91       	pop	r17
    1392:	0f 91       	pop	r16
    1394:	08 95       	ret

00001396 <UART_send_HEX16>:
	UART_send_HEX8(highb);
	UART_send_HEX8(lowb);
}

void UART_send_HEX16(uint16_t highb){
    1396:	ef 92       	push	r14
    1398:	ff 92       	push	r15
    139a:	1f 93       	push	r17
    139c:	7c 01       	movw	r14, r24
	uint8_t blah;
	blah = (uint8_t)(highb>>8);
    139e:	89 2f       	mov	r24, r25
    13a0:	99 27       	eor	r25, r25
    13a2:	f8 2e       	mov	r15, r24
    13a4:	82 95       	swap	r24
    13a6:	8f 70       	andi	r24, 0x0F	; 15
    13a8:	0e 94 20 08 	call	0x1040
    13ac:	8f 2d       	mov	r24, r15
    13ae:	8f 70       	andi	r24, 0x0F	; 15
    13b0:	0e 94 20 08 	call	0x1040
    13b4:	8e 2d       	mov	r24, r14
    13b6:	82 95       	swap	r24
    13b8:	8f 70       	andi	r24, 0x0F	; 15
    13ba:	0e 94 20 08 	call	0x1040
    13be:	8e 2d       	mov	r24, r14
    13c0:	8f 70       	andi	r24, 0x0F	; 15
    13c2:	0e 94 20 08 	call	0x1040
    13c6:	1f 91       	pop	r17
    13c8:	ff 90       	pop	r15
    13ca:	ef 90       	pop	r14
    13cc:	08 95       	ret

000013ce <init_tp>:
//- INIT ROUTINES
//----------------------------------------------------------------

inline void init_tp(){
	sbi(DDRB, 1);
    13ce:	21 9a       	sbi	0x04, 1	; 4
	sbi(DDRD, 5);
    13d0:	55 9a       	sbi	0x0a, 5	; 10
	sbi(DDRD, 6);	
    13d2:	56 9a       	sbi	0x0a, 6	; 10
    13d4:	08 95       	ret

000013d6 <tpl>:
}

//----------------------------------------------------------------
//- COMMAND ROUTINES
//----------------------------------------------------------------

//Test Point LED (D_IRISU)
inline void tpl(uint8_t cmd){
	switch(cmd){
    13d6:	99 27       	eor	r25, r25
    13d8:	82 30       	cpi	r24, 0x02	; 2
    13da:	91 05       	cpc	r25, r1
    13dc:	69 f0       	breq	.+26     	; 0x13f8
    13de:	83 30       	cpi	r24, 0x03	; 3
    13e0:	91 05       	cpc	r25, r1
    13e2:	1c f4       	brge	.+6      	; 0x13ea
    13e4:	01 97       	sbiw	r24, 0x01	; 1
    13e6:	51 f0       	breq	.+20     	; 0x13fc
    13e8:	08 95       	ret
    13ea:	03 97       	sbiw	r24, 0x03	; 3
    13ec:	e9 f7       	brne	.-6      	; 0x13e8
		case ON:
			sbi(PORTB, 1);
			break;
		case OFF:
			cbi(PORTB, 1);
			break;
		case TOGGLE:
			tbi(PORTB, 1);
    13ee:	85 b1       	in	r24, 0x05	; 5
    13f0:	92 e0       	ldi	r25, 0x02	; 2
    13f2:	89 27       	eor	r24, r25
    13f4:	85 b9       	out	0x05, r24	; 5
    13f6:	08 95       	ret
    13f8:	29 98       	cbi	0x05, 1	; 5
    13fa:	08 95       	ret
    13fc:	29 9a       	sbi	0x05, 1	; 5
    13fe:	08 95       	ret
    1400:	08 95       	ret

00001402 <tp4>:
			break;
		default:
			break;
	}
}

//Test Point 4
inline void tp4(uint8_t cmd){
	switch(cmd){
    1402:	99 27       	eor	r25, r25
    1404:	82 30       	cpi	r24, 0x02	; 2
    1406:	91 05       	cpc	r25, r1
    1408:	69 f0       	breq	.+26     	; 0x1424
    140a:	83 30       	cpi	r24, 0x03	; 3
    140c:	91 05       	cpc	r25, r1
    140e:	1c f4       	brge	.+6      	; 0x1416
    1410:	01 97       	sbiw	r24, 0x01	; 1
    1412:	51 f0       	breq	.+20     	; 0x1428
    1414:	08 95       	ret
    1416:	03 97       	sbiw	r24, 0x03	; 3
    1418:	e9 f7       	brne	.-6      	; 0x1414
		case ON:
			sbi(PORTD, 5);
			break;
		case OFF:
			cbi(PORTD, 5);
			break;
		case TOGGLE:
			tbi(PORTD, 5);
    141a:	8b b1       	in	r24, 0x0b	; 11
    141c:	90 e2       	ldi	r25, 0x20	; 32
    141e:	89 27       	eor	r24, r25
    1420:	8b b9       	out	0x0b, r24	; 11
    1422:	08 95       	ret
    1424:	5d 98       	cbi	0x0b, 5	; 11
    1426:	08 95       	ret
    1428:	5d 9a       	sbi	0x0b, 5	; 11
    142a:	08 95       	ret
    142c:	08 95       	ret

0000142e <tp5>:
			break;
		default:
			break;
	}
}

//Test Point 5
inline void tp5(uint8_t cmd){
	switch(cmd){
    142e:	99 27       	eor	r25, r25
    1430:	82 30       	cpi	r24, 0x02	; 2
    1432:	91 05       	cpc	r25, r1
    1434:	69 f0       	breq	.+26     	; 0x1450
    1436:	83 30       	cpi	r24, 0x03	; 3
    1438:	91 05       	cpc	r25, r1
    143a:	1c f4       	brge	.+6      	; 0x1442
    143c:	01 97       	sbiw	r24, 0x01	; 1
    143e:	51 f0       	breq	.+20     	; 0x1454
    1440:	08 95       	ret
    1442:	03 97       	sbiw	r24, 0x03	; 3
    1444:	e9 f7       	brne	.-6      	; 0x1440
		case ON:
			sbi(PORTD, 6);
			break;
		case OFF:
			cbi(PORTD, 6);
			break;
		case TOGGLE:
			tbi(PORTD, 6);
    1446:	8b b1       	in	r24, 0x0b	; 11
    1448:	90 e4       	ldi	r25, 0x40	; 64
    144a:	89 27       	eor	r24, r25
    144c:	8b b9       	out	0x0b, r24	; 11
    144e:	08 95       	ret
    1450:	5e 98       	cbi	0x0b, 6	; 11
    1452:	08 95       	ret
    1454:	5e 9a       	sbi	0x0b, 6	; 11
    1456:	08 95       	ret
    1458:	08 95       	ret
