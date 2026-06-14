
user/_step5:     file format elf64-littleriscv


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

  printf("fullnet: bind(%d)\n", MYPORT);
   8:	45a9                	li	a1,10
   a:	00001517          	auipc	a0,0x1
   e:	a4650513          	addi	a0,a0,-1466 # a50 <malloc+0x100>
  12:	08b000ef          	jal	89c <printf>
  if(bind(MYPORT) < 0){
  16:	4529                	li	a0,10
  18:	4c6000ef          	jal	4de <bind>
  1c:	12054363          	bltz	a0,142 <main+0x142>
    printf("fullnet: bind failed\n");
    exit(1);
  }

  // 1) TX test: xv6 -> host
  printf("fullnet: TX test (xv6 -> host)\n");
  20:	00001517          	auipc	a0,0x1
  24:	a6050513          	addi	a0,a0,-1440 # a80 <malloc+0x130>
  28:	075000ef          	jal	89c <printf>
  int n = strlen(s);
  2c:	00001517          	auipc	a0,0x1
  30:	a7450513          	addi	a0,a0,-1420 # aa0 <malloc+0x150>
  34:	1ce000ef          	jal	202 <strlen>
  if(send(1111, HOSTIP, HOSTPORT, (char*)s, n) < 0){
  38:	0005071b          	sext.w	a4,a0
  3c:	00001697          	auipc	a3,0x1
  40:	a6468693          	addi	a3,a3,-1436 # aa0 <malloc+0x150>
  44:	6605                	lui	a2,0x1
  46:	8ae60613          	addi	a2,a2,-1874 # 8ae <printf+0x12>
  4a:	0a0005b7          	lui	a1,0xa000
  4e:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffe1f2>
  52:	45700513          	li	a0,1111
  56:	498000ef          	jal	4ee <send>
  5a:	10054063          	bltz	a0,15a <main+0x15a>
  send_msg("TX_OK");

  // 2) RX test: host -> xv6 (منتظر می‌ماند)
  printf("fullnet: RX test (host -> xv6). Now send UDP to host port 26999...\n");
  5e:	00001517          	auipc	a0,0x1
  62:	a6250513          	addi	a0,a0,-1438 # ac0 <malloc+0x170>
  66:	037000ef          	jal	89c <printf>
  int n = recv(MYPORT, &src, &sport, buf, sizeof(buf)-1);
  6a:	07f00713          	li	a4,127
  6e:	f5040693          	addi	a3,s0,-176
  72:	f4a40613          	addi	a2,s0,-182
  76:	f4c40593          	addi	a1,s0,-180
  7a:	4529                	li	a0,10
  7c:	47a000ef          	jal	4f6 <recv>
  if(n < 0){
  80:	0e054963          	bltz	a0,172 <main+0x172>
  84:	f526                	sd	s1,168(sp)
  86:	f14a                	sd	s2,160(sp)
  88:	ed4e                	sd	s3,152(sp)
    printf("fullnet: recv failed\n");
    exit(1);
  }
  buf[n] = 0;
  8a:	fd050793          	addi	a5,a0,-48
  8e:	00878533          	add	a0,a5,s0
  92:	f8050023          	sb	zero,-128(a0)
  printf("fullnet: got \"%s\" from src=%d sport=%d\n", buf, src, sport);
  96:	f4a45683          	lhu	a3,-182(s0)
  9a:	f4c42603          	lw	a2,-180(s0)
  9e:	f5040593          	addi	a1,s0,-176
  a2:	00001517          	auipc	a0,0x1
  a6:	a7e50513          	addi	a0,a0,-1410 # b20 <malloc+0x1d0>
  aa:	7f2000ef          	jal	89c <printf>

  printf("fullnet: queue/drop test: send 30 UDP packets quickly from host now...\n");
  ae:	00001517          	auipc	a0,0x1
  b2:	a9a50513          	addi	a0,a0,-1382 # b48 <malloc+0x1f8>
  b6:	7e6000ef          	jal	89c <printf>
  printf("fullnet: receiving 16 packets (max queue size) ...\n");
  ba:	00001517          	auipc	a0,0x1
  be:	ad650513          	addi	a0,a0,-1322 # b90 <malloc+0x240>
  c2:	7da000ef          	jal	89c <printf>

  int got = 0;
  c6:	4481                	li	s1,0
      printf("fullnet: recv error during stress\n");
      break;
    }
    buf[n] = 0;
  
    printf("fullnet: stress pkt %d: %s\n", i, buf);
  c8:	00001997          	auipc	s3,0x1
  cc:	b2898993          	addi	s3,s3,-1240 # bf0 <malloc+0x2a0>
  for(int i = 0; i < 16; i++){
  d0:	4941                	li	s2,16
    n = recv(MYPORT, &src, &sport, buf, sizeof(buf)-1);
  d2:	07f00713          	li	a4,127
  d6:	f5040693          	addi	a3,s0,-176
  da:	f4a40613          	addi	a2,s0,-182
  de:	f4c40593          	addi	a1,s0,-180
  e2:	4529                	li	a0,10
  e4:	412000ef          	jal	4f6 <recv>
    if(n < 0){
  e8:	0a054163          	bltz	a0,18a <main+0x18a>
    buf[n] = 0;
  ec:	fd050793          	addi	a5,a0,-48
  f0:	00878533          	add	a0,a5,s0
  f4:	f8050023          	sb	zero,-128(a0)
    printf("fullnet: stress pkt %d: %s\n", i, buf);
  f8:	f5040613          	addi	a2,s0,-176
  fc:	85a6                	mv	a1,s1
  fe:	854e                	mv	a0,s3
 100:	79c000ef          	jal	89c <printf>
    got++;
 104:	2485                	addiw	s1,s1,1
  for(int i = 0; i < 16; i++){
 106:	fd2496e3          	bne	s1,s2,d2 <main+0xd2>
  }
  printf("fullnet: received %d packets (should be 16). extra should have been dropped.\n", got);
 10a:	85a6                	mv	a1,s1
 10c:	00001517          	auipc	a0,0x1
 110:	b0450513          	addi	a0,a0,-1276 # c10 <malloc+0x2c0>
 114:	788000ef          	jal	89c <printf>

  printf("fullnet: unbind(%d)\n", MYPORT);
 118:	45a9                	li	a1,10
 11a:	00001517          	auipc	a0,0x1
 11e:	b4650513          	addi	a0,a0,-1210 # c60 <malloc+0x310>
 122:	77a000ef          	jal	89c <printf>
  if(unbind(MYPORT) < 0){
 126:	4529                	li	a0,10
 128:	3be000ef          	jal	4e6 <unbind>
 12c:	06054663          	bltz	a0,198 <main+0x198>
    printf("fullnet: unbind failed\n");
    exit(1);
  }

  printf("fullnet: DONE (no crash, queue limit enforced, unbind drops packets)\n");
 130:	00001517          	auipc	a0,0x1
 134:	b6050513          	addi	a0,a0,-1184 # c90 <malloc+0x340>
 138:	764000ef          	jal	89c <printf>

  exit(0);
 13c:	4501                	li	a0,0
 13e:	300000ef          	jal	43e <exit>
 142:	f526                	sd	s1,168(sp)
 144:	f14a                	sd	s2,160(sp)
 146:	ed4e                	sd	s3,152(sp)
    printf("fullnet: bind failed\n");
 148:	00001517          	auipc	a0,0x1
 14c:	92050513          	addi	a0,a0,-1760 # a68 <malloc+0x118>
 150:	74c000ef          	jal	89c <printf>
    exit(1);
 154:	4505                	li	a0,1
 156:	2e8000ef          	jal	43e <exit>
 15a:	f526                	sd	s1,168(sp)
 15c:	f14a                	sd	s2,160(sp)
 15e:	ed4e                	sd	s3,152(sp)
    printf("fullnet: send failed\n");
 160:	00001517          	auipc	a0,0x1
 164:	94850513          	addi	a0,a0,-1720 # aa8 <malloc+0x158>
 168:	734000ef          	jal	89c <printf>
    exit(1);
 16c:	4505                	li	a0,1
 16e:	2d0000ef          	jal	43e <exit>
 172:	f526                	sd	s1,168(sp)
 174:	f14a                	sd	s2,160(sp)
 176:	ed4e                	sd	s3,152(sp)
    printf("fullnet: recv failed\n");
 178:	00001517          	auipc	a0,0x1
 17c:	99050513          	addi	a0,a0,-1648 # b08 <malloc+0x1b8>
 180:	71c000ef          	jal	89c <printf>
    exit(1);
 184:	4505                	li	a0,1
 186:	2b8000ef          	jal	43e <exit>
      printf("fullnet: recv error during stress\n");
 18a:	00001517          	auipc	a0,0x1
 18e:	a3e50513          	addi	a0,a0,-1474 # bc8 <malloc+0x278>
 192:	70a000ef          	jal	89c <printf>
      break;
 196:	bf95                	j	10a <main+0x10a>
    printf("fullnet: unbind failed\n");
 198:	00001517          	auipc	a0,0x1
 19c:	ae050513          	addi	a0,a0,-1312 # c78 <malloc+0x328>
 1a0:	6fc000ef          	jal	89c <printf>
    exit(1);
 1a4:	4505                	li	a0,1
 1a6:	298000ef          	jal	43e <exit>

00000000000001aa <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 1b2:	e4fff0ef          	jal	0 <main>
  exit(r);
 1b6:	288000ef          	jal	43e <exit>

00000000000001ba <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1c0:	87aa                	mv	a5,a0
 1c2:	0585                	addi	a1,a1,1
 1c4:	0785                	addi	a5,a5,1
 1c6:	fff5c703          	lbu	a4,-1(a1)
 1ca:	fee78fa3          	sb	a4,-1(a5)
 1ce:	fb75                	bnez	a4,1c2 <strcpy+0x8>
    ;
  return os;
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret

00000000000001d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1dc:	00054783          	lbu	a5,0(a0)
 1e0:	cb91                	beqz	a5,1f4 <strcmp+0x1e>
 1e2:	0005c703          	lbu	a4,0(a1)
 1e6:	00f71763          	bne	a4,a5,1f4 <strcmp+0x1e>
    p++, q++;
 1ea:	0505                	addi	a0,a0,1
 1ec:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ee:	00054783          	lbu	a5,0(a0)
 1f2:	fbe5                	bnez	a5,1e2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1f4:	0005c503          	lbu	a0,0(a1)
}
 1f8:	40a7853b          	subw	a0,a5,a0
 1fc:	6422                	ld	s0,8(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret

0000000000000202 <strlen>:

uint
strlen(const char *s)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 208:	00054783          	lbu	a5,0(a0)
 20c:	cf91                	beqz	a5,228 <strlen+0x26>
 20e:	0505                	addi	a0,a0,1
 210:	87aa                	mv	a5,a0
 212:	86be                	mv	a3,a5
 214:	0785                	addi	a5,a5,1
 216:	fff7c703          	lbu	a4,-1(a5)
 21a:	ff65                	bnez	a4,212 <strlen+0x10>
 21c:	40a6853b          	subw	a0,a3,a0
 220:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 222:	6422                	ld	s0,8(sp)
 224:	0141                	addi	sp,sp,16
 226:	8082                	ret
  for(n = 0; s[n]; n++)
 228:	4501                	li	a0,0
 22a:	bfe5                	j	222 <strlen+0x20>

000000000000022c <memset>:

void*
memset(void *dst, int c, uint n)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e422                	sd	s0,8(sp)
 230:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 232:	ca19                	beqz	a2,248 <memset+0x1c>
 234:	87aa                	mv	a5,a0
 236:	1602                	slli	a2,a2,0x20
 238:	9201                	srli	a2,a2,0x20
 23a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 23e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 242:	0785                	addi	a5,a5,1
 244:	fee79de3          	bne	a5,a4,23e <memset+0x12>
  }
  return dst;
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret

000000000000024e <strchr>:

char*
strchr(const char *s, char c)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e422                	sd	s0,8(sp)
 252:	0800                	addi	s0,sp,16
  for(; *s; s++)
 254:	00054783          	lbu	a5,0(a0)
 258:	cb99                	beqz	a5,26e <strchr+0x20>
    if(*s == c)
 25a:	00f58763          	beq	a1,a5,268 <strchr+0x1a>
  for(; *s; s++)
 25e:	0505                	addi	a0,a0,1
 260:	00054783          	lbu	a5,0(a0)
 264:	fbfd                	bnez	a5,25a <strchr+0xc>
      return (char*)s;
  return 0;
 266:	4501                	li	a0,0
}
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret
  return 0;
 26e:	4501                	li	a0,0
 270:	bfe5                	j	268 <strchr+0x1a>

0000000000000272 <gets>:

char*
gets(char *buf, int max)
{
 272:	711d                	addi	sp,sp,-96
 274:	ec86                	sd	ra,88(sp)
 276:	e8a2                	sd	s0,80(sp)
 278:	e4a6                	sd	s1,72(sp)
 27a:	e0ca                	sd	s2,64(sp)
 27c:	fc4e                	sd	s3,56(sp)
 27e:	f852                	sd	s4,48(sp)
 280:	f456                	sd	s5,40(sp)
 282:	f05a                	sd	s6,32(sp)
 284:	ec5e                	sd	s7,24(sp)
 286:	1080                	addi	s0,sp,96
 288:	8baa                	mv	s7,a0
 28a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28c:	892a                	mv	s2,a0
 28e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 290:	4aa9                	li	s5,10
 292:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 294:	89a6                	mv	s3,s1
 296:	2485                	addiw	s1,s1,1
 298:	0344d663          	bge	s1,s4,2c4 <gets+0x52>
    cc = read(0, &c, 1);
 29c:	4605                	li	a2,1
 29e:	faf40593          	addi	a1,s0,-81
 2a2:	4501                	li	a0,0
 2a4:	1b2000ef          	jal	456 <read>
    if(cc < 1)
 2a8:	00a05e63          	blez	a0,2c4 <gets+0x52>
    buf[i++] = c;
 2ac:	faf44783          	lbu	a5,-81(s0)
 2b0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2b4:	01578763          	beq	a5,s5,2c2 <gets+0x50>
 2b8:	0905                	addi	s2,s2,1
 2ba:	fd679de3          	bne	a5,s6,294 <gets+0x22>
    buf[i++] = c;
 2be:	89a6                	mv	s3,s1
 2c0:	a011                	j	2c4 <gets+0x52>
 2c2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2c4:	99de                	add	s3,s3,s7
 2c6:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ca:	855e                	mv	a0,s7
 2cc:	60e6                	ld	ra,88(sp)
 2ce:	6446                	ld	s0,80(sp)
 2d0:	64a6                	ld	s1,72(sp)
 2d2:	6906                	ld	s2,64(sp)
 2d4:	79e2                	ld	s3,56(sp)
 2d6:	7a42                	ld	s4,48(sp)
 2d8:	7aa2                	ld	s5,40(sp)
 2da:	7b02                	ld	s6,32(sp)
 2dc:	6be2                	ld	s7,24(sp)
 2de:	6125                	addi	sp,sp,96
 2e0:	8082                	ret

00000000000002e2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2e2:	1101                	addi	sp,sp,-32
 2e4:	ec06                	sd	ra,24(sp)
 2e6:	e822                	sd	s0,16(sp)
 2e8:	e04a                	sd	s2,0(sp)
 2ea:	1000                	addi	s0,sp,32
 2ec:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ee:	4581                	li	a1,0
 2f0:	18e000ef          	jal	47e <open>
  if(fd < 0)
 2f4:	02054263          	bltz	a0,318 <stat+0x36>
 2f8:	e426                	sd	s1,8(sp)
 2fa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2fc:	85ca                	mv	a1,s2
 2fe:	198000ef          	jal	496 <fstat>
 302:	892a                	mv	s2,a0
  close(fd);
 304:	8526                	mv	a0,s1
 306:	160000ef          	jal	466 <close>
  return r;
 30a:	64a2                	ld	s1,8(sp)
}
 30c:	854a                	mv	a0,s2
 30e:	60e2                	ld	ra,24(sp)
 310:	6442                	ld	s0,16(sp)
 312:	6902                	ld	s2,0(sp)
 314:	6105                	addi	sp,sp,32
 316:	8082                	ret
    return -1;
 318:	597d                	li	s2,-1
 31a:	bfcd                	j	30c <stat+0x2a>

000000000000031c <atoi>:

int
atoi(const char *s)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 322:	00054683          	lbu	a3,0(a0)
 326:	fd06879b          	addiw	a5,a3,-48
 32a:	0ff7f793          	zext.b	a5,a5
 32e:	4625                	li	a2,9
 330:	02f66863          	bltu	a2,a5,360 <atoi+0x44>
 334:	872a                	mv	a4,a0
  n = 0;
 336:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 338:	0705                	addi	a4,a4,1
 33a:	0025179b          	slliw	a5,a0,0x2
 33e:	9fa9                	addw	a5,a5,a0
 340:	0017979b          	slliw	a5,a5,0x1
 344:	9fb5                	addw	a5,a5,a3
 346:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 34a:	00074683          	lbu	a3,0(a4)
 34e:	fd06879b          	addiw	a5,a3,-48
 352:	0ff7f793          	zext.b	a5,a5
 356:	fef671e3          	bgeu	a2,a5,338 <atoi+0x1c>
  return n;
}
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
  n = 0;
 360:	4501                	li	a0,0
 362:	bfe5                	j	35a <atoi+0x3e>

0000000000000364 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e422                	sd	s0,8(sp)
 368:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 36a:	02b57463          	bgeu	a0,a1,392 <memmove+0x2e>
    while(n-- > 0)
 36e:	00c05f63          	blez	a2,38c <memmove+0x28>
 372:	1602                	slli	a2,a2,0x20
 374:	9201                	srli	a2,a2,0x20
 376:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 37a:	872a                	mv	a4,a0
      *dst++ = *src++;
 37c:	0585                	addi	a1,a1,1
 37e:	0705                	addi	a4,a4,1
 380:	fff5c683          	lbu	a3,-1(a1)
 384:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 388:	fef71ae3          	bne	a4,a5,37c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 38c:	6422                	ld	s0,8(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret
    dst += n;
 392:	00c50733          	add	a4,a0,a2
    src += n;
 396:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 398:	fec05ae3          	blez	a2,38c <memmove+0x28>
 39c:	fff6079b          	addiw	a5,a2,-1
 3a0:	1782                	slli	a5,a5,0x20
 3a2:	9381                	srli	a5,a5,0x20
 3a4:	fff7c793          	not	a5,a5
 3a8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3aa:	15fd                	addi	a1,a1,-1
 3ac:	177d                	addi	a4,a4,-1
 3ae:	0005c683          	lbu	a3,0(a1)
 3b2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3b6:	fee79ae3          	bne	a5,a4,3aa <memmove+0x46>
 3ba:	bfc9                	j	38c <memmove+0x28>

00000000000003bc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3bc:	1141                	addi	sp,sp,-16
 3be:	e422                	sd	s0,8(sp)
 3c0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c2:	ca05                	beqz	a2,3f2 <memcmp+0x36>
 3c4:	fff6069b          	addiw	a3,a2,-1
 3c8:	1682                	slli	a3,a3,0x20
 3ca:	9281                	srli	a3,a3,0x20
 3cc:	0685                	addi	a3,a3,1
 3ce:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3d0:	00054783          	lbu	a5,0(a0)
 3d4:	0005c703          	lbu	a4,0(a1)
 3d8:	00e79863          	bne	a5,a4,3e8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3dc:	0505                	addi	a0,a0,1
    p2++;
 3de:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3e0:	fed518e3          	bne	a0,a3,3d0 <memcmp+0x14>
  }
  return 0;
 3e4:	4501                	li	a0,0
 3e6:	a019                	j	3ec <memcmp+0x30>
      return *p1 - *p2;
 3e8:	40e7853b          	subw	a0,a5,a4
}
 3ec:	6422                	ld	s0,8(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret
  return 0;
 3f2:	4501                	li	a0,0
 3f4:	bfe5                	j	3ec <memcmp+0x30>

00000000000003f6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e406                	sd	ra,8(sp)
 3fa:	e022                	sd	s0,0(sp)
 3fc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3fe:	f67ff0ef          	jal	364 <memmove>
}
 402:	60a2                	ld	ra,8(sp)
 404:	6402                	ld	s0,0(sp)
 406:	0141                	addi	sp,sp,16
 408:	8082                	ret

000000000000040a <sbrk>:

char *
sbrk(int n) {
 40a:	1141                	addi	sp,sp,-16
 40c:	e406                	sd	ra,8(sp)
 40e:	e022                	sd	s0,0(sp)
 410:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 412:	4585                	li	a1,1
 414:	0b2000ef          	jal	4c6 <sys_sbrk>
}
 418:	60a2                	ld	ra,8(sp)
 41a:	6402                	ld	s0,0(sp)
 41c:	0141                	addi	sp,sp,16
 41e:	8082                	ret

0000000000000420 <sbrklazy>:

char *
sbrklazy(int n) {
 420:	1141                	addi	sp,sp,-16
 422:	e406                	sd	ra,8(sp)
 424:	e022                	sd	s0,0(sp)
 426:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 428:	4589                	li	a1,2
 42a:	09c000ef          	jal	4c6 <sys_sbrk>
}
 42e:	60a2                	ld	ra,8(sp)
 430:	6402                	ld	s0,0(sp)
 432:	0141                	addi	sp,sp,16
 434:	8082                	ret

0000000000000436 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 436:	4885                	li	a7,1
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <exit>:
.global exit
exit:
 li a7, SYS_exit
 43e:	4889                	li	a7,2
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <wait>:
.global wait
wait:
 li a7, SYS_wait
 446:	488d                	li	a7,3
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 44e:	4891                	li	a7,4
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <read>:
.global read
read:
 li a7, SYS_read
 456:	4895                	li	a7,5
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <write>:
.global write
write:
 li a7, SYS_write
 45e:	48c1                	li	a7,16
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <close>:
.global close
close:
 li a7, SYS_close
 466:	48d5                	li	a7,21
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <kill>:
.global kill
kill:
 li a7, SYS_kill
 46e:	4899                	li	a7,6
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <exec>:
.global exec
exec:
 li a7, SYS_exec
 476:	489d                	li	a7,7
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <open>:
.global open
open:
 li a7, SYS_open
 47e:	48bd                	li	a7,15
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 486:	48c5                	li	a7,17
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 48e:	48c9                	li	a7,18
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 496:	48a1                	li	a7,8
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <link>:
.global link
link:
 li a7, SYS_link
 49e:	48cd                	li	a7,19
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4a6:	48d1                	li	a7,20
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ae:	48a5                	li	a7,9
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4b6:	48a9                	li	a7,10
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4be:	48ad                	li	a7,11
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4c6:	48b1                	li	a7,12
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <pause>:
.global pause
pause:
 li a7, SYS_pause
 4ce:	48b5                	li	a7,13
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4d6:	48b9                	li	a7,14
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <bind>:
.global bind
bind:
 li a7, SYS_bind
 4de:	48f5                	li	a7,29
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 4e6:	48f9                	li	a7,30
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <send>:
.global send
send:
 li a7, SYS_send
 4ee:	48fd                	li	a7,31
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <recv>:
.global recv
recv:
 li a7, SYS_recv
 4f6:	02000893          	li	a7,32
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 500:	02100893          	li	a7,33
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 50a:	02200893          	li	a7,34
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 514:	1101                	addi	sp,sp,-32
 516:	ec06                	sd	ra,24(sp)
 518:	e822                	sd	s0,16(sp)
 51a:	1000                	addi	s0,sp,32
 51c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 520:	4605                	li	a2,1
 522:	fef40593          	addi	a1,s0,-17
 526:	f39ff0ef          	jal	45e <write>
}
 52a:	60e2                	ld	ra,24(sp)
 52c:	6442                	ld	s0,16(sp)
 52e:	6105                	addi	sp,sp,32
 530:	8082                	ret

0000000000000532 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 532:	715d                	addi	sp,sp,-80
 534:	e486                	sd	ra,72(sp)
 536:	e0a2                	sd	s0,64(sp)
 538:	f84a                	sd	s2,48(sp)
 53a:	0880                	addi	s0,sp,80
 53c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 53e:	c299                	beqz	a3,544 <printint+0x12>
 540:	0805c363          	bltz	a1,5c6 <printint+0x94>
  neg = 0;
 544:	4881                	li	a7,0
 546:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 54a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 54c:	00000517          	auipc	a0,0x0
 550:	79450513          	addi	a0,a0,1940 # ce0 <digits>
 554:	883e                	mv	a6,a5
 556:	2785                	addiw	a5,a5,1
 558:	02c5f733          	remu	a4,a1,a2
 55c:	972a                	add	a4,a4,a0
 55e:	00074703          	lbu	a4,0(a4)
 562:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 566:	872e                	mv	a4,a1
 568:	02c5d5b3          	divu	a1,a1,a2
 56c:	0685                	addi	a3,a3,1
 56e:	fec773e3          	bgeu	a4,a2,554 <printint+0x22>
  if(neg)
 572:	00088b63          	beqz	a7,588 <printint+0x56>
    buf[i++] = '-';
 576:	fd078793          	addi	a5,a5,-48
 57a:	97a2                	add	a5,a5,s0
 57c:	02d00713          	li	a4,45
 580:	fee78423          	sb	a4,-24(a5)
 584:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 588:	02f05a63          	blez	a5,5bc <printint+0x8a>
 58c:	fc26                	sd	s1,56(sp)
 58e:	f44e                	sd	s3,40(sp)
 590:	fb840713          	addi	a4,s0,-72
 594:	00f704b3          	add	s1,a4,a5
 598:	fff70993          	addi	s3,a4,-1
 59c:	99be                	add	s3,s3,a5
 59e:	37fd                	addiw	a5,a5,-1
 5a0:	1782                	slli	a5,a5,0x20
 5a2:	9381                	srli	a5,a5,0x20
 5a4:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 5a8:	fff4c583          	lbu	a1,-1(s1)
 5ac:	854a                	mv	a0,s2
 5ae:	f67ff0ef          	jal	514 <putc>
  while(--i >= 0)
 5b2:	14fd                	addi	s1,s1,-1
 5b4:	ff349ae3          	bne	s1,s3,5a8 <printint+0x76>
 5b8:	74e2                	ld	s1,56(sp)
 5ba:	79a2                	ld	s3,40(sp)
}
 5bc:	60a6                	ld	ra,72(sp)
 5be:	6406                	ld	s0,64(sp)
 5c0:	7942                	ld	s2,48(sp)
 5c2:	6161                	addi	sp,sp,80
 5c4:	8082                	ret
    x = -xx;
 5c6:	40b005b3          	neg	a1,a1
    neg = 1;
 5ca:	4885                	li	a7,1
    x = -xx;
 5cc:	bfad                	j	546 <printint+0x14>

00000000000005ce <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ce:	711d                	addi	sp,sp,-96
 5d0:	ec86                	sd	ra,88(sp)
 5d2:	e8a2                	sd	s0,80(sp)
 5d4:	e0ca                	sd	s2,64(sp)
 5d6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5d8:	0005c903          	lbu	s2,0(a1)
 5dc:	28090663          	beqz	s2,868 <vprintf+0x29a>
 5e0:	e4a6                	sd	s1,72(sp)
 5e2:	fc4e                	sd	s3,56(sp)
 5e4:	f852                	sd	s4,48(sp)
 5e6:	f456                	sd	s5,40(sp)
 5e8:	f05a                	sd	s6,32(sp)
 5ea:	ec5e                	sd	s7,24(sp)
 5ec:	e862                	sd	s8,16(sp)
 5ee:	e466                	sd	s9,8(sp)
 5f0:	8b2a                	mv	s6,a0
 5f2:	8a2e                	mv	s4,a1
 5f4:	8bb2                	mv	s7,a2
  state = 0;
 5f6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5f8:	4481                	li	s1,0
 5fa:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5fc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 600:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 604:	06c00c93          	li	s9,108
 608:	a005                	j	628 <vprintf+0x5a>
        putc(fd, c0);
 60a:	85ca                	mv	a1,s2
 60c:	855a                	mv	a0,s6
 60e:	f07ff0ef          	jal	514 <putc>
 612:	a019                	j	618 <vprintf+0x4a>
    } else if(state == '%'){
 614:	03598263          	beq	s3,s5,638 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 618:	2485                	addiw	s1,s1,1
 61a:	8726                	mv	a4,s1
 61c:	009a07b3          	add	a5,s4,s1
 620:	0007c903          	lbu	s2,0(a5)
 624:	22090a63          	beqz	s2,858 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 628:	0009079b          	sext.w	a5,s2
    if(state == 0){
 62c:	fe0994e3          	bnez	s3,614 <vprintf+0x46>
      if(c0 == '%'){
 630:	fd579de3          	bne	a5,s5,60a <vprintf+0x3c>
        state = '%';
 634:	89be                	mv	s3,a5
 636:	b7cd                	j	618 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 638:	00ea06b3          	add	a3,s4,a4
 63c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 640:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 642:	c681                	beqz	a3,64a <vprintf+0x7c>
 644:	9752                	add	a4,a4,s4
 646:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 64a:	05878363          	beq	a5,s8,690 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 64e:	05978d63          	beq	a5,s9,6a8 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 652:	07500713          	li	a4,117
 656:	0ee78763          	beq	a5,a4,744 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 65a:	07800713          	li	a4,120
 65e:	12e78963          	beq	a5,a4,790 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 662:	07000713          	li	a4,112
 666:	14e78e63          	beq	a5,a4,7c2 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 66a:	06300713          	li	a4,99
 66e:	18e78e63          	beq	a5,a4,80a <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 672:	07300713          	li	a4,115
 676:	1ae78463          	beq	a5,a4,81e <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 67a:	02500713          	li	a4,37
 67e:	04e79563          	bne	a5,a4,6c8 <vprintf+0xfa>
        putc(fd, '%');
 682:	02500593          	li	a1,37
 686:	855a                	mv	a0,s6
 688:	e8dff0ef          	jal	514 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 68c:	4981                	li	s3,0
 68e:	b769                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 690:	008b8913          	addi	s2,s7,8
 694:	4685                	li	a3,1
 696:	4629                	li	a2,10
 698:	000ba583          	lw	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	e95ff0ef          	jal	532 <printint>
 6a2:	8bca                	mv	s7,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bf8d                	j	618 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6a8:	06400793          	li	a5,100
 6ac:	02f68963          	beq	a3,a5,6de <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6b0:	06c00793          	li	a5,108
 6b4:	04f68263          	beq	a3,a5,6f8 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 6b8:	07500793          	li	a5,117
 6bc:	0af68063          	beq	a3,a5,75c <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 6c0:	07800793          	li	a5,120
 6c4:	0ef68263          	beq	a3,a5,7a8 <vprintf+0x1da>
        putc(fd, '%');
 6c8:	02500593          	li	a1,37
 6cc:	855a                	mv	a0,s6
 6ce:	e47ff0ef          	jal	514 <putc>
        putc(fd, c0);
 6d2:	85ca                	mv	a1,s2
 6d4:	855a                	mv	a0,s6
 6d6:	e3fff0ef          	jal	514 <putc>
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	bf35                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6de:	008b8913          	addi	s2,s7,8
 6e2:	4685                	li	a3,1
 6e4:	4629                	li	a2,10
 6e6:	000bb583          	ld	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	e47ff0ef          	jal	532 <printint>
        i += 1;
 6f0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f2:	8bca                	mv	s7,s2
      state = 0;
 6f4:	4981                	li	s3,0
        i += 1;
 6f6:	b70d                	j	618 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f8:	06400793          	li	a5,100
 6fc:	02f60763          	beq	a2,a5,72a <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 700:	07500793          	li	a5,117
 704:	06f60963          	beq	a2,a5,776 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 708:	07800793          	li	a5,120
 70c:	faf61ee3          	bne	a2,a5,6c8 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 710:	008b8913          	addi	s2,s7,8
 714:	4681                	li	a3,0
 716:	4641                	li	a2,16
 718:	000bb583          	ld	a1,0(s7)
 71c:	855a                	mv	a0,s6
 71e:	e15ff0ef          	jal	532 <printint>
        i += 2;
 722:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 724:	8bca                	mv	s7,s2
      state = 0;
 726:	4981                	li	s3,0
        i += 2;
 728:	bdc5                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 72a:	008b8913          	addi	s2,s7,8
 72e:	4685                	li	a3,1
 730:	4629                	li	a2,10
 732:	000bb583          	ld	a1,0(s7)
 736:	855a                	mv	a0,s6
 738:	dfbff0ef          	jal	532 <printint>
        i += 2;
 73c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 73e:	8bca                	mv	s7,s2
      state = 0;
 740:	4981                	li	s3,0
        i += 2;
 742:	bdd9                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 744:	008b8913          	addi	s2,s7,8
 748:	4681                	li	a3,0
 74a:	4629                	li	a2,10
 74c:	000be583          	lwu	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	de1ff0ef          	jal	532 <printint>
 756:	8bca                	mv	s7,s2
      state = 0;
 758:	4981                	li	s3,0
 75a:	bd7d                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 75c:	008b8913          	addi	s2,s7,8
 760:	4681                	li	a3,0
 762:	4629                	li	a2,10
 764:	000bb583          	ld	a1,0(s7)
 768:	855a                	mv	a0,s6
 76a:	dc9ff0ef          	jal	532 <printint>
        i += 1;
 76e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 770:	8bca                	mv	s7,s2
      state = 0;
 772:	4981                	li	s3,0
        i += 1;
 774:	b555                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 776:	008b8913          	addi	s2,s7,8
 77a:	4681                	li	a3,0
 77c:	4629                	li	a2,10
 77e:	000bb583          	ld	a1,0(s7)
 782:	855a                	mv	a0,s6
 784:	dafff0ef          	jal	532 <printint>
        i += 2;
 788:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 78a:	8bca                	mv	s7,s2
      state = 0;
 78c:	4981                	li	s3,0
        i += 2;
 78e:	b569                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 790:	008b8913          	addi	s2,s7,8
 794:	4681                	li	a3,0
 796:	4641                	li	a2,16
 798:	000be583          	lwu	a1,0(s7)
 79c:	855a                	mv	a0,s6
 79e:	d95ff0ef          	jal	532 <printint>
 7a2:	8bca                	mv	s7,s2
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	bd8d                	j	618 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a8:	008b8913          	addi	s2,s7,8
 7ac:	4681                	li	a3,0
 7ae:	4641                	li	a2,16
 7b0:	000bb583          	ld	a1,0(s7)
 7b4:	855a                	mv	a0,s6
 7b6:	d7dff0ef          	jal	532 <printint>
        i += 1;
 7ba:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7bc:	8bca                	mv	s7,s2
      state = 0;
 7be:	4981                	li	s3,0
        i += 1;
 7c0:	bda1                	j	618 <vprintf+0x4a>
 7c2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7c4:	008b8d13          	addi	s10,s7,8
 7c8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7cc:	03000593          	li	a1,48
 7d0:	855a                	mv	a0,s6
 7d2:	d43ff0ef          	jal	514 <putc>
  putc(fd, 'x');
 7d6:	07800593          	li	a1,120
 7da:	855a                	mv	a0,s6
 7dc:	d39ff0ef          	jal	514 <putc>
 7e0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e2:	00000b97          	auipc	s7,0x0
 7e6:	4feb8b93          	addi	s7,s7,1278 # ce0 <digits>
 7ea:	03c9d793          	srli	a5,s3,0x3c
 7ee:	97de                	add	a5,a5,s7
 7f0:	0007c583          	lbu	a1,0(a5)
 7f4:	855a                	mv	a0,s6
 7f6:	d1fff0ef          	jal	514 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7fa:	0992                	slli	s3,s3,0x4
 7fc:	397d                	addiw	s2,s2,-1
 7fe:	fe0916e3          	bnez	s2,7ea <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 802:	8bea                	mv	s7,s10
      state = 0;
 804:	4981                	li	s3,0
 806:	6d02                	ld	s10,0(sp)
 808:	bd01                	j	618 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 80a:	008b8913          	addi	s2,s7,8
 80e:	000bc583          	lbu	a1,0(s7)
 812:	855a                	mv	a0,s6
 814:	d01ff0ef          	jal	514 <putc>
 818:	8bca                	mv	s7,s2
      state = 0;
 81a:	4981                	li	s3,0
 81c:	bbf5                	j	618 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 81e:	008b8993          	addi	s3,s7,8
 822:	000bb903          	ld	s2,0(s7)
 826:	00090f63          	beqz	s2,844 <vprintf+0x276>
        for(; *s; s++)
 82a:	00094583          	lbu	a1,0(s2)
 82e:	c195                	beqz	a1,852 <vprintf+0x284>
          putc(fd, *s);
 830:	855a                	mv	a0,s6
 832:	ce3ff0ef          	jal	514 <putc>
        for(; *s; s++)
 836:	0905                	addi	s2,s2,1
 838:	00094583          	lbu	a1,0(s2)
 83c:	f9f5                	bnez	a1,830 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 83e:	8bce                	mv	s7,s3
      state = 0;
 840:	4981                	li	s3,0
 842:	bbd9                	j	618 <vprintf+0x4a>
          s = "(null)";
 844:	00000917          	auipc	s2,0x0
 848:	49490913          	addi	s2,s2,1172 # cd8 <malloc+0x388>
        for(; *s; s++)
 84c:	02800593          	li	a1,40
 850:	b7c5                	j	830 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 852:	8bce                	mv	s7,s3
      state = 0;
 854:	4981                	li	s3,0
 856:	b3c9                	j	618 <vprintf+0x4a>
 858:	64a6                	ld	s1,72(sp)
 85a:	79e2                	ld	s3,56(sp)
 85c:	7a42                	ld	s4,48(sp)
 85e:	7aa2                	ld	s5,40(sp)
 860:	7b02                	ld	s6,32(sp)
 862:	6be2                	ld	s7,24(sp)
 864:	6c42                	ld	s8,16(sp)
 866:	6ca2                	ld	s9,8(sp)
    }
  }
}
 868:	60e6                	ld	ra,88(sp)
 86a:	6446                	ld	s0,80(sp)
 86c:	6906                	ld	s2,64(sp)
 86e:	6125                	addi	sp,sp,96
 870:	8082                	ret

0000000000000872 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 872:	715d                	addi	sp,sp,-80
 874:	ec06                	sd	ra,24(sp)
 876:	e822                	sd	s0,16(sp)
 878:	1000                	addi	s0,sp,32
 87a:	e010                	sd	a2,0(s0)
 87c:	e414                	sd	a3,8(s0)
 87e:	e818                	sd	a4,16(s0)
 880:	ec1c                	sd	a5,24(s0)
 882:	03043023          	sd	a6,32(s0)
 886:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 88a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 88e:	8622                	mv	a2,s0
 890:	d3fff0ef          	jal	5ce <vprintf>
}
 894:	60e2                	ld	ra,24(sp)
 896:	6442                	ld	s0,16(sp)
 898:	6161                	addi	sp,sp,80
 89a:	8082                	ret

000000000000089c <printf>:

void
printf(const char *fmt, ...)
{
 89c:	711d                	addi	sp,sp,-96
 89e:	ec06                	sd	ra,24(sp)
 8a0:	e822                	sd	s0,16(sp)
 8a2:	1000                	addi	s0,sp,32
 8a4:	e40c                	sd	a1,8(s0)
 8a6:	e810                	sd	a2,16(s0)
 8a8:	ec14                	sd	a3,24(s0)
 8aa:	f018                	sd	a4,32(s0)
 8ac:	f41c                	sd	a5,40(s0)
 8ae:	03043823          	sd	a6,48(s0)
 8b2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8b6:	00840613          	addi	a2,s0,8
 8ba:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8be:	85aa                	mv	a1,a0
 8c0:	4505                	li	a0,1
 8c2:	d0dff0ef          	jal	5ce <vprintf>
}
 8c6:	60e2                	ld	ra,24(sp)
 8c8:	6442                	ld	s0,16(sp)
 8ca:	6125                	addi	sp,sp,96
 8cc:	8082                	ret

00000000000008ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ce:	1141                	addi	sp,sp,-16
 8d0:	e422                	sd	s0,8(sp)
 8d2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8d4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d8:	00001797          	auipc	a5,0x1
 8dc:	7287b783          	ld	a5,1832(a5) # 2000 <freep>
 8e0:	a02d                	j	90a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8e2:	4618                	lw	a4,8(a2)
 8e4:	9f2d                	addw	a4,a4,a1
 8e6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ea:	6398                	ld	a4,0(a5)
 8ec:	6310                	ld	a2,0(a4)
 8ee:	a83d                	j	92c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8f0:	ff852703          	lw	a4,-8(a0)
 8f4:	9f31                	addw	a4,a4,a2
 8f6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8f8:	ff053683          	ld	a3,-16(a0)
 8fc:	a091                	j	940 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fe:	6398                	ld	a4,0(a5)
 900:	00e7e463          	bltu	a5,a4,908 <free+0x3a>
 904:	00e6ea63          	bltu	a3,a4,918 <free+0x4a>
{
 908:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90a:	fed7fae3          	bgeu	a5,a3,8fe <free+0x30>
 90e:	6398                	ld	a4,0(a5)
 910:	00e6e463          	bltu	a3,a4,918 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 914:	fee7eae3          	bltu	a5,a4,908 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 918:	ff852583          	lw	a1,-8(a0)
 91c:	6390                	ld	a2,0(a5)
 91e:	02059813          	slli	a6,a1,0x20
 922:	01c85713          	srli	a4,a6,0x1c
 926:	9736                	add	a4,a4,a3
 928:	fae60de3          	beq	a2,a4,8e2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 92c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 930:	4790                	lw	a2,8(a5)
 932:	02061593          	slli	a1,a2,0x20
 936:	01c5d713          	srli	a4,a1,0x1c
 93a:	973e                	add	a4,a4,a5
 93c:	fae68ae3          	beq	a3,a4,8f0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 940:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 942:	00001717          	auipc	a4,0x1
 946:	6af73f23          	sd	a5,1726(a4) # 2000 <freep>
}
 94a:	6422                	ld	s0,8(sp)
 94c:	0141                	addi	sp,sp,16
 94e:	8082                	ret

0000000000000950 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 950:	7139                	addi	sp,sp,-64
 952:	fc06                	sd	ra,56(sp)
 954:	f822                	sd	s0,48(sp)
 956:	f426                	sd	s1,40(sp)
 958:	ec4e                	sd	s3,24(sp)
 95a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 95c:	02051493          	slli	s1,a0,0x20
 960:	9081                	srli	s1,s1,0x20
 962:	04bd                	addi	s1,s1,15
 964:	8091                	srli	s1,s1,0x4
 966:	0014899b          	addiw	s3,s1,1
 96a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 96c:	00001517          	auipc	a0,0x1
 970:	69453503          	ld	a0,1684(a0) # 2000 <freep>
 974:	c915                	beqz	a0,9a8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 976:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 978:	4798                	lw	a4,8(a5)
 97a:	08977a63          	bgeu	a4,s1,a0e <malloc+0xbe>
 97e:	f04a                	sd	s2,32(sp)
 980:	e852                	sd	s4,16(sp)
 982:	e456                	sd	s5,8(sp)
 984:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 986:	8a4e                	mv	s4,s3
 988:	0009871b          	sext.w	a4,s3
 98c:	6685                	lui	a3,0x1
 98e:	00d77363          	bgeu	a4,a3,994 <malloc+0x44>
 992:	6a05                	lui	s4,0x1
 994:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 998:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 99c:	00001917          	auipc	s2,0x1
 9a0:	66490913          	addi	s2,s2,1636 # 2000 <freep>
  if(p == SBRK_ERROR)
 9a4:	5afd                	li	s5,-1
 9a6:	a081                	j	9e6 <malloc+0x96>
 9a8:	f04a                	sd	s2,32(sp)
 9aa:	e852                	sd	s4,16(sp)
 9ac:	e456                	sd	s5,8(sp)
 9ae:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9b0:	00001797          	auipc	a5,0x1
 9b4:	66078793          	addi	a5,a5,1632 # 2010 <base>
 9b8:	00001717          	auipc	a4,0x1
 9bc:	64f73423          	sd	a5,1608(a4) # 2000 <freep>
 9c0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9c2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9c6:	b7c1                	j	986 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9c8:	6398                	ld	a4,0(a5)
 9ca:	e118                	sd	a4,0(a0)
 9cc:	a8a9                	j	a26 <malloc+0xd6>
  hp->s.size = nu;
 9ce:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9d2:	0541                	addi	a0,a0,16
 9d4:	efbff0ef          	jal	8ce <free>
  return freep;
 9d8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9dc:	c12d                	beqz	a0,a3e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9de:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e0:	4798                	lw	a4,8(a5)
 9e2:	02977263          	bgeu	a4,s1,a06 <malloc+0xb6>
    if(p == freep)
 9e6:	00093703          	ld	a4,0(s2)
 9ea:	853e                	mv	a0,a5
 9ec:	fef719e3          	bne	a4,a5,9de <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9f0:	8552                	mv	a0,s4
 9f2:	a19ff0ef          	jal	40a <sbrk>
  if(p == SBRK_ERROR)
 9f6:	fd551ce3          	bne	a0,s5,9ce <malloc+0x7e>
        return 0;
 9fa:	4501                	li	a0,0
 9fc:	7902                	ld	s2,32(sp)
 9fe:	6a42                	ld	s4,16(sp)
 a00:	6aa2                	ld	s5,8(sp)
 a02:	6b02                	ld	s6,0(sp)
 a04:	a03d                	j	a32 <malloc+0xe2>
 a06:	7902                	ld	s2,32(sp)
 a08:	6a42                	ld	s4,16(sp)
 a0a:	6aa2                	ld	s5,8(sp)
 a0c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a0e:	fae48de3          	beq	s1,a4,9c8 <malloc+0x78>
        p->s.size -= nunits;
 a12:	4137073b          	subw	a4,a4,s3
 a16:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a18:	02071693          	slli	a3,a4,0x20
 a1c:	01c6d713          	srli	a4,a3,0x1c
 a20:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a22:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a26:	00001717          	auipc	a4,0x1
 a2a:	5ca73d23          	sd	a0,1498(a4) # 2000 <freep>
      return (void*)(p + 1);
 a2e:	01078513          	addi	a0,a5,16
  }
}
 a32:	70e2                	ld	ra,56(sp)
 a34:	7442                	ld	s0,48(sp)
 a36:	74a2                	ld	s1,40(sp)
 a38:	69e2                	ld	s3,24(sp)
 a3a:	6121                	addi	sp,sp,64
 a3c:	8082                	ret
 a3e:	7902                	ld	s2,32(sp)
 a40:	6a42                	ld	s4,16(sp)
 a42:	6aa2                	ld	s5,8(sp)
 a44:	6b02                	ld	s6,0(sp)
 a46:	b7f5                	j	a32 <malloc+0xe2>
