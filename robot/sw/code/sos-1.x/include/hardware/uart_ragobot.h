#ifndef _UART_RAGOBOT_H
#define _UART_RAGOBOT_H

enum {
/**
 * @brief send data to uart
 * @param data data to be sent
 * @param len  data length
 * @param flag flag on data, only SOS_MSG_DYM_ALLOC is used
 * @return errno on fail or SOS_OK
 */
  UART_WRITE_FID,
  
  UART_READ_FID
};

/*
#define uart0_checkerror()          (UCSR0A & 0x18)
#define uart0_getbyte()             UDR0
#define uart0_setbyte(b)            UDR0 = (b)
#define uart0_recv_interrupt()      SIGNAL(SIG_UART0_RECV)
#define uart0_send_interrupt()      SIGNAL (SIG_UART0_DATA)
#define uart0_disable_recv()        UCSR0B &= ((unsigned char)~(1<<(RXCIE)))
#define uart0_enable_recv()         UCSR0B |= (1<<(RXCIE))
#define uart0_disable_send()        UCSR0B &= ((unsigned char)~(1<<(UDRIE)))
#define uart0_enable_send()         UCSR0B |= (1<<(UDRIE))
#define uart0_is_disabled()         ((UCSR0B & (1 << UDRIE)) == 0)
*/

#define uart1_checkerror()          (UCSR1A & 0x18)
#define uart1_getbyte()             UDR1
#define uart1_setbyte(b)            UDR1 = (b)
#define uart1_recv_interrupt()      SIGNAL(SIG_UART1_RECV)
#define uart1_send_interrupt()      SIGNAL (SIG_UART1_DATA)
#define uart1_disable_recv()        UCSR1B &= ((unsigned char)~(1<<(RXCIE)))
#define uart1_enable_recv()         UCSR1B |= (1<<(RXCIE))
#define uart1_disable_send()        UCSR1B &= ((unsigned char)~(1<<(UDRIE)))
#define uart1_enable_send()         UCSR1B |= (1<<(UDRIE))
#define uart1_is_disabled()         ((UCSR1B & (1 << UDRIE)) == 0)

#ifndef _MODULE_
mod_header_ptr uart_get_header();
#endif

#endif
