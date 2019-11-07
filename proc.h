#include "procstat.h"
// Per-CPU state
struct cpu {
    uchar apicid;               // Local APIC ID
    struct context *scheduler;  // swtch() here to enter scheduler
    struct taskstate ts;        // Used by x86 to find stack for interrupt
    struct segdesc gdt[NSEGS];  // x86 global descriptor table
    volatile uint started;      // Has the CPU started?
    int ncli;                   // Depth of pushcli nesting.
    int intena;                 // Were interrupts enabled before pushcli?
    struct proc *proc;          // The process running on this cpu or null
};

extern struct cpu cpus[NCPU];
extern int ncpu;

// PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
    uint edi;
    uint esi;
    uint ebx;
    uint ebp;
    uint eip;
};

enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Per-process state
struct proc {
    uint sz;                          // Size of process memory (bytes)
    pde_t *pgdir;                     // Page table
    char *kstack;                     // Bottom of kernel stack for this process
    enum procstate state;             // Process state
    int pid;                          // Process ID
    struct proc *parent;              // Parent process
    struct trapframe *tf;             // Trap frame for current syscall
    struct context *context;          // swtch() here to run process
    void *chan;                       // If non-zero, sleeping on chan
    int killed;                       // If non-zero, have been killed
    struct file *ofile[NOFILE];       // Open files
    struct inode *cwd;                // Current directory
    char name[16];                    // Process name (debugging)
    int ctime, rtime, etime, iotime;  // start, running and end time
    int priority;                     // priority of the process
    int qno;
    int aging_time;
    int rrtime[5];
    struct proc_stat stat;
};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap

extern struct proc *q0[1000];
extern struct proc *q1[1000];
extern struct proc *q2[1000];
extern struct proc *q3[1000];
extern struct proc *q4[1000];
extern int clkpr[];
extern int cnt[];
extern int beg0;
extern int beg1;
extern int beg2;
extern int beg3;
extern int beg4;
extern int end0;
extern int end1;
extern int end2;
extern int end3;
extern int end4;
extern int time_age;
int check_priority(int prt);
int aging();
int graph();