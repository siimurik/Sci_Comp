#include <stdio.h>
int main(){
  int j = 10; // Declare j and set value to 10
  /* -------------------------------------while loop
  -> Executes statements ONLY if
  condition is met
  ---------------------------------------*/
  while(j > 10 && j < 20){
    printf("while: j = %d\n", j);
    j = j + 1;
  }
  j = 20; // Reset value of j to 10
  /* -------------------------------------do while
  loop
  -> Executes statements at least 1 time,
  even if condition is not met
  ---------------------------------------*/
  do{
    printf("do-while: j = %d\n", j);
    j = j + 1;
  }while(j > 10 && j < 20);
  return 0;
}
