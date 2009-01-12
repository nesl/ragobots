#ifndef __uart0_h
#define __uart0_h
	void init_serial();
	void inline USRT_send_2bytes(unsigned char dataA, unsigned char dataB);
	void inline send_byte_serial(unsigned char dataB);
	void UART_send_HEX8(uint8_t lowb);
	void UART_send_HEX16b(uint8_t highb, uint8_t lowb);
	void UART_send_HEX16(uint16_t highb);
#endif
