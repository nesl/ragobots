#include <avr/sfr_defs.h>
#include <avr/interrupt.h>

#include "utilities.h"

#undef EECR
#define EECR    _SFR_IO8 (0x1F)

#undef EEDR
#define EEDR    _SFR_IO8 (0x20)

#undef EEAR
#define EEAR    _SFR_IO16 (0x21)

#undef EEARL
#define EEARL   _SFR_IO8 (0x21)

#undef EEARH
#define EEARH   _SFR_IO8 (0x22)


#define EERE 0
#define EEPE 1
#define EEMPE 2
#define EERIE 3
#define EEPM0 4
#define EEPM1 5

void eeprom_write(uint16_t addr, uint8_t* data, uint8_t length);

void eeprom_read(uint16_t addr, uint8_t* data, uint8_t length);
