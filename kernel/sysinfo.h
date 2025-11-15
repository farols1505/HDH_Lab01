#ifndef SYSINFO_H
#define SYSINFO_H

#include "types.h"

/* sysinfo struct returned to user space */
struct sysinfo 
{
  uint64 freemem;   // free bytes
  uint64 nproc;        // number of non-UNUSED processes
  int loadavg[3];   // fixed-point scaled by 1000 (1,5,15)
};

#endif // SYSINFO_H