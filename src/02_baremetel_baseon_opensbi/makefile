
ASFLAGS := -g
CFLAGS := -g -mcmodel=medany -nostartfiles -fno-plt -fno-pic -I../../devices/common/opensbi/include
LDFLAGS := -L/usr/riscv64-unknown-elf/lib/ -lc
QFLAGS := -nographic -display none -serial mon:stdio -smp 4

kernel.elf: kernel.ld boot.o main.o
	riscv64-unknown-elf-ld $(LDFLAGS) -o $@ -T $^

%.o: %.s
	riscv64-unknown-elf-as $(ASFLAGS) -o $@ $<

%.o: %.c
	riscv64-unknown-elf-gcc $(CFLAGS) -c -o $@ $<

asm: kernel.elf
	riscv64-unknown-elf-objdump -d $<

qemu: kernel.elf
	qemu-system-riscv64 -machine virt $(QFLAGS) -kernel $<

qemuasm: kernel.elf
	qemu-system-riscv64 -machine virt $(QFLAGS) -kernel $< -d in_asm

qemudebug: kernel.elf
	qemu-system-riscv64 -machine virt $(QFLAGS) -kernel $< -s -S

gdb: kernel.elf
	gdb-multiarch -iex "set auto-load safe-path /" $<

qemu.dts: kernel.elf
	qemu-system-riscv64 -machine virt,dumpdtb=qemu.dtb $(QFLAGS) -kernel $<
	dtc -o qemu.dts -O dts -I dtb qemu.dtb

clean:
	rm *.o kernel.elf *.dts *.dtb *.log *.fixed.s

.PHONY: clean qemu asm qemudebug gdb
