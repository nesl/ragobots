#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/signal.h>
#include "utilities.h"

void init_serial(){
	// USART initialization
	// Communication Parameters: 8 Data, 1 Stop, No Parity
	// USART Receiver: On
	// USART Transmitter: On
	// USART0 Mode: Asynchronous
	// USART Baud rate: 38400 (Double Speed Mode)
	UCSR0A=0x02;
	UCSR0B=0x18;
	UCSR0C=0x06;
	UBRR0H=0x00;
	UBRR0L=25;	 //24 is a tweak from 25-default
	sbi(DDRD,1); //TXD is output pin
}

void inline send_byte_serial(unsigned char dataB){
	while ((UCSR0A & _BV(5)) != B8(00100000));
	UDR0 = dataB;
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
