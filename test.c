#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "procstat.h"
#include <stddef.h>

int main(int argc, char *argv[]) {
    int k, n, id;
    double x = 0, z;
    // set_priority(4, 70);
    if (argc < 2)
        n = 1;  // default value
    else
        n = atoi(argv[1]);  // from command line

    if (n < 0 || n > 20)
        n = 2;

    x = 0;
    id = 0;
    for (k = 0; k < n; k++) {
        id = fork();

        // printf(1, "%d\n", o);
        if (id < 0) {
            printf(1, "%d failed in fork!\n", getpid());
        } else if (id > 0) {  // parent
            // printf(1, "Parent %d creating child %d\n", getpid(), id);
            // wait();
        } else {  // child
            // printf(1, "Child %d created\n", getpid());
            for (z = 0; z < 3000000.0; z += 0.1)
                x = x +
                    3.14 * 89.64;  // useless calculations to consume CPU time
            exit();
        }
        // set_priority(6, 80);
    }
    for (k = 0; k < n; k++) {
        // wait();
        int a, b;
        waitx(&a, &b);
        printf(1, "Wait time : %d  Run Time : %d\n", a, b);

#ifdef MLFQ
        int pd = 4;
        struct proc_stat q;
        int c = getpinfo(&q, pd);
        if (c == 1) {
            printf(1,
                   "Pid : %d  runtime : %d num_run : %d current "
                   "queue: %d\n",
                   q.pid, q.runtime, q.num_run, q.current_queue);
            printf(1, "Ticks in ");
            for (int j = 0; j < 5; j++) {
                printf(1, "queue %d : %d ", j, q.ticks[j]);
            }
            printf(1, "\n");
        } else {
            printf(1, "Process not found\n");
        }
#endif
    }
    exit();
}