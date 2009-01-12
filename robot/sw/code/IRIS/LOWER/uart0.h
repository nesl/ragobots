#ifndef __uart0_h
	#define __uart0_h
	
	#define UART 		12
	#define DEBUG_MODE	12
	#define USRT		13
	#define RUN_MODE	13
	
	void init_serial(uint8_t blah);
	void inline USRT_send_2bytes(unsigned char dataA, unsigned char dataB);
	void inline send_byte_serial(unsigned char dataB);
	void inline uart0_force_byte(unsigned char dataB);
	void UART_send_HEX8(uint8_t lowb);
	void UART_send_HEX16b(uint8_t highb, uint8_t lowb);
	void UART_send_HEX16(uint16_t highb);
	void UART_send_BIN8(uint8_t tosend);
#endif
