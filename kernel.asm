
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
8010004c:	68 60 7f 10 80       	push   $0x80107f60
80100051:	68 60 c6 10 80       	push   $0x8010c660
80100056:	e8 e5 4b 00 00       	call   80104c40 <initlock>
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
80100092:	68 67 7f 10 80       	push   $0x80107f67
80100097:	50                   	push   %eax
80100098:	e8 73 4a 00 00       	call   80104b10 <initsleeplock>
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
801000e4:	e8 97 4c 00 00       	call   80104d80 <acquire>
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
80100162:	e8 d9 4c 00 00       	call   80104e40 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 49 00 00       	call   80104b50 <acquiresleep>
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
80100193:	68 6e 7f 10 80       	push   $0x80107f6e
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
801001ae:	e8 3d 4a 00 00       	call   80104bf0 <holdingsleep>
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
801001cc:	68 7f 7f 10 80       	push   $0x80107f7f
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
801001ef:	e8 fc 49 00 00       	call   80104bf0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 49 00 00       	call   80104bb0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010020b:	e8 70 4b 00 00       	call   80104d80 <acquire>
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
8010025c:	e9 df 4b 00 00       	jmp    80104e40 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 7f 10 80       	push   $0x80107f86
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
8010028c:	e8 ef 4a 00 00       	call   80104d80 <acquire>
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
801002c5:	e8 36 42 00 00       	call   80104500 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 40 10 11 80    	mov    0x80111040,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 44 10 11 80    	cmp    0x80111044,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 10 36 00 00       	call   801038f0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 80 b5 10 80       	push   $0x8010b580
801002ef:	e8 4c 4b 00 00       	call   80104e40 <release>
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
8010034d:	e8 ee 4a 00 00       	call   80104e40 <release>
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
801003b2:	68 8d 7f 10 80       	push   $0x80107f8d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 93 89 10 80 	movl   $0x80108993,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 83 48 00 00       	call   80104c60 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 a1 7f 10 80       	push   $0x80107fa1
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
8010043a:	e8 21 67 00 00       	call   80106b60 <uartputc>
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
801004ec:	e8 6f 66 00 00       	call   80106b60 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 63 66 00 00       	call   80106b60 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 57 66 00 00       	call   80106b60 <uartputc>
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
80100524:	e8 17 4a 00 00       	call   80104f40 <memmove>
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
80100541:	e8 4a 49 00 00       	call   80104e90 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 a5 7f 10 80       	push   $0x80107fa5
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
801005b1:	0f b6 92 d0 7f 10 80 	movzbl -0x7fef8030(%edx),%edx
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
8010061b:	e8 60 47 00 00       	call   80104d80 <acquire>
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
80100647:	e8 f4 47 00 00       	call   80104e40 <release>
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
8010071f:	e8 1c 47 00 00       	call   80104e40 <release>
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
801007d0:	ba b8 7f 10 80       	mov    $0x80107fb8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 80 b5 10 80       	push   $0x8010b580
801007f0:	e8 8b 45 00 00       	call   80104d80 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 bf 7f 10 80       	push   $0x80107fbf
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
80100823:	e8 58 45 00 00       	call   80104d80 <acquire>
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
80100888:	e8 b3 45 00 00       	call   80104e40 <release>
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
80100916:	e8 c5 3e 00 00       	call   801047e0 <wakeup>
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
80100997:	e9 24 3f 00 00       	jmp    801048c0 <procdump>
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
801009c6:	68 c8 7f 10 80       	push   $0x80107fc8
801009cb:	68 80 b5 10 80       	push   $0x8010b580
801009d0:	e8 6b 42 00 00       	call   80104c40 <initlock>

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
80100a1c:	e8 cf 2e 00 00       	call   801038f0 <myproc>
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
80100a94:	e8 17 72 00 00       	call   80107cb0 <setupkvm>
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
80100af6:	e8 d5 6f 00 00       	call   80107ad0 <allocuvm>
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
80100b28:	e8 e3 6e 00 00       	call   80107a10 <loaduvm>
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
80100b72:	e8 b9 70 00 00       	call   80107c30 <freevm>
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
80100baa:	e8 21 6f 00 00       	call   80107ad0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 6a 70 00 00       	call   80107c30 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 e1 7f 10 80       	push   $0x80107fe1
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
80100c06:	e8 45 71 00 00       	call   80107d50 <clearpteu>
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
80100c39:	e8 72 44 00 00       	call   801050b0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 5f 44 00 00       	call   801050b0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 4e 72 00 00       	call   80107eb0 <copyout>
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
80100cc7:	e8 e4 71 00 00       	call   80107eb0 <copyout>
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
80100d0a:	e8 61 43 00 00       	call   80105070 <safestrcpy>
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
80100d34:	e8 47 6b 00 00       	call   80107880 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 ef 6e 00 00       	call   80107c30 <freevm>
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
80100d66:	68 ed 7f 10 80       	push   $0x80107fed
80100d6b:	68 60 10 11 80       	push   $0x80111060
80100d70:	e8 cb 3e 00 00       	call   80104c40 <initlock>
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
80100d91:	e8 ea 3f 00 00       	call   80104d80 <acquire>
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
80100dc1:	e8 7a 40 00 00       	call   80104e40 <release>
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
80100dda:	e8 61 40 00 00       	call   80104e40 <release>
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
80100dff:	e8 7c 3f 00 00       	call   80104d80 <acquire>
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
80100e1c:	e8 1f 40 00 00       	call   80104e40 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 f4 7f 10 80       	push   $0x80107ff4
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
80100e51:	e8 2a 3f 00 00       	call   80104d80 <acquire>
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
80100e7c:	e9 bf 3f 00 00       	jmp    80104e40 <release>
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
80100ea8:	e8 93 3f 00 00       	call   80104e40 <release>
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
80100f02:	68 fc 7f 10 80       	push   $0x80107ffc
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
80100fe2:	68 06 80 10 80       	push   $0x80108006
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
801010f5:	68 0f 80 10 80       	push   $0x8010800f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 15 80 10 80       	push   $0x80108015
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
80101173:	68 1f 80 10 80       	push   $0x8010801f
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
80101224:	68 32 80 10 80       	push   $0x80108032
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
80101265:	e8 26 3c 00 00       	call   80104e90 <memset>
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
801012aa:	e8 d1 3a 00 00       	call   80104d80 <acquire>
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
8010130f:	e8 2c 3b 00 00       	call   80104e40 <release>

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
8010133d:	e8 fe 3a 00 00       	call   80104e40 <release>
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
80101352:	68 48 80 10 80       	push   $0x80108048
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
80101427:	68 58 80 10 80       	push   $0x80108058
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
80101461:	e8 da 3a 00 00       	call   80104f40 <memmove>
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
8010148c:	68 6b 80 10 80       	push   $0x8010806b
80101491:	68 80 1a 11 80       	push   $0x80111a80
80101496:	e8 a5 37 00 00       	call   80104c40 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 72 80 10 80       	push   $0x80108072
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 5c 36 00 00       	call   80104b10 <initsleeplock>
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
801014f9:	68 d8 80 10 80       	push   $0x801080d8
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
8010158e:	e8 fd 38 00 00       	call   80104e90 <memset>
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
801015c3:	68 78 80 10 80       	push   $0x80108078
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
80101631:	e8 0a 39 00 00       	call   80104f40 <memmove>
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
8010165f:	e8 1c 37 00 00       	call   80104d80 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
8010166f:	e8 cc 37 00 00       	call   80104e40 <release>
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
801016a2:	e8 a9 34 00 00       	call   80104b50 <acquiresleep>
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
80101718:	e8 23 38 00 00       	call   80104f40 <memmove>
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
8010173d:	68 90 80 10 80       	push   $0x80108090
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 8a 80 10 80       	push   $0x8010808a
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
80101773:	e8 78 34 00 00       	call   80104bf0 <holdingsleep>
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
8010178f:	e9 1c 34 00 00       	jmp    80104bb0 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 9f 80 10 80       	push   $0x8010809f
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
801017c0:	e8 8b 33 00 00       	call   80104b50 <acquiresleep>
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
801017da:	e8 d1 33 00 00       	call   80104bb0 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
801017e6:	e8 95 35 00 00       	call   80104d80 <acquire>
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
80101800:	e9 3b 36 00 00       	jmp    80104e40 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 80 1a 11 80       	push   $0x80111a80
80101810:	e8 6b 35 00 00       	call   80104d80 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
8010181f:	e8 1c 36 00 00       	call   80104e40 <release>
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
80101a07:	e8 34 35 00 00       	call   80104f40 <memmove>
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
80101b03:	e8 38 34 00 00       	call   80104f40 <memmove>
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
80101b9e:	e8 0d 34 00 00       	call   80104fb0 <strncmp>
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
80101bfd:	e8 ae 33 00 00       	call   80104fb0 <strncmp>
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
80101c42:	68 b9 80 10 80       	push   $0x801080b9
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 a7 80 10 80       	push   $0x801080a7
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
80101c79:	e8 72 1c 00 00       	call   801038f0 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c84:	68 80 1a 11 80       	push   $0x80111a80
80101c89:	e8 f2 30 00 00       	call   80104d80 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101c99:	e8 a2 31 00 00       	call   80104e40 <release>
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
80101cf5:	e8 46 32 00 00       	call   80104f40 <memmove>
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
80101d88:	e8 b3 31 00 00       	call   80104f40 <memmove>
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
80101e7d:	e8 8e 31 00 00       	call   80105010 <strncpy>
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
80101ebb:	68 c8 80 10 80       	push   $0x801080c8
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 6a 87 10 80       	push   $0x8010876a
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
80101fdb:	68 34 81 10 80       	push   $0x80108134
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 2b 81 10 80       	push   $0x8010812b
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102006:	68 46 81 10 80       	push   $0x80108146
8010200b:	68 e0 b5 10 80       	push   $0x8010b5e0
80102010:	e8 2b 2c 00 00       	call   80104c40 <initlock>
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
8010208e:	e8 ed 2c 00 00       	call   80104d80 <acquire>

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
801020f1:	e8 ea 26 00 00       	call   801047e0 <wakeup>

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
8010210f:	e8 2c 2d 00 00       	call   80104e40 <release>

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
8010212e:	e8 bd 2a 00 00       	call   80104bf0 <holdingsleep>
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
80102168:	e8 13 2c 00 00       	call   80104d80 <acquire>

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
801021b9:	e8 42 23 00 00       	call   80104500 <sleep>
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
801021d6:	e9 65 2c 00 00       	jmp    80104e40 <release>
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
801021fa:	68 60 81 10 80       	push   $0x80108160
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 4a 81 10 80       	push   $0x8010814a
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 75 81 10 80       	push   $0x80108175
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
80102267:	68 94 81 10 80       	push   $0x80108194
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
80102322:	81 fb 88 c9 11 80    	cmp    $0x8011c988,%ebx
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
80102342:	e8 49 2b 00 00       	call   80104e90 <memset>

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
8010237b:	e9 c0 2a 00 00       	jmp    80104e40 <release>
    acquire(&kmem.lock);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 e0 36 11 80       	push   $0x801136e0
80102388:	e8 f3 29 00 00       	call   80104d80 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
    panic("kfree");
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 c6 81 10 80       	push   $0x801081c6
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
801023fb:	68 cc 81 10 80       	push   $0x801081cc
80102400:	68 e0 36 11 80       	push   $0x801136e0
80102405:	e8 36 28 00 00       	call   80104c40 <initlock>
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
801024f3:	e8 88 28 00 00       	call   80104d80 <acquire>
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
80102521:	e8 1a 29 00 00       	call   80104e40 <release>
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
80102573:	0f b6 82 00 83 10 80 	movzbl -0x7fef7d00(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010257c:	0f b6 82 00 82 10 80 	movzbl -0x7fef7e00(%edx),%eax
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
80102593:	8b 04 85 e0 81 10 80 	mov    -0x7fef7e20(,%eax,4),%eax
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
801025b8:	0f b6 82 00 83 10 80 	movzbl -0x7fef7d00(%edx),%eax
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
80102937:	e8 a4 25 00 00       	call   80104ee0 <memcmp>
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
80102a64:	e8 d7 24 00 00       	call   80104f40 <memmove>
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
80102b0a:	68 00 84 10 80       	push   $0x80108400
80102b0f:	68 20 37 11 80       	push   $0x80113720
80102b14:	e8 27 21 00 00       	call   80104c40 <initlock>
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
80102bab:	e8 d0 21 00 00       	call   80104d80 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 20 37 11 80       	push   $0x80113720
80102bc0:	68 20 37 11 80       	push   $0x80113720
80102bc5:	e8 36 19 00 00       	call   80104500 <sleep>
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
80102bfc:	e8 3f 22 00 00       	call   80104e40 <release>
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
80102c1e:	e8 5d 21 00 00       	call   80104d80 <acquire>
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
80102c5c:	e8 df 21 00 00       	call   80104e40 <release>
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
80102cb6:	e8 85 22 00 00       	call   80104f40 <memmove>
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
80102cff:	e8 7c 20 00 00       	call   80104d80 <acquire>
    wakeup(&log);
80102d04:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
    log.committing = 0;
80102d0b:	c7 05 60 37 11 80 00 	movl   $0x0,0x80113760
80102d12:	00 00 00 
    wakeup(&log);
80102d15:	e8 c6 1a 00 00       	call   801047e0 <wakeup>
    release(&log.lock);
80102d1a:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80102d21:	e8 1a 21 00 00       	call   80104e40 <release>
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
80102d40:	e8 9b 1a 00 00       	call   801047e0 <wakeup>
  release(&log.lock);
80102d45:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80102d4c:	e8 ef 20 00 00       	call   80104e40 <release>
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
80102d5f:	68 04 84 10 80       	push   $0x80108404
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
80102dae:	e8 cd 1f 00 00       	call   80104d80 <acquire>
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
80102dfd:	e9 3e 20 00 00       	jmp    80104e40 <release>
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
80102e29:	68 13 84 10 80       	push   $0x80108413
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 29 84 10 80       	push   $0x80108429
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
80102e47:	e8 84 0a 00 00       	call   801038d0 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 7d 0a 00 00       	call   801038d0 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 44 84 10 80       	push   $0x80108444
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e62:	e8 b9 33 00 00       	call   80106220 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e67:	e8 e4 09 00 00       	call   80103850 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7a:	e8 41 12 00 00       	call   801040c0 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 d5 49 00 00       	call   80107860 <switchkvm>
  seginit();
80102e8b:	e8 40 49 00 00       	call   801077d0 <seginit>
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
80102eb7:	68 88 c9 11 80       	push   $0x8011c988
80102ebc:	e8 2f f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102ec1:	e8 6a 4e 00 00       	call   80107d30 <kvmalloc>
  mpinit();        // detect other processors
80102ec6:	e8 75 01 00 00       	call   80103040 <mpinit>
  lapicinit();     // interrupt controller
80102ecb:	e8 60 f7 ff ff       	call   80102630 <lapicinit>
  seginit();       // segment descriptors
80102ed0:	e8 fb 48 00 00       	call   801077d0 <seginit>
  picinit();       // disable pic
80102ed5:	e8 46 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102eda:	e8 41 f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102edf:	e8 dc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ee4:	e8 b7 3b 00 00       	call   80106aa0 <uartinit>
  pinit();         // process table
80102ee9:	e8 42 09 00 00       	call   80103830 <pinit>
  tvinit();        // trap vectors
80102eee:	e8 ad 32 00 00       	call   801061a0 <tvinit>
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
80102f14:	e8 27 20 00 00       	call   80104f40 <memmove>

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
80102f40:	e8 0b 09 00 00       	call   80103850 <mycpu>
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
80102fb5:	e8 36 0d 00 00       	call   80103cf0 <userinit>
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
80102fee:	68 58 84 10 80       	push   $0x80108458
80102ff3:	56                   	push   %esi
80102ff4:	e8 e7 1e 00 00       	call   80104ee0 <memcmp>
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
801030ac:	68 75 84 10 80       	push   $0x80108475
801030b1:	56                   	push   %esi
801030b2:	e8 29 1e 00 00       	call   80104ee0 <memcmp>
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
80103140:	ff 24 95 9c 84 10 80 	jmp    *-0x7fef7b64(,%edx,4)
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
801031f3:	68 5d 84 10 80       	push   $0x8010845d
801031f8:	e8 93 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801031fd:	83 ec 0c             	sub    $0xc,%esp
80103200:	68 7c 84 10 80       	push   $0x8010847c
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
801032fb:	68 b0 84 10 80       	push   $0x801084b0
80103300:	50                   	push   %eax
80103301:	e8 3a 19 00 00       	call   80104c40 <initlock>
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
8010335f:	e8 1c 1a 00 00       	call   80104d80 <acquire>
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
8010337f:	e8 5c 14 00 00       	call   801047e0 <wakeup>
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
801033a4:	e9 97 1a 00 00       	jmp    80104e40 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c0:	00 00 00 
    wakeup(&p->nwrite);
801033c3:	50                   	push   %eax
801033c4:	e8 17 14 00 00       	call   801047e0 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 67 1a 00 00       	call   80104e40 <release>
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
801033fd:	e8 7e 19 00 00       	call   80104d80 <acquire>
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
80103454:	e8 87 13 00 00       	call   801047e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103459:	5a                   	pop    %edx
8010345a:	59                   	pop    %ecx
8010345b:	53                   	push   %ebx
8010345c:	56                   	push   %esi
8010345d:	e8 9e 10 00 00       	call   80104500 <sleep>
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
80103484:	e8 67 04 00 00       	call   801038f0 <myproc>
80103489:	8b 40 24             	mov    0x24(%eax),%eax
8010348c:	85 c0                	test   %eax,%eax
8010348e:	74 c0                	je     80103450 <pipewrite+0x60>
        release(&p->lock);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 a7 19 00 00       	call   80104e40 <release>
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
801034e3:	e8 f8 12 00 00       	call   801047e0 <wakeup>
  release(&p->lock);
801034e8:	89 1c 24             	mov    %ebx,(%esp)
801034eb:	e8 50 19 00 00       	call   80104e40 <release>
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
80103510:	e8 6b 18 00 00       	call   80104d80 <acquire>
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
80103545:	e8 b6 0f 00 00       	call   80104500 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010354a:	83 c4 10             	add    $0x10,%esp
8010354d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103553:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103559:	75 35                	jne    80103590 <piperead+0x90>
8010355b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	0f 84 8f 00 00 00    	je     801035f8 <piperead+0xf8>
    if(myproc()->killed){
80103569:	e8 82 03 00 00       	call   801038f0 <myproc>
8010356e:	8b 48 24             	mov    0x24(%eax),%ecx
80103571:	85 c9                	test   %ecx,%ecx
80103573:	74 cb                	je     80103540 <piperead+0x40>
      release(&p->lock);
80103575:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103578:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010357d:	56                   	push   %esi
8010357e:	e8 bd 18 00 00       	call   80104e40 <release>
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
801035d7:	e8 04 12 00 00       	call   801047e0 <wakeup>
  release(&p->lock);
801035dc:	89 34 24             	mov    %esi,(%esp)
801035df:	e8 5c 18 00 00       	call   80104e40 <release>
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
80103604:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
80103607:	68 60 7c 11 80       	push   $0x80117c60
8010360c:	e8 6f 17 00 00       	call   80104d80 <acquire>
80103611:	83 c4 10             	add    $0x10,%esp

    struct proc_stat *pp = ptable.stat;
80103614:	ba 94 a8 11 80       	mov    $0x8011a894,%edx

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103619:	b8 94 7c 11 80       	mov    $0x80117c94,%eax
8010361e:	66 90                	xchg   %ax,%ax
        pp->pid = &p->pid;
80103620:	8d 48 10             	lea    0x10(%eax),%ecx
        pp->num_run = &p->num_run;
        pp->current_queue = &p->qno;
        for (int ii = 0; ii < 5; ii++) {
            pp->ticks[ii] = &p->tick[ii];
        }
        ++pp;
80103623:	83 c2 24             	add    $0x24,%edx
        pp->pid = &p->pid;
80103626:	89 4a dc             	mov    %ecx,-0x24(%edx)
        pp->runtime = &p->rtime;
80103629:	8d 88 80 00 00 00    	lea    0x80(%eax),%ecx
8010362f:	89 4a e0             	mov    %ecx,-0x20(%edx)
        pp->num_run = &p->num_run;
80103632:	8d 88 94 00 00 00    	lea    0x94(%eax),%ecx
80103638:	89 4a e4             	mov    %ecx,-0x1c(%edx)
        pp->current_queue = &p->qno;
8010363b:	8d 88 90 00 00 00    	lea    0x90(%eax),%ecx
80103641:	89 4a e8             	mov    %ecx,-0x18(%edx)
            pp->ticks[ii] = &p->tick[ii];
80103644:	8d 88 98 00 00 00    	lea    0x98(%eax),%ecx
8010364a:	89 4a ec             	mov    %ecx,-0x14(%edx)
8010364d:	8d 88 9c 00 00 00    	lea    0x9c(%eax),%ecx
80103653:	89 4a f0             	mov    %ecx,-0x10(%edx)
80103656:	8d 88 a0 00 00 00    	lea    0xa0(%eax),%ecx
8010365c:	89 4a f4             	mov    %ecx,-0xc(%edx)
8010365f:	8d 88 a4 00 00 00    	lea    0xa4(%eax),%ecx
80103665:	89 4a f8             	mov    %ecx,-0x8(%edx)
80103668:	8d 88 a8 00 00 00    	lea    0xa8(%eax),%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010366e:	05 b0 00 00 00       	add    $0xb0,%eax
            pp->ticks[ii] = &p->tick[ii];
80103673:	89 4a fc             	mov    %ecx,-0x4(%edx)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103676:	3d 94 a8 11 80       	cmp    $0x8011a894,%eax
8010367b:	72 a3                	jb     80103620 <allocproc+0x20>
    }

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010367d:	bb 94 7c 11 80       	mov    $0x80117c94,%ebx
80103682:	eb 16                	jmp    8010369a <allocproc+0x9a>
80103684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103688:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010368e:	81 fb 94 a8 11 80    	cmp    $0x8011a894,%ebx
80103694:	0f 83 13 01 00 00    	jae    801037ad <allocproc+0x1ad>
        if (p->state == UNUSED)
8010369a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010369d:	85 c0                	test   %eax,%eax
8010369f:	75 e7                	jne    80103688 <allocproc+0x88>
    return 0;

found:
    p->state = EMBRYO;
    p->priority = 60;  // default priority value
    p->pid = nextpid++;
801036a1:	a1 60 b0 10 80       	mov    0x8010b060,%eax
    }
    // pushq(&q0, &p, &end0);
    q0[cnt[0]] = p;
    end0 += 1;
    cnt[0]++;
    release(&ptable.lock);
801036a6:	83 ec 0c             	sub    $0xc,%esp
    p->state = EMBRYO;
801036a9:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->priority = 60;  // default priority value
801036b0:	c7 83 8c 00 00 00 3c 	movl   $0x3c,0x8c(%ebx)
801036b7:	00 00 00 
    p->qno = 0;
801036ba:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
801036c1:	00 00 00 
    p->num_run = 0;
801036c4:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
801036cb:	00 00 00 
        p->tick[j] = 0;
801036ce:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
801036d5:	00 00 00 
    p->pid = nextpid++;
801036d8:	8d 50 01             	lea    0x1(%eax),%edx
801036db:	89 43 10             	mov    %eax,0x10(%ebx)
    q0[cnt[0]] = p;
801036de:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
        p->tick[j] = 0;
801036e3:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
801036ea:	00 00 00 
801036ed:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
801036f4:	00 00 00 
801036f7:	c7 83 a4 00 00 00 00 	movl   $0x0,0xa4(%ebx)
801036fe:	00 00 00 
80103701:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
80103708:	00 00 00 
    release(&ptable.lock);
8010370b:	68 60 7c 11 80       	push   $0x80117c60
    q0[cnt[0]] = p;
80103710:	89 1c 85 c0 6c 11 80 	mov    %ebx,-0x7fee9340(,%eax,4)
    cnt[0]++;
80103717:	83 c0 01             	add    $0x1,%eax
    p->pid = nextpid++;
8010371a:	89 15 60 b0 10 80    	mov    %edx,0x8010b060
    end0 += 1;
80103720:	83 05 40 b6 10 80 01 	addl   $0x1,0x8010b640
    cnt[0]++;
80103727:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    release(&ptable.lock);
8010372c:	e8 0f 17 00 00       	call   80104e40 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
80103731:	e8 8a ed ff ff       	call   801024c0 <kalloc>
80103736:	83 c4 10             	add    $0x10,%esp
80103739:	85 c0                	test   %eax,%eax
8010373b:	89 43 08             	mov    %eax,0x8(%ebx)
8010373e:	0f 84 82 00 00 00    	je     801037c6 <allocproc+0x1c6>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80103744:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *)sp;
    memset(p->context, 0, sizeof *p->context);
8010374a:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
8010374d:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
80103752:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint *)sp = (uint)trapret;
80103755:	c7 40 14 92 61 10 80 	movl   $0x80106192,0x14(%eax)
    p->context = (struct context *)sp;
8010375c:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
8010375f:	6a 14                	push   $0x14
80103761:	6a 00                	push   $0x0
80103763:	50                   	push   %eax
80103764:	e8 27 17 00 00       	call   80104e90 <memset>
    p->context->eip = (uint)forkret;
80103769:	8b 43 1c             	mov    0x1c(%ebx),%eax
    p->rtime = 0;
    p->etime = 0;
    p->iotime = 0;
    p->aging_time = 0;

    return p;
8010376c:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
8010376f:	c7 40 10 e0 37 10 80 	movl   $0x801037e0,0x10(%eax)
    p->ctime = ticks;
80103776:	a1 80 c9 11 80       	mov    0x8011c980,%eax
    p->rtime = 0;
8010377b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103782:	00 00 00 
    p->etime = 0;
80103785:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010378c:	00 00 00 
    p->iotime = 0;
8010378f:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103796:	00 00 00 
    p->aging_time = 0;
80103799:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801037a0:	00 00 00 
    p->ctime = ticks;
801037a3:	89 43 7c             	mov    %eax,0x7c(%ebx)
}
801037a6:	89 d8                	mov    %ebx,%eax
801037a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037ab:	c9                   	leave  
801037ac:	c3                   	ret    
    release(&ptable.lock);
801037ad:	83 ec 0c             	sub    $0xc,%esp
    return 0;
801037b0:	31 db                	xor    %ebx,%ebx
    release(&ptable.lock);
801037b2:	68 60 7c 11 80       	push   $0x80117c60
801037b7:	e8 84 16 00 00       	call   80104e40 <release>
}
801037bc:	89 d8                	mov    %ebx,%eax
    return 0;
801037be:	83 c4 10             	add    $0x10,%esp
}
801037c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037c4:	c9                   	leave  
801037c5:	c3                   	ret    
        p->state = UNUSED;
801037c6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
801037cd:	31 db                	xor    %ebx,%ebx
}
801037cf:	89 d8                	mov    %ebx,%eax
801037d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037d4:	c9                   	leave  
801037d5:	c3                   	ret    
801037d6:	8d 76 00             	lea    0x0(%esi),%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037e0 <forkret>:
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void) {
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
801037e6:	68 60 7c 11 80       	push   $0x80117c60
801037eb:	e8 50 16 00 00       	call   80104e40 <release>

    if (first) {
801037f0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801037f5:	83 c4 10             	add    $0x10,%esp
801037f8:	85 c0                	test   %eax,%eax
801037fa:	75 04                	jne    80103800 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
801037fc:	c9                   	leave  
801037fd:	c3                   	ret    
801037fe:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
80103800:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
80103803:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010380a:	00 00 00 
        iinit(ROOTDEV);
8010380d:	6a 01                	push   $0x1
8010380f:	e8 6c dc ff ff       	call   80101480 <iinit>
        initlog(ROOTDEV);
80103814:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010381b:	e8 e0 f2 ff ff       	call   80102b00 <initlog>
80103820:	83 c4 10             	add    $0x10,%esp
}
80103823:	c9                   	leave  
80103824:	c3                   	ret    
80103825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103830 <pinit>:
void pinit(void) {
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
80103836:	68 b5 84 10 80       	push   $0x801084b5
8010383b:	68 60 7c 11 80       	push   $0x80117c60
80103840:	e8 fb 13 00 00       	call   80104c40 <initlock>
}
80103845:	83 c4 10             	add    $0x10,%esp
80103848:	c9                   	leave  
80103849:	c3                   	ret    
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103850 <mycpu>:
struct cpu *mycpu(void) {
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	56                   	push   %esi
80103854:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103855:	9c                   	pushf  
80103856:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103857:	f6 c4 02             	test   $0x2,%ah
8010385a:	75 5e                	jne    801038ba <mycpu+0x6a>
    apicid = lapicid();
8010385c:	e8 cf ee ff ff       	call   80102730 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103861:	8b 35 a0 3d 11 80    	mov    0x80113da0,%esi
80103867:	85 f6                	test   %esi,%esi
80103869:	7e 42                	jle    801038ad <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
8010386b:	0f b6 15 20 38 11 80 	movzbl 0x80113820,%edx
80103872:	39 d0                	cmp    %edx,%eax
80103874:	74 30                	je     801038a6 <mycpu+0x56>
80103876:	b9 d0 38 11 80       	mov    $0x801138d0,%ecx
    for (i = 0; i < ncpu; ++i) {
8010387b:	31 d2                	xor    %edx,%edx
8010387d:	8d 76 00             	lea    0x0(%esi),%esi
80103880:	83 c2 01             	add    $0x1,%edx
80103883:	39 f2                	cmp    %esi,%edx
80103885:	74 26                	je     801038ad <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103887:	0f b6 19             	movzbl (%ecx),%ebx
8010388a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103890:	39 c3                	cmp    %eax,%ebx
80103892:	75 ec                	jne    80103880 <mycpu+0x30>
80103894:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010389a:	05 20 38 11 80       	add    $0x80113820,%eax
}
8010389f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038a2:	5b                   	pop    %ebx
801038a3:	5e                   	pop    %esi
801038a4:	5d                   	pop    %ebp
801038a5:	c3                   	ret    
        if (cpus[i].apicid == apicid)
801038a6:	b8 20 38 11 80       	mov    $0x80113820,%eax
            return &cpus[i];
801038ab:	eb f2                	jmp    8010389f <mycpu+0x4f>
    panic("unknown apicid\n");
801038ad:	83 ec 0c             	sub    $0xc,%esp
801038b0:	68 bc 84 10 80       	push   $0x801084bc
801038b5:	e8 d6 ca ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
801038ba:	83 ec 0c             	sub    $0xc,%esp
801038bd:	68 e4 85 10 80       	push   $0x801085e4
801038c2:	e8 c9 ca ff ff       	call   80100390 <panic>
801038c7:	89 f6                	mov    %esi,%esi
801038c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038d0 <cpuid>:
int cpuid() {
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
801038d6:	e8 75 ff ff ff       	call   80103850 <mycpu>
801038db:	2d 20 38 11 80       	sub    $0x80113820,%eax
}
801038e0:	c9                   	leave  
    return mycpu() - cpus;
801038e1:	c1 f8 04             	sar    $0x4,%eax
801038e4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801038ea:	c3                   	ret    
801038eb:	90                   	nop
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038f0 <myproc>:
struct proc *myproc(void) {
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	53                   	push   %ebx
801038f4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
801038f7:	e8 b4 13 00 00       	call   80104cb0 <pushcli>
    c = mycpu();
801038fc:	e8 4f ff ff ff       	call   80103850 <mycpu>
    p = c->proc;
80103901:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103907:	e8 e4 13 00 00       	call   80104cf0 <popcli>
}
8010390c:	83 c4 04             	add    $0x4,%esp
8010390f:	89 d8                	mov    %ebx,%eax
80103911:	5b                   	pop    %ebx
80103912:	5d                   	pop    %ebp
80103913:	c3                   	ret    
80103914:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010391a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103920 <getpinfo>:
int getpinfo(struct proc_stat *p, int pid) {
80103920:	55                   	push   %ebp
    for (q = ptable.proc; q < &ptable.proc[NPROC]; q++) {
80103921:	b8 94 7c 11 80       	mov    $0x80117c94,%eax
int getpinfo(struct proc_stat *p, int pid) {
80103926:	89 e5                	mov    %esp,%ebp
80103928:	53                   	push   %ebx
80103929:	83 ec 04             	sub    $0x4,%esp
8010392c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010392f:	8b 55 0c             	mov    0xc(%ebp),%edx
80103932:	eb 10                	jmp    80103944 <getpinfo+0x24>
80103934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (q = ptable.proc; q < &ptable.proc[NPROC]; q++) {
80103938:	05 b0 00 00 00       	add    $0xb0,%eax
8010393d:	3d 94 a8 11 80       	cmp    $0x8011a894,%eax
80103942:	73 4c                	jae    80103990 <getpinfo+0x70>
        if (q->state != RUNNABLE)
80103944:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103948:	75 ee                	jne    80103938 <getpinfo+0x18>
        if (q->pid == pid) {
8010394a:	39 50 10             	cmp    %edx,0x10(%eax)
8010394d:	75 e9                	jne    80103938 <getpinfo+0x18>
            p->num_run = &(q->num_run);
8010394f:	8d 98 94 00 00 00    	lea    0x94(%eax),%ebx
            p->pid = &(q->pid);
80103955:	8d 50 10             	lea    0x10(%eax),%edx
            p->num_run = &(q->num_run);
80103958:	89 59 08             	mov    %ebx,0x8(%ecx)
            p->current_queue = &(q->qno);
8010395b:	8d 98 90 00 00 00    	lea    0x90(%eax),%ebx
            p->pid = &(q->pid);
80103961:	89 11                	mov    %edx,(%ecx)
            p->current_queue = &(q->qno);
80103963:	89 59 0c             	mov    %ebx,0xc(%ecx)
            p->runtime = &(q->rtime);
80103966:	8d 98 80 00 00 00    	lea    0x80(%eax),%ebx
8010396c:	89 59 04             	mov    %ebx,0x4(%ecx)
            cprintf("as%d %p %p\n", *(p->pid), p->pid, *p->pid);
8010396f:	8b 40 10             	mov    0x10(%eax),%eax
80103972:	50                   	push   %eax
80103973:	52                   	push   %edx
80103974:	50                   	push   %eax
80103975:	68 cc 84 10 80       	push   $0x801084cc
8010397a:	e8 e1 cc ff ff       	call   80100660 <cprintf>
            return 1;
8010397f:	83 c4 10             	add    $0x10,%esp
80103982:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103987:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010398a:	c9                   	leave  
8010398b:	c3                   	ret    
8010398c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80103990:	31 c0                	xor    %eax,%eax
}
80103992:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103995:	c9                   	leave  
80103996:	c3                   	ret    
80103997:	89 f6                	mov    %esi,%esi
80103999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039a0 <aging>:
int aging() {
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	56                   	push   %esi
801039a4:	53                   	push   %ebx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801039a5:	bb 94 7c 11 80       	mov    $0x80117c94,%ebx
    acquire(&ptable.lock);
801039aa:	83 ec 0c             	sub    $0xc,%esp
801039ad:	68 60 7c 11 80       	push   $0x80117c60
801039b2:	e8 c9 13 00 00       	call   80104d80 <acquire>
801039b7:	8b 0d 80 c9 11 80    	mov    0x8011c980,%ecx
801039bd:	83 c4 10             	add    $0x10,%esp
801039c0:	eb 1e                	jmp    801039e0 <aging+0x40>
801039c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        p->aging_time = ticks - (p->ctime + p->rtime);
801039c8:	89 83 ac 00 00 00    	mov    %eax,0xac(%ebx)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801039ce:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801039d4:	81 fb 94 a8 11 80    	cmp    $0x8011a894,%ebx
801039da:	0f 83 f0 02 00 00    	jae    80103cd0 <aging+0x330>
        int tm = ticks - (p->ctime + p->rtime) - p->aging_time;
801039e0:	89 c8                	mov    %ecx,%eax
801039e2:	2b 83 80 00 00 00    	sub    0x80(%ebx),%eax
801039e8:	2b 43 7c             	sub    0x7c(%ebx),%eax
801039eb:	89 c2                	mov    %eax,%edx
801039ed:	2b 93 ac 00 00 00    	sub    0xac(%ebx),%edx
        if (tm > time_age) {
801039f3:	39 15 64 b0 10 80    	cmp    %edx,0x8010b064
801039f9:	7d cd                	jge    801039c8 <aging+0x28>
            cprintf("KANISH\n");
801039fb:	83 ec 0c             	sub    $0xc,%esp
            int no = p->qno;
801039fe:	8b b3 90 00 00 00    	mov    0x90(%ebx),%esi
            cprintf("KANISH\n");
80103a04:	68 d8 84 10 80       	push   $0x801084d8
80103a09:	e8 52 cc ff ff       	call   80100660 <cprintf>
            if (no == 1) {
80103a0e:	83 c4 10             	add    $0x10,%esp
80103a11:	83 fe 01             	cmp    $0x1,%esi
80103a14:	74 32                	je     80103a48 <aging+0xa8>
            } else if (no == 2) {
80103a16:	83 fe 02             	cmp    $0x2,%esi
80103a19:	0f 84 d1 00 00 00    	je     80103af0 <aging+0x150>
            } else if (no == 3) {
80103a1f:	83 fe 03             	cmp    $0x3,%esi
80103a22:	0f 84 68 01 00 00    	je     80103b90 <aging+0x1f0>
            } else if (no == 4) {
80103a28:	83 fe 04             	cmp    $0x4,%esi
80103a2b:	0f 84 ff 01 00 00    	je     80103c30 <aging+0x290>
80103a31:	8b 0d 80 c9 11 80    	mov    0x8011c980,%ecx
80103a37:	89 c8                	mov    %ecx,%eax
80103a39:	2b 83 80 00 00 00    	sub    0x80(%ebx),%eax
80103a3f:	2b 43 7c             	sub    0x7c(%ebx),%eax
80103a42:	eb 84                	jmp    801039c8 <aging+0x28>
80103a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                cnt[1]--;
80103a48:	8b 15 20 b6 10 80    	mov    0x8010b620,%edx
                for (int i = beg1; i < cnt[1]; i++) {
80103a4e:	8b 0d 50 b6 10 80    	mov    0x8010b650,%ecx
                p->qno = 0;
80103a54:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103a5b:	00 00 00 
                cnt[1]--;
80103a5e:	8d 42 ff             	lea    -0x1(%edx),%eax
                for (int i = beg1; i < cnt[1]; i++) {
80103a61:	39 c8                	cmp    %ecx,%eax
                cnt[1]--;
80103a63:	a3 20 b6 10 80       	mov    %eax,0x8010b620
                for (int i = beg1; i < cnt[1]; i++) {
80103a68:	7e 23                	jle    80103a8d <aging+0xed>
80103a6a:	8d 04 8d 20 5d 11 80 	lea    -0x7feea2e0(,%ecx,4),%eax
80103a71:	8d 0c 95 1c 5d 11 80 	lea    -0x7feea2e4(,%edx,4),%ecx
80103a78:	90                   	nop
80103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    q1[i] = q1[i + 1];
80103a80:	8b 50 04             	mov    0x4(%eax),%edx
80103a83:	83 c0 04             	add    $0x4,%eax
80103a86:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = beg1; i < cnt[1]; i++) {
80103a89:	39 c8                	cmp    %ecx,%eax
80103a8b:	75 f3                	jne    80103a80 <aging+0xe0>
80103a8d:	8b 0d 80 c9 11 80    	mov    0x8011c980,%ecx
                for (int i = 0; i < cnt[0]; i++) {
80103a93:	8b 35 1c b6 10 80    	mov    0x8010b61c,%esi
80103a99:	89 c8                	mov    %ecx,%eax
80103a9b:	2b 83 80 00 00 00    	sub    0x80(%ebx),%eax
80103aa1:	2b 43 7c             	sub    0x7c(%ebx),%eax
80103aa4:	85 f6                	test   %esi,%esi
80103aa6:	7e 2c                	jle    80103ad4 <aging+0x134>
                    if (q0[i] == p) {
80103aa8:	39 1d c0 6c 11 80    	cmp    %ebx,0x80116cc0
80103aae:	0f 84 14 ff ff ff    	je     801039c8 <aging+0x28>
                for (int i = 0; i < cnt[0]; i++) {
80103ab4:	31 d2                	xor    %edx,%edx
80103ab6:	eb 15                	jmp    80103acd <aging+0x12d>
80103ab8:	90                   	nop
80103ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    if (q0[i] == p) {
80103ac0:	39 1c 95 c0 6c 11 80 	cmp    %ebx,-0x7fee9340(,%edx,4)
80103ac7:	0f 84 fb fe ff ff    	je     801039c8 <aging+0x28>
                for (int i = 0; i < cnt[0]; i++) {
80103acd:	83 c2 01             	add    $0x1,%edx
80103ad0:	39 f2                	cmp    %esi,%edx
80103ad2:	75 ec                	jne    80103ac0 <aging+0x120>
                    cnt[0]++;
80103ad4:	8d 56 01             	lea    0x1(%esi),%edx
                    q0[cnt[0] - 1] = p;
80103ad7:	89 1c b5 c0 6c 11 80 	mov    %ebx,-0x7fee9340(,%esi,4)
                    end0 += 1;
80103ade:	83 05 40 b6 10 80 01 	addl   $0x1,0x8010b640
                    cnt[0]++;
80103ae5:	89 15 1c b6 10 80    	mov    %edx,0x8010b61c
80103aeb:	e9 d8 fe ff ff       	jmp    801039c8 <aging+0x28>
                cnt[2]--;
80103af0:	8b 15 24 b6 10 80    	mov    0x8010b624,%edx
                for (int i = beg2; i < cnt[2]; i++) {
80103af6:	8b 0d 4c b6 10 80    	mov    0x8010b64c,%ecx
                p->qno = 1;
80103afc:	c7 83 90 00 00 00 01 	movl   $0x1,0x90(%ebx)
80103b03:	00 00 00 
                cnt[2]--;
80103b06:	8d 42 ff             	lea    -0x1(%edx),%eax
                for (int i = beg2; i < cnt[2]; i++) {
80103b09:	39 c8                	cmp    %ecx,%eax
                cnt[2]--;
80103b0b:	a3 24 b6 10 80       	mov    %eax,0x8010b624
                for (int i = beg2; i < cnt[2]; i++) {
80103b10:	7e 1b                	jle    80103b2d <aging+0x18d>
80103b12:	8d 04 8d c0 3d 11 80 	lea    -0x7feec240(,%ecx,4),%eax
80103b19:	8d 0c 95 bc 3d 11 80 	lea    -0x7feec244(,%edx,4),%ecx
                    q2[i] = q2[i + 1];
80103b20:	8b 50 04             	mov    0x4(%eax),%edx
80103b23:	83 c0 04             	add    $0x4,%eax
80103b26:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = beg2; i < cnt[2]; i++) {
80103b29:	39 c1                	cmp    %eax,%ecx
80103b2b:	75 f3                	jne    80103b20 <aging+0x180>
80103b2d:	8b 0d 80 c9 11 80    	mov    0x8011c980,%ecx
                for (int i = 0; i < cnt[1]; i++) {
80103b33:	8b 35 20 b6 10 80    	mov    0x8010b620,%esi
80103b39:	89 c8                	mov    %ecx,%eax
80103b3b:	2b 83 80 00 00 00    	sub    0x80(%ebx),%eax
80103b41:	2b 43 7c             	sub    0x7c(%ebx),%eax
80103b44:	85 f6                	test   %esi,%esi
80103b46:	7e 2c                	jle    80103b74 <aging+0x1d4>
                    if (q1[i] == p) {
80103b48:	39 1d 20 5d 11 80    	cmp    %ebx,0x80115d20
80103b4e:	0f 84 74 fe ff ff    	je     801039c8 <aging+0x28>
                for (int i = 0; i < cnt[1]; i++) {
80103b54:	31 d2                	xor    %edx,%edx
80103b56:	eb 15                	jmp    80103b6d <aging+0x1cd>
80103b58:	90                   	nop
80103b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    if (q1[i] == p) {
80103b60:	39 1c 95 20 5d 11 80 	cmp    %ebx,-0x7feea2e0(,%edx,4)
80103b67:	0f 84 5b fe ff ff    	je     801039c8 <aging+0x28>
                for (int i = 0; i < cnt[1]; i++) {
80103b6d:	83 c2 01             	add    $0x1,%edx
80103b70:	39 f2                	cmp    %esi,%edx
80103b72:	75 ec                	jne    80103b60 <aging+0x1c0>
                    cnt[1]++;
80103b74:	8d 56 01             	lea    0x1(%esi),%edx
                    q1[cnt[1] - 1] = p;
80103b77:	89 1c b5 20 5d 11 80 	mov    %ebx,-0x7feea2e0(,%esi,4)
                    end1 += 1;
80103b7e:	83 05 3c b6 10 80 01 	addl   $0x1,0x8010b63c
                    cnt[1]++;
80103b85:	89 15 20 b6 10 80    	mov    %edx,0x8010b620
80103b8b:	e9 38 fe ff ff       	jmp    801039c8 <aging+0x28>
                cnt[3]--;
80103b90:	8b 15 28 b6 10 80    	mov    0x8010b628,%edx
                for (int i = beg3; i < cnt[3]; i++) {
80103b96:	8b 0d 48 b6 10 80    	mov    0x8010b648,%ecx
                p->qno = 2;
80103b9c:	c7 83 90 00 00 00 02 	movl   $0x2,0x90(%ebx)
80103ba3:	00 00 00 
                cnt[3]--;
80103ba6:	8d 42 ff             	lea    -0x1(%edx),%eax
                for (int i = beg3; i < cnt[3]; i++) {
80103ba9:	39 c8                	cmp    %ecx,%eax
                cnt[3]--;
80103bab:	a3 28 b6 10 80       	mov    %eax,0x8010b628
                for (int i = beg3; i < cnt[3]; i++) {
80103bb0:	7e 1b                	jle    80103bcd <aging+0x22d>
80103bb2:	8d 04 8d 80 4d 11 80 	lea    -0x7feeb280(,%ecx,4),%eax
80103bb9:	8d 0c 95 7c 4d 11 80 	lea    -0x7feeb284(,%edx,4),%ecx
                    q3[i] = q3[i + 1];
80103bc0:	8b 50 04             	mov    0x4(%eax),%edx
80103bc3:	83 c0 04             	add    $0x4,%eax
80103bc6:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = beg3; i < cnt[3]; i++) {
80103bc9:	39 c1                	cmp    %eax,%ecx
80103bcb:	75 f3                	jne    80103bc0 <aging+0x220>
80103bcd:	8b 0d 80 c9 11 80    	mov    0x8011c980,%ecx
                for (int i = 0; i < cnt[2]; i++) {
80103bd3:	8b 35 24 b6 10 80    	mov    0x8010b624,%esi
80103bd9:	89 c8                	mov    %ecx,%eax
80103bdb:	2b 83 80 00 00 00    	sub    0x80(%ebx),%eax
80103be1:	2b 43 7c             	sub    0x7c(%ebx),%eax
80103be4:	85 f6                	test   %esi,%esi
80103be6:	7e 2c                	jle    80103c14 <aging+0x274>
                    if (q2[i] == p) {
80103be8:	39 1d c0 3d 11 80    	cmp    %ebx,0x80113dc0
80103bee:	0f 84 d4 fd ff ff    	je     801039c8 <aging+0x28>
                for (int i = 0; i < cnt[2]; i++) {
80103bf4:	31 d2                	xor    %edx,%edx
80103bf6:	eb 15                	jmp    80103c0d <aging+0x26d>
80103bf8:	90                   	nop
80103bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    if (q2[i] == p) {
80103c00:	39 1c 95 c0 3d 11 80 	cmp    %ebx,-0x7feec240(,%edx,4)
80103c07:	0f 84 bb fd ff ff    	je     801039c8 <aging+0x28>
                for (int i = 0; i < cnt[2]; i++) {
80103c0d:	83 c2 01             	add    $0x1,%edx
80103c10:	39 f2                	cmp    %esi,%edx
80103c12:	75 ec                	jne    80103c00 <aging+0x260>
                    cnt[2]++;
80103c14:	8d 56 01             	lea    0x1(%esi),%edx
                    q2[cnt[2] - 1] = p;
80103c17:	89 1c b5 c0 3d 11 80 	mov    %ebx,-0x7feec240(,%esi,4)
                    end2 += 1;
80103c1e:	83 05 38 b6 10 80 01 	addl   $0x1,0x8010b638
                    cnt[2]++;
80103c25:	89 15 24 b6 10 80    	mov    %edx,0x8010b624
80103c2b:	e9 98 fd ff ff       	jmp    801039c8 <aging+0x28>
                cnt[4]--;
80103c30:	8b 15 2c b6 10 80    	mov    0x8010b62c,%edx
                for (int i = beg4; i < cnt[4]; i++) {
80103c36:	8b 0d 44 b6 10 80    	mov    0x8010b644,%ecx
                p->qno = 3;
80103c3c:	c7 83 90 00 00 00 03 	movl   $0x3,0x90(%ebx)
80103c43:	00 00 00 
                cnt[4]--;
80103c46:	8d 42 ff             	lea    -0x1(%edx),%eax
                for (int i = beg4; i < cnt[4]; i++) {
80103c49:	39 c8                	cmp    %ecx,%eax
                cnt[4]--;
80103c4b:	a3 2c b6 10 80       	mov    %eax,0x8010b62c
                for (int i = beg4; i < cnt[4]; i++) {
80103c50:	7e 1b                	jle    80103c6d <aging+0x2cd>
80103c52:	8d 04 8d a0 b1 11 80 	lea    -0x7fee4e60(,%ecx,4),%eax
80103c59:	8d 0c 95 9c b1 11 80 	lea    -0x7fee4e64(,%edx,4),%ecx
                    q4[i] = q4[i + 1];
80103c60:	8b 50 04             	mov    0x4(%eax),%edx
80103c63:	83 c0 04             	add    $0x4,%eax
80103c66:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = beg4; i < cnt[4]; i++) {
80103c69:	39 c1                	cmp    %eax,%ecx
80103c6b:	75 f3                	jne    80103c60 <aging+0x2c0>
80103c6d:	8b 0d 80 c9 11 80    	mov    0x8011c980,%ecx
                for (int i = 0; i < cnt[3]; i++) {
80103c73:	8b 35 28 b6 10 80    	mov    0x8010b628,%esi
80103c79:	89 c8                	mov    %ecx,%eax
80103c7b:	2b 83 80 00 00 00    	sub    0x80(%ebx),%eax
80103c81:	2b 43 7c             	sub    0x7c(%ebx),%eax
80103c84:	85 f6                	test   %esi,%esi
80103c86:	7e 2c                	jle    80103cb4 <aging+0x314>
                    if (q3[i] == p) {
80103c88:	39 1d 80 4d 11 80    	cmp    %ebx,0x80114d80
80103c8e:	0f 84 34 fd ff ff    	je     801039c8 <aging+0x28>
                for (int i = 0; i < cnt[3]; i++) {
80103c94:	31 d2                	xor    %edx,%edx
80103c96:	eb 15                	jmp    80103cad <aging+0x30d>
80103c98:	90                   	nop
80103c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    if (q3[i] == p) {
80103ca0:	39 1c 95 80 4d 11 80 	cmp    %ebx,-0x7feeb280(,%edx,4)
80103ca7:	0f 84 1b fd ff ff    	je     801039c8 <aging+0x28>
                for (int i = 0; i < cnt[3]; i++) {
80103cad:	83 c2 01             	add    $0x1,%edx
80103cb0:	39 f2                	cmp    %esi,%edx
80103cb2:	75 ec                	jne    80103ca0 <aging+0x300>
                    cnt[3]++;
80103cb4:	8d 56 01             	lea    0x1(%esi),%edx
                    q3[cnt[3] - 1] = p;
80103cb7:	89 1c b5 80 4d 11 80 	mov    %ebx,-0x7feeb280(,%esi,4)
                    end3 += 1;
80103cbe:	83 05 34 b6 10 80 01 	addl   $0x1,0x8010b634
                    cnt[3]++;
80103cc5:	89 15 28 b6 10 80    	mov    %edx,0x8010b628
80103ccb:	e9 f8 fc ff ff       	jmp    801039c8 <aging+0x28>
    release(&ptable.lock);
80103cd0:	83 ec 0c             	sub    $0xc,%esp
80103cd3:	68 60 7c 11 80       	push   $0x80117c60
80103cd8:	e8 63 11 00 00       	call   80104e40 <release>
}
80103cdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ce0:	b8 01 00 00 00       	mov    $0x1,%eax
80103ce5:	5b                   	pop    %ebx
80103ce6:	5e                   	pop    %esi
80103ce7:	5d                   	pop    %ebp
80103ce8:	c3                   	ret    
80103ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cf0 <userinit>:
void userinit(void) {
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	53                   	push   %ebx
80103cf4:	83 ec 04             	sub    $0x4,%esp
    p = allocproc();
80103cf7:	e8 04 f9 ff ff       	call   80103600 <allocproc>
80103cfc:	89 c3                	mov    %eax,%ebx
    initproc = p;
80103cfe:	a3 58 b6 10 80       	mov    %eax,0x8010b658
    if ((p->pgdir = setupkvm()) == 0)
80103d03:	e8 a8 3f 00 00       	call   80107cb0 <setupkvm>
80103d08:	85 c0                	test   %eax,%eax
80103d0a:	89 43 04             	mov    %eax,0x4(%ebx)
80103d0d:	0f 84 bd 00 00 00    	je     80103dd0 <userinit+0xe0>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d13:	83 ec 04             	sub    $0x4,%esp
80103d16:	68 2c 00 00 00       	push   $0x2c
80103d1b:	68 c0 b4 10 80       	push   $0x8010b4c0
80103d20:	50                   	push   %eax
80103d21:	e8 6a 3c 00 00       	call   80107990 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80103d26:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103d29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103d2f:	6a 4c                	push   $0x4c
80103d31:	6a 00                	push   $0x0
80103d33:	ff 73 18             	pushl  0x18(%ebx)
80103d36:	e8 55 11 00 00       	call   80104e90 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103d3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d43:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103d48:	83 c4 0c             	add    $0xc,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103d52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103d56:	8b 43 18             	mov    0x18(%ebx),%eax
80103d59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d5d:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80103d61:	8b 43 18             	mov    0x18(%ebx),%eax
80103d64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d68:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80103d6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103d6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103d76:	8b 43 18             	mov    0x18(%ebx),%eax
80103d79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80103d80:	8b 43 18             	mov    0x18(%ebx),%eax
80103d83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103d8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d8d:	6a 10                	push   $0x10
80103d8f:	68 f9 84 10 80       	push   $0x801084f9
80103d94:	50                   	push   %eax
80103d95:	e8 d6 12 00 00       	call   80105070 <safestrcpy>
    p->cwd = namei("/");
80103d9a:	c7 04 24 02 85 10 80 	movl   $0x80108502,(%esp)
80103da1:	e8 3a e1 ff ff       	call   80101ee0 <namei>
80103da6:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
80103da9:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
80103db0:	e8 cb 0f 00 00       	call   80104d80 <acquire>
    p->state = RUNNABLE;
80103db5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
80103dbc:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
80103dc3:	e8 78 10 00 00       	call   80104e40 <release>
}
80103dc8:	83 c4 10             	add    $0x10,%esp
80103dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dce:	c9                   	leave  
80103dcf:	c3                   	ret    
        panic("userinit: out of memory?");
80103dd0:	83 ec 0c             	sub    $0xc,%esp
80103dd3:	68 e0 84 10 80       	push   $0x801084e0
80103dd8:	e8 b3 c5 ff ff       	call   80100390 <panic>
80103ddd:	8d 76 00             	lea    0x0(%esi),%esi

80103de0 <growproc>:
int growproc(int n) {
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	56                   	push   %esi
80103de4:	53                   	push   %ebx
80103de5:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103de8:	e8 c3 0e 00 00       	call   80104cb0 <pushcli>
    c = mycpu();
80103ded:	e8 5e fa ff ff       	call   80103850 <mycpu>
    p = c->proc;
80103df2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103df8:	e8 f3 0e 00 00       	call   80104cf0 <popcli>
    if (n > 0) {
80103dfd:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80103e00:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103e02:	7f 1c                	jg     80103e20 <growproc+0x40>
    } else if (n < 0) {
80103e04:	75 3a                	jne    80103e40 <growproc+0x60>
    switchuvm(curproc);
80103e06:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80103e09:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103e0b:	53                   	push   %ebx
80103e0c:	e8 6f 3a 00 00       	call   80107880 <switchuvm>
    return 0;
80103e11:	83 c4 10             	add    $0x10,%esp
80103e14:	31 c0                	xor    %eax,%eax
}
80103e16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e19:	5b                   	pop    %ebx
80103e1a:	5e                   	pop    %esi
80103e1b:	5d                   	pop    %ebp
80103e1c:	c3                   	ret    
80103e1d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e20:	83 ec 04             	sub    $0x4,%esp
80103e23:	01 c6                	add    %eax,%esi
80103e25:	56                   	push   %esi
80103e26:	50                   	push   %eax
80103e27:	ff 73 04             	pushl  0x4(%ebx)
80103e2a:	e8 a1 3c 00 00       	call   80107ad0 <allocuvm>
80103e2f:	83 c4 10             	add    $0x10,%esp
80103e32:	85 c0                	test   %eax,%eax
80103e34:	75 d0                	jne    80103e06 <growproc+0x26>
            return -1;
80103e36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e3b:	eb d9                	jmp    80103e16 <growproc+0x36>
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e40:	83 ec 04             	sub    $0x4,%esp
80103e43:	01 c6                	add    %eax,%esi
80103e45:	56                   	push   %esi
80103e46:	50                   	push   %eax
80103e47:	ff 73 04             	pushl  0x4(%ebx)
80103e4a:	e8 b1 3d 00 00       	call   80107c00 <deallocuvm>
80103e4f:	83 c4 10             	add    $0x10,%esp
80103e52:	85 c0                	test   %eax,%eax
80103e54:	75 b0                	jne    80103e06 <growproc+0x26>
80103e56:	eb de                	jmp    80103e36 <growproc+0x56>
80103e58:	90                   	nop
80103e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e60 <rand>:
    bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
80103e60:	0f b7 05 5c b0 10 80 	movzwl 0x8010b05c,%eax
unsigned rand() {
80103e67:	55                   	push   %ebp
80103e68:	89 e5                	mov    %esp,%ebp
}
80103e6a:	5d                   	pop    %ebp
    bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
80103e6b:	89 c2                	mov    %eax,%edx
80103e6d:	89 c1                	mov    %eax,%ecx
80103e6f:	66 c1 e9 03          	shr    $0x3,%cx
80103e73:	66 c1 ea 02          	shr    $0x2,%dx
80103e77:	31 ca                	xor    %ecx,%edx
80103e79:	89 c1                	mov    %eax,%ecx
80103e7b:	31 c2                	xor    %eax,%edx
80103e7d:	66 c1 e9 05          	shr    $0x5,%cx
    return lfsr = (lfsr >> 1) | (bit << 15);
80103e81:	66 d1 e8             	shr    %ax
    bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
80103e84:	31 ca                	xor    %ecx,%edx
80103e86:	83 e2 01             	and    $0x1,%edx
80103e89:	0f b7 ca             	movzwl %dx,%ecx
    return lfsr = (lfsr >> 1) | (bit << 15);
80103e8c:	c1 e2 0f             	shl    $0xf,%edx
80103e8f:	09 d0                	or     %edx,%eax
    bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
80103e91:	89 0d 60 4d 11 80    	mov    %ecx,0x80114d60
    return lfsr = (lfsr >> 1) | (bit << 15);
80103e97:	66 a3 5c b0 10 80    	mov    %ax,0x8010b05c
80103e9d:	0f b7 c0             	movzwl %ax,%eax
}
80103ea0:	c3                   	ret    
80103ea1:	eb 0d                	jmp    80103eb0 <fork>
80103ea3:	90                   	nop
80103ea4:	90                   	nop
80103ea5:	90                   	nop
80103ea6:	90                   	nop
80103ea7:	90                   	nop
80103ea8:	90                   	nop
80103ea9:	90                   	nop
80103eaa:	90                   	nop
80103eab:	90                   	nop
80103eac:	90                   	nop
80103ead:	90                   	nop
80103eae:	90                   	nop
80103eaf:	90                   	nop

80103eb0 <fork>:
int fork(void) {
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	57                   	push   %edi
80103eb4:	56                   	push   %esi
80103eb5:	53                   	push   %ebx
80103eb6:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80103eb9:	e8 f2 0d 00 00       	call   80104cb0 <pushcli>
    c = mycpu();
80103ebe:	e8 8d f9 ff ff       	call   80103850 <mycpu>
    p = c->proc;
80103ec3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103ec9:	e8 22 0e 00 00       	call   80104cf0 <popcli>
    if ((np = allocproc()) == 0) {
80103ece:	e8 2d f7 ff ff       	call   80103600 <allocproc>
80103ed3:	85 c0                	test   %eax,%eax
80103ed5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ed8:	0f 84 ce 00 00 00    	je     80103fac <fork+0xfc>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103ede:	83 ec 08             	sub    $0x8,%esp
80103ee1:	ff 33                	pushl  (%ebx)
80103ee3:	ff 73 04             	pushl  0x4(%ebx)
80103ee6:	89 c7                	mov    %eax,%edi
80103ee8:	e8 93 3e 00 00       	call   80107d80 <copyuvm>
80103eed:	83 c4 10             	add    $0x10,%esp
80103ef0:	85 c0                	test   %eax,%eax
80103ef2:	89 47 04             	mov    %eax,0x4(%edi)
80103ef5:	0f 84 b8 00 00 00    	je     80103fb3 <fork+0x103>
    np->sz = curproc->sz;
80103efb:	8b 03                	mov    (%ebx),%eax
80103efd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103f00:	89 01                	mov    %eax,(%ecx)
    np->parent = curproc;
80103f02:	89 59 14             	mov    %ebx,0x14(%ecx)
80103f05:	89 c8                	mov    %ecx,%eax
    *np->tf = *curproc->tf;
80103f07:	8b 79 18             	mov    0x18(%ecx),%edi
80103f0a:	8b 73 18             	mov    0x18(%ebx),%esi
80103f0d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103f12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++)
80103f14:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
80103f16:	8b 40 18             	mov    0x18(%eax),%eax
80103f19:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
        if (curproc->ofile[i])
80103f20:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f24:	85 c0                	test   %eax,%eax
80103f26:	74 13                	je     80103f3b <fork+0x8b>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103f28:	83 ec 0c             	sub    $0xc,%esp
80103f2b:	50                   	push   %eax
80103f2c:	e8 bf ce ff ff       	call   80100df0 <filedup>
80103f31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f34:	83 c4 10             	add    $0x10,%esp
80103f37:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
    for (i = 0; i < NOFILE; i++)
80103f3b:	83 c6 01             	add    $0x1,%esi
80103f3e:	83 fe 10             	cmp    $0x10,%esi
80103f41:	75 dd                	jne    80103f20 <fork+0x70>
    np->cwd = idup(curproc->cwd);
80103f43:	83 ec 0c             	sub    $0xc,%esp
80103f46:	ff 73 68             	pushl  0x68(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f49:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
80103f4c:	e8 ff d6 ff ff       	call   80101650 <idup>
80103f51:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f54:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
80103f57:	89 47 68             	mov    %eax,0x68(%edi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f5a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f5d:	6a 10                	push   $0x10
80103f5f:	53                   	push   %ebx
80103f60:	50                   	push   %eax
80103f61:	e8 0a 11 00 00       	call   80105070 <safestrcpy>
    pid = np->pid;
80103f66:	8b 5f 10             	mov    0x10(%edi),%ebx
    np->qno = 0;
80103f69:	c7 87 90 00 00 00 00 	movl   $0x0,0x90(%edi)
80103f70:	00 00 00 
    cprintf("Child with pid %d created\n", pid);
80103f73:	58                   	pop    %eax
80103f74:	5a                   	pop    %edx
80103f75:	53                   	push   %ebx
80103f76:	68 04 85 10 80       	push   $0x80108504
80103f7b:	e8 e0 c6 ff ff       	call   80100660 <cprintf>
    acquire(&ptable.lock);
80103f80:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
80103f87:	e8 f4 0d 00 00       	call   80104d80 <acquire>
    np->state = RUNNABLE;
80103f8c:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
    release(&ptable.lock);
80103f93:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
80103f9a:	e8 a1 0e 00 00       	call   80104e40 <release>
    return pid;
80103f9f:	83 c4 10             	add    $0x10,%esp
}
80103fa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fa5:	89 d8                	mov    %ebx,%eax
80103fa7:	5b                   	pop    %ebx
80103fa8:	5e                   	pop    %esi
80103fa9:	5f                   	pop    %edi
80103faa:	5d                   	pop    %ebp
80103fab:	c3                   	ret    
        return -1;
80103fac:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103fb1:	eb ef                	jmp    80103fa2 <fork+0xf2>
        kfree(np->kstack);
80103fb3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103fb6:	83 ec 0c             	sub    $0xc,%esp
        return -1;
80103fb9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
        kfree(np->kstack);
80103fbe:	ff 77 08             	pushl  0x8(%edi)
80103fc1:	e8 4a e3 ff ff       	call   80102310 <kfree>
        np->kstack = 0;
80103fc6:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
        np->state = UNUSED;
80103fcd:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
        return -1;
80103fd4:	83 c4 10             	add    $0x10,%esp
80103fd7:	eb c9                	jmp    80103fa2 <fork+0xf2>
80103fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fe0 <set_priority>:
int set_priority(int pid, int priority) {
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	53                   	push   %ebx
80103fe4:	83 ec 10             	sub    $0x10,%esp
80103fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
80103fea:	68 60 7c 11 80       	push   $0x80117c60
80103fef:	e8 8c 0d 00 00       	call   80104d80 <acquire>
80103ff4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103ff7:	ba 94 7c 11 80       	mov    $0x80117c94,%edx
80103ffc:	eb 10                	jmp    8010400e <set_priority+0x2e>
80103ffe:	66 90                	xchg   %ax,%ax
80104000:	81 c2 b0 00 00 00    	add    $0xb0,%edx
80104006:	81 fa 94 a8 11 80    	cmp    $0x8011a894,%edx
8010400c:	73 32                	jae    80104040 <set_priority+0x60>
        if (p->pid == pid) {
8010400e:	39 5a 10             	cmp    %ebx,0x10(%edx)
80104011:	75 ed                	jne    80104000 <set_priority+0x20>
            p->priority = priority;
80104013:	8b 45 0c             	mov    0xc(%ebp),%eax
            val = p->priority;
80104016:	8b 9a 8c 00 00 00    	mov    0x8c(%edx),%ebx
            p->priority = priority;
8010401c:	89 82 8c 00 00 00    	mov    %eax,0x8c(%edx)
    release(&ptable.lock);
80104022:	83 ec 0c             	sub    $0xc,%esp
80104025:	68 60 7c 11 80       	push   $0x80117c60
8010402a:	e8 11 0e 00 00       	call   80104e40 <release>
}
8010402f:	89 d8                	mov    %ebx,%eax
80104031:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104034:	c9                   	leave  
80104035:	c3                   	ret    
80104036:	8d 76 00             	lea    0x0(%esi),%esi
80104039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    int val = -1;  // in order to return old priority of the process
80104040:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104045:	eb db                	jmp    80104022 <set_priority+0x42>
80104047:	89 f6                	mov    %esi,%esi
80104049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104050 <check_priority>:
int check_priority(int prt) {
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	53                   	push   %ebx
80104054:	83 ec 10             	sub    $0x10,%esp
80104057:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
8010405a:	68 60 7c 11 80       	push   $0x80117c60
8010405f:	e8 1c 0d 00 00       	call   80104d80 <acquire>
80104064:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104067:	b8 94 7c 11 80       	mov    $0x80117c94,%eax
8010406c:	eb 0e                	jmp    8010407c <check_priority+0x2c>
8010406e:	66 90                	xchg   %ax,%ax
80104070:	05 b0 00 00 00       	add    $0xb0,%eax
80104075:	3d 94 a8 11 80       	cmp    $0x8011a894,%eax
8010407a:	73 2c                	jae    801040a8 <check_priority+0x58>
        if (p->state != RUNNABLE)
8010407c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104080:	75 ee                	jne    80104070 <check_priority+0x20>
        if (p->priority <= prt) {
80104082:	39 98 8c 00 00 00    	cmp    %ebx,0x8c(%eax)
80104088:	7f e6                	jg     80104070 <check_priority+0x20>
            release(&ptable.lock);
8010408a:	83 ec 0c             	sub    $0xc,%esp
8010408d:	68 60 7c 11 80       	push   $0x80117c60
80104092:	e8 a9 0d 00 00       	call   80104e40 <release>
            return 1;
80104097:	83 c4 10             	add    $0x10,%esp
8010409a:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010409f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040a2:	c9                   	leave  
801040a3:	c3                   	ret    
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	68 60 7c 11 80       	push   $0x80117c60
801040b0:	e8 8b 0d 00 00       	call   80104e40 <release>
    return 0;
801040b5:	83 c4 10             	add    $0x10,%esp
801040b8:	31 c0                	xor    %eax,%eax
}
801040ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040bd:	c9                   	leave  
801040be:	c3                   	ret    
801040bf:	90                   	nop

801040c0 <scheduler>:
void scheduler(void) {
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	57                   	push   %edi
801040c4:	56                   	push   %esi
801040c5:	53                   	push   %ebx
801040c6:	83 ec 0c             	sub    $0xc,%esp
    struct cpu *c = mycpu();
801040c9:	e8 82 f7 ff ff       	call   80103850 <mycpu>
801040ce:	8d 78 04             	lea    0x4(%eax),%edi
801040d1:	89 c6                	mov    %eax,%esi
    c->proc = 0;
801040d3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801040da:	00 00 00 
801040dd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801040e0:	fb                   	sti    
        acquire(&ptable.lock);
801040e1:	83 ec 0c             	sub    $0xc,%esp
801040e4:	68 60 7c 11 80       	push   $0x80117c60
801040e9:	e8 92 0c 00 00       	call   80104d80 <acquire>
            for (int i = 0; i < cnt[0]; i++) {
801040ee:	8b 15 1c b6 10 80    	mov    0x8010b61c,%edx
801040f4:	83 c4 10             	add    $0x10,%esp
801040f7:	85 d2                	test   %edx,%edx
801040f9:	0f 8e a1 00 00 00    	jle    801041a0 <scheduler+0xe0>
                p = q0[i];
801040ff:	8b 1d c0 6c 11 80    	mov    0x80116cc0,%ebx
            for (int i = 0; i < cnt[0]; i++) {
80104105:	31 c0                	xor    %eax,%eax
                if (p->state != RUNNABLE)
80104107:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010410b:	74 18                	je     80104125 <scheduler+0x65>
            for (int i = 0; i < cnt[0]; i++) {
8010410d:	83 c0 01             	add    $0x1,%eax
80104110:	39 c2                	cmp    %eax,%edx
80104112:	0f 84 88 00 00 00    	je     801041a0 <scheduler+0xe0>
                p = q0[i];
80104118:	8b 1c 85 c0 6c 11 80 	mov    -0x7fee9340(,%eax,4),%ebx
                if (p->state != RUNNABLE)
8010411f:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104123:	75 e8                	jne    8010410d <scheduler+0x4d>
                beg0 = i;
80104125:	a3 54 b6 10 80       	mov    %eax,0x8010b654
                switchuvm(p);
8010412a:	83 ec 0c             	sub    $0xc,%esp
                c->proc = p;
8010412d:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
                switchuvm(p);
80104133:	53                   	push   %ebx
80104134:	e8 47 37 00 00       	call   80107880 <switchuvm>
                p->num_run++;
80104139:	83 83 94 00 00 00 01 	addl   $0x1,0x94(%ebx)
                p->state = RUNNING;
80104140:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
                    p->name, p->pid, p->qno, p->rtime,
80104147:	83 c3 6c             	add    $0x6c,%ebx
                swtch(&(c->scheduler), p->context);
8010414a:	58                   	pop    %eax
8010414b:	5a                   	pop    %edx
8010414c:	ff 73 b0             	pushl  -0x50(%ebx)
8010414f:	57                   	push   %edi
80104150:	e8 76 0f 00 00       	call   801050cb <swtch>
                cprintf(
80104155:	59                   	pop    %ecx
80104156:	58                   	pop    %eax
                    ticks - p->ctime - p->rtime);
80104157:	a1 80 c9 11 80       	mov    0x8011c980,%eax
8010415c:	2b 43 10             	sub    0x10(%ebx),%eax
8010415f:	8b 53 14             	mov    0x14(%ebx),%edx
                cprintf(
80104162:	29 d0                	sub    %edx,%eax
80104164:	50                   	push   %eax
80104165:	52                   	push   %edx
80104166:	ff 73 24             	pushl  0x24(%ebx)
80104169:	ff 73 a4             	pushl  -0x5c(%ebx)
8010416c:	53                   	push   %ebx
8010416d:	68 0c 86 10 80       	push   $0x8010860c
80104172:	e8 e9 c4 ff ff       	call   80100660 <cprintf>
                switchkvm();
80104177:	83 c4 20             	add    $0x20,%esp
8010417a:	e8 e1 36 00 00       	call   80107860 <switchkvm>
                c->proc = 0;
8010417f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104186:	00 00 00 
        release(&ptable.lock);
80104189:	83 ec 0c             	sub    $0xc,%esp
8010418c:	68 60 7c 11 80       	push   $0x80117c60
80104191:	e8 aa 0c 00 00       	call   80104e40 <release>
    for (;;) {
80104196:	83 c4 10             	add    $0x10,%esp
80104199:	e9 42 ff ff ff       	jmp    801040e0 <scheduler+0x20>
8010419e:	66 90                	xchg   %ax,%ax
            for (int i = 0; i < cnt[1]; i++) {
801041a0:	8b 15 20 b6 10 80    	mov    0x8010b620,%edx
801041a6:	85 d2                	test   %edx,%edx
801041a8:	7e 36                	jle    801041e0 <scheduler+0x120>
                p = q1[i];
801041aa:	8b 1d 20 5d 11 80    	mov    0x80115d20,%ebx
            for (int i = 0; i < cnt[1]; i++) {
801041b0:	31 c0                	xor    %eax,%eax
                if (p->state != RUNNABLE)
801041b2:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801041b6:	74 14                	je     801041cc <scheduler+0x10c>
            for (int i = 0; i < cnt[1]; i++) {
801041b8:	83 c0 01             	add    $0x1,%eax
801041bb:	39 d0                	cmp    %edx,%eax
801041bd:	74 21                	je     801041e0 <scheduler+0x120>
                p = q1[i];
801041bf:	8b 1c 85 20 5d 11 80 	mov    -0x7feea2e0(,%eax,4),%ebx
                if (p->state != RUNNABLE)
801041c6:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801041ca:	75 ec                	jne    801041b8 <scheduler+0xf8>
                beg1 = i;
801041cc:	a3 50 b6 10 80       	mov    %eax,0x8010b650
801041d1:	e9 54 ff ff ff       	jmp    8010412a <scheduler+0x6a>
801041d6:	8d 76 00             	lea    0x0(%esi),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            for (int i = 0; i < cnt[2]; i++) {
801041e0:	8b 15 24 b6 10 80    	mov    0x8010b624,%edx
801041e6:	85 d2                	test   %edx,%edx
801041e8:	7e 36                	jle    80104220 <scheduler+0x160>
                p = q2[i];
801041ea:	8b 1d c0 3d 11 80    	mov    0x80113dc0,%ebx
            for (int i = 0; i < cnt[2]; i++) {
801041f0:	31 c0                	xor    %eax,%eax
                if (p->state != RUNNABLE)
801041f2:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801041f6:	74 1c                	je     80104214 <scheduler+0x154>
801041f8:	90                   	nop
801041f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (int i = 0; i < cnt[2]; i++) {
80104200:	83 c0 01             	add    $0x1,%eax
80104203:	39 d0                	cmp    %edx,%eax
80104205:	74 19                	je     80104220 <scheduler+0x160>
                p = q2[i];
80104207:	8b 1c 85 c0 3d 11 80 	mov    -0x7feec240(,%eax,4),%ebx
                if (p->state != RUNNABLE)
8010420e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104212:	75 ec                	jne    80104200 <scheduler+0x140>
                beg2 = i;
80104214:	a3 4c b6 10 80       	mov    %eax,0x8010b64c
80104219:	e9 0c ff ff ff       	jmp    8010412a <scheduler+0x6a>
8010421e:	66 90                	xchg   %ax,%ax
            for (int i = 0; i < cnt[3]; i++) {
80104220:	8b 15 28 b6 10 80    	mov    0x8010b628,%edx
80104226:	85 d2                	test   %edx,%edx
80104228:	7e 36                	jle    80104260 <scheduler+0x1a0>
                p = q3[i];
8010422a:	8b 1d 80 4d 11 80    	mov    0x80114d80,%ebx
                if (p->state != RUNNABLE)
80104230:	31 c0                	xor    %eax,%eax
80104232:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104236:	74 1c                	je     80104254 <scheduler+0x194>
80104238:	90                   	nop
80104239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (int i = 0; i < cnt[3]; i++) {
80104240:	83 c0 01             	add    $0x1,%eax
80104243:	39 d0                	cmp    %edx,%eax
80104245:	74 19                	je     80104260 <scheduler+0x1a0>
                p = q3[i];
80104247:	8b 1c 85 80 4d 11 80 	mov    -0x7feeb280(,%eax,4),%ebx
                if (p->state != RUNNABLE)
8010424e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104252:	75 ec                	jne    80104240 <scheduler+0x180>
                beg3 = i;
80104254:	a3 48 b6 10 80       	mov    %eax,0x8010b648
80104259:	e9 cc fe ff ff       	jmp    8010412a <scheduler+0x6a>
8010425e:	66 90                	xchg   %ax,%ax
            for (int i = 0; i < cnt[4]; i++) {
80104260:	8b 15 2c b6 10 80    	mov    0x8010b62c,%edx
80104266:	85 d2                	test   %edx,%edx
80104268:	0f 8e 1b ff ff ff    	jle    80104189 <scheduler+0xc9>
                p = q4[i];
8010426e:	8b 1d a0 b1 11 80    	mov    0x8011b1a0,%ebx
            for (int i = 0; i < cnt[4]; i++) {
80104274:	31 c0                	xor    %eax,%eax
                if (p->state != RUNNABLE)
80104276:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010427a:	74 1c                	je     80104298 <scheduler+0x1d8>
8010427c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (int i = 0; i < cnt[4]; i++) {
80104280:	83 c0 01             	add    $0x1,%eax
80104283:	39 d0                	cmp    %edx,%eax
80104285:	0f 84 fe fe ff ff    	je     80104189 <scheduler+0xc9>
                p = q4[i];
8010428b:	8b 1c 85 a0 b1 11 80 	mov    -0x7fee4e60(,%eax,4),%ebx
                if (p->state != RUNNABLE)
80104292:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104296:	75 e8                	jne    80104280 <scheduler+0x1c0>
                beg4 = i;
80104298:	a3 44 b6 10 80       	mov    %eax,0x8010b644
8010429d:	e9 88 fe ff ff       	jmp    8010412a <scheduler+0x6a>
801042a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042b0 <sched>:
void sched(void) {
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	56                   	push   %esi
801042b4:	53                   	push   %ebx
    pushcli();
801042b5:	e8 f6 09 00 00       	call   80104cb0 <pushcli>
    c = mycpu();
801042ba:	e8 91 f5 ff ff       	call   80103850 <mycpu>
    p = c->proc;
801042bf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801042c5:	e8 26 0a 00 00       	call   80104cf0 <popcli>
    if (!holding(&ptable.lock))
801042ca:	83 ec 0c             	sub    $0xc,%esp
801042cd:	68 60 7c 11 80       	push   $0x80117c60
801042d2:	e8 79 0a 00 00       	call   80104d50 <holding>
801042d7:	83 c4 10             	add    $0x10,%esp
801042da:	85 c0                	test   %eax,%eax
801042dc:	74 4f                	je     8010432d <sched+0x7d>
    if (mycpu()->ncli != 1)
801042de:	e8 6d f5 ff ff       	call   80103850 <mycpu>
801042e3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801042ea:	75 68                	jne    80104354 <sched+0xa4>
    if (p->state == RUNNING)
801042ec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801042f0:	74 55                	je     80104347 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042f2:	9c                   	pushf  
801042f3:	58                   	pop    %eax
    if (readeflags() & FL_IF)
801042f4:	f6 c4 02             	test   $0x2,%ah
801042f7:	75 41                	jne    8010433a <sched+0x8a>
    intena = mycpu()->intena;
801042f9:	e8 52 f5 ff ff       	call   80103850 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
801042fe:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
80104301:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
80104307:	e8 44 f5 ff ff       	call   80103850 <mycpu>
8010430c:	83 ec 08             	sub    $0x8,%esp
8010430f:	ff 70 04             	pushl  0x4(%eax)
80104312:	53                   	push   %ebx
80104313:	e8 b3 0d 00 00       	call   801050cb <swtch>
    mycpu()->intena = intena;
80104318:	e8 33 f5 ff ff       	call   80103850 <mycpu>
}
8010431d:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80104320:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104326:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104329:	5b                   	pop    %ebx
8010432a:	5e                   	pop    %esi
8010432b:	5d                   	pop    %ebp
8010432c:	c3                   	ret    
        panic("sched ptable.lock");
8010432d:	83 ec 0c             	sub    $0xc,%esp
80104330:	68 1f 85 10 80       	push   $0x8010851f
80104335:	e8 56 c0 ff ff       	call   80100390 <panic>
        panic("sched interruptible");
8010433a:	83 ec 0c             	sub    $0xc,%esp
8010433d:	68 4b 85 10 80       	push   $0x8010854b
80104342:	e8 49 c0 ff ff       	call   80100390 <panic>
        panic("sched running");
80104347:	83 ec 0c             	sub    $0xc,%esp
8010434a:	68 3d 85 10 80       	push   $0x8010853d
8010434f:	e8 3c c0 ff ff       	call   80100390 <panic>
        panic("sched locks");
80104354:	83 ec 0c             	sub    $0xc,%esp
80104357:	68 31 85 10 80       	push   $0x80108531
8010435c:	e8 2f c0 ff ff       	call   80100390 <panic>
80104361:	eb 0d                	jmp    80104370 <exit>
80104363:	90                   	nop
80104364:	90                   	nop
80104365:	90                   	nop
80104366:	90                   	nop
80104367:	90                   	nop
80104368:	90                   	nop
80104369:	90                   	nop
8010436a:	90                   	nop
8010436b:	90                   	nop
8010436c:	90                   	nop
8010436d:	90                   	nop
8010436e:	90                   	nop
8010436f:	90                   	nop

80104370 <exit>:
void exit(void) {
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	57                   	push   %edi
80104374:	56                   	push   %esi
80104375:	53                   	push   %ebx
80104376:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
80104379:	e8 32 09 00 00       	call   80104cb0 <pushcli>
    c = mycpu();
8010437e:	e8 cd f4 ff ff       	call   80103850 <mycpu>
    p = c->proc;
80104383:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104389:	e8 62 09 00 00       	call   80104cf0 <popcli>
    if (curproc == initproc)
8010438e:	39 35 58 b6 10 80    	cmp    %esi,0x8010b658
80104394:	8d 5e 28             	lea    0x28(%esi),%ebx
80104397:	8d 7e 68             	lea    0x68(%esi),%edi
8010439a:	0f 84 fc 00 00 00    	je     8010449c <exit+0x12c>
        if (curproc->ofile[fd]) {
801043a0:	8b 03                	mov    (%ebx),%eax
801043a2:	85 c0                	test   %eax,%eax
801043a4:	74 12                	je     801043b8 <exit+0x48>
            fileclose(curproc->ofile[fd]);
801043a6:	83 ec 0c             	sub    $0xc,%esp
801043a9:	50                   	push   %eax
801043aa:	e8 91 ca ff ff       	call   80100e40 <fileclose>
            curproc->ofile[fd] = 0;
801043af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801043b5:	83 c4 10             	add    $0x10,%esp
801043b8:	83 c3 04             	add    $0x4,%ebx
    for (fd = 0; fd < NOFILE; fd++) {
801043bb:	39 fb                	cmp    %edi,%ebx
801043bd:	75 e1                	jne    801043a0 <exit+0x30>
    begin_op();
801043bf:	e8 dc e7 ff ff       	call   80102ba0 <begin_op>
    iput(curproc->cwd);
801043c4:	83 ec 0c             	sub    $0xc,%esp
801043c7:	ff 76 68             	pushl  0x68(%esi)
801043ca:	e8 e1 d3 ff ff       	call   801017b0 <iput>
    end_op();
801043cf:	e8 3c e8 ff ff       	call   80102c10 <end_op>
    curproc->cwd = 0;
801043d4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
    acquire(&ptable.lock);
801043db:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
801043e2:	e8 99 09 00 00       	call   80104d80 <acquire>
    wakeup1(curproc->parent);
801043e7:	8b 56 14             	mov    0x14(%esi),%edx
801043ea:	83 c4 10             	add    $0x10,%esp
// PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void wakeup1(void *chan) {
    struct proc *p;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ed:	b8 94 7c 11 80       	mov    $0x80117c94,%eax
801043f2:	eb 10                	jmp    80104404 <exit+0x94>
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043f8:	05 b0 00 00 00       	add    $0xb0,%eax
801043fd:	3d 94 a8 11 80       	cmp    $0x8011a894,%eax
80104402:	73 1e                	jae    80104422 <exit+0xb2>
        if (p->state == SLEEPING && p->chan == chan) {
80104404:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104408:	75 ee                	jne    801043f8 <exit+0x88>
8010440a:	3b 50 20             	cmp    0x20(%eax),%edx
8010440d:	75 e9                	jne    801043f8 <exit+0x88>
            p->state = RUNNABLE;
8010440f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104416:	05 b0 00 00 00       	add    $0xb0,%eax
8010441b:	3d 94 a8 11 80       	cmp    $0x8011a894,%eax
80104420:	72 e2                	jb     80104404 <exit+0x94>
            p->parent = initproc;
80104422:	8b 0d 58 b6 10 80    	mov    0x8010b658,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104428:	ba 94 7c 11 80       	mov    $0x80117c94,%edx
8010442d:	eb 0f                	jmp    8010443e <exit+0xce>
8010442f:	90                   	nop
80104430:	81 c2 b0 00 00 00    	add    $0xb0,%edx
80104436:	81 fa 94 a8 11 80    	cmp    $0x8011a894,%edx
8010443c:	73 3a                	jae    80104478 <exit+0x108>
        if (p->parent == curproc) {
8010443e:	39 72 14             	cmp    %esi,0x14(%edx)
80104441:	75 ed                	jne    80104430 <exit+0xc0>
            if (p->state == ZOMBIE)
80104443:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
80104447:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
8010444a:	75 e4                	jne    80104430 <exit+0xc0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010444c:	b8 94 7c 11 80       	mov    $0x80117c94,%eax
80104451:	eb 11                	jmp    80104464 <exit+0xf4>
80104453:	90                   	nop
80104454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104458:	05 b0 00 00 00       	add    $0xb0,%eax
8010445d:	3d 94 a8 11 80       	cmp    $0x8011a894,%eax
80104462:	73 cc                	jae    80104430 <exit+0xc0>
        if (p->state == SLEEPING && p->chan == chan) {
80104464:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104468:	75 ee                	jne    80104458 <exit+0xe8>
8010446a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010446d:	75 e9                	jne    80104458 <exit+0xe8>
            p->state = RUNNABLE;
8010446f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104476:	eb e0                	jmp    80104458 <exit+0xe8>
    curproc->etime = ticks;  // assign endtime value
80104478:	a1 80 c9 11 80       	mov    0x8011c980,%eax
    curproc->state = ZOMBIE;
8010447d:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    curproc->etime = ticks;  // assign endtime value
80104484:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
    sched();
8010448a:	e8 21 fe ff ff       	call   801042b0 <sched>
    panic("zombie exit");
8010448f:	83 ec 0c             	sub    $0xc,%esp
80104492:	68 6c 85 10 80       	push   $0x8010856c
80104497:	e8 f4 be ff ff       	call   80100390 <panic>
        panic("init exiting");
8010449c:	83 ec 0c             	sub    $0xc,%esp
8010449f:	68 5f 85 10 80       	push   $0x8010855f
801044a4:	e8 e7 be ff ff       	call   80100390 <panic>
801044a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044b0 <yield>:
void yield(void) {
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  // DOC: yieldlock
801044b7:	68 60 7c 11 80       	push   $0x80117c60
801044bc:	e8 bf 08 00 00       	call   80104d80 <acquire>
    pushcli();
801044c1:	e8 ea 07 00 00       	call   80104cb0 <pushcli>
    c = mycpu();
801044c6:	e8 85 f3 ff ff       	call   80103850 <mycpu>
    p = c->proc;
801044cb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801044d1:	e8 1a 08 00 00       	call   80104cf0 <popcli>
    myproc()->state = RUNNABLE;
801044d6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
801044dd:	e8 ce fd ff ff       	call   801042b0 <sched>
    release(&ptable.lock);
801044e2:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
801044e9:	e8 52 09 00 00       	call   80104e40 <release>
}
801044ee:	83 c4 10             	add    $0x10,%esp
801044f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f4:	c9                   	leave  
801044f5:	c3                   	ret    
801044f6:	8d 76 00             	lea    0x0(%esi),%esi
801044f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104500 <sleep>:
void sleep(void *chan, struct spinlock *lk) {
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	57                   	push   %edi
80104504:	56                   	push   %esi
80104505:	53                   	push   %ebx
80104506:	83 ec 0c             	sub    $0xc,%esp
80104509:	8b 7d 08             	mov    0x8(%ebp),%edi
8010450c:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
8010450f:	e8 9c 07 00 00       	call   80104cb0 <pushcli>
    c = mycpu();
80104514:	e8 37 f3 ff ff       	call   80103850 <mycpu>
    p = c->proc;
80104519:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
8010451f:	e8 cc 07 00 00       	call   80104cf0 <popcli>
    if (p == 0)
80104524:	85 db                	test   %ebx,%ebx
80104526:	0f 84 87 00 00 00    	je     801045b3 <sleep+0xb3>
    if (lk == 0)
8010452c:	85 f6                	test   %esi,%esi
8010452e:	74 76                	je     801045a6 <sleep+0xa6>
    if (lk != &ptable.lock) {   // DOC: sleeplock0
80104530:	81 fe 60 7c 11 80    	cmp    $0x80117c60,%esi
80104536:	74 50                	je     80104588 <sleep+0x88>
        acquire(&ptable.lock);  // DOC: sleeplock1
80104538:	83 ec 0c             	sub    $0xc,%esp
8010453b:	68 60 7c 11 80       	push   $0x80117c60
80104540:	e8 3b 08 00 00       	call   80104d80 <acquire>
        release(lk);
80104545:	89 34 24             	mov    %esi,(%esp)
80104548:	e8 f3 08 00 00       	call   80104e40 <release>
    p->chan = chan;
8010454d:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
80104550:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104557:	e8 54 fd ff ff       	call   801042b0 <sched>
    p->chan = 0;
8010455c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
80104563:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
8010456a:	e8 d1 08 00 00       	call   80104e40 <release>
        acquire(lk);
8010456f:	89 75 08             	mov    %esi,0x8(%ebp)
80104572:	83 c4 10             	add    $0x10,%esp
}
80104575:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104578:	5b                   	pop    %ebx
80104579:	5e                   	pop    %esi
8010457a:	5f                   	pop    %edi
8010457b:	5d                   	pop    %ebp
        acquire(lk);
8010457c:	e9 ff 07 00 00       	jmp    80104d80 <acquire>
80104581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->chan = chan;
80104588:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010458b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104592:	e8 19 fd ff ff       	call   801042b0 <sched>
    p->chan = 0;
80104597:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010459e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045a1:	5b                   	pop    %ebx
801045a2:	5e                   	pop    %esi
801045a3:	5f                   	pop    %edi
801045a4:	5d                   	pop    %ebp
801045a5:	c3                   	ret    
        panic("sleep without lk");
801045a6:	83 ec 0c             	sub    $0xc,%esp
801045a9:	68 7e 85 10 80       	push   $0x8010857e
801045ae:	e8 dd bd ff ff       	call   80100390 <panic>
        panic("sleep");
801045b3:	83 ec 0c             	sub    $0xc,%esp
801045b6:	68 78 85 10 80       	push   $0x80108578
801045bb:	e8 d0 bd ff ff       	call   80100390 <panic>

801045c0 <wait>:
int wait(void) {
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
    pushcli();
801045c5:	e8 e6 06 00 00       	call   80104cb0 <pushcli>
    c = mycpu();
801045ca:	e8 81 f2 ff ff       	call   80103850 <mycpu>
    p = c->proc;
801045cf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801045d5:	e8 16 07 00 00       	call   80104cf0 <popcli>
    acquire(&ptable.lock);
801045da:	83 ec 0c             	sub    $0xc,%esp
801045dd:	68 60 7c 11 80       	push   $0x80117c60
801045e2:	e8 99 07 00 00       	call   80104d80 <acquire>
801045e7:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
801045ea:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045ec:	bb 94 7c 11 80       	mov    $0x80117c94,%ebx
801045f1:	eb 13                	jmp    80104606 <wait+0x46>
801045f3:	90                   	nop
801045f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045f8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801045fe:	81 fb 94 a8 11 80    	cmp    $0x8011a894,%ebx
80104604:	73 1e                	jae    80104624 <wait+0x64>
            if (p->parent != curproc)
80104606:	39 73 14             	cmp    %esi,0x14(%ebx)
80104609:	75 ed                	jne    801045f8 <wait+0x38>
            if (p->state == ZOMBIE) {
8010460b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010460f:	74 37                	je     80104648 <wait+0x88>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104611:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
            havekids = 1;
80104617:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010461c:	81 fb 94 a8 11 80    	cmp    $0x8011a894,%ebx
80104622:	72 e2                	jb     80104606 <wait+0x46>
        if (!havekids || curproc->killed) {
80104624:	85 c0                	test   %eax,%eax
80104626:	74 76                	je     8010469e <wait+0xde>
80104628:	8b 46 24             	mov    0x24(%esi),%eax
8010462b:	85 c0                	test   %eax,%eax
8010462d:	75 6f                	jne    8010469e <wait+0xde>
        sleep(curproc, &ptable.lock);  // DOC: wait-sleep
8010462f:	83 ec 08             	sub    $0x8,%esp
80104632:	68 60 7c 11 80       	push   $0x80117c60
80104637:	56                   	push   %esi
80104638:	e8 c3 fe ff ff       	call   80104500 <sleep>
        havekids = 0;
8010463d:	83 c4 10             	add    $0x10,%esp
80104640:	eb a8                	jmp    801045ea <wait+0x2a>
80104642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                kfree(p->kstack);
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	ff 73 08             	pushl  0x8(%ebx)
8010464e:	e8 bd dc ff ff       	call   80102310 <kfree>
                freevm(p->pgdir);
80104653:	5a                   	pop    %edx
80104654:	ff 73 04             	pushl  0x4(%ebx)
                p->kstack = 0;
80104657:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
8010465e:	e8 cd 35 00 00       	call   80107c30 <freevm>
                release(&ptable.lock);
80104663:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
                p->pid = 0;
8010466a:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104671:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80104678:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
8010467c:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80104683:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
8010468a:	e8 b1 07 00 00       	call   80104e40 <release>
                return pid;
8010468f:	83 c4 10             	add    $0x10,%esp
}
80104692:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010469a:	5b                   	pop    %ebx
8010469b:	5e                   	pop    %esi
8010469c:	5d                   	pop    %ebp
8010469d:	c3                   	ret    
            release(&ptable.lock);
8010469e:	83 ec 0c             	sub    $0xc,%esp
801046a1:	68 60 7c 11 80       	push   $0x80117c60
801046a6:	e8 95 07 00 00       	call   80104e40 <release>
            return -1;
801046ab:	83 c4 10             	add    $0x10,%esp
801046ae:	eb e2                	jmp    80104692 <wait+0xd2>

801046b0 <waitx>:
int waitx(int *wtime, int *rtime) {
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	56                   	push   %esi
801046b4:	53                   	push   %ebx
    pushcli();
801046b5:	e8 f6 05 00 00       	call   80104cb0 <pushcli>
    c = mycpu();
801046ba:	e8 91 f1 ff ff       	call   80103850 <mycpu>
    p = c->proc;
801046bf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801046c5:	e8 26 06 00 00       	call   80104cf0 <popcli>
    acquire(&ptable.lock);
801046ca:	83 ec 0c             	sub    $0xc,%esp
801046cd:	68 60 7c 11 80       	push   $0x80117c60
801046d2:	e8 a9 06 00 00       	call   80104d80 <acquire>
801046d7:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
801046da:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801046dc:	bb 94 7c 11 80       	mov    $0x80117c94,%ebx
801046e1:	eb 13                	jmp    801046f6 <waitx+0x46>
801046e3:	90                   	nop
801046e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046e8:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801046ee:	81 fb 94 a8 11 80    	cmp    $0x8011a894,%ebx
801046f4:	73 1e                	jae    80104714 <waitx+0x64>
            if (p->parent != curproc)
801046f6:	39 73 14             	cmp    %esi,0x14(%ebx)
801046f9:	75 ed                	jne    801046e8 <waitx+0x38>
            if (p->state == ZOMBIE) {
801046fb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801046ff:	74 3f                	je     80104740 <waitx+0x90>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104701:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
            havekids = 1;
80104707:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010470c:	81 fb 94 a8 11 80    	cmp    $0x8011a894,%ebx
80104712:	72 e2                	jb     801046f6 <waitx+0x46>
        if (!havekids || curproc->killed) {
80104714:	85 c0                	test   %eax,%eax
80104716:	0f 84 9f 00 00 00    	je     801047bb <waitx+0x10b>
8010471c:	8b 46 24             	mov    0x24(%esi),%eax
8010471f:	85 c0                	test   %eax,%eax
80104721:	0f 85 94 00 00 00    	jne    801047bb <waitx+0x10b>
        sleep(curproc, &ptable.lock);  // DOC: wait-sleep
80104727:	83 ec 08             	sub    $0x8,%esp
8010472a:	68 60 7c 11 80       	push   $0x80117c60
8010472f:	56                   	push   %esi
80104730:	e8 cb fd ff ff       	call   80104500 <sleep>
        havekids = 0;
80104735:	83 c4 10             	add    $0x10,%esp
80104738:	eb a0                	jmp    801046da <waitx+0x2a>
8010473a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                *wtime = p->etime - p->ctime - p->rtime - p->iotime;
80104740:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80104746:	2b 43 7c             	sub    0x7c(%ebx),%eax
                kfree(p->kstack);
80104749:	83 ec 0c             	sub    $0xc,%esp
                *wtime = p->etime - p->ctime - p->rtime - p->iotime;
8010474c:	2b 83 80 00 00 00    	sub    0x80(%ebx),%eax
80104752:	8b 55 08             	mov    0x8(%ebp),%edx
80104755:	2b 83 88 00 00 00    	sub    0x88(%ebx),%eax
8010475b:	89 02                	mov    %eax,(%edx)
                *rtime = p->rtime;
8010475d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104760:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
80104766:	89 10                	mov    %edx,(%eax)
                kfree(p->kstack);
80104768:	ff 73 08             	pushl  0x8(%ebx)
                pid = p->pid;
8010476b:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
8010476e:	e8 9d db ff ff       	call   80102310 <kfree>
                freevm(p->pgdir);
80104773:	5a                   	pop    %edx
80104774:	ff 73 04             	pushl  0x4(%ebx)
                p->kstack = 0;
80104777:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
8010477e:	e8 ad 34 00 00       	call   80107c30 <freevm>
                release(&ptable.lock);
80104783:	c7 04 24 60 7c 11 80 	movl   $0x80117c60,(%esp)
                p->pid = 0;
8010478a:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104791:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80104798:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
8010479c:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
801047a3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
801047aa:	e8 91 06 00 00       	call   80104e40 <release>
                return pid;
801047af:	83 c4 10             	add    $0x10,%esp
}
801047b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047b5:	89 f0                	mov    %esi,%eax
801047b7:	5b                   	pop    %ebx
801047b8:	5e                   	pop    %esi
801047b9:	5d                   	pop    %ebp
801047ba:	c3                   	ret    
            release(&ptable.lock);
801047bb:	83 ec 0c             	sub    $0xc,%esp
            return -1;
801047be:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
801047c3:	68 60 7c 11 80       	push   $0x80117c60
801047c8:	e8 73 06 00 00       	call   80104e40 <release>
            return -1;
801047cd:	83 c4 10             	add    $0x10,%esp
801047d0:	eb e0                	jmp    801047b2 <waitx+0x102>
801047d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047e0 <wakeup>:
            // }
        }
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan) {
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	53                   	push   %ebx
801047e4:	83 ec 10             	sub    $0x10,%esp
801047e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
801047ea:	68 60 7c 11 80       	push   $0x80117c60
801047ef:	e8 8c 05 00 00       	call   80104d80 <acquire>
801047f4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047f7:	b8 94 7c 11 80       	mov    $0x80117c94,%eax
801047fc:	eb 0e                	jmp    8010480c <wakeup+0x2c>
801047fe:	66 90                	xchg   %ax,%ax
80104800:	05 b0 00 00 00       	add    $0xb0,%eax
80104805:	3d 94 a8 11 80       	cmp    $0x8011a894,%eax
8010480a:	73 1e                	jae    8010482a <wakeup+0x4a>
        if (p->state == SLEEPING && p->chan == chan) {
8010480c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104810:	75 ee                	jne    80104800 <wakeup+0x20>
80104812:	3b 58 20             	cmp    0x20(%eax),%ebx
80104815:	75 e9                	jne    80104800 <wakeup+0x20>
            p->state = RUNNABLE;
80104817:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010481e:	05 b0 00 00 00       	add    $0xb0,%eax
80104823:	3d 94 a8 11 80       	cmp    $0x8011a894,%eax
80104828:	72 e2                	jb     8010480c <wakeup+0x2c>
    wakeup1(chan);
    release(&ptable.lock);
8010482a:	c7 45 08 60 7c 11 80 	movl   $0x80117c60,0x8(%ebp)
}
80104831:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104834:	c9                   	leave  
    release(&ptable.lock);
80104835:	e9 06 06 00 00       	jmp    80104e40 <release>
8010483a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104840 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid) {
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	53                   	push   %ebx
80104844:	83 ec 10             	sub    $0x10,%esp
80104847:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
8010484a:	68 60 7c 11 80       	push   $0x80117c60
8010484f:	e8 2c 05 00 00       	call   80104d80 <acquire>
80104854:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104857:	b8 94 7c 11 80       	mov    $0x80117c94,%eax
8010485c:	eb 0e                	jmp    8010486c <kill+0x2c>
8010485e:	66 90                	xchg   %ax,%ax
80104860:	05 b0 00 00 00       	add    $0xb0,%eax
80104865:	3d 94 a8 11 80       	cmp    $0x8011a894,%eax
8010486a:	73 34                	jae    801048a0 <kill+0x60>
        if (p->pid == pid) {
8010486c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010486f:	75 ef                	jne    80104860 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
80104871:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
80104875:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING)
8010487c:	75 07                	jne    80104885 <kill+0x45>
                p->state = RUNNABLE;
8010487e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
80104885:	83 ec 0c             	sub    $0xc,%esp
80104888:	68 60 7c 11 80       	push   $0x80117c60
8010488d:	e8 ae 05 00 00       	call   80104e40 <release>
            return 0;
80104892:	83 c4 10             	add    $0x10,%esp
80104895:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
80104897:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010489a:	c9                   	leave  
8010489b:	c3                   	ret    
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
801048a0:	83 ec 0c             	sub    $0xc,%esp
801048a3:	68 60 7c 11 80       	push   $0x80117c60
801048a8:	e8 93 05 00 00       	call   80104e40 <release>
    return -1;
801048ad:	83 c4 10             	add    $0x10,%esp
801048b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048b8:	c9                   	leave  
801048b9:	c3                   	ret    
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048c0 <procdump>:

// PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	57                   	push   %edi
801048c4:	56                   	push   %esi
801048c5:	53                   	push   %ebx
801048c6:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801048c9:	bb 94 7c 11 80       	mov    $0x80117c94,%ebx
void procdump(void) {
801048ce:	83 ec 3c             	sub    $0x3c,%esp
801048d1:	eb 2d                	jmp    80104900 <procdump+0x40>
801048d3:	90                   	nop
801048d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == SLEEPING) {
            getcallerpcs((uint *)p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf(" - queue %d\n", p->qno);
801048d8:	83 ec 08             	sub    $0x8,%esp
801048db:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
801048e1:	68 9c 85 10 80       	push   $0x8010859c
801048e6:	e8 75 bd ff ff       	call   80100660 <cprintf>
801048eb:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801048ee:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801048f4:	81 fb 94 a8 11 80    	cmp    $0x8011a894,%ebx
801048fa:	0f 83 90 00 00 00    	jae    80104990 <procdump+0xd0>
        if (p->state == UNUSED)
80104900:	8b 43 0c             	mov    0xc(%ebx),%eax
80104903:	85 c0                	test   %eax,%eax
80104905:	74 e7                	je     801048ee <procdump+0x2e>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104907:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
8010490a:	ba 8f 85 10 80       	mov    $0x8010858f,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010490f:	77 11                	ja     80104922 <procdump+0x62>
80104911:	8b 14 85 60 86 10 80 	mov    -0x7fef79a0(,%eax,4),%edx
            state = "???";
80104918:	b8 8f 85 10 80       	mov    $0x8010858f,%eax
8010491d:	85 d2                	test   %edx,%edx
8010491f:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
80104922:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104925:	50                   	push   %eax
80104926:	52                   	push   %edx
80104927:	ff 73 10             	pushl  0x10(%ebx)
8010492a:	68 93 85 10 80       	push   $0x80108593
8010492f:	e8 2c bd ff ff       	call   80100660 <cprintf>
        if (p->state == SLEEPING) {
80104934:	83 c4 10             	add    $0x10,%esp
80104937:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
8010493b:	75 9b                	jne    801048d8 <procdump+0x18>
            getcallerpcs((uint *)p->context->ebp + 2, pc);
8010493d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104940:	83 ec 08             	sub    $0x8,%esp
80104943:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104946:	50                   	push   %eax
80104947:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010494a:	8b 40 0c             	mov    0xc(%eax),%eax
8010494d:	83 c0 08             	add    $0x8,%eax
80104950:	50                   	push   %eax
80104951:	e8 0a 03 00 00       	call   80104c60 <getcallerpcs>
80104956:	83 c4 10             	add    $0x10,%esp
80104959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104960:	8b 17                	mov    (%edi),%edx
80104962:	85 d2                	test   %edx,%edx
80104964:	0f 84 6e ff ff ff    	je     801048d8 <procdump+0x18>
                cprintf(" %p", pc[i]);
8010496a:	83 ec 08             	sub    $0x8,%esp
8010496d:	83 c7 04             	add    $0x4,%edi
80104970:	52                   	push   %edx
80104971:	68 a1 7f 10 80       	push   $0x80107fa1
80104976:	e8 e5 bc ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
8010497b:	83 c4 10             	add    $0x10,%esp
8010497e:	39 f7                	cmp    %esi,%edi
80104980:	75 de                	jne    80104960 <procdump+0xa0>
80104982:	e9 51 ff ff ff       	jmp    801048d8 <procdump+0x18>
80104987:	89 f6                	mov    %esi,%esi
80104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104990:	31 f6                	xor    %esi,%esi
    }

    for (int i = 0; i < 5; i++) {
        cprintf("\nQ %d : %d", i, cnt[i]);
80104992:	83 ec 04             	sub    $0x4,%esp
80104995:	ff 34 b5 1c b6 10 80 	pushl  -0x7fef49e4(,%esi,4)
8010499c:	56                   	push   %esi
8010499d:	68 a9 85 10 80       	push   $0x801085a9
801049a2:	e8 b9 bc ff ff       	call   80100660 <cprintf>
        if (i == 0) {
801049a7:	83 c4 10             	add    $0x10,%esp
801049aa:	85 f6                	test   %esi,%esi
801049ac:	74 77                	je     80104a25 <procdump+0x165>
            for (int j = 0; j < cnt[i]; j++) {
                cprintf("\n %d", q0[j]->pid);
            }
        } else if (i == 1) {
801049ae:	83 fe 01             	cmp    $0x1,%esi
801049b1:	0f 84 d6 00 00 00    	je     80104a8d <procdump+0x1cd>
            for (int j = 0; j < cnt[i]; j++) {
                cprintf("\n %d", q1[j]->pid);
            }
        } else if (i == 2) {
801049b7:	83 fe 02             	cmp    $0x2,%esi
801049ba:	0f 84 07 01 00 00    	je     80104ac7 <procdump+0x207>
            for (int j = 0; j < cnt[i]; j++) {
                cprintf("\n %d", q2[j]->pid);
            }
        } else if (i == 3) {
801049c0:	83 fe 03             	cmp    $0x3,%esi
801049c3:	0f 84 8f 00 00 00    	je     80104a58 <procdump+0x198>
            for (int j = 0; j < cnt[i]; j++) {
                cprintf("\n %d", q3[j]->pid);
            }
        } else if (i == 4) {
            for (int j = 0; j < cnt[i]; j++) {
801049c9:	8b 15 2c b6 10 80    	mov    0x8010b62c,%edx
801049cf:	31 db                	xor    %ebx,%ebx
801049d1:	85 d2                	test   %edx,%edx
801049d3:	7e 28                	jle    801049fd <procdump+0x13d>
801049d5:	8d 76 00             	lea    0x0(%esi),%esi
                cprintf("\n %d", q4[j]->pid);
801049d8:	8b 04 9d a0 b1 11 80 	mov    -0x7fee4e60(,%ebx,4),%eax
801049df:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
801049e2:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q4[j]->pid);
801049e5:	ff 70 10             	pushl  0x10(%eax)
801049e8:	68 b4 85 10 80       	push   $0x801085b4
801049ed:	e8 6e bc ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
801049f2:	83 c4 10             	add    $0x10,%esp
801049f5:	39 1d 2c b6 10 80    	cmp    %ebx,0x8010b62c
801049fb:	7f db                	jg     801049d8 <procdump+0x118>
    for (int i = 0; i < 5; i++) {
801049fd:	83 fe 04             	cmp    $0x4,%esi
80104a00:	74 0e                	je     80104a10 <procdump+0x150>
80104a02:	83 c6 01             	add    $0x1,%esi
80104a05:	eb 8b                	jmp    80104992 <procdump+0xd2>
80104a07:	89 f6                	mov    %esi,%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            }
        }
    }
    cprintf("\n");
80104a10:	83 ec 0c             	sub    $0xc,%esp
80104a13:	68 93 89 10 80       	push   $0x80108993
80104a18:	e8 43 bc ff ff       	call   80100660 <cprintf>
}
80104a1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a20:	5b                   	pop    %ebx
80104a21:	5e                   	pop    %esi
80104a22:	5f                   	pop    %edi
80104a23:	5d                   	pop    %ebp
80104a24:	c3                   	ret    
            for (int j = 0; j < cnt[i]; j++) {
80104a25:	8b 3d 1c b6 10 80    	mov    0x8010b61c,%edi
80104a2b:	85 ff                	test   %edi,%edi
80104a2d:	7e d3                	jle    80104a02 <procdump+0x142>
80104a2f:	31 db                	xor    %ebx,%ebx
                cprintf("\n %d", q0[j]->pid);
80104a31:	8b 04 9d c0 6c 11 80 	mov    -0x7fee9340(,%ebx,4),%eax
80104a38:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
80104a3b:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q0[j]->pid);
80104a3e:	ff 70 10             	pushl  0x10(%eax)
80104a41:	68 b4 85 10 80       	push   $0x801085b4
80104a46:	e8 15 bc ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
80104a4b:	83 c4 10             	add    $0x10,%esp
80104a4e:	39 1d 1c b6 10 80    	cmp    %ebx,0x8010b61c
80104a54:	7f db                	jg     80104a31 <procdump+0x171>
80104a56:	eb aa                	jmp    80104a02 <procdump+0x142>
            for (int j = 0; j < cnt[i]; j++) {
80104a58:	a1 28 b6 10 80       	mov    0x8010b628,%eax
80104a5d:	85 c0                	test   %eax,%eax
80104a5f:	7e a1                	jle    80104a02 <procdump+0x142>
80104a61:	31 db                	xor    %ebx,%ebx
                cprintf("\n %d", q3[j]->pid);
80104a63:	8b 04 9d 80 4d 11 80 	mov    -0x7feeb280(,%ebx,4),%eax
80104a6a:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
80104a6d:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q3[j]->pid);
80104a70:	ff 70 10             	pushl  0x10(%eax)
80104a73:	68 b4 85 10 80       	push   $0x801085b4
80104a78:	e8 e3 bb ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
80104a7d:	83 c4 10             	add    $0x10,%esp
80104a80:	39 1d 28 b6 10 80    	cmp    %ebx,0x8010b628
80104a86:	7f db                	jg     80104a63 <procdump+0x1a3>
80104a88:	e9 75 ff ff ff       	jmp    80104a02 <procdump+0x142>
            for (int j = 0; j < cnt[i]; j++) {
80104a8d:	8b 1d 20 b6 10 80    	mov    0x8010b620,%ebx
80104a93:	85 db                	test   %ebx,%ebx
80104a95:	0f 8e 67 ff ff ff    	jle    80104a02 <procdump+0x142>
80104a9b:	31 db                	xor    %ebx,%ebx
                cprintf("\n %d", q1[j]->pid);
80104a9d:	8b 04 9d 20 5d 11 80 	mov    -0x7feea2e0(,%ebx,4),%eax
80104aa4:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
80104aa7:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q1[j]->pid);
80104aaa:	ff 70 10             	pushl  0x10(%eax)
80104aad:	68 b4 85 10 80       	push   $0x801085b4
80104ab2:	e8 a9 bb ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
80104ab7:	83 c4 10             	add    $0x10,%esp
80104aba:	39 1d 20 b6 10 80    	cmp    %ebx,0x8010b620
80104ac0:	7f db                	jg     80104a9d <procdump+0x1dd>
80104ac2:	e9 3b ff ff ff       	jmp    80104a02 <procdump+0x142>
            for (int j = 0; j < cnt[i]; j++) {
80104ac7:	8b 0d 24 b6 10 80    	mov    0x8010b624,%ecx
80104acd:	85 c9                	test   %ecx,%ecx
80104acf:	0f 8e 2d ff ff ff    	jle    80104a02 <procdump+0x142>
80104ad5:	31 db                	xor    %ebx,%ebx
                cprintf("\n %d", q2[j]->pid);
80104ad7:	8b 04 9d c0 3d 11 80 	mov    -0x7feec240(,%ebx,4),%eax
80104ade:	83 ec 08             	sub    $0x8,%esp
            for (int j = 0; j < cnt[i]; j++) {
80104ae1:	83 c3 01             	add    $0x1,%ebx
                cprintf("\n %d", q2[j]->pid);
80104ae4:	ff 70 10             	pushl  0x10(%eax)
80104ae7:	68 b4 85 10 80       	push   $0x801085b4
80104aec:	e8 6f bb ff ff       	call   80100660 <cprintf>
            for (int j = 0; j < cnt[i]; j++) {
80104af1:	83 c4 10             	add    $0x10,%esp
80104af4:	39 1d 24 b6 10 80    	cmp    %ebx,0x8010b624
80104afa:	7f db                	jg     80104ad7 <procdump+0x217>
80104afc:	e9 01 ff ff ff       	jmp    80104a02 <procdump+0x142>
80104b01:	66 90                	xchg   %ax,%ax
80104b03:	66 90                	xchg   %ax,%ax
80104b05:	66 90                	xchg   %ax,%ax
80104b07:	66 90                	xchg   %ax,%ax
80104b09:	66 90                	xchg   %ax,%ax
80104b0b:	66 90                	xchg   %ax,%ax
80104b0d:	66 90                	xchg   %ax,%ax
80104b0f:	90                   	nop

80104b10 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 0c             	sub    $0xc,%esp
80104b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b1a:	68 78 86 10 80       	push   $0x80108678
80104b1f:	8d 43 04             	lea    0x4(%ebx),%eax
80104b22:	50                   	push   %eax
80104b23:	e8 18 01 00 00       	call   80104c40 <initlock>
  lk->name = name;
80104b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104b2b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104b31:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104b34:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104b3b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b41:	c9                   	leave  
80104b42:	c3                   	ret    
80104b43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b50 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
80104b55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b58:	83 ec 0c             	sub    $0xc,%esp
80104b5b:	8d 73 04             	lea    0x4(%ebx),%esi
80104b5e:	56                   	push   %esi
80104b5f:	e8 1c 02 00 00       	call   80104d80 <acquire>
  while (lk->locked) {
80104b64:	8b 13                	mov    (%ebx),%edx
80104b66:	83 c4 10             	add    $0x10,%esp
80104b69:	85 d2                	test   %edx,%edx
80104b6b:	74 16                	je     80104b83 <acquiresleep+0x33>
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104b70:	83 ec 08             	sub    $0x8,%esp
80104b73:	56                   	push   %esi
80104b74:	53                   	push   %ebx
80104b75:	e8 86 f9 ff ff       	call   80104500 <sleep>
  while (lk->locked) {
80104b7a:	8b 03                	mov    (%ebx),%eax
80104b7c:	83 c4 10             	add    $0x10,%esp
80104b7f:	85 c0                	test   %eax,%eax
80104b81:	75 ed                	jne    80104b70 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104b83:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104b89:	e8 62 ed ff ff       	call   801038f0 <myproc>
80104b8e:	8b 40 10             	mov    0x10(%eax),%eax
80104b91:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104b94:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b97:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b9a:	5b                   	pop    %ebx
80104b9b:	5e                   	pop    %esi
80104b9c:	5d                   	pop    %ebp
  release(&lk->lk);
80104b9d:	e9 9e 02 00 00       	jmp    80104e40 <release>
80104ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bb0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	53                   	push   %ebx
80104bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bb8:	83 ec 0c             	sub    $0xc,%esp
80104bbb:	8d 73 04             	lea    0x4(%ebx),%esi
80104bbe:	56                   	push   %esi
80104bbf:	e8 bc 01 00 00       	call   80104d80 <acquire>
  lk->locked = 0;
80104bc4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104bca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104bd1:	89 1c 24             	mov    %ebx,(%esp)
80104bd4:	e8 07 fc ff ff       	call   801047e0 <wakeup>
  release(&lk->lk);
80104bd9:	89 75 08             	mov    %esi,0x8(%ebp)
80104bdc:	83 c4 10             	add    $0x10,%esp
}
80104bdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104be2:	5b                   	pop    %ebx
80104be3:	5e                   	pop    %esi
80104be4:	5d                   	pop    %ebp
  release(&lk->lk);
80104be5:	e9 56 02 00 00       	jmp    80104e40 <release>
80104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bf0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	57                   	push   %edi
80104bf4:	56                   	push   %esi
80104bf5:	53                   	push   %ebx
80104bf6:	31 ff                	xor    %edi,%edi
80104bf8:	83 ec 18             	sub    $0x18,%esp
80104bfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104bfe:	8d 73 04             	lea    0x4(%ebx),%esi
80104c01:	56                   	push   %esi
80104c02:	e8 79 01 00 00       	call   80104d80 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104c07:	8b 03                	mov    (%ebx),%eax
80104c09:	83 c4 10             	add    $0x10,%esp
80104c0c:	85 c0                	test   %eax,%eax
80104c0e:	74 13                	je     80104c23 <holdingsleep+0x33>
80104c10:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104c13:	e8 d8 ec ff ff       	call   801038f0 <myproc>
80104c18:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c1b:	0f 94 c0             	sete   %al
80104c1e:	0f b6 c0             	movzbl %al,%eax
80104c21:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104c23:	83 ec 0c             	sub    $0xc,%esp
80104c26:	56                   	push   %esi
80104c27:	e8 14 02 00 00       	call   80104e40 <release>
  return r;
}
80104c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c2f:	89 f8                	mov    %edi,%eax
80104c31:	5b                   	pop    %ebx
80104c32:	5e                   	pop    %esi
80104c33:	5f                   	pop    %edi
80104c34:	5d                   	pop    %ebp
80104c35:	c3                   	ret    
80104c36:	66 90                	xchg   %ax,%ax
80104c38:	66 90                	xchg   %ax,%ax
80104c3a:	66 90                	xchg   %ax,%ax
80104c3c:	66 90                	xchg   %ax,%ax
80104c3e:	66 90                	xchg   %ax,%ax

80104c40 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104c46:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104c49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104c4f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104c52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c59:	5d                   	pop    %ebp
80104c5a:	c3                   	ret    
80104c5b:	90                   	nop
80104c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c60 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c60:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c61:	31 d2                	xor    %edx,%edx
{
80104c63:	89 e5                	mov    %esp,%ebp
80104c65:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c66:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c6c:	83 e8 08             	sub    $0x8,%eax
80104c6f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c70:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104c76:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c7c:	77 1a                	ja     80104c98 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c7e:	8b 58 04             	mov    0x4(%eax),%ebx
80104c81:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104c84:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104c87:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c89:	83 fa 0a             	cmp    $0xa,%edx
80104c8c:	75 e2                	jne    80104c70 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104c8e:	5b                   	pop    %ebx
80104c8f:	5d                   	pop    %ebp
80104c90:	c3                   	ret    
80104c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c98:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104c9b:	83 c1 28             	add    $0x28,%ecx
80104c9e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ca0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ca6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ca9:	39 c1                	cmp    %eax,%ecx
80104cab:	75 f3                	jne    80104ca0 <getcallerpcs+0x40>
}
80104cad:	5b                   	pop    %ebx
80104cae:	5d                   	pop    %ebp
80104caf:	c3                   	ret    

80104cb0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	53                   	push   %ebx
80104cb4:	83 ec 04             	sub    $0x4,%esp
80104cb7:	9c                   	pushf  
80104cb8:	5b                   	pop    %ebx
  asm volatile("cli");
80104cb9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104cba:	e8 91 eb ff ff       	call   80103850 <mycpu>
80104cbf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104cc5:	85 c0                	test   %eax,%eax
80104cc7:	75 11                	jne    80104cda <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104cc9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104ccf:	e8 7c eb ff ff       	call   80103850 <mycpu>
80104cd4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104cda:	e8 71 eb ff ff       	call   80103850 <mycpu>
80104cdf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ce6:	83 c4 04             	add    $0x4,%esp
80104ce9:	5b                   	pop    %ebx
80104cea:	5d                   	pop    %ebp
80104ceb:	c3                   	ret    
80104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cf0 <popcli>:

void
popcli(void)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104cf6:	9c                   	pushf  
80104cf7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104cf8:	f6 c4 02             	test   $0x2,%ah
80104cfb:	75 35                	jne    80104d32 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104cfd:	e8 4e eb ff ff       	call   80103850 <mycpu>
80104d02:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104d09:	78 34                	js     80104d3f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d0b:	e8 40 eb ff ff       	call   80103850 <mycpu>
80104d10:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d16:	85 d2                	test   %edx,%edx
80104d18:	74 06                	je     80104d20 <popcli+0x30>
    sti();
}
80104d1a:	c9                   	leave  
80104d1b:	c3                   	ret    
80104d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d20:	e8 2b eb ff ff       	call   80103850 <mycpu>
80104d25:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d2b:	85 c0                	test   %eax,%eax
80104d2d:	74 eb                	je     80104d1a <popcli+0x2a>
  asm volatile("sti");
80104d2f:	fb                   	sti    
}
80104d30:	c9                   	leave  
80104d31:	c3                   	ret    
    panic("popcli - interruptible");
80104d32:	83 ec 0c             	sub    $0xc,%esp
80104d35:	68 83 86 10 80       	push   $0x80108683
80104d3a:	e8 51 b6 ff ff       	call   80100390 <panic>
    panic("popcli");
80104d3f:	83 ec 0c             	sub    $0xc,%esp
80104d42:	68 9a 86 10 80       	push   $0x8010869a
80104d47:	e8 44 b6 ff ff       	call   80100390 <panic>
80104d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d50 <holding>:
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
80104d55:	8b 75 08             	mov    0x8(%ebp),%esi
80104d58:	31 db                	xor    %ebx,%ebx
  pushcli();
80104d5a:	e8 51 ff ff ff       	call   80104cb0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d5f:	8b 06                	mov    (%esi),%eax
80104d61:	85 c0                	test   %eax,%eax
80104d63:	74 10                	je     80104d75 <holding+0x25>
80104d65:	8b 5e 08             	mov    0x8(%esi),%ebx
80104d68:	e8 e3 ea ff ff       	call   80103850 <mycpu>
80104d6d:	39 c3                	cmp    %eax,%ebx
80104d6f:	0f 94 c3             	sete   %bl
80104d72:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104d75:	e8 76 ff ff ff       	call   80104cf0 <popcli>
}
80104d7a:	89 d8                	mov    %ebx,%eax
80104d7c:	5b                   	pop    %ebx
80104d7d:	5e                   	pop    %esi
80104d7e:	5d                   	pop    %ebp
80104d7f:	c3                   	ret    

80104d80 <acquire>:
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104d85:	e8 26 ff ff ff       	call   80104cb0 <pushcli>
  if(holding(lk))
80104d8a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d8d:	83 ec 0c             	sub    $0xc,%esp
80104d90:	53                   	push   %ebx
80104d91:	e8 ba ff ff ff       	call   80104d50 <holding>
80104d96:	83 c4 10             	add    $0x10,%esp
80104d99:	85 c0                	test   %eax,%eax
80104d9b:	0f 85 83 00 00 00    	jne    80104e24 <acquire+0xa4>
80104da1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104da3:	ba 01 00 00 00       	mov    $0x1,%edx
80104da8:	eb 09                	jmp    80104db3 <acquire+0x33>
80104daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104db0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104db3:	89 d0                	mov    %edx,%eax
80104db5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104db8:	85 c0                	test   %eax,%eax
80104dba:	75 f4                	jne    80104db0 <acquire+0x30>
  __sync_synchronize();
80104dbc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104dc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dc4:	e8 87 ea ff ff       	call   80103850 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104dc9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104dcc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104dcf:	89 e8                	mov    %ebp,%eax
80104dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104dd8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104dde:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104de4:	77 1a                	ja     80104e00 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104de6:	8b 48 04             	mov    0x4(%eax),%ecx
80104de9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104dec:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104def:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104df1:	83 fe 0a             	cmp    $0xa,%esi
80104df4:	75 e2                	jne    80104dd8 <acquire+0x58>
}
80104df6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104df9:	5b                   	pop    %ebx
80104dfa:	5e                   	pop    %esi
80104dfb:	5d                   	pop    %ebp
80104dfc:	c3                   	ret    
80104dfd:	8d 76 00             	lea    0x0(%esi),%esi
80104e00:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104e03:	83 c2 28             	add    $0x28,%edx
80104e06:	8d 76 00             	lea    0x0(%esi),%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104e10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104e16:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104e19:	39 d0                	cmp    %edx,%eax
80104e1b:	75 f3                	jne    80104e10 <acquire+0x90>
}
80104e1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e20:	5b                   	pop    %ebx
80104e21:	5e                   	pop    %esi
80104e22:	5d                   	pop    %ebp
80104e23:	c3                   	ret    
    panic("acquire");
80104e24:	83 ec 0c             	sub    $0xc,%esp
80104e27:	68 a1 86 10 80       	push   $0x801086a1
80104e2c:	e8 5f b5 ff ff       	call   80100390 <panic>
80104e31:	eb 0d                	jmp    80104e40 <release>
80104e33:	90                   	nop
80104e34:	90                   	nop
80104e35:	90                   	nop
80104e36:	90                   	nop
80104e37:	90                   	nop
80104e38:	90                   	nop
80104e39:	90                   	nop
80104e3a:	90                   	nop
80104e3b:	90                   	nop
80104e3c:	90                   	nop
80104e3d:	90                   	nop
80104e3e:	90                   	nop
80104e3f:	90                   	nop

80104e40 <release>:
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	53                   	push   %ebx
80104e44:	83 ec 10             	sub    $0x10,%esp
80104e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104e4a:	53                   	push   %ebx
80104e4b:	e8 00 ff ff ff       	call   80104d50 <holding>
80104e50:	83 c4 10             	add    $0x10,%esp
80104e53:	85 c0                	test   %eax,%eax
80104e55:	74 22                	je     80104e79 <release+0x39>
  lk->pcs[0] = 0;
80104e57:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104e5e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104e65:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104e6a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104e70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e73:	c9                   	leave  
  popcli();
80104e74:	e9 77 fe ff ff       	jmp    80104cf0 <popcli>
    panic("release");
80104e79:	83 ec 0c             	sub    $0xc,%esp
80104e7c:	68 a9 86 10 80       	push   $0x801086a9
80104e81:	e8 0a b5 ff ff       	call   80100390 <panic>
80104e86:	66 90                	xchg   %ax,%ax
80104e88:	66 90                	xchg   %ax,%ax
80104e8a:	66 90                	xchg   %ax,%ax
80104e8c:	66 90                	xchg   %ax,%ax
80104e8e:	66 90                	xchg   %ax,%ax

80104e90 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	57                   	push   %edi
80104e94:	53                   	push   %ebx
80104e95:	8b 55 08             	mov    0x8(%ebp),%edx
80104e98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104e9b:	f6 c2 03             	test   $0x3,%dl
80104e9e:	75 05                	jne    80104ea5 <memset+0x15>
80104ea0:	f6 c1 03             	test   $0x3,%cl
80104ea3:	74 13                	je     80104eb8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104ea5:	89 d7                	mov    %edx,%edi
80104ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eaa:	fc                   	cld    
80104eab:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104ead:	5b                   	pop    %ebx
80104eae:	89 d0                	mov    %edx,%eax
80104eb0:	5f                   	pop    %edi
80104eb1:	5d                   	pop    %ebp
80104eb2:	c3                   	ret    
80104eb3:	90                   	nop
80104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104eb8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104ebc:	c1 e9 02             	shr    $0x2,%ecx
80104ebf:	89 f8                	mov    %edi,%eax
80104ec1:	89 fb                	mov    %edi,%ebx
80104ec3:	c1 e0 18             	shl    $0x18,%eax
80104ec6:	c1 e3 10             	shl    $0x10,%ebx
80104ec9:	09 d8                	or     %ebx,%eax
80104ecb:	09 f8                	or     %edi,%eax
80104ecd:	c1 e7 08             	shl    $0x8,%edi
80104ed0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104ed2:	89 d7                	mov    %edx,%edi
80104ed4:	fc                   	cld    
80104ed5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104ed7:	5b                   	pop    %ebx
80104ed8:	89 d0                	mov    %edx,%eax
80104eda:	5f                   	pop    %edi
80104edb:	5d                   	pop    %ebp
80104edc:	c3                   	ret    
80104edd:	8d 76 00             	lea    0x0(%esi),%esi

80104ee0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	57                   	push   %edi
80104ee4:	56                   	push   %esi
80104ee5:	53                   	push   %ebx
80104ee6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ee9:	8b 75 08             	mov    0x8(%ebp),%esi
80104eec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104eef:	85 db                	test   %ebx,%ebx
80104ef1:	74 29                	je     80104f1c <memcmp+0x3c>
    if(*s1 != *s2)
80104ef3:	0f b6 16             	movzbl (%esi),%edx
80104ef6:	0f b6 0f             	movzbl (%edi),%ecx
80104ef9:	38 d1                	cmp    %dl,%cl
80104efb:	75 2b                	jne    80104f28 <memcmp+0x48>
80104efd:	b8 01 00 00 00       	mov    $0x1,%eax
80104f02:	eb 14                	jmp    80104f18 <memcmp+0x38>
80104f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f08:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104f0c:	83 c0 01             	add    $0x1,%eax
80104f0f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104f14:	38 ca                	cmp    %cl,%dl
80104f16:	75 10                	jne    80104f28 <memcmp+0x48>
  while(n-- > 0){
80104f18:	39 d8                	cmp    %ebx,%eax
80104f1a:	75 ec                	jne    80104f08 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104f1c:	5b                   	pop    %ebx
  return 0;
80104f1d:	31 c0                	xor    %eax,%eax
}
80104f1f:	5e                   	pop    %esi
80104f20:	5f                   	pop    %edi
80104f21:	5d                   	pop    %ebp
80104f22:	c3                   	ret    
80104f23:	90                   	nop
80104f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104f28:	0f b6 c2             	movzbl %dl,%eax
}
80104f2b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104f2c:	29 c8                	sub    %ecx,%eax
}
80104f2e:	5e                   	pop    %esi
80104f2f:	5f                   	pop    %edi
80104f30:	5d                   	pop    %ebp
80104f31:	c3                   	ret    
80104f32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f40 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
80104f45:	8b 45 08             	mov    0x8(%ebp),%eax
80104f48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104f4b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104f4e:	39 c3                	cmp    %eax,%ebx
80104f50:	73 26                	jae    80104f78 <memmove+0x38>
80104f52:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104f55:	39 c8                	cmp    %ecx,%eax
80104f57:	73 1f                	jae    80104f78 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104f59:	85 f6                	test   %esi,%esi
80104f5b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104f5e:	74 0f                	je     80104f6f <memmove+0x2f>
      *--d = *--s;
80104f60:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104f64:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104f67:	83 ea 01             	sub    $0x1,%edx
80104f6a:	83 fa ff             	cmp    $0xffffffff,%edx
80104f6d:	75 f1                	jne    80104f60 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104f6f:	5b                   	pop    %ebx
80104f70:	5e                   	pop    %esi
80104f71:	5d                   	pop    %ebp
80104f72:	c3                   	ret    
80104f73:	90                   	nop
80104f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104f78:	31 d2                	xor    %edx,%edx
80104f7a:	85 f6                	test   %esi,%esi
80104f7c:	74 f1                	je     80104f6f <memmove+0x2f>
80104f7e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104f80:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104f84:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104f87:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104f8a:	39 d6                	cmp    %edx,%esi
80104f8c:	75 f2                	jne    80104f80 <memmove+0x40>
}
80104f8e:	5b                   	pop    %ebx
80104f8f:	5e                   	pop    %esi
80104f90:	5d                   	pop    %ebp
80104f91:	c3                   	ret    
80104f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fa0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104fa3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104fa4:	eb 9a                	jmp    80104f40 <memmove>
80104fa6:	8d 76 00             	lea    0x0(%esi),%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fb0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	57                   	push   %edi
80104fb4:	56                   	push   %esi
80104fb5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104fb8:	53                   	push   %ebx
80104fb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fbc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104fbf:	85 ff                	test   %edi,%edi
80104fc1:	74 2f                	je     80104ff2 <strncmp+0x42>
80104fc3:	0f b6 01             	movzbl (%ecx),%eax
80104fc6:	0f b6 1e             	movzbl (%esi),%ebx
80104fc9:	84 c0                	test   %al,%al
80104fcb:	74 37                	je     80105004 <strncmp+0x54>
80104fcd:	38 c3                	cmp    %al,%bl
80104fcf:	75 33                	jne    80105004 <strncmp+0x54>
80104fd1:	01 f7                	add    %esi,%edi
80104fd3:	eb 13                	jmp    80104fe8 <strncmp+0x38>
80104fd5:	8d 76 00             	lea    0x0(%esi),%esi
80104fd8:	0f b6 01             	movzbl (%ecx),%eax
80104fdb:	84 c0                	test   %al,%al
80104fdd:	74 21                	je     80105000 <strncmp+0x50>
80104fdf:	0f b6 1a             	movzbl (%edx),%ebx
80104fe2:	89 d6                	mov    %edx,%esi
80104fe4:	38 d8                	cmp    %bl,%al
80104fe6:	75 1c                	jne    80105004 <strncmp+0x54>
    n--, p++, q++;
80104fe8:	8d 56 01             	lea    0x1(%esi),%edx
80104feb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104fee:	39 fa                	cmp    %edi,%edx
80104ff0:	75 e6                	jne    80104fd8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104ff2:	5b                   	pop    %ebx
    return 0;
80104ff3:	31 c0                	xor    %eax,%eax
}
80104ff5:	5e                   	pop    %esi
80104ff6:	5f                   	pop    %edi
80104ff7:	5d                   	pop    %ebp
80104ff8:	c3                   	ret    
80104ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105000:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105004:	29 d8                	sub    %ebx,%eax
}
80105006:	5b                   	pop    %ebx
80105007:	5e                   	pop    %esi
80105008:	5f                   	pop    %edi
80105009:	5d                   	pop    %ebp
8010500a:	c3                   	ret    
8010500b:	90                   	nop
8010500c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105010 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
80105015:	8b 45 08             	mov    0x8(%ebp),%eax
80105018:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010501b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010501e:	89 c2                	mov    %eax,%edx
80105020:	eb 19                	jmp    8010503b <strncpy+0x2b>
80105022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105028:	83 c3 01             	add    $0x1,%ebx
8010502b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010502f:	83 c2 01             	add    $0x1,%edx
80105032:	84 c9                	test   %cl,%cl
80105034:	88 4a ff             	mov    %cl,-0x1(%edx)
80105037:	74 09                	je     80105042 <strncpy+0x32>
80105039:	89 f1                	mov    %esi,%ecx
8010503b:	85 c9                	test   %ecx,%ecx
8010503d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105040:	7f e6                	jg     80105028 <strncpy+0x18>
    ;
  while(n-- > 0)
80105042:	31 c9                	xor    %ecx,%ecx
80105044:	85 f6                	test   %esi,%esi
80105046:	7e 17                	jle    8010505f <strncpy+0x4f>
80105048:	90                   	nop
80105049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105050:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105054:	89 f3                	mov    %esi,%ebx
80105056:	83 c1 01             	add    $0x1,%ecx
80105059:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010505b:	85 db                	test   %ebx,%ebx
8010505d:	7f f1                	jg     80105050 <strncpy+0x40>
  return os;
}
8010505f:	5b                   	pop    %ebx
80105060:	5e                   	pop    %esi
80105061:	5d                   	pop    %ebp
80105062:	c3                   	ret    
80105063:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105070 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	56                   	push   %esi
80105074:	53                   	push   %ebx
80105075:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105078:	8b 45 08             	mov    0x8(%ebp),%eax
8010507b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010507e:	85 c9                	test   %ecx,%ecx
80105080:	7e 26                	jle    801050a8 <safestrcpy+0x38>
80105082:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105086:	89 c1                	mov    %eax,%ecx
80105088:	eb 17                	jmp    801050a1 <safestrcpy+0x31>
8010508a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105090:	83 c2 01             	add    $0x1,%edx
80105093:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105097:	83 c1 01             	add    $0x1,%ecx
8010509a:	84 db                	test   %bl,%bl
8010509c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010509f:	74 04                	je     801050a5 <safestrcpy+0x35>
801050a1:	39 f2                	cmp    %esi,%edx
801050a3:	75 eb                	jne    80105090 <safestrcpy+0x20>
    ;
  *s = 0;
801050a5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801050a8:	5b                   	pop    %ebx
801050a9:	5e                   	pop    %esi
801050aa:	5d                   	pop    %ebp
801050ab:	c3                   	ret    
801050ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050b0 <strlen>:

int
strlen(const char *s)
{
801050b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801050b1:	31 c0                	xor    %eax,%eax
{
801050b3:	89 e5                	mov    %esp,%ebp
801050b5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801050b8:	80 3a 00             	cmpb   $0x0,(%edx)
801050bb:	74 0c                	je     801050c9 <strlen+0x19>
801050bd:	8d 76 00             	lea    0x0(%esi),%esi
801050c0:	83 c0 01             	add    $0x1,%eax
801050c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801050c7:	75 f7                	jne    801050c0 <strlen+0x10>
    ;
  return n;
}
801050c9:	5d                   	pop    %ebp
801050ca:	c3                   	ret    

801050cb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801050cb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801050cf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801050d3:	55                   	push   %ebp
  pushl %ebx
801050d4:	53                   	push   %ebx
  pushl %esi
801050d5:	56                   	push   %esi
  pushl %edi
801050d6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801050d7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801050d9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801050db:	5f                   	pop    %edi
  popl %esi
801050dc:	5e                   	pop    %esi
  popl %ebx
801050dd:	5b                   	pop    %ebx
  popl %ebp
801050de:	5d                   	pop    %ebp
  ret
801050df:	c3                   	ret    

801050e0 <fetchint>:
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip) {
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	53                   	push   %ebx
801050e4:	83 ec 04             	sub    $0x4,%esp
801050e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *curproc = myproc();
801050ea:	e8 01 e8 ff ff       	call   801038f0 <myproc>

    if (addr >= curproc->sz || addr + 4 > curproc->sz)
801050ef:	8b 00                	mov    (%eax),%eax
801050f1:	39 d8                	cmp    %ebx,%eax
801050f3:	76 1b                	jbe    80105110 <fetchint+0x30>
801050f5:	8d 53 04             	lea    0x4(%ebx),%edx
801050f8:	39 d0                	cmp    %edx,%eax
801050fa:	72 14                	jb     80105110 <fetchint+0x30>
        return -1;
    *ip = *(int *)(addr);
801050fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ff:	8b 13                	mov    (%ebx),%edx
80105101:	89 10                	mov    %edx,(%eax)
    return 0;
80105103:	31 c0                	xor    %eax,%eax
}
80105105:	83 c4 04             	add    $0x4,%esp
80105108:	5b                   	pop    %ebx
80105109:	5d                   	pop    %ebp
8010510a:	c3                   	ret    
8010510b:	90                   	nop
8010510c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105115:	eb ee                	jmp    80105105 <fetchint+0x25>
80105117:	89 f6                	mov    %esi,%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp) {
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	53                   	push   %ebx
80105124:	83 ec 04             	sub    $0x4,%esp
80105127:	8b 5d 08             	mov    0x8(%ebp),%ebx
    char *s, *ep;
    struct proc *curproc = myproc();
8010512a:	e8 c1 e7 ff ff       	call   801038f0 <myproc>

    if (addr >= curproc->sz)
8010512f:	39 18                	cmp    %ebx,(%eax)
80105131:	76 29                	jbe    8010515c <fetchstr+0x3c>
        return -1;
    *pp = (char *)addr;
80105133:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105136:	89 da                	mov    %ebx,%edx
80105138:	89 19                	mov    %ebx,(%ecx)
    ep = (char *)curproc->sz;
8010513a:	8b 00                	mov    (%eax),%eax
    for (s = *pp; s < ep; s++) {
8010513c:	39 c3                	cmp    %eax,%ebx
8010513e:	73 1c                	jae    8010515c <fetchstr+0x3c>
        if (*s == 0)
80105140:	80 3b 00             	cmpb   $0x0,(%ebx)
80105143:	75 10                	jne    80105155 <fetchstr+0x35>
80105145:	eb 39                	jmp    80105180 <fetchstr+0x60>
80105147:	89 f6                	mov    %esi,%esi
80105149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105150:	80 3a 00             	cmpb   $0x0,(%edx)
80105153:	74 1b                	je     80105170 <fetchstr+0x50>
    for (s = *pp; s < ep; s++) {
80105155:	83 c2 01             	add    $0x1,%edx
80105158:	39 d0                	cmp    %edx,%eax
8010515a:	77 f4                	ja     80105150 <fetchstr+0x30>
        return -1;
8010515c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return s - *pp;
    }
    return -1;
}
80105161:	83 c4 04             	add    $0x4,%esp
80105164:	5b                   	pop    %ebx
80105165:	5d                   	pop    %ebp
80105166:	c3                   	ret    
80105167:	89 f6                	mov    %esi,%esi
80105169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105170:	83 c4 04             	add    $0x4,%esp
80105173:	89 d0                	mov    %edx,%eax
80105175:	29 d8                	sub    %ebx,%eax
80105177:	5b                   	pop    %ebx
80105178:	5d                   	pop    %ebp
80105179:	c3                   	ret    
8010517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (*s == 0)
80105180:	31 c0                	xor    %eax,%eax
            return s - *pp;
80105182:	eb dd                	jmp    80105161 <fetchstr+0x41>
80105184:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010518a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105190 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip) {
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	56                   	push   %esi
80105194:	53                   	push   %ebx
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80105195:	e8 56 e7 ff ff       	call   801038f0 <myproc>
8010519a:	8b 40 18             	mov    0x18(%eax),%eax
8010519d:	8b 55 08             	mov    0x8(%ebp),%edx
801051a0:	8b 40 44             	mov    0x44(%eax),%eax
801051a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    struct proc *curproc = myproc();
801051a6:	e8 45 e7 ff ff       	call   801038f0 <myproc>
    if (addr >= curproc->sz || addr + 4 > curproc->sz)
801051ab:	8b 00                	mov    (%eax),%eax
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
801051ad:	8d 73 04             	lea    0x4(%ebx),%esi
    if (addr >= curproc->sz || addr + 4 > curproc->sz)
801051b0:	39 c6                	cmp    %eax,%esi
801051b2:	73 1c                	jae    801051d0 <argint+0x40>
801051b4:	8d 53 08             	lea    0x8(%ebx),%edx
801051b7:	39 d0                	cmp    %edx,%eax
801051b9:	72 15                	jb     801051d0 <argint+0x40>
    *ip = *(int *)(addr);
801051bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801051be:	8b 53 04             	mov    0x4(%ebx),%edx
801051c1:	89 10                	mov    %edx,(%eax)
    return 0;
801051c3:	31 c0                	xor    %eax,%eax
}
801051c5:	5b                   	pop    %ebx
801051c6:	5e                   	pop    %esi
801051c7:	5d                   	pop    %ebp
801051c8:	c3                   	ret    
801051c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801051d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
801051d5:	eb ee                	jmp    801051c5 <argint+0x35>
801051d7:	89 f6                	mov    %esi,%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051e0 <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size) {
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	56                   	push   %esi
801051e4:	53                   	push   %ebx
801051e5:	83 ec 10             	sub    $0x10,%esp
801051e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
    int i;
    struct proc *curproc = myproc();
801051eb:	e8 00 e7 ff ff       	call   801038f0 <myproc>
801051f0:	89 c6                	mov    %eax,%esi

    if (argint(n, &i) < 0)
801051f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051f5:	83 ec 08             	sub    $0x8,%esp
801051f8:	50                   	push   %eax
801051f9:	ff 75 08             	pushl  0x8(%ebp)
801051fc:	e8 8f ff ff ff       	call   80105190 <argint>
        return -1;
    if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz)
80105201:	83 c4 10             	add    $0x10,%esp
80105204:	85 c0                	test   %eax,%eax
80105206:	78 28                	js     80105230 <argptr+0x50>
80105208:	85 db                	test   %ebx,%ebx
8010520a:	78 24                	js     80105230 <argptr+0x50>
8010520c:	8b 16                	mov    (%esi),%edx
8010520e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105211:	39 c2                	cmp    %eax,%edx
80105213:	76 1b                	jbe    80105230 <argptr+0x50>
80105215:	01 c3                	add    %eax,%ebx
80105217:	39 da                	cmp    %ebx,%edx
80105219:	72 15                	jb     80105230 <argptr+0x50>
        return -1;
    *pp = (char *)i;
8010521b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010521e:	89 02                	mov    %eax,(%edx)
    return 0;
80105220:	31 c0                	xor    %eax,%eax
}
80105222:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105225:	5b                   	pop    %ebx
80105226:	5e                   	pop    %esi
80105227:	5d                   	pop    %ebp
80105228:	c3                   	ret    
80105229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105235:	eb eb                	jmp    80105222 <argptr+0x42>
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105240 <argstr>:

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp) {
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	83 ec 20             	sub    $0x20,%esp
    int addr;
    if (argint(n, &addr) < 0)
80105246:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105249:	50                   	push   %eax
8010524a:	ff 75 08             	pushl  0x8(%ebp)
8010524d:	e8 3e ff ff ff       	call   80105190 <argint>
80105252:	83 c4 10             	add    $0x10,%esp
80105255:	85 c0                	test   %eax,%eax
80105257:	78 17                	js     80105270 <argstr+0x30>
        return -1;
    return fetchstr(addr, pp);
80105259:	83 ec 08             	sub    $0x8,%esp
8010525c:	ff 75 0c             	pushl  0xc(%ebp)
8010525f:	ff 75 f4             	pushl  -0xc(%ebp)
80105262:	e8 b9 fe ff ff       	call   80105120 <fetchstr>
80105267:	83 c4 10             	add    $0x10,%esp
}
8010526a:	c9                   	leave  
8010526b:	c3                   	ret    
8010526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105275:	c9                   	leave  
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105280 <syscall>:
    [SYS_waitx] sys_waitx,
    [SYS_set_priority] sys_set_priority,
    [SYS_getpinfo] sys_getpinfo,
};

void syscall(void) {
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	53                   	push   %ebx
80105284:	83 ec 04             	sub    $0x4,%esp
    int num;
    struct proc *curproc = myproc();
80105287:	e8 64 e6 ff ff       	call   801038f0 <myproc>
8010528c:	89 c3                	mov    %eax,%ebx

    num = curproc->tf->eax;
8010528e:	8b 40 18             	mov    0x18(%eax),%eax
80105291:	8b 40 1c             	mov    0x1c(%eax),%eax
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105294:	8d 50 ff             	lea    -0x1(%eax),%edx
80105297:	83 fa 17             	cmp    $0x17,%edx
8010529a:	77 1c                	ja     801052b8 <syscall+0x38>
8010529c:	8b 14 85 e0 86 10 80 	mov    -0x7fef7920(,%eax,4),%edx
801052a3:	85 d2                	test   %edx,%edx
801052a5:	74 11                	je     801052b8 <syscall+0x38>
        curproc->tf->eax = syscalls[num]();
801052a7:	ff d2                	call   *%edx
801052a9:	8b 53 18             	mov    0x18(%ebx),%edx
801052ac:	89 42 1c             	mov    %eax,0x1c(%edx)
    } else {
        cprintf("%d %s: unknown sys call %d\n", curproc->pid, curproc->name,
                num);
        curproc->tf->eax = -1;
    }
}
801052af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052b2:	c9                   	leave  
801052b3:	c3                   	ret    
801052b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("%d %s: unknown sys call %d\n", curproc->pid, curproc->name,
801052b8:	50                   	push   %eax
801052b9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801052bc:	50                   	push   %eax
801052bd:	ff 73 10             	pushl  0x10(%ebx)
801052c0:	68 b1 86 10 80       	push   $0x801086b1
801052c5:	e8 96 b3 ff ff       	call   80100660 <cprintf>
        curproc->tf->eax = -1;
801052ca:	8b 43 18             	mov    0x18(%ebx),%eax
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801052d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052da:	c9                   	leave  
801052db:	c3                   	ret    
801052dc:	66 90                	xchg   %ax,%ax
801052de:	66 90                	xchg   %ax,%ax

801052e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	57                   	push   %edi
801052e4:	56                   	push   %esi
801052e5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801052e6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801052e9:	83 ec 34             	sub    $0x34,%esp
801052ec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801052ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801052f2:	56                   	push   %esi
801052f3:	50                   	push   %eax
{
801052f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801052f7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801052fa:	e8 01 cc ff ff       	call   80101f00 <nameiparent>
801052ff:	83 c4 10             	add    $0x10,%esp
80105302:	85 c0                	test   %eax,%eax
80105304:	0f 84 46 01 00 00    	je     80105450 <create+0x170>
    return 0;
  ilock(dp);
8010530a:	83 ec 0c             	sub    $0xc,%esp
8010530d:	89 c3                	mov    %eax,%ebx
8010530f:	50                   	push   %eax
80105310:	e8 6b c3 ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105315:	83 c4 0c             	add    $0xc,%esp
80105318:	6a 00                	push   $0x0
8010531a:	56                   	push   %esi
8010531b:	53                   	push   %ebx
8010531c:	e8 8f c8 ff ff       	call   80101bb0 <dirlookup>
80105321:	83 c4 10             	add    $0x10,%esp
80105324:	85 c0                	test   %eax,%eax
80105326:	89 c7                	mov    %eax,%edi
80105328:	74 36                	je     80105360 <create+0x80>
    iunlockput(dp);
8010532a:	83 ec 0c             	sub    $0xc,%esp
8010532d:	53                   	push   %ebx
8010532e:	e8 dd c5 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80105333:	89 3c 24             	mov    %edi,(%esp)
80105336:	e8 45 c3 ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010533b:	83 c4 10             	add    $0x10,%esp
8010533e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105343:	0f 85 97 00 00 00    	jne    801053e0 <create+0x100>
80105349:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010534e:	0f 85 8c 00 00 00    	jne    801053e0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105354:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105357:	89 f8                	mov    %edi,%eax
80105359:	5b                   	pop    %ebx
8010535a:	5e                   	pop    %esi
8010535b:	5f                   	pop    %edi
8010535c:	5d                   	pop    %ebp
8010535d:	c3                   	ret    
8010535e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105360:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105364:	83 ec 08             	sub    $0x8,%esp
80105367:	50                   	push   %eax
80105368:	ff 33                	pushl  (%ebx)
8010536a:	e8 a1 c1 ff ff       	call   80101510 <ialloc>
8010536f:	83 c4 10             	add    $0x10,%esp
80105372:	85 c0                	test   %eax,%eax
80105374:	89 c7                	mov    %eax,%edi
80105376:	0f 84 e8 00 00 00    	je     80105464 <create+0x184>
  ilock(ip);
8010537c:	83 ec 0c             	sub    $0xc,%esp
8010537f:	50                   	push   %eax
80105380:	e8 fb c2 ff ff       	call   80101680 <ilock>
  ip->major = major;
80105385:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105389:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010538d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105391:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105395:	b8 01 00 00 00       	mov    $0x1,%eax
8010539a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010539e:	89 3c 24             	mov    %edi,(%esp)
801053a1:	e8 2a c2 ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801053a6:	83 c4 10             	add    $0x10,%esp
801053a9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801053ae:	74 50                	je     80105400 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801053b0:	83 ec 04             	sub    $0x4,%esp
801053b3:	ff 77 04             	pushl  0x4(%edi)
801053b6:	56                   	push   %esi
801053b7:	53                   	push   %ebx
801053b8:	e8 63 ca ff ff       	call   80101e20 <dirlink>
801053bd:	83 c4 10             	add    $0x10,%esp
801053c0:	85 c0                	test   %eax,%eax
801053c2:	0f 88 8f 00 00 00    	js     80105457 <create+0x177>
  iunlockput(dp);
801053c8:	83 ec 0c             	sub    $0xc,%esp
801053cb:	53                   	push   %ebx
801053cc:	e8 3f c5 ff ff       	call   80101910 <iunlockput>
  return ip;
801053d1:	83 c4 10             	add    $0x10,%esp
}
801053d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d7:	89 f8                	mov    %edi,%eax
801053d9:	5b                   	pop    %ebx
801053da:	5e                   	pop    %esi
801053db:	5f                   	pop    %edi
801053dc:	5d                   	pop    %ebp
801053dd:	c3                   	ret    
801053de:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801053e0:	83 ec 0c             	sub    $0xc,%esp
801053e3:	57                   	push   %edi
    return 0;
801053e4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801053e6:	e8 25 c5 ff ff       	call   80101910 <iunlockput>
    return 0;
801053eb:	83 c4 10             	add    $0x10,%esp
}
801053ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053f1:	89 f8                	mov    %edi,%eax
801053f3:	5b                   	pop    %ebx
801053f4:	5e                   	pop    %esi
801053f5:	5f                   	pop    %edi
801053f6:	5d                   	pop    %ebp
801053f7:	c3                   	ret    
801053f8:	90                   	nop
801053f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105400:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105405:	83 ec 0c             	sub    $0xc,%esp
80105408:	53                   	push   %ebx
80105409:	e8 c2 c1 ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010540e:	83 c4 0c             	add    $0xc,%esp
80105411:	ff 77 04             	pushl  0x4(%edi)
80105414:	68 60 87 10 80       	push   $0x80108760
80105419:	57                   	push   %edi
8010541a:	e8 01 ca ff ff       	call   80101e20 <dirlink>
8010541f:	83 c4 10             	add    $0x10,%esp
80105422:	85 c0                	test   %eax,%eax
80105424:	78 1c                	js     80105442 <create+0x162>
80105426:	83 ec 04             	sub    $0x4,%esp
80105429:	ff 73 04             	pushl  0x4(%ebx)
8010542c:	68 5f 87 10 80       	push   $0x8010875f
80105431:	57                   	push   %edi
80105432:	e8 e9 c9 ff ff       	call   80101e20 <dirlink>
80105437:	83 c4 10             	add    $0x10,%esp
8010543a:	85 c0                	test   %eax,%eax
8010543c:	0f 89 6e ff ff ff    	jns    801053b0 <create+0xd0>
      panic("create dots");
80105442:	83 ec 0c             	sub    $0xc,%esp
80105445:	68 53 87 10 80       	push   $0x80108753
8010544a:	e8 41 af ff ff       	call   80100390 <panic>
8010544f:	90                   	nop
    return 0;
80105450:	31 ff                	xor    %edi,%edi
80105452:	e9 fd fe ff ff       	jmp    80105354 <create+0x74>
    panic("create: dirlink");
80105457:	83 ec 0c             	sub    $0xc,%esp
8010545a:	68 62 87 10 80       	push   $0x80108762
8010545f:	e8 2c af ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105464:	83 ec 0c             	sub    $0xc,%esp
80105467:	68 44 87 10 80       	push   $0x80108744
8010546c:	e8 1f af ff ff       	call   80100390 <panic>
80105471:	eb 0d                	jmp    80105480 <argfd.constprop.0>
80105473:	90                   	nop
80105474:	90                   	nop
80105475:	90                   	nop
80105476:	90                   	nop
80105477:	90                   	nop
80105478:	90                   	nop
80105479:	90                   	nop
8010547a:	90                   	nop
8010547b:	90                   	nop
8010547c:	90                   	nop
8010547d:	90                   	nop
8010547e:	90                   	nop
8010547f:	90                   	nop

80105480 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	56                   	push   %esi
80105484:	53                   	push   %ebx
80105485:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105487:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010548a:	89 d6                	mov    %edx,%esi
8010548c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010548f:	50                   	push   %eax
80105490:	6a 00                	push   $0x0
80105492:	e8 f9 fc ff ff       	call   80105190 <argint>
80105497:	83 c4 10             	add    $0x10,%esp
8010549a:	85 c0                	test   %eax,%eax
8010549c:	78 2a                	js     801054c8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010549e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054a2:	77 24                	ja     801054c8 <argfd.constprop.0+0x48>
801054a4:	e8 47 e4 ff ff       	call   801038f0 <myproc>
801054a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054ac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801054b0:	85 c0                	test   %eax,%eax
801054b2:	74 14                	je     801054c8 <argfd.constprop.0+0x48>
  if(pfd)
801054b4:	85 db                	test   %ebx,%ebx
801054b6:	74 02                	je     801054ba <argfd.constprop.0+0x3a>
    *pfd = fd;
801054b8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801054ba:	89 06                	mov    %eax,(%esi)
  return 0;
801054bc:	31 c0                	xor    %eax,%eax
}
801054be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054c1:	5b                   	pop    %ebx
801054c2:	5e                   	pop    %esi
801054c3:	5d                   	pop    %ebp
801054c4:	c3                   	ret    
801054c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054cd:	eb ef                	jmp    801054be <argfd.constprop.0+0x3e>
801054cf:	90                   	nop

801054d0 <sys_dup>:
{
801054d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801054d1:	31 c0                	xor    %eax,%eax
{
801054d3:	89 e5                	mov    %esp,%ebp
801054d5:	56                   	push   %esi
801054d6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801054d7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801054da:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801054dd:	e8 9e ff ff ff       	call   80105480 <argfd.constprop.0>
801054e2:	85 c0                	test   %eax,%eax
801054e4:	78 42                	js     80105528 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801054e6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801054e9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054eb:	e8 00 e4 ff ff       	call   801038f0 <myproc>
801054f0:	eb 0e                	jmp    80105500 <sys_dup+0x30>
801054f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801054f8:	83 c3 01             	add    $0x1,%ebx
801054fb:	83 fb 10             	cmp    $0x10,%ebx
801054fe:	74 28                	je     80105528 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105500:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105504:	85 d2                	test   %edx,%edx
80105506:	75 f0                	jne    801054f8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105508:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010550c:	83 ec 0c             	sub    $0xc,%esp
8010550f:	ff 75 f4             	pushl  -0xc(%ebp)
80105512:	e8 d9 b8 ff ff       	call   80100df0 <filedup>
  return fd;
80105517:	83 c4 10             	add    $0x10,%esp
}
8010551a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010551d:	89 d8                	mov    %ebx,%eax
8010551f:	5b                   	pop    %ebx
80105520:	5e                   	pop    %esi
80105521:	5d                   	pop    %ebp
80105522:	c3                   	ret    
80105523:	90                   	nop
80105524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105528:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010552b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105530:	89 d8                	mov    %ebx,%eax
80105532:	5b                   	pop    %ebx
80105533:	5e                   	pop    %esi
80105534:	5d                   	pop    %ebp
80105535:	c3                   	ret    
80105536:	8d 76 00             	lea    0x0(%esi),%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105540 <sys_read>:
{
80105540:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105541:	31 c0                	xor    %eax,%eax
{
80105543:	89 e5                	mov    %esp,%ebp
80105545:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105548:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010554b:	e8 30 ff ff ff       	call   80105480 <argfd.constprop.0>
80105550:	85 c0                	test   %eax,%eax
80105552:	78 4c                	js     801055a0 <sys_read+0x60>
80105554:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105557:	83 ec 08             	sub    $0x8,%esp
8010555a:	50                   	push   %eax
8010555b:	6a 02                	push   $0x2
8010555d:	e8 2e fc ff ff       	call   80105190 <argint>
80105562:	83 c4 10             	add    $0x10,%esp
80105565:	85 c0                	test   %eax,%eax
80105567:	78 37                	js     801055a0 <sys_read+0x60>
80105569:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010556c:	83 ec 04             	sub    $0x4,%esp
8010556f:	ff 75 f0             	pushl  -0x10(%ebp)
80105572:	50                   	push   %eax
80105573:	6a 01                	push   $0x1
80105575:	e8 66 fc ff ff       	call   801051e0 <argptr>
8010557a:	83 c4 10             	add    $0x10,%esp
8010557d:	85 c0                	test   %eax,%eax
8010557f:	78 1f                	js     801055a0 <sys_read+0x60>
  return fileread(f, p, n);
80105581:	83 ec 04             	sub    $0x4,%esp
80105584:	ff 75 f0             	pushl  -0x10(%ebp)
80105587:	ff 75 f4             	pushl  -0xc(%ebp)
8010558a:	ff 75 ec             	pushl  -0x14(%ebp)
8010558d:	e8 ce b9 ff ff       	call   80100f60 <fileread>
80105592:	83 c4 10             	add    $0x10,%esp
}
80105595:	c9                   	leave  
80105596:	c3                   	ret    
80105597:	89 f6                	mov    %esi,%esi
80105599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801055a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055a5:	c9                   	leave  
801055a6:	c3                   	ret    
801055a7:	89 f6                	mov    %esi,%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055b0 <sys_write>:
{
801055b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055b1:	31 c0                	xor    %eax,%eax
{
801055b3:	89 e5                	mov    %esp,%ebp
801055b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801055bb:	e8 c0 fe ff ff       	call   80105480 <argfd.constprop.0>
801055c0:	85 c0                	test   %eax,%eax
801055c2:	78 4c                	js     80105610 <sys_write+0x60>
801055c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055c7:	83 ec 08             	sub    $0x8,%esp
801055ca:	50                   	push   %eax
801055cb:	6a 02                	push   $0x2
801055cd:	e8 be fb ff ff       	call   80105190 <argint>
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	85 c0                	test   %eax,%eax
801055d7:	78 37                	js     80105610 <sys_write+0x60>
801055d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055dc:	83 ec 04             	sub    $0x4,%esp
801055df:	ff 75 f0             	pushl  -0x10(%ebp)
801055e2:	50                   	push   %eax
801055e3:	6a 01                	push   $0x1
801055e5:	e8 f6 fb ff ff       	call   801051e0 <argptr>
801055ea:	83 c4 10             	add    $0x10,%esp
801055ed:	85 c0                	test   %eax,%eax
801055ef:	78 1f                	js     80105610 <sys_write+0x60>
  return filewrite(f, p, n);
801055f1:	83 ec 04             	sub    $0x4,%esp
801055f4:	ff 75 f0             	pushl  -0x10(%ebp)
801055f7:	ff 75 f4             	pushl  -0xc(%ebp)
801055fa:	ff 75 ec             	pushl  -0x14(%ebp)
801055fd:	e8 ee b9 ff ff       	call   80100ff0 <filewrite>
80105602:	83 c4 10             	add    $0x10,%esp
}
80105605:	c9                   	leave  
80105606:	c3                   	ret    
80105607:	89 f6                	mov    %esi,%esi
80105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105615:	c9                   	leave  
80105616:	c3                   	ret    
80105617:	89 f6                	mov    %esi,%esi
80105619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105620 <sys_close>:
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105626:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105629:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010562c:	e8 4f fe ff ff       	call   80105480 <argfd.constprop.0>
80105631:	85 c0                	test   %eax,%eax
80105633:	78 2b                	js     80105660 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105635:	e8 b6 e2 ff ff       	call   801038f0 <myproc>
8010563a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010563d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105640:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105647:	00 
  fileclose(f);
80105648:	ff 75 f4             	pushl  -0xc(%ebp)
8010564b:	e8 f0 b7 ff ff       	call   80100e40 <fileclose>
  return 0;
80105650:	83 c4 10             	add    $0x10,%esp
80105653:	31 c0                	xor    %eax,%eax
}
80105655:	c9                   	leave  
80105656:	c3                   	ret    
80105657:	89 f6                	mov    %esi,%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105665:	c9                   	leave  
80105666:	c3                   	ret    
80105667:	89 f6                	mov    %esi,%esi
80105669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105670 <sys_fstat>:
{
80105670:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105671:	31 c0                	xor    %eax,%eax
{
80105673:	89 e5                	mov    %esp,%ebp
80105675:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105678:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010567b:	e8 00 fe ff ff       	call   80105480 <argfd.constprop.0>
80105680:	85 c0                	test   %eax,%eax
80105682:	78 2c                	js     801056b0 <sys_fstat+0x40>
80105684:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105687:	83 ec 04             	sub    $0x4,%esp
8010568a:	6a 14                	push   $0x14
8010568c:	50                   	push   %eax
8010568d:	6a 01                	push   $0x1
8010568f:	e8 4c fb ff ff       	call   801051e0 <argptr>
80105694:	83 c4 10             	add    $0x10,%esp
80105697:	85 c0                	test   %eax,%eax
80105699:	78 15                	js     801056b0 <sys_fstat+0x40>
  return filestat(f, st);
8010569b:	83 ec 08             	sub    $0x8,%esp
8010569e:	ff 75 f4             	pushl  -0xc(%ebp)
801056a1:	ff 75 f0             	pushl  -0x10(%ebp)
801056a4:	e8 67 b8 ff ff       	call   80100f10 <filestat>
801056a9:	83 c4 10             	add    $0x10,%esp
}
801056ac:	c9                   	leave  
801056ad:	c3                   	ret    
801056ae:	66 90                	xchg   %ax,%ax
    return -1;
801056b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056b5:	c9                   	leave  
801056b6:	c3                   	ret    
801056b7:	89 f6                	mov    %esi,%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056c0 <sys_link>:
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	57                   	push   %edi
801056c4:	56                   	push   %esi
801056c5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056c6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801056c9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056cc:	50                   	push   %eax
801056cd:	6a 00                	push   $0x0
801056cf:	e8 6c fb ff ff       	call   80105240 <argstr>
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	85 c0                	test   %eax,%eax
801056d9:	0f 88 fb 00 00 00    	js     801057da <sys_link+0x11a>
801056df:	8d 45 d0             	lea    -0x30(%ebp),%eax
801056e2:	83 ec 08             	sub    $0x8,%esp
801056e5:	50                   	push   %eax
801056e6:	6a 01                	push   $0x1
801056e8:	e8 53 fb ff ff       	call   80105240 <argstr>
801056ed:	83 c4 10             	add    $0x10,%esp
801056f0:	85 c0                	test   %eax,%eax
801056f2:	0f 88 e2 00 00 00    	js     801057da <sys_link+0x11a>
  begin_op();
801056f8:	e8 a3 d4 ff ff       	call   80102ba0 <begin_op>
  if((ip = namei(old)) == 0){
801056fd:	83 ec 0c             	sub    $0xc,%esp
80105700:	ff 75 d4             	pushl  -0x2c(%ebp)
80105703:	e8 d8 c7 ff ff       	call   80101ee0 <namei>
80105708:	83 c4 10             	add    $0x10,%esp
8010570b:	85 c0                	test   %eax,%eax
8010570d:	89 c3                	mov    %eax,%ebx
8010570f:	0f 84 ea 00 00 00    	je     801057ff <sys_link+0x13f>
  ilock(ip);
80105715:	83 ec 0c             	sub    $0xc,%esp
80105718:	50                   	push   %eax
80105719:	e8 62 bf ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
8010571e:	83 c4 10             	add    $0x10,%esp
80105721:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105726:	0f 84 bb 00 00 00    	je     801057e7 <sys_link+0x127>
  ip->nlink++;
8010572c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105731:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105734:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105737:	53                   	push   %ebx
80105738:	e8 93 be ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
8010573d:	89 1c 24             	mov    %ebx,(%esp)
80105740:	e8 1b c0 ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105745:	58                   	pop    %eax
80105746:	5a                   	pop    %edx
80105747:	57                   	push   %edi
80105748:	ff 75 d0             	pushl  -0x30(%ebp)
8010574b:	e8 b0 c7 ff ff       	call   80101f00 <nameiparent>
80105750:	83 c4 10             	add    $0x10,%esp
80105753:	85 c0                	test   %eax,%eax
80105755:	89 c6                	mov    %eax,%esi
80105757:	74 5b                	je     801057b4 <sys_link+0xf4>
  ilock(dp);
80105759:	83 ec 0c             	sub    $0xc,%esp
8010575c:	50                   	push   %eax
8010575d:	e8 1e bf ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105762:	83 c4 10             	add    $0x10,%esp
80105765:	8b 03                	mov    (%ebx),%eax
80105767:	39 06                	cmp    %eax,(%esi)
80105769:	75 3d                	jne    801057a8 <sys_link+0xe8>
8010576b:	83 ec 04             	sub    $0x4,%esp
8010576e:	ff 73 04             	pushl  0x4(%ebx)
80105771:	57                   	push   %edi
80105772:	56                   	push   %esi
80105773:	e8 a8 c6 ff ff       	call   80101e20 <dirlink>
80105778:	83 c4 10             	add    $0x10,%esp
8010577b:	85 c0                	test   %eax,%eax
8010577d:	78 29                	js     801057a8 <sys_link+0xe8>
  iunlockput(dp);
8010577f:	83 ec 0c             	sub    $0xc,%esp
80105782:	56                   	push   %esi
80105783:	e8 88 c1 ff ff       	call   80101910 <iunlockput>
  iput(ip);
80105788:	89 1c 24             	mov    %ebx,(%esp)
8010578b:	e8 20 c0 ff ff       	call   801017b0 <iput>
  end_op();
80105790:	e8 7b d4 ff ff       	call   80102c10 <end_op>
  return 0;
80105795:	83 c4 10             	add    $0x10,%esp
80105798:	31 c0                	xor    %eax,%eax
}
8010579a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010579d:	5b                   	pop    %ebx
8010579e:	5e                   	pop    %esi
8010579f:	5f                   	pop    %edi
801057a0:	5d                   	pop    %ebp
801057a1:	c3                   	ret    
801057a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801057a8:	83 ec 0c             	sub    $0xc,%esp
801057ab:	56                   	push   %esi
801057ac:	e8 5f c1 ff ff       	call   80101910 <iunlockput>
    goto bad;
801057b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801057b4:	83 ec 0c             	sub    $0xc,%esp
801057b7:	53                   	push   %ebx
801057b8:	e8 c3 be ff ff       	call   80101680 <ilock>
  ip->nlink--;
801057bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057c2:	89 1c 24             	mov    %ebx,(%esp)
801057c5:	e8 06 be ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
801057ca:	89 1c 24             	mov    %ebx,(%esp)
801057cd:	e8 3e c1 ff ff       	call   80101910 <iunlockput>
  end_op();
801057d2:	e8 39 d4 ff ff       	call   80102c10 <end_op>
  return -1;
801057d7:	83 c4 10             	add    $0x10,%esp
}
801057da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801057dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057e2:	5b                   	pop    %ebx
801057e3:	5e                   	pop    %esi
801057e4:	5f                   	pop    %edi
801057e5:	5d                   	pop    %ebp
801057e6:	c3                   	ret    
    iunlockput(ip);
801057e7:	83 ec 0c             	sub    $0xc,%esp
801057ea:	53                   	push   %ebx
801057eb:	e8 20 c1 ff ff       	call   80101910 <iunlockput>
    end_op();
801057f0:	e8 1b d4 ff ff       	call   80102c10 <end_op>
    return -1;
801057f5:	83 c4 10             	add    $0x10,%esp
801057f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057fd:	eb 9b                	jmp    8010579a <sys_link+0xda>
    end_op();
801057ff:	e8 0c d4 ff ff       	call   80102c10 <end_op>
    return -1;
80105804:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105809:	eb 8f                	jmp    8010579a <sys_link+0xda>
8010580b:	90                   	nop
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_unlink>:
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	57                   	push   %edi
80105814:	56                   	push   %esi
80105815:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105816:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105819:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010581c:	50                   	push   %eax
8010581d:	6a 00                	push   $0x0
8010581f:	e8 1c fa ff ff       	call   80105240 <argstr>
80105824:	83 c4 10             	add    $0x10,%esp
80105827:	85 c0                	test   %eax,%eax
80105829:	0f 88 77 01 00 00    	js     801059a6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010582f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105832:	e8 69 d3 ff ff       	call   80102ba0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105837:	83 ec 08             	sub    $0x8,%esp
8010583a:	53                   	push   %ebx
8010583b:	ff 75 c0             	pushl  -0x40(%ebp)
8010583e:	e8 bd c6 ff ff       	call   80101f00 <nameiparent>
80105843:	83 c4 10             	add    $0x10,%esp
80105846:	85 c0                	test   %eax,%eax
80105848:	89 c6                	mov    %eax,%esi
8010584a:	0f 84 60 01 00 00    	je     801059b0 <sys_unlink+0x1a0>
  ilock(dp);
80105850:	83 ec 0c             	sub    $0xc,%esp
80105853:	50                   	push   %eax
80105854:	e8 27 be ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105859:	58                   	pop    %eax
8010585a:	5a                   	pop    %edx
8010585b:	68 60 87 10 80       	push   $0x80108760
80105860:	53                   	push   %ebx
80105861:	e8 2a c3 ff ff       	call   80101b90 <namecmp>
80105866:	83 c4 10             	add    $0x10,%esp
80105869:	85 c0                	test   %eax,%eax
8010586b:	0f 84 03 01 00 00    	je     80105974 <sys_unlink+0x164>
80105871:	83 ec 08             	sub    $0x8,%esp
80105874:	68 5f 87 10 80       	push   $0x8010875f
80105879:	53                   	push   %ebx
8010587a:	e8 11 c3 ff ff       	call   80101b90 <namecmp>
8010587f:	83 c4 10             	add    $0x10,%esp
80105882:	85 c0                	test   %eax,%eax
80105884:	0f 84 ea 00 00 00    	je     80105974 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010588a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010588d:	83 ec 04             	sub    $0x4,%esp
80105890:	50                   	push   %eax
80105891:	53                   	push   %ebx
80105892:	56                   	push   %esi
80105893:	e8 18 c3 ff ff       	call   80101bb0 <dirlookup>
80105898:	83 c4 10             	add    $0x10,%esp
8010589b:	85 c0                	test   %eax,%eax
8010589d:	89 c3                	mov    %eax,%ebx
8010589f:	0f 84 cf 00 00 00    	je     80105974 <sys_unlink+0x164>
  ilock(ip);
801058a5:	83 ec 0c             	sub    $0xc,%esp
801058a8:	50                   	push   %eax
801058a9:	e8 d2 bd ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
801058ae:	83 c4 10             	add    $0x10,%esp
801058b1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801058b6:	0f 8e 10 01 00 00    	jle    801059cc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801058bc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058c1:	74 6d                	je     80105930 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801058c3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801058c6:	83 ec 04             	sub    $0x4,%esp
801058c9:	6a 10                	push   $0x10
801058cb:	6a 00                	push   $0x0
801058cd:	50                   	push   %eax
801058ce:	e8 bd f5 ff ff       	call   80104e90 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058d3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801058d6:	6a 10                	push   $0x10
801058d8:	ff 75 c4             	pushl  -0x3c(%ebp)
801058db:	50                   	push   %eax
801058dc:	56                   	push   %esi
801058dd:	e8 7e c1 ff ff       	call   80101a60 <writei>
801058e2:	83 c4 20             	add    $0x20,%esp
801058e5:	83 f8 10             	cmp    $0x10,%eax
801058e8:	0f 85 eb 00 00 00    	jne    801059d9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801058ee:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058f3:	0f 84 97 00 00 00    	je     80105990 <sys_unlink+0x180>
  iunlockput(dp);
801058f9:	83 ec 0c             	sub    $0xc,%esp
801058fc:	56                   	push   %esi
801058fd:	e8 0e c0 ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80105902:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105907:	89 1c 24             	mov    %ebx,(%esp)
8010590a:	e8 c1 bc ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
8010590f:	89 1c 24             	mov    %ebx,(%esp)
80105912:	e8 f9 bf ff ff       	call   80101910 <iunlockput>
  end_op();
80105917:	e8 f4 d2 ff ff       	call   80102c10 <end_op>
  return 0;
8010591c:	83 c4 10             	add    $0x10,%esp
8010591f:	31 c0                	xor    %eax,%eax
}
80105921:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105924:	5b                   	pop    %ebx
80105925:	5e                   	pop    %esi
80105926:	5f                   	pop    %edi
80105927:	5d                   	pop    %ebp
80105928:	c3                   	ret    
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105930:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105934:	76 8d                	jbe    801058c3 <sys_unlink+0xb3>
80105936:	bf 20 00 00 00       	mov    $0x20,%edi
8010593b:	eb 0f                	jmp    8010594c <sys_unlink+0x13c>
8010593d:	8d 76 00             	lea    0x0(%esi),%esi
80105940:	83 c7 10             	add    $0x10,%edi
80105943:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105946:	0f 83 77 ff ff ff    	jae    801058c3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010594c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010594f:	6a 10                	push   $0x10
80105951:	57                   	push   %edi
80105952:	50                   	push   %eax
80105953:	53                   	push   %ebx
80105954:	e8 07 c0 ff ff       	call   80101960 <readi>
80105959:	83 c4 10             	add    $0x10,%esp
8010595c:	83 f8 10             	cmp    $0x10,%eax
8010595f:	75 5e                	jne    801059bf <sys_unlink+0x1af>
    if(de.inum != 0)
80105961:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105966:	74 d8                	je     80105940 <sys_unlink+0x130>
    iunlockput(ip);
80105968:	83 ec 0c             	sub    $0xc,%esp
8010596b:	53                   	push   %ebx
8010596c:	e8 9f bf ff ff       	call   80101910 <iunlockput>
    goto bad;
80105971:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105974:	83 ec 0c             	sub    $0xc,%esp
80105977:	56                   	push   %esi
80105978:	e8 93 bf ff ff       	call   80101910 <iunlockput>
  end_op();
8010597d:	e8 8e d2 ff ff       	call   80102c10 <end_op>
  return -1;
80105982:	83 c4 10             	add    $0x10,%esp
80105985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010598a:	eb 95                	jmp    80105921 <sys_unlink+0x111>
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105990:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105995:	83 ec 0c             	sub    $0xc,%esp
80105998:	56                   	push   %esi
80105999:	e8 32 bc ff ff       	call   801015d0 <iupdate>
8010599e:	83 c4 10             	add    $0x10,%esp
801059a1:	e9 53 ff ff ff       	jmp    801058f9 <sys_unlink+0xe9>
    return -1;
801059a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ab:	e9 71 ff ff ff       	jmp    80105921 <sys_unlink+0x111>
    end_op();
801059b0:	e8 5b d2 ff ff       	call   80102c10 <end_op>
    return -1;
801059b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ba:	e9 62 ff ff ff       	jmp    80105921 <sys_unlink+0x111>
      panic("isdirempty: readi");
801059bf:	83 ec 0c             	sub    $0xc,%esp
801059c2:	68 84 87 10 80       	push   $0x80108784
801059c7:	e8 c4 a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801059cc:	83 ec 0c             	sub    $0xc,%esp
801059cf:	68 72 87 10 80       	push   $0x80108772
801059d4:	e8 b7 a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801059d9:	83 ec 0c             	sub    $0xc,%esp
801059dc:	68 96 87 10 80       	push   $0x80108796
801059e1:	e8 aa a9 ff ff       	call   80100390 <panic>
801059e6:	8d 76 00             	lea    0x0(%esi),%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059f0 <sys_open>:

int
sys_open(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
801059f5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801059f9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059fc:	50                   	push   %eax
801059fd:	6a 00                	push   $0x0
801059ff:	e8 3c f8 ff ff       	call   80105240 <argstr>
80105a04:	83 c4 10             	add    $0x10,%esp
80105a07:	85 c0                	test   %eax,%eax
80105a09:	0f 88 1d 01 00 00    	js     80105b2c <sys_open+0x13c>
80105a0f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a12:	83 ec 08             	sub    $0x8,%esp
80105a15:	50                   	push   %eax
80105a16:	6a 01                	push   $0x1
80105a18:	e8 73 f7 ff ff       	call   80105190 <argint>
80105a1d:	83 c4 10             	add    $0x10,%esp
80105a20:	85 c0                	test   %eax,%eax
80105a22:	0f 88 04 01 00 00    	js     80105b2c <sys_open+0x13c>
    return -1;

  begin_op();
80105a28:	e8 73 d1 ff ff       	call   80102ba0 <begin_op>

  if(omode & O_CREATE){
80105a2d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a31:	0f 85 a9 00 00 00    	jne    80105ae0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a37:	83 ec 0c             	sub    $0xc,%esp
80105a3a:	ff 75 e0             	pushl  -0x20(%ebp)
80105a3d:	e8 9e c4 ff ff       	call   80101ee0 <namei>
80105a42:	83 c4 10             	add    $0x10,%esp
80105a45:	85 c0                	test   %eax,%eax
80105a47:	89 c6                	mov    %eax,%esi
80105a49:	0f 84 b2 00 00 00    	je     80105b01 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105a4f:	83 ec 0c             	sub    $0xc,%esp
80105a52:	50                   	push   %eax
80105a53:	e8 28 bc ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a58:	83 c4 10             	add    $0x10,%esp
80105a5b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105a60:	0f 84 aa 00 00 00    	je     80105b10 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105a66:	e8 15 b3 ff ff       	call   80100d80 <filealloc>
80105a6b:	85 c0                	test   %eax,%eax
80105a6d:	89 c7                	mov    %eax,%edi
80105a6f:	0f 84 a6 00 00 00    	je     80105b1b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105a75:	e8 76 de ff ff       	call   801038f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a7a:	31 db                	xor    %ebx,%ebx
80105a7c:	eb 0e                	jmp    80105a8c <sys_open+0x9c>
80105a7e:	66 90                	xchg   %ax,%ax
80105a80:	83 c3 01             	add    $0x1,%ebx
80105a83:	83 fb 10             	cmp    $0x10,%ebx
80105a86:	0f 84 ac 00 00 00    	je     80105b38 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105a8c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105a90:	85 d2                	test   %edx,%edx
80105a92:	75 ec                	jne    80105a80 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a94:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105a97:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105a9b:	56                   	push   %esi
80105a9c:	e8 bf bc ff ff       	call   80101760 <iunlock>
  end_op();
80105aa1:	e8 6a d1 ff ff       	call   80102c10 <end_op>

  f->type = FD_INODE;
80105aa6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105aac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105aaf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105ab2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105ab5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105abc:	89 d0                	mov    %edx,%eax
80105abe:	f7 d0                	not    %eax
80105ac0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ac3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105ac6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ac9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105acd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ad0:	89 d8                	mov    %ebx,%eax
80105ad2:	5b                   	pop    %ebx
80105ad3:	5e                   	pop    %esi
80105ad4:	5f                   	pop    %edi
80105ad5:	5d                   	pop    %ebp
80105ad6:	c3                   	ret    
80105ad7:	89 f6                	mov    %esi,%esi
80105ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105ae0:	83 ec 0c             	sub    $0xc,%esp
80105ae3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105ae6:	31 c9                	xor    %ecx,%ecx
80105ae8:	6a 00                	push   $0x0
80105aea:	ba 02 00 00 00       	mov    $0x2,%edx
80105aef:	e8 ec f7 ff ff       	call   801052e0 <create>
    if(ip == 0){
80105af4:	83 c4 10             	add    $0x10,%esp
80105af7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105af9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105afb:	0f 85 65 ff ff ff    	jne    80105a66 <sys_open+0x76>
      end_op();
80105b01:	e8 0a d1 ff ff       	call   80102c10 <end_op>
      return -1;
80105b06:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b0b:	eb c0                	jmp    80105acd <sys_open+0xdd>
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b10:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b13:	85 c9                	test   %ecx,%ecx
80105b15:	0f 84 4b ff ff ff    	je     80105a66 <sys_open+0x76>
    iunlockput(ip);
80105b1b:	83 ec 0c             	sub    $0xc,%esp
80105b1e:	56                   	push   %esi
80105b1f:	e8 ec bd ff ff       	call   80101910 <iunlockput>
    end_op();
80105b24:	e8 e7 d0 ff ff       	call   80102c10 <end_op>
    return -1;
80105b29:	83 c4 10             	add    $0x10,%esp
80105b2c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b31:	eb 9a                	jmp    80105acd <sys_open+0xdd>
80105b33:	90                   	nop
80105b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105b38:	83 ec 0c             	sub    $0xc,%esp
80105b3b:	57                   	push   %edi
80105b3c:	e8 ff b2 ff ff       	call   80100e40 <fileclose>
80105b41:	83 c4 10             	add    $0x10,%esp
80105b44:	eb d5                	jmp    80105b1b <sys_open+0x12b>
80105b46:	8d 76 00             	lea    0x0(%esi),%esi
80105b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b50 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b56:	e8 45 d0 ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b5e:	83 ec 08             	sub    $0x8,%esp
80105b61:	50                   	push   %eax
80105b62:	6a 00                	push   $0x0
80105b64:	e8 d7 f6 ff ff       	call   80105240 <argstr>
80105b69:	83 c4 10             	add    $0x10,%esp
80105b6c:	85 c0                	test   %eax,%eax
80105b6e:	78 30                	js     80105ba0 <sys_mkdir+0x50>
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b76:	31 c9                	xor    %ecx,%ecx
80105b78:	6a 00                	push   $0x0
80105b7a:	ba 01 00 00 00       	mov    $0x1,%edx
80105b7f:	e8 5c f7 ff ff       	call   801052e0 <create>
80105b84:	83 c4 10             	add    $0x10,%esp
80105b87:	85 c0                	test   %eax,%eax
80105b89:	74 15                	je     80105ba0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b8b:	83 ec 0c             	sub    $0xc,%esp
80105b8e:	50                   	push   %eax
80105b8f:	e8 7c bd ff ff       	call   80101910 <iunlockput>
  end_op();
80105b94:	e8 77 d0 ff ff       	call   80102c10 <end_op>
  return 0;
80105b99:	83 c4 10             	add    $0x10,%esp
80105b9c:	31 c0                	xor    %eax,%eax
}
80105b9e:	c9                   	leave  
80105b9f:	c3                   	ret    
    end_op();
80105ba0:	e8 6b d0 ff ff       	call   80102c10 <end_op>
    return -1;
80105ba5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105baa:	c9                   	leave  
80105bab:	c3                   	ret    
80105bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bb0 <sys_mknod>:

int
sys_mknod(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105bb6:	e8 e5 cf ff ff       	call   80102ba0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105bbb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bbe:	83 ec 08             	sub    $0x8,%esp
80105bc1:	50                   	push   %eax
80105bc2:	6a 00                	push   $0x0
80105bc4:	e8 77 f6 ff ff       	call   80105240 <argstr>
80105bc9:	83 c4 10             	add    $0x10,%esp
80105bcc:	85 c0                	test   %eax,%eax
80105bce:	78 60                	js     80105c30 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105bd0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bd3:	83 ec 08             	sub    $0x8,%esp
80105bd6:	50                   	push   %eax
80105bd7:	6a 01                	push   $0x1
80105bd9:	e8 b2 f5 ff ff       	call   80105190 <argint>
  if((argstr(0, &path)) < 0 ||
80105bde:	83 c4 10             	add    $0x10,%esp
80105be1:	85 c0                	test   %eax,%eax
80105be3:	78 4b                	js     80105c30 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105be5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105be8:	83 ec 08             	sub    $0x8,%esp
80105beb:	50                   	push   %eax
80105bec:	6a 02                	push   $0x2
80105bee:	e8 9d f5 ff ff       	call   80105190 <argint>
     argint(1, &major) < 0 ||
80105bf3:	83 c4 10             	add    $0x10,%esp
80105bf6:	85 c0                	test   %eax,%eax
80105bf8:	78 36                	js     80105c30 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105bfa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105bfe:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c01:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105c05:	ba 03 00 00 00       	mov    $0x3,%edx
80105c0a:	50                   	push   %eax
80105c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c0e:	e8 cd f6 ff ff       	call   801052e0 <create>
80105c13:	83 c4 10             	add    $0x10,%esp
80105c16:	85 c0                	test   %eax,%eax
80105c18:	74 16                	je     80105c30 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c1a:	83 ec 0c             	sub    $0xc,%esp
80105c1d:	50                   	push   %eax
80105c1e:	e8 ed bc ff ff       	call   80101910 <iunlockput>
  end_op();
80105c23:	e8 e8 cf ff ff       	call   80102c10 <end_op>
  return 0;
80105c28:	83 c4 10             	add    $0x10,%esp
80105c2b:	31 c0                	xor    %eax,%eax
}
80105c2d:	c9                   	leave  
80105c2e:	c3                   	ret    
80105c2f:	90                   	nop
    end_op();
80105c30:	e8 db cf ff ff       	call   80102c10 <end_op>
    return -1;
80105c35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c3a:	c9                   	leave  
80105c3b:	c3                   	ret    
80105c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c40 <sys_chdir>:

int
sys_chdir(void)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	56                   	push   %esi
80105c44:	53                   	push   %ebx
80105c45:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c48:	e8 a3 dc ff ff       	call   801038f0 <myproc>
80105c4d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c4f:	e8 4c cf ff ff       	call   80102ba0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105c54:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c57:	83 ec 08             	sub    $0x8,%esp
80105c5a:	50                   	push   %eax
80105c5b:	6a 00                	push   $0x0
80105c5d:	e8 de f5 ff ff       	call   80105240 <argstr>
80105c62:	83 c4 10             	add    $0x10,%esp
80105c65:	85 c0                	test   %eax,%eax
80105c67:	78 77                	js     80105ce0 <sys_chdir+0xa0>
80105c69:	83 ec 0c             	sub    $0xc,%esp
80105c6c:	ff 75 f4             	pushl  -0xc(%ebp)
80105c6f:	e8 6c c2 ff ff       	call   80101ee0 <namei>
80105c74:	83 c4 10             	add    $0x10,%esp
80105c77:	85 c0                	test   %eax,%eax
80105c79:	89 c3                	mov    %eax,%ebx
80105c7b:	74 63                	je     80105ce0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105c7d:	83 ec 0c             	sub    $0xc,%esp
80105c80:	50                   	push   %eax
80105c81:	e8 fa b9 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
80105c86:	83 c4 10             	add    $0x10,%esp
80105c89:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c8e:	75 30                	jne    80105cc0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c90:	83 ec 0c             	sub    $0xc,%esp
80105c93:	53                   	push   %ebx
80105c94:	e8 c7 ba ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105c99:	58                   	pop    %eax
80105c9a:	ff 76 68             	pushl  0x68(%esi)
80105c9d:	e8 0e bb ff ff       	call   801017b0 <iput>
  end_op();
80105ca2:	e8 69 cf ff ff       	call   80102c10 <end_op>
  curproc->cwd = ip;
80105ca7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105caa:	83 c4 10             	add    $0x10,%esp
80105cad:	31 c0                	xor    %eax,%eax
}
80105caf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cb2:	5b                   	pop    %ebx
80105cb3:	5e                   	pop    %esi
80105cb4:	5d                   	pop    %ebp
80105cb5:	c3                   	ret    
80105cb6:	8d 76 00             	lea    0x0(%esi),%esi
80105cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105cc0:	83 ec 0c             	sub    $0xc,%esp
80105cc3:	53                   	push   %ebx
80105cc4:	e8 47 bc ff ff       	call   80101910 <iunlockput>
    end_op();
80105cc9:	e8 42 cf ff ff       	call   80102c10 <end_op>
    return -1;
80105cce:	83 c4 10             	add    $0x10,%esp
80105cd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cd6:	eb d7                	jmp    80105caf <sys_chdir+0x6f>
80105cd8:	90                   	nop
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105ce0:	e8 2b cf ff ff       	call   80102c10 <end_op>
    return -1;
80105ce5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cea:	eb c3                	jmp    80105caf <sys_chdir+0x6f>
80105cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cf0 <sys_exec>:

int
sys_exec(void)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	57                   	push   %edi
80105cf4:	56                   	push   %esi
80105cf5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cf6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105cfc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d02:	50                   	push   %eax
80105d03:	6a 00                	push   $0x0
80105d05:	e8 36 f5 ff ff       	call   80105240 <argstr>
80105d0a:	83 c4 10             	add    $0x10,%esp
80105d0d:	85 c0                	test   %eax,%eax
80105d0f:	0f 88 87 00 00 00    	js     80105d9c <sys_exec+0xac>
80105d15:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d1b:	83 ec 08             	sub    $0x8,%esp
80105d1e:	50                   	push   %eax
80105d1f:	6a 01                	push   $0x1
80105d21:	e8 6a f4 ff ff       	call   80105190 <argint>
80105d26:	83 c4 10             	add    $0x10,%esp
80105d29:	85 c0                	test   %eax,%eax
80105d2b:	78 6f                	js     80105d9c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d2d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105d33:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105d36:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d38:	68 80 00 00 00       	push   $0x80
80105d3d:	6a 00                	push   $0x0
80105d3f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105d45:	50                   	push   %eax
80105d46:	e8 45 f1 ff ff       	call   80104e90 <memset>
80105d4b:	83 c4 10             	add    $0x10,%esp
80105d4e:	eb 2c                	jmp    80105d7c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105d50:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105d56:	85 c0                	test   %eax,%eax
80105d58:	74 56                	je     80105db0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105d5a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105d60:	83 ec 08             	sub    $0x8,%esp
80105d63:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105d66:	52                   	push   %edx
80105d67:	50                   	push   %eax
80105d68:	e8 b3 f3 ff ff       	call   80105120 <fetchstr>
80105d6d:	83 c4 10             	add    $0x10,%esp
80105d70:	85 c0                	test   %eax,%eax
80105d72:	78 28                	js     80105d9c <sys_exec+0xac>
  for(i=0;; i++){
80105d74:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105d77:	83 fb 20             	cmp    $0x20,%ebx
80105d7a:	74 20                	je     80105d9c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d7c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d82:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105d89:	83 ec 08             	sub    $0x8,%esp
80105d8c:	57                   	push   %edi
80105d8d:	01 f0                	add    %esi,%eax
80105d8f:	50                   	push   %eax
80105d90:	e8 4b f3 ff ff       	call   801050e0 <fetchint>
80105d95:	83 c4 10             	add    $0x10,%esp
80105d98:	85 c0                	test   %eax,%eax
80105d9a:	79 b4                	jns    80105d50 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105d9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105da4:	5b                   	pop    %ebx
80105da5:	5e                   	pop    %esi
80105da6:	5f                   	pop    %edi
80105da7:	5d                   	pop    %ebp
80105da8:	c3                   	ret    
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105db0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105db6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105db9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105dc0:	00 00 00 00 
  return exec(path, argv);
80105dc4:	50                   	push   %eax
80105dc5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105dcb:	e8 40 ac ff ff       	call   80100a10 <exec>
80105dd0:	83 c4 10             	add    $0x10,%esp
}
80105dd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dd6:	5b                   	pop    %ebx
80105dd7:	5e                   	pop    %esi
80105dd8:	5f                   	pop    %edi
80105dd9:	5d                   	pop    %ebp
80105dda:	c3                   	ret    
80105ddb:	90                   	nop
80105ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105de0 <sys_pipe>:

int
sys_pipe(void)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	57                   	push   %edi
80105de4:	56                   	push   %esi
80105de5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105de6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105de9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105dec:	6a 08                	push   $0x8
80105dee:	50                   	push   %eax
80105def:	6a 00                	push   $0x0
80105df1:	e8 ea f3 ff ff       	call   801051e0 <argptr>
80105df6:	83 c4 10             	add    $0x10,%esp
80105df9:	85 c0                	test   %eax,%eax
80105dfb:	0f 88 ae 00 00 00    	js     80105eaf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e01:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e04:	83 ec 08             	sub    $0x8,%esp
80105e07:	50                   	push   %eax
80105e08:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e0b:	50                   	push   %eax
80105e0c:	e8 2f d4 ff ff       	call   80103240 <pipealloc>
80105e11:	83 c4 10             	add    $0x10,%esp
80105e14:	85 c0                	test   %eax,%eax
80105e16:	0f 88 93 00 00 00    	js     80105eaf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e1c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e1f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e21:	e8 ca da ff ff       	call   801038f0 <myproc>
80105e26:	eb 10                	jmp    80105e38 <sys_pipe+0x58>
80105e28:	90                   	nop
80105e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105e30:	83 c3 01             	add    $0x1,%ebx
80105e33:	83 fb 10             	cmp    $0x10,%ebx
80105e36:	74 60                	je     80105e98 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105e38:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e3c:	85 f6                	test   %esi,%esi
80105e3e:	75 f0                	jne    80105e30 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105e40:	8d 73 08             	lea    0x8(%ebx),%esi
80105e43:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e4a:	e8 a1 da ff ff       	call   801038f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e4f:	31 d2                	xor    %edx,%edx
80105e51:	eb 0d                	jmp    80105e60 <sys_pipe+0x80>
80105e53:	90                   	nop
80105e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e58:	83 c2 01             	add    $0x1,%edx
80105e5b:	83 fa 10             	cmp    $0x10,%edx
80105e5e:	74 28                	je     80105e88 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105e60:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105e64:	85 c9                	test   %ecx,%ecx
80105e66:	75 f0                	jne    80105e58 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105e68:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105e6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e6f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105e71:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e74:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105e77:	31 c0                	xor    %eax,%eax
}
80105e79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e7c:	5b                   	pop    %ebx
80105e7d:	5e                   	pop    %esi
80105e7e:	5f                   	pop    %edi
80105e7f:	5d                   	pop    %ebp
80105e80:	c3                   	ret    
80105e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105e88:	e8 63 da ff ff       	call   801038f0 <myproc>
80105e8d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105e94:	00 
80105e95:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105e98:	83 ec 0c             	sub    $0xc,%esp
80105e9b:	ff 75 e0             	pushl  -0x20(%ebp)
80105e9e:	e8 9d af ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105ea3:	58                   	pop    %eax
80105ea4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ea7:	e8 94 af ff ff       	call   80100e40 <fileclose>
    return -1;
80105eac:	83 c4 10             	add    $0x10,%esp
80105eaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eb4:	eb c3                	jmp    80105e79 <sys_pipe+0x99>
80105eb6:	66 90                	xchg   %ax,%ax
80105eb8:	66 90                	xchg   %ax,%ax
80105eba:	66 90                	xchg   %ax,%ax
80105ebc:	66 90                	xchg   %ax,%ax
80105ebe:	66 90                	xchg   %ax,%ax

80105ec0 <sys_fork>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void) {
80105ec0:	55                   	push   %ebp
80105ec1:	89 e5                	mov    %esp,%ebp
    return fork();
}
80105ec3:	5d                   	pop    %ebp
    return fork();
80105ec4:	e9 e7 df ff ff       	jmp    80103eb0 <fork>
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ed0 <sys_exit>:

int sys_exit(void) {
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	83 ec 08             	sub    $0x8,%esp
    cprintf("Exiting pid %d\n", myproc()->pid);
80105ed6:	e8 15 da ff ff       	call   801038f0 <myproc>
80105edb:	83 ec 08             	sub    $0x8,%esp
80105ede:	ff 70 10             	pushl  0x10(%eax)
80105ee1:	68 a5 87 10 80       	push   $0x801087a5
80105ee6:	e8 75 a7 ff ff       	call   80100660 <cprintf>
    exit();
80105eeb:	e8 80 e4 ff ff       	call   80104370 <exit>
    return 0;  // not reached
}
80105ef0:	31 c0                	xor    %eax,%eax
80105ef2:	c9                   	leave  
80105ef3:	c3                   	ret    
80105ef4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105efa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105f00 <sys_wait>:

int sys_wait(void) {
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
    return wait();
}
80105f03:	5d                   	pop    %ebp
    return wait();
80105f04:	e9 b7 e6 ff ff       	jmp    801045c0 <wait>
80105f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f10 <sys_waitx>:

int sys_waitx(void) {
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	83 ec 1c             	sub    $0x1c,%esp
    int *wtime, *rtime;
    if (argptr(0, (char **)&wtime, sizeof(int)) < 0) {
80105f16:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f19:	6a 04                	push   $0x4
80105f1b:	50                   	push   %eax
80105f1c:	6a 00                	push   $0x0
80105f1e:	e8 bd f2 ff ff       	call   801051e0 <argptr>
80105f23:	83 c4 10             	add    $0x10,%esp
80105f26:	85 c0                	test   %eax,%eax
80105f28:	78 2e                	js     80105f58 <sys_waitx+0x48>
        return -1;
    }
    if (argptr(1, (char **)&rtime, sizeof(int)) < 0) {
80105f2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f2d:	83 ec 04             	sub    $0x4,%esp
80105f30:	6a 04                	push   $0x4
80105f32:	50                   	push   %eax
80105f33:	6a 01                	push   $0x1
80105f35:	e8 a6 f2 ff ff       	call   801051e0 <argptr>
80105f3a:	83 c4 10             	add    $0x10,%esp
80105f3d:	85 c0                	test   %eax,%eax
80105f3f:	78 17                	js     80105f58 <sys_waitx+0x48>
        return -1;
    }

    return waitx(wtime, rtime);
80105f41:	83 ec 08             	sub    $0x8,%esp
80105f44:	ff 75 f4             	pushl  -0xc(%ebp)
80105f47:	ff 75 f0             	pushl  -0x10(%ebp)
80105f4a:	e8 61 e7 ff ff       	call   801046b0 <waitx>
80105f4f:	83 c4 10             	add    $0x10,%esp
}
80105f52:	c9                   	leave  
80105f53:	c3                   	ret    
80105f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f5d:	c9                   	leave  
80105f5e:	c3                   	ret    
80105f5f:	90                   	nop

80105f60 <sys_set_priority>:

int sys_set_priority(void) {
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	83 ec 20             	sub    $0x20,%esp
    int pid, priority;
    if (argint(0, &pid) < 0)
80105f66:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f69:	50                   	push   %eax
80105f6a:	6a 00                	push   $0x0
80105f6c:	e8 1f f2 ff ff       	call   80105190 <argint>
80105f71:	83 c4 10             	add    $0x10,%esp
80105f74:	85 c0                	test   %eax,%eax
80105f76:	78 28                	js     80105fa0 <sys_set_priority+0x40>
        return -1;
    if (argint(1, &priority) < 0)
80105f78:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f7b:	83 ec 08             	sub    $0x8,%esp
80105f7e:	50                   	push   %eax
80105f7f:	6a 01                	push   $0x1
80105f81:	e8 0a f2 ff ff       	call   80105190 <argint>
80105f86:	83 c4 10             	add    $0x10,%esp
80105f89:	85 c0                	test   %eax,%eax
80105f8b:	78 13                	js     80105fa0 <sys_set_priority+0x40>
        return -1;

    return set_priority(pid, priority);
80105f8d:	83 ec 08             	sub    $0x8,%esp
80105f90:	ff 75 f4             	pushl  -0xc(%ebp)
80105f93:	ff 75 f0             	pushl  -0x10(%ebp)
80105f96:	e8 45 e0 ff ff       	call   80103fe0 <set_priority>
80105f9b:	83 c4 10             	add    $0x10,%esp
}
80105f9e:	c9                   	leave  
80105f9f:	c3                   	ret    
        return -1;
80105fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fa5:	c9                   	leave  
80105fa6:	c3                   	ret    
80105fa7:	89 f6                	mov    %esi,%esi
80105fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fb0 <sys_getpinfo>:

int sys_getpinfo(void) {
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	83 ec 20             	sub    $0x20,%esp
    int pid;
    struct proc_stat *p;
    if (argint(1, &pid) < 0) {
80105fb6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fb9:	50                   	push   %eax
80105fba:	6a 01                	push   $0x1
80105fbc:	e8 cf f1 ff ff       	call   80105190 <argint>
80105fc1:	83 c4 10             	add    $0x10,%esp
80105fc4:	85 c0                	test   %eax,%eax
80105fc6:	78 30                	js     80105ff8 <sys_getpinfo+0x48>
        return -1;
    }
    if (argptr(0, (char **)&p, sizeof(struct proc_stat)) < 0) {
80105fc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fcb:	83 ec 04             	sub    $0x4,%esp
80105fce:	6a 24                	push   $0x24
80105fd0:	50                   	push   %eax
80105fd1:	6a 00                	push   $0x0
80105fd3:	e8 08 f2 ff ff       	call   801051e0 <argptr>
80105fd8:	83 c4 10             	add    $0x10,%esp
80105fdb:	85 c0                	test   %eax,%eax
80105fdd:	78 19                	js     80105ff8 <sys_getpinfo+0x48>
        return -1;
    }

    return getpinfo(p, pid);
80105fdf:	83 ec 08             	sub    $0x8,%esp
80105fe2:	ff 75 f0             	pushl  -0x10(%ebp)
80105fe5:	ff 75 f4             	pushl  -0xc(%ebp)
80105fe8:	e8 33 d9 ff ff       	call   80103920 <getpinfo>
80105fed:	83 c4 10             	add    $0x10,%esp
}
80105ff0:	c9                   	leave  
80105ff1:	c3                   	ret    
80105ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
80105ff8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ffd:	c9                   	leave  
80105ffe:	c3                   	ret    
80105fff:	90                   	nop

80106000 <sys_kill>:

int sys_kill(void) {
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	83 ec 20             	sub    $0x20,%esp
    int pid;

    if (argint(0, &pid) < 0)
80106006:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106009:	50                   	push   %eax
8010600a:	6a 00                	push   $0x0
8010600c:	e8 7f f1 ff ff       	call   80105190 <argint>
80106011:	83 c4 10             	add    $0x10,%esp
80106014:	85 c0                	test   %eax,%eax
80106016:	78 18                	js     80106030 <sys_kill+0x30>
        return -1;
    return kill(pid);
80106018:	83 ec 0c             	sub    $0xc,%esp
8010601b:	ff 75 f4             	pushl  -0xc(%ebp)
8010601e:	e8 1d e8 ff ff       	call   80104840 <kill>
80106023:	83 c4 10             	add    $0x10,%esp
}
80106026:	c9                   	leave  
80106027:	c3                   	ret    
80106028:	90                   	nop
80106029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80106030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106035:	c9                   	leave  
80106036:	c3                   	ret    
80106037:	89 f6                	mov    %esi,%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106040 <sys_getpid>:

int sys_getpid(void) {
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
80106046:	e8 a5 d8 ff ff       	call   801038f0 <myproc>
8010604b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010604e:	c9                   	leave  
8010604f:	c3                   	ret    

80106050 <sys_sbrk>:

int sys_sbrk(void) {
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	53                   	push   %ebx
    int addr;
    int n;

    if (argint(0, &n) < 0)
80106054:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sbrk(void) {
80106057:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0)
8010605a:	50                   	push   %eax
8010605b:	6a 00                	push   $0x0
8010605d:	e8 2e f1 ff ff       	call   80105190 <argint>
80106062:	83 c4 10             	add    $0x10,%esp
80106065:	85 c0                	test   %eax,%eax
80106067:	78 27                	js     80106090 <sys_sbrk+0x40>
        return -1;
    addr = myproc()->sz;
80106069:	e8 82 d8 ff ff       	call   801038f0 <myproc>
    if (growproc(n) < 0)
8010606e:	83 ec 0c             	sub    $0xc,%esp
    addr = myproc()->sz;
80106071:	8b 18                	mov    (%eax),%ebx
    if (growproc(n) < 0)
80106073:	ff 75 f4             	pushl  -0xc(%ebp)
80106076:	e8 65 dd ff ff       	call   80103de0 <growproc>
8010607b:	83 c4 10             	add    $0x10,%esp
8010607e:	85 c0                	test   %eax,%eax
80106080:	78 0e                	js     80106090 <sys_sbrk+0x40>
        return -1;
    return addr;
}
80106082:	89 d8                	mov    %ebx,%eax
80106084:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106087:	c9                   	leave  
80106088:	c3                   	ret    
80106089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80106090:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106095:	eb eb                	jmp    80106082 <sys_sbrk+0x32>
80106097:	89 f6                	mov    %esi,%esi
80106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060a0 <sys_sleep>:

int sys_sleep(void) {
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	53                   	push   %ebx
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
801060a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sleep(void) {
801060a7:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0)
801060aa:	50                   	push   %eax
801060ab:	6a 00                	push   $0x0
801060ad:	e8 de f0 ff ff       	call   80105190 <argint>
801060b2:	83 c4 10             	add    $0x10,%esp
801060b5:	85 c0                	test   %eax,%eax
801060b7:	0f 88 8a 00 00 00    	js     80106147 <sys_sleep+0xa7>
        return -1;
    acquire(&tickslock);
801060bd:	83 ec 0c             	sub    $0xc,%esp
801060c0:	68 40 c1 11 80       	push   $0x8011c140
801060c5:	e8 b6 ec ff ff       	call   80104d80 <acquire>
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
801060ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060cd:	83 c4 10             	add    $0x10,%esp
    ticks0 = ticks;
801060d0:	8b 1d 80 c9 11 80    	mov    0x8011c980,%ebx
    while (ticks - ticks0 < n) {
801060d6:	85 d2                	test   %edx,%edx
801060d8:	75 27                	jne    80106101 <sys_sleep+0x61>
801060da:	eb 54                	jmp    80106130 <sys_sleep+0x90>
801060dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
801060e0:	83 ec 08             	sub    $0x8,%esp
801060e3:	68 40 c1 11 80       	push   $0x8011c140
801060e8:	68 80 c9 11 80       	push   $0x8011c980
801060ed:	e8 0e e4 ff ff       	call   80104500 <sleep>
    while (ticks - ticks0 < n) {
801060f2:	a1 80 c9 11 80       	mov    0x8011c980,%eax
801060f7:	83 c4 10             	add    $0x10,%esp
801060fa:	29 d8                	sub    %ebx,%eax
801060fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801060ff:	73 2f                	jae    80106130 <sys_sleep+0x90>
        if (myproc()->killed) {
80106101:	e8 ea d7 ff ff       	call   801038f0 <myproc>
80106106:	8b 40 24             	mov    0x24(%eax),%eax
80106109:	85 c0                	test   %eax,%eax
8010610b:	74 d3                	je     801060e0 <sys_sleep+0x40>
            release(&tickslock);
8010610d:	83 ec 0c             	sub    $0xc,%esp
80106110:	68 40 c1 11 80       	push   $0x8011c140
80106115:	e8 26 ed ff ff       	call   80104e40 <release>
            return -1;
8010611a:	83 c4 10             	add    $0x10,%esp
8010611d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    release(&tickslock);
    return 0;
}
80106122:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106125:	c9                   	leave  
80106126:	c3                   	ret    
80106127:	89 f6                	mov    %esi,%esi
80106129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&tickslock);
80106130:	83 ec 0c             	sub    $0xc,%esp
80106133:	68 40 c1 11 80       	push   $0x8011c140
80106138:	e8 03 ed ff ff       	call   80104e40 <release>
    return 0;
8010613d:	83 c4 10             	add    $0x10,%esp
80106140:	31 c0                	xor    %eax,%eax
}
80106142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106145:	c9                   	leave  
80106146:	c3                   	ret    
        return -1;
80106147:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010614c:	eb f4                	jmp    80106142 <sys_sleep+0xa2>
8010614e:	66 90                	xchg   %ax,%ax

80106150 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void) {
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	53                   	push   %ebx
80106154:	83 ec 10             	sub    $0x10,%esp
    uint xticks;

    acquire(&tickslock);
80106157:	68 40 c1 11 80       	push   $0x8011c140
8010615c:	e8 1f ec ff ff       	call   80104d80 <acquire>
    xticks = ticks;
80106161:	8b 1d 80 c9 11 80    	mov    0x8011c980,%ebx
    release(&tickslock);
80106167:	c7 04 24 40 c1 11 80 	movl   $0x8011c140,(%esp)
8010616e:	e8 cd ec ff ff       	call   80104e40 <release>
    return xticks;
}
80106173:	89 d8                	mov    %ebx,%eax
80106175:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106178:	c9                   	leave  
80106179:	c3                   	ret    

8010617a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010617a:	1e                   	push   %ds
  pushl %es
8010617b:	06                   	push   %es
  pushl %fs
8010617c:	0f a0                	push   %fs
  pushl %gs
8010617e:	0f a8                	push   %gs
  pushal
80106180:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106181:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106185:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106187:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106189:	54                   	push   %esp
  call trap
8010618a:	e8 c1 00 00 00       	call   80106250 <trap>
  addl $4, %esp
8010618f:	83 c4 04             	add    $0x4,%esp

80106192 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106192:	61                   	popa   
  popl %gs
80106193:	0f a9                	pop    %gs
  popl %fs
80106195:	0f a1                	pop    %fs
  popl %es
80106197:	07                   	pop    %es
  popl %ds
80106198:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106199:	83 c4 08             	add    $0x8,%esp
  iret
8010619c:	cf                   	iret   
8010619d:	66 90                	xchg   %ax,%ax
8010619f:	90                   	nop

801061a0 <tvinit>:
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void) {
801061a0:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++)
801061a1:	31 c0                	xor    %eax,%eax
void tvinit(void) {
801061a3:	89 e5                	mov    %esp,%ebp
801061a5:	83 ec 08             	sub    $0x8,%esp
801061a8:	90                   	nop
801061a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
801061b0:	8b 14 85 7c b0 10 80 	mov    -0x7fef4f84(,%eax,4),%edx
801061b7:	c7 04 c5 82 c1 11 80 	movl   $0x8e000008,-0x7fee3e7e(,%eax,8)
801061be:	08 00 00 8e 
801061c2:	66 89 14 c5 80 c1 11 	mov    %dx,-0x7fee3e80(,%eax,8)
801061c9:	80 
801061ca:	c1 ea 10             	shr    $0x10,%edx
801061cd:	66 89 14 c5 86 c1 11 	mov    %dx,-0x7fee3e7a(,%eax,8)
801061d4:	80 
    for (i = 0; i < 256; i++)
801061d5:	83 c0 01             	add    $0x1,%eax
801061d8:	3d 00 01 00 00       	cmp    $0x100,%eax
801061dd:	75 d1                	jne    801061b0 <tvinit+0x10>
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801061df:	a1 7c b1 10 80       	mov    0x8010b17c,%eax

    initlock(&tickslock, "time");
801061e4:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801061e7:	c7 05 82 c3 11 80 08 	movl   $0xef000008,0x8011c382
801061ee:	00 00 ef 
    initlock(&tickslock, "time");
801061f1:	68 b5 87 10 80       	push   $0x801087b5
801061f6:	68 40 c1 11 80       	push   $0x8011c140
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801061fb:	66 a3 80 c3 11 80    	mov    %ax,0x8011c380
80106201:	c1 e8 10             	shr    $0x10,%eax
80106204:	66 a3 86 c3 11 80    	mov    %ax,0x8011c386
    initlock(&tickslock, "time");
8010620a:	e8 31 ea ff ff       	call   80104c40 <initlock>
}
8010620f:	83 c4 10             	add    $0x10,%esp
80106212:	c9                   	leave  
80106213:	c3                   	ret    
80106214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010621a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106220 <idtinit>:

void idtinit(void) {
80106220:	55                   	push   %ebp
  pd[0] = size-1;
80106221:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106226:	89 e5                	mov    %esp,%ebp
80106228:	83 ec 10             	sub    $0x10,%esp
8010622b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010622f:	b8 80 c1 11 80       	mov    $0x8011c180,%eax
80106234:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106238:	c1 e8 10             	shr    $0x10,%eax
8010623b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010623f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106242:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80106245:	c9                   	leave  
80106246:	c3                   	ret    
80106247:	89 f6                	mov    %esi,%esi
80106249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106250 <trap>:

// PAGEBREAK: 41
void trap(struct trapframe *tf) {
80106250:	55                   	push   %ebp
80106251:	89 e5                	mov    %esp,%ebp
80106253:	57                   	push   %edi
80106254:	56                   	push   %esi
80106255:	53                   	push   %ebx
80106256:	83 ec 1c             	sub    $0x1c,%esp
80106259:	8b 7d 08             	mov    0x8(%ebp),%edi
    if (tf->trapno == T_SYSCALL) {
8010625c:	8b 47 30             	mov    0x30(%edi),%eax
8010625f:	83 f8 40             	cmp    $0x40,%eax
80106262:	0f 84 f0 00 00 00    	je     80106358 <trap+0x108>
        if (myproc()->killed)
            exit();
        return;
    }

    switch (tf->trapno) {
80106268:	83 e8 20             	sub    $0x20,%eax
8010626b:	83 f8 1f             	cmp    $0x1f,%eax
8010626e:	77 10                	ja     80106280 <trap+0x30>
80106270:	ff 24 85 5c 88 10 80 	jmp    *-0x7fef77a4(,%eax,4)
80106277:	89 f6                	mov    %esi,%esi
80106279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            lapiceoi();
            break;

        // PAGEBREAK: 13
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
80106280:	e8 6b d6 ff ff       	call   801038f0 <myproc>
80106285:	85 c0                	test   %eax,%eax
80106287:	8b 5f 38             	mov    0x38(%edi),%ebx
8010628a:	0f 84 5d 07 00 00    	je     801069ed <trap+0x79d>
80106290:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106294:	0f 84 53 07 00 00    	je     801069ed <trap+0x79d>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010629a:	0f 20 d1             	mov    %cr2,%ecx
8010629d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf(
801062a0:	e8 2b d6 ff ff       	call   801038d0 <cpuid>
801062a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801062a8:	8b 47 34             	mov    0x34(%edi),%eax
801062ab:	8b 77 30             	mov    0x30(%edi),%esi
801062ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                "pid %d %s: trap %d err %d on cpu %d "
                "eip 0x%x addr 0x%x--kill proc\n",
                myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(),
801062b1:	e8 3a d6 ff ff       	call   801038f0 <myproc>
801062b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801062b9:	e8 32 d6 ff ff       	call   801038f0 <myproc>
            cprintf(
801062be:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801062c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801062c4:	51                   	push   %ecx
801062c5:	53                   	push   %ebx
801062c6:	52                   	push   %edx
                myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(),
801062c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
            cprintf(
801062ca:	ff 75 e4             	pushl  -0x1c(%ebp)
801062cd:	56                   	push   %esi
                myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(),
801062ce:	83 c2 6c             	add    $0x6c,%edx
            cprintf(
801062d1:	52                   	push   %edx
801062d2:	ff 70 10             	pushl  0x10(%eax)
801062d5:	68 18 88 10 80       	push   $0x80108818
801062da:	e8 81 a3 ff ff       	call   80100660 <cprintf>
                tf->eip, rcr2());
            myproc()->killed = 1;
801062df:	83 c4 20             	add    $0x20,%esp
801062e2:	e8 09 d6 ff ff       	call   801038f0 <myproc>
801062e7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801062ee:	e8 fd d5 ff ff       	call   801038f0 <myproc>
801062f3:	85 c0                	test   %eax,%eax
801062f5:	74 1d                	je     80106314 <trap+0xc4>
801062f7:	e8 f4 d5 ff ff       	call   801038f0 <myproc>
801062fc:	8b 48 24             	mov    0x24(%eax),%ecx
801062ff:	85 c9                	test   %ecx,%ecx
80106301:	74 11                	je     80106314 <trap+0xc4>
80106303:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106307:	83 e0 03             	and    $0x3,%eax
8010630a:	66 83 f8 03          	cmp    $0x3,%ax
8010630e:	0f 84 dc 02 00 00    	je     801065f0 <trap+0x3a0>
        }
    }
#endif

#ifdef MLFQ
    if (myproc() && myproc()->state == RUNNING &&
80106314:	e8 d7 d5 ff ff       	call   801038f0 <myproc>
80106319:	85 c0                	test   %eax,%eax
8010631b:	74 0b                	je     80106328 <trap+0xd8>
8010631d:	e8 ce d5 ff ff       	call   801038f0 <myproc>
80106322:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106326:	74 68                	je     80106390 <trap+0x140>
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();
#endif

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106328:	e8 c3 d5 ff ff       	call   801038f0 <myproc>
8010632d:	85 c0                	test   %eax,%eax
8010632f:	74 19                	je     8010634a <trap+0xfa>
80106331:	e8 ba d5 ff ff       	call   801038f0 <myproc>
80106336:	8b 40 24             	mov    0x24(%eax),%eax
80106339:	85 c0                	test   %eax,%eax
8010633b:	74 0d                	je     8010634a <trap+0xfa>
8010633d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106341:	83 e0 03             	and    $0x3,%eax
80106344:	66 83 f8 03          	cmp    $0x3,%ax
80106348:	74 37                	je     80106381 <trap+0x131>
        exit();
}
8010634a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010634d:	5b                   	pop    %ebx
8010634e:	5e                   	pop    %esi
8010634f:	5f                   	pop    %edi
80106350:	5d                   	pop    %ebp
80106351:	c3                   	ret    
80106352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (myproc()->killed)
80106358:	e8 93 d5 ff ff       	call   801038f0 <myproc>
8010635d:	8b 70 24             	mov    0x24(%eax),%esi
80106360:	85 f6                	test   %esi,%esi
80106362:	0f 85 78 02 00 00    	jne    801065e0 <trap+0x390>
        myproc()->tf = tf;
80106368:	e8 83 d5 ff ff       	call   801038f0 <myproc>
8010636d:	89 78 18             	mov    %edi,0x18(%eax)
        syscall();
80106370:	e8 0b ef ff ff       	call   80105280 <syscall>
        if (myproc()->killed)
80106375:	e8 76 d5 ff ff       	call   801038f0 <myproc>
8010637a:	8b 58 24             	mov    0x24(%eax),%ebx
8010637d:	85 db                	test   %ebx,%ebx
8010637f:	74 c9                	je     8010634a <trap+0xfa>
}
80106381:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106384:	5b                   	pop    %ebx
80106385:	5e                   	pop    %esi
80106386:	5f                   	pop    %edi
80106387:	5d                   	pop    %ebp
            exit();
80106388:	e9 e3 df ff ff       	jmp    80104370 <exit>
8010638d:	8d 76 00             	lea    0x0(%esi),%esi
    if (myproc() && myproc()->state == RUNNING &&
80106390:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106394:	75 92                	jne    80106328 <trap+0xd8>
        int no = myproc()->qno;
80106396:	e8 55 d5 ff ff       	call   801038f0 <myproc>
8010639b:	8b 98 90 00 00 00    	mov    0x90(%eax),%ebx
        if (myproc()->tick[no] != 0) {
801063a1:	e8 4a d5 ff ff       	call   801038f0 <myproc>
801063a6:	8b 94 98 98 00 00 00 	mov    0x98(%eax,%ebx,4),%edx
801063ad:	85 d2                	test   %edx,%edx
801063af:	0f 84 73 ff ff ff    	je     80106328 <trap+0xd8>
            if (no == 0) {
801063b5:	85 db                	test   %ebx,%ebx
801063b7:	0f 84 c9 02 00 00    	je     80106686 <trap+0x436>
            } else if (no == 1 && myproc()->tick[1] % 2 == 0) {
801063bd:	83 fb 01             	cmp    $0x1,%ebx
801063c0:	0f 84 aa 03 00 00    	je     80106770 <trap+0x520>
            } else if (no == 2 && myproc()->tick[2] % 4 == 0) {
801063c6:	83 fb 02             	cmp    $0x2,%ebx
801063c9:	0f 84 45 04 00 00    	je     80106814 <trap+0x5c4>
            } else if (no == 3 && myproc()->tick[3] % 8 == 0) {
801063cf:	83 fb 03             	cmp    $0x3,%ebx
801063d2:	0f 84 e0 04 00 00    	je     801068b8 <trap+0x668>
            } else if (no == 4 && myproc()->tick[4] % 16 == 0) {
801063d8:	83 fb 04             	cmp    $0x4,%ebx
801063db:	0f 84 88 05 00 00    	je     80106969 <trap+0x719>
                for (int j = 0; j < cnt[0]; j++) {
801063e1:	8b 0d 1c b6 10 80    	mov    0x8010b61c,%ecx
801063e7:	85 c9                	test   %ecx,%ecx
801063e9:	7e 2d                	jle    80106418 <trap+0x1c8>
                    if (q0[j]->state == RUNNABLE) {
801063eb:	a1 c0 6c 11 80       	mov    0x80116cc0,%eax
801063f0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801063f4:	0f 84 27 03 00 00    	je     80106721 <trap+0x4d1>
                for (int j = 0; j < cnt[0]; j++) {
801063fa:	31 c0                	xor    %eax,%eax
801063fc:	eb 13                	jmp    80106411 <trap+0x1c1>
801063fe:	66 90                	xchg   %ax,%ax
                    if (q0[j]->state == RUNNABLE) {
80106400:	8b 14 85 c0 6c 11 80 	mov    -0x7fee9340(,%eax,4),%edx
80106407:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
8010640b:	0f 84 10 03 00 00    	je     80106721 <trap+0x4d1>
                for (int j = 0; j < cnt[0]; j++) {
80106411:	83 c0 01             	add    $0x1,%eax
80106414:	39 c8                	cmp    %ecx,%eax
80106416:	75 e8                	jne    80106400 <trap+0x1b0>
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
80106418:	31 c9                	xor    %ecx,%ecx
                for (int j = 0; j < cnt[1]; j++) {
8010641a:	8b 35 20 b6 10 80    	mov    0x8010b620,%esi
80106420:	85 f6                	test   %esi,%esi
80106422:	7e 34                	jle    80106458 <trap+0x208>
                    if (q1[j]->state == RUNNABLE) {
80106424:	a1 20 5d 11 80       	mov    0x80115d20,%eax
80106429:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010642d:	0f 84 14 03 00 00    	je     80106747 <trap+0x4f7>
                for (int j = 0; j < cnt[1]; j++) {
80106433:	31 c0                	xor    %eax,%eax
80106435:	eb 1a                	jmp    80106451 <trap+0x201>
80106437:	89 f6                	mov    %esi,%esi
80106439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    if (q1[j]->state == RUNNABLE) {
80106440:	8b 14 85 20 5d 11 80 	mov    -0x7feea2e0(,%eax,4),%edx
80106447:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
8010644b:	0f 84 f6 02 00 00    	je     80106747 <trap+0x4f7>
                for (int j = 0; j < cnt[1]; j++) {
80106451:	83 c0 01             	add    $0x1,%eax
80106454:	39 c6                	cmp    %eax,%esi
80106456:	75 e8                	jne    80106440 <trap+0x1f0>
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
80106458:	31 d2                	xor    %edx,%edx
                for (int j = 0; j < cnt[2]; j++) {
8010645a:	8b 35 24 b6 10 80    	mov    0x8010b624,%esi
80106460:	85 f6                	test   %esi,%esi
80106462:	0f 8e 72 05 00 00    	jle    801069da <trap+0x78a>
                    if (q2[j]->state == RUNNABLE) {
80106468:	a1 c0 3d 11 80       	mov    0x80113dc0,%eax
8010646d:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80106471:	0f 84 c4 02 00 00    	je     8010673b <trap+0x4eb>
                for (int j = 0; j < cnt[2]; j++) {
80106477:	31 c0                	xor    %eax,%eax
80106479:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010647c:	eb 13                	jmp    80106491 <trap+0x241>
8010647e:	66 90                	xchg   %ax,%ax
                    if (q2[j]->state == RUNNABLE) {
80106480:	8b 14 85 c0 3d 11 80 	mov    -0x7feec240(,%eax,4),%edx
80106487:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
8010648b:	0f 84 a7 02 00 00    	je     80106738 <trap+0x4e8>
                for (int j = 0; j < cnt[2]; j++) {
80106491:	83 c0 01             	add    $0x1,%eax
80106494:	39 c6                	cmp    %eax,%esi
80106496:	75 e8                	jne    80106480 <trap+0x230>
80106498:	8b 55 e4             	mov    -0x1c(%ebp),%edx
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
8010649b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
                for (int j = 0; j < cnt[3]; j++) {
801064a2:	8b 35 28 b6 10 80    	mov    0x8010b628,%esi
801064a8:	85 f6                	test   %esi,%esi
801064aa:	0f 8e 36 05 00 00    	jle    801069e6 <trap+0x796>
                    if (q3[j]->state == RUNNABLE) {
801064b0:	a1 80 4d 11 80       	mov    0x80114d80,%eax
801064b5:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801064b9:	0f 84 6f 02 00 00    	je     8010672e <trap+0x4de>
                for (int j = 0; j < cnt[3]; j++) {
801064bf:	31 c0                	xor    %eax,%eax
801064c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801064c4:	eb 1b                	jmp    801064e1 <trap+0x291>
801064c6:	8d 76 00             	lea    0x0(%esi),%esi
801064c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    if (q3[j]->state == RUNNABLE) {
801064d0:	8b 14 85 80 4d 11 80 	mov    -0x7feeb280(,%eax,4),%edx
801064d7:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801064db:	0f 84 4a 02 00 00    	je     8010672b <trap+0x4db>
                for (int j = 0; j < cnt[3]; j++) {
801064e1:	83 c0 01             	add    $0x1,%eax
801064e4:	39 f0                	cmp    %esi,%eax
801064e6:	75 e8                	jne    801064d0 <trap+0x280>
801064e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
801064eb:	31 c0                	xor    %eax,%eax
                if (no == 1) {
801064ed:	83 fb 01             	cmp    $0x1,%ebx
801064f0:	0f 84 6c 02 00 00    	je     80106762 <trap+0x512>
                } else if (no == 2) {
801064f6:	83 fb 02             	cmp    $0x2,%ebx
801064f9:	0f 84 5d 04 00 00    	je     8010695c <trap+0x70c>
                } else if (no == 3) {
801064ff:	83 fb 03             	cmp    $0x3,%ebx
80106502:	0f 84 bf 04 00 00    	je     801069c7 <trap+0x777>
                } else if (no == 4) {
80106508:	83 fb 04             	cmp    $0x4,%ebx
8010650b:	0f 85 17 fe ff ff    	jne    80106328 <trap+0xd8>
                    if (flag0 == 1 || flag1 == 1 || flag2 == 1 || flag3 == 1) {
80106511:	09 d1                	or     %edx,%ecx
80106513:	75 0b                	jne    80106520 <trap+0x2d0>
80106515:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106518:	09 c1                	or     %eax,%ecx
8010651a:	0f 84 08 fe ff ff    	je     80106328 <trap+0xd8>
                yield();
80106520:	e8 8b df ff ff       	call   801044b0 <yield>
80106525:	e9 fe fd ff ff       	jmp    80106328 <trap+0xd8>
8010652a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if (cpuid() == 0) {
80106530:	e8 9b d3 ff ff       	call   801038d0 <cpuid>
80106535:	85 c0                	test   %eax,%eax
80106537:	0f 84 c3 00 00 00    	je     80106600 <trap+0x3b0>
            lapiceoi();
8010653d:	e8 0e c2 ff ff       	call   80102750 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106542:	e8 a9 d3 ff ff       	call   801038f0 <myproc>
80106547:	85 c0                	test   %eax,%eax
80106549:	0f 85 a8 fd ff ff    	jne    801062f7 <trap+0xa7>
8010654f:	e9 c0 fd ff ff       	jmp    80106314 <trap+0xc4>
80106554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kbdintr();
80106558:	e8 b3 c0 ff ff       	call   80102610 <kbdintr>
            lapiceoi();
8010655d:	e8 ee c1 ff ff       	call   80102750 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106562:	e8 89 d3 ff ff       	call   801038f0 <myproc>
80106567:	85 c0                	test   %eax,%eax
80106569:	0f 85 88 fd ff ff    	jne    801062f7 <trap+0xa7>
8010656f:	e9 a0 fd ff ff       	jmp    80106314 <trap+0xc4>
80106574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            uartintr();
80106578:	e8 13 06 00 00       	call   80106b90 <uartintr>
            lapiceoi();
8010657d:	e8 ce c1 ff ff       	call   80102750 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106582:	e8 69 d3 ff ff       	call   801038f0 <myproc>
80106587:	85 c0                	test   %eax,%eax
80106589:	0f 85 68 fd ff ff    	jne    801062f7 <trap+0xa7>
8010658f:	e9 80 fd ff ff       	jmp    80106314 <trap+0xc4>
80106594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            cprintf("cpu%d: spurious interrupt at %x:%x\n", cpuid(), tf->cs,
80106598:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010659c:	8b 77 38             	mov    0x38(%edi),%esi
8010659f:	e8 2c d3 ff ff       	call   801038d0 <cpuid>
801065a4:	56                   	push   %esi
801065a5:	53                   	push   %ebx
801065a6:	50                   	push   %eax
801065a7:	68 c0 87 10 80       	push   $0x801087c0
801065ac:	e8 af a0 ff ff       	call   80100660 <cprintf>
            lapiceoi();
801065b1:	e8 9a c1 ff ff       	call   80102750 <lapiceoi>
            break;
801065b6:	83 c4 10             	add    $0x10,%esp
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801065b9:	e8 32 d3 ff ff       	call   801038f0 <myproc>
801065be:	85 c0                	test   %eax,%eax
801065c0:	0f 85 31 fd ff ff    	jne    801062f7 <trap+0xa7>
801065c6:	e9 49 fd ff ff       	jmp    80106314 <trap+0xc4>
801065cb:	90                   	nop
801065cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            ideintr();
801065d0:	e8 ab ba ff ff       	call   80102080 <ideintr>
801065d5:	e9 63 ff ff ff       	jmp    8010653d <trap+0x2ed>
801065da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            exit();
801065e0:	e8 8b dd ff ff       	call   80104370 <exit>
801065e5:	e9 7e fd ff ff       	jmp    80106368 <trap+0x118>
801065ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        exit();
801065f0:	e8 7b dd ff ff       	call   80104370 <exit>
801065f5:	e9 1a fd ff ff       	jmp    80106314 <trap+0xc4>
801065fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                acquire(&tickslock);
80106600:	83 ec 0c             	sub    $0xc,%esp
80106603:	68 40 c1 11 80       	push   $0x8011c140
80106608:	e8 73 e7 ff ff       	call   80104d80 <acquire>
                wakeup(&ticks);
8010660d:	c7 04 24 80 c9 11 80 	movl   $0x8011c980,(%esp)
                ticks++;
80106614:	83 05 80 c9 11 80 01 	addl   $0x1,0x8011c980
                wakeup(&ticks);
8010661b:	e8 c0 e1 ff ff       	call   801047e0 <wakeup>
                release(&tickslock);
80106620:	c7 04 24 40 c1 11 80 	movl   $0x8011c140,(%esp)
80106627:	e8 14 e8 ff ff       	call   80104e40 <release>
                if (myproc()) {
8010662c:	e8 bf d2 ff ff       	call   801038f0 <myproc>
80106631:	83 c4 10             	add    $0x10,%esp
80106634:	85 c0                	test   %eax,%eax
80106636:	0f 84 01 ff ff ff    	je     8010653d <trap+0x2ed>
                    if (myproc()->state == RUNNING) {
8010663c:	e8 af d2 ff ff       	call   801038f0 <myproc>
80106641:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106645:	74 19                	je     80106660 <trap+0x410>
                    } else if (myproc()->state == SLEEPING) {
80106647:	e8 a4 d2 ff ff       	call   801038f0 <myproc>
8010664c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80106650:	0f 84 fb 00 00 00    	je     80106751 <trap+0x501>
                    aging();
80106656:	e8 45 d3 ff ff       	call   801039a0 <aging>
8010665b:	e9 dd fe ff ff       	jmp    8010653d <trap+0x2ed>
                        myproc()->rtime++;
80106660:	e8 8b d2 ff ff       	call   801038f0 <myproc>
80106665:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
                        int no = myproc()->qno;
8010666c:	e8 7f d2 ff ff       	call   801038f0 <myproc>
80106671:	8b 98 90 00 00 00    	mov    0x90(%eax),%ebx
                        myproc()->tick[no]++;
80106677:	e8 74 d2 ff ff       	call   801038f0 <myproc>
8010667c:	83 84 98 98 00 00 00 	addl   $0x1,0x98(%eax,%ebx,4)
80106683:	01 
80106684:	eb d0                	jmp    80106656 <trap+0x406>
                myproc()->qno = 1;
80106686:	e8 65 d2 ff ff       	call   801038f0 <myproc>
8010668b:	c7 80 90 00 00 00 01 	movl   $0x1,0x90(%eax)
80106692:	00 00 00 
                cnt[0]--;
80106695:	8b 15 1c b6 10 80    	mov    0x8010b61c,%edx
                for (int i = beg0; i < cnt[0]; i++) {
8010669b:	a1 54 b6 10 80       	mov    0x8010b654,%eax
                cnt[0]--;
801066a0:	8d 4a ff             	lea    -0x1(%edx),%ecx
                for (int i = beg0; i < cnt[0]; i++) {
801066a3:	39 c1                	cmp    %eax,%ecx
                cnt[0]--;
801066a5:	89 0d 1c b6 10 80    	mov    %ecx,0x8010b61c
                for (int i = beg0; i < cnt[0]; i++) {
801066ab:	7e 20                	jle    801066cd <trap+0x47d>
801066ad:	8d 04 85 c0 6c 11 80 	lea    -0x7fee9340(,%eax,4),%eax
801066b4:	8d 0c 95 bc 6c 11 80 	lea    -0x7fee9344(,%edx,4),%ecx
801066bb:	90                   	nop
801066bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                    q0[i] = q0[i + 1];
801066c0:	8b 50 04             	mov    0x4(%eax),%edx
801066c3:	83 c0 04             	add    $0x4,%eax
801066c6:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = beg0; i < cnt[0]; i++) {
801066c9:	39 c8                	cmp    %ecx,%eax
801066cb:	75 f3                	jne    801066c0 <trap+0x470>
                for (int i = 0; i < cnt[1]; i++) {
801066cd:	8b 35 20 b6 10 80    	mov    0x8010b620,%esi
801066d3:	85 f6                	test   %esi,%esi
801066d5:	7e 2a                	jle    80106701 <trap+0x4b1>
801066d7:	89 f6                	mov    %esi,%esi
801066d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    if (q1[i] == myproc()) {
801066e0:	8b 34 9d 20 5d 11 80 	mov    -0x7feea2e0(,%ebx,4),%esi
801066e7:	e8 04 d2 ff ff       	call   801038f0 <myproc>
801066ec:	39 c6                	cmp    %eax,%esi
801066ee:	0f 84 2c fe ff ff    	je     80106520 <trap+0x2d0>
                for (int i = 0; i < cnt[1]; i++) {
801066f4:	8b 35 20 b6 10 80    	mov    0x8010b620,%esi
801066fa:	83 c3 01             	add    $0x1,%ebx
801066fd:	39 de                	cmp    %ebx,%esi
801066ff:	7f df                	jg     801066e0 <trap+0x490>
                    cnt[1]++;
80106701:	8d 46 01             	lea    0x1(%esi),%eax
80106704:	a3 20 b6 10 80       	mov    %eax,0x8010b620
                    q1[cnt[1] - 1] = myproc();
80106709:	e8 e2 d1 ff ff       	call   801038f0 <myproc>
                    end1 += 1;
8010670e:	83 05 3c b6 10 80 01 	addl   $0x1,0x8010b63c
                    q1[cnt[1] - 1] = myproc();
80106715:	89 04 b5 20 5d 11 80 	mov    %eax,-0x7feea2e0(,%esi,4)
8010671c:	e9 ff fd ff ff       	jmp    80106520 <trap+0x2d0>
                        flag0 = 1;
80106721:	b9 01 00 00 00       	mov    $0x1,%ecx
80106726:	e9 ef fc ff ff       	jmp    8010641a <trap+0x1ca>
8010672b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
                        flag3 = 1;
8010672e:	b8 01 00 00 00       	mov    $0x1,%eax
80106733:	e9 b5 fd ff ff       	jmp    801064ed <trap+0x29d>
80106738:	8b 55 e4             	mov    -0x1c(%ebp),%edx
                        flag2 = 1;
8010673b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
80106742:	e9 5b fd ff ff       	jmp    801064a2 <trap+0x252>
                        flag1 = 1;
80106747:	ba 01 00 00 00       	mov    $0x1,%edx
8010674c:	e9 09 fd ff ff       	jmp    8010645a <trap+0x20a>
                        myproc()->iotime++;
80106751:	e8 9a d1 ff ff       	call   801038f0 <myproc>
80106756:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
8010675d:	e9 f4 fe ff ff       	jmp    80106656 <trap+0x406>
                    if (flag0 == 1) {
80106762:	83 f9 01             	cmp    $0x1,%ecx
80106765:	0f 85 bd fb ff ff    	jne    80106328 <trap+0xd8>
8010676b:	e9 b0 fd ff ff       	jmp    80106520 <trap+0x2d0>
            } else if (no == 1 && myproc()->tick[1] % 2 == 0) {
80106770:	e8 7b d1 ff ff       	call   801038f0 <myproc>
80106775:	f6 80 9c 00 00 00 01 	testb  $0x1,0x9c(%eax)
8010677c:	0f 85 5f fc ff ff    	jne    801063e1 <trap+0x191>
                myproc()->qno = 2;
80106782:	e8 69 d1 ff ff       	call   801038f0 <myproc>
80106787:	c7 80 90 00 00 00 02 	movl   $0x2,0x90(%eax)
8010678e:	00 00 00 
                cnt[1]--;
80106791:	8b 15 20 b6 10 80    	mov    0x8010b620,%edx
                for (int i = beg1; i < cnt[1]; i++) {
80106797:	a1 50 b6 10 80       	mov    0x8010b650,%eax
                cnt[1]--;
8010679c:	8d 4a ff             	lea    -0x1(%edx),%ecx
                for (int i = beg1; i < cnt[1]; i++) {
8010679f:	39 c1                	cmp    %eax,%ecx
                cnt[1]--;
801067a1:	89 0d 20 b6 10 80    	mov    %ecx,0x8010b620
                for (int i = beg1; i < cnt[1]; i++) {
801067a7:	7e 1b                	jle    801067c4 <trap+0x574>
801067a9:	8d 04 85 20 5d 11 80 	lea    -0x7feea2e0(,%eax,4),%eax
801067b0:	8d 0c 95 1c 5d 11 80 	lea    -0x7feea2e4(,%edx,4),%ecx
                    q1[i] = q1[i + 1];
801067b7:	8b 50 04             	mov    0x4(%eax),%edx
801067ba:	83 c0 04             	add    $0x4,%eax
801067bd:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = beg1; i < cnt[1]; i++) {
801067c0:	39 c1                	cmp    %eax,%ecx
801067c2:	75 f3                	jne    801067b7 <trap+0x567>
                for (int i = 0; i < cnt[2]; i++) {
801067c4:	83 3d 24 b6 10 80 00 	cmpl   $0x0,0x8010b624
801067cb:	7e 21                	jle    801067ee <trap+0x59e>
801067cd:	31 db                	xor    %ebx,%ebx
                    if (q2[i] == myproc()) {
801067cf:	8b 34 9d c0 3d 11 80 	mov    -0x7feec240(,%ebx,4),%esi
801067d6:	e8 15 d1 ff ff       	call   801038f0 <myproc>
801067db:	39 c6                	cmp    %eax,%esi
801067dd:	0f 84 3d fd ff ff    	je     80106520 <trap+0x2d0>
                for (int i = 0; i < cnt[2]; i++) {
801067e3:	83 c3 01             	add    $0x1,%ebx
801067e6:	39 1d 24 b6 10 80    	cmp    %ebx,0x8010b624
801067ec:	7f e1                	jg     801067cf <trap+0x57f>
                    cnt[2]++;
801067ee:	8b 1d 24 b6 10 80    	mov    0x8010b624,%ebx
801067f4:	8d 43 01             	lea    0x1(%ebx),%eax
801067f7:	a3 24 b6 10 80       	mov    %eax,0x8010b624
                    q2[cnt[2] - 1] = myproc();
801067fc:	e8 ef d0 ff ff       	call   801038f0 <myproc>
                    end2 += 1;
80106801:	83 05 38 b6 10 80 01 	addl   $0x1,0x8010b638
                    q2[cnt[2] - 1] = myproc();
80106808:	89 04 9d c0 3d 11 80 	mov    %eax,-0x7feec240(,%ebx,4)
8010680f:	e9 0c fd ff ff       	jmp    80106520 <trap+0x2d0>
            } else if (no == 2 && myproc()->tick[2] % 4 == 0) {
80106814:	e8 d7 d0 ff ff       	call   801038f0 <myproc>
80106819:	f6 80 a0 00 00 00 03 	testb  $0x3,0xa0(%eax)
80106820:	0f 85 bb fb ff ff    	jne    801063e1 <trap+0x191>
                myproc()->qno = 3;
80106826:	e8 c5 d0 ff ff       	call   801038f0 <myproc>
8010682b:	c7 80 90 00 00 00 03 	movl   $0x3,0x90(%eax)
80106832:	00 00 00 
                cnt[2]--;
80106835:	8b 15 24 b6 10 80    	mov    0x8010b624,%edx
                for (int i = beg2; i < cnt[2]; i++) {
8010683b:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
                cnt[2]--;
80106840:	8d 4a ff             	lea    -0x1(%edx),%ecx
                for (int i = beg2; i < cnt[2]; i++) {
80106843:	39 c1                	cmp    %eax,%ecx
                cnt[2]--;
80106845:	89 0d 24 b6 10 80    	mov    %ecx,0x8010b624
                for (int i = beg2; i < cnt[2]; i++) {
8010684b:	7e 1b                	jle    80106868 <trap+0x618>
8010684d:	8d 04 85 c0 3d 11 80 	lea    -0x7feec240(,%eax,4),%eax
80106854:	8d 0c 95 bc 3d 11 80 	lea    -0x7feec244(,%edx,4),%ecx
                    q2[i] = q2[i + 1];
8010685b:	8b 50 04             	mov    0x4(%eax),%edx
8010685e:	83 c0 04             	add    $0x4,%eax
80106861:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = beg2; i < cnt[2]; i++) {
80106864:	39 c1                	cmp    %eax,%ecx
80106866:	75 f3                	jne    8010685b <trap+0x60b>
                for (int i = 0; i < cnt[3]; i++) {
80106868:	83 3d 28 b6 10 80 00 	cmpl   $0x0,0x8010b628
8010686f:	7e 21                	jle    80106892 <trap+0x642>
80106871:	31 db                	xor    %ebx,%ebx
                    if (q3[i] == myproc()) {
80106873:	8b 34 9d 80 4d 11 80 	mov    -0x7feeb280(,%ebx,4),%esi
8010687a:	e8 71 d0 ff ff       	call   801038f0 <myproc>
8010687f:	39 c6                	cmp    %eax,%esi
80106881:	0f 84 99 fc ff ff    	je     80106520 <trap+0x2d0>
                for (int i = 0; i < cnt[3]; i++) {
80106887:	83 c3 01             	add    $0x1,%ebx
8010688a:	39 1d 28 b6 10 80    	cmp    %ebx,0x8010b628
80106890:	7f e1                	jg     80106873 <trap+0x623>
                    cnt[3]++;
80106892:	8b 1d 28 b6 10 80    	mov    0x8010b628,%ebx
80106898:	8d 43 01             	lea    0x1(%ebx),%eax
8010689b:	a3 28 b6 10 80       	mov    %eax,0x8010b628
                    q3[cnt[3] - 1] = myproc();
801068a0:	e8 4b d0 ff ff       	call   801038f0 <myproc>
                    end3 += 1;
801068a5:	83 05 34 b6 10 80 01 	addl   $0x1,0x8010b634
                    q3[cnt[3] - 1] = myproc();
801068ac:	89 04 9d 80 4d 11 80 	mov    %eax,-0x7feeb280(,%ebx,4)
801068b3:	e9 68 fc ff ff       	jmp    80106520 <trap+0x2d0>
            } else if (no == 3 && myproc()->tick[3] % 8 == 0) {
801068b8:	e8 33 d0 ff ff       	call   801038f0 <myproc>
801068bd:	f6 80 a4 00 00 00 07 	testb  $0x7,0xa4(%eax)
801068c4:	0f 85 17 fb ff ff    	jne    801063e1 <trap+0x191>
                myproc()->qno = 4;
801068ca:	e8 21 d0 ff ff       	call   801038f0 <myproc>
801068cf:	c7 80 90 00 00 00 04 	movl   $0x4,0x90(%eax)
801068d6:	00 00 00 
                cnt[3]--;
801068d9:	8b 15 28 b6 10 80    	mov    0x8010b628,%edx
                for (int i = beg3; i < cnt[3]; i++) {
801068df:	a1 48 b6 10 80       	mov    0x8010b648,%eax
                cnt[3]--;
801068e4:	8d 4a ff             	lea    -0x1(%edx),%ecx
                for (int i = beg3; i < cnt[3]; i++) {
801068e7:	39 c1                	cmp    %eax,%ecx
                cnt[3]--;
801068e9:	89 0d 28 b6 10 80    	mov    %ecx,0x8010b628
                for (int i = beg3; i < cnt[3]; i++) {
801068ef:	7e 1b                	jle    8010690c <trap+0x6bc>
801068f1:	8d 04 85 80 4d 11 80 	lea    -0x7feeb280(,%eax,4),%eax
801068f8:	8d 0c 95 7c 4d 11 80 	lea    -0x7feeb284(,%edx,4),%ecx
                    q3[i] = q3[i + 1];
801068ff:	8b 50 04             	mov    0x4(%eax),%edx
80106902:	83 c0 04             	add    $0x4,%eax
80106905:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = beg3; i < cnt[3]; i++) {
80106908:	39 c8                	cmp    %ecx,%eax
8010690a:	75 f3                	jne    801068ff <trap+0x6af>
                for (int i = 0; i < cnt[4]; i++) {
8010690c:	83 3d 2c b6 10 80 00 	cmpl   $0x0,0x8010b62c
80106913:	7e 21                	jle    80106936 <trap+0x6e6>
80106915:	31 db                	xor    %ebx,%ebx
                    if (q4[i] == myproc()) {
80106917:	8b 34 9d a0 b1 11 80 	mov    -0x7fee4e60(,%ebx,4),%esi
8010691e:	e8 cd cf ff ff       	call   801038f0 <myproc>
80106923:	39 c6                	cmp    %eax,%esi
80106925:	0f 84 f5 fb ff ff    	je     80106520 <trap+0x2d0>
                for (int i = 0; i < cnt[4]; i++) {
8010692b:	83 c3 01             	add    $0x1,%ebx
8010692e:	39 1d 2c b6 10 80    	cmp    %ebx,0x8010b62c
80106934:	7f e1                	jg     80106917 <trap+0x6c7>
                    cnt[4]++;
80106936:	8b 1d 2c b6 10 80    	mov    0x8010b62c,%ebx
8010693c:	8d 43 01             	lea    0x1(%ebx),%eax
8010693f:	a3 2c b6 10 80       	mov    %eax,0x8010b62c
                    q4[cnt[4] - 1] = myproc();
80106944:	e8 a7 cf ff ff       	call   801038f0 <myproc>
                    end4 += 1;
80106949:	83 05 30 b6 10 80 01 	addl   $0x1,0x8010b630
                    q4[cnt[4] - 1] = myproc();
80106950:	89 04 9d a0 b1 11 80 	mov    %eax,-0x7fee4e60(,%ebx,4)
80106957:	e9 c4 fb ff ff       	jmp    80106520 <trap+0x2d0>
                    if (flag0 == 1 || flag1 == 1) {
8010695c:	09 d1                	or     %edx,%ecx
8010695e:	0f 84 c4 f9 ff ff    	je     80106328 <trap+0xd8>
80106964:	e9 b7 fb ff ff       	jmp    80106520 <trap+0x2d0>
            } else if (no == 4 && myproc()->tick[4] % 16 == 0) {
80106969:	e8 82 cf ff ff       	call   801038f0 <myproc>
8010696e:	f6 80 a8 00 00 00 0f 	testb  $0xf,0xa8(%eax)
80106975:	0f 85 66 fa ff ff    	jne    801063e1 <trap+0x191>
                q4[cnt[4]] = myproc();
8010697b:	8b 1d 2c b6 10 80    	mov    0x8010b62c,%ebx
80106981:	e8 6a cf ff ff       	call   801038f0 <myproc>
                for (int i = beg4; i < cnt[4]; i++) {
80106986:	8b 15 2c b6 10 80    	mov    0x8010b62c,%edx
                end4 += 1;
8010698c:	83 05 30 b6 10 80 01 	addl   $0x1,0x8010b630
                q4[cnt[4]] = myproc();
80106993:	89 04 9d a0 b1 11 80 	mov    %eax,-0x7fee4e60(,%ebx,4)
                for (int i = beg4; i < cnt[4]; i++) {
8010699a:	a1 44 b6 10 80       	mov    0x8010b644,%eax
8010699f:	39 d0                	cmp    %edx,%eax
801069a1:	0f 8d 79 fb ff ff    	jge    80106520 <trap+0x2d0>
801069a7:	8d 04 85 a0 b1 11 80 	lea    -0x7fee4e60(,%eax,4),%eax
801069ae:	8d 0c 95 a0 b1 11 80 	lea    -0x7fee4e60(,%edx,4),%ecx
                    q4[i] = q4[i + 1];
801069b5:	8b 50 04             	mov    0x4(%eax),%edx
801069b8:	83 c0 04             	add    $0x4,%eax
801069bb:	89 50 fc             	mov    %edx,-0x4(%eax)
                for (int i = beg4; i < cnt[4]; i++) {
801069be:	39 c1                	cmp    %eax,%ecx
801069c0:	75 f3                	jne    801069b5 <trap+0x765>
801069c2:	e9 59 fb ff ff       	jmp    80106520 <trap+0x2d0>
                    if (flag0 == 1 || flag1 == 1 || flag2 == 1) {
801069c7:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
801069cb:	09 d1                	or     %edx,%ecx
801069cd:	08 c8                	or     %cl,%al
801069cf:	0f 85 4b fb ff ff    	jne    80106520 <trap+0x2d0>
801069d5:	e9 4e f9 ff ff       	jmp    80106328 <trap+0xd8>
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;
801069da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801069e1:	e9 bc fa ff ff       	jmp    801064a2 <trap+0x252>
801069e6:	31 c0                	xor    %eax,%eax
801069e8:	e9 00 fb ff ff       	jmp    801064ed <trap+0x29d>
801069ed:	0f 20 d6             	mov    %cr2,%esi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801069f0:	e8 db ce ff ff       	call   801038d0 <cpuid>
801069f5:	83 ec 0c             	sub    $0xc,%esp
801069f8:	56                   	push   %esi
801069f9:	53                   	push   %ebx
801069fa:	50                   	push   %eax
801069fb:	ff 77 30             	pushl  0x30(%edi)
801069fe:	68 e4 87 10 80       	push   $0x801087e4
80106a03:	e8 58 9c ff ff       	call   80100660 <cprintf>
                panic("trap");
80106a08:	83 c4 14             	add    $0x14,%esp
80106a0b:	68 ba 87 10 80       	push   $0x801087ba
80106a10:	e8 7b 99 ff ff       	call   80100390 <panic>
80106a15:	66 90                	xchg   %ax,%ax
80106a17:	66 90                	xchg   %ax,%ax
80106a19:	66 90                	xchg   %ax,%ax
80106a1b:	66 90                	xchg   %ax,%ax
80106a1d:	66 90                	xchg   %ax,%ax
80106a1f:	90                   	nop

80106a20 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106a20:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
{
80106a25:	55                   	push   %ebp
80106a26:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106a28:	85 c0                	test   %eax,%eax
80106a2a:	74 1c                	je     80106a48 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a2c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106a31:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106a32:	a8 01                	test   $0x1,%al
80106a34:	74 12                	je     80106a48 <uartgetc+0x28>
80106a36:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a3b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106a3c:	0f b6 c0             	movzbl %al,%eax
}
80106a3f:	5d                   	pop    %ebp
80106a40:	c3                   	ret    
80106a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a4d:	5d                   	pop    %ebp
80106a4e:	c3                   	ret    
80106a4f:	90                   	nop

80106a50 <uartputc.part.0>:
uartputc(int c)
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	57                   	push   %edi
80106a54:	56                   	push   %esi
80106a55:	53                   	push   %ebx
80106a56:	89 c7                	mov    %eax,%edi
80106a58:	bb 80 00 00 00       	mov    $0x80,%ebx
80106a5d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106a62:	83 ec 0c             	sub    $0xc,%esp
80106a65:	eb 1b                	jmp    80106a82 <uartputc.part.0+0x32>
80106a67:	89 f6                	mov    %esi,%esi
80106a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106a70:	83 ec 0c             	sub    $0xc,%esp
80106a73:	6a 0a                	push   $0xa
80106a75:	e8 f6 bc ff ff       	call   80102770 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106a7a:	83 c4 10             	add    $0x10,%esp
80106a7d:	83 eb 01             	sub    $0x1,%ebx
80106a80:	74 07                	je     80106a89 <uartputc.part.0+0x39>
80106a82:	89 f2                	mov    %esi,%edx
80106a84:	ec                   	in     (%dx),%al
80106a85:	a8 20                	test   $0x20,%al
80106a87:	74 e7                	je     80106a70 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a89:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a8e:	89 f8                	mov    %edi,%eax
80106a90:	ee                   	out    %al,(%dx)
}
80106a91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a94:	5b                   	pop    %ebx
80106a95:	5e                   	pop    %esi
80106a96:	5f                   	pop    %edi
80106a97:	5d                   	pop    %ebp
80106a98:	c3                   	ret    
80106a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106aa0 <uartinit>:
{
80106aa0:	55                   	push   %ebp
80106aa1:	31 c9                	xor    %ecx,%ecx
80106aa3:	89 c8                	mov    %ecx,%eax
80106aa5:	89 e5                	mov    %esp,%ebp
80106aa7:	57                   	push   %edi
80106aa8:	56                   	push   %esi
80106aa9:	53                   	push   %ebx
80106aaa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106aaf:	89 da                	mov    %ebx,%edx
80106ab1:	83 ec 0c             	sub    $0xc,%esp
80106ab4:	ee                   	out    %al,(%dx)
80106ab5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106aba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106abf:	89 fa                	mov    %edi,%edx
80106ac1:	ee                   	out    %al,(%dx)
80106ac2:	b8 0c 00 00 00       	mov    $0xc,%eax
80106ac7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106acc:	ee                   	out    %al,(%dx)
80106acd:	be f9 03 00 00       	mov    $0x3f9,%esi
80106ad2:	89 c8                	mov    %ecx,%eax
80106ad4:	89 f2                	mov    %esi,%edx
80106ad6:	ee                   	out    %al,(%dx)
80106ad7:	b8 03 00 00 00       	mov    $0x3,%eax
80106adc:	89 fa                	mov    %edi,%edx
80106ade:	ee                   	out    %al,(%dx)
80106adf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106ae4:	89 c8                	mov    %ecx,%eax
80106ae6:	ee                   	out    %al,(%dx)
80106ae7:	b8 01 00 00 00       	mov    $0x1,%eax
80106aec:	89 f2                	mov    %esi,%edx
80106aee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106aef:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106af4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106af5:	3c ff                	cmp    $0xff,%al
80106af7:	74 5a                	je     80106b53 <uartinit+0xb3>
  uart = 1;
80106af9:	c7 05 5c b6 10 80 01 	movl   $0x1,0x8010b65c
80106b00:	00 00 00 
80106b03:	89 da                	mov    %ebx,%edx
80106b05:	ec                   	in     (%dx),%al
80106b06:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b0b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106b0c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106b0f:	bb dc 88 10 80       	mov    $0x801088dc,%ebx
  ioapicenable(IRQ_COM1, 0);
80106b14:	6a 00                	push   $0x0
80106b16:	6a 04                	push   $0x4
80106b18:	e8 b3 b7 ff ff       	call   801022d0 <ioapicenable>
80106b1d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106b20:	b8 78 00 00 00       	mov    $0x78,%eax
80106b25:	eb 13                	jmp    80106b3a <uartinit+0x9a>
80106b27:	89 f6                	mov    %esi,%esi
80106b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106b30:	83 c3 01             	add    $0x1,%ebx
80106b33:	0f be 03             	movsbl (%ebx),%eax
80106b36:	84 c0                	test   %al,%al
80106b38:	74 19                	je     80106b53 <uartinit+0xb3>
  if(!uart)
80106b3a:	8b 15 5c b6 10 80    	mov    0x8010b65c,%edx
80106b40:	85 d2                	test   %edx,%edx
80106b42:	74 ec                	je     80106b30 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106b44:	83 c3 01             	add    $0x1,%ebx
80106b47:	e8 04 ff ff ff       	call   80106a50 <uartputc.part.0>
80106b4c:	0f be 03             	movsbl (%ebx),%eax
80106b4f:	84 c0                	test   %al,%al
80106b51:	75 e7                	jne    80106b3a <uartinit+0x9a>
}
80106b53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b56:	5b                   	pop    %ebx
80106b57:	5e                   	pop    %esi
80106b58:	5f                   	pop    %edi
80106b59:	5d                   	pop    %ebp
80106b5a:	c3                   	ret    
80106b5b:	90                   	nop
80106b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b60 <uartputc>:
  if(!uart)
80106b60:	8b 15 5c b6 10 80    	mov    0x8010b65c,%edx
{
80106b66:	55                   	push   %ebp
80106b67:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106b69:	85 d2                	test   %edx,%edx
{
80106b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106b6e:	74 10                	je     80106b80 <uartputc+0x20>
}
80106b70:	5d                   	pop    %ebp
80106b71:	e9 da fe ff ff       	jmp    80106a50 <uartputc.part.0>
80106b76:	8d 76 00             	lea    0x0(%esi),%esi
80106b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106b80:	5d                   	pop    %ebp
80106b81:	c3                   	ret    
80106b82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b90 <uartintr>:

void
uartintr(void)
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106b96:	68 20 6a 10 80       	push   $0x80106a20
80106b9b:	e8 70 9c ff ff       	call   80100810 <consoleintr>
}
80106ba0:	83 c4 10             	add    $0x10,%esp
80106ba3:	c9                   	leave  
80106ba4:	c3                   	ret    

80106ba5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106ba5:	6a 00                	push   $0x0
  pushl $0
80106ba7:	6a 00                	push   $0x0
  jmp alltraps
80106ba9:	e9 cc f5 ff ff       	jmp    8010617a <alltraps>

80106bae <vector1>:
.globl vector1
vector1:
  pushl $0
80106bae:	6a 00                	push   $0x0
  pushl $1
80106bb0:	6a 01                	push   $0x1
  jmp alltraps
80106bb2:	e9 c3 f5 ff ff       	jmp    8010617a <alltraps>

80106bb7 <vector2>:
.globl vector2
vector2:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $2
80106bb9:	6a 02                	push   $0x2
  jmp alltraps
80106bbb:	e9 ba f5 ff ff       	jmp    8010617a <alltraps>

80106bc0 <vector3>:
.globl vector3
vector3:
  pushl $0
80106bc0:	6a 00                	push   $0x0
  pushl $3
80106bc2:	6a 03                	push   $0x3
  jmp alltraps
80106bc4:	e9 b1 f5 ff ff       	jmp    8010617a <alltraps>

80106bc9 <vector4>:
.globl vector4
vector4:
  pushl $0
80106bc9:	6a 00                	push   $0x0
  pushl $4
80106bcb:	6a 04                	push   $0x4
  jmp alltraps
80106bcd:	e9 a8 f5 ff ff       	jmp    8010617a <alltraps>

80106bd2 <vector5>:
.globl vector5
vector5:
  pushl $0
80106bd2:	6a 00                	push   $0x0
  pushl $5
80106bd4:	6a 05                	push   $0x5
  jmp alltraps
80106bd6:	e9 9f f5 ff ff       	jmp    8010617a <alltraps>

80106bdb <vector6>:
.globl vector6
vector6:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $6
80106bdd:	6a 06                	push   $0x6
  jmp alltraps
80106bdf:	e9 96 f5 ff ff       	jmp    8010617a <alltraps>

80106be4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106be4:	6a 00                	push   $0x0
  pushl $7
80106be6:	6a 07                	push   $0x7
  jmp alltraps
80106be8:	e9 8d f5 ff ff       	jmp    8010617a <alltraps>

80106bed <vector8>:
.globl vector8
vector8:
  pushl $8
80106bed:	6a 08                	push   $0x8
  jmp alltraps
80106bef:	e9 86 f5 ff ff       	jmp    8010617a <alltraps>

80106bf4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106bf4:	6a 00                	push   $0x0
  pushl $9
80106bf6:	6a 09                	push   $0x9
  jmp alltraps
80106bf8:	e9 7d f5 ff ff       	jmp    8010617a <alltraps>

80106bfd <vector10>:
.globl vector10
vector10:
  pushl $10
80106bfd:	6a 0a                	push   $0xa
  jmp alltraps
80106bff:	e9 76 f5 ff ff       	jmp    8010617a <alltraps>

80106c04 <vector11>:
.globl vector11
vector11:
  pushl $11
80106c04:	6a 0b                	push   $0xb
  jmp alltraps
80106c06:	e9 6f f5 ff ff       	jmp    8010617a <alltraps>

80106c0b <vector12>:
.globl vector12
vector12:
  pushl $12
80106c0b:	6a 0c                	push   $0xc
  jmp alltraps
80106c0d:	e9 68 f5 ff ff       	jmp    8010617a <alltraps>

80106c12 <vector13>:
.globl vector13
vector13:
  pushl $13
80106c12:	6a 0d                	push   $0xd
  jmp alltraps
80106c14:	e9 61 f5 ff ff       	jmp    8010617a <alltraps>

80106c19 <vector14>:
.globl vector14
vector14:
  pushl $14
80106c19:	6a 0e                	push   $0xe
  jmp alltraps
80106c1b:	e9 5a f5 ff ff       	jmp    8010617a <alltraps>

80106c20 <vector15>:
.globl vector15
vector15:
  pushl $0
80106c20:	6a 00                	push   $0x0
  pushl $15
80106c22:	6a 0f                	push   $0xf
  jmp alltraps
80106c24:	e9 51 f5 ff ff       	jmp    8010617a <alltraps>

80106c29 <vector16>:
.globl vector16
vector16:
  pushl $0
80106c29:	6a 00                	push   $0x0
  pushl $16
80106c2b:	6a 10                	push   $0x10
  jmp alltraps
80106c2d:	e9 48 f5 ff ff       	jmp    8010617a <alltraps>

80106c32 <vector17>:
.globl vector17
vector17:
  pushl $17
80106c32:	6a 11                	push   $0x11
  jmp alltraps
80106c34:	e9 41 f5 ff ff       	jmp    8010617a <alltraps>

80106c39 <vector18>:
.globl vector18
vector18:
  pushl $0
80106c39:	6a 00                	push   $0x0
  pushl $18
80106c3b:	6a 12                	push   $0x12
  jmp alltraps
80106c3d:	e9 38 f5 ff ff       	jmp    8010617a <alltraps>

80106c42 <vector19>:
.globl vector19
vector19:
  pushl $0
80106c42:	6a 00                	push   $0x0
  pushl $19
80106c44:	6a 13                	push   $0x13
  jmp alltraps
80106c46:	e9 2f f5 ff ff       	jmp    8010617a <alltraps>

80106c4b <vector20>:
.globl vector20
vector20:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $20
80106c4d:	6a 14                	push   $0x14
  jmp alltraps
80106c4f:	e9 26 f5 ff ff       	jmp    8010617a <alltraps>

80106c54 <vector21>:
.globl vector21
vector21:
  pushl $0
80106c54:	6a 00                	push   $0x0
  pushl $21
80106c56:	6a 15                	push   $0x15
  jmp alltraps
80106c58:	e9 1d f5 ff ff       	jmp    8010617a <alltraps>

80106c5d <vector22>:
.globl vector22
vector22:
  pushl $0
80106c5d:	6a 00                	push   $0x0
  pushl $22
80106c5f:	6a 16                	push   $0x16
  jmp alltraps
80106c61:	e9 14 f5 ff ff       	jmp    8010617a <alltraps>

80106c66 <vector23>:
.globl vector23
vector23:
  pushl $0
80106c66:	6a 00                	push   $0x0
  pushl $23
80106c68:	6a 17                	push   $0x17
  jmp alltraps
80106c6a:	e9 0b f5 ff ff       	jmp    8010617a <alltraps>

80106c6f <vector24>:
.globl vector24
vector24:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $24
80106c71:	6a 18                	push   $0x18
  jmp alltraps
80106c73:	e9 02 f5 ff ff       	jmp    8010617a <alltraps>

80106c78 <vector25>:
.globl vector25
vector25:
  pushl $0
80106c78:	6a 00                	push   $0x0
  pushl $25
80106c7a:	6a 19                	push   $0x19
  jmp alltraps
80106c7c:	e9 f9 f4 ff ff       	jmp    8010617a <alltraps>

80106c81 <vector26>:
.globl vector26
vector26:
  pushl $0
80106c81:	6a 00                	push   $0x0
  pushl $26
80106c83:	6a 1a                	push   $0x1a
  jmp alltraps
80106c85:	e9 f0 f4 ff ff       	jmp    8010617a <alltraps>

80106c8a <vector27>:
.globl vector27
vector27:
  pushl $0
80106c8a:	6a 00                	push   $0x0
  pushl $27
80106c8c:	6a 1b                	push   $0x1b
  jmp alltraps
80106c8e:	e9 e7 f4 ff ff       	jmp    8010617a <alltraps>

80106c93 <vector28>:
.globl vector28
vector28:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $28
80106c95:	6a 1c                	push   $0x1c
  jmp alltraps
80106c97:	e9 de f4 ff ff       	jmp    8010617a <alltraps>

80106c9c <vector29>:
.globl vector29
vector29:
  pushl $0
80106c9c:	6a 00                	push   $0x0
  pushl $29
80106c9e:	6a 1d                	push   $0x1d
  jmp alltraps
80106ca0:	e9 d5 f4 ff ff       	jmp    8010617a <alltraps>

80106ca5 <vector30>:
.globl vector30
vector30:
  pushl $0
80106ca5:	6a 00                	push   $0x0
  pushl $30
80106ca7:	6a 1e                	push   $0x1e
  jmp alltraps
80106ca9:	e9 cc f4 ff ff       	jmp    8010617a <alltraps>

80106cae <vector31>:
.globl vector31
vector31:
  pushl $0
80106cae:	6a 00                	push   $0x0
  pushl $31
80106cb0:	6a 1f                	push   $0x1f
  jmp alltraps
80106cb2:	e9 c3 f4 ff ff       	jmp    8010617a <alltraps>

80106cb7 <vector32>:
.globl vector32
vector32:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $32
80106cb9:	6a 20                	push   $0x20
  jmp alltraps
80106cbb:	e9 ba f4 ff ff       	jmp    8010617a <alltraps>

80106cc0 <vector33>:
.globl vector33
vector33:
  pushl $0
80106cc0:	6a 00                	push   $0x0
  pushl $33
80106cc2:	6a 21                	push   $0x21
  jmp alltraps
80106cc4:	e9 b1 f4 ff ff       	jmp    8010617a <alltraps>

80106cc9 <vector34>:
.globl vector34
vector34:
  pushl $0
80106cc9:	6a 00                	push   $0x0
  pushl $34
80106ccb:	6a 22                	push   $0x22
  jmp alltraps
80106ccd:	e9 a8 f4 ff ff       	jmp    8010617a <alltraps>

80106cd2 <vector35>:
.globl vector35
vector35:
  pushl $0
80106cd2:	6a 00                	push   $0x0
  pushl $35
80106cd4:	6a 23                	push   $0x23
  jmp alltraps
80106cd6:	e9 9f f4 ff ff       	jmp    8010617a <alltraps>

80106cdb <vector36>:
.globl vector36
vector36:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $36
80106cdd:	6a 24                	push   $0x24
  jmp alltraps
80106cdf:	e9 96 f4 ff ff       	jmp    8010617a <alltraps>

80106ce4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106ce4:	6a 00                	push   $0x0
  pushl $37
80106ce6:	6a 25                	push   $0x25
  jmp alltraps
80106ce8:	e9 8d f4 ff ff       	jmp    8010617a <alltraps>

80106ced <vector38>:
.globl vector38
vector38:
  pushl $0
80106ced:	6a 00                	push   $0x0
  pushl $38
80106cef:	6a 26                	push   $0x26
  jmp alltraps
80106cf1:	e9 84 f4 ff ff       	jmp    8010617a <alltraps>

80106cf6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106cf6:	6a 00                	push   $0x0
  pushl $39
80106cf8:	6a 27                	push   $0x27
  jmp alltraps
80106cfa:	e9 7b f4 ff ff       	jmp    8010617a <alltraps>

80106cff <vector40>:
.globl vector40
vector40:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $40
80106d01:	6a 28                	push   $0x28
  jmp alltraps
80106d03:	e9 72 f4 ff ff       	jmp    8010617a <alltraps>

80106d08 <vector41>:
.globl vector41
vector41:
  pushl $0
80106d08:	6a 00                	push   $0x0
  pushl $41
80106d0a:	6a 29                	push   $0x29
  jmp alltraps
80106d0c:	e9 69 f4 ff ff       	jmp    8010617a <alltraps>

80106d11 <vector42>:
.globl vector42
vector42:
  pushl $0
80106d11:	6a 00                	push   $0x0
  pushl $42
80106d13:	6a 2a                	push   $0x2a
  jmp alltraps
80106d15:	e9 60 f4 ff ff       	jmp    8010617a <alltraps>

80106d1a <vector43>:
.globl vector43
vector43:
  pushl $0
80106d1a:	6a 00                	push   $0x0
  pushl $43
80106d1c:	6a 2b                	push   $0x2b
  jmp alltraps
80106d1e:	e9 57 f4 ff ff       	jmp    8010617a <alltraps>

80106d23 <vector44>:
.globl vector44
vector44:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $44
80106d25:	6a 2c                	push   $0x2c
  jmp alltraps
80106d27:	e9 4e f4 ff ff       	jmp    8010617a <alltraps>

80106d2c <vector45>:
.globl vector45
vector45:
  pushl $0
80106d2c:	6a 00                	push   $0x0
  pushl $45
80106d2e:	6a 2d                	push   $0x2d
  jmp alltraps
80106d30:	e9 45 f4 ff ff       	jmp    8010617a <alltraps>

80106d35 <vector46>:
.globl vector46
vector46:
  pushl $0
80106d35:	6a 00                	push   $0x0
  pushl $46
80106d37:	6a 2e                	push   $0x2e
  jmp alltraps
80106d39:	e9 3c f4 ff ff       	jmp    8010617a <alltraps>

80106d3e <vector47>:
.globl vector47
vector47:
  pushl $0
80106d3e:	6a 00                	push   $0x0
  pushl $47
80106d40:	6a 2f                	push   $0x2f
  jmp alltraps
80106d42:	e9 33 f4 ff ff       	jmp    8010617a <alltraps>

80106d47 <vector48>:
.globl vector48
vector48:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $48
80106d49:	6a 30                	push   $0x30
  jmp alltraps
80106d4b:	e9 2a f4 ff ff       	jmp    8010617a <alltraps>

80106d50 <vector49>:
.globl vector49
vector49:
  pushl $0
80106d50:	6a 00                	push   $0x0
  pushl $49
80106d52:	6a 31                	push   $0x31
  jmp alltraps
80106d54:	e9 21 f4 ff ff       	jmp    8010617a <alltraps>

80106d59 <vector50>:
.globl vector50
vector50:
  pushl $0
80106d59:	6a 00                	push   $0x0
  pushl $50
80106d5b:	6a 32                	push   $0x32
  jmp alltraps
80106d5d:	e9 18 f4 ff ff       	jmp    8010617a <alltraps>

80106d62 <vector51>:
.globl vector51
vector51:
  pushl $0
80106d62:	6a 00                	push   $0x0
  pushl $51
80106d64:	6a 33                	push   $0x33
  jmp alltraps
80106d66:	e9 0f f4 ff ff       	jmp    8010617a <alltraps>

80106d6b <vector52>:
.globl vector52
vector52:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $52
80106d6d:	6a 34                	push   $0x34
  jmp alltraps
80106d6f:	e9 06 f4 ff ff       	jmp    8010617a <alltraps>

80106d74 <vector53>:
.globl vector53
vector53:
  pushl $0
80106d74:	6a 00                	push   $0x0
  pushl $53
80106d76:	6a 35                	push   $0x35
  jmp alltraps
80106d78:	e9 fd f3 ff ff       	jmp    8010617a <alltraps>

80106d7d <vector54>:
.globl vector54
vector54:
  pushl $0
80106d7d:	6a 00                	push   $0x0
  pushl $54
80106d7f:	6a 36                	push   $0x36
  jmp alltraps
80106d81:	e9 f4 f3 ff ff       	jmp    8010617a <alltraps>

80106d86 <vector55>:
.globl vector55
vector55:
  pushl $0
80106d86:	6a 00                	push   $0x0
  pushl $55
80106d88:	6a 37                	push   $0x37
  jmp alltraps
80106d8a:	e9 eb f3 ff ff       	jmp    8010617a <alltraps>

80106d8f <vector56>:
.globl vector56
vector56:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $56
80106d91:	6a 38                	push   $0x38
  jmp alltraps
80106d93:	e9 e2 f3 ff ff       	jmp    8010617a <alltraps>

80106d98 <vector57>:
.globl vector57
vector57:
  pushl $0
80106d98:	6a 00                	push   $0x0
  pushl $57
80106d9a:	6a 39                	push   $0x39
  jmp alltraps
80106d9c:	e9 d9 f3 ff ff       	jmp    8010617a <alltraps>

80106da1 <vector58>:
.globl vector58
vector58:
  pushl $0
80106da1:	6a 00                	push   $0x0
  pushl $58
80106da3:	6a 3a                	push   $0x3a
  jmp alltraps
80106da5:	e9 d0 f3 ff ff       	jmp    8010617a <alltraps>

80106daa <vector59>:
.globl vector59
vector59:
  pushl $0
80106daa:	6a 00                	push   $0x0
  pushl $59
80106dac:	6a 3b                	push   $0x3b
  jmp alltraps
80106dae:	e9 c7 f3 ff ff       	jmp    8010617a <alltraps>

80106db3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $60
80106db5:	6a 3c                	push   $0x3c
  jmp alltraps
80106db7:	e9 be f3 ff ff       	jmp    8010617a <alltraps>

80106dbc <vector61>:
.globl vector61
vector61:
  pushl $0
80106dbc:	6a 00                	push   $0x0
  pushl $61
80106dbe:	6a 3d                	push   $0x3d
  jmp alltraps
80106dc0:	e9 b5 f3 ff ff       	jmp    8010617a <alltraps>

80106dc5 <vector62>:
.globl vector62
vector62:
  pushl $0
80106dc5:	6a 00                	push   $0x0
  pushl $62
80106dc7:	6a 3e                	push   $0x3e
  jmp alltraps
80106dc9:	e9 ac f3 ff ff       	jmp    8010617a <alltraps>

80106dce <vector63>:
.globl vector63
vector63:
  pushl $0
80106dce:	6a 00                	push   $0x0
  pushl $63
80106dd0:	6a 3f                	push   $0x3f
  jmp alltraps
80106dd2:	e9 a3 f3 ff ff       	jmp    8010617a <alltraps>

80106dd7 <vector64>:
.globl vector64
vector64:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $64
80106dd9:	6a 40                	push   $0x40
  jmp alltraps
80106ddb:	e9 9a f3 ff ff       	jmp    8010617a <alltraps>

80106de0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106de0:	6a 00                	push   $0x0
  pushl $65
80106de2:	6a 41                	push   $0x41
  jmp alltraps
80106de4:	e9 91 f3 ff ff       	jmp    8010617a <alltraps>

80106de9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106de9:	6a 00                	push   $0x0
  pushl $66
80106deb:	6a 42                	push   $0x42
  jmp alltraps
80106ded:	e9 88 f3 ff ff       	jmp    8010617a <alltraps>

80106df2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106df2:	6a 00                	push   $0x0
  pushl $67
80106df4:	6a 43                	push   $0x43
  jmp alltraps
80106df6:	e9 7f f3 ff ff       	jmp    8010617a <alltraps>

80106dfb <vector68>:
.globl vector68
vector68:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $68
80106dfd:	6a 44                	push   $0x44
  jmp alltraps
80106dff:	e9 76 f3 ff ff       	jmp    8010617a <alltraps>

80106e04 <vector69>:
.globl vector69
vector69:
  pushl $0
80106e04:	6a 00                	push   $0x0
  pushl $69
80106e06:	6a 45                	push   $0x45
  jmp alltraps
80106e08:	e9 6d f3 ff ff       	jmp    8010617a <alltraps>

80106e0d <vector70>:
.globl vector70
vector70:
  pushl $0
80106e0d:	6a 00                	push   $0x0
  pushl $70
80106e0f:	6a 46                	push   $0x46
  jmp alltraps
80106e11:	e9 64 f3 ff ff       	jmp    8010617a <alltraps>

80106e16 <vector71>:
.globl vector71
vector71:
  pushl $0
80106e16:	6a 00                	push   $0x0
  pushl $71
80106e18:	6a 47                	push   $0x47
  jmp alltraps
80106e1a:	e9 5b f3 ff ff       	jmp    8010617a <alltraps>

80106e1f <vector72>:
.globl vector72
vector72:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $72
80106e21:	6a 48                	push   $0x48
  jmp alltraps
80106e23:	e9 52 f3 ff ff       	jmp    8010617a <alltraps>

80106e28 <vector73>:
.globl vector73
vector73:
  pushl $0
80106e28:	6a 00                	push   $0x0
  pushl $73
80106e2a:	6a 49                	push   $0x49
  jmp alltraps
80106e2c:	e9 49 f3 ff ff       	jmp    8010617a <alltraps>

80106e31 <vector74>:
.globl vector74
vector74:
  pushl $0
80106e31:	6a 00                	push   $0x0
  pushl $74
80106e33:	6a 4a                	push   $0x4a
  jmp alltraps
80106e35:	e9 40 f3 ff ff       	jmp    8010617a <alltraps>

80106e3a <vector75>:
.globl vector75
vector75:
  pushl $0
80106e3a:	6a 00                	push   $0x0
  pushl $75
80106e3c:	6a 4b                	push   $0x4b
  jmp alltraps
80106e3e:	e9 37 f3 ff ff       	jmp    8010617a <alltraps>

80106e43 <vector76>:
.globl vector76
vector76:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $76
80106e45:	6a 4c                	push   $0x4c
  jmp alltraps
80106e47:	e9 2e f3 ff ff       	jmp    8010617a <alltraps>

80106e4c <vector77>:
.globl vector77
vector77:
  pushl $0
80106e4c:	6a 00                	push   $0x0
  pushl $77
80106e4e:	6a 4d                	push   $0x4d
  jmp alltraps
80106e50:	e9 25 f3 ff ff       	jmp    8010617a <alltraps>

80106e55 <vector78>:
.globl vector78
vector78:
  pushl $0
80106e55:	6a 00                	push   $0x0
  pushl $78
80106e57:	6a 4e                	push   $0x4e
  jmp alltraps
80106e59:	e9 1c f3 ff ff       	jmp    8010617a <alltraps>

80106e5e <vector79>:
.globl vector79
vector79:
  pushl $0
80106e5e:	6a 00                	push   $0x0
  pushl $79
80106e60:	6a 4f                	push   $0x4f
  jmp alltraps
80106e62:	e9 13 f3 ff ff       	jmp    8010617a <alltraps>

80106e67 <vector80>:
.globl vector80
vector80:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $80
80106e69:	6a 50                	push   $0x50
  jmp alltraps
80106e6b:	e9 0a f3 ff ff       	jmp    8010617a <alltraps>

80106e70 <vector81>:
.globl vector81
vector81:
  pushl $0
80106e70:	6a 00                	push   $0x0
  pushl $81
80106e72:	6a 51                	push   $0x51
  jmp alltraps
80106e74:	e9 01 f3 ff ff       	jmp    8010617a <alltraps>

80106e79 <vector82>:
.globl vector82
vector82:
  pushl $0
80106e79:	6a 00                	push   $0x0
  pushl $82
80106e7b:	6a 52                	push   $0x52
  jmp alltraps
80106e7d:	e9 f8 f2 ff ff       	jmp    8010617a <alltraps>

80106e82 <vector83>:
.globl vector83
vector83:
  pushl $0
80106e82:	6a 00                	push   $0x0
  pushl $83
80106e84:	6a 53                	push   $0x53
  jmp alltraps
80106e86:	e9 ef f2 ff ff       	jmp    8010617a <alltraps>

80106e8b <vector84>:
.globl vector84
vector84:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $84
80106e8d:	6a 54                	push   $0x54
  jmp alltraps
80106e8f:	e9 e6 f2 ff ff       	jmp    8010617a <alltraps>

80106e94 <vector85>:
.globl vector85
vector85:
  pushl $0
80106e94:	6a 00                	push   $0x0
  pushl $85
80106e96:	6a 55                	push   $0x55
  jmp alltraps
80106e98:	e9 dd f2 ff ff       	jmp    8010617a <alltraps>

80106e9d <vector86>:
.globl vector86
vector86:
  pushl $0
80106e9d:	6a 00                	push   $0x0
  pushl $86
80106e9f:	6a 56                	push   $0x56
  jmp alltraps
80106ea1:	e9 d4 f2 ff ff       	jmp    8010617a <alltraps>

80106ea6 <vector87>:
.globl vector87
vector87:
  pushl $0
80106ea6:	6a 00                	push   $0x0
  pushl $87
80106ea8:	6a 57                	push   $0x57
  jmp alltraps
80106eaa:	e9 cb f2 ff ff       	jmp    8010617a <alltraps>

80106eaf <vector88>:
.globl vector88
vector88:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $88
80106eb1:	6a 58                	push   $0x58
  jmp alltraps
80106eb3:	e9 c2 f2 ff ff       	jmp    8010617a <alltraps>

80106eb8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106eb8:	6a 00                	push   $0x0
  pushl $89
80106eba:	6a 59                	push   $0x59
  jmp alltraps
80106ebc:	e9 b9 f2 ff ff       	jmp    8010617a <alltraps>

80106ec1 <vector90>:
.globl vector90
vector90:
  pushl $0
80106ec1:	6a 00                	push   $0x0
  pushl $90
80106ec3:	6a 5a                	push   $0x5a
  jmp alltraps
80106ec5:	e9 b0 f2 ff ff       	jmp    8010617a <alltraps>

80106eca <vector91>:
.globl vector91
vector91:
  pushl $0
80106eca:	6a 00                	push   $0x0
  pushl $91
80106ecc:	6a 5b                	push   $0x5b
  jmp alltraps
80106ece:	e9 a7 f2 ff ff       	jmp    8010617a <alltraps>

80106ed3 <vector92>:
.globl vector92
vector92:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $92
80106ed5:	6a 5c                	push   $0x5c
  jmp alltraps
80106ed7:	e9 9e f2 ff ff       	jmp    8010617a <alltraps>

80106edc <vector93>:
.globl vector93
vector93:
  pushl $0
80106edc:	6a 00                	push   $0x0
  pushl $93
80106ede:	6a 5d                	push   $0x5d
  jmp alltraps
80106ee0:	e9 95 f2 ff ff       	jmp    8010617a <alltraps>

80106ee5 <vector94>:
.globl vector94
vector94:
  pushl $0
80106ee5:	6a 00                	push   $0x0
  pushl $94
80106ee7:	6a 5e                	push   $0x5e
  jmp alltraps
80106ee9:	e9 8c f2 ff ff       	jmp    8010617a <alltraps>

80106eee <vector95>:
.globl vector95
vector95:
  pushl $0
80106eee:	6a 00                	push   $0x0
  pushl $95
80106ef0:	6a 5f                	push   $0x5f
  jmp alltraps
80106ef2:	e9 83 f2 ff ff       	jmp    8010617a <alltraps>

80106ef7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $96
80106ef9:	6a 60                	push   $0x60
  jmp alltraps
80106efb:	e9 7a f2 ff ff       	jmp    8010617a <alltraps>

80106f00 <vector97>:
.globl vector97
vector97:
  pushl $0
80106f00:	6a 00                	push   $0x0
  pushl $97
80106f02:	6a 61                	push   $0x61
  jmp alltraps
80106f04:	e9 71 f2 ff ff       	jmp    8010617a <alltraps>

80106f09 <vector98>:
.globl vector98
vector98:
  pushl $0
80106f09:	6a 00                	push   $0x0
  pushl $98
80106f0b:	6a 62                	push   $0x62
  jmp alltraps
80106f0d:	e9 68 f2 ff ff       	jmp    8010617a <alltraps>

80106f12 <vector99>:
.globl vector99
vector99:
  pushl $0
80106f12:	6a 00                	push   $0x0
  pushl $99
80106f14:	6a 63                	push   $0x63
  jmp alltraps
80106f16:	e9 5f f2 ff ff       	jmp    8010617a <alltraps>

80106f1b <vector100>:
.globl vector100
vector100:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $100
80106f1d:	6a 64                	push   $0x64
  jmp alltraps
80106f1f:	e9 56 f2 ff ff       	jmp    8010617a <alltraps>

80106f24 <vector101>:
.globl vector101
vector101:
  pushl $0
80106f24:	6a 00                	push   $0x0
  pushl $101
80106f26:	6a 65                	push   $0x65
  jmp alltraps
80106f28:	e9 4d f2 ff ff       	jmp    8010617a <alltraps>

80106f2d <vector102>:
.globl vector102
vector102:
  pushl $0
80106f2d:	6a 00                	push   $0x0
  pushl $102
80106f2f:	6a 66                	push   $0x66
  jmp alltraps
80106f31:	e9 44 f2 ff ff       	jmp    8010617a <alltraps>

80106f36 <vector103>:
.globl vector103
vector103:
  pushl $0
80106f36:	6a 00                	push   $0x0
  pushl $103
80106f38:	6a 67                	push   $0x67
  jmp alltraps
80106f3a:	e9 3b f2 ff ff       	jmp    8010617a <alltraps>

80106f3f <vector104>:
.globl vector104
vector104:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $104
80106f41:	6a 68                	push   $0x68
  jmp alltraps
80106f43:	e9 32 f2 ff ff       	jmp    8010617a <alltraps>

80106f48 <vector105>:
.globl vector105
vector105:
  pushl $0
80106f48:	6a 00                	push   $0x0
  pushl $105
80106f4a:	6a 69                	push   $0x69
  jmp alltraps
80106f4c:	e9 29 f2 ff ff       	jmp    8010617a <alltraps>

80106f51 <vector106>:
.globl vector106
vector106:
  pushl $0
80106f51:	6a 00                	push   $0x0
  pushl $106
80106f53:	6a 6a                	push   $0x6a
  jmp alltraps
80106f55:	e9 20 f2 ff ff       	jmp    8010617a <alltraps>

80106f5a <vector107>:
.globl vector107
vector107:
  pushl $0
80106f5a:	6a 00                	push   $0x0
  pushl $107
80106f5c:	6a 6b                	push   $0x6b
  jmp alltraps
80106f5e:	e9 17 f2 ff ff       	jmp    8010617a <alltraps>

80106f63 <vector108>:
.globl vector108
vector108:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $108
80106f65:	6a 6c                	push   $0x6c
  jmp alltraps
80106f67:	e9 0e f2 ff ff       	jmp    8010617a <alltraps>

80106f6c <vector109>:
.globl vector109
vector109:
  pushl $0
80106f6c:	6a 00                	push   $0x0
  pushl $109
80106f6e:	6a 6d                	push   $0x6d
  jmp alltraps
80106f70:	e9 05 f2 ff ff       	jmp    8010617a <alltraps>

80106f75 <vector110>:
.globl vector110
vector110:
  pushl $0
80106f75:	6a 00                	push   $0x0
  pushl $110
80106f77:	6a 6e                	push   $0x6e
  jmp alltraps
80106f79:	e9 fc f1 ff ff       	jmp    8010617a <alltraps>

80106f7e <vector111>:
.globl vector111
vector111:
  pushl $0
80106f7e:	6a 00                	push   $0x0
  pushl $111
80106f80:	6a 6f                	push   $0x6f
  jmp alltraps
80106f82:	e9 f3 f1 ff ff       	jmp    8010617a <alltraps>

80106f87 <vector112>:
.globl vector112
vector112:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $112
80106f89:	6a 70                	push   $0x70
  jmp alltraps
80106f8b:	e9 ea f1 ff ff       	jmp    8010617a <alltraps>

80106f90 <vector113>:
.globl vector113
vector113:
  pushl $0
80106f90:	6a 00                	push   $0x0
  pushl $113
80106f92:	6a 71                	push   $0x71
  jmp alltraps
80106f94:	e9 e1 f1 ff ff       	jmp    8010617a <alltraps>

80106f99 <vector114>:
.globl vector114
vector114:
  pushl $0
80106f99:	6a 00                	push   $0x0
  pushl $114
80106f9b:	6a 72                	push   $0x72
  jmp alltraps
80106f9d:	e9 d8 f1 ff ff       	jmp    8010617a <alltraps>

80106fa2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106fa2:	6a 00                	push   $0x0
  pushl $115
80106fa4:	6a 73                	push   $0x73
  jmp alltraps
80106fa6:	e9 cf f1 ff ff       	jmp    8010617a <alltraps>

80106fab <vector116>:
.globl vector116
vector116:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $116
80106fad:	6a 74                	push   $0x74
  jmp alltraps
80106faf:	e9 c6 f1 ff ff       	jmp    8010617a <alltraps>

80106fb4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106fb4:	6a 00                	push   $0x0
  pushl $117
80106fb6:	6a 75                	push   $0x75
  jmp alltraps
80106fb8:	e9 bd f1 ff ff       	jmp    8010617a <alltraps>

80106fbd <vector118>:
.globl vector118
vector118:
  pushl $0
80106fbd:	6a 00                	push   $0x0
  pushl $118
80106fbf:	6a 76                	push   $0x76
  jmp alltraps
80106fc1:	e9 b4 f1 ff ff       	jmp    8010617a <alltraps>

80106fc6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106fc6:	6a 00                	push   $0x0
  pushl $119
80106fc8:	6a 77                	push   $0x77
  jmp alltraps
80106fca:	e9 ab f1 ff ff       	jmp    8010617a <alltraps>

80106fcf <vector120>:
.globl vector120
vector120:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $120
80106fd1:	6a 78                	push   $0x78
  jmp alltraps
80106fd3:	e9 a2 f1 ff ff       	jmp    8010617a <alltraps>

80106fd8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106fd8:	6a 00                	push   $0x0
  pushl $121
80106fda:	6a 79                	push   $0x79
  jmp alltraps
80106fdc:	e9 99 f1 ff ff       	jmp    8010617a <alltraps>

80106fe1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106fe1:	6a 00                	push   $0x0
  pushl $122
80106fe3:	6a 7a                	push   $0x7a
  jmp alltraps
80106fe5:	e9 90 f1 ff ff       	jmp    8010617a <alltraps>

80106fea <vector123>:
.globl vector123
vector123:
  pushl $0
80106fea:	6a 00                	push   $0x0
  pushl $123
80106fec:	6a 7b                	push   $0x7b
  jmp alltraps
80106fee:	e9 87 f1 ff ff       	jmp    8010617a <alltraps>

80106ff3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $124
80106ff5:	6a 7c                	push   $0x7c
  jmp alltraps
80106ff7:	e9 7e f1 ff ff       	jmp    8010617a <alltraps>

80106ffc <vector125>:
.globl vector125
vector125:
  pushl $0
80106ffc:	6a 00                	push   $0x0
  pushl $125
80106ffe:	6a 7d                	push   $0x7d
  jmp alltraps
80107000:	e9 75 f1 ff ff       	jmp    8010617a <alltraps>

80107005 <vector126>:
.globl vector126
vector126:
  pushl $0
80107005:	6a 00                	push   $0x0
  pushl $126
80107007:	6a 7e                	push   $0x7e
  jmp alltraps
80107009:	e9 6c f1 ff ff       	jmp    8010617a <alltraps>

8010700e <vector127>:
.globl vector127
vector127:
  pushl $0
8010700e:	6a 00                	push   $0x0
  pushl $127
80107010:	6a 7f                	push   $0x7f
  jmp alltraps
80107012:	e9 63 f1 ff ff       	jmp    8010617a <alltraps>

80107017 <vector128>:
.globl vector128
vector128:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $128
80107019:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010701e:	e9 57 f1 ff ff       	jmp    8010617a <alltraps>

80107023 <vector129>:
.globl vector129
vector129:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $129
80107025:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010702a:	e9 4b f1 ff ff       	jmp    8010617a <alltraps>

8010702f <vector130>:
.globl vector130
vector130:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $130
80107031:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107036:	e9 3f f1 ff ff       	jmp    8010617a <alltraps>

8010703b <vector131>:
.globl vector131
vector131:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $131
8010703d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107042:	e9 33 f1 ff ff       	jmp    8010617a <alltraps>

80107047 <vector132>:
.globl vector132
vector132:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $132
80107049:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010704e:	e9 27 f1 ff ff       	jmp    8010617a <alltraps>

80107053 <vector133>:
.globl vector133
vector133:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $133
80107055:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010705a:	e9 1b f1 ff ff       	jmp    8010617a <alltraps>

8010705f <vector134>:
.globl vector134
vector134:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $134
80107061:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107066:	e9 0f f1 ff ff       	jmp    8010617a <alltraps>

8010706b <vector135>:
.globl vector135
vector135:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $135
8010706d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107072:	e9 03 f1 ff ff       	jmp    8010617a <alltraps>

80107077 <vector136>:
.globl vector136
vector136:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $136
80107079:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010707e:	e9 f7 f0 ff ff       	jmp    8010617a <alltraps>

80107083 <vector137>:
.globl vector137
vector137:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $137
80107085:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010708a:	e9 eb f0 ff ff       	jmp    8010617a <alltraps>

8010708f <vector138>:
.globl vector138
vector138:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $138
80107091:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107096:	e9 df f0 ff ff       	jmp    8010617a <alltraps>

8010709b <vector139>:
.globl vector139
vector139:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $139
8010709d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801070a2:	e9 d3 f0 ff ff       	jmp    8010617a <alltraps>

801070a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $140
801070a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801070ae:	e9 c7 f0 ff ff       	jmp    8010617a <alltraps>

801070b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $141
801070b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801070ba:	e9 bb f0 ff ff       	jmp    8010617a <alltraps>

801070bf <vector142>:
.globl vector142
vector142:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $142
801070c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801070c6:	e9 af f0 ff ff       	jmp    8010617a <alltraps>

801070cb <vector143>:
.globl vector143
vector143:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $143
801070cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801070d2:	e9 a3 f0 ff ff       	jmp    8010617a <alltraps>

801070d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $144
801070d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801070de:	e9 97 f0 ff ff       	jmp    8010617a <alltraps>

801070e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $145
801070e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801070ea:	e9 8b f0 ff ff       	jmp    8010617a <alltraps>

801070ef <vector146>:
.globl vector146
vector146:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $146
801070f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801070f6:	e9 7f f0 ff ff       	jmp    8010617a <alltraps>

801070fb <vector147>:
.globl vector147
vector147:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $147
801070fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107102:	e9 73 f0 ff ff       	jmp    8010617a <alltraps>

80107107 <vector148>:
.globl vector148
vector148:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $148
80107109:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010710e:	e9 67 f0 ff ff       	jmp    8010617a <alltraps>

80107113 <vector149>:
.globl vector149
vector149:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $149
80107115:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010711a:	e9 5b f0 ff ff       	jmp    8010617a <alltraps>

8010711f <vector150>:
.globl vector150
vector150:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $150
80107121:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107126:	e9 4f f0 ff ff       	jmp    8010617a <alltraps>

8010712b <vector151>:
.globl vector151
vector151:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $151
8010712d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107132:	e9 43 f0 ff ff       	jmp    8010617a <alltraps>

80107137 <vector152>:
.globl vector152
vector152:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $152
80107139:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010713e:	e9 37 f0 ff ff       	jmp    8010617a <alltraps>

80107143 <vector153>:
.globl vector153
vector153:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $153
80107145:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010714a:	e9 2b f0 ff ff       	jmp    8010617a <alltraps>

8010714f <vector154>:
.globl vector154
vector154:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $154
80107151:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107156:	e9 1f f0 ff ff       	jmp    8010617a <alltraps>

8010715b <vector155>:
.globl vector155
vector155:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $155
8010715d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107162:	e9 13 f0 ff ff       	jmp    8010617a <alltraps>

80107167 <vector156>:
.globl vector156
vector156:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $156
80107169:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010716e:	e9 07 f0 ff ff       	jmp    8010617a <alltraps>

80107173 <vector157>:
.globl vector157
vector157:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $157
80107175:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010717a:	e9 fb ef ff ff       	jmp    8010617a <alltraps>

8010717f <vector158>:
.globl vector158
vector158:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $158
80107181:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107186:	e9 ef ef ff ff       	jmp    8010617a <alltraps>

8010718b <vector159>:
.globl vector159
vector159:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $159
8010718d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107192:	e9 e3 ef ff ff       	jmp    8010617a <alltraps>

80107197 <vector160>:
.globl vector160
vector160:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $160
80107199:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010719e:	e9 d7 ef ff ff       	jmp    8010617a <alltraps>

801071a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $161
801071a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801071aa:	e9 cb ef ff ff       	jmp    8010617a <alltraps>

801071af <vector162>:
.globl vector162
vector162:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $162
801071b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801071b6:	e9 bf ef ff ff       	jmp    8010617a <alltraps>

801071bb <vector163>:
.globl vector163
vector163:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $163
801071bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801071c2:	e9 b3 ef ff ff       	jmp    8010617a <alltraps>

801071c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $164
801071c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801071ce:	e9 a7 ef ff ff       	jmp    8010617a <alltraps>

801071d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $165
801071d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801071da:	e9 9b ef ff ff       	jmp    8010617a <alltraps>

801071df <vector166>:
.globl vector166
vector166:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $166
801071e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801071e6:	e9 8f ef ff ff       	jmp    8010617a <alltraps>

801071eb <vector167>:
.globl vector167
vector167:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $167
801071ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801071f2:	e9 83 ef ff ff       	jmp    8010617a <alltraps>

801071f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $168
801071f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801071fe:	e9 77 ef ff ff       	jmp    8010617a <alltraps>

80107203 <vector169>:
.globl vector169
vector169:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $169
80107205:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010720a:	e9 6b ef ff ff       	jmp    8010617a <alltraps>

8010720f <vector170>:
.globl vector170
vector170:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $170
80107211:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107216:	e9 5f ef ff ff       	jmp    8010617a <alltraps>

8010721b <vector171>:
.globl vector171
vector171:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $171
8010721d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107222:	e9 53 ef ff ff       	jmp    8010617a <alltraps>

80107227 <vector172>:
.globl vector172
vector172:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $172
80107229:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010722e:	e9 47 ef ff ff       	jmp    8010617a <alltraps>

80107233 <vector173>:
.globl vector173
vector173:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $173
80107235:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010723a:	e9 3b ef ff ff       	jmp    8010617a <alltraps>

8010723f <vector174>:
.globl vector174
vector174:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $174
80107241:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107246:	e9 2f ef ff ff       	jmp    8010617a <alltraps>

8010724b <vector175>:
.globl vector175
vector175:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $175
8010724d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107252:	e9 23 ef ff ff       	jmp    8010617a <alltraps>

80107257 <vector176>:
.globl vector176
vector176:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $176
80107259:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010725e:	e9 17 ef ff ff       	jmp    8010617a <alltraps>

80107263 <vector177>:
.globl vector177
vector177:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $177
80107265:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010726a:	e9 0b ef ff ff       	jmp    8010617a <alltraps>

8010726f <vector178>:
.globl vector178
vector178:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $178
80107271:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107276:	e9 ff ee ff ff       	jmp    8010617a <alltraps>

8010727b <vector179>:
.globl vector179
vector179:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $179
8010727d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107282:	e9 f3 ee ff ff       	jmp    8010617a <alltraps>

80107287 <vector180>:
.globl vector180
vector180:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $180
80107289:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010728e:	e9 e7 ee ff ff       	jmp    8010617a <alltraps>

80107293 <vector181>:
.globl vector181
vector181:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $181
80107295:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010729a:	e9 db ee ff ff       	jmp    8010617a <alltraps>

8010729f <vector182>:
.globl vector182
vector182:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $182
801072a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801072a6:	e9 cf ee ff ff       	jmp    8010617a <alltraps>

801072ab <vector183>:
.globl vector183
vector183:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $183
801072ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801072b2:	e9 c3 ee ff ff       	jmp    8010617a <alltraps>

801072b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $184
801072b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801072be:	e9 b7 ee ff ff       	jmp    8010617a <alltraps>

801072c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $185
801072c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801072ca:	e9 ab ee ff ff       	jmp    8010617a <alltraps>

801072cf <vector186>:
.globl vector186
vector186:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $186
801072d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801072d6:	e9 9f ee ff ff       	jmp    8010617a <alltraps>

801072db <vector187>:
.globl vector187
vector187:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $187
801072dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801072e2:	e9 93 ee ff ff       	jmp    8010617a <alltraps>

801072e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $188
801072e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801072ee:	e9 87 ee ff ff       	jmp    8010617a <alltraps>

801072f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $189
801072f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801072fa:	e9 7b ee ff ff       	jmp    8010617a <alltraps>

801072ff <vector190>:
.globl vector190
vector190:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $190
80107301:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107306:	e9 6f ee ff ff       	jmp    8010617a <alltraps>

8010730b <vector191>:
.globl vector191
vector191:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $191
8010730d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107312:	e9 63 ee ff ff       	jmp    8010617a <alltraps>

80107317 <vector192>:
.globl vector192
vector192:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $192
80107319:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010731e:	e9 57 ee ff ff       	jmp    8010617a <alltraps>

80107323 <vector193>:
.globl vector193
vector193:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $193
80107325:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010732a:	e9 4b ee ff ff       	jmp    8010617a <alltraps>

8010732f <vector194>:
.globl vector194
vector194:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $194
80107331:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107336:	e9 3f ee ff ff       	jmp    8010617a <alltraps>

8010733b <vector195>:
.globl vector195
vector195:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $195
8010733d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107342:	e9 33 ee ff ff       	jmp    8010617a <alltraps>

80107347 <vector196>:
.globl vector196
vector196:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $196
80107349:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010734e:	e9 27 ee ff ff       	jmp    8010617a <alltraps>

80107353 <vector197>:
.globl vector197
vector197:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $197
80107355:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010735a:	e9 1b ee ff ff       	jmp    8010617a <alltraps>

8010735f <vector198>:
.globl vector198
vector198:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $198
80107361:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107366:	e9 0f ee ff ff       	jmp    8010617a <alltraps>

8010736b <vector199>:
.globl vector199
vector199:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $199
8010736d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107372:	e9 03 ee ff ff       	jmp    8010617a <alltraps>

80107377 <vector200>:
.globl vector200
vector200:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $200
80107379:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010737e:	e9 f7 ed ff ff       	jmp    8010617a <alltraps>

80107383 <vector201>:
.globl vector201
vector201:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $201
80107385:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010738a:	e9 eb ed ff ff       	jmp    8010617a <alltraps>

8010738f <vector202>:
.globl vector202
vector202:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $202
80107391:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107396:	e9 df ed ff ff       	jmp    8010617a <alltraps>

8010739b <vector203>:
.globl vector203
vector203:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $203
8010739d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801073a2:	e9 d3 ed ff ff       	jmp    8010617a <alltraps>

801073a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $204
801073a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801073ae:	e9 c7 ed ff ff       	jmp    8010617a <alltraps>

801073b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $205
801073b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801073ba:	e9 bb ed ff ff       	jmp    8010617a <alltraps>

801073bf <vector206>:
.globl vector206
vector206:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $206
801073c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801073c6:	e9 af ed ff ff       	jmp    8010617a <alltraps>

801073cb <vector207>:
.globl vector207
vector207:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $207
801073cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801073d2:	e9 a3 ed ff ff       	jmp    8010617a <alltraps>

801073d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $208
801073d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801073de:	e9 97 ed ff ff       	jmp    8010617a <alltraps>

801073e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $209
801073e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801073ea:	e9 8b ed ff ff       	jmp    8010617a <alltraps>

801073ef <vector210>:
.globl vector210
vector210:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $210
801073f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801073f6:	e9 7f ed ff ff       	jmp    8010617a <alltraps>

801073fb <vector211>:
.globl vector211
vector211:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $211
801073fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107402:	e9 73 ed ff ff       	jmp    8010617a <alltraps>

80107407 <vector212>:
.globl vector212
vector212:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $212
80107409:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010740e:	e9 67 ed ff ff       	jmp    8010617a <alltraps>

80107413 <vector213>:
.globl vector213
vector213:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $213
80107415:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010741a:	e9 5b ed ff ff       	jmp    8010617a <alltraps>

8010741f <vector214>:
.globl vector214
vector214:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $214
80107421:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107426:	e9 4f ed ff ff       	jmp    8010617a <alltraps>

8010742b <vector215>:
.globl vector215
vector215:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $215
8010742d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107432:	e9 43 ed ff ff       	jmp    8010617a <alltraps>

80107437 <vector216>:
.globl vector216
vector216:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $216
80107439:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010743e:	e9 37 ed ff ff       	jmp    8010617a <alltraps>

80107443 <vector217>:
.globl vector217
vector217:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $217
80107445:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010744a:	e9 2b ed ff ff       	jmp    8010617a <alltraps>

8010744f <vector218>:
.globl vector218
vector218:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $218
80107451:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107456:	e9 1f ed ff ff       	jmp    8010617a <alltraps>

8010745b <vector219>:
.globl vector219
vector219:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $219
8010745d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107462:	e9 13 ed ff ff       	jmp    8010617a <alltraps>

80107467 <vector220>:
.globl vector220
vector220:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $220
80107469:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010746e:	e9 07 ed ff ff       	jmp    8010617a <alltraps>

80107473 <vector221>:
.globl vector221
vector221:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $221
80107475:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010747a:	e9 fb ec ff ff       	jmp    8010617a <alltraps>

8010747f <vector222>:
.globl vector222
vector222:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $222
80107481:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107486:	e9 ef ec ff ff       	jmp    8010617a <alltraps>

8010748b <vector223>:
.globl vector223
vector223:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $223
8010748d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107492:	e9 e3 ec ff ff       	jmp    8010617a <alltraps>

80107497 <vector224>:
.globl vector224
vector224:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $224
80107499:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010749e:	e9 d7 ec ff ff       	jmp    8010617a <alltraps>

801074a3 <vector225>:
.globl vector225
vector225:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $225
801074a5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801074aa:	e9 cb ec ff ff       	jmp    8010617a <alltraps>

801074af <vector226>:
.globl vector226
vector226:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $226
801074b1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801074b6:	e9 bf ec ff ff       	jmp    8010617a <alltraps>

801074bb <vector227>:
.globl vector227
vector227:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $227
801074bd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801074c2:	e9 b3 ec ff ff       	jmp    8010617a <alltraps>

801074c7 <vector228>:
.globl vector228
vector228:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $228
801074c9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801074ce:	e9 a7 ec ff ff       	jmp    8010617a <alltraps>

801074d3 <vector229>:
.globl vector229
vector229:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $229
801074d5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801074da:	e9 9b ec ff ff       	jmp    8010617a <alltraps>

801074df <vector230>:
.globl vector230
vector230:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $230
801074e1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801074e6:	e9 8f ec ff ff       	jmp    8010617a <alltraps>

801074eb <vector231>:
.globl vector231
vector231:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $231
801074ed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801074f2:	e9 83 ec ff ff       	jmp    8010617a <alltraps>

801074f7 <vector232>:
.globl vector232
vector232:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $232
801074f9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801074fe:	e9 77 ec ff ff       	jmp    8010617a <alltraps>

80107503 <vector233>:
.globl vector233
vector233:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $233
80107505:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010750a:	e9 6b ec ff ff       	jmp    8010617a <alltraps>

8010750f <vector234>:
.globl vector234
vector234:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $234
80107511:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107516:	e9 5f ec ff ff       	jmp    8010617a <alltraps>

8010751b <vector235>:
.globl vector235
vector235:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $235
8010751d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107522:	e9 53 ec ff ff       	jmp    8010617a <alltraps>

80107527 <vector236>:
.globl vector236
vector236:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $236
80107529:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010752e:	e9 47 ec ff ff       	jmp    8010617a <alltraps>

80107533 <vector237>:
.globl vector237
vector237:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $237
80107535:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010753a:	e9 3b ec ff ff       	jmp    8010617a <alltraps>

8010753f <vector238>:
.globl vector238
vector238:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $238
80107541:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107546:	e9 2f ec ff ff       	jmp    8010617a <alltraps>

8010754b <vector239>:
.globl vector239
vector239:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $239
8010754d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107552:	e9 23 ec ff ff       	jmp    8010617a <alltraps>

80107557 <vector240>:
.globl vector240
vector240:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $240
80107559:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010755e:	e9 17 ec ff ff       	jmp    8010617a <alltraps>

80107563 <vector241>:
.globl vector241
vector241:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $241
80107565:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010756a:	e9 0b ec ff ff       	jmp    8010617a <alltraps>

8010756f <vector242>:
.globl vector242
vector242:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $242
80107571:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107576:	e9 ff eb ff ff       	jmp    8010617a <alltraps>

8010757b <vector243>:
.globl vector243
vector243:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $243
8010757d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107582:	e9 f3 eb ff ff       	jmp    8010617a <alltraps>

80107587 <vector244>:
.globl vector244
vector244:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $244
80107589:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010758e:	e9 e7 eb ff ff       	jmp    8010617a <alltraps>

80107593 <vector245>:
.globl vector245
vector245:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $245
80107595:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010759a:	e9 db eb ff ff       	jmp    8010617a <alltraps>

8010759f <vector246>:
.globl vector246
vector246:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $246
801075a1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801075a6:	e9 cf eb ff ff       	jmp    8010617a <alltraps>

801075ab <vector247>:
.globl vector247
vector247:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $247
801075ad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801075b2:	e9 c3 eb ff ff       	jmp    8010617a <alltraps>

801075b7 <vector248>:
.globl vector248
vector248:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $248
801075b9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801075be:	e9 b7 eb ff ff       	jmp    8010617a <alltraps>

801075c3 <vector249>:
.globl vector249
vector249:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $249
801075c5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801075ca:	e9 ab eb ff ff       	jmp    8010617a <alltraps>

801075cf <vector250>:
.globl vector250
vector250:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $250
801075d1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801075d6:	e9 9f eb ff ff       	jmp    8010617a <alltraps>

801075db <vector251>:
.globl vector251
vector251:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $251
801075dd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801075e2:	e9 93 eb ff ff       	jmp    8010617a <alltraps>

801075e7 <vector252>:
.globl vector252
vector252:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $252
801075e9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801075ee:	e9 87 eb ff ff       	jmp    8010617a <alltraps>

801075f3 <vector253>:
.globl vector253
vector253:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $253
801075f5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801075fa:	e9 7b eb ff ff       	jmp    8010617a <alltraps>

801075ff <vector254>:
.globl vector254
vector254:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $254
80107601:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107606:	e9 6f eb ff ff       	jmp    8010617a <alltraps>

8010760b <vector255>:
.globl vector255
vector255:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $255
8010760d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107612:	e9 63 eb ff ff       	jmp    8010617a <alltraps>
80107617:	66 90                	xchg   %ax,%ax
80107619:	66 90                	xchg   %ax,%ax
8010761b:	66 90                	xchg   %ax,%ax
8010761d:	66 90                	xchg   %ax,%ax
8010761f:	90                   	nop

80107620 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	57                   	push   %edi
80107624:	56                   	push   %esi
80107625:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107626:	89 d3                	mov    %edx,%ebx
{
80107628:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010762a:	c1 eb 16             	shr    $0x16,%ebx
8010762d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107630:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107633:	8b 06                	mov    (%esi),%eax
80107635:	a8 01                	test   $0x1,%al
80107637:	74 27                	je     80107660 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107639:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010763e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107644:	c1 ef 0a             	shr    $0xa,%edi
}
80107647:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010764a:	89 fa                	mov    %edi,%edx
8010764c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107652:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107655:	5b                   	pop    %ebx
80107656:	5e                   	pop    %esi
80107657:	5f                   	pop    %edi
80107658:	5d                   	pop    %ebp
80107659:	c3                   	ret    
8010765a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107660:	85 c9                	test   %ecx,%ecx
80107662:	74 2c                	je     80107690 <walkpgdir+0x70>
80107664:	e8 57 ae ff ff       	call   801024c0 <kalloc>
80107669:	85 c0                	test   %eax,%eax
8010766b:	89 c3                	mov    %eax,%ebx
8010766d:	74 21                	je     80107690 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010766f:	83 ec 04             	sub    $0x4,%esp
80107672:	68 00 10 00 00       	push   $0x1000
80107677:	6a 00                	push   $0x0
80107679:	50                   	push   %eax
8010767a:	e8 11 d8 ff ff       	call   80104e90 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010767f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107685:	83 c4 10             	add    $0x10,%esp
80107688:	83 c8 07             	or     $0x7,%eax
8010768b:	89 06                	mov    %eax,(%esi)
8010768d:	eb b5                	jmp    80107644 <walkpgdir+0x24>
8010768f:	90                   	nop
}
80107690:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107693:	31 c0                	xor    %eax,%eax
}
80107695:	5b                   	pop    %ebx
80107696:	5e                   	pop    %esi
80107697:	5f                   	pop    %edi
80107698:	5d                   	pop    %ebp
80107699:	c3                   	ret    
8010769a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076a0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801076a0:	55                   	push   %ebp
801076a1:	89 e5                	mov    %esp,%ebp
801076a3:	57                   	push   %edi
801076a4:	56                   	push   %esi
801076a5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801076a6:	89 d3                	mov    %edx,%ebx
801076a8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801076ae:	83 ec 1c             	sub    $0x1c,%esp
801076b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801076b4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801076b8:	8b 7d 08             	mov    0x8(%ebp),%edi
801076bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801076c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801076c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801076c6:	29 df                	sub    %ebx,%edi
801076c8:	83 c8 01             	or     $0x1,%eax
801076cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801076ce:	eb 15                	jmp    801076e5 <mappages+0x45>
    if(*pte & PTE_P)
801076d0:	f6 00 01             	testb  $0x1,(%eax)
801076d3:	75 45                	jne    8010771a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801076d5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801076d8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801076db:	89 30                	mov    %esi,(%eax)
    if(a == last)
801076dd:	74 31                	je     80107710 <mappages+0x70>
      break;
    a += PGSIZE;
801076df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801076e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076e8:	b9 01 00 00 00       	mov    $0x1,%ecx
801076ed:	89 da                	mov    %ebx,%edx
801076ef:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801076f2:	e8 29 ff ff ff       	call   80107620 <walkpgdir>
801076f7:	85 c0                	test   %eax,%eax
801076f9:	75 d5                	jne    801076d0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801076fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107703:	5b                   	pop    %ebx
80107704:	5e                   	pop    %esi
80107705:	5f                   	pop    %edi
80107706:	5d                   	pop    %ebp
80107707:	c3                   	ret    
80107708:	90                   	nop
80107709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107710:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107713:	31 c0                	xor    %eax,%eax
}
80107715:	5b                   	pop    %ebx
80107716:	5e                   	pop    %esi
80107717:	5f                   	pop    %edi
80107718:	5d                   	pop    %ebp
80107719:	c3                   	ret    
      panic("remap");
8010771a:	83 ec 0c             	sub    $0xc,%esp
8010771d:	68 e4 88 10 80       	push   $0x801088e4
80107722:	e8 69 8c ff ff       	call   80100390 <panic>
80107727:	89 f6                	mov    %esi,%esi
80107729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107730 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107730:	55                   	push   %ebp
80107731:	89 e5                	mov    %esp,%ebp
80107733:	57                   	push   %edi
80107734:	56                   	push   %esi
80107735:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107736:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010773c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010773e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107744:	83 ec 1c             	sub    $0x1c,%esp
80107747:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010774a:	39 d3                	cmp    %edx,%ebx
8010774c:	73 66                	jae    801077b4 <deallocuvm.part.0+0x84>
8010774e:	89 d6                	mov    %edx,%esi
80107750:	eb 3d                	jmp    8010778f <deallocuvm.part.0+0x5f>
80107752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107758:	8b 10                	mov    (%eax),%edx
8010775a:	f6 c2 01             	test   $0x1,%dl
8010775d:	74 26                	je     80107785 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010775f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107765:	74 58                	je     801077bf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107767:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010776a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107770:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107773:	52                   	push   %edx
80107774:	e8 97 ab ff ff       	call   80102310 <kfree>
      *pte = 0;
80107779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010777c:	83 c4 10             	add    $0x10,%esp
8010777f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107785:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010778b:	39 f3                	cmp    %esi,%ebx
8010778d:	73 25                	jae    801077b4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010778f:	31 c9                	xor    %ecx,%ecx
80107791:	89 da                	mov    %ebx,%edx
80107793:	89 f8                	mov    %edi,%eax
80107795:	e8 86 fe ff ff       	call   80107620 <walkpgdir>
    if(!pte)
8010779a:	85 c0                	test   %eax,%eax
8010779c:	75 ba                	jne    80107758 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010779e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801077a4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801077aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801077b0:	39 f3                	cmp    %esi,%ebx
801077b2:	72 db                	jb     8010778f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801077b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077ba:	5b                   	pop    %ebx
801077bb:	5e                   	pop    %esi
801077bc:	5f                   	pop    %edi
801077bd:	5d                   	pop    %ebp
801077be:	c3                   	ret    
        panic("kfree");
801077bf:	83 ec 0c             	sub    $0xc,%esp
801077c2:	68 c6 81 10 80       	push   $0x801081c6
801077c7:	e8 c4 8b ff ff       	call   80100390 <panic>
801077cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801077d0 <seginit>:
{
801077d0:	55                   	push   %ebp
801077d1:	89 e5                	mov    %esp,%ebp
801077d3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801077d6:	e8 f5 c0 ff ff       	call   801038d0 <cpuid>
801077db:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801077e1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801077e6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801077ea:	c7 80 98 38 11 80 ff 	movl   $0xffff,-0x7feec768(%eax)
801077f1:	ff 00 00 
801077f4:	c7 80 9c 38 11 80 00 	movl   $0xcf9a00,-0x7feec764(%eax)
801077fb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801077fe:	c7 80 a0 38 11 80 ff 	movl   $0xffff,-0x7feec760(%eax)
80107805:	ff 00 00 
80107808:	c7 80 a4 38 11 80 00 	movl   $0xcf9200,-0x7feec75c(%eax)
8010780f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107812:	c7 80 a8 38 11 80 ff 	movl   $0xffff,-0x7feec758(%eax)
80107819:	ff 00 00 
8010781c:	c7 80 ac 38 11 80 00 	movl   $0xcffa00,-0x7feec754(%eax)
80107823:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107826:	c7 80 b0 38 11 80 ff 	movl   $0xffff,-0x7feec750(%eax)
8010782d:	ff 00 00 
80107830:	c7 80 b4 38 11 80 00 	movl   $0xcff200,-0x7feec74c(%eax)
80107837:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010783a:	05 90 38 11 80       	add    $0x80113890,%eax
  pd[1] = (uint)p;
8010783f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107843:	c1 e8 10             	shr    $0x10,%eax
80107846:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010784a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010784d:	0f 01 10             	lgdtl  (%eax)
}
80107850:	c9                   	leave  
80107851:	c3                   	ret    
80107852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107860 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107860:	a1 84 c9 11 80       	mov    0x8011c984,%eax
{
80107865:	55                   	push   %ebp
80107866:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107868:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010786d:	0f 22 d8             	mov    %eax,%cr3
}
80107870:	5d                   	pop    %ebp
80107871:	c3                   	ret    
80107872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107880 <switchuvm>:
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
80107885:	53                   	push   %ebx
80107886:	83 ec 1c             	sub    $0x1c,%esp
80107889:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010788c:	85 db                	test   %ebx,%ebx
8010788e:	0f 84 cb 00 00 00    	je     8010795f <switchuvm+0xdf>
  if(p->kstack == 0)
80107894:	8b 43 08             	mov    0x8(%ebx),%eax
80107897:	85 c0                	test   %eax,%eax
80107899:	0f 84 da 00 00 00    	je     80107979 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010789f:	8b 43 04             	mov    0x4(%ebx),%eax
801078a2:	85 c0                	test   %eax,%eax
801078a4:	0f 84 c2 00 00 00    	je     8010796c <switchuvm+0xec>
  pushcli();
801078aa:	e8 01 d4 ff ff       	call   80104cb0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801078af:	e8 9c bf ff ff       	call   80103850 <mycpu>
801078b4:	89 c6                	mov    %eax,%esi
801078b6:	e8 95 bf ff ff       	call   80103850 <mycpu>
801078bb:	89 c7                	mov    %eax,%edi
801078bd:	e8 8e bf ff ff       	call   80103850 <mycpu>
801078c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801078c5:	83 c7 08             	add    $0x8,%edi
801078c8:	e8 83 bf ff ff       	call   80103850 <mycpu>
801078cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801078d0:	83 c0 08             	add    $0x8,%eax
801078d3:	ba 67 00 00 00       	mov    $0x67,%edx
801078d8:	c1 e8 18             	shr    $0x18,%eax
801078db:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801078e2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801078e9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801078ef:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801078f4:	83 c1 08             	add    $0x8,%ecx
801078f7:	c1 e9 10             	shr    $0x10,%ecx
801078fa:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107900:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107905:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010790c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107911:	e8 3a bf ff ff       	call   80103850 <mycpu>
80107916:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010791d:	e8 2e bf ff ff       	call   80103850 <mycpu>
80107922:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107926:	8b 73 08             	mov    0x8(%ebx),%esi
80107929:	e8 22 bf ff ff       	call   80103850 <mycpu>
8010792e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107934:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107937:	e8 14 bf ff ff       	call   80103850 <mycpu>
8010793c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107940:	b8 28 00 00 00       	mov    $0x28,%eax
80107945:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107948:	8b 43 04             	mov    0x4(%ebx),%eax
8010794b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107950:	0f 22 d8             	mov    %eax,%cr3
}
80107953:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107956:	5b                   	pop    %ebx
80107957:	5e                   	pop    %esi
80107958:	5f                   	pop    %edi
80107959:	5d                   	pop    %ebp
  popcli();
8010795a:	e9 91 d3 ff ff       	jmp    80104cf0 <popcli>
    panic("switchuvm: no process");
8010795f:	83 ec 0c             	sub    $0xc,%esp
80107962:	68 ea 88 10 80       	push   $0x801088ea
80107967:	e8 24 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010796c:	83 ec 0c             	sub    $0xc,%esp
8010796f:	68 15 89 10 80       	push   $0x80108915
80107974:	e8 17 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107979:	83 ec 0c             	sub    $0xc,%esp
8010797c:	68 00 89 10 80       	push   $0x80108900
80107981:	e8 0a 8a ff ff       	call   80100390 <panic>
80107986:	8d 76 00             	lea    0x0(%esi),%esi
80107989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107990 <inituvm>:
{
80107990:	55                   	push   %ebp
80107991:	89 e5                	mov    %esp,%ebp
80107993:	57                   	push   %edi
80107994:	56                   	push   %esi
80107995:	53                   	push   %ebx
80107996:	83 ec 1c             	sub    $0x1c,%esp
80107999:	8b 75 10             	mov    0x10(%ebp),%esi
8010799c:	8b 45 08             	mov    0x8(%ebp),%eax
8010799f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801079a2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801079a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801079ab:	77 49                	ja     801079f6 <inituvm+0x66>
  mem = kalloc();
801079ad:	e8 0e ab ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
801079b2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801079b5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801079b7:	68 00 10 00 00       	push   $0x1000
801079bc:	6a 00                	push   $0x0
801079be:	50                   	push   %eax
801079bf:	e8 cc d4 ff ff       	call   80104e90 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801079c4:	58                   	pop    %eax
801079c5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801079cb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801079d0:	5a                   	pop    %edx
801079d1:	6a 06                	push   $0x6
801079d3:	50                   	push   %eax
801079d4:	31 d2                	xor    %edx,%edx
801079d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079d9:	e8 c2 fc ff ff       	call   801076a0 <mappages>
  memmove(mem, init, sz);
801079de:	89 75 10             	mov    %esi,0x10(%ebp)
801079e1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801079e4:	83 c4 10             	add    $0x10,%esp
801079e7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801079ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079ed:	5b                   	pop    %ebx
801079ee:	5e                   	pop    %esi
801079ef:	5f                   	pop    %edi
801079f0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801079f1:	e9 4a d5 ff ff       	jmp    80104f40 <memmove>
    panic("inituvm: more than a page");
801079f6:	83 ec 0c             	sub    $0xc,%esp
801079f9:	68 29 89 10 80       	push   $0x80108929
801079fe:	e8 8d 89 ff ff       	call   80100390 <panic>
80107a03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a10 <loaduvm>:
{
80107a10:	55                   	push   %ebp
80107a11:	89 e5                	mov    %esp,%ebp
80107a13:	57                   	push   %edi
80107a14:	56                   	push   %esi
80107a15:	53                   	push   %ebx
80107a16:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107a19:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107a20:	0f 85 91 00 00 00    	jne    80107ab7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107a26:	8b 75 18             	mov    0x18(%ebp),%esi
80107a29:	31 db                	xor    %ebx,%ebx
80107a2b:	85 f6                	test   %esi,%esi
80107a2d:	75 1a                	jne    80107a49 <loaduvm+0x39>
80107a2f:	eb 6f                	jmp    80107aa0 <loaduvm+0x90>
80107a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a38:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a3e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107a44:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107a47:	76 57                	jbe    80107aa0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107a49:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a4c:	8b 45 08             	mov    0x8(%ebp),%eax
80107a4f:	31 c9                	xor    %ecx,%ecx
80107a51:	01 da                	add    %ebx,%edx
80107a53:	e8 c8 fb ff ff       	call   80107620 <walkpgdir>
80107a58:	85 c0                	test   %eax,%eax
80107a5a:	74 4e                	je     80107aaa <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80107a5c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a5e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107a61:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107a66:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107a6b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107a71:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a74:	01 d9                	add    %ebx,%ecx
80107a76:	05 00 00 00 80       	add    $0x80000000,%eax
80107a7b:	57                   	push   %edi
80107a7c:	51                   	push   %ecx
80107a7d:	50                   	push   %eax
80107a7e:	ff 75 10             	pushl  0x10(%ebp)
80107a81:	e8 da 9e ff ff       	call   80101960 <readi>
80107a86:	83 c4 10             	add    $0x10,%esp
80107a89:	39 f8                	cmp    %edi,%eax
80107a8b:	74 ab                	je     80107a38 <loaduvm+0x28>
}
80107a8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a95:	5b                   	pop    %ebx
80107a96:	5e                   	pop    %esi
80107a97:	5f                   	pop    %edi
80107a98:	5d                   	pop    %ebp
80107a99:	c3                   	ret    
80107a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107aa3:	31 c0                	xor    %eax,%eax
}
80107aa5:	5b                   	pop    %ebx
80107aa6:	5e                   	pop    %esi
80107aa7:	5f                   	pop    %edi
80107aa8:	5d                   	pop    %ebp
80107aa9:	c3                   	ret    
      panic("loaduvm: address should exist");
80107aaa:	83 ec 0c             	sub    $0xc,%esp
80107aad:	68 43 89 10 80       	push   $0x80108943
80107ab2:	e8 d9 88 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107ab7:	83 ec 0c             	sub    $0xc,%esp
80107aba:	68 e4 89 10 80       	push   $0x801089e4
80107abf:	e8 cc 88 ff ff       	call   80100390 <panic>
80107ac4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107aca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107ad0 <allocuvm>:
{
80107ad0:	55                   	push   %ebp
80107ad1:	89 e5                	mov    %esp,%ebp
80107ad3:	57                   	push   %edi
80107ad4:	56                   	push   %esi
80107ad5:	53                   	push   %ebx
80107ad6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107ad9:	8b 7d 10             	mov    0x10(%ebp),%edi
80107adc:	85 ff                	test   %edi,%edi
80107ade:	0f 88 8e 00 00 00    	js     80107b72 <allocuvm+0xa2>
  if(newsz < oldsz)
80107ae4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107ae7:	0f 82 93 00 00 00    	jb     80107b80 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80107aed:	8b 45 0c             	mov    0xc(%ebp),%eax
80107af0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107af6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107afc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107aff:	0f 86 7e 00 00 00    	jbe    80107b83 <allocuvm+0xb3>
80107b05:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107b08:	8b 7d 08             	mov    0x8(%ebp),%edi
80107b0b:	eb 42                	jmp    80107b4f <allocuvm+0x7f>
80107b0d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107b10:	83 ec 04             	sub    $0x4,%esp
80107b13:	68 00 10 00 00       	push   $0x1000
80107b18:	6a 00                	push   $0x0
80107b1a:	50                   	push   %eax
80107b1b:	e8 70 d3 ff ff       	call   80104e90 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107b20:	58                   	pop    %eax
80107b21:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107b27:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b2c:	5a                   	pop    %edx
80107b2d:	6a 06                	push   $0x6
80107b2f:	50                   	push   %eax
80107b30:	89 da                	mov    %ebx,%edx
80107b32:	89 f8                	mov    %edi,%eax
80107b34:	e8 67 fb ff ff       	call   801076a0 <mappages>
80107b39:	83 c4 10             	add    $0x10,%esp
80107b3c:	85 c0                	test   %eax,%eax
80107b3e:	78 50                	js     80107b90 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107b40:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107b46:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107b49:	0f 86 81 00 00 00    	jbe    80107bd0 <allocuvm+0x100>
    mem = kalloc();
80107b4f:	e8 6c a9 ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
80107b54:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107b56:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107b58:	75 b6                	jne    80107b10 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107b5a:	83 ec 0c             	sub    $0xc,%esp
80107b5d:	68 61 89 10 80       	push   $0x80108961
80107b62:	e8 f9 8a ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107b67:	83 c4 10             	add    $0x10,%esp
80107b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b6d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107b70:	77 6e                	ja     80107be0 <allocuvm+0x110>
}
80107b72:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107b75:	31 ff                	xor    %edi,%edi
}
80107b77:	89 f8                	mov    %edi,%eax
80107b79:	5b                   	pop    %ebx
80107b7a:	5e                   	pop    %esi
80107b7b:	5f                   	pop    %edi
80107b7c:	5d                   	pop    %ebp
80107b7d:	c3                   	ret    
80107b7e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107b80:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107b83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b86:	89 f8                	mov    %edi,%eax
80107b88:	5b                   	pop    %ebx
80107b89:	5e                   	pop    %esi
80107b8a:	5f                   	pop    %edi
80107b8b:	5d                   	pop    %ebp
80107b8c:	c3                   	ret    
80107b8d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107b90:	83 ec 0c             	sub    $0xc,%esp
80107b93:	68 79 89 10 80       	push   $0x80108979
80107b98:	e8 c3 8a ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107b9d:	83 c4 10             	add    $0x10,%esp
80107ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ba3:	39 45 10             	cmp    %eax,0x10(%ebp)
80107ba6:	76 0d                	jbe    80107bb5 <allocuvm+0xe5>
80107ba8:	89 c1                	mov    %eax,%ecx
80107baa:	8b 55 10             	mov    0x10(%ebp),%edx
80107bad:	8b 45 08             	mov    0x8(%ebp),%eax
80107bb0:	e8 7b fb ff ff       	call   80107730 <deallocuvm.part.0>
      kfree(mem);
80107bb5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107bb8:	31 ff                	xor    %edi,%edi
      kfree(mem);
80107bba:	56                   	push   %esi
80107bbb:	e8 50 a7 ff ff       	call   80102310 <kfree>
      return 0;
80107bc0:	83 c4 10             	add    $0x10,%esp
}
80107bc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bc6:	89 f8                	mov    %edi,%eax
80107bc8:	5b                   	pop    %ebx
80107bc9:	5e                   	pop    %esi
80107bca:	5f                   	pop    %edi
80107bcb:	5d                   	pop    %ebp
80107bcc:	c3                   	ret    
80107bcd:	8d 76 00             	lea    0x0(%esi),%esi
80107bd0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107bd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bd6:	5b                   	pop    %ebx
80107bd7:	89 f8                	mov    %edi,%eax
80107bd9:	5e                   	pop    %esi
80107bda:	5f                   	pop    %edi
80107bdb:	5d                   	pop    %ebp
80107bdc:	c3                   	ret    
80107bdd:	8d 76 00             	lea    0x0(%esi),%esi
80107be0:	89 c1                	mov    %eax,%ecx
80107be2:	8b 55 10             	mov    0x10(%ebp),%edx
80107be5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107be8:	31 ff                	xor    %edi,%edi
80107bea:	e8 41 fb ff ff       	call   80107730 <deallocuvm.part.0>
80107bef:	eb 92                	jmp    80107b83 <allocuvm+0xb3>
80107bf1:	eb 0d                	jmp    80107c00 <deallocuvm>
80107bf3:	90                   	nop
80107bf4:	90                   	nop
80107bf5:	90                   	nop
80107bf6:	90                   	nop
80107bf7:	90                   	nop
80107bf8:	90                   	nop
80107bf9:	90                   	nop
80107bfa:	90                   	nop
80107bfb:	90                   	nop
80107bfc:	90                   	nop
80107bfd:	90                   	nop
80107bfe:	90                   	nop
80107bff:	90                   	nop

80107c00 <deallocuvm>:
{
80107c00:	55                   	push   %ebp
80107c01:	89 e5                	mov    %esp,%ebp
80107c03:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c06:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107c09:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107c0c:	39 d1                	cmp    %edx,%ecx
80107c0e:	73 10                	jae    80107c20 <deallocuvm+0x20>
}
80107c10:	5d                   	pop    %ebp
80107c11:	e9 1a fb ff ff       	jmp    80107730 <deallocuvm.part.0>
80107c16:	8d 76 00             	lea    0x0(%esi),%esi
80107c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107c20:	89 d0                	mov    %edx,%eax
80107c22:	5d                   	pop    %ebp
80107c23:	c3                   	ret    
80107c24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107c30 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107c30:	55                   	push   %ebp
80107c31:	89 e5                	mov    %esp,%ebp
80107c33:	57                   	push   %edi
80107c34:	56                   	push   %esi
80107c35:	53                   	push   %ebx
80107c36:	83 ec 0c             	sub    $0xc,%esp
80107c39:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107c3c:	85 f6                	test   %esi,%esi
80107c3e:	74 59                	je     80107c99 <freevm+0x69>
80107c40:	31 c9                	xor    %ecx,%ecx
80107c42:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107c47:	89 f0                	mov    %esi,%eax
80107c49:	e8 e2 fa ff ff       	call   80107730 <deallocuvm.part.0>
80107c4e:	89 f3                	mov    %esi,%ebx
80107c50:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107c56:	eb 0f                	jmp    80107c67 <freevm+0x37>
80107c58:	90                   	nop
80107c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c60:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107c63:	39 fb                	cmp    %edi,%ebx
80107c65:	74 23                	je     80107c8a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107c67:	8b 03                	mov    (%ebx),%eax
80107c69:	a8 01                	test   $0x1,%al
80107c6b:	74 f3                	je     80107c60 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107c6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107c72:	83 ec 0c             	sub    $0xc,%esp
80107c75:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107c78:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107c7d:	50                   	push   %eax
80107c7e:	e8 8d a6 ff ff       	call   80102310 <kfree>
80107c83:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107c86:	39 fb                	cmp    %edi,%ebx
80107c88:	75 dd                	jne    80107c67 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107c8a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c90:	5b                   	pop    %ebx
80107c91:	5e                   	pop    %esi
80107c92:	5f                   	pop    %edi
80107c93:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107c94:	e9 77 a6 ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
80107c99:	83 ec 0c             	sub    $0xc,%esp
80107c9c:	68 95 89 10 80       	push   $0x80108995
80107ca1:	e8 ea 86 ff ff       	call   80100390 <panic>
80107ca6:	8d 76 00             	lea    0x0(%esi),%esi
80107ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107cb0 <setupkvm>:
{
80107cb0:	55                   	push   %ebp
80107cb1:	89 e5                	mov    %esp,%ebp
80107cb3:	56                   	push   %esi
80107cb4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107cb5:	e8 06 a8 ff ff       	call   801024c0 <kalloc>
80107cba:	85 c0                	test   %eax,%eax
80107cbc:	89 c6                	mov    %eax,%esi
80107cbe:	74 42                	je     80107d02 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107cc0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107cc3:	bb 80 b4 10 80       	mov    $0x8010b480,%ebx
  memset(pgdir, 0, PGSIZE);
80107cc8:	68 00 10 00 00       	push   $0x1000
80107ccd:	6a 00                	push   $0x0
80107ccf:	50                   	push   %eax
80107cd0:	e8 bb d1 ff ff       	call   80104e90 <memset>
80107cd5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107cd8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107cdb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107cde:	83 ec 08             	sub    $0x8,%esp
80107ce1:	8b 13                	mov    (%ebx),%edx
80107ce3:	ff 73 0c             	pushl  0xc(%ebx)
80107ce6:	50                   	push   %eax
80107ce7:	29 c1                	sub    %eax,%ecx
80107ce9:	89 f0                	mov    %esi,%eax
80107ceb:	e8 b0 f9 ff ff       	call   801076a0 <mappages>
80107cf0:	83 c4 10             	add    $0x10,%esp
80107cf3:	85 c0                	test   %eax,%eax
80107cf5:	78 19                	js     80107d10 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107cf7:	83 c3 10             	add    $0x10,%ebx
80107cfa:	81 fb c0 b4 10 80    	cmp    $0x8010b4c0,%ebx
80107d00:	75 d6                	jne    80107cd8 <setupkvm+0x28>
}
80107d02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d05:	89 f0                	mov    %esi,%eax
80107d07:	5b                   	pop    %ebx
80107d08:	5e                   	pop    %esi
80107d09:	5d                   	pop    %ebp
80107d0a:	c3                   	ret    
80107d0b:	90                   	nop
80107d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107d10:	83 ec 0c             	sub    $0xc,%esp
80107d13:	56                   	push   %esi
      return 0;
80107d14:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107d16:	e8 15 ff ff ff       	call   80107c30 <freevm>
      return 0;
80107d1b:	83 c4 10             	add    $0x10,%esp
}
80107d1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d21:	89 f0                	mov    %esi,%eax
80107d23:	5b                   	pop    %ebx
80107d24:	5e                   	pop    %esi
80107d25:	5d                   	pop    %ebp
80107d26:	c3                   	ret    
80107d27:	89 f6                	mov    %esi,%esi
80107d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107d30 <kvmalloc>:
{
80107d30:	55                   	push   %ebp
80107d31:	89 e5                	mov    %esp,%ebp
80107d33:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107d36:	e8 75 ff ff ff       	call   80107cb0 <setupkvm>
80107d3b:	a3 84 c9 11 80       	mov    %eax,0x8011c984
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107d40:	05 00 00 00 80       	add    $0x80000000,%eax
80107d45:	0f 22 d8             	mov    %eax,%cr3
}
80107d48:	c9                   	leave  
80107d49:	c3                   	ret    
80107d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107d50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107d50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107d51:	31 c9                	xor    %ecx,%ecx
{
80107d53:	89 e5                	mov    %esp,%ebp
80107d55:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107d58:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d5b:	8b 45 08             	mov    0x8(%ebp),%eax
80107d5e:	e8 bd f8 ff ff       	call   80107620 <walkpgdir>
  if(pte == 0)
80107d63:	85 c0                	test   %eax,%eax
80107d65:	74 05                	je     80107d6c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107d67:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107d6a:	c9                   	leave  
80107d6b:	c3                   	ret    
    panic("clearpteu");
80107d6c:	83 ec 0c             	sub    $0xc,%esp
80107d6f:	68 a6 89 10 80       	push   $0x801089a6
80107d74:	e8 17 86 ff ff       	call   80100390 <panic>
80107d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107d80 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107d80:	55                   	push   %ebp
80107d81:	89 e5                	mov    %esp,%ebp
80107d83:	57                   	push   %edi
80107d84:	56                   	push   %esi
80107d85:	53                   	push   %ebx
80107d86:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107d89:	e8 22 ff ff ff       	call   80107cb0 <setupkvm>
80107d8e:	85 c0                	test   %eax,%eax
80107d90:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107d93:	0f 84 9f 00 00 00    	je     80107e38 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107d99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107d9c:	85 c9                	test   %ecx,%ecx
80107d9e:	0f 84 94 00 00 00    	je     80107e38 <copyuvm+0xb8>
80107da4:	31 ff                	xor    %edi,%edi
80107da6:	eb 4a                	jmp    80107df2 <copyuvm+0x72>
80107da8:	90                   	nop
80107da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107db0:	83 ec 04             	sub    $0x4,%esp
80107db3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107db9:	68 00 10 00 00       	push   $0x1000
80107dbe:	53                   	push   %ebx
80107dbf:	50                   	push   %eax
80107dc0:	e8 7b d1 ff ff       	call   80104f40 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107dc5:	58                   	pop    %eax
80107dc6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107dcc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107dd1:	5a                   	pop    %edx
80107dd2:	ff 75 e4             	pushl  -0x1c(%ebp)
80107dd5:	50                   	push   %eax
80107dd6:	89 fa                	mov    %edi,%edx
80107dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ddb:	e8 c0 f8 ff ff       	call   801076a0 <mappages>
80107de0:	83 c4 10             	add    $0x10,%esp
80107de3:	85 c0                	test   %eax,%eax
80107de5:	78 61                	js     80107e48 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107de7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107ded:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107df0:	76 46                	jbe    80107e38 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107df2:	8b 45 08             	mov    0x8(%ebp),%eax
80107df5:	31 c9                	xor    %ecx,%ecx
80107df7:	89 fa                	mov    %edi,%edx
80107df9:	e8 22 f8 ff ff       	call   80107620 <walkpgdir>
80107dfe:	85 c0                	test   %eax,%eax
80107e00:	74 61                	je     80107e63 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107e02:	8b 00                	mov    (%eax),%eax
80107e04:	a8 01                	test   $0x1,%al
80107e06:	74 4e                	je     80107e56 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107e08:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107e0a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107e0f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107e15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107e18:	e8 a3 a6 ff ff       	call   801024c0 <kalloc>
80107e1d:	85 c0                	test   %eax,%eax
80107e1f:	89 c6                	mov    %eax,%esi
80107e21:	75 8d                	jne    80107db0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107e23:	83 ec 0c             	sub    $0xc,%esp
80107e26:	ff 75 e0             	pushl  -0x20(%ebp)
80107e29:	e8 02 fe ff ff       	call   80107c30 <freevm>
  return 0;
80107e2e:	83 c4 10             	add    $0x10,%esp
80107e31:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e3e:	5b                   	pop    %ebx
80107e3f:	5e                   	pop    %esi
80107e40:	5f                   	pop    %edi
80107e41:	5d                   	pop    %ebp
80107e42:	c3                   	ret    
80107e43:	90                   	nop
80107e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107e48:	83 ec 0c             	sub    $0xc,%esp
80107e4b:	56                   	push   %esi
80107e4c:	e8 bf a4 ff ff       	call   80102310 <kfree>
      goto bad;
80107e51:	83 c4 10             	add    $0x10,%esp
80107e54:	eb cd                	jmp    80107e23 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107e56:	83 ec 0c             	sub    $0xc,%esp
80107e59:	68 ca 89 10 80       	push   $0x801089ca
80107e5e:	e8 2d 85 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107e63:	83 ec 0c             	sub    $0xc,%esp
80107e66:	68 b0 89 10 80       	push   $0x801089b0
80107e6b:	e8 20 85 ff ff       	call   80100390 <panic>

80107e70 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107e70:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107e71:	31 c9                	xor    %ecx,%ecx
{
80107e73:	89 e5                	mov    %esp,%ebp
80107e75:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107e78:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e7e:	e8 9d f7 ff ff       	call   80107620 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107e83:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107e85:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107e86:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107e88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107e8d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107e90:	05 00 00 00 80       	add    $0x80000000,%eax
80107e95:	83 fa 05             	cmp    $0x5,%edx
80107e98:	ba 00 00 00 00       	mov    $0x0,%edx
80107e9d:	0f 45 c2             	cmovne %edx,%eax
}
80107ea0:	c3                   	ret    
80107ea1:	eb 0d                	jmp    80107eb0 <copyout>
80107ea3:	90                   	nop
80107ea4:	90                   	nop
80107ea5:	90                   	nop
80107ea6:	90                   	nop
80107ea7:	90                   	nop
80107ea8:	90                   	nop
80107ea9:	90                   	nop
80107eaa:	90                   	nop
80107eab:	90                   	nop
80107eac:	90                   	nop
80107ead:	90                   	nop
80107eae:	90                   	nop
80107eaf:	90                   	nop

80107eb0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107eb0:	55                   	push   %ebp
80107eb1:	89 e5                	mov    %esp,%ebp
80107eb3:	57                   	push   %edi
80107eb4:	56                   	push   %esi
80107eb5:	53                   	push   %ebx
80107eb6:	83 ec 1c             	sub    $0x1c,%esp
80107eb9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ebf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107ec2:	85 db                	test   %ebx,%ebx
80107ec4:	75 40                	jne    80107f06 <copyout+0x56>
80107ec6:	eb 70                	jmp    80107f38 <copyout+0x88>
80107ec8:	90                   	nop
80107ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107ed0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107ed3:	89 f1                	mov    %esi,%ecx
80107ed5:	29 d1                	sub    %edx,%ecx
80107ed7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107edd:	39 d9                	cmp    %ebx,%ecx
80107edf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107ee2:	29 f2                	sub    %esi,%edx
80107ee4:	83 ec 04             	sub    $0x4,%esp
80107ee7:	01 d0                	add    %edx,%eax
80107ee9:	51                   	push   %ecx
80107eea:	57                   	push   %edi
80107eeb:	50                   	push   %eax
80107eec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107eef:	e8 4c d0 ff ff       	call   80104f40 <memmove>
    len -= n;
    buf += n;
80107ef4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107ef7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107efa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107f00:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107f02:	29 cb                	sub    %ecx,%ebx
80107f04:	74 32                	je     80107f38 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107f06:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107f08:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107f0b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107f0e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107f14:	56                   	push   %esi
80107f15:	ff 75 08             	pushl  0x8(%ebp)
80107f18:	e8 53 ff ff ff       	call   80107e70 <uva2ka>
    if(pa0 == 0)
80107f1d:	83 c4 10             	add    $0x10,%esp
80107f20:	85 c0                	test   %eax,%eax
80107f22:	75 ac                	jne    80107ed0 <copyout+0x20>
  }
  return 0;
}
80107f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107f27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f2c:	5b                   	pop    %ebx
80107f2d:	5e                   	pop    %esi
80107f2e:	5f                   	pop    %edi
80107f2f:	5d                   	pop    %ebp
80107f30:	c3                   	ret    
80107f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107f3b:	31 c0                	xor    %eax,%eax
}
80107f3d:	5b                   	pop    %ebx
80107f3e:	5e                   	pop    %esi
80107f3f:	5f                   	pop    %edi
80107f40:	5d                   	pop    %ebp
80107f41:	c3                   	ret    
