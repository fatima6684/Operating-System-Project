
user/_TEST_MAIN:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
  }
}

int
main(void)
{
   0:	7131                	addi	sp,sp,-192
   2:	fd06                	sd	ra,184(sp)
   4:	f922                	sd	s0,176(sp)
   6:	0180                	addi	s0,sp,192
  char buf[128];
  uint32 src;
  uint16 sport;

  printf("bind(%d)\n", MYPORT);
   8:	45a9                	li	a1,10
   a:	00001517          	auipc	a0,0x1
   e:	a4650513          	addi	a0,a0,-1466 # a50 <malloc+0x102>
  12:	089000ef          	jal	89a <printf>
  if(bind(MYPORT) < 0){
  16:	4529                	li	a0,10
  18:	4c4000ef          	jal	4dc <bind>
  1c:	12054263          	bltz	a0,140 <main+0x140>
    printf("bind failed\n");
    exit(1);
  }

  // 1) TX test: xv6 -> host
  printf("TX test (xv6 -> host)\n");
  20:	00001517          	auipc	a0,0x1
  24:	a5050513          	addi	a0,a0,-1456 # a70 <malloc+0x122>
  28:	073000ef          	jal	89a <printf>
  int n = strlen(s);
  2c:	00001517          	auipc	a0,0x1
  30:	a5c50513          	addi	a0,a0,-1444 # a88 <malloc+0x13a>
  34:	1cc000ef          	jal	200 <strlen>
  if(send(MYPORT, HOSTIP, HOSTPORT, (char*)s, n) < 0){
  38:	0005071b          	sext.w	a4,a0
  3c:	00001697          	auipc	a3,0x1
  40:	a4c68693          	addi	a3,a3,-1460 # a88 <malloc+0x13a>
  44:	6605                	lui	a2,0x1
  46:	8ae60613          	addi	a2,a2,-1874 # 8ae <printf+0x14>
  4a:	0a0005b7          	lui	a1,0xa000
  4e:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffe1f2>
  52:	4529                	li	a0,10
  54:	498000ef          	jal	4ec <send>
  58:	10054063          	bltz	a0,158 <main+0x158>
  send_msg("TX_OK");

  // 2) RX test: host
  printf("RX test (host -> xv6). Now send UDP to host port 26999...\n");
  5c:	00001517          	auipc	a0,0x1
  60:	a4c50513          	addi	a0,a0,-1460 # aa8 <malloc+0x15a>
  64:	037000ef          	jal	89a <printf>
  int n = recv(MYPORT, &src, &sport, buf, sizeof(buf)-1);
  68:	07f00713          	li	a4,127
  6c:	f5040693          	addi	a3,s0,-176
  70:	f4a40613          	addi	a2,s0,-182
  74:	f4c40593          	addi	a1,s0,-180
  78:	4529                	li	a0,10
  7a:	47a000ef          	jal	4f4 <recv>
  if(n < 0){
  7e:	0e054963          	bltz	a0,170 <main+0x170>
  82:	f526                	sd	s1,168(sp)
  84:	f14a                	sd	s2,160(sp)
  86:	ed4e                	sd	s3,152(sp)
    printf("recv failed\n");
    exit(1);
  }
  buf[n] = 0;
  88:	fd050793          	addi	a5,a0,-48
  8c:	00878533          	add	a0,a5,s0
  90:	f8050023          	sb	zero,-128(a0)
  printf("got \"%s\" from src=%d sport=%d\n", buf, src, sport);
  94:	f4a45683          	lhu	a3,-182(s0)
  98:	f4c42603          	lw	a2,-180(s0)
  9c:	f5040593          	addi	a1,s0,-176
  a0:	00001517          	auipc	a0,0x1
  a4:	a5850513          	addi	a0,a0,-1448 # af8 <malloc+0x1aa>
  a8:	7f2000ef          	jal	89a <printf>

  printf("queue/drop test: send 30 UDP packets quickly from host now...\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	a6c50513          	addi	a0,a0,-1428 # b18 <malloc+0x1ca>
  b4:	7e6000ef          	jal	89a <printf>
  printf("receiving 16 packets (max queue size) ...\n");
  b8:	00001517          	auipc	a0,0x1
  bc:	aa050513          	addi	a0,a0,-1376 # b58 <malloc+0x20a>
  c0:	7da000ef          	jal	89a <printf>

  int got = 0;
  c4:	4481                	li	s1,0
      printf("recv error during stress\n");
      break;
    }
    buf[n] = 0;
  
    printf("stress pkt %d: %s\n", i, buf);
  c6:	00001997          	auipc	s3,0x1
  ca:	ae298993          	addi	s3,s3,-1310 # ba8 <malloc+0x25a>
  for(int i = 0; i < 16; i++){
  ce:	4941                	li	s2,16
    n = recv(MYPORT, &src, &sport, buf, sizeof(buf)-1);
  d0:	07f00713          	li	a4,127
  d4:	f5040693          	addi	a3,s0,-176
  d8:	f4a40613          	addi	a2,s0,-182
  dc:	f4c40593          	addi	a1,s0,-180
  e0:	4529                	li	a0,10
  e2:	412000ef          	jal	4f4 <recv>
    if(n < 0){
  e6:	0a054163          	bltz	a0,188 <main+0x188>
    buf[n] = 0;
  ea:	fd050793          	addi	a5,a0,-48
  ee:	00878533          	add	a0,a5,s0
  f2:	f8050023          	sb	zero,-128(a0)
    printf("stress pkt %d: %s\n", i, buf);
  f6:	f5040613          	addi	a2,s0,-176
  fa:	85a6                	mv	a1,s1
  fc:	854e                	mv	a0,s3
  fe:	79c000ef          	jal	89a <printf>
    got++;
 102:	2485                	addiw	s1,s1,1
  for(int i = 0; i < 16; i++){
 104:	fd2496e3          	bne	s1,s2,d0 <main+0xd0>
  }
  printf("received %d packets (should be 16). extra should have been dropped.\n", got);
 108:	85a6                	mv	a1,s1
 10a:	00001517          	auipc	a0,0x1
 10e:	ab650513          	addi	a0,a0,-1354 # bc0 <malloc+0x272>
 112:	788000ef          	jal	89a <printf>

  printf("unbind(%d)\n", MYPORT);
 116:	45a9                	li	a1,10
 118:	00001517          	auipc	a0,0x1
 11c:	af050513          	addi	a0,a0,-1296 # c08 <malloc+0x2ba>
 120:	77a000ef          	jal	89a <printf>
  if(unbind(MYPORT) < 0){
 124:	4529                	li	a0,10
 126:	3be000ef          	jal	4e4 <unbind>
 12a:	06054663          	bltz	a0,196 <main+0x196>
    printf("unbind failed\n");
    exit(1);
  }

  printf("fullnet: DONE (no crash, queue limit enforced, unbind drops packets)\n");
 12e:	00001517          	auipc	a0,0x1
 132:	afa50513          	addi	a0,a0,-1286 # c28 <malloc+0x2da>
 136:	764000ef          	jal	89a <printf>

  exit(0);
 13a:	4501                	li	a0,0
 13c:	300000ef          	jal	43c <exit>
 140:	f526                	sd	s1,168(sp)
 142:	f14a                	sd	s2,160(sp)
 144:	ed4e                	sd	s3,152(sp)
    printf("bind failed\n");
 146:	00001517          	auipc	a0,0x1
 14a:	91a50513          	addi	a0,a0,-1766 # a60 <malloc+0x112>
 14e:	74c000ef          	jal	89a <printf>
    exit(1);
 152:	4505                	li	a0,1
 154:	2e8000ef          	jal	43c <exit>
 158:	f526                	sd	s1,168(sp)
 15a:	f14a                	sd	s2,160(sp)
 15c:	ed4e                	sd	s3,152(sp)
    printf("fullnet: send failed\n");
 15e:	00001517          	auipc	a0,0x1
 162:	93250513          	addi	a0,a0,-1742 # a90 <malloc+0x142>
 166:	734000ef          	jal	89a <printf>
    exit(1);
 16a:	4505                	li	a0,1
 16c:	2d0000ef          	jal	43c <exit>
 170:	f526                	sd	s1,168(sp)
 172:	f14a                	sd	s2,160(sp)
 174:	ed4e                	sd	s3,152(sp)
    printf("recv failed\n");
 176:	00001517          	auipc	a0,0x1
 17a:	97250513          	addi	a0,a0,-1678 # ae8 <malloc+0x19a>
 17e:	71c000ef          	jal	89a <printf>
    exit(1);
 182:	4505                	li	a0,1
 184:	2b8000ef          	jal	43c <exit>
      printf("recv error during stress\n");
 188:	00001517          	auipc	a0,0x1
 18c:	a0050513          	addi	a0,a0,-1536 # b88 <malloc+0x23a>
 190:	70a000ef          	jal	89a <printf>
      break;
 194:	bf95                	j	108 <main+0x108>
    printf("unbind failed\n");
 196:	00001517          	auipc	a0,0x1
 19a:	a8250513          	addi	a0,a0,-1406 # c18 <malloc+0x2ca>
 19e:	6fc000ef          	jal	89a <printf>
    exit(1);
 1a2:	4505                	li	a0,1
 1a4:	298000ef          	jal	43c <exit>

00000000000001a8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e406                	sd	ra,8(sp)
 1ac:	e022                	sd	s0,0(sp)
 1ae:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 1b0:	e51ff0ef          	jal	0 <main>
  exit(r);
 1b4:	288000ef          	jal	43c <exit>

00000000000001b8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1be:	87aa                	mv	a5,a0
 1c0:	0585                	addi	a1,a1,1
 1c2:	0785                	addi	a5,a5,1
 1c4:	fff5c703          	lbu	a4,-1(a1)
 1c8:	fee78fa3          	sb	a4,-1(a5)
 1cc:	fb75                	bnez	a4,1c0 <strcpy+0x8>
    ;
  return os;
}
 1ce:	6422                	ld	s0,8(sp)
 1d0:	0141                	addi	sp,sp,16
 1d2:	8082                	ret

00000000000001d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1da:	00054783          	lbu	a5,0(a0)
 1de:	cb91                	beqz	a5,1f2 <strcmp+0x1e>
 1e0:	0005c703          	lbu	a4,0(a1)
 1e4:	00f71763          	bne	a4,a5,1f2 <strcmp+0x1e>
    p++, q++;
 1e8:	0505                	addi	a0,a0,1
 1ea:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ec:	00054783          	lbu	a5,0(a0)
 1f0:	fbe5                	bnez	a5,1e0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1f2:	0005c503          	lbu	a0,0(a1)
}
 1f6:	40a7853b          	subw	a0,a5,a0
 1fa:	6422                	ld	s0,8(sp)
 1fc:	0141                	addi	sp,sp,16
 1fe:	8082                	ret

0000000000000200 <strlen>:

uint
strlen(const char *s)
{
 200:	1141                	addi	sp,sp,-16
 202:	e422                	sd	s0,8(sp)
 204:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 206:	00054783          	lbu	a5,0(a0)
 20a:	cf91                	beqz	a5,226 <strlen+0x26>
 20c:	0505                	addi	a0,a0,1
 20e:	87aa                	mv	a5,a0
 210:	86be                	mv	a3,a5
 212:	0785                	addi	a5,a5,1
 214:	fff7c703          	lbu	a4,-1(a5)
 218:	ff65                	bnez	a4,210 <strlen+0x10>
 21a:	40a6853b          	subw	a0,a3,a0
 21e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 220:	6422                	ld	s0,8(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret
  for(n = 0; s[n]; n++)
 226:	4501                	li	a0,0
 228:	bfe5                	j	220 <strlen+0x20>

000000000000022a <memset>:

void*
memset(void *dst, int c, uint n)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e422                	sd	s0,8(sp)
 22e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 230:	ca19                	beqz	a2,246 <memset+0x1c>
 232:	87aa                	mv	a5,a0
 234:	1602                	slli	a2,a2,0x20
 236:	9201                	srli	a2,a2,0x20
 238:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 23c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 240:	0785                	addi	a5,a5,1
 242:	fee79de3          	bne	a5,a4,23c <memset+0x12>
  }
  return dst;
}
 246:	6422                	ld	s0,8(sp)
 248:	0141                	addi	sp,sp,16
 24a:	8082                	ret

000000000000024c <strchr>:

char*
strchr(const char *s, char c)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  for(; *s; s++)
 252:	00054783          	lbu	a5,0(a0)
 256:	cb99                	beqz	a5,26c <strchr+0x20>
    if(*s == c)
 258:	00f58763          	beq	a1,a5,266 <strchr+0x1a>
  for(; *s; s++)
 25c:	0505                	addi	a0,a0,1
 25e:	00054783          	lbu	a5,0(a0)
 262:	fbfd                	bnez	a5,258 <strchr+0xc>
      return (char*)s;
  return 0;
 264:	4501                	li	a0,0
}
 266:	6422                	ld	s0,8(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret
  return 0;
 26c:	4501                	li	a0,0
 26e:	bfe5                	j	266 <strchr+0x1a>

0000000000000270 <gets>:

char*
gets(char *buf, int max)
{
 270:	711d                	addi	sp,sp,-96
 272:	ec86                	sd	ra,88(sp)
 274:	e8a2                	sd	s0,80(sp)
 276:	e4a6                	sd	s1,72(sp)
 278:	e0ca                	sd	s2,64(sp)
 27a:	fc4e                	sd	s3,56(sp)
 27c:	f852                	sd	s4,48(sp)
 27e:	f456                	sd	s5,40(sp)
 280:	f05a                	sd	s6,32(sp)
 282:	ec5e                	sd	s7,24(sp)
 284:	1080                	addi	s0,sp,96
 286:	8baa                	mv	s7,a0
 288:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28a:	892a                	mv	s2,a0
 28c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 28e:	4aa9                	li	s5,10
 290:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 292:	89a6                	mv	s3,s1
 294:	2485                	addiw	s1,s1,1
 296:	0344d663          	bge	s1,s4,2c2 <gets+0x52>
    cc = read(0, &c, 1);
 29a:	4605                	li	a2,1
 29c:	faf40593          	addi	a1,s0,-81
 2a0:	4501                	li	a0,0
 2a2:	1b2000ef          	jal	454 <read>
    if(cc < 1)
 2a6:	00a05e63          	blez	a0,2c2 <gets+0x52>
    buf[i++] = c;
 2aa:	faf44783          	lbu	a5,-81(s0)
 2ae:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2b2:	01578763          	beq	a5,s5,2c0 <gets+0x50>
 2b6:	0905                	addi	s2,s2,1
 2b8:	fd679de3          	bne	a5,s6,292 <gets+0x22>
    buf[i++] = c;
 2bc:	89a6                	mv	s3,s1
 2be:	a011                	j	2c2 <gets+0x52>
 2c0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2c2:	99de                	add	s3,s3,s7
 2c4:	00098023          	sb	zero,0(s3)
  return buf;
}
 2c8:	855e                	mv	a0,s7
 2ca:	60e6                	ld	ra,88(sp)
 2cc:	6446                	ld	s0,80(sp)
 2ce:	64a6                	ld	s1,72(sp)
 2d0:	6906                	ld	s2,64(sp)
 2d2:	79e2                	ld	s3,56(sp)
 2d4:	7a42                	ld	s4,48(sp)
 2d6:	7aa2                	ld	s5,40(sp)
 2d8:	7b02                	ld	s6,32(sp)
 2da:	6be2                	ld	s7,24(sp)
 2dc:	6125                	addi	sp,sp,96
 2de:	8082                	ret

00000000000002e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2e0:	1101                	addi	sp,sp,-32
 2e2:	ec06                	sd	ra,24(sp)
 2e4:	e822                	sd	s0,16(sp)
 2e6:	e04a                	sd	s2,0(sp)
 2e8:	1000                	addi	s0,sp,32
 2ea:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ec:	4581                	li	a1,0
 2ee:	18e000ef          	jal	47c <open>
  if(fd < 0)
 2f2:	02054263          	bltz	a0,316 <stat+0x36>
 2f6:	e426                	sd	s1,8(sp)
 2f8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2fa:	85ca                	mv	a1,s2
 2fc:	198000ef          	jal	494 <fstat>
 300:	892a                	mv	s2,a0
  close(fd);
 302:	8526                	mv	a0,s1
 304:	160000ef          	jal	464 <close>
  return r;
 308:	64a2                	ld	s1,8(sp)
}
 30a:	854a                	mv	a0,s2
 30c:	60e2                	ld	ra,24(sp)
 30e:	6442                	ld	s0,16(sp)
 310:	6902                	ld	s2,0(sp)
 312:	6105                	addi	sp,sp,32
 314:	8082                	ret
    return -1;
 316:	597d                	li	s2,-1
 318:	bfcd                	j	30a <stat+0x2a>

000000000000031a <atoi>:

int
atoi(const char *s)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e422                	sd	s0,8(sp)
 31e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 320:	00054683          	lbu	a3,0(a0)
 324:	fd06879b          	addiw	a5,a3,-48
 328:	0ff7f793          	zext.b	a5,a5
 32c:	4625                	li	a2,9
 32e:	02f66863          	bltu	a2,a5,35e <atoi+0x44>
 332:	872a                	mv	a4,a0
  n = 0;
 334:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 336:	0705                	addi	a4,a4,1
 338:	0025179b          	slliw	a5,a0,0x2
 33c:	9fa9                	addw	a5,a5,a0
 33e:	0017979b          	slliw	a5,a5,0x1
 342:	9fb5                	addw	a5,a5,a3
 344:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 348:	00074683          	lbu	a3,0(a4)
 34c:	fd06879b          	addiw	a5,a3,-48
 350:	0ff7f793          	zext.b	a5,a5
 354:	fef671e3          	bgeu	a2,a5,336 <atoi+0x1c>
  return n;
}
 358:	6422                	ld	s0,8(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret
  n = 0;
 35e:	4501                	li	a0,0
 360:	bfe5                	j	358 <atoi+0x3e>

0000000000000362 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 362:	1141                	addi	sp,sp,-16
 364:	e422                	sd	s0,8(sp)
 366:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 368:	02b57463          	bgeu	a0,a1,390 <memmove+0x2e>
    while(n-- > 0)
 36c:	00c05f63          	blez	a2,38a <memmove+0x28>
 370:	1602                	slli	a2,a2,0x20
 372:	9201                	srli	a2,a2,0x20
 374:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 378:	872a                	mv	a4,a0
      *dst++ = *src++;
 37a:	0585                	addi	a1,a1,1
 37c:	0705                	addi	a4,a4,1
 37e:	fff5c683          	lbu	a3,-1(a1)
 382:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 386:	fef71ae3          	bne	a4,a5,37a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 38a:	6422                	ld	s0,8(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret
    dst += n;
 390:	00c50733          	add	a4,a0,a2
    src += n;
 394:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 396:	fec05ae3          	blez	a2,38a <memmove+0x28>
 39a:	fff6079b          	addiw	a5,a2,-1
 39e:	1782                	slli	a5,a5,0x20
 3a0:	9381                	srli	a5,a5,0x20
 3a2:	fff7c793          	not	a5,a5
 3a6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3a8:	15fd                	addi	a1,a1,-1
 3aa:	177d                	addi	a4,a4,-1
 3ac:	0005c683          	lbu	a3,0(a1)
 3b0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3b4:	fee79ae3          	bne	a5,a4,3a8 <memmove+0x46>
 3b8:	bfc9                	j	38a <memmove+0x28>

00000000000003ba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e422                	sd	s0,8(sp)
 3be:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c0:	ca05                	beqz	a2,3f0 <memcmp+0x36>
 3c2:	fff6069b          	addiw	a3,a2,-1
 3c6:	1682                	slli	a3,a3,0x20
 3c8:	9281                	srli	a3,a3,0x20
 3ca:	0685                	addi	a3,a3,1
 3cc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ce:	00054783          	lbu	a5,0(a0)
 3d2:	0005c703          	lbu	a4,0(a1)
 3d6:	00e79863          	bne	a5,a4,3e6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3da:	0505                	addi	a0,a0,1
    p2++;
 3dc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3de:	fed518e3          	bne	a0,a3,3ce <memcmp+0x14>
  }
  return 0;
 3e2:	4501                	li	a0,0
 3e4:	a019                	j	3ea <memcmp+0x30>
      return *p1 - *p2;
 3e6:	40e7853b          	subw	a0,a5,a4
}
 3ea:	6422                	ld	s0,8(sp)
 3ec:	0141                	addi	sp,sp,16
 3ee:	8082                	ret
  return 0;
 3f0:	4501                	li	a0,0
 3f2:	bfe5                	j	3ea <memcmp+0x30>

00000000000003f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e406                	sd	ra,8(sp)
 3f8:	e022                	sd	s0,0(sp)
 3fa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3fc:	f67ff0ef          	jal	362 <memmove>
}
 400:	60a2                	ld	ra,8(sp)
 402:	6402                	ld	s0,0(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret

0000000000000408 <sbrk>:

char *
sbrk(int n) {
 408:	1141                	addi	sp,sp,-16
 40a:	e406                	sd	ra,8(sp)
 40c:	e022                	sd	s0,0(sp)
 40e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 410:	4585                	li	a1,1
 412:	0b2000ef          	jal	4c4 <sys_sbrk>
}
 416:	60a2                	ld	ra,8(sp)
 418:	6402                	ld	s0,0(sp)
 41a:	0141                	addi	sp,sp,16
 41c:	8082                	ret

000000000000041e <sbrklazy>:

char *
sbrklazy(int n) {
 41e:	1141                	addi	sp,sp,-16
 420:	e406                	sd	ra,8(sp)
 422:	e022                	sd	s0,0(sp)
 424:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 426:	4589                	li	a1,2
 428:	09c000ef          	jal	4c4 <sys_sbrk>
}
 42c:	60a2                	ld	ra,8(sp)
 42e:	6402                	ld	s0,0(sp)
 430:	0141                	addi	sp,sp,16
 432:	8082                	ret

0000000000000434 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 434:	4885                	li	a7,1
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <exit>:
.global exit
exit:
 li a7, SYS_exit
 43c:	4889                	li	a7,2
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <wait>:
.global wait
wait:
 li a7, SYS_wait
 444:	488d                	li	a7,3
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 44c:	4891                	li	a7,4
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <read>:
.global read
read:
 li a7, SYS_read
 454:	4895                	li	a7,5
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <write>:
.global write
write:
 li a7, SYS_write
 45c:	48c1                	li	a7,16
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <close>:
.global close
close:
 li a7, SYS_close
 464:	48d5                	li	a7,21
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <kill>:
.global kill
kill:
 li a7, SYS_kill
 46c:	4899                	li	a7,6
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <exec>:
.global exec
exec:
 li a7, SYS_exec
 474:	489d                	li	a7,7
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <open>:
.global open
open:
 li a7, SYS_open
 47c:	48bd                	li	a7,15
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 484:	48c5                	li	a7,17
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 48c:	48c9                	li	a7,18
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 494:	48a1                	li	a7,8
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <link>:
.global link
link:
 li a7, SYS_link
 49c:	48cd                	li	a7,19
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4a4:	48d1                	li	a7,20
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ac:	48a5                	li	a7,9
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4b4:	48a9                	li	a7,10
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4bc:	48ad                	li	a7,11
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4c4:	48b1                	li	a7,12
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <pause>:
.global pause
pause:
 li a7, SYS_pause
 4cc:	48b5                	li	a7,13
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4d4:	48b9                	li	a7,14
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <bind>:
.global bind
bind:
 li a7, SYS_bind
 4dc:	48f5                	li	a7,29
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 4e4:	48f9                	li	a7,30
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <send>:
.global send
send:
 li a7, SYS_send
 4ec:	48fd                	li	a7,31
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <recv>:
.global recv
recv:
 li a7, SYS_recv
 4f4:	02000893          	li	a7,32
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 4fe:	02100893          	li	a7,33
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 508:	02200893          	li	a7,34
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 512:	1101                	addi	sp,sp,-32
 514:	ec06                	sd	ra,24(sp)
 516:	e822                	sd	s0,16(sp)
 518:	1000                	addi	s0,sp,32
 51a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 51e:	4605                	li	a2,1
 520:	fef40593          	addi	a1,s0,-17
 524:	f39ff0ef          	jal	45c <write>
}
 528:	60e2                	ld	ra,24(sp)
 52a:	6442                	ld	s0,16(sp)
 52c:	6105                	addi	sp,sp,32
 52e:	8082                	ret

0000000000000530 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 530:	715d                	addi	sp,sp,-80
 532:	e486                	sd	ra,72(sp)
 534:	e0a2                	sd	s0,64(sp)
 536:	f84a                	sd	s2,48(sp)
 538:	0880                	addi	s0,sp,80
 53a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 53c:	c299                	beqz	a3,542 <printint+0x12>
 53e:	0805c363          	bltz	a1,5c4 <printint+0x94>
  neg = 0;
 542:	4881                	li	a7,0
 544:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 548:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 54a:	00000517          	auipc	a0,0x0
 54e:	72e50513          	addi	a0,a0,1838 # c78 <digits>
 552:	883e                	mv	a6,a5
 554:	2785                	addiw	a5,a5,1
 556:	02c5f733          	remu	a4,a1,a2
 55a:	972a                	add	a4,a4,a0
 55c:	00074703          	lbu	a4,0(a4)
 560:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 564:	872e                	mv	a4,a1
 566:	02c5d5b3          	divu	a1,a1,a2
 56a:	0685                	addi	a3,a3,1
 56c:	fec773e3          	bgeu	a4,a2,552 <printint+0x22>
  if(neg)
 570:	00088b63          	beqz	a7,586 <printint+0x56>
    buf[i++] = '-';
 574:	fd078793          	addi	a5,a5,-48
 578:	97a2                	add	a5,a5,s0
 57a:	02d00713          	li	a4,45
 57e:	fee78423          	sb	a4,-24(a5)
 582:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 586:	02f05a63          	blez	a5,5ba <printint+0x8a>
 58a:	fc26                	sd	s1,56(sp)
 58c:	f44e                	sd	s3,40(sp)
 58e:	fb840713          	addi	a4,s0,-72
 592:	00f704b3          	add	s1,a4,a5
 596:	fff70993          	addi	s3,a4,-1
 59a:	99be                	add	s3,s3,a5
 59c:	37fd                	addiw	a5,a5,-1
 59e:	1782                	slli	a5,a5,0x20
 5a0:	9381                	srli	a5,a5,0x20
 5a2:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 5a6:	fff4c583          	lbu	a1,-1(s1)
 5aa:	854a                	mv	a0,s2
 5ac:	f67ff0ef          	jal	512 <putc>
  while(--i >= 0)
 5b0:	14fd                	addi	s1,s1,-1
 5b2:	ff349ae3          	bne	s1,s3,5a6 <printint+0x76>
 5b6:	74e2                	ld	s1,56(sp)
 5b8:	79a2                	ld	s3,40(sp)
}
 5ba:	60a6                	ld	ra,72(sp)
 5bc:	6406                	ld	s0,64(sp)
 5be:	7942                	ld	s2,48(sp)
 5c0:	6161                	addi	sp,sp,80
 5c2:	8082                	ret
    x = -xx;
 5c4:	40b005b3          	neg	a1,a1
    neg = 1;
 5c8:	4885                	li	a7,1
    x = -xx;
 5ca:	bfad                	j	544 <printint+0x14>

00000000000005cc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5cc:	711d                	addi	sp,sp,-96
 5ce:	ec86                	sd	ra,88(sp)
 5d0:	e8a2                	sd	s0,80(sp)
 5d2:	e0ca                	sd	s2,64(sp)
 5d4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5d6:	0005c903          	lbu	s2,0(a1)
 5da:	28090663          	beqz	s2,866 <vprintf+0x29a>
 5de:	e4a6                	sd	s1,72(sp)
 5e0:	fc4e                	sd	s3,56(sp)
 5e2:	f852                	sd	s4,48(sp)
 5e4:	f456                	sd	s5,40(sp)
 5e6:	f05a                	sd	s6,32(sp)
 5e8:	ec5e                	sd	s7,24(sp)
 5ea:	e862                	sd	s8,16(sp)
 5ec:	e466                	sd	s9,8(sp)
 5ee:	8b2a                	mv	s6,a0
 5f0:	8a2e                	mv	s4,a1
 5f2:	8bb2                	mv	s7,a2
  state = 0;
 5f4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5f6:	4481                	li	s1,0
 5f8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5fa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5fe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 602:	06c00c93          	li	s9,108
 606:	a005                	j	626 <vprintf+0x5a>
        putc(fd, c0);
 608:	85ca                	mv	a1,s2
 60a:	855a                	mv	a0,s6
 60c:	f07ff0ef          	jal	512 <putc>
 610:	a019                	j	616 <vprintf+0x4a>
    } else if(state == '%'){
 612:	03598263          	beq	s3,s5,636 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 616:	2485                	addiw	s1,s1,1
 618:	8726                	mv	a4,s1
 61a:	009a07b3          	add	a5,s4,s1
 61e:	0007c903          	lbu	s2,0(a5)
 622:	22090a63          	beqz	s2,856 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 626:	0009079b          	sext.w	a5,s2
    if(state == 0){
 62a:	fe0994e3          	bnez	s3,612 <vprintf+0x46>
      if(c0 == '%'){
 62e:	fd579de3          	bne	a5,s5,608 <vprintf+0x3c>
        state = '%';
 632:	89be                	mv	s3,a5
 634:	b7cd                	j	616 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 636:	00ea06b3          	add	a3,s4,a4
 63a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 63e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 640:	c681                	beqz	a3,648 <vprintf+0x7c>
 642:	9752                	add	a4,a4,s4
 644:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 648:	05878363          	beq	a5,s8,68e <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 64c:	05978d63          	beq	a5,s9,6a6 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 650:	07500713          	li	a4,117
 654:	0ee78763          	beq	a5,a4,742 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 658:	07800713          	li	a4,120
 65c:	12e78963          	beq	a5,a4,78e <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 660:	07000713          	li	a4,112
 664:	14e78e63          	beq	a5,a4,7c0 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 668:	06300713          	li	a4,99
 66c:	18e78e63          	beq	a5,a4,808 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 670:	07300713          	li	a4,115
 674:	1ae78463          	beq	a5,a4,81c <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 678:	02500713          	li	a4,37
 67c:	04e79563          	bne	a5,a4,6c6 <vprintf+0xfa>
        putc(fd, '%');
 680:	02500593          	li	a1,37
 684:	855a                	mv	a0,s6
 686:	e8dff0ef          	jal	512 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 68a:	4981                	li	s3,0
 68c:	b769                	j	616 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 68e:	008b8913          	addi	s2,s7,8
 692:	4685                	li	a3,1
 694:	4629                	li	a2,10
 696:	000ba583          	lw	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	e95ff0ef          	jal	530 <printint>
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bf8d                	j	616 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6a6:	06400793          	li	a5,100
 6aa:	02f68963          	beq	a3,a5,6dc <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6ae:	06c00793          	li	a5,108
 6b2:	04f68263          	beq	a3,a5,6f6 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 6b6:	07500793          	li	a5,117
 6ba:	0af68063          	beq	a3,a5,75a <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 6be:	07800793          	li	a5,120
 6c2:	0ef68263          	beq	a3,a5,7a6 <vprintf+0x1da>
        putc(fd, '%');
 6c6:	02500593          	li	a1,37
 6ca:	855a                	mv	a0,s6
 6cc:	e47ff0ef          	jal	512 <putc>
        putc(fd, c0);
 6d0:	85ca                	mv	a1,s2
 6d2:	855a                	mv	a0,s6
 6d4:	e3fff0ef          	jal	512 <putc>
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bf35                	j	616 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6dc:	008b8913          	addi	s2,s7,8
 6e0:	4685                	li	a3,1
 6e2:	4629                	li	a2,10
 6e4:	000bb583          	ld	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	e47ff0ef          	jal	530 <printint>
        i += 1;
 6ee:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f0:	8bca                	mv	s7,s2
      state = 0;
 6f2:	4981                	li	s3,0
        i += 1;
 6f4:	b70d                	j	616 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f6:	06400793          	li	a5,100
 6fa:	02f60763          	beq	a2,a5,728 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6fe:	07500793          	li	a5,117
 702:	06f60963          	beq	a2,a5,774 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 706:	07800793          	li	a5,120
 70a:	faf61ee3          	bne	a2,a5,6c6 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 70e:	008b8913          	addi	s2,s7,8
 712:	4681                	li	a3,0
 714:	4641                	li	a2,16
 716:	000bb583          	ld	a1,0(s7)
 71a:	855a                	mv	a0,s6
 71c:	e15ff0ef          	jal	530 <printint>
        i += 2;
 720:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 722:	8bca                	mv	s7,s2
      state = 0;
 724:	4981                	li	s3,0
        i += 2;
 726:	bdc5                	j	616 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 728:	008b8913          	addi	s2,s7,8
 72c:	4685                	li	a3,1
 72e:	4629                	li	a2,10
 730:	000bb583          	ld	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	dfbff0ef          	jal	530 <printint>
        i += 2;
 73a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 73c:	8bca                	mv	s7,s2
      state = 0;
 73e:	4981                	li	s3,0
        i += 2;
 740:	bdd9                	j	616 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 742:	008b8913          	addi	s2,s7,8
 746:	4681                	li	a3,0
 748:	4629                	li	a2,10
 74a:	000be583          	lwu	a1,0(s7)
 74e:	855a                	mv	a0,s6
 750:	de1ff0ef          	jal	530 <printint>
 754:	8bca                	mv	s7,s2
      state = 0;
 756:	4981                	li	s3,0
 758:	bd7d                	j	616 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 75a:	008b8913          	addi	s2,s7,8
 75e:	4681                	li	a3,0
 760:	4629                	li	a2,10
 762:	000bb583          	ld	a1,0(s7)
 766:	855a                	mv	a0,s6
 768:	dc9ff0ef          	jal	530 <printint>
        i += 1;
 76c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 76e:	8bca                	mv	s7,s2
      state = 0;
 770:	4981                	li	s3,0
        i += 1;
 772:	b555                	j	616 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 774:	008b8913          	addi	s2,s7,8
 778:	4681                	li	a3,0
 77a:	4629                	li	a2,10
 77c:	000bb583          	ld	a1,0(s7)
 780:	855a                	mv	a0,s6
 782:	dafff0ef          	jal	530 <printint>
        i += 2;
 786:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 788:	8bca                	mv	s7,s2
      state = 0;
 78a:	4981                	li	s3,0
        i += 2;
 78c:	b569                	j	616 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 78e:	008b8913          	addi	s2,s7,8
 792:	4681                	li	a3,0
 794:	4641                	li	a2,16
 796:	000be583          	lwu	a1,0(s7)
 79a:	855a                	mv	a0,s6
 79c:	d95ff0ef          	jal	530 <printint>
 7a0:	8bca                	mv	s7,s2
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	bd8d                	j	616 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a6:	008b8913          	addi	s2,s7,8
 7aa:	4681                	li	a3,0
 7ac:	4641                	li	a2,16
 7ae:	000bb583          	ld	a1,0(s7)
 7b2:	855a                	mv	a0,s6
 7b4:	d7dff0ef          	jal	530 <printint>
        i += 1;
 7b8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ba:	8bca                	mv	s7,s2
      state = 0;
 7bc:	4981                	li	s3,0
        i += 1;
 7be:	bda1                	j	616 <vprintf+0x4a>
 7c0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7c2:	008b8d13          	addi	s10,s7,8
 7c6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7ca:	03000593          	li	a1,48
 7ce:	855a                	mv	a0,s6
 7d0:	d43ff0ef          	jal	512 <putc>
  putc(fd, 'x');
 7d4:	07800593          	li	a1,120
 7d8:	855a                	mv	a0,s6
 7da:	d39ff0ef          	jal	512 <putc>
 7de:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e0:	00000b97          	auipc	s7,0x0
 7e4:	498b8b93          	addi	s7,s7,1176 # c78 <digits>
 7e8:	03c9d793          	srli	a5,s3,0x3c
 7ec:	97de                	add	a5,a5,s7
 7ee:	0007c583          	lbu	a1,0(a5)
 7f2:	855a                	mv	a0,s6
 7f4:	d1fff0ef          	jal	512 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7f8:	0992                	slli	s3,s3,0x4
 7fa:	397d                	addiw	s2,s2,-1
 7fc:	fe0916e3          	bnez	s2,7e8 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 800:	8bea                	mv	s7,s10
      state = 0;
 802:	4981                	li	s3,0
 804:	6d02                	ld	s10,0(sp)
 806:	bd01                	j	616 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 808:	008b8913          	addi	s2,s7,8
 80c:	000bc583          	lbu	a1,0(s7)
 810:	855a                	mv	a0,s6
 812:	d01ff0ef          	jal	512 <putc>
 816:	8bca                	mv	s7,s2
      state = 0;
 818:	4981                	li	s3,0
 81a:	bbf5                	j	616 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 81c:	008b8993          	addi	s3,s7,8
 820:	000bb903          	ld	s2,0(s7)
 824:	00090f63          	beqz	s2,842 <vprintf+0x276>
        for(; *s; s++)
 828:	00094583          	lbu	a1,0(s2)
 82c:	c195                	beqz	a1,850 <vprintf+0x284>
          putc(fd, *s);
 82e:	855a                	mv	a0,s6
 830:	ce3ff0ef          	jal	512 <putc>
        for(; *s; s++)
 834:	0905                	addi	s2,s2,1
 836:	00094583          	lbu	a1,0(s2)
 83a:	f9f5                	bnez	a1,82e <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 83c:	8bce                	mv	s7,s3
      state = 0;
 83e:	4981                	li	s3,0
 840:	bbd9                	j	616 <vprintf+0x4a>
          s = "(null)";
 842:	00000917          	auipc	s2,0x0
 846:	42e90913          	addi	s2,s2,1070 # c70 <malloc+0x322>
        for(; *s; s++)
 84a:	02800593          	li	a1,40
 84e:	b7c5                	j	82e <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 850:	8bce                	mv	s7,s3
      state = 0;
 852:	4981                	li	s3,0
 854:	b3c9                	j	616 <vprintf+0x4a>
 856:	64a6                	ld	s1,72(sp)
 858:	79e2                	ld	s3,56(sp)
 85a:	7a42                	ld	s4,48(sp)
 85c:	7aa2                	ld	s5,40(sp)
 85e:	7b02                	ld	s6,32(sp)
 860:	6be2                	ld	s7,24(sp)
 862:	6c42                	ld	s8,16(sp)
 864:	6ca2                	ld	s9,8(sp)
    }
  }
}
 866:	60e6                	ld	ra,88(sp)
 868:	6446                	ld	s0,80(sp)
 86a:	6906                	ld	s2,64(sp)
 86c:	6125                	addi	sp,sp,96
 86e:	8082                	ret

0000000000000870 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 870:	715d                	addi	sp,sp,-80
 872:	ec06                	sd	ra,24(sp)
 874:	e822                	sd	s0,16(sp)
 876:	1000                	addi	s0,sp,32
 878:	e010                	sd	a2,0(s0)
 87a:	e414                	sd	a3,8(s0)
 87c:	e818                	sd	a4,16(s0)
 87e:	ec1c                	sd	a5,24(s0)
 880:	03043023          	sd	a6,32(s0)
 884:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 888:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 88c:	8622                	mv	a2,s0
 88e:	d3fff0ef          	jal	5cc <vprintf>
}
 892:	60e2                	ld	ra,24(sp)
 894:	6442                	ld	s0,16(sp)
 896:	6161                	addi	sp,sp,80
 898:	8082                	ret

000000000000089a <printf>:

void
printf(const char *fmt, ...)
{
 89a:	711d                	addi	sp,sp,-96
 89c:	ec06                	sd	ra,24(sp)
 89e:	e822                	sd	s0,16(sp)
 8a0:	1000                	addi	s0,sp,32
 8a2:	e40c                	sd	a1,8(s0)
 8a4:	e810                	sd	a2,16(s0)
 8a6:	ec14                	sd	a3,24(s0)
 8a8:	f018                	sd	a4,32(s0)
 8aa:	f41c                	sd	a5,40(s0)
 8ac:	03043823          	sd	a6,48(s0)
 8b0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8b4:	00840613          	addi	a2,s0,8
 8b8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8bc:	85aa                	mv	a1,a0
 8be:	4505                	li	a0,1
 8c0:	d0dff0ef          	jal	5cc <vprintf>
}
 8c4:	60e2                	ld	ra,24(sp)
 8c6:	6442                	ld	s0,16(sp)
 8c8:	6125                	addi	sp,sp,96
 8ca:	8082                	ret

00000000000008cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8cc:	1141                	addi	sp,sp,-16
 8ce:	e422                	sd	s0,8(sp)
 8d0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8d2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d6:	00001797          	auipc	a5,0x1
 8da:	72a7b783          	ld	a5,1834(a5) # 2000 <freep>
 8de:	a02d                	j	908 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8e0:	4618                	lw	a4,8(a2)
 8e2:	9f2d                	addw	a4,a4,a1
 8e4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e8:	6398                	ld	a4,0(a5)
 8ea:	6310                	ld	a2,0(a4)
 8ec:	a83d                	j	92a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8ee:	ff852703          	lw	a4,-8(a0)
 8f2:	9f31                	addw	a4,a4,a2
 8f4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8f6:	ff053683          	ld	a3,-16(a0)
 8fa:	a091                	j	93e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fc:	6398                	ld	a4,0(a5)
 8fe:	00e7e463          	bltu	a5,a4,906 <free+0x3a>
 902:	00e6ea63          	bltu	a3,a4,916 <free+0x4a>
{
 906:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 908:	fed7fae3          	bgeu	a5,a3,8fc <free+0x30>
 90c:	6398                	ld	a4,0(a5)
 90e:	00e6e463          	bltu	a3,a4,916 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 912:	fee7eae3          	bltu	a5,a4,906 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 916:	ff852583          	lw	a1,-8(a0)
 91a:	6390                	ld	a2,0(a5)
 91c:	02059813          	slli	a6,a1,0x20
 920:	01c85713          	srli	a4,a6,0x1c
 924:	9736                	add	a4,a4,a3
 926:	fae60de3          	beq	a2,a4,8e0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 92a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 92e:	4790                	lw	a2,8(a5)
 930:	02061593          	slli	a1,a2,0x20
 934:	01c5d713          	srli	a4,a1,0x1c
 938:	973e                	add	a4,a4,a5
 93a:	fae68ae3          	beq	a3,a4,8ee <free+0x22>
    p->s.ptr = bp->s.ptr;
 93e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 940:	00001717          	auipc	a4,0x1
 944:	6cf73023          	sd	a5,1728(a4) # 2000 <freep>
}
 948:	6422                	ld	s0,8(sp)
 94a:	0141                	addi	sp,sp,16
 94c:	8082                	ret

000000000000094e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 94e:	7139                	addi	sp,sp,-64
 950:	fc06                	sd	ra,56(sp)
 952:	f822                	sd	s0,48(sp)
 954:	f426                	sd	s1,40(sp)
 956:	ec4e                	sd	s3,24(sp)
 958:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 95a:	02051493          	slli	s1,a0,0x20
 95e:	9081                	srli	s1,s1,0x20
 960:	04bd                	addi	s1,s1,15
 962:	8091                	srli	s1,s1,0x4
 964:	0014899b          	addiw	s3,s1,1
 968:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 96a:	00001517          	auipc	a0,0x1
 96e:	69653503          	ld	a0,1686(a0) # 2000 <freep>
 972:	c915                	beqz	a0,9a6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 974:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 976:	4798                	lw	a4,8(a5)
 978:	08977a63          	bgeu	a4,s1,a0c <malloc+0xbe>
 97c:	f04a                	sd	s2,32(sp)
 97e:	e852                	sd	s4,16(sp)
 980:	e456                	sd	s5,8(sp)
 982:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 984:	8a4e                	mv	s4,s3
 986:	0009871b          	sext.w	a4,s3
 98a:	6685                	lui	a3,0x1
 98c:	00d77363          	bgeu	a4,a3,992 <malloc+0x44>
 990:	6a05                	lui	s4,0x1
 992:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 996:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 99a:	00001917          	auipc	s2,0x1
 99e:	66690913          	addi	s2,s2,1638 # 2000 <freep>
  if(p == SBRK_ERROR)
 9a2:	5afd                	li	s5,-1
 9a4:	a081                	j	9e4 <malloc+0x96>
 9a6:	f04a                	sd	s2,32(sp)
 9a8:	e852                	sd	s4,16(sp)
 9aa:	e456                	sd	s5,8(sp)
 9ac:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9ae:	00001797          	auipc	a5,0x1
 9b2:	66278793          	addi	a5,a5,1634 # 2010 <base>
 9b6:	00001717          	auipc	a4,0x1
 9ba:	64f73523          	sd	a5,1610(a4) # 2000 <freep>
 9be:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9c0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9c4:	b7c1                	j	984 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9c6:	6398                	ld	a4,0(a5)
 9c8:	e118                	sd	a4,0(a0)
 9ca:	a8a9                	j	a24 <malloc+0xd6>
  hp->s.size = nu;
 9cc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9d0:	0541                	addi	a0,a0,16
 9d2:	efbff0ef          	jal	8cc <free>
  return freep;
 9d6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9da:	c12d                	beqz	a0,a3c <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9de:	4798                	lw	a4,8(a5)
 9e0:	02977263          	bgeu	a4,s1,a04 <malloc+0xb6>
    if(p == freep)
 9e4:	00093703          	ld	a4,0(s2)
 9e8:	853e                	mv	a0,a5
 9ea:	fef719e3          	bne	a4,a5,9dc <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9ee:	8552                	mv	a0,s4
 9f0:	a19ff0ef          	jal	408 <sbrk>
  if(p == SBRK_ERROR)
 9f4:	fd551ce3          	bne	a0,s5,9cc <malloc+0x7e>
        return 0;
 9f8:	4501                	li	a0,0
 9fa:	7902                	ld	s2,32(sp)
 9fc:	6a42                	ld	s4,16(sp)
 9fe:	6aa2                	ld	s5,8(sp)
 a00:	6b02                	ld	s6,0(sp)
 a02:	a03d                	j	a30 <malloc+0xe2>
 a04:	7902                	ld	s2,32(sp)
 a06:	6a42                	ld	s4,16(sp)
 a08:	6aa2                	ld	s5,8(sp)
 a0a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a0c:	fae48de3          	beq	s1,a4,9c6 <malloc+0x78>
        p->s.size -= nunits;
 a10:	4137073b          	subw	a4,a4,s3
 a14:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a16:	02071693          	slli	a3,a4,0x20
 a1a:	01c6d713          	srli	a4,a3,0x1c
 a1e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a20:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a24:	00001717          	auipc	a4,0x1
 a28:	5ca73e23          	sd	a0,1500(a4) # 2000 <freep>
      return (void*)(p + 1);
 a2c:	01078513          	addi	a0,a5,16
  }
}
 a30:	70e2                	ld	ra,56(sp)
 a32:	7442                	ld	s0,48(sp)
 a34:	74a2                	ld	s1,40(sp)
 a36:	69e2                	ld	s3,24(sp)
 a38:	6121                	addi	sp,sp,64
 a3a:	8082                	ret
 a3c:	7902                	ld	s2,32(sp)
 a3e:	6a42                	ld	s4,16(sp)
 a40:	6aa2                	ld	s5,8(sp)
 a42:	6b02                	ld	s6,0(sp)
 a44:	b7f5                	j	a30 <malloc+0xe2>
