#include <stdio.h>
#include <string.h>
#include <math.h>
#include "nrutil.h"
#include "kalman_data_structures.h"

//vlasios
#define STORAGE_TYPE double
#define FREE_FUNCTION free_dvector

int main(){
	SCAATState in;
	SCAATState out;
	KalmanBuffer buffer;
	STORAGE_TYPE timestamp=0.0;
	STORAGE_TYPE var=0.0;


	in.x = dvector(1, STATE_NUM);
	in.P = dmatrix(1, STATE_NUM, 1, STATE_NUM);
	in.latest_timestamp = 0.0;
	out.x = dvector(1, STATE_NUM);
	out.P = dmatrix(1, STATE_NUM, 1, STATE_NUM);
	out.latest_timestamp = 0.0;


	// here you invoke lob_scaat


	free_dvector(out.x, 1, STATE_NUM);
	free_dmatrix(out.P, 1, STATE_NUM, 1, STATE_NUM);

	free_dvector(in.x, 1, STATE_NUM);
	free_dmatrix(in.P, 1, STATE_NUM, 1, STATE_NUM);
	return(0);
}

