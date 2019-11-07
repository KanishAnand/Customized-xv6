#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "procstat.h"
#include <stddef.h>

int main(void) {
    // for (int i = 0; i < 5; i++) {
    //     printf(1, "PID:%d\n", i + 3);
    //     for (int j = 0; j < 2000; j++) {
    //         if (store[i][j].totaltime)
    //             printf(1, "%d %d %d\n", store[i][j].totaltime, i + 3,
    //                    store[i][j].qno);
    //     }
    //     printf(1, "\n\n");
    // }
    int a, b;
    waitx(&a, &b);
    exit();
}