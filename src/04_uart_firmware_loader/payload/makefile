
PREFIX := riscv64-linux-gnu-
# PREFIX := riscv64-unknown-elf-

ASFLAGS := -g -fpic
CFLAGS := -g -mcmodel=medany -nostartfiles -fno-plt -fpic
LDFLAGS := -L/usr/riscv64-unknown-elf/lib/ -lc -fpic -shared
QFLAGS := -nographic -display none -serial mon:stdio -smp 1 -bios none

PRJNAME = payload
UART ?= /dev/ttyUSB0
RAM_ADDR ?= 0x46000000

$(PRJNAME).script: $(PRJNAME).bin
	hexdump -ve '"46%06_ax " 1/4 "%08X" "\n"' $< > $@

$(PRJNAME).bin: $(PRJNAME).elf
	riscv64-unknown-elf-objcopy -O binary $< $@

$(PRJNAME).fix.ld: $(PRJNAME).ld
	sed -r 's/@RAM_ADDR/$(RAM_ADDR)/' $< > $@

$(PRJNAME).elf: $(PRJNAME).fix.ld boot.o main.o
	$(PREFIX)ld $(LDFLAGS) -o $@ -T $^

%.o: %.S
	$(PREFIX)as $(ASFLAGS) -o $@ $<

%.o: %.c
	$(PREFIX)gcc $(CFLAGS) -c -o $@ $<

payload: $(PRJNAME).script
	echo -e 'led 0 1\n' > $(UART)
	cat $< | xargs -I % sh -c '{ echo w32 %; echo w32 % > $(UART); sleep 0.001; }'
# cat $< | xargs -I % sh -c '{ echo w32 %; echo w32 % > $(UART); sleep 0.001; echo r32 % > $(UART); sleep 0.001; }'
	echo -e 'led 0 0\n' > $(UART)
	echo -e 'boot $(RAM_ADDR)\n' > $(UART)

asm: $(PRJNAME).elf
	riscv64-unknown-elf-objdump -d $<

clean:
	rm *.o $(PRJNAME).elf *.dts *.dtb *.log *.fixed.s *.fix.ld *.bin *.script

.PHONY: clean qemu asm payload
