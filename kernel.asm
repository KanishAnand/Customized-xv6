
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc 60 c6 10 80       	mov    $0x8010c660,%esp

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
80100044:	bb 94 c6 10 80       	mov    $0x8010c694,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 80 10 80       	push   $0x80108060
80100051:	68 60 c6 10 80       	push   $0x8010c660
80100056:	e8 f5 4c 00 00       	call   80104d50 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 ac 0d 11 80 5c 	movl   $0x80110d5c,0x80110dac
80100062:	0d 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 b0 0d 11 80 5c 	movl   $0x80110d5c,0x80110db0
8010006c:	0d 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba 5c 0d 11 80       	mov    $0x80110d5c,%edx
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
8010008b:	c7 43 50 5c 0d 11 80 	movl   $0x80110d5c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 80 10 80       	push   $0x80108067
80100097:	50                   	push   %eax
80100098:	e8 83 4b 00 00       	call   80104c20 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d b0 0d 11 80    	mov    %ebx,0x80110db0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 5c 0d 11 80       	cmp    $0x80110d5c,%eax
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
801000df:	68 60 c6 10 80       	push   $0x8010c660
801000e4:	e8 a7 4d 00 00       	call   80104e90 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d b0 0d 11 80    	mov    0x80110db0,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 5c 0d 11 80    	cmp    $0x80110d5c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 5c 0d 11 80    	cmp    $0x80110d5c,%ebx
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
80100120:	8b 1d ac 0d 11 80    	mov    0x80110dac,%ebx
80100126:	81 fb 5c 0d 11 80    	cmp    $0x80110d5c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 5c 0d 11 80    	cmp    $0x80110d5c,%ebx
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
8010015d:	68 60 c6 10 80       	push   $0x8010c660
80100162:	e8 e9 4d 00 00       	call   80104f50 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 4a 00 00       	call   80104c60 <acquiresleep>
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
80100193:	68 6e 80 10 80       	push   $0x8010806e
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
801001ae:	e8 4d 4b 00 00       	call   80104d00 <holdingsleep>
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
801001cc:	68 7f 80 10 80       	push   $0x8010807f
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
801001ef:	e8 0c 4b 00 00       	call   80104d00 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 4a 00 00       	call   80104cc0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010020b:	e8 80 4c 00 00       	call   80104e90 <acquire>
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
80100232:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 5c 0d 11 80 	movl   $0x80110d5c,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 b0 0d 11 80       	mov    0x80110db0,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d b0 0d 11 80    	mov    %ebx,0x80110db0
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 60 c6 10 80 	movl   $0x8010c660,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 ef 4c 00 00       	jmp    80104f50 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 80 10 80       	push   $0x80108086
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
80100285:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
8010028c:	e8 ff 4b 00 00       	call   80104e90 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 40 10 11 80    	mov    0x80111040,%edx
801002a7:	39 15 44 10 11 80    	cmp    %edx,0x80111044
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
801002bb:	68 80 b5 10 80       	push   $0x8010b580
801002c0:	68 40 10 11 80       	push   $0x80111040
801002c5:	e8 46 43 00 00       	call   80104610 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 40 10 11 80    	mov    0x80111040,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 44 10 11 80    	cmp    0x80111044,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 c0 35 00 00       	call   801038a0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 80 b5 10 80       	push   $0x8010b580
801002ef:	e8 5c 4c 00 00       	call   80104f50 <release>
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
80100313:	a3 40 10 11 80       	mov    %eax,0x80111040
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 c0 0f 11 80 	movsbl -0x7feef040(%eax),%eax
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
80100348:	68 80 b5 10 80       	push   $0x8010b580
8010034d:	e8 fe 4b 00 00       	call   80104f50 <release>
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
80100372:	89 15 40 10 11 80    	mov    %edx,0x80111040
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
80100399:	c7 05 b4 b5 10 80 00 	movl   $0x0,0x8010b5b4
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 8d 80 10 80       	push   $0x8010808d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 23 8b 10 80 	movl   $0x80108b23,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 93 49 00 00       	call   80104d70 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 a1 80 10 80       	push   $0x801080a1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 b8 b5 10 80 01 	movl   $0x1,0x8010b5b8
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
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
8010043a:	e8 31 68 00 00       	call   80106c70 <uartputc>
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
801004ec:	e8 7f 67 00 00       	call   80106c70 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 73 67 00 00       	call   80106c70 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 67 67 00 00       	call   80106c70 <uartputc>
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
80100524:	e8 27 4b 00 00       	call   80105050 <memmove>
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
80100541:	e8 5a 4a 00 00       	call   80104fa0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 a5 80 10 80       	push   $0x801080a5
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
801005b1:	0f b6 92 d0 80 10 80 	movzbl -0x7fef7f30(%edx),%edx
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
80100614:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
8010061b:	e8 70 48 00 00       	call   80104e90 <acquire>
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
80100642:	68 80 b5 10 80       	push   $0x8010b580
80100647:	e8 04 49 00 00       	call   80104f50 <release>
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
80100669:	a1 b4 b5 10 80       	mov    0x8010b5b4,%eax
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
8010071a:	68 80 b5 10 80       	push   $0x8010b580
8010071f:	e8 2c 48 00 00       	call   80104f50 <release>
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
801007d0:	ba b8 80 10 80       	mov    $0x801080b8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 80 b5 10 80       	push   $0x8010b580
801007f0:	e8 9b 46 00 00       	call   80104e90 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 bf 80 10 80       	push   $0x801080bf
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
8010081e:	68 80 b5 10 80       	push   $0x8010b580
80100823:	e8 68 46 00 00       	call   80104e90 <acquire>
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
80100851:	a1 48 10 11 80       	mov    0x80111048,%eax
80100856:	3b 05 44 10 11 80    	cmp    0x80111044,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 48 10 11 80       	mov    %eax,0x80111048
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
80100883:	68 80 b5 10 80       	push   $0x8010b580
80100888:	e8 c3 46 00 00       	call   80104f50 <release>
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
801008a9:	a1 48 10 11 80       	mov    0x80111048,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 40 10 11 80    	sub    0x80111040,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 48 10 11 80    	mov    %edx,0x80111048
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 c0 0f 11 80    	mov    %cl,-0x7feef040(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 40 10 11 80       	mov    0x80111040,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 48 10 11 80    	cmp    %eax,0x80111048
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 44 10 11 80       	mov    %eax,0x80111044
          wakeup(&input.r);
80100911:	68 40 10 11 80       	push   $0x80111040
80100916:	e8 d5 3f 00 00       	call   801048f0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 48 10 11 80       	mov    0x80111048,%eax
8010093d:	39 05 44 10 11 80    	cmp    %eax,0x80111044
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 48 10 11 80       	mov    %eax,0x80111048
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 48 10 11 80       	mov    0x80111048,%eax
80100964:	3b 05 44 10 11 80    	cmp    0x80111044,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba c0 0f 11 80 0a 	cmpb   $0xa,-0x7feef040(%edx)
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
80100997:	e9 34 40 00 00       	jmp    801049d0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 c0 0f 11 80 0a 	movb   $0xa,-0x7feef040(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 48 10 11 80       	mov    0x80111048,%eax
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
801009c6:	68 c8 80 10 80       	push   $0x801080c8
801009cb:	68 80 b5 10 80       	push   $0x8010b580
801009d0:	e8 7b 43 00 00       	call   80104d50 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 0c 1a 11 80 00 	movl   $0x80100600,0x80111a0c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 08 1a 11 80 70 	movl   $0x80100270,0x80111a08
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 b4 b5 10 80 01 	movl   $0x1,0x8010b5b4
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
80100a1c:	e8 7f 2e 00 00       	call   801038a0 <myproc>
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
80100a94:	e8 27 73 00 00       	call   80107dc0 <setupkvm>
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
80100af6:	e8 e5 70 00 00       	call   80107be0 <allocuvm>
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
80100b28:	e8 f3 6f 00 00       	call   80107b20 <loaduvm>
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
80100b72:	e8 c9 71 00 00       	call   80107d40 <freevm>
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
80100baa:	e8 31 70 00 00       	call   80107be0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 7a 71 00 00       	call   80107d40 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 e1 80 10 80       	push   $0x801080e1
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
80100c06:	e8 55 72 00 00       	call   80107e60 <clearpteu>
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
80100c39:	e8 82 45 00 00       	call   801051c0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 6f 45 00 00       	call   801051c0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 5e 73 00 00       	call   80107fc0 <copyout>
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
80100cc7:	e8 f4 72 00 00       	call   80107fc0 <copyout>
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
80100d0a:	e8 71 44 00 00       	call   80105180 <safestrcpy>
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
80100d34:	e8 57 6c 00 00       	call   80107990 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 ff 6f 00 00       	call   80107d40 <freevm>
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
80100d66:	68 ed 80 10 80       	push   $0x801080ed
80100d6b:	68 60 10 11 80       	push   $0x80111060
80100d70:	e8 db 3f 00 00       	call   80104d50 <initlock>
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
80100d84:	bb 94 10 11 80       	mov    $0x80111094,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 60 10 11 80       	push   $0x80111060
80100d91:	e8 fa 40 00 00       	call   80104e90 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb f4 19 11 80    	cmp    $0x801119f4,%ebx
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
80100dbc:	68 60 10 11 80       	push   $0x80111060
80100dc1:	e8 8a 41 00 00       	call   80104f50 <release>
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
80100dd5:	68 60 10 11 80       	push   $0x80111060
80100dda:	e8 71 41 00 00       	call   80104f50 <release>
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
80100dfa:	68 60 10 11 80       	push   $0x80111060
80100dff:	e8 8c 40 00 00       	call   80104e90 <acquire>
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
80100e17:	68 60 10 11 80       	push   $0x80111060
80100e1c:	e8 2f 41 00 00       	call   80104f50 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 f4 80 10 80       	push   $0x801080f4
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
80100e4c:	68 60 10 11 80       	push   $0x80111060
80100e51:	e8 3a 40 00 00       	call   80104e90 <acquire>
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
80100e6e:	c7 45 08 60 10 11 80 	movl   $0x80111060,0x8(%ebp)
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
80100e7c:	e9 cf 40 00 00       	jmp    80104f50 <release>
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
80100ea0:	68 60 10 11 80       	push   $0x80111060
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 a3 40 00 00       	call   80104f50 <release>
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
80100f02:	68 fc 80 10 80       	push   $0x801080fc
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
80100fe2:	68 06 81 10 80       	push   $0x80108106
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
801010f5:	68 0f 81 10 80       	push   $0x8010810f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 15 81 10 80       	push   $0x80108115
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
8010111a:	03 15 78 1a 11 80    	add    0x80111a78,%edx
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
80101173:	68 1f 81 10 80       	push   $0x8010811f
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
80101189:	8b 0d 60 1a 11 80    	mov    0x80111a60,%ecx
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
801011ac:	03 05 78 1a 11 80    	add    0x80111a78,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 60 1a 11 80       	mov    0x80111a60,%eax
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
80101219:	39 05 60 1a 11 80    	cmp    %eax,0x80111a60
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 32 81 10 80       	push   $0x80108132
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
80101265:	e8 36 3d 00 00       	call   80104fa0 <memset>
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
8010129a:	bb b4 1a 11 80       	mov    $0x80111ab4,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 80 1a 11 80       	push   $0x80111a80
801012aa:	e8 e1 3b 00 00       	call   80104e90 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb d4 36 11 80    	cmp    $0x801136d4,%ebx
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
801012e8:	81 fb d4 36 11 80    	cmp    $0x801136d4,%ebx
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
8010130a:	68 80 1a 11 80       	push   $0x80111a80
8010130f:	e8 3c 3c 00 00       	call   80104f50 <release>

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
80101335:	68 80 1a 11 80       	push   $0x80111a80
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 0e 3c 00 00       	call   80104f50 <release>
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
80101352:	68 48 81 10 80       	push   $0x80108148
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
80101427:	68 58 81 10 80       	push   $0x80108158
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
80101461:	e8 ea 3b 00 00       	call   80105050 <memmove>
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
80101484:	bb c0 1a 11 80       	mov    $0x80111ac0,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 6b 81 10 80       	push   $0x8010816b
80101491:	68 80 1a 11 80       	push   $0x80111a80
80101496:	e8 b5 38 00 00       	call   80104d50 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 72 81 10 80       	push   $0x80108172
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 6c 37 00 00       	call   80104c20 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb e0 36 11 80    	cmp    $0x801136e0,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 60 1a 11 80       	push   $0x80111a60
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 78 1a 11 80    	pushl  0x80111a78
801014d5:	ff 35 74 1a 11 80    	pushl  0x80111a74
801014db:	ff 35 70 1a 11 80    	pushl  0x80111a70
801014e1:	ff 35 6c 1a 11 80    	pushl  0x80111a6c
801014e7:	ff 35 68 1a 11 80    	pushl  0x80111a68
801014ed:	ff 35 64 1a 11 80    	pushl  0x80111a64
801014f3:	ff 35 60 1a 11 80    	pushl  0x80111a60
801014f9:	68 d8 81 10 80       	push   $0x801081d8
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
80101519:	83 3d 68 1a 11 80 01 	cmpl   $0x1,0x80111a68
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
8010154f:	39 1d 68 1a 11 80    	cmp    %ebx,0x80111a68
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 74 1a 11 80    	add    0x80111a74,%eax
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
8010158e:	e8 0d 3a 00 00       	call   80104fa0 <memset>
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
801015c3:	68 78 81 10 80       	push   $0x80108178
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
801015e4:	03 05 74 1a 11 80    	add    0x80111a74,%eax
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
80101631:	e8 1a 3a 00 00       	call   80105050 <memmove>
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
8010165a:	68 80 1a 11 80       	push   $0x80111a80
8010165f:	e8 2c 38 00 00       	call   80104e90 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
8010166f:	e8 dc 38 00 00       	call   80104f50 <release>
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
801016a2:	e8 b9 35 00 00       	call   80104c60 <acquiresleep>
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
801016c9:	03 05 74 1a 11 80    	add    0x80111a74,%eax
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
80101718:	e8 33 39 00 00       	call   80105050 <memmove>
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
8010173d:	68 90 81 10 80       	push   $0x80108190
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 8a 81 10 80       	push   $0x8010818a
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
80101773:	e8 88 35 00 00       	call   80104d00 <holdingsleep>
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
8010178f:	e9 2c 35 00 00       	jmp    80104cc0 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 9f 81 10 80       	push   $0x8010819f
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
801017c0:	e8 9b 34 00 00       	call   80104c60 <acquiresleep>
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
801017da:	e8 e1 34 00 00       	call   80104cc0 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
801017e6:	e8 a5 36 00 00       	call   80104e90 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 80 1a 11 80 	movl   $0x80111a80,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 4b 37 00 00       	jmp    80104f50 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 80 1a 11 80       	push   $0x80111a80
80101810:	e8 7b 36 00 00       	call   80104e90 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
8010181f:	e8 2c 37 00 00       	call   80104f50 <release>
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
80101a07:	e8 44 36 00 00       	call   80105050 <memmove>
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
80101a3a:	8b 04 c5 00 1a 11 80 	mov    -0x7feee600(,%eax,8),%eax
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
80101b03:	e8 48 35 00 00       	call   80105050 <memmove>
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
80101b4a:	8b 04 c5 04 1a 11 80 	mov    -0x7feee5fc(,%eax,8),%eax
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
80101b9e:	e8 1d 35 00 00       	call   801050c0 <strncmp>
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
80101bfd:	e8 be 34 00 00       	call   801050c0 <strncmp>
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
80101c42:	68 b9 81 10 80       	push   $0x801081b9
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 a7 81 10 80       	push   $0x801081a7
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
80101c79:	e8 22 1c 00 00       	call   801038a0 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 80 1a 11 80       	push   $0x80111a80
80101c89:	e8 02 32 00 00       	call   80104e90 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101c99:	e8 b2 32 00 00       	call   80104f50 <release>
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
80101cf5:	e8 56 33 00 00       	call   80105050 <memmove>
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
80101d88:	e8 c3 32 00 00       	call   80105050 <memmove>
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
80101e7d:	e8 9e 32 00 00       	call   80105120 <strncpy>
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
80101ebb:	68 c8 81 10 80       	push   $0x801081c8
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 0a 89 10 80       	push   $0x8010890a
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
80101fdb:	68 34 82 10 80       	push   $0x80108234
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 2b 82 10 80       	push   $0x8010822b
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 46 82 10 80       	push   $0x80108246
8010200b:	68 e0 b5 10 80       	push   $0x8010b5e0
80102010:	e8 3b 2d 00 00       	call   80104d50 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102015:	58                   	pop    %eax
80102016:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
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
8010205a:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
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
80102089:	68 e0 b5 10 80       	push   $0x8010b5e0
8010208e:	e8 fd 2d 00 00       	call   80104e90 <acquire>

  if((b = idequeue) == 0){
80102093:	8b 1d c4 b5 10 80    	mov    0x8010b5c4,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 c4 b5 10 80       	mov    %eax,0x8010b5c4

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
801020f1:	e8 fa 27 00 00       	call   801048f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f6:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
    idestart(idequeue);
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
    release(&idelock);
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 e0 b5 10 80       	push   $0x8010b5e0
8010210f:	e8 3c 2e 00 00       	call   80104f50 <release>

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
8010212e:	e8 cd 2b 00 00       	call   80104d00 <holdingsleep>
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
80102153:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 e0 b5 10 80       	push   $0x8010b5e0
80102168:	e8 23 2d 00 00       	call   80104e90 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216d:	8b 15 c4 b5 10 80    	mov    0x8010b5c4,%edx
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
80102196:	39 1d c4 b5 10 80    	cmp    %ebx,0x8010b5c4
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
801021b3:	68 e0 b5 10 80       	push   $0x8010b5e0
801021b8:	53                   	push   %ebx
801021b9:	e8 52 24 00 00       	call   80104610 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
  }


  release(&idelock);
801021cb:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
  release(&idelock);
801021d6:	e9 75 2d 00 00       	jmp    80104f50 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f0:	ba c4 b5 10 80       	mov    $0x8010b5c4,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
    panic("iderw: nothing to do");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 60 82 10 80       	push   $0x80108260
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 4a 82 10 80       	push   $0x8010824a
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 75 82 10 80       	push   $0x80108275
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
80102221:	c7 05 d4 36 11 80 00 	movl   $0xfec00000,0x801136d4
80102228:	00 c0 fe 
{
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
  ioapic->reg = reg;
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
  return ioapic->data;
80102239:	a1 d4 36 11 80       	mov    0x801136d4,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102247:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010224d:	0f b6 15 00 38 11 80 	movzbl 0x80113800,%edx
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
80102267:	68 94 82 10 80       	push   $0x80108294
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
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
80102292:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx

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
801022b0:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
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
801022d1:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
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
801022e5:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801022f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f6:	a1 d4 36 11 80       	mov    0x801136d4,%eax
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
80102322:	81 fb 88 c3 11 80    	cmp    $0x8011c388,%ebx
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
80102342:	e8 59 2c 00 00       	call   80104fa0 <memset>

  if(kmem.use_lock)
80102347:	8b 15 14 37 11 80    	mov    0x80113714,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102354:	a1 18 37 11 80       	mov    0x80113718,%eax
80102359:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010235b:	a1 14 37 11 80       	mov    0x80113714,%eax
  kmem.freelist = r;
80102360:	89 1d 18 37 11 80    	mov    %ebx,0x80113718
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
80102370:	c7 45 08 e0 36 11 80 	movl   $0x801136e0,0x8(%ebp)
}
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
    release(&kmem.lock);
8010237b:	e9 d0 2b 00 00       	jmp    80104f50 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 e0 36 11 80       	push   $0x801136e0
80102388:	e8 03 2b 00 00       	call   80104e90 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 c6 82 10 80       	push   $0x801082c6
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
801023fb:	68 cc 82 10 80       	push   $0x801082cc
80102400:	68 e0 36 11 80       	push   $0x801136e0
80102405:	e8 46 29 00 00       	call   80104d50 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010240d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102410:	c7 05 14 37 11 80 00 	movl   $0x0,0x80113714
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
801024a4:	c7 05 14 37 11 80 01 	movl   $0x1,0x80113714
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
801024c0:	a1 14 37 11 80       	mov    0x80113714,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c9:	a1 18 37 11 80       	mov    0x80113718,%eax
  if(r)
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
    kmem.freelist = r->next;
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 18 37 11 80    	mov    %edx,0x80113718
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
801024ee:	68 e0 36 11 80       	push   $0x801136e0
801024f3:	e8 98 29 00 00       	call   80104e90 <acquire>
  r = kmem.freelist;
801024f8:	a1 18 37 11 80       	mov    0x80113718,%eax
  if(r)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 14 37 11 80    	mov    0x80113714,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
    kmem.freelist = r->next;
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d 18 37 11 80    	mov    %ecx,0x80113718
  if(kmem.use_lock)
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
    release(&kmem.lock);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 e0 36 11 80       	push   $0x801136e0
80102521:	e8 2a 2a 00 00       	call   80104f50 <release>
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
80102547:	8b 0d 14 b6 10 80    	mov    0x8010b614,%ecx

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
80102573:	0f b6 82 00 84 10 80 	movzbl -0x7fef7c00(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 00 83 10 80 	movzbl -0x7fef7d00(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102585:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102587:	89 0d 14 b6 10 80    	mov    %ecx,0x8010b614
  c = charcode[shift & (CTL | SHIFT)][data];
8010258d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102590:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102593:	8b 04 85 e0 82 10 80 	mov    -0x7fef7d20(,%eax,4),%eax
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
801025b8:	0f b6 82 00 84 10 80 	movzbl -0x7fef7c00(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
    return 0;
801025c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025cb:	89 0d 14 b6 10 80    	mov    %ecx,0x8010b614
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
801025dd:	89 0d 14 b6 10 80    	mov    %ecx,0x8010b614
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
80102630:	a1 1c 37 11 80       	mov    0x8011371c,%eax
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
80102730:	8b 15 1c 37 11 80    	mov    0x8011371c,%edx
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
80102750:	a1 1c 37 11 80       	mov    0x8011371c,%eax
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
801027be:	a1 1c 37 11 80       	mov    0x8011371c,%eax
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
80102937:	e8 b4 26 00 00       	call   80104ff0 <memcmp>
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
80102a00:	8b 0d 68 37 11 80    	mov    0x80113768,%ecx
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
80102a20:	a1 54 37 11 80       	mov    0x80113754,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 64 37 11 80    	pushl  0x80113764
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d 6c 37 11 80 	pushl  -0x7feec894(,%ebx,4)
80102a44:	ff 35 64 37 11 80    	pushl  0x80113764
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
80102a64:	e8 e7 25 00 00       	call   80105050 <memmove>
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
80102a84:	39 1d 68 37 11 80    	cmp    %ebx,0x80113768
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
80102aa8:	ff 35 54 37 11 80    	pushl  0x80113754
80102aae:	ff 35 64 37 11 80    	pushl  0x80113764
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ab9:	8b 1d 68 37 11 80    	mov    0x80113768,%ebx
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
80102ad0:	8b 8a 6c 37 11 80    	mov    -0x7feec894(%edx),%ecx
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
80102b0a:	68 00 85 10 80       	push   $0x80108500
80102b0f:	68 20 37 11 80       	push   $0x80113720
80102b14:	e8 37 22 00 00       	call   80104d50 <initlock>
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
80102b2c:	89 1d 64 37 11 80    	mov    %ebx,0x80113764
  log.size = sb.nlog;
80102b32:	89 15 58 37 11 80    	mov    %edx,0x80113758
  log.start = sb.logstart;
80102b38:	a3 54 37 11 80       	mov    %eax,0x80113754
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
80102b4d:	89 1d 68 37 11 80    	mov    %ebx,0x80113768
  for (i = 0; i < log.lh.n; i++) {
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a 68 37 11 80    	mov    %ecx,-0x7feec898(%edx)
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
80102b7f:	c7 05 68 37 11 80 00 	movl   $0x0,0x80113768
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
80102ba6:	68 20 37 11 80       	push   $0x80113720
80102bab:	e8 e0 22 00 00       	call   80104e90 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 20 37 11 80       	push   $0x80113720
80102bc0:	68 20 37 11 80       	push   $0x80113720
80102bc5:	e8 46 1a 00 00       	call   80104610 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bcd:	a1 60 37 11 80       	mov    0x80113760,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bd6:	a1 5c 37 11 80       	mov    0x8011375c,%eax
80102bdb:	8b 15 68 37 11 80    	mov    0x80113768,%edx
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
80102bf2:	a3 5c 37 11 80       	mov    %eax,0x8011375c
      release(&log.lock);
80102bf7:	68 20 37 11 80       	push   $0x80113720
80102bfc:	e8 4f 23 00 00       	call   80104f50 <release>
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
80102c19:	68 20 37 11 80       	push   $0x80113720
80102c1e:	e8 6d 22 00 00       	call   80104e90 <acquire>
  log.outstanding -= 1;
80102c23:	a1 5c 37 11 80       	mov    0x8011375c,%eax
  if(log.committing)
80102c28:	8b 35 60 37 11 80    	mov    0x80113760,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c34:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c36:	89 1d 5c 37 11 80    	mov    %ebx,0x8011375c
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
80102c4d:	c7 05 60 37 11 80 01 	movl   $0x1,0x80113760
80102c54:	00 00 00 
  release(&log.lock);
80102c57:	68 20 37 11 80       	push   $0x80113720
80102c5c:	e8 ef 22 00 00       	call   80104f50 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c61:	8b 0d 68 37 11 80    	mov    0x80113768,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c72:	a1 54 37 11 80       	mov    0x80113754,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 64 37 11 80    	pushl  0x80113764
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d 6c 37 11 80 	pushl  -0x7feec894(,%ebx,4)
80102c96:	ff 35 64 37 11 80    	pushl  0x80113764
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
80102cb6:	e8 95 23 00 00       	call   80105050 <memmove>
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
80102cd6:	3b 1d 68 37 11 80    	cmp    0x80113768,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
    install_trans(); // Now install writes to home locations
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
    log.lh.n = 0;
80102ce8:	c7 05 68 37 11 80 00 	movl   $0x0,0x80113768
80102cef:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
    acquire(&log.lock);
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 20 37 11 80       	push   $0x80113720
80102cff:	e8 8c 21 00 00       	call   80104e90 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
    log.committing = 0;
80102d0b:	c7 05 60 37 11 80 00 	movl   $0x0,0x80113760
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 d6 1b 00 00       	call   801048f0 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80102d21:	e8 2a 22 00 00       	call   80104f50 <release>
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
80102d3b:	68 20 37 11 80       	push   $0x80113720
80102d40:	e8 ab 1b 00 00       	call   801048f0 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80102d4c:	e8 ff 21 00 00       	call   80104f50 <release>
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
80102d5f:	68 04 85 10 80       	push   $0x80108504
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
80102d77:	8b 15 68 37 11 80    	mov    0x80113768,%edx
{
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 58 37 11 80       	mov    0x80113758,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 5c 37 11 80       	mov    0x8011375c,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 20 37 11 80       	push   $0x80113720
80102dae:	e8 dd 20 00 00       	call   80104e90 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db3:	8b 0d 68 37 11 80    	mov    0x80113768,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dc4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc6:	3b 15 6c 37 11 80    	cmp    0x8011376c,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 6c 37 11 80 	cmp    %edx,-0x7feec894(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 14 85 6c 37 11 80 	mov    %edx,-0x7feec894(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 68 37 11 80       	mov    %eax,0x80113768
  b->flags |= B_DIRTY; // prevent eviction
80102def:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df2:	c7 45 08 20 37 11 80 	movl   $0x80113720,0x8(%ebp)
}
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
  release(&log.lock);
80102dfd:	e9 4e 21 00 00       	jmp    80104f50 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e08:	89 14 85 6c 37 11 80 	mov    %edx,-0x7feec894(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 6c 37 11 80       	mov    %eax,0x8011376c
  if (i == log.lh.n)
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
    panic("too big a transaction");
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 13 85 10 80       	push   $0x80108513
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 29 85 10 80       	push   $0x80108529
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
80102e47:	e8 34 0a 00 00       	call   80103880 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 2d 0a 00 00       	call   80103880 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 44 85 10 80       	push   $0x80108544
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 a9 34 00 00       	call   80106310 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 94 09 00 00       	call   80103800 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 41 13 00 00       	call   801041c0 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 e5 4a 00 00       	call   80107970 <switchkvm>
  seginit();
80102e8b:	e8 50 4a 00 00       	call   801078e0 <seginit>
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
80102eb7:	68 88 c3 11 80       	push   $0x8011c388
80102ebc:	e8 2f f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102ec1:	e8 7a 4f 00 00       	call   80107e40 <kvmalloc>
  mpinit();        // detect other processors
80102ec6:	e8 75 01 00 00       	call   80103040 <mpinit>
  lapicinit();     // interrupt controller
80102ecb:	e8 60 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102ed0:	e8 0b 4a 00 00       	call   801078e0 <seginit>
  picinit();       // disable pic
80102ed5:	e8 46 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102eda:	e8 41 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102edf:	e8 dc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ee4:	e8 c7 3c 00 00       	call   80106bb0 <uartinit>
  pinit();         // process table
80102ee9:	e8 f2 08 00 00       	call   801037e0 <pinit>
  tvinit();        // trap vectors
80102eee:	e8 9d 33 00 00       	call   80106290 <tvinit>
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
80102f0a:	68 ec b4 10 80       	push   $0x8010b4ec
80102f0f:	68 00 70 00 80       	push   $0x80007000
80102f14:	e8 37 21 00 00       	call   80105050 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f19:	69 05 a0 3d 11 80 b0 	imul   $0xb0,0x80113da0,%eax
80102f20:	00 00 00 
80102f23:	83 c4 10             	add    $0x10,%esp
80102f26:	05 20 38 11 80       	add    $0x80113820,%eax
80102f2b:	3d 20 38 11 80       	cmp    $0x80113820,%eax
80102f30:	76 71                	jbe    80102fa3 <main+0x103>
80102f32:	bb 20 38 11 80       	mov    $0x80113820,%ebx
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f40:	e8 bb 08 00 00       	call   80103800 <mycpu>
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
80102f5d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f64:	a0 10 00 
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
80102f8a:	69 05 a0 3d 11 80 b0 	imul   $0xb0,0x80113da0,%eax
80102f91:	00 00 00 
80102f94:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f9a:	05 20 38 11 80       	add    $0x80113820,%eax
80102f9f:	39 c3                	cmp    %eax,%ebx
80102fa1:	72 9d                	jb     80102f40 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fa3:	83 ec 08             	sub    $0x8,%esp
80102fa6:	68 00 00 00 8e       	push   $0x8e000000
80102fab:	68 00 00 40 80       	push   $0x80400000
80102fb0:	e8 ab f4 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102fb5:	e8 36 0e 00 00       	call   80103df0 <userinit>
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
80102fee:	68 58 85 10 80       	push   $0x80108558
80102ff3:	56                   	push   %esi
80102ff4:	e8 f7 1f 00 00       	call   80104ff0 <memcmp>
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
801030ac:	68 75 85 10 80       	push   $0x80108575
801030b1:	56                   	push   %esi
801030b2:	e8 39 1f 00 00       	call   80104ff0 <memcmp>
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
80103117:	a3 1c 37 11 80       	mov    %eax,0x8011371c
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
80103140:	ff 24 95 9c 85 10 80 	jmp    *-0x7fef7a64(,%edx,4)
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
80103188:	8b 0d a0 3d 11 80    	mov    0x80113da0,%ecx
8010318e:	83 f9 07             	cmp    $0x7,%ecx
80103191:	7f 19                	jg     801031ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103193:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103197:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010319d:	83 c1 01             	add    $0x1,%ecx
801031a0:	89 0d a0 3d 11 80    	mov    %ecx,0x80113da0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a6:	88 97 20 38 11 80    	mov    %dl,-0x7feec7e0(%edi)
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
801031bf:	88 15 00 38 11 80    	mov    %dl,0x80113800
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
801031f3:	68 5d 85 10 80       	push   $0x8010855d
801031f8:	e8 93 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801031fd:	83 ec 0c             	sub    $0xc,%esp
80103200:	68 7c 85 10 80       	push   $0x8010857c
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
801032fb:	68 b0 85 10 80       	push   $0x801085b0
80103300:	50                   	push   %eax
80103301:	e8 4a 1a 00 00       	call   80104d50 <initlock>
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
8010335f:	e8 2c 1b 00 00       	call   80104e90 <acquire>
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
8010337f:	e8 6c 15 00 00       	call   801048f0 <wakeup>
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
801033a4:	e9 a7 1b 00 00       	jmp    80104f50 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c0:	00 00 00 
    wakeup(&p->nwrite);
801033c3:	50                   	push   %eax
801033c4:	e8 27 15 00 00       	call   801048f0 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 77 1b 00 00       	call   80104f50 <release>
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
801033fd:	e8 8e 1a 00 00       	call   80104e90 <acquire>
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
80103454:	e8 97 14 00 00       	call   801048f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103459:	5a                   	pop    %edx
8010345a:	59                   	pop    %ecx
8010345b:	53                   	push   %ebx
8010345c:	56                   	push   %esi
8010345d:	e8 ae 11 00 00       	call   80104610 <sleep>
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
80103484:	e8 17 04 00 00       	call   801038a0 <myproc>
80103489:	8b 40 24             	mov    0x24(%eax),%eax
8010348c:	85 c0                	test   %eax,%eax
8010348e:	74 c0                	je     80103450 <pipewrite+0x60>
        release(&p->lock);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 b7 1a 00 00       	call   80104f50 <release>
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
801034e3:	e8 08 14 00 00       	call   801048f0 <wakeup>
  release(&p->lock);
801034e8:	89 1c 24             	mov    %ebx,(%esp)
801034eb:	e8 60 1a 00 00       	call   80104f50 <release>
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
80103510:	e8 7b 19 00 00       	call   80104e90 <acquire>
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
80103545:	e8 c6 10 00 00       	call   80104610 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010354a:	83 c4 10             	add    $0x10,%esp
8010354d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103553:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103559:	75 35                	jne    80103590 <piperead+0x90>
8010355b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	0f 84 8f 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
80103569:	e8 32 03 00 00       	call   801038a0 <myproc>
8010356e:	8b 48 24             	mov    0x24(%eax),%ecx
80103571:	85 c9                	test   %ecx,%ecx
80103573:	74 cb                	je     80103540 <piperead+0x40>
      release(&p->lock);
80103575:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103578:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010357d:	56                   	push   %esi
8010357e:	e8 cd 19 00 00       	call   80104f50 <release>
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
801035d7:	e8 14 13 00 00       	call   801048f0 <wakeup>
  release(&p->lock);
801035dc:	89 34 24             	mov    %esi,(%esp)
801035df:	e8 6c 19 00 00       	call   80104f50 <release>
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
80103604:	bb 94 7c 11 80       	mov    $0x80117c94,%ebx
static struct proc *allocproc(void) {
80103609:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
8010360c:	68 60 7c 11 80       	push   $0x80117c60
80103611:	e8 7a 18 00 00       	call   80104e90 <acquire>
80103616:	83 c4 10             	add    $0x10,%esp
80103619:	eb 17                	jmp    80103632 <allocproc+0x32>
8010361b:	90                   	nop
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103620:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80103626:	81 fb 94 ab 11 80    	cmp    $0x8011ab94,%ebx
8010362c:	0f 83 2e 01 00 00    	jae    80103760 <allocproc+0x160>
        if (p->state == UNUSED)
80103632:	8b 43 0c             	mov    0xc(%ebx),%eax
80103635:	85 c0                	test   %eax,%eax
80103637:	75 e7                	jne    80103620 <allocproc+0x20>
    return 0;

found:
    p->state = EMBRYO;
    p->priority = 60;  // default priority value
    p->pid = nextpid++;
80103639:	a1 60 b0 10 80       	mov    0x8010b060,%eax
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
8010365c:	c7 83 a4 00 00 00 00 	movl   $0x0,0xa4(%ebx)
80103663:	00 00 00 
    p->stat.num_run = 0;
80103666:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
8010366d:	00 00 00 
    p->pid = nextpid++;
80103670:	8d 50 01             	lea    0x1(%eax),%edx
80103673:	89 43 10             	mov    %eax,0x10(%ebx)
    p->stat.pid = p->pid;
80103676:	89 83 98 00 00 00    	mov    %eax,0x98(%ebx)
    q0[cnt[0]] = p;
8010367c:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
    p->stat.runtime = 0;
80103681:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
80103688:	00 00 00 
        p->stat.ticks[j] = 0;
8010368b:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
80103692:	00 00 00 
80103695:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
8010369c:	00 00 00 
8010369f:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
801036a6:	00 00 00 
801036a9:	c7 83 b4 00 00 00 00 	movl   $0x0,0xb4(%ebx)
801036b0:	00 00 00 
801036b3:	c7 83 b8 00 00 00 00 	movl   $0x0,0xb8(%ebx)
801036ba:	00 00 00 
    release(&ptable.lock);
801036bd:	68 60 7c 11 80       	push   $0x80117c60
    q0[cnt[0]] = p;
801036c2:	89 1c 85 c0 6c 11 80 	mov    %ebx,-0x7fee9340(,%eax,4)
    cnt[0]++;
801036c9:	83 c0 01             	add    $0x1,%eax
    p->pid = nextpid++;
801036cc:	89 15 60 b0 10 80    	mov    %edx,0x8010b060
    end0 += 1;
801036d2:	83 05 40 b6 10 80 01 	addl   $0x1,0x8010b640
    cnt[0]++;
801036d9:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    release(&ptable.lock);
801036de:	e8 6d 18 00 00       	call   80104f50 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
801036e3:	e8 d8 ed ff ff       	call   801024c0 <kalloc>
801036e8:	83 c4 10             	add    $0x10,%esp
801036eb:	85 c0                	test   %eax,%eax
801036ed:	89 43 08             	mov    %eax,0x8(%ebx)
801036f0:	0f 84 83 00 00 00    	je     80103779 <allocproc+0x179>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
801036f6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *)sp;
    memset(p->context, 0, sizeof *p->context);
801036fc:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
801036ff:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
80103704:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint *)sp = (uint)trapret;
80103707:	c7 40 14 82 62 10 80 	movl   $0x80106282,0x14(%eax)
    p->context = (struct context *)sp;
8010370e:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103711:	6a 14                	push   $0x14
80103713:	6a 00                	push   $0x0
80103715:	50                   	push   %eax
80103716:	e8 85 18 00 00       	call   80104fa0 <memset>
    p->context->eip = (uint)forkret;
8010371b:	8b 43 1c             	mov    0x1c(%ebx),%eax
    p->rtime = 0;
    p->etime = 0;
    p->iotime = 0;
    p->aging_time = 0;

    return p;
8010371e:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
80103721:	c7 40 10 90 37 10 80 	movl   $0x80103790,0x10(%eax)
    p->ctime = ticks;
80103728:	a1 80 c3 11 80       	mov    0x8011c380,%eax
    p->rtime = 0;
8010372d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103734:	00 00 00 
    p->etime = 0;
80103737:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010373e:	00 00 00 
    p->iotime = 0;
80103741:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103748:	00 00 00 
    p->aging_time = 0;
8010374b:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103752:	00 00 00 
    p->ctime = ticks;
80103755:	89 43 7c             	mov    %eax,0x7c(%ebx)
}
80103758:	89 d8                	mov    %ebx,%eax
8010375a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010375d:	c9                   	leave  
8010375e:	c3                   	ret    
8010375f:	90                   	nop
    release(&ptable.lock);
80103760:	83 ec 0c             	sub    $0xc,%esp
    return 0;
80103763:	31 db                	xor    %ebx,%ebx
    release(&ptable.lock);
80103765:	68 60 7c 11 80       	push   $0x80117c60
8010376a:	e8 e1 17 00 00       	call   80104f50 <release>
}
8010376f:	89 d8                	mov    %ebx,%eax
    return 0;
80103771:	83 c4 10             	add    $0x10,%esp
}
80103774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103777:	c9                   	leave  
80103778:	c3                   	ret    
        p->state = UNUSED;
80103779:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
80103780:	31 db                	xor    %ebx,%ebx
80103782:	eb d4                	jmp    80103758 <allocproc+0x158>
80103784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010378a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103790 <forkret>:
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void) {
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103796:	68 60 7c 11 80       	push   $0x80117c60
8010379b:	e8 b0 17 00 00       	call   80104f50 <release>

    if (first) {
801037a0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	85 c0                	test   %eax,%eax
801037aa:	75 04                	jne    801037b0 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
801037ac:	c9                   	leave  
801037ad:	c3                   	ret    
801037ae:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
801037b0:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
801037b3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801037ba:	00 00 00 
        iinit(ROOTDEV);
801037bd:	6a 01                	push   $0x1
801037bf:	e8 bc dc ff ff       	call   80101480 <iinit>
        initlog(ROOTDEV);
801037c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037cb:	e8 30 f3 ff ff       	call   80102b00 <initlog>
801037d0:	83 c4 10             	add    $0x10,%esp
}
801037d3:	c9                   	leave  
801037d4:	c3                   	ret    
801037d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037e0 <pinit>:
void pinit(void) {
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
801037e6:	68 b5 85 10 80       	push   $0x801085b5
801037eb:	68 60 7c 11 80       	push   $0x80117c60
801037f0:	e8 5b 15 00 00       	call   80104d50 <initlock>
}
801037f5:	83 c4 10             	add    $0x10,%esp
801037f8:	c9                   	leave  
801037f9:	c3                   	ret    
801037fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103800 <mycpu>:
struct cpu *mycpu(void) {
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103805:	9c                   	pushf  
80103806:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103807:	f6 c4 02             	test   $0x2,%ah
8010380a:	75 5e                	jne    8010386a <mycpu+0x6a>
    apicid = lapicid();
8010380c:	e8 1f ef ff ff       	call   80102730 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103811:	8b 35 a0 3d 11 80    	mov    0x80113da0,%esi
80103817:	85 f6                	test   %esi,%esi
80103819:	7e 42                	jle    8010385d <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
8010381b:	0f b6 15 20 38 11 80 	movzbl 0x80113820,%edx
80103822:	39 d0                	cmp    %edx,%eax
80103824:	74 30                	je     80103856 <mycpu+0x56>
80103826:	b9 d0 38 11 80       	mov    $0x801138d0,%ecx
    for (i = 0; i < ncpu; ++i) {
8010382b:	31 d2                	xor    %edx,%edx
8010382d:	8d 76 00             	lea    0x0(%esi),%esi
80103830:	83 c2 01             	add    $0x1,%edx
80103833:	39 f2                	cmp    %esi,%edx
80103835:	74 26                	je     8010385d <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103837:	0f b6 19             	movzbl (%ecx),%ebx
8010383a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103840:	39 c3                	cmp    %eax,%ebx
80103842:	75 ec                	jne    80103830 <mycpu+0x30>
80103844:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010384a:	05 20 38 11 80       	add    $0x80113820,%eax
}
8010384f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103852:	5b                   	pop    %ebx
80103853:	5e                   	pop    %esi
80103854:	5d                   	pop    %ebp
80103855:	c3                   	ret    
        if (cpus[i].apicid == apicid)
80103856:	b8 20 38 11 80       	mov    $0x80113820,%eax
            return &cpus[i];
8010385b:	eb f2                	jmp    8010384f <mycpu+0x4f>
    panic("unknown apicid\n");
8010385d:	83 ec 0c             	sub    $0xc,%esp
80103860:	68 bc 85 10 80       	push   $0x801085bc
80103865:	e8 26 cb ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
8010386a:	83 ec 0c             	sub    $0xc,%esp
8010386d:	68 f0 86 10 80       	push   $0x801086f0
80103872:	e8 19 cb ff ff       	call   80100390 <panic>
80103877:	89 f6                	mov    %esi,%esi
80103879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103880 <cpuid>:
int cpuid() {
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80103886:	e8 75 ff ff ff       	call   80103800 <mycpu>
8010388b:	2d 20 38 11 80       	sub    $0x80113820,%eax
}
80103890:	c9                   	leave  
    return mycpu() - cpus;
80103891:	c1 f8 04             	sar    $0x4,%eax
80103894:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010389a:	c3                   	ret    
8010389b:	90                   	nop
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038a0 <myproc>:
struct proc *myproc(void) {
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
801038a4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
801038a7:	e8 14 15 00 00       	call   80104dc0 <pushcli>
    c = mycpu();
801038ac:	e8 4f ff ff ff       	call   80103800 <mycpu>
    p = c->proc;
801038b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801038b7:	e8 44 15 00 00       	call   80104e00 <popcli>
}
801038bc:	83 c4 04             	add    $0x4,%esp
801038bf:	89 d8                	mov    %ebx,%eax
801038c1:	5b                   	pop    %ebx
801038c2:	5d                   	pop    %ebp
801038c3:	c3                   	ret    
801038c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038d0 <getpinfo>:
int getpinfo(struct proc_stat *p, int pid) {
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	56                   	push   %esi
801038d4:	53                   	push   %ebx
801038d5:	8b 75 08             	mov    0x8(%ebp),%esi
801038d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    acquire(&ptable.lock);
801038db:	83 ec 0c             	sub    $0xc,%esp
801038de:	68 60 7c 11 80       	push   $0x80117c60
801038e3:	e8 a8 15 00 00       	call   80104e90 <acquire>
801038e8:	83 c4 10             	add    $0x10,%esp
    for (q = ptable.proc; q < &ptable.proc[NPROC]; q++) {
801038eb:	b8 94 7c 11 80       	mov    $0x80117c94,%eax
801038f0:	eb 12                	jmp    80103904 <getpinfo+0x34>
801038f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038f8:	05 bc 00 00 00       	add    $0xbc,%eax
801038fd:	3d 94 ab 11 80       	cmp    $0x8011ab94,%eax
80103902:	73 74                	jae    80103978 <getpinfo+0xa8>
        if (q->state != RUNNABLE) {
80103904:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103908:	75 ee                	jne    801038f8 <getpinfo+0x28>
        if (q->pid == pid) {
8010390a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010390d:	75 e9                	jne    801038f8 <getpinfo+0x28>
            p->pid = q->pid;
8010390f:	89 1e                	mov    %ebx,(%esi)
            p->runtime = q->stat.runtime;
80103911:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
            release(&ptable.lock);
80103917:	83 ec 0c             	sub    $0xc,%esp
            p->runtime = q->stat.runtime;
8010391a:	89 56 04             	mov    %edx,0x4(%esi)
            p->current_queue = q->qno;
8010391d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80103923:	89 56 0c             	mov    %edx,0xc(%esi)
            p->num_run = q->stat.num_run;
80103926:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
8010392c:	89 56 08             	mov    %edx,0x8(%esi)
                p->ticks[j] = q->stat.ticks[j];
8010392f:	8b 90 a8 00 00 00    	mov    0xa8(%eax),%edx
80103935:	89 56 10             	mov    %edx,0x10(%esi)
80103938:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010393e:	89 56 14             	mov    %edx,0x14(%esi)
80103941:	8b 90 b0 00 00 00    	mov    0xb0(%eax),%edx
80103947:	89 56 18             	mov    %edx,0x18(%esi)
8010394a:	8b 90 b4 00 00 00    	mov    0xb4(%eax),%edx
80103950:	89 56 1c             	mov    %edx,0x1c(%esi)
80103953:	8b 80 b8 00 00 00    	mov    0xb8(%eax),%eax
80103959:	89 46 20             	mov    %eax,0x20(%esi)
            release(&ptable.lock);
8010395c:	68 60 7c 11 80       	push   $0x80117c60
80103961:	e8 ea 15 00 00       	call   80104f50 <release>
            return 1;
80103966:	83 c4 10             	add    $0x10,%esp
}
80103969:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 1;
8010396c:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103971:	5b                   	pop    %ebx
80103972:	5e                   	pop    %esi
80103973:	5d                   	pop    %ebp
80103974:	c3                   	ret    
80103975:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ptable.lock);
80103978:	83 ec 0c             	sub    $0xc,%esp
8010397b:	68 60 7c 11 80       	push   $0x80117c60
80103980:	e8 cb 15 00 00       	call   80104f50 <release>
    return 0;
80103985:	83 c4 10             	add    $0x10,%esp
}
80103988:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010398b:	31 c0                	xor    %eax,%eax
}
8010398d:	5b                   	pop    %ebx
8010398e:	5e                   	pop    %esi
8010398f:	5d                   	pop    %ebp
80103990:	c3                   	ret    
80103991:	eb 0d                	jmp    801039a0 <aging>
80103993:	90                   	nop
80103994:	90                   	nop
80103995:	90                   	nop
80103996:	90                   	nop
80103997:	90                   	nop
80103998:	90                   	nop
80103999:	90                   	nop
8010399a:	90                   	nop
8010399b:	90                   	nop
8010399c:	90                   	nop
8010399d:	90                   	nop
8010399e:	90                   	nop
8010399f:	90                   	nop

801039a0 <aging>:
int aging() {
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	57                   	push   %edi
801039a4:	56                   	push   %esi
801039a5:	53                   	push   %ebx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801039a6:	bf 94 7c 11 80       	mov    $0x80117c94,%edi
int aging() {
801039ab:	83 ec 28             	sub    $0x28,%esp
    acquire(&ptable.lock);
801039ae:	68 60 7c 11 80       	push   $0x80117c60
801039b3:	e8 d8 14 00 00       	call   80104e90 <acquire>
801039b8:	83 c4 10             	add    $0x10,%esp
801039bb:	eb 3d                	jmp    801039fa <aging+0x5a>
801039bd:	8d 76 00             	lea    0x0(%esi),%esi
            } else if (no == 2) {
801039c0:	83 f8 02             	cmp    $0x2,%eax
801039c3:	0f 84 67 01 00 00    	je     80103b30 <aging+0x190>
            } else if (no == 3) {
801039c9:	83 f8 03             	cmp    $0x3,%eax
801039cc:	0f 84 3e 02 00 00    	je     80103c10 <aging+0x270>
            } else if (no == 4) {
801039d2:	83 f8 04             	cmp    $0x4,%eax
801039d5:	0f 84 15 03 00 00    	je     80103cf0 <aging+0x350>
            p->aging_time = ticks - (p->ctime + p->rtime);
801039db:	03 55 e4             	add    -0x1c(%ebp),%edx
801039de:	89 f0                	mov    %esi,%eax
801039e0:	29 d0                	sub    %edx,%eax
801039e2:	89 87 94 00 00 00    	mov    %eax,0x94(%edi)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801039e8:	81 c7 bc 00 00 00    	add    $0xbc,%edi
801039ee:	81 ff 94 ab 11 80    	cmp    $0x8011ab94,%edi
801039f4:	0f 83 d6 03 00 00    	jae    80103dd0 <aging+0x430>
        if (p->state != RUNNABLE)
801039fa:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
801039fe:	75 e8                	jne    801039e8 <aging+0x48>
        int tm = ticks - p->ctime - p->rtime - p->aging_time;
80103a00:	8b 47 7c             	mov    0x7c(%edi),%eax
80103a03:	8b 35 80 c3 11 80    	mov    0x8011c380,%esi
80103a09:	8b 97 80 00 00 00    	mov    0x80(%edi),%edx
80103a0f:	89 c3                	mov    %eax,%ebx
80103a11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a14:	89 f0                	mov    %esi,%eax
80103a16:	29 d8                	sub    %ebx,%eax
80103a18:	29 d0                	sub    %edx,%eax
80103a1a:	2b 87 94 00 00 00    	sub    0x94(%edi),%eax
        if (tm > time_age) {
80103a20:	39 05 64 b0 10 80    	cmp    %eax,0x8010b064
80103a26:	7d c0                	jge    801039e8 <aging+0x48>
            int no = p->qno;
80103a28:	8b 87 90 00 00 00    	mov    0x90(%edi),%eax
            if (no == 1) {
80103a2e:	83 f8 01             	cmp    $0x1,%eax
80103a31:	75 8d                	jne    801039c0 <aging+0x20>
                cnt[1]--;
80103a33:	a1 20 b6 10 80       	mov    0x8010b620,%eax
                p->qno = 0;
80103a38:	c7 87 90 00 00 00 00 	movl   $0x0,0x90(%edi)
80103a3f:	00 00 00 
80103a42:	8b 5f 10             	mov    0x10(%edi),%ebx
                cnt[1]--;
80103a45:	8d 48 ff             	lea    -0x1(%eax),%ecx
                for (int i = 0; i < cnt[1]; i++) {
80103a48:	85 c9                	test   %ecx,%ecx
                cnt[1]--;
80103a4a:	89 0d 20 b6 10 80    	mov    %ecx,0x8010b620
                for (int i = 0; i < cnt[1]; i++) {
80103a50:	7e 4e                	jle    80103aa0 <aging+0x100>
                    if (q1[i]->pid == p->pid) {
80103a52:	a1 20 5d 11 80       	mov    0x80115d20,%eax
80103a57:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103a5a:	39 58 10             	cmp    %ebx,0x10(%eax)
                for (int i = 0; i < cnt[1]; i++) {
80103a5d:	b8 00 00 00 00       	mov    $0x0,%eax
                    if (q1[i]->pid == p->pid) {
80103a62:	75 18                	jne    80103a7c <aging+0xdc>
80103a64:	eb 22                	jmp    80103a88 <aging+0xe8>
80103a66:	8d 76 00             	lea    0x0(%esi),%esi
80103a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103a70:	8b 14 85 20 5d 11 80 	mov    -0x7feea2e0(,%eax,4),%edx
80103a77:	39 5a 10             	cmp    %ebx,0x10(%edx)
80103a7a:	74 0c                	je     80103a88 <aging+0xe8>
                for (int i = 0; i < cnt[1]; i++) {
80103a7c:	83 c0 01             	add    $0x1,%eax
80103a7f:	39 c8                	cmp    %ecx,%eax
80103a81:	75 ed                	jne    80103a70 <aging+0xd0>
80103a83:	31 c0                	xor    %eax,%eax
80103a85:	8d 76 00             	lea    0x0(%esi),%esi
                    q1[i] = q1[i + 1];
80103a88:	83 c0 01             	add    $0x1,%eax
80103a8b:	8b 14 85 20 5d 11 80 	mov    -0x7feea2e0(,%eax,4),%edx
                for (int i = ind; i < cnt[1]; i++) {
80103a92:	39 c1                	cmp    %eax,%ecx
                    q1[i] = q1[i + 1];
80103a94:	89 14 85 1c 5d 11 80 	mov    %edx,-0x7feea2e4(,%eax,4)
                for (int i = ind; i < cnt[1]; i++) {
80103a9b:	7f eb                	jg     80103a88 <aging+0xe8>
80103a9d:	8b 55 e0             	mov    -0x20(%ebp),%edx
                for (int i = 0; i < cnt[0]; i++) {
80103aa0:	8b 0d 1c b6 10 80    	mov    0x8010b61c,%ecx
80103aa6:	85 c9                	test   %ecx,%ecx
80103aa8:	7e 29                	jle    80103ad3 <aging+0x133>
                    if (q0[i]->pid == p->pid) {
80103aaa:	a1 c0 6c 11 80       	mov    0x80116cc0,%eax
80103aaf:	39 58 10             	cmp    %ebx,0x10(%eax)
80103ab2:	0f 84 23 ff ff ff    	je     801039db <aging+0x3b>
                for (int i = 0; i < cnt[0]; i++) {
80103ab8:	31 c0                	xor    %eax,%eax
80103aba:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103abd:	eb 0d                	jmp    80103acc <aging+0x12c>
80103abf:	90                   	nop
                    if (q0[i]->pid == p->pid) {
80103ac0:	8b 14 85 c0 6c 11 80 	mov    -0x7fee9340(,%eax,4),%edx
80103ac7:	39 5a 10             	cmp    %ebx,0x10(%edx)
80103aca:	74 54                	je     80103b20 <aging+0x180>
                for (int i = 0; i < cnt[0]; i++) {
80103acc:	83 c0 01             	add    $0x1,%eax
80103acf:	39 c8                	cmp    %ecx,%eax
80103ad1:	75 ed                	jne    80103ac0 <aging+0x120>
                    cprintf("Process with pid %d AGED from 1 to 0\n", p->pid);
80103ad3:	83 ec 08             	sub    $0x8,%esp
80103ad6:	53                   	push   %ebx
80103ad7:	68 18 87 10 80       	push   $0x80108718
80103adc:	e8 7f cb ff ff       	call   80100660 <cprintf>
                    cnt[0]++;
80103ae1:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
                    end0 += 1;
80103ae6:	83 05 40 b6 10 80 01 	addl   $0x1,0x8010b640
                    cnt[0]++;
80103aed:	8d 50 01             	lea    0x1(%eax),%edx
                    q0[cnt[0] - 1] = p;
80103af0:	89 3c 85 c0 6c 11 80 	mov    %edi,-0x7fee9340(,%eax,4)
                    cnt[0]++;
80103af7:	89 15 1c b6 10 80    	mov    %edx,0x8010b61c
80103afd:	8b 47 7c             	mov    0x7c(%edi),%eax
80103b00:	8b 35 80 c3 11 80    	mov    0x8011c380,%esi
80103b06:	83 c4 10             	add    $0x10,%esp
80103b09:	8b 97 80 00 00 00    	mov    0x80(%edi),%edx
80103b0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b12:	e9 c4 fe ff ff       	jmp    801039db <aging+0x3b>
80103b17:	89 f6                	mov    %esi,%esi
80103b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103b20:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103b23:	e9 b3 fe ff ff       	jmp    801039db <aging+0x3b>
80103b28:	90                   	nop
80103b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                cnt[2]--;
80103b30:	a1 24 b6 10 80       	mov    0x8010b624,%eax
                p->qno = 1;
80103b35:	c7 87 90 00 00 00 01 	movl   $0x1,0x90(%edi)
80103b3c:	00 00 00 
80103b3f:	8b 5f 10             	mov    0x10(%edi),%ebx
                cnt[2]--;
80103b42:	8d 48 ff             	lea    -0x1(%eax),%ecx
                for (int i = 0; i < cnt[2]; i++) {
80103b45:	85 c9                	test   %ecx,%ecx
                cnt[2]--;
80103b47:	89 0d 24 b6 10 80    	mov    %ecx,0x8010b624
                for (int i = 0; i < cnt[2]; i++) {
80103b4d:	7e 49                	jle    80103b98 <aging+0x1f8>
                    if (q2[i]->pid == p->pid) {
80103b4f:	a1 c0 3d 11 80       	mov    0x80113dc0,%eax
80103b54:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103b57:	39 58 10             	cmp    %ebx,0x10(%eax)
                for (int i = 0; i < cnt[2]; i++) {
80103b5a:	b8 00 00 00 00       	mov    $0x0,%eax
                    if (q2[i]->pid == p->pid) {
80103b5f:	75 13                	jne    80103b74 <aging+0x1d4>
80103b61:	eb 1d                	jmp    80103b80 <aging+0x1e0>
80103b63:	90                   	nop
80103b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b68:	8b 14 85 c0 3d 11 80 	mov    -0x7feec240(,%eax,4),%edx
80103b6f:	39 5a 10             	cmp    %ebx,0x10(%edx)
80103b72:	74 0c                	je     80103b80 <aging+0x1e0>
                for (int i = 0; i < cnt[2]; i++) {
80103b74:	83 c0 01             	add    $0x1,%eax
80103b77:	39 c8                	cmp    %ecx,%eax
80103b79:	75 ed                	jne    80103b68 <aging+0x1c8>
80103b7b:	31 c0                	xor    %eax,%eax
80103b7d:	8d 76 00             	lea    0x0(%esi),%esi
                    q2[i] = q2[i + 1];
80103b80:	83 c0 01             	add    $0x1,%eax
80103b83:	8b 14 85 c0 3d 11 80 	mov    -0x7feec240(,%eax,4),%edx
                for (int i = ind; i < cnt[2]; i++) {
80103b8a:	39 c1                	cmp    %eax,%ecx
                    q2[i] = q2[i + 1];
80103b8c:	89 14 85 bc 3d 11 80 	mov    %edx,-0x7feec244(,%eax,4)
                for (int i = ind; i < cnt[2]; i++) {
80103b93:	7f eb                	jg     80103b80 <aging+0x1e0>
80103b95:	8b 55 e0             	mov    -0x20(%ebp),%edx
                for (int i = 0; i < cnt[1]; i++) {
80103b98:	8b 0d 20 b6 10 80    	mov    0x8010b620,%ecx
80103b9e:	85 c9                	test   %ecx,%ecx
80103ba0:	7e 35                	jle    80103bd7 <aging+0x237>
                    if (q1[i]->pid == p->pid) {
80103ba2:	a1 20 5d 11 80       	mov    0x80115d20,%eax
80103ba7:	39 58 10             	cmp    %ebx,0x10(%eax)
80103baa:	0f 84 2b fe ff ff    	je     801039db <aging+0x3b>
                for (int i = 0; i < cnt[1]; i++) {
80103bb0:	31 c0                	xor    %eax,%eax
80103bb2:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103bb5:	eb 19                	jmp    80103bd0 <aging+0x230>
80103bb7:	89 f6                	mov    %esi,%esi
80103bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    if (q1[i]->pid == p->pid) {
80103bc0:	8b 14 85 20 5d 11 80 	mov    -0x7feea2e0(,%eax,4),%edx
80103bc7:	39 5a 10             	cmp    %ebx,0x10(%edx)
80103bca:	0f 84 50 ff ff ff    	je     80103b20 <aging+0x180>
                for (int i = 0; i < cnt[1]; i++) {
80103bd0:	83 c0 01             	add    $0x1,%eax
80103bd3:	39 c8                	cmp    %ecx,%eax
80103bd5:	75 e9                	jne    80103bc0 <aging+0x220>
                    cprintf("Process with pid %d AGED from 2 to 1\n", p->pid);
80103bd7:	83 ec 08             	sub    $0x8,%esp
                    cnt[1]++;
80103bda:	8d 71 01             	lea    0x1(%ecx),%esi
                    cprintf("Process with pid %d AGED from 2 to 1\n", p->pid);
80103bdd:	53                   	push   %ebx
80103bde:	68 40 87 10 80       	push   $0x80108740
                    cnt[1]++;
80103be3:	89 35 20 b6 10 80    	mov    %esi,0x8010b620
                    cprintf("Process with pid %d AGED from 2 to 1\n", p->pid);
80103be9:	e8 72 ca ff ff       	call   80100660 <cprintf>
                    q1[cnt[1] - 1] = p;
80103bee:	a1 20 b6 10 80       	mov    0x8010b620,%eax
                    end1 += 1;
80103bf3:	83 05 3c b6 10 80 01 	addl   $0x1,0x8010b63c
                    q1[cnt[1] - 1] = p;
80103bfa:	89 3c 85 1c 5d 11 80 	mov    %edi,-0x7feea2e4(,%eax,4)
80103c01:	e9 f7 fe ff ff       	jmp    80103afd <aging+0x15d>
80103c06:	8d 76 00             	lea    0x0(%esi),%esi
80103c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                cnt[3]--;
80103c10:	a1 28 b6 10 80       	mov    0x8010b628,%eax
                p->qno = 2;
80103c15:	c7 87 90 00 00 00 02 	movl   $0x2,0x90(%edi)
80103c1c:	00 00 00 
80103c1f:	8b 5f 10             	mov    0x10(%edi),%ebx
                cnt[3]--;
80103c22:	8d 48 ff             	lea    -0x1(%eax),%ecx
                for (int i = 0; i < cnt[3]; i++) {
80103c25:	85 c9                	test   %ecx,%ecx
                cnt[3]--;
80103c27:	89 0d 28 b6 10 80    	mov    %ecx,0x8010b628
                for (int i = 0; i < cnt[3]; i++) {
80103c2d:	7e 49                	jle    80103c78 <aging+0x2d8>
                    if (q3[i]->pid == p->pid) {
80103c2f:	a1 80 4d 11 80       	mov    0x80114d80,%eax
80103c34:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103c37:	39 58 10             	cmp    %ebx,0x10(%eax)
                for (int i = 0; i < cnt[3]; i++) {
80103c3a:	b8 00 00 00 00       	mov    $0x0,%eax
                    if (q3[i]->pid == p->pid) {
80103c3f:	75 13                	jne    80103c54 <aging+0x2b4>
80103c41:	eb 1d                	jmp    80103c60 <aging+0x2c0>
80103c43:	90                   	nop
80103c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c48:	8b 14 85 80 4d 11 80 	mov    -0x7feeb280(,%eax,4),%edx
80103c4f:	39 5a 10             	cmp    %ebx,0x10(%edx)
80103c52:	74 0c                	je     80103c60 <aging+0x2c0>
                for (int i = 0; i < cnt[3]; i++) {
80103c54:	83 c0 01             	add    $0x1,%eax
80103c57:	39 c8                	cmp    %ecx,%eax
80103c59:	75 ed                	jne    80103c48 <aging+0x2a8>
80103c5b:	31 c0                	xor    %eax,%eax
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
                    q3[i] = q3[i + 1];
80103c60:	83 c0 01             	add    $0x1,%eax
80103c63:	8b 14 85 80 4d 11 80 	mov    -0x7feeb280(,%eax,4),%edx
                for (int i = ind; i < cnt[3]; i++) {
80103c6a:	39 c1                	cmp    %eax,%ecx
                    q3[i] = q3[i + 1];
80103c6c:	89 14 85 7c 4d 11 80 	mov    %edx,-0x7feeb284(,%eax,4)
                for (int i = ind; i < cnt[3]; i++) {
80103c73:	7f eb                	jg     80103c60 <aging+0x2c0>
80103c75:	8b 55 e0             	mov    -0x20(%ebp),%edx
                for (int i = 0; i < cnt[2]; i++) {
80103c78:	8b 0d 24 b6 10 80    	mov    0x8010b624,%ecx
80103c7e:	85 c9                	test   %ecx,%ecx
80103c80:	7e 35                	jle    80103cb7 <aging+0x317>
                    if (q2[i]->pid == p->pid) {
80103c82:	a1 c0 3d 11 80       	mov    0x80113dc0,%eax
80103c87:	39 58 10             	cmp    %ebx,0x10(%eax)
80103c8a:	0f 84 4b fd ff ff    	je     801039db <aging+0x3b>
                for (int i = 0; i < cnt[2]; i++) {
80103c90:	31 c0                	xor    %eax,%eax
80103c92:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103c95:	eb 19                	jmp    80103cb0 <aging+0x310>
80103c97:	89 f6                	mov    %esi,%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    if (q2[i]->pid == p->pid) {
80103ca0:	8b 14 85 c0 3d 11 80 	mov    -0x7feec240(,%eax,4),%edx
80103ca7:	39 5a 10             	cmp    %ebx,0x10(%edx)
80103caa:	0f 84 70 fe ff ff    	je     80103b20 <aging+0x180>
                for (int i = 0; i < cnt[2]; i++) {
80103cb0:	83 c0 01             	add    $0x1,%eax
80103cb3:	39 c1                	cmp    %eax,%ecx
80103cb5:	75 e9                	jne    80103ca0 <aging+0x300>
                    cprintf("Process with pid %d AGED from 3 to 2\n", p->pid);
80103cb7:	83 ec 08             	sub    $0x8,%esp
                    cnt[2]++;
80103cba:	8d 71 01             	lea    0x1(%ecx),%esi
                    cprintf("Process with pid %d AGED from 3 to 2\n", p->pid);
80103cbd:	53                   	push   %ebx
80103cbe:	68 68 87 10 80       	push   $0x80108768
                    cnt[2]++;
80103cc3:	89 35 24 b6 10 80    	mov    %esi,0x8010b624
                    cprintf("Process with pid %d AGED from 3 to 2\n", p->pid);
80103cc9:	e8 92 c9 ff ff       	call   80100660 <cprintf>
                    q2[cnt[2] - 1] = p;
80103cce:	a1 24 b6 10 80       	mov    0x8010b624,%eax
                    end2 += 1;
80103cd3:	83 05 38 b6 10 80 01 	addl   $0x1,0x8010b638
                    q2[cnt[2] - 1] = p;
80103cda:	89 3c 85 bc 3d 11 80 	mov    %edi,-0x7feec244(,%eax,4)
80103ce1:	e9 17 fe ff ff       	jmp    80103afd <aging+0x15d>
80103ce6:	8d 76 00             	lea    0x0(%esi),%esi
80103ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                cnt[4]--;
80103cf0:	a1 2c b6 10 80       	mov    0x8010b62c,%eax
                p->qno = 3;
80103cf5:	c7 87 90 00 00 00 03 	movl   $0x3,0x90(%edi)
80103cfc:	00 00 00 
80103cff:	8b 5f 10             	mov    0x10(%edi),%ebx
                cnt[4]--;
80103d02:	8d 48 ff             	lea    -0x1(%eax),%ecx
                for (int i = 0; i < cnt[4]; i++) {
80103d05:	85 c9                	test   %ecx,%ecx
                cnt[4]--;
80103d07:	89 0d 2c b6 10 80    	mov    %ecx,0x8010b62c
                for (int i = 0; i < cnt[4]; i++) {
80103d0d:	7e 49                	jle    80103d58 <aging+0x3b8>
                    if (q4[i]->pid == p->pid) {
80103d0f:	a1 a0 ab 11 80       	mov    0x8011aba0,%eax
80103d14:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103d17:	3b 58 10             	cmp    0x10(%eax),%ebx
                for (int i = 0; i < cnt[4]; i++) {
80103d1a:	b8 00 00 00 00       	mov    $0x0,%eax
                    if (q4[i]->pid == p->pid) {
80103d1f:	75 13                	jne    80103d34 <aging+0x394>
80103d21:	eb 1d                	jmp    80103d40 <aging+0x3a0>
80103d23:	90                   	nop
80103d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d28:	8b 14 85 a0 ab 11 80 	mov    -0x7fee5460(,%eax,4),%edx
80103d2f:	39 5a 10             	cmp    %ebx,0x10(%edx)
80103d32:	74 0c                	je     80103d40 <aging+0x3a0>
                for (int i = 0; i < cnt[4]; i++) {
80103d34:	83 c0 01             	add    $0x1,%eax
80103d37:	39 c1                	cmp    %eax,%ecx
80103d39:	75 ed                	jne    80103d28 <aging+0x388>
80103d3b:	31 c0                	xor    %eax,%eax
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi
                    q4[i] = q4[i + 1];
80103d40:	83 c0 01             	add    $0x1,%eax
80103d43:	8b 14 85 a0 ab 11 80 	mov    -0x7fee5460(,%eax,4),%edx
                for (int i = ind; i < cnt[4]; i++) {
80103d4a:	39 c1                	cmp    %eax,%ecx
                    q4[i] = q4[i + 1];
80103d4c:	89 14 85 9c ab 11 80 	mov    %edx,-0x7fee5464(,%eax,4)
                for (int i = ind; i < cnt[4]; i++) {
80103d53:	7f eb                	jg     80103d40 <aging+0x3a0>
80103d55:	8b 55 e0             	mov    -0x20(%ebp),%edx
                for (int i = 0; i < cnt[3]; i++) {
80103d58:	8b 0d 28 b6 10 80    	mov    0x8010b628,%ecx
80103d5e:	85 c9                	test   %ecx,%ecx
80103d60:	7e 35                	jle    80103d97 <aging+0x3f7>
                    if (q3[i]->pid == p->pid) {
80103d62:	a1 80 4d 11 80       	mov    0x80114d80,%eax
80103d67:	3b 58 10             	cmp    0x10(%eax),%ebx
80103d6a:	0f 84 6b fc ff ff    	je     801039db <aging+0x3b>
                for (int i = 0; i < cnt[3]; i++) {
80103d70:	31 c0                	xor    %eax,%eax
80103d72:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103d75:	eb 19                	jmp    80103d90 <aging+0x3f0>
80103d77:	89 f6                	mov    %esi,%esi
80103d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    if (q3[i]->pid == p->pid) {
80103d80:	8b 14 85 80 4d 11 80 	mov    -0x7feeb280(,%eax,4),%edx
80103d87:	39 5a 10             	cmp    %ebx,0x10(%edx)
80103d8a:	0f 84 90 fd ff ff    	je     80103b20 <aging+0x180>
                for (int i = 0; i < cnt[3]; i++) {
80103d90:	83 c0 01             	add    $0x1,%eax
80103d93:	39 c8                	cmp    %ecx,%eax
80103d95:	75 e9                	jne    80103d80 <aging+0x3e0>
                    cprintf("Process with pid %d AGED from 4 to 3\n", p->pid);
80103d97:	83 ec 08             	sub    $0x8,%esp
                    cnt[3]++;
80103d9a:	8d 71 01             	lea    0x1(%ecx),%esi
                    cprintf("Process with pid %d AGED from 4 to 3\n", p->pid);
80103d9d:	53                   	push   %ebx
80103d9e:	68 90 87 10 80       	push   $0x80108790
                    cnt[3]++;
80103da3:	89 35 28 b6 10 80    	mov    %esi,0x8010b628
                    cprintf("Process with pid %d AGED from 4 to 3\n", p->pid);
80103da9:	e8 b2 c8 ff ff       	call   80100660 <cprintf>
                    q3[cnt[3] - 1] = p;
80103dae:	a1 28 b6 10 80       	mov    0x8010b628,%eax
                    end3 += 1;
80103db3:	83 05 34 b6 10 80 01 	addl   $0x1,0x8010b634
                    q3[cnt[3] - 1] = p;
80103dba:	89 3c 85 7c 4d 11 80 	mov    %edi,-0x7feeb284(,%eax,4)
80103dc1:	e9 37 fd ff ff       	jmp    80103afd <aging+0x15d>
80103dc6:	8d 76 00             	lea    0x0(%esi),%esi
80103dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&ptable.lock);
80103dd0:	83 ec 0c             	sub    $0xc,%esp
80103dd3:	68 60 7c 11 80       	push   $0x80117c60
80103dd8:	e8 73 11 00 00       	call   80104f50 <release>
}
80103ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103de0:	31 c0                	xor    %eax,%eax
80103de2:	5b                   	pop    %ebx
80103de3:	5e                   	pop    %esi
80103de4:	5f                   	pop    %edi
80103de5:	5d                   	pop    %ebp
80103de6:	c3                   	ret    
80103de7:	89 f6                	mov    %esi,%esi
80103de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103df0 <userinit>:
void userinit(void) {
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
80103df4:	83 ec 04             	sub    $0x4,%esp
    p = allocproc();
80103df7:	e8 04 f8 ff ff       	call   80103600 <allocproc>
80103dfc:	89 c3                	mov    %eax,%ebx
    initproc = p;
80103dfe:	a3 58 b6 10 80       	mov    %eax,0x8010b658
    if ((p->pgdir = setupkvm()) == 0)
80103e03:	e8 b8 3f 00 00       	call   80107dc0 <setupkvm>
80103e08:	85 c0                	test   %eax,%eax
80103e0a:	89 43 04             	mov    %eax,0x4(%ebx)
80103e0d:	0f 84 bd 00 00 00    	je     80103ed0 <userinit+0xe0>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e13:	83 ec 04             	sub    $0x4,%esp
80103e16:	68 2c 00 00 00       	push   $0x2c
80103e1b:	68 c0 b4 10 80       	push   $0x8010b4c0
80103e20:	50                   	push   %eax
80103e21:	e8 7a 3c 00 00       	call   80107aa0 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80103e26:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103e29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103e2f:	6a 4c                	push   $0x4c
80103e31:	6a 00                	push   $0x0
80103e33:	ff 73 18             	pushl  0x18(%ebx)
80103e36:	e8 65 11 00 00       	call   80104fa0 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103e3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e43:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103e48:	83 c4 0c             	add    $0xc,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103e52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103e56:	8b 43 18             	mov    0x18(%ebx),%eax
80103e59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e5d:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80103e61:	8b 43 18             	mov    0x18(%ebx),%eax
80103e64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e68:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80103e6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103e6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103e76:	8b 43 18             	mov    0x18(%ebx),%eax
80103e79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80103e80:	8b 43 18             	mov    0x18(%ebx),%eax
80103e83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103e8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103e8d:	6a 10                	push   $0x10
80103e8f:	68 e5 85 10 80       	push   $0x801085e5
80103e94:	50                   	push   %eax
80103e95:	e8 e6 12 00 00       	call   80105180 <safestrcpy>
    p->cwd = namei("/");
80103e9a:	c7 04 24 ee 85 10 80 	movl   $0x801085ee,(%esp)
80103ea1:	e8 3a e0 ff ff       	call   80101ee0 <namei>
80103ea6:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
80103ea9:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
80103eb0:	e8 db 0f 00 00       	call   80104e90 <acquire>
    p->state = RUNNABLE;
80103eb5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
80103ebc:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
80103ec3:	e8 88 10 00 00       	call   80104f50 <release>
}
80103ec8:	83 c4 10             	add    $0x10,%esp
80103ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ece:	c9                   	leave  
80103ecf:	c3                   	ret    
        panic("userinit: out of memory?");
80103ed0:	83 ec 0c             	sub    $0xc,%esp
80103ed3:	68 cc 85 10 80       	push   $0x801085cc
80103ed8:	e8 b3 c4 ff ff       	call   80100390 <panic>
80103edd:	8d 76 00             	lea    0x0(%esi),%esi

80103ee0 <growproc>:
int growproc(int n) {
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
80103ee5:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103ee8:	e8 d3 0e 00 00       	call   80104dc0 <pushcli>
    c = mycpu();
80103eed:	e8 0e f9 ff ff       	call   80103800 <mycpu>
    p = c->proc;
80103ef2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103ef8:	e8 03 0f 00 00       	call   80104e00 <popcli>
    if (n > 0) {
80103efd:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80103f00:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103f02:	7f 1c                	jg     80103f20 <growproc+0x40>
    } else if (n < 0) {
80103f04:	75 3a                	jne    80103f40 <growproc+0x60>
    switchuvm(curproc);
80103f06:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80103f09:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103f0b:	53                   	push   %ebx
80103f0c:	e8 7f 3a 00 00       	call   80107990 <switchuvm>
    return 0;
80103f11:	83 c4 10             	add    $0x10,%esp
80103f14:	31 c0                	xor    %eax,%eax
}
80103f16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f19:	5b                   	pop    %ebx
80103f1a:	5e                   	pop    %esi
80103f1b:	5d                   	pop    %ebp
80103f1c:	c3                   	ret    
80103f1d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f20:	83 ec 04             	sub    $0x4,%esp
80103f23:	01 c6                	add    %eax,%esi
80103f25:	56                   	push   %esi
80103f26:	50                   	push   %eax
80103f27:	ff 73 04             	pushl  0x4(%ebx)
80103f2a:	e8 b1 3c 00 00       	call   80107be0 <allocuvm>
80103f2f:	83 c4 10             	add    $0x10,%esp
80103f32:	85 c0                	test   %eax,%eax
80103f34:	75 d0                	jne    80103f06 <growproc+0x26>
            return -1;
80103f36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f3b:	eb d9                	jmp    80103f16 <growproc+0x36>
80103f3d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f40:	83 ec 04             	sub    $0x4,%esp
80103f43:	01 c6                	add    %eax,%esi
80103f45:	56                   	push   %esi
80103f46:	50                   	push   %eax
80103f47:	ff 73 04             	pushl  0x4(%ebx)
80103f4a:	e8 c1 3d 00 00       	call   80107d10 <deallocuvm>
80103f4f:	83 c4 10             	add    $0x10,%esp
80103f52:	85 c0                	test   %eax,%eax
80103f54:	75 b0                	jne    80103f06 <growproc+0x26>
80103f56:	eb de                	jmp    80103f36 <growproc+0x56>
80103f58:	90                   	nop
80103f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f60 <rand>:
    bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
80103f60:	0f b7 05 5c b0 10 80 	movzwl 0x8010b05c,%eax
unsigned rand() {
80103f67:	55                   	push   %ebp
80103f68:	89 e5                	mov    %esp,%ebp
}
80103f6a:	5d                   	pop    %ebp
    bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
80103f6b:	89 c2                	mov    %eax,%edx
80103f6d:	89 c1                	mov    %eax,%ecx
80103f6f:	66 c1 e9 03          	shr    $0x3,%cx
80103f73:	66 c1 ea 02          	shr    $0x2,%dx
80103f77:	31 ca                	xor    %ecx,%edx
80103f79:	89 c1                	mov    %eax,%ecx
80103f7b:	31 c2                	xor    %eax,%edx
80103f7d:	66 c1 e9 05          	shr    $0x5,%cx
    return lfsr = (lfsr >> 1) | (bit << 15);
80103f81:	66 d1 e8             	shr    %ax
    bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
80103f84:	31 ca                	xor    %ecx,%edx
80103f86:	83 e2 01             	and    $0x1,%edx
80103f89:	0f b7 ca             	movzwl %dx,%ecx
    return lfsr = (lfsr >> 1) | (bit << 15);
80103f8c:	c1 e2 0f             	shl    $0xf,%edx
80103f8f:	09 d0                	or     %edx,%eax
    bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
80103f91:	89 0d 60 4d 11 80    	mov    %ecx,0x80114d60
    return lfsr = (lfsr >> 1) | (bit << 15);
80103f97:	66 a3 5c b0 10 80    	mov    %ax,0x8010b05c
80103f9d:	0f b7 c0             	movzwl %ax,%eax
}
80103fa0:	c3                   	ret    
80103fa1:	eb 0d                	jmp    80103fb0 <fork>
80103fa3:	90                   	nop
80103fa4:	90                   	nop
80103fa5:	90                   	nop
80103fa6:	90                   	nop
80103fa7:	90                   	nop
80103fa8:	90                   	nop
80103fa9:	90                   	nop
80103faa:	90                   	nop
80103fab:	90                   	nop
80103fac:	90                   	nop
80103fad:	90                   	nop
80103fae:	90                   	nop
80103faf:	90                   	nop

80103fb0 <fork>:
int fork(void) {
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	57                   	push   %edi
80103fb4:	56                   	push   %esi
80103fb5:	53                   	push   %ebx
80103fb6:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80103fb9:	e8 02 0e 00 00       	call   80104dc0 <pushcli>
    c = mycpu();
80103fbe:	e8 3d f8 ff ff       	call   80103800 <mycpu>
    p = c->proc;
80103fc3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103fc9:	e8 32 0e 00 00       	call   80104e00 <popcli>
    if ((np = allocproc()) == 0) {
80103fce:	e8 2d f6 ff ff       	call   80103600 <allocproc>
80103fd3:	85 c0                	test   %eax,%eax
80103fd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103fd8:	0f 84 ce 00 00 00    	je     801040ac <fork+0xfc>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103fde:	83 ec 08             	sub    $0x8,%esp
80103fe1:	ff 33                	pushl  (%ebx)
80103fe3:	ff 73 04             	pushl  0x4(%ebx)
80103fe6:	89 c7                	mov    %eax,%edi
80103fe8:	e8 a3 3e 00 00       	call   80107e90 <copyuvm>
80103fed:	83 c4 10             	add    $0x10,%esp
80103ff0:	85 c0                	test   %eax,%eax
80103ff2:	89 47 04             	mov    %eax,0x4(%edi)
80103ff5:	0f 84 b8 00 00 00    	je     801040b3 <fork+0x103>
    np->sz = curproc->sz;
80103ffb:	8b 03                	mov    (%ebx),%eax
80103ffd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104000:	89 01                	mov    %eax,(%ecx)
    np->parent = curproc;
80104002:	89 59 14             	mov    %ebx,0x14(%ecx)
80104005:	89 c8                	mov    %ecx,%eax
    *np->tf = *curproc->tf;
80104007:	8b 79 18             	mov    0x18(%ecx),%edi
8010400a:	8b 73 18             	mov    0x18(%ebx),%esi
8010400d:	b9 13 00 00 00       	mov    $0x13,%ecx
80104012:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++)
80104014:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
80104016:	8b 40 18             	mov    0x18(%eax),%eax
80104019:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
        if (curproc->ofile[i])
80104020:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104024:	85 c0                	test   %eax,%eax
80104026:	74 13                	je     8010403b <fork+0x8b>
            np->ofile[i] = filedup(curproc->ofile[i]);
80104028:	83 ec 0c             	sub    $0xc,%esp
8010402b:	50                   	push   %eax
8010402c:	e8 bf cd ff ff       	call   80100df0 <filedup>
80104031:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104034:	83 c4 10             	add    $0x10,%esp
80104037:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
    for (i = 0; i < NOFILE; i++)
8010403b:	83 c6 01             	add    $0x1,%esi
8010403e:	83 fe 10             	cmp    $0x10,%esi
80104041:	75 dd                	jne    80104020 <fork+0x70>
    np->cwd = idup(curproc->cwd);
80104043:	83 ec 0c             	sub    $0xc,%esp
80104046:	ff 73 68             	pushl  0x68(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104049:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
8010404c:	e8 ff d5 ff ff       	call   80101650 <idup>
80104051:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104054:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
80104057:	89 47 68             	mov    %eax,0x68(%edi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010405a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010405d:	6a 10                	push   $0x10
8010405f:	53                   	push   %ebx
80104060:	50                   	push   %eax
80104061:	e8 1a 11 00 00       	call   80105180 <safestrcpy>
    pid = np->pid;
80104066:	8b 5f 10             	mov    0x10(%edi),%ebx
    np->qno = 0;
80104069:	c7 87 90 00 00 00 00 	movl   $0x0,0x90(%edi)
80104070:	00 00 00 
    cprintf("Child with pid %d created\n", pid);
80104073:	58                   	pop    %eax
80104074:	5a                   	pop    %edx
80104075:	53                   	push   %ebx
80104076:	68 f0 85 10 80       	push   $0x801085f0
8010407b:	e8 e0 c5 ff ff       	call   80100660 <cprintf>
    acquire(&ptable.lock);
80104080:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
80104087:	e8 04 0e 00 00       	call   80104e90 <acquire>
    np->state = RUNNABLE;
8010408c:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
    release(&ptable.lock);
80104093:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
8010409a:	e8 b1 0e 00 00       	call   80104f50 <release>
    return pid;
8010409f:	83 c4 10             	add    $0x10,%esp
}
801040a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040a5:	89 d8                	mov    %ebx,%eax
801040a7:	5b                   	pop    %ebx
801040a8:	5e                   	pop    %esi
801040a9:	5f                   	pop    %edi
801040aa:	5d                   	pop    %ebp
801040ab:	c3                   	ret    
        return -1;
801040ac:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801040b1:	eb ef                	jmp    801040a2 <fork+0xf2>
        kfree(np->kstack);
801040b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801040b6:	83 ec 0c             	sub    $0xc,%esp
        return -1;
801040b9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
        kfree(np->kstack);
801040be:	ff 77 08             	pushl  0x8(%edi)
801040c1:	e8 4a e2 ff ff       	call   80102310 <kfree>
        np->kstack = 0;
801040c6:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
        np->state = UNUSED;
801040cd:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
        return -1;
801040d4:	83 c4 10             	add    $0x10,%esp
801040d7:	eb c9                	jmp    801040a2 <fork+0xf2>
801040d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040e0 <set_priority>:
int set_priority(int pid, int priority) {
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	53                   	push   %ebx
801040e4:	83 ec 10             	sub    $0x10,%esp
801040e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
801040ea:	68 60 7c 11 80       	push   $0x80117c60
801040ef:	e8 9c 0d 00 00       	call   80104e90 <acquire>
801040f4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040f7:	ba 94 7c 11 80       	mov    $0x80117c94,%edx
801040fc:	eb 10                	jmp    8010410e <set_priority+0x2e>
801040fe:	66 90                	xchg   %ax,%ax
80104100:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80104106:	81 fa 94 ab 11 80    	cmp    $0x8011ab94,%edx
8010410c:	73 32                	jae    80104140 <set_priority+0x60>
        if (p->pid == pid) {
8010410e:	39 5a 10             	cmp    %ebx,0x10(%edx)
80104111:	75 ed                	jne    80104100 <set_priority+0x20>
            p->priority = priority;
80104113:	8b 45 0c             	mov    0xc(%ebp),%eax
            val = p->priority;
80104116:	8b 9a 8c 00 00 00    	mov    0x8c(%edx),%ebx
            p->priority = priority;
8010411c:	89 82 8c 00 00 00    	mov    %eax,0x8c(%edx)
    release(&ptable.lock);
80104122:	83 ec 0c             	sub    $0xc,%esp
80104125:	68 60 7c 11 80       	push   $0x80117c60
8010412a:	e8 21 0e 00 00       	call   80104f50 <release>
}
8010412f:	89 d8                	mov    %ebx,%eax
80104131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104134:	c9                   	leave  
80104135:	c3                   	ret    
80104136:	8d 76 00             	lea    0x0(%esi),%esi
80104139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    int val = -1;  // in order to return old priority of the process
80104140:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104145:	eb db                	jmp    80104122 <set_priority+0x42>
80104147:	89 f6                	mov    %esi,%esi
80104149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104150 <check_priority>:
int check_priority(int prt) {
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 10             	sub    $0x10,%esp
80104157:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
8010415a:	68 60 7c 11 80       	push   $0x80117c60
8010415f:	e8 2c 0d 00 00       	call   80104e90 <acquire>
80104164:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104167:	b8 94 7c 11 80       	mov    $0x80117c94,%eax
8010416c:	eb 0e                	jmp    8010417c <check_priority+0x2c>
8010416e:	66 90                	xchg   %ax,%ax
80104170:	05 bc 00 00 00       	add    $0xbc,%eax
80104175:	3d 94 ab 11 80       	cmp    $0x8011ab94,%eax
8010417a:	73 2c                	jae    801041a8 <check_priority+0x58>
        if (p->state != RUNNABLE)
8010417c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104180:	75 ee                	jne    80104170 <check_priority+0x20>
        if (p->priority <= prt) {
80104182:	39 98 8c 00 00 00    	cmp    %ebx,0x8c(%eax)
80104188:	7f e6                	jg     80104170 <check_priority+0x20>
            release(&ptable.lock);
8010418a:	83 ec 0c             	sub    $0xc,%esp
8010418d:	68 60 7c 11 80       	push   $0x80117c60
80104192:	e8 b9 0d 00 00       	call   80104f50 <release>
            return 1;
80104197:	83 c4 10             	add    $0x10,%esp
8010419a:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010419f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041a2:	c9                   	leave  
801041a3:	c3                   	ret    
801041a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	68 60 7c 11 80       	push   $0x80117c60
801041b0:	e8 9b 0d 00 00       	call   80104f50 <release>
    return 0;
801041b5:	83 c4 10             	add    $0x10,%esp
801041b8:	31 c0                	xor    %eax,%eax
}
801041ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041bd:	c9                   	leave  
801041be:	c3                   	ret    
801041bf:	90                   	nop

801041c0 <scheduler>:
void scheduler(void) {
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	57                   	push   %edi
801041c4:	56                   	push   %esi
801041c5:	53                   	push   %ebx
801041c6:	83 ec 0c             	sub    $0xc,%esp
    struct cpu *c = mycpu();
801041c9:	e8 32 f6 ff ff       	call   80103800 <mycpu>
801041ce:	8d 78 04             	lea    0x4(%eax),%edi
801041d1:	89 c6                	mov    %eax,%esi
    c->proc = 0;
801041d3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041da:	00 00 00 
801041dd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801041e0:	fb                   	sti    
        acquire(&ptable.lock);
801041e1:	83 ec 0c             	sub    $0xc,%esp
801041e4:	68 60 7c 11 80       	push   $0x80117c60
801041e9:	e8 a2 0c 00 00       	call   80104e90 <acquire>
            for (int i = 0; i < cnt[0]; i++) {
801041ee:	8b 15 1c b6 10 80    	mov    0x8010b61c,%edx
801041f4:	83 c4 10             	add    $0x10,%esp
801041f7:	85 d2                	test   %edx,%edx
801041f9:	0f 8e 91 00 00 00    	jle    80104290 <scheduler+0xd0>
                p = q0[i];
801041ff:	8b 1d c0 6c 11 80    	mov    0x80116cc0,%ebx
            for (int i = 0; i < cnt[0]; i++) {
80104205:	31 c0                	xor    %eax,%eax
                if (p->state != RUNNABLE)
80104207:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010420b:	74 14                	je     80104221 <scheduler+0x61>
            for (int i = 0; i < cnt[0]; i++) {
8010420d:	83 c0 01             	add    $0x1,%eax
80104210:	39 c2                	cmp    %eax,%edx
80104212:	74 7c                	je     80104290 <scheduler+0xd0>
                p = q0[i];
80104214:	8b 1c 85 c0 6c 11 80 	mov    -0x7fee9340(,%eax,4),%ebx
                if (p->state != RUNNABLE)
8010421b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010421f:	75 ec                	jne    8010420d <scheduler+0x4d>
                beg0 = i;
80104221:	a3 54 b6 10 80       	mov    %eax,0x8010b654
                switchuvm(p);
80104226:	83 ec 0c             	sub    $0xc,%esp
                c->proc = p;
80104229:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
                switchuvm(p);
8010422f:	53                   	push   %ebx
80104230:	e8 5b 37 00 00       	call   80107990 <switchuvm>
                p->stat.num_run++;
80104235:	83 83 a0 00 00 00 01 	addl   $0x1,0xa0(%ebx)
                p->state = RUNNING;
8010423c:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
                    p->name, p->pid, p->qno, p->rtime);
80104243:	83 c3 6c             	add    $0x6c,%ebx
                swtch(&(c->scheduler), p->context);
80104246:	58                   	pop    %eax
80104247:	5a                   	pop    %edx
80104248:	ff 73 b0             	pushl  -0x50(%ebx)
8010424b:	57                   	push   %edi
8010424c:	e8 8a 0f 00 00       	call   801051db <swtch>
                cprintf(
80104251:	59                   	pop    %ecx
80104252:	ff 73 14             	pushl  0x14(%ebx)
80104255:	ff 73 24             	pushl  0x24(%ebx)
80104258:	ff 73 a4             	pushl  -0x5c(%ebx)
8010425b:	53                   	push   %ebx
8010425c:	68 b8 87 10 80       	push   $0x801087b8
80104261:	e8 fa c3 ff ff       	call   80100660 <cprintf>
                switchkvm();
80104266:	83 c4 20             	add    $0x20,%esp
80104269:	e8 02 37 00 00       	call   80107970 <switchkvm>
                c->proc = 0;
8010426e:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104275:	00 00 00 
        release(&ptable.lock);
80104278:	83 ec 0c             	sub    $0xc,%esp
8010427b:	68 60 7c 11 80       	push   $0x80117c60
80104280:	e8 cb 0c 00 00       	call   80104f50 <release>
    for (;;) {
80104285:	83 c4 10             	add    $0x10,%esp
80104288:	e9 53 ff ff ff       	jmp    801041e0 <scheduler+0x20>
8010428d:	8d 76 00             	lea    0x0(%esi),%esi
            for (int i = 0; i < cnt[1]; i++) {
80104290:	8b 15 20 b6 10 80    	mov    0x8010b620,%edx
80104296:	85 d2                	test   %edx,%edx
80104298:	7e 36                	jle    801042d0 <scheduler+0x110>
                p = q1[i];
8010429a:	8b 1d 20 5d 11 80    	mov    0x80115d20,%ebx
            for (int i = 0; i < cnt[1]; i++) {
801042a0:	31 c0                	xor    %eax,%eax
                if (p->state != RUNNABLE)
801042a2:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801042a6:	74 14                	je     801042bc <scheduler+0xfc>
            for (int i = 0; i < cnt[1]; i++) {
801042a8:	83 c0 01             	add    $0x1,%eax
801042ab:	39 d0                	cmp    %edx,%eax
801042ad:	74 21                	je     801042d0 <scheduler+0x110>
                p = q1[i];
801042af:	8b 1c 85 20 5d 11 80 	mov    -0x7feea2e0(,%eax,4),%ebx
                if (p->state != RUNNABLE)
801042b6:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801042ba:	75 ec                	jne    801042a8 <scheduler+0xe8>
                beg1 = i;
801042bc:	a3 50 b6 10 80       	mov    %eax,0x8010b650
801042c1:	e9 60 ff ff ff       	jmp    80104226 <scheduler+0x66>
801042c6:	8d 76 00             	lea    0x0(%esi),%esi
801042c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            for (int i = 0; i < cnt[2]; i++) {
801042d0:	8b 15 24 b6 10 80    	mov    0x8010b624,%edx
801042d6:	85 d2                	test   %edx,%edx
801042d8:	7e 36                	jle    80104310 <scheduler+0x150>
                p = q2[i];
801042da:	8b 1d c0 3d 11 80    	mov    0x80113dc0,%ebx
            for (int i = 0; i < cnt[2]; i++) {
801042e0:	31 c0                	xor    %eax,%eax
                if (p->state != RUNNABLE)
801042e2:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801042e6:	74 1c                	je     80104304 <scheduler+0x144>
801042e8:	90                   	nop
801042e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (int i = 0; i < cnt[2]; i++) {
801042f0:	83 c0 01             	add    $0x1,%eax
801042f3:	39 d0                	cmp    %edx,%eax
801042f5:	74 19                	je     80104310 <scheduler+0x150>
                p = q2[i];
801042f7:	8b 1c 85 c0 3d 11 80 	mov    -0x7feec240(,%eax,4),%ebx
                if (p->state != RUNNABLE)
801042fe:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104302:	75 ec                	jne    801042f0 <scheduler+0x130>
                beg2 = i;
80104304:	a3 4c b6 10 80       	mov    %eax,0x8010b64c
80104309:	e9 18 ff ff ff       	jmp    80104226 <scheduler+0x66>
8010430e:	66 90                	xchg   %ax,%ax
            for (int i = 0; i < cnt[3]; i++) {
80104310:	8b 15 28 b6 10 80    	mov    0x8010b628,%edx
80104316:	85 d2                	test   %edx,%edx
80104318:	7e 36                	jle    80104350 <scheduler+0x190>
                p = q3[i];
8010431a:	8b 1d 80 4d 11 80    	mov    0x80114d80,%ebx
                if (p->state != RUNNABLE)
80104320:	31 c0                	xor    %eax,%eax
80104322:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104326:	74 1c                	je     80104344 <scheduler+0x184>
80104328:	90                   	nop
80104329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (int i = 0; i < cnt[3]; i++) {
80104330:	83 c0 01             	add    $0x1,%eax
80104333:	39 d0                	cmp    %edx,%eax
80104335:	74 19                	je     80104350 <scheduler+0x190>
                p = q3[i];
80104337:	8b 1c 85 80 4d 11 80 	mov    -0x7feeb280(,%eax,4),%ebx
                if (p->state != RUNNABLE)
8010433e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104342:	75 ec                	jne    80104330 <scheduler+0x170>
                beg3 = i;
80104344:	a3 48 b6 10 80       	mov    %eax,0x8010b648
80104349:	e9 d8 fe ff ff       	jmp    80104226 <scheduler+0x66>
8010434e:	66 90                	xchg   %ax,%ax
            for (int i = 0; i < cnt[4]; i++) {
80104350:	8b 15 2c b6 10 80    	mov    0x8010b62c,%edx
80104356:	85 d2                	test   %edx,%edx
80104358:	0f 8e 1a ff ff ff    	jle    80104278 <scheduler+0xb8>
                p = q4[i];
8010435e:	8b 1d a0 ab 11 80    	mov    0x8011aba0,%ebx
            for (int i = 0; i < cnt[4]; i++) {
80104364:	31 c0                	xor    %eax,%eax
                if (p->state != RUNNABLE)
80104366:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010436a:	74 1c                	je     80104388 <scheduler+0x1c8>
8010436c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (int i = 0; i < cnt[4]; i++) {
80104370:	83 c0 01             	add    $0x1,%eax
80104373:	39 d0                	cmp    %edx,%eax
80104375:	0f 84 fd fe ff ff    	je     80104278 <scheduler+0xb8>
                p = q4[i];
8010437b:	8b 1c 85 a0 ab 11 80 	mov    -0x7fee5460(,%eax,4),%ebx
                if (p->state != RUNNABLE)
80104382:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104386:	75 e8                	jne    80104370 <scheduler+0x1b0>
                beg4 = i;
80104388:	a3 44 b6 10 80       	mov    %eax,0x8010b644
8010438d:	e9 94 fe ff ff       	jmp    80104226 <scheduler+0x66>
80104392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043a0 <sched>:
void sched(void) {
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
    pushcli();
801043a5:	e8 16 0a 00 00       	call   80104dc0 <pushcli>
    c = mycpu();
801043aa:	e8 51 f4 ff ff       	call   80103800 <mycpu>
    p = c->proc;
801043af:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801043b5:	e8 46 0a 00 00       	call   80104e00 <popcli>
    if (!holding(&ptable.lock))
801043ba:	83 ec 0c             	sub    $0xc,%esp
801043bd:	68 60 7c 11 80       	push   $0x80117c60
801043c2:	e8 99 0a 00 00       	call   80104e60 <holding>
801043c7:	83 c4 10             	add    $0x10,%esp
801043ca:	85 c0                	test   %eax,%eax
801043cc:	74 4f                	je     8010441d <sched+0x7d>
    if (mycpu()->ncli != 1)
801043ce:	e8 2d f4 ff ff       	call   80103800 <mycpu>
801043d3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801043da:	75 68                	jne    80104444 <sched+0xa4>
    if (p->state == RUNNING)
801043dc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801043e0:	74 55                	je     80104437 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043e2:	9c                   	pushf  
801043e3:	58                   	pop    %eax
    if (readeflags() & FL_IF)
801043e4:	f6 c4 02             	test   $0x2,%ah
801043e7:	75 41                	jne    8010442a <sched+0x8a>
    intena = mycpu()->intena;
801043e9:	e8 12 f4 ff ff       	call   80103800 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
801043ee:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
801043f1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
801043f7:	e8 04 f4 ff ff       	call   80103800 <mycpu>
801043fc:	83 ec 08             	sub    $0x8,%esp
801043ff:	ff 70 04             	pushl  0x4(%eax)
80104402:	53                   	push   %ebx
80104403:	e8 d3 0d 00 00       	call   801051db <swtch>
    mycpu()->intena = intena;
80104408:	e8 f3 f3 ff ff       	call   80103800 <mycpu>
}
8010440d:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80104410:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104416:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104419:	5b                   	pop    %ebx
8010441a:	5e                   	pop    %esi
8010441b:	5d                   	pop    %ebp
8010441c:	c3                   	ret    
        panic("sched ptable.lock");
8010441d:	83 ec 0c             	sub    $0xc,%esp
80104420:	68 0b 86 10 80       	push   $0x8010860b
80104425:	e8 66 bf ff ff       	call   80100390 <panic>
        panic("sched interruptible");
8010442a:	83 ec 0c             	sub    $0xc,%esp
8010442d:	68 37 86 10 80       	push   $0x80108637
80104432:	e8 59 bf ff ff       	call   80100390 <panic>
        panic("sched running");
80104437:	83 ec 0c             	sub    $0xc,%esp
8010443a:	68 29 86 10 80       	push   $0x80108629
8010443f:	e8 4c bf ff ff       	call   80100390 <panic>
        panic("sched locks");
80104444:	83 ec 0c             	sub    $0xc,%esp
80104447:	68 1d 86 10 80       	push   $0x8010861d
8010444c:	e8 3f bf ff ff       	call   80100390 <panic>
80104451:	eb 0d                	jmp    80104460 <exit>
80104453:	90                   	nop
80104454:	90                   	nop
80104455:	90                   	nop
80104456:	90                   	nop
80104457:	90                   	nop
80104458:	90                   	nop
80104459:	90                   	nop
8010445a:	90                   	nop
8010445b:	90                   	nop
8010445c:	90                   	nop
8010445d:	90                   	nop
8010445e:	90                   	nop
8010445f:	90                   	nop

80104460 <exit>:
void exit(void) {
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	57                   	push   %edi
80104464:	56                   	push   %esi
80104465:	53                   	push   %ebx
80104466:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
80104469:	e8 52 09 00 00       	call   80104dc0 <pushcli>
    c = mycpu();
8010446e:	e8 8d f3 ff ff       	call   80103800 <mycpu>
    p = c->proc;
80104473:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104479:	e8 82 09 00 00       	call   80104e00 <popcli>
    if (curproc == initproc)
8010447e:	39 35 58 b6 10 80    	cmp    %esi,0x8010b658
80104484:	8d 5e 28             	lea    0x28(%esi),%ebx
80104487:	8d 7e 68             	lea    0x68(%esi),%edi
8010448a:	0f 84 fc 00 00 00    	je     8010458c <exit+0x12c>
        if (curproc->ofile[fd]) {
80104490:	8b 03                	mov    (%ebx),%eax
80104492:	85 c0                	test   %eax,%eax
80104494:	74 12                	je     801044a8 <exit+0x48>
            fileclose(curproc->ofile[fd]);
80104496:	83 ec 0c             	sub    $0xc,%esp
80104499:	50                   	push   %eax
8010449a:	e8 a1 c9 ff ff       	call   80100e40 <fileclose>
            curproc->ofile[fd] = 0;
8010449f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801044a5:	83 c4 10             	add    $0x10,%esp
801044a8:	83 c3 04             	add    $0x4,%ebx
    for (fd = 0; fd < NOFILE; fd++) {
801044ab:	39 fb                	cmp    %edi,%ebx
801044ad:	75 e1                	jne    80104490 <exit+0x30>
    begin_op();
801044af:	e8 ec e6 ff ff       	call   80102ba0 <begin_op>
    iput(curproc->cwd);
801044b4:	83 ec 0c             	sub    $0xc,%esp
801044b7:	ff 76 68             	pushl  0x68(%esi)
801044ba:	e8 f1 d2 ff ff       	call   801017b0 <iput>
    end_op();
801044bf:	e8 4c e7 ff ff       	call   80102c10 <end_op>
    curproc->cwd = 0;
801044c4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
    acquire(&ptable.lock);
801044cb:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
801044d2:	e8 b9 09 00 00       	call   80104e90 <acquire>
    wakeup1(curproc->parent);
801044d7:	8b 56 14             	mov    0x14(%esi),%edx
801044da:	83 c4 10             	add    $0x10,%esp
// PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void wakeup1(void *chan) {
    struct proc *p;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044dd:	b8 94 7c 11 80       	mov    $0x80117c94,%eax
801044e2:	eb 10                	jmp    801044f4 <exit+0x94>
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e8:	05 bc 00 00 00       	add    $0xbc,%eax
801044ed:	3d 94 ab 11 80       	cmp    $0x8011ab94,%eax
801044f2:	73 1e                	jae    80104512 <exit+0xb2>
        if (p->state == SLEEPING && p->chan == chan) {
801044f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044f8:	75 ee                	jne    801044e8 <exit+0x88>
801044fa:	3b 50 20             	cmp    0x20(%eax),%edx
801044fd:	75 e9                	jne    801044e8 <exit+0x88>
            p->state = RUNNABLE;
801044ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104506:	05 bc 00 00 00       	add    $0xbc,%eax
8010450b:	3d 94 ab 11 80       	cmp    $0x8011ab94,%eax
80104510:	72 e2                	jb     801044f4 <exit+0x94>
            p->parent = initproc;
80104512:	8b 0d 58 b6 10 80    	mov    0x8010b658,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104518:	ba 94 7c 11 80       	mov    $0x80117c94,%edx
8010451d:	eb 0f                	jmp    8010452e <exit+0xce>
8010451f:	90                   	nop
80104520:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80104526:	81 fa 94 ab 11 80    	cmp    $0x8011ab94,%edx
8010452c:	73 3a                	jae    80104568 <exit+0x108>
        if (p->parent == curproc) {
8010452e:	39 72 14             	cmp    %esi,0x14(%edx)
80104531:	75 ed                	jne    80104520 <exit+0xc0>
            if (p->state == ZOMBIE)
80104533:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
80104537:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
8010453a:	75 e4                	jne    80104520 <exit+0xc0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010453c:	b8 94 7c 11 80       	mov    $0x80117c94,%eax
80104541:	eb 11                	jmp    80104554 <exit+0xf4>
80104543:	90                   	nop
80104544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104548:	05 bc 00 00 00       	add    $0xbc,%eax
8010454d:	3d 94 ab 11 80       	cmp    $0x8011ab94,%eax
80104552:	73 cc                	jae    80104520 <exit+0xc0>
        if (p->state == SLEEPING && p->chan == chan) {
80104554:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104558:	75 ee                	jne    80104548 <exit+0xe8>
8010455a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010455d:	75 e9                	jne    80104548 <exit+0xe8>
            p->state = RUNNABLE;
8010455f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104566:	eb e0                	jmp    80104548 <exit+0xe8>
    curproc->etime = ticks;  // assign endtime value
80104568:	a1 80 c3 11 80       	mov    0x8011c380,%eax
    curproc->state = ZOMBIE;
8010456d:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    curproc->etime = ticks;  // assign endtime value
80104574:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
    sched();
8010457a:	e8 21 fe ff ff       	call   801043a0 <sched>
    panic("zombie exit");
8010457f:	83 ec 0c             	sub    $0xc,%esp
80104582:	68 58 86 10 80       	push   $0x80108658
80104587:	e8 04 be ff ff       	call   80100390 <panic>
        panic("init exiting");
8010458c:	83 ec 0c             	sub    $0xc,%esp
8010458f:	68 4b 86 10 80       	push   $0x8010864b
80104594:	e8 f7 bd ff ff       	call   80100390 <panic>
80104599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045a0 <yield>:
void yield(void) {
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  // DOC: yieldlock
801045a7:	68 60 7c 11 80       	push   $0x80117c60
801045ac:	e8 df 08 00 00       	call   80104e90 <acquire>
    pushcli();
801045b1:	e8 0a 08 00 00       	call   80104dc0 <pushcli>
    c = mycpu();
801045b6:	e8 45 f2 ff ff       	call   80103800 <mycpu>
    p = c->proc;
801045bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801045c1:	e8 3a 08 00 00       	call   80104e00 <popcli>
    myproc()->state = RUNNABLE;
801045c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    pushcli();
801045cd:	e8 ee 07 00 00       	call   80104dc0 <pushcli>
    c = mycpu();
801045d2:	e8 29 f2 ff ff       	call   80103800 <mycpu>
    p = c->proc;
801045d7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801045dd:	e8 1e 08 00 00       	call   80104e00 <popcli>
    cprintf("Yield of process with pid %d\n", myproc()->pid);
801045e2:	58                   	pop    %eax
801045e3:	5a                   	pop    %edx
801045e4:	ff 73 10             	pushl  0x10(%ebx)
801045e7:	68 64 86 10 80       	push   $0x80108664
801045ec:	e8 6f c0 ff ff       	call   80100660 <cprintf>
    sched();
801045f1:	e8 aa fd ff ff       	call   801043a0 <sched>
    release(&ptable.lock);
801045f6:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
801045fd:	e8 4e 09 00 00       	call   80104f50 <release>
}
80104602:	83 c4 10             	add    $0x10,%esp
80104605:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104608:	c9                   	leave  
80104609:	c3                   	ret    
8010460a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104610 <sleep>:
void sleep(void *chan, struct spinlock *lk) {
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	57                   	push   %edi
80104614:	56                   	push   %esi
80104615:	53                   	push   %ebx
80104616:	83 ec 0c             	sub    $0xc,%esp
80104619:	8b 7d 08             	mov    0x8(%ebp),%edi
8010461c:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
8010461f:	e8 9c 07 00 00       	call   80104dc0 <pushcli>
    c = mycpu();
80104624:	e8 d7 f1 ff ff       	call   80103800 <mycpu>
    p = c->proc;
80104629:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
8010462f:	e8 cc 07 00 00       	call   80104e00 <popcli>
    if (p == 0)
80104634:	85 db                	test   %ebx,%ebx
80104636:	0f 84 87 00 00 00    	je     801046c3 <sleep+0xb3>
    if (lk == 0)
8010463c:	85 f6                	test   %esi,%esi
8010463e:	74 76                	je     801046b6 <sleep+0xa6>
    if (lk != &ptable.lock) {   // DOC: sleeplock0
80104640:	81 fe 60 7c 11 80    	cmp    $0x80117c60,%esi
80104646:	74 50                	je     80104698 <sleep+0x88>
        acquire(&ptable.lock);  // DOC: sleeplock1
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	68 60 7c 11 80       	push   $0x80117c60
80104650:	e8 3b 08 00 00       	call   80104e90 <acquire>
        release(lk);
80104655:	89 34 24             	mov    %esi,(%esp)
80104658:	e8 f3 08 00 00       	call   80104f50 <release>
    p->chan = chan;
8010465d:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
80104660:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104667:	e8 34 fd ff ff       	call   801043a0 <sched>
    p->chan = 0;
8010466c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
80104673:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
8010467a:	e8 d1 08 00 00       	call   80104f50 <release>
        acquire(lk);
8010467f:	89 75 08             	mov    %esi,0x8(%ebp)
80104682:	83 c4 10             	add    $0x10,%esp
}
80104685:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104688:	5b                   	pop    %ebx
80104689:	5e                   	pop    %esi
8010468a:	5f                   	pop    %edi
8010468b:	5d                   	pop    %ebp
        acquire(lk);
8010468c:	e9 ff 07 00 00       	jmp    80104e90 <acquire>
80104691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->chan = chan;
80104698:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010469b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
801046a2:	e8 f9 fc ff ff       	call   801043a0 <sched>
    p->chan = 0;
801046a7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801046ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046b1:	5b                   	pop    %ebx
801046b2:	5e                   	pop    %esi
801046b3:	5f                   	pop    %edi
801046b4:	5d                   	pop    %ebp
801046b5:	c3                   	ret    
        panic("sleep without lk");
801046b6:	83 ec 0c             	sub    $0xc,%esp
801046b9:	68 88 86 10 80       	push   $0x80108688
801046be:	e8 cd bc ff ff       	call   80100390 <panic>
        panic("sleep");
801046c3:	83 ec 0c             	sub    $0xc,%esp
801046c6:	68 82 86 10 80       	push   $0x80108682
801046cb:	e8 c0 bc ff ff       	call   80100390 <panic>

801046d0 <wait>:
int wait(void) {
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
    pushcli();
801046d5:	e8 e6 06 00 00       	call   80104dc0 <pushcli>
    c = mycpu();
801046da:	e8 21 f1 ff ff       	call   80103800 <mycpu>
    p = c->proc;
801046df:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801046e5:	e8 16 07 00 00       	call   80104e00 <popcli>
    acquire(&ptable.lock);
801046ea:	83 ec 0c             	sub    $0xc,%esp
801046ed:	68 60 7c 11 80       	push   $0x80117c60
801046f2:	e8 99 07 00 00       	call   80104e90 <acquire>
801046f7:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
801046fa:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801046fc:	bb 94 7c 11 80       	mov    $0x80117c94,%ebx
80104701:	eb 13                	jmp    80104716 <wait+0x46>
80104703:	90                   	nop
80104704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104708:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
8010470e:	81 fb 94 ab 11 80    	cmp    $0x8011ab94,%ebx
80104714:	73 1e                	jae    80104734 <wait+0x64>
            if (p->parent != curproc)
80104716:	39 73 14             	cmp    %esi,0x14(%ebx)
80104719:	75 ed                	jne    80104708 <wait+0x38>
            if (p->state == ZOMBIE) {
8010471b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010471f:	74 37                	je     80104758 <wait+0x88>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104721:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
            havekids = 1;
80104727:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010472c:	81 fb 94 ab 11 80    	cmp    $0x8011ab94,%ebx
80104732:	72 e2                	jb     80104716 <wait+0x46>
        if (!havekids || curproc->killed) {
80104734:	85 c0                	test   %eax,%eax
80104736:	74 76                	je     801047ae <wait+0xde>
80104738:	8b 46 24             	mov    0x24(%esi),%eax
8010473b:	85 c0                	test   %eax,%eax
8010473d:	75 6f                	jne    801047ae <wait+0xde>
        sleep(curproc, &ptable.lock);  // DOC: wait-sleep
8010473f:	83 ec 08             	sub    $0x8,%esp
80104742:	68 60 7c 11 80       	push   $0x80117c60
80104747:	56                   	push   %esi
80104748:	e8 c3 fe ff ff       	call   80104610 <sleep>
        havekids = 0;
8010474d:	83 c4 10             	add    $0x10,%esp
80104750:	eb a8                	jmp    801046fa <wait+0x2a>
80104752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                kfree(p->kstack);
80104758:	83 ec 0c             	sub    $0xc,%esp
8010475b:	ff 73 08             	pushl  0x8(%ebx)
8010475e:	e8 ad db ff ff       	call   80102310 <kfree>
                freevm(p->pgdir);
80104763:	5a                   	pop    %edx
80104764:	ff 73 04             	pushl  0x4(%ebx)
                p->kstack = 0;
80104767:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
8010476e:	e8 cd 35 00 00       	call   80107d40 <freevm>
                release(&ptable.lock);
80104773:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
                p->pid = 0;
8010477a:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104781:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80104788:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
8010478c:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80104793:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
8010479a:	e8 b1 07 00 00       	call   80104f50 <release>
                return pid;
8010479f:	83 c4 10             	add    $0x10,%esp
}
801047a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047aa:	5b                   	pop    %ebx
801047ab:	5e                   	pop    %esi
801047ac:	5d                   	pop    %ebp
801047ad:	c3                   	ret    
            release(&ptable.lock);
801047ae:	83 ec 0c             	sub    $0xc,%esp
801047b1:	68 60 7c 11 80       	push   $0x80117c60
801047b6:	e8 95 07 00 00       	call   80104f50 <release>
            return -1;
801047bb:	83 c4 10             	add    $0x10,%esp
801047be:	eb e2                	jmp    801047a2 <wait+0xd2>

801047c0 <waitx>:
int waitx(int *wtime, int *rtime) {
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	53                   	push   %ebx
    pushcli();
801047c5:	e8 f6 05 00 00       	call   80104dc0 <pushcli>
    c = mycpu();
801047ca:	e8 31 f0 ff ff       	call   80103800 <mycpu>
    p = c->proc;
801047cf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801047d5:	e8 26 06 00 00       	call   80104e00 <popcli>
    acquire(&ptable.lock);
801047da:	83 ec 0c             	sub    $0xc,%esp
801047dd:	68 60 7c 11 80       	push   $0x80117c60
801047e2:	e8 a9 06 00 00       	call   80104e90 <acquire>
801047e7:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
801047ea:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801047ec:	bb 94 7c 11 80       	mov    $0x80117c94,%ebx
801047f1:	eb 13                	jmp    80104806 <waitx+0x46>
801047f3:	90                   	nop
801047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047f8:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
801047fe:	81 fb 94 ab 11 80    	cmp    $0x8011ab94,%ebx
80104804:	73 1e                	jae    80104824 <waitx+0x64>
            if (p->parent != curproc)
80104806:	39 73 14             	cmp    %esi,0x14(%ebx)
80104809:	75 ed                	jne    801047f8 <waitx+0x38>
            if (p->state == ZOMBIE) {
8010480b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010480f:	74 3f                	je     80104850 <waitx+0x90>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104811:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
            havekids = 1;
80104817:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010481c:	81 fb 94 ab 11 80    	cmp    $0x8011ab94,%ebx
80104822:	72 e2                	jb     80104806 <waitx+0x46>
        if (!havekids || curproc->killed) {
80104824:	85 c0                	test   %eax,%eax
80104826:	0f 84 9f 00 00 00    	je     801048cb <waitx+0x10b>
8010482c:	8b 46 24             	mov    0x24(%esi),%eax
8010482f:	85 c0                	test   %eax,%eax
80104831:	0f 85 94 00 00 00    	jne    801048cb <waitx+0x10b>
        sleep(curproc, &ptable.lock);  // DOC: wait-sleep
80104837:	83 ec 08             	sub    $0x8,%esp
8010483a:	68 60 7c 11 80       	push   $0x80117c60
8010483f:	56                   	push   %esi
80104840:	e8 cb fd ff ff       	call   80104610 <sleep>
        havekids = 0;
80104845:	83 c4 10             	add    $0x10,%esp
80104848:	eb a0                	jmp    801047ea <waitx+0x2a>
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                *wtime = p->etime - p->ctime - p->rtime - p->iotime;
80104850:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80104856:	2b 43 7c             	sub    0x7c(%ebx),%eax
                kfree(p->kstack);
80104859:	83 ec 0c             	sub    $0xc,%esp
                *wtime = p->etime - p->ctime - p->rtime - p->iotime;
8010485c:	2b 83 80 00 00 00    	sub    0x80(%ebx),%eax
80104862:	8b 55 08             	mov    0x8(%ebp),%edx
80104865:	2b 83 88 00 00 00    	sub    0x88(%ebx),%eax
8010486b:	89 02                	mov    %eax,(%edx)
                *rtime = p->rtime;
8010486d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104870:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
80104876:	89 10                	mov    %edx,(%eax)
                kfree(p->kstack);
80104878:	ff 73 08             	pushl  0x8(%ebx)
                pid = p->pid;
8010487b:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
8010487e:	e8 8d da ff ff       	call   80102310 <kfree>
                freevm(p->pgdir);
80104883:	5a                   	pop    %edx
80104884:	ff 73 04             	pushl  0x4(%ebx)
                p->kstack = 0;
80104887:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
8010488e:	e8 ad 34 00 00       	call   80107d40 <freevm>
                release(&ptable.lock);
80104893:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
                p->pid = 0;
8010489a:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
801048a1:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
801048a8:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
801048ac:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
801048b3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
801048ba:	e8 91 06 00 00       	call   80104f50 <release>
                return pid;
801048bf:	83 c4 10             	add    $0x10,%esp
}
801048c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048c5:	89 f0                	mov    %esi,%eax
801048c7:	5b                   	pop    %ebx
801048c8:	5e                   	pop    %esi
801048c9:	5d                   	pop    %ebp
801048ca:	c3                   	ret    
            release(&ptable.lock);
801048cb:	83 ec 0c             	sub    $0xc,%esp
            return -1;
801048ce:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
801048d3:	68 60 7c 11 80       	push   $0x80117c60
801048d8:	e8 73 06 00 00       	call   80104f50 <release>
            return -1;
801048dd:	83 c4 10             	add    $0x10,%esp
801048e0:	eb e0                	jmp    801048c2 <waitx+0x102>
801048e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048f0 <wakeup>:
            // }
        }
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan) {
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
801048f4:	83 ec 10             	sub    $0x10,%esp
801048f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
801048fa:	68 60 7c 11 80       	push   $0x80117c60
801048ff:	e8 8c 05 00 00       	call   80104e90 <acquire>
80104904:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104907:	b8 94 7c 11 80       	mov    $0x80117c94,%eax
8010490c:	eb 0e                	jmp    8010491c <wakeup+0x2c>
8010490e:	66 90                	xchg   %ax,%ax
80104910:	05 bc 00 00 00       	add    $0xbc,%eax
80104915:	3d 94 ab 11 80       	cmp    $0x8011ab94,%eax
8010491a:	73 1e                	jae    8010493a <wakeup+0x4a>
        if (p->state == SLEEPING && p->chan == chan) {
8010491c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104920:	75 ee                	jne    80104910 <wakeup+0x20>
80104922:	3b 58 20             	cmp    0x20(%eax),%ebx
80104925:	75 e9                	jne    80104910 <wakeup+0x20>
            p->state = RUNNABLE;
80104927:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010492e:	05 bc 00 00 00       	add    $0xbc,%eax
80104933:	3d 94 ab 11 80       	cmp    $0x8011ab94,%eax
80104938:	72 e2                	jb     8010491c <wakeup+0x2c>
    wakeup1(chan);
    release(&ptable.lock);
8010493a:	c7 45 08 60 7c 11 80 	movl   $0x80117c60,0x8(%ebp)
}
80104941:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104944:	c9                   	leave  
    release(&ptable.lock);
80104945:	e9 06 06 00 00       	jmp    80104f50 <release>
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104950 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid) {
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	53                   	push   %ebx
80104954:	83 ec 10             	sub    $0x10,%esp
80104957:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
8010495a:	68 60 7c 11 80       	push   $0x80117c60
8010495f:	e8 2c 05 00 00       	call   80104e90 <acquire>
80104964:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104967:	b8 94 7c 11 80       	mov    $0x80117c94,%eax
8010496c:	eb 0e                	jmp    8010497c <kill+0x2c>
8010496e:	66 90                	xchg   %ax,%ax
80104970:	05 bc 00 00 00       	add    $0xbc,%eax
80104975:	3d 94 ab 11 80       	cmp    $0x8011ab94,%eax
8010497a:	73 34                	jae    801049b0 <kill+0x60>
        if (p->pid == pid) {
8010497c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010497f:	75 ef                	jne    80104970 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
80104981:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
80104985:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING)
8010498c:	75 07                	jne    80104995 <kill+0x45>
                p->state = RUNNABLE;
8010498e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
80104995:	83 ec 0c             	sub    $0xc,%esp
80104998:	68 60 7c 11 80       	push   $0x80117c60
8010499d:	e8 ae 05 00 00       	call   80104f50 <release>
            return 0;
801049a2:	83 c4 10             	add    $0x10,%esp
801049a5:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
801049a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049aa:	c9                   	leave  
801049ab:	c3                   	ret    
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
801049b0:	83 ec 0c             	sub    $0xc,%esp
801049b3:	68 60 7c 11 80       	push   $0x80117c60
801049b8:	e8 93 05 00 00       	call   80104f50 <release>
    return -1;
801049bd:	83 c4 10             	add    $0x10,%esp
801049c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049c8:	c9                   	leave  
801049c9:	c3                   	ret    
801049ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049d0 <procdump>:

// PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	57                   	push   %edi
801049d4:	56                   	push   %esi
801049d5:	53                   	push   %ebx
801049d6:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801049d9:	bb 94 7c 11 80       	mov    $0x80117c94,%ebx
void procdump(void) {
801049de:	83 ec 3c             	sub    $0x3c,%esp
801049e1:	eb 2d                	jmp    80104a10 <procdump+0x40>
801049e3:	90                   	nop
801049e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == SLEEPING) {
            getcallerpcs((uint *)p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf(" - queue %d\n", p->qno);
801049e8:	83 ec 08             	sub    $0x8,%esp
801049eb:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
801049f1:	68 a6 86 10 80       	push   $0x801086a6
801049f6:	e8 65 bc ff ff       	call   80100660 <cprintf>
801049fb:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801049fe:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80104a04:	81 fb 94 ab 11 80    	cmp    $0x8011ab94,%ebx
80104a0a:	0f 83 90 00 00 00    	jae    80104aa0 <procdump+0xd0>
        if (p->state == UNUSED)
80104a10:	8b 43 0c             	mov    0xc(%ebx),%eax
80104a13:	85 c0                	test   %eax,%eax
80104a15:	74 e7                	je     801049fe <procdump+0x2e>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a17:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
80104a1a:	ba 99 86 10 80       	mov    $0x80108699,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a1f:	77 11                	ja     80104a32 <procdump+0x62>
80104a21:	8b 14 85 fc 87 10 80 	mov    -0x7fef7804(,%eax,4),%edx
            state = "???";
80104a28:	b8 99 86 10 80       	mov    $0x80108699,%eax
80104a2d:	85 d2                	test   %edx,%edx
80104a2f:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
80104a32:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104a35:	50                   	push   %eax
80104a36:	52                   	push   %edx
80104a37:	ff 73 10             	pushl  0x10(%ebx)
80104a3a:	68 9d 86 10 80       	push   $0x8010869d
80104a3f:	e8 1c bc ff ff       	call   80100660 <cprintf>
        if (p->state == SLEEPING) {
80104a44:	83 c4 10             	add    $0x10,%esp
80104a47:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104a4b:	75 9b                	jne    801049e8 <procdump+0x18>
            getcallerpcs((uint *)p->context->ebp + 2, pc);
80104a4d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104a50:	83 ec 08             	sub    $0x8,%esp
80104a53:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104a56:	50                   	push   %eax
80104a57:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104a5a:	8b 40 0c             	mov    0xc(%eax),%eax
80104a5d:	83 c0 08             	add    $0x8,%eax
80104a60:	50                   	push   %eax
80104a61:	e8 0a 03 00 00       	call   80104d70 <getcallerpcs>
80104a66:	83 c4 10             	add    $0x10,%esp
80104a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104a70:	8b 17                	mov    (%edi),%edx
80104a72:	85 d2                	test   %edx,%edx
80104a74:	0f 84 6e ff ff ff    	je     801049e8 <procdump+0x18>
                cprintf(" %p", pc[i]);
80104a7a:	83 ec 08             	sub    $0x8,%esp
80104a7d:	83 c7 04             	add    $0x4,%edi
80104a80:	52                   	push   %edx
80104a81:	68 a1 80 10 80       	push   $0x801080a1
80104a86:	e8 d5 bb ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104a8b:	83 c4 10             	add    $0x10,%esp
80104a8e:	39 f7                	cmp    %esi,%edi
80104a90:	75 de                	jne    80104a70 <procdump+0xa0>
80104a92:	e9 51 ff ff ff       	jmp    801049e8 <procdump+0x18>
80104a97:	89 f6                	mov    %esi,%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104aa0:	31 f6                	xor    %esi,%esi
    }

    for (int i = 0; i < 5; i++) {
        cprintf("\nQ %d : %d", i, cnt[i]);
80104aa2:	83 ec 04             	sub    $0x4,%esp
80104aa5:	ff 34 b5 1c b6 10 80 	pushl  -0x7fef49e4(,%esi,4)
80104aac:	56                   	push   %esi
80104aad:	68 b3 86 10 80       	push   $0x801086b3
80104ab2:	e8 a9 bb ff ff       	call   80100660 <cprintf>
        if (i == 0) {
80104ab7:	83 c4 10             	add    $0x10,%esp
80104aba:	85 f6                	test   %esi,%esi
80104abc:	74 77                	je     80104b35 <procdump+0x165>
            for (int j = 0; j < cnt[i]; j++) {
                cprintf("\n %d", q0[j]->pid);
            }
        } else if (i == 1) {
80104abe:	83 fe 01             	cmp    $0x1,%esi
80104ac1:	0f 84 d6 00 00 00    	je     80104b9d <procdump+0x1cd>
            for (int j = 0; j < cnt[i]; j++) {
                cprintf("\n %d", q1[j]->pid);
            }
        } else if (i == 2) {
80104ac7:	83 fe 02             	cmp    $0x2,%esi
80104aca:	0f 84 07 01 00 00    	je     80104bd7 <procdump+0x207>
            for (int j = 0; j < cnt[i]; j++) {
                cprintf("\n %d", q2[j]->pid);
            }
        } else if (i == 3) {
80104ad0:	83 fe 03             	cmp    $0x3,%esi
80104ad3:	0f 84 8f 00 00 00    	je     80104b68 <procdump+0x198>
            for (int j = 0; j < cnt[i]; j++) {
                cprintf("\n %d", q3[j]->pid);
            }
        } else if (i == 4) {
            for (int j = 0; j < cnt[i]; j++) {
80104ad9:	8b 15 2c b6 10 80    	mov    0x8010b62c,%edx
80104adf:	31 db                	xor    %ebx,%ebx
80104ae1:	85 d2                	test   %edx,%edx
80104ae3:	7e 28                	jle    80104b0d <procdump+0x13d>
80104ae5:	8d 76 00             	lea    0x0(%esi),%esi
                cprintf("\n %d", q4[j]->pid);
80104ae8:	8b 04 9d a0 ab 11 80 	mov    -0x7fee5460(,%ebx,4),%eax
80104aef:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
80104af2:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q4[j]->pid);
80104af5:	ff 70 10             	pushl  0x10(%eax)
80104af8:	68 be 86 10 80       	push   $0x801086be
80104afd:	e8 5e bb ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
80104b02:	83 c4 10             	add    $0x10,%esp
80104b05:	39 1d 2c b6 10 80    	cmp    %ebx,0x8010b62c
80104b0b:	7f db                	jg     80104ae8 <procdump+0x118>
    for (int i = 0; i < 5; i++) {
80104b0d:	83 fe 04             	cmp    $0x4,%esi
80104b10:	74 0e                	je     80104b20 <procdump+0x150>
80104b12:	83 c6 01             	add    $0x1,%esi
80104b15:	eb 8b                	jmp    80104aa2 <procdump+0xd2>
80104b17:	89 f6                	mov    %esi,%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            }
        }
    }
    cprintf("\n");
80104b20:	83 ec 0c             	sub    $0xc,%esp
80104b23:	68 23 8b 10 80       	push   $0x80108b23
80104b28:	e8 33 bb ff ff       	call   80100660 <cprintf>
}
80104b2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b30:	5b                   	pop    %ebx
80104b31:	5e                   	pop    %esi
80104b32:	5f                   	pop    %edi
80104b33:	5d                   	pop    %ebp
80104b34:	c3                   	ret    
            for (int j = 0; j < cnt[i]; j++) {
80104b35:	8b 3d 1c b6 10 80    	mov    0x8010b61c,%edi
80104b3b:	85 ff                	test   %edi,%edi
80104b3d:	7e d3                	jle    80104b12 <procdump+0x142>
80104b3f:	31 db                	xor    %ebx,%ebx
                cprintf("\n %d", q0[j]->pid);
80104b41:	8b 04 9d c0 6c 11 80 	mov    -0x7fee9340(,%ebx,4),%eax
80104b48:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
80104b4b:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q0[j]->pid);
80104b4e:	ff 70 10             	pushl  0x10(%eax)
80104b51:	68 be 86 10 80       	push   $0x801086be
80104b56:	e8 05 bb ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
80104b5b:	83 c4 10             	add    $0x10,%esp
80104b5e:	39 1d 1c b6 10 80    	cmp    %ebx,0x8010b61c
80104b64:	7f db                	jg     80104b41 <procdump+0x171>
80104b66:	eb aa                	jmp    80104b12 <procdump+0x142>
            for (int j = 0; j < cnt[i]; j++) {
80104b68:	a1 28 b6 10 80       	mov    0x8010b628,%eax
80104b6d:	85 c0                	test   %eax,%eax
80104b6f:	7e a1                	jle    80104b12 <procdump+0x142>
80104b71:	31 db                	xor    %ebx,%ebx
                cprintf("\n %d", q3[j]->pid);
80104b73:	8b 04 9d 80 4d 11 80 	mov    -0x7feeb280(,%ebx,4),%eax
80104b7a:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
80104b7d:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q3[j]->pid);
80104b80:	ff 70 10             	pushl  0x10(%eax)
80104b83:	68 be 86 10 80       	push   $0x801086be
80104b88:	e8 d3 ba ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
80104b8d:	83 c4 10             	add    $0x10,%esp
80104b90:	39 1d 28 b6 10 80    	cmp    %ebx,0x8010b628
80104b96:	7f db                	jg     80104b73 <procdump+0x1a3>
80104b98:	e9 75 ff ff ff       	jmp    80104b12 <procdump+0x142>
            for (int j = 0; j < cnt[i]; j++) {
80104b9d:	8b 1d 20 b6 10 80    	mov    0x8010b620,%ebx
80104ba3:	85 db                	test   %ebx,%ebx
80104ba5:	0f 8e 67 ff ff ff    	jle    80104b12 <procdump+0x142>
80104bab:	31 db                	xor    %ebx,%ebx
                cprintf("\n %d", q1[j]->pid);
80104bad:	8b 04 9d 20 5d 11 80 	mov    -0x7feea2e0(,%ebx,4),%eax
80104bb4:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
80104bb7:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q1[j]->pid);
80104bba:	ff 70 10             	pushl  0x10(%eax)
80104bbd:	68 be 86 10 80       	push   $0x801086be
80104bc2:	e8 99 ba ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
80104bc7:	83 c4 10             	add    $0x10,%esp
80104bca:	39 1d 20 b6 10 80    	cmp    %ebx,0x8010b620
80104bd0:	7f db                	jg     80104bad <procdump+0x1dd>
80104bd2:	e9 3b ff ff ff       	jmp    80104b12 <procdump+0x142>
            for (int j = 0; j < cnt[i]; j++) {
80104bd7:	8b 0d 24 b6 10 80    	mov    0x8010b624,%ecx
80104bdd:	85 c9                	test   %ecx,%ecx
80104bdf:	0f 8e 2d ff ff ff    	jle    80104b12 <procdump+0x142>
80104be5:	31 db                	xor    %ebx,%ebx
                cprintf("\n %d", q2[j]->pid);
80104be7:	8b 04 9d c0 3d 11 80 	mov    -0x7feec240(,%ebx,4),%eax
80104bee:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
80104bf1:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q2[j]->pid);
80104bf4:	ff 70 10             	pushl  0x10(%eax)
80104bf7:	68 be 86 10 80       	push   $0x801086be
80104bfc:	e8 5f ba ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
80104c01:	83 c4 10             	add    $0x10,%esp
80104c04:	39 1d 24 b6 10 80    	cmp    %ebx,0x8010b624
80104c0a:	7f db                	jg     80104be7 <procdump+0x217>
80104c0c:	e9 01 ff ff ff       	jmp    80104b12 <procdump+0x142>
80104c11:	66 90                	xchg   %ax,%ax
80104c13:	66 90                	xchg   %ax,%ax
80104c15:	66 90                	xchg   %ax,%ax
80104c17:	66 90                	xchg   %ax,%ax
80104c19:	66 90                	xchg   %ax,%ax
80104c1b:	66 90                	xchg   %ax,%ax
80104c1d:	66 90                	xchg   %ax,%ax
80104c1f:	90                   	nop

80104c20 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	53                   	push   %ebx
80104c24:	83 ec 0c             	sub    $0xc,%esp
80104c27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104c2a:	68 14 88 10 80       	push   $0x80108814
80104c2f:	8d 43 04             	lea    0x4(%ebx),%eax
80104c32:	50                   	push   %eax
80104c33:	e8 18 01 00 00       	call   80104d50 <initlock>
  lk->name = name;
80104c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104c3b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104c41:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104c44:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104c4b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104c4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c51:	c9                   	leave  
80104c52:	c3                   	ret    
80104c53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	56                   	push   %esi
80104c64:	53                   	push   %ebx
80104c65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c68:	83 ec 0c             	sub    $0xc,%esp
80104c6b:	8d 73 04             	lea    0x4(%ebx),%esi
80104c6e:	56                   	push   %esi
80104c6f:	e8 1c 02 00 00       	call   80104e90 <acquire>
  while (lk->locked) {
80104c74:	8b 13                	mov    (%ebx),%edx
80104c76:	83 c4 10             	add    $0x10,%esp
80104c79:	85 d2                	test   %edx,%edx
80104c7b:	74 16                	je     80104c93 <acquiresleep+0x33>
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104c80:	83 ec 08             	sub    $0x8,%esp
80104c83:	56                   	push   %esi
80104c84:	53                   	push   %ebx
80104c85:	e8 86 f9 ff ff       	call   80104610 <sleep>
  while (lk->locked) {
80104c8a:	8b 03                	mov    (%ebx),%eax
80104c8c:	83 c4 10             	add    $0x10,%esp
80104c8f:	85 c0                	test   %eax,%eax
80104c91:	75 ed                	jne    80104c80 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104c93:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104c99:	e8 02 ec ff ff       	call   801038a0 <myproc>
80104c9e:	8b 40 10             	mov    0x10(%eax),%eax
80104ca1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104ca4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104ca7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104caa:	5b                   	pop    %ebx
80104cab:	5e                   	pop    %esi
80104cac:	5d                   	pop    %ebp
  release(&lk->lk);
80104cad:	e9 9e 02 00 00       	jmp    80104f50 <release>
80104cb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	53                   	push   %ebx
80104cc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104cc8:	83 ec 0c             	sub    $0xc,%esp
80104ccb:	8d 73 04             	lea    0x4(%ebx),%esi
80104cce:	56                   	push   %esi
80104ccf:	e8 bc 01 00 00       	call   80104e90 <acquire>
  lk->locked = 0;
80104cd4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104cda:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104ce1:	89 1c 24             	mov    %ebx,(%esp)
80104ce4:	e8 07 fc ff ff       	call   801048f0 <wakeup>
  release(&lk->lk);
80104ce9:	89 75 08             	mov    %esi,0x8(%ebp)
80104cec:	83 c4 10             	add    $0x10,%esp
}
80104cef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cf2:	5b                   	pop    %ebx
80104cf3:	5e                   	pop    %esi
80104cf4:	5d                   	pop    %ebp
  release(&lk->lk);
80104cf5:	e9 56 02 00 00       	jmp    80104f50 <release>
80104cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d00 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	56                   	push   %esi
80104d05:	53                   	push   %ebx
80104d06:	31 ff                	xor    %edi,%edi
80104d08:	83 ec 18             	sub    $0x18,%esp
80104d0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104d0e:	8d 73 04             	lea    0x4(%ebx),%esi
80104d11:	56                   	push   %esi
80104d12:	e8 79 01 00 00       	call   80104e90 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104d17:	8b 03                	mov    (%ebx),%eax
80104d19:	83 c4 10             	add    $0x10,%esp
80104d1c:	85 c0                	test   %eax,%eax
80104d1e:	74 13                	je     80104d33 <holdingsleep+0x33>
80104d20:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104d23:	e8 78 eb ff ff       	call   801038a0 <myproc>
80104d28:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d2b:	0f 94 c0             	sete   %al
80104d2e:	0f b6 c0             	movzbl %al,%eax
80104d31:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104d33:	83 ec 0c             	sub    $0xc,%esp
80104d36:	56                   	push   %esi
80104d37:	e8 14 02 00 00       	call   80104f50 <release>
  return r;
}
80104d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d3f:	89 f8                	mov    %edi,%eax
80104d41:	5b                   	pop    %ebx
80104d42:	5e                   	pop    %esi
80104d43:	5f                   	pop    %edi
80104d44:	5d                   	pop    %ebp
80104d45:	c3                   	ret    
80104d46:	66 90                	xchg   %ax,%ax
80104d48:	66 90                	xchg   %ax,%ax
80104d4a:	66 90                	xchg   %ax,%ax
80104d4c:	66 90                	xchg   %ax,%ax
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104d59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104d5f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104d62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d69:	5d                   	pop    %ebp
80104d6a:	c3                   	ret    
80104d6b:	90                   	nop
80104d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d70 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d70:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d71:	31 d2                	xor    %edx,%edx
{
80104d73:	89 e5                	mov    %esp,%ebp
80104d75:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104d76:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104d7c:	83 e8 08             	sub    $0x8,%eax
80104d7f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d80:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104d86:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104d8c:	77 1a                	ja     80104da8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d8e:	8b 58 04             	mov    0x4(%eax),%ebx
80104d91:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104d94:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104d97:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d99:	83 fa 0a             	cmp    $0xa,%edx
80104d9c:	75 e2                	jne    80104d80 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d9e:	5b                   	pop    %ebx
80104d9f:	5d                   	pop    %ebp
80104da0:	c3                   	ret    
80104da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104da8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104dab:	83 c1 28             	add    $0x28,%ecx
80104dae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104db0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104db6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104db9:	39 c1                	cmp    %eax,%ecx
80104dbb:	75 f3                	jne    80104db0 <getcallerpcs+0x40>
}
80104dbd:	5b                   	pop    %ebx
80104dbe:	5d                   	pop    %ebp
80104dbf:	c3                   	ret    

80104dc0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	53                   	push   %ebx
80104dc4:	83 ec 04             	sub    $0x4,%esp
80104dc7:	9c                   	pushf  
80104dc8:	5b                   	pop    %ebx
  asm volatile("cli");
80104dc9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104dca:	e8 31 ea ff ff       	call   80103800 <mycpu>
80104dcf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104dd5:	85 c0                	test   %eax,%eax
80104dd7:	75 11                	jne    80104dea <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104dd9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104ddf:	e8 1c ea ff ff       	call   80103800 <mycpu>
80104de4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104dea:	e8 11 ea ff ff       	call   80103800 <mycpu>
80104def:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104df6:	83 c4 04             	add    $0x4,%esp
80104df9:	5b                   	pop    %ebx
80104dfa:	5d                   	pop    %ebp
80104dfb:	c3                   	ret    
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e00 <popcli>:

void
popcli(void)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e06:	9c                   	pushf  
80104e07:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104e08:	f6 c4 02             	test   $0x2,%ah
80104e0b:	75 35                	jne    80104e42 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104e0d:	e8 ee e9 ff ff       	call   80103800 <mycpu>
80104e12:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104e19:	78 34                	js     80104e4f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e1b:	e8 e0 e9 ff ff       	call   80103800 <mycpu>
80104e20:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104e26:	85 d2                	test   %edx,%edx
80104e28:	74 06                	je     80104e30 <popcli+0x30>
    sti();
}
80104e2a:	c9                   	leave  
80104e2b:	c3                   	ret    
80104e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e30:	e8 cb e9 ff ff       	call   80103800 <mycpu>
80104e35:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104e3b:	85 c0                	test   %eax,%eax
80104e3d:	74 eb                	je     80104e2a <popcli+0x2a>
  asm volatile("sti");
80104e3f:	fb                   	sti    
}
80104e40:	c9                   	leave  
80104e41:	c3                   	ret    
    panic("popcli - interruptible");
80104e42:	83 ec 0c             	sub    $0xc,%esp
80104e45:	68 1f 88 10 80       	push   $0x8010881f
80104e4a:	e8 41 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104e4f:	83 ec 0c             	sub    $0xc,%esp
80104e52:	68 36 88 10 80       	push   $0x80108836
80104e57:	e8 34 b5 ff ff       	call   80100390 <panic>
80104e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e60 <holding>:
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
80104e65:	8b 75 08             	mov    0x8(%ebp),%esi
80104e68:	31 db                	xor    %ebx,%ebx
  pushcli();
80104e6a:	e8 51 ff ff ff       	call   80104dc0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e6f:	8b 06                	mov    (%esi),%eax
80104e71:	85 c0                	test   %eax,%eax
80104e73:	74 10                	je     80104e85 <holding+0x25>
80104e75:	8b 5e 08             	mov    0x8(%esi),%ebx
80104e78:	e8 83 e9 ff ff       	call   80103800 <mycpu>
80104e7d:	39 c3                	cmp    %eax,%ebx
80104e7f:	0f 94 c3             	sete   %bl
80104e82:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104e85:	e8 76 ff ff ff       	call   80104e00 <popcli>
}
80104e8a:	89 d8                	mov    %ebx,%eax
80104e8c:	5b                   	pop    %ebx
80104e8d:	5e                   	pop    %esi
80104e8e:	5d                   	pop    %ebp
80104e8f:	c3                   	ret    

80104e90 <acquire>:
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104e95:	e8 26 ff ff ff       	call   80104dc0 <pushcli>
  if(holding(lk))
80104e9a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e9d:	83 ec 0c             	sub    $0xc,%esp
80104ea0:	53                   	push   %ebx
80104ea1:	e8 ba ff ff ff       	call   80104e60 <holding>
80104ea6:	83 c4 10             	add    $0x10,%esp
80104ea9:	85 c0                	test   %eax,%eax
80104eab:	0f 85 83 00 00 00    	jne    80104f34 <acquire+0xa4>
80104eb1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104eb3:	ba 01 00 00 00       	mov    $0x1,%edx
80104eb8:	eb 09                	jmp    80104ec3 <acquire+0x33>
80104eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ec0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ec3:	89 d0                	mov    %edx,%eax
80104ec5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104ec8:	85 c0                	test   %eax,%eax
80104eca:	75 f4                	jne    80104ec0 <acquire+0x30>
  __sync_synchronize();
80104ecc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ed1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ed4:	e8 27 e9 ff ff       	call   80103800 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104ed9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104edc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104edf:	89 e8                	mov    %ebp,%eax
80104ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ee8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104eee:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104ef4:	77 1a                	ja     80104f10 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104ef6:	8b 48 04             	mov    0x4(%eax),%ecx
80104ef9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104efc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104eff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104f01:	83 fe 0a             	cmp    $0xa,%esi
80104f04:	75 e2                	jne    80104ee8 <acquire+0x58>
}
80104f06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f09:	5b                   	pop    %ebx
80104f0a:	5e                   	pop    %esi
80104f0b:	5d                   	pop    %ebp
80104f0c:	c3                   	ret    
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
80104f10:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104f13:	83 c2 28             	add    $0x28,%edx
80104f16:	8d 76 00             	lea    0x0(%esi),%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104f20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104f26:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104f29:	39 d0                	cmp    %edx,%eax
80104f2b:	75 f3                	jne    80104f20 <acquire+0x90>
}
80104f2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f30:	5b                   	pop    %ebx
80104f31:	5e                   	pop    %esi
80104f32:	5d                   	pop    %ebp
80104f33:	c3                   	ret    
    panic("acquire");
80104f34:	83 ec 0c             	sub    $0xc,%esp
80104f37:	68 3d 88 10 80       	push   $0x8010883d
80104f3c:	e8 4f b4 ff ff       	call   80100390 <panic>
80104f41:	eb 0d                	jmp    80104f50 <release>
80104f43:	90                   	nop
80104f44:	90                   	nop
80104f45:	90                   	nop
80104f46:	90                   	nop
80104f47:	90                   	nop
80104f48:	90                   	nop
80104f49:	90                   	nop
80104f4a:	90                   	nop
80104f4b:	90                   	nop
80104f4c:	90                   	nop
80104f4d:	90                   	nop
80104f4e:	90                   	nop
80104f4f:	90                   	nop

80104f50 <release>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	53                   	push   %ebx
80104f54:	83 ec 10             	sub    $0x10,%esp
80104f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104f5a:	53                   	push   %ebx
80104f5b:	e8 00 ff ff ff       	call   80104e60 <holding>
80104f60:	83 c4 10             	add    $0x10,%esp
80104f63:	85 c0                	test   %eax,%eax
80104f65:	74 22                	je     80104f89 <release+0x39>
  lk->pcs[0] = 0;
80104f67:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104f6e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104f75:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104f7a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f83:	c9                   	leave  
  popcli();
80104f84:	e9 77 fe ff ff       	jmp    80104e00 <popcli>
    panic("release");
80104f89:	83 ec 0c             	sub    $0xc,%esp
80104f8c:	68 45 88 10 80       	push   $0x80108845
80104f91:	e8 fa b3 ff ff       	call   80100390 <panic>
80104f96:	66 90                	xchg   %ax,%ax
80104f98:	66 90                	xchg   %ax,%ax
80104f9a:	66 90                	xchg   %ax,%ax
80104f9c:	66 90                	xchg   %ax,%ax
80104f9e:	66 90                	xchg   %ax,%ax

80104fa0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	57                   	push   %edi
80104fa4:	53                   	push   %ebx
80104fa5:	8b 55 08             	mov    0x8(%ebp),%edx
80104fa8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104fab:	f6 c2 03             	test   $0x3,%dl
80104fae:	75 05                	jne    80104fb5 <memset+0x15>
80104fb0:	f6 c1 03             	test   $0x3,%cl
80104fb3:	74 13                	je     80104fc8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104fb5:	89 d7                	mov    %edx,%edi
80104fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fba:	fc                   	cld    
80104fbb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104fbd:	5b                   	pop    %ebx
80104fbe:	89 d0                	mov    %edx,%eax
80104fc0:	5f                   	pop    %edi
80104fc1:	5d                   	pop    %ebp
80104fc2:	c3                   	ret    
80104fc3:	90                   	nop
80104fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104fc8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104fcc:	c1 e9 02             	shr    $0x2,%ecx
80104fcf:	89 f8                	mov    %edi,%eax
80104fd1:	89 fb                	mov    %edi,%ebx
80104fd3:	c1 e0 18             	shl    $0x18,%eax
80104fd6:	c1 e3 10             	shl    $0x10,%ebx
80104fd9:	09 d8                	or     %ebx,%eax
80104fdb:	09 f8                	or     %edi,%eax
80104fdd:	c1 e7 08             	shl    $0x8,%edi
80104fe0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104fe2:	89 d7                	mov    %edx,%edi
80104fe4:	fc                   	cld    
80104fe5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104fe7:	5b                   	pop    %ebx
80104fe8:	89 d0                	mov    %edx,%eax
80104fea:	5f                   	pop    %edi
80104feb:	5d                   	pop    %ebp
80104fec:	c3                   	ret    
80104fed:	8d 76 00             	lea    0x0(%esi),%esi

80104ff0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	57                   	push   %edi
80104ff4:	56                   	push   %esi
80104ff5:	53                   	push   %ebx
80104ff6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80104ffc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104fff:	85 db                	test   %ebx,%ebx
80105001:	74 29                	je     8010502c <memcmp+0x3c>
    if(*s1 != *s2)
80105003:	0f b6 16             	movzbl (%esi),%edx
80105006:	0f b6 0f             	movzbl (%edi),%ecx
80105009:	38 d1                	cmp    %dl,%cl
8010500b:	75 2b                	jne    80105038 <memcmp+0x48>
8010500d:	b8 01 00 00 00       	mov    $0x1,%eax
80105012:	eb 14                	jmp    80105028 <memcmp+0x38>
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105018:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010501c:	83 c0 01             	add    $0x1,%eax
8010501f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105024:	38 ca                	cmp    %cl,%dl
80105026:	75 10                	jne    80105038 <memcmp+0x48>
  while(n-- > 0){
80105028:	39 d8                	cmp    %ebx,%eax
8010502a:	75 ec                	jne    80105018 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010502c:	5b                   	pop    %ebx
  return 0;
8010502d:	31 c0                	xor    %eax,%eax
}
8010502f:	5e                   	pop    %esi
80105030:	5f                   	pop    %edi
80105031:	5d                   	pop    %ebp
80105032:	c3                   	ret    
80105033:	90                   	nop
80105034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105038:	0f b6 c2             	movzbl %dl,%eax
}
8010503b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010503c:	29 c8                	sub    %ecx,%eax
}
8010503e:	5e                   	pop    %esi
8010503f:	5f                   	pop    %edi
80105040:	5d                   	pop    %ebp
80105041:	c3                   	ret    
80105042:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	56                   	push   %esi
80105054:	53                   	push   %ebx
80105055:	8b 45 08             	mov    0x8(%ebp),%eax
80105058:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010505b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010505e:	39 c3                	cmp    %eax,%ebx
80105060:	73 26                	jae    80105088 <memmove+0x38>
80105062:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105065:	39 c8                	cmp    %ecx,%eax
80105067:	73 1f                	jae    80105088 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105069:	85 f6                	test   %esi,%esi
8010506b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010506e:	74 0f                	je     8010507f <memmove+0x2f>
      *--d = *--s;
80105070:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105074:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105077:	83 ea 01             	sub    $0x1,%edx
8010507a:	83 fa ff             	cmp    $0xffffffff,%edx
8010507d:	75 f1                	jne    80105070 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010507f:	5b                   	pop    %ebx
80105080:	5e                   	pop    %esi
80105081:	5d                   	pop    %ebp
80105082:	c3                   	ret    
80105083:	90                   	nop
80105084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105088:	31 d2                	xor    %edx,%edx
8010508a:	85 f6                	test   %esi,%esi
8010508c:	74 f1                	je     8010507f <memmove+0x2f>
8010508e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105090:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105094:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105097:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010509a:	39 d6                	cmp    %edx,%esi
8010509c:	75 f2                	jne    80105090 <memmove+0x40>
}
8010509e:	5b                   	pop    %ebx
8010509f:	5e                   	pop    %esi
801050a0:	5d                   	pop    %ebp
801050a1:	c3                   	ret    
801050a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801050b3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801050b4:	eb 9a                	jmp    80105050 <memmove>
801050b6:	8d 76 00             	lea    0x0(%esi),%esi
801050b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050c0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	57                   	push   %edi
801050c4:	56                   	push   %esi
801050c5:	8b 7d 10             	mov    0x10(%ebp),%edi
801050c8:	53                   	push   %ebx
801050c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801050cf:	85 ff                	test   %edi,%edi
801050d1:	74 2f                	je     80105102 <strncmp+0x42>
801050d3:	0f b6 01             	movzbl (%ecx),%eax
801050d6:	0f b6 1e             	movzbl (%esi),%ebx
801050d9:	84 c0                	test   %al,%al
801050db:	74 37                	je     80105114 <strncmp+0x54>
801050dd:	38 c3                	cmp    %al,%bl
801050df:	75 33                	jne    80105114 <strncmp+0x54>
801050e1:	01 f7                	add    %esi,%edi
801050e3:	eb 13                	jmp    801050f8 <strncmp+0x38>
801050e5:	8d 76 00             	lea    0x0(%esi),%esi
801050e8:	0f b6 01             	movzbl (%ecx),%eax
801050eb:	84 c0                	test   %al,%al
801050ed:	74 21                	je     80105110 <strncmp+0x50>
801050ef:	0f b6 1a             	movzbl (%edx),%ebx
801050f2:	89 d6                	mov    %edx,%esi
801050f4:	38 d8                	cmp    %bl,%al
801050f6:	75 1c                	jne    80105114 <strncmp+0x54>
    n--, p++, q++;
801050f8:	8d 56 01             	lea    0x1(%esi),%edx
801050fb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801050fe:	39 fa                	cmp    %edi,%edx
80105100:	75 e6                	jne    801050e8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105102:	5b                   	pop    %ebx
    return 0;
80105103:	31 c0                	xor    %eax,%eax
}
80105105:	5e                   	pop    %esi
80105106:	5f                   	pop    %edi
80105107:	5d                   	pop    %ebp
80105108:	c3                   	ret    
80105109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105110:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105114:	29 d8                	sub    %ebx,%eax
}
80105116:	5b                   	pop    %ebx
80105117:	5e                   	pop    %esi
80105118:	5f                   	pop    %edi
80105119:	5d                   	pop    %ebp
8010511a:	c3                   	ret    
8010511b:	90                   	nop
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105120 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	8b 45 08             	mov    0x8(%ebp),%eax
80105128:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010512b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010512e:	89 c2                	mov    %eax,%edx
80105130:	eb 19                	jmp    8010514b <strncpy+0x2b>
80105132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105138:	83 c3 01             	add    $0x1,%ebx
8010513b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010513f:	83 c2 01             	add    $0x1,%edx
80105142:	84 c9                	test   %cl,%cl
80105144:	88 4a ff             	mov    %cl,-0x1(%edx)
80105147:	74 09                	je     80105152 <strncpy+0x32>
80105149:	89 f1                	mov    %esi,%ecx
8010514b:	85 c9                	test   %ecx,%ecx
8010514d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105150:	7f e6                	jg     80105138 <strncpy+0x18>
    ;
  while(n-- > 0)
80105152:	31 c9                	xor    %ecx,%ecx
80105154:	85 f6                	test   %esi,%esi
80105156:	7e 17                	jle    8010516f <strncpy+0x4f>
80105158:	90                   	nop
80105159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105160:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105164:	89 f3                	mov    %esi,%ebx
80105166:	83 c1 01             	add    $0x1,%ecx
80105169:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010516b:	85 db                	test   %ebx,%ebx
8010516d:	7f f1                	jg     80105160 <strncpy+0x40>
  return os;
}
8010516f:	5b                   	pop    %ebx
80105170:	5e                   	pop    %esi
80105171:	5d                   	pop    %ebp
80105172:	c3                   	ret    
80105173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	56                   	push   %esi
80105184:	53                   	push   %ebx
80105185:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105188:	8b 45 08             	mov    0x8(%ebp),%eax
8010518b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010518e:	85 c9                	test   %ecx,%ecx
80105190:	7e 26                	jle    801051b8 <safestrcpy+0x38>
80105192:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105196:	89 c1                	mov    %eax,%ecx
80105198:	eb 17                	jmp    801051b1 <safestrcpy+0x31>
8010519a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801051a0:	83 c2 01             	add    $0x1,%edx
801051a3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801051a7:	83 c1 01             	add    $0x1,%ecx
801051aa:	84 db                	test   %bl,%bl
801051ac:	88 59 ff             	mov    %bl,-0x1(%ecx)
801051af:	74 04                	je     801051b5 <safestrcpy+0x35>
801051b1:	39 f2                	cmp    %esi,%edx
801051b3:	75 eb                	jne    801051a0 <safestrcpy+0x20>
    ;
  *s = 0;
801051b5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801051b8:	5b                   	pop    %ebx
801051b9:	5e                   	pop    %esi
801051ba:	5d                   	pop    %ebp
801051bb:	c3                   	ret    
801051bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051c0 <strlen>:

int
strlen(const char *s)
{
801051c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801051c1:	31 c0                	xor    %eax,%eax
{
801051c3:	89 e5                	mov    %esp,%ebp
801051c5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801051c8:	80 3a 00             	cmpb   $0x0,(%edx)
801051cb:	74 0c                	je     801051d9 <strlen+0x19>
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
801051d0:	83 c0 01             	add    $0x1,%eax
801051d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801051d7:	75 f7                	jne    801051d0 <strlen+0x10>
    ;
  return n;
}
801051d9:	5d                   	pop    %ebp
801051da:	c3                   	ret    

801051db <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801051db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801051df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801051e3:	55                   	push   %ebp
  pushl %ebx
801051e4:	53                   	push   %ebx
  pushl %esi
801051e5:	56                   	push   %esi
  pushl %edi
801051e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801051e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801051e9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801051eb:	5f                   	pop    %edi
  popl %esi
801051ec:	5e                   	pop    %esi
  popl %ebx
801051ed:	5b                   	pop    %ebx
  popl %ebp
801051ee:	5d                   	pop    %ebp
  ret
801051ef:	c3                   	ret    

801051f0 <fetchint>:
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip) {
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	53                   	push   %ebx
801051f4:	83 ec 04             	sub    $0x4,%esp
801051f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *curproc = myproc();
801051fa:	e8 a1 e6 ff ff       	call   801038a0 <myproc>

    if (addr >= curproc->sz || addr + 4 > curproc->sz)
801051ff:	8b 00                	mov    (%eax),%eax
80105201:	39 d8                	cmp    %ebx,%eax
80105203:	76 1b                	jbe    80105220 <fetchint+0x30>
80105205:	8d 53 04             	lea    0x4(%ebx),%edx
80105208:	39 d0                	cmp    %edx,%eax
8010520a:	72 14                	jb     80105220 <fetchint+0x30>
        return -1;
    *ip = *(int *)(addr);
8010520c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010520f:	8b 13                	mov    (%ebx),%edx
80105211:	89 10                	mov    %edx,(%eax)
    return 0;
80105213:	31 c0                	xor    %eax,%eax
}
80105215:	83 c4 04             	add    $0x4,%esp
80105218:	5b                   	pop    %ebx
80105219:	5d                   	pop    %ebp
8010521a:	c3                   	ret    
8010521b:	90                   	nop
8010521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105225:	eb ee                	jmp    80105215 <fetchint+0x25>
80105227:	89 f6                	mov    %esi,%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105230 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp) {
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	53                   	push   %ebx
80105234:	83 ec 04             	sub    $0x4,%esp
80105237:	8b 5d 08             	mov    0x8(%ebp),%ebx
    char *s, *ep;
    struct proc *curproc = myproc();
8010523a:	e8 61 e6 ff ff       	call   801038a0 <myproc>

    if (addr >= curproc->sz)
8010523f:	39 18                	cmp    %ebx,(%eax)
80105241:	76 29                	jbe    8010526c <fetchstr+0x3c>
        return -1;
    *pp = (char *)addr;
80105243:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105246:	89 da                	mov    %ebx,%edx
80105248:	89 19                	mov    %ebx,(%ecx)
    ep = (char *)curproc->sz;
8010524a:	8b 00                	mov    (%eax),%eax
    for (s = *pp; s < ep; s++) {
8010524c:	39 c3                	cmp    %eax,%ebx
8010524e:	73 1c                	jae    8010526c <fetchstr+0x3c>
        if (*s == 0)
80105250:	80 3b 00             	cmpb   $0x0,(%ebx)
80105253:	75 10                	jne    80105265 <fetchstr+0x35>
80105255:	eb 39                	jmp    80105290 <fetchstr+0x60>
80105257:	89 f6                	mov    %esi,%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105260:	80 3a 00             	cmpb   $0x0,(%edx)
80105263:	74 1b                	je     80105280 <fetchstr+0x50>
    for (s = *pp; s < ep; s++) {
80105265:	83 c2 01             	add    $0x1,%edx
80105268:	39 d0                	cmp    %edx,%eax
8010526a:	77 f4                	ja     80105260 <fetchstr+0x30>
        return -1;
8010526c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return s - *pp;
    }
    return -1;
}
80105271:	83 c4 04             	add    $0x4,%esp
80105274:	5b                   	pop    %ebx
80105275:	5d                   	pop    %ebp
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105280:	83 c4 04             	add    $0x4,%esp
80105283:	89 d0                	mov    %edx,%eax
80105285:	29 d8                	sub    %ebx,%eax
80105287:	5b                   	pop    %ebx
80105288:	5d                   	pop    %ebp
80105289:	c3                   	ret    
8010528a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (*s == 0)
80105290:	31 c0                	xor    %eax,%eax
            return s - *pp;
80105292:	eb dd                	jmp    80105271 <fetchstr+0x41>
80105294:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010529a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801052a0 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip) {
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	56                   	push   %esi
801052a4:	53                   	push   %ebx
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
801052a5:	e8 f6 e5 ff ff       	call   801038a0 <myproc>
801052aa:	8b 40 18             	mov    0x18(%eax),%eax
801052ad:	8b 55 08             	mov    0x8(%ebp),%edx
801052b0:	8b 40 44             	mov    0x44(%eax),%eax
801052b3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    struct proc *curproc = myproc();
801052b6:	e8 e5 e5 ff ff       	call   801038a0 <myproc>
    if (addr >= curproc->sz || addr + 4 > curproc->sz)
801052bb:	8b 00                	mov    (%eax),%eax
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
801052bd:	8d 73 04             	lea    0x4(%ebx),%esi
    if (addr >= curproc->sz || addr + 4 > curproc->sz)
801052c0:	39 c6                	cmp    %eax,%esi
801052c2:	73 1c                	jae    801052e0 <argint+0x40>
801052c4:	8d 53 08             	lea    0x8(%ebx),%edx
801052c7:	39 d0                	cmp    %edx,%eax
801052c9:	72 15                	jb     801052e0 <argint+0x40>
    *ip = *(int *)(addr);
801052cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801052ce:	8b 53 04             	mov    0x4(%ebx),%edx
801052d1:	89 10                	mov    %edx,(%eax)
    return 0;
801052d3:	31 c0                	xor    %eax,%eax
}
801052d5:	5b                   	pop    %ebx
801052d6:	5e                   	pop    %esi
801052d7:	5d                   	pop    %ebp
801052d8:	c3                   	ret    
801052d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801052e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
801052e5:	eb ee                	jmp    801052d5 <argint+0x35>
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052f0 <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size) {
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	56                   	push   %esi
801052f4:	53                   	push   %ebx
801052f5:	83 ec 10             	sub    $0x10,%esp
801052f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
    int i;
    struct proc *curproc = myproc();
801052fb:	e8 a0 e5 ff ff       	call   801038a0 <myproc>
80105300:	89 c6                	mov    %eax,%esi

    if (argint(n, &i) < 0)
80105302:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105305:	83 ec 08             	sub    $0x8,%esp
80105308:	50                   	push   %eax
80105309:	ff 75 08             	pushl  0x8(%ebp)
8010530c:	e8 8f ff ff ff       	call   801052a0 <argint>
        return -1;
    if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz)
80105311:	83 c4 10             	add    $0x10,%esp
80105314:	85 c0                	test   %eax,%eax
80105316:	78 28                	js     80105340 <argptr+0x50>
80105318:	85 db                	test   %ebx,%ebx
8010531a:	78 24                	js     80105340 <argptr+0x50>
8010531c:	8b 16                	mov    (%esi),%edx
8010531e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105321:	39 c2                	cmp    %eax,%edx
80105323:	76 1b                	jbe    80105340 <argptr+0x50>
80105325:	01 c3                	add    %eax,%ebx
80105327:	39 da                	cmp    %ebx,%edx
80105329:	72 15                	jb     80105340 <argptr+0x50>
        return -1;
    *pp = (char *)i;
8010532b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010532e:	89 02                	mov    %eax,(%edx)
    return 0;
80105330:	31 c0                	xor    %eax,%eax
}
80105332:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105335:	5b                   	pop    %ebx
80105336:	5e                   	pop    %esi
80105337:	5d                   	pop    %ebp
80105338:	c3                   	ret    
80105339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105345:	eb eb                	jmp    80105332 <argptr+0x42>
80105347:	89 f6                	mov    %esi,%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105350 <argstr>:

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp) {
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	83 ec 20             	sub    $0x20,%esp
    int addr;
    if (argint(n, &addr) < 0)
80105356:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105359:	50                   	push   %eax
8010535a:	ff 75 08             	pushl  0x8(%ebp)
8010535d:	e8 3e ff ff ff       	call   801052a0 <argint>
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	85 c0                	test   %eax,%eax
80105367:	78 17                	js     80105380 <argstr+0x30>
        return -1;
    return fetchstr(addr, pp);
80105369:	83 ec 08             	sub    $0x8,%esp
8010536c:	ff 75 0c             	pushl  0xc(%ebp)
8010536f:	ff 75 f4             	pushl  -0xc(%ebp)
80105372:	e8 b9 fe ff ff       	call   80105230 <fetchstr>
80105377:	83 c4 10             	add    $0x10,%esp
}
8010537a:	c9                   	leave  
8010537b:	c3                   	ret    
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105385:	c9                   	leave  
80105386:	c3                   	ret    
80105387:	89 f6                	mov    %esi,%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105390 <syscall>:
    [SYS_waitx] sys_waitx,
    [SYS_set_priority] sys_set_priority,
    [SYS_getpinfo] sys_getpinfo,
};

void syscall(void) {
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	53                   	push   %ebx
80105394:	83 ec 04             	sub    $0x4,%esp
    int num;
    struct proc *curproc = myproc();
80105397:	e8 04 e5 ff ff       	call   801038a0 <myproc>
8010539c:	89 c3                	mov    %eax,%ebx

    num = curproc->tf->eax;
8010539e:	8b 40 18             	mov    0x18(%eax),%eax
801053a1:	8b 40 1c             	mov    0x1c(%eax),%eax
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801053a4:	8d 50 ff             	lea    -0x1(%eax),%edx
801053a7:	83 fa 17             	cmp    $0x17,%edx
801053aa:	77 1c                	ja     801053c8 <syscall+0x38>
801053ac:	8b 14 85 80 88 10 80 	mov    -0x7fef7780(,%eax,4),%edx
801053b3:	85 d2                	test   %edx,%edx
801053b5:	74 11                	je     801053c8 <syscall+0x38>
        curproc->tf->eax = syscalls[num]();
801053b7:	ff d2                	call   *%edx
801053b9:	8b 53 18             	mov    0x18(%ebx),%edx
801053bc:	89 42 1c             	mov    %eax,0x1c(%edx)
    } else {
        cprintf("%d %s: unknown sys call %d\n", curproc->pid, curproc->name,
                num);
        curproc->tf->eax = -1;
    }
}
801053bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053c2:	c9                   	leave  
801053c3:	c3                   	ret    
801053c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("%d %s: unknown sys call %d\n", curproc->pid, curproc->name,
801053c8:	50                   	push   %eax
801053c9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801053cc:	50                   	push   %eax
801053cd:	ff 73 10             	pushl  0x10(%ebx)
801053d0:	68 4d 88 10 80       	push   $0x8010884d
801053d5:	e8 86 b2 ff ff       	call   80100660 <cprintf>
        curproc->tf->eax = -1;
801053da:	8b 43 18             	mov    0x18(%ebx),%eax
801053dd:	83 c4 10             	add    $0x10,%esp
801053e0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801053e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053ea:	c9                   	leave  
801053eb:	c3                   	ret    
801053ec:	66 90                	xchg   %ax,%ax
801053ee:	66 90                	xchg   %ax,%ax

801053f0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	57                   	push   %edi
801053f4:	56                   	push   %esi
801053f5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801053f6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801053f9:	83 ec 34             	sub    $0x34,%esp
801053fc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801053ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105402:	56                   	push   %esi
80105403:	50                   	push   %eax
{
80105404:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105407:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010540a:	e8 f1 ca ff ff       	call   80101f00 <nameiparent>
8010540f:	83 c4 10             	add    $0x10,%esp
80105412:	85 c0                	test   %eax,%eax
80105414:	0f 84 46 01 00 00    	je     80105560 <create+0x170>
    return 0;
  ilock(dp);
8010541a:	83 ec 0c             	sub    $0xc,%esp
8010541d:	89 c3                	mov    %eax,%ebx
8010541f:	50                   	push   %eax
80105420:	e8 5b c2 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105425:	83 c4 0c             	add    $0xc,%esp
80105428:	6a 00                	push   $0x0
8010542a:	56                   	push   %esi
8010542b:	53                   	push   %ebx
8010542c:	e8 7f c7 ff ff       	call   80101bb0 <dirlookup>
80105431:	83 c4 10             	add    $0x10,%esp
80105434:	85 c0                	test   %eax,%eax
80105436:	89 c7                	mov    %eax,%edi
80105438:	74 36                	je     80105470 <create+0x80>
    iunlockput(dp);
8010543a:	83 ec 0c             	sub    $0xc,%esp
8010543d:	53                   	push   %ebx
8010543e:	e8 cd c4 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80105443:	89 3c 24             	mov    %edi,(%esp)
80105446:	e8 35 c2 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010544b:	83 c4 10             	add    $0x10,%esp
8010544e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105453:	0f 85 97 00 00 00    	jne    801054f0 <create+0x100>
80105459:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010545e:	0f 85 8c 00 00 00    	jne    801054f0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105464:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105467:	89 f8                	mov    %edi,%eax
80105469:	5b                   	pop    %ebx
8010546a:	5e                   	pop    %esi
8010546b:	5f                   	pop    %edi
8010546c:	5d                   	pop    %ebp
8010546d:	c3                   	ret    
8010546e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105470:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105474:	83 ec 08             	sub    $0x8,%esp
80105477:	50                   	push   %eax
80105478:	ff 33                	pushl  (%ebx)
8010547a:	e8 91 c0 ff ff       	call   80101510 <ialloc>
8010547f:	83 c4 10             	add    $0x10,%esp
80105482:	85 c0                	test   %eax,%eax
80105484:	89 c7                	mov    %eax,%edi
80105486:	0f 84 e8 00 00 00    	je     80105574 <create+0x184>
  ilock(ip);
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	50                   	push   %eax
80105490:	e8 eb c1 ff ff       	call   80101680 <ilock>
  ip->major = major;
80105495:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105499:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010549d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801054a1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801054a5:	b8 01 00 00 00       	mov    $0x1,%eax
801054aa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801054ae:	89 3c 24             	mov    %edi,(%esp)
801054b1:	e8 1a c1 ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801054b6:	83 c4 10             	add    $0x10,%esp
801054b9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801054be:	74 50                	je     80105510 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801054c0:	83 ec 04             	sub    $0x4,%esp
801054c3:	ff 77 04             	pushl  0x4(%edi)
801054c6:	56                   	push   %esi
801054c7:	53                   	push   %ebx
801054c8:	e8 53 c9 ff ff       	call   80101e20 <dirlink>
801054cd:	83 c4 10             	add    $0x10,%esp
801054d0:	85 c0                	test   %eax,%eax
801054d2:	0f 88 8f 00 00 00    	js     80105567 <create+0x177>
  iunlockput(dp);
801054d8:	83 ec 0c             	sub    $0xc,%esp
801054db:	53                   	push   %ebx
801054dc:	e8 2f c4 ff ff       	call   80101910 <iunlockput>
  return ip;
801054e1:	83 c4 10             	add    $0x10,%esp
}
801054e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054e7:	89 f8                	mov    %edi,%eax
801054e9:	5b                   	pop    %ebx
801054ea:	5e                   	pop    %esi
801054eb:	5f                   	pop    %edi
801054ec:	5d                   	pop    %ebp
801054ed:	c3                   	ret    
801054ee:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801054f0:	83 ec 0c             	sub    $0xc,%esp
801054f3:	57                   	push   %edi
    return 0;
801054f4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801054f6:	e8 15 c4 ff ff       	call   80101910 <iunlockput>
    return 0;
801054fb:	83 c4 10             	add    $0x10,%esp
}
801054fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105501:	89 f8                	mov    %edi,%eax
80105503:	5b                   	pop    %ebx
80105504:	5e                   	pop    %esi
80105505:	5f                   	pop    %edi
80105506:	5d                   	pop    %ebp
80105507:	c3                   	ret    
80105508:	90                   	nop
80105509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105510:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105515:	83 ec 0c             	sub    $0xc,%esp
80105518:	53                   	push   %ebx
80105519:	e8 b2 c0 ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010551e:	83 c4 0c             	add    $0xc,%esp
80105521:	ff 77 04             	pushl  0x4(%edi)
80105524:	68 00 89 10 80       	push   $0x80108900
80105529:	57                   	push   %edi
8010552a:	e8 f1 c8 ff ff       	call   80101e20 <dirlink>
8010552f:	83 c4 10             	add    $0x10,%esp
80105532:	85 c0                	test   %eax,%eax
80105534:	78 1c                	js     80105552 <create+0x162>
80105536:	83 ec 04             	sub    $0x4,%esp
80105539:	ff 73 04             	pushl  0x4(%ebx)
8010553c:	68 ff 88 10 80       	push   $0x801088ff
80105541:	57                   	push   %edi
80105542:	e8 d9 c8 ff ff       	call   80101e20 <dirlink>
80105547:	83 c4 10             	add    $0x10,%esp
8010554a:	85 c0                	test   %eax,%eax
8010554c:	0f 89 6e ff ff ff    	jns    801054c0 <create+0xd0>
      panic("create dots");
80105552:	83 ec 0c             	sub    $0xc,%esp
80105555:	68 f3 88 10 80       	push   $0x801088f3
8010555a:	e8 31 ae ff ff       	call   80100390 <panic>
8010555f:	90                   	nop
    return 0;
80105560:	31 ff                	xor    %edi,%edi
80105562:	e9 fd fe ff ff       	jmp    80105464 <create+0x74>
    panic("create: dirlink");
80105567:	83 ec 0c             	sub    $0xc,%esp
8010556a:	68 02 89 10 80       	push   $0x80108902
8010556f:	e8 1c ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105574:	83 ec 0c             	sub    $0xc,%esp
80105577:	68 e4 88 10 80       	push   $0x801088e4
8010557c:	e8 0f ae ff ff       	call   80100390 <panic>
80105581:	eb 0d                	jmp    80105590 <argfd.constprop.0>
80105583:	90                   	nop
80105584:	90                   	nop
80105585:	90                   	nop
80105586:	90                   	nop
80105587:	90                   	nop
80105588:	90                   	nop
80105589:	90                   	nop
8010558a:	90                   	nop
8010558b:	90                   	nop
8010558c:	90                   	nop
8010558d:	90                   	nop
8010558e:	90                   	nop
8010558f:	90                   	nop

80105590 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	56                   	push   %esi
80105594:	53                   	push   %ebx
80105595:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105597:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010559a:	89 d6                	mov    %edx,%esi
8010559c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010559f:	50                   	push   %eax
801055a0:	6a 00                	push   $0x0
801055a2:	e8 f9 fc ff ff       	call   801052a0 <argint>
801055a7:	83 c4 10             	add    $0x10,%esp
801055aa:	85 c0                	test   %eax,%eax
801055ac:	78 2a                	js     801055d8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055b2:	77 24                	ja     801055d8 <argfd.constprop.0+0x48>
801055b4:	e8 e7 e2 ff ff       	call   801038a0 <myproc>
801055b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055bc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801055c0:	85 c0                	test   %eax,%eax
801055c2:	74 14                	je     801055d8 <argfd.constprop.0+0x48>
  if(pfd)
801055c4:	85 db                	test   %ebx,%ebx
801055c6:	74 02                	je     801055ca <argfd.constprop.0+0x3a>
    *pfd = fd;
801055c8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801055ca:	89 06                	mov    %eax,(%esi)
  return 0;
801055cc:	31 c0                	xor    %eax,%eax
}
801055ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055d1:	5b                   	pop    %ebx
801055d2:	5e                   	pop    %esi
801055d3:	5d                   	pop    %ebp
801055d4:	c3                   	ret    
801055d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801055d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055dd:	eb ef                	jmp    801055ce <argfd.constprop.0+0x3e>
801055df:	90                   	nop

801055e0 <sys_dup>:
{
801055e0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801055e1:	31 c0                	xor    %eax,%eax
{
801055e3:	89 e5                	mov    %esp,%ebp
801055e5:	56                   	push   %esi
801055e6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801055e7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801055ea:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801055ed:	e8 9e ff ff ff       	call   80105590 <argfd.constprop.0>
801055f2:	85 c0                	test   %eax,%eax
801055f4:	78 42                	js     80105638 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801055f6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801055f9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801055fb:	e8 a0 e2 ff ff       	call   801038a0 <myproc>
80105600:	eb 0e                	jmp    80105610 <sys_dup+0x30>
80105602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105608:	83 c3 01             	add    $0x1,%ebx
8010560b:	83 fb 10             	cmp    $0x10,%ebx
8010560e:	74 28                	je     80105638 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105610:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105614:	85 d2                	test   %edx,%edx
80105616:	75 f0                	jne    80105608 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105618:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010561c:	83 ec 0c             	sub    $0xc,%esp
8010561f:	ff 75 f4             	pushl  -0xc(%ebp)
80105622:	e8 c9 b7 ff ff       	call   80100df0 <filedup>
  return fd;
80105627:	83 c4 10             	add    $0x10,%esp
}
8010562a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010562d:	89 d8                	mov    %ebx,%eax
8010562f:	5b                   	pop    %ebx
80105630:	5e                   	pop    %esi
80105631:	5d                   	pop    %ebp
80105632:	c3                   	ret    
80105633:	90                   	nop
80105634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105638:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010563b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105640:	89 d8                	mov    %ebx,%eax
80105642:	5b                   	pop    %ebx
80105643:	5e                   	pop    %esi
80105644:	5d                   	pop    %ebp
80105645:	c3                   	ret    
80105646:	8d 76 00             	lea    0x0(%esi),%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105650 <sys_read>:
{
80105650:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105651:	31 c0                	xor    %eax,%eax
{
80105653:	89 e5                	mov    %esp,%ebp
80105655:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105658:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010565b:	e8 30 ff ff ff       	call   80105590 <argfd.constprop.0>
80105660:	85 c0                	test   %eax,%eax
80105662:	78 4c                	js     801056b0 <sys_read+0x60>
80105664:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105667:	83 ec 08             	sub    $0x8,%esp
8010566a:	50                   	push   %eax
8010566b:	6a 02                	push   $0x2
8010566d:	e8 2e fc ff ff       	call   801052a0 <argint>
80105672:	83 c4 10             	add    $0x10,%esp
80105675:	85 c0                	test   %eax,%eax
80105677:	78 37                	js     801056b0 <sys_read+0x60>
80105679:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010567c:	83 ec 04             	sub    $0x4,%esp
8010567f:	ff 75 f0             	pushl  -0x10(%ebp)
80105682:	50                   	push   %eax
80105683:	6a 01                	push   $0x1
80105685:	e8 66 fc ff ff       	call   801052f0 <argptr>
8010568a:	83 c4 10             	add    $0x10,%esp
8010568d:	85 c0                	test   %eax,%eax
8010568f:	78 1f                	js     801056b0 <sys_read+0x60>
  return fileread(f, p, n);
80105691:	83 ec 04             	sub    $0x4,%esp
80105694:	ff 75 f0             	pushl  -0x10(%ebp)
80105697:	ff 75 f4             	pushl  -0xc(%ebp)
8010569a:	ff 75 ec             	pushl  -0x14(%ebp)
8010569d:	e8 be b8 ff ff       	call   80100f60 <fileread>
801056a2:	83 c4 10             	add    $0x10,%esp
}
801056a5:	c9                   	leave  
801056a6:	c3                   	ret    
801056a7:	89 f6                	mov    %esi,%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801056b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056b5:	c9                   	leave  
801056b6:	c3                   	ret    
801056b7:	89 f6                	mov    %esi,%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056c0 <sys_write>:
{
801056c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056c1:	31 c0                	xor    %eax,%eax
{
801056c3:	89 e5                	mov    %esp,%ebp
801056c5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056c8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801056cb:	e8 c0 fe ff ff       	call   80105590 <argfd.constprop.0>
801056d0:	85 c0                	test   %eax,%eax
801056d2:	78 4c                	js     80105720 <sys_write+0x60>
801056d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056d7:	83 ec 08             	sub    $0x8,%esp
801056da:	50                   	push   %eax
801056db:	6a 02                	push   $0x2
801056dd:	e8 be fb ff ff       	call   801052a0 <argint>
801056e2:	83 c4 10             	add    $0x10,%esp
801056e5:	85 c0                	test   %eax,%eax
801056e7:	78 37                	js     80105720 <sys_write+0x60>
801056e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ec:	83 ec 04             	sub    $0x4,%esp
801056ef:	ff 75 f0             	pushl  -0x10(%ebp)
801056f2:	50                   	push   %eax
801056f3:	6a 01                	push   $0x1
801056f5:	e8 f6 fb ff ff       	call   801052f0 <argptr>
801056fa:	83 c4 10             	add    $0x10,%esp
801056fd:	85 c0                	test   %eax,%eax
801056ff:	78 1f                	js     80105720 <sys_write+0x60>
  return filewrite(f, p, n);
80105701:	83 ec 04             	sub    $0x4,%esp
80105704:	ff 75 f0             	pushl  -0x10(%ebp)
80105707:	ff 75 f4             	pushl  -0xc(%ebp)
8010570a:	ff 75 ec             	pushl  -0x14(%ebp)
8010570d:	e8 de b8 ff ff       	call   80100ff0 <filewrite>
80105712:	83 c4 10             	add    $0x10,%esp
}
80105715:	c9                   	leave  
80105716:	c3                   	ret    
80105717:	89 f6                	mov    %esi,%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105725:	c9                   	leave  
80105726:	c3                   	ret    
80105727:	89 f6                	mov    %esi,%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105730 <sys_close>:
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105736:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105739:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010573c:	e8 4f fe ff ff       	call   80105590 <argfd.constprop.0>
80105741:	85 c0                	test   %eax,%eax
80105743:	78 2b                	js     80105770 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105745:	e8 56 e1 ff ff       	call   801038a0 <myproc>
8010574a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010574d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105750:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105757:	00 
  fileclose(f);
80105758:	ff 75 f4             	pushl  -0xc(%ebp)
8010575b:	e8 e0 b6 ff ff       	call   80100e40 <fileclose>
  return 0;
80105760:	83 c4 10             	add    $0x10,%esp
80105763:	31 c0                	xor    %eax,%eax
}
80105765:	c9                   	leave  
80105766:	c3                   	ret    
80105767:	89 f6                	mov    %esi,%esi
80105769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105775:	c9                   	leave  
80105776:	c3                   	ret    
80105777:	89 f6                	mov    %esi,%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105780 <sys_fstat>:
{
80105780:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105781:	31 c0                	xor    %eax,%eax
{
80105783:	89 e5                	mov    %esp,%ebp
80105785:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105788:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010578b:	e8 00 fe ff ff       	call   80105590 <argfd.constprop.0>
80105790:	85 c0                	test   %eax,%eax
80105792:	78 2c                	js     801057c0 <sys_fstat+0x40>
80105794:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105797:	83 ec 04             	sub    $0x4,%esp
8010579a:	6a 14                	push   $0x14
8010579c:	50                   	push   %eax
8010579d:	6a 01                	push   $0x1
8010579f:	e8 4c fb ff ff       	call   801052f0 <argptr>
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	85 c0                	test   %eax,%eax
801057a9:	78 15                	js     801057c0 <sys_fstat+0x40>
  return filestat(f, st);
801057ab:	83 ec 08             	sub    $0x8,%esp
801057ae:	ff 75 f4             	pushl  -0xc(%ebp)
801057b1:	ff 75 f0             	pushl  -0x10(%ebp)
801057b4:	e8 57 b7 ff ff       	call   80100f10 <filestat>
801057b9:	83 c4 10             	add    $0x10,%esp
}
801057bc:	c9                   	leave  
801057bd:	c3                   	ret    
801057be:	66 90                	xchg   %ax,%ax
    return -1;
801057c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057c5:	c9                   	leave  
801057c6:	c3                   	ret    
801057c7:	89 f6                	mov    %esi,%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057d0 <sys_link>:
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
801057d5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801057d6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801057d9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801057dc:	50                   	push   %eax
801057dd:	6a 00                	push   $0x0
801057df:	e8 6c fb ff ff       	call   80105350 <argstr>
801057e4:	83 c4 10             	add    $0x10,%esp
801057e7:	85 c0                	test   %eax,%eax
801057e9:	0f 88 fb 00 00 00    	js     801058ea <sys_link+0x11a>
801057ef:	8d 45 d0             	lea    -0x30(%ebp),%eax
801057f2:	83 ec 08             	sub    $0x8,%esp
801057f5:	50                   	push   %eax
801057f6:	6a 01                	push   $0x1
801057f8:	e8 53 fb ff ff       	call   80105350 <argstr>
801057fd:	83 c4 10             	add    $0x10,%esp
80105800:	85 c0                	test   %eax,%eax
80105802:	0f 88 e2 00 00 00    	js     801058ea <sys_link+0x11a>
  begin_op();
80105808:	e8 93 d3 ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
8010580d:	83 ec 0c             	sub    $0xc,%esp
80105810:	ff 75 d4             	pushl  -0x2c(%ebp)
80105813:	e8 c8 c6 ff ff       	call   80101ee0 <namei>
80105818:	83 c4 10             	add    $0x10,%esp
8010581b:	85 c0                	test   %eax,%eax
8010581d:	89 c3                	mov    %eax,%ebx
8010581f:	0f 84 ea 00 00 00    	je     8010590f <sys_link+0x13f>
  ilock(ip);
80105825:	83 ec 0c             	sub    $0xc,%esp
80105828:	50                   	push   %eax
80105829:	e8 52 be ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
8010582e:	83 c4 10             	add    $0x10,%esp
80105831:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105836:	0f 84 bb 00 00 00    	je     801058f7 <sys_link+0x127>
  ip->nlink++;
8010583c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105841:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105844:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105847:	53                   	push   %ebx
80105848:	e8 83 bd ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
8010584d:	89 1c 24             	mov    %ebx,(%esp)
80105850:	e8 0b bf ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105855:	58                   	pop    %eax
80105856:	5a                   	pop    %edx
80105857:	57                   	push   %edi
80105858:	ff 75 d0             	pushl  -0x30(%ebp)
8010585b:	e8 a0 c6 ff ff       	call   80101f00 <nameiparent>
80105860:	83 c4 10             	add    $0x10,%esp
80105863:	85 c0                	test   %eax,%eax
80105865:	89 c6                	mov    %eax,%esi
80105867:	74 5b                	je     801058c4 <sys_link+0xf4>
  ilock(dp);
80105869:	83 ec 0c             	sub    $0xc,%esp
8010586c:	50                   	push   %eax
8010586d:	e8 0e be ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105872:	83 c4 10             	add    $0x10,%esp
80105875:	8b 03                	mov    (%ebx),%eax
80105877:	39 06                	cmp    %eax,(%esi)
80105879:	75 3d                	jne    801058b8 <sys_link+0xe8>
8010587b:	83 ec 04             	sub    $0x4,%esp
8010587e:	ff 73 04             	pushl  0x4(%ebx)
80105881:	57                   	push   %edi
80105882:	56                   	push   %esi
80105883:	e8 98 c5 ff ff       	call   80101e20 <dirlink>
80105888:	83 c4 10             	add    $0x10,%esp
8010588b:	85 c0                	test   %eax,%eax
8010588d:	78 29                	js     801058b8 <sys_link+0xe8>
  iunlockput(dp);
8010588f:	83 ec 0c             	sub    $0xc,%esp
80105892:	56                   	push   %esi
80105893:	e8 78 c0 ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105898:	89 1c 24             	mov    %ebx,(%esp)
8010589b:	e8 10 bf ff ff       	call   801017b0 <iput>
  end_op();
801058a0:	e8 6b d3 ff ff       	call   80102c10 <end_op>
  return 0;
801058a5:	83 c4 10             	add    $0x10,%esp
801058a8:	31 c0                	xor    %eax,%eax
}
801058aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058ad:	5b                   	pop    %ebx
801058ae:	5e                   	pop    %esi
801058af:	5f                   	pop    %edi
801058b0:	5d                   	pop    %ebp
801058b1:	c3                   	ret    
801058b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801058b8:	83 ec 0c             	sub    $0xc,%esp
801058bb:	56                   	push   %esi
801058bc:	e8 4f c0 ff ff       	call   80101910 <iunlockput>
    goto bad;
801058c1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801058c4:	83 ec 0c             	sub    $0xc,%esp
801058c7:	53                   	push   %ebx
801058c8:	e8 b3 bd ff ff       	call   80101680 <ilock>
  ip->nlink--;
801058cd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801058d2:	89 1c 24             	mov    %ebx,(%esp)
801058d5:	e8 f6 bc ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
801058da:	89 1c 24             	mov    %ebx,(%esp)
801058dd:	e8 2e c0 ff ff       	call   80101910 <iunlockput>
  end_op();
801058e2:	e8 29 d3 ff ff       	call   80102c10 <end_op>
  return -1;
801058e7:	83 c4 10             	add    $0x10,%esp
}
801058ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801058ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058f2:	5b                   	pop    %ebx
801058f3:	5e                   	pop    %esi
801058f4:	5f                   	pop    %edi
801058f5:	5d                   	pop    %ebp
801058f6:	c3                   	ret    
    iunlockput(ip);
801058f7:	83 ec 0c             	sub    $0xc,%esp
801058fa:	53                   	push   %ebx
801058fb:	e8 10 c0 ff ff       	call   80101910 <iunlockput>
    end_op();
80105900:	e8 0b d3 ff ff       	call   80102c10 <end_op>
    return -1;
80105905:	83 c4 10             	add    $0x10,%esp
80105908:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010590d:	eb 9b                	jmp    801058aa <sys_link+0xda>
    end_op();
8010590f:	e8 fc d2 ff ff       	call   80102c10 <end_op>
    return -1;
80105914:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105919:	eb 8f                	jmp    801058aa <sys_link+0xda>
8010591b:	90                   	nop
8010591c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105920 <sys_unlink>:
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	57                   	push   %edi
80105924:	56                   	push   %esi
80105925:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105926:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105929:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010592c:	50                   	push   %eax
8010592d:	6a 00                	push   $0x0
8010592f:	e8 1c fa ff ff       	call   80105350 <argstr>
80105934:	83 c4 10             	add    $0x10,%esp
80105937:	85 c0                	test   %eax,%eax
80105939:	0f 88 77 01 00 00    	js     80105ab6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010593f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105942:	e8 59 d2 ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105947:	83 ec 08             	sub    $0x8,%esp
8010594a:	53                   	push   %ebx
8010594b:	ff 75 c0             	pushl  -0x40(%ebp)
8010594e:	e8 ad c5 ff ff       	call   80101f00 <nameiparent>
80105953:	83 c4 10             	add    $0x10,%esp
80105956:	85 c0                	test   %eax,%eax
80105958:	89 c6                	mov    %eax,%esi
8010595a:	0f 84 60 01 00 00    	je     80105ac0 <sys_unlink+0x1a0>
  ilock(dp);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	50                   	push   %eax
80105964:	e8 17 bd ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105969:	58                   	pop    %eax
8010596a:	5a                   	pop    %edx
8010596b:	68 00 89 10 80       	push   $0x80108900
80105970:	53                   	push   %ebx
80105971:	e8 1a c2 ff ff       	call   80101b90 <namecmp>
80105976:	83 c4 10             	add    $0x10,%esp
80105979:	85 c0                	test   %eax,%eax
8010597b:	0f 84 03 01 00 00    	je     80105a84 <sys_unlink+0x164>
80105981:	83 ec 08             	sub    $0x8,%esp
80105984:	68 ff 88 10 80       	push   $0x801088ff
80105989:	53                   	push   %ebx
8010598a:	e8 01 c2 ff ff       	call   80101b90 <namecmp>
8010598f:	83 c4 10             	add    $0x10,%esp
80105992:	85 c0                	test   %eax,%eax
80105994:	0f 84 ea 00 00 00    	je     80105a84 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010599a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010599d:	83 ec 04             	sub    $0x4,%esp
801059a0:	50                   	push   %eax
801059a1:	53                   	push   %ebx
801059a2:	56                   	push   %esi
801059a3:	e8 08 c2 ff ff       	call   80101bb0 <dirlookup>
801059a8:	83 c4 10             	add    $0x10,%esp
801059ab:	85 c0                	test   %eax,%eax
801059ad:	89 c3                	mov    %eax,%ebx
801059af:	0f 84 cf 00 00 00    	je     80105a84 <sys_unlink+0x164>
  ilock(ip);
801059b5:	83 ec 0c             	sub    $0xc,%esp
801059b8:	50                   	push   %eax
801059b9:	e8 c2 bc ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
801059be:	83 c4 10             	add    $0x10,%esp
801059c1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801059c6:	0f 8e 10 01 00 00    	jle    80105adc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801059cc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059d1:	74 6d                	je     80105a40 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801059d3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801059d6:	83 ec 04             	sub    $0x4,%esp
801059d9:	6a 10                	push   $0x10
801059db:	6a 00                	push   $0x0
801059dd:	50                   	push   %eax
801059de:	e8 bd f5 ff ff       	call   80104fa0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059e3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801059e6:	6a 10                	push   $0x10
801059e8:	ff 75 c4             	pushl  -0x3c(%ebp)
801059eb:	50                   	push   %eax
801059ec:	56                   	push   %esi
801059ed:	e8 6e c0 ff ff       	call   80101a60 <writei>
801059f2:	83 c4 20             	add    $0x20,%esp
801059f5:	83 f8 10             	cmp    $0x10,%eax
801059f8:	0f 85 eb 00 00 00    	jne    80105ae9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801059fe:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a03:	0f 84 97 00 00 00    	je     80105aa0 <sys_unlink+0x180>
  iunlockput(dp);
80105a09:	83 ec 0c             	sub    $0xc,%esp
80105a0c:	56                   	push   %esi
80105a0d:	e8 fe be ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80105a12:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a17:	89 1c 24             	mov    %ebx,(%esp)
80105a1a:	e8 b1 bb ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80105a1f:	89 1c 24             	mov    %ebx,(%esp)
80105a22:	e8 e9 be ff ff       	call   80101910 <iunlockput>
  end_op();
80105a27:	e8 e4 d1 ff ff       	call   80102c10 <end_op>
  return 0;
80105a2c:	83 c4 10             	add    $0x10,%esp
80105a2f:	31 c0                	xor    %eax,%eax
}
80105a31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a34:	5b                   	pop    %ebx
80105a35:	5e                   	pop    %esi
80105a36:	5f                   	pop    %edi
80105a37:	5d                   	pop    %ebp
80105a38:	c3                   	ret    
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a40:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105a44:	76 8d                	jbe    801059d3 <sys_unlink+0xb3>
80105a46:	bf 20 00 00 00       	mov    $0x20,%edi
80105a4b:	eb 0f                	jmp    80105a5c <sys_unlink+0x13c>
80105a4d:	8d 76 00             	lea    0x0(%esi),%esi
80105a50:	83 c7 10             	add    $0x10,%edi
80105a53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105a56:	0f 83 77 ff ff ff    	jae    801059d3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a5c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a5f:	6a 10                	push   $0x10
80105a61:	57                   	push   %edi
80105a62:	50                   	push   %eax
80105a63:	53                   	push   %ebx
80105a64:	e8 f7 be ff ff       	call   80101960 <readi>
80105a69:	83 c4 10             	add    $0x10,%esp
80105a6c:	83 f8 10             	cmp    $0x10,%eax
80105a6f:	75 5e                	jne    80105acf <sys_unlink+0x1af>
    if(de.inum != 0)
80105a71:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105a76:	74 d8                	je     80105a50 <sys_unlink+0x130>
    iunlockput(ip);
80105a78:	83 ec 0c             	sub    $0xc,%esp
80105a7b:	53                   	push   %ebx
80105a7c:	e8 8f be ff ff       	call   80101910 <iunlockput>
    goto bad;
80105a81:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105a84:	83 ec 0c             	sub    $0xc,%esp
80105a87:	56                   	push   %esi
80105a88:	e8 83 be ff ff       	call   80101910 <iunlockput>
  end_op();
80105a8d:	e8 7e d1 ff ff       	call   80102c10 <end_op>
  return -1;
80105a92:	83 c4 10             	add    $0x10,%esp
80105a95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a9a:	eb 95                	jmp    80105a31 <sys_unlink+0x111>
80105a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105aa0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105aa5:	83 ec 0c             	sub    $0xc,%esp
80105aa8:	56                   	push   %esi
80105aa9:	e8 22 bb ff ff       	call   801015d0 <iupdate>
80105aae:	83 c4 10             	add    $0x10,%esp
80105ab1:	e9 53 ff ff ff       	jmp    80105a09 <sys_unlink+0xe9>
    return -1;
80105ab6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abb:	e9 71 ff ff ff       	jmp    80105a31 <sys_unlink+0x111>
    end_op();
80105ac0:	e8 4b d1 ff ff       	call   80102c10 <end_op>
    return -1;
80105ac5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aca:	e9 62 ff ff ff       	jmp    80105a31 <sys_unlink+0x111>
      panic("isdirempty: readi");
80105acf:	83 ec 0c             	sub    $0xc,%esp
80105ad2:	68 24 89 10 80       	push   $0x80108924
80105ad7:	e8 b4 a8 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105adc:	83 ec 0c             	sub    $0xc,%esp
80105adf:	68 12 89 10 80       	push   $0x80108912
80105ae4:	e8 a7 a8 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105ae9:	83 ec 0c             	sub    $0xc,%esp
80105aec:	68 36 89 10 80       	push   $0x80108936
80105af1:	e8 9a a8 ff ff       	call   80100390 <panic>
80105af6:	8d 76 00             	lea    0x0(%esi),%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b00 <sys_open>:

int
sys_open(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	57                   	push   %edi
80105b04:	56                   	push   %esi
80105b05:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b06:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105b09:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b0c:	50                   	push   %eax
80105b0d:	6a 00                	push   $0x0
80105b0f:	e8 3c f8 ff ff       	call   80105350 <argstr>
80105b14:	83 c4 10             	add    $0x10,%esp
80105b17:	85 c0                	test   %eax,%eax
80105b19:	0f 88 1d 01 00 00    	js     80105c3c <sys_open+0x13c>
80105b1f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b22:	83 ec 08             	sub    $0x8,%esp
80105b25:	50                   	push   %eax
80105b26:	6a 01                	push   $0x1
80105b28:	e8 73 f7 ff ff       	call   801052a0 <argint>
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	85 c0                	test   %eax,%eax
80105b32:	0f 88 04 01 00 00    	js     80105c3c <sys_open+0x13c>
    return -1;

  begin_op();
80105b38:	e8 63 d0 ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
80105b3d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105b41:	0f 85 a9 00 00 00    	jne    80105bf0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105b47:	83 ec 0c             	sub    $0xc,%esp
80105b4a:	ff 75 e0             	pushl  -0x20(%ebp)
80105b4d:	e8 8e c3 ff ff       	call   80101ee0 <namei>
80105b52:	83 c4 10             	add    $0x10,%esp
80105b55:	85 c0                	test   %eax,%eax
80105b57:	89 c6                	mov    %eax,%esi
80105b59:	0f 84 b2 00 00 00    	je     80105c11 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105b5f:	83 ec 0c             	sub    $0xc,%esp
80105b62:	50                   	push   %eax
80105b63:	e8 18 bb ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b68:	83 c4 10             	add    $0x10,%esp
80105b6b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105b70:	0f 84 aa 00 00 00    	je     80105c20 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b76:	e8 05 b2 ff ff       	call   80100d80 <filealloc>
80105b7b:	85 c0                	test   %eax,%eax
80105b7d:	89 c7                	mov    %eax,%edi
80105b7f:	0f 84 a6 00 00 00    	je     80105c2b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105b85:	e8 16 dd ff ff       	call   801038a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b8a:	31 db                	xor    %ebx,%ebx
80105b8c:	eb 0e                	jmp    80105b9c <sys_open+0x9c>
80105b8e:	66 90                	xchg   %ax,%ax
80105b90:	83 c3 01             	add    $0x1,%ebx
80105b93:	83 fb 10             	cmp    $0x10,%ebx
80105b96:	0f 84 ac 00 00 00    	je     80105c48 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105b9c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ba0:	85 d2                	test   %edx,%edx
80105ba2:	75 ec                	jne    80105b90 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ba4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105ba7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105bab:	56                   	push   %esi
80105bac:	e8 af bb ff ff       	call   80101760 <iunlock>
  end_op();
80105bb1:	e8 5a d0 ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80105bb6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105bbc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bbf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105bc2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105bc5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105bcc:	89 d0                	mov    %edx,%eax
80105bce:	f7 d0                	not    %eax
80105bd0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bd3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105bd6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bd9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105bdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105be0:	89 d8                	mov    %ebx,%eax
80105be2:	5b                   	pop    %ebx
80105be3:	5e                   	pop    %esi
80105be4:	5f                   	pop    %edi
80105be5:	5d                   	pop    %ebp
80105be6:	c3                   	ret    
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105bf0:	83 ec 0c             	sub    $0xc,%esp
80105bf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105bf6:	31 c9                	xor    %ecx,%ecx
80105bf8:	6a 00                	push   $0x0
80105bfa:	ba 02 00 00 00       	mov    $0x2,%edx
80105bff:	e8 ec f7 ff ff       	call   801053f0 <create>
    if(ip == 0){
80105c04:	83 c4 10             	add    $0x10,%esp
80105c07:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105c09:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105c0b:	0f 85 65 ff ff ff    	jne    80105b76 <sys_open+0x76>
      end_op();
80105c11:	e8 fa cf ff ff       	call   80102c10 <end_op>
      return -1;
80105c16:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c1b:	eb c0                	jmp    80105bdd <sys_open+0xdd>
80105c1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c20:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105c23:	85 c9                	test   %ecx,%ecx
80105c25:	0f 84 4b ff ff ff    	je     80105b76 <sys_open+0x76>
    iunlockput(ip);
80105c2b:	83 ec 0c             	sub    $0xc,%esp
80105c2e:	56                   	push   %esi
80105c2f:	e8 dc bc ff ff       	call   80101910 <iunlockput>
    end_op();
80105c34:	e8 d7 cf ff ff       	call   80102c10 <end_op>
    return -1;
80105c39:	83 c4 10             	add    $0x10,%esp
80105c3c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c41:	eb 9a                	jmp    80105bdd <sys_open+0xdd>
80105c43:	90                   	nop
80105c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105c48:	83 ec 0c             	sub    $0xc,%esp
80105c4b:	57                   	push   %edi
80105c4c:	e8 ef b1 ff ff       	call   80100e40 <fileclose>
80105c51:	83 c4 10             	add    $0x10,%esp
80105c54:	eb d5                	jmp    80105c2b <sys_open+0x12b>
80105c56:	8d 76 00             	lea    0x0(%esi),%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c60 <sys_mkdir>:

int
sys_mkdir(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105c66:	e8 35 cf ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c6e:	83 ec 08             	sub    $0x8,%esp
80105c71:	50                   	push   %eax
80105c72:	6a 00                	push   $0x0
80105c74:	e8 d7 f6 ff ff       	call   80105350 <argstr>
80105c79:	83 c4 10             	add    $0x10,%esp
80105c7c:	85 c0                	test   %eax,%eax
80105c7e:	78 30                	js     80105cb0 <sys_mkdir+0x50>
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c86:	31 c9                	xor    %ecx,%ecx
80105c88:	6a 00                	push   $0x0
80105c8a:	ba 01 00 00 00       	mov    $0x1,%edx
80105c8f:	e8 5c f7 ff ff       	call   801053f0 <create>
80105c94:	83 c4 10             	add    $0x10,%esp
80105c97:	85 c0                	test   %eax,%eax
80105c99:	74 15                	je     80105cb0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c9b:	83 ec 0c             	sub    $0xc,%esp
80105c9e:	50                   	push   %eax
80105c9f:	e8 6c bc ff ff       	call   80101910 <iunlockput>
  end_op();
80105ca4:	e8 67 cf ff ff       	call   80102c10 <end_op>
  return 0;
80105ca9:	83 c4 10             	add    $0x10,%esp
80105cac:	31 c0                	xor    %eax,%eax
}
80105cae:	c9                   	leave  
80105caf:	c3                   	ret    
    end_op();
80105cb0:	e8 5b cf ff ff       	call   80102c10 <end_op>
    return -1;
80105cb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cba:	c9                   	leave  
80105cbb:	c3                   	ret    
80105cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cc0 <sys_mknod>:

int
sys_mknod(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105cc6:	e8 d5 ce ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105ccb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105cce:	83 ec 08             	sub    $0x8,%esp
80105cd1:	50                   	push   %eax
80105cd2:	6a 00                	push   $0x0
80105cd4:	e8 77 f6 ff ff       	call   80105350 <argstr>
80105cd9:	83 c4 10             	add    $0x10,%esp
80105cdc:	85 c0                	test   %eax,%eax
80105cde:	78 60                	js     80105d40 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105ce0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ce3:	83 ec 08             	sub    $0x8,%esp
80105ce6:	50                   	push   %eax
80105ce7:	6a 01                	push   $0x1
80105ce9:	e8 b2 f5 ff ff       	call   801052a0 <argint>
  if((argstr(0, &path)) < 0 ||
80105cee:	83 c4 10             	add    $0x10,%esp
80105cf1:	85 c0                	test   %eax,%eax
80105cf3:	78 4b                	js     80105d40 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105cf5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cf8:	83 ec 08             	sub    $0x8,%esp
80105cfb:	50                   	push   %eax
80105cfc:	6a 02                	push   $0x2
80105cfe:	e8 9d f5 ff ff       	call   801052a0 <argint>
     argint(1, &major) < 0 ||
80105d03:	83 c4 10             	add    $0x10,%esp
80105d06:	85 c0                	test   %eax,%eax
80105d08:	78 36                	js     80105d40 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d0a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105d0e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d11:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105d15:	ba 03 00 00 00       	mov    $0x3,%edx
80105d1a:	50                   	push   %eax
80105d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d1e:	e8 cd f6 ff ff       	call   801053f0 <create>
80105d23:	83 c4 10             	add    $0x10,%esp
80105d26:	85 c0                	test   %eax,%eax
80105d28:	74 16                	je     80105d40 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d2a:	83 ec 0c             	sub    $0xc,%esp
80105d2d:	50                   	push   %eax
80105d2e:	e8 dd bb ff ff       	call   80101910 <iunlockput>
  end_op();
80105d33:	e8 d8 ce ff ff       	call   80102c10 <end_op>
  return 0;
80105d38:	83 c4 10             	add    $0x10,%esp
80105d3b:	31 c0                	xor    %eax,%eax
}
80105d3d:	c9                   	leave  
80105d3e:	c3                   	ret    
80105d3f:	90                   	nop
    end_op();
80105d40:	e8 cb ce ff ff       	call   80102c10 <end_op>
    return -1;
80105d45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d4a:	c9                   	leave  
80105d4b:	c3                   	ret    
80105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d50 <sys_chdir>:

int
sys_chdir(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	56                   	push   %esi
80105d54:	53                   	push   %ebx
80105d55:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105d58:	e8 43 db ff ff       	call   801038a0 <myproc>
80105d5d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105d5f:	e8 3c ce ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105d64:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d67:	83 ec 08             	sub    $0x8,%esp
80105d6a:	50                   	push   %eax
80105d6b:	6a 00                	push   $0x0
80105d6d:	e8 de f5 ff ff       	call   80105350 <argstr>
80105d72:	83 c4 10             	add    $0x10,%esp
80105d75:	85 c0                	test   %eax,%eax
80105d77:	78 77                	js     80105df0 <sys_chdir+0xa0>
80105d79:	83 ec 0c             	sub    $0xc,%esp
80105d7c:	ff 75 f4             	pushl  -0xc(%ebp)
80105d7f:	e8 5c c1 ff ff       	call   80101ee0 <namei>
80105d84:	83 c4 10             	add    $0x10,%esp
80105d87:	85 c0                	test   %eax,%eax
80105d89:	89 c3                	mov    %eax,%ebx
80105d8b:	74 63                	je     80105df0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105d8d:	83 ec 0c             	sub    $0xc,%esp
80105d90:	50                   	push   %eax
80105d91:	e8 ea b8 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105d96:	83 c4 10             	add    $0x10,%esp
80105d99:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d9e:	75 30                	jne    80105dd0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105da0:	83 ec 0c             	sub    $0xc,%esp
80105da3:	53                   	push   %ebx
80105da4:	e8 b7 b9 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105da9:	58                   	pop    %eax
80105daa:	ff 76 68             	pushl  0x68(%esi)
80105dad:	e8 fe b9 ff ff       	call   801017b0 <iput>
  end_op();
80105db2:	e8 59 ce ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80105db7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105dba:	83 c4 10             	add    $0x10,%esp
80105dbd:	31 c0                	xor    %eax,%eax
}
80105dbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105dc2:	5b                   	pop    %ebx
80105dc3:	5e                   	pop    %esi
80105dc4:	5d                   	pop    %ebp
80105dc5:	c3                   	ret    
80105dc6:	8d 76 00             	lea    0x0(%esi),%esi
80105dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105dd0:	83 ec 0c             	sub    $0xc,%esp
80105dd3:	53                   	push   %ebx
80105dd4:	e8 37 bb ff ff       	call   80101910 <iunlockput>
    end_op();
80105dd9:	e8 32 ce ff ff       	call   80102c10 <end_op>
    return -1;
80105dde:	83 c4 10             	add    $0x10,%esp
80105de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105de6:	eb d7                	jmp    80105dbf <sys_chdir+0x6f>
80105de8:	90                   	nop
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105df0:	e8 1b ce ff ff       	call   80102c10 <end_op>
    return -1;
80105df5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dfa:	eb c3                	jmp    80105dbf <sys_chdir+0x6f>
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e00 <sys_exec>:

int
sys_exec(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	57                   	push   %edi
80105e04:	56                   	push   %esi
80105e05:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e06:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105e0c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e12:	50                   	push   %eax
80105e13:	6a 00                	push   $0x0
80105e15:	e8 36 f5 ff ff       	call   80105350 <argstr>
80105e1a:	83 c4 10             	add    $0x10,%esp
80105e1d:	85 c0                	test   %eax,%eax
80105e1f:	0f 88 87 00 00 00    	js     80105eac <sys_exec+0xac>
80105e25:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105e2b:	83 ec 08             	sub    $0x8,%esp
80105e2e:	50                   	push   %eax
80105e2f:	6a 01                	push   $0x1
80105e31:	e8 6a f4 ff ff       	call   801052a0 <argint>
80105e36:	83 c4 10             	add    $0x10,%esp
80105e39:	85 c0                	test   %eax,%eax
80105e3b:	78 6f                	js     80105eac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105e3d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105e43:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105e46:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105e48:	68 80 00 00 00       	push   $0x80
80105e4d:	6a 00                	push   $0x0
80105e4f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105e55:	50                   	push   %eax
80105e56:	e8 45 f1 ff ff       	call   80104fa0 <memset>
80105e5b:	83 c4 10             	add    $0x10,%esp
80105e5e:	eb 2c                	jmp    80105e8c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105e60:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105e66:	85 c0                	test   %eax,%eax
80105e68:	74 56                	je     80105ec0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e6a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105e70:	83 ec 08             	sub    $0x8,%esp
80105e73:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105e76:	52                   	push   %edx
80105e77:	50                   	push   %eax
80105e78:	e8 b3 f3 ff ff       	call   80105230 <fetchstr>
80105e7d:	83 c4 10             	add    $0x10,%esp
80105e80:	85 c0                	test   %eax,%eax
80105e82:	78 28                	js     80105eac <sys_exec+0xac>
  for(i=0;; i++){
80105e84:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e87:	83 fb 20             	cmp    $0x20,%ebx
80105e8a:	74 20                	je     80105eac <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105e8c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105e92:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105e99:	83 ec 08             	sub    $0x8,%esp
80105e9c:	57                   	push   %edi
80105e9d:	01 f0                	add    %esi,%eax
80105e9f:	50                   	push   %eax
80105ea0:	e8 4b f3 ff ff       	call   801051f0 <fetchint>
80105ea5:	83 c4 10             	add    $0x10,%esp
80105ea8:	85 c0                	test   %eax,%eax
80105eaa:	79 b4                	jns    80105e60 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105eaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eb4:	5b                   	pop    %ebx
80105eb5:	5e                   	pop    %esi
80105eb6:	5f                   	pop    %edi
80105eb7:	5d                   	pop    %ebp
80105eb8:	c3                   	ret    
80105eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105ec0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ec6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105ec9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ed0:	00 00 00 00 
  return exec(path, argv);
80105ed4:	50                   	push   %eax
80105ed5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105edb:	e8 30 ab ff ff       	call   80100a10 <exec>
80105ee0:	83 c4 10             	add    $0x10,%esp
}
80105ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ee6:	5b                   	pop    %ebx
80105ee7:	5e                   	pop    %esi
80105ee8:	5f                   	pop    %edi
80105ee9:	5d                   	pop    %ebp
80105eea:	c3                   	ret    
80105eeb:	90                   	nop
80105eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ef0 <sys_pipe>:

int
sys_pipe(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	57                   	push   %edi
80105ef4:	56                   	push   %esi
80105ef5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ef6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105ef9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105efc:	6a 08                	push   $0x8
80105efe:	50                   	push   %eax
80105eff:	6a 00                	push   $0x0
80105f01:	e8 ea f3 ff ff       	call   801052f0 <argptr>
80105f06:	83 c4 10             	add    $0x10,%esp
80105f09:	85 c0                	test   %eax,%eax
80105f0b:	0f 88 ae 00 00 00    	js     80105fbf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105f11:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f14:	83 ec 08             	sub    $0x8,%esp
80105f17:	50                   	push   %eax
80105f18:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f1b:	50                   	push   %eax
80105f1c:	e8 1f d3 ff ff       	call   80103240 <pipealloc>
80105f21:	83 c4 10             	add    $0x10,%esp
80105f24:	85 c0                	test   %eax,%eax
80105f26:	0f 88 93 00 00 00    	js     80105fbf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f2c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105f2f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105f31:	e8 6a d9 ff ff       	call   801038a0 <myproc>
80105f36:	eb 10                	jmp    80105f48 <sys_pipe+0x58>
80105f38:	90                   	nop
80105f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105f40:	83 c3 01             	add    $0x1,%ebx
80105f43:	83 fb 10             	cmp    $0x10,%ebx
80105f46:	74 60                	je     80105fa8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105f48:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105f4c:	85 f6                	test   %esi,%esi
80105f4e:	75 f0                	jne    80105f40 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105f50:	8d 73 08             	lea    0x8(%ebx),%esi
80105f53:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105f5a:	e8 41 d9 ff ff       	call   801038a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f5f:	31 d2                	xor    %edx,%edx
80105f61:	eb 0d                	jmp    80105f70 <sys_pipe+0x80>
80105f63:	90                   	nop
80105f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f68:	83 c2 01             	add    $0x1,%edx
80105f6b:	83 fa 10             	cmp    $0x10,%edx
80105f6e:	74 28                	je     80105f98 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105f70:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f74:	85 c9                	test   %ecx,%ecx
80105f76:	75 f0                	jne    80105f68 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105f78:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105f7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f7f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f81:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f84:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f87:	31 c0                	xor    %eax,%eax
}
80105f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f8c:	5b                   	pop    %ebx
80105f8d:	5e                   	pop    %esi
80105f8e:	5f                   	pop    %edi
80105f8f:	5d                   	pop    %ebp
80105f90:	c3                   	ret    
80105f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105f98:	e8 03 d9 ff ff       	call   801038a0 <myproc>
80105f9d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105fa4:	00 
80105fa5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105fa8:	83 ec 0c             	sub    $0xc,%esp
80105fab:	ff 75 e0             	pushl  -0x20(%ebp)
80105fae:	e8 8d ae ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105fb3:	58                   	pop    %eax
80105fb4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fb7:	e8 84 ae ff ff       	call   80100e40 <fileclose>
    return -1;
80105fbc:	83 c4 10             	add    $0x10,%esp
80105fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc4:	eb c3                	jmp    80105f89 <sys_pipe+0x99>
80105fc6:	66 90                	xchg   %ax,%ax
80105fc8:	66 90                	xchg   %ax,%ax
80105fca:	66 90                	xchg   %ax,%ax
80105fcc:	66 90                	xchg   %ax,%ax
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <sys_fork>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void) {
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
    return fork();
}
80105fd3:	5d                   	pop    %ebp
    return fork();
80105fd4:	e9 d7 df ff ff       	jmp    80103fb0 <fork>
80105fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fe0 <sys_exit>:

int sys_exit(void) {
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	83 ec 08             	sub    $0x8,%esp
    // cprintf("Exiting pid %d\n", myproc()->pid);
    exit();
80105fe6:	e8 75 e4 ff ff       	call   80104460 <exit>
    return 0;  // not reached
}
80105feb:	31 c0                	xor    %eax,%eax
80105fed:	c9                   	leave  
80105fee:	c3                   	ret    
80105fef:	90                   	nop

80105ff0 <sys_wait>:

int sys_wait(void) {
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
    return wait();
}
80105ff3:	5d                   	pop    %ebp
    return wait();
80105ff4:	e9 d7 e6 ff ff       	jmp    801046d0 <wait>
80105ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106000 <sys_waitx>:

int sys_waitx(void) {
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	83 ec 1c             	sub    $0x1c,%esp
    int *wtime, *rtime;
    if (argptr(0, (char **)&wtime, sizeof(int)) < 0) {
80106006:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106009:	6a 04                	push   $0x4
8010600b:	50                   	push   %eax
8010600c:	6a 00                	push   $0x0
8010600e:	e8 dd f2 ff ff       	call   801052f0 <argptr>
80106013:	83 c4 10             	add    $0x10,%esp
80106016:	85 c0                	test   %eax,%eax
80106018:	78 2e                	js     80106048 <sys_waitx+0x48>
        return -1;
    }
    if (argptr(1, (char **)&rtime, sizeof(int)) < 0) {
8010601a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010601d:	83 ec 04             	sub    $0x4,%esp
80106020:	6a 04                	push   $0x4
80106022:	50                   	push   %eax
80106023:	6a 01                	push   $0x1
80106025:	e8 c6 f2 ff ff       	call   801052f0 <argptr>
8010602a:	83 c4 10             	add    $0x10,%esp
8010602d:	85 c0                	test   %eax,%eax
8010602f:	78 17                	js     80106048 <sys_waitx+0x48>
        return -1;
    }

    return waitx(wtime, rtime);
80106031:	83 ec 08             	sub    $0x8,%esp
80106034:	ff 75 f4             	pushl  -0xc(%ebp)
80106037:	ff 75 f0             	pushl  -0x10(%ebp)
8010603a:	e8 81 e7 ff ff       	call   801047c0 <waitx>
8010603f:	83 c4 10             	add    $0x10,%esp
}
80106042:	c9                   	leave  
80106043:	c3                   	ret    
80106044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80106048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010604d:	c9                   	leave  
8010604e:	c3                   	ret    
8010604f:	90                   	nop

80106050 <sys_set_priority>:

int sys_set_priority(void) {
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	83 ec 20             	sub    $0x20,%esp
    int pid, priority;
    if (argint(0, &pid) < 0)
80106056:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106059:	50                   	push   %eax
8010605a:	6a 00                	push   $0x0
8010605c:	e8 3f f2 ff ff       	call   801052a0 <argint>
80106061:	83 c4 10             	add    $0x10,%esp
80106064:	85 c0                	test   %eax,%eax
80106066:	78 28                	js     80106090 <sys_set_priority+0x40>
        return -1;
    if (argint(1, &priority) < 0)
80106068:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010606b:	83 ec 08             	sub    $0x8,%esp
8010606e:	50                   	push   %eax
8010606f:	6a 01                	push   $0x1
80106071:	e8 2a f2 ff ff       	call   801052a0 <argint>
80106076:	83 c4 10             	add    $0x10,%esp
80106079:	85 c0                	test   %eax,%eax
8010607b:	78 13                	js     80106090 <sys_set_priority+0x40>
        return -1;

    return set_priority(pid, priority);
8010607d:	83 ec 08             	sub    $0x8,%esp
80106080:	ff 75 f4             	pushl  -0xc(%ebp)
80106083:	ff 75 f0             	pushl  -0x10(%ebp)
80106086:	e8 55 e0 ff ff       	call   801040e0 <set_priority>
8010608b:	83 c4 10             	add    $0x10,%esp
}
8010608e:	c9                   	leave  
8010608f:	c3                   	ret    
        return -1;
80106090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106095:	c9                   	leave  
80106096:	c3                   	ret    
80106097:	89 f6                	mov    %esi,%esi
80106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060a0 <sys_getpinfo>:

int sys_getpinfo(void) {
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	83 ec 20             	sub    $0x20,%esp
    int pid;
    struct proc_stat *p;
    if (argint(1, &pid) < 0) {
801060a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060a9:	50                   	push   %eax
801060aa:	6a 01                	push   $0x1
801060ac:	e8 ef f1 ff ff       	call   801052a0 <argint>
801060b1:	83 c4 10             	add    $0x10,%esp
801060b4:	85 c0                	test   %eax,%eax
801060b6:	78 30                	js     801060e8 <sys_getpinfo+0x48>
        return -1;
    }
    if (argptr(0, (char **)&p, sizeof(struct proc_stat)) < 0) {
801060b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060bb:	83 ec 04             	sub    $0x4,%esp
801060be:	6a 24                	push   $0x24
801060c0:	50                   	push   %eax
801060c1:	6a 00                	push   $0x0
801060c3:	e8 28 f2 ff ff       	call   801052f0 <argptr>
801060c8:	83 c4 10             	add    $0x10,%esp
801060cb:	85 c0                	test   %eax,%eax
801060cd:	78 19                	js     801060e8 <sys_getpinfo+0x48>
        return -1;
    }

    return getpinfo(p, pid);
801060cf:	83 ec 08             	sub    $0x8,%esp
801060d2:	ff 75 f0             	pushl  -0x10(%ebp)
801060d5:	ff 75 f4             	pushl  -0xc(%ebp)
801060d8:	e8 f3 d7 ff ff       	call   801038d0 <getpinfo>
801060dd:	83 c4 10             	add    $0x10,%esp
}
801060e0:	c9                   	leave  
801060e1:	c3                   	ret    
801060e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
801060e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060ed:	c9                   	leave  
801060ee:	c3                   	ret    
801060ef:	90                   	nop

801060f0 <sys_kill>:

int sys_kill(void) {
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	83 ec 20             	sub    $0x20,%esp
    int pid;

    if (argint(0, &pid) < 0)
801060f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060f9:	50                   	push   %eax
801060fa:	6a 00                	push   $0x0
801060fc:	e8 9f f1 ff ff       	call   801052a0 <argint>
80106101:	83 c4 10             	add    $0x10,%esp
80106104:	85 c0                	test   %eax,%eax
80106106:	78 18                	js     80106120 <sys_kill+0x30>
        return -1;
    return kill(pid);
80106108:	83 ec 0c             	sub    $0xc,%esp
8010610b:	ff 75 f4             	pushl  -0xc(%ebp)
8010610e:	e8 3d e8 ff ff       	call   80104950 <kill>
80106113:	83 c4 10             	add    $0x10,%esp
}
80106116:	c9                   	leave  
80106117:	c3                   	ret    
80106118:	90                   	nop
80106119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80106120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106125:	c9                   	leave  
80106126:	c3                   	ret    
80106127:	89 f6                	mov    %esi,%esi
80106129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106130 <sys_getpid>:

int sys_getpid(void) {
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
80106136:	e8 65 d7 ff ff       	call   801038a0 <myproc>
8010613b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010613e:	c9                   	leave  
8010613f:	c3                   	ret    

80106140 <sys_sbrk>:

int sys_sbrk(void) {
80106140:	55                   	push   %ebp
80106141:	89 e5                	mov    %esp,%ebp
80106143:	53                   	push   %ebx
    int addr;
    int n;

    if (argint(0, &n) < 0)
80106144:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sbrk(void) {
80106147:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0)
8010614a:	50                   	push   %eax
8010614b:	6a 00                	push   $0x0
8010614d:	e8 4e f1 ff ff       	call   801052a0 <argint>
80106152:	83 c4 10             	add    $0x10,%esp
80106155:	85 c0                	test   %eax,%eax
80106157:	78 27                	js     80106180 <sys_sbrk+0x40>
        return -1;
    addr = myproc()->sz;
80106159:	e8 42 d7 ff ff       	call   801038a0 <myproc>
    if (growproc(n) < 0)
8010615e:	83 ec 0c             	sub    $0xc,%esp
    addr = myproc()->sz;
80106161:	8b 18                	mov    (%eax),%ebx
    if (growproc(n) < 0)
80106163:	ff 75 f4             	pushl  -0xc(%ebp)
80106166:	e8 75 dd ff ff       	call   80103ee0 <growproc>
8010616b:	83 c4 10             	add    $0x10,%esp
8010616e:	85 c0                	test   %eax,%eax
80106170:	78 0e                	js     80106180 <sys_sbrk+0x40>
        return -1;
    return addr;
}
80106172:	89 d8                	mov    %ebx,%eax
80106174:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106177:	c9                   	leave  
80106178:	c3                   	ret    
80106179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80106180:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106185:	eb eb                	jmp    80106172 <sys_sbrk+0x32>
80106187:	89 f6                	mov    %esi,%esi
80106189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106190 <sys_sleep>:

int sys_sleep(void) {
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
80106193:	53                   	push   %ebx
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
80106194:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sleep(void) {
80106197:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0)
8010619a:	50                   	push   %eax
8010619b:	6a 00                	push   $0x0
8010619d:	e8 fe f0 ff ff       	call   801052a0 <argint>
801061a2:	83 c4 10             	add    $0x10,%esp
801061a5:	85 c0                	test   %eax,%eax
801061a7:	0f 88 8a 00 00 00    	js     80106237 <sys_sleep+0xa7>
        return -1;
    acquire(&tickslock);
801061ad:	83 ec 0c             	sub    $0xc,%esp
801061b0:	68 40 bb 11 80       	push   $0x8011bb40
801061b5:	e8 d6 ec ff ff       	call   80104e90 <acquire>
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
801061ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061bd:	83 c4 10             	add    $0x10,%esp
    ticks0 = ticks;
801061c0:	8b 1d 80 c3 11 80    	mov    0x8011c380,%ebx
    while (ticks - ticks0 < n) {
801061c6:	85 d2                	test   %edx,%edx
801061c8:	75 27                	jne    801061f1 <sys_sleep+0x61>
801061ca:	eb 54                	jmp    80106220 <sys_sleep+0x90>
801061cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
801061d0:	83 ec 08             	sub    $0x8,%esp
801061d3:	68 40 bb 11 80       	push   $0x8011bb40
801061d8:	68 80 c3 11 80       	push   $0x8011c380
801061dd:	e8 2e e4 ff ff       	call   80104610 <sleep>
    while (ticks - ticks0 < n) {
801061e2:	a1 80 c3 11 80       	mov    0x8011c380,%eax
801061e7:	83 c4 10             	add    $0x10,%esp
801061ea:	29 d8                	sub    %ebx,%eax
801061ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801061ef:	73 2f                	jae    80106220 <sys_sleep+0x90>
        if (myproc()->killed) {
801061f1:	e8 aa d6 ff ff       	call   801038a0 <myproc>
801061f6:	8b 40 24             	mov    0x24(%eax),%eax
801061f9:	85 c0                	test   %eax,%eax
801061fb:	74 d3                	je     801061d0 <sys_sleep+0x40>
            release(&tickslock);
801061fd:	83 ec 0c             	sub    $0xc,%esp
80106200:	68 40 bb 11 80       	push   $0x8011bb40
80106205:	e8 46 ed ff ff       	call   80104f50 <release>
            return -1;
8010620a:	83 c4 10             	add    $0x10,%esp
8010620d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    release(&tickslock);
    return 0;
}
80106212:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106215:	c9                   	leave  
80106216:	c3                   	ret    
80106217:	89 f6                	mov    %esi,%esi
80106219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&tickslock);
80106220:	83 ec 0c             	sub    $0xc,%esp
80106223:	68 40 bb 11 80       	push   $0x8011bb40
80106228:	e8 23 ed ff ff       	call   80104f50 <release>
    return 0;
8010622d:	83 c4 10             	add    $0x10,%esp
80106230:	31 c0                	xor    %eax,%eax
}
80106232:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106235:	c9                   	leave  
80106236:	c3                   	ret    
        return -1;
80106237:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010623c:	eb f4                	jmp    80106232 <sys_sleep+0xa2>
8010623e:	66 90                	xchg   %ax,%ax

80106240 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void) {
80106240:	55                   	push   %ebp
80106241:	89 e5                	mov    %esp,%ebp
80106243:	53                   	push   %ebx
80106244:	83 ec 10             	sub    $0x10,%esp
    uint xticks;

    acquire(&tickslock);
80106247:	68 40 bb 11 80       	push   $0x8011bb40
8010624c:	e8 3f ec ff ff       	call   80104e90 <acquire>
    xticks = ticks;
80106251:	8b 1d 80 c3 11 80    	mov    0x8011c380,%ebx
    release(&tickslock);
80106257:	c7 04 24 40 bb 11 80 	movl   $0x8011bb40,(%esp)
8010625e:	e8 ed ec ff ff       	call   80104f50 <release>
    return xticks;
}
80106263:	89 d8                	mov    %ebx,%eax
80106265:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106268:	c9                   	leave  
80106269:	c3                   	ret    

8010626a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010626a:	1e                   	push   %ds
  pushl %es
8010626b:	06                   	push   %es
  pushl %fs
8010626c:	0f a0                	push   %fs
  pushl %gs
8010626e:	0f a8                	push   %gs
  pushal
80106270:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106271:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106275:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106277:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106279:	54                   	push   %esp
  call trap
8010627a:	e8 c1 00 00 00       	call   80106340 <trap>
  addl $4, %esp
8010627f:	83 c4 04             	add    $0x4,%esp

80106282 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106282:	61                   	popa   
  popl %gs
80106283:	0f a9                	pop    %gs
  popl %fs
80106285:	0f a1                	pop    %fs
  popl %es
80106287:	07                   	pop    %es
  popl %ds
80106288:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106289:	83 c4 08             	add    $0x8,%esp
  iret
8010628c:	cf                   	iret   
8010628d:	66 90                	xchg   %ax,%ax
8010628f:	90                   	nop

80106290 <tvinit>:
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void) {
80106290:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++)
80106291:	31 c0                	xor    %eax,%eax
void tvinit(void) {
80106293:	89 e5                	mov    %esp,%ebp
80106295:	83 ec 08             	sub    $0x8,%esp
80106298:	90                   	nop
80106299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
801062a0:	8b 14 85 7c b0 10 80 	mov    -0x7fef4f84(,%eax,4),%edx
801062a7:	c7 04 c5 82 bb 11 80 	movl   $0x8e000008,-0x7fee447e(,%eax,8)
801062ae:	08 00 00 8e 
801062b2:	66 89 14 c5 80 bb 11 	mov    %dx,-0x7fee4480(,%eax,8)
801062b9:	80 
801062ba:	c1 ea 10             	shr    $0x10,%edx
801062bd:	66 89 14 c5 86 bb 11 	mov    %dx,-0x7fee447a(,%eax,8)
801062c4:	80 
    for (i = 0; i < 256; i++)
801062c5:	83 c0 01             	add    $0x1,%eax
801062c8:	3d 00 01 00 00       	cmp    $0x100,%eax
801062cd:	75 d1                	jne    801062a0 <tvinit+0x10>
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801062cf:	a1 7c b1 10 80       	mov    0x8010b17c,%eax

    initlock(&tickslock, "time");
801062d4:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801062d7:	c7 05 82 bd 11 80 08 	movl   $0xef000008,0x8011bd82
801062de:	00 00 ef 
    initlock(&tickslock, "time");
801062e1:	68 45 89 10 80       	push   $0x80108945
801062e6:	68 40 bb 11 80       	push   $0x8011bb40
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801062eb:	66 a3 80 bd 11 80    	mov    %ax,0x8011bd80
801062f1:	c1 e8 10             	shr    $0x10,%eax
801062f4:	66 a3 86 bd 11 80    	mov    %ax,0x8011bd86
    initlock(&tickslock, "time");
801062fa:	e8 51 ea ff ff       	call   80104d50 <initlock>
}
801062ff:	83 c4 10             	add    $0x10,%esp
80106302:	c9                   	leave  
80106303:	c3                   	ret    
80106304:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010630a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106310 <idtinit>:

void idtinit(void) {
80106310:	55                   	push   %ebp
  pd[0] = size-1;
80106311:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106316:	89 e5                	mov    %esp,%ebp
80106318:	83 ec 10             	sub    $0x10,%esp
8010631b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010631f:	b8 80 bb 11 80       	mov    $0x8011bb80,%eax
80106324:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106328:	c1 e8 10             	shr    $0x10,%eax
8010632b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010632f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106332:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80106335:	c9                   	leave  
80106336:	c3                   	ret    
80106337:	89 f6                	mov    %esi,%esi
80106339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106340 <trap>:

// PAGEBREAK: 41
void trap(struct trapframe *tf) {
80106340:	55                   	push   %ebp
80106341:	89 e5                	mov    %esp,%ebp
80106343:	57                   	push   %edi
80106344:	56                   	push   %esi
80106345:	53                   	push   %ebx
80106346:	83 ec 1c             	sub    $0x1c,%esp
80106349:	8b 7d 08             	mov    0x8(%ebp),%edi
    if (tf->trapno == T_SYSCALL) {
8010634c:	8b 47 30             	mov    0x30(%edi),%eax
8010634f:	83 f8 40             	cmp    $0x40,%eax
80106352:	0f 84 f0 00 00 00    	je     80106448 <trap+0x108>
        if (myproc()->killed)
            exit();
        return;
    }

    switch (tf->trapno) {
80106358:	83 e8 20             	sub    $0x20,%eax
8010635b:	83 f8 1f             	cmp    $0x1f,%eax
8010635e:	77 10                	ja     80106370 <trap+0x30>
80106360:	ff 24 85 ec 89 10 80 	jmp    *-0x7fef7614(,%eax,4)
80106367:	89 f6                	mov    %esi,%esi
80106369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            lapiceoi();
            break;

        // PAGEBREAK: 13
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
80106370:	e8 2b d5 ff ff       	call   801038a0 <myproc>
80106375:	85 c0                	test   %eax,%eax
80106377:	8b 5f 38             	mov    0x38(%edi),%ebx
8010637a:	0f 84 7c 07 00 00    	je     80106afc <trap+0x7bc>
80106380:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106384:	0f 84 72 07 00 00    	je     80106afc <trap+0x7bc>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010638a:	0f 20 d1             	mov    %cr2,%ecx
8010638d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf(
80106390:	e8 eb d4 ff ff       	call   80103880 <cpuid>
80106395:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106398:	8b 47 34             	mov    0x34(%edi),%eax
8010639b:	8b 77 30             	mov    0x30(%edi),%esi
8010639e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                "pid %d %s: trap %d err %d on cpu %d "
                "eip 0x%x addr 0x%x--kill proc\n",
                myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(),
801063a1:	e8 fa d4 ff ff       	call   801038a0 <myproc>
801063a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801063a9:	e8 f2 d4 ff ff       	call   801038a0 <myproc>
            cprintf(
801063ae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801063b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801063b4:	51                   	push   %ecx
801063b5:	53                   	push   %ebx
801063b6:	52                   	push   %edx
                myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(),
801063b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
            cprintf(
801063ba:	ff 75 e4             	pushl  -0x1c(%ebp)
801063bd:	56                   	push   %esi
                myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(),
801063be:	83 c2 6c             	add    $0x6c,%edx
            cprintf(
801063c1:	52                   	push   %edx
801063c2:	ff 70 10             	pushl  0x10(%eax)
801063c5:	68 a8 89 10 80       	push   $0x801089a8
801063ca:	e8 91 a2 ff ff       	call   80100660 <cprintf>
                tf->eip, rcr2());
            myproc()->killed = 1;
801063cf:	83 c4 20             	add    $0x20,%esp
801063d2:	e8 c9 d4 ff ff       	call   801038a0 <myproc>
801063d7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801063de:	e8 bd d4 ff ff       	call   801038a0 <myproc>
801063e3:	85 c0                	test   %eax,%eax
801063e5:	74 1d                	je     80106404 <trap+0xc4>
801063e7:	e8 b4 d4 ff ff       	call   801038a0 <myproc>
801063ec:	8b 48 24             	mov    0x24(%eax),%ecx
801063ef:	85 c9                	test   %ecx,%ecx
801063f1:	74 11                	je     80106404 <trap+0xc4>
801063f3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801063f7:	83 e0 03             	and    $0x3,%eax
801063fa:	66 83 f8 03          	cmp    $0x3,%ax
801063fe:	0f 84 dc 02 00 00    	je     801066e0 <trap+0x3a0>
        }
    }
#endif

#ifdef MLFQ
    if (myproc() && myproc()->state == RUNNING &&
80106404:	e8 97 d4 ff ff       	call   801038a0 <myproc>
80106409:	85 c0                	test   %eax,%eax
8010640b:	74 0b                	je     80106418 <trap+0xd8>
8010640d:	e8 8e d4 ff ff       	call   801038a0 <myproc>
80106412:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106416:	74 68                	je     80106480 <trap+0x140>
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();
#endif

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106418:	e8 83 d4 ff ff       	call   801038a0 <myproc>
8010641d:	85 c0                	test   %eax,%eax
8010641f:	74 19                	je     8010643a <trap+0xfa>
80106421:	e8 7a d4 ff ff       	call   801038a0 <myproc>
80106426:	8b 40 24             	mov    0x24(%eax),%eax
80106429:	85 c0                	test   %eax,%eax
8010642b:	74 0d                	je     8010643a <trap+0xfa>
8010642d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106431:	83 e0 03             	and    $0x3,%eax
80106434:	66 83 f8 03          	cmp    $0x3,%ax
80106438:	74 37                	je     80106471 <trap+0x131>
        exit();
}
8010643a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010643d:	5b                   	pop    %ebx
8010643e:	5e                   	pop    %esi
8010643f:	5f                   	pop    %edi
80106440:	5d                   	pop    %ebp
80106441:	c3                   	ret    
80106442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (myproc()->killed)
80106448:	e8 53 d4 ff ff       	call   801038a0 <myproc>
8010644d:	8b 70 24             	mov    0x24(%eax),%esi
80106450:	85 f6                	test   %esi,%esi
80106452:	0f 85 78 02 00 00    	jne    801066d0 <trap+0x390>
        myproc()->tf = tf;
80106458:	e8 43 d4 ff ff       	call   801038a0 <myproc>
8010645d:	89 78 18             	mov    %edi,0x18(%eax)
        syscall();
80106460:	e8 2b ef ff ff       	call   80105390 <syscall>
        if (myproc()->killed)
80106465:	e8 36 d4 ff ff       	call   801038a0 <myproc>
8010646a:	8b 58 24             	mov    0x24(%eax),%ebx
8010646d:	85 db                	test   %ebx,%ebx
8010646f:	74 c9                	je     8010643a <trap+0xfa>
}
80106471:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106474:	5b                   	pop    %ebx
80106475:	5e                   	pop    %esi
80106476:	5f                   	pop    %edi
80106477:	5d                   	pop    %ebp
            exit();
80106478:	e9 e3 df ff ff       	jmp    80104460 <exit>
8010647d:	8d 76 00             	lea    0x0(%esi),%esi
    if (myproc() && myproc()->state == RUNNING &&
80106480:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106484:	75 92                	jne    80106418 <trap+0xd8>
        int no = myproc()->qno;
80106486:	e8 15 d4 ff ff       	call   801038a0 <myproc>
8010648b:	8b 98 90 00 00 00    	mov    0x90(%eax),%ebx
        if (myproc()->stat.ticks[no] != 0) {
80106491:	e8 0a d4 ff ff       	call   801038a0 <myproc>
80106496:	8b 94 98 a8 00 00 00 	mov    0xa8(%eax,%ebx,4),%edx
8010649d:	85 d2                	test   %edx,%edx
8010649f:	0f 84 73 ff ff ff    	je     80106418 <trap+0xd8>
            if (no == 0) {
801064a5:	85 db                	test   %ebx,%ebx
801064a7:	0f 84 e4 02 00 00    	je     80106791 <trap+0x451>
            } else if (no == 1 && myproc()->stat.ticks[1] % 2 == 0) {
801064ad:	83 fb 01             	cmp    $0x1,%ebx
801064b0:	0f 84 bd 03 00 00    	je     80106873 <trap+0x533>
            } else if (no == 2 && myproc()->stat.ticks[2] % 4 == 0) {
801064b6:	83 fb 02             	cmp    $0x2,%ebx
801064b9:	0f 84 5c 04 00 00    	je     8010691b <trap+0x5db>
            } else if (no == 3 && myproc()->stat.ticks[3] % 8 == 0) {
801064bf:	83 fb 03             	cmp    $0x3,%ebx
801064c2:	0f 84 fb 04 00 00    	je     801069c3 <trap+0x683>
            } else if (no == 4 && myproc()->stat.ticks[4] % 16 == 0) {
801064c8:	83 fb 04             	cmp    $0x4,%ebx
801064cb:	0f 84 a7 05 00 00    	je     80106a78 <trap+0x738>
                for (int j = 0; j < cnt[0]; j++) {
801064d1:	8b 0d 1c b6 10 80    	mov    0x8010b61c,%ecx
801064d7:	85 c9                	test   %ecx,%ecx
801064d9:	7e 2d                	jle    80106508 <trap+0x1c8>
                    if (q0[j]->state == RUNNABLE) {
801064db:	a1 c0 6c 11 80       	mov    0x80116cc0,%eax
801064e0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801064e4:	0f 84 4b 03 00 00    	je     80106835 <trap+0x4f5>
                for (int j = 0; j < cnt[0]; j++) {
801064ea:	31 c0                	xor    %eax,%eax
801064ec:	eb 13                	jmp    80106501 <trap+0x1c1>
801064ee:	66 90                	xchg   %ax,%ax
                    if (q0[j]->state == RUNNABLE) {
801064f0:	8b 14 85 c0 6c 11 80 	mov    -0x7fee9340(,%eax,4),%edx
801064f7:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801064fb:	0f 84 34 03 00 00    	je     80106835 <trap+0x4f5>
                for (int j = 0; j < cnt[0]; j++) {
80106501:	83 c0 01             	add    $0x1,%eax
80106504:	39 c8                	cmp    %ecx,%eax
80106506:	75 e8                	jne    801064f0 <trap+0x1b0>
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
80106508:	31 c9                	xor    %ecx,%ecx
                for (int j = 0; j < cnt[1]; j++) {
8010650a:	8b 35 20 b6 10 80    	mov    0x8010b620,%esi
80106510:	85 f6                	test   %esi,%esi
80106512:	7e 34                	jle    80106548 <trap+0x208>
                    if (q1[j]->state == RUNNABLE) {
80106514:	a1 20 5d 11 80       	mov    0x80115d20,%eax
80106519:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010651d:	0f 84 38 03 00 00    	je     8010685b <trap+0x51b>
                for (int j = 0; j < cnt[1]; j++) {
80106523:	31 c0                	xor    %eax,%eax
80106525:	eb 1a                	jmp    80106541 <trap+0x201>
80106527:	89 f6                	mov    %esi,%esi
80106529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    if (q1[j]->state == RUNNABLE) {
80106530:	8b 14 85 20 5d 11 80 	mov    -0x7feea2e0(,%eax,4),%edx
80106537:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
8010653b:	0f 84 1a 03 00 00    	je     8010685b <trap+0x51b>
                for (int j = 0; j < cnt[1]; j++) {
80106541:	83 c0 01             	add    $0x1,%eax
80106544:	39 c6                	cmp    %eax,%esi
80106546:	75 e8                	jne    80106530 <trap+0x1f0>
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
80106548:	31 d2                	xor    %edx,%edx
                for (int j = 0; j < cnt[2]; j++) {
8010654a:	8b 35 24 b6 10 80    	mov    0x8010b624,%esi
80106550:	85 f6                	test   %esi,%esi
80106552:	0f 8e 91 05 00 00    	jle    80106ae9 <trap+0x7a9>
                    if (q2[j]->state == RUNNABLE) {
80106558:	a1 c0 3d 11 80       	mov    0x80113dc0,%eax
8010655d:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80106561:	0f 84 e8 02 00 00    	je     8010684f <trap+0x50f>
                for (int j = 0; j < cnt[2]; j++) {
80106567:	31 c0                	xor    %eax,%eax
80106569:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010656c:	eb 13                	jmp    80106581 <trap+0x241>
8010656e:	66 90                	xchg   %ax,%ax
                    if (q2[j]->state == RUNNABLE) {
80106570:	8b 14 85 c0 3d 11 80 	mov    -0x7feec240(,%eax,4),%edx
80106577:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
8010657b:	0f 84 cb 02 00 00    	je     8010684c <trap+0x50c>
                for (int j = 0; j < cnt[2]; j++) {
80106581:	83 c0 01             	add    $0x1,%eax
80106584:	39 c6                	cmp    %eax,%esi
80106586:	75 e8                	jne    80106570 <trap+0x230>
80106588:	8b 55 e4             	mov    -0x1c(%ebp),%edx
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
8010658b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
                for (int j = 0; j < cnt[3]; j++) {
80106592:	8b 35 28 b6 10 80    	mov    0x8010b628,%esi
80106598:	85 f6                	test   %esi,%esi
8010659a:	0f 8e 55 05 00 00    	jle    80106af5 <trap+0x7b5>
                    if (q3[j]->state == RUNNABLE) {
801065a0:	a1 80 4d 11 80       	mov    0x80114d80,%eax
801065a5:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801065a9:	0f 84 93 02 00 00    	je     80106842 <trap+0x502>
                for (int j = 0; j < cnt[3]; j++) {
801065af:	31 c0                	xor    %eax,%eax
801065b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801065b4:	eb 1b                	jmp    801065d1 <trap+0x291>
801065b6:	8d 76 00             	lea    0x0(%esi),%esi
801065b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    if (q3[j]->state == RUNNABLE) {
801065c0:	8b 14 85 80 4d 11 80 	mov    -0x7feeb280(,%eax,4),%edx
801065c7:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801065cb:	0f 84 6e 02 00 00    	je     8010683f <trap+0x4ff>
                for (int j = 0; j < cnt[3]; j++) {
801065d1:	83 c0 01             	add    $0x1,%eax
801065d4:	39 f0                	cmp    %esi,%eax
801065d6:	75 e8                	jne    801065c0 <trap+0x280>
801065d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
801065db:	31 c0                	xor    %eax,%eax
                if (no == 1) {
801065dd:	83 fb 01             	cmp    $0x1,%ebx
801065e0:	0f 84 7f 02 00 00    	je     80106865 <trap+0x525>
                } else if (no == 2) {
801065e6:	83 fb 02             	cmp    $0x2,%ebx
801065e9:	0f 84 7c 04 00 00    	je     80106a6b <trap+0x72b>
                } else if (no == 3) {
801065ef:	83 fb 03             	cmp    $0x3,%ebx
801065f2:	0f 84 de 04 00 00    	je     80106ad6 <trap+0x796>
                } else if (no == 4) {
801065f8:	83 fb 04             	cmp    $0x4,%ebx
801065fb:	0f 85 17 fe ff ff    	jne    80106418 <trap+0xd8>
                    if (flag0 == 1 || flag1 == 1 || flag2 == 1 || flag3 == 1) {
80106601:	09 d1                	or     %edx,%ecx
80106603:	75 0b                	jne    80106610 <trap+0x2d0>
80106605:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106608:	09 c1                	or     %eax,%ecx
8010660a:	0f 84 08 fe ff ff    	je     80106418 <trap+0xd8>
                yield();
80106610:	e8 8b df ff ff       	call   801045a0 <yield>
80106615:	e9 fe fd ff ff       	jmp    80106418 <trap+0xd8>
8010661a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if (cpuid() == 0) {
80106620:	e8 5b d2 ff ff       	call   80103880 <cpuid>
80106625:	85 c0                	test   %eax,%eax
80106627:	0f 84 c3 00 00 00    	je     801066f0 <trap+0x3b0>
            lapiceoi();
8010662d:	e8 1e c1 ff ff       	call   80102750 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106632:	e8 69 d2 ff ff       	call   801038a0 <myproc>
80106637:	85 c0                	test   %eax,%eax
80106639:	0f 85 a8 fd ff ff    	jne    801063e7 <trap+0xa7>
8010663f:	e9 c0 fd ff ff       	jmp    80106404 <trap+0xc4>
80106644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kbdintr();
80106648:	e8 c3 bf ff ff       	call   80102610 <kbdintr>
            lapiceoi();
8010664d:	e8 fe c0 ff ff       	call   80102750 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106652:	e8 49 d2 ff ff       	call   801038a0 <myproc>
80106657:	85 c0                	test   %eax,%eax
80106659:	0f 85 88 fd ff ff    	jne    801063e7 <trap+0xa7>
8010665f:	e9 a0 fd ff ff       	jmp    80106404 <trap+0xc4>
80106664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            uartintr();
80106668:	e8 33 06 00 00       	call   80106ca0 <uartintr>
            lapiceoi();
8010666d:	e8 de c0 ff ff       	call   80102750 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106672:	e8 29 d2 ff ff       	call   801038a0 <myproc>
80106677:	85 c0                	test   %eax,%eax
80106679:	0f 85 68 fd ff ff    	jne    801063e7 <trap+0xa7>
8010667f:	e9 80 fd ff ff       	jmp    80106404 <trap+0xc4>
80106684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            cprintf("cpu%d: spurious interrupt at %x:%x\n", cpuid(), tf->cs,
80106688:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010668c:	8b 77 38             	mov    0x38(%edi),%esi
8010668f:	e8 ec d1 ff ff       	call   80103880 <cpuid>
80106694:	56                   	push   %esi
80106695:	53                   	push   %ebx
80106696:	50                   	push   %eax
80106697:	68 50 89 10 80       	push   $0x80108950
8010669c:	e8 bf 9f ff ff       	call   80100660 <cprintf>
            lapiceoi();
801066a1:	e8 aa c0 ff ff       	call   80102750 <lapiceoi>
            break;
801066a6:	83 c4 10             	add    $0x10,%esp
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801066a9:	e8 f2 d1 ff ff       	call   801038a0 <myproc>
801066ae:	85 c0                	test   %eax,%eax
801066b0:	0f 85 31 fd ff ff    	jne    801063e7 <trap+0xa7>
801066b6:	e9 49 fd ff ff       	jmp    80106404 <trap+0xc4>
801066bb:	90                   	nop
801066bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            ideintr();
801066c0:	e8 bb b9 ff ff       	call   80102080 <ideintr>
801066c5:	e9 63 ff ff ff       	jmp    8010662d <trap+0x2ed>
801066ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            exit();
801066d0:	e8 8b dd ff ff       	call   80104460 <exit>
801066d5:	e9 7e fd ff ff       	jmp    80106458 <trap+0x118>
801066da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        exit();
801066e0:	e8 7b dd ff ff       	call   80104460 <exit>
801066e5:	e9 1a fd ff ff       	jmp    80106404 <trap+0xc4>
801066ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                acquire(&tickslock);
801066f0:	83 ec 0c             	sub    $0xc,%esp
801066f3:	68 40 bb 11 80       	push   $0x8011bb40
801066f8:	e8 93 e7 ff ff       	call   80104e90 <acquire>
                wakeup(&ticks);
801066fd:	c7 04 24 80 c3 11 80 	movl   $0x8011c380,(%esp)
                ticks++;
80106704:	83 05 80 c3 11 80 01 	addl   $0x1,0x8011c380
                wakeup(&ticks);
8010670b:	e8 e0 e1 ff ff       	call   801048f0 <wakeup>
                release(&tickslock);
80106710:	c7 04 24 40 bb 11 80 	movl   $0x8011bb40,(%esp)
80106717:	e8 34 e8 ff ff       	call   80104f50 <release>
                aging();
8010671c:	e8 7f d2 ff ff       	call   801039a0 <aging>
                if (myproc()) {
80106721:	e8 7a d1 ff ff       	call   801038a0 <myproc>
80106726:	83 c4 10             	add    $0x10,%esp
80106729:	85 c0                	test   %eax,%eax
8010672b:	0f 84 fc fe ff ff    	je     8010662d <trap+0x2ed>
                    if (myproc()->state == RUNNING) {
80106731:	e8 6a d1 ff ff       	call   801038a0 <myproc>
80106736:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010673a:	74 20                	je     8010675c <trap+0x41c>
                    } else if (myproc()->state == SLEEPING) {
8010673c:	e8 5f d1 ff ff       	call   801038a0 <myproc>
80106741:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80106745:	0f 85 e2 fe ff ff    	jne    8010662d <trap+0x2ed>
                        myproc()->iotime++;
8010674b:	e8 50 d1 ff ff       	call   801038a0 <myproc>
80106750:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
80106757:	e9 d1 fe ff ff       	jmp    8010662d <trap+0x2ed>
                        myproc()->rtime++;
8010675c:	e8 3f d1 ff ff       	call   801038a0 <myproc>
80106761:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
                        myproc()->stat.runtime++;
80106768:	e8 33 d1 ff ff       	call   801038a0 <myproc>
8010676d:	83 80 9c 00 00 00 01 	addl   $0x1,0x9c(%eax)
                        int no = myproc()->qno;
80106774:	e8 27 d1 ff ff       	call   801038a0 <myproc>
80106779:	8b 98 90 00 00 00    	mov    0x90(%eax),%ebx
                        myproc()->stat.ticks[no]++;
8010677f:	e8 1c d1 ff ff       	call   801038a0 <myproc>
80106784:	83 84 98 a8 00 00 00 	addl   $0x1,0xa8(%eax,%ebx,4)
8010678b:	01 
8010678c:	e9 9c fe ff ff       	jmp    8010662d <trap+0x2ed>
                myproc()->qno = 1;
80106791:	e8 0a d1 ff ff       	call   801038a0 <myproc>
80106796:	c7 80 90 00 00 00 01 	movl   $0x1,0x90(%eax)
8010679d:	00 00 00 
                cnt[0]--;
801067a0:	8b 15 1c b6 10 80    	mov    0x8010b61c,%edx
                for (int i = beg0; i < cnt[0]; i++) {
801067a6:	a1 54 b6 10 80       	mov    0x8010b654,%eax
                cnt[0]--;
801067ab:	8d 4a ff             	lea    -0x1(%edx),%ecx
                for (int i = beg0; i < cnt[0]; i++) {
801067ae:	39 c1                	cmp    %eax,%ecx
                cnt[0]--;
801067b0:	89 0d 1c b6 10 80    	mov    %ecx,0x8010b61c
                for (int i = beg0; i < cnt[0]; i++) {
801067b6:	7e 25                	jle    801067dd <trap+0x49d>
801067b8:	8d 04 85 c0 6c 11 80 	lea    -0x7fee9340(,%eax,4),%eax
801067bf:	8d 0c 95 bc 6c 11 80 	lea    -0x7fee9344(,%edx,4),%ecx
801067c6:	8d 76 00             	lea    0x0(%esi),%esi
801067c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    q0[i] = q0[i + 1];
801067d0:	8b 50 04             	mov    0x4(%eax),%edx
801067d3:	83 c0 04             	add    $0x4,%eax
801067d6:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = beg0; i < cnt[0]; i++) {
801067d9:	39 c8                	cmp    %ecx,%eax
801067db:	75 f3                	jne    801067d0 <trap+0x490>
                for (int i = 0; i < cnt[1]; i++) {
801067dd:	8b 35 20 b6 10 80    	mov    0x8010b620,%esi
801067e3:	85 f6                	test   %esi,%esi
801067e5:	7e 2e                	jle    80106815 <trap+0x4d5>
801067e7:	89 f6                	mov    %esi,%esi
801067e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    if (q1[i]->pid == myproc()->pid) {
801067f0:	8b 04 9d 20 5d 11 80 	mov    -0x7feea2e0(,%ebx,4),%eax
801067f7:	8b 70 10             	mov    0x10(%eax),%esi
801067fa:	e8 a1 d0 ff ff       	call   801038a0 <myproc>
801067ff:	3b 70 10             	cmp    0x10(%eax),%esi
80106802:	0f 84 08 fe ff ff    	je     80106610 <trap+0x2d0>
                for (int i = 0; i < cnt[1]; i++) {
80106808:	8b 35 20 b6 10 80    	mov    0x8010b620,%esi
8010680e:	83 c3 01             	add    $0x1,%ebx
80106811:	39 de                	cmp    %ebx,%esi
80106813:	7f db                	jg     801067f0 <trap+0x4b0>
                    cnt[1]++;
80106815:	8d 46 01             	lea    0x1(%esi),%eax
80106818:	a3 20 b6 10 80       	mov    %eax,0x8010b620
                    q1[cnt[1] - 1] = myproc();
8010681d:	e8 7e d0 ff ff       	call   801038a0 <myproc>
                    end1 += 1;
80106822:	83 05 3c b6 10 80 01 	addl   $0x1,0x8010b63c
                    q1[cnt[1] - 1] = myproc();
80106829:	89 04 b5 20 5d 11 80 	mov    %eax,-0x7feea2e0(,%esi,4)
80106830:	e9 db fd ff ff       	jmp    80106610 <trap+0x2d0>
                        flag0 = 1;
80106835:	b9 01 00 00 00       	mov    $0x1,%ecx
8010683a:	e9 cb fc ff ff       	jmp    8010650a <trap+0x1ca>
8010683f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
                        flag3 = 1;
80106842:	b8 01 00 00 00       	mov    $0x1,%eax
80106847:	e9 91 fd ff ff       	jmp    801065dd <trap+0x29d>
8010684c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
                        flag2 = 1;
8010684f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
80106856:	e9 37 fd ff ff       	jmp    80106592 <trap+0x252>
                        flag1 = 1;
8010685b:	ba 01 00 00 00       	mov    $0x1,%edx
80106860:	e9 e5 fc ff ff       	jmp    8010654a <trap+0x20a>
                    if (flag0 == 1) {
80106865:	83 f9 01             	cmp    $0x1,%ecx
80106868:	0f 85 aa fb ff ff    	jne    80106418 <trap+0xd8>
8010686e:	e9 9d fd ff ff       	jmp    80106610 <trap+0x2d0>
            } else if (no == 1 && myproc()->stat.ticks[1] % 2 == 0) {
80106873:	e8 28 d0 ff ff       	call   801038a0 <myproc>
80106878:	f6 80 ac 00 00 00 01 	testb  $0x1,0xac(%eax)
8010687f:	0f 85 4c fc ff ff    	jne    801064d1 <trap+0x191>
                myproc()->qno = 2;
80106885:	e8 16 d0 ff ff       	call   801038a0 <myproc>
8010688a:	c7 80 90 00 00 00 02 	movl   $0x2,0x90(%eax)
80106891:	00 00 00 
                cnt[1]--;
80106894:	8b 15 20 b6 10 80    	mov    0x8010b620,%edx
                for (int i = beg1; i < cnt[1]; i++) {
8010689a:	a1 50 b6 10 80       	mov    0x8010b650,%eax
                cnt[1]--;
8010689f:	8d 4a ff             	lea    -0x1(%edx),%ecx
                for (int i = beg1; i < cnt[1]; i++) {
801068a2:	39 c1                	cmp    %eax,%ecx
                cnt[1]--;
801068a4:	89 0d 20 b6 10 80    	mov    %ecx,0x8010b620
                for (int i = beg1; i < cnt[1]; i++) {
801068aa:	7e 1b                	jle    801068c7 <trap+0x587>
801068ac:	8d 04 85 20 5d 11 80 	lea    -0x7feea2e0(,%eax,4),%eax
801068b3:	8d 0c 95 1c 5d 11 80 	lea    -0x7feea2e4(,%edx,4),%ecx
                    q1[i] = q1[i + 1];
801068ba:	8b 50 04             	mov    0x4(%eax),%edx
801068bd:	83 c0 04             	add    $0x4,%eax
801068c0:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = beg1; i < cnt[1]; i++) {
801068c3:	39 c1                	cmp    %eax,%ecx
801068c5:	75 f3                	jne    801068ba <trap+0x57a>
                for (int i = 0; i < cnt[2]; i++) {
801068c7:	83 3d 24 b6 10 80 00 	cmpl   $0x0,0x8010b624
801068ce:	7e 25                	jle    801068f5 <trap+0x5b5>
801068d0:	31 db                	xor    %ebx,%ebx
                    if (q2[i]->pid == myproc()->pid) {
801068d2:	8b 04 9d c0 3d 11 80 	mov    -0x7feec240(,%ebx,4),%eax
801068d9:	8b 70 10             	mov    0x10(%eax),%esi
801068dc:	e8 bf cf ff ff       	call   801038a0 <myproc>
801068e1:	3b 70 10             	cmp    0x10(%eax),%esi
801068e4:	0f 84 26 fd ff ff    	je     80106610 <trap+0x2d0>
                for (int i = 0; i < cnt[2]; i++) {
801068ea:	83 c3 01             	add    $0x1,%ebx
801068ed:	39 1d 24 b6 10 80    	cmp    %ebx,0x8010b624
801068f3:	7f dd                	jg     801068d2 <trap+0x592>
                    cnt[2]++;
801068f5:	8b 1d 24 b6 10 80    	mov    0x8010b624,%ebx
801068fb:	8d 43 01             	lea    0x1(%ebx),%eax
801068fe:	a3 24 b6 10 80       	mov    %eax,0x8010b624
                    q2[cnt[2] - 1] = myproc();
80106903:	e8 98 cf ff ff       	call   801038a0 <myproc>
                    end2 += 1;
80106908:	83 05 38 b6 10 80 01 	addl   $0x1,0x8010b638
                    q2[cnt[2] - 1] = myproc();
8010690f:	89 04 9d c0 3d 11 80 	mov    %eax,-0x7feec240(,%ebx,4)
80106916:	e9 f5 fc ff ff       	jmp    80106610 <trap+0x2d0>
            } else if (no == 2 && myproc()->stat.ticks[2] % 4 == 0) {
8010691b:	e8 80 cf ff ff       	call   801038a0 <myproc>
80106920:	f6 80 b0 00 00 00 03 	testb  $0x3,0xb0(%eax)
80106927:	0f 85 a4 fb ff ff    	jne    801064d1 <trap+0x191>
                myproc()->qno = 3;
8010692d:	e8 6e cf ff ff       	call   801038a0 <myproc>
80106932:	c7 80 90 00 00 00 03 	movl   $0x3,0x90(%eax)
80106939:	00 00 00 
                cnt[2]--;
8010693c:	8b 15 24 b6 10 80    	mov    0x8010b624,%edx
                for (int i = beg2; i < cnt[2]; i++) {
80106942:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
                cnt[2]--;
80106947:	8d 4a ff             	lea    -0x1(%edx),%ecx
                for (int i = beg2; i < cnt[2]; i++) {
8010694a:	39 c1                	cmp    %eax,%ecx
                cnt[2]--;
8010694c:	89 0d 24 b6 10 80    	mov    %ecx,0x8010b624
                for (int i = beg2; i < cnt[2]; i++) {
80106952:	7e 1b                	jle    8010696f <trap+0x62f>
80106954:	8d 04 85 c0 3d 11 80 	lea    -0x7feec240(,%eax,4),%eax
8010695b:	8d 0c 95 bc 3d 11 80 	lea    -0x7feec244(,%edx,4),%ecx
                    q2[i] = q2[i + 1];
80106962:	8b 50 04             	mov    0x4(%eax),%edx
80106965:	83 c0 04             	add    $0x4,%eax
80106968:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = beg2; i < cnt[2]; i++) {
8010696b:	39 c1                	cmp    %eax,%ecx
8010696d:	75 f3                	jne    80106962 <trap+0x622>
                for (int i = 0; i < cnt[3]; i++) {
8010696f:	83 3d 28 b6 10 80 00 	cmpl   $0x0,0x8010b628
80106976:	7e 25                	jle    8010699d <trap+0x65d>
80106978:	31 db                	xor    %ebx,%ebx
                    if (q3[i]->pid == myproc()->pid) {
8010697a:	8b 04 9d 80 4d 11 80 	mov    -0x7feeb280(,%ebx,4),%eax
80106981:	8b 70 10             	mov    0x10(%eax),%esi
80106984:	e8 17 cf ff ff       	call   801038a0 <myproc>
80106989:	3b 70 10             	cmp    0x10(%eax),%esi
8010698c:	0f 84 7e fc ff ff    	je     80106610 <trap+0x2d0>
                for (int i = 0; i < cnt[3]; i++) {
80106992:	83 c3 01             	add    $0x1,%ebx
80106995:	39 1d 28 b6 10 80    	cmp    %ebx,0x8010b628
8010699b:	7f dd                	jg     8010697a <trap+0x63a>
                    cnt[3]++;
8010699d:	8b 1d 28 b6 10 80    	mov    0x8010b628,%ebx
801069a3:	8d 43 01             	lea    0x1(%ebx),%eax
801069a6:	a3 28 b6 10 80       	mov    %eax,0x8010b628
                    q3[cnt[3] - 1] = myproc();
801069ab:	e8 f0 ce ff ff       	call   801038a0 <myproc>
                    end3 += 1;
801069b0:	83 05 34 b6 10 80 01 	addl   $0x1,0x8010b634
                    q3[cnt[3] - 1] = myproc();
801069b7:	89 04 9d 80 4d 11 80 	mov    %eax,-0x7feeb280(,%ebx,4)
801069be:	e9 4d fc ff ff       	jmp    80106610 <trap+0x2d0>
            } else if (no == 3 && myproc()->stat.ticks[3] % 8 == 0) {
801069c3:	e8 d8 ce ff ff       	call   801038a0 <myproc>
801069c8:	f6 80 b4 00 00 00 07 	testb  $0x7,0xb4(%eax)
801069cf:	0f 85 fc fa ff ff    	jne    801064d1 <trap+0x191>
                myproc()->qno = 4;
801069d5:	e8 c6 ce ff ff       	call   801038a0 <myproc>
801069da:	c7 80 90 00 00 00 04 	movl   $0x4,0x90(%eax)
801069e1:	00 00 00 
                cnt[3]--;
801069e4:	8b 15 28 b6 10 80    	mov    0x8010b628,%edx
                for (int i = beg3; i < cnt[3]; i++) {
801069ea:	a1 48 b6 10 80       	mov    0x8010b648,%eax
                cnt[3]--;
801069ef:	8d 4a ff             	lea    -0x1(%edx),%ecx
                for (int i = beg3; i < cnt[3]; i++) {
801069f2:	39 c1                	cmp    %eax,%ecx
                cnt[3]--;
801069f4:	89 0d 28 b6 10 80    	mov    %ecx,0x8010b628
                for (int i = beg3; i < cnt[3]; i++) {
801069fa:	7e 1b                	jle    80106a17 <trap+0x6d7>
801069fc:	8d 04 85 80 4d 11 80 	lea    -0x7feeb280(,%eax,4),%eax
80106a03:	8d 0c 95 7c 4d 11 80 	lea    -0x7feeb284(,%edx,4),%ecx
                    q3[i] = q3[i + 1];
80106a0a:	8b 50 04             	mov    0x4(%eax),%edx
80106a0d:	83 c0 04             	add    $0x4,%eax
80106a10:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = beg3; i < cnt[3]; i++) {
80106a13:	39 c8                	cmp    %ecx,%eax
80106a15:	75 f3                	jne    80106a0a <trap+0x6ca>
                for (int i = 0; i < cnt[4]; i++) {
80106a17:	83 3d 2c b6 10 80 00 	cmpl   $0x0,0x8010b62c
80106a1e:	7e 25                	jle    80106a45 <trap+0x705>
80106a20:	31 db                	xor    %ebx,%ebx
                    if (q4[i]->pid == myproc()->pid) {
80106a22:	8b 04 9d a0 ab 11 80 	mov    -0x7fee5460(,%ebx,4),%eax
80106a29:	8b 70 10             	mov    0x10(%eax),%esi
80106a2c:	e8 6f ce ff ff       	call   801038a0 <myproc>
80106a31:	3b 70 10             	cmp    0x10(%eax),%esi
80106a34:	0f 84 d6 fb ff ff    	je     80106610 <trap+0x2d0>
                for (int i = 0; i < cnt[4]; i++) {
80106a3a:	83 c3 01             	add    $0x1,%ebx
80106a3d:	39 1d 2c b6 10 80    	cmp    %ebx,0x8010b62c
80106a43:	7f dd                	jg     80106a22 <trap+0x6e2>
                    cnt[4]++;
80106a45:	8b 1d 2c b6 10 80    	mov    0x8010b62c,%ebx
80106a4b:	8d 43 01             	lea    0x1(%ebx),%eax
80106a4e:	a3 2c b6 10 80       	mov    %eax,0x8010b62c
                    q4[cnt[4] - 1] = myproc();
80106a53:	e8 48 ce ff ff       	call   801038a0 <myproc>
                    end4 += 1;
80106a58:	83 05 30 b6 10 80 01 	addl   $0x1,0x8010b630
                    q4[cnt[4] - 1] = myproc();
80106a5f:	89 04 9d a0 ab 11 80 	mov    %eax,-0x7fee5460(,%ebx,4)
80106a66:	e9 a5 fb ff ff       	jmp    80106610 <trap+0x2d0>
                    if (flag0 == 1 || flag1 == 1) {
80106a6b:	09 d1                	or     %edx,%ecx
80106a6d:	0f 84 a5 f9 ff ff    	je     80106418 <trap+0xd8>
80106a73:	e9 98 fb ff ff       	jmp    80106610 <trap+0x2d0>
            } else if (no == 4 && myproc()->stat.ticks[4] % 16 == 0) {
80106a78:	e8 23 ce ff ff       	call   801038a0 <myproc>
80106a7d:	f6 80 b8 00 00 00 0f 	testb  $0xf,0xb8(%eax)
80106a84:	0f 85 47 fa ff ff    	jne    801064d1 <trap+0x191>
                q4[cnt[4]] = myproc();
80106a8a:	8b 1d 2c b6 10 80    	mov    0x8010b62c,%ebx
80106a90:	e8 0b ce ff ff       	call   801038a0 <myproc>
                for (int i = beg4; i < cnt[4]; i++) {
80106a95:	8b 15 2c b6 10 80    	mov    0x8010b62c,%edx
                end4 += 1;
80106a9b:	83 05 30 b6 10 80 01 	addl   $0x1,0x8010b630
                q4[cnt[4]] = myproc();
80106aa2:	89 04 9d a0 ab 11 80 	mov    %eax,-0x7fee5460(,%ebx,4)
                for (int i = beg4; i < cnt[4]; i++) {
80106aa9:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80106aae:	39 d0                	cmp    %edx,%eax
80106ab0:	0f 8d 5a fb ff ff    	jge    80106610 <trap+0x2d0>
80106ab6:	8d 04 85 a0 ab 11 80 	lea    -0x7fee5460(,%eax,4),%eax
80106abd:	8d 0c 95 a0 ab 11 80 	lea    -0x7fee5460(,%edx,4),%ecx
                    q4[i] = q4[i + 1];
80106ac4:	8b 50 04             	mov    0x4(%eax),%edx
80106ac7:	83 c0 04             	add    $0x4,%eax
80106aca:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = beg4; i < cnt[4]; i++) {
80106acd:	39 c8                	cmp    %ecx,%eax
80106acf:	75 f3                	jne    80106ac4 <trap+0x784>
80106ad1:	e9 3a fb ff ff       	jmp    80106610 <trap+0x2d0>
                    if (flag0 == 1 || flag1 == 1 || flag2 == 1) {
80106ad6:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
80106ada:	09 d1                	or     %edx,%ecx
80106adc:	08 c8                	or     %cl,%al
80106ade:	0f 85 2c fb ff ff    	jne    80106610 <trap+0x2d0>
80106ae4:	e9 2f f9 ff ff       	jmp    80106418 <trap+0xd8>
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
80106ae9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106af0:	e9 9d fa ff ff       	jmp    80106592 <trap+0x252>
80106af5:	31 c0                	xor    %eax,%eax
80106af7:	e9 e1 fa ff ff       	jmp    801065dd <trap+0x29d>
80106afc:	0f 20 d6             	mov    %cr2,%esi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106aff:	e8 7c cd ff ff       	call   80103880 <cpuid>
80106b04:	83 ec 0c             	sub    $0xc,%esp
80106b07:	56                   	push   %esi
80106b08:	53                   	push   %ebx
80106b09:	50                   	push   %eax
80106b0a:	ff 77 30             	pushl  0x30(%edi)
80106b0d:	68 74 89 10 80       	push   $0x80108974
80106b12:	e8 49 9b ff ff       	call   80100660 <cprintf>
                panic("trap");
80106b17:	83 c4 14             	add    $0x14,%esp
80106b1a:	68 4a 89 10 80       	push   $0x8010894a
80106b1f:	e8 6c 98 ff ff       	call   80100390 <panic>
80106b24:	66 90                	xchg   %ax,%ax
80106b26:	66 90                	xchg   %ax,%ax
80106b28:	66 90                	xchg   %ax,%ax
80106b2a:	66 90                	xchg   %ax,%ax
80106b2c:	66 90                	xchg   %ax,%ax
80106b2e:	66 90                	xchg   %ax,%ax

80106b30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106b30:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
{
80106b35:	55                   	push   %ebp
80106b36:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106b38:	85 c0                	test   %eax,%eax
80106b3a:	74 1c                	je     80106b58 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b3c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106b41:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106b42:	a8 01                	test   $0x1,%al
80106b44:	74 12                	je     80106b58 <uartgetc+0x28>
80106b46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b4b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106b4c:	0f b6 c0             	movzbl %al,%eax
}
80106b4f:	5d                   	pop    %ebp
80106b50:	c3                   	ret    
80106b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b5d:	5d                   	pop    %ebp
80106b5e:	c3                   	ret    
80106b5f:	90                   	nop

80106b60 <uartputc.part.0>:
uartputc(int c)
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	56                   	push   %esi
80106b65:	53                   	push   %ebx
80106b66:	89 c7                	mov    %eax,%edi
80106b68:	bb 80 00 00 00       	mov    $0x80,%ebx
80106b6d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106b72:	83 ec 0c             	sub    $0xc,%esp
80106b75:	eb 1b                	jmp    80106b92 <uartputc.part.0+0x32>
80106b77:	89 f6                	mov    %esi,%esi
80106b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106b80:	83 ec 0c             	sub    $0xc,%esp
80106b83:	6a 0a                	push   $0xa
80106b85:	e8 e6 bb ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b8a:	83 c4 10             	add    $0x10,%esp
80106b8d:	83 eb 01             	sub    $0x1,%ebx
80106b90:	74 07                	je     80106b99 <uartputc.part.0+0x39>
80106b92:	89 f2                	mov    %esi,%edx
80106b94:	ec                   	in     (%dx),%al
80106b95:	a8 20                	test   $0x20,%al
80106b97:	74 e7                	je     80106b80 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b99:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b9e:	89 f8                	mov    %edi,%eax
80106ba0:	ee                   	out    %al,(%dx)
}
80106ba1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ba4:	5b                   	pop    %ebx
80106ba5:	5e                   	pop    %esi
80106ba6:	5f                   	pop    %edi
80106ba7:	5d                   	pop    %ebp
80106ba8:	c3                   	ret    
80106ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106bb0 <uartinit>:
{
80106bb0:	55                   	push   %ebp
80106bb1:	31 c9                	xor    %ecx,%ecx
80106bb3:	89 c8                	mov    %ecx,%eax
80106bb5:	89 e5                	mov    %esp,%ebp
80106bb7:	57                   	push   %edi
80106bb8:	56                   	push   %esi
80106bb9:	53                   	push   %ebx
80106bba:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106bbf:	89 da                	mov    %ebx,%edx
80106bc1:	83 ec 0c             	sub    $0xc,%esp
80106bc4:	ee                   	out    %al,(%dx)
80106bc5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106bca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106bcf:	89 fa                	mov    %edi,%edx
80106bd1:	ee                   	out    %al,(%dx)
80106bd2:	b8 0c 00 00 00       	mov    $0xc,%eax
80106bd7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106bdc:	ee                   	out    %al,(%dx)
80106bdd:	be f9 03 00 00       	mov    $0x3f9,%esi
80106be2:	89 c8                	mov    %ecx,%eax
80106be4:	89 f2                	mov    %esi,%edx
80106be6:	ee                   	out    %al,(%dx)
80106be7:	b8 03 00 00 00       	mov    $0x3,%eax
80106bec:	89 fa                	mov    %edi,%edx
80106bee:	ee                   	out    %al,(%dx)
80106bef:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106bf4:	89 c8                	mov    %ecx,%eax
80106bf6:	ee                   	out    %al,(%dx)
80106bf7:	b8 01 00 00 00       	mov    $0x1,%eax
80106bfc:	89 f2                	mov    %esi,%edx
80106bfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106bff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106c04:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106c05:	3c ff                	cmp    $0xff,%al
80106c07:	74 5a                	je     80106c63 <uartinit+0xb3>
  uart = 1;
80106c09:	c7 05 5c b6 10 80 01 	movl   $0x1,0x8010b65c
80106c10:	00 00 00 
80106c13:	89 da                	mov    %ebx,%edx
80106c15:	ec                   	in     (%dx),%al
80106c16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c1b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106c1c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106c1f:	bb 6c 8a 10 80       	mov    $0x80108a6c,%ebx
  ioapicenable(IRQ_COM1, 0);
80106c24:	6a 00                	push   $0x0
80106c26:	6a 04                	push   $0x4
80106c28:	e8 a3 b6 ff ff       	call   801022d0 <ioapicenable>
80106c2d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106c30:	b8 78 00 00 00       	mov    $0x78,%eax
80106c35:	eb 13                	jmp    80106c4a <uartinit+0x9a>
80106c37:	89 f6                	mov    %esi,%esi
80106c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c40:	83 c3 01             	add    $0x1,%ebx
80106c43:	0f be 03             	movsbl (%ebx),%eax
80106c46:	84 c0                	test   %al,%al
80106c48:	74 19                	je     80106c63 <uartinit+0xb3>
  if(!uart)
80106c4a:	8b 15 5c b6 10 80    	mov    0x8010b65c,%edx
80106c50:	85 d2                	test   %edx,%edx
80106c52:	74 ec                	je     80106c40 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106c54:	83 c3 01             	add    $0x1,%ebx
80106c57:	e8 04 ff ff ff       	call   80106b60 <uartputc.part.0>
80106c5c:	0f be 03             	movsbl (%ebx),%eax
80106c5f:	84 c0                	test   %al,%al
80106c61:	75 e7                	jne    80106c4a <uartinit+0x9a>
}
80106c63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c66:	5b                   	pop    %ebx
80106c67:	5e                   	pop    %esi
80106c68:	5f                   	pop    %edi
80106c69:	5d                   	pop    %ebp
80106c6a:	c3                   	ret    
80106c6b:	90                   	nop
80106c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c70 <uartputc>:
  if(!uart)
80106c70:	8b 15 5c b6 10 80    	mov    0x8010b65c,%edx
{
80106c76:	55                   	push   %ebp
80106c77:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106c79:	85 d2                	test   %edx,%edx
{
80106c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106c7e:	74 10                	je     80106c90 <uartputc+0x20>
}
80106c80:	5d                   	pop    %ebp
80106c81:	e9 da fe ff ff       	jmp    80106b60 <uartputc.part.0>
80106c86:	8d 76 00             	lea    0x0(%esi),%esi
80106c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c90:	5d                   	pop    %ebp
80106c91:	c3                   	ret    
80106c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ca0 <uartintr>:

void
uartintr(void)
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106ca6:	68 30 6b 10 80       	push   $0x80106b30
80106cab:	e8 60 9b ff ff       	call   80100810 <consoleintr>
}
80106cb0:	83 c4 10             	add    $0x10,%esp
80106cb3:	c9                   	leave  
80106cb4:	c3                   	ret    

80106cb5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106cb5:	6a 00                	push   $0x0
  pushl $0
80106cb7:	6a 00                	push   $0x0
  jmp alltraps
80106cb9:	e9 ac f5 ff ff       	jmp    8010626a <alltraps>

80106cbe <vector1>:
.globl vector1
vector1:
  pushl $0
80106cbe:	6a 00                	push   $0x0
  pushl $1
80106cc0:	6a 01                	push   $0x1
  jmp alltraps
80106cc2:	e9 a3 f5 ff ff       	jmp    8010626a <alltraps>

80106cc7 <vector2>:
.globl vector2
vector2:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $2
80106cc9:	6a 02                	push   $0x2
  jmp alltraps
80106ccb:	e9 9a f5 ff ff       	jmp    8010626a <alltraps>

80106cd0 <vector3>:
.globl vector3
vector3:
  pushl $0
80106cd0:	6a 00                	push   $0x0
  pushl $3
80106cd2:	6a 03                	push   $0x3
  jmp alltraps
80106cd4:	e9 91 f5 ff ff       	jmp    8010626a <alltraps>

80106cd9 <vector4>:
.globl vector4
vector4:
  pushl $0
80106cd9:	6a 00                	push   $0x0
  pushl $4
80106cdb:	6a 04                	push   $0x4
  jmp alltraps
80106cdd:	e9 88 f5 ff ff       	jmp    8010626a <alltraps>

80106ce2 <vector5>:
.globl vector5
vector5:
  pushl $0
80106ce2:	6a 00                	push   $0x0
  pushl $5
80106ce4:	6a 05                	push   $0x5
  jmp alltraps
80106ce6:	e9 7f f5 ff ff       	jmp    8010626a <alltraps>

80106ceb <vector6>:
.globl vector6
vector6:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $6
80106ced:	6a 06                	push   $0x6
  jmp alltraps
80106cef:	e9 76 f5 ff ff       	jmp    8010626a <alltraps>

80106cf4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106cf4:	6a 00                	push   $0x0
  pushl $7
80106cf6:	6a 07                	push   $0x7
  jmp alltraps
80106cf8:	e9 6d f5 ff ff       	jmp    8010626a <alltraps>

80106cfd <vector8>:
.globl vector8
vector8:
  pushl $8
80106cfd:	6a 08                	push   $0x8
  jmp alltraps
80106cff:	e9 66 f5 ff ff       	jmp    8010626a <alltraps>

80106d04 <vector9>:
.globl vector9
vector9:
  pushl $0
80106d04:	6a 00                	push   $0x0
  pushl $9
80106d06:	6a 09                	push   $0x9
  jmp alltraps
80106d08:	e9 5d f5 ff ff       	jmp    8010626a <alltraps>

80106d0d <vector10>:
.globl vector10
vector10:
  pushl $10
80106d0d:	6a 0a                	push   $0xa
  jmp alltraps
80106d0f:	e9 56 f5 ff ff       	jmp    8010626a <alltraps>

80106d14 <vector11>:
.globl vector11
vector11:
  pushl $11
80106d14:	6a 0b                	push   $0xb
  jmp alltraps
80106d16:	e9 4f f5 ff ff       	jmp    8010626a <alltraps>

80106d1b <vector12>:
.globl vector12
vector12:
  pushl $12
80106d1b:	6a 0c                	push   $0xc
  jmp alltraps
80106d1d:	e9 48 f5 ff ff       	jmp    8010626a <alltraps>

80106d22 <vector13>:
.globl vector13
vector13:
  pushl $13
80106d22:	6a 0d                	push   $0xd
  jmp alltraps
80106d24:	e9 41 f5 ff ff       	jmp    8010626a <alltraps>

80106d29 <vector14>:
.globl vector14
vector14:
  pushl $14
80106d29:	6a 0e                	push   $0xe
  jmp alltraps
80106d2b:	e9 3a f5 ff ff       	jmp    8010626a <alltraps>

80106d30 <vector15>:
.globl vector15
vector15:
  pushl $0
80106d30:	6a 00                	push   $0x0
  pushl $15
80106d32:	6a 0f                	push   $0xf
  jmp alltraps
80106d34:	e9 31 f5 ff ff       	jmp    8010626a <alltraps>

80106d39 <vector16>:
.globl vector16
vector16:
  pushl $0
80106d39:	6a 00                	push   $0x0
  pushl $16
80106d3b:	6a 10                	push   $0x10
  jmp alltraps
80106d3d:	e9 28 f5 ff ff       	jmp    8010626a <alltraps>

80106d42 <vector17>:
.globl vector17
vector17:
  pushl $17
80106d42:	6a 11                	push   $0x11
  jmp alltraps
80106d44:	e9 21 f5 ff ff       	jmp    8010626a <alltraps>

80106d49 <vector18>:
.globl vector18
vector18:
  pushl $0
80106d49:	6a 00                	push   $0x0
  pushl $18
80106d4b:	6a 12                	push   $0x12
  jmp alltraps
80106d4d:	e9 18 f5 ff ff       	jmp    8010626a <alltraps>

80106d52 <vector19>:
.globl vector19
vector19:
  pushl $0
80106d52:	6a 00                	push   $0x0
  pushl $19
80106d54:	6a 13                	push   $0x13
  jmp alltraps
80106d56:	e9 0f f5 ff ff       	jmp    8010626a <alltraps>

80106d5b <vector20>:
.globl vector20
vector20:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $20
80106d5d:	6a 14                	push   $0x14
  jmp alltraps
80106d5f:	e9 06 f5 ff ff       	jmp    8010626a <alltraps>

80106d64 <vector21>:
.globl vector21
vector21:
  pushl $0
80106d64:	6a 00                	push   $0x0
  pushl $21
80106d66:	6a 15                	push   $0x15
  jmp alltraps
80106d68:	e9 fd f4 ff ff       	jmp    8010626a <alltraps>

80106d6d <vector22>:
.globl vector22
vector22:
  pushl $0
80106d6d:	6a 00                	push   $0x0
  pushl $22
80106d6f:	6a 16                	push   $0x16
  jmp alltraps
80106d71:	e9 f4 f4 ff ff       	jmp    8010626a <alltraps>

80106d76 <vector23>:
.globl vector23
vector23:
  pushl $0
80106d76:	6a 00                	push   $0x0
  pushl $23
80106d78:	6a 17                	push   $0x17
  jmp alltraps
80106d7a:	e9 eb f4 ff ff       	jmp    8010626a <alltraps>

80106d7f <vector24>:
.globl vector24
vector24:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $24
80106d81:	6a 18                	push   $0x18
  jmp alltraps
80106d83:	e9 e2 f4 ff ff       	jmp    8010626a <alltraps>

80106d88 <vector25>:
.globl vector25
vector25:
  pushl $0
80106d88:	6a 00                	push   $0x0
  pushl $25
80106d8a:	6a 19                	push   $0x19
  jmp alltraps
80106d8c:	e9 d9 f4 ff ff       	jmp    8010626a <alltraps>

80106d91 <vector26>:
.globl vector26
vector26:
  pushl $0
80106d91:	6a 00                	push   $0x0
  pushl $26
80106d93:	6a 1a                	push   $0x1a
  jmp alltraps
80106d95:	e9 d0 f4 ff ff       	jmp    8010626a <alltraps>

80106d9a <vector27>:
.globl vector27
vector27:
  pushl $0
80106d9a:	6a 00                	push   $0x0
  pushl $27
80106d9c:	6a 1b                	push   $0x1b
  jmp alltraps
80106d9e:	e9 c7 f4 ff ff       	jmp    8010626a <alltraps>

80106da3 <vector28>:
.globl vector28
vector28:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $28
80106da5:	6a 1c                	push   $0x1c
  jmp alltraps
80106da7:	e9 be f4 ff ff       	jmp    8010626a <alltraps>

80106dac <vector29>:
.globl vector29
vector29:
  pushl $0
80106dac:	6a 00                	push   $0x0
  pushl $29
80106dae:	6a 1d                	push   $0x1d
  jmp alltraps
80106db0:	e9 b5 f4 ff ff       	jmp    8010626a <alltraps>

80106db5 <vector30>:
.globl vector30
vector30:
  pushl $0
80106db5:	6a 00                	push   $0x0
  pushl $30
80106db7:	6a 1e                	push   $0x1e
  jmp alltraps
80106db9:	e9 ac f4 ff ff       	jmp    8010626a <alltraps>

80106dbe <vector31>:
.globl vector31
vector31:
  pushl $0
80106dbe:	6a 00                	push   $0x0
  pushl $31
80106dc0:	6a 1f                	push   $0x1f
  jmp alltraps
80106dc2:	e9 a3 f4 ff ff       	jmp    8010626a <alltraps>

80106dc7 <vector32>:
.globl vector32
vector32:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $32
80106dc9:	6a 20                	push   $0x20
  jmp alltraps
80106dcb:	e9 9a f4 ff ff       	jmp    8010626a <alltraps>

80106dd0 <vector33>:
.globl vector33
vector33:
  pushl $0
80106dd0:	6a 00                	push   $0x0
  pushl $33
80106dd2:	6a 21                	push   $0x21
  jmp alltraps
80106dd4:	e9 91 f4 ff ff       	jmp    8010626a <alltraps>

80106dd9 <vector34>:
.globl vector34
vector34:
  pushl $0
80106dd9:	6a 00                	push   $0x0
  pushl $34
80106ddb:	6a 22                	push   $0x22
  jmp alltraps
80106ddd:	e9 88 f4 ff ff       	jmp    8010626a <alltraps>

80106de2 <vector35>:
.globl vector35
vector35:
  pushl $0
80106de2:	6a 00                	push   $0x0
  pushl $35
80106de4:	6a 23                	push   $0x23
  jmp alltraps
80106de6:	e9 7f f4 ff ff       	jmp    8010626a <alltraps>

80106deb <vector36>:
.globl vector36
vector36:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $36
80106ded:	6a 24                	push   $0x24
  jmp alltraps
80106def:	e9 76 f4 ff ff       	jmp    8010626a <alltraps>

80106df4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106df4:	6a 00                	push   $0x0
  pushl $37
80106df6:	6a 25                	push   $0x25
  jmp alltraps
80106df8:	e9 6d f4 ff ff       	jmp    8010626a <alltraps>

80106dfd <vector38>:
.globl vector38
vector38:
  pushl $0
80106dfd:	6a 00                	push   $0x0
  pushl $38
80106dff:	6a 26                	push   $0x26
  jmp alltraps
80106e01:	e9 64 f4 ff ff       	jmp    8010626a <alltraps>

80106e06 <vector39>:
.globl vector39
vector39:
  pushl $0
80106e06:	6a 00                	push   $0x0
  pushl $39
80106e08:	6a 27                	push   $0x27
  jmp alltraps
80106e0a:	e9 5b f4 ff ff       	jmp    8010626a <alltraps>

80106e0f <vector40>:
.globl vector40
vector40:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $40
80106e11:	6a 28                	push   $0x28
  jmp alltraps
80106e13:	e9 52 f4 ff ff       	jmp    8010626a <alltraps>

80106e18 <vector41>:
.globl vector41
vector41:
  pushl $0
80106e18:	6a 00                	push   $0x0
  pushl $41
80106e1a:	6a 29                	push   $0x29
  jmp alltraps
80106e1c:	e9 49 f4 ff ff       	jmp    8010626a <alltraps>

80106e21 <vector42>:
.globl vector42
vector42:
  pushl $0
80106e21:	6a 00                	push   $0x0
  pushl $42
80106e23:	6a 2a                	push   $0x2a
  jmp alltraps
80106e25:	e9 40 f4 ff ff       	jmp    8010626a <alltraps>

80106e2a <vector43>:
.globl vector43
vector43:
  pushl $0
80106e2a:	6a 00                	push   $0x0
  pushl $43
80106e2c:	6a 2b                	push   $0x2b
  jmp alltraps
80106e2e:	e9 37 f4 ff ff       	jmp    8010626a <alltraps>

80106e33 <vector44>:
.globl vector44
vector44:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $44
80106e35:	6a 2c                	push   $0x2c
  jmp alltraps
80106e37:	e9 2e f4 ff ff       	jmp    8010626a <alltraps>

80106e3c <vector45>:
.globl vector45
vector45:
  pushl $0
80106e3c:	6a 00                	push   $0x0
  pushl $45
80106e3e:	6a 2d                	push   $0x2d
  jmp alltraps
80106e40:	e9 25 f4 ff ff       	jmp    8010626a <alltraps>

80106e45 <vector46>:
.globl vector46
vector46:
  pushl $0
80106e45:	6a 00                	push   $0x0
  pushl $46
80106e47:	6a 2e                	push   $0x2e
  jmp alltraps
80106e49:	e9 1c f4 ff ff       	jmp    8010626a <alltraps>

80106e4e <vector47>:
.globl vector47
vector47:
  pushl $0
80106e4e:	6a 00                	push   $0x0
  pushl $47
80106e50:	6a 2f                	push   $0x2f
  jmp alltraps
80106e52:	e9 13 f4 ff ff       	jmp    8010626a <alltraps>

80106e57 <vector48>:
.globl vector48
vector48:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $48
80106e59:	6a 30                	push   $0x30
  jmp alltraps
80106e5b:	e9 0a f4 ff ff       	jmp    8010626a <alltraps>

80106e60 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e60:	6a 00                	push   $0x0
  pushl $49
80106e62:	6a 31                	push   $0x31
  jmp alltraps
80106e64:	e9 01 f4 ff ff       	jmp    8010626a <alltraps>

80106e69 <vector50>:
.globl vector50
vector50:
  pushl $0
80106e69:	6a 00                	push   $0x0
  pushl $50
80106e6b:	6a 32                	push   $0x32
  jmp alltraps
80106e6d:	e9 f8 f3 ff ff       	jmp    8010626a <alltraps>

80106e72 <vector51>:
.globl vector51
vector51:
  pushl $0
80106e72:	6a 00                	push   $0x0
  pushl $51
80106e74:	6a 33                	push   $0x33
  jmp alltraps
80106e76:	e9 ef f3 ff ff       	jmp    8010626a <alltraps>

80106e7b <vector52>:
.globl vector52
vector52:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $52
80106e7d:	6a 34                	push   $0x34
  jmp alltraps
80106e7f:	e9 e6 f3 ff ff       	jmp    8010626a <alltraps>

80106e84 <vector53>:
.globl vector53
vector53:
  pushl $0
80106e84:	6a 00                	push   $0x0
  pushl $53
80106e86:	6a 35                	push   $0x35
  jmp alltraps
80106e88:	e9 dd f3 ff ff       	jmp    8010626a <alltraps>

80106e8d <vector54>:
.globl vector54
vector54:
  pushl $0
80106e8d:	6a 00                	push   $0x0
  pushl $54
80106e8f:	6a 36                	push   $0x36
  jmp alltraps
80106e91:	e9 d4 f3 ff ff       	jmp    8010626a <alltraps>

80106e96 <vector55>:
.globl vector55
vector55:
  pushl $0
80106e96:	6a 00                	push   $0x0
  pushl $55
80106e98:	6a 37                	push   $0x37
  jmp alltraps
80106e9a:	e9 cb f3 ff ff       	jmp    8010626a <alltraps>

80106e9f <vector56>:
.globl vector56
vector56:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $56
80106ea1:	6a 38                	push   $0x38
  jmp alltraps
80106ea3:	e9 c2 f3 ff ff       	jmp    8010626a <alltraps>

80106ea8 <vector57>:
.globl vector57
vector57:
  pushl $0
80106ea8:	6a 00                	push   $0x0
  pushl $57
80106eaa:	6a 39                	push   $0x39
  jmp alltraps
80106eac:	e9 b9 f3 ff ff       	jmp    8010626a <alltraps>

80106eb1 <vector58>:
.globl vector58
vector58:
  pushl $0
80106eb1:	6a 00                	push   $0x0
  pushl $58
80106eb3:	6a 3a                	push   $0x3a
  jmp alltraps
80106eb5:	e9 b0 f3 ff ff       	jmp    8010626a <alltraps>

80106eba <vector59>:
.globl vector59
vector59:
  pushl $0
80106eba:	6a 00                	push   $0x0
  pushl $59
80106ebc:	6a 3b                	push   $0x3b
  jmp alltraps
80106ebe:	e9 a7 f3 ff ff       	jmp    8010626a <alltraps>

80106ec3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $60
80106ec5:	6a 3c                	push   $0x3c
  jmp alltraps
80106ec7:	e9 9e f3 ff ff       	jmp    8010626a <alltraps>

80106ecc <vector61>:
.globl vector61
vector61:
  pushl $0
80106ecc:	6a 00                	push   $0x0
  pushl $61
80106ece:	6a 3d                	push   $0x3d
  jmp alltraps
80106ed0:	e9 95 f3 ff ff       	jmp    8010626a <alltraps>

80106ed5 <vector62>:
.globl vector62
vector62:
  pushl $0
80106ed5:	6a 00                	push   $0x0
  pushl $62
80106ed7:	6a 3e                	push   $0x3e
  jmp alltraps
80106ed9:	e9 8c f3 ff ff       	jmp    8010626a <alltraps>

80106ede <vector63>:
.globl vector63
vector63:
  pushl $0
80106ede:	6a 00                	push   $0x0
  pushl $63
80106ee0:	6a 3f                	push   $0x3f
  jmp alltraps
80106ee2:	e9 83 f3 ff ff       	jmp    8010626a <alltraps>

80106ee7 <vector64>:
.globl vector64
vector64:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $64
80106ee9:	6a 40                	push   $0x40
  jmp alltraps
80106eeb:	e9 7a f3 ff ff       	jmp    8010626a <alltraps>

80106ef0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ef0:	6a 00                	push   $0x0
  pushl $65
80106ef2:	6a 41                	push   $0x41
  jmp alltraps
80106ef4:	e9 71 f3 ff ff       	jmp    8010626a <alltraps>

80106ef9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106ef9:	6a 00                	push   $0x0
  pushl $66
80106efb:	6a 42                	push   $0x42
  jmp alltraps
80106efd:	e9 68 f3 ff ff       	jmp    8010626a <alltraps>

80106f02 <vector67>:
.globl vector67
vector67:
  pushl $0
80106f02:	6a 00                	push   $0x0
  pushl $67
80106f04:	6a 43                	push   $0x43
  jmp alltraps
80106f06:	e9 5f f3 ff ff       	jmp    8010626a <alltraps>

80106f0b <vector68>:
.globl vector68
vector68:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $68
80106f0d:	6a 44                	push   $0x44
  jmp alltraps
80106f0f:	e9 56 f3 ff ff       	jmp    8010626a <alltraps>

80106f14 <vector69>:
.globl vector69
vector69:
  pushl $0
80106f14:	6a 00                	push   $0x0
  pushl $69
80106f16:	6a 45                	push   $0x45
  jmp alltraps
80106f18:	e9 4d f3 ff ff       	jmp    8010626a <alltraps>

80106f1d <vector70>:
.globl vector70
vector70:
  pushl $0
80106f1d:	6a 00                	push   $0x0
  pushl $70
80106f1f:	6a 46                	push   $0x46
  jmp alltraps
80106f21:	e9 44 f3 ff ff       	jmp    8010626a <alltraps>

80106f26 <vector71>:
.globl vector71
vector71:
  pushl $0
80106f26:	6a 00                	push   $0x0
  pushl $71
80106f28:	6a 47                	push   $0x47
  jmp alltraps
80106f2a:	e9 3b f3 ff ff       	jmp    8010626a <alltraps>

80106f2f <vector72>:
.globl vector72
vector72:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $72
80106f31:	6a 48                	push   $0x48
  jmp alltraps
80106f33:	e9 32 f3 ff ff       	jmp    8010626a <alltraps>

80106f38 <vector73>:
.globl vector73
vector73:
  pushl $0
80106f38:	6a 00                	push   $0x0
  pushl $73
80106f3a:	6a 49                	push   $0x49
  jmp alltraps
80106f3c:	e9 29 f3 ff ff       	jmp    8010626a <alltraps>

80106f41 <vector74>:
.globl vector74
vector74:
  pushl $0
80106f41:	6a 00                	push   $0x0
  pushl $74
80106f43:	6a 4a                	push   $0x4a
  jmp alltraps
80106f45:	e9 20 f3 ff ff       	jmp    8010626a <alltraps>

80106f4a <vector75>:
.globl vector75
vector75:
  pushl $0
80106f4a:	6a 00                	push   $0x0
  pushl $75
80106f4c:	6a 4b                	push   $0x4b
  jmp alltraps
80106f4e:	e9 17 f3 ff ff       	jmp    8010626a <alltraps>

80106f53 <vector76>:
.globl vector76
vector76:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $76
80106f55:	6a 4c                	push   $0x4c
  jmp alltraps
80106f57:	e9 0e f3 ff ff       	jmp    8010626a <alltraps>

80106f5c <vector77>:
.globl vector77
vector77:
  pushl $0
80106f5c:	6a 00                	push   $0x0
  pushl $77
80106f5e:	6a 4d                	push   $0x4d
  jmp alltraps
80106f60:	e9 05 f3 ff ff       	jmp    8010626a <alltraps>

80106f65 <vector78>:
.globl vector78
vector78:
  pushl $0
80106f65:	6a 00                	push   $0x0
  pushl $78
80106f67:	6a 4e                	push   $0x4e
  jmp alltraps
80106f69:	e9 fc f2 ff ff       	jmp    8010626a <alltraps>

80106f6e <vector79>:
.globl vector79
vector79:
  pushl $0
80106f6e:	6a 00                	push   $0x0
  pushl $79
80106f70:	6a 4f                	push   $0x4f
  jmp alltraps
80106f72:	e9 f3 f2 ff ff       	jmp    8010626a <alltraps>

80106f77 <vector80>:
.globl vector80
vector80:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $80
80106f79:	6a 50                	push   $0x50
  jmp alltraps
80106f7b:	e9 ea f2 ff ff       	jmp    8010626a <alltraps>

80106f80 <vector81>:
.globl vector81
vector81:
  pushl $0
80106f80:	6a 00                	push   $0x0
  pushl $81
80106f82:	6a 51                	push   $0x51
  jmp alltraps
80106f84:	e9 e1 f2 ff ff       	jmp    8010626a <alltraps>

80106f89 <vector82>:
.globl vector82
vector82:
  pushl $0
80106f89:	6a 00                	push   $0x0
  pushl $82
80106f8b:	6a 52                	push   $0x52
  jmp alltraps
80106f8d:	e9 d8 f2 ff ff       	jmp    8010626a <alltraps>

80106f92 <vector83>:
.globl vector83
vector83:
  pushl $0
80106f92:	6a 00                	push   $0x0
  pushl $83
80106f94:	6a 53                	push   $0x53
  jmp alltraps
80106f96:	e9 cf f2 ff ff       	jmp    8010626a <alltraps>

80106f9b <vector84>:
.globl vector84
vector84:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $84
80106f9d:	6a 54                	push   $0x54
  jmp alltraps
80106f9f:	e9 c6 f2 ff ff       	jmp    8010626a <alltraps>

80106fa4 <vector85>:
.globl vector85
vector85:
  pushl $0
80106fa4:	6a 00                	push   $0x0
  pushl $85
80106fa6:	6a 55                	push   $0x55
  jmp alltraps
80106fa8:	e9 bd f2 ff ff       	jmp    8010626a <alltraps>

80106fad <vector86>:
.globl vector86
vector86:
  pushl $0
80106fad:	6a 00                	push   $0x0
  pushl $86
80106faf:	6a 56                	push   $0x56
  jmp alltraps
80106fb1:	e9 b4 f2 ff ff       	jmp    8010626a <alltraps>

80106fb6 <vector87>:
.globl vector87
vector87:
  pushl $0
80106fb6:	6a 00                	push   $0x0
  pushl $87
80106fb8:	6a 57                	push   $0x57
  jmp alltraps
80106fba:	e9 ab f2 ff ff       	jmp    8010626a <alltraps>

80106fbf <vector88>:
.globl vector88
vector88:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $88
80106fc1:	6a 58                	push   $0x58
  jmp alltraps
80106fc3:	e9 a2 f2 ff ff       	jmp    8010626a <alltraps>

80106fc8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106fc8:	6a 00                	push   $0x0
  pushl $89
80106fca:	6a 59                	push   $0x59
  jmp alltraps
80106fcc:	e9 99 f2 ff ff       	jmp    8010626a <alltraps>

80106fd1 <vector90>:
.globl vector90
vector90:
  pushl $0
80106fd1:	6a 00                	push   $0x0
  pushl $90
80106fd3:	6a 5a                	push   $0x5a
  jmp alltraps
80106fd5:	e9 90 f2 ff ff       	jmp    8010626a <alltraps>

80106fda <vector91>:
.globl vector91
vector91:
  pushl $0
80106fda:	6a 00                	push   $0x0
  pushl $91
80106fdc:	6a 5b                	push   $0x5b
  jmp alltraps
80106fde:	e9 87 f2 ff ff       	jmp    8010626a <alltraps>

80106fe3 <vector92>:
.globl vector92
vector92:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $92
80106fe5:	6a 5c                	push   $0x5c
  jmp alltraps
80106fe7:	e9 7e f2 ff ff       	jmp    8010626a <alltraps>

80106fec <vector93>:
.globl vector93
vector93:
  pushl $0
80106fec:	6a 00                	push   $0x0
  pushl $93
80106fee:	6a 5d                	push   $0x5d
  jmp alltraps
80106ff0:	e9 75 f2 ff ff       	jmp    8010626a <alltraps>

80106ff5 <vector94>:
.globl vector94
vector94:
  pushl $0
80106ff5:	6a 00                	push   $0x0
  pushl $94
80106ff7:	6a 5e                	push   $0x5e
  jmp alltraps
80106ff9:	e9 6c f2 ff ff       	jmp    8010626a <alltraps>

80106ffe <vector95>:
.globl vector95
vector95:
  pushl $0
80106ffe:	6a 00                	push   $0x0
  pushl $95
80107000:	6a 5f                	push   $0x5f
  jmp alltraps
80107002:	e9 63 f2 ff ff       	jmp    8010626a <alltraps>

80107007 <vector96>:
.globl vector96
vector96:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $96
80107009:	6a 60                	push   $0x60
  jmp alltraps
8010700b:	e9 5a f2 ff ff       	jmp    8010626a <alltraps>

80107010 <vector97>:
.globl vector97
vector97:
  pushl $0
80107010:	6a 00                	push   $0x0
  pushl $97
80107012:	6a 61                	push   $0x61
  jmp alltraps
80107014:	e9 51 f2 ff ff       	jmp    8010626a <alltraps>

80107019 <vector98>:
.globl vector98
vector98:
  pushl $0
80107019:	6a 00                	push   $0x0
  pushl $98
8010701b:	6a 62                	push   $0x62
  jmp alltraps
8010701d:	e9 48 f2 ff ff       	jmp    8010626a <alltraps>

80107022 <vector99>:
.globl vector99
vector99:
  pushl $0
80107022:	6a 00                	push   $0x0
  pushl $99
80107024:	6a 63                	push   $0x63
  jmp alltraps
80107026:	e9 3f f2 ff ff       	jmp    8010626a <alltraps>

8010702b <vector100>:
.globl vector100
vector100:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $100
8010702d:	6a 64                	push   $0x64
  jmp alltraps
8010702f:	e9 36 f2 ff ff       	jmp    8010626a <alltraps>

80107034 <vector101>:
.globl vector101
vector101:
  pushl $0
80107034:	6a 00                	push   $0x0
  pushl $101
80107036:	6a 65                	push   $0x65
  jmp alltraps
80107038:	e9 2d f2 ff ff       	jmp    8010626a <alltraps>

8010703d <vector102>:
.globl vector102
vector102:
  pushl $0
8010703d:	6a 00                	push   $0x0
  pushl $102
8010703f:	6a 66                	push   $0x66
  jmp alltraps
80107041:	e9 24 f2 ff ff       	jmp    8010626a <alltraps>

80107046 <vector103>:
.globl vector103
vector103:
  pushl $0
80107046:	6a 00                	push   $0x0
  pushl $103
80107048:	6a 67                	push   $0x67
  jmp alltraps
8010704a:	e9 1b f2 ff ff       	jmp    8010626a <alltraps>

8010704f <vector104>:
.globl vector104
vector104:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $104
80107051:	6a 68                	push   $0x68
  jmp alltraps
80107053:	e9 12 f2 ff ff       	jmp    8010626a <alltraps>

80107058 <vector105>:
.globl vector105
vector105:
  pushl $0
80107058:	6a 00                	push   $0x0
  pushl $105
8010705a:	6a 69                	push   $0x69
  jmp alltraps
8010705c:	e9 09 f2 ff ff       	jmp    8010626a <alltraps>

80107061 <vector106>:
.globl vector106
vector106:
  pushl $0
80107061:	6a 00                	push   $0x0
  pushl $106
80107063:	6a 6a                	push   $0x6a
  jmp alltraps
80107065:	e9 00 f2 ff ff       	jmp    8010626a <alltraps>

8010706a <vector107>:
.globl vector107
vector107:
  pushl $0
8010706a:	6a 00                	push   $0x0
  pushl $107
8010706c:	6a 6b                	push   $0x6b
  jmp alltraps
8010706e:	e9 f7 f1 ff ff       	jmp    8010626a <alltraps>

80107073 <vector108>:
.globl vector108
vector108:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $108
80107075:	6a 6c                	push   $0x6c
  jmp alltraps
80107077:	e9 ee f1 ff ff       	jmp    8010626a <alltraps>

8010707c <vector109>:
.globl vector109
vector109:
  pushl $0
8010707c:	6a 00                	push   $0x0
  pushl $109
8010707e:	6a 6d                	push   $0x6d
  jmp alltraps
80107080:	e9 e5 f1 ff ff       	jmp    8010626a <alltraps>

80107085 <vector110>:
.globl vector110
vector110:
  pushl $0
80107085:	6a 00                	push   $0x0
  pushl $110
80107087:	6a 6e                	push   $0x6e
  jmp alltraps
80107089:	e9 dc f1 ff ff       	jmp    8010626a <alltraps>

8010708e <vector111>:
.globl vector111
vector111:
  pushl $0
8010708e:	6a 00                	push   $0x0
  pushl $111
80107090:	6a 6f                	push   $0x6f
  jmp alltraps
80107092:	e9 d3 f1 ff ff       	jmp    8010626a <alltraps>

80107097 <vector112>:
.globl vector112
vector112:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $112
80107099:	6a 70                	push   $0x70
  jmp alltraps
8010709b:	e9 ca f1 ff ff       	jmp    8010626a <alltraps>

801070a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801070a0:	6a 00                	push   $0x0
  pushl $113
801070a2:	6a 71                	push   $0x71
  jmp alltraps
801070a4:	e9 c1 f1 ff ff       	jmp    8010626a <alltraps>

801070a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801070a9:	6a 00                	push   $0x0
  pushl $114
801070ab:	6a 72                	push   $0x72
  jmp alltraps
801070ad:	e9 b8 f1 ff ff       	jmp    8010626a <alltraps>

801070b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801070b2:	6a 00                	push   $0x0
  pushl $115
801070b4:	6a 73                	push   $0x73
  jmp alltraps
801070b6:	e9 af f1 ff ff       	jmp    8010626a <alltraps>

801070bb <vector116>:
.globl vector116
vector116:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $116
801070bd:	6a 74                	push   $0x74
  jmp alltraps
801070bf:	e9 a6 f1 ff ff       	jmp    8010626a <alltraps>

801070c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801070c4:	6a 00                	push   $0x0
  pushl $117
801070c6:	6a 75                	push   $0x75
  jmp alltraps
801070c8:	e9 9d f1 ff ff       	jmp    8010626a <alltraps>

801070cd <vector118>:
.globl vector118
vector118:
  pushl $0
801070cd:	6a 00                	push   $0x0
  pushl $118
801070cf:	6a 76                	push   $0x76
  jmp alltraps
801070d1:	e9 94 f1 ff ff       	jmp    8010626a <alltraps>

801070d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801070d6:	6a 00                	push   $0x0
  pushl $119
801070d8:	6a 77                	push   $0x77
  jmp alltraps
801070da:	e9 8b f1 ff ff       	jmp    8010626a <alltraps>

801070df <vector120>:
.globl vector120
vector120:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $120
801070e1:	6a 78                	push   $0x78
  jmp alltraps
801070e3:	e9 82 f1 ff ff       	jmp    8010626a <alltraps>

801070e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801070e8:	6a 00                	push   $0x0
  pushl $121
801070ea:	6a 79                	push   $0x79
  jmp alltraps
801070ec:	e9 79 f1 ff ff       	jmp    8010626a <alltraps>

801070f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801070f1:	6a 00                	push   $0x0
  pushl $122
801070f3:	6a 7a                	push   $0x7a
  jmp alltraps
801070f5:	e9 70 f1 ff ff       	jmp    8010626a <alltraps>

801070fa <vector123>:
.globl vector123
vector123:
  pushl $0
801070fa:	6a 00                	push   $0x0
  pushl $123
801070fc:	6a 7b                	push   $0x7b
  jmp alltraps
801070fe:	e9 67 f1 ff ff       	jmp    8010626a <alltraps>

80107103 <vector124>:
.globl vector124
vector124:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $124
80107105:	6a 7c                	push   $0x7c
  jmp alltraps
80107107:	e9 5e f1 ff ff       	jmp    8010626a <alltraps>

8010710c <vector125>:
.globl vector125
vector125:
  pushl $0
8010710c:	6a 00                	push   $0x0
  pushl $125
8010710e:	6a 7d                	push   $0x7d
  jmp alltraps
80107110:	e9 55 f1 ff ff       	jmp    8010626a <alltraps>

80107115 <vector126>:
.globl vector126
vector126:
  pushl $0
80107115:	6a 00                	push   $0x0
  pushl $126
80107117:	6a 7e                	push   $0x7e
  jmp alltraps
80107119:	e9 4c f1 ff ff       	jmp    8010626a <alltraps>

8010711e <vector127>:
.globl vector127
vector127:
  pushl $0
8010711e:	6a 00                	push   $0x0
  pushl $127
80107120:	6a 7f                	push   $0x7f
  jmp alltraps
80107122:	e9 43 f1 ff ff       	jmp    8010626a <alltraps>

80107127 <vector128>:
.globl vector128
vector128:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $128
80107129:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010712e:	e9 37 f1 ff ff       	jmp    8010626a <alltraps>

80107133 <vector129>:
.globl vector129
vector129:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $129
80107135:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010713a:	e9 2b f1 ff ff       	jmp    8010626a <alltraps>

8010713f <vector130>:
.globl vector130
vector130:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $130
80107141:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107146:	e9 1f f1 ff ff       	jmp    8010626a <alltraps>

8010714b <vector131>:
.globl vector131
vector131:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $131
8010714d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107152:	e9 13 f1 ff ff       	jmp    8010626a <alltraps>

80107157 <vector132>:
.globl vector132
vector132:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $132
80107159:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010715e:	e9 07 f1 ff ff       	jmp    8010626a <alltraps>

80107163 <vector133>:
.globl vector133
vector133:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $133
80107165:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010716a:	e9 fb f0 ff ff       	jmp    8010626a <alltraps>

8010716f <vector134>:
.globl vector134
vector134:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $134
80107171:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107176:	e9 ef f0 ff ff       	jmp    8010626a <alltraps>

8010717b <vector135>:
.globl vector135
vector135:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $135
8010717d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107182:	e9 e3 f0 ff ff       	jmp    8010626a <alltraps>

80107187 <vector136>:
.globl vector136
vector136:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $136
80107189:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010718e:	e9 d7 f0 ff ff       	jmp    8010626a <alltraps>

80107193 <vector137>:
.globl vector137
vector137:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $137
80107195:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010719a:	e9 cb f0 ff ff       	jmp    8010626a <alltraps>

8010719f <vector138>:
.globl vector138
vector138:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $138
801071a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801071a6:	e9 bf f0 ff ff       	jmp    8010626a <alltraps>

801071ab <vector139>:
.globl vector139
vector139:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $139
801071ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801071b2:	e9 b3 f0 ff ff       	jmp    8010626a <alltraps>

801071b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $140
801071b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801071be:	e9 a7 f0 ff ff       	jmp    8010626a <alltraps>

801071c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $141
801071c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801071ca:	e9 9b f0 ff ff       	jmp    8010626a <alltraps>

801071cf <vector142>:
.globl vector142
vector142:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $142
801071d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801071d6:	e9 8f f0 ff ff       	jmp    8010626a <alltraps>

801071db <vector143>:
.globl vector143
vector143:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $143
801071dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801071e2:	e9 83 f0 ff ff       	jmp    8010626a <alltraps>

801071e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $144
801071e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801071ee:	e9 77 f0 ff ff       	jmp    8010626a <alltraps>

801071f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $145
801071f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801071fa:	e9 6b f0 ff ff       	jmp    8010626a <alltraps>

801071ff <vector146>:
.globl vector146
vector146:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $146
80107201:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107206:	e9 5f f0 ff ff       	jmp    8010626a <alltraps>

8010720b <vector147>:
.globl vector147
vector147:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $147
8010720d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107212:	e9 53 f0 ff ff       	jmp    8010626a <alltraps>

80107217 <vector148>:
.globl vector148
vector148:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $148
80107219:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010721e:	e9 47 f0 ff ff       	jmp    8010626a <alltraps>

80107223 <vector149>:
.globl vector149
vector149:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $149
80107225:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010722a:	e9 3b f0 ff ff       	jmp    8010626a <alltraps>

8010722f <vector150>:
.globl vector150
vector150:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $150
80107231:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107236:	e9 2f f0 ff ff       	jmp    8010626a <alltraps>

8010723b <vector151>:
.globl vector151
vector151:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $151
8010723d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107242:	e9 23 f0 ff ff       	jmp    8010626a <alltraps>

80107247 <vector152>:
.globl vector152
vector152:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $152
80107249:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010724e:	e9 17 f0 ff ff       	jmp    8010626a <alltraps>

80107253 <vector153>:
.globl vector153
vector153:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $153
80107255:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010725a:	e9 0b f0 ff ff       	jmp    8010626a <alltraps>

8010725f <vector154>:
.globl vector154
vector154:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $154
80107261:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107266:	e9 ff ef ff ff       	jmp    8010626a <alltraps>

8010726b <vector155>:
.globl vector155
vector155:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $155
8010726d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107272:	e9 f3 ef ff ff       	jmp    8010626a <alltraps>

80107277 <vector156>:
.globl vector156
vector156:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $156
80107279:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010727e:	e9 e7 ef ff ff       	jmp    8010626a <alltraps>

80107283 <vector157>:
.globl vector157
vector157:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $157
80107285:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010728a:	e9 db ef ff ff       	jmp    8010626a <alltraps>

8010728f <vector158>:
.globl vector158
vector158:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $158
80107291:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107296:	e9 cf ef ff ff       	jmp    8010626a <alltraps>

8010729b <vector159>:
.globl vector159
vector159:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $159
8010729d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801072a2:	e9 c3 ef ff ff       	jmp    8010626a <alltraps>

801072a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $160
801072a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801072ae:	e9 b7 ef ff ff       	jmp    8010626a <alltraps>

801072b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $161
801072b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801072ba:	e9 ab ef ff ff       	jmp    8010626a <alltraps>

801072bf <vector162>:
.globl vector162
vector162:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $162
801072c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801072c6:	e9 9f ef ff ff       	jmp    8010626a <alltraps>

801072cb <vector163>:
.globl vector163
vector163:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $163
801072cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801072d2:	e9 93 ef ff ff       	jmp    8010626a <alltraps>

801072d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $164
801072d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801072de:	e9 87 ef ff ff       	jmp    8010626a <alltraps>

801072e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $165
801072e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801072ea:	e9 7b ef ff ff       	jmp    8010626a <alltraps>

801072ef <vector166>:
.globl vector166
vector166:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $166
801072f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801072f6:	e9 6f ef ff ff       	jmp    8010626a <alltraps>

801072fb <vector167>:
.globl vector167
vector167:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $167
801072fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107302:	e9 63 ef ff ff       	jmp    8010626a <alltraps>

80107307 <vector168>:
.globl vector168
vector168:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $168
80107309:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010730e:	e9 57 ef ff ff       	jmp    8010626a <alltraps>

80107313 <vector169>:
.globl vector169
vector169:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $169
80107315:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010731a:	e9 4b ef ff ff       	jmp    8010626a <alltraps>

8010731f <vector170>:
.globl vector170
vector170:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $170
80107321:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107326:	e9 3f ef ff ff       	jmp    8010626a <alltraps>

8010732b <vector171>:
.globl vector171
vector171:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $171
8010732d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107332:	e9 33 ef ff ff       	jmp    8010626a <alltraps>

80107337 <vector172>:
.globl vector172
vector172:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $172
80107339:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010733e:	e9 27 ef ff ff       	jmp    8010626a <alltraps>

80107343 <vector173>:
.globl vector173
vector173:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $173
80107345:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010734a:	e9 1b ef ff ff       	jmp    8010626a <alltraps>

8010734f <vector174>:
.globl vector174
vector174:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $174
80107351:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107356:	e9 0f ef ff ff       	jmp    8010626a <alltraps>

8010735b <vector175>:
.globl vector175
vector175:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $175
8010735d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107362:	e9 03 ef ff ff       	jmp    8010626a <alltraps>

80107367 <vector176>:
.globl vector176
vector176:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $176
80107369:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010736e:	e9 f7 ee ff ff       	jmp    8010626a <alltraps>

80107373 <vector177>:
.globl vector177
vector177:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $177
80107375:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010737a:	e9 eb ee ff ff       	jmp    8010626a <alltraps>

8010737f <vector178>:
.globl vector178
vector178:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $178
80107381:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107386:	e9 df ee ff ff       	jmp    8010626a <alltraps>

8010738b <vector179>:
.globl vector179
vector179:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $179
8010738d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107392:	e9 d3 ee ff ff       	jmp    8010626a <alltraps>

80107397 <vector180>:
.globl vector180
vector180:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $180
80107399:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010739e:	e9 c7 ee ff ff       	jmp    8010626a <alltraps>

801073a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $181
801073a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801073aa:	e9 bb ee ff ff       	jmp    8010626a <alltraps>

801073af <vector182>:
.globl vector182
vector182:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $182
801073b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801073b6:	e9 af ee ff ff       	jmp    8010626a <alltraps>

801073bb <vector183>:
.globl vector183
vector183:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $183
801073bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801073c2:	e9 a3 ee ff ff       	jmp    8010626a <alltraps>

801073c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $184
801073c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801073ce:	e9 97 ee ff ff       	jmp    8010626a <alltraps>

801073d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $185
801073d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801073da:	e9 8b ee ff ff       	jmp    8010626a <alltraps>

801073df <vector186>:
.globl vector186
vector186:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $186
801073e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801073e6:	e9 7f ee ff ff       	jmp    8010626a <alltraps>

801073eb <vector187>:
.globl vector187
vector187:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $187
801073ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801073f2:	e9 73 ee ff ff       	jmp    8010626a <alltraps>

801073f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $188
801073f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801073fe:	e9 67 ee ff ff       	jmp    8010626a <alltraps>

80107403 <vector189>:
.globl vector189
vector189:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $189
80107405:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010740a:	e9 5b ee ff ff       	jmp    8010626a <alltraps>

8010740f <vector190>:
.globl vector190
vector190:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $190
80107411:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107416:	e9 4f ee ff ff       	jmp    8010626a <alltraps>

8010741b <vector191>:
.globl vector191
vector191:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $191
8010741d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107422:	e9 43 ee ff ff       	jmp    8010626a <alltraps>

80107427 <vector192>:
.globl vector192
vector192:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $192
80107429:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010742e:	e9 37 ee ff ff       	jmp    8010626a <alltraps>

80107433 <vector193>:
.globl vector193
vector193:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $193
80107435:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010743a:	e9 2b ee ff ff       	jmp    8010626a <alltraps>

8010743f <vector194>:
.globl vector194
vector194:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $194
80107441:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107446:	e9 1f ee ff ff       	jmp    8010626a <alltraps>

8010744b <vector195>:
.globl vector195
vector195:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $195
8010744d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107452:	e9 13 ee ff ff       	jmp    8010626a <alltraps>

80107457 <vector196>:
.globl vector196
vector196:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $196
80107459:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010745e:	e9 07 ee ff ff       	jmp    8010626a <alltraps>

80107463 <vector197>:
.globl vector197
vector197:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $197
80107465:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010746a:	e9 fb ed ff ff       	jmp    8010626a <alltraps>

8010746f <vector198>:
.globl vector198
vector198:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $198
80107471:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107476:	e9 ef ed ff ff       	jmp    8010626a <alltraps>

8010747b <vector199>:
.globl vector199
vector199:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $199
8010747d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107482:	e9 e3 ed ff ff       	jmp    8010626a <alltraps>

80107487 <vector200>:
.globl vector200
vector200:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $200
80107489:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010748e:	e9 d7 ed ff ff       	jmp    8010626a <alltraps>

80107493 <vector201>:
.globl vector201
vector201:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $201
80107495:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010749a:	e9 cb ed ff ff       	jmp    8010626a <alltraps>

8010749f <vector202>:
.globl vector202
vector202:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $202
801074a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801074a6:	e9 bf ed ff ff       	jmp    8010626a <alltraps>

801074ab <vector203>:
.globl vector203
vector203:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $203
801074ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801074b2:	e9 b3 ed ff ff       	jmp    8010626a <alltraps>

801074b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $204
801074b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801074be:	e9 a7 ed ff ff       	jmp    8010626a <alltraps>

801074c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $205
801074c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801074ca:	e9 9b ed ff ff       	jmp    8010626a <alltraps>

801074cf <vector206>:
.globl vector206
vector206:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $206
801074d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801074d6:	e9 8f ed ff ff       	jmp    8010626a <alltraps>

801074db <vector207>:
.globl vector207
vector207:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $207
801074dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801074e2:	e9 83 ed ff ff       	jmp    8010626a <alltraps>

801074e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $208
801074e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801074ee:	e9 77 ed ff ff       	jmp    8010626a <alltraps>

801074f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $209
801074f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801074fa:	e9 6b ed ff ff       	jmp    8010626a <alltraps>

801074ff <vector210>:
.globl vector210
vector210:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $210
80107501:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107506:	e9 5f ed ff ff       	jmp    8010626a <alltraps>

8010750b <vector211>:
.globl vector211
vector211:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $211
8010750d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107512:	e9 53 ed ff ff       	jmp    8010626a <alltraps>

80107517 <vector212>:
.globl vector212
vector212:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $212
80107519:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010751e:	e9 47 ed ff ff       	jmp    8010626a <alltraps>

80107523 <vector213>:
.globl vector213
vector213:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $213
80107525:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010752a:	e9 3b ed ff ff       	jmp    8010626a <alltraps>

8010752f <vector214>:
.globl vector214
vector214:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $214
80107531:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107536:	e9 2f ed ff ff       	jmp    8010626a <alltraps>

8010753b <vector215>:
.globl vector215
vector215:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $215
8010753d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107542:	e9 23 ed ff ff       	jmp    8010626a <alltraps>

80107547 <vector216>:
.globl vector216
vector216:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $216
80107549:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010754e:	e9 17 ed ff ff       	jmp    8010626a <alltraps>

80107553 <vector217>:
.globl vector217
vector217:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $217
80107555:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010755a:	e9 0b ed ff ff       	jmp    8010626a <alltraps>

8010755f <vector218>:
.globl vector218
vector218:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $218
80107561:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107566:	e9 ff ec ff ff       	jmp    8010626a <alltraps>

8010756b <vector219>:
.globl vector219
vector219:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $219
8010756d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107572:	e9 f3 ec ff ff       	jmp    8010626a <alltraps>

80107577 <vector220>:
.globl vector220
vector220:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $220
80107579:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010757e:	e9 e7 ec ff ff       	jmp    8010626a <alltraps>

80107583 <vector221>:
.globl vector221
vector221:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $221
80107585:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010758a:	e9 db ec ff ff       	jmp    8010626a <alltraps>

8010758f <vector222>:
.globl vector222
vector222:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $222
80107591:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107596:	e9 cf ec ff ff       	jmp    8010626a <alltraps>

8010759b <vector223>:
.globl vector223
vector223:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $223
8010759d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801075a2:	e9 c3 ec ff ff       	jmp    8010626a <alltraps>

801075a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $224
801075a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801075ae:	e9 b7 ec ff ff       	jmp    8010626a <alltraps>

801075b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $225
801075b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801075ba:	e9 ab ec ff ff       	jmp    8010626a <alltraps>

801075bf <vector226>:
.globl vector226
vector226:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $226
801075c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801075c6:	e9 9f ec ff ff       	jmp    8010626a <alltraps>

801075cb <vector227>:
.globl vector227
vector227:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $227
801075cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801075d2:	e9 93 ec ff ff       	jmp    8010626a <alltraps>

801075d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $228
801075d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801075de:	e9 87 ec ff ff       	jmp    8010626a <alltraps>

801075e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $229
801075e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801075ea:	e9 7b ec ff ff       	jmp    8010626a <alltraps>

801075ef <vector230>:
.globl vector230
vector230:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $230
801075f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801075f6:	e9 6f ec ff ff       	jmp    8010626a <alltraps>

801075fb <vector231>:
.globl vector231
vector231:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $231
801075fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107602:	e9 63 ec ff ff       	jmp    8010626a <alltraps>

80107607 <vector232>:
.globl vector232
vector232:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $232
80107609:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010760e:	e9 57 ec ff ff       	jmp    8010626a <alltraps>

80107613 <vector233>:
.globl vector233
vector233:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $233
80107615:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010761a:	e9 4b ec ff ff       	jmp    8010626a <alltraps>

8010761f <vector234>:
.globl vector234
vector234:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $234
80107621:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107626:	e9 3f ec ff ff       	jmp    8010626a <alltraps>

8010762b <vector235>:
.globl vector235
vector235:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $235
8010762d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107632:	e9 33 ec ff ff       	jmp    8010626a <alltraps>

80107637 <vector236>:
.globl vector236
vector236:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $236
80107639:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010763e:	e9 27 ec ff ff       	jmp    8010626a <alltraps>

80107643 <vector237>:
.globl vector237
vector237:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $237
80107645:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010764a:	e9 1b ec ff ff       	jmp    8010626a <alltraps>

8010764f <vector238>:
.globl vector238
vector238:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $238
80107651:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107656:	e9 0f ec ff ff       	jmp    8010626a <alltraps>

8010765b <vector239>:
.globl vector239
vector239:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $239
8010765d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107662:	e9 03 ec ff ff       	jmp    8010626a <alltraps>

80107667 <vector240>:
.globl vector240
vector240:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $240
80107669:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010766e:	e9 f7 eb ff ff       	jmp    8010626a <alltraps>

80107673 <vector241>:
.globl vector241
vector241:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $241
80107675:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010767a:	e9 eb eb ff ff       	jmp    8010626a <alltraps>

8010767f <vector242>:
.globl vector242
vector242:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $242
80107681:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107686:	e9 df eb ff ff       	jmp    8010626a <alltraps>

8010768b <vector243>:
.globl vector243
vector243:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $243
8010768d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107692:	e9 d3 eb ff ff       	jmp    8010626a <alltraps>

80107697 <vector244>:
.globl vector244
vector244:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $244
80107699:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010769e:	e9 c7 eb ff ff       	jmp    8010626a <alltraps>

801076a3 <vector245>:
.globl vector245
vector245:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $245
801076a5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801076aa:	e9 bb eb ff ff       	jmp    8010626a <alltraps>

801076af <vector246>:
.globl vector246
vector246:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $246
801076b1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801076b6:	e9 af eb ff ff       	jmp    8010626a <alltraps>

801076bb <vector247>:
.globl vector247
vector247:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $247
801076bd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801076c2:	e9 a3 eb ff ff       	jmp    8010626a <alltraps>

801076c7 <vector248>:
.globl vector248
vector248:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $248
801076c9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801076ce:	e9 97 eb ff ff       	jmp    8010626a <alltraps>

801076d3 <vector249>:
.globl vector249
vector249:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $249
801076d5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801076da:	e9 8b eb ff ff       	jmp    8010626a <alltraps>

801076df <vector250>:
.globl vector250
vector250:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $250
801076e1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801076e6:	e9 7f eb ff ff       	jmp    8010626a <alltraps>

801076eb <vector251>:
.globl vector251
vector251:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $251
801076ed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801076f2:	e9 73 eb ff ff       	jmp    8010626a <alltraps>

801076f7 <vector252>:
.globl vector252
vector252:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $252
801076f9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801076fe:	e9 67 eb ff ff       	jmp    8010626a <alltraps>

80107703 <vector253>:
.globl vector253
vector253:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $253
80107705:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010770a:	e9 5b eb ff ff       	jmp    8010626a <alltraps>

8010770f <vector254>:
.globl vector254
vector254:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $254
80107711:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107716:	e9 4f eb ff ff       	jmp    8010626a <alltraps>

8010771b <vector255>:
.globl vector255
vector255:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $255
8010771d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107722:	e9 43 eb ff ff       	jmp    8010626a <alltraps>
80107727:	66 90                	xchg   %ax,%ax
80107729:	66 90                	xchg   %ax,%ax
8010772b:	66 90                	xchg   %ax,%ax
8010772d:	66 90                	xchg   %ax,%ax
8010772f:	90                   	nop

80107730 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107730:	55                   	push   %ebp
80107731:	89 e5                	mov    %esp,%ebp
80107733:	57                   	push   %edi
80107734:	56                   	push   %esi
80107735:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107736:	89 d3                	mov    %edx,%ebx
{
80107738:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010773a:	c1 eb 16             	shr    $0x16,%ebx
8010773d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107740:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107743:	8b 06                	mov    (%esi),%eax
80107745:	a8 01                	test   $0x1,%al
80107747:	74 27                	je     80107770 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107749:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010774e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107754:	c1 ef 0a             	shr    $0xa,%edi
}
80107757:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010775a:	89 fa                	mov    %edi,%edx
8010775c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107762:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107765:	5b                   	pop    %ebx
80107766:	5e                   	pop    %esi
80107767:	5f                   	pop    %edi
80107768:	5d                   	pop    %ebp
80107769:	c3                   	ret    
8010776a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107770:	85 c9                	test   %ecx,%ecx
80107772:	74 2c                	je     801077a0 <walkpgdir+0x70>
80107774:	e8 47 ad ff ff       	call   801024c0 <kalloc>
80107779:	85 c0                	test   %eax,%eax
8010777b:	89 c3                	mov    %eax,%ebx
8010777d:	74 21                	je     801077a0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010777f:	83 ec 04             	sub    $0x4,%esp
80107782:	68 00 10 00 00       	push   $0x1000
80107787:	6a 00                	push   $0x0
80107789:	50                   	push   %eax
8010778a:	e8 11 d8 ff ff       	call   80104fa0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010778f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107795:	83 c4 10             	add    $0x10,%esp
80107798:	83 c8 07             	or     $0x7,%eax
8010779b:	89 06                	mov    %eax,(%esi)
8010779d:	eb b5                	jmp    80107754 <walkpgdir+0x24>
8010779f:	90                   	nop
}
801077a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801077a3:	31 c0                	xor    %eax,%eax
}
801077a5:	5b                   	pop    %ebx
801077a6:	5e                   	pop    %esi
801077a7:	5f                   	pop    %edi
801077a8:	5d                   	pop    %ebp
801077a9:	c3                   	ret    
801077aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	57                   	push   %edi
801077b4:	56                   	push   %esi
801077b5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801077b6:	89 d3                	mov    %edx,%ebx
801077b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801077be:	83 ec 1c             	sub    $0x1c,%esp
801077c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801077c4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801077c8:	8b 7d 08             	mov    0x8(%ebp),%edi
801077cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801077d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801077d6:	29 df                	sub    %ebx,%edi
801077d8:	83 c8 01             	or     $0x1,%eax
801077db:	89 45 dc             	mov    %eax,-0x24(%ebp)
801077de:	eb 15                	jmp    801077f5 <mappages+0x45>
    if(*pte & PTE_P)
801077e0:	f6 00 01             	testb  $0x1,(%eax)
801077e3:	75 45                	jne    8010782a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801077e5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801077e8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801077eb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801077ed:	74 31                	je     80107820 <mappages+0x70>
      break;
    a += PGSIZE;
801077ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801077f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077f8:	b9 01 00 00 00       	mov    $0x1,%ecx
801077fd:	89 da                	mov    %ebx,%edx
801077ff:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107802:	e8 29 ff ff ff       	call   80107730 <walkpgdir>
80107807:	85 c0                	test   %eax,%eax
80107809:	75 d5                	jne    801077e0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010780b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010780e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107813:	5b                   	pop    %ebx
80107814:	5e                   	pop    %esi
80107815:	5f                   	pop    %edi
80107816:	5d                   	pop    %ebp
80107817:	c3                   	ret    
80107818:	90                   	nop
80107819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107820:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107823:	31 c0                	xor    %eax,%eax
}
80107825:	5b                   	pop    %ebx
80107826:	5e                   	pop    %esi
80107827:	5f                   	pop    %edi
80107828:	5d                   	pop    %ebp
80107829:	c3                   	ret    
      panic("remap");
8010782a:	83 ec 0c             	sub    $0xc,%esp
8010782d:	68 74 8a 10 80       	push   $0x80108a74
80107832:	e8 59 8b ff ff       	call   80100390 <panic>
80107837:	89 f6                	mov    %esi,%esi
80107839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107840 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107840:	55                   	push   %ebp
80107841:	89 e5                	mov    %esp,%ebp
80107843:	57                   	push   %edi
80107844:	56                   	push   %esi
80107845:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107846:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010784c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010784e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107854:	83 ec 1c             	sub    $0x1c,%esp
80107857:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010785a:	39 d3                	cmp    %edx,%ebx
8010785c:	73 66                	jae    801078c4 <deallocuvm.part.0+0x84>
8010785e:	89 d6                	mov    %edx,%esi
80107860:	eb 3d                	jmp    8010789f <deallocuvm.part.0+0x5f>
80107862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107868:	8b 10                	mov    (%eax),%edx
8010786a:	f6 c2 01             	test   $0x1,%dl
8010786d:	74 26                	je     80107895 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010786f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107875:	74 58                	je     801078cf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107877:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010787a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107880:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107883:	52                   	push   %edx
80107884:	e8 87 aa ff ff       	call   80102310 <kfree>
      *pte = 0;
80107889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010788c:	83 c4 10             	add    $0x10,%esp
8010788f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107895:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010789b:	39 f3                	cmp    %esi,%ebx
8010789d:	73 25                	jae    801078c4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010789f:	31 c9                	xor    %ecx,%ecx
801078a1:	89 da                	mov    %ebx,%edx
801078a3:	89 f8                	mov    %edi,%eax
801078a5:	e8 86 fe ff ff       	call   80107730 <walkpgdir>
    if(!pte)
801078aa:	85 c0                	test   %eax,%eax
801078ac:	75 ba                	jne    80107868 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801078ae:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801078b4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801078ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801078c0:	39 f3                	cmp    %esi,%ebx
801078c2:	72 db                	jb     8010789f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801078c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078ca:	5b                   	pop    %ebx
801078cb:	5e                   	pop    %esi
801078cc:	5f                   	pop    %edi
801078cd:	5d                   	pop    %ebp
801078ce:	c3                   	ret    
        panic("kfree");
801078cf:	83 ec 0c             	sub    $0xc,%esp
801078d2:	68 c6 82 10 80       	push   $0x801082c6
801078d7:	e8 b4 8a ff ff       	call   80100390 <panic>
801078dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801078e0 <seginit>:
{
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801078e6:	e8 95 bf ff ff       	call   80103880 <cpuid>
801078eb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801078f1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801078f6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801078fa:	c7 80 98 38 11 80 ff 	movl   $0xffff,-0x7feec768(%eax)
80107901:	ff 00 00 
80107904:	c7 80 9c 38 11 80 00 	movl   $0xcf9a00,-0x7feec764(%eax)
8010790b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010790e:	c7 80 a0 38 11 80 ff 	movl   $0xffff,-0x7feec760(%eax)
80107915:	ff 00 00 
80107918:	c7 80 a4 38 11 80 00 	movl   $0xcf9200,-0x7feec75c(%eax)
8010791f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107922:	c7 80 a8 38 11 80 ff 	movl   $0xffff,-0x7feec758(%eax)
80107929:	ff 00 00 
8010792c:	c7 80 ac 38 11 80 00 	movl   $0xcffa00,-0x7feec754(%eax)
80107933:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107936:	c7 80 b0 38 11 80 ff 	movl   $0xffff,-0x7feec750(%eax)
8010793d:	ff 00 00 
80107940:	c7 80 b4 38 11 80 00 	movl   $0xcff200,-0x7feec74c(%eax)
80107947:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010794a:	05 90 38 11 80       	add    $0x80113890,%eax
  pd[1] = (uint)p;
8010794f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107953:	c1 e8 10             	shr    $0x10,%eax
80107956:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010795a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010795d:	0f 01 10             	lgdtl  (%eax)
}
80107960:	c9                   	leave  
80107961:	c3                   	ret    
80107962:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107970 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107970:	a1 84 c3 11 80       	mov    0x8011c384,%eax
{
80107975:	55                   	push   %ebp
80107976:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107978:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010797d:	0f 22 d8             	mov    %eax,%cr3
}
80107980:	5d                   	pop    %ebp
80107981:	c3                   	ret    
80107982:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107990 <switchuvm>:
{
80107990:	55                   	push   %ebp
80107991:	89 e5                	mov    %esp,%ebp
80107993:	57                   	push   %edi
80107994:	56                   	push   %esi
80107995:	53                   	push   %ebx
80107996:	83 ec 1c             	sub    $0x1c,%esp
80107999:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010799c:	85 db                	test   %ebx,%ebx
8010799e:	0f 84 cb 00 00 00    	je     80107a6f <switchuvm+0xdf>
  if(p->kstack == 0)
801079a4:	8b 43 08             	mov    0x8(%ebx),%eax
801079a7:	85 c0                	test   %eax,%eax
801079a9:	0f 84 da 00 00 00    	je     80107a89 <switchuvm+0xf9>
  if(p->pgdir == 0)
801079af:	8b 43 04             	mov    0x4(%ebx),%eax
801079b2:	85 c0                	test   %eax,%eax
801079b4:	0f 84 c2 00 00 00    	je     80107a7c <switchuvm+0xec>
  pushcli();
801079ba:	e8 01 d4 ff ff       	call   80104dc0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801079bf:	e8 3c be ff ff       	call   80103800 <mycpu>
801079c4:	89 c6                	mov    %eax,%esi
801079c6:	e8 35 be ff ff       	call   80103800 <mycpu>
801079cb:	89 c7                	mov    %eax,%edi
801079cd:	e8 2e be ff ff       	call   80103800 <mycpu>
801079d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079d5:	83 c7 08             	add    $0x8,%edi
801079d8:	e8 23 be ff ff       	call   80103800 <mycpu>
801079dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801079e0:	83 c0 08             	add    $0x8,%eax
801079e3:	ba 67 00 00 00       	mov    $0x67,%edx
801079e8:	c1 e8 18             	shr    $0x18,%eax
801079eb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801079f2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801079f9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801079ff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a04:	83 c1 08             	add    $0x8,%ecx
80107a07:	c1 e9 10             	shr    $0x10,%ecx
80107a0a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107a10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107a15:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a1c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107a21:	e8 da bd ff ff       	call   80103800 <mycpu>
80107a26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a2d:	e8 ce bd ff ff       	call   80103800 <mycpu>
80107a32:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107a36:	8b 73 08             	mov    0x8(%ebx),%esi
80107a39:	e8 c2 bd ff ff       	call   80103800 <mycpu>
80107a3e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a44:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107a47:	e8 b4 bd ff ff       	call   80103800 <mycpu>
80107a4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107a50:	b8 28 00 00 00       	mov    $0x28,%eax
80107a55:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107a58:	8b 43 04             	mov    0x4(%ebx),%eax
80107a5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a60:	0f 22 d8             	mov    %eax,%cr3
}
80107a63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a66:	5b                   	pop    %ebx
80107a67:	5e                   	pop    %esi
80107a68:	5f                   	pop    %edi
80107a69:	5d                   	pop    %ebp
  popcli();
80107a6a:	e9 91 d3 ff ff       	jmp    80104e00 <popcli>
    panic("switchuvm: no process");
80107a6f:	83 ec 0c             	sub    $0xc,%esp
80107a72:	68 7a 8a 10 80       	push   $0x80108a7a
80107a77:	e8 14 89 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107a7c:	83 ec 0c             	sub    $0xc,%esp
80107a7f:	68 a5 8a 10 80       	push   $0x80108aa5
80107a84:	e8 07 89 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107a89:	83 ec 0c             	sub    $0xc,%esp
80107a8c:	68 90 8a 10 80       	push   $0x80108a90
80107a91:	e8 fa 88 ff ff       	call   80100390 <panic>
80107a96:	8d 76 00             	lea    0x0(%esi),%esi
80107a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107aa0 <inituvm>:
{
80107aa0:	55                   	push   %ebp
80107aa1:	89 e5                	mov    %esp,%ebp
80107aa3:	57                   	push   %edi
80107aa4:	56                   	push   %esi
80107aa5:	53                   	push   %ebx
80107aa6:	83 ec 1c             	sub    $0x1c,%esp
80107aa9:	8b 75 10             	mov    0x10(%ebp),%esi
80107aac:	8b 45 08             	mov    0x8(%ebp),%eax
80107aaf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107ab2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107ab8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107abb:	77 49                	ja     80107b06 <inituvm+0x66>
  mem = kalloc();
80107abd:	e8 fe a9 ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
80107ac2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107ac5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107ac7:	68 00 10 00 00       	push   $0x1000
80107acc:	6a 00                	push   $0x0
80107ace:	50                   	push   %eax
80107acf:	e8 cc d4 ff ff       	call   80104fa0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107ad4:	58                   	pop    %eax
80107ad5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107adb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ae0:	5a                   	pop    %edx
80107ae1:	6a 06                	push   $0x6
80107ae3:	50                   	push   %eax
80107ae4:	31 d2                	xor    %edx,%edx
80107ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ae9:	e8 c2 fc ff ff       	call   801077b0 <mappages>
  memmove(mem, init, sz);
80107aee:	89 75 10             	mov    %esi,0x10(%ebp)
80107af1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107af4:	83 c4 10             	add    $0x10,%esp
80107af7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107afa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107afd:	5b                   	pop    %ebx
80107afe:	5e                   	pop    %esi
80107aff:	5f                   	pop    %edi
80107b00:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107b01:	e9 4a d5 ff ff       	jmp    80105050 <memmove>
    panic("inituvm: more than a page");
80107b06:	83 ec 0c             	sub    $0xc,%esp
80107b09:	68 b9 8a 10 80       	push   $0x80108ab9
80107b0e:	e8 7d 88 ff ff       	call   80100390 <panic>
80107b13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b20 <loaduvm>:
{
80107b20:	55                   	push   %ebp
80107b21:	89 e5                	mov    %esp,%ebp
80107b23:	57                   	push   %edi
80107b24:	56                   	push   %esi
80107b25:	53                   	push   %ebx
80107b26:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107b29:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107b30:	0f 85 91 00 00 00    	jne    80107bc7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107b36:	8b 75 18             	mov    0x18(%ebp),%esi
80107b39:	31 db                	xor    %ebx,%ebx
80107b3b:	85 f6                	test   %esi,%esi
80107b3d:	75 1a                	jne    80107b59 <loaduvm+0x39>
80107b3f:	eb 6f                	jmp    80107bb0 <loaduvm+0x90>
80107b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b48:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107b4e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107b54:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107b57:	76 57                	jbe    80107bb0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107b59:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80107b5f:	31 c9                	xor    %ecx,%ecx
80107b61:	01 da                	add    %ebx,%edx
80107b63:	e8 c8 fb ff ff       	call   80107730 <walkpgdir>
80107b68:	85 c0                	test   %eax,%eax
80107b6a:	74 4e                	je     80107bba <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80107b6c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107b6e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107b71:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107b76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107b7b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107b81:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107b84:	01 d9                	add    %ebx,%ecx
80107b86:	05 00 00 00 80       	add    $0x80000000,%eax
80107b8b:	57                   	push   %edi
80107b8c:	51                   	push   %ecx
80107b8d:	50                   	push   %eax
80107b8e:	ff 75 10             	pushl  0x10(%ebp)
80107b91:	e8 ca 9d ff ff       	call   80101960 <readi>
80107b96:	83 c4 10             	add    $0x10,%esp
80107b99:	39 f8                	cmp    %edi,%eax
80107b9b:	74 ab                	je     80107b48 <loaduvm+0x28>
}
80107b9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ba5:	5b                   	pop    %ebx
80107ba6:	5e                   	pop    %esi
80107ba7:	5f                   	pop    %edi
80107ba8:	5d                   	pop    %ebp
80107ba9:	c3                   	ret    
80107baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107bb3:	31 c0                	xor    %eax,%eax
}
80107bb5:	5b                   	pop    %ebx
80107bb6:	5e                   	pop    %esi
80107bb7:	5f                   	pop    %edi
80107bb8:	5d                   	pop    %ebp
80107bb9:	c3                   	ret    
      panic("loaduvm: address should exist");
80107bba:	83 ec 0c             	sub    $0xc,%esp
80107bbd:	68 d3 8a 10 80       	push   $0x80108ad3
80107bc2:	e8 c9 87 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107bc7:	83 ec 0c             	sub    $0xc,%esp
80107bca:	68 74 8b 10 80       	push   $0x80108b74
80107bcf:	e8 bc 87 ff ff       	call   80100390 <panic>
80107bd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107bda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107be0 <allocuvm>:
{
80107be0:	55                   	push   %ebp
80107be1:	89 e5                	mov    %esp,%ebp
80107be3:	57                   	push   %edi
80107be4:	56                   	push   %esi
80107be5:	53                   	push   %ebx
80107be6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107be9:	8b 7d 10             	mov    0x10(%ebp),%edi
80107bec:	85 ff                	test   %edi,%edi
80107bee:	0f 88 8e 00 00 00    	js     80107c82 <allocuvm+0xa2>
  if(newsz < oldsz)
80107bf4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107bf7:	0f 82 93 00 00 00    	jb     80107c90 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80107bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c00:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107c06:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107c0c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107c0f:	0f 86 7e 00 00 00    	jbe    80107c93 <allocuvm+0xb3>
80107c15:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107c18:	8b 7d 08             	mov    0x8(%ebp),%edi
80107c1b:	eb 42                	jmp    80107c5f <allocuvm+0x7f>
80107c1d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107c20:	83 ec 04             	sub    $0x4,%esp
80107c23:	68 00 10 00 00       	push   $0x1000
80107c28:	6a 00                	push   $0x0
80107c2a:	50                   	push   %eax
80107c2b:	e8 70 d3 ff ff       	call   80104fa0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107c30:	58                   	pop    %eax
80107c31:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107c37:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c3c:	5a                   	pop    %edx
80107c3d:	6a 06                	push   $0x6
80107c3f:	50                   	push   %eax
80107c40:	89 da                	mov    %ebx,%edx
80107c42:	89 f8                	mov    %edi,%eax
80107c44:	e8 67 fb ff ff       	call   801077b0 <mappages>
80107c49:	83 c4 10             	add    $0x10,%esp
80107c4c:	85 c0                	test   %eax,%eax
80107c4e:	78 50                	js     80107ca0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107c50:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c56:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107c59:	0f 86 81 00 00 00    	jbe    80107ce0 <allocuvm+0x100>
    mem = kalloc();
80107c5f:	e8 5c a8 ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
80107c64:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107c66:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107c68:	75 b6                	jne    80107c20 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107c6a:	83 ec 0c             	sub    $0xc,%esp
80107c6d:	68 f1 8a 10 80       	push   $0x80108af1
80107c72:	e8 e9 89 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107c77:	83 c4 10             	add    $0x10,%esp
80107c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c7d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107c80:	77 6e                	ja     80107cf0 <allocuvm+0x110>
}
80107c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107c85:	31 ff                	xor    %edi,%edi
}
80107c87:	89 f8                	mov    %edi,%eax
80107c89:	5b                   	pop    %ebx
80107c8a:	5e                   	pop    %esi
80107c8b:	5f                   	pop    %edi
80107c8c:	5d                   	pop    %ebp
80107c8d:	c3                   	ret    
80107c8e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107c90:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c96:	89 f8                	mov    %edi,%eax
80107c98:	5b                   	pop    %ebx
80107c99:	5e                   	pop    %esi
80107c9a:	5f                   	pop    %edi
80107c9b:	5d                   	pop    %ebp
80107c9c:	c3                   	ret    
80107c9d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107ca0:	83 ec 0c             	sub    $0xc,%esp
80107ca3:	68 09 8b 10 80       	push   $0x80108b09
80107ca8:	e8 b3 89 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107cad:	83 c4 10             	add    $0x10,%esp
80107cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cb3:	39 45 10             	cmp    %eax,0x10(%ebp)
80107cb6:	76 0d                	jbe    80107cc5 <allocuvm+0xe5>
80107cb8:	89 c1                	mov    %eax,%ecx
80107cba:	8b 55 10             	mov    0x10(%ebp),%edx
80107cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80107cc0:	e8 7b fb ff ff       	call   80107840 <deallocuvm.part.0>
      kfree(mem);
80107cc5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107cc8:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107cca:	56                   	push   %esi
80107ccb:	e8 40 a6 ff ff       	call   80102310 <kfree>
      return 0;
80107cd0:	83 c4 10             	add    $0x10,%esp
}
80107cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cd6:	89 f8                	mov    %edi,%eax
80107cd8:	5b                   	pop    %ebx
80107cd9:	5e                   	pop    %esi
80107cda:	5f                   	pop    %edi
80107cdb:	5d                   	pop    %ebp
80107cdc:	c3                   	ret    
80107cdd:	8d 76 00             	lea    0x0(%esi),%esi
80107ce0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ce6:	5b                   	pop    %ebx
80107ce7:	89 f8                	mov    %edi,%eax
80107ce9:	5e                   	pop    %esi
80107cea:	5f                   	pop    %edi
80107ceb:	5d                   	pop    %ebp
80107cec:	c3                   	ret    
80107ced:	8d 76 00             	lea    0x0(%esi),%esi
80107cf0:	89 c1                	mov    %eax,%ecx
80107cf2:	8b 55 10             	mov    0x10(%ebp),%edx
80107cf5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107cf8:	31 ff                	xor    %edi,%edi
80107cfa:	e8 41 fb ff ff       	call   80107840 <deallocuvm.part.0>
80107cff:	eb 92                	jmp    80107c93 <allocuvm+0xb3>
80107d01:	eb 0d                	jmp    80107d10 <deallocuvm>
80107d03:	90                   	nop
80107d04:	90                   	nop
80107d05:	90                   	nop
80107d06:	90                   	nop
80107d07:	90                   	nop
80107d08:	90                   	nop
80107d09:	90                   	nop
80107d0a:	90                   	nop
80107d0b:	90                   	nop
80107d0c:	90                   	nop
80107d0d:	90                   	nop
80107d0e:	90                   	nop
80107d0f:	90                   	nop

80107d10 <deallocuvm>:
{
80107d10:	55                   	push   %ebp
80107d11:	89 e5                	mov    %esp,%ebp
80107d13:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107d19:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107d1c:	39 d1                	cmp    %edx,%ecx
80107d1e:	73 10                	jae    80107d30 <deallocuvm+0x20>
}
80107d20:	5d                   	pop    %ebp
80107d21:	e9 1a fb ff ff       	jmp    80107840 <deallocuvm.part.0>
80107d26:	8d 76 00             	lea    0x0(%esi),%esi
80107d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107d30:	89 d0                	mov    %edx,%eax
80107d32:	5d                   	pop    %ebp
80107d33:	c3                   	ret    
80107d34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107d40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107d40:	55                   	push   %ebp
80107d41:	89 e5                	mov    %esp,%ebp
80107d43:	57                   	push   %edi
80107d44:	56                   	push   %esi
80107d45:	53                   	push   %ebx
80107d46:	83 ec 0c             	sub    $0xc,%esp
80107d49:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107d4c:	85 f6                	test   %esi,%esi
80107d4e:	74 59                	je     80107da9 <freevm+0x69>
80107d50:	31 c9                	xor    %ecx,%ecx
80107d52:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107d57:	89 f0                	mov    %esi,%eax
80107d59:	e8 e2 fa ff ff       	call   80107840 <deallocuvm.part.0>
80107d5e:	89 f3                	mov    %esi,%ebx
80107d60:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107d66:	eb 0f                	jmp    80107d77 <freevm+0x37>
80107d68:	90                   	nop
80107d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d70:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107d73:	39 fb                	cmp    %edi,%ebx
80107d75:	74 23                	je     80107d9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107d77:	8b 03                	mov    (%ebx),%eax
80107d79:	a8 01                	test   $0x1,%al
80107d7b:	74 f3                	je     80107d70 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107d82:	83 ec 0c             	sub    $0xc,%esp
80107d85:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d88:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107d8d:	50                   	push   %eax
80107d8e:	e8 7d a5 ff ff       	call   80102310 <kfree>
80107d93:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d96:	39 fb                	cmp    %edi,%ebx
80107d98:	75 dd                	jne    80107d77 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107d9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107da0:	5b                   	pop    %ebx
80107da1:	5e                   	pop    %esi
80107da2:	5f                   	pop    %edi
80107da3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107da4:	e9 67 a5 ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
80107da9:	83 ec 0c             	sub    $0xc,%esp
80107dac:	68 25 8b 10 80       	push   $0x80108b25
80107db1:	e8 da 85 ff ff       	call   80100390 <panic>
80107db6:	8d 76 00             	lea    0x0(%esi),%esi
80107db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107dc0 <setupkvm>:
{
80107dc0:	55                   	push   %ebp
80107dc1:	89 e5                	mov    %esp,%ebp
80107dc3:	56                   	push   %esi
80107dc4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107dc5:	e8 f6 a6 ff ff       	call   801024c0 <kalloc>
80107dca:	85 c0                	test   %eax,%eax
80107dcc:	89 c6                	mov    %eax,%esi
80107dce:	74 42                	je     80107e12 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107dd0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107dd3:	bb 80 b4 10 80       	mov    $0x8010b480,%ebx
  memset(pgdir, 0, PGSIZE);
80107dd8:	68 00 10 00 00       	push   $0x1000
80107ddd:	6a 00                	push   $0x0
80107ddf:	50                   	push   %eax
80107de0:	e8 bb d1 ff ff       	call   80104fa0 <memset>
80107de5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107de8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107deb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107dee:	83 ec 08             	sub    $0x8,%esp
80107df1:	8b 13                	mov    (%ebx),%edx
80107df3:	ff 73 0c             	pushl  0xc(%ebx)
80107df6:	50                   	push   %eax
80107df7:	29 c1                	sub    %eax,%ecx
80107df9:	89 f0                	mov    %esi,%eax
80107dfb:	e8 b0 f9 ff ff       	call   801077b0 <mappages>
80107e00:	83 c4 10             	add    $0x10,%esp
80107e03:	85 c0                	test   %eax,%eax
80107e05:	78 19                	js     80107e20 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e07:	83 c3 10             	add    $0x10,%ebx
80107e0a:	81 fb c0 b4 10 80    	cmp    $0x8010b4c0,%ebx
80107e10:	75 d6                	jne    80107de8 <setupkvm+0x28>
}
80107e12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e15:	89 f0                	mov    %esi,%eax
80107e17:	5b                   	pop    %ebx
80107e18:	5e                   	pop    %esi
80107e19:	5d                   	pop    %ebp
80107e1a:	c3                   	ret    
80107e1b:	90                   	nop
80107e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107e20:	83 ec 0c             	sub    $0xc,%esp
80107e23:	56                   	push   %esi
      return 0;
80107e24:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107e26:	e8 15 ff ff ff       	call   80107d40 <freevm>
      return 0;
80107e2b:	83 c4 10             	add    $0x10,%esp
}
80107e2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e31:	89 f0                	mov    %esi,%eax
80107e33:	5b                   	pop    %ebx
80107e34:	5e                   	pop    %esi
80107e35:	5d                   	pop    %ebp
80107e36:	c3                   	ret    
80107e37:	89 f6                	mov    %esi,%esi
80107e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e40 <kvmalloc>:
{
80107e40:	55                   	push   %ebp
80107e41:	89 e5                	mov    %esp,%ebp
80107e43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107e46:	e8 75 ff ff ff       	call   80107dc0 <setupkvm>
80107e4b:	a3 84 c3 11 80       	mov    %eax,0x8011c384
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107e50:	05 00 00 00 80       	add    $0x80000000,%eax
80107e55:	0f 22 d8             	mov    %eax,%cr3
}
80107e58:	c9                   	leave  
80107e59:	c3                   	ret    
80107e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107e60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107e60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107e61:	31 c9                	xor    %ecx,%ecx
{
80107e63:	89 e5                	mov    %esp,%ebp
80107e65:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107e68:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e6e:	e8 bd f8 ff ff       	call   80107730 <walkpgdir>
  if(pte == 0)
80107e73:	85 c0                	test   %eax,%eax
80107e75:	74 05                	je     80107e7c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107e77:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107e7a:	c9                   	leave  
80107e7b:	c3                   	ret    
    panic("clearpteu");
80107e7c:	83 ec 0c             	sub    $0xc,%esp
80107e7f:	68 36 8b 10 80       	push   $0x80108b36
80107e84:	e8 07 85 ff ff       	call   80100390 <panic>
80107e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107e90 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107e90:	55                   	push   %ebp
80107e91:	89 e5                	mov    %esp,%ebp
80107e93:	57                   	push   %edi
80107e94:	56                   	push   %esi
80107e95:	53                   	push   %ebx
80107e96:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107e99:	e8 22 ff ff ff       	call   80107dc0 <setupkvm>
80107e9e:	85 c0                	test   %eax,%eax
80107ea0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ea3:	0f 84 9f 00 00 00    	je     80107f48 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107ea9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107eac:	85 c9                	test   %ecx,%ecx
80107eae:	0f 84 94 00 00 00    	je     80107f48 <copyuvm+0xb8>
80107eb4:	31 ff                	xor    %edi,%edi
80107eb6:	eb 4a                	jmp    80107f02 <copyuvm+0x72>
80107eb8:	90                   	nop
80107eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107ec0:	83 ec 04             	sub    $0x4,%esp
80107ec3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107ec9:	68 00 10 00 00       	push   $0x1000
80107ece:	53                   	push   %ebx
80107ecf:	50                   	push   %eax
80107ed0:	e8 7b d1 ff ff       	call   80105050 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107ed5:	58                   	pop    %eax
80107ed6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107edc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ee1:	5a                   	pop    %edx
80107ee2:	ff 75 e4             	pushl  -0x1c(%ebp)
80107ee5:	50                   	push   %eax
80107ee6:	89 fa                	mov    %edi,%edx
80107ee8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107eeb:	e8 c0 f8 ff ff       	call   801077b0 <mappages>
80107ef0:	83 c4 10             	add    $0x10,%esp
80107ef3:	85 c0                	test   %eax,%eax
80107ef5:	78 61                	js     80107f58 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107ef7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107efd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107f00:	76 46                	jbe    80107f48 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107f02:	8b 45 08             	mov    0x8(%ebp),%eax
80107f05:	31 c9                	xor    %ecx,%ecx
80107f07:	89 fa                	mov    %edi,%edx
80107f09:	e8 22 f8 ff ff       	call   80107730 <walkpgdir>
80107f0e:	85 c0                	test   %eax,%eax
80107f10:	74 61                	je     80107f73 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107f12:	8b 00                	mov    (%eax),%eax
80107f14:	a8 01                	test   $0x1,%al
80107f16:	74 4e                	je     80107f66 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107f18:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107f1a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107f1f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107f25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107f28:	e8 93 a5 ff ff       	call   801024c0 <kalloc>
80107f2d:	85 c0                	test   %eax,%eax
80107f2f:	89 c6                	mov    %eax,%esi
80107f31:	75 8d                	jne    80107ec0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107f33:	83 ec 0c             	sub    $0xc,%esp
80107f36:	ff 75 e0             	pushl  -0x20(%ebp)
80107f39:	e8 02 fe ff ff       	call   80107d40 <freevm>
  return 0;
80107f3e:	83 c4 10             	add    $0x10,%esp
80107f41:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107f48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f4e:	5b                   	pop    %ebx
80107f4f:	5e                   	pop    %esi
80107f50:	5f                   	pop    %edi
80107f51:	5d                   	pop    %ebp
80107f52:	c3                   	ret    
80107f53:	90                   	nop
80107f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107f58:	83 ec 0c             	sub    $0xc,%esp
80107f5b:	56                   	push   %esi
80107f5c:	e8 af a3 ff ff       	call   80102310 <kfree>
      goto bad;
80107f61:	83 c4 10             	add    $0x10,%esp
80107f64:	eb cd                	jmp    80107f33 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107f66:	83 ec 0c             	sub    $0xc,%esp
80107f69:	68 5a 8b 10 80       	push   $0x80108b5a
80107f6e:	e8 1d 84 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107f73:	83 ec 0c             	sub    $0xc,%esp
80107f76:	68 40 8b 10 80       	push   $0x80108b40
80107f7b:	e8 10 84 ff ff       	call   80100390 <panic>

80107f80 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107f80:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f81:	31 c9                	xor    %ecx,%ecx
{
80107f83:	89 e5                	mov    %esp,%ebp
80107f85:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107f88:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f8e:	e8 9d f7 ff ff       	call   80107730 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107f93:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107f95:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107f96:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107f98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107f9d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107fa0:	05 00 00 00 80       	add    $0x80000000,%eax
80107fa5:	83 fa 05             	cmp    $0x5,%edx
80107fa8:	ba 00 00 00 00       	mov    $0x0,%edx
80107fad:	0f 45 c2             	cmovne %edx,%eax
}
80107fb0:	c3                   	ret    
80107fb1:	eb 0d                	jmp    80107fc0 <copyout>
80107fb3:	90                   	nop
80107fb4:	90                   	nop
80107fb5:	90                   	nop
80107fb6:	90                   	nop
80107fb7:	90                   	nop
80107fb8:	90                   	nop
80107fb9:	90                   	nop
80107fba:	90                   	nop
80107fbb:	90                   	nop
80107fbc:	90                   	nop
80107fbd:	90                   	nop
80107fbe:	90                   	nop
80107fbf:	90                   	nop

80107fc0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107fc0:	55                   	push   %ebp
80107fc1:	89 e5                	mov    %esp,%ebp
80107fc3:	57                   	push   %edi
80107fc4:	56                   	push   %esi
80107fc5:	53                   	push   %ebx
80107fc6:	83 ec 1c             	sub    $0x1c,%esp
80107fc9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107fcf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107fd2:	85 db                	test   %ebx,%ebx
80107fd4:	75 40                	jne    80108016 <copyout+0x56>
80107fd6:	eb 70                	jmp    80108048 <copyout+0x88>
80107fd8:	90                   	nop
80107fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107fe3:	89 f1                	mov    %esi,%ecx
80107fe5:	29 d1                	sub    %edx,%ecx
80107fe7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107fed:	39 d9                	cmp    %ebx,%ecx
80107fef:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107ff2:	29 f2                	sub    %esi,%edx
80107ff4:	83 ec 04             	sub    $0x4,%esp
80107ff7:	01 d0                	add    %edx,%eax
80107ff9:	51                   	push   %ecx
80107ffa:	57                   	push   %edi
80107ffb:	50                   	push   %eax
80107ffc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107fff:	e8 4c d0 ff ff       	call   80105050 <memmove>
    len -= n;
    buf += n;
80108004:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80108007:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010800a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80108010:	01 cf                	add    %ecx,%edi
  while(len > 0){
80108012:	29 cb                	sub    %ecx,%ebx
80108014:	74 32                	je     80108048 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108016:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108018:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010801b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010801e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108024:	56                   	push   %esi
80108025:	ff 75 08             	pushl  0x8(%ebp)
80108028:	e8 53 ff ff ff       	call   80107f80 <uva2ka>
    if(pa0 == 0)
8010802d:	83 c4 10             	add    $0x10,%esp
80108030:	85 c0                	test   %eax,%eax
80108032:	75 ac                	jne    80107fe0 <copyout+0x20>
  }
  return 0;
}
80108034:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010803c:	5b                   	pop    %ebx
8010803d:	5e                   	pop    %esi
8010803e:	5f                   	pop    %edi
8010803f:	5d                   	pop    %ebp
80108040:	c3                   	ret    
80108041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108048:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010804b:	31 c0                	xor    %eax,%eax
}
8010804d:	5b                   	pop    %ebx
8010804e:	5e                   	pop    %esi
8010804f:	5f                   	pop    %edi
80108050:	5d                   	pop    %ebp
80108051:	c3                   	ret    
