# Baremetel riscv program example

[![asciicast](https://asciinema.org/a/551075.svg)](https://asciinema.org/a/551075)

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
