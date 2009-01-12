#ifndef __RUN_KALMAN_H__
#define __RUN_KALMAN_H__
int run_kalman(SCAATState *out,
	KalmanBuffer *buffer, int n, SCAATState *in, double timestamp, double var);

#endif