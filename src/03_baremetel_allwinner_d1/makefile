
ASFLAGS := -g
CFLAGS := -g -mcmodel=medany -nostartfiles -fno-plt -fno-pic -I../../devices/common/opensbi/include
LDFLAGS := -L/usr/riscv64-unknown-elf/lib/ -lc

sd.img: kernel.bin opensbi.bin spl.bin
	dd if=/dev/zero of=$@ bs=512 count=16
	dd if=spl.bin of=$@ bs=512 seek=16
	# dd if=opensbi.bin of=$@ bs=512 seek=32800
	# dd if=kernel.bin of=$@ bs=512 seek=65536
	ls -lah $@

kernel.bin: kernel.elf
	riscv64-unknown-elf-objcopy -O binary kernel.elf $@

kernel.elf: kernel.ld boot.o main.o
	riscv64-unknown-elf-ld $(LDFLAGS) -o $@ -T $^

%.o: %.s
	riscv64-unknown-elf-as $(ASFLAGS) -o $@ $<

%.o: %.c
	riscv64-unknown-elf-gcc $(CFLAGS) -c -o $@ $<

asm: kernel.elf
	riscv64-unknown-elf-objdump -d $<

bootpack: spl.bin opensbi.bin

spl.bin:
	pushd ../../devices/d1/sun20i_d1_spl; make CROSS_COMPILE=riscv64-linux-gnu- p=sun20iw1p1 mmc; popd
	cp ../../devices/d1/sun20i_d1_spl/nboot/boot0_sdcard_sun20iw1p1.bin ./spl.bin

opensbi.bin:
	pushd ../../devices/common/opensbi; make CROSS_COMPILE=riscv64-linux-gnu- PLATFORM=generic FW_PIC=y; popd
	cp ../../devices/common/opensbi/build/platform/generic/firmware/fw_jump.bin ./opensbi.bin

clean:
	rm *.o kernel.elf *.dts *.dtb *.log *.fixed.s *.bin

.PHONY: clean asm bootpack kernel
