#include <stdio.h>
int main(){
  float x = 1000.0;

  while(x > 1.0){
    printf("x = %f\n", x);
    x = x / 2.0;
  }
  return 0;
}
