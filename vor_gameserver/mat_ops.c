#include "mat_ops.h"
//vlasios
#define STORAGE_TYPE double
#define FREE_VECTOR_FUNCTION free_dvector
#define FREE_MATRIX_FUNCTION free_dmatrix
#define VECTOR dvector
#define MATRIX dmatrix


// CAUTION!!! 
int isnan(STORAGE_TYPE a)
{
	//if (a==NaN)
	//	return(1);
	//else 
		return(0);

}



// c(nx1) = A(nxn)*b(nx1);
int mat_vec_mult(STORAGE_TYPE *c, STORAGE_TYPE **A, STORAGE_TYPE *b, int n, 
			 int A_trans)
{
	int i=0;
	int j=0;
	STORAGE_TYPE sum=0.0;

	for (i=1;i<=n;i++){
		sum = 0.0;
		for (j=1;j<=n;j++){
			if (A_trans)
				sum += A[j][i]*b[j];
			else
				sum += A[i][j]*b[j];
		}
		c[i] = sum;
	}
	return (0);
}
// if A_T = 1 then A traspose should be multiplied
// array multiplication  C = A(nxn) X B(nxn) 
int mat_mat_mult(STORAGE_TYPE **C, STORAGE_TYPE **A, STORAGE_TYPE **B, int n, 
				 int A_trans, int B_trans)
{
	int i=0;
	int j=0;
	int k=0;
	STORAGE_TYPE sum;


	for (i=1;i<=n;i++){
		for (j=1;j<=n;j++){
			sum = 0.0;
			for (k=1;k<=n;k++){
				if (A_trans)
					if (B_trans)
						sum += A[k][i]*B[j][k];
					else
						sum += A[k][i]*B[k][j];
				else
					if (B_trans)
						sum += A[i][k]*B[j][k];
					else
						sum += A[i][k]*B[k][j];
			}	
			C[i][j] = sum;
		}
	}

	return(0);
}

// B_neg = if B is subtracted or not
int mat_add(STORAGE_TYPE **C, STORAGE_TYPE **A, STORAGE_TYPE **B, int n, 
			int B_neg)
{
	int i=0;
	int j=0;
	for (i=1;i<=n;i++){
		for (j=1;j<=n;j++){
			C[i][j] = A[i][j];
			if (B_neg)
				C[i][j] -= B[i][j];
			else
				C[i][j] += B[i][j];
		}
	}
	return(0);
}

// C = A or A_transpose
int mat_copy(STORAGE_TYPE **C, STORAGE_TYPE **A, int n, int A_trans)
{
	int i=0;
	int j=0;
	int k=0;
	for (i=1;i<=n;i++){
		for (j=1;j<=n;j++){
			if (A_trans)
				C[i][j] = A[j][i];
			else
				C[i][j] = A[i][j];
		}
	}
	return(0);
}

// inner product of two vectors (1xn) . (nx1) =  (1x1)
int inner_prod(STORAGE_TYPE *c, STORAGE_TYPE *a, STORAGE_TYPE *b, int n)
{
	int i=0;
	STORAGE_TYPE sum=0.0;

	for (i=1;i<=n;i++){
		sum += a[i]*b[i];
	}
	*c = sum;
	return(0);
}

// outer product of two vectors (1xn) X (nx1) =  (nxn)
int outer_prod(STORAGE_TYPE **C, STORAGE_TYPE *a, STORAGE_TYPE *b, int n)
{
	int i=0;
	int j=0;
	STORAGE_TYPE sum=0.0;
	
	for (i=1;i<=n;i++){
		for (j=1;j<=n;j++){
			C[i][j] = a[i]*b[j];
		}
	}
	return(0);
}

// multiplication of a scaler with a vector
int	scal_vec_mult(STORAGE_TYPE *c,  STORAGE_TYPE s, STORAGE_TYPE *a, int n)
{
	int i=0;

	for (i=1;i<=n;i++){
		c[i]= s*a[i];
	}
	
	return(0);
}

int vec_add(STORAGE_TYPE *c, STORAGE_TYPE *a, STORAGE_TYPE *b, int n)
{
	int i=0;
	for (i=1;i<=n;i++){
			c[i] = a[i] + b[i] ;
	}
	return(0);
}

// given the diagonal elements in a vector d (nx1) return the matrix
// C (nxn) whose is all zeros except the diagonal elements
// where C[i][i] = d[i] for all i=1..n
int	convert_vec_diag(STORAGE_TYPE **C, STORAGE_TYPE *d, int n)
{
	int i=1;
	int j=1;
	
	for (i=1;i<=n;i++){
		for (j=1;j<=n;j++){
			if (i==j)
				C[i][i] = d[i];
			else
				C[i][j] = 0.0;
		}
	}
	return(0);
}

