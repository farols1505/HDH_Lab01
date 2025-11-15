#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "user/sysinfo.h"

int
main(int argc, char *argv[])
{
  struct sysinfo info;
  if (sysinfo(&info) < 0) {
    printf("sysinfotest: sysinfo failed\n");
    exit(1);
  }

  // print freemem and nproc
  printf("sysinfotest: freemem=%lu nproc=%d\n", info.freemem, info.nproc);


  // check loadavg values

  if (info.loadavg[0] < 0 || info.loadavg[1] < 0 || info.loadavg[2] < 0) {
    printf("sysinfotest: invalid loadavg\n");
    exit(1);
  }

  // print loadavg as float-like
  printf("sysinfotest: loadavg = [%.3f, %.3f, %.3f]\n", info.loadavg[0], info.loadavg[1], info.loadavg[2]);

  if (info.freemem == 0 || info.nproc == 0) {
    printf("sysinfotest: FAIL\n");
    exit(1);
  }

  printf("sysinfotest: OK\n");
  exit(0);
}
