
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 60 d6 10 80       	mov    $0x8010d660,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 94 d6 10 80       	mov    $0x8010d694,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 85 10 80       	push   $0x80108580
80100051:	68 60 d6 10 80       	push   $0x8010d660
80100056:	e8 65 4f 00 00       	call   80104fc0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 ac 1d 11 80 5c 	movl   $0x80111d5c,0x80111dac
80100062:	1d 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 b0 1d 11 80 5c 	movl   $0x80111d5c,0x80111db0
8010006c:	1d 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba 5c 1d 11 80       	mov    $0x80111d5c,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 5c 1d 11 80 	movl   $0x80111d5c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 85 10 80       	push   $0x80108587
80100097:	50                   	push   %eax
80100098:	e8 f3 4d 00 00       	call   80104e90 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 b0 1d 11 80       	mov    0x80111db0,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d b0 1d 11 80    	mov    %ebx,0x80111db0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 5c 1d 11 80       	cmp    $0x80111d5c,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 60 d6 10 80       	push   $0x8010d660
801000e4:	e8 17 50 00 00       	call   80105100 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d b0 1d 11 80    	mov    0x80111db0,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 5c 1d 11 80    	cmp    $0x80111d5c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 5c 1d 11 80    	cmp    $0x80111d5c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d ac 1d 11 80    	mov    0x80111dac,%ebx
80100126:	81 fb 5c 1d 11 80    	cmp    $0x80111d5c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 5c 1d 11 80    	cmp    $0x80111d5c,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 60 d6 10 80       	push   $0x8010d660
80100162:	e8 59 50 00 00       	call   801051c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 4d 00 00       	call   80104ed0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 8e 85 10 80       	push   $0x8010858e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 bd 4d 00 00       	call   80104f70 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 85 10 80       	push   $0x8010859f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 7c 4d 00 00       	call   80104f70 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 4d 00 00       	call   80104f30 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 60 d6 10 80 	movl   $0x8010d660,(%esp)
8010020b:	e8 f0 4e 00 00       	call   80105100 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 b0 1d 11 80       	mov    0x80111db0,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 5c 1d 11 80 	movl   $0x80111d5c,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 b0 1d 11 80       	mov    0x80111db0,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d b0 1d 11 80    	mov    %ebx,0x80111db0
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 60 d6 10 80 	movl   $0x8010d660,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 5f 4f 00 00       	jmp    801051c0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 85 10 80       	push   $0x801085a6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 80 c5 10 80 	movl   $0x8010c580,(%esp)
8010028c:	e8 6f 4e 00 00       	call   80105100 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 40 73 18 80    	mov    0x80187340,%edx
801002a7:	39 15 44 73 18 80    	cmp    %edx,0x80187344
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 80 c5 10 80       	push   $0x8010c580
801002c0:	68 40 73 18 80       	push   $0x80187340
801002c5:	e8 b6 45 00 00       	call   80104880 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 40 73 18 80    	mov    0x80187340,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 44 73 18 80    	cmp    0x80187344,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 40 37 00 00       	call   80103a20 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 80 c5 10 80       	push   $0x8010c580
801002ef:	e8 cc 4e 00 00       	call   801051c0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 40 73 18 80       	mov    %eax,0x80187340
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 c0 72 18 80 	movsbl -0x7fe78d40(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 80 c5 10 80       	push   $0x8010c580
8010034d:	e8 6e 4e 00 00       	call   801051c0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 40 73 18 80    	mov    %edx,0x80187340
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 b4 c5 10 80 00 	movl   $0x0,0x8010c5b4
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ad 85 10 80       	push   $0x801085ad
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 0b 91 10 80 	movl   $0x8010910b,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 03 4c 00 00       	call   80104fe0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 85 10 80       	push   $0x801085c1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 b8 c5 10 80 01 	movl   $0x1,0x8010c5b8
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 41 6d 00 00       	call   80107180 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 8f 6c 00 00       	call   80107180 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 83 6c 00 00       	call   80107180 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 77 6c 00 00       	call   80107180 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 97 4d 00 00       	call   801052c0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 ca 4c 00 00       	call   80105210 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 c5 85 10 80       	push   $0x801085c5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 f0 85 10 80 	movzbl -0x7fef7a10(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 80 c5 10 80 	movl   $0x8010c580,(%esp)
8010061b:	e8 e0 4a 00 00       	call   80105100 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 80 c5 10 80       	push   $0x8010c580
80100647:	e8 74 4b 00 00       	call   801051c0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 b4 c5 10 80       	mov    0x8010c5b4,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 80 c5 10 80       	push   $0x8010c580
8010071f:	e8 9c 4a 00 00       	call   801051c0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba d8 85 10 80       	mov    $0x801085d8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 80 c5 10 80       	push   $0x8010c580
801007f0:	e8 0b 49 00 00       	call   80105100 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 df 85 10 80       	push   $0x801085df
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 80 c5 10 80       	push   $0x8010c580
80100823:	e8 d8 48 00 00       	call   80105100 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 48 73 18 80       	mov    0x80187348,%eax
80100856:	3b 05 44 73 18 80    	cmp    0x80187344,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 48 73 18 80       	mov    %eax,0x80187348
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 80 c5 10 80       	push   $0x8010c580
80100888:	e8 33 49 00 00       	call   801051c0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 48 73 18 80       	mov    0x80187348,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 40 73 18 80    	sub    0x80187340,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 48 73 18 80    	mov    %edx,0x80187348
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 c0 72 18 80    	mov    %cl,-0x7fe78d40(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 40 73 18 80       	mov    0x80187340,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 48 73 18 80    	cmp    %eax,0x80187348
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 44 73 18 80       	mov    %eax,0x80187344
          wakeup(&input.r);
80100911:	68 40 73 18 80       	push   $0x80187340
80100916:	e8 45 42 00 00       	call   80104b60 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 48 73 18 80       	mov    0x80187348,%eax
8010093d:	39 05 44 73 18 80    	cmp    %eax,0x80187344
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 48 73 18 80       	mov    %eax,0x80187348
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 48 73 18 80       	mov    0x80187348,%eax
80100964:	3b 05 44 73 18 80    	cmp    0x80187344,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba c0 72 18 80 0a 	cmpb   $0xa,-0x7fe78d40(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 a4 42 00 00       	jmp    80104c40 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 c0 72 18 80 0a 	movb   $0xa,-0x7fe78d40(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 48 73 18 80       	mov    0x80187348,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 e8 85 10 80       	push   $0x801085e8
801009cb:	68 80 c5 10 80       	push   $0x8010c580
801009d0:	e8 eb 45 00 00       	call   80104fc0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 0c 7d 18 80 00 	movl   $0x80100600,0x80187d0c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 08 7d 18 80 70 	movl   $0x80100270,0x80187d08
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 b4 c5 10 80 01 	movl   $0x1,0x8010c5b4
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 ff 2f 00 00       	call   80103a20 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 21 00 00       	call   80102ba0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 9c 21 00 00       	call   80102c10 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 37 78 00 00       	call   801082d0 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 f5 75 00 00       	call   801080f0 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 03 75 00 00       	call   80108030 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 d9 76 00 00       	call   80108250 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 71 20 00 00       	call   80102c10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 41 75 00 00       	call   801080f0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 8a 76 00 00       	call   80108250 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 01 86 10 80       	push   $0x80108601
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 65 77 00 00       	call   80108370 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 f2 47 00 00       	call   80105430 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 df 47 00 00       	call   80105430 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 6e 78 00 00       	call   801084d0 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 04 78 00 00       	call   801084d0 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 e1 46 00 00       	call   801053f0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 67 71 00 00       	call   80107ea0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 0f 75 00 00       	call   80108250 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 0d 86 10 80       	push   $0x8010860d
80100d6b:	68 60 73 18 80       	push   $0x80187360
80100d70:	e8 4b 42 00 00       	call   80104fc0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 94 73 18 80       	mov    $0x80187394,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 60 73 18 80       	push   $0x80187360
80100d91:	e8 6a 43 00 00       	call   80105100 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb f4 7c 18 80    	cmp    $0x80187cf4,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 60 73 18 80       	push   $0x80187360
80100dc1:	e8 fa 43 00 00       	call   801051c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 60 73 18 80       	push   $0x80187360
80100dda:	e8 e1 43 00 00       	call   801051c0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 60 73 18 80       	push   $0x80187360
80100dff:	e8 fc 42 00 00       	call   80105100 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 60 73 18 80       	push   $0x80187360
80100e1c:	e8 9f 43 00 00       	call   801051c0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 14 86 10 80       	push   $0x80108614
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 60 73 18 80       	push   $0x80187360
80100e51:	e8 aa 42 00 00       	call   80105100 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 60 73 18 80 	movl   $0x80187360,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 3f 43 00 00       	jmp    801051c0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 60 73 18 80       	push   $0x80187360
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 13 43 00 00       	call   801051c0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 7a 24 00 00       	call   80103350 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 bb 1c 00 00       	call   80102ba0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 11 1d 00 00       	jmp    80102c10 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 1c 86 10 80       	push   $0x8010861c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 2e 25 00 00       	jmp    80103500 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 26 86 10 80       	push   $0x80108626
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 c2 1b 00 00       	call   80102c10 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 25 1b 00 00       	call   80102ba0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 5e 1b 00 00       	call   80102c10 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 fe 22 00 00       	jmp    801033f0 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 2f 86 10 80       	push   $0x8010862f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 35 86 10 80       	push   $0x80108635
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 78 7d 18 80    	add    0x80187d78,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 12 1c 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 3f 86 10 80       	push   $0x8010863f
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d 60 7d 18 80    	mov    0x80187d60,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 78 7d 18 80    	add    0x80187d78,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 60 7d 18 80       	mov    0x80187d60,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 60 7d 18 80    	cmp    %eax,0x80187d60
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 52 86 10 80       	push   $0x80108652
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 2e 1b 00 00       	call   80102d70 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 a6 3f 00 00       	call   80105210 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 fe 1a 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb b4 7d 18 80       	mov    $0x80187db4,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 80 7d 18 80       	push   $0x80187d80
801012aa:	e8 51 3e 00 00       	call   80105100 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb d4 99 18 80    	cmp    $0x801899d4,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb d4 99 18 80    	cmp    $0x801899d4,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 80 7d 18 80       	push   $0x80187d80
8010130f:	e8 ac 3e 00 00       	call   801051c0 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 80 7d 18 80       	push   $0x80187d80
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 7e 3e 00 00       	call   801051c0 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 68 86 10 80       	push   $0x80108668
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 9d 19 00 00       	call   80102d70 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 78 86 10 80       	push   $0x80108678
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 5a 3e 00 00       	call   801052c0 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb c0 7d 18 80       	mov    $0x80187dc0,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 8b 86 10 80       	push   $0x8010868b
80101491:	68 80 7d 18 80       	push   $0x80187d80
80101496:	e8 25 3b 00 00       	call   80104fc0 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 92 86 10 80       	push   $0x80108692
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 dc 39 00 00       	call   80104e90 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb e0 99 18 80    	cmp    $0x801899e0,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 60 7d 18 80       	push   $0x80187d60
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 78 7d 18 80    	pushl  0x80187d78
801014d5:	ff 35 74 7d 18 80    	pushl  0x80187d74
801014db:	ff 35 70 7d 18 80    	pushl  0x80187d70
801014e1:	ff 35 6c 7d 18 80    	pushl  0x80187d6c
801014e7:	ff 35 68 7d 18 80    	pushl  0x80187d68
801014ed:	ff 35 64 7d 18 80    	pushl  0x80187d64
801014f3:	ff 35 60 7d 18 80    	pushl  0x80187d60
801014f9:	68 f8 86 10 80       	push   $0x801086f8
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d 68 7d 18 80 01 	cmpl   $0x1,0x80187d68
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d 68 7d 18 80    	cmp    %ebx,0x80187d68
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 74 7d 18 80    	add    0x80187d74,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 7d 3c 00 00       	call   80105210 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 cb 17 00 00       	call   80102d70 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 98 86 10 80       	push   $0x80108698
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 74 7d 18 80    	add    0x80187d74,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 8a 3c 00 00       	call   801052c0 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 32 17 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 80 7d 18 80       	push   $0x80187d80
8010165f:	e8 9c 3a 00 00       	call   80105100 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 80 7d 18 80 	movl   $0x80187d80,(%esp)
8010166f:	e8 4c 3b 00 00       	call   801051c0 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 29 38 00 00       	call   80104ed0 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 74 7d 18 80    	add    0x80187d74,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 a3 3b 00 00       	call   801052c0 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 b0 86 10 80       	push   $0x801086b0
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 aa 86 10 80       	push   $0x801086aa
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 f8 37 00 00       	call   80104f70 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 9c 37 00 00       	jmp    80104f30 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 bf 86 10 80       	push   $0x801086bf
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 0b 37 00 00       	call   80104ed0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 51 37 00 00       	call   80104f30 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 80 7d 18 80 	movl   $0x80187d80,(%esp)
801017e6:	e8 15 39 00 00       	call   80105100 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 80 7d 18 80 	movl   $0x80187d80,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 bb 39 00 00       	jmp    801051c0 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 80 7d 18 80       	push   $0x80187d80
80101810:	e8 eb 38 00 00       	call   80105100 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 80 7d 18 80 	movl   $0x80187d80,(%esp)
8010181f:	e8 9c 39 00 00       	call   801051c0 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a07:	e8 b4 38 00 00       	call   801052c0 <memmove>
    brelse(bp);
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
  }
  return n;
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 00 7d 18 80 	mov    -0x7fe78300(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
      return -1;
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b02:	50                   	push   %eax
80101b03:	e8 b8 37 00 00       	call   801052c0 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 60 12 00 00       	call   80102d70 <log_write>
    brelse(bp);
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 04 7d 18 80 	mov    -0x7fe782fc(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 8d 37 00 00       	call   80105330 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 2e 37 00 00       	call   80105330 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c14:	31 c0                	xor    %eax,%eax
}
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
        *poff = off;
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
}
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
      panic("dirlookup read");
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 d9 86 10 80       	push   $0x801086d9
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 c7 86 10 80       	push   $0x801086c7
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 a2 1d 00 00       	call   80103a20 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 80 7d 18 80       	push   $0x80187d80
80101c89:	e8 72 34 00 00       	call   80105100 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 80 7d 18 80 	movl   $0x80187d80,(%esp)
80101c99:	e8 22 35 00 00       	call   801051c0 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ca8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
  if(*path == 0)
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
    path++;
80101cd4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 c6 35 00 00       	call   801052c0 <memmove>
    path++;
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101cfd:	83 c4 10             	add    $0x10,%esp
    path++;
80101d00:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
  iunlock(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 33 35 00 00       	call   801052c0 <memmove>
    name[len] = 0;
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101dc9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dcc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
      return 0;
80101dd3:	83 c4 10             	add    $0x10,%esp
}
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
      iunlock(ip);
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
      return ip;
80101dff:	83 c4 10             	add    $0x10,%esp
}
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
    iput(ip);
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
    return 0;
80101e10:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 0e 35 00 00       	call   80105390 <strncpy>
  de.inum = inum;
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
  de.inum = inum;
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
  return 0;
80101e9b:	31 c0                	xor    %eax,%eax
}
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
    iput(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
    return -1;
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
      panic("dirlink read");
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 e8 86 10 80       	push   $0x801086e8
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 aa 8e 10 80       	push   $0x80108eaa
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fc5:	83 c6 5c             	add    $0x5c,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
    panic("incorrect blockno");
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 54 87 10 80       	push   $0x80108754
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 4b 87 10 80       	push   $0x8010874b
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 66 87 10 80       	push   $0x80108766
8010200b:	68 e0 c5 10 80       	push   $0x8010c5e0
80102010:	e8 ab 2f 00 00       	call   80104fc0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102015:	58                   	pop    %eax
80102016:	a1 a0 a0 18 80       	mov    0x8018a0a0,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
  for(i=0; i<1000; i++){
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
      havedisk1 = 1;
8010205a:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
80102061:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
}
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	68 e0 c5 10 80       	push   $0x8010c5e0
8010208e:	e8 6d 30 00 00       	call   80105100 <acquire>

  if((b = idequeue) == 0){
80102093:	8b 1d c4 c5 10 80    	mov    0x8010c5c4,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 c4 c5 10 80       	mov    %eax,0x8010c5c4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801020f0:	53                   	push   %ebx
801020f1:	e8 6a 2a 00 00       	call   80104b60 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f6:	a1 c4 c5 10 80       	mov    0x8010c5c4,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
    idestart(idequeue);
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 e0 c5 10 80       	push   $0x8010c5e0
8010210f:	e8 ac 30 00 00       	call   801051c0 <release>

  release(&idelock);
}
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 3d 2e 00 00       	call   80104f70 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 e0 c5 10 80       	push   $0x8010c5e0
80102168:	e8 93 2f 00 00       	call   80105100 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216d:	8b 15 c4 c5 10 80    	mov    0x8010c5c4,%edx
80102173:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102176:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 58             	mov    0x58(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102194:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102196:	39 1d c4 c5 10 80    	cmp    %ebx,0x8010c5c4
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 e0 c5 10 80       	push   $0x8010c5e0
801021b8:	53                   	push   %ebx
801021b9:	e8 c2 26 00 00       	call   80104880 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
  }


  release(&idelock);
801021cb:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
  release(&idelock);
801021d6:	e9 e5 2f 00 00       	jmp    801051c0 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f0:	ba c4 c5 10 80       	mov    $0x8010c5c4,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
    panic("iderw: nothing to do");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 80 87 10 80       	push   $0x80108780
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 6a 87 10 80       	push   $0x8010876a
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 95 87 10 80       	push   $0x80108795
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102221:	c7 05 d4 99 18 80 00 	movl   $0xfec00000,0x801899d4
80102228:	00 c0 fe 
{
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
  ioapic->reg = reg;
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
  return ioapic->data;
80102239:	a1 d4 99 18 80       	mov    0x801899d4,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102247:	8b 0d d4 99 18 80    	mov    0x801899d4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010224d:	0f b6 15 00 9b 18 80 	movzbl 0x80189b00,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102254:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010225a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010225d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 b4 87 10 80       	push   $0x801087b4
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d d4 99 18 80    	mov    0x801899d4,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
{
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102290:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102292:	8b 0d d4 99 18 80    	mov    0x801899d4,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022b0:	8b 0d d4 99 18 80    	mov    0x801899d4,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
  ioapic->reg = reg;
801022d1:	8b 0d d4 99 18 80    	mov    0x801899d4,%ecx
{
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022e5:	8b 0d d4 99 18 80    	mov    0x801899d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f6:	a1 d4 99 18 80       	mov    0x801899d4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 70                	jne    80102392 <kfree+0x82>
80102322:	81 fb 88 2b 19 80    	cmp    $0x80192b88,%ebx
80102328:	72 68                	jb     80102392 <kfree+0x82>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 5b                	ja     80102392 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	68 00 10 00 00       	push   $0x1000
8010233f:	6a 01                	push   $0x1
80102341:	53                   	push   %ebx
80102342:	e8 c9 2e 00 00       	call   80105210 <memset>

  if(kmem.use_lock)
80102347:	8b 15 14 9a 18 80    	mov    0x80189a14,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102354:	a1 18 9a 18 80       	mov    0x80189a18,%eax
80102359:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010235b:	a1 14 9a 18 80       	mov    0x80189a14,%eax
  kmem.freelist = r;
80102360:	89 1d 18 9a 18 80    	mov    %ebx,0x80189a18
  if(kmem.use_lock)
80102366:	85 c0                	test   %eax,%eax
80102368:	75 06                	jne    80102370 <kfree+0x60>
    release(&kmem.lock);
}
8010236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236d:	c9                   	leave  
8010236e:	c3                   	ret    
8010236f:	90                   	nop
    release(&kmem.lock);
80102370:	c7 45 08 e0 99 18 80 	movl   $0x801899e0,0x8(%ebp)
}
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
    release(&kmem.lock);
8010237b:	e9 40 2e 00 00       	jmp    801051c0 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 e0 99 18 80       	push   $0x801899e0
80102388:	e8 73 2d 00 00       	call   80105100 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 e6 87 10 80       	push   $0x801087e6
8010239a:	e8 f1 df ff ff       	call   80100390 <panic>
8010239f:	90                   	nop

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bd:	39 de                	cmp    %ebx,%esi
801023bf:	72 23                	jb     801023e4 <freerange+0x44>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023d7:	50                   	push   %eax
801023d8:	e8 33 ff ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	39 f3                	cmp    %esi,%ebx
801023e2:	76 e4                	jbe    801023c8 <freerange+0x28>
}
801023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e7:	5b                   	pop    %ebx
801023e8:	5e                   	pop    %esi
801023e9:	5d                   	pop    %ebp
801023ea:	c3                   	ret    
801023eb:	90                   	nop
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 ec 87 10 80       	push   $0x801087ec
80102400:	68 e0 99 18 80       	push   $0x801899e0
80102405:	e8 b6 2b 00 00       	call   80104fc0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102410:	c7 05 14 9a 18 80 00 	movl   $0x0,0x80189a14
80102417:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242c:	39 de                	cmp    %ebx,%esi
8010242e:	72 1c                	jb     8010244c <kinit1+0x5c>
    kfree(p);
80102430:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102436:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010243f:	50                   	push   %eax
80102440:	e8 cb fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	39 de                	cmp    %ebx,%esi
8010244a:	73 e4                	jae    80102430 <kinit1+0x40>
}
8010244c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010244f:	5b                   	pop    %ebx
80102450:	5e                   	pop    %esi
80102451:	5d                   	pop    %ebp
80102452:	c3                   	ret    
80102453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <kinit2+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102497:	50                   	push   %eax
80102498:	e8 73 fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 e4                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
801024a4:	c7 05 14 9a 18 80 01 	movl   $0x1,0x80189a14
801024ab:	00 00 00 
}
801024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024c0:	a1 14 9a 18 80       	mov    0x80189a14,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c9:	a1 18 9a 18 80       	mov    0x80189a18,%eax
  if(r)
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
    kmem.freelist = r->next;
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 18 9a 18 80    	mov    %edx,0x80189a18
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024e0:	f3 c3                	repz ret 
801024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024ee:	68 e0 99 18 80       	push   $0x801899e0
801024f3:	e8 08 2c 00 00       	call   80105100 <acquire>
  r = kmem.freelist;
801024f8:	a1 18 9a 18 80       	mov    0x80189a18,%eax
  if(r)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 14 9a 18 80    	mov    0x80189a14,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
    kmem.freelist = r->next;
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d 18 9a 18 80    	mov    %ecx,0x80189a18
  if(kmem.use_lock)
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
    release(&kmem.lock);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 e0 99 18 80       	push   $0x801899e0
80102521:	e8 9a 2c 00 00       	call   801051c0 <release>
  return (char*)r;
80102526:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102529:	83 c4 10             	add    $0x10,%esp
}
8010252c:	c9                   	leave  
8010252d:	c3                   	ret    
8010252e:	66 90                	xchg   %ax,%ax

80102530 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 c2 00 00 00    	je     80102600 <kbdgetc+0xd0>
8010253e:	ba 60 00 00 00       	mov    $0x60,%edx
80102543:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102544:	0f b6 d0             	movzbl %al,%edx
80102547:	8b 0d 14 c6 10 80    	mov    0x8010c614,%ecx

  if(data == 0xE0){
8010254d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102553:	0f 84 7f 00 00 00    	je     801025d8 <kbdgetc+0xa8>
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	53                   	push   %ebx
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102562:	84 c0                	test   %al,%al
80102564:	78 4a                	js     801025b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102566:	85 db                	test   %ebx,%ebx
80102568:	74 09                	je     80102573 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010256d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102570:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102573:	0f b6 82 20 89 10 80 	movzbl -0x7fef76e0(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 20 88 10 80 	movzbl -0x7fef77e0(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102585:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102587:	89 0d 14 c6 10 80    	mov    %ecx,0x8010c614
  c = charcode[shift & (CTL | SHIFT)][data];
8010258d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102590:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102593:	8b 04 85 00 88 10 80 	mov    -0x7fef7800(,%eax,4),%eax
8010259a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010259e:	74 31                	je     801025d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a3:	83 fa 19             	cmp    $0x19,%edx
801025a6:	77 40                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025ab:	5b                   	pop    %ebx
801025ac:	5d                   	pop    %ebp
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025b0:	83 e0 7f             	and    $0x7f,%eax
801025b3:	85 db                	test   %ebx,%ebx
801025b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025b8:	0f b6 82 20 89 10 80 	movzbl -0x7fef76e0(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
    return 0;
801025c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025cb:	89 0d 14 c6 10 80    	mov    %ecx,0x8010c614
}
801025d1:	5b                   	pop    %ebx
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025dd:	89 0d 14 c6 10 80    	mov    %ecx,0x8010c614
    return 0;
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ef:	83 f9 1a             	cmp    $0x1a,%ecx
801025f2:	0f 42 c2             	cmovb  %edx,%eax
}
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102605:	c3                   	ret    
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kbdintr>:

void
kbdintr(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102616:	68 30 25 10 80       	push   $0x80102530
8010261b:	e8 f0 e1 ff ff       	call   80100810 <consoleintr>
}
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	c9                   	leave  
80102624:	c3                   	ret    
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102630:	a1 1c 9a 18 80       	mov    0x80189a1c,%eax
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102638:	85 c0                	test   %eax,%eax
8010263a:	0f 84 c8 00 00 00    	je     80102708 <lapicinit+0xd8>
  lapic[index] = value;
80102640:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102647:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010264a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010264d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102654:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102657:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102661:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102664:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102667:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010266e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102671:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102674:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010267b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010267e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102681:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102688:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010268e:	8b 50 30             	mov    0x30(%eax),%edx
80102691:	c1 ea 10             	shr    $0x10,%edx
80102694:	80 fa 03             	cmp    $0x3,%dl
80102697:	77 77                	ja     80102710 <lapicinit+0xe0>
  lapic[index] = value;
80102699:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026f6:	80 e6 10             	and    $0x10,%dh
801026f9:	75 f5                	jne    801026f0 <lapicinit+0xc0>
  lapic[index] = value;
801026fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102702:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102705:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102708:	5d                   	pop    %ebp
80102709:	c3                   	ret    
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102710:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102717:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
8010271d:	e9 77 ff ff ff       	jmp    80102699 <lapicinit+0x69>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102730:	8b 15 1c 9a 18 80    	mov    0x80189a1c,%edx
{
80102736:	55                   	push   %ebp
80102737:	31 c0                	xor    %eax,%eax
80102739:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010273b:	85 d2                	test   %edx,%edx
8010273d:	74 06                	je     80102745 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010273f:	8b 42 20             	mov    0x20(%edx),%eax
80102742:	c1 e8 18             	shr    $0x18,%eax
}
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102750:	a1 1c 9a 18 80       	mov    0x80189a1c,%eax
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
  lapic[index] = value;
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
}
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102780:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102781:	b8 0f 00 00 00       	mov    $0xf,%eax
80102786:	ba 70 00 00 00       	mov    $0x70,%edx
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	ba 71 00 00 00       	mov    $0x71,%edx
8010279f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027b0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027b3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027be:	a1 1c 9a 18 80       	mov    0x80189a1c,%eax
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010280a:	5b                   	pop    %ebx
8010280b:	5d                   	pop    %ebp
8010280c:	c3                   	ret    
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102810:	55                   	push   %ebp
80102811:	b8 0b 00 00 00       	mov    $0xb,%eax
80102816:	ba 70 00 00 00       	mov    $0x70,%edx
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102824:	ba 71 00 00 00       	mov    $0x71,%edx
80102829:	ec                   	in     (%dx),%al
8010282a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010282d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102832:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102835:	8d 76 00             	lea    0x0(%esi),%esi
80102838:	31 c0                	xor    %eax,%eax
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102842:	89 ca                	mov    %ecx,%edx
80102844:	ec                   	in     (%dx),%al
80102845:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102848:	89 da                	mov    %ebx,%edx
8010284a:	b8 02 00 00 00       	mov    $0x2,%eax
8010284f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
80102853:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102856:	89 da                	mov    %ebx,%edx
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
80102861:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	89 da                	mov    %ebx,%edx
80102866:	b8 07 00 00 00       	mov    $0x7,%eax
8010286b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
8010286f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 da                	mov    %ebx,%edx
80102874:	b8 08 00 00 00       	mov    $0x8,%eax
80102879:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287f:	89 da                	mov    %ebx,%edx
80102881:	b8 09 00 00 00       	mov    $0x9,%eax
80102886:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102887:	89 ca                	mov    %ecx,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288c:	89 da                	mov    %ebx,%edx
8010288e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	89 ca                	mov    %ecx,%edx
80102896:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102897:	84 c0                	test   %al,%al
80102899:	78 9d                	js     80102838 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010289b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010289f:	89 fa                	mov    %edi,%edx
801028a1:	0f b6 fa             	movzbl %dl,%edi
801028a4:	89 f2                	mov    %esi,%edx
801028a6:	0f b6 f2             	movzbl %dl,%esi
801028a9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028b4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028bb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c9:	31 c0                	xor    %eax,%eax
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e3:	89 da                	mov    %ebx,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f4:	89 da                	mov    %ebx,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	89 da                	mov    %ebx,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102916:	89 da                	mov    %ebx,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102927:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010292d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	50                   	push   %eax
80102933:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102936:	50                   	push   %eax
80102937:	e8 24 29 00 00       	call   80105260 <memcmp>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	0f 85 f1 fe ff ff    	jne    80102838 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102947:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010294b:	75 78                	jne    801029c5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010294d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102950:	89 c2                	mov    %eax,%edx
80102952:	83 e0 0f             	and    $0xf,%eax
80102955:	c1 ea 04             	shr    $0x4,%edx
80102958:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102961:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102964:	89 c2                	mov    %eax,%edx
80102966:	83 e0 0f             	and    $0xf,%eax
80102969:	c1 ea 04             	shr    $0x4,%edx
8010296c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102972:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102975:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102978:	89 c2                	mov    %eax,%edx
8010297a:	83 e0 0f             	and    $0xf,%eax
8010297d:	c1 ea 04             	shr    $0x4,%edx
80102980:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102983:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102986:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298c:	89 c2                	mov    %eax,%edx
8010298e:	83 e0 0f             	and    $0xf,%eax
80102991:	c1 ea 04             	shr    $0x4,%edx
80102994:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102997:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	83 e0 0f             	and    $0xf,%eax
801029a5:	c1 ea 04             	shr    $0x4,%edx
801029a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b4:	89 c2                	mov    %eax,%edx
801029b6:	83 e0 0f             	and    $0xf,%eax
801029b9:	c1 ea 04             	shr    $0x4,%edx
801029bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029c5:	8b 75 08             	mov    0x8(%ebp),%esi
801029c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cb:	89 06                	mov    %eax,(%esi)
801029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d0:	89 46 04             	mov    %eax,0x4(%esi)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 46 08             	mov    %eax,0x8(%esi)
801029d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029dc:	89 46 0c             	mov    %eax,0xc(%esi)
801029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e2:	89 46 10             	mov    %eax,0x10(%esi)
801029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f5:	5b                   	pop    %ebx
801029f6:	5e                   	pop    %esi
801029f7:	5f                   	pop    %edi
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a00:	8b 0d 68 9a 18 80    	mov    0x80189a68,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 8a 00 00 00    	jle    80102a98 <install_trans+0x98>
{
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	31 db                	xor    %ebx,%ebx
{
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a20:	a1 54 9a 18 80       	mov    0x80189a54,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 64 9a 18 80    	pushl  0x80189a64
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d 6c 9a 18 80 	pushl  -0x7fe76594(,%ebx,4)
80102a44:	ff 35 64 9a 18 80    	pushl  0x80189a64
  for (tail = 0; tail < log.lh.n; tail++) {
80102a4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 57 28 00 00       	call   801052c0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d 68 9a 18 80    	cmp    %ebx,0x80189a68
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
  }
}
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	f3 c3                	repz ret 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	ff 35 54 9a 18 80    	pushl  0x80189a54
80102aae:	ff 35 64 9a 18 80    	pushl  0x80189a64
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ab9:	8b 1d 68 9a 18 80    	mov    0x80189a68,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102abf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ac6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	7e 16                	jle    80102ae1 <write_head+0x41>
80102acb:	c1 e3 02             	shl    $0x2,%ebx
80102ace:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ad0:	8b 8a 6c 9a 18 80    	mov    -0x7fe76594(%edx),%ecx
80102ad6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102ada:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <write_head+0x30>
  }
  bwrite(buf);
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	56                   	push   %esi
80102ae5:	e8 b6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aea:	89 34 24             	mov    %esi,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
}
80102af2:	83 c4 10             	add    $0x10,%esp
80102af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af8:	5b                   	pop    %ebx
80102af9:	5e                   	pop    %esi
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <initlog>:
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b0a:	68 20 8a 10 80       	push   $0x80108a20
80102b0f:	68 20 9a 18 80       	push   $0x80189a20
80102b14:	e8 a7 24 00 00       	call   80104fc0 <initlock>
  readsb(dev, &sb);
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 1b e9 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b2b:	59                   	pop    %ecx
  log.dev = dev;
80102b2c:	89 1d 64 9a 18 80    	mov    %ebx,0x80189a64
  log.size = sb.nlog;
80102b32:	89 15 58 9a 18 80    	mov    %edx,0x80189a58
  log.start = sb.logstart;
80102b38:	a3 54 9a 18 80       	mov    %eax,0x80189a54
  struct buf *buf = bread(log.dev, log.start);
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b4d:	89 1d 68 9a 18 80    	mov    %ebx,0x80189a68
  for (i = 0; i < log.lh.n; i++) {
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a 68 9a 18 80    	mov    %ecx,-0x7fe76598(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b6d:	39 d3                	cmp    %edx,%ebx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
  brelse(buf);
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
  log.lh.n = 0;
80102b7f:	c7 05 68 9a 18 80 00 	movl   $0x0,0x80189a68
80102b86:	00 00 00 
  write_head(); // clear the log
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
}
80102b8e:	83 c4 10             	add    $0x10,%esp
80102b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ba6:	68 20 9a 18 80       	push   $0x80189a20
80102bab:	e8 50 25 00 00       	call   80105100 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 20 9a 18 80       	push   $0x80189a20
80102bc0:	68 20 9a 18 80       	push   $0x80189a20
80102bc5:	e8 b6 1c 00 00       	call   80104880 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bcd:	a1 60 9a 18 80       	mov    0x80189a60,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bd6:	a1 5c 9a 18 80       	mov    0x80189a5c,%eax
80102bdb:	8b 15 68 9a 18 80    	mov    0x80189a68,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102bf2:	a3 5c 9a 18 80       	mov    %eax,0x80189a5c
      release(&log.lock);
80102bf7:	68 20 9a 18 80       	push   $0x80189a20
80102bfc:	e8 bf 25 00 00       	call   801051c0 <release>
      break;
    }
  }
}
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c19:	68 20 9a 18 80       	push   $0x80189a20
80102c1e:	e8 dd 24 00 00       	call   80105100 <acquire>
  log.outstanding -= 1;
80102c23:	a1 5c 9a 18 80       	mov    0x80189a5c,%eax
  if(log.committing)
80102c28:	8b 35 60 9a 18 80    	mov    0x80189a60,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c34:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c36:	89 1d 5c 9a 18 80    	mov    %ebx,0x80189a5c
  if(log.committing)
80102c3c:	0f 85 1a 01 00 00    	jne    80102d5c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c42:	85 db                	test   %ebx,%ebx
80102c44:	0f 85 ee 00 00 00    	jne    80102d38 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c4a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c4d:	c7 05 60 9a 18 80 01 	movl   $0x1,0x80189a60
80102c54:	00 00 00 
  release(&log.lock);
80102c57:	68 20 9a 18 80       	push   $0x80189a20
80102c5c:	e8 5f 25 00 00       	call   801051c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c61:	8b 0d 68 9a 18 80    	mov    0x80189a68,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c72:	a1 54 9a 18 80       	mov    0x80189a54,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 64 9a 18 80    	pushl  0x80189a64
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d 6c 9a 18 80 	pushl  -0x7fe76594(,%ebx,4)
80102c96:	ff 35 64 9a 18 80    	pushl  0x80189a64
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9f:	e8 2c d4 ff ff       	call   801000d0 <bread>
80102ca4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca9:	83 c4 0c             	add    $0xc,%esp
80102cac:	68 00 02 00 00       	push   $0x200
80102cb1:	50                   	push   %eax
80102cb2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cb5:	50                   	push   %eax
80102cb6:	e8 05 26 00 00       	call   801052c0 <memmove>
    bwrite(to);  // write the log
80102cbb:	89 34 24             	mov    %esi,(%esp)
80102cbe:	e8 dd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cc3:	89 3c 24             	mov    %edi,(%esp)
80102cc6:	e8 15 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 0d d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	3b 1d 68 9a 18 80    	cmp    0x80189a68,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
    install_trans(); // Now install writes to home locations
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
    log.lh.n = 0;
80102ce8:	c7 05 68 9a 18 80 00 	movl   $0x0,0x80189a68
80102cef:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
    acquire(&log.lock);
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 20 9a 18 80       	push   $0x80189a20
80102cff:	e8 fc 23 00 00       	call   80105100 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 20 9a 18 80 	movl   $0x80189a20,(%esp)
    log.committing = 0;
80102d0b:	c7 05 60 9a 18 80 00 	movl   $0x0,0x80189a60
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 46 1e 00 00       	call   80104b60 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 20 9a 18 80 	movl   $0x80189a20,(%esp)
80102d21:	e8 9a 24 00 00       	call   801051c0 <release>
80102d26:	83 c4 10             	add    $0x10,%esp
}
80102d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2c:	5b                   	pop    %ebx
80102d2d:	5e                   	pop    %esi
80102d2e:	5f                   	pop    %edi
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 20 9a 18 80       	push   $0x80189a20
80102d40:	e8 1b 1e 00 00       	call   80104b60 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 20 9a 18 80 	movl   $0x80189a20,(%esp)
80102d4c:	e8 6f 24 00 00       	call   801051c0 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
}
80102d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5f                   	pop    %edi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
    panic("log.committing");
80102d5c:	83 ec 0c             	sub    $0xc,%esp
80102d5f:	68 24 8a 10 80       	push   $0x80108a24
80102d64:	e8 27 d6 ff ff       	call   80100390 <panic>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d77:	8b 15 68 9a 18 80    	mov    0x80189a68,%edx
{
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 58 9a 18 80       	mov    0x80189a58,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 5c 9a 18 80       	mov    0x80189a5c,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 20 9a 18 80       	push   $0x80189a20
80102dae:	e8 4d 23 00 00       	call   80105100 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db3:	8b 0d 68 9a 18 80    	mov    0x80189a68,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dc4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc6:	3b 15 6c 9a 18 80    	cmp    0x80189a6c,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 6c 9a 18 80 	cmp    %edx,-0x7fe76594(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 14 85 6c 9a 18 80 	mov    %edx,-0x7fe76594(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 68 9a 18 80       	mov    %eax,0x80189a68
  b->flags |= B_DIRTY; // prevent eviction
80102def:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df2:	c7 45 08 20 9a 18 80 	movl   $0x80189a20,0x8(%ebp)
}
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
  release(&log.lock);
80102dfd:	e9 be 23 00 00       	jmp    801051c0 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e08:	89 14 85 6c 9a 18 80 	mov    %edx,-0x7fe76594(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 6c 9a 18 80       	mov    %eax,0x80189a6c
  if (i == log.lh.n)
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
    panic("too big a transaction");
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 33 8a 10 80       	push   $0x80108a33
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 49 8a 10 80       	push   $0x80108a49
80102e3b:	e8 50 d5 ff ff       	call   80100390 <panic>

80102e40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e47:	e8 b4 0b 00 00       	call   80103a00 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 ad 0b 00 00       	call   80103a00 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 64 8a 10 80       	push   $0x80108a64
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 39 37 00 00       	call   801065a0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 14 0b 00 00       	call   80103980 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 b1 15 00 00       	call   80104430 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 f5 4f 00 00       	call   80107e80 <switchkvm>
  seginit();
80102e8b:	e8 60 4f 00 00       	call   80107df0 <seginit>
  lapicinit();
80102e90:	e8 9b f7 ff ff       	call   80102630 <lapicinit>
  mpmain();
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
{
80102ea0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ea7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	53                   	push   %ebx
80102eae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eaf:	83 ec 08             	sub    $0x8,%esp
80102eb2:	68 00 00 40 80       	push   $0x80400000
80102eb7:	68 88 2b 19 80       	push   $0x80192b88
80102ebc:	e8 2f f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102ec1:	e8 8a 54 00 00       	call   80108350 <kvmalloc>
  mpinit();        // detect other processors
80102ec6:	e8 75 01 00 00       	call   80103040 <mpinit>
  lapicinit();     // interrupt controller
80102ecb:	e8 60 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102ed0:	e8 1b 4f 00 00       	call   80107df0 <seginit>
  picinit();       // disable pic
80102ed5:	e8 46 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102eda:	e8 41 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102edf:	e8 dc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ee4:	e8 d7 41 00 00       	call   801070c0 <uartinit>
  pinit();         // process table
80102ee9:	e8 22 09 00 00       	call   80103810 <pinit>
  tvinit();        // trap vectors
80102eee:	e8 2d 36 00 00       	call   80106520 <tvinit>
  binit();         // buffer cache
80102ef3:	e8 48 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ef8:	e8 63 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102efd:	e8 fe f0 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f02:	83 c4 0c             	add    $0xc,%esp
80102f05:	68 8a 00 00 00       	push   $0x8a
80102f0a:	68 ec c4 10 80       	push   $0x8010c4ec
80102f0f:	68 00 70 00 80       	push   $0x80007000
80102f14:	e8 a7 23 00 00       	call   801052c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f19:	69 05 a0 a0 18 80 b0 	imul   $0xb0,0x8018a0a0,%eax
80102f20:	00 00 00 
80102f23:	83 c4 10             	add    $0x10,%esp
80102f26:	05 20 9b 18 80       	add    $0x80189b20,%eax
80102f2b:	3d 20 9b 18 80       	cmp    $0x80189b20,%eax
80102f30:	76 71                	jbe    80102fa3 <main+0x103>
80102f32:	bb 20 9b 18 80       	mov    $0x80189b20,%ebx
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f40:	e8 3b 0a 00 00       	call   80103980 <mycpu>
80102f45:	39 d8                	cmp    %ebx,%eax
80102f47:	74 41                	je     80102f8a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f49:	e8 72 f5 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f4e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f53:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f5a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f5d:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80102f64:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f67:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f6c:	0f b6 03             	movzbl (%ebx),%eax
80102f6f:	83 ec 08             	sub    $0x8,%esp
80102f72:	68 00 70 00 00       	push   $0x7000
80102f77:	50                   	push   %eax
80102f78:	e8 03 f8 ff ff       	call   80102780 <lapicstartap>
80102f7d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f80:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f86:	85 c0                	test   %eax,%eax
80102f88:	74 f6                	je     80102f80 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f8a:	69 05 a0 a0 18 80 b0 	imul   $0xb0,0x8018a0a0,%eax
80102f91:	00 00 00 
80102f94:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f9a:	05 20 9b 18 80       	add    $0x80189b20,%eax
80102f9f:	39 c3                	cmp    %eax,%ebx
80102fa1:	72 9d                	jb     80102f40 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fa3:	83 ec 08             	sub    $0x8,%esp
80102fa6:	68 00 00 00 8e       	push   $0x8e000000
80102fab:	68 00 00 40 80       	push   $0x80400000
80102fb0:	e8 ab f4 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102fb5:	e8 96 10 00 00       	call   80104050 <userinit>
  mpmain();        // finish this processor's setup
80102fba:	e8 81 fe ff ff       	call   80102e40 <mpmain>
80102fbf:	90                   	nop

80102fc0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fc5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fcb:	53                   	push   %ebx
  e = addr+len;
80102fcc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fcf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fd2:	39 de                	cmp    %ebx,%esi
80102fd4:	72 10                	jb     80102fe6 <mpsearch1+0x26>
80102fd6:	eb 50                	jmp    80103028 <mpsearch1+0x68>
80102fd8:	90                   	nop
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe0:	39 fb                	cmp    %edi,%ebx
80102fe2:	89 fe                	mov    %edi,%esi
80102fe4:	76 42                	jbe    80103028 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe6:	83 ec 04             	sub    $0x4,%esp
80102fe9:	8d 7e 10             	lea    0x10(%esi),%edi
80102fec:	6a 04                	push   $0x4
80102fee:	68 78 8a 10 80       	push   $0x80108a78
80102ff3:	56                   	push   %esi
80102ff4:	e8 67 22 00 00       	call   80105260 <memcmp>
80102ff9:	83 c4 10             	add    $0x10,%esp
80102ffc:	85 c0                	test   %eax,%eax
80102ffe:	75 e0                	jne    80102fe0 <mpsearch1+0x20>
80103000:	89 f1                	mov    %esi,%ecx
80103002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103008:	0f b6 11             	movzbl (%ecx),%edx
8010300b:	83 c1 01             	add    $0x1,%ecx
8010300e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103010:	39 f9                	cmp    %edi,%ecx
80103012:	75 f4                	jne    80103008 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103014:	84 c0                	test   %al,%al
80103016:	75 c8                	jne    80102fe0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010301b:	89 f0                	mov    %esi,%eax
8010301d:	5b                   	pop    %ebx
8010301e:	5e                   	pop    %esi
8010301f:	5f                   	pop    %edi
80103020:	5d                   	pop    %ebp
80103021:	c3                   	ret    
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010302b:	31 f6                	xor    %esi,%esi
}
8010302d:	89 f0                	mov    %esi,%eax
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
80103034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010303a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103040 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103049:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103050:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103057:	c1 e0 08             	shl    $0x8,%eax
8010305a:	09 d0                	or     %edx,%eax
8010305c:	c1 e0 04             	shl    $0x4,%eax
8010305f:	85 c0                	test   %eax,%eax
80103061:	75 1b                	jne    8010307e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103063:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010306a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103071:	c1 e0 08             	shl    $0x8,%eax
80103074:	09 d0                	or     %edx,%eax
80103076:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103079:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010307e:	ba 00 04 00 00       	mov    $0x400,%edx
80103083:	e8 38 ff ff ff       	call   80102fc0 <mpsearch1>
80103088:	85 c0                	test   %eax,%eax
8010308a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010308d:	0f 84 3d 01 00 00    	je     801031d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103096:	8b 58 04             	mov    0x4(%eax),%ebx
80103099:	85 db                	test   %ebx,%ebx
8010309b:	0f 84 4f 01 00 00    	je     801031f0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030a7:	83 ec 04             	sub    $0x4,%esp
801030aa:	6a 04                	push   $0x4
801030ac:	68 95 8a 10 80       	push   $0x80108a95
801030b1:	56                   	push   %esi
801030b2:	e8 a9 21 00 00       	call   80105260 <memcmp>
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	85 c0                	test   %eax,%eax
801030bc:	0f 85 2e 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030c9:	3c 01                	cmp    $0x1,%al
801030cb:	0f 95 c2             	setne  %dl
801030ce:	3c 04                	cmp    $0x4,%al
801030d0:	0f 95 c0             	setne  %al
801030d3:	20 c2                	and    %al,%dl
801030d5:	0f 85 15 01 00 00    	jne    801031f0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030e2:	66 85 ff             	test   %di,%di
801030e5:	74 1a                	je     80103101 <mpinit+0xc1>
801030e7:	89 f0                	mov    %esi,%eax
801030e9:	01 f7                	add    %esi,%edi
  sum = 0;
801030eb:	31 d2                	xor    %edx,%edx
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801030f0:	0f b6 08             	movzbl (%eax),%ecx
801030f3:	83 c0 01             	add    $0x1,%eax
801030f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801030f8:	39 c7                	cmp    %eax,%edi
801030fa:	75 f4                	jne    801030f0 <mpinit+0xb0>
801030fc:	84 d2                	test   %dl,%dl
801030fe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103101:	85 f6                	test   %esi,%esi
80103103:	0f 84 e7 00 00 00    	je     801031f0 <mpinit+0x1b0>
80103109:	84 d2                	test   %dl,%dl
8010310b:	0f 85 df 00 00 00    	jne    801031f0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103111:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103117:	a3 1c 9a 18 80       	mov    %eax,0x80189a1c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010311c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103123:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103129:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312e:	01 d6                	add    %edx,%esi
80103130:	39 c6                	cmp    %eax,%esi
80103132:	76 23                	jbe    80103157 <mpinit+0x117>
    switch(*p){
80103134:	0f b6 10             	movzbl (%eax),%edx
80103137:	80 fa 04             	cmp    $0x4,%dl
8010313a:	0f 87 ca 00 00 00    	ja     8010320a <mpinit+0x1ca>
80103140:	ff 24 95 bc 8a 10 80 	jmp    *-0x7fef7544(,%edx,4)
80103147:	89 f6                	mov    %esi,%esi
80103149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103150:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103153:	39 c6                	cmp    %eax,%esi
80103155:	77 dd                	ja     80103134 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103157:	85 db                	test   %ebx,%ebx
80103159:	0f 84 9e 00 00 00    	je     801031fd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103162:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103166:	74 15                	je     8010317d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103168:	b8 70 00 00 00       	mov    $0x70,%eax
8010316d:	ba 22 00 00 00       	mov    $0x22,%edx
80103172:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103173:	ba 23 00 00 00       	mov    $0x23,%edx
80103178:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103179:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010317c:	ee                   	out    %al,(%dx)
  }
}
8010317d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103180:	5b                   	pop    %ebx
80103181:	5e                   	pop    %esi
80103182:	5f                   	pop    %edi
80103183:	5d                   	pop    %ebp
80103184:	c3                   	ret    
80103185:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103188:	8b 0d a0 a0 18 80    	mov    0x8018a0a0,%ecx
8010318e:	83 f9 07             	cmp    $0x7,%ecx
80103191:	7f 19                	jg     801031ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103193:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103197:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010319d:	83 c1 01             	add    $0x1,%ecx
801031a0:	89 0d a0 a0 18 80    	mov    %ecx,0x8018a0a0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a6:	88 97 20 9b 18 80    	mov    %dl,-0x7fe764e0(%edi)
      p += sizeof(struct mpproc);
801031ac:	83 c0 14             	add    $0x14,%eax
      continue;
801031af:	e9 7c ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031bf:	88 15 00 9b 18 80    	mov    %dl,0x80189b00
      continue;
801031c5:	e9 66 ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031da:	e8 e1 fd ff ff       	call   80102fc0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031df:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031e4:	0f 85 a9 fe ff ff    	jne    80103093 <mpinit+0x53>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 7d 8a 10 80       	push   $0x80108a7d
801031f8:	e8 93 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801031fd:	83 ec 0c             	sub    $0xc,%esp
80103200:	68 9c 8a 10 80       	push   $0x80108a9c
80103205:	e8 86 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010320a:	31 db                	xor    %ebx,%ebx
8010320c:	e9 26 ff ff ff       	jmp    80103137 <mpinit+0xf7>
80103211:	66 90                	xchg   %ax,%ax
80103213:	66 90                	xchg   %ax,%ax
80103215:	66 90                	xchg   %ax,%ax
80103217:	66 90                	xchg   %ax,%ax
80103219:	66 90                	xchg   %ax,%ax
8010321b:	66 90                	xchg   %ax,%ax
8010321d:	66 90                	xchg   %ax,%ax
8010321f:	90                   	nop

80103220 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103220:	55                   	push   %ebp
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	ba 21 00 00 00       	mov    $0x21,%edx
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	ee                   	out    %al,(%dx)
8010322e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103233:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103234:	5d                   	pop    %ebp
80103235:	c3                   	ret    
80103236:	66 90                	xchg   %ax,%ax
80103238:	66 90                	xchg   %ax,%ax
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010324c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010324f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103255:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010325b:	e8 20 db ff ff       	call   80100d80 <filealloc>
80103260:	85 c0                	test   %eax,%eax
80103262:	89 03                	mov    %eax,(%ebx)
80103264:	74 22                	je     80103288 <pipealloc+0x48>
80103266:	e8 15 db ff ff       	call   80100d80 <filealloc>
8010326b:	85 c0                	test   %eax,%eax
8010326d:	89 06                	mov    %eax,(%esi)
8010326f:	74 3f                	je     801032b0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103271:	e8 4a f2 ff ff       	call   801024c0 <kalloc>
80103276:	85 c0                	test   %eax,%eax
80103278:	89 c7                	mov    %eax,%edi
8010327a:	75 54                	jne    801032d0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010327c:	8b 03                	mov    (%ebx),%eax
8010327e:	85 c0                	test   %eax,%eax
80103280:	75 34                	jne    801032b6 <pipealloc+0x76>
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103288:	8b 06                	mov    (%esi),%eax
8010328a:	85 c0                	test   %eax,%eax
8010328c:	74 0c                	je     8010329a <pipealloc+0x5a>
    fileclose(*f1);
8010328e:	83 ec 0c             	sub    $0xc,%esp
80103291:	50                   	push   %eax
80103292:	e8 a9 db ff ff       	call   80100e40 <fileclose>
80103297:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010329a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010329d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032a2:	5b                   	pop    %ebx
801032a3:	5e                   	pop    %esi
801032a4:	5f                   	pop    %edi
801032a5:	5d                   	pop    %ebp
801032a6:	c3                   	ret    
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032b0:	8b 03                	mov    (%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 e4                	je     8010329a <pipealloc+0x5a>
    fileclose(*f0);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 81 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032bf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032c4:	85 c0                	test   %eax,%eax
801032c6:	75 c6                	jne    8010328e <pipealloc+0x4e>
801032c8:	eb d0                	jmp    8010329a <pipealloc+0x5a>
801032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032d0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032da:	00 00 00 
  p->writeopen = 1;
801032dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032e4:	00 00 00 
  p->nwrite = 0;
801032e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032ee:	00 00 00 
  p->nread = 0;
801032f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801032f8:	00 00 00 
  initlock(&p->lock, "pipe");
801032fb:	68 d0 8a 10 80       	push   $0x80108ad0
80103300:	50                   	push   %eax
80103301:	e8 ba 1c 00 00       	call   80104fc0 <initlock>
  (*f0)->type = FD_PIPE;
80103306:	8b 03                	mov    (%ebx),%eax
  return 0;
80103308:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010330b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103311:	8b 03                	mov    (%ebx),%eax
80103313:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103317:	8b 03                	mov    (%ebx),%eax
80103319:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010331d:	8b 03                	mov    (%ebx),%eax
8010331f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103322:	8b 06                	mov    (%esi),%eax
80103324:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010332a:	8b 06                	mov    (%esi),%eax
8010332c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103330:	8b 06                	mov    (%esi),%eax
80103332:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103336:	8b 06                	mov    (%esi),%eax
80103338:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010333b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010333e:	31 c0                	xor    %eax,%eax
}
80103340:	5b                   	pop    %ebx
80103341:	5e                   	pop    %esi
80103342:	5f                   	pop    %edi
80103343:	5d                   	pop    %ebp
80103344:	c3                   	ret    
80103345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103350 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	56                   	push   %esi
80103354:	53                   	push   %ebx
80103355:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103358:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010335b:	83 ec 0c             	sub    $0xc,%esp
8010335e:	53                   	push   %ebx
8010335f:	e8 9c 1d 00 00       	call   80105100 <acquire>
  if(writable){
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 f6                	test   %esi,%esi
80103369:	74 45                	je     801033b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010336b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103371:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103374:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010337b:	00 00 00 
    wakeup(&p->nread);
8010337e:	50                   	push   %eax
8010337f:	e8 dc 17 00 00       	call   80104b60 <wakeup>
80103384:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103387:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338d:	85 d2                	test   %edx,%edx
8010338f:	75 0a                	jne    8010339b <pipeclose+0x4b>
80103391:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	74 35                	je     801033d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010339b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010339e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033a1:	5b                   	pop    %ebx
801033a2:	5e                   	pop    %esi
801033a3:	5d                   	pop    %ebp
    release(&p->lock);
801033a4:	e9 17 1e 00 00       	jmp    801051c0 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c0:	00 00 00 
    wakeup(&p->nwrite);
801033c3:	50                   	push   %eax
801033c4:	e8 97 17 00 00       	call   80104b60 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 e7 1d 00 00       	call   801051c0 <release>
    kfree((char*)p);
801033d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033dc:	83 c4 10             	add    $0x10,%esp
}
801033df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e2:	5b                   	pop    %ebx
801033e3:	5e                   	pop    %esi
801033e4:	5d                   	pop    %ebp
    kfree((char*)p);
801033e5:	e9 26 ef ff ff       	jmp    80102310 <kfree>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 28             	sub    $0x28,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033fc:	53                   	push   %ebx
801033fd:	e8 fe 1c 00 00       	call   80105100 <acquire>
  for(i = 0; i < n; i++){
80103402:	8b 45 10             	mov    0x10(%ebp),%eax
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 8e c9 00 00 00    	jle    801034d9 <pipewrite+0xe9>
80103410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103413:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103419:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010341f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103422:	03 4d 10             	add    0x10(%ebp),%ecx
80103425:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103428:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010342e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103434:	39 d0                	cmp    %edx,%eax
80103436:	75 71                	jne    801034a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103438:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010343e:	85 c0                	test   %eax,%eax
80103440:	74 4e                	je     80103490 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103442:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103448:	eb 3a                	jmp    80103484 <pipewrite+0x94>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	57                   	push   %edi
80103454:	e8 07 17 00 00       	call   80104b60 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103459:	5a                   	pop    %edx
8010345a:	59                   	pop    %ecx
8010345b:	53                   	push   %ebx
8010345c:	56                   	push   %esi
8010345d:	e8 1e 14 00 00       	call   80104880 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103462:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103468:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010346e:	83 c4 10             	add    $0x10,%esp
80103471:	05 00 02 00 00       	add    $0x200,%eax
80103476:	39 c2                	cmp    %eax,%edx
80103478:	75 36                	jne    801034b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010347a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103480:	85 c0                	test   %eax,%eax
80103482:	74 0c                	je     80103490 <pipewrite+0xa0>
80103484:	e8 97 05 00 00       	call   80103a20 <myproc>
80103489:	8b 40 24             	mov    0x24(%eax),%eax
8010348c:	85 c0                	test   %eax,%eax
8010348e:	74 c0                	je     80103450 <pipewrite+0x60>
        release(&p->lock);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 27 1d 00 00       	call   801051c0 <release>
        return -1;
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5f                   	pop    %edi
801034a7:	5d                   	pop    %ebp
801034a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a9:	89 c2                	mov    %eax,%edx
801034ab:	90                   	nop
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034b3:	8d 42 01             	lea    0x1(%edx),%eax
801034b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034c2:	83 c6 01             	add    $0x1,%esi
801034c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034cf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034d3:	0f 85 4f ff ff ff    	jne    80103428 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034df:	83 ec 0c             	sub    $0xc,%esp
801034e2:	50                   	push   %eax
801034e3:	e8 78 16 00 00       	call   80104b60 <wakeup>
  release(&p->lock);
801034e8:	89 1c 24             	mov    %ebx,(%esp)
801034eb:	e8 d0 1c 00 00       	call   801051c0 <release>
  return n;
801034f0:	83 c4 10             	add    $0x10,%esp
801034f3:	8b 45 10             	mov    0x10(%ebp),%eax
801034f6:	eb a9                	jmp    801034a1 <pipewrite+0xb1>
801034f8:	90                   	nop
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103500 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 18             	sub    $0x18,%esp
80103509:	8b 75 08             	mov    0x8(%ebp),%esi
8010350c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010350f:	56                   	push   %esi
80103510:	e8 eb 1b 00 00       	call   80105100 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010351e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103524:	75 6a                	jne    80103590 <piperead+0x90>
80103526:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010352c:	85 db                	test   %ebx,%ebx
8010352e:	0f 84 c4 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103534:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010353a:	eb 2d                	jmp    80103569 <piperead+0x69>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103540:	83 ec 08             	sub    $0x8,%esp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	e8 36 13 00 00       	call   80104880 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010354a:	83 c4 10             	add    $0x10,%esp
8010354d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103553:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103559:	75 35                	jne    80103590 <piperead+0x90>
8010355b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	0f 84 8f 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
80103569:	e8 b2 04 00 00       	call   80103a20 <myproc>
8010356e:	8b 48 24             	mov    0x24(%eax),%ecx
80103571:	85 c9                	test   %ecx,%ecx
80103573:	74 cb                	je     80103540 <piperead+0x40>
      release(&p->lock);
80103575:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103578:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010357d:	56                   	push   %esi
8010357e:	e8 3d 1c 00 00       	call   801051c0 <release>
      return -1;
80103583:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103589:	89 d8                	mov    %ebx,%eax
8010358b:	5b                   	pop    %ebx
8010358c:	5e                   	pop    %esi
8010358d:	5f                   	pop    %edi
8010358e:	5d                   	pop    %ebp
8010358f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103590:	8b 45 10             	mov    0x10(%ebp),%eax
80103593:	85 c0                	test   %eax,%eax
80103595:	7e 61                	jle    801035f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103597:	31 db                	xor    %ebx,%ebx
80103599:	eb 13                	jmp    801035ae <piperead+0xae>
8010359b:	90                   	nop
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ac:	74 1f                	je     801035cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ae:	8d 41 01             	lea    0x1(%ecx),%eax
801035b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035c5:	83 c3 01             	add    $0x1,%ebx
801035c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035cb:	75 d3                	jne    801035a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	50                   	push   %eax
801035d7:	e8 84 15 00 00       	call   80104b60 <wakeup>
  release(&p->lock);
801035dc:	89 34 24             	mov    %esi,(%esp)
801035df:	e8 dc 1b 00 00       	call   801051c0 <release>
  return i;
801035e4:	83 c4 10             	add    $0x10,%esp
}
801035e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ea:	89 d8                	mov    %ebx,%eax
801035ec:	5b                   	pop    %ebx
801035ed:	5e                   	pop    %esi
801035ee:	5f                   	pop    %edi
801035ef:	5d                   	pop    %ebp
801035f0:	c3                   	ret    
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035f8:	31 db                	xor    %ebx,%ebx
801035fa:	eb d1                	jmp    801035cd <piperead+0xcd>
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <allocproc>:
// PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *allocproc(void) {
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	53                   	push   %ebx
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103604:	bb 94 df 18 80       	mov    $0x8018df94,%ebx
static struct proc *allocproc(void) {
80103609:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
8010360c:	68 60 df 18 80       	push   $0x8018df60
80103611:	e8 ea 1a 00 00       	call   80105100 <acquire>
80103616:	83 c4 10             	add    $0x10,%esp
80103619:	eb 17                	jmp    80103632 <allocproc+0x32>
8010361b:	90                   	nop
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103620:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
80103626:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
8010362c:	0f 83 66 01 00 00    	jae    80103798 <allocproc+0x198>
        if (p->state == UNUSED)
80103632:	8b 43 0c             	mov    0xc(%ebx),%eax
80103635:	85 c0                	test   %eax,%eax
80103637:	75 e7                	jne    80103620 <allocproc+0x20>
    return 0;

found:
    p->state = EMBRYO;
    p->priority = 60;  // default priority value
    p->pid = nextpid++;
80103639:	a1 60 c0 10 80       	mov    0x8010c060,%eax
    }
    // pushq(&q0, &p, &end0);
    q0[cnt[0]] = p;
    end0 += 1;
    cnt[0]++;
    release(&ptable.lock);
8010363e:	83 ec 0c             	sub    $0xc,%esp
    p->state = EMBRYO;
80103641:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->priority = 60;  // default priority value
80103648:	c7 83 8c 00 00 00 3c 	movl   $0x3c,0x8c(%ebx)
8010364f:	00 00 00 
    p->qno = 0;
80103652:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103659:	00 00 00 
    p->stat.current_queue = 0;
8010365c:	c7 83 b8 00 00 00 00 	movl   $0x0,0xb8(%ebx)
80103663:	00 00 00 
    p->stat.num_run = 0;
80103666:	c7 83 b4 00 00 00 00 	movl   $0x0,0xb4(%ebx)
8010366d:	00 00 00 
    p->pid = nextpid++;
80103670:	8d 50 01             	lea    0x1(%eax),%edx
80103673:	89 43 10             	mov    %eax,0x10(%ebx)
    p->stat.pid = p->pid;
80103676:	89 83 ac 00 00 00    	mov    %eax,0xac(%ebx)
    q0[cnt[0]] = p;
8010367c:	a1 1c c6 10 80       	mov    0x8010c61c,%eax
    p->stat.runtime = 0;
80103681:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
80103688:	00 00 00 
        p->stat.ticks[j] = 0;
8010368b:	c7 83 bc 00 00 00 00 	movl   $0x0,0xbc(%ebx)
80103692:	00 00 00 
        p->rrtime[j] = 0;
80103695:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
8010369c:	00 00 00 
        p->stat.ticks[j] = 0;
8010369f:	c7 83 c0 00 00 00 00 	movl   $0x0,0xc0(%ebx)
801036a6:	00 00 00 
        p->rrtime[j] = 0;
801036a9:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
801036b0:	00 00 00 
        p->stat.ticks[j] = 0;
801036b3:	c7 83 c4 00 00 00 00 	movl   $0x0,0xc4(%ebx)
801036ba:	00 00 00 
        p->rrtime[j] = 0;
801036bd:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
801036c4:	00 00 00 
        p->stat.ticks[j] = 0;
801036c7:	c7 83 c8 00 00 00 00 	movl   $0x0,0xc8(%ebx)
801036ce:	00 00 00 
        p->rrtime[j] = 0;
801036d1:	c7 83 a4 00 00 00 00 	movl   $0x0,0xa4(%ebx)
801036d8:	00 00 00 
        p->stat.ticks[j] = 0;
801036db:	c7 83 cc 00 00 00 00 	movl   $0x0,0xcc(%ebx)
801036e2:	00 00 00 
        p->rrtime[j] = 0;
801036e5:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
801036ec:	00 00 00 
    release(&ptable.lock);
801036ef:	68 60 df 18 80       	push   $0x8018df60
    q0[cnt[0]] = p;
801036f4:	89 1c 85 c0 cf 18 80 	mov    %ebx,-0x7fe73040(,%eax,4)
    cnt[0]++;
801036fb:	83 c0 01             	add    $0x1,%eax
    p->pid = nextpid++;
801036fe:	89 15 60 c0 10 80    	mov    %edx,0x8010c060
    end0 += 1;
80103704:	83 05 40 c6 10 80 01 	addl   $0x1,0x8010c640
    cnt[0]++;
8010370b:	a3 1c c6 10 80       	mov    %eax,0x8010c61c
    release(&ptable.lock);
80103710:	e8 ab 1a 00 00       	call   801051c0 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
80103715:	e8 a6 ed ff ff       	call   801024c0 <kalloc>
8010371a:	83 c4 10             	add    $0x10,%esp
8010371d:	85 c0                	test   %eax,%eax
8010371f:	89 43 08             	mov    %eax,0x8(%ebx)
80103722:	0f 84 89 00 00 00    	je     801037b1 <allocproc+0x1b1>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80103728:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *)sp;
    memset(p->context, 0, sizeof *p->context);
8010372e:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
80103731:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
80103736:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint *)sp = (uint)trapret;
80103739:	c7 40 14 12 65 10 80 	movl   $0x80106512,0x14(%eax)
    p->context = (struct context *)sp;
80103740:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103743:	6a 14                	push   $0x14
80103745:	6a 00                	push   $0x0
80103747:	50                   	push   %eax
80103748:	e8 c3 1a 00 00       	call   80105210 <memset>
    p->context->eip = (uint)forkret;
8010374d:	8b 43 1c             	mov    0x1c(%ebx),%eax
    p->rtime = 0;
    p->etime = 0;
    p->iotime = 0;
    p->aging_time = 0;

    return p;
80103750:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
80103753:	c7 40 10 c0 37 10 80 	movl   $0x801037c0,0x10(%eax)
    p->ctime = ticks;
8010375a:	a1 80 2b 19 80       	mov    0x80192b80,%eax
    p->rtime = 0;
8010375f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103766:	00 00 00 
    p->etime = 0;
80103769:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103770:	00 00 00 
    p->iotime = 0;
80103773:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
8010377a:	00 00 00 
    p->aging_time = 0;
8010377d:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103784:	00 00 00 
    p->ctime = ticks;
80103787:	89 43 7c             	mov    %eax,0x7c(%ebx)
}
8010378a:	89 d8                	mov    %ebx,%eax
8010378c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010378f:	c9                   	leave  
80103790:	c3                   	ret    
80103791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80103798:	83 ec 0c             	sub    $0xc,%esp
    return 0;
8010379b:	31 db                	xor    %ebx,%ebx
    release(&ptable.lock);
8010379d:	68 60 df 18 80       	push   $0x8018df60
801037a2:	e8 19 1a 00 00       	call   801051c0 <release>
}
801037a7:	89 d8                	mov    %ebx,%eax
    return 0;
801037a9:	83 c4 10             	add    $0x10,%esp
}
801037ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037af:	c9                   	leave  
801037b0:	c3                   	ret    
        p->state = UNUSED;
801037b1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
801037b8:	31 db                	xor    %ebx,%ebx
801037ba:	eb ce                	jmp    8010378a <allocproc+0x18a>
801037bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037c0 <forkret>:
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void) {
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
801037c6:	68 60 df 18 80       	push   $0x8018df60
801037cb:	e8 f0 19 00 00       	call   801051c0 <release>

    if (first) {
801037d0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801037d5:	83 c4 10             	add    $0x10,%esp
801037d8:	85 c0                	test   %eax,%eax
801037da:	75 04                	jne    801037e0 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
801037dc:	c9                   	leave  
801037dd:	c3                   	ret    
801037de:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
801037e0:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
801037e3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
801037ea:	00 00 00 
        iinit(ROOTDEV);
801037ed:	6a 01                	push   $0x1
801037ef:	e8 8c dc ff ff       	call   80101480 <iinit>
        initlog(ROOTDEV);
801037f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037fb:	e8 00 f3 ff ff       	call   80102b00 <initlog>
80103800:	83 c4 10             	add    $0x10,%esp
}
80103803:	c9                   	leave  
80103804:	c3                   	ret    
80103805:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103810 <pinit>:
void pinit(void) {
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
80103816:	68 d5 8a 10 80       	push   $0x80108ad5
8010381b:	68 60 df 18 80       	push   $0x8018df60
80103820:	e8 9b 17 00 00       	call   80104fc0 <initlock>
}
80103825:	83 c4 10             	add    $0x10,%esp
80103828:	c9                   	leave  
80103829:	c3                   	ret    
8010382a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103830 <graph>:
    if (ticks > 800) {
80103830:	81 3d 80 2b 19 80 20 	cmpl   $0x320,0x80192b80
80103837:	03 00 00 
8010383a:	76 04                	jbe    80103840 <graph+0x10>
}
8010383c:	31 c0                	xor    %eax,%eax
8010383e:	c3                   	ret    
8010383f:	90                   	nop
int graph() {
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	57                   	push   %edi
80103844:	56                   	push   %esi
80103845:	53                   	push   %ebx
80103846:	83 ec 18             	sub    $0x18,%esp
    acquire(&ptable.lock);
80103849:	68 60 df 18 80       	push   $0x8018df60
8010384e:	e8 ad 18 00 00       	call   80105100 <acquire>
            store[5][ticks].totaltime = ticks;
80103853:	8b 0d 80 2b 19 80    	mov    0x80192b80,%ecx
80103859:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010385c:	b8 94 df 18 80       	mov    $0x8018df94,%eax
            store[5][ticks].totaltime = ticks;
80103861:	8d b1 50 c3 00 00    	lea    0xc350(%ecx),%esi
            store[4][ticks].totaltime = ticks;
80103867:	8d 99 40 9c 00 00    	lea    0x9c40(%ecx),%ebx
8010386d:	eb 21                	jmp    80103890 <graph+0x60>
8010386f:	90                   	nop
            store[0][ticks].qno = p->qno;
80103870:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
            store[0][ticks].totaltime = ticks;
80103876:	89 0c cd c0 1f 11 80 	mov    %ecx,-0x7feee040(,%ecx,8)
            store[0][ticks].qno = p->qno;
8010387d:	89 14 cd c4 1f 11 80 	mov    %edx,-0x7feee03c(,%ecx,8)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103884:	05 d0 00 00 00       	add    $0xd0,%eax
80103889:	3d 94 13 19 80       	cmp    $0x80191394,%eax
8010388e:	73 48                	jae    801038d8 <graph+0xa8>
        if (p->pid == 0) {
80103890:	8b 50 10             	mov    0x10(%eax),%edx
80103893:	85 d2                	test   %edx,%edx
80103895:	74 d9                	je     80103870 <graph+0x40>
        } else if (p->pid == 1) {
80103897:	83 fa 01             	cmp    $0x1,%edx
8010389a:	74 5c                	je     801038f8 <graph+0xc8>
        } else if (p->pid == 2) {
8010389c:	83 fa 02             	cmp    $0x2,%edx
8010389f:	74 7f                	je     80103920 <graph+0xf0>
        } else if (p->pid == 3) {
801038a1:	83 fa 03             	cmp    $0x3,%edx
801038a4:	0f 84 96 00 00 00    	je     80103940 <graph+0x110>
        } else if (p->pid == 6) {
801038aa:	83 fa 06             	cmp    $0x6,%edx
801038ad:	0f 84 ad 00 00 00    	je     80103960 <graph+0x130>
        } else if (p->pid == 7) {
801038b3:	83 fa 07             	cmp    $0x7,%edx
801038b6:	75 cc                	jne    80103884 <graph+0x54>
            store[5][ticks].qno = p->qno;
801038b8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801038be:	05 d0 00 00 00       	add    $0xd0,%eax
            store[5][ticks].totaltime = ticks;
801038c3:	89 0c f5 c0 1f 11 80 	mov    %ecx,-0x7feee040(,%esi,8)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801038ca:	3d 94 13 19 80       	cmp    $0x80191394,%eax
            store[5][ticks].qno = p->qno;
801038cf:	89 14 f5 c4 1f 11 80 	mov    %edx,-0x7feee03c(,%esi,8)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801038d6:	72 b8                	jb     80103890 <graph+0x60>
    release(&ptable.lock);
801038d8:	83 ec 0c             	sub    $0xc,%esp
801038db:	68 60 df 18 80       	push   $0x8018df60
801038e0:	e8 db 18 00 00       	call   801051c0 <release>
    return 0;
801038e5:	83 c4 10             	add    $0x10,%esp
}
801038e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038eb:	31 c0                	xor    %eax,%eax
801038ed:	5b                   	pop    %ebx
801038ee:	5e                   	pop    %esi
801038ef:	5f                   	pop    %edi
801038f0:	5d                   	pop    %ebp
801038f1:	c3                   	ret    
801038f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            store[1][ticks].totaltime = ticks;
801038f8:	8d 91 10 27 00 00    	lea    0x2710(%ecx),%edx
801038fe:	89 0c d5 c0 1f 11 80 	mov    %ecx,-0x7feee040(,%edx,8)
            store[1][ticks].qno = p->qno;
80103905:	8b b8 90 00 00 00    	mov    0x90(%eax),%edi
8010390b:	89 3c d5 c4 1f 11 80 	mov    %edi,-0x7feee03c(,%edx,8)
80103912:	e9 6d ff ff ff       	jmp    80103884 <graph+0x54>
80103917:	89 f6                	mov    %esi,%esi
80103919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            store[2][ticks].totaltime = ticks;
80103920:	8d 91 20 4e 00 00    	lea    0x4e20(%ecx),%edx
80103926:	89 0c d5 c0 1f 11 80 	mov    %ecx,-0x7feee040(,%edx,8)
            store[2][ticks].qno = p->qno;
8010392d:	8b b8 90 00 00 00    	mov    0x90(%eax),%edi
80103933:	89 3c d5 c4 1f 11 80 	mov    %edi,-0x7feee03c(,%edx,8)
8010393a:	e9 45 ff ff ff       	jmp    80103884 <graph+0x54>
8010393f:	90                   	nop
            store[3][ticks].totaltime = ticks;
80103940:	8d 91 30 75 00 00    	lea    0x7530(%ecx),%edx
80103946:	89 0c d5 c0 1f 11 80 	mov    %ecx,-0x7feee040(,%edx,8)
            store[3][ticks].qno = p->qno;
8010394d:	8b b8 90 00 00 00    	mov    0x90(%eax),%edi
80103953:	89 3c d5 c4 1f 11 80 	mov    %edi,-0x7feee03c(,%edx,8)
8010395a:	e9 25 ff ff ff       	jmp    80103884 <graph+0x54>
8010395f:	90                   	nop
            store[4][ticks].qno = p->qno;
80103960:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
            store[4][ticks].totaltime = ticks;
80103966:	89 0c dd c0 1f 11 80 	mov    %ecx,-0x7feee040(,%ebx,8)
            store[4][ticks].qno = p->qno;
8010396d:	89 14 dd c4 1f 11 80 	mov    %edx,-0x7feee03c(,%ebx,8)
80103974:	e9 0b ff ff ff       	jmp    80103884 <graph+0x54>
80103979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103980 <mycpu>:
struct cpu *mycpu(void) {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	56                   	push   %esi
80103984:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103985:	9c                   	pushf  
80103986:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103987:	f6 c4 02             	test   $0x2,%ah
8010398a:	75 5e                	jne    801039ea <mycpu+0x6a>
    apicid = lapicid();
8010398c:	e8 9f ed ff ff       	call   80102730 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103991:	8b 35 a0 a0 18 80    	mov    0x8018a0a0,%esi
80103997:	85 f6                	test   %esi,%esi
80103999:	7e 42                	jle    801039dd <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
8010399b:	0f b6 15 20 9b 18 80 	movzbl 0x80189b20,%edx
801039a2:	39 d0                	cmp    %edx,%eax
801039a4:	74 30                	je     801039d6 <mycpu+0x56>
801039a6:	b9 d0 9b 18 80       	mov    $0x80189bd0,%ecx
    for (i = 0; i < ncpu; ++i) {
801039ab:	31 d2                	xor    %edx,%edx
801039ad:	8d 76 00             	lea    0x0(%esi),%esi
801039b0:	83 c2 01             	add    $0x1,%edx
801039b3:	39 f2                	cmp    %esi,%edx
801039b5:	74 26                	je     801039dd <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
801039b7:	0f b6 19             	movzbl (%ecx),%ebx
801039ba:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801039c0:	39 c3                	cmp    %eax,%ebx
801039c2:	75 ec                	jne    801039b0 <mycpu+0x30>
801039c4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801039ca:	05 20 9b 18 80       	add    $0x80189b20,%eax
}
801039cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039d2:	5b                   	pop    %ebx
801039d3:	5e                   	pop    %esi
801039d4:	5d                   	pop    %ebp
801039d5:	c3                   	ret    
        if (cpus[i].apicid == apicid)
801039d6:	b8 20 9b 18 80       	mov    $0x80189b20,%eax
            return &cpus[i];
801039db:	eb f2                	jmp    801039cf <mycpu+0x4f>
    panic("unknown apicid\n");
801039dd:	83 ec 0c             	sub    $0xc,%esp
801039e0:	68 dc 8a 10 80       	push   $0x80108adc
801039e5:	e8 a6 c9 ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
801039ea:	83 ec 0c             	sub    $0xc,%esp
801039ed:	68 5c 8c 10 80       	push   $0x80108c5c
801039f2:	e8 99 c9 ff ff       	call   80100390 <panic>
801039f7:	89 f6                	mov    %esi,%esi
801039f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a00 <cpuid>:
int cpuid() {
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80103a06:	e8 75 ff ff ff       	call   80103980 <mycpu>
80103a0b:	2d 20 9b 18 80       	sub    $0x80189b20,%eax
}
80103a10:	c9                   	leave  
    return mycpu() - cpus;
80103a11:	c1 f8 04             	sar    $0x4,%eax
80103a14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a1a:	c3                   	ret    
80103a1b:	90                   	nop
80103a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a20 <myproc>:
struct proc *myproc(void) {
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	53                   	push   %ebx
80103a24:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103a27:	e8 04 16 00 00       	call   80105030 <pushcli>
    c = mycpu();
80103a2c:	e8 4f ff ff ff       	call   80103980 <mycpu>
    p = c->proc;
80103a31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103a37:	e8 34 16 00 00       	call   80105070 <popcli>
}
80103a3c:	83 c4 04             	add    $0x4,%esp
80103a3f:	89 d8                	mov    %ebx,%eax
80103a41:	5b                   	pop    %ebx
80103a42:	5d                   	pop    %ebp
80103a43:	c3                   	ret    
80103a44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a50 <getpinfo>:
int getpinfo(struct proc_stat *p, int pid) {
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	56                   	push   %esi
80103a54:	53                   	push   %ebx
80103a55:	8b 75 0c             	mov    0xc(%ebp),%esi
80103a58:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
80103a5b:	83 ec 0c             	sub    $0xc,%esp
80103a5e:	68 60 df 18 80       	push   $0x8018df60
80103a63:	e8 98 16 00 00       	call   80105100 <acquire>
80103a68:	83 c4 10             	add    $0x10,%esp
    for (q = ptable.proc; q < &ptable.proc[NPROC]; q++) {
80103a6b:	b8 94 df 18 80       	mov    $0x8018df94,%eax
80103a70:	eb 16                	jmp    80103a88 <getpinfo+0x38>
80103a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a78:	05 d0 00 00 00       	add    $0xd0,%eax
80103a7d:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80103a82:	0f 83 c8 00 00 00    	jae    80103b50 <getpinfo+0x100>
        if (q->state != RUNNABLE) {
80103a88:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103a8c:	75 ea                	jne    80103a78 <getpinfo+0x28>
        if (q->pid == pid) {
80103a8e:	39 70 10             	cmp    %esi,0x10(%eax)
80103a91:	75 e5                	jne    80103a78 <getpinfo+0x28>
            p->pid = q->pid;
80103a93:	89 33                	mov    %esi,(%ebx)
            p->runtime = q->stat.runtime;
80103a95:	8b 90 b0 00 00 00    	mov    0xb0(%eax),%edx
            cprintf("pid : %d\n", p->pid);
80103a9b:	83 ec 08             	sub    $0x8,%esp
            p->runtime = q->stat.runtime;
80103a9e:	89 53 04             	mov    %edx,0x4(%ebx)
            p->current_queue = q->qno;
80103aa1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80103aa7:	89 53 0c             	mov    %edx,0xc(%ebx)
            p->num_run = q->stat.num_run;
80103aaa:	8b 90 b4 00 00 00    	mov    0xb4(%eax),%edx
80103ab0:	89 53 08             	mov    %edx,0x8(%ebx)
                p->ticks[j] = q->stat.ticks[j];
80103ab3:	8b 90 bc 00 00 00    	mov    0xbc(%eax),%edx
80103ab9:	89 53 10             	mov    %edx,0x10(%ebx)
80103abc:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
80103ac2:	89 53 14             	mov    %edx,0x14(%ebx)
80103ac5:	8b 90 c4 00 00 00    	mov    0xc4(%eax),%edx
80103acb:	89 53 18             	mov    %edx,0x18(%ebx)
80103ace:	8b 90 c8 00 00 00    	mov    0xc8(%eax),%edx
80103ad4:	89 53 1c             	mov    %edx,0x1c(%ebx)
80103ad7:	8b 80 cc 00 00 00    	mov    0xcc(%eax),%eax
80103add:	89 43 20             	mov    %eax,0x20(%ebx)
            cprintf("pid : %d\n", p->pid);
80103ae0:	56                   	push   %esi
80103ae1:	68 ec 8a 10 80       	push   $0x80108aec
80103ae6:	e8 75 cb ff ff       	call   80100660 <cprintf>
            cprintf("current queue : %d\n", p->current_queue);
80103aeb:	58                   	pop    %eax
80103aec:	5a                   	pop    %edx
80103aed:	ff 73 0c             	pushl  0xc(%ebx)
80103af0:	68 f6 8a 10 80       	push   $0x80108af6
80103af5:	e8 66 cb ff ff       	call   80100660 <cprintf>
            cprintf("num_run : %d\n", p->num_run);
80103afa:	59                   	pop    %ecx
80103afb:	5e                   	pop    %esi
80103afc:	ff 73 08             	pushl  0x8(%ebx)
80103aff:	68 0a 8b 10 80       	push   $0x80108b0a
80103b04:	e8 57 cb ff ff       	call   80100660 <cprintf>
            cprintf("runtime : %d\n", p->runtime);
80103b09:	58                   	pop    %eax
80103b0a:	5a                   	pop    %edx
80103b0b:	ff 73 04             	pushl  0x4(%ebx)
80103b0e:	68 18 8b 10 80       	push   $0x80108b18
80103b13:	e8 48 cb ff ff       	call   80100660 <cprintf>
            cprintf("ticks : %d %d %d %d %d\n", p->ticks[0], p->ticks[1],
80103b18:	59                   	pop    %ecx
80103b19:	5e                   	pop    %esi
80103b1a:	ff 73 20             	pushl  0x20(%ebx)
80103b1d:	ff 73 1c             	pushl  0x1c(%ebx)
80103b20:	ff 73 18             	pushl  0x18(%ebx)
80103b23:	ff 73 14             	pushl  0x14(%ebx)
80103b26:	ff 73 10             	pushl  0x10(%ebx)
80103b29:	68 26 8b 10 80       	push   $0x80108b26
80103b2e:	e8 2d cb ff ff       	call   80100660 <cprintf>
            release(&ptable.lock);
80103b33:	83 c4 14             	add    $0x14,%esp
80103b36:	68 60 df 18 80       	push   $0x8018df60
80103b3b:	e8 80 16 00 00       	call   801051c0 <release>
            return 1;
80103b40:	83 c4 10             	add    $0x10,%esp
}
80103b43:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 1;
80103b46:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103b4b:	5b                   	pop    %ebx
80103b4c:	5e                   	pop    %esi
80103b4d:	5d                   	pop    %ebp
80103b4e:	c3                   	ret    
80103b4f:	90                   	nop
    release(&ptable.lock);
80103b50:	83 ec 0c             	sub    $0xc,%esp
80103b53:	68 60 df 18 80       	push   $0x8018df60
80103b58:	e8 63 16 00 00       	call   801051c0 <release>
    return 0;
80103b5d:	83 c4 10             	add    $0x10,%esp
}
80103b60:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80103b63:	31 c0                	xor    %eax,%eax
}
80103b65:	5b                   	pop    %ebx
80103b66:	5e                   	pop    %esi
80103b67:	5d                   	pop    %ebp
80103b68:	c3                   	ret    
80103b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b70 <aging>:
int aging() {
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	57                   	push   %edi
80103b74:	56                   	push   %esi
80103b75:	53                   	push   %ebx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103b76:	bf 94 df 18 80       	mov    $0x8018df94,%edi
int aging() {
80103b7b:	83 ec 28             	sub    $0x28,%esp
    acquire(&ptable.lock);
80103b7e:	68 60 df 18 80       	push   $0x8018df60
80103b83:	e8 78 15 00 00       	call   80105100 <acquire>
80103b88:	83 c4 10             	add    $0x10,%esp
80103b8b:	eb 3d                	jmp    80103bca <aging+0x5a>
80103b8d:	8d 76 00             	lea    0x0(%esi),%esi
            } else if (no == 2) {
80103b90:	83 f9 02             	cmp    $0x2,%ecx
80103b93:	0f 84 57 01 00 00    	je     80103cf0 <aging+0x180>
            } else if (no == 3) {
80103b99:	83 f9 03             	cmp    $0x3,%ecx
80103b9c:	0f 84 6e 02 00 00    	je     80103e10 <aging+0x2a0>
            } else if (no == 4) {
80103ba2:	83 f9 04             	cmp    $0x4,%ecx
80103ba5:	0f 84 75 03 00 00    	je     80103f20 <aging+0x3b0>
            p->aging_time = ticks - (p->ctime + p->rtime);
80103bab:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103bae:	01 d0                	add    %edx,%eax
80103bb0:	29 c6                	sub    %eax,%esi
80103bb2:	89 b7 94 00 00 00    	mov    %esi,0x94(%edi)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103bb8:	81 c7 d0 00 00 00    	add    $0xd0,%edi
80103bbe:	81 ff 94 13 19 80    	cmp    $0x80191394,%edi
80103bc4:	0f 83 66 04 00 00    	jae    80104030 <aging+0x4c0>
        if (p->state != RUNNABLE)
80103bca:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103bce:	75 e8                	jne    80103bb8 <aging+0x48>
        int tm = ticks - p->ctime - p->rtime - p->aging_time;
80103bd0:	a1 80 2b 19 80       	mov    0x80192b80,%eax
80103bd5:	8b 57 7c             	mov    0x7c(%edi),%edx
80103bd8:	89 c1                	mov    %eax,%ecx
80103bda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103bdd:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80103be3:	29 d1                	sub    %edx,%ecx
80103be5:	29 c1                	sub    %eax,%ecx
80103be7:	2b 8f 94 00 00 00    	sub    0x94(%edi),%ecx
        if (tm > time_age) {
80103bed:	39 0d 64 c0 10 80    	cmp    %ecx,0x8010c064
80103bf3:	7d c3                	jge    80103bb8 <aging+0x48>
            int no = p->qno;
80103bf5:	8b 8f 90 00 00 00    	mov    0x90(%edi),%ecx
            if (no == 1) {
80103bfb:	83 f9 01             	cmp    $0x1,%ecx
80103bfe:	75 90                	jne    80103b90 <aging+0x20>
                for (int i = 0; i < cnt[1]; i++) {
80103c00:	8b 15 20 c6 10 80    	mov    0x8010c620,%edx
80103c06:	85 d2                	test   %edx,%edx
80103c08:	7e 26                	jle    80103c30 <aging+0xc0>
                int ind = 0;
80103c0a:	31 db                	xor    %ebx,%ebx
                    if (q1[i] == p) {
80103c0c:	39 3d 20 c0 18 80    	cmp    %edi,0x8018c020
80103c12:	75 15                	jne    80103c29 <aging+0xb9>
80103c14:	eb 1c                	jmp    80103c32 <aging+0xc2>
80103c16:	8d 76 00             	lea    0x0(%esi),%esi
80103c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103c20:	39 3c 9d 20 c0 18 80 	cmp    %edi,-0x7fe73fe0(,%ebx,4)
80103c27:	74 09                	je     80103c32 <aging+0xc2>
                for (int i = 0; i < cnt[1]; i++) {
80103c29:	83 c3 01             	add    $0x1,%ebx
80103c2c:	39 d3                	cmp    %edx,%ebx
80103c2e:	75 f0                	jne    80103c20 <aging+0xb0>
                int ind = 0;
80103c30:	31 db                	xor    %ebx,%ebx
                cprintf("%d : Process with pid %d AGED from 1 to 0 rtime %d\n",
80103c32:	50                   	push   %eax
80103c33:	ff 77 10             	pushl  0x10(%edi)
                cnt[1]--;
80103c36:	83 ea 01             	sub    $0x1,%edx
                cprintf("%d : Process with pid %d AGED from 1 to 0 rtime %d\n",
80103c39:	ff 75 e4             	pushl  -0x1c(%ebp)
80103c3c:	68 84 8c 10 80       	push   $0x80108c84
                cnt[1]--;
80103c41:	89 15 20 c6 10 80    	mov    %edx,0x8010c620
                p->qno = 0;
80103c47:	c7 87 90 00 00 00 00 	movl   $0x0,0x90(%edi)
80103c4e:	00 00 00 
                p->rrtime[0] = 0;
80103c51:	c7 87 98 00 00 00 00 	movl   $0x0,0x98(%edi)
80103c58:	00 00 00 
                p->rrtime[1] = 0;
80103c5b:	c7 87 9c 00 00 00 00 	movl   $0x0,0x9c(%edi)
80103c62:	00 00 00 
                cprintf("%d : Process with pid %d AGED from 1 to 0 rtime %d\n",
80103c65:	e8 f6 c9 ff ff       	call   80100660 <cprintf>
                for (int i = ind; i < cnt[1]; i++) {
80103c6a:	8b 15 20 c6 10 80    	mov    0x8010c620,%edx
80103c70:	83 c4 10             	add    $0x10,%esp
80103c73:	39 d3                	cmp    %edx,%ebx
80103c75:	7d 1e                	jge    80103c95 <aging+0x125>
80103c77:	8d 04 9d 20 c0 18 80 	lea    -0x7fe73fe0(,%ebx,4),%eax
80103c7e:	8d 0c 95 20 c0 18 80 	lea    -0x7fe73fe0(,%edx,4),%ecx
80103c85:	8d 76 00             	lea    0x0(%esi),%esi
                    q1[i] = q1[i + 1];
80103c88:	8b 50 04             	mov    0x4(%eax),%edx
80103c8b:	83 c0 04             	add    $0x4,%eax
80103c8e:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = ind; i < cnt[1]; i++) {
80103c91:	39 c1                	cmp    %eax,%ecx
80103c93:	75 f3                	jne    80103c88 <aging+0x118>
                for (int i = 0; i < cnt[0]; i++) {
80103c95:	8b 1d 1c c6 10 80    	mov    0x8010c61c,%ebx
80103c9b:	a1 80 2b 19 80       	mov    0x80192b80,%eax
80103ca0:	8b 57 7c             	mov    0x7c(%edi),%edx
80103ca3:	85 db                	test   %ebx,%ebx
80103ca5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ca8:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80103cae:	7e 24                	jle    80103cd4 <aging+0x164>
                    if (q0[i] == p) {
80103cb0:	39 3d c0 cf 18 80    	cmp    %edi,0x8018cfc0
80103cb6:	0f 84 ef fe ff ff    	je     80103bab <aging+0x3b>
                for (int i = 0; i < cnt[0]; i++) {
80103cbc:	31 c9                	xor    %ecx,%ecx
80103cbe:	eb 0d                	jmp    80103ccd <aging+0x15d>
                    if (q0[i] == p) {
80103cc0:	39 3c 8d c0 cf 18 80 	cmp    %edi,-0x7fe73040(,%ecx,4)
80103cc7:	0f 84 de fe ff ff    	je     80103bab <aging+0x3b>
                for (int i = 0; i < cnt[0]; i++) {
80103ccd:	83 c1 01             	add    $0x1,%ecx
80103cd0:	39 d9                	cmp    %ebx,%ecx
80103cd2:	75 ec                	jne    80103cc0 <aging+0x150>
                    cnt[0]++;
80103cd4:	8d 4b 01             	lea    0x1(%ebx),%ecx
                    q0[cnt[0] - 1] = p;
80103cd7:	89 3c 9d c0 cf 18 80 	mov    %edi,-0x7fe73040(,%ebx,4)
                    end0 += 1;
80103cde:	83 05 40 c6 10 80 01 	addl   $0x1,0x8010c640
                    cnt[0]++;
80103ce5:	89 0d 1c c6 10 80    	mov    %ecx,0x8010c61c
80103ceb:	e9 bb fe ff ff       	jmp    80103bab <aging+0x3b>
                for (int i = 0; i < cnt[2]; i++) {
80103cf0:	8b 0d 24 c6 10 80    	mov    0x8010c624,%ecx
80103cf6:	8b 77 10             	mov    0x10(%edi),%esi
80103cf9:	85 c9                	test   %ecx,%ecx
80103cfb:	7e 26                	jle    80103d23 <aging+0x1b3>
                    if (q2[i]->pid == p->pid) {
80103cfd:	8b 15 c0 a0 18 80    	mov    0x8018a0c0,%edx
                int ind = 0;
80103d03:	31 db                	xor    %ebx,%ebx
                    if (q2[i]->pid == p->pid) {
80103d05:	39 72 10             	cmp    %esi,0x10(%edx)
80103d08:	75 12                	jne    80103d1c <aging+0x1ac>
80103d0a:	eb 19                	jmp    80103d25 <aging+0x1b5>
80103d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d10:	8b 14 9d c0 a0 18 80 	mov    -0x7fe75f40(,%ebx,4),%edx
80103d17:	39 72 10             	cmp    %esi,0x10(%edx)
80103d1a:	74 09                	je     80103d25 <aging+0x1b5>
                for (int i = 0; i < cnt[2]; i++) {
80103d1c:	83 c3 01             	add    $0x1,%ebx
80103d1f:	39 cb                	cmp    %ecx,%ebx
80103d21:	75 ed                	jne    80103d10 <aging+0x1a0>
                int ind = 0;
80103d23:	31 db                	xor    %ebx,%ebx
                cprintf("%d : Process with pid %d AGED from 2 to 1 rtime %d\n",
80103d25:	50                   	push   %eax
80103d26:	56                   	push   %esi
                cnt[2]--;
80103d27:	83 e9 01             	sub    $0x1,%ecx
                cprintf("%d : Process with pid %d AGED from 2 to 1 rtime %d\n",
80103d2a:	ff 75 e4             	pushl  -0x1c(%ebp)
80103d2d:	68 b8 8c 10 80       	push   $0x80108cb8
                p->qno = 1;
80103d32:	c7 87 90 00 00 00 01 	movl   $0x1,0x90(%edi)
80103d39:	00 00 00 
                p->rrtime[1] = 0;
80103d3c:	c7 87 9c 00 00 00 00 	movl   $0x0,0x9c(%edi)
80103d43:	00 00 00 
                p->rrtime[2] = 0;
80103d46:	c7 87 a0 00 00 00 00 	movl   $0x0,0xa0(%edi)
80103d4d:	00 00 00 
                cnt[2]--;
80103d50:	89 0d 24 c6 10 80    	mov    %ecx,0x8010c624
                cprintf("%d : Process with pid %d AGED from 2 to 1 rtime %d\n",
80103d56:	e8 05 c9 ff ff       	call   80100660 <cprintf>
                for (int i = ind; i < cnt[2]; i++) {
80103d5b:	8b 15 24 c6 10 80    	mov    0x8010c624,%edx
80103d61:	83 c4 10             	add    $0x10,%esp
80103d64:	39 d3                	cmp    %edx,%ebx
80103d66:	7d 25                	jge    80103d8d <aging+0x21d>
80103d68:	8d 04 9d c0 a0 18 80 	lea    -0x7fe75f40(,%ebx,4),%eax
80103d6f:	8d 0c 95 c0 a0 18 80 	lea    -0x7fe75f40(,%edx,4),%ecx
80103d76:	8d 76 00             	lea    0x0(%esi),%esi
80103d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    q2[i] = q2[i + 1];
80103d80:	8b 50 04             	mov    0x4(%eax),%edx
80103d83:	83 c0 04             	add    $0x4,%eax
80103d86:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = ind; i < cnt[2]; i++) {
80103d89:	39 c1                	cmp    %eax,%ecx
80103d8b:	75 f3                	jne    80103d80 <aging+0x210>
                for (int i = 0; i < cnt[1]; i++) {
80103d8d:	8b 35 20 c6 10 80    	mov    0x8010c620,%esi
80103d93:	a1 80 2b 19 80       	mov    0x80192b80,%eax
80103d98:	8b 57 7c             	mov    0x7c(%edi),%edx
80103d9b:	85 f6                	test   %esi,%esi
80103d9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103da0:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80103da6:	7e 36                	jle    80103dde <aging+0x26e>
                    if (q1[i]->pid == p->pid) {
80103da8:	8b 0d 20 c0 18 80    	mov    0x8018c020,%ecx
80103dae:	8b 5f 10             	mov    0x10(%edi),%ebx
80103db1:	3b 59 10             	cmp    0x10(%ecx),%ebx
80103db4:	0f 84 f1 fd ff ff    	je     80103bab <aging+0x3b>
                for (int i = 0; i < cnt[1]; i++) {
80103dba:	31 c9                	xor    %ecx,%ecx
80103dbc:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103dbf:	eb 13                	jmp    80103dd4 <aging+0x264>
80103dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    if (q1[i]->pid == p->pid) {
80103dc8:	8b 04 8d 20 c0 18 80 	mov    -0x7fe73fe0(,%ecx,4),%eax
80103dcf:	39 58 10             	cmp    %ebx,0x10(%eax)
80103dd2:	74 2c                	je     80103e00 <aging+0x290>
                for (int i = 0; i < cnt[1]; i++) {
80103dd4:	83 c1 01             	add    $0x1,%ecx
80103dd7:	39 f1                	cmp    %esi,%ecx
80103dd9:	75 ed                	jne    80103dc8 <aging+0x258>
80103ddb:	8b 45 e0             	mov    -0x20(%ebp),%eax
                    cnt[1]++;
80103dde:	8d 4e 01             	lea    0x1(%esi),%ecx
                    q1[cnt[1] - 1] = p;
80103de1:	89 3c b5 20 c0 18 80 	mov    %edi,-0x7fe73fe0(,%esi,4)
                    end1 += 1;
80103de8:	83 05 3c c6 10 80 01 	addl   $0x1,0x8010c63c
                    cnt[1]++;
80103def:	89 0d 20 c6 10 80    	mov    %ecx,0x8010c620
80103df5:	e9 b1 fd ff ff       	jmp    80103bab <aging+0x3b>
80103dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e00:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e03:	e9 a3 fd ff ff       	jmp    80103bab <aging+0x3b>
80103e08:	90                   	nop
80103e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                for (int i = 0; i < cnt[3]; i++) {
80103e10:	8b 35 28 c6 10 80    	mov    0x8010c628,%esi
80103e16:	8b 4f 10             	mov    0x10(%edi),%ecx
80103e19:	85 f6                	test   %esi,%esi
80103e1b:	7e 26                	jle    80103e43 <aging+0x2d3>
                    if (q3[i]->pid == p->pid) {
80103e1d:	8b 15 80 b0 18 80    	mov    0x8018b080,%edx
                int ind = 0;
80103e23:	31 db                	xor    %ebx,%ebx
                    if (q3[i]->pid == p->pid) {
80103e25:	39 4a 10             	cmp    %ecx,0x10(%edx)
80103e28:	75 12                	jne    80103e3c <aging+0x2cc>
80103e2a:	eb 19                	jmp    80103e45 <aging+0x2d5>
80103e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e30:	8b 14 9d 80 b0 18 80 	mov    -0x7fe74f80(,%ebx,4),%edx
80103e37:	39 4a 10             	cmp    %ecx,0x10(%edx)
80103e3a:	74 09                	je     80103e45 <aging+0x2d5>
                for (int i = 0; i < cnt[3]; i++) {
80103e3c:	83 c3 01             	add    $0x1,%ebx
80103e3f:	39 f3                	cmp    %esi,%ebx
80103e41:	75 ed                	jne    80103e30 <aging+0x2c0>
                int ind = 0;
80103e43:	31 db                	xor    %ebx,%ebx
                cprintf("%d : Process with pid %d AGED from 3 to 2 rtime %d\n",
80103e45:	50                   	push   %eax
80103e46:	51                   	push   %ecx
80103e47:	ff 75 e4             	pushl  -0x1c(%ebp)
80103e4a:	68 ec 8c 10 80       	push   $0x80108cec
                p->rrtime[2] = 0;
80103e4f:	c7 87 a0 00 00 00 00 	movl   $0x0,0xa0(%edi)
80103e56:	00 00 00 
                p->rrtime[3] = 0;
80103e59:	c7 87 a4 00 00 00 00 	movl   $0x0,0xa4(%edi)
80103e60:	00 00 00 
                p->qno = 2;
80103e63:	c7 87 90 00 00 00 02 	movl   $0x2,0x90(%edi)
80103e6a:	00 00 00 
                cprintf("%d : Process with pid %d AGED from 3 to 2 rtime %d\n",
80103e6d:	e8 ee c7 ff ff       	call   80100660 <cprintf>
                cnt[3]--;
80103e72:	8b 15 28 c6 10 80    	mov    0x8010c628,%edx
                for (int i = ind; i < cnt[3]; i++) {
80103e78:	83 c4 10             	add    $0x10,%esp
                cnt[3]--;
80103e7b:	8d 42 ff             	lea    -0x1(%edx),%eax
                for (int i = ind; i < cnt[3]; i++) {
80103e7e:	39 d8                	cmp    %ebx,%eax
                cnt[3]--;
80103e80:	a3 28 c6 10 80       	mov    %eax,0x8010c628
                for (int i = ind; i < cnt[3]; i++) {
80103e85:	7e 1e                	jle    80103ea5 <aging+0x335>
80103e87:	8d 04 9d 80 b0 18 80 	lea    -0x7fe74f80(,%ebx,4),%eax
80103e8e:	8d 0c 95 7c b0 18 80 	lea    -0x7fe74f84(,%edx,4),%ecx
80103e95:	8d 76 00             	lea    0x0(%esi),%esi
                    q3[i] = q3[i + 1];
80103e98:	8b 50 04             	mov    0x4(%eax),%edx
80103e9b:	83 c0 04             	add    $0x4,%eax
80103e9e:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = ind; i < cnt[3]; i++) {
80103ea1:	39 c8                	cmp    %ecx,%eax
80103ea3:	75 f3                	jne    80103e98 <aging+0x328>
                for (int i = 0; i < cnt[2]; i++) {
80103ea5:	8b 35 24 c6 10 80    	mov    0x8010c624,%esi
80103eab:	a1 80 2b 19 80       	mov    0x80192b80,%eax
80103eb0:	8b 57 7c             	mov    0x7c(%edi),%edx
80103eb3:	85 f6                	test   %esi,%esi
80103eb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103eb8:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80103ebe:	7e 3a                	jle    80103efa <aging+0x38a>
                    if (q2[i]->pid == p->pid) {
80103ec0:	8b 0d c0 a0 18 80    	mov    0x8018a0c0,%ecx
80103ec6:	8b 5f 10             	mov    0x10(%edi),%ebx
80103ec9:	3b 59 10             	cmp    0x10(%ecx),%ebx
80103ecc:	0f 84 d9 fc ff ff    	je     80103bab <aging+0x3b>
                for (int i = 0; i < cnt[2]; i++) {
80103ed2:	31 c9                	xor    %ecx,%ecx
80103ed4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103ed7:	eb 17                	jmp    80103ef0 <aging+0x380>
80103ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    if (q2[i]->pid == p->pid) {
80103ee0:	8b 04 8d c0 a0 18 80 	mov    -0x7fe75f40(,%ecx,4),%eax
80103ee7:	39 58 10             	cmp    %ebx,0x10(%eax)
80103eea:	0f 84 10 ff ff ff    	je     80103e00 <aging+0x290>
                for (int i = 0; i < cnt[2]; i++) {
80103ef0:	83 c1 01             	add    $0x1,%ecx
80103ef3:	39 ce                	cmp    %ecx,%esi
80103ef5:	75 e9                	jne    80103ee0 <aging+0x370>
80103ef7:	8b 45 e0             	mov    -0x20(%ebp),%eax
                    cnt[2]++;
80103efa:	8d 4e 01             	lea    0x1(%esi),%ecx
                    q2[cnt[2] - 1] = p;
80103efd:	89 3c b5 c0 a0 18 80 	mov    %edi,-0x7fe75f40(,%esi,4)
                    end2 += 1;
80103f04:	83 05 38 c6 10 80 01 	addl   $0x1,0x8010c638
                    cnt[2]++;
80103f0b:	89 0d 24 c6 10 80    	mov    %ecx,0x8010c624
80103f11:	e9 95 fc ff ff       	jmp    80103bab <aging+0x3b>
80103f16:	8d 76 00             	lea    0x0(%esi),%esi
80103f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                for (int i = 0; i < cnt[4]; i++) {
80103f20:	8b 35 2c c6 10 80    	mov    0x8010c62c,%esi
80103f26:	8b 4f 10             	mov    0x10(%edi),%ecx
80103f29:	85 f6                	test   %esi,%esi
80103f2b:	7e 26                	jle    80103f53 <aging+0x3e3>
                    if (q4[i]->pid == p->pid) {
80103f2d:	8b 15 a0 13 19 80    	mov    0x801913a0,%edx
                int ind = 0;
80103f33:	31 db                	xor    %ebx,%ebx
                    if (q4[i]->pid == p->pid) {
80103f35:	39 4a 10             	cmp    %ecx,0x10(%edx)
80103f38:	75 12                	jne    80103f4c <aging+0x3dc>
80103f3a:	eb 19                	jmp    80103f55 <aging+0x3e5>
80103f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f40:	8b 14 9d a0 13 19 80 	mov    -0x7fe6ec60(,%ebx,4),%edx
80103f47:	39 4a 10             	cmp    %ecx,0x10(%edx)
80103f4a:	74 09                	je     80103f55 <aging+0x3e5>
                for (int i = 0; i < cnt[4]; i++) {
80103f4c:	83 c3 01             	add    $0x1,%ebx
80103f4f:	39 f3                	cmp    %esi,%ebx
80103f51:	75 ed                	jne    80103f40 <aging+0x3d0>
                int ind = 0;
80103f53:	31 db                	xor    %ebx,%ebx
                cprintf("%d : Process with pid %d AGED from 4 to 3 rtime %d\n",
80103f55:	50                   	push   %eax
80103f56:	51                   	push   %ecx
80103f57:	ff 75 e4             	pushl  -0x1c(%ebp)
80103f5a:	68 20 8d 10 80       	push   $0x80108d20
                p->rrtime[3] = 0;
80103f5f:	c7 87 a4 00 00 00 00 	movl   $0x0,0xa4(%edi)
80103f66:	00 00 00 
                p->rrtime[4] = 0;
80103f69:	c7 87 a8 00 00 00 00 	movl   $0x0,0xa8(%edi)
80103f70:	00 00 00 
                p->qno = 3;
80103f73:	c7 87 90 00 00 00 03 	movl   $0x3,0x90(%edi)
80103f7a:	00 00 00 
                cprintf("%d : Process with pid %d AGED from 4 to 3 rtime %d\n",
80103f7d:	e8 de c6 ff ff       	call   80100660 <cprintf>
                cnt[4]--;
80103f82:	8b 15 2c c6 10 80    	mov    0x8010c62c,%edx
                for (int i = ind; i < cnt[4]; i++) {
80103f88:	83 c4 10             	add    $0x10,%esp
                cnt[4]--;
80103f8b:	8d 42 ff             	lea    -0x1(%edx),%eax
                for (int i = ind; i < cnt[4]; i++) {
80103f8e:	39 d8                	cmp    %ebx,%eax
                cnt[4]--;
80103f90:	a3 2c c6 10 80       	mov    %eax,0x8010c62c
                for (int i = ind; i < cnt[4]; i++) {
80103f95:	7e 1e                	jle    80103fb5 <aging+0x445>
80103f97:	8d 04 9d a0 13 19 80 	lea    -0x7fe6ec60(,%ebx,4),%eax
80103f9e:	8d 0c 95 9c 13 19 80 	lea    -0x7fe6ec64(,%edx,4),%ecx
80103fa5:	8d 76 00             	lea    0x0(%esi),%esi
                    q4[i] = q4[i + 1];
80103fa8:	8b 50 04             	mov    0x4(%eax),%edx
80103fab:	83 c0 04             	add    $0x4,%eax
80103fae:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = ind; i < cnt[4]; i++) {
80103fb1:	39 c1                	cmp    %eax,%ecx
80103fb3:	75 f3                	jne    80103fa8 <aging+0x438>
                for (int i = 0; i < cnt[3]; i++) {
80103fb5:	8b 35 28 c6 10 80    	mov    0x8010c628,%esi
80103fbb:	a1 80 2b 19 80       	mov    0x80192b80,%eax
80103fc0:	8b 57 7c             	mov    0x7c(%edi),%edx
80103fc3:	85 f6                	test   %esi,%esi
80103fc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103fc8:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80103fce:	7e 3a                	jle    8010400a <aging+0x49a>
                    if (q3[i]->pid == p->pid) {
80103fd0:	8b 0d 80 b0 18 80    	mov    0x8018b080,%ecx
80103fd6:	8b 5f 10             	mov    0x10(%edi),%ebx
80103fd9:	39 59 10             	cmp    %ebx,0x10(%ecx)
80103fdc:	0f 84 c9 fb ff ff    	je     80103bab <aging+0x3b>
                for (int i = 0; i < cnt[3]; i++) {
80103fe2:	31 c9                	xor    %ecx,%ecx
80103fe4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103fe7:	eb 17                	jmp    80104000 <aging+0x490>
80103fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    if (q3[i]->pid == p->pid) {
80103ff0:	8b 04 8d 80 b0 18 80 	mov    -0x7fe74f80(,%ecx,4),%eax
80103ff7:	39 58 10             	cmp    %ebx,0x10(%eax)
80103ffa:	0f 84 00 fe ff ff    	je     80103e00 <aging+0x290>
                for (int i = 0; i < cnt[3]; i++) {
80104000:	83 c1 01             	add    $0x1,%ecx
80104003:	39 f1                	cmp    %esi,%ecx
80104005:	75 e9                	jne    80103ff0 <aging+0x480>
80104007:	8b 45 e0             	mov    -0x20(%ebp),%eax
                    cnt[3]++;
8010400a:	8d 4e 01             	lea    0x1(%esi),%ecx
                    q3[cnt[3] - 1] = p;
8010400d:	89 3c b5 80 b0 18 80 	mov    %edi,-0x7fe74f80(,%esi,4)
                    end3 += 1;
80104014:	83 05 34 c6 10 80 01 	addl   $0x1,0x8010c634
                    cnt[3]++;
8010401b:	89 0d 28 c6 10 80    	mov    %ecx,0x8010c628
80104021:	e9 85 fb ff ff       	jmp    80103bab <aging+0x3b>
80104026:	8d 76 00             	lea    0x0(%esi),%esi
80104029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&ptable.lock);
80104030:	83 ec 0c             	sub    $0xc,%esp
80104033:	68 60 df 18 80       	push   $0x8018df60
80104038:	e8 83 11 00 00       	call   801051c0 <release>
}
8010403d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104040:	31 c0                	xor    %eax,%eax
80104042:	5b                   	pop    %ebx
80104043:	5e                   	pop    %esi
80104044:	5f                   	pop    %edi
80104045:	5d                   	pop    %ebp
80104046:	c3                   	ret    
80104047:	89 f6                	mov    %esi,%esi
80104049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104050 <userinit>:
void userinit(void) {
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	53                   	push   %ebx
80104054:	83 ec 04             	sub    $0x4,%esp
    p = allocproc();
80104057:	e8 a4 f5 ff ff       	call   80103600 <allocproc>
8010405c:	89 c3                	mov    %eax,%ebx
    initproc = p;
8010405e:	a3 58 c6 10 80       	mov    %eax,0x8010c658
    if ((p->pgdir = setupkvm()) == 0)
80104063:	e8 68 42 00 00       	call   801082d0 <setupkvm>
80104068:	85 c0                	test   %eax,%eax
8010406a:	89 43 04             	mov    %eax,0x4(%ebx)
8010406d:	0f 84 bd 00 00 00    	je     80104130 <userinit+0xe0>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104073:	83 ec 04             	sub    $0x4,%esp
80104076:	68 2c 00 00 00       	push   $0x2c
8010407b:	68 c0 c4 10 80       	push   $0x8010c4c0
80104080:	50                   	push   %eax
80104081:	e8 2a 3f 00 00       	call   80107fb0 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80104086:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80104089:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
8010408f:	6a 4c                	push   $0x4c
80104091:	6a 00                	push   $0x0
80104093:	ff 73 18             	pushl  0x18(%ebx)
80104096:	e8 75 11 00 00       	call   80105210 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010409b:	8b 43 18             	mov    0x18(%ebx),%eax
8010409e:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801040a3:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
801040a8:	83 c4 0c             	add    $0xc,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801040ab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801040af:	8b 43 18             	mov    0x18(%ebx),%eax
801040b2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
801040b6:	8b 43 18             	mov    0x18(%ebx),%eax
801040b9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040bd:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
801040c1:	8b 43 18             	mov    0x18(%ebx),%eax
801040c4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040c8:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
801040cc:	8b 43 18             	mov    0x18(%ebx),%eax
801040cf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
801040d6:	8b 43 18             	mov    0x18(%ebx),%eax
801040d9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
801040e0:	8b 43 18             	mov    0x18(%ebx),%eax
801040e3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
801040ea:	8d 43 6c             	lea    0x6c(%ebx),%eax
801040ed:	6a 10                	push   $0x10
801040ef:	68 57 8b 10 80       	push   $0x80108b57
801040f4:	50                   	push   %eax
801040f5:	e8 f6 12 00 00       	call   801053f0 <safestrcpy>
    p->cwd = namei("/");
801040fa:	c7 04 24 60 8b 10 80 	movl   $0x80108b60,(%esp)
80104101:	e8 da dd ff ff       	call   80101ee0 <namei>
80104106:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
80104109:	c7 04 24 60 df 18 80 	movl   $0x8018df60,(%esp)
80104110:	e8 eb 0f 00 00       	call   80105100 <acquire>
    p->state = RUNNABLE;
80104115:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
8010411c:	c7 04 24 60 df 18 80 	movl   $0x8018df60,(%esp)
80104123:	e8 98 10 00 00       	call   801051c0 <release>
}
80104128:	83 c4 10             	add    $0x10,%esp
8010412b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010412e:	c9                   	leave  
8010412f:	c3                   	ret    
        panic("userinit: out of memory?");
80104130:	83 ec 0c             	sub    $0xc,%esp
80104133:	68 3e 8b 10 80       	push   $0x80108b3e
80104138:	e8 53 c2 ff ff       	call   80100390 <panic>
8010413d:	8d 76 00             	lea    0x0(%esi),%esi

80104140 <growproc>:
int growproc(int n) {
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	56                   	push   %esi
80104144:	53                   	push   %ebx
80104145:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80104148:	e8 e3 0e 00 00       	call   80105030 <pushcli>
    c = mycpu();
8010414d:	e8 2e f8 ff ff       	call   80103980 <mycpu>
    p = c->proc;
80104152:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104158:	e8 13 0f 00 00       	call   80105070 <popcli>
    if (n > 0) {
8010415d:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80104160:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80104162:	7f 1c                	jg     80104180 <growproc+0x40>
    } else if (n < 0) {
80104164:	75 3a                	jne    801041a0 <growproc+0x60>
    switchuvm(curproc);
80104166:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80104169:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
8010416b:	53                   	push   %ebx
8010416c:	e8 2f 3d 00 00       	call   80107ea0 <switchuvm>
    return 0;
80104171:	83 c4 10             	add    $0x10,%esp
80104174:	31 c0                	xor    %eax,%eax
}
80104176:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104179:	5b                   	pop    %ebx
8010417a:	5e                   	pop    %esi
8010417b:	5d                   	pop    %ebp
8010417c:	c3                   	ret    
8010417d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104180:	83 ec 04             	sub    $0x4,%esp
80104183:	01 c6                	add    %eax,%esi
80104185:	56                   	push   %esi
80104186:	50                   	push   %eax
80104187:	ff 73 04             	pushl  0x4(%ebx)
8010418a:	e8 61 3f 00 00       	call   801080f0 <allocuvm>
8010418f:	83 c4 10             	add    $0x10,%esp
80104192:	85 c0                	test   %eax,%eax
80104194:	75 d0                	jne    80104166 <growproc+0x26>
            return -1;
80104196:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010419b:	eb d9                	jmp    80104176 <growproc+0x36>
8010419d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041a0:	83 ec 04             	sub    $0x4,%esp
801041a3:	01 c6                	add    %eax,%esi
801041a5:	56                   	push   %esi
801041a6:	50                   	push   %eax
801041a7:	ff 73 04             	pushl  0x4(%ebx)
801041aa:	e8 71 40 00 00       	call   80108220 <deallocuvm>
801041af:	83 c4 10             	add    $0x10,%esp
801041b2:	85 c0                	test   %eax,%eax
801041b4:	75 b0                	jne    80104166 <growproc+0x26>
801041b6:	eb de                	jmp    80104196 <growproc+0x56>
801041b8:	90                   	nop
801041b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041c0 <rand>:
    bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
801041c0:	0f b7 05 5c c0 10 80 	movzwl 0x8010c05c,%eax
unsigned rand() {
801041c7:	55                   	push   %ebp
801041c8:	89 e5                	mov    %esp,%ebp
}
801041ca:	5d                   	pop    %ebp
    bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
801041cb:	89 c2                	mov    %eax,%edx
801041cd:	89 c1                	mov    %eax,%ecx
801041cf:	66 c1 e9 03          	shr    $0x3,%cx
801041d3:	66 c1 ea 02          	shr    $0x2,%dx
801041d7:	31 ca                	xor    %ecx,%edx
801041d9:	89 c1                	mov    %eax,%ecx
801041db:	31 c2                	xor    %eax,%edx
801041dd:	66 c1 e9 05          	shr    $0x5,%cx
    return lfsr = (lfsr >> 1) | (bit << 15);
801041e1:	66 d1 e8             	shr    %ax
    bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
801041e4:	31 ca                	xor    %ecx,%edx
801041e6:	83 e2 01             	and    $0x1,%edx
801041e9:	0f b7 ca             	movzwl %dx,%ecx
    return lfsr = (lfsr >> 1) | (bit << 15);
801041ec:	c1 e2 0f             	shl    $0xf,%edx
801041ef:	09 d0                	or     %edx,%eax
    bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
801041f1:	89 0d 60 b0 18 80    	mov    %ecx,0x8018b060
    return lfsr = (lfsr >> 1) | (bit << 15);
801041f7:	66 a3 5c c0 10 80    	mov    %ax,0x8010c05c
801041fd:	0f b7 c0             	movzwl %ax,%eax
}
80104200:	c3                   	ret    
80104201:	eb 0d                	jmp    80104210 <fork>
80104203:	90                   	nop
80104204:	90                   	nop
80104205:	90                   	nop
80104206:	90                   	nop
80104207:	90                   	nop
80104208:	90                   	nop
80104209:	90                   	nop
8010420a:	90                   	nop
8010420b:	90                   	nop
8010420c:	90                   	nop
8010420d:	90                   	nop
8010420e:	90                   	nop
8010420f:	90                   	nop

80104210 <fork>:
int fork(void) {
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	56                   	push   %esi
80104215:	53                   	push   %ebx
80104216:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80104219:	e8 12 0e 00 00       	call   80105030 <pushcli>
    c = mycpu();
8010421e:	e8 5d f7 ff ff       	call   80103980 <mycpu>
    p = c->proc;
80104223:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104229:	e8 42 0e 00 00       	call   80105070 <popcli>
    if ((np = allocproc()) == 0) {
8010422e:	e8 cd f3 ff ff       	call   80103600 <allocproc>
80104233:	85 c0                	test   %eax,%eax
80104235:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104238:	0f 84 ce 00 00 00    	je     8010430c <fork+0xfc>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
8010423e:	83 ec 08             	sub    $0x8,%esp
80104241:	ff 33                	pushl  (%ebx)
80104243:	ff 73 04             	pushl  0x4(%ebx)
80104246:	89 c7                	mov    %eax,%edi
80104248:	e8 53 41 00 00       	call   801083a0 <copyuvm>
8010424d:	83 c4 10             	add    $0x10,%esp
80104250:	85 c0                	test   %eax,%eax
80104252:	89 47 04             	mov    %eax,0x4(%edi)
80104255:	0f 84 b8 00 00 00    	je     80104313 <fork+0x103>
    np->sz = curproc->sz;
8010425b:	8b 03                	mov    (%ebx),%eax
8010425d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104260:	89 01                	mov    %eax,(%ecx)
    np->parent = curproc;
80104262:	89 59 14             	mov    %ebx,0x14(%ecx)
80104265:	89 c8                	mov    %ecx,%eax
    *np->tf = *curproc->tf;
80104267:	8b 79 18             	mov    0x18(%ecx),%edi
8010426a:	8b 73 18             	mov    0x18(%ebx),%esi
8010426d:	b9 13 00 00 00       	mov    $0x13,%ecx
80104272:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++)
80104274:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
80104276:	8b 40 18             	mov    0x18(%eax),%eax
80104279:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
        if (curproc->ofile[i])
80104280:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104284:	85 c0                	test   %eax,%eax
80104286:	74 13                	je     8010429b <fork+0x8b>
            np->ofile[i] = filedup(curproc->ofile[i]);
80104288:	83 ec 0c             	sub    $0xc,%esp
8010428b:	50                   	push   %eax
8010428c:	e8 5f cb ff ff       	call   80100df0 <filedup>
80104291:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104294:	83 c4 10             	add    $0x10,%esp
80104297:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
    for (i = 0; i < NOFILE; i++)
8010429b:	83 c6 01             	add    $0x1,%esi
8010429e:	83 fe 10             	cmp    $0x10,%esi
801042a1:	75 dd                	jne    80104280 <fork+0x70>
    np->cwd = idup(curproc->cwd);
801042a3:	83 ec 0c             	sub    $0xc,%esp
801042a6:	ff 73 68             	pushl  0x68(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042a9:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
801042ac:	e8 9f d3 ff ff       	call   80101650 <idup>
801042b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042b4:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
801042b7:	89 47 68             	mov    %eax,0x68(%edi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042ba:	8d 47 6c             	lea    0x6c(%edi),%eax
801042bd:	6a 10                	push   $0x10
801042bf:	53                   	push   %ebx
801042c0:	50                   	push   %eax
801042c1:	e8 2a 11 00 00       	call   801053f0 <safestrcpy>
    pid = np->pid;
801042c6:	8b 5f 10             	mov    0x10(%edi),%ebx
    np->qno = 0;
801042c9:	c7 87 90 00 00 00 00 	movl   $0x0,0x90(%edi)
801042d0:	00 00 00 
    cprintf("Child with pid %d created\n", pid);
801042d3:	58                   	pop    %eax
801042d4:	5a                   	pop    %edx
801042d5:	53                   	push   %ebx
801042d6:	68 62 8b 10 80       	push   $0x80108b62
801042db:	e8 80 c3 ff ff       	call   80100660 <cprintf>
    acquire(&ptable.lock);
801042e0:	c7 04 24 60 df 18 80 	movl   $0x8018df60,(%esp)
801042e7:	e8 14 0e 00 00       	call   80105100 <acquire>
    np->state = RUNNABLE;
801042ec:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
    release(&ptable.lock);
801042f3:	c7 04 24 60 df 18 80 	movl   $0x8018df60,(%esp)
801042fa:	e8 c1 0e 00 00       	call   801051c0 <release>
    return pid;
801042ff:	83 c4 10             	add    $0x10,%esp
}
80104302:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104305:	89 d8                	mov    %ebx,%eax
80104307:	5b                   	pop    %ebx
80104308:	5e                   	pop    %esi
80104309:	5f                   	pop    %edi
8010430a:	5d                   	pop    %ebp
8010430b:	c3                   	ret    
        return -1;
8010430c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104311:	eb ef                	jmp    80104302 <fork+0xf2>
        kfree(np->kstack);
80104313:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80104316:	83 ec 0c             	sub    $0xc,%esp
        return -1;
80104319:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
        kfree(np->kstack);
8010431e:	ff 77 08             	pushl  0x8(%edi)
80104321:	e8 ea df ff ff       	call   80102310 <kfree>
        np->kstack = 0;
80104326:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
        np->state = UNUSED;
8010432d:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
        return -1;
80104334:	83 c4 10             	add    $0x10,%esp
80104337:	eb c9                	jmp    80104302 <fork+0xf2>
80104339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104340 <set_priority>:
int set_priority(int pid, int priority) {
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	53                   	push   %ebx
80104346:	83 ec 18             	sub    $0x18,%esp
80104349:	8b 7d 08             	mov    0x8(%ebp),%edi
8010434c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    acquire(&ptable.lock);
8010434f:	68 60 df 18 80       	push   $0x8018df60
80104354:	e8 a7 0d 00 00       	call   80105100 <acquire>
80104359:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010435c:	b8 94 df 18 80       	mov    $0x8018df94,%eax
80104361:	eb 11                	jmp    80104374 <set_priority+0x34>
80104363:	90                   	nop
80104364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104368:	05 d0 00 00 00       	add    $0xd0,%eax
8010436d:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104372:	73 3c                	jae    801043b0 <set_priority+0x70>
        if (p && p->pid == pid) {
80104374:	39 78 10             	cmp    %edi,0x10(%eax)
80104377:	75 ef                	jne    80104368 <set_priority+0x28>
            cprintf("set priority of %d to %d\n", p->pid, p->priority);
80104379:	83 ec 04             	sub    $0x4,%esp
            val = p->priority;
8010437c:	8b b0 8c 00 00 00    	mov    0x8c(%eax),%esi
            p->priority = priority;
80104382:	89 98 8c 00 00 00    	mov    %ebx,0x8c(%eax)
            cprintf("set priority of %d to %d\n", p->pid, p->priority);
80104388:	53                   	push   %ebx
80104389:	57                   	push   %edi
8010438a:	68 7d 8b 10 80       	push   $0x80108b7d
8010438f:	e8 cc c2 ff ff       	call   80100660 <cprintf>
            break;
80104394:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104397:	83 ec 0c             	sub    $0xc,%esp
8010439a:	68 60 df 18 80       	push   $0x8018df60
8010439f:	e8 1c 0e 00 00       	call   801051c0 <release>
}
801043a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043a7:	89 f0                	mov    %esi,%eax
801043a9:	5b                   	pop    %ebx
801043aa:	5e                   	pop    %esi
801043ab:	5f                   	pop    %edi
801043ac:	5d                   	pop    %ebp
801043ad:	c3                   	ret    
801043ae:	66 90                	xchg   %ax,%ax
    int val = -1;  // in order to return old priority of the process
801043b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801043b5:	eb e0                	jmp    80104397 <set_priority+0x57>
801043b7:	89 f6                	mov    %esi,%esi
801043b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043c0 <check_priority>:
int check_priority(int prt) {
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 10             	sub    $0x10,%esp
801043c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
801043ca:	68 60 df 18 80       	push   $0x8018df60
801043cf:	e8 2c 0d 00 00       	call   80105100 <acquire>
801043d4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043d7:	b8 94 df 18 80       	mov    $0x8018df94,%eax
801043dc:	eb 0e                	jmp    801043ec <check_priority+0x2c>
801043de:	66 90                	xchg   %ax,%ax
801043e0:	05 d0 00 00 00       	add    $0xd0,%eax
801043e5:	3d 94 13 19 80       	cmp    $0x80191394,%eax
801043ea:	73 2c                	jae    80104418 <check_priority+0x58>
        if (p->state != RUNNABLE)
801043ec:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801043f0:	75 ee                	jne    801043e0 <check_priority+0x20>
        if (p->priority <= prt) {
801043f2:	39 98 8c 00 00 00    	cmp    %ebx,0x8c(%eax)
801043f8:	7f e6                	jg     801043e0 <check_priority+0x20>
            release(&ptable.lock);
801043fa:	83 ec 0c             	sub    $0xc,%esp
801043fd:	68 60 df 18 80       	push   $0x8018df60
80104402:	e8 b9 0d 00 00       	call   801051c0 <release>
            return 1;
80104407:	83 c4 10             	add    $0x10,%esp
8010440a:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010440f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104412:	c9                   	leave  
80104413:	c3                   	ret    
80104414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80104418:	83 ec 0c             	sub    $0xc,%esp
8010441b:	68 60 df 18 80       	push   $0x8018df60
80104420:	e8 9b 0d 00 00       	call   801051c0 <release>
    return 0;
80104425:	83 c4 10             	add    $0x10,%esp
80104428:	31 c0                	xor    %eax,%eax
}
8010442a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010442d:	c9                   	leave  
8010442e:	c3                   	ret    
8010442f:	90                   	nop

80104430 <scheduler>:
void scheduler(void) {
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	57                   	push   %edi
80104434:	56                   	push   %esi
80104435:	53                   	push   %ebx
80104436:	83 ec 0c             	sub    $0xc,%esp
    struct cpu *c = mycpu();
80104439:	e8 42 f5 ff ff       	call   80103980 <mycpu>
8010443e:	8d 78 04             	lea    0x4(%eax),%edi
80104441:	89 c6                	mov    %eax,%esi
    c->proc = 0;
80104443:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010444a:	00 00 00 
8010444d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104450:	fb                   	sti    
        acquire(&ptable.lock);
80104451:	83 ec 0c             	sub    $0xc,%esp
80104454:	68 60 df 18 80       	push   $0x8018df60
80104459:	e8 a2 0c 00 00       	call   80105100 <acquire>
            for (int i = 0; i < cnt[0]; i++) {
8010445e:	8b 15 1c c6 10 80    	mov    0x8010c61c,%edx
80104464:	83 c4 10             	add    $0x10,%esp
80104467:	85 d2                	test   %edx,%edx
80104469:	0f 8e b1 00 00 00    	jle    80104520 <scheduler+0xf0>
                p = q0[i];
8010446f:	8b 1d c0 cf 18 80    	mov    0x8018cfc0,%ebx
            for (int i = 0; i < cnt[0]; i++) {
80104475:	31 c0                	xor    %eax,%eax
                if (p->state != RUNNABLE)
80104477:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010447b:	74 18                	je     80104495 <scheduler+0x65>
            for (int i = 0; i < cnt[0]; i++) {
8010447d:	83 c0 01             	add    $0x1,%eax
80104480:	39 c2                	cmp    %eax,%edx
80104482:	0f 84 98 00 00 00    	je     80104520 <scheduler+0xf0>
                p = q0[i];
80104488:	8b 1c 85 c0 cf 18 80 	mov    -0x7fe73040(,%eax,4),%ebx
                if (p->state != RUNNABLE)
8010448f:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104493:	75 e8                	jne    8010447d <scheduler+0x4d>
                beg0 = i;
80104495:	a3 54 c6 10 80       	mov    %eax,0x8010c654
                switchuvm(p);
8010449a:	83 ec 0c             	sub    $0xc,%esp
                c->proc = p;
8010449d:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
                switchuvm(p);
801044a3:	53                   	push   %ebx
801044a4:	e8 f7 39 00 00       	call   80107ea0 <switchuvm>
                p->stat.num_run++;
801044a9:	83 83 b4 00 00 00 01 	addl   $0x1,0xb4(%ebx)
                p->state = RUNNING;
801044b0:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
                cprintf(
801044b7:	83 c4 0c             	add    $0xc,%esp
                    ticks - p->rtime - p->ctime - p->aging_time);
801044ba:	8b 15 80 2b 19 80    	mov    0x80192b80,%edx
801044c0:	8b 8b 80 00 00 00    	mov    0x80(%ebx),%ecx
801044c6:	89 d0                	mov    %edx,%eax
801044c8:	29 c8                	sub    %ecx,%eax
801044ca:	2b 43 7c             	sub    0x7c(%ebx),%eax
                cprintf(
801044cd:	2b 83 94 00 00 00    	sub    0x94(%ebx),%eax
801044d3:	50                   	push   %eax
                    ticks, p->name, p->pid, p->qno, p->rtime,
801044d4:	8d 43 6c             	lea    0x6c(%ebx),%eax
                cprintf(
801044d7:	51                   	push   %ecx
801044d8:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
801044de:	ff 73 10             	pushl  0x10(%ebx)
801044e1:	50                   	push   %eax
801044e2:	52                   	push   %edx
801044e3:	68 54 8d 10 80       	push   $0x80108d54
801044e8:	e8 73 c1 ff ff       	call   80100660 <cprintf>
                swtch(&(c->scheduler), p->context);
801044ed:	83 c4 18             	add    $0x18,%esp
801044f0:	ff 73 1c             	pushl  0x1c(%ebx)
801044f3:	57                   	push   %edi
801044f4:	e8 52 0f 00 00       	call   8010544b <swtch>
                switchkvm();
801044f9:	e8 82 39 00 00       	call   80107e80 <switchkvm>
                c->proc = 0;
801044fe:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104505:	00 00 00 
                break;
80104508:	83 c4 10             	add    $0x10,%esp
        release(&ptable.lock);
8010450b:	83 ec 0c             	sub    $0xc,%esp
8010450e:	68 60 df 18 80       	push   $0x8018df60
80104513:	e8 a8 0c 00 00       	call   801051c0 <release>
    for (;;) {
80104518:	83 c4 10             	add    $0x10,%esp
8010451b:	e9 30 ff ff ff       	jmp    80104450 <scheduler+0x20>
            for (int i = 0; i < cnt[1]; i++) {
80104520:	8b 15 20 c6 10 80    	mov    0x8010c620,%edx
80104526:	85 d2                	test   %edx,%edx
80104528:	7e 36                	jle    80104560 <scheduler+0x130>
                p = q1[i];
8010452a:	8b 1d 20 c0 18 80    	mov    0x8018c020,%ebx
            for (int i = 0; i < cnt[1]; i++) {
80104530:	31 c0                	xor    %eax,%eax
                if (p->state != RUNNABLE)
80104532:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104536:	74 14                	je     8010454c <scheduler+0x11c>
            for (int i = 0; i < cnt[1]; i++) {
80104538:	83 c0 01             	add    $0x1,%eax
8010453b:	39 d0                	cmp    %edx,%eax
8010453d:	74 21                	je     80104560 <scheduler+0x130>
                p = q1[i];
8010453f:	8b 1c 85 20 c0 18 80 	mov    -0x7fe73fe0(,%eax,4),%ebx
                if (p->state != RUNNABLE)
80104546:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010454a:	75 ec                	jne    80104538 <scheduler+0x108>
                beg1 = i;
8010454c:	a3 50 c6 10 80       	mov    %eax,0x8010c650
80104551:	e9 44 ff ff ff       	jmp    8010449a <scheduler+0x6a>
80104556:	8d 76 00             	lea    0x0(%esi),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            for (int i = 0; i < cnt[2]; i++) {
80104560:	8b 15 24 c6 10 80    	mov    0x8010c624,%edx
80104566:	85 d2                	test   %edx,%edx
80104568:	7e 36                	jle    801045a0 <scheduler+0x170>
                p = q2[i];
8010456a:	8b 1d c0 a0 18 80    	mov    0x8018a0c0,%ebx
            for (int i = 0; i < cnt[2]; i++) {
80104570:	31 c0                	xor    %eax,%eax
                if (p->state != RUNNABLE)
80104572:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104576:	74 1c                	je     80104594 <scheduler+0x164>
80104578:	90                   	nop
80104579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (int i = 0; i < cnt[2]; i++) {
80104580:	83 c0 01             	add    $0x1,%eax
80104583:	39 d0                	cmp    %edx,%eax
80104585:	74 19                	je     801045a0 <scheduler+0x170>
                p = q2[i];
80104587:	8b 1c 85 c0 a0 18 80 	mov    -0x7fe75f40(,%eax,4),%ebx
                if (p->state != RUNNABLE)
8010458e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104592:	75 ec                	jne    80104580 <scheduler+0x150>
                beg2 = i;
80104594:	a3 4c c6 10 80       	mov    %eax,0x8010c64c
80104599:	e9 fc fe ff ff       	jmp    8010449a <scheduler+0x6a>
8010459e:	66 90                	xchg   %ax,%ax
            for (int i = 0; i < cnt[3]; i++) {
801045a0:	8b 15 28 c6 10 80    	mov    0x8010c628,%edx
801045a6:	85 d2                	test   %edx,%edx
801045a8:	7e 36                	jle    801045e0 <scheduler+0x1b0>
                p = q3[i];
801045aa:	8b 1d 80 b0 18 80    	mov    0x8018b080,%ebx
                if (p->state != RUNNABLE)
801045b0:	31 c0                	xor    %eax,%eax
801045b2:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801045b6:	74 1c                	je     801045d4 <scheduler+0x1a4>
801045b8:	90                   	nop
801045b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (int i = 0; i < cnt[3]; i++) {
801045c0:	83 c0 01             	add    $0x1,%eax
801045c3:	39 d0                	cmp    %edx,%eax
801045c5:	74 19                	je     801045e0 <scheduler+0x1b0>
                p = q3[i];
801045c7:	8b 1c 85 80 b0 18 80 	mov    -0x7fe74f80(,%eax,4),%ebx
                if (p->state != RUNNABLE)
801045ce:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801045d2:	75 ec                	jne    801045c0 <scheduler+0x190>
                beg3 = i;
801045d4:	a3 48 c6 10 80       	mov    %eax,0x8010c648
801045d9:	e9 bc fe ff ff       	jmp    8010449a <scheduler+0x6a>
801045de:	66 90                	xchg   %ax,%ax
            for (int i = 0; i < cnt[4]; i++) {
801045e0:	8b 15 2c c6 10 80    	mov    0x8010c62c,%edx
801045e6:	85 d2                	test   %edx,%edx
801045e8:	0f 8e 1d ff ff ff    	jle    8010450b <scheduler+0xdb>
                p = q4[i];
801045ee:	8b 1d a0 13 19 80    	mov    0x801913a0,%ebx
            for (int i = 0; i < cnt[4]; i++) {
801045f4:	31 c0                	xor    %eax,%eax
                if (p->state != RUNNABLE)
801045f6:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801045fa:	74 1c                	je     80104618 <scheduler+0x1e8>
801045fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (int i = 0; i < cnt[4]; i++) {
80104600:	83 c0 01             	add    $0x1,%eax
80104603:	39 d0                	cmp    %edx,%eax
80104605:	0f 84 00 ff ff ff    	je     8010450b <scheduler+0xdb>
                p = q4[i];
8010460b:	8b 1c 85 a0 13 19 80 	mov    -0x7fe6ec60(,%eax,4),%ebx
                if (p->state != RUNNABLE)
80104612:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104616:	75 e8                	jne    80104600 <scheduler+0x1d0>
                beg4 = i;
80104618:	a3 44 c6 10 80       	mov    %eax,0x8010c644
8010461d:	e9 78 fe ff ff       	jmp    8010449a <scheduler+0x6a>
80104622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104630 <sched>:
void sched(void) {
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
    pushcli();
80104635:	e8 f6 09 00 00       	call   80105030 <pushcli>
    c = mycpu();
8010463a:	e8 41 f3 ff ff       	call   80103980 <mycpu>
    p = c->proc;
8010463f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104645:	e8 26 0a 00 00       	call   80105070 <popcli>
    if (!holding(&ptable.lock))
8010464a:	83 ec 0c             	sub    $0xc,%esp
8010464d:	68 60 df 18 80       	push   $0x8018df60
80104652:	e8 79 0a 00 00       	call   801050d0 <holding>
80104657:	83 c4 10             	add    $0x10,%esp
8010465a:	85 c0                	test   %eax,%eax
8010465c:	74 4f                	je     801046ad <sched+0x7d>
    if (mycpu()->ncli != 1)
8010465e:	e8 1d f3 ff ff       	call   80103980 <mycpu>
80104663:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010466a:	75 68                	jne    801046d4 <sched+0xa4>
    if (p->state == RUNNING)
8010466c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104670:	74 55                	je     801046c7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104672:	9c                   	pushf  
80104673:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80104674:	f6 c4 02             	test   $0x2,%ah
80104677:	75 41                	jne    801046ba <sched+0x8a>
    intena = mycpu()->intena;
80104679:	e8 02 f3 ff ff       	call   80103980 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
8010467e:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
80104681:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
80104687:	e8 f4 f2 ff ff       	call   80103980 <mycpu>
8010468c:	83 ec 08             	sub    $0x8,%esp
8010468f:	ff 70 04             	pushl  0x4(%eax)
80104692:	53                   	push   %ebx
80104693:	e8 b3 0d 00 00       	call   8010544b <swtch>
    mycpu()->intena = intena;
80104698:	e8 e3 f2 ff ff       	call   80103980 <mycpu>
}
8010469d:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
801046a0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801046a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046a9:	5b                   	pop    %ebx
801046aa:	5e                   	pop    %esi
801046ab:	5d                   	pop    %ebp
801046ac:	c3                   	ret    
        panic("sched ptable.lock");
801046ad:	83 ec 0c             	sub    $0xc,%esp
801046b0:	68 97 8b 10 80       	push   $0x80108b97
801046b5:	e8 d6 bc ff ff       	call   80100390 <panic>
        panic("sched interruptible");
801046ba:	83 ec 0c             	sub    $0xc,%esp
801046bd:	68 c3 8b 10 80       	push   $0x80108bc3
801046c2:	e8 c9 bc ff ff       	call   80100390 <panic>
        panic("sched running");
801046c7:	83 ec 0c             	sub    $0xc,%esp
801046ca:	68 b5 8b 10 80       	push   $0x80108bb5
801046cf:	e8 bc bc ff ff       	call   80100390 <panic>
        panic("sched locks");
801046d4:	83 ec 0c             	sub    $0xc,%esp
801046d7:	68 a9 8b 10 80       	push   $0x80108ba9
801046dc:	e8 af bc ff ff       	call   80100390 <panic>
801046e1:	eb 0d                	jmp    801046f0 <exit>
801046e3:	90                   	nop
801046e4:	90                   	nop
801046e5:	90                   	nop
801046e6:	90                   	nop
801046e7:	90                   	nop
801046e8:	90                   	nop
801046e9:	90                   	nop
801046ea:	90                   	nop
801046eb:	90                   	nop
801046ec:	90                   	nop
801046ed:	90                   	nop
801046ee:	90                   	nop
801046ef:	90                   	nop

801046f0 <exit>:
void exit(void) {
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	57                   	push   %edi
801046f4:	56                   	push   %esi
801046f5:	53                   	push   %ebx
801046f6:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
801046f9:	e8 32 09 00 00       	call   80105030 <pushcli>
    c = mycpu();
801046fe:	e8 7d f2 ff ff       	call   80103980 <mycpu>
    p = c->proc;
80104703:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104709:	e8 62 09 00 00       	call   80105070 <popcli>
    if (curproc == initproc)
8010470e:	39 35 58 c6 10 80    	cmp    %esi,0x8010c658
80104714:	8d 5e 28             	lea    0x28(%esi),%ebx
80104717:	8d 7e 68             	lea    0x68(%esi),%edi
8010471a:	0f 84 fc 00 00 00    	je     8010481c <exit+0x12c>
        if (curproc->ofile[fd]) {
80104720:	8b 03                	mov    (%ebx),%eax
80104722:	85 c0                	test   %eax,%eax
80104724:	74 12                	je     80104738 <exit+0x48>
            fileclose(curproc->ofile[fd]);
80104726:	83 ec 0c             	sub    $0xc,%esp
80104729:	50                   	push   %eax
8010472a:	e8 11 c7 ff ff       	call   80100e40 <fileclose>
            curproc->ofile[fd] = 0;
8010472f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104735:	83 c4 10             	add    $0x10,%esp
80104738:	83 c3 04             	add    $0x4,%ebx
    for (fd = 0; fd < NOFILE; fd++) {
8010473b:	39 fb                	cmp    %edi,%ebx
8010473d:	75 e1                	jne    80104720 <exit+0x30>
    begin_op();
8010473f:	e8 5c e4 ff ff       	call   80102ba0 <begin_op>
    iput(curproc->cwd);
80104744:	83 ec 0c             	sub    $0xc,%esp
80104747:	ff 76 68             	pushl  0x68(%esi)
8010474a:	e8 61 d0 ff ff       	call   801017b0 <iput>
    end_op();
8010474f:	e8 bc e4 ff ff       	call   80102c10 <end_op>
    curproc->cwd = 0;
80104754:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
    acquire(&ptable.lock);
8010475b:	c7 04 24 60 df 18 80 	movl   $0x8018df60,(%esp)
80104762:	e8 99 09 00 00       	call   80105100 <acquire>
    wakeup1(curproc->parent);
80104767:	8b 56 14             	mov    0x14(%esi),%edx
8010476a:	83 c4 10             	add    $0x10,%esp
// PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void wakeup1(void *chan) {
    struct proc *p;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010476d:	b8 94 df 18 80       	mov    $0x8018df94,%eax
80104772:	eb 10                	jmp    80104784 <exit+0x94>
80104774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104778:	05 d0 00 00 00       	add    $0xd0,%eax
8010477d:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104782:	73 1e                	jae    801047a2 <exit+0xb2>
        if (p->state == SLEEPING && p->chan == chan) {
80104784:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104788:	75 ee                	jne    80104778 <exit+0x88>
8010478a:	3b 50 20             	cmp    0x20(%eax),%edx
8010478d:	75 e9                	jne    80104778 <exit+0x88>
            p->state = RUNNABLE;
8010478f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104796:	05 d0 00 00 00       	add    $0xd0,%eax
8010479b:	3d 94 13 19 80       	cmp    $0x80191394,%eax
801047a0:	72 e2                	jb     80104784 <exit+0x94>
            p->parent = initproc;
801047a2:	8b 0d 58 c6 10 80    	mov    0x8010c658,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801047a8:	ba 94 df 18 80       	mov    $0x8018df94,%edx
801047ad:	eb 0f                	jmp    801047be <exit+0xce>
801047af:	90                   	nop
801047b0:	81 c2 d0 00 00 00    	add    $0xd0,%edx
801047b6:	81 fa 94 13 19 80    	cmp    $0x80191394,%edx
801047bc:	73 3a                	jae    801047f8 <exit+0x108>
        if (p->parent == curproc) {
801047be:	39 72 14             	cmp    %esi,0x14(%edx)
801047c1:	75 ed                	jne    801047b0 <exit+0xc0>
            if (p->state == ZOMBIE)
801047c3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
801047c7:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
801047ca:	75 e4                	jne    801047b0 <exit+0xc0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047cc:	b8 94 df 18 80       	mov    $0x8018df94,%eax
801047d1:	eb 11                	jmp    801047e4 <exit+0xf4>
801047d3:	90                   	nop
801047d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047d8:	05 d0 00 00 00       	add    $0xd0,%eax
801047dd:	3d 94 13 19 80       	cmp    $0x80191394,%eax
801047e2:	73 cc                	jae    801047b0 <exit+0xc0>
        if (p->state == SLEEPING && p->chan == chan) {
801047e4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047e8:	75 ee                	jne    801047d8 <exit+0xe8>
801047ea:	3b 48 20             	cmp    0x20(%eax),%ecx
801047ed:	75 e9                	jne    801047d8 <exit+0xe8>
            p->state = RUNNABLE;
801047ef:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801047f6:	eb e0                	jmp    801047d8 <exit+0xe8>
    curproc->etime = ticks;  // assign endtime value
801047f8:	a1 80 2b 19 80       	mov    0x80192b80,%eax
    curproc->state = ZOMBIE;
801047fd:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    curproc->etime = ticks;  // assign endtime value
80104804:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
    sched();
8010480a:	e8 21 fe ff ff       	call   80104630 <sched>
    panic("zombie exit");
8010480f:	83 ec 0c             	sub    $0xc,%esp
80104812:	68 e4 8b 10 80       	push   $0x80108be4
80104817:	e8 74 bb ff ff       	call   80100390 <panic>
        panic("init exiting");
8010481c:	83 ec 0c             	sub    $0xc,%esp
8010481f:	68 d7 8b 10 80       	push   $0x80108bd7
80104824:	e8 67 bb ff ff       	call   80100390 <panic>
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104830 <yield>:
void yield(void) {
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  // DOC: yieldlock
80104837:	68 60 df 18 80       	push   $0x8018df60
8010483c:	e8 bf 08 00 00       	call   80105100 <acquire>
    pushcli();
80104841:	e8 ea 07 00 00       	call   80105030 <pushcli>
    c = mycpu();
80104846:	e8 35 f1 ff ff       	call   80103980 <mycpu>
    p = c->proc;
8010484b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104851:	e8 1a 08 00 00       	call   80105070 <popcli>
    myproc()->state = RUNNABLE;
80104856:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
8010485d:	e8 ce fd ff ff       	call   80104630 <sched>
    release(&ptable.lock);
80104862:	c7 04 24 60 df 18 80 	movl   $0x8018df60,(%esp)
80104869:	e8 52 09 00 00       	call   801051c0 <release>
}
8010486e:	83 c4 10             	add    $0x10,%esp
80104871:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104874:	c9                   	leave  
80104875:	c3                   	ret    
80104876:	8d 76 00             	lea    0x0(%esi),%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104880 <sleep>:
void sleep(void *chan, struct spinlock *lk) {
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	57                   	push   %edi
80104884:	56                   	push   %esi
80104885:	53                   	push   %ebx
80104886:	83 ec 0c             	sub    $0xc,%esp
80104889:	8b 7d 08             	mov    0x8(%ebp),%edi
8010488c:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
8010488f:	e8 9c 07 00 00       	call   80105030 <pushcli>
    c = mycpu();
80104894:	e8 e7 f0 ff ff       	call   80103980 <mycpu>
    p = c->proc;
80104899:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
8010489f:	e8 cc 07 00 00       	call   80105070 <popcli>
    if (p == 0)
801048a4:	85 db                	test   %ebx,%ebx
801048a6:	0f 84 87 00 00 00    	je     80104933 <sleep+0xb3>
    if (lk == 0)
801048ac:	85 f6                	test   %esi,%esi
801048ae:	74 76                	je     80104926 <sleep+0xa6>
    if (lk != &ptable.lock) {   // DOC: sleeplock0
801048b0:	81 fe 60 df 18 80    	cmp    $0x8018df60,%esi
801048b6:	74 50                	je     80104908 <sleep+0x88>
        acquire(&ptable.lock);  // DOC: sleeplock1
801048b8:	83 ec 0c             	sub    $0xc,%esp
801048bb:	68 60 df 18 80       	push   $0x8018df60
801048c0:	e8 3b 08 00 00       	call   80105100 <acquire>
        release(lk);
801048c5:	89 34 24             	mov    %esi,(%esp)
801048c8:	e8 f3 08 00 00       	call   801051c0 <release>
    p->chan = chan;
801048cd:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
801048d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
801048d7:	e8 54 fd ff ff       	call   80104630 <sched>
    p->chan = 0;
801048dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
801048e3:	c7 04 24 60 df 18 80 	movl   $0x8018df60,(%esp)
801048ea:	e8 d1 08 00 00       	call   801051c0 <release>
        acquire(lk);
801048ef:	89 75 08             	mov    %esi,0x8(%ebp)
801048f2:	83 c4 10             	add    $0x10,%esp
}
801048f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048f8:	5b                   	pop    %ebx
801048f9:	5e                   	pop    %esi
801048fa:	5f                   	pop    %edi
801048fb:	5d                   	pop    %ebp
        acquire(lk);
801048fc:	e9 ff 07 00 00       	jmp    80105100 <acquire>
80104901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->chan = chan;
80104908:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010490b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104912:	e8 19 fd ff ff       	call   80104630 <sched>
    p->chan = 0;
80104917:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010491e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104921:	5b                   	pop    %ebx
80104922:	5e                   	pop    %esi
80104923:	5f                   	pop    %edi
80104924:	5d                   	pop    %ebp
80104925:	c3                   	ret    
        panic("sleep without lk");
80104926:	83 ec 0c             	sub    $0xc,%esp
80104929:	68 f6 8b 10 80       	push   $0x80108bf6
8010492e:	e8 5d ba ff ff       	call   80100390 <panic>
        panic("sleep");
80104933:	83 ec 0c             	sub    $0xc,%esp
80104936:	68 f0 8b 10 80       	push   $0x80108bf0
8010493b:	e8 50 ba ff ff       	call   80100390 <panic>

80104940 <wait>:
int wait(void) {
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
    pushcli();
80104945:	e8 e6 06 00 00       	call   80105030 <pushcli>
    c = mycpu();
8010494a:	e8 31 f0 ff ff       	call   80103980 <mycpu>
    p = c->proc;
8010494f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104955:	e8 16 07 00 00       	call   80105070 <popcli>
    acquire(&ptable.lock);
8010495a:	83 ec 0c             	sub    $0xc,%esp
8010495d:	68 60 df 18 80       	push   $0x8018df60
80104962:	e8 99 07 00 00       	call   80105100 <acquire>
80104967:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
8010496a:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010496c:	bb 94 df 18 80       	mov    $0x8018df94,%ebx
80104971:	eb 13                	jmp    80104986 <wait+0x46>
80104973:	90                   	nop
80104974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104978:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
8010497e:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
80104984:	73 1e                	jae    801049a4 <wait+0x64>
            if (p->parent != curproc)
80104986:	39 73 14             	cmp    %esi,0x14(%ebx)
80104989:	75 ed                	jne    80104978 <wait+0x38>
            if (p->state == ZOMBIE) {
8010498b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010498f:	74 37                	je     801049c8 <wait+0x88>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104991:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
            havekids = 1;
80104997:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010499c:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
801049a2:	72 e2                	jb     80104986 <wait+0x46>
        if (!havekids || curproc->killed) {
801049a4:	85 c0                	test   %eax,%eax
801049a6:	74 76                	je     80104a1e <wait+0xde>
801049a8:	8b 46 24             	mov    0x24(%esi),%eax
801049ab:	85 c0                	test   %eax,%eax
801049ad:	75 6f                	jne    80104a1e <wait+0xde>
        sleep(curproc, &ptable.lock);  // DOC: wait-sleep
801049af:	83 ec 08             	sub    $0x8,%esp
801049b2:	68 60 df 18 80       	push   $0x8018df60
801049b7:	56                   	push   %esi
801049b8:	e8 c3 fe ff ff       	call   80104880 <sleep>
        havekids = 0;
801049bd:	83 c4 10             	add    $0x10,%esp
801049c0:	eb a8                	jmp    8010496a <wait+0x2a>
801049c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                kfree(p->kstack);
801049c8:	83 ec 0c             	sub    $0xc,%esp
801049cb:	ff 73 08             	pushl  0x8(%ebx)
801049ce:	e8 3d d9 ff ff       	call   80102310 <kfree>
                freevm(p->pgdir);
801049d3:	5a                   	pop    %edx
801049d4:	ff 73 04             	pushl  0x4(%ebx)
                p->kstack = 0;
801049d7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
801049de:	e8 6d 38 00 00       	call   80108250 <freevm>
                release(&ptable.lock);
801049e3:	c7 04 24 60 df 18 80 	movl   $0x8018df60,(%esp)
                p->pid = 0;
801049ea:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
801049f1:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
801049f8:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
801049fc:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80104a03:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
80104a0a:	e8 b1 07 00 00       	call   801051c0 <release>
                return pid;
80104a0f:	83 c4 10             	add    $0x10,%esp
}
80104a12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a1a:	5b                   	pop    %ebx
80104a1b:	5e                   	pop    %esi
80104a1c:	5d                   	pop    %ebp
80104a1d:	c3                   	ret    
            release(&ptable.lock);
80104a1e:	83 ec 0c             	sub    $0xc,%esp
80104a21:	68 60 df 18 80       	push   $0x8018df60
80104a26:	e8 95 07 00 00       	call   801051c0 <release>
            return -1;
80104a2b:	83 c4 10             	add    $0x10,%esp
80104a2e:	eb e2                	jmp    80104a12 <wait+0xd2>

80104a30 <waitx>:
int waitx(int *wtime, int *rtime) {
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	53                   	push   %ebx
    pushcli();
80104a35:	e8 f6 05 00 00       	call   80105030 <pushcli>
    c = mycpu();
80104a3a:	e8 41 ef ff ff       	call   80103980 <mycpu>
    p = c->proc;
80104a3f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104a45:	e8 26 06 00 00       	call   80105070 <popcli>
    acquire(&ptable.lock);
80104a4a:	83 ec 0c             	sub    $0xc,%esp
80104a4d:	68 60 df 18 80       	push   $0x8018df60
80104a52:	e8 a9 06 00 00       	call   80105100 <acquire>
80104a57:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
80104a5a:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a5c:	bb 94 df 18 80       	mov    $0x8018df94,%ebx
80104a61:	eb 13                	jmp    80104a76 <waitx+0x46>
80104a63:	90                   	nop
80104a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a68:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
80104a6e:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
80104a74:	73 1e                	jae    80104a94 <waitx+0x64>
            if (p->parent != curproc)
80104a76:	39 73 14             	cmp    %esi,0x14(%ebx)
80104a79:	75 ed                	jne    80104a68 <waitx+0x38>
            if (p->state == ZOMBIE) {
80104a7b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104a7f:	74 3f                	je     80104ac0 <waitx+0x90>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a81:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
            havekids = 1;
80104a87:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a8c:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
80104a92:	72 e2                	jb     80104a76 <waitx+0x46>
        if (!havekids || curproc->killed) {
80104a94:	85 c0                	test   %eax,%eax
80104a96:	0f 84 9f 00 00 00    	je     80104b3b <waitx+0x10b>
80104a9c:	8b 46 24             	mov    0x24(%esi),%eax
80104a9f:	85 c0                	test   %eax,%eax
80104aa1:	0f 85 94 00 00 00    	jne    80104b3b <waitx+0x10b>
        sleep(curproc, &ptable.lock);  // DOC: wait-sleep
80104aa7:	83 ec 08             	sub    $0x8,%esp
80104aaa:	68 60 df 18 80       	push   $0x8018df60
80104aaf:	56                   	push   %esi
80104ab0:	e8 cb fd ff ff       	call   80104880 <sleep>
        havekids = 0;
80104ab5:	83 c4 10             	add    $0x10,%esp
80104ab8:	eb a0                	jmp    80104a5a <waitx+0x2a>
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                *wtime = p->etime - p->ctime - p->rtime - p->iotime;
80104ac0:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80104ac6:	2b 43 7c             	sub    0x7c(%ebx),%eax
                kfree(p->kstack);
80104ac9:	83 ec 0c             	sub    $0xc,%esp
                *wtime = p->etime - p->ctime - p->rtime - p->iotime;
80104acc:	2b 83 80 00 00 00    	sub    0x80(%ebx),%eax
80104ad2:	8b 55 08             	mov    0x8(%ebp),%edx
80104ad5:	2b 83 88 00 00 00    	sub    0x88(%ebx),%eax
80104adb:	89 02                	mov    %eax,(%edx)
                *rtime = p->rtime;
80104add:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ae0:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
80104ae6:	89 10                	mov    %edx,(%eax)
                kfree(p->kstack);
80104ae8:	ff 73 08             	pushl  0x8(%ebx)
                pid = p->pid;
80104aeb:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
80104aee:	e8 1d d8 ff ff       	call   80102310 <kfree>
                freevm(p->pgdir);
80104af3:	5a                   	pop    %edx
80104af4:	ff 73 04             	pushl  0x4(%ebx)
                p->kstack = 0;
80104af7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80104afe:	e8 4d 37 00 00       	call   80108250 <freevm>
                release(&ptable.lock);
80104b03:	c7 04 24 60 df 18 80 	movl   $0x8018df60,(%esp)
                p->pid = 0;
80104b0a:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104b11:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80104b18:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
80104b1c:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80104b23:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
80104b2a:	e8 91 06 00 00       	call   801051c0 <release>
                return pid;
80104b2f:	83 c4 10             	add    $0x10,%esp
}
80104b32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b35:	89 f0                	mov    %esi,%eax
80104b37:	5b                   	pop    %ebx
80104b38:	5e                   	pop    %esi
80104b39:	5d                   	pop    %ebp
80104b3a:	c3                   	ret    
            release(&ptable.lock);
80104b3b:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80104b3e:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
80104b43:	68 60 df 18 80       	push   $0x8018df60
80104b48:	e8 73 06 00 00       	call   801051c0 <release>
            return -1;
80104b4d:	83 c4 10             	add    $0x10,%esp
80104b50:	eb e0                	jmp    80104b32 <waitx+0x102>
80104b52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <wakeup>:
            // }
        }
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan) {
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	53                   	push   %ebx
80104b64:	83 ec 10             	sub    $0x10,%esp
80104b67:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
80104b6a:	68 60 df 18 80       	push   $0x8018df60
80104b6f:	e8 8c 05 00 00       	call   80105100 <acquire>
80104b74:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b77:	b8 94 df 18 80       	mov    $0x8018df94,%eax
80104b7c:	eb 0e                	jmp    80104b8c <wakeup+0x2c>
80104b7e:	66 90                	xchg   %ax,%ax
80104b80:	05 d0 00 00 00       	add    $0xd0,%eax
80104b85:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104b8a:	73 1e                	jae    80104baa <wakeup+0x4a>
        if (p->state == SLEEPING && p->chan == chan) {
80104b8c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104b90:	75 ee                	jne    80104b80 <wakeup+0x20>
80104b92:	3b 58 20             	cmp    0x20(%eax),%ebx
80104b95:	75 e9                	jne    80104b80 <wakeup+0x20>
            p->state = RUNNABLE;
80104b97:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b9e:	05 d0 00 00 00       	add    $0xd0,%eax
80104ba3:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104ba8:	72 e2                	jb     80104b8c <wakeup+0x2c>
    wakeup1(chan);
    release(&ptable.lock);
80104baa:	c7 45 08 60 df 18 80 	movl   $0x8018df60,0x8(%ebp)
}
80104bb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb4:	c9                   	leave  
    release(&ptable.lock);
80104bb5:	e9 06 06 00 00       	jmp    801051c0 <release>
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bc0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid) {
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
80104bc4:	83 ec 10             	sub    $0x10,%esp
80104bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
80104bca:	68 60 df 18 80       	push   $0x8018df60
80104bcf:	e8 2c 05 00 00       	call   80105100 <acquire>
80104bd4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104bd7:	b8 94 df 18 80       	mov    $0x8018df94,%eax
80104bdc:	eb 0e                	jmp    80104bec <kill+0x2c>
80104bde:	66 90                	xchg   %ax,%ax
80104be0:	05 d0 00 00 00       	add    $0xd0,%eax
80104be5:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104bea:	73 34                	jae    80104c20 <kill+0x60>
        if (p->pid == pid) {
80104bec:	39 58 10             	cmp    %ebx,0x10(%eax)
80104bef:	75 ef                	jne    80104be0 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
80104bf1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
80104bf5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING)
80104bfc:	75 07                	jne    80104c05 <kill+0x45>
                p->state = RUNNABLE;
80104bfe:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
80104c05:	83 ec 0c             	sub    $0xc,%esp
80104c08:	68 60 df 18 80       	push   $0x8018df60
80104c0d:	e8 ae 05 00 00       	call   801051c0 <release>
            return 0;
80104c12:	83 c4 10             	add    $0x10,%esp
80104c15:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
80104c17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c1a:	c9                   	leave  
80104c1b:	c3                   	ret    
80104c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80104c20:	83 ec 0c             	sub    $0xc,%esp
80104c23:	68 60 df 18 80       	push   $0x8018df60
80104c28:	e8 93 05 00 00       	call   801051c0 <release>
    return -1;
80104c2d:	83 c4 10             	add    $0x10,%esp
80104c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c38:	c9                   	leave  
80104c39:	c3                   	ret    
80104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c40 <procdump>:

// PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	57                   	push   %edi
80104c44:	56                   	push   %esi
80104c45:	53                   	push   %ebx
80104c46:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104c49:	bb 94 df 18 80       	mov    $0x8018df94,%ebx
void procdump(void) {
80104c4e:	83 ec 3c             	sub    $0x3c,%esp
80104c51:	eb 2d                	jmp    80104c80 <procdump+0x40>
80104c53:	90                   	nop
80104c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == SLEEPING) {
            getcallerpcs((uint *)p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf(" - queue %d\n", p->qno);
80104c58:	83 ec 08             	sub    $0x8,%esp
80104c5b:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
80104c61:	68 14 8c 10 80       	push   $0x80108c14
80104c66:	e8 f5 b9 ff ff       	call   80100660 <cprintf>
80104c6b:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104c6e:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
80104c74:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
80104c7a:	0f 83 90 00 00 00    	jae    80104d10 <procdump+0xd0>
        if (p->state == UNUSED)
80104c80:	8b 43 0c             	mov    0xc(%ebx),%eax
80104c83:	85 c0                	test   %eax,%eax
80104c85:	74 e7                	je     80104c6e <procdump+0x2e>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104c87:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
80104c8a:	ba 07 8c 10 80       	mov    $0x80108c07,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104c8f:	77 11                	ja     80104ca2 <procdump+0x62>
80104c91:	8b 14 85 a8 8d 10 80 	mov    -0x7fef7258(,%eax,4),%edx
            state = "???";
80104c98:	b8 07 8c 10 80       	mov    $0x80108c07,%eax
80104c9d:	85 d2                	test   %edx,%edx
80104c9f:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
80104ca2:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104ca5:	50                   	push   %eax
80104ca6:	52                   	push   %edx
80104ca7:	ff 73 10             	pushl  0x10(%ebx)
80104caa:	68 0b 8c 10 80       	push   $0x80108c0b
80104caf:	e8 ac b9 ff ff       	call   80100660 <cprintf>
        if (p->state == SLEEPING) {
80104cb4:	83 c4 10             	add    $0x10,%esp
80104cb7:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104cbb:	75 9b                	jne    80104c58 <procdump+0x18>
            getcallerpcs((uint *)p->context->ebp + 2, pc);
80104cbd:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104cc0:	83 ec 08             	sub    $0x8,%esp
80104cc3:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104cc6:	50                   	push   %eax
80104cc7:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104cca:	8b 40 0c             	mov    0xc(%eax),%eax
80104ccd:	83 c0 08             	add    $0x8,%eax
80104cd0:	50                   	push   %eax
80104cd1:	e8 0a 03 00 00       	call   80104fe0 <getcallerpcs>
80104cd6:	83 c4 10             	add    $0x10,%esp
80104cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104ce0:	8b 17                	mov    (%edi),%edx
80104ce2:	85 d2                	test   %edx,%edx
80104ce4:	0f 84 6e ff ff ff    	je     80104c58 <procdump+0x18>
                cprintf(" %p", pc[i]);
80104cea:	83 ec 08             	sub    $0x8,%esp
80104ced:	83 c7 04             	add    $0x4,%edi
80104cf0:	52                   	push   %edx
80104cf1:	68 c1 85 10 80       	push   $0x801085c1
80104cf6:	e8 65 b9 ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104cfb:	83 c4 10             	add    $0x10,%esp
80104cfe:	39 f7                	cmp    %esi,%edi
80104d00:	75 de                	jne    80104ce0 <procdump+0xa0>
80104d02:	e9 51 ff ff ff       	jmp    80104c58 <procdump+0x18>
80104d07:	89 f6                	mov    %esi,%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d10:	31 f6                	xor    %esi,%esi
    }

    for (int i = 0; i < 5; i++) {
        cprintf("\nQ %d : %d", i, cnt[i]);
80104d12:	83 ec 04             	sub    $0x4,%esp
80104d15:	ff 34 b5 1c c6 10 80 	pushl  -0x7fef39e4(,%esi,4)
80104d1c:	56                   	push   %esi
80104d1d:	68 21 8c 10 80       	push   $0x80108c21
80104d22:	e8 39 b9 ff ff       	call   80100660 <cprintf>
        if (i == 0) {
80104d27:	83 c4 10             	add    $0x10,%esp
80104d2a:	85 f6                	test   %esi,%esi
80104d2c:	74 77                	je     80104da5 <procdump+0x165>
            for (int j = 0; j < cnt[i]; j++) {
                cprintf("\n %d", q0[j]->pid);
            }
        } else if (i == 1) {
80104d2e:	83 fe 01             	cmp    $0x1,%esi
80104d31:	0f 84 d6 00 00 00    	je     80104e0d <procdump+0x1cd>
            for (int j = 0; j < cnt[i]; j++) {
                cprintf("\n %d", q1[j]->pid);
            }
        } else if (i == 2) {
80104d37:	83 fe 02             	cmp    $0x2,%esi
80104d3a:	0f 84 07 01 00 00    	je     80104e47 <procdump+0x207>
            for (int j = 0; j < cnt[i]; j++) {
                cprintf("\n %d", q2[j]->pid);
            }
        } else if (i == 3) {
80104d40:	83 fe 03             	cmp    $0x3,%esi
80104d43:	0f 84 8f 00 00 00    	je     80104dd8 <procdump+0x198>
            for (int j = 0; j < cnt[i]; j++) {
                cprintf("\n %d", q3[j]->pid);
            }
        } else if (i == 4) {
            for (int j = 0; j < cnt[i]; j++) {
80104d49:	8b 15 2c c6 10 80    	mov    0x8010c62c,%edx
80104d4f:	31 db                	xor    %ebx,%ebx
80104d51:	85 d2                	test   %edx,%edx
80104d53:	7e 28                	jle    80104d7d <procdump+0x13d>
80104d55:	8d 76 00             	lea    0x0(%esi),%esi
                cprintf("\n %d", q4[j]->pid);
80104d58:	8b 04 9d a0 13 19 80 	mov    -0x7fe6ec60(,%ebx,4),%eax
80104d5f:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
80104d62:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q4[j]->pid);
80104d65:	ff 70 10             	pushl  0x10(%eax)
80104d68:	68 2c 8c 10 80       	push   $0x80108c2c
80104d6d:	e8 ee b8 ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
80104d72:	83 c4 10             	add    $0x10,%esp
80104d75:	39 1d 2c c6 10 80    	cmp    %ebx,0x8010c62c
80104d7b:	7f db                	jg     80104d58 <procdump+0x118>
    for (int i = 0; i < 5; i++) {
80104d7d:	83 fe 04             	cmp    $0x4,%esi
80104d80:	74 0e                	je     80104d90 <procdump+0x150>
80104d82:	83 c6 01             	add    $0x1,%esi
80104d85:	eb 8b                	jmp    80104d12 <procdump+0xd2>
80104d87:	89 f6                	mov    %esi,%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            }
        }
    }
    cprintf("\n");
80104d90:	83 ec 0c             	sub    $0xc,%esp
80104d93:	68 0b 91 10 80       	push   $0x8010910b
80104d98:	e8 c3 b8 ff ff       	call   80100660 <cprintf>
}
80104d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104da0:	5b                   	pop    %ebx
80104da1:	5e                   	pop    %esi
80104da2:	5f                   	pop    %edi
80104da3:	5d                   	pop    %ebp
80104da4:	c3                   	ret    
            for (int j = 0; j < cnt[i]; j++) {
80104da5:	8b 3d 1c c6 10 80    	mov    0x8010c61c,%edi
80104dab:	85 ff                	test   %edi,%edi
80104dad:	7e d3                	jle    80104d82 <procdump+0x142>
80104daf:	31 db                	xor    %ebx,%ebx
                cprintf("\n %d", q0[j]->pid);
80104db1:	8b 04 9d c0 cf 18 80 	mov    -0x7fe73040(,%ebx,4),%eax
80104db8:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
80104dbb:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q0[j]->pid);
80104dbe:	ff 70 10             	pushl  0x10(%eax)
80104dc1:	68 2c 8c 10 80       	push   $0x80108c2c
80104dc6:	e8 95 b8 ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
80104dcb:	83 c4 10             	add    $0x10,%esp
80104dce:	39 1d 1c c6 10 80    	cmp    %ebx,0x8010c61c
80104dd4:	7f db                	jg     80104db1 <procdump+0x171>
80104dd6:	eb aa                	jmp    80104d82 <procdump+0x142>
            for (int j = 0; j < cnt[i]; j++) {
80104dd8:	a1 28 c6 10 80       	mov    0x8010c628,%eax
80104ddd:	85 c0                	test   %eax,%eax
80104ddf:	7e a1                	jle    80104d82 <procdump+0x142>
80104de1:	31 db                	xor    %ebx,%ebx
                cprintf("\n %d", q3[j]->pid);
80104de3:	8b 04 9d 80 b0 18 80 	mov    -0x7fe74f80(,%ebx,4),%eax
80104dea:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
80104ded:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q3[j]->pid);
80104df0:	ff 70 10             	pushl  0x10(%eax)
80104df3:	68 2c 8c 10 80       	push   $0x80108c2c
80104df8:	e8 63 b8 ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
80104dfd:	83 c4 10             	add    $0x10,%esp
80104e00:	39 1d 28 c6 10 80    	cmp    %ebx,0x8010c628
80104e06:	7f db                	jg     80104de3 <procdump+0x1a3>
80104e08:	e9 75 ff ff ff       	jmp    80104d82 <procdump+0x142>
            for (int j = 0; j < cnt[i]; j++) {
80104e0d:	8b 1d 20 c6 10 80    	mov    0x8010c620,%ebx
80104e13:	85 db                	test   %ebx,%ebx
80104e15:	0f 8e 67 ff ff ff    	jle    80104d82 <procdump+0x142>
80104e1b:	31 db                	xor    %ebx,%ebx
                cprintf("\n %d", q1[j]->pid);
80104e1d:	8b 04 9d 20 c0 18 80 	mov    -0x7fe73fe0(,%ebx,4),%eax
80104e24:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
80104e27:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q1[j]->pid);
80104e2a:	ff 70 10             	pushl  0x10(%eax)
80104e2d:	68 2c 8c 10 80       	push   $0x80108c2c
80104e32:	e8 29 b8 ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
80104e37:	83 c4 10             	add    $0x10,%esp
80104e3a:	39 1d 20 c6 10 80    	cmp    %ebx,0x8010c620
80104e40:	7f db                	jg     80104e1d <procdump+0x1dd>
80104e42:	e9 3b ff ff ff       	jmp    80104d82 <procdump+0x142>
            for (int j = 0; j < cnt[i]; j++) {
80104e47:	8b 0d 24 c6 10 80    	mov    0x8010c624,%ecx
80104e4d:	85 c9                	test   %ecx,%ecx
80104e4f:	0f 8e 2d ff ff ff    	jle    80104d82 <procdump+0x142>
80104e55:	31 db                	xor    %ebx,%ebx
                cprintf("\n %d", q2[j]->pid);
80104e57:	8b 04 9d c0 a0 18 80 	mov    -0x7fe75f40(,%ebx,4),%eax
80104e5e:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
80104e61:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q2[j]->pid);
80104e64:	ff 70 10             	pushl  0x10(%eax)
80104e67:	68 2c 8c 10 80       	push   $0x80108c2c
80104e6c:	e8 ef b7 ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
80104e71:	83 c4 10             	add    $0x10,%esp
80104e74:	39 1d 24 c6 10 80    	cmp    %ebx,0x8010c624
80104e7a:	7f db                	jg     80104e57 <procdump+0x217>
80104e7c:	e9 01 ff ff ff       	jmp    80104d82 <procdump+0x142>
80104e81:	66 90                	xchg   %ax,%ax
80104e83:	66 90                	xchg   %ax,%ax
80104e85:	66 90                	xchg   %ax,%ax
80104e87:	66 90                	xchg   %ax,%ax
80104e89:	66 90                	xchg   %ax,%ax
80104e8b:	66 90                	xchg   %ax,%ax
80104e8d:	66 90                	xchg   %ax,%ax
80104e8f:	90                   	nop

80104e90 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	53                   	push   %ebx
80104e94:	83 ec 0c             	sub    $0xc,%esp
80104e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104e9a:	68 c0 8d 10 80       	push   $0x80108dc0
80104e9f:	8d 43 04             	lea    0x4(%ebx),%eax
80104ea2:	50                   	push   %eax
80104ea3:	e8 18 01 00 00       	call   80104fc0 <initlock>
  lk->name = name;
80104ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104eab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104eb1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104eb4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104ebb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104ebe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ec1:	c9                   	leave  
80104ec2:	c3                   	ret    
80104ec3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ed0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	56                   	push   %esi
80104ed4:	53                   	push   %ebx
80104ed5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ed8:	83 ec 0c             	sub    $0xc,%esp
80104edb:	8d 73 04             	lea    0x4(%ebx),%esi
80104ede:	56                   	push   %esi
80104edf:	e8 1c 02 00 00       	call   80105100 <acquire>
  while (lk->locked) {
80104ee4:	8b 13                	mov    (%ebx),%edx
80104ee6:	83 c4 10             	add    $0x10,%esp
80104ee9:	85 d2                	test   %edx,%edx
80104eeb:	74 16                	je     80104f03 <acquiresleep+0x33>
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104ef0:	83 ec 08             	sub    $0x8,%esp
80104ef3:	56                   	push   %esi
80104ef4:	53                   	push   %ebx
80104ef5:	e8 86 f9 ff ff       	call   80104880 <sleep>
  while (lk->locked) {
80104efa:	8b 03                	mov    (%ebx),%eax
80104efc:	83 c4 10             	add    $0x10,%esp
80104eff:	85 c0                	test   %eax,%eax
80104f01:	75 ed                	jne    80104ef0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104f03:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104f09:	e8 12 eb ff ff       	call   80103a20 <myproc>
80104f0e:	8b 40 10             	mov    0x10(%eax),%eax
80104f11:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104f14:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104f17:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f1a:	5b                   	pop    %ebx
80104f1b:	5e                   	pop    %esi
80104f1c:	5d                   	pop    %ebp
  release(&lk->lk);
80104f1d:	e9 9e 02 00 00       	jmp    801051c0 <release>
80104f22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f30 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	56                   	push   %esi
80104f34:	53                   	push   %ebx
80104f35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104f38:	83 ec 0c             	sub    $0xc,%esp
80104f3b:	8d 73 04             	lea    0x4(%ebx),%esi
80104f3e:	56                   	push   %esi
80104f3f:	e8 bc 01 00 00       	call   80105100 <acquire>
  lk->locked = 0;
80104f44:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104f4a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104f51:	89 1c 24             	mov    %ebx,(%esp)
80104f54:	e8 07 fc ff ff       	call   80104b60 <wakeup>
  release(&lk->lk);
80104f59:	89 75 08             	mov    %esi,0x8(%ebp)
80104f5c:	83 c4 10             	add    $0x10,%esp
}
80104f5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f62:	5b                   	pop    %ebx
80104f63:	5e                   	pop    %esi
80104f64:	5d                   	pop    %ebp
  release(&lk->lk);
80104f65:	e9 56 02 00 00       	jmp    801051c0 <release>
80104f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f70 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	57                   	push   %edi
80104f74:	56                   	push   %esi
80104f75:	53                   	push   %ebx
80104f76:	31 ff                	xor    %edi,%edi
80104f78:	83 ec 18             	sub    $0x18,%esp
80104f7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104f7e:	8d 73 04             	lea    0x4(%ebx),%esi
80104f81:	56                   	push   %esi
80104f82:	e8 79 01 00 00       	call   80105100 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104f87:	8b 03                	mov    (%ebx),%eax
80104f89:	83 c4 10             	add    $0x10,%esp
80104f8c:	85 c0                	test   %eax,%eax
80104f8e:	74 13                	je     80104fa3 <holdingsleep+0x33>
80104f90:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104f93:	e8 88 ea ff ff       	call   80103a20 <myproc>
80104f98:	39 58 10             	cmp    %ebx,0x10(%eax)
80104f9b:	0f 94 c0             	sete   %al
80104f9e:	0f b6 c0             	movzbl %al,%eax
80104fa1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104fa3:	83 ec 0c             	sub    $0xc,%esp
80104fa6:	56                   	push   %esi
80104fa7:	e8 14 02 00 00       	call   801051c0 <release>
  return r;
}
80104fac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104faf:	89 f8                	mov    %edi,%eax
80104fb1:	5b                   	pop    %ebx
80104fb2:	5e                   	pop    %esi
80104fb3:	5f                   	pop    %edi
80104fb4:	5d                   	pop    %ebp
80104fb5:	c3                   	ret    
80104fb6:	66 90                	xchg   %ax,%ax
80104fb8:	66 90                	xchg   %ax,%ax
80104fba:	66 90                	xchg   %ax,%ax
80104fbc:	66 90                	xchg   %ax,%ax
80104fbe:	66 90                	xchg   %ax,%ax

80104fc0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104fc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104fc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104fcf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104fd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104fd9:	5d                   	pop    %ebp
80104fda:	c3                   	ret    
80104fdb:	90                   	nop
80104fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fe0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104fe0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104fe1:	31 d2                	xor    %edx,%edx
{
80104fe3:	89 e5                	mov    %esp,%ebp
80104fe5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104fe6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104fe9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104fec:	83 e8 08             	sub    $0x8,%eax
80104fef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ff0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ff6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104ffc:	77 1a                	ja     80105018 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104ffe:	8b 58 04             	mov    0x4(%eax),%ebx
80105001:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105004:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105007:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105009:	83 fa 0a             	cmp    $0xa,%edx
8010500c:	75 e2                	jne    80104ff0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010500e:	5b                   	pop    %ebx
8010500f:	5d                   	pop    %ebp
80105010:	c3                   	ret    
80105011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105018:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010501b:	83 c1 28             	add    $0x28,%ecx
8010501e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105020:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105026:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105029:	39 c1                	cmp    %eax,%ecx
8010502b:	75 f3                	jne    80105020 <getcallerpcs+0x40>
}
8010502d:	5b                   	pop    %ebx
8010502e:	5d                   	pop    %ebp
8010502f:	c3                   	ret    

80105030 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	53                   	push   %ebx
80105034:	83 ec 04             	sub    $0x4,%esp
80105037:	9c                   	pushf  
80105038:	5b                   	pop    %ebx
  asm volatile("cli");
80105039:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010503a:	e8 41 e9 ff ff       	call   80103980 <mycpu>
8010503f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105045:	85 c0                	test   %eax,%eax
80105047:	75 11                	jne    8010505a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105049:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010504f:	e8 2c e9 ff ff       	call   80103980 <mycpu>
80105054:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010505a:	e8 21 e9 ff ff       	call   80103980 <mycpu>
8010505f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105066:	83 c4 04             	add    $0x4,%esp
80105069:	5b                   	pop    %ebx
8010506a:	5d                   	pop    %ebp
8010506b:	c3                   	ret    
8010506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105070 <popcli>:

void
popcli(void)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105076:	9c                   	pushf  
80105077:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105078:	f6 c4 02             	test   $0x2,%ah
8010507b:	75 35                	jne    801050b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010507d:	e8 fe e8 ff ff       	call   80103980 <mycpu>
80105082:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105089:	78 34                	js     801050bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010508b:	e8 f0 e8 ff ff       	call   80103980 <mycpu>
80105090:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105096:	85 d2                	test   %edx,%edx
80105098:	74 06                	je     801050a0 <popcli+0x30>
    sti();
}
8010509a:	c9                   	leave  
8010509b:	c3                   	ret    
8010509c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050a0:	e8 db e8 ff ff       	call   80103980 <mycpu>
801050a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801050ab:	85 c0                	test   %eax,%eax
801050ad:	74 eb                	je     8010509a <popcli+0x2a>
  asm volatile("sti");
801050af:	fb                   	sti    
}
801050b0:	c9                   	leave  
801050b1:	c3                   	ret    
    panic("popcli - interruptible");
801050b2:	83 ec 0c             	sub    $0xc,%esp
801050b5:	68 cb 8d 10 80       	push   $0x80108dcb
801050ba:	e8 d1 b2 ff ff       	call   80100390 <panic>
    panic("popcli");
801050bf:	83 ec 0c             	sub    $0xc,%esp
801050c2:	68 e2 8d 10 80       	push   $0x80108de2
801050c7:	e8 c4 b2 ff ff       	call   80100390 <panic>
801050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050d0 <holding>:
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	56                   	push   %esi
801050d4:	53                   	push   %ebx
801050d5:	8b 75 08             	mov    0x8(%ebp),%esi
801050d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801050da:	e8 51 ff ff ff       	call   80105030 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801050df:	8b 06                	mov    (%esi),%eax
801050e1:	85 c0                	test   %eax,%eax
801050e3:	74 10                	je     801050f5 <holding+0x25>
801050e5:	8b 5e 08             	mov    0x8(%esi),%ebx
801050e8:	e8 93 e8 ff ff       	call   80103980 <mycpu>
801050ed:	39 c3                	cmp    %eax,%ebx
801050ef:	0f 94 c3             	sete   %bl
801050f2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801050f5:	e8 76 ff ff ff       	call   80105070 <popcli>
}
801050fa:	89 d8                	mov    %ebx,%eax
801050fc:	5b                   	pop    %ebx
801050fd:	5e                   	pop    %esi
801050fe:	5d                   	pop    %ebp
801050ff:	c3                   	ret    

80105100 <acquire>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105105:	e8 26 ff ff ff       	call   80105030 <pushcli>
  if(holding(lk))
8010510a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010510d:	83 ec 0c             	sub    $0xc,%esp
80105110:	53                   	push   %ebx
80105111:	e8 ba ff ff ff       	call   801050d0 <holding>
80105116:	83 c4 10             	add    $0x10,%esp
80105119:	85 c0                	test   %eax,%eax
8010511b:	0f 85 83 00 00 00    	jne    801051a4 <acquire+0xa4>
80105121:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105123:	ba 01 00 00 00       	mov    $0x1,%edx
80105128:	eb 09                	jmp    80105133 <acquire+0x33>
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105130:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105133:	89 d0                	mov    %edx,%eax
80105135:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105138:	85 c0                	test   %eax,%eax
8010513a:	75 f4                	jne    80105130 <acquire+0x30>
  __sync_synchronize();
8010513c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105141:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105144:	e8 37 e8 ff ff       	call   80103980 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105149:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010514c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010514f:	89 e8                	mov    %ebp,%eax
80105151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105158:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010515e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105164:	77 1a                	ja     80105180 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105166:	8b 48 04             	mov    0x4(%eax),%ecx
80105169:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010516c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010516f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105171:	83 fe 0a             	cmp    $0xa,%esi
80105174:	75 e2                	jne    80105158 <acquire+0x58>
}
80105176:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105179:	5b                   	pop    %ebx
8010517a:	5e                   	pop    %esi
8010517b:	5d                   	pop    %ebp
8010517c:	c3                   	ret    
8010517d:	8d 76 00             	lea    0x0(%esi),%esi
80105180:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80105183:	83 c2 28             	add    $0x28,%edx
80105186:	8d 76 00             	lea    0x0(%esi),%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105190:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105196:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105199:	39 d0                	cmp    %edx,%eax
8010519b:	75 f3                	jne    80105190 <acquire+0x90>
}
8010519d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051a0:	5b                   	pop    %ebx
801051a1:	5e                   	pop    %esi
801051a2:	5d                   	pop    %ebp
801051a3:	c3                   	ret    
    panic("acquire");
801051a4:	83 ec 0c             	sub    $0xc,%esp
801051a7:	68 e9 8d 10 80       	push   $0x80108de9
801051ac:	e8 df b1 ff ff       	call   80100390 <panic>
801051b1:	eb 0d                	jmp    801051c0 <release>
801051b3:	90                   	nop
801051b4:	90                   	nop
801051b5:	90                   	nop
801051b6:	90                   	nop
801051b7:	90                   	nop
801051b8:	90                   	nop
801051b9:	90                   	nop
801051ba:	90                   	nop
801051bb:	90                   	nop
801051bc:	90                   	nop
801051bd:	90                   	nop
801051be:	90                   	nop
801051bf:	90                   	nop

801051c0 <release>:
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	53                   	push   %ebx
801051c4:	83 ec 10             	sub    $0x10,%esp
801051c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801051ca:	53                   	push   %ebx
801051cb:	e8 00 ff ff ff       	call   801050d0 <holding>
801051d0:	83 c4 10             	add    $0x10,%esp
801051d3:	85 c0                	test   %eax,%eax
801051d5:	74 22                	je     801051f9 <release+0x39>
  lk->pcs[0] = 0;
801051d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801051de:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801051e5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801051ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801051f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051f3:	c9                   	leave  
  popcli();
801051f4:	e9 77 fe ff ff       	jmp    80105070 <popcli>
    panic("release");
801051f9:	83 ec 0c             	sub    $0xc,%esp
801051fc:	68 f1 8d 10 80       	push   $0x80108df1
80105201:	e8 8a b1 ff ff       	call   80100390 <panic>
80105206:	66 90                	xchg   %ax,%ax
80105208:	66 90                	xchg   %ax,%ax
8010520a:	66 90                	xchg   %ax,%ax
8010520c:	66 90                	xchg   %ax,%ax
8010520e:	66 90                	xchg   %ax,%ax

80105210 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	57                   	push   %edi
80105214:	53                   	push   %ebx
80105215:	8b 55 08             	mov    0x8(%ebp),%edx
80105218:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010521b:	f6 c2 03             	test   $0x3,%dl
8010521e:	75 05                	jne    80105225 <memset+0x15>
80105220:	f6 c1 03             	test   $0x3,%cl
80105223:	74 13                	je     80105238 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105225:	89 d7                	mov    %edx,%edi
80105227:	8b 45 0c             	mov    0xc(%ebp),%eax
8010522a:	fc                   	cld    
8010522b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010522d:	5b                   	pop    %ebx
8010522e:	89 d0                	mov    %edx,%eax
80105230:	5f                   	pop    %edi
80105231:	5d                   	pop    %ebp
80105232:	c3                   	ret    
80105233:	90                   	nop
80105234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105238:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010523c:	c1 e9 02             	shr    $0x2,%ecx
8010523f:	89 f8                	mov    %edi,%eax
80105241:	89 fb                	mov    %edi,%ebx
80105243:	c1 e0 18             	shl    $0x18,%eax
80105246:	c1 e3 10             	shl    $0x10,%ebx
80105249:	09 d8                	or     %ebx,%eax
8010524b:	09 f8                	or     %edi,%eax
8010524d:	c1 e7 08             	shl    $0x8,%edi
80105250:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105252:	89 d7                	mov    %edx,%edi
80105254:	fc                   	cld    
80105255:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105257:	5b                   	pop    %ebx
80105258:	89 d0                	mov    %edx,%eax
8010525a:	5f                   	pop    %edi
8010525b:	5d                   	pop    %ebp
8010525c:	c3                   	ret    
8010525d:	8d 76 00             	lea    0x0(%esi),%esi

80105260 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	56                   	push   %esi
80105265:	53                   	push   %ebx
80105266:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105269:	8b 75 08             	mov    0x8(%ebp),%esi
8010526c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010526f:	85 db                	test   %ebx,%ebx
80105271:	74 29                	je     8010529c <memcmp+0x3c>
    if(*s1 != *s2)
80105273:	0f b6 16             	movzbl (%esi),%edx
80105276:	0f b6 0f             	movzbl (%edi),%ecx
80105279:	38 d1                	cmp    %dl,%cl
8010527b:	75 2b                	jne    801052a8 <memcmp+0x48>
8010527d:	b8 01 00 00 00       	mov    $0x1,%eax
80105282:	eb 14                	jmp    80105298 <memcmp+0x38>
80105284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105288:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010528c:	83 c0 01             	add    $0x1,%eax
8010528f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105294:	38 ca                	cmp    %cl,%dl
80105296:	75 10                	jne    801052a8 <memcmp+0x48>
  while(n-- > 0){
80105298:	39 d8                	cmp    %ebx,%eax
8010529a:	75 ec                	jne    80105288 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010529c:	5b                   	pop    %ebx
  return 0;
8010529d:	31 c0                	xor    %eax,%eax
}
8010529f:	5e                   	pop    %esi
801052a0:	5f                   	pop    %edi
801052a1:	5d                   	pop    %ebp
801052a2:	c3                   	ret    
801052a3:	90                   	nop
801052a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801052a8:	0f b6 c2             	movzbl %dl,%eax
}
801052ab:	5b                   	pop    %ebx
      return *s1 - *s2;
801052ac:	29 c8                	sub    %ecx,%eax
}
801052ae:	5e                   	pop    %esi
801052af:	5f                   	pop    %edi
801052b0:	5d                   	pop    %ebp
801052b1:	c3                   	ret    
801052b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	56                   	push   %esi
801052c4:	53                   	push   %ebx
801052c5:	8b 45 08             	mov    0x8(%ebp),%eax
801052c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801052cb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801052ce:	39 c3                	cmp    %eax,%ebx
801052d0:	73 26                	jae    801052f8 <memmove+0x38>
801052d2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801052d5:	39 c8                	cmp    %ecx,%eax
801052d7:	73 1f                	jae    801052f8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801052d9:	85 f6                	test   %esi,%esi
801052db:	8d 56 ff             	lea    -0x1(%esi),%edx
801052de:	74 0f                	je     801052ef <memmove+0x2f>
      *--d = *--s;
801052e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801052e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801052e7:	83 ea 01             	sub    $0x1,%edx
801052ea:	83 fa ff             	cmp    $0xffffffff,%edx
801052ed:	75 f1                	jne    801052e0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801052ef:	5b                   	pop    %ebx
801052f0:	5e                   	pop    %esi
801052f1:	5d                   	pop    %ebp
801052f2:	c3                   	ret    
801052f3:	90                   	nop
801052f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801052f8:	31 d2                	xor    %edx,%edx
801052fa:	85 f6                	test   %esi,%esi
801052fc:	74 f1                	je     801052ef <memmove+0x2f>
801052fe:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105300:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105304:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105307:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010530a:	39 d6                	cmp    %edx,%esi
8010530c:	75 f2                	jne    80105300 <memmove+0x40>
}
8010530e:	5b                   	pop    %ebx
8010530f:	5e                   	pop    %esi
80105310:	5d                   	pop    %ebp
80105311:	c3                   	ret    
80105312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105320 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105323:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105324:	eb 9a                	jmp    801052c0 <memmove>
80105326:	8d 76 00             	lea    0x0(%esi),%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	57                   	push   %edi
80105334:	56                   	push   %esi
80105335:	8b 7d 10             	mov    0x10(%ebp),%edi
80105338:	53                   	push   %ebx
80105339:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010533c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010533f:	85 ff                	test   %edi,%edi
80105341:	74 2f                	je     80105372 <strncmp+0x42>
80105343:	0f b6 01             	movzbl (%ecx),%eax
80105346:	0f b6 1e             	movzbl (%esi),%ebx
80105349:	84 c0                	test   %al,%al
8010534b:	74 37                	je     80105384 <strncmp+0x54>
8010534d:	38 c3                	cmp    %al,%bl
8010534f:	75 33                	jne    80105384 <strncmp+0x54>
80105351:	01 f7                	add    %esi,%edi
80105353:	eb 13                	jmp    80105368 <strncmp+0x38>
80105355:	8d 76 00             	lea    0x0(%esi),%esi
80105358:	0f b6 01             	movzbl (%ecx),%eax
8010535b:	84 c0                	test   %al,%al
8010535d:	74 21                	je     80105380 <strncmp+0x50>
8010535f:	0f b6 1a             	movzbl (%edx),%ebx
80105362:	89 d6                	mov    %edx,%esi
80105364:	38 d8                	cmp    %bl,%al
80105366:	75 1c                	jne    80105384 <strncmp+0x54>
    n--, p++, q++;
80105368:	8d 56 01             	lea    0x1(%esi),%edx
8010536b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010536e:	39 fa                	cmp    %edi,%edx
80105370:	75 e6                	jne    80105358 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105372:	5b                   	pop    %ebx
    return 0;
80105373:	31 c0                	xor    %eax,%eax
}
80105375:	5e                   	pop    %esi
80105376:	5f                   	pop    %edi
80105377:	5d                   	pop    %ebp
80105378:	c3                   	ret    
80105379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105380:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105384:	29 d8                	sub    %ebx,%eax
}
80105386:	5b                   	pop    %ebx
80105387:	5e                   	pop    %esi
80105388:	5f                   	pop    %edi
80105389:	5d                   	pop    %ebp
8010538a:	c3                   	ret    
8010538b:	90                   	nop
8010538c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105390 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	56                   	push   %esi
80105394:	53                   	push   %ebx
80105395:	8b 45 08             	mov    0x8(%ebp),%eax
80105398:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010539b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010539e:	89 c2                	mov    %eax,%edx
801053a0:	eb 19                	jmp    801053bb <strncpy+0x2b>
801053a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053a8:	83 c3 01             	add    $0x1,%ebx
801053ab:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801053af:	83 c2 01             	add    $0x1,%edx
801053b2:	84 c9                	test   %cl,%cl
801053b4:	88 4a ff             	mov    %cl,-0x1(%edx)
801053b7:	74 09                	je     801053c2 <strncpy+0x32>
801053b9:	89 f1                	mov    %esi,%ecx
801053bb:	85 c9                	test   %ecx,%ecx
801053bd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801053c0:	7f e6                	jg     801053a8 <strncpy+0x18>
    ;
  while(n-- > 0)
801053c2:	31 c9                	xor    %ecx,%ecx
801053c4:	85 f6                	test   %esi,%esi
801053c6:	7e 17                	jle    801053df <strncpy+0x4f>
801053c8:	90                   	nop
801053c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801053d0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801053d4:	89 f3                	mov    %esi,%ebx
801053d6:	83 c1 01             	add    $0x1,%ecx
801053d9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801053db:	85 db                	test   %ebx,%ebx
801053dd:	7f f1                	jg     801053d0 <strncpy+0x40>
  return os;
}
801053df:	5b                   	pop    %ebx
801053e0:	5e                   	pop    %esi
801053e1:	5d                   	pop    %ebp
801053e2:	c3                   	ret    
801053e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	56                   	push   %esi
801053f4:	53                   	push   %ebx
801053f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801053f8:	8b 45 08             	mov    0x8(%ebp),%eax
801053fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801053fe:	85 c9                	test   %ecx,%ecx
80105400:	7e 26                	jle    80105428 <safestrcpy+0x38>
80105402:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105406:	89 c1                	mov    %eax,%ecx
80105408:	eb 17                	jmp    80105421 <safestrcpy+0x31>
8010540a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105410:	83 c2 01             	add    $0x1,%edx
80105413:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105417:	83 c1 01             	add    $0x1,%ecx
8010541a:	84 db                	test   %bl,%bl
8010541c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010541f:	74 04                	je     80105425 <safestrcpy+0x35>
80105421:	39 f2                	cmp    %esi,%edx
80105423:	75 eb                	jne    80105410 <safestrcpy+0x20>
    ;
  *s = 0;
80105425:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105428:	5b                   	pop    %ebx
80105429:	5e                   	pop    %esi
8010542a:	5d                   	pop    %ebp
8010542b:	c3                   	ret    
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105430 <strlen>:

int
strlen(const char *s)
{
80105430:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105431:	31 c0                	xor    %eax,%eax
{
80105433:	89 e5                	mov    %esp,%ebp
80105435:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105438:	80 3a 00             	cmpb   $0x0,(%edx)
8010543b:	74 0c                	je     80105449 <strlen+0x19>
8010543d:	8d 76 00             	lea    0x0(%esi),%esi
80105440:	83 c0 01             	add    $0x1,%eax
80105443:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105447:	75 f7                	jne    80105440 <strlen+0x10>
    ;
  return n;
}
80105449:	5d                   	pop    %ebp
8010544a:	c3                   	ret    

8010544b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010544b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010544f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105453:	55                   	push   %ebp
  pushl %ebx
80105454:	53                   	push   %ebx
  pushl %esi
80105455:	56                   	push   %esi
  pushl %edi
80105456:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105457:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105459:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010545b:	5f                   	pop    %edi
  popl %esi
8010545c:	5e                   	pop    %esi
  popl %ebx
8010545d:	5b                   	pop    %ebx
  popl %ebp
8010545e:	5d                   	pop    %ebp
  ret
8010545f:	c3                   	ret    

80105460 <fetchint>:
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip) {
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	53                   	push   %ebx
80105464:	83 ec 04             	sub    $0x4,%esp
80105467:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *curproc = myproc();
8010546a:	e8 b1 e5 ff ff       	call   80103a20 <myproc>

    if (addr >= curproc->sz || addr + 4 > curproc->sz)
8010546f:	8b 00                	mov    (%eax),%eax
80105471:	39 d8                	cmp    %ebx,%eax
80105473:	76 1b                	jbe    80105490 <fetchint+0x30>
80105475:	8d 53 04             	lea    0x4(%ebx),%edx
80105478:	39 d0                	cmp    %edx,%eax
8010547a:	72 14                	jb     80105490 <fetchint+0x30>
        return -1;
    *ip = *(int *)(addr);
8010547c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010547f:	8b 13                	mov    (%ebx),%edx
80105481:	89 10                	mov    %edx,(%eax)
    return 0;
80105483:	31 c0                	xor    %eax,%eax
}
80105485:	83 c4 04             	add    $0x4,%esp
80105488:	5b                   	pop    %ebx
80105489:	5d                   	pop    %ebp
8010548a:	c3                   	ret    
8010548b:	90                   	nop
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105495:	eb ee                	jmp    80105485 <fetchint+0x25>
80105497:	89 f6                	mov    %esi,%esi
80105499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054a0 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp) {
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	53                   	push   %ebx
801054a4:	83 ec 04             	sub    $0x4,%esp
801054a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    char *s, *ep;
    struct proc *curproc = myproc();
801054aa:	e8 71 e5 ff ff       	call   80103a20 <myproc>

    if (addr >= curproc->sz)
801054af:	39 18                	cmp    %ebx,(%eax)
801054b1:	76 29                	jbe    801054dc <fetchstr+0x3c>
        return -1;
    *pp = (char *)addr;
801054b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801054b6:	89 da                	mov    %ebx,%edx
801054b8:	89 19                	mov    %ebx,(%ecx)
    ep = (char *)curproc->sz;
801054ba:	8b 00                	mov    (%eax),%eax
    for (s = *pp; s < ep; s++) {
801054bc:	39 c3                	cmp    %eax,%ebx
801054be:	73 1c                	jae    801054dc <fetchstr+0x3c>
        if (*s == 0)
801054c0:	80 3b 00             	cmpb   $0x0,(%ebx)
801054c3:	75 10                	jne    801054d5 <fetchstr+0x35>
801054c5:	eb 39                	jmp    80105500 <fetchstr+0x60>
801054c7:	89 f6                	mov    %esi,%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801054d0:	80 3a 00             	cmpb   $0x0,(%edx)
801054d3:	74 1b                	je     801054f0 <fetchstr+0x50>
    for (s = *pp; s < ep; s++) {
801054d5:	83 c2 01             	add    $0x1,%edx
801054d8:	39 d0                	cmp    %edx,%eax
801054da:	77 f4                	ja     801054d0 <fetchstr+0x30>
        return -1;
801054dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return s - *pp;
    }
    return -1;
}
801054e1:	83 c4 04             	add    $0x4,%esp
801054e4:	5b                   	pop    %ebx
801054e5:	5d                   	pop    %ebp
801054e6:	c3                   	ret    
801054e7:	89 f6                	mov    %esi,%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801054f0:	83 c4 04             	add    $0x4,%esp
801054f3:	89 d0                	mov    %edx,%eax
801054f5:	29 d8                	sub    %ebx,%eax
801054f7:	5b                   	pop    %ebx
801054f8:	5d                   	pop    %ebp
801054f9:	c3                   	ret    
801054fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (*s == 0)
80105500:	31 c0                	xor    %eax,%eax
            return s - *pp;
80105502:	eb dd                	jmp    801054e1 <fetchstr+0x41>
80105504:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010550a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105510 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip) {
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	56                   	push   %esi
80105514:	53                   	push   %ebx
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80105515:	e8 06 e5 ff ff       	call   80103a20 <myproc>
8010551a:	8b 40 18             	mov    0x18(%eax),%eax
8010551d:	8b 55 08             	mov    0x8(%ebp),%edx
80105520:	8b 40 44             	mov    0x44(%eax),%eax
80105523:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    struct proc *curproc = myproc();
80105526:	e8 f5 e4 ff ff       	call   80103a20 <myproc>
    if (addr >= curproc->sz || addr + 4 > curproc->sz)
8010552b:	8b 00                	mov    (%eax),%eax
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
8010552d:	8d 73 04             	lea    0x4(%ebx),%esi
    if (addr >= curproc->sz || addr + 4 > curproc->sz)
80105530:	39 c6                	cmp    %eax,%esi
80105532:	73 1c                	jae    80105550 <argint+0x40>
80105534:	8d 53 08             	lea    0x8(%ebx),%edx
80105537:	39 d0                	cmp    %edx,%eax
80105539:	72 15                	jb     80105550 <argint+0x40>
    *ip = *(int *)(addr);
8010553b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010553e:	8b 53 04             	mov    0x4(%ebx),%edx
80105541:	89 10                	mov    %edx,(%eax)
    return 0;
80105543:	31 c0                	xor    %eax,%eax
}
80105545:	5b                   	pop    %ebx
80105546:	5e                   	pop    %esi
80105547:	5d                   	pop    %ebp
80105548:	c3                   	ret    
80105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80105555:	eb ee                	jmp    80105545 <argint+0x35>
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105560 <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size) {
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	56                   	push   %esi
80105564:	53                   	push   %ebx
80105565:	83 ec 10             	sub    $0x10,%esp
80105568:	8b 5d 10             	mov    0x10(%ebp),%ebx
    int i;
    struct proc *curproc = myproc();
8010556b:	e8 b0 e4 ff ff       	call   80103a20 <myproc>
80105570:	89 c6                	mov    %eax,%esi

    if (argint(n, &i) < 0)
80105572:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105575:	83 ec 08             	sub    $0x8,%esp
80105578:	50                   	push   %eax
80105579:	ff 75 08             	pushl  0x8(%ebp)
8010557c:	e8 8f ff ff ff       	call   80105510 <argint>
        return -1;
    if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz)
80105581:	83 c4 10             	add    $0x10,%esp
80105584:	85 c0                	test   %eax,%eax
80105586:	78 28                	js     801055b0 <argptr+0x50>
80105588:	85 db                	test   %ebx,%ebx
8010558a:	78 24                	js     801055b0 <argptr+0x50>
8010558c:	8b 16                	mov    (%esi),%edx
8010558e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105591:	39 c2                	cmp    %eax,%edx
80105593:	76 1b                	jbe    801055b0 <argptr+0x50>
80105595:	01 c3                	add    %eax,%ebx
80105597:	39 da                	cmp    %ebx,%edx
80105599:	72 15                	jb     801055b0 <argptr+0x50>
        return -1;
    *pp = (char *)i;
8010559b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010559e:	89 02                	mov    %eax,(%edx)
    return 0;
801055a0:	31 c0                	xor    %eax,%eax
}
801055a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055a5:	5b                   	pop    %ebx
801055a6:	5e                   	pop    %esi
801055a7:	5d                   	pop    %ebp
801055a8:	c3                   	ret    
801055a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801055b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b5:	eb eb                	jmp    801055a2 <argptr+0x42>
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <argstr>:

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp) {
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	83 ec 20             	sub    $0x20,%esp
    int addr;
    if (argint(n, &addr) < 0)
801055c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c9:	50                   	push   %eax
801055ca:	ff 75 08             	pushl  0x8(%ebp)
801055cd:	e8 3e ff ff ff       	call   80105510 <argint>
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	85 c0                	test   %eax,%eax
801055d7:	78 17                	js     801055f0 <argstr+0x30>
        return -1;
    return fetchstr(addr, pp);
801055d9:	83 ec 08             	sub    $0x8,%esp
801055dc:	ff 75 0c             	pushl  0xc(%ebp)
801055df:	ff 75 f4             	pushl  -0xc(%ebp)
801055e2:	e8 b9 fe ff ff       	call   801054a0 <fetchstr>
801055e7:	83 c4 10             	add    $0x10,%esp
}
801055ea:	c9                   	leave  
801055eb:	c3                   	ret    
801055ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801055f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055f5:	c9                   	leave  
801055f6:	c3                   	ret    
801055f7:	89 f6                	mov    %esi,%esi
801055f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105600 <syscall>:
    [SYS_waitx] sys_waitx,
    [SYS_set_priority] sys_set_priority,
    [SYS_getpinfo] sys_getpinfo,
};

void syscall(void) {
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	53                   	push   %ebx
80105604:	83 ec 04             	sub    $0x4,%esp
    int num;
    struct proc *curproc = myproc();
80105607:	e8 14 e4 ff ff       	call   80103a20 <myproc>
8010560c:	89 c3                	mov    %eax,%ebx

    num = curproc->tf->eax;
8010560e:	8b 40 18             	mov    0x18(%eax),%eax
80105611:	8b 40 1c             	mov    0x1c(%eax),%eax
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105614:	8d 50 ff             	lea    -0x1(%eax),%edx
80105617:	83 fa 17             	cmp    $0x17,%edx
8010561a:	77 1c                	ja     80105638 <syscall+0x38>
8010561c:	8b 14 85 20 8e 10 80 	mov    -0x7fef71e0(,%eax,4),%edx
80105623:	85 d2                	test   %edx,%edx
80105625:	74 11                	je     80105638 <syscall+0x38>
        curproc->tf->eax = syscalls[num]();
80105627:	ff d2                	call   *%edx
80105629:	8b 53 18             	mov    0x18(%ebx),%edx
8010562c:	89 42 1c             	mov    %eax,0x1c(%edx)
    } else {
        cprintf("%d %s: unknown sys call %d\n", curproc->pid, curproc->name,
                num);
        curproc->tf->eax = -1;
    }
}
8010562f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105632:	c9                   	leave  
80105633:	c3                   	ret    
80105634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("%d %s: unknown sys call %d\n", curproc->pid, curproc->name,
80105638:	50                   	push   %eax
80105639:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010563c:	50                   	push   %eax
8010563d:	ff 73 10             	pushl  0x10(%ebx)
80105640:	68 f9 8d 10 80       	push   $0x80108df9
80105645:	e8 16 b0 ff ff       	call   80100660 <cprintf>
        curproc->tf->eax = -1;
8010564a:	8b 43 18             	mov    0x18(%ebx),%eax
8010564d:	83 c4 10             	add    $0x10,%esp
80105650:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105657:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010565a:	c9                   	leave  
8010565b:	c3                   	ret    
8010565c:	66 90                	xchg   %ax,%ax
8010565e:	66 90                	xchg   %ax,%ax

80105660 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	57                   	push   %edi
80105664:	56                   	push   %esi
80105665:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105666:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105669:	83 ec 34             	sub    $0x34,%esp
8010566c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010566f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105672:	56                   	push   %esi
80105673:	50                   	push   %eax
{
80105674:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105677:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010567a:	e8 81 c8 ff ff       	call   80101f00 <nameiparent>
8010567f:	83 c4 10             	add    $0x10,%esp
80105682:	85 c0                	test   %eax,%eax
80105684:	0f 84 46 01 00 00    	je     801057d0 <create+0x170>
    return 0;
  ilock(dp);
8010568a:	83 ec 0c             	sub    $0xc,%esp
8010568d:	89 c3                	mov    %eax,%ebx
8010568f:	50                   	push   %eax
80105690:	e8 eb bf ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105695:	83 c4 0c             	add    $0xc,%esp
80105698:	6a 00                	push   $0x0
8010569a:	56                   	push   %esi
8010569b:	53                   	push   %ebx
8010569c:	e8 0f c5 ff ff       	call   80101bb0 <dirlookup>
801056a1:	83 c4 10             	add    $0x10,%esp
801056a4:	85 c0                	test   %eax,%eax
801056a6:	89 c7                	mov    %eax,%edi
801056a8:	74 36                	je     801056e0 <create+0x80>
    iunlockput(dp);
801056aa:	83 ec 0c             	sub    $0xc,%esp
801056ad:	53                   	push   %ebx
801056ae:	e8 5d c2 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
801056b3:	89 3c 24             	mov    %edi,(%esp)
801056b6:	e8 c5 bf ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801056bb:	83 c4 10             	add    $0x10,%esp
801056be:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801056c3:	0f 85 97 00 00 00    	jne    80105760 <create+0x100>
801056c9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801056ce:	0f 85 8c 00 00 00    	jne    80105760 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801056d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056d7:	89 f8                	mov    %edi,%eax
801056d9:	5b                   	pop    %ebx
801056da:	5e                   	pop    %esi
801056db:	5f                   	pop    %edi
801056dc:	5d                   	pop    %ebp
801056dd:	c3                   	ret    
801056de:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
801056e0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801056e4:	83 ec 08             	sub    $0x8,%esp
801056e7:	50                   	push   %eax
801056e8:	ff 33                	pushl  (%ebx)
801056ea:	e8 21 be ff ff       	call   80101510 <ialloc>
801056ef:	83 c4 10             	add    $0x10,%esp
801056f2:	85 c0                	test   %eax,%eax
801056f4:	89 c7                	mov    %eax,%edi
801056f6:	0f 84 e8 00 00 00    	je     801057e4 <create+0x184>
  ilock(ip);
801056fc:	83 ec 0c             	sub    $0xc,%esp
801056ff:	50                   	push   %eax
80105700:	e8 7b bf ff ff       	call   80101680 <ilock>
  ip->major = major;
80105705:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105709:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010570d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105711:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105715:	b8 01 00 00 00       	mov    $0x1,%eax
8010571a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010571e:	89 3c 24             	mov    %edi,(%esp)
80105721:	e8 aa be ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105726:	83 c4 10             	add    $0x10,%esp
80105729:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010572e:	74 50                	je     80105780 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105730:	83 ec 04             	sub    $0x4,%esp
80105733:	ff 77 04             	pushl  0x4(%edi)
80105736:	56                   	push   %esi
80105737:	53                   	push   %ebx
80105738:	e8 e3 c6 ff ff       	call   80101e20 <dirlink>
8010573d:	83 c4 10             	add    $0x10,%esp
80105740:	85 c0                	test   %eax,%eax
80105742:	0f 88 8f 00 00 00    	js     801057d7 <create+0x177>
  iunlockput(dp);
80105748:	83 ec 0c             	sub    $0xc,%esp
8010574b:	53                   	push   %ebx
8010574c:	e8 bf c1 ff ff       	call   80101910 <iunlockput>
  return ip;
80105751:	83 c4 10             	add    $0x10,%esp
}
80105754:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105757:	89 f8                	mov    %edi,%eax
80105759:	5b                   	pop    %ebx
8010575a:	5e                   	pop    %esi
8010575b:	5f                   	pop    %edi
8010575c:	5d                   	pop    %ebp
8010575d:	c3                   	ret    
8010575e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	57                   	push   %edi
    return 0;
80105764:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105766:	e8 a5 c1 ff ff       	call   80101910 <iunlockput>
    return 0;
8010576b:	83 c4 10             	add    $0x10,%esp
}
8010576e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105771:	89 f8                	mov    %edi,%eax
80105773:	5b                   	pop    %ebx
80105774:	5e                   	pop    %esi
80105775:	5f                   	pop    %edi
80105776:	5d                   	pop    %ebp
80105777:	c3                   	ret    
80105778:	90                   	nop
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105780:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105785:	83 ec 0c             	sub    $0xc,%esp
80105788:	53                   	push   %ebx
80105789:	e8 42 be ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010578e:	83 c4 0c             	add    $0xc,%esp
80105791:	ff 77 04             	pushl  0x4(%edi)
80105794:	68 a0 8e 10 80       	push   $0x80108ea0
80105799:	57                   	push   %edi
8010579a:	e8 81 c6 ff ff       	call   80101e20 <dirlink>
8010579f:	83 c4 10             	add    $0x10,%esp
801057a2:	85 c0                	test   %eax,%eax
801057a4:	78 1c                	js     801057c2 <create+0x162>
801057a6:	83 ec 04             	sub    $0x4,%esp
801057a9:	ff 73 04             	pushl  0x4(%ebx)
801057ac:	68 9f 8e 10 80       	push   $0x80108e9f
801057b1:	57                   	push   %edi
801057b2:	e8 69 c6 ff ff       	call   80101e20 <dirlink>
801057b7:	83 c4 10             	add    $0x10,%esp
801057ba:	85 c0                	test   %eax,%eax
801057bc:	0f 89 6e ff ff ff    	jns    80105730 <create+0xd0>
      panic("create dots");
801057c2:	83 ec 0c             	sub    $0xc,%esp
801057c5:	68 93 8e 10 80       	push   $0x80108e93
801057ca:	e8 c1 ab ff ff       	call   80100390 <panic>
801057cf:	90                   	nop
    return 0;
801057d0:	31 ff                	xor    %edi,%edi
801057d2:	e9 fd fe ff ff       	jmp    801056d4 <create+0x74>
    panic("create: dirlink");
801057d7:	83 ec 0c             	sub    $0xc,%esp
801057da:	68 a2 8e 10 80       	push   $0x80108ea2
801057df:	e8 ac ab ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801057e4:	83 ec 0c             	sub    $0xc,%esp
801057e7:	68 84 8e 10 80       	push   $0x80108e84
801057ec:	e8 9f ab ff ff       	call   80100390 <panic>
801057f1:	eb 0d                	jmp    80105800 <argfd.constprop.0>
801057f3:	90                   	nop
801057f4:	90                   	nop
801057f5:	90                   	nop
801057f6:	90                   	nop
801057f7:	90                   	nop
801057f8:	90                   	nop
801057f9:	90                   	nop
801057fa:	90                   	nop
801057fb:	90                   	nop
801057fc:	90                   	nop
801057fd:	90                   	nop
801057fe:	90                   	nop
801057ff:	90                   	nop

80105800 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	56                   	push   %esi
80105804:	53                   	push   %ebx
80105805:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105807:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010580a:	89 d6                	mov    %edx,%esi
8010580c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010580f:	50                   	push   %eax
80105810:	6a 00                	push   $0x0
80105812:	e8 f9 fc ff ff       	call   80105510 <argint>
80105817:	83 c4 10             	add    $0x10,%esp
8010581a:	85 c0                	test   %eax,%eax
8010581c:	78 2a                	js     80105848 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010581e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105822:	77 24                	ja     80105848 <argfd.constprop.0+0x48>
80105824:	e8 f7 e1 ff ff       	call   80103a20 <myproc>
80105829:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010582c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105830:	85 c0                	test   %eax,%eax
80105832:	74 14                	je     80105848 <argfd.constprop.0+0x48>
  if(pfd)
80105834:	85 db                	test   %ebx,%ebx
80105836:	74 02                	je     8010583a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105838:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010583a:	89 06                	mov    %eax,(%esi)
  return 0;
8010583c:	31 c0                	xor    %eax,%eax
}
8010583e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105841:	5b                   	pop    %ebx
80105842:	5e                   	pop    %esi
80105843:	5d                   	pop    %ebp
80105844:	c3                   	ret    
80105845:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584d:	eb ef                	jmp    8010583e <argfd.constprop.0+0x3e>
8010584f:	90                   	nop

80105850 <sys_dup>:
{
80105850:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105851:	31 c0                	xor    %eax,%eax
{
80105853:	89 e5                	mov    %esp,%ebp
80105855:	56                   	push   %esi
80105856:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105857:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010585a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010585d:	e8 9e ff ff ff       	call   80105800 <argfd.constprop.0>
80105862:	85 c0                	test   %eax,%eax
80105864:	78 42                	js     801058a8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105866:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105869:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010586b:	e8 b0 e1 ff ff       	call   80103a20 <myproc>
80105870:	eb 0e                	jmp    80105880 <sys_dup+0x30>
80105872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105878:	83 c3 01             	add    $0x1,%ebx
8010587b:	83 fb 10             	cmp    $0x10,%ebx
8010587e:	74 28                	je     801058a8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105880:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105884:	85 d2                	test   %edx,%edx
80105886:	75 f0                	jne    80105878 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105888:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010588c:	83 ec 0c             	sub    $0xc,%esp
8010588f:	ff 75 f4             	pushl  -0xc(%ebp)
80105892:	e8 59 b5 ff ff       	call   80100df0 <filedup>
  return fd;
80105897:	83 c4 10             	add    $0x10,%esp
}
8010589a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010589d:	89 d8                	mov    %ebx,%eax
8010589f:	5b                   	pop    %ebx
801058a0:	5e                   	pop    %esi
801058a1:	5d                   	pop    %ebp
801058a2:	c3                   	ret    
801058a3:	90                   	nop
801058a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801058ab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801058b0:	89 d8                	mov    %ebx,%eax
801058b2:	5b                   	pop    %ebx
801058b3:	5e                   	pop    %esi
801058b4:	5d                   	pop    %ebp
801058b5:	c3                   	ret    
801058b6:	8d 76 00             	lea    0x0(%esi),%esi
801058b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058c0 <sys_read>:
{
801058c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058c1:	31 c0                	xor    %eax,%eax
{
801058c3:	89 e5                	mov    %esp,%ebp
801058c5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058c8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801058cb:	e8 30 ff ff ff       	call   80105800 <argfd.constprop.0>
801058d0:	85 c0                	test   %eax,%eax
801058d2:	78 4c                	js     80105920 <sys_read+0x60>
801058d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058d7:	83 ec 08             	sub    $0x8,%esp
801058da:	50                   	push   %eax
801058db:	6a 02                	push   $0x2
801058dd:	e8 2e fc ff ff       	call   80105510 <argint>
801058e2:	83 c4 10             	add    $0x10,%esp
801058e5:	85 c0                	test   %eax,%eax
801058e7:	78 37                	js     80105920 <sys_read+0x60>
801058e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ec:	83 ec 04             	sub    $0x4,%esp
801058ef:	ff 75 f0             	pushl  -0x10(%ebp)
801058f2:	50                   	push   %eax
801058f3:	6a 01                	push   $0x1
801058f5:	e8 66 fc ff ff       	call   80105560 <argptr>
801058fa:	83 c4 10             	add    $0x10,%esp
801058fd:	85 c0                	test   %eax,%eax
801058ff:	78 1f                	js     80105920 <sys_read+0x60>
  return fileread(f, p, n);
80105901:	83 ec 04             	sub    $0x4,%esp
80105904:	ff 75 f0             	pushl  -0x10(%ebp)
80105907:	ff 75 f4             	pushl  -0xc(%ebp)
8010590a:	ff 75 ec             	pushl  -0x14(%ebp)
8010590d:	e8 4e b6 ff ff       	call   80100f60 <fileread>
80105912:	83 c4 10             	add    $0x10,%esp
}
80105915:	c9                   	leave  
80105916:	c3                   	ret    
80105917:	89 f6                	mov    %esi,%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105925:	c9                   	leave  
80105926:	c3                   	ret    
80105927:	89 f6                	mov    %esi,%esi
80105929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105930 <sys_write>:
{
80105930:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105931:	31 c0                	xor    %eax,%eax
{
80105933:	89 e5                	mov    %esp,%ebp
80105935:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105938:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010593b:	e8 c0 fe ff ff       	call   80105800 <argfd.constprop.0>
80105940:	85 c0                	test   %eax,%eax
80105942:	78 4c                	js     80105990 <sys_write+0x60>
80105944:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105947:	83 ec 08             	sub    $0x8,%esp
8010594a:	50                   	push   %eax
8010594b:	6a 02                	push   $0x2
8010594d:	e8 be fb ff ff       	call   80105510 <argint>
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	85 c0                	test   %eax,%eax
80105957:	78 37                	js     80105990 <sys_write+0x60>
80105959:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010595c:	83 ec 04             	sub    $0x4,%esp
8010595f:	ff 75 f0             	pushl  -0x10(%ebp)
80105962:	50                   	push   %eax
80105963:	6a 01                	push   $0x1
80105965:	e8 f6 fb ff ff       	call   80105560 <argptr>
8010596a:	83 c4 10             	add    $0x10,%esp
8010596d:	85 c0                	test   %eax,%eax
8010596f:	78 1f                	js     80105990 <sys_write+0x60>
  return filewrite(f, p, n);
80105971:	83 ec 04             	sub    $0x4,%esp
80105974:	ff 75 f0             	pushl  -0x10(%ebp)
80105977:	ff 75 f4             	pushl  -0xc(%ebp)
8010597a:	ff 75 ec             	pushl  -0x14(%ebp)
8010597d:	e8 6e b6 ff ff       	call   80100ff0 <filewrite>
80105982:	83 c4 10             	add    $0x10,%esp
}
80105985:	c9                   	leave  
80105986:	c3                   	ret    
80105987:	89 f6                	mov    %esi,%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105995:	c9                   	leave  
80105996:	c3                   	ret    
80105997:	89 f6                	mov    %esi,%esi
80105999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059a0 <sys_close>:
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801059a6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801059a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059ac:	e8 4f fe ff ff       	call   80105800 <argfd.constprop.0>
801059b1:	85 c0                	test   %eax,%eax
801059b3:	78 2b                	js     801059e0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801059b5:	e8 66 e0 ff ff       	call   80103a20 <myproc>
801059ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801059bd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801059c0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801059c7:	00 
  fileclose(f);
801059c8:	ff 75 f4             	pushl  -0xc(%ebp)
801059cb:	e8 70 b4 ff ff       	call   80100e40 <fileclose>
  return 0;
801059d0:	83 c4 10             	add    $0x10,%esp
801059d3:	31 c0                	xor    %eax,%eax
}
801059d5:	c9                   	leave  
801059d6:	c3                   	ret    
801059d7:	89 f6                	mov    %esi,%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801059e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059e5:	c9                   	leave  
801059e6:	c3                   	ret    
801059e7:	89 f6                	mov    %esi,%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059f0 <sys_fstat>:
{
801059f0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059f1:	31 c0                	xor    %eax,%eax
{
801059f3:	89 e5                	mov    %esp,%ebp
801059f5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059f8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801059fb:	e8 00 fe ff ff       	call   80105800 <argfd.constprop.0>
80105a00:	85 c0                	test   %eax,%eax
80105a02:	78 2c                	js     80105a30 <sys_fstat+0x40>
80105a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a07:	83 ec 04             	sub    $0x4,%esp
80105a0a:	6a 14                	push   $0x14
80105a0c:	50                   	push   %eax
80105a0d:	6a 01                	push   $0x1
80105a0f:	e8 4c fb ff ff       	call   80105560 <argptr>
80105a14:	83 c4 10             	add    $0x10,%esp
80105a17:	85 c0                	test   %eax,%eax
80105a19:	78 15                	js     80105a30 <sys_fstat+0x40>
  return filestat(f, st);
80105a1b:	83 ec 08             	sub    $0x8,%esp
80105a1e:	ff 75 f4             	pushl  -0xc(%ebp)
80105a21:	ff 75 f0             	pushl  -0x10(%ebp)
80105a24:	e8 e7 b4 ff ff       	call   80100f10 <filestat>
80105a29:	83 c4 10             	add    $0x10,%esp
}
80105a2c:	c9                   	leave  
80105a2d:	c3                   	ret    
80105a2e:	66 90                	xchg   %ax,%ax
    return -1;
80105a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a35:	c9                   	leave  
80105a36:	c3                   	ret    
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a40 <sys_link>:
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	57                   	push   %edi
80105a44:	56                   	push   %esi
80105a45:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a46:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105a49:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a4c:	50                   	push   %eax
80105a4d:	6a 00                	push   $0x0
80105a4f:	e8 6c fb ff ff       	call   801055c0 <argstr>
80105a54:	83 c4 10             	add    $0x10,%esp
80105a57:	85 c0                	test   %eax,%eax
80105a59:	0f 88 fb 00 00 00    	js     80105b5a <sys_link+0x11a>
80105a5f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105a62:	83 ec 08             	sub    $0x8,%esp
80105a65:	50                   	push   %eax
80105a66:	6a 01                	push   $0x1
80105a68:	e8 53 fb ff ff       	call   801055c0 <argstr>
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	85 c0                	test   %eax,%eax
80105a72:	0f 88 e2 00 00 00    	js     80105b5a <sys_link+0x11a>
  begin_op();
80105a78:	e8 23 d1 ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
80105a7d:	83 ec 0c             	sub    $0xc,%esp
80105a80:	ff 75 d4             	pushl  -0x2c(%ebp)
80105a83:	e8 58 c4 ff ff       	call   80101ee0 <namei>
80105a88:	83 c4 10             	add    $0x10,%esp
80105a8b:	85 c0                	test   %eax,%eax
80105a8d:	89 c3                	mov    %eax,%ebx
80105a8f:	0f 84 ea 00 00 00    	je     80105b7f <sys_link+0x13f>
  ilock(ip);
80105a95:	83 ec 0c             	sub    $0xc,%esp
80105a98:	50                   	push   %eax
80105a99:	e8 e2 bb ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
80105a9e:	83 c4 10             	add    $0x10,%esp
80105aa1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105aa6:	0f 84 bb 00 00 00    	je     80105b67 <sys_link+0x127>
  ip->nlink++;
80105aac:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105ab1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105ab4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105ab7:	53                   	push   %ebx
80105ab8:	e8 13 bb ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
80105abd:	89 1c 24             	mov    %ebx,(%esp)
80105ac0:	e8 9b bc ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105ac5:	58                   	pop    %eax
80105ac6:	5a                   	pop    %edx
80105ac7:	57                   	push   %edi
80105ac8:	ff 75 d0             	pushl  -0x30(%ebp)
80105acb:	e8 30 c4 ff ff       	call   80101f00 <nameiparent>
80105ad0:	83 c4 10             	add    $0x10,%esp
80105ad3:	85 c0                	test   %eax,%eax
80105ad5:	89 c6                	mov    %eax,%esi
80105ad7:	74 5b                	je     80105b34 <sys_link+0xf4>
  ilock(dp);
80105ad9:	83 ec 0c             	sub    $0xc,%esp
80105adc:	50                   	push   %eax
80105add:	e8 9e bb ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105ae2:	83 c4 10             	add    $0x10,%esp
80105ae5:	8b 03                	mov    (%ebx),%eax
80105ae7:	39 06                	cmp    %eax,(%esi)
80105ae9:	75 3d                	jne    80105b28 <sys_link+0xe8>
80105aeb:	83 ec 04             	sub    $0x4,%esp
80105aee:	ff 73 04             	pushl  0x4(%ebx)
80105af1:	57                   	push   %edi
80105af2:	56                   	push   %esi
80105af3:	e8 28 c3 ff ff       	call   80101e20 <dirlink>
80105af8:	83 c4 10             	add    $0x10,%esp
80105afb:	85 c0                	test   %eax,%eax
80105afd:	78 29                	js     80105b28 <sys_link+0xe8>
  iunlockput(dp);
80105aff:	83 ec 0c             	sub    $0xc,%esp
80105b02:	56                   	push   %esi
80105b03:	e8 08 be ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105b08:	89 1c 24             	mov    %ebx,(%esp)
80105b0b:	e8 a0 bc ff ff       	call   801017b0 <iput>
  end_op();
80105b10:	e8 fb d0 ff ff       	call   80102c10 <end_op>
  return 0;
80105b15:	83 c4 10             	add    $0x10,%esp
80105b18:	31 c0                	xor    %eax,%eax
}
80105b1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b1d:	5b                   	pop    %ebx
80105b1e:	5e                   	pop    %esi
80105b1f:	5f                   	pop    %edi
80105b20:	5d                   	pop    %ebp
80105b21:	c3                   	ret    
80105b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105b28:	83 ec 0c             	sub    $0xc,%esp
80105b2b:	56                   	push   %esi
80105b2c:	e8 df bd ff ff       	call   80101910 <iunlockput>
    goto bad;
80105b31:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105b34:	83 ec 0c             	sub    $0xc,%esp
80105b37:	53                   	push   %ebx
80105b38:	e8 43 bb ff ff       	call   80101680 <ilock>
  ip->nlink--;
80105b3d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105b42:	89 1c 24             	mov    %ebx,(%esp)
80105b45:	e8 86 ba ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105b4a:	89 1c 24             	mov    %ebx,(%esp)
80105b4d:	e8 be bd ff ff       	call   80101910 <iunlockput>
  end_op();
80105b52:	e8 b9 d0 ff ff       	call   80102c10 <end_op>
  return -1;
80105b57:	83 c4 10             	add    $0x10,%esp
}
80105b5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105b5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b62:	5b                   	pop    %ebx
80105b63:	5e                   	pop    %esi
80105b64:	5f                   	pop    %edi
80105b65:	5d                   	pop    %ebp
80105b66:	c3                   	ret    
    iunlockput(ip);
80105b67:	83 ec 0c             	sub    $0xc,%esp
80105b6a:	53                   	push   %ebx
80105b6b:	e8 a0 bd ff ff       	call   80101910 <iunlockput>
    end_op();
80105b70:	e8 9b d0 ff ff       	call   80102c10 <end_op>
    return -1;
80105b75:	83 c4 10             	add    $0x10,%esp
80105b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b7d:	eb 9b                	jmp    80105b1a <sys_link+0xda>
    end_op();
80105b7f:	e8 8c d0 ff ff       	call   80102c10 <end_op>
    return -1;
80105b84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b89:	eb 8f                	jmp    80105b1a <sys_link+0xda>
80105b8b:	90                   	nop
80105b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b90 <sys_unlink>:
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	57                   	push   %edi
80105b94:	56                   	push   %esi
80105b95:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105b96:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105b99:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105b9c:	50                   	push   %eax
80105b9d:	6a 00                	push   $0x0
80105b9f:	e8 1c fa ff ff       	call   801055c0 <argstr>
80105ba4:	83 c4 10             	add    $0x10,%esp
80105ba7:	85 c0                	test   %eax,%eax
80105ba9:	0f 88 77 01 00 00    	js     80105d26 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80105baf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105bb2:	e8 e9 cf ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105bb7:	83 ec 08             	sub    $0x8,%esp
80105bba:	53                   	push   %ebx
80105bbb:	ff 75 c0             	pushl  -0x40(%ebp)
80105bbe:	e8 3d c3 ff ff       	call   80101f00 <nameiparent>
80105bc3:	83 c4 10             	add    $0x10,%esp
80105bc6:	85 c0                	test   %eax,%eax
80105bc8:	89 c6                	mov    %eax,%esi
80105bca:	0f 84 60 01 00 00    	je     80105d30 <sys_unlink+0x1a0>
  ilock(dp);
80105bd0:	83 ec 0c             	sub    $0xc,%esp
80105bd3:	50                   	push   %eax
80105bd4:	e8 a7 ba ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105bd9:	58                   	pop    %eax
80105bda:	5a                   	pop    %edx
80105bdb:	68 a0 8e 10 80       	push   $0x80108ea0
80105be0:	53                   	push   %ebx
80105be1:	e8 aa bf ff ff       	call   80101b90 <namecmp>
80105be6:	83 c4 10             	add    $0x10,%esp
80105be9:	85 c0                	test   %eax,%eax
80105beb:	0f 84 03 01 00 00    	je     80105cf4 <sys_unlink+0x164>
80105bf1:	83 ec 08             	sub    $0x8,%esp
80105bf4:	68 9f 8e 10 80       	push   $0x80108e9f
80105bf9:	53                   	push   %ebx
80105bfa:	e8 91 bf ff ff       	call   80101b90 <namecmp>
80105bff:	83 c4 10             	add    $0x10,%esp
80105c02:	85 c0                	test   %eax,%eax
80105c04:	0f 84 ea 00 00 00    	je     80105cf4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105c0a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105c0d:	83 ec 04             	sub    $0x4,%esp
80105c10:	50                   	push   %eax
80105c11:	53                   	push   %ebx
80105c12:	56                   	push   %esi
80105c13:	e8 98 bf ff ff       	call   80101bb0 <dirlookup>
80105c18:	83 c4 10             	add    $0x10,%esp
80105c1b:	85 c0                	test   %eax,%eax
80105c1d:	89 c3                	mov    %eax,%ebx
80105c1f:	0f 84 cf 00 00 00    	je     80105cf4 <sys_unlink+0x164>
  ilock(ip);
80105c25:	83 ec 0c             	sub    $0xc,%esp
80105c28:	50                   	push   %eax
80105c29:	e8 52 ba ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
80105c2e:	83 c4 10             	add    $0x10,%esp
80105c31:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105c36:	0f 8e 10 01 00 00    	jle    80105d4c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c41:	74 6d                	je     80105cb0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105c43:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105c46:	83 ec 04             	sub    $0x4,%esp
80105c49:	6a 10                	push   $0x10
80105c4b:	6a 00                	push   $0x0
80105c4d:	50                   	push   %eax
80105c4e:	e8 bd f5 ff ff       	call   80105210 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c53:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105c56:	6a 10                	push   $0x10
80105c58:	ff 75 c4             	pushl  -0x3c(%ebp)
80105c5b:	50                   	push   %eax
80105c5c:	56                   	push   %esi
80105c5d:	e8 fe bd ff ff       	call   80101a60 <writei>
80105c62:	83 c4 20             	add    $0x20,%esp
80105c65:	83 f8 10             	cmp    $0x10,%eax
80105c68:	0f 85 eb 00 00 00    	jne    80105d59 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80105c6e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c73:	0f 84 97 00 00 00    	je     80105d10 <sys_unlink+0x180>
  iunlockput(dp);
80105c79:	83 ec 0c             	sub    $0xc,%esp
80105c7c:	56                   	push   %esi
80105c7d:	e8 8e bc ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80105c82:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105c87:	89 1c 24             	mov    %ebx,(%esp)
80105c8a:	e8 41 b9 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105c8f:	89 1c 24             	mov    %ebx,(%esp)
80105c92:	e8 79 bc ff ff       	call   80101910 <iunlockput>
  end_op();
80105c97:	e8 74 cf ff ff       	call   80102c10 <end_op>
  return 0;
80105c9c:	83 c4 10             	add    $0x10,%esp
80105c9f:	31 c0                	xor    %eax,%eax
}
80105ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ca4:	5b                   	pop    %ebx
80105ca5:	5e                   	pop    %esi
80105ca6:	5f                   	pop    %edi
80105ca7:	5d                   	pop    %ebp
80105ca8:	c3                   	ret    
80105ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105cb0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105cb4:	76 8d                	jbe    80105c43 <sys_unlink+0xb3>
80105cb6:	bf 20 00 00 00       	mov    $0x20,%edi
80105cbb:	eb 0f                	jmp    80105ccc <sys_unlink+0x13c>
80105cbd:	8d 76 00             	lea    0x0(%esi),%esi
80105cc0:	83 c7 10             	add    $0x10,%edi
80105cc3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105cc6:	0f 83 77 ff ff ff    	jae    80105c43 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ccc:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105ccf:	6a 10                	push   $0x10
80105cd1:	57                   	push   %edi
80105cd2:	50                   	push   %eax
80105cd3:	53                   	push   %ebx
80105cd4:	e8 87 bc ff ff       	call   80101960 <readi>
80105cd9:	83 c4 10             	add    $0x10,%esp
80105cdc:	83 f8 10             	cmp    $0x10,%eax
80105cdf:	75 5e                	jne    80105d3f <sys_unlink+0x1af>
    if(de.inum != 0)
80105ce1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105ce6:	74 d8                	je     80105cc0 <sys_unlink+0x130>
    iunlockput(ip);
80105ce8:	83 ec 0c             	sub    $0xc,%esp
80105ceb:	53                   	push   %ebx
80105cec:	e8 1f bc ff ff       	call   80101910 <iunlockput>
    goto bad;
80105cf1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105cf4:	83 ec 0c             	sub    $0xc,%esp
80105cf7:	56                   	push   %esi
80105cf8:	e8 13 bc ff ff       	call   80101910 <iunlockput>
  end_op();
80105cfd:	e8 0e cf ff ff       	call   80102c10 <end_op>
  return -1;
80105d02:	83 c4 10             	add    $0x10,%esp
80105d05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0a:	eb 95                	jmp    80105ca1 <sys_unlink+0x111>
80105d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105d10:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105d15:	83 ec 0c             	sub    $0xc,%esp
80105d18:	56                   	push   %esi
80105d19:	e8 b2 b8 ff ff       	call   801015d0 <iupdate>
80105d1e:	83 c4 10             	add    $0x10,%esp
80105d21:	e9 53 ff ff ff       	jmp    80105c79 <sys_unlink+0xe9>
    return -1;
80105d26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d2b:	e9 71 ff ff ff       	jmp    80105ca1 <sys_unlink+0x111>
    end_op();
80105d30:	e8 db ce ff ff       	call   80102c10 <end_op>
    return -1;
80105d35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d3a:	e9 62 ff ff ff       	jmp    80105ca1 <sys_unlink+0x111>
      panic("isdirempty: readi");
80105d3f:	83 ec 0c             	sub    $0xc,%esp
80105d42:	68 c4 8e 10 80       	push   $0x80108ec4
80105d47:	e8 44 a6 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105d4c:	83 ec 0c             	sub    $0xc,%esp
80105d4f:	68 b2 8e 10 80       	push   $0x80108eb2
80105d54:	e8 37 a6 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105d59:	83 ec 0c             	sub    $0xc,%esp
80105d5c:	68 d6 8e 10 80       	push   $0x80108ed6
80105d61:	e8 2a a6 ff ff       	call   80100390 <panic>
80105d66:	8d 76 00             	lea    0x0(%esi),%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d70 <sys_open>:

int
sys_open(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	57                   	push   %edi
80105d74:	56                   	push   %esi
80105d75:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d76:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105d79:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d7c:	50                   	push   %eax
80105d7d:	6a 00                	push   $0x0
80105d7f:	e8 3c f8 ff ff       	call   801055c0 <argstr>
80105d84:	83 c4 10             	add    $0x10,%esp
80105d87:	85 c0                	test   %eax,%eax
80105d89:	0f 88 1d 01 00 00    	js     80105eac <sys_open+0x13c>
80105d8f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d92:	83 ec 08             	sub    $0x8,%esp
80105d95:	50                   	push   %eax
80105d96:	6a 01                	push   $0x1
80105d98:	e8 73 f7 ff ff       	call   80105510 <argint>
80105d9d:	83 c4 10             	add    $0x10,%esp
80105da0:	85 c0                	test   %eax,%eax
80105da2:	0f 88 04 01 00 00    	js     80105eac <sys_open+0x13c>
    return -1;

  begin_op();
80105da8:	e8 f3 cd ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
80105dad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105db1:	0f 85 a9 00 00 00    	jne    80105e60 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105db7:	83 ec 0c             	sub    $0xc,%esp
80105dba:	ff 75 e0             	pushl  -0x20(%ebp)
80105dbd:	e8 1e c1 ff ff       	call   80101ee0 <namei>
80105dc2:	83 c4 10             	add    $0x10,%esp
80105dc5:	85 c0                	test   %eax,%eax
80105dc7:	89 c6                	mov    %eax,%esi
80105dc9:	0f 84 b2 00 00 00    	je     80105e81 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105dcf:	83 ec 0c             	sub    $0xc,%esp
80105dd2:	50                   	push   %eax
80105dd3:	e8 a8 b8 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105dd8:	83 c4 10             	add    $0x10,%esp
80105ddb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105de0:	0f 84 aa 00 00 00    	je     80105e90 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105de6:	e8 95 af ff ff       	call   80100d80 <filealloc>
80105deb:	85 c0                	test   %eax,%eax
80105ded:	89 c7                	mov    %eax,%edi
80105def:	0f 84 a6 00 00 00    	je     80105e9b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105df5:	e8 26 dc ff ff       	call   80103a20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105dfa:	31 db                	xor    %ebx,%ebx
80105dfc:	eb 0e                	jmp    80105e0c <sys_open+0x9c>
80105dfe:	66 90                	xchg   %ax,%ax
80105e00:	83 c3 01             	add    $0x1,%ebx
80105e03:	83 fb 10             	cmp    $0x10,%ebx
80105e06:	0f 84 ac 00 00 00    	je     80105eb8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105e0c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105e10:	85 d2                	test   %edx,%edx
80105e12:	75 ec                	jne    80105e00 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105e14:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105e17:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105e1b:	56                   	push   %esi
80105e1c:	e8 3f b9 ff ff       	call   80101760 <iunlock>
  end_op();
80105e21:	e8 ea cd ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80105e26:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105e2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e2f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105e32:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105e35:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105e3c:	89 d0                	mov    %edx,%eax
80105e3e:	f7 d0                	not    %eax
80105e40:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e43:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105e46:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e49:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e50:	89 d8                	mov    %ebx,%eax
80105e52:	5b                   	pop    %ebx
80105e53:	5e                   	pop    %esi
80105e54:	5f                   	pop    %edi
80105e55:	5d                   	pop    %ebp
80105e56:	c3                   	ret    
80105e57:	89 f6                	mov    %esi,%esi
80105e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105e60:	83 ec 0c             	sub    $0xc,%esp
80105e63:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105e66:	31 c9                	xor    %ecx,%ecx
80105e68:	6a 00                	push   $0x0
80105e6a:	ba 02 00 00 00       	mov    $0x2,%edx
80105e6f:	e8 ec f7 ff ff       	call   80105660 <create>
    if(ip == 0){
80105e74:	83 c4 10             	add    $0x10,%esp
80105e77:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105e79:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105e7b:	0f 85 65 ff ff ff    	jne    80105de6 <sys_open+0x76>
      end_op();
80105e81:	e8 8a cd ff ff       	call   80102c10 <end_op>
      return -1;
80105e86:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e8b:	eb c0                	jmp    80105e4d <sys_open+0xdd>
80105e8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e90:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105e93:	85 c9                	test   %ecx,%ecx
80105e95:	0f 84 4b ff ff ff    	je     80105de6 <sys_open+0x76>
    iunlockput(ip);
80105e9b:	83 ec 0c             	sub    $0xc,%esp
80105e9e:	56                   	push   %esi
80105e9f:	e8 6c ba ff ff       	call   80101910 <iunlockput>
    end_op();
80105ea4:	e8 67 cd ff ff       	call   80102c10 <end_op>
    return -1;
80105ea9:	83 c4 10             	add    $0x10,%esp
80105eac:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105eb1:	eb 9a                	jmp    80105e4d <sys_open+0xdd>
80105eb3:	90                   	nop
80105eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105eb8:	83 ec 0c             	sub    $0xc,%esp
80105ebb:	57                   	push   %edi
80105ebc:	e8 7f af ff ff       	call   80100e40 <fileclose>
80105ec1:	83 c4 10             	add    $0x10,%esp
80105ec4:	eb d5                	jmp    80105e9b <sys_open+0x12b>
80105ec6:	8d 76 00             	lea    0x0(%esi),%esi
80105ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ed0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105ed6:	e8 c5 cc ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105edb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ede:	83 ec 08             	sub    $0x8,%esp
80105ee1:	50                   	push   %eax
80105ee2:	6a 00                	push   $0x0
80105ee4:	e8 d7 f6 ff ff       	call   801055c0 <argstr>
80105ee9:	83 c4 10             	add    $0x10,%esp
80105eec:	85 c0                	test   %eax,%eax
80105eee:	78 30                	js     80105f20 <sys_mkdir+0x50>
80105ef0:	83 ec 0c             	sub    $0xc,%esp
80105ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef6:	31 c9                	xor    %ecx,%ecx
80105ef8:	6a 00                	push   $0x0
80105efa:	ba 01 00 00 00       	mov    $0x1,%edx
80105eff:	e8 5c f7 ff ff       	call   80105660 <create>
80105f04:	83 c4 10             	add    $0x10,%esp
80105f07:	85 c0                	test   %eax,%eax
80105f09:	74 15                	je     80105f20 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f0b:	83 ec 0c             	sub    $0xc,%esp
80105f0e:	50                   	push   %eax
80105f0f:	e8 fc b9 ff ff       	call   80101910 <iunlockput>
  end_op();
80105f14:	e8 f7 cc ff ff       	call   80102c10 <end_op>
  return 0;
80105f19:	83 c4 10             	add    $0x10,%esp
80105f1c:	31 c0                	xor    %eax,%eax
}
80105f1e:	c9                   	leave  
80105f1f:	c3                   	ret    
    end_op();
80105f20:	e8 eb cc ff ff       	call   80102c10 <end_op>
    return -1;
80105f25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f2a:	c9                   	leave  
80105f2b:	c3                   	ret    
80105f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f30 <sys_mknod>:

int
sys_mknod(void)
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f36:	e8 65 cc ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f3b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f3e:	83 ec 08             	sub    $0x8,%esp
80105f41:	50                   	push   %eax
80105f42:	6a 00                	push   $0x0
80105f44:	e8 77 f6 ff ff       	call   801055c0 <argstr>
80105f49:	83 c4 10             	add    $0x10,%esp
80105f4c:	85 c0                	test   %eax,%eax
80105f4e:	78 60                	js     80105fb0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105f50:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f53:	83 ec 08             	sub    $0x8,%esp
80105f56:	50                   	push   %eax
80105f57:	6a 01                	push   $0x1
80105f59:	e8 b2 f5 ff ff       	call   80105510 <argint>
  if((argstr(0, &path)) < 0 ||
80105f5e:	83 c4 10             	add    $0x10,%esp
80105f61:	85 c0                	test   %eax,%eax
80105f63:	78 4b                	js     80105fb0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105f65:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f68:	83 ec 08             	sub    $0x8,%esp
80105f6b:	50                   	push   %eax
80105f6c:	6a 02                	push   $0x2
80105f6e:	e8 9d f5 ff ff       	call   80105510 <argint>
     argint(1, &major) < 0 ||
80105f73:	83 c4 10             	add    $0x10,%esp
80105f76:	85 c0                	test   %eax,%eax
80105f78:	78 36                	js     80105fb0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105f7a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105f7e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105f81:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105f85:	ba 03 00 00 00       	mov    $0x3,%edx
80105f8a:	50                   	push   %eax
80105f8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f8e:	e8 cd f6 ff ff       	call   80105660 <create>
80105f93:	83 c4 10             	add    $0x10,%esp
80105f96:	85 c0                	test   %eax,%eax
80105f98:	74 16                	je     80105fb0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f9a:	83 ec 0c             	sub    $0xc,%esp
80105f9d:	50                   	push   %eax
80105f9e:	e8 6d b9 ff ff       	call   80101910 <iunlockput>
  end_op();
80105fa3:	e8 68 cc ff ff       	call   80102c10 <end_op>
  return 0;
80105fa8:	83 c4 10             	add    $0x10,%esp
80105fab:	31 c0                	xor    %eax,%eax
}
80105fad:	c9                   	leave  
80105fae:	c3                   	ret    
80105faf:	90                   	nop
    end_op();
80105fb0:	e8 5b cc ff ff       	call   80102c10 <end_op>
    return -1;
80105fb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fba:	c9                   	leave  
80105fbb:	c3                   	ret    
80105fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fc0 <sys_chdir>:

int
sys_chdir(void)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	56                   	push   %esi
80105fc4:	53                   	push   %ebx
80105fc5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105fc8:	e8 53 da ff ff       	call   80103a20 <myproc>
80105fcd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105fcf:	e8 cc cb ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105fd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fd7:	83 ec 08             	sub    $0x8,%esp
80105fda:	50                   	push   %eax
80105fdb:	6a 00                	push   $0x0
80105fdd:	e8 de f5 ff ff       	call   801055c0 <argstr>
80105fe2:	83 c4 10             	add    $0x10,%esp
80105fe5:	85 c0                	test   %eax,%eax
80105fe7:	78 77                	js     80106060 <sys_chdir+0xa0>
80105fe9:	83 ec 0c             	sub    $0xc,%esp
80105fec:	ff 75 f4             	pushl  -0xc(%ebp)
80105fef:	e8 ec be ff ff       	call   80101ee0 <namei>
80105ff4:	83 c4 10             	add    $0x10,%esp
80105ff7:	85 c0                	test   %eax,%eax
80105ff9:	89 c3                	mov    %eax,%ebx
80105ffb:	74 63                	je     80106060 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105ffd:	83 ec 0c             	sub    $0xc,%esp
80106000:	50                   	push   %eax
80106001:	e8 7a b6 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80106006:	83 c4 10             	add    $0x10,%esp
80106009:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010600e:	75 30                	jne    80106040 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106010:	83 ec 0c             	sub    $0xc,%esp
80106013:	53                   	push   %ebx
80106014:	e8 47 b7 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80106019:	58                   	pop    %eax
8010601a:	ff 76 68             	pushl  0x68(%esi)
8010601d:	e8 8e b7 ff ff       	call   801017b0 <iput>
  end_op();
80106022:	e8 e9 cb ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80106027:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010602a:	83 c4 10             	add    $0x10,%esp
8010602d:	31 c0                	xor    %eax,%eax
}
8010602f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106032:	5b                   	pop    %ebx
80106033:	5e                   	pop    %esi
80106034:	5d                   	pop    %ebp
80106035:	c3                   	ret    
80106036:	8d 76 00             	lea    0x0(%esi),%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106040:	83 ec 0c             	sub    $0xc,%esp
80106043:	53                   	push   %ebx
80106044:	e8 c7 b8 ff ff       	call   80101910 <iunlockput>
    end_op();
80106049:	e8 c2 cb ff ff       	call   80102c10 <end_op>
    return -1;
8010604e:	83 c4 10             	add    $0x10,%esp
80106051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106056:	eb d7                	jmp    8010602f <sys_chdir+0x6f>
80106058:	90                   	nop
80106059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106060:	e8 ab cb ff ff       	call   80102c10 <end_op>
    return -1;
80106065:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010606a:	eb c3                	jmp    8010602f <sys_chdir+0x6f>
8010606c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106070 <sys_exec>:

int
sys_exec(void)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	57                   	push   %edi
80106074:	56                   	push   %esi
80106075:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106076:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010607c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106082:	50                   	push   %eax
80106083:	6a 00                	push   $0x0
80106085:	e8 36 f5 ff ff       	call   801055c0 <argstr>
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	85 c0                	test   %eax,%eax
8010608f:	0f 88 87 00 00 00    	js     8010611c <sys_exec+0xac>
80106095:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010609b:	83 ec 08             	sub    $0x8,%esp
8010609e:	50                   	push   %eax
8010609f:	6a 01                	push   $0x1
801060a1:	e8 6a f4 ff ff       	call   80105510 <argint>
801060a6:	83 c4 10             	add    $0x10,%esp
801060a9:	85 c0                	test   %eax,%eax
801060ab:	78 6f                	js     8010611c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801060ad:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801060b3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801060b6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801060b8:	68 80 00 00 00       	push   $0x80
801060bd:	6a 00                	push   $0x0
801060bf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801060c5:	50                   	push   %eax
801060c6:	e8 45 f1 ff ff       	call   80105210 <memset>
801060cb:	83 c4 10             	add    $0x10,%esp
801060ce:	eb 2c                	jmp    801060fc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801060d0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801060d6:	85 c0                	test   %eax,%eax
801060d8:	74 56                	je     80106130 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801060da:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801060e0:	83 ec 08             	sub    $0x8,%esp
801060e3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801060e6:	52                   	push   %edx
801060e7:	50                   	push   %eax
801060e8:	e8 b3 f3 ff ff       	call   801054a0 <fetchstr>
801060ed:	83 c4 10             	add    $0x10,%esp
801060f0:	85 c0                	test   %eax,%eax
801060f2:	78 28                	js     8010611c <sys_exec+0xac>
  for(i=0;; i++){
801060f4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801060f7:	83 fb 20             	cmp    $0x20,%ebx
801060fa:	74 20                	je     8010611c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801060fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106102:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106109:	83 ec 08             	sub    $0x8,%esp
8010610c:	57                   	push   %edi
8010610d:	01 f0                	add    %esi,%eax
8010610f:	50                   	push   %eax
80106110:	e8 4b f3 ff ff       	call   80105460 <fetchint>
80106115:	83 c4 10             	add    $0x10,%esp
80106118:	85 c0                	test   %eax,%eax
8010611a:	79 b4                	jns    801060d0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010611c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010611f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106124:	5b                   	pop    %ebx
80106125:	5e                   	pop    %esi
80106126:	5f                   	pop    %edi
80106127:	5d                   	pop    %ebp
80106128:	c3                   	ret    
80106129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106130:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106136:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106139:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106140:	00 00 00 00 
  return exec(path, argv);
80106144:	50                   	push   %eax
80106145:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010614b:	e8 c0 a8 ff ff       	call   80100a10 <exec>
80106150:	83 c4 10             	add    $0x10,%esp
}
80106153:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106156:	5b                   	pop    %ebx
80106157:	5e                   	pop    %esi
80106158:	5f                   	pop    %edi
80106159:	5d                   	pop    %ebp
8010615a:	c3                   	ret    
8010615b:	90                   	nop
8010615c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106160 <sys_pipe>:

int
sys_pipe(void)
{
80106160:	55                   	push   %ebp
80106161:	89 e5                	mov    %esp,%ebp
80106163:	57                   	push   %edi
80106164:	56                   	push   %esi
80106165:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106166:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106169:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010616c:	6a 08                	push   $0x8
8010616e:	50                   	push   %eax
8010616f:	6a 00                	push   $0x0
80106171:	e8 ea f3 ff ff       	call   80105560 <argptr>
80106176:	83 c4 10             	add    $0x10,%esp
80106179:	85 c0                	test   %eax,%eax
8010617b:	0f 88 ae 00 00 00    	js     8010622f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106181:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106184:	83 ec 08             	sub    $0x8,%esp
80106187:	50                   	push   %eax
80106188:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010618b:	50                   	push   %eax
8010618c:	e8 af d0 ff ff       	call   80103240 <pipealloc>
80106191:	83 c4 10             	add    $0x10,%esp
80106194:	85 c0                	test   %eax,%eax
80106196:	0f 88 93 00 00 00    	js     8010622f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010619c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010619f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801061a1:	e8 7a d8 ff ff       	call   80103a20 <myproc>
801061a6:	eb 10                	jmp    801061b8 <sys_pipe+0x58>
801061a8:	90                   	nop
801061a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801061b0:	83 c3 01             	add    $0x1,%ebx
801061b3:	83 fb 10             	cmp    $0x10,%ebx
801061b6:	74 60                	je     80106218 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801061b8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801061bc:	85 f6                	test   %esi,%esi
801061be:	75 f0                	jne    801061b0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801061c0:	8d 73 08             	lea    0x8(%ebx),%esi
801061c3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801061c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801061ca:	e8 51 d8 ff ff       	call   80103a20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801061cf:	31 d2                	xor    %edx,%edx
801061d1:	eb 0d                	jmp    801061e0 <sys_pipe+0x80>
801061d3:	90                   	nop
801061d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061d8:	83 c2 01             	add    $0x1,%edx
801061db:	83 fa 10             	cmp    $0x10,%edx
801061de:	74 28                	je     80106208 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801061e0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801061e4:	85 c9                	test   %ecx,%ecx
801061e6:	75 f0                	jne    801061d8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801061e8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801061ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061ef:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801061f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061f4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801061f7:	31 c0                	xor    %eax,%eax
}
801061f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061fc:	5b                   	pop    %ebx
801061fd:	5e                   	pop    %esi
801061fe:	5f                   	pop    %edi
801061ff:	5d                   	pop    %ebp
80106200:	c3                   	ret    
80106201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106208:	e8 13 d8 ff ff       	call   80103a20 <myproc>
8010620d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106214:	00 
80106215:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106218:	83 ec 0c             	sub    $0xc,%esp
8010621b:	ff 75 e0             	pushl  -0x20(%ebp)
8010621e:	e8 1d ac ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80106223:	58                   	pop    %eax
80106224:	ff 75 e4             	pushl  -0x1c(%ebp)
80106227:	e8 14 ac ff ff       	call   80100e40 <fileclose>
    return -1;
8010622c:	83 c4 10             	add    $0x10,%esp
8010622f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106234:	eb c3                	jmp    801061f9 <sys_pipe+0x99>
80106236:	66 90                	xchg   %ax,%ax
80106238:	66 90                	xchg   %ax,%ax
8010623a:	66 90                	xchg   %ax,%ax
8010623c:	66 90                	xchg   %ax,%ax
8010623e:	66 90                	xchg   %ax,%ax

80106240 <sys_fork>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void) {
80106240:	55                   	push   %ebp
80106241:	89 e5                	mov    %esp,%ebp
    return fork();
}
80106243:	5d                   	pop    %ebp
    return fork();
80106244:	e9 c7 df ff ff       	jmp    80104210 <fork>
80106249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106250 <sys_exit>:

int sys_exit(void) {
80106250:	55                   	push   %ebp
80106251:	89 e5                	mov    %esp,%ebp
80106253:	83 ec 08             	sub    $0x8,%esp
    cprintf("Exiting pid %d\n", myproc()->pid);
80106256:	e8 c5 d7 ff ff       	call   80103a20 <myproc>
8010625b:	83 ec 08             	sub    $0x8,%esp
8010625e:	ff 70 10             	pushl  0x10(%eax)
80106261:	68 e5 8e 10 80       	push   $0x80108ee5
80106266:	e8 f5 a3 ff ff       	call   80100660 <cprintf>
    exit();
8010626b:	e8 80 e4 ff ff       	call   801046f0 <exit>
    return 0;  // not reached
}
80106270:	31 c0                	xor    %eax,%eax
80106272:	c9                   	leave  
80106273:	c3                   	ret    
80106274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010627a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106280 <sys_wait>:

int sys_wait(void) {
80106280:	55                   	push   %ebp
80106281:	89 e5                	mov    %esp,%ebp
    return wait();
}
80106283:	5d                   	pop    %ebp
    return wait();
80106284:	e9 b7 e6 ff ff       	jmp    80104940 <wait>
80106289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106290 <sys_waitx>:

int sys_waitx(void) {
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
80106293:	83 ec 1c             	sub    $0x1c,%esp
    int *wtime, *rtime;
    if (argptr(0, (char **)&wtime, sizeof(int)) < 0) {
80106296:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106299:	6a 04                	push   $0x4
8010629b:	50                   	push   %eax
8010629c:	6a 00                	push   $0x0
8010629e:	e8 bd f2 ff ff       	call   80105560 <argptr>
801062a3:	83 c4 10             	add    $0x10,%esp
801062a6:	85 c0                	test   %eax,%eax
801062a8:	78 2e                	js     801062d8 <sys_waitx+0x48>
        return -1;
    }
    if (argptr(1, (char **)&rtime, sizeof(int)) < 0) {
801062aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062ad:	83 ec 04             	sub    $0x4,%esp
801062b0:	6a 04                	push   $0x4
801062b2:	50                   	push   %eax
801062b3:	6a 01                	push   $0x1
801062b5:	e8 a6 f2 ff ff       	call   80105560 <argptr>
801062ba:	83 c4 10             	add    $0x10,%esp
801062bd:	85 c0                	test   %eax,%eax
801062bf:	78 17                	js     801062d8 <sys_waitx+0x48>
        return -1;
    }

    return waitx(wtime, rtime);
801062c1:	83 ec 08             	sub    $0x8,%esp
801062c4:	ff 75 f4             	pushl  -0xc(%ebp)
801062c7:	ff 75 f0             	pushl  -0x10(%ebp)
801062ca:	e8 61 e7 ff ff       	call   80104a30 <waitx>
801062cf:	83 c4 10             	add    $0x10,%esp
}
801062d2:	c9                   	leave  
801062d3:	c3                   	ret    
801062d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801062d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062dd:	c9                   	leave  
801062de:	c3                   	ret    
801062df:	90                   	nop

801062e0 <sys_set_priority>:

int sys_set_priority(void) {
801062e0:	55                   	push   %ebp
801062e1:	89 e5                	mov    %esp,%ebp
801062e3:	83 ec 20             	sub    $0x20,%esp
    int pid, priority;
    if (argint(0, &pid) < 0)
801062e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062e9:	50                   	push   %eax
801062ea:	6a 00                	push   $0x0
801062ec:	e8 1f f2 ff ff       	call   80105510 <argint>
801062f1:	83 c4 10             	add    $0x10,%esp
801062f4:	85 c0                	test   %eax,%eax
801062f6:	78 28                	js     80106320 <sys_set_priority+0x40>
        return -1;
    if (argint(1, &priority) < 0)
801062f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062fb:	83 ec 08             	sub    $0x8,%esp
801062fe:	50                   	push   %eax
801062ff:	6a 01                	push   $0x1
80106301:	e8 0a f2 ff ff       	call   80105510 <argint>
80106306:	83 c4 10             	add    $0x10,%esp
80106309:	85 c0                	test   %eax,%eax
8010630b:	78 13                	js     80106320 <sys_set_priority+0x40>
        return -1;

    return set_priority(pid, priority);
8010630d:	83 ec 08             	sub    $0x8,%esp
80106310:	ff 75 f4             	pushl  -0xc(%ebp)
80106313:	ff 75 f0             	pushl  -0x10(%ebp)
80106316:	e8 25 e0 ff ff       	call   80104340 <set_priority>
8010631b:	83 c4 10             	add    $0x10,%esp
}
8010631e:	c9                   	leave  
8010631f:	c3                   	ret    
        return -1;
80106320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106325:	c9                   	leave  
80106326:	c3                   	ret    
80106327:	89 f6                	mov    %esi,%esi
80106329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106330 <sys_getpinfo>:

int sys_getpinfo(void) {
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	83 ec 20             	sub    $0x20,%esp
    int pid;
    struct proc_stat *p;
    if (argint(1, &pid) < 0) {
80106336:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106339:	50                   	push   %eax
8010633a:	6a 01                	push   $0x1
8010633c:	e8 cf f1 ff ff       	call   80105510 <argint>
80106341:	83 c4 10             	add    $0x10,%esp
80106344:	85 c0                	test   %eax,%eax
80106346:	78 30                	js     80106378 <sys_getpinfo+0x48>
        return -1;
    }
    if (argptr(0, (char **)&p, sizeof(struct proc_stat)) < 0) {
80106348:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010634b:	83 ec 04             	sub    $0x4,%esp
8010634e:	6a 24                	push   $0x24
80106350:	50                   	push   %eax
80106351:	6a 00                	push   $0x0
80106353:	e8 08 f2 ff ff       	call   80105560 <argptr>
80106358:	83 c4 10             	add    $0x10,%esp
8010635b:	85 c0                	test   %eax,%eax
8010635d:	78 19                	js     80106378 <sys_getpinfo+0x48>
        return -1;
    }

    return getpinfo(p, pid);
8010635f:	83 ec 08             	sub    $0x8,%esp
80106362:	ff 75 f0             	pushl  -0x10(%ebp)
80106365:	ff 75 f4             	pushl  -0xc(%ebp)
80106368:	e8 e3 d6 ff ff       	call   80103a50 <getpinfo>
8010636d:	83 c4 10             	add    $0x10,%esp
}
80106370:	c9                   	leave  
80106371:	c3                   	ret    
80106372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
80106378:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010637d:	c9                   	leave  
8010637e:	c3                   	ret    
8010637f:	90                   	nop

80106380 <sys_kill>:

int sys_kill(void) {
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
80106383:	83 ec 20             	sub    $0x20,%esp
    int pid;

    if (argint(0, &pid) < 0)
80106386:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106389:	50                   	push   %eax
8010638a:	6a 00                	push   $0x0
8010638c:	e8 7f f1 ff ff       	call   80105510 <argint>
80106391:	83 c4 10             	add    $0x10,%esp
80106394:	85 c0                	test   %eax,%eax
80106396:	78 18                	js     801063b0 <sys_kill+0x30>
        return -1;
    return kill(pid);
80106398:	83 ec 0c             	sub    $0xc,%esp
8010639b:	ff 75 f4             	pushl  -0xc(%ebp)
8010639e:	e8 1d e8 ff ff       	call   80104bc0 <kill>
801063a3:	83 c4 10             	add    $0x10,%esp
}
801063a6:	c9                   	leave  
801063a7:	c3                   	ret    
801063a8:	90                   	nop
801063a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801063b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063b5:	c9                   	leave  
801063b6:	c3                   	ret    
801063b7:	89 f6                	mov    %esi,%esi
801063b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063c0 <sys_getpid>:

int sys_getpid(void) {
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
801063c6:	e8 55 d6 ff ff       	call   80103a20 <myproc>
801063cb:	8b 40 10             	mov    0x10(%eax),%eax
}
801063ce:	c9                   	leave  
801063cf:	c3                   	ret    

801063d0 <sys_sbrk>:

int sys_sbrk(void) {
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
801063d3:	53                   	push   %ebx
    int addr;
    int n;

    if (argint(0, &n) < 0)
801063d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sbrk(void) {
801063d7:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0)
801063da:	50                   	push   %eax
801063db:	6a 00                	push   $0x0
801063dd:	e8 2e f1 ff ff       	call   80105510 <argint>
801063e2:	83 c4 10             	add    $0x10,%esp
801063e5:	85 c0                	test   %eax,%eax
801063e7:	78 27                	js     80106410 <sys_sbrk+0x40>
        return -1;
    addr = myproc()->sz;
801063e9:	e8 32 d6 ff ff       	call   80103a20 <myproc>
    if (growproc(n) < 0)
801063ee:	83 ec 0c             	sub    $0xc,%esp
    addr = myproc()->sz;
801063f1:	8b 18                	mov    (%eax),%ebx
    if (growproc(n) < 0)
801063f3:	ff 75 f4             	pushl  -0xc(%ebp)
801063f6:	e8 45 dd ff ff       	call   80104140 <growproc>
801063fb:	83 c4 10             	add    $0x10,%esp
801063fe:	85 c0                	test   %eax,%eax
80106400:	78 0e                	js     80106410 <sys_sbrk+0x40>
        return -1;
    return addr;
}
80106402:	89 d8                	mov    %ebx,%eax
80106404:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106407:	c9                   	leave  
80106408:	c3                   	ret    
80106409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80106410:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106415:	eb eb                	jmp    80106402 <sys_sbrk+0x32>
80106417:	89 f6                	mov    %esi,%esi
80106419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106420 <sys_sleep>:

int sys_sleep(void) {
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	53                   	push   %ebx
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
80106424:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sleep(void) {
80106427:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0)
8010642a:	50                   	push   %eax
8010642b:	6a 00                	push   $0x0
8010642d:	e8 de f0 ff ff       	call   80105510 <argint>
80106432:	83 c4 10             	add    $0x10,%esp
80106435:	85 c0                	test   %eax,%eax
80106437:	0f 88 8a 00 00 00    	js     801064c7 <sys_sleep+0xa7>
        return -1;
    acquire(&tickslock);
8010643d:	83 ec 0c             	sub    $0xc,%esp
80106440:	68 40 23 19 80       	push   $0x80192340
80106445:	e8 b6 ec ff ff       	call   80105100 <acquire>
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
8010644a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010644d:	83 c4 10             	add    $0x10,%esp
    ticks0 = ticks;
80106450:	8b 1d 80 2b 19 80    	mov    0x80192b80,%ebx
    while (ticks - ticks0 < n) {
80106456:	85 d2                	test   %edx,%edx
80106458:	75 27                	jne    80106481 <sys_sleep+0x61>
8010645a:	eb 54                	jmp    801064b0 <sys_sleep+0x90>
8010645c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
80106460:	83 ec 08             	sub    $0x8,%esp
80106463:	68 40 23 19 80       	push   $0x80192340
80106468:	68 80 2b 19 80       	push   $0x80192b80
8010646d:	e8 0e e4 ff ff       	call   80104880 <sleep>
    while (ticks - ticks0 < n) {
80106472:	a1 80 2b 19 80       	mov    0x80192b80,%eax
80106477:	83 c4 10             	add    $0x10,%esp
8010647a:	29 d8                	sub    %ebx,%eax
8010647c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010647f:	73 2f                	jae    801064b0 <sys_sleep+0x90>
        if (myproc()->killed) {
80106481:	e8 9a d5 ff ff       	call   80103a20 <myproc>
80106486:	8b 40 24             	mov    0x24(%eax),%eax
80106489:	85 c0                	test   %eax,%eax
8010648b:	74 d3                	je     80106460 <sys_sleep+0x40>
            release(&tickslock);
8010648d:	83 ec 0c             	sub    $0xc,%esp
80106490:	68 40 23 19 80       	push   $0x80192340
80106495:	e8 26 ed ff ff       	call   801051c0 <release>
            return -1;
8010649a:	83 c4 10             	add    $0x10,%esp
8010649d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    release(&tickslock);
    return 0;
}
801064a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064a5:	c9                   	leave  
801064a6:	c3                   	ret    
801064a7:	89 f6                	mov    %esi,%esi
801064a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&tickslock);
801064b0:	83 ec 0c             	sub    $0xc,%esp
801064b3:	68 40 23 19 80       	push   $0x80192340
801064b8:	e8 03 ed ff ff       	call   801051c0 <release>
    return 0;
801064bd:	83 c4 10             	add    $0x10,%esp
801064c0:	31 c0                	xor    %eax,%eax
}
801064c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064c5:	c9                   	leave  
801064c6:	c3                   	ret    
        return -1;
801064c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064cc:	eb f4                	jmp    801064c2 <sys_sleep+0xa2>
801064ce:	66 90                	xchg   %ax,%ax

801064d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void) {
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	53                   	push   %ebx
801064d4:	83 ec 10             	sub    $0x10,%esp
    uint xticks;

    acquire(&tickslock);
801064d7:	68 40 23 19 80       	push   $0x80192340
801064dc:	e8 1f ec ff ff       	call   80105100 <acquire>
    xticks = ticks;
801064e1:	8b 1d 80 2b 19 80    	mov    0x80192b80,%ebx
    release(&tickslock);
801064e7:	c7 04 24 40 23 19 80 	movl   $0x80192340,(%esp)
801064ee:	e8 cd ec ff ff       	call   801051c0 <release>
    return xticks;
}
801064f3:	89 d8                	mov    %ebx,%eax
801064f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064f8:	c9                   	leave  
801064f9:	c3                   	ret    

801064fa <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801064fa:	1e                   	push   %ds
  pushl %es
801064fb:	06                   	push   %es
  pushl %fs
801064fc:	0f a0                	push   %fs
  pushl %gs
801064fe:	0f a8                	push   %gs
  pushal
80106500:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106501:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106505:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106507:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106509:	54                   	push   %esp
  call trap
8010650a:	e8 c1 00 00 00       	call   801065d0 <trap>
  addl $4, %esp
8010650f:	83 c4 04             	add    $0x4,%esp

80106512 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106512:	61                   	popa   
  popl %gs
80106513:	0f a9                	pop    %gs
  popl %fs
80106515:	0f a1                	pop    %fs
  popl %es
80106517:	07                   	pop    %es
  popl %ds
80106518:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106519:	83 c4 08             	add    $0x8,%esp
  iret
8010651c:	cf                   	iret   
8010651d:	66 90                	xchg   %ax,%ax
8010651f:	90                   	nop

80106520 <tvinit>:
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void) {
80106520:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++)
80106521:	31 c0                	xor    %eax,%eax
void tvinit(void) {
80106523:	89 e5                	mov    %esp,%ebp
80106525:	83 ec 08             	sub    $0x8,%esp
80106528:	90                   	nop
80106529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80106530:	8b 14 85 7c c0 10 80 	mov    -0x7fef3f84(,%eax,4),%edx
80106537:	c7 04 c5 82 23 19 80 	movl   $0x8e000008,-0x7fe6dc7e(,%eax,8)
8010653e:	08 00 00 8e 
80106542:	66 89 14 c5 80 23 19 	mov    %dx,-0x7fe6dc80(,%eax,8)
80106549:	80 
8010654a:	c1 ea 10             	shr    $0x10,%edx
8010654d:	66 89 14 c5 86 23 19 	mov    %dx,-0x7fe6dc7a(,%eax,8)
80106554:	80 
    for (i = 0; i < 256; i++)
80106555:	83 c0 01             	add    $0x1,%eax
80106558:	3d 00 01 00 00       	cmp    $0x100,%eax
8010655d:	75 d1                	jne    80106530 <tvinit+0x10>
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010655f:	a1 7c c1 10 80       	mov    0x8010c17c,%eax

    initlock(&tickslock, "time");
80106564:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106567:	c7 05 82 25 19 80 08 	movl   $0xef000008,0x80192582
8010656e:	00 00 ef 
    initlock(&tickslock, "time");
80106571:	68 f5 8e 10 80       	push   $0x80108ef5
80106576:	68 40 23 19 80       	push   $0x80192340
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010657b:	66 a3 80 25 19 80    	mov    %ax,0x80192580
80106581:	c1 e8 10             	shr    $0x10,%eax
80106584:	66 a3 86 25 19 80    	mov    %ax,0x80192586
    initlock(&tickslock, "time");
8010658a:	e8 31 ea ff ff       	call   80104fc0 <initlock>
}
8010658f:	83 c4 10             	add    $0x10,%esp
80106592:	c9                   	leave  
80106593:	c3                   	ret    
80106594:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010659a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801065a0 <idtinit>:

void idtinit(void) {
801065a0:	55                   	push   %ebp
  pd[0] = size-1;
801065a1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801065a6:	89 e5                	mov    %esp,%ebp
801065a8:	83 ec 10             	sub    $0x10,%esp
801065ab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801065af:	b8 80 23 19 80       	mov    $0x80192380,%eax
801065b4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801065b8:	c1 e8 10             	shr    $0x10,%eax
801065bb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801065bf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801065c2:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
801065c5:	c9                   	leave  
801065c6:	c3                   	ret    
801065c7:	89 f6                	mov    %esi,%esi
801065c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065d0 <trap>:

// PAGEBREAK: 41
void trap(struct trapframe *tf) {
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	57                   	push   %edi
801065d4:	56                   	push   %esi
801065d5:	53                   	push   %ebx
801065d6:	83 ec 1c             	sub    $0x1c,%esp
801065d9:	8b 7d 08             	mov    0x8(%ebp),%edi
    if (tf->trapno == T_SYSCALL) {
801065dc:	8b 47 30             	mov    0x30(%edi),%eax
801065df:	83 f8 40             	cmp    $0x40,%eax
801065e2:	0f 84 f0 00 00 00    	je     801066d8 <trap+0x108>
        if (myproc()->killed)
            exit();
        return;
    }

    switch (tf->trapno) {
801065e8:	83 e8 20             	sub    $0x20,%eax
801065eb:	83 f8 1f             	cmp    $0x1f,%eax
801065ee:	77 10                	ja     80106600 <trap+0x30>
801065f0:	ff 24 85 d4 8f 10 80 	jmp    *-0x7fef702c(,%eax,4)
801065f7:	89 f6                	mov    %esi,%esi
801065f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            lapiceoi();
            break;

        // PAGEBREAK: 13
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
80106600:	e8 1b d4 ff ff       	call   80103a20 <myproc>
80106605:	85 c0                	test   %eax,%eax
80106607:	8b 5f 38             	mov    0x38(%edi),%ebx
8010660a:	0f 84 07 0a 00 00    	je     80107017 <trap+0xa47>
80106610:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106614:	0f 84 fd 09 00 00    	je     80107017 <trap+0xa47>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010661a:	0f 20 d1             	mov    %cr2,%ecx
8010661d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf(
80106620:	e8 db d3 ff ff       	call   80103a00 <cpuid>
80106625:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106628:	8b 47 34             	mov    0x34(%edi),%eax
8010662b:	8b 77 30             	mov    0x30(%edi),%esi
8010662e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                "pid %d %s: trap %d err %d on cpu %d "
                "eip 0x%x addr 0x%x--kill proc\n",
                myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(),
80106631:	e8 ea d3 ff ff       	call   80103a20 <myproc>
80106636:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106639:	e8 e2 d3 ff ff       	call   80103a20 <myproc>
            cprintf(
8010663e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106641:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106644:	51                   	push   %ecx
80106645:	53                   	push   %ebx
80106646:	52                   	push   %edx
                myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(),
80106647:	8b 55 e0             	mov    -0x20(%ebp),%edx
            cprintf(
8010664a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010664d:	56                   	push   %esi
                myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(),
8010664e:	83 c2 6c             	add    $0x6c,%edx
            cprintf(
80106651:	52                   	push   %edx
80106652:	ff 70 10             	pushl  0x10(%eax)
80106655:	68 58 8f 10 80       	push   $0x80108f58
8010665a:	e8 01 a0 ff ff       	call   80100660 <cprintf>
                tf->eip, rcr2());
            myproc()->killed = 1;
8010665f:	83 c4 20             	add    $0x20,%esp
80106662:	e8 b9 d3 ff ff       	call   80103a20 <myproc>
80106667:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010666e:	e8 ad d3 ff ff       	call   80103a20 <myproc>
80106673:	85 c0                	test   %eax,%eax
80106675:	74 1d                	je     80106694 <trap+0xc4>
80106677:	e8 a4 d3 ff ff       	call   80103a20 <myproc>
8010667c:	8b 40 24             	mov    0x24(%eax),%eax
8010667f:	85 c0                	test   %eax,%eax
80106681:	74 11                	je     80106694 <trap+0xc4>
80106683:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106687:	83 e0 03             	and    $0x3,%eax
8010668a:	66 83 f8 03          	cmp    $0x3,%ax
8010668e:	0f 84 5c 02 00 00    	je     801068f0 <trap+0x320>
        }
    }
#endif

#ifdef MLFQ
    if (myproc() && myproc()->state == RUNNING &&
80106694:	e8 87 d3 ff ff       	call   80103a20 <myproc>
80106699:	85 c0                	test   %eax,%eax
8010669b:	74 0b                	je     801066a8 <trap+0xd8>
8010669d:	e8 7e d3 ff ff       	call   80103a20 <myproc>
801066a2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801066a6:	74 68                	je     80106710 <trap+0x140>
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();
#endif

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801066a8:	e8 73 d3 ff ff       	call   80103a20 <myproc>
801066ad:	85 c0                	test   %eax,%eax
801066af:	74 19                	je     801066ca <trap+0xfa>
801066b1:	e8 6a d3 ff ff       	call   80103a20 <myproc>
801066b6:	8b 40 24             	mov    0x24(%eax),%eax
801066b9:	85 c0                	test   %eax,%eax
801066bb:	74 0d                	je     801066ca <trap+0xfa>
801066bd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801066c1:	83 e0 03             	and    $0x3,%eax
801066c4:	66 83 f8 03          	cmp    $0x3,%ax
801066c8:	74 37                	je     80106701 <trap+0x131>
        exit();
}
801066ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066cd:	5b                   	pop    %ebx
801066ce:	5e                   	pop    %esi
801066cf:	5f                   	pop    %edi
801066d0:	5d                   	pop    %ebp
801066d1:	c3                   	ret    
801066d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (myproc()->killed)
801066d8:	e8 43 d3 ff ff       	call   80103a20 <myproc>
801066dd:	8b 40 24             	mov    0x24(%eax),%eax
801066e0:	85 c0                	test   %eax,%eax
801066e2:	0f 85 f8 01 00 00    	jne    801068e0 <trap+0x310>
        myproc()->tf = tf;
801066e8:	e8 33 d3 ff ff       	call   80103a20 <myproc>
801066ed:	89 78 18             	mov    %edi,0x18(%eax)
        syscall();
801066f0:	e8 0b ef ff ff       	call   80105600 <syscall>
        if (myproc()->killed)
801066f5:	e8 26 d3 ff ff       	call   80103a20 <myproc>
801066fa:	8b 40 24             	mov    0x24(%eax),%eax
801066fd:	85 c0                	test   %eax,%eax
801066ff:	74 c9                	je     801066ca <trap+0xfa>
}
80106701:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106704:	5b                   	pop    %ebx
80106705:	5e                   	pop    %esi
80106706:	5f                   	pop    %edi
80106707:	5d                   	pop    %ebp
            exit();
80106708:	e9 e3 df ff ff       	jmp    801046f0 <exit>
8010670d:	8d 76 00             	lea    0x0(%esi),%esi
    if (myproc() && myproc()->state == RUNNING &&
80106710:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106714:	75 92                	jne    801066a8 <trap+0xd8>
        int no = myproc()->qno;
80106716:	e8 05 d3 ff ff       	call   80103a20 <myproc>
8010671b:	8b 98 90 00 00 00    	mov    0x90(%eax),%ebx
        if (myproc()->rrtime[no] != 0) {
80106721:	e8 fa d2 ff ff       	call   80103a20 <myproc>
80106726:	8b b4 98 98 00 00 00 	mov    0x98(%eax,%ebx,4),%esi
8010672d:	85 f6                	test   %esi,%esi
8010672f:	0f 84 73 ff ff ff    	je     801066a8 <trap+0xd8>
            if (no == 0) {
80106735:	85 db                	test   %ebx,%ebx
80106737:	0f 85 38 02 00 00    	jne    80106975 <trap+0x3a5>
                for (int i = 0; i < cnt[0]; i++) {
8010673d:	8b 0d 1c c6 10 80    	mov    0x8010c61c,%ecx
80106743:	85 c9                	test   %ecx,%ecx
80106745:	0f 8e 99 07 00 00    	jle    80106ee4 <trap+0x914>
                int ind = -1;
8010674b:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80106750:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
                for (int i = 0; i < cnt[0]; i++) {
80106753:	31 f6                	xor    %esi,%esi
                int ind = -1;
80106755:	89 cb                	mov    %ecx,%ebx
80106757:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010675a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                    if (q0[i]->pid == myproc()->pid) {
80106760:	8b 04 b5 c0 cf 18 80 	mov    -0x7fe73040(,%esi,4),%eax
80106767:	8b 78 10             	mov    0x10(%eax),%edi
8010676a:	e8 b1 d2 ff ff       	call   80103a20 <myproc>
8010676f:	3b 78 10             	cmp    0x10(%eax),%edi
80106772:	0f 44 de             	cmove  %esi,%ebx
                for (int i = 0; i < cnt[0]; i++) {
80106775:	83 c6 01             	add    $0x1,%esi
80106778:	39 35 1c c6 10 80    	cmp    %esi,0x8010c61c
8010677e:	7f e0                	jg     80106760 <trap+0x190>
80106780:	89 d9                	mov    %ebx,%ecx
80106782:	8b 7d e0             	mov    -0x20(%ebp),%edi
80106785:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80106788:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
                myproc()->rrtime[0] = 0;
8010678b:	e8 90 d2 ff ff       	call   80103a20 <myproc>
80106790:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
80106797:	00 00 00 
                myproc()->rrtime[1] = 0;
8010679a:	e8 81 d2 ff ff       	call   80103a20 <myproc>
8010679f:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%eax)
801067a6:	00 00 00 
                myproc()->qno = 1;
801067a9:	e8 72 d2 ff ff       	call   80103a20 <myproc>
801067ae:	c7 80 90 00 00 00 01 	movl   $0x1,0x90(%eax)
801067b5:	00 00 00 
                cnt[0]--;
801067b8:	8b 15 1c c6 10 80    	mov    0x8010c61c,%edx
                for (int i = ind; i < cnt[0]; i++) {
801067be:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
                cnt[0]--;
801067c1:	8d 42 ff             	lea    -0x1(%edx),%eax
                for (int i = ind; i < cnt[0]; i++) {
801067c4:	39 c8                	cmp    %ecx,%eax
                cnt[0]--;
801067c6:	a3 1c c6 10 80       	mov    %eax,0x8010c61c
                for (int i = ind; i < cnt[0]; i++) {
801067cb:	7e 20                	jle    801067ed <trap+0x21d>
801067cd:	8d 04 8d c0 cf 18 80 	lea    -0x7fe73040(,%ecx,4),%eax
801067d4:	8d 0c 95 bc cf 18 80 	lea    -0x7fe73044(,%edx,4),%ecx
801067db:	90                   	nop
801067dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                    q0[i] = q0[i + 1];
801067e0:	8b 50 04             	mov    0x4(%eax),%edx
801067e3:	83 c0 04             	add    $0x4,%eax
801067e6:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = ind; i < cnt[0]; i++) {
801067e9:	39 c8                	cmp    %ecx,%eax
801067eb:	75 f3                	jne    801067e0 <trap+0x210>
                for (int i = 0; i < cnt[1]; i++) {
801067ed:	8b 15 20 c6 10 80    	mov    0x8010c620,%edx
801067f3:	85 d2                	test   %edx,%edx
801067f5:	7f 18                	jg     8010680f <trap+0x23f>
801067f7:	e9 39 03 00 00       	jmp    80106b35 <trap+0x565>
801067fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106800:	83 c3 01             	add    $0x1,%ebx
80106803:	39 1d 20 c6 10 80    	cmp    %ebx,0x8010c620
80106809:	0f 8e 26 03 00 00    	jle    80106b35 <trap+0x565>
                    if (q1[i]->pid == myproc()->pid) {
8010680f:	8b 04 9d 20 c0 18 80 	mov    -0x7fe73fe0(,%ebx,4),%eax
80106816:	8b 70 10             	mov    0x10(%eax),%esi
80106819:	e8 02 d2 ff ff       	call   80103a20 <myproc>
8010681e:	3b 70 10             	cmp    0x10(%eax),%esi
80106821:	75 dd                	jne    80106800 <trap+0x230>
                yield();
80106823:	e8 08 e0 ff ff       	call   80104830 <yield>
80106828:	e9 7b fe ff ff       	jmp    801066a8 <trap+0xd8>
8010682d:	8d 76 00             	lea    0x0(%esi),%esi
            if (cpuid() == 0) {
80106830:	e8 cb d1 ff ff       	call   80103a00 <cpuid>
80106835:	85 c0                	test   %eax,%eax
80106837:	0f 84 c3 00 00 00    	je     80106900 <trap+0x330>
            lapiceoi();
8010683d:	e8 0e bf ff ff       	call   80102750 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106842:	e8 d9 d1 ff ff       	call   80103a20 <myproc>
80106847:	85 c0                	test   %eax,%eax
80106849:	0f 85 28 fe ff ff    	jne    80106677 <trap+0xa7>
8010684f:	e9 40 fe ff ff       	jmp    80106694 <trap+0xc4>
80106854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kbdintr();
80106858:	e8 b3 bd ff ff       	call   80102610 <kbdintr>
            lapiceoi();
8010685d:	e8 ee be ff ff       	call   80102750 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106862:	e8 b9 d1 ff ff       	call   80103a20 <myproc>
80106867:	85 c0                	test   %eax,%eax
80106869:	0f 85 08 fe ff ff    	jne    80106677 <trap+0xa7>
8010686f:	e9 20 fe ff ff       	jmp    80106694 <trap+0xc4>
80106874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            uartintr();
80106878:	e8 33 09 00 00       	call   801071b0 <uartintr>
            lapiceoi();
8010687d:	e8 ce be ff ff       	call   80102750 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106882:	e8 99 d1 ff ff       	call   80103a20 <myproc>
80106887:	85 c0                	test   %eax,%eax
80106889:	0f 85 e8 fd ff ff    	jne    80106677 <trap+0xa7>
8010688f:	e9 00 fe ff ff       	jmp    80106694 <trap+0xc4>
80106894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            cprintf("cpu%d: spurious interrupt at %x:%x\n", cpuid(), tf->cs,
80106898:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010689c:	8b 77 38             	mov    0x38(%edi),%esi
8010689f:	e8 5c d1 ff ff       	call   80103a00 <cpuid>
801068a4:	56                   	push   %esi
801068a5:	53                   	push   %ebx
801068a6:	50                   	push   %eax
801068a7:	68 00 8f 10 80       	push   $0x80108f00
801068ac:	e8 af 9d ff ff       	call   80100660 <cprintf>
            lapiceoi();
801068b1:	e8 9a be ff ff       	call   80102750 <lapiceoi>
            break;
801068b6:	83 c4 10             	add    $0x10,%esp
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801068b9:	e8 62 d1 ff ff       	call   80103a20 <myproc>
801068be:	85 c0                	test   %eax,%eax
801068c0:	0f 85 b1 fd ff ff    	jne    80106677 <trap+0xa7>
801068c6:	e9 c9 fd ff ff       	jmp    80106694 <trap+0xc4>
801068cb:	90                   	nop
801068cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            ideintr();
801068d0:	e8 ab b7 ff ff       	call   80102080 <ideintr>
801068d5:	e9 63 ff ff ff       	jmp    8010683d <trap+0x26d>
801068da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            exit();
801068e0:	e8 0b de ff ff       	call   801046f0 <exit>
801068e5:	e9 fe fd ff ff       	jmp    801066e8 <trap+0x118>
801068ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        exit();
801068f0:	e8 fb dd ff ff       	call   801046f0 <exit>
801068f5:	e9 9a fd ff ff       	jmp    80106694 <trap+0xc4>
801068fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                acquire(&tickslock);
80106900:	83 ec 0c             	sub    $0xc,%esp
80106903:	68 40 23 19 80       	push   $0x80192340
80106908:	e8 f3 e7 ff ff       	call   80105100 <acquire>
                wakeup(&ticks);
8010690d:	c7 04 24 80 2b 19 80 	movl   $0x80192b80,(%esp)
                ticks++;
80106914:	83 05 80 2b 19 80 01 	addl   $0x1,0x80192b80
                wakeup(&ticks);
8010691b:	e8 40 e2 ff ff       	call   80104b60 <wakeup>
                release(&tickslock);
80106920:	c7 04 24 40 23 19 80 	movl   $0x80192340,(%esp)
80106927:	e8 94 e8 ff ff       	call   801051c0 <release>
                graph();
8010692c:	e8 ff ce ff ff       	call   80103830 <graph>
                aging();
80106931:	e8 3a d2 ff ff       	call   80103b70 <aging>
                if (myproc()) {
80106936:	e8 e5 d0 ff ff       	call   80103a20 <myproc>
8010693b:	83 c4 10             	add    $0x10,%esp
8010693e:	85 c0                	test   %eax,%eax
80106940:	0f 84 f7 fe ff ff    	je     8010683d <trap+0x26d>
                    if (myproc()->state == RUNNING) {
80106946:	e8 d5 d0 ff ff       	call   80103a20 <myproc>
8010694b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010694f:	0f 84 9b 01 00 00    	je     80106af0 <trap+0x520>
                    } else if (myproc()->state == SLEEPING) {
80106955:	e8 c6 d0 ff ff       	call   80103a20 <myproc>
8010695a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010695e:	0f 85 d9 fe ff ff    	jne    8010683d <trap+0x26d>
                        myproc()->iotime++;
80106964:	e8 b7 d0 ff ff       	call   80103a20 <myproc>
80106969:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
80106970:	e9 c8 fe ff ff       	jmp    8010683d <trap+0x26d>
            } else if (no == 1 && myproc()->rrtime[1] % 2 == 0) {
80106975:	83 fb 01             	cmp    $0x1,%ebx
80106978:	0f 84 42 02 00 00    	je     80106bc0 <trap+0x5f0>
            } else if (no == 2 && myproc()->rrtime[2] % 4 == 0) {
8010697e:	83 fb 02             	cmp    $0x2,%ebx
80106981:	0f 84 0e 03 00 00    	je     80106c95 <trap+0x6c5>
            } else if (no == 3 && myproc()->rrtime[3] % 8 == 0) {
80106987:	83 fb 03             	cmp    $0x3,%ebx
8010698a:	0f 84 da 03 00 00    	je     80106d6a <trap+0x79a>
            } else if (no == 4 && myproc()->rrtime[4] % 16 == 0) {
80106990:	83 fb 04             	cmp    $0x4,%ebx
80106993:	0f 84 a6 04 00 00    	je     80106e3f <trap+0x86f>
                for (int j = 0; j < cnt[0]; j++) {
80106999:	8b 0d 1c c6 10 80    	mov    0x8010c61c,%ecx
8010699f:	85 c9                	test   %ecx,%ecx
801069a1:	7e 35                	jle    801069d8 <trap+0x408>
                    if (q0[j]->state == RUNNABLE) {
801069a3:	a1 c0 cf 18 80       	mov    0x8018cfc0,%eax
801069a8:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801069ac:	0f 84 f6 01 00 00    	je     80106ba8 <trap+0x5d8>
                for (int j = 0; j < cnt[0]; j++) {
801069b2:	31 c0                	xor    %eax,%eax
801069b4:	eb 1b                	jmp    801069d1 <trap+0x401>
801069b6:	8d 76 00             	lea    0x0(%esi),%esi
801069b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    if (q0[j]->state == RUNNABLE) {
801069c0:	8b 14 85 c0 cf 18 80 	mov    -0x7fe73040(,%eax,4),%edx
801069c7:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801069cb:	0f 84 d7 01 00 00    	je     80106ba8 <trap+0x5d8>
                for (int j = 0; j < cnt[0]; j++) {
801069d1:	83 c0 01             	add    $0x1,%eax
801069d4:	39 c8                	cmp    %ecx,%eax
801069d6:	75 e8                	jne    801069c0 <trap+0x3f0>
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
801069d8:	31 c9                	xor    %ecx,%ecx
                for (int j = 0; j < cnt[1]; j++) {
801069da:	8b 35 20 c6 10 80    	mov    0x8010c620,%esi
801069e0:	85 f6                	test   %esi,%esi
801069e2:	7e 34                	jle    80106a18 <trap+0x448>
                    if (q1[j]->state == RUNNABLE) {
801069e4:	a1 20 c0 18 80       	mov    0x8018c020,%eax
801069e9:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801069ed:	0f 84 ab 01 00 00    	je     80106b9e <trap+0x5ce>
                for (int j = 0; j < cnt[1]; j++) {
801069f3:	31 c0                	xor    %eax,%eax
801069f5:	eb 1a                	jmp    80106a11 <trap+0x441>
801069f7:	89 f6                	mov    %esi,%esi
801069f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    if (q1[j]->state == RUNNABLE) {
80106a00:	8b 14 85 20 c0 18 80 	mov    -0x7fe73fe0(,%eax,4),%edx
80106a07:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80106a0b:	0f 84 8d 01 00 00    	je     80106b9e <trap+0x5ce>
                for (int j = 0; j < cnt[1]; j++) {
80106a11:	83 c0 01             	add    $0x1,%eax
80106a14:	39 f0                	cmp    %esi,%eax
80106a16:	75 e8                	jne    80106a00 <trap+0x430>
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
80106a18:	31 d2                	xor    %edx,%edx
                for (int j = 0; j < cnt[2]; j++) {
80106a1a:	8b 35 24 c6 10 80    	mov    0x8010c624,%esi
80106a20:	85 f6                	test   %esi,%esi
80106a22:	0f 8e d9 04 00 00    	jle    80106f01 <trap+0x931>
                    if (q2[j]->state == RUNNABLE) {
80106a28:	a1 c0 a0 18 80       	mov    0x8018a0c0,%eax
80106a2d:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80106a31:	0f 84 5b 01 00 00    	je     80106b92 <trap+0x5c2>
                for (int j = 0; j < cnt[2]; j++) {
80106a37:	31 c0                	xor    %eax,%eax
80106a39:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106a3c:	eb 13                	jmp    80106a51 <trap+0x481>
80106a3e:	66 90                	xchg   %ax,%ax
                    if (q2[j]->state == RUNNABLE) {
80106a40:	8b 14 85 c0 a0 18 80 	mov    -0x7fe75f40(,%eax,4),%edx
80106a47:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80106a4b:	0f 84 3e 01 00 00    	je     80106b8f <trap+0x5bf>
                for (int j = 0; j < cnt[2]; j++) {
80106a51:	83 c0 01             	add    $0x1,%eax
80106a54:	39 f0                	cmp    %esi,%eax
80106a56:	75 e8                	jne    80106a40 <trap+0x470>
80106a58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
80106a5b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                for (int j = 0; j < cnt[3]; j++) {
80106a62:	8b 35 28 c6 10 80    	mov    0x8010c628,%esi
80106a68:	85 f6                	test   %esi,%esi
80106a6a:	0f 8e ab 04 00 00    	jle    80106f1b <trap+0x94b>
                    if (q3[j]->state == RUNNABLE) {
80106a70:	a1 80 b0 18 80       	mov    0x8018b080,%eax
80106a75:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80106a79:	0f 84 06 01 00 00    	je     80106b85 <trap+0x5b5>
                for (int j = 0; j < cnt[3]; j++) {
80106a7f:	31 c0                	xor    %eax,%eax
80106a81:	89 55 e0             	mov    %edx,-0x20(%ebp)
80106a84:	eb 1b                	jmp    80106aa1 <trap+0x4d1>
80106a86:	8d 76 00             	lea    0x0(%esi),%esi
80106a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    if (q3[j]->state == RUNNABLE) {
80106a90:	8b 14 85 80 b0 18 80 	mov    -0x7fe74f80(,%eax,4),%edx
80106a97:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80106a9b:	0f 84 e1 00 00 00    	je     80106b82 <trap+0x5b2>
                for (int j = 0; j < cnt[3]; j++) {
80106aa1:	83 c0 01             	add    $0x1,%eax
80106aa4:	39 c6                	cmp    %eax,%esi
80106aa6:	75 e8                	jne    80106a90 <trap+0x4c0>
80106aa8:	8b 55 e0             	mov    -0x20(%ebp),%edx
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
80106aab:	31 c0                	xor    %eax,%eax
                if (no == 1) {
80106aad:	83 fb 01             	cmp    $0x1,%ebx
80106ab0:	0f 84 fc 00 00 00    	je     80106bb2 <trap+0x5e2>
                } else if (no == 2) {
80106ab6:	83 fb 02             	cmp    $0x2,%ebx
80106ab9:	0f 84 18 04 00 00    	je     80106ed7 <trap+0x907>
                } else if (no == 3) {
80106abf:	83 fb 03             	cmp    $0x3,%ebx
80106ac2:	0f 84 26 04 00 00    	je     80106eee <trap+0x91e>
                } else if (no == 4) {
80106ac8:	83 fb 04             	cmp    $0x4,%ebx
80106acb:	0f 85 d7 fb ff ff    	jne    801066a8 <trap+0xd8>
                    if (flag0 == 1 || flag1 == 1 || flag2 == 1 || flag3 == 1) {
80106ad1:	09 d1                	or     %edx,%ecx
80106ad3:	0f 85 4a fd ff ff    	jne    80106823 <trap+0x253>
80106ad9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106adc:	09 c1                	or     %eax,%ecx
80106ade:	0f 85 3f fd ff ff    	jne    80106823 <trap+0x253>
80106ae4:	e9 bf fb ff ff       	jmp    801066a8 <trap+0xd8>
80106ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                        myproc()->rtime++;
80106af0:	e8 2b cf ff ff       	call   80103a20 <myproc>
80106af5:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
                        myproc()->stat.runtime++;
80106afc:	e8 1f cf ff ff       	call   80103a20 <myproc>
80106b01:	83 80 b0 00 00 00 01 	addl   $0x1,0xb0(%eax)
                        int no = myproc()->qno;
80106b08:	e8 13 cf ff ff       	call   80103a20 <myproc>
80106b0d:	8b 98 90 00 00 00    	mov    0x90(%eax),%ebx
                        myproc()->rrtime[no]++;
80106b13:	e8 08 cf ff ff       	call   80103a20 <myproc>
80106b18:	c1 e3 02             	shl    $0x2,%ebx
80106b1b:	83 84 18 98 00 00 00 	addl   $0x1,0x98(%eax,%ebx,1)
80106b22:	01 
                        myproc()->stat.ticks[no]++;
80106b23:	e8 f8 ce ff ff       	call   80103a20 <myproc>
80106b28:	83 84 18 bc 00 00 00 	addl   $0x1,0xbc(%eax,%ebx,1)
80106b2f:	01 
80106b30:	e9 08 fd ff ff       	jmp    8010683d <trap+0x26d>
                        ticks, myproc()->pid, myproc()->rtime);
80106b35:	e8 e6 ce ff ff       	call   80103a20 <myproc>
                    cprintf(
80106b3a:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
                        ticks, myproc()->pid, myproc()->rtime);
80106b40:	e8 db ce ff ff       	call   80103a20 <myproc>
                    cprintf(
80106b45:	53                   	push   %ebx
80106b46:	ff 70 10             	pushl  0x10(%eax)
80106b49:	ff 35 80 2b 19 80    	pushl  0x80192b80
80106b4f:	68 9c 8f 10 80       	push   $0x80108f9c
80106b54:	e8 07 9b ff ff       	call   80100660 <cprintf>
                    cnt[1]++;
80106b59:	8b 1d 20 c6 10 80    	mov    0x8010c620,%ebx
80106b5f:	8d 43 01             	lea    0x1(%ebx),%eax
80106b62:	a3 20 c6 10 80       	mov    %eax,0x8010c620
                    q1[cnt[1] - 1] = myproc();
80106b67:	e8 b4 ce ff ff       	call   80103a20 <myproc>
                    end1 += 1;
80106b6c:	83 05 3c c6 10 80 01 	addl   $0x1,0x8010c63c
                    q1[cnt[1] - 1] = myproc();
80106b73:	89 04 9d 20 c0 18 80 	mov    %eax,-0x7fe73fe0(,%ebx,4)
                    end1 += 1;
80106b7a:	83 c4 10             	add    $0x10,%esp
80106b7d:	e9 a1 fc ff ff       	jmp    80106823 <trap+0x253>
80106b82:	8b 55 e0             	mov    -0x20(%ebp),%edx
                        flag3 = 1;
80106b85:	b8 01 00 00 00       	mov    $0x1,%eax
80106b8a:	e9 1e ff ff ff       	jmp    80106aad <trap+0x4dd>
80106b8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
                        flag2 = 1;
80106b92:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
80106b99:	e9 c4 fe ff ff       	jmp    80106a62 <trap+0x492>
                        flag1 = 1;
80106b9e:	ba 01 00 00 00       	mov    $0x1,%edx
80106ba3:	e9 72 fe ff ff       	jmp    80106a1a <trap+0x44a>
                        flag0 = 1;
80106ba8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106bad:	e9 28 fe ff ff       	jmp    801069da <trap+0x40a>
                    if (flag0 == 1) {
80106bb2:	83 f9 01             	cmp    $0x1,%ecx
80106bb5:	0f 85 ed fa ff ff    	jne    801066a8 <trap+0xd8>
80106bbb:	e9 63 fc ff ff       	jmp    80106823 <trap+0x253>
            } else if (no == 1 && myproc()->rrtime[1] % 2 == 0) {
80106bc0:	e8 5b ce ff ff       	call   80103a20 <myproc>
80106bc5:	f6 80 9c 00 00 00 01 	testb  $0x1,0x9c(%eax)
80106bcc:	0f 85 c7 fd ff ff    	jne    80106999 <trap+0x3c9>
                for (int i = 0; i < cnt[1]; i++) {
80106bd2:	83 3d 20 c6 10 80 00 	cmpl   $0x0,0x8010c620
80106bd9:	0f 8e 35 03 00 00    	jle    80106f14 <trap+0x944>
80106bdf:	31 db                	xor    %ebx,%ebx
80106be1:	eb 0f                	jmp    80106bf2 <trap+0x622>
80106be3:	83 c3 01             	add    $0x1,%ebx
80106be6:	39 1d 20 c6 10 80    	cmp    %ebx,0x8010c620
80106bec:	0f 8e 22 03 00 00    	jle    80106f14 <trap+0x944>
                    if (q1[i] == myproc()) {
80106bf2:	8b 34 9d 20 c0 18 80 	mov    -0x7fe73fe0(,%ebx,4),%esi
80106bf9:	e8 22 ce ff ff       	call   80103a20 <myproc>
80106bfe:	39 c6                	cmp    %eax,%esi
80106c00:	75 e1                	jne    80106be3 <trap+0x613>
                myproc()->rrtime[1] = 0;
80106c02:	e8 19 ce ff ff       	call   80103a20 <myproc>
80106c07:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%eax)
80106c0e:	00 00 00 
                myproc()->rrtime[2] = 0;
80106c11:	e8 0a ce ff ff       	call   80103a20 <myproc>
80106c16:	c7 80 a0 00 00 00 00 	movl   $0x0,0xa0(%eax)
80106c1d:	00 00 00 
                myproc()->qno = 2;
80106c20:	e8 fb cd ff ff       	call   80103a20 <myproc>
80106c25:	c7 80 90 00 00 00 02 	movl   $0x2,0x90(%eax)
80106c2c:	00 00 00 
                cnt[1]--;
80106c2f:	8b 15 20 c6 10 80    	mov    0x8010c620,%edx
80106c35:	8d 42 ff             	lea    -0x1(%edx),%eax
                for (int i = ind; i < cnt[1]; i++) {
80106c38:	39 d8                	cmp    %ebx,%eax
                cnt[1]--;
80106c3a:	a3 20 c6 10 80       	mov    %eax,0x8010c620
                for (int i = ind; i < cnt[1]; i++) {
80106c3f:	7e 1b                	jle    80106c5c <trap+0x68c>
80106c41:	8d 04 9d 20 c0 18 80 	lea    -0x7fe73fe0(,%ebx,4),%eax
80106c48:	8d 0c 95 1c c0 18 80 	lea    -0x7fe73fe4(,%edx,4),%ecx
                    q1[i] = q1[i + 1];
80106c4f:	8b 50 04             	mov    0x4(%eax),%edx
80106c52:	83 c0 04             	add    $0x4,%eax
80106c55:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = ind; i < cnt[1]; i++) {
80106c58:	39 c1                	cmp    %eax,%ecx
80106c5a:	75 f3                	jne    80106c4f <trap+0x67f>
                for (int i = 0; i < cnt[2]; i++) {
80106c5c:	83 3d 24 c6 10 80 00 	cmpl   $0x0,0x8010c624
80106c63:	0f 8e b9 02 00 00    	jle    80106f22 <trap+0x952>
80106c69:	31 db                	xor    %ebx,%ebx
80106c6b:	eb 0f                	jmp    80106c7c <trap+0x6ac>
80106c6d:	83 c3 01             	add    $0x1,%ebx
80106c70:	39 1d 24 c6 10 80    	cmp    %ebx,0x8010c624
80106c76:	0f 8e a6 02 00 00    	jle    80106f22 <trap+0x952>
                    if (q2[i]->pid == myproc()->pid) {
80106c7c:	8b 04 9d c0 a0 18 80 	mov    -0x7fe75f40(,%ebx,4),%eax
80106c83:	8b 70 10             	mov    0x10(%eax),%esi
80106c86:	e8 95 cd ff ff       	call   80103a20 <myproc>
80106c8b:	3b 70 10             	cmp    0x10(%eax),%esi
80106c8e:	75 dd                	jne    80106c6d <trap+0x69d>
80106c90:	e9 8e fb ff ff       	jmp    80106823 <trap+0x253>
            } else if (no == 2 && myproc()->rrtime[2] % 4 == 0) {
80106c95:	e8 86 cd ff ff       	call   80103a20 <myproc>
80106c9a:	f6 80 a0 00 00 00 03 	testb  $0x3,0xa0(%eax)
80106ca1:	0f 85 f2 fc ff ff    	jne    80106999 <trap+0x3c9>
                for (int i = 0; i < cnt[2]; i++) {
80106ca7:	83 3d 24 c6 10 80 00 	cmpl   $0x0,0x8010c624
80106cae:	0f 8e 59 02 00 00    	jle    80106f0d <trap+0x93d>
80106cb4:	31 db                	xor    %ebx,%ebx
80106cb6:	eb 0f                	jmp    80106cc7 <trap+0x6f7>
80106cb8:	83 c3 01             	add    $0x1,%ebx
80106cbb:	39 1d 24 c6 10 80    	cmp    %ebx,0x8010c624
80106cc1:	0f 8e 46 02 00 00    	jle    80106f0d <trap+0x93d>
                    if (q2[i] == myproc()) {
80106cc7:	8b 34 9d c0 a0 18 80 	mov    -0x7fe75f40(,%ebx,4),%esi
80106cce:	e8 4d cd ff ff       	call   80103a20 <myproc>
80106cd3:	39 c6                	cmp    %eax,%esi
80106cd5:	75 e1                	jne    80106cb8 <trap+0x6e8>
                myproc()->rrtime[2] = 0;
80106cd7:	e8 44 cd ff ff       	call   80103a20 <myproc>
80106cdc:	c7 80 a0 00 00 00 00 	movl   $0x0,0xa0(%eax)
80106ce3:	00 00 00 
                myproc()->rrtime[3] = 0;
80106ce6:	e8 35 cd ff ff       	call   80103a20 <myproc>
80106ceb:	c7 80 a4 00 00 00 00 	movl   $0x0,0xa4(%eax)
80106cf2:	00 00 00 
                myproc()->qno = 3;
80106cf5:	e8 26 cd ff ff       	call   80103a20 <myproc>
80106cfa:	c7 80 90 00 00 00 03 	movl   $0x3,0x90(%eax)
80106d01:	00 00 00 
                cnt[2]--;
80106d04:	8b 15 24 c6 10 80    	mov    0x8010c624,%edx
80106d0a:	8d 42 ff             	lea    -0x1(%edx),%eax
                for (int i = ind; i < cnt[2]; i++) {
80106d0d:	39 d8                	cmp    %ebx,%eax
                cnt[2]--;
80106d0f:	a3 24 c6 10 80       	mov    %eax,0x8010c624
                for (int i = ind; i < cnt[2]; i++) {
80106d14:	7e 1b                	jle    80106d31 <trap+0x761>
80106d16:	8d 04 9d c0 a0 18 80 	lea    -0x7fe75f40(,%ebx,4),%eax
80106d1d:	8d 0c 95 bc a0 18 80 	lea    -0x7fe75f44(,%edx,4),%ecx
                    q2[i] = q2[i + 1];
80106d24:	8b 50 04             	mov    0x4(%eax),%edx
80106d27:	83 c0 04             	add    $0x4,%eax
80106d2a:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = ind; i < cnt[2]; i++) {
80106d2d:	39 c8                	cmp    %ecx,%eax
80106d2f:	75 f3                	jne    80106d24 <trap+0x754>
                for (int i = 0; i < cnt[3]; i++) {
80106d31:	83 3d 28 c6 10 80 00 	cmpl   $0x0,0x8010c628
80106d38:	0f 8e 31 02 00 00    	jle    80106f6f <trap+0x99f>
80106d3e:	31 db                	xor    %ebx,%ebx
80106d40:	eb 0f                	jmp    80106d51 <trap+0x781>
80106d42:	83 c3 01             	add    $0x1,%ebx
80106d45:	39 1d 28 c6 10 80    	cmp    %ebx,0x8010c628
80106d4b:	0f 8e 1e 02 00 00    	jle    80106f6f <trap+0x99f>
                    if (q3[i]->pid == myproc()->pid) {
80106d51:	8b 04 9d 80 b0 18 80 	mov    -0x7fe74f80(,%ebx,4),%eax
80106d58:	8b 70 10             	mov    0x10(%eax),%esi
80106d5b:	e8 c0 cc ff ff       	call   80103a20 <myproc>
80106d60:	3b 70 10             	cmp    0x10(%eax),%esi
80106d63:	75 dd                	jne    80106d42 <trap+0x772>
80106d65:	e9 b9 fa ff ff       	jmp    80106823 <trap+0x253>
            } else if (no == 3 && myproc()->rrtime[3] % 8 == 0) {
80106d6a:	e8 b1 cc ff ff       	call   80103a20 <myproc>
80106d6f:	f6 80 a4 00 00 00 07 	testb  $0x7,0xa4(%eax)
80106d76:	0f 85 1d fc ff ff    	jne    80106999 <trap+0x3c9>
                for (int i = 0; i < cnt[3]; i++) {
80106d7c:	83 3d 28 c6 10 80 00 	cmpl   $0x0,0x8010c628
80106d83:	0f 8e 33 02 00 00    	jle    80106fbc <trap+0x9ec>
80106d89:	31 db                	xor    %ebx,%ebx
80106d8b:	eb 0f                	jmp    80106d9c <trap+0x7cc>
80106d8d:	83 c3 01             	add    $0x1,%ebx
80106d90:	39 1d 28 c6 10 80    	cmp    %ebx,0x8010c628
80106d96:	0f 8e 20 02 00 00    	jle    80106fbc <trap+0x9ec>
                    if (q3[i] == myproc()) {
80106d9c:	8b 34 9d 80 b0 18 80 	mov    -0x7fe74f80(,%ebx,4),%esi
80106da3:	e8 78 cc ff ff       	call   80103a20 <myproc>
80106da8:	39 c6                	cmp    %eax,%esi
80106daa:	75 e1                	jne    80106d8d <trap+0x7bd>
                myproc()->rrtime[3] = 0;
80106dac:	e8 6f cc ff ff       	call   80103a20 <myproc>
80106db1:	c7 80 a4 00 00 00 00 	movl   $0x0,0xa4(%eax)
80106db8:	00 00 00 
                myproc()->rrtime[4] = 0;
80106dbb:	e8 60 cc ff ff       	call   80103a20 <myproc>
80106dc0:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
80106dc7:	00 00 00 
                myproc()->qno = 4;
80106dca:	e8 51 cc ff ff       	call   80103a20 <myproc>
80106dcf:	c7 80 90 00 00 00 04 	movl   $0x4,0x90(%eax)
80106dd6:	00 00 00 
                cnt[3]--;
80106dd9:	8b 15 28 c6 10 80    	mov    0x8010c628,%edx
80106ddf:	8d 42 ff             	lea    -0x1(%edx),%eax
                for (int i = ind; i < cnt[3]; i++) {
80106de2:	39 d8                	cmp    %ebx,%eax
                cnt[3]--;
80106de4:	a3 28 c6 10 80       	mov    %eax,0x8010c628
                for (int i = ind; i < cnt[3]; i++) {
80106de9:	7e 1b                	jle    80106e06 <trap+0x836>
80106deb:	8d 04 9d 80 b0 18 80 	lea    -0x7fe74f80(,%ebx,4),%eax
80106df2:	8d 0c 95 7c b0 18 80 	lea    -0x7fe74f84(,%edx,4),%ecx
                    q3[i] = q3[i + 1];
80106df9:	8b 50 04             	mov    0x4(%eax),%edx
80106dfc:	83 c0 04             	add    $0x4,%eax
80106dff:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = ind; i < cnt[3]; i++) {
80106e02:	39 c8                	cmp    %ecx,%eax
80106e04:	75 f3                	jne    80106df9 <trap+0x829>
                for (int i = 0; i < cnt[4]; i++) {
80106e06:	83 3d 2c c6 10 80 00 	cmpl   $0x0,0x8010c62c
80106e0d:	0f 8e b0 01 00 00    	jle    80106fc3 <trap+0x9f3>
80106e13:	31 db                	xor    %ebx,%ebx
80106e15:	eb 0f                	jmp    80106e26 <trap+0x856>
80106e17:	83 c3 01             	add    $0x1,%ebx
80106e1a:	39 1d 2c c6 10 80    	cmp    %ebx,0x8010c62c
80106e20:	0f 8e 9d 01 00 00    	jle    80106fc3 <trap+0x9f3>
                    if (q4[i]->pid == myproc()->pid) {
80106e26:	8b 04 9d a0 13 19 80 	mov    -0x7fe6ec60(,%ebx,4),%eax
80106e2d:	8b 70 10             	mov    0x10(%eax),%esi
80106e30:	e8 eb cb ff ff       	call   80103a20 <myproc>
80106e35:	3b 70 10             	cmp    0x10(%eax),%esi
80106e38:	75 dd                	jne    80106e17 <trap+0x847>
80106e3a:	e9 e4 f9 ff ff       	jmp    80106823 <trap+0x253>
            } else if (no == 4 && myproc()->rrtime[4] % 16 == 0) {
80106e3f:	e8 dc cb ff ff       	call   80103a20 <myproc>
80106e44:	f6 80 a8 00 00 00 0f 	testb  $0xf,0xa8(%eax)
80106e4b:	0f 85 48 fb ff ff    	jne    80106999 <trap+0x3c9>
                myproc()->rrtime[4] = 0;
80106e51:	e8 ca cb ff ff       	call   80103a20 <myproc>
80106e56:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
80106e5d:	00 00 00 
                for (int i = 0; i < cnt[4]; i++) {
80106e60:	83 3d 2c c6 10 80 00 	cmpl   $0x0,0x8010c62c
80106e67:	0f 8e a3 01 00 00    	jle    80107010 <trap+0xa40>
80106e6d:	31 db                	xor    %ebx,%ebx
80106e6f:	eb 0f                	jmp    80106e80 <trap+0x8b0>
80106e71:	83 c3 01             	add    $0x1,%ebx
80106e74:	39 1d 2c c6 10 80    	cmp    %ebx,0x8010c62c
80106e7a:	0f 8e 90 01 00 00    	jle    80107010 <trap+0xa40>
                    if (q4[i] == myproc()) {
80106e80:	8b 34 9d a0 13 19 80 	mov    -0x7fe6ec60(,%ebx,4),%esi
80106e87:	e8 94 cb ff ff       	call   80103a20 <myproc>
80106e8c:	39 c6                	cmp    %eax,%esi
80106e8e:	75 e1                	jne    80106e71 <trap+0x8a1>
                q4[cnt[4]] = myproc();
80106e90:	8b 35 2c c6 10 80    	mov    0x8010c62c,%esi
80106e96:	e8 85 cb ff ff       	call   80103a20 <myproc>
                for (int i = ind; i < cnt[4]; i++) {
80106e9b:	8b 15 2c c6 10 80    	mov    0x8010c62c,%edx
                end4 += 1;
80106ea1:	83 05 30 c6 10 80 01 	addl   $0x1,0x8010c630
                q4[cnt[4]] = myproc();
80106ea8:	89 04 b5 a0 13 19 80 	mov    %eax,-0x7fe6ec60(,%esi,4)
                for (int i = ind; i < cnt[4]; i++) {
80106eaf:	39 d3                	cmp    %edx,%ebx
80106eb1:	0f 8d 6c f9 ff ff    	jge    80106823 <trap+0x253>
80106eb7:	8d 04 9d a0 13 19 80 	lea    -0x7fe6ec60(,%ebx,4),%eax
80106ebe:	8d 0c 95 a0 13 19 80 	lea    -0x7fe6ec60(,%edx,4),%ecx
                    q4[i] = q4[i + 1];
80106ec5:	8b 50 04             	mov    0x4(%eax),%edx
80106ec8:	83 c0 04             	add    $0x4,%eax
80106ecb:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = ind; i < cnt[4]; i++) {
80106ece:	39 c1                	cmp    %eax,%ecx
80106ed0:	75 f3                	jne    80106ec5 <trap+0x8f5>
80106ed2:	e9 4c f9 ff ff       	jmp    80106823 <trap+0x253>
                    if (flag0 == 1 || flag1 == 1) {
80106ed7:	09 d1                	or     %edx,%ecx
80106ed9:	0f 84 c9 f7 ff ff    	je     801066a8 <trap+0xd8>
80106edf:	e9 3f f9 ff ff       	jmp    80106823 <trap+0x253>
                int ind = -1;
80106ee4:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80106ee9:	e9 9a f8 ff ff       	jmp    80106788 <trap+0x1b8>
                    if (flag0 == 1 || flag1 == 1 || flag2 == 1) {
80106eee:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80106ef2:	09 d1                	or     %edx,%ecx
80106ef4:	08 c8                	or     %cl,%al
80106ef6:	0f 85 27 f9 ff ff    	jne    80106823 <trap+0x253>
80106efc:	e9 a7 f7 ff ff       	jmp    801066a8 <trap+0xd8>
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
80106f01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106f08:	e9 55 fb ff ff       	jmp    80106a62 <trap+0x492>
                int ind = 0;
80106f0d:	31 db                	xor    %ebx,%ebx
80106f0f:	e9 c3 fd ff ff       	jmp    80106cd7 <trap+0x707>
                int ind = 0;
80106f14:	31 db                	xor    %ebx,%ebx
80106f16:	e9 e7 fc ff ff       	jmp    80106c02 <trap+0x632>
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
80106f1b:	31 c0                	xor    %eax,%eax
80106f1d:	e9 8b fb ff ff       	jmp    80106aad <trap+0x4dd>
                        ticks, myproc()->pid, myproc()->rtime);
80106f22:	e8 f9 ca ff ff       	call   80103a20 <myproc>
                    cprintf(
80106f27:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
                        ticks, myproc()->pid, myproc()->rtime);
80106f2d:	e8 ee ca ff ff       	call   80103a20 <myproc>
                    cprintf(
80106f32:	53                   	push   %ebx
80106f33:	ff 70 10             	pushl  0x10(%eax)
80106f36:	ff 35 80 2b 19 80    	pushl  0x80192b80
80106f3c:	68 9c 8f 10 80       	push   $0x80108f9c
80106f41:	e8 1a 97 ff ff       	call   80100660 <cprintf>
                    cnt[2]++;
80106f46:	8b 1d 24 c6 10 80    	mov    0x8010c624,%ebx
80106f4c:	8d 43 01             	lea    0x1(%ebx),%eax
80106f4f:	a3 24 c6 10 80       	mov    %eax,0x8010c624
                    q2[cnt[2] - 1] = myproc();
80106f54:	e8 c7 ca ff ff       	call   80103a20 <myproc>
                    end2 += 1;
80106f59:	83 05 38 c6 10 80 01 	addl   $0x1,0x8010c638
                    q2[cnt[2] - 1] = myproc();
80106f60:	89 04 9d c0 a0 18 80 	mov    %eax,-0x7fe75f40(,%ebx,4)
                    end2 += 1;
80106f67:	83 c4 10             	add    $0x10,%esp
80106f6a:	e9 b4 f8 ff ff       	jmp    80106823 <trap+0x253>
                        ticks, myproc()->pid, myproc()->rtime);
80106f6f:	e8 ac ca ff ff       	call   80103a20 <myproc>
                    cprintf(
80106f74:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
                        ticks, myproc()->pid, myproc()->rtime);
80106f7a:	e8 a1 ca ff ff       	call   80103a20 <myproc>
                    cprintf(
80106f7f:	53                   	push   %ebx
80106f80:	ff 70 10             	pushl  0x10(%eax)
80106f83:	ff 35 80 2b 19 80    	pushl  0x80192b80
80106f89:	68 9c 8f 10 80       	push   $0x80108f9c
80106f8e:	e8 cd 96 ff ff       	call   80100660 <cprintf>
                    cnt[3]++;
80106f93:	8b 1d 28 c6 10 80    	mov    0x8010c628,%ebx
80106f99:	8d 43 01             	lea    0x1(%ebx),%eax
80106f9c:	a3 28 c6 10 80       	mov    %eax,0x8010c628
                    q3[cnt[3] - 1] = myproc();
80106fa1:	e8 7a ca ff ff       	call   80103a20 <myproc>
                    end3 += 1;
80106fa6:	83 05 34 c6 10 80 01 	addl   $0x1,0x8010c634
                    q3[cnt[3] - 1] = myproc();
80106fad:	89 04 9d 80 b0 18 80 	mov    %eax,-0x7fe74f80(,%ebx,4)
                    end3 += 1;
80106fb4:	83 c4 10             	add    $0x10,%esp
80106fb7:	e9 67 f8 ff ff       	jmp    80106823 <trap+0x253>
                int ind = 0;
80106fbc:	31 db                	xor    %ebx,%ebx
80106fbe:	e9 e9 fd ff ff       	jmp    80106dac <trap+0x7dc>
                        ticks, myproc()->pid, myproc()->rtime);
80106fc3:	e8 58 ca ff ff       	call   80103a20 <myproc>
                    cprintf(
80106fc8:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
                        ticks, myproc()->pid, myproc()->rtime);
80106fce:	e8 4d ca ff ff       	call   80103a20 <myproc>
                    cprintf(
80106fd3:	53                   	push   %ebx
80106fd4:	ff 70 10             	pushl  0x10(%eax)
80106fd7:	ff 35 80 2b 19 80    	pushl  0x80192b80
80106fdd:	68 9c 8f 10 80       	push   $0x80108f9c
80106fe2:	e8 79 96 ff ff       	call   80100660 <cprintf>
                    cnt[4]++;
80106fe7:	8b 1d 2c c6 10 80    	mov    0x8010c62c,%ebx
80106fed:	8d 43 01             	lea    0x1(%ebx),%eax
80106ff0:	a3 2c c6 10 80       	mov    %eax,0x8010c62c
                    q4[cnt[4] - 1] = myproc();
80106ff5:	e8 26 ca ff ff       	call   80103a20 <myproc>
                    end4 += 1;
80106ffa:	83 05 30 c6 10 80 01 	addl   $0x1,0x8010c630
                    q4[cnt[4] - 1] = myproc();
80107001:	89 04 9d a0 13 19 80 	mov    %eax,-0x7fe6ec60(,%ebx,4)
                    end4 += 1;
80107008:	83 c4 10             	add    $0x10,%esp
8010700b:	e9 13 f8 ff ff       	jmp    80106823 <trap+0x253>
                int ind = 0;
80107010:	31 db                	xor    %ebx,%ebx
80107012:	e9 79 fe ff ff       	jmp    80106e90 <trap+0x8c0>
80107017:	0f 20 d6             	mov    %cr2,%esi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010701a:	e8 e1 c9 ff ff       	call   80103a00 <cpuid>
8010701f:	83 ec 0c             	sub    $0xc,%esp
80107022:	56                   	push   %esi
80107023:	53                   	push   %ebx
80107024:	50                   	push   %eax
80107025:	ff 77 30             	pushl  0x30(%edi)
80107028:	68 24 8f 10 80       	push   $0x80108f24
8010702d:	e8 2e 96 ff ff       	call   80100660 <cprintf>
                panic("trap");
80107032:	83 c4 14             	add    $0x14,%esp
80107035:	68 fa 8e 10 80       	push   $0x80108efa
8010703a:	e8 51 93 ff ff       	call   80100390 <panic>
8010703f:	90                   	nop

80107040 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80107040:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
{
80107045:	55                   	push   %ebp
80107046:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107048:	85 c0                	test   %eax,%eax
8010704a:	74 1c                	je     80107068 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010704c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107051:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80107052:	a8 01                	test   $0x1,%al
80107054:	74 12                	je     80107068 <uartgetc+0x28>
80107056:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010705b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010705c:	0f b6 c0             	movzbl %al,%eax
}
8010705f:	5d                   	pop    %ebp
80107060:	c3                   	ret    
80107061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010706d:	5d                   	pop    %ebp
8010706e:	c3                   	ret    
8010706f:	90                   	nop

80107070 <uartputc.part.0>:
uartputc(int c)
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	89 c7                	mov    %eax,%edi
80107078:	bb 80 00 00 00       	mov    $0x80,%ebx
8010707d:	be fd 03 00 00       	mov    $0x3fd,%esi
80107082:	83 ec 0c             	sub    $0xc,%esp
80107085:	eb 1b                	jmp    801070a2 <uartputc.part.0+0x32>
80107087:	89 f6                	mov    %esi,%esi
80107089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80107090:	83 ec 0c             	sub    $0xc,%esp
80107093:	6a 0a                	push   $0xa
80107095:	e8 d6 b6 ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010709a:	83 c4 10             	add    $0x10,%esp
8010709d:	83 eb 01             	sub    $0x1,%ebx
801070a0:	74 07                	je     801070a9 <uartputc.part.0+0x39>
801070a2:	89 f2                	mov    %esi,%edx
801070a4:	ec                   	in     (%dx),%al
801070a5:	a8 20                	test   $0x20,%al
801070a7:	74 e7                	je     80107090 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801070a9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801070ae:	89 f8                	mov    %edi,%eax
801070b0:	ee                   	out    %al,(%dx)
}
801070b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070b4:	5b                   	pop    %ebx
801070b5:	5e                   	pop    %esi
801070b6:	5f                   	pop    %edi
801070b7:	5d                   	pop    %ebp
801070b8:	c3                   	ret    
801070b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070c0 <uartinit>:
{
801070c0:	55                   	push   %ebp
801070c1:	31 c9                	xor    %ecx,%ecx
801070c3:	89 c8                	mov    %ecx,%eax
801070c5:	89 e5                	mov    %esp,%ebp
801070c7:	57                   	push   %edi
801070c8:	56                   	push   %esi
801070c9:	53                   	push   %ebx
801070ca:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801070cf:	89 da                	mov    %ebx,%edx
801070d1:	83 ec 0c             	sub    $0xc,%esp
801070d4:	ee                   	out    %al,(%dx)
801070d5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801070da:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801070df:	89 fa                	mov    %edi,%edx
801070e1:	ee                   	out    %al,(%dx)
801070e2:	b8 0c 00 00 00       	mov    $0xc,%eax
801070e7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801070ec:	ee                   	out    %al,(%dx)
801070ed:	be f9 03 00 00       	mov    $0x3f9,%esi
801070f2:	89 c8                	mov    %ecx,%eax
801070f4:	89 f2                	mov    %esi,%edx
801070f6:	ee                   	out    %al,(%dx)
801070f7:	b8 03 00 00 00       	mov    $0x3,%eax
801070fc:	89 fa                	mov    %edi,%edx
801070fe:	ee                   	out    %al,(%dx)
801070ff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107104:	89 c8                	mov    %ecx,%eax
80107106:	ee                   	out    %al,(%dx)
80107107:	b8 01 00 00 00       	mov    $0x1,%eax
8010710c:	89 f2                	mov    %esi,%edx
8010710e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010710f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107114:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107115:	3c ff                	cmp    $0xff,%al
80107117:	74 5a                	je     80107173 <uartinit+0xb3>
  uart = 1;
80107119:	c7 05 5c c6 10 80 01 	movl   $0x1,0x8010c65c
80107120:	00 00 00 
80107123:	89 da                	mov    %ebx,%edx
80107125:	ec                   	in     (%dx),%al
80107126:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010712b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010712c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010712f:	bb 54 90 10 80       	mov    $0x80109054,%ebx
  ioapicenable(IRQ_COM1, 0);
80107134:	6a 00                	push   $0x0
80107136:	6a 04                	push   $0x4
80107138:	e8 93 b1 ff ff       	call   801022d0 <ioapicenable>
8010713d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80107140:	b8 78 00 00 00       	mov    $0x78,%eax
80107145:	eb 13                	jmp    8010715a <uartinit+0x9a>
80107147:	89 f6                	mov    %esi,%esi
80107149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107150:	83 c3 01             	add    $0x1,%ebx
80107153:	0f be 03             	movsbl (%ebx),%eax
80107156:	84 c0                	test   %al,%al
80107158:	74 19                	je     80107173 <uartinit+0xb3>
  if(!uart)
8010715a:	8b 15 5c c6 10 80    	mov    0x8010c65c,%edx
80107160:	85 d2                	test   %edx,%edx
80107162:	74 ec                	je     80107150 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80107164:	83 c3 01             	add    $0x1,%ebx
80107167:	e8 04 ff ff ff       	call   80107070 <uartputc.part.0>
8010716c:	0f be 03             	movsbl (%ebx),%eax
8010716f:	84 c0                	test   %al,%al
80107171:	75 e7                	jne    8010715a <uartinit+0x9a>
}
80107173:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107176:	5b                   	pop    %ebx
80107177:	5e                   	pop    %esi
80107178:	5f                   	pop    %edi
80107179:	5d                   	pop    %ebp
8010717a:	c3                   	ret    
8010717b:	90                   	nop
8010717c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107180 <uartputc>:
  if(!uart)
80107180:	8b 15 5c c6 10 80    	mov    0x8010c65c,%edx
{
80107186:	55                   	push   %ebp
80107187:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107189:	85 d2                	test   %edx,%edx
{
8010718b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010718e:	74 10                	je     801071a0 <uartputc+0x20>
}
80107190:	5d                   	pop    %ebp
80107191:	e9 da fe ff ff       	jmp    80107070 <uartputc.part.0>
80107196:	8d 76 00             	lea    0x0(%esi),%esi
80107199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801071a0:	5d                   	pop    %ebp
801071a1:	c3                   	ret    
801071a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071b0 <uartintr>:

void
uartintr(void)
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801071b6:	68 40 70 10 80       	push   $0x80107040
801071bb:	e8 50 96 ff ff       	call   80100810 <consoleintr>
}
801071c0:	83 c4 10             	add    $0x10,%esp
801071c3:	c9                   	leave  
801071c4:	c3                   	ret    

801071c5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801071c5:	6a 00                	push   $0x0
  pushl $0
801071c7:	6a 00                	push   $0x0
  jmp alltraps
801071c9:	e9 2c f3 ff ff       	jmp    801064fa <alltraps>

801071ce <vector1>:
.globl vector1
vector1:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $1
801071d0:	6a 01                	push   $0x1
  jmp alltraps
801071d2:	e9 23 f3 ff ff       	jmp    801064fa <alltraps>

801071d7 <vector2>:
.globl vector2
vector2:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $2
801071d9:	6a 02                	push   $0x2
  jmp alltraps
801071db:	e9 1a f3 ff ff       	jmp    801064fa <alltraps>

801071e0 <vector3>:
.globl vector3
vector3:
  pushl $0
801071e0:	6a 00                	push   $0x0
  pushl $3
801071e2:	6a 03                	push   $0x3
  jmp alltraps
801071e4:	e9 11 f3 ff ff       	jmp    801064fa <alltraps>

801071e9 <vector4>:
.globl vector4
vector4:
  pushl $0
801071e9:	6a 00                	push   $0x0
  pushl $4
801071eb:	6a 04                	push   $0x4
  jmp alltraps
801071ed:	e9 08 f3 ff ff       	jmp    801064fa <alltraps>

801071f2 <vector5>:
.globl vector5
vector5:
  pushl $0
801071f2:	6a 00                	push   $0x0
  pushl $5
801071f4:	6a 05                	push   $0x5
  jmp alltraps
801071f6:	e9 ff f2 ff ff       	jmp    801064fa <alltraps>

801071fb <vector6>:
.globl vector6
vector6:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $6
801071fd:	6a 06                	push   $0x6
  jmp alltraps
801071ff:	e9 f6 f2 ff ff       	jmp    801064fa <alltraps>

80107204 <vector7>:
.globl vector7
vector7:
  pushl $0
80107204:	6a 00                	push   $0x0
  pushl $7
80107206:	6a 07                	push   $0x7
  jmp alltraps
80107208:	e9 ed f2 ff ff       	jmp    801064fa <alltraps>

8010720d <vector8>:
.globl vector8
vector8:
  pushl $8
8010720d:	6a 08                	push   $0x8
  jmp alltraps
8010720f:	e9 e6 f2 ff ff       	jmp    801064fa <alltraps>

80107214 <vector9>:
.globl vector9
vector9:
  pushl $0
80107214:	6a 00                	push   $0x0
  pushl $9
80107216:	6a 09                	push   $0x9
  jmp alltraps
80107218:	e9 dd f2 ff ff       	jmp    801064fa <alltraps>

8010721d <vector10>:
.globl vector10
vector10:
  pushl $10
8010721d:	6a 0a                	push   $0xa
  jmp alltraps
8010721f:	e9 d6 f2 ff ff       	jmp    801064fa <alltraps>

80107224 <vector11>:
.globl vector11
vector11:
  pushl $11
80107224:	6a 0b                	push   $0xb
  jmp alltraps
80107226:	e9 cf f2 ff ff       	jmp    801064fa <alltraps>

8010722b <vector12>:
.globl vector12
vector12:
  pushl $12
8010722b:	6a 0c                	push   $0xc
  jmp alltraps
8010722d:	e9 c8 f2 ff ff       	jmp    801064fa <alltraps>

80107232 <vector13>:
.globl vector13
vector13:
  pushl $13
80107232:	6a 0d                	push   $0xd
  jmp alltraps
80107234:	e9 c1 f2 ff ff       	jmp    801064fa <alltraps>

80107239 <vector14>:
.globl vector14
vector14:
  pushl $14
80107239:	6a 0e                	push   $0xe
  jmp alltraps
8010723b:	e9 ba f2 ff ff       	jmp    801064fa <alltraps>

80107240 <vector15>:
.globl vector15
vector15:
  pushl $0
80107240:	6a 00                	push   $0x0
  pushl $15
80107242:	6a 0f                	push   $0xf
  jmp alltraps
80107244:	e9 b1 f2 ff ff       	jmp    801064fa <alltraps>

80107249 <vector16>:
.globl vector16
vector16:
  pushl $0
80107249:	6a 00                	push   $0x0
  pushl $16
8010724b:	6a 10                	push   $0x10
  jmp alltraps
8010724d:	e9 a8 f2 ff ff       	jmp    801064fa <alltraps>

80107252 <vector17>:
.globl vector17
vector17:
  pushl $17
80107252:	6a 11                	push   $0x11
  jmp alltraps
80107254:	e9 a1 f2 ff ff       	jmp    801064fa <alltraps>

80107259 <vector18>:
.globl vector18
vector18:
  pushl $0
80107259:	6a 00                	push   $0x0
  pushl $18
8010725b:	6a 12                	push   $0x12
  jmp alltraps
8010725d:	e9 98 f2 ff ff       	jmp    801064fa <alltraps>

80107262 <vector19>:
.globl vector19
vector19:
  pushl $0
80107262:	6a 00                	push   $0x0
  pushl $19
80107264:	6a 13                	push   $0x13
  jmp alltraps
80107266:	e9 8f f2 ff ff       	jmp    801064fa <alltraps>

8010726b <vector20>:
.globl vector20
vector20:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $20
8010726d:	6a 14                	push   $0x14
  jmp alltraps
8010726f:	e9 86 f2 ff ff       	jmp    801064fa <alltraps>

80107274 <vector21>:
.globl vector21
vector21:
  pushl $0
80107274:	6a 00                	push   $0x0
  pushl $21
80107276:	6a 15                	push   $0x15
  jmp alltraps
80107278:	e9 7d f2 ff ff       	jmp    801064fa <alltraps>

8010727d <vector22>:
.globl vector22
vector22:
  pushl $0
8010727d:	6a 00                	push   $0x0
  pushl $22
8010727f:	6a 16                	push   $0x16
  jmp alltraps
80107281:	e9 74 f2 ff ff       	jmp    801064fa <alltraps>

80107286 <vector23>:
.globl vector23
vector23:
  pushl $0
80107286:	6a 00                	push   $0x0
  pushl $23
80107288:	6a 17                	push   $0x17
  jmp alltraps
8010728a:	e9 6b f2 ff ff       	jmp    801064fa <alltraps>

8010728f <vector24>:
.globl vector24
vector24:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $24
80107291:	6a 18                	push   $0x18
  jmp alltraps
80107293:	e9 62 f2 ff ff       	jmp    801064fa <alltraps>

80107298 <vector25>:
.globl vector25
vector25:
  pushl $0
80107298:	6a 00                	push   $0x0
  pushl $25
8010729a:	6a 19                	push   $0x19
  jmp alltraps
8010729c:	e9 59 f2 ff ff       	jmp    801064fa <alltraps>

801072a1 <vector26>:
.globl vector26
vector26:
  pushl $0
801072a1:	6a 00                	push   $0x0
  pushl $26
801072a3:	6a 1a                	push   $0x1a
  jmp alltraps
801072a5:	e9 50 f2 ff ff       	jmp    801064fa <alltraps>

801072aa <vector27>:
.globl vector27
vector27:
  pushl $0
801072aa:	6a 00                	push   $0x0
  pushl $27
801072ac:	6a 1b                	push   $0x1b
  jmp alltraps
801072ae:	e9 47 f2 ff ff       	jmp    801064fa <alltraps>

801072b3 <vector28>:
.globl vector28
vector28:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $28
801072b5:	6a 1c                	push   $0x1c
  jmp alltraps
801072b7:	e9 3e f2 ff ff       	jmp    801064fa <alltraps>

801072bc <vector29>:
.globl vector29
vector29:
  pushl $0
801072bc:	6a 00                	push   $0x0
  pushl $29
801072be:	6a 1d                	push   $0x1d
  jmp alltraps
801072c0:	e9 35 f2 ff ff       	jmp    801064fa <alltraps>

801072c5 <vector30>:
.globl vector30
vector30:
  pushl $0
801072c5:	6a 00                	push   $0x0
  pushl $30
801072c7:	6a 1e                	push   $0x1e
  jmp alltraps
801072c9:	e9 2c f2 ff ff       	jmp    801064fa <alltraps>

801072ce <vector31>:
.globl vector31
vector31:
  pushl $0
801072ce:	6a 00                	push   $0x0
  pushl $31
801072d0:	6a 1f                	push   $0x1f
  jmp alltraps
801072d2:	e9 23 f2 ff ff       	jmp    801064fa <alltraps>

801072d7 <vector32>:
.globl vector32
vector32:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $32
801072d9:	6a 20                	push   $0x20
  jmp alltraps
801072db:	e9 1a f2 ff ff       	jmp    801064fa <alltraps>

801072e0 <vector33>:
.globl vector33
vector33:
  pushl $0
801072e0:	6a 00                	push   $0x0
  pushl $33
801072e2:	6a 21                	push   $0x21
  jmp alltraps
801072e4:	e9 11 f2 ff ff       	jmp    801064fa <alltraps>

801072e9 <vector34>:
.globl vector34
vector34:
  pushl $0
801072e9:	6a 00                	push   $0x0
  pushl $34
801072eb:	6a 22                	push   $0x22
  jmp alltraps
801072ed:	e9 08 f2 ff ff       	jmp    801064fa <alltraps>

801072f2 <vector35>:
.globl vector35
vector35:
  pushl $0
801072f2:	6a 00                	push   $0x0
  pushl $35
801072f4:	6a 23                	push   $0x23
  jmp alltraps
801072f6:	e9 ff f1 ff ff       	jmp    801064fa <alltraps>

801072fb <vector36>:
.globl vector36
vector36:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $36
801072fd:	6a 24                	push   $0x24
  jmp alltraps
801072ff:	e9 f6 f1 ff ff       	jmp    801064fa <alltraps>

80107304 <vector37>:
.globl vector37
vector37:
  pushl $0
80107304:	6a 00                	push   $0x0
  pushl $37
80107306:	6a 25                	push   $0x25
  jmp alltraps
80107308:	e9 ed f1 ff ff       	jmp    801064fa <alltraps>

8010730d <vector38>:
.globl vector38
vector38:
  pushl $0
8010730d:	6a 00                	push   $0x0
  pushl $38
8010730f:	6a 26                	push   $0x26
  jmp alltraps
80107311:	e9 e4 f1 ff ff       	jmp    801064fa <alltraps>

80107316 <vector39>:
.globl vector39
vector39:
  pushl $0
80107316:	6a 00                	push   $0x0
  pushl $39
80107318:	6a 27                	push   $0x27
  jmp alltraps
8010731a:	e9 db f1 ff ff       	jmp    801064fa <alltraps>

8010731f <vector40>:
.globl vector40
vector40:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $40
80107321:	6a 28                	push   $0x28
  jmp alltraps
80107323:	e9 d2 f1 ff ff       	jmp    801064fa <alltraps>

80107328 <vector41>:
.globl vector41
vector41:
  pushl $0
80107328:	6a 00                	push   $0x0
  pushl $41
8010732a:	6a 29                	push   $0x29
  jmp alltraps
8010732c:	e9 c9 f1 ff ff       	jmp    801064fa <alltraps>

80107331 <vector42>:
.globl vector42
vector42:
  pushl $0
80107331:	6a 00                	push   $0x0
  pushl $42
80107333:	6a 2a                	push   $0x2a
  jmp alltraps
80107335:	e9 c0 f1 ff ff       	jmp    801064fa <alltraps>

8010733a <vector43>:
.globl vector43
vector43:
  pushl $0
8010733a:	6a 00                	push   $0x0
  pushl $43
8010733c:	6a 2b                	push   $0x2b
  jmp alltraps
8010733e:	e9 b7 f1 ff ff       	jmp    801064fa <alltraps>

80107343 <vector44>:
.globl vector44
vector44:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $44
80107345:	6a 2c                	push   $0x2c
  jmp alltraps
80107347:	e9 ae f1 ff ff       	jmp    801064fa <alltraps>

8010734c <vector45>:
.globl vector45
vector45:
  pushl $0
8010734c:	6a 00                	push   $0x0
  pushl $45
8010734e:	6a 2d                	push   $0x2d
  jmp alltraps
80107350:	e9 a5 f1 ff ff       	jmp    801064fa <alltraps>

80107355 <vector46>:
.globl vector46
vector46:
  pushl $0
80107355:	6a 00                	push   $0x0
  pushl $46
80107357:	6a 2e                	push   $0x2e
  jmp alltraps
80107359:	e9 9c f1 ff ff       	jmp    801064fa <alltraps>

8010735e <vector47>:
.globl vector47
vector47:
  pushl $0
8010735e:	6a 00                	push   $0x0
  pushl $47
80107360:	6a 2f                	push   $0x2f
  jmp alltraps
80107362:	e9 93 f1 ff ff       	jmp    801064fa <alltraps>

80107367 <vector48>:
.globl vector48
vector48:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $48
80107369:	6a 30                	push   $0x30
  jmp alltraps
8010736b:	e9 8a f1 ff ff       	jmp    801064fa <alltraps>

80107370 <vector49>:
.globl vector49
vector49:
  pushl $0
80107370:	6a 00                	push   $0x0
  pushl $49
80107372:	6a 31                	push   $0x31
  jmp alltraps
80107374:	e9 81 f1 ff ff       	jmp    801064fa <alltraps>

80107379 <vector50>:
.globl vector50
vector50:
  pushl $0
80107379:	6a 00                	push   $0x0
  pushl $50
8010737b:	6a 32                	push   $0x32
  jmp alltraps
8010737d:	e9 78 f1 ff ff       	jmp    801064fa <alltraps>

80107382 <vector51>:
.globl vector51
vector51:
  pushl $0
80107382:	6a 00                	push   $0x0
  pushl $51
80107384:	6a 33                	push   $0x33
  jmp alltraps
80107386:	e9 6f f1 ff ff       	jmp    801064fa <alltraps>

8010738b <vector52>:
.globl vector52
vector52:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $52
8010738d:	6a 34                	push   $0x34
  jmp alltraps
8010738f:	e9 66 f1 ff ff       	jmp    801064fa <alltraps>

80107394 <vector53>:
.globl vector53
vector53:
  pushl $0
80107394:	6a 00                	push   $0x0
  pushl $53
80107396:	6a 35                	push   $0x35
  jmp alltraps
80107398:	e9 5d f1 ff ff       	jmp    801064fa <alltraps>

8010739d <vector54>:
.globl vector54
vector54:
  pushl $0
8010739d:	6a 00                	push   $0x0
  pushl $54
8010739f:	6a 36                	push   $0x36
  jmp alltraps
801073a1:	e9 54 f1 ff ff       	jmp    801064fa <alltraps>

801073a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801073a6:	6a 00                	push   $0x0
  pushl $55
801073a8:	6a 37                	push   $0x37
  jmp alltraps
801073aa:	e9 4b f1 ff ff       	jmp    801064fa <alltraps>

801073af <vector56>:
.globl vector56
vector56:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $56
801073b1:	6a 38                	push   $0x38
  jmp alltraps
801073b3:	e9 42 f1 ff ff       	jmp    801064fa <alltraps>

801073b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801073b8:	6a 00                	push   $0x0
  pushl $57
801073ba:	6a 39                	push   $0x39
  jmp alltraps
801073bc:	e9 39 f1 ff ff       	jmp    801064fa <alltraps>

801073c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801073c1:	6a 00                	push   $0x0
  pushl $58
801073c3:	6a 3a                	push   $0x3a
  jmp alltraps
801073c5:	e9 30 f1 ff ff       	jmp    801064fa <alltraps>

801073ca <vector59>:
.globl vector59
vector59:
  pushl $0
801073ca:	6a 00                	push   $0x0
  pushl $59
801073cc:	6a 3b                	push   $0x3b
  jmp alltraps
801073ce:	e9 27 f1 ff ff       	jmp    801064fa <alltraps>

801073d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $60
801073d5:	6a 3c                	push   $0x3c
  jmp alltraps
801073d7:	e9 1e f1 ff ff       	jmp    801064fa <alltraps>

801073dc <vector61>:
.globl vector61
vector61:
  pushl $0
801073dc:	6a 00                	push   $0x0
  pushl $61
801073de:	6a 3d                	push   $0x3d
  jmp alltraps
801073e0:	e9 15 f1 ff ff       	jmp    801064fa <alltraps>

801073e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801073e5:	6a 00                	push   $0x0
  pushl $62
801073e7:	6a 3e                	push   $0x3e
  jmp alltraps
801073e9:	e9 0c f1 ff ff       	jmp    801064fa <alltraps>

801073ee <vector63>:
.globl vector63
vector63:
  pushl $0
801073ee:	6a 00                	push   $0x0
  pushl $63
801073f0:	6a 3f                	push   $0x3f
  jmp alltraps
801073f2:	e9 03 f1 ff ff       	jmp    801064fa <alltraps>

801073f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $64
801073f9:	6a 40                	push   $0x40
  jmp alltraps
801073fb:	e9 fa f0 ff ff       	jmp    801064fa <alltraps>

80107400 <vector65>:
.globl vector65
vector65:
  pushl $0
80107400:	6a 00                	push   $0x0
  pushl $65
80107402:	6a 41                	push   $0x41
  jmp alltraps
80107404:	e9 f1 f0 ff ff       	jmp    801064fa <alltraps>

80107409 <vector66>:
.globl vector66
vector66:
  pushl $0
80107409:	6a 00                	push   $0x0
  pushl $66
8010740b:	6a 42                	push   $0x42
  jmp alltraps
8010740d:	e9 e8 f0 ff ff       	jmp    801064fa <alltraps>

80107412 <vector67>:
.globl vector67
vector67:
  pushl $0
80107412:	6a 00                	push   $0x0
  pushl $67
80107414:	6a 43                	push   $0x43
  jmp alltraps
80107416:	e9 df f0 ff ff       	jmp    801064fa <alltraps>

8010741b <vector68>:
.globl vector68
vector68:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $68
8010741d:	6a 44                	push   $0x44
  jmp alltraps
8010741f:	e9 d6 f0 ff ff       	jmp    801064fa <alltraps>

80107424 <vector69>:
.globl vector69
vector69:
  pushl $0
80107424:	6a 00                	push   $0x0
  pushl $69
80107426:	6a 45                	push   $0x45
  jmp alltraps
80107428:	e9 cd f0 ff ff       	jmp    801064fa <alltraps>

8010742d <vector70>:
.globl vector70
vector70:
  pushl $0
8010742d:	6a 00                	push   $0x0
  pushl $70
8010742f:	6a 46                	push   $0x46
  jmp alltraps
80107431:	e9 c4 f0 ff ff       	jmp    801064fa <alltraps>

80107436 <vector71>:
.globl vector71
vector71:
  pushl $0
80107436:	6a 00                	push   $0x0
  pushl $71
80107438:	6a 47                	push   $0x47
  jmp alltraps
8010743a:	e9 bb f0 ff ff       	jmp    801064fa <alltraps>

8010743f <vector72>:
.globl vector72
vector72:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $72
80107441:	6a 48                	push   $0x48
  jmp alltraps
80107443:	e9 b2 f0 ff ff       	jmp    801064fa <alltraps>

80107448 <vector73>:
.globl vector73
vector73:
  pushl $0
80107448:	6a 00                	push   $0x0
  pushl $73
8010744a:	6a 49                	push   $0x49
  jmp alltraps
8010744c:	e9 a9 f0 ff ff       	jmp    801064fa <alltraps>

80107451 <vector74>:
.globl vector74
vector74:
  pushl $0
80107451:	6a 00                	push   $0x0
  pushl $74
80107453:	6a 4a                	push   $0x4a
  jmp alltraps
80107455:	e9 a0 f0 ff ff       	jmp    801064fa <alltraps>

8010745a <vector75>:
.globl vector75
vector75:
  pushl $0
8010745a:	6a 00                	push   $0x0
  pushl $75
8010745c:	6a 4b                	push   $0x4b
  jmp alltraps
8010745e:	e9 97 f0 ff ff       	jmp    801064fa <alltraps>

80107463 <vector76>:
.globl vector76
vector76:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $76
80107465:	6a 4c                	push   $0x4c
  jmp alltraps
80107467:	e9 8e f0 ff ff       	jmp    801064fa <alltraps>

8010746c <vector77>:
.globl vector77
vector77:
  pushl $0
8010746c:	6a 00                	push   $0x0
  pushl $77
8010746e:	6a 4d                	push   $0x4d
  jmp alltraps
80107470:	e9 85 f0 ff ff       	jmp    801064fa <alltraps>

80107475 <vector78>:
.globl vector78
vector78:
  pushl $0
80107475:	6a 00                	push   $0x0
  pushl $78
80107477:	6a 4e                	push   $0x4e
  jmp alltraps
80107479:	e9 7c f0 ff ff       	jmp    801064fa <alltraps>

8010747e <vector79>:
.globl vector79
vector79:
  pushl $0
8010747e:	6a 00                	push   $0x0
  pushl $79
80107480:	6a 4f                	push   $0x4f
  jmp alltraps
80107482:	e9 73 f0 ff ff       	jmp    801064fa <alltraps>

80107487 <vector80>:
.globl vector80
vector80:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $80
80107489:	6a 50                	push   $0x50
  jmp alltraps
8010748b:	e9 6a f0 ff ff       	jmp    801064fa <alltraps>

80107490 <vector81>:
.globl vector81
vector81:
  pushl $0
80107490:	6a 00                	push   $0x0
  pushl $81
80107492:	6a 51                	push   $0x51
  jmp alltraps
80107494:	e9 61 f0 ff ff       	jmp    801064fa <alltraps>

80107499 <vector82>:
.globl vector82
vector82:
  pushl $0
80107499:	6a 00                	push   $0x0
  pushl $82
8010749b:	6a 52                	push   $0x52
  jmp alltraps
8010749d:	e9 58 f0 ff ff       	jmp    801064fa <alltraps>

801074a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801074a2:	6a 00                	push   $0x0
  pushl $83
801074a4:	6a 53                	push   $0x53
  jmp alltraps
801074a6:	e9 4f f0 ff ff       	jmp    801064fa <alltraps>

801074ab <vector84>:
.globl vector84
vector84:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $84
801074ad:	6a 54                	push   $0x54
  jmp alltraps
801074af:	e9 46 f0 ff ff       	jmp    801064fa <alltraps>

801074b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801074b4:	6a 00                	push   $0x0
  pushl $85
801074b6:	6a 55                	push   $0x55
  jmp alltraps
801074b8:	e9 3d f0 ff ff       	jmp    801064fa <alltraps>

801074bd <vector86>:
.globl vector86
vector86:
  pushl $0
801074bd:	6a 00                	push   $0x0
  pushl $86
801074bf:	6a 56                	push   $0x56
  jmp alltraps
801074c1:	e9 34 f0 ff ff       	jmp    801064fa <alltraps>

801074c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801074c6:	6a 00                	push   $0x0
  pushl $87
801074c8:	6a 57                	push   $0x57
  jmp alltraps
801074ca:	e9 2b f0 ff ff       	jmp    801064fa <alltraps>

801074cf <vector88>:
.globl vector88
vector88:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $88
801074d1:	6a 58                	push   $0x58
  jmp alltraps
801074d3:	e9 22 f0 ff ff       	jmp    801064fa <alltraps>

801074d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801074d8:	6a 00                	push   $0x0
  pushl $89
801074da:	6a 59                	push   $0x59
  jmp alltraps
801074dc:	e9 19 f0 ff ff       	jmp    801064fa <alltraps>

801074e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801074e1:	6a 00                	push   $0x0
  pushl $90
801074e3:	6a 5a                	push   $0x5a
  jmp alltraps
801074e5:	e9 10 f0 ff ff       	jmp    801064fa <alltraps>

801074ea <vector91>:
.globl vector91
vector91:
  pushl $0
801074ea:	6a 00                	push   $0x0
  pushl $91
801074ec:	6a 5b                	push   $0x5b
  jmp alltraps
801074ee:	e9 07 f0 ff ff       	jmp    801064fa <alltraps>

801074f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $92
801074f5:	6a 5c                	push   $0x5c
  jmp alltraps
801074f7:	e9 fe ef ff ff       	jmp    801064fa <alltraps>

801074fc <vector93>:
.globl vector93
vector93:
  pushl $0
801074fc:	6a 00                	push   $0x0
  pushl $93
801074fe:	6a 5d                	push   $0x5d
  jmp alltraps
80107500:	e9 f5 ef ff ff       	jmp    801064fa <alltraps>

80107505 <vector94>:
.globl vector94
vector94:
  pushl $0
80107505:	6a 00                	push   $0x0
  pushl $94
80107507:	6a 5e                	push   $0x5e
  jmp alltraps
80107509:	e9 ec ef ff ff       	jmp    801064fa <alltraps>

8010750e <vector95>:
.globl vector95
vector95:
  pushl $0
8010750e:	6a 00                	push   $0x0
  pushl $95
80107510:	6a 5f                	push   $0x5f
  jmp alltraps
80107512:	e9 e3 ef ff ff       	jmp    801064fa <alltraps>

80107517 <vector96>:
.globl vector96
vector96:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $96
80107519:	6a 60                	push   $0x60
  jmp alltraps
8010751b:	e9 da ef ff ff       	jmp    801064fa <alltraps>

80107520 <vector97>:
.globl vector97
vector97:
  pushl $0
80107520:	6a 00                	push   $0x0
  pushl $97
80107522:	6a 61                	push   $0x61
  jmp alltraps
80107524:	e9 d1 ef ff ff       	jmp    801064fa <alltraps>

80107529 <vector98>:
.globl vector98
vector98:
  pushl $0
80107529:	6a 00                	push   $0x0
  pushl $98
8010752b:	6a 62                	push   $0x62
  jmp alltraps
8010752d:	e9 c8 ef ff ff       	jmp    801064fa <alltraps>

80107532 <vector99>:
.globl vector99
vector99:
  pushl $0
80107532:	6a 00                	push   $0x0
  pushl $99
80107534:	6a 63                	push   $0x63
  jmp alltraps
80107536:	e9 bf ef ff ff       	jmp    801064fa <alltraps>

8010753b <vector100>:
.globl vector100
vector100:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $100
8010753d:	6a 64                	push   $0x64
  jmp alltraps
8010753f:	e9 b6 ef ff ff       	jmp    801064fa <alltraps>

80107544 <vector101>:
.globl vector101
vector101:
  pushl $0
80107544:	6a 00                	push   $0x0
  pushl $101
80107546:	6a 65                	push   $0x65
  jmp alltraps
80107548:	e9 ad ef ff ff       	jmp    801064fa <alltraps>

8010754d <vector102>:
.globl vector102
vector102:
  pushl $0
8010754d:	6a 00                	push   $0x0
  pushl $102
8010754f:	6a 66                	push   $0x66
  jmp alltraps
80107551:	e9 a4 ef ff ff       	jmp    801064fa <alltraps>

80107556 <vector103>:
.globl vector103
vector103:
  pushl $0
80107556:	6a 00                	push   $0x0
  pushl $103
80107558:	6a 67                	push   $0x67
  jmp alltraps
8010755a:	e9 9b ef ff ff       	jmp    801064fa <alltraps>

8010755f <vector104>:
.globl vector104
vector104:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $104
80107561:	6a 68                	push   $0x68
  jmp alltraps
80107563:	e9 92 ef ff ff       	jmp    801064fa <alltraps>

80107568 <vector105>:
.globl vector105
vector105:
  pushl $0
80107568:	6a 00                	push   $0x0
  pushl $105
8010756a:	6a 69                	push   $0x69
  jmp alltraps
8010756c:	e9 89 ef ff ff       	jmp    801064fa <alltraps>

80107571 <vector106>:
.globl vector106
vector106:
  pushl $0
80107571:	6a 00                	push   $0x0
  pushl $106
80107573:	6a 6a                	push   $0x6a
  jmp alltraps
80107575:	e9 80 ef ff ff       	jmp    801064fa <alltraps>

8010757a <vector107>:
.globl vector107
vector107:
  pushl $0
8010757a:	6a 00                	push   $0x0
  pushl $107
8010757c:	6a 6b                	push   $0x6b
  jmp alltraps
8010757e:	e9 77 ef ff ff       	jmp    801064fa <alltraps>

80107583 <vector108>:
.globl vector108
vector108:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $108
80107585:	6a 6c                	push   $0x6c
  jmp alltraps
80107587:	e9 6e ef ff ff       	jmp    801064fa <alltraps>

8010758c <vector109>:
.globl vector109
vector109:
  pushl $0
8010758c:	6a 00                	push   $0x0
  pushl $109
8010758e:	6a 6d                	push   $0x6d
  jmp alltraps
80107590:	e9 65 ef ff ff       	jmp    801064fa <alltraps>

80107595 <vector110>:
.globl vector110
vector110:
  pushl $0
80107595:	6a 00                	push   $0x0
  pushl $110
80107597:	6a 6e                	push   $0x6e
  jmp alltraps
80107599:	e9 5c ef ff ff       	jmp    801064fa <alltraps>

8010759e <vector111>:
.globl vector111
vector111:
  pushl $0
8010759e:	6a 00                	push   $0x0
  pushl $111
801075a0:	6a 6f                	push   $0x6f
  jmp alltraps
801075a2:	e9 53 ef ff ff       	jmp    801064fa <alltraps>

801075a7 <vector112>:
.globl vector112
vector112:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $112
801075a9:	6a 70                	push   $0x70
  jmp alltraps
801075ab:	e9 4a ef ff ff       	jmp    801064fa <alltraps>

801075b0 <vector113>:
.globl vector113
vector113:
  pushl $0
801075b0:	6a 00                	push   $0x0
  pushl $113
801075b2:	6a 71                	push   $0x71
  jmp alltraps
801075b4:	e9 41 ef ff ff       	jmp    801064fa <alltraps>

801075b9 <vector114>:
.globl vector114
vector114:
  pushl $0
801075b9:	6a 00                	push   $0x0
  pushl $114
801075bb:	6a 72                	push   $0x72
  jmp alltraps
801075bd:	e9 38 ef ff ff       	jmp    801064fa <alltraps>

801075c2 <vector115>:
.globl vector115
vector115:
  pushl $0
801075c2:	6a 00                	push   $0x0
  pushl $115
801075c4:	6a 73                	push   $0x73
  jmp alltraps
801075c6:	e9 2f ef ff ff       	jmp    801064fa <alltraps>

801075cb <vector116>:
.globl vector116
vector116:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $116
801075cd:	6a 74                	push   $0x74
  jmp alltraps
801075cf:	e9 26 ef ff ff       	jmp    801064fa <alltraps>

801075d4 <vector117>:
.globl vector117
vector117:
  pushl $0
801075d4:	6a 00                	push   $0x0
  pushl $117
801075d6:	6a 75                	push   $0x75
  jmp alltraps
801075d8:	e9 1d ef ff ff       	jmp    801064fa <alltraps>

801075dd <vector118>:
.globl vector118
vector118:
  pushl $0
801075dd:	6a 00                	push   $0x0
  pushl $118
801075df:	6a 76                	push   $0x76
  jmp alltraps
801075e1:	e9 14 ef ff ff       	jmp    801064fa <alltraps>

801075e6 <vector119>:
.globl vector119
vector119:
  pushl $0
801075e6:	6a 00                	push   $0x0
  pushl $119
801075e8:	6a 77                	push   $0x77
  jmp alltraps
801075ea:	e9 0b ef ff ff       	jmp    801064fa <alltraps>

801075ef <vector120>:
.globl vector120
vector120:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $120
801075f1:	6a 78                	push   $0x78
  jmp alltraps
801075f3:	e9 02 ef ff ff       	jmp    801064fa <alltraps>

801075f8 <vector121>:
.globl vector121
vector121:
  pushl $0
801075f8:	6a 00                	push   $0x0
  pushl $121
801075fa:	6a 79                	push   $0x79
  jmp alltraps
801075fc:	e9 f9 ee ff ff       	jmp    801064fa <alltraps>

80107601 <vector122>:
.globl vector122
vector122:
  pushl $0
80107601:	6a 00                	push   $0x0
  pushl $122
80107603:	6a 7a                	push   $0x7a
  jmp alltraps
80107605:	e9 f0 ee ff ff       	jmp    801064fa <alltraps>

8010760a <vector123>:
.globl vector123
vector123:
  pushl $0
8010760a:	6a 00                	push   $0x0
  pushl $123
8010760c:	6a 7b                	push   $0x7b
  jmp alltraps
8010760e:	e9 e7 ee ff ff       	jmp    801064fa <alltraps>

80107613 <vector124>:
.globl vector124
vector124:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $124
80107615:	6a 7c                	push   $0x7c
  jmp alltraps
80107617:	e9 de ee ff ff       	jmp    801064fa <alltraps>

8010761c <vector125>:
.globl vector125
vector125:
  pushl $0
8010761c:	6a 00                	push   $0x0
  pushl $125
8010761e:	6a 7d                	push   $0x7d
  jmp alltraps
80107620:	e9 d5 ee ff ff       	jmp    801064fa <alltraps>

80107625 <vector126>:
.globl vector126
vector126:
  pushl $0
80107625:	6a 00                	push   $0x0
  pushl $126
80107627:	6a 7e                	push   $0x7e
  jmp alltraps
80107629:	e9 cc ee ff ff       	jmp    801064fa <alltraps>

8010762e <vector127>:
.globl vector127
vector127:
  pushl $0
8010762e:	6a 00                	push   $0x0
  pushl $127
80107630:	6a 7f                	push   $0x7f
  jmp alltraps
80107632:	e9 c3 ee ff ff       	jmp    801064fa <alltraps>

80107637 <vector128>:
.globl vector128
vector128:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $128
80107639:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010763e:	e9 b7 ee ff ff       	jmp    801064fa <alltraps>

80107643 <vector129>:
.globl vector129
vector129:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $129
80107645:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010764a:	e9 ab ee ff ff       	jmp    801064fa <alltraps>

8010764f <vector130>:
.globl vector130
vector130:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $130
80107651:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107656:	e9 9f ee ff ff       	jmp    801064fa <alltraps>

8010765b <vector131>:
.globl vector131
vector131:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $131
8010765d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107662:	e9 93 ee ff ff       	jmp    801064fa <alltraps>

80107667 <vector132>:
.globl vector132
vector132:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $132
80107669:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010766e:	e9 87 ee ff ff       	jmp    801064fa <alltraps>

80107673 <vector133>:
.globl vector133
vector133:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $133
80107675:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010767a:	e9 7b ee ff ff       	jmp    801064fa <alltraps>

8010767f <vector134>:
.globl vector134
vector134:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $134
80107681:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107686:	e9 6f ee ff ff       	jmp    801064fa <alltraps>

8010768b <vector135>:
.globl vector135
vector135:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $135
8010768d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107692:	e9 63 ee ff ff       	jmp    801064fa <alltraps>

80107697 <vector136>:
.globl vector136
vector136:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $136
80107699:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010769e:	e9 57 ee ff ff       	jmp    801064fa <alltraps>

801076a3 <vector137>:
.globl vector137
vector137:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $137
801076a5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801076aa:	e9 4b ee ff ff       	jmp    801064fa <alltraps>

801076af <vector138>:
.globl vector138
vector138:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $138
801076b1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801076b6:	e9 3f ee ff ff       	jmp    801064fa <alltraps>

801076bb <vector139>:
.globl vector139
vector139:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $139
801076bd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801076c2:	e9 33 ee ff ff       	jmp    801064fa <alltraps>

801076c7 <vector140>:
.globl vector140
vector140:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $140
801076c9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801076ce:	e9 27 ee ff ff       	jmp    801064fa <alltraps>

801076d3 <vector141>:
.globl vector141
vector141:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $141
801076d5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801076da:	e9 1b ee ff ff       	jmp    801064fa <alltraps>

801076df <vector142>:
.globl vector142
vector142:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $142
801076e1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801076e6:	e9 0f ee ff ff       	jmp    801064fa <alltraps>

801076eb <vector143>:
.globl vector143
vector143:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $143
801076ed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801076f2:	e9 03 ee ff ff       	jmp    801064fa <alltraps>

801076f7 <vector144>:
.globl vector144
vector144:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $144
801076f9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801076fe:	e9 f7 ed ff ff       	jmp    801064fa <alltraps>

80107703 <vector145>:
.globl vector145
vector145:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $145
80107705:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010770a:	e9 eb ed ff ff       	jmp    801064fa <alltraps>

8010770f <vector146>:
.globl vector146
vector146:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $146
80107711:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107716:	e9 df ed ff ff       	jmp    801064fa <alltraps>

8010771b <vector147>:
.globl vector147
vector147:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $147
8010771d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107722:	e9 d3 ed ff ff       	jmp    801064fa <alltraps>

80107727 <vector148>:
.globl vector148
vector148:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $148
80107729:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010772e:	e9 c7 ed ff ff       	jmp    801064fa <alltraps>

80107733 <vector149>:
.globl vector149
vector149:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $149
80107735:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010773a:	e9 bb ed ff ff       	jmp    801064fa <alltraps>

8010773f <vector150>:
.globl vector150
vector150:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $150
80107741:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107746:	e9 af ed ff ff       	jmp    801064fa <alltraps>

8010774b <vector151>:
.globl vector151
vector151:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $151
8010774d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107752:	e9 a3 ed ff ff       	jmp    801064fa <alltraps>

80107757 <vector152>:
.globl vector152
vector152:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $152
80107759:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010775e:	e9 97 ed ff ff       	jmp    801064fa <alltraps>

80107763 <vector153>:
.globl vector153
vector153:
  pushl $0
80107763:	6a 00                	push   $0x0
  pushl $153
80107765:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010776a:	e9 8b ed ff ff       	jmp    801064fa <alltraps>

8010776f <vector154>:
.globl vector154
vector154:
  pushl $0
8010776f:	6a 00                	push   $0x0
  pushl $154
80107771:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107776:	e9 7f ed ff ff       	jmp    801064fa <alltraps>

8010777b <vector155>:
.globl vector155
vector155:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $155
8010777d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107782:	e9 73 ed ff ff       	jmp    801064fa <alltraps>

80107787 <vector156>:
.globl vector156
vector156:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $156
80107789:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010778e:	e9 67 ed ff ff       	jmp    801064fa <alltraps>

80107793 <vector157>:
.globl vector157
vector157:
  pushl $0
80107793:	6a 00                	push   $0x0
  pushl $157
80107795:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010779a:	e9 5b ed ff ff       	jmp    801064fa <alltraps>

8010779f <vector158>:
.globl vector158
vector158:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $158
801077a1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801077a6:	e9 4f ed ff ff       	jmp    801064fa <alltraps>

801077ab <vector159>:
.globl vector159
vector159:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $159
801077ad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801077b2:	e9 43 ed ff ff       	jmp    801064fa <alltraps>

801077b7 <vector160>:
.globl vector160
vector160:
  pushl $0
801077b7:	6a 00                	push   $0x0
  pushl $160
801077b9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801077be:	e9 37 ed ff ff       	jmp    801064fa <alltraps>

801077c3 <vector161>:
.globl vector161
vector161:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $161
801077c5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801077ca:	e9 2b ed ff ff       	jmp    801064fa <alltraps>

801077cf <vector162>:
.globl vector162
vector162:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $162
801077d1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801077d6:	e9 1f ed ff ff       	jmp    801064fa <alltraps>

801077db <vector163>:
.globl vector163
vector163:
  pushl $0
801077db:	6a 00                	push   $0x0
  pushl $163
801077dd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801077e2:	e9 13 ed ff ff       	jmp    801064fa <alltraps>

801077e7 <vector164>:
.globl vector164
vector164:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $164
801077e9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801077ee:	e9 07 ed ff ff       	jmp    801064fa <alltraps>

801077f3 <vector165>:
.globl vector165
vector165:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $165
801077f5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801077fa:	e9 fb ec ff ff       	jmp    801064fa <alltraps>

801077ff <vector166>:
.globl vector166
vector166:
  pushl $0
801077ff:	6a 00                	push   $0x0
  pushl $166
80107801:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107806:	e9 ef ec ff ff       	jmp    801064fa <alltraps>

8010780b <vector167>:
.globl vector167
vector167:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $167
8010780d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107812:	e9 e3 ec ff ff       	jmp    801064fa <alltraps>

80107817 <vector168>:
.globl vector168
vector168:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $168
80107819:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010781e:	e9 d7 ec ff ff       	jmp    801064fa <alltraps>

80107823 <vector169>:
.globl vector169
vector169:
  pushl $0
80107823:	6a 00                	push   $0x0
  pushl $169
80107825:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010782a:	e9 cb ec ff ff       	jmp    801064fa <alltraps>

8010782f <vector170>:
.globl vector170
vector170:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $170
80107831:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107836:	e9 bf ec ff ff       	jmp    801064fa <alltraps>

8010783b <vector171>:
.globl vector171
vector171:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $171
8010783d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107842:	e9 b3 ec ff ff       	jmp    801064fa <alltraps>

80107847 <vector172>:
.globl vector172
vector172:
  pushl $0
80107847:	6a 00                	push   $0x0
  pushl $172
80107849:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010784e:	e9 a7 ec ff ff       	jmp    801064fa <alltraps>

80107853 <vector173>:
.globl vector173
vector173:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $173
80107855:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010785a:	e9 9b ec ff ff       	jmp    801064fa <alltraps>

8010785f <vector174>:
.globl vector174
vector174:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $174
80107861:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107866:	e9 8f ec ff ff       	jmp    801064fa <alltraps>

8010786b <vector175>:
.globl vector175
vector175:
  pushl $0
8010786b:	6a 00                	push   $0x0
  pushl $175
8010786d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107872:	e9 83 ec ff ff       	jmp    801064fa <alltraps>

80107877 <vector176>:
.globl vector176
vector176:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $176
80107879:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010787e:	e9 77 ec ff ff       	jmp    801064fa <alltraps>

80107883 <vector177>:
.globl vector177
vector177:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $177
80107885:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010788a:	e9 6b ec ff ff       	jmp    801064fa <alltraps>

8010788f <vector178>:
.globl vector178
vector178:
  pushl $0
8010788f:	6a 00                	push   $0x0
  pushl $178
80107891:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107896:	e9 5f ec ff ff       	jmp    801064fa <alltraps>

8010789b <vector179>:
.globl vector179
vector179:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $179
8010789d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801078a2:	e9 53 ec ff ff       	jmp    801064fa <alltraps>

801078a7 <vector180>:
.globl vector180
vector180:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $180
801078a9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801078ae:	e9 47 ec ff ff       	jmp    801064fa <alltraps>

801078b3 <vector181>:
.globl vector181
vector181:
  pushl $0
801078b3:	6a 00                	push   $0x0
  pushl $181
801078b5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801078ba:	e9 3b ec ff ff       	jmp    801064fa <alltraps>

801078bf <vector182>:
.globl vector182
vector182:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $182
801078c1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801078c6:	e9 2f ec ff ff       	jmp    801064fa <alltraps>

801078cb <vector183>:
.globl vector183
vector183:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $183
801078cd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801078d2:	e9 23 ec ff ff       	jmp    801064fa <alltraps>

801078d7 <vector184>:
.globl vector184
vector184:
  pushl $0
801078d7:	6a 00                	push   $0x0
  pushl $184
801078d9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801078de:	e9 17 ec ff ff       	jmp    801064fa <alltraps>

801078e3 <vector185>:
.globl vector185
vector185:
  pushl $0
801078e3:	6a 00                	push   $0x0
  pushl $185
801078e5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801078ea:	e9 0b ec ff ff       	jmp    801064fa <alltraps>

801078ef <vector186>:
.globl vector186
vector186:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $186
801078f1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801078f6:	e9 ff eb ff ff       	jmp    801064fa <alltraps>

801078fb <vector187>:
.globl vector187
vector187:
  pushl $0
801078fb:	6a 00                	push   $0x0
  pushl $187
801078fd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107902:	e9 f3 eb ff ff       	jmp    801064fa <alltraps>

80107907 <vector188>:
.globl vector188
vector188:
  pushl $0
80107907:	6a 00                	push   $0x0
  pushl $188
80107909:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010790e:	e9 e7 eb ff ff       	jmp    801064fa <alltraps>

80107913 <vector189>:
.globl vector189
vector189:
  pushl $0
80107913:	6a 00                	push   $0x0
  pushl $189
80107915:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010791a:	e9 db eb ff ff       	jmp    801064fa <alltraps>

8010791f <vector190>:
.globl vector190
vector190:
  pushl $0
8010791f:	6a 00                	push   $0x0
  pushl $190
80107921:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107926:	e9 cf eb ff ff       	jmp    801064fa <alltraps>

8010792b <vector191>:
.globl vector191
vector191:
  pushl $0
8010792b:	6a 00                	push   $0x0
  pushl $191
8010792d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107932:	e9 c3 eb ff ff       	jmp    801064fa <alltraps>

80107937 <vector192>:
.globl vector192
vector192:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $192
80107939:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010793e:	e9 b7 eb ff ff       	jmp    801064fa <alltraps>

80107943 <vector193>:
.globl vector193
vector193:
  pushl $0
80107943:	6a 00                	push   $0x0
  pushl $193
80107945:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010794a:	e9 ab eb ff ff       	jmp    801064fa <alltraps>

8010794f <vector194>:
.globl vector194
vector194:
  pushl $0
8010794f:	6a 00                	push   $0x0
  pushl $194
80107951:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107956:	e9 9f eb ff ff       	jmp    801064fa <alltraps>

8010795b <vector195>:
.globl vector195
vector195:
  pushl $0
8010795b:	6a 00                	push   $0x0
  pushl $195
8010795d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107962:	e9 93 eb ff ff       	jmp    801064fa <alltraps>

80107967 <vector196>:
.globl vector196
vector196:
  pushl $0
80107967:	6a 00                	push   $0x0
  pushl $196
80107969:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010796e:	e9 87 eb ff ff       	jmp    801064fa <alltraps>

80107973 <vector197>:
.globl vector197
vector197:
  pushl $0
80107973:	6a 00                	push   $0x0
  pushl $197
80107975:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010797a:	e9 7b eb ff ff       	jmp    801064fa <alltraps>

8010797f <vector198>:
.globl vector198
vector198:
  pushl $0
8010797f:	6a 00                	push   $0x0
  pushl $198
80107981:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107986:	e9 6f eb ff ff       	jmp    801064fa <alltraps>

8010798b <vector199>:
.globl vector199
vector199:
  pushl $0
8010798b:	6a 00                	push   $0x0
  pushl $199
8010798d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107992:	e9 63 eb ff ff       	jmp    801064fa <alltraps>

80107997 <vector200>:
.globl vector200
vector200:
  pushl $0
80107997:	6a 00                	push   $0x0
  pushl $200
80107999:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010799e:	e9 57 eb ff ff       	jmp    801064fa <alltraps>

801079a3 <vector201>:
.globl vector201
vector201:
  pushl $0
801079a3:	6a 00                	push   $0x0
  pushl $201
801079a5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801079aa:	e9 4b eb ff ff       	jmp    801064fa <alltraps>

801079af <vector202>:
.globl vector202
vector202:
  pushl $0
801079af:	6a 00                	push   $0x0
  pushl $202
801079b1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801079b6:	e9 3f eb ff ff       	jmp    801064fa <alltraps>

801079bb <vector203>:
.globl vector203
vector203:
  pushl $0
801079bb:	6a 00                	push   $0x0
  pushl $203
801079bd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801079c2:	e9 33 eb ff ff       	jmp    801064fa <alltraps>

801079c7 <vector204>:
.globl vector204
vector204:
  pushl $0
801079c7:	6a 00                	push   $0x0
  pushl $204
801079c9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801079ce:	e9 27 eb ff ff       	jmp    801064fa <alltraps>

801079d3 <vector205>:
.globl vector205
vector205:
  pushl $0
801079d3:	6a 00                	push   $0x0
  pushl $205
801079d5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801079da:	e9 1b eb ff ff       	jmp    801064fa <alltraps>

801079df <vector206>:
.globl vector206
vector206:
  pushl $0
801079df:	6a 00                	push   $0x0
  pushl $206
801079e1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801079e6:	e9 0f eb ff ff       	jmp    801064fa <alltraps>

801079eb <vector207>:
.globl vector207
vector207:
  pushl $0
801079eb:	6a 00                	push   $0x0
  pushl $207
801079ed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801079f2:	e9 03 eb ff ff       	jmp    801064fa <alltraps>

801079f7 <vector208>:
.globl vector208
vector208:
  pushl $0
801079f7:	6a 00                	push   $0x0
  pushl $208
801079f9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801079fe:	e9 f7 ea ff ff       	jmp    801064fa <alltraps>

80107a03 <vector209>:
.globl vector209
vector209:
  pushl $0
80107a03:	6a 00                	push   $0x0
  pushl $209
80107a05:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107a0a:	e9 eb ea ff ff       	jmp    801064fa <alltraps>

80107a0f <vector210>:
.globl vector210
vector210:
  pushl $0
80107a0f:	6a 00                	push   $0x0
  pushl $210
80107a11:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107a16:	e9 df ea ff ff       	jmp    801064fa <alltraps>

80107a1b <vector211>:
.globl vector211
vector211:
  pushl $0
80107a1b:	6a 00                	push   $0x0
  pushl $211
80107a1d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107a22:	e9 d3 ea ff ff       	jmp    801064fa <alltraps>

80107a27 <vector212>:
.globl vector212
vector212:
  pushl $0
80107a27:	6a 00                	push   $0x0
  pushl $212
80107a29:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107a2e:	e9 c7 ea ff ff       	jmp    801064fa <alltraps>

80107a33 <vector213>:
.globl vector213
vector213:
  pushl $0
80107a33:	6a 00                	push   $0x0
  pushl $213
80107a35:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107a3a:	e9 bb ea ff ff       	jmp    801064fa <alltraps>

80107a3f <vector214>:
.globl vector214
vector214:
  pushl $0
80107a3f:	6a 00                	push   $0x0
  pushl $214
80107a41:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107a46:	e9 af ea ff ff       	jmp    801064fa <alltraps>

80107a4b <vector215>:
.globl vector215
vector215:
  pushl $0
80107a4b:	6a 00                	push   $0x0
  pushl $215
80107a4d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107a52:	e9 a3 ea ff ff       	jmp    801064fa <alltraps>

80107a57 <vector216>:
.globl vector216
vector216:
  pushl $0
80107a57:	6a 00                	push   $0x0
  pushl $216
80107a59:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107a5e:	e9 97 ea ff ff       	jmp    801064fa <alltraps>

80107a63 <vector217>:
.globl vector217
vector217:
  pushl $0
80107a63:	6a 00                	push   $0x0
  pushl $217
80107a65:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107a6a:	e9 8b ea ff ff       	jmp    801064fa <alltraps>

80107a6f <vector218>:
.globl vector218
vector218:
  pushl $0
80107a6f:	6a 00                	push   $0x0
  pushl $218
80107a71:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107a76:	e9 7f ea ff ff       	jmp    801064fa <alltraps>

80107a7b <vector219>:
.globl vector219
vector219:
  pushl $0
80107a7b:	6a 00                	push   $0x0
  pushl $219
80107a7d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107a82:	e9 73 ea ff ff       	jmp    801064fa <alltraps>

80107a87 <vector220>:
.globl vector220
vector220:
  pushl $0
80107a87:	6a 00                	push   $0x0
  pushl $220
80107a89:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107a8e:	e9 67 ea ff ff       	jmp    801064fa <alltraps>

80107a93 <vector221>:
.globl vector221
vector221:
  pushl $0
80107a93:	6a 00                	push   $0x0
  pushl $221
80107a95:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107a9a:	e9 5b ea ff ff       	jmp    801064fa <alltraps>

80107a9f <vector222>:
.globl vector222
vector222:
  pushl $0
80107a9f:	6a 00                	push   $0x0
  pushl $222
80107aa1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107aa6:	e9 4f ea ff ff       	jmp    801064fa <alltraps>

80107aab <vector223>:
.globl vector223
vector223:
  pushl $0
80107aab:	6a 00                	push   $0x0
  pushl $223
80107aad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107ab2:	e9 43 ea ff ff       	jmp    801064fa <alltraps>

80107ab7 <vector224>:
.globl vector224
vector224:
  pushl $0
80107ab7:	6a 00                	push   $0x0
  pushl $224
80107ab9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107abe:	e9 37 ea ff ff       	jmp    801064fa <alltraps>

80107ac3 <vector225>:
.globl vector225
vector225:
  pushl $0
80107ac3:	6a 00                	push   $0x0
  pushl $225
80107ac5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107aca:	e9 2b ea ff ff       	jmp    801064fa <alltraps>

80107acf <vector226>:
.globl vector226
vector226:
  pushl $0
80107acf:	6a 00                	push   $0x0
  pushl $226
80107ad1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107ad6:	e9 1f ea ff ff       	jmp    801064fa <alltraps>

80107adb <vector227>:
.globl vector227
vector227:
  pushl $0
80107adb:	6a 00                	push   $0x0
  pushl $227
80107add:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107ae2:	e9 13 ea ff ff       	jmp    801064fa <alltraps>

80107ae7 <vector228>:
.globl vector228
vector228:
  pushl $0
80107ae7:	6a 00                	push   $0x0
  pushl $228
80107ae9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107aee:	e9 07 ea ff ff       	jmp    801064fa <alltraps>

80107af3 <vector229>:
.globl vector229
vector229:
  pushl $0
80107af3:	6a 00                	push   $0x0
  pushl $229
80107af5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107afa:	e9 fb e9 ff ff       	jmp    801064fa <alltraps>

80107aff <vector230>:
.globl vector230
vector230:
  pushl $0
80107aff:	6a 00                	push   $0x0
  pushl $230
80107b01:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107b06:	e9 ef e9 ff ff       	jmp    801064fa <alltraps>

80107b0b <vector231>:
.globl vector231
vector231:
  pushl $0
80107b0b:	6a 00                	push   $0x0
  pushl $231
80107b0d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107b12:	e9 e3 e9 ff ff       	jmp    801064fa <alltraps>

80107b17 <vector232>:
.globl vector232
vector232:
  pushl $0
80107b17:	6a 00                	push   $0x0
  pushl $232
80107b19:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107b1e:	e9 d7 e9 ff ff       	jmp    801064fa <alltraps>

80107b23 <vector233>:
.globl vector233
vector233:
  pushl $0
80107b23:	6a 00                	push   $0x0
  pushl $233
80107b25:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107b2a:	e9 cb e9 ff ff       	jmp    801064fa <alltraps>

80107b2f <vector234>:
.globl vector234
vector234:
  pushl $0
80107b2f:	6a 00                	push   $0x0
  pushl $234
80107b31:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107b36:	e9 bf e9 ff ff       	jmp    801064fa <alltraps>

80107b3b <vector235>:
.globl vector235
vector235:
  pushl $0
80107b3b:	6a 00                	push   $0x0
  pushl $235
80107b3d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107b42:	e9 b3 e9 ff ff       	jmp    801064fa <alltraps>

80107b47 <vector236>:
.globl vector236
vector236:
  pushl $0
80107b47:	6a 00                	push   $0x0
  pushl $236
80107b49:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107b4e:	e9 a7 e9 ff ff       	jmp    801064fa <alltraps>

80107b53 <vector237>:
.globl vector237
vector237:
  pushl $0
80107b53:	6a 00                	push   $0x0
  pushl $237
80107b55:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107b5a:	e9 9b e9 ff ff       	jmp    801064fa <alltraps>

80107b5f <vector238>:
.globl vector238
vector238:
  pushl $0
80107b5f:	6a 00                	push   $0x0
  pushl $238
80107b61:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107b66:	e9 8f e9 ff ff       	jmp    801064fa <alltraps>

80107b6b <vector239>:
.globl vector239
vector239:
  pushl $0
80107b6b:	6a 00                	push   $0x0
  pushl $239
80107b6d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107b72:	e9 83 e9 ff ff       	jmp    801064fa <alltraps>

80107b77 <vector240>:
.globl vector240
vector240:
  pushl $0
80107b77:	6a 00                	push   $0x0
  pushl $240
80107b79:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107b7e:	e9 77 e9 ff ff       	jmp    801064fa <alltraps>

80107b83 <vector241>:
.globl vector241
vector241:
  pushl $0
80107b83:	6a 00                	push   $0x0
  pushl $241
80107b85:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107b8a:	e9 6b e9 ff ff       	jmp    801064fa <alltraps>

80107b8f <vector242>:
.globl vector242
vector242:
  pushl $0
80107b8f:	6a 00                	push   $0x0
  pushl $242
80107b91:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107b96:	e9 5f e9 ff ff       	jmp    801064fa <alltraps>

80107b9b <vector243>:
.globl vector243
vector243:
  pushl $0
80107b9b:	6a 00                	push   $0x0
  pushl $243
80107b9d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107ba2:	e9 53 e9 ff ff       	jmp    801064fa <alltraps>

80107ba7 <vector244>:
.globl vector244
vector244:
  pushl $0
80107ba7:	6a 00                	push   $0x0
  pushl $244
80107ba9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107bae:	e9 47 e9 ff ff       	jmp    801064fa <alltraps>

80107bb3 <vector245>:
.globl vector245
vector245:
  pushl $0
80107bb3:	6a 00                	push   $0x0
  pushl $245
80107bb5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107bba:	e9 3b e9 ff ff       	jmp    801064fa <alltraps>

80107bbf <vector246>:
.globl vector246
vector246:
  pushl $0
80107bbf:	6a 00                	push   $0x0
  pushl $246
80107bc1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107bc6:	e9 2f e9 ff ff       	jmp    801064fa <alltraps>

80107bcb <vector247>:
.globl vector247
vector247:
  pushl $0
80107bcb:	6a 00                	push   $0x0
  pushl $247
80107bcd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107bd2:	e9 23 e9 ff ff       	jmp    801064fa <alltraps>

80107bd7 <vector248>:
.globl vector248
vector248:
  pushl $0
80107bd7:	6a 00                	push   $0x0
  pushl $248
80107bd9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107bde:	e9 17 e9 ff ff       	jmp    801064fa <alltraps>

80107be3 <vector249>:
.globl vector249
vector249:
  pushl $0
80107be3:	6a 00                	push   $0x0
  pushl $249
80107be5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107bea:	e9 0b e9 ff ff       	jmp    801064fa <alltraps>

80107bef <vector250>:
.globl vector250
vector250:
  pushl $0
80107bef:	6a 00                	push   $0x0
  pushl $250
80107bf1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107bf6:	e9 ff e8 ff ff       	jmp    801064fa <alltraps>

80107bfb <vector251>:
.globl vector251
vector251:
  pushl $0
80107bfb:	6a 00                	push   $0x0
  pushl $251
80107bfd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107c02:	e9 f3 e8 ff ff       	jmp    801064fa <alltraps>

80107c07 <vector252>:
.globl vector252
vector252:
  pushl $0
80107c07:	6a 00                	push   $0x0
  pushl $252
80107c09:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107c0e:	e9 e7 e8 ff ff       	jmp    801064fa <alltraps>

80107c13 <vector253>:
.globl vector253
vector253:
  pushl $0
80107c13:	6a 00                	push   $0x0
  pushl $253
80107c15:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107c1a:	e9 db e8 ff ff       	jmp    801064fa <alltraps>

80107c1f <vector254>:
.globl vector254
vector254:
  pushl $0
80107c1f:	6a 00                	push   $0x0
  pushl $254
80107c21:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107c26:	e9 cf e8 ff ff       	jmp    801064fa <alltraps>

80107c2b <vector255>:
.globl vector255
vector255:
  pushl $0
80107c2b:	6a 00                	push   $0x0
  pushl $255
80107c2d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107c32:	e9 c3 e8 ff ff       	jmp    801064fa <alltraps>
80107c37:	66 90                	xchg   %ax,%ax
80107c39:	66 90                	xchg   %ax,%ax
80107c3b:	66 90                	xchg   %ax,%ax
80107c3d:	66 90                	xchg   %ax,%ax
80107c3f:	90                   	nop

80107c40 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107c40:	55                   	push   %ebp
80107c41:	89 e5                	mov    %esp,%ebp
80107c43:	57                   	push   %edi
80107c44:	56                   	push   %esi
80107c45:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107c46:	89 d3                	mov    %edx,%ebx
{
80107c48:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80107c4a:	c1 eb 16             	shr    $0x16,%ebx
80107c4d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107c50:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107c53:	8b 06                	mov    (%esi),%eax
80107c55:	a8 01                	test   $0x1,%al
80107c57:	74 27                	je     80107c80 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107c59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c5e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107c64:	c1 ef 0a             	shr    $0xa,%edi
}
80107c67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107c6a:	89 fa                	mov    %edi,%edx
80107c6c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107c72:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107c75:	5b                   	pop    %ebx
80107c76:	5e                   	pop    %esi
80107c77:	5f                   	pop    %edi
80107c78:	5d                   	pop    %ebp
80107c79:	c3                   	ret    
80107c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107c80:	85 c9                	test   %ecx,%ecx
80107c82:	74 2c                	je     80107cb0 <walkpgdir+0x70>
80107c84:	e8 37 a8 ff ff       	call   801024c0 <kalloc>
80107c89:	85 c0                	test   %eax,%eax
80107c8b:	89 c3                	mov    %eax,%ebx
80107c8d:	74 21                	je     80107cb0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80107c8f:	83 ec 04             	sub    $0x4,%esp
80107c92:	68 00 10 00 00       	push   $0x1000
80107c97:	6a 00                	push   $0x0
80107c99:	50                   	push   %eax
80107c9a:	e8 71 d5 ff ff       	call   80105210 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107c9f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107ca5:	83 c4 10             	add    $0x10,%esp
80107ca8:	83 c8 07             	or     $0x7,%eax
80107cab:	89 06                	mov    %eax,(%esi)
80107cad:	eb b5                	jmp    80107c64 <walkpgdir+0x24>
80107caf:	90                   	nop
}
80107cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107cb3:	31 c0                	xor    %eax,%eax
}
80107cb5:	5b                   	pop    %ebx
80107cb6:	5e                   	pop    %esi
80107cb7:	5f                   	pop    %edi
80107cb8:	5d                   	pop    %ebp
80107cb9:	c3                   	ret    
80107cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107cc0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107cc0:	55                   	push   %ebp
80107cc1:	89 e5                	mov    %esp,%ebp
80107cc3:	57                   	push   %edi
80107cc4:	56                   	push   %esi
80107cc5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107cc6:	89 d3                	mov    %edx,%ebx
80107cc8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80107cce:	83 ec 1c             	sub    $0x1c,%esp
80107cd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107cd4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107cd8:	8b 7d 08             	mov    0x8(%ebp),%edi
80107cdb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ce0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ce6:	29 df                	sub    %ebx,%edi
80107ce8:	83 c8 01             	or     $0x1,%eax
80107ceb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107cee:	eb 15                	jmp    80107d05 <mappages+0x45>
    if(*pte & PTE_P)
80107cf0:	f6 00 01             	testb  $0x1,(%eax)
80107cf3:	75 45                	jne    80107d3a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107cf5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107cf8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80107cfb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107cfd:	74 31                	je     80107d30 <mappages+0x70>
      break;
    a += PGSIZE;
80107cff:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d08:	b9 01 00 00 00       	mov    $0x1,%ecx
80107d0d:	89 da                	mov    %ebx,%edx
80107d0f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107d12:	e8 29 ff ff ff       	call   80107c40 <walkpgdir>
80107d17:	85 c0                	test   %eax,%eax
80107d19:	75 d5                	jne    80107cf0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107d1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107d1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d23:	5b                   	pop    %ebx
80107d24:	5e                   	pop    %esi
80107d25:	5f                   	pop    %edi
80107d26:	5d                   	pop    %ebp
80107d27:	c3                   	ret    
80107d28:	90                   	nop
80107d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107d33:	31 c0                	xor    %eax,%eax
}
80107d35:	5b                   	pop    %ebx
80107d36:	5e                   	pop    %esi
80107d37:	5f                   	pop    %edi
80107d38:	5d                   	pop    %ebp
80107d39:	c3                   	ret    
      panic("remap");
80107d3a:	83 ec 0c             	sub    $0xc,%esp
80107d3d:	68 5c 90 10 80       	push   $0x8010905c
80107d42:	e8 49 86 ff ff       	call   80100390 <panic>
80107d47:	89 f6                	mov    %esi,%esi
80107d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107d50 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107d50:	55                   	push   %ebp
80107d51:	89 e5                	mov    %esp,%ebp
80107d53:	57                   	push   %edi
80107d54:	56                   	push   %esi
80107d55:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107d56:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107d5c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80107d5e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107d64:	83 ec 1c             	sub    $0x1c,%esp
80107d67:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107d6a:	39 d3                	cmp    %edx,%ebx
80107d6c:	73 66                	jae    80107dd4 <deallocuvm.part.0+0x84>
80107d6e:	89 d6                	mov    %edx,%esi
80107d70:	eb 3d                	jmp    80107daf <deallocuvm.part.0+0x5f>
80107d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107d78:	8b 10                	mov    (%eax),%edx
80107d7a:	f6 c2 01             	test   $0x1,%dl
80107d7d:	74 26                	je     80107da5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107d7f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107d85:	74 58                	je     80107ddf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107d87:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107d8a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107d90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107d93:	52                   	push   %edx
80107d94:	e8 77 a5 ff ff       	call   80102310 <kfree>
      *pte = 0;
80107d99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d9c:	83 c4 10             	add    $0x10,%esp
80107d9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107da5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107dab:	39 f3                	cmp    %esi,%ebx
80107dad:	73 25                	jae    80107dd4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107daf:	31 c9                	xor    %ecx,%ecx
80107db1:	89 da                	mov    %ebx,%edx
80107db3:	89 f8                	mov    %edi,%eax
80107db5:	e8 86 fe ff ff       	call   80107c40 <walkpgdir>
    if(!pte)
80107dba:	85 c0                	test   %eax,%eax
80107dbc:	75 ba                	jne    80107d78 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107dbe:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107dc4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107dca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107dd0:	39 f3                	cmp    %esi,%ebx
80107dd2:	72 db                	jb     80107daf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107dd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107dda:	5b                   	pop    %ebx
80107ddb:	5e                   	pop    %esi
80107ddc:	5f                   	pop    %edi
80107ddd:	5d                   	pop    %ebp
80107dde:	c3                   	ret    
        panic("kfree");
80107ddf:	83 ec 0c             	sub    $0xc,%esp
80107de2:	68 e6 87 10 80       	push   $0x801087e6
80107de7:	e8 a4 85 ff ff       	call   80100390 <panic>
80107dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107df0 <seginit>:
{
80107df0:	55                   	push   %ebp
80107df1:	89 e5                	mov    %esp,%ebp
80107df3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107df6:	e8 05 bc ff ff       	call   80103a00 <cpuid>
80107dfb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107e01:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107e06:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107e0a:	c7 80 98 9b 18 80 ff 	movl   $0xffff,-0x7fe76468(%eax)
80107e11:	ff 00 00 
80107e14:	c7 80 9c 9b 18 80 00 	movl   $0xcf9a00,-0x7fe76464(%eax)
80107e1b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107e1e:	c7 80 a0 9b 18 80 ff 	movl   $0xffff,-0x7fe76460(%eax)
80107e25:	ff 00 00 
80107e28:	c7 80 a4 9b 18 80 00 	movl   $0xcf9200,-0x7fe7645c(%eax)
80107e2f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107e32:	c7 80 a8 9b 18 80 ff 	movl   $0xffff,-0x7fe76458(%eax)
80107e39:	ff 00 00 
80107e3c:	c7 80 ac 9b 18 80 00 	movl   $0xcffa00,-0x7fe76454(%eax)
80107e43:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107e46:	c7 80 b0 9b 18 80 ff 	movl   $0xffff,-0x7fe76450(%eax)
80107e4d:	ff 00 00 
80107e50:	c7 80 b4 9b 18 80 00 	movl   $0xcff200,-0x7fe7644c(%eax)
80107e57:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107e5a:	05 90 9b 18 80       	add    $0x80189b90,%eax
  pd[1] = (uint)p;
80107e5f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107e63:	c1 e8 10             	shr    $0x10,%eax
80107e66:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107e6a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107e6d:	0f 01 10             	lgdtl  (%eax)
}
80107e70:	c9                   	leave  
80107e71:	c3                   	ret    
80107e72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e80 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107e80:	a1 84 2b 19 80       	mov    0x80192b84,%eax
{
80107e85:	55                   	push   %ebp
80107e86:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107e88:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107e8d:	0f 22 d8             	mov    %eax,%cr3
}
80107e90:	5d                   	pop    %ebp
80107e91:	c3                   	ret    
80107e92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ea0 <switchuvm>:
{
80107ea0:	55                   	push   %ebp
80107ea1:	89 e5                	mov    %esp,%ebp
80107ea3:	57                   	push   %edi
80107ea4:	56                   	push   %esi
80107ea5:	53                   	push   %ebx
80107ea6:	83 ec 1c             	sub    $0x1c,%esp
80107ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80107eac:	85 db                	test   %ebx,%ebx
80107eae:	0f 84 cb 00 00 00    	je     80107f7f <switchuvm+0xdf>
  if(p->kstack == 0)
80107eb4:	8b 43 08             	mov    0x8(%ebx),%eax
80107eb7:	85 c0                	test   %eax,%eax
80107eb9:	0f 84 da 00 00 00    	je     80107f99 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107ebf:	8b 43 04             	mov    0x4(%ebx),%eax
80107ec2:	85 c0                	test   %eax,%eax
80107ec4:	0f 84 c2 00 00 00    	je     80107f8c <switchuvm+0xec>
  pushcli();
80107eca:	e8 61 d1 ff ff       	call   80105030 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107ecf:	e8 ac ba ff ff       	call   80103980 <mycpu>
80107ed4:	89 c6                	mov    %eax,%esi
80107ed6:	e8 a5 ba ff ff       	call   80103980 <mycpu>
80107edb:	89 c7                	mov    %eax,%edi
80107edd:	e8 9e ba ff ff       	call   80103980 <mycpu>
80107ee2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107ee5:	83 c7 08             	add    $0x8,%edi
80107ee8:	e8 93 ba ff ff       	call   80103980 <mycpu>
80107eed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107ef0:	83 c0 08             	add    $0x8,%eax
80107ef3:	ba 67 00 00 00       	mov    $0x67,%edx
80107ef8:	c1 e8 18             	shr    $0x18,%eax
80107efb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107f02:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107f09:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107f0f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107f14:	83 c1 08             	add    $0x8,%ecx
80107f17:	c1 e9 10             	shr    $0x10,%ecx
80107f1a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107f20:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107f25:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107f2c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107f31:	e8 4a ba ff ff       	call   80103980 <mycpu>
80107f36:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107f3d:	e8 3e ba ff ff       	call   80103980 <mycpu>
80107f42:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107f46:	8b 73 08             	mov    0x8(%ebx),%esi
80107f49:	e8 32 ba ff ff       	call   80103980 <mycpu>
80107f4e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107f54:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107f57:	e8 24 ba ff ff       	call   80103980 <mycpu>
80107f5c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107f60:	b8 28 00 00 00       	mov    $0x28,%eax
80107f65:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107f68:	8b 43 04             	mov    0x4(%ebx),%eax
80107f6b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f70:	0f 22 d8             	mov    %eax,%cr3
}
80107f73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f76:	5b                   	pop    %ebx
80107f77:	5e                   	pop    %esi
80107f78:	5f                   	pop    %edi
80107f79:	5d                   	pop    %ebp
  popcli();
80107f7a:	e9 f1 d0 ff ff       	jmp    80105070 <popcli>
    panic("switchuvm: no process");
80107f7f:	83 ec 0c             	sub    $0xc,%esp
80107f82:	68 62 90 10 80       	push   $0x80109062
80107f87:	e8 04 84 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107f8c:	83 ec 0c             	sub    $0xc,%esp
80107f8f:	68 8d 90 10 80       	push   $0x8010908d
80107f94:	e8 f7 83 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107f99:	83 ec 0c             	sub    $0xc,%esp
80107f9c:	68 78 90 10 80       	push   $0x80109078
80107fa1:	e8 ea 83 ff ff       	call   80100390 <panic>
80107fa6:	8d 76 00             	lea    0x0(%esi),%esi
80107fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107fb0 <inituvm>:
{
80107fb0:	55                   	push   %ebp
80107fb1:	89 e5                	mov    %esp,%ebp
80107fb3:	57                   	push   %edi
80107fb4:	56                   	push   %esi
80107fb5:	53                   	push   %ebx
80107fb6:	83 ec 1c             	sub    $0x1c,%esp
80107fb9:	8b 75 10             	mov    0x10(%ebp),%esi
80107fbc:	8b 45 08             	mov    0x8(%ebp),%eax
80107fbf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107fc2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107fc8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107fcb:	77 49                	ja     80108016 <inituvm+0x66>
  mem = kalloc();
80107fcd:	e8 ee a4 ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
80107fd2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107fd5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107fd7:	68 00 10 00 00       	push   $0x1000
80107fdc:	6a 00                	push   $0x0
80107fde:	50                   	push   %eax
80107fdf:	e8 2c d2 ff ff       	call   80105210 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107fe4:	58                   	pop    %eax
80107fe5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107feb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ff0:	5a                   	pop    %edx
80107ff1:	6a 06                	push   $0x6
80107ff3:	50                   	push   %eax
80107ff4:	31 d2                	xor    %edx,%edx
80107ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ff9:	e8 c2 fc ff ff       	call   80107cc0 <mappages>
  memmove(mem, init, sz);
80107ffe:	89 75 10             	mov    %esi,0x10(%ebp)
80108001:	89 7d 0c             	mov    %edi,0xc(%ebp)
80108004:	83 c4 10             	add    $0x10,%esp
80108007:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010800a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010800d:	5b                   	pop    %ebx
8010800e:	5e                   	pop    %esi
8010800f:	5f                   	pop    %edi
80108010:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108011:	e9 aa d2 ff ff       	jmp    801052c0 <memmove>
    panic("inituvm: more than a page");
80108016:	83 ec 0c             	sub    $0xc,%esp
80108019:	68 a1 90 10 80       	push   $0x801090a1
8010801e:	e8 6d 83 ff ff       	call   80100390 <panic>
80108023:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108030 <loaduvm>:
{
80108030:	55                   	push   %ebp
80108031:	89 e5                	mov    %esp,%ebp
80108033:	57                   	push   %edi
80108034:	56                   	push   %esi
80108035:	53                   	push   %ebx
80108036:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80108039:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80108040:	0f 85 91 00 00 00    	jne    801080d7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80108046:	8b 75 18             	mov    0x18(%ebp),%esi
80108049:	31 db                	xor    %ebx,%ebx
8010804b:	85 f6                	test   %esi,%esi
8010804d:	75 1a                	jne    80108069 <loaduvm+0x39>
8010804f:	eb 6f                	jmp    801080c0 <loaduvm+0x90>
80108051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108058:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010805e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80108064:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80108067:	76 57                	jbe    801080c0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108069:	8b 55 0c             	mov    0xc(%ebp),%edx
8010806c:	8b 45 08             	mov    0x8(%ebp),%eax
8010806f:	31 c9                	xor    %ecx,%ecx
80108071:	01 da                	add    %ebx,%edx
80108073:	e8 c8 fb ff ff       	call   80107c40 <walkpgdir>
80108078:	85 c0                	test   %eax,%eax
8010807a:	74 4e                	je     801080ca <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010807c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010807e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80108081:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80108086:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010808b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80108091:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108094:	01 d9                	add    %ebx,%ecx
80108096:	05 00 00 00 80       	add    $0x80000000,%eax
8010809b:	57                   	push   %edi
8010809c:	51                   	push   %ecx
8010809d:	50                   	push   %eax
8010809e:	ff 75 10             	pushl  0x10(%ebp)
801080a1:	e8 ba 98 ff ff       	call   80101960 <readi>
801080a6:	83 c4 10             	add    $0x10,%esp
801080a9:	39 f8                	cmp    %edi,%eax
801080ab:	74 ab                	je     80108058 <loaduvm+0x28>
}
801080ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801080b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801080b5:	5b                   	pop    %ebx
801080b6:	5e                   	pop    %esi
801080b7:	5f                   	pop    %edi
801080b8:	5d                   	pop    %ebp
801080b9:	c3                   	ret    
801080ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801080c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801080c3:	31 c0                	xor    %eax,%eax
}
801080c5:	5b                   	pop    %ebx
801080c6:	5e                   	pop    %esi
801080c7:	5f                   	pop    %edi
801080c8:	5d                   	pop    %ebp
801080c9:	c3                   	ret    
      panic("loaduvm: address should exist");
801080ca:	83 ec 0c             	sub    $0xc,%esp
801080cd:	68 bb 90 10 80       	push   $0x801090bb
801080d2:	e8 b9 82 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801080d7:	83 ec 0c             	sub    $0xc,%esp
801080da:	68 5c 91 10 80       	push   $0x8010915c
801080df:	e8 ac 82 ff ff       	call   80100390 <panic>
801080e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801080ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801080f0 <allocuvm>:
{
801080f0:	55                   	push   %ebp
801080f1:	89 e5                	mov    %esp,%ebp
801080f3:	57                   	push   %edi
801080f4:	56                   	push   %esi
801080f5:	53                   	push   %ebx
801080f6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801080f9:	8b 7d 10             	mov    0x10(%ebp),%edi
801080fc:	85 ff                	test   %edi,%edi
801080fe:	0f 88 8e 00 00 00    	js     80108192 <allocuvm+0xa2>
  if(newsz < oldsz)
80108104:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80108107:	0f 82 93 00 00 00    	jb     801081a0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010810d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108110:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80108116:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010811c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010811f:	0f 86 7e 00 00 00    	jbe    801081a3 <allocuvm+0xb3>
80108125:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80108128:	8b 7d 08             	mov    0x8(%ebp),%edi
8010812b:	eb 42                	jmp    8010816f <allocuvm+0x7f>
8010812d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80108130:	83 ec 04             	sub    $0x4,%esp
80108133:	68 00 10 00 00       	push   $0x1000
80108138:	6a 00                	push   $0x0
8010813a:	50                   	push   %eax
8010813b:	e8 d0 d0 ff ff       	call   80105210 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108140:	58                   	pop    %eax
80108141:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80108147:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010814c:	5a                   	pop    %edx
8010814d:	6a 06                	push   $0x6
8010814f:	50                   	push   %eax
80108150:	89 da                	mov    %ebx,%edx
80108152:	89 f8                	mov    %edi,%eax
80108154:	e8 67 fb ff ff       	call   80107cc0 <mappages>
80108159:	83 c4 10             	add    $0x10,%esp
8010815c:	85 c0                	test   %eax,%eax
8010815e:	78 50                	js     801081b0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80108160:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108166:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80108169:	0f 86 81 00 00 00    	jbe    801081f0 <allocuvm+0x100>
    mem = kalloc();
8010816f:	e8 4c a3 ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
80108174:	85 c0                	test   %eax,%eax
    mem = kalloc();
80108176:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80108178:	75 b6                	jne    80108130 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010817a:	83 ec 0c             	sub    $0xc,%esp
8010817d:	68 d9 90 10 80       	push   $0x801090d9
80108182:	e8 d9 84 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80108187:	83 c4 10             	add    $0x10,%esp
8010818a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010818d:	39 45 10             	cmp    %eax,0x10(%ebp)
80108190:	77 6e                	ja     80108200 <allocuvm+0x110>
}
80108192:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80108195:	31 ff                	xor    %edi,%edi
}
80108197:	89 f8                	mov    %edi,%eax
80108199:	5b                   	pop    %ebx
8010819a:	5e                   	pop    %esi
8010819b:	5f                   	pop    %edi
8010819c:	5d                   	pop    %ebp
8010819d:	c3                   	ret    
8010819e:	66 90                	xchg   %ax,%ax
    return oldsz;
801081a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801081a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081a6:	89 f8                	mov    %edi,%eax
801081a8:	5b                   	pop    %ebx
801081a9:	5e                   	pop    %esi
801081aa:	5f                   	pop    %edi
801081ab:	5d                   	pop    %ebp
801081ac:	c3                   	ret    
801081ad:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801081b0:	83 ec 0c             	sub    $0xc,%esp
801081b3:	68 f1 90 10 80       	push   $0x801090f1
801081b8:	e8 a3 84 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801081bd:	83 c4 10             	add    $0x10,%esp
801081c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801081c3:	39 45 10             	cmp    %eax,0x10(%ebp)
801081c6:	76 0d                	jbe    801081d5 <allocuvm+0xe5>
801081c8:	89 c1                	mov    %eax,%ecx
801081ca:	8b 55 10             	mov    0x10(%ebp),%edx
801081cd:	8b 45 08             	mov    0x8(%ebp),%eax
801081d0:	e8 7b fb ff ff       	call   80107d50 <deallocuvm.part.0>
      kfree(mem);
801081d5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801081d8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801081da:	56                   	push   %esi
801081db:	e8 30 a1 ff ff       	call   80102310 <kfree>
      return 0;
801081e0:	83 c4 10             	add    $0x10,%esp
}
801081e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081e6:	89 f8                	mov    %edi,%eax
801081e8:	5b                   	pop    %ebx
801081e9:	5e                   	pop    %esi
801081ea:	5f                   	pop    %edi
801081eb:	5d                   	pop    %ebp
801081ec:	c3                   	ret    
801081ed:	8d 76 00             	lea    0x0(%esi),%esi
801081f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801081f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081f6:	5b                   	pop    %ebx
801081f7:	89 f8                	mov    %edi,%eax
801081f9:	5e                   	pop    %esi
801081fa:	5f                   	pop    %edi
801081fb:	5d                   	pop    %ebp
801081fc:	c3                   	ret    
801081fd:	8d 76 00             	lea    0x0(%esi),%esi
80108200:	89 c1                	mov    %eax,%ecx
80108202:	8b 55 10             	mov    0x10(%ebp),%edx
80108205:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80108208:	31 ff                	xor    %edi,%edi
8010820a:	e8 41 fb ff ff       	call   80107d50 <deallocuvm.part.0>
8010820f:	eb 92                	jmp    801081a3 <allocuvm+0xb3>
80108211:	eb 0d                	jmp    80108220 <deallocuvm>
80108213:	90                   	nop
80108214:	90                   	nop
80108215:	90                   	nop
80108216:	90                   	nop
80108217:	90                   	nop
80108218:	90                   	nop
80108219:	90                   	nop
8010821a:	90                   	nop
8010821b:	90                   	nop
8010821c:	90                   	nop
8010821d:	90                   	nop
8010821e:	90                   	nop
8010821f:	90                   	nop

80108220 <deallocuvm>:
{
80108220:	55                   	push   %ebp
80108221:	89 e5                	mov    %esp,%ebp
80108223:	8b 55 0c             	mov    0xc(%ebp),%edx
80108226:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108229:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010822c:	39 d1                	cmp    %edx,%ecx
8010822e:	73 10                	jae    80108240 <deallocuvm+0x20>
}
80108230:	5d                   	pop    %ebp
80108231:	e9 1a fb ff ff       	jmp    80107d50 <deallocuvm.part.0>
80108236:	8d 76 00             	lea    0x0(%esi),%esi
80108239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80108240:	89 d0                	mov    %edx,%eax
80108242:	5d                   	pop    %ebp
80108243:	c3                   	ret    
80108244:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010824a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108250 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108250:	55                   	push   %ebp
80108251:	89 e5                	mov    %esp,%ebp
80108253:	57                   	push   %edi
80108254:	56                   	push   %esi
80108255:	53                   	push   %ebx
80108256:	83 ec 0c             	sub    $0xc,%esp
80108259:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010825c:	85 f6                	test   %esi,%esi
8010825e:	74 59                	je     801082b9 <freevm+0x69>
80108260:	31 c9                	xor    %ecx,%ecx
80108262:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108267:	89 f0                	mov    %esi,%eax
80108269:	e8 e2 fa ff ff       	call   80107d50 <deallocuvm.part.0>
8010826e:	89 f3                	mov    %esi,%ebx
80108270:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108276:	eb 0f                	jmp    80108287 <freevm+0x37>
80108278:	90                   	nop
80108279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108280:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108283:	39 fb                	cmp    %edi,%ebx
80108285:	74 23                	je     801082aa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108287:	8b 03                	mov    (%ebx),%eax
80108289:	a8 01                	test   $0x1,%al
8010828b:	74 f3                	je     80108280 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010828d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108292:	83 ec 0c             	sub    $0xc,%esp
80108295:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108298:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010829d:	50                   	push   %eax
8010829e:	e8 6d a0 ff ff       	call   80102310 <kfree>
801082a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801082a6:	39 fb                	cmp    %edi,%ebx
801082a8:	75 dd                	jne    80108287 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801082aa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801082ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082b0:	5b                   	pop    %ebx
801082b1:	5e                   	pop    %esi
801082b2:	5f                   	pop    %edi
801082b3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801082b4:	e9 57 a0 ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
801082b9:	83 ec 0c             	sub    $0xc,%esp
801082bc:	68 0d 91 10 80       	push   $0x8010910d
801082c1:	e8 ca 80 ff ff       	call   80100390 <panic>
801082c6:	8d 76 00             	lea    0x0(%esi),%esi
801082c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801082d0 <setupkvm>:
{
801082d0:	55                   	push   %ebp
801082d1:	89 e5                	mov    %esp,%ebp
801082d3:	56                   	push   %esi
801082d4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801082d5:	e8 e6 a1 ff ff       	call   801024c0 <kalloc>
801082da:	85 c0                	test   %eax,%eax
801082dc:	89 c6                	mov    %eax,%esi
801082de:	74 42                	je     80108322 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801082e0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801082e3:	bb 80 c4 10 80       	mov    $0x8010c480,%ebx
  memset(pgdir, 0, PGSIZE);
801082e8:	68 00 10 00 00       	push   $0x1000
801082ed:	6a 00                	push   $0x0
801082ef:	50                   	push   %eax
801082f0:	e8 1b cf ff ff       	call   80105210 <memset>
801082f5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801082f8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801082fb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801082fe:	83 ec 08             	sub    $0x8,%esp
80108301:	8b 13                	mov    (%ebx),%edx
80108303:	ff 73 0c             	pushl  0xc(%ebx)
80108306:	50                   	push   %eax
80108307:	29 c1                	sub    %eax,%ecx
80108309:	89 f0                	mov    %esi,%eax
8010830b:	e8 b0 f9 ff ff       	call   80107cc0 <mappages>
80108310:	83 c4 10             	add    $0x10,%esp
80108313:	85 c0                	test   %eax,%eax
80108315:	78 19                	js     80108330 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108317:	83 c3 10             	add    $0x10,%ebx
8010831a:	81 fb c0 c4 10 80    	cmp    $0x8010c4c0,%ebx
80108320:	75 d6                	jne    801082f8 <setupkvm+0x28>
}
80108322:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108325:	89 f0                	mov    %esi,%eax
80108327:	5b                   	pop    %ebx
80108328:	5e                   	pop    %esi
80108329:	5d                   	pop    %ebp
8010832a:	c3                   	ret    
8010832b:	90                   	nop
8010832c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80108330:	83 ec 0c             	sub    $0xc,%esp
80108333:	56                   	push   %esi
      return 0;
80108334:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108336:	e8 15 ff ff ff       	call   80108250 <freevm>
      return 0;
8010833b:	83 c4 10             	add    $0x10,%esp
}
8010833e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108341:	89 f0                	mov    %esi,%eax
80108343:	5b                   	pop    %ebx
80108344:	5e                   	pop    %esi
80108345:	5d                   	pop    %ebp
80108346:	c3                   	ret    
80108347:	89 f6                	mov    %esi,%esi
80108349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108350 <kvmalloc>:
{
80108350:	55                   	push   %ebp
80108351:	89 e5                	mov    %esp,%ebp
80108353:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108356:	e8 75 ff ff ff       	call   801082d0 <setupkvm>
8010835b:	a3 84 2b 19 80       	mov    %eax,0x80192b84
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108360:	05 00 00 00 80       	add    $0x80000000,%eax
80108365:	0f 22 d8             	mov    %eax,%cr3
}
80108368:	c9                   	leave  
80108369:	c3                   	ret    
8010836a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108370 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108370:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108371:	31 c9                	xor    %ecx,%ecx
{
80108373:	89 e5                	mov    %esp,%ebp
80108375:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108378:	8b 55 0c             	mov    0xc(%ebp),%edx
8010837b:	8b 45 08             	mov    0x8(%ebp),%eax
8010837e:	e8 bd f8 ff ff       	call   80107c40 <walkpgdir>
  if(pte == 0)
80108383:	85 c0                	test   %eax,%eax
80108385:	74 05                	je     8010838c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80108387:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010838a:	c9                   	leave  
8010838b:	c3                   	ret    
    panic("clearpteu");
8010838c:	83 ec 0c             	sub    $0xc,%esp
8010838f:	68 1e 91 10 80       	push   $0x8010911e
80108394:	e8 f7 7f ff ff       	call   80100390 <panic>
80108399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801083a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801083a0:	55                   	push   %ebp
801083a1:	89 e5                	mov    %esp,%ebp
801083a3:	57                   	push   %edi
801083a4:	56                   	push   %esi
801083a5:	53                   	push   %ebx
801083a6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801083a9:	e8 22 ff ff ff       	call   801082d0 <setupkvm>
801083ae:	85 c0                	test   %eax,%eax
801083b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801083b3:	0f 84 9f 00 00 00    	je     80108458 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801083b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801083bc:	85 c9                	test   %ecx,%ecx
801083be:	0f 84 94 00 00 00    	je     80108458 <copyuvm+0xb8>
801083c4:	31 ff                	xor    %edi,%edi
801083c6:	eb 4a                	jmp    80108412 <copyuvm+0x72>
801083c8:	90                   	nop
801083c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801083d0:	83 ec 04             	sub    $0x4,%esp
801083d3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801083d9:	68 00 10 00 00       	push   $0x1000
801083de:	53                   	push   %ebx
801083df:	50                   	push   %eax
801083e0:	e8 db ce ff ff       	call   801052c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801083e5:	58                   	pop    %eax
801083e6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801083ec:	b9 00 10 00 00       	mov    $0x1000,%ecx
801083f1:	5a                   	pop    %edx
801083f2:	ff 75 e4             	pushl  -0x1c(%ebp)
801083f5:	50                   	push   %eax
801083f6:	89 fa                	mov    %edi,%edx
801083f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083fb:	e8 c0 f8 ff ff       	call   80107cc0 <mappages>
80108400:	83 c4 10             	add    $0x10,%esp
80108403:	85 c0                	test   %eax,%eax
80108405:	78 61                	js     80108468 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80108407:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010840d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80108410:	76 46                	jbe    80108458 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108412:	8b 45 08             	mov    0x8(%ebp),%eax
80108415:	31 c9                	xor    %ecx,%ecx
80108417:	89 fa                	mov    %edi,%edx
80108419:	e8 22 f8 ff ff       	call   80107c40 <walkpgdir>
8010841e:	85 c0                	test   %eax,%eax
80108420:	74 61                	je     80108483 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80108422:	8b 00                	mov    (%eax),%eax
80108424:	a8 01                	test   $0x1,%al
80108426:	74 4e                	je     80108476 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80108428:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010842a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010842f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80108435:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108438:	e8 83 a0 ff ff       	call   801024c0 <kalloc>
8010843d:	85 c0                	test   %eax,%eax
8010843f:	89 c6                	mov    %eax,%esi
80108441:	75 8d                	jne    801083d0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80108443:	83 ec 0c             	sub    $0xc,%esp
80108446:	ff 75 e0             	pushl  -0x20(%ebp)
80108449:	e8 02 fe ff ff       	call   80108250 <freevm>
  return 0;
8010844e:	83 c4 10             	add    $0x10,%esp
80108451:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80108458:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010845b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010845e:	5b                   	pop    %ebx
8010845f:	5e                   	pop    %esi
80108460:	5f                   	pop    %edi
80108461:	5d                   	pop    %ebp
80108462:	c3                   	ret    
80108463:	90                   	nop
80108464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108468:	83 ec 0c             	sub    $0xc,%esp
8010846b:	56                   	push   %esi
8010846c:	e8 9f 9e ff ff       	call   80102310 <kfree>
      goto bad;
80108471:	83 c4 10             	add    $0x10,%esp
80108474:	eb cd                	jmp    80108443 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80108476:	83 ec 0c             	sub    $0xc,%esp
80108479:	68 42 91 10 80       	push   $0x80109142
8010847e:	e8 0d 7f ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108483:	83 ec 0c             	sub    $0xc,%esp
80108486:	68 28 91 10 80       	push   $0x80109128
8010848b:	e8 00 7f ff ff       	call   80100390 <panic>

80108490 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108490:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108491:	31 c9                	xor    %ecx,%ecx
{
80108493:	89 e5                	mov    %esp,%ebp
80108495:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108498:	8b 55 0c             	mov    0xc(%ebp),%edx
8010849b:	8b 45 08             	mov    0x8(%ebp),%eax
8010849e:	e8 9d f7 ff ff       	call   80107c40 <walkpgdir>
  if((*pte & PTE_P) == 0)
801084a3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801084a5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801084a6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801084a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801084ad:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801084b0:	05 00 00 00 80       	add    $0x80000000,%eax
801084b5:	83 fa 05             	cmp    $0x5,%edx
801084b8:	ba 00 00 00 00       	mov    $0x0,%edx
801084bd:	0f 45 c2             	cmovne %edx,%eax
}
801084c0:	c3                   	ret    
801084c1:	eb 0d                	jmp    801084d0 <copyout>
801084c3:	90                   	nop
801084c4:	90                   	nop
801084c5:	90                   	nop
801084c6:	90                   	nop
801084c7:	90                   	nop
801084c8:	90                   	nop
801084c9:	90                   	nop
801084ca:	90                   	nop
801084cb:	90                   	nop
801084cc:	90                   	nop
801084cd:	90                   	nop
801084ce:	90                   	nop
801084cf:	90                   	nop

801084d0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801084d0:	55                   	push   %ebp
801084d1:	89 e5                	mov    %esp,%ebp
801084d3:	57                   	push   %edi
801084d4:	56                   	push   %esi
801084d5:	53                   	push   %ebx
801084d6:	83 ec 1c             	sub    $0x1c,%esp
801084d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801084dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801084df:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801084e2:	85 db                	test   %ebx,%ebx
801084e4:	75 40                	jne    80108526 <copyout+0x56>
801084e6:	eb 70                	jmp    80108558 <copyout+0x88>
801084e8:	90                   	nop
801084e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801084f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801084f3:	89 f1                	mov    %esi,%ecx
801084f5:	29 d1                	sub    %edx,%ecx
801084f7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801084fd:	39 d9                	cmp    %ebx,%ecx
801084ff:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108502:	29 f2                	sub    %esi,%edx
80108504:	83 ec 04             	sub    $0x4,%esp
80108507:	01 d0                	add    %edx,%eax
80108509:	51                   	push   %ecx
8010850a:	57                   	push   %edi
8010850b:	50                   	push   %eax
8010850c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010850f:	e8 ac cd ff ff       	call   801052c0 <memmove>
    len -= n;
    buf += n;
80108514:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80108517:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010851a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80108520:	01 cf                	add    %ecx,%edi
  while(len > 0){
80108522:	29 cb                	sub    %ecx,%ebx
80108524:	74 32                	je     80108558 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108526:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108528:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010852b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010852e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108534:	56                   	push   %esi
80108535:	ff 75 08             	pushl  0x8(%ebp)
80108538:	e8 53 ff ff ff       	call   80108490 <uva2ka>
    if(pa0 == 0)
8010853d:	83 c4 10             	add    $0x10,%esp
80108540:	85 c0                	test   %eax,%eax
80108542:	75 ac                	jne    801084f0 <copyout+0x20>
  }
  return 0;
}
80108544:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108547:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010854c:	5b                   	pop    %ebx
8010854d:	5e                   	pop    %esi
8010854e:	5f                   	pop    %edi
8010854f:	5d                   	pop    %ebp
80108550:	c3                   	ret    
80108551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108558:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010855b:	31 c0                	xor    %eax,%eax
}
8010855d:	5b                   	pop    %ebx
8010855e:	5e                   	pop    %esi
8010855f:	5f                   	pop    %edi
80108560:	5d                   	pop    %ebp
80108561:	c3                   	ret    
