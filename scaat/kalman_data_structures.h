#ifndef __KALMAN_DATA_STRUCTURES_H__
#define __KALMAN_DATA_STRUCTURES_H__

// we have 6 state variables
#define STATE_NUM 6

// this structure is actually defined in some other file
typedef struct KalmanBuffer_tag {
	double receiv_time;
	double timestamp;
	double range_meas;
	double s_x;
	double s_y;
}KalmanBuffer;

typedef struct SCAATState_tag {
	double *x;
	double **P;
	double latest_timestamp;
}SCAATState;

#endif
