#include <stdio.h>
int main(){
  int N = 10;
  int sum = 0;
  for(int i=0; i<N; i++){ // i++ same as i = i + 1
    sum = sum + i;
    printf("Iteration: %d, sum = %d\n", i, sum);
    }
  return 0;
}
