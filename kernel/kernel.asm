
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000c117          	auipc	sp,0xc
    80000004:	8e813103          	ld	sp,-1816(sp) # 8000b8e8 <_GLOBAL_OFFSET_TABLE_+0x8>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	655050ef          	jal	80005e6a <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	000a9797          	auipc	a5,0xa9
    80000034:	8d878793          	addi	a5,a5,-1832 # 800a8908 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000c917          	auipc	s2,0xc
    80000050:	8f490913          	addi	s2,s2,-1804 # 8000b940 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	051060ef          	jal	800068a6 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	0d9060ef          	jal	8000693e <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00008517          	auipc	a0,0x8
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80008000 <etext>
    8000007e:	56c060ef          	jal	800065ea <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00008597          	auipc	a1,0x8
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80008010 <etext+0x10>
    800000da:	0000c517          	auipc	a0,0xc
    800000de:	86650513          	addi	a0,a0,-1946 # 8000b940 <kmem>
    800000e2:	744060ef          	jal	80006826 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	000a9517          	auipc	a0,0xa9
    800000ee:	81e50513          	addi	a0,a0,-2018 # 800a8908 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000c497          	auipc	s1,0xc
    8000010c:	83848493          	addi	s1,s1,-1992 # 8000b940 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	794060ef          	jal	800068a6 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000c517          	auipc	a0,0xc
    80000120:	82450513          	addi	a0,a0,-2012 # 8000b940 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	019060ef          	jal	8000693e <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000c517          	auipc	a0,0xc
    80000144:	80050513          	addi	a0,a0,-2048 # 8000b940 <kmem>
    80000148:	7f6060ef          	jal	8000693e <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e422                	sd	s0,8(sp)
    80000152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000154:	ca19                	beqz	a2,8000016a <memset+0x1c>
    80000156:	87aa                	mv	a5,a0
    80000158:	1602                	slli	a2,a2,0x20
    8000015a:	9201                	srli	a2,a2,0x20
    8000015c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000164:	0785                	addi	a5,a5,1
    80000166:	fee79de3          	bne	a5,a4,80000160 <memset+0x12>
  }
  return dst;
}
    8000016a:	6422                	ld	s0,8(sp)
    8000016c:	0141                	addi	sp,sp,16
    8000016e:	8082                	ret

0000000080000170 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000170:	1141                	addi	sp,sp,-16
    80000172:	e422                	sd	s0,8(sp)
    80000174:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000176:	ca05                	beqz	a2,800001a6 <memcmp+0x36>
    80000178:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000017c:	1682                	slli	a3,a3,0x20
    8000017e:	9281                	srli	a3,a3,0x20
    80000180:	0685                	addi	a3,a3,1
    80000182:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000184:	00054783          	lbu	a5,0(a0)
    80000188:	0005c703          	lbu	a4,0(a1)
    8000018c:	00e79863          	bne	a5,a4,8000019c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000190:	0505                	addi	a0,a0,1
    80000192:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000194:	fed518e3          	bne	a0,a3,80000184 <memcmp+0x14>
  }

  return 0;
    80000198:	4501                	li	a0,0
    8000019a:	a019                	j	800001a0 <memcmp+0x30>
      return *s1 - *s2;
    8000019c:	40e7853b          	subw	a0,a5,a4
}
    800001a0:	6422                	ld	s0,8(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret
  return 0;
    800001a6:	4501                	li	a0,0
    800001a8:	bfe5                	j	800001a0 <memcmp+0x30>

00000000800001aa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001aa:	1141                	addi	sp,sp,-16
    800001ac:	e422                	sd	s0,8(sp)
    800001ae:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b0:	c205                	beqz	a2,800001d0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b2:	02a5e263          	bltu	a1,a0,800001d6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001b6:	1602                	slli	a2,a2,0x20
    800001b8:	9201                	srli	a2,a2,0x20
    800001ba:	00c587b3          	add	a5,a1,a2
{
    800001be:	872a                	mv	a4,a0
      *d++ = *s++;
    800001c0:	0585                	addi	a1,a1,1
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ff566f9>
    800001c4:	fff5c683          	lbu	a3,-1(a1)
    800001c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001cc:	feb79ae3          	bne	a5,a1,800001c0 <memmove+0x16>

  return dst;
}
    800001d0:	6422                	ld	s0,8(sp)
    800001d2:	0141                	addi	sp,sp,16
    800001d4:	8082                	ret
  if(s < d && s + n > d){
    800001d6:	02061693          	slli	a3,a2,0x20
    800001da:	9281                	srli	a3,a3,0x20
    800001dc:	00d58733          	add	a4,a1,a3
    800001e0:	fce57be3          	bgeu	a0,a4,800001b6 <memmove+0xc>
    d += n;
    800001e4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001e6:	fff6079b          	addiw	a5,a2,-1
    800001ea:	1782                	slli	a5,a5,0x20
    800001ec:	9381                	srli	a5,a5,0x20
    800001ee:	fff7c793          	not	a5,a5
    800001f2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001f4:	177d                	addi	a4,a4,-1
    800001f6:	16fd                	addi	a3,a3,-1
    800001f8:	00074603          	lbu	a2,0(a4)
    800001fc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000200:	fef71ae3          	bne	a4,a5,800001f4 <memmove+0x4a>
    80000204:	b7f1                	j	800001d0 <memmove+0x26>

0000000080000206 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e406                	sd	ra,8(sp)
    8000020a:	e022                	sd	s0,0(sp)
    8000020c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000020e:	f9dff0ef          	jal	800001aa <memmove>
}
    80000212:	60a2                	ld	ra,8(sp)
    80000214:	6402                	ld	s0,0(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret

000000008000021a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000021a:	1141                	addi	sp,sp,-16
    8000021c:	e422                	sd	s0,8(sp)
    8000021e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000220:	ce11                	beqz	a2,8000023c <strncmp+0x22>
    80000222:	00054783          	lbu	a5,0(a0)
    80000226:	cf89                	beqz	a5,80000240 <strncmp+0x26>
    80000228:	0005c703          	lbu	a4,0(a1)
    8000022c:	00f71a63          	bne	a4,a5,80000240 <strncmp+0x26>
    n--, p++, q++;
    80000230:	367d                	addiw	a2,a2,-1
    80000232:	0505                	addi	a0,a0,1
    80000234:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000236:	f675                	bnez	a2,80000222 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000238:	4501                	li	a0,0
    8000023a:	a801                	j	8000024a <strncmp+0x30>
    8000023c:	4501                	li	a0,0
    8000023e:	a031                	j	8000024a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000240:	00054503          	lbu	a0,0(a0)
    80000244:	0005c783          	lbu	a5,0(a1)
    80000248:	9d1d                	subw	a0,a0,a5
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000256:	87aa                	mv	a5,a0
    80000258:	86b2                	mv	a3,a2
    8000025a:	367d                	addiw	a2,a2,-1
    8000025c:	02d05563          	blez	a3,80000286 <strncpy+0x36>
    80000260:	0785                	addi	a5,a5,1
    80000262:	0005c703          	lbu	a4,0(a1)
    80000266:	fee78fa3          	sb	a4,-1(a5)
    8000026a:	0585                	addi	a1,a1,1
    8000026c:	f775                	bnez	a4,80000258 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000026e:	873e                	mv	a4,a5
    80000270:	9fb5                	addw	a5,a5,a3
    80000272:	37fd                	addiw	a5,a5,-1
    80000274:	00c05963          	blez	a2,80000286 <strncpy+0x36>
    *s++ = 0;
    80000278:	0705                	addi	a4,a4,1
    8000027a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000027e:	40e786bb          	subw	a3,a5,a4
    80000282:	fed04be3          	bgtz	a3,80000278 <strncpy+0x28>
  return os;
}
    80000286:	6422                	ld	s0,8(sp)
    80000288:	0141                	addi	sp,sp,16
    8000028a:	8082                	ret

000000008000028c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000292:	02c05363          	blez	a2,800002b8 <safestrcpy+0x2c>
    80000296:	fff6069b          	addiw	a3,a2,-1
    8000029a:	1682                	slli	a3,a3,0x20
    8000029c:	9281                	srli	a3,a3,0x20
    8000029e:	96ae                	add	a3,a3,a1
    800002a0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002a2:	00d58963          	beq	a1,a3,800002b4 <safestrcpy+0x28>
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	0785                	addi	a5,a5,1
    800002aa:	fff5c703          	lbu	a4,-1(a1)
    800002ae:	fee78fa3          	sb	a4,-1(a5)
    800002b2:	fb65                	bnez	a4,800002a2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002b4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret

00000000800002be <strlen>:

int
strlen(const char *s)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002c4:	00054783          	lbu	a5,0(a0)
    800002c8:	cf91                	beqz	a5,800002e4 <strlen+0x26>
    800002ca:	0505                	addi	a0,a0,1
    800002cc:	87aa                	mv	a5,a0
    800002ce:	86be                	mv	a3,a5
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff7c703          	lbu	a4,-1(a5)
    800002d6:	ff65                	bnez	a4,800002ce <strlen+0x10>
    800002d8:	40a6853b          	subw	a0,a3,a0
    800002dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002de:	6422                	ld	s0,8(sp)
    800002e0:	0141                	addi	sp,sp,16
    800002e2:	8082                	ret
  for(n = 0; s[n]; n++)
    800002e4:	4501                	li	a0,0
    800002e6:	bfe5                	j	800002de <strlen+0x20>

00000000800002e8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002e8:	1101                	addi	sp,sp,-32
    800002ea:	ec06                	sd	ra,24(sp)
    800002ec:	e822                	sd	s0,16(sp)
    800002ee:	e426                	sd	s1,8(sp)
    800002f0:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800002f2:	2b9000ef          	jal	80000daa <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(atomic_read4((int *) &started) == 0)
    800002f6:	0000b497          	auipc	s1,0xb
    800002fa:	60a48493          	addi	s1,s1,1546 # 8000b900 <started>
  if(cpuid() == 0){
    800002fe:	c905                	beqz	a0,8000032e <main+0x46>
    while(atomic_read4((int *) &started) == 0)
    80000300:	8526                	mv	a0,s1
    80000302:	678060ef          	jal	8000697a <atomic_read4>
    80000306:	dd6d                	beqz	a0,80000300 <main+0x18>
      ;
    __sync_synchronize();
    80000308:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000030c:	29f000ef          	jal	80000daa <cpuid>
    80000310:	85aa                	mv	a1,a0
    80000312:	00008517          	auipc	a0,0x8
    80000316:	d2650513          	addi	a0,a0,-730 # 80008038 <etext+0x38>
    8000031a:	7eb050ef          	jal	80006304 <printf>
    kvminithart();    // turn on paging
    8000031e:	088000ef          	jal	800003a6 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000322:	5ce010ef          	jal	800018f0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000326:	5a6040ef          	jal	800048cc <plicinithart>
  }

#ifdef LAB_LOCK
  rwspinlock_test();
#endif
  scheduler();        
    8000032a:	70d000ef          	jal	80001236 <scheduler>
    consoleinit();
    8000032e:	701050ef          	jal	8000622e <consoleinit>
    printfinit();
    80000332:	2f4060ef          	jal	80006626 <printfinit>
    printf("\n");
    80000336:	00008517          	auipc	a0,0x8
    8000033a:	ce250513          	addi	a0,a0,-798 # 80008018 <etext+0x18>
    8000033e:	7c7050ef          	jal	80006304 <printf>
    printf("xv6 kernel is booting\n");
    80000342:	00008517          	auipc	a0,0x8
    80000346:	cde50513          	addi	a0,a0,-802 # 80008020 <etext+0x20>
    8000034a:	7bb050ef          	jal	80006304 <printf>
    printf("\n");
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cca50513          	addi	a0,a0,-822 # 80008018 <etext+0x18>
    80000356:	7af050ef          	jal	80006304 <printf>
    kinit();         // physical page allocator
    8000035a:	d71ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035e:	2fa000ef          	jal	80000658 <kvminit>
    kvminithart();   // turn on paging
    80000362:	044000ef          	jal	800003a6 <kvminithart>
    procinit();      // process table
    80000366:	191000ef          	jal	80000cf6 <procinit>
    trapinit();      // trap vectors
    8000036a:	562010ef          	jal	800018cc <trapinit>
    trapinithart();  // install kernel trap vector
    8000036e:	582010ef          	jal	800018f0 <trapinithart>
    plicinit();      // set up interrupt controller
    80000372:	52c040ef          	jal	8000489e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000376:	556040ef          	jal	800048cc <plicinithart>
    binit();         // buffer cache
    8000037a:	40b010ef          	jal	80001f84 <binit>
    iinit();         // inode table
    8000037e:	190020ef          	jal	8000250e <iinit>
    fileinit();      // file table
    80000382:	082030ef          	jal	80003404 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000386:	644040ef          	jal	800049ca <virtio_disk_init>
    pci_init();
    8000038a:	215050ef          	jal	80005d9e <pci_init>
    netinit();
    8000038e:	747040ef          	jal	800052d4 <netinit>
    userinit();      // first user process
    80000392:	50b000ef          	jal	8000109c <userinit>
    __sync_synchronize();
    80000396:	0330000f          	fence	rw,rw
    started = 1;
    8000039a:	4785                	li	a5,1
    8000039c:	0000b717          	auipc	a4,0xb
    800003a0:	56f72223          	sw	a5,1380(a4) # 8000b900 <started>
    800003a4:	b759                	j	8000032a <main+0x42>

00000000800003a6 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    800003a6:	1141                	addi	sp,sp,-16
    800003a8:	e422                	sd	s0,8(sp)
    800003aa:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003ac:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003b0:	0000b797          	auipc	a5,0xb
    800003b4:	5587b783          	ld	a5,1368(a5) # 8000b908 <kernel_pagetable>
    800003b8:	83b1                	srli	a5,a5,0xc
    800003ba:	577d                	li	a4,-1
    800003bc:	177e                	slli	a4,a4,0x3f
    800003be:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003c0:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003c4:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003c8:	6422                	ld	s0,8(sp)
    800003ca:	0141                	addi	sp,sp,16
    800003cc:	8082                	ret

00000000800003ce <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003ce:	7139                	addi	sp,sp,-64
    800003d0:	fc06                	sd	ra,56(sp)
    800003d2:	f822                	sd	s0,48(sp)
    800003d4:	f426                	sd	s1,40(sp)
    800003d6:	f04a                	sd	s2,32(sp)
    800003d8:	ec4e                	sd	s3,24(sp)
    800003da:	e852                	sd	s4,16(sp)
    800003dc:	e456                	sd	s5,8(sp)
    800003de:	e05a                	sd	s6,0(sp)
    800003e0:	0080                	addi	s0,sp,64
    800003e2:	84aa                	mv	s1,a0
    800003e4:	89ae                	mv	s3,a1
    800003e6:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003e8:	57fd                	li	a5,-1
    800003ea:	83e9                	srli	a5,a5,0x1a
    800003ec:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003ee:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003f0:	02b7fc63          	bgeu	a5,a1,80000428 <walk+0x5a>
    panic("walk");
    800003f4:	00008517          	auipc	a0,0x8
    800003f8:	c5c50513          	addi	a0,a0,-932 # 80008050 <etext+0x50>
    800003fc:	1ee060ef          	jal	800065ea <panic>
      if(PTE_LEAF(*pte)) {
        return pte;
      }
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000400:	060a8263          	beqz	s5,80000464 <walk+0x96>
    80000404:	cfbff0ef          	jal	800000fe <kalloc>
    80000408:	84aa                	mv	s1,a0
    8000040a:	c139                	beqz	a0,80000450 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000040c:	6605                	lui	a2,0x1
    8000040e:	4581                	li	a1,0
    80000410:	d3fff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000414:	00c4d793          	srli	a5,s1,0xc
    80000418:	07aa                	slli	a5,a5,0xa
    8000041a:	0017e793          	ori	a5,a5,1
    8000041e:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000422:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ff566ef>
    80000424:	036a0063          	beq	s4,s6,80000444 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000428:	0149d933          	srl	s2,s3,s4
    8000042c:	1ff97913          	andi	s2,s2,511
    80000430:	090e                	slli	s2,s2,0x3
    80000432:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000434:	00093483          	ld	s1,0(s2)
    80000438:	0014f793          	andi	a5,s1,1
    8000043c:	d3f1                	beqz	a5,80000400 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000043e:	80a9                	srli	s1,s1,0xa
    80000440:	04b2                	slli	s1,s1,0xc
    80000442:	b7c5                	j	80000422 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000444:	00c9d513          	srli	a0,s3,0xc
    80000448:	1ff57513          	andi	a0,a0,511
    8000044c:	050e                	slli	a0,a0,0x3
    8000044e:	9526                	add	a0,a0,s1
}
    80000450:	70e2                	ld	ra,56(sp)
    80000452:	7442                	ld	s0,48(sp)
    80000454:	74a2                	ld	s1,40(sp)
    80000456:	7902                	ld	s2,32(sp)
    80000458:	69e2                	ld	s3,24(sp)
    8000045a:	6a42                	ld	s4,16(sp)
    8000045c:	6aa2                	ld	s5,8(sp)
    8000045e:	6b02                	ld	s6,0(sp)
    80000460:	6121                	addi	sp,sp,64
    80000462:	8082                	ret
        return 0;
    80000464:	4501                	li	a0,0
    80000466:	b7ed                	j	80000450 <walk+0x82>

0000000080000468 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000468:	57fd                	li	a5,-1
    8000046a:	83e9                	srli	a5,a5,0x1a
    8000046c:	00b7f463          	bgeu	a5,a1,80000474 <walkaddr+0xc>
    return 0;
    80000470:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000472:	8082                	ret
{
    80000474:	1141                	addi	sp,sp,-16
    80000476:	e406                	sd	ra,8(sp)
    80000478:	e022                	sd	s0,0(sp)
    8000047a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000047c:	4601                	li	a2,0
    8000047e:	f51ff0ef          	jal	800003ce <walk>
  if(pte == 0)
    80000482:	c105                	beqz	a0,800004a2 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000484:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000486:	0117f693          	andi	a3,a5,17
    8000048a:	4745                	li	a4,17
    return 0;
    8000048c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000048e:	00e68663          	beq	a3,a4,8000049a <walkaddr+0x32>
}
    80000492:	60a2                	ld	ra,8(sp)
    80000494:	6402                	ld	s0,0(sp)
    80000496:	0141                	addi	sp,sp,16
    80000498:	8082                	ret
  pa = PTE2PA(*pte);
    8000049a:	83a9                	srli	a5,a5,0xa
    8000049c:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004a0:	bfcd                	j	80000492 <walkaddr+0x2a>
    return 0;
    800004a2:	4501                	li	a0,0
    800004a4:	b7fd                	j	80000492 <walkaddr+0x2a>

00000000800004a6 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004a6:	715d                	addi	sp,sp,-80
    800004a8:	e486                	sd	ra,72(sp)
    800004aa:	e0a2                	sd	s0,64(sp)
    800004ac:	fc26                	sd	s1,56(sp)
    800004ae:	f84a                	sd	s2,48(sp)
    800004b0:	f44e                	sd	s3,40(sp)
    800004b2:	f052                	sd	s4,32(sp)
    800004b4:	ec56                	sd	s5,24(sp)
    800004b6:	e85a                	sd	s6,16(sp)
    800004b8:	e45e                	sd	s7,8(sp)
    800004ba:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004bc:	03459793          	slli	a5,a1,0x34
    800004c0:	e7a9                	bnez	a5,8000050a <mappages+0x64>
    800004c2:	8aaa                	mv	s5,a0
    800004c4:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004c6:	03461793          	slli	a5,a2,0x34
    800004ca:	e7b1                	bnez	a5,80000516 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004cc:	ca39                	beqz	a2,80000522 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004ce:	77fd                	lui	a5,0xfffff
    800004d0:	963e                	add	a2,a2,a5
    800004d2:	00b609b3          	add	s3,a2,a1
  a = va;
    800004d6:	892e                	mv	s2,a1
    800004d8:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004dc:	6b85                	lui	s7,0x1
    800004de:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004e2:	4605                	li	a2,1
    800004e4:	85ca                	mv	a1,s2
    800004e6:	8556                	mv	a0,s5
    800004e8:	ee7ff0ef          	jal	800003ce <walk>
    800004ec:	c539                	beqz	a0,8000053a <mappages+0x94>
    if(*pte & PTE_V)
    800004ee:	611c                	ld	a5,0(a0)
    800004f0:	8b85                	andi	a5,a5,1
    800004f2:	ef95                	bnez	a5,8000052e <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004f4:	80b1                	srli	s1,s1,0xc
    800004f6:	04aa                	slli	s1,s1,0xa
    800004f8:	0164e4b3          	or	s1,s1,s6
    800004fc:	0014e493          	ori	s1,s1,1
    80000500:	e104                	sd	s1,0(a0)
    if(a == last)
    80000502:	05390863          	beq	s2,s3,80000552 <mappages+0xac>
    a += PGSIZE;
    80000506:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000508:	bfd9                	j	800004de <mappages+0x38>
    panic("mappages: va not aligned");
    8000050a:	00008517          	auipc	a0,0x8
    8000050e:	b4e50513          	addi	a0,a0,-1202 # 80008058 <etext+0x58>
    80000512:	0d8060ef          	jal	800065ea <panic>
    panic("mappages: size not aligned");
    80000516:	00008517          	auipc	a0,0x8
    8000051a:	b6250513          	addi	a0,a0,-1182 # 80008078 <etext+0x78>
    8000051e:	0cc060ef          	jal	800065ea <panic>
    panic("mappages: size");
    80000522:	00008517          	auipc	a0,0x8
    80000526:	b7650513          	addi	a0,a0,-1162 # 80008098 <etext+0x98>
    8000052a:	0c0060ef          	jal	800065ea <panic>
      panic("mappages: remap");
    8000052e:	00008517          	auipc	a0,0x8
    80000532:	b7a50513          	addi	a0,a0,-1158 # 800080a8 <etext+0xa8>
    80000536:	0b4060ef          	jal	800065ea <panic>
      return -1;
    8000053a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000053c:	60a6                	ld	ra,72(sp)
    8000053e:	6406                	ld	s0,64(sp)
    80000540:	74e2                	ld	s1,56(sp)
    80000542:	7942                	ld	s2,48(sp)
    80000544:	79a2                	ld	s3,40(sp)
    80000546:	7a02                	ld	s4,32(sp)
    80000548:	6ae2                	ld	s5,24(sp)
    8000054a:	6b42                	ld	s6,16(sp)
    8000054c:	6ba2                	ld	s7,8(sp)
    8000054e:	6161                	addi	sp,sp,80
    80000550:	8082                	ret
  return 0;
    80000552:	4501                	li	a0,0
    80000554:	b7e5                	j	8000053c <mappages+0x96>

0000000080000556 <kvmmap>:
{
    80000556:	1141                	addi	sp,sp,-16
    80000558:	e406                	sd	ra,8(sp)
    8000055a:	e022                	sd	s0,0(sp)
    8000055c:	0800                	addi	s0,sp,16
    8000055e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000560:	86b2                	mv	a3,a2
    80000562:	863e                	mv	a2,a5
    80000564:	f43ff0ef          	jal	800004a6 <mappages>
    80000568:	e509                	bnez	a0,80000572 <kvmmap+0x1c>
}
    8000056a:	60a2                	ld	ra,8(sp)
    8000056c:	6402                	ld	s0,0(sp)
    8000056e:	0141                	addi	sp,sp,16
    80000570:	8082                	ret
    panic("kvmmap");
    80000572:	00008517          	auipc	a0,0x8
    80000576:	b4650513          	addi	a0,a0,-1210 # 800080b8 <etext+0xb8>
    8000057a:	070060ef          	jal	800065ea <panic>

000000008000057e <kvmmake>:
{
    8000057e:	1101                	addi	sp,sp,-32
    80000580:	ec06                	sd	ra,24(sp)
    80000582:	e822                	sd	s0,16(sp)
    80000584:	e426                	sd	s1,8(sp)
    80000586:	e04a                	sd	s2,0(sp)
    80000588:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000058a:	b75ff0ef          	jal	800000fe <kalloc>
    8000058e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000590:	6605                	lui	a2,0x1
    80000592:	4581                	li	a1,0
    80000594:	bbbff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000598:	4719                	li	a4,6
    8000059a:	6685                	lui	a3,0x1
    8000059c:	10000637          	lui	a2,0x10000
    800005a0:	100005b7          	lui	a1,0x10000
    800005a4:	8526                	mv	a0,s1
    800005a6:	fb1ff0ef          	jal	80000556 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005aa:	4719                	li	a4,6
    800005ac:	6685                	lui	a3,0x1
    800005ae:	10001637          	lui	a2,0x10001
    800005b2:	100015b7          	lui	a1,0x10001
    800005b6:	8526                	mv	a0,s1
    800005b8:	f9fff0ef          	jal	80000556 <kvmmap>
  kvmmap(kpgtbl, 0x30000000L, 0x30000000L, 0x10000000, PTE_R | PTE_W);
    800005bc:	4719                	li	a4,6
    800005be:	100006b7          	lui	a3,0x10000
    800005c2:	30000637          	lui	a2,0x30000
    800005c6:	300005b7          	lui	a1,0x30000
    800005ca:	8526                	mv	a0,s1
    800005cc:	f8bff0ef          	jal	80000556 <kvmmap>
  kvmmap(kpgtbl, 0x40000000L, 0x40000000L, 0x20000, PTE_R | PTE_W);
    800005d0:	4719                	li	a4,6
    800005d2:	000206b7          	lui	a3,0x20
    800005d6:	40000637          	lui	a2,0x40000
    800005da:	400005b7          	lui	a1,0x40000
    800005de:	8526                	mv	a0,s1
    800005e0:	f77ff0ef          	jal	80000556 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005e4:	4719                	li	a4,6
    800005e6:	040006b7          	lui	a3,0x4000
    800005ea:	0c000637          	lui	a2,0xc000
    800005ee:	0c0005b7          	lui	a1,0xc000
    800005f2:	8526                	mv	a0,s1
    800005f4:	f63ff0ef          	jal	80000556 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005f8:	00008917          	auipc	s2,0x8
    800005fc:	a0890913          	addi	s2,s2,-1528 # 80008000 <etext>
    80000600:	4729                	li	a4,10
    80000602:	80008697          	auipc	a3,0x80008
    80000606:	9fe68693          	addi	a3,a3,-1538 # 8000 <_entry-0x7fff8000>
    8000060a:	4605                	li	a2,1
    8000060c:	067e                	slli	a2,a2,0x1f
    8000060e:	85b2                	mv	a1,a2
    80000610:	8526                	mv	a0,s1
    80000612:	f45ff0ef          	jal	80000556 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000616:	46c5                	li	a3,17
    80000618:	06ee                	slli	a3,a3,0x1b
    8000061a:	4719                	li	a4,6
    8000061c:	412686b3          	sub	a3,a3,s2
    80000620:	864a                	mv	a2,s2
    80000622:	85ca                	mv	a1,s2
    80000624:	8526                	mv	a0,s1
    80000626:	f31ff0ef          	jal	80000556 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000062a:	4729                	li	a4,10
    8000062c:	6685                	lui	a3,0x1
    8000062e:	00007617          	auipc	a2,0x7
    80000632:	9d260613          	addi	a2,a2,-1582 # 80007000 <_trampoline>
    80000636:	040005b7          	lui	a1,0x4000
    8000063a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000063c:	05b2                	slli	a1,a1,0xc
    8000063e:	8526                	mv	a0,s1
    80000640:	f17ff0ef          	jal	80000556 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000644:	8526                	mv	a0,s1
    80000646:	61a000ef          	jal	80000c60 <proc_mapstacks>
}
    8000064a:	8526                	mv	a0,s1
    8000064c:	60e2                	ld	ra,24(sp)
    8000064e:	6442                	ld	s0,16(sp)
    80000650:	64a2                	ld	s1,8(sp)
    80000652:	6902                	ld	s2,0(sp)
    80000654:	6105                	addi	sp,sp,32
    80000656:	8082                	ret

0000000080000658 <kvminit>:
{
    80000658:	1141                	addi	sp,sp,-16
    8000065a:	e406                	sd	ra,8(sp)
    8000065c:	e022                	sd	s0,0(sp)
    8000065e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000660:	f1fff0ef          	jal	8000057e <kvmmake>
    80000664:	0000b797          	auipc	a5,0xb
    80000668:	2aa7b223          	sd	a0,676(a5) # 8000b908 <kernel_pagetable>
}
    8000066c:	60a2                	ld	ra,8(sp)
    8000066e:	6402                	ld	s0,0(sp)
    80000670:	0141                	addi	sp,sp,16
    80000672:	8082                	ret

0000000080000674 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000674:	1101                	addi	sp,sp,-32
    80000676:	ec06                	sd	ra,24(sp)
    80000678:	e822                	sd	s0,16(sp)
    8000067a:	e426                	sd	s1,8(sp)
    8000067c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000067e:	a81ff0ef          	jal	800000fe <kalloc>
    80000682:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000684:	c509                	beqz	a0,8000068e <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000686:	6605                	lui	a2,0x1
    80000688:	4581                	li	a1,0
    8000068a:	ac5ff0ef          	jal	8000014e <memset>
  return pagetable;
}
    8000068e:	8526                	mv	a0,s1
    80000690:	60e2                	ld	ra,24(sp)
    80000692:	6442                	ld	s0,16(sp)
    80000694:	64a2                	ld	s1,8(sp)
    80000696:	6105                	addi	sp,sp,32
    80000698:	8082                	ret

000000008000069a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000069a:	715d                	addi	sp,sp,-80
    8000069c:	e486                	sd	ra,72(sp)
    8000069e:	e0a2                	sd	s0,64(sp)
    800006a0:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz = PGSIZE;

  if((va % PGSIZE) != 0)
    800006a2:	03459793          	slli	a5,a1,0x34
    800006a6:	e39d                	bnez	a5,800006cc <uvmunmap+0x32>
    800006a8:	f84a                	sd	s2,48(sp)
    800006aa:	f44e                	sd	s3,40(sp)
    800006ac:	f052                	sd	s4,32(sp)
    800006ae:	ec56                	sd	s5,24(sp)
    800006b0:	e85a                	sd	s6,16(sp)
    800006b2:	e45e                	sd	s7,8(sp)
    800006b4:	8a2a                	mv	s4,a0
    800006b6:	892e                	mv	s2,a1
    800006b8:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006ba:	0632                	slli	a2,a2,0xc
    800006bc:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
      continue;
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
      continue;
    sz = PGSIZE;
    if(PTE_FLAGS(*pte) == PTE_V)
    800006c0:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006c2:	6a85                	lui	s5,0x1
    800006c4:	0735f463          	bgeu	a1,s3,8000072c <uvmunmap+0x92>
    800006c8:	fc26                	sd	s1,56(sp)
    800006ca:	a80d                	j	800006fc <uvmunmap+0x62>
    800006cc:	fc26                	sd	s1,56(sp)
    800006ce:	f84a                	sd	s2,48(sp)
    800006d0:	f44e                	sd	s3,40(sp)
    800006d2:	f052                	sd	s4,32(sp)
    800006d4:	ec56                	sd	s5,24(sp)
    800006d6:	e85a                	sd	s6,16(sp)
    800006d8:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006da:	00008517          	auipc	a0,0x8
    800006de:	9e650513          	addi	a0,a0,-1562 # 800080c0 <etext+0xc0>
    800006e2:	709050ef          	jal	800065ea <panic>
      panic("uvmunmap: not a leaf");
    800006e6:	00008517          	auipc	a0,0x8
    800006ea:	9f250513          	addi	a0,a0,-1550 # 800080d8 <etext+0xd8>
    800006ee:	6fd050ef          	jal	800065ea <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006f2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006f6:	9956                	add	s2,s2,s5
    800006f8:	03397963          	bgeu	s2,s3,8000072a <uvmunmap+0x90>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800006fc:	4601                	li	a2,0
    800006fe:	85ca                	mv	a1,s2
    80000700:	8552                	mv	a0,s4
    80000702:	ccdff0ef          	jal	800003ce <walk>
    80000706:	84aa                	mv	s1,a0
    80000708:	d57d                	beqz	a0,800006f6 <uvmunmap+0x5c>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    8000070a:	611c                	ld	a5,0(a0)
    8000070c:	0017f713          	andi	a4,a5,1
    80000710:	d37d                	beqz	a4,800006f6 <uvmunmap+0x5c>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000712:	3ff7f713          	andi	a4,a5,1023
    80000716:	fd7708e3          	beq	a4,s7,800006e6 <uvmunmap+0x4c>
    if(do_free){
    8000071a:	fc0b0ce3          	beqz	s6,800006f2 <uvmunmap+0x58>
      uint64 pa = PTE2PA(*pte);
    8000071e:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80000720:	00c79513          	slli	a0,a5,0xc
    80000724:	8f9ff0ef          	jal	8000001c <kfree>
    80000728:	b7e9                	j	800006f2 <uvmunmap+0x58>
    8000072a:	74e2                	ld	s1,56(sp)
    8000072c:	7942                	ld	s2,48(sp)
    8000072e:	79a2                	ld	s3,40(sp)
    80000730:	7a02                	ld	s4,32(sp)
    80000732:	6ae2                	ld	s5,24(sp)
    80000734:	6b42                	ld	s6,16(sp)
    80000736:	6ba2                	ld	s7,8(sp)
  }
}
    80000738:	60a6                	ld	ra,72(sp)
    8000073a:	6406                	ld	s0,64(sp)
    8000073c:	6161                	addi	sp,sp,80
    8000073e:	8082                	ret

0000000080000740 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000740:	1101                	addi	sp,sp,-32
    80000742:	ec06                	sd	ra,24(sp)
    80000744:	e822                	sd	s0,16(sp)
    80000746:	e426                	sd	s1,8(sp)
    80000748:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000074a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000074c:	00b67d63          	bgeu	a2,a1,80000766 <uvmdealloc+0x26>
    80000750:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000752:	6785                	lui	a5,0x1
    80000754:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000756:	00f60733          	add	a4,a2,a5
    8000075a:	76fd                	lui	a3,0xfffff
    8000075c:	8f75                	and	a4,a4,a3
    8000075e:	97ae                	add	a5,a5,a1
    80000760:	8ff5                	and	a5,a5,a3
    80000762:	00f76863          	bltu	a4,a5,80000772 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000766:	8526                	mv	a0,s1
    80000768:	60e2                	ld	ra,24(sp)
    8000076a:	6442                	ld	s0,16(sp)
    8000076c:	64a2                	ld	s1,8(sp)
    8000076e:	6105                	addi	sp,sp,32
    80000770:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000772:	8f99                	sub	a5,a5,a4
    80000774:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000776:	4685                	li	a3,1
    80000778:	0007861b          	sext.w	a2,a5
    8000077c:	85ba                	mv	a1,a4
    8000077e:	f1dff0ef          	jal	8000069a <uvmunmap>
    80000782:	b7d5                	j	80000766 <uvmdealloc+0x26>

0000000080000784 <uvmalloc>:
  if(newsz < oldsz)
    80000784:	08b66f63          	bltu	a2,a1,80000822 <uvmalloc+0x9e>
{
    80000788:	7139                	addi	sp,sp,-64
    8000078a:	fc06                	sd	ra,56(sp)
    8000078c:	f822                	sd	s0,48(sp)
    8000078e:	ec4e                	sd	s3,24(sp)
    80000790:	e852                	sd	s4,16(sp)
    80000792:	e456                	sd	s5,8(sp)
    80000794:	0080                	addi	s0,sp,64
    80000796:	8aaa                	mv	s5,a0
    80000798:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000079a:	6785                	lui	a5,0x1
    8000079c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000079e:	95be                	add	a1,a1,a5
    800007a0:	77fd                	lui	a5,0xfffff
    800007a2:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    800007a6:	08c9f063          	bgeu	s3,a2,80000826 <uvmalloc+0xa2>
    800007aa:	f426                	sd	s1,40(sp)
    800007ac:	f04a                	sd	s2,32(sp)
    800007ae:	e05a                	sd	s6,0(sp)
    800007b0:	894e                	mv	s2,s3
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007b2:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800007b6:	949ff0ef          	jal	800000fe <kalloc>
    800007ba:	84aa                	mv	s1,a0
    if(mem == 0){
    800007bc:	c515                	beqz	a0,800007e8 <uvmalloc+0x64>
    memset(mem, 0, sz);
    800007be:	6605                	lui	a2,0x1
    800007c0:	4581                	li	a1,0
    800007c2:	98dff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007c6:	875a                	mv	a4,s6
    800007c8:	86a6                	mv	a3,s1
    800007ca:	6605                	lui	a2,0x1
    800007cc:	85ca                	mv	a1,s2
    800007ce:	8556                	mv	a0,s5
    800007d0:	cd7ff0ef          	jal	800004a6 <mappages>
    800007d4:	e915                	bnez	a0,80000808 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += sz){
    800007d6:	6785                	lui	a5,0x1
    800007d8:	993e                	add	s2,s2,a5
    800007da:	fd496ee3          	bltu	s2,s4,800007b6 <uvmalloc+0x32>
  return newsz;
    800007de:	8552                	mv	a0,s4
    800007e0:	74a2                	ld	s1,40(sp)
    800007e2:	7902                	ld	s2,32(sp)
    800007e4:	6b02                	ld	s6,0(sp)
    800007e6:	a811                	j	800007fa <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800007e8:	864e                	mv	a2,s3
    800007ea:	85ca                	mv	a1,s2
    800007ec:	8556                	mv	a0,s5
    800007ee:	f53ff0ef          	jal	80000740 <uvmdealloc>
      return 0;
    800007f2:	4501                	li	a0,0
    800007f4:	74a2                	ld	s1,40(sp)
    800007f6:	7902                	ld	s2,32(sp)
    800007f8:	6b02                	ld	s6,0(sp)
}
    800007fa:	70e2                	ld	ra,56(sp)
    800007fc:	7442                	ld	s0,48(sp)
    800007fe:	69e2                	ld	s3,24(sp)
    80000800:	6a42                	ld	s4,16(sp)
    80000802:	6aa2                	ld	s5,8(sp)
    80000804:	6121                	addi	sp,sp,64
    80000806:	8082                	ret
      kfree(mem);
    80000808:	8526                	mv	a0,s1
    8000080a:	813ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000080e:	864e                	mv	a2,s3
    80000810:	85ca                	mv	a1,s2
    80000812:	8556                	mv	a0,s5
    80000814:	f2dff0ef          	jal	80000740 <uvmdealloc>
      return 0;
    80000818:	4501                	li	a0,0
    8000081a:	74a2                	ld	s1,40(sp)
    8000081c:	7902                	ld	s2,32(sp)
    8000081e:	6b02                	ld	s6,0(sp)
    80000820:	bfe9                	j	800007fa <uvmalloc+0x76>
    return oldsz;
    80000822:	852e                	mv	a0,a1
}
    80000824:	8082                	ret
  return newsz;
    80000826:	8532                	mv	a0,a2
    80000828:	bfc9                	j	800007fa <uvmalloc+0x76>

000000008000082a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000082a:	7179                	addi	sp,sp,-48
    8000082c:	f406                	sd	ra,40(sp)
    8000082e:	f022                	sd	s0,32(sp)
    80000830:	ec26                	sd	s1,24(sp)
    80000832:	e84a                	sd	s2,16(sp)
    80000834:	e44e                	sd	s3,8(sp)
    80000836:	e052                	sd	s4,0(sp)
    80000838:	1800                	addi	s0,sp,48
    8000083a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000083c:	84aa                	mv	s1,a0
    8000083e:	6905                	lui	s2,0x1
    80000840:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000842:	4985                	li	s3,1
    80000844:	a819                	j	8000085a <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000846:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000848:	00c79513          	slli	a0,a5,0xc
    8000084c:	fdfff0ef          	jal	8000082a <freewalk>
      pagetable[i] = 0;
    80000850:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000854:	04a1                	addi	s1,s1,8
    80000856:	01248f63          	beq	s1,s2,80000874 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8000085a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000085c:	00f7f713          	andi	a4,a5,15
    80000860:	ff3703e3          	beq	a4,s3,80000846 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000864:	8b85                	andi	a5,a5,1
    80000866:	d7fd                	beqz	a5,80000854 <freewalk+0x2a>
      // backtrace();
      panic("freewalk: leaf");
    80000868:	00008517          	auipc	a0,0x8
    8000086c:	88850513          	addi	a0,a0,-1912 # 800080f0 <etext+0xf0>
    80000870:	57b050ef          	jal	800065ea <panic>
    }
  }
  kfree((void*)pagetable);
    80000874:	8552                	mv	a0,s4
    80000876:	fa6ff0ef          	jal	8000001c <kfree>
}
    8000087a:	70a2                	ld	ra,40(sp)
    8000087c:	7402                	ld	s0,32(sp)
    8000087e:	64e2                	ld	s1,24(sp)
    80000880:	6942                	ld	s2,16(sp)
    80000882:	69a2                	ld	s3,8(sp)
    80000884:	6a02                	ld	s4,0(sp)
    80000886:	6145                	addi	sp,sp,48
    80000888:	8082                	ret

000000008000088a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000088a:	1101                	addi	sp,sp,-32
    8000088c:	ec06                	sd	ra,24(sp)
    8000088e:	e822                	sd	s0,16(sp)
    80000890:	e426                	sd	s1,8(sp)
    80000892:	1000                	addi	s0,sp,32
    80000894:	84aa                	mv	s1,a0
  if(sz > 0)
    80000896:	e989                	bnez	a1,800008a8 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000898:	8526                	mv	a0,s1
    8000089a:	f91ff0ef          	jal	8000082a <freewalk>
}
    8000089e:	60e2                	ld	ra,24(sp)
    800008a0:	6442                	ld	s0,16(sp)
    800008a2:	64a2                	ld	s1,8(sp)
    800008a4:	6105                	addi	sp,sp,32
    800008a6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800008a8:	6785                	lui	a5,0x1
    800008aa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008ac:	95be                	add	a1,a1,a5
    800008ae:	4685                	li	a3,1
    800008b0:	00c5d613          	srli	a2,a1,0xc
    800008b4:	4581                	li	a1,0
    800008b6:	de5ff0ef          	jal	8000069a <uvmunmap>
    800008ba:	bff9                	j	80000898 <uvmfree+0xe>

00000000800008bc <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc = PGSIZE;

  for(i = 0; i < sz; i += szinc){
    800008bc:	ce49                	beqz	a2,80000956 <uvmcopy+0x9a>
{
    800008be:	715d                	addi	sp,sp,-80
    800008c0:	e486                	sd	ra,72(sp)
    800008c2:	e0a2                	sd	s0,64(sp)
    800008c4:	fc26                	sd	s1,56(sp)
    800008c6:	f84a                	sd	s2,48(sp)
    800008c8:	f44e                	sd	s3,40(sp)
    800008ca:	f052                	sd	s4,32(sp)
    800008cc:	ec56                	sd	s5,24(sp)
    800008ce:	e85a                	sd	s6,16(sp)
    800008d0:	e45e                	sd	s7,8(sp)
    800008d2:	0880                	addi	s0,sp,80
    800008d4:	8aaa                	mv	s5,a0
    800008d6:	8b2e                	mv	s6,a1
    800008d8:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += szinc){
    800008da:	4481                	li	s1,0
    800008dc:	a029                	j	800008e6 <uvmcopy+0x2a>
    800008de:	6785                	lui	a5,0x1
    800008e0:	94be                	add	s1,s1,a5
    800008e2:	0544fe63          	bgeu	s1,s4,8000093e <uvmcopy+0x82>
    if((pte = walk(old, i, 0)) == 0)
    800008e6:	4601                	li	a2,0
    800008e8:	85a6                	mv	a1,s1
    800008ea:	8556                	mv	a0,s5
    800008ec:	ae3ff0ef          	jal	800003ce <walk>
    800008f0:	d57d                	beqz	a0,800008de <uvmcopy+0x22>
      continue;
    if((*pte & PTE_V) == 0) {
    800008f2:	6118                	ld	a4,0(a0)
    800008f4:	00177793          	andi	a5,a4,1
    800008f8:	d3fd                	beqz	a5,800008de <uvmcopy+0x22>
      continue;
    }
    szinc = PGSIZE;
    pa = PTE2PA(*pte);
    800008fa:	00a75593          	srli	a1,a4,0xa
    800008fe:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000902:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    80000906:	ff8ff0ef          	jal	800000fe <kalloc>
    8000090a:	89aa                	mv	s3,a0
    8000090c:	c105                	beqz	a0,8000092c <uvmcopy+0x70>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000090e:	6605                	lui	a2,0x1
    80000910:	85de                	mv	a1,s7
    80000912:	899ff0ef          	jal	800001aa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000916:	874a                	mv	a4,s2
    80000918:	86ce                	mv	a3,s3
    8000091a:	6605                	lui	a2,0x1
    8000091c:	85a6                	mv	a1,s1
    8000091e:	855a                	mv	a0,s6
    80000920:	b87ff0ef          	jal	800004a6 <mappages>
    80000924:	dd4d                	beqz	a0,800008de <uvmcopy+0x22>
      kfree(mem);
    80000926:	854e                	mv	a0,s3
    80000928:	ef4ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000092c:	4685                	li	a3,1
    8000092e:	00c4d613          	srli	a2,s1,0xc
    80000932:	4581                	li	a1,0
    80000934:	855a                	mv	a0,s6
    80000936:	d65ff0ef          	jal	8000069a <uvmunmap>
  return -1;
    8000093a:	557d                	li	a0,-1
    8000093c:	a011                	j	80000940 <uvmcopy+0x84>
  return 0;
    8000093e:	4501                	li	a0,0
}
    80000940:	60a6                	ld	ra,72(sp)
    80000942:	6406                	ld	s0,64(sp)
    80000944:	74e2                	ld	s1,56(sp)
    80000946:	7942                	ld	s2,48(sp)
    80000948:	79a2                	ld	s3,40(sp)
    8000094a:	7a02                	ld	s4,32(sp)
    8000094c:	6ae2                	ld	s5,24(sp)
    8000094e:	6b42                	ld	s6,16(sp)
    80000950:	6ba2                	ld	s7,8(sp)
    80000952:	6161                	addi	sp,sp,80
    80000954:	8082                	ret
  return 0;
    80000956:	4501                	li	a0,0
}
    80000958:	8082                	ret

000000008000095a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000095a:	1141                	addi	sp,sp,-16
    8000095c:	e406                	sd	ra,8(sp)
    8000095e:	e022                	sd	s0,0(sp)
    80000960:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000962:	4601                	li	a2,0
    80000964:	a6bff0ef          	jal	800003ce <walk>
  if(pte == 0)
    80000968:	c901                	beqz	a0,80000978 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000096a:	611c                	ld	a5,0(a0)
    8000096c:	9bbd                	andi	a5,a5,-17
    8000096e:	e11c                	sd	a5,0(a0)
}
    80000970:	60a2                	ld	ra,8(sp)
    80000972:	6402                	ld	s0,0(sp)
    80000974:	0141                	addi	sp,sp,16
    80000976:	8082                	ret
    panic("uvmclear");
    80000978:	00007517          	auipc	a0,0x7
    8000097c:	78850513          	addi	a0,a0,1928 # 80008100 <etext+0x100>
    80000980:	46b050ef          	jal	800065ea <panic>

0000000080000984 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000984:	c6dd                	beqz	a3,80000a32 <copyinstr+0xae>
{
    80000986:	715d                	addi	sp,sp,-80
    80000988:	e486                	sd	ra,72(sp)
    8000098a:	e0a2                	sd	s0,64(sp)
    8000098c:	fc26                	sd	s1,56(sp)
    8000098e:	f84a                	sd	s2,48(sp)
    80000990:	f44e                	sd	s3,40(sp)
    80000992:	f052                	sd	s4,32(sp)
    80000994:	ec56                	sd	s5,24(sp)
    80000996:	e85a                	sd	s6,16(sp)
    80000998:	e45e                	sd	s7,8(sp)
    8000099a:	0880                	addi	s0,sp,80
    8000099c:	8a2a                	mv	s4,a0
    8000099e:	8b2e                	mv	s6,a1
    800009a0:	8bb2                	mv	s7,a2
    800009a2:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800009a4:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800009a6:	6985                	lui	s3,0x1
    800009a8:	a825                	j	800009e0 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800009aa:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800009ae:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800009b0:	37fd                	addiw	a5,a5,-1
    800009b2:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800009b6:	60a6                	ld	ra,72(sp)
    800009b8:	6406                	ld	s0,64(sp)
    800009ba:	74e2                	ld	s1,56(sp)
    800009bc:	7942                	ld	s2,48(sp)
    800009be:	79a2                	ld	s3,40(sp)
    800009c0:	7a02                	ld	s4,32(sp)
    800009c2:	6ae2                	ld	s5,24(sp)
    800009c4:	6b42                	ld	s6,16(sp)
    800009c6:	6ba2                	ld	s7,8(sp)
    800009c8:	6161                	addi	sp,sp,80
    800009ca:	8082                	ret
    800009cc:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    800009d0:	9742                	add	a4,a4,a6
      --max;
    800009d2:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    800009d6:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    800009da:	04e58463          	beq	a1,a4,80000a22 <copyinstr+0x9e>
{
    800009de:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    800009e0:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800009e4:	85a6                	mv	a1,s1
    800009e6:	8552                	mv	a0,s4
    800009e8:	a81ff0ef          	jal	80000468 <walkaddr>
    if(pa0 == 0)
    800009ec:	cd0d                	beqz	a0,80000a26 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800009ee:	417486b3          	sub	a3,s1,s7
    800009f2:	96ce                	add	a3,a3,s3
    if(n > max)
    800009f4:	00d97363          	bgeu	s2,a3,800009fa <copyinstr+0x76>
    800009f8:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    800009fa:	955e                	add	a0,a0,s7
    800009fc:	8d05                	sub	a0,a0,s1
    while(n > 0){
    800009fe:	c695                	beqz	a3,80000a2a <copyinstr+0xa6>
    80000a00:	87da                	mv	a5,s6
    80000a02:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000a04:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000a08:	96da                	add	a3,a3,s6
    80000a0a:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000a0c:	00f60733          	add	a4,a2,a5
    80000a10:	00074703          	lbu	a4,0(a4)
    80000a14:	db59                	beqz	a4,800009aa <copyinstr+0x26>
        *dst = *p;
    80000a16:	00e78023          	sb	a4,0(a5)
      dst++;
    80000a1a:	0785                	addi	a5,a5,1
    while(n > 0){
    80000a1c:	fed797e3          	bne	a5,a3,80000a0a <copyinstr+0x86>
    80000a20:	b775                	j	800009cc <copyinstr+0x48>
    80000a22:	4781                	li	a5,0
    80000a24:	b771                	j	800009b0 <copyinstr+0x2c>
      return -1;
    80000a26:	557d                	li	a0,-1
    80000a28:	b779                	j	800009b6 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000a2a:	6b85                	lui	s7,0x1
    80000a2c:	9ba6                	add	s7,s7,s1
    80000a2e:	87da                	mv	a5,s6
    80000a30:	b77d                	j	800009de <copyinstr+0x5a>
  int got_null = 0;
    80000a32:	4781                	li	a5,0
  if(got_null){
    80000a34:	37fd                	addiw	a5,a5,-1
    80000a36:	0007851b          	sext.w	a0,a5
}
    80000a3a:	8082                	ret

0000000080000a3c <ismapped>:
  }
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va) {
    80000a3c:	1141                	addi	sp,sp,-16
    80000a3e:	e406                	sd	ra,8(sp)
    80000a40:	e022                	sd	s0,0(sp)
    80000a42:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80000a44:	4601                	li	a2,0
    80000a46:	989ff0ef          	jal	800003ce <walk>
  if (pte == 0) {
    80000a4a:	c519                	beqz	a0,80000a58 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    80000a4c:	6108                	ld	a0,0(a0)
    80000a4e:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000a50:	60a2                	ld	ra,8(sp)
    80000a52:	6402                	ld	s0,0(sp)
    80000a54:	0141                	addi	sp,sp,16
    80000a56:	8082                	ret
    return 0;
    80000a58:	4501                	li	a0,0
    80000a5a:	bfdd                	j	80000a50 <ismapped+0x14>

0000000080000a5c <vmfault>:
{
    80000a5c:	7179                	addi	sp,sp,-48
    80000a5e:	f406                	sd	ra,40(sp)
    80000a60:	f022                	sd	s0,32(sp)
    80000a62:	ec26                	sd	s1,24(sp)
    80000a64:	e44e                	sd	s3,8(sp)
    80000a66:	1800                	addi	s0,sp,48
    80000a68:	89aa                	mv	s3,a0
    80000a6a:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80000a6c:	36a000ef          	jal	80000dd6 <myproc>
  if (va >= p->sz)
    80000a70:	653c                	ld	a5,72(a0)
    80000a72:	00f4ea63          	bltu	s1,a5,80000a86 <vmfault+0x2a>
    return 0;
    80000a76:	4981                	li	s3,0
}
    80000a78:	854e                	mv	a0,s3
    80000a7a:	70a2                	ld	ra,40(sp)
    80000a7c:	7402                	ld	s0,32(sp)
    80000a7e:	64e2                	ld	s1,24(sp)
    80000a80:	69a2                	ld	s3,8(sp)
    80000a82:	6145                	addi	sp,sp,48
    80000a84:	8082                	ret
    80000a86:	e84a                	sd	s2,16(sp)
    80000a88:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    80000a8a:	77fd                	lui	a5,0xfffff
    80000a8c:	8cfd                	and	s1,s1,a5
  if(ismapped(pagetable, va)) {
    80000a8e:	85a6                	mv	a1,s1
    80000a90:	854e                	mv	a0,s3
    80000a92:	fabff0ef          	jal	80000a3c <ismapped>
    return 0;
    80000a96:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80000a98:	c119                	beqz	a0,80000a9e <vmfault+0x42>
    80000a9a:	6942                	ld	s2,16(sp)
    80000a9c:	bff1                	j	80000a78 <vmfault+0x1c>
    80000a9e:	e052                	sd	s4,0(sp)
  mem = (uint64) kalloc();
    80000aa0:	e5eff0ef          	jal	800000fe <kalloc>
    80000aa4:	8a2a                	mv	s4,a0
  if(mem == 0)
    80000aa6:	c90d                	beqz	a0,80000ad8 <vmfault+0x7c>
  mem = (uint64) kalloc();
    80000aa8:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80000aaa:	6605                	lui	a2,0x1
    80000aac:	4581                	li	a1,0
    80000aae:	ea0ff0ef          	jal	8000014e <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000ab2:	4759                	li	a4,22
    80000ab4:	86d2                	mv	a3,s4
    80000ab6:	6605                	lui	a2,0x1
    80000ab8:	85a6                	mv	a1,s1
    80000aba:	05093503          	ld	a0,80(s2)
    80000abe:	9e9ff0ef          	jal	800004a6 <mappages>
    80000ac2:	e501                	bnez	a0,80000aca <vmfault+0x6e>
    80000ac4:	6942                	ld	s2,16(sp)
    80000ac6:	6a02                	ld	s4,0(sp)
    80000ac8:	bf45                	j	80000a78 <vmfault+0x1c>
    kfree((void *)mem);
    80000aca:	8552                	mv	a0,s4
    80000acc:	d50ff0ef          	jal	8000001c <kfree>
    return 0;
    80000ad0:	4981                	li	s3,0
    80000ad2:	6942                	ld	s2,16(sp)
    80000ad4:	6a02                	ld	s4,0(sp)
    80000ad6:	b74d                	j	80000a78 <vmfault+0x1c>
    80000ad8:	6942                	ld	s2,16(sp)
    80000ada:	6a02                	ld	s4,0(sp)
    80000adc:	bf71                	j	80000a78 <vmfault+0x1c>

0000000080000ade <copyout>:
  while(len > 0){
    80000ade:	c2d5                	beqz	a3,80000b82 <copyout+0xa4>
{
    80000ae0:	711d                	addi	sp,sp,-96
    80000ae2:	ec86                	sd	ra,88(sp)
    80000ae4:	e8a2                	sd	s0,80(sp)
    80000ae6:	e4a6                	sd	s1,72(sp)
    80000ae8:	f852                	sd	s4,48(sp)
    80000aea:	f456                	sd	s5,40(sp)
    80000aec:	f05a                	sd	s6,32(sp)
    80000aee:	ec5e                	sd	s7,24(sp)
    80000af0:	1080                	addi	s0,sp,96
    80000af2:	8baa                	mv	s7,a0
    80000af4:	8aae                	mv	s5,a1
    80000af6:	8b32                	mv	s6,a2
    80000af8:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000afa:	74fd                	lui	s1,0xfffff
    80000afc:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000afe:	57fd                	li	a5,-1
    80000b00:	83e9                	srli	a5,a5,0x1a
    80000b02:	0897e263          	bltu	a5,s1,80000b86 <copyout+0xa8>
    80000b06:	e0ca                	sd	s2,64(sp)
    80000b08:	fc4e                	sd	s3,56(sp)
    80000b0a:	e862                	sd	s8,16(sp)
    80000b0c:	e466                	sd	s9,8(sp)
    80000b0e:	e06a                	sd	s10,0(sp)
    80000b10:	6c85                	lui	s9,0x1
    80000b12:	8c3e                	mv	s8,a5
    80000b14:	a015                	j	80000b38 <copyout+0x5a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b16:	409a8533          	sub	a0,s5,s1
    80000b1a:	0009861b          	sext.w	a2,s3
    80000b1e:	85da                	mv	a1,s6
    80000b20:	954a                	add	a0,a0,s2
    80000b22:	e88ff0ef          	jal	800001aa <memmove>
    len -= n;
    80000b26:	413a0a33          	sub	s4,s4,s3
    src += n;
    80000b2a:	9b4e                	add	s6,s6,s3
  while(len > 0){
    80000b2c:	040a0463          	beqz	s4,80000b74 <copyout+0x96>
    if (va0 >= MAXVA)
    80000b30:	05ac6d63          	bltu	s8,s10,80000b8a <copyout+0xac>
    80000b34:	84ea                	mv	s1,s10
    80000b36:	8aea                	mv	s5,s10
    pa0 = walkaddr(pagetable, va0);
    80000b38:	85a6                	mv	a1,s1
    80000b3a:	855e                	mv	a0,s7
    80000b3c:	92dff0ef          	jal	80000468 <walkaddr>
    80000b40:	892a                	mv	s2,a0
    if(pa0 == 0) {
    80000b42:	e901                	bnez	a0,80000b52 <copyout+0x74>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000b44:	4601                	li	a2,0
    80000b46:	85a6                	mv	a1,s1
    80000b48:	855e                	mv	a0,s7
    80000b4a:	f13ff0ef          	jal	80000a5c <vmfault>
    80000b4e:	892a                	mv	s2,a0
    80000b50:	c521                	beqz	a0,80000b98 <copyout+0xba>
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000b52:	4601                	li	a2,0
    80000b54:	85a6                	mv	a1,s1
    80000b56:	855e                	mv	a0,s7
    80000b58:	877ff0ef          	jal	800003ce <walk>
    80000b5c:	c529                	beqz	a0,80000ba6 <copyout+0xc8>
    if((*pte & PTE_W) == 0)
    80000b5e:	611c                	ld	a5,0(a0)
    80000b60:	8b91                	andi	a5,a5,4
    80000b62:	c3ad                	beqz	a5,80000bc4 <copyout+0xe6>
    n = PGSIZE - (dstva - va0);
    80000b64:	01948d33          	add	s10,s1,s9
    80000b68:	415d09b3          	sub	s3,s10,s5
    if(n > len)
    80000b6c:	fb3a75e3          	bgeu	s4,s3,80000b16 <copyout+0x38>
    80000b70:	89d2                	mv	s3,s4
    80000b72:	b755                	j	80000b16 <copyout+0x38>
  return 0;
    80000b74:	4501                	li	a0,0
    80000b76:	6906                	ld	s2,64(sp)
    80000b78:	79e2                	ld	s3,56(sp)
    80000b7a:	6c42                	ld	s8,16(sp)
    80000b7c:	6ca2                	ld	s9,8(sp)
    80000b7e:	6d02                	ld	s10,0(sp)
    80000b80:	a80d                	j	80000bb2 <copyout+0xd4>
    80000b82:	4501                	li	a0,0
}
    80000b84:	8082                	ret
      return -1;
    80000b86:	557d                	li	a0,-1
    80000b88:	a02d                	j	80000bb2 <copyout+0xd4>
    80000b8a:	557d                	li	a0,-1
    80000b8c:	6906                	ld	s2,64(sp)
    80000b8e:	79e2                	ld	s3,56(sp)
    80000b90:	6c42                	ld	s8,16(sp)
    80000b92:	6ca2                	ld	s9,8(sp)
    80000b94:	6d02                	ld	s10,0(sp)
    80000b96:	a831                	j	80000bb2 <copyout+0xd4>
        return -1;
    80000b98:	557d                	li	a0,-1
    80000b9a:	6906                	ld	s2,64(sp)
    80000b9c:	79e2                	ld	s3,56(sp)
    80000b9e:	6c42                	ld	s8,16(sp)
    80000ba0:	6ca2                	ld	s9,8(sp)
    80000ba2:	6d02                	ld	s10,0(sp)
    80000ba4:	a039                	j	80000bb2 <copyout+0xd4>
      return -1;
    80000ba6:	557d                	li	a0,-1
    80000ba8:	6906                	ld	s2,64(sp)
    80000baa:	79e2                	ld	s3,56(sp)
    80000bac:	6c42                	ld	s8,16(sp)
    80000bae:	6ca2                	ld	s9,8(sp)
    80000bb0:	6d02                	ld	s10,0(sp)
}
    80000bb2:	60e6                	ld	ra,88(sp)
    80000bb4:	6446                	ld	s0,80(sp)
    80000bb6:	64a6                	ld	s1,72(sp)
    80000bb8:	7a42                	ld	s4,48(sp)
    80000bba:	7aa2                	ld	s5,40(sp)
    80000bbc:	7b02                	ld	s6,32(sp)
    80000bbe:	6be2                	ld	s7,24(sp)
    80000bc0:	6125                	addi	sp,sp,96
    80000bc2:	8082                	ret
      return -1;
    80000bc4:	557d                	li	a0,-1
    80000bc6:	6906                	ld	s2,64(sp)
    80000bc8:	79e2                	ld	s3,56(sp)
    80000bca:	6c42                	ld	s8,16(sp)
    80000bcc:	6ca2                	ld	s9,8(sp)
    80000bce:	6d02                	ld	s10,0(sp)
    80000bd0:	b7cd                	j	80000bb2 <copyout+0xd4>

0000000080000bd2 <copyin>:
  while(len > 0){
    80000bd2:	c6c9                	beqz	a3,80000c5c <copyin+0x8a>
{
    80000bd4:	715d                	addi	sp,sp,-80
    80000bd6:	e486                	sd	ra,72(sp)
    80000bd8:	e0a2                	sd	s0,64(sp)
    80000bda:	fc26                	sd	s1,56(sp)
    80000bdc:	f84a                	sd	s2,48(sp)
    80000bde:	f44e                	sd	s3,40(sp)
    80000be0:	f052                	sd	s4,32(sp)
    80000be2:	ec56                	sd	s5,24(sp)
    80000be4:	e85a                	sd	s6,16(sp)
    80000be6:	e45e                	sd	s7,8(sp)
    80000be8:	e062                	sd	s8,0(sp)
    80000bea:	0880                	addi	s0,sp,80
    80000bec:	8baa                	mv	s7,a0
    80000bee:	8aae                	mv	s5,a1
    80000bf0:	8932                	mv	s2,a2
    80000bf2:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000bf4:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000bf6:	6b05                	lui	s6,0x1
    80000bf8:	a035                	j	80000c24 <copyin+0x52>
    80000bfa:	412984b3          	sub	s1,s3,s2
    80000bfe:	94da                	add	s1,s1,s6
    if(n > len)
    80000c00:	009a7363          	bgeu	s4,s1,80000c06 <copyin+0x34>
    80000c04:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c06:	413905b3          	sub	a1,s2,s3
    80000c0a:	0004861b          	sext.w	a2,s1
    80000c0e:	95aa                	add	a1,a1,a0
    80000c10:	8556                	mv	a0,s5
    80000c12:	d98ff0ef          	jal	800001aa <memmove>
    len -= n;
    80000c16:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000c1a:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000c1c:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000c20:	020a0163          	beqz	s4,80000c42 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000c24:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000c28:	85ce                	mv	a1,s3
    80000c2a:	855e                	mv	a0,s7
    80000c2c:	83dff0ef          	jal	80000468 <walkaddr>
    if(pa0 == 0) {
    80000c30:	f569                	bnez	a0,80000bfa <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000c32:	4601                	li	a2,0
    80000c34:	85ce                	mv	a1,s3
    80000c36:	855e                	mv	a0,s7
    80000c38:	e25ff0ef          	jal	80000a5c <vmfault>
    80000c3c:	fd5d                	bnez	a0,80000bfa <copyin+0x28>
        return -1;
    80000c3e:	557d                	li	a0,-1
    80000c40:	a011                	j	80000c44 <copyin+0x72>
  return 0;
    80000c42:	4501                	li	a0,0
}
    80000c44:	60a6                	ld	ra,72(sp)
    80000c46:	6406                	ld	s0,64(sp)
    80000c48:	74e2                	ld	s1,56(sp)
    80000c4a:	7942                	ld	s2,48(sp)
    80000c4c:	79a2                	ld	s3,40(sp)
    80000c4e:	7a02                	ld	s4,32(sp)
    80000c50:	6ae2                	ld	s5,24(sp)
    80000c52:	6b42                	ld	s6,16(sp)
    80000c54:	6ba2                	ld	s7,8(sp)
    80000c56:	6c02                	ld	s8,0(sp)
    80000c58:	6161                	addi	sp,sp,80
    80000c5a:	8082                	ret
  return 0;
    80000c5c:	4501                	li	a0,0
}
    80000c5e:	8082                	ret

0000000080000c60 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c60:	7139                	addi	sp,sp,-64
    80000c62:	fc06                	sd	ra,56(sp)
    80000c64:	f822                	sd	s0,48(sp)
    80000c66:	f426                	sd	s1,40(sp)
    80000c68:	f04a                	sd	s2,32(sp)
    80000c6a:	ec4e                	sd	s3,24(sp)
    80000c6c:	e852                	sd	s4,16(sp)
    80000c6e:	e456                	sd	s5,8(sp)
    80000c70:	e05a                	sd	s6,0(sp)
    80000c72:	0080                	addi	s0,sp,64
    80000c74:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c76:	0000b497          	auipc	s1,0xb
    80000c7a:	11a48493          	addi	s1,s1,282 # 8000bd90 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c7e:	8b26                	mv	s6,s1
    80000c80:	04fa5937          	lui	s2,0x4fa5
    80000c84:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000c88:	0932                	slli	s2,s2,0xc
    80000c8a:	fa590913          	addi	s2,s2,-91
    80000c8e:	0932                	slli	s2,s2,0xc
    80000c90:	fa590913          	addi	s2,s2,-91
    80000c94:	0932                	slli	s2,s2,0xc
    80000c96:	fa590913          	addi	s2,s2,-91
    80000c9a:	010009b7          	lui	s3,0x1000
    80000c9e:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000ca0:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ca2:	00011a97          	auipc	s5,0x11
    80000ca6:	aeea8a93          	addi	s5,s5,-1298 # 80011790 <tickslock>
    char *pa = kalloc();
    80000caa:	c54ff0ef          	jal	800000fe <kalloc>
    80000cae:	862a                	mv	a2,a0
    if(pa == 0)
    80000cb0:	cd0d                	beqz	a0,80000cea <proc_mapstacks+0x8a>
    uint64 va = KSTACK((int) (p - proc));
    80000cb2:	416485b3          	sub	a1,s1,s6
    80000cb6:	858d                	srai	a1,a1,0x3
    80000cb8:	032585b3          	mul	a1,a1,s2
    80000cbc:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000cc0:	4719                	li	a4,6
    80000cc2:	6685                	lui	a3,0x1
    80000cc4:	40b985b3          	sub	a1,s3,a1
    80000cc8:	8552                	mv	a0,s4
    80000cca:	88dff0ef          	jal	80000556 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cce:	16848493          	addi	s1,s1,360
    80000cd2:	fd549ce3          	bne	s1,s5,80000caa <proc_mapstacks+0x4a>
  }
}
    80000cd6:	70e2                	ld	ra,56(sp)
    80000cd8:	7442                	ld	s0,48(sp)
    80000cda:	74a2                	ld	s1,40(sp)
    80000cdc:	7902                	ld	s2,32(sp)
    80000cde:	69e2                	ld	s3,24(sp)
    80000ce0:	6a42                	ld	s4,16(sp)
    80000ce2:	6aa2                	ld	s5,8(sp)
    80000ce4:	6b02                	ld	s6,0(sp)
    80000ce6:	6121                	addi	sp,sp,64
    80000ce8:	8082                	ret
      panic("kalloc");
    80000cea:	00007517          	auipc	a0,0x7
    80000cee:	42650513          	addi	a0,a0,1062 # 80008110 <etext+0x110>
    80000cf2:	0f9050ef          	jal	800065ea <panic>

0000000080000cf6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000cf6:	7139                	addi	sp,sp,-64
    80000cf8:	fc06                	sd	ra,56(sp)
    80000cfa:	f822                	sd	s0,48(sp)
    80000cfc:	f426                	sd	s1,40(sp)
    80000cfe:	f04a                	sd	s2,32(sp)
    80000d00:	ec4e                	sd	s3,24(sp)
    80000d02:	e852                	sd	s4,16(sp)
    80000d04:	e456                	sd	s5,8(sp)
    80000d06:	e05a                	sd	s6,0(sp)
    80000d08:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d0a:	00007597          	auipc	a1,0x7
    80000d0e:	40e58593          	addi	a1,a1,1038 # 80008118 <etext+0x118>
    80000d12:	0000b517          	auipc	a0,0xb
    80000d16:	c4e50513          	addi	a0,a0,-946 # 8000b960 <pid_lock>
    80000d1a:	30d050ef          	jal	80006826 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d1e:	00007597          	auipc	a1,0x7
    80000d22:	40258593          	addi	a1,a1,1026 # 80008120 <etext+0x120>
    80000d26:	0000b517          	auipc	a0,0xb
    80000d2a:	c5250513          	addi	a0,a0,-942 # 8000b978 <wait_lock>
    80000d2e:	2f9050ef          	jal	80006826 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d32:	0000b497          	auipc	s1,0xb
    80000d36:	05e48493          	addi	s1,s1,94 # 8000bd90 <proc>
      initlock(&p->lock, "proc");
    80000d3a:	00007b17          	auipc	s6,0x7
    80000d3e:	3f6b0b13          	addi	s6,s6,1014 # 80008130 <etext+0x130>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d42:	8aa6                	mv	s5,s1
    80000d44:	04fa5937          	lui	s2,0x4fa5
    80000d48:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d4c:	0932                	slli	s2,s2,0xc
    80000d4e:	fa590913          	addi	s2,s2,-91
    80000d52:	0932                	slli	s2,s2,0xc
    80000d54:	fa590913          	addi	s2,s2,-91
    80000d58:	0932                	slli	s2,s2,0xc
    80000d5a:	fa590913          	addi	s2,s2,-91
    80000d5e:	010009b7          	lui	s3,0x1000
    80000d62:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000d64:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d66:	00011a17          	auipc	s4,0x11
    80000d6a:	a2aa0a13          	addi	s4,s4,-1494 # 80011790 <tickslock>
      initlock(&p->lock, "proc");
    80000d6e:	85da                	mv	a1,s6
    80000d70:	8526                	mv	a0,s1
    80000d72:	2b5050ef          	jal	80006826 <initlock>
      p->state = UNUSED;
    80000d76:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d7a:	415487b3          	sub	a5,s1,s5
    80000d7e:	878d                	srai	a5,a5,0x3
    80000d80:	032787b3          	mul	a5,a5,s2
    80000d84:	00d7979b          	slliw	a5,a5,0xd
    80000d88:	40f987b3          	sub	a5,s3,a5
    80000d8c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8e:	16848493          	addi	s1,s1,360
    80000d92:	fd449ee3          	bne	s1,s4,80000d6e <procinit+0x78>
  }
}
    80000d96:	70e2                	ld	ra,56(sp)
    80000d98:	7442                	ld	s0,48(sp)
    80000d9a:	74a2                	ld	s1,40(sp)
    80000d9c:	7902                	ld	s2,32(sp)
    80000d9e:	69e2                	ld	s3,24(sp)
    80000da0:	6a42                	ld	s4,16(sp)
    80000da2:	6aa2                	ld	s5,8(sp)
    80000da4:	6b02                	ld	s6,0(sp)
    80000da6:	6121                	addi	sp,sp,64
    80000da8:	8082                	ret

0000000080000daa <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000daa:	1141                	addi	sp,sp,-16
    80000dac:	e422                	sd	s0,8(sp)
    80000dae:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000db0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000db2:	2501                	sext.w	a0,a0
    80000db4:	6422                	ld	s0,8(sp)
    80000db6:	0141                	addi	sp,sp,16
    80000db8:	8082                	ret

0000000080000dba <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000dba:	1141                	addi	sp,sp,-16
    80000dbc:	e422                	sd	s0,8(sp)
    80000dbe:	0800                	addi	s0,sp,16
    80000dc0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000dc2:	2781                	sext.w	a5,a5
    80000dc4:	079e                	slli	a5,a5,0x7
  return c;
}
    80000dc6:	0000b517          	auipc	a0,0xb
    80000dca:	bca50513          	addi	a0,a0,-1078 # 8000b990 <cpus>
    80000dce:	953e                	add	a0,a0,a5
    80000dd0:	6422                	ld	s0,8(sp)
    80000dd2:	0141                	addi	sp,sp,16
    80000dd4:	8082                	ret

0000000080000dd6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000dd6:	1101                	addi	sp,sp,-32
    80000dd8:	ec06                	sd	ra,24(sp)
    80000dda:	e822                	sd	s0,16(sp)
    80000ddc:	e426                	sd	s1,8(sp)
    80000dde:	1000                	addi	s0,sp,32
  push_off();
    80000de0:	287050ef          	jal	80006866 <push_off>
    80000de4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000de6:	2781                	sext.w	a5,a5
    80000de8:	079e                	slli	a5,a5,0x7
    80000dea:	0000b717          	auipc	a4,0xb
    80000dee:	b7670713          	addi	a4,a4,-1162 # 8000b960 <pid_lock>
    80000df2:	97ba                	add	a5,a5,a4
    80000df4:	7b84                	ld	s1,48(a5)
  pop_off();
    80000df6:	2f5050ef          	jal	800068ea <pop_off>
  return p;
}
    80000dfa:	8526                	mv	a0,s1
    80000dfc:	60e2                	ld	ra,24(sp)
    80000dfe:	6442                	ld	s0,16(sp)
    80000e00:	64a2                	ld	s1,8(sp)
    80000e02:	6105                	addi	sp,sp,32
    80000e04:	8082                	ret

0000000080000e06 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e06:	7179                	addi	sp,sp,-48
    80000e08:	f406                	sd	ra,40(sp)
    80000e0a:	f022                	sd	s0,32(sp)
    80000e0c:	ec26                	sd	s1,24(sp)
    80000e0e:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000e10:	fc7ff0ef          	jal	80000dd6 <myproc>
    80000e14:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000e16:	329050ef          	jal	8000693e <release>

  if (first) {
    80000e1a:	0000b797          	auipc	a5,0xb
    80000e1e:	aa67a783          	lw	a5,-1370(a5) # 8000b8c0 <first.1>
    80000e22:	cf8d                	beqz	a5,80000e5c <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000e24:	4505                	li	a0,1
    80000e26:	3a5010ef          	jal	800029ca <fsinit>

    first = 0;
    80000e2a:	0000b797          	auipc	a5,0xb
    80000e2e:	a807ab23          	sw	zero,-1386(a5) # 8000b8c0 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000e32:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000e36:	00007517          	auipc	a0,0x7
    80000e3a:	30250513          	addi	a0,a0,770 # 80008138 <etext+0x138>
    80000e3e:	fca43823          	sd	a0,-48(s0)
    80000e42:	fc043c23          	sd	zero,-40(s0)
    80000e46:	fd040593          	addi	a1,s0,-48
    80000e4a:	481020ef          	jal	80003aca <kexec>
    80000e4e:	6cbc                	ld	a5,88(s1)
    80000e50:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000e52:	6cbc                	ld	a5,88(s1)
    80000e54:	7bb8                	ld	a4,112(a5)
    80000e56:	57fd                	li	a5,-1
    80000e58:	02f70d63          	beq	a4,a5,80000e92 <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000e5c:	2ad000ef          	jal	80001908 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e60:	68a8                	ld	a0,80(s1)
    80000e62:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000e64:	04000737          	lui	a4,0x4000
    80000e68:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000e6a:	0732                	slli	a4,a4,0xc
    80000e6c:	00006797          	auipc	a5,0x6
    80000e70:	23078793          	addi	a5,a5,560 # 8000709c <userret>
    80000e74:	00006697          	auipc	a3,0x6
    80000e78:	18c68693          	addi	a3,a3,396 # 80007000 <_trampoline>
    80000e7c:	8f95                	sub	a5,a5,a3
    80000e7e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000e80:	577d                	li	a4,-1
    80000e82:	177e                	slli	a4,a4,0x3f
    80000e84:	8d59                	or	a0,a0,a4
    80000e86:	9782                	jalr	a5
}
    80000e88:	70a2                	ld	ra,40(sp)
    80000e8a:	7402                	ld	s0,32(sp)
    80000e8c:	64e2                	ld	s1,24(sp)
    80000e8e:	6145                	addi	sp,sp,48
    80000e90:	8082                	ret
      panic("exec");
    80000e92:	00007517          	auipc	a0,0x7
    80000e96:	2ae50513          	addi	a0,a0,686 # 80008140 <etext+0x140>
    80000e9a:	750050ef          	jal	800065ea <panic>

0000000080000e9e <allocpid>:
{
    80000e9e:	1101                	addi	sp,sp,-32
    80000ea0:	ec06                	sd	ra,24(sp)
    80000ea2:	e822                	sd	s0,16(sp)
    80000ea4:	e426                	sd	s1,8(sp)
    80000ea6:	e04a                	sd	s2,0(sp)
    80000ea8:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000eaa:	0000b917          	auipc	s2,0xb
    80000eae:	ab690913          	addi	s2,s2,-1354 # 8000b960 <pid_lock>
    80000eb2:	854a                	mv	a0,s2
    80000eb4:	1f3050ef          	jal	800068a6 <acquire>
  pid = nextpid;
    80000eb8:	0000b797          	auipc	a5,0xb
    80000ebc:	a0c78793          	addi	a5,a5,-1524 # 8000b8c4 <nextpid>
    80000ec0:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ec2:	0014871b          	addiw	a4,s1,1
    80000ec6:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ec8:	854a                	mv	a0,s2
    80000eca:	275050ef          	jal	8000693e <release>
}
    80000ece:	8526                	mv	a0,s1
    80000ed0:	60e2                	ld	ra,24(sp)
    80000ed2:	6442                	ld	s0,16(sp)
    80000ed4:	64a2                	ld	s1,8(sp)
    80000ed6:	6902                	ld	s2,0(sp)
    80000ed8:	6105                	addi	sp,sp,32
    80000eda:	8082                	ret

0000000080000edc <proc_pagetable>:
{
    80000edc:	1101                	addi	sp,sp,-32
    80000ede:	ec06                	sd	ra,24(sp)
    80000ee0:	e822                	sd	s0,16(sp)
    80000ee2:	e426                	sd	s1,8(sp)
    80000ee4:	e04a                	sd	s2,0(sp)
    80000ee6:	1000                	addi	s0,sp,32
    80000ee8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000eea:	f8aff0ef          	jal	80000674 <uvmcreate>
    80000eee:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000ef0:	cd05                	beqz	a0,80000f28 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000ef2:	4729                	li	a4,10
    80000ef4:	00006697          	auipc	a3,0x6
    80000ef8:	10c68693          	addi	a3,a3,268 # 80007000 <_trampoline>
    80000efc:	6605                	lui	a2,0x1
    80000efe:	040005b7          	lui	a1,0x4000
    80000f02:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f04:	05b2                	slli	a1,a1,0xc
    80000f06:	da0ff0ef          	jal	800004a6 <mappages>
    80000f0a:	02054663          	bltz	a0,80000f36 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f0e:	4719                	li	a4,6
    80000f10:	05893683          	ld	a3,88(s2)
    80000f14:	6605                	lui	a2,0x1
    80000f16:	020005b7          	lui	a1,0x2000
    80000f1a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f1c:	05b6                	slli	a1,a1,0xd
    80000f1e:	8526                	mv	a0,s1
    80000f20:	d86ff0ef          	jal	800004a6 <mappages>
    80000f24:	00054f63          	bltz	a0,80000f42 <proc_pagetable+0x66>
}
    80000f28:	8526                	mv	a0,s1
    80000f2a:	60e2                	ld	ra,24(sp)
    80000f2c:	6442                	ld	s0,16(sp)
    80000f2e:	64a2                	ld	s1,8(sp)
    80000f30:	6902                	ld	s2,0(sp)
    80000f32:	6105                	addi	sp,sp,32
    80000f34:	8082                	ret
    uvmfree(pagetable, 0);
    80000f36:	4581                	li	a1,0
    80000f38:	8526                	mv	a0,s1
    80000f3a:	951ff0ef          	jal	8000088a <uvmfree>
    return 0;
    80000f3e:	4481                	li	s1,0
    80000f40:	b7e5                	j	80000f28 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f42:	4681                	li	a3,0
    80000f44:	4605                	li	a2,1
    80000f46:	040005b7          	lui	a1,0x4000
    80000f4a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f4c:	05b2                	slli	a1,a1,0xc
    80000f4e:	8526                	mv	a0,s1
    80000f50:	f4aff0ef          	jal	8000069a <uvmunmap>
    uvmfree(pagetable, 0);
    80000f54:	4581                	li	a1,0
    80000f56:	8526                	mv	a0,s1
    80000f58:	933ff0ef          	jal	8000088a <uvmfree>
    return 0;
    80000f5c:	4481                	li	s1,0
    80000f5e:	b7e9                	j	80000f28 <proc_pagetable+0x4c>

0000000080000f60 <proc_freepagetable>:
{
    80000f60:	1101                	addi	sp,sp,-32
    80000f62:	ec06                	sd	ra,24(sp)
    80000f64:	e822                	sd	s0,16(sp)
    80000f66:	e426                	sd	s1,8(sp)
    80000f68:	e04a                	sd	s2,0(sp)
    80000f6a:	1000                	addi	s0,sp,32
    80000f6c:	84aa                	mv	s1,a0
    80000f6e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f70:	4681                	li	a3,0
    80000f72:	4605                	li	a2,1
    80000f74:	040005b7          	lui	a1,0x4000
    80000f78:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f7a:	05b2                	slli	a1,a1,0xc
    80000f7c:	f1eff0ef          	jal	8000069a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f80:	4681                	li	a3,0
    80000f82:	4605                	li	a2,1
    80000f84:	020005b7          	lui	a1,0x2000
    80000f88:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f8a:	05b6                	slli	a1,a1,0xd
    80000f8c:	8526                	mv	a0,s1
    80000f8e:	f0cff0ef          	jal	8000069a <uvmunmap>
  uvmfree(pagetable, sz);
    80000f92:	85ca                	mv	a1,s2
    80000f94:	8526                	mv	a0,s1
    80000f96:	8f5ff0ef          	jal	8000088a <uvmfree>
}
    80000f9a:	60e2                	ld	ra,24(sp)
    80000f9c:	6442                	ld	s0,16(sp)
    80000f9e:	64a2                	ld	s1,8(sp)
    80000fa0:	6902                	ld	s2,0(sp)
    80000fa2:	6105                	addi	sp,sp,32
    80000fa4:	8082                	ret

0000000080000fa6 <freeproc>:
{
    80000fa6:	1101                	addi	sp,sp,-32
    80000fa8:	ec06                	sd	ra,24(sp)
    80000faa:	e822                	sd	s0,16(sp)
    80000fac:	e426                	sd	s1,8(sp)
    80000fae:	1000                	addi	s0,sp,32
    80000fb0:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000fb2:	6d28                	ld	a0,88(a0)
    80000fb4:	c119                	beqz	a0,80000fba <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000fb6:	866ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000fba:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000fbe:	68a8                	ld	a0,80(s1)
    80000fc0:	c501                	beqz	a0,80000fc8 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000fc2:	64ac                	ld	a1,72(s1)
    80000fc4:	f9dff0ef          	jal	80000f60 <proc_freepagetable>
  p->pagetable = 0;
    80000fc8:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000fcc:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000fd0:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000fd4:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000fd8:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000fdc:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000fe0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000fe4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000fe8:	0004ac23          	sw	zero,24(s1)
}
    80000fec:	60e2                	ld	ra,24(sp)
    80000fee:	6442                	ld	s0,16(sp)
    80000ff0:	64a2                	ld	s1,8(sp)
    80000ff2:	6105                	addi	sp,sp,32
    80000ff4:	8082                	ret

0000000080000ff6 <allocproc>:
{
    80000ff6:	1101                	addi	sp,sp,-32
    80000ff8:	ec06                	sd	ra,24(sp)
    80000ffa:	e822                	sd	s0,16(sp)
    80000ffc:	e426                	sd	s1,8(sp)
    80000ffe:	e04a                	sd	s2,0(sp)
    80001000:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001002:	0000b497          	auipc	s1,0xb
    80001006:	d8e48493          	addi	s1,s1,-626 # 8000bd90 <proc>
    8000100a:	00010917          	auipc	s2,0x10
    8000100e:	78690913          	addi	s2,s2,1926 # 80011790 <tickslock>
    acquire(&p->lock);
    80001012:	8526                	mv	a0,s1
    80001014:	093050ef          	jal	800068a6 <acquire>
    if(p->state == UNUSED) {
    80001018:	4c9c                	lw	a5,24(s1)
    8000101a:	cb91                	beqz	a5,8000102e <allocproc+0x38>
      release(&p->lock);
    8000101c:	8526                	mv	a0,s1
    8000101e:	121050ef          	jal	8000693e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001022:	16848493          	addi	s1,s1,360
    80001026:	ff2496e3          	bne	s1,s2,80001012 <allocproc+0x1c>
  return 0;
    8000102a:	4481                	li	s1,0
    8000102c:	a089                	j	8000106e <allocproc+0x78>
  p->pid = allocpid();
    8000102e:	e71ff0ef          	jal	80000e9e <allocpid>
    80001032:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001034:	4785                	li	a5,1
    80001036:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001038:	8c6ff0ef          	jal	800000fe <kalloc>
    8000103c:	892a                	mv	s2,a0
    8000103e:	eca8                	sd	a0,88(s1)
    80001040:	cd15                	beqz	a0,8000107c <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001042:	8526                	mv	a0,s1
    80001044:	e99ff0ef          	jal	80000edc <proc_pagetable>
    80001048:	892a                	mv	s2,a0
    8000104a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000104c:	c121                	beqz	a0,8000108c <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    8000104e:	07000613          	li	a2,112
    80001052:	4581                	li	a1,0
    80001054:	06048513          	addi	a0,s1,96
    80001058:	8f6ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    8000105c:	00000797          	auipc	a5,0x0
    80001060:	daa78793          	addi	a5,a5,-598 # 80000e06 <forkret>
    80001064:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001066:	60bc                	ld	a5,64(s1)
    80001068:	6705                	lui	a4,0x1
    8000106a:	97ba                	add	a5,a5,a4
    8000106c:	f4bc                	sd	a5,104(s1)
}
    8000106e:	8526                	mv	a0,s1
    80001070:	60e2                	ld	ra,24(sp)
    80001072:	6442                	ld	s0,16(sp)
    80001074:	64a2                	ld	s1,8(sp)
    80001076:	6902                	ld	s2,0(sp)
    80001078:	6105                	addi	sp,sp,32
    8000107a:	8082                	ret
    freeproc(p);
    8000107c:	8526                	mv	a0,s1
    8000107e:	f29ff0ef          	jal	80000fa6 <freeproc>
    release(&p->lock);
    80001082:	8526                	mv	a0,s1
    80001084:	0bb050ef          	jal	8000693e <release>
    return 0;
    80001088:	84ca                	mv	s1,s2
    8000108a:	b7d5                	j	8000106e <allocproc+0x78>
    freeproc(p);
    8000108c:	8526                	mv	a0,s1
    8000108e:	f19ff0ef          	jal	80000fa6 <freeproc>
    release(&p->lock);
    80001092:	8526                	mv	a0,s1
    80001094:	0ab050ef          	jal	8000693e <release>
    return 0;
    80001098:	84ca                	mv	s1,s2
    8000109a:	bfd1                	j	8000106e <allocproc+0x78>

000000008000109c <userinit>:
{
    8000109c:	1101                	addi	sp,sp,-32
    8000109e:	ec06                	sd	ra,24(sp)
    800010a0:	e822                	sd	s0,16(sp)
    800010a2:	e426                	sd	s1,8(sp)
    800010a4:	1000                	addi	s0,sp,32
  p = allocproc();
    800010a6:	f51ff0ef          	jal	80000ff6 <allocproc>
    800010aa:	84aa                	mv	s1,a0
  initproc = p;
    800010ac:	0000b797          	auipc	a5,0xb
    800010b0:	86a7b223          	sd	a0,-1948(a5) # 8000b910 <initproc>
  p->cwd = namei("/");
    800010b4:	00007517          	auipc	a0,0x7
    800010b8:	09450513          	addi	a0,a0,148 # 80008148 <etext+0x148>
    800010bc:	631010ef          	jal	80002eec <namei>
    800010c0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800010c4:	478d                	li	a5,3
    800010c6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800010c8:	8526                	mv	a0,s1
    800010ca:	075050ef          	jal	8000693e <release>
}
    800010ce:	60e2                	ld	ra,24(sp)
    800010d0:	6442                	ld	s0,16(sp)
    800010d2:	64a2                	ld	s1,8(sp)
    800010d4:	6105                	addi	sp,sp,32
    800010d6:	8082                	ret

00000000800010d8 <growproc>:
{
    800010d8:	1101                	addi	sp,sp,-32
    800010da:	ec06                	sd	ra,24(sp)
    800010dc:	e822                	sd	s0,16(sp)
    800010de:	e426                	sd	s1,8(sp)
    800010e0:	e04a                	sd	s2,0(sp)
    800010e2:	1000                	addi	s0,sp,32
    800010e4:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800010e6:	cf1ff0ef          	jal	80000dd6 <myproc>
    800010ea:	84aa                	mv	s1,a0
  sz = p->sz;
    800010ec:	652c                	ld	a1,72(a0)
  if(n > 0){
    800010ee:	01204c63          	bgtz	s2,80001106 <growproc+0x2e>
  } else if(n < 0){
    800010f2:	02094463          	bltz	s2,8000111a <growproc+0x42>
  p->sz = sz;
    800010f6:	e4ac                	sd	a1,72(s1)
  return 0;
    800010f8:	4501                	li	a0,0
}
    800010fa:	60e2                	ld	ra,24(sp)
    800010fc:	6442                	ld	s0,16(sp)
    800010fe:	64a2                	ld	s1,8(sp)
    80001100:	6902                	ld	s2,0(sp)
    80001102:	6105                	addi	sp,sp,32
    80001104:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001106:	4691                	li	a3,4
    80001108:	00b90633          	add	a2,s2,a1
    8000110c:	6928                	ld	a0,80(a0)
    8000110e:	e76ff0ef          	jal	80000784 <uvmalloc>
    80001112:	85aa                	mv	a1,a0
    80001114:	f16d                	bnez	a0,800010f6 <growproc+0x1e>
      return -1;
    80001116:	557d                	li	a0,-1
    80001118:	b7cd                	j	800010fa <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000111a:	00b90633          	add	a2,s2,a1
    8000111e:	6928                	ld	a0,80(a0)
    80001120:	e20ff0ef          	jal	80000740 <uvmdealloc>
    80001124:	85aa                	mv	a1,a0
    80001126:	bfc1                	j	800010f6 <growproc+0x1e>

0000000080001128 <kfork>:
{
    80001128:	7139                	addi	sp,sp,-64
    8000112a:	fc06                	sd	ra,56(sp)
    8000112c:	f822                	sd	s0,48(sp)
    8000112e:	f04a                	sd	s2,32(sp)
    80001130:	e456                	sd	s5,8(sp)
    80001132:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001134:	ca3ff0ef          	jal	80000dd6 <myproc>
    80001138:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000113a:	ebdff0ef          	jal	80000ff6 <allocproc>
    8000113e:	0e050a63          	beqz	a0,80001232 <kfork+0x10a>
    80001142:	e852                	sd	s4,16(sp)
    80001144:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001146:	048ab603          	ld	a2,72(s5)
    8000114a:	692c                	ld	a1,80(a0)
    8000114c:	050ab503          	ld	a0,80(s5)
    80001150:	f6cff0ef          	jal	800008bc <uvmcopy>
    80001154:	04054a63          	bltz	a0,800011a8 <kfork+0x80>
    80001158:	f426                	sd	s1,40(sp)
    8000115a:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000115c:	048ab783          	ld	a5,72(s5)
    80001160:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001164:	058ab683          	ld	a3,88(s5)
    80001168:	87b6                	mv	a5,a3
    8000116a:	058a3703          	ld	a4,88(s4)
    8000116e:	12068693          	addi	a3,a3,288
    80001172:	0007b803          	ld	a6,0(a5)
    80001176:	6788                	ld	a0,8(a5)
    80001178:	6b8c                	ld	a1,16(a5)
    8000117a:	6f90                	ld	a2,24(a5)
    8000117c:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001180:	e708                	sd	a0,8(a4)
    80001182:	eb0c                	sd	a1,16(a4)
    80001184:	ef10                	sd	a2,24(a4)
    80001186:	02078793          	addi	a5,a5,32
    8000118a:	02070713          	addi	a4,a4,32
    8000118e:	fed792e3          	bne	a5,a3,80001172 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001192:	058a3783          	ld	a5,88(s4)
    80001196:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000119a:	0d0a8493          	addi	s1,s5,208
    8000119e:	0d0a0913          	addi	s2,s4,208
    800011a2:	150a8993          	addi	s3,s5,336
    800011a6:	a831                	j	800011c2 <kfork+0x9a>
    freeproc(np);
    800011a8:	8552                	mv	a0,s4
    800011aa:	dfdff0ef          	jal	80000fa6 <freeproc>
    release(&np->lock);
    800011ae:	8552                	mv	a0,s4
    800011b0:	78e050ef          	jal	8000693e <release>
    return -1;
    800011b4:	597d                	li	s2,-1
    800011b6:	6a42                	ld	s4,16(sp)
    800011b8:	a0b5                	j	80001224 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    800011ba:	04a1                	addi	s1,s1,8
    800011bc:	0921                	addi	s2,s2,8
    800011be:	01348963          	beq	s1,s3,800011d0 <kfork+0xa8>
    if(p->ofile[i])
    800011c2:	6088                	ld	a0,0(s1)
    800011c4:	d97d                	beqz	a0,800011ba <kfork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    800011c6:	2c0020ef          	jal	80003486 <filedup>
    800011ca:	00a93023          	sd	a0,0(s2)
    800011ce:	b7f5                	j	800011ba <kfork+0x92>
  np->cwd = idup(p->cwd);
    800011d0:	150ab503          	ld	a0,336(s5)
    800011d4:	4cc010ef          	jal	800026a0 <idup>
    800011d8:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800011dc:	4641                	li	a2,16
    800011de:	158a8593          	addi	a1,s5,344
    800011e2:	158a0513          	addi	a0,s4,344
    800011e6:	8a6ff0ef          	jal	8000028c <safestrcpy>
  pid = np->pid;
    800011ea:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800011ee:	8552                	mv	a0,s4
    800011f0:	74e050ef          	jal	8000693e <release>
  acquire(&wait_lock);
    800011f4:	0000a497          	auipc	s1,0xa
    800011f8:	78448493          	addi	s1,s1,1924 # 8000b978 <wait_lock>
    800011fc:	8526                	mv	a0,s1
    800011fe:	6a8050ef          	jal	800068a6 <acquire>
  np->parent = p;
    80001202:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001206:	8526                	mv	a0,s1
    80001208:	736050ef          	jal	8000693e <release>
  acquire(&np->lock);
    8000120c:	8552                	mv	a0,s4
    8000120e:	698050ef          	jal	800068a6 <acquire>
  np->state = RUNNABLE;
    80001212:	478d                	li	a5,3
    80001214:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001218:	8552                	mv	a0,s4
    8000121a:	724050ef          	jal	8000693e <release>
  return pid;
    8000121e:	74a2                	ld	s1,40(sp)
    80001220:	69e2                	ld	s3,24(sp)
    80001222:	6a42                	ld	s4,16(sp)
}
    80001224:	854a                	mv	a0,s2
    80001226:	70e2                	ld	ra,56(sp)
    80001228:	7442                	ld	s0,48(sp)
    8000122a:	7902                	ld	s2,32(sp)
    8000122c:	6aa2                	ld	s5,8(sp)
    8000122e:	6121                	addi	sp,sp,64
    80001230:	8082                	ret
    return -1;
    80001232:	597d                	li	s2,-1
    80001234:	bfc5                	j	80001224 <kfork+0xfc>

0000000080001236 <scheduler>:
{
    80001236:	715d                	addi	sp,sp,-80
    80001238:	e486                	sd	ra,72(sp)
    8000123a:	e0a2                	sd	s0,64(sp)
    8000123c:	fc26                	sd	s1,56(sp)
    8000123e:	f84a                	sd	s2,48(sp)
    80001240:	f44e                	sd	s3,40(sp)
    80001242:	f052                	sd	s4,32(sp)
    80001244:	ec56                	sd	s5,24(sp)
    80001246:	e85a                	sd	s6,16(sp)
    80001248:	e45e                	sd	s7,8(sp)
    8000124a:	e062                	sd	s8,0(sp)
    8000124c:	0880                	addi	s0,sp,80
    8000124e:	8792                	mv	a5,tp
  int id = r_tp();
    80001250:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001252:	00779b13          	slli	s6,a5,0x7
    80001256:	0000a717          	auipc	a4,0xa
    8000125a:	70a70713          	addi	a4,a4,1802 # 8000b960 <pid_lock>
    8000125e:	975a                	add	a4,a4,s6
    80001260:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001264:	0000a717          	auipc	a4,0xa
    80001268:	73470713          	addi	a4,a4,1844 # 8000b998 <cpus+0x8>
    8000126c:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    8000126e:	4c11                	li	s8,4
        c->proc = p;
    80001270:	079e                	slli	a5,a5,0x7
    80001272:	0000aa17          	auipc	s4,0xa
    80001276:	6eea0a13          	addi	s4,s4,1774 # 8000b960 <pid_lock>
    8000127a:	9a3e                	add	s4,s4,a5
        found = 1;
    8000127c:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    8000127e:	00010997          	auipc	s3,0x10
    80001282:	51298993          	addi	s3,s3,1298 # 80011790 <tickslock>
    80001286:	a83d                	j	800012c4 <scheduler+0x8e>
      release(&p->lock);
    80001288:	8526                	mv	a0,s1
    8000128a:	6b4050ef          	jal	8000693e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000128e:	16848493          	addi	s1,s1,360
    80001292:	03348563          	beq	s1,s3,800012bc <scheduler+0x86>
      acquire(&p->lock);
    80001296:	8526                	mv	a0,s1
    80001298:	60e050ef          	jal	800068a6 <acquire>
      if(p->state == RUNNABLE) {
    8000129c:	4c9c                	lw	a5,24(s1)
    8000129e:	ff2795e3          	bne	a5,s2,80001288 <scheduler+0x52>
        p->state = RUNNING;
    800012a2:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800012a6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800012aa:	06048593          	addi	a1,s1,96
    800012ae:	855a                	mv	a0,s6
    800012b0:	5b2000ef          	jal	80001862 <swtch>
        c->proc = 0;
    800012b4:	020a3823          	sd	zero,48(s4)
        found = 1;
    800012b8:	8ade                	mv	s5,s7
    800012ba:	b7f9                	j	80001288 <scheduler+0x52>
    if(found == 0) {
    800012bc:	000a9463          	bnez	s5,800012c4 <scheduler+0x8e>
      asm volatile("wfi");
    800012c0:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012c4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800012c8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800012cc:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012d0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800012d4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800012d6:	10079073          	csrw	sstatus,a5
    int found = 0;
    800012da:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800012dc:	0000b497          	auipc	s1,0xb
    800012e0:	ab448493          	addi	s1,s1,-1356 # 8000bd90 <proc>
      if(p->state == RUNNABLE) {
    800012e4:	490d                	li	s2,3
    800012e6:	bf45                	j	80001296 <scheduler+0x60>

00000000800012e8 <sched>:
{
    800012e8:	7179                	addi	sp,sp,-48
    800012ea:	f406                	sd	ra,40(sp)
    800012ec:	f022                	sd	s0,32(sp)
    800012ee:	ec26                	sd	s1,24(sp)
    800012f0:	e84a                	sd	s2,16(sp)
    800012f2:	e44e                	sd	s3,8(sp)
    800012f4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012f6:	ae1ff0ef          	jal	80000dd6 <myproc>
    800012fa:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012fc:	540050ef          	jal	8000683c <holding>
    80001300:	c92d                	beqz	a0,80001372 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001302:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001304:	2781                	sext.w	a5,a5
    80001306:	079e                	slli	a5,a5,0x7
    80001308:	0000a717          	auipc	a4,0xa
    8000130c:	65870713          	addi	a4,a4,1624 # 8000b960 <pid_lock>
    80001310:	97ba                	add	a5,a5,a4
    80001312:	0a87a703          	lw	a4,168(a5)
    80001316:	4785                	li	a5,1
    80001318:	06f71363          	bne	a4,a5,8000137e <sched+0x96>
  if(p->state == RUNNING)
    8000131c:	4c98                	lw	a4,24(s1)
    8000131e:	4791                	li	a5,4
    80001320:	06f70563          	beq	a4,a5,8000138a <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001324:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001328:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000132a:	e7b5                	bnez	a5,80001396 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000132c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000132e:	0000a917          	auipc	s2,0xa
    80001332:	63290913          	addi	s2,s2,1586 # 8000b960 <pid_lock>
    80001336:	2781                	sext.w	a5,a5
    80001338:	079e                	slli	a5,a5,0x7
    8000133a:	97ca                	add	a5,a5,s2
    8000133c:	0ac7a983          	lw	s3,172(a5)
    80001340:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001342:	2781                	sext.w	a5,a5
    80001344:	079e                	slli	a5,a5,0x7
    80001346:	0000a597          	auipc	a1,0xa
    8000134a:	65258593          	addi	a1,a1,1618 # 8000b998 <cpus+0x8>
    8000134e:	95be                	add	a1,a1,a5
    80001350:	06048513          	addi	a0,s1,96
    80001354:	50e000ef          	jal	80001862 <swtch>
    80001358:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000135a:	2781                	sext.w	a5,a5
    8000135c:	079e                	slli	a5,a5,0x7
    8000135e:	993e                	add	s2,s2,a5
    80001360:	0b392623          	sw	s3,172(s2)
}
    80001364:	70a2                	ld	ra,40(sp)
    80001366:	7402                	ld	s0,32(sp)
    80001368:	64e2                	ld	s1,24(sp)
    8000136a:	6942                	ld	s2,16(sp)
    8000136c:	69a2                	ld	s3,8(sp)
    8000136e:	6145                	addi	sp,sp,48
    80001370:	8082                	ret
    panic("sched p->lock");
    80001372:	00007517          	auipc	a0,0x7
    80001376:	dde50513          	addi	a0,a0,-546 # 80008150 <etext+0x150>
    8000137a:	270050ef          	jal	800065ea <panic>
    panic("sched locks");
    8000137e:	00007517          	auipc	a0,0x7
    80001382:	de250513          	addi	a0,a0,-542 # 80008160 <etext+0x160>
    80001386:	264050ef          	jal	800065ea <panic>
    panic("sched RUNNING");
    8000138a:	00007517          	auipc	a0,0x7
    8000138e:	de650513          	addi	a0,a0,-538 # 80008170 <etext+0x170>
    80001392:	258050ef          	jal	800065ea <panic>
    panic("sched interruptible");
    80001396:	00007517          	auipc	a0,0x7
    8000139a:	dea50513          	addi	a0,a0,-534 # 80008180 <etext+0x180>
    8000139e:	24c050ef          	jal	800065ea <panic>

00000000800013a2 <yield>:
{
    800013a2:	1101                	addi	sp,sp,-32
    800013a4:	ec06                	sd	ra,24(sp)
    800013a6:	e822                	sd	s0,16(sp)
    800013a8:	e426                	sd	s1,8(sp)
    800013aa:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800013ac:	a2bff0ef          	jal	80000dd6 <myproc>
    800013b0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800013b2:	4f4050ef          	jal	800068a6 <acquire>
  p->state = RUNNABLE;
    800013b6:	478d                	li	a5,3
    800013b8:	cc9c                	sw	a5,24(s1)
  sched();
    800013ba:	f2fff0ef          	jal	800012e8 <sched>
  release(&p->lock);
    800013be:	8526                	mv	a0,s1
    800013c0:	57e050ef          	jal	8000693e <release>
}
    800013c4:	60e2                	ld	ra,24(sp)
    800013c6:	6442                	ld	s0,16(sp)
    800013c8:	64a2                	ld	s1,8(sp)
    800013ca:	6105                	addi	sp,sp,32
    800013cc:	8082                	ret

00000000800013ce <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800013ce:	7179                	addi	sp,sp,-48
    800013d0:	f406                	sd	ra,40(sp)
    800013d2:	f022                	sd	s0,32(sp)
    800013d4:	ec26                	sd	s1,24(sp)
    800013d6:	e84a                	sd	s2,16(sp)
    800013d8:	e44e                	sd	s3,8(sp)
    800013da:	1800                	addi	s0,sp,48
    800013dc:	89aa                	mv	s3,a0
    800013de:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800013e0:	9f7ff0ef          	jal	80000dd6 <myproc>
    800013e4:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800013e6:	4c0050ef          	jal	800068a6 <acquire>
  release(lk);
    800013ea:	854a                	mv	a0,s2
    800013ec:	552050ef          	jal	8000693e <release>

  // Go to sleep.
  p->chan = chan;
    800013f0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800013f4:	4789                	li	a5,2
    800013f6:	cc9c                	sw	a5,24(s1)

  sched();
    800013f8:	ef1ff0ef          	jal	800012e8 <sched>

  // Tidy up.
  p->chan = 0;
    800013fc:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001400:	8526                	mv	a0,s1
    80001402:	53c050ef          	jal	8000693e <release>
  acquire(lk);
    80001406:	854a                	mv	a0,s2
    80001408:	49e050ef          	jal	800068a6 <acquire>
}
    8000140c:	70a2                	ld	ra,40(sp)
    8000140e:	7402                	ld	s0,32(sp)
    80001410:	64e2                	ld	s1,24(sp)
    80001412:	6942                	ld	s2,16(sp)
    80001414:	69a2                	ld	s3,8(sp)
    80001416:	6145                	addi	sp,sp,48
    80001418:	8082                	ret

000000008000141a <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    8000141a:	7139                	addi	sp,sp,-64
    8000141c:	fc06                	sd	ra,56(sp)
    8000141e:	f822                	sd	s0,48(sp)
    80001420:	f426                	sd	s1,40(sp)
    80001422:	f04a                	sd	s2,32(sp)
    80001424:	ec4e                	sd	s3,24(sp)
    80001426:	e852                	sd	s4,16(sp)
    80001428:	e456                	sd	s5,8(sp)
    8000142a:	0080                	addi	s0,sp,64
    8000142c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000142e:	0000b497          	auipc	s1,0xb
    80001432:	96248493          	addi	s1,s1,-1694 # 8000bd90 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001436:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001438:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000143a:	00010917          	auipc	s2,0x10
    8000143e:	35690913          	addi	s2,s2,854 # 80011790 <tickslock>
    80001442:	a801                	j	80001452 <wakeup+0x38>
      }
      release(&p->lock);
    80001444:	8526                	mv	a0,s1
    80001446:	4f8050ef          	jal	8000693e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000144a:	16848493          	addi	s1,s1,360
    8000144e:	03248263          	beq	s1,s2,80001472 <wakeup+0x58>
    if(p != myproc()){
    80001452:	985ff0ef          	jal	80000dd6 <myproc>
    80001456:	fea48ae3          	beq	s1,a0,8000144a <wakeup+0x30>
      acquire(&p->lock);
    8000145a:	8526                	mv	a0,s1
    8000145c:	44a050ef          	jal	800068a6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001460:	4c9c                	lw	a5,24(s1)
    80001462:	ff3791e3          	bne	a5,s3,80001444 <wakeup+0x2a>
    80001466:	709c                	ld	a5,32(s1)
    80001468:	fd479ee3          	bne	a5,s4,80001444 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000146c:	0154ac23          	sw	s5,24(s1)
    80001470:	bfd1                	j	80001444 <wakeup+0x2a>
    }
  }
}
    80001472:	70e2                	ld	ra,56(sp)
    80001474:	7442                	ld	s0,48(sp)
    80001476:	74a2                	ld	s1,40(sp)
    80001478:	7902                	ld	s2,32(sp)
    8000147a:	69e2                	ld	s3,24(sp)
    8000147c:	6a42                	ld	s4,16(sp)
    8000147e:	6aa2                	ld	s5,8(sp)
    80001480:	6121                	addi	sp,sp,64
    80001482:	8082                	ret

0000000080001484 <reparent>:
{
    80001484:	7179                	addi	sp,sp,-48
    80001486:	f406                	sd	ra,40(sp)
    80001488:	f022                	sd	s0,32(sp)
    8000148a:	ec26                	sd	s1,24(sp)
    8000148c:	e84a                	sd	s2,16(sp)
    8000148e:	e44e                	sd	s3,8(sp)
    80001490:	e052                	sd	s4,0(sp)
    80001492:	1800                	addi	s0,sp,48
    80001494:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001496:	0000b497          	auipc	s1,0xb
    8000149a:	8fa48493          	addi	s1,s1,-1798 # 8000bd90 <proc>
      pp->parent = initproc;
    8000149e:	0000aa17          	auipc	s4,0xa
    800014a2:	472a0a13          	addi	s4,s4,1138 # 8000b910 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800014a6:	00010997          	auipc	s3,0x10
    800014aa:	2ea98993          	addi	s3,s3,746 # 80011790 <tickslock>
    800014ae:	a029                	j	800014b8 <reparent+0x34>
    800014b0:	16848493          	addi	s1,s1,360
    800014b4:	01348b63          	beq	s1,s3,800014ca <reparent+0x46>
    if(pp->parent == p){
    800014b8:	7c9c                	ld	a5,56(s1)
    800014ba:	ff279be3          	bne	a5,s2,800014b0 <reparent+0x2c>
      pp->parent = initproc;
    800014be:	000a3503          	ld	a0,0(s4)
    800014c2:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800014c4:	f57ff0ef          	jal	8000141a <wakeup>
    800014c8:	b7e5                	j	800014b0 <reparent+0x2c>
}
    800014ca:	70a2                	ld	ra,40(sp)
    800014cc:	7402                	ld	s0,32(sp)
    800014ce:	64e2                	ld	s1,24(sp)
    800014d0:	6942                	ld	s2,16(sp)
    800014d2:	69a2                	ld	s3,8(sp)
    800014d4:	6a02                	ld	s4,0(sp)
    800014d6:	6145                	addi	sp,sp,48
    800014d8:	8082                	ret

00000000800014da <kexit>:
{
    800014da:	7179                	addi	sp,sp,-48
    800014dc:	f406                	sd	ra,40(sp)
    800014de:	f022                	sd	s0,32(sp)
    800014e0:	ec26                	sd	s1,24(sp)
    800014e2:	e84a                	sd	s2,16(sp)
    800014e4:	e44e                	sd	s3,8(sp)
    800014e6:	e052                	sd	s4,0(sp)
    800014e8:	1800                	addi	s0,sp,48
    800014ea:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800014ec:	8ebff0ef          	jal	80000dd6 <myproc>
    800014f0:	89aa                	mv	s3,a0
  if(p == initproc)
    800014f2:	0000a797          	auipc	a5,0xa
    800014f6:	41e7b783          	ld	a5,1054(a5) # 8000b910 <initproc>
    800014fa:	0d050493          	addi	s1,a0,208
    800014fe:	15050913          	addi	s2,a0,336
    80001502:	00a79f63          	bne	a5,a0,80001520 <kexit+0x46>
    panic("init exiting");
    80001506:	00007517          	auipc	a0,0x7
    8000150a:	c9250513          	addi	a0,a0,-878 # 80008198 <etext+0x198>
    8000150e:	0dc050ef          	jal	800065ea <panic>
      fileclose(f);
    80001512:	7bb010ef          	jal	800034cc <fileclose>
      p->ofile[fd] = 0;
    80001516:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000151a:	04a1                	addi	s1,s1,8
    8000151c:	01248563          	beq	s1,s2,80001526 <kexit+0x4c>
    if(p->ofile[fd]){
    80001520:	6088                	ld	a0,0(s1)
    80001522:	f965                	bnez	a0,80001512 <kexit+0x38>
    80001524:	bfdd                	j	8000151a <kexit+0x40>
  begin_op();
    80001526:	39b010ef          	jal	800030c0 <begin_op>
  iput(p->cwd);
    8000152a:	1509b503          	ld	a0,336(s3)
    8000152e:	32a010ef          	jal	80002858 <iput>
  end_op();
    80001532:	3f9010ef          	jal	8000312a <end_op>
  p->cwd = 0;
    80001536:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000153a:	0000a497          	auipc	s1,0xa
    8000153e:	43e48493          	addi	s1,s1,1086 # 8000b978 <wait_lock>
    80001542:	8526                	mv	a0,s1
    80001544:	362050ef          	jal	800068a6 <acquire>
  reparent(p);
    80001548:	854e                	mv	a0,s3
    8000154a:	f3bff0ef          	jal	80001484 <reparent>
  wakeup(p->parent);
    8000154e:	0389b503          	ld	a0,56(s3)
    80001552:	ec9ff0ef          	jal	8000141a <wakeup>
  acquire(&p->lock);
    80001556:	854e                	mv	a0,s3
    80001558:	34e050ef          	jal	800068a6 <acquire>
  p->xstate = status;
    8000155c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001560:	4795                	li	a5,5
    80001562:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001566:	8526                	mv	a0,s1
    80001568:	3d6050ef          	jal	8000693e <release>
  sched();
    8000156c:	d7dff0ef          	jal	800012e8 <sched>
  panic("zombie exit");
    80001570:	00007517          	auipc	a0,0x7
    80001574:	c3850513          	addi	a0,a0,-968 # 800081a8 <etext+0x1a8>
    80001578:	072050ef          	jal	800065ea <panic>

000000008000157c <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    8000157c:	7179                	addi	sp,sp,-48
    8000157e:	f406                	sd	ra,40(sp)
    80001580:	f022                	sd	s0,32(sp)
    80001582:	ec26                	sd	s1,24(sp)
    80001584:	e84a                	sd	s2,16(sp)
    80001586:	e44e                	sd	s3,8(sp)
    80001588:	1800                	addi	s0,sp,48
    8000158a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000158c:	0000b497          	auipc	s1,0xb
    80001590:	80448493          	addi	s1,s1,-2044 # 8000bd90 <proc>
    80001594:	00010997          	auipc	s3,0x10
    80001598:	1fc98993          	addi	s3,s3,508 # 80011790 <tickslock>
    acquire(&p->lock);
    8000159c:	8526                	mv	a0,s1
    8000159e:	308050ef          	jal	800068a6 <acquire>
    if(p->pid == pid){
    800015a2:	589c                	lw	a5,48(s1)
    800015a4:	01278b63          	beq	a5,s2,800015ba <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800015a8:	8526                	mv	a0,s1
    800015aa:	394050ef          	jal	8000693e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800015ae:	16848493          	addi	s1,s1,360
    800015b2:	ff3495e3          	bne	s1,s3,8000159c <kkill+0x20>
  }
  return -1;
    800015b6:	557d                	li	a0,-1
    800015b8:	a819                	j	800015ce <kkill+0x52>
      p->killed = 1;
    800015ba:	4785                	li	a5,1
    800015bc:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800015be:	4c98                	lw	a4,24(s1)
    800015c0:	4789                	li	a5,2
    800015c2:	00f70d63          	beq	a4,a5,800015dc <kkill+0x60>
      release(&p->lock);
    800015c6:	8526                	mv	a0,s1
    800015c8:	376050ef          	jal	8000693e <release>
      return 0;
    800015cc:	4501                	li	a0,0
}
    800015ce:	70a2                	ld	ra,40(sp)
    800015d0:	7402                	ld	s0,32(sp)
    800015d2:	64e2                	ld	s1,24(sp)
    800015d4:	6942                	ld	s2,16(sp)
    800015d6:	69a2                	ld	s3,8(sp)
    800015d8:	6145                	addi	sp,sp,48
    800015da:	8082                	ret
        p->state = RUNNABLE;
    800015dc:	478d                	li	a5,3
    800015de:	cc9c                	sw	a5,24(s1)
    800015e0:	b7dd                	j	800015c6 <kkill+0x4a>

00000000800015e2 <setkilled>:

void
setkilled(struct proc *p)
{
    800015e2:	1101                	addi	sp,sp,-32
    800015e4:	ec06                	sd	ra,24(sp)
    800015e6:	e822                	sd	s0,16(sp)
    800015e8:	e426                	sd	s1,8(sp)
    800015ea:	1000                	addi	s0,sp,32
    800015ec:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015ee:	2b8050ef          	jal	800068a6 <acquire>
  p->killed = 1;
    800015f2:	4785                	li	a5,1
    800015f4:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800015f6:	8526                	mv	a0,s1
    800015f8:	346050ef          	jal	8000693e <release>
}
    800015fc:	60e2                	ld	ra,24(sp)
    800015fe:	6442                	ld	s0,16(sp)
    80001600:	64a2                	ld	s1,8(sp)
    80001602:	6105                	addi	sp,sp,32
    80001604:	8082                	ret

0000000080001606 <killed>:

int
killed(struct proc *p)
{
    80001606:	1101                	addi	sp,sp,-32
    80001608:	ec06                	sd	ra,24(sp)
    8000160a:	e822                	sd	s0,16(sp)
    8000160c:	e426                	sd	s1,8(sp)
    8000160e:	e04a                	sd	s2,0(sp)
    80001610:	1000                	addi	s0,sp,32
    80001612:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001614:	292050ef          	jal	800068a6 <acquire>
  k = p->killed;
    80001618:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000161c:	8526                	mv	a0,s1
    8000161e:	320050ef          	jal	8000693e <release>
  return k;
}
    80001622:	854a                	mv	a0,s2
    80001624:	60e2                	ld	ra,24(sp)
    80001626:	6442                	ld	s0,16(sp)
    80001628:	64a2                	ld	s1,8(sp)
    8000162a:	6902                	ld	s2,0(sp)
    8000162c:	6105                	addi	sp,sp,32
    8000162e:	8082                	ret

0000000080001630 <kwait>:
{
    80001630:	715d                	addi	sp,sp,-80
    80001632:	e486                	sd	ra,72(sp)
    80001634:	e0a2                	sd	s0,64(sp)
    80001636:	fc26                	sd	s1,56(sp)
    80001638:	f84a                	sd	s2,48(sp)
    8000163a:	f44e                	sd	s3,40(sp)
    8000163c:	f052                	sd	s4,32(sp)
    8000163e:	ec56                	sd	s5,24(sp)
    80001640:	e85a                	sd	s6,16(sp)
    80001642:	e45e                	sd	s7,8(sp)
    80001644:	e062                	sd	s8,0(sp)
    80001646:	0880                	addi	s0,sp,80
    80001648:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000164a:	f8cff0ef          	jal	80000dd6 <myproc>
    8000164e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001650:	0000a517          	auipc	a0,0xa
    80001654:	32850513          	addi	a0,a0,808 # 8000b978 <wait_lock>
    80001658:	24e050ef          	jal	800068a6 <acquire>
    havekids = 0;
    8000165c:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000165e:	4a15                	li	s4,5
        havekids = 1;
    80001660:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001662:	00010997          	auipc	s3,0x10
    80001666:	12e98993          	addi	s3,s3,302 # 80011790 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000166a:	0000ac17          	auipc	s8,0xa
    8000166e:	30ec0c13          	addi	s8,s8,782 # 8000b978 <wait_lock>
    80001672:	a871                	j	8000170e <kwait+0xde>
          pid = pp->pid;
    80001674:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001678:	000b0c63          	beqz	s6,80001690 <kwait+0x60>
    8000167c:	4691                	li	a3,4
    8000167e:	02c48613          	addi	a2,s1,44
    80001682:	85da                	mv	a1,s6
    80001684:	05093503          	ld	a0,80(s2)
    80001688:	c56ff0ef          	jal	80000ade <copyout>
    8000168c:	02054b63          	bltz	a0,800016c2 <kwait+0x92>
          freeproc(pp);
    80001690:	8526                	mv	a0,s1
    80001692:	915ff0ef          	jal	80000fa6 <freeproc>
          release(&pp->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	2a6050ef          	jal	8000693e <release>
          release(&wait_lock);
    8000169c:	0000a517          	auipc	a0,0xa
    800016a0:	2dc50513          	addi	a0,a0,732 # 8000b978 <wait_lock>
    800016a4:	29a050ef          	jal	8000693e <release>
}
    800016a8:	854e                	mv	a0,s3
    800016aa:	60a6                	ld	ra,72(sp)
    800016ac:	6406                	ld	s0,64(sp)
    800016ae:	74e2                	ld	s1,56(sp)
    800016b0:	7942                	ld	s2,48(sp)
    800016b2:	79a2                	ld	s3,40(sp)
    800016b4:	7a02                	ld	s4,32(sp)
    800016b6:	6ae2                	ld	s5,24(sp)
    800016b8:	6b42                	ld	s6,16(sp)
    800016ba:	6ba2                	ld	s7,8(sp)
    800016bc:	6c02                	ld	s8,0(sp)
    800016be:	6161                	addi	sp,sp,80
    800016c0:	8082                	ret
            release(&pp->lock);
    800016c2:	8526                	mv	a0,s1
    800016c4:	27a050ef          	jal	8000693e <release>
            release(&wait_lock);
    800016c8:	0000a517          	auipc	a0,0xa
    800016cc:	2b050513          	addi	a0,a0,688 # 8000b978 <wait_lock>
    800016d0:	26e050ef          	jal	8000693e <release>
            return -1;
    800016d4:	59fd                	li	s3,-1
    800016d6:	bfc9                	j	800016a8 <kwait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016d8:	16848493          	addi	s1,s1,360
    800016dc:	03348063          	beq	s1,s3,800016fc <kwait+0xcc>
      if(pp->parent == p){
    800016e0:	7c9c                	ld	a5,56(s1)
    800016e2:	ff279be3          	bne	a5,s2,800016d8 <kwait+0xa8>
        acquire(&pp->lock);
    800016e6:	8526                	mv	a0,s1
    800016e8:	1be050ef          	jal	800068a6 <acquire>
        if(pp->state == ZOMBIE){
    800016ec:	4c9c                	lw	a5,24(s1)
    800016ee:	f94783e3          	beq	a5,s4,80001674 <kwait+0x44>
        release(&pp->lock);
    800016f2:	8526                	mv	a0,s1
    800016f4:	24a050ef          	jal	8000693e <release>
        havekids = 1;
    800016f8:	8756                	mv	a4,s5
    800016fa:	bff9                	j	800016d8 <kwait+0xa8>
    if(!havekids || killed(p)){
    800016fc:	cf19                	beqz	a4,8000171a <kwait+0xea>
    800016fe:	854a                	mv	a0,s2
    80001700:	f07ff0ef          	jal	80001606 <killed>
    80001704:	e919                	bnez	a0,8000171a <kwait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001706:	85e2                	mv	a1,s8
    80001708:	854a                	mv	a0,s2
    8000170a:	cc5ff0ef          	jal	800013ce <sleep>
    havekids = 0;
    8000170e:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001710:	0000a497          	auipc	s1,0xa
    80001714:	68048493          	addi	s1,s1,1664 # 8000bd90 <proc>
    80001718:	b7e1                	j	800016e0 <kwait+0xb0>
      release(&wait_lock);
    8000171a:	0000a517          	auipc	a0,0xa
    8000171e:	25e50513          	addi	a0,a0,606 # 8000b978 <wait_lock>
    80001722:	21c050ef          	jal	8000693e <release>
      return -1;
    80001726:	59fd                	li	s3,-1
    80001728:	b741                	j	800016a8 <kwait+0x78>

000000008000172a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000172a:	7179                	addi	sp,sp,-48
    8000172c:	f406                	sd	ra,40(sp)
    8000172e:	f022                	sd	s0,32(sp)
    80001730:	ec26                	sd	s1,24(sp)
    80001732:	e84a                	sd	s2,16(sp)
    80001734:	e44e                	sd	s3,8(sp)
    80001736:	e052                	sd	s4,0(sp)
    80001738:	1800                	addi	s0,sp,48
    8000173a:	84aa                	mv	s1,a0
    8000173c:	892e                	mv	s2,a1
    8000173e:	89b2                	mv	s3,a2
    80001740:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001742:	e94ff0ef          	jal	80000dd6 <myproc>
  if(user_dst){
    80001746:	cc99                	beqz	s1,80001764 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001748:	86d2                	mv	a3,s4
    8000174a:	864e                	mv	a2,s3
    8000174c:	85ca                	mv	a1,s2
    8000174e:	6928                	ld	a0,80(a0)
    80001750:	b8eff0ef          	jal	80000ade <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001754:	70a2                	ld	ra,40(sp)
    80001756:	7402                	ld	s0,32(sp)
    80001758:	64e2                	ld	s1,24(sp)
    8000175a:	6942                	ld	s2,16(sp)
    8000175c:	69a2                	ld	s3,8(sp)
    8000175e:	6a02                	ld	s4,0(sp)
    80001760:	6145                	addi	sp,sp,48
    80001762:	8082                	ret
    memmove((char *)dst, src, len);
    80001764:	000a061b          	sext.w	a2,s4
    80001768:	85ce                	mv	a1,s3
    8000176a:	854a                	mv	a0,s2
    8000176c:	a3ffe0ef          	jal	800001aa <memmove>
    return 0;
    80001770:	8526                	mv	a0,s1
    80001772:	b7cd                	j	80001754 <either_copyout+0x2a>

0000000080001774 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001774:	7179                	addi	sp,sp,-48
    80001776:	f406                	sd	ra,40(sp)
    80001778:	f022                	sd	s0,32(sp)
    8000177a:	ec26                	sd	s1,24(sp)
    8000177c:	e84a                	sd	s2,16(sp)
    8000177e:	e44e                	sd	s3,8(sp)
    80001780:	e052                	sd	s4,0(sp)
    80001782:	1800                	addi	s0,sp,48
    80001784:	892a                	mv	s2,a0
    80001786:	84ae                	mv	s1,a1
    80001788:	89b2                	mv	s3,a2
    8000178a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000178c:	e4aff0ef          	jal	80000dd6 <myproc>
  if(user_src){
    80001790:	cc99                	beqz	s1,800017ae <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001792:	86d2                	mv	a3,s4
    80001794:	864e                	mv	a2,s3
    80001796:	85ca                	mv	a1,s2
    80001798:	6928                	ld	a0,80(a0)
    8000179a:	c38ff0ef          	jal	80000bd2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000179e:	70a2                	ld	ra,40(sp)
    800017a0:	7402                	ld	s0,32(sp)
    800017a2:	64e2                	ld	s1,24(sp)
    800017a4:	6942                	ld	s2,16(sp)
    800017a6:	69a2                	ld	s3,8(sp)
    800017a8:	6a02                	ld	s4,0(sp)
    800017aa:	6145                	addi	sp,sp,48
    800017ac:	8082                	ret
    memmove(dst, (char*)src, len);
    800017ae:	000a061b          	sext.w	a2,s4
    800017b2:	85ce                	mv	a1,s3
    800017b4:	854a                	mv	a0,s2
    800017b6:	9f5fe0ef          	jal	800001aa <memmove>
    return 0;
    800017ba:	8526                	mv	a0,s1
    800017bc:	b7cd                	j	8000179e <either_copyin+0x2a>

00000000800017be <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800017be:	715d                	addi	sp,sp,-80
    800017c0:	e486                	sd	ra,72(sp)
    800017c2:	e0a2                	sd	s0,64(sp)
    800017c4:	fc26                	sd	s1,56(sp)
    800017c6:	f84a                	sd	s2,48(sp)
    800017c8:	f44e                	sd	s3,40(sp)
    800017ca:	f052                	sd	s4,32(sp)
    800017cc:	ec56                	sd	s5,24(sp)
    800017ce:	e85a                	sd	s6,16(sp)
    800017d0:	e45e                	sd	s7,8(sp)
    800017d2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800017d4:	00007517          	auipc	a0,0x7
    800017d8:	84450513          	addi	a0,a0,-1980 # 80008018 <etext+0x18>
    800017dc:	329040ef          	jal	80006304 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017e0:	0000a497          	auipc	s1,0xa
    800017e4:	70848493          	addi	s1,s1,1800 # 8000bee8 <proc+0x158>
    800017e8:	00010917          	auipc	s2,0x10
    800017ec:	10090913          	addi	s2,s2,256 # 800118e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017f0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800017f2:	00007997          	auipc	s3,0x7
    800017f6:	9c698993          	addi	s3,s3,-1594 # 800081b8 <etext+0x1b8>
    printf("%d %s %s", p->pid, state, p->name);
    800017fa:	00007a97          	auipc	s5,0x7
    800017fe:	9c6a8a93          	addi	s5,s5,-1594 # 800081c0 <etext+0x1c0>
    printf("\n");
    80001802:	00007a17          	auipc	s4,0x7
    80001806:	816a0a13          	addi	s4,s4,-2026 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000180a:	00007b97          	auipc	s7,0x7
    8000180e:	19eb8b93          	addi	s7,s7,414 # 800089a8 <states.0>
    80001812:	a829                	j	8000182c <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001814:	ed86a583          	lw	a1,-296(a3)
    80001818:	8556                	mv	a0,s5
    8000181a:	2eb040ef          	jal	80006304 <printf>
    printf("\n");
    8000181e:	8552                	mv	a0,s4
    80001820:	2e5040ef          	jal	80006304 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001824:	16848493          	addi	s1,s1,360
    80001828:	03248263          	beq	s1,s2,8000184c <procdump+0x8e>
    if(p->state == UNUSED)
    8000182c:	86a6                	mv	a3,s1
    8000182e:	ec04a783          	lw	a5,-320(s1)
    80001832:	dbed                	beqz	a5,80001824 <procdump+0x66>
      state = "???";
    80001834:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001836:	fcfb6fe3          	bltu	s6,a5,80001814 <procdump+0x56>
    8000183a:	02079713          	slli	a4,a5,0x20
    8000183e:	01d75793          	srli	a5,a4,0x1d
    80001842:	97de                	add	a5,a5,s7
    80001844:	6390                	ld	a2,0(a5)
    80001846:	f679                	bnez	a2,80001814 <procdump+0x56>
      state = "???";
    80001848:	864e                	mv	a2,s3
    8000184a:	b7e9                	j	80001814 <procdump+0x56>
  }
}
    8000184c:	60a6                	ld	ra,72(sp)
    8000184e:	6406                	ld	s0,64(sp)
    80001850:	74e2                	ld	s1,56(sp)
    80001852:	7942                	ld	s2,48(sp)
    80001854:	79a2                	ld	s3,40(sp)
    80001856:	7a02                	ld	s4,32(sp)
    80001858:	6ae2                	ld	s5,24(sp)
    8000185a:	6b42                	ld	s6,16(sp)
    8000185c:	6ba2                	ld	s7,8(sp)
    8000185e:	6161                	addi	sp,sp,80
    80001860:	8082                	ret

0000000080001862 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001862:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001866:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    8000186a:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8000186c:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8000186e:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001872:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001876:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    8000187a:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    8000187e:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001882:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001886:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    8000188a:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    8000188e:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001892:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001896:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    8000189a:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    8000189e:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800018a0:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800018a2:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    800018a6:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    800018aa:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    800018ae:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    800018b2:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    800018b6:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    800018ba:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    800018be:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    800018c2:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800018c6:	0685bd83          	ld	s11,104(a1)
        
        ret
    800018ca:	8082                	ret

00000000800018cc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018cc:	1141                	addi	sp,sp,-16
    800018ce:	e406                	sd	ra,8(sp)
    800018d0:	e022                	sd	s0,0(sp)
    800018d2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018d4:	00007597          	auipc	a1,0x7
    800018d8:	92c58593          	addi	a1,a1,-1748 # 80008200 <etext+0x200>
    800018dc:	00010517          	auipc	a0,0x10
    800018e0:	eb450513          	addi	a0,a0,-332 # 80011790 <tickslock>
    800018e4:	743040ef          	jal	80006826 <initlock>
}
    800018e8:	60a2                	ld	ra,8(sp)
    800018ea:	6402                	ld	s0,0(sp)
    800018ec:	0141                	addi	sp,sp,16
    800018ee:	8082                	ret

00000000800018f0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018f0:	1141                	addi	sp,sp,-16
    800018f2:	e422                	sd	s0,8(sp)
    800018f4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018f6:	00003797          	auipc	a5,0x3
    800018fa:	f4a78793          	addi	a5,a5,-182 # 80004840 <kernelvec>
    800018fe:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001902:	6422                	ld	s0,8(sp)
    80001904:	0141                	addi	sp,sp,16
    80001906:	8082                	ret

0000000080001908 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80001908:	1141                	addi	sp,sp,-16
    8000190a:	e406                	sd	ra,8(sp)
    8000190c:	e022                	sd	s0,0(sp)
    8000190e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001910:	cc6ff0ef          	jal	80000dd6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001914:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001918:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000191a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000191e:	04000737          	lui	a4,0x4000
    80001922:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001924:	0732                	slli	a4,a4,0xc
    80001926:	00005797          	auipc	a5,0x5
    8000192a:	6da78793          	addi	a5,a5,1754 # 80007000 <_trampoline>
    8000192e:	00005697          	auipc	a3,0x5
    80001932:	6d268693          	addi	a3,a3,1746 # 80007000 <_trampoline>
    80001936:	8f95                	sub	a5,a5,a3
    80001938:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000193a:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000193e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001940:	18002773          	csrr	a4,satp
    80001944:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001946:	6d38                	ld	a4,88(a0)
    80001948:	613c                	ld	a5,64(a0)
    8000194a:	6685                	lui	a3,0x1
    8000194c:	97b6                	add	a5,a5,a3
    8000194e:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001950:	6d3c                	ld	a5,88(a0)
    80001952:	00000717          	auipc	a4,0x0
    80001956:	10670713          	addi	a4,a4,262 # 80001a58 <usertrap>
    8000195a:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000195c:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000195e:	8712                	mv	a4,tp
    80001960:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001962:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001966:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000196a:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000196e:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001972:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001974:	6f9c                	ld	a5,24(a5)
    80001976:	14179073          	csrw	sepc,a5
}
    8000197a:	60a2                	ld	ra,8(sp)
    8000197c:	6402                	ld	s0,0(sp)
    8000197e:	0141                	addi	sp,sp,16
    80001980:	8082                	ret

0000000080001982 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001982:	1101                	addi	sp,sp,-32
    80001984:	ec06                	sd	ra,24(sp)
    80001986:	e822                	sd	s0,16(sp)
    80001988:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000198a:	c20ff0ef          	jal	80000daa <cpuid>
    8000198e:	cd11                	beqz	a0,800019aa <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001990:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001994:	000f4737          	lui	a4,0xf4
    80001998:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000199c:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000199e:	14d79073          	csrw	stimecmp,a5
}
    800019a2:	60e2                	ld	ra,24(sp)
    800019a4:	6442                	ld	s0,16(sp)
    800019a6:	6105                	addi	sp,sp,32
    800019a8:	8082                	ret
    800019aa:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800019ac:	00010497          	auipc	s1,0x10
    800019b0:	de448493          	addi	s1,s1,-540 # 80011790 <tickslock>
    800019b4:	8526                	mv	a0,s1
    800019b6:	6f1040ef          	jal	800068a6 <acquire>
    ticks++;
    800019ba:	0000a517          	auipc	a0,0xa
    800019be:	f5e50513          	addi	a0,a0,-162 # 8000b918 <ticks>
    800019c2:	411c                	lw	a5,0(a0)
    800019c4:	2785                	addiw	a5,a5,1
    800019c6:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800019c8:	a53ff0ef          	jal	8000141a <wakeup>
    release(&tickslock);
    800019cc:	8526                	mv	a0,s1
    800019ce:	771040ef          	jal	8000693e <release>
    800019d2:	64a2                	ld	s1,8(sp)
    800019d4:	bf75                	j	80001990 <clockintr+0xe>

00000000800019d6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019d6:	1101                	addi	sp,sp,-32
    800019d8:	ec06                	sd	ra,24(sp)
    800019da:	e822                	sd	s0,16(sp)
    800019dc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019de:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019e2:	57fd                	li	a5,-1
    800019e4:	17fe                	slli	a5,a5,0x3f
    800019e6:	07a5                	addi	a5,a5,9
    800019e8:	00f70c63          	beq	a4,a5,80001a00 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019ec:	57fd                	li	a5,-1
    800019ee:	17fe                	slli	a5,a5,0x3f
    800019f0:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019f2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019f4:	04f70e63          	beq	a4,a5,80001a50 <devintr+0x7a>
  }
}
    800019f8:	60e2                	ld	ra,24(sp)
    800019fa:	6442                	ld	s0,16(sp)
    800019fc:	6105                	addi	sp,sp,32
    800019fe:	8082                	ret
    80001a00:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001a02:	70d020ef          	jal	8000490e <plic_claim>
    80001a06:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a08:	47a9                	li	a5,10
    80001a0a:	00f50d63          	beq	a0,a5,80001a24 <devintr+0x4e>
    } else if(irq == VIRTIO0_IRQ){
    80001a0e:	4785                	li	a5,1
    80001a10:	02f50263          	beq	a0,a5,80001a34 <devintr+0x5e>
    else if(irq == E1000_IRQ){
    80001a14:	02100793          	li	a5,33
    80001a18:	02f50163          	beq	a0,a5,80001a3a <devintr+0x64>
    return 1;
    80001a1c:	4505                	li	a0,1
    else if(irq){
    80001a1e:	e08d                	bnez	s1,80001a40 <devintr+0x6a>
    80001a20:	64a2                	ld	s1,8(sp)
    80001a22:	bfd9                	j	800019f8 <devintr+0x22>
      uartintr();
    80001a24:	597040ef          	jal	800067ba <uartintr>
      plic_complete(irq);
    80001a28:	8526                	mv	a0,s1
    80001a2a:	705020ef          	jal	8000492e <plic_complete>
    return 1;
    80001a2e:	4505                	li	a0,1
    80001a30:	64a2                	ld	s1,8(sp)
    80001a32:	b7d9                	j	800019f8 <devintr+0x22>
      virtio_disk_intr();
    80001a34:	3a0030ef          	jal	80004dd4 <virtio_disk_intr>
    if(irq)
    80001a38:	bfc5                	j	80001a28 <devintr+0x52>
      e1000_intr();
    80001a3a:	684030ef          	jal	800050be <e1000_intr>
    if(irq)
    80001a3e:	b7ed                	j	80001a28 <devintr+0x52>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a40:	85a6                	mv	a1,s1
    80001a42:	00006517          	auipc	a0,0x6
    80001a46:	7c650513          	addi	a0,a0,1990 # 80008208 <etext+0x208>
    80001a4a:	0bb040ef          	jal	80006304 <printf>
    if(irq)
    80001a4e:	bfe9                	j	80001a28 <devintr+0x52>
    clockintr();
    80001a50:	f33ff0ef          	jal	80001982 <clockintr>
    return 2;
    80001a54:	4509                	li	a0,2
    80001a56:	b74d                	j	800019f8 <devintr+0x22>

0000000080001a58 <usertrap>:
{
    80001a58:	1101                	addi	sp,sp,-32
    80001a5a:	ec06                	sd	ra,24(sp)
    80001a5c:	e822                	sd	s0,16(sp)
    80001a5e:	e426                	sd	s1,8(sp)
    80001a60:	e04a                	sd	s2,0(sp)
    80001a62:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a64:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a68:	1007f793          	andi	a5,a5,256
    80001a6c:	eba5                	bnez	a5,80001adc <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a6e:	00003797          	auipc	a5,0x3
    80001a72:	dd278793          	addi	a5,a5,-558 # 80004840 <kernelvec>
    80001a76:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a7a:	b5cff0ef          	jal	80000dd6 <myproc>
    80001a7e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a80:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a82:	14102773          	csrr	a4,sepc
    80001a86:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a88:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a8c:	47a1                	li	a5,8
    80001a8e:	04f70d63          	beq	a4,a5,80001ae8 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001a92:	f45ff0ef          	jal	800019d6 <devintr>
    80001a96:	892a                	mv	s2,a0
    80001a98:	e945                	bnez	a0,80001b48 <usertrap+0xf0>
    80001a9a:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001a9e:	47bd                	li	a5,15
    80001aa0:	08f70863          	beq	a4,a5,80001b30 <usertrap+0xd8>
    80001aa4:	14202773          	csrr	a4,scause
    80001aa8:	47b5                	li	a5,13
    80001aaa:	08f70363          	beq	a4,a5,80001b30 <usertrap+0xd8>
    80001aae:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001ab2:	5890                	lw	a2,48(s1)
    80001ab4:	00006517          	auipc	a0,0x6
    80001ab8:	79450513          	addi	a0,a0,1940 # 80008248 <etext+0x248>
    80001abc:	049040ef          	jal	80006304 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ac0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ac4:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001ac8:	00006517          	auipc	a0,0x6
    80001acc:	7b050513          	addi	a0,a0,1968 # 80008278 <etext+0x278>
    80001ad0:	035040ef          	jal	80006304 <printf>
    setkilled(p);
    80001ad4:	8526                	mv	a0,s1
    80001ad6:	b0dff0ef          	jal	800015e2 <setkilled>
    80001ada:	a035                	j	80001b06 <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001adc:	00006517          	auipc	a0,0x6
    80001ae0:	74c50513          	addi	a0,a0,1868 # 80008228 <etext+0x228>
    80001ae4:	307040ef          	jal	800065ea <panic>
    if(killed(p))
    80001ae8:	b1fff0ef          	jal	80001606 <killed>
    80001aec:	ed15                	bnez	a0,80001b28 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001aee:	6cb8                	ld	a4,88(s1)
    80001af0:	6f1c                	ld	a5,24(a4)
    80001af2:	0791                	addi	a5,a5,4
    80001af4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001af6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001afa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001afe:	10079073          	csrw	sstatus,a5
    syscall();
    80001b02:	246000ef          	jal	80001d48 <syscall>
  if(killed(p))
    80001b06:	8526                	mv	a0,s1
    80001b08:	affff0ef          	jal	80001606 <killed>
    80001b0c:	e139                	bnez	a0,80001b52 <usertrap+0xfa>
  prepare_return();
    80001b0e:	dfbff0ef          	jal	80001908 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b12:	68a8                	ld	a0,80(s1)
    80001b14:	8131                	srli	a0,a0,0xc
    80001b16:	57fd                	li	a5,-1
    80001b18:	17fe                	slli	a5,a5,0x3f
    80001b1a:	8d5d                	or	a0,a0,a5
}
    80001b1c:	60e2                	ld	ra,24(sp)
    80001b1e:	6442                	ld	s0,16(sp)
    80001b20:	64a2                	ld	s1,8(sp)
    80001b22:	6902                	ld	s2,0(sp)
    80001b24:	6105                	addi	sp,sp,32
    80001b26:	8082                	ret
      kexit(-1);
    80001b28:	557d                	li	a0,-1
    80001b2a:	9b1ff0ef          	jal	800014da <kexit>
    80001b2e:	b7c1                	j	80001aee <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b30:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b34:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001b38:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001b3a:	00163613          	seqz	a2,a2
    80001b3e:	68a8                	ld	a0,80(s1)
    80001b40:	f1dfe0ef          	jal	80000a5c <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b44:	f169                	bnez	a0,80001b06 <usertrap+0xae>
    80001b46:	b7a5                	j	80001aae <usertrap+0x56>
  if(killed(p))
    80001b48:	8526                	mv	a0,s1
    80001b4a:	abdff0ef          	jal	80001606 <killed>
    80001b4e:	c511                	beqz	a0,80001b5a <usertrap+0x102>
    80001b50:	a011                	j	80001b54 <usertrap+0xfc>
    80001b52:	4901                	li	s2,0
    kexit(-1);
    80001b54:	557d                	li	a0,-1
    80001b56:	985ff0ef          	jal	800014da <kexit>
  if(which_dev == 2)
    80001b5a:	4789                	li	a5,2
    80001b5c:	faf919e3          	bne	s2,a5,80001b0e <usertrap+0xb6>
    yield();
    80001b60:	843ff0ef          	jal	800013a2 <yield>
    80001b64:	b76d                	j	80001b0e <usertrap+0xb6>

0000000080001b66 <kerneltrap>:
{
    80001b66:	7179                	addi	sp,sp,-48
    80001b68:	f406                	sd	ra,40(sp)
    80001b6a:	f022                	sd	s0,32(sp)
    80001b6c:	ec26                	sd	s1,24(sp)
    80001b6e:	e84a                	sd	s2,16(sp)
    80001b70:	e44e                	sd	s3,8(sp)
    80001b72:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b74:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b78:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b7c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b80:	1004f793          	andi	a5,s1,256
    80001b84:	c795                	beqz	a5,80001bb0 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b86:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b8a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b8c:	eb85                	bnez	a5,80001bbc <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b8e:	e49ff0ef          	jal	800019d6 <devintr>
    80001b92:	c91d                	beqz	a0,80001bc8 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b94:	4789                	li	a5,2
    80001b96:	04f50a63          	beq	a0,a5,80001bea <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b9a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b9e:	10049073          	csrw	sstatus,s1
}
    80001ba2:	70a2                	ld	ra,40(sp)
    80001ba4:	7402                	ld	s0,32(sp)
    80001ba6:	64e2                	ld	s1,24(sp)
    80001ba8:	6942                	ld	s2,16(sp)
    80001baa:	69a2                	ld	s3,8(sp)
    80001bac:	6145                	addi	sp,sp,48
    80001bae:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001bb0:	00006517          	auipc	a0,0x6
    80001bb4:	6f050513          	addi	a0,a0,1776 # 800082a0 <etext+0x2a0>
    80001bb8:	233040ef          	jal	800065ea <panic>
    panic("kerneltrap: interrupts enabled");
    80001bbc:	00006517          	auipc	a0,0x6
    80001bc0:	70c50513          	addi	a0,a0,1804 # 800082c8 <etext+0x2c8>
    80001bc4:	227040ef          	jal	800065ea <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001bc8:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001bcc:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001bd0:	85ce                	mv	a1,s3
    80001bd2:	00006517          	auipc	a0,0x6
    80001bd6:	71650513          	addi	a0,a0,1814 # 800082e8 <etext+0x2e8>
    80001bda:	72a040ef          	jal	80006304 <printf>
    panic("kerneltrap");
    80001bde:	00006517          	auipc	a0,0x6
    80001be2:	73250513          	addi	a0,a0,1842 # 80008310 <etext+0x310>
    80001be6:	205040ef          	jal	800065ea <panic>
  if(which_dev == 2 && myproc() != 0)
    80001bea:	9ecff0ef          	jal	80000dd6 <myproc>
    80001bee:	d555                	beqz	a0,80001b9a <kerneltrap+0x34>
    yield();
    80001bf0:	fb2ff0ef          	jal	800013a2 <yield>
    80001bf4:	b75d                	j	80001b9a <kerneltrap+0x34>

0000000080001bf6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001bf6:	1101                	addi	sp,sp,-32
    80001bf8:	ec06                	sd	ra,24(sp)
    80001bfa:	e822                	sd	s0,16(sp)
    80001bfc:	e426                	sd	s1,8(sp)
    80001bfe:	1000                	addi	s0,sp,32
    80001c00:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c02:	9d4ff0ef          	jal	80000dd6 <myproc>
  switch (n) {
    80001c06:	4795                	li	a5,5
    80001c08:	0497e163          	bltu	a5,s1,80001c4a <argraw+0x54>
    80001c0c:	048a                	slli	s1,s1,0x2
    80001c0e:	00007717          	auipc	a4,0x7
    80001c12:	dca70713          	addi	a4,a4,-566 # 800089d8 <states.0+0x30>
    80001c16:	94ba                	add	s1,s1,a4
    80001c18:	409c                	lw	a5,0(s1)
    80001c1a:	97ba                	add	a5,a5,a4
    80001c1c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001c1e:	6d3c                	ld	a5,88(a0)
    80001c20:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001c22:	60e2                	ld	ra,24(sp)
    80001c24:	6442                	ld	s0,16(sp)
    80001c26:	64a2                	ld	s1,8(sp)
    80001c28:	6105                	addi	sp,sp,32
    80001c2a:	8082                	ret
    return p->trapframe->a1;
    80001c2c:	6d3c                	ld	a5,88(a0)
    80001c2e:	7fa8                	ld	a0,120(a5)
    80001c30:	bfcd                	j	80001c22 <argraw+0x2c>
    return p->trapframe->a2;
    80001c32:	6d3c                	ld	a5,88(a0)
    80001c34:	63c8                	ld	a0,128(a5)
    80001c36:	b7f5                	j	80001c22 <argraw+0x2c>
    return p->trapframe->a3;
    80001c38:	6d3c                	ld	a5,88(a0)
    80001c3a:	67c8                	ld	a0,136(a5)
    80001c3c:	b7dd                	j	80001c22 <argraw+0x2c>
    return p->trapframe->a4;
    80001c3e:	6d3c                	ld	a5,88(a0)
    80001c40:	6bc8                	ld	a0,144(a5)
    80001c42:	b7c5                	j	80001c22 <argraw+0x2c>
    return p->trapframe->a5;
    80001c44:	6d3c                	ld	a5,88(a0)
    80001c46:	6fc8                	ld	a0,152(a5)
    80001c48:	bfe9                	j	80001c22 <argraw+0x2c>
  panic("argraw");
    80001c4a:	00006517          	auipc	a0,0x6
    80001c4e:	6d650513          	addi	a0,a0,1750 # 80008320 <etext+0x320>
    80001c52:	199040ef          	jal	800065ea <panic>

0000000080001c56 <fetchaddr>:
{
    80001c56:	1101                	addi	sp,sp,-32
    80001c58:	ec06                	sd	ra,24(sp)
    80001c5a:	e822                	sd	s0,16(sp)
    80001c5c:	e426                	sd	s1,8(sp)
    80001c5e:	e04a                	sd	s2,0(sp)
    80001c60:	1000                	addi	s0,sp,32
    80001c62:	84aa                	mv	s1,a0
    80001c64:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c66:	970ff0ef          	jal	80000dd6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c6a:	653c                	ld	a5,72(a0)
    80001c6c:	02f4f663          	bgeu	s1,a5,80001c98 <fetchaddr+0x42>
    80001c70:	00848713          	addi	a4,s1,8
    80001c74:	02e7e463          	bltu	a5,a4,80001c9c <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c78:	46a1                	li	a3,8
    80001c7a:	8626                	mv	a2,s1
    80001c7c:	85ca                	mv	a1,s2
    80001c7e:	6928                	ld	a0,80(a0)
    80001c80:	f53fe0ef          	jal	80000bd2 <copyin>
    80001c84:	00a03533          	snez	a0,a0
    80001c88:	40a00533          	neg	a0,a0
}
    80001c8c:	60e2                	ld	ra,24(sp)
    80001c8e:	6442                	ld	s0,16(sp)
    80001c90:	64a2                	ld	s1,8(sp)
    80001c92:	6902                	ld	s2,0(sp)
    80001c94:	6105                	addi	sp,sp,32
    80001c96:	8082                	ret
    return -1;
    80001c98:	557d                	li	a0,-1
    80001c9a:	bfcd                	j	80001c8c <fetchaddr+0x36>
    80001c9c:	557d                	li	a0,-1
    80001c9e:	b7fd                	j	80001c8c <fetchaddr+0x36>

0000000080001ca0 <fetchstr>:
{
    80001ca0:	7179                	addi	sp,sp,-48
    80001ca2:	f406                	sd	ra,40(sp)
    80001ca4:	f022                	sd	s0,32(sp)
    80001ca6:	ec26                	sd	s1,24(sp)
    80001ca8:	e84a                	sd	s2,16(sp)
    80001caa:	e44e                	sd	s3,8(sp)
    80001cac:	1800                	addi	s0,sp,48
    80001cae:	892a                	mv	s2,a0
    80001cb0:	84ae                	mv	s1,a1
    80001cb2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001cb4:	922ff0ef          	jal	80000dd6 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001cb8:	86ce                	mv	a3,s3
    80001cba:	864a                	mv	a2,s2
    80001cbc:	85a6                	mv	a1,s1
    80001cbe:	6928                	ld	a0,80(a0)
    80001cc0:	cc5fe0ef          	jal	80000984 <copyinstr>
    80001cc4:	00054c63          	bltz	a0,80001cdc <fetchstr+0x3c>
  return strlen(buf);
    80001cc8:	8526                	mv	a0,s1
    80001cca:	df4fe0ef          	jal	800002be <strlen>
}
    80001cce:	70a2                	ld	ra,40(sp)
    80001cd0:	7402                	ld	s0,32(sp)
    80001cd2:	64e2                	ld	s1,24(sp)
    80001cd4:	6942                	ld	s2,16(sp)
    80001cd6:	69a2                	ld	s3,8(sp)
    80001cd8:	6145                	addi	sp,sp,48
    80001cda:	8082                	ret
    return -1;
    80001cdc:	557d                	li	a0,-1
    80001cde:	bfc5                	j	80001cce <fetchstr+0x2e>

0000000080001ce0 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001ce0:	1101                	addi	sp,sp,-32
    80001ce2:	ec06                	sd	ra,24(sp)
    80001ce4:	e822                	sd	s0,16(sp)
    80001ce6:	e426                	sd	s1,8(sp)
    80001ce8:	1000                	addi	s0,sp,32
    80001cea:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cec:	f0bff0ef          	jal	80001bf6 <argraw>
    80001cf0:	c088                	sw	a0,0(s1)
}
    80001cf2:	60e2                	ld	ra,24(sp)
    80001cf4:	6442                	ld	s0,16(sp)
    80001cf6:	64a2                	ld	s1,8(sp)
    80001cf8:	6105                	addi	sp,sp,32
    80001cfa:	8082                	ret

0000000080001cfc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cfc:	1101                	addi	sp,sp,-32
    80001cfe:	ec06                	sd	ra,24(sp)
    80001d00:	e822                	sd	s0,16(sp)
    80001d02:	e426                	sd	s1,8(sp)
    80001d04:	1000                	addi	s0,sp,32
    80001d06:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d08:	eefff0ef          	jal	80001bf6 <argraw>
    80001d0c:	e088                	sd	a0,0(s1)
}
    80001d0e:	60e2                	ld	ra,24(sp)
    80001d10:	6442                	ld	s0,16(sp)
    80001d12:	64a2                	ld	s1,8(sp)
    80001d14:	6105                	addi	sp,sp,32
    80001d16:	8082                	ret

0000000080001d18 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001d18:	7179                	addi	sp,sp,-48
    80001d1a:	f406                	sd	ra,40(sp)
    80001d1c:	f022                	sd	s0,32(sp)
    80001d1e:	ec26                	sd	s1,24(sp)
    80001d20:	e84a                	sd	s2,16(sp)
    80001d22:	1800                	addi	s0,sp,48
    80001d24:	84ae                	mv	s1,a1
    80001d26:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001d28:	fd840593          	addi	a1,s0,-40
    80001d2c:	fd1ff0ef          	jal	80001cfc <argaddr>
  return fetchstr(addr, buf, max);
    80001d30:	864a                	mv	a2,s2
    80001d32:	85a6                	mv	a1,s1
    80001d34:	fd843503          	ld	a0,-40(s0)
    80001d38:	f69ff0ef          	jal	80001ca0 <fetchstr>
}
    80001d3c:	70a2                	ld	ra,40(sp)
    80001d3e:	7402                	ld	s0,32(sp)
    80001d40:	64e2                	ld	s1,24(sp)
    80001d42:	6942                	ld	s2,16(sp)
    80001d44:	6145                	addi	sp,sp,48
    80001d46:	8082                	ret

0000000080001d48 <syscall>:
};


void
syscall(void)
{
    80001d48:	1101                	addi	sp,sp,-32
    80001d4a:	ec06                	sd	ra,24(sp)
    80001d4c:	e822                	sd	s0,16(sp)
    80001d4e:	e426                	sd	s1,8(sp)
    80001d50:	e04a                	sd	s2,0(sp)
    80001d52:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001d54:	882ff0ef          	jal	80000dd6 <myproc>
    80001d58:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d5a:	05853903          	ld	s2,88(a0)
    80001d5e:	0a893783          	ld	a5,168(s2)
    80001d62:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d66:	37fd                	addiw	a5,a5,-1
    80001d68:	477d                	li	a4,31
    80001d6a:	00f76f63          	bltu	a4,a5,80001d88 <syscall+0x40>
    80001d6e:	00369713          	slli	a4,a3,0x3
    80001d72:	00007797          	auipc	a5,0x7
    80001d76:	c7e78793          	addi	a5,a5,-898 # 800089f0 <syscalls>
    80001d7a:	97ba                	add	a5,a5,a4
    80001d7c:	639c                	ld	a5,0(a5)
    80001d7e:	c789                	beqz	a5,80001d88 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d80:	9782                	jalr	a5
    80001d82:	06a93823          	sd	a0,112(s2)
    80001d86:	a829                	j	80001da0 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d88:	15848613          	addi	a2,s1,344
    80001d8c:	588c                	lw	a1,48(s1)
    80001d8e:	00006517          	auipc	a0,0x6
    80001d92:	59a50513          	addi	a0,a0,1434 # 80008328 <etext+0x328>
    80001d96:	56e040ef          	jal	80006304 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d9a:	6cbc                	ld	a5,88(s1)
    80001d9c:	577d                	li	a4,-1
    80001d9e:	fbb8                	sd	a4,112(a5)
  }
}
    80001da0:	60e2                	ld	ra,24(sp)
    80001da2:	6442                	ld	s0,16(sp)
    80001da4:	64a2                	ld	s1,8(sp)
    80001da6:	6902                	ld	s2,0(sp)
    80001da8:	6105                	addi	sp,sp,32
    80001daa:	8082                	ret

0000000080001dac <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80001dac:	1101                	addi	sp,sp,-32
    80001dae:	ec06                	sd	ra,24(sp)
    80001db0:	e822                	sd	s0,16(sp)
    80001db2:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001db4:	fec40593          	addi	a1,s0,-20
    80001db8:	4501                	li	a0,0
    80001dba:	f27ff0ef          	jal	80001ce0 <argint>
  kexit(n);
    80001dbe:	fec42503          	lw	a0,-20(s0)
    80001dc2:	f18ff0ef          	jal	800014da <kexit>
  return 0;  // not reached
}
    80001dc6:	4501                	li	a0,0
    80001dc8:	60e2                	ld	ra,24(sp)
    80001dca:	6442                	ld	s0,16(sp)
    80001dcc:	6105                	addi	sp,sp,32
    80001dce:	8082                	ret

0000000080001dd0 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001dd0:	1141                	addi	sp,sp,-16
    80001dd2:	e406                	sd	ra,8(sp)
    80001dd4:	e022                	sd	s0,0(sp)
    80001dd6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001dd8:	ffffe0ef          	jal	80000dd6 <myproc>
}
    80001ddc:	5908                	lw	a0,48(a0)
    80001dde:	60a2                	ld	ra,8(sp)
    80001de0:	6402                	ld	s0,0(sp)
    80001de2:	0141                	addi	sp,sp,16
    80001de4:	8082                	ret

0000000080001de6 <sys_fork>:

uint64
sys_fork(void)
{
    80001de6:	1141                	addi	sp,sp,-16
    80001de8:	e406                	sd	ra,8(sp)
    80001dea:	e022                	sd	s0,0(sp)
    80001dec:	0800                	addi	s0,sp,16
  return kfork();
    80001dee:	b3aff0ef          	jal	80001128 <kfork>
}
    80001df2:	60a2                	ld	ra,8(sp)
    80001df4:	6402                	ld	s0,0(sp)
    80001df6:	0141                	addi	sp,sp,16
    80001df8:	8082                	ret

0000000080001dfa <sys_wait>:

uint64
sys_wait(void)
{
    80001dfa:	1101                	addi	sp,sp,-32
    80001dfc:	ec06                	sd	ra,24(sp)
    80001dfe:	e822                	sd	s0,16(sp)
    80001e00:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e02:	fe840593          	addi	a1,s0,-24
    80001e06:	4501                	li	a0,0
    80001e08:	ef5ff0ef          	jal	80001cfc <argaddr>
  return kwait(p);
    80001e0c:	fe843503          	ld	a0,-24(s0)
    80001e10:	821ff0ef          	jal	80001630 <kwait>
}
    80001e14:	60e2                	ld	ra,24(sp)
    80001e16:	6442                	ld	s0,16(sp)
    80001e18:	6105                	addi	sp,sp,32
    80001e1a:	8082                	ret

0000000080001e1c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e1c:	7179                	addi	sp,sp,-48
    80001e1e:	f406                	sd	ra,40(sp)
    80001e20:	f022                	sd	s0,32(sp)
    80001e22:	ec26                	sd	s1,24(sp)
    80001e24:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001e26:	fd840593          	addi	a1,s0,-40
    80001e2a:	4501                	li	a0,0
    80001e2c:	eb5ff0ef          	jal	80001ce0 <argint>
  argint(1, &t);
    80001e30:	fdc40593          	addi	a1,s0,-36
    80001e34:	4505                	li	a0,1
    80001e36:	eabff0ef          	jal	80001ce0 <argint>
  addr = myproc()->sz;
    80001e3a:	f9dfe0ef          	jal	80000dd6 <myproc>
    80001e3e:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80001e40:	fdc42703          	lw	a4,-36(s0)
    80001e44:	4785                	li	a5,1
    80001e46:	02f70163          	beq	a4,a5,80001e68 <sys_sbrk+0x4c>
    80001e4a:	fd842783          	lw	a5,-40(s0)
    80001e4e:	0007cd63          	bltz	a5,80001e68 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80001e52:	97a6                	add	a5,a5,s1
    80001e54:	0297e863          	bltu	a5,s1,80001e84 <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001e58:	f7ffe0ef          	jal	80000dd6 <myproc>
    80001e5c:	fd842703          	lw	a4,-40(s0)
    80001e60:	653c                	ld	a5,72(a0)
    80001e62:	97ba                	add	a5,a5,a4
    80001e64:	e53c                	sd	a5,72(a0)
    80001e66:	a039                	j	80001e74 <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80001e68:	fd842503          	lw	a0,-40(s0)
    80001e6c:	a6cff0ef          	jal	800010d8 <growproc>
    80001e70:	00054863          	bltz	a0,80001e80 <sys_sbrk+0x64>
  }
  return addr;
}
    80001e74:	8526                	mv	a0,s1
    80001e76:	70a2                	ld	ra,40(sp)
    80001e78:	7402                	ld	s0,32(sp)
    80001e7a:	64e2                	ld	s1,24(sp)
    80001e7c:	6145                	addi	sp,sp,48
    80001e7e:	8082                	ret
      return -1;
    80001e80:	54fd                	li	s1,-1
    80001e82:	bfcd                	j	80001e74 <sys_sbrk+0x58>
      return -1;
    80001e84:	54fd                	li	s1,-1
    80001e86:	b7fd                	j	80001e74 <sys_sbrk+0x58>

0000000080001e88 <sys_pause>:

uint64
sys_pause(void)
{
    80001e88:	7139                	addi	sp,sp,-64
    80001e8a:	fc06                	sd	ra,56(sp)
    80001e8c:	f822                	sd	s0,48(sp)
    80001e8e:	f04a                	sd	s2,32(sp)
    80001e90:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e92:	fcc40593          	addi	a1,s0,-52
    80001e96:	4501                	li	a0,0
    80001e98:	e49ff0ef          	jal	80001ce0 <argint>
  if(n < 0)
    80001e9c:	fcc42783          	lw	a5,-52(s0)
    80001ea0:	0607c763          	bltz	a5,80001f0e <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80001ea4:	00010517          	auipc	a0,0x10
    80001ea8:	8ec50513          	addi	a0,a0,-1812 # 80011790 <tickslock>
    80001eac:	1fb040ef          	jal	800068a6 <acquire>
  ticks0 = ticks;
    80001eb0:	0000a917          	auipc	s2,0xa
    80001eb4:	a6892903          	lw	s2,-1432(s2) # 8000b918 <ticks>
  while(ticks - ticks0 < n){
    80001eb8:	fcc42783          	lw	a5,-52(s0)
    80001ebc:	cf8d                	beqz	a5,80001ef6 <sys_pause+0x6e>
    80001ebe:	f426                	sd	s1,40(sp)
    80001ec0:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001ec2:	00010997          	auipc	s3,0x10
    80001ec6:	8ce98993          	addi	s3,s3,-1842 # 80011790 <tickslock>
    80001eca:	0000a497          	auipc	s1,0xa
    80001ece:	a4e48493          	addi	s1,s1,-1458 # 8000b918 <ticks>
    if(killed(myproc())){
    80001ed2:	f05fe0ef          	jal	80000dd6 <myproc>
    80001ed6:	f30ff0ef          	jal	80001606 <killed>
    80001eda:	ed0d                	bnez	a0,80001f14 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80001edc:	85ce                	mv	a1,s3
    80001ede:	8526                	mv	a0,s1
    80001ee0:	ceeff0ef          	jal	800013ce <sleep>
  while(ticks - ticks0 < n){
    80001ee4:	409c                	lw	a5,0(s1)
    80001ee6:	412787bb          	subw	a5,a5,s2
    80001eea:	fcc42703          	lw	a4,-52(s0)
    80001eee:	fee7e2e3          	bltu	a5,a4,80001ed2 <sys_pause+0x4a>
    80001ef2:	74a2                	ld	s1,40(sp)
    80001ef4:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001ef6:	00010517          	auipc	a0,0x10
    80001efa:	89a50513          	addi	a0,a0,-1894 # 80011790 <tickslock>
    80001efe:	241040ef          	jal	8000693e <release>
  return 0;
    80001f02:	4501                	li	a0,0
}
    80001f04:	70e2                	ld	ra,56(sp)
    80001f06:	7442                	ld	s0,48(sp)
    80001f08:	7902                	ld	s2,32(sp)
    80001f0a:	6121                	addi	sp,sp,64
    80001f0c:	8082                	ret
    n = 0;
    80001f0e:	fc042623          	sw	zero,-52(s0)
    80001f12:	bf49                	j	80001ea4 <sys_pause+0x1c>
      release(&tickslock);
    80001f14:	00010517          	auipc	a0,0x10
    80001f18:	87c50513          	addi	a0,a0,-1924 # 80011790 <tickslock>
    80001f1c:	223040ef          	jal	8000693e <release>
      return -1;
    80001f20:	557d                	li	a0,-1
    80001f22:	74a2                	ld	s1,40(sp)
    80001f24:	69e2                	ld	s3,24(sp)
    80001f26:	bff9                	j	80001f04 <sys_pause+0x7c>

0000000080001f28 <sys_kill>:

uint64
sys_kill(void)
{
    80001f28:	1101                	addi	sp,sp,-32
    80001f2a:	ec06                	sd	ra,24(sp)
    80001f2c:	e822                	sd	s0,16(sp)
    80001f2e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001f30:	fec40593          	addi	a1,s0,-20
    80001f34:	4501                	li	a0,0
    80001f36:	dabff0ef          	jal	80001ce0 <argint>
  return kkill(pid);
    80001f3a:	fec42503          	lw	a0,-20(s0)
    80001f3e:	e3eff0ef          	jal	8000157c <kkill>
}
    80001f42:	60e2                	ld	ra,24(sp)
    80001f44:	6442                	ld	s0,16(sp)
    80001f46:	6105                	addi	sp,sp,32
    80001f48:	8082                	ret

0000000080001f4a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f4a:	1101                	addi	sp,sp,-32
    80001f4c:	ec06                	sd	ra,24(sp)
    80001f4e:	e822                	sd	s0,16(sp)
    80001f50:	e426                	sd	s1,8(sp)
    80001f52:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f54:	00010517          	auipc	a0,0x10
    80001f58:	83c50513          	addi	a0,a0,-1988 # 80011790 <tickslock>
    80001f5c:	14b040ef          	jal	800068a6 <acquire>
  xticks = ticks;
    80001f60:	0000a497          	auipc	s1,0xa
    80001f64:	9b84a483          	lw	s1,-1608(s1) # 8000b918 <ticks>
  release(&tickslock);
    80001f68:	00010517          	auipc	a0,0x10
    80001f6c:	82850513          	addi	a0,a0,-2008 # 80011790 <tickslock>
    80001f70:	1cf040ef          	jal	8000693e <release>
  return xticks;
}
    80001f74:	02049513          	slli	a0,s1,0x20
    80001f78:	9101                	srli	a0,a0,0x20
    80001f7a:	60e2                	ld	ra,24(sp)
    80001f7c:	6442                	ld	s0,16(sp)
    80001f7e:	64a2                	ld	s1,8(sp)
    80001f80:	6105                	addi	sp,sp,32
    80001f82:	8082                	ret

0000000080001f84 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f84:	7179                	addi	sp,sp,-48
    80001f86:	f406                	sd	ra,40(sp)
    80001f88:	f022                	sd	s0,32(sp)
    80001f8a:	ec26                	sd	s1,24(sp)
    80001f8c:	e84a                	sd	s2,16(sp)
    80001f8e:	e44e                	sd	s3,8(sp)
    80001f90:	e052                	sd	s4,0(sp)
    80001f92:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001f94:	00006597          	auipc	a1,0x6
    80001f98:	3b458593          	addi	a1,a1,948 # 80008348 <etext+0x348>
    80001f9c:	00010517          	auipc	a0,0x10
    80001fa0:	80c50513          	addi	a0,a0,-2036 # 800117a8 <bcache>
    80001fa4:	083040ef          	jal	80006826 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001fa8:	00018797          	auipc	a5,0x18
    80001fac:	80078793          	addi	a5,a5,-2048 # 800197a8 <bcache+0x8000>
    80001fb0:	00018717          	auipc	a4,0x18
    80001fb4:	a6070713          	addi	a4,a4,-1440 # 80019a10 <bcache+0x8268>
    80001fb8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001fbc:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fc0:	00010497          	auipc	s1,0x10
    80001fc4:	80048493          	addi	s1,s1,-2048 # 800117c0 <bcache+0x18>
    b->next = bcache.head.next;
    80001fc8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001fca:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001fcc:	00006a17          	auipc	s4,0x6
    80001fd0:	384a0a13          	addi	s4,s4,900 # 80008350 <etext+0x350>
    b->next = bcache.head.next;
    80001fd4:	2b893783          	ld	a5,696(s2)
    80001fd8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001fda:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001fde:	85d2                	mv	a1,s4
    80001fe0:	01048513          	addi	a0,s1,16
    80001fe4:	322010ef          	jal	80003306 <initsleeplock>
    bcache.head.next->prev = b;
    80001fe8:	2b893783          	ld	a5,696(s2)
    80001fec:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001fee:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ff2:	45848493          	addi	s1,s1,1112
    80001ff6:	fd349fe3          	bne	s1,s3,80001fd4 <binit+0x50>
  }
}
    80001ffa:	70a2                	ld	ra,40(sp)
    80001ffc:	7402                	ld	s0,32(sp)
    80001ffe:	64e2                	ld	s1,24(sp)
    80002000:	6942                	ld	s2,16(sp)
    80002002:	69a2                	ld	s3,8(sp)
    80002004:	6a02                	ld	s4,0(sp)
    80002006:	6145                	addi	sp,sp,48
    80002008:	8082                	ret

000000008000200a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000200a:	7179                	addi	sp,sp,-48
    8000200c:	f406                	sd	ra,40(sp)
    8000200e:	f022                	sd	s0,32(sp)
    80002010:	ec26                	sd	s1,24(sp)
    80002012:	e84a                	sd	s2,16(sp)
    80002014:	e44e                	sd	s3,8(sp)
    80002016:	1800                	addi	s0,sp,48
    80002018:	892a                	mv	s2,a0
    8000201a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000201c:	0000f517          	auipc	a0,0xf
    80002020:	78c50513          	addi	a0,a0,1932 # 800117a8 <bcache>
    80002024:	083040ef          	jal	800068a6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002028:	00018497          	auipc	s1,0x18
    8000202c:	a384b483          	ld	s1,-1480(s1) # 80019a60 <bcache+0x82b8>
    80002030:	00018797          	auipc	a5,0x18
    80002034:	9e078793          	addi	a5,a5,-1568 # 80019a10 <bcache+0x8268>
    80002038:	02f48b63          	beq	s1,a5,8000206e <bread+0x64>
    8000203c:	873e                	mv	a4,a5
    8000203e:	a021                	j	80002046 <bread+0x3c>
    80002040:	68a4                	ld	s1,80(s1)
    80002042:	02e48663          	beq	s1,a4,8000206e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002046:	449c                	lw	a5,8(s1)
    80002048:	ff279ce3          	bne	a5,s2,80002040 <bread+0x36>
    8000204c:	44dc                	lw	a5,12(s1)
    8000204e:	ff3799e3          	bne	a5,s3,80002040 <bread+0x36>
      b->refcnt++;
    80002052:	40bc                	lw	a5,64(s1)
    80002054:	2785                	addiw	a5,a5,1
    80002056:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002058:	0000f517          	auipc	a0,0xf
    8000205c:	75050513          	addi	a0,a0,1872 # 800117a8 <bcache>
    80002060:	0df040ef          	jal	8000693e <release>
      acquiresleep(&b->lock);
    80002064:	01048513          	addi	a0,s1,16
    80002068:	2d4010ef          	jal	8000333c <acquiresleep>
      return b;
    8000206c:	a889                	j	800020be <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000206e:	00018497          	auipc	s1,0x18
    80002072:	9ea4b483          	ld	s1,-1558(s1) # 80019a58 <bcache+0x82b0>
    80002076:	00018797          	auipc	a5,0x18
    8000207a:	99a78793          	addi	a5,a5,-1638 # 80019a10 <bcache+0x8268>
    8000207e:	00f48863          	beq	s1,a5,8000208e <bread+0x84>
    80002082:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002084:	40bc                	lw	a5,64(s1)
    80002086:	cb91                	beqz	a5,8000209a <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002088:	64a4                	ld	s1,72(s1)
    8000208a:	fee49de3          	bne	s1,a4,80002084 <bread+0x7a>
  panic("bget: no buffers");
    8000208e:	00006517          	auipc	a0,0x6
    80002092:	2ca50513          	addi	a0,a0,714 # 80008358 <etext+0x358>
    80002096:	554040ef          	jal	800065ea <panic>
      b->dev = dev;
    8000209a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000209e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800020a2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800020a6:	4785                	li	a5,1
    800020a8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020aa:	0000f517          	auipc	a0,0xf
    800020ae:	6fe50513          	addi	a0,a0,1790 # 800117a8 <bcache>
    800020b2:	08d040ef          	jal	8000693e <release>
      acquiresleep(&b->lock);
    800020b6:	01048513          	addi	a0,s1,16
    800020ba:	282010ef          	jal	8000333c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800020be:	409c                	lw	a5,0(s1)
    800020c0:	cb89                	beqz	a5,800020d2 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800020c2:	8526                	mv	a0,s1
    800020c4:	70a2                	ld	ra,40(sp)
    800020c6:	7402                	ld	s0,32(sp)
    800020c8:	64e2                	ld	s1,24(sp)
    800020ca:	6942                	ld	s2,16(sp)
    800020cc:	69a2                	ld	s3,8(sp)
    800020ce:	6145                	addi	sp,sp,48
    800020d0:	8082                	ret
    virtio_disk_rw(b, 0);
    800020d2:	4581                	li	a1,0
    800020d4:	8526                	mv	a0,s1
    800020d6:	2ed020ef          	jal	80004bc2 <virtio_disk_rw>
    b->valid = 1;
    800020da:	4785                	li	a5,1
    800020dc:	c09c                	sw	a5,0(s1)
  return b;
    800020de:	b7d5                	j	800020c2 <bread+0xb8>

00000000800020e0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800020e0:	1101                	addi	sp,sp,-32
    800020e2:	ec06                	sd	ra,24(sp)
    800020e4:	e822                	sd	s0,16(sp)
    800020e6:	e426                	sd	s1,8(sp)
    800020e8:	1000                	addi	s0,sp,32
    800020ea:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020ec:	0541                	addi	a0,a0,16
    800020ee:	2cc010ef          	jal	800033ba <holdingsleep>
    800020f2:	c911                	beqz	a0,80002106 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800020f4:	4585                	li	a1,1
    800020f6:	8526                	mv	a0,s1
    800020f8:	2cb020ef          	jal	80004bc2 <virtio_disk_rw>
}
    800020fc:	60e2                	ld	ra,24(sp)
    800020fe:	6442                	ld	s0,16(sp)
    80002100:	64a2                	ld	s1,8(sp)
    80002102:	6105                	addi	sp,sp,32
    80002104:	8082                	ret
    panic("bwrite");
    80002106:	00006517          	auipc	a0,0x6
    8000210a:	26a50513          	addi	a0,a0,618 # 80008370 <etext+0x370>
    8000210e:	4dc040ef          	jal	800065ea <panic>

0000000080002112 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002112:	1101                	addi	sp,sp,-32
    80002114:	ec06                	sd	ra,24(sp)
    80002116:	e822                	sd	s0,16(sp)
    80002118:	e426                	sd	s1,8(sp)
    8000211a:	e04a                	sd	s2,0(sp)
    8000211c:	1000                	addi	s0,sp,32
    8000211e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002120:	01050913          	addi	s2,a0,16
    80002124:	854a                	mv	a0,s2
    80002126:	294010ef          	jal	800033ba <holdingsleep>
    8000212a:	c135                	beqz	a0,8000218e <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000212c:	854a                	mv	a0,s2
    8000212e:	254010ef          	jal	80003382 <releasesleep>

  acquire(&bcache.lock);
    80002132:	0000f517          	auipc	a0,0xf
    80002136:	67650513          	addi	a0,a0,1654 # 800117a8 <bcache>
    8000213a:	76c040ef          	jal	800068a6 <acquire>
  b->refcnt--;
    8000213e:	40bc                	lw	a5,64(s1)
    80002140:	37fd                	addiw	a5,a5,-1
    80002142:	0007871b          	sext.w	a4,a5
    80002146:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002148:	e71d                	bnez	a4,80002176 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000214a:	68b8                	ld	a4,80(s1)
    8000214c:	64bc                	ld	a5,72(s1)
    8000214e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002150:	68b8                	ld	a4,80(s1)
    80002152:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002154:	00017797          	auipc	a5,0x17
    80002158:	65478793          	addi	a5,a5,1620 # 800197a8 <bcache+0x8000>
    8000215c:	2b87b703          	ld	a4,696(a5)
    80002160:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002162:	00018717          	auipc	a4,0x18
    80002166:	8ae70713          	addi	a4,a4,-1874 # 80019a10 <bcache+0x8268>
    8000216a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000216c:	2b87b703          	ld	a4,696(a5)
    80002170:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002172:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002176:	0000f517          	auipc	a0,0xf
    8000217a:	63250513          	addi	a0,a0,1586 # 800117a8 <bcache>
    8000217e:	7c0040ef          	jal	8000693e <release>
}
    80002182:	60e2                	ld	ra,24(sp)
    80002184:	6442                	ld	s0,16(sp)
    80002186:	64a2                	ld	s1,8(sp)
    80002188:	6902                	ld	s2,0(sp)
    8000218a:	6105                	addi	sp,sp,32
    8000218c:	8082                	ret
    panic("brelse");
    8000218e:	00006517          	auipc	a0,0x6
    80002192:	1ea50513          	addi	a0,a0,490 # 80008378 <etext+0x378>
    80002196:	454040ef          	jal	800065ea <panic>

000000008000219a <bpin>:

void
bpin(struct buf *b) {
    8000219a:	1101                	addi	sp,sp,-32
    8000219c:	ec06                	sd	ra,24(sp)
    8000219e:	e822                	sd	s0,16(sp)
    800021a0:	e426                	sd	s1,8(sp)
    800021a2:	1000                	addi	s0,sp,32
    800021a4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021a6:	0000f517          	auipc	a0,0xf
    800021aa:	60250513          	addi	a0,a0,1538 # 800117a8 <bcache>
    800021ae:	6f8040ef          	jal	800068a6 <acquire>
  b->refcnt++;
    800021b2:	40bc                	lw	a5,64(s1)
    800021b4:	2785                	addiw	a5,a5,1
    800021b6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021b8:	0000f517          	auipc	a0,0xf
    800021bc:	5f050513          	addi	a0,a0,1520 # 800117a8 <bcache>
    800021c0:	77e040ef          	jal	8000693e <release>
}
    800021c4:	60e2                	ld	ra,24(sp)
    800021c6:	6442                	ld	s0,16(sp)
    800021c8:	64a2                	ld	s1,8(sp)
    800021ca:	6105                	addi	sp,sp,32
    800021cc:	8082                	ret

00000000800021ce <bunpin>:

void
bunpin(struct buf *b) {
    800021ce:	1101                	addi	sp,sp,-32
    800021d0:	ec06                	sd	ra,24(sp)
    800021d2:	e822                	sd	s0,16(sp)
    800021d4:	e426                	sd	s1,8(sp)
    800021d6:	1000                	addi	s0,sp,32
    800021d8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021da:	0000f517          	auipc	a0,0xf
    800021de:	5ce50513          	addi	a0,a0,1486 # 800117a8 <bcache>
    800021e2:	6c4040ef          	jal	800068a6 <acquire>
  b->refcnt--;
    800021e6:	40bc                	lw	a5,64(s1)
    800021e8:	37fd                	addiw	a5,a5,-1
    800021ea:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021ec:	0000f517          	auipc	a0,0xf
    800021f0:	5bc50513          	addi	a0,a0,1468 # 800117a8 <bcache>
    800021f4:	74a040ef          	jal	8000693e <release>
}
    800021f8:	60e2                	ld	ra,24(sp)
    800021fa:	6442                	ld	s0,16(sp)
    800021fc:	64a2                	ld	s1,8(sp)
    800021fe:	6105                	addi	sp,sp,32
    80002200:	8082                	ret

0000000080002202 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002202:	1101                	addi	sp,sp,-32
    80002204:	ec06                	sd	ra,24(sp)
    80002206:	e822                	sd	s0,16(sp)
    80002208:	e426                	sd	s1,8(sp)
    8000220a:	e04a                	sd	s2,0(sp)
    8000220c:	1000                	addi	s0,sp,32
    8000220e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002210:	00d5d59b          	srliw	a1,a1,0xd
    80002214:	00018797          	auipc	a5,0x18
    80002218:	c707a783          	lw	a5,-912(a5) # 80019e84 <sb+0x1c>
    8000221c:	9dbd                	addw	a1,a1,a5
    8000221e:	dedff0ef          	jal	8000200a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002222:	0074f713          	andi	a4,s1,7
    80002226:	4785                	li	a5,1
    80002228:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000222c:	14ce                	slli	s1,s1,0x33
    8000222e:	90d9                	srli	s1,s1,0x36
    80002230:	00950733          	add	a4,a0,s1
    80002234:	05874703          	lbu	a4,88(a4)
    80002238:	00e7f6b3          	and	a3,a5,a4
    8000223c:	c29d                	beqz	a3,80002262 <bfree+0x60>
    8000223e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002240:	94aa                	add	s1,s1,a0
    80002242:	fff7c793          	not	a5,a5
    80002246:	8f7d                	and	a4,a4,a5
    80002248:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000224c:	7f9000ef          	jal	80003244 <log_write>
  brelse(bp);
    80002250:	854a                	mv	a0,s2
    80002252:	ec1ff0ef          	jal	80002112 <brelse>
}
    80002256:	60e2                	ld	ra,24(sp)
    80002258:	6442                	ld	s0,16(sp)
    8000225a:	64a2                	ld	s1,8(sp)
    8000225c:	6902                	ld	s2,0(sp)
    8000225e:	6105                	addi	sp,sp,32
    80002260:	8082                	ret
    panic("freeing free block");
    80002262:	00006517          	auipc	a0,0x6
    80002266:	11e50513          	addi	a0,a0,286 # 80008380 <etext+0x380>
    8000226a:	380040ef          	jal	800065ea <panic>

000000008000226e <balloc>:
{
    8000226e:	711d                	addi	sp,sp,-96
    80002270:	ec86                	sd	ra,88(sp)
    80002272:	e8a2                	sd	s0,80(sp)
    80002274:	e4a6                	sd	s1,72(sp)
    80002276:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002278:	00018797          	auipc	a5,0x18
    8000227c:	bf47a783          	lw	a5,-1036(a5) # 80019e6c <sb+0x4>
    80002280:	0e078f63          	beqz	a5,8000237e <balloc+0x110>
    80002284:	e0ca                	sd	s2,64(sp)
    80002286:	fc4e                	sd	s3,56(sp)
    80002288:	f852                	sd	s4,48(sp)
    8000228a:	f456                	sd	s5,40(sp)
    8000228c:	f05a                	sd	s6,32(sp)
    8000228e:	ec5e                	sd	s7,24(sp)
    80002290:	e862                	sd	s8,16(sp)
    80002292:	e466                	sd	s9,8(sp)
    80002294:	8baa                	mv	s7,a0
    80002296:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002298:	00018b17          	auipc	s6,0x18
    8000229c:	bd0b0b13          	addi	s6,s6,-1072 # 80019e68 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022a0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800022a2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022a4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800022a6:	6c89                	lui	s9,0x2
    800022a8:	a0b5                	j	80002314 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800022aa:	97ca                	add	a5,a5,s2
    800022ac:	8e55                	or	a2,a2,a3
    800022ae:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800022b2:	854a                	mv	a0,s2
    800022b4:	791000ef          	jal	80003244 <log_write>
        brelse(bp);
    800022b8:	854a                	mv	a0,s2
    800022ba:	e59ff0ef          	jal	80002112 <brelse>
  bp = bread(dev, bno);
    800022be:	85a6                	mv	a1,s1
    800022c0:	855e                	mv	a0,s7
    800022c2:	d49ff0ef          	jal	8000200a <bread>
    800022c6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800022c8:	40000613          	li	a2,1024
    800022cc:	4581                	li	a1,0
    800022ce:	05850513          	addi	a0,a0,88
    800022d2:	e7dfd0ef          	jal	8000014e <memset>
  log_write(bp);
    800022d6:	854a                	mv	a0,s2
    800022d8:	76d000ef          	jal	80003244 <log_write>
  brelse(bp);
    800022dc:	854a                	mv	a0,s2
    800022de:	e35ff0ef          	jal	80002112 <brelse>
}
    800022e2:	6906                	ld	s2,64(sp)
    800022e4:	79e2                	ld	s3,56(sp)
    800022e6:	7a42                	ld	s4,48(sp)
    800022e8:	7aa2                	ld	s5,40(sp)
    800022ea:	7b02                	ld	s6,32(sp)
    800022ec:	6be2                	ld	s7,24(sp)
    800022ee:	6c42                	ld	s8,16(sp)
    800022f0:	6ca2                	ld	s9,8(sp)
}
    800022f2:	8526                	mv	a0,s1
    800022f4:	60e6                	ld	ra,88(sp)
    800022f6:	6446                	ld	s0,80(sp)
    800022f8:	64a6                	ld	s1,72(sp)
    800022fa:	6125                	addi	sp,sp,96
    800022fc:	8082                	ret
    brelse(bp);
    800022fe:	854a                	mv	a0,s2
    80002300:	e13ff0ef          	jal	80002112 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002304:	015c87bb          	addw	a5,s9,s5
    80002308:	00078a9b          	sext.w	s5,a5
    8000230c:	004b2703          	lw	a4,4(s6)
    80002310:	04eaff63          	bgeu	s5,a4,8000236e <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002314:	41fad79b          	sraiw	a5,s5,0x1f
    80002318:	0137d79b          	srliw	a5,a5,0x13
    8000231c:	015787bb          	addw	a5,a5,s5
    80002320:	40d7d79b          	sraiw	a5,a5,0xd
    80002324:	01cb2583          	lw	a1,28(s6)
    80002328:	9dbd                	addw	a1,a1,a5
    8000232a:	855e                	mv	a0,s7
    8000232c:	cdfff0ef          	jal	8000200a <bread>
    80002330:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002332:	004b2503          	lw	a0,4(s6)
    80002336:	000a849b          	sext.w	s1,s5
    8000233a:	8762                	mv	a4,s8
    8000233c:	fca4f1e3          	bgeu	s1,a0,800022fe <balloc+0x90>
      m = 1 << (bi % 8);
    80002340:	00777693          	andi	a3,a4,7
    80002344:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002348:	41f7579b          	sraiw	a5,a4,0x1f
    8000234c:	01d7d79b          	srliw	a5,a5,0x1d
    80002350:	9fb9                	addw	a5,a5,a4
    80002352:	4037d79b          	sraiw	a5,a5,0x3
    80002356:	00f90633          	add	a2,s2,a5
    8000235a:	05864603          	lbu	a2,88(a2)
    8000235e:	00c6f5b3          	and	a1,a3,a2
    80002362:	d5a1                	beqz	a1,800022aa <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002364:	2705                	addiw	a4,a4,1
    80002366:	2485                	addiw	s1,s1,1
    80002368:	fd471ae3          	bne	a4,s4,8000233c <balloc+0xce>
    8000236c:	bf49                	j	800022fe <balloc+0x90>
    8000236e:	6906                	ld	s2,64(sp)
    80002370:	79e2                	ld	s3,56(sp)
    80002372:	7a42                	ld	s4,48(sp)
    80002374:	7aa2                	ld	s5,40(sp)
    80002376:	7b02                	ld	s6,32(sp)
    80002378:	6be2                	ld	s7,24(sp)
    8000237a:	6c42                	ld	s8,16(sp)
    8000237c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000237e:	00006517          	auipc	a0,0x6
    80002382:	01a50513          	addi	a0,a0,26 # 80008398 <etext+0x398>
    80002386:	77f030ef          	jal	80006304 <printf>
  return 0;
    8000238a:	4481                	li	s1,0
    8000238c:	b79d                	j	800022f2 <balloc+0x84>

000000008000238e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000238e:	7179                	addi	sp,sp,-48
    80002390:	f406                	sd	ra,40(sp)
    80002392:	f022                	sd	s0,32(sp)
    80002394:	ec26                	sd	s1,24(sp)
    80002396:	e84a                	sd	s2,16(sp)
    80002398:	e44e                	sd	s3,8(sp)
    8000239a:	1800                	addi	s0,sp,48
    8000239c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000239e:	47ad                	li	a5,11
    800023a0:	02b7e663          	bltu	a5,a1,800023cc <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800023a4:	02059793          	slli	a5,a1,0x20
    800023a8:	01e7d593          	srli	a1,a5,0x1e
    800023ac:	00b504b3          	add	s1,a0,a1
    800023b0:	0504a903          	lw	s2,80(s1)
    800023b4:	06091a63          	bnez	s2,80002428 <bmap+0x9a>
      addr = balloc(ip->dev);
    800023b8:	4108                	lw	a0,0(a0)
    800023ba:	eb5ff0ef          	jal	8000226e <balloc>
    800023be:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023c2:	06090363          	beqz	s2,80002428 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800023c6:	0524a823          	sw	s2,80(s1)
    800023ca:	a8b9                	j	80002428 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800023cc:	ff45849b          	addiw	s1,a1,-12
    800023d0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800023d4:	0ff00793          	li	a5,255
    800023d8:	06e7ee63          	bltu	a5,a4,80002454 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800023dc:	08052903          	lw	s2,128(a0)
    800023e0:	00091d63          	bnez	s2,800023fa <bmap+0x6c>
      addr = balloc(ip->dev);
    800023e4:	4108                	lw	a0,0(a0)
    800023e6:	e89ff0ef          	jal	8000226e <balloc>
    800023ea:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023ee:	02090d63          	beqz	s2,80002428 <bmap+0x9a>
    800023f2:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800023f4:	0929a023          	sw	s2,128(s3)
    800023f8:	a011                	j	800023fc <bmap+0x6e>
    800023fa:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800023fc:	85ca                	mv	a1,s2
    800023fe:	0009a503          	lw	a0,0(s3)
    80002402:	c09ff0ef          	jal	8000200a <bread>
    80002406:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002408:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000240c:	02049713          	slli	a4,s1,0x20
    80002410:	01e75593          	srli	a1,a4,0x1e
    80002414:	00b784b3          	add	s1,a5,a1
    80002418:	0004a903          	lw	s2,0(s1)
    8000241c:	00090e63          	beqz	s2,80002438 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002420:	8552                	mv	a0,s4
    80002422:	cf1ff0ef          	jal	80002112 <brelse>
    return addr;
    80002426:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002428:	854a                	mv	a0,s2
    8000242a:	70a2                	ld	ra,40(sp)
    8000242c:	7402                	ld	s0,32(sp)
    8000242e:	64e2                	ld	s1,24(sp)
    80002430:	6942                	ld	s2,16(sp)
    80002432:	69a2                	ld	s3,8(sp)
    80002434:	6145                	addi	sp,sp,48
    80002436:	8082                	ret
      addr = balloc(ip->dev);
    80002438:	0009a503          	lw	a0,0(s3)
    8000243c:	e33ff0ef          	jal	8000226e <balloc>
    80002440:	0005091b          	sext.w	s2,a0
      if(addr){
    80002444:	fc090ee3          	beqz	s2,80002420 <bmap+0x92>
        a[bn] = addr;
    80002448:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000244c:	8552                	mv	a0,s4
    8000244e:	5f7000ef          	jal	80003244 <log_write>
    80002452:	b7f9                	j	80002420 <bmap+0x92>
    80002454:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002456:	00006517          	auipc	a0,0x6
    8000245a:	f5a50513          	addi	a0,a0,-166 # 800083b0 <etext+0x3b0>
    8000245e:	18c040ef          	jal	800065ea <panic>

0000000080002462 <iget>:
{
    80002462:	7179                	addi	sp,sp,-48
    80002464:	f406                	sd	ra,40(sp)
    80002466:	f022                	sd	s0,32(sp)
    80002468:	ec26                	sd	s1,24(sp)
    8000246a:	e84a                	sd	s2,16(sp)
    8000246c:	e44e                	sd	s3,8(sp)
    8000246e:	e052                	sd	s4,0(sp)
    80002470:	1800                	addi	s0,sp,48
    80002472:	89aa                	mv	s3,a0
    80002474:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002476:	00018517          	auipc	a0,0x18
    8000247a:	a1250513          	addi	a0,a0,-1518 # 80019e88 <itable>
    8000247e:	428040ef          	jal	800068a6 <acquire>
  empty = 0;
    80002482:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002484:	00018497          	auipc	s1,0x18
    80002488:	a1c48493          	addi	s1,s1,-1508 # 80019ea0 <itable+0x18>
    8000248c:	00019697          	auipc	a3,0x19
    80002490:	4a468693          	addi	a3,a3,1188 # 8001b930 <log>
    80002494:	a039                	j	800024a2 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002496:	02090963          	beqz	s2,800024c8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000249a:	08848493          	addi	s1,s1,136
    8000249e:	02d48863          	beq	s1,a3,800024ce <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800024a2:	449c                	lw	a5,8(s1)
    800024a4:	fef059e3          	blez	a5,80002496 <iget+0x34>
    800024a8:	4098                	lw	a4,0(s1)
    800024aa:	ff3716e3          	bne	a4,s3,80002496 <iget+0x34>
    800024ae:	40d8                	lw	a4,4(s1)
    800024b0:	ff4713e3          	bne	a4,s4,80002496 <iget+0x34>
      ip->ref++;
    800024b4:	2785                	addiw	a5,a5,1
    800024b6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024b8:	00018517          	auipc	a0,0x18
    800024bc:	9d050513          	addi	a0,a0,-1584 # 80019e88 <itable>
    800024c0:	47e040ef          	jal	8000693e <release>
      return ip;
    800024c4:	8926                	mv	s2,s1
    800024c6:	a02d                	j	800024f0 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024c8:	fbe9                	bnez	a5,8000249a <iget+0x38>
      empty = ip;
    800024ca:	8926                	mv	s2,s1
    800024cc:	b7f9                	j	8000249a <iget+0x38>
  if(empty == 0)
    800024ce:	02090a63          	beqz	s2,80002502 <iget+0xa0>
  ip->dev = dev;
    800024d2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800024d6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800024da:	4785                	li	a5,1
    800024dc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800024e0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800024e4:	00018517          	auipc	a0,0x18
    800024e8:	9a450513          	addi	a0,a0,-1628 # 80019e88 <itable>
    800024ec:	452040ef          	jal	8000693e <release>
}
    800024f0:	854a                	mv	a0,s2
    800024f2:	70a2                	ld	ra,40(sp)
    800024f4:	7402                	ld	s0,32(sp)
    800024f6:	64e2                	ld	s1,24(sp)
    800024f8:	6942                	ld	s2,16(sp)
    800024fa:	69a2                	ld	s3,8(sp)
    800024fc:	6a02                	ld	s4,0(sp)
    800024fe:	6145                	addi	sp,sp,48
    80002500:	8082                	ret
    panic("iget: no inodes");
    80002502:	00006517          	auipc	a0,0x6
    80002506:	ec650513          	addi	a0,a0,-314 # 800083c8 <etext+0x3c8>
    8000250a:	0e0040ef          	jal	800065ea <panic>

000000008000250e <iinit>:
{
    8000250e:	7179                	addi	sp,sp,-48
    80002510:	f406                	sd	ra,40(sp)
    80002512:	f022                	sd	s0,32(sp)
    80002514:	ec26                	sd	s1,24(sp)
    80002516:	e84a                	sd	s2,16(sp)
    80002518:	e44e                	sd	s3,8(sp)
    8000251a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000251c:	00006597          	auipc	a1,0x6
    80002520:	ebc58593          	addi	a1,a1,-324 # 800083d8 <etext+0x3d8>
    80002524:	00018517          	auipc	a0,0x18
    80002528:	96450513          	addi	a0,a0,-1692 # 80019e88 <itable>
    8000252c:	2fa040ef          	jal	80006826 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002530:	00018497          	auipc	s1,0x18
    80002534:	98048493          	addi	s1,s1,-1664 # 80019eb0 <itable+0x28>
    80002538:	00019997          	auipc	s3,0x19
    8000253c:	40898993          	addi	s3,s3,1032 # 8001b940 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002540:	00006917          	auipc	s2,0x6
    80002544:	ea090913          	addi	s2,s2,-352 # 800083e0 <etext+0x3e0>
    80002548:	85ca                	mv	a1,s2
    8000254a:	8526                	mv	a0,s1
    8000254c:	5bb000ef          	jal	80003306 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002550:	08848493          	addi	s1,s1,136
    80002554:	ff349ae3          	bne	s1,s3,80002548 <iinit+0x3a>
}
    80002558:	70a2                	ld	ra,40(sp)
    8000255a:	7402                	ld	s0,32(sp)
    8000255c:	64e2                	ld	s1,24(sp)
    8000255e:	6942                	ld	s2,16(sp)
    80002560:	69a2                	ld	s3,8(sp)
    80002562:	6145                	addi	sp,sp,48
    80002564:	8082                	ret

0000000080002566 <ialloc>:
{
    80002566:	7139                	addi	sp,sp,-64
    80002568:	fc06                	sd	ra,56(sp)
    8000256a:	f822                	sd	s0,48(sp)
    8000256c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000256e:	00018717          	auipc	a4,0x18
    80002572:	90672703          	lw	a4,-1786(a4) # 80019e74 <sb+0xc>
    80002576:	4785                	li	a5,1
    80002578:	06e7f063          	bgeu	a5,a4,800025d8 <ialloc+0x72>
    8000257c:	f426                	sd	s1,40(sp)
    8000257e:	f04a                	sd	s2,32(sp)
    80002580:	ec4e                	sd	s3,24(sp)
    80002582:	e852                	sd	s4,16(sp)
    80002584:	e456                	sd	s5,8(sp)
    80002586:	e05a                	sd	s6,0(sp)
    80002588:	8aaa                	mv	s5,a0
    8000258a:	8b2e                	mv	s6,a1
    8000258c:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000258e:	00018a17          	auipc	s4,0x18
    80002592:	8daa0a13          	addi	s4,s4,-1830 # 80019e68 <sb>
    80002596:	00495593          	srli	a1,s2,0x4
    8000259a:	018a2783          	lw	a5,24(s4)
    8000259e:	9dbd                	addw	a1,a1,a5
    800025a0:	8556                	mv	a0,s5
    800025a2:	a69ff0ef          	jal	8000200a <bread>
    800025a6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800025a8:	05850993          	addi	s3,a0,88
    800025ac:	00f97793          	andi	a5,s2,15
    800025b0:	079a                	slli	a5,a5,0x6
    800025b2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800025b4:	00099783          	lh	a5,0(s3)
    800025b8:	cb9d                	beqz	a5,800025ee <ialloc+0x88>
    brelse(bp);
    800025ba:	b59ff0ef          	jal	80002112 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800025be:	0905                	addi	s2,s2,1
    800025c0:	00ca2703          	lw	a4,12(s4)
    800025c4:	0009079b          	sext.w	a5,s2
    800025c8:	fce7e7e3          	bltu	a5,a4,80002596 <ialloc+0x30>
    800025cc:	74a2                	ld	s1,40(sp)
    800025ce:	7902                	ld	s2,32(sp)
    800025d0:	69e2                	ld	s3,24(sp)
    800025d2:	6a42                	ld	s4,16(sp)
    800025d4:	6aa2                	ld	s5,8(sp)
    800025d6:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800025d8:	00006517          	auipc	a0,0x6
    800025dc:	e1050513          	addi	a0,a0,-496 # 800083e8 <etext+0x3e8>
    800025e0:	525030ef          	jal	80006304 <printf>
  return 0;
    800025e4:	4501                	li	a0,0
}
    800025e6:	70e2                	ld	ra,56(sp)
    800025e8:	7442                	ld	s0,48(sp)
    800025ea:	6121                	addi	sp,sp,64
    800025ec:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800025ee:	04000613          	li	a2,64
    800025f2:	4581                	li	a1,0
    800025f4:	854e                	mv	a0,s3
    800025f6:	b59fd0ef          	jal	8000014e <memset>
      dip->type = type;
    800025fa:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800025fe:	8526                	mv	a0,s1
    80002600:	445000ef          	jal	80003244 <log_write>
      brelse(bp);
    80002604:	8526                	mv	a0,s1
    80002606:	b0dff0ef          	jal	80002112 <brelse>
      return iget(dev, inum);
    8000260a:	0009059b          	sext.w	a1,s2
    8000260e:	8556                	mv	a0,s5
    80002610:	e53ff0ef          	jal	80002462 <iget>
    80002614:	74a2                	ld	s1,40(sp)
    80002616:	7902                	ld	s2,32(sp)
    80002618:	69e2                	ld	s3,24(sp)
    8000261a:	6a42                	ld	s4,16(sp)
    8000261c:	6aa2                	ld	s5,8(sp)
    8000261e:	6b02                	ld	s6,0(sp)
    80002620:	b7d9                	j	800025e6 <ialloc+0x80>

0000000080002622 <iupdate>:
{
    80002622:	1101                	addi	sp,sp,-32
    80002624:	ec06                	sd	ra,24(sp)
    80002626:	e822                	sd	s0,16(sp)
    80002628:	e426                	sd	s1,8(sp)
    8000262a:	e04a                	sd	s2,0(sp)
    8000262c:	1000                	addi	s0,sp,32
    8000262e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002630:	415c                	lw	a5,4(a0)
    80002632:	0047d79b          	srliw	a5,a5,0x4
    80002636:	00018597          	auipc	a1,0x18
    8000263a:	84a5a583          	lw	a1,-1974(a1) # 80019e80 <sb+0x18>
    8000263e:	9dbd                	addw	a1,a1,a5
    80002640:	4108                	lw	a0,0(a0)
    80002642:	9c9ff0ef          	jal	8000200a <bread>
    80002646:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002648:	05850793          	addi	a5,a0,88
    8000264c:	40d8                	lw	a4,4(s1)
    8000264e:	8b3d                	andi	a4,a4,15
    80002650:	071a                	slli	a4,a4,0x6
    80002652:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002654:	04449703          	lh	a4,68(s1)
    80002658:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000265c:	04649703          	lh	a4,70(s1)
    80002660:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002664:	04849703          	lh	a4,72(s1)
    80002668:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000266c:	04a49703          	lh	a4,74(s1)
    80002670:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002674:	44f8                	lw	a4,76(s1)
    80002676:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002678:	03400613          	li	a2,52
    8000267c:	05048593          	addi	a1,s1,80
    80002680:	00c78513          	addi	a0,a5,12
    80002684:	b27fd0ef          	jal	800001aa <memmove>
  log_write(bp);
    80002688:	854a                	mv	a0,s2
    8000268a:	3bb000ef          	jal	80003244 <log_write>
  brelse(bp);
    8000268e:	854a                	mv	a0,s2
    80002690:	a83ff0ef          	jal	80002112 <brelse>
}
    80002694:	60e2                	ld	ra,24(sp)
    80002696:	6442                	ld	s0,16(sp)
    80002698:	64a2                	ld	s1,8(sp)
    8000269a:	6902                	ld	s2,0(sp)
    8000269c:	6105                	addi	sp,sp,32
    8000269e:	8082                	ret

00000000800026a0 <idup>:
{
    800026a0:	1101                	addi	sp,sp,-32
    800026a2:	ec06                	sd	ra,24(sp)
    800026a4:	e822                	sd	s0,16(sp)
    800026a6:	e426                	sd	s1,8(sp)
    800026a8:	1000                	addi	s0,sp,32
    800026aa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800026ac:	00017517          	auipc	a0,0x17
    800026b0:	7dc50513          	addi	a0,a0,2012 # 80019e88 <itable>
    800026b4:	1f2040ef          	jal	800068a6 <acquire>
  ip->ref++;
    800026b8:	449c                	lw	a5,8(s1)
    800026ba:	2785                	addiw	a5,a5,1
    800026bc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800026be:	00017517          	auipc	a0,0x17
    800026c2:	7ca50513          	addi	a0,a0,1994 # 80019e88 <itable>
    800026c6:	278040ef          	jal	8000693e <release>
}
    800026ca:	8526                	mv	a0,s1
    800026cc:	60e2                	ld	ra,24(sp)
    800026ce:	6442                	ld	s0,16(sp)
    800026d0:	64a2                	ld	s1,8(sp)
    800026d2:	6105                	addi	sp,sp,32
    800026d4:	8082                	ret

00000000800026d6 <ilock>:
{
    800026d6:	1101                	addi	sp,sp,-32
    800026d8:	ec06                	sd	ra,24(sp)
    800026da:	e822                	sd	s0,16(sp)
    800026dc:	e426                	sd	s1,8(sp)
    800026de:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800026e0:	cd19                	beqz	a0,800026fe <ilock+0x28>
    800026e2:	84aa                	mv	s1,a0
    800026e4:	451c                	lw	a5,8(a0)
    800026e6:	00f05c63          	blez	a5,800026fe <ilock+0x28>
  acquiresleep(&ip->lock);
    800026ea:	0541                	addi	a0,a0,16
    800026ec:	451000ef          	jal	8000333c <acquiresleep>
  if(ip->valid == 0){
    800026f0:	40bc                	lw	a5,64(s1)
    800026f2:	cf89                	beqz	a5,8000270c <ilock+0x36>
}
    800026f4:	60e2                	ld	ra,24(sp)
    800026f6:	6442                	ld	s0,16(sp)
    800026f8:	64a2                	ld	s1,8(sp)
    800026fa:	6105                	addi	sp,sp,32
    800026fc:	8082                	ret
    800026fe:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002700:	00006517          	auipc	a0,0x6
    80002704:	d0050513          	addi	a0,a0,-768 # 80008400 <etext+0x400>
    80002708:	6e3030ef          	jal	800065ea <panic>
    8000270c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000270e:	40dc                	lw	a5,4(s1)
    80002710:	0047d79b          	srliw	a5,a5,0x4
    80002714:	00017597          	auipc	a1,0x17
    80002718:	76c5a583          	lw	a1,1900(a1) # 80019e80 <sb+0x18>
    8000271c:	9dbd                	addw	a1,a1,a5
    8000271e:	4088                	lw	a0,0(s1)
    80002720:	8ebff0ef          	jal	8000200a <bread>
    80002724:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002726:	05850593          	addi	a1,a0,88
    8000272a:	40dc                	lw	a5,4(s1)
    8000272c:	8bbd                	andi	a5,a5,15
    8000272e:	079a                	slli	a5,a5,0x6
    80002730:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002732:	00059783          	lh	a5,0(a1)
    80002736:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000273a:	00259783          	lh	a5,2(a1)
    8000273e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002742:	00459783          	lh	a5,4(a1)
    80002746:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000274a:	00659783          	lh	a5,6(a1)
    8000274e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002752:	459c                	lw	a5,8(a1)
    80002754:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002756:	03400613          	li	a2,52
    8000275a:	05b1                	addi	a1,a1,12
    8000275c:	05048513          	addi	a0,s1,80
    80002760:	a4bfd0ef          	jal	800001aa <memmove>
    brelse(bp);
    80002764:	854a                	mv	a0,s2
    80002766:	9adff0ef          	jal	80002112 <brelse>
    ip->valid = 1;
    8000276a:	4785                	li	a5,1
    8000276c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000276e:	04449783          	lh	a5,68(s1)
    80002772:	c399                	beqz	a5,80002778 <ilock+0xa2>
    80002774:	6902                	ld	s2,0(sp)
    80002776:	bfbd                	j	800026f4 <ilock+0x1e>
      panic("ilock: no type");
    80002778:	00006517          	auipc	a0,0x6
    8000277c:	c9050513          	addi	a0,a0,-880 # 80008408 <etext+0x408>
    80002780:	66b030ef          	jal	800065ea <panic>

0000000080002784 <iunlock>:
{
    80002784:	1101                	addi	sp,sp,-32
    80002786:	ec06                	sd	ra,24(sp)
    80002788:	e822                	sd	s0,16(sp)
    8000278a:	e426                	sd	s1,8(sp)
    8000278c:	e04a                	sd	s2,0(sp)
    8000278e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002790:	c505                	beqz	a0,800027b8 <iunlock+0x34>
    80002792:	84aa                	mv	s1,a0
    80002794:	01050913          	addi	s2,a0,16
    80002798:	854a                	mv	a0,s2
    8000279a:	421000ef          	jal	800033ba <holdingsleep>
    8000279e:	cd09                	beqz	a0,800027b8 <iunlock+0x34>
    800027a0:	449c                	lw	a5,8(s1)
    800027a2:	00f05b63          	blez	a5,800027b8 <iunlock+0x34>
  releasesleep(&ip->lock);
    800027a6:	854a                	mv	a0,s2
    800027a8:	3db000ef          	jal	80003382 <releasesleep>
}
    800027ac:	60e2                	ld	ra,24(sp)
    800027ae:	6442                	ld	s0,16(sp)
    800027b0:	64a2                	ld	s1,8(sp)
    800027b2:	6902                	ld	s2,0(sp)
    800027b4:	6105                	addi	sp,sp,32
    800027b6:	8082                	ret
    panic("iunlock");
    800027b8:	00006517          	auipc	a0,0x6
    800027bc:	c6050513          	addi	a0,a0,-928 # 80008418 <etext+0x418>
    800027c0:	62b030ef          	jal	800065ea <panic>

00000000800027c4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800027c4:	7179                	addi	sp,sp,-48
    800027c6:	f406                	sd	ra,40(sp)
    800027c8:	f022                	sd	s0,32(sp)
    800027ca:	ec26                	sd	s1,24(sp)
    800027cc:	e84a                	sd	s2,16(sp)
    800027ce:	e44e                	sd	s3,8(sp)
    800027d0:	1800                	addi	s0,sp,48
    800027d2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800027d4:	05050493          	addi	s1,a0,80
    800027d8:	08050913          	addi	s2,a0,128
    800027dc:	a021                	j	800027e4 <itrunc+0x20>
    800027de:	0491                	addi	s1,s1,4
    800027e0:	01248b63          	beq	s1,s2,800027f6 <itrunc+0x32>
    if(ip->addrs[i]){
    800027e4:	408c                	lw	a1,0(s1)
    800027e6:	dde5                	beqz	a1,800027de <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800027e8:	0009a503          	lw	a0,0(s3)
    800027ec:	a17ff0ef          	jal	80002202 <bfree>
      ip->addrs[i] = 0;
    800027f0:	0004a023          	sw	zero,0(s1)
    800027f4:	b7ed                	j	800027de <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800027f6:	0809a583          	lw	a1,128(s3)
    800027fa:	ed89                	bnez	a1,80002814 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800027fc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002800:	854e                	mv	a0,s3
    80002802:	e21ff0ef          	jal	80002622 <iupdate>
}
    80002806:	70a2                	ld	ra,40(sp)
    80002808:	7402                	ld	s0,32(sp)
    8000280a:	64e2                	ld	s1,24(sp)
    8000280c:	6942                	ld	s2,16(sp)
    8000280e:	69a2                	ld	s3,8(sp)
    80002810:	6145                	addi	sp,sp,48
    80002812:	8082                	ret
    80002814:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002816:	0009a503          	lw	a0,0(s3)
    8000281a:	ff0ff0ef          	jal	8000200a <bread>
    8000281e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002820:	05850493          	addi	s1,a0,88
    80002824:	45850913          	addi	s2,a0,1112
    80002828:	a021                	j	80002830 <itrunc+0x6c>
    8000282a:	0491                	addi	s1,s1,4
    8000282c:	01248963          	beq	s1,s2,8000283e <itrunc+0x7a>
      if(a[j])
    80002830:	408c                	lw	a1,0(s1)
    80002832:	dde5                	beqz	a1,8000282a <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002834:	0009a503          	lw	a0,0(s3)
    80002838:	9cbff0ef          	jal	80002202 <bfree>
    8000283c:	b7fd                	j	8000282a <itrunc+0x66>
    brelse(bp);
    8000283e:	8552                	mv	a0,s4
    80002840:	8d3ff0ef          	jal	80002112 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002844:	0809a583          	lw	a1,128(s3)
    80002848:	0009a503          	lw	a0,0(s3)
    8000284c:	9b7ff0ef          	jal	80002202 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002850:	0809a023          	sw	zero,128(s3)
    80002854:	6a02                	ld	s4,0(sp)
    80002856:	b75d                	j	800027fc <itrunc+0x38>

0000000080002858 <iput>:
{
    80002858:	1101                	addi	sp,sp,-32
    8000285a:	ec06                	sd	ra,24(sp)
    8000285c:	e822                	sd	s0,16(sp)
    8000285e:	e426                	sd	s1,8(sp)
    80002860:	1000                	addi	s0,sp,32
    80002862:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002864:	00017517          	auipc	a0,0x17
    80002868:	62450513          	addi	a0,a0,1572 # 80019e88 <itable>
    8000286c:	03a040ef          	jal	800068a6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002870:	4498                	lw	a4,8(s1)
    80002872:	4785                	li	a5,1
    80002874:	02f70063          	beq	a4,a5,80002894 <iput+0x3c>
  ip->ref--;
    80002878:	449c                	lw	a5,8(s1)
    8000287a:	37fd                	addiw	a5,a5,-1
    8000287c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000287e:	00017517          	auipc	a0,0x17
    80002882:	60a50513          	addi	a0,a0,1546 # 80019e88 <itable>
    80002886:	0b8040ef          	jal	8000693e <release>
}
    8000288a:	60e2                	ld	ra,24(sp)
    8000288c:	6442                	ld	s0,16(sp)
    8000288e:	64a2                	ld	s1,8(sp)
    80002890:	6105                	addi	sp,sp,32
    80002892:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002894:	40bc                	lw	a5,64(s1)
    80002896:	d3ed                	beqz	a5,80002878 <iput+0x20>
    80002898:	04a49783          	lh	a5,74(s1)
    8000289c:	fff1                	bnez	a5,80002878 <iput+0x20>
    8000289e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800028a0:	01048913          	addi	s2,s1,16
    800028a4:	854a                	mv	a0,s2
    800028a6:	297000ef          	jal	8000333c <acquiresleep>
    release(&itable.lock);
    800028aa:	00017517          	auipc	a0,0x17
    800028ae:	5de50513          	addi	a0,a0,1502 # 80019e88 <itable>
    800028b2:	08c040ef          	jal	8000693e <release>
    itrunc(ip);
    800028b6:	8526                	mv	a0,s1
    800028b8:	f0dff0ef          	jal	800027c4 <itrunc>
    ip->type = 0;
    800028bc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800028c0:	8526                	mv	a0,s1
    800028c2:	d61ff0ef          	jal	80002622 <iupdate>
    ip->valid = 0;
    800028c6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800028ca:	854a                	mv	a0,s2
    800028cc:	2b7000ef          	jal	80003382 <releasesleep>
    acquire(&itable.lock);
    800028d0:	00017517          	auipc	a0,0x17
    800028d4:	5b850513          	addi	a0,a0,1464 # 80019e88 <itable>
    800028d8:	7cf030ef          	jal	800068a6 <acquire>
    800028dc:	6902                	ld	s2,0(sp)
    800028de:	bf69                	j	80002878 <iput+0x20>

00000000800028e0 <iunlockput>:
{
    800028e0:	1101                	addi	sp,sp,-32
    800028e2:	ec06                	sd	ra,24(sp)
    800028e4:	e822                	sd	s0,16(sp)
    800028e6:	e426                	sd	s1,8(sp)
    800028e8:	1000                	addi	s0,sp,32
    800028ea:	84aa                	mv	s1,a0
  iunlock(ip);
    800028ec:	e99ff0ef          	jal	80002784 <iunlock>
  iput(ip);
    800028f0:	8526                	mv	a0,s1
    800028f2:	f67ff0ef          	jal	80002858 <iput>
}
    800028f6:	60e2                	ld	ra,24(sp)
    800028f8:	6442                	ld	s0,16(sp)
    800028fa:	64a2                	ld	s1,8(sp)
    800028fc:	6105                	addi	sp,sp,32
    800028fe:	8082                	ret

0000000080002900 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002900:	00017717          	auipc	a4,0x17
    80002904:	57472703          	lw	a4,1396(a4) # 80019e74 <sb+0xc>
    80002908:	4785                	li	a5,1
    8000290a:	0ae7ff63          	bgeu	a5,a4,800029c8 <ireclaim+0xc8>
{
    8000290e:	7139                	addi	sp,sp,-64
    80002910:	fc06                	sd	ra,56(sp)
    80002912:	f822                	sd	s0,48(sp)
    80002914:	f426                	sd	s1,40(sp)
    80002916:	f04a                	sd	s2,32(sp)
    80002918:	ec4e                	sd	s3,24(sp)
    8000291a:	e852                	sd	s4,16(sp)
    8000291c:	e456                	sd	s5,8(sp)
    8000291e:	e05a                	sd	s6,0(sp)
    80002920:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002922:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002924:	00050a1b          	sext.w	s4,a0
    80002928:	00017a97          	auipc	s5,0x17
    8000292c:	540a8a93          	addi	s5,s5,1344 # 80019e68 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80002930:	00006b17          	auipc	s6,0x6
    80002934:	af0b0b13          	addi	s6,s6,-1296 # 80008420 <etext+0x420>
    80002938:	a099                	j	8000297e <ireclaim+0x7e>
    8000293a:	85ce                	mv	a1,s3
    8000293c:	855a                	mv	a0,s6
    8000293e:	1c7030ef          	jal	80006304 <printf>
      ip = iget(dev, inum);
    80002942:	85ce                	mv	a1,s3
    80002944:	8552                	mv	a0,s4
    80002946:	b1dff0ef          	jal	80002462 <iget>
    8000294a:	89aa                	mv	s3,a0
    brelse(bp);
    8000294c:	854a                	mv	a0,s2
    8000294e:	fc4ff0ef          	jal	80002112 <brelse>
    if (ip) {
    80002952:	00098f63          	beqz	s3,80002970 <ireclaim+0x70>
      begin_op();
    80002956:	76a000ef          	jal	800030c0 <begin_op>
      ilock(ip);
    8000295a:	854e                	mv	a0,s3
    8000295c:	d7bff0ef          	jal	800026d6 <ilock>
      iunlock(ip);
    80002960:	854e                	mv	a0,s3
    80002962:	e23ff0ef          	jal	80002784 <iunlock>
      iput(ip);
    80002966:	854e                	mv	a0,s3
    80002968:	ef1ff0ef          	jal	80002858 <iput>
      end_op();
    8000296c:	7be000ef          	jal	8000312a <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002970:	0485                	addi	s1,s1,1
    80002972:	00caa703          	lw	a4,12(s5)
    80002976:	0004879b          	sext.w	a5,s1
    8000297a:	02e7fd63          	bgeu	a5,a4,800029b4 <ireclaim+0xb4>
    8000297e:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002982:	0044d593          	srli	a1,s1,0x4
    80002986:	018aa783          	lw	a5,24(s5)
    8000298a:	9dbd                	addw	a1,a1,a5
    8000298c:	8552                	mv	a0,s4
    8000298e:	e7cff0ef          	jal	8000200a <bread>
    80002992:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002994:	05850793          	addi	a5,a0,88
    80002998:	00f9f713          	andi	a4,s3,15
    8000299c:	071a                	slli	a4,a4,0x6
    8000299e:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800029a0:	00079703          	lh	a4,0(a5)
    800029a4:	c701                	beqz	a4,800029ac <ireclaim+0xac>
    800029a6:	00679783          	lh	a5,6(a5)
    800029aa:	dbc1                	beqz	a5,8000293a <ireclaim+0x3a>
    brelse(bp);
    800029ac:	854a                	mv	a0,s2
    800029ae:	f64ff0ef          	jal	80002112 <brelse>
    if (ip) {
    800029b2:	bf7d                	j	80002970 <ireclaim+0x70>
}
    800029b4:	70e2                	ld	ra,56(sp)
    800029b6:	7442                	ld	s0,48(sp)
    800029b8:	74a2                	ld	s1,40(sp)
    800029ba:	7902                	ld	s2,32(sp)
    800029bc:	69e2                	ld	s3,24(sp)
    800029be:	6a42                	ld	s4,16(sp)
    800029c0:	6aa2                	ld	s5,8(sp)
    800029c2:	6b02                	ld	s6,0(sp)
    800029c4:	6121                	addi	sp,sp,64
    800029c6:	8082                	ret
    800029c8:	8082                	ret

00000000800029ca <fsinit>:
fsinit(int dev) {
    800029ca:	7179                	addi	sp,sp,-48
    800029cc:	f406                	sd	ra,40(sp)
    800029ce:	f022                	sd	s0,32(sp)
    800029d0:	ec26                	sd	s1,24(sp)
    800029d2:	e84a                	sd	s2,16(sp)
    800029d4:	e44e                	sd	s3,8(sp)
    800029d6:	1800                	addi	s0,sp,48
    800029d8:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    800029da:	4585                	li	a1,1
    800029dc:	e2eff0ef          	jal	8000200a <bread>
    800029e0:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029e2:	00017997          	auipc	s3,0x17
    800029e6:	48698993          	addi	s3,s3,1158 # 80019e68 <sb>
    800029ea:	02000613          	li	a2,32
    800029ee:	05850593          	addi	a1,a0,88
    800029f2:	854e                	mv	a0,s3
    800029f4:	fb6fd0ef          	jal	800001aa <memmove>
  brelse(bp);
    800029f8:	854a                	mv	a0,s2
    800029fa:	f18ff0ef          	jal	80002112 <brelse>
  if(sb.magic != FSMAGIC)
    800029fe:	0009a703          	lw	a4,0(s3)
    80002a02:	102037b7          	lui	a5,0x10203
    80002a06:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a0a:	02f71363          	bne	a4,a5,80002a30 <fsinit+0x66>
  initlog(dev, &sb);
    80002a0e:	00017597          	auipc	a1,0x17
    80002a12:	45a58593          	addi	a1,a1,1114 # 80019e68 <sb>
    80002a16:	8526                	mv	a0,s1
    80002a18:	62a000ef          	jal	80003042 <initlog>
  ireclaim(dev);
    80002a1c:	8526                	mv	a0,s1
    80002a1e:	ee3ff0ef          	jal	80002900 <ireclaim>
}
    80002a22:	70a2                	ld	ra,40(sp)
    80002a24:	7402                	ld	s0,32(sp)
    80002a26:	64e2                	ld	s1,24(sp)
    80002a28:	6942                	ld	s2,16(sp)
    80002a2a:	69a2                	ld	s3,8(sp)
    80002a2c:	6145                	addi	sp,sp,48
    80002a2e:	8082                	ret
    panic("invalid file system");
    80002a30:	00006517          	auipc	a0,0x6
    80002a34:	a1050513          	addi	a0,a0,-1520 # 80008440 <etext+0x440>
    80002a38:	3b3030ef          	jal	800065ea <panic>

0000000080002a3c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002a3c:	1141                	addi	sp,sp,-16
    80002a3e:	e422                	sd	s0,8(sp)
    80002a40:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a42:	411c                	lw	a5,0(a0)
    80002a44:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a46:	415c                	lw	a5,4(a0)
    80002a48:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a4a:	04451783          	lh	a5,68(a0)
    80002a4e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a52:	04a51783          	lh	a5,74(a0)
    80002a56:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a5a:	04c56783          	lwu	a5,76(a0)
    80002a5e:	e99c                	sd	a5,16(a1)
}
    80002a60:	6422                	ld	s0,8(sp)
    80002a62:	0141                	addi	sp,sp,16
    80002a64:	8082                	ret

0000000080002a66 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a66:	457c                	lw	a5,76(a0)
    80002a68:	0ed7eb63          	bltu	a5,a3,80002b5e <readi+0xf8>
{
    80002a6c:	7159                	addi	sp,sp,-112
    80002a6e:	f486                	sd	ra,104(sp)
    80002a70:	f0a2                	sd	s0,96(sp)
    80002a72:	eca6                	sd	s1,88(sp)
    80002a74:	e0d2                	sd	s4,64(sp)
    80002a76:	fc56                	sd	s5,56(sp)
    80002a78:	f85a                	sd	s6,48(sp)
    80002a7a:	f45e                	sd	s7,40(sp)
    80002a7c:	1880                	addi	s0,sp,112
    80002a7e:	8b2a                	mv	s6,a0
    80002a80:	8bae                	mv	s7,a1
    80002a82:	8a32                	mv	s4,a2
    80002a84:	84b6                	mv	s1,a3
    80002a86:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002a88:	9f35                	addw	a4,a4,a3
    return 0;
    80002a8a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002a8c:	0cd76063          	bltu	a4,a3,80002b4c <readi+0xe6>
    80002a90:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002a92:	00e7f463          	bgeu	a5,a4,80002a9a <readi+0x34>
    n = ip->size - off;
    80002a96:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a9a:	080a8f63          	beqz	s5,80002b38 <readi+0xd2>
    80002a9e:	e8ca                	sd	s2,80(sp)
    80002aa0:	f062                	sd	s8,32(sp)
    80002aa2:	ec66                	sd	s9,24(sp)
    80002aa4:	e86a                	sd	s10,16(sp)
    80002aa6:	e46e                	sd	s11,8(sp)
    80002aa8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002aaa:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002aae:	5c7d                	li	s8,-1
    80002ab0:	a80d                	j	80002ae2 <readi+0x7c>
    80002ab2:	020d1d93          	slli	s11,s10,0x20
    80002ab6:	020ddd93          	srli	s11,s11,0x20
    80002aba:	05890613          	addi	a2,s2,88
    80002abe:	86ee                	mv	a3,s11
    80002ac0:	963a                	add	a2,a2,a4
    80002ac2:	85d2                	mv	a1,s4
    80002ac4:	855e                	mv	a0,s7
    80002ac6:	c65fe0ef          	jal	8000172a <either_copyout>
    80002aca:	05850763          	beq	a0,s8,80002b18 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ace:	854a                	mv	a0,s2
    80002ad0:	e42ff0ef          	jal	80002112 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ad4:	013d09bb          	addw	s3,s10,s3
    80002ad8:	009d04bb          	addw	s1,s10,s1
    80002adc:	9a6e                	add	s4,s4,s11
    80002ade:	0559f763          	bgeu	s3,s5,80002b2c <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002ae2:	00a4d59b          	srliw	a1,s1,0xa
    80002ae6:	855a                	mv	a0,s6
    80002ae8:	8a7ff0ef          	jal	8000238e <bmap>
    80002aec:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002af0:	c5b1                	beqz	a1,80002b3c <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002af2:	000b2503          	lw	a0,0(s6)
    80002af6:	d14ff0ef          	jal	8000200a <bread>
    80002afa:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002afc:	3ff4f713          	andi	a4,s1,1023
    80002b00:	40ec87bb          	subw	a5,s9,a4
    80002b04:	413a86bb          	subw	a3,s5,s3
    80002b08:	8d3e                	mv	s10,a5
    80002b0a:	2781                	sext.w	a5,a5
    80002b0c:	0006861b          	sext.w	a2,a3
    80002b10:	faf671e3          	bgeu	a2,a5,80002ab2 <readi+0x4c>
    80002b14:	8d36                	mv	s10,a3
    80002b16:	bf71                	j	80002ab2 <readi+0x4c>
      brelse(bp);
    80002b18:	854a                	mv	a0,s2
    80002b1a:	df8ff0ef          	jal	80002112 <brelse>
      tot = -1;
    80002b1e:	59fd                	li	s3,-1
      break;
    80002b20:	6946                	ld	s2,80(sp)
    80002b22:	7c02                	ld	s8,32(sp)
    80002b24:	6ce2                	ld	s9,24(sp)
    80002b26:	6d42                	ld	s10,16(sp)
    80002b28:	6da2                	ld	s11,8(sp)
    80002b2a:	a831                	j	80002b46 <readi+0xe0>
    80002b2c:	6946                	ld	s2,80(sp)
    80002b2e:	7c02                	ld	s8,32(sp)
    80002b30:	6ce2                	ld	s9,24(sp)
    80002b32:	6d42                	ld	s10,16(sp)
    80002b34:	6da2                	ld	s11,8(sp)
    80002b36:	a801                	j	80002b46 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b38:	89d6                	mv	s3,s5
    80002b3a:	a031                	j	80002b46 <readi+0xe0>
    80002b3c:	6946                	ld	s2,80(sp)
    80002b3e:	7c02                	ld	s8,32(sp)
    80002b40:	6ce2                	ld	s9,24(sp)
    80002b42:	6d42                	ld	s10,16(sp)
    80002b44:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002b46:	0009851b          	sext.w	a0,s3
    80002b4a:	69a6                	ld	s3,72(sp)
}
    80002b4c:	70a6                	ld	ra,104(sp)
    80002b4e:	7406                	ld	s0,96(sp)
    80002b50:	64e6                	ld	s1,88(sp)
    80002b52:	6a06                	ld	s4,64(sp)
    80002b54:	7ae2                	ld	s5,56(sp)
    80002b56:	7b42                	ld	s6,48(sp)
    80002b58:	7ba2                	ld	s7,40(sp)
    80002b5a:	6165                	addi	sp,sp,112
    80002b5c:	8082                	ret
    return 0;
    80002b5e:	4501                	li	a0,0
}
    80002b60:	8082                	ret

0000000080002b62 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b62:	457c                	lw	a5,76(a0)
    80002b64:	10d7e063          	bltu	a5,a3,80002c64 <writei+0x102>
{
    80002b68:	7159                	addi	sp,sp,-112
    80002b6a:	f486                	sd	ra,104(sp)
    80002b6c:	f0a2                	sd	s0,96(sp)
    80002b6e:	e8ca                	sd	s2,80(sp)
    80002b70:	e0d2                	sd	s4,64(sp)
    80002b72:	fc56                	sd	s5,56(sp)
    80002b74:	f85a                	sd	s6,48(sp)
    80002b76:	f45e                	sd	s7,40(sp)
    80002b78:	1880                	addi	s0,sp,112
    80002b7a:	8aaa                	mv	s5,a0
    80002b7c:	8bae                	mv	s7,a1
    80002b7e:	8a32                	mv	s4,a2
    80002b80:	8936                	mv	s2,a3
    80002b82:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b84:	00e687bb          	addw	a5,a3,a4
    80002b88:	0ed7e063          	bltu	a5,a3,80002c68 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b8c:	00043737          	lui	a4,0x43
    80002b90:	0cf76e63          	bltu	a4,a5,80002c6c <writei+0x10a>
    80002b94:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b96:	0a0b0f63          	beqz	s6,80002c54 <writei+0xf2>
    80002b9a:	eca6                	sd	s1,88(sp)
    80002b9c:	f062                	sd	s8,32(sp)
    80002b9e:	ec66                	sd	s9,24(sp)
    80002ba0:	e86a                	sd	s10,16(sp)
    80002ba2:	e46e                	sd	s11,8(sp)
    80002ba4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ba6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002baa:	5c7d                	li	s8,-1
    80002bac:	a825                	j	80002be4 <writei+0x82>
    80002bae:	020d1d93          	slli	s11,s10,0x20
    80002bb2:	020ddd93          	srli	s11,s11,0x20
    80002bb6:	05848513          	addi	a0,s1,88
    80002bba:	86ee                	mv	a3,s11
    80002bbc:	8652                	mv	a2,s4
    80002bbe:	85de                	mv	a1,s7
    80002bc0:	953a                	add	a0,a0,a4
    80002bc2:	bb3fe0ef          	jal	80001774 <either_copyin>
    80002bc6:	05850a63          	beq	a0,s8,80002c1a <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002bca:	8526                	mv	a0,s1
    80002bcc:	678000ef          	jal	80003244 <log_write>
    brelse(bp);
    80002bd0:	8526                	mv	a0,s1
    80002bd2:	d40ff0ef          	jal	80002112 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bd6:	013d09bb          	addw	s3,s10,s3
    80002bda:	012d093b          	addw	s2,s10,s2
    80002bde:	9a6e                	add	s4,s4,s11
    80002be0:	0569f063          	bgeu	s3,s6,80002c20 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002be4:	00a9559b          	srliw	a1,s2,0xa
    80002be8:	8556                	mv	a0,s5
    80002bea:	fa4ff0ef          	jal	8000238e <bmap>
    80002bee:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002bf2:	c59d                	beqz	a1,80002c20 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002bf4:	000aa503          	lw	a0,0(s5)
    80002bf8:	c12ff0ef          	jal	8000200a <bread>
    80002bfc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bfe:	3ff97713          	andi	a4,s2,1023
    80002c02:	40ec87bb          	subw	a5,s9,a4
    80002c06:	413b06bb          	subw	a3,s6,s3
    80002c0a:	8d3e                	mv	s10,a5
    80002c0c:	2781                	sext.w	a5,a5
    80002c0e:	0006861b          	sext.w	a2,a3
    80002c12:	f8f67ee3          	bgeu	a2,a5,80002bae <writei+0x4c>
    80002c16:	8d36                	mv	s10,a3
    80002c18:	bf59                	j	80002bae <writei+0x4c>
      brelse(bp);
    80002c1a:	8526                	mv	a0,s1
    80002c1c:	cf6ff0ef          	jal	80002112 <brelse>
  }

  if(off > ip->size)
    80002c20:	04caa783          	lw	a5,76(s5)
    80002c24:	0327fa63          	bgeu	a5,s2,80002c58 <writei+0xf6>
    ip->size = off;
    80002c28:	052aa623          	sw	s2,76(s5)
    80002c2c:	64e6                	ld	s1,88(sp)
    80002c2e:	7c02                	ld	s8,32(sp)
    80002c30:	6ce2                	ld	s9,24(sp)
    80002c32:	6d42                	ld	s10,16(sp)
    80002c34:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002c36:	8556                	mv	a0,s5
    80002c38:	9ebff0ef          	jal	80002622 <iupdate>

  return tot;
    80002c3c:	0009851b          	sext.w	a0,s3
    80002c40:	69a6                	ld	s3,72(sp)
}
    80002c42:	70a6                	ld	ra,104(sp)
    80002c44:	7406                	ld	s0,96(sp)
    80002c46:	6946                	ld	s2,80(sp)
    80002c48:	6a06                	ld	s4,64(sp)
    80002c4a:	7ae2                	ld	s5,56(sp)
    80002c4c:	7b42                	ld	s6,48(sp)
    80002c4e:	7ba2                	ld	s7,40(sp)
    80002c50:	6165                	addi	sp,sp,112
    80002c52:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c54:	89da                	mv	s3,s6
    80002c56:	b7c5                	j	80002c36 <writei+0xd4>
    80002c58:	64e6                	ld	s1,88(sp)
    80002c5a:	7c02                	ld	s8,32(sp)
    80002c5c:	6ce2                	ld	s9,24(sp)
    80002c5e:	6d42                	ld	s10,16(sp)
    80002c60:	6da2                	ld	s11,8(sp)
    80002c62:	bfd1                	j	80002c36 <writei+0xd4>
    return -1;
    80002c64:	557d                	li	a0,-1
}
    80002c66:	8082                	ret
    return -1;
    80002c68:	557d                	li	a0,-1
    80002c6a:	bfe1                	j	80002c42 <writei+0xe0>
    return -1;
    80002c6c:	557d                	li	a0,-1
    80002c6e:	bfd1                	j	80002c42 <writei+0xe0>

0000000080002c70 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c70:	1141                	addi	sp,sp,-16
    80002c72:	e406                	sd	ra,8(sp)
    80002c74:	e022                	sd	s0,0(sp)
    80002c76:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c78:	4639                	li	a2,14
    80002c7a:	da0fd0ef          	jal	8000021a <strncmp>
}
    80002c7e:	60a2                	ld	ra,8(sp)
    80002c80:	6402                	ld	s0,0(sp)
    80002c82:	0141                	addi	sp,sp,16
    80002c84:	8082                	ret

0000000080002c86 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c86:	7139                	addi	sp,sp,-64
    80002c88:	fc06                	sd	ra,56(sp)
    80002c8a:	f822                	sd	s0,48(sp)
    80002c8c:	f426                	sd	s1,40(sp)
    80002c8e:	f04a                	sd	s2,32(sp)
    80002c90:	ec4e                	sd	s3,24(sp)
    80002c92:	e852                	sd	s4,16(sp)
    80002c94:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c96:	04451703          	lh	a4,68(a0)
    80002c9a:	4785                	li	a5,1
    80002c9c:	00f71a63          	bne	a4,a5,80002cb0 <dirlookup+0x2a>
    80002ca0:	892a                	mv	s2,a0
    80002ca2:	89ae                	mv	s3,a1
    80002ca4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ca6:	457c                	lw	a5,76(a0)
    80002ca8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002caa:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cac:	e39d                	bnez	a5,80002cd2 <dirlookup+0x4c>
    80002cae:	a095                	j	80002d12 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002cb0:	00005517          	auipc	a0,0x5
    80002cb4:	7a850513          	addi	a0,a0,1960 # 80008458 <etext+0x458>
    80002cb8:	133030ef          	jal	800065ea <panic>
      panic("dirlookup read");
    80002cbc:	00005517          	auipc	a0,0x5
    80002cc0:	7b450513          	addi	a0,a0,1972 # 80008470 <etext+0x470>
    80002cc4:	127030ef          	jal	800065ea <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cc8:	24c1                	addiw	s1,s1,16
    80002cca:	04c92783          	lw	a5,76(s2)
    80002cce:	04f4f163          	bgeu	s1,a5,80002d10 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cd2:	4741                	li	a4,16
    80002cd4:	86a6                	mv	a3,s1
    80002cd6:	fc040613          	addi	a2,s0,-64
    80002cda:	4581                	li	a1,0
    80002cdc:	854a                	mv	a0,s2
    80002cde:	d89ff0ef          	jal	80002a66 <readi>
    80002ce2:	47c1                	li	a5,16
    80002ce4:	fcf51ce3          	bne	a0,a5,80002cbc <dirlookup+0x36>
    if(de.inum == 0)
    80002ce8:	fc045783          	lhu	a5,-64(s0)
    80002cec:	dff1                	beqz	a5,80002cc8 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002cee:	fc240593          	addi	a1,s0,-62
    80002cf2:	854e                	mv	a0,s3
    80002cf4:	f7dff0ef          	jal	80002c70 <namecmp>
    80002cf8:	f961                	bnez	a0,80002cc8 <dirlookup+0x42>
      if(poff)
    80002cfa:	000a0463          	beqz	s4,80002d02 <dirlookup+0x7c>
        *poff = off;
    80002cfe:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002d02:	fc045583          	lhu	a1,-64(s0)
    80002d06:	00092503          	lw	a0,0(s2)
    80002d0a:	f58ff0ef          	jal	80002462 <iget>
    80002d0e:	a011                	j	80002d12 <dirlookup+0x8c>
  return 0;
    80002d10:	4501                	li	a0,0
}
    80002d12:	70e2                	ld	ra,56(sp)
    80002d14:	7442                	ld	s0,48(sp)
    80002d16:	74a2                	ld	s1,40(sp)
    80002d18:	7902                	ld	s2,32(sp)
    80002d1a:	69e2                	ld	s3,24(sp)
    80002d1c:	6a42                	ld	s4,16(sp)
    80002d1e:	6121                	addi	sp,sp,64
    80002d20:	8082                	ret

0000000080002d22 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002d22:	711d                	addi	sp,sp,-96
    80002d24:	ec86                	sd	ra,88(sp)
    80002d26:	e8a2                	sd	s0,80(sp)
    80002d28:	e4a6                	sd	s1,72(sp)
    80002d2a:	e0ca                	sd	s2,64(sp)
    80002d2c:	fc4e                	sd	s3,56(sp)
    80002d2e:	f852                	sd	s4,48(sp)
    80002d30:	f456                	sd	s5,40(sp)
    80002d32:	f05a                	sd	s6,32(sp)
    80002d34:	ec5e                	sd	s7,24(sp)
    80002d36:	e862                	sd	s8,16(sp)
    80002d38:	e466                	sd	s9,8(sp)
    80002d3a:	1080                	addi	s0,sp,96
    80002d3c:	84aa                	mv	s1,a0
    80002d3e:	8b2e                	mv	s6,a1
    80002d40:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d42:	00054703          	lbu	a4,0(a0)
    80002d46:	02f00793          	li	a5,47
    80002d4a:	00f70e63          	beq	a4,a5,80002d66 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d4e:	888fe0ef          	jal	80000dd6 <myproc>
    80002d52:	15053503          	ld	a0,336(a0)
    80002d56:	94bff0ef          	jal	800026a0 <idup>
    80002d5a:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002d5c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002d60:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d62:	4b85                	li	s7,1
    80002d64:	a871                	j	80002e00 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002d66:	4585                	li	a1,1
    80002d68:	4505                	li	a0,1
    80002d6a:	ef8ff0ef          	jal	80002462 <iget>
    80002d6e:	8a2a                	mv	s4,a0
    80002d70:	b7f5                	j	80002d5c <namex+0x3a>
      iunlockput(ip);
    80002d72:	8552                	mv	a0,s4
    80002d74:	b6dff0ef          	jal	800028e0 <iunlockput>
      return 0;
    80002d78:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d7a:	8552                	mv	a0,s4
    80002d7c:	60e6                	ld	ra,88(sp)
    80002d7e:	6446                	ld	s0,80(sp)
    80002d80:	64a6                	ld	s1,72(sp)
    80002d82:	6906                	ld	s2,64(sp)
    80002d84:	79e2                	ld	s3,56(sp)
    80002d86:	7a42                	ld	s4,48(sp)
    80002d88:	7aa2                	ld	s5,40(sp)
    80002d8a:	7b02                	ld	s6,32(sp)
    80002d8c:	6be2                	ld	s7,24(sp)
    80002d8e:	6c42                	ld	s8,16(sp)
    80002d90:	6ca2                	ld	s9,8(sp)
    80002d92:	6125                	addi	sp,sp,96
    80002d94:	8082                	ret
      iunlock(ip);
    80002d96:	8552                	mv	a0,s4
    80002d98:	9edff0ef          	jal	80002784 <iunlock>
      return ip;
    80002d9c:	bff9                	j	80002d7a <namex+0x58>
      iunlockput(ip);
    80002d9e:	8552                	mv	a0,s4
    80002da0:	b41ff0ef          	jal	800028e0 <iunlockput>
      return 0;
    80002da4:	8a4e                	mv	s4,s3
    80002da6:	bfd1                	j	80002d7a <namex+0x58>
  len = path - s;
    80002da8:	40998633          	sub	a2,s3,s1
    80002dac:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002db0:	099c5063          	bge	s8,s9,80002e30 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002db4:	4639                	li	a2,14
    80002db6:	85a6                	mv	a1,s1
    80002db8:	8556                	mv	a0,s5
    80002dba:	bf0fd0ef          	jal	800001aa <memmove>
    80002dbe:	84ce                	mv	s1,s3
  while(*path == '/')
    80002dc0:	0004c783          	lbu	a5,0(s1)
    80002dc4:	01279763          	bne	a5,s2,80002dd2 <namex+0xb0>
    path++;
    80002dc8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002dca:	0004c783          	lbu	a5,0(s1)
    80002dce:	ff278de3          	beq	a5,s2,80002dc8 <namex+0xa6>
    ilock(ip);
    80002dd2:	8552                	mv	a0,s4
    80002dd4:	903ff0ef          	jal	800026d6 <ilock>
    if(ip->type != T_DIR){
    80002dd8:	044a1783          	lh	a5,68(s4)
    80002ddc:	f9779be3          	bne	a5,s7,80002d72 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002de0:	000b0563          	beqz	s6,80002dea <namex+0xc8>
    80002de4:	0004c783          	lbu	a5,0(s1)
    80002de8:	d7dd                	beqz	a5,80002d96 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002dea:	4601                	li	a2,0
    80002dec:	85d6                	mv	a1,s5
    80002dee:	8552                	mv	a0,s4
    80002df0:	e97ff0ef          	jal	80002c86 <dirlookup>
    80002df4:	89aa                	mv	s3,a0
    80002df6:	d545                	beqz	a0,80002d9e <namex+0x7c>
    iunlockput(ip);
    80002df8:	8552                	mv	a0,s4
    80002dfa:	ae7ff0ef          	jal	800028e0 <iunlockput>
    ip = next;
    80002dfe:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002e00:	0004c783          	lbu	a5,0(s1)
    80002e04:	01279763          	bne	a5,s2,80002e12 <namex+0xf0>
    path++;
    80002e08:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e0a:	0004c783          	lbu	a5,0(s1)
    80002e0e:	ff278de3          	beq	a5,s2,80002e08 <namex+0xe6>
  if(*path == 0)
    80002e12:	cb8d                	beqz	a5,80002e44 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002e14:	0004c783          	lbu	a5,0(s1)
    80002e18:	89a6                	mv	s3,s1
  len = path - s;
    80002e1a:	4c81                	li	s9,0
    80002e1c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002e1e:	01278963          	beq	a5,s2,80002e30 <namex+0x10e>
    80002e22:	d3d9                	beqz	a5,80002da8 <namex+0x86>
    path++;
    80002e24:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002e26:	0009c783          	lbu	a5,0(s3)
    80002e2a:	ff279ce3          	bne	a5,s2,80002e22 <namex+0x100>
    80002e2e:	bfad                	j	80002da8 <namex+0x86>
    memmove(name, s, len);
    80002e30:	2601                	sext.w	a2,a2
    80002e32:	85a6                	mv	a1,s1
    80002e34:	8556                	mv	a0,s5
    80002e36:	b74fd0ef          	jal	800001aa <memmove>
    name[len] = 0;
    80002e3a:	9cd6                	add	s9,s9,s5
    80002e3c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002e40:	84ce                	mv	s1,s3
    80002e42:	bfbd                	j	80002dc0 <namex+0x9e>
  if(nameiparent){
    80002e44:	f20b0be3          	beqz	s6,80002d7a <namex+0x58>
    iput(ip);
    80002e48:	8552                	mv	a0,s4
    80002e4a:	a0fff0ef          	jal	80002858 <iput>
    return 0;
    80002e4e:	4a01                	li	s4,0
    80002e50:	b72d                	j	80002d7a <namex+0x58>

0000000080002e52 <dirlink>:
{
    80002e52:	7139                	addi	sp,sp,-64
    80002e54:	fc06                	sd	ra,56(sp)
    80002e56:	f822                	sd	s0,48(sp)
    80002e58:	f04a                	sd	s2,32(sp)
    80002e5a:	ec4e                	sd	s3,24(sp)
    80002e5c:	e852                	sd	s4,16(sp)
    80002e5e:	0080                	addi	s0,sp,64
    80002e60:	892a                	mv	s2,a0
    80002e62:	8a2e                	mv	s4,a1
    80002e64:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e66:	4601                	li	a2,0
    80002e68:	e1fff0ef          	jal	80002c86 <dirlookup>
    80002e6c:	e535                	bnez	a0,80002ed8 <dirlink+0x86>
    80002e6e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e70:	04c92483          	lw	s1,76(s2)
    80002e74:	c48d                	beqz	s1,80002e9e <dirlink+0x4c>
    80002e76:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e78:	4741                	li	a4,16
    80002e7a:	86a6                	mv	a3,s1
    80002e7c:	fc040613          	addi	a2,s0,-64
    80002e80:	4581                	li	a1,0
    80002e82:	854a                	mv	a0,s2
    80002e84:	be3ff0ef          	jal	80002a66 <readi>
    80002e88:	47c1                	li	a5,16
    80002e8a:	04f51b63          	bne	a0,a5,80002ee0 <dirlink+0x8e>
    if(de.inum == 0)
    80002e8e:	fc045783          	lhu	a5,-64(s0)
    80002e92:	c791                	beqz	a5,80002e9e <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e94:	24c1                	addiw	s1,s1,16
    80002e96:	04c92783          	lw	a5,76(s2)
    80002e9a:	fcf4efe3          	bltu	s1,a5,80002e78 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002e9e:	4639                	li	a2,14
    80002ea0:	85d2                	mv	a1,s4
    80002ea2:	fc240513          	addi	a0,s0,-62
    80002ea6:	baafd0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    80002eaa:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002eae:	4741                	li	a4,16
    80002eb0:	86a6                	mv	a3,s1
    80002eb2:	fc040613          	addi	a2,s0,-64
    80002eb6:	4581                	li	a1,0
    80002eb8:	854a                	mv	a0,s2
    80002eba:	ca9ff0ef          	jal	80002b62 <writei>
    80002ebe:	1541                	addi	a0,a0,-16
    80002ec0:	00a03533          	snez	a0,a0
    80002ec4:	40a00533          	neg	a0,a0
    80002ec8:	74a2                	ld	s1,40(sp)
}
    80002eca:	70e2                	ld	ra,56(sp)
    80002ecc:	7442                	ld	s0,48(sp)
    80002ece:	7902                	ld	s2,32(sp)
    80002ed0:	69e2                	ld	s3,24(sp)
    80002ed2:	6a42                	ld	s4,16(sp)
    80002ed4:	6121                	addi	sp,sp,64
    80002ed6:	8082                	ret
    iput(ip);
    80002ed8:	981ff0ef          	jal	80002858 <iput>
    return -1;
    80002edc:	557d                	li	a0,-1
    80002ede:	b7f5                	j	80002eca <dirlink+0x78>
      panic("dirlink read");
    80002ee0:	00005517          	auipc	a0,0x5
    80002ee4:	5a050513          	addi	a0,a0,1440 # 80008480 <etext+0x480>
    80002ee8:	702030ef          	jal	800065ea <panic>

0000000080002eec <namei>:

struct inode*
namei(char *path)
{
    80002eec:	1101                	addi	sp,sp,-32
    80002eee:	ec06                	sd	ra,24(sp)
    80002ef0:	e822                	sd	s0,16(sp)
    80002ef2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002ef4:	fe040613          	addi	a2,s0,-32
    80002ef8:	4581                	li	a1,0
    80002efa:	e29ff0ef          	jal	80002d22 <namex>
}
    80002efe:	60e2                	ld	ra,24(sp)
    80002f00:	6442                	ld	s0,16(sp)
    80002f02:	6105                	addi	sp,sp,32
    80002f04:	8082                	ret

0000000080002f06 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002f06:	1141                	addi	sp,sp,-16
    80002f08:	e406                	sd	ra,8(sp)
    80002f0a:	e022                	sd	s0,0(sp)
    80002f0c:	0800                	addi	s0,sp,16
    80002f0e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002f10:	4585                	li	a1,1
    80002f12:	e11ff0ef          	jal	80002d22 <namex>
}
    80002f16:	60a2                	ld	ra,8(sp)
    80002f18:	6402                	ld	s0,0(sp)
    80002f1a:	0141                	addi	sp,sp,16
    80002f1c:	8082                	ret

0000000080002f1e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002f1e:	1101                	addi	sp,sp,-32
    80002f20:	ec06                	sd	ra,24(sp)
    80002f22:	e822                	sd	s0,16(sp)
    80002f24:	e426                	sd	s1,8(sp)
    80002f26:	e04a                	sd	s2,0(sp)
    80002f28:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002f2a:	00019917          	auipc	s2,0x19
    80002f2e:	a0690913          	addi	s2,s2,-1530 # 8001b930 <log>
    80002f32:	01892583          	lw	a1,24(s2)
    80002f36:	02492503          	lw	a0,36(s2)
    80002f3a:	8d0ff0ef          	jal	8000200a <bread>
    80002f3e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f40:	02892603          	lw	a2,40(s2)
    80002f44:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f46:	00c05f63          	blez	a2,80002f64 <write_head+0x46>
    80002f4a:	00019717          	auipc	a4,0x19
    80002f4e:	a1270713          	addi	a4,a4,-1518 # 8001b95c <log+0x2c>
    80002f52:	87aa                	mv	a5,a0
    80002f54:	060a                	slli	a2,a2,0x2
    80002f56:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002f58:	4314                	lw	a3,0(a4)
    80002f5a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002f5c:	0711                	addi	a4,a4,4
    80002f5e:	0791                	addi	a5,a5,4
    80002f60:	fec79ce3          	bne	a5,a2,80002f58 <write_head+0x3a>
  }
  bwrite(buf);
    80002f64:	8526                	mv	a0,s1
    80002f66:	97aff0ef          	jal	800020e0 <bwrite>
  brelse(buf);
    80002f6a:	8526                	mv	a0,s1
    80002f6c:	9a6ff0ef          	jal	80002112 <brelse>
}
    80002f70:	60e2                	ld	ra,24(sp)
    80002f72:	6442                	ld	s0,16(sp)
    80002f74:	64a2                	ld	s1,8(sp)
    80002f76:	6902                	ld	s2,0(sp)
    80002f78:	6105                	addi	sp,sp,32
    80002f7a:	8082                	ret

0000000080002f7c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f7c:	00019797          	auipc	a5,0x19
    80002f80:	9dc7a783          	lw	a5,-1572(a5) # 8001b958 <log+0x28>
    80002f84:	0af05e63          	blez	a5,80003040 <install_trans+0xc4>
{
    80002f88:	715d                	addi	sp,sp,-80
    80002f8a:	e486                	sd	ra,72(sp)
    80002f8c:	e0a2                	sd	s0,64(sp)
    80002f8e:	fc26                	sd	s1,56(sp)
    80002f90:	f84a                	sd	s2,48(sp)
    80002f92:	f44e                	sd	s3,40(sp)
    80002f94:	f052                	sd	s4,32(sp)
    80002f96:	ec56                	sd	s5,24(sp)
    80002f98:	e85a                	sd	s6,16(sp)
    80002f9a:	e45e                	sd	s7,8(sp)
    80002f9c:	0880                	addi	s0,sp,80
    80002f9e:	8b2a                	mv	s6,a0
    80002fa0:	00019a97          	auipc	s5,0x19
    80002fa4:	9bca8a93          	addi	s5,s5,-1604 # 8001b95c <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fa8:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002faa:	00005b97          	auipc	s7,0x5
    80002fae:	4e6b8b93          	addi	s7,s7,1254 # 80008490 <etext+0x490>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fb2:	00019a17          	auipc	s4,0x19
    80002fb6:	97ea0a13          	addi	s4,s4,-1666 # 8001b930 <log>
    80002fba:	a025                	j	80002fe2 <install_trans+0x66>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002fbc:	000aa603          	lw	a2,0(s5)
    80002fc0:	85ce                	mv	a1,s3
    80002fc2:	855e                	mv	a0,s7
    80002fc4:	340030ef          	jal	80006304 <printf>
    80002fc8:	a839                	j	80002fe6 <install_trans+0x6a>
    brelse(lbuf);
    80002fca:	854a                	mv	a0,s2
    80002fcc:	946ff0ef          	jal	80002112 <brelse>
    brelse(dbuf);
    80002fd0:	8526                	mv	a0,s1
    80002fd2:	940ff0ef          	jal	80002112 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fd6:	2985                	addiw	s3,s3,1
    80002fd8:	0a91                	addi	s5,s5,4
    80002fda:	028a2783          	lw	a5,40(s4)
    80002fde:	04f9d663          	bge	s3,a5,8000302a <install_trans+0xae>
    if(recovering) {
    80002fe2:	fc0b1de3          	bnez	s6,80002fbc <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fe6:	018a2583          	lw	a1,24(s4)
    80002fea:	013585bb          	addw	a1,a1,s3
    80002fee:	2585                	addiw	a1,a1,1
    80002ff0:	024a2503          	lw	a0,36(s4)
    80002ff4:	816ff0ef          	jal	8000200a <bread>
    80002ff8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002ffa:	000aa583          	lw	a1,0(s5)
    80002ffe:	024a2503          	lw	a0,36(s4)
    80003002:	808ff0ef          	jal	8000200a <bread>
    80003006:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003008:	40000613          	li	a2,1024
    8000300c:	05890593          	addi	a1,s2,88
    80003010:	05850513          	addi	a0,a0,88
    80003014:	996fd0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    80003018:	8526                	mv	a0,s1
    8000301a:	8c6ff0ef          	jal	800020e0 <bwrite>
    if(recovering == 0)
    8000301e:	fa0b16e3          	bnez	s6,80002fca <install_trans+0x4e>
      bunpin(dbuf);
    80003022:	8526                	mv	a0,s1
    80003024:	9aaff0ef          	jal	800021ce <bunpin>
    80003028:	b74d                	j	80002fca <install_trans+0x4e>
}
    8000302a:	60a6                	ld	ra,72(sp)
    8000302c:	6406                	ld	s0,64(sp)
    8000302e:	74e2                	ld	s1,56(sp)
    80003030:	7942                	ld	s2,48(sp)
    80003032:	79a2                	ld	s3,40(sp)
    80003034:	7a02                	ld	s4,32(sp)
    80003036:	6ae2                	ld	s5,24(sp)
    80003038:	6b42                	ld	s6,16(sp)
    8000303a:	6ba2                	ld	s7,8(sp)
    8000303c:	6161                	addi	sp,sp,80
    8000303e:	8082                	ret
    80003040:	8082                	ret

0000000080003042 <initlog>:
{
    80003042:	7179                	addi	sp,sp,-48
    80003044:	f406                	sd	ra,40(sp)
    80003046:	f022                	sd	s0,32(sp)
    80003048:	ec26                	sd	s1,24(sp)
    8000304a:	e84a                	sd	s2,16(sp)
    8000304c:	e44e                	sd	s3,8(sp)
    8000304e:	1800                	addi	s0,sp,48
    80003050:	892a                	mv	s2,a0
    80003052:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003054:	00019497          	auipc	s1,0x19
    80003058:	8dc48493          	addi	s1,s1,-1828 # 8001b930 <log>
    8000305c:	00005597          	auipc	a1,0x5
    80003060:	45458593          	addi	a1,a1,1108 # 800084b0 <etext+0x4b0>
    80003064:	8526                	mv	a0,s1
    80003066:	7c0030ef          	jal	80006826 <initlock>
  log.start = sb->logstart;
    8000306a:	0149a583          	lw	a1,20(s3)
    8000306e:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80003070:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003074:	854a                	mv	a0,s2
    80003076:	f95fe0ef          	jal	8000200a <bread>
  log.lh.n = lh->n;
    8000307a:	4d30                	lw	a2,88(a0)
    8000307c:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000307e:	00c05f63          	blez	a2,8000309c <initlog+0x5a>
    80003082:	87aa                	mv	a5,a0
    80003084:	00019717          	auipc	a4,0x19
    80003088:	8d870713          	addi	a4,a4,-1832 # 8001b95c <log+0x2c>
    8000308c:	060a                	slli	a2,a2,0x2
    8000308e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003090:	4ff4                	lw	a3,92(a5)
    80003092:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003094:	0791                	addi	a5,a5,4
    80003096:	0711                	addi	a4,a4,4
    80003098:	fec79ce3          	bne	a5,a2,80003090 <initlog+0x4e>
  brelse(buf);
    8000309c:	876ff0ef          	jal	80002112 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800030a0:	4505                	li	a0,1
    800030a2:	edbff0ef          	jal	80002f7c <install_trans>
  log.lh.n = 0;
    800030a6:	00019797          	auipc	a5,0x19
    800030aa:	8a07a923          	sw	zero,-1870(a5) # 8001b958 <log+0x28>
  write_head(); // clear the log
    800030ae:	e71ff0ef          	jal	80002f1e <write_head>
}
    800030b2:	70a2                	ld	ra,40(sp)
    800030b4:	7402                	ld	s0,32(sp)
    800030b6:	64e2                	ld	s1,24(sp)
    800030b8:	6942                	ld	s2,16(sp)
    800030ba:	69a2                	ld	s3,8(sp)
    800030bc:	6145                	addi	sp,sp,48
    800030be:	8082                	ret

00000000800030c0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800030c0:	1101                	addi	sp,sp,-32
    800030c2:	ec06                	sd	ra,24(sp)
    800030c4:	e822                	sd	s0,16(sp)
    800030c6:	e426                	sd	s1,8(sp)
    800030c8:	e04a                	sd	s2,0(sp)
    800030ca:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800030cc:	00019517          	auipc	a0,0x19
    800030d0:	86450513          	addi	a0,a0,-1948 # 8001b930 <log>
    800030d4:	7d2030ef          	jal	800068a6 <acquire>
  while(1){
    if(log.committing){
    800030d8:	00019497          	auipc	s1,0x19
    800030dc:	85848493          	addi	s1,s1,-1960 # 8001b930 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800030e0:	4979                	li	s2,30
    800030e2:	a029                	j	800030ec <begin_op+0x2c>
      sleep(&log, &log.lock);
    800030e4:	85a6                	mv	a1,s1
    800030e6:	8526                	mv	a0,s1
    800030e8:	ae6fe0ef          	jal	800013ce <sleep>
    if(log.committing){
    800030ec:	509c                	lw	a5,32(s1)
    800030ee:	fbfd                	bnez	a5,800030e4 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800030f0:	4cd8                	lw	a4,28(s1)
    800030f2:	2705                	addiw	a4,a4,1
    800030f4:	0027179b          	slliw	a5,a4,0x2
    800030f8:	9fb9                	addw	a5,a5,a4
    800030fa:	0017979b          	slliw	a5,a5,0x1
    800030fe:	5494                	lw	a3,40(s1)
    80003100:	9fb5                	addw	a5,a5,a3
    80003102:	00f95763          	bge	s2,a5,80003110 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003106:	85a6                	mv	a1,s1
    80003108:	8526                	mv	a0,s1
    8000310a:	ac4fe0ef          	jal	800013ce <sleep>
    8000310e:	bff9                	j	800030ec <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003110:	00019517          	auipc	a0,0x19
    80003114:	82050513          	addi	a0,a0,-2016 # 8001b930 <log>
    80003118:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    8000311a:	025030ef          	jal	8000693e <release>
      break;
    }
  }
}
    8000311e:	60e2                	ld	ra,24(sp)
    80003120:	6442                	ld	s0,16(sp)
    80003122:	64a2                	ld	s1,8(sp)
    80003124:	6902                	ld	s2,0(sp)
    80003126:	6105                	addi	sp,sp,32
    80003128:	8082                	ret

000000008000312a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000312a:	7139                	addi	sp,sp,-64
    8000312c:	fc06                	sd	ra,56(sp)
    8000312e:	f822                	sd	s0,48(sp)
    80003130:	f426                	sd	s1,40(sp)
    80003132:	f04a                	sd	s2,32(sp)
    80003134:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003136:	00018497          	auipc	s1,0x18
    8000313a:	7fa48493          	addi	s1,s1,2042 # 8001b930 <log>
    8000313e:	8526                	mv	a0,s1
    80003140:	766030ef          	jal	800068a6 <acquire>
  log.outstanding -= 1;
    80003144:	4cdc                	lw	a5,28(s1)
    80003146:	37fd                	addiw	a5,a5,-1
    80003148:	0007891b          	sext.w	s2,a5
    8000314c:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    8000314e:	509c                	lw	a5,32(s1)
    80003150:	ef9d                	bnez	a5,8000318e <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003152:	04091763          	bnez	s2,800031a0 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003156:	00018497          	auipc	s1,0x18
    8000315a:	7da48493          	addi	s1,s1,2010 # 8001b930 <log>
    8000315e:	4785                	li	a5,1
    80003160:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003162:	8526                	mv	a0,s1
    80003164:	7da030ef          	jal	8000693e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003168:	549c                	lw	a5,40(s1)
    8000316a:	04f04b63          	bgtz	a5,800031c0 <end_op+0x96>
    acquire(&log.lock);
    8000316e:	00018497          	auipc	s1,0x18
    80003172:	7c248493          	addi	s1,s1,1986 # 8001b930 <log>
    80003176:	8526                	mv	a0,s1
    80003178:	72e030ef          	jal	800068a6 <acquire>
    log.committing = 0;
    8000317c:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003180:	8526                	mv	a0,s1
    80003182:	a98fe0ef          	jal	8000141a <wakeup>
    release(&log.lock);
    80003186:	8526                	mv	a0,s1
    80003188:	7b6030ef          	jal	8000693e <release>
}
    8000318c:	a025                	j	800031b4 <end_op+0x8a>
    8000318e:	ec4e                	sd	s3,24(sp)
    80003190:	e852                	sd	s4,16(sp)
    80003192:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003194:	00005517          	auipc	a0,0x5
    80003198:	32450513          	addi	a0,a0,804 # 800084b8 <etext+0x4b8>
    8000319c:	44e030ef          	jal	800065ea <panic>
    wakeup(&log);
    800031a0:	00018497          	auipc	s1,0x18
    800031a4:	79048493          	addi	s1,s1,1936 # 8001b930 <log>
    800031a8:	8526                	mv	a0,s1
    800031aa:	a70fe0ef          	jal	8000141a <wakeup>
  release(&log.lock);
    800031ae:	8526                	mv	a0,s1
    800031b0:	78e030ef          	jal	8000693e <release>
}
    800031b4:	70e2                	ld	ra,56(sp)
    800031b6:	7442                	ld	s0,48(sp)
    800031b8:	74a2                	ld	s1,40(sp)
    800031ba:	7902                	ld	s2,32(sp)
    800031bc:	6121                	addi	sp,sp,64
    800031be:	8082                	ret
    800031c0:	ec4e                	sd	s3,24(sp)
    800031c2:	e852                	sd	s4,16(sp)
    800031c4:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800031c6:	00018a97          	auipc	s5,0x18
    800031ca:	796a8a93          	addi	s5,s5,1942 # 8001b95c <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800031ce:	00018a17          	auipc	s4,0x18
    800031d2:	762a0a13          	addi	s4,s4,1890 # 8001b930 <log>
    800031d6:	018a2583          	lw	a1,24(s4)
    800031da:	012585bb          	addw	a1,a1,s2
    800031de:	2585                	addiw	a1,a1,1
    800031e0:	024a2503          	lw	a0,36(s4)
    800031e4:	e27fe0ef          	jal	8000200a <bread>
    800031e8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800031ea:	000aa583          	lw	a1,0(s5)
    800031ee:	024a2503          	lw	a0,36(s4)
    800031f2:	e19fe0ef          	jal	8000200a <bread>
    800031f6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800031f8:	40000613          	li	a2,1024
    800031fc:	05850593          	addi	a1,a0,88
    80003200:	05848513          	addi	a0,s1,88
    80003204:	fa7fc0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    80003208:	8526                	mv	a0,s1
    8000320a:	ed7fe0ef          	jal	800020e0 <bwrite>
    brelse(from);
    8000320e:	854e                	mv	a0,s3
    80003210:	f03fe0ef          	jal	80002112 <brelse>
    brelse(to);
    80003214:	8526                	mv	a0,s1
    80003216:	efdfe0ef          	jal	80002112 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000321a:	2905                	addiw	s2,s2,1
    8000321c:	0a91                	addi	s5,s5,4
    8000321e:	028a2783          	lw	a5,40(s4)
    80003222:	faf94ae3          	blt	s2,a5,800031d6 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003226:	cf9ff0ef          	jal	80002f1e <write_head>
    install_trans(0); // Now install writes to home locations
    8000322a:	4501                	li	a0,0
    8000322c:	d51ff0ef          	jal	80002f7c <install_trans>
    log.lh.n = 0;
    80003230:	00018797          	auipc	a5,0x18
    80003234:	7207a423          	sw	zero,1832(a5) # 8001b958 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003238:	ce7ff0ef          	jal	80002f1e <write_head>
    8000323c:	69e2                	ld	s3,24(sp)
    8000323e:	6a42                	ld	s4,16(sp)
    80003240:	6aa2                	ld	s5,8(sp)
    80003242:	b735                	j	8000316e <end_op+0x44>

0000000080003244 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003244:	1101                	addi	sp,sp,-32
    80003246:	ec06                	sd	ra,24(sp)
    80003248:	e822                	sd	s0,16(sp)
    8000324a:	e426                	sd	s1,8(sp)
    8000324c:	e04a                	sd	s2,0(sp)
    8000324e:	1000                	addi	s0,sp,32
    80003250:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003252:	00018917          	auipc	s2,0x18
    80003256:	6de90913          	addi	s2,s2,1758 # 8001b930 <log>
    8000325a:	854a                	mv	a0,s2
    8000325c:	64a030ef          	jal	800068a6 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003260:	02892603          	lw	a2,40(s2)
    80003264:	47f5                	li	a5,29
    80003266:	04c7cc63          	blt	a5,a2,800032be <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000326a:	00018797          	auipc	a5,0x18
    8000326e:	6e27a783          	lw	a5,1762(a5) # 8001b94c <log+0x1c>
    80003272:	04f05c63          	blez	a5,800032ca <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003276:	4781                	li	a5,0
    80003278:	04c05f63          	blez	a2,800032d6 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000327c:	44cc                	lw	a1,12(s1)
    8000327e:	00018717          	auipc	a4,0x18
    80003282:	6de70713          	addi	a4,a4,1758 # 8001b95c <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003286:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003288:	4314                	lw	a3,0(a4)
    8000328a:	04b68663          	beq	a3,a1,800032d6 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    8000328e:	2785                	addiw	a5,a5,1
    80003290:	0711                	addi	a4,a4,4
    80003292:	fef61be3          	bne	a2,a5,80003288 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003296:	0621                	addi	a2,a2,8
    80003298:	060a                	slli	a2,a2,0x2
    8000329a:	00018797          	auipc	a5,0x18
    8000329e:	69678793          	addi	a5,a5,1686 # 8001b930 <log>
    800032a2:	97b2                	add	a5,a5,a2
    800032a4:	44d8                	lw	a4,12(s1)
    800032a6:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800032a8:	8526                	mv	a0,s1
    800032aa:	ef1fe0ef          	jal	8000219a <bpin>
    log.lh.n++;
    800032ae:	00018717          	auipc	a4,0x18
    800032b2:	68270713          	addi	a4,a4,1666 # 8001b930 <log>
    800032b6:	571c                	lw	a5,40(a4)
    800032b8:	2785                	addiw	a5,a5,1
    800032ba:	d71c                	sw	a5,40(a4)
    800032bc:	a80d                	j	800032ee <log_write+0xaa>
    panic("too big a transaction");
    800032be:	00005517          	auipc	a0,0x5
    800032c2:	20a50513          	addi	a0,a0,522 # 800084c8 <etext+0x4c8>
    800032c6:	324030ef          	jal	800065ea <panic>
    panic("log_write outside of trans");
    800032ca:	00005517          	auipc	a0,0x5
    800032ce:	21650513          	addi	a0,a0,534 # 800084e0 <etext+0x4e0>
    800032d2:	318030ef          	jal	800065ea <panic>
  log.lh.block[i] = b->blockno;
    800032d6:	00878693          	addi	a3,a5,8
    800032da:	068a                	slli	a3,a3,0x2
    800032dc:	00018717          	auipc	a4,0x18
    800032e0:	65470713          	addi	a4,a4,1620 # 8001b930 <log>
    800032e4:	9736                	add	a4,a4,a3
    800032e6:	44d4                	lw	a3,12(s1)
    800032e8:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800032ea:	faf60fe3          	beq	a2,a5,800032a8 <log_write+0x64>
  }
  release(&log.lock);
    800032ee:	00018517          	auipc	a0,0x18
    800032f2:	64250513          	addi	a0,a0,1602 # 8001b930 <log>
    800032f6:	648030ef          	jal	8000693e <release>
}
    800032fa:	60e2                	ld	ra,24(sp)
    800032fc:	6442                	ld	s0,16(sp)
    800032fe:	64a2                	ld	s1,8(sp)
    80003300:	6902                	ld	s2,0(sp)
    80003302:	6105                	addi	sp,sp,32
    80003304:	8082                	ret

0000000080003306 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003306:	1101                	addi	sp,sp,-32
    80003308:	ec06                	sd	ra,24(sp)
    8000330a:	e822                	sd	s0,16(sp)
    8000330c:	e426                	sd	s1,8(sp)
    8000330e:	e04a                	sd	s2,0(sp)
    80003310:	1000                	addi	s0,sp,32
    80003312:	84aa                	mv	s1,a0
    80003314:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003316:	00005597          	auipc	a1,0x5
    8000331a:	1ea58593          	addi	a1,a1,490 # 80008500 <etext+0x500>
    8000331e:	0521                	addi	a0,a0,8
    80003320:	506030ef          	jal	80006826 <initlock>
  lk->name = name;
    80003324:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003328:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000332c:	0204a423          	sw	zero,40(s1)
}
    80003330:	60e2                	ld	ra,24(sp)
    80003332:	6442                	ld	s0,16(sp)
    80003334:	64a2                	ld	s1,8(sp)
    80003336:	6902                	ld	s2,0(sp)
    80003338:	6105                	addi	sp,sp,32
    8000333a:	8082                	ret

000000008000333c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000333c:	1101                	addi	sp,sp,-32
    8000333e:	ec06                	sd	ra,24(sp)
    80003340:	e822                	sd	s0,16(sp)
    80003342:	e426                	sd	s1,8(sp)
    80003344:	e04a                	sd	s2,0(sp)
    80003346:	1000                	addi	s0,sp,32
    80003348:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000334a:	00850913          	addi	s2,a0,8
    8000334e:	854a                	mv	a0,s2
    80003350:	556030ef          	jal	800068a6 <acquire>
  while (lk->locked) {
    80003354:	409c                	lw	a5,0(s1)
    80003356:	c799                	beqz	a5,80003364 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003358:	85ca                	mv	a1,s2
    8000335a:	8526                	mv	a0,s1
    8000335c:	872fe0ef          	jal	800013ce <sleep>
  while (lk->locked) {
    80003360:	409c                	lw	a5,0(s1)
    80003362:	fbfd                	bnez	a5,80003358 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003364:	4785                	li	a5,1
    80003366:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003368:	a6ffd0ef          	jal	80000dd6 <myproc>
    8000336c:	591c                	lw	a5,48(a0)
    8000336e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003370:	854a                	mv	a0,s2
    80003372:	5cc030ef          	jal	8000693e <release>
}
    80003376:	60e2                	ld	ra,24(sp)
    80003378:	6442                	ld	s0,16(sp)
    8000337a:	64a2                	ld	s1,8(sp)
    8000337c:	6902                	ld	s2,0(sp)
    8000337e:	6105                	addi	sp,sp,32
    80003380:	8082                	ret

0000000080003382 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003382:	1101                	addi	sp,sp,-32
    80003384:	ec06                	sd	ra,24(sp)
    80003386:	e822                	sd	s0,16(sp)
    80003388:	e426                	sd	s1,8(sp)
    8000338a:	e04a                	sd	s2,0(sp)
    8000338c:	1000                	addi	s0,sp,32
    8000338e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003390:	00850913          	addi	s2,a0,8
    80003394:	854a                	mv	a0,s2
    80003396:	510030ef          	jal	800068a6 <acquire>
  lk->locked = 0;
    8000339a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000339e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800033a2:	8526                	mv	a0,s1
    800033a4:	876fe0ef          	jal	8000141a <wakeup>
  release(&lk->lk);
    800033a8:	854a                	mv	a0,s2
    800033aa:	594030ef          	jal	8000693e <release>
}
    800033ae:	60e2                	ld	ra,24(sp)
    800033b0:	6442                	ld	s0,16(sp)
    800033b2:	64a2                	ld	s1,8(sp)
    800033b4:	6902                	ld	s2,0(sp)
    800033b6:	6105                	addi	sp,sp,32
    800033b8:	8082                	ret

00000000800033ba <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800033ba:	7179                	addi	sp,sp,-48
    800033bc:	f406                	sd	ra,40(sp)
    800033be:	f022                	sd	s0,32(sp)
    800033c0:	ec26                	sd	s1,24(sp)
    800033c2:	e84a                	sd	s2,16(sp)
    800033c4:	1800                	addi	s0,sp,48
    800033c6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800033c8:	00850913          	addi	s2,a0,8
    800033cc:	854a                	mv	a0,s2
    800033ce:	4d8030ef          	jal	800068a6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800033d2:	409c                	lw	a5,0(s1)
    800033d4:	ef81                	bnez	a5,800033ec <holdingsleep+0x32>
    800033d6:	4481                	li	s1,0
  release(&lk->lk);
    800033d8:	854a                	mv	a0,s2
    800033da:	564030ef          	jal	8000693e <release>
  return r;
}
    800033de:	8526                	mv	a0,s1
    800033e0:	70a2                	ld	ra,40(sp)
    800033e2:	7402                	ld	s0,32(sp)
    800033e4:	64e2                	ld	s1,24(sp)
    800033e6:	6942                	ld	s2,16(sp)
    800033e8:	6145                	addi	sp,sp,48
    800033ea:	8082                	ret
    800033ec:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800033ee:	0284a983          	lw	s3,40(s1)
    800033f2:	9e5fd0ef          	jal	80000dd6 <myproc>
    800033f6:	5904                	lw	s1,48(a0)
    800033f8:	413484b3          	sub	s1,s1,s3
    800033fc:	0014b493          	seqz	s1,s1
    80003400:	69a2                	ld	s3,8(sp)
    80003402:	bfd9                	j	800033d8 <holdingsleep+0x1e>

0000000080003404 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003404:	1141                	addi	sp,sp,-16
    80003406:	e406                	sd	ra,8(sp)
    80003408:	e022                	sd	s0,0(sp)
    8000340a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000340c:	00005597          	auipc	a1,0x5
    80003410:	10458593          	addi	a1,a1,260 # 80008510 <etext+0x510>
    80003414:	00018517          	auipc	a0,0x18
    80003418:	66450513          	addi	a0,a0,1636 # 8001ba78 <ftable>
    8000341c:	40a030ef          	jal	80006826 <initlock>
}
    80003420:	60a2                	ld	ra,8(sp)
    80003422:	6402                	ld	s0,0(sp)
    80003424:	0141                	addi	sp,sp,16
    80003426:	8082                	ret

0000000080003428 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003428:	1101                	addi	sp,sp,-32
    8000342a:	ec06                	sd	ra,24(sp)
    8000342c:	e822                	sd	s0,16(sp)
    8000342e:	e426                	sd	s1,8(sp)
    80003430:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003432:	00018517          	auipc	a0,0x18
    80003436:	64650513          	addi	a0,a0,1606 # 8001ba78 <ftable>
    8000343a:	46c030ef          	jal	800068a6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000343e:	00018497          	auipc	s1,0x18
    80003442:	65248493          	addi	s1,s1,1618 # 8001ba90 <ftable+0x18>
    80003446:	00019717          	auipc	a4,0x19
    8000344a:	5ea70713          	addi	a4,a4,1514 # 8001ca30 <disk>
    if(f->ref == 0){
    8000344e:	40dc                	lw	a5,4(s1)
    80003450:	cf89                	beqz	a5,8000346a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003452:	02848493          	addi	s1,s1,40
    80003456:	fee49ce3          	bne	s1,a4,8000344e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000345a:	00018517          	auipc	a0,0x18
    8000345e:	61e50513          	addi	a0,a0,1566 # 8001ba78 <ftable>
    80003462:	4dc030ef          	jal	8000693e <release>
  return 0;
    80003466:	4481                	li	s1,0
    80003468:	a809                	j	8000347a <filealloc+0x52>
      f->ref = 1;
    8000346a:	4785                	li	a5,1
    8000346c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000346e:	00018517          	auipc	a0,0x18
    80003472:	60a50513          	addi	a0,a0,1546 # 8001ba78 <ftable>
    80003476:	4c8030ef          	jal	8000693e <release>
}
    8000347a:	8526                	mv	a0,s1
    8000347c:	60e2                	ld	ra,24(sp)
    8000347e:	6442                	ld	s0,16(sp)
    80003480:	64a2                	ld	s1,8(sp)
    80003482:	6105                	addi	sp,sp,32
    80003484:	8082                	ret

0000000080003486 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003486:	1101                	addi	sp,sp,-32
    80003488:	ec06                	sd	ra,24(sp)
    8000348a:	e822                	sd	s0,16(sp)
    8000348c:	e426                	sd	s1,8(sp)
    8000348e:	1000                	addi	s0,sp,32
    80003490:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003492:	00018517          	auipc	a0,0x18
    80003496:	5e650513          	addi	a0,a0,1510 # 8001ba78 <ftable>
    8000349a:	40c030ef          	jal	800068a6 <acquire>
  if(f->ref < 1)
    8000349e:	40dc                	lw	a5,4(s1)
    800034a0:	02f05063          	blez	a5,800034c0 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800034a4:	2785                	addiw	a5,a5,1
    800034a6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800034a8:	00018517          	auipc	a0,0x18
    800034ac:	5d050513          	addi	a0,a0,1488 # 8001ba78 <ftable>
    800034b0:	48e030ef          	jal	8000693e <release>
  return f;
}
    800034b4:	8526                	mv	a0,s1
    800034b6:	60e2                	ld	ra,24(sp)
    800034b8:	6442                	ld	s0,16(sp)
    800034ba:	64a2                	ld	s1,8(sp)
    800034bc:	6105                	addi	sp,sp,32
    800034be:	8082                	ret
    panic("filedup");
    800034c0:	00005517          	auipc	a0,0x5
    800034c4:	05850513          	addi	a0,a0,88 # 80008518 <etext+0x518>
    800034c8:	122030ef          	jal	800065ea <panic>

00000000800034cc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800034cc:	7139                	addi	sp,sp,-64
    800034ce:	fc06                	sd	ra,56(sp)
    800034d0:	f822                	sd	s0,48(sp)
    800034d2:	f426                	sd	s1,40(sp)
    800034d4:	0080                	addi	s0,sp,64
    800034d6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800034d8:	00018517          	auipc	a0,0x18
    800034dc:	5a050513          	addi	a0,a0,1440 # 8001ba78 <ftable>
    800034e0:	3c6030ef          	jal	800068a6 <acquire>
  if(f->ref < 1)
    800034e4:	40dc                	lw	a5,4(s1)
    800034e6:	04f05a63          	blez	a5,8000353a <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800034ea:	37fd                	addiw	a5,a5,-1
    800034ec:	0007871b          	sext.w	a4,a5
    800034f0:	c0dc                	sw	a5,4(s1)
    800034f2:	04e04e63          	bgtz	a4,8000354e <fileclose+0x82>
    800034f6:	f04a                	sd	s2,32(sp)
    800034f8:	ec4e                	sd	s3,24(sp)
    800034fa:	e852                	sd	s4,16(sp)
    800034fc:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800034fe:	0004a903          	lw	s2,0(s1)
    80003502:	0094ca83          	lbu	s5,9(s1)
    80003506:	0104ba03          	ld	s4,16(s1)
    8000350a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000350e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003512:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003516:	00018517          	auipc	a0,0x18
    8000351a:	56250513          	addi	a0,a0,1378 # 8001ba78 <ftable>
    8000351e:	420030ef          	jal	8000693e <release>

  if(ff.type == FD_PIPE){
    80003522:	4785                	li	a5,1
    80003524:	04f90063          	beq	s2,a5,80003564 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003528:	3979                	addiw	s2,s2,-2
    8000352a:	4785                	li	a5,1
    8000352c:	0527f563          	bgeu	a5,s2,80003576 <fileclose+0xaa>
    80003530:	7902                	ld	s2,32(sp)
    80003532:	69e2                	ld	s3,24(sp)
    80003534:	6a42                	ld	s4,16(sp)
    80003536:	6aa2                	ld	s5,8(sp)
    80003538:	a00d                	j	8000355a <fileclose+0x8e>
    8000353a:	f04a                	sd	s2,32(sp)
    8000353c:	ec4e                	sd	s3,24(sp)
    8000353e:	e852                	sd	s4,16(sp)
    80003540:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003542:	00005517          	auipc	a0,0x5
    80003546:	fde50513          	addi	a0,a0,-34 # 80008520 <etext+0x520>
    8000354a:	0a0030ef          	jal	800065ea <panic>
    release(&ftable.lock);
    8000354e:	00018517          	auipc	a0,0x18
    80003552:	52a50513          	addi	a0,a0,1322 # 8001ba78 <ftable>
    80003556:	3e8030ef          	jal	8000693e <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000355a:	70e2                	ld	ra,56(sp)
    8000355c:	7442                	ld	s0,48(sp)
    8000355e:	74a2                	ld	s1,40(sp)
    80003560:	6121                	addi	sp,sp,64
    80003562:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003564:	85d6                	mv	a1,s5
    80003566:	8552                	mv	a0,s4
    80003568:	336000ef          	jal	8000389e <pipeclose>
    8000356c:	7902                	ld	s2,32(sp)
    8000356e:	69e2                	ld	s3,24(sp)
    80003570:	6a42                	ld	s4,16(sp)
    80003572:	6aa2                	ld	s5,8(sp)
    80003574:	b7dd                	j	8000355a <fileclose+0x8e>
    begin_op();
    80003576:	b4bff0ef          	jal	800030c0 <begin_op>
    iput(ff.ip);
    8000357a:	854e                	mv	a0,s3
    8000357c:	adcff0ef          	jal	80002858 <iput>
    end_op();
    80003580:	babff0ef          	jal	8000312a <end_op>
    80003584:	7902                	ld	s2,32(sp)
    80003586:	69e2                	ld	s3,24(sp)
    80003588:	6a42                	ld	s4,16(sp)
    8000358a:	6aa2                	ld	s5,8(sp)
    8000358c:	b7f9                	j	8000355a <fileclose+0x8e>

000000008000358e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000358e:	715d                	addi	sp,sp,-80
    80003590:	e486                	sd	ra,72(sp)
    80003592:	e0a2                	sd	s0,64(sp)
    80003594:	fc26                	sd	s1,56(sp)
    80003596:	f44e                	sd	s3,40(sp)
    80003598:	0880                	addi	s0,sp,80
    8000359a:	84aa                	mv	s1,a0
    8000359c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000359e:	839fd0ef          	jal	80000dd6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800035a2:	409c                	lw	a5,0(s1)
    800035a4:	37f9                	addiw	a5,a5,-2
    800035a6:	4705                	li	a4,1
    800035a8:	04f76063          	bltu	a4,a5,800035e8 <filestat+0x5a>
    800035ac:	f84a                	sd	s2,48(sp)
    800035ae:	892a                	mv	s2,a0
    ilock(f->ip);
    800035b0:	6c88                	ld	a0,24(s1)
    800035b2:	924ff0ef          	jal	800026d6 <ilock>
    stati(f->ip, &st);
    800035b6:	fb840593          	addi	a1,s0,-72
    800035ba:	6c88                	ld	a0,24(s1)
    800035bc:	c80ff0ef          	jal	80002a3c <stati>
    iunlock(f->ip);
    800035c0:	6c88                	ld	a0,24(s1)
    800035c2:	9c2ff0ef          	jal	80002784 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800035c6:	46e1                	li	a3,24
    800035c8:	fb840613          	addi	a2,s0,-72
    800035cc:	85ce                	mv	a1,s3
    800035ce:	05093503          	ld	a0,80(s2)
    800035d2:	d0cfd0ef          	jal	80000ade <copyout>
    800035d6:	41f5551b          	sraiw	a0,a0,0x1f
    800035da:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800035dc:	60a6                	ld	ra,72(sp)
    800035de:	6406                	ld	s0,64(sp)
    800035e0:	74e2                	ld	s1,56(sp)
    800035e2:	79a2                	ld	s3,40(sp)
    800035e4:	6161                	addi	sp,sp,80
    800035e6:	8082                	ret
  return -1;
    800035e8:	557d                	li	a0,-1
    800035ea:	bfcd                	j	800035dc <filestat+0x4e>

00000000800035ec <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800035ec:	7179                	addi	sp,sp,-48
    800035ee:	f406                	sd	ra,40(sp)
    800035f0:	f022                	sd	s0,32(sp)
    800035f2:	e84a                	sd	s2,16(sp)
    800035f4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800035f6:	00854783          	lbu	a5,8(a0)
    800035fa:	cfd1                	beqz	a5,80003696 <fileread+0xaa>
    800035fc:	ec26                	sd	s1,24(sp)
    800035fe:	e44e                	sd	s3,8(sp)
    80003600:	84aa                	mv	s1,a0
    80003602:	89ae                	mv	s3,a1
    80003604:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003606:	411c                	lw	a5,0(a0)
    80003608:	4705                	li	a4,1
    8000360a:	04e78363          	beq	a5,a4,80003650 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000360e:	470d                	li	a4,3
    80003610:	04e78763          	beq	a5,a4,8000365e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003614:	4709                	li	a4,2
    80003616:	06e79a63          	bne	a5,a4,8000368a <fileread+0x9e>
    ilock(f->ip);
    8000361a:	6d08                	ld	a0,24(a0)
    8000361c:	8baff0ef          	jal	800026d6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003620:	874a                	mv	a4,s2
    80003622:	5094                	lw	a3,32(s1)
    80003624:	864e                	mv	a2,s3
    80003626:	4585                	li	a1,1
    80003628:	6c88                	ld	a0,24(s1)
    8000362a:	c3cff0ef          	jal	80002a66 <readi>
    8000362e:	892a                	mv	s2,a0
    80003630:	00a05563          	blez	a0,8000363a <fileread+0x4e>
      f->off += r;
    80003634:	509c                	lw	a5,32(s1)
    80003636:	9fa9                	addw	a5,a5,a0
    80003638:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000363a:	6c88                	ld	a0,24(s1)
    8000363c:	948ff0ef          	jal	80002784 <iunlock>
    80003640:	64e2                	ld	s1,24(sp)
    80003642:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003644:	854a                	mv	a0,s2
    80003646:	70a2                	ld	ra,40(sp)
    80003648:	7402                	ld	s0,32(sp)
    8000364a:	6942                	ld	s2,16(sp)
    8000364c:	6145                	addi	sp,sp,48
    8000364e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003650:	6908                	ld	a0,16(a0)
    80003652:	388000ef          	jal	800039da <piperead>
    80003656:	892a                	mv	s2,a0
    80003658:	64e2                	ld	s1,24(sp)
    8000365a:	69a2                	ld	s3,8(sp)
    8000365c:	b7e5                	j	80003644 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000365e:	02451783          	lh	a5,36(a0)
    80003662:	03079693          	slli	a3,a5,0x30
    80003666:	92c1                	srli	a3,a3,0x30
    80003668:	4725                	li	a4,9
    8000366a:	02d76863          	bltu	a4,a3,8000369a <fileread+0xae>
    8000366e:	0792                	slli	a5,a5,0x4
    80003670:	00018717          	auipc	a4,0x18
    80003674:	36870713          	addi	a4,a4,872 # 8001b9d8 <devsw>
    80003678:	97ba                	add	a5,a5,a4
    8000367a:	639c                	ld	a5,0(a5)
    8000367c:	c39d                	beqz	a5,800036a2 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000367e:	4505                	li	a0,1
    80003680:	9782                	jalr	a5
    80003682:	892a                	mv	s2,a0
    80003684:	64e2                	ld	s1,24(sp)
    80003686:	69a2                	ld	s3,8(sp)
    80003688:	bf75                	j	80003644 <fileread+0x58>
    panic("fileread");
    8000368a:	00005517          	auipc	a0,0x5
    8000368e:	ea650513          	addi	a0,a0,-346 # 80008530 <etext+0x530>
    80003692:	759020ef          	jal	800065ea <panic>
    return -1;
    80003696:	597d                	li	s2,-1
    80003698:	b775                	j	80003644 <fileread+0x58>
      return -1;
    8000369a:	597d                	li	s2,-1
    8000369c:	64e2                	ld	s1,24(sp)
    8000369e:	69a2                	ld	s3,8(sp)
    800036a0:	b755                	j	80003644 <fileread+0x58>
    800036a2:	597d                	li	s2,-1
    800036a4:	64e2                	ld	s1,24(sp)
    800036a6:	69a2                	ld	s3,8(sp)
    800036a8:	bf71                	j	80003644 <fileread+0x58>

00000000800036aa <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800036aa:	00954783          	lbu	a5,9(a0)
    800036ae:	10078b63          	beqz	a5,800037c4 <filewrite+0x11a>
{
    800036b2:	715d                	addi	sp,sp,-80
    800036b4:	e486                	sd	ra,72(sp)
    800036b6:	e0a2                	sd	s0,64(sp)
    800036b8:	f84a                	sd	s2,48(sp)
    800036ba:	f052                	sd	s4,32(sp)
    800036bc:	e85a                	sd	s6,16(sp)
    800036be:	0880                	addi	s0,sp,80
    800036c0:	892a                	mv	s2,a0
    800036c2:	8b2e                	mv	s6,a1
    800036c4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800036c6:	411c                	lw	a5,0(a0)
    800036c8:	4705                	li	a4,1
    800036ca:	02e78763          	beq	a5,a4,800036f8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800036ce:	470d                	li	a4,3
    800036d0:	02e78863          	beq	a5,a4,80003700 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800036d4:	4709                	li	a4,2
    800036d6:	0ce79c63          	bne	a5,a4,800037ae <filewrite+0x104>
    800036da:	f44e                	sd	s3,40(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800036dc:	0ac05863          	blez	a2,8000378c <filewrite+0xe2>
    800036e0:	fc26                	sd	s1,56(sp)
    800036e2:	ec56                	sd	s5,24(sp)
    800036e4:	e45e                	sd	s7,8(sp)
    800036e6:	e062                	sd	s8,0(sp)
    int i = 0;
    800036e8:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800036ea:	6b85                	lui	s7,0x1
    800036ec:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800036f0:	6c05                	lui	s8,0x1
    800036f2:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800036f6:	a8b5                	j	80003772 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800036f8:	6908                	ld	a0,16(a0)
    800036fa:	1fc000ef          	jal	800038f6 <pipewrite>
    800036fe:	a04d                	j	800037a0 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003700:	02451783          	lh	a5,36(a0)
    80003704:	03079693          	slli	a3,a5,0x30
    80003708:	92c1                	srli	a3,a3,0x30
    8000370a:	4725                	li	a4,9
    8000370c:	0ad76e63          	bltu	a4,a3,800037c8 <filewrite+0x11e>
    80003710:	0792                	slli	a5,a5,0x4
    80003712:	00018717          	auipc	a4,0x18
    80003716:	2c670713          	addi	a4,a4,710 # 8001b9d8 <devsw>
    8000371a:	97ba                	add	a5,a5,a4
    8000371c:	679c                	ld	a5,8(a5)
    8000371e:	c7dd                	beqz	a5,800037cc <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003720:	4505                	li	a0,1
    80003722:	9782                	jalr	a5
    80003724:	a8b5                	j	800037a0 <filewrite+0xf6>
      if(n1 > max)
    80003726:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000372a:	997ff0ef          	jal	800030c0 <begin_op>
      ilock(f->ip);
    8000372e:	01893503          	ld	a0,24(s2)
    80003732:	fa5fe0ef          	jal	800026d6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003736:	8756                	mv	a4,s5
    80003738:	02092683          	lw	a3,32(s2)
    8000373c:	01698633          	add	a2,s3,s6
    80003740:	4585                	li	a1,1
    80003742:	01893503          	ld	a0,24(s2)
    80003746:	c1cff0ef          	jal	80002b62 <writei>
    8000374a:	84aa                	mv	s1,a0
    8000374c:	00a05763          	blez	a0,8000375a <filewrite+0xb0>
        f->off += r;
    80003750:	02092783          	lw	a5,32(s2)
    80003754:	9fa9                	addw	a5,a5,a0
    80003756:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000375a:	01893503          	ld	a0,24(s2)
    8000375e:	826ff0ef          	jal	80002784 <iunlock>
      end_op();
    80003762:	9c9ff0ef          	jal	8000312a <end_op>

      if(r != n1){
    80003766:	029a9563          	bne	s5,s1,80003790 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    8000376a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000376e:	0149da63          	bge	s3,s4,80003782 <filewrite+0xd8>
      int n1 = n - i;
    80003772:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003776:	0004879b          	sext.w	a5,s1
    8000377a:	fafbd6e3          	bge	s7,a5,80003726 <filewrite+0x7c>
    8000377e:	84e2                	mv	s1,s8
    80003780:	b75d                	j	80003726 <filewrite+0x7c>
    80003782:	74e2                	ld	s1,56(sp)
    80003784:	6ae2                	ld	s5,24(sp)
    80003786:	6ba2                	ld	s7,8(sp)
    80003788:	6c02                	ld	s8,0(sp)
    8000378a:	a039                	j	80003798 <filewrite+0xee>
    int i = 0;
    8000378c:	4981                	li	s3,0
    8000378e:	a029                	j	80003798 <filewrite+0xee>
    80003790:	74e2                	ld	s1,56(sp)
    80003792:	6ae2                	ld	s5,24(sp)
    80003794:	6ba2                	ld	s7,8(sp)
    80003796:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003798:	033a1c63          	bne	s4,s3,800037d0 <filewrite+0x126>
    8000379c:	8552                	mv	a0,s4
    8000379e:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800037a0:	60a6                	ld	ra,72(sp)
    800037a2:	6406                	ld	s0,64(sp)
    800037a4:	7942                	ld	s2,48(sp)
    800037a6:	7a02                	ld	s4,32(sp)
    800037a8:	6b42                	ld	s6,16(sp)
    800037aa:	6161                	addi	sp,sp,80
    800037ac:	8082                	ret
    800037ae:	fc26                	sd	s1,56(sp)
    800037b0:	f44e                	sd	s3,40(sp)
    800037b2:	ec56                	sd	s5,24(sp)
    800037b4:	e45e                	sd	s7,8(sp)
    800037b6:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800037b8:	00005517          	auipc	a0,0x5
    800037bc:	d8850513          	addi	a0,a0,-632 # 80008540 <etext+0x540>
    800037c0:	62b020ef          	jal	800065ea <panic>
    return -1;
    800037c4:	557d                	li	a0,-1
}
    800037c6:	8082                	ret
      return -1;
    800037c8:	557d                	li	a0,-1
    800037ca:	bfd9                	j	800037a0 <filewrite+0xf6>
    800037cc:	557d                	li	a0,-1
    800037ce:	bfc9                	j	800037a0 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800037d0:	557d                	li	a0,-1
    800037d2:	79a2                	ld	s3,40(sp)
    800037d4:	b7f1                	j	800037a0 <filewrite+0xf6>

00000000800037d6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800037d6:	7179                	addi	sp,sp,-48
    800037d8:	f406                	sd	ra,40(sp)
    800037da:	f022                	sd	s0,32(sp)
    800037dc:	ec26                	sd	s1,24(sp)
    800037de:	e052                	sd	s4,0(sp)
    800037e0:	1800                	addi	s0,sp,48
    800037e2:	84aa                	mv	s1,a0
    800037e4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800037e6:	0005b023          	sd	zero,0(a1)
    800037ea:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800037ee:	c3bff0ef          	jal	80003428 <filealloc>
    800037f2:	e088                	sd	a0,0(s1)
    800037f4:	c549                	beqz	a0,8000387e <pipealloc+0xa8>
    800037f6:	c33ff0ef          	jal	80003428 <filealloc>
    800037fa:	00aa3023          	sd	a0,0(s4)
    800037fe:	cd25                	beqz	a0,80003876 <pipealloc+0xa0>
    80003800:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003802:	8fdfc0ef          	jal	800000fe <kalloc>
    80003806:	892a                	mv	s2,a0
    80003808:	c12d                	beqz	a0,8000386a <pipealloc+0x94>
    8000380a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000380c:	4985                	li	s3,1
    8000380e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003812:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003816:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000381a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000381e:	00005597          	auipc	a1,0x5
    80003822:	d3258593          	addi	a1,a1,-718 # 80008550 <etext+0x550>
    80003826:	000030ef          	jal	80006826 <initlock>
  (*f0)->type = FD_PIPE;
    8000382a:	609c                	ld	a5,0(s1)
    8000382c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003830:	609c                	ld	a5,0(s1)
    80003832:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003836:	609c                	ld	a5,0(s1)
    80003838:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000383c:	609c                	ld	a5,0(s1)
    8000383e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003842:	000a3783          	ld	a5,0(s4)
    80003846:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000384a:	000a3783          	ld	a5,0(s4)
    8000384e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003852:	000a3783          	ld	a5,0(s4)
    80003856:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000385a:	000a3783          	ld	a5,0(s4)
    8000385e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003862:	4501                	li	a0,0
    80003864:	6942                	ld	s2,16(sp)
    80003866:	69a2                	ld	s3,8(sp)
    80003868:	a01d                	j	8000388e <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000386a:	6088                	ld	a0,0(s1)
    8000386c:	c119                	beqz	a0,80003872 <pipealloc+0x9c>
    8000386e:	6942                	ld	s2,16(sp)
    80003870:	a029                	j	8000387a <pipealloc+0xa4>
    80003872:	6942                	ld	s2,16(sp)
    80003874:	a029                	j	8000387e <pipealloc+0xa8>
    80003876:	6088                	ld	a0,0(s1)
    80003878:	c10d                	beqz	a0,8000389a <pipealloc+0xc4>
    fileclose(*f0);
    8000387a:	c53ff0ef          	jal	800034cc <fileclose>
  if(*f1)
    8000387e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003882:	557d                	li	a0,-1
  if(*f1)
    80003884:	c789                	beqz	a5,8000388e <pipealloc+0xb8>
    fileclose(*f1);
    80003886:	853e                	mv	a0,a5
    80003888:	c45ff0ef          	jal	800034cc <fileclose>
  return -1;
    8000388c:	557d                	li	a0,-1
}
    8000388e:	70a2                	ld	ra,40(sp)
    80003890:	7402                	ld	s0,32(sp)
    80003892:	64e2                	ld	s1,24(sp)
    80003894:	6a02                	ld	s4,0(sp)
    80003896:	6145                	addi	sp,sp,48
    80003898:	8082                	ret
  return -1;
    8000389a:	557d                	li	a0,-1
    8000389c:	bfcd                	j	8000388e <pipealloc+0xb8>

000000008000389e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000389e:	1101                	addi	sp,sp,-32
    800038a0:	ec06                	sd	ra,24(sp)
    800038a2:	e822                	sd	s0,16(sp)
    800038a4:	e426                	sd	s1,8(sp)
    800038a6:	e04a                	sd	s2,0(sp)
    800038a8:	1000                	addi	s0,sp,32
    800038aa:	84aa                	mv	s1,a0
    800038ac:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800038ae:	7f9020ef          	jal	800068a6 <acquire>
  if(writable){
    800038b2:	02090763          	beqz	s2,800038e0 <pipeclose+0x42>
    pi->writeopen = 0;
    800038b6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800038ba:	21848513          	addi	a0,s1,536
    800038be:	b5dfd0ef          	jal	8000141a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800038c2:	2204b783          	ld	a5,544(s1)
    800038c6:	e785                	bnez	a5,800038ee <pipeclose+0x50>
    release(&pi->lock);
    800038c8:	8526                	mv	a0,s1
    800038ca:	074030ef          	jal	8000693e <release>
    kfree((char*)pi);
    800038ce:	8526                	mv	a0,s1
    800038d0:	f4cfc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800038d4:	60e2                	ld	ra,24(sp)
    800038d6:	6442                	ld	s0,16(sp)
    800038d8:	64a2                	ld	s1,8(sp)
    800038da:	6902                	ld	s2,0(sp)
    800038dc:	6105                	addi	sp,sp,32
    800038de:	8082                	ret
    pi->readopen = 0;
    800038e0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800038e4:	21c48513          	addi	a0,s1,540
    800038e8:	b33fd0ef          	jal	8000141a <wakeup>
    800038ec:	bfd9                	j	800038c2 <pipeclose+0x24>
    release(&pi->lock);
    800038ee:	8526                	mv	a0,s1
    800038f0:	04e030ef          	jal	8000693e <release>
}
    800038f4:	b7c5                	j	800038d4 <pipeclose+0x36>

00000000800038f6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800038f6:	711d                	addi	sp,sp,-96
    800038f8:	ec86                	sd	ra,88(sp)
    800038fa:	e8a2                	sd	s0,80(sp)
    800038fc:	e4a6                	sd	s1,72(sp)
    800038fe:	e0ca                	sd	s2,64(sp)
    80003900:	fc4e                	sd	s3,56(sp)
    80003902:	f852                	sd	s4,48(sp)
    80003904:	f456                	sd	s5,40(sp)
    80003906:	1080                	addi	s0,sp,96
    80003908:	84aa                	mv	s1,a0
    8000390a:	8aae                	mv	s5,a1
    8000390c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000390e:	cc8fd0ef          	jal	80000dd6 <myproc>
    80003912:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003914:	8526                	mv	a0,s1
    80003916:	791020ef          	jal	800068a6 <acquire>
  while(i < n){
    8000391a:	0b405a63          	blez	s4,800039ce <pipewrite+0xd8>
    8000391e:	f05a                	sd	s6,32(sp)
    80003920:	ec5e                	sd	s7,24(sp)
    80003922:	e862                	sd	s8,16(sp)
  int i = 0;
    80003924:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003926:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003928:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000392c:	21c48b93          	addi	s7,s1,540
    80003930:	a81d                	j	80003966 <pipewrite+0x70>
      release(&pi->lock);
    80003932:	8526                	mv	a0,s1
    80003934:	00a030ef          	jal	8000693e <release>
      return -1;
    80003938:	597d                	li	s2,-1
    8000393a:	7b02                	ld	s6,32(sp)
    8000393c:	6be2                	ld	s7,24(sp)
    8000393e:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003940:	854a                	mv	a0,s2
    80003942:	60e6                	ld	ra,88(sp)
    80003944:	6446                	ld	s0,80(sp)
    80003946:	64a6                	ld	s1,72(sp)
    80003948:	6906                	ld	s2,64(sp)
    8000394a:	79e2                	ld	s3,56(sp)
    8000394c:	7a42                	ld	s4,48(sp)
    8000394e:	7aa2                	ld	s5,40(sp)
    80003950:	6125                	addi	sp,sp,96
    80003952:	8082                	ret
      wakeup(&pi->nread);
    80003954:	8562                	mv	a0,s8
    80003956:	ac5fd0ef          	jal	8000141a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000395a:	85a6                	mv	a1,s1
    8000395c:	855e                	mv	a0,s7
    8000395e:	a71fd0ef          	jal	800013ce <sleep>
  while(i < n){
    80003962:	05495b63          	bge	s2,s4,800039b8 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003966:	2204a783          	lw	a5,544(s1)
    8000396a:	d7e1                	beqz	a5,80003932 <pipewrite+0x3c>
    8000396c:	854e                	mv	a0,s3
    8000396e:	c99fd0ef          	jal	80001606 <killed>
    80003972:	f161                	bnez	a0,80003932 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003974:	2184a783          	lw	a5,536(s1)
    80003978:	21c4a703          	lw	a4,540(s1)
    8000397c:	2007879b          	addiw	a5,a5,512
    80003980:	fcf70ae3          	beq	a4,a5,80003954 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003984:	4685                	li	a3,1
    80003986:	01590633          	add	a2,s2,s5
    8000398a:	faf40593          	addi	a1,s0,-81
    8000398e:	0509b503          	ld	a0,80(s3)
    80003992:	a40fd0ef          	jal	80000bd2 <copyin>
    80003996:	03650e63          	beq	a0,s6,800039d2 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000399a:	21c4a783          	lw	a5,540(s1)
    8000399e:	0017871b          	addiw	a4,a5,1
    800039a2:	20e4ae23          	sw	a4,540(s1)
    800039a6:	1ff7f793          	andi	a5,a5,511
    800039aa:	97a6                	add	a5,a5,s1
    800039ac:	faf44703          	lbu	a4,-81(s0)
    800039b0:	00e78c23          	sb	a4,24(a5)
      i++;
    800039b4:	2905                	addiw	s2,s2,1
    800039b6:	b775                	j	80003962 <pipewrite+0x6c>
    800039b8:	7b02                	ld	s6,32(sp)
    800039ba:	6be2                	ld	s7,24(sp)
    800039bc:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800039be:	21848513          	addi	a0,s1,536
    800039c2:	a59fd0ef          	jal	8000141a <wakeup>
  release(&pi->lock);
    800039c6:	8526                	mv	a0,s1
    800039c8:	777020ef          	jal	8000693e <release>
  return i;
    800039cc:	bf95                	j	80003940 <pipewrite+0x4a>
  int i = 0;
    800039ce:	4901                	li	s2,0
    800039d0:	b7fd                	j	800039be <pipewrite+0xc8>
    800039d2:	7b02                	ld	s6,32(sp)
    800039d4:	6be2                	ld	s7,24(sp)
    800039d6:	6c42                	ld	s8,16(sp)
    800039d8:	b7dd                	j	800039be <pipewrite+0xc8>

00000000800039da <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800039da:	715d                	addi	sp,sp,-80
    800039dc:	e486                	sd	ra,72(sp)
    800039de:	e0a2                	sd	s0,64(sp)
    800039e0:	fc26                	sd	s1,56(sp)
    800039e2:	f84a                	sd	s2,48(sp)
    800039e4:	f44e                	sd	s3,40(sp)
    800039e6:	f052                	sd	s4,32(sp)
    800039e8:	ec56                	sd	s5,24(sp)
    800039ea:	0880                	addi	s0,sp,80
    800039ec:	84aa                	mv	s1,a0
    800039ee:	892e                	mv	s2,a1
    800039f0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800039f2:	be4fd0ef          	jal	80000dd6 <myproc>
    800039f6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800039f8:	8526                	mv	a0,s1
    800039fa:	6ad020ef          	jal	800068a6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039fe:	2184a703          	lw	a4,536(s1)
    80003a02:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a06:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a0a:	02f71563          	bne	a4,a5,80003a34 <piperead+0x5a>
    80003a0e:	2244a783          	lw	a5,548(s1)
    80003a12:	cb85                	beqz	a5,80003a42 <piperead+0x68>
    if(killed(pr)){
    80003a14:	8552                	mv	a0,s4
    80003a16:	bf1fd0ef          	jal	80001606 <killed>
    80003a1a:	ed19                	bnez	a0,80003a38 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a1c:	85a6                	mv	a1,s1
    80003a1e:	854e                	mv	a0,s3
    80003a20:	9affd0ef          	jal	800013ce <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a24:	2184a703          	lw	a4,536(s1)
    80003a28:	21c4a783          	lw	a5,540(s1)
    80003a2c:	fef701e3          	beq	a4,a5,80003a0e <piperead+0x34>
    80003a30:	e85a                	sd	s6,16(sp)
    80003a32:	a809                	j	80003a44 <piperead+0x6a>
    80003a34:	e85a                	sd	s6,16(sp)
    80003a36:	a039                	j	80003a44 <piperead+0x6a>
      release(&pi->lock);
    80003a38:	8526                	mv	a0,s1
    80003a3a:	705020ef          	jal	8000693e <release>
      return -1;
    80003a3e:	59fd                	li	s3,-1
    80003a40:	a8b1                	j	80003a9c <piperead+0xc2>
    80003a42:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a44:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a46:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a48:	05505263          	blez	s5,80003a8c <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003a4c:	2184a783          	lw	a5,536(s1)
    80003a50:	21c4a703          	lw	a4,540(s1)
    80003a54:	02f70c63          	beq	a4,a5,80003a8c <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003a58:	0017871b          	addiw	a4,a5,1
    80003a5c:	20e4ac23          	sw	a4,536(s1)
    80003a60:	1ff7f793          	andi	a5,a5,511
    80003a64:	97a6                	add	a5,a5,s1
    80003a66:	0187c783          	lbu	a5,24(a5)
    80003a6a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a6e:	4685                	li	a3,1
    80003a70:	fbf40613          	addi	a2,s0,-65
    80003a74:	85ca                	mv	a1,s2
    80003a76:	050a3503          	ld	a0,80(s4)
    80003a7a:	864fd0ef          	jal	80000ade <copyout>
    80003a7e:	01650763          	beq	a0,s6,80003a8c <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a82:	2985                	addiw	s3,s3,1
    80003a84:	0905                	addi	s2,s2,1
    80003a86:	fd3a93e3          	bne	s5,s3,80003a4c <piperead+0x72>
    80003a8a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a8c:	21c48513          	addi	a0,s1,540
    80003a90:	98bfd0ef          	jal	8000141a <wakeup>
  release(&pi->lock);
    80003a94:	8526                	mv	a0,s1
    80003a96:	6a9020ef          	jal	8000693e <release>
    80003a9a:	6b42                	ld	s6,16(sp)
  return i;
}
    80003a9c:	854e                	mv	a0,s3
    80003a9e:	60a6                	ld	ra,72(sp)
    80003aa0:	6406                	ld	s0,64(sp)
    80003aa2:	74e2                	ld	s1,56(sp)
    80003aa4:	7942                	ld	s2,48(sp)
    80003aa6:	79a2                	ld	s3,40(sp)
    80003aa8:	7a02                	ld	s4,32(sp)
    80003aaa:	6ae2                	ld	s5,24(sp)
    80003aac:	6161                	addi	sp,sp,80
    80003aae:	8082                	ret

0000000080003ab0 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003ab0:	1141                	addi	sp,sp,-16
    80003ab2:	e422                	sd	s0,8(sp)
    80003ab4:	0800                	addi	s0,sp,16
    80003ab6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003ab8:	8905                	andi	a0,a0,1
    80003aba:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003abc:	8b89                	andi	a5,a5,2
    80003abe:	c399                	beqz	a5,80003ac4 <flags2perm+0x14>
      perm |= PTE_W;
    80003ac0:	00456513          	ori	a0,a0,4
    return perm;
}
    80003ac4:	6422                	ld	s0,8(sp)
    80003ac6:	0141                	addi	sp,sp,16
    80003ac8:	8082                	ret

0000000080003aca <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003aca:	df010113          	addi	sp,sp,-528
    80003ace:	20113423          	sd	ra,520(sp)
    80003ad2:	20813023          	sd	s0,512(sp)
    80003ad6:	ffa6                	sd	s1,504(sp)
    80003ad8:	fbca                	sd	s2,496(sp)
    80003ada:	0c00                	addi	s0,sp,528
    80003adc:	892a                	mv	s2,a0
    80003ade:	dea43c23          	sd	a0,-520(s0)
    80003ae2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003ae6:	af0fd0ef          	jal	80000dd6 <myproc>
    80003aea:	84aa                	mv	s1,a0

  begin_op();
    80003aec:	dd4ff0ef          	jal	800030c0 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003af0:	854a                	mv	a0,s2
    80003af2:	bfaff0ef          	jal	80002eec <namei>
    80003af6:	c931                	beqz	a0,80003b4a <kexec+0x80>
    80003af8:	f3d2                	sd	s4,480(sp)
    80003afa:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003afc:	bdbfe0ef          	jal	800026d6 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003b00:	04000713          	li	a4,64
    80003b04:	4681                	li	a3,0
    80003b06:	e5040613          	addi	a2,s0,-432
    80003b0a:	4581                	li	a1,0
    80003b0c:	8552                	mv	a0,s4
    80003b0e:	f59fe0ef          	jal	80002a66 <readi>
    80003b12:	04000793          	li	a5,64
    80003b16:	00f51a63          	bne	a0,a5,80003b2a <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003b1a:	e5042703          	lw	a4,-432(s0)
    80003b1e:	464c47b7          	lui	a5,0x464c4
    80003b22:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003b26:	02f70663          	beq	a4,a5,80003b52 <kexec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003b2a:	8552                	mv	a0,s4
    80003b2c:	db5fe0ef          	jal	800028e0 <iunlockput>
    end_op();
    80003b30:	dfaff0ef          	jal	8000312a <end_op>
  }
  return -1;
    80003b34:	557d                	li	a0,-1
    80003b36:	7a1e                	ld	s4,480(sp)
}
    80003b38:	20813083          	ld	ra,520(sp)
    80003b3c:	20013403          	ld	s0,512(sp)
    80003b40:	74fe                	ld	s1,504(sp)
    80003b42:	795e                	ld	s2,496(sp)
    80003b44:	21010113          	addi	sp,sp,528
    80003b48:	8082                	ret
    end_op();
    80003b4a:	de0ff0ef          	jal	8000312a <end_op>
    return -1;
    80003b4e:	557d                	li	a0,-1
    80003b50:	b7e5                	j	80003b38 <kexec+0x6e>
    80003b52:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003b54:	8526                	mv	a0,s1
    80003b56:	b86fd0ef          	jal	80000edc <proc_pagetable>
    80003b5a:	8b2a                	mv	s6,a0
    80003b5c:	2c050b63          	beqz	a0,80003e32 <kexec+0x368>
    80003b60:	f7ce                	sd	s3,488(sp)
    80003b62:	efd6                	sd	s5,472(sp)
    80003b64:	e7de                	sd	s7,456(sp)
    80003b66:	e3e2                	sd	s8,448(sp)
    80003b68:	ff66                	sd	s9,440(sp)
    80003b6a:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b6c:	e7042d03          	lw	s10,-400(s0)
    80003b70:	e8845783          	lhu	a5,-376(s0)
    80003b74:	12078963          	beqz	a5,80003ca6 <kexec+0x1dc>
    80003b78:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b7a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b7c:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003b7e:	6c85                	lui	s9,0x1
    80003b80:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b84:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b88:	6a85                	lui	s5,0x1
    80003b8a:	a085                	j	80003bea <kexec+0x120>
      panic("loadseg: address should exist");
    80003b8c:	00005517          	auipc	a0,0x5
    80003b90:	9cc50513          	addi	a0,a0,-1588 # 80008558 <etext+0x558>
    80003b94:	257020ef          	jal	800065ea <panic>
    if(sz - i < PGSIZE)
    80003b98:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b9a:	8726                	mv	a4,s1
    80003b9c:	012c06bb          	addw	a3,s8,s2
    80003ba0:	4581                	li	a1,0
    80003ba2:	8552                	mv	a0,s4
    80003ba4:	ec3fe0ef          	jal	80002a66 <readi>
    80003ba8:	2501                	sext.w	a0,a0
    80003baa:	24a49a63          	bne	s1,a0,80003dfe <kexec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003bae:	012a893b          	addw	s2,s5,s2
    80003bb2:	03397363          	bgeu	s2,s3,80003bd8 <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003bb6:	02091593          	slli	a1,s2,0x20
    80003bba:	9181                	srli	a1,a1,0x20
    80003bbc:	95de                	add	a1,a1,s7
    80003bbe:	855a                	mv	a0,s6
    80003bc0:	8a9fc0ef          	jal	80000468 <walkaddr>
    80003bc4:	862a                	mv	a2,a0
    if(pa == 0)
    80003bc6:	d179                	beqz	a0,80003b8c <kexec+0xc2>
    if(sz - i < PGSIZE)
    80003bc8:	412984bb          	subw	s1,s3,s2
    80003bcc:	0004879b          	sext.w	a5,s1
    80003bd0:	fcfcf4e3          	bgeu	s9,a5,80003b98 <kexec+0xce>
    80003bd4:	84d6                	mv	s1,s5
    80003bd6:	b7c9                	j	80003b98 <kexec+0xce>
    sz = sz1;
    80003bd8:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003bdc:	2d85                	addiw	s11,s11,1
    80003bde:	038d0d1b          	addiw	s10,s10,56
    80003be2:	e8845783          	lhu	a5,-376(s0)
    80003be6:	08fdd063          	bge	s11,a5,80003c66 <kexec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003bea:	2d01                	sext.w	s10,s10
    80003bec:	03800713          	li	a4,56
    80003bf0:	86ea                	mv	a3,s10
    80003bf2:	e1840613          	addi	a2,s0,-488
    80003bf6:	4581                	li	a1,0
    80003bf8:	8552                	mv	a0,s4
    80003bfa:	e6dfe0ef          	jal	80002a66 <readi>
    80003bfe:	03800793          	li	a5,56
    80003c02:	1cf51663          	bne	a0,a5,80003dce <kexec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003c06:	e1842783          	lw	a5,-488(s0)
    80003c0a:	4705                	li	a4,1
    80003c0c:	fce798e3          	bne	a5,a4,80003bdc <kexec+0x112>
    if(ph.memsz < ph.filesz)
    80003c10:	e4043483          	ld	s1,-448(s0)
    80003c14:	e3843783          	ld	a5,-456(s0)
    80003c18:	1af4ef63          	bltu	s1,a5,80003dd6 <kexec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003c1c:	e2843783          	ld	a5,-472(s0)
    80003c20:	94be                	add	s1,s1,a5
    80003c22:	1af4ee63          	bltu	s1,a5,80003dde <kexec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003c26:	df043703          	ld	a4,-528(s0)
    80003c2a:	8ff9                	and	a5,a5,a4
    80003c2c:	1a079d63          	bnez	a5,80003de6 <kexec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c30:	e1c42503          	lw	a0,-484(s0)
    80003c34:	e7dff0ef          	jal	80003ab0 <flags2perm>
    80003c38:	86aa                	mv	a3,a0
    80003c3a:	8626                	mv	a2,s1
    80003c3c:	85ca                	mv	a1,s2
    80003c3e:	855a                	mv	a0,s6
    80003c40:	b45fc0ef          	jal	80000784 <uvmalloc>
    80003c44:	e0a43423          	sd	a0,-504(s0)
    80003c48:	1a050363          	beqz	a0,80003dee <kexec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003c4c:	e2843b83          	ld	s7,-472(s0)
    80003c50:	e2042c03          	lw	s8,-480(s0)
    80003c54:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003c58:	00098463          	beqz	s3,80003c60 <kexec+0x196>
    80003c5c:	4901                	li	s2,0
    80003c5e:	bfa1                	j	80003bb6 <kexec+0xec>
    sz = sz1;
    80003c60:	e0843903          	ld	s2,-504(s0)
    80003c64:	bfa5                	j	80003bdc <kexec+0x112>
    80003c66:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003c68:	8552                	mv	a0,s4
    80003c6a:	c77fe0ef          	jal	800028e0 <iunlockput>
  end_op();
    80003c6e:	cbcff0ef          	jal	8000312a <end_op>
  p = myproc();
    80003c72:	964fd0ef          	jal	80000dd6 <myproc>
    80003c76:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003c78:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003c7c:	6985                	lui	s3,0x1
    80003c7e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003c80:	99ca                	add	s3,s3,s2
    80003c82:	77fd                	lui	a5,0xfffff
    80003c84:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c88:	4691                	li	a3,4
    80003c8a:	6609                	lui	a2,0x2
    80003c8c:	964e                	add	a2,a2,s3
    80003c8e:	85ce                	mv	a1,s3
    80003c90:	855a                	mv	a0,s6
    80003c92:	af3fc0ef          	jal	80000784 <uvmalloc>
    80003c96:	892a                	mv	s2,a0
    80003c98:	e0a43423          	sd	a0,-504(s0)
    80003c9c:	e519                	bnez	a0,80003caa <kexec+0x1e0>
  if(pagetable)
    80003c9e:	e1343423          	sd	s3,-504(s0)
    80003ca2:	4a01                	li	s4,0
    80003ca4:	aab1                	j	80003e00 <kexec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ca6:	4901                	li	s2,0
    80003ca8:	b7c1                	j	80003c68 <kexec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003caa:	75f9                	lui	a1,0xffffe
    80003cac:	95aa                	add	a1,a1,a0
    80003cae:	855a                	mv	a0,s6
    80003cb0:	cabfc0ef          	jal	8000095a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003cb4:	7bfd                	lui	s7,0xfffff
    80003cb6:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003cb8:	e0043783          	ld	a5,-512(s0)
    80003cbc:	6388                	ld	a0,0(a5)
    80003cbe:	cd39                	beqz	a0,80003d1c <kexec+0x252>
    80003cc0:	e9040993          	addi	s3,s0,-368
    80003cc4:	f9040c13          	addi	s8,s0,-112
    80003cc8:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003cca:	df4fc0ef          	jal	800002be <strlen>
    80003cce:	0015079b          	addiw	a5,a0,1
    80003cd2:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003cd6:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003cda:	11796e63          	bltu	s2,s7,80003df6 <kexec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003cde:	e0043d03          	ld	s10,-512(s0)
    80003ce2:	000d3a03          	ld	s4,0(s10)
    80003ce6:	8552                	mv	a0,s4
    80003ce8:	dd6fc0ef          	jal	800002be <strlen>
    80003cec:	0015069b          	addiw	a3,a0,1
    80003cf0:	8652                	mv	a2,s4
    80003cf2:	85ca                	mv	a1,s2
    80003cf4:	855a                	mv	a0,s6
    80003cf6:	de9fc0ef          	jal	80000ade <copyout>
    80003cfa:	10054063          	bltz	a0,80003dfa <kexec+0x330>
    ustack[argc] = sp;
    80003cfe:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003d02:	0485                	addi	s1,s1,1
    80003d04:	008d0793          	addi	a5,s10,8
    80003d08:	e0f43023          	sd	a5,-512(s0)
    80003d0c:	008d3503          	ld	a0,8(s10)
    80003d10:	c909                	beqz	a0,80003d22 <kexec+0x258>
    if(argc >= MAXARG)
    80003d12:	09a1                	addi	s3,s3,8
    80003d14:	fb899be3          	bne	s3,s8,80003cca <kexec+0x200>
  ip = 0;
    80003d18:	4a01                	li	s4,0
    80003d1a:	a0dd                	j	80003e00 <kexec+0x336>
  sp = sz;
    80003d1c:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003d20:	4481                	li	s1,0
  ustack[argc] = 0;
    80003d22:	00349793          	slli	a5,s1,0x3
    80003d26:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ff56688>
    80003d2a:	97a2                	add	a5,a5,s0
    80003d2c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003d30:	00148693          	addi	a3,s1,1
    80003d34:	068e                	slli	a3,a3,0x3
    80003d36:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003d3a:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003d3e:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003d42:	f5796ee3          	bltu	s2,s7,80003c9e <kexec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003d46:	e9040613          	addi	a2,s0,-368
    80003d4a:	85ca                	mv	a1,s2
    80003d4c:	855a                	mv	a0,s6
    80003d4e:	d91fc0ef          	jal	80000ade <copyout>
    80003d52:	0e054263          	bltz	a0,80003e36 <kexec+0x36c>
  p->trapframe->a1 = sp;
    80003d56:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003d5a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003d5e:	df843783          	ld	a5,-520(s0)
    80003d62:	0007c703          	lbu	a4,0(a5)
    80003d66:	cf11                	beqz	a4,80003d82 <kexec+0x2b8>
    80003d68:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003d6a:	02f00693          	li	a3,47
    80003d6e:	a039                	j	80003d7c <kexec+0x2b2>
      last = s+1;
    80003d70:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003d74:	0785                	addi	a5,a5,1
    80003d76:	fff7c703          	lbu	a4,-1(a5)
    80003d7a:	c701                	beqz	a4,80003d82 <kexec+0x2b8>
    if(*s == '/')
    80003d7c:	fed71ce3          	bne	a4,a3,80003d74 <kexec+0x2aa>
    80003d80:	bfc5                	j	80003d70 <kexec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d82:	4641                	li	a2,16
    80003d84:	df843583          	ld	a1,-520(s0)
    80003d88:	158a8513          	addi	a0,s5,344
    80003d8c:	d00fc0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80003d90:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d94:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d98:	e0843783          	ld	a5,-504(s0)
    80003d9c:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80003da0:	058ab783          	ld	a5,88(s5)
    80003da4:	e6843703          	ld	a4,-408(s0)
    80003da8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003daa:	058ab783          	ld	a5,88(s5)
    80003dae:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003db2:	85e6                	mv	a1,s9
    80003db4:	9acfd0ef          	jal	80000f60 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003db8:	0004851b          	sext.w	a0,s1
    80003dbc:	79be                	ld	s3,488(sp)
    80003dbe:	7a1e                	ld	s4,480(sp)
    80003dc0:	6afe                	ld	s5,472(sp)
    80003dc2:	6b5e                	ld	s6,464(sp)
    80003dc4:	6bbe                	ld	s7,456(sp)
    80003dc6:	6c1e                	ld	s8,448(sp)
    80003dc8:	7cfa                	ld	s9,440(sp)
    80003dca:	7d5a                	ld	s10,432(sp)
    80003dcc:	b3b5                	j	80003b38 <kexec+0x6e>
    80003dce:	e1243423          	sd	s2,-504(s0)
    80003dd2:	7dba                	ld	s11,424(sp)
    80003dd4:	a035                	j	80003e00 <kexec+0x336>
    80003dd6:	e1243423          	sd	s2,-504(s0)
    80003dda:	7dba                	ld	s11,424(sp)
    80003ddc:	a015                	j	80003e00 <kexec+0x336>
    80003dde:	e1243423          	sd	s2,-504(s0)
    80003de2:	7dba                	ld	s11,424(sp)
    80003de4:	a831                	j	80003e00 <kexec+0x336>
    80003de6:	e1243423          	sd	s2,-504(s0)
    80003dea:	7dba                	ld	s11,424(sp)
    80003dec:	a811                	j	80003e00 <kexec+0x336>
    80003dee:	e1243423          	sd	s2,-504(s0)
    80003df2:	7dba                	ld	s11,424(sp)
    80003df4:	a031                	j	80003e00 <kexec+0x336>
  ip = 0;
    80003df6:	4a01                	li	s4,0
    80003df8:	a021                	j	80003e00 <kexec+0x336>
    80003dfa:	4a01                	li	s4,0
  if(pagetable)
    80003dfc:	a011                	j	80003e00 <kexec+0x336>
    80003dfe:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003e00:	e0843583          	ld	a1,-504(s0)
    80003e04:	855a                	mv	a0,s6
    80003e06:	95afd0ef          	jal	80000f60 <proc_freepagetable>
  return -1;
    80003e0a:	557d                	li	a0,-1
  if(ip){
    80003e0c:	000a1b63          	bnez	s4,80003e22 <kexec+0x358>
    80003e10:	79be                	ld	s3,488(sp)
    80003e12:	7a1e                	ld	s4,480(sp)
    80003e14:	6afe                	ld	s5,472(sp)
    80003e16:	6b5e                	ld	s6,464(sp)
    80003e18:	6bbe                	ld	s7,456(sp)
    80003e1a:	6c1e                	ld	s8,448(sp)
    80003e1c:	7cfa                	ld	s9,440(sp)
    80003e1e:	7d5a                	ld	s10,432(sp)
    80003e20:	bb21                	j	80003b38 <kexec+0x6e>
    80003e22:	79be                	ld	s3,488(sp)
    80003e24:	6afe                	ld	s5,472(sp)
    80003e26:	6b5e                	ld	s6,464(sp)
    80003e28:	6bbe                	ld	s7,456(sp)
    80003e2a:	6c1e                	ld	s8,448(sp)
    80003e2c:	7cfa                	ld	s9,440(sp)
    80003e2e:	7d5a                	ld	s10,432(sp)
    80003e30:	b9ed                	j	80003b2a <kexec+0x60>
    80003e32:	6b5e                	ld	s6,464(sp)
    80003e34:	b9dd                	j	80003b2a <kexec+0x60>
  sz = sz1;
    80003e36:	e0843983          	ld	s3,-504(s0)
    80003e3a:	b595                	j	80003c9e <kexec+0x1d4>

0000000080003e3c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003e3c:	7179                	addi	sp,sp,-48
    80003e3e:	f406                	sd	ra,40(sp)
    80003e40:	f022                	sd	s0,32(sp)
    80003e42:	ec26                	sd	s1,24(sp)
    80003e44:	e84a                	sd	s2,16(sp)
    80003e46:	1800                	addi	s0,sp,48
    80003e48:	892e                	mv	s2,a1
    80003e4a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003e4c:	fdc40593          	addi	a1,s0,-36
    80003e50:	e91fd0ef          	jal	80001ce0 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003e54:	fdc42703          	lw	a4,-36(s0)
    80003e58:	47bd                	li	a5,15
    80003e5a:	02e7e963          	bltu	a5,a4,80003e8c <argfd+0x50>
    80003e5e:	f79fc0ef          	jal	80000dd6 <myproc>
    80003e62:	fdc42703          	lw	a4,-36(s0)
    80003e66:	01a70793          	addi	a5,a4,26
    80003e6a:	078e                	slli	a5,a5,0x3
    80003e6c:	953e                	add	a0,a0,a5
    80003e6e:	611c                	ld	a5,0(a0)
    80003e70:	c385                	beqz	a5,80003e90 <argfd+0x54>
    return -1;
  if(pfd)
    80003e72:	00090463          	beqz	s2,80003e7a <argfd+0x3e>
    *pfd = fd;
    80003e76:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003e7a:	4501                	li	a0,0
  if(pf)
    80003e7c:	c091                	beqz	s1,80003e80 <argfd+0x44>
    *pf = f;
    80003e7e:	e09c                	sd	a5,0(s1)
}
    80003e80:	70a2                	ld	ra,40(sp)
    80003e82:	7402                	ld	s0,32(sp)
    80003e84:	64e2                	ld	s1,24(sp)
    80003e86:	6942                	ld	s2,16(sp)
    80003e88:	6145                	addi	sp,sp,48
    80003e8a:	8082                	ret
    return -1;
    80003e8c:	557d                	li	a0,-1
    80003e8e:	bfcd                	j	80003e80 <argfd+0x44>
    80003e90:	557d                	li	a0,-1
    80003e92:	b7fd                	j	80003e80 <argfd+0x44>

0000000080003e94 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e94:	1101                	addi	sp,sp,-32
    80003e96:	ec06                	sd	ra,24(sp)
    80003e98:	e822                	sd	s0,16(sp)
    80003e9a:	e426                	sd	s1,8(sp)
    80003e9c:	1000                	addi	s0,sp,32
    80003e9e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003ea0:	f37fc0ef          	jal	80000dd6 <myproc>
    80003ea4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003ea6:	0d050793          	addi	a5,a0,208
    80003eaa:	4501                	li	a0,0
    80003eac:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003eae:	6398                	ld	a4,0(a5)
    80003eb0:	cb19                	beqz	a4,80003ec6 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003eb2:	2505                	addiw	a0,a0,1
    80003eb4:	07a1                	addi	a5,a5,8
    80003eb6:	fed51ce3          	bne	a0,a3,80003eae <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003eba:	557d                	li	a0,-1
}
    80003ebc:	60e2                	ld	ra,24(sp)
    80003ebe:	6442                	ld	s0,16(sp)
    80003ec0:	64a2                	ld	s1,8(sp)
    80003ec2:	6105                	addi	sp,sp,32
    80003ec4:	8082                	ret
      p->ofile[fd] = f;
    80003ec6:	01a50793          	addi	a5,a0,26
    80003eca:	078e                	slli	a5,a5,0x3
    80003ecc:	963e                	add	a2,a2,a5
    80003ece:	e204                	sd	s1,0(a2)
      return fd;
    80003ed0:	b7f5                	j	80003ebc <fdalloc+0x28>

0000000080003ed2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003ed2:	715d                	addi	sp,sp,-80
    80003ed4:	e486                	sd	ra,72(sp)
    80003ed6:	e0a2                	sd	s0,64(sp)
    80003ed8:	fc26                	sd	s1,56(sp)
    80003eda:	f84a                	sd	s2,48(sp)
    80003edc:	f44e                	sd	s3,40(sp)
    80003ede:	ec56                	sd	s5,24(sp)
    80003ee0:	e85a                	sd	s6,16(sp)
    80003ee2:	0880                	addi	s0,sp,80
    80003ee4:	8b2e                	mv	s6,a1
    80003ee6:	89b2                	mv	s3,a2
    80003ee8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003eea:	fb040593          	addi	a1,s0,-80
    80003eee:	818ff0ef          	jal	80002f06 <nameiparent>
    80003ef2:	84aa                	mv	s1,a0
    80003ef4:	10050a63          	beqz	a0,80004008 <create+0x136>
    return 0;

  ilock(dp);
    80003ef8:	fdefe0ef          	jal	800026d6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003efc:	4601                	li	a2,0
    80003efe:	fb040593          	addi	a1,s0,-80
    80003f02:	8526                	mv	a0,s1
    80003f04:	d83fe0ef          	jal	80002c86 <dirlookup>
    80003f08:	8aaa                	mv	s5,a0
    80003f0a:	c129                	beqz	a0,80003f4c <create+0x7a>
    iunlockput(dp);
    80003f0c:	8526                	mv	a0,s1
    80003f0e:	9d3fe0ef          	jal	800028e0 <iunlockput>
    ilock(ip);
    80003f12:	8556                	mv	a0,s5
    80003f14:	fc2fe0ef          	jal	800026d6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003f18:	4789                	li	a5,2
    80003f1a:	02fb1463          	bne	s6,a5,80003f42 <create+0x70>
    80003f1e:	044ad783          	lhu	a5,68(s5)
    80003f22:	37f9                	addiw	a5,a5,-2
    80003f24:	17c2                	slli	a5,a5,0x30
    80003f26:	93c1                	srli	a5,a5,0x30
    80003f28:	4705                	li	a4,1
    80003f2a:	00f76c63          	bltu	a4,a5,80003f42 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003f2e:	8556                	mv	a0,s5
    80003f30:	60a6                	ld	ra,72(sp)
    80003f32:	6406                	ld	s0,64(sp)
    80003f34:	74e2                	ld	s1,56(sp)
    80003f36:	7942                	ld	s2,48(sp)
    80003f38:	79a2                	ld	s3,40(sp)
    80003f3a:	6ae2                	ld	s5,24(sp)
    80003f3c:	6b42                	ld	s6,16(sp)
    80003f3e:	6161                	addi	sp,sp,80
    80003f40:	8082                	ret
    iunlockput(ip);
    80003f42:	8556                	mv	a0,s5
    80003f44:	99dfe0ef          	jal	800028e0 <iunlockput>
    return 0;
    80003f48:	4a81                	li	s5,0
    80003f4a:	b7d5                	j	80003f2e <create+0x5c>
    80003f4c:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003f4e:	85da                	mv	a1,s6
    80003f50:	4088                	lw	a0,0(s1)
    80003f52:	e14fe0ef          	jal	80002566 <ialloc>
    80003f56:	8a2a                	mv	s4,a0
    80003f58:	cd15                	beqz	a0,80003f94 <create+0xc2>
  ilock(ip);
    80003f5a:	f7cfe0ef          	jal	800026d6 <ilock>
  ip->major = major;
    80003f5e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003f62:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003f66:	4905                	li	s2,1
    80003f68:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003f6c:	8552                	mv	a0,s4
    80003f6e:	eb4fe0ef          	jal	80002622 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003f72:	032b0763          	beq	s6,s2,80003fa0 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f76:	004a2603          	lw	a2,4(s4)
    80003f7a:	fb040593          	addi	a1,s0,-80
    80003f7e:	8526                	mv	a0,s1
    80003f80:	ed3fe0ef          	jal	80002e52 <dirlink>
    80003f84:	06054563          	bltz	a0,80003fee <create+0x11c>
  iunlockput(dp);
    80003f88:	8526                	mv	a0,s1
    80003f8a:	957fe0ef          	jal	800028e0 <iunlockput>
  return ip;
    80003f8e:	8ad2                	mv	s5,s4
    80003f90:	7a02                	ld	s4,32(sp)
    80003f92:	bf71                	j	80003f2e <create+0x5c>
    iunlockput(dp);
    80003f94:	8526                	mv	a0,s1
    80003f96:	94bfe0ef          	jal	800028e0 <iunlockput>
    return 0;
    80003f9a:	8ad2                	mv	s5,s4
    80003f9c:	7a02                	ld	s4,32(sp)
    80003f9e:	bf41                	j	80003f2e <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003fa0:	004a2603          	lw	a2,4(s4)
    80003fa4:	00004597          	auipc	a1,0x4
    80003fa8:	5d458593          	addi	a1,a1,1492 # 80008578 <etext+0x578>
    80003fac:	8552                	mv	a0,s4
    80003fae:	ea5fe0ef          	jal	80002e52 <dirlink>
    80003fb2:	02054e63          	bltz	a0,80003fee <create+0x11c>
    80003fb6:	40d0                	lw	a2,4(s1)
    80003fb8:	00004597          	auipc	a1,0x4
    80003fbc:	5c858593          	addi	a1,a1,1480 # 80008580 <etext+0x580>
    80003fc0:	8552                	mv	a0,s4
    80003fc2:	e91fe0ef          	jal	80002e52 <dirlink>
    80003fc6:	02054463          	bltz	a0,80003fee <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003fca:	004a2603          	lw	a2,4(s4)
    80003fce:	fb040593          	addi	a1,s0,-80
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	e7ffe0ef          	jal	80002e52 <dirlink>
    80003fd8:	00054b63          	bltz	a0,80003fee <create+0x11c>
    dp->nlink++;  // for ".."
    80003fdc:	04a4d783          	lhu	a5,74(s1)
    80003fe0:	2785                	addiw	a5,a5,1
    80003fe2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	e3afe0ef          	jal	80002622 <iupdate>
    80003fec:	bf71                	j	80003f88 <create+0xb6>
  ip->nlink = 0;
    80003fee:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003ff2:	8552                	mv	a0,s4
    80003ff4:	e2efe0ef          	jal	80002622 <iupdate>
  iunlockput(ip);
    80003ff8:	8552                	mv	a0,s4
    80003ffa:	8e7fe0ef          	jal	800028e0 <iunlockput>
  iunlockput(dp);
    80003ffe:	8526                	mv	a0,s1
    80004000:	8e1fe0ef          	jal	800028e0 <iunlockput>
  return 0;
    80004004:	7a02                	ld	s4,32(sp)
    80004006:	b725                	j	80003f2e <create+0x5c>
    return 0;
    80004008:	8aaa                	mv	s5,a0
    8000400a:	b715                	j	80003f2e <create+0x5c>

000000008000400c <sys_dup>:
{
    8000400c:	7179                	addi	sp,sp,-48
    8000400e:	f406                	sd	ra,40(sp)
    80004010:	f022                	sd	s0,32(sp)
    80004012:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004014:	fd840613          	addi	a2,s0,-40
    80004018:	4581                	li	a1,0
    8000401a:	4501                	li	a0,0
    8000401c:	e21ff0ef          	jal	80003e3c <argfd>
    return -1;
    80004020:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004022:	02054363          	bltz	a0,80004048 <sys_dup+0x3c>
    80004026:	ec26                	sd	s1,24(sp)
    80004028:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000402a:	fd843903          	ld	s2,-40(s0)
    8000402e:	854a                	mv	a0,s2
    80004030:	e65ff0ef          	jal	80003e94 <fdalloc>
    80004034:	84aa                	mv	s1,a0
    return -1;
    80004036:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004038:	00054d63          	bltz	a0,80004052 <sys_dup+0x46>
  filedup(f);
    8000403c:	854a                	mv	a0,s2
    8000403e:	c48ff0ef          	jal	80003486 <filedup>
  return fd;
    80004042:	87a6                	mv	a5,s1
    80004044:	64e2                	ld	s1,24(sp)
    80004046:	6942                	ld	s2,16(sp)
}
    80004048:	853e                	mv	a0,a5
    8000404a:	70a2                	ld	ra,40(sp)
    8000404c:	7402                	ld	s0,32(sp)
    8000404e:	6145                	addi	sp,sp,48
    80004050:	8082                	ret
    80004052:	64e2                	ld	s1,24(sp)
    80004054:	6942                	ld	s2,16(sp)
    80004056:	bfcd                	j	80004048 <sys_dup+0x3c>

0000000080004058 <sys_read>:
{
    80004058:	7179                	addi	sp,sp,-48
    8000405a:	f406                	sd	ra,40(sp)
    8000405c:	f022                	sd	s0,32(sp)
    8000405e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004060:	fd840593          	addi	a1,s0,-40
    80004064:	4505                	li	a0,1
    80004066:	c97fd0ef          	jal	80001cfc <argaddr>
  argint(2, &n);
    8000406a:	fe440593          	addi	a1,s0,-28
    8000406e:	4509                	li	a0,2
    80004070:	c71fd0ef          	jal	80001ce0 <argint>
  if(argfd(0, 0, &f) < 0)
    80004074:	fe840613          	addi	a2,s0,-24
    80004078:	4581                	li	a1,0
    8000407a:	4501                	li	a0,0
    8000407c:	dc1ff0ef          	jal	80003e3c <argfd>
    80004080:	87aa                	mv	a5,a0
    return -1;
    80004082:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004084:	0007ca63          	bltz	a5,80004098 <sys_read+0x40>
  return fileread(f, p, n);
    80004088:	fe442603          	lw	a2,-28(s0)
    8000408c:	fd843583          	ld	a1,-40(s0)
    80004090:	fe843503          	ld	a0,-24(s0)
    80004094:	d58ff0ef          	jal	800035ec <fileread>
}
    80004098:	70a2                	ld	ra,40(sp)
    8000409a:	7402                	ld	s0,32(sp)
    8000409c:	6145                	addi	sp,sp,48
    8000409e:	8082                	ret

00000000800040a0 <sys_write>:
{
    800040a0:	7179                	addi	sp,sp,-48
    800040a2:	f406                	sd	ra,40(sp)
    800040a4:	f022                	sd	s0,32(sp)
    800040a6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800040a8:	fd840593          	addi	a1,s0,-40
    800040ac:	4505                	li	a0,1
    800040ae:	c4ffd0ef          	jal	80001cfc <argaddr>
  argint(2, &n);
    800040b2:	fe440593          	addi	a1,s0,-28
    800040b6:	4509                	li	a0,2
    800040b8:	c29fd0ef          	jal	80001ce0 <argint>
  if(argfd(0, 0, &f) < 0)
    800040bc:	fe840613          	addi	a2,s0,-24
    800040c0:	4581                	li	a1,0
    800040c2:	4501                	li	a0,0
    800040c4:	d79ff0ef          	jal	80003e3c <argfd>
    800040c8:	87aa                	mv	a5,a0
    return -1;
    800040ca:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040cc:	0007ca63          	bltz	a5,800040e0 <sys_write+0x40>
  return filewrite(f, p, n);
    800040d0:	fe442603          	lw	a2,-28(s0)
    800040d4:	fd843583          	ld	a1,-40(s0)
    800040d8:	fe843503          	ld	a0,-24(s0)
    800040dc:	dceff0ef          	jal	800036aa <filewrite>
}
    800040e0:	70a2                	ld	ra,40(sp)
    800040e2:	7402                	ld	s0,32(sp)
    800040e4:	6145                	addi	sp,sp,48
    800040e6:	8082                	ret

00000000800040e8 <sys_close>:
{
    800040e8:	1101                	addi	sp,sp,-32
    800040ea:	ec06                	sd	ra,24(sp)
    800040ec:	e822                	sd	s0,16(sp)
    800040ee:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800040f0:	fe040613          	addi	a2,s0,-32
    800040f4:	fec40593          	addi	a1,s0,-20
    800040f8:	4501                	li	a0,0
    800040fa:	d43ff0ef          	jal	80003e3c <argfd>
    return -1;
    800040fe:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004100:	02054063          	bltz	a0,80004120 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004104:	cd3fc0ef          	jal	80000dd6 <myproc>
    80004108:	fec42783          	lw	a5,-20(s0)
    8000410c:	07e9                	addi	a5,a5,26
    8000410e:	078e                	slli	a5,a5,0x3
    80004110:	953e                	add	a0,a0,a5
    80004112:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004116:	fe043503          	ld	a0,-32(s0)
    8000411a:	bb2ff0ef          	jal	800034cc <fileclose>
  return 0;
    8000411e:	4781                	li	a5,0
}
    80004120:	853e                	mv	a0,a5
    80004122:	60e2                	ld	ra,24(sp)
    80004124:	6442                	ld	s0,16(sp)
    80004126:	6105                	addi	sp,sp,32
    80004128:	8082                	ret

000000008000412a <sys_fstat>:
{
    8000412a:	1101                	addi	sp,sp,-32
    8000412c:	ec06                	sd	ra,24(sp)
    8000412e:	e822                	sd	s0,16(sp)
    80004130:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004132:	fe040593          	addi	a1,s0,-32
    80004136:	4505                	li	a0,1
    80004138:	bc5fd0ef          	jal	80001cfc <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000413c:	fe840613          	addi	a2,s0,-24
    80004140:	4581                	li	a1,0
    80004142:	4501                	li	a0,0
    80004144:	cf9ff0ef          	jal	80003e3c <argfd>
    80004148:	87aa                	mv	a5,a0
    return -1;
    8000414a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000414c:	0007c863          	bltz	a5,8000415c <sys_fstat+0x32>
  return filestat(f, st);
    80004150:	fe043583          	ld	a1,-32(s0)
    80004154:	fe843503          	ld	a0,-24(s0)
    80004158:	c36ff0ef          	jal	8000358e <filestat>
}
    8000415c:	60e2                	ld	ra,24(sp)
    8000415e:	6442                	ld	s0,16(sp)
    80004160:	6105                	addi	sp,sp,32
    80004162:	8082                	ret

0000000080004164 <sys_link>:
{
    80004164:	7169                	addi	sp,sp,-304
    80004166:	f606                	sd	ra,296(sp)
    80004168:	f222                	sd	s0,288(sp)
    8000416a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000416c:	08000613          	li	a2,128
    80004170:	ed040593          	addi	a1,s0,-304
    80004174:	4501                	li	a0,0
    80004176:	ba3fd0ef          	jal	80001d18 <argstr>
    return -1;
    8000417a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000417c:	0c054e63          	bltz	a0,80004258 <sys_link+0xf4>
    80004180:	08000613          	li	a2,128
    80004184:	f5040593          	addi	a1,s0,-176
    80004188:	4505                	li	a0,1
    8000418a:	b8ffd0ef          	jal	80001d18 <argstr>
    return -1;
    8000418e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004190:	0c054463          	bltz	a0,80004258 <sys_link+0xf4>
    80004194:	ee26                	sd	s1,280(sp)
  begin_op();
    80004196:	f2bfe0ef          	jal	800030c0 <begin_op>
  if((ip = namei(old)) == 0){
    8000419a:	ed040513          	addi	a0,s0,-304
    8000419e:	d4ffe0ef          	jal	80002eec <namei>
    800041a2:	84aa                	mv	s1,a0
    800041a4:	c53d                	beqz	a0,80004212 <sys_link+0xae>
  ilock(ip);
    800041a6:	d30fe0ef          	jal	800026d6 <ilock>
  if(ip->type == T_DIR){
    800041aa:	04449703          	lh	a4,68(s1)
    800041ae:	4785                	li	a5,1
    800041b0:	06f70663          	beq	a4,a5,8000421c <sys_link+0xb8>
    800041b4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800041b6:	04a4d783          	lhu	a5,74(s1)
    800041ba:	2785                	addiw	a5,a5,1
    800041bc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800041c0:	8526                	mv	a0,s1
    800041c2:	c60fe0ef          	jal	80002622 <iupdate>
  iunlock(ip);
    800041c6:	8526                	mv	a0,s1
    800041c8:	dbcfe0ef          	jal	80002784 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800041cc:	fd040593          	addi	a1,s0,-48
    800041d0:	f5040513          	addi	a0,s0,-176
    800041d4:	d33fe0ef          	jal	80002f06 <nameiparent>
    800041d8:	892a                	mv	s2,a0
    800041da:	cd21                	beqz	a0,80004232 <sys_link+0xce>
  ilock(dp);
    800041dc:	cfafe0ef          	jal	800026d6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800041e0:	00092703          	lw	a4,0(s2)
    800041e4:	409c                	lw	a5,0(s1)
    800041e6:	04f71363          	bne	a4,a5,8000422c <sys_link+0xc8>
    800041ea:	40d0                	lw	a2,4(s1)
    800041ec:	fd040593          	addi	a1,s0,-48
    800041f0:	854a                	mv	a0,s2
    800041f2:	c61fe0ef          	jal	80002e52 <dirlink>
    800041f6:	02054b63          	bltz	a0,8000422c <sys_link+0xc8>
  iunlockput(dp);
    800041fa:	854a                	mv	a0,s2
    800041fc:	ee4fe0ef          	jal	800028e0 <iunlockput>
  iput(ip);
    80004200:	8526                	mv	a0,s1
    80004202:	e56fe0ef          	jal	80002858 <iput>
  end_op();
    80004206:	f25fe0ef          	jal	8000312a <end_op>
  return 0;
    8000420a:	4781                	li	a5,0
    8000420c:	64f2                	ld	s1,280(sp)
    8000420e:	6952                	ld	s2,272(sp)
    80004210:	a0a1                	j	80004258 <sys_link+0xf4>
    end_op();
    80004212:	f19fe0ef          	jal	8000312a <end_op>
    return -1;
    80004216:	57fd                	li	a5,-1
    80004218:	64f2                	ld	s1,280(sp)
    8000421a:	a83d                	j	80004258 <sys_link+0xf4>
    iunlockput(ip);
    8000421c:	8526                	mv	a0,s1
    8000421e:	ec2fe0ef          	jal	800028e0 <iunlockput>
    end_op();
    80004222:	f09fe0ef          	jal	8000312a <end_op>
    return -1;
    80004226:	57fd                	li	a5,-1
    80004228:	64f2                	ld	s1,280(sp)
    8000422a:	a03d                	j	80004258 <sys_link+0xf4>
    iunlockput(dp);
    8000422c:	854a                	mv	a0,s2
    8000422e:	eb2fe0ef          	jal	800028e0 <iunlockput>
  ilock(ip);
    80004232:	8526                	mv	a0,s1
    80004234:	ca2fe0ef          	jal	800026d6 <ilock>
  ip->nlink--;
    80004238:	04a4d783          	lhu	a5,74(s1)
    8000423c:	37fd                	addiw	a5,a5,-1
    8000423e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004242:	8526                	mv	a0,s1
    80004244:	bdefe0ef          	jal	80002622 <iupdate>
  iunlockput(ip);
    80004248:	8526                	mv	a0,s1
    8000424a:	e96fe0ef          	jal	800028e0 <iunlockput>
  end_op();
    8000424e:	eddfe0ef          	jal	8000312a <end_op>
  return -1;
    80004252:	57fd                	li	a5,-1
    80004254:	64f2                	ld	s1,280(sp)
    80004256:	6952                	ld	s2,272(sp)
}
    80004258:	853e                	mv	a0,a5
    8000425a:	70b2                	ld	ra,296(sp)
    8000425c:	7412                	ld	s0,288(sp)
    8000425e:	6155                	addi	sp,sp,304
    80004260:	8082                	ret

0000000080004262 <sys_unlink>:
{
    80004262:	7151                	addi	sp,sp,-240
    80004264:	f586                	sd	ra,232(sp)
    80004266:	f1a2                	sd	s0,224(sp)
    80004268:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000426a:	08000613          	li	a2,128
    8000426e:	f3040593          	addi	a1,s0,-208
    80004272:	4501                	li	a0,0
    80004274:	aa5fd0ef          	jal	80001d18 <argstr>
    80004278:	16054063          	bltz	a0,800043d8 <sys_unlink+0x176>
    8000427c:	eda6                	sd	s1,216(sp)
  begin_op();
    8000427e:	e43fe0ef          	jal	800030c0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004282:	fb040593          	addi	a1,s0,-80
    80004286:	f3040513          	addi	a0,s0,-208
    8000428a:	c7dfe0ef          	jal	80002f06 <nameiparent>
    8000428e:	84aa                	mv	s1,a0
    80004290:	c945                	beqz	a0,80004340 <sys_unlink+0xde>
  ilock(dp);
    80004292:	c44fe0ef          	jal	800026d6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004296:	00004597          	auipc	a1,0x4
    8000429a:	2e258593          	addi	a1,a1,738 # 80008578 <etext+0x578>
    8000429e:	fb040513          	addi	a0,s0,-80
    800042a2:	9cffe0ef          	jal	80002c70 <namecmp>
    800042a6:	10050e63          	beqz	a0,800043c2 <sys_unlink+0x160>
    800042aa:	00004597          	auipc	a1,0x4
    800042ae:	2d658593          	addi	a1,a1,726 # 80008580 <etext+0x580>
    800042b2:	fb040513          	addi	a0,s0,-80
    800042b6:	9bbfe0ef          	jal	80002c70 <namecmp>
    800042ba:	10050463          	beqz	a0,800043c2 <sys_unlink+0x160>
    800042be:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800042c0:	f2c40613          	addi	a2,s0,-212
    800042c4:	fb040593          	addi	a1,s0,-80
    800042c8:	8526                	mv	a0,s1
    800042ca:	9bdfe0ef          	jal	80002c86 <dirlookup>
    800042ce:	892a                	mv	s2,a0
    800042d0:	0e050863          	beqz	a0,800043c0 <sys_unlink+0x15e>
  ilock(ip);
    800042d4:	c02fe0ef          	jal	800026d6 <ilock>
  if(ip->nlink < 1)
    800042d8:	04a91783          	lh	a5,74(s2)
    800042dc:	06f05763          	blez	a5,8000434a <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800042e0:	04491703          	lh	a4,68(s2)
    800042e4:	4785                	li	a5,1
    800042e6:	06f70963          	beq	a4,a5,80004358 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800042ea:	4641                	li	a2,16
    800042ec:	4581                	li	a1,0
    800042ee:	fc040513          	addi	a0,s0,-64
    800042f2:	e5dfb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042f6:	4741                	li	a4,16
    800042f8:	f2c42683          	lw	a3,-212(s0)
    800042fc:	fc040613          	addi	a2,s0,-64
    80004300:	4581                	li	a1,0
    80004302:	8526                	mv	a0,s1
    80004304:	85ffe0ef          	jal	80002b62 <writei>
    80004308:	47c1                	li	a5,16
    8000430a:	08f51b63          	bne	a0,a5,800043a0 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    8000430e:	04491703          	lh	a4,68(s2)
    80004312:	4785                	li	a5,1
    80004314:	08f70d63          	beq	a4,a5,800043ae <sys_unlink+0x14c>
  iunlockput(dp);
    80004318:	8526                	mv	a0,s1
    8000431a:	dc6fe0ef          	jal	800028e0 <iunlockput>
  ip->nlink--;
    8000431e:	04a95783          	lhu	a5,74(s2)
    80004322:	37fd                	addiw	a5,a5,-1
    80004324:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004328:	854a                	mv	a0,s2
    8000432a:	af8fe0ef          	jal	80002622 <iupdate>
  iunlockput(ip);
    8000432e:	854a                	mv	a0,s2
    80004330:	db0fe0ef          	jal	800028e0 <iunlockput>
  end_op();
    80004334:	df7fe0ef          	jal	8000312a <end_op>
  return 0;
    80004338:	4501                	li	a0,0
    8000433a:	64ee                	ld	s1,216(sp)
    8000433c:	694e                	ld	s2,208(sp)
    8000433e:	a849                	j	800043d0 <sys_unlink+0x16e>
    end_op();
    80004340:	debfe0ef          	jal	8000312a <end_op>
    return -1;
    80004344:	557d                	li	a0,-1
    80004346:	64ee                	ld	s1,216(sp)
    80004348:	a061                	j	800043d0 <sys_unlink+0x16e>
    8000434a:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000434c:	00004517          	auipc	a0,0x4
    80004350:	23c50513          	addi	a0,a0,572 # 80008588 <etext+0x588>
    80004354:	296020ef          	jal	800065ea <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004358:	04c92703          	lw	a4,76(s2)
    8000435c:	02000793          	li	a5,32
    80004360:	f8e7f5e3          	bgeu	a5,a4,800042ea <sys_unlink+0x88>
    80004364:	e5ce                	sd	s3,200(sp)
    80004366:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000436a:	4741                	li	a4,16
    8000436c:	86ce                	mv	a3,s3
    8000436e:	f1840613          	addi	a2,s0,-232
    80004372:	4581                	li	a1,0
    80004374:	854a                	mv	a0,s2
    80004376:	ef0fe0ef          	jal	80002a66 <readi>
    8000437a:	47c1                	li	a5,16
    8000437c:	00f51c63          	bne	a0,a5,80004394 <sys_unlink+0x132>
    if(de.inum != 0)
    80004380:	f1845783          	lhu	a5,-232(s0)
    80004384:	efa1                	bnez	a5,800043dc <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004386:	29c1                	addiw	s3,s3,16
    80004388:	04c92783          	lw	a5,76(s2)
    8000438c:	fcf9efe3          	bltu	s3,a5,8000436a <sys_unlink+0x108>
    80004390:	69ae                	ld	s3,200(sp)
    80004392:	bfa1                	j	800042ea <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004394:	00004517          	auipc	a0,0x4
    80004398:	20c50513          	addi	a0,a0,524 # 800085a0 <etext+0x5a0>
    8000439c:	24e020ef          	jal	800065ea <panic>
    800043a0:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800043a2:	00004517          	auipc	a0,0x4
    800043a6:	21650513          	addi	a0,a0,534 # 800085b8 <etext+0x5b8>
    800043aa:	240020ef          	jal	800065ea <panic>
    dp->nlink--;
    800043ae:	04a4d783          	lhu	a5,74(s1)
    800043b2:	37fd                	addiw	a5,a5,-1
    800043b4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800043b8:	8526                	mv	a0,s1
    800043ba:	a68fe0ef          	jal	80002622 <iupdate>
    800043be:	bfa9                	j	80004318 <sys_unlink+0xb6>
    800043c0:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800043c2:	8526                	mv	a0,s1
    800043c4:	d1cfe0ef          	jal	800028e0 <iunlockput>
  end_op();
    800043c8:	d63fe0ef          	jal	8000312a <end_op>
  return -1;
    800043cc:	557d                	li	a0,-1
    800043ce:	64ee                	ld	s1,216(sp)
}
    800043d0:	70ae                	ld	ra,232(sp)
    800043d2:	740e                	ld	s0,224(sp)
    800043d4:	616d                	addi	sp,sp,240
    800043d6:	8082                	ret
    return -1;
    800043d8:	557d                	li	a0,-1
    800043da:	bfdd                	j	800043d0 <sys_unlink+0x16e>
    iunlockput(ip);
    800043dc:	854a                	mv	a0,s2
    800043de:	d02fe0ef          	jal	800028e0 <iunlockput>
    goto bad;
    800043e2:	694e                	ld	s2,208(sp)
    800043e4:	69ae                	ld	s3,200(sp)
    800043e6:	bff1                	j	800043c2 <sys_unlink+0x160>

00000000800043e8 <sys_open>:

uint64
sys_open(void)
{
    800043e8:	7131                	addi	sp,sp,-192
    800043ea:	fd06                	sd	ra,184(sp)
    800043ec:	f922                	sd	s0,176(sp)
    800043ee:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800043f0:	f4c40593          	addi	a1,s0,-180
    800043f4:	4505                	li	a0,1
    800043f6:	8ebfd0ef          	jal	80001ce0 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043fa:	08000613          	li	a2,128
    800043fe:	f5040593          	addi	a1,s0,-176
    80004402:	4501                	li	a0,0
    80004404:	915fd0ef          	jal	80001d18 <argstr>
    80004408:	87aa                	mv	a5,a0
    return -1;
    8000440a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000440c:	0a07c263          	bltz	a5,800044b0 <sys_open+0xc8>
    80004410:	f526                	sd	s1,168(sp)

  begin_op();
    80004412:	caffe0ef          	jal	800030c0 <begin_op>

  if(omode & O_CREATE){
    80004416:	f4c42783          	lw	a5,-180(s0)
    8000441a:	2007f793          	andi	a5,a5,512
    8000441e:	c3d5                	beqz	a5,800044c2 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004420:	4681                	li	a3,0
    80004422:	4601                	li	a2,0
    80004424:	4589                	li	a1,2
    80004426:	f5040513          	addi	a0,s0,-176
    8000442a:	aa9ff0ef          	jal	80003ed2 <create>
    8000442e:	84aa                	mv	s1,a0
    if(ip == 0){
    80004430:	c541                	beqz	a0,800044b8 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004432:	04449703          	lh	a4,68(s1)
    80004436:	478d                	li	a5,3
    80004438:	00f71763          	bne	a4,a5,80004446 <sys_open+0x5e>
    8000443c:	0464d703          	lhu	a4,70(s1)
    80004440:	47a5                	li	a5,9
    80004442:	0ae7ed63          	bltu	a5,a4,800044fc <sys_open+0x114>
    80004446:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004448:	fe1fe0ef          	jal	80003428 <filealloc>
    8000444c:	892a                	mv	s2,a0
    8000444e:	c179                	beqz	a0,80004514 <sys_open+0x12c>
    80004450:	ed4e                	sd	s3,152(sp)
    80004452:	a43ff0ef          	jal	80003e94 <fdalloc>
    80004456:	89aa                	mv	s3,a0
    80004458:	0a054a63          	bltz	a0,8000450c <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000445c:	04449703          	lh	a4,68(s1)
    80004460:	478d                	li	a5,3
    80004462:	0cf70263          	beq	a4,a5,80004526 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004466:	4789                	li	a5,2
    80004468:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000446c:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004470:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004474:	f4c42783          	lw	a5,-180(s0)
    80004478:	0017c713          	xori	a4,a5,1
    8000447c:	8b05                	andi	a4,a4,1
    8000447e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004482:	0037f713          	andi	a4,a5,3
    80004486:	00e03733          	snez	a4,a4
    8000448a:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000448e:	4007f793          	andi	a5,a5,1024
    80004492:	c791                	beqz	a5,8000449e <sys_open+0xb6>
    80004494:	04449703          	lh	a4,68(s1)
    80004498:	4789                	li	a5,2
    8000449a:	08f70d63          	beq	a4,a5,80004534 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    8000449e:	8526                	mv	a0,s1
    800044a0:	ae4fe0ef          	jal	80002784 <iunlock>
  end_op();
    800044a4:	c87fe0ef          	jal	8000312a <end_op>

  return fd;
    800044a8:	854e                	mv	a0,s3
    800044aa:	74aa                	ld	s1,168(sp)
    800044ac:	790a                	ld	s2,160(sp)
    800044ae:	69ea                	ld	s3,152(sp)
}
    800044b0:	70ea                	ld	ra,184(sp)
    800044b2:	744a                	ld	s0,176(sp)
    800044b4:	6129                	addi	sp,sp,192
    800044b6:	8082                	ret
      end_op();
    800044b8:	c73fe0ef          	jal	8000312a <end_op>
      return -1;
    800044bc:	557d                	li	a0,-1
    800044be:	74aa                	ld	s1,168(sp)
    800044c0:	bfc5                	j	800044b0 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800044c2:	f5040513          	addi	a0,s0,-176
    800044c6:	a27fe0ef          	jal	80002eec <namei>
    800044ca:	84aa                	mv	s1,a0
    800044cc:	c11d                	beqz	a0,800044f2 <sys_open+0x10a>
    ilock(ip);
    800044ce:	a08fe0ef          	jal	800026d6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800044d2:	04449703          	lh	a4,68(s1)
    800044d6:	4785                	li	a5,1
    800044d8:	f4f71de3          	bne	a4,a5,80004432 <sys_open+0x4a>
    800044dc:	f4c42783          	lw	a5,-180(s0)
    800044e0:	d3bd                	beqz	a5,80004446 <sys_open+0x5e>
      iunlockput(ip);
    800044e2:	8526                	mv	a0,s1
    800044e4:	bfcfe0ef          	jal	800028e0 <iunlockput>
      end_op();
    800044e8:	c43fe0ef          	jal	8000312a <end_op>
      return -1;
    800044ec:	557d                	li	a0,-1
    800044ee:	74aa                	ld	s1,168(sp)
    800044f0:	b7c1                	j	800044b0 <sys_open+0xc8>
      end_op();
    800044f2:	c39fe0ef          	jal	8000312a <end_op>
      return -1;
    800044f6:	557d                	li	a0,-1
    800044f8:	74aa                	ld	s1,168(sp)
    800044fa:	bf5d                	j	800044b0 <sys_open+0xc8>
    iunlockput(ip);
    800044fc:	8526                	mv	a0,s1
    800044fe:	be2fe0ef          	jal	800028e0 <iunlockput>
    end_op();
    80004502:	c29fe0ef          	jal	8000312a <end_op>
    return -1;
    80004506:	557d                	li	a0,-1
    80004508:	74aa                	ld	s1,168(sp)
    8000450a:	b75d                	j	800044b0 <sys_open+0xc8>
      fileclose(f);
    8000450c:	854a                	mv	a0,s2
    8000450e:	fbffe0ef          	jal	800034cc <fileclose>
    80004512:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004514:	8526                	mv	a0,s1
    80004516:	bcafe0ef          	jal	800028e0 <iunlockput>
    end_op();
    8000451a:	c11fe0ef          	jal	8000312a <end_op>
    return -1;
    8000451e:	557d                	li	a0,-1
    80004520:	74aa                	ld	s1,168(sp)
    80004522:	790a                	ld	s2,160(sp)
    80004524:	b771                	j	800044b0 <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004526:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000452a:	04649783          	lh	a5,70(s1)
    8000452e:	02f91223          	sh	a5,36(s2)
    80004532:	bf3d                	j	80004470 <sys_open+0x88>
    itrunc(ip);
    80004534:	8526                	mv	a0,s1
    80004536:	a8efe0ef          	jal	800027c4 <itrunc>
    8000453a:	b795                	j	8000449e <sys_open+0xb6>

000000008000453c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000453c:	7175                	addi	sp,sp,-144
    8000453e:	e506                	sd	ra,136(sp)
    80004540:	e122                	sd	s0,128(sp)
    80004542:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004544:	b7dfe0ef          	jal	800030c0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004548:	08000613          	li	a2,128
    8000454c:	f7040593          	addi	a1,s0,-144
    80004550:	4501                	li	a0,0
    80004552:	fc6fd0ef          	jal	80001d18 <argstr>
    80004556:	02054363          	bltz	a0,8000457c <sys_mkdir+0x40>
    8000455a:	4681                	li	a3,0
    8000455c:	4601                	li	a2,0
    8000455e:	4585                	li	a1,1
    80004560:	f7040513          	addi	a0,s0,-144
    80004564:	96fff0ef          	jal	80003ed2 <create>
    80004568:	c911                	beqz	a0,8000457c <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000456a:	b76fe0ef          	jal	800028e0 <iunlockput>
  end_op();
    8000456e:	bbdfe0ef          	jal	8000312a <end_op>
  return 0;
    80004572:	4501                	li	a0,0
}
    80004574:	60aa                	ld	ra,136(sp)
    80004576:	640a                	ld	s0,128(sp)
    80004578:	6149                	addi	sp,sp,144
    8000457a:	8082                	ret
    end_op();
    8000457c:	baffe0ef          	jal	8000312a <end_op>
    return -1;
    80004580:	557d                	li	a0,-1
    80004582:	bfcd                	j	80004574 <sys_mkdir+0x38>

0000000080004584 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004584:	7135                	addi	sp,sp,-160
    80004586:	ed06                	sd	ra,152(sp)
    80004588:	e922                	sd	s0,144(sp)
    8000458a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000458c:	b35fe0ef          	jal	800030c0 <begin_op>
  argint(1, &major);
    80004590:	f6c40593          	addi	a1,s0,-148
    80004594:	4505                	li	a0,1
    80004596:	f4afd0ef          	jal	80001ce0 <argint>
  argint(2, &minor);
    8000459a:	f6840593          	addi	a1,s0,-152
    8000459e:	4509                	li	a0,2
    800045a0:	f40fd0ef          	jal	80001ce0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045a4:	08000613          	li	a2,128
    800045a8:	f7040593          	addi	a1,s0,-144
    800045ac:	4501                	li	a0,0
    800045ae:	f6afd0ef          	jal	80001d18 <argstr>
    800045b2:	02054563          	bltz	a0,800045dc <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800045b6:	f6841683          	lh	a3,-152(s0)
    800045ba:	f6c41603          	lh	a2,-148(s0)
    800045be:	458d                	li	a1,3
    800045c0:	f7040513          	addi	a0,s0,-144
    800045c4:	90fff0ef          	jal	80003ed2 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045c8:	c911                	beqz	a0,800045dc <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800045ca:	b16fe0ef          	jal	800028e0 <iunlockput>
  end_op();
    800045ce:	b5dfe0ef          	jal	8000312a <end_op>
  return 0;
    800045d2:	4501                	li	a0,0
}
    800045d4:	60ea                	ld	ra,152(sp)
    800045d6:	644a                	ld	s0,144(sp)
    800045d8:	610d                	addi	sp,sp,160
    800045da:	8082                	ret
    end_op();
    800045dc:	b4ffe0ef          	jal	8000312a <end_op>
    return -1;
    800045e0:	557d                	li	a0,-1
    800045e2:	bfcd                	j	800045d4 <sys_mknod+0x50>

00000000800045e4 <sys_chdir>:

uint64
sys_chdir(void)
{
    800045e4:	7135                	addi	sp,sp,-160
    800045e6:	ed06                	sd	ra,152(sp)
    800045e8:	e922                	sd	s0,144(sp)
    800045ea:	e14a                	sd	s2,128(sp)
    800045ec:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800045ee:	fe8fc0ef          	jal	80000dd6 <myproc>
    800045f2:	892a                	mv	s2,a0
  
  begin_op();
    800045f4:	acdfe0ef          	jal	800030c0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800045f8:	08000613          	li	a2,128
    800045fc:	f6040593          	addi	a1,s0,-160
    80004600:	4501                	li	a0,0
    80004602:	f16fd0ef          	jal	80001d18 <argstr>
    80004606:	04054363          	bltz	a0,8000464c <sys_chdir+0x68>
    8000460a:	e526                	sd	s1,136(sp)
    8000460c:	f6040513          	addi	a0,s0,-160
    80004610:	8ddfe0ef          	jal	80002eec <namei>
    80004614:	84aa                	mv	s1,a0
    80004616:	c915                	beqz	a0,8000464a <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004618:	8befe0ef          	jal	800026d6 <ilock>
  if(ip->type != T_DIR){
    8000461c:	04449703          	lh	a4,68(s1)
    80004620:	4785                	li	a5,1
    80004622:	02f71963          	bne	a4,a5,80004654 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004626:	8526                	mv	a0,s1
    80004628:	95cfe0ef          	jal	80002784 <iunlock>
  iput(p->cwd);
    8000462c:	15093503          	ld	a0,336(s2)
    80004630:	a28fe0ef          	jal	80002858 <iput>
  end_op();
    80004634:	af7fe0ef          	jal	8000312a <end_op>
  p->cwd = ip;
    80004638:	14993823          	sd	s1,336(s2)
  return 0;
    8000463c:	4501                	li	a0,0
    8000463e:	64aa                	ld	s1,136(sp)
}
    80004640:	60ea                	ld	ra,152(sp)
    80004642:	644a                	ld	s0,144(sp)
    80004644:	690a                	ld	s2,128(sp)
    80004646:	610d                	addi	sp,sp,160
    80004648:	8082                	ret
    8000464a:	64aa                	ld	s1,136(sp)
    end_op();
    8000464c:	adffe0ef          	jal	8000312a <end_op>
    return -1;
    80004650:	557d                	li	a0,-1
    80004652:	b7fd                	j	80004640 <sys_chdir+0x5c>
    iunlockput(ip);
    80004654:	8526                	mv	a0,s1
    80004656:	a8afe0ef          	jal	800028e0 <iunlockput>
    end_op();
    8000465a:	ad1fe0ef          	jal	8000312a <end_op>
    return -1;
    8000465e:	557d                	li	a0,-1
    80004660:	64aa                	ld	s1,136(sp)
    80004662:	bff9                	j	80004640 <sys_chdir+0x5c>

0000000080004664 <sys_exec>:

uint64
sys_exec(void)
{
    80004664:	7121                	addi	sp,sp,-448
    80004666:	ff06                	sd	ra,440(sp)
    80004668:	fb22                	sd	s0,432(sp)
    8000466a:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000466c:	e4840593          	addi	a1,s0,-440
    80004670:	4505                	li	a0,1
    80004672:	e8afd0ef          	jal	80001cfc <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004676:	08000613          	li	a2,128
    8000467a:	f5040593          	addi	a1,s0,-176
    8000467e:	4501                	li	a0,0
    80004680:	e98fd0ef          	jal	80001d18 <argstr>
    80004684:	87aa                	mv	a5,a0
    return -1;
    80004686:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004688:	0c07c463          	bltz	a5,80004750 <sys_exec+0xec>
    8000468c:	f726                	sd	s1,424(sp)
    8000468e:	f34a                	sd	s2,416(sp)
    80004690:	ef4e                	sd	s3,408(sp)
    80004692:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004694:	10000613          	li	a2,256
    80004698:	4581                	li	a1,0
    8000469a:	e5040513          	addi	a0,s0,-432
    8000469e:	ab1fb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800046a2:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800046a6:	89a6                	mv	s3,s1
    800046a8:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800046aa:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800046ae:	00391513          	slli	a0,s2,0x3
    800046b2:	e4040593          	addi	a1,s0,-448
    800046b6:	e4843783          	ld	a5,-440(s0)
    800046ba:	953e                	add	a0,a0,a5
    800046bc:	d9afd0ef          	jal	80001c56 <fetchaddr>
    800046c0:	02054663          	bltz	a0,800046ec <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800046c4:	e4043783          	ld	a5,-448(s0)
    800046c8:	c3a9                	beqz	a5,8000470a <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800046ca:	a35fb0ef          	jal	800000fe <kalloc>
    800046ce:	85aa                	mv	a1,a0
    800046d0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800046d4:	cd01                	beqz	a0,800046ec <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800046d6:	6605                	lui	a2,0x1
    800046d8:	e4043503          	ld	a0,-448(s0)
    800046dc:	dc4fd0ef          	jal	80001ca0 <fetchstr>
    800046e0:	00054663          	bltz	a0,800046ec <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800046e4:	0905                	addi	s2,s2,1
    800046e6:	09a1                	addi	s3,s3,8
    800046e8:	fd4913e3          	bne	s2,s4,800046ae <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046ec:	f5040913          	addi	s2,s0,-176
    800046f0:	6088                	ld	a0,0(s1)
    800046f2:	c931                	beqz	a0,80004746 <sys_exec+0xe2>
    kfree(argv[i]);
    800046f4:	929fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046f8:	04a1                	addi	s1,s1,8
    800046fa:	ff249be3          	bne	s1,s2,800046f0 <sys_exec+0x8c>
  return -1;
    800046fe:	557d                	li	a0,-1
    80004700:	74ba                	ld	s1,424(sp)
    80004702:	791a                	ld	s2,416(sp)
    80004704:	69fa                	ld	s3,408(sp)
    80004706:	6a5a                	ld	s4,400(sp)
    80004708:	a0a1                	j	80004750 <sys_exec+0xec>
      argv[i] = 0;
    8000470a:	0009079b          	sext.w	a5,s2
    8000470e:	078e                	slli	a5,a5,0x3
    80004710:	fd078793          	addi	a5,a5,-48
    80004714:	97a2                	add	a5,a5,s0
    80004716:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    8000471a:	e5040593          	addi	a1,s0,-432
    8000471e:	f5040513          	addi	a0,s0,-176
    80004722:	ba8ff0ef          	jal	80003aca <kexec>
    80004726:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004728:	f5040993          	addi	s3,s0,-176
    8000472c:	6088                	ld	a0,0(s1)
    8000472e:	c511                	beqz	a0,8000473a <sys_exec+0xd6>
    kfree(argv[i]);
    80004730:	8edfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004734:	04a1                	addi	s1,s1,8
    80004736:	ff349be3          	bne	s1,s3,8000472c <sys_exec+0xc8>
  return ret;
    8000473a:	854a                	mv	a0,s2
    8000473c:	74ba                	ld	s1,424(sp)
    8000473e:	791a                	ld	s2,416(sp)
    80004740:	69fa                	ld	s3,408(sp)
    80004742:	6a5a                	ld	s4,400(sp)
    80004744:	a031                	j	80004750 <sys_exec+0xec>
  return -1;
    80004746:	557d                	li	a0,-1
    80004748:	74ba                	ld	s1,424(sp)
    8000474a:	791a                	ld	s2,416(sp)
    8000474c:	69fa                	ld	s3,408(sp)
    8000474e:	6a5a                	ld	s4,400(sp)
}
    80004750:	70fa                	ld	ra,440(sp)
    80004752:	745a                	ld	s0,432(sp)
    80004754:	6139                	addi	sp,sp,448
    80004756:	8082                	ret

0000000080004758 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004758:	7139                	addi	sp,sp,-64
    8000475a:	fc06                	sd	ra,56(sp)
    8000475c:	f822                	sd	s0,48(sp)
    8000475e:	f426                	sd	s1,40(sp)
    80004760:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004762:	e74fc0ef          	jal	80000dd6 <myproc>
    80004766:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004768:	fd840593          	addi	a1,s0,-40
    8000476c:	4501                	li	a0,0
    8000476e:	d8efd0ef          	jal	80001cfc <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004772:	fc840593          	addi	a1,s0,-56
    80004776:	fd040513          	addi	a0,s0,-48
    8000477a:	85cff0ef          	jal	800037d6 <pipealloc>
    return -1;
    8000477e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004780:	0a054463          	bltz	a0,80004828 <sys_pipe+0xd0>
  fd0 = -1;
    80004784:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004788:	fd043503          	ld	a0,-48(s0)
    8000478c:	f08ff0ef          	jal	80003e94 <fdalloc>
    80004790:	fca42223          	sw	a0,-60(s0)
    80004794:	08054163          	bltz	a0,80004816 <sys_pipe+0xbe>
    80004798:	fc843503          	ld	a0,-56(s0)
    8000479c:	ef8ff0ef          	jal	80003e94 <fdalloc>
    800047a0:	fca42023          	sw	a0,-64(s0)
    800047a4:	06054063          	bltz	a0,80004804 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047a8:	4691                	li	a3,4
    800047aa:	fc440613          	addi	a2,s0,-60
    800047ae:	fd843583          	ld	a1,-40(s0)
    800047b2:	68a8                	ld	a0,80(s1)
    800047b4:	b2afc0ef          	jal	80000ade <copyout>
    800047b8:	00054e63          	bltz	a0,800047d4 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800047bc:	4691                	li	a3,4
    800047be:	fc040613          	addi	a2,s0,-64
    800047c2:	fd843583          	ld	a1,-40(s0)
    800047c6:	0591                	addi	a1,a1,4
    800047c8:	68a8                	ld	a0,80(s1)
    800047ca:	b14fc0ef          	jal	80000ade <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800047ce:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047d0:	04055c63          	bgez	a0,80004828 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800047d4:	fc442783          	lw	a5,-60(s0)
    800047d8:	07e9                	addi	a5,a5,26
    800047da:	078e                	slli	a5,a5,0x3
    800047dc:	97a6                	add	a5,a5,s1
    800047de:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800047e2:	fc042783          	lw	a5,-64(s0)
    800047e6:	07e9                	addi	a5,a5,26
    800047e8:	078e                	slli	a5,a5,0x3
    800047ea:	94be                	add	s1,s1,a5
    800047ec:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800047f0:	fd043503          	ld	a0,-48(s0)
    800047f4:	cd9fe0ef          	jal	800034cc <fileclose>
    fileclose(wf);
    800047f8:	fc843503          	ld	a0,-56(s0)
    800047fc:	cd1fe0ef          	jal	800034cc <fileclose>
    return -1;
    80004800:	57fd                	li	a5,-1
    80004802:	a01d                	j	80004828 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004804:	fc442783          	lw	a5,-60(s0)
    80004808:	0007c763          	bltz	a5,80004816 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000480c:	07e9                	addi	a5,a5,26
    8000480e:	078e                	slli	a5,a5,0x3
    80004810:	97a6                	add	a5,a5,s1
    80004812:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004816:	fd043503          	ld	a0,-48(s0)
    8000481a:	cb3fe0ef          	jal	800034cc <fileclose>
    fileclose(wf);
    8000481e:	fc843503          	ld	a0,-56(s0)
    80004822:	cabfe0ef          	jal	800034cc <fileclose>
    return -1;
    80004826:	57fd                	li	a5,-1
}
    80004828:	853e                	mv	a0,a5
    8000482a:	70e2                	ld	ra,56(sp)
    8000482c:	7442                	ld	s0,48(sp)
    8000482e:	74a2                	ld	s1,40(sp)
    80004830:	6121                	addi	sp,sp,64
    80004832:	8082                	ret
	...

0000000080004840 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004840:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004842:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004844:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004846:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004848:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000484a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000484c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000484e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004850:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004852:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004854:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004856:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004858:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000485a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000485c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000485e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004860:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004862:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004864:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004866:	b00fd0ef          	jal	80001b66 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000486a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000486c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000486e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004870:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004872:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004874:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004876:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004878:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000487a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000487c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000487e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004880:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004882:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004884:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004886:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004888:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000488a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000488c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000488e:	10200073          	sret
	...

000000008000489e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000489e:	1141                	addi	sp,sp,-16
    800048a0:	e422                	sd	s0,8(sp)
    800048a2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800048a4:	0c0007b7          	lui	a5,0xc000
    800048a8:	4705                	li	a4,1
    800048aa:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800048ac:	0c0007b7          	lui	a5,0xc000
    800048b0:	c3d8                	sw	a4,4(a5)
    800048b2:	0791                	addi	a5,a5,4 # c000004 <_entry-0x73fffffc>
  
#ifdef LAB_NET
  // PCIE IRQs are 32 to 35
  for(int irq = 1; irq < 0x35; irq++){
    *(uint32*)(PLIC + irq*4) = 1;
    800048b4:	4685                	li	a3,1
  for(int irq = 1; irq < 0x35; irq++){
    800048b6:	0c000737          	lui	a4,0xc000
    800048ba:	0d470713          	addi	a4,a4,212 # c0000d4 <_entry-0x73ffff2c>
    *(uint32*)(PLIC + irq*4) = 1;
    800048be:	c394                	sw	a3,0(a5)
  for(int irq = 1; irq < 0x35; irq++){
    800048c0:	0791                	addi	a5,a5,4
    800048c2:	fee79ee3          	bne	a5,a4,800048be <plicinit+0x20>
  }
#endif  
}
    800048c6:	6422                	ld	s0,8(sp)
    800048c8:	0141                	addi	sp,sp,16
    800048ca:	8082                	ret

00000000800048cc <plicinithart>:

void
plicinithart(void)
{
    800048cc:	1141                	addi	sp,sp,-16
    800048ce:	e406                	sd	ra,8(sp)
    800048d0:	e022                	sd	s0,0(sp)
    800048d2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800048d4:	cd6fc0ef          	jal	80000daa <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800048d8:	0085179b          	slliw	a5,a0,0x8
    800048dc:	0c002737          	lui	a4,0xc002
    800048e0:	973e                	add	a4,a4,a5
    800048e2:	40200693          	li	a3,1026
    800048e6:	08d72023          	sw	a3,128(a4) # c002080 <_entry-0x73ffdf80>

#ifdef LAB_NET
  // hack to get at next 32 IRQs for e1000.
  // volatile prevents the compiler from merging this with
  // the assignment above to generate a single 64-bit store.
  *(volatile uint32*)(PLIC_SENABLE(hart)+4) = 0xffffffff;
    800048ea:	0c002737          	lui	a4,0xc002
    800048ee:	08470713          	addi	a4,a4,132 # c002084 <_entry-0x73ffdf7c>
    800048f2:	97ba                	add	a5,a5,a4
    800048f4:	577d                	li	a4,-1
    800048f6:	c398                	sw	a4,0(a5)
#endif
  
  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800048f8:	00d5151b          	slliw	a0,a0,0xd
    800048fc:	0c2017b7          	lui	a5,0xc201
    80004900:	97aa                	add	a5,a5,a0
    80004902:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004906:	60a2                	ld	ra,8(sp)
    80004908:	6402                	ld	s0,0(sp)
    8000490a:	0141                	addi	sp,sp,16
    8000490c:	8082                	ret

000000008000490e <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000490e:	1141                	addi	sp,sp,-16
    80004910:	e406                	sd	ra,8(sp)
    80004912:	e022                	sd	s0,0(sp)
    80004914:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004916:	c94fc0ef          	jal	80000daa <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000491a:	00d5151b          	slliw	a0,a0,0xd
    8000491e:	0c2017b7          	lui	a5,0xc201
    80004922:	97aa                	add	a5,a5,a0
  return irq;
}
    80004924:	43c8                	lw	a0,4(a5)
    80004926:	60a2                	ld	ra,8(sp)
    80004928:	6402                	ld	s0,0(sp)
    8000492a:	0141                	addi	sp,sp,16
    8000492c:	8082                	ret

000000008000492e <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000492e:	1101                	addi	sp,sp,-32
    80004930:	ec06                	sd	ra,24(sp)
    80004932:	e822                	sd	s0,16(sp)
    80004934:	e426                	sd	s1,8(sp)
    80004936:	1000                	addi	s0,sp,32
    80004938:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000493a:	c70fc0ef          	jal	80000daa <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000493e:	00d5151b          	slliw	a0,a0,0xd
    80004942:	0c2017b7          	lui	a5,0xc201
    80004946:	97aa                	add	a5,a5,a0
    80004948:	c3c4                	sw	s1,4(a5)
}
    8000494a:	60e2                	ld	ra,24(sp)
    8000494c:	6442                	ld	s0,16(sp)
    8000494e:	64a2                	ld	s1,8(sp)
    80004950:	6105                	addi	sp,sp,32
    80004952:	8082                	ret

0000000080004954 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004954:	1141                	addi	sp,sp,-16
    80004956:	e406                	sd	ra,8(sp)
    80004958:	e022                	sd	s0,0(sp)
    8000495a:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000495c:	479d                	li	a5,7
    8000495e:	04a7ca63          	blt	a5,a0,800049b2 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004962:	00018797          	auipc	a5,0x18
    80004966:	0ce78793          	addi	a5,a5,206 # 8001ca30 <disk>
    8000496a:	97aa                	add	a5,a5,a0
    8000496c:	0187c783          	lbu	a5,24(a5)
    80004970:	e7b9                	bnez	a5,800049be <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004972:	00451693          	slli	a3,a0,0x4
    80004976:	00018797          	auipc	a5,0x18
    8000497a:	0ba78793          	addi	a5,a5,186 # 8001ca30 <disk>
    8000497e:	6398                	ld	a4,0(a5)
    80004980:	9736                	add	a4,a4,a3
    80004982:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004986:	6398                	ld	a4,0(a5)
    80004988:	9736                	add	a4,a4,a3
    8000498a:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000498e:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004992:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004996:	97aa                	add	a5,a5,a0
    80004998:	4705                	li	a4,1
    8000499a:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000499e:	00018517          	auipc	a0,0x18
    800049a2:	0aa50513          	addi	a0,a0,170 # 8001ca48 <disk+0x18>
    800049a6:	a75fc0ef          	jal	8000141a <wakeup>
}
    800049aa:	60a2                	ld	ra,8(sp)
    800049ac:	6402                	ld	s0,0(sp)
    800049ae:	0141                	addi	sp,sp,16
    800049b0:	8082                	ret
    panic("free_desc 1");
    800049b2:	00004517          	auipc	a0,0x4
    800049b6:	c1650513          	addi	a0,a0,-1002 # 800085c8 <etext+0x5c8>
    800049ba:	431010ef          	jal	800065ea <panic>
    panic("free_desc 2");
    800049be:	00004517          	auipc	a0,0x4
    800049c2:	c1a50513          	addi	a0,a0,-998 # 800085d8 <etext+0x5d8>
    800049c6:	425010ef          	jal	800065ea <panic>

00000000800049ca <virtio_disk_init>:
{
    800049ca:	1101                	addi	sp,sp,-32
    800049cc:	ec06                	sd	ra,24(sp)
    800049ce:	e822                	sd	s0,16(sp)
    800049d0:	e426                	sd	s1,8(sp)
    800049d2:	e04a                	sd	s2,0(sp)
    800049d4:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800049d6:	00004597          	auipc	a1,0x4
    800049da:	c1258593          	addi	a1,a1,-1006 # 800085e8 <etext+0x5e8>
    800049de:	00018517          	auipc	a0,0x18
    800049e2:	17a50513          	addi	a0,a0,378 # 8001cb58 <disk+0x128>
    800049e6:	641010ef          	jal	80006826 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800049ea:	100017b7          	lui	a5,0x10001
    800049ee:	4398                	lw	a4,0(a5)
    800049f0:	2701                	sext.w	a4,a4
    800049f2:	747277b7          	lui	a5,0x74727
    800049f6:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800049fa:	18f71063          	bne	a4,a5,80004b7a <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049fe:	100017b7          	lui	a5,0x10001
    80004a02:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004a04:	439c                	lw	a5,0(a5)
    80004a06:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a08:	4709                	li	a4,2
    80004a0a:	16e79863          	bne	a5,a4,80004b7a <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a0e:	100017b7          	lui	a5,0x10001
    80004a12:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004a14:	439c                	lw	a5,0(a5)
    80004a16:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004a18:	16e79163          	bne	a5,a4,80004b7a <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004a1c:	100017b7          	lui	a5,0x10001
    80004a20:	47d8                	lw	a4,12(a5)
    80004a22:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a24:	554d47b7          	lui	a5,0x554d4
    80004a28:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004a2c:	14f71763          	bne	a4,a5,80004b7a <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a30:	100017b7          	lui	a5,0x10001
    80004a34:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a38:	4705                	li	a4,1
    80004a3a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a3c:	470d                	li	a4,3
    80004a3e:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004a40:	10001737          	lui	a4,0x10001
    80004a44:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004a46:	c7ffe737          	lui	a4,0xc7ffe
    80004a4a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47f55e57>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004a4e:	8ef9                	and	a3,a3,a4
    80004a50:	10001737          	lui	a4,0x10001
    80004a54:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a56:	472d                	li	a4,11
    80004a58:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a5a:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004a5e:	439c                	lw	a5,0(a5)
    80004a60:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004a64:	8ba1                	andi	a5,a5,8
    80004a66:	12078063          	beqz	a5,80004b86 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004a6a:	100017b7          	lui	a5,0x10001
    80004a6e:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004a72:	100017b7          	lui	a5,0x10001
    80004a76:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004a7a:	439c                	lw	a5,0(a5)
    80004a7c:	2781                	sext.w	a5,a5
    80004a7e:	10079a63          	bnez	a5,80004b92 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004a82:	100017b7          	lui	a5,0x10001
    80004a86:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004a8a:	439c                	lw	a5,0(a5)
    80004a8c:	2781                	sext.w	a5,a5
  if(max == 0)
    80004a8e:	10078863          	beqz	a5,80004b9e <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004a92:	471d                	li	a4,7
    80004a94:	10f77b63          	bgeu	a4,a5,80004baa <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004a98:	e66fb0ef          	jal	800000fe <kalloc>
    80004a9c:	00018497          	auipc	s1,0x18
    80004aa0:	f9448493          	addi	s1,s1,-108 # 8001ca30 <disk>
    80004aa4:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004aa6:	e58fb0ef          	jal	800000fe <kalloc>
    80004aaa:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004aac:	e52fb0ef          	jal	800000fe <kalloc>
    80004ab0:	87aa                	mv	a5,a0
    80004ab2:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004ab4:	6088                	ld	a0,0(s1)
    80004ab6:	10050063          	beqz	a0,80004bb6 <virtio_disk_init+0x1ec>
    80004aba:	00018717          	auipc	a4,0x18
    80004abe:	f7e73703          	ld	a4,-130(a4) # 8001ca38 <disk+0x8>
    80004ac2:	0e070a63          	beqz	a4,80004bb6 <virtio_disk_init+0x1ec>
    80004ac6:	0e078863          	beqz	a5,80004bb6 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004aca:	6605                	lui	a2,0x1
    80004acc:	4581                	li	a1,0
    80004ace:	e80fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004ad2:	00018497          	auipc	s1,0x18
    80004ad6:	f5e48493          	addi	s1,s1,-162 # 8001ca30 <disk>
    80004ada:	6605                	lui	a2,0x1
    80004adc:	4581                	li	a1,0
    80004ade:	6488                	ld	a0,8(s1)
    80004ae0:	e6efb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80004ae4:	6605                	lui	a2,0x1
    80004ae6:	4581                	li	a1,0
    80004ae8:	6888                	ld	a0,16(s1)
    80004aea:	e64fb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004aee:	100017b7          	lui	a5,0x10001
    80004af2:	4721                	li	a4,8
    80004af4:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004af6:	4098                	lw	a4,0(s1)
    80004af8:	100017b7          	lui	a5,0x10001
    80004afc:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004b00:	40d8                	lw	a4,4(s1)
    80004b02:	100017b7          	lui	a5,0x10001
    80004b06:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004b0a:	649c                	ld	a5,8(s1)
    80004b0c:	0007869b          	sext.w	a3,a5
    80004b10:	10001737          	lui	a4,0x10001
    80004b14:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004b18:	9781                	srai	a5,a5,0x20
    80004b1a:	10001737          	lui	a4,0x10001
    80004b1e:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004b22:	689c                	ld	a5,16(s1)
    80004b24:	0007869b          	sext.w	a3,a5
    80004b28:	10001737          	lui	a4,0x10001
    80004b2c:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004b30:	9781                	srai	a5,a5,0x20
    80004b32:	10001737          	lui	a4,0x10001
    80004b36:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004b3a:	10001737          	lui	a4,0x10001
    80004b3e:	4785                	li	a5,1
    80004b40:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004b42:	00f48c23          	sb	a5,24(s1)
    80004b46:	00f48ca3          	sb	a5,25(s1)
    80004b4a:	00f48d23          	sb	a5,26(s1)
    80004b4e:	00f48da3          	sb	a5,27(s1)
    80004b52:	00f48e23          	sb	a5,28(s1)
    80004b56:	00f48ea3          	sb	a5,29(s1)
    80004b5a:	00f48f23          	sb	a5,30(s1)
    80004b5e:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004b62:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b66:	100017b7          	lui	a5,0x10001
    80004b6a:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004b6e:	60e2                	ld	ra,24(sp)
    80004b70:	6442                	ld	s0,16(sp)
    80004b72:	64a2                	ld	s1,8(sp)
    80004b74:	6902                	ld	s2,0(sp)
    80004b76:	6105                	addi	sp,sp,32
    80004b78:	8082                	ret
    panic("could not find virtio disk");
    80004b7a:	00004517          	auipc	a0,0x4
    80004b7e:	a7e50513          	addi	a0,a0,-1410 # 800085f8 <etext+0x5f8>
    80004b82:	269010ef          	jal	800065ea <panic>
    panic("virtio disk FEATURES_OK unset");
    80004b86:	00004517          	auipc	a0,0x4
    80004b8a:	a9250513          	addi	a0,a0,-1390 # 80008618 <etext+0x618>
    80004b8e:	25d010ef          	jal	800065ea <panic>
    panic("virtio disk should not be ready");
    80004b92:	00004517          	auipc	a0,0x4
    80004b96:	aa650513          	addi	a0,a0,-1370 # 80008638 <etext+0x638>
    80004b9a:	251010ef          	jal	800065ea <panic>
    panic("virtio disk has no queue 0");
    80004b9e:	00004517          	auipc	a0,0x4
    80004ba2:	aba50513          	addi	a0,a0,-1350 # 80008658 <etext+0x658>
    80004ba6:	245010ef          	jal	800065ea <panic>
    panic("virtio disk max queue too short");
    80004baa:	00004517          	auipc	a0,0x4
    80004bae:	ace50513          	addi	a0,a0,-1330 # 80008678 <etext+0x678>
    80004bb2:	239010ef          	jal	800065ea <panic>
    panic("virtio disk kalloc");
    80004bb6:	00004517          	auipc	a0,0x4
    80004bba:	ae250513          	addi	a0,a0,-1310 # 80008698 <etext+0x698>
    80004bbe:	22d010ef          	jal	800065ea <panic>

0000000080004bc2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004bc2:	7159                	addi	sp,sp,-112
    80004bc4:	f486                	sd	ra,104(sp)
    80004bc6:	f0a2                	sd	s0,96(sp)
    80004bc8:	eca6                	sd	s1,88(sp)
    80004bca:	e8ca                	sd	s2,80(sp)
    80004bcc:	e4ce                	sd	s3,72(sp)
    80004bce:	e0d2                	sd	s4,64(sp)
    80004bd0:	fc56                	sd	s5,56(sp)
    80004bd2:	f85a                	sd	s6,48(sp)
    80004bd4:	f45e                	sd	s7,40(sp)
    80004bd6:	f062                	sd	s8,32(sp)
    80004bd8:	ec66                	sd	s9,24(sp)
    80004bda:	1880                	addi	s0,sp,112
    80004bdc:	8a2a                	mv	s4,a0
    80004bde:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004be0:	00c52c83          	lw	s9,12(a0)
    80004be4:	001c9c9b          	slliw	s9,s9,0x1
    80004be8:	1c82                	slli	s9,s9,0x20
    80004bea:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004bee:	00018517          	auipc	a0,0x18
    80004bf2:	f6a50513          	addi	a0,a0,-150 # 8001cb58 <disk+0x128>
    80004bf6:	4b1010ef          	jal	800068a6 <acquire>
  for(int i = 0; i < 3; i++){
    80004bfa:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004bfc:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004bfe:	00018b17          	auipc	s6,0x18
    80004c02:	e32b0b13          	addi	s6,s6,-462 # 8001ca30 <disk>
  for(int i = 0; i < 3; i++){
    80004c06:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004c08:	00018c17          	auipc	s8,0x18
    80004c0c:	f50c0c13          	addi	s8,s8,-176 # 8001cb58 <disk+0x128>
    80004c10:	a8b9                	j	80004c6e <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004c12:	00fb0733          	add	a4,s6,a5
    80004c16:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004c1a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004c1c:	0207c563          	bltz	a5,80004c46 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004c20:	2905                	addiw	s2,s2,1
    80004c22:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004c24:	05590963          	beq	s2,s5,80004c76 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004c28:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004c2a:	00018717          	auipc	a4,0x18
    80004c2e:	e0670713          	addi	a4,a4,-506 # 8001ca30 <disk>
    80004c32:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004c34:	01874683          	lbu	a3,24(a4)
    80004c38:	fee9                	bnez	a3,80004c12 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004c3a:	2785                	addiw	a5,a5,1
    80004c3c:	0705                	addi	a4,a4,1
    80004c3e:	fe979be3          	bne	a5,s1,80004c34 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004c42:	57fd                	li	a5,-1
    80004c44:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004c46:	01205d63          	blez	s2,80004c60 <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004c4a:	f9042503          	lw	a0,-112(s0)
    80004c4e:	d07ff0ef          	jal	80004954 <free_desc>
      for(int j = 0; j < i; j++)
    80004c52:	4785                	li	a5,1
    80004c54:	0127d663          	bge	a5,s2,80004c60 <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004c58:	f9442503          	lw	a0,-108(s0)
    80004c5c:	cf9ff0ef          	jal	80004954 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004c60:	85e2                	mv	a1,s8
    80004c62:	00018517          	auipc	a0,0x18
    80004c66:	de650513          	addi	a0,a0,-538 # 8001ca48 <disk+0x18>
    80004c6a:	f64fc0ef          	jal	800013ce <sleep>
  for(int i = 0; i < 3; i++){
    80004c6e:	f9040613          	addi	a2,s0,-112
    80004c72:	894e                	mv	s2,s3
    80004c74:	bf55                	j	80004c28 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c76:	f9042503          	lw	a0,-112(s0)
    80004c7a:	00451693          	slli	a3,a0,0x4

  if(write)
    80004c7e:	00018797          	auipc	a5,0x18
    80004c82:	db278793          	addi	a5,a5,-590 # 8001ca30 <disk>
    80004c86:	00a50713          	addi	a4,a0,10
    80004c8a:	0712                	slli	a4,a4,0x4
    80004c8c:	973e                	add	a4,a4,a5
    80004c8e:	01703633          	snez	a2,s7
    80004c92:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004c94:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004c98:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c9c:	6398                	ld	a4,0(a5)
    80004c9e:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004ca0:	0a868613          	addi	a2,a3,168
    80004ca4:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004ca6:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004ca8:	6390                	ld	a2,0(a5)
    80004caa:	00d605b3          	add	a1,a2,a3
    80004cae:	4741                	li	a4,16
    80004cb0:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004cb2:	4805                	li	a6,1
    80004cb4:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004cb8:	f9442703          	lw	a4,-108(s0)
    80004cbc:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004cc0:	0712                	slli	a4,a4,0x4
    80004cc2:	963a                	add	a2,a2,a4
    80004cc4:	058a0593          	addi	a1,s4,88
    80004cc8:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004cca:	0007b883          	ld	a7,0(a5)
    80004cce:	9746                	add	a4,a4,a7
    80004cd0:	40000613          	li	a2,1024
    80004cd4:	c710                	sw	a2,8(a4)
  if(write)
    80004cd6:	001bb613          	seqz	a2,s7
    80004cda:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004cde:	00166613          	ori	a2,a2,1
    80004ce2:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004ce6:	f9842583          	lw	a1,-104(s0)
    80004cea:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004cee:	00250613          	addi	a2,a0,2
    80004cf2:	0612                	slli	a2,a2,0x4
    80004cf4:	963e                	add	a2,a2,a5
    80004cf6:	577d                	li	a4,-1
    80004cf8:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004cfc:	0592                	slli	a1,a1,0x4
    80004cfe:	98ae                	add	a7,a7,a1
    80004d00:	03068713          	addi	a4,a3,48
    80004d04:	973e                	add	a4,a4,a5
    80004d06:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004d0a:	6398                	ld	a4,0(a5)
    80004d0c:	972e                	add	a4,a4,a1
    80004d0e:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004d12:	4689                	li	a3,2
    80004d14:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004d18:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004d1c:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004d20:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004d24:	6794                	ld	a3,8(a5)
    80004d26:	0026d703          	lhu	a4,2(a3)
    80004d2a:	8b1d                	andi	a4,a4,7
    80004d2c:	0706                	slli	a4,a4,0x1
    80004d2e:	96ba                	add	a3,a3,a4
    80004d30:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004d34:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004d38:	6798                	ld	a4,8(a5)
    80004d3a:	00275783          	lhu	a5,2(a4)
    80004d3e:	2785                	addiw	a5,a5,1
    80004d40:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004d44:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004d48:	100017b7          	lui	a5,0x10001
    80004d4c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004d50:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004d54:	00018917          	auipc	s2,0x18
    80004d58:	e0490913          	addi	s2,s2,-508 # 8001cb58 <disk+0x128>
  while(b->disk == 1) {
    80004d5c:	4485                	li	s1,1
    80004d5e:	01079a63          	bne	a5,a6,80004d72 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004d62:	85ca                	mv	a1,s2
    80004d64:	8552                	mv	a0,s4
    80004d66:	e68fc0ef          	jal	800013ce <sleep>
  while(b->disk == 1) {
    80004d6a:	004a2783          	lw	a5,4(s4)
    80004d6e:	fe978ae3          	beq	a5,s1,80004d62 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004d72:	f9042903          	lw	s2,-112(s0)
    80004d76:	00290713          	addi	a4,s2,2
    80004d7a:	0712                	slli	a4,a4,0x4
    80004d7c:	00018797          	auipc	a5,0x18
    80004d80:	cb478793          	addi	a5,a5,-844 # 8001ca30 <disk>
    80004d84:	97ba                	add	a5,a5,a4
    80004d86:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004d8a:	00018997          	auipc	s3,0x18
    80004d8e:	ca698993          	addi	s3,s3,-858 # 8001ca30 <disk>
    80004d92:	00491713          	slli	a4,s2,0x4
    80004d96:	0009b783          	ld	a5,0(s3)
    80004d9a:	97ba                	add	a5,a5,a4
    80004d9c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004da0:	854a                	mv	a0,s2
    80004da2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004da6:	bafff0ef          	jal	80004954 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004daa:	8885                	andi	s1,s1,1
    80004dac:	f0fd                	bnez	s1,80004d92 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004dae:	00018517          	auipc	a0,0x18
    80004db2:	daa50513          	addi	a0,a0,-598 # 8001cb58 <disk+0x128>
    80004db6:	389010ef          	jal	8000693e <release>
}
    80004dba:	70a6                	ld	ra,104(sp)
    80004dbc:	7406                	ld	s0,96(sp)
    80004dbe:	64e6                	ld	s1,88(sp)
    80004dc0:	6946                	ld	s2,80(sp)
    80004dc2:	69a6                	ld	s3,72(sp)
    80004dc4:	6a06                	ld	s4,64(sp)
    80004dc6:	7ae2                	ld	s5,56(sp)
    80004dc8:	7b42                	ld	s6,48(sp)
    80004dca:	7ba2                	ld	s7,40(sp)
    80004dcc:	7c02                	ld	s8,32(sp)
    80004dce:	6ce2                	ld	s9,24(sp)
    80004dd0:	6165                	addi	sp,sp,112
    80004dd2:	8082                	ret

0000000080004dd4 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004dd4:	1101                	addi	sp,sp,-32
    80004dd6:	ec06                	sd	ra,24(sp)
    80004dd8:	e822                	sd	s0,16(sp)
    80004dda:	e426                	sd	s1,8(sp)
    80004ddc:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004dde:	00018497          	auipc	s1,0x18
    80004de2:	c5248493          	addi	s1,s1,-942 # 8001ca30 <disk>
    80004de6:	00018517          	auipc	a0,0x18
    80004dea:	d7250513          	addi	a0,a0,-654 # 8001cb58 <disk+0x128>
    80004dee:	2b9010ef          	jal	800068a6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004df2:	100017b7          	lui	a5,0x10001
    80004df6:	53b8                	lw	a4,96(a5)
    80004df8:	8b0d                	andi	a4,a4,3
    80004dfa:	100017b7          	lui	a5,0x10001
    80004dfe:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004e00:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004e04:	689c                	ld	a5,16(s1)
    80004e06:	0204d703          	lhu	a4,32(s1)
    80004e0a:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004e0e:	04f70663          	beq	a4,a5,80004e5a <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004e12:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004e16:	6898                	ld	a4,16(s1)
    80004e18:	0204d783          	lhu	a5,32(s1)
    80004e1c:	8b9d                	andi	a5,a5,7
    80004e1e:	078e                	slli	a5,a5,0x3
    80004e20:	97ba                	add	a5,a5,a4
    80004e22:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004e24:	00278713          	addi	a4,a5,2
    80004e28:	0712                	slli	a4,a4,0x4
    80004e2a:	9726                	add	a4,a4,s1
    80004e2c:	01074703          	lbu	a4,16(a4)
    80004e30:	e321                	bnez	a4,80004e70 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004e32:	0789                	addi	a5,a5,2
    80004e34:	0792                	slli	a5,a5,0x4
    80004e36:	97a6                	add	a5,a5,s1
    80004e38:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004e3a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004e3e:	ddcfc0ef          	jal	8000141a <wakeup>

    disk.used_idx += 1;
    80004e42:	0204d783          	lhu	a5,32(s1)
    80004e46:	2785                	addiw	a5,a5,1
    80004e48:	17c2                	slli	a5,a5,0x30
    80004e4a:	93c1                	srli	a5,a5,0x30
    80004e4c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004e50:	6898                	ld	a4,16(s1)
    80004e52:	00275703          	lhu	a4,2(a4)
    80004e56:	faf71ee3          	bne	a4,a5,80004e12 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004e5a:	00018517          	auipc	a0,0x18
    80004e5e:	cfe50513          	addi	a0,a0,-770 # 8001cb58 <disk+0x128>
    80004e62:	2dd010ef          	jal	8000693e <release>
}
    80004e66:	60e2                	ld	ra,24(sp)
    80004e68:	6442                	ld	s0,16(sp)
    80004e6a:	64a2                	ld	s1,8(sp)
    80004e6c:	6105                	addi	sp,sp,32
    80004e6e:	8082                	ret
      panic("virtio_disk_intr status");
    80004e70:	00004517          	auipc	a0,0x4
    80004e74:	84050513          	addi	a0,a0,-1984 # 800086b0 <etext+0x6b0>
    80004e78:	772010ef          	jal	800065ea <panic>

0000000080004e7c <e1000_init>:
// e1000's registers are mapped.
// this code loosely follows the initialization directions
// in Chapter 14 of Intel's Software Developer's Manual.
void
e1000_init(uint32 *xregs)
{
    80004e7c:	1101                	addi	sp,sp,-32
    80004e7e:	ec06                	sd	ra,24(sp)
    80004e80:	e822                	sd	s0,16(sp)
    80004e82:	e426                	sd	s1,8(sp)
    80004e84:	e04a                	sd	s2,0(sp)
    80004e86:	1000                	addi	s0,sp,32
    80004e88:	84aa                	mv	s1,a0
  int i;

  initlock(&e1000_lock, "e1000");
    80004e8a:	00004597          	auipc	a1,0x4
    80004e8e:	83e58593          	addi	a1,a1,-1986 # 800086c8 <etext+0x6c8>
    80004e92:	00018517          	auipc	a0,0x18
    80004e96:	cde50513          	addi	a0,a0,-802 # 8001cb70 <e1000_lock>
    80004e9a:	18d010ef          	jal	80006826 <initlock>

  regs = xregs;
    80004e9e:	00007797          	auipc	a5,0x7
    80004ea2:	a897b123          	sd	s1,-1406(a5) # 8000b920 <regs>

  // Reset the device
  regs[E1000_IMS] = 0; // disable interrupts
    80004ea6:	0c04a823          	sw	zero,208(s1)
  regs[E1000_CTL] |= E1000_CTL_RST;
    80004eaa:	409c                	lw	a5,0(s1)
    80004eac:	04000737          	lui	a4,0x4000
    80004eb0:	8fd9                	or	a5,a5,a4
    80004eb2:	c09c                	sw	a5,0(s1)
  regs[E1000_IMS] = 0; // redisable interrupts
    80004eb4:	0c04a823          	sw	zero,208(s1)
  __sync_synchronize();
    80004eb8:	0330000f          	fence	rw,rw

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
    80004ebc:	00018497          	auipc	s1,0x18
    80004ec0:	cd448493          	addi	s1,s1,-812 # 8001cb90 <tx_ring>
    80004ec4:	10000613          	li	a2,256
    80004ec8:	4581                	li	a1,0
    80004eca:	8526                	mv	a0,s1
    80004ecc:	a82fb0ef          	jal	8000014e <memset>
  for (i = 0; i < TX_RING_SIZE; i++) {
    80004ed0:	8526                	mv	a0,s1
    80004ed2:	00018717          	auipc	a4,0x18
    80004ed6:	dbe70713          	addi	a4,a4,-578 # 8001cc90 <tx_bufs>
    tx_ring[i].status = E1000_TXD_STAT_DD;
    80004eda:	4785                	li	a5,1
    80004edc:	00f50623          	sb	a5,12(a0)
    tx_ring[i].addr = 0;
    80004ee0:	00053023          	sd	zero,0(a0)
  for (i = 0; i < TX_RING_SIZE; i++) {
    80004ee4:	0541                	addi	a0,a0,16
    80004ee6:	fee51be3          	bne	a0,a4,80004edc <e1000_init+0x60>
  }
  memset(tx_bufs, 0, sizeof(tx_bufs));
    80004eea:	08000613          	li	a2,128
    80004eee:	4581                	li	a1,0
    80004ef0:	00018517          	auipc	a0,0x18
    80004ef4:	da050513          	addi	a0,a0,-608 # 8001cc90 <tx_bufs>
    80004ef8:	a56fb0ef          	jal	8000014e <memset>
  regs[E1000_TDBAL] = (uint64) tx_ring;
    80004efc:	00018717          	auipc	a4,0x18
    80004f00:	c9470713          	addi	a4,a4,-876 # 8001cb90 <tx_ring>
    80004f04:	00007797          	auipc	a5,0x7
    80004f08:	a1c7b783          	ld	a5,-1508(a5) # 8000b920 <regs>
    80004f0c:	6691                	lui	a3,0x4
    80004f0e:	97b6                	add	a5,a5,a3
    80004f10:	80e7a023          	sw	a4,-2048(a5)
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
    80004f14:	10000713          	li	a4,256
    80004f18:	80e7a423          	sw	a4,-2040(a5)
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
    80004f1c:	8007ac23          	sw	zero,-2024(a5)
    80004f20:	8007a823          	sw	zero,-2032(a5)
  
  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
    80004f24:	00018497          	auipc	s1,0x18
    80004f28:	dec48493          	addi	s1,s1,-532 # 8001cd10 <rx_ring>
    80004f2c:	10000613          	li	a2,256
    80004f30:	4581                	li	a1,0
    80004f32:	8526                	mv	a0,s1
    80004f34:	a1afb0ef          	jal	8000014e <memset>
  for (i = 0; i < RX_RING_SIZE; i++) {
    80004f38:	00018917          	auipc	s2,0x18
    80004f3c:	ed890913          	addi	s2,s2,-296 # 8001ce10 <netlock>
    rx_bufs[i] = kalloc();
    80004f40:	9befb0ef          	jal	800000fe <kalloc>
    if (rx_bufs[i] == 0)
    80004f44:	c55d                	beqz	a0,80004ff2 <e1000_init+0x176>
      panic("e1000");
    rx_ring[i].addr = (uint64) rx_bufs[i];
    80004f46:	e088                	sd	a0,0(s1)
    rx_ring[i].status = 0;
    80004f48:	00048623          	sb	zero,12(s1)
  for (i = 0; i < RX_RING_SIZE; i++) {
    80004f4c:	04c1                	addi	s1,s1,16
    80004f4e:	ff2499e3          	bne	s1,s2,80004f40 <e1000_init+0xc4>
  }
  regs[E1000_RDBAL] = (uint64) rx_ring;
    80004f52:	00007697          	auipc	a3,0x7
    80004f56:	9ce6b683          	ld	a3,-1586(a3) # 8000b920 <regs>
    80004f5a:	00018717          	auipc	a4,0x18
    80004f5e:	db670713          	addi	a4,a4,-586 # 8001cd10 <rx_ring>
    80004f62:	678d                	lui	a5,0x3
    80004f64:	97b6                	add	a5,a5,a3
    80004f66:	80e7a023          	sw	a4,-2048(a5) # 2800 <_entry-0x7fffd800>
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;
    80004f6a:	8007a823          	sw	zero,-2032(a5)
  regs[E1000_RDT] = RX_RING_SIZE - 1;
    80004f6e:	473d                	li	a4,15
    80004f70:	80e7ac23          	sw	a4,-2024(a5)
  regs[E1000_RDLEN] = sizeof(rx_ring);
    80004f74:	10000713          	li	a4,256
    80004f78:	80e7a423          	sw	a4,-2040(a5)

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
    80004f7c:	6795                	lui	a5,0x5
    80004f7e:	97b6                	add	a5,a5,a3
    80004f80:	12005737          	lui	a4,0x12005
    80004f84:	45270713          	addi	a4,a4,1106 # 12005452 <_entry-0x6dffabae>
    80004f88:	40e7a023          	sw	a4,1024(a5) # 5400 <_entry-0x7fffac00>
  regs[E1000_RA+1] = 0x5634 | (1<<31);
    80004f8c:	80005737          	lui	a4,0x80005
    80004f90:	63470713          	addi	a4,a4,1588 # ffffffff80005634 <end+0xfffffffefff5cd2c>
    80004f94:	40e7a223          	sw	a4,1028(a5)
  // multicast table
  for (int i = 0; i < 4096/32; i++)
    80004f98:	6795                	lui	a5,0x5
    80004f9a:	20078793          	addi	a5,a5,512 # 5200 <_entry-0x7fffae00>
    80004f9e:	97b6                	add	a5,a5,a3
    80004fa0:	6715                	lui	a4,0x5
    80004fa2:	40070713          	addi	a4,a4,1024 # 5400 <_entry-0x7fffac00>
    80004fa6:	9736                	add	a4,a4,a3
    regs[E1000_MTA + i] = 0;
    80004fa8:	0007a023          	sw	zero,0(a5)
  for (int i = 0; i < 4096/32; i++)
    80004fac:	0791                	addi	a5,a5,4
    80004fae:	fee79de3          	bne	a5,a4,80004fa8 <e1000_init+0x12c>

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |  // enable
    80004fb2:	000407b7          	lui	a5,0x40
    80004fb6:	10a78793          	addi	a5,a5,266 # 4010a <_entry-0x7ffbfef6>
    80004fba:	40f6a023          	sw	a5,1024(a3)
    E1000_TCTL_PSP |                  // pad short packets
    (0x10 << E1000_TCTL_CT_SHIFT) |   // collision stuff
    (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8<<10) | (6<<20); // inter-pkt gap
    80004fbe:	006027b7          	lui	a5,0x602
    80004fc2:	07a9                	addi	a5,a5,10 # 60200a <_entry-0x7f9fdff6>
    80004fc4:	40f6a823          	sw	a5,1040(a3)

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN | // enable receiver
    80004fc8:	040087b7          	lui	a5,0x4008
    80004fcc:	0789                	addi	a5,a5,2 # 4008002 <_entry-0x7bff7ffe>
    80004fce:	10f6a023          	sw	a5,256(a3)
    E1000_RCTL_BAM |                 // enable broadcast
    E1000_RCTL_SZ_2048 |             // 2048-byte rx buffers
    E1000_RCTL_SECRC;                // strip CRC
  
  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0; // interrupt after every received packet (no timer)
    80004fd2:	678d                	lui	a5,0x3
    80004fd4:	97b6                	add	a5,a5,a3
    80004fd6:	8207a023          	sw	zero,-2016(a5) # 2820 <_entry-0x7fffd7e0>
  regs[E1000_RADV] = 0; // interrupt after every packet (no timer)
    80004fda:	8207a623          	sw	zero,-2004(a5)
  regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
    80004fde:	08000793          	li	a5,128
    80004fe2:	0cf6a823          	sw	a5,208(a3)
}
    80004fe6:	60e2                	ld	ra,24(sp)
    80004fe8:	6442                	ld	s0,16(sp)
    80004fea:	64a2                	ld	s1,8(sp)
    80004fec:	6902                	ld	s2,0(sp)
    80004fee:	6105                	addi	sp,sp,32
    80004ff0:	8082                	ret
      panic("e1000");
    80004ff2:	00003517          	auipc	a0,0x3
    80004ff6:	6d650513          	addi	a0,a0,1750 # 800086c8 <etext+0x6c8>
    80004ffa:	5f0010ef          	jal	800065ea <panic>

0000000080004ffe <e1000_transmit>:

int
e1000_transmit(char *buf, int len)
{
    80004ffe:	7179                	addi	sp,sp,-48
    80005000:	f406                	sd	ra,40(sp)
    80005002:	f022                	sd	s0,32(sp)
    80005004:	ec26                	sd	s1,24(sp)
    80005006:	e84a                	sd	s2,16(sp)
    80005008:	e44e                	sd	s3,8(sp)
    8000500a:	e052                	sd	s4,0(sp)
    8000500c:	1800                	addi	s0,sp,48
    8000500e:	89aa                	mv	s3,a0
    80005010:	8a2e                	mv	s4,a1
  acquire(&e1000_lock);
    80005012:	00018917          	auipc	s2,0x18
    80005016:	b5e90913          	addi	s2,s2,-1186 # 8001cb70 <e1000_lock>
    8000501a:	854a                	mv	a0,s2
    8000501c:	08b010ef          	jal	800068a6 <acquire>

  uint32 idx = regs[E1000_TDT] % TX_RING_SIZE;
    80005020:	00007797          	auipc	a5,0x7
    80005024:	9007b783          	ld	a5,-1792(a5) # 8000b920 <regs>
    80005028:	6711                	lui	a4,0x4
    8000502a:	97ba                	add	a5,a5,a4
    8000502c:	8187a783          	lw	a5,-2024(a5)
    80005030:	00f7f493          	andi	s1,a5,15

  if ((tx_ring[idx].status & E1000_TXD_STAT_DD) == 0) {
    80005034:	00449793          	slli	a5,s1,0x4
    80005038:	993e                	add	s2,s2,a5
    8000503a:	02c94783          	lbu	a5,44(s2)
    8000503e:	8b85                	andi	a5,a5,1
    80005040:	c7bd                	beqz	a5,800050ae <e1000_transmit+0xb0>
    release(&e1000_lock);
    return -1;
  }
  if (tx_bufs[idx]) {
    80005042:	00349713          	slli	a4,s1,0x3
    80005046:	00018797          	auipc	a5,0x18
    8000504a:	b2a78793          	addi	a5,a5,-1238 # 8001cb70 <e1000_lock>
    8000504e:	97ba                	add	a5,a5,a4
    80005050:	1207b503          	ld	a0,288(a5)
    80005054:	c119                	beqz	a0,8000505a <e1000_transmit+0x5c>
    kfree(tx_bufs[idx]);
    80005056:	fc7fa0ef          	jal	8000001c <kfree>
    tx_bufs[idx] = 0;
  }

  tx_ring[idx].addr = (uint64)buf;
    8000505a:	00018517          	auipc	a0,0x18
    8000505e:	b1650513          	addi	a0,a0,-1258 # 8001cb70 <e1000_lock>
    80005062:	00449793          	slli	a5,s1,0x4
    80005066:	97aa                	add	a5,a5,a0
    80005068:	0337b023          	sd	s3,32(a5)
  tx_ring[idx].length = len;
    8000506c:	03479423          	sh	s4,40(a5)
  tx_ring[idx].cmd = E1000_TXD_CMD_EOP | E1000_TXD_CMD_RS; 
    80005070:	4725                	li	a4,9
    80005072:	02e785a3          	sb	a4,43(a5)
  tx_ring[idx].status = 0; 
    80005076:	02078623          	sb	zero,44(a5)

  tx_bufs[idx] = buf;
    8000507a:	00349793          	slli	a5,s1,0x3
    8000507e:	97aa                	add	a5,a5,a0
    80005080:	1337b023          	sd	s3,288(a5)
  regs[E1000_TDT] = (idx + 1) % TX_RING_SIZE;
    80005084:	2485                	addiw	s1,s1,1
    80005086:	88bd                	andi	s1,s1,15
    80005088:	00007797          	auipc	a5,0x7
    8000508c:	8987b783          	ld	a5,-1896(a5) # 8000b920 <regs>
    80005090:	6711                	lui	a4,0x4
    80005092:	97ba                	add	a5,a5,a4
    80005094:	8097ac23          	sw	s1,-2024(a5)

  release(&e1000_lock);
    80005098:	0a7010ef          	jal	8000693e <release>
  return 0;
    8000509c:	4501                	li	a0,0
}
    8000509e:	70a2                	ld	ra,40(sp)
    800050a0:	7402                	ld	s0,32(sp)
    800050a2:	64e2                	ld	s1,24(sp)
    800050a4:	6942                	ld	s2,16(sp)
    800050a6:	69a2                	ld	s3,8(sp)
    800050a8:	6a02                	ld	s4,0(sp)
    800050aa:	6145                	addi	sp,sp,48
    800050ac:	8082                	ret
    release(&e1000_lock);
    800050ae:	00018517          	auipc	a0,0x18
    800050b2:	ac250513          	addi	a0,a0,-1342 # 8001cb70 <e1000_lock>
    800050b6:	089010ef          	jal	8000693e <release>
    return -1;
    800050ba:	557d                	li	a0,-1
    800050bc:	b7cd                	j	8000509e <e1000_transmit+0xa0>

00000000800050be <e1000_intr>:



void
e1000_intr(void)
{
    800050be:	7139                	addi	sp,sp,-64
    800050c0:	fc06                	sd	ra,56(sp)
    800050c2:	f822                	sd	s0,48(sp)
    800050c4:	f426                	sd	s1,40(sp)
    800050c6:	f04a                	sd	s2,32(sp)
    800050c8:	0080                	addi	s0,sp,64
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;
    800050ca:	00007497          	auipc	s1,0x7
    800050ce:	85648493          	addi	s1,s1,-1962 # 8000b920 <regs>
    800050d2:	609c                	ld	a5,0(s1)
    800050d4:	577d                	li	a4,-1
    800050d6:	0ce7a023          	sw	a4,192(a5)
  acquire(&e1000_lock);
    800050da:	00018917          	auipc	s2,0x18
    800050de:	a9690913          	addi	s2,s2,-1386 # 8001cb70 <e1000_lock>
    800050e2:	854a                	mv	a0,s2
    800050e4:	7c2010ef          	jal	800068a6 <acquire>
  uint32 idx = (regs[E1000_RDT] + 1) % RX_RING_SIZE;
    800050e8:	609c                	ld	a5,0(s1)
    800050ea:	670d                	lui	a4,0x3
    800050ec:	97ba                	add	a5,a5,a4
    800050ee:	8187a783          	lw	a5,-2024(a5)
    800050f2:	2785                	addiw	a5,a5,1
    800050f4:	00f7f493          	andi	s1,a5,15
  while (rx_ring[idx].status & E1000_RXD_STAT_DD) {
    800050f8:	00449793          	slli	a5,s1,0x4
    800050fc:	993e                	add	s2,s2,a5
    800050fe:	1ac94783          	lbu	a5,428(s2)
    80005102:	0017f713          	andi	a4,a5,1
    80005106:	cf41                	beqz	a4,8000519e <e1000_intr+0xe0>
    80005108:	ec4e                	sd	s3,24(sp)
    8000510a:	e852                	sd	s4,16(sp)
    8000510c:	e456                	sd	s5,8(sp)
    8000510e:	e05a                	sd	s6,0(sp)
    char *buf = (char *)rx_ring[idx].addr;
    80005110:	00018917          	auipc	s2,0x18
    80005114:	a6090913          	addi	s2,s2,-1440 # 8001cb70 <e1000_lock>
    regs[E1000_RDT] = idx;
    80005118:	00007a17          	auipc	s4,0x7
    8000511c:	808a0a13          	addi	s4,s4,-2040 # 8000b920 <regs>
    80005120:	698d                	lui	s3,0x3
    80005122:	a899                	j	80005178 <e1000_intr+0xba>
    char *buf = (char *)rx_ring[idx].addr;
    80005124:	00449793          	slli	a5,s1,0x4
    80005128:	97ca                	add	a5,a5,s2
    8000512a:	1a07ba83          	ld	s5,416(a5)
    int len = rx_ring[idx].length;
    8000512e:	1a87db03          	lhu	s6,424(a5)
    char *newbuf = kalloc();
    80005132:	fcdfa0ef          	jal	800000fe <kalloc>
    if(newbuf == 0){
    80005136:	c141                	beqz	a0,800051b6 <e1000_intr+0xf8>
    rx_ring[idx].addr = (uint64)newbuf;
    80005138:	00449793          	slli	a5,s1,0x4
    8000513c:	97ca                	add	a5,a5,s2
    8000513e:	1aa7b023          	sd	a0,416(a5)
    rx_ring[idx].status = 0;
    80005142:	1a078623          	sb	zero,428(a5)
    release(&e1000_lock);
    80005146:	854a                	mv	a0,s2
    80005148:	7f6010ef          	jal	8000693e <release>
    net_rx(buf, len);
    8000514c:	85da                	mv	a1,s6
    8000514e:	8556                	mv	a0,s5
    80005150:	3d3000ef          	jal	80005d22 <net_rx>
    acquire(&e1000_lock);
    80005154:	854a                	mv	a0,s2
    80005156:	750010ef          	jal	800068a6 <acquire>
    regs[E1000_RDT] = idx;
    8000515a:	000a3783          	ld	a5,0(s4)
    8000515e:	97ce                	add	a5,a5,s3
    80005160:	8097ac23          	sw	s1,-2024(a5)
    idx = (idx + 1) % RX_RING_SIZE;
    80005164:	2485                	addiw	s1,s1,1
    80005166:	88bd                	andi	s1,s1,15
  while (rx_ring[idx].status & E1000_RXD_STAT_DD) {
    80005168:	00449793          	slli	a5,s1,0x4
    8000516c:	97ca                	add	a5,a5,s2
    8000516e:	1ac7c783          	lbu	a5,428(a5)
    80005172:	0017f713          	andi	a4,a5,1
    80005176:	c305                	beqz	a4,80005196 <e1000_intr+0xd8>
    if ((rx_ring[idx].status & E1000_RXD_STAT_EOP) == 0) {
    80005178:	8b89                	andi	a5,a5,2
    8000517a:	f7cd                	bnez	a5,80005124 <e1000_intr+0x66>
      rx_ring[idx].status = 0;
    8000517c:	00449793          	slli	a5,s1,0x4
    80005180:	97ca                	add	a5,a5,s2
    80005182:	1a078623          	sb	zero,428(a5)
      regs[E1000_RDT] = idx;
    80005186:	000a3783          	ld	a5,0(s4)
    8000518a:	97ce                	add	a5,a5,s3
    8000518c:	8097ac23          	sw	s1,-2024(a5)
      idx = (idx + 1) % RX_RING_SIZE;
    80005190:	2485                	addiw	s1,s1,1
    80005192:	88bd                	andi	s1,s1,15
      continue;
    80005194:	bfd1                	j	80005168 <e1000_intr+0xaa>
    80005196:	69e2                	ld	s3,24(sp)
    80005198:	6a42                	ld	s4,16(sp)
    8000519a:	6aa2                	ld	s5,8(sp)
    8000519c:	6b02                	ld	s6,0(sp)
  release(&e1000_lock);
    8000519e:	00018517          	auipc	a0,0x18
    800051a2:	9d250513          	addi	a0,a0,-1582 # 8001cb70 <e1000_lock>
    800051a6:	798010ef          	jal	8000693e <release>
  e1000_recv();
}
    800051aa:	70e2                	ld	ra,56(sp)
    800051ac:	7442                	ld	s0,48(sp)
    800051ae:	74a2                	ld	s1,40(sp)
    800051b0:	7902                	ld	s2,32(sp)
    800051b2:	6121                	addi	sp,sp,64
    800051b4:	8082                	ret
    800051b6:	69e2                	ld	s3,24(sp)
    800051b8:	6a42                	ld	s4,16(sp)
    800051ba:	6aa2                	ld	s5,8(sp)
    800051bc:	6b02                	ld	s6,0(sp)
    800051be:	b7c5                	j	8000519e <e1000_intr+0xe0>

00000000800051c0 <in_cksum>:

// This code is lifted from FreeBSD's ping.c, and is copyright by the Regents
// of the University of California.
static unsigned short
in_cksum(const unsigned char *addr, int len)
{
    800051c0:	1141                	addi	sp,sp,-16
    800051c2:	e422                	sd	s0,8(sp)
    800051c4:	0800                	addi	s0,sp,16
  /*
   * Our algorithm is simple, using a 32 bit accumulator (sum), we add
   * sequential 16 bit words to it, and at the end, fold back all the
   * carry bits from the top 16 bits into the lower 16 bits.
   */
  while (nleft > 1)  {
    800051c6:	4785                	li	a5,1
    800051c8:	04b7db63          	bge	a5,a1,8000521e <in_cksum+0x5e>
    800051cc:	ffe5861b          	addiw	a2,a1,-2
    800051d0:	0016561b          	srliw	a2,a2,0x1
    800051d4:	0016069b          	addiw	a3,a2,1
    800051d8:	02069793          	slli	a5,a3,0x20
    800051dc:	01f7d693          	srli	a3,a5,0x1f
    800051e0:	96aa                	add	a3,a3,a0
  unsigned int sum = 0;
    800051e2:	4781                	li	a5,0
    sum += *w++;
    800051e4:	0509                	addi	a0,a0,2
    800051e6:	ffe55703          	lhu	a4,-2(a0)
    800051ea:	9fb9                	addw	a5,a5,a4
  while (nleft > 1)  {
    800051ec:	fed51ce3          	bne	a0,a3,800051e4 <in_cksum+0x24>
    800051f0:	35f9                	addiw	a1,a1,-2
    800051f2:	0016161b          	slliw	a2,a2,0x1
    800051f6:	9d91                	subw	a1,a1,a2
    nleft -= 2;
  }

  /* mop up an odd byte, if necessary */
  if (nleft == 1) {
    800051f8:	4705                	li	a4,1
    800051fa:	02e58563          	beq	a1,a4,80005224 <in_cksum+0x64>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    sum += answer;
  }

  /* add back carry outs from top 16 bits to low 16 bits */
  sum = (sum & 0xffff) + (sum >> 16);
    800051fe:	03079713          	slli	a4,a5,0x30
    80005202:	9341                	srli	a4,a4,0x30
    80005204:	0107d79b          	srliw	a5,a5,0x10
    80005208:	9fb9                	addw	a5,a5,a4
  sum += (sum >> 16);
    8000520a:	0107d51b          	srliw	a0,a5,0x10
    8000520e:	9d3d                	addw	a0,a0,a5
  /* guaranteed now that the lower 16 bits of sum are correct */

  answer = ~sum; /* truncate to 16 bits */
    80005210:	fff54513          	not	a0,a0
  return answer;
}
    80005214:	1542                	slli	a0,a0,0x30
    80005216:	9141                	srli	a0,a0,0x30
    80005218:	6422                	ld	s0,8(sp)
    8000521a:	0141                	addi	sp,sp,16
    8000521c:	8082                	ret
  const unsigned short *w = (const unsigned short *)addr;
    8000521e:	86aa                	mv	a3,a0
  unsigned int sum = 0;
    80005220:	4781                	li	a5,0
    80005222:	bfd9                	j	800051f8 <in_cksum+0x38>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    80005224:	0006c703          	lbu	a4,0(a3)
    sum += answer;
    80005228:	9fb9                	addw	a5,a5,a4
    8000522a:	bfd1                	j	800051fe <in_cksum+0x3e>

000000008000522c <notify_socket_error>:
}

// *ICMP*
static int
notify_socket_error(char *buf)
{
    8000522c:	7179                	addi	sp,sp,-48
    8000522e:	f406                	sd	ra,40(sp)
    80005230:	f022                	sd	s0,32(sp)
    80005232:	e84a                	sd	s2,16(sp)
    80005234:	1800                	addi	s0,sp,48
  struct eth *eth = (struct eth *)buf;
  struct ip *ip = (struct ip *)(eth + 1);
  int ip_hlen = (ip->ip_vhl & 0x0f) * 4;
    80005236:	00e54783          	lbu	a5,14(a0)
    8000523a:	8bbd                	andi	a5,a5,15
    8000523c:	0027979b          	slliw	a5,a5,0x2
  struct icmp *icmp = (struct icmp *)((char *)ip + ip_hlen);
    80005240:	27b9                	addiw	a5,a5,14
    80005242:	2781                	sext.w	a5,a5
    80005244:	953e                	add	a0,a0,a5

  struct ip *inner_ip = (struct ip *)((char *)icmp + 8);
  int inner_ip_hlen = (inner_ip->ip_vhl & 0x0f) * 4;
    80005246:	00854783          	lbu	a5,8(a0)
    8000524a:	8bbd                	andi	a5,a5,15
    8000524c:	0027979b          	slliw	a5,a5,0x2
  struct udp *inner_udp = (struct udp *)((char *)inner_ip + inner_ip_hlen);
    80005250:	27a1                	addiw	a5,a5,8
    80005252:	2781                	sext.w	a5,a5
  
  uint16 local_port = ntohs(inner_udp->dport);
    80005254:	953e                	add	a0,a0,a5
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
    80005256:	00255783          	lhu	a5,2(a0)
    8000525a:	0087971b          	slliw	a4,a5,0x8
    8000525e:	83a1                	srli	a5,a5,0x8
    80005260:	8fd9                	or	a5,a5,a4
    80005262:	17c2                	slli	a5,a5,0x30
    80005264:	93c1                	srli	a5,a5,0x30
  int handled = 0;

  if(local_port < NUDPPORT){
    80005266:	0007869b          	sext.w	a3,a5
    8000526a:	03f00713          	li	a4,63
  int handled = 0;
    8000526e:	4901                	li	s2,0
  if(local_port < NUDPPORT){
    80005270:	00d77863          	bgeu	a4,a3,80005280 <notify_socket_error+0x54>
      handled = 1; // Successfully matched to a listening app
    }
    release(&q->lock);
  }
  return handled;
}
    80005274:	854a                	mv	a0,s2
    80005276:	70a2                	ld	ra,40(sp)
    80005278:	7402                	ld	s0,32(sp)
    8000527a:	6942                	ld	s2,16(sp)
    8000527c:	6145                	addi	sp,sp,48
    8000527e:	8082                	ret
    80005280:	ec26                	sd	s1,24(sp)
    80005282:	e44e                	sd	s3,8(sp)
    80005284:	e052                	sd	s4,0(sp)
    struct udp_queue *q = &udp_ports[local_port];
    80005286:	8a36                	mv	s4,a3
    80005288:	6909                	lui	s2,0x2
    8000528a:	0e890913          	addi	s2,s2,232 # 20e8 <_entry-0x7fffdf18>
    8000528e:	032787b3          	mul	a5,a5,s2
    80005292:	00018997          	auipc	s3,0x18
    80005296:	b9698993          	addi	s3,s3,-1130 # 8001ce28 <udp_ports>
    8000529a:	013784b3          	add	s1,a5,s3
    acquire(&q->lock);
    8000529e:	8526                	mv	a0,s1
    800052a0:	606010ef          	jal	800068a6 <acquire>
    if(q->bound){
    800052a4:	032a0933          	mul	s2,s4,s2
    800052a8:	99ca                	add	s3,s3,s2
    800052aa:	0189a903          	lw	s2,24(s3)
    800052ae:	00091963          	bnez	s2,800052c0 <notify_socket_error+0x94>
    release(&q->lock);
    800052b2:	8526                	mv	a0,s1
    800052b4:	68a010ef          	jal	8000693e <release>
    800052b8:	64e2                	ld	s1,24(sp)
    800052ba:	69a2                	ld	s3,8(sp)
    800052bc:	6a02                	ld	s4,0(sp)
    800052be:	bf5d                	j	80005274 <notify_socket_error+0x48>
      q->err = 1;
    800052c0:	6789                	lui	a5,0x2
    800052c2:	97ce                	add	a5,a5,s3
    800052c4:	4705                	li	a4,1
    800052c6:	0ee7a223          	sw	a4,228(a5) # 20e4 <_entry-0x7fffdf1c>
      wakeup(q); 
    800052ca:	8526                	mv	a0,s1
    800052cc:	94efc0ef          	jal	8000141a <wakeup>
      handled = 1; // Successfully matched to a listening app
    800052d0:	4905                	li	s2,1
    800052d2:	b7c5                	j	800052b2 <notify_socket_error+0x86>

00000000800052d4 <netinit>:
{
    800052d4:	7139                	addi	sp,sp,-64
    800052d6:	fc06                	sd	ra,56(sp)
    800052d8:	f822                	sd	s0,48(sp)
    800052da:	f426                	sd	s1,40(sp)
    800052dc:	f04a                	sd	s2,32(sp)
    800052de:	ec4e                	sd	s3,24(sp)
    800052e0:	e852                	sd	s4,16(sp)
    800052e2:	e456                	sd	s5,8(sp)
    800052e4:	0080                	addi	s0,sp,64
  initlock(&netlock, "netlock");
    800052e6:	00003597          	auipc	a1,0x3
    800052ea:	3ea58593          	addi	a1,a1,1002 # 800086d0 <etext+0x6d0>
    800052ee:	00018517          	auipc	a0,0x18
    800052f2:	b2250513          	addi	a0,a0,-1246 # 8001ce10 <netlock>
    800052f6:	530010ef          	jal	80006826 <initlock>
  for(int i = 0; i < NUDPPORT; i++){
    800052fa:	00018917          	auipc	s2,0x18
    800052fe:	b2e90913          	addi	s2,s2,-1234 # 8001ce28 <udp_ports>
    80005302:	0001a497          	auipc	s1,0x1a
    80005306:	c0248493          	addi	s1,s1,-1022 # 8001ef04 <udp_ports+0x20dc>
    8000530a:	0009da97          	auipc	s5,0x9d
    8000530e:	5faa8a93          	addi	s5,s5,1530 # 800a2904 <stack0+0x20d4>
    initlock(&udp_ports[i].lock, "udpq");
    80005312:	00003a17          	auipc	s4,0x3
    80005316:	3c6a0a13          	addi	s4,s4,966 # 800086d8 <etext+0x6d8>
  for(int i = 0; i < NUDPPORT; i++){
    8000531a:	6989                	lui	s3,0x2
    8000531c:	0e898993          	addi	s3,s3,232 # 20e8 <_entry-0x7fffdf18>
    initlock(&udp_ports[i].lock, "udpq");
    80005320:	85d2                	mv	a1,s4
    80005322:	854a                	mv	a0,s2
    80005324:	502010ef          	jal	80006826 <initlock>
    udp_ports[i].bound = 0;
    80005328:	00092c23          	sw	zero,24(s2)
    udp_ports[i].r = 0;
    8000532c:	0004a023          	sw	zero,0(s1)
    udp_ports[i].w = 0;
    80005330:	0004a223          	sw	zero,4(s1)
    udp_ports[i].err = 0;     // *ICMP*
    80005334:	0004a423          	sw	zero,8(s1)
  for(int i = 0; i < NUDPPORT; i++){
    80005338:	994e                	add	s2,s2,s3
    8000533a:	94ce                	add	s1,s1,s3
    8000533c:	ff5492e3          	bne	s1,s5,80005320 <netinit+0x4c>
}
    80005340:	70e2                	ld	ra,56(sp)
    80005342:	7442                	ld	s0,48(sp)
    80005344:	74a2                	ld	s1,40(sp)
    80005346:	7902                	ld	s2,32(sp)
    80005348:	69e2                	ld	s3,24(sp)
    8000534a:	6a42                	ld	s4,16(sp)
    8000534c:	6aa2                	ld	s5,8(sp)
    8000534e:	6121                	addi	sp,sp,64
    80005350:	8082                	ret

0000000080005352 <sys_bind>:
{
    80005352:	7179                	addi	sp,sp,-48
    80005354:	f406                	sd	ra,40(sp)
    80005356:	f022                	sd	s0,32(sp)
    80005358:	1800                	addi	s0,sp,48
  argint(0, &port);
    8000535a:	fdc40593          	addi	a1,s0,-36
    8000535e:	4501                	li	a0,0
    80005360:	981fc0ef          	jal	80001ce0 <argint>
  if(port < 0 || port >= NUDPPORT)
    80005364:	fdc42783          	lw	a5,-36(s0)
    80005368:	0007869b          	sext.w	a3,a5
    8000536c:	03f00713          	li	a4,63
    return -1;
    80005370:	557d                	li	a0,-1
  if(port < 0 || port >= NUDPPORT)
    80005372:	04d76363          	bltu	a4,a3,800053b8 <sys_bind+0x66>
    80005376:	ec26                	sd	s1,24(sp)
    80005378:	e84a                	sd	s2,16(sp)
  acquire(&udp_ports[port].lock);
    8000537a:	6909                	lui	s2,0x2
    8000537c:	0e890913          	addi	s2,s2,232 # 20e8 <_entry-0x7fffdf18>
    80005380:	03278533          	mul	a0,a5,s2
    80005384:	00018497          	auipc	s1,0x18
    80005388:	aa448493          	addi	s1,s1,-1372 # 8001ce28 <udp_ports>
    8000538c:	9526                	add	a0,a0,s1
    8000538e:	518010ef          	jal	800068a6 <acquire>
  udp_ports[port].bound = 1;
    80005392:	fdc42783          	lw	a5,-36(s0)
    80005396:	032787b3          	mul	a5,a5,s2
    8000539a:	00f48533          	add	a0,s1,a5
    8000539e:	4785                	li	a5,1
    800053a0:	cd1c                	sw	a5,24(a0)
  udp_ports[port].r = 0;
    800053a2:	6789                	lui	a5,0x2
    800053a4:	97aa                	add	a5,a5,a0
    800053a6:	0c07ae23          	sw	zero,220(a5) # 20dc <_entry-0x7fffdf24>
  udp_ports[port].w = 0;
    800053aa:	0e07a023          	sw	zero,224(a5)
  release(&udp_ports[port].lock);
    800053ae:	590010ef          	jal	8000693e <release>
  return 0;
    800053b2:	4501                	li	a0,0
    800053b4:	64e2                	ld	s1,24(sp)
    800053b6:	6942                	ld	s2,16(sp)
}
    800053b8:	70a2                	ld	ra,40(sp)
    800053ba:	7402                	ld	s0,32(sp)
    800053bc:	6145                	addi	sp,sp,48
    800053be:	8082                	ret

00000000800053c0 <sys_unbind>:
{
    800053c0:	7179                	addi	sp,sp,-48
    800053c2:	f406                	sd	ra,40(sp)
    800053c4:	f022                	sd	s0,32(sp)
    800053c6:	ec26                	sd	s1,24(sp)
    800053c8:	1800                	addi	s0,sp,48
  argint(0, &port);
    800053ca:	fdc40593          	addi	a1,s0,-36
    800053ce:	4501                	li	a0,0
    800053d0:	911fc0ef          	jal	80001ce0 <argint>
  if(port < 0 || port >= NUDPPORT)
    800053d4:	fdc42483          	lw	s1,-36(s0)
    800053d8:	0004871b          	sext.w	a4,s1
    800053dc:	03f00793          	li	a5,63
    return -1;
    800053e0:	557d                	li	a0,-1
  if(port < 0 || port >= NUDPPORT)
    800053e2:	02e7e963          	bltu	a5,a4,80005414 <sys_unbind+0x54>
  acquire(&q->lock);
    800053e6:	6789                	lui	a5,0x2
    800053e8:	0e878793          	addi	a5,a5,232 # 20e8 <_entry-0x7fffdf18>
    800053ec:	02f484b3          	mul	s1,s1,a5
    800053f0:	00018797          	auipc	a5,0x18
    800053f4:	a3878793          	addi	a5,a5,-1480 # 8001ce28 <udp_ports>
    800053f8:	94be                	add	s1,s1,a5
    800053fa:	8526                	mv	a0,s1
    800053fc:	4aa010ef          	jal	800068a6 <acquire>
  q->w = 0;
    80005400:	6789                	lui	a5,0x2
    80005402:	97a6                	add	a5,a5,s1
    80005404:	0e07a023          	sw	zero,224(a5) # 20e0 <_entry-0x7fffdf20>
  q->bound = 0;
    80005408:	0004ac23          	sw	zero,24(s1)
  release(&q->lock);
    8000540c:	8526                	mv	a0,s1
    8000540e:	530010ef          	jal	8000693e <release>
  return 0;
    80005412:	4501                	li	a0,0
}
    80005414:	70a2                	ld	ra,40(sp)
    80005416:	7402                	ld	s0,32(sp)
    80005418:	64e2                	ld	s1,24(sp)
    8000541a:	6145                	addi	sp,sp,48
    8000541c:	8082                	ret

000000008000541e <sys_recv>:
{
    8000541e:	7159                	addi	sp,sp,-112
    80005420:	f486                	sd	ra,104(sp)
    80005422:	f0a2                	sd	s0,96(sp)
    80005424:	eca6                	sd	s1,88(sp)
    80005426:	e0d2                	sd	s4,64(sp)
    80005428:	1880                	addi	s0,sp,112
  argint(0, &dport);
    8000542a:	fbc40593          	addi	a1,s0,-68
    8000542e:	4501                	li	a0,0
    80005430:	8b1fc0ef          	jal	80001ce0 <argint>
  argaddr(1, &srcaddr);
    80005434:	fb040593          	addi	a1,s0,-80
    80005438:	4505                	li	a0,1
    8000543a:	8c3fc0ef          	jal	80001cfc <argaddr>
  argaddr(2, &sportaddr);
    8000543e:	fa840593          	addi	a1,s0,-88
    80005442:	4509                	li	a0,2
    80005444:	8b9fc0ef          	jal	80001cfc <argaddr>
  argaddr(3, &bufaddr);
    80005448:	fa040593          	addi	a1,s0,-96
    8000544c:	450d                	li	a0,3
    8000544e:	8affc0ef          	jal	80001cfc <argaddr>
  argint(4, &maxlen);
    80005452:	f9c40593          	addi	a1,s0,-100
    80005456:	4511                	li	a0,4
    80005458:	889fc0ef          	jal	80001ce0 <argint>
  if(dport < 0 || dport >= NUDPPORT)
    8000545c:	fbc42a03          	lw	s4,-68(s0)
    80005460:	000a071b          	sext.w	a4,s4
    80005464:	03f00793          	li	a5,63
    return -1;
    80005468:	54fd                	li	s1,-1
  if(dport < 0 || dport >= NUDPPORT)
    8000546a:	16e7eb63          	bltu	a5,a4,800055e0 <sys_recv+0x1c2>
    8000546e:	e8ca                	sd	s2,80(sp)
    80005470:	e4ce                	sd	s3,72(sp)
  struct udp_queue *q = &udp_ports[dport];
    80005472:	6989                	lui	s3,0x2
    80005474:	0e898993          	addi	s3,s3,232 # 20e8 <_entry-0x7fffdf18>
    80005478:	033a09b3          	mul	s3,s4,s3
    8000547c:	00018917          	auipc	s2,0x18
    80005480:	9ac90913          	addi	s2,s2,-1620 # 8001ce28 <udp_ports>
    80005484:	994e                	add	s2,s2,s3
  acquire(&q->lock);
    80005486:	854a                	mv	a0,s2
    80005488:	41e010ef          	jal	800068a6 <acquire>
  while(q->r == q->w){
    8000548c:	6709                	lui	a4,0x2
    8000548e:	974a                	add	a4,a4,s2
    80005490:	0dc72783          	lw	a5,220(a4) # 20dc <_entry-0x7fffdf24>
    80005494:	0e072703          	lw	a4,224(a4)
    80005498:	02f71263          	bne	a4,a5,800054bc <sys_recv+0x9e>
    if(q->err){
    8000549c:	6489                	lui	s1,0x2
    8000549e:	94ca                	add	s1,s1,s2
    800054a0:	0e44a783          	lw	a5,228(s1) # 20e4 <_entry-0x7fffdf1c>
    800054a4:	10079a63          	bnez	a5,800055b8 <sys_recv+0x19a>
    sleep(q, &q->lock);
    800054a8:	85ca                	mv	a1,s2
    800054aa:	854a                	mv	a0,s2
    800054ac:	f23fb0ef          	jal	800013ce <sleep>
  while(q->r == q->w){
    800054b0:	0dc4a783          	lw	a5,220(s1)
    800054b4:	0e04a703          	lw	a4,224(s1)
    800054b8:	fef704e3          	beq	a4,a5,800054a0 <sys_recv+0x82>
  if(q->err){
    800054bc:	6709                	lui	a4,0x2
    800054be:	0e870713          	addi	a4,a4,232 # 20e8 <_entry-0x7fffdf18>
    800054c2:	02ea0733          	mul	a4,s4,a4
    800054c6:	00018697          	auipc	a3,0x18
    800054ca:	96268693          	addi	a3,a3,-1694 # 8001ce28 <udp_ports>
    800054ce:	96ba                	add	a3,a3,a4
    800054d0:	6709                	lui	a4,0x2
    800054d2:	9736                	add	a4,a4,a3
    800054d4:	0e472703          	lw	a4,228(a4) # 20e4 <_entry-0x7fffdf1c>
    800054d8:	10071b63          	bnez	a4,800055ee <sys_recv+0x1d0>
    800054dc:	fc56                	sd	s5,56(sp)
    800054de:	f85a                	sd	s6,48(sp)
  struct udp_packet *p = &q->pkts[q->r % UDPQSIZE];
    800054e0:	41f7d71b          	sraiw	a4,a5,0x1f
    800054e4:	01c7571b          	srliw	a4,a4,0x1c
    800054e8:	00f70abb          	addw	s5,a4,a5
    800054ec:	00fafa93          	andi	s5,s5,15
    800054f0:	40ea8abb          	subw	s5,s5,a4
  q->r++;
    800054f4:	00018497          	auipc	s1,0x18
    800054f8:	93448493          	addi	s1,s1,-1740 # 8001ce28 <udp_ports>
    800054fc:	6709                	lui	a4,0x2
    800054fe:	0e870713          	addi	a4,a4,232 # 20e8 <_entry-0x7fffdf18>
    80005502:	02ea0733          	mul	a4,s4,a4
    80005506:	9726                	add	a4,a4,s1
    80005508:	6689                	lui	a3,0x2
    8000550a:	9736                	add	a4,a4,a3
    8000550c:	2785                	addiw	a5,a5,1
    8000550e:	0cf72e23          	sw	a5,220(a4)
  release(&q->lock);
    80005512:	854a                	mv	a0,s2
    80005514:	42a010ef          	jal	8000693e <release>
  struct proc *pr = myproc();
    80005518:	8bffb0ef          	jal	80000dd6 <myproc>
    8000551c:	892a                	mv	s2,a0
  if(copyout(pr->pagetable, srcaddr, (char*)&p->src, sizeof(p->src)) < 0)
    8000551e:	20c00b13          	li	s6,524
    80005522:	036a8b33          	mul	s6,s5,s6
    80005526:	01c98613          	addi	a2,s3,28
    8000552a:	965a                	add	a2,a2,s6
    8000552c:	4691                	li	a3,4
    8000552e:	9626                	add	a2,a2,s1
    80005530:	fb043583          	ld	a1,-80(s0)
    80005534:	6928                	ld	a0,80(a0)
    80005536:	da8fb0ef          	jal	80000ade <copyout>
    return -1;
    8000553a:	54fd                	li	s1,-1
  if(copyout(pr->pagetable, srcaddr, (char*)&p->src, sizeof(p->src)) < 0)
    8000553c:	0c054a63          	bltz	a0,80005610 <sys_recv+0x1f2>
  if(copyout(pr->pagetable, sportaddr, (char*)&p->sport, sizeof(p->sport)) < 0)
    80005540:	02098793          	addi	a5,s3,32
    80005544:	97da                	add	a5,a5,s6
    80005546:	4689                	li	a3,2
    80005548:	00018617          	auipc	a2,0x18
    8000554c:	8e060613          	addi	a2,a2,-1824 # 8001ce28 <udp_ports>
    80005550:	963e                	add	a2,a2,a5
    80005552:	fa843583          	ld	a1,-88(s0)
    80005556:	05093503          	ld	a0,80(s2)
    8000555a:	d84fb0ef          	jal	80000ade <copyout>
    8000555e:	0a054e63          	bltz	a0,8000561a <sys_recv+0x1fc>
  int n = p->len;
    80005562:	6789                	lui	a5,0x2
    80005564:	0e878793          	addi	a5,a5,232 # 20e8 <_entry-0x7fffdf18>
    80005568:	02fa0a33          	mul	s4,s4,a5
    8000556c:	014b0ab3          	add	s5,s6,s4
    80005570:	00018797          	auipc	a5,0x18
    80005574:	8b878793          	addi	a5,a5,-1864 # 8001ce28 <udp_ports>
    80005578:	97d6                	add	a5,a5,s5
  if(n > maxlen) n = maxlen;
    8000557a:	53d8                	lw	a4,36(a5)
    8000557c:	f9c42783          	lw	a5,-100(s0)
    80005580:	84be                	mv	s1,a5
    80005582:	2781                	sext.w	a5,a5
    80005584:	00f75363          	bge	a4,a5,8000558a <sys_recv+0x16c>
    80005588:	84ba                	mv	s1,a4
  if(copyout(pr->pagetable, bufaddr, p->data, n) < 0)
    8000558a:	2481                	sext.w	s1,s1
    8000558c:	02898993          	addi	s3,s3,40
    80005590:	99da                	add	s3,s3,s6
    80005592:	86a6                	mv	a3,s1
    80005594:	00018617          	auipc	a2,0x18
    80005598:	89460613          	addi	a2,a2,-1900 # 8001ce28 <udp_ports>
    8000559c:	964e                	add	a2,a2,s3
    8000559e:	fa043583          	ld	a1,-96(s0)
    800055a2:	05093503          	ld	a0,80(s2)
    800055a6:	d38fb0ef          	jal	80000ade <copyout>
    800055aa:	04054d63          	bltz	a0,80005604 <sys_recv+0x1e6>
    800055ae:	6946                	ld	s2,80(sp)
    800055b0:	69a6                	ld	s3,72(sp)
    800055b2:	7ae2                	ld	s5,56(sp)
    800055b4:	7b42                	ld	s6,48(sp)
    800055b6:	a02d                	j	800055e0 <sys_recv+0x1c2>
      q->err = 0; // Clear the error so next call works
    800055b8:	6789                	lui	a5,0x2
    800055ba:	0e878793          	addi	a5,a5,232 # 20e8 <_entry-0x7fffdf18>
    800055be:	02fa07b3          	mul	a5,s4,a5
    800055c2:	00018717          	auipc	a4,0x18
    800055c6:	86670713          	addi	a4,a4,-1946 # 8001ce28 <udp_ports>
    800055ca:	973e                	add	a4,a4,a5
    800055cc:	6789                	lui	a5,0x2
    800055ce:	97ba                	add	a5,a5,a4
    800055d0:	0e07a223          	sw	zero,228(a5) # 20e4 <_entry-0x7fffdf1c>
      release(&q->lock);
    800055d4:	854a                	mv	a0,s2
    800055d6:	368010ef          	jal	8000693e <release>
      return -1; // Return error to user
    800055da:	54fd                	li	s1,-1
    800055dc:	6946                	ld	s2,80(sp)
    800055de:	69a6                	ld	s3,72(sp)
}
    800055e0:	8526                	mv	a0,s1
    800055e2:	70a6                	ld	ra,104(sp)
    800055e4:	7406                	ld	s0,96(sp)
    800055e6:	64e6                	ld	s1,88(sp)
    800055e8:	6a06                	ld	s4,64(sp)
    800055ea:	6165                	addi	sp,sp,112
    800055ec:	8082                	ret
    q->err = 0;
    800055ee:	6789                	lui	a5,0x2
    800055f0:	97b6                	add	a5,a5,a3
    800055f2:	0e07a223          	sw	zero,228(a5) # 20e4 <_entry-0x7fffdf1c>
    release(&q->lock);
    800055f6:	854a                	mv	a0,s2
    800055f8:	346010ef          	jal	8000693e <release>
    return -1;
    800055fc:	54fd                	li	s1,-1
    800055fe:	6946                	ld	s2,80(sp)
    80005600:	69a6                	ld	s3,72(sp)
    80005602:	bff9                	j	800055e0 <sys_recv+0x1c2>
    return -1;
    80005604:	54fd                	li	s1,-1
    80005606:	6946                	ld	s2,80(sp)
    80005608:	69a6                	ld	s3,72(sp)
    8000560a:	7ae2                	ld	s5,56(sp)
    8000560c:	7b42                	ld	s6,48(sp)
    8000560e:	bfc9                	j	800055e0 <sys_recv+0x1c2>
    80005610:	6946                	ld	s2,80(sp)
    80005612:	69a6                	ld	s3,72(sp)
    80005614:	7ae2                	ld	s5,56(sp)
    80005616:	7b42                	ld	s6,48(sp)
    80005618:	b7e1                	j	800055e0 <sys_recv+0x1c2>
    8000561a:	6946                	ld	s2,80(sp)
    8000561c:	69a6                	ld	s3,72(sp)
    8000561e:	7ae2                	ld	s5,56(sp)
    80005620:	7b42                	ld	s6,48(sp)
    80005622:	bf7d                	j	800055e0 <sys_recv+0x1c2>

0000000080005624 <sys_send>:
{
    80005624:	711d                	addi	sp,sp,-96
    80005626:	ec86                	sd	ra,88(sp)
    80005628:	e8a2                	sd	s0,80(sp)
    8000562a:	fc4e                	sd	s3,56(sp)
    8000562c:	f852                	sd	s4,48(sp)
    8000562e:	1080                	addi	s0,sp,96
  struct proc *p = myproc();
    80005630:	fa6fb0ef          	jal	80000dd6 <myproc>
    80005634:	8a2a                	mv	s4,a0
  argint(0, &sport);
    80005636:	fbc40593          	addi	a1,s0,-68
    8000563a:	4501                	li	a0,0
    8000563c:	ea4fc0ef          	jal	80001ce0 <argint>
  argint(1, &dst);
    80005640:	fb840593          	addi	a1,s0,-72
    80005644:	4505                	li	a0,1
    80005646:	e9afc0ef          	jal	80001ce0 <argint>
  argint(2, &dport);
    8000564a:	fb440593          	addi	a1,s0,-76
    8000564e:	4509                	li	a0,2
    80005650:	e90fc0ef          	jal	80001ce0 <argint>
  argaddr(3, &bufaddr);
    80005654:	fa840593          	addi	a1,s0,-88
    80005658:	450d                	li	a0,3
    8000565a:	ea2fc0ef          	jal	80001cfc <argaddr>
  argint(4, &len);
    8000565e:	fa440593          	addi	a1,s0,-92
    80005662:	4511                	li	a0,4
    80005664:	e7cfc0ef          	jal	80001ce0 <argint>
  int total = len + sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp);
    80005668:	fa442983          	lw	s3,-92(s0)
    8000566c:	02a9899b          	addiw	s3,s3,42
  if(total > PGSIZE)
    80005670:	6785                	lui	a5,0x1
    return -1;
    80005672:	557d                	li	a0,-1
  if(total > PGSIZE)
    80005674:	1537c463          	blt	a5,s3,800057bc <sys_send+0x198>
    80005678:	e4a6                	sd	s1,72(sp)
  char *buf = kalloc();
    8000567a:	a85fa0ef          	jal	800000fe <kalloc>
    8000567e:	84aa                	mv	s1,a0
  if(buf == 0){
    80005680:	14050463          	beqz	a0,800057c8 <sys_send+0x1a4>
    80005684:	e0ca                	sd	s2,64(sp)
    80005686:	f456                	sd	s5,40(sp)
  memset(buf, 0, PGSIZE);
    80005688:	6605                	lui	a2,0x1
    8000568a:	4581                	li	a1,0
    8000568c:	ac3fa0ef          	jal	8000014e <memset>
  memmove(eth->dhost, host_mac, ETHADDR_LEN);
    80005690:	4619                	li	a2,6
    80005692:	00006597          	auipc	a1,0x6
    80005696:	23658593          	addi	a1,a1,566 # 8000b8c8 <host_mac>
    8000569a:	8526                	mv	a0,s1
    8000569c:	b0ffa0ef          	jal	800001aa <memmove>
  memmove(eth->shost, local_mac, ETHADDR_LEN);
    800056a0:	4619                	li	a2,6
    800056a2:	00006597          	auipc	a1,0x6
    800056a6:	22e58593          	addi	a1,a1,558 # 8000b8d0 <local_mac>
    800056aa:	00648513          	addi	a0,s1,6
    800056ae:	afdfa0ef          	jal	800001aa <memmove>
  eth->type = htons(ETHTYPE_IP);
    800056b2:	47a1                	li	a5,8
    800056b4:	00f48623          	sb	a5,12(s1)
    800056b8:	000486a3          	sb	zero,13(s1)
  ip->ip_vhl = 0x45; // version 4, header length 4*5
    800056bc:	04500793          	li	a5,69
    800056c0:	00f48723          	sb	a5,14(s1)
  ip->ip_tos = 0;
    800056c4:	000487a3          	sb	zero,15(s1)
  ip->ip_len = htons(sizeof(struct ip) + sizeof(struct udp) + len);
    800056c8:	fa442a83          	lw	s5,-92(s0)
    800056cc:	030a9913          	slli	s2,s5,0x30
    800056d0:	03095913          	srli	s2,s2,0x30
    800056d4:	01c9079b          	addiw	a5,s2,28
    800056d8:	0087971b          	slliw	a4,a5,0x8
    800056dc:	0107979b          	slliw	a5,a5,0x10
    800056e0:	0107d79b          	srliw	a5,a5,0x10
    800056e4:	0087d79b          	srliw	a5,a5,0x8
    800056e8:	8fd9                	or	a5,a5,a4
    800056ea:	00f49823          	sh	a5,16(s1)
  ip->ip_id = 0;
    800056ee:	00049923          	sh	zero,18(s1)
  ip->ip_off = 0;
    800056f2:	00049a23          	sh	zero,20(s1)
  ip->ip_ttl = 100;
    800056f6:	06400793          	li	a5,100
    800056fa:	00f48b23          	sb	a5,22(s1)
  ip->ip_p = IPPROTO_UDP;
    800056fe:	47c5                	li	a5,17
    80005700:	00f48ba3          	sb	a5,23(s1)
  ip->ip_src = htonl(local_ip);
    80005704:	0f0207b7          	lui	a5,0xf020
    80005708:	07a9                	addi	a5,a5,10 # f02000a <_entry-0x70fdfff6>
    8000570a:	00f4ad23          	sw	a5,26(s1)
  ip->ip_dst = htonl(dst);
    8000570e:	fb842783          	lw	a5,-72(s0)
          ((val & 0xff00U) >> 8));
}

static inline uint32 bswapl(uint32 val)
{
  return (((val & 0x000000ffUL) << 24) |
    80005712:	0187971b          	slliw	a4,a5,0x18
          ((val & 0x0000ff00UL) << 8) |
          ((val & 0x00ff0000UL) >> 8) |
          ((val & 0xff000000UL) >> 24));
    80005716:	0187d69b          	srliw	a3,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    8000571a:	8f55                	or	a4,a4,a3
          ((val & 0x0000ff00UL) << 8) |
    8000571c:	0087969b          	slliw	a3,a5,0x8
    80005720:	00ff0637          	lui	a2,0xff0
    80005724:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80005726:	8f55                	or	a4,a4,a3
    80005728:	0087d79b          	srliw	a5,a5,0x8
    8000572c:	66c1                	lui	a3,0x10
    8000572e:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80005732:	8ff5                	and	a5,a5,a3
    80005734:	8fd9                	or	a5,a5,a4
    80005736:	00f4af23          	sw	a5,30(s1)
  ip->ip_sum = in_cksum((unsigned char *)ip, sizeof(*ip));
    8000573a:	45d1                	li	a1,20
    8000573c:	00e48513          	addi	a0,s1,14
    80005740:	a81ff0ef          	jal	800051c0 <in_cksum>
    80005744:	00a49c23          	sh	a0,24(s1)
  udp->sport = htons(sport);
    80005748:	fbc42783          	lw	a5,-68(s0)
  return (((val & 0x00ffU) << 8) |
    8000574c:	0087971b          	slliw	a4,a5,0x8
    80005750:	0107979b          	slliw	a5,a5,0x10
    80005754:	0107d79b          	srliw	a5,a5,0x10
    80005758:	0087d79b          	srliw	a5,a5,0x8
    8000575c:	8fd9                	or	a5,a5,a4
    8000575e:	02f49123          	sh	a5,34(s1)
  udp->dport = htons(dport);
    80005762:	fb442783          	lw	a5,-76(s0)
    80005766:	0087971b          	slliw	a4,a5,0x8
    8000576a:	0107979b          	slliw	a5,a5,0x10
    8000576e:	0107d79b          	srliw	a5,a5,0x10
    80005772:	0087d79b          	srliw	a5,a5,0x8
    80005776:	8fd9                	or	a5,a5,a4
    80005778:	02f49223          	sh	a5,36(s1)
  udp->ulen = htons(len + sizeof(struct udp));
    8000577c:	2921                	addiw	s2,s2,8
    8000577e:	0089179b          	slliw	a5,s2,0x8
    80005782:	0109191b          	slliw	s2,s2,0x10
    80005786:	0109591b          	srliw	s2,s2,0x10
    8000578a:	0089591b          	srliw	s2,s2,0x8
    8000578e:	0127e7b3          	or	a5,a5,s2
    80005792:	02f49323          	sh	a5,38(s1)
  if(copyin(p->pagetable, payload, bufaddr, len) < 0){
    80005796:	86d6                	mv	a3,s5
    80005798:	fa843603          	ld	a2,-88(s0)
    8000579c:	02a48593          	addi	a1,s1,42
    800057a0:	050a3503          	ld	a0,80(s4)
    800057a4:	c2efb0ef          	jal	80000bd2 <copyin>
    800057a8:	02054963          	bltz	a0,800057da <sys_send+0x1b6>
  e1000_transmit(buf, total);
    800057ac:	85ce                	mv	a1,s3
    800057ae:	8526                	mv	a0,s1
    800057b0:	84fff0ef          	jal	80004ffe <e1000_transmit>
  return 0;
    800057b4:	4501                	li	a0,0
    800057b6:	64a6                	ld	s1,72(sp)
    800057b8:	6906                	ld	s2,64(sp)
    800057ba:	7aa2                	ld	s5,40(sp)
}
    800057bc:	60e6                	ld	ra,88(sp)
    800057be:	6446                	ld	s0,80(sp)
    800057c0:	79e2                	ld	s3,56(sp)
    800057c2:	7a42                	ld	s4,48(sp)
    800057c4:	6125                	addi	sp,sp,96
    800057c6:	8082                	ret
    printf("sys_send: kalloc failed\n");
    800057c8:	00003517          	auipc	a0,0x3
    800057cc:	f1850513          	addi	a0,a0,-232 # 800086e0 <etext+0x6e0>
    800057d0:	335000ef          	jal	80006304 <printf>
    return -1;
    800057d4:	557d                	li	a0,-1
    800057d6:	64a6                	ld	s1,72(sp)
    800057d8:	b7d5                	j	800057bc <sys_send+0x198>
    kfree(buf);
    800057da:	8526                	mv	a0,s1
    800057dc:	841fa0ef          	jal	8000001c <kfree>
    printf("send: copyin failed\n");
    800057e0:	00003517          	auipc	a0,0x3
    800057e4:	f2050513          	addi	a0,a0,-224 # 80008700 <etext+0x700>
    800057e8:	31d000ef          	jal	80006304 <printf>
    return -1;
    800057ec:	557d                	li	a0,-1
    800057ee:	64a6                	ld	s1,72(sp)
    800057f0:	6906                	ld	s2,64(sp)
    800057f2:	7aa2                	ld	s5,40(sp)
    800057f4:	b7e1                	j	800057bc <sys_send+0x198>

00000000800057f6 <icmp_rx>:

// *ICMP*
void
icmp_rx(char *buf, int len)
{
    800057f6:	7139                	addi	sp,sp,-64
    800057f8:	fc06                	sd	ra,56(sp)
    800057fa:	f822                	sd	s0,48(sp)
    800057fc:	f426                	sd	s1,40(sp)
    800057fe:	0080                	addi	s0,sp,64
    80005800:	84aa                	mv	s1,a0
  struct eth *eth = (struct eth *)buf;
  struct ip *ip = (struct ip *)(eth + 1);
  int ip_hlen = (ip->ip_vhl & 0x0f) * 4;
    80005802:	00e54783          	lbu	a5,14(a0)
    80005806:	078a                	slli	a5,a5,0x2
  
  if (len < sizeof(struct eth) + ip_hlen + 8) {
    80005808:	03c7f793          	andi	a5,a5,60
    8000580c:	01678713          	addi	a4,a5,22
    80005810:	04e5e963          	bltu	a1,a4,80005862 <icmp_rx+0x6c>
  }

  struct icmp *icmp = (struct icmp *)((char *)ip + ip_hlen);
  int success = 0;

  switch(icmp->type) {
    80005814:	97aa                	add	a5,a5,a0
    80005816:	00e7c583          	lbu	a1,14(a5)
    8000581a:	47a1                	li	a5,8
    8000581c:	06f58b63          	beq	a1,a5,80005892 <icmp_rx+0x9c>
    80005820:	04b7eb63          	bltu	a5,a1,80005876 <icmp_rx+0x80>
    80005824:	478d                	li	a5,3
    80005826:	12f58163          	beq	a1,a5,80005948 <icmp_rx+0x152>
    8000582a:	4791                	li	a5,4
    8000582c:	14f59663          	bne	a1,a5,80005978 <icmp_rx+0x182>
      else
        printf("icmp_rx: TTL EXPIRED ignored\n");
      break;

    case ICMP_QUENCH:
      success = notify_socket_error(buf);
    80005830:	9fdff0ef          	jal	8000522c <notify_socket_error>
      printf("icmp_rx: SOURCE QUENCH received (throttling: %s)\n", success ? "OK" : "IGNORED");
    80005834:	00003597          	auipc	a1,0x3
    80005838:	eec58593          	addi	a1,a1,-276 # 80008720 <etext+0x720>
    8000583c:	c509                	beqz	a0,80005846 <icmp_rx+0x50>
    8000583e:	00003597          	auipc	a1,0x3
    80005842:	eda58593          	addi	a1,a1,-294 # 80008718 <etext+0x718>
    80005846:	00003517          	auipc	a0,0x3
    8000584a:	01250513          	addi	a0,a0,18 # 80008858 <etext+0x858>
    8000584e:	2b7000ef          	jal	80006304 <printf>
    default:
      printf("icmp_rx: unhandled type %d - dropping\n", icmp->type);
      break;
  }

  kfree(buf);
    80005852:	8526                	mv	a0,s1
    80005854:	fc8fa0ef          	jal	8000001c <kfree>
}
    80005858:	70e2                	ld	ra,56(sp)
    8000585a:	7442                	ld	s0,48(sp)
    8000585c:	74a2                	ld	s1,40(sp)
    8000585e:	6121                	addi	sp,sp,64
    80005860:	8082                	ret
    printf("icmp_rx: packet too short (%d bytes), dropping\n", len);
    80005862:	00003517          	auipc	a0,0x3
    80005866:	ec650513          	addi	a0,a0,-314 # 80008728 <etext+0x728>
    8000586a:	29b000ef          	jal	80006304 <printf>
    kfree(buf);
    8000586e:	8526                	mv	a0,s1
    80005870:	facfa0ef          	jal	8000001c <kfree>
    return;
    80005874:	b7d5                	j	80005858 <icmp_rx+0x62>
  switch(icmp->type) {
    80005876:	47ad                	li	a5,11
    80005878:	10f59063          	bne	a1,a5,80005978 <icmp_rx+0x182>
      success = notify_socket_error(buf);
    8000587c:	9b1ff0ef          	jal	8000522c <notify_socket_error>
      if(success)
    80005880:	0e050563          	beqz	a0,8000596a <icmp_rx+0x174>
        printf("icmp_rx: TTL EXPIRED handled (notified port)\n");
    80005884:	00003517          	auipc	a0,0x3
    80005888:	f8450513          	addi	a0,a0,-124 # 80008808 <etext+0x808>
    8000588c:	279000ef          	jal	80006304 <printf>
    80005890:	b7c9                	j	80005852 <icmp_rx+0x5c>
    80005892:	f04a                	sd	s2,32(sp)
    80005894:	ec4e                	sd	s3,24(sp)
    80005896:	e852                	sd	s4,16(sp)
      printf("icmp_rx: ECHO REQUEST received -> sending reply\n");
    80005898:	00003517          	auipc	a0,0x3
    8000589c:	ec050513          	addi	a0,a0,-320 # 80008758 <etext+0x758>
    800058a0:	265000ef          	jal	80006304 <printf>
  int ip_hlen = (ip->ip_vhl & 0x0f) * 4;
    800058a4:	00e4c983          	lbu	s3,14(s1)
    800058a8:	00f9f993          	andi	s3,s3,15
    800058ac:	0029999b          	slliw	s3,s3,0x2
  struct icmp *icmp = (struct icmp *)((char *)ip + ip_hlen);
    800058b0:	00e9891b          	addiw	s2,s3,14
    800058b4:	2901                	sext.w	s2,s2
    800058b6:	9926                	add	s2,s2,s1
  memmove(tmp_mac, eth->shost, ETHADDR_LEN);
    800058b8:	00648a13          	addi	s4,s1,6
    800058bc:	4619                	li	a2,6
    800058be:	85d2                	mv	a1,s4
    800058c0:	fc840513          	addi	a0,s0,-56
    800058c4:	8e7fa0ef          	jal	800001aa <memmove>
  memmove(eth->shost, eth->dhost, ETHADDR_LEN);
    800058c8:	4619                	li	a2,6
    800058ca:	85a6                	mv	a1,s1
    800058cc:	8552                	mv	a0,s4
    800058ce:	8ddfa0ef          	jal	800001aa <memmove>
  memmove(eth->dhost, tmp_mac, ETHADDR_LEN);
    800058d2:	4619                	li	a2,6
    800058d4:	fc840593          	addi	a1,s0,-56
    800058d8:	8526                	mv	a0,s1
    800058da:	8d1fa0ef          	jal	800001aa <memmove>
  uint32 tmp_ip = ip->ip_src;
    800058de:	01a4a783          	lw	a5,26(s1)
  ip->ip_src = ip->ip_dst;
    800058e2:	01e4a703          	lw	a4,30(s1)
    800058e6:	00e4ad23          	sw	a4,26(s1)
  ip->ip_dst = tmp_ip;
    800058ea:	00f4af23          	sw	a5,30(s1)
  icmp->type = ICMP_ECHO_REPLY;
    800058ee:	00090023          	sb	zero,0(s2)
  icmp->checksum = 0;
    800058f2:	00090123          	sb	zero,2(s2)
    800058f6:	000901a3          	sb	zero,3(s2)
    800058fa:	0104d783          	lhu	a5,16(s1)
    800058fe:	0087971b          	slliw	a4,a5,0x8
    80005902:	0087d593          	srli	a1,a5,0x8
    80005906:	8dd9                	or	a1,a1,a4
  int icmp_len = ntohs(ip->ip_len) - ip_hlen;
    80005908:	0105959b          	slliw	a1,a1,0x10
    8000590c:	0105d59b          	srliw	a1,a1,0x10
  icmp->checksum = in_cksum((unsigned char *)icmp, icmp_len);
    80005910:	413585bb          	subw	a1,a1,s3
    80005914:	854a                	mv	a0,s2
    80005916:	8abff0ef          	jal	800051c0 <in_cksum>
    8000591a:	00a90123          	sb	a0,2(s2)
    8000591e:	0085551b          	srliw	a0,a0,0x8
    80005922:	00a901a3          	sb	a0,3(s2)
    80005926:	0104d783          	lhu	a5,16(s1)
    8000592a:	0087971b          	slliw	a4,a5,0x8
    8000592e:	0087d593          	srli	a1,a5,0x8
    80005932:	8dd9                	or	a1,a1,a4
  e1000_transmit(buf, sizeof(struct eth) + ntohs(ip->ip_len));
    80005934:	15c2                	slli	a1,a1,0x30
    80005936:	91c1                	srli	a1,a1,0x30
    80005938:	05b9                	addi	a1,a1,14
    8000593a:	8526                	mv	a0,s1
    8000593c:	ec2ff0ef          	jal	80004ffe <e1000_transmit>
}
    80005940:	7902                	ld	s2,32(sp)
    80005942:	69e2                	ld	s3,24(sp)
    80005944:	6a42                	ld	s4,16(sp)
    80005946:	bf09                	j	80005858 <icmp_rx+0x62>
      success = notify_socket_error(buf);
    80005948:	8e5ff0ef          	jal	8000522c <notify_socket_error>
      if(success)
    8000594c:	c901                	beqz	a0,8000595c <icmp_rx+0x166>
        printf("icmp_rx: DEST UNREACHABLE handled (notified port)\n");
    8000594e:	00003517          	auipc	a0,0x3
    80005952:	e4250513          	addi	a0,a0,-446 # 80008790 <etext+0x790>
    80005956:	1af000ef          	jal	80006304 <printf>
    8000595a:	bde5                	j	80005852 <icmp_rx+0x5c>
        printf("icmp_rx: DEST UNREACHABLE ignored (no bound port found)\n");
    8000595c:	00003517          	auipc	a0,0x3
    80005960:	e6c50513          	addi	a0,a0,-404 # 800087c8 <etext+0x7c8>
    80005964:	1a1000ef          	jal	80006304 <printf>
    80005968:	b5ed                	j	80005852 <icmp_rx+0x5c>
        printf("icmp_rx: TTL EXPIRED ignored\n");
    8000596a:	00003517          	auipc	a0,0x3
    8000596e:	ece50513          	addi	a0,a0,-306 # 80008838 <etext+0x838>
    80005972:	193000ef          	jal	80006304 <printf>
    80005976:	bdf1                	j	80005852 <icmp_rx+0x5c>
      printf("icmp_rx: unhandled type %d - dropping\n", icmp->type);
    80005978:	00003517          	auipc	a0,0x3
    8000597c:	f1850513          	addi	a0,a0,-232 # 80008890 <etext+0x890>
    80005980:	185000ef          	jal	80006304 <printf>
      break;
    80005984:	b5f9                	j	80005852 <icmp_rx+0x5c>

0000000080005986 <ip_rx>:

void
ip_rx(char *buf, int len)
{
    80005986:	715d                	addi	sp,sp,-80
    80005988:	e486                	sd	ra,72(sp)
    8000598a:	e0a2                	sd	s0,64(sp)
    8000598c:	fc26                	sd	s1,56(sp)
    8000598e:	f84a                	sd	s2,48(sp)
    80005990:	0880                	addi	s0,sp,80
    80005992:	84aa                	mv	s1,a0
    80005994:	892e                	mv	s2,a1
  static int seen_ip = 0;
  if(seen_ip == 0)
    80005996:	00006797          	auipc	a5,0x6
    8000599a:	f967a783          	lw	a5,-106(a5) # 8000b92c <seen_ip.1>
    8000599e:	16078363          	beqz	a5,80005b04 <ip_rx+0x17e>
    printf("ip_rx: received an IP packet\n");
  seen_ip = 1;
    800059a2:	4785                	li	a5,1
    800059a4:	00006717          	auipc	a4,0x6
    800059a8:	f8f72423          	sw	a5,-120(a4) # 8000b92c <seen_ip.1>

  if(len < sizeof(struct eth) + sizeof(struct ip)){
    800059ac:	0009079b          	sext.w	a5,s2
    800059b0:	02100713          	li	a4,33
    800059b4:	14f77f63          	bgeu	a4,a5,80005b12 <ip_rx+0x18c>

  struct eth *eth = (struct eth *)buf;
  struct ip *ip = (struct ip *)(eth + 1);

  // handle ICMP errorz
  if(ip->ip_p == IPPROTO_ICMP){
    800059b8:	0174c783          	lbu	a5,23(s1)
    800059bc:	4705                	li	a4,1
    800059be:	14e78e63          	beq	a5,a4,80005b1a <ip_rx+0x194>
    icmp_rx(buf, len); // Call the *ICMP* function
    return;
  }

  // drop non-udp packets
  if(ip->ip_p != IPPROTO_UDP){
    800059c2:	4745                	li	a4,17
    800059c4:	16e79663          	bne	a5,a4,80005b30 <ip_rx+0x1aa>
    kfree(buf);
    return;
  }

  int ip_hlen = (ip->ip_vhl & 0x0f) * 4;
    800059c8:	00e4c783          	lbu	a5,14(s1)
    800059cc:	078a                	slli	a5,a5,0x2
    800059ce:	03c7f793          	andi	a5,a5,60
  if(ip_hlen < 20){
    800059d2:	474d                	li	a4,19
    800059d4:	16f75763          	bge	a4,a5,80005b42 <ip_rx+0x1bc>
    kfree(buf);
    return;
  }

  if(len < sizeof(struct eth) + ip_hlen + sizeof(struct udp)){
    800059d8:	01678713          	addi	a4,a5,22
    800059dc:	16e96763          	bltu	s2,a4,80005b4a <ip_rx+0x1c4>
    800059e0:	e45e                	sd	s7,8(sp)
    kfree(buf);
    return;
  }

  struct udp *udp = (struct udp *)((char *)ip + ip_hlen);
    800059e2:	07b9                	addi	a5,a5,14
    800059e4:	00f48933          	add	s2,s1,a5
    800059e8:	00295783          	lhu	a5,2(s2)
    800059ec:	0087971b          	slliw	a4,a5,0x8
    800059f0:	83a1                	srli	a5,a5,0x8
    800059f2:	8fd9                	or	a5,a5,a4
    800059f4:	17c2                	slli	a5,a5,0x30
    800059f6:	93c1                	srli	a5,a5,0x30

  uint16 dport = ntohs(udp->dport);
  uint16 sport = ntohs(udp->sport);
    800059f8:	00095b83          	lhu	s7,0(s2)

  if(dport >= NUDPPORT){
    800059fc:	0007869b          	sext.w	a3,a5
    80005a00:	03f00713          	li	a4,63
    80005a04:	14d76763          	bltu	a4,a3,80005b52 <ip_rx+0x1cc>
    80005a08:	f44e                	sd	s3,40(sp)
    80005a0a:	f052                	sd	s4,32(sp)
    80005a0c:	ec56                	sd	s5,24(sp)
    80005a0e:	e85a                	sd	s6,16(sp)
    80005a10:	e062                	sd	s8,0(sp)
    kfree(buf);
    return;
  }

  struct udp_queue *q = &udp_ports[dport];
    80005a12:	00078a9b          	sext.w	s5,a5
    80005a16:	6a09                	lui	s4,0x2
    80005a18:	0e8a0a13          	addi	s4,s4,232 # 20e8 <_entry-0x7fffdf18>
    80005a1c:	034789b3          	mul	s3,a5,s4
    80005a20:	00017c17          	auipc	s8,0x17
    80005a24:	408c0c13          	addi	s8,s8,1032 # 8001ce28 <udp_ports>
    80005a28:	01898b33          	add	s6,s3,s8

  acquire(&q->lock);
    80005a2c:	855a                	mv	a0,s6
    80005a2e:	679000ef          	jal	800068a6 <acquire>

  if(q->bound == 0){
    80005a32:	034a8a33          	mul	s4,s5,s4
    80005a36:	9c52                	add	s8,s8,s4
    80005a38:	018c2783          	lw	a5,24(s8)
    80005a3c:	12078063          	beqz	a5,80005b5c <ip_rx+0x1d6>
    release(&q->lock);
    kfree(buf);
    return;
  }

  if(q->w - q->r >= UDPQSIZE){
    80005a40:	6789                	lui	a5,0x2
    80005a42:	0e878793          	addi	a5,a5,232 # 20e8 <_entry-0x7fffdf18>
    80005a46:	02fa87b3          	mul	a5,s5,a5
    80005a4a:	00017717          	auipc	a4,0x17
    80005a4e:	3de70713          	addi	a4,a4,990 # 8001ce28 <udp_ports>
    80005a52:	97ba                	add	a5,a5,a4
    80005a54:	6709                	lui	a4,0x2
    80005a56:	973e                	add	a4,a4,a5
    80005a58:	0e072783          	lw	a5,224(a4) # 20e0 <_entry-0x7fffdf20>
    80005a5c:	0dc72703          	lw	a4,220(a4)
    80005a60:	40e7873b          	subw	a4,a5,a4
    80005a64:	46bd                	li	a3,15
    80005a66:	10e6c863          	blt	a3,a4,80005b76 <ip_rx+0x1f0>
    release(&q->lock);
    kfree(buf);
    return;
  }

  struct udp_packet *p = &q->pkts[q->w % UDPQSIZE];
    80005a6a:	41f7d69b          	sraiw	a3,a5,0x1f
    80005a6e:	01c6d69b          	srliw	a3,a3,0x1c
    80005a72:	00f6873b          	addw	a4,a3,a5
    80005a76:	8b3d                	andi	a4,a4,15
    80005a78:	9f15                	subw	a4,a4,a3

  p->src = ntohl(ip->ip_src);
    80005a7a:	01a4a783          	lw	a5,26(s1)
    80005a7e:	20c00693          	li	a3,524
    80005a82:	02d706b3          	mul	a3,a4,a3
    80005a86:	6609                	lui	a2,0x2
    80005a88:	0e860613          	addi	a2,a2,232 # 20e8 <_entry-0x7fffdf18>
    80005a8c:	02ca8633          	mul	a2,s5,a2
    80005a90:	96b2                	add	a3,a3,a2
    80005a92:	00017617          	auipc	a2,0x17
    80005a96:	39660613          	addi	a2,a2,918 # 8001ce28 <udp_ports>
    80005a9a:	9636                	add	a2,a2,a3
  return (((val & 0x000000ffUL) << 24) |
    80005a9c:	0187969b          	slliw	a3,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80005aa0:	0187d59b          	srliw	a1,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005aa4:	8ecd                	or	a3,a3,a1
          ((val & 0x0000ff00UL) << 8) |
    80005aa6:	0087959b          	slliw	a1,a5,0x8
    80005aaa:	00ff0537          	lui	a0,0xff0
    80005aae:	8de9                	and	a1,a1,a0
          ((val & 0x00ff0000UL) >> 8) |
    80005ab0:	8ecd                	or	a3,a3,a1
    80005ab2:	0087d79b          	srliw	a5,a5,0x8
    80005ab6:	65c1                	lui	a1,0x10
    80005ab8:	f0058593          	addi	a1,a1,-256 # ff00 <_entry-0x7fff0100>
    80005abc:	8fed                	and	a5,a5,a1
    80005abe:	8fd5                	or	a5,a5,a3
    80005ac0:	ce5c                	sw	a5,28(a2)
  return (((val & 0x00ffU) << 8) |
    80005ac2:	008b979b          	slliw	a5,s7,0x8
    80005ac6:	008bdb9b          	srliw	s7,s7,0x8
    80005aca:	0177e7b3          	or	a5,a5,s7
  p->sport = sport;
    80005ace:	02f61023          	sh	a5,32(a2)
    80005ad2:	00495783          	lhu	a5,4(s2)
    80005ad6:	0087969b          	slliw	a3,a5,0x8
    80005ada:	0087da13          	srli	s4,a5,0x8
    80005ade:	00da6a33          	or	s4,s4,a3

  int plen = ntohs(udp->ulen) - sizeof(struct udp);
    80005ae2:	010a1a1b          	slliw	s4,s4,0x10
    80005ae6:	010a5a1b          	srliw	s4,s4,0x10
    80005aea:	3a61                	addiw	s4,s4,-8
    80005aec:	000a079b          	sext.w	a5,s4
    80005af0:	8a3e                	mv	s4,a5
  if(plen < 0) plen = 0;
    80005af2:	0807cf63          	bltz	a5,80005b90 <ip_rx+0x20a>
  if(plen > sizeof(p->data)) plen = sizeof(p->data);
    80005af6:	20000693          	li	a3,512
    80005afa:	08f6fc63          	bgeu	a3,a5,80005b92 <ip_rx+0x20c>
    80005afe:	20000a13          	li	s4,512
    80005b02:	a841                	j	80005b92 <ip_rx+0x20c>
    printf("ip_rx: received an IP packet\n");
    80005b04:	00003517          	auipc	a0,0x3
    80005b08:	db450513          	addi	a0,a0,-588 # 800088b8 <etext+0x8b8>
    80005b0c:	7f8000ef          	jal	80006304 <printf>
    80005b10:	bd49                	j	800059a2 <ip_rx+0x1c>
    kfree(buf);
    80005b12:	8526                	mv	a0,s1
    80005b14:	d08fa0ef          	jal	8000001c <kfree>
    return;
    80005b18:	a839                	j	80005b36 <ip_rx+0x1b0>
    printf("ip_rx: detected ICMP packet!\n");
    80005b1a:	00003517          	auipc	a0,0x3
    80005b1e:	dbe50513          	addi	a0,a0,-578 # 800088d8 <etext+0x8d8>
    80005b22:	7e2000ef          	jal	80006304 <printf>
    icmp_rx(buf, len); // Call the *ICMP* function
    80005b26:	85ca                	mv	a1,s2
    80005b28:	8526                	mv	a0,s1
    80005b2a:	ccdff0ef          	jal	800057f6 <icmp_rx>
    return;
    80005b2e:	a021                	j	80005b36 <ip_rx+0x1b0>
    kfree(buf);
    80005b30:	8526                	mv	a0,s1
    80005b32:	ceafa0ef          	jal	8000001c <kfree>
  wakeup(q);

  release(&q->lock);

  kfree(buf);
}
    80005b36:	60a6                	ld	ra,72(sp)
    80005b38:	6406                	ld	s0,64(sp)
    80005b3a:	74e2                	ld	s1,56(sp)
    80005b3c:	7942                	ld	s2,48(sp)
    80005b3e:	6161                	addi	sp,sp,80
    80005b40:	8082                	ret
    kfree(buf);
    80005b42:	8526                	mv	a0,s1
    80005b44:	cd8fa0ef          	jal	8000001c <kfree>
    return;
    80005b48:	b7fd                	j	80005b36 <ip_rx+0x1b0>
    kfree(buf);
    80005b4a:	8526                	mv	a0,s1
    80005b4c:	cd0fa0ef          	jal	8000001c <kfree>
    return;
    80005b50:	b7dd                	j	80005b36 <ip_rx+0x1b0>
    kfree(buf);
    80005b52:	8526                	mv	a0,s1
    80005b54:	cc8fa0ef          	jal	8000001c <kfree>
    return;
    80005b58:	6ba2                	ld	s7,8(sp)
    80005b5a:	bff1                	j	80005b36 <ip_rx+0x1b0>
    release(&q->lock);
    80005b5c:	855a                	mv	a0,s6
    80005b5e:	5e1000ef          	jal	8000693e <release>
    kfree(buf);
    80005b62:	8526                	mv	a0,s1
    80005b64:	cb8fa0ef          	jal	8000001c <kfree>
    return;
    80005b68:	79a2                	ld	s3,40(sp)
    80005b6a:	7a02                	ld	s4,32(sp)
    80005b6c:	6ae2                	ld	s5,24(sp)
    80005b6e:	6b42                	ld	s6,16(sp)
    80005b70:	6ba2                	ld	s7,8(sp)
    80005b72:	6c02                	ld	s8,0(sp)
    80005b74:	b7c9                	j	80005b36 <ip_rx+0x1b0>
    release(&q->lock);
    80005b76:	855a                	mv	a0,s6
    80005b78:	5c7000ef          	jal	8000693e <release>
    kfree(buf);
    80005b7c:	8526                	mv	a0,s1
    80005b7e:	c9efa0ef          	jal	8000001c <kfree>
    return;
    80005b82:	79a2                	ld	s3,40(sp)
    80005b84:	7a02                	ld	s4,32(sp)
    80005b86:	6ae2                	ld	s5,24(sp)
    80005b88:	6b42                	ld	s6,16(sp)
    80005b8a:	6ba2                	ld	s7,8(sp)
    80005b8c:	6c02                	ld	s8,0(sp)
    80005b8e:	b765                	j	80005b36 <ip_rx+0x1b0>
  if(plen < 0) plen = 0;
    80005b90:	4a01                	li	s4,0
  memmove(p->data, (char *)(udp + 1), plen);
    80005b92:	20c00b93          	li	s7,524
    80005b96:	03770bb3          	mul	s7,a4,s7
    80005b9a:	02898793          	addi	a5,s3,40
    80005b9e:	00fb8533          	add	a0,s7,a5
    80005ba2:	00017997          	auipc	s3,0x17
    80005ba6:	28698993          	addi	s3,s3,646 # 8001ce28 <udp_ports>
    80005baa:	8652                	mv	a2,s4
    80005bac:	00890593          	addi	a1,s2,8
    80005bb0:	954e                	add	a0,a0,s3
    80005bb2:	df8fa0ef          	jal	800001aa <memmove>
  p->len = plen;
    80005bb6:	6789                	lui	a5,0x2
    80005bb8:	0e878793          	addi	a5,a5,232 # 20e8 <_entry-0x7fffdf18>
    80005bbc:	02fa8ab3          	mul	s5,s5,a5
    80005bc0:	9bd6                	add	s7,s7,s5
    80005bc2:	9bce                	add	s7,s7,s3
    80005bc4:	034ba223          	sw	s4,36(s7) # fffffffffffff024 <end+0xffffffff7ff5671c>
  q->w++;
    80005bc8:	99d6                	add	s3,s3,s5
    80005bca:	6789                	lui	a5,0x2
    80005bcc:	97ce                	add	a5,a5,s3
    80005bce:	0e07a703          	lw	a4,224(a5) # 20e0 <_entry-0x7fffdf20>
    80005bd2:	2705                	addiw	a4,a4,1
    80005bd4:	0ee7a023          	sw	a4,224(a5)
  wakeup(q);
    80005bd8:	855a                	mv	a0,s6
    80005bda:	841fb0ef          	jal	8000141a <wakeup>
  release(&q->lock);
    80005bde:	855a                	mv	a0,s6
    80005be0:	55f000ef          	jal	8000693e <release>
  kfree(buf);
    80005be4:	8526                	mv	a0,s1
    80005be6:	c36fa0ef          	jal	8000001c <kfree>
    80005bea:	79a2                	ld	s3,40(sp)
    80005bec:	7a02                	ld	s4,32(sp)
    80005bee:	6ae2                	ld	s5,24(sp)
    80005bf0:	6b42                	ld	s6,16(sp)
    80005bf2:	6ba2                	ld	s7,8(sp)
    80005bf4:	6c02                	ld	s8,0(sp)
    80005bf6:	b781                	j	80005b36 <ip_rx+0x1b0>

0000000080005bf8 <arp_rx>:
// qemu to send IP packets to xv6; the real ARP
// protocol is more complex.
//
void
arp_rx(char *inbuf)
{
    80005bf8:	7179                	addi	sp,sp,-48
    80005bfa:	f406                	sd	ra,40(sp)
    80005bfc:	f022                	sd	s0,32(sp)
    80005bfe:	e84a                	sd	s2,16(sp)
    80005c00:	1800                	addi	s0,sp,48
    80005c02:	892a                	mv	s2,a0
  static int seen_arp = 0;

  if(seen_arp){
    80005c04:	00006797          	auipc	a5,0x6
    80005c08:	d247a783          	lw	a5,-732(a5) # 8000b928 <seen_arp.0>
    80005c0c:	10079263          	bnez	a5,80005d10 <arp_rx+0x118>
    80005c10:	ec26                	sd	s1,24(sp)
    80005c12:	e44e                	sd	s3,8(sp)
    80005c14:	e052                	sd	s4,0(sp)
    kfree(inbuf);
    return;
  }
  printf("arp_rx: received an ARP packet\n");
    80005c16:	00003517          	auipc	a0,0x3
    80005c1a:	ce250513          	addi	a0,a0,-798 # 800088f8 <etext+0x8f8>
    80005c1e:	6e6000ef          	jal	80006304 <printf>
  seen_arp = 1;
    80005c22:	4785                	li	a5,1
    80005c24:	00006717          	auipc	a4,0x6
    80005c28:	d0f72223          	sw	a5,-764(a4) # 8000b928 <seen_arp.0>

  struct eth *ineth = (struct eth *) inbuf;
  struct arp *inarp = (struct arp *) (ineth + 1);

  char *buf = kalloc();
    80005c2c:	cd2fa0ef          	jal	800000fe <kalloc>
    80005c30:	84aa                	mv	s1,a0
  if(buf == 0)
    80005c32:	0e050263          	beqz	a0,80005d16 <arp_rx+0x11e>
    panic("send_arp_reply");
  
  struct eth *eth = (struct eth *) buf;
  memmove(eth->dhost, ineth->shost, ETHADDR_LEN); // ethernet destination = query source
    80005c36:	00690993          	addi	s3,s2,6
    80005c3a:	4619                	li	a2,6
    80005c3c:	85ce                	mv	a1,s3
    80005c3e:	d6cfa0ef          	jal	800001aa <memmove>
  memmove(eth->shost, local_mac, ETHADDR_LEN); // ethernet source = xv6's ethernet address
    80005c42:	4619                	li	a2,6
    80005c44:	00006597          	auipc	a1,0x6
    80005c48:	c8c58593          	addi	a1,a1,-884 # 8000b8d0 <local_mac>
    80005c4c:	00648513          	addi	a0,s1,6
    80005c50:	d5afa0ef          	jal	800001aa <memmove>
  eth->type = htons(ETHTYPE_ARP);
    80005c54:	47a1                	li	a5,8
    80005c56:	00f48623          	sb	a5,12(s1)
    80005c5a:	4719                	li	a4,6
    80005c5c:	00e486a3          	sb	a4,13(s1)

  struct arp *arp = (struct arp *)(eth + 1);
  arp->hrd = htons(ARP_HRD_ETHER);
    80005c60:	00048723          	sb	zero,14(s1)
    80005c64:	4705                	li	a4,1
    80005c66:	00e487a3          	sb	a4,15(s1)
  arp->pro = htons(ETHTYPE_IP);
    80005c6a:	00f48823          	sb	a5,16(s1)
    80005c6e:	000488a3          	sb	zero,17(s1)
  arp->hln = ETHADDR_LEN;
    80005c72:	4799                	li	a5,6
    80005c74:	00f48923          	sb	a5,18(s1)
  arp->pln = sizeof(uint32);
    80005c78:	4791                	li	a5,4
    80005c7a:	00f489a3          	sb	a5,19(s1)
  arp->op = htons(ARP_OP_REPLY);
    80005c7e:	00048a23          	sb	zero,20(s1)
    80005c82:	4a09                	li	s4,2
    80005c84:	01448aa3          	sb	s4,21(s1)

  memmove(arp->sha, local_mac, ETHADDR_LEN);
    80005c88:	4619                	li	a2,6
    80005c8a:	00006597          	auipc	a1,0x6
    80005c8e:	c4658593          	addi	a1,a1,-954 # 8000b8d0 <local_mac>
    80005c92:	01648513          	addi	a0,s1,22
    80005c96:	d14fa0ef          	jal	800001aa <memmove>
  arp->sip = htonl(local_ip);
    80005c9a:	47a9                	li	a5,10
    80005c9c:	00f48e23          	sb	a5,28(s1)
    80005ca0:	00048ea3          	sb	zero,29(s1)
    80005ca4:	01448f23          	sb	s4,30(s1)
    80005ca8:	47bd                	li	a5,15
    80005caa:	00f48fa3          	sb	a5,31(s1)
  memmove(arp->tha, ineth->shost, ETHADDR_LEN);
    80005cae:	4619                	li	a2,6
    80005cb0:	85ce                	mv	a1,s3
    80005cb2:	02048513          	addi	a0,s1,32
    80005cb6:	cf4fa0ef          	jal	800001aa <memmove>
  arp->tip = inarp->sip;
    80005cba:	01c94703          	lbu	a4,28(s2)
    80005cbe:	01d94783          	lbu	a5,29(s2)
    80005cc2:	07a2                	slli	a5,a5,0x8
    80005cc4:	8fd9                	or	a5,a5,a4
    80005cc6:	01e94703          	lbu	a4,30(s2)
    80005cca:	0742                	slli	a4,a4,0x10
    80005ccc:	8f5d                	or	a4,a4,a5
    80005cce:	01f94783          	lbu	a5,31(s2)
    80005cd2:	07e2                	slli	a5,a5,0x18
    80005cd4:	8fd9                	or	a5,a5,a4
    80005cd6:	02f48323          	sb	a5,38(s1)
    80005cda:	0087d713          	srli	a4,a5,0x8
    80005cde:	02e483a3          	sb	a4,39(s1)
    80005ce2:	0107d713          	srli	a4,a5,0x10
    80005ce6:	02e48423          	sb	a4,40(s1)
    80005cea:	83e1                	srli	a5,a5,0x18
    80005cec:	02f484a3          	sb	a5,41(s1)

  e1000_transmit(buf, sizeof(*eth) + sizeof(*arp));
    80005cf0:	02a00593          	li	a1,42
    80005cf4:	8526                	mv	a0,s1
    80005cf6:	b08ff0ef          	jal	80004ffe <e1000_transmit>

  kfree(inbuf);
    80005cfa:	854a                	mv	a0,s2
    80005cfc:	b20fa0ef          	jal	8000001c <kfree>
    80005d00:	64e2                	ld	s1,24(sp)
    80005d02:	69a2                	ld	s3,8(sp)
    80005d04:	6a02                	ld	s4,0(sp)
}
    80005d06:	70a2                	ld	ra,40(sp)
    80005d08:	7402                	ld	s0,32(sp)
    80005d0a:	6942                	ld	s2,16(sp)
    80005d0c:	6145                	addi	sp,sp,48
    80005d0e:	8082                	ret
    kfree(inbuf);
    80005d10:	b0cfa0ef          	jal	8000001c <kfree>
    return;
    80005d14:	bfcd                	j	80005d06 <arp_rx+0x10e>
    panic("send_arp_reply");
    80005d16:	00003517          	auipc	a0,0x3
    80005d1a:	c0250513          	addi	a0,a0,-1022 # 80008918 <etext+0x918>
    80005d1e:	0cd000ef          	jal	800065ea <panic>

0000000080005d22 <net_rx>:

void
net_rx(char *buf, int len)
{
    80005d22:	1101                	addi	sp,sp,-32
    80005d24:	ec06                	sd	ra,24(sp)
    80005d26:	e822                	sd	s0,16(sp)
    80005d28:	e426                	sd	s1,8(sp)
    80005d2a:	e04a                	sd	s2,0(sp)
    80005d2c:	1000                	addi	s0,sp,32
    80005d2e:	84aa                	mv	s1,a0
    80005d30:	892e                	mv	s2,a1
  printf("net_rx: received packet len %d\n", len);
    80005d32:	00003517          	auipc	a0,0x3
    80005d36:	bf650513          	addi	a0,a0,-1034 # 80008928 <etext+0x928>
    80005d3a:	5ca000ef          	jal	80006304 <printf>
  struct eth *eth = (struct eth *) buf;

  if(len >= sizeof(struct eth) + sizeof(struct arp) &&
    80005d3e:	0009079b          	sext.w	a5,s2
    80005d42:	02900713          	li	a4,41
    80005d46:	04f77263          	bgeu	a4,a5,80005d8a <net_rx+0x68>
     ntohs(eth->type) == ETHTYPE_ARP){
    80005d4a:	00c4c703          	lbu	a4,12(s1)
    80005d4e:	00d4c783          	lbu	a5,13(s1)
    80005d52:	07a2                	slli	a5,a5,0x8
  if(len >= sizeof(struct eth) + sizeof(struct arp) &&
    80005d54:	8fd9                	or	a5,a5,a4
    80005d56:	60800713          	li	a4,1544
    80005d5a:	02e78463          	beq	a5,a4,80005d82 <net_rx+0x60>
    arp_rx(buf);
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
     ntohs(eth->type) == ETHTYPE_IP){
    80005d5e:	00c4c703          	lbu	a4,12(s1)
    80005d62:	00d4c783          	lbu	a5,13(s1)
    80005d66:	07a2                	slli	a5,a5,0x8
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
    80005d68:	8fd9                	or	a5,a5,a4
    80005d6a:	4721                	li	a4,8
    80005d6c:	02e78463          	beq	a5,a4,80005d94 <net_rx+0x72>
    ip_rx(buf, len);
  } else {
    kfree(buf);
    80005d70:	8526                	mv	a0,s1
    80005d72:	aaafa0ef          	jal	8000001c <kfree>
  }
}
    80005d76:	60e2                	ld	ra,24(sp)
    80005d78:	6442                	ld	s0,16(sp)
    80005d7a:	64a2                	ld	s1,8(sp)
    80005d7c:	6902                	ld	s2,0(sp)
    80005d7e:	6105                	addi	sp,sp,32
    80005d80:	8082                	ret
    arp_rx(buf);
    80005d82:	8526                	mv	a0,s1
    80005d84:	e75ff0ef          	jal	80005bf8 <arp_rx>
    80005d88:	b7fd                	j	80005d76 <net_rx+0x54>
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
    80005d8a:	02100713          	li	a4,33
    80005d8e:	fef771e3          	bgeu	a4,a5,80005d70 <net_rx+0x4e>
    80005d92:	b7f1                	j	80005d5e <net_rx+0x3c>
    ip_rx(buf, len);
    80005d94:	85ca                	mv	a1,s2
    80005d96:	8526                	mv	a0,s1
    80005d98:	befff0ef          	jal	80005986 <ip_rx>
    80005d9c:	bfe9                	j	80005d76 <net_rx+0x54>

0000000080005d9e <pci_init>:
#include "proc.h"
#include "defs.h"

void
pci_init()
{
    80005d9e:	715d                	addi	sp,sp,-80
    80005da0:	e486                	sd	ra,72(sp)
    80005da2:	e0a2                	sd	s0,64(sp)
    80005da4:	fc26                	sd	s1,56(sp)
    80005da6:	f84a                	sd	s2,48(sp)
    80005da8:	f44e                	sd	s3,40(sp)
    80005daa:	f052                	sd	s4,32(sp)
    80005dac:	ec56                	sd	s5,24(sp)
    80005dae:	e85a                	sd	s6,16(sp)
    80005db0:	e45e                	sd	s7,8(sp)
    80005db2:	0880                	addi	s0,sp,80
    80005db4:	300004b7          	lui	s1,0x30000
    uint32 off = (bus << 16) | (dev << 11) | (func << 8) | (offset);
    volatile uint32 *base = ecam + off;
    uint32 id = base[0];
    
    // 100e:8086 is an e1000
    if(id == 0x100e8086){
    80005db8:	100e8937          	lui	s2,0x100e8
    80005dbc:	08690913          	addi	s2,s2,134 # 100e8086 <_entry-0x6ff17f7a>
      // command and status register.
      // bit 0 : I/O access enable
      // bit 1 : memory access enable
      // bit 2 : enable mastering
      base[1] = 7;
    80005dc0:	4b9d                	li	s7,7
      for(int i = 0; i < 6; i++){
        uint32 old = base[4+i];

        // writing all 1's to the BAR causes it to be
        // replaced with its size.
        base[4+i] = 0xffffffff;
    80005dc2:	5afd                	li	s5,-1
        base[4+i] = old;
      }

      // tell the e1000 to reveal its registers at
      // physical address 0x40000000.
      base[4+0] = e1000_regs;
    80005dc4:	40000b37          	lui	s6,0x40000
  for(int dev = 0; dev < 32; dev++){
    80005dc8:	6a09                	lui	s4,0x2
    80005dca:	300409b7          	lui	s3,0x30040
    80005dce:	a809                	j	80005de0 <pci_init+0x42>
      base[4+0] = e1000_regs;
    80005dd0:	0166a823          	sw	s6,16(a3)

      e1000_init((uint32*)e1000_regs);
    80005dd4:	855a                	mv	a0,s6
    80005dd6:	8a6ff0ef          	jal	80004e7c <e1000_init>
  for(int dev = 0; dev < 32; dev++){
    80005dda:	94d2                	add	s1,s1,s4
    80005ddc:	03348a63          	beq	s1,s3,80005e10 <pci_init+0x72>
    volatile uint32 *base = ecam + off;
    80005de0:	86a6                	mv	a3,s1
    uint32 id = base[0];
    80005de2:	409c                	lw	a5,0(s1)
    80005de4:	2781                	sext.w	a5,a5
    if(id == 0x100e8086){
    80005de6:	ff279ae3          	bne	a5,s2,80005dda <pci_init+0x3c>
      base[1] = 7;
    80005dea:	0174a223          	sw	s7,4(s1) # 30000004 <_entry-0x4ffffffc>
      __sync_synchronize();
    80005dee:	0330000f          	fence	rw,rw
      for(int i = 0; i < 6; i++){
    80005df2:	01048793          	addi	a5,s1,16
    80005df6:	02848613          	addi	a2,s1,40
        uint32 old = base[4+i];
    80005dfa:	4398                	lw	a4,0(a5)
    80005dfc:	2701                	sext.w	a4,a4
        base[4+i] = 0xffffffff;
    80005dfe:	0157a023          	sw	s5,0(a5)
        __sync_synchronize();
    80005e02:	0330000f          	fence	rw,rw
        base[4+i] = old;
    80005e06:	c398                	sw	a4,0(a5)
      for(int i = 0; i < 6; i++){
    80005e08:	0791                	addi	a5,a5,4
    80005e0a:	fec798e3          	bne	a5,a2,80005dfa <pci_init+0x5c>
    80005e0e:	b7c9                	j	80005dd0 <pci_init+0x32>
    }
  }
}
    80005e10:	60a6                	ld	ra,72(sp)
    80005e12:	6406                	ld	s0,64(sp)
    80005e14:	74e2                	ld	s1,56(sp)
    80005e16:	7942                	ld	s2,48(sp)
    80005e18:	79a2                	ld	s3,40(sp)
    80005e1a:	7a02                	ld	s4,32(sp)
    80005e1c:	6ae2                	ld	s5,24(sp)
    80005e1e:	6b42                	ld	s6,16(sp)
    80005e20:	6ba2                	ld	s7,8(sp)
    80005e22:	6161                	addi	sp,sp,80
    80005e24:	8082                	ret

0000000080005e26 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80005e26:	1141                	addi	sp,sp,-16
    80005e28:	e422                	sd	s0,8(sp)
    80005e2a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005e2c:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80005e30:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80005e34:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80005e38:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80005e3c:	577d                	li	a4,-1
    80005e3e:	177e                	slli	a4,a4,0x3f
    80005e40:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80005e42:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80005e46:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80005e4a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80005e4e:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80005e52:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80005e56:	000f4737          	lui	a4,0xf4
    80005e5a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80005e5e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80005e60:	14d79073          	csrw	stimecmp,a5
}
    80005e64:	6422                	ld	s0,8(sp)
    80005e66:	0141                	addi	sp,sp,16
    80005e68:	8082                	ret

0000000080005e6a <start>:
{
    80005e6a:	1141                	addi	sp,sp,-16
    80005e6c:	e406                	sd	ra,8(sp)
    80005e6e:	e022                	sd	s0,0(sp)
    80005e70:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005e72:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005e76:	7779                	lui	a4,0xffffe
    80005e78:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff55ef7>
    80005e7c:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005e7e:	6705                	lui	a4,0x1
    80005e80:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005e84:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005e86:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005e8a:	ffffa797          	auipc	a5,0xffffa
    80005e8e:	45e78793          	addi	a5,a5,1118 # 800002e8 <main>
    80005e92:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005e96:	4781                	li	a5,0
    80005e98:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005e9c:	67c1                	lui	a5,0x10
    80005e9e:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005ea0:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005ea4:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005ea8:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80005eac:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80005eb0:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005eb4:	57fd                	li	a5,-1
    80005eb6:	83a9                	srli	a5,a5,0xa
    80005eb8:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005ebc:	47bd                	li	a5,15
    80005ebe:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005ec2:	f65ff0ef          	jal	80005e26 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005ec6:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005eca:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005ecc:	823e                	mv	tp,a5
  asm volatile("mret");
    80005ece:	30200073          	mret
}
    80005ed2:	60a2                	ld	ra,8(sp)
    80005ed4:	6402                	ld	s0,0(sp)
    80005ed6:	0141                	addi	sp,sp,16
    80005ed8:	8082                	ret

0000000080005eda <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005eda:	7119                	addi	sp,sp,-128
    80005edc:	fc86                	sd	ra,120(sp)
    80005ede:	f8a2                	sd	s0,112(sp)
    80005ee0:	f4a6                	sd	s1,104(sp)
    80005ee2:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80005ee4:	06c05a63          	blez	a2,80005f58 <consolewrite+0x7e>
    80005ee8:	f0ca                	sd	s2,96(sp)
    80005eea:	ecce                	sd	s3,88(sp)
    80005eec:	e8d2                	sd	s4,80(sp)
    80005eee:	e4d6                	sd	s5,72(sp)
    80005ef0:	e0da                	sd	s6,64(sp)
    80005ef2:	fc5e                	sd	s7,56(sp)
    80005ef4:	f862                	sd	s8,48(sp)
    80005ef6:	f466                	sd	s9,40(sp)
    80005ef8:	8aaa                	mv	s5,a0
    80005efa:	8b2e                	mv	s6,a1
    80005efc:	8a32                	mv	s4,a2
  int i = 0;
    80005efe:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    80005f00:	02000c13          	li	s8,32
    80005f04:	02000c93          	li	s9,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005f08:	5bfd                	li	s7,-1
    80005f0a:	a035                	j	80005f36 <consolewrite+0x5c>
    if(nn > n - i)
    80005f0c:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005f10:	86ce                	mv	a3,s3
    80005f12:	01648633          	add	a2,s1,s6
    80005f16:	85d6                	mv	a1,s5
    80005f18:	f8040513          	addi	a0,s0,-128
    80005f1c:	859fb0ef          	jal	80001774 <either_copyin>
    80005f20:	03750e63          	beq	a0,s7,80005f5c <consolewrite+0x82>
      break;
    uartwrite(buf, nn);
    80005f24:	85ce                	mv	a1,s3
    80005f26:	f8040513          	addi	a0,s0,-128
    80005f2a:	778000ef          	jal	800066a2 <uartwrite>
    i += nn;
    80005f2e:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80005f32:	0144da63          	bge	s1,s4,80005f46 <consolewrite+0x6c>
    if(nn > n - i)
    80005f36:	409a093b          	subw	s2,s4,s1
    80005f3a:	0009079b          	sext.w	a5,s2
    80005f3e:	fcfc57e3          	bge	s8,a5,80005f0c <consolewrite+0x32>
    80005f42:	8966                	mv	s2,s9
    80005f44:	b7e1                	j	80005f0c <consolewrite+0x32>
    80005f46:	7906                	ld	s2,96(sp)
    80005f48:	69e6                	ld	s3,88(sp)
    80005f4a:	6a46                	ld	s4,80(sp)
    80005f4c:	6aa6                	ld	s5,72(sp)
    80005f4e:	6b06                	ld	s6,64(sp)
    80005f50:	7be2                	ld	s7,56(sp)
    80005f52:	7c42                	ld	s8,48(sp)
    80005f54:	7ca2                	ld	s9,40(sp)
    80005f56:	a819                	j	80005f6c <consolewrite+0x92>
  int i = 0;
    80005f58:	4481                	li	s1,0
    80005f5a:	a809                	j	80005f6c <consolewrite+0x92>
    80005f5c:	7906                	ld	s2,96(sp)
    80005f5e:	69e6                	ld	s3,88(sp)
    80005f60:	6a46                	ld	s4,80(sp)
    80005f62:	6aa6                	ld	s5,72(sp)
    80005f64:	6b06                	ld	s6,64(sp)
    80005f66:	7be2                	ld	s7,56(sp)
    80005f68:	7c42                	ld	s8,48(sp)
    80005f6a:	7ca2                	ld	s9,40(sp)
  }

  return i;
}
    80005f6c:	8526                	mv	a0,s1
    80005f6e:	70e6                	ld	ra,120(sp)
    80005f70:	7446                	ld	s0,112(sp)
    80005f72:	74a6                	ld	s1,104(sp)
    80005f74:	6109                	addi	sp,sp,128
    80005f76:	8082                	ret

0000000080005f78 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005f78:	711d                	addi	sp,sp,-96
    80005f7a:	ec86                	sd	ra,88(sp)
    80005f7c:	e8a2                	sd	s0,80(sp)
    80005f7e:	e4a6                	sd	s1,72(sp)
    80005f80:	e0ca                	sd	s2,64(sp)
    80005f82:	fc4e                	sd	s3,56(sp)
    80005f84:	f852                	sd	s4,48(sp)
    80005f86:	f456                	sd	s5,40(sp)
    80005f88:	f05a                	sd	s6,32(sp)
    80005f8a:	1080                	addi	s0,sp,96
    80005f8c:	8aaa                	mv	s5,a0
    80005f8e:	8a2e                	mv	s4,a1
    80005f90:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005f92:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005f96:	000a3517          	auipc	a0,0xa3
    80005f9a:	89a50513          	addi	a0,a0,-1894 # 800a8830 <cons>
    80005f9e:	109000ef          	jal	800068a6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005fa2:	000a3497          	auipc	s1,0xa3
    80005fa6:	88e48493          	addi	s1,s1,-1906 # 800a8830 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005faa:	000a3917          	auipc	s2,0xa3
    80005fae:	91e90913          	addi	s2,s2,-1762 # 800a88c8 <cons+0x98>
  while(n > 0){
    80005fb2:	0b305d63          	blez	s3,8000606c <consoleread+0xf4>
    while(cons.r == cons.w){
    80005fb6:	0984a783          	lw	a5,152(s1)
    80005fba:	09c4a703          	lw	a4,156(s1)
    80005fbe:	0af71263          	bne	a4,a5,80006062 <consoleread+0xea>
      if(killed(myproc())){
    80005fc2:	e15fa0ef          	jal	80000dd6 <myproc>
    80005fc6:	e40fb0ef          	jal	80001606 <killed>
    80005fca:	e12d                	bnez	a0,8000602c <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80005fcc:	85a6                	mv	a1,s1
    80005fce:	854a                	mv	a0,s2
    80005fd0:	bfefb0ef          	jal	800013ce <sleep>
    while(cons.r == cons.w){
    80005fd4:	0984a783          	lw	a5,152(s1)
    80005fd8:	09c4a703          	lw	a4,156(s1)
    80005fdc:	fef703e3          	beq	a4,a5,80005fc2 <consoleread+0x4a>
    80005fe0:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005fe2:	000a3717          	auipc	a4,0xa3
    80005fe6:	84e70713          	addi	a4,a4,-1970 # 800a8830 <cons>
    80005fea:	0017869b          	addiw	a3,a5,1
    80005fee:	08d72c23          	sw	a3,152(a4)
    80005ff2:	07f7f693          	andi	a3,a5,127
    80005ff6:	9736                	add	a4,a4,a3
    80005ff8:	01874703          	lbu	a4,24(a4)
    80005ffc:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80006000:	4691                	li	a3,4
    80006002:	04db8663          	beq	s7,a3,8000604e <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80006006:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000600a:	4685                	li	a3,1
    8000600c:	faf40613          	addi	a2,s0,-81
    80006010:	85d2                	mv	a1,s4
    80006012:	8556                	mv	a0,s5
    80006014:	f16fb0ef          	jal	8000172a <either_copyout>
    80006018:	57fd                	li	a5,-1
    8000601a:	04f50863          	beq	a0,a5,8000606a <consoleread+0xf2>
      break;

    dst++;
    8000601e:	0a05                	addi	s4,s4,1 # 2001 <_entry-0x7fffdfff>
    --n;
    80006020:	39fd                	addiw	s3,s3,-1 # 3003ffff <_entry-0x4ffc0001>

    if(c == '\n'){
    80006022:	47a9                	li	a5,10
    80006024:	04fb8d63          	beq	s7,a5,8000607e <consoleread+0x106>
    80006028:	6be2                	ld	s7,24(sp)
    8000602a:	b761                	j	80005fb2 <consoleread+0x3a>
        release(&cons.lock);
    8000602c:	000a3517          	auipc	a0,0xa3
    80006030:	80450513          	addi	a0,a0,-2044 # 800a8830 <cons>
    80006034:	10b000ef          	jal	8000693e <release>
        return -1;
    80006038:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000603a:	60e6                	ld	ra,88(sp)
    8000603c:	6446                	ld	s0,80(sp)
    8000603e:	64a6                	ld	s1,72(sp)
    80006040:	6906                	ld	s2,64(sp)
    80006042:	79e2                	ld	s3,56(sp)
    80006044:	7a42                	ld	s4,48(sp)
    80006046:	7aa2                	ld	s5,40(sp)
    80006048:	7b02                	ld	s6,32(sp)
    8000604a:	6125                	addi	sp,sp,96
    8000604c:	8082                	ret
      if(n < target){
    8000604e:	0009871b          	sext.w	a4,s3
    80006052:	01677a63          	bgeu	a4,s6,80006066 <consoleread+0xee>
        cons.r--;
    80006056:	000a3717          	auipc	a4,0xa3
    8000605a:	86f72923          	sw	a5,-1934(a4) # 800a88c8 <cons+0x98>
    8000605e:	6be2                	ld	s7,24(sp)
    80006060:	a031                	j	8000606c <consoleread+0xf4>
    80006062:	ec5e                	sd	s7,24(sp)
    80006064:	bfbd                	j	80005fe2 <consoleread+0x6a>
    80006066:	6be2                	ld	s7,24(sp)
    80006068:	a011                	j	8000606c <consoleread+0xf4>
    8000606a:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000606c:	000a2517          	auipc	a0,0xa2
    80006070:	7c450513          	addi	a0,a0,1988 # 800a8830 <cons>
    80006074:	0cb000ef          	jal	8000693e <release>
  return target - n;
    80006078:	413b053b          	subw	a0,s6,s3
    8000607c:	bf7d                	j	8000603a <consoleread+0xc2>
    8000607e:	6be2                	ld	s7,24(sp)
    80006080:	b7f5                	j	8000606c <consoleread+0xf4>

0000000080006082 <consputc>:
{
    80006082:	1141                	addi	sp,sp,-16
    80006084:	e406                	sd	ra,8(sp)
    80006086:	e022                	sd	s0,0(sp)
    80006088:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000608a:	10000793          	li	a5,256
    8000608e:	00f50863          	beq	a0,a5,8000609e <consputc+0x1c>
    uartputc_sync(c);
    80006092:	6a4000ef          	jal	80006736 <uartputc_sync>
}
    80006096:	60a2                	ld	ra,8(sp)
    80006098:	6402                	ld	s0,0(sp)
    8000609a:	0141                	addi	sp,sp,16
    8000609c:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000609e:	4521                	li	a0,8
    800060a0:	696000ef          	jal	80006736 <uartputc_sync>
    800060a4:	02000513          	li	a0,32
    800060a8:	68e000ef          	jal	80006736 <uartputc_sync>
    800060ac:	4521                	li	a0,8
    800060ae:	688000ef          	jal	80006736 <uartputc_sync>
    800060b2:	b7d5                	j	80006096 <consputc+0x14>

00000000800060b4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800060b4:	1101                	addi	sp,sp,-32
    800060b6:	ec06                	sd	ra,24(sp)
    800060b8:	e822                	sd	s0,16(sp)
    800060ba:	e426                	sd	s1,8(sp)
    800060bc:	1000                	addi	s0,sp,32
    800060be:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800060c0:	000a2517          	auipc	a0,0xa2
    800060c4:	77050513          	addi	a0,a0,1904 # 800a8830 <cons>
    800060c8:	7de000ef          	jal	800068a6 <acquire>

  switch(c){
    800060cc:	47d5                	li	a5,21
    800060ce:	08f48f63          	beq	s1,a5,8000616c <consoleintr+0xb8>
    800060d2:	0297c563          	blt	a5,s1,800060fc <consoleintr+0x48>
    800060d6:	47a1                	li	a5,8
    800060d8:	0ef48463          	beq	s1,a5,800061c0 <consoleintr+0x10c>
    800060dc:	47c1                	li	a5,16
    800060de:	10f49563          	bne	s1,a5,800061e8 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800060e2:	edcfb0ef          	jal	800017be <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800060e6:	000a2517          	auipc	a0,0xa2
    800060ea:	74a50513          	addi	a0,a0,1866 # 800a8830 <cons>
    800060ee:	051000ef          	jal	8000693e <release>
}
    800060f2:	60e2                	ld	ra,24(sp)
    800060f4:	6442                	ld	s0,16(sp)
    800060f6:	64a2                	ld	s1,8(sp)
    800060f8:	6105                	addi	sp,sp,32
    800060fa:	8082                	ret
  switch(c){
    800060fc:	07f00793          	li	a5,127
    80006100:	0cf48063          	beq	s1,a5,800061c0 <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80006104:	000a2717          	auipc	a4,0xa2
    80006108:	72c70713          	addi	a4,a4,1836 # 800a8830 <cons>
    8000610c:	0a072783          	lw	a5,160(a4)
    80006110:	09872703          	lw	a4,152(a4)
    80006114:	9f99                	subw	a5,a5,a4
    80006116:	07f00713          	li	a4,127
    8000611a:	fcf766e3          	bltu	a4,a5,800060e6 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000611e:	47b5                	li	a5,13
    80006120:	0cf48763          	beq	s1,a5,800061ee <consoleintr+0x13a>
      consputc(c);
    80006124:	8526                	mv	a0,s1
    80006126:	f5dff0ef          	jal	80006082 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000612a:	000a2797          	auipc	a5,0xa2
    8000612e:	70678793          	addi	a5,a5,1798 # 800a8830 <cons>
    80006132:	0a07a683          	lw	a3,160(a5)
    80006136:	0016871b          	addiw	a4,a3,1
    8000613a:	0007061b          	sext.w	a2,a4
    8000613e:	0ae7a023          	sw	a4,160(a5)
    80006142:	07f6f693          	andi	a3,a3,127
    80006146:	97b6                	add	a5,a5,a3
    80006148:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000614c:	47a9                	li	a5,10
    8000614e:	0cf48563          	beq	s1,a5,80006218 <consoleintr+0x164>
    80006152:	4791                	li	a5,4
    80006154:	0cf48263          	beq	s1,a5,80006218 <consoleintr+0x164>
    80006158:	000a2797          	auipc	a5,0xa2
    8000615c:	7707a783          	lw	a5,1904(a5) # 800a88c8 <cons+0x98>
    80006160:	9f1d                	subw	a4,a4,a5
    80006162:	08000793          	li	a5,128
    80006166:	f8f710e3          	bne	a4,a5,800060e6 <consoleintr+0x32>
    8000616a:	a07d                	j	80006218 <consoleintr+0x164>
    8000616c:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000616e:	000a2717          	auipc	a4,0xa2
    80006172:	6c270713          	addi	a4,a4,1730 # 800a8830 <cons>
    80006176:	0a072783          	lw	a5,160(a4)
    8000617a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000617e:	000a2497          	auipc	s1,0xa2
    80006182:	6b248493          	addi	s1,s1,1714 # 800a8830 <cons>
    while(cons.e != cons.w &&
    80006186:	4929                	li	s2,10
    80006188:	02f70863          	beq	a4,a5,800061b8 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000618c:	37fd                	addiw	a5,a5,-1
    8000618e:	07f7f713          	andi	a4,a5,127
    80006192:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80006194:	01874703          	lbu	a4,24(a4)
    80006198:	03270263          	beq	a4,s2,800061bc <consoleintr+0x108>
      cons.e--;
    8000619c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800061a0:	10000513          	li	a0,256
    800061a4:	edfff0ef          	jal	80006082 <consputc>
    while(cons.e != cons.w &&
    800061a8:	0a04a783          	lw	a5,160(s1)
    800061ac:	09c4a703          	lw	a4,156(s1)
    800061b0:	fcf71ee3          	bne	a4,a5,8000618c <consoleintr+0xd8>
    800061b4:	6902                	ld	s2,0(sp)
    800061b6:	bf05                	j	800060e6 <consoleintr+0x32>
    800061b8:	6902                	ld	s2,0(sp)
    800061ba:	b735                	j	800060e6 <consoleintr+0x32>
    800061bc:	6902                	ld	s2,0(sp)
    800061be:	b725                	j	800060e6 <consoleintr+0x32>
    if(cons.e != cons.w){
    800061c0:	000a2717          	auipc	a4,0xa2
    800061c4:	67070713          	addi	a4,a4,1648 # 800a8830 <cons>
    800061c8:	0a072783          	lw	a5,160(a4)
    800061cc:	09c72703          	lw	a4,156(a4)
    800061d0:	f0f70be3          	beq	a4,a5,800060e6 <consoleintr+0x32>
      cons.e--;
    800061d4:	37fd                	addiw	a5,a5,-1
    800061d6:	000a2717          	auipc	a4,0xa2
    800061da:	6ef72d23          	sw	a5,1786(a4) # 800a88d0 <cons+0xa0>
      consputc(BACKSPACE);
    800061de:	10000513          	li	a0,256
    800061e2:	ea1ff0ef          	jal	80006082 <consputc>
    800061e6:	b701                	j	800060e6 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800061e8:	ee048fe3          	beqz	s1,800060e6 <consoleintr+0x32>
    800061ec:	bf21                	j	80006104 <consoleintr+0x50>
      consputc(c);
    800061ee:	4529                	li	a0,10
    800061f0:	e93ff0ef          	jal	80006082 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800061f4:	000a2797          	auipc	a5,0xa2
    800061f8:	63c78793          	addi	a5,a5,1596 # 800a8830 <cons>
    800061fc:	0a07a703          	lw	a4,160(a5)
    80006200:	0017069b          	addiw	a3,a4,1
    80006204:	0006861b          	sext.w	a2,a3
    80006208:	0ad7a023          	sw	a3,160(a5)
    8000620c:	07f77713          	andi	a4,a4,127
    80006210:	97ba                	add	a5,a5,a4
    80006212:	4729                	li	a4,10
    80006214:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006218:	000a2797          	auipc	a5,0xa2
    8000621c:	6ac7aa23          	sw	a2,1716(a5) # 800a88cc <cons+0x9c>
        wakeup(&cons.r);
    80006220:	000a2517          	auipc	a0,0xa2
    80006224:	6a850513          	addi	a0,a0,1704 # 800a88c8 <cons+0x98>
    80006228:	9f2fb0ef          	jal	8000141a <wakeup>
    8000622c:	bd6d                	j	800060e6 <consoleintr+0x32>

000000008000622e <consoleinit>:

void
consoleinit(void)
{
    8000622e:	1141                	addi	sp,sp,-16
    80006230:	e406                	sd	ra,8(sp)
    80006232:	e022                	sd	s0,0(sp)
    80006234:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006236:	00002597          	auipc	a1,0x2
    8000623a:	71258593          	addi	a1,a1,1810 # 80008948 <etext+0x948>
    8000623e:	000a2517          	auipc	a0,0xa2
    80006242:	5f250513          	addi	a0,a0,1522 # 800a8830 <cons>
    80006246:	5e0000ef          	jal	80006826 <initlock>

  uartinit();
    8000624a:	400000ef          	jal	8000664a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000624e:	00015797          	auipc	a5,0x15
    80006252:	78a78793          	addi	a5,a5,1930 # 8001b9d8 <devsw>
    80006256:	00000717          	auipc	a4,0x0
    8000625a:	d2270713          	addi	a4,a4,-734 # 80005f78 <consoleread>
    8000625e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006260:	00000717          	auipc	a4,0x0
    80006264:	c7a70713          	addi	a4,a4,-902 # 80005eda <consolewrite>
    80006268:	ef98                	sd	a4,24(a5)
}
    8000626a:	60a2                	ld	ra,8(sp)
    8000626c:	6402                	ld	s0,0(sp)
    8000626e:	0141                	addi	sp,sp,16
    80006270:	8082                	ret

0000000080006272 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80006272:	7139                	addi	sp,sp,-64
    80006274:	fc06                	sd	ra,56(sp)
    80006276:	f822                	sd	s0,48(sp)
    80006278:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000627a:	c219                	beqz	a2,80006280 <printint+0xe>
    8000627c:	08054063          	bltz	a0,800062fc <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80006280:	4881                	li	a7,0
    80006282:	fc840693          	addi	a3,s0,-56

  i = 0;
    80006286:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80006288:	00003617          	auipc	a2,0x3
    8000628c:	87060613          	addi	a2,a2,-1936 # 80008af8 <digits>
    80006290:	883e                	mv	a6,a5
    80006292:	2785                	addiw	a5,a5,1
    80006294:	02b57733          	remu	a4,a0,a1
    80006298:	9732                	add	a4,a4,a2
    8000629a:	00074703          	lbu	a4,0(a4)
    8000629e:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800062a2:	872a                	mv	a4,a0
    800062a4:	02b55533          	divu	a0,a0,a1
    800062a8:	0685                	addi	a3,a3,1
    800062aa:	feb773e3          	bgeu	a4,a1,80006290 <printint+0x1e>

  if(sign)
    800062ae:	00088a63          	beqz	a7,800062c2 <printint+0x50>
    buf[i++] = '-';
    800062b2:	1781                	addi	a5,a5,-32
    800062b4:	97a2                	add	a5,a5,s0
    800062b6:	02d00713          	li	a4,45
    800062ba:	fee78423          	sb	a4,-24(a5)
    800062be:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800062c2:	02f05963          	blez	a5,800062f4 <printint+0x82>
    800062c6:	f426                	sd	s1,40(sp)
    800062c8:	f04a                	sd	s2,32(sp)
    800062ca:	fc840713          	addi	a4,s0,-56
    800062ce:	00f704b3          	add	s1,a4,a5
    800062d2:	fff70913          	addi	s2,a4,-1
    800062d6:	993e                	add	s2,s2,a5
    800062d8:	37fd                	addiw	a5,a5,-1
    800062da:	1782                	slli	a5,a5,0x20
    800062dc:	9381                	srli	a5,a5,0x20
    800062de:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800062e2:	fff4c503          	lbu	a0,-1(s1)
    800062e6:	d9dff0ef          	jal	80006082 <consputc>
  while(--i >= 0)
    800062ea:	14fd                	addi	s1,s1,-1
    800062ec:	ff249be3          	bne	s1,s2,800062e2 <printint+0x70>
    800062f0:	74a2                	ld	s1,40(sp)
    800062f2:	7902                	ld	s2,32(sp)
}
    800062f4:	70e2                	ld	ra,56(sp)
    800062f6:	7442                	ld	s0,48(sp)
    800062f8:	6121                	addi	sp,sp,64
    800062fa:	8082                	ret
    x = -xx;
    800062fc:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80006300:	4885                	li	a7,1
    x = -xx;
    80006302:	b741                	j	80006282 <printint+0x10>

0000000080006304 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80006304:	7131                	addi	sp,sp,-192
    80006306:	fc86                	sd	ra,120(sp)
    80006308:	f8a2                	sd	s0,112(sp)
    8000630a:	e8d2                	sd	s4,80(sp)
    8000630c:	0100                	addi	s0,sp,128
    8000630e:	8a2a                	mv	s4,a0
    80006310:	e40c                	sd	a1,8(s0)
    80006312:	e810                	sd	a2,16(s0)
    80006314:	ec14                	sd	a3,24(s0)
    80006316:	f018                	sd	a4,32(s0)
    80006318:	f41c                	sd	a5,40(s0)
    8000631a:	03043823          	sd	a6,48(s0)
    8000631e:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80006322:	00005797          	auipc	a5,0x5
    80006326:	6127a783          	lw	a5,1554(a5) # 8000b934 <panicking>
    8000632a:	c3a1                	beqz	a5,8000636a <printf+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000632c:	00840793          	addi	a5,s0,8
    80006330:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80006334:	000a4503          	lbu	a0,0(s4)
    80006338:	28050763          	beqz	a0,800065c6 <printf+0x2c2>
    8000633c:	f4a6                	sd	s1,104(sp)
    8000633e:	f0ca                	sd	s2,96(sp)
    80006340:	ecce                	sd	s3,88(sp)
    80006342:	e4d6                	sd	s5,72(sp)
    80006344:	e0da                	sd	s6,64(sp)
    80006346:	f862                	sd	s8,48(sp)
    80006348:	f466                	sd	s9,40(sp)
    8000634a:	f06a                	sd	s10,32(sp)
    8000634c:	ec6e                	sd	s11,24(sp)
    8000634e:	4981                	li	s3,0
    if(cx != '%'){
    80006350:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80006354:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80006358:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000635c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80006360:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80006364:	07000d93          	li	s11,112
    80006368:	a01d                	j	8000638e <printf+0x8a>
    acquire(&pr.lock);
    8000636a:	000a2517          	auipc	a0,0xa2
    8000636e:	56e50513          	addi	a0,a0,1390 # 800a88d8 <pr>
    80006372:	534000ef          	jal	800068a6 <acquire>
    80006376:	bf5d                	j	8000632c <printf+0x28>
      consputc(cx);
    80006378:	d0bff0ef          	jal	80006082 <consputc>
      continue;
    8000637c:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000637e:	0014899b          	addiw	s3,s1,1
    80006382:	013a07b3          	add	a5,s4,s3
    80006386:	0007c503          	lbu	a0,0(a5)
    8000638a:	20050b63          	beqz	a0,800065a0 <printf+0x29c>
    if(cx != '%'){
    8000638e:	ff5515e3          	bne	a0,s5,80006378 <printf+0x74>
    i++;
    80006392:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80006396:	009a07b3          	add	a5,s4,s1
    8000639a:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000639e:	20090b63          	beqz	s2,800065b4 <printf+0x2b0>
    800063a2:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800063a6:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800063a8:	c789                	beqz	a5,800063b2 <printf+0xae>
    800063aa:	009a0733          	add	a4,s4,s1
    800063ae:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800063b2:	03690963          	beq	s2,s6,800063e4 <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    800063b6:	05890363          	beq	s2,s8,800063fc <printf+0xf8>
    } else if(c0 == 'u'){
    800063ba:	0d990663          	beq	s2,s9,80006486 <printf+0x182>
    } else if(c0 == 'x'){
    800063be:	11a90d63          	beq	s2,s10,800064d8 <printf+0x1d4>
    } else if(c0 == 'p'){
    800063c2:	15b90663          	beq	s2,s11,8000650e <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    800063c6:	06300793          	li	a5,99
    800063ca:	18f90563          	beq	s2,a5,80006554 <printf+0x250>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    800063ce:	07300793          	li	a5,115
    800063d2:	18f90b63          	beq	s2,a5,80006568 <printf+0x264>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800063d6:	03591b63          	bne	s2,s5,8000640c <printf+0x108>
      consputc('%');
    800063da:	02500513          	li	a0,37
    800063de:	ca5ff0ef          	jal	80006082 <consputc>
    800063e2:	bf71                	j	8000637e <printf+0x7a>
      printint(va_arg(ap, int), 10, 1);
    800063e4:	f8843783          	ld	a5,-120(s0)
    800063e8:	00878713          	addi	a4,a5,8
    800063ec:	f8e43423          	sd	a4,-120(s0)
    800063f0:	4605                	li	a2,1
    800063f2:	45a9                	li	a1,10
    800063f4:	4388                	lw	a0,0(a5)
    800063f6:	e7dff0ef          	jal	80006272 <printint>
    800063fa:	b751                	j	8000637e <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'd'){
    800063fc:	01678f63          	beq	a5,s6,8000641a <printf+0x116>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80006400:	03878b63          	beq	a5,s8,80006436 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'u'){
    80006404:	09978e63          	beq	a5,s9,800064a0 <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'x'){
    80006408:	0fa78563          	beq	a5,s10,800064f2 <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    8000640c:	8556                	mv	a0,s5
    8000640e:	c75ff0ef          	jal	80006082 <consputc>
      consputc(c0);
    80006412:	854a                	mv	a0,s2
    80006414:	c6fff0ef          	jal	80006082 <consputc>
    80006418:	b79d                	j	8000637e <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    8000641a:	f8843783          	ld	a5,-120(s0)
    8000641e:	00878713          	addi	a4,a5,8
    80006422:	f8e43423          	sd	a4,-120(s0)
    80006426:	4605                	li	a2,1
    80006428:	45a9                	li	a1,10
    8000642a:	6388                	ld	a0,0(a5)
    8000642c:	e47ff0ef          	jal	80006272 <printint>
      i += 1;
    80006430:	0029849b          	addiw	s1,s3,2
    80006434:	b7a9                	j	8000637e <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80006436:	06400793          	li	a5,100
    8000643a:	02f68863          	beq	a3,a5,8000646a <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000643e:	07500793          	li	a5,117
    80006442:	06f68d63          	beq	a3,a5,800064bc <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80006446:	07800793          	li	a5,120
    8000644a:	fcf691e3          	bne	a3,a5,8000640c <printf+0x108>
      printint(va_arg(ap, uint64), 16, 0);
    8000644e:	f8843783          	ld	a5,-120(s0)
    80006452:	00878713          	addi	a4,a5,8
    80006456:	f8e43423          	sd	a4,-120(s0)
    8000645a:	4601                	li	a2,0
    8000645c:	45c1                	li	a1,16
    8000645e:	6388                	ld	a0,0(a5)
    80006460:	e13ff0ef          	jal	80006272 <printint>
      i += 2;
    80006464:	0039849b          	addiw	s1,s3,3
    80006468:	bf19                	j	8000637e <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    8000646a:	f8843783          	ld	a5,-120(s0)
    8000646e:	00878713          	addi	a4,a5,8
    80006472:	f8e43423          	sd	a4,-120(s0)
    80006476:	4605                	li	a2,1
    80006478:	45a9                	li	a1,10
    8000647a:	6388                	ld	a0,0(a5)
    8000647c:	df7ff0ef          	jal	80006272 <printint>
      i += 2;
    80006480:	0039849b          	addiw	s1,s3,3
    80006484:	bded                	j	8000637e <printf+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    80006486:	f8843783          	ld	a5,-120(s0)
    8000648a:	00878713          	addi	a4,a5,8
    8000648e:	f8e43423          	sd	a4,-120(s0)
    80006492:	4601                	li	a2,0
    80006494:	45a9                	li	a1,10
    80006496:	0007e503          	lwu	a0,0(a5)
    8000649a:	dd9ff0ef          	jal	80006272 <printint>
    8000649e:	b5c5                	j	8000637e <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800064a0:	f8843783          	ld	a5,-120(s0)
    800064a4:	00878713          	addi	a4,a5,8
    800064a8:	f8e43423          	sd	a4,-120(s0)
    800064ac:	4601                	li	a2,0
    800064ae:	45a9                	li	a1,10
    800064b0:	6388                	ld	a0,0(a5)
    800064b2:	dc1ff0ef          	jal	80006272 <printint>
      i += 1;
    800064b6:	0029849b          	addiw	s1,s3,2
    800064ba:	b5d1                	j	8000637e <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800064bc:	f8843783          	ld	a5,-120(s0)
    800064c0:	00878713          	addi	a4,a5,8
    800064c4:	f8e43423          	sd	a4,-120(s0)
    800064c8:	4601                	li	a2,0
    800064ca:	45a9                	li	a1,10
    800064cc:	6388                	ld	a0,0(a5)
    800064ce:	da5ff0ef          	jal	80006272 <printint>
      i += 2;
    800064d2:	0039849b          	addiw	s1,s3,3
    800064d6:	b565                	j	8000637e <printf+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    800064d8:	f8843783          	ld	a5,-120(s0)
    800064dc:	00878713          	addi	a4,a5,8
    800064e0:	f8e43423          	sd	a4,-120(s0)
    800064e4:	4601                	li	a2,0
    800064e6:	45c1                	li	a1,16
    800064e8:	0007e503          	lwu	a0,0(a5)
    800064ec:	d87ff0ef          	jal	80006272 <printint>
    800064f0:	b579                	j	8000637e <printf+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    800064f2:	f8843783          	ld	a5,-120(s0)
    800064f6:	00878713          	addi	a4,a5,8
    800064fa:	f8e43423          	sd	a4,-120(s0)
    800064fe:	4601                	li	a2,0
    80006500:	45c1                	li	a1,16
    80006502:	6388                	ld	a0,0(a5)
    80006504:	d6fff0ef          	jal	80006272 <printint>
      i += 1;
    80006508:	0029849b          	addiw	s1,s3,2
    8000650c:	bd8d                	j	8000637e <printf+0x7a>
    8000650e:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    80006510:	f8843783          	ld	a5,-120(s0)
    80006514:	00878713          	addi	a4,a5,8
    80006518:	f8e43423          	sd	a4,-120(s0)
    8000651c:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006520:	03000513          	li	a0,48
    80006524:	b5fff0ef          	jal	80006082 <consputc>
  consputc('x');
    80006528:	07800513          	li	a0,120
    8000652c:	b57ff0ef          	jal	80006082 <consputc>
    80006530:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006532:	00002b97          	auipc	s7,0x2
    80006536:	5c6b8b93          	addi	s7,s7,1478 # 80008af8 <digits>
    8000653a:	03c9d793          	srli	a5,s3,0x3c
    8000653e:	97de                	add	a5,a5,s7
    80006540:	0007c503          	lbu	a0,0(a5)
    80006544:	b3fff0ef          	jal	80006082 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006548:	0992                	slli	s3,s3,0x4
    8000654a:	397d                	addiw	s2,s2,-1
    8000654c:	fe0917e3          	bnez	s2,8000653a <printf+0x236>
    80006550:	7be2                	ld	s7,56(sp)
    80006552:	b535                	j	8000637e <printf+0x7a>
      consputc(va_arg(ap, uint));
    80006554:	f8843783          	ld	a5,-120(s0)
    80006558:	00878713          	addi	a4,a5,8
    8000655c:	f8e43423          	sd	a4,-120(s0)
    80006560:	4388                	lw	a0,0(a5)
    80006562:	b21ff0ef          	jal	80006082 <consputc>
    80006566:	bd21                	j	8000637e <printf+0x7a>
      if((s = va_arg(ap, char*)) == 0)
    80006568:	f8843783          	ld	a5,-120(s0)
    8000656c:	00878713          	addi	a4,a5,8
    80006570:	f8e43423          	sd	a4,-120(s0)
    80006574:	0007b903          	ld	s2,0(a5)
    80006578:	00090d63          	beqz	s2,80006592 <printf+0x28e>
      for(; *s; s++)
    8000657c:	00094503          	lbu	a0,0(s2)
    80006580:	de050fe3          	beqz	a0,8000637e <printf+0x7a>
        consputc(*s);
    80006584:	affff0ef          	jal	80006082 <consputc>
      for(; *s; s++)
    80006588:	0905                	addi	s2,s2,1
    8000658a:	00094503          	lbu	a0,0(s2)
    8000658e:	f97d                	bnez	a0,80006584 <printf+0x280>
    80006590:	b3fd                	j	8000637e <printf+0x7a>
        s = "(null)";
    80006592:	00002917          	auipc	s2,0x2
    80006596:	3be90913          	addi	s2,s2,958 # 80008950 <etext+0x950>
      for(; *s; s++)
    8000659a:	02800513          	li	a0,40
    8000659e:	b7dd                	j	80006584 <printf+0x280>
    800065a0:	74a6                	ld	s1,104(sp)
    800065a2:	7906                	ld	s2,96(sp)
    800065a4:	69e6                	ld	s3,88(sp)
    800065a6:	6aa6                	ld	s5,72(sp)
    800065a8:	6b06                	ld	s6,64(sp)
    800065aa:	7c42                	ld	s8,48(sp)
    800065ac:	7ca2                	ld	s9,40(sp)
    800065ae:	7d02                	ld	s10,32(sp)
    800065b0:	6de2                	ld	s11,24(sp)
    800065b2:	a811                	j	800065c6 <printf+0x2c2>
    800065b4:	74a6                	ld	s1,104(sp)
    800065b6:	7906                	ld	s2,96(sp)
    800065b8:	69e6                	ld	s3,88(sp)
    800065ba:	6aa6                	ld	s5,72(sp)
    800065bc:	6b06                	ld	s6,64(sp)
    800065be:	7c42                	ld	s8,48(sp)
    800065c0:	7ca2                	ld	s9,40(sp)
    800065c2:	7d02                	ld	s10,32(sp)
    800065c4:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    800065c6:	00005797          	auipc	a5,0x5
    800065ca:	36e7a783          	lw	a5,878(a5) # 8000b934 <panicking>
    800065ce:	c799                	beqz	a5,800065dc <printf+0x2d8>
    release(&pr.lock);

  return 0;
}
    800065d0:	4501                	li	a0,0
    800065d2:	70e6                	ld	ra,120(sp)
    800065d4:	7446                	ld	s0,112(sp)
    800065d6:	6a46                	ld	s4,80(sp)
    800065d8:	6129                	addi	sp,sp,192
    800065da:	8082                	ret
    release(&pr.lock);
    800065dc:	000a2517          	auipc	a0,0xa2
    800065e0:	2fc50513          	addi	a0,a0,764 # 800a88d8 <pr>
    800065e4:	35a000ef          	jal	8000693e <release>
  return 0;
    800065e8:	b7e5                	j	800065d0 <printf+0x2cc>

00000000800065ea <panic>:

void
panic(char *s)
{
    800065ea:	1101                	addi	sp,sp,-32
    800065ec:	ec06                	sd	ra,24(sp)
    800065ee:	e822                	sd	s0,16(sp)
    800065f0:	e426                	sd	s1,8(sp)
    800065f2:	e04a                	sd	s2,0(sp)
    800065f4:	1000                	addi	s0,sp,32
    800065f6:	84aa                	mv	s1,a0
  panicking = 1;
    800065f8:	4905                	li	s2,1
    800065fa:	00005797          	auipc	a5,0x5
    800065fe:	3327ad23          	sw	s2,826(a5) # 8000b934 <panicking>
  printf("panic: ");
    80006602:	00002517          	auipc	a0,0x2
    80006606:	35650513          	addi	a0,a0,854 # 80008958 <etext+0x958>
    8000660a:	cfbff0ef          	jal	80006304 <printf>
  printf("%s\n", s);
    8000660e:	85a6                	mv	a1,s1
    80006610:	00002517          	auipc	a0,0x2
    80006614:	35050513          	addi	a0,a0,848 # 80008960 <etext+0x960>
    80006618:	cedff0ef          	jal	80006304 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000661c:	00005797          	auipc	a5,0x5
    80006620:	3127aa23          	sw	s2,788(a5) # 8000b930 <panicked>
  for(;;)
    80006624:	a001                	j	80006624 <panic+0x3a>

0000000080006626 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006626:	1141                	addi	sp,sp,-16
    80006628:	e406                	sd	ra,8(sp)
    8000662a:	e022                	sd	s0,0(sp)
    8000662c:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    8000662e:	00002597          	auipc	a1,0x2
    80006632:	33a58593          	addi	a1,a1,826 # 80008968 <etext+0x968>
    80006636:	000a2517          	auipc	a0,0xa2
    8000663a:	2a250513          	addi	a0,a0,674 # 800a88d8 <pr>
    8000663e:	1e8000ef          	jal	80006826 <initlock>
}
    80006642:	60a2                	ld	ra,8(sp)
    80006644:	6402                	ld	s0,0(sp)
    80006646:	0141                	addi	sp,sp,16
    80006648:	8082                	ret

000000008000664a <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    8000664a:	1141                	addi	sp,sp,-16
    8000664c:	e406                	sd	ra,8(sp)
    8000664e:	e022                	sd	s0,0(sp)
    80006650:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006652:	100007b7          	lui	a5,0x10000
    80006656:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000665a:	10000737          	lui	a4,0x10000
    8000665e:	f8000693          	li	a3,-128
    80006662:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006666:	468d                	li	a3,3
    80006668:	10000637          	lui	a2,0x10000
    8000666c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006670:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006674:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006678:	10000737          	lui	a4,0x10000
    8000667c:	461d                	li	a2,7
    8000667e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006682:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    80006686:	00002597          	auipc	a1,0x2
    8000668a:	2ea58593          	addi	a1,a1,746 # 80008970 <etext+0x970>
    8000668e:	000a2517          	auipc	a0,0xa2
    80006692:	26250513          	addi	a0,a0,610 # 800a88f0 <tx_lock>
    80006696:	190000ef          	jal	80006826 <initlock>
}
    8000669a:	60a2                	ld	ra,8(sp)
    8000669c:	6402                	ld	s0,0(sp)
    8000669e:	0141                	addi	sp,sp,16
    800066a0:	8082                	ret

00000000800066a2 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800066a2:	715d                	addi	sp,sp,-80
    800066a4:	e486                	sd	ra,72(sp)
    800066a6:	e0a2                	sd	s0,64(sp)
    800066a8:	fc26                	sd	s1,56(sp)
    800066aa:	ec56                	sd	s5,24(sp)
    800066ac:	0880                	addi	s0,sp,80
    800066ae:	8aaa                	mv	s5,a0
    800066b0:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800066b2:	000a2517          	auipc	a0,0xa2
    800066b6:	23e50513          	addi	a0,a0,574 # 800a88f0 <tx_lock>
    800066ba:	1ec000ef          	jal	800068a6 <acquire>

  int i = 0;
  while(i < n){ 
    800066be:	06905063          	blez	s1,8000671e <uartwrite+0x7c>
    800066c2:	f84a                	sd	s2,48(sp)
    800066c4:	f44e                	sd	s3,40(sp)
    800066c6:	f052                	sd	s4,32(sp)
    800066c8:	e85a                	sd	s6,16(sp)
    800066ca:	e45e                	sd	s7,8(sp)
    800066cc:	8a56                	mv	s4,s5
    800066ce:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    800066d0:	00005497          	auipc	s1,0x5
    800066d4:	26c48493          	addi	s1,s1,620 # 8000b93c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    800066d8:	000a2997          	auipc	s3,0xa2
    800066dc:	21898993          	addi	s3,s3,536 # 800a88f0 <tx_lock>
    800066e0:	00005917          	auipc	s2,0x5
    800066e4:	25890913          	addi	s2,s2,600 # 8000b938 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    800066e8:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    800066ec:	4b05                	li	s6,1
    800066ee:	a005                	j	8000670e <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    800066f0:	85ce                	mv	a1,s3
    800066f2:	854a                	mv	a0,s2
    800066f4:	cdbfa0ef          	jal	800013ce <sleep>
    while(tx_busy != 0){
    800066f8:	409c                	lw	a5,0(s1)
    800066fa:	fbfd                	bnez	a5,800066f0 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    800066fc:	000a4783          	lbu	a5,0(s4)
    80006700:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80006704:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80006708:	0a05                	addi	s4,s4,1
    8000670a:	015a0563          	beq	s4,s5,80006714 <uartwrite+0x72>
    while(tx_busy != 0){
    8000670e:	409c                	lw	a5,0(s1)
    80006710:	f3e5                	bnez	a5,800066f0 <uartwrite+0x4e>
    80006712:	b7ed                	j	800066fc <uartwrite+0x5a>
    80006714:	7942                	ld	s2,48(sp)
    80006716:	79a2                	ld	s3,40(sp)
    80006718:	7a02                	ld	s4,32(sp)
    8000671a:	6b42                	ld	s6,16(sp)
    8000671c:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    8000671e:	000a2517          	auipc	a0,0xa2
    80006722:	1d250513          	addi	a0,a0,466 # 800a88f0 <tx_lock>
    80006726:	218000ef          	jal	8000693e <release>
}
    8000672a:	60a6                	ld	ra,72(sp)
    8000672c:	6406                	ld	s0,64(sp)
    8000672e:	74e2                	ld	s1,56(sp)
    80006730:	6ae2                	ld	s5,24(sp)
    80006732:	6161                	addi	sp,sp,80
    80006734:	8082                	ret

0000000080006736 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006736:	1101                	addi	sp,sp,-32
    80006738:	ec06                	sd	ra,24(sp)
    8000673a:	e822                	sd	s0,16(sp)
    8000673c:	e426                	sd	s1,8(sp)
    8000673e:	1000                	addi	s0,sp,32
    80006740:	84aa                	mv	s1,a0
  if(panicking == 0)
    80006742:	00005797          	auipc	a5,0x5
    80006746:	1f27a783          	lw	a5,498(a5) # 8000b934 <panicking>
    8000674a:	cf95                	beqz	a5,80006786 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    8000674c:	00005797          	auipc	a5,0x5
    80006750:	1e47a783          	lw	a5,484(a5) # 8000b930 <panicked>
    80006754:	ef85                	bnez	a5,8000678c <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006756:	10000737          	lui	a4,0x10000
    8000675a:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000675c:	00074783          	lbu	a5,0(a4)
    80006760:	0207f793          	andi	a5,a5,32
    80006764:	dfe5                	beqz	a5,8000675c <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80006766:	0ff4f513          	zext.b	a0,s1
    8000676a:	100007b7          	lui	a5,0x10000
    8000676e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80006772:	00005797          	auipc	a5,0x5
    80006776:	1c27a783          	lw	a5,450(a5) # 8000b934 <panicking>
    8000677a:	cb91                	beqz	a5,8000678e <uartputc_sync+0x58>
    pop_off();
}
    8000677c:	60e2                	ld	ra,24(sp)
    8000677e:	6442                	ld	s0,16(sp)
    80006780:	64a2                	ld	s1,8(sp)
    80006782:	6105                	addi	sp,sp,32
    80006784:	8082                	ret
    push_off();
    80006786:	0e0000ef          	jal	80006866 <push_off>
    8000678a:	b7c9                	j	8000674c <uartputc_sync+0x16>
    for(;;)
    8000678c:	a001                	j	8000678c <uartputc_sync+0x56>
    pop_off();
    8000678e:	15c000ef          	jal	800068ea <pop_off>
}
    80006792:	b7ed                	j	8000677c <uartputc_sync+0x46>

0000000080006794 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006794:	1141                	addi	sp,sp,-16
    80006796:	e422                	sd	s0,8(sp)
    80006798:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    8000679a:	100007b7          	lui	a5,0x10000
    8000679e:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800067a0:	0007c783          	lbu	a5,0(a5)
    800067a4:	8b85                	andi	a5,a5,1
    800067a6:	cb81                	beqz	a5,800067b6 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800067a8:	100007b7          	lui	a5,0x10000
    800067ac:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800067b0:	6422                	ld	s0,8(sp)
    800067b2:	0141                	addi	sp,sp,16
    800067b4:	8082                	ret
    return -1;
    800067b6:	557d                	li	a0,-1
    800067b8:	bfe5                	j	800067b0 <uartgetc+0x1c>

00000000800067ba <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800067ba:	1101                	addi	sp,sp,-32
    800067bc:	ec06                	sd	ra,24(sp)
    800067be:	e822                	sd	s0,16(sp)
    800067c0:	e426                	sd	s1,8(sp)
    800067c2:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800067c4:	100007b7          	lui	a5,0x10000
    800067c8:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800067ca:	0007c783          	lbu	a5,0(a5)

  acquire(&tx_lock);
    800067ce:	000a2517          	auipc	a0,0xa2
    800067d2:	12250513          	addi	a0,a0,290 # 800a88f0 <tx_lock>
    800067d6:	0d0000ef          	jal	800068a6 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    800067da:	100007b7          	lui	a5,0x10000
    800067de:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800067e0:	0007c783          	lbu	a5,0(a5)
    800067e4:	0207f793          	andi	a5,a5,32
    800067e8:	eb89                	bnez	a5,800067fa <uartintr+0x40>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    800067ea:	000a2517          	auipc	a0,0xa2
    800067ee:	10650513          	addi	a0,a0,262 # 800a88f0 <tx_lock>
    800067f2:	14c000ef          	jal	8000693e <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800067f6:	54fd                	li	s1,-1
    800067f8:	a831                	j	80006814 <uartintr+0x5a>
    tx_busy = 0;
    800067fa:	00005797          	auipc	a5,0x5
    800067fe:	1407a123          	sw	zero,322(a5) # 8000b93c <tx_busy>
    wakeup(&tx_chan);
    80006802:	00005517          	auipc	a0,0x5
    80006806:	13650513          	addi	a0,a0,310 # 8000b938 <tx_chan>
    8000680a:	c11fa0ef          	jal	8000141a <wakeup>
    8000680e:	bff1                	j	800067ea <uartintr+0x30>
      break;
    consoleintr(c);
    80006810:	8a5ff0ef          	jal	800060b4 <consoleintr>
    int c = uartgetc();
    80006814:	f81ff0ef          	jal	80006794 <uartgetc>
    if(c == -1)
    80006818:	fe951ce3          	bne	a0,s1,80006810 <uartintr+0x56>
  }
}
    8000681c:	60e2                	ld	ra,24(sp)
    8000681e:	6442                	ld	s0,16(sp)
    80006820:	64a2                	ld	s1,8(sp)
    80006822:	6105                	addi	sp,sp,32
    80006824:	8082                	ret

0000000080006826 <initlock>:
}
#endif

void
initlock(struct spinlock *lk, char *name)
{
    80006826:	1141                	addi	sp,sp,-16
    80006828:	e422                	sd	s0,8(sp)
    8000682a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000682c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000682e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006832:	00053823          	sd	zero,16(a0)
#ifdef LAB_LOCK
  lk->nts = 0;
  lk->n = 0;
  findslot(lk);
#endif  
}
    80006836:	6422                	ld	s0,8(sp)
    80006838:	0141                	addi	sp,sp,16
    8000683a:	8082                	ret

000000008000683c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000683c:	411c                	lw	a5,0(a0)
    8000683e:	e399                	bnez	a5,80006844 <holding+0x8>
    80006840:	4501                	li	a0,0
  return r;
}
    80006842:	8082                	ret
{
    80006844:	1101                	addi	sp,sp,-32
    80006846:	ec06                	sd	ra,24(sp)
    80006848:	e822                	sd	s0,16(sp)
    8000684a:	e426                	sd	s1,8(sp)
    8000684c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000684e:	6904                	ld	s1,16(a0)
    80006850:	d6afa0ef          	jal	80000dba <mycpu>
    80006854:	40a48533          	sub	a0,s1,a0
    80006858:	00153513          	seqz	a0,a0
}
    8000685c:	60e2                	ld	ra,24(sp)
    8000685e:	6442                	ld	s0,16(sp)
    80006860:	64a2                	ld	s1,8(sp)
    80006862:	6105                	addi	sp,sp,32
    80006864:	8082                	ret

0000000080006866 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006866:	1101                	addi	sp,sp,-32
    80006868:	ec06                	sd	ra,24(sp)
    8000686a:	e822                	sd	s0,16(sp)
    8000686c:	e426                	sd	s1,8(sp)
    8000686e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006870:	100024f3          	csrr	s1,sstatus
    80006874:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006878:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000687a:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    8000687e:	d3cfa0ef          	jal	80000dba <mycpu>
    80006882:	5d3c                	lw	a5,120(a0)
    80006884:	cb99                	beqz	a5,8000689a <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006886:	d34fa0ef          	jal	80000dba <mycpu>
    8000688a:	5d3c                	lw	a5,120(a0)
    8000688c:	2785                	addiw	a5,a5,1
    8000688e:	dd3c                	sw	a5,120(a0)
}
    80006890:	60e2                	ld	ra,24(sp)
    80006892:	6442                	ld	s0,16(sp)
    80006894:	64a2                	ld	s1,8(sp)
    80006896:	6105                	addi	sp,sp,32
    80006898:	8082                	ret
    mycpu()->intena = old;
    8000689a:	d20fa0ef          	jal	80000dba <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000689e:	8085                	srli	s1,s1,0x1
    800068a0:	8885                	andi	s1,s1,1
    800068a2:	dd64                	sw	s1,124(a0)
    800068a4:	b7cd                	j	80006886 <push_off+0x20>

00000000800068a6 <acquire>:
{
    800068a6:	1101                	addi	sp,sp,-32
    800068a8:	ec06                	sd	ra,24(sp)
    800068aa:	e822                	sd	s0,16(sp)
    800068ac:	e426                	sd	s1,8(sp)
    800068ae:	1000                	addi	s0,sp,32
    800068b0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800068b2:	fb5ff0ef          	jal	80006866 <push_off>
  if(holding(lk))
    800068b6:	8526                	mv	a0,s1
    800068b8:	f85ff0ef          	jal	8000683c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800068bc:	4705                	li	a4,1
  if(holding(lk))
    800068be:	e105                	bnez	a0,800068de <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800068c0:	87ba                	mv	a5,a4
    800068c2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800068c6:	2781                	sext.w	a5,a5
    800068c8:	ffe5                	bnez	a5,800068c0 <acquire+0x1a>
  __sync_synchronize();
    800068ca:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800068ce:	cecfa0ef          	jal	80000dba <mycpu>
    800068d2:	e888                	sd	a0,16(s1)
}
    800068d4:	60e2                	ld	ra,24(sp)
    800068d6:	6442                	ld	s0,16(sp)
    800068d8:	64a2                	ld	s1,8(sp)
    800068da:	6105                	addi	sp,sp,32
    800068dc:	8082                	ret
    panic("acquire");
    800068de:	00002517          	auipc	a0,0x2
    800068e2:	09a50513          	addi	a0,a0,154 # 80008978 <etext+0x978>
    800068e6:	d05ff0ef          	jal	800065ea <panic>

00000000800068ea <pop_off>:

void
pop_off(void)
{
    800068ea:	1141                	addi	sp,sp,-16
    800068ec:	e406                	sd	ra,8(sp)
    800068ee:	e022                	sd	s0,0(sp)
    800068f0:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800068f2:	cc8fa0ef          	jal	80000dba <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800068f6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800068fa:	8b89                	andi	a5,a5,2
  if(intr_get())
    800068fc:	e78d                	bnez	a5,80006926 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800068fe:	5d3c                	lw	a5,120(a0)
    80006900:	02f05963          	blez	a5,80006932 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80006904:	37fd                	addiw	a5,a5,-1
    80006906:	0007871b          	sext.w	a4,a5
    8000690a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000690c:	eb09                	bnez	a4,8000691e <pop_off+0x34>
    8000690e:	5d7c                	lw	a5,124(a0)
    80006910:	c799                	beqz	a5,8000691e <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006912:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006916:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000691a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000691e:	60a2                	ld	ra,8(sp)
    80006920:	6402                	ld	s0,0(sp)
    80006922:	0141                	addi	sp,sp,16
    80006924:	8082                	ret
    panic("pop_off - interruptible");
    80006926:	00002517          	auipc	a0,0x2
    8000692a:	05a50513          	addi	a0,a0,90 # 80008980 <etext+0x980>
    8000692e:	cbdff0ef          	jal	800065ea <panic>
    panic("pop_off");
    80006932:	00002517          	auipc	a0,0x2
    80006936:	06650513          	addi	a0,a0,102 # 80008998 <etext+0x998>
    8000693a:	cb1ff0ef          	jal	800065ea <panic>

000000008000693e <release>:
{
    8000693e:	1101                	addi	sp,sp,-32
    80006940:	ec06                	sd	ra,24(sp)
    80006942:	e822                	sd	s0,16(sp)
    80006944:	e426                	sd	s1,8(sp)
    80006946:	1000                	addi	s0,sp,32
    80006948:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000694a:	ef3ff0ef          	jal	8000683c <holding>
    8000694e:	c105                	beqz	a0,8000696e <release+0x30>
  lk->cpu = 0;
    80006950:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006954:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006958:	0310000f          	fence	rw,w
    8000695c:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006960:	f8bff0ef          	jal	800068ea <pop_off>
}
    80006964:	60e2                	ld	ra,24(sp)
    80006966:	6442                	ld	s0,16(sp)
    80006968:	64a2                	ld	s1,8(sp)
    8000696a:	6105                	addi	sp,sp,32
    8000696c:	8082                	ret
    panic("release");
    8000696e:	00002517          	auipc	a0,0x2
    80006972:	03250513          	addi	a0,a0,50 # 800089a0 <etext+0x9a0>
    80006976:	c75ff0ef          	jal	800065ea <panic>

000000008000697a <atomic_read4>:

// Read a shared 32-bit value without holding a lock
int
atomic_read4(int *addr) {
    8000697a:	1141                	addi	sp,sp,-16
    8000697c:	e422                	sd	s0,8(sp)
    8000697e:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006980:	0330000f          	fence	rw,rw
    80006984:	4108                	lw	a0,0(a0)
    80006986:	0230000f          	fence	r,rw
  return val;
}
    8000698a:	2501                	sext.w	a0,a0
    8000698c:	6422                	ld	s0,8(sp)
    8000698e:	0141                	addi	sp,sp,16
    80006990:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	9282                	jalr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
