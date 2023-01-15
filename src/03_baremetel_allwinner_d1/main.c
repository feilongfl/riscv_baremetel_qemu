
#include <sbi/sbi_ecall_interface.h>
#include <stdio.h>

#define SBI_ECALL(__eid, __fid, __a0, __a1, __a2)                              \
  ({                                                                           \
    register unsigned long a0 asm("a0") = (unsigned long)(__a0);               \
    register unsigned long a1 asm("a1") = (unsigned long)(__a1);               \
    register unsigned long a2 asm("a2") = (unsigned long)(__a2);               \
    register unsigned long a6 asm("a6") = (unsigned long)(__fid);              \
    register unsigned long a7 asm("a7") = (unsigned long)(__eid);              \
    asm volatile("ecall"                                                       \
                 : "+r"(a0)                                                    \
                 : "r"(a1), "r"(a2), "r"(a6), "r"(a7)                          \
                 : "memory");                                                  \
    a0;                                                                        \
  })

#define sbi_ecall_console_putc(c)                                              \
  SBI_ECALL(SBI_EXT_0_1_CONSOLE_PUTCHAR, 0, (c), 0, 0)

// putchar() is called by printf() to output a character
int putchar(int c) {
  sbi_ecall_console_putc(c);
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

// initial GPIO: PD18 as output
// 0x02000000: GPIO controller base address
#define GPIO_BASE 0x02000000
#define PORTD_OFFSET 0x0090
#define GPIO_PIN 18

struct sunxi_gpio {
  unsigned int cfg[4];
  unsigned int dat;
  unsigned int drv[2];
  unsigned int pull[2];
};

struct sunxi_gpio *PortD = (struct sunxi_gpio *)(GPIO_BASE + PORTD_OFFSET);

void led_blink() {
  int i = 0;
  int j = 0;
  int k = 0;
  int led = 0;

  // PD18: output
  PortD->cfg[(GPIO_PIN) / 8] &= (~0x0F << (GPIO_PIN % 8) * 4);
  PortD->cfg[(GPIO_PIN) / 8] |= (0x01 << (GPIO_PIN % 8) * 4);
  PortD->dat |= (0x01 << 18);

  while (1) {
    printf(".");
    for (i = 0; i < 100000000; i++) {
    }

    // toggle led
    if (led)
      PortD->dat |= (0x01 << GPIO_PIN);
    else
      PortD->dat &= ~(0x01 << GPIO_PIN);

    led = ~led;
  }
}

// main function, called by _start() in boot.s
void main(unsigned long a0) {
  printf("FeiLong\n\n");

  printf("\n\n");
  printf("Tips: Press reset button to reboot.\n\n");

  led_blink();

  return;
}
