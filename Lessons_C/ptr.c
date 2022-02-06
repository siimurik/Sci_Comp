#include <stdio.h>

int main() {
  int x = 7;
  printf("x is %d\n", x);

  x = 14;
  printf("x is %d\n", x);

  int *aptr = &x; //* indicates a pointer
                  //& is the address in memory for x
  printf("aptr is %x\n", aptr); // %x is in HEX decimal

  printf("x is %d\n", *aptr); // x is 14

  *aptr = 21;
  printf("x is %d %d\n", x, *aptr); // x is 21 21
}
