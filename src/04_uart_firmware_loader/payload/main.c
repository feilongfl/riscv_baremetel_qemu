
#include <stdio.h>

#define SBI_EXT_0_1_CONSOLE_PUTCHAR 0x1
#define SBI_EXT_0_1_CONSOLE_GETCHAR 0x2

#define SBI_ECALL(__eid, __a0)                                                 \
  ({                                                                           \
    register unsigned long a0 asm("a0") = (unsigned long)(__a0);               \
    register unsigned long a7 asm("a7") = (unsigned long)(__eid);              \
    asm volatile("ecall" : "+r"(a0) : "r"(a7) : "memory");                     \
    a0;                                                                        \
  })

// putchar() is called by printf() to output a character
int putchar(int c) {
  SBI_ECALL(SBI_EXT_0_1_CONSOLE_PUTCHAR, (c));
  return c;
}

// puts() is called by printf() to output a string
int puts(const char *str) {
  char *s = (char *)str;

  while (*s) {
    putchar(*s++);
  }

  return 0;
}

// main function, called by _start() in boot.s
void main() {
  printf("FeiLong\n\n");

  printf("\n\n");
  printf("Tips: Press [Ctrl+A]X to quit qemu.\n\n");
  return;
}
