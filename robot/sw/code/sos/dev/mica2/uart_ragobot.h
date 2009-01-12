
/**
 * @brief header file for UART0
 * @auther Simon Han
 * 
 */

#ifndef _UART_RAGOBOT_H
#define _UART_RAGOBOT_H

#ifndef _MODULE_
#include <sos_types.h>

/**
 * init function
 */
extern void uart_init(void);

/**
 * Module API
 * Same as kernel api
 */

/**
 * @brief send data to uart
 * @param data data to be sent
 * @param len  data length
 * @param flag flag on data, only SOS_MSG_DYM_ALLOC is used
 * @return errno on fail or SOS_OK
 */
extern int8_t ker_serial_write(uint8_t pid, uint8_t port, uint8_t *data, uint8_t len, uint8_t flag);

extern int8_t ker_serial_read(uint8_t pid, uint8_t port, uint8_t len);
#endif /* _MODULE_ */

#endif
