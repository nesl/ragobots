#ifndef __MAT_OPS_H__
#define __MAT_OPS_H__

//vlasios
#define STORAGE_TYPE double
#define FREE_VECTOR_FUNCTION free_dvector
#define FREE_MATRIX_FUNCTION free_dmatrix
#define VECTOR dvector
#define MATRIX dmatrix


// CAUTION!!! 
extern int isnan(STORAGE_TYPE a);


// c(nx1) = A(nxn)*b(nx1);
extern int mat_vec_mult(STORAGE_TYPE *c, STORAGE_TYPE **A, 
			STORAGE_TYPE *b, int n,  int A_trans);

// if A_T = 1 then A traspose should be multiplied
// array multiplication  C = A(nxn) X B(nxn) 
extern int mat_mat_mult(STORAGE_TYPE **C, STORAGE_TYPE **A, STORAGE_TYPE **B, 
				int n, int A_trans, int B_trans);

// B_neg = if B is subtracted or not
extern int mat_add(STORAGE_TYPE **C, STORAGE_TYPE **A, STORAGE_TYPE **B, 
			int n, int B_neg);

// C = A or A_transpose
extern int mat_copy(STORAGE_TYPE **C, STORAGE_TYPE **A, int n, int A_trans);

// inner product of two vectors (1xn) . (nx1) =  (1x1)
extern int inner_prod(STORAGE_TYPE *c, STORAGE_TYPE *a, STORAGE_TYPE *b, int n);

// outer product of two vectors (1xn) X (nx1) =  (nxn)
extern int outer_prod(STORAGE_TYPE **C, STORAGE_TYPE *a, STORAGE_TYPE *b, int n);

// multiplication of a scaler with a vector
extern int	scal_vec_mult(STORAGE_TYPE *c,  STORAGE_TYPE s, STORAGE_TYPE *a, 
						  int n);
extern int vec_add(STORAGE_TYPE *c, STORAGE_TYPE *a, STORAGE_TYPE *b, int n);

// given the diagonal elements in a vector d (nx1) return the matrix
// C (nxn) whose is all zeros except the diagonal elements
// where C[i][i] = d[i] for all i=1..n
extern int	convert_vec_diag(STORAGE_TYPE **C, STORAGE_TYPE *d, int n);

#endif //__MAT_OPS_H__
