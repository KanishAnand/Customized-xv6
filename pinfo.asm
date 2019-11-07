
_pinfo:     file format elf32-i386


Disassembly of section .text:

00000000 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	8b 45 08             	mov    0x8(%ebp),%eax
   7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
   a:	89 c2                	mov    %eax,%edx
   c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10:	83 c1 01             	add    $0x1,%ecx
  13:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  17:	83 c2 01             	add    $0x1,%edx
  1a:	84 db                	test   %bl,%bl
  1c:	88 5a ff             	mov    %bl,-0x1(%edx)
  1f:	75 ef                	jne    10 <strcpy+0x10>
    ;
  return os;
}
  21:	5b                   	pop    %ebx
  22:	5d                   	pop    %ebp
  23:	c3                   	ret    
  24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000030 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	53                   	push   %ebx
  34:	8b 55 08             	mov    0x8(%ebp),%edx
  37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  3a:	0f b6 02             	movzbl (%edx),%eax
  3d:	0f b6 19             	movzbl (%ecx),%ebx
  40:	84 c0                	test   %al,%al
  42:	75 1c                	jne    60 <strcmp+0x30>
  44:	eb 2a                	jmp    70 <strcmp+0x40>
  46:	8d 76 00             	lea    0x0(%esi),%esi
  49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
  50:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  53:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  56:	83 c1 01             	add    $0x1,%ecx
  59:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
  5c:	84 c0                	test   %al,%al
  5e:	74 10                	je     70 <strcmp+0x40>
  60:	38 d8                	cmp    %bl,%al
  62:	74 ec                	je     50 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  64:	29 d8                	sub    %ebx,%eax
}
  66:	5b                   	pop    %ebx
  67:	5d                   	pop    %ebp
  68:	c3                   	ret    
  69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  70:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  72:	29 d8                	sub    %ebx,%eax
}
  74:	5b                   	pop    %ebx
  75:	5d                   	pop    %ebp
  76:	c3                   	ret    
  77:	89 f6                	mov    %esi,%esi
  79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000080 <strlen>:

uint
strlen(const char *s)
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  86:	80 39 00             	cmpb   $0x0,(%ecx)
  89:	74 15                	je     a0 <strlen+0x20>
  8b:	31 d2                	xor    %edx,%edx
  8d:	8d 76 00             	lea    0x0(%esi),%esi
  90:	83 c2 01             	add    $0x1,%edx
  93:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  97:	89 d0                	mov    %edx,%eax
  99:	75 f5                	jne    90 <strlen+0x10>
    ;
  return n;
}
  9b:	5d                   	pop    %ebp
  9c:	c3                   	ret    
  9d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  a0:	31 c0                	xor    %eax,%eax
}
  a2:	5d                   	pop    %ebp
  a3:	c3                   	ret    
  a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	57                   	push   %edi
  b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  bd:	89 d7                	mov    %edx,%edi
  bf:	fc                   	cld    
  c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c2:	89 d0                	mov    %edx,%eax
  c4:	5f                   	pop    %edi
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    
  c7:	89 f6                	mov    %esi,%esi
  c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000d0 <strchr>:

char*
strchr(const char *s, char c)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	53                   	push   %ebx
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
  da:	0f b6 10             	movzbl (%eax),%edx
  dd:	84 d2                	test   %dl,%dl
  df:	74 1d                	je     fe <strchr+0x2e>
    if(*s == c)
  e1:	38 d3                	cmp    %dl,%bl
  e3:	89 d9                	mov    %ebx,%ecx
  e5:	75 0d                	jne    f4 <strchr+0x24>
  e7:	eb 17                	jmp    100 <strchr+0x30>
  e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  f0:	38 ca                	cmp    %cl,%dl
  f2:	74 0c                	je     100 <strchr+0x30>
  for(; *s; s++)
  f4:	83 c0 01             	add    $0x1,%eax
  f7:	0f b6 10             	movzbl (%eax),%edx
  fa:	84 d2                	test   %dl,%dl
  fc:	75 f2                	jne    f0 <strchr+0x20>
      return (char*)s;
  return 0;
  fe:	31 c0                	xor    %eax,%eax
}
 100:	5b                   	pop    %ebx
 101:	5d                   	pop    %ebp
 102:	c3                   	ret    
 103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000110 <gets>:

char*
gets(char *buf, int max)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	56                   	push   %esi
 115:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 116:	31 f6                	xor    %esi,%esi
 118:	89 f3                	mov    %esi,%ebx
{
 11a:	83 ec 1c             	sub    $0x1c,%esp
 11d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 120:	eb 2f                	jmp    151 <gets+0x41>
 122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 128:	8d 45 e7             	lea    -0x19(%ebp),%eax
 12b:	83 ec 04             	sub    $0x4,%esp
 12e:	6a 01                	push   $0x1
 130:	50                   	push   %eax
 131:	6a 00                	push   $0x0
 133:	e8 32 01 00 00       	call   26a <read>
    if(cc < 1)
 138:	83 c4 10             	add    $0x10,%esp
 13b:	85 c0                	test   %eax,%eax
 13d:	7e 1c                	jle    15b <gets+0x4b>
      break;
    buf[i++] = c;
 13f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 143:	83 c7 01             	add    $0x1,%edi
 146:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 149:	3c 0a                	cmp    $0xa,%al
 14b:	74 23                	je     170 <gets+0x60>
 14d:	3c 0d                	cmp    $0xd,%al
 14f:	74 1f                	je     170 <gets+0x60>
  for(i=0; i+1 < max; ){
 151:	83 c3 01             	add    $0x1,%ebx
 154:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 157:	89 fe                	mov    %edi,%esi
 159:	7c cd                	jl     128 <gets+0x18>
 15b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 160:	c6 03 00             	movb   $0x0,(%ebx)
}
 163:	8d 65 f4             	lea    -0xc(%ebp),%esp
 166:	5b                   	pop    %ebx
 167:	5e                   	pop    %esi
 168:	5f                   	pop    %edi
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    
 16b:	90                   	nop
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 170:	8b 75 08             	mov    0x8(%ebp),%esi
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	01 de                	add    %ebx,%esi
 178:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 17a:	c6 03 00             	movb   $0x0,(%ebx)
}
 17d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 180:	5b                   	pop    %ebx
 181:	5e                   	pop    %esi
 182:	5f                   	pop    %edi
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    
 185:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000190 <stat>:

int
stat(const char *n, struct stat *st)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	56                   	push   %esi
 194:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 195:	83 ec 08             	sub    $0x8,%esp
 198:	6a 00                	push   $0x0
 19a:	ff 75 08             	pushl  0x8(%ebp)
 19d:	e8 f0 00 00 00       	call   292 <open>
  if(fd < 0)
 1a2:	83 c4 10             	add    $0x10,%esp
 1a5:	85 c0                	test   %eax,%eax
 1a7:	78 27                	js     1d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1a9:	83 ec 08             	sub    $0x8,%esp
 1ac:	ff 75 0c             	pushl  0xc(%ebp)
 1af:	89 c3                	mov    %eax,%ebx
 1b1:	50                   	push   %eax
 1b2:	e8 f3 00 00 00       	call   2aa <fstat>
  close(fd);
 1b7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1ba:	89 c6                	mov    %eax,%esi
  close(fd);
 1bc:	e8 b9 00 00 00       	call   27a <close>
  return r;
 1c1:	83 c4 10             	add    $0x10,%esp
}
 1c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1c7:	89 f0                	mov    %esi,%eax
 1c9:	5b                   	pop    %ebx
 1ca:	5e                   	pop    %esi
 1cb:	5d                   	pop    %ebp
 1cc:	c3                   	ret    
 1cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1d5:	eb ed                	jmp    1c4 <stat+0x34>
 1d7:	89 f6                	mov    %esi,%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <atoi>:

int
atoi(const char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e7:	0f be 11             	movsbl (%ecx),%edx
 1ea:	8d 42 d0             	lea    -0x30(%edx),%eax
 1ed:	3c 09                	cmp    $0x9,%al
  n = 0;
 1ef:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 1f4:	77 1f                	ja     215 <atoi+0x35>
 1f6:	8d 76 00             	lea    0x0(%esi),%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 200:	8d 04 80             	lea    (%eax,%eax,4),%eax
 203:	83 c1 01             	add    $0x1,%ecx
 206:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 20a:	0f be 11             	movsbl (%ecx),%edx
 20d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 210:	80 fb 09             	cmp    $0x9,%bl
 213:	76 eb                	jbe    200 <atoi+0x20>
  return n;
}
 215:	5b                   	pop    %ebx
 216:	5d                   	pop    %ebp
 217:	c3                   	ret    
 218:	90                   	nop
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000220 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
 225:	8b 5d 10             	mov    0x10(%ebp),%ebx
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 22e:	85 db                	test   %ebx,%ebx
 230:	7e 14                	jle    246 <memmove+0x26>
 232:	31 d2                	xor    %edx,%edx
 234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 238:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 23c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 23f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 242:	39 d3                	cmp    %edx,%ebx
 244:	75 f2                	jne    238 <memmove+0x18>
  return vdst;
}
 246:	5b                   	pop    %ebx
 247:	5e                   	pop    %esi
 248:	5d                   	pop    %ebp
 249:	c3                   	ret    

0000024a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 24a:	b8 01 00 00 00       	mov    $0x1,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <exit>:
SYSCALL(exit)
 252:	b8 02 00 00 00       	mov    $0x2,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <wait>:
SYSCALL(wait)
 25a:	b8 03 00 00 00       	mov    $0x3,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <pipe>:
SYSCALL(pipe)
 262:	b8 04 00 00 00       	mov    $0x4,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <read>:
SYSCALL(read)
 26a:	b8 05 00 00 00       	mov    $0x5,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <write>:
SYSCALL(write)
 272:	b8 10 00 00 00       	mov    $0x10,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <close>:
SYSCALL(close)
 27a:	b8 15 00 00 00       	mov    $0x15,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <kill>:
SYSCALL(kill)
 282:	b8 06 00 00 00       	mov    $0x6,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <exec>:
SYSCALL(exec)
 28a:	b8 07 00 00 00       	mov    $0x7,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <open>:
SYSCALL(open)
 292:	b8 0f 00 00 00       	mov    $0xf,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <mknod>:
SYSCALL(mknod)
 29a:	b8 11 00 00 00       	mov    $0x11,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <unlink>:
SYSCALL(unlink)
 2a2:	b8 12 00 00 00       	mov    $0x12,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <fstat>:
SYSCALL(fstat)
 2aa:	b8 08 00 00 00       	mov    $0x8,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <link>:
SYSCALL(link)
 2b2:	b8 13 00 00 00       	mov    $0x13,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <mkdir>:
SYSCALL(mkdir)
 2ba:	b8 14 00 00 00       	mov    $0x14,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <chdir>:
SYSCALL(chdir)
 2c2:	b8 09 00 00 00       	mov    $0x9,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <dup>:
SYSCALL(dup)
 2ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <getpid>:
SYSCALL(getpid)
 2d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <sbrk>:
SYSCALL(sbrk)
 2da:	b8 0c 00 00 00       	mov    $0xc,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <sleep>:
SYSCALL(sleep)
 2e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <uptime>:
SYSCALL(uptime)
 2ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <waitx>:
SYSCALL(waitx)
 2f2:	b8 16 00 00 00       	mov    $0x16,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <set_priority>:
SYSCALL(set_priority)
 2fa:	b8 17 00 00 00       	mov    $0x17,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <getpinfo>:
SYSCALL(getpinfo)
 302:	b8 18 00 00 00       	mov    $0x18,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    
 30a:	66 90                	xchg   %ax,%ax
 30c:	66 90                	xchg   %ax,%ax
 30e:	66 90                	xchg   %ax,%ax

00000310 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	56                   	push   %esi
 315:	53                   	push   %ebx
 316:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 319:	85 d2                	test   %edx,%edx
{
 31b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 31e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 320:	79 76                	jns    398 <printint+0x88>
 322:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 326:	74 70                	je     398 <printint+0x88>
    x = -xx;
 328:	f7 d8                	neg    %eax
    neg = 1;
 32a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 331:	31 f6                	xor    %esi,%esi
 333:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 336:	eb 0a                	jmp    342 <printint+0x32>
 338:	90                   	nop
 339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 340:	89 fe                	mov    %edi,%esi
 342:	31 d2                	xor    %edx,%edx
 344:	8d 7e 01             	lea    0x1(%esi),%edi
 347:	f7 f1                	div    %ecx
 349:	0f b6 92 10 07 00 00 	movzbl 0x710(%edx),%edx
  }while((x /= base) != 0);
 350:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 352:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 355:	75 e9                	jne    340 <printint+0x30>
  if(neg)
 357:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 35a:	85 c0                	test   %eax,%eax
 35c:	74 08                	je     366 <printint+0x56>
    buf[i++] = '-';
 35e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 363:	8d 7e 02             	lea    0x2(%esi),%edi
 366:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 36a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 36d:	8d 76 00             	lea    0x0(%esi),%esi
 370:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 373:	83 ec 04             	sub    $0x4,%esp
 376:	83 ee 01             	sub    $0x1,%esi
 379:	6a 01                	push   $0x1
 37b:	53                   	push   %ebx
 37c:	57                   	push   %edi
 37d:	88 45 d7             	mov    %al,-0x29(%ebp)
 380:	e8 ed fe ff ff       	call   272 <write>

  while(--i >= 0)
 385:	83 c4 10             	add    $0x10,%esp
 388:	39 de                	cmp    %ebx,%esi
 38a:	75 e4                	jne    370 <printint+0x60>
    putc(fd, buf[i]);
}
 38c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 38f:	5b                   	pop    %ebx
 390:	5e                   	pop    %esi
 391:	5f                   	pop    %edi
 392:	5d                   	pop    %ebp
 393:	c3                   	ret    
 394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 398:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 39f:	eb 90                	jmp    331 <printint+0x21>
 3a1:	eb 0d                	jmp    3b0 <printf>
 3a3:	90                   	nop
 3a4:	90                   	nop
 3a5:	90                   	nop
 3a6:	90                   	nop
 3a7:	90                   	nop
 3a8:	90                   	nop
 3a9:	90                   	nop
 3aa:	90                   	nop
 3ab:	90                   	nop
 3ac:	90                   	nop
 3ad:	90                   	nop
 3ae:	90                   	nop
 3af:	90                   	nop

000003b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
 3b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3b9:	8b 75 0c             	mov    0xc(%ebp),%esi
 3bc:	0f b6 1e             	movzbl (%esi),%ebx
 3bf:	84 db                	test   %bl,%bl
 3c1:	0f 84 b3 00 00 00    	je     47a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 3c7:	8d 45 10             	lea    0x10(%ebp),%eax
 3ca:	83 c6 01             	add    $0x1,%esi
  state = 0;
 3cd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 3cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3d2:	eb 2f                	jmp    403 <printf+0x53>
 3d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3d8:	83 f8 25             	cmp    $0x25,%eax
 3db:	0f 84 a7 00 00 00    	je     488 <printf+0xd8>
  write(fd, &c, 1);
 3e1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3e4:	83 ec 04             	sub    $0x4,%esp
 3e7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 3ea:	6a 01                	push   $0x1
 3ec:	50                   	push   %eax
 3ed:	ff 75 08             	pushl  0x8(%ebp)
 3f0:	e8 7d fe ff ff       	call   272 <write>
 3f5:	83 c4 10             	add    $0x10,%esp
 3f8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 3fb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 3ff:	84 db                	test   %bl,%bl
 401:	74 77                	je     47a <printf+0xca>
    if(state == 0){
 403:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 405:	0f be cb             	movsbl %bl,%ecx
 408:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 40b:	74 cb                	je     3d8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 40d:	83 ff 25             	cmp    $0x25,%edi
 410:	75 e6                	jne    3f8 <printf+0x48>
      if(c == 'd'){
 412:	83 f8 64             	cmp    $0x64,%eax
 415:	0f 84 05 01 00 00    	je     520 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 41b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 421:	83 f9 70             	cmp    $0x70,%ecx
 424:	74 72                	je     498 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 426:	83 f8 73             	cmp    $0x73,%eax
 429:	0f 84 99 00 00 00    	je     4c8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 42f:	83 f8 63             	cmp    $0x63,%eax
 432:	0f 84 08 01 00 00    	je     540 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 438:	83 f8 25             	cmp    $0x25,%eax
 43b:	0f 84 ef 00 00 00    	je     530 <printf+0x180>
  write(fd, &c, 1);
 441:	8d 45 e7             	lea    -0x19(%ebp),%eax
 444:	83 ec 04             	sub    $0x4,%esp
 447:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 44b:	6a 01                	push   $0x1
 44d:	50                   	push   %eax
 44e:	ff 75 08             	pushl  0x8(%ebp)
 451:	e8 1c fe ff ff       	call   272 <write>
 456:	83 c4 0c             	add    $0xc,%esp
 459:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 45c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 45f:	6a 01                	push   $0x1
 461:	50                   	push   %eax
 462:	ff 75 08             	pushl  0x8(%ebp)
 465:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 468:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 46a:	e8 03 fe ff ff       	call   272 <write>
  for(i = 0; fmt[i]; i++){
 46f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 473:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 476:	84 db                	test   %bl,%bl
 478:	75 89                	jne    403 <printf+0x53>
    }
  }
}
 47a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 47d:	5b                   	pop    %ebx
 47e:	5e                   	pop    %esi
 47f:	5f                   	pop    %edi
 480:	5d                   	pop    %ebp
 481:	c3                   	ret    
 482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 488:	bf 25 00 00 00       	mov    $0x25,%edi
 48d:	e9 66 ff ff ff       	jmp    3f8 <printf+0x48>
 492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 498:	83 ec 0c             	sub    $0xc,%esp
 49b:	b9 10 00 00 00       	mov    $0x10,%ecx
 4a0:	6a 00                	push   $0x0
 4a2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	8b 17                	mov    (%edi),%edx
 4aa:	e8 61 fe ff ff       	call   310 <printint>
        ap++;
 4af:	89 f8                	mov    %edi,%eax
 4b1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4b4:	31 ff                	xor    %edi,%edi
        ap++;
 4b6:	83 c0 04             	add    $0x4,%eax
 4b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4bc:	e9 37 ff ff ff       	jmp    3f8 <printf+0x48>
 4c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 4c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4cb:	8b 08                	mov    (%eax),%ecx
        ap++;
 4cd:	83 c0 04             	add    $0x4,%eax
 4d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 4d3:	85 c9                	test   %ecx,%ecx
 4d5:	0f 84 8e 00 00 00    	je     569 <printf+0x1b9>
        while(*s != 0){
 4db:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 4de:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 4e0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 4e2:	84 c0                	test   %al,%al
 4e4:	0f 84 0e ff ff ff    	je     3f8 <printf+0x48>
 4ea:	89 75 d0             	mov    %esi,-0x30(%ebp)
 4ed:	89 de                	mov    %ebx,%esi
 4ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4f2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 4f5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 4f8:	83 ec 04             	sub    $0x4,%esp
          s++;
 4fb:	83 c6 01             	add    $0x1,%esi
 4fe:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 501:	6a 01                	push   $0x1
 503:	57                   	push   %edi
 504:	53                   	push   %ebx
 505:	e8 68 fd ff ff       	call   272 <write>
        while(*s != 0){
 50a:	0f b6 06             	movzbl (%esi),%eax
 50d:	83 c4 10             	add    $0x10,%esp
 510:	84 c0                	test   %al,%al
 512:	75 e4                	jne    4f8 <printf+0x148>
 514:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 517:	31 ff                	xor    %edi,%edi
 519:	e9 da fe ff ff       	jmp    3f8 <printf+0x48>
 51e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 520:	83 ec 0c             	sub    $0xc,%esp
 523:	b9 0a 00 00 00       	mov    $0xa,%ecx
 528:	6a 01                	push   $0x1
 52a:	e9 73 ff ff ff       	jmp    4a2 <printf+0xf2>
 52f:	90                   	nop
  write(fd, &c, 1);
 530:	83 ec 04             	sub    $0x4,%esp
 533:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 536:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 539:	6a 01                	push   $0x1
 53b:	e9 21 ff ff ff       	jmp    461 <printf+0xb1>
        putc(fd, *ap);
 540:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 543:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 546:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 548:	6a 01                	push   $0x1
        ap++;
 54a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 54d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 550:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 553:	50                   	push   %eax
 554:	ff 75 08             	pushl  0x8(%ebp)
 557:	e8 16 fd ff ff       	call   272 <write>
        ap++;
 55c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 55f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 562:	31 ff                	xor    %edi,%edi
 564:	e9 8f fe ff ff       	jmp    3f8 <printf+0x48>
          s = "(null)";
 569:	bb 08 07 00 00       	mov    $0x708,%ebx
        while(*s != 0){
 56e:	b8 28 00 00 00       	mov    $0x28,%eax
 573:	e9 72 ff ff ff       	jmp    4ea <printf+0x13a>
 578:	66 90                	xchg   %ax,%ax
 57a:	66 90                	xchg   %ax,%ax
 57c:	66 90                	xchg   %ax,%ax
 57e:	66 90                	xchg   %ax,%ax

00000580 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 580:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 581:	a1 a0 09 00 00       	mov    0x9a0,%eax
{
 586:	89 e5                	mov    %esp,%ebp
 588:	57                   	push   %edi
 589:	56                   	push   %esi
 58a:	53                   	push   %ebx
 58b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 58e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 598:	39 c8                	cmp    %ecx,%eax
 59a:	8b 10                	mov    (%eax),%edx
 59c:	73 32                	jae    5d0 <free+0x50>
 59e:	39 d1                	cmp    %edx,%ecx
 5a0:	72 04                	jb     5a6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a2:	39 d0                	cmp    %edx,%eax
 5a4:	72 32                	jb     5d8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5a6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5a9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ac:	39 fa                	cmp    %edi,%edx
 5ae:	74 30                	je     5e0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5b0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5b3:	8b 50 04             	mov    0x4(%eax),%edx
 5b6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5b9:	39 f1                	cmp    %esi,%ecx
 5bb:	74 3a                	je     5f7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5bd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5bf:	a3 a0 09 00 00       	mov    %eax,0x9a0
}
 5c4:	5b                   	pop    %ebx
 5c5:	5e                   	pop    %esi
 5c6:	5f                   	pop    %edi
 5c7:	5d                   	pop    %ebp
 5c8:	c3                   	ret    
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d0:	39 d0                	cmp    %edx,%eax
 5d2:	72 04                	jb     5d8 <free+0x58>
 5d4:	39 d1                	cmp    %edx,%ecx
 5d6:	72 ce                	jb     5a6 <free+0x26>
{
 5d8:	89 d0                	mov    %edx,%eax
 5da:	eb bc                	jmp    598 <free+0x18>
 5dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 5e0:	03 72 04             	add    0x4(%edx),%esi
 5e3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5e6:	8b 10                	mov    (%eax),%edx
 5e8:	8b 12                	mov    (%edx),%edx
 5ea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ed:	8b 50 04             	mov    0x4(%eax),%edx
 5f0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5f3:	39 f1                	cmp    %esi,%ecx
 5f5:	75 c6                	jne    5bd <free+0x3d>
    p->s.size += bp->s.size;
 5f7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 5fa:	a3 a0 09 00 00       	mov    %eax,0x9a0
    p->s.size += bp->s.size;
 5ff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 602:	8b 53 f8             	mov    -0x8(%ebx),%edx
 605:	89 10                	mov    %edx,(%eax)
}
 607:	5b                   	pop    %ebx
 608:	5e                   	pop    %esi
 609:	5f                   	pop    %edi
 60a:	5d                   	pop    %ebp
 60b:	c3                   	ret    
 60c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000610 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
 616:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 619:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 61c:	8b 15 a0 09 00 00    	mov    0x9a0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 622:	8d 78 07             	lea    0x7(%eax),%edi
 625:	c1 ef 03             	shr    $0x3,%edi
 628:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 62b:	85 d2                	test   %edx,%edx
 62d:	0f 84 9d 00 00 00    	je     6d0 <malloc+0xc0>
 633:	8b 02                	mov    (%edx),%eax
 635:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 638:	39 cf                	cmp    %ecx,%edi
 63a:	76 6c                	jbe    6a8 <malloc+0x98>
 63c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 642:	bb 00 10 00 00       	mov    $0x1000,%ebx
 647:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 64a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 651:	eb 0e                	jmp    661 <malloc+0x51>
 653:	90                   	nop
 654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 658:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 65a:	8b 48 04             	mov    0x4(%eax),%ecx
 65d:	39 f9                	cmp    %edi,%ecx
 65f:	73 47                	jae    6a8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 661:	39 05 a0 09 00 00    	cmp    %eax,0x9a0
 667:	89 c2                	mov    %eax,%edx
 669:	75 ed                	jne    658 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 66b:	83 ec 0c             	sub    $0xc,%esp
 66e:	56                   	push   %esi
 66f:	e8 66 fc ff ff       	call   2da <sbrk>
  if(p == (char*)-1)
 674:	83 c4 10             	add    $0x10,%esp
 677:	83 f8 ff             	cmp    $0xffffffff,%eax
 67a:	74 1c                	je     698 <malloc+0x88>
  hp->s.size = nu;
 67c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 67f:	83 ec 0c             	sub    $0xc,%esp
 682:	83 c0 08             	add    $0x8,%eax
 685:	50                   	push   %eax
 686:	e8 f5 fe ff ff       	call   580 <free>
  return freep;
 68b:	8b 15 a0 09 00 00    	mov    0x9a0,%edx
      if((p = morecore(nunits)) == 0)
 691:	83 c4 10             	add    $0x10,%esp
 694:	85 d2                	test   %edx,%edx
 696:	75 c0                	jne    658 <malloc+0x48>
        return 0;
  }
}
 698:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 69b:	31 c0                	xor    %eax,%eax
}
 69d:	5b                   	pop    %ebx
 69e:	5e                   	pop    %esi
 69f:	5f                   	pop    %edi
 6a0:	5d                   	pop    %ebp
 6a1:	c3                   	ret    
 6a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 6a8:	39 cf                	cmp    %ecx,%edi
 6aa:	74 54                	je     700 <malloc+0xf0>
        p->s.size -= nunits;
 6ac:	29 f9                	sub    %edi,%ecx
 6ae:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6b1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6b4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6b7:	89 15 a0 09 00 00    	mov    %edx,0x9a0
}
 6bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 6c0:	83 c0 08             	add    $0x8,%eax
}
 6c3:	5b                   	pop    %ebx
 6c4:	5e                   	pop    %esi
 6c5:	5f                   	pop    %edi
 6c6:	5d                   	pop    %ebp
 6c7:	c3                   	ret    
 6c8:	90                   	nop
 6c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 6d0:	c7 05 a0 09 00 00 a4 	movl   $0x9a4,0x9a0
 6d7:	09 00 00 
 6da:	c7 05 a4 09 00 00 a4 	movl   $0x9a4,0x9a4
 6e1:	09 00 00 
    base.s.size = 0;
 6e4:	b8 a4 09 00 00       	mov    $0x9a4,%eax
 6e9:	c7 05 a8 09 00 00 00 	movl   $0x0,0x9a8
 6f0:	00 00 00 
 6f3:	e9 44 ff ff ff       	jmp    63c <malloc+0x2c>
 6f8:	90                   	nop
 6f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 700:	8b 08                	mov    (%eax),%ecx
 702:	89 0a                	mov    %ecx,(%edx)
 704:	eb b1                	jmp    6b7 <malloc+0xa7>
