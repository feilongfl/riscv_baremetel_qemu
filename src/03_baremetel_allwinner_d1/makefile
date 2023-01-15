
ASFLAGS := -g
CFLAGS := -g -mcmodel=medany -nostartfiles -fno-plt -fno-pic -I../../devices/common/opensbi/include
LDFLAGS := -L/usr/riscv64-unknown-elf/lib/ -lc

kernel.elf: kernel.ld boot.o main.o
	riscv64-unknown-elf-ld $(LDFLAGS) -o $@ -T $^

%.o: %.s
	riscv64-unknown-elf-as $(ASFLAGS) -o $@ $<

%.o: %.c
	riscv64-unknown-elf-gcc $(CFLAGS) -c -o $@ $<

asm: kernel.elf
	riscv64-unknown-elf-objdump -d $<

clean:
	rm *.o kernel.elf *.dts *.dtb *.log *.fixed.s

.PHONY: clean asm
