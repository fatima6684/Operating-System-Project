#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
  char msg[] = "Ayeh";
  int dst = (10<<24) | (0<<16) | (2<<8) | 2; // 10.0.2.2
  int sport = 1111;
  int dport = 2222;

  printf("TX test: sending packet...\n");

  if(send(sport, dst, dport, msg, sizeof(msg)) < 0){
    printf("TX failed\n");
    exit(1);
  }

  printf("TX success\n");
  exit(0);
}

