#ifndef _FUNC_TYPES_H_
#define _FUNC_TYPES_H_

/** @return int8_t
 *  @arg0   uint8_t
 *  @arg1   uint8_t
 *  @arg2   uint8_t*
 *  @arg3   uint8_t
 *  @arg4   uint8_t
 */
typedef int8_t (*func_ri8u8u8u8ptru8u8_t) (func_cb_ptr proto, uint8_t arg0, uint8_t arg1, uint8_t* arg2, uint8_t arg3, uint8_t arg4);

/** @return int8_t
 *  @arg0   uint8_t
 *  @arg1   uint8_t
 *  @arg2   uint8_t
 */
typedef int8_t (*func_ri8u8u8u8_t) (func_cb_ptr proto, uint8_t arg0, uint8_t arg1, uint8_t arg2);

/** @return int8_t
 *  @arg0   uint8_t
 */
typedef int8_t (*func_ri8u8_t)(func_cb_ptr proto, uint8_t arg0);

#endif 
