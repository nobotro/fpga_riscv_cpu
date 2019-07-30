transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/home/fpgaworkspace/riscv_cpu {/home/home/fpgaworkspace/riscv_cpu/riscv_cpu.v}
vlog -vlog01compat -work work +incdir+/home/home/fpgaworkspace/riscv_cpu {/home/home/fpgaworkspace/riscv_cpu/ramm.v}

