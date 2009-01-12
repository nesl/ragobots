#ifndef __TCP_H___
#define __TCP_H___

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdio.h>
#include <math.h>

#include "nrutil.h"
#include "kalman_data_structures.h"


#define uint8_t unsigned char
#define int8_t char
#define STORAGE_TYPE double

#define MAXDATASIZE  15// max number of bytes we can get at once 
#define MY_NODE_ID 0
#define TRANSMITTER_1 1
#define TRANSMITTER_2 2
#define MOBILE_AGENT1 5
#define MAX_MOBILES 10

int sock_fd ;

extern STORAGE_TYPE ** dmatrix_alloc(int rows,int cols);

typedef struct {
	int8_t Id;
	int8_t init_x;
	int8_t init_y;
	int8_t curr_x;
	int8_t curr_y;
	int angle;
	int8_t s_x;
	int8_t s_y;
	long dt;
	SCAATState in;
	SCAATState out;
} TARGET_INFO;

TARGET_INFO target_arr[MAX_MOBILES];

typedef enum {
   VOR_MSG_IDLE=0,
   VOR_MSG_START,
   VOR_MSG_END,
   VOR_MSG_REQ_PREDICTION,
   VOR_MSG_RES_PREDICTION, //PREDICTION RESPONSE
   VOR_MSG_ABORT
}EMSG_TYPE;


typedef struct {
   uint8_t hdr_1;
   uint8_t hdr_2;
   uint8_t hdr_3;
   uint8_t hdr_4;
   uint8_t hdr_5;
   uint8_t from_Id;
   uint8_t to_Id;
   int8_t pos_x;
   int8_t pos_y;
   uint8_t msg_type;
   uint8_t elapsed_time; // in milli seconds
   int8_t angle;
   int8_t s_x;
   int8_t s_y;
}VOR_MSG ;

#endif
