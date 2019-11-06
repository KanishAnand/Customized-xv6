#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void) {
    int i;

    for (i = 0; i < 256; i++)
        SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

    initlock(&tickslock, "time");
}

void idtinit(void) {
    lidt(idt, sizeof(idt));
}

// PAGEBREAK: 41
void trap(struct trapframe *tf) {
    if (tf->trapno == T_SYSCALL) {
        if (myproc()->killed)
            exit();
        myproc()->tf = tf;
        syscall();
        if (myproc()->killed)
            exit();
        return;
    }

    switch (tf->trapno) {
        case T_IRQ0 + IRQ_TIMER:
            if (cpuid() == 0) {
                acquire(&tickslock);
                ticks++;
                wakeup(&ticks);
                release(&tickslock);

                if (myproc()) {
                    if (myproc()->state == RUNNING) {
                        myproc()->rtime++;
                        int no = myproc()->qno;
                        myproc()->tick[no]++;
                    } else if (myproc()->state == SLEEPING) {
                        myproc()->iotime++;
                    }
#ifdef MLFQ
                    aging();
#endif
                }
            }

            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE:
            ideintr();
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE + 1:
            // Bochs generates spurious IDE1 interrupts.
            break;
        case T_IRQ0 + IRQ_KBD:
            kbdintr();
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_COM1:
            uartintr();
            lapiceoi();
            break;
        case T_IRQ0 + 7:
        case T_IRQ0 + IRQ_SPURIOUS:
            cprintf("cpu%d: spurious interrupt at %x:%x\n", cpuid(), tf->cs,
                    tf->eip);
            lapiceoi();
            break;

        // PAGEBREAK: 13
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
                // In kernel, it must be our mistake.
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf(
                "pid %d %s: trap %d err %d on cpu %d "
                "eip 0x%x addr 0x%x--kill proc\n",
                myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(),
                tf->eip, rcr2());
            myproc()->killed = 1;
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
        exit();

// Force process to give up CPU on clock tick.
// If interrupts were on while locks held, would need to check nlock.
#ifdef FCFS
// don't yield :)
#endif

#ifdef PBS
    if (myproc() && myproc()->state == RUNNING &&
        tf->trapno == T_IRQ0 + IRQ_TIMER) {
        int c = check_priority(myproc()->priority);
        if (c == 1) {
            yield();
        }
    }
#endif

#ifdef MLFQ
    if (myproc() && myproc()->state == RUNNING &&
        tf->trapno == T_IRQ0 + IRQ_TIMER) {
        int no = myproc()->qno;
        if (myproc()->tick[no] != 0) {
            if (no == 0) {
                myproc()->qno = 1;
                cnt[0]--;
                // cnt[1]++;
                for (int i = beg0; i < cnt[0]; i++) {
                    q0[i] = q0[i + 1];
                }
                int f = 0;
                for (int i = 0; i < cnt[1]; i++) {
                    if (q1[i] == myproc()) {
                        f = 1;
                        break;
                    }
                }
                if (f == 0) {
                    cnt[1]++;
                    q1[cnt[1] - 1] = myproc();
                    end1 += 1;
                }
                yield();
            } else if (no == 1 && myproc()->tick[1] % 2 == 0) {
                myproc()->qno = 2;
                cnt[1]--;
                for (int i = beg1; i < cnt[1]; i++) {
                    q1[i] = q1[i + 1];
                }
                int f = 0;
                for (int i = 0; i < cnt[2]; i++) {
                    if (q2[i] == myproc()) {
                        f = 1;
                        break;
                    }
                }
                if (f == 0) {
                    cnt[2]++;
                    q2[cnt[2] - 1] = myproc();
                    end2 += 1;
                }
                yield();
            } else if (no == 2 && myproc()->tick[2] % 4 == 0) {
                myproc()->qno = 3;
                cnt[2]--;
                for (int i = beg2; i < cnt[2]; i++) {
                    q2[i] = q2[i + 1];
                }
                int f = 0;
                for (int i = 0; i < cnt[3]; i++) {
                    if (q3[i] == myproc()) {
                        f = 1;
                        break;
                    }
                }
                if (f == 0) {
                    cnt[3]++;
                    q3[cnt[3] - 1] = myproc();
                    end3 += 1;
                }
                yield();
            } else if (no == 3 && myproc()->tick[3] % 8 == 0) {
                myproc()->qno = 4;
                cnt[3]--;
                // cnt[4]++;
                for (int i = beg3; i < cnt[3]; i++) {
                    q3[i] = q3[i + 1];
                }
                int f = 0;
                for (int i = 0; i < cnt[4]; i++) {
                    if (q4[i] == myproc()) {
                        f = 1;
                        break;
                    }
                }
                if (f == 0) {
                    cnt[4]++;
                    q4[cnt[4] - 1] = myproc();
                    end4 += 1;
                }
                yield();
            } else if (no == 4 && myproc()->tick[4] % 16 == 0) {
                // beg4++;
                q4[cnt[4]] = myproc();
                end4 += 1;
                for (int i = beg4; i < cnt[4]; i++) {
                    q4[i] = q4[i + 1];
                }
                yield();
            } else {
                int flag0 = 0, flag1 = 0, flag2 = 0, flag3 = 0;

                for (int j = 0; j < cnt[0]; j++) {
                    if (q0[j]->state == RUNNABLE) {
                        flag0 = 1;
                        break;
                    }
                }
                for (int j = 0; j < cnt[1]; j++) {
                    if (q1[j]->state == RUNNABLE) {
                        flag1 = 1;
                        break;
                    }
                }
                for (int j = 0; j < cnt[2]; j++) {
                    if (q2[j]->state == RUNNABLE) {
                        flag2 = 1;
                        break;
                    }
                }
                for (int j = 0; j < cnt[3]; j++) {
                    if (q3[j]->state == RUNNABLE) {
                        flag3 = 1;
                        break;
                    }
                }

                if (no == 1) {
                    if (flag0 == 1) {
                        yield();
                    }
                } else if (no == 2) {
                    if (flag0 == 1 || flag1 == 1) {
                        yield();
                    }
                } else if (no == 3) {
                    if (flag0 == 1 || flag1 == 1 || flag2 == 1) {
                        yield();
                    }
                } else if (no == 4) {
                    if (flag0 == 1 || flag1 == 1 || flag2 == 1 || flag3 == 1) {
                        yield();
                    }
                }
            }
        }
    }

#endif

#ifdef DEFAULT
    if (myproc() && myproc()->state == RUNNING &&
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();
#endif

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
        exit();
}
