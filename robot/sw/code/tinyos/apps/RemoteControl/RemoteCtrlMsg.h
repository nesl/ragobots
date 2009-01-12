enum {
    AM_REMOTECTRLMSG = 58
};

typedef enum {
    MOVEFORWARD,
    MOVEBACKWARD,
    TURNCLOCKWISE,
    TURNCOUNTERCLOCKWISE,
    STOP
}MoveTurn;

typedef struct RemoteCtrlMsg {
    uint8_t RobotID;
    MoveTurn movement;
    uint8_t amount;
};


