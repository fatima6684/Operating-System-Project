
user/_TEST_ICMP:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#define HOSTIP    0x0a000202  
#define PORT      11 
#define WRONGPORT 33
int
main(void)
{
   0:	7135                	addi	sp,sp,-160
   2:	ed06                	sd	ra,152(sp)
   4:	e922                	sd	s0,144(sp)
   6:	1100                	addi	s0,sp,160
  uint32 src;
  uint16 sport;
  char buf[128];

  printf("TEST_ICMP: starting...\n");
   8:	00001517          	auipc	a0,0x1
   c:	9b850513          	addi	a0,a0,-1608 # 9c0 <malloc+0x106>
  10:	7f6000ef          	jal	806 <printf>

  // 1. Bind to a local port so we can receive the error
  if(bind(PORT) < 0){
  14:	452d                	li	a0,11
  16:	432000ef          	jal	448 <bind>
  1a:	0a054563          	bltz	a0,c4 <main+0xc4>
    printf("TEST_ICMP: bind failed\n");
    exit(1);
  }
  printf("TEST_ICMP: bound to port %d\n", PORT);
  1e:	45ad                	li	a1,11
  20:	00001517          	auipc	a0,0x1
  24:	9d050513          	addi	a0,a0,-1584 # 9f0 <malloc+0x136>
  28:	7de000ef          	jal	806 <printf>

  // 2. Send a UDP packet to a closed port on the host
  // When the host receives this, it will see no one is listening 
  // and send back an ICMP Port Unreachable packet.
  printf("TEST_ICMP: sending to closed port %d on host (10.0.2.2)...\n", PORT);
  2c:	45ad                	li	a1,11
  2e:	00001517          	auipc	a0,0x1
  32:	9ea50513          	addi	a0,a0,-1558 # a18 <malloc+0x15e>
  36:	7d0000ef          	jal	806 <printf>
  
  if(send(WRONGPORT, HOSTIP, PORT, "ICMP", 4) < 0){
  3a:	4711                	li	a4,4
  3c:	00001697          	auipc	a3,0x1
  40:	a1c68693          	addi	a3,a3,-1508 # a58 <malloc+0x19e>
  44:	462d                	li	a2,11
  46:	0a0005b7          	lui	a1,0xa000
  4a:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffe1f2>
  4e:	02100513          	li	a0,33
  52:	406000ef          	jal	458 <send>
  56:	08054063          	bltz	a0,d6 <main+0xd6>
  }

  // 3. Call recv(). 
  // Normal behavior: This would block forever waiting for a reply.
  // ICMP behavior: The kernel should receive the ICMP error, wake us up, and return -1.
  printf("TEST_ICMP: waiting for response (expecting ICMP error)...\n");
  5a:	00001517          	auipc	a0,0x1
  5e:	a1e50513          	addi	a0,a0,-1506 # a78 <malloc+0x1be>
  62:	7a4000ef          	jal	806 <printf>
  
  int n = recv(PORT, &src, &sport, buf, sizeof(buf)-1);
  66:	07f00713          	li	a4,127
  6a:	f6840693          	addi	a3,s0,-152
  6e:	fea40613          	addi	a2,s0,-22
  72:	fec40593          	addi	a1,s0,-20
  76:	452d                	li	a0,11
  78:	3e8000ef          	jal	460 <recv>

  if(n < 0){
  7c:	06054663          	bltz	a0,e8 <main+0xe8>
    printf("TEST_ICMP: SUCCESS! recv returned -1.\n");
    printf("TEST_ICMP: This indicates the kernel received the ICMP unreachable message.\n");
  } else {
    buf[n] = 0;
  80:	ff050793          	addi	a5,a0,-16
  84:	00878533          	add	a0,a5,s0
  88:	f6050c23          	sb	zero,-136(a0)
    printf("TEST_ICMP: FAILURE. Received actual data: '%s'\n", buf);
  8c:	f6840593          	addi	a1,s0,-152
  90:	00001517          	auipc	a0,0x1
  94:	aa050513          	addi	a0,a0,-1376 # b30 <malloc+0x276>
  98:	76e000ef          	jal	806 <printf>
    printf("TEST_ICMP: Did not receive expected ICMP error.\n");
  9c:	00001517          	auipc	a0,0x1
  a0:	ac450513          	addi	a0,a0,-1340 # b60 <malloc+0x2a6>
  a4:	762000ef          	jal	806 <printf>
  }

  // Cleanup
  if(unbind(PORT) < 0){
  a8:	452d                	li	a0,11
  aa:	3a6000ef          	jal	450 <unbind>
  ae:	04054a63          	bltz	a0,102 <main+0x102>
    printf("unbind failed\n");
    exit(1);
  }
  printf("TEST_ICMP: DONE ( ICMP handled successfully)\n");
  b2:	00001517          	auipc	a0,0x1
  b6:	af650513          	addi	a0,a0,-1290 # ba8 <malloc+0x2ee>
  ba:	74c000ef          	jal	806 <printf>
  exit(0);
  be:	4501                	li	a0,0
  c0:	2e8000ef          	jal	3a8 <exit>
    printf("TEST_ICMP: bind failed\n");
  c4:	00001517          	auipc	a0,0x1
  c8:	91450513          	addi	a0,a0,-1772 # 9d8 <malloc+0x11e>
  cc:	73a000ef          	jal	806 <printf>
    exit(1);
  d0:	4505                	li	a0,1
  d2:	2d6000ef          	jal	3a8 <exit>
    printf("TEST_ICMP: send failed\n");
  d6:	00001517          	auipc	a0,0x1
  da:	98a50513          	addi	a0,a0,-1654 # a60 <malloc+0x1a6>
  de:	728000ef          	jal	806 <printf>
    exit(1);
  e2:	4505                	li	a0,1
  e4:	2c4000ef          	jal	3a8 <exit>
    printf("TEST_ICMP: SUCCESS! recv returned -1.\n");
  e8:	00001517          	auipc	a0,0x1
  ec:	9d050513          	addi	a0,a0,-1584 # ab8 <malloc+0x1fe>
  f0:	716000ef          	jal	806 <printf>
    printf("TEST_ICMP: This indicates the kernel received the ICMP unreachable message.\n");
  f4:	00001517          	auipc	a0,0x1
  f8:	9ec50513          	addi	a0,a0,-1556 # ae0 <malloc+0x226>
  fc:	70a000ef          	jal	806 <printf>
 100:	b765                	j	a8 <main+0xa8>
    printf("unbind failed\n");
 102:	00001517          	auipc	a0,0x1
 106:	a9650513          	addi	a0,a0,-1386 # b98 <malloc+0x2de>
 10a:	6fc000ef          	jal	806 <printf>
    exit(1);
 10e:	4505                	li	a0,1
 110:	298000ef          	jal	3a8 <exit>

0000000000000114 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 114:	1141                	addi	sp,sp,-16
 116:	e406                	sd	ra,8(sp)
 118:	e022                	sd	s0,0(sp)
 11a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 11c:	ee5ff0ef          	jal	0 <main>
  exit(r);
 120:	288000ef          	jal	3a8 <exit>

0000000000000124 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 124:	1141                	addi	sp,sp,-16
 126:	e422                	sd	s0,8(sp)
 128:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12a:	87aa                	mv	a5,a0
 12c:	0585                	addi	a1,a1,1
 12e:	0785                	addi	a5,a5,1
 130:	fff5c703          	lbu	a4,-1(a1)
 134:	fee78fa3          	sb	a4,-1(a5)
 138:	fb75                	bnez	a4,12c <strcpy+0x8>
    ;
  return os;
}
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cb91                	beqz	a5,15e <strcmp+0x1e>
 14c:	0005c703          	lbu	a4,0(a1)
 150:	00f71763          	bne	a4,a5,15e <strcmp+0x1e>
    p++, q++;
 154:	0505                	addi	a0,a0,1
 156:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 158:	00054783          	lbu	a5,0(a0)
 15c:	fbe5                	bnez	a5,14c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 15e:	0005c503          	lbu	a0,0(a1)
}
 162:	40a7853b          	subw	a0,a5,a0
 166:	6422                	ld	s0,8(sp)
 168:	0141                	addi	sp,sp,16
 16a:	8082                	ret

000000000000016c <strlen>:

uint
strlen(const char *s)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e422                	sd	s0,8(sp)
 170:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 172:	00054783          	lbu	a5,0(a0)
 176:	cf91                	beqz	a5,192 <strlen+0x26>
 178:	0505                	addi	a0,a0,1
 17a:	87aa                	mv	a5,a0
 17c:	86be                	mv	a3,a5
 17e:	0785                	addi	a5,a5,1
 180:	fff7c703          	lbu	a4,-1(a5)
 184:	ff65                	bnez	a4,17c <strlen+0x10>
 186:	40a6853b          	subw	a0,a3,a0
 18a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 18c:	6422                	ld	s0,8(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret
  for(n = 0; s[n]; n++)
 192:	4501                	li	a0,0
 194:	bfe5                	j	18c <strlen+0x20>

0000000000000196 <memset>:

void*
memset(void *dst, int c, uint n)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 19c:	ca19                	beqz	a2,1b2 <memset+0x1c>
 19e:	87aa                	mv	a5,a0
 1a0:	1602                	slli	a2,a2,0x20
 1a2:	9201                	srli	a2,a2,0x20
 1a4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ac:	0785                	addi	a5,a5,1
 1ae:	fee79de3          	bne	a5,a4,1a8 <memset+0x12>
  }
  return dst;
}
 1b2:	6422                	ld	s0,8(sp)
 1b4:	0141                	addi	sp,sp,16
 1b6:	8082                	ret

00000000000001b8 <strchr>:

char*
strchr(const char *s, char c)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	cb99                	beqz	a5,1d8 <strchr+0x20>
    if(*s == c)
 1c4:	00f58763          	beq	a1,a5,1d2 <strchr+0x1a>
  for(; *s; s++)
 1c8:	0505                	addi	a0,a0,1
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbfd                	bnez	a5,1c4 <strchr+0xc>
      return (char*)s;
  return 0;
 1d0:	4501                	li	a0,0
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret
  return 0;
 1d8:	4501                	li	a0,0
 1da:	bfe5                	j	1d2 <strchr+0x1a>

00000000000001dc <gets>:

char*
gets(char *buf, int max)
{
 1dc:	711d                	addi	sp,sp,-96
 1de:	ec86                	sd	ra,88(sp)
 1e0:	e8a2                	sd	s0,80(sp)
 1e2:	e4a6                	sd	s1,72(sp)
 1e4:	e0ca                	sd	s2,64(sp)
 1e6:	fc4e                	sd	s3,56(sp)
 1e8:	f852                	sd	s4,48(sp)
 1ea:	f456                	sd	s5,40(sp)
 1ec:	f05a                	sd	s6,32(sp)
 1ee:	ec5e                	sd	s7,24(sp)
 1f0:	1080                	addi	s0,sp,96
 1f2:	8baa                	mv	s7,a0
 1f4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f6:	892a                	mv	s2,a0
 1f8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1fa:	4aa9                	li	s5,10
 1fc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1fe:	89a6                	mv	s3,s1
 200:	2485                	addiw	s1,s1,1
 202:	0344d663          	bge	s1,s4,22e <gets+0x52>
    cc = read(0, &c, 1);
 206:	4605                	li	a2,1
 208:	faf40593          	addi	a1,s0,-81
 20c:	4501                	li	a0,0
 20e:	1b2000ef          	jal	3c0 <read>
    if(cc < 1)
 212:	00a05e63          	blez	a0,22e <gets+0x52>
    buf[i++] = c;
 216:	faf44783          	lbu	a5,-81(s0)
 21a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21e:	01578763          	beq	a5,s5,22c <gets+0x50>
 222:	0905                	addi	s2,s2,1
 224:	fd679de3          	bne	a5,s6,1fe <gets+0x22>
    buf[i++] = c;
 228:	89a6                	mv	s3,s1
 22a:	a011                	j	22e <gets+0x52>
 22c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 22e:	99de                	add	s3,s3,s7
 230:	00098023          	sb	zero,0(s3)
  return buf;
}
 234:	855e                	mv	a0,s7
 236:	60e6                	ld	ra,88(sp)
 238:	6446                	ld	s0,80(sp)
 23a:	64a6                	ld	s1,72(sp)
 23c:	6906                	ld	s2,64(sp)
 23e:	79e2                	ld	s3,56(sp)
 240:	7a42                	ld	s4,48(sp)
 242:	7aa2                	ld	s5,40(sp)
 244:	7b02                	ld	s6,32(sp)
 246:	6be2                	ld	s7,24(sp)
 248:	6125                	addi	sp,sp,96
 24a:	8082                	ret

000000000000024c <stat>:

int
stat(const char *n, struct stat *st)
{
 24c:	1101                	addi	sp,sp,-32
 24e:	ec06                	sd	ra,24(sp)
 250:	e822                	sd	s0,16(sp)
 252:	e04a                	sd	s2,0(sp)
 254:	1000                	addi	s0,sp,32
 256:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 258:	4581                	li	a1,0
 25a:	18e000ef          	jal	3e8 <open>
  if(fd < 0)
 25e:	02054263          	bltz	a0,282 <stat+0x36>
 262:	e426                	sd	s1,8(sp)
 264:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 266:	85ca                	mv	a1,s2
 268:	198000ef          	jal	400 <fstat>
 26c:	892a                	mv	s2,a0
  close(fd);
 26e:	8526                	mv	a0,s1
 270:	160000ef          	jal	3d0 <close>
  return r;
 274:	64a2                	ld	s1,8(sp)
}
 276:	854a                	mv	a0,s2
 278:	60e2                	ld	ra,24(sp)
 27a:	6442                	ld	s0,16(sp)
 27c:	6902                	ld	s2,0(sp)
 27e:	6105                	addi	sp,sp,32
 280:	8082                	ret
    return -1;
 282:	597d                	li	s2,-1
 284:	bfcd                	j	276 <stat+0x2a>

0000000000000286 <atoi>:

int
atoi(const char *s)
{
 286:	1141                	addi	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28c:	00054683          	lbu	a3,0(a0)
 290:	fd06879b          	addiw	a5,a3,-48
 294:	0ff7f793          	zext.b	a5,a5
 298:	4625                	li	a2,9
 29a:	02f66863          	bltu	a2,a5,2ca <atoi+0x44>
 29e:	872a                	mv	a4,a0
  n = 0;
 2a0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a2:	0705                	addi	a4,a4,1
 2a4:	0025179b          	slliw	a5,a0,0x2
 2a8:	9fa9                	addw	a5,a5,a0
 2aa:	0017979b          	slliw	a5,a5,0x1
 2ae:	9fb5                	addw	a5,a5,a3
 2b0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b4:	00074683          	lbu	a3,0(a4)
 2b8:	fd06879b          	addiw	a5,a3,-48
 2bc:	0ff7f793          	zext.b	a5,a5
 2c0:	fef671e3          	bgeu	a2,a5,2a2 <atoi+0x1c>
  return n;
}
 2c4:	6422                	ld	s0,8(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  n = 0;
 2ca:	4501                	li	a0,0
 2cc:	bfe5                	j	2c4 <atoi+0x3e>

00000000000002ce <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d4:	02b57463          	bgeu	a0,a1,2fc <memmove+0x2e>
    while(n-- > 0)
 2d8:	00c05f63          	blez	a2,2f6 <memmove+0x28>
 2dc:	1602                	slli	a2,a2,0x20
 2de:	9201                	srli	a2,a2,0x20
 2e0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e6:	0585                	addi	a1,a1,1
 2e8:	0705                	addi	a4,a4,1
 2ea:	fff5c683          	lbu	a3,-1(a1)
 2ee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f2:	fef71ae3          	bne	a4,a5,2e6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret
    dst += n;
 2fc:	00c50733          	add	a4,a0,a2
    src += n;
 300:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 302:	fec05ae3          	blez	a2,2f6 <memmove+0x28>
 306:	fff6079b          	addiw	a5,a2,-1
 30a:	1782                	slli	a5,a5,0x20
 30c:	9381                	srli	a5,a5,0x20
 30e:	fff7c793          	not	a5,a5
 312:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 314:	15fd                	addi	a1,a1,-1
 316:	177d                	addi	a4,a4,-1
 318:	0005c683          	lbu	a3,0(a1)
 31c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 320:	fee79ae3          	bne	a5,a4,314 <memmove+0x46>
 324:	bfc9                	j	2f6 <memmove+0x28>

0000000000000326 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 326:	1141                	addi	sp,sp,-16
 328:	e422                	sd	s0,8(sp)
 32a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 32c:	ca05                	beqz	a2,35c <memcmp+0x36>
 32e:	fff6069b          	addiw	a3,a2,-1
 332:	1682                	slli	a3,a3,0x20
 334:	9281                	srli	a3,a3,0x20
 336:	0685                	addi	a3,a3,1
 338:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 33a:	00054783          	lbu	a5,0(a0)
 33e:	0005c703          	lbu	a4,0(a1)
 342:	00e79863          	bne	a5,a4,352 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 346:	0505                	addi	a0,a0,1
    p2++;
 348:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 34a:	fed518e3          	bne	a0,a3,33a <memcmp+0x14>
  }
  return 0;
 34e:	4501                	li	a0,0
 350:	a019                	j	356 <memcmp+0x30>
      return *p1 - *p2;
 352:	40e7853b          	subw	a0,a5,a4
}
 356:	6422                	ld	s0,8(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret
  return 0;
 35c:	4501                	li	a0,0
 35e:	bfe5                	j	356 <memcmp+0x30>

0000000000000360 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 360:	1141                	addi	sp,sp,-16
 362:	e406                	sd	ra,8(sp)
 364:	e022                	sd	s0,0(sp)
 366:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 368:	f67ff0ef          	jal	2ce <memmove>
}
 36c:	60a2                	ld	ra,8(sp)
 36e:	6402                	ld	s0,0(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret

0000000000000374 <sbrk>:

char *
sbrk(int n) {
 374:	1141                	addi	sp,sp,-16
 376:	e406                	sd	ra,8(sp)
 378:	e022                	sd	s0,0(sp)
 37a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 37c:	4585                	li	a1,1
 37e:	0b2000ef          	jal	430 <sys_sbrk>
}
 382:	60a2                	ld	ra,8(sp)
 384:	6402                	ld	s0,0(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret

000000000000038a <sbrklazy>:

char *
sbrklazy(int n) {
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 392:	4589                	li	a1,2
 394:	09c000ef          	jal	430 <sys_sbrk>
}
 398:	60a2                	ld	ra,8(sp)
 39a:	6402                	ld	s0,0(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret

00000000000003a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a0:	4885                	li	a7,1
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a8:	4889                	li	a7,2
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b0:	488d                	li	a7,3
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b8:	4891                	li	a7,4
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <read>:
.global read
read:
 li a7, SYS_read
 3c0:	4895                	li	a7,5
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <write>:
.global write
write:
 li a7, SYS_write
 3c8:	48c1                	li	a7,16
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <close>:
.global close
close:
 li a7, SYS_close
 3d0:	48d5                	li	a7,21
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d8:	4899                	li	a7,6
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e0:	489d                	li	a7,7
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <open>:
.global open
open:
 li a7, SYS_open
 3e8:	48bd                	li	a7,15
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f0:	48c5                	li	a7,17
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f8:	48c9                	li	a7,18
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 400:	48a1                	li	a7,8
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <link>:
.global link
link:
 li a7, SYS_link
 408:	48cd                	li	a7,19
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 410:	48d1                	li	a7,20
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 418:	48a5                	li	a7,9
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <dup>:
.global dup
dup:
 li a7, SYS_dup
 420:	48a9                	li	a7,10
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 428:	48ad                	li	a7,11
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 430:	48b1                	li	a7,12
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <pause>:
.global pause
pause:
 li a7, SYS_pause
 438:	48b5                	li	a7,13
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 440:	48b9                	li	a7,14
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <bind>:
.global bind
bind:
 li a7, SYS_bind
 448:	48f5                	li	a7,29
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 450:	48f9                	li	a7,30
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <send>:
.global send
send:
 li a7, SYS_send
 458:	48fd                	li	a7,31
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <recv>:
.global recv
recv:
 li a7, SYS_recv
 460:	02000893          	li	a7,32
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 46a:	02100893          	li	a7,33
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 474:	02200893          	li	a7,34
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 47e:	1101                	addi	sp,sp,-32
 480:	ec06                	sd	ra,24(sp)
 482:	e822                	sd	s0,16(sp)
 484:	1000                	addi	s0,sp,32
 486:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 48a:	4605                	li	a2,1
 48c:	fef40593          	addi	a1,s0,-17
 490:	f39ff0ef          	jal	3c8 <write>
}
 494:	60e2                	ld	ra,24(sp)
 496:	6442                	ld	s0,16(sp)
 498:	6105                	addi	sp,sp,32
 49a:	8082                	ret

000000000000049c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 49c:	715d                	addi	sp,sp,-80
 49e:	e486                	sd	ra,72(sp)
 4a0:	e0a2                	sd	s0,64(sp)
 4a2:	f84a                	sd	s2,48(sp)
 4a4:	0880                	addi	s0,sp,80
 4a6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4a8:	c299                	beqz	a3,4ae <printint+0x12>
 4aa:	0805c363          	bltz	a1,530 <printint+0x94>
  neg = 0;
 4ae:	4881                	li	a7,0
 4b0:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4b4:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4b6:	00000517          	auipc	a0,0x0
 4ba:	72a50513          	addi	a0,a0,1834 # be0 <digits>
 4be:	883e                	mv	a6,a5
 4c0:	2785                	addiw	a5,a5,1
 4c2:	02c5f733          	remu	a4,a1,a2
 4c6:	972a                	add	a4,a4,a0
 4c8:	00074703          	lbu	a4,0(a4)
 4cc:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4d0:	872e                	mv	a4,a1
 4d2:	02c5d5b3          	divu	a1,a1,a2
 4d6:	0685                	addi	a3,a3,1
 4d8:	fec773e3          	bgeu	a4,a2,4be <printint+0x22>
  if(neg)
 4dc:	00088b63          	beqz	a7,4f2 <printint+0x56>
    buf[i++] = '-';
 4e0:	fd078793          	addi	a5,a5,-48
 4e4:	97a2                	add	a5,a5,s0
 4e6:	02d00713          	li	a4,45
 4ea:	fee78423          	sb	a4,-24(a5)
 4ee:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 4f2:	02f05a63          	blez	a5,526 <printint+0x8a>
 4f6:	fc26                	sd	s1,56(sp)
 4f8:	f44e                	sd	s3,40(sp)
 4fa:	fb840713          	addi	a4,s0,-72
 4fe:	00f704b3          	add	s1,a4,a5
 502:	fff70993          	addi	s3,a4,-1
 506:	99be                	add	s3,s3,a5
 508:	37fd                	addiw	a5,a5,-1
 50a:	1782                	slli	a5,a5,0x20
 50c:	9381                	srli	a5,a5,0x20
 50e:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 512:	fff4c583          	lbu	a1,-1(s1)
 516:	854a                	mv	a0,s2
 518:	f67ff0ef          	jal	47e <putc>
  while(--i >= 0)
 51c:	14fd                	addi	s1,s1,-1
 51e:	ff349ae3          	bne	s1,s3,512 <printint+0x76>
 522:	74e2                	ld	s1,56(sp)
 524:	79a2                	ld	s3,40(sp)
}
 526:	60a6                	ld	ra,72(sp)
 528:	6406                	ld	s0,64(sp)
 52a:	7942                	ld	s2,48(sp)
 52c:	6161                	addi	sp,sp,80
 52e:	8082                	ret
    x = -xx;
 530:	40b005b3          	neg	a1,a1
    neg = 1;
 534:	4885                	li	a7,1
    x = -xx;
 536:	bfad                	j	4b0 <printint+0x14>

0000000000000538 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 538:	711d                	addi	sp,sp,-96
 53a:	ec86                	sd	ra,88(sp)
 53c:	e8a2                	sd	s0,80(sp)
 53e:	e0ca                	sd	s2,64(sp)
 540:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 542:	0005c903          	lbu	s2,0(a1)
 546:	28090663          	beqz	s2,7d2 <vprintf+0x29a>
 54a:	e4a6                	sd	s1,72(sp)
 54c:	fc4e                	sd	s3,56(sp)
 54e:	f852                	sd	s4,48(sp)
 550:	f456                	sd	s5,40(sp)
 552:	f05a                	sd	s6,32(sp)
 554:	ec5e                	sd	s7,24(sp)
 556:	e862                	sd	s8,16(sp)
 558:	e466                	sd	s9,8(sp)
 55a:	8b2a                	mv	s6,a0
 55c:	8a2e                	mv	s4,a1
 55e:	8bb2                	mv	s7,a2
  state = 0;
 560:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 562:	4481                	li	s1,0
 564:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 566:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 56a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 56e:	06c00c93          	li	s9,108
 572:	a005                	j	592 <vprintf+0x5a>
        putc(fd, c0);
 574:	85ca                	mv	a1,s2
 576:	855a                	mv	a0,s6
 578:	f07ff0ef          	jal	47e <putc>
 57c:	a019                	j	582 <vprintf+0x4a>
    } else if(state == '%'){
 57e:	03598263          	beq	s3,s5,5a2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 582:	2485                	addiw	s1,s1,1
 584:	8726                	mv	a4,s1
 586:	009a07b3          	add	a5,s4,s1
 58a:	0007c903          	lbu	s2,0(a5)
 58e:	22090a63          	beqz	s2,7c2 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 592:	0009079b          	sext.w	a5,s2
    if(state == 0){
 596:	fe0994e3          	bnez	s3,57e <vprintf+0x46>
      if(c0 == '%'){
 59a:	fd579de3          	bne	a5,s5,574 <vprintf+0x3c>
        state = '%';
 59e:	89be                	mv	s3,a5
 5a0:	b7cd                	j	582 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5a2:	00ea06b3          	add	a3,s4,a4
 5a6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5aa:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5ac:	c681                	beqz	a3,5b4 <vprintf+0x7c>
 5ae:	9752                	add	a4,a4,s4
 5b0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5b4:	05878363          	beq	a5,s8,5fa <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5b8:	05978d63          	beq	a5,s9,612 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5bc:	07500713          	li	a4,117
 5c0:	0ee78763          	beq	a5,a4,6ae <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5c4:	07800713          	li	a4,120
 5c8:	12e78963          	beq	a5,a4,6fa <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5cc:	07000713          	li	a4,112
 5d0:	14e78e63          	beq	a5,a4,72c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5d4:	06300713          	li	a4,99
 5d8:	18e78e63          	beq	a5,a4,774 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5dc:	07300713          	li	a4,115
 5e0:	1ae78463          	beq	a5,a4,788 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5e4:	02500713          	li	a4,37
 5e8:	04e79563          	bne	a5,a4,632 <vprintf+0xfa>
        putc(fd, '%');
 5ec:	02500593          	li	a1,37
 5f0:	855a                	mv	a0,s6
 5f2:	e8dff0ef          	jal	47e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b769                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5fa:	008b8913          	addi	s2,s7,8
 5fe:	4685                	li	a3,1
 600:	4629                	li	a2,10
 602:	000ba583          	lw	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	e95ff0ef          	jal	49c <printint>
 60c:	8bca                	mv	s7,s2
      state = 0;
 60e:	4981                	li	s3,0
 610:	bf8d                	j	582 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 612:	06400793          	li	a5,100
 616:	02f68963          	beq	a3,a5,648 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 61a:	06c00793          	li	a5,108
 61e:	04f68263          	beq	a3,a5,662 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 622:	07500793          	li	a5,117
 626:	0af68063          	beq	a3,a5,6c6 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 62a:	07800793          	li	a5,120
 62e:	0ef68263          	beq	a3,a5,712 <vprintf+0x1da>
        putc(fd, '%');
 632:	02500593          	li	a1,37
 636:	855a                	mv	a0,s6
 638:	e47ff0ef          	jal	47e <putc>
        putc(fd, c0);
 63c:	85ca                	mv	a1,s2
 63e:	855a                	mv	a0,s6
 640:	e3fff0ef          	jal	47e <putc>
      state = 0;
 644:	4981                	li	s3,0
 646:	bf35                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 648:	008b8913          	addi	s2,s7,8
 64c:	4685                	li	a3,1
 64e:	4629                	li	a2,10
 650:	000bb583          	ld	a1,0(s7)
 654:	855a                	mv	a0,s6
 656:	e47ff0ef          	jal	49c <printint>
        i += 1;
 65a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 65c:	8bca                	mv	s7,s2
      state = 0;
 65e:	4981                	li	s3,0
        i += 1;
 660:	b70d                	j	582 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 662:	06400793          	li	a5,100
 666:	02f60763          	beq	a2,a5,694 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 66a:	07500793          	li	a5,117
 66e:	06f60963          	beq	a2,a5,6e0 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 672:	07800793          	li	a5,120
 676:	faf61ee3          	bne	a2,a5,632 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 67a:	008b8913          	addi	s2,s7,8
 67e:	4681                	li	a3,0
 680:	4641                	li	a2,16
 682:	000bb583          	ld	a1,0(s7)
 686:	855a                	mv	a0,s6
 688:	e15ff0ef          	jal	49c <printint>
        i += 2;
 68c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 68e:	8bca                	mv	s7,s2
      state = 0;
 690:	4981                	li	s3,0
        i += 2;
 692:	bdc5                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 694:	008b8913          	addi	s2,s7,8
 698:	4685                	li	a3,1
 69a:	4629                	li	a2,10
 69c:	000bb583          	ld	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	dfbff0ef          	jal	49c <printint>
        i += 2;
 6a6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a8:	8bca                	mv	s7,s2
      state = 0;
 6aa:	4981                	li	s3,0
        i += 2;
 6ac:	bdd9                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6ae:	008b8913          	addi	s2,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4629                	li	a2,10
 6b6:	000be583          	lwu	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	de1ff0ef          	jal	49c <printint>
 6c0:	8bca                	mv	s7,s2
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	bd7d                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c6:	008b8913          	addi	s2,s7,8
 6ca:	4681                	li	a3,0
 6cc:	4629                	li	a2,10
 6ce:	000bb583          	ld	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	dc9ff0ef          	jal	49c <printint>
        i += 1;
 6d8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6da:	8bca                	mv	s7,s2
      state = 0;
 6dc:	4981                	li	s3,0
        i += 1;
 6de:	b555                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e0:	008b8913          	addi	s2,s7,8
 6e4:	4681                	li	a3,0
 6e6:	4629                	li	a2,10
 6e8:	000bb583          	ld	a1,0(s7)
 6ec:	855a                	mv	a0,s6
 6ee:	dafff0ef          	jal	49c <printint>
        i += 2;
 6f2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f4:	8bca                	mv	s7,s2
      state = 0;
 6f6:	4981                	li	s3,0
        i += 2;
 6f8:	b569                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6fa:	008b8913          	addi	s2,s7,8
 6fe:	4681                	li	a3,0
 700:	4641                	li	a2,16
 702:	000be583          	lwu	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	d95ff0ef          	jal	49c <printint>
 70c:	8bca                	mv	s7,s2
      state = 0;
 70e:	4981                	li	s3,0
 710:	bd8d                	j	582 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 712:	008b8913          	addi	s2,s7,8
 716:	4681                	li	a3,0
 718:	4641                	li	a2,16
 71a:	000bb583          	ld	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	d7dff0ef          	jal	49c <printint>
        i += 1;
 724:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 726:	8bca                	mv	s7,s2
      state = 0;
 728:	4981                	li	s3,0
        i += 1;
 72a:	bda1                	j	582 <vprintf+0x4a>
 72c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 72e:	008b8d13          	addi	s10,s7,8
 732:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 736:	03000593          	li	a1,48
 73a:	855a                	mv	a0,s6
 73c:	d43ff0ef          	jal	47e <putc>
  putc(fd, 'x');
 740:	07800593          	li	a1,120
 744:	855a                	mv	a0,s6
 746:	d39ff0ef          	jal	47e <putc>
 74a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74c:	00000b97          	auipc	s7,0x0
 750:	494b8b93          	addi	s7,s7,1172 # be0 <digits>
 754:	03c9d793          	srli	a5,s3,0x3c
 758:	97de                	add	a5,a5,s7
 75a:	0007c583          	lbu	a1,0(a5)
 75e:	855a                	mv	a0,s6
 760:	d1fff0ef          	jal	47e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 764:	0992                	slli	s3,s3,0x4
 766:	397d                	addiw	s2,s2,-1
 768:	fe0916e3          	bnez	s2,754 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 76c:	8bea                	mv	s7,s10
      state = 0;
 76e:	4981                	li	s3,0
 770:	6d02                	ld	s10,0(sp)
 772:	bd01                	j	582 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 774:	008b8913          	addi	s2,s7,8
 778:	000bc583          	lbu	a1,0(s7)
 77c:	855a                	mv	a0,s6
 77e:	d01ff0ef          	jal	47e <putc>
 782:	8bca                	mv	s7,s2
      state = 0;
 784:	4981                	li	s3,0
 786:	bbf5                	j	582 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 788:	008b8993          	addi	s3,s7,8
 78c:	000bb903          	ld	s2,0(s7)
 790:	00090f63          	beqz	s2,7ae <vprintf+0x276>
        for(; *s; s++)
 794:	00094583          	lbu	a1,0(s2)
 798:	c195                	beqz	a1,7bc <vprintf+0x284>
          putc(fd, *s);
 79a:	855a                	mv	a0,s6
 79c:	ce3ff0ef          	jal	47e <putc>
        for(; *s; s++)
 7a0:	0905                	addi	s2,s2,1
 7a2:	00094583          	lbu	a1,0(s2)
 7a6:	f9f5                	bnez	a1,79a <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7a8:	8bce                	mv	s7,s3
      state = 0;
 7aa:	4981                	li	s3,0
 7ac:	bbd9                	j	582 <vprintf+0x4a>
          s = "(null)";
 7ae:	00000917          	auipc	s2,0x0
 7b2:	42a90913          	addi	s2,s2,1066 # bd8 <malloc+0x31e>
        for(; *s; s++)
 7b6:	02800593          	li	a1,40
 7ba:	b7c5                	j	79a <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7bc:	8bce                	mv	s7,s3
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	b3c9                	j	582 <vprintf+0x4a>
 7c2:	64a6                	ld	s1,72(sp)
 7c4:	79e2                	ld	s3,56(sp)
 7c6:	7a42                	ld	s4,48(sp)
 7c8:	7aa2                	ld	s5,40(sp)
 7ca:	7b02                	ld	s6,32(sp)
 7cc:	6be2                	ld	s7,24(sp)
 7ce:	6c42                	ld	s8,16(sp)
 7d0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7d2:	60e6                	ld	ra,88(sp)
 7d4:	6446                	ld	s0,80(sp)
 7d6:	6906                	ld	s2,64(sp)
 7d8:	6125                	addi	sp,sp,96
 7da:	8082                	ret

00000000000007dc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7dc:	715d                	addi	sp,sp,-80
 7de:	ec06                	sd	ra,24(sp)
 7e0:	e822                	sd	s0,16(sp)
 7e2:	1000                	addi	s0,sp,32
 7e4:	e010                	sd	a2,0(s0)
 7e6:	e414                	sd	a3,8(s0)
 7e8:	e818                	sd	a4,16(s0)
 7ea:	ec1c                	sd	a5,24(s0)
 7ec:	03043023          	sd	a6,32(s0)
 7f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7f8:	8622                	mv	a2,s0
 7fa:	d3fff0ef          	jal	538 <vprintf>
}
 7fe:	60e2                	ld	ra,24(sp)
 800:	6442                	ld	s0,16(sp)
 802:	6161                	addi	sp,sp,80
 804:	8082                	ret

0000000000000806 <printf>:

void
printf(const char *fmt, ...)
{
 806:	711d                	addi	sp,sp,-96
 808:	ec06                	sd	ra,24(sp)
 80a:	e822                	sd	s0,16(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	e40c                	sd	a1,8(s0)
 810:	e810                	sd	a2,16(s0)
 812:	ec14                	sd	a3,24(s0)
 814:	f018                	sd	a4,32(s0)
 816:	f41c                	sd	a5,40(s0)
 818:	03043823          	sd	a6,48(s0)
 81c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 820:	00840613          	addi	a2,s0,8
 824:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 828:	85aa                	mv	a1,a0
 82a:	4505                	li	a0,1
 82c:	d0dff0ef          	jal	538 <vprintf>
}
 830:	60e2                	ld	ra,24(sp)
 832:	6442                	ld	s0,16(sp)
 834:	6125                	addi	sp,sp,96
 836:	8082                	ret

0000000000000838 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 838:	1141                	addi	sp,sp,-16
 83a:	e422                	sd	s0,8(sp)
 83c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 83e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 842:	00001797          	auipc	a5,0x1
 846:	7be7b783          	ld	a5,1982(a5) # 2000 <freep>
 84a:	a02d                	j	874 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 84c:	4618                	lw	a4,8(a2)
 84e:	9f2d                	addw	a4,a4,a1
 850:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 854:	6398                	ld	a4,0(a5)
 856:	6310                	ld	a2,0(a4)
 858:	a83d                	j	896 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 85a:	ff852703          	lw	a4,-8(a0)
 85e:	9f31                	addw	a4,a4,a2
 860:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 862:	ff053683          	ld	a3,-16(a0)
 866:	a091                	j	8aa <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 868:	6398                	ld	a4,0(a5)
 86a:	00e7e463          	bltu	a5,a4,872 <free+0x3a>
 86e:	00e6ea63          	bltu	a3,a4,882 <free+0x4a>
{
 872:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 874:	fed7fae3          	bgeu	a5,a3,868 <free+0x30>
 878:	6398                	ld	a4,0(a5)
 87a:	00e6e463          	bltu	a3,a4,882 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87e:	fee7eae3          	bltu	a5,a4,872 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 882:	ff852583          	lw	a1,-8(a0)
 886:	6390                	ld	a2,0(a5)
 888:	02059813          	slli	a6,a1,0x20
 88c:	01c85713          	srli	a4,a6,0x1c
 890:	9736                	add	a4,a4,a3
 892:	fae60de3          	beq	a2,a4,84c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 896:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 89a:	4790                	lw	a2,8(a5)
 89c:	02061593          	slli	a1,a2,0x20
 8a0:	01c5d713          	srli	a4,a1,0x1c
 8a4:	973e                	add	a4,a4,a5
 8a6:	fae68ae3          	beq	a3,a4,85a <free+0x22>
    p->s.ptr = bp->s.ptr;
 8aa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ac:	00001717          	auipc	a4,0x1
 8b0:	74f73a23          	sd	a5,1876(a4) # 2000 <freep>
}
 8b4:	6422                	ld	s0,8(sp)
 8b6:	0141                	addi	sp,sp,16
 8b8:	8082                	ret

00000000000008ba <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ba:	7139                	addi	sp,sp,-64
 8bc:	fc06                	sd	ra,56(sp)
 8be:	f822                	sd	s0,48(sp)
 8c0:	f426                	sd	s1,40(sp)
 8c2:	ec4e                	sd	s3,24(sp)
 8c4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c6:	02051493          	slli	s1,a0,0x20
 8ca:	9081                	srli	s1,s1,0x20
 8cc:	04bd                	addi	s1,s1,15
 8ce:	8091                	srli	s1,s1,0x4
 8d0:	0014899b          	addiw	s3,s1,1
 8d4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8d6:	00001517          	auipc	a0,0x1
 8da:	72a53503          	ld	a0,1834(a0) # 2000 <freep>
 8de:	c915                	beqz	a0,912 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e2:	4798                	lw	a4,8(a5)
 8e4:	08977a63          	bgeu	a4,s1,978 <malloc+0xbe>
 8e8:	f04a                	sd	s2,32(sp)
 8ea:	e852                	sd	s4,16(sp)
 8ec:	e456                	sd	s5,8(sp)
 8ee:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8f0:	8a4e                	mv	s4,s3
 8f2:	0009871b          	sext.w	a4,s3
 8f6:	6685                	lui	a3,0x1
 8f8:	00d77363          	bgeu	a4,a3,8fe <malloc+0x44>
 8fc:	6a05                	lui	s4,0x1
 8fe:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 902:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 906:	00001917          	auipc	s2,0x1
 90a:	6fa90913          	addi	s2,s2,1786 # 2000 <freep>
  if(p == SBRK_ERROR)
 90e:	5afd                	li	s5,-1
 910:	a081                	j	950 <malloc+0x96>
 912:	f04a                	sd	s2,32(sp)
 914:	e852                	sd	s4,16(sp)
 916:	e456                	sd	s5,8(sp)
 918:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 91a:	00001797          	auipc	a5,0x1
 91e:	6f678793          	addi	a5,a5,1782 # 2010 <base>
 922:	00001717          	auipc	a4,0x1
 926:	6cf73f23          	sd	a5,1758(a4) # 2000 <freep>
 92a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 92c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 930:	b7c1                	j	8f0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 932:	6398                	ld	a4,0(a5)
 934:	e118                	sd	a4,0(a0)
 936:	a8a9                	j	990 <malloc+0xd6>
  hp->s.size = nu;
 938:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 93c:	0541                	addi	a0,a0,16
 93e:	efbff0ef          	jal	838 <free>
  return freep;
 942:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 946:	c12d                	beqz	a0,9a8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 948:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94a:	4798                	lw	a4,8(a5)
 94c:	02977263          	bgeu	a4,s1,970 <malloc+0xb6>
    if(p == freep)
 950:	00093703          	ld	a4,0(s2)
 954:	853e                	mv	a0,a5
 956:	fef719e3          	bne	a4,a5,948 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 95a:	8552                	mv	a0,s4
 95c:	a19ff0ef          	jal	374 <sbrk>
  if(p == SBRK_ERROR)
 960:	fd551ce3          	bne	a0,s5,938 <malloc+0x7e>
        return 0;
 964:	4501                	li	a0,0
 966:	7902                	ld	s2,32(sp)
 968:	6a42                	ld	s4,16(sp)
 96a:	6aa2                	ld	s5,8(sp)
 96c:	6b02                	ld	s6,0(sp)
 96e:	a03d                	j	99c <malloc+0xe2>
 970:	7902                	ld	s2,32(sp)
 972:	6a42                	ld	s4,16(sp)
 974:	6aa2                	ld	s5,8(sp)
 976:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 978:	fae48de3          	beq	s1,a4,932 <malloc+0x78>
        p->s.size -= nunits;
 97c:	4137073b          	subw	a4,a4,s3
 980:	c798                	sw	a4,8(a5)
        p += p->s.size;
 982:	02071693          	slli	a3,a4,0x20
 986:	01c6d713          	srli	a4,a3,0x1c
 98a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 98c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 990:	00001717          	auipc	a4,0x1
 994:	66a73823          	sd	a0,1648(a4) # 2000 <freep>
      return (void*)(p + 1);
 998:	01078513          	addi	a0,a5,16
  }
}
 99c:	70e2                	ld	ra,56(sp)
 99e:	7442                	ld	s0,48(sp)
 9a0:	74a2                	ld	s1,40(sp)
 9a2:	69e2                	ld	s3,24(sp)
 9a4:	6121                	addi	sp,sp,64
 9a6:	8082                	ret
 9a8:	7902                	ld	s2,32(sp)
 9aa:	6a42                	ld	s4,16(sp)
 9ac:	6aa2                	ld	s5,8(sp)
 9ae:	6b02                	ld	s6,0(sp)
 9b0:	b7f5                	j	99c <malloc+0xe2>
