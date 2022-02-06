#include <stdio.h>
int main(){
  float x = 2.713;
  float *p_x; // * used to declare pointer
  p_x = &x; // The pointer is assigned the value of the memory address of x
  printf("The value of x: %f\n", x);
  printf("The address of x: %p\n", &x);
  printf("The value of p_x: %p\n", p_x);
  printf("The value stored in the memory address stored in p_x: %f\n", *p_x);
  return 0;
}
