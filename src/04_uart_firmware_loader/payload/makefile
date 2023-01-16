
ASFLAGS := -g
CFLAGS := -g -mcmodel=medany -nostartfiles -fno-plt -fno-pic
LDFLAGS := -L/usr/riscv64-unknown-elf/lib/ -lc
QFLAGS := -nographic -display none -serial mon:stdio -smp 1 -bios none

PRJNAME = payload
UART ?= /dev/ttyUSB0

$(PRJNAME).script: $(PRJNAME).bin
	hexdump -ve '"4a%06_ax " 1/4 "%08X" "\n"' $< > $@

$(PRJNAME).bin: $(PRJNAME).elf
	riscv64-unknown-elf-objcopy -O binary $< $@

$(PRJNAME).elf: $(PRJNAME).ld boot.o
	riscv64-unknown-elf-ld $(LDFLAGS) -o $@ -T $^

%.o: %.s
	riscv64-unknown-elf-as $(ASFLAGS) -o $@ $<

%.o: %.c
	riscv64-unknown-elf-gcc $(CFLAGS) -c -o $@ $<

payload: $(PRJNAME).script
	echo -e 'led 0 1\n' > $(UART)
	cat $< | xargs -I % sh -c '{ echo w32 %; echo w32 % > $(UART); sleep 0.1; echo r32 % > $(UART); sleep 0.1; }'
	echo -e 'led 0 0\n' > $(UART)
	echo -e 'boot 0x4a000000\n' > $(UART)

asm: $(PRJNAME).elf
	riscv64-unknown-elf-objdump -d $<

clean:
	rm *.o $(PRJNAME).elf *.dts *.dtb *.log *.fixed.s

.PHONY: clean qemu asm payload
