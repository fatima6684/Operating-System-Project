#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "fs.h"
#include "sleeplock.h"
#include "file.h"
#include "net.h"

// xv6's ethernet and IP addresses
static uint8 local_mac[ETHADDR_LEN] = { 0x52, 0x54, 0x00, 0x12, 0x34, 0x56 };
static uint32 local_ip = MAKE_IP_ADDR(10, 0, 2, 15);

// qemu host's ethernet address.
static uint8 host_mac[ETHADDR_LEN] = { 0x52, 0x55, 0x0a, 0x00, 0x02, 0x02 };

static struct spinlock netlock;

#define NUDPPORT 64
#define UDPQSIZE 16

struct udp_packet {
  uint32 src;
  uint16 sport;
  int len;
  char data[512];
};

struct udp_queue {
  struct spinlock lock;
  int bound;
  struct udp_packet pkts[UDPQSIZE];
  int r;
  int w;
  int err; // Flag to indicate a network error occurred *ICMP*
};

static struct udp_queue udp_ports[NUDPPORT];

void
netinit(void)
{
  initlock(&netlock, "netlock");

  for(int i = 0; i < NUDPPORT; i++){
    initlock(&udp_ports[i].lock, "udpq");
    udp_ports[i].bound = 0;
    udp_ports[i].r = 0;
    udp_ports[i].w = 0;
    udp_ports[i].err = 0;     // *ICMP*
  }
}

//
// bind(int port)
// prepare to receive UDP packets address to the port,
// i.e. allocate any queues &c needed.
//
uint64
sys_bind(void)
{
  int port;
  argint(0, &port);

  if(port < 0 || port >= NUDPPORT)
    return -1;

  acquire(&udp_ports[port].lock);
  udp_ports[port].bound = 1;
  udp_ports[port].r = 0;
  udp_ports[port].w = 0;
  release(&udp_ports[port].lock);

  return 0;
}


//
// unbind(int port)
// release any resources previously created by bind(port);
// from now on UDP packets addressed to port should be dropped.
//
uint64
sys_unbind(void)
{
  int port;
  argint(0, &port);

  if(port < 0 || port >= NUDPPORT)
    return -1;

  struct udp_queue *q = &udp_ports[port];

  acquire(&q->lock);

  q->w = 0;

  q->bound = 0;

  release(&q->lock);

  return 0;
}


//
// recv(int dport, int *src, short *sport, char *buf, int maxlen)
// if there's a received UDP packet already queued that was
// addressed to dport, then return it.
// otherwise wait for such a packet.
//
// sets *src to the IP source address.
// sets *sport to the UDP source port.
// copies up to maxlen bytes of UDP payload to buf.
// returns the number of bytes copied,
// and -1 if there was an error.
//
// dport, *src, and *sport are host byte order.
// bind(dport) must previously have been called.
//
uint64
sys_recv(void)
{
  int dport;
  uint64 srcaddr, sportaddr, bufaddr;
  int maxlen;

  argint(0, &dport);
  argaddr(1, &srcaddr);
  argaddr(2, &sportaddr);
  argaddr(3, &bufaddr);
  argint(4, &maxlen);

  if(dport < 0 || dport >= NUDPPORT)
    return -1;

  struct udp_queue *q = &udp_ports[dport];

  acquire(&q->lock);

  while(q->r == q->w){
    // CHECK FOR ERROR BEFORE SLEEPING
    if(q->err){
      q->err = 0; // Clear the error so next call works
      release(&q->lock);
      return -1; // Return error to user
    }
    sleep(q, &q->lock);
  }
  
  // CHECK FOR ERROR AFTER WAKING UP
  if(q->err){
    q->err = 0;
    release(&q->lock);
    return -1;
  }

  struct udp_packet *p = &q->pkts[q->r % UDPQSIZE];
  q->r++;

  release(&q->lock);

  struct proc *pr = myproc();

  if(copyout(pr->pagetable, srcaddr, (char*)&p->src, sizeof(p->src)) < 0)
    return -1;

  if(copyout(pr->pagetable, sportaddr, (char*)&p->sport, sizeof(p->sport)) < 0)
    return -1;

  int n = p->len;
  if(n > maxlen) n = maxlen;

  if(copyout(pr->pagetable, bufaddr, p->data, n) < 0)
    return -1;

  return n;
}

// This code is lifted from FreeBSD's ping.c, and is copyright by the Regents
// of the University of California.
static unsigned short
in_cksum(const unsigned char *addr, int len)
{
  int nleft = len;
  const unsigned short *w = (const unsigned short *)addr;
  unsigned int sum = 0;
  unsigned short answer = 0;

  /*
   * Our algorithm is simple, using a 32 bit accumulator (sum), we add
   * sequential 16 bit words to it, and at the end, fold back all the
   * carry bits from the top 16 bits into the lower 16 bits.
   */
  while (nleft > 1)  {
    sum += *w++;
    nleft -= 2;
  }

  /* mop up an odd byte, if necessary */
  if (nleft == 1) {
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    sum += answer;
  }

  /* add back carry outs from top 16 bits to low 16 bits */
  sum = (sum & 0xffff) + (sum >> 16);
  sum += (sum >> 16);
  /* guaranteed now that the lower 16 bits of sum are correct */

  answer = ~sum; /* truncate to 16 bits */
  return answer;
}

//
// send(int sport, int dst, int dport, char *buf, int len)
//
uint64
sys_send(void)
{
  struct proc *p = myproc();
  int sport;
  int dst;
  int dport;
  uint64 bufaddr;
  int len;

  argint(0, &sport);
  argint(1, &dst);
  argint(2, &dport);
  argaddr(3, &bufaddr);
  argint(4, &len);

  int total = len + sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp);
  if(total > PGSIZE)
    return -1;

  char *buf = kalloc();
  if(buf == 0){
    printf("sys_send: kalloc failed\n");
    return -1;
  }
  memset(buf, 0, PGSIZE);

  struct eth *eth = (struct eth *) buf;
  memmove(eth->dhost, host_mac, ETHADDR_LEN);
  memmove(eth->shost, local_mac, ETHADDR_LEN);
  eth->type = htons(ETHTYPE_IP);

  struct ip *ip = (struct ip *)(eth + 1);
  ip->ip_vhl = 0x45; // version 4, header length 4*5
  ip->ip_tos = 0;
  ip->ip_len = htons(sizeof(struct ip) + sizeof(struct udp) + len);
  ip->ip_id = 0;
  ip->ip_off = 0;
  ip->ip_ttl = 100;
  ip->ip_p = IPPROTO_UDP;
  ip->ip_src = htonl(local_ip);
  ip->ip_dst = htonl(dst);
  ip->ip_sum = in_cksum((unsigned char *)ip, sizeof(*ip));

  struct udp *udp = (struct udp *)(ip + 1);
  udp->sport = htons(sport);
  udp->dport = htons(dport);
  udp->ulen = htons(len + sizeof(struct udp));

  char *payload = (char *)(udp + 1);
  if(copyin(p->pagetable, payload, bufaddr, len) < 0){
    kfree(buf);
    printf("send: copyin failed\n");
    return -1;
  }

  e1000_transmit(buf, total);

  return 0;
}

// *ICMP*
static void
icmp_send_reply(char *buf)
{
  struct eth *eth = (struct eth *)buf;
  struct ip *ip = (struct ip *)(eth + 1);
  int ip_hlen = (ip->ip_vhl & 0x0f) * 4;
  struct icmp *icmp = (struct icmp *)((char *)ip + ip_hlen);

  // 1. Swap Ethernet addresses
  uint8 tmp_mac[ETHADDR_LEN];
  memmove(tmp_mac, eth->shost, ETHADDR_LEN);
  memmove(eth->shost, eth->dhost, ETHADDR_LEN);
  memmove(eth->dhost, tmp_mac, ETHADDR_LEN);

  // 2. Swap IP addresses
  uint32 tmp_ip = ip->ip_src;
  ip->ip_src = ip->ip_dst;
  ip->ip_dst = tmp_ip;

  // 3. Change ICMP type to Reply and update Checksum
  icmp->type = ICMP_ECHO_REPLY;
  icmp->checksum = 0;
  // Recalculate checksum over the ICMP header and data
  int icmp_len = ntohs(ip->ip_len) - ip_hlen;
  icmp->checksum = in_cksum((unsigned char *)icmp, icmp_len);

  // 4. Transmit the modified buffer
  e1000_transmit(buf, sizeof(struct eth) + ntohs(ip->ip_len));
}

// *ICMP*
static int
notify_socket_error(char *buf)
{
  struct eth *eth = (struct eth *)buf;
  struct ip *ip = (struct ip *)(eth + 1);
  int ip_hlen = (ip->ip_vhl & 0x0f) * 4;
  struct icmp *icmp = (struct icmp *)((char *)ip + ip_hlen);

  struct ip *inner_ip = (struct ip *)((char *)icmp + 8);
  int inner_ip_hlen = (inner_ip->ip_vhl & 0x0f) * 4;
  struct udp *inner_udp = (struct udp *)((char *)inner_ip + inner_ip_hlen);
  
  uint16 local_port = ntohs(inner_udp->dport);
  int handled = 0;

  if(local_port < NUDPPORT){
    struct udp_queue *q = &udp_ports[local_port];
    acquire(&q->lock);
    if(q->bound){
      q->err = 1;
      wakeup(q); 
      handled = 1; // Successfully matched to a listening app
    }
    release(&q->lock);
  }
  return handled;
}

// *ICMP*
void
icmp_rx(char *buf, int len)
{
  struct eth *eth = (struct eth *)buf;
  struct ip *ip = (struct ip *)(eth + 1);
  int ip_hlen = (ip->ip_vhl & 0x0f) * 4;
  
  if (len < sizeof(struct eth) + ip_hlen + 8) {
    printf("icmp_rx: packet too short (%d bytes), dropping\n", len);
    kfree(buf);
    return;
  }

  struct icmp *icmp = (struct icmp *)((char *)ip + ip_hlen);
  int success = 0;

  switch(icmp->type) {
    case ICMP_ECHO:
      printf("icmp_rx: ECHO REQUEST received -> sending reply\n");
      icmp_send_reply(buf);
      return; // Return early; buf is kfreed after transmission

    case ICMP_DST_UNREACH:
      success = notify_socket_error(buf);
      if(success)
        printf("icmp_rx: DEST UNREACHABLE handled (notified port)\n");
      else
        printf("icmp_rx: DEST UNREACHABLE ignored (no bound port found)\n");
      break;

    case ICMP_TIME_EXCEED:
      success = notify_socket_error(buf);
      if(success)
        printf("icmp_rx: TTL EXPIRED handled (notified port)\n");
      else
        printf("icmp_rx: TTL EXPIRED ignored\n");
      break;

    case ICMP_QUENCH:
      success = notify_socket_error(buf);
      printf("icmp_rx: SOURCE QUENCH received (throttling: %s)\n", success ? "OK" : "IGNORED");
      break;

    default:
      printf("icmp_rx: unhandled type %d - dropping\n", icmp->type);
      break;
  }

  kfree(buf);
}

void
ip_rx(char *buf, int len)
{
  static int seen_ip = 0;
  if(seen_ip == 0)
    printf("ip_rx: received an IP packet\n");
  seen_ip = 1;

  if(len < sizeof(struct eth) + sizeof(struct ip)){
    kfree(buf);
    return;
  }

  struct eth *eth = (struct eth *)buf;
  struct ip *ip = (struct ip *)(eth + 1);

  // handle ICMP errorz
  if(ip->ip_p == IPPROTO_ICMP){
    printf("ip_rx: detected ICMP packet!\n");
    icmp_rx(buf, len); // Call the *ICMP* function
    return;
  }

  // drop non-udp packets
  if(ip->ip_p != IPPROTO_UDP){
    kfree(buf);
    return;
  }

  int ip_hlen = (ip->ip_vhl & 0x0f) * 4;
  if(ip_hlen < 20){
    kfree(buf);
    return;
  }

  if(len < sizeof(struct eth) + ip_hlen + sizeof(struct udp)){
    kfree(buf);
    return;
  }

  struct udp *udp = (struct udp *)((char *)ip + ip_hlen);

  uint16 dport = ntohs(udp->dport);
  uint16 sport = ntohs(udp->sport);

  if(dport >= NUDPPORT){
    kfree(buf);
    return;
  }

  struct udp_queue *q = &udp_ports[dport];

  acquire(&q->lock);

  if(q->bound == 0){
    release(&q->lock);
    kfree(buf);
    return;
  }

  if(q->w - q->r >= UDPQSIZE){
    release(&q->lock);
    kfree(buf);
    return;
  }

  struct udp_packet *p = &q->pkts[q->w % UDPQSIZE];

  p->src = ntohl(ip->ip_src);
  p->sport = sport;

  int plen = ntohs(udp->ulen) - sizeof(struct udp);
  if(plen < 0) plen = 0;
  if(plen > sizeof(p->data)) plen = sizeof(p->data);

  memmove(p->data, (char *)(udp + 1), plen);
  p->len = plen;

  q->w++;

  wakeup(q);

  release(&q->lock);

  kfree(buf);
}





//
// send an ARP reply packet to tell qemu to map
// xv6's ip address to its ethernet address.
// this is the bare minimum needed to persuade
// qemu to send IP packets to xv6; the real ARP
// protocol is more complex.
//
void
arp_rx(char *inbuf)
{
  static int seen_arp = 0;

  if(seen_arp){
    kfree(inbuf);
    return;
  }
  printf("arp_rx: received an ARP packet\n");
  seen_arp = 1;

  struct eth *ineth = (struct eth *) inbuf;
  struct arp *inarp = (struct arp *) (ineth + 1);

  char *buf = kalloc();
  if(buf == 0)
    panic("send_arp_reply");
  
  struct eth *eth = (struct eth *) buf;
  memmove(eth->dhost, ineth->shost, ETHADDR_LEN); // ethernet destination = query source
  memmove(eth->shost, local_mac, ETHADDR_LEN); // ethernet source = xv6's ethernet address
  eth->type = htons(ETHTYPE_ARP);

  struct arp *arp = (struct arp *)(eth + 1);
  arp->hrd = htons(ARP_HRD_ETHER);
  arp->pro = htons(ETHTYPE_IP);
  arp->hln = ETHADDR_LEN;
  arp->pln = sizeof(uint32);
  arp->op = htons(ARP_OP_REPLY);

  memmove(arp->sha, local_mac, ETHADDR_LEN);
  arp->sip = htonl(local_ip);
  memmove(arp->tha, ineth->shost, ETHADDR_LEN);
  arp->tip = inarp->sip;

  e1000_transmit(buf, sizeof(*eth) + sizeof(*arp));

  kfree(inbuf);
}

void
net_rx(char *buf, int len)
{
  printf("net_rx: received packet len %d\n", len);
  struct eth *eth = (struct eth *) buf;

  if(len >= sizeof(struct eth) + sizeof(struct arp) &&
     ntohs(eth->type) == ETHTYPE_ARP){
    arp_rx(buf);
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
     ntohs(eth->type) == ETHTYPE_IP){
    ip_rx(buf, len);
  } else {
    kfree(buf);
  }
}
