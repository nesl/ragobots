

typedef enum {
   VOR_IDLE=0,
   VOR_START,
   VOR_ONGOING,
   VOR_END,
   OTHER_NODE_VOR,
   VOR_ABORT
}E_STATE;

typedef enum {
   VOR_MSG_IDLE=0,
   VOR_MSG_START,
   VOR_MSG_END,
   VOR_MSG_REQ_PREDICTION,
   VOR_MSG_RES_PREDICTION, //PREDICTION RESPONSE
   VOR_MSG_ABORT
}EMSG_TYPE;


typedef struct {
   uint8_t from_Id;
   uint8_t to_Id;
   int8_t pos_x;
   int8_t pos_y;
   EMSG_TYPE msg_type;
   uint8_t elapsed_time; // in milli seconds
   uint8_t angle;
   int8_t s_x;
   int8_t s_y;
}VOR_MSG ;
