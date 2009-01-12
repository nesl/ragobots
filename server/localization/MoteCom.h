#ifndef MOTECOM_H
#define MOTECOM_H

#define MOTECOM_IP_ADDR "127.0.0.1"
#define MOTECOM_PORT_ADDR 9002

#define TOSH_DATA_LENGTH 29

// As defined in nesC
typedef unsigned char uint8_t; // same as byte
typedef unsigned short uint16_t; // same as word

// Packet format in tinyos
typedef struct TOS_Msg
{
  /* The following fields are transmitted/received on the radio. */
  uint16_t addr;
  uint8_t type;
  uint8_t group;
  uint8_t length;
  uint8_t data[TOSH_DATA_LENGTH];
  uint16_t crc;
} TOS_Msg;

typedef struct Location {
  uint16_t x_pix;
  uint16_t y_pix;
  uint16_t orientation_deg;
} Location;

enum {
  TOS_BCAST_ADDR = 0xffff,
  TOS_UART_ADDR = 0x007e,
};

// Opens a TCP socket
int openSocket();

// Generates the tinyos packet
void broadcastLocation(int sock, Location location[]);

// Calculates CRC of tinyos packet
// Function is called for each byte
// 'ax' is initialized to 0xFFFF
// When all byte have been checked, 'ax' must be inverted
//void calculateCRC(uint8_t bl, uint16_t* ax);

#endif