
#include "tcp.h"

int get_host_ip_addr(unsigned long *ipAddr)
{
	char hostname[32], **p;
	struct hostent *hostInfo;
	struct in_addr in;

	if(gethostname(hostname,32))
	{
		printf("gethostname returned error\n");
		return -1;
	}

	if((hostInfo = gethostbyname(hostname)) == NULL)
	{
		printf("gethostbyname returned error\n");
		return -1;
	}
	printf("hostname %s\n",hostname);

	for(p = hostInfo->h_addr_list;*p != 0;p++)
	{
		memcpy(&in.s_addr, *p, sizeof(in.s_addr));
		break;
	}

	if((*ipAddr = inet_addr(inet_ntoa(in))) == -1)
	{
		printf("inet_addr returned error\n");
		return -1;
	}

	return 1;
}

int open_tcp_socket(int *sock_fd,int port )
{
	struct sockaddr_in me;
	unsigned long ipAddr;

	if(get_host_ip_addr(&ipAddr) == -1)
	{
		printf("get_host_ip_addr returned error\n");
		return -1;
	}

	*sock_fd = socket(AF_INET,SOCK_STREAM,0);
	if(*sock_fd == -1)
	{
		printf("socket creation returned an error\n");
		return -1;
	}

	bzero(&me,sizeof(struct sockaddr_in));
	me.sin_family = AF_INET;
	me.sin_port = htons(port);
	me.sin_addr.s_addr = ipAddr;
	
	if(connect(*sock_fd,(struct sockaddr *)&me,sizeof(struct sockaddr))==-1)
	{
		printf("Could not connect to server\n");
		return -1;
	}
	return 1;
}

TARGET_INFO * get_target_info(VOR_MSG *msg)
{
	int i;
	for(i=0;i<MAX_MOBILES;i++) {
		if(msg->from_Id == target_arr[i].Id)
			return &target_arr[i];
	}
	
	return NULL;	

}

TARGET_INFO * create_target_info(VOR_MSG *msg)
{
	int i=0;
	struct timeval tm;

	gettimeofday(&tm,NULL);

	for(i=0;i<MAX_MOBILES;i++) {
		if(target_arr[i].Id == -1) break;
	}

	if(i == MAX_MOBILES) return NULL;

	target_arr[i].Id = msg->from_Id;
	target_arr[i].init_x = msg->pos_x;
	target_arr[i].init_y = msg->pos_y;
	target_arr[i].curr_x = msg->pos_x;
	target_arr[i].curr_y = msg->pos_y;
	target_arr[i].s_x = msg->s_x;
	target_arr[i].s_y = msg->s_y;
	target_arr[i].angle = msg->angle;
	target_arr[i].dt = tm.tv_sec;

	return &target_arr[i];
}

int check_msg_validity(TARGET_INFO *info,VOR_MSG *msg)
{
	if((info->s_x == msg->s_x) ||
	   (info->s_y == msg->s_y))
		return -1;

	return 1;
}

int request_scaat_prediction(TARGET_INFO *info)
{
	struct timeval tm;
	STORAGE_TYPE s_x = (double )info->s_x;
	STORAGE_TYPE s_y = (double )info->s_y;
	STORAGE_TYPE dt ;
	STORAGE_TYPE q = 2.1; //Noise
	STORAGE_TYPE R= 2.1; //Noise
	STORAGE_TYPE init_x = (double )info->curr_x;
	STORAGE_TYPE init_y = (double )info->curr_y;
	STORAGE_TYPE z  = (double)info->angle * (22/7)/180 + sqrt(R);;

	gettimeofday(&tm,NULL);
	dt = (double)(tm.tv_sec - info->dt);
	lob_scaat(&info->out, z,  s_x,  s_y,  dt, &info->in, q, R);
	info->in.x = info->out.x;
	info->in.P = info->out.P;
	info->curr_x = info->out.x[1];
	info->curr_y = info->out.x[2];
	info->dt = tm.tv_sec;

	return 1;
}

int intialize_kalman_buffers(TARGET_INFO *info )
{
	info->in.x = dvector(1, STATE_NUM);
	info->in.P = dmatrix_alloc(STATE_NUM, STATE_NUM);
	info->in.latest_timestamp = 0.0;
	info->out.x = dvector(1, STATE_NUM);
	info->out.P = dmatrix_alloc(STATE_NUM,STATE_NUM);
	info->out.latest_timestamp = 0.0;
}

int free_kalman_buffers(TARGET_INFO *info)
{
	free_dvector(info->out.x, 1, STATE_NUM);
	free_dmatrix(info->out.P, 1, STATE_NUM, 1, STATE_NUM);

	free_dvector(info->in.x, 1, STATE_NUM);
	free_dmatrix(info->in.P, 1, STATE_NUM, 1, STATE_NUM);
	return 1;
}

int send_response(TARGET_INFO *info)
{
	VOR_MSG msg;
	char buf[sizeof(VOR_MSG)];

 	msg.hdr_1 = 0xff;	
 	msg.hdr_2 = 0xff;	
 	msg.hdr_3 = 0x05;	
 	msg.hdr_4 = 0x7d;	
 	msg.hdr_5 = 0x09;	
	msg.from_Id = MY_NODE_ID;
  	msg.to_Id = info->Id;
	msg.pos_x = info->curr_x;
	msg.pos_y = info->curr_y;
  	msg.msg_type = VOR_MSG_RES_PREDICTION;
  	msg.elapsed_time = 0;
  	msg.angle = 0;
  	msg.s_x = info->s_x;
  	msg.s_y = info->s_y;

	bcopy(msg,buf,sizeof(VOR_MSG));
	if(send(sock_fd,buf, sizeof(VOR_MSG), 0) == -1)
	{
		printf("send failed\n");
	}

	
	return 1;
}

int handle_msg_from_mobile(VOR_MSG *msg)
{

	TARGET_INFO *info =	get_target_info(msg);

	if(info == NULL)
	{
		info = create_target_info(msg);
		if(info == NULL) {
			printf("Could not create info structure for target %d\n",msg->from_Id);
			return -1;
		}
		intialize_kalman_buffers(info);
		return 1;
	}

	if(msg->msg_type == VOR_MSG_REQ_PREDICTION)
	if(check_msg_validity(info,msg))
	{
		info->s_x = msg->s_x;
		info->s_y = msg->s_y;
		info->angle = msg->angle;
		info->dt = msg->elapsed_time;
		request_scaat_prediction(info);

		send_response(info);
	}

	return 1;
}

int handle_recv_buffer(int sock_fd)
{
	int i,numbytes;
	unsigned char buf[MAXDATASIZE];
	VOR_MSG *msg;

	buf[0]=0x00;
	numbytes=recv(sock_fd, buf, MAXDATASIZE-1, 0);	

	if(numbytes <=0)
	  return -1;
	if(buf[0] !=0xff)
	  return -1;

	  putchar('\n');

	 msg = (VOR_MSG *) buf;

     switch(msg->from_Id) {
	  case TRANSMITTER_1:
	   break;
	  case TRANSMITTER_2:
	    if(msg->msg_type == VOR_MSG_START)
	     printf("----NODE %02x START--->\n",msg->from_Id);
	   else
	    printf("<-----NODE %02x END-----\n",msg->from_Id);
	  	break;
	  case MOBILE_AGENT1:
		if(msg->msg_type == VOR_MSG_REQ_PREDICTION)
		{
			printf("----NODE %02x REQ_PREDICTION--->\n",msg->from_Id);
			handle_msg_from_mobile(msg);
		}
		break;	
	  default:
	   printf("Unknown message %02x\n",buf[5]);
	   break;
	}  

      for(i=0;i<numbytes;i++)
	    printf("%02x ",buf[i]);
	  putchar('\n');

	return 1;
}

void init_server()
{
	int  i=0;

	for(i=0;i<MAX_MOBILES;i++)
		target_arr[i].Id = -1;

}

void clean_exit()
{
	int i;
	
	close(sock_fd);

	for(i=0;i<MAX_MOBILES;i++) {
		if(target_arr[i].Id = -1)
			return;
		free_kalman_buffers(&target_arr[i]);
	}

	return;
}

int main(int argc, char *argv[])
{
	int retval;
	fd_set ReadId;

	if(argc !=2)
	{
		printf(" usage\n tcp <port>\n");
		return;
	}

	init_server();

	retval = open_tcp_socket(&sock_fd,atoi(argv[1]));
	if(retval == -1)
	{
		printf("Error opening tcp socket\n");
		return;
	}
	
	FD_ZERO(&ReadId);
	while(1)
	{
		int retval;
	
		FD_SET(sock_fd,&ReadId);
		retval = select(sock_fd+1,&ReadId,NULL,NULL,NULL);

		if(FD_ISSET(sock_fd,&ReadId))
		{
			handle_recv_buffer(sock_fd);
		}

	}

	clean_exit();

	return 1;
}

