#include <winsock.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
  #define INCR_DIST   100 
void calcAngle(unsigned short x, unsigned short y, unsigned short lx, unsigned short ly);
void DieWithError(char *errorMessage)
{
    fprintf(stderr,"%s: %d\n", errorMessage, WSAGetLastError());
    exit(1);
}

void main() {
  int sock;                        /* Socket descriptor */
  struct sockaddr_in echoServAddr; /* Echo server address */
  WSADATA wsaData;                 /* Structure for WinSock setup communication */
  int bytesRecv = SOCKET_ERROR;
  char sendbuf[32] = "Client: Sending data.";
  char recvbuf[32] = "";
	calcAngle(20, 20, 279, 105);
  if(WSAStartup(MAKEWORD(2, 0), &wsaData) != 0) /* Load Winsock 2.0 DLL */
    {
      fprintf(stderr, "WSAStartup() failed");
      exit(1);
    }

  /* Create a reliable, stream socket using TCP */
  if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
    DieWithError("socket() failed");

  /* Construct the server address structure */
  memset(&echoServAddr, 0, sizeof(echoServAddr));     /* Zero out structure */
  echoServAddr.sin_family      = AF_INET;             /* Internet address family */
  echoServAddr.sin_addr.s_addr = inet_addr("127.0.0.1");   /* Server IP address */
  echoServAddr.sin_port        = htons(9001); /* Server port */
  /* Establish the connection to the echo server */
  if (connect(sock, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr)) < 0)
    DieWithError("connect() failed");

  /* Send the TOS_Msg to the server */
/*  if (send(sock, (char*) msg, sizeof(TOS_Msg), 0) != sizeof(TOS_Msg))
    DieWithError("send() sent a different number of bytes than expected");*/
  while( bytesRecv == SOCKET_ERROR ) {
	bytesRecv = recv(sock, recvbuf, 32, 0 );
  if ( bytesRecv == 0 || bytesRecv == WSAECONNRESET ) {
		printf( "Connection Closed.\n");
		break;
	}
	if (bytesRecv < 0)
		return;
	printf( "Bytes Recv: %d\n", bytesRecv );
  }
bytesRecv = recv(sock, recvbuf, 32, 0 );

}
  float mod(float d)
  {
    if(d<0) return -1 *d;
    else return d;
  }

void calcAngle( short x, short y, short lx, short ly){

	short d_x, d_y;
    float hyp,angle;
    if(lx == 0 && ly ==0) 
    {
	return;
    }
    d_x = x - lx;
    d_y = y - ly; 
    hyp = (float) sqrt((float) (d_x * d_x + d_y*d_y));
    hyp = mod(hyp);

     if(mod(d_x) < mod(d_y))
    {
	angle = (float) asin((float) d_y/hyp);
	angle = angle * (180/3.14);
	if(x < lx)
	  angle = 180 - angle;
	if(angle < 0)
	  angle = 360 + angle;
    }
    else
    {
	angle = acos((float) d_x/hyp);
	//	testAngle((uint16_t ) angle);
	angle = angle * (180/3.14);
	if(y<ly)
	  angle = 360 - angle;
    }

      return;

}
/*void calculateCRC(uint8_t bl, uint16_t* ax) {
  uint16_t dx;
  uint8_t *al = (uint8_t *)ax;
  uint8_t *ah = al+1;
  uint8_t *dl = (uint8_t *)&dx;
  uint8_t *dh = dl+1;
  uint8_t tmp;
  tmp = *al;
  *al = *ah;
  *ah = tmp;
  dx = *ax;
  *dl = *al ^ bl;
  *dl = *dl ^ (*dl / 16);
  *ah = *dl * 16;
  *dh = *dh ^ *ah;
  *al = *dl;
  *ah = 0;
  *ax *= 32;
  *ax = *ax ^ dx;
}*/ /* Calc_CRC */

