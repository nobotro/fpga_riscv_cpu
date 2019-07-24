cd {/home/home/fpgaworkspace/riscv_cpu/}

echo "Creating library"
vlib ./work
vmap work ./work

echo "Adding library"
vlib altera_mf_ver
vmap altera_mf_ver ./altera_mf_ver

echo "Compiling library"
vlog -work ./altera_mf_ver /home/home/intelFPGA_lite/18.1/quartus/eda//sim_lib/altera_mf.v

echo "Compiling modules"
vlog -work ./work riscv_cpu.v
vlog -work ./work ramm.v

echo "Load/Simulate the design"
vsim -L altera_mf_ver riscv_cpu -t ns
force -freeze sim:/riscv_cpu/clk 1 0, 0 {50 ns} -r 100
