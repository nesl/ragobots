#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/signal.h>
#include "jonathan.h"
#include "uart0.h"
#include "ircomm_l.h"
#include "tp.h"
#include "i2c.h"

uint8_t usrt_rx_buffer[2];
uint8_t usrt_rx_count;

//==================================
//= IRIS LOWER PROCESSOR
//==================================

void init_serial(uint8_t mode){
	switch (mode){
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
			UCSR0C=B8(01000110);//SYNCHRONOUS (but ignore clock line because less error at BRG); N,8-bit data,1 frame format
			UBRR0H = 0;
			UBRR0L = 68; //115.2k bps from 16MHz clock
			sbi(DDRD,1); //TXD is output pin (data line)
			cbi(DDRD,4); //XCK is not used so make input (with pull-up) for safety (USRT clock line)
			sbi(PORTD, 4);
			UCSR0B=0x08;//No Rx; TX enabled - last line because operation begins on this flag
			break;
	}
}

//dataA is sent first
//this function built for speed, no safety checking. UART shift and buffer registers should be empty.
//The first write falls through to the actual output register freeing the buffer for byte 2.
void inline USRT_send_2bytes(unsigned char dataA, unsigned char dataB){
	// XXX
	UDR0 = dataA;
	UDR0 = dataB;
	/*
	//DEBUG code to test the buffer ready for new data flag
	if(UCSR0A & B8(00100000)){ //true != 0, freeze on buffer avail
		stk_ledon(0xAA);
		while(1);
	}
	*/
}

void inline send_byte_serial(unsigned char dataB){
	while ((UCSR0A & _BV(5)) != B8(00100000));
	UDR0 = dataB;
}

void inline uart0_force_byte(unsigned char dataB){
	UDR0 = dataB;
}

//Most Significant Bit first
void UART_send_BIN4(uint8_t lowb){
	switch(lowb){
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
	send_byte_serial('b');
	UART_send_BIN4(lowb>>4);
	UART_send_BIN4(lowb & 0x0F);
}
	
void UART_send_HEX4(uint8_t lowb){
	switch(lowb){
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
	UART_send_HEX4(lowb>>4);
	UART_send_HEX4(lowb & 0x0F);
}

void UART_send_HEX16b(uint8_t highb, uint8_t lowb){
	UART_send_HEX8(highb);
	UART_send_HEX8(lowb);
}

void UART_send_HEX16(uint16_t highb){
	uint8_t blah;
	blah = (uint8_t)(highb>>8);
	UART_send_HEX8(blah);
	blah = (uint8_t)(highb & 0x00FF);
	UART_send_HEX8(blah);
}

inline void USRT_VIA_I2C(void){
	if ((usrt_rx_buffer[0] != 0x00) || (usrt_rx_buffer[1] != 0x00)){
		i2c_enqueue(usrt_rx_buffer[0]);
		i2c_enqueue(usrt_rx_buffer[1]);	
	}
}

//Handle this event but immediately re-enable the interrupt so 
//	that we don't kill other real-time stuff like the data transmit encoder
SIGNAL(SIG_USART_RECV){

	if (usrt_rx_count > 0){
		usrt_rx_buffer[1] = UDR0;
		usrt_rx_count = 0; //reset
		
		//USRT_VIA_I2C(); //xxx
		
		sei(); //re-enable interrupts since we aren't data sensitive anymore
		USRT_DATA_RX_ISR(usrt_rx_buffer[0], usrt_rx_buffer[1]);
	}
	else {
		usrt_rx_count++;
		usrt_rx_buffer[0] = UDR0;
	}
}
