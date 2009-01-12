#include <stdio.h>
#include <string.h>
#include <math.h>
#define NRANSI
#include "nrutil.h"

int inv(double **C, int n, double **A){

	double d,*col;
	int *indx;

	int i=0;
	int j=0;

	col = dvector(1, n);
	indx = ivector(1, n);

	ludcmp(a,n,indx,&d); //Decompose the matrix just once.
	for(j=1;j<=n;j++) {           // Find inverse by columns.
		for(i=1;i<=n;i++) col[i]=0.0;
		col[j]=1.0;
		lubksb(a,n,indx,col);
		for(i=1;i<=n;i++) inv_a[i][j]=col[i];
	}

	free_dvector(col, 1, n);
	free_ivector(indx, 1, n);
	return(0);
}

