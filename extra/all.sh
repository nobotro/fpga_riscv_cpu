
rm *.o
rm *.out
riscv32-unknown-elf-gcc -O0  starter.s led2.c -ffreestanding -fno-stack-protector  -fno-pie -march=rv32i -c&&riscv32-unknown-elf-ld starter.o led2.o  -T link.ld&&rom=$(elf2hex --input a.out --bit-width 32)&&python romgen.py  "$rom"
