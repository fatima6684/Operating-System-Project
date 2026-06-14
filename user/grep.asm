
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	02c000ef          	jal	4a <matchhere>
  22:	e919                	bnez	a0,38 <matchstar+0x38>
  }while(*text!='\0' && (*text++==c || c=='.'));
  24:	0004c783          	lbu	a5,0(s1)
  28:	cb89                	beqz	a5,3a <matchstar+0x3a>
  2a:	0485                	addi	s1,s1,1
  2c:	2781                	sext.w	a5,a5
  2e:	ff2786e3          	beq	a5,s2,1a <matchstar+0x1a>
  32:	ff4904e3          	beq	s2,s4,1a <matchstar+0x1a>
  36:	a011                	j	3a <matchstar+0x3a>
      return 1;
  38:	4505                	li	a0,1
  return 0;
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6942                	ld	s2,16(sp)
  42:	69a2                	ld	s3,8(sp)
  44:	6a02                	ld	s4,0(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret

000000000000004a <matchhere>:
  if(re[0] == '\0')
  4a:	00054703          	lbu	a4,0(a0)
  4e:	c73d                	beqz	a4,bc <matchhere+0x72>
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  58:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5a:	00154683          	lbu	a3,1(a0)
  5e:	02a00613          	li	a2,42
  62:	02c68563          	beq	a3,a2,8c <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  66:	02400613          	li	a2,36
  6a:	02c70863          	beq	a4,a2,9a <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  6e:	0005c683          	lbu	a3,0(a1)
  return 0;
  72:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  74:	ca81                	beqz	a3,84 <matchhere+0x3a>
  76:	02e00613          	li	a2,46
  7a:	02c70b63          	beq	a4,a2,b0 <matchhere+0x66>
  return 0;
  7e:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  80:	02d70863          	beq	a4,a3,b0 <matchhere+0x66>
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret
    return matchstar(re[0], re+2, text);
  8c:	862e                	mv	a2,a1
  8e:	00250593          	addi	a1,a0,2
  92:	853a                	mv	a0,a4
  94:	f6dff0ef          	jal	0 <matchstar>
  98:	b7f5                	j	84 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  9a:	c691                	beqz	a3,a6 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  9c:	0005c683          	lbu	a3,0(a1)
  a0:	fef9                	bnez	a3,7e <matchhere+0x34>
  return 0;
  a2:	4501                	li	a0,0
  a4:	b7c5                	j	84 <matchhere+0x3a>
    return *text == '\0';
  a6:	0005c503          	lbu	a0,0(a1)
  aa:	00153513          	seqz	a0,a0
  ae:	bfd9                	j	84 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b0:	0585                	addi	a1,a1,1
  b2:	00178513          	addi	a0,a5,1
  b6:	f95ff0ef          	jal	4a <matchhere>
  ba:	b7e9                	j	84 <matchhere+0x3a>
    return 1;
  bc:	4505                	li	a0,1
}
  be:	8082                	ret

00000000000000c0 <match>:
{
  c0:	1101                	addi	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	e04a                	sd	s2,0(sp)
  ca:	1000                	addi	s0,sp,32
  cc:	892a                	mv	s2,a0
  ce:	84ae                	mv	s1,a1
  if(re[0] == '^')
  d0:	00054703          	lbu	a4,0(a0)
  d4:	05e00793          	li	a5,94
  d8:	00f70c63          	beq	a4,a5,f0 <match+0x30>
    if(matchhere(re, text))
  dc:	85a6                	mv	a1,s1
  de:	854a                	mv	a0,s2
  e0:	f6bff0ef          	jal	4a <matchhere>
  e4:	e911                	bnez	a0,f8 <match+0x38>
  }while(*text++ != '\0');
  e6:	0485                	addi	s1,s1,1
  e8:	fff4c783          	lbu	a5,-1(s1)
  ec:	fbe5                	bnez	a5,dc <match+0x1c>
  ee:	a031                	j	fa <match+0x3a>
    return matchhere(re+1, text);
  f0:	0505                	addi	a0,a0,1
  f2:	f59ff0ef          	jal	4a <matchhere>
  f6:	a011                	j	fa <match+0x3a>
      return 1;
  f8:	4505                	li	a0,1
}
  fa:	60e2                	ld	ra,24(sp)
  fc:	6442                	ld	s0,16(sp)
  fe:	64a2                	ld	s1,8(sp)
 100:	6902                	ld	s2,0(sp)
 102:	6105                	addi	sp,sp,32
 104:	8082                	ret

0000000000000106 <grep>:
{
 106:	715d                	addi	sp,sp,-80
 108:	e486                	sd	ra,72(sp)
 10a:	e0a2                	sd	s0,64(sp)
 10c:	fc26                	sd	s1,56(sp)
 10e:	f84a                	sd	s2,48(sp)
 110:	f44e                	sd	s3,40(sp)
 112:	f052                	sd	s4,32(sp)
 114:	ec56                	sd	s5,24(sp)
 116:	e85a                	sd	s6,16(sp)
 118:	e45e                	sd	s7,8(sp)
 11a:	e062                	sd	s8,0(sp)
 11c:	0880                	addi	s0,sp,80
 11e:	89aa                	mv	s3,a0
 120:	8b2e                	mv	s6,a1
  m = 0;
 122:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 124:	3ff00b93          	li	s7,1023
 128:	00002a97          	auipc	s5,0x2
 12c:	ee8a8a93          	addi	s5,s5,-280 # 2010 <buf>
 130:	a835                	j	16c <grep+0x66>
      p = q+1;
 132:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 136:	45a9                	li	a1,10
 138:	854a                	mv	a0,s2
 13a:	1c4000ef          	jal	2fe <strchr>
 13e:	84aa                	mv	s1,a0
 140:	c505                	beqz	a0,168 <grep+0x62>
      *q = 0;
 142:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 146:	85ca                	mv	a1,s2
 148:	854e                	mv	a0,s3
 14a:	f77ff0ef          	jal	c0 <match>
 14e:	d175                	beqz	a0,132 <grep+0x2c>
        *q = '\n';
 150:	47a9                	li	a5,10
 152:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 156:	00148613          	addi	a2,s1,1
 15a:	4126063b          	subw	a2,a2,s2
 15e:	85ca                	mv	a1,s2
 160:	4505                	li	a0,1
 162:	3ac000ef          	jal	50e <write>
 166:	b7f1                	j	132 <grep+0x2c>
    if(m > 0){
 168:	03404563          	bgtz	s4,192 <grep+0x8c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 16c:	414b863b          	subw	a2,s7,s4
 170:	014a85b3          	add	a1,s5,s4
 174:	855a                	mv	a0,s6
 176:	390000ef          	jal	506 <read>
 17a:	02a05963          	blez	a0,1ac <grep+0xa6>
    m += n;
 17e:	00aa0c3b          	addw	s8,s4,a0
 182:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 186:	014a87b3          	add	a5,s5,s4
 18a:	00078023          	sb	zero,0(a5)
    p = buf;
 18e:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 190:	b75d                	j	136 <grep+0x30>
      m -= p - buf;
 192:	00002517          	auipc	a0,0x2
 196:	e7e50513          	addi	a0,a0,-386 # 2010 <buf>
 19a:	40a90a33          	sub	s4,s2,a0
 19e:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 1a2:	8652                	mv	a2,s4
 1a4:	85ca                	mv	a1,s2
 1a6:	26e000ef          	jal	414 <memmove>
 1aa:	b7c9                	j	16c <grep+0x66>
}
 1ac:	60a6                	ld	ra,72(sp)
 1ae:	6406                	ld	s0,64(sp)
 1b0:	74e2                	ld	s1,56(sp)
 1b2:	7942                	ld	s2,48(sp)
 1b4:	79a2                	ld	s3,40(sp)
 1b6:	7a02                	ld	s4,32(sp)
 1b8:	6ae2                	ld	s5,24(sp)
 1ba:	6b42                	ld	s6,16(sp)
 1bc:	6ba2                	ld	s7,8(sp)
 1be:	6c02                	ld	s8,0(sp)
 1c0:	6161                	addi	sp,sp,80
 1c2:	8082                	ret

00000000000001c4 <main>:
{
 1c4:	7179                	addi	sp,sp,-48
 1c6:	f406                	sd	ra,40(sp)
 1c8:	f022                	sd	s0,32(sp)
 1ca:	ec26                	sd	s1,24(sp)
 1cc:	e84a                	sd	s2,16(sp)
 1ce:	e44e                	sd	s3,8(sp)
 1d0:	e052                	sd	s4,0(sp)
 1d2:	1800                	addi	s0,sp,48
  if(argc <= 1){
 1d4:	4785                	li	a5,1
 1d6:	04a7d663          	bge	a5,a0,222 <main+0x5e>
  pattern = argv[1];
 1da:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1de:	4789                	li	a5,2
 1e0:	04a7db63          	bge	a5,a0,236 <main+0x72>
 1e4:	01058913          	addi	s2,a1,16
 1e8:	ffd5099b          	addiw	s3,a0,-3
 1ec:	02099793          	slli	a5,s3,0x20
 1f0:	01d7d993          	srli	s3,a5,0x1d
 1f4:	05e1                	addi	a1,a1,24
 1f6:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 1f8:	4581                	li	a1,0
 1fa:	00093503          	ld	a0,0(s2)
 1fe:	330000ef          	jal	52e <open>
 202:	84aa                	mv	s1,a0
 204:	04054063          	bltz	a0,244 <main+0x80>
    grep(pattern, fd);
 208:	85aa                	mv	a1,a0
 20a:	8552                	mv	a0,s4
 20c:	efbff0ef          	jal	106 <grep>
    close(fd);
 210:	8526                	mv	a0,s1
 212:	304000ef          	jal	516 <close>
  for(i = 2; i < argc; i++){
 216:	0921                	addi	s2,s2,8
 218:	ff3910e3          	bne	s2,s3,1f8 <main+0x34>
  exit(0);
 21c:	4501                	li	a0,0
 21e:	2d0000ef          	jal	4ee <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 222:	00001597          	auipc	a1,0x1
 226:	8de58593          	addi	a1,a1,-1826 # b00 <malloc+0x100>
 22a:	4509                	li	a0,2
 22c:	6f6000ef          	jal	922 <fprintf>
    exit(1);
 230:	4505                	li	a0,1
 232:	2bc000ef          	jal	4ee <exit>
    grep(pattern, 0);
 236:	4581                	li	a1,0
 238:	8552                	mv	a0,s4
 23a:	ecdff0ef          	jal	106 <grep>
    exit(0);
 23e:	4501                	li	a0,0
 240:	2ae000ef          	jal	4ee <exit>
      printf("grep: cannot open %s\n", argv[i]);
 244:	00093583          	ld	a1,0(s2)
 248:	00001517          	auipc	a0,0x1
 24c:	8d850513          	addi	a0,a0,-1832 # b20 <malloc+0x120>
 250:	6fc000ef          	jal	94c <printf>
      exit(1);
 254:	4505                	li	a0,1
 256:	298000ef          	jal	4ee <exit>

000000000000025a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 262:	f63ff0ef          	jal	1c4 <main>
  exit(r);
 266:	288000ef          	jal	4ee <exit>

000000000000026a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 270:	87aa                	mv	a5,a0
 272:	0585                	addi	a1,a1,1
 274:	0785                	addi	a5,a5,1
 276:	fff5c703          	lbu	a4,-1(a1)
 27a:	fee78fa3          	sb	a4,-1(a5)
 27e:	fb75                	bnez	a4,272 <strcpy+0x8>
    ;
  return os;
}
 280:	6422                	ld	s0,8(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret

0000000000000286 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 286:	1141                	addi	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 28c:	00054783          	lbu	a5,0(a0)
 290:	cb91                	beqz	a5,2a4 <strcmp+0x1e>
 292:	0005c703          	lbu	a4,0(a1)
 296:	00f71763          	bne	a4,a5,2a4 <strcmp+0x1e>
    p++, q++;
 29a:	0505                	addi	a0,a0,1
 29c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	fbe5                	bnez	a5,292 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2a4:	0005c503          	lbu	a0,0(a1)
}
 2a8:	40a7853b          	subw	a0,a5,a0
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <strlen>:

uint
strlen(const char *s)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	cf91                	beqz	a5,2d8 <strlen+0x26>
 2be:	0505                	addi	a0,a0,1
 2c0:	87aa                	mv	a5,a0
 2c2:	86be                	mv	a3,a5
 2c4:	0785                	addi	a5,a5,1
 2c6:	fff7c703          	lbu	a4,-1(a5)
 2ca:	ff65                	bnez	a4,2c2 <strlen+0x10>
 2cc:	40a6853b          	subw	a0,a3,a0
 2d0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
  for(n = 0; s[n]; n++)
 2d8:	4501                	li	a0,0
 2da:	bfe5                	j	2d2 <strlen+0x20>

00000000000002dc <memset>:

void*
memset(void *dst, int c, uint n)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2e2:	ca19                	beqz	a2,2f8 <memset+0x1c>
 2e4:	87aa                	mv	a5,a0
 2e6:	1602                	slli	a2,a2,0x20
 2e8:	9201                	srli	a2,a2,0x20
 2ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2f2:	0785                	addi	a5,a5,1
 2f4:	fee79de3          	bne	a5,a4,2ee <memset+0x12>
  }
  return dst;
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <strchr>:

char*
strchr(const char *s, char c)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	addi	s0,sp,16
  for(; *s; s++)
 304:	00054783          	lbu	a5,0(a0)
 308:	cb99                	beqz	a5,31e <strchr+0x20>
    if(*s == c)
 30a:	00f58763          	beq	a1,a5,318 <strchr+0x1a>
  for(; *s; s++)
 30e:	0505                	addi	a0,a0,1
 310:	00054783          	lbu	a5,0(a0)
 314:	fbfd                	bnez	a5,30a <strchr+0xc>
      return (char*)s;
  return 0;
 316:	4501                	li	a0,0
}
 318:	6422                	ld	s0,8(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret
  return 0;
 31e:	4501                	li	a0,0
 320:	bfe5                	j	318 <strchr+0x1a>

0000000000000322 <gets>:

char*
gets(char *buf, int max)
{
 322:	711d                	addi	sp,sp,-96
 324:	ec86                	sd	ra,88(sp)
 326:	e8a2                	sd	s0,80(sp)
 328:	e4a6                	sd	s1,72(sp)
 32a:	e0ca                	sd	s2,64(sp)
 32c:	fc4e                	sd	s3,56(sp)
 32e:	f852                	sd	s4,48(sp)
 330:	f456                	sd	s5,40(sp)
 332:	f05a                	sd	s6,32(sp)
 334:	ec5e                	sd	s7,24(sp)
 336:	1080                	addi	s0,sp,96
 338:	8baa                	mv	s7,a0
 33a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33c:	892a                	mv	s2,a0
 33e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 340:	4aa9                	li	s5,10
 342:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 344:	89a6                	mv	s3,s1
 346:	2485                	addiw	s1,s1,1
 348:	0344d663          	bge	s1,s4,374 <gets+0x52>
    cc = read(0, &c, 1);
 34c:	4605                	li	a2,1
 34e:	faf40593          	addi	a1,s0,-81
 352:	4501                	li	a0,0
 354:	1b2000ef          	jal	506 <read>
    if(cc < 1)
 358:	00a05e63          	blez	a0,374 <gets+0x52>
    buf[i++] = c;
 35c:	faf44783          	lbu	a5,-81(s0)
 360:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 364:	01578763          	beq	a5,s5,372 <gets+0x50>
 368:	0905                	addi	s2,s2,1
 36a:	fd679de3          	bne	a5,s6,344 <gets+0x22>
    buf[i++] = c;
 36e:	89a6                	mv	s3,s1
 370:	a011                	j	374 <gets+0x52>
 372:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 374:	99de                	add	s3,s3,s7
 376:	00098023          	sb	zero,0(s3)
  return buf;
}
 37a:	855e                	mv	a0,s7
 37c:	60e6                	ld	ra,88(sp)
 37e:	6446                	ld	s0,80(sp)
 380:	64a6                	ld	s1,72(sp)
 382:	6906                	ld	s2,64(sp)
 384:	79e2                	ld	s3,56(sp)
 386:	7a42                	ld	s4,48(sp)
 388:	7aa2                	ld	s5,40(sp)
 38a:	7b02                	ld	s6,32(sp)
 38c:	6be2                	ld	s7,24(sp)
 38e:	6125                	addi	sp,sp,96
 390:	8082                	ret

0000000000000392 <stat>:

int
stat(const char *n, struct stat *st)
{
 392:	1101                	addi	sp,sp,-32
 394:	ec06                	sd	ra,24(sp)
 396:	e822                	sd	s0,16(sp)
 398:	e04a                	sd	s2,0(sp)
 39a:	1000                	addi	s0,sp,32
 39c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 39e:	4581                	li	a1,0
 3a0:	18e000ef          	jal	52e <open>
  if(fd < 0)
 3a4:	02054263          	bltz	a0,3c8 <stat+0x36>
 3a8:	e426                	sd	s1,8(sp)
 3aa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3ac:	85ca                	mv	a1,s2
 3ae:	198000ef          	jal	546 <fstat>
 3b2:	892a                	mv	s2,a0
  close(fd);
 3b4:	8526                	mv	a0,s1
 3b6:	160000ef          	jal	516 <close>
  return r;
 3ba:	64a2                	ld	s1,8(sp)
}
 3bc:	854a                	mv	a0,s2
 3be:	60e2                	ld	ra,24(sp)
 3c0:	6442                	ld	s0,16(sp)
 3c2:	6902                	ld	s2,0(sp)
 3c4:	6105                	addi	sp,sp,32
 3c6:	8082                	ret
    return -1;
 3c8:	597d                	li	s2,-1
 3ca:	bfcd                	j	3bc <stat+0x2a>

00000000000003cc <atoi>:

int
atoi(const char *s)
{
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e422                	sd	s0,8(sp)
 3d0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3d2:	00054683          	lbu	a3,0(a0)
 3d6:	fd06879b          	addiw	a5,a3,-48
 3da:	0ff7f793          	zext.b	a5,a5
 3de:	4625                	li	a2,9
 3e0:	02f66863          	bltu	a2,a5,410 <atoi+0x44>
 3e4:	872a                	mv	a4,a0
  n = 0;
 3e6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3e8:	0705                	addi	a4,a4,1
 3ea:	0025179b          	slliw	a5,a0,0x2
 3ee:	9fa9                	addw	a5,a5,a0
 3f0:	0017979b          	slliw	a5,a5,0x1
 3f4:	9fb5                	addw	a5,a5,a3
 3f6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3fa:	00074683          	lbu	a3,0(a4)
 3fe:	fd06879b          	addiw	a5,a3,-48
 402:	0ff7f793          	zext.b	a5,a5
 406:	fef671e3          	bgeu	a2,a5,3e8 <atoi+0x1c>
  return n;
}
 40a:	6422                	ld	s0,8(sp)
 40c:	0141                	addi	sp,sp,16
 40e:	8082                	ret
  n = 0;
 410:	4501                	li	a0,0
 412:	bfe5                	j	40a <atoi+0x3e>

0000000000000414 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 414:	1141                	addi	sp,sp,-16
 416:	e422                	sd	s0,8(sp)
 418:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 41a:	02b57463          	bgeu	a0,a1,442 <memmove+0x2e>
    while(n-- > 0)
 41e:	00c05f63          	blez	a2,43c <memmove+0x28>
 422:	1602                	slli	a2,a2,0x20
 424:	9201                	srli	a2,a2,0x20
 426:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 42a:	872a                	mv	a4,a0
      *dst++ = *src++;
 42c:	0585                	addi	a1,a1,1
 42e:	0705                	addi	a4,a4,1
 430:	fff5c683          	lbu	a3,-1(a1)
 434:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 438:	fef71ae3          	bne	a4,a5,42c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 43c:	6422                	ld	s0,8(sp)
 43e:	0141                	addi	sp,sp,16
 440:	8082                	ret
    dst += n;
 442:	00c50733          	add	a4,a0,a2
    src += n;
 446:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 448:	fec05ae3          	blez	a2,43c <memmove+0x28>
 44c:	fff6079b          	addiw	a5,a2,-1
 450:	1782                	slli	a5,a5,0x20
 452:	9381                	srli	a5,a5,0x20
 454:	fff7c793          	not	a5,a5
 458:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 45a:	15fd                	addi	a1,a1,-1
 45c:	177d                	addi	a4,a4,-1
 45e:	0005c683          	lbu	a3,0(a1)
 462:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 466:	fee79ae3          	bne	a5,a4,45a <memmove+0x46>
 46a:	bfc9                	j	43c <memmove+0x28>

000000000000046c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 46c:	1141                	addi	sp,sp,-16
 46e:	e422                	sd	s0,8(sp)
 470:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 472:	ca05                	beqz	a2,4a2 <memcmp+0x36>
 474:	fff6069b          	addiw	a3,a2,-1
 478:	1682                	slli	a3,a3,0x20
 47a:	9281                	srli	a3,a3,0x20
 47c:	0685                	addi	a3,a3,1
 47e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 480:	00054783          	lbu	a5,0(a0)
 484:	0005c703          	lbu	a4,0(a1)
 488:	00e79863          	bne	a5,a4,498 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 48c:	0505                	addi	a0,a0,1
    p2++;
 48e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 490:	fed518e3          	bne	a0,a3,480 <memcmp+0x14>
  }
  return 0;
 494:	4501                	li	a0,0
 496:	a019                	j	49c <memcmp+0x30>
      return *p1 - *p2;
 498:	40e7853b          	subw	a0,a5,a4
}
 49c:	6422                	ld	s0,8(sp)
 49e:	0141                	addi	sp,sp,16
 4a0:	8082                	ret
  return 0;
 4a2:	4501                	li	a0,0
 4a4:	bfe5                	j	49c <memcmp+0x30>

00000000000004a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e406                	sd	ra,8(sp)
 4aa:	e022                	sd	s0,0(sp)
 4ac:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4ae:	f67ff0ef          	jal	414 <memmove>
}
 4b2:	60a2                	ld	ra,8(sp)
 4b4:	6402                	ld	s0,0(sp)
 4b6:	0141                	addi	sp,sp,16
 4b8:	8082                	ret

00000000000004ba <sbrk>:

char *
sbrk(int n) {
 4ba:	1141                	addi	sp,sp,-16
 4bc:	e406                	sd	ra,8(sp)
 4be:	e022                	sd	s0,0(sp)
 4c0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4c2:	4585                	li	a1,1
 4c4:	0b2000ef          	jal	576 <sys_sbrk>
}
 4c8:	60a2                	ld	ra,8(sp)
 4ca:	6402                	ld	s0,0(sp)
 4cc:	0141                	addi	sp,sp,16
 4ce:	8082                	ret

00000000000004d0 <sbrklazy>:

char *
sbrklazy(int n) {
 4d0:	1141                	addi	sp,sp,-16
 4d2:	e406                	sd	ra,8(sp)
 4d4:	e022                	sd	s0,0(sp)
 4d6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4d8:	4589                	li	a1,2
 4da:	09c000ef          	jal	576 <sys_sbrk>
}
 4de:	60a2                	ld	ra,8(sp)
 4e0:	6402                	ld	s0,0(sp)
 4e2:	0141                	addi	sp,sp,16
 4e4:	8082                	ret

00000000000004e6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4e6:	4885                	li	a7,1
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <exit>:
.global exit
exit:
 li a7, SYS_exit
 4ee:	4889                	li	a7,2
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4f6:	488d                	li	a7,3
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4fe:	4891                	li	a7,4
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <read>:
.global read
read:
 li a7, SYS_read
 506:	4895                	li	a7,5
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <write>:
.global write
write:
 li a7, SYS_write
 50e:	48c1                	li	a7,16
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <close>:
.global close
close:
 li a7, SYS_close
 516:	48d5                	li	a7,21
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <kill>:
.global kill
kill:
 li a7, SYS_kill
 51e:	4899                	li	a7,6
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <exec>:
.global exec
exec:
 li a7, SYS_exec
 526:	489d                	li	a7,7
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <open>:
.global open
open:
 li a7, SYS_open
 52e:	48bd                	li	a7,15
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 536:	48c5                	li	a7,17
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 53e:	48c9                	li	a7,18
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 546:	48a1                	li	a7,8
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <link>:
.global link
link:
 li a7, SYS_link
 54e:	48cd                	li	a7,19
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 556:	48d1                	li	a7,20
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 55e:	48a5                	li	a7,9
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <dup>:
.global dup
dup:
 li a7, SYS_dup
 566:	48a9                	li	a7,10
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 56e:	48ad                	li	a7,11
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 576:	48b1                	li	a7,12
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <pause>:
.global pause
pause:
 li a7, SYS_pause
 57e:	48b5                	li	a7,13
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 586:	48b9                	li	a7,14
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <bind>:
.global bind
bind:
 li a7, SYS_bind
 58e:	48f5                	li	a7,29
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 596:	48f9                	li	a7,30
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <send>:
.global send
send:
 li a7, SYS_send
 59e:	48fd                	li	a7,31
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <recv>:
.global recv
recv:
 li a7, SYS_recv
 5a6:	02000893          	li	a7,32
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 5b0:	02100893          	li	a7,33
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 5ba:	02200893          	li	a7,34
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5c4:	1101                	addi	sp,sp,-32
 5c6:	ec06                	sd	ra,24(sp)
 5c8:	e822                	sd	s0,16(sp)
 5ca:	1000                	addi	s0,sp,32
 5cc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5d0:	4605                	li	a2,1
 5d2:	fef40593          	addi	a1,s0,-17
 5d6:	f39ff0ef          	jal	50e <write>
}
 5da:	60e2                	ld	ra,24(sp)
 5dc:	6442                	ld	s0,16(sp)
 5de:	6105                	addi	sp,sp,32
 5e0:	8082                	ret

00000000000005e2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5e2:	715d                	addi	sp,sp,-80
 5e4:	e486                	sd	ra,72(sp)
 5e6:	e0a2                	sd	s0,64(sp)
 5e8:	f84a                	sd	s2,48(sp)
 5ea:	0880                	addi	s0,sp,80
 5ec:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 5ee:	c299                	beqz	a3,5f4 <printint+0x12>
 5f0:	0805c363          	bltz	a1,676 <printint+0x94>
  neg = 0;
 5f4:	4881                	li	a7,0
 5f6:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5fa:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5fc:	00000517          	auipc	a0,0x0
 600:	54450513          	addi	a0,a0,1348 # b40 <digits>
 604:	883e                	mv	a6,a5
 606:	2785                	addiw	a5,a5,1
 608:	02c5f733          	remu	a4,a1,a2
 60c:	972a                	add	a4,a4,a0
 60e:	00074703          	lbu	a4,0(a4)
 612:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 616:	872e                	mv	a4,a1
 618:	02c5d5b3          	divu	a1,a1,a2
 61c:	0685                	addi	a3,a3,1
 61e:	fec773e3          	bgeu	a4,a2,604 <printint+0x22>
  if(neg)
 622:	00088b63          	beqz	a7,638 <printint+0x56>
    buf[i++] = '-';
 626:	fd078793          	addi	a5,a5,-48
 62a:	97a2                	add	a5,a5,s0
 62c:	02d00713          	li	a4,45
 630:	fee78423          	sb	a4,-24(a5)
 634:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 638:	02f05a63          	blez	a5,66c <printint+0x8a>
 63c:	fc26                	sd	s1,56(sp)
 63e:	f44e                	sd	s3,40(sp)
 640:	fb840713          	addi	a4,s0,-72
 644:	00f704b3          	add	s1,a4,a5
 648:	fff70993          	addi	s3,a4,-1
 64c:	99be                	add	s3,s3,a5
 64e:	37fd                	addiw	a5,a5,-1
 650:	1782                	slli	a5,a5,0x20
 652:	9381                	srli	a5,a5,0x20
 654:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 658:	fff4c583          	lbu	a1,-1(s1)
 65c:	854a                	mv	a0,s2
 65e:	f67ff0ef          	jal	5c4 <putc>
  while(--i >= 0)
 662:	14fd                	addi	s1,s1,-1
 664:	ff349ae3          	bne	s1,s3,658 <printint+0x76>
 668:	74e2                	ld	s1,56(sp)
 66a:	79a2                	ld	s3,40(sp)
}
 66c:	60a6                	ld	ra,72(sp)
 66e:	6406                	ld	s0,64(sp)
 670:	7942                	ld	s2,48(sp)
 672:	6161                	addi	sp,sp,80
 674:	8082                	ret
    x = -xx;
 676:	40b005b3          	neg	a1,a1
    neg = 1;
 67a:	4885                	li	a7,1
    x = -xx;
 67c:	bfad                	j	5f6 <printint+0x14>

000000000000067e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 67e:	711d                	addi	sp,sp,-96
 680:	ec86                	sd	ra,88(sp)
 682:	e8a2                	sd	s0,80(sp)
 684:	e0ca                	sd	s2,64(sp)
 686:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 688:	0005c903          	lbu	s2,0(a1)
 68c:	28090663          	beqz	s2,918 <vprintf+0x29a>
 690:	e4a6                	sd	s1,72(sp)
 692:	fc4e                	sd	s3,56(sp)
 694:	f852                	sd	s4,48(sp)
 696:	f456                	sd	s5,40(sp)
 698:	f05a                	sd	s6,32(sp)
 69a:	ec5e                	sd	s7,24(sp)
 69c:	e862                	sd	s8,16(sp)
 69e:	e466                	sd	s9,8(sp)
 6a0:	8b2a                	mv	s6,a0
 6a2:	8a2e                	mv	s4,a1
 6a4:	8bb2                	mv	s7,a2
  state = 0;
 6a6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6a8:	4481                	li	s1,0
 6aa:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6ac:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6b0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6b4:	06c00c93          	li	s9,108
 6b8:	a005                	j	6d8 <vprintf+0x5a>
        putc(fd, c0);
 6ba:	85ca                	mv	a1,s2
 6bc:	855a                	mv	a0,s6
 6be:	f07ff0ef          	jal	5c4 <putc>
 6c2:	a019                	j	6c8 <vprintf+0x4a>
    } else if(state == '%'){
 6c4:	03598263          	beq	s3,s5,6e8 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6c8:	2485                	addiw	s1,s1,1
 6ca:	8726                	mv	a4,s1
 6cc:	009a07b3          	add	a5,s4,s1
 6d0:	0007c903          	lbu	s2,0(a5)
 6d4:	22090a63          	beqz	s2,908 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 6d8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6dc:	fe0994e3          	bnez	s3,6c4 <vprintf+0x46>
      if(c0 == '%'){
 6e0:	fd579de3          	bne	a5,s5,6ba <vprintf+0x3c>
        state = '%';
 6e4:	89be                	mv	s3,a5
 6e6:	b7cd                	j	6c8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6e8:	00ea06b3          	add	a3,s4,a4
 6ec:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6f0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6f2:	c681                	beqz	a3,6fa <vprintf+0x7c>
 6f4:	9752                	add	a4,a4,s4
 6f6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6fa:	05878363          	beq	a5,s8,740 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6fe:	05978d63          	beq	a5,s9,758 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 702:	07500713          	li	a4,117
 706:	0ee78763          	beq	a5,a4,7f4 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 70a:	07800713          	li	a4,120
 70e:	12e78963          	beq	a5,a4,840 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 712:	07000713          	li	a4,112
 716:	14e78e63          	beq	a5,a4,872 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 71a:	06300713          	li	a4,99
 71e:	18e78e63          	beq	a5,a4,8ba <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 722:	07300713          	li	a4,115
 726:	1ae78463          	beq	a5,a4,8ce <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 72a:	02500713          	li	a4,37
 72e:	04e79563          	bne	a5,a4,778 <vprintf+0xfa>
        putc(fd, '%');
 732:	02500593          	li	a1,37
 736:	855a                	mv	a0,s6
 738:	e8dff0ef          	jal	5c4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 73c:	4981                	li	s3,0
 73e:	b769                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 740:	008b8913          	addi	s2,s7,8
 744:	4685                	li	a3,1
 746:	4629                	li	a2,10
 748:	000ba583          	lw	a1,0(s7)
 74c:	855a                	mv	a0,s6
 74e:	e95ff0ef          	jal	5e2 <printint>
 752:	8bca                	mv	s7,s2
      state = 0;
 754:	4981                	li	s3,0
 756:	bf8d                	j	6c8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 758:	06400793          	li	a5,100
 75c:	02f68963          	beq	a3,a5,78e <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 760:	06c00793          	li	a5,108
 764:	04f68263          	beq	a3,a5,7a8 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 768:	07500793          	li	a5,117
 76c:	0af68063          	beq	a3,a5,80c <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 770:	07800793          	li	a5,120
 774:	0ef68263          	beq	a3,a5,858 <vprintf+0x1da>
        putc(fd, '%');
 778:	02500593          	li	a1,37
 77c:	855a                	mv	a0,s6
 77e:	e47ff0ef          	jal	5c4 <putc>
        putc(fd, c0);
 782:	85ca                	mv	a1,s2
 784:	855a                	mv	a0,s6
 786:	e3fff0ef          	jal	5c4 <putc>
      state = 0;
 78a:	4981                	li	s3,0
 78c:	bf35                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 78e:	008b8913          	addi	s2,s7,8
 792:	4685                	li	a3,1
 794:	4629                	li	a2,10
 796:	000bb583          	ld	a1,0(s7)
 79a:	855a                	mv	a0,s6
 79c:	e47ff0ef          	jal	5e2 <printint>
        i += 1;
 7a0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a2:	8bca                	mv	s7,s2
      state = 0;
 7a4:	4981                	li	s3,0
        i += 1;
 7a6:	b70d                	j	6c8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7a8:	06400793          	li	a5,100
 7ac:	02f60763          	beq	a2,a5,7da <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7b0:	07500793          	li	a5,117
 7b4:	06f60963          	beq	a2,a5,826 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7b8:	07800793          	li	a5,120
 7bc:	faf61ee3          	bne	a2,a5,778 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c0:	008b8913          	addi	s2,s7,8
 7c4:	4681                	li	a3,0
 7c6:	4641                	li	a2,16
 7c8:	000bb583          	ld	a1,0(s7)
 7cc:	855a                	mv	a0,s6
 7ce:	e15ff0ef          	jal	5e2 <printint>
        i += 2;
 7d2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d4:	8bca                	mv	s7,s2
      state = 0;
 7d6:	4981                	li	s3,0
        i += 2;
 7d8:	bdc5                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7da:	008b8913          	addi	s2,s7,8
 7de:	4685                	li	a3,1
 7e0:	4629                	li	a2,10
 7e2:	000bb583          	ld	a1,0(s7)
 7e6:	855a                	mv	a0,s6
 7e8:	dfbff0ef          	jal	5e2 <printint>
        i += 2;
 7ec:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ee:	8bca                	mv	s7,s2
      state = 0;
 7f0:	4981                	li	s3,0
        i += 2;
 7f2:	bdd9                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7f4:	008b8913          	addi	s2,s7,8
 7f8:	4681                	li	a3,0
 7fa:	4629                	li	a2,10
 7fc:	000be583          	lwu	a1,0(s7)
 800:	855a                	mv	a0,s6
 802:	de1ff0ef          	jal	5e2 <printint>
 806:	8bca                	mv	s7,s2
      state = 0;
 808:	4981                	li	s3,0
 80a:	bd7d                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 80c:	008b8913          	addi	s2,s7,8
 810:	4681                	li	a3,0
 812:	4629                	li	a2,10
 814:	000bb583          	ld	a1,0(s7)
 818:	855a                	mv	a0,s6
 81a:	dc9ff0ef          	jal	5e2 <printint>
        i += 1;
 81e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 820:	8bca                	mv	s7,s2
      state = 0;
 822:	4981                	li	s3,0
        i += 1;
 824:	b555                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 826:	008b8913          	addi	s2,s7,8
 82a:	4681                	li	a3,0
 82c:	4629                	li	a2,10
 82e:	000bb583          	ld	a1,0(s7)
 832:	855a                	mv	a0,s6
 834:	dafff0ef          	jal	5e2 <printint>
        i += 2;
 838:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 83a:	8bca                	mv	s7,s2
      state = 0;
 83c:	4981                	li	s3,0
        i += 2;
 83e:	b569                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 840:	008b8913          	addi	s2,s7,8
 844:	4681                	li	a3,0
 846:	4641                	li	a2,16
 848:	000be583          	lwu	a1,0(s7)
 84c:	855a                	mv	a0,s6
 84e:	d95ff0ef          	jal	5e2 <printint>
 852:	8bca                	mv	s7,s2
      state = 0;
 854:	4981                	li	s3,0
 856:	bd8d                	j	6c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 858:	008b8913          	addi	s2,s7,8
 85c:	4681                	li	a3,0
 85e:	4641                	li	a2,16
 860:	000bb583          	ld	a1,0(s7)
 864:	855a                	mv	a0,s6
 866:	d7dff0ef          	jal	5e2 <printint>
        i += 1;
 86a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 86c:	8bca                	mv	s7,s2
      state = 0;
 86e:	4981                	li	s3,0
        i += 1;
 870:	bda1                	j	6c8 <vprintf+0x4a>
 872:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 874:	008b8d13          	addi	s10,s7,8
 878:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 87c:	03000593          	li	a1,48
 880:	855a                	mv	a0,s6
 882:	d43ff0ef          	jal	5c4 <putc>
  putc(fd, 'x');
 886:	07800593          	li	a1,120
 88a:	855a                	mv	a0,s6
 88c:	d39ff0ef          	jal	5c4 <putc>
 890:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 892:	00000b97          	auipc	s7,0x0
 896:	2aeb8b93          	addi	s7,s7,686 # b40 <digits>
 89a:	03c9d793          	srli	a5,s3,0x3c
 89e:	97de                	add	a5,a5,s7
 8a0:	0007c583          	lbu	a1,0(a5)
 8a4:	855a                	mv	a0,s6
 8a6:	d1fff0ef          	jal	5c4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8aa:	0992                	slli	s3,s3,0x4
 8ac:	397d                	addiw	s2,s2,-1
 8ae:	fe0916e3          	bnez	s2,89a <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 8b2:	8bea                	mv	s7,s10
      state = 0;
 8b4:	4981                	li	s3,0
 8b6:	6d02                	ld	s10,0(sp)
 8b8:	bd01                	j	6c8 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 8ba:	008b8913          	addi	s2,s7,8
 8be:	000bc583          	lbu	a1,0(s7)
 8c2:	855a                	mv	a0,s6
 8c4:	d01ff0ef          	jal	5c4 <putc>
 8c8:	8bca                	mv	s7,s2
      state = 0;
 8ca:	4981                	li	s3,0
 8cc:	bbf5                	j	6c8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8ce:	008b8993          	addi	s3,s7,8
 8d2:	000bb903          	ld	s2,0(s7)
 8d6:	00090f63          	beqz	s2,8f4 <vprintf+0x276>
        for(; *s; s++)
 8da:	00094583          	lbu	a1,0(s2)
 8de:	c195                	beqz	a1,902 <vprintf+0x284>
          putc(fd, *s);
 8e0:	855a                	mv	a0,s6
 8e2:	ce3ff0ef          	jal	5c4 <putc>
        for(; *s; s++)
 8e6:	0905                	addi	s2,s2,1
 8e8:	00094583          	lbu	a1,0(s2)
 8ec:	f9f5                	bnez	a1,8e0 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 8ee:	8bce                	mv	s7,s3
      state = 0;
 8f0:	4981                	li	s3,0
 8f2:	bbd9                	j	6c8 <vprintf+0x4a>
          s = "(null)";
 8f4:	00000917          	auipc	s2,0x0
 8f8:	24490913          	addi	s2,s2,580 # b38 <malloc+0x138>
        for(; *s; s++)
 8fc:	02800593          	li	a1,40
 900:	b7c5                	j	8e0 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 902:	8bce                	mv	s7,s3
      state = 0;
 904:	4981                	li	s3,0
 906:	b3c9                	j	6c8 <vprintf+0x4a>
 908:	64a6                	ld	s1,72(sp)
 90a:	79e2                	ld	s3,56(sp)
 90c:	7a42                	ld	s4,48(sp)
 90e:	7aa2                	ld	s5,40(sp)
 910:	7b02                	ld	s6,32(sp)
 912:	6be2                	ld	s7,24(sp)
 914:	6c42                	ld	s8,16(sp)
 916:	6ca2                	ld	s9,8(sp)
    }
  }
}
 918:	60e6                	ld	ra,88(sp)
 91a:	6446                	ld	s0,80(sp)
 91c:	6906                	ld	s2,64(sp)
 91e:	6125                	addi	sp,sp,96
 920:	8082                	ret

0000000000000922 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 922:	715d                	addi	sp,sp,-80
 924:	ec06                	sd	ra,24(sp)
 926:	e822                	sd	s0,16(sp)
 928:	1000                	addi	s0,sp,32
 92a:	e010                	sd	a2,0(s0)
 92c:	e414                	sd	a3,8(s0)
 92e:	e818                	sd	a4,16(s0)
 930:	ec1c                	sd	a5,24(s0)
 932:	03043023          	sd	a6,32(s0)
 936:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 93a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 93e:	8622                	mv	a2,s0
 940:	d3fff0ef          	jal	67e <vprintf>
}
 944:	60e2                	ld	ra,24(sp)
 946:	6442                	ld	s0,16(sp)
 948:	6161                	addi	sp,sp,80
 94a:	8082                	ret

000000000000094c <printf>:

void
printf(const char *fmt, ...)
{
 94c:	711d                	addi	sp,sp,-96
 94e:	ec06                	sd	ra,24(sp)
 950:	e822                	sd	s0,16(sp)
 952:	1000                	addi	s0,sp,32
 954:	e40c                	sd	a1,8(s0)
 956:	e810                	sd	a2,16(s0)
 958:	ec14                	sd	a3,24(s0)
 95a:	f018                	sd	a4,32(s0)
 95c:	f41c                	sd	a5,40(s0)
 95e:	03043823          	sd	a6,48(s0)
 962:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 966:	00840613          	addi	a2,s0,8
 96a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 96e:	85aa                	mv	a1,a0
 970:	4505                	li	a0,1
 972:	d0dff0ef          	jal	67e <vprintf>
}
 976:	60e2                	ld	ra,24(sp)
 978:	6442                	ld	s0,16(sp)
 97a:	6125                	addi	sp,sp,96
 97c:	8082                	ret

000000000000097e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 97e:	1141                	addi	sp,sp,-16
 980:	e422                	sd	s0,8(sp)
 982:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 984:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 988:	00001797          	auipc	a5,0x1
 98c:	6787b783          	ld	a5,1656(a5) # 2000 <freep>
 990:	a02d                	j	9ba <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 992:	4618                	lw	a4,8(a2)
 994:	9f2d                	addw	a4,a4,a1
 996:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 99a:	6398                	ld	a4,0(a5)
 99c:	6310                	ld	a2,0(a4)
 99e:	a83d                	j	9dc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9a0:	ff852703          	lw	a4,-8(a0)
 9a4:	9f31                	addw	a4,a4,a2
 9a6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9a8:	ff053683          	ld	a3,-16(a0)
 9ac:	a091                	j	9f0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ae:	6398                	ld	a4,0(a5)
 9b0:	00e7e463          	bltu	a5,a4,9b8 <free+0x3a>
 9b4:	00e6ea63          	bltu	a3,a4,9c8 <free+0x4a>
{
 9b8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ba:	fed7fae3          	bgeu	a5,a3,9ae <free+0x30>
 9be:	6398                	ld	a4,0(a5)
 9c0:	00e6e463          	bltu	a3,a4,9c8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c4:	fee7eae3          	bltu	a5,a4,9b8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9c8:	ff852583          	lw	a1,-8(a0)
 9cc:	6390                	ld	a2,0(a5)
 9ce:	02059813          	slli	a6,a1,0x20
 9d2:	01c85713          	srli	a4,a6,0x1c
 9d6:	9736                	add	a4,a4,a3
 9d8:	fae60de3          	beq	a2,a4,992 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9dc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9e0:	4790                	lw	a2,8(a5)
 9e2:	02061593          	slli	a1,a2,0x20
 9e6:	01c5d713          	srli	a4,a1,0x1c
 9ea:	973e                	add	a4,a4,a5
 9ec:	fae68ae3          	beq	a3,a4,9a0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9f0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9f2:	00001717          	auipc	a4,0x1
 9f6:	60f73723          	sd	a5,1550(a4) # 2000 <freep>
}
 9fa:	6422                	ld	s0,8(sp)
 9fc:	0141                	addi	sp,sp,16
 9fe:	8082                	ret

0000000000000a00 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a00:	7139                	addi	sp,sp,-64
 a02:	fc06                	sd	ra,56(sp)
 a04:	f822                	sd	s0,48(sp)
 a06:	f426                	sd	s1,40(sp)
 a08:	ec4e                	sd	s3,24(sp)
 a0a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a0c:	02051493          	slli	s1,a0,0x20
 a10:	9081                	srli	s1,s1,0x20
 a12:	04bd                	addi	s1,s1,15
 a14:	8091                	srli	s1,s1,0x4
 a16:	0014899b          	addiw	s3,s1,1
 a1a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a1c:	00001517          	auipc	a0,0x1
 a20:	5e453503          	ld	a0,1508(a0) # 2000 <freep>
 a24:	c915                	beqz	a0,a58 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a26:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a28:	4798                	lw	a4,8(a5)
 a2a:	08977a63          	bgeu	a4,s1,abe <malloc+0xbe>
 a2e:	f04a                	sd	s2,32(sp)
 a30:	e852                	sd	s4,16(sp)
 a32:	e456                	sd	s5,8(sp)
 a34:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a36:	8a4e                	mv	s4,s3
 a38:	0009871b          	sext.w	a4,s3
 a3c:	6685                	lui	a3,0x1
 a3e:	00d77363          	bgeu	a4,a3,a44 <malloc+0x44>
 a42:	6a05                	lui	s4,0x1
 a44:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a48:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a4c:	00001917          	auipc	s2,0x1
 a50:	5b490913          	addi	s2,s2,1460 # 2000 <freep>
  if(p == SBRK_ERROR)
 a54:	5afd                	li	s5,-1
 a56:	a081                	j	a96 <malloc+0x96>
 a58:	f04a                	sd	s2,32(sp)
 a5a:	e852                	sd	s4,16(sp)
 a5c:	e456                	sd	s5,8(sp)
 a5e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a60:	00002797          	auipc	a5,0x2
 a64:	9b078793          	addi	a5,a5,-1616 # 2410 <base>
 a68:	00001717          	auipc	a4,0x1
 a6c:	58f73c23          	sd	a5,1432(a4) # 2000 <freep>
 a70:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a72:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a76:	b7c1                	j	a36 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a78:	6398                	ld	a4,0(a5)
 a7a:	e118                	sd	a4,0(a0)
 a7c:	a8a9                	j	ad6 <malloc+0xd6>
  hp->s.size = nu;
 a7e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a82:	0541                	addi	a0,a0,16
 a84:	efbff0ef          	jal	97e <free>
  return freep;
 a88:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a8c:	c12d                	beqz	a0,aee <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a90:	4798                	lw	a4,8(a5)
 a92:	02977263          	bgeu	a4,s1,ab6 <malloc+0xb6>
    if(p == freep)
 a96:	00093703          	ld	a4,0(s2)
 a9a:	853e                	mv	a0,a5
 a9c:	fef719e3          	bne	a4,a5,a8e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 aa0:	8552                	mv	a0,s4
 aa2:	a19ff0ef          	jal	4ba <sbrk>
  if(p == SBRK_ERROR)
 aa6:	fd551ce3          	bne	a0,s5,a7e <malloc+0x7e>
        return 0;
 aaa:	4501                	li	a0,0
 aac:	7902                	ld	s2,32(sp)
 aae:	6a42                	ld	s4,16(sp)
 ab0:	6aa2                	ld	s5,8(sp)
 ab2:	6b02                	ld	s6,0(sp)
 ab4:	a03d                	j	ae2 <malloc+0xe2>
 ab6:	7902                	ld	s2,32(sp)
 ab8:	6a42                	ld	s4,16(sp)
 aba:	6aa2                	ld	s5,8(sp)
 abc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 abe:	fae48de3          	beq	s1,a4,a78 <malloc+0x78>
        p->s.size -= nunits;
 ac2:	4137073b          	subw	a4,a4,s3
 ac6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ac8:	02071693          	slli	a3,a4,0x20
 acc:	01c6d713          	srli	a4,a3,0x1c
 ad0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ad2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ad6:	00001717          	auipc	a4,0x1
 ada:	52a73523          	sd	a0,1322(a4) # 2000 <freep>
      return (void*)(p + 1);
 ade:	01078513          	addi	a0,a5,16
  }
}
 ae2:	70e2                	ld	ra,56(sp)
 ae4:	7442                	ld	s0,48(sp)
 ae6:	74a2                	ld	s1,40(sp)
 ae8:	69e2                	ld	s3,24(sp)
 aea:	6121                	addi	sp,sp,64
 aec:	8082                	ret
 aee:	7902                	ld	s2,32(sp)
 af0:	6a42                	ld	s4,16(sp)
 af2:	6aa2                	ld	s5,8(sp)
 af4:	6b02                	ld	s6,0(sp)
 af6:	b7f5                	j	ae2 <malloc+0xe2>
