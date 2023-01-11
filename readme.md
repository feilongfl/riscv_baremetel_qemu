# Baremetel riscv program example

## prepare

### archlinux / manjaro

``` shell
yay -S riscv-gnu-toolchain-bin qemu gdb-multiarch
```

## compile & run & debug

### compile & run

``` shell
make clean
make

make qemu
```

### debug

``` shell
make qemudebug
```

in another shell:
``` shell
make gdb
```
