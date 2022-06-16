#include<stdio.h>
#include<stdlib.h> // for malloc() and calloc() functions
void smul(); //static multiplication
void dmul(); //dynamic multiplication
void main()
{
 int n;
 printf("MENU\n Select an option\n");
 printf("1.Static Multiplication\n");
 printf("2.Dynamic Multiplication\n");
 printf("3.Exit\n");
 printf("Enter your choice ");
 scanf("%d",&n);
 switch(n)
 {
  case 1 : smul();
         break;
  case 2 : dmul();
         break;
  case 3 : exit(0);
         break;
  default : printf("Invalid choice");
 }
}

void smul()
{
 int A[20][20],B[20][20],C[20][20],i,j,k,m,n,p,q;
 printf("Enter no. of rows and no. of columns for Matrix 1 :");
 scanf("%d%d",&m,&n);
 printf("Enter no. of rows and no. of columns for Matrix 2:");
 scanf("%d%d",&p,&q);
 if(n==p)
 {
 printf("Enter elements for matrix 1:");
  for(i=0;i<m;++i) //row1
   for(j=0;j<n;++j) .//col1
    scanf("%d",&A[i][j]);
  printf("Enter elements for matrix 2:");
  for(i=0;i<p;++i)  //row2
   for(j=0;j<q;++j)  //col2
    scanf("%d",&B[i][j]);
  //calculation
  for(i=0;i<m;++i)
  {
   for(j=0;j<q;++j) //dimensions of resul. Matrix= row1Xcol2
   {
     C[i][j]=0;
     for(k=0;k<n;++k)   //col1
      C[i][j]=C[i][j]+A[i][k]*B[k][j];
   }
  }
  printf("Matrix after multiplication :: ");
  for(i=0;i<m;++i)
  {
   printf("\n");
   for(j=0;j<q;++j)
    printf("%d\t",C[i][j]);
  }
 }
 else
 printf("Multiplication is not possible ");
 }

 void dmul()  //dynamically
 {
  int r1,c1,r2,c2,i,j,k;
  int **A,**B,**C;
  printf("Enter no. of rows and no. of columns for Matrix 1 :");
  scanf("%d%d",&r1,&c1);
  printf("Enter no. of rows and no. of columns for Matrix 2:");
  scanf("%d%d",&r2,&c2);
  if(c1==r2)
  {
   A=malloc(r1*sizeof*A);
   for(i=0;i<r1;++i)
    A[i]=malloc(c1*sizeof*A[i]);

   B=malloc(r2*sizeof*B);
   for(i=0;i<r2;++i)
    B[i]=malloc(c2*sizeof*B[i]);

   C=malloc(r1*sizeof*C);
   for(i=0;i<r1;++i)
    C[i]=malloc(c2*sizeof*C[i]);

  printf("Enter elements for matrix 1:");
  for(i=0;i<r1;++i)
   for(j=0;j<c1;++j)
    scanf("%d",&A[i][j]);

  printf("Enter elements for matrix 2:");
  for(i=0;i<r2;++i)
   for(j=0;j<c2;++j)
    scanf("%d",&B[i][j]);

  for(i=0;i<r1;++i)
  {
   for(j=0;j<c2;++j)
   {
     C[i][j]=0;
     for(k=0;k<c1;++k)
      C[i][j]=C[i][j]+A[i][k]*B[k][j];
   }
  }
  printf("Matrix after multiplication :: ");
  for(i=0;i<r1;++i)
  {
   printf("\n");
   for(j=0;j<c2;++j)
    printf("%d\n",C[i][j]);
  }
 }

  else
  printf("Matrix multiplication is not possible ");
 } 
