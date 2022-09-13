#include <stdio.h>
#include <arm_neon.h>

void intr() {
  uint8_t a = 1, b = 2;
  uint8x16_t va = vdupq_n_u8(a), vb = vdupq_n_u8(b);
  va = vaddq_u8(va, vb);
  uint8_t c[16];
  vst1q_u8(c, va);
  for(int i=0;i<sizeof(c);i++)
    printf("%d: %u\n", i, c[i]);
}

void asms() {
  uint32_t a = 1, b = 2;
  uint8_t c[16];
  asm volatile("\n\
  DUP V0.16B, %w[a]\n\
  DUP V1.16B, %w[b]\n\
  ADD V2.16B,V0.16B,V1.16B\n\
  ST1 {V2.16B},%[c]\n"
  :[c] "=m" (c),"=m" (*(uint8_t(*)[sizeof(c)])c)
  :[a] "r" (a),[b] "r" (b)
  :"v0","v1","v2");
  for(int i=0;i<sizeof(c);i++)
    printf("%d: %u\n", i, c[i]);
}

int main(){
  intr();
  asms();
  return 0;
}
//clang-10 -target aarch64-linux-gnu -I /usr/aarch64-linux-gnu/include add.c
//qemu-aarch64 -L /usr/aarch64-linux-gnu a.out
