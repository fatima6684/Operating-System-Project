
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	99a78793          	addi	a5,a5,-1638 # 9b0 <malloc+0x132>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	95450513          	addi	a0,a0,-1708 # 980 <malloc+0x102>
  34:	796000ef          	jal	7ca <printf>
  memset(data, 'a', sizeof(data));
  38:	20000613          	li	a2,512
  3c:	06100593          	li	a1,97
  40:	dd040513          	addi	a0,s0,-560
  44:	116000ef          	jal	15a <memset>

  for(i = 0; i < 4; i++)
  48:	4481                	li	s1,0
  4a:	4911                	li	s2,4
    if(fork() > 0)
  4c:	318000ef          	jal	364 <fork>
  50:	00a04563          	bgtz	a0,5a <main+0x5a>
  for(i = 0; i < 4; i++)
  54:	2485                	addiw	s1,s1,1
  56:	ff249be3          	bne	s1,s2,4c <main+0x4c>
      break;

  printf("write %d\n", i);
  5a:	85a6                	mv	a1,s1
  5c:	00001517          	auipc	a0,0x1
  60:	93c50513          	addi	a0,a0,-1732 # 998 <malloc+0x11a>
  64:	766000ef          	jal	7ca <printf>

  path[8] += i;
  68:	fd844783          	lbu	a5,-40(s0)
  6c:	9fa5                	addw	a5,a5,s1
  6e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  72:	20200593          	li	a1,514
  76:	fd040513          	addi	a0,s0,-48
  7a:	332000ef          	jal	3ac <open>
  7e:	892a                	mv	s2,a0
  80:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  82:	20000613          	li	a2,512
  86:	dd040593          	addi	a1,s0,-560
  8a:	854a                	mv	a0,s2
  8c:	300000ef          	jal	38c <write>
  for(i = 0; i < 20; i++)
  90:	34fd                	addiw	s1,s1,-1
  92:	f8e5                	bnez	s1,82 <main+0x82>
  close(fd);
  94:	854a                	mv	a0,s2
  96:	2fe000ef          	jal	394 <close>

  printf("read\n");
  9a:	00001517          	auipc	a0,0x1
  9e:	90e50513          	addi	a0,a0,-1778 # 9a8 <malloc+0x12a>
  a2:	728000ef          	jal	7ca <printf>

  fd = open(path, O_RDONLY);
  a6:	4581                	li	a1,0
  a8:	fd040513          	addi	a0,s0,-48
  ac:	300000ef          	jal	3ac <open>
  b0:	892a                	mv	s2,a0
  b2:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  b4:	20000613          	li	a2,512
  b8:	dd040593          	addi	a1,s0,-560
  bc:	854a                	mv	a0,s2
  be:	2c6000ef          	jal	384 <read>
  for (i = 0; i < 20; i++)
  c2:	34fd                	addiw	s1,s1,-1
  c4:	f8e5                	bnez	s1,b4 <main+0xb4>
  close(fd);
  c6:	854a                	mv	a0,s2
  c8:	2cc000ef          	jal	394 <close>

  wait(0);
  cc:	4501                	li	a0,0
  ce:	2a6000ef          	jal	374 <wait>

  exit(0);
  d2:	4501                	li	a0,0
  d4:	298000ef          	jal	36c <exit>

00000000000000d8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  e0:	f21ff0ef          	jal	0 <main>
  exit(r);
  e4:	288000ef          	jal	36c <exit>

00000000000000e8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ee:	87aa                	mv	a5,a0
  f0:	0585                	addi	a1,a1,1
  f2:	0785                	addi	a5,a5,1
  f4:	fff5c703          	lbu	a4,-1(a1)
  f8:	fee78fa3          	sb	a4,-1(a5)
  fc:	fb75                	bnez	a4,f0 <strcpy+0x8>
    ;
  return os;
}
  fe:	6422                	ld	s0,8(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret

0000000000000104 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cb91                	beqz	a5,122 <strcmp+0x1e>
 110:	0005c703          	lbu	a4,0(a1)
 114:	00f71763          	bne	a4,a5,122 <strcmp+0x1e>
    p++, q++;
 118:	0505                	addi	a0,a0,1
 11a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 11c:	00054783          	lbu	a5,0(a0)
 120:	fbe5                	bnez	a5,110 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 122:	0005c503          	lbu	a0,0(a1)
}
 126:	40a7853b          	subw	a0,a5,a0
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strlen>:

uint
strlen(const char *s)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cf91                	beqz	a5,156 <strlen+0x26>
 13c:	0505                	addi	a0,a0,1
 13e:	87aa                	mv	a5,a0
 140:	86be                	mv	a3,a5
 142:	0785                	addi	a5,a5,1
 144:	fff7c703          	lbu	a4,-1(a5)
 148:	ff65                	bnez	a4,140 <strlen+0x10>
 14a:	40a6853b          	subw	a0,a3,a0
 14e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 150:	6422                	ld	s0,8(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret
  for(n = 0; s[n]; n++)
 156:	4501                	li	a0,0
 158:	bfe5                	j	150 <strlen+0x20>

000000000000015a <memset>:

void*
memset(void *dst, int c, uint n)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 160:	ca19                	beqz	a2,176 <memset+0x1c>
 162:	87aa                	mv	a5,a0
 164:	1602                	slli	a2,a2,0x20
 166:	9201                	srli	a2,a2,0x20
 168:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 16c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 170:	0785                	addi	a5,a5,1
 172:	fee79de3          	bne	a5,a4,16c <memset+0x12>
  }
  return dst;
}
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <strchr>:

char*
strchr(const char *s, char c)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
  for(; *s; s++)
 182:	00054783          	lbu	a5,0(a0)
 186:	cb99                	beqz	a5,19c <strchr+0x20>
    if(*s == c)
 188:	00f58763          	beq	a1,a5,196 <strchr+0x1a>
  for(; *s; s++)
 18c:	0505                	addi	a0,a0,1
 18e:	00054783          	lbu	a5,0(a0)
 192:	fbfd                	bnez	a5,188 <strchr+0xc>
      return (char*)s;
  return 0;
 194:	4501                	li	a0,0
}
 196:	6422                	ld	s0,8(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret
  return 0;
 19c:	4501                	li	a0,0
 19e:	bfe5                	j	196 <strchr+0x1a>

00000000000001a0 <gets>:

char*
gets(char *buf, int max)
{
 1a0:	711d                	addi	sp,sp,-96
 1a2:	ec86                	sd	ra,88(sp)
 1a4:	e8a2                	sd	s0,80(sp)
 1a6:	e4a6                	sd	s1,72(sp)
 1a8:	e0ca                	sd	s2,64(sp)
 1aa:	fc4e                	sd	s3,56(sp)
 1ac:	f852                	sd	s4,48(sp)
 1ae:	f456                	sd	s5,40(sp)
 1b0:	f05a                	sd	s6,32(sp)
 1b2:	ec5e                	sd	s7,24(sp)
 1b4:	1080                	addi	s0,sp,96
 1b6:	8baa                	mv	s7,a0
 1b8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ba:	892a                	mv	s2,a0
 1bc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1be:	4aa9                	li	s5,10
 1c0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1c2:	89a6                	mv	s3,s1
 1c4:	2485                	addiw	s1,s1,1
 1c6:	0344d663          	bge	s1,s4,1f2 <gets+0x52>
    cc = read(0, &c, 1);
 1ca:	4605                	li	a2,1
 1cc:	faf40593          	addi	a1,s0,-81
 1d0:	4501                	li	a0,0
 1d2:	1b2000ef          	jal	384 <read>
    if(cc < 1)
 1d6:	00a05e63          	blez	a0,1f2 <gets+0x52>
    buf[i++] = c;
 1da:	faf44783          	lbu	a5,-81(s0)
 1de:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e2:	01578763          	beq	a5,s5,1f0 <gets+0x50>
 1e6:	0905                	addi	s2,s2,1
 1e8:	fd679de3          	bne	a5,s6,1c2 <gets+0x22>
    buf[i++] = c;
 1ec:	89a6                	mv	s3,s1
 1ee:	a011                	j	1f2 <gets+0x52>
 1f0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1f2:	99de                	add	s3,s3,s7
 1f4:	00098023          	sb	zero,0(s3)
  return buf;
}
 1f8:	855e                	mv	a0,s7
 1fa:	60e6                	ld	ra,88(sp)
 1fc:	6446                	ld	s0,80(sp)
 1fe:	64a6                	ld	s1,72(sp)
 200:	6906                	ld	s2,64(sp)
 202:	79e2                	ld	s3,56(sp)
 204:	7a42                	ld	s4,48(sp)
 206:	7aa2                	ld	s5,40(sp)
 208:	7b02                	ld	s6,32(sp)
 20a:	6be2                	ld	s7,24(sp)
 20c:	6125                	addi	sp,sp,96
 20e:	8082                	ret

0000000000000210 <stat>:

int
stat(const char *n, struct stat *st)
{
 210:	1101                	addi	sp,sp,-32
 212:	ec06                	sd	ra,24(sp)
 214:	e822                	sd	s0,16(sp)
 216:	e04a                	sd	s2,0(sp)
 218:	1000                	addi	s0,sp,32
 21a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21c:	4581                	li	a1,0
 21e:	18e000ef          	jal	3ac <open>
  if(fd < 0)
 222:	02054263          	bltz	a0,246 <stat+0x36>
 226:	e426                	sd	s1,8(sp)
 228:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22a:	85ca                	mv	a1,s2
 22c:	198000ef          	jal	3c4 <fstat>
 230:	892a                	mv	s2,a0
  close(fd);
 232:	8526                	mv	a0,s1
 234:	160000ef          	jal	394 <close>
  return r;
 238:	64a2                	ld	s1,8(sp)
}
 23a:	854a                	mv	a0,s2
 23c:	60e2                	ld	ra,24(sp)
 23e:	6442                	ld	s0,16(sp)
 240:	6902                	ld	s2,0(sp)
 242:	6105                	addi	sp,sp,32
 244:	8082                	ret
    return -1;
 246:	597d                	li	s2,-1
 248:	bfcd                	j	23a <stat+0x2a>

000000000000024a <atoi>:

int
atoi(const char *s)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 250:	00054683          	lbu	a3,0(a0)
 254:	fd06879b          	addiw	a5,a3,-48
 258:	0ff7f793          	zext.b	a5,a5
 25c:	4625                	li	a2,9
 25e:	02f66863          	bltu	a2,a5,28e <atoi+0x44>
 262:	872a                	mv	a4,a0
  n = 0;
 264:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 266:	0705                	addi	a4,a4,1
 268:	0025179b          	slliw	a5,a0,0x2
 26c:	9fa9                	addw	a5,a5,a0
 26e:	0017979b          	slliw	a5,a5,0x1
 272:	9fb5                	addw	a5,a5,a3
 274:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 278:	00074683          	lbu	a3,0(a4)
 27c:	fd06879b          	addiw	a5,a3,-48
 280:	0ff7f793          	zext.b	a5,a5
 284:	fef671e3          	bgeu	a2,a5,266 <atoi+0x1c>
  return n;
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret
  n = 0;
 28e:	4501                	li	a0,0
 290:	bfe5                	j	288 <atoi+0x3e>

0000000000000292 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 298:	02b57463          	bgeu	a0,a1,2c0 <memmove+0x2e>
    while(n-- > 0)
 29c:	00c05f63          	blez	a2,2ba <memmove+0x28>
 2a0:	1602                	slli	a2,a2,0x20
 2a2:	9201                	srli	a2,a2,0x20
 2a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2a8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2aa:	0585                	addi	a1,a1,1
 2ac:	0705                	addi	a4,a4,1
 2ae:	fff5c683          	lbu	a3,-1(a1)
 2b2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b6:	fef71ae3          	bne	a4,a5,2aa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret
    dst += n;
 2c0:	00c50733          	add	a4,a0,a2
    src += n;
 2c4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2c6:	fec05ae3          	blez	a2,2ba <memmove+0x28>
 2ca:	fff6079b          	addiw	a5,a2,-1
 2ce:	1782                	slli	a5,a5,0x20
 2d0:	9381                	srli	a5,a5,0x20
 2d2:	fff7c793          	not	a5,a5
 2d6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2d8:	15fd                	addi	a1,a1,-1
 2da:	177d                	addi	a4,a4,-1
 2dc:	0005c683          	lbu	a3,0(a1)
 2e0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e4:	fee79ae3          	bne	a5,a4,2d8 <memmove+0x46>
 2e8:	bfc9                	j	2ba <memmove+0x28>

00000000000002ea <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f0:	ca05                	beqz	a2,320 <memcmp+0x36>
 2f2:	fff6069b          	addiw	a3,a2,-1
 2f6:	1682                	slli	a3,a3,0x20
 2f8:	9281                	srli	a3,a3,0x20
 2fa:	0685                	addi	a3,a3,1
 2fc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2fe:	00054783          	lbu	a5,0(a0)
 302:	0005c703          	lbu	a4,0(a1)
 306:	00e79863          	bne	a5,a4,316 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 30a:	0505                	addi	a0,a0,1
    p2++;
 30c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 30e:	fed518e3          	bne	a0,a3,2fe <memcmp+0x14>
  }
  return 0;
 312:	4501                	li	a0,0
 314:	a019                	j	31a <memcmp+0x30>
      return *p1 - *p2;
 316:	40e7853b          	subw	a0,a5,a4
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  return 0;
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <memcmp+0x30>

0000000000000324 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e406                	sd	ra,8(sp)
 328:	e022                	sd	s0,0(sp)
 32a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 32c:	f67ff0ef          	jal	292 <memmove>
}
 330:	60a2                	ld	ra,8(sp)
 332:	6402                	ld	s0,0(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret

0000000000000338 <sbrk>:

char *
sbrk(int n) {
 338:	1141                	addi	sp,sp,-16
 33a:	e406                	sd	ra,8(sp)
 33c:	e022                	sd	s0,0(sp)
 33e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 340:	4585                	li	a1,1
 342:	0b2000ef          	jal	3f4 <sys_sbrk>
}
 346:	60a2                	ld	ra,8(sp)
 348:	6402                	ld	s0,0(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret

000000000000034e <sbrklazy>:

char *
sbrklazy(int n) {
 34e:	1141                	addi	sp,sp,-16
 350:	e406                	sd	ra,8(sp)
 352:	e022                	sd	s0,0(sp)
 354:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 356:	4589                	li	a1,2
 358:	09c000ef          	jal	3f4 <sys_sbrk>
}
 35c:	60a2                	ld	ra,8(sp)
 35e:	6402                	ld	s0,0(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret

0000000000000364 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 364:	4885                	li	a7,1
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <exit>:
.global exit
exit:
 li a7, SYS_exit
 36c:	4889                	li	a7,2
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <wait>:
.global wait
wait:
 li a7, SYS_wait
 374:	488d                	li	a7,3
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 37c:	4891                	li	a7,4
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <read>:
.global read
read:
 li a7, SYS_read
 384:	4895                	li	a7,5
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <write>:
.global write
write:
 li a7, SYS_write
 38c:	48c1                	li	a7,16
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <close>:
.global close
close:
 li a7, SYS_close
 394:	48d5                	li	a7,21
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <kill>:
.global kill
kill:
 li a7, SYS_kill
 39c:	4899                	li	a7,6
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3a4:	489d                	li	a7,7
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <open>:
.global open
open:
 li a7, SYS_open
 3ac:	48bd                	li	a7,15
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b4:	48c5                	li	a7,17
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3bc:	48c9                	li	a7,18
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3c4:	48a1                	li	a7,8
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <link>:
.global link
link:
 li a7, SYS_link
 3cc:	48cd                	li	a7,19
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d4:	48d1                	li	a7,20
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3dc:	48a5                	li	a7,9
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e4:	48a9                	li	a7,10
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ec:	48ad                	li	a7,11
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3f4:	48b1                	li	a7,12
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <pause>:
.global pause
pause:
 li a7, SYS_pause
 3fc:	48b5                	li	a7,13
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 404:	48b9                	li	a7,14
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <bind>:
.global bind
bind:
 li a7, SYS_bind
 40c:	48f5                	li	a7,29
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 414:	48f9                	li	a7,30
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <send>:
.global send
send:
 li a7, SYS_send
 41c:	48fd                	li	a7,31
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <recv>:
.global recv
recv:
 li a7, SYS_recv
 424:	02000893          	li	a7,32
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 42e:	02100893          	li	a7,33
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 438:	02200893          	li	a7,34
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 442:	1101                	addi	sp,sp,-32
 444:	ec06                	sd	ra,24(sp)
 446:	e822                	sd	s0,16(sp)
 448:	1000                	addi	s0,sp,32
 44a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44e:	4605                	li	a2,1
 450:	fef40593          	addi	a1,s0,-17
 454:	f39ff0ef          	jal	38c <write>
}
 458:	60e2                	ld	ra,24(sp)
 45a:	6442                	ld	s0,16(sp)
 45c:	6105                	addi	sp,sp,32
 45e:	8082                	ret

0000000000000460 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 460:	715d                	addi	sp,sp,-80
 462:	e486                	sd	ra,72(sp)
 464:	e0a2                	sd	s0,64(sp)
 466:	f84a                	sd	s2,48(sp)
 468:	0880                	addi	s0,sp,80
 46a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 46c:	c299                	beqz	a3,472 <printint+0x12>
 46e:	0805c363          	bltz	a1,4f4 <printint+0x94>
  neg = 0;
 472:	4881                	li	a7,0
 474:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 478:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 47a:	00000517          	auipc	a0,0x0
 47e:	54e50513          	addi	a0,a0,1358 # 9c8 <digits>
 482:	883e                	mv	a6,a5
 484:	2785                	addiw	a5,a5,1
 486:	02c5f733          	remu	a4,a1,a2
 48a:	972a                	add	a4,a4,a0
 48c:	00074703          	lbu	a4,0(a4)
 490:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 494:	872e                	mv	a4,a1
 496:	02c5d5b3          	divu	a1,a1,a2
 49a:	0685                	addi	a3,a3,1
 49c:	fec773e3          	bgeu	a4,a2,482 <printint+0x22>
  if(neg)
 4a0:	00088b63          	beqz	a7,4b6 <printint+0x56>
    buf[i++] = '-';
 4a4:	fd078793          	addi	a5,a5,-48
 4a8:	97a2                	add	a5,a5,s0
 4aa:	02d00713          	li	a4,45
 4ae:	fee78423          	sb	a4,-24(a5)
 4b2:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 4b6:	02f05a63          	blez	a5,4ea <printint+0x8a>
 4ba:	fc26                	sd	s1,56(sp)
 4bc:	f44e                	sd	s3,40(sp)
 4be:	fb840713          	addi	a4,s0,-72
 4c2:	00f704b3          	add	s1,a4,a5
 4c6:	fff70993          	addi	s3,a4,-1
 4ca:	99be                	add	s3,s3,a5
 4cc:	37fd                	addiw	a5,a5,-1
 4ce:	1782                	slli	a5,a5,0x20
 4d0:	9381                	srli	a5,a5,0x20
 4d2:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4d6:	fff4c583          	lbu	a1,-1(s1)
 4da:	854a                	mv	a0,s2
 4dc:	f67ff0ef          	jal	442 <putc>
  while(--i >= 0)
 4e0:	14fd                	addi	s1,s1,-1
 4e2:	ff349ae3          	bne	s1,s3,4d6 <printint+0x76>
 4e6:	74e2                	ld	s1,56(sp)
 4e8:	79a2                	ld	s3,40(sp)
}
 4ea:	60a6                	ld	ra,72(sp)
 4ec:	6406                	ld	s0,64(sp)
 4ee:	7942                	ld	s2,48(sp)
 4f0:	6161                	addi	sp,sp,80
 4f2:	8082                	ret
    x = -xx;
 4f4:	40b005b3          	neg	a1,a1
    neg = 1;
 4f8:	4885                	li	a7,1
    x = -xx;
 4fa:	bfad                	j	474 <printint+0x14>

00000000000004fc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4fc:	711d                	addi	sp,sp,-96
 4fe:	ec86                	sd	ra,88(sp)
 500:	e8a2                	sd	s0,80(sp)
 502:	e0ca                	sd	s2,64(sp)
 504:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 506:	0005c903          	lbu	s2,0(a1)
 50a:	28090663          	beqz	s2,796 <vprintf+0x29a>
 50e:	e4a6                	sd	s1,72(sp)
 510:	fc4e                	sd	s3,56(sp)
 512:	f852                	sd	s4,48(sp)
 514:	f456                	sd	s5,40(sp)
 516:	f05a                	sd	s6,32(sp)
 518:	ec5e                	sd	s7,24(sp)
 51a:	e862                	sd	s8,16(sp)
 51c:	e466                	sd	s9,8(sp)
 51e:	8b2a                	mv	s6,a0
 520:	8a2e                	mv	s4,a1
 522:	8bb2                	mv	s7,a2
  state = 0;
 524:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 526:	4481                	li	s1,0
 528:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 52a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 52e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 532:	06c00c93          	li	s9,108
 536:	a005                	j	556 <vprintf+0x5a>
        putc(fd, c0);
 538:	85ca                	mv	a1,s2
 53a:	855a                	mv	a0,s6
 53c:	f07ff0ef          	jal	442 <putc>
 540:	a019                	j	546 <vprintf+0x4a>
    } else if(state == '%'){
 542:	03598263          	beq	s3,s5,566 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 546:	2485                	addiw	s1,s1,1
 548:	8726                	mv	a4,s1
 54a:	009a07b3          	add	a5,s4,s1
 54e:	0007c903          	lbu	s2,0(a5)
 552:	22090a63          	beqz	s2,786 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 556:	0009079b          	sext.w	a5,s2
    if(state == 0){
 55a:	fe0994e3          	bnez	s3,542 <vprintf+0x46>
      if(c0 == '%'){
 55e:	fd579de3          	bne	a5,s5,538 <vprintf+0x3c>
        state = '%';
 562:	89be                	mv	s3,a5
 564:	b7cd                	j	546 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 566:	00ea06b3          	add	a3,s4,a4
 56a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 56e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 570:	c681                	beqz	a3,578 <vprintf+0x7c>
 572:	9752                	add	a4,a4,s4
 574:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 578:	05878363          	beq	a5,s8,5be <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 57c:	05978d63          	beq	a5,s9,5d6 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 580:	07500713          	li	a4,117
 584:	0ee78763          	beq	a5,a4,672 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 588:	07800713          	li	a4,120
 58c:	12e78963          	beq	a5,a4,6be <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 590:	07000713          	li	a4,112
 594:	14e78e63          	beq	a5,a4,6f0 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 598:	06300713          	li	a4,99
 59c:	18e78e63          	beq	a5,a4,738 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5a0:	07300713          	li	a4,115
 5a4:	1ae78463          	beq	a5,a4,74c <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5a8:	02500713          	li	a4,37
 5ac:	04e79563          	bne	a5,a4,5f6 <vprintf+0xfa>
        putc(fd, '%');
 5b0:	02500593          	li	a1,37
 5b4:	855a                	mv	a0,s6
 5b6:	e8dff0ef          	jal	442 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	b769                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5be:	008b8913          	addi	s2,s7,8
 5c2:	4685                	li	a3,1
 5c4:	4629                	li	a2,10
 5c6:	000ba583          	lw	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	e95ff0ef          	jal	460 <printint>
 5d0:	8bca                	mv	s7,s2
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	bf8d                	j	546 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5d6:	06400793          	li	a5,100
 5da:	02f68963          	beq	a3,a5,60c <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5de:	06c00793          	li	a5,108
 5e2:	04f68263          	beq	a3,a5,626 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 5e6:	07500793          	li	a5,117
 5ea:	0af68063          	beq	a3,a5,68a <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 5ee:	07800793          	li	a5,120
 5f2:	0ef68263          	beq	a3,a5,6d6 <vprintf+0x1da>
        putc(fd, '%');
 5f6:	02500593          	li	a1,37
 5fa:	855a                	mv	a0,s6
 5fc:	e47ff0ef          	jal	442 <putc>
        putc(fd, c0);
 600:	85ca                	mv	a1,s2
 602:	855a                	mv	a0,s6
 604:	e3fff0ef          	jal	442 <putc>
      state = 0;
 608:	4981                	li	s3,0
 60a:	bf35                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	008b8913          	addi	s2,s7,8
 610:	4685                	li	a3,1
 612:	4629                	li	a2,10
 614:	000bb583          	ld	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	e47ff0ef          	jal	460 <printint>
        i += 1;
 61e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 620:	8bca                	mv	s7,s2
      state = 0;
 622:	4981                	li	s3,0
        i += 1;
 624:	b70d                	j	546 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 626:	06400793          	li	a5,100
 62a:	02f60763          	beq	a2,a5,658 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 62e:	07500793          	li	a5,117
 632:	06f60963          	beq	a2,a5,6a4 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 636:	07800793          	li	a5,120
 63a:	faf61ee3          	bne	a2,a5,5f6 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63e:	008b8913          	addi	s2,s7,8
 642:	4681                	li	a3,0
 644:	4641                	li	a2,16
 646:	000bb583          	ld	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	e15ff0ef          	jal	460 <printint>
        i += 2;
 650:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
        i += 2;
 656:	bdc5                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 658:	008b8913          	addi	s2,s7,8
 65c:	4685                	li	a3,1
 65e:	4629                	li	a2,10
 660:	000bb583          	ld	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	dfbff0ef          	jal	460 <printint>
        i += 2;
 66a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 66c:	8bca                	mv	s7,s2
      state = 0;
 66e:	4981                	li	s3,0
        i += 2;
 670:	bdd9                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 672:	008b8913          	addi	s2,s7,8
 676:	4681                	li	a3,0
 678:	4629                	li	a2,10
 67a:	000be583          	lwu	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	de1ff0ef          	jal	460 <printint>
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
 688:	bd7d                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68a:	008b8913          	addi	s2,s7,8
 68e:	4681                	li	a3,0
 690:	4629                	li	a2,10
 692:	000bb583          	ld	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	dc9ff0ef          	jal	460 <printint>
        i += 1;
 69c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 69e:	8bca                	mv	s7,s2
      state = 0;
 6a0:	4981                	li	s3,0
        i += 1;
 6a2:	b555                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a4:	008b8913          	addi	s2,s7,8
 6a8:	4681                	li	a3,0
 6aa:	4629                	li	a2,10
 6ac:	000bb583          	ld	a1,0(s7)
 6b0:	855a                	mv	a0,s6
 6b2:	dafff0ef          	jal	460 <printint>
        i += 2;
 6b6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b8:	8bca                	mv	s7,s2
      state = 0;
 6ba:	4981                	li	s3,0
        i += 2;
 6bc:	b569                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6be:	008b8913          	addi	s2,s7,8
 6c2:	4681                	li	a3,0
 6c4:	4641                	li	a2,16
 6c6:	000be583          	lwu	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	d95ff0ef          	jal	460 <printint>
 6d0:	8bca                	mv	s7,s2
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bd8d                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d6:	008b8913          	addi	s2,s7,8
 6da:	4681                	li	a3,0
 6dc:	4641                	li	a2,16
 6de:	000bb583          	ld	a1,0(s7)
 6e2:	855a                	mv	a0,s6
 6e4:	d7dff0ef          	jal	460 <printint>
        i += 1;
 6e8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ea:	8bca                	mv	s7,s2
      state = 0;
 6ec:	4981                	li	s3,0
        i += 1;
 6ee:	bda1                	j	546 <vprintf+0x4a>
 6f0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6f2:	008b8d13          	addi	s10,s7,8
 6f6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6fa:	03000593          	li	a1,48
 6fe:	855a                	mv	a0,s6
 700:	d43ff0ef          	jal	442 <putc>
  putc(fd, 'x');
 704:	07800593          	li	a1,120
 708:	855a                	mv	a0,s6
 70a:	d39ff0ef          	jal	442 <putc>
 70e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 710:	00000b97          	auipc	s7,0x0
 714:	2b8b8b93          	addi	s7,s7,696 # 9c8 <digits>
 718:	03c9d793          	srli	a5,s3,0x3c
 71c:	97de                	add	a5,a5,s7
 71e:	0007c583          	lbu	a1,0(a5)
 722:	855a                	mv	a0,s6
 724:	d1fff0ef          	jal	442 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 728:	0992                	slli	s3,s3,0x4
 72a:	397d                	addiw	s2,s2,-1
 72c:	fe0916e3          	bnez	s2,718 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 730:	8bea                	mv	s7,s10
      state = 0;
 732:	4981                	li	s3,0
 734:	6d02                	ld	s10,0(sp)
 736:	bd01                	j	546 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 738:	008b8913          	addi	s2,s7,8
 73c:	000bc583          	lbu	a1,0(s7)
 740:	855a                	mv	a0,s6
 742:	d01ff0ef          	jal	442 <putc>
 746:	8bca                	mv	s7,s2
      state = 0;
 748:	4981                	li	s3,0
 74a:	bbf5                	j	546 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 74c:	008b8993          	addi	s3,s7,8
 750:	000bb903          	ld	s2,0(s7)
 754:	00090f63          	beqz	s2,772 <vprintf+0x276>
        for(; *s; s++)
 758:	00094583          	lbu	a1,0(s2)
 75c:	c195                	beqz	a1,780 <vprintf+0x284>
          putc(fd, *s);
 75e:	855a                	mv	a0,s6
 760:	ce3ff0ef          	jal	442 <putc>
        for(; *s; s++)
 764:	0905                	addi	s2,s2,1
 766:	00094583          	lbu	a1,0(s2)
 76a:	f9f5                	bnez	a1,75e <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 76c:	8bce                	mv	s7,s3
      state = 0;
 76e:	4981                	li	s3,0
 770:	bbd9                	j	546 <vprintf+0x4a>
          s = "(null)";
 772:	00000917          	auipc	s2,0x0
 776:	24e90913          	addi	s2,s2,590 # 9c0 <malloc+0x142>
        for(; *s; s++)
 77a:	02800593          	li	a1,40
 77e:	b7c5                	j	75e <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 780:	8bce                	mv	s7,s3
      state = 0;
 782:	4981                	li	s3,0
 784:	b3c9                	j	546 <vprintf+0x4a>
 786:	64a6                	ld	s1,72(sp)
 788:	79e2                	ld	s3,56(sp)
 78a:	7a42                	ld	s4,48(sp)
 78c:	7aa2                	ld	s5,40(sp)
 78e:	7b02                	ld	s6,32(sp)
 790:	6be2                	ld	s7,24(sp)
 792:	6c42                	ld	s8,16(sp)
 794:	6ca2                	ld	s9,8(sp)
    }
  }
}
 796:	60e6                	ld	ra,88(sp)
 798:	6446                	ld	s0,80(sp)
 79a:	6906                	ld	s2,64(sp)
 79c:	6125                	addi	sp,sp,96
 79e:	8082                	ret

00000000000007a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a0:	715d                	addi	sp,sp,-80
 7a2:	ec06                	sd	ra,24(sp)
 7a4:	e822                	sd	s0,16(sp)
 7a6:	1000                	addi	s0,sp,32
 7a8:	e010                	sd	a2,0(s0)
 7aa:	e414                	sd	a3,8(s0)
 7ac:	e818                	sd	a4,16(s0)
 7ae:	ec1c                	sd	a5,24(s0)
 7b0:	03043023          	sd	a6,32(s0)
 7b4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7bc:	8622                	mv	a2,s0
 7be:	d3fff0ef          	jal	4fc <vprintf>
}
 7c2:	60e2                	ld	ra,24(sp)
 7c4:	6442                	ld	s0,16(sp)
 7c6:	6161                	addi	sp,sp,80
 7c8:	8082                	ret

00000000000007ca <printf>:

void
printf(const char *fmt, ...)
{
 7ca:	711d                	addi	sp,sp,-96
 7cc:	ec06                	sd	ra,24(sp)
 7ce:	e822                	sd	s0,16(sp)
 7d0:	1000                	addi	s0,sp,32
 7d2:	e40c                	sd	a1,8(s0)
 7d4:	e810                	sd	a2,16(s0)
 7d6:	ec14                	sd	a3,24(s0)
 7d8:	f018                	sd	a4,32(s0)
 7da:	f41c                	sd	a5,40(s0)
 7dc:	03043823          	sd	a6,48(s0)
 7e0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e4:	00840613          	addi	a2,s0,8
 7e8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ec:	85aa                	mv	a1,a0
 7ee:	4505                	li	a0,1
 7f0:	d0dff0ef          	jal	4fc <vprintf>
}
 7f4:	60e2                	ld	ra,24(sp)
 7f6:	6442                	ld	s0,16(sp)
 7f8:	6125                	addi	sp,sp,96
 7fa:	8082                	ret

00000000000007fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fc:	1141                	addi	sp,sp,-16
 7fe:	e422                	sd	s0,8(sp)
 800:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 802:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 806:	00000797          	auipc	a5,0x0
 80a:	7fa7b783          	ld	a5,2042(a5) # 1000 <freep>
 80e:	a02d                	j	838 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 810:	4618                	lw	a4,8(a2)
 812:	9f2d                	addw	a4,a4,a1
 814:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 818:	6398                	ld	a4,0(a5)
 81a:	6310                	ld	a2,0(a4)
 81c:	a83d                	j	85a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 81e:	ff852703          	lw	a4,-8(a0)
 822:	9f31                	addw	a4,a4,a2
 824:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 826:	ff053683          	ld	a3,-16(a0)
 82a:	a091                	j	86e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82c:	6398                	ld	a4,0(a5)
 82e:	00e7e463          	bltu	a5,a4,836 <free+0x3a>
 832:	00e6ea63          	bltu	a3,a4,846 <free+0x4a>
{
 836:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 838:	fed7fae3          	bgeu	a5,a3,82c <free+0x30>
 83c:	6398                	ld	a4,0(a5)
 83e:	00e6e463          	bltu	a3,a4,846 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 842:	fee7eae3          	bltu	a5,a4,836 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 846:	ff852583          	lw	a1,-8(a0)
 84a:	6390                	ld	a2,0(a5)
 84c:	02059813          	slli	a6,a1,0x20
 850:	01c85713          	srli	a4,a6,0x1c
 854:	9736                	add	a4,a4,a3
 856:	fae60de3          	beq	a2,a4,810 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 85a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 85e:	4790                	lw	a2,8(a5)
 860:	02061593          	slli	a1,a2,0x20
 864:	01c5d713          	srli	a4,a1,0x1c
 868:	973e                	add	a4,a4,a5
 86a:	fae68ae3          	beq	a3,a4,81e <free+0x22>
    p->s.ptr = bp->s.ptr;
 86e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 870:	00000717          	auipc	a4,0x0
 874:	78f73823          	sd	a5,1936(a4) # 1000 <freep>
}
 878:	6422                	ld	s0,8(sp)
 87a:	0141                	addi	sp,sp,16
 87c:	8082                	ret

000000000000087e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 87e:	7139                	addi	sp,sp,-64
 880:	fc06                	sd	ra,56(sp)
 882:	f822                	sd	s0,48(sp)
 884:	f426                	sd	s1,40(sp)
 886:	ec4e                	sd	s3,24(sp)
 888:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88a:	02051493          	slli	s1,a0,0x20
 88e:	9081                	srli	s1,s1,0x20
 890:	04bd                	addi	s1,s1,15
 892:	8091                	srli	s1,s1,0x4
 894:	0014899b          	addiw	s3,s1,1
 898:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 89a:	00000517          	auipc	a0,0x0
 89e:	76653503          	ld	a0,1894(a0) # 1000 <freep>
 8a2:	c915                	beqz	a0,8d6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a6:	4798                	lw	a4,8(a5)
 8a8:	08977a63          	bgeu	a4,s1,93c <malloc+0xbe>
 8ac:	f04a                	sd	s2,32(sp)
 8ae:	e852                	sd	s4,16(sp)
 8b0:	e456                	sd	s5,8(sp)
 8b2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8b4:	8a4e                	mv	s4,s3
 8b6:	0009871b          	sext.w	a4,s3
 8ba:	6685                	lui	a3,0x1
 8bc:	00d77363          	bgeu	a4,a3,8c2 <malloc+0x44>
 8c0:	6a05                	lui	s4,0x1
 8c2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ca:	00000917          	auipc	s2,0x0
 8ce:	73690913          	addi	s2,s2,1846 # 1000 <freep>
  if(p == SBRK_ERROR)
 8d2:	5afd                	li	s5,-1
 8d4:	a081                	j	914 <malloc+0x96>
 8d6:	f04a                	sd	s2,32(sp)
 8d8:	e852                	sd	s4,16(sp)
 8da:	e456                	sd	s5,8(sp)
 8dc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8de:	00000797          	auipc	a5,0x0
 8e2:	73278793          	addi	a5,a5,1842 # 1010 <base>
 8e6:	00000717          	auipc	a4,0x0
 8ea:	70f73d23          	sd	a5,1818(a4) # 1000 <freep>
 8ee:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8f4:	b7c1                	j	8b4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8f6:	6398                	ld	a4,0(a5)
 8f8:	e118                	sd	a4,0(a0)
 8fa:	a8a9                	j	954 <malloc+0xd6>
  hp->s.size = nu;
 8fc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 900:	0541                	addi	a0,a0,16
 902:	efbff0ef          	jal	7fc <free>
  return freep;
 906:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 90a:	c12d                	beqz	a0,96c <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 90e:	4798                	lw	a4,8(a5)
 910:	02977263          	bgeu	a4,s1,934 <malloc+0xb6>
    if(p == freep)
 914:	00093703          	ld	a4,0(s2)
 918:	853e                	mv	a0,a5
 91a:	fef719e3          	bne	a4,a5,90c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 91e:	8552                	mv	a0,s4
 920:	a19ff0ef          	jal	338 <sbrk>
  if(p == SBRK_ERROR)
 924:	fd551ce3          	bne	a0,s5,8fc <malloc+0x7e>
        return 0;
 928:	4501                	li	a0,0
 92a:	7902                	ld	s2,32(sp)
 92c:	6a42                	ld	s4,16(sp)
 92e:	6aa2                	ld	s5,8(sp)
 930:	6b02                	ld	s6,0(sp)
 932:	a03d                	j	960 <malloc+0xe2>
 934:	7902                	ld	s2,32(sp)
 936:	6a42                	ld	s4,16(sp)
 938:	6aa2                	ld	s5,8(sp)
 93a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 93c:	fae48de3          	beq	s1,a4,8f6 <malloc+0x78>
        p->s.size -= nunits;
 940:	4137073b          	subw	a4,a4,s3
 944:	c798                	sw	a4,8(a5)
        p += p->s.size;
 946:	02071693          	slli	a3,a4,0x20
 94a:	01c6d713          	srli	a4,a3,0x1c
 94e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 950:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 954:	00000717          	auipc	a4,0x0
 958:	6aa73623          	sd	a0,1708(a4) # 1000 <freep>
      return (void*)(p + 1);
 95c:	01078513          	addi	a0,a5,16
  }
}
 960:	70e2                	ld	ra,56(sp)
 962:	7442                	ld	s0,48(sp)
 964:	74a2                	ld	s1,40(sp)
 966:	69e2                	ld	s3,24(sp)
 968:	6121                	addi	sp,sp,64
 96a:	8082                	ret
 96c:	7902                	ld	s2,32(sp)
 96e:	6a42                	ld	s4,16(sp)
 970:	6aa2                	ld	s5,8(sp)
 972:	6b02                	ld	s6,0(sp)
 974:	b7f5                	j	960 <malloc+0xe2>
