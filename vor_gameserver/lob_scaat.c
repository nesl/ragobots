//%SCAAT does the Extended Kalman filtering on given data
//%Input: recorded distance, sensor location, seconds elapsed since the last estimate,
//%       prior position, velocity, and acceleration, prior P error covariance marix
//%Output: optimal position, velocity, and acceleration obtained, updated P error covariance marix
//function [opt_x, opt_P]=SCAAT(z, a, b, dt, pre_x, pre_P, R)
//%global u;
//Predict=struct('x',[],'y',[]);   %Used to store the predicted result;

#include <stdio.h>
#include <math.h>
#include "kalman_data_structures.h"
#include "nrutil.h"
#include "mat_ops.h"

//vlasios
#define STORAGE_TYPE double
#define FREE_VECTOR_FUNCTION free_dvector
#define FREE_MATRIX_FUNCTION free_dmatrix
#define VECTOR dvector
#define MATRIX dmatrix

#ifndef PI
#define PI 3.14159265358979
#endif

extern void jacobi(STORAGE_TYPE **a, int n, STORAGE_TYPE d[],
				   STORAGE_TYPE **v, int *nrot);
extern void ludcmp(STORAGE_TYPE **a, int n, int *indx, STORAGE_TYPE *d);
extern void lubksb(STORAGE_TYPE **a, int n, int *indx, STORAGE_TYPE b[]);
extern STORAGE_TYPE ** dmatrix_alloc(int rows,int cols);

/*
% LOB_SCAAT implements the Single Constraint At A Time (SCAAT) filter for 
%           fusing the different LOBs from different sensor nodes. 
% Inputs: 
%    z         : LOB measurement from sensor at (s_x, s_y)  (1x1)
%    (s_x, s_y): sensor location ((1x1), (1x1))
%    dt        : Time passed since last target state update (1x1)
%    pre_x     : previous target state (6x1)
%    pre_P     : previous state covariance matrix (6x6)
%    q         : state error variance (1x1)
%    R         : measurement error covariance matrix (m=1)x(m=1)
% assume that 0<=z<2*pi 

% Outputs: 
%    opt_x     : new target state
%    opt_P     : new state covariance matrix
% This file was based on the range SCAAT filter that was developed
% by Delbert. Delbert had some mistakes and unsubstantiated additions
% to the filter formulation that we don't follow for this filter. 

function [opt_x, opt_P]=lob_scaat(z, s_x, s_y, dt, pre_x, pre_P, q, R)

*/

int lob_scaat(SCAATState *out,
		STORAGE_TYPE z, STORAGE_TYPE s_x, STORAGE_TYPE s_y, STORAGE_TYPE dt,
		SCAATState *in,
		STORAGE_TYPE q, STORAGE_TYPE R){

	STORAGE_TYPE **A;
	STORAGE_TYPE **Q;
	STORAGE_TYPE **Q1; // temporary matrix
	STORAGE_TYPE opt_z=0.0;
	STORAGE_TYPE *H;
	STORAGE_TYPE *K; //Kalman gain
	STORAGE_TYPE **I; //unit matrix

	STORAGE_TYPE **v; // for the eigenvectors
	int    *nrot; // for the Jacobi method of eigenvalue computation
	STORAGE_TYPE *d;

	SCAATState pred; // prediction

	int i, j;
	int add_noise = 0;

	// section for temporary variables
	STORAGE_TYPE *t_v1; // vector

	STORAGE_TYPE **t_m1; // matrix
	STORAGE_TYPE **t_m2; // matrix
	STORAGE_TYPE **t_m3; // matrix

	STORAGE_TYPE t_s; //temporary scalar value
	STORAGE_TYPE temp_sum = 0.0;
	STORAGE_TYPE min_d = 0.0;


	// program start
	//A=[1 0 dt  0 dt*dt/2       0
	//   0 1  0 dt       0 dt*dt/2
	//   0 0  1  0      dt       0
	//   0 0  0  1       0      dt
	//   0 0  0  0       1       0
	//   0 0  0  0       0       1];

	pred.x = VECTOR(1, STATE_NUM);
	//pred.P = MATRIX(1, STATE_NUM, 1, STATE_NUM);
	pred.P = dmatrix_alloc(STATE_NUM,STATE_NUM);

	t_v1 = VECTOR(1, STATE_NUM);
	//t_m1 = MATRIX(1, STATE_NUM, 1, STATE_NUM);
	//t_m2 = MATRIX(1, STATE_NUM, 1, STATE_NUM);
	//t_m3 = MATRIX(1, STATE_NUM, 1, STATE_NUM);

	t_m1 = dmatrix_alloc(STATE_NUM,STATE_NUM);
	t_m2 = dmatrix_alloc(STATE_NUM,STATE_NUM);
	t_m3 = dmatrix_alloc(STATE_NUM,STATE_NUM);

	//v = MATRIX(1, STATE_NUM, 1, STATE_NUM);
	v  = dmatrix_alloc(STATE_NUM,STATE_NUM);
	nrot = ivector(1, STATE_NUM);
	d = VECTOR(1, STATE_NUM);

	//A = MATRIX(1, STATE_NUM, 1, STATE_NUM);
	//Q = MATRIX(1, STATE_NUM, 1, STATE_NUM);
	//Q1 = MATRIX(1, STATE_NUM, 1, STATE_NUM);
	A = dmatrix_alloc(STATE_NUM,STATE_NUM);
	Q = dmatrix_alloc(STATE_NUM,STATE_NUM);
	Q1 = dmatrix_alloc(STATE_NUM,STATE_NUM);

	H = VECTOR(1, STATE_NUM);
	K = VECTOR(1, STATE_NUM);
	//I = MATRIX(1, STATE_NUM, 1, STATE_NUM);
	I = dmatrix_alloc(STATE_NUM,STATE_NUM);


	// Initialize matrices A and Q
	for (i=1;i<=STATE_NUM;i++){
		K[i] = 0.0;
		for (j=1;j<=STATE_NUM;j++){
			A[i][i] = 0;
			Q[i][i] = 0;
			Q1[i][i] = 0;
			if (i==j)
				I[i][j]= 1.0;
			else
				I[i][j]= 0.0;

		}
	}

	for (i=1;i<=STATE_NUM;i++){
		A[i][i] = 1;
		if (i+2<=STATE_NUM)
			A[i][i+2] = dt;
		if (i+4<=STATE_NUM)
			A[i][i+4] = dt*dt/2.0;
	}



//% The state error covariance matrix is a function of the driving
//% error which is assumed to only hit the accelaration directly.
//% Indirectly this noise affects the velocity and position estimate
//% through the dynamics model. 

//Q=q*[(dt^5)/20         0 (dt^4)/8        0  (dt^3)/6         0
//            0 (dt^5)/20        0 (dt^4)/8         0  (dt^3)/6   
//      (dt^4)/8         0 (dt^3)/3        0  (dt^2)/2         0
//             0  (dt^4)/8        0 (dt^3)/3         0  (dt^2)/2
//     (dt^3)/6         0  (dt^2)/2       0        dt         0
//             0  (dt^3)/6         0  (dt^2)/2       0        dt];


	Q[1][1] = q*pow(dt, 5)/20.0;
	Q[1][3] = q*pow(dt, 4)/8.0;
	Q[1][5] = q*pow(dt, 3)/6.0;

	Q[2][2] = q*pow(dt, 5)/20.0;
	Q[2][4] = q*pow(dt, 4)/8.0;
	Q[2][6] = q*pow(dt, 3)/6.0;

	Q[3][1] = q*pow(dt, 4)/8.0;
	Q[3][3] = q*pow(dt, 3)/3.0;
	Q[3][5] = q*pow(dt, 2)/2.0;

	Q[4][2] = q*pow(dt, 4)/8.0;
	Q[4][4] = q*pow(dt, 3)/3.0;
	Q[4][6] = q*pow(dt, 2)/2.0;

	Q[5][1] = q*pow(dt, 3)/6.0;
	Q[5][3] = q*pow(dt, 2)/2.0;
	Q[5][5] = q*dt;

	Q[6][2] = q*pow(dt, 3)/6.0;
	Q[6][4] = q*pow(dt, 2)/2.0;
	Q[6][6] = q*dt;

	/*for (i=1;i<=STATE_NUM;i++) {
	for (j=1;j<=STATE_NUM;j++)
		printf("%f ",Q[i][j]);
	 printf("\n");
	}*/
	//%step b
	//pred_x=A*pre_x;  %6 x 1
	mat_vec_mult(pred.x, A, in->x, STATE_NUM, 0);
	//pred_P=A*pre_P*(A')+Q;  %6 x 6
	// A is transpose
	mat_mat_mult(t_m1, in->P, A, STATE_NUM, 0, 1);
	mat_mat_mult(t_m2, A, t_m1, STATE_NUM, 0, 0);
	mat_add(pred.P, t_m2, Q, STATE_NUM, 0);

	// %step c
	// % assume that 0<=z<2*pi 
	// opt_z = 2*pi + atan2((pred_x(2)-s_y), (pred_x(1)-s_x)); %1 x 1
	// if (opt_z>2*pi)
	//     opt_z = opt_z - 2*pi;
	// end
	// %H is 1 x 6
	// % measurement function is nonlinear 
	// % 
	// % z = atan(x(2) - s_y,  x(1) - s_x);
	// % In order to linearize the problem we find the jacobian
	// % noticing that 
	// %
	// % d(atan(x))/dx = 1/(1+x^2)
	// %
	// H=[ -(pred_x(2)-s_y)/(( (pred_x(1)-s_x)^2+(pred_x(2)-s_y)^2 )), (pred_x(1)-s_x)/(( (pred_x(1)-s_x)^2+(pred_x(2)-s_y)^2 )), 0, 0, 0, 0];

	opt_z = 2*PI + atan2((pred.x[2]-s_y), (pred.x[1]-s_x));
	
	H[1] = -(pred.x[2]-s_y)/ ( (pred.x[1]-s_x)*(pred.x[1]-s_x)+(pred.x[2]-s_y)*(pred.x[2]-s_y) );
	H[2] = (pred.x[1]-s_x) / ( (pred.x[1]-s_x)*(pred.x[1]-s_x)+(pred.x[2]-s_y)*(pred.x[2]-s_y) );
	H[3] = 0.0; H[4] = 0.0; H[5] = 0.0; H[6] = 0.0;


	//test=find(isnan(H)==1);
	//if (~isempty(test))
	//	disp('H goes to infinity due to node position is the same as the predicted value')
	//	return;
	//end
	if (isnan(H[1]) || isnan(H[1])){
			fprintf(stderr, "H goes to infinity due to node position is the same as the predicted value\n");
			return(-1);
	}


	//%step d
	//%also test if P is still a positive definite matrix.  If not, add some small noise to it to
	//%make it still positive.
	//n1=1;
	//Q1=n1*eye(6);
	//Q1(1,1)=0.1;
	//Q1(2,2)=0.1;
	//Q1(3,3)=5;
	//Q1(4,4)=5;

	Q1[1][1] = 0.1;
	Q1[2][2] = 0.1;
	Q1[3][3] = 5.0;
	Q1[4][4] = 5.0;
	Q1[5][5] = 1.0;
	Q1[6][6] = 1.0;

	//if isempty(find(eig(pred_P)<0.001))
	//   K=pred_P*H'*inv(H*pred_P*H' + R);   %6 x 1
	//else
	//   pred_P=pred_P+Q1;
	//    K=pred_P*H'*inv(H*pred_P*H' + R);   %6 x 1
	//end

	add_noise=0;
	// jacobi destroys the input vector
	mat_copy(t_m2, pred.P, STATE_NUM, 0);
	jacobi(t_m2, STATE_NUM, d, v, nrot);
	for(i=1;i<=STATE_NUM;i++){
		if (d[i]< 0.001)
			add_noise=1;
	}

	if (add_noise){
		mat_add(t_m1, pred.P, Q1, STATE_NUM, 0);
		mat_copy(pred.P, t_m1, STATE_NUM, 0);
	}

	mat_vec_mult(t_v1, pred.P, H, STATE_NUM, 1);
	inner_prod(&t_s, t_v1, H, STATE_NUM);
	t_s+= R;
	scal_vec_mult(K, 1.0/t_s, t_v1, STATE_NUM);

	//%step e and f
	//I=eye(6);

	//opt_x=pred_x+K*(z-opt_z);   %6 x 1
	scal_vec_mult(t_v1, z - opt_z, K, STATE_NUM);
	vec_add(out->x, pred.x, t_v1, STATE_NUM);
	// H: 1 x 6, K: 6 x 1
	//%Joseph form to ward off round off problem
	//opt_P=(I-K*H)*pred_P*(I-K*H)'+K*R*K';       %6 x 6
	scal_vec_mult(t_v1, R, K, STATE_NUM); // R*K'
	outer_prod(t_m1, K, t_v1, STATE_NUM); // K*(R*K')

	outer_prod(t_m2, K, H, STATE_NUM); // K*H
	mat_add(t_m3, I, t_m2, STATE_NUM, 1); // I-K*H
	mat_mat_mult(t_m2, pred.P, t_m3, STATE_NUM, 0, 1);
	mat_mat_mult(out->P, t_m3, t_m2, STATE_NUM, 0, 0);
	mat_add(t_m3, out->P, t_m1, STATE_NUM, 0);
	mat_copy(out->P, t_m3, STATE_NUM, 0);

	//% PRECAUTIONARY APPROACH.  EVEN THOUGH IT HASN'T HAPPEN IN THE SIMULATION SO FAR
	//% also test if opt_P is still a positive definite matrix.  If not, add some small noise to it to
	//% make it still positive.
	//% d: a diagonal matrix of eigenvalues
	//% v: matrix whose vectors are the eigenvectors
	//% X*V = V*D
	//if isempty(find(eig(opt_P)<0.001))
	//else
	//[v d]=eig(opt_P);
	//c=find(d==min(diag(d)));
	//d(c)=0.001;
	//opt_P=v*d*v';
	//end

	add_noise=0;
	// jacobi destroys the input vector
	mat_copy(t_m1, out->P, STATE_NUM, 0);
	jacobi(t_m1, STATE_NUM, d, v, nrot);

	min_d = d[1] ;
	for(i=1;i<=STATE_NUM;i++){
		if ( min_d > d[i])
			min_d = d[i];

		if (d[i]< 0.001)
			add_noise=1;
	}

	// CAUTION - maybe the 2nd minimum is quite far from 0.001
	if (add_noise){
		// change diagonal matrix d
		for (i=1;i<STATE_NUM;i++){
			if (d[i] == min_d)
				d[i] = 0.001;
		}

		// opt_P=v*d*v';
		mat_copy(t_m1, v, STATE_NUM, 1);
		convert_vec_diag(t_m2, d, STATE_NUM);
		mat_mat_mult(t_m3, t_m2, t_m1, STATE_NUM, 0, 0);
		mat_mat_mult(out->P, v, t_m3, STATE_NUM, 0, 0);
	}

	//printf("The pred  are x = %f y = %f\n",pred.x[1],pred.x[2]);


	// Free all MALLOCed matrices
	FREE_VECTOR_FUNCTION(pred.x, 1, STATE_NUM);
	FREE_MATRIX_FUNCTION(pred.P, 1, STATE_NUM, 1, STATE_NUM);

	FREE_VECTOR_FUNCTION(t_v1,   1, STATE_NUM);
	FREE_MATRIX_FUNCTION(t_m1,   1, STATE_NUM, 1, STATE_NUM);
	FREE_MATRIX_FUNCTION(t_m2,   1, STATE_NUM, 1, STATE_NUM);
	FREE_MATRIX_FUNCTION(t_m3,   1, STATE_NUM, 1, STATE_NUM);

	FREE_MATRIX_FUNCTION(v,      1, STATE_NUM, 1, STATE_NUM);
	free_ivector(nrot,           1, STATE_NUM);
	FREE_VECTOR_FUNCTION(d,      1, STATE_NUM);

	FREE_MATRIX_FUNCTION(A,      1, STATE_NUM, 1, STATE_NUM);
	FREE_MATRIX_FUNCTION(Q,      1, STATE_NUM, 1, STATE_NUM);
	FREE_MATRIX_FUNCTION(Q1,     1, STATE_NUM, 1, STATE_NUM);
	FREE_VECTOR_FUNCTION(H,      1, STATE_NUM);
	FREE_VECTOR_FUNCTION(K,      1, STATE_NUM);
	FREE_MATRIX_FUNCTION(I,      1, STATE_NUM, 1, STATE_NUM);

	return(0);
}




