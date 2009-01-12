#include <winsock.h>
#include <stdio.h>
#include <stdlib.h>
#include "Main.h"
#include "MoteCom.h"

void DieWithError(char *errorMessage)
{
    fprintf(stderr,"%s: %d\n", errorMessage, WSAGetLastError());
    exit(1);
}

int openSocket() {
  int sock;                        /* Socket descriptor */
  WSADATA wsaData;                 /* Structure for WinSock setup communication */
  struct sockaddr_in echoServAddr; /* Echo server address */

  if(WSAStartup(MAKEWORD(2, 0), &wsaData) != 0) /* Load Winsock 2.0 DLL */
  {
    fprintf(stderr, "WSAStartup() failed");
    exit(1);
  }

  /* Construct the server address structure */
  memset(&echoServAddr, 0, sizeof(echoServAddr));     /* Zero out structure */
  echoServAddr.sin_family      = AF_INET;             /* Internet address family */
  echoServAddr.sin_addr.s_addr = inet_addr("127.0.0.1");   /* Server IP address */
  echoServAddr.sin_port        = htons(MOTECOM_PORT_ADDR); /* Server port */

  /* Create a reliable, stream socket using TCP */
  if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
    DieWithError("socket() failed");

  /* Establish the connection to the echo server */
  if (connect(sock, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr)) < 0)
    DieWithError("connect() failed");

  printf("socket %d\n", sock);
  return sock;
}

void broadcastLocation(int sock, Location location[]) {
  uint16_t *ptr;
  uint8_t data[28];
  int i;

  //  writing into 'data' field of TOS_Msg
  for(i=0;i<NUM_TEAMS * NUM_RAGOBOTS_PER_TEAM;++i) {
	data[i * 7] = (uint8_t) (i + 1);
	ptr = (uint16_t*) (&(data[i * 7 + 1]));
	*ptr = location[i].x_pix;
	ptr = (uint16_t*) (&(data[i * 7 + 3]));
	*ptr = location[i].y_pix;
	ptr = (uint16_t*) (&(data[i * 7 + 5]));
	*ptr = location[i].orientation_deg;
  }

  /* Send the TOS_Msg to the server */
  if (send(sock, (char*) data, 28, 0) != 28)
    DieWithError("send() sent a different number of bytes than expected");
  else
	printf("data sent\n");

  return;
}