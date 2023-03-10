
ASFLAGS := -g
CFLAGS := -g -mcmodel=medany -nostartfiles -fno-plt -fno-pic -I../../devices/common/opensbi/include
LDFLAGS := -L/usr/riscv64-unknown-elf/lib/ -lc

MKIMG=../../devices/d1/u-boot/tools/mkimage

sd.img: kernel.bin opensbi.bin spl.bin d1.toc
	dd if=/dev/zero of=$@ bs=512 count=256
	dd if=spl.bin of=$@ bs=512 seek=256
	dd if=d1.toc of=$@ bs=512 seek=32800
	ls -lah $@

d1.toc: opensbi.bin root_key.pem allwinner_d1.cfg $(MKIMG) u-boot.dtb
	$(MKIMG) -T sunxi_toc1 -d allwinner_d1.cfg d1.toc

root_key.pem:
	openssl genrsa -out root_key.pem

$(MKIMG):
	pushd ../../devices/d1/u-boot; make tools-only_defconfig; make tools-only; popd

u-boot.dtb:
	pushd ../../devices/d1/u-boot; make CROSS_COMPILE=riscv64-linux-gnu- nezha_defconfig; make CROSS_COMPILE=riscv64-linux-gnu- -j`nproc`; popd
	cp ../../devices/d1/u-boot/u-boot.dtb ./u-boot.dtb

../../devices/common/esh/examples/physical/riscv-opensbi/shell.bin:
	pushd ../../devices/common/esh/examples/physical/riscv-opensbi; make; popd

kernel.bin: ../../devices/common/esh/examples/physical/riscv-opensbi/shell.bin
	cp $< $@

bootpack: spl.bin opensbi.bin

spl.bin:
	pushd ../../devices/d1/sun20i_d1_spl; make CROSS_COMPILE=riscv64-linux-gnu- p=sun20iw1p1 mmc; popd
	cp ../../devices/d1/sun20i_d1_spl/nboot/boot0_sdcard_sun20iw1p1.bin ./spl.bin

opensbi.bin:
	pushd ../../devices/common/opensbi; make CROSS_COMPILE=riscv64-linux-gnu- PLATFORM=generic FW_PIC=y; popd
	cp ../../devices/common/opensbi/build/platform/generic/firmware/fw_dynamic.bin ./opensbi.bin

payload:
	make -C payload payload

clean:
	rm *.o kernel.elf *.dts *.dtb *.log *.fixed.s *.bin *.img
	git submodule foreach git clean -xfd

.PHONY: clean asm bootpack kernel payload
