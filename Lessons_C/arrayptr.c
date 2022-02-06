#include <stdio.h>

int main() {
  int somenumbers[5]; //array of numbers length 5
  int *ptr = somenumbers; // eqiv to &somenumbers[0]
  int v = 2;

  for(;ptr < &somenumbers[5]; ptr++) {
    *ptr = v;
    v = v*2;
  } // no inizialization; keep going while ptr is less than somenumbers[5]

  int i;
  for(i=0;i<5;i++) {
    printf("%d\n", somenumbers[i]);
  }
}
