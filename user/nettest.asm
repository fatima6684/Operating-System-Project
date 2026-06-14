
user/_nettest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <txone>:
// this packet, and you can also see what
// happened with tcpdump -XXnr packets.pcap
//
void
txone()
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	1000                	addi	s0,sp,32
  printf("txone: sending one packet\n");
       8:	00002517          	auipc	a0,0x2
       c:	ee850513          	addi	a0,a0,-280 # 1ef0 <malloc+0x104>
      10:	529010ef          	jal	1d38 <printf>
  uint32 dst = 0x0A000202; // 10.0.2.2
  int dport = NET_TESTS_PORT;
  char buf[5];
  buf[0] = 't';
      14:	07400793          	li	a5,116
      18:	fef40423          	sb	a5,-24(s0)
  buf[1] = 'x';
      1c:	07800793          	li	a5,120
      20:	fef404a3          	sb	a5,-23(s0)
  buf[2] = 'o';
      24:	06f00793          	li	a5,111
      28:	fef40523          	sb	a5,-22(s0)
  buf[3] = 'n';
      2c:	06e00793          	li	a5,110
      30:	fef405a3          	sb	a5,-21(s0)
  buf[4] = 'e';
      34:	06500793          	li	a5,101
      38:	fef40623          	sb	a5,-20(s0)
  if(send(2003, dst, dport, buf, 5) < 0){
      3c:	4715                	li	a4,5
      3e:	fe840693          	addi	a3,s0,-24
      42:	6619                	lui	a2,0x6
      44:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
      48:	0a0005b7          	lui	a1,0xa000
      4c:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffbff2>
      50:	7d300513          	li	a0,2003
      54:	137010ef          	jal	198a <send>
      58:	00054663          	bltz	a0,64 <txone+0x64>
    printf("txone: send() failed\n");
  }
}
      5c:	60e2                	ld	ra,24(sp)
      5e:	6442                	ld	s0,16(sp)
      60:	6105                	addi	sp,sp,32
      62:	8082                	ret
    printf("txone: send() failed\n");
      64:	00002517          	auipc	a0,0x2
      68:	eac50513          	addi	a0,a0,-340 # 1f10 <malloc+0x124>
      6c:	4cd010ef          	jal	1d38 <printf>
}
      70:	b7f5                	j	5c <txone+0x5c>

0000000000000072 <rx>:
// outside of qemu, run
//   ./nettest.py rx
//
int
rx(char *name)
{
      72:	7151                	addi	sp,sp,-240
      74:	f586                	sd	ra,232(sp)
      76:	f1a2                	sd	s0,224(sp)
      78:	eda6                	sd	s1,216(sp)
      7a:	e9ca                	sd	s2,208(sp)
      7c:	e5ce                	sd	s3,200(sp)
      7e:	e1d2                	sd	s4,192(sp)
      80:	fd56                	sd	s5,184(sp)
      82:	f95a                	sd	s6,176(sp)
      84:	f55e                	sd	s7,168(sp)
      86:	f162                	sd	s8,160(sp)
      88:	ed66                	sd	s9,152(sp)
      8a:	1980                	addi	s0,sp,240
      8c:	892a                	mv	s2,a0
  bind(2000);
      8e:	7d000513          	li	a0,2000
      92:	0e9010ef          	jal	197a <bind>
      96:	4a91                	li	s5,4

  int lastseq = -1;
      98:	5a7d                	li	s4,-1
    if(cc < 0){
      fprintf(2, "nettest %s: recv() failed\n", name);
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
      9a:	0a0004b7          	lui	s1,0xa000
      9e:	20248493          	addi	s1,s1,514 # a000202 <base+0x9ffbff2>
      printf("wrong ip src %x\n", src);
      return 0;
    }

    if(cc < strlen("packet 1")){
      a2:	00002b17          	auipc	s6,0x2
      a6:	ebeb0b13          	addi	s6,s6,-322 # 1f60 <malloc+0x174>
      printf("len %d too short\n", cc);
      return 0;
    }

    if(cc > strlen("packet xxxxxx")){
      aa:	00002b97          	auipc	s7,0x2
      ae:	edeb8b93          	addi	s7,s7,-290 # 1f88 <malloc+0x19c>
      printf("len %d too long\n", cc);
      return 0;
    }

    if(memcmp(ibuf, "packet ", strlen("packet ")) != 0){
      b2:	00002997          	auipc	s3,0x2
      b6:	efe98993          	addi	s3,s3,-258 # 1fb0 <malloc+0x1c4>
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
      ba:	07f00713          	li	a4,127
      be:	f2040693          	addi	a3,s0,-224
      c2:	f1a40613          	addi	a2,s0,-230
      c6:	f1c40593          	addi	a1,s0,-228
      ca:	7d000513          	li	a0,2000
      ce:	0c5010ef          	jal	1992 <recv>
      d2:	8caa                	mv	s9,a0
    if(cc < 0){
      d4:	0e054963          	bltz	a0,1c6 <rx+0x154>
    if(src != 0x0A000202){ // 10.0.2.2
      d8:	f1c42583          	lw	a1,-228(s0)
      dc:	0e959e63          	bne	a1,s1,1d8 <rx+0x166>
    if(cc < strlen("packet 1")){
      e0:	855a                	mv	a0,s6
      e2:	5bc010ef          	jal	169e <strlen>
      e6:	2501                	sext.w	a0,a0
      e8:	000c8c1b          	sext.w	s8,s9
      ec:	0eac6d63          	bltu	s8,a0,1e6 <rx+0x174>
    if(cc > strlen("packet xxxxxx")){
      f0:	855e                	mv	a0,s7
      f2:	5ac010ef          	jal	169e <strlen>
      f6:	2501                	sext.w	a0,a0
      f8:	0f856f63          	bltu	a0,s8,1f6 <rx+0x184>
    if(memcmp(ibuf, "packet ", strlen("packet ")) != 0){
      fc:	854e                	mv	a0,s3
      fe:	5a0010ef          	jal	169e <strlen>
     102:	0005061b          	sext.w	a2,a0
     106:	85ce                	mv	a1,s3
     108:	f2040513          	addi	a0,s0,-224
     10c:	74c010ef          	jal	1858 <memcmp>
     110:	0e051b63          	bnez	a0,206 <rx+0x194>
      printf("packet doesn't start with packet\n");
      return 0;
    }

    ibuf[cc] = '\0';
     114:	fa0c8793          	addi	a5,s9,-96
     118:	97a2                	add	a5,a5,s0
     11a:	f8078023          	sb	zero,-128(a5)
#define isdigit(x) ((x) >= '0' && (x) <= '9')
    if(!isdigit(ibuf[7])){
     11e:	f2744583          	lbu	a1,-217(s0)
     122:	fd05879b          	addiw	a5,a1,-48
     126:	0ff7f793          	zext.b	a5,a5
     12a:	4725                	li	a4,9
     12c:	0ef76463          	bltu	a4,a5,214 <rx+0x1a2>
      printf("packet doesn't contain a number\n");
      return 0;
    }
    for(int i = 7; i < cc; i++){
     130:	479d                	li	a5,7
     132:	0397d763          	bge	a5,s9,160 <rx+0xee>
     136:	f2740713          	addi	a4,s0,-217
     13a:	ff8c069b          	addiw	a3,s8,-8
     13e:	1682                	slli	a3,a3,0x20
     140:	9281                	srli	a3,a3,0x20
     142:	f2840793          	addi	a5,s0,-216
     146:	96be                	add	a3,a3,a5
      if(!isdigit(ibuf[i])){
     148:	4625                	li	a2,9
     14a:	00074783          	lbu	a5,0(a4)
     14e:	fd07879b          	addiw	a5,a5,-48
     152:	0ff7f793          	zext.b	a5,a5
     156:	0cf66663          	bltu	a2,a5,222 <rx+0x1b0>
    for(int i = 7; i < cc; i++){
     15a:	0705                	addi	a4,a4,1
     15c:	fed717e3          	bne	a4,a3,14a <rx+0xd8>
        printf("packet contains non-digits in the number\n");
        return 0;
      }
    }
    int seq = ibuf[7] - '0';
     160:	fd05859b          	addiw	a1,a1,-48
     164:	0005871b          	sext.w	a4,a1
    if(isdigit(ibuf[8])){
     168:	f2844783          	lbu	a5,-216(s0)
     16c:	fd07869b          	addiw	a3,a5,-48
     170:	0ff6f693          	zext.b	a3,a3
     174:	4625                	li	a2,9
     176:	02d66d63          	bltu	a2,a3,1b0 <rx+0x13e>
      seq *= 10;
     17a:	0025971b          	slliw	a4,a1,0x2
     17e:	9f2d                	addw	a4,a4,a1
     180:	0017171b          	slliw	a4,a4,0x1
      seq += ibuf[8] - '0';
     184:	fd07879b          	addiw	a5,a5,-48
     188:	9fb9                	addw	a5,a5,a4
     18a:	0007871b          	sext.w	a4,a5
      if(isdigit(ibuf[9])){
     18e:	f2944603          	lbu	a2,-215(s0)
     192:	fd06069b          	addiw	a3,a2,-48
     196:	0ff6f693          	zext.b	a3,a3
     19a:	45a5                	li	a1,9
     19c:	00d5ea63          	bltu	a1,a3,1b0 <rx+0x13e>
        seq *= 10;
     1a0:	0027971b          	slliw	a4,a5,0x2
     1a4:	9f3d                	addw	a4,a4,a5
     1a6:	0017171b          	slliw	a4,a4,0x1
        seq += ibuf[9] - '0';
     1aa:	fd06061b          	addiw	a2,a2,-48
     1ae:	9f31                	addw	a4,a4,a2
      }
    }

    if(lastseq != -1){
     1b0:	57fd                	li	a5,-1
     1b2:	00fa0563          	beq	s4,a5,1bc <rx+0x14a>
      if(seq != lastseq + 1){
     1b6:	2a05                	addiw	s4,s4,1
     1b8:	08ea1963          	bne	s4,a4,24a <rx+0x1d8>
  while(ok < 4){
     1bc:	3afd                	addiw	s5,s5,-1
     1be:	080a8f63          	beqz	s5,25c <rx+0x1ea>
     1c2:	8a3a                	mv	s4,a4
     1c4:	bddd                	j	ba <rx+0x48>
      fprintf(2, "nettest %s: recv() failed\n", name);
     1c6:	864a                	mv	a2,s2
     1c8:	00002597          	auipc	a1,0x2
     1cc:	d6058593          	addi	a1,a1,-672 # 1f28 <malloc+0x13c>
     1d0:	4509                	li	a0,2
     1d2:	33d010ef          	jal	1d0e <fprintf>
      return 0;
     1d6:	a8a1                	j	22e <rx+0x1bc>
      printf("wrong ip src %x\n", src);
     1d8:	00002517          	auipc	a0,0x2
     1dc:	d7050513          	addi	a0,a0,-656 # 1f48 <malloc+0x15c>
     1e0:	359010ef          	jal	1d38 <printf>
      return 0;
     1e4:	a0a9                	j	22e <rx+0x1bc>
      printf("len %d too short\n", cc);
     1e6:	85e6                	mv	a1,s9
     1e8:	00002517          	auipc	a0,0x2
     1ec:	d8850513          	addi	a0,a0,-632 # 1f70 <malloc+0x184>
     1f0:	349010ef          	jal	1d38 <printf>
      return 0;
     1f4:	a82d                	j	22e <rx+0x1bc>
      printf("len %d too long\n", cc);
     1f6:	85e6                	mv	a1,s9
     1f8:	00002517          	auipc	a0,0x2
     1fc:	da050513          	addi	a0,a0,-608 # 1f98 <malloc+0x1ac>
     200:	339010ef          	jal	1d38 <printf>
      return 0;
     204:	a02d                	j	22e <rx+0x1bc>
      printf("packet doesn't start with packet\n");
     206:	00002517          	auipc	a0,0x2
     20a:	db250513          	addi	a0,a0,-590 # 1fb8 <malloc+0x1cc>
     20e:	32b010ef          	jal	1d38 <printf>
      return 0;
     212:	a831                	j	22e <rx+0x1bc>
      printf("packet doesn't contain a number\n");
     214:	00002517          	auipc	a0,0x2
     218:	dcc50513          	addi	a0,a0,-564 # 1fe0 <malloc+0x1f4>
     21c:	31d010ef          	jal	1d38 <printf>
      return 0;
     220:	a039                	j	22e <rx+0x1bc>
        printf("packet contains non-digits in the number\n");
     222:	00002517          	auipc	a0,0x2
     226:	de650513          	addi	a0,a0,-538 # 2008 <malloc+0x21c>
     22a:	30f010ef          	jal	1d38 <printf>
      return 0;
     22e:	4501                	li	a0,0
  }

  printf("%s: OK\n", name);

  return 1;
}
     230:	70ae                	ld	ra,232(sp)
     232:	740e                	ld	s0,224(sp)
     234:	64ee                	ld	s1,216(sp)
     236:	694e                	ld	s2,208(sp)
     238:	69ae                	ld	s3,200(sp)
     23a:	6a0e                	ld	s4,192(sp)
     23c:	7aea                	ld	s5,184(sp)
     23e:	7b4a                	ld	s6,176(sp)
     240:	7baa                	ld	s7,168(sp)
     242:	7c0a                	ld	s8,160(sp)
     244:	6cea                	ld	s9,152(sp)
     246:	616d                	addi	sp,sp,240
     248:	8082                	ret
        printf("got seq %d, expecting %d\n", seq, lastseq + 1);
     24a:	8652                	mv	a2,s4
     24c:	85ba                	mv	a1,a4
     24e:	00002517          	auipc	a0,0x2
     252:	dea50513          	addi	a0,a0,-534 # 2038 <malloc+0x24c>
     256:	2e3010ef          	jal	1d38 <printf>
        return 0;
     25a:	bfd1                	j	22e <rx+0x1bc>
  printf("%s: OK\n", name);
     25c:	85ca                	mv	a1,s2
     25e:	00002517          	auipc	a0,0x2
     262:	dfa50513          	addi	a0,a0,-518 # 2058 <malloc+0x26c>
     266:	2d3010ef          	jal	1d38 <printf>
  return 1;
     26a:	4505                	li	a0,1
     26c:	b7d1                	j	230 <rx+0x1be>

000000000000026e <rx2>:
// outside of qemu, run
//   ./nettest.py rx2
//
int
rx2()
{
     26e:	7115                	addi	sp,sp,-224
     270:	ed86                	sd	ra,216(sp)
     272:	e9a2                	sd	s0,208(sp)
     274:	e5a6                	sd	s1,200(sp)
     276:	e1ca                	sd	s2,192(sp)
     278:	fd4e                	sd	s3,184(sp)
     27a:	f952                	sd	s4,176(sp)
     27c:	f556                	sd	s5,168(sp)
     27e:	f15a                	sd	s6,160(sp)
     280:	ed5e                	sd	s7,152(sp)
     282:	1180                	addi	s0,sp,224
  bind(2000);
     284:	7d000513          	li	a0,2000
     288:	6f2010ef          	jal	197a <bind>
  bind(2001);
     28c:	7d100513          	li	a0,2001
     290:	6ea010ef          	jal	197a <bind>
     294:	490d                	li	s2,3
    if(cc < 0){
      fprintf(2, "nettest rx2: recv() failed\n");
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
     296:	0a000a37          	lui	s4,0xa000
     29a:	202a0a13          	addi	s4,s4,514 # a000202 <base+0x9ffbff2>
      printf("wrong ip src %x\n", src);
      return 0;
    }

    if(cc < strlen("one 1")){
     29e:	00002a97          	auipc	s5,0x2
     2a2:	de2a8a93          	addi	s5,s5,-542 # 2080 <malloc+0x294>
      printf("len %d too short\n", cc);
      return 0;
    }

    if(cc > strlen("one xxxxxx")){
     2a6:	00002b17          	auipc	s6,0x2
     2aa:	de2b0b13          	addi	s6,s6,-542 # 2088 <malloc+0x29c>
      printf("len %d too long\n", cc);
      return 0;
    }

    if(memcmp(ibuf, "one ", strlen("one ")) != 0){
     2ae:	00002997          	auipc	s3,0x2
     2b2:	dea98993          	addi	s3,s3,-534 # 2098 <malloc+0x2ac>
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
     2b6:	07f00713          	li	a4,127
     2ba:	f3040693          	addi	a3,s0,-208
     2be:	f2a40613          	addi	a2,s0,-214
     2c2:	f2c40593          	addi	a1,s0,-212
     2c6:	7d000513          	li	a0,2000
     2ca:	6c8010ef          	jal	1992 <recv>
     2ce:	84aa                	mv	s1,a0
    if(cc < 0){
     2d0:	16054c63          	bltz	a0,448 <rx2+0x1da>
    if(src != 0x0A000202){ // 10.0.2.2
     2d4:	f2c42583          	lw	a1,-212(s0)
     2d8:	19459163          	bne	a1,s4,45a <rx2+0x1ec>
    if(cc < strlen("one 1")){
     2dc:	8556                	mv	a0,s5
     2de:	3c0010ef          	jal	169e <strlen>
     2e2:	2501                	sext.w	a0,a0
     2e4:	00048b9b          	sext.w	s7,s1
     2e8:	18abe063          	bltu	s7,a0,468 <rx2+0x1fa>
    if(cc > strlen("one xxxxxx")){
     2ec:	855a                	mv	a0,s6
     2ee:	3b0010ef          	jal	169e <strlen>
     2f2:	2501                	sext.w	a0,a0
     2f4:	19756263          	bltu	a0,s7,478 <rx2+0x20a>
    if(memcmp(ibuf, "one ", strlen("one ")) != 0){
     2f8:	854e                	mv	a0,s3
     2fa:	3a4010ef          	jal	169e <strlen>
     2fe:	0005061b          	sext.w	a2,a0
     302:	85ce                	mv	a1,s3
     304:	f3040513          	addi	a0,s0,-208
     308:	550010ef          	jal	1858 <memcmp>
     30c:	84aa                	mv	s1,a0
     30e:	16051d63          	bnez	a0,488 <rx2+0x21a>
  for(int i = 0; i < 3; i++){
     312:	397d                	addiw	s2,s2,-1
     314:	fa0911e3          	bnez	s2,2b6 <rx2+0x48>
     318:	e962                	sd	s8,144(sp)
     31a:	498d                	li	s3,3
    if(cc < 0){
      fprintf(2, "nettest rx2: recv() failed\n");
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
     31c:	0a000ab7          	lui	s5,0xa000
     320:	202a8a93          	addi	s5,s5,514 # a000202 <base+0x9ffbff2>
      printf("wrong ip src %x\n", src);
      return 0;
    }

    if(cc < strlen("one 1")){
     324:	00002b17          	auipc	s6,0x2
     328:	d5cb0b13          	addi	s6,s6,-676 # 2080 <malloc+0x294>
      printf("len %d too short\n", cc);
      return 0;
    }

    if(cc > strlen("one xxxxxx")){
     32c:	00002b97          	auipc	s7,0x2
     330:	d5cb8b93          	addi	s7,s7,-676 # 2088 <malloc+0x29c>
      printf("len %d too long\n", cc);
      return 0;
    }

    if(memcmp(ibuf, "two ", strlen("two ")) != 0){
     334:	00002a17          	auipc	s4,0x2
     338:	d8ca0a13          	addi	s4,s4,-628 # 20c0 <malloc+0x2d4>
    int cc = recv(2001, &src, &sport, ibuf, sizeof(ibuf)-1);
     33c:	07f00713          	li	a4,127
     340:	f3040693          	addi	a3,s0,-208
     344:	f2a40613          	addi	a2,s0,-214
     348:	f2c40593          	addi	a1,s0,-212
     34c:	7d100513          	li	a0,2001
     350:	642010ef          	jal	1992 <recv>
     354:	892a                	mv	s2,a0
    if(cc < 0){
     356:	14054063          	bltz	a0,496 <rx2+0x228>
    if(src != 0x0A000202){ // 10.0.2.2
     35a:	f2c42583          	lw	a1,-212(s0)
     35e:	15559563          	bne	a1,s5,4a8 <rx2+0x23a>
    if(cc < strlen("one 1")){
     362:	855a                	mv	a0,s6
     364:	33a010ef          	jal	169e <strlen>
     368:	2501                	sext.w	a0,a0
     36a:	00090c1b          	sext.w	s8,s2
     36e:	14ac6563          	bltu	s8,a0,4b8 <rx2+0x24a>
    if(cc > strlen("one xxxxxx")){
     372:	855e                	mv	a0,s7
     374:	32a010ef          	jal	169e <strlen>
     378:	2501                	sext.w	a0,a0
     37a:	15856863          	bltu	a0,s8,4ca <rx2+0x25c>
    if(memcmp(ibuf, "two ", strlen("two ")) != 0){
     37e:	8552                	mv	a0,s4
     380:	31e010ef          	jal	169e <strlen>
     384:	0005061b          	sext.w	a2,a0
     388:	85d2                	mv	a1,s4
     38a:	f3040513          	addi	a0,s0,-208
     38e:	4ca010ef          	jal	1858 <memcmp>
     392:	892a                	mv	s2,a0
     394:	14051463          	bnez	a0,4dc <rx2+0x26e>
  for(int i = 0; i < 3; i++){
     398:	39fd                	addiw	s3,s3,-1
     39a:	fa0991e3          	bnez	s3,33c <rx2+0xce>
     39e:	498d                	li	s3,3
    if(cc < 0){
      fprintf(2, "nettest rx2: recv() failed\n");
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
     3a0:	0a000ab7          	lui	s5,0xa000
     3a4:	202a8a93          	addi	s5,s5,514 # a000202 <base+0x9ffbff2>
      printf("wrong ip src %x\n", src);
      return 0;
    }

    if(cc < strlen("one 1")){
     3a8:	00002b17          	auipc	s6,0x2
     3ac:	cd8b0b13          	addi	s6,s6,-808 # 2080 <malloc+0x294>
      printf("len %d too short\n", cc);
      return 0;
    }

    if(cc > strlen("one xxxxxx")){
     3b0:	00002b97          	auipc	s7,0x2
     3b4:	cd8b8b93          	addi	s7,s7,-808 # 2088 <malloc+0x29c>
      printf("len %d too long\n", cc);
      return 0;
    }

    if(memcmp(ibuf, "one ", strlen("one ")) != 0){
     3b8:	00002a17          	auipc	s4,0x2
     3bc:	ce0a0a13          	addi	s4,s4,-800 # 2098 <malloc+0x2ac>
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
     3c0:	07f00713          	li	a4,127
     3c4:	f3040693          	addi	a3,s0,-208
     3c8:	f2a40613          	addi	a2,s0,-214
     3cc:	f2c40593          	addi	a1,s0,-212
     3d0:	7d000513          	li	a0,2000
     3d4:	5be010ef          	jal	1992 <recv>
     3d8:	84aa                	mv	s1,a0
    if(cc < 0){
     3da:	10054963          	bltz	a0,4ec <rx2+0x27e>
    if(src != 0x0A000202){ // 10.0.2.2
     3de:	f2c42583          	lw	a1,-212(s0)
     3e2:	11559f63          	bne	a1,s5,500 <rx2+0x292>
    if(cc < strlen("one 1")){
     3e6:	855a                	mv	a0,s6
     3e8:	2b6010ef          	jal	169e <strlen>
     3ec:	2501                	sext.w	a0,a0
     3ee:	00048c1b          	sext.w	s8,s1
     3f2:	10ac6e63          	bltu	s8,a0,50e <rx2+0x2a0>
    if(cc > strlen("one xxxxxx")){
     3f6:	855e                	mv	a0,s7
     3f8:	2a6010ef          	jal	169e <strlen>
     3fc:	2501                	sext.w	a0,a0
     3fe:	13856063          	bltu	a0,s8,51e <rx2+0x2b0>
    if(memcmp(ibuf, "one ", strlen("one ")) != 0){
     402:	8552                	mv	a0,s4
     404:	29a010ef          	jal	169e <strlen>
     408:	0005061b          	sext.w	a2,a0
     40c:	85d2                	mv	a1,s4
     40e:	f3040513          	addi	a0,s0,-208
     412:	446010ef          	jal	1858 <memcmp>
     416:	10051c63          	bnez	a0,52e <rx2+0x2c0>
  for(int i = 0; i < 3; i++){
     41a:	39fd                	addiw	s3,s3,-1
     41c:	fa0992e3          	bnez	s3,3c0 <rx2+0x152>
      printf("packet doesn't start with one\n");
      return 0;
    }
  }

  printf("rx2: OK\n");
     420:	00002517          	auipc	a0,0x2
     424:	cc850513          	addi	a0,a0,-824 # 20e8 <malloc+0x2fc>
     428:	111010ef          	jal	1d38 <printf>

  return 1;
     42c:	4485                	li	s1,1
     42e:	6c4a                	ld	s8,144(sp)
}
     430:	8526                	mv	a0,s1
     432:	60ee                	ld	ra,216(sp)
     434:	644e                	ld	s0,208(sp)
     436:	64ae                	ld	s1,200(sp)
     438:	690e                	ld	s2,192(sp)
     43a:	79ea                	ld	s3,184(sp)
     43c:	7a4a                	ld	s4,176(sp)
     43e:	7aaa                	ld	s5,168(sp)
     440:	7b0a                	ld	s6,160(sp)
     442:	6bea                	ld	s7,152(sp)
     444:	612d                	addi	sp,sp,224
     446:	8082                	ret
      fprintf(2, "nettest rx2: recv() failed\n");
     448:	00002597          	auipc	a1,0x2
     44c:	c1858593          	addi	a1,a1,-1000 # 2060 <malloc+0x274>
     450:	4509                	li	a0,2
     452:	0bd010ef          	jal	1d0e <fprintf>
      return 0;
     456:	4481                	li	s1,0
     458:	bfe1                	j	430 <rx2+0x1c2>
      printf("wrong ip src %x\n", src);
     45a:	00002517          	auipc	a0,0x2
     45e:	aee50513          	addi	a0,a0,-1298 # 1f48 <malloc+0x15c>
     462:	0d7010ef          	jal	1d38 <printf>
      return 0;
     466:	bfc5                	j	456 <rx2+0x1e8>
      printf("len %d too short\n", cc);
     468:	85a6                	mv	a1,s1
     46a:	00002517          	auipc	a0,0x2
     46e:	b0650513          	addi	a0,a0,-1274 # 1f70 <malloc+0x184>
     472:	0c7010ef          	jal	1d38 <printf>
      return 0;
     476:	b7c5                	j	456 <rx2+0x1e8>
      printf("len %d too long\n", cc);
     478:	85a6                	mv	a1,s1
     47a:	00002517          	auipc	a0,0x2
     47e:	b1e50513          	addi	a0,a0,-1250 # 1f98 <malloc+0x1ac>
     482:	0b7010ef          	jal	1d38 <printf>
      return 0;
     486:	bfc1                	j	456 <rx2+0x1e8>
      printf("packet doesn't start with one\n");
     488:	00002517          	auipc	a0,0x2
     48c:	c1850513          	addi	a0,a0,-1000 # 20a0 <malloc+0x2b4>
     490:	0a9010ef          	jal	1d38 <printf>
      return 0;
     494:	b7c9                	j	456 <rx2+0x1e8>
      fprintf(2, "nettest rx2: recv() failed\n");
     496:	00002597          	auipc	a1,0x2
     49a:	bca58593          	addi	a1,a1,-1078 # 2060 <malloc+0x274>
     49e:	4509                	li	a0,2
     4a0:	06f010ef          	jal	1d0e <fprintf>
      return 0;
     4a4:	6c4a                	ld	s8,144(sp)
     4a6:	b769                	j	430 <rx2+0x1c2>
      printf("wrong ip src %x\n", src);
     4a8:	00002517          	auipc	a0,0x2
     4ac:	aa050513          	addi	a0,a0,-1376 # 1f48 <malloc+0x15c>
     4b0:	089010ef          	jal	1d38 <printf>
      return 0;
     4b4:	6c4a                	ld	s8,144(sp)
     4b6:	bfad                	j	430 <rx2+0x1c2>
      printf("len %d too short\n", cc);
     4b8:	85ca                	mv	a1,s2
     4ba:	00002517          	auipc	a0,0x2
     4be:	ab650513          	addi	a0,a0,-1354 # 1f70 <malloc+0x184>
     4c2:	077010ef          	jal	1d38 <printf>
      return 0;
     4c6:	6c4a                	ld	s8,144(sp)
     4c8:	b7a5                	j	430 <rx2+0x1c2>
      printf("len %d too long\n", cc);
     4ca:	85ca                	mv	a1,s2
     4cc:	00002517          	auipc	a0,0x2
     4d0:	acc50513          	addi	a0,a0,-1332 # 1f98 <malloc+0x1ac>
     4d4:	065010ef          	jal	1d38 <printf>
      return 0;
     4d8:	6c4a                	ld	s8,144(sp)
     4da:	bf99                	j	430 <rx2+0x1c2>
      printf("packet doesn't start with two\n");
     4dc:	00002517          	auipc	a0,0x2
     4e0:	bec50513          	addi	a0,a0,-1044 # 20c8 <malloc+0x2dc>
     4e4:	055010ef          	jal	1d38 <printf>
      return 0;
     4e8:	6c4a                	ld	s8,144(sp)
     4ea:	b799                	j	430 <rx2+0x1c2>
      fprintf(2, "nettest rx2: recv() failed\n");
     4ec:	00002597          	auipc	a1,0x2
     4f0:	b7458593          	addi	a1,a1,-1164 # 2060 <malloc+0x274>
     4f4:	4509                	li	a0,2
     4f6:	019010ef          	jal	1d0e <fprintf>
      return 0;
     4fa:	84ca                	mv	s1,s2
     4fc:	6c4a                	ld	s8,144(sp)
     4fe:	bf0d                	j	430 <rx2+0x1c2>
      printf("wrong ip src %x\n", src);
     500:	00002517          	auipc	a0,0x2
     504:	a4850513          	addi	a0,a0,-1464 # 1f48 <malloc+0x15c>
     508:	031010ef          	jal	1d38 <printf>
      return 0;
     50c:	b7fd                	j	4fa <rx2+0x28c>
      printf("len %d too short\n", cc);
     50e:	85a6                	mv	a1,s1
     510:	00002517          	auipc	a0,0x2
     514:	a6050513          	addi	a0,a0,-1440 # 1f70 <malloc+0x184>
     518:	021010ef          	jal	1d38 <printf>
      return 0;
     51c:	bff9                	j	4fa <rx2+0x28c>
      printf("len %d too long\n", cc);
     51e:	85a6                	mv	a1,s1
     520:	00002517          	auipc	a0,0x2
     524:	a7850513          	addi	a0,a0,-1416 # 1f98 <malloc+0x1ac>
     528:	011010ef          	jal	1d38 <printf>
      return 0;
     52c:	b7f9                	j	4fa <rx2+0x28c>
      printf("packet doesn't start with one\n");
     52e:	00002517          	auipc	a0,0x2
     532:	b7250513          	addi	a0,a0,-1166 # 20a0 <malloc+0x2b4>
     536:	003010ef          	jal	1d38 <printf>
      return 0;
     53a:	b7c1                	j	4fa <rx2+0x28c>

000000000000053c <tx>:
//
// send some UDP packets to nettest.py tx.
//
int
tx()
{
     53c:	715d                	addi	sp,sp,-80
     53e:	e486                	sd	ra,72(sp)
     540:	e0a2                	sd	s0,64(sp)
     542:	fc26                	sd	s1,56(sp)
     544:	f84a                	sd	s2,48(sp)
     546:	f44e                	sd	s3,40(sp)
     548:	f052                	sd	s4,32(sp)
     54a:	ec56                	sd	s5,24(sp)
     54c:	e85a                	sd	s6,16(sp)
     54e:	0880                	addi	s0,sp,80
     550:	03000493          	li	s1,48
  for(int ii = 0; ii < 5; ii++){
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[3];
    buf[0] = 't';
     554:	07400a93          	li	s5,116
    buf[1] = ' ';
     558:	02000a13          	li	s4,32
    buf[2] = '0' + ii;
    if(send(2000, dst, dport, buf, 3) < 0){
     55c:	6999                	lui	s3,0x6
     55e:	5f398993          	addi	s3,s3,1523 # 65f3 <base+0x23e3>
     562:	0a000937          	lui	s2,0xa000
     566:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffbff2>
  for(int ii = 0; ii < 5; ii++){
     56a:	03500b13          	li	s6,53
    buf[0] = 't';
     56e:	fb540c23          	sb	s5,-72(s0)
    buf[1] = ' ';
     572:	fb440ca3          	sb	s4,-71(s0)
    buf[2] = '0' + ii;
     576:	fa940d23          	sb	s1,-70(s0)
    if(send(2000, dst, dport, buf, 3) < 0){
     57a:	470d                	li	a4,3
     57c:	fb840693          	addi	a3,s0,-72
     580:	864e                	mv	a2,s3
     582:	85ca                	mv	a1,s2
     584:	7d000513          	li	a0,2000
     588:	402010ef          	jal	198a <send>
     58c:	02054563          	bltz	a0,5b6 <tx+0x7a>
      printf("send() failed\n");
      return 0;
    }
    pause(10);
     590:	4529                	li	a0,10
     592:	3d8010ef          	jal	196a <pause>
  for(int ii = 0; ii < 5; ii++){
     596:	2485                	addiw	s1,s1,1
     598:	0ff4f493          	zext.b	s1,s1
     59c:	fd6499e3          	bne	s1,s6,56e <tx+0x32>
  }

  // can't actually tell if the packets arrived.
  return 1;
     5a0:	4505                	li	a0,1
}
     5a2:	60a6                	ld	ra,72(sp)
     5a4:	6406                	ld	s0,64(sp)
     5a6:	74e2                	ld	s1,56(sp)
     5a8:	7942                	ld	s2,48(sp)
     5aa:	79a2                	ld	s3,40(sp)
     5ac:	7a02                	ld	s4,32(sp)
     5ae:	6ae2                	ld	s5,24(sp)
     5b0:	6b42                	ld	s6,16(sp)
     5b2:	6161                	addi	sp,sp,80
     5b4:	8082                	ret
      printf("send() failed\n");
     5b6:	00002517          	auipc	a0,0x2
     5ba:	b4250513          	addi	a0,a0,-1214 # 20f8 <malloc+0x30c>
     5be:	77a010ef          	jal	1d38 <printf>
      return 0;
     5c2:	4501                	li	a0,0
     5c4:	bff9                	j	5a2 <tx+0x66>

00000000000005c6 <ping0>:
// expect a reply.
// nettest.py ping must be started first.
//
int
ping0()
{
     5c6:	7171                	addi	sp,sp,-176
     5c8:	f506                	sd	ra,168(sp)
     5ca:	f122                	sd	s0,160(sp)
     5cc:	e94a                	sd	s2,144(sp)
     5ce:	1900                	addi	s0,sp,176
  printf("ping0: starting\n");
     5d0:	00002517          	auipc	a0,0x2
     5d4:	b3850513          	addi	a0,a0,-1224 # 2108 <malloc+0x31c>
     5d8:	760010ef          	jal	1d38 <printf>

  bind(2004);
     5dc:	7d400513          	li	a0,2004
     5e0:	39a010ef          	jal	197a <bind>
  
  uint32 dst = 0x0A000202; // 10.0.2.2
  int dport = NET_TESTS_PORT;
  char buf[5];
  memcpy(buf, "ping0", sizeof(buf));
     5e4:	4615                	li	a2,5
     5e6:	00002597          	auipc	a1,0x2
     5ea:	b3a58593          	addi	a1,a1,-1222 # 2120 <malloc+0x334>
     5ee:	fd840513          	addi	a0,s0,-40
     5f2:	2a0010ef          	jal	1892 <memcpy>
  if(send(2004, dst, dport, buf, sizeof(buf)) < 0){
     5f6:	4715                	li	a4,5
     5f8:	fd840693          	addi	a3,s0,-40
     5fc:	6619                	lui	a2,0x6
     5fe:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
     602:	0a0005b7          	lui	a1,0xa000
     606:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffbff2>
     60a:	7d400513          	li	a0,2004
     60e:	37c010ef          	jal	198a <send>
     612:	06054863          	bltz	a0,682 <ping0+0xbc>
     616:	ed26                	sd	s1,152(sp)
    printf("ping0: send() failed\n");
    return 0;
  }

  char ibuf[128];
  uint32 src = 0;
     618:	f4042a23          	sw	zero,-172(s0)
  uint16 sport = 0;
     61c:	f4041923          	sh	zero,-174(s0)
  memset(ibuf, 0, sizeof(ibuf));
     620:	08000613          	li	a2,128
     624:	4581                	li	a1,0
     626:	f5840513          	addi	a0,s0,-168
     62a:	09e010ef          	jal	16c8 <memset>
  int cc = recv(2004, &src, &sport, ibuf, sizeof(ibuf)-1);
     62e:	07f00713          	li	a4,127
     632:	f5840693          	addi	a3,s0,-168
     636:	f5240613          	addi	a2,s0,-174
     63a:	f5440593          	addi	a1,s0,-172
     63e:	7d400513          	li	a0,2004
     642:	350010ef          	jal	1992 <recv>
     646:	84aa                	mv	s1,a0
  if(cc < 0){
     648:	04054a63          	bltz	a0,69c <ping0+0xd6>
    fprintf(2, "ping0: recv() failed\n");
    return 0;
  }
  
  if(src != 0x0A000202){ // 10.0.2.2
     64c:	f5442583          	lw	a1,-172(s0)
     650:	0a0007b7          	lui	a5,0xa000
     654:	20278793          	addi	a5,a5,514 # a000202 <base+0x9ffbff2>
     658:	04f59c63          	bne	a1,a5,6b0 <ping0+0xea>
    printf("ping0: wrong ip src %x, expecting %x\n", src, 0x0A000202);
    return 0;
  }
  
  if(sport != NET_TESTS_PORT){
     65c:	f5245583          	lhu	a1,-174(s0)
     660:	0005871b          	sext.w	a4,a1
     664:	6799                	lui	a5,0x6
     666:	5f378793          	addi	a5,a5,1523 # 65f3 <base+0x23e3>
     66a:	04f70d63          	beq	a4,a5,6c4 <ping0+0xfe>
    printf("ping0: wrong sport %d, expecting %d\n", sport, NET_TESTS_PORT);
     66e:	863e                	mv	a2,a5
     670:	00002517          	auipc	a0,0x2
     674:	b1050513          	addi	a0,a0,-1264 # 2180 <malloc+0x394>
     678:	6c0010ef          	jal	1d38 <printf>
    return 0;
     67c:	4901                	li	s2,0
     67e:	64ea                	ld	s1,152(sp)
     680:	a801                	j	690 <ping0+0xca>
    printf("ping0: send() failed\n");
     682:	00002517          	auipc	a0,0x2
     686:	aa650513          	addi	a0,a0,-1370 # 2128 <malloc+0x33c>
     68a:	6ae010ef          	jal	1d38 <printf>
    return 0;
     68e:	4901                	li	s2,0
  }

  printf("ping0: OK\n");

  return 1;
}
     690:	854a                	mv	a0,s2
     692:	70aa                	ld	ra,168(sp)
     694:	740a                	ld	s0,160(sp)
     696:	694a                	ld	s2,144(sp)
     698:	614d                	addi	sp,sp,176
     69a:	8082                	ret
    fprintf(2, "ping0: recv() failed\n");
     69c:	00002597          	auipc	a1,0x2
     6a0:	aa458593          	addi	a1,a1,-1372 # 2140 <malloc+0x354>
     6a4:	4509                	li	a0,2
     6a6:	668010ef          	jal	1d0e <fprintf>
    return 0;
     6aa:	4901                	li	s2,0
     6ac:	64ea                	ld	s1,152(sp)
     6ae:	b7cd                	j	690 <ping0+0xca>
    printf("ping0: wrong ip src %x, expecting %x\n", src, 0x0A000202);
     6b0:	863e                	mv	a2,a5
     6b2:	00002517          	auipc	a0,0x2
     6b6:	aa650513          	addi	a0,a0,-1370 # 2158 <malloc+0x36c>
     6ba:	67e010ef          	jal	1d38 <printf>
    return 0;
     6be:	4901                	li	s2,0
     6c0:	64ea                	ld	s1,152(sp)
     6c2:	b7f9                	j	690 <ping0+0xca>
  if(memcmp(buf, ibuf, sizeof(buf)) != 0){
     6c4:	4615                	li	a2,5
     6c6:	f5840593          	addi	a1,s0,-168
     6ca:	fd840513          	addi	a0,s0,-40
     6ce:	18a010ef          	jal	1858 <memcmp>
     6d2:	892a                	mv	s2,a0
     6d4:	ed11                	bnez	a0,6f0 <ping0+0x12a>
  if(cc != sizeof(buf)){
     6d6:	4795                	li	a5,5
     6d8:	02f48563          	beq	s1,a5,702 <ping0+0x13c>
    printf("ping0: wrong length %d, expecting %ld\n", cc, sizeof(buf));
     6dc:	4615                	li	a2,5
     6de:	85a6                	mv	a1,s1
     6e0:	00002517          	auipc	a0,0x2
     6e4:	ae050513          	addi	a0,a0,-1312 # 21c0 <malloc+0x3d4>
     6e8:	650010ef          	jal	1d38 <printf>
    return 0;
     6ec:	64ea                	ld	s1,152(sp)
     6ee:	b74d                	j	690 <ping0+0xca>
    printf("ping0: wrong content\n");
     6f0:	00002517          	auipc	a0,0x2
     6f4:	ab850513          	addi	a0,a0,-1352 # 21a8 <malloc+0x3bc>
     6f8:	640010ef          	jal	1d38 <printf>
    return 0;
     6fc:	4901                	li	s2,0
     6fe:	64ea                	ld	s1,152(sp)
     700:	bf41                	j	690 <ping0+0xca>
  printf("ping0: OK\n");
     702:	00002517          	auipc	a0,0x2
     706:	ae650513          	addi	a0,a0,-1306 # 21e8 <malloc+0x3fc>
     70a:	62e010ef          	jal	1d38 <printf>
  return 1;
     70e:	4905                	li	s2,1
     710:	64ea                	ld	s1,152(sp)
     712:	bfbd                	j	690 <ping0+0xca>

0000000000000714 <ping1>:
// expect a reply to each.
// nettest.py ping must be started first.
//
int
ping1()
{
     714:	7155                	addi	sp,sp,-208
     716:	e586                	sd	ra,200(sp)
     718:	e1a2                	sd	s0,192(sp)
     71a:	fd26                	sd	s1,184(sp)
     71c:	f94a                	sd	s2,176(sp)
     71e:	f54e                	sd	s3,168(sp)
     720:	f152                	sd	s4,160(sp)
     722:	ed56                	sd	s5,152(sp)
     724:	e95a                	sd	s6,144(sp)
     726:	0980                	addi	s0,sp,208
  printf("ping1: starting\n");
     728:	00002517          	auipc	a0,0x2
     72c:	ad050513          	addi	a0,a0,-1328 # 21f8 <malloc+0x40c>
     730:	608010ef          	jal	1d38 <printf>

  bind(2005);
     734:	7d500513          	li	a0,2005
     738:	242010ef          	jal	197a <bind>
     73c:	03000493          	li	s1,48
  
  for(int ii = 0; ii < 20; ii++){
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[3];
    buf[0] = 'p';
     740:	07000b13          	li	s6,112
    buf[1] = ' ';
     744:	02000a93          	li	s5,32
    buf[2] = '0' + ii;
    if(send(2005, dst, dport, buf, 3) < 0){
     748:	6a19                	lui	s4,0x6
     74a:	5f3a0a13          	addi	s4,s4,1523 # 65f3 <base+0x23e3>
     74e:	0a0009b7          	lui	s3,0xa000
     752:	20298993          	addi	s3,s3,514 # a000202 <base+0x9ffbff2>
    buf[0] = 'p';
     756:	f3640c23          	sb	s6,-200(s0)
    buf[1] = ' ';
     75a:	f3540ca3          	sb	s5,-199(s0)
    buf[2] = '0' + ii;
     75e:	f2940d23          	sb	s1,-198(s0)
    if(send(2005, dst, dport, buf, 3) < 0){
     762:	470d                	li	a4,3
     764:	f3840693          	addi	a3,s0,-200
     768:	8652                	mv	a2,s4
     76a:	85ce                	mv	a1,s3
     76c:	7d500513          	li	a0,2005
     770:	21a010ef          	jal	198a <send>
     774:	08054063          	bltz	a0,7f4 <ping1+0xe0>
      printf("ping1: send() failed\n");
      return 0;
    }

    char ibuf[128];
    uint32 src = 0;
     778:	f2042e23          	sw	zero,-196(s0)
    uint16 sport = 0;
     77c:	f2041b23          	sh	zero,-202(s0)
    memset(ibuf, 0, sizeof(ibuf));
     780:	08000613          	li	a2,128
     784:	4581                	li	a1,0
     786:	f4040513          	addi	a0,s0,-192
     78a:	73f000ef          	jal	16c8 <memset>
    int cc = recv(2005, &src, &sport, ibuf, sizeof(ibuf)-1);
     78e:	07f00713          	li	a4,127
     792:	f4040693          	addi	a3,s0,-192
     796:	f3640613          	addi	a2,s0,-202
     79a:	f3c40593          	addi	a1,s0,-196
     79e:	7d500513          	li	a0,2005
     7a2:	1f0010ef          	jal	1992 <recv>
     7a6:	892a                	mv	s2,a0
    if(cc < 0){
     7a8:	06054763          	bltz	a0,816 <ping1+0x102>
      fprintf(2, "ping1: recv() failed\n");
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
     7ac:	f3c42583          	lw	a1,-196(s0)
     7b0:	07359b63          	bne	a1,s3,826 <ping1+0x112>
      printf("ping1: wrong ip src %x, expecting %x\n", src, 0x0A000202);
      return 0;
    }

    if(sport != NET_TESTS_PORT){
     7b4:	f3645583          	lhu	a1,-202(s0)
     7b8:	0005879b          	sext.w	a5,a1
     7bc:	09479063          	bne	a5,s4,83c <ping1+0x128>
      printf("ping1: wrong sport %d, expecting %d\n", sport, NET_TESTS_PORT);
      return 0;
    }

    if(memcmp(buf, ibuf, 3) != 0){
     7c0:	460d                	li	a2,3
     7c2:	f4040593          	addi	a1,s0,-192
     7c6:	f3840513          	addi	a0,s0,-200
     7ca:	08e010ef          	jal	1858 <memcmp>
     7ce:	e149                	bnez	a0,850 <ping1+0x13c>
      printf("ping1: wrong content\n");
      return 0;
    }

    if(cc != 3){
     7d0:	478d                	li	a5,3
     7d2:	08f91663          	bne	s2,a5,85e <ping1+0x14a>
  for(int ii = 0; ii < 20; ii++){
     7d6:	2485                	addiw	s1,s1,1
     7d8:	0ff4f493          	zext.b	s1,s1
     7dc:	04400793          	li	a5,68
     7e0:	f6f49be3          	bne	s1,a5,756 <ping1+0x42>
      printf("ping1: wrong length %d, expecting 3\n", cc);
      return 0;
    }
  }

  printf("ping1: OK\n");
     7e4:	00002517          	auipc	a0,0x2
     7e8:	aec50513          	addi	a0,a0,-1300 # 22d0 <malloc+0x4e4>
     7ec:	54c010ef          	jal	1d38 <printf>

  return 1;
     7f0:	4505                	li	a0,1
     7f2:	a801                	j	802 <ping1+0xee>
      printf("ping1: send() failed\n");
     7f4:	00002517          	auipc	a0,0x2
     7f8:	a1c50513          	addi	a0,a0,-1508 # 2210 <malloc+0x424>
     7fc:	53c010ef          	jal	1d38 <printf>
      return 0;
     800:	4501                	li	a0,0
}
     802:	60ae                	ld	ra,200(sp)
     804:	640e                	ld	s0,192(sp)
     806:	74ea                	ld	s1,184(sp)
     808:	794a                	ld	s2,176(sp)
     80a:	79aa                	ld	s3,168(sp)
     80c:	7a0a                	ld	s4,160(sp)
     80e:	6aea                	ld	s5,152(sp)
     810:	6b4a                	ld	s6,144(sp)
     812:	6169                	addi	sp,sp,208
     814:	8082                	ret
      fprintf(2, "ping1: recv() failed\n");
     816:	00002597          	auipc	a1,0x2
     81a:	a1258593          	addi	a1,a1,-1518 # 2228 <malloc+0x43c>
     81e:	4509                	li	a0,2
     820:	4ee010ef          	jal	1d0e <fprintf>
      return 0;
     824:	bff1                	j	800 <ping1+0xec>
      printf("ping1: wrong ip src %x, expecting %x\n", src, 0x0A000202);
     826:	0a000637          	lui	a2,0xa000
     82a:	20260613          	addi	a2,a2,514 # a000202 <base+0x9ffbff2>
     82e:	00002517          	auipc	a0,0x2
     832:	a1250513          	addi	a0,a0,-1518 # 2240 <malloc+0x454>
     836:	502010ef          	jal	1d38 <printf>
      return 0;
     83a:	b7d9                	j	800 <ping1+0xec>
      printf("ping1: wrong sport %d, expecting %d\n", sport, NET_TESTS_PORT);
     83c:	6619                	lui	a2,0x6
     83e:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
     842:	00002517          	auipc	a0,0x2
     846:	a2650513          	addi	a0,a0,-1498 # 2268 <malloc+0x47c>
     84a:	4ee010ef          	jal	1d38 <printf>
      return 0;
     84e:	bf4d                	j	800 <ping1+0xec>
      printf("ping1: wrong content\n");
     850:	00002517          	auipc	a0,0x2
     854:	a4050513          	addi	a0,a0,-1472 # 2290 <malloc+0x4a4>
     858:	4e0010ef          	jal	1d38 <printf>
      return 0;
     85c:	b755                	j	800 <ping1+0xec>
      printf("ping1: wrong length %d, expecting 3\n", cc);
     85e:	85ca                	mv	a1,s2
     860:	00002517          	auipc	a0,0x2
     864:	a4850513          	addi	a0,a0,-1464 # 22a8 <malloc+0x4bc>
     868:	4d0010ef          	jal	1d38 <printf>
      return 0;
     86c:	bf51                	j	800 <ping1+0xec>

000000000000086e <ping2>:
// expect a reply to each to appear on the correct port.
// nettest.py ping must be started first.
//
int
ping2()
{
     86e:	7115                	addi	sp,sp,-224
     870:	ed86                	sd	ra,216(sp)
     872:	e9a2                	sd	s0,208(sp)
     874:	e5a6                	sd	s1,200(sp)
     876:	e1ca                	sd	s2,192(sp)
     878:	fd4e                	sd	s3,184(sp)
     87a:	f952                	sd	s4,176(sp)
     87c:	f556                	sd	s5,168(sp)
     87e:	f15a                	sd	s6,160(sp)
     880:	ed5e                	sd	s7,152(sp)
     882:	1180                	addi	s0,sp,224
  printf("ping2: starting\n");
     884:	00002517          	auipc	a0,0x2
     888:	a5c50513          	addi	a0,a0,-1444 # 22e0 <malloc+0x4f4>
     88c:	4ac010ef          	jal	1d38 <printf>
  
  bind(2006);
     890:	7d600513          	li	a0,2006
     894:	0e6010ef          	jal	197a <bind>
  bind(2007);
     898:	7d700513          	li	a0,2007
     89c:	0de010ef          	jal	197a <bind>
     8a0:	06100493          	li	s1,97
  for(int ii = 0; ii < 5; ii++){
    for(int port = 2006; port <= 2007; port++){
      uint32 dst = 0x0A000202; // 10.0.2.2
      int dport = NET_TESTS_PORT;
      char buf[4];
      buf[0] = 'p';
     8a4:	07000b13          	li	s6,112
      buf[1] = ' ';
     8a8:	02000a93          	li	s5,32
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
      buf[3] = '!';
     8ac:	02100a13          	li	s4,33
      if(send(port, dst, dport, buf, 4) < 0){
     8b0:	6999                	lui	s3,0x6
     8b2:	5f398993          	addi	s3,s3,1523 # 65f3 <base+0x23e3>
     8b6:	0a000937          	lui	s2,0xa000
     8ba:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffbff2>
  for(int ii = 0; ii < 5; ii++){
     8be:	06600b93          	li	s7,102
      buf[0] = 'p';
     8c2:	f3640823          	sb	s6,-208(s0)
      buf[1] = ' ';
     8c6:	f35408a3          	sb	s5,-207(s0)
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     8ca:	f2940923          	sb	s1,-206(s0)
      buf[3] = '!';
     8ce:	f34409a3          	sb	s4,-205(s0)
      if(send(port, dst, dport, buf, 4) < 0){
     8d2:	4711                	li	a4,4
     8d4:	f3040693          	addi	a3,s0,-208
     8d8:	864e                	mv	a2,s3
     8da:	85ca                	mv	a1,s2
     8dc:	7d600513          	li	a0,2006
     8e0:	0aa010ef          	jal	198a <send>
     8e4:	10054b63          	bltz	a0,9fa <ping2+0x18c>
      buf[0] = 'p';
     8e8:	f3640823          	sb	s6,-208(s0)
      buf[1] = ' ';
     8ec:	f35408a3          	sb	s5,-207(s0)
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     8f0:	fe04879b          	addiw	a5,s1,-32
     8f4:	f2f40923          	sb	a5,-206(s0)
      buf[3] = '!';
     8f8:	f34409a3          	sb	s4,-205(s0)
      if(send(port, dst, dport, buf, 4) < 0){
     8fc:	4711                	li	a4,4
     8fe:	f3040693          	addi	a3,s0,-208
     902:	864e                	mv	a2,s3
     904:	85ca                	mv	a1,s2
     906:	7d700513          	li	a0,2007
     90a:	080010ef          	jal	198a <send>
     90e:	0e054663          	bltz	a0,9fa <ping2+0x18c>
  for(int ii = 0; ii < 5; ii++){
     912:	2485                	addiw	s1,s1,1
     914:	0ff4f493          	zext.b	s1,s1
     918:	fb7495e3          	bne	s1,s7,8c2 <ping2+0x54>
        return 0;
      }
    }
  }

  for(int port = 2006; port <= 2007; port++){
     91c:	7d600a13          	li	s4,2006
      if(cc < 0){
        fprintf(2, "ping2: recv() failed\n");
        return 0;
      }
      
      if(src != 0x0A000202){ // 10.0.2.2
     920:	0a000937          	lui	s2,0xa000
     924:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffbff2>
        printf("ping2: wrong ip src %x\n", src);
        return 0;
      }
      
      if(sport != NET_TESTS_PORT){
     928:	6999                	lui	s3,0x6
     92a:	5f398993          	addi	s3,s3,1523 # 65f3 <base+0x23e3>
    for(int ii = 0; ii < 5; ii++){
     92e:	82aa0793          	addi	a5,s4,-2006
     932:	04100493          	li	s1,65
     936:	e399                	bnez	a5,93c <ping2+0xce>
     938:	06100493          	li	s1,97
     93c:	0ff4f493          	zext.b	s1,s1
     940:	00548b93          	addi	s7,s1,5
      int cc = recv(port, &src, &sport, ibuf, sizeof(ibuf)-1);
     944:	030a1a93          	slli	s5,s4,0x30
     948:	030ada93          	srli	s5,s5,0x30
        printf("ping2: wrong sport %d\n", sport);
        return 0;
      }
      
      if(cc != 4){
     94c:	4b11                	li	s6,4
      uint32 src = 0;
     94e:	f2042623          	sw	zero,-212(s0)
      uint16 sport = 0;
     952:	f2041323          	sh	zero,-218(s0)
      memset(ibuf, 0, sizeof(ibuf));
     956:	08000613          	li	a2,128
     95a:	4581                	li	a1,0
     95c:	f3040513          	addi	a0,s0,-208
     960:	569000ef          	jal	16c8 <memset>
      int cc = recv(port, &src, &sport, ibuf, sizeof(ibuf)-1);
     964:	07f00713          	li	a4,127
     968:	f3040693          	addi	a3,s0,-208
     96c:	f2640613          	addi	a2,s0,-218
     970:	f2c40593          	addi	a1,s0,-212
     974:	8556                	mv	a0,s5
     976:	01c010ef          	jal	1992 <recv>
      if(cc < 0){
     97a:	08054863          	bltz	a0,a0a <ping2+0x19c>
      if(src != 0x0A000202){ // 10.0.2.2
     97e:	f2c42583          	lw	a1,-212(s0)
     982:	09259d63          	bne	a1,s2,a1c <ping2+0x1ae>
      if(sport != NET_TESTS_PORT){
     986:	f2645583          	lhu	a1,-218(s0)
     98a:	0005879b          	sext.w	a5,a1
     98e:	09379e63          	bne	a5,s3,a2a <ping2+0x1bc>
      if(cc != 4){
     992:	0b651363          	bne	a0,s6,a38 <ping2+0x1ca>
      }

      // printf("port=%d ii=%d: %c%c%c\n", port, ii, ibuf[0], ibuf[1], ibuf[2]);

      char buf[4];
      buf[0] = 'p';
     996:	07000793          	li	a5,112
     99a:	f2f40423          	sb	a5,-216(s0)
      buf[1] = ' ';
     99e:	02000793          	li	a5,32
     9a2:	f2f404a3          	sb	a5,-215(s0)
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     9a6:	f2940523          	sb	s1,-214(s0)
      buf[3] = '!';
     9aa:	02100793          	li	a5,33
     9ae:	f2f405a3          	sb	a5,-213(s0)

      if(memcmp(buf, ibuf, 3) != 0){
     9b2:	460d                	li	a2,3
     9b4:	f3040593          	addi	a1,s0,-208
     9b8:	f2840513          	addi	a0,s0,-216
     9bc:	69d000ef          	jal	1858 <memcmp>
     9c0:	e541                	bnez	a0,a48 <ping2+0x1da>
    for(int ii = 0; ii < 5; ii++){
     9c2:	2485                	addiw	s1,s1,1
     9c4:	0ff4f493          	zext.b	s1,s1
     9c8:	f97493e3          	bne	s1,s7,94e <ping2+0xe0>
  for(int port = 2006; port <= 2007; port++){
     9cc:	2a05                	addiw	s4,s4,1
     9ce:	7d800793          	li	a5,2008
     9d2:	f4fa1ee3          	bne	s4,a5,92e <ping2+0xc0>
        return 0;
      }
    }
  }

  printf("ping2: OK\n");
     9d6:	00002517          	auipc	a0,0x2
     9da:	9b250513          	addi	a0,a0,-1614 # 2388 <malloc+0x59c>
     9de:	35a010ef          	jal	1d38 <printf>

  return 1;
     9e2:	4505                	li	a0,1
}
     9e4:	60ee                	ld	ra,216(sp)
     9e6:	644e                	ld	s0,208(sp)
     9e8:	64ae                	ld	s1,200(sp)
     9ea:	690e                	ld	s2,192(sp)
     9ec:	79ea                	ld	s3,184(sp)
     9ee:	7a4a                	ld	s4,176(sp)
     9f0:	7aaa                	ld	s5,168(sp)
     9f2:	7b0a                	ld	s6,160(sp)
     9f4:	6bea                	ld	s7,152(sp)
     9f6:	612d                	addi	sp,sp,224
     9f8:	8082                	ret
        printf("ping2: send() failed\n");
     9fa:	00002517          	auipc	a0,0x2
     9fe:	8fe50513          	addi	a0,a0,-1794 # 22f8 <malloc+0x50c>
     a02:	336010ef          	jal	1d38 <printf>
        return 0;
     a06:	4501                	li	a0,0
     a08:	bff1                	j	9e4 <ping2+0x176>
        fprintf(2, "ping2: recv() failed\n");
     a0a:	00002597          	auipc	a1,0x2
     a0e:	90658593          	addi	a1,a1,-1786 # 2310 <malloc+0x524>
     a12:	4509                	li	a0,2
     a14:	2fa010ef          	jal	1d0e <fprintf>
        return 0;
     a18:	4501                	li	a0,0
     a1a:	b7e9                	j	9e4 <ping2+0x176>
        printf("ping2: wrong ip src %x\n", src);
     a1c:	00002517          	auipc	a0,0x2
     a20:	90c50513          	addi	a0,a0,-1780 # 2328 <malloc+0x53c>
     a24:	314010ef          	jal	1d38 <printf>
        return 0;
     a28:	bfc5                	j	a18 <ping2+0x1aa>
        printf("ping2: wrong sport %d\n", sport);
     a2a:	00002517          	auipc	a0,0x2
     a2e:	91650513          	addi	a0,a0,-1770 # 2340 <malloc+0x554>
     a32:	306010ef          	jal	1d38 <printf>
        return 0;
     a36:	b7cd                	j	a18 <ping2+0x1aa>
        printf("ping2: wrong length %d\n", cc);
     a38:	85aa                	mv	a1,a0
     a3a:	00002517          	auipc	a0,0x2
     a3e:	91e50513          	addi	a0,a0,-1762 # 2358 <malloc+0x56c>
     a42:	2f6010ef          	jal	1d38 <printf>
        return 0;
     a46:	bfc9                	j	a18 <ping2+0x1aa>
        printf("ping2: wrong content\n");
     a48:	00002517          	auipc	a0,0x2
     a4c:	92850513          	addi	a0,a0,-1752 # 2370 <malloc+0x584>
     a50:	2e8010ef          	jal	1d38 <printf>
        return 0;
     a54:	b7d1                	j	a18 <ping2+0x1aa>

0000000000000a56 <ping3>:
// check that port 2008 had a finite queue length (dropped some).
// nettest.py ping must be started first.
//
int
ping3()
{
     a56:	7151                	addi	sp,sp,-240
     a58:	f586                	sd	ra,232(sp)
     a5a:	f1a2                	sd	s0,224(sp)
     a5c:	eda6                	sd	s1,216(sp)
     a5e:	1980                	addi	s0,sp,240
  printf("ping3: starting\n");
     a60:	00002517          	auipc	a0,0x2
     a64:	93850513          	addi	a0,a0,-1736 # 2398 <malloc+0x5ac>
     a68:	2d0010ef          	jal	1d38 <printf>
  
  bind(2008);
     a6c:	7d800513          	li	a0,2008
     a70:	70b000ef          	jal	197a <bind>
  bind(2009);
     a74:	7d900513          	li	a0,2009
     a78:	703000ef          	jal	197a <bind>
  //
  {
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     a7c:	07000793          	li	a5,112
     a80:	f2f40423          	sb	a5,-216(s0)
    buf[1] = ' ';
     a84:	02000793          	li	a5,32
     a88:	f2f404a3          	sb	a5,-215(s0)
    buf[2] = 'A';
     a8c:	04100793          	li	a5,65
     a90:	f2f40523          	sb	a5,-214(s0)
    buf[3] = '!';
     a94:	02100793          	li	a5,33
     a98:	f2f405a3          	sb	a5,-213(s0)
    if(send(2009, dst, dport, buf, 4) < 0){
     a9c:	4711                	li	a4,4
     a9e:	f2840693          	addi	a3,s0,-216
     aa2:	6619                	lui	a2,0x6
     aa4:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
     aa8:	0a0005b7          	lui	a1,0xa000
     aac:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffbff2>
     ab0:	7d900513          	li	a0,2009
     ab4:	6d7000ef          	jal	198a <send>
     ab8:	1c054363          	bltz	a0,c7e <ping3+0x228>
     abc:	e9ca                	sd	s2,208(sp)
     abe:	e5ce                	sd	s3,200(sp)
     ac0:	e1d2                	sd	s4,192(sp)
     ac2:	fd56                	sd	s5,184(sp)
     ac4:	f95a                	sd	s6,176(sp)
     ac6:	f55e                	sd	s7,168(sp)
      printf("ping3: send() failed\n");
      return 0;
    }
  }
  pause(1);
     ac8:	4505                	li	a0,1
     aca:	6a1000ef          	jal	196a <pause>
  //
  // send so many packets from 2008 and 2010 that some of the
  // replies must be dropped due to the requirement
  // for finite maximum queueing.
  //
  for(int ii = 0; ii < 257; ii++){
     ace:	4481                	li	s1,0
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     ad0:	07000b13          	li	s6,112
    buf[1] = ' ';
     ad4:	02000a93          	li	s5,32
    buf[2] = 'a' + ii;
    buf[3] = '!';
     ad8:	02100a13          	li	s4,33
    int port = 2008 + (ii % 2) * 2;
    if(send(port, dst, dport, buf, 4) < 0){
     adc:	6999                	lui	s3,0x6
     ade:	5f398993          	addi	s3,s3,1523 # 65f3 <base+0x23e3>
     ae2:	0a000937          	lui	s2,0xa000
     ae6:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffbff2>
  for(int ii = 0; ii < 257; ii++){
     aea:	10100b93          	li	s7,257
    buf[0] = 'p';
     aee:	f3640423          	sb	s6,-216(s0)
    buf[1] = ' ';
     af2:	f35404a3          	sb	s5,-215(s0)
    buf[2] = 'a' + ii;
     af6:	0614879b          	addiw	a5,s1,97
     afa:	f2f40523          	sb	a5,-214(s0)
    buf[3] = '!';
     afe:	f34405a3          	sb	s4,-213(s0)
    int port = 2008 + (ii % 2) * 2;
     b02:	01f4d79b          	srliw	a5,s1,0x1f
     b06:	0097853b          	addw	a0,a5,s1
     b0a:	8905                	andi	a0,a0,1
     b0c:	9d1d                	subw	a0,a0,a5
     b0e:	3ec5051b          	addiw	a0,a0,1004
     b12:	0015151b          	slliw	a0,a0,0x1
    if(send(port, dst, dport, buf, 4) < 0){
     b16:	1542                	slli	a0,a0,0x30
     b18:	9141                	srli	a0,a0,0x30
     b1a:	4711                	li	a4,4
     b1c:	f2840693          	addi	a3,s0,-216
     b20:	864e                	mv	a2,s3
     b22:	85ca                	mv	a1,s2
     b24:	667000ef          	jal	198a <send>
     b28:	16054363          	bltz	a0,c8e <ping3+0x238>
  for(int ii = 0; ii < 257; ii++){
     b2c:	2485                	addiw	s1,s1,1
     b2e:	fd7490e3          	bne	s1,s7,aee <ping3+0x98>
      printf("ping3: send() failed\n");
      return 0;
    }
  }
  pause(1);
     b32:	4505                	li	a0,1
     b34:	637000ef          	jal	196a <pause>
  //
  {
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     b38:	07000793          	li	a5,112
     b3c:	f2f40423          	sb	a5,-216(s0)
    buf[1] = ' ';
     b40:	02000793          	li	a5,32
     b44:	f2f404a3          	sb	a5,-215(s0)
    buf[2] = 'B';
     b48:	04200793          	li	a5,66
     b4c:	f2f40523          	sb	a5,-214(s0)
    buf[3] = '!';
     b50:	02100793          	li	a5,33
     b54:	f2f405a3          	sb	a5,-213(s0)
    if(send(2009, dst, dport, buf, 4) < 0){
     b58:	4711                	li	a4,4
     b5a:	f2840693          	addi	a3,s0,-216
     b5e:	6619                	lui	a2,0x6
     b60:	5f360613          	addi	a2,a2,1523 # 65f3 <base+0x23e3>
     b64:	0a0005b7          	lui	a1,0xa000
     b68:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffbff2>
     b6c:	7d900513          	li	a0,2009
     b70:	61b000ef          	jal	198a <send>
     b74:	04100913          	li	s2,65
     b78:	12054e63          	bltz	a0,cb4 <ping3+0x25e>
    if(cc < 0){
      fprintf(2, "ping3: recv() failed\n");
      return 0;
    }
    
    if(src != 0x0A000202){ // 10.0.2.2
     b7c:	0a0009b7          	lui	s3,0xa000
     b80:	20298993          	addi	s3,s3,514 # a000202 <base+0x9ffbff2>
      printf("ping3: wrong ip src %x\n", src);
      return 0;
    }
    
    if(sport != NET_TESTS_PORT){
     b84:	6a19                	lui	s4,0x6
     b86:	5f3a0a13          	addi	s4,s4,1523 # 65f3 <base+0x23e3>
      printf("ping3: wrong sport %d\n", sport);
      return 0;
    }
      
    if(cc != 4){
     b8a:	4b11                	li	s6,4
    }

    // printf("port=%d ii=%d: %c%c%c\n", port, ii, ibuf[0], ibuf[1], ibuf[2]);

    char buf[4];
    buf[0] = 'p';
     b8c:	07000a93          	li	s5,112
    uint32 src = 0;
     b90:	f2042223          	sw	zero,-220(s0)
    uint16 sport = 0;
     b94:	f0041f23          	sh	zero,-226(s0)
    memset(ibuf, 0, sizeof(ibuf));
     b98:	08000613          	li	a2,128
     b9c:	4581                	li	a1,0
     b9e:	f2840513          	addi	a0,s0,-216
     ba2:	327000ef          	jal	16c8 <memset>
    int cc = recv(2009, &src, &sport, ibuf, sizeof(ibuf)-1);
     ba6:	07f00713          	li	a4,127
     baa:	f2840693          	addi	a3,s0,-216
     bae:	f1e40613          	addi	a2,s0,-226
     bb2:	f2440593          	addi	a1,s0,-220
     bb6:	7d900513          	li	a0,2009
     bba:	5d9000ef          	jal	1992 <recv>
    if(cc < 0){
     bbe:	10054963          	bltz	a0,cd0 <ping3+0x27a>
    if(src != 0x0A000202){ // 10.0.2.2
     bc2:	f2442583          	lw	a1,-220(s0)
     bc6:	13359463          	bne	a1,s3,cee <ping3+0x298>
    if(sport != NET_TESTS_PORT){
     bca:	f1e45583          	lhu	a1,-226(s0)
     bce:	0005879b          	sext.w	a5,a1
     bd2:	13479563          	bne	a5,s4,cfc <ping3+0x2a6>
    if(cc != 4){
     bd6:	13651a63          	bne	a0,s6,d0a <ping3+0x2b4>
    buf[0] = 'p';
     bda:	f3540023          	sb	s5,-224(s0)
    buf[1] = ' ';
     bde:	02000793          	li	a5,32
     be2:	f2f400a3          	sb	a5,-223(s0)
    buf[2] = 'A' + ii;
     be6:	f3240123          	sb	s2,-222(s0)
    buf[3] = '!';
     bea:	02100793          	li	a5,33
     bee:	f2f401a3          	sb	a5,-221(s0)
    
    if(memcmp(buf, ibuf, 3) != 0){
     bf2:	460d                	li	a2,3
     bf4:	f2840593          	addi	a1,s0,-216
     bf8:	f2040513          	addi	a0,s0,-224
     bfc:	45d000ef          	jal	1858 <memcmp>
     c00:	84aa                	mv	s1,a0
     c02:	10051c63          	bnez	a0,d1a <ping3+0x2c4>
  for(int ii = 0; ii < 2; ii++){
     c06:	2905                	addiw	s2,s2,1
     c08:	0ff97913          	zext.b	s2,s2
     c0c:	04300793          	li	a5,67
     c10:	f8f910e3          	bne	s2,a5,b90 <ping3+0x13a>

  //
  // now count how many replies were queued for 2008.
  //
  int fds[2];
  pipe(fds);
     c14:	fa840513          	addi	a0,s0,-88
     c18:	4d3000ef          	jal	18ea <pipe>
  int pid = fork();
     c1c:	4b7000ef          	jal	18d2 <fork>
     c20:	89aa                	mv	s3,a0
  if(pid == 0){
     c22:	10050363          	beqz	a0,d28 <ping3+0x2d2>
      }
      write(fds[1], "x", 1);
    }
    exit(0);
  }
  close(fds[1]);
     c26:	fac42503          	lw	a0,-84(s0)
     c2a:	4d9000ef          	jal	1902 <close>

  pause(5);
     c2e:	4515                	li	a0,5
     c30:	53b000ef          	jal	196a <pause>
  static char nbuf[512];
  int n = read(fds[0], nbuf, sizeof(nbuf));
     c34:	20000613          	li	a2,512
     c38:	00003597          	auipc	a1,0x3
     c3c:	3d858593          	addi	a1,a1,984 # 4010 <nbuf.0>
     c40:	fa842503          	lw	a0,-88(s0)
     c44:	4af000ef          	jal	18f2 <read>
     c48:	892a                	mv	s2,a0
  close(fds[0]);
     c4a:	fa842503          	lw	a0,-88(s0)
     c4e:	4b5000ef          	jal	1902 <close>
  kill(pid);
     c52:	854e                	mv	a0,s3
     c54:	4b7000ef          	jal	190a <kill>

  n -= 1; // the ":"
     c58:	fff9059b          	addiw	a1,s2,-1
  if(n > 16){
     c5c:	47c1                	li	a5,16
     c5e:	12b7cf63          	blt	a5,a1,d9c <ping3+0x346>
    printf("ping3: too many packets (%d) were queued on a UDP port\n", n);
    return 0;
  }

  printf("ping3: OK\n");
     c62:	00002517          	auipc	a0,0x2
     c66:	83e50513          	addi	a0,a0,-1986 # 24a0 <malloc+0x6b4>
     c6a:	0ce010ef          	jal	1d38 <printf>

  return 1;
     c6e:	4485                	li	s1,1
     c70:	694e                	ld	s2,208(sp)
     c72:	69ae                	ld	s3,200(sp)
     c74:	6a0e                	ld	s4,192(sp)
     c76:	7aea                	ld	s5,184(sp)
     c78:	7b4a                	ld	s6,176(sp)
     c7a:	7baa                	ld	s7,168(sp)
     c7c:	a035                	j	ca8 <ping3+0x252>
      printf("ping3: send() failed\n");
     c7e:	00001517          	auipc	a0,0x1
     c82:	73250513          	addi	a0,a0,1842 # 23b0 <malloc+0x5c4>
     c86:	0b2010ef          	jal	1d38 <printf>
      return 0;
     c8a:	4481                	li	s1,0
     c8c:	a831                	j	ca8 <ping3+0x252>
      printf("ping3: send() failed\n");
     c8e:	00001517          	auipc	a0,0x1
     c92:	72250513          	addi	a0,a0,1826 # 23b0 <malloc+0x5c4>
     c96:	0a2010ef          	jal	1d38 <printf>
      return 0;
     c9a:	4481                	li	s1,0
     c9c:	694e                	ld	s2,208(sp)
     c9e:	69ae                	ld	s3,200(sp)
     ca0:	6a0e                	ld	s4,192(sp)
     ca2:	7aea                	ld	s5,184(sp)
     ca4:	7b4a                	ld	s6,176(sp)
     ca6:	7baa                	ld	s7,168(sp)
}
     ca8:	8526                	mv	a0,s1
     caa:	70ae                	ld	ra,232(sp)
     cac:	740e                	ld	s0,224(sp)
     cae:	64ee                	ld	s1,216(sp)
     cb0:	616d                	addi	sp,sp,240
     cb2:	8082                	ret
      printf("ping3: send() failed\n");
     cb4:	00001517          	auipc	a0,0x1
     cb8:	6fc50513          	addi	a0,a0,1788 # 23b0 <malloc+0x5c4>
     cbc:	07c010ef          	jal	1d38 <printf>
      return 0;
     cc0:	4481                	li	s1,0
     cc2:	694e                	ld	s2,208(sp)
     cc4:	69ae                	ld	s3,200(sp)
     cc6:	6a0e                	ld	s4,192(sp)
     cc8:	7aea                	ld	s5,184(sp)
     cca:	7b4a                	ld	s6,176(sp)
     ccc:	7baa                	ld	s7,168(sp)
     cce:	bfe9                	j	ca8 <ping3+0x252>
      fprintf(2, "ping3: recv() failed\n");
     cd0:	00001597          	auipc	a1,0x1
     cd4:	6f858593          	addi	a1,a1,1784 # 23c8 <malloc+0x5dc>
     cd8:	4509                	li	a0,2
     cda:	034010ef          	jal	1d0e <fprintf>
      return 0;
     cde:	4481                	li	s1,0
     ce0:	694e                	ld	s2,208(sp)
     ce2:	69ae                	ld	s3,200(sp)
     ce4:	6a0e                	ld	s4,192(sp)
     ce6:	7aea                	ld	s5,184(sp)
     ce8:	7b4a                	ld	s6,176(sp)
     cea:	7baa                	ld	s7,168(sp)
     cec:	bf75                	j	ca8 <ping3+0x252>
      printf("ping3: wrong ip src %x\n", src);
     cee:	00001517          	auipc	a0,0x1
     cf2:	6f250513          	addi	a0,a0,1778 # 23e0 <malloc+0x5f4>
     cf6:	042010ef          	jal	1d38 <printf>
      return 0;
     cfa:	b7d5                	j	cde <ping3+0x288>
      printf("ping3: wrong sport %d\n", sport);
     cfc:	00001517          	auipc	a0,0x1
     d00:	6fc50513          	addi	a0,a0,1788 # 23f8 <malloc+0x60c>
     d04:	034010ef          	jal	1d38 <printf>
      return 0;
     d08:	bfd9                	j	cde <ping3+0x288>
      printf("ping3: wrong length %d\n", cc);
     d0a:	85aa                	mv	a1,a0
     d0c:	00001517          	auipc	a0,0x1
     d10:	70450513          	addi	a0,a0,1796 # 2410 <malloc+0x624>
     d14:	024010ef          	jal	1d38 <printf>
      return 0;
     d18:	b7d9                	j	cde <ping3+0x288>
      printf("ping3: wrong content\n");
     d1a:	00001517          	auipc	a0,0x1
     d1e:	70e50513          	addi	a0,a0,1806 # 2428 <malloc+0x63c>
     d22:	016010ef          	jal	1d38 <printf>
      return 0;
     d26:	bf65                	j	cde <ping3+0x288>
    close(fds[0]);
     d28:	fa842503          	lw	a0,-88(s0)
     d2c:	3d7000ef          	jal	1902 <close>
    write(fds[1], ":", 1); // ensure parent's read() doesn't block
     d30:	4605                	li	a2,1
     d32:	00001597          	auipc	a1,0x1
     d36:	70e58593          	addi	a1,a1,1806 # 2440 <malloc+0x654>
     d3a:	fac42503          	lw	a0,-84(s0)
     d3e:	3bd000ef          	jal	18fa <write>
      write(fds[1], "x", 1);
     d42:	00001497          	auipc	s1,0x1
     d46:	71e48493          	addi	s1,s1,1822 # 2460 <malloc+0x674>
     d4a:	a039                	j	d58 <ping3+0x302>
     d4c:	4605                	li	a2,1
     d4e:	85a6                	mv	a1,s1
     d50:	fac42503          	lw	a0,-84(s0)
     d54:	3a7000ef          	jal	18fa <write>
      uint32 src = 0;
     d58:	f2042223          	sw	zero,-220(s0)
      uint16 sport = 0;
     d5c:	f2041023          	sh	zero,-224(s0)
      memset(ibuf, 0, sizeof(ibuf));
     d60:	08000613          	li	a2,128
     d64:	4581                	li	a1,0
     d66:	f2840513          	addi	a0,s0,-216
     d6a:	15f000ef          	jal	16c8 <memset>
      int cc = recv(2008, &src, &sport, ibuf, sizeof(ibuf)-1);
     d6e:	07f00713          	li	a4,127
     d72:	f2840693          	addi	a3,s0,-216
     d76:	f2040613          	addi	a2,s0,-224
     d7a:	f2440593          	addi	a1,s0,-220
     d7e:	7d800513          	li	a0,2008
     d82:	411000ef          	jal	1992 <recv>
      if(cc < 0){
     d86:	fc0553e3          	bgez	a0,d4c <ping3+0x2f6>
        printf("ping3: recv failed\n");
     d8a:	00001517          	auipc	a0,0x1
     d8e:	6be50513          	addi	a0,a0,1726 # 2448 <malloc+0x65c>
     d92:	7a7000ef          	jal	1d38 <printf>
    exit(0);
     d96:	4501                	li	a0,0
     d98:	343000ef          	jal	18da <exit>
    printf("ping3: too many packets (%d) were queued on a UDP port\n", n);
     d9c:	00001517          	auipc	a0,0x1
     da0:	6cc50513          	addi	a0,a0,1740 # 2468 <malloc+0x67c>
     da4:	795000ef          	jal	1d38 <printf>
    return 0;
     da8:	694e                	ld	s2,208(sp)
     daa:	69ae                	ld	s3,200(sp)
     dac:	6a0e                	ld	s4,192(sp)
     dae:	7aea                	ld	s5,184(sp)
     db0:	7b4a                	ld	s6,176(sp)
     db2:	7baa                	ld	s7,168(sp)
     db4:	bdd5                	j	ca8 <ping3+0x252>

0000000000000db6 <encode_qname>:

// Encode a DNS name
void
encode_qname(char *qn, char *host)
{
     db6:	7139                	addi	sp,sp,-64
     db8:	fc06                	sd	ra,56(sp)
     dba:	f822                	sd	s0,48(sp)
     dbc:	f426                	sd	s1,40(sp)
     dbe:	f04a                	sd	s2,32(sp)
     dc0:	ec4e                	sd	s3,24(sp)
     dc2:	e852                	sd	s4,16(sp)
     dc4:	e456                	sd	s5,8(sp)
     dc6:	0080                	addi	s0,sp,64
     dc8:	8aaa                	mv	s5,a0
     dca:	892e                	mv	s2,a1
  char *l = host; 
  
  for(char *c = host; c < host+strlen(host)+1; c++) {
     dcc:	84ae                	mv	s1,a1
  char *l = host; 
     dce:	8a2e                	mv	s4,a1
    if(*c == '.') {
     dd0:	02e00993          	li	s3,46
  for(char *c = host; c < host+strlen(host)+1; c++) {
     dd4:	a029                	j	dde <encode_qname+0x28>
      *qn++ = (char) (c-l);
     dd6:	8ab2                	mv	s5,a2
      for(char *d = l; d < c; d++) {
        *qn++ = *d;
      }
      l = c+1; // skip .
     dd8:	00148a13          	addi	s4,s1,1
  for(char *c = host; c < host+strlen(host)+1; c++) {
     ddc:	0485                	addi	s1,s1,1
     dde:	854a                	mv	a0,s2
     de0:	0bf000ef          	jal	169e <strlen>
     de4:	02051793          	slli	a5,a0,0x20
     de8:	9381                	srli	a5,a5,0x20
     dea:	0785                	addi	a5,a5,1
     dec:	97ca                	add	a5,a5,s2
     dee:	02f4fc63          	bgeu	s1,a5,e26 <encode_qname+0x70>
    if(*c == '.') {
     df2:	0004c783          	lbu	a5,0(s1)
     df6:	ff3793e3          	bne	a5,s3,ddc <encode_qname+0x26>
      *qn++ = (char) (c-l);
     dfa:	001a8613          	addi	a2,s5,1
     dfe:	414487b3          	sub	a5,s1,s4
     e02:	00fa8023          	sb	a5,0(s5)
      for(char *d = l; d < c; d++) {
     e06:	fc9a78e3          	bgeu	s4,s1,dd6 <encode_qname+0x20>
     e0a:	87d2                	mv	a5,s4
      *qn++ = (char) (c-l);
     e0c:	8732                	mv	a4,a2
        *qn++ = *d;
     e0e:	0705                	addi	a4,a4,1
     e10:	0007c683          	lbu	a3,0(a5)
     e14:	fed70fa3          	sb	a3,-1(a4)
      for(char *d = l; d < c; d++) {
     e18:	0785                	addi	a5,a5,1
     e1a:	fef49ae3          	bne	s1,a5,e0e <encode_qname+0x58>
     e1e:	41448ab3          	sub	s5,s1,s4
     e22:	9ab2                	add	s5,s5,a2
     e24:	bf55                	j	dd8 <encode_qname+0x22>
    }
  }
  *qn = '\0';
     e26:	000a8023          	sb	zero,0(s5)
}
     e2a:	70e2                	ld	ra,56(sp)
     e2c:	7442                	ld	s0,48(sp)
     e2e:	74a2                	ld	s1,40(sp)
     e30:	7902                	ld	s2,32(sp)
     e32:	69e2                	ld	s3,24(sp)
     e34:	6a42                	ld	s4,16(sp)
     e36:	6aa2                	ld	s5,8(sp)
     e38:	6121                	addi	sp,sp,64
     e3a:	8082                	ret

0000000000000e3c <decode_qname>:

// Decode a DNS name
void
decode_qname(char *qn, int max)
{
  char *qnMax = qn + max;
     e3c:	95aa                	add	a1,a1,a0
      break;
    for(int i = 0; i < l; i++) {
      *qn = *(qn+1);
      qn++;
    }
    *qn++ = '.';
     e3e:	02e00813          	li	a6,46
    if(qn >= qnMax){
     e42:	02b56663          	bltu	a0,a1,e6e <decode_qname+0x32>
{
     e46:	1141                	addi	sp,sp,-16
     e48:	e406                	sd	ra,8(sp)
     e4a:	e022                	sd	s0,0(sp)
     e4c:	0800                	addi	s0,sp,16
      printf("invalid DNS reply\n");
     e4e:	00001517          	auipc	a0,0x1
     e52:	66250513          	addi	a0,a0,1634 # 24b0 <malloc+0x6c4>
     e56:	6e3000ef          	jal	1d38 <printf>
      exit(1);
     e5a:	4505                	li	a0,1
     e5c:	27f000ef          	jal	18da <exit>
    *qn++ = '.';
     e60:	00160793          	addi	a5,a2,1
     e64:	953e                	add	a0,a0,a5
     e66:	01068023          	sb	a6,0(a3)
    if(qn >= qnMax){
     e6a:	fcb57ee3          	bgeu	a0,a1,e46 <decode_qname+0xa>
    int l = *qn;
     e6e:	00054683          	lbu	a3,0(a0)
    if(l == 0)
     e72:	ce89                	beqz	a3,e8c <decode_qname+0x50>
    for(int i = 0; i < l; i++) {
     e74:	0006861b          	sext.w	a2,a3
     e78:	96aa                	add	a3,a3,a0
    if(l == 0)
     e7a:	87aa                	mv	a5,a0
      *qn = *(qn+1);
     e7c:	0017c703          	lbu	a4,1(a5)
     e80:	00e78023          	sb	a4,0(a5)
      qn++;
     e84:	0785                	addi	a5,a5,1
    for(int i = 0; i < l; i++) {
     e86:	fed79be3          	bne	a5,a3,e7c <decode_qname+0x40>
     e8a:	bfd9                	j	e60 <decode_qname+0x24>
     e8c:	8082                	ret

0000000000000e8e <dns_req>:
}

// Make a DNS request
int
dns_req(uint8 *obuf)
{
     e8e:	7179                	addi	sp,sp,-48
     e90:	f406                	sd	ra,40(sp)
     e92:	f022                	sd	s0,32(sp)
     e94:	ec26                	sd	s1,24(sp)
     e96:	e84a                	sd	s2,16(sp)
     e98:	e44e                	sd	s3,8(sp)
     e9a:	1800                	addi	s0,sp,48
  int len = 0;
  
  struct dns *hdr = (struct dns *) obuf;
  hdr->id = htons(6828);
     e9c:	47e9                	li	a5,26
     e9e:	00f50023          	sb	a5,0(a0)
     ea2:	fac00793          	li	a5,-84
     ea6:	00f500a3          	sb	a5,1(a0)
  hdr->rd = 1;
     eaa:	00254783          	lbu	a5,2(a0)
     eae:	0017e793          	ori	a5,a5,1
     eb2:	00f50123          	sb	a5,2(a0)
  hdr->qdcount = htons(1);
     eb6:	00050223          	sb	zero,4(a0)
     eba:	4985                	li	s3,1
     ebc:	013502a3          	sb	s3,5(a0)
  
  len += sizeof(struct dns);
  
  // qname part of question
  char *qname = (char *) (obuf + sizeof(struct dns));
     ec0:	00c50493          	addi	s1,a0,12
  char *s = "pdos.csail.mit.edu.";
  encode_qname(qname, s);
     ec4:	00001597          	auipc	a1,0x1
     ec8:	60458593          	addi	a1,a1,1540 # 24c8 <malloc+0x6dc>
     ecc:	8526                	mv	a0,s1
     ece:	ee9ff0ef          	jal	db6 <encode_qname>
  len += strlen(qname) + 1;
     ed2:	8526                	mv	a0,s1
     ed4:	7ca000ef          	jal	169e <strlen>
     ed8:	0005091b          	sext.w	s2,a0

  // constants part of question
  struct dns_question *h = (struct dns_question *) (qname+strlen(qname)+1);
     edc:	8526                	mv	a0,s1
     ede:	7c0000ef          	jal	169e <strlen>
     ee2:	02051793          	slli	a5,a0,0x20
     ee6:	9381                	srli	a5,a5,0x20
     ee8:	0785                	addi	a5,a5,1
     eea:	00f48533          	add	a0,s1,a5
  h->qtype = htons(0x1);
     eee:	00050023          	sb	zero,0(a0)
     ef2:	013500a3          	sb	s3,1(a0)
  h->qclass = htons(0x1);
     ef6:	00050123          	sb	zero,2(a0)
     efa:	013501a3          	sb	s3,3(a0)

  len += sizeof(struct dns_question);
  return len;
}
     efe:	0119051b          	addiw	a0,s2,17
     f02:	70a2                	ld	ra,40(sp)
     f04:	7402                	ld	s0,32(sp)
     f06:	64e2                	ld	s1,24(sp)
     f08:	6942                	ld	s2,16(sp)
     f0a:	69a2                	ld	s3,8(sp)
     f0c:	6145                	addi	sp,sp,48
     f0e:	8082                	ret

0000000000000f10 <dns_rep>:

// Process DNS response
int
dns_rep(uint8 *ibuf, int cc)
{
     f10:	7119                	addi	sp,sp,-128
     f12:	fc86                	sd	ra,120(sp)
     f14:	f8a2                	sd	s0,112(sp)
     f16:	f862                	sd	s8,48(sp)
     f18:	0100                	addi	s0,sp,128
  struct dns *hdr = (struct dns *) ibuf;
  int len;
  char *qname = 0;
  int record = 0;

  if(cc < sizeof(struct dns)){
     f1a:	47ad                	li	a5,11
     f1c:	0cb7f863          	bgeu	a5,a1,fec <dns_rep+0xdc>
     f20:	f0ca                	sd	s2,96(sp)
     f22:	e4d6                	sd	s5,72(sp)
     f24:	892a                	mv	s2,a0
     f26:	8aae                	mv	s5,a1
    printf("DNS reply too short\n");
    return 0;
  }

  if(!hdr->qr) {
     f28:	00250783          	lb	a5,2(a0)
     f2c:	0c07d863          	bgez	a5,ffc <dns_rep+0xec>
    printf("Not a DNS reply for %d\n", ntohs(hdr->id));
    return 0;
  }

  if(hdr->id != htons(6828)){
     f30:	00054703          	lbu	a4,0(a0)
     f34:	00154783          	lbu	a5,1(a0)
     f38:	07a2                	slli	a5,a5,0x8
     f3a:	00e7e6b3          	or	a3,a5,a4
     f3e:	672d                	lui	a4,0xb
     f40:	c1a70713          	addi	a4,a4,-998 # ac1a <base+0x6a0a>
     f44:	0ee69863          	bne	a3,a4,1034 <dns_rep+0x124>
    printf("DNS wrong id: %d\n", ntohs(hdr->id));
    return 0;
  }
  
  if(hdr->rcode != 0) {
     f48:	00354783          	lbu	a5,3(a0)
     f4c:	8bbd                	andi	a5,a5,15
     f4e:	10079463          	bnez	a5,1056 <dns_rep+0x146>
     f52:	f4a6                	sd	s1,104(sp)
     f54:	ecce                	sd	s3,88(sp)
     f56:	e8d2                	sd	s4,80(sp)
  //printf("nscount: %x\n", ntohs(hdr->nscount));
  //printf("arcount: %x\n", ntohs(hdr->arcount));
  
  len = sizeof(struct dns);

  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     f58:	00454703          	lbu	a4,4(a0)
     f5c:	00554783          	lbu	a5,5(a0)
     f60:	07a2                	slli	a5,a5,0x8
     f62:	8fd9                	or	a5,a5,a4
     f64:	4a01                	li	s4,0
  len = sizeof(struct dns);
     f66:	44b1                	li	s1,12
  char *qname = 0;
     f68:	4981                	li	s3,0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     f6a:	cf85                	beqz	a5,fa2 <dns_rep+0x92>
    char *qn = (char *) (ibuf+len);
     f6c:	009909b3          	add	s3,s2,s1
    qname = qn;
    decode_qname(qn, cc - len);
     f70:	409a85bb          	subw	a1,s5,s1
     f74:	854e                	mv	a0,s3
     f76:	ec7ff0ef          	jal	e3c <decode_qname>
    len += strlen(qn)+1;
     f7a:	854e                	mv	a0,s3
     f7c:	722000ef          	jal	169e <strlen>
    len += sizeof(struct dns_question);
     f80:	2515                	addiw	a0,a0,5
     f82:	9ca9                	addw	s1,s1,a0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     f84:	2a05                	addiw	s4,s4,1
     f86:	00494703          	lbu	a4,4(s2)
     f8a:	00594783          	lbu	a5,5(s2)
     f8e:	07a2                	slli	a5,a5,0x8
     f90:	8fd9                	or	a5,a5,a4
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
     f92:	0087971b          	slliw	a4,a5,0x8
     f96:	83a1                	srli	a5,a5,0x8
     f98:	8fd9                	or	a5,a5,a4
     f9a:	17c2                	slli	a5,a5,0x30
     f9c:	93c1                	srli	a5,a5,0x30
     f9e:	fcfa47e3          	blt	s4,a5,f6c <dns_rep+0x5c>
  }

  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     fa2:	00694703          	lbu	a4,6(s2)
     fa6:	00794783          	lbu	a5,7(s2)
     faa:	07a2                	slli	a5,a5,0x8
     fac:	8fd9                	or	a5,a5,a4
     fae:	26078063          	beqz	a5,120e <dns_rep+0x2fe>
    if(len >= cc){
     fb2:	0d54d463          	bge	s1,s5,107a <dns_rep+0x16a>
     fb6:	e0da                	sd	s6,64(sp)
     fb8:	fc5e                	sd	s7,56(sp)
     fba:	f466                	sd	s9,40(sp)
     fbc:	f06a                	sd	s10,32(sp)
     fbe:	ec6e                	sd	s11,24(sp)
     fc0:	00002797          	auipc	a5,0x2
     fc4:	8a878793          	addi	a5,a5,-1880 # 2868 <malloc+0xa7c>
     fc8:	00098363          	beqz	s3,fce <dns_rep+0xbe>
     fcc:	87ce                	mv	a5,s3
     fce:	f8f43423          	sd	a5,-120(s0)
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     fd2:	4981                	li	s3,0
  int record = 0;
     fd4:	4c01                	li	s8,0
      return 0;
    }
    
    char *qn = (char *) (ibuf+len);

    if((int) qn[0] > 63) {  // compression?
     fd6:	03f00b93          	li	s7,63
    }
      
    struct dns_data *d = (struct dns_data *) (ibuf+len);
    len += sizeof(struct dns_data);
    //printf("type %d ttl %d len %d\n", ntohs(d->type), ntohl(d->ttl), ntohs(d->len));
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
     fda:	10000b13          	li	s6,256
     fde:	40000c93          	li	s9,1024
      record = 1;
      printf("DNS arecord for %s is ", qname ? qname : "" );
      uint8 *ip = (ibuf+len);
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
     fe2:	08000d13          	li	s10,128
     fe6:	03400d93          	li	s11,52
     fea:	a219                	j	10f0 <dns_rep+0x1e0>
    printf("DNS reply too short\n");
     fec:	00001517          	auipc	a0,0x1
     ff0:	4f450513          	addi	a0,a0,1268 # 24e0 <malloc+0x6f4>
     ff4:	545000ef          	jal	1d38 <printf>
    return 0;
     ff8:	4c01                	li	s8,0
     ffa:	a03d                	j	1028 <dns_rep+0x118>
    printf("Not a DNS reply for %d\n", ntohs(hdr->id));
     ffc:	00054703          	lbu	a4,0(a0)
    1000:	00154783          	lbu	a5,1(a0)
    1004:	07a2                	slli	a5,a5,0x8
    1006:	8fd9                	or	a5,a5,a4
    1008:	0087971b          	slliw	a4,a5,0x8
    100c:	83a1                	srli	a5,a5,0x8
    100e:	00e7e5b3          	or	a1,a5,a4
    1012:	15c2                	slli	a1,a1,0x30
    1014:	91c1                	srli	a1,a1,0x30
    1016:	00001517          	auipc	a0,0x1
    101a:	4e250513          	addi	a0,a0,1250 # 24f8 <malloc+0x70c>
    101e:	51b000ef          	jal	1d38 <printf>
    return 0;
    1022:	4c01                	li	s8,0
    1024:	7906                	ld	s2,96(sp)
    1026:	6aa6                	ld	s5,72(sp)
    printf("dns: didn't receive an arecord\n");
    return 0;
  }

  return 1;
}
    1028:	8562                	mv	a0,s8
    102a:	70e6                	ld	ra,120(sp)
    102c:	7446                	ld	s0,112(sp)
    102e:	7c42                	ld	s8,48(sp)
    1030:	6109                	addi	sp,sp,128
    1032:	8082                	ret
    1034:	0086959b          	slliw	a1,a3,0x8
    1038:	0086d69b          	srliw	a3,a3,0x8
    103c:	8dd5                	or	a1,a1,a3
    printf("DNS wrong id: %d\n", ntohs(hdr->id));
    103e:	15c2                	slli	a1,a1,0x30
    1040:	91c1                	srli	a1,a1,0x30
    1042:	00001517          	auipc	a0,0x1
    1046:	4ce50513          	addi	a0,a0,1230 # 2510 <malloc+0x724>
    104a:	4ef000ef          	jal	1d38 <printf>
    return 0;
    104e:	4c01                	li	s8,0
    1050:	7906                	ld	s2,96(sp)
    1052:	6aa6                	ld	s5,72(sp)
    1054:	bfd1                	j	1028 <dns_rep+0x118>
    printf("DNS rcode error: %x\n", hdr->rcode);
    1056:	00354583          	lbu	a1,3(a0)
    105a:	89bd                	andi	a1,a1,15
    105c:	00001517          	auipc	a0,0x1
    1060:	4cc50513          	addi	a0,a0,1228 # 2528 <malloc+0x73c>
    1064:	4d5000ef          	jal	1d38 <printf>
    return 0;
    1068:	4c01                	li	s8,0
    106a:	7906                	ld	s2,96(sp)
    106c:	6aa6                	ld	s5,72(sp)
    106e:	bf6d                	j	1028 <dns_rep+0x118>
    1070:	6b06                	ld	s6,64(sp)
    1072:	7be2                	ld	s7,56(sp)
    1074:	7ca2                	ld	s9,40(sp)
    1076:	7d02                	ld	s10,32(sp)
    1078:	6de2                	ld	s11,24(sp)
      printf("dns: invalid DNS reply\n");
    107a:	00001517          	auipc	a0,0x1
    107e:	4c650513          	addi	a0,a0,1222 # 2540 <malloc+0x754>
    1082:	4b7000ef          	jal	1d38 <printf>
      return 0;
    1086:	4c01                	li	s8,0
    1088:	74a6                	ld	s1,104(sp)
    108a:	7906                	ld	s2,96(sp)
    108c:	69e6                	ld	s3,88(sp)
    108e:	6a46                	ld	s4,80(sp)
    1090:	6aa6                	ld	s5,72(sp)
    1092:	bf59                	j	1028 <dns_rep+0x118>
      decode_qname(qn, cc - len);
    1094:	409a85bb          	subw	a1,s5,s1
    1098:	8552                	mv	a0,s4
    109a:	da3ff0ef          	jal	e3c <decode_qname>
      len += strlen(qn)+1;
    109e:	8552                	mv	a0,s4
    10a0:	5fe000ef          	jal	169e <strlen>
    10a4:	2485                	addiw	s1,s1,1
    10a6:	9ca9                	addw	s1,s1,a0
    10a8:	a899                	j	10fe <dns_rep+0x1ee>
        printf("dns: wrong ip address");
    10aa:	00001517          	auipc	a0,0x1
    10ae:	4d650513          	addi	a0,a0,1238 # 2580 <malloc+0x794>
    10b2:	487000ef          	jal	1d38 <printf>
        return 0;
    10b6:	4c01                	li	s8,0
    10b8:	74a6                	ld	s1,104(sp)
    10ba:	7906                	ld	s2,96(sp)
    10bc:	69e6                	ld	s3,88(sp)
    10be:	6a46                	ld	s4,80(sp)
    10c0:	6aa6                	ld	s5,72(sp)
    10c2:	6b06                	ld	s6,64(sp)
    10c4:	7be2                	ld	s7,56(sp)
    10c6:	7ca2                	ld	s9,40(sp)
    10c8:	7d02                	ld	s10,32(sp)
    10ca:	6de2                	ld	s11,24(sp)
    10cc:	bfb1                	j	1028 <dns_rep+0x118>
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
    10ce:	2985                	addiw	s3,s3,1
    10d0:	00694703          	lbu	a4,6(s2)
    10d4:	00794783          	lbu	a5,7(s2)
    10d8:	07a2                	slli	a5,a5,0x8
    10da:	8fd9                	or	a5,a5,a4
    10dc:	0087971b          	slliw	a4,a5,0x8
    10e0:	83a1                	srli	a5,a5,0x8
    10e2:	8fd9                	or	a5,a5,a4
    10e4:	17c2                	slli	a5,a5,0x30
    10e6:	93c1                	srli	a5,a5,0x30
    10e8:	08f9df63          	bge	s3,a5,1186 <dns_rep+0x276>
    if(len >= cc){
    10ec:	f954d2e3          	bge	s1,s5,1070 <dns_rep+0x160>
    char *qn = (char *) (ibuf+len);
    10f0:	00990a33          	add	s4,s2,s1
    if((int) qn[0] > 63) {  // compression?
    10f4:	000a4783          	lbu	a5,0(s4)
    10f8:	f8fbfee3          	bgeu	s7,a5,1094 <dns_rep+0x184>
      len += 2;
    10fc:	2489                	addiw	s1,s1,2
    struct dns_data *d = (struct dns_data *) (ibuf+len);
    10fe:	00990733          	add	a4,s2,s1
    len += sizeof(struct dns_data);
    1102:	00048a1b          	sext.w	s4,s1
    1106:	24a9                	addiw	s1,s1,10
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
    1108:	00074683          	lbu	a3,0(a4)
    110c:	00174783          	lbu	a5,1(a4)
    1110:	07a2                	slli	a5,a5,0x8
    1112:	8fd5                	or	a5,a5,a3
    1114:	fb679de3          	bne	a5,s6,10ce <dns_rep+0x1be>
    1118:	00874683          	lbu	a3,8(a4)
    111c:	00974783          	lbu	a5,9(a4)
    1120:	07a2                	slli	a5,a5,0x8
    1122:	8fd5                	or	a5,a5,a3
    1124:	fb9795e3          	bne	a5,s9,10ce <dns_rep+0x1be>
      printf("DNS arecord for %s is ", qname ? qname : "" );
    1128:	f8843583          	ld	a1,-120(s0)
    112c:	00001517          	auipc	a0,0x1
    1130:	42c50513          	addi	a0,a0,1068 # 2558 <malloc+0x76c>
    1134:	405000ef          	jal	1d38 <printf>
      uint8 *ip = (ibuf+len);
    1138:	94ca                	add	s1,s1,s2
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
    113a:	0034c703          	lbu	a4,3(s1)
    113e:	0024c683          	lbu	a3,2(s1)
    1142:	0014c603          	lbu	a2,1(s1)
    1146:	0004c583          	lbu	a1,0(s1)
    114a:	00001517          	auipc	a0,0x1
    114e:	42650513          	addi	a0,a0,1062 # 2570 <malloc+0x784>
    1152:	3e7000ef          	jal	1d38 <printf>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
    1156:	0004c783          	lbu	a5,0(s1)
    115a:	f5a798e3          	bne	a5,s10,10aa <dns_rep+0x19a>
    115e:	0014c783          	lbu	a5,1(s1)
    1162:	f5b794e3          	bne	a5,s11,10aa <dns_rep+0x19a>
    1166:	0024c783          	lbu	a5,2(s1)
    116a:	08100713          	li	a4,129
    116e:	f2e79ee3          	bne	a5,a4,10aa <dns_rep+0x19a>
    1172:	0034c703          	lbu	a4,3(s1)
    1176:	07e00793          	li	a5,126
    117a:	f2f718e3          	bne	a4,a5,10aa <dns_rep+0x19a>
      len += 4;
    117e:	00ea049b          	addiw	s1,s4,14
      record = 1;
    1182:	4c05                	li	s8,1
    1184:	b7a9                	j	10ce <dns_rep+0x1be>
    1186:	6b06                	ld	s6,64(sp)
    1188:	7be2                	ld	s7,56(sp)
    118a:	7ca2                	ld	s9,40(sp)
    118c:	7d02                	ld	s10,32(sp)
    118e:	6de2                	ld	s11,24(sp)
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
    1190:	00a94703          	lbu	a4,10(s2)
    1194:	00b94783          	lbu	a5,11(s2)
    1198:	07a2                	slli	a5,a5,0x8
    119a:	8fd9                	or	a5,a5,a4
    119c:	0087959b          	slliw	a1,a5,0x8
    11a0:	0087d71b          	srliw	a4,a5,0x8
    11a4:	8dd9                	or	a1,a1,a4
    11a6:	15c2                	slli	a1,a1,0x30
    11a8:	91c1                	srli	a1,a1,0x30
    11aa:	cba1                	beqz	a5,11fa <dns_rep+0x2ea>
    11ac:	4681                	li	a3,0
    if(ntohs(d->type) != 41) {
    11ae:	650d                	lui	a0,0x3
    11b0:	90050513          	addi	a0,a0,-1792 # 2900 <digits+0x70>
    if(*qn != 0) {
    11b4:	009907b3          	add	a5,s2,s1
    11b8:	0007c783          	lbu	a5,0(a5)
    11bc:	ebb9                	bnez	a5,1212 <dns_rep+0x302>
    struct dns_data *d = (struct dns_data *) (ibuf+len);
    11be:	0014879b          	addiw	a5,s1,1
    11c2:	97ca                	add	a5,a5,s2
    len += sizeof(struct dns_data);
    11c4:	24ad                	addiw	s1,s1,11
    if(ntohs(d->type) != 41) {
    11c6:	0007c603          	lbu	a2,0(a5)
    11ca:	0017c703          	lbu	a4,1(a5)
    11ce:	0722                	slli	a4,a4,0x8
    11d0:	8f51                	or	a4,a4,a2
    11d2:	04a71d63          	bne	a4,a0,122c <dns_rep+0x31c>
    len += ntohs(d->len);
    11d6:	0087c703          	lbu	a4,8(a5)
    11da:	0097c783          	lbu	a5,9(a5)
    11de:	07a2                	slli	a5,a5,0x8
    11e0:	8fd9                	or	a5,a5,a4
    11e2:	0087971b          	slliw	a4,a5,0x8
    11e6:	83a1                	srli	a5,a5,0x8
    11e8:	8fd9                	or	a5,a5,a4
    11ea:	0107979b          	slliw	a5,a5,0x10
    11ee:	0107d79b          	srliw	a5,a5,0x10
    11f2:	9cbd                	addw	s1,s1,a5
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
    11f4:	2685                	addiw	a3,a3,1
    11f6:	fab6cfe3          	blt	a3,a1,11b4 <dns_rep+0x2a4>
  if(len != cc) {
    11fa:	049a9663          	bne	s5,s1,1246 <dns_rep+0x336>
  if(!record) {
    11fe:	060c0363          	beqz	s8,1264 <dns_rep+0x354>
    1202:	74a6                	ld	s1,104(sp)
    1204:	7906                	ld	s2,96(sp)
    1206:	69e6                	ld	s3,88(sp)
    1208:	6a46                	ld	s4,80(sp)
    120a:	6aa6                	ld	s5,72(sp)
    120c:	bd31                	j	1028 <dns_rep+0x118>
  int record = 0;
    120e:	4c01                	li	s8,0
    1210:	b741                	j	1190 <dns_rep+0x280>
      printf("dns: invalid name for EDNS\n");
    1212:	00001517          	auipc	a0,0x1
    1216:	38650513          	addi	a0,a0,902 # 2598 <malloc+0x7ac>
    121a:	31f000ef          	jal	1d38 <printf>
      return 0;
    121e:	4c01                	li	s8,0
    1220:	74a6                	ld	s1,104(sp)
    1222:	7906                	ld	s2,96(sp)
    1224:	69e6                	ld	s3,88(sp)
    1226:	6a46                	ld	s4,80(sp)
    1228:	6aa6                	ld	s5,72(sp)
    122a:	bbfd                	j	1028 <dns_rep+0x118>
      printf("dns: invalid type for EDNS\n");
    122c:	00001517          	auipc	a0,0x1
    1230:	38c50513          	addi	a0,a0,908 # 25b8 <malloc+0x7cc>
    1234:	305000ef          	jal	1d38 <printf>
      return 0;
    1238:	4c01                	li	s8,0
    123a:	74a6                	ld	s1,104(sp)
    123c:	7906                	ld	s2,96(sp)
    123e:	69e6                	ld	s3,88(sp)
    1240:	6a46                	ld	s4,80(sp)
    1242:	6aa6                	ld	s5,72(sp)
    1244:	b3d5                	j	1028 <dns_rep+0x118>
    printf("dns: processed %d data bytes but received %d\n", len, cc);
    1246:	8656                	mv	a2,s5
    1248:	85a6                	mv	a1,s1
    124a:	00001517          	auipc	a0,0x1
    124e:	38e50513          	addi	a0,a0,910 # 25d8 <malloc+0x7ec>
    1252:	2e7000ef          	jal	1d38 <printf>
    return 0;
    1256:	4c01                	li	s8,0
    1258:	74a6                	ld	s1,104(sp)
    125a:	7906                	ld	s2,96(sp)
    125c:	69e6                	ld	s3,88(sp)
    125e:	6a46                	ld	s4,80(sp)
    1260:	6aa6                	ld	s5,72(sp)
    1262:	b3d9                	j	1028 <dns_rep+0x118>
    printf("dns: didn't receive an arecord\n");
    1264:	00001517          	auipc	a0,0x1
    1268:	3a450513          	addi	a0,a0,932 # 2608 <malloc+0x81c>
    126c:	2cd000ef          	jal	1d38 <printf>
    1270:	74a6                	ld	s1,104(sp)
    1272:	7906                	ld	s2,96(sp)
    1274:	69e6                	ld	s3,88(sp)
    1276:	6a46                	ld	s4,80(sp)
    1278:	6aa6                	ld	s5,72(sp)
    return 0;
    127a:	b37d                	j	1028 <dns_rep+0x118>

000000000000127c <dns>:

int
dns()
{
    127c:	1101                	addi	sp,sp,-32
    127e:	ec06                	sd	ra,24(sp)
    1280:	e822                	sd	s0,16(sp)
    1282:	e426                	sd	s1,8(sp)
    1284:	1000                	addi	s0,sp,32
    1286:	82010113          	addi	sp,sp,-2016
  uint8 obuf[N];
  uint8 ibuf[N];
  uint32 dst;
  int len;

  printf("dns: starting\n");
    128a:	00001517          	auipc	a0,0x1
    128e:	39e50513          	addi	a0,a0,926 # 2628 <malloc+0x83c>
    1292:	2a7000ef          	jal	1d38 <printf>

  memset(obuf, 0, N);
    1296:	3e800613          	li	a2,1000
    129a:	4581                	li	a1,0
    129c:	bf840513          	addi	a0,s0,-1032
    12a0:	428000ef          	jal	16c8 <memset>
  memset(ibuf, 0, N);
    12a4:	3e800613          	li	a2,1000
    12a8:	4581                	li	a1,0
    12aa:	81040513          	addi	a0,s0,-2032
    12ae:	41a000ef          	jal	16c8 <memset>
  
  // 8.8.8.8: google's name server
  dst = (8 << 24) | (8 << 16) | (8 << 8) | (8 << 0);

  len = dns_req(obuf);
    12b2:	bf840513          	addi	a0,s0,-1032
    12b6:	bd9ff0ef          	jal	e8e <dns_req>
    12ba:	84aa                	mv	s1,a0
  
  bind(10000);
    12bc:	6509                	lui	a0,0x2
    12be:	71050513          	addi	a0,a0,1808 # 2710 <malloc+0x924>
    12c2:	6b8000ef          	jal	197a <bind>
  
  if(send(10000, dst, 53, (char*)obuf, len) < 0){
    12c6:	0004871b          	sext.w	a4,s1
    12ca:	bf840693          	addi	a3,s0,-1032
    12ce:	03500613          	li	a2,53
    12d2:	080815b7          	lui	a1,0x8081
    12d6:	80858593          	addi	a1,a1,-2040 # 8080808 <base+0x807c5f8>
    12da:	6509                	lui	a0,0x2
    12dc:	71050513          	addi	a0,a0,1808 # 2710 <malloc+0x924>
    12e0:	6aa000ef          	jal	198a <send>
    12e4:	02054e63          	bltz	a0,1320 <dns+0xa4>
    return 0;
  }

  uint32 src;
  uint16 sport;
  int cc = recv(10000, &src, &sport, (char*)ibuf, sizeof(ibuf));
    12e8:	3e800713          	li	a4,1000
    12ec:	81040693          	addi	a3,s0,-2032
    12f0:	80a40613          	addi	a2,s0,-2038
    12f4:	80c40593          	addi	a1,s0,-2036
    12f8:	6509                	lui	a0,0x2
    12fa:	71050513          	addi	a0,a0,1808 # 2710 <malloc+0x924>
    12fe:	694000ef          	jal	1992 <recv>
    1302:	85aa                	mv	a1,a0
  if(cc < 0){
    1304:	02054763          	bltz	a0,1332 <dns+0xb6>
    fprintf(2, "dns: recv() failed\n");
    return 0;
  }

  if(dns_rep(ibuf, cc)){
    1308:	81040513          	addi	a0,s0,-2032
    130c:	c05ff0ef          	jal	f10 <dns_rep>
    1310:	e915                	bnez	a0,1344 <dns+0xc8>
    printf("dns: OK\n");
    return 1;
  } else {
    return 0;
  }
}  
    1312:	7e010113          	addi	sp,sp,2016
    1316:	60e2                	ld	ra,24(sp)
    1318:	6442                	ld	s0,16(sp)
    131a:	64a2                	ld	s1,8(sp)
    131c:	6105                	addi	sp,sp,32
    131e:	8082                	ret
    fprintf(2, "dns: send() failed\n");
    1320:	00001597          	auipc	a1,0x1
    1324:	31858593          	addi	a1,a1,792 # 2638 <malloc+0x84c>
    1328:	4509                	li	a0,2
    132a:	1e5000ef          	jal	1d0e <fprintf>
    return 0;
    132e:	4501                	li	a0,0
    1330:	b7cd                	j	1312 <dns+0x96>
    fprintf(2, "dns: recv() failed\n");
    1332:	00001597          	auipc	a1,0x1
    1336:	31e58593          	addi	a1,a1,798 # 2650 <malloc+0x864>
    133a:	4509                	li	a0,2
    133c:	1d3000ef          	jal	1d0e <fprintf>
    return 0;
    1340:	4501                	li	a0,0
    1342:	bfc1                	j	1312 <dns+0x96>
    printf("dns: OK\n");
    1344:	00001517          	auipc	a0,0x1
    1348:	32450513          	addi	a0,a0,804 # 2668 <malloc+0x87c>
    134c:	1ed000ef          	jal	1d38 <printf>
    return 1;
    1350:	4505                	li	a0,1
    1352:	b7c1                	j	1312 <dns+0x96>

0000000000001354 <usage>:

void
usage()
{
    1354:	1141                	addi	sp,sp,-16
    1356:	e406                	sd	ra,8(sp)
    1358:	e022                	sd	s0,0(sp)
    135a:	0800                	addi	s0,sp,16
  printf("Usage: nettest txone\n");
    135c:	00001517          	auipc	a0,0x1
    1360:	31c50513          	addi	a0,a0,796 # 2678 <malloc+0x88c>
    1364:	1d5000ef          	jal	1d38 <printf>
  printf("       nettest tx\n");
    1368:	00001517          	auipc	a0,0x1
    136c:	32850513          	addi	a0,a0,808 # 2690 <malloc+0x8a4>
    1370:	1c9000ef          	jal	1d38 <printf>
  printf("       nettest rx\n");
    1374:	00001517          	auipc	a0,0x1
    1378:	33450513          	addi	a0,a0,820 # 26a8 <malloc+0x8bc>
    137c:	1bd000ef          	jal	1d38 <printf>
  printf("       nettest rx2\n");
    1380:	00001517          	auipc	a0,0x1
    1384:	34050513          	addi	a0,a0,832 # 26c0 <malloc+0x8d4>
    1388:	1b1000ef          	jal	1d38 <printf>
  printf("       nettest rxburst\n");
    138c:	00001517          	auipc	a0,0x1
    1390:	34c50513          	addi	a0,a0,844 # 26d8 <malloc+0x8ec>
    1394:	1a5000ef          	jal	1d38 <printf>
  printf("       nettest ping1\n");
    1398:	00001517          	auipc	a0,0x1
    139c:	35850513          	addi	a0,a0,856 # 26f0 <malloc+0x904>
    13a0:	199000ef          	jal	1d38 <printf>
  printf("       nettest ping2\n");
    13a4:	00001517          	auipc	a0,0x1
    13a8:	36450513          	addi	a0,a0,868 # 2708 <malloc+0x91c>
    13ac:	18d000ef          	jal	1d38 <printf>
  printf("       nettest ping3\n");
    13b0:	00001517          	auipc	a0,0x1
    13b4:	37050513          	addi	a0,a0,880 # 2720 <malloc+0x934>
    13b8:	181000ef          	jal	1d38 <printf>
  printf("       nettest dns\n");
    13bc:	00001517          	auipc	a0,0x1
    13c0:	37c50513          	addi	a0,a0,892 # 2738 <malloc+0x94c>
    13c4:	175000ef          	jal	1d38 <printf>
  printf("       nettest grade\n");
    13c8:	00001517          	auipc	a0,0x1
    13cc:	38850513          	addi	a0,a0,904 # 2750 <malloc+0x964>
    13d0:	169000ef          	jal	1d38 <printf>
  exit(1);
    13d4:	4505                	li	a0,1
    13d6:	504000ef          	jal	18da <exit>

00000000000013da <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    13da:	7139                	addi	sp,sp,-64
    13dc:	fc06                	sd	ra,56(sp)
    13de:	f822                	sd	s0,48(sp)
    13e0:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    13e2:	fc840513          	addi	a0,s0,-56
    13e6:	504000ef          	jal	18ea <pipe>
    13ea:	04054e63          	bltz	a0,1446 <countfree+0x6c>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    13ee:	4e4000ef          	jal	18d2 <fork>

  if(pid < 0){
    13f2:	06054663          	bltz	a0,145e <countfree+0x84>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    13f6:	e159                	bnez	a0,147c <countfree+0xa2>
    13f8:	f426                	sd	s1,40(sp)
    13fa:	f04a                	sd	s2,32(sp)
    13fc:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    13fe:	fc842503          	lw	a0,-56(s0)
    1402:	500000ef          	jal	1902 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    1406:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    1408:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    140a:	00001997          	auipc	s3,0x1
    140e:	05698993          	addi	s3,s3,86 # 2460 <malloc+0x674>
      uint64 a = (uint64) sbrk(4096);
    1412:	6505                	lui	a0,0x1
    1414:	492000ef          	jal	18a6 <sbrk>
      if(a == 0xffffffffffffffff){
    1418:	05250f63          	beq	a0,s2,1476 <countfree+0x9c>
      *(char *)(a + 4096 - 1) = 1;
    141c:	6785                	lui	a5,0x1
    141e:	97aa                	add	a5,a5,a0
    1420:	fe978fa3          	sb	s1,-1(a5) # fff <dns_rep+0xef>
      if(write(fds[1], "x", 1) != 1){
    1424:	8626                	mv	a2,s1
    1426:	85ce                	mv	a1,s3
    1428:	fcc42503          	lw	a0,-52(s0)
    142c:	4ce000ef          	jal	18fa <write>
    1430:	fe9501e3          	beq	a0,s1,1412 <countfree+0x38>
        printf("write() failed in countfree()\n");
    1434:	00001517          	auipc	a0,0x1
    1438:	37450513          	addi	a0,a0,884 # 27a8 <malloc+0x9bc>
    143c:	0fd000ef          	jal	1d38 <printf>
        exit(1);
    1440:	4505                	li	a0,1
    1442:	498000ef          	jal	18da <exit>
    1446:	f426                	sd	s1,40(sp)
    1448:	f04a                	sd	s2,32(sp)
    144a:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    144c:	00001517          	auipc	a0,0x1
    1450:	31c50513          	addi	a0,a0,796 # 2768 <malloc+0x97c>
    1454:	0e5000ef          	jal	1d38 <printf>
    exit(1);
    1458:	4505                	li	a0,1
    145a:	480000ef          	jal	18da <exit>
    145e:	f426                	sd	s1,40(sp)
    1460:	f04a                	sd	s2,32(sp)
    1462:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    1464:	00001517          	auipc	a0,0x1
    1468:	32450513          	addi	a0,a0,804 # 2788 <malloc+0x99c>
    146c:	0cd000ef          	jal	1d38 <printf>
    exit(1);
    1470:	4505                	li	a0,1
    1472:	468000ef          	jal	18da <exit>
      }
    }

    exit(0);
    1476:	4501                	li	a0,0
    1478:	462000ef          	jal	18da <exit>
    147c:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    147e:	fcc42503          	lw	a0,-52(s0)
    1482:	480000ef          	jal	1902 <close>

  int n = 0;
    1486:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    1488:	4605                	li	a2,1
    148a:	fc740593          	addi	a1,s0,-57
    148e:	fc842503          	lw	a0,-56(s0)
    1492:	460000ef          	jal	18f2 <read>
    if(cc < 0){
    1496:	00054563          	bltz	a0,14a0 <countfree+0xc6>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    149a:	cd11                	beqz	a0,14b6 <countfree+0xdc>
      break;
    n += 1;
    149c:	2485                	addiw	s1,s1,1
  while(1){
    149e:	b7ed                	j	1488 <countfree+0xae>
    14a0:	f04a                	sd	s2,32(sp)
    14a2:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    14a4:	00001517          	auipc	a0,0x1
    14a8:	32450513          	addi	a0,a0,804 # 27c8 <malloc+0x9dc>
    14ac:	08d000ef          	jal	1d38 <printf>
      exit(1);
    14b0:	4505                	li	a0,1
    14b2:	428000ef          	jal	18da <exit>
  }

  close(fds[0]);
    14b6:	fc842503          	lw	a0,-56(s0)
    14ba:	448000ef          	jal	1902 <close>
  wait((int*)0);
    14be:	4501                	li	a0,0
    14c0:	422000ef          	jal	18e2 <wait>
  
  return n;
}
    14c4:	8526                	mv	a0,s1
    14c6:	74a2                	ld	s1,40(sp)
    14c8:	70e2                	ld	ra,56(sp)
    14ca:	7442                	ld	s0,48(sp)
    14cc:	6121                	addi	sp,sp,64
    14ce:	8082                	ret

00000000000014d0 <main>:

int
main(int argc, char *argv[])
{
    14d0:	1101                	addi	sp,sp,-32
    14d2:	ec06                	sd	ra,24(sp)
    14d4:	e822                	sd	s0,16(sp)
    14d6:	1000                	addi	s0,sp,32
  if(argc != 2)
    14d8:	4789                	li	a5,2
    14da:	00f50563          	beq	a0,a5,14e4 <main+0x14>
    14de:	e426                	sd	s1,8(sp)
    usage();
    14e0:	e75ff0ef          	jal	1354 <usage>
    14e4:	e426                	sd	s1,8(sp)
    14e6:	84ae                	mv	s1,a1

  if(strcmp(argv[1], "txone") == 0){
    14e8:	00001597          	auipc	a1,0x1
    14ec:	30058593          	addi	a1,a1,768 # 27e8 <malloc+0x9fc>
    14f0:	6488                	ld	a0,8(s1)
    14f2:	180000ef          	jal	1672 <strcmp>
    14f6:	e511                	bnez	a0,1502 <main+0x32>
    txone();
    14f8:	b09fe0ef          	jal	0 <txone>
    dns();
  } else {
    usage();
  }

  exit(0);
    14fc:	4501                	li	a0,0
    14fe:	3dc000ef          	jal	18da <exit>
  } else if(strcmp(argv[1], "rx") == 0 || strcmp(argv[1], "rxburst") == 0){
    1502:	00001597          	auipc	a1,0x1
    1506:	2ee58593          	addi	a1,a1,750 # 27f0 <malloc+0xa04>
    150a:	6488                	ld	a0,8(s1)
    150c:	166000ef          	jal	1672 <strcmp>
    1510:	c909                	beqz	a0,1522 <main+0x52>
    1512:	00001597          	auipc	a1,0x1
    1516:	2e658593          	addi	a1,a1,742 # 27f8 <malloc+0xa0c>
    151a:	6488                	ld	a0,8(s1)
    151c:	156000ef          	jal	1672 <strcmp>
    1520:	e509                	bnez	a0,152a <main+0x5a>
    rx(argv[1]);
    1522:	6488                	ld	a0,8(s1)
    1524:	b4ffe0ef          	jal	72 <rx>
    1528:	bfd1                	j	14fc <main+0x2c>
  } else if(strcmp(argv[1], "rx2") == 0){
    152a:	00001597          	auipc	a1,0x1
    152e:	2d658593          	addi	a1,a1,726 # 2800 <malloc+0xa14>
    1532:	6488                	ld	a0,8(s1)
    1534:	13e000ef          	jal	1672 <strcmp>
    1538:	e501                	bnez	a0,1540 <main+0x70>
    rx2();
    153a:	d35fe0ef          	jal	26e <rx2>
    153e:	bf7d                	j	14fc <main+0x2c>
  } else if(strcmp(argv[1], "tx") == 0){
    1540:	00001597          	auipc	a1,0x1
    1544:	2c858593          	addi	a1,a1,712 # 2808 <malloc+0xa1c>
    1548:	6488                	ld	a0,8(s1)
    154a:	128000ef          	jal	1672 <strcmp>
    154e:	e501                	bnez	a0,1556 <main+0x86>
    tx();
    1550:	fedfe0ef          	jal	53c <tx>
    1554:	b765                	j	14fc <main+0x2c>
  } else if(strcmp(argv[1], "ping0") == 0){
    1556:	00001597          	auipc	a1,0x1
    155a:	bca58593          	addi	a1,a1,-1078 # 2120 <malloc+0x334>
    155e:	6488                	ld	a0,8(s1)
    1560:	112000ef          	jal	1672 <strcmp>
    1564:	e501                	bnez	a0,156c <main+0x9c>
    ping0();
    1566:	860ff0ef          	jal	5c6 <ping0>
    156a:	bf49                	j	14fc <main+0x2c>
  } else if(strcmp(argv[1], "ping1") == 0){
    156c:	00001597          	auipc	a1,0x1
    1570:	2a458593          	addi	a1,a1,676 # 2810 <malloc+0xa24>
    1574:	6488                	ld	a0,8(s1)
    1576:	0fc000ef          	jal	1672 <strcmp>
    157a:	e501                	bnez	a0,1582 <main+0xb2>
    ping1();
    157c:	998ff0ef          	jal	714 <ping1>
    1580:	bfb5                	j	14fc <main+0x2c>
  } else if(strcmp(argv[1], "ping2") == 0){
    1582:	00001597          	auipc	a1,0x1
    1586:	29658593          	addi	a1,a1,662 # 2818 <malloc+0xa2c>
    158a:	6488                	ld	a0,8(s1)
    158c:	0e6000ef          	jal	1672 <strcmp>
    1590:	e501                	bnez	a0,1598 <main+0xc8>
    ping2();
    1592:	adcff0ef          	jal	86e <ping2>
    1596:	b79d                	j	14fc <main+0x2c>
  } else if(strcmp(argv[1], "ping3") == 0){
    1598:	00001597          	auipc	a1,0x1
    159c:	28858593          	addi	a1,a1,648 # 2820 <malloc+0xa34>
    15a0:	6488                	ld	a0,8(s1)
    15a2:	0d0000ef          	jal	1672 <strcmp>
    15a6:	e501                	bnez	a0,15ae <main+0xde>
    ping3();
    15a8:	caeff0ef          	jal	a56 <ping3>
    15ac:	bf81                	j	14fc <main+0x2c>
  } else if(strcmp(argv[1], "grade") == 0){
    15ae:	00001597          	auipc	a1,0x1
    15b2:	27a58593          	addi	a1,a1,634 # 2828 <malloc+0xa3c>
    15b6:	6488                	ld	a0,8(s1)
    15b8:	0ba000ef          	jal	1672 <strcmp>
    15bc:	e925                	bnez	a0,162c <main+0x15c>
    int free0 = countfree();
    15be:	e1dff0ef          	jal	13da <countfree>
    15c2:	84aa                	mv	s1,a0
    txone();
    15c4:	a3dfe0ef          	jal	0 <txone>
    pause(2);
    15c8:	4509                	li	a0,2
    15ca:	3a0000ef          	jal	196a <pause>
    ping0();
    15ce:	ff9fe0ef          	jal	5c6 <ping0>
    pause(2);
    15d2:	4509                	li	a0,2
    15d4:	396000ef          	jal	196a <pause>
    ping1();
    15d8:	93cff0ef          	jal	714 <ping1>
    pause(2);
    15dc:	4509                	li	a0,2
    15de:	38c000ef          	jal	196a <pause>
    ping2();
    15e2:	a8cff0ef          	jal	86e <ping2>
    pause(2);
    15e6:	4509                	li	a0,2
    15e8:	382000ef          	jal	196a <pause>
    ping3();
    15ec:	c6aff0ef          	jal	a56 <ping3>
    pause(2);
    15f0:	4509                	li	a0,2
    15f2:	378000ef          	jal	196a <pause>
    dns();
    15f6:	c87ff0ef          	jal	127c <dns>
    pause(2);
    15fa:	4509                	li	a0,2
    15fc:	36e000ef          	jal	196a <pause>
    if ((free1 = countfree()) + 32 < free0) {
    1600:	ddbff0ef          	jal	13da <countfree>
    1604:	85aa                	mv	a1,a0
    1606:	0205079b          	addiw	a5,a0,32
    160a:	0097da63          	bge	a5,s1,161e <main+0x14e>
      printf("free: FAILED -- lost too many free pages %d (out of %d)\n", free1, free0);
    160e:	8626                	mv	a2,s1
    1610:	00001517          	auipc	a0,0x1
    1614:	22050513          	addi	a0,a0,544 # 2830 <malloc+0xa44>
    1618:	720000ef          	jal	1d38 <printf>
    161c:	b5c5                	j	14fc <main+0x2c>
      printf("free: OK\n");
    161e:	00001517          	auipc	a0,0x1
    1622:	25250513          	addi	a0,a0,594 # 2870 <malloc+0xa84>
    1626:	712000ef          	jal	1d38 <printf>
    162a:	bdc9                	j	14fc <main+0x2c>
  } else if(strcmp(argv[1], "dns") == 0){
    162c:	00001597          	auipc	a1,0x1
    1630:	25458593          	addi	a1,a1,596 # 2880 <malloc+0xa94>
    1634:	6488                	ld	a0,8(s1)
    1636:	03c000ef          	jal	1672 <strcmp>
    163a:	e501                	bnez	a0,1642 <main+0x172>
    dns();
    163c:	c41ff0ef          	jal	127c <dns>
    1640:	bd75                	j	14fc <main+0x2c>
    usage();
    1642:	d13ff0ef          	jal	1354 <usage>

0000000000001646 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    1646:	1141                	addi	sp,sp,-16
    1648:	e406                	sd	ra,8(sp)
    164a:	e022                	sd	s0,0(sp)
    164c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    164e:	e83ff0ef          	jal	14d0 <main>
  exit(r);
    1652:	288000ef          	jal	18da <exit>

0000000000001656 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    1656:	1141                	addi	sp,sp,-16
    1658:	e422                	sd	s0,8(sp)
    165a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    165c:	87aa                	mv	a5,a0
    165e:	0585                	addi	a1,a1,1
    1660:	0785                	addi	a5,a5,1
    1662:	fff5c703          	lbu	a4,-1(a1)
    1666:	fee78fa3          	sb	a4,-1(a5)
    166a:	fb75                	bnez	a4,165e <strcpy+0x8>
    ;
  return os;
}
    166c:	6422                	ld	s0,8(sp)
    166e:	0141                	addi	sp,sp,16
    1670:	8082                	ret

0000000000001672 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1672:	1141                	addi	sp,sp,-16
    1674:	e422                	sd	s0,8(sp)
    1676:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    1678:	00054783          	lbu	a5,0(a0)
    167c:	cb91                	beqz	a5,1690 <strcmp+0x1e>
    167e:	0005c703          	lbu	a4,0(a1)
    1682:	00f71763          	bne	a4,a5,1690 <strcmp+0x1e>
    p++, q++;
    1686:	0505                	addi	a0,a0,1
    1688:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    168a:	00054783          	lbu	a5,0(a0)
    168e:	fbe5                	bnez	a5,167e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    1690:	0005c503          	lbu	a0,0(a1)
}
    1694:	40a7853b          	subw	a0,a5,a0
    1698:	6422                	ld	s0,8(sp)
    169a:	0141                	addi	sp,sp,16
    169c:	8082                	ret

000000000000169e <strlen>:

uint
strlen(const char *s)
{
    169e:	1141                	addi	sp,sp,-16
    16a0:	e422                	sd	s0,8(sp)
    16a2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    16a4:	00054783          	lbu	a5,0(a0)
    16a8:	cf91                	beqz	a5,16c4 <strlen+0x26>
    16aa:	0505                	addi	a0,a0,1
    16ac:	87aa                	mv	a5,a0
    16ae:	86be                	mv	a3,a5
    16b0:	0785                	addi	a5,a5,1
    16b2:	fff7c703          	lbu	a4,-1(a5)
    16b6:	ff65                	bnez	a4,16ae <strlen+0x10>
    16b8:	40a6853b          	subw	a0,a3,a0
    16bc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    16be:	6422                	ld	s0,8(sp)
    16c0:	0141                	addi	sp,sp,16
    16c2:	8082                	ret
  for(n = 0; s[n]; n++)
    16c4:	4501                	li	a0,0
    16c6:	bfe5                	j	16be <strlen+0x20>

00000000000016c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    16c8:	1141                	addi	sp,sp,-16
    16ca:	e422                	sd	s0,8(sp)
    16cc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    16ce:	ca19                	beqz	a2,16e4 <memset+0x1c>
    16d0:	87aa                	mv	a5,a0
    16d2:	1602                	slli	a2,a2,0x20
    16d4:	9201                	srli	a2,a2,0x20
    16d6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    16da:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    16de:	0785                	addi	a5,a5,1
    16e0:	fee79de3          	bne	a5,a4,16da <memset+0x12>
  }
  return dst;
}
    16e4:	6422                	ld	s0,8(sp)
    16e6:	0141                	addi	sp,sp,16
    16e8:	8082                	ret

00000000000016ea <strchr>:

char*
strchr(const char *s, char c)
{
    16ea:	1141                	addi	sp,sp,-16
    16ec:	e422                	sd	s0,8(sp)
    16ee:	0800                	addi	s0,sp,16
  for(; *s; s++)
    16f0:	00054783          	lbu	a5,0(a0)
    16f4:	cb99                	beqz	a5,170a <strchr+0x20>
    if(*s == c)
    16f6:	00f58763          	beq	a1,a5,1704 <strchr+0x1a>
  for(; *s; s++)
    16fa:	0505                	addi	a0,a0,1
    16fc:	00054783          	lbu	a5,0(a0)
    1700:	fbfd                	bnez	a5,16f6 <strchr+0xc>
      return (char*)s;
  return 0;
    1702:	4501                	li	a0,0
}
    1704:	6422                	ld	s0,8(sp)
    1706:	0141                	addi	sp,sp,16
    1708:	8082                	ret
  return 0;
    170a:	4501                	li	a0,0
    170c:	bfe5                	j	1704 <strchr+0x1a>

000000000000170e <gets>:

char*
gets(char *buf, int max)
{
    170e:	711d                	addi	sp,sp,-96
    1710:	ec86                	sd	ra,88(sp)
    1712:	e8a2                	sd	s0,80(sp)
    1714:	e4a6                	sd	s1,72(sp)
    1716:	e0ca                	sd	s2,64(sp)
    1718:	fc4e                	sd	s3,56(sp)
    171a:	f852                	sd	s4,48(sp)
    171c:	f456                	sd	s5,40(sp)
    171e:	f05a                	sd	s6,32(sp)
    1720:	ec5e                	sd	s7,24(sp)
    1722:	1080                	addi	s0,sp,96
    1724:	8baa                	mv	s7,a0
    1726:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1728:	892a                	mv	s2,a0
    172a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    172c:	4aa9                	li	s5,10
    172e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1730:	89a6                	mv	s3,s1
    1732:	2485                	addiw	s1,s1,1
    1734:	0344d663          	bge	s1,s4,1760 <gets+0x52>
    cc = read(0, &c, 1);
    1738:	4605                	li	a2,1
    173a:	faf40593          	addi	a1,s0,-81
    173e:	4501                	li	a0,0
    1740:	1b2000ef          	jal	18f2 <read>
    if(cc < 1)
    1744:	00a05e63          	blez	a0,1760 <gets+0x52>
    buf[i++] = c;
    1748:	faf44783          	lbu	a5,-81(s0)
    174c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1750:	01578763          	beq	a5,s5,175e <gets+0x50>
    1754:	0905                	addi	s2,s2,1
    1756:	fd679de3          	bne	a5,s6,1730 <gets+0x22>
    buf[i++] = c;
    175a:	89a6                	mv	s3,s1
    175c:	a011                	j	1760 <gets+0x52>
    175e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1760:	99de                	add	s3,s3,s7
    1762:	00098023          	sb	zero,0(s3)
  return buf;
}
    1766:	855e                	mv	a0,s7
    1768:	60e6                	ld	ra,88(sp)
    176a:	6446                	ld	s0,80(sp)
    176c:	64a6                	ld	s1,72(sp)
    176e:	6906                	ld	s2,64(sp)
    1770:	79e2                	ld	s3,56(sp)
    1772:	7a42                	ld	s4,48(sp)
    1774:	7aa2                	ld	s5,40(sp)
    1776:	7b02                	ld	s6,32(sp)
    1778:	6be2                	ld	s7,24(sp)
    177a:	6125                	addi	sp,sp,96
    177c:	8082                	ret

000000000000177e <stat>:

int
stat(const char *n, struct stat *st)
{
    177e:	1101                	addi	sp,sp,-32
    1780:	ec06                	sd	ra,24(sp)
    1782:	e822                	sd	s0,16(sp)
    1784:	e04a                	sd	s2,0(sp)
    1786:	1000                	addi	s0,sp,32
    1788:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    178a:	4581                	li	a1,0
    178c:	18e000ef          	jal	191a <open>
  if(fd < 0)
    1790:	02054263          	bltz	a0,17b4 <stat+0x36>
    1794:	e426                	sd	s1,8(sp)
    1796:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1798:	85ca                	mv	a1,s2
    179a:	198000ef          	jal	1932 <fstat>
    179e:	892a                	mv	s2,a0
  close(fd);
    17a0:	8526                	mv	a0,s1
    17a2:	160000ef          	jal	1902 <close>
  return r;
    17a6:	64a2                	ld	s1,8(sp)
}
    17a8:	854a                	mv	a0,s2
    17aa:	60e2                	ld	ra,24(sp)
    17ac:	6442                	ld	s0,16(sp)
    17ae:	6902                	ld	s2,0(sp)
    17b0:	6105                	addi	sp,sp,32
    17b2:	8082                	ret
    return -1;
    17b4:	597d                	li	s2,-1
    17b6:	bfcd                	j	17a8 <stat+0x2a>

00000000000017b8 <atoi>:

int
atoi(const char *s)
{
    17b8:	1141                	addi	sp,sp,-16
    17ba:	e422                	sd	s0,8(sp)
    17bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    17be:	00054683          	lbu	a3,0(a0)
    17c2:	fd06879b          	addiw	a5,a3,-48
    17c6:	0ff7f793          	zext.b	a5,a5
    17ca:	4625                	li	a2,9
    17cc:	02f66863          	bltu	a2,a5,17fc <atoi+0x44>
    17d0:	872a                	mv	a4,a0
  n = 0;
    17d2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    17d4:	0705                	addi	a4,a4,1
    17d6:	0025179b          	slliw	a5,a0,0x2
    17da:	9fa9                	addw	a5,a5,a0
    17dc:	0017979b          	slliw	a5,a5,0x1
    17e0:	9fb5                	addw	a5,a5,a3
    17e2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    17e6:	00074683          	lbu	a3,0(a4)
    17ea:	fd06879b          	addiw	a5,a3,-48
    17ee:	0ff7f793          	zext.b	a5,a5
    17f2:	fef671e3          	bgeu	a2,a5,17d4 <atoi+0x1c>
  return n;
}
    17f6:	6422                	ld	s0,8(sp)
    17f8:	0141                	addi	sp,sp,16
    17fa:	8082                	ret
  n = 0;
    17fc:	4501                	li	a0,0
    17fe:	bfe5                	j	17f6 <atoi+0x3e>

0000000000001800 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1800:	1141                	addi	sp,sp,-16
    1802:	e422                	sd	s0,8(sp)
    1804:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    1806:	02b57463          	bgeu	a0,a1,182e <memmove+0x2e>
    while(n-- > 0)
    180a:	00c05f63          	blez	a2,1828 <memmove+0x28>
    180e:	1602                	slli	a2,a2,0x20
    1810:	9201                	srli	a2,a2,0x20
    1812:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    1816:	872a                	mv	a4,a0
      *dst++ = *src++;
    1818:	0585                	addi	a1,a1,1
    181a:	0705                	addi	a4,a4,1
    181c:	fff5c683          	lbu	a3,-1(a1)
    1820:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    1824:	fef71ae3          	bne	a4,a5,1818 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    1828:	6422                	ld	s0,8(sp)
    182a:	0141                	addi	sp,sp,16
    182c:	8082                	ret
    dst += n;
    182e:	00c50733          	add	a4,a0,a2
    src += n;
    1832:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    1834:	fec05ae3          	blez	a2,1828 <memmove+0x28>
    1838:	fff6079b          	addiw	a5,a2,-1
    183c:	1782                	slli	a5,a5,0x20
    183e:	9381                	srli	a5,a5,0x20
    1840:	fff7c793          	not	a5,a5
    1844:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    1846:	15fd                	addi	a1,a1,-1
    1848:	177d                	addi	a4,a4,-1
    184a:	0005c683          	lbu	a3,0(a1)
    184e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    1852:	fee79ae3          	bne	a5,a4,1846 <memmove+0x46>
    1856:	bfc9                	j	1828 <memmove+0x28>

0000000000001858 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1858:	1141                	addi	sp,sp,-16
    185a:	e422                	sd	s0,8(sp)
    185c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    185e:	ca05                	beqz	a2,188e <memcmp+0x36>
    1860:	fff6069b          	addiw	a3,a2,-1
    1864:	1682                	slli	a3,a3,0x20
    1866:	9281                	srli	a3,a3,0x20
    1868:	0685                	addi	a3,a3,1
    186a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    186c:	00054783          	lbu	a5,0(a0)
    1870:	0005c703          	lbu	a4,0(a1)
    1874:	00e79863          	bne	a5,a4,1884 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    1878:	0505                	addi	a0,a0,1
    p2++;
    187a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    187c:	fed518e3          	bne	a0,a3,186c <memcmp+0x14>
  }
  return 0;
    1880:	4501                	li	a0,0
    1882:	a019                	j	1888 <memcmp+0x30>
      return *p1 - *p2;
    1884:	40e7853b          	subw	a0,a5,a4
}
    1888:	6422                	ld	s0,8(sp)
    188a:	0141                	addi	sp,sp,16
    188c:	8082                	ret
  return 0;
    188e:	4501                	li	a0,0
    1890:	bfe5                	j	1888 <memcmp+0x30>

0000000000001892 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    1892:	1141                	addi	sp,sp,-16
    1894:	e406                	sd	ra,8(sp)
    1896:	e022                	sd	s0,0(sp)
    1898:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    189a:	f67ff0ef          	jal	1800 <memmove>
}
    189e:	60a2                	ld	ra,8(sp)
    18a0:	6402                	ld	s0,0(sp)
    18a2:	0141                	addi	sp,sp,16
    18a4:	8082                	ret

00000000000018a6 <sbrk>:

char *
sbrk(int n) {
    18a6:	1141                	addi	sp,sp,-16
    18a8:	e406                	sd	ra,8(sp)
    18aa:	e022                	sd	s0,0(sp)
    18ac:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    18ae:	4585                	li	a1,1
    18b0:	0b2000ef          	jal	1962 <sys_sbrk>
}
    18b4:	60a2                	ld	ra,8(sp)
    18b6:	6402                	ld	s0,0(sp)
    18b8:	0141                	addi	sp,sp,16
    18ba:	8082                	ret

00000000000018bc <sbrklazy>:

char *
sbrklazy(int n) {
    18bc:	1141                	addi	sp,sp,-16
    18be:	e406                	sd	ra,8(sp)
    18c0:	e022                	sd	s0,0(sp)
    18c2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    18c4:	4589                	li	a1,2
    18c6:	09c000ef          	jal	1962 <sys_sbrk>
}
    18ca:	60a2                	ld	ra,8(sp)
    18cc:	6402                	ld	s0,0(sp)
    18ce:	0141                	addi	sp,sp,16
    18d0:	8082                	ret

00000000000018d2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    18d2:	4885                	li	a7,1
 ecall
    18d4:	00000073          	ecall
 ret
    18d8:	8082                	ret

00000000000018da <exit>:
.global exit
exit:
 li a7, SYS_exit
    18da:	4889                	li	a7,2
 ecall
    18dc:	00000073          	ecall
 ret
    18e0:	8082                	ret

00000000000018e2 <wait>:
.global wait
wait:
 li a7, SYS_wait
    18e2:	488d                	li	a7,3
 ecall
    18e4:	00000073          	ecall
 ret
    18e8:	8082                	ret

00000000000018ea <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    18ea:	4891                	li	a7,4
 ecall
    18ec:	00000073          	ecall
 ret
    18f0:	8082                	ret

00000000000018f2 <read>:
.global read
read:
 li a7, SYS_read
    18f2:	4895                	li	a7,5
 ecall
    18f4:	00000073          	ecall
 ret
    18f8:	8082                	ret

00000000000018fa <write>:
.global write
write:
 li a7, SYS_write
    18fa:	48c1                	li	a7,16
 ecall
    18fc:	00000073          	ecall
 ret
    1900:	8082                	ret

0000000000001902 <close>:
.global close
close:
 li a7, SYS_close
    1902:	48d5                	li	a7,21
 ecall
    1904:	00000073          	ecall
 ret
    1908:	8082                	ret

000000000000190a <kill>:
.global kill
kill:
 li a7, SYS_kill
    190a:	4899                	li	a7,6
 ecall
    190c:	00000073          	ecall
 ret
    1910:	8082                	ret

0000000000001912 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1912:	489d                	li	a7,7
 ecall
    1914:	00000073          	ecall
 ret
    1918:	8082                	ret

000000000000191a <open>:
.global open
open:
 li a7, SYS_open
    191a:	48bd                	li	a7,15
 ecall
    191c:	00000073          	ecall
 ret
    1920:	8082                	ret

0000000000001922 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1922:	48c5                	li	a7,17
 ecall
    1924:	00000073          	ecall
 ret
    1928:	8082                	ret

000000000000192a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    192a:	48c9                	li	a7,18
 ecall
    192c:	00000073          	ecall
 ret
    1930:	8082                	ret

0000000000001932 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1932:	48a1                	li	a7,8
 ecall
    1934:	00000073          	ecall
 ret
    1938:	8082                	ret

000000000000193a <link>:
.global link
link:
 li a7, SYS_link
    193a:	48cd                	li	a7,19
 ecall
    193c:	00000073          	ecall
 ret
    1940:	8082                	ret

0000000000001942 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1942:	48d1                	li	a7,20
 ecall
    1944:	00000073          	ecall
 ret
    1948:	8082                	ret

000000000000194a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    194a:	48a5                	li	a7,9
 ecall
    194c:	00000073          	ecall
 ret
    1950:	8082                	ret

0000000000001952 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1952:	48a9                	li	a7,10
 ecall
    1954:	00000073          	ecall
 ret
    1958:	8082                	ret

000000000000195a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    195a:	48ad                	li	a7,11
 ecall
    195c:	00000073          	ecall
 ret
    1960:	8082                	ret

0000000000001962 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    1962:	48b1                	li	a7,12
 ecall
    1964:	00000073          	ecall
 ret
    1968:	8082                	ret

000000000000196a <pause>:
.global pause
pause:
 li a7, SYS_pause
    196a:	48b5                	li	a7,13
 ecall
    196c:	00000073          	ecall
 ret
    1970:	8082                	ret

0000000000001972 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1972:	48b9                	li	a7,14
 ecall
    1974:	00000073          	ecall
 ret
    1978:	8082                	ret

000000000000197a <bind>:
.global bind
bind:
 li a7, SYS_bind
    197a:	48f5                	li	a7,29
 ecall
    197c:	00000073          	ecall
 ret
    1980:	8082                	ret

0000000000001982 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
    1982:	48f9                	li	a7,30
 ecall
    1984:	00000073          	ecall
 ret
    1988:	8082                	ret

000000000000198a <send>:
.global send
send:
 li a7, SYS_send
    198a:	48fd                	li	a7,31
 ecall
    198c:	00000073          	ecall
 ret
    1990:	8082                	ret

0000000000001992 <recv>:
.global recv
recv:
 li a7, SYS_recv
    1992:	02000893          	li	a7,32
 ecall
    1996:	00000073          	ecall
 ret
    199a:	8082                	ret

000000000000199c <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
    199c:	02100893          	li	a7,33
 ecall
    19a0:	00000073          	ecall
 ret
    19a4:	8082                	ret

00000000000019a6 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
    19a6:	02200893          	li	a7,34
 ecall
    19aa:	00000073          	ecall
 ret
    19ae:	8082                	ret

00000000000019b0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    19b0:	1101                	addi	sp,sp,-32
    19b2:	ec06                	sd	ra,24(sp)
    19b4:	e822                	sd	s0,16(sp)
    19b6:	1000                	addi	s0,sp,32
    19b8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    19bc:	4605                	li	a2,1
    19be:	fef40593          	addi	a1,s0,-17
    19c2:	f39ff0ef          	jal	18fa <write>
}
    19c6:	60e2                	ld	ra,24(sp)
    19c8:	6442                	ld	s0,16(sp)
    19ca:	6105                	addi	sp,sp,32
    19cc:	8082                	ret

00000000000019ce <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    19ce:	715d                	addi	sp,sp,-80
    19d0:	e486                	sd	ra,72(sp)
    19d2:	e0a2                	sd	s0,64(sp)
    19d4:	f84a                	sd	s2,48(sp)
    19d6:	0880                	addi	s0,sp,80
    19d8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
    19da:	c299                	beqz	a3,19e0 <printint+0x12>
    19dc:	0805c363          	bltz	a1,1a62 <printint+0x94>
  neg = 0;
    19e0:	4881                	li	a7,0
    19e2:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    19e6:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
    19e8:	00001517          	auipc	a0,0x1
    19ec:	ea850513          	addi	a0,a0,-344 # 2890 <digits>
    19f0:	883e                	mv	a6,a5
    19f2:	2785                	addiw	a5,a5,1
    19f4:	02c5f733          	remu	a4,a1,a2
    19f8:	972a                	add	a4,a4,a0
    19fa:	00074703          	lbu	a4,0(a4)
    19fe:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
    1a02:	872e                	mv	a4,a1
    1a04:	02c5d5b3          	divu	a1,a1,a2
    1a08:	0685                	addi	a3,a3,1
    1a0a:	fec773e3          	bgeu	a4,a2,19f0 <printint+0x22>
  if(neg)
    1a0e:	00088b63          	beqz	a7,1a24 <printint+0x56>
    buf[i++] = '-';
    1a12:	fd078793          	addi	a5,a5,-48
    1a16:	97a2                	add	a5,a5,s0
    1a18:	02d00713          	li	a4,45
    1a1c:	fee78423          	sb	a4,-24(a5)
    1a20:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    1a24:	02f05a63          	blez	a5,1a58 <printint+0x8a>
    1a28:	fc26                	sd	s1,56(sp)
    1a2a:	f44e                	sd	s3,40(sp)
    1a2c:	fb840713          	addi	a4,s0,-72
    1a30:	00f704b3          	add	s1,a4,a5
    1a34:	fff70993          	addi	s3,a4,-1
    1a38:	99be                	add	s3,s3,a5
    1a3a:	37fd                	addiw	a5,a5,-1
    1a3c:	1782                	slli	a5,a5,0x20
    1a3e:	9381                	srli	a5,a5,0x20
    1a40:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
    1a44:	fff4c583          	lbu	a1,-1(s1)
    1a48:	854a                	mv	a0,s2
    1a4a:	f67ff0ef          	jal	19b0 <putc>
  while(--i >= 0)
    1a4e:	14fd                	addi	s1,s1,-1
    1a50:	ff349ae3          	bne	s1,s3,1a44 <printint+0x76>
    1a54:	74e2                	ld	s1,56(sp)
    1a56:	79a2                	ld	s3,40(sp)
}
    1a58:	60a6                	ld	ra,72(sp)
    1a5a:	6406                	ld	s0,64(sp)
    1a5c:	7942                	ld	s2,48(sp)
    1a5e:	6161                	addi	sp,sp,80
    1a60:	8082                	ret
    x = -xx;
    1a62:	40b005b3          	neg	a1,a1
    neg = 1;
    1a66:	4885                	li	a7,1
    x = -xx;
    1a68:	bfad                	j	19e2 <printint+0x14>

0000000000001a6a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1a6a:	711d                	addi	sp,sp,-96
    1a6c:	ec86                	sd	ra,88(sp)
    1a6e:	e8a2                	sd	s0,80(sp)
    1a70:	e0ca                	sd	s2,64(sp)
    1a72:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1a74:	0005c903          	lbu	s2,0(a1)
    1a78:	28090663          	beqz	s2,1d04 <vprintf+0x29a>
    1a7c:	e4a6                	sd	s1,72(sp)
    1a7e:	fc4e                	sd	s3,56(sp)
    1a80:	f852                	sd	s4,48(sp)
    1a82:	f456                	sd	s5,40(sp)
    1a84:	f05a                	sd	s6,32(sp)
    1a86:	ec5e                	sd	s7,24(sp)
    1a88:	e862                	sd	s8,16(sp)
    1a8a:	e466                	sd	s9,8(sp)
    1a8c:	8b2a                	mv	s6,a0
    1a8e:	8a2e                	mv	s4,a1
    1a90:	8bb2                	mv	s7,a2
  state = 0;
    1a92:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    1a94:	4481                	li	s1,0
    1a96:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    1a98:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    1a9c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    1aa0:	06c00c93          	li	s9,108
    1aa4:	a005                	j	1ac4 <vprintf+0x5a>
        putc(fd, c0);
    1aa6:	85ca                	mv	a1,s2
    1aa8:	855a                	mv	a0,s6
    1aaa:	f07ff0ef          	jal	19b0 <putc>
    1aae:	a019                	j	1ab4 <vprintf+0x4a>
    } else if(state == '%'){
    1ab0:	03598263          	beq	s3,s5,1ad4 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    1ab4:	2485                	addiw	s1,s1,1
    1ab6:	8726                	mv	a4,s1
    1ab8:	009a07b3          	add	a5,s4,s1
    1abc:	0007c903          	lbu	s2,0(a5)
    1ac0:	22090a63          	beqz	s2,1cf4 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
    1ac4:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1ac8:	fe0994e3          	bnez	s3,1ab0 <vprintf+0x46>
      if(c0 == '%'){
    1acc:	fd579de3          	bne	a5,s5,1aa6 <vprintf+0x3c>
        state = '%';
    1ad0:	89be                	mv	s3,a5
    1ad2:	b7cd                	j	1ab4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    1ad4:	00ea06b3          	add	a3,s4,a4
    1ad8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    1adc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    1ade:	c681                	beqz	a3,1ae6 <vprintf+0x7c>
    1ae0:	9752                	add	a4,a4,s4
    1ae2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    1ae6:	05878363          	beq	a5,s8,1b2c <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
    1aea:	05978d63          	beq	a5,s9,1b44 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1aee:	07500713          	li	a4,117
    1af2:	0ee78763          	beq	a5,a4,1be0 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    1af6:	07800713          	li	a4,120
    1afa:	12e78963          	beq	a5,a4,1c2c <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1afe:	07000713          	li	a4,112
    1b02:	14e78e63          	beq	a5,a4,1c5e <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
    1b06:	06300713          	li	a4,99
    1b0a:	18e78e63          	beq	a5,a4,1ca6 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
    1b0e:	07300713          	li	a4,115
    1b12:	1ae78463          	beq	a5,a4,1cba <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1b16:	02500713          	li	a4,37
    1b1a:	04e79563          	bne	a5,a4,1b64 <vprintf+0xfa>
        putc(fd, '%');
    1b1e:	02500593          	li	a1,37
    1b22:	855a                	mv	a0,s6
    1b24:	e8dff0ef          	jal	19b0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    1b28:	4981                	li	s3,0
    1b2a:	b769                	j	1ab4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    1b2c:	008b8913          	addi	s2,s7,8
    1b30:	4685                	li	a3,1
    1b32:	4629                	li	a2,10
    1b34:	000ba583          	lw	a1,0(s7)
    1b38:	855a                	mv	a0,s6
    1b3a:	e95ff0ef          	jal	19ce <printint>
    1b3e:	8bca                	mv	s7,s2
      state = 0;
    1b40:	4981                	li	s3,0
    1b42:	bf8d                	j	1ab4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1b44:	06400793          	li	a5,100
    1b48:	02f68963          	beq	a3,a5,1b7a <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1b4c:	06c00793          	li	a5,108
    1b50:	04f68263          	beq	a3,a5,1b94 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
    1b54:	07500793          	li	a5,117
    1b58:	0af68063          	beq	a3,a5,1bf8 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
    1b5c:	07800793          	li	a5,120
    1b60:	0ef68263          	beq	a3,a5,1c44 <vprintf+0x1da>
        putc(fd, '%');
    1b64:	02500593          	li	a1,37
    1b68:	855a                	mv	a0,s6
    1b6a:	e47ff0ef          	jal	19b0 <putc>
        putc(fd, c0);
    1b6e:	85ca                	mv	a1,s2
    1b70:	855a                	mv	a0,s6
    1b72:	e3fff0ef          	jal	19b0 <putc>
      state = 0;
    1b76:	4981                	li	s3,0
    1b78:	bf35                	j	1ab4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1b7a:	008b8913          	addi	s2,s7,8
    1b7e:	4685                	li	a3,1
    1b80:	4629                	li	a2,10
    1b82:	000bb583          	ld	a1,0(s7)
    1b86:	855a                	mv	a0,s6
    1b88:	e47ff0ef          	jal	19ce <printint>
        i += 1;
    1b8c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    1b8e:	8bca                	mv	s7,s2
      state = 0;
    1b90:	4981                	li	s3,0
        i += 1;
    1b92:	b70d                	j	1ab4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1b94:	06400793          	li	a5,100
    1b98:	02f60763          	beq	a2,a5,1bc6 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1b9c:	07500793          	li	a5,117
    1ba0:	06f60963          	beq	a2,a5,1c12 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1ba4:	07800793          	li	a5,120
    1ba8:	faf61ee3          	bne	a2,a5,1b64 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1bac:	008b8913          	addi	s2,s7,8
    1bb0:	4681                	li	a3,0
    1bb2:	4641                	li	a2,16
    1bb4:	000bb583          	ld	a1,0(s7)
    1bb8:	855a                	mv	a0,s6
    1bba:	e15ff0ef          	jal	19ce <printint>
        i += 2;
    1bbe:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1bc0:	8bca                	mv	s7,s2
      state = 0;
    1bc2:	4981                	li	s3,0
        i += 2;
    1bc4:	bdc5                	j	1ab4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1bc6:	008b8913          	addi	s2,s7,8
    1bca:	4685                	li	a3,1
    1bcc:	4629                	li	a2,10
    1bce:	000bb583          	ld	a1,0(s7)
    1bd2:	855a                	mv	a0,s6
    1bd4:	dfbff0ef          	jal	19ce <printint>
        i += 2;
    1bd8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    1bda:	8bca                	mv	s7,s2
      state = 0;
    1bdc:	4981                	li	s3,0
        i += 2;
    1bde:	bdd9                	j	1ab4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
    1be0:	008b8913          	addi	s2,s7,8
    1be4:	4681                	li	a3,0
    1be6:	4629                	li	a2,10
    1be8:	000be583          	lwu	a1,0(s7)
    1bec:	855a                	mv	a0,s6
    1bee:	de1ff0ef          	jal	19ce <printint>
    1bf2:	8bca                	mv	s7,s2
      state = 0;
    1bf4:	4981                	li	s3,0
    1bf6:	bd7d                	j	1ab4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1bf8:	008b8913          	addi	s2,s7,8
    1bfc:	4681                	li	a3,0
    1bfe:	4629                	li	a2,10
    1c00:	000bb583          	ld	a1,0(s7)
    1c04:	855a                	mv	a0,s6
    1c06:	dc9ff0ef          	jal	19ce <printint>
        i += 1;
    1c0a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    1c0c:	8bca                	mv	s7,s2
      state = 0;
    1c0e:	4981                	li	s3,0
        i += 1;
    1c10:	b555                	j	1ab4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1c12:	008b8913          	addi	s2,s7,8
    1c16:	4681                	li	a3,0
    1c18:	4629                	li	a2,10
    1c1a:	000bb583          	ld	a1,0(s7)
    1c1e:	855a                	mv	a0,s6
    1c20:	dafff0ef          	jal	19ce <printint>
        i += 2;
    1c24:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1c26:	8bca                	mv	s7,s2
      state = 0;
    1c28:	4981                	li	s3,0
        i += 2;
    1c2a:	b569                	j	1ab4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
    1c2c:	008b8913          	addi	s2,s7,8
    1c30:	4681                	li	a3,0
    1c32:	4641                	li	a2,16
    1c34:	000be583          	lwu	a1,0(s7)
    1c38:	855a                	mv	a0,s6
    1c3a:	d95ff0ef          	jal	19ce <printint>
    1c3e:	8bca                	mv	s7,s2
      state = 0;
    1c40:	4981                	li	s3,0
    1c42:	bd8d                	j	1ab4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1c44:	008b8913          	addi	s2,s7,8
    1c48:	4681                	li	a3,0
    1c4a:	4641                	li	a2,16
    1c4c:	000bb583          	ld	a1,0(s7)
    1c50:	855a                	mv	a0,s6
    1c52:	d7dff0ef          	jal	19ce <printint>
        i += 1;
    1c56:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1c58:	8bca                	mv	s7,s2
      state = 0;
    1c5a:	4981                	li	s3,0
        i += 1;
    1c5c:	bda1                	j	1ab4 <vprintf+0x4a>
    1c5e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1c60:	008b8d13          	addi	s10,s7,8
    1c64:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1c68:	03000593          	li	a1,48
    1c6c:	855a                	mv	a0,s6
    1c6e:	d43ff0ef          	jal	19b0 <putc>
  putc(fd, 'x');
    1c72:	07800593          	li	a1,120
    1c76:	855a                	mv	a0,s6
    1c78:	d39ff0ef          	jal	19b0 <putc>
    1c7c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1c7e:	00001b97          	auipc	s7,0x1
    1c82:	c12b8b93          	addi	s7,s7,-1006 # 2890 <digits>
    1c86:	03c9d793          	srli	a5,s3,0x3c
    1c8a:	97de                	add	a5,a5,s7
    1c8c:	0007c583          	lbu	a1,0(a5)
    1c90:	855a                	mv	a0,s6
    1c92:	d1fff0ef          	jal	19b0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1c96:	0992                	slli	s3,s3,0x4
    1c98:	397d                	addiw	s2,s2,-1
    1c9a:	fe0916e3          	bnez	s2,1c86 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
    1c9e:	8bea                	mv	s7,s10
      state = 0;
    1ca0:	4981                	li	s3,0
    1ca2:	6d02                	ld	s10,0(sp)
    1ca4:	bd01                	j	1ab4 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
    1ca6:	008b8913          	addi	s2,s7,8
    1caa:	000bc583          	lbu	a1,0(s7)
    1cae:	855a                	mv	a0,s6
    1cb0:	d01ff0ef          	jal	19b0 <putc>
    1cb4:	8bca                	mv	s7,s2
      state = 0;
    1cb6:	4981                	li	s3,0
    1cb8:	bbf5                	j	1ab4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1cba:	008b8993          	addi	s3,s7,8
    1cbe:	000bb903          	ld	s2,0(s7)
    1cc2:	00090f63          	beqz	s2,1ce0 <vprintf+0x276>
        for(; *s; s++)
    1cc6:	00094583          	lbu	a1,0(s2)
    1cca:	c195                	beqz	a1,1cee <vprintf+0x284>
          putc(fd, *s);
    1ccc:	855a                	mv	a0,s6
    1cce:	ce3ff0ef          	jal	19b0 <putc>
        for(; *s; s++)
    1cd2:	0905                	addi	s2,s2,1
    1cd4:	00094583          	lbu	a1,0(s2)
    1cd8:	f9f5                	bnez	a1,1ccc <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    1cda:	8bce                	mv	s7,s3
      state = 0;
    1cdc:	4981                	li	s3,0
    1cde:	bbd9                	j	1ab4 <vprintf+0x4a>
          s = "(null)";
    1ce0:	00001917          	auipc	s2,0x1
    1ce4:	ba890913          	addi	s2,s2,-1112 # 2888 <malloc+0xa9c>
        for(; *s; s++)
    1ce8:	02800593          	li	a1,40
    1cec:	b7c5                	j	1ccc <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    1cee:	8bce                	mv	s7,s3
      state = 0;
    1cf0:	4981                	li	s3,0
    1cf2:	b3c9                	j	1ab4 <vprintf+0x4a>
    1cf4:	64a6                	ld	s1,72(sp)
    1cf6:	79e2                	ld	s3,56(sp)
    1cf8:	7a42                	ld	s4,48(sp)
    1cfa:	7aa2                	ld	s5,40(sp)
    1cfc:	7b02                	ld	s6,32(sp)
    1cfe:	6be2                	ld	s7,24(sp)
    1d00:	6c42                	ld	s8,16(sp)
    1d02:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1d04:	60e6                	ld	ra,88(sp)
    1d06:	6446                	ld	s0,80(sp)
    1d08:	6906                	ld	s2,64(sp)
    1d0a:	6125                	addi	sp,sp,96
    1d0c:	8082                	ret

0000000000001d0e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1d0e:	715d                	addi	sp,sp,-80
    1d10:	ec06                	sd	ra,24(sp)
    1d12:	e822                	sd	s0,16(sp)
    1d14:	1000                	addi	s0,sp,32
    1d16:	e010                	sd	a2,0(s0)
    1d18:	e414                	sd	a3,8(s0)
    1d1a:	e818                	sd	a4,16(s0)
    1d1c:	ec1c                	sd	a5,24(s0)
    1d1e:	03043023          	sd	a6,32(s0)
    1d22:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1d26:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1d2a:	8622                	mv	a2,s0
    1d2c:	d3fff0ef          	jal	1a6a <vprintf>
}
    1d30:	60e2                	ld	ra,24(sp)
    1d32:	6442                	ld	s0,16(sp)
    1d34:	6161                	addi	sp,sp,80
    1d36:	8082                	ret

0000000000001d38 <printf>:

void
printf(const char *fmt, ...)
{
    1d38:	711d                	addi	sp,sp,-96
    1d3a:	ec06                	sd	ra,24(sp)
    1d3c:	e822                	sd	s0,16(sp)
    1d3e:	1000                	addi	s0,sp,32
    1d40:	e40c                	sd	a1,8(s0)
    1d42:	e810                	sd	a2,16(s0)
    1d44:	ec14                	sd	a3,24(s0)
    1d46:	f018                	sd	a4,32(s0)
    1d48:	f41c                	sd	a5,40(s0)
    1d4a:	03043823          	sd	a6,48(s0)
    1d4e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1d52:	00840613          	addi	a2,s0,8
    1d56:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1d5a:	85aa                	mv	a1,a0
    1d5c:	4505                	li	a0,1
    1d5e:	d0dff0ef          	jal	1a6a <vprintf>
}
    1d62:	60e2                	ld	ra,24(sp)
    1d64:	6442                	ld	s0,16(sp)
    1d66:	6125                	addi	sp,sp,96
    1d68:	8082                	ret

0000000000001d6a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1d6a:	1141                	addi	sp,sp,-16
    1d6c:	e422                	sd	s0,8(sp)
    1d6e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1d70:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1d74:	00002797          	auipc	a5,0x2
    1d78:	28c7b783          	ld	a5,652(a5) # 4000 <freep>
    1d7c:	a02d                	j	1da6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1d7e:	4618                	lw	a4,8(a2)
    1d80:	9f2d                	addw	a4,a4,a1
    1d82:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1d86:	6398                	ld	a4,0(a5)
    1d88:	6310                	ld	a2,0(a4)
    1d8a:	a83d                	j	1dc8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1d8c:	ff852703          	lw	a4,-8(a0)
    1d90:	9f31                	addw	a4,a4,a2
    1d92:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1d94:	ff053683          	ld	a3,-16(a0)
    1d98:	a091                	j	1ddc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1d9a:	6398                	ld	a4,0(a5)
    1d9c:	00e7e463          	bltu	a5,a4,1da4 <free+0x3a>
    1da0:	00e6ea63          	bltu	a3,a4,1db4 <free+0x4a>
{
    1da4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1da6:	fed7fae3          	bgeu	a5,a3,1d9a <free+0x30>
    1daa:	6398                	ld	a4,0(a5)
    1dac:	00e6e463          	bltu	a3,a4,1db4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1db0:	fee7eae3          	bltu	a5,a4,1da4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1db4:	ff852583          	lw	a1,-8(a0)
    1db8:	6390                	ld	a2,0(a5)
    1dba:	02059813          	slli	a6,a1,0x20
    1dbe:	01c85713          	srli	a4,a6,0x1c
    1dc2:	9736                	add	a4,a4,a3
    1dc4:	fae60de3          	beq	a2,a4,1d7e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1dc8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1dcc:	4790                	lw	a2,8(a5)
    1dce:	02061593          	slli	a1,a2,0x20
    1dd2:	01c5d713          	srli	a4,a1,0x1c
    1dd6:	973e                	add	a4,a4,a5
    1dd8:	fae68ae3          	beq	a3,a4,1d8c <free+0x22>
    p->s.ptr = bp->s.ptr;
    1ddc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1dde:	00002717          	auipc	a4,0x2
    1de2:	22f73123          	sd	a5,546(a4) # 4000 <freep>
}
    1de6:	6422                	ld	s0,8(sp)
    1de8:	0141                	addi	sp,sp,16
    1dea:	8082                	ret

0000000000001dec <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1dec:	7139                	addi	sp,sp,-64
    1dee:	fc06                	sd	ra,56(sp)
    1df0:	f822                	sd	s0,48(sp)
    1df2:	f426                	sd	s1,40(sp)
    1df4:	ec4e                	sd	s3,24(sp)
    1df6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1df8:	02051493          	slli	s1,a0,0x20
    1dfc:	9081                	srli	s1,s1,0x20
    1dfe:	04bd                	addi	s1,s1,15
    1e00:	8091                	srli	s1,s1,0x4
    1e02:	0014899b          	addiw	s3,s1,1
    1e06:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1e08:	00002517          	auipc	a0,0x2
    1e0c:	1f853503          	ld	a0,504(a0) # 4000 <freep>
    1e10:	c915                	beqz	a0,1e44 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e12:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1e14:	4798                	lw	a4,8(a5)
    1e16:	08977a63          	bgeu	a4,s1,1eaa <malloc+0xbe>
    1e1a:	f04a                	sd	s2,32(sp)
    1e1c:	e852                	sd	s4,16(sp)
    1e1e:	e456                	sd	s5,8(sp)
    1e20:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1e22:	8a4e                	mv	s4,s3
    1e24:	0009871b          	sext.w	a4,s3
    1e28:	6685                	lui	a3,0x1
    1e2a:	00d77363          	bgeu	a4,a3,1e30 <malloc+0x44>
    1e2e:	6a05                	lui	s4,0x1
    1e30:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1e34:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1e38:	00002917          	auipc	s2,0x2
    1e3c:	1c890913          	addi	s2,s2,456 # 4000 <freep>
  if(p == SBRK_ERROR)
    1e40:	5afd                	li	s5,-1
    1e42:	a081                	j	1e82 <malloc+0x96>
    1e44:	f04a                	sd	s2,32(sp)
    1e46:	e852                	sd	s4,16(sp)
    1e48:	e456                	sd	s5,8(sp)
    1e4a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1e4c:	00002797          	auipc	a5,0x2
    1e50:	3c478793          	addi	a5,a5,964 # 4210 <base>
    1e54:	00002717          	auipc	a4,0x2
    1e58:	1af73623          	sd	a5,428(a4) # 4000 <freep>
    1e5c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1e5e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1e62:	b7c1                	j	1e22 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1e64:	6398                	ld	a4,0(a5)
    1e66:	e118                	sd	a4,0(a0)
    1e68:	a8a9                	j	1ec2 <malloc+0xd6>
  hp->s.size = nu;
    1e6a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1e6e:	0541                	addi	a0,a0,16
    1e70:	efbff0ef          	jal	1d6a <free>
  return freep;
    1e74:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1e78:	c12d                	beqz	a0,1eda <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e7a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1e7c:	4798                	lw	a4,8(a5)
    1e7e:	02977263          	bgeu	a4,s1,1ea2 <malloc+0xb6>
    if(p == freep)
    1e82:	00093703          	ld	a4,0(s2)
    1e86:	853e                	mv	a0,a5
    1e88:	fef719e3          	bne	a4,a5,1e7a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1e8c:	8552                	mv	a0,s4
    1e8e:	a19ff0ef          	jal	18a6 <sbrk>
  if(p == SBRK_ERROR)
    1e92:	fd551ce3          	bne	a0,s5,1e6a <malloc+0x7e>
        return 0;
    1e96:	4501                	li	a0,0
    1e98:	7902                	ld	s2,32(sp)
    1e9a:	6a42                	ld	s4,16(sp)
    1e9c:	6aa2                	ld	s5,8(sp)
    1e9e:	6b02                	ld	s6,0(sp)
    1ea0:	a03d                	j	1ece <malloc+0xe2>
    1ea2:	7902                	ld	s2,32(sp)
    1ea4:	6a42                	ld	s4,16(sp)
    1ea6:	6aa2                	ld	s5,8(sp)
    1ea8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1eaa:	fae48de3          	beq	s1,a4,1e64 <malloc+0x78>
        p->s.size -= nunits;
    1eae:	4137073b          	subw	a4,a4,s3
    1eb2:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1eb4:	02071693          	slli	a3,a4,0x20
    1eb8:	01c6d713          	srli	a4,a3,0x1c
    1ebc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1ebe:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1ec2:	00002717          	auipc	a4,0x2
    1ec6:	12a73f23          	sd	a0,318(a4) # 4000 <freep>
      return (void*)(p + 1);
    1eca:	01078513          	addi	a0,a5,16
  }
}
    1ece:	70e2                	ld	ra,56(sp)
    1ed0:	7442                	ld	s0,48(sp)
    1ed2:	74a2                	ld	s1,40(sp)
    1ed4:	69e2                	ld	s3,24(sp)
    1ed6:	6121                	addi	sp,sp,64
    1ed8:	8082                	ret
    1eda:	7902                	ld	s2,32(sp)
    1edc:	6a42                	ld	s4,16(sp)
    1ede:	6aa2                	ld	s5,8(sp)
    1ee0:	6b02                	ld	s6,0(sp)
    1ee2:	b7f5                	j	1ece <malloc+0xe2>
