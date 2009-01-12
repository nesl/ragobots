
//toggle bit
#ifndef tbi
#define tbi(sfr, bit) (_SFR_BYTE(sfr) ^= _BV(bit))
#endif 

//set bit 
#ifndef sbi
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
#endif

//clear bit
#ifndef cbi
#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#endif 

#ifndef outb
#define outb(addr, data)        outp(data, addr)
#endif

#ifndef inb
#define inb(addr)                       inp(addr)
#endif

#ifndef outp
#define outp(data, addr)        addr = data;
#endif

#ifndef inp
#define inp(addr)                       addr;
#endif
