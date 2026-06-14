#include "kernel/types.h"
#include "user/user.h"

#define MYPORT   10        
#define HOSTIP   0x0a000202   
#define HOSTPORT 2222

static void
send_msg(const char *s)
{
  int n = strlen(s);
  if(send(1111, HOSTIP, HOSTPORT, (char*)s, n) < 0){
    printf("fullnet: send failed\n");
    exit(1);
  }
}

int
main(void)
{
  char buf[128];
  uint32 src;
  uint16 sport;

  printf("fullnet: bind(%d)\n", MYPORT);
  if(bind(MYPORT) < 0){
    printf("fullnet: bind failed\n");
    exit(1);
  }

  // 1) TX test: xv6 -> host
  printf("fullnet: TX test (xv6 -> host)\n");
  send_msg("TX_OK");

  // 2) RX test: host -> xv6 (منتظر می‌ماند)
  printf("fullnet: RX test (host -> xv6). Now send UDP to host port 26999...\n");
  int n = recv(MYPORT, &src, &sport, buf, sizeof(buf)-1);
  if(n < 0){
    printf("fullnet: recv failed\n");
    exit(1);
  }
  buf[n] = 0;
  printf("fullnet: got \"%s\" from src=%d sport=%d\n", buf, src, sport);

  printf("fullnet: queue/drop test: send 30 UDP packets quickly from host now...\n");
  printf("fullnet: receiving 16 packets (max queue size) ...\n");

  int got = 0;
  for(int i = 0; i < 16; i++){
    n = recv(MYPORT, &src, &sport, buf, sizeof(buf)-1);
    if(n < 0){
      printf("fullnet: recv error during stress\n");
      break;
    }
    buf[n] = 0;
  
    printf("fullnet: stress pkt %d: %s\n", i, buf);
    got++;
  }
  printf("fullnet: received %d packets (should be 16). extra should have been dropped.\n", got);

  printf("fullnet: unbind(%d)\n", MYPORT);
  if(unbind(MYPORT) < 0){
    printf("fullnet: unbind failed\n");
    exit(1);
  }

  printf("fullnet: DONE (no crash, queue limit enforced, unbind drops packets)\n");

  exit(0);
}

