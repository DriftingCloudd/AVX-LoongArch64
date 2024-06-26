
#ifndef __CONTEXT_H
#define __CONTEXT_H

#include "types.h"

typedef struct context {
  uint64 ra; //0
  uint64 sp; //8

  // callee-saved
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  
  uint64 fp;
}context;

#endif