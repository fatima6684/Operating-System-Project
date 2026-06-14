#include "kernel/types.h"
#include "user/user.h"

int main(void){
  int r1 = bind(2000);
  int r2 = bind(10);
  printf("bind(2000)=%d bind(10)=%d\n", r1, r2);
  exit(0);
}

