#include "eeprom1.h"

void eeprom_write(uint16_t addr, uint8_t* data, uint8_t length)
{
  int i;
  HAS_CRITICAL_SECTION;
  if (length == 0) 
    return;

  for (i = 0; i < length; i+=1)
    {
      while (EECR & (1<<EEPE));
      EEAR = addr + i;
      //EEARH = 0x00;
      //EEARL = (uint8_t) addr + i;
      EEDR = data[i];
      ENTER_CRITICAL_SECTION();
      //write one to EEMPE to initiate write
      EECR |= (1<<EEMPE);
      //within 4 clock cycles after setting EEMPE, write one to EEPE
      EECR |= (1<<EEPE);
      LEAVE_CRITICAL_SECTION();
    }
}

void eeprom_read(uint16_t addr, uint8_t* data, uint8_t length)
{
  int i;

  if (length == 0) 
    return;

  while (EECR & (1<<EEPE));
 
  for (i = 0; i < length; i+=1)
    {
      EEAR = addr + i;
      EECR |= (1<<EERE);
      data[i] = EEDR;
    }
}
