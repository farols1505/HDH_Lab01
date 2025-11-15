
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	52013103          	ld	sp,1312(sp) # 8000a520 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7c9040ef          	jal	80004fde <start>

000000008000001a <spin>:
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
    80000030:	00024797          	auipc	a5,0x24
    80000034:	aa078793          	addi	a5,a5,-1376 # 80023ad0 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	148000ef          	jal	80000190 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	52490913          	addi	s2,s2,1316 # 8000a570 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	1eb050ef          	jal	80005a40 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	273050ef          	jal	80005ad8 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	694050ef          	jal	80005712 <panic>

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
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	49650513          	addi	a0,a0,1174 # 8000a570 <kmem>
    800000e2:	0df050ef          	jal	800059c0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00024517          	auipc	a0,0x24
    800000ee:	9e650513          	addi	a0,a0,-1562 # 80023ad0 <end>
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
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	46848493          	addi	s1,s1,1128 # 8000a570 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	12f050ef          	jal	80005a40 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	45450513          	addi	a0,a0,1108 # 8000a570 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	1b3050ef          	jal	80005ad8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	060000ef          	jal	80000190 <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	43050513          	addi	a0,a0,1072 # 8000a570 <kmem>
    80000148:	191050ef          	jal	80005ad8 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <freemem_count>:
// Return the amount of free memory (in bytes)
// Using the previously defined kmem.freelist structure

uint64
freemem_count(void)
{
    8000014e:	1101                	addi	sp,sp,-32
    80000150:	ec06                	sd	ra,24(sp)
    80000152:	e822                	sd	s0,16(sp)
    80000154:	e426                	sd	s1,8(sp)
    80000156:	1000                	addi	s0,sp,32
  uint64 count = 0;
  struct run *r;

  acquire(&kmem.lock);
    80000158:	0000a497          	auipc	s1,0xa
    8000015c:	41848493          	addi	s1,s1,1048 # 8000a570 <kmem>
    80000160:	8526                	mv	a0,s1
    80000162:	0df050ef          	jal	80005a40 <acquire>
  r = kmem.freelist;
    80000166:	6c9c                	ld	a5,24(s1)
  while(r){
    80000168:	c395                	beqz	a5,8000018c <freemem_count+0x3e>
  uint64 count = 0;
    8000016a:	4481                	li	s1,0
    count++;
    8000016c:	0485                	addi	s1,s1,1
    r = r->next;
    8000016e:	639c                	ld	a5,0(a5)
  while(r){
    80000170:	fff5                	bnez	a5,8000016c <freemem_count+0x1e>
  }
  release(&kmem.lock);
    80000172:	0000a517          	auipc	a0,0xa
    80000176:	3fe50513          	addi	a0,a0,1022 # 8000a570 <kmem>
    8000017a:	15f050ef          	jal	80005ad8 <release>

  return count * PGSIZE; // freemem in bytes
    8000017e:	00c49513          	slli	a0,s1,0xc
    80000182:	60e2                	ld	ra,24(sp)
    80000184:	6442                	ld	s0,16(sp)
    80000186:	64a2                	ld	s1,8(sp)
    80000188:	6105                	addi	sp,sp,32
    8000018a:	8082                	ret
  uint64 count = 0;
    8000018c:	4481                	li	s1,0
    8000018e:	b7d5                	j	80000172 <freemem_count+0x24>

0000000080000190 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000190:	1141                	addi	sp,sp,-16
    80000192:	e422                	sd	s0,8(sp)
    80000194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000196:	ca19                	beqz	a2,800001ac <memset+0x1c>
    80000198:	87aa                	mv	a5,a0
    8000019a:	1602                	slli	a2,a2,0x20
    8000019c:	9201                	srli	a2,a2,0x20
    8000019e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001a6:	0785                	addi	a5,a5,1
    800001a8:	fee79de3          	bne	a5,a4,800001a2 <memset+0x12>
  }
  return dst;
}
    800001ac:	6422                	ld	s0,8(sp)
    800001ae:	0141                	addi	sp,sp,16
    800001b0:	8082                	ret

00000000800001b2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001b2:	1141                	addi	sp,sp,-16
    800001b4:	e422                	sd	s0,8(sp)
    800001b6:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001b8:	ca05                	beqz	a2,800001e8 <memcmp+0x36>
    800001ba:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001be:	1682                	slli	a3,a3,0x20
    800001c0:	9281                	srli	a3,a3,0x20
    800001c2:	0685                	addi	a3,a3,1
    800001c4:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001c6:	00054783          	lbu	a5,0(a0)
    800001ca:	0005c703          	lbu	a4,0(a1)
    800001ce:	00e79863          	bne	a5,a4,800001de <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001d2:	0505                	addi	a0,a0,1
    800001d4:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001d6:	fed518e3          	bne	a0,a3,800001c6 <memcmp+0x14>
  }

  return 0;
    800001da:	4501                	li	a0,0
    800001dc:	a019                	j	800001e2 <memcmp+0x30>
      return *s1 - *s2;
    800001de:	40e7853b          	subw	a0,a5,a4
}
    800001e2:	6422                	ld	s0,8(sp)
    800001e4:	0141                	addi	sp,sp,16
    800001e6:	8082                	ret
  return 0;
    800001e8:	4501                	li	a0,0
    800001ea:	bfe5                	j	800001e2 <memcmp+0x30>

00000000800001ec <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001ec:	1141                	addi	sp,sp,-16
    800001ee:	e422                	sd	s0,8(sp)
    800001f0:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001f2:	c205                	beqz	a2,80000212 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001f4:	02a5e263          	bltu	a1,a0,80000218 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f8:	1602                	slli	a2,a2,0x20
    800001fa:	9201                	srli	a2,a2,0x20
    800001fc:	00c587b3          	add	a5,a1,a2
{
    80000200:	872a                	mv	a4,a0
      *d++ = *s++;
    80000202:	0585                	addi	a1,a1,1
    80000204:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb531>
    80000206:	fff5c683          	lbu	a3,-1(a1)
    8000020a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020e:	feb79ae3          	bne	a5,a1,80000202 <memmove+0x16>

  return dst;
}
    80000212:	6422                	ld	s0,8(sp)
    80000214:	0141                	addi	sp,sp,16
    80000216:	8082                	ret
  if(s < d && s + n > d){
    80000218:	02061693          	slli	a3,a2,0x20
    8000021c:	9281                	srli	a3,a3,0x20
    8000021e:	00d58733          	add	a4,a1,a3
    80000222:	fce57be3          	bgeu	a0,a4,800001f8 <memmove+0xc>
    d += n;
    80000226:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000228:	fff6079b          	addiw	a5,a2,-1
    8000022c:	1782                	slli	a5,a5,0x20
    8000022e:	9381                	srli	a5,a5,0x20
    80000230:	fff7c793          	not	a5,a5
    80000234:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000236:	177d                	addi	a4,a4,-1
    80000238:	16fd                	addi	a3,a3,-1
    8000023a:	00074603          	lbu	a2,0(a4)
    8000023e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000242:	fef71ae3          	bne	a4,a5,80000236 <memmove+0x4a>
    80000246:	b7f1                	j	80000212 <memmove+0x26>

0000000080000248 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e406                	sd	ra,8(sp)
    8000024c:	e022                	sd	s0,0(sp)
    8000024e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000250:	f9dff0ef          	jal	800001ec <memmove>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret

000000008000025c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000025c:	1141                	addi	sp,sp,-16
    8000025e:	e422                	sd	s0,8(sp)
    80000260:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000262:	ce11                	beqz	a2,8000027e <strncmp+0x22>
    80000264:	00054783          	lbu	a5,0(a0)
    80000268:	cf89                	beqz	a5,80000282 <strncmp+0x26>
    8000026a:	0005c703          	lbu	a4,0(a1)
    8000026e:	00f71a63          	bne	a4,a5,80000282 <strncmp+0x26>
    n--, p++, q++;
    80000272:	367d                	addiw	a2,a2,-1
    80000274:	0505                	addi	a0,a0,1
    80000276:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000278:	f675                	bnez	a2,80000264 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000027a:	4501                	li	a0,0
    8000027c:	a801                	j	8000028c <strncmp+0x30>
    8000027e:	4501                	li	a0,0
    80000280:	a031                	j	8000028c <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000282:	00054503          	lbu	a0,0(a0)
    80000286:	0005c783          	lbu	a5,0(a1)
    8000028a:	9d1d                	subw	a0,a0,a5
}
    8000028c:	6422                	ld	s0,8(sp)
    8000028e:	0141                	addi	sp,sp,16
    80000290:	8082                	ret

0000000080000292 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000292:	1141                	addi	sp,sp,-16
    80000294:	e422                	sd	s0,8(sp)
    80000296:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000298:	87aa                	mv	a5,a0
    8000029a:	86b2                	mv	a3,a2
    8000029c:	367d                	addiw	a2,a2,-1
    8000029e:	02d05563          	blez	a3,800002c8 <strncpy+0x36>
    800002a2:	0785                	addi	a5,a5,1
    800002a4:	0005c703          	lbu	a4,0(a1)
    800002a8:	fee78fa3          	sb	a4,-1(a5)
    800002ac:	0585                	addi	a1,a1,1
    800002ae:	f775                	bnez	a4,8000029a <strncpy+0x8>
    ;
  while(n-- > 0)
    800002b0:	873e                	mv	a4,a5
    800002b2:	9fb5                	addw	a5,a5,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	00c05963          	blez	a2,800002c8 <strncpy+0x36>
    *s++ = 0;
    800002ba:	0705                	addi	a4,a4,1
    800002bc:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002c0:	40e786bb          	subw	a3,a5,a4
    800002c4:	fed04be3          	bgtz	a3,800002ba <strncpy+0x28>
  return os;
}
    800002c8:	6422                	ld	s0,8(sp)
    800002ca:	0141                	addi	sp,sp,16
    800002cc:	8082                	ret

00000000800002ce <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ce:	1141                	addi	sp,sp,-16
    800002d0:	e422                	sd	s0,8(sp)
    800002d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d4:	02c05363          	blez	a2,800002fa <safestrcpy+0x2c>
    800002d8:	fff6069b          	addiw	a3,a2,-1
    800002dc:	1682                	slli	a3,a3,0x20
    800002de:	9281                	srli	a3,a3,0x20
    800002e0:	96ae                	add	a3,a3,a1
    800002e2:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e4:	00d58963          	beq	a1,a3,800002f6 <safestrcpy+0x28>
    800002e8:	0585                	addi	a1,a1,1
    800002ea:	0785                	addi	a5,a5,1
    800002ec:	fff5c703          	lbu	a4,-1(a1)
    800002f0:	fee78fa3          	sb	a4,-1(a5)
    800002f4:	fb65                	bnez	a4,800002e4 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f6:	00078023          	sb	zero,0(a5)
  return os;
}
    800002fa:	6422                	ld	s0,8(sp)
    800002fc:	0141                	addi	sp,sp,16
    800002fe:	8082                	ret

0000000080000300 <strlen>:

int
strlen(const char *s)
{
    80000300:	1141                	addi	sp,sp,-16
    80000302:	e422                	sd	s0,8(sp)
    80000304:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000306:	00054783          	lbu	a5,0(a0)
    8000030a:	cf91                	beqz	a5,80000326 <strlen+0x26>
    8000030c:	0505                	addi	a0,a0,1
    8000030e:	87aa                	mv	a5,a0
    80000310:	86be                	mv	a3,a5
    80000312:	0785                	addi	a5,a5,1
    80000314:	fff7c703          	lbu	a4,-1(a5)
    80000318:	ff65                	bnez	a4,80000310 <strlen+0x10>
    8000031a:	40a6853b          	subw	a0,a3,a0
    8000031e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000320:	6422                	ld	s0,8(sp)
    80000322:	0141                	addi	sp,sp,16
    80000324:	8082                	ret
  for(n = 0; s[n]; n++)
    80000326:	4501                	li	a0,0
    80000328:	bfe5                	j	80000320 <strlen+0x20>

000000008000032a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000032a:	1141                	addi	sp,sp,-16
    8000032c:	e406                	sd	ra,8(sp)
    8000032e:	e022                	sd	s0,0(sp)
    80000330:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000332:	25f000ef          	jal	80000d90 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	0000a717          	auipc	a4,0xa
    8000033a:	20a70713          	addi	a4,a4,522 # 8000a540 <started>
  if(cpuid() == 0){
    8000033e:	c51d                	beqz	a0,8000036c <main+0x42>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x16>
      ;
    __sync_synchronize();
    80000346:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000034a:	247000ef          	jal	80000d90 <cpuid>
    8000034e:	85aa                	mv	a1,a0
    80000350:	00007517          	auipc	a0,0x7
    80000354:	ce850513          	addi	a0,a0,-792 # 80007038 <etext+0x38>
    80000358:	0e8050ef          	jal	80005440 <printf>
    kvminithart();    // turn on paging
    8000035c:	080000ef          	jal	800003dc <kvminithart>
    trapinithart();   // install kernel trap vector
    80000360:	69a010ef          	jal	800019fa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000364:	694040ef          	jal	800049f8 <plicinithart>
  }

  scheduler();        
    80000368:	691000ef          	jal	800011f8 <scheduler>
    consoleinit();
    8000036c:	7ff040ef          	jal	8000536a <consoleinit>
    printfinit();
    80000370:	3dc050ef          	jal	8000574c <printfinit>
    printf("\n");
    80000374:	00007517          	auipc	a0,0x7
    80000378:	ca450513          	addi	a0,a0,-860 # 80007018 <etext+0x18>
    8000037c:	0c4050ef          	jal	80005440 <printf>
    printf("xv6 kernel is booting\n");
    80000380:	00007517          	auipc	a0,0x7
    80000384:	ca050513          	addi	a0,a0,-864 # 80007020 <etext+0x20>
    80000388:	0b8050ef          	jal	80005440 <printf>
    printf("\n");
    8000038c:	00007517          	auipc	a0,0x7
    80000390:	c8c50513          	addi	a0,a0,-884 # 80007018 <etext+0x18>
    80000394:	0ac050ef          	jal	80005440 <printf>
    kinit();         // physical page allocator
    80000398:	d33ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000039c:	2ca000ef          	jal	80000666 <kvminit>
    kvminithart();   // turn on paging
    800003a0:	03c000ef          	jal	800003dc <kvminithart>
    procinit();      // process table
    800003a4:	123000ef          	jal	80000cc6 <procinit>
    trapinit();      // trap vectors
    800003a8:	62e010ef          	jal	800019d6 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ac:	64e010ef          	jal	800019fa <trapinithart>
    plicinit();      // set up interrupt controller
    800003b0:	62e040ef          	jal	800049de <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003b4:	644040ef          	jal	800049f8 <plicinithart>
    binit();         // buffer cache
    800003b8:	5ed010ef          	jal	800021a4 <binit>
    iinit();         // inode table
    800003bc:	3de020ef          	jal	8000279a <iinit>
    fileinit();      // file table
    800003c0:	18a030ef          	jal	8000354a <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003c4:	724040ef          	jal	80004ae8 <virtio_disk_init>
    userinit();      // first user process
    800003c8:	45d000ef          	jal	80001024 <userinit>
    __sync_synchronize();
    800003cc:	0330000f          	fence	rw,rw
    started = 1;
    800003d0:	4785                	li	a5,1
    800003d2:	0000a717          	auipc	a4,0xa
    800003d6:	16f72723          	sw	a5,366(a4) # 8000a540 <started>
    800003da:	b779                	j	80000368 <main+0x3e>

00000000800003dc <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003dc:	1141                	addi	sp,sp,-16
    800003de:	e422                	sd	s0,8(sp)
    800003e0:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003e2:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003e6:	0000a797          	auipc	a5,0xa
    800003ea:	1627b783          	ld	a5,354(a5) # 8000a548 <kernel_pagetable>
    800003ee:	83b1                	srli	a5,a5,0xc
    800003f0:	577d                	li	a4,-1
    800003f2:	177e                	slli	a4,a4,0x3f
    800003f4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003f6:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003fa:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003fe:	6422                	ld	s0,8(sp)
    80000400:	0141                	addi	sp,sp,16
    80000402:	8082                	ret

0000000080000404 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000404:	7139                	addi	sp,sp,-64
    80000406:	fc06                	sd	ra,56(sp)
    80000408:	f822                	sd	s0,48(sp)
    8000040a:	f426                	sd	s1,40(sp)
    8000040c:	f04a                	sd	s2,32(sp)
    8000040e:	ec4e                	sd	s3,24(sp)
    80000410:	e852                	sd	s4,16(sp)
    80000412:	e456                	sd	s5,8(sp)
    80000414:	e05a                	sd	s6,0(sp)
    80000416:	0080                	addi	s0,sp,64
    80000418:	84aa                	mv	s1,a0
    8000041a:	89ae                	mv	s3,a1
    8000041c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000041e:	57fd                	li	a5,-1
    80000420:	83e9                	srli	a5,a5,0x1a
    80000422:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000424:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000426:	02b7fc63          	bgeu	a5,a1,8000045e <walk+0x5a>
    panic("walk");
    8000042a:	00007517          	auipc	a0,0x7
    8000042e:	c2650513          	addi	a0,a0,-986 # 80007050 <etext+0x50>
    80000432:	2e0050ef          	jal	80005712 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000436:	060a8263          	beqz	s5,8000049a <walk+0x96>
    8000043a:	cc5ff0ef          	jal	800000fe <kalloc>
    8000043e:	84aa                	mv	s1,a0
    80000440:	c139                	beqz	a0,80000486 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000442:	6605                	lui	a2,0x1
    80000444:	4581                	li	a1,0
    80000446:	d4bff0ef          	jal	80000190 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000044a:	00c4d793          	srli	a5,s1,0xc
    8000044e:	07aa                	slli	a5,a5,0xa
    80000450:	0017e793          	ori	a5,a5,1
    80000454:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000458:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb527>
    8000045a:	036a0063          	beq	s4,s6,8000047a <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000045e:	0149d933          	srl	s2,s3,s4
    80000462:	1ff97913          	andi	s2,s2,511
    80000466:	090e                	slli	s2,s2,0x3
    80000468:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000046a:	00093483          	ld	s1,0(s2)
    8000046e:	0014f793          	andi	a5,s1,1
    80000472:	d3f1                	beqz	a5,80000436 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000474:	80a9                	srli	s1,s1,0xa
    80000476:	04b2                	slli	s1,s1,0xc
    80000478:	b7c5                	j	80000458 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    8000047a:	00c9d513          	srli	a0,s3,0xc
    8000047e:	1ff57513          	andi	a0,a0,511
    80000482:	050e                	slli	a0,a0,0x3
    80000484:	9526                	add	a0,a0,s1
}
    80000486:	70e2                	ld	ra,56(sp)
    80000488:	7442                	ld	s0,48(sp)
    8000048a:	74a2                	ld	s1,40(sp)
    8000048c:	7902                	ld	s2,32(sp)
    8000048e:	69e2                	ld	s3,24(sp)
    80000490:	6a42                	ld	s4,16(sp)
    80000492:	6aa2                	ld	s5,8(sp)
    80000494:	6b02                	ld	s6,0(sp)
    80000496:	6121                	addi	sp,sp,64
    80000498:	8082                	ret
        return 0;
    8000049a:	4501                	li	a0,0
    8000049c:	b7ed                	j	80000486 <walk+0x82>

000000008000049e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000049e:	57fd                	li	a5,-1
    800004a0:	83e9                	srli	a5,a5,0x1a
    800004a2:	00b7f463          	bgeu	a5,a1,800004aa <walkaddr+0xc>
    return 0;
    800004a6:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800004a8:	8082                	ret
{
    800004aa:	1141                	addi	sp,sp,-16
    800004ac:	e406                	sd	ra,8(sp)
    800004ae:	e022                	sd	s0,0(sp)
    800004b0:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800004b2:	4601                	li	a2,0
    800004b4:	f51ff0ef          	jal	80000404 <walk>
  if(pte == 0)
    800004b8:	c105                	beqz	a0,800004d8 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    800004ba:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004bc:	0117f693          	andi	a3,a5,17
    800004c0:	4745                	li	a4,17
    return 0;
    800004c2:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004c4:	00e68663          	beq	a3,a4,800004d0 <walkaddr+0x32>
}
    800004c8:	60a2                	ld	ra,8(sp)
    800004ca:	6402                	ld	s0,0(sp)
    800004cc:	0141                	addi	sp,sp,16
    800004ce:	8082                	ret
  pa = PTE2PA(*pte);
    800004d0:	83a9                	srli	a5,a5,0xa
    800004d2:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004d6:	bfcd                	j	800004c8 <walkaddr+0x2a>
    return 0;
    800004d8:	4501                	li	a0,0
    800004da:	b7fd                	j	800004c8 <walkaddr+0x2a>

00000000800004dc <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004dc:	715d                	addi	sp,sp,-80
    800004de:	e486                	sd	ra,72(sp)
    800004e0:	e0a2                	sd	s0,64(sp)
    800004e2:	fc26                	sd	s1,56(sp)
    800004e4:	f84a                	sd	s2,48(sp)
    800004e6:	f44e                	sd	s3,40(sp)
    800004e8:	f052                	sd	s4,32(sp)
    800004ea:	ec56                	sd	s5,24(sp)
    800004ec:	e85a                	sd	s6,16(sp)
    800004ee:	e45e                	sd	s7,8(sp)
    800004f0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004f2:	03459793          	slli	a5,a1,0x34
    800004f6:	e7a9                	bnez	a5,80000540 <mappages+0x64>
    800004f8:	8aaa                	mv	s5,a0
    800004fa:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004fc:	03461793          	slli	a5,a2,0x34
    80000500:	e7b1                	bnez	a5,8000054c <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80000502:	ca39                	beqz	a2,80000558 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000504:	77fd                	lui	a5,0xfffff
    80000506:	963e                	add	a2,a2,a5
    80000508:	00b609b3          	add	s3,a2,a1
  a = va;
    8000050c:	892e                	mv	s2,a1
    8000050e:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000512:	6b85                	lui	s7,0x1
    80000514:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000518:	4605                	li	a2,1
    8000051a:	85ca                	mv	a1,s2
    8000051c:	8556                	mv	a0,s5
    8000051e:	ee7ff0ef          	jal	80000404 <walk>
    80000522:	c539                	beqz	a0,80000570 <mappages+0x94>
    if(*pte & PTE_V)
    80000524:	611c                	ld	a5,0(a0)
    80000526:	8b85                	andi	a5,a5,1
    80000528:	ef95                	bnez	a5,80000564 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000052a:	80b1                	srli	s1,s1,0xc
    8000052c:	04aa                	slli	s1,s1,0xa
    8000052e:	0164e4b3          	or	s1,s1,s6
    80000532:	0014e493          	ori	s1,s1,1
    80000536:	e104                	sd	s1,0(a0)
    if(a == last)
    80000538:	05390863          	beq	s2,s3,80000588 <mappages+0xac>
    a += PGSIZE;
    8000053c:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000053e:	bfd9                	j	80000514 <mappages+0x38>
    panic("mappages: va not aligned");
    80000540:	00007517          	auipc	a0,0x7
    80000544:	b1850513          	addi	a0,a0,-1256 # 80007058 <etext+0x58>
    80000548:	1ca050ef          	jal	80005712 <panic>
    panic("mappages: size not aligned");
    8000054c:	00007517          	auipc	a0,0x7
    80000550:	b2c50513          	addi	a0,a0,-1236 # 80007078 <etext+0x78>
    80000554:	1be050ef          	jal	80005712 <panic>
    panic("mappages: size");
    80000558:	00007517          	auipc	a0,0x7
    8000055c:	b4050513          	addi	a0,a0,-1216 # 80007098 <etext+0x98>
    80000560:	1b2050ef          	jal	80005712 <panic>
      panic("mappages: remap");
    80000564:	00007517          	auipc	a0,0x7
    80000568:	b4450513          	addi	a0,a0,-1212 # 800070a8 <etext+0xa8>
    8000056c:	1a6050ef          	jal	80005712 <panic>
      return -1;
    80000570:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000572:	60a6                	ld	ra,72(sp)
    80000574:	6406                	ld	s0,64(sp)
    80000576:	74e2                	ld	s1,56(sp)
    80000578:	7942                	ld	s2,48(sp)
    8000057a:	79a2                	ld	s3,40(sp)
    8000057c:	7a02                	ld	s4,32(sp)
    8000057e:	6ae2                	ld	s5,24(sp)
    80000580:	6b42                	ld	s6,16(sp)
    80000582:	6ba2                	ld	s7,8(sp)
    80000584:	6161                	addi	sp,sp,80
    80000586:	8082                	ret
  return 0;
    80000588:	4501                	li	a0,0
    8000058a:	b7e5                	j	80000572 <mappages+0x96>

000000008000058c <kvmmap>:
{
    8000058c:	1141                	addi	sp,sp,-16
    8000058e:	e406                	sd	ra,8(sp)
    80000590:	e022                	sd	s0,0(sp)
    80000592:	0800                	addi	s0,sp,16
    80000594:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000596:	86b2                	mv	a3,a2
    80000598:	863e                	mv	a2,a5
    8000059a:	f43ff0ef          	jal	800004dc <mappages>
    8000059e:	e509                	bnez	a0,800005a8 <kvmmap+0x1c>
}
    800005a0:	60a2                	ld	ra,8(sp)
    800005a2:	6402                	ld	s0,0(sp)
    800005a4:	0141                	addi	sp,sp,16
    800005a6:	8082                	ret
    panic("kvmmap");
    800005a8:	00007517          	auipc	a0,0x7
    800005ac:	b1050513          	addi	a0,a0,-1264 # 800070b8 <etext+0xb8>
    800005b0:	162050ef          	jal	80005712 <panic>

00000000800005b4 <kvmmake>:
{
    800005b4:	1101                	addi	sp,sp,-32
    800005b6:	ec06                	sd	ra,24(sp)
    800005b8:	e822                	sd	s0,16(sp)
    800005ba:	e426                	sd	s1,8(sp)
    800005bc:	e04a                	sd	s2,0(sp)
    800005be:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005c0:	b3fff0ef          	jal	800000fe <kalloc>
    800005c4:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005c6:	6605                	lui	a2,0x1
    800005c8:	4581                	li	a1,0
    800005ca:	bc7ff0ef          	jal	80000190 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005ce:	4719                	li	a4,6
    800005d0:	6685                	lui	a3,0x1
    800005d2:	10000637          	lui	a2,0x10000
    800005d6:	100005b7          	lui	a1,0x10000
    800005da:	8526                	mv	a0,s1
    800005dc:	fb1ff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005e0:	4719                	li	a4,6
    800005e2:	6685                	lui	a3,0x1
    800005e4:	10001637          	lui	a2,0x10001
    800005e8:	100015b7          	lui	a1,0x10001
    800005ec:	8526                	mv	a0,s1
    800005ee:	f9fff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005f2:	4719                	li	a4,6
    800005f4:	040006b7          	lui	a3,0x4000
    800005f8:	0c000637          	lui	a2,0xc000
    800005fc:	0c0005b7          	lui	a1,0xc000
    80000600:	8526                	mv	a0,s1
    80000602:	f8bff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000606:	00007917          	auipc	s2,0x7
    8000060a:	9fa90913          	addi	s2,s2,-1542 # 80007000 <etext>
    8000060e:	4729                	li	a4,10
    80000610:	80007697          	auipc	a3,0x80007
    80000614:	9f068693          	addi	a3,a3,-1552 # 7000 <_entry-0x7fff9000>
    80000618:	4605                	li	a2,1
    8000061a:	067e                	slli	a2,a2,0x1f
    8000061c:	85b2                	mv	a1,a2
    8000061e:	8526                	mv	a0,s1
    80000620:	f6dff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000624:	46c5                	li	a3,17
    80000626:	06ee                	slli	a3,a3,0x1b
    80000628:	4719                	li	a4,6
    8000062a:	412686b3          	sub	a3,a3,s2
    8000062e:	864a                	mv	a2,s2
    80000630:	85ca                	mv	a1,s2
    80000632:	8526                	mv	a0,s1
    80000634:	f59ff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000638:	4729                	li	a4,10
    8000063a:	6685                	lui	a3,0x1
    8000063c:	00006617          	auipc	a2,0x6
    80000640:	9c460613          	addi	a2,a2,-1596 # 80006000 <_trampoline>
    80000644:	040005b7          	lui	a1,0x4000
    80000648:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000064a:	05b2                	slli	a1,a1,0xc
    8000064c:	8526                	mv	a0,s1
    8000064e:	f3fff0ef          	jal	8000058c <kvmmap>
  proc_mapstacks(kpgtbl);
    80000652:	8526                	mv	a0,s1
    80000654:	5da000ef          	jal	80000c2e <proc_mapstacks>
}
    80000658:	8526                	mv	a0,s1
    8000065a:	60e2                	ld	ra,24(sp)
    8000065c:	6442                	ld	s0,16(sp)
    8000065e:	64a2                	ld	s1,8(sp)
    80000660:	6902                	ld	s2,0(sp)
    80000662:	6105                	addi	sp,sp,32
    80000664:	8082                	ret

0000000080000666 <kvminit>:
{
    80000666:	1141                	addi	sp,sp,-16
    80000668:	e406                	sd	ra,8(sp)
    8000066a:	e022                	sd	s0,0(sp)
    8000066c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000066e:	f47ff0ef          	jal	800005b4 <kvmmake>
    80000672:	0000a797          	auipc	a5,0xa
    80000676:	eca7bb23          	sd	a0,-298(a5) # 8000a548 <kernel_pagetable>
}
    8000067a:	60a2                	ld	ra,8(sp)
    8000067c:	6402                	ld	s0,0(sp)
    8000067e:	0141                	addi	sp,sp,16
    80000680:	8082                	ret

0000000080000682 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000682:	715d                	addi	sp,sp,-80
    80000684:	e486                	sd	ra,72(sp)
    80000686:	e0a2                	sd	s0,64(sp)
    80000688:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000068a:	03459793          	slli	a5,a1,0x34
    8000068e:	e39d                	bnez	a5,800006b4 <uvmunmap+0x32>
    80000690:	f84a                	sd	s2,48(sp)
    80000692:	f44e                	sd	s3,40(sp)
    80000694:	f052                	sd	s4,32(sp)
    80000696:	ec56                	sd	s5,24(sp)
    80000698:	e85a                	sd	s6,16(sp)
    8000069a:	e45e                	sd	s7,8(sp)
    8000069c:	8a2a                	mv	s4,a0
    8000069e:	892e                	mv	s2,a1
    800006a0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006a2:	0632                	slli	a2,a2,0xc
    800006a4:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800006a8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006aa:	6b05                	lui	s6,0x1
    800006ac:	0735ff63          	bgeu	a1,s3,8000072a <uvmunmap+0xa8>
    800006b0:	fc26                	sd	s1,56(sp)
    800006b2:	a0a9                	j	800006fc <uvmunmap+0x7a>
    800006b4:	fc26                	sd	s1,56(sp)
    800006b6:	f84a                	sd	s2,48(sp)
    800006b8:	f44e                	sd	s3,40(sp)
    800006ba:	f052                	sd	s4,32(sp)
    800006bc:	ec56                	sd	s5,24(sp)
    800006be:	e85a                	sd	s6,16(sp)
    800006c0:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006c2:	00007517          	auipc	a0,0x7
    800006c6:	9fe50513          	addi	a0,a0,-1538 # 800070c0 <etext+0xc0>
    800006ca:	048050ef          	jal	80005712 <panic>
      panic("uvmunmap: walk");
    800006ce:	00007517          	auipc	a0,0x7
    800006d2:	a0a50513          	addi	a0,a0,-1526 # 800070d8 <etext+0xd8>
    800006d6:	03c050ef          	jal	80005712 <panic>
      panic("uvmunmap: not mapped");
    800006da:	00007517          	auipc	a0,0x7
    800006de:	a0e50513          	addi	a0,a0,-1522 # 800070e8 <etext+0xe8>
    800006e2:	030050ef          	jal	80005712 <panic>
      panic("uvmunmap: not a leaf");
    800006e6:	00007517          	auipc	a0,0x7
    800006ea:	a1a50513          	addi	a0,a0,-1510 # 80007100 <etext+0x100>
    800006ee:	024050ef          	jal	80005712 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006f2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006f6:	995a                	add	s2,s2,s6
    800006f8:	03397863          	bgeu	s2,s3,80000728 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006fc:	4601                	li	a2,0
    800006fe:	85ca                	mv	a1,s2
    80000700:	8552                	mv	a0,s4
    80000702:	d03ff0ef          	jal	80000404 <walk>
    80000706:	84aa                	mv	s1,a0
    80000708:	d179                	beqz	a0,800006ce <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    8000070a:	6108                	ld	a0,0(a0)
    8000070c:	00157793          	andi	a5,a0,1
    80000710:	d7e9                	beqz	a5,800006da <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000712:	3ff57793          	andi	a5,a0,1023
    80000716:	fd7788e3          	beq	a5,s7,800006e6 <uvmunmap+0x64>
    if(do_free){
    8000071a:	fc0a8ce3          	beqz	s5,800006f2 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    8000071e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000720:	0532                	slli	a0,a0,0xc
    80000722:	8fbff0ef          	jal	8000001c <kfree>
    80000726:	b7f1                	j	800006f2 <uvmunmap+0x70>
    80000728:	74e2                	ld	s1,56(sp)
    8000072a:	7942                	ld	s2,48(sp)
    8000072c:	79a2                	ld	s3,40(sp)
    8000072e:	7a02                	ld	s4,32(sp)
    80000730:	6ae2                	ld	s5,24(sp)
    80000732:	6b42                	ld	s6,16(sp)
    80000734:	6ba2                	ld	s7,8(sp)
  }
}
    80000736:	60a6                	ld	ra,72(sp)
    80000738:	6406                	ld	s0,64(sp)
    8000073a:	6161                	addi	sp,sp,80
    8000073c:	8082                	ret

000000008000073e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000073e:	1101                	addi	sp,sp,-32
    80000740:	ec06                	sd	ra,24(sp)
    80000742:	e822                	sd	s0,16(sp)
    80000744:	e426                	sd	s1,8(sp)
    80000746:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000748:	9b7ff0ef          	jal	800000fe <kalloc>
    8000074c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000074e:	c509                	beqz	a0,80000758 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000750:	6605                	lui	a2,0x1
    80000752:	4581                	li	a1,0
    80000754:	a3dff0ef          	jal	80000190 <memset>
  return pagetable;
}
    80000758:	8526                	mv	a0,s1
    8000075a:	60e2                	ld	ra,24(sp)
    8000075c:	6442                	ld	s0,16(sp)
    8000075e:	64a2                	ld	s1,8(sp)
    80000760:	6105                	addi	sp,sp,32
    80000762:	8082                	ret

0000000080000764 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000764:	7179                	addi	sp,sp,-48
    80000766:	f406                	sd	ra,40(sp)
    80000768:	f022                	sd	s0,32(sp)
    8000076a:	ec26                	sd	s1,24(sp)
    8000076c:	e84a                	sd	s2,16(sp)
    8000076e:	e44e                	sd	s3,8(sp)
    80000770:	e052                	sd	s4,0(sp)
    80000772:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000774:	6785                	lui	a5,0x1
    80000776:	04f67063          	bgeu	a2,a5,800007b6 <uvmfirst+0x52>
    8000077a:	8a2a                	mv	s4,a0
    8000077c:	89ae                	mv	s3,a1
    8000077e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000780:	97fff0ef          	jal	800000fe <kalloc>
    80000784:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000786:	6605                	lui	a2,0x1
    80000788:	4581                	li	a1,0
    8000078a:	a07ff0ef          	jal	80000190 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000078e:	4779                	li	a4,30
    80000790:	86ca                	mv	a3,s2
    80000792:	6605                	lui	a2,0x1
    80000794:	4581                	li	a1,0
    80000796:	8552                	mv	a0,s4
    80000798:	d45ff0ef          	jal	800004dc <mappages>
  memmove(mem, src, sz);
    8000079c:	8626                	mv	a2,s1
    8000079e:	85ce                	mv	a1,s3
    800007a0:	854a                	mv	a0,s2
    800007a2:	a4bff0ef          	jal	800001ec <memmove>
}
    800007a6:	70a2                	ld	ra,40(sp)
    800007a8:	7402                	ld	s0,32(sp)
    800007aa:	64e2                	ld	s1,24(sp)
    800007ac:	6942                	ld	s2,16(sp)
    800007ae:	69a2                	ld	s3,8(sp)
    800007b0:	6a02                	ld	s4,0(sp)
    800007b2:	6145                	addi	sp,sp,48
    800007b4:	8082                	ret
    panic("uvmfirst: more than a page");
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	96250513          	addi	a0,a0,-1694 # 80007118 <etext+0x118>
    800007be:	755040ef          	jal	80005712 <panic>

00000000800007c2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007c2:	1101                	addi	sp,sp,-32
    800007c4:	ec06                	sd	ra,24(sp)
    800007c6:	e822                	sd	s0,16(sp)
    800007c8:	e426                	sd	s1,8(sp)
    800007ca:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007cc:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007ce:	00b67d63          	bgeu	a2,a1,800007e8 <uvmdealloc+0x26>
    800007d2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007d4:	6785                	lui	a5,0x1
    800007d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007d8:	00f60733          	add	a4,a2,a5
    800007dc:	76fd                	lui	a3,0xfffff
    800007de:	8f75                	and	a4,a4,a3
    800007e0:	97ae                	add	a5,a5,a1
    800007e2:	8ff5                	and	a5,a5,a3
    800007e4:	00f76863          	bltu	a4,a5,800007f4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007e8:	8526                	mv	a0,s1
    800007ea:	60e2                	ld	ra,24(sp)
    800007ec:	6442                	ld	s0,16(sp)
    800007ee:	64a2                	ld	s1,8(sp)
    800007f0:	6105                	addi	sp,sp,32
    800007f2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007f4:	8f99                	sub	a5,a5,a4
    800007f6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007f8:	4685                	li	a3,1
    800007fa:	0007861b          	sext.w	a2,a5
    800007fe:	85ba                	mv	a1,a4
    80000800:	e83ff0ef          	jal	80000682 <uvmunmap>
    80000804:	b7d5                	j	800007e8 <uvmdealloc+0x26>

0000000080000806 <uvmalloc>:
  if(newsz < oldsz)
    80000806:	08b66f63          	bltu	a2,a1,800008a4 <uvmalloc+0x9e>
{
    8000080a:	7139                	addi	sp,sp,-64
    8000080c:	fc06                	sd	ra,56(sp)
    8000080e:	f822                	sd	s0,48(sp)
    80000810:	ec4e                	sd	s3,24(sp)
    80000812:	e852                	sd	s4,16(sp)
    80000814:	e456                	sd	s5,8(sp)
    80000816:	0080                	addi	s0,sp,64
    80000818:	8aaa                	mv	s5,a0
    8000081a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000081c:	6785                	lui	a5,0x1
    8000081e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000820:	95be                	add	a1,a1,a5
    80000822:	77fd                	lui	a5,0xfffff
    80000824:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000828:	08c9f063          	bgeu	s3,a2,800008a8 <uvmalloc+0xa2>
    8000082c:	f426                	sd	s1,40(sp)
    8000082e:	f04a                	sd	s2,32(sp)
    80000830:	e05a                	sd	s6,0(sp)
    80000832:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000834:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000838:	8c7ff0ef          	jal	800000fe <kalloc>
    8000083c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000083e:	c515                	beqz	a0,8000086a <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000840:	6605                	lui	a2,0x1
    80000842:	4581                	li	a1,0
    80000844:	94dff0ef          	jal	80000190 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000848:	875a                	mv	a4,s6
    8000084a:	86a6                	mv	a3,s1
    8000084c:	6605                	lui	a2,0x1
    8000084e:	85ca                	mv	a1,s2
    80000850:	8556                	mv	a0,s5
    80000852:	c8bff0ef          	jal	800004dc <mappages>
    80000856:	e915                	bnez	a0,8000088a <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000858:	6785                	lui	a5,0x1
    8000085a:	993e                	add	s2,s2,a5
    8000085c:	fd496ee3          	bltu	s2,s4,80000838 <uvmalloc+0x32>
  return newsz;
    80000860:	8552                	mv	a0,s4
    80000862:	74a2                	ld	s1,40(sp)
    80000864:	7902                	ld	s2,32(sp)
    80000866:	6b02                	ld	s6,0(sp)
    80000868:	a811                	j	8000087c <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    8000086a:	864e                	mv	a2,s3
    8000086c:	85ca                	mv	a1,s2
    8000086e:	8556                	mv	a0,s5
    80000870:	f53ff0ef          	jal	800007c2 <uvmdealloc>
      return 0;
    80000874:	4501                	li	a0,0
    80000876:	74a2                	ld	s1,40(sp)
    80000878:	7902                	ld	s2,32(sp)
    8000087a:	6b02                	ld	s6,0(sp)
}
    8000087c:	70e2                	ld	ra,56(sp)
    8000087e:	7442                	ld	s0,48(sp)
    80000880:	69e2                	ld	s3,24(sp)
    80000882:	6a42                	ld	s4,16(sp)
    80000884:	6aa2                	ld	s5,8(sp)
    80000886:	6121                	addi	sp,sp,64
    80000888:	8082                	ret
      kfree(mem);
    8000088a:	8526                	mv	a0,s1
    8000088c:	f90ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000890:	864e                	mv	a2,s3
    80000892:	85ca                	mv	a1,s2
    80000894:	8556                	mv	a0,s5
    80000896:	f2dff0ef          	jal	800007c2 <uvmdealloc>
      return 0;
    8000089a:	4501                	li	a0,0
    8000089c:	74a2                	ld	s1,40(sp)
    8000089e:	7902                	ld	s2,32(sp)
    800008a0:	6b02                	ld	s6,0(sp)
    800008a2:	bfe9                	j	8000087c <uvmalloc+0x76>
    return oldsz;
    800008a4:	852e                	mv	a0,a1
}
    800008a6:	8082                	ret
  return newsz;
    800008a8:	8532                	mv	a0,a2
    800008aa:	bfc9                	j	8000087c <uvmalloc+0x76>

00000000800008ac <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800008ac:	7179                	addi	sp,sp,-48
    800008ae:	f406                	sd	ra,40(sp)
    800008b0:	f022                	sd	s0,32(sp)
    800008b2:	ec26                	sd	s1,24(sp)
    800008b4:	e84a                	sd	s2,16(sp)
    800008b6:	e44e                	sd	s3,8(sp)
    800008b8:	e052                	sd	s4,0(sp)
    800008ba:	1800                	addi	s0,sp,48
    800008bc:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008be:	84aa                	mv	s1,a0
    800008c0:	6905                	lui	s2,0x1
    800008c2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008c4:	4985                	li	s3,1
    800008c6:	a819                	j	800008dc <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008c8:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008ca:	00c79513          	slli	a0,a5,0xc
    800008ce:	fdfff0ef          	jal	800008ac <freewalk>
      pagetable[i] = 0;
    800008d2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008d6:	04a1                	addi	s1,s1,8
    800008d8:	01248f63          	beq	s1,s2,800008f6 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008dc:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008de:	00f7f713          	andi	a4,a5,15
    800008e2:	ff3703e3          	beq	a4,s3,800008c8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008e6:	8b85                	andi	a5,a5,1
    800008e8:	d7fd                	beqz	a5,800008d6 <freewalk+0x2a>
      panic("freewalk: leaf");
    800008ea:	00007517          	auipc	a0,0x7
    800008ee:	84e50513          	addi	a0,a0,-1970 # 80007138 <etext+0x138>
    800008f2:	621040ef          	jal	80005712 <panic>
    }
  }
  kfree((void*)pagetable);
    800008f6:	8552                	mv	a0,s4
    800008f8:	f24ff0ef          	jal	8000001c <kfree>
}
    800008fc:	70a2                	ld	ra,40(sp)
    800008fe:	7402                	ld	s0,32(sp)
    80000900:	64e2                	ld	s1,24(sp)
    80000902:	6942                	ld	s2,16(sp)
    80000904:	69a2                	ld	s3,8(sp)
    80000906:	6a02                	ld	s4,0(sp)
    80000908:	6145                	addi	sp,sp,48
    8000090a:	8082                	ret

000000008000090c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000090c:	1101                	addi	sp,sp,-32
    8000090e:	ec06                	sd	ra,24(sp)
    80000910:	e822                	sd	s0,16(sp)
    80000912:	e426                	sd	s1,8(sp)
    80000914:	1000                	addi	s0,sp,32
    80000916:	84aa                	mv	s1,a0
  if(sz > 0)
    80000918:	e989                	bnez	a1,8000092a <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000091a:	8526                	mv	a0,s1
    8000091c:	f91ff0ef          	jal	800008ac <freewalk>
}
    80000920:	60e2                	ld	ra,24(sp)
    80000922:	6442                	ld	s0,16(sp)
    80000924:	64a2                	ld	s1,8(sp)
    80000926:	6105                	addi	sp,sp,32
    80000928:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000092a:	6785                	lui	a5,0x1
    8000092c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000092e:	95be                	add	a1,a1,a5
    80000930:	4685                	li	a3,1
    80000932:	00c5d613          	srli	a2,a1,0xc
    80000936:	4581                	li	a1,0
    80000938:	d4bff0ef          	jal	80000682 <uvmunmap>
    8000093c:	bff9                	j	8000091a <uvmfree+0xe>

000000008000093e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000093e:	c65d                	beqz	a2,800009ec <uvmcopy+0xae>
{
    80000940:	715d                	addi	sp,sp,-80
    80000942:	e486                	sd	ra,72(sp)
    80000944:	e0a2                	sd	s0,64(sp)
    80000946:	fc26                	sd	s1,56(sp)
    80000948:	f84a                	sd	s2,48(sp)
    8000094a:	f44e                	sd	s3,40(sp)
    8000094c:	f052                	sd	s4,32(sp)
    8000094e:	ec56                	sd	s5,24(sp)
    80000950:	e85a                	sd	s6,16(sp)
    80000952:	e45e                	sd	s7,8(sp)
    80000954:	0880                	addi	s0,sp,80
    80000956:	8b2a                	mv	s6,a0
    80000958:	8aae                	mv	s5,a1
    8000095a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000095c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000095e:	4601                	li	a2,0
    80000960:	85ce                	mv	a1,s3
    80000962:	855a                	mv	a0,s6
    80000964:	aa1ff0ef          	jal	80000404 <walk>
    80000968:	c121                	beqz	a0,800009a8 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000096a:	6118                	ld	a4,0(a0)
    8000096c:	00177793          	andi	a5,a4,1
    80000970:	c3b1                	beqz	a5,800009b4 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000972:	00a75593          	srli	a1,a4,0xa
    80000976:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000097a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000097e:	f80ff0ef          	jal	800000fe <kalloc>
    80000982:	892a                	mv	s2,a0
    80000984:	c129                	beqz	a0,800009c6 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000986:	6605                	lui	a2,0x1
    80000988:	85de                	mv	a1,s7
    8000098a:	863ff0ef          	jal	800001ec <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000098e:	8726                	mv	a4,s1
    80000990:	86ca                	mv	a3,s2
    80000992:	6605                	lui	a2,0x1
    80000994:	85ce                	mv	a1,s3
    80000996:	8556                	mv	a0,s5
    80000998:	b45ff0ef          	jal	800004dc <mappages>
    8000099c:	e115                	bnez	a0,800009c0 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    8000099e:	6785                	lui	a5,0x1
    800009a0:	99be                	add	s3,s3,a5
    800009a2:	fb49eee3          	bltu	s3,s4,8000095e <uvmcopy+0x20>
    800009a6:	a805                	j	800009d6 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    800009a8:	00006517          	auipc	a0,0x6
    800009ac:	7a050513          	addi	a0,a0,1952 # 80007148 <etext+0x148>
    800009b0:	563040ef          	jal	80005712 <panic>
      panic("uvmcopy: page not present");
    800009b4:	00006517          	auipc	a0,0x6
    800009b8:	7b450513          	addi	a0,a0,1972 # 80007168 <etext+0x168>
    800009bc:	557040ef          	jal	80005712 <panic>
      kfree(mem);
    800009c0:	854a                	mv	a0,s2
    800009c2:	e5aff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009c6:	4685                	li	a3,1
    800009c8:	00c9d613          	srli	a2,s3,0xc
    800009cc:	4581                	li	a1,0
    800009ce:	8556                	mv	a0,s5
    800009d0:	cb3ff0ef          	jal	80000682 <uvmunmap>
  return -1;
    800009d4:	557d                	li	a0,-1
}
    800009d6:	60a6                	ld	ra,72(sp)
    800009d8:	6406                	ld	s0,64(sp)
    800009da:	74e2                	ld	s1,56(sp)
    800009dc:	7942                	ld	s2,48(sp)
    800009de:	79a2                	ld	s3,40(sp)
    800009e0:	7a02                	ld	s4,32(sp)
    800009e2:	6ae2                	ld	s5,24(sp)
    800009e4:	6b42                	ld	s6,16(sp)
    800009e6:	6ba2                	ld	s7,8(sp)
    800009e8:	6161                	addi	sp,sp,80
    800009ea:	8082                	ret
  return 0;
    800009ec:	4501                	li	a0,0
}
    800009ee:	8082                	ret

00000000800009f0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009f0:	1141                	addi	sp,sp,-16
    800009f2:	e406                	sd	ra,8(sp)
    800009f4:	e022                	sd	s0,0(sp)
    800009f6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009f8:	4601                	li	a2,0
    800009fa:	a0bff0ef          	jal	80000404 <walk>
  if(pte == 0)
    800009fe:	c901                	beqz	a0,80000a0e <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000a00:	611c                	ld	a5,0(a0)
    80000a02:	9bbd                	andi	a5,a5,-17
    80000a04:	e11c                	sd	a5,0(a0)
}
    80000a06:	60a2                	ld	ra,8(sp)
    80000a08:	6402                	ld	s0,0(sp)
    80000a0a:	0141                	addi	sp,sp,16
    80000a0c:	8082                	ret
    panic("uvmclear");
    80000a0e:	00006517          	auipc	a0,0x6
    80000a12:	77a50513          	addi	a0,a0,1914 # 80007188 <etext+0x188>
    80000a16:	4fd040ef          	jal	80005712 <panic>

0000000080000a1a <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a1a:	cad1                	beqz	a3,80000aae <copyout+0x94>
{
    80000a1c:	711d                	addi	sp,sp,-96
    80000a1e:	ec86                	sd	ra,88(sp)
    80000a20:	e8a2                	sd	s0,80(sp)
    80000a22:	e4a6                	sd	s1,72(sp)
    80000a24:	fc4e                	sd	s3,56(sp)
    80000a26:	f456                	sd	s5,40(sp)
    80000a28:	f05a                	sd	s6,32(sp)
    80000a2a:	ec5e                	sd	s7,24(sp)
    80000a2c:	1080                	addi	s0,sp,96
    80000a2e:	8baa                	mv	s7,a0
    80000a30:	8aae                	mv	s5,a1
    80000a32:	8b32                	mv	s6,a2
    80000a34:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000a36:	74fd                	lui	s1,0xfffff
    80000a38:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000a3a:	57fd                	li	a5,-1
    80000a3c:	83e9                	srli	a5,a5,0x1a
    80000a3e:	0697ea63          	bltu	a5,s1,80000ab2 <copyout+0x98>
    80000a42:	e0ca                	sd	s2,64(sp)
    80000a44:	f852                	sd	s4,48(sp)
    80000a46:	e862                	sd	s8,16(sp)
    80000a48:	e466                	sd	s9,8(sp)
    80000a4a:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a4c:	4cd5                	li	s9,21
    80000a4e:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000a50:	8c3e                	mv	s8,a5
    80000a52:	a025                	j	80000a7a <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000a54:	83a9                	srli	a5,a5,0xa
    80000a56:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a58:	409a8533          	sub	a0,s5,s1
    80000a5c:	0009061b          	sext.w	a2,s2
    80000a60:	85da                	mv	a1,s6
    80000a62:	953e                	add	a0,a0,a5
    80000a64:	f88ff0ef          	jal	800001ec <memmove>

    len -= n;
    80000a68:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a6c:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000a6e:	02098963          	beqz	s3,80000aa0 <copyout+0x86>
    if(va0 >= MAXVA)
    80000a72:	054c6263          	bltu	s8,s4,80000ab6 <copyout+0x9c>
    80000a76:	84d2                	mv	s1,s4
    80000a78:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000a7a:	4601                	li	a2,0
    80000a7c:	85a6                	mv	a1,s1
    80000a7e:	855e                	mv	a0,s7
    80000a80:	985ff0ef          	jal	80000404 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a84:	c121                	beqz	a0,80000ac4 <copyout+0xaa>
    80000a86:	611c                	ld	a5,0(a0)
    80000a88:	0157f713          	andi	a4,a5,21
    80000a8c:	05971b63          	bne	a4,s9,80000ae2 <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    80000a90:	01a48a33          	add	s4,s1,s10
    80000a94:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000a98:	fb29fee3          	bgeu	s3,s2,80000a54 <copyout+0x3a>
    80000a9c:	894e                	mv	s2,s3
    80000a9e:	bf5d                	j	80000a54 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000aa0:	4501                	li	a0,0
    80000aa2:	6906                	ld	s2,64(sp)
    80000aa4:	7a42                	ld	s4,48(sp)
    80000aa6:	6c42                	ld	s8,16(sp)
    80000aa8:	6ca2                	ld	s9,8(sp)
    80000aaa:	6d02                	ld	s10,0(sp)
    80000aac:	a015                	j	80000ad0 <copyout+0xb6>
    80000aae:	4501                	li	a0,0
}
    80000ab0:	8082                	ret
      return -1;
    80000ab2:	557d                	li	a0,-1
    80000ab4:	a831                	j	80000ad0 <copyout+0xb6>
    80000ab6:	557d                	li	a0,-1
    80000ab8:	6906                	ld	s2,64(sp)
    80000aba:	7a42                	ld	s4,48(sp)
    80000abc:	6c42                	ld	s8,16(sp)
    80000abe:	6ca2                	ld	s9,8(sp)
    80000ac0:	6d02                	ld	s10,0(sp)
    80000ac2:	a039                	j	80000ad0 <copyout+0xb6>
      return -1;
    80000ac4:	557d                	li	a0,-1
    80000ac6:	6906                	ld	s2,64(sp)
    80000ac8:	7a42                	ld	s4,48(sp)
    80000aca:	6c42                	ld	s8,16(sp)
    80000acc:	6ca2                	ld	s9,8(sp)
    80000ace:	6d02                	ld	s10,0(sp)
}
    80000ad0:	60e6                	ld	ra,88(sp)
    80000ad2:	6446                	ld	s0,80(sp)
    80000ad4:	64a6                	ld	s1,72(sp)
    80000ad6:	79e2                	ld	s3,56(sp)
    80000ad8:	7aa2                	ld	s5,40(sp)
    80000ada:	7b02                	ld	s6,32(sp)
    80000adc:	6be2                	ld	s7,24(sp)
    80000ade:	6125                	addi	sp,sp,96
    80000ae0:	8082                	ret
      return -1;
    80000ae2:	557d                	li	a0,-1
    80000ae4:	6906                	ld	s2,64(sp)
    80000ae6:	7a42                	ld	s4,48(sp)
    80000ae8:	6c42                	ld	s8,16(sp)
    80000aea:	6ca2                	ld	s9,8(sp)
    80000aec:	6d02                	ld	s10,0(sp)
    80000aee:	b7cd                	j	80000ad0 <copyout+0xb6>

0000000080000af0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000af0:	c6a5                	beqz	a3,80000b58 <copyin+0x68>
{
    80000af2:	715d                	addi	sp,sp,-80
    80000af4:	e486                	sd	ra,72(sp)
    80000af6:	e0a2                	sd	s0,64(sp)
    80000af8:	fc26                	sd	s1,56(sp)
    80000afa:	f84a                	sd	s2,48(sp)
    80000afc:	f44e                	sd	s3,40(sp)
    80000afe:	f052                	sd	s4,32(sp)
    80000b00:	ec56                	sd	s5,24(sp)
    80000b02:	e85a                	sd	s6,16(sp)
    80000b04:	e45e                	sd	s7,8(sp)
    80000b06:	e062                	sd	s8,0(sp)
    80000b08:	0880                	addi	s0,sp,80
    80000b0a:	8b2a                	mv	s6,a0
    80000b0c:	8a2e                	mv	s4,a1
    80000b0e:	8c32                	mv	s8,a2
    80000b10:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b12:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b14:	6a85                	lui	s5,0x1
    80000b16:	a00d                	j	80000b38 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b18:	018505b3          	add	a1,a0,s8
    80000b1c:	0004861b          	sext.w	a2,s1
    80000b20:	412585b3          	sub	a1,a1,s2
    80000b24:	8552                	mv	a0,s4
    80000b26:	ec6ff0ef          	jal	800001ec <memmove>

    len -= n;
    80000b2a:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b2e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b30:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b34:	02098063          	beqz	s3,80000b54 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b38:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b3c:	85ca                	mv	a1,s2
    80000b3e:	855a                	mv	a0,s6
    80000b40:	95fff0ef          	jal	8000049e <walkaddr>
    if(pa0 == 0)
    80000b44:	cd01                	beqz	a0,80000b5c <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b46:	418904b3          	sub	s1,s2,s8
    80000b4a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b4c:	fc99f6e3          	bgeu	s3,s1,80000b18 <copyin+0x28>
    80000b50:	84ce                	mv	s1,s3
    80000b52:	b7d9                	j	80000b18 <copyin+0x28>
  }
  return 0;
    80000b54:	4501                	li	a0,0
    80000b56:	a021                	j	80000b5e <copyin+0x6e>
    80000b58:	4501                	li	a0,0
}
    80000b5a:	8082                	ret
      return -1;
    80000b5c:	557d                	li	a0,-1
}
    80000b5e:	60a6                	ld	ra,72(sp)
    80000b60:	6406                	ld	s0,64(sp)
    80000b62:	74e2                	ld	s1,56(sp)
    80000b64:	7942                	ld	s2,48(sp)
    80000b66:	79a2                	ld	s3,40(sp)
    80000b68:	7a02                	ld	s4,32(sp)
    80000b6a:	6ae2                	ld	s5,24(sp)
    80000b6c:	6b42                	ld	s6,16(sp)
    80000b6e:	6ba2                	ld	s7,8(sp)
    80000b70:	6c02                	ld	s8,0(sp)
    80000b72:	6161                	addi	sp,sp,80
    80000b74:	8082                	ret

0000000080000b76 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b76:	c6dd                	beqz	a3,80000c24 <copyinstr+0xae>
{
    80000b78:	715d                	addi	sp,sp,-80
    80000b7a:	e486                	sd	ra,72(sp)
    80000b7c:	e0a2                	sd	s0,64(sp)
    80000b7e:	fc26                	sd	s1,56(sp)
    80000b80:	f84a                	sd	s2,48(sp)
    80000b82:	f44e                	sd	s3,40(sp)
    80000b84:	f052                	sd	s4,32(sp)
    80000b86:	ec56                	sd	s5,24(sp)
    80000b88:	e85a                	sd	s6,16(sp)
    80000b8a:	e45e                	sd	s7,8(sp)
    80000b8c:	0880                	addi	s0,sp,80
    80000b8e:	8a2a                	mv	s4,a0
    80000b90:	8b2e                	mv	s6,a1
    80000b92:	8bb2                	mv	s7,a2
    80000b94:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b96:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b98:	6985                	lui	s3,0x1
    80000b9a:	a825                	j	80000bd2 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b9c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ba0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ba2:	37fd                	addiw	a5,a5,-1
    80000ba4:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ba8:	60a6                	ld	ra,72(sp)
    80000baa:	6406                	ld	s0,64(sp)
    80000bac:	74e2                	ld	s1,56(sp)
    80000bae:	7942                	ld	s2,48(sp)
    80000bb0:	79a2                	ld	s3,40(sp)
    80000bb2:	7a02                	ld	s4,32(sp)
    80000bb4:	6ae2                	ld	s5,24(sp)
    80000bb6:	6b42                	ld	s6,16(sp)
    80000bb8:	6ba2                	ld	s7,8(sp)
    80000bba:	6161                	addi	sp,sp,80
    80000bbc:	8082                	ret
    80000bbe:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000bc2:	9742                	add	a4,a4,a6
      --max;
    80000bc4:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000bc8:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000bcc:	04e58463          	beq	a1,a4,80000c14 <copyinstr+0x9e>
{
    80000bd0:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000bd2:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000bd6:	85a6                	mv	a1,s1
    80000bd8:	8552                	mv	a0,s4
    80000bda:	8c5ff0ef          	jal	8000049e <walkaddr>
    if(pa0 == 0)
    80000bde:	cd0d                	beqz	a0,80000c18 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000be0:	417486b3          	sub	a3,s1,s7
    80000be4:	96ce                	add	a3,a3,s3
    if(n > max)
    80000be6:	00d97363          	bgeu	s2,a3,80000bec <copyinstr+0x76>
    80000bea:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000bec:	955e                	add	a0,a0,s7
    80000bee:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000bf0:	c695                	beqz	a3,80000c1c <copyinstr+0xa6>
    80000bf2:	87da                	mv	a5,s6
    80000bf4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000bf6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000bfa:	96da                	add	a3,a3,s6
    80000bfc:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bfe:	00f60733          	add	a4,a2,a5
    80000c02:	00074703          	lbu	a4,0(a4)
    80000c06:	db59                	beqz	a4,80000b9c <copyinstr+0x26>
        *dst = *p;
    80000c08:	00e78023          	sb	a4,0(a5)
      dst++;
    80000c0c:	0785                	addi	a5,a5,1
    while(n > 0){
    80000c0e:	fed797e3          	bne	a5,a3,80000bfc <copyinstr+0x86>
    80000c12:	b775                	j	80000bbe <copyinstr+0x48>
    80000c14:	4781                	li	a5,0
    80000c16:	b771                	j	80000ba2 <copyinstr+0x2c>
      return -1;
    80000c18:	557d                	li	a0,-1
    80000c1a:	b779                	j	80000ba8 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000c1c:	6b85                	lui	s7,0x1
    80000c1e:	9ba6                	add	s7,s7,s1
    80000c20:	87da                	mv	a5,s6
    80000c22:	b77d                	j	80000bd0 <copyinstr+0x5a>
  int got_null = 0;
    80000c24:	4781                	li	a5,0
  if(got_null){
    80000c26:	37fd                	addiw	a5,a5,-1
    80000c28:	0007851b          	sext.w	a0,a5
}
    80000c2c:	8082                	ret

0000000080000c2e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c2e:	7139                	addi	sp,sp,-64
    80000c30:	fc06                	sd	ra,56(sp)
    80000c32:	f822                	sd	s0,48(sp)
    80000c34:	f426                	sd	s1,40(sp)
    80000c36:	f04a                	sd	s2,32(sp)
    80000c38:	ec4e                	sd	s3,24(sp)
    80000c3a:	e852                	sd	s4,16(sp)
    80000c3c:	e456                	sd	s5,8(sp)
    80000c3e:	e05a                	sd	s6,0(sp)
    80000c40:	0080                	addi	s0,sp,64
    80000c42:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c44:	0000a497          	auipc	s1,0xa
    80000c48:	da448493          	addi	s1,s1,-604 # 8000a9e8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c4c:	8b26                	mv	s6,s1
    80000c4e:	ff4df937          	lui	s2,0xff4df
    80000c52:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4baeed>
    80000c56:	0936                	slli	s2,s2,0xd
    80000c58:	6f590913          	addi	s2,s2,1781
    80000c5c:	0936                	slli	s2,s2,0xd
    80000c5e:	bd390913          	addi	s2,s2,-1069
    80000c62:	0932                	slli	s2,s2,0xc
    80000c64:	7a790913          	addi	s2,s2,1959
    80000c68:	040009b7          	lui	s3,0x4000
    80000c6c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c6e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c70:	00010a97          	auipc	s5,0x10
    80000c74:	978a8a93          	addi	s5,s5,-1672 # 800105e8 <tickslock>
    char *pa = kalloc();
    80000c78:	c86ff0ef          	jal	800000fe <kalloc>
    80000c7c:	862a                	mv	a2,a0
    if(pa == 0)
    80000c7e:	cd15                	beqz	a0,80000cba <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c80:	416485b3          	sub	a1,s1,s6
    80000c84:	8591                	srai	a1,a1,0x4
    80000c86:	032585b3          	mul	a1,a1,s2
    80000c8a:	2585                	addiw	a1,a1,1
    80000c8c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c90:	4719                	li	a4,6
    80000c92:	6685                	lui	a3,0x1
    80000c94:	40b985b3          	sub	a1,s3,a1
    80000c98:	8552                	mv	a0,s4
    80000c9a:	8f3ff0ef          	jal	8000058c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c9e:	17048493          	addi	s1,s1,368
    80000ca2:	fd549be3          	bne	s1,s5,80000c78 <proc_mapstacks+0x4a>
  }
}
    80000ca6:	70e2                	ld	ra,56(sp)
    80000ca8:	7442                	ld	s0,48(sp)
    80000caa:	74a2                	ld	s1,40(sp)
    80000cac:	7902                	ld	s2,32(sp)
    80000cae:	69e2                	ld	s3,24(sp)
    80000cb0:	6a42                	ld	s4,16(sp)
    80000cb2:	6aa2                	ld	s5,8(sp)
    80000cb4:	6b02                	ld	s6,0(sp)
    80000cb6:	6121                	addi	sp,sp,64
    80000cb8:	8082                	ret
      panic("kalloc");
    80000cba:	00006517          	auipc	a0,0x6
    80000cbe:	4de50513          	addi	a0,a0,1246 # 80007198 <etext+0x198>
    80000cc2:	251040ef          	jal	80005712 <panic>

0000000080000cc6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000cc6:	7139                	addi	sp,sp,-64
    80000cc8:	fc06                	sd	ra,56(sp)
    80000cca:	f822                	sd	s0,48(sp)
    80000ccc:	f426                	sd	s1,40(sp)
    80000cce:	f04a                	sd	s2,32(sp)
    80000cd0:	ec4e                	sd	s3,24(sp)
    80000cd2:	e852                	sd	s4,16(sp)
    80000cd4:	e456                	sd	s5,8(sp)
    80000cd6:	e05a                	sd	s6,0(sp)
    80000cd8:	0080                	addi	s0,sp,64
  struct proc *p;
  initlock(&load_lock, "loadavg");
    80000cda:	00006597          	auipc	a1,0x6
    80000cde:	4c658593          	addi	a1,a1,1222 # 800071a0 <etext+0x1a0>
    80000ce2:	0000a517          	auipc	a0,0xa
    80000ce6:	8ae50513          	addi	a0,a0,-1874 # 8000a590 <load_lock>
    80000cea:	4d7040ef          	jal	800059c0 <initlock>
  initlock(&pid_lock, "nextpid");
    80000cee:	00006597          	auipc	a1,0x6
    80000cf2:	4ba58593          	addi	a1,a1,1210 # 800071a8 <etext+0x1a8>
    80000cf6:	0000a517          	auipc	a0,0xa
    80000cfa:	8b250513          	addi	a0,a0,-1870 # 8000a5a8 <pid_lock>
    80000cfe:	4c3040ef          	jal	800059c0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d02:	00006597          	auipc	a1,0x6
    80000d06:	4ae58593          	addi	a1,a1,1198 # 800071b0 <etext+0x1b0>
    80000d0a:	0000a517          	auipc	a0,0xa
    80000d0e:	8b650513          	addi	a0,a0,-1866 # 8000a5c0 <wait_lock>
    80000d12:	4af040ef          	jal	800059c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d16:	0000a497          	auipc	s1,0xa
    80000d1a:	cd248493          	addi	s1,s1,-814 # 8000a9e8 <proc>
      initlock(&p->lock, "proc");
    80000d1e:	00006b17          	auipc	s6,0x6
    80000d22:	4a2b0b13          	addi	s6,s6,1186 # 800071c0 <etext+0x1c0>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d26:	8aa6                	mv	s5,s1
    80000d28:	ff4df937          	lui	s2,0xff4df
    80000d2c:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4baeed>
    80000d30:	0936                	slli	s2,s2,0xd
    80000d32:	6f590913          	addi	s2,s2,1781
    80000d36:	0936                	slli	s2,s2,0xd
    80000d38:	bd390913          	addi	s2,s2,-1069
    80000d3c:	0932                	slli	s2,s2,0xc
    80000d3e:	7a790913          	addi	s2,s2,1959
    80000d42:	040009b7          	lui	s3,0x4000
    80000d46:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d48:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4a:	00010a17          	auipc	s4,0x10
    80000d4e:	89ea0a13          	addi	s4,s4,-1890 # 800105e8 <tickslock>
      initlock(&p->lock, "proc");
    80000d52:	85da                	mv	a1,s6
    80000d54:	8526                	mv	a0,s1
    80000d56:	46b040ef          	jal	800059c0 <initlock>
      p->state = UNUSED;
    80000d5a:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d5e:	415487b3          	sub	a5,s1,s5
    80000d62:	8791                	srai	a5,a5,0x4
    80000d64:	032787b3          	mul	a5,a5,s2
    80000d68:	2785                	addiw	a5,a5,1
    80000d6a:	00d7979b          	slliw	a5,a5,0xd
    80000d6e:	40f987b3          	sub	a5,s3,a5
    80000d72:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d74:	17048493          	addi	s1,s1,368
    80000d78:	fd449de3          	bne	s1,s4,80000d52 <procinit+0x8c>
  }
}
    80000d7c:	70e2                	ld	ra,56(sp)
    80000d7e:	7442                	ld	s0,48(sp)
    80000d80:	74a2                	ld	s1,40(sp)
    80000d82:	7902                	ld	s2,32(sp)
    80000d84:	69e2                	ld	s3,24(sp)
    80000d86:	6a42                	ld	s4,16(sp)
    80000d88:	6aa2                	ld	s5,8(sp)
    80000d8a:	6b02                	ld	s6,0(sp)
    80000d8c:	6121                	addi	sp,sp,64
    80000d8e:	8082                	ret

0000000080000d90 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d90:	1141                	addi	sp,sp,-16
    80000d92:	e422                	sd	s0,8(sp)
    80000d94:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d96:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d98:	2501                	sext.w	a0,a0
    80000d9a:	6422                	ld	s0,8(sp)
    80000d9c:	0141                	addi	sp,sp,16
    80000d9e:	8082                	ret

0000000080000da0 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000da0:	1141                	addi	sp,sp,-16
    80000da2:	e422                	sd	s0,8(sp)
    80000da4:	0800                	addi	s0,sp,16
    80000da6:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000da8:	2781                	sext.w	a5,a5
    80000daa:	079e                	slli	a5,a5,0x7
  return c;
}
    80000dac:	0000a517          	auipc	a0,0xa
    80000db0:	82c50513          	addi	a0,a0,-2004 # 8000a5d8 <cpus>
    80000db4:	953e                	add	a0,a0,a5
    80000db6:	6422                	ld	s0,8(sp)
    80000db8:	0141                	addi	sp,sp,16
    80000dba:	8082                	ret

0000000080000dbc <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000dbc:	1101                	addi	sp,sp,-32
    80000dbe:	ec06                	sd	ra,24(sp)
    80000dc0:	e822                	sd	s0,16(sp)
    80000dc2:	e426                	sd	s1,8(sp)
    80000dc4:	1000                	addi	s0,sp,32
  push_off();
    80000dc6:	43b040ef          	jal	80005a00 <push_off>
    80000dca:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000dcc:	2781                	sext.w	a5,a5
    80000dce:	079e                	slli	a5,a5,0x7
    80000dd0:	00009717          	auipc	a4,0x9
    80000dd4:	7c070713          	addi	a4,a4,1984 # 8000a590 <load_lock>
    80000dd8:	97ba                	add	a5,a5,a4
    80000dda:	67a4                	ld	s1,72(a5)
  pop_off();
    80000ddc:	4a9040ef          	jal	80005a84 <pop_off>
  return p;
}
    80000de0:	8526                	mv	a0,s1
    80000de2:	60e2                	ld	ra,24(sp)
    80000de4:	6442                	ld	s0,16(sp)
    80000de6:	64a2                	ld	s1,8(sp)
    80000de8:	6105                	addi	sp,sp,32
    80000dea:	8082                	ret

0000000080000dec <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000dec:	1141                	addi	sp,sp,-16
    80000dee:	e406                	sd	ra,8(sp)
    80000df0:	e022                	sd	s0,0(sp)
    80000df2:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000df4:	fc9ff0ef          	jal	80000dbc <myproc>
    80000df8:	4e1040ef          	jal	80005ad8 <release>

  if (first) {
    80000dfc:	00009797          	auipc	a5,0x9
    80000e00:	6d47a783          	lw	a5,1748(a5) # 8000a4d0 <first.1>
    80000e04:	e799                	bnez	a5,80000e12 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000e06:	40d000ef          	jal	80001a12 <usertrapret>
}
    80000e0a:	60a2                	ld	ra,8(sp)
    80000e0c:	6402                	ld	s0,0(sp)
    80000e0e:	0141                	addi	sp,sp,16
    80000e10:	8082                	ret
    fsinit(ROOTDEV);
    80000e12:	4505                	li	a0,1
    80000e14:	11b010ef          	jal	8000272e <fsinit>
    first = 0;
    80000e18:	00009797          	auipc	a5,0x9
    80000e1c:	6a07ac23          	sw	zero,1720(a5) # 8000a4d0 <first.1>
    __sync_synchronize();
    80000e20:	0330000f          	fence	rw,rw
    80000e24:	b7cd                	j	80000e06 <forkret+0x1a>

0000000080000e26 <allocpid>:
{
    80000e26:	1101                	addi	sp,sp,-32
    80000e28:	ec06                	sd	ra,24(sp)
    80000e2a:	e822                	sd	s0,16(sp)
    80000e2c:	e426                	sd	s1,8(sp)
    80000e2e:	e04a                	sd	s2,0(sp)
    80000e30:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e32:	00009917          	auipc	s2,0x9
    80000e36:	77690913          	addi	s2,s2,1910 # 8000a5a8 <pid_lock>
    80000e3a:	854a                	mv	a0,s2
    80000e3c:	405040ef          	jal	80005a40 <acquire>
  pid = nextpid;
    80000e40:	00009797          	auipc	a5,0x9
    80000e44:	69478793          	addi	a5,a5,1684 # 8000a4d4 <nextpid>
    80000e48:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e4a:	0014871b          	addiw	a4,s1,1
    80000e4e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e50:	854a                	mv	a0,s2
    80000e52:	487040ef          	jal	80005ad8 <release>
}
    80000e56:	8526                	mv	a0,s1
    80000e58:	60e2                	ld	ra,24(sp)
    80000e5a:	6442                	ld	s0,16(sp)
    80000e5c:	64a2                	ld	s1,8(sp)
    80000e5e:	6902                	ld	s2,0(sp)
    80000e60:	6105                	addi	sp,sp,32
    80000e62:	8082                	ret

0000000080000e64 <proc_pagetable>:
{
    80000e64:	1101                	addi	sp,sp,-32
    80000e66:	ec06                	sd	ra,24(sp)
    80000e68:	e822                	sd	s0,16(sp)
    80000e6a:	e426                	sd	s1,8(sp)
    80000e6c:	e04a                	sd	s2,0(sp)
    80000e6e:	1000                	addi	s0,sp,32
    80000e70:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e72:	8cdff0ef          	jal	8000073e <uvmcreate>
    80000e76:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e78:	cd05                	beqz	a0,80000eb0 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e7a:	4729                	li	a4,10
    80000e7c:	00005697          	auipc	a3,0x5
    80000e80:	18468693          	addi	a3,a3,388 # 80006000 <_trampoline>
    80000e84:	6605                	lui	a2,0x1
    80000e86:	040005b7          	lui	a1,0x4000
    80000e8a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e8c:	05b2                	slli	a1,a1,0xc
    80000e8e:	e4eff0ef          	jal	800004dc <mappages>
    80000e92:	02054663          	bltz	a0,80000ebe <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e96:	4719                	li	a4,6
    80000e98:	05893683          	ld	a3,88(s2)
    80000e9c:	6605                	lui	a2,0x1
    80000e9e:	020005b7          	lui	a1,0x2000
    80000ea2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ea4:	05b6                	slli	a1,a1,0xd
    80000ea6:	8526                	mv	a0,s1
    80000ea8:	e34ff0ef          	jal	800004dc <mappages>
    80000eac:	00054f63          	bltz	a0,80000eca <proc_pagetable+0x66>
}
    80000eb0:	8526                	mv	a0,s1
    80000eb2:	60e2                	ld	ra,24(sp)
    80000eb4:	6442                	ld	s0,16(sp)
    80000eb6:	64a2                	ld	s1,8(sp)
    80000eb8:	6902                	ld	s2,0(sp)
    80000eba:	6105                	addi	sp,sp,32
    80000ebc:	8082                	ret
    uvmfree(pagetable, 0);
    80000ebe:	4581                	li	a1,0
    80000ec0:	8526                	mv	a0,s1
    80000ec2:	a4bff0ef          	jal	8000090c <uvmfree>
    return 0;
    80000ec6:	4481                	li	s1,0
    80000ec8:	b7e5                	j	80000eb0 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000eca:	4681                	li	a3,0
    80000ecc:	4605                	li	a2,1
    80000ece:	040005b7          	lui	a1,0x4000
    80000ed2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ed4:	05b2                	slli	a1,a1,0xc
    80000ed6:	8526                	mv	a0,s1
    80000ed8:	faaff0ef          	jal	80000682 <uvmunmap>
    uvmfree(pagetable, 0);
    80000edc:	4581                	li	a1,0
    80000ede:	8526                	mv	a0,s1
    80000ee0:	a2dff0ef          	jal	8000090c <uvmfree>
    return 0;
    80000ee4:	4481                	li	s1,0
    80000ee6:	b7e9                	j	80000eb0 <proc_pagetable+0x4c>

0000000080000ee8 <proc_freepagetable>:
{
    80000ee8:	1101                	addi	sp,sp,-32
    80000eea:	ec06                	sd	ra,24(sp)
    80000eec:	e822                	sd	s0,16(sp)
    80000eee:	e426                	sd	s1,8(sp)
    80000ef0:	e04a                	sd	s2,0(sp)
    80000ef2:	1000                	addi	s0,sp,32
    80000ef4:	84aa                	mv	s1,a0
    80000ef6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ef8:	4681                	li	a3,0
    80000efa:	4605                	li	a2,1
    80000efc:	040005b7          	lui	a1,0x4000
    80000f00:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f02:	05b2                	slli	a1,a1,0xc
    80000f04:	f7eff0ef          	jal	80000682 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f08:	4681                	li	a3,0
    80000f0a:	4605                	li	a2,1
    80000f0c:	020005b7          	lui	a1,0x2000
    80000f10:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f12:	05b6                	slli	a1,a1,0xd
    80000f14:	8526                	mv	a0,s1
    80000f16:	f6cff0ef          	jal	80000682 <uvmunmap>
  uvmfree(pagetable, sz);
    80000f1a:	85ca                	mv	a1,s2
    80000f1c:	8526                	mv	a0,s1
    80000f1e:	9efff0ef          	jal	8000090c <uvmfree>
}
    80000f22:	60e2                	ld	ra,24(sp)
    80000f24:	6442                	ld	s0,16(sp)
    80000f26:	64a2                	ld	s1,8(sp)
    80000f28:	6902                	ld	s2,0(sp)
    80000f2a:	6105                	addi	sp,sp,32
    80000f2c:	8082                	ret

0000000080000f2e <freeproc>:
{
    80000f2e:	1101                	addi	sp,sp,-32
    80000f30:	ec06                	sd	ra,24(sp)
    80000f32:	e822                	sd	s0,16(sp)
    80000f34:	e426                	sd	s1,8(sp)
    80000f36:	1000                	addi	s0,sp,32
    80000f38:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f3a:	6d28                	ld	a0,88(a0)
    80000f3c:	c119                	beqz	a0,80000f42 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f3e:	8deff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f42:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f46:	68a8                	ld	a0,80(s1)
    80000f48:	c501                	beqz	a0,80000f50 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f4a:	64ac                	ld	a1,72(s1)
    80000f4c:	f9dff0ef          	jal	80000ee8 <proc_freepagetable>
  p->pagetable = 0;
    80000f50:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f54:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f58:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f5c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f60:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f64:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f68:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f6c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f70:	0004ac23          	sw	zero,24(s1)
}
    80000f74:	60e2                	ld	ra,24(sp)
    80000f76:	6442                	ld	s0,16(sp)
    80000f78:	64a2                	ld	s1,8(sp)
    80000f7a:	6105                	addi	sp,sp,32
    80000f7c:	8082                	ret

0000000080000f7e <allocproc>:
{
    80000f7e:	1101                	addi	sp,sp,-32
    80000f80:	ec06                	sd	ra,24(sp)
    80000f82:	e822                	sd	s0,16(sp)
    80000f84:	e426                	sd	s1,8(sp)
    80000f86:	e04a                	sd	s2,0(sp)
    80000f88:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f8a:	0000a497          	auipc	s1,0xa
    80000f8e:	a5e48493          	addi	s1,s1,-1442 # 8000a9e8 <proc>
    80000f92:	0000f917          	auipc	s2,0xf
    80000f96:	65690913          	addi	s2,s2,1622 # 800105e8 <tickslock>
    acquire(&p->lock);
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	2a5040ef          	jal	80005a40 <acquire>
    if(p->state == UNUSED) {
    80000fa0:	4c9c                	lw	a5,24(s1)
    80000fa2:	cb91                	beqz	a5,80000fb6 <allocproc+0x38>
      release(&p->lock);
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	333040ef          	jal	80005ad8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000faa:	17048493          	addi	s1,s1,368
    80000fae:	ff2496e3          	bne	s1,s2,80000f9a <allocproc+0x1c>
  return 0;
    80000fb2:	4481                	li	s1,0
    80000fb4:	a089                	j	80000ff6 <allocproc+0x78>
  p->pid = allocpid();
    80000fb6:	e71ff0ef          	jal	80000e26 <allocpid>
    80000fba:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000fbc:	4785                	li	a5,1
    80000fbe:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fc0:	93eff0ef          	jal	800000fe <kalloc>
    80000fc4:	892a                	mv	s2,a0
    80000fc6:	eca8                	sd	a0,88(s1)
    80000fc8:	cd15                	beqz	a0,80001004 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000fca:	8526                	mv	a0,s1
    80000fcc:	e99ff0ef          	jal	80000e64 <proc_pagetable>
    80000fd0:	892a                	mv	s2,a0
    80000fd2:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000fd4:	c121                	beqz	a0,80001014 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000fd6:	07000613          	li	a2,112
    80000fda:	4581                	li	a1,0
    80000fdc:	06048513          	addi	a0,s1,96
    80000fe0:	9b0ff0ef          	jal	80000190 <memset>
  p->context.ra = (uint64)forkret;
    80000fe4:	00000797          	auipc	a5,0x0
    80000fe8:	e0878793          	addi	a5,a5,-504 # 80000dec <forkret>
    80000fec:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000fee:	60bc                	ld	a5,64(s1)
    80000ff0:	6705                	lui	a4,0x1
    80000ff2:	97ba                	add	a5,a5,a4
    80000ff4:	f4bc                	sd	a5,104(s1)
}
    80000ff6:	8526                	mv	a0,s1
    80000ff8:	60e2                	ld	ra,24(sp)
    80000ffa:	6442                	ld	s0,16(sp)
    80000ffc:	64a2                	ld	s1,8(sp)
    80000ffe:	6902                	ld	s2,0(sp)
    80001000:	6105                	addi	sp,sp,32
    80001002:	8082                	ret
    freeproc(p);
    80001004:	8526                	mv	a0,s1
    80001006:	f29ff0ef          	jal	80000f2e <freeproc>
    release(&p->lock);
    8000100a:	8526                	mv	a0,s1
    8000100c:	2cd040ef          	jal	80005ad8 <release>
    return 0;
    80001010:	84ca                	mv	s1,s2
    80001012:	b7d5                	j	80000ff6 <allocproc+0x78>
    freeproc(p);
    80001014:	8526                	mv	a0,s1
    80001016:	f19ff0ef          	jal	80000f2e <freeproc>
    release(&p->lock);
    8000101a:	8526                	mv	a0,s1
    8000101c:	2bd040ef          	jal	80005ad8 <release>
    return 0;
    80001020:	84ca                	mv	s1,s2
    80001022:	bfd1                	j	80000ff6 <allocproc+0x78>

0000000080001024 <userinit>:
{
    80001024:	1101                	addi	sp,sp,-32
    80001026:	ec06                	sd	ra,24(sp)
    80001028:	e822                	sd	s0,16(sp)
    8000102a:	e426                	sd	s1,8(sp)
    8000102c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000102e:	f51ff0ef          	jal	80000f7e <allocproc>
    80001032:	84aa                	mv	s1,a0
  initproc = p;
    80001034:	00009797          	auipc	a5,0x9
    80001038:	50a7be23          	sd	a0,1308(a5) # 8000a550 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000103c:	03400613          	li	a2,52
    80001040:	00009597          	auipc	a1,0x9
    80001044:	4a058593          	addi	a1,a1,1184 # 8000a4e0 <initcode>
    80001048:	6928                	ld	a0,80(a0)
    8000104a:	f1aff0ef          	jal	80000764 <uvmfirst>
  p->sz = PGSIZE;
    8000104e:	6785                	lui	a5,0x1
    80001050:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001052:	6cb8                	ld	a4,88(s1)
    80001054:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001058:	6cb8                	ld	a4,88(s1)
    8000105a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000105c:	4641                	li	a2,16
    8000105e:	00006597          	auipc	a1,0x6
    80001062:	16a58593          	addi	a1,a1,362 # 800071c8 <etext+0x1c8>
    80001066:	15848513          	addi	a0,s1,344
    8000106a:	a64ff0ef          	jal	800002ce <safestrcpy>
  p->cwd = namei("/");
    8000106e:	00006517          	auipc	a0,0x6
    80001072:	16a50513          	addi	a0,a0,362 # 800071d8 <etext+0x1d8>
    80001076:	7c7010ef          	jal	8000303c <namei>
    8000107a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000107e:	478d                	li	a5,3
    80001080:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001082:	8526                	mv	a0,s1
    80001084:	255040ef          	jal	80005ad8 <release>
}
    80001088:	60e2                	ld	ra,24(sp)
    8000108a:	6442                	ld	s0,16(sp)
    8000108c:	64a2                	ld	s1,8(sp)
    8000108e:	6105                	addi	sp,sp,32
    80001090:	8082                	ret

0000000080001092 <growproc>:
{
    80001092:	1101                	addi	sp,sp,-32
    80001094:	ec06                	sd	ra,24(sp)
    80001096:	e822                	sd	s0,16(sp)
    80001098:	e426                	sd	s1,8(sp)
    8000109a:	e04a                	sd	s2,0(sp)
    8000109c:	1000                	addi	s0,sp,32
    8000109e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800010a0:	d1dff0ef          	jal	80000dbc <myproc>
    800010a4:	84aa                	mv	s1,a0
  sz = p->sz;
    800010a6:	652c                	ld	a1,72(a0)
  if(n > 0){
    800010a8:	01204c63          	bgtz	s2,800010c0 <growproc+0x2e>
  } else if(n < 0){
    800010ac:	02094463          	bltz	s2,800010d4 <growproc+0x42>
  p->sz = sz;
    800010b0:	e4ac                	sd	a1,72(s1)
  return 0;
    800010b2:	4501                	li	a0,0
}
    800010b4:	60e2                	ld	ra,24(sp)
    800010b6:	6442                	ld	s0,16(sp)
    800010b8:	64a2                	ld	s1,8(sp)
    800010ba:	6902                	ld	s2,0(sp)
    800010bc:	6105                	addi	sp,sp,32
    800010be:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010c0:	4691                	li	a3,4
    800010c2:	00b90633          	add	a2,s2,a1
    800010c6:	6928                	ld	a0,80(a0)
    800010c8:	f3eff0ef          	jal	80000806 <uvmalloc>
    800010cc:	85aa                	mv	a1,a0
    800010ce:	f16d                	bnez	a0,800010b0 <growproc+0x1e>
      return -1;
    800010d0:	557d                	li	a0,-1
    800010d2:	b7cd                	j	800010b4 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010d4:	00b90633          	add	a2,s2,a1
    800010d8:	6928                	ld	a0,80(a0)
    800010da:	ee8ff0ef          	jal	800007c2 <uvmdealloc>
    800010de:	85aa                	mv	a1,a0
    800010e0:	bfc1                	j	800010b0 <growproc+0x1e>

00000000800010e2 <fork>:
{
    800010e2:	7139                	addi	sp,sp,-64
    800010e4:	fc06                	sd	ra,56(sp)
    800010e6:	f822                	sd	s0,48(sp)
    800010e8:	f04a                	sd	s2,32(sp)
    800010ea:	e456                	sd	s5,8(sp)
    800010ec:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010ee:	ccfff0ef          	jal	80000dbc <myproc>
    800010f2:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010f4:	e8bff0ef          	jal	80000f7e <allocproc>
    800010f8:	0e050e63          	beqz	a0,800011f4 <fork+0x112>
    800010fc:	ec4e                	sd	s3,24(sp)
    800010fe:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001100:	048ab603          	ld	a2,72(s5)
    80001104:	692c                	ld	a1,80(a0)
    80001106:	050ab503          	ld	a0,80(s5)
    8000110a:	835ff0ef          	jal	8000093e <uvmcopy>
    8000110e:	04054e63          	bltz	a0,8000116a <fork+0x88>
    80001112:	f426                	sd	s1,40(sp)
    80001114:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001116:	048ab783          	ld	a5,72(s5)
    8000111a:	04f9b423          	sd	a5,72(s3)
  np->trace_mask = p->trace_mask; // Tracing Inheritance from p to np
    8000111e:	168aa783          	lw	a5,360(s5)
    80001122:	16f9a423          	sw	a5,360(s3)
  *(np->trapframe) = *(p->trapframe);
    80001126:	058ab683          	ld	a3,88(s5)
    8000112a:	87b6                	mv	a5,a3
    8000112c:	0589b703          	ld	a4,88(s3)
    80001130:	12068693          	addi	a3,a3,288
    80001134:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001138:	6788                	ld	a0,8(a5)
    8000113a:	6b8c                	ld	a1,16(a5)
    8000113c:	6f90                	ld	a2,24(a5)
    8000113e:	01073023          	sd	a6,0(a4)
    80001142:	e708                	sd	a0,8(a4)
    80001144:	eb0c                	sd	a1,16(a4)
    80001146:	ef10                	sd	a2,24(a4)
    80001148:	02078793          	addi	a5,a5,32
    8000114c:	02070713          	addi	a4,a4,32
    80001150:	fed792e3          	bne	a5,a3,80001134 <fork+0x52>
  np->trapframe->a0 = 0;
    80001154:	0589b783          	ld	a5,88(s3)
    80001158:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000115c:	0d0a8493          	addi	s1,s5,208
    80001160:	0d098913          	addi	s2,s3,208
    80001164:	150a8a13          	addi	s4,s5,336
    80001168:	a831                	j	80001184 <fork+0xa2>
    freeproc(np);
    8000116a:	854e                	mv	a0,s3
    8000116c:	dc3ff0ef          	jal	80000f2e <freeproc>
    release(&np->lock);
    80001170:	854e                	mv	a0,s3
    80001172:	167040ef          	jal	80005ad8 <release>
    return -1;
    80001176:	597d                	li	s2,-1
    80001178:	69e2                	ld	s3,24(sp)
    8000117a:	a0b5                	j	800011e6 <fork+0x104>
  for(i = 0; i < NOFILE; i++)
    8000117c:	04a1                	addi	s1,s1,8
    8000117e:	0921                	addi	s2,s2,8
    80001180:	01448963          	beq	s1,s4,80001192 <fork+0xb0>
    if(p->ofile[i])
    80001184:	6088                	ld	a0,0(s1)
    80001186:	d97d                	beqz	a0,8000117c <fork+0x9a>
      np->ofile[i] = filedup(p->ofile[i]);
    80001188:	444020ef          	jal	800035cc <filedup>
    8000118c:	00a93023          	sd	a0,0(s2)
    80001190:	b7f5                	j	8000117c <fork+0x9a>
  np->cwd = idup(p->cwd);
    80001192:	150ab503          	ld	a0,336(s5)
    80001196:	796010ef          	jal	8000292c <idup>
    8000119a:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000119e:	4641                	li	a2,16
    800011a0:	158a8593          	addi	a1,s5,344
    800011a4:	15898513          	addi	a0,s3,344
    800011a8:	926ff0ef          	jal	800002ce <safestrcpy>
  pid = np->pid;
    800011ac:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    800011b0:	854e                	mv	a0,s3
    800011b2:	127040ef          	jal	80005ad8 <release>
  acquire(&wait_lock);
    800011b6:	00009497          	auipc	s1,0x9
    800011ba:	40a48493          	addi	s1,s1,1034 # 8000a5c0 <wait_lock>
    800011be:	8526                	mv	a0,s1
    800011c0:	081040ef          	jal	80005a40 <acquire>
  np->parent = p;
    800011c4:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    800011c8:	8526                	mv	a0,s1
    800011ca:	10f040ef          	jal	80005ad8 <release>
  acquire(&np->lock);
    800011ce:	854e                	mv	a0,s3
    800011d0:	071040ef          	jal	80005a40 <acquire>
  np->state = RUNNABLE;
    800011d4:	478d                	li	a5,3
    800011d6:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800011da:	854e                	mv	a0,s3
    800011dc:	0fd040ef          	jal	80005ad8 <release>
  return pid;
    800011e0:	74a2                	ld	s1,40(sp)
    800011e2:	69e2                	ld	s3,24(sp)
    800011e4:	6a42                	ld	s4,16(sp)
}
    800011e6:	854a                	mv	a0,s2
    800011e8:	70e2                	ld	ra,56(sp)
    800011ea:	7442                	ld	s0,48(sp)
    800011ec:	7902                	ld	s2,32(sp)
    800011ee:	6aa2                	ld	s5,8(sp)
    800011f0:	6121                	addi	sp,sp,64
    800011f2:	8082                	ret
    return -1;
    800011f4:	597d                	li	s2,-1
    800011f6:	bfc5                	j	800011e6 <fork+0x104>

00000000800011f8 <scheduler>:
{
    800011f8:	715d                	addi	sp,sp,-80
    800011fa:	e486                	sd	ra,72(sp)
    800011fc:	e0a2                	sd	s0,64(sp)
    800011fe:	fc26                	sd	s1,56(sp)
    80001200:	f84a                	sd	s2,48(sp)
    80001202:	f44e                	sd	s3,40(sp)
    80001204:	f052                	sd	s4,32(sp)
    80001206:	ec56                	sd	s5,24(sp)
    80001208:	e85a                	sd	s6,16(sp)
    8000120a:	e45e                	sd	s7,8(sp)
    8000120c:	e062                	sd	s8,0(sp)
    8000120e:	0880                	addi	s0,sp,80
    80001210:	8792                	mv	a5,tp
  int id = r_tp();
    80001212:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001214:	00779b13          	slli	s6,a5,0x7
    80001218:	00009717          	auipc	a4,0x9
    8000121c:	37870713          	addi	a4,a4,888 # 8000a590 <load_lock>
    80001220:	975a                	add	a4,a4,s6
    80001222:	04073423          	sd	zero,72(a4)
        swtch(&c->context, &p->context);
    80001226:	00009717          	auipc	a4,0x9
    8000122a:	3ba70713          	addi	a4,a4,954 # 8000a5e0 <cpus+0x8>
    8000122e:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001230:	4c11                	li	s8,4
        c->proc = p;
    80001232:	079e                	slli	a5,a5,0x7
    80001234:	00009a17          	auipc	s4,0x9
    80001238:	35ca0a13          	addi	s4,s4,860 # 8000a590 <load_lock>
    8000123c:	9a3e                	add	s4,s4,a5
        found = 1;
    8000123e:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001240:	0000f997          	auipc	s3,0xf
    80001244:	3a898993          	addi	s3,s3,936 # 800105e8 <tickslock>
    80001248:	a0a9                	j	80001292 <scheduler+0x9a>
      release(&p->lock);
    8000124a:	8526                	mv	a0,s1
    8000124c:	08d040ef          	jal	80005ad8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001250:	17048493          	addi	s1,s1,368
    80001254:	03348563          	beq	s1,s3,8000127e <scheduler+0x86>
      acquire(&p->lock);
    80001258:	8526                	mv	a0,s1
    8000125a:	7e6040ef          	jal	80005a40 <acquire>
      if(p->state == RUNNABLE) {
    8000125e:	4c9c                	lw	a5,24(s1)
    80001260:	ff2795e3          	bne	a5,s2,8000124a <scheduler+0x52>
        p->state = RUNNING;
    80001264:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001268:	049a3423          	sd	s1,72(s4)
        swtch(&c->context, &p->context);
    8000126c:	06048593          	addi	a1,s1,96
    80001270:	855a                	mv	a0,s6
    80001272:	6fa000ef          	jal	8000196c <swtch>
        c->proc = 0;
    80001276:	040a3423          	sd	zero,72(s4)
        found = 1;
    8000127a:	8ade                	mv	s5,s7
    8000127c:	b7f9                	j	8000124a <scheduler+0x52>
    if(found == 0) {
    8000127e:	000a9a63          	bnez	s5,80001292 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001282:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001286:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000128a:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000128e:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001292:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001296:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000129a:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000129e:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800012a0:	00009497          	auipc	s1,0x9
    800012a4:	74848493          	addi	s1,s1,1864 # 8000a9e8 <proc>
      if(p->state == RUNNABLE) {
    800012a8:	490d                	li	s2,3
    800012aa:	b77d                	j	80001258 <scheduler+0x60>

00000000800012ac <sched>:
{
    800012ac:	7179                	addi	sp,sp,-48
    800012ae:	f406                	sd	ra,40(sp)
    800012b0:	f022                	sd	s0,32(sp)
    800012b2:	ec26                	sd	s1,24(sp)
    800012b4:	e84a                	sd	s2,16(sp)
    800012b6:	e44e                	sd	s3,8(sp)
    800012b8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012ba:	b03ff0ef          	jal	80000dbc <myproc>
    800012be:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012c0:	716040ef          	jal	800059d6 <holding>
    800012c4:	c92d                	beqz	a0,80001336 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012c6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012c8:	2781                	sext.w	a5,a5
    800012ca:	079e                	slli	a5,a5,0x7
    800012cc:	00009717          	auipc	a4,0x9
    800012d0:	2c470713          	addi	a4,a4,708 # 8000a590 <load_lock>
    800012d4:	97ba                	add	a5,a5,a4
    800012d6:	0c07a703          	lw	a4,192(a5)
    800012da:	4785                	li	a5,1
    800012dc:	06f71363          	bne	a4,a5,80001342 <sched+0x96>
  if(p->state == RUNNING)
    800012e0:	4c98                	lw	a4,24(s1)
    800012e2:	4791                	li	a5,4
    800012e4:	06f70563          	beq	a4,a5,8000134e <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012e8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012ec:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012ee:	e7b5                	bnez	a5,8000135a <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012f0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012f2:	00009917          	auipc	s2,0x9
    800012f6:	29e90913          	addi	s2,s2,670 # 8000a590 <load_lock>
    800012fa:	2781                	sext.w	a5,a5
    800012fc:	079e                	slli	a5,a5,0x7
    800012fe:	97ca                	add	a5,a5,s2
    80001300:	0c47a983          	lw	s3,196(a5)
    80001304:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001306:	2781                	sext.w	a5,a5
    80001308:	079e                	slli	a5,a5,0x7
    8000130a:	00009597          	auipc	a1,0x9
    8000130e:	2d658593          	addi	a1,a1,726 # 8000a5e0 <cpus+0x8>
    80001312:	95be                	add	a1,a1,a5
    80001314:	06048513          	addi	a0,s1,96
    80001318:	654000ef          	jal	8000196c <swtch>
    8000131c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000131e:	2781                	sext.w	a5,a5
    80001320:	079e                	slli	a5,a5,0x7
    80001322:	993e                	add	s2,s2,a5
    80001324:	0d392223          	sw	s3,196(s2)
}
    80001328:	70a2                	ld	ra,40(sp)
    8000132a:	7402                	ld	s0,32(sp)
    8000132c:	64e2                	ld	s1,24(sp)
    8000132e:	6942                	ld	s2,16(sp)
    80001330:	69a2                	ld	s3,8(sp)
    80001332:	6145                	addi	sp,sp,48
    80001334:	8082                	ret
    panic("sched p->lock");
    80001336:	00006517          	auipc	a0,0x6
    8000133a:	eaa50513          	addi	a0,a0,-342 # 800071e0 <etext+0x1e0>
    8000133e:	3d4040ef          	jal	80005712 <panic>
    panic("sched locks");
    80001342:	00006517          	auipc	a0,0x6
    80001346:	eae50513          	addi	a0,a0,-338 # 800071f0 <etext+0x1f0>
    8000134a:	3c8040ef          	jal	80005712 <panic>
    panic("sched running");
    8000134e:	00006517          	auipc	a0,0x6
    80001352:	eb250513          	addi	a0,a0,-334 # 80007200 <etext+0x200>
    80001356:	3bc040ef          	jal	80005712 <panic>
    panic("sched interruptible");
    8000135a:	00006517          	auipc	a0,0x6
    8000135e:	eb650513          	addi	a0,a0,-330 # 80007210 <etext+0x210>
    80001362:	3b0040ef          	jal	80005712 <panic>

0000000080001366 <yield>:
{
    80001366:	1101                	addi	sp,sp,-32
    80001368:	ec06                	sd	ra,24(sp)
    8000136a:	e822                	sd	s0,16(sp)
    8000136c:	e426                	sd	s1,8(sp)
    8000136e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001370:	a4dff0ef          	jal	80000dbc <myproc>
    80001374:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001376:	6ca040ef          	jal	80005a40 <acquire>
  p->state = RUNNABLE;
    8000137a:	478d                	li	a5,3
    8000137c:	cc9c                	sw	a5,24(s1)
  sched();
    8000137e:	f2fff0ef          	jal	800012ac <sched>
  release(&p->lock);
    80001382:	8526                	mv	a0,s1
    80001384:	754040ef          	jal	80005ad8 <release>
}
    80001388:	60e2                	ld	ra,24(sp)
    8000138a:	6442                	ld	s0,16(sp)
    8000138c:	64a2                	ld	s1,8(sp)
    8000138e:	6105                	addi	sp,sp,32
    80001390:	8082                	ret

0000000080001392 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001392:	7179                	addi	sp,sp,-48
    80001394:	f406                	sd	ra,40(sp)
    80001396:	f022                	sd	s0,32(sp)
    80001398:	ec26                	sd	s1,24(sp)
    8000139a:	e84a                	sd	s2,16(sp)
    8000139c:	e44e                	sd	s3,8(sp)
    8000139e:	1800                	addi	s0,sp,48
    800013a0:	89aa                	mv	s3,a0
    800013a2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800013a4:	a19ff0ef          	jal	80000dbc <myproc>
    800013a8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800013aa:	696040ef          	jal	80005a40 <acquire>
  release(lk);
    800013ae:	854a                	mv	a0,s2
    800013b0:	728040ef          	jal	80005ad8 <release>

  // Go to sleep.
  p->chan = chan;
    800013b4:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800013b8:	4789                	li	a5,2
    800013ba:	cc9c                	sw	a5,24(s1)

  sched();
    800013bc:	ef1ff0ef          	jal	800012ac <sched>

  // Tidy up.
  p->chan = 0;
    800013c0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013c4:	8526                	mv	a0,s1
    800013c6:	712040ef          	jal	80005ad8 <release>
  acquire(lk);
    800013ca:	854a                	mv	a0,s2
    800013cc:	674040ef          	jal	80005a40 <acquire>
}
    800013d0:	70a2                	ld	ra,40(sp)
    800013d2:	7402                	ld	s0,32(sp)
    800013d4:	64e2                	ld	s1,24(sp)
    800013d6:	6942                	ld	s2,16(sp)
    800013d8:	69a2                	ld	s3,8(sp)
    800013da:	6145                	addi	sp,sp,48
    800013dc:	8082                	ret

00000000800013de <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800013de:	7139                	addi	sp,sp,-64
    800013e0:	fc06                	sd	ra,56(sp)
    800013e2:	f822                	sd	s0,48(sp)
    800013e4:	f426                	sd	s1,40(sp)
    800013e6:	f04a                	sd	s2,32(sp)
    800013e8:	ec4e                	sd	s3,24(sp)
    800013ea:	e852                	sd	s4,16(sp)
    800013ec:	e456                	sd	s5,8(sp)
    800013ee:	0080                	addi	s0,sp,64
    800013f0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013f2:	00009497          	auipc	s1,0x9
    800013f6:	5f648493          	addi	s1,s1,1526 # 8000a9e8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013fa:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013fc:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013fe:	0000f917          	auipc	s2,0xf
    80001402:	1ea90913          	addi	s2,s2,490 # 800105e8 <tickslock>
    80001406:	a801                	j	80001416 <wakeup+0x38>
      }
      release(&p->lock);
    80001408:	8526                	mv	a0,s1
    8000140a:	6ce040ef          	jal	80005ad8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000140e:	17048493          	addi	s1,s1,368
    80001412:	03248263          	beq	s1,s2,80001436 <wakeup+0x58>
    if(p != myproc()){
    80001416:	9a7ff0ef          	jal	80000dbc <myproc>
    8000141a:	fea48ae3          	beq	s1,a0,8000140e <wakeup+0x30>
      acquire(&p->lock);
    8000141e:	8526                	mv	a0,s1
    80001420:	620040ef          	jal	80005a40 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001424:	4c9c                	lw	a5,24(s1)
    80001426:	ff3791e3          	bne	a5,s3,80001408 <wakeup+0x2a>
    8000142a:	709c                	ld	a5,32(s1)
    8000142c:	fd479ee3          	bne	a5,s4,80001408 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001430:	0154ac23          	sw	s5,24(s1)
    80001434:	bfd1                	j	80001408 <wakeup+0x2a>
    }
  }
}
    80001436:	70e2                	ld	ra,56(sp)
    80001438:	7442                	ld	s0,48(sp)
    8000143a:	74a2                	ld	s1,40(sp)
    8000143c:	7902                	ld	s2,32(sp)
    8000143e:	69e2                	ld	s3,24(sp)
    80001440:	6a42                	ld	s4,16(sp)
    80001442:	6aa2                	ld	s5,8(sp)
    80001444:	6121                	addi	sp,sp,64
    80001446:	8082                	ret

0000000080001448 <reparent>:
{
    80001448:	7179                	addi	sp,sp,-48
    8000144a:	f406                	sd	ra,40(sp)
    8000144c:	f022                	sd	s0,32(sp)
    8000144e:	ec26                	sd	s1,24(sp)
    80001450:	e84a                	sd	s2,16(sp)
    80001452:	e44e                	sd	s3,8(sp)
    80001454:	e052                	sd	s4,0(sp)
    80001456:	1800                	addi	s0,sp,48
    80001458:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000145a:	00009497          	auipc	s1,0x9
    8000145e:	58e48493          	addi	s1,s1,1422 # 8000a9e8 <proc>
      pp->parent = initproc;
    80001462:	00009a17          	auipc	s4,0x9
    80001466:	0eea0a13          	addi	s4,s4,238 # 8000a550 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000146a:	0000f997          	auipc	s3,0xf
    8000146e:	17e98993          	addi	s3,s3,382 # 800105e8 <tickslock>
    80001472:	a029                	j	8000147c <reparent+0x34>
    80001474:	17048493          	addi	s1,s1,368
    80001478:	01348b63          	beq	s1,s3,8000148e <reparent+0x46>
    if(pp->parent == p){
    8000147c:	7c9c                	ld	a5,56(s1)
    8000147e:	ff279be3          	bne	a5,s2,80001474 <reparent+0x2c>
      pp->parent = initproc;
    80001482:	000a3503          	ld	a0,0(s4)
    80001486:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001488:	f57ff0ef          	jal	800013de <wakeup>
    8000148c:	b7e5                	j	80001474 <reparent+0x2c>
}
    8000148e:	70a2                	ld	ra,40(sp)
    80001490:	7402                	ld	s0,32(sp)
    80001492:	64e2                	ld	s1,24(sp)
    80001494:	6942                	ld	s2,16(sp)
    80001496:	69a2                	ld	s3,8(sp)
    80001498:	6a02                	ld	s4,0(sp)
    8000149a:	6145                	addi	sp,sp,48
    8000149c:	8082                	ret

000000008000149e <exit>:
{
    8000149e:	7179                	addi	sp,sp,-48
    800014a0:	f406                	sd	ra,40(sp)
    800014a2:	f022                	sd	s0,32(sp)
    800014a4:	ec26                	sd	s1,24(sp)
    800014a6:	e84a                	sd	s2,16(sp)
    800014a8:	e44e                	sd	s3,8(sp)
    800014aa:	e052                	sd	s4,0(sp)
    800014ac:	1800                	addi	s0,sp,48
    800014ae:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800014b0:	90dff0ef          	jal	80000dbc <myproc>
    800014b4:	89aa                	mv	s3,a0
  if(p == initproc)
    800014b6:	00009797          	auipc	a5,0x9
    800014ba:	09a7b783          	ld	a5,154(a5) # 8000a550 <initproc>
    800014be:	0d050493          	addi	s1,a0,208
    800014c2:	15050913          	addi	s2,a0,336
    800014c6:	00a79f63          	bne	a5,a0,800014e4 <exit+0x46>
    panic("init exiting");
    800014ca:	00006517          	auipc	a0,0x6
    800014ce:	d5e50513          	addi	a0,a0,-674 # 80007228 <etext+0x228>
    800014d2:	240040ef          	jal	80005712 <panic>
      fileclose(f);
    800014d6:	13c020ef          	jal	80003612 <fileclose>
      p->ofile[fd] = 0;
    800014da:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014de:	04a1                	addi	s1,s1,8
    800014e0:	01248563          	beq	s1,s2,800014ea <exit+0x4c>
    if(p->ofile[fd]){
    800014e4:	6088                	ld	a0,0(s1)
    800014e6:	f965                	bnez	a0,800014d6 <exit+0x38>
    800014e8:	bfdd                	j	800014de <exit+0x40>
  begin_op();
    800014ea:	50f010ef          	jal	800031f8 <begin_op>
  iput(p->cwd);
    800014ee:	1509b503          	ld	a0,336(s3)
    800014f2:	5f2010ef          	jal	80002ae4 <iput>
  end_op();
    800014f6:	56d010ef          	jal	80003262 <end_op>
  p->cwd = 0;
    800014fa:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014fe:	00009497          	auipc	s1,0x9
    80001502:	0c248493          	addi	s1,s1,194 # 8000a5c0 <wait_lock>
    80001506:	8526                	mv	a0,s1
    80001508:	538040ef          	jal	80005a40 <acquire>
  reparent(p);
    8000150c:	854e                	mv	a0,s3
    8000150e:	f3bff0ef          	jal	80001448 <reparent>
  wakeup(p->parent);
    80001512:	0389b503          	ld	a0,56(s3)
    80001516:	ec9ff0ef          	jal	800013de <wakeup>
  acquire(&p->lock);
    8000151a:	854e                	mv	a0,s3
    8000151c:	524040ef          	jal	80005a40 <acquire>
  p->xstate = status;
    80001520:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001524:	4795                	li	a5,5
    80001526:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000152a:	8526                	mv	a0,s1
    8000152c:	5ac040ef          	jal	80005ad8 <release>
  sched();
    80001530:	d7dff0ef          	jal	800012ac <sched>
  panic("zombie exit");
    80001534:	00006517          	auipc	a0,0x6
    80001538:	d0450513          	addi	a0,a0,-764 # 80007238 <etext+0x238>
    8000153c:	1d6040ef          	jal	80005712 <panic>

0000000080001540 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001540:	7179                	addi	sp,sp,-48
    80001542:	f406                	sd	ra,40(sp)
    80001544:	f022                	sd	s0,32(sp)
    80001546:	ec26                	sd	s1,24(sp)
    80001548:	e84a                	sd	s2,16(sp)
    8000154a:	e44e                	sd	s3,8(sp)
    8000154c:	1800                	addi	s0,sp,48
    8000154e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001550:	00009497          	auipc	s1,0x9
    80001554:	49848493          	addi	s1,s1,1176 # 8000a9e8 <proc>
    80001558:	0000f997          	auipc	s3,0xf
    8000155c:	09098993          	addi	s3,s3,144 # 800105e8 <tickslock>
    acquire(&p->lock);
    80001560:	8526                	mv	a0,s1
    80001562:	4de040ef          	jal	80005a40 <acquire>
    if(p->pid == pid){
    80001566:	589c                	lw	a5,48(s1)
    80001568:	01278b63          	beq	a5,s2,8000157e <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000156c:	8526                	mv	a0,s1
    8000156e:	56a040ef          	jal	80005ad8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001572:	17048493          	addi	s1,s1,368
    80001576:	ff3495e3          	bne	s1,s3,80001560 <kill+0x20>
  }
  return -1;
    8000157a:	557d                	li	a0,-1
    8000157c:	a819                	j	80001592 <kill+0x52>
      p->killed = 1;
    8000157e:	4785                	li	a5,1
    80001580:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001582:	4c98                	lw	a4,24(s1)
    80001584:	4789                	li	a5,2
    80001586:	00f70d63          	beq	a4,a5,800015a0 <kill+0x60>
      release(&p->lock);
    8000158a:	8526                	mv	a0,s1
    8000158c:	54c040ef          	jal	80005ad8 <release>
      return 0;
    80001590:	4501                	li	a0,0
}
    80001592:	70a2                	ld	ra,40(sp)
    80001594:	7402                	ld	s0,32(sp)
    80001596:	64e2                	ld	s1,24(sp)
    80001598:	6942                	ld	s2,16(sp)
    8000159a:	69a2                	ld	s3,8(sp)
    8000159c:	6145                	addi	sp,sp,48
    8000159e:	8082                	ret
        p->state = RUNNABLE;
    800015a0:	478d                	li	a5,3
    800015a2:	cc9c                	sw	a5,24(s1)
    800015a4:	b7dd                	j	8000158a <kill+0x4a>

00000000800015a6 <setkilled>:

void
setkilled(struct proc *p)
{
    800015a6:	1101                	addi	sp,sp,-32
    800015a8:	ec06                	sd	ra,24(sp)
    800015aa:	e822                	sd	s0,16(sp)
    800015ac:	e426                	sd	s1,8(sp)
    800015ae:	1000                	addi	s0,sp,32
    800015b0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015b2:	48e040ef          	jal	80005a40 <acquire>
  p->killed = 1;
    800015b6:	4785                	li	a5,1
    800015b8:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800015ba:	8526                	mv	a0,s1
    800015bc:	51c040ef          	jal	80005ad8 <release>
}
    800015c0:	60e2                	ld	ra,24(sp)
    800015c2:	6442                	ld	s0,16(sp)
    800015c4:	64a2                	ld	s1,8(sp)
    800015c6:	6105                	addi	sp,sp,32
    800015c8:	8082                	ret

00000000800015ca <killed>:

int
killed(struct proc *p)
{
    800015ca:	1101                	addi	sp,sp,-32
    800015cc:	ec06                	sd	ra,24(sp)
    800015ce:	e822                	sd	s0,16(sp)
    800015d0:	e426                	sd	s1,8(sp)
    800015d2:	e04a                	sd	s2,0(sp)
    800015d4:	1000                	addi	s0,sp,32
    800015d6:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015d8:	468040ef          	jal	80005a40 <acquire>
  k = p->killed;
    800015dc:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015e0:	8526                	mv	a0,s1
    800015e2:	4f6040ef          	jal	80005ad8 <release>
  return k;
}
    800015e6:	854a                	mv	a0,s2
    800015e8:	60e2                	ld	ra,24(sp)
    800015ea:	6442                	ld	s0,16(sp)
    800015ec:	64a2                	ld	s1,8(sp)
    800015ee:	6902                	ld	s2,0(sp)
    800015f0:	6105                	addi	sp,sp,32
    800015f2:	8082                	ret

00000000800015f4 <wait>:
{
    800015f4:	715d                	addi	sp,sp,-80
    800015f6:	e486                	sd	ra,72(sp)
    800015f8:	e0a2                	sd	s0,64(sp)
    800015fa:	fc26                	sd	s1,56(sp)
    800015fc:	f84a                	sd	s2,48(sp)
    800015fe:	f44e                	sd	s3,40(sp)
    80001600:	f052                	sd	s4,32(sp)
    80001602:	ec56                	sd	s5,24(sp)
    80001604:	e85a                	sd	s6,16(sp)
    80001606:	e45e                	sd	s7,8(sp)
    80001608:	e062                	sd	s8,0(sp)
    8000160a:	0880                	addi	s0,sp,80
    8000160c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000160e:	faeff0ef          	jal	80000dbc <myproc>
    80001612:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001614:	00009517          	auipc	a0,0x9
    80001618:	fac50513          	addi	a0,a0,-84 # 8000a5c0 <wait_lock>
    8000161c:	424040ef          	jal	80005a40 <acquire>
    havekids = 0;
    80001620:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001622:	4a15                	li	s4,5
        havekids = 1;
    80001624:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001626:	0000f997          	auipc	s3,0xf
    8000162a:	fc298993          	addi	s3,s3,-62 # 800105e8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000162e:	00009c17          	auipc	s8,0x9
    80001632:	f92c0c13          	addi	s8,s8,-110 # 8000a5c0 <wait_lock>
    80001636:	a871                	j	800016d2 <wait+0xde>
          pid = pp->pid;
    80001638:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000163c:	000b0c63          	beqz	s6,80001654 <wait+0x60>
    80001640:	4691                	li	a3,4
    80001642:	02c48613          	addi	a2,s1,44
    80001646:	85da                	mv	a1,s6
    80001648:	05093503          	ld	a0,80(s2)
    8000164c:	bceff0ef          	jal	80000a1a <copyout>
    80001650:	02054b63          	bltz	a0,80001686 <wait+0x92>
          freeproc(pp);
    80001654:	8526                	mv	a0,s1
    80001656:	8d9ff0ef          	jal	80000f2e <freeproc>
          release(&pp->lock);
    8000165a:	8526                	mv	a0,s1
    8000165c:	47c040ef          	jal	80005ad8 <release>
          release(&wait_lock);
    80001660:	00009517          	auipc	a0,0x9
    80001664:	f6050513          	addi	a0,a0,-160 # 8000a5c0 <wait_lock>
    80001668:	470040ef          	jal	80005ad8 <release>
}
    8000166c:	854e                	mv	a0,s3
    8000166e:	60a6                	ld	ra,72(sp)
    80001670:	6406                	ld	s0,64(sp)
    80001672:	74e2                	ld	s1,56(sp)
    80001674:	7942                	ld	s2,48(sp)
    80001676:	79a2                	ld	s3,40(sp)
    80001678:	7a02                	ld	s4,32(sp)
    8000167a:	6ae2                	ld	s5,24(sp)
    8000167c:	6b42                	ld	s6,16(sp)
    8000167e:	6ba2                	ld	s7,8(sp)
    80001680:	6c02                	ld	s8,0(sp)
    80001682:	6161                	addi	sp,sp,80
    80001684:	8082                	ret
            release(&pp->lock);
    80001686:	8526                	mv	a0,s1
    80001688:	450040ef          	jal	80005ad8 <release>
            release(&wait_lock);
    8000168c:	00009517          	auipc	a0,0x9
    80001690:	f3450513          	addi	a0,a0,-204 # 8000a5c0 <wait_lock>
    80001694:	444040ef          	jal	80005ad8 <release>
            return -1;
    80001698:	59fd                	li	s3,-1
    8000169a:	bfc9                	j	8000166c <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000169c:	17048493          	addi	s1,s1,368
    800016a0:	03348063          	beq	s1,s3,800016c0 <wait+0xcc>
      if(pp->parent == p){
    800016a4:	7c9c                	ld	a5,56(s1)
    800016a6:	ff279be3          	bne	a5,s2,8000169c <wait+0xa8>
        acquire(&pp->lock);
    800016aa:	8526                	mv	a0,s1
    800016ac:	394040ef          	jal	80005a40 <acquire>
        if(pp->state == ZOMBIE){
    800016b0:	4c9c                	lw	a5,24(s1)
    800016b2:	f94783e3          	beq	a5,s4,80001638 <wait+0x44>
        release(&pp->lock);
    800016b6:	8526                	mv	a0,s1
    800016b8:	420040ef          	jal	80005ad8 <release>
        havekids = 1;
    800016bc:	8756                	mv	a4,s5
    800016be:	bff9                	j	8000169c <wait+0xa8>
    if(!havekids || killed(p)){
    800016c0:	cf19                	beqz	a4,800016de <wait+0xea>
    800016c2:	854a                	mv	a0,s2
    800016c4:	f07ff0ef          	jal	800015ca <killed>
    800016c8:	e919                	bnez	a0,800016de <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016ca:	85e2                	mv	a1,s8
    800016cc:	854a                	mv	a0,s2
    800016ce:	cc5ff0ef          	jal	80001392 <sleep>
    havekids = 0;
    800016d2:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016d4:	00009497          	auipc	s1,0x9
    800016d8:	31448493          	addi	s1,s1,788 # 8000a9e8 <proc>
    800016dc:	b7e1                	j	800016a4 <wait+0xb0>
      release(&wait_lock);
    800016de:	00009517          	auipc	a0,0x9
    800016e2:	ee250513          	addi	a0,a0,-286 # 8000a5c0 <wait_lock>
    800016e6:	3f2040ef          	jal	80005ad8 <release>
      return -1;
    800016ea:	59fd                	li	s3,-1
    800016ec:	b741                	j	8000166c <wait+0x78>

00000000800016ee <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016ee:	7179                	addi	sp,sp,-48
    800016f0:	f406                	sd	ra,40(sp)
    800016f2:	f022                	sd	s0,32(sp)
    800016f4:	ec26                	sd	s1,24(sp)
    800016f6:	e84a                	sd	s2,16(sp)
    800016f8:	e44e                	sd	s3,8(sp)
    800016fa:	e052                	sd	s4,0(sp)
    800016fc:	1800                	addi	s0,sp,48
    800016fe:	84aa                	mv	s1,a0
    80001700:	892e                	mv	s2,a1
    80001702:	89b2                	mv	s3,a2
    80001704:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001706:	eb6ff0ef          	jal	80000dbc <myproc>
  if(user_dst){
    8000170a:	cc99                	beqz	s1,80001728 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000170c:	86d2                	mv	a3,s4
    8000170e:	864e                	mv	a2,s3
    80001710:	85ca                	mv	a1,s2
    80001712:	6928                	ld	a0,80(a0)
    80001714:	b06ff0ef          	jal	80000a1a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001718:	70a2                	ld	ra,40(sp)
    8000171a:	7402                	ld	s0,32(sp)
    8000171c:	64e2                	ld	s1,24(sp)
    8000171e:	6942                	ld	s2,16(sp)
    80001720:	69a2                	ld	s3,8(sp)
    80001722:	6a02                	ld	s4,0(sp)
    80001724:	6145                	addi	sp,sp,48
    80001726:	8082                	ret
    memmove((char *)dst, src, len);
    80001728:	000a061b          	sext.w	a2,s4
    8000172c:	85ce                	mv	a1,s3
    8000172e:	854a                	mv	a0,s2
    80001730:	abdfe0ef          	jal	800001ec <memmove>
    return 0;
    80001734:	8526                	mv	a0,s1
    80001736:	b7cd                	j	80001718 <either_copyout+0x2a>

0000000080001738 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001738:	7179                	addi	sp,sp,-48
    8000173a:	f406                	sd	ra,40(sp)
    8000173c:	f022                	sd	s0,32(sp)
    8000173e:	ec26                	sd	s1,24(sp)
    80001740:	e84a                	sd	s2,16(sp)
    80001742:	e44e                	sd	s3,8(sp)
    80001744:	e052                	sd	s4,0(sp)
    80001746:	1800                	addi	s0,sp,48
    80001748:	892a                	mv	s2,a0
    8000174a:	84ae                	mv	s1,a1
    8000174c:	89b2                	mv	s3,a2
    8000174e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001750:	e6cff0ef          	jal	80000dbc <myproc>
  if(user_src){
    80001754:	cc99                	beqz	s1,80001772 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001756:	86d2                	mv	a3,s4
    80001758:	864e                	mv	a2,s3
    8000175a:	85ca                	mv	a1,s2
    8000175c:	6928                	ld	a0,80(a0)
    8000175e:	b92ff0ef          	jal	80000af0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001762:	70a2                	ld	ra,40(sp)
    80001764:	7402                	ld	s0,32(sp)
    80001766:	64e2                	ld	s1,24(sp)
    80001768:	6942                	ld	s2,16(sp)
    8000176a:	69a2                	ld	s3,8(sp)
    8000176c:	6a02                	ld	s4,0(sp)
    8000176e:	6145                	addi	sp,sp,48
    80001770:	8082                	ret
    memmove(dst, (char*)src, len);
    80001772:	000a061b          	sext.w	a2,s4
    80001776:	85ce                	mv	a1,s3
    80001778:	854a                	mv	a0,s2
    8000177a:	a73fe0ef          	jal	800001ec <memmove>
    return 0;
    8000177e:	8526                	mv	a0,s1
    80001780:	b7cd                	j	80001762 <either_copyin+0x2a>

0000000080001782 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001782:	715d                	addi	sp,sp,-80
    80001784:	e486                	sd	ra,72(sp)
    80001786:	e0a2                	sd	s0,64(sp)
    80001788:	fc26                	sd	s1,56(sp)
    8000178a:	f84a                	sd	s2,48(sp)
    8000178c:	f44e                	sd	s3,40(sp)
    8000178e:	f052                	sd	s4,32(sp)
    80001790:	ec56                	sd	s5,24(sp)
    80001792:	e85a                	sd	s6,16(sp)
    80001794:	e45e                	sd	s7,8(sp)
    80001796:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001798:	00006517          	auipc	a0,0x6
    8000179c:	88050513          	addi	a0,a0,-1920 # 80007018 <etext+0x18>
    800017a0:	4a1030ef          	jal	80005440 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017a4:	00009497          	auipc	s1,0x9
    800017a8:	39c48493          	addi	s1,s1,924 # 8000ab40 <proc+0x158>
    800017ac:	0000f917          	auipc	s2,0xf
    800017b0:	f9490913          	addi	s2,s2,-108 # 80010740 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017b4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800017b6:	00006997          	auipc	s3,0x6
    800017ba:	a9298993          	addi	s3,s3,-1390 # 80007248 <etext+0x248>
    printf("%d %s %s", p->pid, state, p->name);
    800017be:	00006a97          	auipc	s5,0x6
    800017c2:	a92a8a93          	addi	s5,s5,-1390 # 80007250 <etext+0x250>
    printf("\n");
    800017c6:	00006a17          	auipc	s4,0x6
    800017ca:	852a0a13          	addi	s4,s4,-1966 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ce:	00006b97          	auipc	s7,0x6
    800017d2:	0aab8b93          	addi	s7,s7,170 # 80007878 <states.0>
    800017d6:	a829                	j	800017f0 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017d8:	ed86a583          	lw	a1,-296(a3)
    800017dc:	8556                	mv	a0,s5
    800017de:	463030ef          	jal	80005440 <printf>
    printf("\n");
    800017e2:	8552                	mv	a0,s4
    800017e4:	45d030ef          	jal	80005440 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017e8:	17048493          	addi	s1,s1,368
    800017ec:	03248263          	beq	s1,s2,80001810 <procdump+0x8e>
    if(p->state == UNUSED)
    800017f0:	86a6                	mv	a3,s1
    800017f2:	ec04a783          	lw	a5,-320(s1)
    800017f6:	dbed                	beqz	a5,800017e8 <procdump+0x66>
      state = "???";
    800017f8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017fa:	fcfb6fe3          	bltu	s6,a5,800017d8 <procdump+0x56>
    800017fe:	02079713          	slli	a4,a5,0x20
    80001802:	01d75793          	srli	a5,a4,0x1d
    80001806:	97de                	add	a5,a5,s7
    80001808:	6390                	ld	a2,0(a5)
    8000180a:	f679                	bnez	a2,800017d8 <procdump+0x56>
      state = "???";
    8000180c:	864e                	mv	a2,s3
    8000180e:	b7e9                	j	800017d8 <procdump+0x56>
  }
}
    80001810:	60a6                	ld	ra,72(sp)
    80001812:	6406                	ld	s0,64(sp)
    80001814:	74e2                	ld	s1,56(sp)
    80001816:	7942                	ld	s2,48(sp)
    80001818:	79a2                	ld	s3,40(sp)
    8000181a:	7a02                	ld	s4,32(sp)
    8000181c:	6ae2                	ld	s5,24(sp)
    8000181e:	6b42                	ld	s6,16(sp)
    80001820:	6ba2                	ld	s7,8(sp)
    80001822:	6161                	addi	sp,sp,80
    80001824:	8082                	ret

0000000080001826 <proc_count>:

uint64
proc_count(void)
{
    80001826:	1141                	addi	sp,sp,-16
    80001828:	e422                	sd	s0,8(sp)
    8000182a:	0800                	addi	s0,sp,16
  struct proc *p;
  int count = 0;
    8000182c:	4501                	li	a0,0

  for(p = proc; p < &proc[NPROC]; p++){
    8000182e:	00009797          	auipc	a5,0x9
    80001832:	1ba78793          	addi	a5,a5,442 # 8000a9e8 <proc>
    80001836:	0000f697          	auipc	a3,0xf
    8000183a:	db268693          	addi	a3,a3,-590 # 800105e8 <tickslock>
    8000183e:	a029                	j	80001848 <proc_count+0x22>
    80001840:	17078793          	addi	a5,a5,368
    80001844:	00d78663          	beq	a5,a3,80001850 <proc_count+0x2a>
    if (p->state != UNUSED) {
    80001848:	4f98                	lw	a4,24(a5)
    8000184a:	db7d                	beqz	a4,80001840 <proc_count+0x1a>
      count++;
    8000184c:	2505                	addiw	a0,a0,1
    8000184e:	bfcd                	j	80001840 <proc_count+0x1a>
    }
  }
  return count;
}
    80001850:	6422                	ld	s0,8(sp)
    80001852:	0141                	addi	sp,sp,16
    80001854:	8082                	ret

0000000080001856 <update_loadavg>:
// }

// call this once per second (e.g. from clockintr when ticks%100==0)
void
update_loadavg(void)
{
    80001856:	7179                	addi	sp,sp,-48
    80001858:	f406                	sd	ra,40(sp)
    8000185a:	f022                	sd	s0,32(sp)
    8000185c:	ec26                	sd	s1,24(sp)
    8000185e:	e84a                	sd	s2,16(sp)
    80001860:	e44e                	sd	s3,8(sp)
    80001862:	e052                	sd	s4,0(sp)
    80001864:	1800                	addi	s0,sp,48
  int runnable_count = 0;
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001866:	00009497          	auipc	s1,0x9
    8000186a:	18248493          	addi	s1,s1,386 # 8000a9e8 <proc>
  int runnable_count = 0;
    8000186e:	4a01                	li	s4,0
    acquire(&p->lock);
    if(p->state == RUNNABLE || p->state == RUNNING)
    80001870:	4985                	li	s3,1
  for(p = proc; p < &proc[NPROC]; p++){
    80001872:	0000f917          	auipc	s2,0xf
    80001876:	d7690913          	addi	s2,s2,-650 # 800105e8 <tickslock>
    8000187a:	a801                	j	8000188a <update_loadavg+0x34>
      runnable_count++;
    release(&p->lock);
    8000187c:	8526                	mv	a0,s1
    8000187e:	25a040ef          	jal	80005ad8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001882:	17048493          	addi	s1,s1,368
    80001886:	01248b63          	beq	s1,s2,8000189c <update_loadavg+0x46>
    acquire(&p->lock);
    8000188a:	8526                	mv	a0,s1
    8000188c:	1b4040ef          	jal	80005a40 <acquire>
    if(p->state == RUNNABLE || p->state == RUNNING)
    80001890:	4c9c                	lw	a5,24(s1)
    80001892:	37f5                	addiw	a5,a5,-3
    80001894:	fef9e4e3          	bltu	s3,a5,8000187c <update_loadavg+0x26>
      runnable_count++;
    80001898:	2a05                	addiw	s4,s4,1
    8000189a:	b7cd                	j	8000187c <update_loadavg+0x26>
  const int SCALE = 1000;
  const int alpha1 = 920;   // ~0.92
  const int alpha5 = 983;   // ~0.983
  const int alpha15 = 994;  // ~0.994

  acquire(&load_lock);
    8000189c:	00009497          	auipc	s1,0x9
    800018a0:	cf448493          	addi	s1,s1,-780 # 8000a590 <load_lock>
    800018a4:	8526                	mv	a0,s1
    800018a6:	19a040ef          	jal	80005a40 <acquire>
  kernel_loadavg[0] = (kernel_loadavg[0] * alpha1 + runnable_count * (SCALE - alpha1)) / SCALE;
    800018aa:	4484a703          	lw	a4,1096(s1)
    800018ae:	39800793          	li	a5,920
    800018b2:	02e787bb          	mulw	a5,a5,a4
    800018b6:	002a171b          	slliw	a4,s4,0x2
    800018ba:	0147073b          	addw	a4,a4,s4
    800018be:	0047171b          	slliw	a4,a4,0x4
    800018c2:	9fb9                	addw	a5,a5,a4
    800018c4:	3e800693          	li	a3,1000
    800018c8:	02d7c7bb          	divw	a5,a5,a3
    800018cc:	44f4a423          	sw	a5,1096(s1)
  kernel_loadavg[1] = (kernel_loadavg[1] * alpha5 + runnable_count * (SCALE - alpha5)) / SCALE;
    800018d0:	44c4a703          	lw	a4,1100(s1)
    800018d4:	3d700793          	li	a5,983
    800018d8:	02e787bb          	mulw	a5,a5,a4
    800018dc:	004a171b          	slliw	a4,s4,0x4
    800018e0:	0147073b          	addw	a4,a4,s4
    800018e4:	9fb9                	addw	a5,a5,a4
    800018e6:	02d7c7bb          	divw	a5,a5,a3
    800018ea:	44f4a623          	sw	a5,1100(s1)
  kernel_loadavg[2] = (kernel_loadavg[2] * alpha15 + runnable_count * (SCALE - alpha15)) / SCALE;
    800018ee:	4504a703          	lw	a4,1104(s1)
    800018f2:	3e200793          	li	a5,994
    800018f6:	02e787bb          	mulw	a5,a5,a4
    800018fa:	001a171b          	slliw	a4,s4,0x1
    800018fe:	0147073b          	addw	a4,a4,s4
    80001902:	0017171b          	slliw	a4,a4,0x1
    80001906:	9fb9                	addw	a5,a5,a4
    80001908:	02d7c7bb          	divw	a5,a5,a3
    8000190c:	44f4a823          	sw	a5,1104(s1)
  release(&load_lock);
    80001910:	8526                	mv	a0,s1
    80001912:	1c6040ef          	jal	80005ad8 <release>
}
    80001916:	70a2                	ld	ra,40(sp)
    80001918:	7402                	ld	s0,32(sp)
    8000191a:	64e2                	ld	s1,24(sp)
    8000191c:	6942                	ld	s2,16(sp)
    8000191e:	69a2                	ld	s3,8(sp)
    80001920:	6a02                	ld	s4,0(sp)
    80001922:	6145                	addi	sp,sp,48
    80001924:	8082                	ret

0000000080001926 <get_loadavg>:

void
get_loadavg(int out[3])
{
    80001926:	1101                	addi	sp,sp,-32
    80001928:	ec06                	sd	ra,24(sp)
    8000192a:	e822                	sd	s0,16(sp)
    8000192c:	e426                	sd	s1,8(sp)
    8000192e:	e04a                	sd	s2,0(sp)
    80001930:	1000                	addi	s0,sp,32
    80001932:	892a                	mv	s2,a0
  acquire(&load_lock);
    80001934:	00009497          	auipc	s1,0x9
    80001938:	c5c48493          	addi	s1,s1,-932 # 8000a590 <load_lock>
    8000193c:	8526                	mv	a0,s1
    8000193e:	102040ef          	jal	80005a40 <acquire>
  out[0] = kernel_loadavg[0];
    80001942:	4484a783          	lw	a5,1096(s1)
    80001946:	00f92023          	sw	a5,0(s2)
  out[1] = kernel_loadavg[1];
    8000194a:	44c4a783          	lw	a5,1100(s1)
    8000194e:	00f92223          	sw	a5,4(s2)
  out[2] = kernel_loadavg[2];
    80001952:	4504a783          	lw	a5,1104(s1)
    80001956:	00f92423          	sw	a5,8(s2)
  release(&load_lock);
    8000195a:	8526                	mv	a0,s1
    8000195c:	17c040ef          	jal	80005ad8 <release>
}
    80001960:	60e2                	ld	ra,24(sp)
    80001962:	6442                	ld	s0,16(sp)
    80001964:	64a2                	ld	s1,8(sp)
    80001966:	6902                	ld	s2,0(sp)
    80001968:	6105                	addi	sp,sp,32
    8000196a:	8082                	ret

000000008000196c <swtch>:
    8000196c:	00153023          	sd	ra,0(a0)
    80001970:	00253423          	sd	sp,8(a0)
    80001974:	e900                	sd	s0,16(a0)
    80001976:	ed04                	sd	s1,24(a0)
    80001978:	03253023          	sd	s2,32(a0)
    8000197c:	03353423          	sd	s3,40(a0)
    80001980:	03453823          	sd	s4,48(a0)
    80001984:	03553c23          	sd	s5,56(a0)
    80001988:	05653023          	sd	s6,64(a0)
    8000198c:	05753423          	sd	s7,72(a0)
    80001990:	05853823          	sd	s8,80(a0)
    80001994:	05953c23          	sd	s9,88(a0)
    80001998:	07a53023          	sd	s10,96(a0)
    8000199c:	07b53423          	sd	s11,104(a0)
    800019a0:	0005b083          	ld	ra,0(a1)
    800019a4:	0085b103          	ld	sp,8(a1)
    800019a8:	6980                	ld	s0,16(a1)
    800019aa:	6d84                	ld	s1,24(a1)
    800019ac:	0205b903          	ld	s2,32(a1)
    800019b0:	0285b983          	ld	s3,40(a1)
    800019b4:	0305ba03          	ld	s4,48(a1)
    800019b8:	0385ba83          	ld	s5,56(a1)
    800019bc:	0405bb03          	ld	s6,64(a1)
    800019c0:	0485bb83          	ld	s7,72(a1)
    800019c4:	0505bc03          	ld	s8,80(a1)
    800019c8:	0585bc83          	ld	s9,88(a1)
    800019cc:	0605bd03          	ld	s10,96(a1)
    800019d0:	0685bd83          	ld	s11,104(a1)
    800019d4:	8082                	ret

00000000800019d6 <trapinit>:

extern void update_loadavg(void);

void
trapinit(void)
{
    800019d6:	1141                	addi	sp,sp,-16
    800019d8:	e406                	sd	ra,8(sp)
    800019da:	e022                	sd	s0,0(sp)
    800019dc:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800019de:	00006597          	auipc	a1,0x6
    800019e2:	8b258593          	addi	a1,a1,-1870 # 80007290 <etext+0x290>
    800019e6:	0000f517          	auipc	a0,0xf
    800019ea:	c0250513          	addi	a0,a0,-1022 # 800105e8 <tickslock>
    800019ee:	7d3030ef          	jal	800059c0 <initlock>
}
    800019f2:	60a2                	ld	ra,8(sp)
    800019f4:	6402                	ld	s0,0(sp)
    800019f6:	0141                	addi	sp,sp,16
    800019f8:	8082                	ret

00000000800019fa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800019fa:	1141                	addi	sp,sp,-16
    800019fc:	e422                	sd	s0,8(sp)
    800019fe:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a00:	00003797          	auipc	a5,0x3
    80001a04:	f8078793          	addi	a5,a5,-128 # 80004980 <kernelvec>
    80001a08:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001a0c:	6422                	ld	s0,8(sp)
    80001a0e:	0141                	addi	sp,sp,16
    80001a10:	8082                	ret

0000000080001a12 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001a12:	1141                	addi	sp,sp,-16
    80001a14:	e406                	sd	ra,8(sp)
    80001a16:	e022                	sd	s0,0(sp)
    80001a18:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001a1a:	ba2ff0ef          	jal	80000dbc <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a1e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001a22:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a24:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001a28:	00004697          	auipc	a3,0x4
    80001a2c:	5d868693          	addi	a3,a3,1496 # 80006000 <_trampoline>
    80001a30:	00004717          	auipc	a4,0x4
    80001a34:	5d070713          	addi	a4,a4,1488 # 80006000 <_trampoline>
    80001a38:	8f15                	sub	a4,a4,a3
    80001a3a:	040007b7          	lui	a5,0x4000
    80001a3e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001a40:	07b2                	slli	a5,a5,0xc
    80001a42:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a44:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001a48:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001a4a:	18002673          	csrr	a2,satp
    80001a4e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001a50:	6d30                	ld	a2,88(a0)
    80001a52:	6138                	ld	a4,64(a0)
    80001a54:	6585                	lui	a1,0x1
    80001a56:	972e                	add	a4,a4,a1
    80001a58:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001a5a:	6d38                	ld	a4,88(a0)
    80001a5c:	00000617          	auipc	a2,0x0
    80001a60:	12a60613          	addi	a2,a2,298 # 80001b86 <usertrap>
    80001a64:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001a66:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a68:	8612                	mv	a2,tp
    80001a6a:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a6c:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001a70:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001a74:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a78:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001a7c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001a7e:	6f18                	ld	a4,24(a4)
    80001a80:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001a84:	6928                	ld	a0,80(a0)
    80001a86:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001a88:	00004717          	auipc	a4,0x4
    80001a8c:	61470713          	addi	a4,a4,1556 # 8000609c <userret>
    80001a90:	8f15                	sub	a4,a4,a3
    80001a92:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001a94:	577d                	li	a4,-1
    80001a96:	177e                	slli	a4,a4,0x3f
    80001a98:	8d59                	or	a0,a0,a4
    80001a9a:	9782                	jalr	a5
}
    80001a9c:	60a2                	ld	ra,8(sp)
    80001a9e:	6402                	ld	s0,0(sp)
    80001aa0:	0141                	addi	sp,sp,16
    80001aa2:	8082                	ret

0000000080001aa4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001aa4:	1141                	addi	sp,sp,-16
    80001aa6:	e406                	sd	ra,8(sp)
    80001aa8:	e022                	sd	s0,0(sp)
    80001aaa:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001aac:	ae4ff0ef          	jal	80000d90 <cpuid>
    80001ab0:	cd11                	beqz	a0,80001acc <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001ab2:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001ab6:	000f4737          	lui	a4,0xf4
    80001aba:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001abe:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001ac0:	14d79073          	csrw	stimecmp,a5
}
    80001ac4:	60a2                	ld	ra,8(sp)
    80001ac6:	6402                	ld	s0,0(sp)
    80001ac8:	0141                	addi	sp,sp,16
    80001aca:	8082                	ret
    acquire(&tickslock);
    80001acc:	0000f517          	auipc	a0,0xf
    80001ad0:	b1c50513          	addi	a0,a0,-1252 # 800105e8 <tickslock>
    80001ad4:	76d030ef          	jal	80005a40 <acquire>
    ticks++;
    80001ad8:	00009717          	auipc	a4,0x9
    80001adc:	a8070713          	addi	a4,a4,-1408 # 8000a558 <ticks>
    80001ae0:	431c                	lw	a5,0(a4)
    80001ae2:	2785                	addiw	a5,a5,1
    80001ae4:	c31c                	sw	a5,0(a4)
    if (ticks % 100 == 0) {
    80001ae6:	06400713          	li	a4,100
    80001aea:	02e7f7bb          	remuw	a5,a5,a4
    80001aee:	2781                	sext.w	a5,a5
    80001af0:	cf91                	beqz	a5,80001b0c <clockintr+0x68>
    wakeup(&ticks);
    80001af2:	00009517          	auipc	a0,0x9
    80001af6:	a6650513          	addi	a0,a0,-1434 # 8000a558 <ticks>
    80001afa:	8e5ff0ef          	jal	800013de <wakeup>
    release(&tickslock);
    80001afe:	0000f517          	auipc	a0,0xf
    80001b02:	aea50513          	addi	a0,a0,-1302 # 800105e8 <tickslock>
    80001b06:	7d3030ef          	jal	80005ad8 <release>
    80001b0a:	b765                	j	80001ab2 <clockintr+0xe>
      update_loadavg();
    80001b0c:	d4bff0ef          	jal	80001856 <update_loadavg>
    80001b10:	b7cd                	j	80001af2 <clockintr+0x4e>

0000000080001b12 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b12:	1101                	addi	sp,sp,-32
    80001b14:	ec06                	sd	ra,24(sp)
    80001b16:	e822                	sd	s0,16(sp)
    80001b18:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b1a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001b1e:	57fd                	li	a5,-1
    80001b20:	17fe                	slli	a5,a5,0x3f
    80001b22:	07a5                	addi	a5,a5,9
    80001b24:	00f70c63          	beq	a4,a5,80001b3c <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001b28:	57fd                	li	a5,-1
    80001b2a:	17fe                	slli	a5,a5,0x3f
    80001b2c:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001b2e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001b30:	04f70763          	beq	a4,a5,80001b7e <devintr+0x6c>
  }
}
    80001b34:	60e2                	ld	ra,24(sp)
    80001b36:	6442                	ld	s0,16(sp)
    80001b38:	6105                	addi	sp,sp,32
    80001b3a:	8082                	ret
    80001b3c:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001b3e:	6ef020ef          	jal	80004a2c <plic_claim>
    80001b42:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001b44:	47a9                	li	a5,10
    80001b46:	00f50963          	beq	a0,a5,80001b58 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001b4a:	4785                	li	a5,1
    80001b4c:	00f50963          	beq	a0,a5,80001b5e <devintr+0x4c>
    return 1;
    80001b50:	4505                	li	a0,1
    } else if(irq){
    80001b52:	e889                	bnez	s1,80001b64 <devintr+0x52>
    80001b54:	64a2                	ld	s1,8(sp)
    80001b56:	bff9                	j	80001b34 <devintr+0x22>
      uartintr();
    80001b58:	62d030ef          	jal	80005984 <uartintr>
    if(irq)
    80001b5c:	a819                	j	80001b72 <devintr+0x60>
      virtio_disk_intr();
    80001b5e:	394030ef          	jal	80004ef2 <virtio_disk_intr>
    if(irq)
    80001b62:	a801                	j	80001b72 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001b64:	85a6                	mv	a1,s1
    80001b66:	00005517          	auipc	a0,0x5
    80001b6a:	73250513          	addi	a0,a0,1842 # 80007298 <etext+0x298>
    80001b6e:	0d3030ef          	jal	80005440 <printf>
      plic_complete(irq);
    80001b72:	8526                	mv	a0,s1
    80001b74:	6d9020ef          	jal	80004a4c <plic_complete>
    return 1;
    80001b78:	4505                	li	a0,1
    80001b7a:	64a2                	ld	s1,8(sp)
    80001b7c:	bf65                	j	80001b34 <devintr+0x22>
    clockintr();
    80001b7e:	f27ff0ef          	jal	80001aa4 <clockintr>
    return 2;
    80001b82:	4509                	li	a0,2
    80001b84:	bf45                	j	80001b34 <devintr+0x22>

0000000080001b86 <usertrap>:
{
    80001b86:	1101                	addi	sp,sp,-32
    80001b88:	ec06                	sd	ra,24(sp)
    80001b8a:	e822                	sd	s0,16(sp)
    80001b8c:	e426                	sd	s1,8(sp)
    80001b8e:	e04a                	sd	s2,0(sp)
    80001b90:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b92:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001b96:	1007f793          	andi	a5,a5,256
    80001b9a:	ef85                	bnez	a5,80001bd2 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b9c:	00003797          	auipc	a5,0x3
    80001ba0:	de478793          	addi	a5,a5,-540 # 80004980 <kernelvec>
    80001ba4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ba8:	a14ff0ef          	jal	80000dbc <myproc>
    80001bac:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001bae:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001bb0:	14102773          	csrr	a4,sepc
    80001bb4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bb6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001bba:	47a1                	li	a5,8
    80001bbc:	02f70163          	beq	a4,a5,80001bde <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001bc0:	f53ff0ef          	jal	80001b12 <devintr>
    80001bc4:	892a                	mv	s2,a0
    80001bc6:	c135                	beqz	a0,80001c2a <usertrap+0xa4>
  if(killed(p))
    80001bc8:	8526                	mv	a0,s1
    80001bca:	a01ff0ef          	jal	800015ca <killed>
    80001bce:	cd1d                	beqz	a0,80001c0c <usertrap+0x86>
    80001bd0:	a81d                	j	80001c06 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001bd2:	00005517          	auipc	a0,0x5
    80001bd6:	6e650513          	addi	a0,a0,1766 # 800072b8 <etext+0x2b8>
    80001bda:	339030ef          	jal	80005712 <panic>
    if(killed(p))
    80001bde:	9edff0ef          	jal	800015ca <killed>
    80001be2:	e121                	bnez	a0,80001c22 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001be4:	6cb8                	ld	a4,88(s1)
    80001be6:	6f1c                	ld	a5,24(a4)
    80001be8:	0791                	addi	a5,a5,4
    80001bea:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001bf0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bf4:	10079073          	csrw	sstatus,a5
    syscall();
    80001bf8:	248000ef          	jal	80001e40 <syscall>
  if(killed(p))
    80001bfc:	8526                	mv	a0,s1
    80001bfe:	9cdff0ef          	jal	800015ca <killed>
    80001c02:	c901                	beqz	a0,80001c12 <usertrap+0x8c>
    80001c04:	4901                	li	s2,0
    exit(-1);
    80001c06:	557d                	li	a0,-1
    80001c08:	897ff0ef          	jal	8000149e <exit>
  if(which_dev == 2)
    80001c0c:	4789                	li	a5,2
    80001c0e:	04f90563          	beq	s2,a5,80001c58 <usertrap+0xd2>
  usertrapret();
    80001c12:	e01ff0ef          	jal	80001a12 <usertrapret>
}
    80001c16:	60e2                	ld	ra,24(sp)
    80001c18:	6442                	ld	s0,16(sp)
    80001c1a:	64a2                	ld	s1,8(sp)
    80001c1c:	6902                	ld	s2,0(sp)
    80001c1e:	6105                	addi	sp,sp,32
    80001c20:	8082                	ret
      exit(-1);
    80001c22:	557d                	li	a0,-1
    80001c24:	87bff0ef          	jal	8000149e <exit>
    80001c28:	bf75                	j	80001be4 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c2a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001c2e:	5890                	lw	a2,48(s1)
    80001c30:	00005517          	auipc	a0,0x5
    80001c34:	6a850513          	addi	a0,a0,1704 # 800072d8 <etext+0x2d8>
    80001c38:	009030ef          	jal	80005440 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c3c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001c40:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001c44:	00005517          	auipc	a0,0x5
    80001c48:	6c450513          	addi	a0,a0,1732 # 80007308 <etext+0x308>
    80001c4c:	7f4030ef          	jal	80005440 <printf>
    setkilled(p);
    80001c50:	8526                	mv	a0,s1
    80001c52:	955ff0ef          	jal	800015a6 <setkilled>
    80001c56:	b75d                	j	80001bfc <usertrap+0x76>
    yield();
    80001c58:	f0eff0ef          	jal	80001366 <yield>
    80001c5c:	bf5d                	j	80001c12 <usertrap+0x8c>

0000000080001c5e <kerneltrap>:
{
    80001c5e:	7179                	addi	sp,sp,-48
    80001c60:	f406                	sd	ra,40(sp)
    80001c62:	f022                	sd	s0,32(sp)
    80001c64:	ec26                	sd	s1,24(sp)
    80001c66:	e84a                	sd	s2,16(sp)
    80001c68:	e44e                	sd	s3,8(sp)
    80001c6a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c6c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c70:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c74:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001c78:	1004f793          	andi	a5,s1,256
    80001c7c:	c795                	beqz	a5,80001ca8 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c7e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001c82:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001c84:	eb85                	bnez	a5,80001cb4 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001c86:	e8dff0ef          	jal	80001b12 <devintr>
    80001c8a:	c91d                	beqz	a0,80001cc0 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001c8c:	4789                	li	a5,2
    80001c8e:	04f50a63          	beq	a0,a5,80001ce2 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c92:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c96:	10049073          	csrw	sstatus,s1
}
    80001c9a:	70a2                	ld	ra,40(sp)
    80001c9c:	7402                	ld	s0,32(sp)
    80001c9e:	64e2                	ld	s1,24(sp)
    80001ca0:	6942                	ld	s2,16(sp)
    80001ca2:	69a2                	ld	s3,8(sp)
    80001ca4:	6145                	addi	sp,sp,48
    80001ca6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ca8:	00005517          	auipc	a0,0x5
    80001cac:	68850513          	addi	a0,a0,1672 # 80007330 <etext+0x330>
    80001cb0:	263030ef          	jal	80005712 <panic>
    panic("kerneltrap: interrupts enabled");
    80001cb4:	00005517          	auipc	a0,0x5
    80001cb8:	6a450513          	addi	a0,a0,1700 # 80007358 <etext+0x358>
    80001cbc:	257030ef          	jal	80005712 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cc0:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cc4:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001cc8:	85ce                	mv	a1,s3
    80001cca:	00005517          	auipc	a0,0x5
    80001cce:	6ae50513          	addi	a0,a0,1710 # 80007378 <etext+0x378>
    80001cd2:	76e030ef          	jal	80005440 <printf>
    panic("kerneltrap");
    80001cd6:	00005517          	auipc	a0,0x5
    80001cda:	6ca50513          	addi	a0,a0,1738 # 800073a0 <etext+0x3a0>
    80001cde:	235030ef          	jal	80005712 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001ce2:	8daff0ef          	jal	80000dbc <myproc>
    80001ce6:	d555                	beqz	a0,80001c92 <kerneltrap+0x34>
    yield();
    80001ce8:	e7eff0ef          	jal	80001366 <yield>
    80001cec:	b75d                	j	80001c92 <kerneltrap+0x34>

0000000080001cee <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001cee:	1101                	addi	sp,sp,-32
    80001cf0:	ec06                	sd	ra,24(sp)
    80001cf2:	e822                	sd	s0,16(sp)
    80001cf4:	e426                	sd	s1,8(sp)
    80001cf6:	1000                	addi	s0,sp,32
    80001cf8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001cfa:	8c2ff0ef          	jal	80000dbc <myproc>
  switch (n) {
    80001cfe:	4795                	li	a5,5
    80001d00:	0497e163          	bltu	a5,s1,80001d42 <argraw+0x54>
    80001d04:	048a                	slli	s1,s1,0x2
    80001d06:	00006717          	auipc	a4,0x6
    80001d0a:	ba270713          	addi	a4,a4,-1118 # 800078a8 <states.0+0x30>
    80001d0e:	94ba                	add	s1,s1,a4
    80001d10:	409c                	lw	a5,0(s1)
    80001d12:	97ba                	add	a5,a5,a4
    80001d14:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001d16:	6d3c                	ld	a5,88(a0)
    80001d18:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001d1a:	60e2                	ld	ra,24(sp)
    80001d1c:	6442                	ld	s0,16(sp)
    80001d1e:	64a2                	ld	s1,8(sp)
    80001d20:	6105                	addi	sp,sp,32
    80001d22:	8082                	ret
    return p->trapframe->a1;
    80001d24:	6d3c                	ld	a5,88(a0)
    80001d26:	7fa8                	ld	a0,120(a5)
    80001d28:	bfcd                	j	80001d1a <argraw+0x2c>
    return p->trapframe->a2;
    80001d2a:	6d3c                	ld	a5,88(a0)
    80001d2c:	63c8                	ld	a0,128(a5)
    80001d2e:	b7f5                	j	80001d1a <argraw+0x2c>
    return p->trapframe->a3;
    80001d30:	6d3c                	ld	a5,88(a0)
    80001d32:	67c8                	ld	a0,136(a5)
    80001d34:	b7dd                	j	80001d1a <argraw+0x2c>
    return p->trapframe->a4;
    80001d36:	6d3c                	ld	a5,88(a0)
    80001d38:	6bc8                	ld	a0,144(a5)
    80001d3a:	b7c5                	j	80001d1a <argraw+0x2c>
    return p->trapframe->a5;
    80001d3c:	6d3c                	ld	a5,88(a0)
    80001d3e:	6fc8                	ld	a0,152(a5)
    80001d40:	bfe9                	j	80001d1a <argraw+0x2c>
  panic("argraw");
    80001d42:	00005517          	auipc	a0,0x5
    80001d46:	66e50513          	addi	a0,a0,1646 # 800073b0 <etext+0x3b0>
    80001d4a:	1c9030ef          	jal	80005712 <panic>

0000000080001d4e <fetchaddr>:
{
    80001d4e:	1101                	addi	sp,sp,-32
    80001d50:	ec06                	sd	ra,24(sp)
    80001d52:	e822                	sd	s0,16(sp)
    80001d54:	e426                	sd	s1,8(sp)
    80001d56:	e04a                	sd	s2,0(sp)
    80001d58:	1000                	addi	s0,sp,32
    80001d5a:	84aa                	mv	s1,a0
    80001d5c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001d5e:	85eff0ef          	jal	80000dbc <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001d62:	653c                	ld	a5,72(a0)
    80001d64:	02f4f663          	bgeu	s1,a5,80001d90 <fetchaddr+0x42>
    80001d68:	00848713          	addi	a4,s1,8
    80001d6c:	02e7e463          	bltu	a5,a4,80001d94 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001d70:	46a1                	li	a3,8
    80001d72:	8626                	mv	a2,s1
    80001d74:	85ca                	mv	a1,s2
    80001d76:	6928                	ld	a0,80(a0)
    80001d78:	d79fe0ef          	jal	80000af0 <copyin>
    80001d7c:	00a03533          	snez	a0,a0
    80001d80:	40a00533          	neg	a0,a0
}
    80001d84:	60e2                	ld	ra,24(sp)
    80001d86:	6442                	ld	s0,16(sp)
    80001d88:	64a2                	ld	s1,8(sp)
    80001d8a:	6902                	ld	s2,0(sp)
    80001d8c:	6105                	addi	sp,sp,32
    80001d8e:	8082                	ret
    return -1;
    80001d90:	557d                	li	a0,-1
    80001d92:	bfcd                	j	80001d84 <fetchaddr+0x36>
    80001d94:	557d                	li	a0,-1
    80001d96:	b7fd                	j	80001d84 <fetchaddr+0x36>

0000000080001d98 <fetchstr>:
{
    80001d98:	7179                	addi	sp,sp,-48
    80001d9a:	f406                	sd	ra,40(sp)
    80001d9c:	f022                	sd	s0,32(sp)
    80001d9e:	ec26                	sd	s1,24(sp)
    80001da0:	e84a                	sd	s2,16(sp)
    80001da2:	e44e                	sd	s3,8(sp)
    80001da4:	1800                	addi	s0,sp,48
    80001da6:	892a                	mv	s2,a0
    80001da8:	84ae                	mv	s1,a1
    80001daa:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001dac:	810ff0ef          	jal	80000dbc <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001db0:	86ce                	mv	a3,s3
    80001db2:	864a                	mv	a2,s2
    80001db4:	85a6                	mv	a1,s1
    80001db6:	6928                	ld	a0,80(a0)
    80001db8:	dbffe0ef          	jal	80000b76 <copyinstr>
    80001dbc:	00054c63          	bltz	a0,80001dd4 <fetchstr+0x3c>
  return strlen(buf);
    80001dc0:	8526                	mv	a0,s1
    80001dc2:	d3efe0ef          	jal	80000300 <strlen>
}
    80001dc6:	70a2                	ld	ra,40(sp)
    80001dc8:	7402                	ld	s0,32(sp)
    80001dca:	64e2                	ld	s1,24(sp)
    80001dcc:	6942                	ld	s2,16(sp)
    80001dce:	69a2                	ld	s3,8(sp)
    80001dd0:	6145                	addi	sp,sp,48
    80001dd2:	8082                	ret
    return -1;
    80001dd4:	557d                	li	a0,-1
    80001dd6:	bfc5                	j	80001dc6 <fetchstr+0x2e>

0000000080001dd8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001dd8:	1101                	addi	sp,sp,-32
    80001dda:	ec06                	sd	ra,24(sp)
    80001ddc:	e822                	sd	s0,16(sp)
    80001dde:	e426                	sd	s1,8(sp)
    80001de0:	1000                	addi	s0,sp,32
    80001de2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001de4:	f0bff0ef          	jal	80001cee <argraw>
    80001de8:	c088                	sw	a0,0(s1)
}
    80001dea:	60e2                	ld	ra,24(sp)
    80001dec:	6442                	ld	s0,16(sp)
    80001dee:	64a2                	ld	s1,8(sp)
    80001df0:	6105                	addi	sp,sp,32
    80001df2:	8082                	ret

0000000080001df4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001df4:	1101                	addi	sp,sp,-32
    80001df6:	ec06                	sd	ra,24(sp)
    80001df8:	e822                	sd	s0,16(sp)
    80001dfa:	e426                	sd	s1,8(sp)
    80001dfc:	1000                	addi	s0,sp,32
    80001dfe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001e00:	eefff0ef          	jal	80001cee <argraw>
    80001e04:	e088                	sd	a0,0(s1)
}
    80001e06:	60e2                	ld	ra,24(sp)
    80001e08:	6442                	ld	s0,16(sp)
    80001e0a:	64a2                	ld	s1,8(sp)
    80001e0c:	6105                	addi	sp,sp,32
    80001e0e:	8082                	ret

0000000080001e10 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001e10:	7179                	addi	sp,sp,-48
    80001e12:	f406                	sd	ra,40(sp)
    80001e14:	f022                	sd	s0,32(sp)
    80001e16:	ec26                	sd	s1,24(sp)
    80001e18:	e84a                	sd	s2,16(sp)
    80001e1a:	1800                	addi	s0,sp,48
    80001e1c:	84ae                	mv	s1,a1
    80001e1e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001e20:	fd840593          	addi	a1,s0,-40
    80001e24:	fd1ff0ef          	jal	80001df4 <argaddr>
  return fetchstr(addr, buf, max);
    80001e28:	864a                	mv	a2,s2
    80001e2a:	85a6                	mv	a1,s1
    80001e2c:	fd843503          	ld	a0,-40(s0)
    80001e30:	f69ff0ef          	jal	80001d98 <fetchstr>
}
    80001e34:	70a2                	ld	ra,40(sp)
    80001e36:	7402                	ld	s0,32(sp)
    80001e38:	64e2                	ld	s1,24(sp)
    80001e3a:	6942                	ld	s2,16(sp)
    80001e3c:	6145                	addi	sp,sp,48
    80001e3e:	8082                	ret

0000000080001e40 <syscall>:
  [SYS_sysinfo] 1, // Add sys_sysinfotest for mapping
};

void
syscall(void)
{
    80001e40:	7159                	addi	sp,sp,-112
    80001e42:	f486                	sd	ra,104(sp)
    80001e44:	f0a2                	sd	s0,96(sp)
    80001e46:	eca6                	sd	s1,88(sp)
    80001e48:	e4ce                	sd	s3,72(sp)
    80001e4a:	e0d2                	sd	s4,64(sp)
    80001e4c:	fc56                	sd	s5,56(sp)
    80001e4e:	f85a                	sd	s6,48(sp)
    80001e50:	1880                	addi	s0,sp,112
  int num;
  struct proc *p = myproc();
    80001e52:	f6bfe0ef          	jal	80000dbc <myproc>
    80001e56:	8a2a                	mv	s4,a0

  num = p->trapframe->a7;
    80001e58:	6d3c                	ld	a5,88(a0)
    80001e5a:	0a87ba83          	ld	s5,168(a5)
    80001e5e:	000a8b1b          	sext.w	s6,s5
  int nargs = syscall_num_args[num];
    80001e62:	002b1713          	slli	a4,s6,0x2
    80001e66:	00006797          	auipc	a5,0x6
    80001e6a:	a5a78793          	addi	a5,a5,-1446 # 800078c0 <syscall_num_args>
    80001e6e:	97ba                	add	a5,a5,a4
    80001e70:	0007a983          	lw	s3,0(a5)

  uint64 args[6];
  for (int i = 0; i < nargs; i++)
    80001e74:	03305063          	blez	s3,80001e94 <syscall+0x54>
    80001e78:	e8ca                	sd	s2,80(sp)
    80001e7a:	f9040913          	addi	s2,s0,-112
    80001e7e:	4481                	li	s1,0
  {
    args[i] = argraw(i);
    80001e80:	8526                	mv	a0,s1
    80001e82:	e6dff0ef          	jal	80001cee <argraw>
    80001e86:	00a93023          	sd	a0,0(s2)
  for (int i = 0; i < nargs; i++)
    80001e8a:	2485                	addiw	s1,s1,1
    80001e8c:	0921                	addi	s2,s2,8
    80001e8e:	fe9999e3          	bne	s3,s1,80001e80 <syscall+0x40>
    80001e92:	6946                	ld	s2,80(sp)
  }

  if(num > 0 && num < NELEM(syscalls) && syscalls[num])
    80001e94:	3afd                	addiw	s5,s5,-1
    80001e96:	47d9                	li	a5,22
    80001e98:	0957ed63          	bltu	a5,s5,80001f32 <syscall+0xf2>
    80001e9c:	003b1713          	slli	a4,s6,0x3
    80001ea0:	00006797          	auipc	a5,0x6
    80001ea4:	a2078793          	addi	a5,a5,-1504 # 800078c0 <syscall_num_args>
    80001ea8:	97ba                	add	a5,a5,a4
    80001eaa:	73bc                	ld	a5,96(a5)
    80001eac:	c3d9                	beqz	a5,80001f32 <syscall+0xf2>
  {
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001eae:	058a3483          	ld	s1,88(s4)
    80001eb2:	9782                	jalr	a5
    80001eb4:	f8a8                	sd	a0,112(s1)
    if (p->trace_mask & (1 << num))
    80001eb6:	168a2783          	lw	a5,360(s4)
    80001eba:	4167d7bb          	sraw	a5,a5,s6
    80001ebe:	8b85                	andi	a5,a5,1
    80001ec0:	cbc1                	beqz	a5,80001f50 <syscall+0x110>
    {
      printf("%d: syscall %s (", p->pid, syscallnames[num]);
    80001ec2:	0b0e                	slli	s6,s6,0x3
    80001ec4:	00006797          	auipc	a5,0x6
    80001ec8:	9fc78793          	addi	a5,a5,-1540 # 800078c0 <syscall_num_args>
    80001ecc:	97da                	add	a5,a5,s6
    80001ece:	1207b603          	ld	a2,288(a5)
    80001ed2:	030a2583          	lw	a1,48(s4)
    80001ed6:	00005517          	auipc	a0,0x5
    80001eda:	4e250513          	addi	a0,a0,1250 # 800073b8 <etext+0x3b8>
    80001ede:	562030ef          	jal	80005440 <printf>
      for (int i = 0; i < nargs; i++)
    80001ee2:	03305e63          	blez	s3,80001f1e <syscall+0xde>
    80001ee6:	e8ca                	sd	s2,80(sp)
    80001ee8:	f9040913          	addi	s2,s0,-112
    80001eec:	4481                	li	s1,0
      {
        if (i > 0) printf(", ");
        printf("%d", (int) args[i]);
    80001eee:	00005a97          	auipc	s5,0x5
    80001ef2:	4eaa8a93          	addi	s5,s5,1258 # 800073d8 <etext+0x3d8>
        if (i > 0) printf(", ");
    80001ef6:	00005b17          	auipc	s6,0x5
    80001efa:	4dab0b13          	addi	s6,s6,1242 # 800073d0 <etext+0x3d0>
        printf("%d", (int) args[i]);
    80001efe:	00092583          	lw	a1,0(s2)
    80001f02:	8556                	mv	a0,s5
    80001f04:	53c030ef          	jal	80005440 <printf>
      for (int i = 0; i < nargs; i++)
    80001f08:	2485                	addiw	s1,s1,1
    80001f0a:	0921                	addi	s2,s2,8
    80001f0c:	00998863          	beq	s3,s1,80001f1c <syscall+0xdc>
        if (i > 0) printf(", ");
    80001f10:	fe9057e3          	blez	s1,80001efe <syscall+0xbe>
    80001f14:	855a                	mv	a0,s6
    80001f16:	52a030ef          	jal	80005440 <printf>
    80001f1a:	b7d5                	j	80001efe <syscall+0xbe>
    80001f1c:	6946                	ld	s2,80(sp)
      }
      printf (") -> %d\n", (int) p->trapframe->a0);
    80001f1e:	058a3783          	ld	a5,88(s4)
    80001f22:	5bac                	lw	a1,112(a5)
    80001f24:	00005517          	auipc	a0,0x5
    80001f28:	4bc50513          	addi	a0,a0,1212 # 800073e0 <etext+0x3e0>
    80001f2c:	514030ef          	jal	80005440 <printf>
    80001f30:	a005                	j	80001f50 <syscall+0x110>
    }
  }
  else
  {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80001f32:	86da                	mv	a3,s6
    80001f34:	158a0613          	addi	a2,s4,344
    80001f38:	030a2583          	lw	a1,48(s4)
    80001f3c:	00005517          	auipc	a0,0x5
    80001f40:	4b450513          	addi	a0,a0,1204 # 800073f0 <etext+0x3f0>
    80001f44:	4fc030ef          	jal	80005440 <printf>
    p->trapframe->a0 = -1;
    80001f48:	058a3783          	ld	a5,88(s4)
    80001f4c:	577d                	li	a4,-1
    80001f4e:	fbb8                	sd	a4,112(a5)
  }
}
    80001f50:	70a6                	ld	ra,104(sp)
    80001f52:	7406                	ld	s0,96(sp)
    80001f54:	64e6                	ld	s1,88(sp)
    80001f56:	69a6                	ld	s3,72(sp)
    80001f58:	6a06                	ld	s4,64(sp)
    80001f5a:	7ae2                	ld	s5,56(sp)
    80001f5c:	7b42                	ld	s6,48(sp)
    80001f5e:	6165                	addi	sp,sp,112
    80001f60:	8082                	ret

0000000080001f62 <sys_exit>:

extern void get_loadavg(int out[3]);

uint64
sys_exit(void)
{
    80001f62:	1101                	addi	sp,sp,-32
    80001f64:	ec06                	sd	ra,24(sp)
    80001f66:	e822                	sd	s0,16(sp)
    80001f68:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001f6a:	fec40593          	addi	a1,s0,-20
    80001f6e:	4501                	li	a0,0
    80001f70:	e69ff0ef          	jal	80001dd8 <argint>
  exit(n);
    80001f74:	fec42503          	lw	a0,-20(s0)
    80001f78:	d26ff0ef          	jal	8000149e <exit>
  return 0;  // not reached
}
    80001f7c:	4501                	li	a0,0
    80001f7e:	60e2                	ld	ra,24(sp)
    80001f80:	6442                	ld	s0,16(sp)
    80001f82:	6105                	addi	sp,sp,32
    80001f84:	8082                	ret

0000000080001f86 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001f86:	1141                	addi	sp,sp,-16
    80001f88:	e406                	sd	ra,8(sp)
    80001f8a:	e022                	sd	s0,0(sp)
    80001f8c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001f8e:	e2ffe0ef          	jal	80000dbc <myproc>
}
    80001f92:	5908                	lw	a0,48(a0)
    80001f94:	60a2                	ld	ra,8(sp)
    80001f96:	6402                	ld	s0,0(sp)
    80001f98:	0141                	addi	sp,sp,16
    80001f9a:	8082                	ret

0000000080001f9c <sys_fork>:

uint64
sys_fork(void)
{
    80001f9c:	1141                	addi	sp,sp,-16
    80001f9e:	e406                	sd	ra,8(sp)
    80001fa0:	e022                	sd	s0,0(sp)
    80001fa2:	0800                	addi	s0,sp,16
  return fork();
    80001fa4:	93eff0ef          	jal	800010e2 <fork>
}
    80001fa8:	60a2                	ld	ra,8(sp)
    80001faa:	6402                	ld	s0,0(sp)
    80001fac:	0141                	addi	sp,sp,16
    80001fae:	8082                	ret

0000000080001fb0 <sys_wait>:

uint64
sys_wait(void)
{
    80001fb0:	1101                	addi	sp,sp,-32
    80001fb2:	ec06                	sd	ra,24(sp)
    80001fb4:	e822                	sd	s0,16(sp)
    80001fb6:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001fb8:	fe840593          	addi	a1,s0,-24
    80001fbc:	4501                	li	a0,0
    80001fbe:	e37ff0ef          	jal	80001df4 <argaddr>
  return wait(p);
    80001fc2:	fe843503          	ld	a0,-24(s0)
    80001fc6:	e2eff0ef          	jal	800015f4 <wait>
}
    80001fca:	60e2                	ld	ra,24(sp)
    80001fcc:	6442                	ld	s0,16(sp)
    80001fce:	6105                	addi	sp,sp,32
    80001fd0:	8082                	ret

0000000080001fd2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001fd2:	7179                	addi	sp,sp,-48
    80001fd4:	f406                	sd	ra,40(sp)
    80001fd6:	f022                	sd	s0,32(sp)
    80001fd8:	ec26                	sd	s1,24(sp)
    80001fda:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001fdc:	fdc40593          	addi	a1,s0,-36
    80001fe0:	4501                	li	a0,0
    80001fe2:	df7ff0ef          	jal	80001dd8 <argint>
  addr = myproc()->sz;
    80001fe6:	dd7fe0ef          	jal	80000dbc <myproc>
    80001fea:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001fec:	fdc42503          	lw	a0,-36(s0)
    80001ff0:	8a2ff0ef          	jal	80001092 <growproc>
    80001ff4:	00054863          	bltz	a0,80002004 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001ff8:	8526                	mv	a0,s1
    80001ffa:	70a2                	ld	ra,40(sp)
    80001ffc:	7402                	ld	s0,32(sp)
    80001ffe:	64e2                	ld	s1,24(sp)
    80002000:	6145                	addi	sp,sp,48
    80002002:	8082                	ret
    return -1;
    80002004:	54fd                	li	s1,-1
    80002006:	bfcd                	j	80001ff8 <sys_sbrk+0x26>

0000000080002008 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002008:	7139                	addi	sp,sp,-64
    8000200a:	fc06                	sd	ra,56(sp)
    8000200c:	f822                	sd	s0,48(sp)
    8000200e:	f04a                	sd	s2,32(sp)
    80002010:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002012:	fcc40593          	addi	a1,s0,-52
    80002016:	4501                	li	a0,0
    80002018:	dc1ff0ef          	jal	80001dd8 <argint>
  if(n < 0)
    8000201c:	fcc42783          	lw	a5,-52(s0)
    80002020:	0607c763          	bltz	a5,8000208e <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002024:	0000e517          	auipc	a0,0xe
    80002028:	5c450513          	addi	a0,a0,1476 # 800105e8 <tickslock>
    8000202c:	215030ef          	jal	80005a40 <acquire>
  ticks0 = ticks;
    80002030:	00008917          	auipc	s2,0x8
    80002034:	52892903          	lw	s2,1320(s2) # 8000a558 <ticks>
  while(ticks - ticks0 < n){
    80002038:	fcc42783          	lw	a5,-52(s0)
    8000203c:	cf8d                	beqz	a5,80002076 <sys_sleep+0x6e>
    8000203e:	f426                	sd	s1,40(sp)
    80002040:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002042:	0000e997          	auipc	s3,0xe
    80002046:	5a698993          	addi	s3,s3,1446 # 800105e8 <tickslock>
    8000204a:	00008497          	auipc	s1,0x8
    8000204e:	50e48493          	addi	s1,s1,1294 # 8000a558 <ticks>
    if(killed(myproc())){
    80002052:	d6bfe0ef          	jal	80000dbc <myproc>
    80002056:	d74ff0ef          	jal	800015ca <killed>
    8000205a:	ed0d                	bnez	a0,80002094 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    8000205c:	85ce                	mv	a1,s3
    8000205e:	8526                	mv	a0,s1
    80002060:	b32ff0ef          	jal	80001392 <sleep>
  while(ticks - ticks0 < n){
    80002064:	409c                	lw	a5,0(s1)
    80002066:	412787bb          	subw	a5,a5,s2
    8000206a:	fcc42703          	lw	a4,-52(s0)
    8000206e:	fee7e2e3          	bltu	a5,a4,80002052 <sys_sleep+0x4a>
    80002072:	74a2                	ld	s1,40(sp)
    80002074:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002076:	0000e517          	auipc	a0,0xe
    8000207a:	57250513          	addi	a0,a0,1394 # 800105e8 <tickslock>
    8000207e:	25b030ef          	jal	80005ad8 <release>
  return 0;
    80002082:	4501                	li	a0,0
}
    80002084:	70e2                	ld	ra,56(sp)
    80002086:	7442                	ld	s0,48(sp)
    80002088:	7902                	ld	s2,32(sp)
    8000208a:	6121                	addi	sp,sp,64
    8000208c:	8082                	ret
    n = 0;
    8000208e:	fc042623          	sw	zero,-52(s0)
    80002092:	bf49                	j	80002024 <sys_sleep+0x1c>
      release(&tickslock);
    80002094:	0000e517          	auipc	a0,0xe
    80002098:	55450513          	addi	a0,a0,1364 # 800105e8 <tickslock>
    8000209c:	23d030ef          	jal	80005ad8 <release>
      return -1;
    800020a0:	557d                	li	a0,-1
    800020a2:	74a2                	ld	s1,40(sp)
    800020a4:	69e2                	ld	s3,24(sp)
    800020a6:	bff9                	j	80002084 <sys_sleep+0x7c>

00000000800020a8 <sys_trace>:

uint64 
sys_trace(void) {
    800020a8:	1101                	addi	sp,sp,-32
    800020aa:	ec06                	sd	ra,24(sp)
    800020ac:	e822                	sd	s0,16(sp)
    800020ae:	1000                	addi	s0,sp,32
    int mask;
    argint(0, &mask);
    800020b0:	fec40593          	addi	a1,s0,-20
    800020b4:	4501                	li	a0,0
    800020b6:	d23ff0ef          	jal	80001dd8 <argint>
    myproc()->trace_mask = mask;  // Save the mask for the current process
    800020ba:	d03fe0ef          	jal	80000dbc <myproc>
    800020be:	fec42783          	lw	a5,-20(s0)
    800020c2:	16f52423          	sw	a5,360(a0)
    return 0;
}
    800020c6:	4501                	li	a0,0
    800020c8:	60e2                	ld	ra,24(sp)
    800020ca:	6442                	ld	s0,16(sp)
    800020cc:	6105                	addi	sp,sp,32
    800020ce:	8082                	ret

00000000800020d0 <sys_sysinfo>:

uint64 sys_sysinfo(void)
{
    800020d0:	711d                	addi	sp,sp,-96
    800020d2:	ec86                	sd	ra,88(sp)
    800020d4:	e8a2                	sd	s0,80(sp)
    800020d6:	e4a6                	sd	s1,72(sp)
    800020d8:	1080                	addi	s0,sp,96
  struct sysinfo info;
  uint64 addr;

  argaddr(0, &addr);
    800020da:	fb840593          	addi	a1,s0,-72
    800020de:	4501                	li	a0,0
    800020e0:	d15ff0ef          	jal	80001df4 <argaddr>

  info.freemem = freemem_count(); // hoặc freemem() theo tên hàm bạn có
    800020e4:	86afe0ef          	jal	8000014e <freemem_count>
    800020e8:	fca43023          	sd	a0,-64(s0)
  info.nproc = proc_count();
    800020ec:	f3aff0ef          	jal	80001826 <proc_count>
    800020f0:	fca43423          	sd	a0,-56(s0)

  int lag[3];
  get_loadavg(lag);
    800020f4:	fa840513          	addi	a0,s0,-88
    800020f8:	82fff0ef          	jal	80001926 <get_loadavg>
  info.loadavg[0] = lag[0];
    800020fc:	fa842783          	lw	a5,-88(s0)
    80002100:	fcf42823          	sw	a5,-48(s0)
  info.loadavg[1] = lag[1];
    80002104:	fac42783          	lw	a5,-84(s0)
    80002108:	fcf42a23          	sw	a5,-44(s0)
  info.loadavg[2] = lag[2];
    8000210c:	fb042783          	lw	a5,-80(s0)
    80002110:	fcf42c23          	sw	a5,-40(s0)

  // printf("freemem=%ld nproc=%d loadavg=%d %d %d\n",
  //   info.freemem, info.nproc,
  //   info.loadavg[0], info.loadavg[1], info.loadavg[2]);

  int ret = copyout(myproc()->pagetable, addr, (char *)&info, sizeof(info));
    80002114:	ca9fe0ef          	jal	80000dbc <myproc>
    80002118:	02000693          	li	a3,32
    8000211c:	fc040613          	addi	a2,s0,-64
    80002120:	fb843583          	ld	a1,-72(s0)
    80002124:	6928                	ld	a0,80(a0)
    80002126:	8f5fe0ef          	jal	80000a1a <copyout>
    8000212a:	84aa                	mv	s1,a0
  printf("sys_sysinfo: copyout ret=%d\n", ret);  // Debug
    8000212c:	85aa                	mv	a1,a0
    8000212e:	00005517          	auipc	a0,0x5
    80002132:	39250513          	addi	a0,a0,914 # 800074c0 <etext+0x4c0>
    80002136:	30a030ef          	jal	80005440 <printf>
  if (ret < 0)
    return -1;

  return 0;
}
    8000213a:	43f4d513          	srai	a0,s1,0x3f
    8000213e:	60e6                	ld	ra,88(sp)
    80002140:	6446                	ld	s0,80(sp)
    80002142:	64a6                	ld	s1,72(sp)
    80002144:	6125                	addi	sp,sp,96
    80002146:	8082                	ret

0000000080002148 <sys_kill>:

int
sys_kill(void)
{
    80002148:	1101                	addi	sp,sp,-32
    8000214a:	ec06                	sd	ra,24(sp)
    8000214c:	e822                	sd	s0,16(sp)
    8000214e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);   
    80002150:	fec40593          	addi	a1,s0,-20
    80002154:	4501                	li	a0,0
    80002156:	c83ff0ef          	jal	80001dd8 <argint>
  return kill(pid);
    8000215a:	fec42503          	lw	a0,-20(s0)
    8000215e:	be2ff0ef          	jal	80001540 <kill>
}
    80002162:	60e2                	ld	ra,24(sp)
    80002164:	6442                	ld	s0,16(sp)
    80002166:	6105                	addi	sp,sp,32
    80002168:	8082                	ret

000000008000216a <sys_uptime>:

uint64
sys_uptime(void)
{
    8000216a:	1101                	addi	sp,sp,-32
    8000216c:	ec06                	sd	ra,24(sp)
    8000216e:	e822                	sd	s0,16(sp)
    80002170:	e426                	sd	s1,8(sp)
    80002172:	1000                	addi	s0,sp,32
  uint xticks;
  acquire(&tickslock);
    80002174:	0000e517          	auipc	a0,0xe
    80002178:	47450513          	addi	a0,a0,1140 # 800105e8 <tickslock>
    8000217c:	0c5030ef          	jal	80005a40 <acquire>
  xticks = ticks;
    80002180:	00008497          	auipc	s1,0x8
    80002184:	3d84a483          	lw	s1,984(s1) # 8000a558 <ticks>
  release(&tickslock);
    80002188:	0000e517          	auipc	a0,0xe
    8000218c:	46050513          	addi	a0,a0,1120 # 800105e8 <tickslock>
    80002190:	149030ef          	jal	80005ad8 <release>
  return xticks;
}
    80002194:	02049513          	slli	a0,s1,0x20
    80002198:	9101                	srli	a0,a0,0x20
    8000219a:	60e2                	ld	ra,24(sp)
    8000219c:	6442                	ld	s0,16(sp)
    8000219e:	64a2                	ld	s1,8(sp)
    800021a0:	6105                	addi	sp,sp,32
    800021a2:	8082                	ret

00000000800021a4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800021a4:	7179                	addi	sp,sp,-48
    800021a6:	f406                	sd	ra,40(sp)
    800021a8:	f022                	sd	s0,32(sp)
    800021aa:	ec26                	sd	s1,24(sp)
    800021ac:	e84a                	sd	s2,16(sp)
    800021ae:	e44e                	sd	s3,8(sp)
    800021b0:	e052                	sd	s4,0(sp)
    800021b2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800021b4:	00005597          	auipc	a1,0x5
    800021b8:	32c58593          	addi	a1,a1,812 # 800074e0 <etext+0x4e0>
    800021bc:	0000e517          	auipc	a0,0xe
    800021c0:	44450513          	addi	a0,a0,1092 # 80010600 <bcache>
    800021c4:	7fc030ef          	jal	800059c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800021c8:	00016797          	auipc	a5,0x16
    800021cc:	43878793          	addi	a5,a5,1080 # 80018600 <bcache+0x8000>
    800021d0:	00016717          	auipc	a4,0x16
    800021d4:	69870713          	addi	a4,a4,1688 # 80018868 <bcache+0x8268>
    800021d8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800021dc:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800021e0:	0000e497          	auipc	s1,0xe
    800021e4:	43848493          	addi	s1,s1,1080 # 80010618 <bcache+0x18>
    b->next = bcache.head.next;
    800021e8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800021ea:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800021ec:	00005a17          	auipc	s4,0x5
    800021f0:	2fca0a13          	addi	s4,s4,764 # 800074e8 <etext+0x4e8>
    b->next = bcache.head.next;
    800021f4:	2b893783          	ld	a5,696(s2)
    800021f8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800021fa:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800021fe:	85d2                	mv	a1,s4
    80002200:	01048513          	addi	a0,s1,16
    80002204:	248010ef          	jal	8000344c <initsleeplock>
    bcache.head.next->prev = b;
    80002208:	2b893783          	ld	a5,696(s2)
    8000220c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000220e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002212:	45848493          	addi	s1,s1,1112
    80002216:	fd349fe3          	bne	s1,s3,800021f4 <binit+0x50>
  }
}
    8000221a:	70a2                	ld	ra,40(sp)
    8000221c:	7402                	ld	s0,32(sp)
    8000221e:	64e2                	ld	s1,24(sp)
    80002220:	6942                	ld	s2,16(sp)
    80002222:	69a2                	ld	s3,8(sp)
    80002224:	6a02                	ld	s4,0(sp)
    80002226:	6145                	addi	sp,sp,48
    80002228:	8082                	ret

000000008000222a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000222a:	7179                	addi	sp,sp,-48
    8000222c:	f406                	sd	ra,40(sp)
    8000222e:	f022                	sd	s0,32(sp)
    80002230:	ec26                	sd	s1,24(sp)
    80002232:	e84a                	sd	s2,16(sp)
    80002234:	e44e                	sd	s3,8(sp)
    80002236:	1800                	addi	s0,sp,48
    80002238:	892a                	mv	s2,a0
    8000223a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000223c:	0000e517          	auipc	a0,0xe
    80002240:	3c450513          	addi	a0,a0,964 # 80010600 <bcache>
    80002244:	7fc030ef          	jal	80005a40 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002248:	00016497          	auipc	s1,0x16
    8000224c:	6704b483          	ld	s1,1648(s1) # 800188b8 <bcache+0x82b8>
    80002250:	00016797          	auipc	a5,0x16
    80002254:	61878793          	addi	a5,a5,1560 # 80018868 <bcache+0x8268>
    80002258:	02f48b63          	beq	s1,a5,8000228e <bread+0x64>
    8000225c:	873e                	mv	a4,a5
    8000225e:	a021                	j	80002266 <bread+0x3c>
    80002260:	68a4                	ld	s1,80(s1)
    80002262:	02e48663          	beq	s1,a4,8000228e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002266:	449c                	lw	a5,8(s1)
    80002268:	ff279ce3          	bne	a5,s2,80002260 <bread+0x36>
    8000226c:	44dc                	lw	a5,12(s1)
    8000226e:	ff3799e3          	bne	a5,s3,80002260 <bread+0x36>
      b->refcnt++;
    80002272:	40bc                	lw	a5,64(s1)
    80002274:	2785                	addiw	a5,a5,1
    80002276:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002278:	0000e517          	auipc	a0,0xe
    8000227c:	38850513          	addi	a0,a0,904 # 80010600 <bcache>
    80002280:	059030ef          	jal	80005ad8 <release>
      acquiresleep(&b->lock);
    80002284:	01048513          	addi	a0,s1,16
    80002288:	1fa010ef          	jal	80003482 <acquiresleep>
      return b;
    8000228c:	a889                	j	800022de <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000228e:	00016497          	auipc	s1,0x16
    80002292:	6224b483          	ld	s1,1570(s1) # 800188b0 <bcache+0x82b0>
    80002296:	00016797          	auipc	a5,0x16
    8000229a:	5d278793          	addi	a5,a5,1490 # 80018868 <bcache+0x8268>
    8000229e:	00f48863          	beq	s1,a5,800022ae <bread+0x84>
    800022a2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800022a4:	40bc                	lw	a5,64(s1)
    800022a6:	cb91                	beqz	a5,800022ba <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022a8:	64a4                	ld	s1,72(s1)
    800022aa:	fee49de3          	bne	s1,a4,800022a4 <bread+0x7a>
  panic("bget: no buffers");
    800022ae:	00005517          	auipc	a0,0x5
    800022b2:	24250513          	addi	a0,a0,578 # 800074f0 <etext+0x4f0>
    800022b6:	45c030ef          	jal	80005712 <panic>
      b->dev = dev;
    800022ba:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800022be:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800022c2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800022c6:	4785                	li	a5,1
    800022c8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022ca:	0000e517          	auipc	a0,0xe
    800022ce:	33650513          	addi	a0,a0,822 # 80010600 <bcache>
    800022d2:	007030ef          	jal	80005ad8 <release>
      acquiresleep(&b->lock);
    800022d6:	01048513          	addi	a0,s1,16
    800022da:	1a8010ef          	jal	80003482 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800022de:	409c                	lw	a5,0(s1)
    800022e0:	cb89                	beqz	a5,800022f2 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800022e2:	8526                	mv	a0,s1
    800022e4:	70a2                	ld	ra,40(sp)
    800022e6:	7402                	ld	s0,32(sp)
    800022e8:	64e2                	ld	s1,24(sp)
    800022ea:	6942                	ld	s2,16(sp)
    800022ec:	69a2                	ld	s3,8(sp)
    800022ee:	6145                	addi	sp,sp,48
    800022f0:	8082                	ret
    virtio_disk_rw(b, 0);
    800022f2:	4581                	li	a1,0
    800022f4:	8526                	mv	a0,s1
    800022f6:	1eb020ef          	jal	80004ce0 <virtio_disk_rw>
    b->valid = 1;
    800022fa:	4785                	li	a5,1
    800022fc:	c09c                	sw	a5,0(s1)
  return b;
    800022fe:	b7d5                	j	800022e2 <bread+0xb8>

0000000080002300 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002300:	1101                	addi	sp,sp,-32
    80002302:	ec06                	sd	ra,24(sp)
    80002304:	e822                	sd	s0,16(sp)
    80002306:	e426                	sd	s1,8(sp)
    80002308:	1000                	addi	s0,sp,32
    8000230a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000230c:	0541                	addi	a0,a0,16
    8000230e:	1f2010ef          	jal	80003500 <holdingsleep>
    80002312:	c911                	beqz	a0,80002326 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002314:	4585                	li	a1,1
    80002316:	8526                	mv	a0,s1
    80002318:	1c9020ef          	jal	80004ce0 <virtio_disk_rw>
}
    8000231c:	60e2                	ld	ra,24(sp)
    8000231e:	6442                	ld	s0,16(sp)
    80002320:	64a2                	ld	s1,8(sp)
    80002322:	6105                	addi	sp,sp,32
    80002324:	8082                	ret
    panic("bwrite");
    80002326:	00005517          	auipc	a0,0x5
    8000232a:	1e250513          	addi	a0,a0,482 # 80007508 <etext+0x508>
    8000232e:	3e4030ef          	jal	80005712 <panic>

0000000080002332 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002332:	1101                	addi	sp,sp,-32
    80002334:	ec06                	sd	ra,24(sp)
    80002336:	e822                	sd	s0,16(sp)
    80002338:	e426                	sd	s1,8(sp)
    8000233a:	e04a                	sd	s2,0(sp)
    8000233c:	1000                	addi	s0,sp,32
    8000233e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002340:	01050913          	addi	s2,a0,16
    80002344:	854a                	mv	a0,s2
    80002346:	1ba010ef          	jal	80003500 <holdingsleep>
    8000234a:	c135                	beqz	a0,800023ae <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000234c:	854a                	mv	a0,s2
    8000234e:	17a010ef          	jal	800034c8 <releasesleep>

  acquire(&bcache.lock);
    80002352:	0000e517          	auipc	a0,0xe
    80002356:	2ae50513          	addi	a0,a0,686 # 80010600 <bcache>
    8000235a:	6e6030ef          	jal	80005a40 <acquire>
  b->refcnt--;
    8000235e:	40bc                	lw	a5,64(s1)
    80002360:	37fd                	addiw	a5,a5,-1
    80002362:	0007871b          	sext.w	a4,a5
    80002366:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002368:	e71d                	bnez	a4,80002396 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000236a:	68b8                	ld	a4,80(s1)
    8000236c:	64bc                	ld	a5,72(s1)
    8000236e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002370:	68b8                	ld	a4,80(s1)
    80002372:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002374:	00016797          	auipc	a5,0x16
    80002378:	28c78793          	addi	a5,a5,652 # 80018600 <bcache+0x8000>
    8000237c:	2b87b703          	ld	a4,696(a5)
    80002380:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002382:	00016717          	auipc	a4,0x16
    80002386:	4e670713          	addi	a4,a4,1254 # 80018868 <bcache+0x8268>
    8000238a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000238c:	2b87b703          	ld	a4,696(a5)
    80002390:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002392:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002396:	0000e517          	auipc	a0,0xe
    8000239a:	26a50513          	addi	a0,a0,618 # 80010600 <bcache>
    8000239e:	73a030ef          	jal	80005ad8 <release>
}
    800023a2:	60e2                	ld	ra,24(sp)
    800023a4:	6442                	ld	s0,16(sp)
    800023a6:	64a2                	ld	s1,8(sp)
    800023a8:	6902                	ld	s2,0(sp)
    800023aa:	6105                	addi	sp,sp,32
    800023ac:	8082                	ret
    panic("brelse");
    800023ae:	00005517          	auipc	a0,0x5
    800023b2:	16250513          	addi	a0,a0,354 # 80007510 <etext+0x510>
    800023b6:	35c030ef          	jal	80005712 <panic>

00000000800023ba <bpin>:

void
bpin(struct buf *b) {
    800023ba:	1101                	addi	sp,sp,-32
    800023bc:	ec06                	sd	ra,24(sp)
    800023be:	e822                	sd	s0,16(sp)
    800023c0:	e426                	sd	s1,8(sp)
    800023c2:	1000                	addi	s0,sp,32
    800023c4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800023c6:	0000e517          	auipc	a0,0xe
    800023ca:	23a50513          	addi	a0,a0,570 # 80010600 <bcache>
    800023ce:	672030ef          	jal	80005a40 <acquire>
  b->refcnt++;
    800023d2:	40bc                	lw	a5,64(s1)
    800023d4:	2785                	addiw	a5,a5,1
    800023d6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800023d8:	0000e517          	auipc	a0,0xe
    800023dc:	22850513          	addi	a0,a0,552 # 80010600 <bcache>
    800023e0:	6f8030ef          	jal	80005ad8 <release>
}
    800023e4:	60e2                	ld	ra,24(sp)
    800023e6:	6442                	ld	s0,16(sp)
    800023e8:	64a2                	ld	s1,8(sp)
    800023ea:	6105                	addi	sp,sp,32
    800023ec:	8082                	ret

00000000800023ee <bunpin>:

void
bunpin(struct buf *b) {
    800023ee:	1101                	addi	sp,sp,-32
    800023f0:	ec06                	sd	ra,24(sp)
    800023f2:	e822                	sd	s0,16(sp)
    800023f4:	e426                	sd	s1,8(sp)
    800023f6:	1000                	addi	s0,sp,32
    800023f8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800023fa:	0000e517          	auipc	a0,0xe
    800023fe:	20650513          	addi	a0,a0,518 # 80010600 <bcache>
    80002402:	63e030ef          	jal	80005a40 <acquire>
  b->refcnt--;
    80002406:	40bc                	lw	a5,64(s1)
    80002408:	37fd                	addiw	a5,a5,-1
    8000240a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000240c:	0000e517          	auipc	a0,0xe
    80002410:	1f450513          	addi	a0,a0,500 # 80010600 <bcache>
    80002414:	6c4030ef          	jal	80005ad8 <release>
}
    80002418:	60e2                	ld	ra,24(sp)
    8000241a:	6442                	ld	s0,16(sp)
    8000241c:	64a2                	ld	s1,8(sp)
    8000241e:	6105                	addi	sp,sp,32
    80002420:	8082                	ret

0000000080002422 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002422:	1101                	addi	sp,sp,-32
    80002424:	ec06                	sd	ra,24(sp)
    80002426:	e822                	sd	s0,16(sp)
    80002428:	e426                	sd	s1,8(sp)
    8000242a:	e04a                	sd	s2,0(sp)
    8000242c:	1000                	addi	s0,sp,32
    8000242e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002430:	00d5d59b          	srliw	a1,a1,0xd
    80002434:	00017797          	auipc	a5,0x17
    80002438:	8a87a783          	lw	a5,-1880(a5) # 80018cdc <sb+0x1c>
    8000243c:	9dbd                	addw	a1,a1,a5
    8000243e:	dedff0ef          	jal	8000222a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002442:	0074f713          	andi	a4,s1,7
    80002446:	4785                	li	a5,1
    80002448:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000244c:	14ce                	slli	s1,s1,0x33
    8000244e:	90d9                	srli	s1,s1,0x36
    80002450:	00950733          	add	a4,a0,s1
    80002454:	05874703          	lbu	a4,88(a4)
    80002458:	00e7f6b3          	and	a3,a5,a4
    8000245c:	c29d                	beqz	a3,80002482 <bfree+0x60>
    8000245e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002460:	94aa                	add	s1,s1,a0
    80002462:	fff7c793          	not	a5,a5
    80002466:	8f7d                	and	a4,a4,a5
    80002468:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000246c:	711000ef          	jal	8000337c <log_write>
  brelse(bp);
    80002470:	854a                	mv	a0,s2
    80002472:	ec1ff0ef          	jal	80002332 <brelse>
}
    80002476:	60e2                	ld	ra,24(sp)
    80002478:	6442                	ld	s0,16(sp)
    8000247a:	64a2                	ld	s1,8(sp)
    8000247c:	6902                	ld	s2,0(sp)
    8000247e:	6105                	addi	sp,sp,32
    80002480:	8082                	ret
    panic("freeing free block");
    80002482:	00005517          	auipc	a0,0x5
    80002486:	09650513          	addi	a0,a0,150 # 80007518 <etext+0x518>
    8000248a:	288030ef          	jal	80005712 <panic>

000000008000248e <balloc>:
{
    8000248e:	711d                	addi	sp,sp,-96
    80002490:	ec86                	sd	ra,88(sp)
    80002492:	e8a2                	sd	s0,80(sp)
    80002494:	e4a6                	sd	s1,72(sp)
    80002496:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002498:	00017797          	auipc	a5,0x17
    8000249c:	82c7a783          	lw	a5,-2004(a5) # 80018cc4 <sb+0x4>
    800024a0:	0e078f63          	beqz	a5,8000259e <balloc+0x110>
    800024a4:	e0ca                	sd	s2,64(sp)
    800024a6:	fc4e                	sd	s3,56(sp)
    800024a8:	f852                	sd	s4,48(sp)
    800024aa:	f456                	sd	s5,40(sp)
    800024ac:	f05a                	sd	s6,32(sp)
    800024ae:	ec5e                	sd	s7,24(sp)
    800024b0:	e862                	sd	s8,16(sp)
    800024b2:	e466                	sd	s9,8(sp)
    800024b4:	8baa                	mv	s7,a0
    800024b6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800024b8:	00017b17          	auipc	s6,0x17
    800024bc:	808b0b13          	addi	s6,s6,-2040 # 80018cc0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800024c0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800024c2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800024c4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800024c6:	6c89                	lui	s9,0x2
    800024c8:	a0b5                	j	80002534 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800024ca:	97ca                	add	a5,a5,s2
    800024cc:	8e55                	or	a2,a2,a3
    800024ce:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800024d2:	854a                	mv	a0,s2
    800024d4:	6a9000ef          	jal	8000337c <log_write>
        brelse(bp);
    800024d8:	854a                	mv	a0,s2
    800024da:	e59ff0ef          	jal	80002332 <brelse>
  bp = bread(dev, bno);
    800024de:	85a6                	mv	a1,s1
    800024e0:	855e                	mv	a0,s7
    800024e2:	d49ff0ef          	jal	8000222a <bread>
    800024e6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800024e8:	40000613          	li	a2,1024
    800024ec:	4581                	li	a1,0
    800024ee:	05850513          	addi	a0,a0,88
    800024f2:	c9ffd0ef          	jal	80000190 <memset>
  log_write(bp);
    800024f6:	854a                	mv	a0,s2
    800024f8:	685000ef          	jal	8000337c <log_write>
  brelse(bp);
    800024fc:	854a                	mv	a0,s2
    800024fe:	e35ff0ef          	jal	80002332 <brelse>
}
    80002502:	6906                	ld	s2,64(sp)
    80002504:	79e2                	ld	s3,56(sp)
    80002506:	7a42                	ld	s4,48(sp)
    80002508:	7aa2                	ld	s5,40(sp)
    8000250a:	7b02                	ld	s6,32(sp)
    8000250c:	6be2                	ld	s7,24(sp)
    8000250e:	6c42                	ld	s8,16(sp)
    80002510:	6ca2                	ld	s9,8(sp)
}
    80002512:	8526                	mv	a0,s1
    80002514:	60e6                	ld	ra,88(sp)
    80002516:	6446                	ld	s0,80(sp)
    80002518:	64a6                	ld	s1,72(sp)
    8000251a:	6125                	addi	sp,sp,96
    8000251c:	8082                	ret
    brelse(bp);
    8000251e:	854a                	mv	a0,s2
    80002520:	e13ff0ef          	jal	80002332 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002524:	015c87bb          	addw	a5,s9,s5
    80002528:	00078a9b          	sext.w	s5,a5
    8000252c:	004b2703          	lw	a4,4(s6)
    80002530:	04eaff63          	bgeu	s5,a4,8000258e <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002534:	41fad79b          	sraiw	a5,s5,0x1f
    80002538:	0137d79b          	srliw	a5,a5,0x13
    8000253c:	015787bb          	addw	a5,a5,s5
    80002540:	40d7d79b          	sraiw	a5,a5,0xd
    80002544:	01cb2583          	lw	a1,28(s6)
    80002548:	9dbd                	addw	a1,a1,a5
    8000254a:	855e                	mv	a0,s7
    8000254c:	cdfff0ef          	jal	8000222a <bread>
    80002550:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002552:	004b2503          	lw	a0,4(s6)
    80002556:	000a849b          	sext.w	s1,s5
    8000255a:	8762                	mv	a4,s8
    8000255c:	fca4f1e3          	bgeu	s1,a0,8000251e <balloc+0x90>
      m = 1 << (bi % 8);
    80002560:	00777693          	andi	a3,a4,7
    80002564:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002568:	41f7579b          	sraiw	a5,a4,0x1f
    8000256c:	01d7d79b          	srliw	a5,a5,0x1d
    80002570:	9fb9                	addw	a5,a5,a4
    80002572:	4037d79b          	sraiw	a5,a5,0x3
    80002576:	00f90633          	add	a2,s2,a5
    8000257a:	05864603          	lbu	a2,88(a2)
    8000257e:	00c6f5b3          	and	a1,a3,a2
    80002582:	d5a1                	beqz	a1,800024ca <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002584:	2705                	addiw	a4,a4,1
    80002586:	2485                	addiw	s1,s1,1
    80002588:	fd471ae3          	bne	a4,s4,8000255c <balloc+0xce>
    8000258c:	bf49                	j	8000251e <balloc+0x90>
    8000258e:	6906                	ld	s2,64(sp)
    80002590:	79e2                	ld	s3,56(sp)
    80002592:	7a42                	ld	s4,48(sp)
    80002594:	7aa2                	ld	s5,40(sp)
    80002596:	7b02                	ld	s6,32(sp)
    80002598:	6be2                	ld	s7,24(sp)
    8000259a:	6c42                	ld	s8,16(sp)
    8000259c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000259e:	00005517          	auipc	a0,0x5
    800025a2:	f9250513          	addi	a0,a0,-110 # 80007530 <etext+0x530>
    800025a6:	69b020ef          	jal	80005440 <printf>
  return 0;
    800025aa:	4481                	li	s1,0
    800025ac:	b79d                	j	80002512 <balloc+0x84>

00000000800025ae <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800025ae:	7179                	addi	sp,sp,-48
    800025b0:	f406                	sd	ra,40(sp)
    800025b2:	f022                	sd	s0,32(sp)
    800025b4:	ec26                	sd	s1,24(sp)
    800025b6:	e84a                	sd	s2,16(sp)
    800025b8:	e44e                	sd	s3,8(sp)
    800025ba:	1800                	addi	s0,sp,48
    800025bc:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800025be:	47ad                	li	a5,11
    800025c0:	02b7e663          	bltu	a5,a1,800025ec <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800025c4:	02059793          	slli	a5,a1,0x20
    800025c8:	01e7d593          	srli	a1,a5,0x1e
    800025cc:	00b504b3          	add	s1,a0,a1
    800025d0:	0504a903          	lw	s2,80(s1)
    800025d4:	06091a63          	bnez	s2,80002648 <bmap+0x9a>
      addr = balloc(ip->dev);
    800025d8:	4108                	lw	a0,0(a0)
    800025da:	eb5ff0ef          	jal	8000248e <balloc>
    800025de:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800025e2:	06090363          	beqz	s2,80002648 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800025e6:	0524a823          	sw	s2,80(s1)
    800025ea:	a8b9                	j	80002648 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800025ec:	ff45849b          	addiw	s1,a1,-12
    800025f0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800025f4:	0ff00793          	li	a5,255
    800025f8:	06e7ee63          	bltu	a5,a4,80002674 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800025fc:	08052903          	lw	s2,128(a0)
    80002600:	00091d63          	bnez	s2,8000261a <bmap+0x6c>
      addr = balloc(ip->dev);
    80002604:	4108                	lw	a0,0(a0)
    80002606:	e89ff0ef          	jal	8000248e <balloc>
    8000260a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000260e:	02090d63          	beqz	s2,80002648 <bmap+0x9a>
    80002612:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002614:	0929a023          	sw	s2,128(s3)
    80002618:	a011                	j	8000261c <bmap+0x6e>
    8000261a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000261c:	85ca                	mv	a1,s2
    8000261e:	0009a503          	lw	a0,0(s3)
    80002622:	c09ff0ef          	jal	8000222a <bread>
    80002626:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002628:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000262c:	02049713          	slli	a4,s1,0x20
    80002630:	01e75593          	srli	a1,a4,0x1e
    80002634:	00b784b3          	add	s1,a5,a1
    80002638:	0004a903          	lw	s2,0(s1)
    8000263c:	00090e63          	beqz	s2,80002658 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002640:	8552                	mv	a0,s4
    80002642:	cf1ff0ef          	jal	80002332 <brelse>
    return addr;
    80002646:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002648:	854a                	mv	a0,s2
    8000264a:	70a2                	ld	ra,40(sp)
    8000264c:	7402                	ld	s0,32(sp)
    8000264e:	64e2                	ld	s1,24(sp)
    80002650:	6942                	ld	s2,16(sp)
    80002652:	69a2                	ld	s3,8(sp)
    80002654:	6145                	addi	sp,sp,48
    80002656:	8082                	ret
      addr = balloc(ip->dev);
    80002658:	0009a503          	lw	a0,0(s3)
    8000265c:	e33ff0ef          	jal	8000248e <balloc>
    80002660:	0005091b          	sext.w	s2,a0
      if(addr){
    80002664:	fc090ee3          	beqz	s2,80002640 <bmap+0x92>
        a[bn] = addr;
    80002668:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000266c:	8552                	mv	a0,s4
    8000266e:	50f000ef          	jal	8000337c <log_write>
    80002672:	b7f9                	j	80002640 <bmap+0x92>
    80002674:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002676:	00005517          	auipc	a0,0x5
    8000267a:	ed250513          	addi	a0,a0,-302 # 80007548 <etext+0x548>
    8000267e:	094030ef          	jal	80005712 <panic>

0000000080002682 <iget>:
{
    80002682:	7179                	addi	sp,sp,-48
    80002684:	f406                	sd	ra,40(sp)
    80002686:	f022                	sd	s0,32(sp)
    80002688:	ec26                	sd	s1,24(sp)
    8000268a:	e84a                	sd	s2,16(sp)
    8000268c:	e44e                	sd	s3,8(sp)
    8000268e:	e052                	sd	s4,0(sp)
    80002690:	1800                	addi	s0,sp,48
    80002692:	89aa                	mv	s3,a0
    80002694:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002696:	00016517          	auipc	a0,0x16
    8000269a:	64a50513          	addi	a0,a0,1610 # 80018ce0 <itable>
    8000269e:	3a2030ef          	jal	80005a40 <acquire>
  empty = 0;
    800026a2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800026a4:	00016497          	auipc	s1,0x16
    800026a8:	65448493          	addi	s1,s1,1620 # 80018cf8 <itable+0x18>
    800026ac:	00018697          	auipc	a3,0x18
    800026b0:	0dc68693          	addi	a3,a3,220 # 8001a788 <log>
    800026b4:	a039                	j	800026c2 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800026b6:	02090963          	beqz	s2,800026e8 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800026ba:	08848493          	addi	s1,s1,136
    800026be:	02d48863          	beq	s1,a3,800026ee <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800026c2:	449c                	lw	a5,8(s1)
    800026c4:	fef059e3          	blez	a5,800026b6 <iget+0x34>
    800026c8:	4098                	lw	a4,0(s1)
    800026ca:	ff3716e3          	bne	a4,s3,800026b6 <iget+0x34>
    800026ce:	40d8                	lw	a4,4(s1)
    800026d0:	ff4713e3          	bne	a4,s4,800026b6 <iget+0x34>
      ip->ref++;
    800026d4:	2785                	addiw	a5,a5,1
    800026d6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800026d8:	00016517          	auipc	a0,0x16
    800026dc:	60850513          	addi	a0,a0,1544 # 80018ce0 <itable>
    800026e0:	3f8030ef          	jal	80005ad8 <release>
      return ip;
    800026e4:	8926                	mv	s2,s1
    800026e6:	a02d                	j	80002710 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800026e8:	fbe9                	bnez	a5,800026ba <iget+0x38>
      empty = ip;
    800026ea:	8926                	mv	s2,s1
    800026ec:	b7f9                	j	800026ba <iget+0x38>
  if(empty == 0)
    800026ee:	02090a63          	beqz	s2,80002722 <iget+0xa0>
  ip->dev = dev;
    800026f2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800026f6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800026fa:	4785                	li	a5,1
    800026fc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002700:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002704:	00016517          	auipc	a0,0x16
    80002708:	5dc50513          	addi	a0,a0,1500 # 80018ce0 <itable>
    8000270c:	3cc030ef          	jal	80005ad8 <release>
}
    80002710:	854a                	mv	a0,s2
    80002712:	70a2                	ld	ra,40(sp)
    80002714:	7402                	ld	s0,32(sp)
    80002716:	64e2                	ld	s1,24(sp)
    80002718:	6942                	ld	s2,16(sp)
    8000271a:	69a2                	ld	s3,8(sp)
    8000271c:	6a02                	ld	s4,0(sp)
    8000271e:	6145                	addi	sp,sp,48
    80002720:	8082                	ret
    panic("iget: no inodes");
    80002722:	00005517          	auipc	a0,0x5
    80002726:	e3e50513          	addi	a0,a0,-450 # 80007560 <etext+0x560>
    8000272a:	7e9020ef          	jal	80005712 <panic>

000000008000272e <fsinit>:
fsinit(int dev) {
    8000272e:	7179                	addi	sp,sp,-48
    80002730:	f406                	sd	ra,40(sp)
    80002732:	f022                	sd	s0,32(sp)
    80002734:	ec26                	sd	s1,24(sp)
    80002736:	e84a                	sd	s2,16(sp)
    80002738:	e44e                	sd	s3,8(sp)
    8000273a:	1800                	addi	s0,sp,48
    8000273c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000273e:	4585                	li	a1,1
    80002740:	aebff0ef          	jal	8000222a <bread>
    80002744:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002746:	00016997          	auipc	s3,0x16
    8000274a:	57a98993          	addi	s3,s3,1402 # 80018cc0 <sb>
    8000274e:	02000613          	li	a2,32
    80002752:	05850593          	addi	a1,a0,88
    80002756:	854e                	mv	a0,s3
    80002758:	a95fd0ef          	jal	800001ec <memmove>
  brelse(bp);
    8000275c:	8526                	mv	a0,s1
    8000275e:	bd5ff0ef          	jal	80002332 <brelse>
  if(sb.magic != FSMAGIC)
    80002762:	0009a703          	lw	a4,0(s3)
    80002766:	102037b7          	lui	a5,0x10203
    8000276a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000276e:	02f71063          	bne	a4,a5,8000278e <fsinit+0x60>
  initlog(dev, &sb);
    80002772:	00016597          	auipc	a1,0x16
    80002776:	54e58593          	addi	a1,a1,1358 # 80018cc0 <sb>
    8000277a:	854a                	mv	a0,s2
    8000277c:	1f9000ef          	jal	80003174 <initlog>
}
    80002780:	70a2                	ld	ra,40(sp)
    80002782:	7402                	ld	s0,32(sp)
    80002784:	64e2                	ld	s1,24(sp)
    80002786:	6942                	ld	s2,16(sp)
    80002788:	69a2                	ld	s3,8(sp)
    8000278a:	6145                	addi	sp,sp,48
    8000278c:	8082                	ret
    panic("invalid file system");
    8000278e:	00005517          	auipc	a0,0x5
    80002792:	de250513          	addi	a0,a0,-542 # 80007570 <etext+0x570>
    80002796:	77d020ef          	jal	80005712 <panic>

000000008000279a <iinit>:
{
    8000279a:	7179                	addi	sp,sp,-48
    8000279c:	f406                	sd	ra,40(sp)
    8000279e:	f022                	sd	s0,32(sp)
    800027a0:	ec26                	sd	s1,24(sp)
    800027a2:	e84a                	sd	s2,16(sp)
    800027a4:	e44e                	sd	s3,8(sp)
    800027a6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800027a8:	00005597          	auipc	a1,0x5
    800027ac:	de058593          	addi	a1,a1,-544 # 80007588 <etext+0x588>
    800027b0:	00016517          	auipc	a0,0x16
    800027b4:	53050513          	addi	a0,a0,1328 # 80018ce0 <itable>
    800027b8:	208030ef          	jal	800059c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800027bc:	00016497          	auipc	s1,0x16
    800027c0:	54c48493          	addi	s1,s1,1356 # 80018d08 <itable+0x28>
    800027c4:	00018997          	auipc	s3,0x18
    800027c8:	fd498993          	addi	s3,s3,-44 # 8001a798 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800027cc:	00005917          	auipc	s2,0x5
    800027d0:	dc490913          	addi	s2,s2,-572 # 80007590 <etext+0x590>
    800027d4:	85ca                	mv	a1,s2
    800027d6:	8526                	mv	a0,s1
    800027d8:	475000ef          	jal	8000344c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800027dc:	08848493          	addi	s1,s1,136
    800027e0:	ff349ae3          	bne	s1,s3,800027d4 <iinit+0x3a>
}
    800027e4:	70a2                	ld	ra,40(sp)
    800027e6:	7402                	ld	s0,32(sp)
    800027e8:	64e2                	ld	s1,24(sp)
    800027ea:	6942                	ld	s2,16(sp)
    800027ec:	69a2                	ld	s3,8(sp)
    800027ee:	6145                	addi	sp,sp,48
    800027f0:	8082                	ret

00000000800027f2 <ialloc>:
{
    800027f2:	7139                	addi	sp,sp,-64
    800027f4:	fc06                	sd	ra,56(sp)
    800027f6:	f822                	sd	s0,48(sp)
    800027f8:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800027fa:	00016717          	auipc	a4,0x16
    800027fe:	4d272703          	lw	a4,1234(a4) # 80018ccc <sb+0xc>
    80002802:	4785                	li	a5,1
    80002804:	06e7f063          	bgeu	a5,a4,80002864 <ialloc+0x72>
    80002808:	f426                	sd	s1,40(sp)
    8000280a:	f04a                	sd	s2,32(sp)
    8000280c:	ec4e                	sd	s3,24(sp)
    8000280e:	e852                	sd	s4,16(sp)
    80002810:	e456                	sd	s5,8(sp)
    80002812:	e05a                	sd	s6,0(sp)
    80002814:	8aaa                	mv	s5,a0
    80002816:	8b2e                	mv	s6,a1
    80002818:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000281a:	00016a17          	auipc	s4,0x16
    8000281e:	4a6a0a13          	addi	s4,s4,1190 # 80018cc0 <sb>
    80002822:	00495593          	srli	a1,s2,0x4
    80002826:	018a2783          	lw	a5,24(s4)
    8000282a:	9dbd                	addw	a1,a1,a5
    8000282c:	8556                	mv	a0,s5
    8000282e:	9fdff0ef          	jal	8000222a <bread>
    80002832:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002834:	05850993          	addi	s3,a0,88
    80002838:	00f97793          	andi	a5,s2,15
    8000283c:	079a                	slli	a5,a5,0x6
    8000283e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002840:	00099783          	lh	a5,0(s3)
    80002844:	cb9d                	beqz	a5,8000287a <ialloc+0x88>
    brelse(bp);
    80002846:	aedff0ef          	jal	80002332 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000284a:	0905                	addi	s2,s2,1
    8000284c:	00ca2703          	lw	a4,12(s4)
    80002850:	0009079b          	sext.w	a5,s2
    80002854:	fce7e7e3          	bltu	a5,a4,80002822 <ialloc+0x30>
    80002858:	74a2                	ld	s1,40(sp)
    8000285a:	7902                	ld	s2,32(sp)
    8000285c:	69e2                	ld	s3,24(sp)
    8000285e:	6a42                	ld	s4,16(sp)
    80002860:	6aa2                	ld	s5,8(sp)
    80002862:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002864:	00005517          	auipc	a0,0x5
    80002868:	d3450513          	addi	a0,a0,-716 # 80007598 <etext+0x598>
    8000286c:	3d5020ef          	jal	80005440 <printf>
  return 0;
    80002870:	4501                	li	a0,0
}
    80002872:	70e2                	ld	ra,56(sp)
    80002874:	7442                	ld	s0,48(sp)
    80002876:	6121                	addi	sp,sp,64
    80002878:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000287a:	04000613          	li	a2,64
    8000287e:	4581                	li	a1,0
    80002880:	854e                	mv	a0,s3
    80002882:	90ffd0ef          	jal	80000190 <memset>
      dip->type = type;
    80002886:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000288a:	8526                	mv	a0,s1
    8000288c:	2f1000ef          	jal	8000337c <log_write>
      brelse(bp);
    80002890:	8526                	mv	a0,s1
    80002892:	aa1ff0ef          	jal	80002332 <brelse>
      return iget(dev, inum);
    80002896:	0009059b          	sext.w	a1,s2
    8000289a:	8556                	mv	a0,s5
    8000289c:	de7ff0ef          	jal	80002682 <iget>
    800028a0:	74a2                	ld	s1,40(sp)
    800028a2:	7902                	ld	s2,32(sp)
    800028a4:	69e2                	ld	s3,24(sp)
    800028a6:	6a42                	ld	s4,16(sp)
    800028a8:	6aa2                	ld	s5,8(sp)
    800028aa:	6b02                	ld	s6,0(sp)
    800028ac:	b7d9                	j	80002872 <ialloc+0x80>

00000000800028ae <iupdate>:
{
    800028ae:	1101                	addi	sp,sp,-32
    800028b0:	ec06                	sd	ra,24(sp)
    800028b2:	e822                	sd	s0,16(sp)
    800028b4:	e426                	sd	s1,8(sp)
    800028b6:	e04a                	sd	s2,0(sp)
    800028b8:	1000                	addi	s0,sp,32
    800028ba:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800028bc:	415c                	lw	a5,4(a0)
    800028be:	0047d79b          	srliw	a5,a5,0x4
    800028c2:	00016597          	auipc	a1,0x16
    800028c6:	4165a583          	lw	a1,1046(a1) # 80018cd8 <sb+0x18>
    800028ca:	9dbd                	addw	a1,a1,a5
    800028cc:	4108                	lw	a0,0(a0)
    800028ce:	95dff0ef          	jal	8000222a <bread>
    800028d2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800028d4:	05850793          	addi	a5,a0,88
    800028d8:	40d8                	lw	a4,4(s1)
    800028da:	8b3d                	andi	a4,a4,15
    800028dc:	071a                	slli	a4,a4,0x6
    800028de:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800028e0:	04449703          	lh	a4,68(s1)
    800028e4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800028e8:	04649703          	lh	a4,70(s1)
    800028ec:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800028f0:	04849703          	lh	a4,72(s1)
    800028f4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800028f8:	04a49703          	lh	a4,74(s1)
    800028fc:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002900:	44f8                	lw	a4,76(s1)
    80002902:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002904:	03400613          	li	a2,52
    80002908:	05048593          	addi	a1,s1,80
    8000290c:	00c78513          	addi	a0,a5,12
    80002910:	8ddfd0ef          	jal	800001ec <memmove>
  log_write(bp);
    80002914:	854a                	mv	a0,s2
    80002916:	267000ef          	jal	8000337c <log_write>
  brelse(bp);
    8000291a:	854a                	mv	a0,s2
    8000291c:	a17ff0ef          	jal	80002332 <brelse>
}
    80002920:	60e2                	ld	ra,24(sp)
    80002922:	6442                	ld	s0,16(sp)
    80002924:	64a2                	ld	s1,8(sp)
    80002926:	6902                	ld	s2,0(sp)
    80002928:	6105                	addi	sp,sp,32
    8000292a:	8082                	ret

000000008000292c <idup>:
{
    8000292c:	1101                	addi	sp,sp,-32
    8000292e:	ec06                	sd	ra,24(sp)
    80002930:	e822                	sd	s0,16(sp)
    80002932:	e426                	sd	s1,8(sp)
    80002934:	1000                	addi	s0,sp,32
    80002936:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002938:	00016517          	auipc	a0,0x16
    8000293c:	3a850513          	addi	a0,a0,936 # 80018ce0 <itable>
    80002940:	100030ef          	jal	80005a40 <acquire>
  ip->ref++;
    80002944:	449c                	lw	a5,8(s1)
    80002946:	2785                	addiw	a5,a5,1
    80002948:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000294a:	00016517          	auipc	a0,0x16
    8000294e:	39650513          	addi	a0,a0,918 # 80018ce0 <itable>
    80002952:	186030ef          	jal	80005ad8 <release>
}
    80002956:	8526                	mv	a0,s1
    80002958:	60e2                	ld	ra,24(sp)
    8000295a:	6442                	ld	s0,16(sp)
    8000295c:	64a2                	ld	s1,8(sp)
    8000295e:	6105                	addi	sp,sp,32
    80002960:	8082                	ret

0000000080002962 <ilock>:
{
    80002962:	1101                	addi	sp,sp,-32
    80002964:	ec06                	sd	ra,24(sp)
    80002966:	e822                	sd	s0,16(sp)
    80002968:	e426                	sd	s1,8(sp)
    8000296a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000296c:	cd19                	beqz	a0,8000298a <ilock+0x28>
    8000296e:	84aa                	mv	s1,a0
    80002970:	451c                	lw	a5,8(a0)
    80002972:	00f05c63          	blez	a5,8000298a <ilock+0x28>
  acquiresleep(&ip->lock);
    80002976:	0541                	addi	a0,a0,16
    80002978:	30b000ef          	jal	80003482 <acquiresleep>
  if(ip->valid == 0){
    8000297c:	40bc                	lw	a5,64(s1)
    8000297e:	cf89                	beqz	a5,80002998 <ilock+0x36>
}
    80002980:	60e2                	ld	ra,24(sp)
    80002982:	6442                	ld	s0,16(sp)
    80002984:	64a2                	ld	s1,8(sp)
    80002986:	6105                	addi	sp,sp,32
    80002988:	8082                	ret
    8000298a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000298c:	00005517          	auipc	a0,0x5
    80002990:	c2450513          	addi	a0,a0,-988 # 800075b0 <etext+0x5b0>
    80002994:	57f020ef          	jal	80005712 <panic>
    80002998:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000299a:	40dc                	lw	a5,4(s1)
    8000299c:	0047d79b          	srliw	a5,a5,0x4
    800029a0:	00016597          	auipc	a1,0x16
    800029a4:	3385a583          	lw	a1,824(a1) # 80018cd8 <sb+0x18>
    800029a8:	9dbd                	addw	a1,a1,a5
    800029aa:	4088                	lw	a0,0(s1)
    800029ac:	87fff0ef          	jal	8000222a <bread>
    800029b0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800029b2:	05850593          	addi	a1,a0,88
    800029b6:	40dc                	lw	a5,4(s1)
    800029b8:	8bbd                	andi	a5,a5,15
    800029ba:	079a                	slli	a5,a5,0x6
    800029bc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800029be:	00059783          	lh	a5,0(a1)
    800029c2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800029c6:	00259783          	lh	a5,2(a1)
    800029ca:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800029ce:	00459783          	lh	a5,4(a1)
    800029d2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800029d6:	00659783          	lh	a5,6(a1)
    800029da:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800029de:	459c                	lw	a5,8(a1)
    800029e0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800029e2:	03400613          	li	a2,52
    800029e6:	05b1                	addi	a1,a1,12
    800029e8:	05048513          	addi	a0,s1,80
    800029ec:	801fd0ef          	jal	800001ec <memmove>
    brelse(bp);
    800029f0:	854a                	mv	a0,s2
    800029f2:	941ff0ef          	jal	80002332 <brelse>
    ip->valid = 1;
    800029f6:	4785                	li	a5,1
    800029f8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800029fa:	04449783          	lh	a5,68(s1)
    800029fe:	c399                	beqz	a5,80002a04 <ilock+0xa2>
    80002a00:	6902                	ld	s2,0(sp)
    80002a02:	bfbd                	j	80002980 <ilock+0x1e>
      panic("ilock: no type");
    80002a04:	00005517          	auipc	a0,0x5
    80002a08:	bb450513          	addi	a0,a0,-1100 # 800075b8 <etext+0x5b8>
    80002a0c:	507020ef          	jal	80005712 <panic>

0000000080002a10 <iunlock>:
{
    80002a10:	1101                	addi	sp,sp,-32
    80002a12:	ec06                	sd	ra,24(sp)
    80002a14:	e822                	sd	s0,16(sp)
    80002a16:	e426                	sd	s1,8(sp)
    80002a18:	e04a                	sd	s2,0(sp)
    80002a1a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002a1c:	c505                	beqz	a0,80002a44 <iunlock+0x34>
    80002a1e:	84aa                	mv	s1,a0
    80002a20:	01050913          	addi	s2,a0,16
    80002a24:	854a                	mv	a0,s2
    80002a26:	2db000ef          	jal	80003500 <holdingsleep>
    80002a2a:	cd09                	beqz	a0,80002a44 <iunlock+0x34>
    80002a2c:	449c                	lw	a5,8(s1)
    80002a2e:	00f05b63          	blez	a5,80002a44 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002a32:	854a                	mv	a0,s2
    80002a34:	295000ef          	jal	800034c8 <releasesleep>
}
    80002a38:	60e2                	ld	ra,24(sp)
    80002a3a:	6442                	ld	s0,16(sp)
    80002a3c:	64a2                	ld	s1,8(sp)
    80002a3e:	6902                	ld	s2,0(sp)
    80002a40:	6105                	addi	sp,sp,32
    80002a42:	8082                	ret
    panic("iunlock");
    80002a44:	00005517          	auipc	a0,0x5
    80002a48:	b8450513          	addi	a0,a0,-1148 # 800075c8 <etext+0x5c8>
    80002a4c:	4c7020ef          	jal	80005712 <panic>

0000000080002a50 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002a50:	7179                	addi	sp,sp,-48
    80002a52:	f406                	sd	ra,40(sp)
    80002a54:	f022                	sd	s0,32(sp)
    80002a56:	ec26                	sd	s1,24(sp)
    80002a58:	e84a                	sd	s2,16(sp)
    80002a5a:	e44e                	sd	s3,8(sp)
    80002a5c:	1800                	addi	s0,sp,48
    80002a5e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002a60:	05050493          	addi	s1,a0,80
    80002a64:	08050913          	addi	s2,a0,128
    80002a68:	a021                	j	80002a70 <itrunc+0x20>
    80002a6a:	0491                	addi	s1,s1,4
    80002a6c:	01248b63          	beq	s1,s2,80002a82 <itrunc+0x32>
    if(ip->addrs[i]){
    80002a70:	408c                	lw	a1,0(s1)
    80002a72:	dde5                	beqz	a1,80002a6a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002a74:	0009a503          	lw	a0,0(s3)
    80002a78:	9abff0ef          	jal	80002422 <bfree>
      ip->addrs[i] = 0;
    80002a7c:	0004a023          	sw	zero,0(s1)
    80002a80:	b7ed                	j	80002a6a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002a82:	0809a583          	lw	a1,128(s3)
    80002a86:	ed89                	bnez	a1,80002aa0 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002a88:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002a8c:	854e                	mv	a0,s3
    80002a8e:	e21ff0ef          	jal	800028ae <iupdate>
}
    80002a92:	70a2                	ld	ra,40(sp)
    80002a94:	7402                	ld	s0,32(sp)
    80002a96:	64e2                	ld	s1,24(sp)
    80002a98:	6942                	ld	s2,16(sp)
    80002a9a:	69a2                	ld	s3,8(sp)
    80002a9c:	6145                	addi	sp,sp,48
    80002a9e:	8082                	ret
    80002aa0:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002aa2:	0009a503          	lw	a0,0(s3)
    80002aa6:	f84ff0ef          	jal	8000222a <bread>
    80002aaa:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002aac:	05850493          	addi	s1,a0,88
    80002ab0:	45850913          	addi	s2,a0,1112
    80002ab4:	a021                	j	80002abc <itrunc+0x6c>
    80002ab6:	0491                	addi	s1,s1,4
    80002ab8:	01248963          	beq	s1,s2,80002aca <itrunc+0x7a>
      if(a[j])
    80002abc:	408c                	lw	a1,0(s1)
    80002abe:	dde5                	beqz	a1,80002ab6 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002ac0:	0009a503          	lw	a0,0(s3)
    80002ac4:	95fff0ef          	jal	80002422 <bfree>
    80002ac8:	b7fd                	j	80002ab6 <itrunc+0x66>
    brelse(bp);
    80002aca:	8552                	mv	a0,s4
    80002acc:	867ff0ef          	jal	80002332 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ad0:	0809a583          	lw	a1,128(s3)
    80002ad4:	0009a503          	lw	a0,0(s3)
    80002ad8:	94bff0ef          	jal	80002422 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002adc:	0809a023          	sw	zero,128(s3)
    80002ae0:	6a02                	ld	s4,0(sp)
    80002ae2:	b75d                	j	80002a88 <itrunc+0x38>

0000000080002ae4 <iput>:
{
    80002ae4:	1101                	addi	sp,sp,-32
    80002ae6:	ec06                	sd	ra,24(sp)
    80002ae8:	e822                	sd	s0,16(sp)
    80002aea:	e426                	sd	s1,8(sp)
    80002aec:	1000                	addi	s0,sp,32
    80002aee:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002af0:	00016517          	auipc	a0,0x16
    80002af4:	1f050513          	addi	a0,a0,496 # 80018ce0 <itable>
    80002af8:	749020ef          	jal	80005a40 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002afc:	4498                	lw	a4,8(s1)
    80002afe:	4785                	li	a5,1
    80002b00:	02f70063          	beq	a4,a5,80002b20 <iput+0x3c>
  ip->ref--;
    80002b04:	449c                	lw	a5,8(s1)
    80002b06:	37fd                	addiw	a5,a5,-1
    80002b08:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b0a:	00016517          	auipc	a0,0x16
    80002b0e:	1d650513          	addi	a0,a0,470 # 80018ce0 <itable>
    80002b12:	7c7020ef          	jal	80005ad8 <release>
}
    80002b16:	60e2                	ld	ra,24(sp)
    80002b18:	6442                	ld	s0,16(sp)
    80002b1a:	64a2                	ld	s1,8(sp)
    80002b1c:	6105                	addi	sp,sp,32
    80002b1e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002b20:	40bc                	lw	a5,64(s1)
    80002b22:	d3ed                	beqz	a5,80002b04 <iput+0x20>
    80002b24:	04a49783          	lh	a5,74(s1)
    80002b28:	fff1                	bnez	a5,80002b04 <iput+0x20>
    80002b2a:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002b2c:	01048913          	addi	s2,s1,16
    80002b30:	854a                	mv	a0,s2
    80002b32:	151000ef          	jal	80003482 <acquiresleep>
    release(&itable.lock);
    80002b36:	00016517          	auipc	a0,0x16
    80002b3a:	1aa50513          	addi	a0,a0,426 # 80018ce0 <itable>
    80002b3e:	79b020ef          	jal	80005ad8 <release>
    itrunc(ip);
    80002b42:	8526                	mv	a0,s1
    80002b44:	f0dff0ef          	jal	80002a50 <itrunc>
    ip->type = 0;
    80002b48:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002b4c:	8526                	mv	a0,s1
    80002b4e:	d61ff0ef          	jal	800028ae <iupdate>
    ip->valid = 0;
    80002b52:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002b56:	854a                	mv	a0,s2
    80002b58:	171000ef          	jal	800034c8 <releasesleep>
    acquire(&itable.lock);
    80002b5c:	00016517          	auipc	a0,0x16
    80002b60:	18450513          	addi	a0,a0,388 # 80018ce0 <itable>
    80002b64:	6dd020ef          	jal	80005a40 <acquire>
    80002b68:	6902                	ld	s2,0(sp)
    80002b6a:	bf69                	j	80002b04 <iput+0x20>

0000000080002b6c <iunlockput>:
{
    80002b6c:	1101                	addi	sp,sp,-32
    80002b6e:	ec06                	sd	ra,24(sp)
    80002b70:	e822                	sd	s0,16(sp)
    80002b72:	e426                	sd	s1,8(sp)
    80002b74:	1000                	addi	s0,sp,32
    80002b76:	84aa                	mv	s1,a0
  iunlock(ip);
    80002b78:	e99ff0ef          	jal	80002a10 <iunlock>
  iput(ip);
    80002b7c:	8526                	mv	a0,s1
    80002b7e:	f67ff0ef          	jal	80002ae4 <iput>
}
    80002b82:	60e2                	ld	ra,24(sp)
    80002b84:	6442                	ld	s0,16(sp)
    80002b86:	64a2                	ld	s1,8(sp)
    80002b88:	6105                	addi	sp,sp,32
    80002b8a:	8082                	ret

0000000080002b8c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002b8c:	1141                	addi	sp,sp,-16
    80002b8e:	e422                	sd	s0,8(sp)
    80002b90:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002b92:	411c                	lw	a5,0(a0)
    80002b94:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002b96:	415c                	lw	a5,4(a0)
    80002b98:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002b9a:	04451783          	lh	a5,68(a0)
    80002b9e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ba2:	04a51783          	lh	a5,74(a0)
    80002ba6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002baa:	04c56783          	lwu	a5,76(a0)
    80002bae:	e99c                	sd	a5,16(a1)
}
    80002bb0:	6422                	ld	s0,8(sp)
    80002bb2:	0141                	addi	sp,sp,16
    80002bb4:	8082                	ret

0000000080002bb6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002bb6:	457c                	lw	a5,76(a0)
    80002bb8:	0ed7eb63          	bltu	a5,a3,80002cae <readi+0xf8>
{
    80002bbc:	7159                	addi	sp,sp,-112
    80002bbe:	f486                	sd	ra,104(sp)
    80002bc0:	f0a2                	sd	s0,96(sp)
    80002bc2:	eca6                	sd	s1,88(sp)
    80002bc4:	e0d2                	sd	s4,64(sp)
    80002bc6:	fc56                	sd	s5,56(sp)
    80002bc8:	f85a                	sd	s6,48(sp)
    80002bca:	f45e                	sd	s7,40(sp)
    80002bcc:	1880                	addi	s0,sp,112
    80002bce:	8b2a                	mv	s6,a0
    80002bd0:	8bae                	mv	s7,a1
    80002bd2:	8a32                	mv	s4,a2
    80002bd4:	84b6                	mv	s1,a3
    80002bd6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002bd8:	9f35                	addw	a4,a4,a3
    return 0;
    80002bda:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002bdc:	0cd76063          	bltu	a4,a3,80002c9c <readi+0xe6>
    80002be0:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002be2:	00e7f463          	bgeu	a5,a4,80002bea <readi+0x34>
    n = ip->size - off;
    80002be6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002bea:	080a8f63          	beqz	s5,80002c88 <readi+0xd2>
    80002bee:	e8ca                	sd	s2,80(sp)
    80002bf0:	f062                	sd	s8,32(sp)
    80002bf2:	ec66                	sd	s9,24(sp)
    80002bf4:	e86a                	sd	s10,16(sp)
    80002bf6:	e46e                	sd	s11,8(sp)
    80002bf8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bfa:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002bfe:	5c7d                	li	s8,-1
    80002c00:	a80d                	j	80002c32 <readi+0x7c>
    80002c02:	020d1d93          	slli	s11,s10,0x20
    80002c06:	020ddd93          	srli	s11,s11,0x20
    80002c0a:	05890613          	addi	a2,s2,88
    80002c0e:	86ee                	mv	a3,s11
    80002c10:	963a                	add	a2,a2,a4
    80002c12:	85d2                	mv	a1,s4
    80002c14:	855e                	mv	a0,s7
    80002c16:	ad9fe0ef          	jal	800016ee <either_copyout>
    80002c1a:	05850763          	beq	a0,s8,80002c68 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002c1e:	854a                	mv	a0,s2
    80002c20:	f12ff0ef          	jal	80002332 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002c24:	013d09bb          	addw	s3,s10,s3
    80002c28:	009d04bb          	addw	s1,s10,s1
    80002c2c:	9a6e                	add	s4,s4,s11
    80002c2e:	0559f763          	bgeu	s3,s5,80002c7c <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002c32:	00a4d59b          	srliw	a1,s1,0xa
    80002c36:	855a                	mv	a0,s6
    80002c38:	977ff0ef          	jal	800025ae <bmap>
    80002c3c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002c40:	c5b1                	beqz	a1,80002c8c <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002c42:	000b2503          	lw	a0,0(s6)
    80002c46:	de4ff0ef          	jal	8000222a <bread>
    80002c4a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c4c:	3ff4f713          	andi	a4,s1,1023
    80002c50:	40ec87bb          	subw	a5,s9,a4
    80002c54:	413a86bb          	subw	a3,s5,s3
    80002c58:	8d3e                	mv	s10,a5
    80002c5a:	2781                	sext.w	a5,a5
    80002c5c:	0006861b          	sext.w	a2,a3
    80002c60:	faf671e3          	bgeu	a2,a5,80002c02 <readi+0x4c>
    80002c64:	8d36                	mv	s10,a3
    80002c66:	bf71                	j	80002c02 <readi+0x4c>
      brelse(bp);
    80002c68:	854a                	mv	a0,s2
    80002c6a:	ec8ff0ef          	jal	80002332 <brelse>
      tot = -1;
    80002c6e:	59fd                	li	s3,-1
      break;
    80002c70:	6946                	ld	s2,80(sp)
    80002c72:	7c02                	ld	s8,32(sp)
    80002c74:	6ce2                	ld	s9,24(sp)
    80002c76:	6d42                	ld	s10,16(sp)
    80002c78:	6da2                	ld	s11,8(sp)
    80002c7a:	a831                	j	80002c96 <readi+0xe0>
    80002c7c:	6946                	ld	s2,80(sp)
    80002c7e:	7c02                	ld	s8,32(sp)
    80002c80:	6ce2                	ld	s9,24(sp)
    80002c82:	6d42                	ld	s10,16(sp)
    80002c84:	6da2                	ld	s11,8(sp)
    80002c86:	a801                	j	80002c96 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002c88:	89d6                	mv	s3,s5
    80002c8a:	a031                	j	80002c96 <readi+0xe0>
    80002c8c:	6946                	ld	s2,80(sp)
    80002c8e:	7c02                	ld	s8,32(sp)
    80002c90:	6ce2                	ld	s9,24(sp)
    80002c92:	6d42                	ld	s10,16(sp)
    80002c94:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002c96:	0009851b          	sext.w	a0,s3
    80002c9a:	69a6                	ld	s3,72(sp)
}
    80002c9c:	70a6                	ld	ra,104(sp)
    80002c9e:	7406                	ld	s0,96(sp)
    80002ca0:	64e6                	ld	s1,88(sp)
    80002ca2:	6a06                	ld	s4,64(sp)
    80002ca4:	7ae2                	ld	s5,56(sp)
    80002ca6:	7b42                	ld	s6,48(sp)
    80002ca8:	7ba2                	ld	s7,40(sp)
    80002caa:	6165                	addi	sp,sp,112
    80002cac:	8082                	ret
    return 0;
    80002cae:	4501                	li	a0,0
}
    80002cb0:	8082                	ret

0000000080002cb2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002cb2:	457c                	lw	a5,76(a0)
    80002cb4:	10d7e063          	bltu	a5,a3,80002db4 <writei+0x102>
{
    80002cb8:	7159                	addi	sp,sp,-112
    80002cba:	f486                	sd	ra,104(sp)
    80002cbc:	f0a2                	sd	s0,96(sp)
    80002cbe:	e8ca                	sd	s2,80(sp)
    80002cc0:	e0d2                	sd	s4,64(sp)
    80002cc2:	fc56                	sd	s5,56(sp)
    80002cc4:	f85a                	sd	s6,48(sp)
    80002cc6:	f45e                	sd	s7,40(sp)
    80002cc8:	1880                	addi	s0,sp,112
    80002cca:	8aaa                	mv	s5,a0
    80002ccc:	8bae                	mv	s7,a1
    80002cce:	8a32                	mv	s4,a2
    80002cd0:	8936                	mv	s2,a3
    80002cd2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002cd4:	00e687bb          	addw	a5,a3,a4
    80002cd8:	0ed7e063          	bltu	a5,a3,80002db8 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002cdc:	00043737          	lui	a4,0x43
    80002ce0:	0cf76e63          	bltu	a4,a5,80002dbc <writei+0x10a>
    80002ce4:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ce6:	0a0b0f63          	beqz	s6,80002da4 <writei+0xf2>
    80002cea:	eca6                	sd	s1,88(sp)
    80002cec:	f062                	sd	s8,32(sp)
    80002cee:	ec66                	sd	s9,24(sp)
    80002cf0:	e86a                	sd	s10,16(sp)
    80002cf2:	e46e                	sd	s11,8(sp)
    80002cf4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002cf6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002cfa:	5c7d                	li	s8,-1
    80002cfc:	a825                	j	80002d34 <writei+0x82>
    80002cfe:	020d1d93          	slli	s11,s10,0x20
    80002d02:	020ddd93          	srli	s11,s11,0x20
    80002d06:	05848513          	addi	a0,s1,88
    80002d0a:	86ee                	mv	a3,s11
    80002d0c:	8652                	mv	a2,s4
    80002d0e:	85de                	mv	a1,s7
    80002d10:	953a                	add	a0,a0,a4
    80002d12:	a27fe0ef          	jal	80001738 <either_copyin>
    80002d16:	05850a63          	beq	a0,s8,80002d6a <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002d1a:	8526                	mv	a0,s1
    80002d1c:	660000ef          	jal	8000337c <log_write>
    brelse(bp);
    80002d20:	8526                	mv	a0,s1
    80002d22:	e10ff0ef          	jal	80002332 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002d26:	013d09bb          	addw	s3,s10,s3
    80002d2a:	012d093b          	addw	s2,s10,s2
    80002d2e:	9a6e                	add	s4,s4,s11
    80002d30:	0569f063          	bgeu	s3,s6,80002d70 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002d34:	00a9559b          	srliw	a1,s2,0xa
    80002d38:	8556                	mv	a0,s5
    80002d3a:	875ff0ef          	jal	800025ae <bmap>
    80002d3e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002d42:	c59d                	beqz	a1,80002d70 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002d44:	000aa503          	lw	a0,0(s5)
    80002d48:	ce2ff0ef          	jal	8000222a <bread>
    80002d4c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d4e:	3ff97713          	andi	a4,s2,1023
    80002d52:	40ec87bb          	subw	a5,s9,a4
    80002d56:	413b06bb          	subw	a3,s6,s3
    80002d5a:	8d3e                	mv	s10,a5
    80002d5c:	2781                	sext.w	a5,a5
    80002d5e:	0006861b          	sext.w	a2,a3
    80002d62:	f8f67ee3          	bgeu	a2,a5,80002cfe <writei+0x4c>
    80002d66:	8d36                	mv	s10,a3
    80002d68:	bf59                	j	80002cfe <writei+0x4c>
      brelse(bp);
    80002d6a:	8526                	mv	a0,s1
    80002d6c:	dc6ff0ef          	jal	80002332 <brelse>
  }

  if(off > ip->size)
    80002d70:	04caa783          	lw	a5,76(s5)
    80002d74:	0327fa63          	bgeu	a5,s2,80002da8 <writei+0xf6>
    ip->size = off;
    80002d78:	052aa623          	sw	s2,76(s5)
    80002d7c:	64e6                	ld	s1,88(sp)
    80002d7e:	7c02                	ld	s8,32(sp)
    80002d80:	6ce2                	ld	s9,24(sp)
    80002d82:	6d42                	ld	s10,16(sp)
    80002d84:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002d86:	8556                	mv	a0,s5
    80002d88:	b27ff0ef          	jal	800028ae <iupdate>

  return tot;
    80002d8c:	0009851b          	sext.w	a0,s3
    80002d90:	69a6                	ld	s3,72(sp)
}
    80002d92:	70a6                	ld	ra,104(sp)
    80002d94:	7406                	ld	s0,96(sp)
    80002d96:	6946                	ld	s2,80(sp)
    80002d98:	6a06                	ld	s4,64(sp)
    80002d9a:	7ae2                	ld	s5,56(sp)
    80002d9c:	7b42                	ld	s6,48(sp)
    80002d9e:	7ba2                	ld	s7,40(sp)
    80002da0:	6165                	addi	sp,sp,112
    80002da2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002da4:	89da                	mv	s3,s6
    80002da6:	b7c5                	j	80002d86 <writei+0xd4>
    80002da8:	64e6                	ld	s1,88(sp)
    80002daa:	7c02                	ld	s8,32(sp)
    80002dac:	6ce2                	ld	s9,24(sp)
    80002dae:	6d42                	ld	s10,16(sp)
    80002db0:	6da2                	ld	s11,8(sp)
    80002db2:	bfd1                	j	80002d86 <writei+0xd4>
    return -1;
    80002db4:	557d                	li	a0,-1
}
    80002db6:	8082                	ret
    return -1;
    80002db8:	557d                	li	a0,-1
    80002dba:	bfe1                	j	80002d92 <writei+0xe0>
    return -1;
    80002dbc:	557d                	li	a0,-1
    80002dbe:	bfd1                	j	80002d92 <writei+0xe0>

0000000080002dc0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002dc0:	1141                	addi	sp,sp,-16
    80002dc2:	e406                	sd	ra,8(sp)
    80002dc4:	e022                	sd	s0,0(sp)
    80002dc6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002dc8:	4639                	li	a2,14
    80002dca:	c92fd0ef          	jal	8000025c <strncmp>
}
    80002dce:	60a2                	ld	ra,8(sp)
    80002dd0:	6402                	ld	s0,0(sp)
    80002dd2:	0141                	addi	sp,sp,16
    80002dd4:	8082                	ret

0000000080002dd6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002dd6:	7139                	addi	sp,sp,-64
    80002dd8:	fc06                	sd	ra,56(sp)
    80002dda:	f822                	sd	s0,48(sp)
    80002ddc:	f426                	sd	s1,40(sp)
    80002dde:	f04a                	sd	s2,32(sp)
    80002de0:	ec4e                	sd	s3,24(sp)
    80002de2:	e852                	sd	s4,16(sp)
    80002de4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002de6:	04451703          	lh	a4,68(a0)
    80002dea:	4785                	li	a5,1
    80002dec:	00f71a63          	bne	a4,a5,80002e00 <dirlookup+0x2a>
    80002df0:	892a                	mv	s2,a0
    80002df2:	89ae                	mv	s3,a1
    80002df4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002df6:	457c                	lw	a5,76(a0)
    80002df8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002dfa:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002dfc:	e39d                	bnez	a5,80002e22 <dirlookup+0x4c>
    80002dfe:	a095                	j	80002e62 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002e00:	00004517          	auipc	a0,0x4
    80002e04:	7d050513          	addi	a0,a0,2000 # 800075d0 <etext+0x5d0>
    80002e08:	10b020ef          	jal	80005712 <panic>
      panic("dirlookup read");
    80002e0c:	00004517          	auipc	a0,0x4
    80002e10:	7dc50513          	addi	a0,a0,2012 # 800075e8 <etext+0x5e8>
    80002e14:	0ff020ef          	jal	80005712 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e18:	24c1                	addiw	s1,s1,16
    80002e1a:	04c92783          	lw	a5,76(s2)
    80002e1e:	04f4f163          	bgeu	s1,a5,80002e60 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e22:	4741                	li	a4,16
    80002e24:	86a6                	mv	a3,s1
    80002e26:	fc040613          	addi	a2,s0,-64
    80002e2a:	4581                	li	a1,0
    80002e2c:	854a                	mv	a0,s2
    80002e2e:	d89ff0ef          	jal	80002bb6 <readi>
    80002e32:	47c1                	li	a5,16
    80002e34:	fcf51ce3          	bne	a0,a5,80002e0c <dirlookup+0x36>
    if(de.inum == 0)
    80002e38:	fc045783          	lhu	a5,-64(s0)
    80002e3c:	dff1                	beqz	a5,80002e18 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002e3e:	fc240593          	addi	a1,s0,-62
    80002e42:	854e                	mv	a0,s3
    80002e44:	f7dff0ef          	jal	80002dc0 <namecmp>
    80002e48:	f961                	bnez	a0,80002e18 <dirlookup+0x42>
      if(poff)
    80002e4a:	000a0463          	beqz	s4,80002e52 <dirlookup+0x7c>
        *poff = off;
    80002e4e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002e52:	fc045583          	lhu	a1,-64(s0)
    80002e56:	00092503          	lw	a0,0(s2)
    80002e5a:	829ff0ef          	jal	80002682 <iget>
    80002e5e:	a011                	j	80002e62 <dirlookup+0x8c>
  return 0;
    80002e60:	4501                	li	a0,0
}
    80002e62:	70e2                	ld	ra,56(sp)
    80002e64:	7442                	ld	s0,48(sp)
    80002e66:	74a2                	ld	s1,40(sp)
    80002e68:	7902                	ld	s2,32(sp)
    80002e6a:	69e2                	ld	s3,24(sp)
    80002e6c:	6a42                	ld	s4,16(sp)
    80002e6e:	6121                	addi	sp,sp,64
    80002e70:	8082                	ret

0000000080002e72 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002e72:	711d                	addi	sp,sp,-96
    80002e74:	ec86                	sd	ra,88(sp)
    80002e76:	e8a2                	sd	s0,80(sp)
    80002e78:	e4a6                	sd	s1,72(sp)
    80002e7a:	e0ca                	sd	s2,64(sp)
    80002e7c:	fc4e                	sd	s3,56(sp)
    80002e7e:	f852                	sd	s4,48(sp)
    80002e80:	f456                	sd	s5,40(sp)
    80002e82:	f05a                	sd	s6,32(sp)
    80002e84:	ec5e                	sd	s7,24(sp)
    80002e86:	e862                	sd	s8,16(sp)
    80002e88:	e466                	sd	s9,8(sp)
    80002e8a:	1080                	addi	s0,sp,96
    80002e8c:	84aa                	mv	s1,a0
    80002e8e:	8b2e                	mv	s6,a1
    80002e90:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002e92:	00054703          	lbu	a4,0(a0)
    80002e96:	02f00793          	li	a5,47
    80002e9a:	00f70e63          	beq	a4,a5,80002eb6 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002e9e:	f1ffd0ef          	jal	80000dbc <myproc>
    80002ea2:	15053503          	ld	a0,336(a0)
    80002ea6:	a87ff0ef          	jal	8000292c <idup>
    80002eaa:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002eac:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002eb0:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002eb2:	4b85                	li	s7,1
    80002eb4:	a871                	j	80002f50 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002eb6:	4585                	li	a1,1
    80002eb8:	4505                	li	a0,1
    80002eba:	fc8ff0ef          	jal	80002682 <iget>
    80002ebe:	8a2a                	mv	s4,a0
    80002ec0:	b7f5                	j	80002eac <namex+0x3a>
      iunlockput(ip);
    80002ec2:	8552                	mv	a0,s4
    80002ec4:	ca9ff0ef          	jal	80002b6c <iunlockput>
      return 0;
    80002ec8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002eca:	8552                	mv	a0,s4
    80002ecc:	60e6                	ld	ra,88(sp)
    80002ece:	6446                	ld	s0,80(sp)
    80002ed0:	64a6                	ld	s1,72(sp)
    80002ed2:	6906                	ld	s2,64(sp)
    80002ed4:	79e2                	ld	s3,56(sp)
    80002ed6:	7a42                	ld	s4,48(sp)
    80002ed8:	7aa2                	ld	s5,40(sp)
    80002eda:	7b02                	ld	s6,32(sp)
    80002edc:	6be2                	ld	s7,24(sp)
    80002ede:	6c42                	ld	s8,16(sp)
    80002ee0:	6ca2                	ld	s9,8(sp)
    80002ee2:	6125                	addi	sp,sp,96
    80002ee4:	8082                	ret
      iunlock(ip);
    80002ee6:	8552                	mv	a0,s4
    80002ee8:	b29ff0ef          	jal	80002a10 <iunlock>
      return ip;
    80002eec:	bff9                	j	80002eca <namex+0x58>
      iunlockput(ip);
    80002eee:	8552                	mv	a0,s4
    80002ef0:	c7dff0ef          	jal	80002b6c <iunlockput>
      return 0;
    80002ef4:	8a4e                	mv	s4,s3
    80002ef6:	bfd1                	j	80002eca <namex+0x58>
  len = path - s;
    80002ef8:	40998633          	sub	a2,s3,s1
    80002efc:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002f00:	099c5063          	bge	s8,s9,80002f80 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002f04:	4639                	li	a2,14
    80002f06:	85a6                	mv	a1,s1
    80002f08:	8556                	mv	a0,s5
    80002f0a:	ae2fd0ef          	jal	800001ec <memmove>
    80002f0e:	84ce                	mv	s1,s3
  while(*path == '/')
    80002f10:	0004c783          	lbu	a5,0(s1)
    80002f14:	01279763          	bne	a5,s2,80002f22 <namex+0xb0>
    path++;
    80002f18:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002f1a:	0004c783          	lbu	a5,0(s1)
    80002f1e:	ff278de3          	beq	a5,s2,80002f18 <namex+0xa6>
    ilock(ip);
    80002f22:	8552                	mv	a0,s4
    80002f24:	a3fff0ef          	jal	80002962 <ilock>
    if(ip->type != T_DIR){
    80002f28:	044a1783          	lh	a5,68(s4)
    80002f2c:	f9779be3          	bne	a5,s7,80002ec2 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002f30:	000b0563          	beqz	s6,80002f3a <namex+0xc8>
    80002f34:	0004c783          	lbu	a5,0(s1)
    80002f38:	d7dd                	beqz	a5,80002ee6 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002f3a:	4601                	li	a2,0
    80002f3c:	85d6                	mv	a1,s5
    80002f3e:	8552                	mv	a0,s4
    80002f40:	e97ff0ef          	jal	80002dd6 <dirlookup>
    80002f44:	89aa                	mv	s3,a0
    80002f46:	d545                	beqz	a0,80002eee <namex+0x7c>
    iunlockput(ip);
    80002f48:	8552                	mv	a0,s4
    80002f4a:	c23ff0ef          	jal	80002b6c <iunlockput>
    ip = next;
    80002f4e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002f50:	0004c783          	lbu	a5,0(s1)
    80002f54:	01279763          	bne	a5,s2,80002f62 <namex+0xf0>
    path++;
    80002f58:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002f5a:	0004c783          	lbu	a5,0(s1)
    80002f5e:	ff278de3          	beq	a5,s2,80002f58 <namex+0xe6>
  if(*path == 0)
    80002f62:	cb8d                	beqz	a5,80002f94 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002f64:	0004c783          	lbu	a5,0(s1)
    80002f68:	89a6                	mv	s3,s1
  len = path - s;
    80002f6a:	4c81                	li	s9,0
    80002f6c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002f6e:	01278963          	beq	a5,s2,80002f80 <namex+0x10e>
    80002f72:	d3d9                	beqz	a5,80002ef8 <namex+0x86>
    path++;
    80002f74:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002f76:	0009c783          	lbu	a5,0(s3)
    80002f7a:	ff279ce3          	bne	a5,s2,80002f72 <namex+0x100>
    80002f7e:	bfad                	j	80002ef8 <namex+0x86>
    memmove(name, s, len);
    80002f80:	2601                	sext.w	a2,a2
    80002f82:	85a6                	mv	a1,s1
    80002f84:	8556                	mv	a0,s5
    80002f86:	a66fd0ef          	jal	800001ec <memmove>
    name[len] = 0;
    80002f8a:	9cd6                	add	s9,s9,s5
    80002f8c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002f90:	84ce                	mv	s1,s3
    80002f92:	bfbd                	j	80002f10 <namex+0x9e>
  if(nameiparent){
    80002f94:	f20b0be3          	beqz	s6,80002eca <namex+0x58>
    iput(ip);
    80002f98:	8552                	mv	a0,s4
    80002f9a:	b4bff0ef          	jal	80002ae4 <iput>
    return 0;
    80002f9e:	4a01                	li	s4,0
    80002fa0:	b72d                	j	80002eca <namex+0x58>

0000000080002fa2 <dirlink>:
{
    80002fa2:	7139                	addi	sp,sp,-64
    80002fa4:	fc06                	sd	ra,56(sp)
    80002fa6:	f822                	sd	s0,48(sp)
    80002fa8:	f04a                	sd	s2,32(sp)
    80002faa:	ec4e                	sd	s3,24(sp)
    80002fac:	e852                	sd	s4,16(sp)
    80002fae:	0080                	addi	s0,sp,64
    80002fb0:	892a                	mv	s2,a0
    80002fb2:	8a2e                	mv	s4,a1
    80002fb4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002fb6:	4601                	li	a2,0
    80002fb8:	e1fff0ef          	jal	80002dd6 <dirlookup>
    80002fbc:	e535                	bnez	a0,80003028 <dirlink+0x86>
    80002fbe:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fc0:	04c92483          	lw	s1,76(s2)
    80002fc4:	c48d                	beqz	s1,80002fee <dirlink+0x4c>
    80002fc6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002fc8:	4741                	li	a4,16
    80002fca:	86a6                	mv	a3,s1
    80002fcc:	fc040613          	addi	a2,s0,-64
    80002fd0:	4581                	li	a1,0
    80002fd2:	854a                	mv	a0,s2
    80002fd4:	be3ff0ef          	jal	80002bb6 <readi>
    80002fd8:	47c1                	li	a5,16
    80002fda:	04f51b63          	bne	a0,a5,80003030 <dirlink+0x8e>
    if(de.inum == 0)
    80002fde:	fc045783          	lhu	a5,-64(s0)
    80002fe2:	c791                	beqz	a5,80002fee <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fe4:	24c1                	addiw	s1,s1,16
    80002fe6:	04c92783          	lw	a5,76(s2)
    80002fea:	fcf4efe3          	bltu	s1,a5,80002fc8 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002fee:	4639                	li	a2,14
    80002ff0:	85d2                	mv	a1,s4
    80002ff2:	fc240513          	addi	a0,s0,-62
    80002ff6:	a9cfd0ef          	jal	80000292 <strncpy>
  de.inum = inum;
    80002ffa:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ffe:	4741                	li	a4,16
    80003000:	86a6                	mv	a3,s1
    80003002:	fc040613          	addi	a2,s0,-64
    80003006:	4581                	li	a1,0
    80003008:	854a                	mv	a0,s2
    8000300a:	ca9ff0ef          	jal	80002cb2 <writei>
    8000300e:	1541                	addi	a0,a0,-16
    80003010:	00a03533          	snez	a0,a0
    80003014:	40a00533          	neg	a0,a0
    80003018:	74a2                	ld	s1,40(sp)
}
    8000301a:	70e2                	ld	ra,56(sp)
    8000301c:	7442                	ld	s0,48(sp)
    8000301e:	7902                	ld	s2,32(sp)
    80003020:	69e2                	ld	s3,24(sp)
    80003022:	6a42                	ld	s4,16(sp)
    80003024:	6121                	addi	sp,sp,64
    80003026:	8082                	ret
    iput(ip);
    80003028:	abdff0ef          	jal	80002ae4 <iput>
    return -1;
    8000302c:	557d                	li	a0,-1
    8000302e:	b7f5                	j	8000301a <dirlink+0x78>
      panic("dirlink read");
    80003030:	00004517          	auipc	a0,0x4
    80003034:	5c850513          	addi	a0,a0,1480 # 800075f8 <etext+0x5f8>
    80003038:	6da020ef          	jal	80005712 <panic>

000000008000303c <namei>:

struct inode*
namei(char *path)
{
    8000303c:	1101                	addi	sp,sp,-32
    8000303e:	ec06                	sd	ra,24(sp)
    80003040:	e822                	sd	s0,16(sp)
    80003042:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003044:	fe040613          	addi	a2,s0,-32
    80003048:	4581                	li	a1,0
    8000304a:	e29ff0ef          	jal	80002e72 <namex>
}
    8000304e:	60e2                	ld	ra,24(sp)
    80003050:	6442                	ld	s0,16(sp)
    80003052:	6105                	addi	sp,sp,32
    80003054:	8082                	ret

0000000080003056 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003056:	1141                	addi	sp,sp,-16
    80003058:	e406                	sd	ra,8(sp)
    8000305a:	e022                	sd	s0,0(sp)
    8000305c:	0800                	addi	s0,sp,16
    8000305e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003060:	4585                	li	a1,1
    80003062:	e11ff0ef          	jal	80002e72 <namex>
}
    80003066:	60a2                	ld	ra,8(sp)
    80003068:	6402                	ld	s0,0(sp)
    8000306a:	0141                	addi	sp,sp,16
    8000306c:	8082                	ret

000000008000306e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000306e:	1101                	addi	sp,sp,-32
    80003070:	ec06                	sd	ra,24(sp)
    80003072:	e822                	sd	s0,16(sp)
    80003074:	e426                	sd	s1,8(sp)
    80003076:	e04a                	sd	s2,0(sp)
    80003078:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000307a:	00017917          	auipc	s2,0x17
    8000307e:	70e90913          	addi	s2,s2,1806 # 8001a788 <log>
    80003082:	01892583          	lw	a1,24(s2)
    80003086:	02892503          	lw	a0,40(s2)
    8000308a:	9a0ff0ef          	jal	8000222a <bread>
    8000308e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003090:	02c92603          	lw	a2,44(s2)
    80003094:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003096:	00c05f63          	blez	a2,800030b4 <write_head+0x46>
    8000309a:	00017717          	auipc	a4,0x17
    8000309e:	71e70713          	addi	a4,a4,1822 # 8001a7b8 <log+0x30>
    800030a2:	87aa                	mv	a5,a0
    800030a4:	060a                	slli	a2,a2,0x2
    800030a6:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800030a8:	4314                	lw	a3,0(a4)
    800030aa:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800030ac:	0711                	addi	a4,a4,4
    800030ae:	0791                	addi	a5,a5,4
    800030b0:	fec79ce3          	bne	a5,a2,800030a8 <write_head+0x3a>
  }
  bwrite(buf);
    800030b4:	8526                	mv	a0,s1
    800030b6:	a4aff0ef          	jal	80002300 <bwrite>
  brelse(buf);
    800030ba:	8526                	mv	a0,s1
    800030bc:	a76ff0ef          	jal	80002332 <brelse>
}
    800030c0:	60e2                	ld	ra,24(sp)
    800030c2:	6442                	ld	s0,16(sp)
    800030c4:	64a2                	ld	s1,8(sp)
    800030c6:	6902                	ld	s2,0(sp)
    800030c8:	6105                	addi	sp,sp,32
    800030ca:	8082                	ret

00000000800030cc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800030cc:	00017797          	auipc	a5,0x17
    800030d0:	6e87a783          	lw	a5,1768(a5) # 8001a7b4 <log+0x2c>
    800030d4:	08f05f63          	blez	a5,80003172 <install_trans+0xa6>
{
    800030d8:	7139                	addi	sp,sp,-64
    800030da:	fc06                	sd	ra,56(sp)
    800030dc:	f822                	sd	s0,48(sp)
    800030de:	f426                	sd	s1,40(sp)
    800030e0:	f04a                	sd	s2,32(sp)
    800030e2:	ec4e                	sd	s3,24(sp)
    800030e4:	e852                	sd	s4,16(sp)
    800030e6:	e456                	sd	s5,8(sp)
    800030e8:	e05a                	sd	s6,0(sp)
    800030ea:	0080                	addi	s0,sp,64
    800030ec:	8b2a                	mv	s6,a0
    800030ee:	00017a97          	auipc	s5,0x17
    800030f2:	6caa8a93          	addi	s5,s5,1738 # 8001a7b8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800030f6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800030f8:	00017997          	auipc	s3,0x17
    800030fc:	69098993          	addi	s3,s3,1680 # 8001a788 <log>
    80003100:	a829                	j	8000311a <install_trans+0x4e>
    brelse(lbuf);
    80003102:	854a                	mv	a0,s2
    80003104:	a2eff0ef          	jal	80002332 <brelse>
    brelse(dbuf);
    80003108:	8526                	mv	a0,s1
    8000310a:	a28ff0ef          	jal	80002332 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000310e:	2a05                	addiw	s4,s4,1
    80003110:	0a91                	addi	s5,s5,4
    80003112:	02c9a783          	lw	a5,44(s3)
    80003116:	04fa5463          	bge	s4,a5,8000315e <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000311a:	0189a583          	lw	a1,24(s3)
    8000311e:	014585bb          	addw	a1,a1,s4
    80003122:	2585                	addiw	a1,a1,1
    80003124:	0289a503          	lw	a0,40(s3)
    80003128:	902ff0ef          	jal	8000222a <bread>
    8000312c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000312e:	000aa583          	lw	a1,0(s5)
    80003132:	0289a503          	lw	a0,40(s3)
    80003136:	8f4ff0ef          	jal	8000222a <bread>
    8000313a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000313c:	40000613          	li	a2,1024
    80003140:	05890593          	addi	a1,s2,88
    80003144:	05850513          	addi	a0,a0,88
    80003148:	8a4fd0ef          	jal	800001ec <memmove>
    bwrite(dbuf);  // write dst to disk
    8000314c:	8526                	mv	a0,s1
    8000314e:	9b2ff0ef          	jal	80002300 <bwrite>
    if(recovering == 0)
    80003152:	fa0b18e3          	bnez	s6,80003102 <install_trans+0x36>
      bunpin(dbuf);
    80003156:	8526                	mv	a0,s1
    80003158:	a96ff0ef          	jal	800023ee <bunpin>
    8000315c:	b75d                	j	80003102 <install_trans+0x36>
}
    8000315e:	70e2                	ld	ra,56(sp)
    80003160:	7442                	ld	s0,48(sp)
    80003162:	74a2                	ld	s1,40(sp)
    80003164:	7902                	ld	s2,32(sp)
    80003166:	69e2                	ld	s3,24(sp)
    80003168:	6a42                	ld	s4,16(sp)
    8000316a:	6aa2                	ld	s5,8(sp)
    8000316c:	6b02                	ld	s6,0(sp)
    8000316e:	6121                	addi	sp,sp,64
    80003170:	8082                	ret
    80003172:	8082                	ret

0000000080003174 <initlog>:
{
    80003174:	7179                	addi	sp,sp,-48
    80003176:	f406                	sd	ra,40(sp)
    80003178:	f022                	sd	s0,32(sp)
    8000317a:	ec26                	sd	s1,24(sp)
    8000317c:	e84a                	sd	s2,16(sp)
    8000317e:	e44e                	sd	s3,8(sp)
    80003180:	1800                	addi	s0,sp,48
    80003182:	892a                	mv	s2,a0
    80003184:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003186:	00017497          	auipc	s1,0x17
    8000318a:	60248493          	addi	s1,s1,1538 # 8001a788 <log>
    8000318e:	00004597          	auipc	a1,0x4
    80003192:	47a58593          	addi	a1,a1,1146 # 80007608 <etext+0x608>
    80003196:	8526                	mv	a0,s1
    80003198:	029020ef          	jal	800059c0 <initlock>
  log.start = sb->logstart;
    8000319c:	0149a583          	lw	a1,20(s3)
    800031a0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800031a2:	0109a783          	lw	a5,16(s3)
    800031a6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800031a8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800031ac:	854a                	mv	a0,s2
    800031ae:	87cff0ef          	jal	8000222a <bread>
  log.lh.n = lh->n;
    800031b2:	4d30                	lw	a2,88(a0)
    800031b4:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800031b6:	00c05f63          	blez	a2,800031d4 <initlog+0x60>
    800031ba:	87aa                	mv	a5,a0
    800031bc:	00017717          	auipc	a4,0x17
    800031c0:	5fc70713          	addi	a4,a4,1532 # 8001a7b8 <log+0x30>
    800031c4:	060a                	slli	a2,a2,0x2
    800031c6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800031c8:	4ff4                	lw	a3,92(a5)
    800031ca:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800031cc:	0791                	addi	a5,a5,4
    800031ce:	0711                	addi	a4,a4,4
    800031d0:	fec79ce3          	bne	a5,a2,800031c8 <initlog+0x54>
  brelse(buf);
    800031d4:	95eff0ef          	jal	80002332 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800031d8:	4505                	li	a0,1
    800031da:	ef3ff0ef          	jal	800030cc <install_trans>
  log.lh.n = 0;
    800031de:	00017797          	auipc	a5,0x17
    800031e2:	5c07ab23          	sw	zero,1494(a5) # 8001a7b4 <log+0x2c>
  write_head(); // clear the log
    800031e6:	e89ff0ef          	jal	8000306e <write_head>
}
    800031ea:	70a2                	ld	ra,40(sp)
    800031ec:	7402                	ld	s0,32(sp)
    800031ee:	64e2                	ld	s1,24(sp)
    800031f0:	6942                	ld	s2,16(sp)
    800031f2:	69a2                	ld	s3,8(sp)
    800031f4:	6145                	addi	sp,sp,48
    800031f6:	8082                	ret

00000000800031f8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800031f8:	1101                	addi	sp,sp,-32
    800031fa:	ec06                	sd	ra,24(sp)
    800031fc:	e822                	sd	s0,16(sp)
    800031fe:	e426                	sd	s1,8(sp)
    80003200:	e04a                	sd	s2,0(sp)
    80003202:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003204:	00017517          	auipc	a0,0x17
    80003208:	58450513          	addi	a0,a0,1412 # 8001a788 <log>
    8000320c:	035020ef          	jal	80005a40 <acquire>
  while(1){
    if(log.committing){
    80003210:	00017497          	auipc	s1,0x17
    80003214:	57848493          	addi	s1,s1,1400 # 8001a788 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003218:	4979                	li	s2,30
    8000321a:	a029                	j	80003224 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000321c:	85a6                	mv	a1,s1
    8000321e:	8526                	mv	a0,s1
    80003220:	972fe0ef          	jal	80001392 <sleep>
    if(log.committing){
    80003224:	50dc                	lw	a5,36(s1)
    80003226:	fbfd                	bnez	a5,8000321c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003228:	5098                	lw	a4,32(s1)
    8000322a:	2705                	addiw	a4,a4,1
    8000322c:	0027179b          	slliw	a5,a4,0x2
    80003230:	9fb9                	addw	a5,a5,a4
    80003232:	0017979b          	slliw	a5,a5,0x1
    80003236:	54d4                	lw	a3,44(s1)
    80003238:	9fb5                	addw	a5,a5,a3
    8000323a:	00f95763          	bge	s2,a5,80003248 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000323e:	85a6                	mv	a1,s1
    80003240:	8526                	mv	a0,s1
    80003242:	950fe0ef          	jal	80001392 <sleep>
    80003246:	bff9                	j	80003224 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003248:	00017517          	auipc	a0,0x17
    8000324c:	54050513          	addi	a0,a0,1344 # 8001a788 <log>
    80003250:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003252:	087020ef          	jal	80005ad8 <release>
      break;
    }
  }
}
    80003256:	60e2                	ld	ra,24(sp)
    80003258:	6442                	ld	s0,16(sp)
    8000325a:	64a2                	ld	s1,8(sp)
    8000325c:	6902                	ld	s2,0(sp)
    8000325e:	6105                	addi	sp,sp,32
    80003260:	8082                	ret

0000000080003262 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003262:	7139                	addi	sp,sp,-64
    80003264:	fc06                	sd	ra,56(sp)
    80003266:	f822                	sd	s0,48(sp)
    80003268:	f426                	sd	s1,40(sp)
    8000326a:	f04a                	sd	s2,32(sp)
    8000326c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000326e:	00017497          	auipc	s1,0x17
    80003272:	51a48493          	addi	s1,s1,1306 # 8001a788 <log>
    80003276:	8526                	mv	a0,s1
    80003278:	7c8020ef          	jal	80005a40 <acquire>
  log.outstanding -= 1;
    8000327c:	509c                	lw	a5,32(s1)
    8000327e:	37fd                	addiw	a5,a5,-1
    80003280:	0007891b          	sext.w	s2,a5
    80003284:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003286:	50dc                	lw	a5,36(s1)
    80003288:	ef9d                	bnez	a5,800032c6 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    8000328a:	04091763          	bnez	s2,800032d8 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000328e:	00017497          	auipc	s1,0x17
    80003292:	4fa48493          	addi	s1,s1,1274 # 8001a788 <log>
    80003296:	4785                	li	a5,1
    80003298:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000329a:	8526                	mv	a0,s1
    8000329c:	03d020ef          	jal	80005ad8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800032a0:	54dc                	lw	a5,44(s1)
    800032a2:	04f04b63          	bgtz	a5,800032f8 <end_op+0x96>
    acquire(&log.lock);
    800032a6:	00017497          	auipc	s1,0x17
    800032aa:	4e248493          	addi	s1,s1,1250 # 8001a788 <log>
    800032ae:	8526                	mv	a0,s1
    800032b0:	790020ef          	jal	80005a40 <acquire>
    log.committing = 0;
    800032b4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800032b8:	8526                	mv	a0,s1
    800032ba:	924fe0ef          	jal	800013de <wakeup>
    release(&log.lock);
    800032be:	8526                	mv	a0,s1
    800032c0:	019020ef          	jal	80005ad8 <release>
}
    800032c4:	a025                	j	800032ec <end_op+0x8a>
    800032c6:	ec4e                	sd	s3,24(sp)
    800032c8:	e852                	sd	s4,16(sp)
    800032ca:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800032cc:	00004517          	auipc	a0,0x4
    800032d0:	34450513          	addi	a0,a0,836 # 80007610 <etext+0x610>
    800032d4:	43e020ef          	jal	80005712 <panic>
    wakeup(&log);
    800032d8:	00017497          	auipc	s1,0x17
    800032dc:	4b048493          	addi	s1,s1,1200 # 8001a788 <log>
    800032e0:	8526                	mv	a0,s1
    800032e2:	8fcfe0ef          	jal	800013de <wakeup>
  release(&log.lock);
    800032e6:	8526                	mv	a0,s1
    800032e8:	7f0020ef          	jal	80005ad8 <release>
}
    800032ec:	70e2                	ld	ra,56(sp)
    800032ee:	7442                	ld	s0,48(sp)
    800032f0:	74a2                	ld	s1,40(sp)
    800032f2:	7902                	ld	s2,32(sp)
    800032f4:	6121                	addi	sp,sp,64
    800032f6:	8082                	ret
    800032f8:	ec4e                	sd	s3,24(sp)
    800032fa:	e852                	sd	s4,16(sp)
    800032fc:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800032fe:	00017a97          	auipc	s5,0x17
    80003302:	4baa8a93          	addi	s5,s5,1210 # 8001a7b8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003306:	00017a17          	auipc	s4,0x17
    8000330a:	482a0a13          	addi	s4,s4,1154 # 8001a788 <log>
    8000330e:	018a2583          	lw	a1,24(s4)
    80003312:	012585bb          	addw	a1,a1,s2
    80003316:	2585                	addiw	a1,a1,1
    80003318:	028a2503          	lw	a0,40(s4)
    8000331c:	f0ffe0ef          	jal	8000222a <bread>
    80003320:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003322:	000aa583          	lw	a1,0(s5)
    80003326:	028a2503          	lw	a0,40(s4)
    8000332a:	f01fe0ef          	jal	8000222a <bread>
    8000332e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003330:	40000613          	li	a2,1024
    80003334:	05850593          	addi	a1,a0,88
    80003338:	05848513          	addi	a0,s1,88
    8000333c:	eb1fc0ef          	jal	800001ec <memmove>
    bwrite(to);  // write the log
    80003340:	8526                	mv	a0,s1
    80003342:	fbffe0ef          	jal	80002300 <bwrite>
    brelse(from);
    80003346:	854e                	mv	a0,s3
    80003348:	febfe0ef          	jal	80002332 <brelse>
    brelse(to);
    8000334c:	8526                	mv	a0,s1
    8000334e:	fe5fe0ef          	jal	80002332 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003352:	2905                	addiw	s2,s2,1
    80003354:	0a91                	addi	s5,s5,4
    80003356:	02ca2783          	lw	a5,44(s4)
    8000335a:	faf94ae3          	blt	s2,a5,8000330e <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000335e:	d11ff0ef          	jal	8000306e <write_head>
    install_trans(0); // Now install writes to home locations
    80003362:	4501                	li	a0,0
    80003364:	d69ff0ef          	jal	800030cc <install_trans>
    log.lh.n = 0;
    80003368:	00017797          	auipc	a5,0x17
    8000336c:	4407a623          	sw	zero,1100(a5) # 8001a7b4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003370:	cffff0ef          	jal	8000306e <write_head>
    80003374:	69e2                	ld	s3,24(sp)
    80003376:	6a42                	ld	s4,16(sp)
    80003378:	6aa2                	ld	s5,8(sp)
    8000337a:	b735                	j	800032a6 <end_op+0x44>

000000008000337c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000337c:	1101                	addi	sp,sp,-32
    8000337e:	ec06                	sd	ra,24(sp)
    80003380:	e822                	sd	s0,16(sp)
    80003382:	e426                	sd	s1,8(sp)
    80003384:	e04a                	sd	s2,0(sp)
    80003386:	1000                	addi	s0,sp,32
    80003388:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000338a:	00017917          	auipc	s2,0x17
    8000338e:	3fe90913          	addi	s2,s2,1022 # 8001a788 <log>
    80003392:	854a                	mv	a0,s2
    80003394:	6ac020ef          	jal	80005a40 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003398:	02c92603          	lw	a2,44(s2)
    8000339c:	47f5                	li	a5,29
    8000339e:	06c7c363          	blt	a5,a2,80003404 <log_write+0x88>
    800033a2:	00017797          	auipc	a5,0x17
    800033a6:	4027a783          	lw	a5,1026(a5) # 8001a7a4 <log+0x1c>
    800033aa:	37fd                	addiw	a5,a5,-1
    800033ac:	04f65c63          	bge	a2,a5,80003404 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800033b0:	00017797          	auipc	a5,0x17
    800033b4:	3f87a783          	lw	a5,1016(a5) # 8001a7a8 <log+0x20>
    800033b8:	04f05c63          	blez	a5,80003410 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800033bc:	4781                	li	a5,0
    800033be:	04c05f63          	blez	a2,8000341c <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800033c2:	44cc                	lw	a1,12(s1)
    800033c4:	00017717          	auipc	a4,0x17
    800033c8:	3f470713          	addi	a4,a4,1012 # 8001a7b8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800033cc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800033ce:	4314                	lw	a3,0(a4)
    800033d0:	04b68663          	beq	a3,a1,8000341c <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800033d4:	2785                	addiw	a5,a5,1
    800033d6:	0711                	addi	a4,a4,4
    800033d8:	fef61be3          	bne	a2,a5,800033ce <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800033dc:	0621                	addi	a2,a2,8
    800033de:	060a                	slli	a2,a2,0x2
    800033e0:	00017797          	auipc	a5,0x17
    800033e4:	3a878793          	addi	a5,a5,936 # 8001a788 <log>
    800033e8:	97b2                	add	a5,a5,a2
    800033ea:	44d8                	lw	a4,12(s1)
    800033ec:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800033ee:	8526                	mv	a0,s1
    800033f0:	fcbfe0ef          	jal	800023ba <bpin>
    log.lh.n++;
    800033f4:	00017717          	auipc	a4,0x17
    800033f8:	39470713          	addi	a4,a4,916 # 8001a788 <log>
    800033fc:	575c                	lw	a5,44(a4)
    800033fe:	2785                	addiw	a5,a5,1
    80003400:	d75c                	sw	a5,44(a4)
    80003402:	a80d                	j	80003434 <log_write+0xb8>
    panic("too big a transaction");
    80003404:	00004517          	auipc	a0,0x4
    80003408:	21c50513          	addi	a0,a0,540 # 80007620 <etext+0x620>
    8000340c:	306020ef          	jal	80005712 <panic>
    panic("log_write outside of trans");
    80003410:	00004517          	auipc	a0,0x4
    80003414:	22850513          	addi	a0,a0,552 # 80007638 <etext+0x638>
    80003418:	2fa020ef          	jal	80005712 <panic>
  log.lh.block[i] = b->blockno;
    8000341c:	00878693          	addi	a3,a5,8
    80003420:	068a                	slli	a3,a3,0x2
    80003422:	00017717          	auipc	a4,0x17
    80003426:	36670713          	addi	a4,a4,870 # 8001a788 <log>
    8000342a:	9736                	add	a4,a4,a3
    8000342c:	44d4                	lw	a3,12(s1)
    8000342e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003430:	faf60fe3          	beq	a2,a5,800033ee <log_write+0x72>
  }
  release(&log.lock);
    80003434:	00017517          	auipc	a0,0x17
    80003438:	35450513          	addi	a0,a0,852 # 8001a788 <log>
    8000343c:	69c020ef          	jal	80005ad8 <release>
}
    80003440:	60e2                	ld	ra,24(sp)
    80003442:	6442                	ld	s0,16(sp)
    80003444:	64a2                	ld	s1,8(sp)
    80003446:	6902                	ld	s2,0(sp)
    80003448:	6105                	addi	sp,sp,32
    8000344a:	8082                	ret

000000008000344c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000344c:	1101                	addi	sp,sp,-32
    8000344e:	ec06                	sd	ra,24(sp)
    80003450:	e822                	sd	s0,16(sp)
    80003452:	e426                	sd	s1,8(sp)
    80003454:	e04a                	sd	s2,0(sp)
    80003456:	1000                	addi	s0,sp,32
    80003458:	84aa                	mv	s1,a0
    8000345a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000345c:	00004597          	auipc	a1,0x4
    80003460:	1fc58593          	addi	a1,a1,508 # 80007658 <etext+0x658>
    80003464:	0521                	addi	a0,a0,8
    80003466:	55a020ef          	jal	800059c0 <initlock>
  lk->name = name;
    8000346a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000346e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003472:	0204a423          	sw	zero,40(s1)
}
    80003476:	60e2                	ld	ra,24(sp)
    80003478:	6442                	ld	s0,16(sp)
    8000347a:	64a2                	ld	s1,8(sp)
    8000347c:	6902                	ld	s2,0(sp)
    8000347e:	6105                	addi	sp,sp,32
    80003480:	8082                	ret

0000000080003482 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003482:	1101                	addi	sp,sp,-32
    80003484:	ec06                	sd	ra,24(sp)
    80003486:	e822                	sd	s0,16(sp)
    80003488:	e426                	sd	s1,8(sp)
    8000348a:	e04a                	sd	s2,0(sp)
    8000348c:	1000                	addi	s0,sp,32
    8000348e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003490:	00850913          	addi	s2,a0,8
    80003494:	854a                	mv	a0,s2
    80003496:	5aa020ef          	jal	80005a40 <acquire>
  while (lk->locked) {
    8000349a:	409c                	lw	a5,0(s1)
    8000349c:	c799                	beqz	a5,800034aa <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000349e:	85ca                	mv	a1,s2
    800034a0:	8526                	mv	a0,s1
    800034a2:	ef1fd0ef          	jal	80001392 <sleep>
  while (lk->locked) {
    800034a6:	409c                	lw	a5,0(s1)
    800034a8:	fbfd                	bnez	a5,8000349e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800034aa:	4785                	li	a5,1
    800034ac:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800034ae:	90ffd0ef          	jal	80000dbc <myproc>
    800034b2:	591c                	lw	a5,48(a0)
    800034b4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800034b6:	854a                	mv	a0,s2
    800034b8:	620020ef          	jal	80005ad8 <release>
}
    800034bc:	60e2                	ld	ra,24(sp)
    800034be:	6442                	ld	s0,16(sp)
    800034c0:	64a2                	ld	s1,8(sp)
    800034c2:	6902                	ld	s2,0(sp)
    800034c4:	6105                	addi	sp,sp,32
    800034c6:	8082                	ret

00000000800034c8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800034c8:	1101                	addi	sp,sp,-32
    800034ca:	ec06                	sd	ra,24(sp)
    800034cc:	e822                	sd	s0,16(sp)
    800034ce:	e426                	sd	s1,8(sp)
    800034d0:	e04a                	sd	s2,0(sp)
    800034d2:	1000                	addi	s0,sp,32
    800034d4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800034d6:	00850913          	addi	s2,a0,8
    800034da:	854a                	mv	a0,s2
    800034dc:	564020ef          	jal	80005a40 <acquire>
  lk->locked = 0;
    800034e0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800034e4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800034e8:	8526                	mv	a0,s1
    800034ea:	ef5fd0ef          	jal	800013de <wakeup>
  release(&lk->lk);
    800034ee:	854a                	mv	a0,s2
    800034f0:	5e8020ef          	jal	80005ad8 <release>
}
    800034f4:	60e2                	ld	ra,24(sp)
    800034f6:	6442                	ld	s0,16(sp)
    800034f8:	64a2                	ld	s1,8(sp)
    800034fa:	6902                	ld	s2,0(sp)
    800034fc:	6105                	addi	sp,sp,32
    800034fe:	8082                	ret

0000000080003500 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003500:	7179                	addi	sp,sp,-48
    80003502:	f406                	sd	ra,40(sp)
    80003504:	f022                	sd	s0,32(sp)
    80003506:	ec26                	sd	s1,24(sp)
    80003508:	e84a                	sd	s2,16(sp)
    8000350a:	1800                	addi	s0,sp,48
    8000350c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000350e:	00850913          	addi	s2,a0,8
    80003512:	854a                	mv	a0,s2
    80003514:	52c020ef          	jal	80005a40 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003518:	409c                	lw	a5,0(s1)
    8000351a:	ef81                	bnez	a5,80003532 <holdingsleep+0x32>
    8000351c:	4481                	li	s1,0
  release(&lk->lk);
    8000351e:	854a                	mv	a0,s2
    80003520:	5b8020ef          	jal	80005ad8 <release>
  return r;
}
    80003524:	8526                	mv	a0,s1
    80003526:	70a2                	ld	ra,40(sp)
    80003528:	7402                	ld	s0,32(sp)
    8000352a:	64e2                	ld	s1,24(sp)
    8000352c:	6942                	ld	s2,16(sp)
    8000352e:	6145                	addi	sp,sp,48
    80003530:	8082                	ret
    80003532:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003534:	0284a983          	lw	s3,40(s1)
    80003538:	885fd0ef          	jal	80000dbc <myproc>
    8000353c:	5904                	lw	s1,48(a0)
    8000353e:	413484b3          	sub	s1,s1,s3
    80003542:	0014b493          	seqz	s1,s1
    80003546:	69a2                	ld	s3,8(sp)
    80003548:	bfd9                	j	8000351e <holdingsleep+0x1e>

000000008000354a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000354a:	1141                	addi	sp,sp,-16
    8000354c:	e406                	sd	ra,8(sp)
    8000354e:	e022                	sd	s0,0(sp)
    80003550:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003552:	00004597          	auipc	a1,0x4
    80003556:	11658593          	addi	a1,a1,278 # 80007668 <etext+0x668>
    8000355a:	00017517          	auipc	a0,0x17
    8000355e:	37650513          	addi	a0,a0,886 # 8001a8d0 <ftable>
    80003562:	45e020ef          	jal	800059c0 <initlock>
}
    80003566:	60a2                	ld	ra,8(sp)
    80003568:	6402                	ld	s0,0(sp)
    8000356a:	0141                	addi	sp,sp,16
    8000356c:	8082                	ret

000000008000356e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000356e:	1101                	addi	sp,sp,-32
    80003570:	ec06                	sd	ra,24(sp)
    80003572:	e822                	sd	s0,16(sp)
    80003574:	e426                	sd	s1,8(sp)
    80003576:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003578:	00017517          	auipc	a0,0x17
    8000357c:	35850513          	addi	a0,a0,856 # 8001a8d0 <ftable>
    80003580:	4c0020ef          	jal	80005a40 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003584:	00017497          	auipc	s1,0x17
    80003588:	36448493          	addi	s1,s1,868 # 8001a8e8 <ftable+0x18>
    8000358c:	00018717          	auipc	a4,0x18
    80003590:	2fc70713          	addi	a4,a4,764 # 8001b888 <disk>
    if(f->ref == 0){
    80003594:	40dc                	lw	a5,4(s1)
    80003596:	cf89                	beqz	a5,800035b0 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003598:	02848493          	addi	s1,s1,40
    8000359c:	fee49ce3          	bne	s1,a4,80003594 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800035a0:	00017517          	auipc	a0,0x17
    800035a4:	33050513          	addi	a0,a0,816 # 8001a8d0 <ftable>
    800035a8:	530020ef          	jal	80005ad8 <release>
  return 0;
    800035ac:	4481                	li	s1,0
    800035ae:	a809                	j	800035c0 <filealloc+0x52>
      f->ref = 1;
    800035b0:	4785                	li	a5,1
    800035b2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800035b4:	00017517          	auipc	a0,0x17
    800035b8:	31c50513          	addi	a0,a0,796 # 8001a8d0 <ftable>
    800035bc:	51c020ef          	jal	80005ad8 <release>
}
    800035c0:	8526                	mv	a0,s1
    800035c2:	60e2                	ld	ra,24(sp)
    800035c4:	6442                	ld	s0,16(sp)
    800035c6:	64a2                	ld	s1,8(sp)
    800035c8:	6105                	addi	sp,sp,32
    800035ca:	8082                	ret

00000000800035cc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800035cc:	1101                	addi	sp,sp,-32
    800035ce:	ec06                	sd	ra,24(sp)
    800035d0:	e822                	sd	s0,16(sp)
    800035d2:	e426                	sd	s1,8(sp)
    800035d4:	1000                	addi	s0,sp,32
    800035d6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800035d8:	00017517          	auipc	a0,0x17
    800035dc:	2f850513          	addi	a0,a0,760 # 8001a8d0 <ftable>
    800035e0:	460020ef          	jal	80005a40 <acquire>
  if(f->ref < 1)
    800035e4:	40dc                	lw	a5,4(s1)
    800035e6:	02f05063          	blez	a5,80003606 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800035ea:	2785                	addiw	a5,a5,1
    800035ec:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800035ee:	00017517          	auipc	a0,0x17
    800035f2:	2e250513          	addi	a0,a0,738 # 8001a8d0 <ftable>
    800035f6:	4e2020ef          	jal	80005ad8 <release>
  return f;
}
    800035fa:	8526                	mv	a0,s1
    800035fc:	60e2                	ld	ra,24(sp)
    800035fe:	6442                	ld	s0,16(sp)
    80003600:	64a2                	ld	s1,8(sp)
    80003602:	6105                	addi	sp,sp,32
    80003604:	8082                	ret
    panic("filedup");
    80003606:	00004517          	auipc	a0,0x4
    8000360a:	06a50513          	addi	a0,a0,106 # 80007670 <etext+0x670>
    8000360e:	104020ef          	jal	80005712 <panic>

0000000080003612 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003612:	7139                	addi	sp,sp,-64
    80003614:	fc06                	sd	ra,56(sp)
    80003616:	f822                	sd	s0,48(sp)
    80003618:	f426                	sd	s1,40(sp)
    8000361a:	0080                	addi	s0,sp,64
    8000361c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000361e:	00017517          	auipc	a0,0x17
    80003622:	2b250513          	addi	a0,a0,690 # 8001a8d0 <ftable>
    80003626:	41a020ef          	jal	80005a40 <acquire>
  if(f->ref < 1)
    8000362a:	40dc                	lw	a5,4(s1)
    8000362c:	04f05a63          	blez	a5,80003680 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003630:	37fd                	addiw	a5,a5,-1
    80003632:	0007871b          	sext.w	a4,a5
    80003636:	c0dc                	sw	a5,4(s1)
    80003638:	04e04e63          	bgtz	a4,80003694 <fileclose+0x82>
    8000363c:	f04a                	sd	s2,32(sp)
    8000363e:	ec4e                	sd	s3,24(sp)
    80003640:	e852                	sd	s4,16(sp)
    80003642:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003644:	0004a903          	lw	s2,0(s1)
    80003648:	0094ca83          	lbu	s5,9(s1)
    8000364c:	0104ba03          	ld	s4,16(s1)
    80003650:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003654:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003658:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000365c:	00017517          	auipc	a0,0x17
    80003660:	27450513          	addi	a0,a0,628 # 8001a8d0 <ftable>
    80003664:	474020ef          	jal	80005ad8 <release>

  if(ff.type == FD_PIPE){
    80003668:	4785                	li	a5,1
    8000366a:	04f90063          	beq	s2,a5,800036aa <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000366e:	3979                	addiw	s2,s2,-2
    80003670:	4785                	li	a5,1
    80003672:	0527f563          	bgeu	a5,s2,800036bc <fileclose+0xaa>
    80003676:	7902                	ld	s2,32(sp)
    80003678:	69e2                	ld	s3,24(sp)
    8000367a:	6a42                	ld	s4,16(sp)
    8000367c:	6aa2                	ld	s5,8(sp)
    8000367e:	a00d                	j	800036a0 <fileclose+0x8e>
    80003680:	f04a                	sd	s2,32(sp)
    80003682:	ec4e                	sd	s3,24(sp)
    80003684:	e852                	sd	s4,16(sp)
    80003686:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003688:	00004517          	auipc	a0,0x4
    8000368c:	ff050513          	addi	a0,a0,-16 # 80007678 <etext+0x678>
    80003690:	082020ef          	jal	80005712 <panic>
    release(&ftable.lock);
    80003694:	00017517          	auipc	a0,0x17
    80003698:	23c50513          	addi	a0,a0,572 # 8001a8d0 <ftable>
    8000369c:	43c020ef          	jal	80005ad8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800036a0:	70e2                	ld	ra,56(sp)
    800036a2:	7442                	ld	s0,48(sp)
    800036a4:	74a2                	ld	s1,40(sp)
    800036a6:	6121                	addi	sp,sp,64
    800036a8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800036aa:	85d6                	mv	a1,s5
    800036ac:	8552                	mv	a0,s4
    800036ae:	336000ef          	jal	800039e4 <pipeclose>
    800036b2:	7902                	ld	s2,32(sp)
    800036b4:	69e2                	ld	s3,24(sp)
    800036b6:	6a42                	ld	s4,16(sp)
    800036b8:	6aa2                	ld	s5,8(sp)
    800036ba:	b7dd                	j	800036a0 <fileclose+0x8e>
    begin_op();
    800036bc:	b3dff0ef          	jal	800031f8 <begin_op>
    iput(ff.ip);
    800036c0:	854e                	mv	a0,s3
    800036c2:	c22ff0ef          	jal	80002ae4 <iput>
    end_op();
    800036c6:	b9dff0ef          	jal	80003262 <end_op>
    800036ca:	7902                	ld	s2,32(sp)
    800036cc:	69e2                	ld	s3,24(sp)
    800036ce:	6a42                	ld	s4,16(sp)
    800036d0:	6aa2                	ld	s5,8(sp)
    800036d2:	b7f9                	j	800036a0 <fileclose+0x8e>

00000000800036d4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800036d4:	715d                	addi	sp,sp,-80
    800036d6:	e486                	sd	ra,72(sp)
    800036d8:	e0a2                	sd	s0,64(sp)
    800036da:	fc26                	sd	s1,56(sp)
    800036dc:	f44e                	sd	s3,40(sp)
    800036de:	0880                	addi	s0,sp,80
    800036e0:	84aa                	mv	s1,a0
    800036e2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800036e4:	ed8fd0ef          	jal	80000dbc <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800036e8:	409c                	lw	a5,0(s1)
    800036ea:	37f9                	addiw	a5,a5,-2
    800036ec:	4705                	li	a4,1
    800036ee:	04f76063          	bltu	a4,a5,8000372e <filestat+0x5a>
    800036f2:	f84a                	sd	s2,48(sp)
    800036f4:	892a                	mv	s2,a0
    ilock(f->ip);
    800036f6:	6c88                	ld	a0,24(s1)
    800036f8:	a6aff0ef          	jal	80002962 <ilock>
    stati(f->ip, &st);
    800036fc:	fb840593          	addi	a1,s0,-72
    80003700:	6c88                	ld	a0,24(s1)
    80003702:	c8aff0ef          	jal	80002b8c <stati>
    iunlock(f->ip);
    80003706:	6c88                	ld	a0,24(s1)
    80003708:	b08ff0ef          	jal	80002a10 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000370c:	46e1                	li	a3,24
    8000370e:	fb840613          	addi	a2,s0,-72
    80003712:	85ce                	mv	a1,s3
    80003714:	05093503          	ld	a0,80(s2)
    80003718:	b02fd0ef          	jal	80000a1a <copyout>
    8000371c:	41f5551b          	sraiw	a0,a0,0x1f
    80003720:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003722:	60a6                	ld	ra,72(sp)
    80003724:	6406                	ld	s0,64(sp)
    80003726:	74e2                	ld	s1,56(sp)
    80003728:	79a2                	ld	s3,40(sp)
    8000372a:	6161                	addi	sp,sp,80
    8000372c:	8082                	ret
  return -1;
    8000372e:	557d                	li	a0,-1
    80003730:	bfcd                	j	80003722 <filestat+0x4e>

0000000080003732 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003732:	7179                	addi	sp,sp,-48
    80003734:	f406                	sd	ra,40(sp)
    80003736:	f022                	sd	s0,32(sp)
    80003738:	e84a                	sd	s2,16(sp)
    8000373a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000373c:	00854783          	lbu	a5,8(a0)
    80003740:	cfd1                	beqz	a5,800037dc <fileread+0xaa>
    80003742:	ec26                	sd	s1,24(sp)
    80003744:	e44e                	sd	s3,8(sp)
    80003746:	84aa                	mv	s1,a0
    80003748:	89ae                	mv	s3,a1
    8000374a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000374c:	411c                	lw	a5,0(a0)
    8000374e:	4705                	li	a4,1
    80003750:	04e78363          	beq	a5,a4,80003796 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003754:	470d                	li	a4,3
    80003756:	04e78763          	beq	a5,a4,800037a4 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000375a:	4709                	li	a4,2
    8000375c:	06e79a63          	bne	a5,a4,800037d0 <fileread+0x9e>
    ilock(f->ip);
    80003760:	6d08                	ld	a0,24(a0)
    80003762:	a00ff0ef          	jal	80002962 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003766:	874a                	mv	a4,s2
    80003768:	5094                	lw	a3,32(s1)
    8000376a:	864e                	mv	a2,s3
    8000376c:	4585                	li	a1,1
    8000376e:	6c88                	ld	a0,24(s1)
    80003770:	c46ff0ef          	jal	80002bb6 <readi>
    80003774:	892a                	mv	s2,a0
    80003776:	00a05563          	blez	a0,80003780 <fileread+0x4e>
      f->off += r;
    8000377a:	509c                	lw	a5,32(s1)
    8000377c:	9fa9                	addw	a5,a5,a0
    8000377e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003780:	6c88                	ld	a0,24(s1)
    80003782:	a8eff0ef          	jal	80002a10 <iunlock>
    80003786:	64e2                	ld	s1,24(sp)
    80003788:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000378a:	854a                	mv	a0,s2
    8000378c:	70a2                	ld	ra,40(sp)
    8000378e:	7402                	ld	s0,32(sp)
    80003790:	6942                	ld	s2,16(sp)
    80003792:	6145                	addi	sp,sp,48
    80003794:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003796:	6908                	ld	a0,16(a0)
    80003798:	388000ef          	jal	80003b20 <piperead>
    8000379c:	892a                	mv	s2,a0
    8000379e:	64e2                	ld	s1,24(sp)
    800037a0:	69a2                	ld	s3,8(sp)
    800037a2:	b7e5                	j	8000378a <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800037a4:	02451783          	lh	a5,36(a0)
    800037a8:	03079693          	slli	a3,a5,0x30
    800037ac:	92c1                	srli	a3,a3,0x30
    800037ae:	4725                	li	a4,9
    800037b0:	02d76863          	bltu	a4,a3,800037e0 <fileread+0xae>
    800037b4:	0792                	slli	a5,a5,0x4
    800037b6:	00017717          	auipc	a4,0x17
    800037ba:	07a70713          	addi	a4,a4,122 # 8001a830 <devsw>
    800037be:	97ba                	add	a5,a5,a4
    800037c0:	639c                	ld	a5,0(a5)
    800037c2:	c39d                	beqz	a5,800037e8 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800037c4:	4505                	li	a0,1
    800037c6:	9782                	jalr	a5
    800037c8:	892a                	mv	s2,a0
    800037ca:	64e2                	ld	s1,24(sp)
    800037cc:	69a2                	ld	s3,8(sp)
    800037ce:	bf75                	j	8000378a <fileread+0x58>
    panic("fileread");
    800037d0:	00004517          	auipc	a0,0x4
    800037d4:	eb850513          	addi	a0,a0,-328 # 80007688 <etext+0x688>
    800037d8:	73b010ef          	jal	80005712 <panic>
    return -1;
    800037dc:	597d                	li	s2,-1
    800037de:	b775                	j	8000378a <fileread+0x58>
      return -1;
    800037e0:	597d                	li	s2,-1
    800037e2:	64e2                	ld	s1,24(sp)
    800037e4:	69a2                	ld	s3,8(sp)
    800037e6:	b755                	j	8000378a <fileread+0x58>
    800037e8:	597d                	li	s2,-1
    800037ea:	64e2                	ld	s1,24(sp)
    800037ec:	69a2                	ld	s3,8(sp)
    800037ee:	bf71                	j	8000378a <fileread+0x58>

00000000800037f0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800037f0:	00954783          	lbu	a5,9(a0)
    800037f4:	10078b63          	beqz	a5,8000390a <filewrite+0x11a>
{
    800037f8:	715d                	addi	sp,sp,-80
    800037fa:	e486                	sd	ra,72(sp)
    800037fc:	e0a2                	sd	s0,64(sp)
    800037fe:	f84a                	sd	s2,48(sp)
    80003800:	f052                	sd	s4,32(sp)
    80003802:	e85a                	sd	s6,16(sp)
    80003804:	0880                	addi	s0,sp,80
    80003806:	892a                	mv	s2,a0
    80003808:	8b2e                	mv	s6,a1
    8000380a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000380c:	411c                	lw	a5,0(a0)
    8000380e:	4705                	li	a4,1
    80003810:	02e78763          	beq	a5,a4,8000383e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003814:	470d                	li	a4,3
    80003816:	02e78863          	beq	a5,a4,80003846 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000381a:	4709                	li	a4,2
    8000381c:	0ce79c63          	bne	a5,a4,800038f4 <filewrite+0x104>
    80003820:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003822:	0ac05863          	blez	a2,800038d2 <filewrite+0xe2>
    80003826:	fc26                	sd	s1,56(sp)
    80003828:	ec56                	sd	s5,24(sp)
    8000382a:	e45e                	sd	s7,8(sp)
    8000382c:	e062                	sd	s8,0(sp)
    int i = 0;
    8000382e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003830:	6b85                	lui	s7,0x1
    80003832:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003836:	6c05                	lui	s8,0x1
    80003838:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000383c:	a8b5                	j	800038b8 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    8000383e:	6908                	ld	a0,16(a0)
    80003840:	1fc000ef          	jal	80003a3c <pipewrite>
    80003844:	a04d                	j	800038e6 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003846:	02451783          	lh	a5,36(a0)
    8000384a:	03079693          	slli	a3,a5,0x30
    8000384e:	92c1                	srli	a3,a3,0x30
    80003850:	4725                	li	a4,9
    80003852:	0ad76e63          	bltu	a4,a3,8000390e <filewrite+0x11e>
    80003856:	0792                	slli	a5,a5,0x4
    80003858:	00017717          	auipc	a4,0x17
    8000385c:	fd870713          	addi	a4,a4,-40 # 8001a830 <devsw>
    80003860:	97ba                	add	a5,a5,a4
    80003862:	679c                	ld	a5,8(a5)
    80003864:	c7dd                	beqz	a5,80003912 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003866:	4505                	li	a0,1
    80003868:	9782                	jalr	a5
    8000386a:	a8b5                	j	800038e6 <filewrite+0xf6>
      if(n1 > max)
    8000386c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003870:	989ff0ef          	jal	800031f8 <begin_op>
      ilock(f->ip);
    80003874:	01893503          	ld	a0,24(s2)
    80003878:	8eaff0ef          	jal	80002962 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000387c:	8756                	mv	a4,s5
    8000387e:	02092683          	lw	a3,32(s2)
    80003882:	01698633          	add	a2,s3,s6
    80003886:	4585                	li	a1,1
    80003888:	01893503          	ld	a0,24(s2)
    8000388c:	c26ff0ef          	jal	80002cb2 <writei>
    80003890:	84aa                	mv	s1,a0
    80003892:	00a05763          	blez	a0,800038a0 <filewrite+0xb0>
        f->off += r;
    80003896:	02092783          	lw	a5,32(s2)
    8000389a:	9fa9                	addw	a5,a5,a0
    8000389c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800038a0:	01893503          	ld	a0,24(s2)
    800038a4:	96cff0ef          	jal	80002a10 <iunlock>
      end_op();
    800038a8:	9bbff0ef          	jal	80003262 <end_op>

      if(r != n1){
    800038ac:	029a9563          	bne	s5,s1,800038d6 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800038b0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800038b4:	0149da63          	bge	s3,s4,800038c8 <filewrite+0xd8>
      int n1 = n - i;
    800038b8:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800038bc:	0004879b          	sext.w	a5,s1
    800038c0:	fafbd6e3          	bge	s7,a5,8000386c <filewrite+0x7c>
    800038c4:	84e2                	mv	s1,s8
    800038c6:	b75d                	j	8000386c <filewrite+0x7c>
    800038c8:	74e2                	ld	s1,56(sp)
    800038ca:	6ae2                	ld	s5,24(sp)
    800038cc:	6ba2                	ld	s7,8(sp)
    800038ce:	6c02                	ld	s8,0(sp)
    800038d0:	a039                	j	800038de <filewrite+0xee>
    int i = 0;
    800038d2:	4981                	li	s3,0
    800038d4:	a029                	j	800038de <filewrite+0xee>
    800038d6:	74e2                	ld	s1,56(sp)
    800038d8:	6ae2                	ld	s5,24(sp)
    800038da:	6ba2                	ld	s7,8(sp)
    800038dc:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800038de:	033a1c63          	bne	s4,s3,80003916 <filewrite+0x126>
    800038e2:	8552                	mv	a0,s4
    800038e4:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800038e6:	60a6                	ld	ra,72(sp)
    800038e8:	6406                	ld	s0,64(sp)
    800038ea:	7942                	ld	s2,48(sp)
    800038ec:	7a02                	ld	s4,32(sp)
    800038ee:	6b42                	ld	s6,16(sp)
    800038f0:	6161                	addi	sp,sp,80
    800038f2:	8082                	ret
    800038f4:	fc26                	sd	s1,56(sp)
    800038f6:	f44e                	sd	s3,40(sp)
    800038f8:	ec56                	sd	s5,24(sp)
    800038fa:	e45e                	sd	s7,8(sp)
    800038fc:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800038fe:	00004517          	auipc	a0,0x4
    80003902:	d9a50513          	addi	a0,a0,-614 # 80007698 <etext+0x698>
    80003906:	60d010ef          	jal	80005712 <panic>
    return -1;
    8000390a:	557d                	li	a0,-1
}
    8000390c:	8082                	ret
      return -1;
    8000390e:	557d                	li	a0,-1
    80003910:	bfd9                	j	800038e6 <filewrite+0xf6>
    80003912:	557d                	li	a0,-1
    80003914:	bfc9                	j	800038e6 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003916:	557d                	li	a0,-1
    80003918:	79a2                	ld	s3,40(sp)
    8000391a:	b7f1                	j	800038e6 <filewrite+0xf6>

000000008000391c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000391c:	7179                	addi	sp,sp,-48
    8000391e:	f406                	sd	ra,40(sp)
    80003920:	f022                	sd	s0,32(sp)
    80003922:	ec26                	sd	s1,24(sp)
    80003924:	e052                	sd	s4,0(sp)
    80003926:	1800                	addi	s0,sp,48
    80003928:	84aa                	mv	s1,a0
    8000392a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000392c:	0005b023          	sd	zero,0(a1)
    80003930:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003934:	c3bff0ef          	jal	8000356e <filealloc>
    80003938:	e088                	sd	a0,0(s1)
    8000393a:	c549                	beqz	a0,800039c4 <pipealloc+0xa8>
    8000393c:	c33ff0ef          	jal	8000356e <filealloc>
    80003940:	00aa3023          	sd	a0,0(s4)
    80003944:	cd25                	beqz	a0,800039bc <pipealloc+0xa0>
    80003946:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003948:	fb6fc0ef          	jal	800000fe <kalloc>
    8000394c:	892a                	mv	s2,a0
    8000394e:	c12d                	beqz	a0,800039b0 <pipealloc+0x94>
    80003950:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003952:	4985                	li	s3,1
    80003954:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003958:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000395c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003960:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003964:	00004597          	auipc	a1,0x4
    80003968:	ac458593          	addi	a1,a1,-1340 # 80007428 <etext+0x428>
    8000396c:	054020ef          	jal	800059c0 <initlock>
  (*f0)->type = FD_PIPE;
    80003970:	609c                	ld	a5,0(s1)
    80003972:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003976:	609c                	ld	a5,0(s1)
    80003978:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000397c:	609c                	ld	a5,0(s1)
    8000397e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003982:	609c                	ld	a5,0(s1)
    80003984:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003988:	000a3783          	ld	a5,0(s4)
    8000398c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003990:	000a3783          	ld	a5,0(s4)
    80003994:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003998:	000a3783          	ld	a5,0(s4)
    8000399c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800039a0:	000a3783          	ld	a5,0(s4)
    800039a4:	0127b823          	sd	s2,16(a5)
  return 0;
    800039a8:	4501                	li	a0,0
    800039aa:	6942                	ld	s2,16(sp)
    800039ac:	69a2                	ld	s3,8(sp)
    800039ae:	a01d                	j	800039d4 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800039b0:	6088                	ld	a0,0(s1)
    800039b2:	c119                	beqz	a0,800039b8 <pipealloc+0x9c>
    800039b4:	6942                	ld	s2,16(sp)
    800039b6:	a029                	j	800039c0 <pipealloc+0xa4>
    800039b8:	6942                	ld	s2,16(sp)
    800039ba:	a029                	j	800039c4 <pipealloc+0xa8>
    800039bc:	6088                	ld	a0,0(s1)
    800039be:	c10d                	beqz	a0,800039e0 <pipealloc+0xc4>
    fileclose(*f0);
    800039c0:	c53ff0ef          	jal	80003612 <fileclose>
  if(*f1)
    800039c4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800039c8:	557d                	li	a0,-1
  if(*f1)
    800039ca:	c789                	beqz	a5,800039d4 <pipealloc+0xb8>
    fileclose(*f1);
    800039cc:	853e                	mv	a0,a5
    800039ce:	c45ff0ef          	jal	80003612 <fileclose>
  return -1;
    800039d2:	557d                	li	a0,-1
}
    800039d4:	70a2                	ld	ra,40(sp)
    800039d6:	7402                	ld	s0,32(sp)
    800039d8:	64e2                	ld	s1,24(sp)
    800039da:	6a02                	ld	s4,0(sp)
    800039dc:	6145                	addi	sp,sp,48
    800039de:	8082                	ret
  return -1;
    800039e0:	557d                	li	a0,-1
    800039e2:	bfcd                	j	800039d4 <pipealloc+0xb8>

00000000800039e4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800039e4:	1101                	addi	sp,sp,-32
    800039e6:	ec06                	sd	ra,24(sp)
    800039e8:	e822                	sd	s0,16(sp)
    800039ea:	e426                	sd	s1,8(sp)
    800039ec:	e04a                	sd	s2,0(sp)
    800039ee:	1000                	addi	s0,sp,32
    800039f0:	84aa                	mv	s1,a0
    800039f2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800039f4:	04c020ef          	jal	80005a40 <acquire>
  if(writable){
    800039f8:	02090763          	beqz	s2,80003a26 <pipeclose+0x42>
    pi->writeopen = 0;
    800039fc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003a00:	21848513          	addi	a0,s1,536
    80003a04:	9dbfd0ef          	jal	800013de <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003a08:	2204b783          	ld	a5,544(s1)
    80003a0c:	e785                	bnez	a5,80003a34 <pipeclose+0x50>
    release(&pi->lock);
    80003a0e:	8526                	mv	a0,s1
    80003a10:	0c8020ef          	jal	80005ad8 <release>
    kfree((char*)pi);
    80003a14:	8526                	mv	a0,s1
    80003a16:	e06fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003a1a:	60e2                	ld	ra,24(sp)
    80003a1c:	6442                	ld	s0,16(sp)
    80003a1e:	64a2                	ld	s1,8(sp)
    80003a20:	6902                	ld	s2,0(sp)
    80003a22:	6105                	addi	sp,sp,32
    80003a24:	8082                	ret
    pi->readopen = 0;
    80003a26:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003a2a:	21c48513          	addi	a0,s1,540
    80003a2e:	9b1fd0ef          	jal	800013de <wakeup>
    80003a32:	bfd9                	j	80003a08 <pipeclose+0x24>
    release(&pi->lock);
    80003a34:	8526                	mv	a0,s1
    80003a36:	0a2020ef          	jal	80005ad8 <release>
}
    80003a3a:	b7c5                	j	80003a1a <pipeclose+0x36>

0000000080003a3c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003a3c:	711d                	addi	sp,sp,-96
    80003a3e:	ec86                	sd	ra,88(sp)
    80003a40:	e8a2                	sd	s0,80(sp)
    80003a42:	e4a6                	sd	s1,72(sp)
    80003a44:	e0ca                	sd	s2,64(sp)
    80003a46:	fc4e                	sd	s3,56(sp)
    80003a48:	f852                	sd	s4,48(sp)
    80003a4a:	f456                	sd	s5,40(sp)
    80003a4c:	1080                	addi	s0,sp,96
    80003a4e:	84aa                	mv	s1,a0
    80003a50:	8aae                	mv	s5,a1
    80003a52:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003a54:	b68fd0ef          	jal	80000dbc <myproc>
    80003a58:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003a5a:	8526                	mv	a0,s1
    80003a5c:	7e5010ef          	jal	80005a40 <acquire>
  while(i < n){
    80003a60:	0b405a63          	blez	s4,80003b14 <pipewrite+0xd8>
    80003a64:	f05a                	sd	s6,32(sp)
    80003a66:	ec5e                	sd	s7,24(sp)
    80003a68:	e862                	sd	s8,16(sp)
  int i = 0;
    80003a6a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a6c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003a6e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003a72:	21c48b93          	addi	s7,s1,540
    80003a76:	a81d                	j	80003aac <pipewrite+0x70>
      release(&pi->lock);
    80003a78:	8526                	mv	a0,s1
    80003a7a:	05e020ef          	jal	80005ad8 <release>
      return -1;
    80003a7e:	597d                	li	s2,-1
    80003a80:	7b02                	ld	s6,32(sp)
    80003a82:	6be2                	ld	s7,24(sp)
    80003a84:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003a86:	854a                	mv	a0,s2
    80003a88:	60e6                	ld	ra,88(sp)
    80003a8a:	6446                	ld	s0,80(sp)
    80003a8c:	64a6                	ld	s1,72(sp)
    80003a8e:	6906                	ld	s2,64(sp)
    80003a90:	79e2                	ld	s3,56(sp)
    80003a92:	7a42                	ld	s4,48(sp)
    80003a94:	7aa2                	ld	s5,40(sp)
    80003a96:	6125                	addi	sp,sp,96
    80003a98:	8082                	ret
      wakeup(&pi->nread);
    80003a9a:	8562                	mv	a0,s8
    80003a9c:	943fd0ef          	jal	800013de <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003aa0:	85a6                	mv	a1,s1
    80003aa2:	855e                	mv	a0,s7
    80003aa4:	8effd0ef          	jal	80001392 <sleep>
  while(i < n){
    80003aa8:	05495b63          	bge	s2,s4,80003afe <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003aac:	2204a783          	lw	a5,544(s1)
    80003ab0:	d7e1                	beqz	a5,80003a78 <pipewrite+0x3c>
    80003ab2:	854e                	mv	a0,s3
    80003ab4:	b17fd0ef          	jal	800015ca <killed>
    80003ab8:	f161                	bnez	a0,80003a78 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003aba:	2184a783          	lw	a5,536(s1)
    80003abe:	21c4a703          	lw	a4,540(s1)
    80003ac2:	2007879b          	addiw	a5,a5,512
    80003ac6:	fcf70ae3          	beq	a4,a5,80003a9a <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003aca:	4685                	li	a3,1
    80003acc:	01590633          	add	a2,s2,s5
    80003ad0:	faf40593          	addi	a1,s0,-81
    80003ad4:	0509b503          	ld	a0,80(s3)
    80003ad8:	818fd0ef          	jal	80000af0 <copyin>
    80003adc:	03650e63          	beq	a0,s6,80003b18 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ae0:	21c4a783          	lw	a5,540(s1)
    80003ae4:	0017871b          	addiw	a4,a5,1
    80003ae8:	20e4ae23          	sw	a4,540(s1)
    80003aec:	1ff7f793          	andi	a5,a5,511
    80003af0:	97a6                	add	a5,a5,s1
    80003af2:	faf44703          	lbu	a4,-81(s0)
    80003af6:	00e78c23          	sb	a4,24(a5)
      i++;
    80003afa:	2905                	addiw	s2,s2,1
    80003afc:	b775                	j	80003aa8 <pipewrite+0x6c>
    80003afe:	7b02                	ld	s6,32(sp)
    80003b00:	6be2                	ld	s7,24(sp)
    80003b02:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003b04:	21848513          	addi	a0,s1,536
    80003b08:	8d7fd0ef          	jal	800013de <wakeup>
  release(&pi->lock);
    80003b0c:	8526                	mv	a0,s1
    80003b0e:	7cb010ef          	jal	80005ad8 <release>
  return i;
    80003b12:	bf95                	j	80003a86 <pipewrite+0x4a>
  int i = 0;
    80003b14:	4901                	li	s2,0
    80003b16:	b7fd                	j	80003b04 <pipewrite+0xc8>
    80003b18:	7b02                	ld	s6,32(sp)
    80003b1a:	6be2                	ld	s7,24(sp)
    80003b1c:	6c42                	ld	s8,16(sp)
    80003b1e:	b7dd                	j	80003b04 <pipewrite+0xc8>

0000000080003b20 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003b20:	715d                	addi	sp,sp,-80
    80003b22:	e486                	sd	ra,72(sp)
    80003b24:	e0a2                	sd	s0,64(sp)
    80003b26:	fc26                	sd	s1,56(sp)
    80003b28:	f84a                	sd	s2,48(sp)
    80003b2a:	f44e                	sd	s3,40(sp)
    80003b2c:	f052                	sd	s4,32(sp)
    80003b2e:	ec56                	sd	s5,24(sp)
    80003b30:	0880                	addi	s0,sp,80
    80003b32:	84aa                	mv	s1,a0
    80003b34:	892e                	mv	s2,a1
    80003b36:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003b38:	a84fd0ef          	jal	80000dbc <myproc>
    80003b3c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003b3e:	8526                	mv	a0,s1
    80003b40:	701010ef          	jal	80005a40 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b44:	2184a703          	lw	a4,536(s1)
    80003b48:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b4c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b50:	02f71563          	bne	a4,a5,80003b7a <piperead+0x5a>
    80003b54:	2244a783          	lw	a5,548(s1)
    80003b58:	cb85                	beqz	a5,80003b88 <piperead+0x68>
    if(killed(pr)){
    80003b5a:	8552                	mv	a0,s4
    80003b5c:	a6ffd0ef          	jal	800015ca <killed>
    80003b60:	ed19                	bnez	a0,80003b7e <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b62:	85a6                	mv	a1,s1
    80003b64:	854e                	mv	a0,s3
    80003b66:	82dfd0ef          	jal	80001392 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b6a:	2184a703          	lw	a4,536(s1)
    80003b6e:	21c4a783          	lw	a5,540(s1)
    80003b72:	fef701e3          	beq	a4,a5,80003b54 <piperead+0x34>
    80003b76:	e85a                	sd	s6,16(sp)
    80003b78:	a809                	j	80003b8a <piperead+0x6a>
    80003b7a:	e85a                	sd	s6,16(sp)
    80003b7c:	a039                	j	80003b8a <piperead+0x6a>
      release(&pi->lock);
    80003b7e:	8526                	mv	a0,s1
    80003b80:	759010ef          	jal	80005ad8 <release>
      return -1;
    80003b84:	59fd                	li	s3,-1
    80003b86:	a8b1                	j	80003be2 <piperead+0xc2>
    80003b88:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b8a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b8c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b8e:	05505263          	blez	s5,80003bd2 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003b92:	2184a783          	lw	a5,536(s1)
    80003b96:	21c4a703          	lw	a4,540(s1)
    80003b9a:	02f70c63          	beq	a4,a5,80003bd2 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003b9e:	0017871b          	addiw	a4,a5,1
    80003ba2:	20e4ac23          	sw	a4,536(s1)
    80003ba6:	1ff7f793          	andi	a5,a5,511
    80003baa:	97a6                	add	a5,a5,s1
    80003bac:	0187c783          	lbu	a5,24(a5)
    80003bb0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003bb4:	4685                	li	a3,1
    80003bb6:	fbf40613          	addi	a2,s0,-65
    80003bba:	85ca                	mv	a1,s2
    80003bbc:	050a3503          	ld	a0,80(s4)
    80003bc0:	e5bfc0ef          	jal	80000a1a <copyout>
    80003bc4:	01650763          	beq	a0,s6,80003bd2 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003bc8:	2985                	addiw	s3,s3,1
    80003bca:	0905                	addi	s2,s2,1
    80003bcc:	fd3a93e3          	bne	s5,s3,80003b92 <piperead+0x72>
    80003bd0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003bd2:	21c48513          	addi	a0,s1,540
    80003bd6:	809fd0ef          	jal	800013de <wakeup>
  release(&pi->lock);
    80003bda:	8526                	mv	a0,s1
    80003bdc:	6fd010ef          	jal	80005ad8 <release>
    80003be0:	6b42                	ld	s6,16(sp)
  return i;
}
    80003be2:	854e                	mv	a0,s3
    80003be4:	60a6                	ld	ra,72(sp)
    80003be6:	6406                	ld	s0,64(sp)
    80003be8:	74e2                	ld	s1,56(sp)
    80003bea:	7942                	ld	s2,48(sp)
    80003bec:	79a2                	ld	s3,40(sp)
    80003bee:	7a02                	ld	s4,32(sp)
    80003bf0:	6ae2                	ld	s5,24(sp)
    80003bf2:	6161                	addi	sp,sp,80
    80003bf4:	8082                	ret

0000000080003bf6 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003bf6:	1141                	addi	sp,sp,-16
    80003bf8:	e422                	sd	s0,8(sp)
    80003bfa:	0800                	addi	s0,sp,16
    80003bfc:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003bfe:	8905                	andi	a0,a0,1
    80003c00:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003c02:	8b89                	andi	a5,a5,2
    80003c04:	c399                	beqz	a5,80003c0a <flags2perm+0x14>
      perm |= PTE_W;
    80003c06:	00456513          	ori	a0,a0,4
    return perm;
}
    80003c0a:	6422                	ld	s0,8(sp)
    80003c0c:	0141                	addi	sp,sp,16
    80003c0e:	8082                	ret

0000000080003c10 <exec>:

int
exec(char *path, char **argv)
{
    80003c10:	df010113          	addi	sp,sp,-528
    80003c14:	20113423          	sd	ra,520(sp)
    80003c18:	20813023          	sd	s0,512(sp)
    80003c1c:	ffa6                	sd	s1,504(sp)
    80003c1e:	fbca                	sd	s2,496(sp)
    80003c20:	0c00                	addi	s0,sp,528
    80003c22:	892a                	mv	s2,a0
    80003c24:	dea43c23          	sd	a0,-520(s0)
    80003c28:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003c2c:	990fd0ef          	jal	80000dbc <myproc>
    80003c30:	84aa                	mv	s1,a0

  begin_op();
    80003c32:	dc6ff0ef          	jal	800031f8 <begin_op>

  if((ip = namei(path)) == 0){
    80003c36:	854a                	mv	a0,s2
    80003c38:	c04ff0ef          	jal	8000303c <namei>
    80003c3c:	c931                	beqz	a0,80003c90 <exec+0x80>
    80003c3e:	f3d2                	sd	s4,480(sp)
    80003c40:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003c42:	d21fe0ef          	jal	80002962 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003c46:	04000713          	li	a4,64
    80003c4a:	4681                	li	a3,0
    80003c4c:	e5040613          	addi	a2,s0,-432
    80003c50:	4581                	li	a1,0
    80003c52:	8552                	mv	a0,s4
    80003c54:	f63fe0ef          	jal	80002bb6 <readi>
    80003c58:	04000793          	li	a5,64
    80003c5c:	00f51a63          	bne	a0,a5,80003c70 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003c60:	e5042703          	lw	a4,-432(s0)
    80003c64:	464c47b7          	lui	a5,0x464c4
    80003c68:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003c6c:	02f70663          	beq	a4,a5,80003c98 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003c70:	8552                	mv	a0,s4
    80003c72:	efbfe0ef          	jal	80002b6c <iunlockput>
    end_op();
    80003c76:	decff0ef          	jal	80003262 <end_op>
  }
  return -1;
    80003c7a:	557d                	li	a0,-1
    80003c7c:	7a1e                	ld	s4,480(sp)
}
    80003c7e:	20813083          	ld	ra,520(sp)
    80003c82:	20013403          	ld	s0,512(sp)
    80003c86:	74fe                	ld	s1,504(sp)
    80003c88:	795e                	ld	s2,496(sp)
    80003c8a:	21010113          	addi	sp,sp,528
    80003c8e:	8082                	ret
    end_op();
    80003c90:	dd2ff0ef          	jal	80003262 <end_op>
    return -1;
    80003c94:	557d                	li	a0,-1
    80003c96:	b7e5                	j	80003c7e <exec+0x6e>
    80003c98:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003c9a:	8526                	mv	a0,s1
    80003c9c:	9c8fd0ef          	jal	80000e64 <proc_pagetable>
    80003ca0:	8b2a                	mv	s6,a0
    80003ca2:	2c050b63          	beqz	a0,80003f78 <exec+0x368>
    80003ca6:	f7ce                	sd	s3,488(sp)
    80003ca8:	efd6                	sd	s5,472(sp)
    80003caa:	e7de                	sd	s7,456(sp)
    80003cac:	e3e2                	sd	s8,448(sp)
    80003cae:	ff66                	sd	s9,440(sp)
    80003cb0:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003cb2:	e7042d03          	lw	s10,-400(s0)
    80003cb6:	e8845783          	lhu	a5,-376(s0)
    80003cba:	12078963          	beqz	a5,80003dec <exec+0x1dc>
    80003cbe:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003cc0:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003cc2:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003cc4:	6c85                	lui	s9,0x1
    80003cc6:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003cca:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003cce:	6a85                	lui	s5,0x1
    80003cd0:	a085                	j	80003d30 <exec+0x120>
      panic("loadseg: address should exist");
    80003cd2:	00004517          	auipc	a0,0x4
    80003cd6:	9d650513          	addi	a0,a0,-1578 # 800076a8 <etext+0x6a8>
    80003cda:	239010ef          	jal	80005712 <panic>
    if(sz - i < PGSIZE)
    80003cde:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003ce0:	8726                	mv	a4,s1
    80003ce2:	012c06bb          	addw	a3,s8,s2
    80003ce6:	4581                	li	a1,0
    80003ce8:	8552                	mv	a0,s4
    80003cea:	ecdfe0ef          	jal	80002bb6 <readi>
    80003cee:	2501                	sext.w	a0,a0
    80003cf0:	24a49a63          	bne	s1,a0,80003f44 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003cf4:	012a893b          	addw	s2,s5,s2
    80003cf8:	03397363          	bgeu	s2,s3,80003d1e <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003cfc:	02091593          	slli	a1,s2,0x20
    80003d00:	9181                	srli	a1,a1,0x20
    80003d02:	95de                	add	a1,a1,s7
    80003d04:	855a                	mv	a0,s6
    80003d06:	f98fc0ef          	jal	8000049e <walkaddr>
    80003d0a:	862a                	mv	a2,a0
    if(pa == 0)
    80003d0c:	d179                	beqz	a0,80003cd2 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003d0e:	412984bb          	subw	s1,s3,s2
    80003d12:	0004879b          	sext.w	a5,s1
    80003d16:	fcfcf4e3          	bgeu	s9,a5,80003cde <exec+0xce>
    80003d1a:	84d6                	mv	s1,s5
    80003d1c:	b7c9                	j	80003cde <exec+0xce>
    sz = sz1;
    80003d1e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d22:	2d85                	addiw	s11,s11,1
    80003d24:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80003d28:	e8845783          	lhu	a5,-376(s0)
    80003d2c:	08fdd063          	bge	s11,a5,80003dac <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003d30:	2d01                	sext.w	s10,s10
    80003d32:	03800713          	li	a4,56
    80003d36:	86ea                	mv	a3,s10
    80003d38:	e1840613          	addi	a2,s0,-488
    80003d3c:	4581                	li	a1,0
    80003d3e:	8552                	mv	a0,s4
    80003d40:	e77fe0ef          	jal	80002bb6 <readi>
    80003d44:	03800793          	li	a5,56
    80003d48:	1cf51663          	bne	a0,a5,80003f14 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003d4c:	e1842783          	lw	a5,-488(s0)
    80003d50:	4705                	li	a4,1
    80003d52:	fce798e3          	bne	a5,a4,80003d22 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003d56:	e4043483          	ld	s1,-448(s0)
    80003d5a:	e3843783          	ld	a5,-456(s0)
    80003d5e:	1af4ef63          	bltu	s1,a5,80003f1c <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003d62:	e2843783          	ld	a5,-472(s0)
    80003d66:	94be                	add	s1,s1,a5
    80003d68:	1af4ee63          	bltu	s1,a5,80003f24 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003d6c:	df043703          	ld	a4,-528(s0)
    80003d70:	8ff9                	and	a5,a5,a4
    80003d72:	1a079d63          	bnez	a5,80003f2c <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003d76:	e1c42503          	lw	a0,-484(s0)
    80003d7a:	e7dff0ef          	jal	80003bf6 <flags2perm>
    80003d7e:	86aa                	mv	a3,a0
    80003d80:	8626                	mv	a2,s1
    80003d82:	85ca                	mv	a1,s2
    80003d84:	855a                	mv	a0,s6
    80003d86:	a81fc0ef          	jal	80000806 <uvmalloc>
    80003d8a:	e0a43423          	sd	a0,-504(s0)
    80003d8e:	1a050363          	beqz	a0,80003f34 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d92:	e2843b83          	ld	s7,-472(s0)
    80003d96:	e2042c03          	lw	s8,-480(s0)
    80003d9a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d9e:	00098463          	beqz	s3,80003da6 <exec+0x196>
    80003da2:	4901                	li	s2,0
    80003da4:	bfa1                	j	80003cfc <exec+0xec>
    sz = sz1;
    80003da6:	e0843903          	ld	s2,-504(s0)
    80003daa:	bfa5                	j	80003d22 <exec+0x112>
    80003dac:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003dae:	8552                	mv	a0,s4
    80003db0:	dbdfe0ef          	jal	80002b6c <iunlockput>
  end_op();
    80003db4:	caeff0ef          	jal	80003262 <end_op>
  p = myproc();
    80003db8:	804fd0ef          	jal	80000dbc <myproc>
    80003dbc:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003dbe:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003dc2:	6985                	lui	s3,0x1
    80003dc4:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003dc6:	99ca                	add	s3,s3,s2
    80003dc8:	77fd                	lui	a5,0xfffff
    80003dca:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003dce:	4691                	li	a3,4
    80003dd0:	6609                	lui	a2,0x2
    80003dd2:	964e                	add	a2,a2,s3
    80003dd4:	85ce                	mv	a1,s3
    80003dd6:	855a                	mv	a0,s6
    80003dd8:	a2ffc0ef          	jal	80000806 <uvmalloc>
    80003ddc:	892a                	mv	s2,a0
    80003dde:	e0a43423          	sd	a0,-504(s0)
    80003de2:	e519                	bnez	a0,80003df0 <exec+0x1e0>
  if(pagetable)
    80003de4:	e1343423          	sd	s3,-504(s0)
    80003de8:	4a01                	li	s4,0
    80003dea:	aab1                	j	80003f46 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003dec:	4901                	li	s2,0
    80003dee:	b7c1                	j	80003dae <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003df0:	75f9                	lui	a1,0xffffe
    80003df2:	95aa                	add	a1,a1,a0
    80003df4:	855a                	mv	a0,s6
    80003df6:	bfbfc0ef          	jal	800009f0 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003dfa:	7bfd                	lui	s7,0xfffff
    80003dfc:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003dfe:	e0043783          	ld	a5,-512(s0)
    80003e02:	6388                	ld	a0,0(a5)
    80003e04:	cd39                	beqz	a0,80003e62 <exec+0x252>
    80003e06:	e9040993          	addi	s3,s0,-368
    80003e0a:	f9040c13          	addi	s8,s0,-112
    80003e0e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003e10:	cf0fc0ef          	jal	80000300 <strlen>
    80003e14:	0015079b          	addiw	a5,a0,1
    80003e18:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003e1c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003e20:	11796e63          	bltu	s2,s7,80003f3c <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003e24:	e0043d03          	ld	s10,-512(s0)
    80003e28:	000d3a03          	ld	s4,0(s10)
    80003e2c:	8552                	mv	a0,s4
    80003e2e:	cd2fc0ef          	jal	80000300 <strlen>
    80003e32:	0015069b          	addiw	a3,a0,1
    80003e36:	8652                	mv	a2,s4
    80003e38:	85ca                	mv	a1,s2
    80003e3a:	855a                	mv	a0,s6
    80003e3c:	bdffc0ef          	jal	80000a1a <copyout>
    80003e40:	10054063          	bltz	a0,80003f40 <exec+0x330>
    ustack[argc] = sp;
    80003e44:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003e48:	0485                	addi	s1,s1,1
    80003e4a:	008d0793          	addi	a5,s10,8
    80003e4e:	e0f43023          	sd	a5,-512(s0)
    80003e52:	008d3503          	ld	a0,8(s10)
    80003e56:	c909                	beqz	a0,80003e68 <exec+0x258>
    if(argc >= MAXARG)
    80003e58:	09a1                	addi	s3,s3,8
    80003e5a:	fb899be3          	bne	s3,s8,80003e10 <exec+0x200>
  ip = 0;
    80003e5e:	4a01                	li	s4,0
    80003e60:	a0dd                	j	80003f46 <exec+0x336>
  sp = sz;
    80003e62:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003e66:	4481                	li	s1,0
  ustack[argc] = 0;
    80003e68:	00349793          	slli	a5,s1,0x3
    80003e6c:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb4c0>
    80003e70:	97a2                	add	a5,a5,s0
    80003e72:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003e76:	00148693          	addi	a3,s1,1
    80003e7a:	068e                	slli	a3,a3,0x3
    80003e7c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003e80:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003e84:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003e88:	f5796ee3          	bltu	s2,s7,80003de4 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003e8c:	e9040613          	addi	a2,s0,-368
    80003e90:	85ca                	mv	a1,s2
    80003e92:	855a                	mv	a0,s6
    80003e94:	b87fc0ef          	jal	80000a1a <copyout>
    80003e98:	0e054263          	bltz	a0,80003f7c <exec+0x36c>
  p->trapframe->a1 = sp;
    80003e9c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003ea0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003ea4:	df843783          	ld	a5,-520(s0)
    80003ea8:	0007c703          	lbu	a4,0(a5)
    80003eac:	cf11                	beqz	a4,80003ec8 <exec+0x2b8>
    80003eae:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003eb0:	02f00693          	li	a3,47
    80003eb4:	a039                	j	80003ec2 <exec+0x2b2>
      last = s+1;
    80003eb6:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003eba:	0785                	addi	a5,a5,1
    80003ebc:	fff7c703          	lbu	a4,-1(a5)
    80003ec0:	c701                	beqz	a4,80003ec8 <exec+0x2b8>
    if(*s == '/')
    80003ec2:	fed71ce3          	bne	a4,a3,80003eba <exec+0x2aa>
    80003ec6:	bfc5                	j	80003eb6 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003ec8:	4641                	li	a2,16
    80003eca:	df843583          	ld	a1,-520(s0)
    80003ece:	158a8513          	addi	a0,s5,344
    80003ed2:	bfcfc0ef          	jal	800002ce <safestrcpy>
  oldpagetable = p->pagetable;
    80003ed6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003eda:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003ede:	e0843783          	ld	a5,-504(s0)
    80003ee2:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003ee6:	058ab783          	ld	a5,88(s5)
    80003eea:	e6843703          	ld	a4,-408(s0)
    80003eee:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003ef0:	058ab783          	ld	a5,88(s5)
    80003ef4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003ef8:	85e6                	mv	a1,s9
    80003efa:	feffc0ef          	jal	80000ee8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003efe:	0004851b          	sext.w	a0,s1
    80003f02:	79be                	ld	s3,488(sp)
    80003f04:	7a1e                	ld	s4,480(sp)
    80003f06:	6afe                	ld	s5,472(sp)
    80003f08:	6b5e                	ld	s6,464(sp)
    80003f0a:	6bbe                	ld	s7,456(sp)
    80003f0c:	6c1e                	ld	s8,448(sp)
    80003f0e:	7cfa                	ld	s9,440(sp)
    80003f10:	7d5a                	ld	s10,432(sp)
    80003f12:	b3b5                	j	80003c7e <exec+0x6e>
    80003f14:	e1243423          	sd	s2,-504(s0)
    80003f18:	7dba                	ld	s11,424(sp)
    80003f1a:	a035                	j	80003f46 <exec+0x336>
    80003f1c:	e1243423          	sd	s2,-504(s0)
    80003f20:	7dba                	ld	s11,424(sp)
    80003f22:	a015                	j	80003f46 <exec+0x336>
    80003f24:	e1243423          	sd	s2,-504(s0)
    80003f28:	7dba                	ld	s11,424(sp)
    80003f2a:	a831                	j	80003f46 <exec+0x336>
    80003f2c:	e1243423          	sd	s2,-504(s0)
    80003f30:	7dba                	ld	s11,424(sp)
    80003f32:	a811                	j	80003f46 <exec+0x336>
    80003f34:	e1243423          	sd	s2,-504(s0)
    80003f38:	7dba                	ld	s11,424(sp)
    80003f3a:	a031                	j	80003f46 <exec+0x336>
  ip = 0;
    80003f3c:	4a01                	li	s4,0
    80003f3e:	a021                	j	80003f46 <exec+0x336>
    80003f40:	4a01                	li	s4,0
  if(pagetable)
    80003f42:	a011                	j	80003f46 <exec+0x336>
    80003f44:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003f46:	e0843583          	ld	a1,-504(s0)
    80003f4a:	855a                	mv	a0,s6
    80003f4c:	f9dfc0ef          	jal	80000ee8 <proc_freepagetable>
  return -1;
    80003f50:	557d                	li	a0,-1
  if(ip){
    80003f52:	000a1b63          	bnez	s4,80003f68 <exec+0x358>
    80003f56:	79be                	ld	s3,488(sp)
    80003f58:	7a1e                	ld	s4,480(sp)
    80003f5a:	6afe                	ld	s5,472(sp)
    80003f5c:	6b5e                	ld	s6,464(sp)
    80003f5e:	6bbe                	ld	s7,456(sp)
    80003f60:	6c1e                	ld	s8,448(sp)
    80003f62:	7cfa                	ld	s9,440(sp)
    80003f64:	7d5a                	ld	s10,432(sp)
    80003f66:	bb21                	j	80003c7e <exec+0x6e>
    80003f68:	79be                	ld	s3,488(sp)
    80003f6a:	6afe                	ld	s5,472(sp)
    80003f6c:	6b5e                	ld	s6,464(sp)
    80003f6e:	6bbe                	ld	s7,456(sp)
    80003f70:	6c1e                	ld	s8,448(sp)
    80003f72:	7cfa                	ld	s9,440(sp)
    80003f74:	7d5a                	ld	s10,432(sp)
    80003f76:	b9ed                	j	80003c70 <exec+0x60>
    80003f78:	6b5e                	ld	s6,464(sp)
    80003f7a:	b9dd                	j	80003c70 <exec+0x60>
  sz = sz1;
    80003f7c:	e0843983          	ld	s3,-504(s0)
    80003f80:	b595                	j	80003de4 <exec+0x1d4>

0000000080003f82 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003f82:	7179                	addi	sp,sp,-48
    80003f84:	f406                	sd	ra,40(sp)
    80003f86:	f022                	sd	s0,32(sp)
    80003f88:	ec26                	sd	s1,24(sp)
    80003f8a:	e84a                	sd	s2,16(sp)
    80003f8c:	1800                	addi	s0,sp,48
    80003f8e:	892e                	mv	s2,a1
    80003f90:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003f92:	fdc40593          	addi	a1,s0,-36
    80003f96:	e43fd0ef          	jal	80001dd8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003f9a:	fdc42703          	lw	a4,-36(s0)
    80003f9e:	47bd                	li	a5,15
    80003fa0:	02e7e963          	bltu	a5,a4,80003fd2 <argfd+0x50>
    80003fa4:	e19fc0ef          	jal	80000dbc <myproc>
    80003fa8:	fdc42703          	lw	a4,-36(s0)
    80003fac:	01a70793          	addi	a5,a4,26
    80003fb0:	078e                	slli	a5,a5,0x3
    80003fb2:	953e                	add	a0,a0,a5
    80003fb4:	611c                	ld	a5,0(a0)
    80003fb6:	c385                	beqz	a5,80003fd6 <argfd+0x54>
    return -1;
  if(pfd)
    80003fb8:	00090463          	beqz	s2,80003fc0 <argfd+0x3e>
    *pfd = fd;
    80003fbc:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003fc0:	4501                	li	a0,0
  if(pf)
    80003fc2:	c091                	beqz	s1,80003fc6 <argfd+0x44>
    *pf = f;
    80003fc4:	e09c                	sd	a5,0(s1)
}
    80003fc6:	70a2                	ld	ra,40(sp)
    80003fc8:	7402                	ld	s0,32(sp)
    80003fca:	64e2                	ld	s1,24(sp)
    80003fcc:	6942                	ld	s2,16(sp)
    80003fce:	6145                	addi	sp,sp,48
    80003fd0:	8082                	ret
    return -1;
    80003fd2:	557d                	li	a0,-1
    80003fd4:	bfcd                	j	80003fc6 <argfd+0x44>
    80003fd6:	557d                	li	a0,-1
    80003fd8:	b7fd                	j	80003fc6 <argfd+0x44>

0000000080003fda <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003fda:	1101                	addi	sp,sp,-32
    80003fdc:	ec06                	sd	ra,24(sp)
    80003fde:	e822                	sd	s0,16(sp)
    80003fe0:	e426                	sd	s1,8(sp)
    80003fe2:	1000                	addi	s0,sp,32
    80003fe4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003fe6:	dd7fc0ef          	jal	80000dbc <myproc>
    80003fea:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003fec:	0d050793          	addi	a5,a0,208
    80003ff0:	4501                	li	a0,0
    80003ff2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003ff4:	6398                	ld	a4,0(a5)
    80003ff6:	cb19                	beqz	a4,8000400c <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003ff8:	2505                	addiw	a0,a0,1
    80003ffa:	07a1                	addi	a5,a5,8
    80003ffc:	fed51ce3          	bne	a0,a3,80003ff4 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004000:	557d                	li	a0,-1
}
    80004002:	60e2                	ld	ra,24(sp)
    80004004:	6442                	ld	s0,16(sp)
    80004006:	64a2                	ld	s1,8(sp)
    80004008:	6105                	addi	sp,sp,32
    8000400a:	8082                	ret
      p->ofile[fd] = f;
    8000400c:	01a50793          	addi	a5,a0,26
    80004010:	078e                	slli	a5,a5,0x3
    80004012:	963e                	add	a2,a2,a5
    80004014:	e204                	sd	s1,0(a2)
      return fd;
    80004016:	b7f5                	j	80004002 <fdalloc+0x28>

0000000080004018 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004018:	715d                	addi	sp,sp,-80
    8000401a:	e486                	sd	ra,72(sp)
    8000401c:	e0a2                	sd	s0,64(sp)
    8000401e:	fc26                	sd	s1,56(sp)
    80004020:	f84a                	sd	s2,48(sp)
    80004022:	f44e                	sd	s3,40(sp)
    80004024:	ec56                	sd	s5,24(sp)
    80004026:	e85a                	sd	s6,16(sp)
    80004028:	0880                	addi	s0,sp,80
    8000402a:	8b2e                	mv	s6,a1
    8000402c:	89b2                	mv	s3,a2
    8000402e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004030:	fb040593          	addi	a1,s0,-80
    80004034:	822ff0ef          	jal	80003056 <nameiparent>
    80004038:	84aa                	mv	s1,a0
    8000403a:	10050a63          	beqz	a0,8000414e <create+0x136>
    return 0;

  ilock(dp);
    8000403e:	925fe0ef          	jal	80002962 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004042:	4601                	li	a2,0
    80004044:	fb040593          	addi	a1,s0,-80
    80004048:	8526                	mv	a0,s1
    8000404a:	d8dfe0ef          	jal	80002dd6 <dirlookup>
    8000404e:	8aaa                	mv	s5,a0
    80004050:	c129                	beqz	a0,80004092 <create+0x7a>
    iunlockput(dp);
    80004052:	8526                	mv	a0,s1
    80004054:	b19fe0ef          	jal	80002b6c <iunlockput>
    ilock(ip);
    80004058:	8556                	mv	a0,s5
    8000405a:	909fe0ef          	jal	80002962 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000405e:	4789                	li	a5,2
    80004060:	02fb1463          	bne	s6,a5,80004088 <create+0x70>
    80004064:	044ad783          	lhu	a5,68(s5)
    80004068:	37f9                	addiw	a5,a5,-2
    8000406a:	17c2                	slli	a5,a5,0x30
    8000406c:	93c1                	srli	a5,a5,0x30
    8000406e:	4705                	li	a4,1
    80004070:	00f76c63          	bltu	a4,a5,80004088 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004074:	8556                	mv	a0,s5
    80004076:	60a6                	ld	ra,72(sp)
    80004078:	6406                	ld	s0,64(sp)
    8000407a:	74e2                	ld	s1,56(sp)
    8000407c:	7942                	ld	s2,48(sp)
    8000407e:	79a2                	ld	s3,40(sp)
    80004080:	6ae2                	ld	s5,24(sp)
    80004082:	6b42                	ld	s6,16(sp)
    80004084:	6161                	addi	sp,sp,80
    80004086:	8082                	ret
    iunlockput(ip);
    80004088:	8556                	mv	a0,s5
    8000408a:	ae3fe0ef          	jal	80002b6c <iunlockput>
    return 0;
    8000408e:	4a81                	li	s5,0
    80004090:	b7d5                	j	80004074 <create+0x5c>
    80004092:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004094:	85da                	mv	a1,s6
    80004096:	4088                	lw	a0,0(s1)
    80004098:	f5afe0ef          	jal	800027f2 <ialloc>
    8000409c:	8a2a                	mv	s4,a0
    8000409e:	cd15                	beqz	a0,800040da <create+0xc2>
  ilock(ip);
    800040a0:	8c3fe0ef          	jal	80002962 <ilock>
  ip->major = major;
    800040a4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800040a8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800040ac:	4905                	li	s2,1
    800040ae:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800040b2:	8552                	mv	a0,s4
    800040b4:	ffafe0ef          	jal	800028ae <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800040b8:	032b0763          	beq	s6,s2,800040e6 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    800040bc:	004a2603          	lw	a2,4(s4)
    800040c0:	fb040593          	addi	a1,s0,-80
    800040c4:	8526                	mv	a0,s1
    800040c6:	eddfe0ef          	jal	80002fa2 <dirlink>
    800040ca:	06054563          	bltz	a0,80004134 <create+0x11c>
  iunlockput(dp);
    800040ce:	8526                	mv	a0,s1
    800040d0:	a9dfe0ef          	jal	80002b6c <iunlockput>
  return ip;
    800040d4:	8ad2                	mv	s5,s4
    800040d6:	7a02                	ld	s4,32(sp)
    800040d8:	bf71                	j	80004074 <create+0x5c>
    iunlockput(dp);
    800040da:	8526                	mv	a0,s1
    800040dc:	a91fe0ef          	jal	80002b6c <iunlockput>
    return 0;
    800040e0:	8ad2                	mv	s5,s4
    800040e2:	7a02                	ld	s4,32(sp)
    800040e4:	bf41                	j	80004074 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800040e6:	004a2603          	lw	a2,4(s4)
    800040ea:	00003597          	auipc	a1,0x3
    800040ee:	5de58593          	addi	a1,a1,1502 # 800076c8 <etext+0x6c8>
    800040f2:	8552                	mv	a0,s4
    800040f4:	eaffe0ef          	jal	80002fa2 <dirlink>
    800040f8:	02054e63          	bltz	a0,80004134 <create+0x11c>
    800040fc:	40d0                	lw	a2,4(s1)
    800040fe:	00003597          	auipc	a1,0x3
    80004102:	5d258593          	addi	a1,a1,1490 # 800076d0 <etext+0x6d0>
    80004106:	8552                	mv	a0,s4
    80004108:	e9bfe0ef          	jal	80002fa2 <dirlink>
    8000410c:	02054463          	bltz	a0,80004134 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004110:	004a2603          	lw	a2,4(s4)
    80004114:	fb040593          	addi	a1,s0,-80
    80004118:	8526                	mv	a0,s1
    8000411a:	e89fe0ef          	jal	80002fa2 <dirlink>
    8000411e:	00054b63          	bltz	a0,80004134 <create+0x11c>
    dp->nlink++;  // for ".."
    80004122:	04a4d783          	lhu	a5,74(s1)
    80004126:	2785                	addiw	a5,a5,1
    80004128:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000412c:	8526                	mv	a0,s1
    8000412e:	f80fe0ef          	jal	800028ae <iupdate>
    80004132:	bf71                	j	800040ce <create+0xb6>
  ip->nlink = 0;
    80004134:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004138:	8552                	mv	a0,s4
    8000413a:	f74fe0ef          	jal	800028ae <iupdate>
  iunlockput(ip);
    8000413e:	8552                	mv	a0,s4
    80004140:	a2dfe0ef          	jal	80002b6c <iunlockput>
  iunlockput(dp);
    80004144:	8526                	mv	a0,s1
    80004146:	a27fe0ef          	jal	80002b6c <iunlockput>
  return 0;
    8000414a:	7a02                	ld	s4,32(sp)
    8000414c:	b725                	j	80004074 <create+0x5c>
    return 0;
    8000414e:	8aaa                	mv	s5,a0
    80004150:	b715                	j	80004074 <create+0x5c>

0000000080004152 <sys_dup>:
{
    80004152:	7179                	addi	sp,sp,-48
    80004154:	f406                	sd	ra,40(sp)
    80004156:	f022                	sd	s0,32(sp)
    80004158:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000415a:	fd840613          	addi	a2,s0,-40
    8000415e:	4581                	li	a1,0
    80004160:	4501                	li	a0,0
    80004162:	e21ff0ef          	jal	80003f82 <argfd>
    return -1;
    80004166:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004168:	02054363          	bltz	a0,8000418e <sys_dup+0x3c>
    8000416c:	ec26                	sd	s1,24(sp)
    8000416e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004170:	fd843903          	ld	s2,-40(s0)
    80004174:	854a                	mv	a0,s2
    80004176:	e65ff0ef          	jal	80003fda <fdalloc>
    8000417a:	84aa                	mv	s1,a0
    return -1;
    8000417c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000417e:	00054d63          	bltz	a0,80004198 <sys_dup+0x46>
  filedup(f);
    80004182:	854a                	mv	a0,s2
    80004184:	c48ff0ef          	jal	800035cc <filedup>
  return fd;
    80004188:	87a6                	mv	a5,s1
    8000418a:	64e2                	ld	s1,24(sp)
    8000418c:	6942                	ld	s2,16(sp)
}
    8000418e:	853e                	mv	a0,a5
    80004190:	70a2                	ld	ra,40(sp)
    80004192:	7402                	ld	s0,32(sp)
    80004194:	6145                	addi	sp,sp,48
    80004196:	8082                	ret
    80004198:	64e2                	ld	s1,24(sp)
    8000419a:	6942                	ld	s2,16(sp)
    8000419c:	bfcd                	j	8000418e <sys_dup+0x3c>

000000008000419e <sys_read>:
{
    8000419e:	7179                	addi	sp,sp,-48
    800041a0:	f406                	sd	ra,40(sp)
    800041a2:	f022                	sd	s0,32(sp)
    800041a4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800041a6:	fd840593          	addi	a1,s0,-40
    800041aa:	4505                	li	a0,1
    800041ac:	c49fd0ef          	jal	80001df4 <argaddr>
  argint(2, &n);
    800041b0:	fe440593          	addi	a1,s0,-28
    800041b4:	4509                	li	a0,2
    800041b6:	c23fd0ef          	jal	80001dd8 <argint>
  if(argfd(0, 0, &f) < 0)
    800041ba:	fe840613          	addi	a2,s0,-24
    800041be:	4581                	li	a1,0
    800041c0:	4501                	li	a0,0
    800041c2:	dc1ff0ef          	jal	80003f82 <argfd>
    800041c6:	87aa                	mv	a5,a0
    return -1;
    800041c8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800041ca:	0007ca63          	bltz	a5,800041de <sys_read+0x40>
  return fileread(f, p, n);
    800041ce:	fe442603          	lw	a2,-28(s0)
    800041d2:	fd843583          	ld	a1,-40(s0)
    800041d6:	fe843503          	ld	a0,-24(s0)
    800041da:	d58ff0ef          	jal	80003732 <fileread>
}
    800041de:	70a2                	ld	ra,40(sp)
    800041e0:	7402                	ld	s0,32(sp)
    800041e2:	6145                	addi	sp,sp,48
    800041e4:	8082                	ret

00000000800041e6 <sys_write>:
{
    800041e6:	7179                	addi	sp,sp,-48
    800041e8:	f406                	sd	ra,40(sp)
    800041ea:	f022                	sd	s0,32(sp)
    800041ec:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800041ee:	fd840593          	addi	a1,s0,-40
    800041f2:	4505                	li	a0,1
    800041f4:	c01fd0ef          	jal	80001df4 <argaddr>
  argint(2, &n);
    800041f8:	fe440593          	addi	a1,s0,-28
    800041fc:	4509                	li	a0,2
    800041fe:	bdbfd0ef          	jal	80001dd8 <argint>
  if(argfd(0, 0, &f) < 0)
    80004202:	fe840613          	addi	a2,s0,-24
    80004206:	4581                	li	a1,0
    80004208:	4501                	li	a0,0
    8000420a:	d79ff0ef          	jal	80003f82 <argfd>
    8000420e:	87aa                	mv	a5,a0
    return -1;
    80004210:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004212:	0007ca63          	bltz	a5,80004226 <sys_write+0x40>
  return filewrite(f, p, n);
    80004216:	fe442603          	lw	a2,-28(s0)
    8000421a:	fd843583          	ld	a1,-40(s0)
    8000421e:	fe843503          	ld	a0,-24(s0)
    80004222:	dceff0ef          	jal	800037f0 <filewrite>
}
    80004226:	70a2                	ld	ra,40(sp)
    80004228:	7402                	ld	s0,32(sp)
    8000422a:	6145                	addi	sp,sp,48
    8000422c:	8082                	ret

000000008000422e <sys_close>:
{
    8000422e:	1101                	addi	sp,sp,-32
    80004230:	ec06                	sd	ra,24(sp)
    80004232:	e822                	sd	s0,16(sp)
    80004234:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004236:	fe040613          	addi	a2,s0,-32
    8000423a:	fec40593          	addi	a1,s0,-20
    8000423e:	4501                	li	a0,0
    80004240:	d43ff0ef          	jal	80003f82 <argfd>
    return -1;
    80004244:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004246:	02054063          	bltz	a0,80004266 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000424a:	b73fc0ef          	jal	80000dbc <myproc>
    8000424e:	fec42783          	lw	a5,-20(s0)
    80004252:	07e9                	addi	a5,a5,26
    80004254:	078e                	slli	a5,a5,0x3
    80004256:	953e                	add	a0,a0,a5
    80004258:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000425c:	fe043503          	ld	a0,-32(s0)
    80004260:	bb2ff0ef          	jal	80003612 <fileclose>
  return 0;
    80004264:	4781                	li	a5,0
}
    80004266:	853e                	mv	a0,a5
    80004268:	60e2                	ld	ra,24(sp)
    8000426a:	6442                	ld	s0,16(sp)
    8000426c:	6105                	addi	sp,sp,32
    8000426e:	8082                	ret

0000000080004270 <sys_fstat>:
{
    80004270:	1101                	addi	sp,sp,-32
    80004272:	ec06                	sd	ra,24(sp)
    80004274:	e822                	sd	s0,16(sp)
    80004276:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004278:	fe040593          	addi	a1,s0,-32
    8000427c:	4505                	li	a0,1
    8000427e:	b77fd0ef          	jal	80001df4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004282:	fe840613          	addi	a2,s0,-24
    80004286:	4581                	li	a1,0
    80004288:	4501                	li	a0,0
    8000428a:	cf9ff0ef          	jal	80003f82 <argfd>
    8000428e:	87aa                	mv	a5,a0
    return -1;
    80004290:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004292:	0007c863          	bltz	a5,800042a2 <sys_fstat+0x32>
  return filestat(f, st);
    80004296:	fe043583          	ld	a1,-32(s0)
    8000429a:	fe843503          	ld	a0,-24(s0)
    8000429e:	c36ff0ef          	jal	800036d4 <filestat>
}
    800042a2:	60e2                	ld	ra,24(sp)
    800042a4:	6442                	ld	s0,16(sp)
    800042a6:	6105                	addi	sp,sp,32
    800042a8:	8082                	ret

00000000800042aa <sys_link>:
{
    800042aa:	7169                	addi	sp,sp,-304
    800042ac:	f606                	sd	ra,296(sp)
    800042ae:	f222                	sd	s0,288(sp)
    800042b0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800042b2:	08000613          	li	a2,128
    800042b6:	ed040593          	addi	a1,s0,-304
    800042ba:	4501                	li	a0,0
    800042bc:	b55fd0ef          	jal	80001e10 <argstr>
    return -1;
    800042c0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800042c2:	0c054e63          	bltz	a0,8000439e <sys_link+0xf4>
    800042c6:	08000613          	li	a2,128
    800042ca:	f5040593          	addi	a1,s0,-176
    800042ce:	4505                	li	a0,1
    800042d0:	b41fd0ef          	jal	80001e10 <argstr>
    return -1;
    800042d4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800042d6:	0c054463          	bltz	a0,8000439e <sys_link+0xf4>
    800042da:	ee26                	sd	s1,280(sp)
  begin_op();
    800042dc:	f1dfe0ef          	jal	800031f8 <begin_op>
  if((ip = namei(old)) == 0){
    800042e0:	ed040513          	addi	a0,s0,-304
    800042e4:	d59fe0ef          	jal	8000303c <namei>
    800042e8:	84aa                	mv	s1,a0
    800042ea:	c53d                	beqz	a0,80004358 <sys_link+0xae>
  ilock(ip);
    800042ec:	e76fe0ef          	jal	80002962 <ilock>
  if(ip->type == T_DIR){
    800042f0:	04449703          	lh	a4,68(s1)
    800042f4:	4785                	li	a5,1
    800042f6:	06f70663          	beq	a4,a5,80004362 <sys_link+0xb8>
    800042fa:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800042fc:	04a4d783          	lhu	a5,74(s1)
    80004300:	2785                	addiw	a5,a5,1
    80004302:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004306:	8526                	mv	a0,s1
    80004308:	da6fe0ef          	jal	800028ae <iupdate>
  iunlock(ip);
    8000430c:	8526                	mv	a0,s1
    8000430e:	f02fe0ef          	jal	80002a10 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004312:	fd040593          	addi	a1,s0,-48
    80004316:	f5040513          	addi	a0,s0,-176
    8000431a:	d3dfe0ef          	jal	80003056 <nameiparent>
    8000431e:	892a                	mv	s2,a0
    80004320:	cd21                	beqz	a0,80004378 <sys_link+0xce>
  ilock(dp);
    80004322:	e40fe0ef          	jal	80002962 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004326:	00092703          	lw	a4,0(s2)
    8000432a:	409c                	lw	a5,0(s1)
    8000432c:	04f71363          	bne	a4,a5,80004372 <sys_link+0xc8>
    80004330:	40d0                	lw	a2,4(s1)
    80004332:	fd040593          	addi	a1,s0,-48
    80004336:	854a                	mv	a0,s2
    80004338:	c6bfe0ef          	jal	80002fa2 <dirlink>
    8000433c:	02054b63          	bltz	a0,80004372 <sys_link+0xc8>
  iunlockput(dp);
    80004340:	854a                	mv	a0,s2
    80004342:	82bfe0ef          	jal	80002b6c <iunlockput>
  iput(ip);
    80004346:	8526                	mv	a0,s1
    80004348:	f9cfe0ef          	jal	80002ae4 <iput>
  end_op();
    8000434c:	f17fe0ef          	jal	80003262 <end_op>
  return 0;
    80004350:	4781                	li	a5,0
    80004352:	64f2                	ld	s1,280(sp)
    80004354:	6952                	ld	s2,272(sp)
    80004356:	a0a1                	j	8000439e <sys_link+0xf4>
    end_op();
    80004358:	f0bfe0ef          	jal	80003262 <end_op>
    return -1;
    8000435c:	57fd                	li	a5,-1
    8000435e:	64f2                	ld	s1,280(sp)
    80004360:	a83d                	j	8000439e <sys_link+0xf4>
    iunlockput(ip);
    80004362:	8526                	mv	a0,s1
    80004364:	809fe0ef          	jal	80002b6c <iunlockput>
    end_op();
    80004368:	efbfe0ef          	jal	80003262 <end_op>
    return -1;
    8000436c:	57fd                	li	a5,-1
    8000436e:	64f2                	ld	s1,280(sp)
    80004370:	a03d                	j	8000439e <sys_link+0xf4>
    iunlockput(dp);
    80004372:	854a                	mv	a0,s2
    80004374:	ff8fe0ef          	jal	80002b6c <iunlockput>
  ilock(ip);
    80004378:	8526                	mv	a0,s1
    8000437a:	de8fe0ef          	jal	80002962 <ilock>
  ip->nlink--;
    8000437e:	04a4d783          	lhu	a5,74(s1)
    80004382:	37fd                	addiw	a5,a5,-1
    80004384:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004388:	8526                	mv	a0,s1
    8000438a:	d24fe0ef          	jal	800028ae <iupdate>
  iunlockput(ip);
    8000438e:	8526                	mv	a0,s1
    80004390:	fdcfe0ef          	jal	80002b6c <iunlockput>
  end_op();
    80004394:	ecffe0ef          	jal	80003262 <end_op>
  return -1;
    80004398:	57fd                	li	a5,-1
    8000439a:	64f2                	ld	s1,280(sp)
    8000439c:	6952                	ld	s2,272(sp)
}
    8000439e:	853e                	mv	a0,a5
    800043a0:	70b2                	ld	ra,296(sp)
    800043a2:	7412                	ld	s0,288(sp)
    800043a4:	6155                	addi	sp,sp,304
    800043a6:	8082                	ret

00000000800043a8 <sys_unlink>:
{
    800043a8:	7151                	addi	sp,sp,-240
    800043aa:	f586                	sd	ra,232(sp)
    800043ac:	f1a2                	sd	s0,224(sp)
    800043ae:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800043b0:	08000613          	li	a2,128
    800043b4:	f3040593          	addi	a1,s0,-208
    800043b8:	4501                	li	a0,0
    800043ba:	a57fd0ef          	jal	80001e10 <argstr>
    800043be:	16054063          	bltz	a0,8000451e <sys_unlink+0x176>
    800043c2:	eda6                	sd	s1,216(sp)
  begin_op();
    800043c4:	e35fe0ef          	jal	800031f8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800043c8:	fb040593          	addi	a1,s0,-80
    800043cc:	f3040513          	addi	a0,s0,-208
    800043d0:	c87fe0ef          	jal	80003056 <nameiparent>
    800043d4:	84aa                	mv	s1,a0
    800043d6:	c945                	beqz	a0,80004486 <sys_unlink+0xde>
  ilock(dp);
    800043d8:	d8afe0ef          	jal	80002962 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800043dc:	00003597          	auipc	a1,0x3
    800043e0:	2ec58593          	addi	a1,a1,748 # 800076c8 <etext+0x6c8>
    800043e4:	fb040513          	addi	a0,s0,-80
    800043e8:	9d9fe0ef          	jal	80002dc0 <namecmp>
    800043ec:	10050e63          	beqz	a0,80004508 <sys_unlink+0x160>
    800043f0:	00003597          	auipc	a1,0x3
    800043f4:	2e058593          	addi	a1,a1,736 # 800076d0 <etext+0x6d0>
    800043f8:	fb040513          	addi	a0,s0,-80
    800043fc:	9c5fe0ef          	jal	80002dc0 <namecmp>
    80004400:	10050463          	beqz	a0,80004508 <sys_unlink+0x160>
    80004404:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004406:	f2c40613          	addi	a2,s0,-212
    8000440a:	fb040593          	addi	a1,s0,-80
    8000440e:	8526                	mv	a0,s1
    80004410:	9c7fe0ef          	jal	80002dd6 <dirlookup>
    80004414:	892a                	mv	s2,a0
    80004416:	0e050863          	beqz	a0,80004506 <sys_unlink+0x15e>
  ilock(ip);
    8000441a:	d48fe0ef          	jal	80002962 <ilock>
  if(ip->nlink < 1)
    8000441e:	04a91783          	lh	a5,74(s2)
    80004422:	06f05763          	blez	a5,80004490 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004426:	04491703          	lh	a4,68(s2)
    8000442a:	4785                	li	a5,1
    8000442c:	06f70963          	beq	a4,a5,8000449e <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004430:	4641                	li	a2,16
    80004432:	4581                	li	a1,0
    80004434:	fc040513          	addi	a0,s0,-64
    80004438:	d59fb0ef          	jal	80000190 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000443c:	4741                	li	a4,16
    8000443e:	f2c42683          	lw	a3,-212(s0)
    80004442:	fc040613          	addi	a2,s0,-64
    80004446:	4581                	li	a1,0
    80004448:	8526                	mv	a0,s1
    8000444a:	869fe0ef          	jal	80002cb2 <writei>
    8000444e:	47c1                	li	a5,16
    80004450:	08f51b63          	bne	a0,a5,800044e6 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004454:	04491703          	lh	a4,68(s2)
    80004458:	4785                	li	a5,1
    8000445a:	08f70d63          	beq	a4,a5,800044f4 <sys_unlink+0x14c>
  iunlockput(dp);
    8000445e:	8526                	mv	a0,s1
    80004460:	f0cfe0ef          	jal	80002b6c <iunlockput>
  ip->nlink--;
    80004464:	04a95783          	lhu	a5,74(s2)
    80004468:	37fd                	addiw	a5,a5,-1
    8000446a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000446e:	854a                	mv	a0,s2
    80004470:	c3efe0ef          	jal	800028ae <iupdate>
  iunlockput(ip);
    80004474:	854a                	mv	a0,s2
    80004476:	ef6fe0ef          	jal	80002b6c <iunlockput>
  end_op();
    8000447a:	de9fe0ef          	jal	80003262 <end_op>
  return 0;
    8000447e:	4501                	li	a0,0
    80004480:	64ee                	ld	s1,216(sp)
    80004482:	694e                	ld	s2,208(sp)
    80004484:	a849                	j	80004516 <sys_unlink+0x16e>
    end_op();
    80004486:	dddfe0ef          	jal	80003262 <end_op>
    return -1;
    8000448a:	557d                	li	a0,-1
    8000448c:	64ee                	ld	s1,216(sp)
    8000448e:	a061                	j	80004516 <sys_unlink+0x16e>
    80004490:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004492:	00003517          	auipc	a0,0x3
    80004496:	24650513          	addi	a0,a0,582 # 800076d8 <etext+0x6d8>
    8000449a:	278010ef          	jal	80005712 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000449e:	04c92703          	lw	a4,76(s2)
    800044a2:	02000793          	li	a5,32
    800044a6:	f8e7f5e3          	bgeu	a5,a4,80004430 <sys_unlink+0x88>
    800044aa:	e5ce                	sd	s3,200(sp)
    800044ac:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044b0:	4741                	li	a4,16
    800044b2:	86ce                	mv	a3,s3
    800044b4:	f1840613          	addi	a2,s0,-232
    800044b8:	4581                	li	a1,0
    800044ba:	854a                	mv	a0,s2
    800044bc:	efafe0ef          	jal	80002bb6 <readi>
    800044c0:	47c1                	li	a5,16
    800044c2:	00f51c63          	bne	a0,a5,800044da <sys_unlink+0x132>
    if(de.inum != 0)
    800044c6:	f1845783          	lhu	a5,-232(s0)
    800044ca:	efa1                	bnez	a5,80004522 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800044cc:	29c1                	addiw	s3,s3,16
    800044ce:	04c92783          	lw	a5,76(s2)
    800044d2:	fcf9efe3          	bltu	s3,a5,800044b0 <sys_unlink+0x108>
    800044d6:	69ae                	ld	s3,200(sp)
    800044d8:	bfa1                	j	80004430 <sys_unlink+0x88>
      panic("isdirempty: readi");
    800044da:	00003517          	auipc	a0,0x3
    800044de:	21650513          	addi	a0,a0,534 # 800076f0 <etext+0x6f0>
    800044e2:	230010ef          	jal	80005712 <panic>
    800044e6:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800044e8:	00003517          	auipc	a0,0x3
    800044ec:	22050513          	addi	a0,a0,544 # 80007708 <etext+0x708>
    800044f0:	222010ef          	jal	80005712 <panic>
    dp->nlink--;
    800044f4:	04a4d783          	lhu	a5,74(s1)
    800044f8:	37fd                	addiw	a5,a5,-1
    800044fa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800044fe:	8526                	mv	a0,s1
    80004500:	baefe0ef          	jal	800028ae <iupdate>
    80004504:	bfa9                	j	8000445e <sys_unlink+0xb6>
    80004506:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004508:	8526                	mv	a0,s1
    8000450a:	e62fe0ef          	jal	80002b6c <iunlockput>
  end_op();
    8000450e:	d55fe0ef          	jal	80003262 <end_op>
  return -1;
    80004512:	557d                	li	a0,-1
    80004514:	64ee                	ld	s1,216(sp)
}
    80004516:	70ae                	ld	ra,232(sp)
    80004518:	740e                	ld	s0,224(sp)
    8000451a:	616d                	addi	sp,sp,240
    8000451c:	8082                	ret
    return -1;
    8000451e:	557d                	li	a0,-1
    80004520:	bfdd                	j	80004516 <sys_unlink+0x16e>
    iunlockput(ip);
    80004522:	854a                	mv	a0,s2
    80004524:	e48fe0ef          	jal	80002b6c <iunlockput>
    goto bad;
    80004528:	694e                	ld	s2,208(sp)
    8000452a:	69ae                	ld	s3,200(sp)
    8000452c:	bff1                	j	80004508 <sys_unlink+0x160>

000000008000452e <sys_open>:

uint64
sys_open(void)
{
    8000452e:	7131                	addi	sp,sp,-192
    80004530:	fd06                	sd	ra,184(sp)
    80004532:	f922                	sd	s0,176(sp)
    80004534:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004536:	f4c40593          	addi	a1,s0,-180
    8000453a:	4505                	li	a0,1
    8000453c:	89dfd0ef          	jal	80001dd8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004540:	08000613          	li	a2,128
    80004544:	f5040593          	addi	a1,s0,-176
    80004548:	4501                	li	a0,0
    8000454a:	8c7fd0ef          	jal	80001e10 <argstr>
    8000454e:	87aa                	mv	a5,a0
    return -1;
    80004550:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004552:	0a07c263          	bltz	a5,800045f6 <sys_open+0xc8>
    80004556:	f526                	sd	s1,168(sp)

  begin_op();
    80004558:	ca1fe0ef          	jal	800031f8 <begin_op>

  if(omode & O_CREATE){
    8000455c:	f4c42783          	lw	a5,-180(s0)
    80004560:	2007f793          	andi	a5,a5,512
    80004564:	c3d5                	beqz	a5,80004608 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004566:	4681                	li	a3,0
    80004568:	4601                	li	a2,0
    8000456a:	4589                	li	a1,2
    8000456c:	f5040513          	addi	a0,s0,-176
    80004570:	aa9ff0ef          	jal	80004018 <create>
    80004574:	84aa                	mv	s1,a0
    if(ip == 0){
    80004576:	c541                	beqz	a0,800045fe <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004578:	04449703          	lh	a4,68(s1)
    8000457c:	478d                	li	a5,3
    8000457e:	00f71763          	bne	a4,a5,8000458c <sys_open+0x5e>
    80004582:	0464d703          	lhu	a4,70(s1)
    80004586:	47a5                	li	a5,9
    80004588:	0ae7ed63          	bltu	a5,a4,80004642 <sys_open+0x114>
    8000458c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000458e:	fe1fe0ef          	jal	8000356e <filealloc>
    80004592:	892a                	mv	s2,a0
    80004594:	c179                	beqz	a0,8000465a <sys_open+0x12c>
    80004596:	ed4e                	sd	s3,152(sp)
    80004598:	a43ff0ef          	jal	80003fda <fdalloc>
    8000459c:	89aa                	mv	s3,a0
    8000459e:	0a054a63          	bltz	a0,80004652 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800045a2:	04449703          	lh	a4,68(s1)
    800045a6:	478d                	li	a5,3
    800045a8:	0cf70263          	beq	a4,a5,8000466c <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800045ac:	4789                	li	a5,2
    800045ae:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800045b2:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800045b6:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800045ba:	f4c42783          	lw	a5,-180(s0)
    800045be:	0017c713          	xori	a4,a5,1
    800045c2:	8b05                	andi	a4,a4,1
    800045c4:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800045c8:	0037f713          	andi	a4,a5,3
    800045cc:	00e03733          	snez	a4,a4
    800045d0:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800045d4:	4007f793          	andi	a5,a5,1024
    800045d8:	c791                	beqz	a5,800045e4 <sys_open+0xb6>
    800045da:	04449703          	lh	a4,68(s1)
    800045de:	4789                	li	a5,2
    800045e0:	08f70d63          	beq	a4,a5,8000467a <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800045e4:	8526                	mv	a0,s1
    800045e6:	c2afe0ef          	jal	80002a10 <iunlock>
  end_op();
    800045ea:	c79fe0ef          	jal	80003262 <end_op>

  return fd;
    800045ee:	854e                	mv	a0,s3
    800045f0:	74aa                	ld	s1,168(sp)
    800045f2:	790a                	ld	s2,160(sp)
    800045f4:	69ea                	ld	s3,152(sp)
}
    800045f6:	70ea                	ld	ra,184(sp)
    800045f8:	744a                	ld	s0,176(sp)
    800045fa:	6129                	addi	sp,sp,192
    800045fc:	8082                	ret
      end_op();
    800045fe:	c65fe0ef          	jal	80003262 <end_op>
      return -1;
    80004602:	557d                	li	a0,-1
    80004604:	74aa                	ld	s1,168(sp)
    80004606:	bfc5                	j	800045f6 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004608:	f5040513          	addi	a0,s0,-176
    8000460c:	a31fe0ef          	jal	8000303c <namei>
    80004610:	84aa                	mv	s1,a0
    80004612:	c11d                	beqz	a0,80004638 <sys_open+0x10a>
    ilock(ip);
    80004614:	b4efe0ef          	jal	80002962 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004618:	04449703          	lh	a4,68(s1)
    8000461c:	4785                	li	a5,1
    8000461e:	f4f71de3          	bne	a4,a5,80004578 <sys_open+0x4a>
    80004622:	f4c42783          	lw	a5,-180(s0)
    80004626:	d3bd                	beqz	a5,8000458c <sys_open+0x5e>
      iunlockput(ip);
    80004628:	8526                	mv	a0,s1
    8000462a:	d42fe0ef          	jal	80002b6c <iunlockput>
      end_op();
    8000462e:	c35fe0ef          	jal	80003262 <end_op>
      return -1;
    80004632:	557d                	li	a0,-1
    80004634:	74aa                	ld	s1,168(sp)
    80004636:	b7c1                	j	800045f6 <sys_open+0xc8>
      end_op();
    80004638:	c2bfe0ef          	jal	80003262 <end_op>
      return -1;
    8000463c:	557d                	li	a0,-1
    8000463e:	74aa                	ld	s1,168(sp)
    80004640:	bf5d                	j	800045f6 <sys_open+0xc8>
    iunlockput(ip);
    80004642:	8526                	mv	a0,s1
    80004644:	d28fe0ef          	jal	80002b6c <iunlockput>
    end_op();
    80004648:	c1bfe0ef          	jal	80003262 <end_op>
    return -1;
    8000464c:	557d                	li	a0,-1
    8000464e:	74aa                	ld	s1,168(sp)
    80004650:	b75d                	j	800045f6 <sys_open+0xc8>
      fileclose(f);
    80004652:	854a                	mv	a0,s2
    80004654:	fbffe0ef          	jal	80003612 <fileclose>
    80004658:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000465a:	8526                	mv	a0,s1
    8000465c:	d10fe0ef          	jal	80002b6c <iunlockput>
    end_op();
    80004660:	c03fe0ef          	jal	80003262 <end_op>
    return -1;
    80004664:	557d                	li	a0,-1
    80004666:	74aa                	ld	s1,168(sp)
    80004668:	790a                	ld	s2,160(sp)
    8000466a:	b771                	j	800045f6 <sys_open+0xc8>
    f->type = FD_DEVICE;
    8000466c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004670:	04649783          	lh	a5,70(s1)
    80004674:	02f91223          	sh	a5,36(s2)
    80004678:	bf3d                	j	800045b6 <sys_open+0x88>
    itrunc(ip);
    8000467a:	8526                	mv	a0,s1
    8000467c:	bd4fe0ef          	jal	80002a50 <itrunc>
    80004680:	b795                	j	800045e4 <sys_open+0xb6>

0000000080004682 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004682:	7175                	addi	sp,sp,-144
    80004684:	e506                	sd	ra,136(sp)
    80004686:	e122                	sd	s0,128(sp)
    80004688:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000468a:	b6ffe0ef          	jal	800031f8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000468e:	08000613          	li	a2,128
    80004692:	f7040593          	addi	a1,s0,-144
    80004696:	4501                	li	a0,0
    80004698:	f78fd0ef          	jal	80001e10 <argstr>
    8000469c:	02054363          	bltz	a0,800046c2 <sys_mkdir+0x40>
    800046a0:	4681                	li	a3,0
    800046a2:	4601                	li	a2,0
    800046a4:	4585                	li	a1,1
    800046a6:	f7040513          	addi	a0,s0,-144
    800046aa:	96fff0ef          	jal	80004018 <create>
    800046ae:	c911                	beqz	a0,800046c2 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800046b0:	cbcfe0ef          	jal	80002b6c <iunlockput>
  end_op();
    800046b4:	baffe0ef          	jal	80003262 <end_op>
  return 0;
    800046b8:	4501                	li	a0,0
}
    800046ba:	60aa                	ld	ra,136(sp)
    800046bc:	640a                	ld	s0,128(sp)
    800046be:	6149                	addi	sp,sp,144
    800046c0:	8082                	ret
    end_op();
    800046c2:	ba1fe0ef          	jal	80003262 <end_op>
    return -1;
    800046c6:	557d                	li	a0,-1
    800046c8:	bfcd                	j	800046ba <sys_mkdir+0x38>

00000000800046ca <sys_mknod>:

uint64
sys_mknod(void)
{
    800046ca:	7135                	addi	sp,sp,-160
    800046cc:	ed06                	sd	ra,152(sp)
    800046ce:	e922                	sd	s0,144(sp)
    800046d0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800046d2:	b27fe0ef          	jal	800031f8 <begin_op>
  argint(1, &major);
    800046d6:	f6c40593          	addi	a1,s0,-148
    800046da:	4505                	li	a0,1
    800046dc:	efcfd0ef          	jal	80001dd8 <argint>
  argint(2, &minor);
    800046e0:	f6840593          	addi	a1,s0,-152
    800046e4:	4509                	li	a0,2
    800046e6:	ef2fd0ef          	jal	80001dd8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800046ea:	08000613          	li	a2,128
    800046ee:	f7040593          	addi	a1,s0,-144
    800046f2:	4501                	li	a0,0
    800046f4:	f1cfd0ef          	jal	80001e10 <argstr>
    800046f8:	02054563          	bltz	a0,80004722 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800046fc:	f6841683          	lh	a3,-152(s0)
    80004700:	f6c41603          	lh	a2,-148(s0)
    80004704:	458d                	li	a1,3
    80004706:	f7040513          	addi	a0,s0,-144
    8000470a:	90fff0ef          	jal	80004018 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000470e:	c911                	beqz	a0,80004722 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004710:	c5cfe0ef          	jal	80002b6c <iunlockput>
  end_op();
    80004714:	b4ffe0ef          	jal	80003262 <end_op>
  return 0;
    80004718:	4501                	li	a0,0
}
    8000471a:	60ea                	ld	ra,152(sp)
    8000471c:	644a                	ld	s0,144(sp)
    8000471e:	610d                	addi	sp,sp,160
    80004720:	8082                	ret
    end_op();
    80004722:	b41fe0ef          	jal	80003262 <end_op>
    return -1;
    80004726:	557d                	li	a0,-1
    80004728:	bfcd                	j	8000471a <sys_mknod+0x50>

000000008000472a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000472a:	7135                	addi	sp,sp,-160
    8000472c:	ed06                	sd	ra,152(sp)
    8000472e:	e922                	sd	s0,144(sp)
    80004730:	e14a                	sd	s2,128(sp)
    80004732:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004734:	e88fc0ef          	jal	80000dbc <myproc>
    80004738:	892a                	mv	s2,a0
  
  begin_op();
    8000473a:	abffe0ef          	jal	800031f8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000473e:	08000613          	li	a2,128
    80004742:	f6040593          	addi	a1,s0,-160
    80004746:	4501                	li	a0,0
    80004748:	ec8fd0ef          	jal	80001e10 <argstr>
    8000474c:	04054363          	bltz	a0,80004792 <sys_chdir+0x68>
    80004750:	e526                	sd	s1,136(sp)
    80004752:	f6040513          	addi	a0,s0,-160
    80004756:	8e7fe0ef          	jal	8000303c <namei>
    8000475a:	84aa                	mv	s1,a0
    8000475c:	c915                	beqz	a0,80004790 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000475e:	a04fe0ef          	jal	80002962 <ilock>
  if(ip->type != T_DIR){
    80004762:	04449703          	lh	a4,68(s1)
    80004766:	4785                	li	a5,1
    80004768:	02f71963          	bne	a4,a5,8000479a <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000476c:	8526                	mv	a0,s1
    8000476e:	aa2fe0ef          	jal	80002a10 <iunlock>
  iput(p->cwd);
    80004772:	15093503          	ld	a0,336(s2)
    80004776:	b6efe0ef          	jal	80002ae4 <iput>
  end_op();
    8000477a:	ae9fe0ef          	jal	80003262 <end_op>
  p->cwd = ip;
    8000477e:	14993823          	sd	s1,336(s2)
  return 0;
    80004782:	4501                	li	a0,0
    80004784:	64aa                	ld	s1,136(sp)
}
    80004786:	60ea                	ld	ra,152(sp)
    80004788:	644a                	ld	s0,144(sp)
    8000478a:	690a                	ld	s2,128(sp)
    8000478c:	610d                	addi	sp,sp,160
    8000478e:	8082                	ret
    80004790:	64aa                	ld	s1,136(sp)
    end_op();
    80004792:	ad1fe0ef          	jal	80003262 <end_op>
    return -1;
    80004796:	557d                	li	a0,-1
    80004798:	b7fd                	j	80004786 <sys_chdir+0x5c>
    iunlockput(ip);
    8000479a:	8526                	mv	a0,s1
    8000479c:	bd0fe0ef          	jal	80002b6c <iunlockput>
    end_op();
    800047a0:	ac3fe0ef          	jal	80003262 <end_op>
    return -1;
    800047a4:	557d                	li	a0,-1
    800047a6:	64aa                	ld	s1,136(sp)
    800047a8:	bff9                	j	80004786 <sys_chdir+0x5c>

00000000800047aa <sys_exec>:

uint64
sys_exec(void)
{
    800047aa:	7121                	addi	sp,sp,-448
    800047ac:	ff06                	sd	ra,440(sp)
    800047ae:	fb22                	sd	s0,432(sp)
    800047b0:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800047b2:	e4840593          	addi	a1,s0,-440
    800047b6:	4505                	li	a0,1
    800047b8:	e3cfd0ef          	jal	80001df4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800047bc:	08000613          	li	a2,128
    800047c0:	f5040593          	addi	a1,s0,-176
    800047c4:	4501                	li	a0,0
    800047c6:	e4afd0ef          	jal	80001e10 <argstr>
    800047ca:	87aa                	mv	a5,a0
    return -1;
    800047cc:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800047ce:	0c07c463          	bltz	a5,80004896 <sys_exec+0xec>
    800047d2:	f726                	sd	s1,424(sp)
    800047d4:	f34a                	sd	s2,416(sp)
    800047d6:	ef4e                	sd	s3,408(sp)
    800047d8:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800047da:	10000613          	li	a2,256
    800047de:	4581                	li	a1,0
    800047e0:	e5040513          	addi	a0,s0,-432
    800047e4:	9adfb0ef          	jal	80000190 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800047e8:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800047ec:	89a6                	mv	s3,s1
    800047ee:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800047f0:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800047f4:	00391513          	slli	a0,s2,0x3
    800047f8:	e4040593          	addi	a1,s0,-448
    800047fc:	e4843783          	ld	a5,-440(s0)
    80004800:	953e                	add	a0,a0,a5
    80004802:	d4cfd0ef          	jal	80001d4e <fetchaddr>
    80004806:	02054663          	bltz	a0,80004832 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    8000480a:	e4043783          	ld	a5,-448(s0)
    8000480e:	c3a9                	beqz	a5,80004850 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004810:	8effb0ef          	jal	800000fe <kalloc>
    80004814:	85aa                	mv	a1,a0
    80004816:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000481a:	cd01                	beqz	a0,80004832 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000481c:	6605                	lui	a2,0x1
    8000481e:	e4043503          	ld	a0,-448(s0)
    80004822:	d76fd0ef          	jal	80001d98 <fetchstr>
    80004826:	00054663          	bltz	a0,80004832 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000482a:	0905                	addi	s2,s2,1
    8000482c:	09a1                	addi	s3,s3,8
    8000482e:	fd4913e3          	bne	s2,s4,800047f4 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004832:	f5040913          	addi	s2,s0,-176
    80004836:	6088                	ld	a0,0(s1)
    80004838:	c931                	beqz	a0,8000488c <sys_exec+0xe2>
    kfree(argv[i]);
    8000483a:	fe2fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000483e:	04a1                	addi	s1,s1,8
    80004840:	ff249be3          	bne	s1,s2,80004836 <sys_exec+0x8c>
  return -1;
    80004844:	557d                	li	a0,-1
    80004846:	74ba                	ld	s1,424(sp)
    80004848:	791a                	ld	s2,416(sp)
    8000484a:	69fa                	ld	s3,408(sp)
    8000484c:	6a5a                	ld	s4,400(sp)
    8000484e:	a0a1                	j	80004896 <sys_exec+0xec>
      argv[i] = 0;
    80004850:	0009079b          	sext.w	a5,s2
    80004854:	078e                	slli	a5,a5,0x3
    80004856:	fd078793          	addi	a5,a5,-48
    8000485a:	97a2                	add	a5,a5,s0
    8000485c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004860:	e5040593          	addi	a1,s0,-432
    80004864:	f5040513          	addi	a0,s0,-176
    80004868:	ba8ff0ef          	jal	80003c10 <exec>
    8000486c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000486e:	f5040993          	addi	s3,s0,-176
    80004872:	6088                	ld	a0,0(s1)
    80004874:	c511                	beqz	a0,80004880 <sys_exec+0xd6>
    kfree(argv[i]);
    80004876:	fa6fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000487a:	04a1                	addi	s1,s1,8
    8000487c:	ff349be3          	bne	s1,s3,80004872 <sys_exec+0xc8>
  return ret;
    80004880:	854a                	mv	a0,s2
    80004882:	74ba                	ld	s1,424(sp)
    80004884:	791a                	ld	s2,416(sp)
    80004886:	69fa                	ld	s3,408(sp)
    80004888:	6a5a                	ld	s4,400(sp)
    8000488a:	a031                	j	80004896 <sys_exec+0xec>
  return -1;
    8000488c:	557d                	li	a0,-1
    8000488e:	74ba                	ld	s1,424(sp)
    80004890:	791a                	ld	s2,416(sp)
    80004892:	69fa                	ld	s3,408(sp)
    80004894:	6a5a                	ld	s4,400(sp)
}
    80004896:	70fa                	ld	ra,440(sp)
    80004898:	745a                	ld	s0,432(sp)
    8000489a:	6139                	addi	sp,sp,448
    8000489c:	8082                	ret

000000008000489e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000489e:	7139                	addi	sp,sp,-64
    800048a0:	fc06                	sd	ra,56(sp)
    800048a2:	f822                	sd	s0,48(sp)
    800048a4:	f426                	sd	s1,40(sp)
    800048a6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800048a8:	d14fc0ef          	jal	80000dbc <myproc>
    800048ac:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800048ae:	fd840593          	addi	a1,s0,-40
    800048b2:	4501                	li	a0,0
    800048b4:	d40fd0ef          	jal	80001df4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800048b8:	fc840593          	addi	a1,s0,-56
    800048bc:	fd040513          	addi	a0,s0,-48
    800048c0:	85cff0ef          	jal	8000391c <pipealloc>
    return -1;
    800048c4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800048c6:	0a054463          	bltz	a0,8000496e <sys_pipe+0xd0>
  fd0 = -1;
    800048ca:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800048ce:	fd043503          	ld	a0,-48(s0)
    800048d2:	f08ff0ef          	jal	80003fda <fdalloc>
    800048d6:	fca42223          	sw	a0,-60(s0)
    800048da:	08054163          	bltz	a0,8000495c <sys_pipe+0xbe>
    800048de:	fc843503          	ld	a0,-56(s0)
    800048e2:	ef8ff0ef          	jal	80003fda <fdalloc>
    800048e6:	fca42023          	sw	a0,-64(s0)
    800048ea:	06054063          	bltz	a0,8000494a <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800048ee:	4691                	li	a3,4
    800048f0:	fc440613          	addi	a2,s0,-60
    800048f4:	fd843583          	ld	a1,-40(s0)
    800048f8:	68a8                	ld	a0,80(s1)
    800048fa:	920fc0ef          	jal	80000a1a <copyout>
    800048fe:	00054e63          	bltz	a0,8000491a <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004902:	4691                	li	a3,4
    80004904:	fc040613          	addi	a2,s0,-64
    80004908:	fd843583          	ld	a1,-40(s0)
    8000490c:	0591                	addi	a1,a1,4
    8000490e:	68a8                	ld	a0,80(s1)
    80004910:	90afc0ef          	jal	80000a1a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004914:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004916:	04055c63          	bgez	a0,8000496e <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000491a:	fc442783          	lw	a5,-60(s0)
    8000491e:	07e9                	addi	a5,a5,26
    80004920:	078e                	slli	a5,a5,0x3
    80004922:	97a6                	add	a5,a5,s1
    80004924:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004928:	fc042783          	lw	a5,-64(s0)
    8000492c:	07e9                	addi	a5,a5,26
    8000492e:	078e                	slli	a5,a5,0x3
    80004930:	94be                	add	s1,s1,a5
    80004932:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004936:	fd043503          	ld	a0,-48(s0)
    8000493a:	cd9fe0ef          	jal	80003612 <fileclose>
    fileclose(wf);
    8000493e:	fc843503          	ld	a0,-56(s0)
    80004942:	cd1fe0ef          	jal	80003612 <fileclose>
    return -1;
    80004946:	57fd                	li	a5,-1
    80004948:	a01d                	j	8000496e <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000494a:	fc442783          	lw	a5,-60(s0)
    8000494e:	0007c763          	bltz	a5,8000495c <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004952:	07e9                	addi	a5,a5,26
    80004954:	078e                	slli	a5,a5,0x3
    80004956:	97a6                	add	a5,a5,s1
    80004958:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000495c:	fd043503          	ld	a0,-48(s0)
    80004960:	cb3fe0ef          	jal	80003612 <fileclose>
    fileclose(wf);
    80004964:	fc843503          	ld	a0,-56(s0)
    80004968:	cabfe0ef          	jal	80003612 <fileclose>
    return -1;
    8000496c:	57fd                	li	a5,-1
}
    8000496e:	853e                	mv	a0,a5
    80004970:	70e2                	ld	ra,56(sp)
    80004972:	7442                	ld	s0,48(sp)
    80004974:	74a2                	ld	s1,40(sp)
    80004976:	6121                	addi	sp,sp,64
    80004978:	8082                	ret
    8000497a:	0000                	unimp
    8000497c:	0000                	unimp
	...

0000000080004980 <kernelvec>:
    80004980:	7111                	addi	sp,sp,-256
    80004982:	e006                	sd	ra,0(sp)
    80004984:	e40a                	sd	sp,8(sp)
    80004986:	e80e                	sd	gp,16(sp)
    80004988:	ec12                	sd	tp,24(sp)
    8000498a:	f016                	sd	t0,32(sp)
    8000498c:	f41a                	sd	t1,40(sp)
    8000498e:	f81e                	sd	t2,48(sp)
    80004990:	e4aa                	sd	a0,72(sp)
    80004992:	e8ae                	sd	a1,80(sp)
    80004994:	ecb2                	sd	a2,88(sp)
    80004996:	f0b6                	sd	a3,96(sp)
    80004998:	f4ba                	sd	a4,104(sp)
    8000499a:	f8be                	sd	a5,112(sp)
    8000499c:	fcc2                	sd	a6,120(sp)
    8000499e:	e146                	sd	a7,128(sp)
    800049a0:	edf2                	sd	t3,216(sp)
    800049a2:	f1f6                	sd	t4,224(sp)
    800049a4:	f5fa                	sd	t5,232(sp)
    800049a6:	f9fe                	sd	t6,240(sp)
    800049a8:	ab6fd0ef          	jal	80001c5e <kerneltrap>
    800049ac:	6082                	ld	ra,0(sp)
    800049ae:	6122                	ld	sp,8(sp)
    800049b0:	61c2                	ld	gp,16(sp)
    800049b2:	7282                	ld	t0,32(sp)
    800049b4:	7322                	ld	t1,40(sp)
    800049b6:	73c2                	ld	t2,48(sp)
    800049b8:	6526                	ld	a0,72(sp)
    800049ba:	65c6                	ld	a1,80(sp)
    800049bc:	6666                	ld	a2,88(sp)
    800049be:	7686                	ld	a3,96(sp)
    800049c0:	7726                	ld	a4,104(sp)
    800049c2:	77c6                	ld	a5,112(sp)
    800049c4:	7866                	ld	a6,120(sp)
    800049c6:	688a                	ld	a7,128(sp)
    800049c8:	6e6e                	ld	t3,216(sp)
    800049ca:	7e8e                	ld	t4,224(sp)
    800049cc:	7f2e                	ld	t5,232(sp)
    800049ce:	7fce                	ld	t6,240(sp)
    800049d0:	6111                	addi	sp,sp,256
    800049d2:	10200073          	sret
	...

00000000800049de <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800049de:	1141                	addi	sp,sp,-16
    800049e0:	e422                	sd	s0,8(sp)
    800049e2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800049e4:	0c0007b7          	lui	a5,0xc000
    800049e8:	4705                	li	a4,1
    800049ea:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800049ec:	0c0007b7          	lui	a5,0xc000
    800049f0:	c3d8                	sw	a4,4(a5)
}
    800049f2:	6422                	ld	s0,8(sp)
    800049f4:	0141                	addi	sp,sp,16
    800049f6:	8082                	ret

00000000800049f8 <plicinithart>:

void
plicinithart(void)
{
    800049f8:	1141                	addi	sp,sp,-16
    800049fa:	e406                	sd	ra,8(sp)
    800049fc:	e022                	sd	s0,0(sp)
    800049fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004a00:	b90fc0ef          	jal	80000d90 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004a04:	0085171b          	slliw	a4,a0,0x8
    80004a08:	0c0027b7          	lui	a5,0xc002
    80004a0c:	97ba                	add	a5,a5,a4
    80004a0e:	40200713          	li	a4,1026
    80004a12:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004a16:	00d5151b          	slliw	a0,a0,0xd
    80004a1a:	0c2017b7          	lui	a5,0xc201
    80004a1e:	97aa                	add	a5,a5,a0
    80004a20:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004a24:	60a2                	ld	ra,8(sp)
    80004a26:	6402                	ld	s0,0(sp)
    80004a28:	0141                	addi	sp,sp,16
    80004a2a:	8082                	ret

0000000080004a2c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004a2c:	1141                	addi	sp,sp,-16
    80004a2e:	e406                	sd	ra,8(sp)
    80004a30:	e022                	sd	s0,0(sp)
    80004a32:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004a34:	b5cfc0ef          	jal	80000d90 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004a38:	00d5151b          	slliw	a0,a0,0xd
    80004a3c:	0c2017b7          	lui	a5,0xc201
    80004a40:	97aa                	add	a5,a5,a0
  return irq;
}
    80004a42:	43c8                	lw	a0,4(a5)
    80004a44:	60a2                	ld	ra,8(sp)
    80004a46:	6402                	ld	s0,0(sp)
    80004a48:	0141                	addi	sp,sp,16
    80004a4a:	8082                	ret

0000000080004a4c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004a4c:	1101                	addi	sp,sp,-32
    80004a4e:	ec06                	sd	ra,24(sp)
    80004a50:	e822                	sd	s0,16(sp)
    80004a52:	e426                	sd	s1,8(sp)
    80004a54:	1000                	addi	s0,sp,32
    80004a56:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004a58:	b38fc0ef          	jal	80000d90 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004a5c:	00d5151b          	slliw	a0,a0,0xd
    80004a60:	0c2017b7          	lui	a5,0xc201
    80004a64:	97aa                	add	a5,a5,a0
    80004a66:	c3c4                	sw	s1,4(a5)
}
    80004a68:	60e2                	ld	ra,24(sp)
    80004a6a:	6442                	ld	s0,16(sp)
    80004a6c:	64a2                	ld	s1,8(sp)
    80004a6e:	6105                	addi	sp,sp,32
    80004a70:	8082                	ret

0000000080004a72 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004a72:	1141                	addi	sp,sp,-16
    80004a74:	e406                	sd	ra,8(sp)
    80004a76:	e022                	sd	s0,0(sp)
    80004a78:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004a7a:	479d                	li	a5,7
    80004a7c:	04a7ca63          	blt	a5,a0,80004ad0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004a80:	00017797          	auipc	a5,0x17
    80004a84:	e0878793          	addi	a5,a5,-504 # 8001b888 <disk>
    80004a88:	97aa                	add	a5,a5,a0
    80004a8a:	0187c783          	lbu	a5,24(a5)
    80004a8e:	e7b9                	bnez	a5,80004adc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004a90:	00451693          	slli	a3,a0,0x4
    80004a94:	00017797          	auipc	a5,0x17
    80004a98:	df478793          	addi	a5,a5,-524 # 8001b888 <disk>
    80004a9c:	6398                	ld	a4,0(a5)
    80004a9e:	9736                	add	a4,a4,a3
    80004aa0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004aa4:	6398                	ld	a4,0(a5)
    80004aa6:	9736                	add	a4,a4,a3
    80004aa8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004aac:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004ab0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004ab4:	97aa                	add	a5,a5,a0
    80004ab6:	4705                	li	a4,1
    80004ab8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004abc:	00017517          	auipc	a0,0x17
    80004ac0:	de450513          	addi	a0,a0,-540 # 8001b8a0 <disk+0x18>
    80004ac4:	91bfc0ef          	jal	800013de <wakeup>
}
    80004ac8:	60a2                	ld	ra,8(sp)
    80004aca:	6402                	ld	s0,0(sp)
    80004acc:	0141                	addi	sp,sp,16
    80004ace:	8082                	ret
    panic("free_desc 1");
    80004ad0:	00003517          	auipc	a0,0x3
    80004ad4:	c4850513          	addi	a0,a0,-952 # 80007718 <etext+0x718>
    80004ad8:	43b000ef          	jal	80005712 <panic>
    panic("free_desc 2");
    80004adc:	00003517          	auipc	a0,0x3
    80004ae0:	c4c50513          	addi	a0,a0,-948 # 80007728 <etext+0x728>
    80004ae4:	42f000ef          	jal	80005712 <panic>

0000000080004ae8 <virtio_disk_init>:
{
    80004ae8:	1101                	addi	sp,sp,-32
    80004aea:	ec06                	sd	ra,24(sp)
    80004aec:	e822                	sd	s0,16(sp)
    80004aee:	e426                	sd	s1,8(sp)
    80004af0:	e04a                	sd	s2,0(sp)
    80004af2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004af4:	00003597          	auipc	a1,0x3
    80004af8:	c4458593          	addi	a1,a1,-956 # 80007738 <etext+0x738>
    80004afc:	00017517          	auipc	a0,0x17
    80004b00:	eb450513          	addi	a0,a0,-332 # 8001b9b0 <disk+0x128>
    80004b04:	6bd000ef          	jal	800059c0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004b08:	100017b7          	lui	a5,0x10001
    80004b0c:	4398                	lw	a4,0(a5)
    80004b0e:	2701                	sext.w	a4,a4
    80004b10:	747277b7          	lui	a5,0x74727
    80004b14:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004b18:	18f71063          	bne	a4,a5,80004c98 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004b1c:	100017b7          	lui	a5,0x10001
    80004b20:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004b22:	439c                	lw	a5,0(a5)
    80004b24:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004b26:	4709                	li	a4,2
    80004b28:	16e79863          	bne	a5,a4,80004c98 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004b2c:	100017b7          	lui	a5,0x10001
    80004b30:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004b32:	439c                	lw	a5,0(a5)
    80004b34:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004b36:	16e79163          	bne	a5,a4,80004c98 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004b3a:	100017b7          	lui	a5,0x10001
    80004b3e:	47d8                	lw	a4,12(a5)
    80004b40:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004b42:	554d47b7          	lui	a5,0x554d4
    80004b46:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004b4a:	14f71763          	bne	a4,a5,80004c98 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b4e:	100017b7          	lui	a5,0x10001
    80004b52:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b56:	4705                	li	a4,1
    80004b58:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b5a:	470d                	li	a4,3
    80004b5c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004b5e:	10001737          	lui	a4,0x10001
    80004b62:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004b64:	c7ffe737          	lui	a4,0xc7ffe
    80004b68:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdac8f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004b6c:	8ef9                	and	a3,a3,a4
    80004b6e:	10001737          	lui	a4,0x10001
    80004b72:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b74:	472d                	li	a4,11
    80004b76:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b78:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004b7c:	439c                	lw	a5,0(a5)
    80004b7e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004b82:	8ba1                	andi	a5,a5,8
    80004b84:	12078063          	beqz	a5,80004ca4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004b88:	100017b7          	lui	a5,0x10001
    80004b8c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004b90:	100017b7          	lui	a5,0x10001
    80004b94:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004b98:	439c                	lw	a5,0(a5)
    80004b9a:	2781                	sext.w	a5,a5
    80004b9c:	10079a63          	bnez	a5,80004cb0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004ba0:	100017b7          	lui	a5,0x10001
    80004ba4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004ba8:	439c                	lw	a5,0(a5)
    80004baa:	2781                	sext.w	a5,a5
  if(max == 0)
    80004bac:	10078863          	beqz	a5,80004cbc <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004bb0:	471d                	li	a4,7
    80004bb2:	10f77b63          	bgeu	a4,a5,80004cc8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004bb6:	d48fb0ef          	jal	800000fe <kalloc>
    80004bba:	00017497          	auipc	s1,0x17
    80004bbe:	cce48493          	addi	s1,s1,-818 # 8001b888 <disk>
    80004bc2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004bc4:	d3afb0ef          	jal	800000fe <kalloc>
    80004bc8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004bca:	d34fb0ef          	jal	800000fe <kalloc>
    80004bce:	87aa                	mv	a5,a0
    80004bd0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004bd2:	6088                	ld	a0,0(s1)
    80004bd4:	10050063          	beqz	a0,80004cd4 <virtio_disk_init+0x1ec>
    80004bd8:	00017717          	auipc	a4,0x17
    80004bdc:	cb873703          	ld	a4,-840(a4) # 8001b890 <disk+0x8>
    80004be0:	0e070a63          	beqz	a4,80004cd4 <virtio_disk_init+0x1ec>
    80004be4:	0e078863          	beqz	a5,80004cd4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004be8:	6605                	lui	a2,0x1
    80004bea:	4581                	li	a1,0
    80004bec:	da4fb0ef          	jal	80000190 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004bf0:	00017497          	auipc	s1,0x17
    80004bf4:	c9848493          	addi	s1,s1,-872 # 8001b888 <disk>
    80004bf8:	6605                	lui	a2,0x1
    80004bfa:	4581                	li	a1,0
    80004bfc:	6488                	ld	a0,8(s1)
    80004bfe:	d92fb0ef          	jal	80000190 <memset>
  memset(disk.used, 0, PGSIZE);
    80004c02:	6605                	lui	a2,0x1
    80004c04:	4581                	li	a1,0
    80004c06:	6888                	ld	a0,16(s1)
    80004c08:	d88fb0ef          	jal	80000190 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004c0c:	100017b7          	lui	a5,0x10001
    80004c10:	4721                	li	a4,8
    80004c12:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004c14:	4098                	lw	a4,0(s1)
    80004c16:	100017b7          	lui	a5,0x10001
    80004c1a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004c1e:	40d8                	lw	a4,4(s1)
    80004c20:	100017b7          	lui	a5,0x10001
    80004c24:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004c28:	649c                	ld	a5,8(s1)
    80004c2a:	0007869b          	sext.w	a3,a5
    80004c2e:	10001737          	lui	a4,0x10001
    80004c32:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004c36:	9781                	srai	a5,a5,0x20
    80004c38:	10001737          	lui	a4,0x10001
    80004c3c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004c40:	689c                	ld	a5,16(s1)
    80004c42:	0007869b          	sext.w	a3,a5
    80004c46:	10001737          	lui	a4,0x10001
    80004c4a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004c4e:	9781                	srai	a5,a5,0x20
    80004c50:	10001737          	lui	a4,0x10001
    80004c54:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004c58:	10001737          	lui	a4,0x10001
    80004c5c:	4785                	li	a5,1
    80004c5e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004c60:	00f48c23          	sb	a5,24(s1)
    80004c64:	00f48ca3          	sb	a5,25(s1)
    80004c68:	00f48d23          	sb	a5,26(s1)
    80004c6c:	00f48da3          	sb	a5,27(s1)
    80004c70:	00f48e23          	sb	a5,28(s1)
    80004c74:	00f48ea3          	sb	a5,29(s1)
    80004c78:	00f48f23          	sb	a5,30(s1)
    80004c7c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004c80:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c84:	100017b7          	lui	a5,0x10001
    80004c88:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004c8c:	60e2                	ld	ra,24(sp)
    80004c8e:	6442                	ld	s0,16(sp)
    80004c90:	64a2                	ld	s1,8(sp)
    80004c92:	6902                	ld	s2,0(sp)
    80004c94:	6105                	addi	sp,sp,32
    80004c96:	8082                	ret
    panic("could not find virtio disk");
    80004c98:	00003517          	auipc	a0,0x3
    80004c9c:	ab050513          	addi	a0,a0,-1360 # 80007748 <etext+0x748>
    80004ca0:	273000ef          	jal	80005712 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004ca4:	00003517          	auipc	a0,0x3
    80004ca8:	ac450513          	addi	a0,a0,-1340 # 80007768 <etext+0x768>
    80004cac:	267000ef          	jal	80005712 <panic>
    panic("virtio disk should not be ready");
    80004cb0:	00003517          	auipc	a0,0x3
    80004cb4:	ad850513          	addi	a0,a0,-1320 # 80007788 <etext+0x788>
    80004cb8:	25b000ef          	jal	80005712 <panic>
    panic("virtio disk has no queue 0");
    80004cbc:	00003517          	auipc	a0,0x3
    80004cc0:	aec50513          	addi	a0,a0,-1300 # 800077a8 <etext+0x7a8>
    80004cc4:	24f000ef          	jal	80005712 <panic>
    panic("virtio disk max queue too short");
    80004cc8:	00003517          	auipc	a0,0x3
    80004ccc:	b0050513          	addi	a0,a0,-1280 # 800077c8 <etext+0x7c8>
    80004cd0:	243000ef          	jal	80005712 <panic>
    panic("virtio disk kalloc");
    80004cd4:	00003517          	auipc	a0,0x3
    80004cd8:	b1450513          	addi	a0,a0,-1260 # 800077e8 <etext+0x7e8>
    80004cdc:	237000ef          	jal	80005712 <panic>

0000000080004ce0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004ce0:	7159                	addi	sp,sp,-112
    80004ce2:	f486                	sd	ra,104(sp)
    80004ce4:	f0a2                	sd	s0,96(sp)
    80004ce6:	eca6                	sd	s1,88(sp)
    80004ce8:	e8ca                	sd	s2,80(sp)
    80004cea:	e4ce                	sd	s3,72(sp)
    80004cec:	e0d2                	sd	s4,64(sp)
    80004cee:	fc56                	sd	s5,56(sp)
    80004cf0:	f85a                	sd	s6,48(sp)
    80004cf2:	f45e                	sd	s7,40(sp)
    80004cf4:	f062                	sd	s8,32(sp)
    80004cf6:	ec66                	sd	s9,24(sp)
    80004cf8:	1880                	addi	s0,sp,112
    80004cfa:	8a2a                	mv	s4,a0
    80004cfc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004cfe:	00c52c83          	lw	s9,12(a0)
    80004d02:	001c9c9b          	slliw	s9,s9,0x1
    80004d06:	1c82                	slli	s9,s9,0x20
    80004d08:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004d0c:	00017517          	auipc	a0,0x17
    80004d10:	ca450513          	addi	a0,a0,-860 # 8001b9b0 <disk+0x128>
    80004d14:	52d000ef          	jal	80005a40 <acquire>
  for(int i = 0; i < 3; i++){
    80004d18:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004d1a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004d1c:	00017b17          	auipc	s6,0x17
    80004d20:	b6cb0b13          	addi	s6,s6,-1172 # 8001b888 <disk>
  for(int i = 0; i < 3; i++){
    80004d24:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004d26:	00017c17          	auipc	s8,0x17
    80004d2a:	c8ac0c13          	addi	s8,s8,-886 # 8001b9b0 <disk+0x128>
    80004d2e:	a8b9                	j	80004d8c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004d30:	00fb0733          	add	a4,s6,a5
    80004d34:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004d38:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004d3a:	0207c563          	bltz	a5,80004d64 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004d3e:	2905                	addiw	s2,s2,1
    80004d40:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004d42:	05590963          	beq	s2,s5,80004d94 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004d46:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004d48:	00017717          	auipc	a4,0x17
    80004d4c:	b4070713          	addi	a4,a4,-1216 # 8001b888 <disk>
    80004d50:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004d52:	01874683          	lbu	a3,24(a4)
    80004d56:	fee9                	bnez	a3,80004d30 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004d58:	2785                	addiw	a5,a5,1
    80004d5a:	0705                	addi	a4,a4,1
    80004d5c:	fe979be3          	bne	a5,s1,80004d52 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004d60:	57fd                	li	a5,-1
    80004d62:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004d64:	01205d63          	blez	s2,80004d7e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004d68:	f9042503          	lw	a0,-112(s0)
    80004d6c:	d07ff0ef          	jal	80004a72 <free_desc>
      for(int j = 0; j < i; j++)
    80004d70:	4785                	li	a5,1
    80004d72:	0127d663          	bge	a5,s2,80004d7e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004d76:	f9442503          	lw	a0,-108(s0)
    80004d7a:	cf9ff0ef          	jal	80004a72 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004d7e:	85e2                	mv	a1,s8
    80004d80:	00017517          	auipc	a0,0x17
    80004d84:	b2050513          	addi	a0,a0,-1248 # 8001b8a0 <disk+0x18>
    80004d88:	e0afc0ef          	jal	80001392 <sleep>
  for(int i = 0; i < 3; i++){
    80004d8c:	f9040613          	addi	a2,s0,-112
    80004d90:	894e                	mv	s2,s3
    80004d92:	bf55                	j	80004d46 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d94:	f9042503          	lw	a0,-112(s0)
    80004d98:	00451693          	slli	a3,a0,0x4

  if(write)
    80004d9c:	00017797          	auipc	a5,0x17
    80004da0:	aec78793          	addi	a5,a5,-1300 # 8001b888 <disk>
    80004da4:	00a50713          	addi	a4,a0,10
    80004da8:	0712                	slli	a4,a4,0x4
    80004daa:	973e                	add	a4,a4,a5
    80004dac:	01703633          	snez	a2,s7
    80004db0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004db2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004db6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004dba:	6398                	ld	a4,0(a5)
    80004dbc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004dbe:	0a868613          	addi	a2,a3,168
    80004dc2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004dc4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004dc6:	6390                	ld	a2,0(a5)
    80004dc8:	00d605b3          	add	a1,a2,a3
    80004dcc:	4741                	li	a4,16
    80004dce:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004dd0:	4805                	li	a6,1
    80004dd2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004dd6:	f9442703          	lw	a4,-108(s0)
    80004dda:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004dde:	0712                	slli	a4,a4,0x4
    80004de0:	963a                	add	a2,a2,a4
    80004de2:	058a0593          	addi	a1,s4,88
    80004de6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004de8:	0007b883          	ld	a7,0(a5)
    80004dec:	9746                	add	a4,a4,a7
    80004dee:	40000613          	li	a2,1024
    80004df2:	c710                	sw	a2,8(a4)
  if(write)
    80004df4:	001bb613          	seqz	a2,s7
    80004df8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004dfc:	00166613          	ori	a2,a2,1
    80004e00:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004e04:	f9842583          	lw	a1,-104(s0)
    80004e08:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004e0c:	00250613          	addi	a2,a0,2
    80004e10:	0612                	slli	a2,a2,0x4
    80004e12:	963e                	add	a2,a2,a5
    80004e14:	577d                	li	a4,-1
    80004e16:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004e1a:	0592                	slli	a1,a1,0x4
    80004e1c:	98ae                	add	a7,a7,a1
    80004e1e:	03068713          	addi	a4,a3,48
    80004e22:	973e                	add	a4,a4,a5
    80004e24:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004e28:	6398                	ld	a4,0(a5)
    80004e2a:	972e                	add	a4,a4,a1
    80004e2c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004e30:	4689                	li	a3,2
    80004e32:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004e36:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004e3a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004e3e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004e42:	6794                	ld	a3,8(a5)
    80004e44:	0026d703          	lhu	a4,2(a3)
    80004e48:	8b1d                	andi	a4,a4,7
    80004e4a:	0706                	slli	a4,a4,0x1
    80004e4c:	96ba                	add	a3,a3,a4
    80004e4e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004e52:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004e56:	6798                	ld	a4,8(a5)
    80004e58:	00275783          	lhu	a5,2(a4)
    80004e5c:	2785                	addiw	a5,a5,1
    80004e5e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004e62:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004e66:	100017b7          	lui	a5,0x10001
    80004e6a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004e6e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004e72:	00017917          	auipc	s2,0x17
    80004e76:	b3e90913          	addi	s2,s2,-1218 # 8001b9b0 <disk+0x128>
  while(b->disk == 1) {
    80004e7a:	4485                	li	s1,1
    80004e7c:	01079a63          	bne	a5,a6,80004e90 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004e80:	85ca                	mv	a1,s2
    80004e82:	8552                	mv	a0,s4
    80004e84:	d0efc0ef          	jal	80001392 <sleep>
  while(b->disk == 1) {
    80004e88:	004a2783          	lw	a5,4(s4)
    80004e8c:	fe978ae3          	beq	a5,s1,80004e80 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004e90:	f9042903          	lw	s2,-112(s0)
    80004e94:	00290713          	addi	a4,s2,2
    80004e98:	0712                	slli	a4,a4,0x4
    80004e9a:	00017797          	auipc	a5,0x17
    80004e9e:	9ee78793          	addi	a5,a5,-1554 # 8001b888 <disk>
    80004ea2:	97ba                	add	a5,a5,a4
    80004ea4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004ea8:	00017997          	auipc	s3,0x17
    80004eac:	9e098993          	addi	s3,s3,-1568 # 8001b888 <disk>
    80004eb0:	00491713          	slli	a4,s2,0x4
    80004eb4:	0009b783          	ld	a5,0(s3)
    80004eb8:	97ba                	add	a5,a5,a4
    80004eba:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004ebe:	854a                	mv	a0,s2
    80004ec0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004ec4:	bafff0ef          	jal	80004a72 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004ec8:	8885                	andi	s1,s1,1
    80004eca:	f0fd                	bnez	s1,80004eb0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004ecc:	00017517          	auipc	a0,0x17
    80004ed0:	ae450513          	addi	a0,a0,-1308 # 8001b9b0 <disk+0x128>
    80004ed4:	405000ef          	jal	80005ad8 <release>
}
    80004ed8:	70a6                	ld	ra,104(sp)
    80004eda:	7406                	ld	s0,96(sp)
    80004edc:	64e6                	ld	s1,88(sp)
    80004ede:	6946                	ld	s2,80(sp)
    80004ee0:	69a6                	ld	s3,72(sp)
    80004ee2:	6a06                	ld	s4,64(sp)
    80004ee4:	7ae2                	ld	s5,56(sp)
    80004ee6:	7b42                	ld	s6,48(sp)
    80004ee8:	7ba2                	ld	s7,40(sp)
    80004eea:	7c02                	ld	s8,32(sp)
    80004eec:	6ce2                	ld	s9,24(sp)
    80004eee:	6165                	addi	sp,sp,112
    80004ef0:	8082                	ret

0000000080004ef2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004ef2:	1101                	addi	sp,sp,-32
    80004ef4:	ec06                	sd	ra,24(sp)
    80004ef6:	e822                	sd	s0,16(sp)
    80004ef8:	e426                	sd	s1,8(sp)
    80004efa:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004efc:	00017497          	auipc	s1,0x17
    80004f00:	98c48493          	addi	s1,s1,-1652 # 8001b888 <disk>
    80004f04:	00017517          	auipc	a0,0x17
    80004f08:	aac50513          	addi	a0,a0,-1364 # 8001b9b0 <disk+0x128>
    80004f0c:	335000ef          	jal	80005a40 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004f10:	100017b7          	lui	a5,0x10001
    80004f14:	53b8                	lw	a4,96(a5)
    80004f16:	8b0d                	andi	a4,a4,3
    80004f18:	100017b7          	lui	a5,0x10001
    80004f1c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004f1e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004f22:	689c                	ld	a5,16(s1)
    80004f24:	0204d703          	lhu	a4,32(s1)
    80004f28:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004f2c:	04f70663          	beq	a4,a5,80004f78 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004f30:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004f34:	6898                	ld	a4,16(s1)
    80004f36:	0204d783          	lhu	a5,32(s1)
    80004f3a:	8b9d                	andi	a5,a5,7
    80004f3c:	078e                	slli	a5,a5,0x3
    80004f3e:	97ba                	add	a5,a5,a4
    80004f40:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004f42:	00278713          	addi	a4,a5,2
    80004f46:	0712                	slli	a4,a4,0x4
    80004f48:	9726                	add	a4,a4,s1
    80004f4a:	01074703          	lbu	a4,16(a4)
    80004f4e:	e321                	bnez	a4,80004f8e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004f50:	0789                	addi	a5,a5,2
    80004f52:	0792                	slli	a5,a5,0x4
    80004f54:	97a6                	add	a5,a5,s1
    80004f56:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004f58:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004f5c:	c82fc0ef          	jal	800013de <wakeup>

    disk.used_idx += 1;
    80004f60:	0204d783          	lhu	a5,32(s1)
    80004f64:	2785                	addiw	a5,a5,1
    80004f66:	17c2                	slli	a5,a5,0x30
    80004f68:	93c1                	srli	a5,a5,0x30
    80004f6a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004f6e:	6898                	ld	a4,16(s1)
    80004f70:	00275703          	lhu	a4,2(a4)
    80004f74:	faf71ee3          	bne	a4,a5,80004f30 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004f78:	00017517          	auipc	a0,0x17
    80004f7c:	a3850513          	addi	a0,a0,-1480 # 8001b9b0 <disk+0x128>
    80004f80:	359000ef          	jal	80005ad8 <release>
}
    80004f84:	60e2                	ld	ra,24(sp)
    80004f86:	6442                	ld	s0,16(sp)
    80004f88:	64a2                	ld	s1,8(sp)
    80004f8a:	6105                	addi	sp,sp,32
    80004f8c:	8082                	ret
      panic("virtio_disk_intr status");
    80004f8e:	00003517          	auipc	a0,0x3
    80004f92:	87250513          	addi	a0,a0,-1934 # 80007800 <etext+0x800>
    80004f96:	77c000ef          	jal	80005712 <panic>

0000000080004f9a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004f9a:	1141                	addi	sp,sp,-16
    80004f9c:	e422                	sd	s0,8(sp)
    80004f9e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004fa0:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004fa4:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004fa8:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004fac:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004fb0:	577d                	li	a4,-1
    80004fb2:	177e                	slli	a4,a4,0x3f
    80004fb4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004fb6:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004fba:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004fbe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004fc2:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004fc6:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004fca:	000f4737          	lui	a4,0xf4
    80004fce:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004fd2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004fd4:	14d79073          	csrw	stimecmp,a5
}
    80004fd8:	6422                	ld	s0,8(sp)
    80004fda:	0141                	addi	sp,sp,16
    80004fdc:	8082                	ret

0000000080004fde <start>:
{
    80004fde:	1141                	addi	sp,sp,-16
    80004fe0:	e406                	sd	ra,8(sp)
    80004fe2:	e022                	sd	s0,0(sp)
    80004fe4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004fe6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004fea:	7779                	lui	a4,0xffffe
    80004fec:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdad2f>
    80004ff0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004ff2:	6705                	lui	a4,0x1
    80004ff4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004ff8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004ffa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004ffe:	ffffb797          	auipc	a5,0xffffb
    80005002:	32c78793          	addi	a5,a5,812 # 8000032a <main>
    80005006:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000500a:	4781                	li	a5,0
    8000500c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005010:	67c1                	lui	a5,0x10
    80005012:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005014:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005018:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000501c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005020:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005024:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005028:	57fd                	li	a5,-1
    8000502a:	83a9                	srli	a5,a5,0xa
    8000502c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005030:	47bd                	li	a5,15
    80005032:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005036:	f65ff0ef          	jal	80004f9a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000503a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000503e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005040:	823e                	mv	tp,a5
  asm volatile("mret");
    80005042:	30200073          	mret
}
    80005046:	60a2                	ld	ra,8(sp)
    80005048:	6402                	ld	s0,0(sp)
    8000504a:	0141                	addi	sp,sp,16
    8000504c:	8082                	ret

000000008000504e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000504e:	715d                	addi	sp,sp,-80
    80005050:	e486                	sd	ra,72(sp)
    80005052:	e0a2                	sd	s0,64(sp)
    80005054:	f84a                	sd	s2,48(sp)
    80005056:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005058:	04c05263          	blez	a2,8000509c <consolewrite+0x4e>
    8000505c:	fc26                	sd	s1,56(sp)
    8000505e:	f44e                	sd	s3,40(sp)
    80005060:	f052                	sd	s4,32(sp)
    80005062:	ec56                	sd	s5,24(sp)
    80005064:	8a2a                	mv	s4,a0
    80005066:	84ae                	mv	s1,a1
    80005068:	89b2                	mv	s3,a2
    8000506a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000506c:	5afd                	li	s5,-1
    8000506e:	4685                	li	a3,1
    80005070:	8626                	mv	a2,s1
    80005072:	85d2                	mv	a1,s4
    80005074:	fbf40513          	addi	a0,s0,-65
    80005078:	ec0fc0ef          	jal	80001738 <either_copyin>
    8000507c:	03550263          	beq	a0,s5,800050a0 <consolewrite+0x52>
      break;
    uartputc(c);
    80005080:	fbf44503          	lbu	a0,-65(s0)
    80005084:	035000ef          	jal	800058b8 <uartputc>
  for(i = 0; i < n; i++){
    80005088:	2905                	addiw	s2,s2,1
    8000508a:	0485                	addi	s1,s1,1
    8000508c:	ff2991e3          	bne	s3,s2,8000506e <consolewrite+0x20>
    80005090:	894e                	mv	s2,s3
    80005092:	74e2                	ld	s1,56(sp)
    80005094:	79a2                	ld	s3,40(sp)
    80005096:	7a02                	ld	s4,32(sp)
    80005098:	6ae2                	ld	s5,24(sp)
    8000509a:	a039                	j	800050a8 <consolewrite+0x5a>
    8000509c:	4901                	li	s2,0
    8000509e:	a029                	j	800050a8 <consolewrite+0x5a>
    800050a0:	74e2                	ld	s1,56(sp)
    800050a2:	79a2                	ld	s3,40(sp)
    800050a4:	7a02                	ld	s4,32(sp)
    800050a6:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    800050a8:	854a                	mv	a0,s2
    800050aa:	60a6                	ld	ra,72(sp)
    800050ac:	6406                	ld	s0,64(sp)
    800050ae:	7942                	ld	s2,48(sp)
    800050b0:	6161                	addi	sp,sp,80
    800050b2:	8082                	ret

00000000800050b4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800050b4:	711d                	addi	sp,sp,-96
    800050b6:	ec86                	sd	ra,88(sp)
    800050b8:	e8a2                	sd	s0,80(sp)
    800050ba:	e4a6                	sd	s1,72(sp)
    800050bc:	e0ca                	sd	s2,64(sp)
    800050be:	fc4e                	sd	s3,56(sp)
    800050c0:	f852                	sd	s4,48(sp)
    800050c2:	f456                	sd	s5,40(sp)
    800050c4:	f05a                	sd	s6,32(sp)
    800050c6:	1080                	addi	s0,sp,96
    800050c8:	8aaa                	mv	s5,a0
    800050ca:	8a2e                	mv	s4,a1
    800050cc:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800050ce:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800050d2:	0001f517          	auipc	a0,0x1f
    800050d6:	8fe50513          	addi	a0,a0,-1794 # 800239d0 <cons>
    800050da:	167000ef          	jal	80005a40 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800050de:	0001f497          	auipc	s1,0x1f
    800050e2:	8f248493          	addi	s1,s1,-1806 # 800239d0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800050e6:	0001f917          	auipc	s2,0x1f
    800050ea:	98290913          	addi	s2,s2,-1662 # 80023a68 <cons+0x98>
  while(n > 0){
    800050ee:	0b305d63          	blez	s3,800051a8 <consoleread+0xf4>
    while(cons.r == cons.w){
    800050f2:	0984a783          	lw	a5,152(s1)
    800050f6:	09c4a703          	lw	a4,156(s1)
    800050fa:	0af71263          	bne	a4,a5,8000519e <consoleread+0xea>
      if(killed(myproc())){
    800050fe:	cbffb0ef          	jal	80000dbc <myproc>
    80005102:	cc8fc0ef          	jal	800015ca <killed>
    80005106:	e12d                	bnez	a0,80005168 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80005108:	85a6                	mv	a1,s1
    8000510a:	854a                	mv	a0,s2
    8000510c:	a86fc0ef          	jal	80001392 <sleep>
    while(cons.r == cons.w){
    80005110:	0984a783          	lw	a5,152(s1)
    80005114:	09c4a703          	lw	a4,156(s1)
    80005118:	fef703e3          	beq	a4,a5,800050fe <consoleread+0x4a>
    8000511c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000511e:	0001f717          	auipc	a4,0x1f
    80005122:	8b270713          	addi	a4,a4,-1870 # 800239d0 <cons>
    80005126:	0017869b          	addiw	a3,a5,1
    8000512a:	08d72c23          	sw	a3,152(a4)
    8000512e:	07f7f693          	andi	a3,a5,127
    80005132:	9736                	add	a4,a4,a3
    80005134:	01874703          	lbu	a4,24(a4)
    80005138:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    8000513c:	4691                	li	a3,4
    8000513e:	04db8663          	beq	s7,a3,8000518a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005142:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005146:	4685                	li	a3,1
    80005148:	faf40613          	addi	a2,s0,-81
    8000514c:	85d2                	mv	a1,s4
    8000514e:	8556                	mv	a0,s5
    80005150:	d9efc0ef          	jal	800016ee <either_copyout>
    80005154:	57fd                	li	a5,-1
    80005156:	04f50863          	beq	a0,a5,800051a6 <consoleread+0xf2>
      break;

    dst++;
    8000515a:	0a05                	addi	s4,s4,1
    --n;
    8000515c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000515e:	47a9                	li	a5,10
    80005160:	04fb8d63          	beq	s7,a5,800051ba <consoleread+0x106>
    80005164:	6be2                	ld	s7,24(sp)
    80005166:	b761                	j	800050ee <consoleread+0x3a>
        release(&cons.lock);
    80005168:	0001f517          	auipc	a0,0x1f
    8000516c:	86850513          	addi	a0,a0,-1944 # 800239d0 <cons>
    80005170:	169000ef          	jal	80005ad8 <release>
        return -1;
    80005174:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005176:	60e6                	ld	ra,88(sp)
    80005178:	6446                	ld	s0,80(sp)
    8000517a:	64a6                	ld	s1,72(sp)
    8000517c:	6906                	ld	s2,64(sp)
    8000517e:	79e2                	ld	s3,56(sp)
    80005180:	7a42                	ld	s4,48(sp)
    80005182:	7aa2                	ld	s5,40(sp)
    80005184:	7b02                	ld	s6,32(sp)
    80005186:	6125                	addi	sp,sp,96
    80005188:	8082                	ret
      if(n < target){
    8000518a:	0009871b          	sext.w	a4,s3
    8000518e:	01677a63          	bgeu	a4,s6,800051a2 <consoleread+0xee>
        cons.r--;
    80005192:	0001f717          	auipc	a4,0x1f
    80005196:	8cf72b23          	sw	a5,-1834(a4) # 80023a68 <cons+0x98>
    8000519a:	6be2                	ld	s7,24(sp)
    8000519c:	a031                	j	800051a8 <consoleread+0xf4>
    8000519e:	ec5e                	sd	s7,24(sp)
    800051a0:	bfbd                	j	8000511e <consoleread+0x6a>
    800051a2:	6be2                	ld	s7,24(sp)
    800051a4:	a011                	j	800051a8 <consoleread+0xf4>
    800051a6:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800051a8:	0001f517          	auipc	a0,0x1f
    800051ac:	82850513          	addi	a0,a0,-2008 # 800239d0 <cons>
    800051b0:	129000ef          	jal	80005ad8 <release>
  return target - n;
    800051b4:	413b053b          	subw	a0,s6,s3
    800051b8:	bf7d                	j	80005176 <consoleread+0xc2>
    800051ba:	6be2                	ld	s7,24(sp)
    800051bc:	b7f5                	j	800051a8 <consoleread+0xf4>

00000000800051be <consputc>:
{
    800051be:	1141                	addi	sp,sp,-16
    800051c0:	e406                	sd	ra,8(sp)
    800051c2:	e022                	sd	s0,0(sp)
    800051c4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800051c6:	10000793          	li	a5,256
    800051ca:	00f50863          	beq	a0,a5,800051da <consputc+0x1c>
    uartputc_sync(c);
    800051ce:	604000ef          	jal	800057d2 <uartputc_sync>
}
    800051d2:	60a2                	ld	ra,8(sp)
    800051d4:	6402                	ld	s0,0(sp)
    800051d6:	0141                	addi	sp,sp,16
    800051d8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800051da:	4521                	li	a0,8
    800051dc:	5f6000ef          	jal	800057d2 <uartputc_sync>
    800051e0:	02000513          	li	a0,32
    800051e4:	5ee000ef          	jal	800057d2 <uartputc_sync>
    800051e8:	4521                	li	a0,8
    800051ea:	5e8000ef          	jal	800057d2 <uartputc_sync>
    800051ee:	b7d5                	j	800051d2 <consputc+0x14>

00000000800051f0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800051f0:	1101                	addi	sp,sp,-32
    800051f2:	ec06                	sd	ra,24(sp)
    800051f4:	e822                	sd	s0,16(sp)
    800051f6:	e426                	sd	s1,8(sp)
    800051f8:	1000                	addi	s0,sp,32
    800051fa:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800051fc:	0001e517          	auipc	a0,0x1e
    80005200:	7d450513          	addi	a0,a0,2004 # 800239d0 <cons>
    80005204:	03d000ef          	jal	80005a40 <acquire>

  switch(c){
    80005208:	47d5                	li	a5,21
    8000520a:	08f48f63          	beq	s1,a5,800052a8 <consoleintr+0xb8>
    8000520e:	0297c563          	blt	a5,s1,80005238 <consoleintr+0x48>
    80005212:	47a1                	li	a5,8
    80005214:	0ef48463          	beq	s1,a5,800052fc <consoleintr+0x10c>
    80005218:	47c1                	li	a5,16
    8000521a:	10f49563          	bne	s1,a5,80005324 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    8000521e:	d64fc0ef          	jal	80001782 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005222:	0001e517          	auipc	a0,0x1e
    80005226:	7ae50513          	addi	a0,a0,1966 # 800239d0 <cons>
    8000522a:	0af000ef          	jal	80005ad8 <release>
}
    8000522e:	60e2                	ld	ra,24(sp)
    80005230:	6442                	ld	s0,16(sp)
    80005232:	64a2                	ld	s1,8(sp)
    80005234:	6105                	addi	sp,sp,32
    80005236:	8082                	ret
  switch(c){
    80005238:	07f00793          	li	a5,127
    8000523c:	0cf48063          	beq	s1,a5,800052fc <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005240:	0001e717          	auipc	a4,0x1e
    80005244:	79070713          	addi	a4,a4,1936 # 800239d0 <cons>
    80005248:	0a072783          	lw	a5,160(a4)
    8000524c:	09872703          	lw	a4,152(a4)
    80005250:	9f99                	subw	a5,a5,a4
    80005252:	07f00713          	li	a4,127
    80005256:	fcf766e3          	bltu	a4,a5,80005222 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000525a:	47b5                	li	a5,13
    8000525c:	0cf48763          	beq	s1,a5,8000532a <consoleintr+0x13a>
      consputc(c);
    80005260:	8526                	mv	a0,s1
    80005262:	f5dff0ef          	jal	800051be <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005266:	0001e797          	auipc	a5,0x1e
    8000526a:	76a78793          	addi	a5,a5,1898 # 800239d0 <cons>
    8000526e:	0a07a683          	lw	a3,160(a5)
    80005272:	0016871b          	addiw	a4,a3,1
    80005276:	0007061b          	sext.w	a2,a4
    8000527a:	0ae7a023          	sw	a4,160(a5)
    8000527e:	07f6f693          	andi	a3,a3,127
    80005282:	97b6                	add	a5,a5,a3
    80005284:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005288:	47a9                	li	a5,10
    8000528a:	0cf48563          	beq	s1,a5,80005354 <consoleintr+0x164>
    8000528e:	4791                	li	a5,4
    80005290:	0cf48263          	beq	s1,a5,80005354 <consoleintr+0x164>
    80005294:	0001e797          	auipc	a5,0x1e
    80005298:	7d47a783          	lw	a5,2004(a5) # 80023a68 <cons+0x98>
    8000529c:	9f1d                	subw	a4,a4,a5
    8000529e:	08000793          	li	a5,128
    800052a2:	f8f710e3          	bne	a4,a5,80005222 <consoleintr+0x32>
    800052a6:	a07d                	j	80005354 <consoleintr+0x164>
    800052a8:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800052aa:	0001e717          	auipc	a4,0x1e
    800052ae:	72670713          	addi	a4,a4,1830 # 800239d0 <cons>
    800052b2:	0a072783          	lw	a5,160(a4)
    800052b6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800052ba:	0001e497          	auipc	s1,0x1e
    800052be:	71648493          	addi	s1,s1,1814 # 800239d0 <cons>
    while(cons.e != cons.w &&
    800052c2:	4929                	li	s2,10
    800052c4:	02f70863          	beq	a4,a5,800052f4 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800052c8:	37fd                	addiw	a5,a5,-1
    800052ca:	07f7f713          	andi	a4,a5,127
    800052ce:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800052d0:	01874703          	lbu	a4,24(a4)
    800052d4:	03270263          	beq	a4,s2,800052f8 <consoleintr+0x108>
      cons.e--;
    800052d8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800052dc:	10000513          	li	a0,256
    800052e0:	edfff0ef          	jal	800051be <consputc>
    while(cons.e != cons.w &&
    800052e4:	0a04a783          	lw	a5,160(s1)
    800052e8:	09c4a703          	lw	a4,156(s1)
    800052ec:	fcf71ee3          	bne	a4,a5,800052c8 <consoleintr+0xd8>
    800052f0:	6902                	ld	s2,0(sp)
    800052f2:	bf05                	j	80005222 <consoleintr+0x32>
    800052f4:	6902                	ld	s2,0(sp)
    800052f6:	b735                	j	80005222 <consoleintr+0x32>
    800052f8:	6902                	ld	s2,0(sp)
    800052fa:	b725                	j	80005222 <consoleintr+0x32>
    if(cons.e != cons.w){
    800052fc:	0001e717          	auipc	a4,0x1e
    80005300:	6d470713          	addi	a4,a4,1748 # 800239d0 <cons>
    80005304:	0a072783          	lw	a5,160(a4)
    80005308:	09c72703          	lw	a4,156(a4)
    8000530c:	f0f70be3          	beq	a4,a5,80005222 <consoleintr+0x32>
      cons.e--;
    80005310:	37fd                	addiw	a5,a5,-1
    80005312:	0001e717          	auipc	a4,0x1e
    80005316:	74f72f23          	sw	a5,1886(a4) # 80023a70 <cons+0xa0>
      consputc(BACKSPACE);
    8000531a:	10000513          	li	a0,256
    8000531e:	ea1ff0ef          	jal	800051be <consputc>
    80005322:	b701                	j	80005222 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005324:	ee048fe3          	beqz	s1,80005222 <consoleintr+0x32>
    80005328:	bf21                	j	80005240 <consoleintr+0x50>
      consputc(c);
    8000532a:	4529                	li	a0,10
    8000532c:	e93ff0ef          	jal	800051be <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005330:	0001e797          	auipc	a5,0x1e
    80005334:	6a078793          	addi	a5,a5,1696 # 800239d0 <cons>
    80005338:	0a07a703          	lw	a4,160(a5)
    8000533c:	0017069b          	addiw	a3,a4,1
    80005340:	0006861b          	sext.w	a2,a3
    80005344:	0ad7a023          	sw	a3,160(a5)
    80005348:	07f77713          	andi	a4,a4,127
    8000534c:	97ba                	add	a5,a5,a4
    8000534e:	4729                	li	a4,10
    80005350:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005354:	0001e797          	auipc	a5,0x1e
    80005358:	70c7ac23          	sw	a2,1816(a5) # 80023a6c <cons+0x9c>
        wakeup(&cons.r);
    8000535c:	0001e517          	auipc	a0,0x1e
    80005360:	70c50513          	addi	a0,a0,1804 # 80023a68 <cons+0x98>
    80005364:	87afc0ef          	jal	800013de <wakeup>
    80005368:	bd6d                	j	80005222 <consoleintr+0x32>

000000008000536a <consoleinit>:

void
consoleinit(void)
{
    8000536a:	1141                	addi	sp,sp,-16
    8000536c:	e406                	sd	ra,8(sp)
    8000536e:	e022                	sd	s0,0(sp)
    80005370:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005372:	00002597          	auipc	a1,0x2
    80005376:	4a658593          	addi	a1,a1,1190 # 80007818 <etext+0x818>
    8000537a:	0001e517          	auipc	a0,0x1e
    8000537e:	65650513          	addi	a0,a0,1622 # 800239d0 <cons>
    80005382:	63e000ef          	jal	800059c0 <initlock>

  uartinit();
    80005386:	3f4000ef          	jal	8000577a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000538a:	00015797          	auipc	a5,0x15
    8000538e:	4a678793          	addi	a5,a5,1190 # 8001a830 <devsw>
    80005392:	00000717          	auipc	a4,0x0
    80005396:	d2270713          	addi	a4,a4,-734 # 800050b4 <consoleread>
    8000539a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000539c:	00000717          	auipc	a4,0x0
    800053a0:	cb270713          	addi	a4,a4,-846 # 8000504e <consolewrite>
    800053a4:	ef98                	sd	a4,24(a5)
}
    800053a6:	60a2                	ld	ra,8(sp)
    800053a8:	6402                	ld	s0,0(sp)
    800053aa:	0141                	addi	sp,sp,16
    800053ac:	8082                	ret

00000000800053ae <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800053ae:	7179                	addi	sp,sp,-48
    800053b0:	f406                	sd	ra,40(sp)
    800053b2:	f022                	sd	s0,32(sp)
    800053b4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800053b6:	c219                	beqz	a2,800053bc <printint+0xe>
    800053b8:	08054063          	bltz	a0,80005438 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800053bc:	4881                	li	a7,0
    800053be:	fd040693          	addi	a3,s0,-48

  i = 0;
    800053c2:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800053c4:	00002617          	auipc	a2,0x2
    800053c8:	6dc60613          	addi	a2,a2,1756 # 80007aa0 <digits>
    800053cc:	883e                	mv	a6,a5
    800053ce:	2785                	addiw	a5,a5,1
    800053d0:	02b57733          	remu	a4,a0,a1
    800053d4:	9732                	add	a4,a4,a2
    800053d6:	00074703          	lbu	a4,0(a4)
    800053da:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800053de:	872a                	mv	a4,a0
    800053e0:	02b55533          	divu	a0,a0,a1
    800053e4:	0685                	addi	a3,a3,1
    800053e6:	feb773e3          	bgeu	a4,a1,800053cc <printint+0x1e>

  if(sign)
    800053ea:	00088a63          	beqz	a7,800053fe <printint+0x50>
    buf[i++] = '-';
    800053ee:	1781                	addi	a5,a5,-32
    800053f0:	97a2                	add	a5,a5,s0
    800053f2:	02d00713          	li	a4,45
    800053f6:	fee78823          	sb	a4,-16(a5)
    800053fa:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800053fe:	02f05963          	blez	a5,80005430 <printint+0x82>
    80005402:	ec26                	sd	s1,24(sp)
    80005404:	e84a                	sd	s2,16(sp)
    80005406:	fd040713          	addi	a4,s0,-48
    8000540a:	00f704b3          	add	s1,a4,a5
    8000540e:	fff70913          	addi	s2,a4,-1
    80005412:	993e                	add	s2,s2,a5
    80005414:	37fd                	addiw	a5,a5,-1
    80005416:	1782                	slli	a5,a5,0x20
    80005418:	9381                	srli	a5,a5,0x20
    8000541a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000541e:	fff4c503          	lbu	a0,-1(s1)
    80005422:	d9dff0ef          	jal	800051be <consputc>
  while(--i >= 0)
    80005426:	14fd                	addi	s1,s1,-1
    80005428:	ff249be3          	bne	s1,s2,8000541e <printint+0x70>
    8000542c:	64e2                	ld	s1,24(sp)
    8000542e:	6942                	ld	s2,16(sp)
}
    80005430:	70a2                	ld	ra,40(sp)
    80005432:	7402                	ld	s0,32(sp)
    80005434:	6145                	addi	sp,sp,48
    80005436:	8082                	ret
    x = -xx;
    80005438:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000543c:	4885                	li	a7,1
    x = -xx;
    8000543e:	b741                	j	800053be <printint+0x10>

0000000080005440 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005440:	7155                	addi	sp,sp,-208
    80005442:	e506                	sd	ra,136(sp)
    80005444:	e122                	sd	s0,128(sp)
    80005446:	f0d2                	sd	s4,96(sp)
    80005448:	0900                	addi	s0,sp,144
    8000544a:	8a2a                	mv	s4,a0
    8000544c:	e40c                	sd	a1,8(s0)
    8000544e:	e810                	sd	a2,16(s0)
    80005450:	ec14                	sd	a3,24(s0)
    80005452:	f018                	sd	a4,32(s0)
    80005454:	f41c                	sd	a5,40(s0)
    80005456:	03043823          	sd	a6,48(s0)
    8000545a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000545e:	0001e797          	auipc	a5,0x1e
    80005462:	6327a783          	lw	a5,1586(a5) # 80023a90 <pr+0x18>
    80005466:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000546a:	e3a1                	bnez	a5,800054aa <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000546c:	00840793          	addi	a5,s0,8
    80005470:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005474:	00054503          	lbu	a0,0(a0)
    80005478:	26050763          	beqz	a0,800056e6 <printf+0x2a6>
    8000547c:	fca6                	sd	s1,120(sp)
    8000547e:	f8ca                	sd	s2,112(sp)
    80005480:	f4ce                	sd	s3,104(sp)
    80005482:	ecd6                	sd	s5,88(sp)
    80005484:	e8da                	sd	s6,80(sp)
    80005486:	e0e2                	sd	s8,64(sp)
    80005488:	fc66                	sd	s9,56(sp)
    8000548a:	f86a                	sd	s10,48(sp)
    8000548c:	f46e                	sd	s11,40(sp)
    8000548e:	4981                	li	s3,0
    if(cx != '%'){
    80005490:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005494:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005498:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000549c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800054a0:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800054a4:	07000d93          	li	s11,112
    800054a8:	a815                	j	800054dc <printf+0x9c>
    acquire(&pr.lock);
    800054aa:	0001e517          	auipc	a0,0x1e
    800054ae:	5ce50513          	addi	a0,a0,1486 # 80023a78 <pr>
    800054b2:	58e000ef          	jal	80005a40 <acquire>
  va_start(ap, fmt);
    800054b6:	00840793          	addi	a5,s0,8
    800054ba:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800054be:	000a4503          	lbu	a0,0(s4)
    800054c2:	fd4d                	bnez	a0,8000547c <printf+0x3c>
    800054c4:	a481                	j	80005704 <printf+0x2c4>
      consputc(cx);
    800054c6:	cf9ff0ef          	jal	800051be <consputc>
      continue;
    800054ca:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800054cc:	0014899b          	addiw	s3,s1,1
    800054d0:	013a07b3          	add	a5,s4,s3
    800054d4:	0007c503          	lbu	a0,0(a5)
    800054d8:	1e050b63          	beqz	a0,800056ce <printf+0x28e>
    if(cx != '%'){
    800054dc:	ff5515e3          	bne	a0,s5,800054c6 <printf+0x86>
    i++;
    800054e0:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800054e4:	009a07b3          	add	a5,s4,s1
    800054e8:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800054ec:	1e090163          	beqz	s2,800056ce <printf+0x28e>
    800054f0:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800054f4:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800054f6:	c789                	beqz	a5,80005500 <printf+0xc0>
    800054f8:	009a0733          	add	a4,s4,s1
    800054fc:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005500:	03690763          	beq	s2,s6,8000552e <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005504:	05890163          	beq	s2,s8,80005546 <printf+0x106>
    } else if(c0 == 'u'){
    80005508:	0d990b63          	beq	s2,s9,800055de <printf+0x19e>
    } else if(c0 == 'x'){
    8000550c:	13a90163          	beq	s2,s10,8000562e <printf+0x1ee>
    } else if(c0 == 'p'){
    80005510:	13b90b63          	beq	s2,s11,80005646 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005514:	07300793          	li	a5,115
    80005518:	16f90a63          	beq	s2,a5,8000568c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000551c:	1b590463          	beq	s2,s5,800056c4 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005520:	8556                	mv	a0,s5
    80005522:	c9dff0ef          	jal	800051be <consputc>
      consputc(c0);
    80005526:	854a                	mv	a0,s2
    80005528:	c97ff0ef          	jal	800051be <consputc>
    8000552c:	b745                	j	800054cc <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000552e:	f8843783          	ld	a5,-120(s0)
    80005532:	00878713          	addi	a4,a5,8
    80005536:	f8e43423          	sd	a4,-120(s0)
    8000553a:	4605                	li	a2,1
    8000553c:	45a9                	li	a1,10
    8000553e:	4388                	lw	a0,0(a5)
    80005540:	e6fff0ef          	jal	800053ae <printint>
    80005544:	b761                	j	800054cc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005546:	03678663          	beq	a5,s6,80005572 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000554a:	05878263          	beq	a5,s8,8000558e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000554e:	0b978463          	beq	a5,s9,800055f6 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005552:	fda797e3          	bne	a5,s10,80005520 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005556:	f8843783          	ld	a5,-120(s0)
    8000555a:	00878713          	addi	a4,a5,8
    8000555e:	f8e43423          	sd	a4,-120(s0)
    80005562:	4601                	li	a2,0
    80005564:	45c1                	li	a1,16
    80005566:	6388                	ld	a0,0(a5)
    80005568:	e47ff0ef          	jal	800053ae <printint>
      i += 1;
    8000556c:	0029849b          	addiw	s1,s3,2
    80005570:	bfb1                	j	800054cc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005572:	f8843783          	ld	a5,-120(s0)
    80005576:	00878713          	addi	a4,a5,8
    8000557a:	f8e43423          	sd	a4,-120(s0)
    8000557e:	4605                	li	a2,1
    80005580:	45a9                	li	a1,10
    80005582:	6388                	ld	a0,0(a5)
    80005584:	e2bff0ef          	jal	800053ae <printint>
      i += 1;
    80005588:	0029849b          	addiw	s1,s3,2
    8000558c:	b781                	j	800054cc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000558e:	06400793          	li	a5,100
    80005592:	02f68863          	beq	a3,a5,800055c2 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005596:	07500793          	li	a5,117
    8000559a:	06f68c63          	beq	a3,a5,80005612 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000559e:	07800793          	li	a5,120
    800055a2:	f6f69fe3          	bne	a3,a5,80005520 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800055a6:	f8843783          	ld	a5,-120(s0)
    800055aa:	00878713          	addi	a4,a5,8
    800055ae:	f8e43423          	sd	a4,-120(s0)
    800055b2:	4601                	li	a2,0
    800055b4:	45c1                	li	a1,16
    800055b6:	6388                	ld	a0,0(a5)
    800055b8:	df7ff0ef          	jal	800053ae <printint>
      i += 2;
    800055bc:	0039849b          	addiw	s1,s3,3
    800055c0:	b731                	j	800054cc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800055c2:	f8843783          	ld	a5,-120(s0)
    800055c6:	00878713          	addi	a4,a5,8
    800055ca:	f8e43423          	sd	a4,-120(s0)
    800055ce:	4605                	li	a2,1
    800055d0:	45a9                	li	a1,10
    800055d2:	6388                	ld	a0,0(a5)
    800055d4:	ddbff0ef          	jal	800053ae <printint>
      i += 2;
    800055d8:	0039849b          	addiw	s1,s3,3
    800055dc:	bdc5                	j	800054cc <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800055de:	f8843783          	ld	a5,-120(s0)
    800055e2:	00878713          	addi	a4,a5,8
    800055e6:	f8e43423          	sd	a4,-120(s0)
    800055ea:	4601                	li	a2,0
    800055ec:	45a9                	li	a1,10
    800055ee:	4388                	lw	a0,0(a5)
    800055f0:	dbfff0ef          	jal	800053ae <printint>
    800055f4:	bde1                	j	800054cc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800055f6:	f8843783          	ld	a5,-120(s0)
    800055fa:	00878713          	addi	a4,a5,8
    800055fe:	f8e43423          	sd	a4,-120(s0)
    80005602:	4601                	li	a2,0
    80005604:	45a9                	li	a1,10
    80005606:	6388                	ld	a0,0(a5)
    80005608:	da7ff0ef          	jal	800053ae <printint>
      i += 1;
    8000560c:	0029849b          	addiw	s1,s3,2
    80005610:	bd75                	j	800054cc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005612:	f8843783          	ld	a5,-120(s0)
    80005616:	00878713          	addi	a4,a5,8
    8000561a:	f8e43423          	sd	a4,-120(s0)
    8000561e:	4601                	li	a2,0
    80005620:	45a9                	li	a1,10
    80005622:	6388                	ld	a0,0(a5)
    80005624:	d8bff0ef          	jal	800053ae <printint>
      i += 2;
    80005628:	0039849b          	addiw	s1,s3,3
    8000562c:	b545                	j	800054cc <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    8000562e:	f8843783          	ld	a5,-120(s0)
    80005632:	00878713          	addi	a4,a5,8
    80005636:	f8e43423          	sd	a4,-120(s0)
    8000563a:	4601                	li	a2,0
    8000563c:	45c1                	li	a1,16
    8000563e:	4388                	lw	a0,0(a5)
    80005640:	d6fff0ef          	jal	800053ae <printint>
    80005644:	b561                	j	800054cc <printf+0x8c>
    80005646:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005648:	f8843783          	ld	a5,-120(s0)
    8000564c:	00878713          	addi	a4,a5,8
    80005650:	f8e43423          	sd	a4,-120(s0)
    80005654:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005658:	03000513          	li	a0,48
    8000565c:	b63ff0ef          	jal	800051be <consputc>
  consputc('x');
    80005660:	07800513          	li	a0,120
    80005664:	b5bff0ef          	jal	800051be <consputc>
    80005668:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000566a:	00002b97          	auipc	s7,0x2
    8000566e:	436b8b93          	addi	s7,s7,1078 # 80007aa0 <digits>
    80005672:	03c9d793          	srli	a5,s3,0x3c
    80005676:	97de                	add	a5,a5,s7
    80005678:	0007c503          	lbu	a0,0(a5)
    8000567c:	b43ff0ef          	jal	800051be <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005680:	0992                	slli	s3,s3,0x4
    80005682:	397d                	addiw	s2,s2,-1
    80005684:	fe0917e3          	bnez	s2,80005672 <printf+0x232>
    80005688:	6ba6                	ld	s7,72(sp)
    8000568a:	b589                	j	800054cc <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000568c:	f8843783          	ld	a5,-120(s0)
    80005690:	00878713          	addi	a4,a5,8
    80005694:	f8e43423          	sd	a4,-120(s0)
    80005698:	0007b903          	ld	s2,0(a5)
    8000569c:	00090d63          	beqz	s2,800056b6 <printf+0x276>
      for(; *s; s++)
    800056a0:	00094503          	lbu	a0,0(s2)
    800056a4:	e20504e3          	beqz	a0,800054cc <printf+0x8c>
        consputc(*s);
    800056a8:	b17ff0ef          	jal	800051be <consputc>
      for(; *s; s++)
    800056ac:	0905                	addi	s2,s2,1
    800056ae:	00094503          	lbu	a0,0(s2)
    800056b2:	f97d                	bnez	a0,800056a8 <printf+0x268>
    800056b4:	bd21                	j	800054cc <printf+0x8c>
        s = "(null)";
    800056b6:	00002917          	auipc	s2,0x2
    800056ba:	16a90913          	addi	s2,s2,362 # 80007820 <etext+0x820>
      for(; *s; s++)
    800056be:	02800513          	li	a0,40
    800056c2:	b7dd                	j	800056a8 <printf+0x268>
      consputc('%');
    800056c4:	02500513          	li	a0,37
    800056c8:	af7ff0ef          	jal	800051be <consputc>
    800056cc:	b501                	j	800054cc <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800056ce:	f7843783          	ld	a5,-136(s0)
    800056d2:	e385                	bnez	a5,800056f2 <printf+0x2b2>
    800056d4:	74e6                	ld	s1,120(sp)
    800056d6:	7946                	ld	s2,112(sp)
    800056d8:	79a6                	ld	s3,104(sp)
    800056da:	6ae6                	ld	s5,88(sp)
    800056dc:	6b46                	ld	s6,80(sp)
    800056de:	6c06                	ld	s8,64(sp)
    800056e0:	7ce2                	ld	s9,56(sp)
    800056e2:	7d42                	ld	s10,48(sp)
    800056e4:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800056e6:	4501                	li	a0,0
    800056e8:	60aa                	ld	ra,136(sp)
    800056ea:	640a                	ld	s0,128(sp)
    800056ec:	7a06                	ld	s4,96(sp)
    800056ee:	6169                	addi	sp,sp,208
    800056f0:	8082                	ret
    800056f2:	74e6                	ld	s1,120(sp)
    800056f4:	7946                	ld	s2,112(sp)
    800056f6:	79a6                	ld	s3,104(sp)
    800056f8:	6ae6                	ld	s5,88(sp)
    800056fa:	6b46                	ld	s6,80(sp)
    800056fc:	6c06                	ld	s8,64(sp)
    800056fe:	7ce2                	ld	s9,56(sp)
    80005700:	7d42                	ld	s10,48(sp)
    80005702:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005704:	0001e517          	auipc	a0,0x1e
    80005708:	37450513          	addi	a0,a0,884 # 80023a78 <pr>
    8000570c:	3cc000ef          	jal	80005ad8 <release>
    80005710:	bfd9                	j	800056e6 <printf+0x2a6>

0000000080005712 <panic>:

void
panic(char *s)
{
    80005712:	1101                	addi	sp,sp,-32
    80005714:	ec06                	sd	ra,24(sp)
    80005716:	e822                	sd	s0,16(sp)
    80005718:	e426                	sd	s1,8(sp)
    8000571a:	1000                	addi	s0,sp,32
    8000571c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000571e:	0001e797          	auipc	a5,0x1e
    80005722:	3607a923          	sw	zero,882(a5) # 80023a90 <pr+0x18>
  printf("panic: ");
    80005726:	00002517          	auipc	a0,0x2
    8000572a:	10250513          	addi	a0,a0,258 # 80007828 <etext+0x828>
    8000572e:	d13ff0ef          	jal	80005440 <printf>
  printf("%s\n", s);
    80005732:	85a6                	mv	a1,s1
    80005734:	00002517          	auipc	a0,0x2
    80005738:	0fc50513          	addi	a0,a0,252 # 80007830 <etext+0x830>
    8000573c:	d05ff0ef          	jal	80005440 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005740:	4785                	li	a5,1
    80005742:	00005717          	auipc	a4,0x5
    80005746:	e0f72d23          	sw	a5,-486(a4) # 8000a55c <panicked>
  for(;;)
    8000574a:	a001                	j	8000574a <panic+0x38>

000000008000574c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000574c:	1101                	addi	sp,sp,-32
    8000574e:	ec06                	sd	ra,24(sp)
    80005750:	e822                	sd	s0,16(sp)
    80005752:	e426                	sd	s1,8(sp)
    80005754:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005756:	0001e497          	auipc	s1,0x1e
    8000575a:	32248493          	addi	s1,s1,802 # 80023a78 <pr>
    8000575e:	00002597          	auipc	a1,0x2
    80005762:	0da58593          	addi	a1,a1,218 # 80007838 <etext+0x838>
    80005766:	8526                	mv	a0,s1
    80005768:	258000ef          	jal	800059c0 <initlock>
  pr.locking = 1;
    8000576c:	4785                	li	a5,1
    8000576e:	cc9c                	sw	a5,24(s1)
}
    80005770:	60e2                	ld	ra,24(sp)
    80005772:	6442                	ld	s0,16(sp)
    80005774:	64a2                	ld	s1,8(sp)
    80005776:	6105                	addi	sp,sp,32
    80005778:	8082                	ret

000000008000577a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000577a:	1141                	addi	sp,sp,-16
    8000577c:	e406                	sd	ra,8(sp)
    8000577e:	e022                	sd	s0,0(sp)
    80005780:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005782:	100007b7          	lui	a5,0x10000
    80005786:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000578a:	10000737          	lui	a4,0x10000
    8000578e:	f8000693          	li	a3,-128
    80005792:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005796:	468d                	li	a3,3
    80005798:	10000637          	lui	a2,0x10000
    8000579c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800057a0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800057a4:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800057a8:	10000737          	lui	a4,0x10000
    800057ac:	461d                	li	a2,7
    800057ae:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800057b2:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800057b6:	00002597          	auipc	a1,0x2
    800057ba:	08a58593          	addi	a1,a1,138 # 80007840 <etext+0x840>
    800057be:	0001e517          	auipc	a0,0x1e
    800057c2:	2da50513          	addi	a0,a0,730 # 80023a98 <uart_tx_lock>
    800057c6:	1fa000ef          	jal	800059c0 <initlock>
}
    800057ca:	60a2                	ld	ra,8(sp)
    800057cc:	6402                	ld	s0,0(sp)
    800057ce:	0141                	addi	sp,sp,16
    800057d0:	8082                	ret

00000000800057d2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800057d2:	1101                	addi	sp,sp,-32
    800057d4:	ec06                	sd	ra,24(sp)
    800057d6:	e822                	sd	s0,16(sp)
    800057d8:	e426                	sd	s1,8(sp)
    800057da:	1000                	addi	s0,sp,32
    800057dc:	84aa                	mv	s1,a0
  push_off();
    800057de:	222000ef          	jal	80005a00 <push_off>

  if(panicked){
    800057e2:	00005797          	auipc	a5,0x5
    800057e6:	d7a7a783          	lw	a5,-646(a5) # 8000a55c <panicked>
    800057ea:	e795                	bnez	a5,80005816 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800057ec:	10000737          	lui	a4,0x10000
    800057f0:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800057f2:	00074783          	lbu	a5,0(a4)
    800057f6:	0207f793          	andi	a5,a5,32
    800057fa:	dfe5                	beqz	a5,800057f2 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800057fc:	0ff4f513          	zext.b	a0,s1
    80005800:	100007b7          	lui	a5,0x10000
    80005804:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005808:	27c000ef          	jal	80005a84 <pop_off>
}
    8000580c:	60e2                	ld	ra,24(sp)
    8000580e:	6442                	ld	s0,16(sp)
    80005810:	64a2                	ld	s1,8(sp)
    80005812:	6105                	addi	sp,sp,32
    80005814:	8082                	ret
    for(;;)
    80005816:	a001                	j	80005816 <uartputc_sync+0x44>

0000000080005818 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005818:	00005797          	auipc	a5,0x5
    8000581c:	d487b783          	ld	a5,-696(a5) # 8000a560 <uart_tx_r>
    80005820:	00005717          	auipc	a4,0x5
    80005824:	d4873703          	ld	a4,-696(a4) # 8000a568 <uart_tx_w>
    80005828:	08f70263          	beq	a4,a5,800058ac <uartstart+0x94>
{
    8000582c:	7139                	addi	sp,sp,-64
    8000582e:	fc06                	sd	ra,56(sp)
    80005830:	f822                	sd	s0,48(sp)
    80005832:	f426                	sd	s1,40(sp)
    80005834:	f04a                	sd	s2,32(sp)
    80005836:	ec4e                	sd	s3,24(sp)
    80005838:	e852                	sd	s4,16(sp)
    8000583a:	e456                	sd	s5,8(sp)
    8000583c:	e05a                	sd	s6,0(sp)
    8000583e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005840:	10000937          	lui	s2,0x10000
    80005844:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005846:	0001ea97          	auipc	s5,0x1e
    8000584a:	252a8a93          	addi	s5,s5,594 # 80023a98 <uart_tx_lock>
    uart_tx_r += 1;
    8000584e:	00005497          	auipc	s1,0x5
    80005852:	d1248493          	addi	s1,s1,-750 # 8000a560 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005856:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000585a:	00005997          	auipc	s3,0x5
    8000585e:	d0e98993          	addi	s3,s3,-754 # 8000a568 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005862:	00094703          	lbu	a4,0(s2)
    80005866:	02077713          	andi	a4,a4,32
    8000586a:	c71d                	beqz	a4,80005898 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000586c:	01f7f713          	andi	a4,a5,31
    80005870:	9756                	add	a4,a4,s5
    80005872:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005876:	0785                	addi	a5,a5,1
    80005878:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000587a:	8526                	mv	a0,s1
    8000587c:	b63fb0ef          	jal	800013de <wakeup>
    WriteReg(THR, c);
    80005880:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005884:	609c                	ld	a5,0(s1)
    80005886:	0009b703          	ld	a4,0(s3)
    8000588a:	fcf71ce3          	bne	a4,a5,80005862 <uartstart+0x4a>
      ReadReg(ISR);
    8000588e:	100007b7          	lui	a5,0x10000
    80005892:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005894:	0007c783          	lbu	a5,0(a5)
  }
}
    80005898:	70e2                	ld	ra,56(sp)
    8000589a:	7442                	ld	s0,48(sp)
    8000589c:	74a2                	ld	s1,40(sp)
    8000589e:	7902                	ld	s2,32(sp)
    800058a0:	69e2                	ld	s3,24(sp)
    800058a2:	6a42                	ld	s4,16(sp)
    800058a4:	6aa2                	ld	s5,8(sp)
    800058a6:	6b02                	ld	s6,0(sp)
    800058a8:	6121                	addi	sp,sp,64
    800058aa:	8082                	ret
      ReadReg(ISR);
    800058ac:	100007b7          	lui	a5,0x10000
    800058b0:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800058b2:	0007c783          	lbu	a5,0(a5)
      return;
    800058b6:	8082                	ret

00000000800058b8 <uartputc>:
{
    800058b8:	7179                	addi	sp,sp,-48
    800058ba:	f406                	sd	ra,40(sp)
    800058bc:	f022                	sd	s0,32(sp)
    800058be:	ec26                	sd	s1,24(sp)
    800058c0:	e84a                	sd	s2,16(sp)
    800058c2:	e44e                	sd	s3,8(sp)
    800058c4:	e052                	sd	s4,0(sp)
    800058c6:	1800                	addi	s0,sp,48
    800058c8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800058ca:	0001e517          	auipc	a0,0x1e
    800058ce:	1ce50513          	addi	a0,a0,462 # 80023a98 <uart_tx_lock>
    800058d2:	16e000ef          	jal	80005a40 <acquire>
  if(panicked){
    800058d6:	00005797          	auipc	a5,0x5
    800058da:	c867a783          	lw	a5,-890(a5) # 8000a55c <panicked>
    800058de:	efbd                	bnez	a5,8000595c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800058e0:	00005717          	auipc	a4,0x5
    800058e4:	c8873703          	ld	a4,-888(a4) # 8000a568 <uart_tx_w>
    800058e8:	00005797          	auipc	a5,0x5
    800058ec:	c787b783          	ld	a5,-904(a5) # 8000a560 <uart_tx_r>
    800058f0:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800058f4:	0001e997          	auipc	s3,0x1e
    800058f8:	1a498993          	addi	s3,s3,420 # 80023a98 <uart_tx_lock>
    800058fc:	00005497          	auipc	s1,0x5
    80005900:	c6448493          	addi	s1,s1,-924 # 8000a560 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005904:	00005917          	auipc	s2,0x5
    80005908:	c6490913          	addi	s2,s2,-924 # 8000a568 <uart_tx_w>
    8000590c:	00e79d63          	bne	a5,a4,80005926 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005910:	85ce                	mv	a1,s3
    80005912:	8526                	mv	a0,s1
    80005914:	a7ffb0ef          	jal	80001392 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005918:	00093703          	ld	a4,0(s2)
    8000591c:	609c                	ld	a5,0(s1)
    8000591e:	02078793          	addi	a5,a5,32
    80005922:	fee787e3          	beq	a5,a4,80005910 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005926:	0001e497          	auipc	s1,0x1e
    8000592a:	17248493          	addi	s1,s1,370 # 80023a98 <uart_tx_lock>
    8000592e:	01f77793          	andi	a5,a4,31
    80005932:	97a6                	add	a5,a5,s1
    80005934:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005938:	0705                	addi	a4,a4,1
    8000593a:	00005797          	auipc	a5,0x5
    8000593e:	c2e7b723          	sd	a4,-978(a5) # 8000a568 <uart_tx_w>
  uartstart();
    80005942:	ed7ff0ef          	jal	80005818 <uartstart>
  release(&uart_tx_lock);
    80005946:	8526                	mv	a0,s1
    80005948:	190000ef          	jal	80005ad8 <release>
}
    8000594c:	70a2                	ld	ra,40(sp)
    8000594e:	7402                	ld	s0,32(sp)
    80005950:	64e2                	ld	s1,24(sp)
    80005952:	6942                	ld	s2,16(sp)
    80005954:	69a2                	ld	s3,8(sp)
    80005956:	6a02                	ld	s4,0(sp)
    80005958:	6145                	addi	sp,sp,48
    8000595a:	8082                	ret
    for(;;)
    8000595c:	a001                	j	8000595c <uartputc+0xa4>

000000008000595e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000595e:	1141                	addi	sp,sp,-16
    80005960:	e422                	sd	s0,8(sp)
    80005962:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005964:	100007b7          	lui	a5,0x10000
    80005968:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000596a:	0007c783          	lbu	a5,0(a5)
    8000596e:	8b85                	andi	a5,a5,1
    80005970:	cb81                	beqz	a5,80005980 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005972:	100007b7          	lui	a5,0x10000
    80005976:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000597a:	6422                	ld	s0,8(sp)
    8000597c:	0141                	addi	sp,sp,16
    8000597e:	8082                	ret
    return -1;
    80005980:	557d                	li	a0,-1
    80005982:	bfe5                	j	8000597a <uartgetc+0x1c>

0000000080005984 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005984:	1101                	addi	sp,sp,-32
    80005986:	ec06                	sd	ra,24(sp)
    80005988:	e822                	sd	s0,16(sp)
    8000598a:	e426                	sd	s1,8(sp)
    8000598c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000598e:	54fd                	li	s1,-1
    80005990:	a019                	j	80005996 <uartintr+0x12>
      break;
    consoleintr(c);
    80005992:	85fff0ef          	jal	800051f0 <consoleintr>
    int c = uartgetc();
    80005996:	fc9ff0ef          	jal	8000595e <uartgetc>
    if(c == -1)
    8000599a:	fe951ce3          	bne	a0,s1,80005992 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000599e:	0001e497          	auipc	s1,0x1e
    800059a2:	0fa48493          	addi	s1,s1,250 # 80023a98 <uart_tx_lock>
    800059a6:	8526                	mv	a0,s1
    800059a8:	098000ef          	jal	80005a40 <acquire>
  uartstart();
    800059ac:	e6dff0ef          	jal	80005818 <uartstart>
  release(&uart_tx_lock);
    800059b0:	8526                	mv	a0,s1
    800059b2:	126000ef          	jal	80005ad8 <release>
}
    800059b6:	60e2                	ld	ra,24(sp)
    800059b8:	6442                	ld	s0,16(sp)
    800059ba:	64a2                	ld	s1,8(sp)
    800059bc:	6105                	addi	sp,sp,32
    800059be:	8082                	ret

00000000800059c0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800059c0:	1141                	addi	sp,sp,-16
    800059c2:	e422                	sd	s0,8(sp)
    800059c4:	0800                	addi	s0,sp,16
  lk->name = name;
    800059c6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800059c8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800059cc:	00053823          	sd	zero,16(a0)
}
    800059d0:	6422                	ld	s0,8(sp)
    800059d2:	0141                	addi	sp,sp,16
    800059d4:	8082                	ret

00000000800059d6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800059d6:	411c                	lw	a5,0(a0)
    800059d8:	e399                	bnez	a5,800059de <holding+0x8>
    800059da:	4501                	li	a0,0
  return r;
}
    800059dc:	8082                	ret
{
    800059de:	1101                	addi	sp,sp,-32
    800059e0:	ec06                	sd	ra,24(sp)
    800059e2:	e822                	sd	s0,16(sp)
    800059e4:	e426                	sd	s1,8(sp)
    800059e6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800059e8:	6904                	ld	s1,16(a0)
    800059ea:	bb6fb0ef          	jal	80000da0 <mycpu>
    800059ee:	40a48533          	sub	a0,s1,a0
    800059f2:	00153513          	seqz	a0,a0
}
    800059f6:	60e2                	ld	ra,24(sp)
    800059f8:	6442                	ld	s0,16(sp)
    800059fa:	64a2                	ld	s1,8(sp)
    800059fc:	6105                	addi	sp,sp,32
    800059fe:	8082                	ret

0000000080005a00 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005a00:	1101                	addi	sp,sp,-32
    80005a02:	ec06                	sd	ra,24(sp)
    80005a04:	e822                	sd	s0,16(sp)
    80005a06:	e426                	sd	s1,8(sp)
    80005a08:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a0a:	100024f3          	csrr	s1,sstatus
    80005a0e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005a12:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005a14:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005a18:	b88fb0ef          	jal	80000da0 <mycpu>
    80005a1c:	5d3c                	lw	a5,120(a0)
    80005a1e:	cb99                	beqz	a5,80005a34 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005a20:	b80fb0ef          	jal	80000da0 <mycpu>
    80005a24:	5d3c                	lw	a5,120(a0)
    80005a26:	2785                	addiw	a5,a5,1
    80005a28:	dd3c                	sw	a5,120(a0)
}
    80005a2a:	60e2                	ld	ra,24(sp)
    80005a2c:	6442                	ld	s0,16(sp)
    80005a2e:	64a2                	ld	s1,8(sp)
    80005a30:	6105                	addi	sp,sp,32
    80005a32:	8082                	ret
    mycpu()->intena = old;
    80005a34:	b6cfb0ef          	jal	80000da0 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005a38:	8085                	srli	s1,s1,0x1
    80005a3a:	8885                	andi	s1,s1,1
    80005a3c:	dd64                	sw	s1,124(a0)
    80005a3e:	b7cd                	j	80005a20 <push_off+0x20>

0000000080005a40 <acquire>:
{
    80005a40:	1101                	addi	sp,sp,-32
    80005a42:	ec06                	sd	ra,24(sp)
    80005a44:	e822                	sd	s0,16(sp)
    80005a46:	e426                	sd	s1,8(sp)
    80005a48:	1000                	addi	s0,sp,32
    80005a4a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005a4c:	fb5ff0ef          	jal	80005a00 <push_off>
  if(holding(lk))
    80005a50:	8526                	mv	a0,s1
    80005a52:	f85ff0ef          	jal	800059d6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005a56:	4705                	li	a4,1
  if(holding(lk))
    80005a58:	e105                	bnez	a0,80005a78 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005a5a:	87ba                	mv	a5,a4
    80005a5c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005a60:	2781                	sext.w	a5,a5
    80005a62:	ffe5                	bnez	a5,80005a5a <acquire+0x1a>
  __sync_synchronize();
    80005a64:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005a68:	b38fb0ef          	jal	80000da0 <mycpu>
    80005a6c:	e888                	sd	a0,16(s1)
}
    80005a6e:	60e2                	ld	ra,24(sp)
    80005a70:	6442                	ld	s0,16(sp)
    80005a72:	64a2                	ld	s1,8(sp)
    80005a74:	6105                	addi	sp,sp,32
    80005a76:	8082                	ret
    panic("acquire");
    80005a78:	00002517          	auipc	a0,0x2
    80005a7c:	dd050513          	addi	a0,a0,-560 # 80007848 <etext+0x848>
    80005a80:	c93ff0ef          	jal	80005712 <panic>

0000000080005a84 <pop_off>:

void
pop_off(void)
{
    80005a84:	1141                	addi	sp,sp,-16
    80005a86:	e406                	sd	ra,8(sp)
    80005a88:	e022                	sd	s0,0(sp)
    80005a8a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005a8c:	b14fb0ef          	jal	80000da0 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a90:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005a94:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005a96:	e78d                	bnez	a5,80005ac0 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005a98:	5d3c                	lw	a5,120(a0)
    80005a9a:	02f05963          	blez	a5,80005acc <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005a9e:	37fd                	addiw	a5,a5,-1
    80005aa0:	0007871b          	sext.w	a4,a5
    80005aa4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005aa6:	eb09                	bnez	a4,80005ab8 <pop_off+0x34>
    80005aa8:	5d7c                	lw	a5,124(a0)
    80005aaa:	c799                	beqz	a5,80005ab8 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005aac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005ab0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005ab4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005ab8:	60a2                	ld	ra,8(sp)
    80005aba:	6402                	ld	s0,0(sp)
    80005abc:	0141                	addi	sp,sp,16
    80005abe:	8082                	ret
    panic("pop_off - interruptible");
    80005ac0:	00002517          	auipc	a0,0x2
    80005ac4:	d9050513          	addi	a0,a0,-624 # 80007850 <etext+0x850>
    80005ac8:	c4bff0ef          	jal	80005712 <panic>
    panic("pop_off");
    80005acc:	00002517          	auipc	a0,0x2
    80005ad0:	d9c50513          	addi	a0,a0,-612 # 80007868 <etext+0x868>
    80005ad4:	c3fff0ef          	jal	80005712 <panic>

0000000080005ad8 <release>:
{
    80005ad8:	1101                	addi	sp,sp,-32
    80005ada:	ec06                	sd	ra,24(sp)
    80005adc:	e822                	sd	s0,16(sp)
    80005ade:	e426                	sd	s1,8(sp)
    80005ae0:	1000                	addi	s0,sp,32
    80005ae2:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005ae4:	ef3ff0ef          	jal	800059d6 <holding>
    80005ae8:	c105                	beqz	a0,80005b08 <release+0x30>
  lk->cpu = 0;
    80005aea:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005aee:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005af2:	0310000f          	fence	rw,w
    80005af6:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005afa:	f8bff0ef          	jal	80005a84 <pop_off>
}
    80005afe:	60e2                	ld	ra,24(sp)
    80005b00:	6442                	ld	s0,16(sp)
    80005b02:	64a2                	ld	s1,8(sp)
    80005b04:	6105                	addi	sp,sp,32
    80005b06:	8082                	ret
    panic("release");
    80005b08:	00002517          	auipc	a0,0x2
    80005b0c:	d6850513          	addi	a0,a0,-664 # 80007870 <etext+0x870>
    80005b10:	c03ff0ef          	jal	80005712 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
