// Mirror file in /user

#ifndef SYSINFO_H
#define SYSINFO_H

#include "kernel/types.h" 

struct sysinfo {
  uint64 freemem;  // number of free memory bytes
  int nproc;       // number of active processes
  float loadavg[3]; // load average over 1, 5, and 15 minutes
};

#endif // SYSINFO_H



