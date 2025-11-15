#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "kernel/sysinfo.h"
#include "syscall.h"

extern void get_loadavg(int out[3]);

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64 
sys_trace(void) {
    int mask;
    argint(0, &mask);
    myproc()->trace_mask = mask;  // Save the mask for the current process
    return 0;
}

uint64 sys_sysinfo(void)
{
  struct sysinfo info;
  uint64 addr;

  argaddr(0, &addr);

  info.freemem = freemem_count(); // hoặc freemem() theo tên hàm bạn có
  info.nproc = proc_count();

  int lag[3];
  get_loadavg(lag);
  info.loadavg[0] = lag[0];
  info.loadavg[1] = lag[1];
  info.loadavg[2] = lag[2];

  // printf("freemem=%ld nproc=%d loadavg=%d %d %d\n",
  //   info.freemem, info.nproc,
  //   info.loadavg[0], info.loadavg[1], info.loadavg[2]);

  int ret = copyout(myproc()->pagetable, addr, (char *)&info, sizeof(info));
  printf("sys_sysinfo: copyout ret=%d\n", ret);  // Debug
  if (ret < 0)
    return -1;

  return 0;
}

int
sys_kill(void)
{
  int pid;

  argint(0, &pid);   
  return kill(pid);
}

uint64
sys_uptime(void)
{
  uint xticks;
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
