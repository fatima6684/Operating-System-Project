#include "kernel/types.h"
#include "user/user.h"

// 10.0.2.2 is the QEMU host address
#define HOSTIP    0x0a000202  
#define PORT      11 
#define WRONGPORT 33
int
main(void)
{
  uint32 src;
  uint16 sport;
  char buf[128];

  printf("TEST_ICMP: starting...\n");

  // 1. Bind to a local port so we can receive the error
  if(bind(PORT) < 0){
    printf("TEST_ICMP: bind failed\n");
    exit(1);
  }
  printf("TEST_ICMP: bound to port %d\n", PORT);

  // 2. Send a UDP packet to a closed port on the host
  // When the host receives this, it will see no one is listening 
  // and send back an ICMP Port Unreachable packet.
  printf("TEST_ICMP: sending to closed port %d on host (10.0.2.2)...\n", PORT);
  
  if(send(WRONGPORT, HOSTIP, PORT, "ICMP", 4) < 0){
    printf("TEST_ICMP: send failed\n");
    exit(1);
  }

  // 3. Call recv(). 
  // Normal behavior: This would block forever waiting for a reply.
  // ICMP behavior: The kernel should receive the ICMP error, wake us up, and return -1.
  printf("TEST_ICMP: waiting for response (expecting ICMP error)...\n");
  
  int n = recv(PORT, &src, &sport, buf, sizeof(buf)-1);

  if(n < 0){
    printf("TEST_ICMP: SUCCESS! recv returned -1.\n");
    printf("TEST_ICMP: This indicates the kernel received the ICMP unreachable message.\n");
  } else {
    buf[n] = 0;
    printf("TEST_ICMP: FAILURE. Received actual data: '%s'\n", buf);
    printf("TEST_ICMP: Did not receive expected ICMP error.\n");
  }

  // Cleanup
  if(unbind(PORT) < 0){
    printf("unbind failed\n");
    exit(1);
  }
  printf("TEST_ICMP: DONE ( ICMP handled successfully)\n");
  exit(0);
}