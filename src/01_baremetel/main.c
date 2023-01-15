
#include <stdio.h>

#ifndef UART_BASE
#define UART_BASE 0x10000000
#endif

// putchar() is called by printf() to output a character
int putchar(int c) {
  *(volatile unsigned int *)(UART_BASE) = c;
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
