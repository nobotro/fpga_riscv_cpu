create_clock   -period 20 [get_ports clk]
create_clock   -period 50 [get_ports  altera_reserved_tck]


derive_pll_clocks -create_base_clocks

derive_clock_uncertainty
