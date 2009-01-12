//vlasios
#define STORAGE_TYPE double
#define FREE_VECTOR_FUNCTION free_dvector
#define FREE_MATRIX_FUNCTION free_dmatrix
#define VECTOR dvector
#define MATRIX dmatrix


void lubksb(STORAGE_TYPE **a, int n, int *indx, STORAGE_TYPE b[])
{
	int i,ii=0,ip,j;
	STORAGE_TYPE sum;

	for (i=1;i<=n;i++) {
		ip=indx[i];
		sum=b[ip];
		b[ip]=b[i];
		if (ii)
			for (j=ii;j<=i-1;j++) sum -= a[i][j]*b[j];
		else if (sum) ii=i;
		b[i]=sum;
	}
	for (i=n;i>=1;i--) {
		sum=b[i];
		for (j=i+1;j<=n;j++) sum -= a[i][j]*b[j];
		b[i]=sum/a[i][i];
	}
}
