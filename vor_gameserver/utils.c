#include <stdio.h>
#include <math.h>
#include "kalman_data_structures.h"
#include "nrutil.h"
#include "mat_ops.h"



STORAGE_TYPE ** dmatrix_alloc(int rows,int cols)
{
	STORAGE_TYPE **ptr;
	int i,j;

	rows++;
	cols++;

	ptr = (double **)malloc(sizeof(double *)*rows);

	for(i=1;i<=rows;i++)
		ptr[i] = (double *)malloc(sizeof(double) * cols);

	for(i=1;i<=rows;i++)
	for(j=0;j<cols;j++)
		ptr[i][j] = 0;		


	return ptr;

}

void free_dmatrix_alloc(STORAGE_TYPE **ptr)
{
	
}
