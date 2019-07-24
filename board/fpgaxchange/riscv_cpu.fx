###############################################################################
# Copyright (C) 1991-2019 Altera Corporation. All rights reserved.
# Any  megafunction  design,  and related netlist (encrypted  or  decrypted),
# support information,  device programming or simulation file,  and any other
# associated  documentation or information  provided by  Intel  or a partner
# under  Intel's   Megafunction   Partnership   Program  may  be  used  only
# to program  PLD  devices (but not masked  PLD  devices) from  Intel.   Any
# other  use  of such  megafunction  design,  netlist,  support  information,
# device programming or simulation file,  or any other  related documentation
# or information  is prohibited  for  any  other purpose,  including, but not
# limited to  modification,  reverse engineering,  de-compiling, or use  with
# any other  silicon devices,  unless such use is  explicitly  licensed under
# a separate agreement with  Intel  or a megafunction partner.  Title to the
# intellectual property,  including patents,  copyrights,  trademarks,  trade
# secrets,  or maskworks,  embodied in any such megafunction design, netlist,
# support  information,  device programming or simulation file,  or any other
# related documentation or information provided by  Intel  or a megafunction
# partner, remains with Intel, the megafunction partner, or their respective
# licensors. No other licenses, including any licenses needed under any third
# party's intellectual property, are provided herein.
#
###############################################################################


# FPGA Xchange file generated using Quartus Prime Version 18.1.1 Build 646 04/11/2019 SJ Lite Edition

# DESIGN=riscv_cpu
# REVISION=riscv_cpu
# DEVICE=EP4CE6
# PACKAGE=TQFP
# SPEEDGRADE=8

Signal Name,Pin Number,Direction,IO Standard,Drive (mA),Termination,Slew Rate,Swap Group,Diff Type

reset,25,input,2.5 V,,Off,--,swap_0,--
ledss[0],87,output,2.5 V,Default,Series 50 Ohm without Calibration,FAST,swap_1,--
ledss[1],86,output,2.5 V,Default,Series 50 Ohm without Calibration,FAST,swap_1,--
ledss[2],85,output,2.5 V,Default,Series 50 Ohm without Calibration,FAST,swap_1,--
ledss[3],84,output,2.5 V,Default,Series 50 Ohm without Calibration,FAST,swap_1,--
clk,23,input,2.5 V,,Off,--,swap_0,--
altera_reserved_tms,18,input,2.5 V,,Off,--,NOSWAP,--
altera_reserved_tck,16,input,2.5 V,,Off,--,NOSWAP,--
altera_reserved_tdi,15,input,2.5 V,,Off,--,NOSWAP,--
altera_reserved_tdo,20,output,2.5 V,Default,Off,FAST,NOSWAP,--
~ALTERA_ASDO_DATA1~,6,input,2.5 V,,Off,--,NOSWAP,--
~ALTERA_FLASH_nCE_nCSO~,8,input,2.5 V,,Off,--,NOSWAP,--
~ALTERA_DCLK~,12,output,2.5 V,Default,Off,FAST,NOSWAP,--
~ALTERA_DATA0~,13,input,2.5 V,,Off,--,NOSWAP,--
~ALTERA_nCEO~,101,output,2.5 V,8,Off,FAST,NOSWAP,--
