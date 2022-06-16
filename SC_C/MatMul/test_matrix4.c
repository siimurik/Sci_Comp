#include<stdio.h>
#include<conio.h>
#include<alloc.h>
void main()
{
int a[3][3],b[3][3],multi[3][3];
int i,j,k,row,col;

clrscr();
printf("\n enter the value of row")
scanf("\n %d",&row);
printf("\n enter the value of col")
scanf("\n %d",&col);
a[i][j]=(int)calloc(n,sizeof(int));

printf("\n enter first matrix-");

for(i=0;i<row;i++)
 {
 for(j=0;j<col;j++)
  {
  scanf("\n %d", &a[i][j]);
  }
 }
printf("\n enter the value of row")
scanf("\n %d",&row);
printf("\n enter the value of col")
scanf("\n %d",&col);
b[i][j]=(int)calloc(n,sizeof(int));

printf("\n enter second matrix-");

for(i=0;i<3;i++)
 {
 for(j=0;j<3;j++)
  {
  scanf("\n %d",&b[i][j]);
  }
 }
for(i=0;i<3;i++)
 {
 for(j=0;j<3;j++)
  {
   multi[i][j]=0;
   for(k=0;k<3;k++)
  {
  multi[i][j]=multi[i][j]+(a[i][k]*b[k][j]);
  }
 }
}
printf("\n the matrix multiplication is-");
for(i=0;i<3;i++)
 {
 for(j=0;j<3;j++)
  {
  printf("\t %d",multi[i][j]);
  }
 printf("\n");
}
getch();
}
