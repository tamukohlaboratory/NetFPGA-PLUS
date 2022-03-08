#
# Copyright (c) 2021 Yuta Tokusashi
# All rights reserved.
#
# This software was developed by the University of Cambridge Computer
# Laboratory under EPSRC EARL Project EP/P025374/1 alongside support
# from Xilinx Inc.
#
# @NETFPGA_LICENSE_HEADER_START@
#
# Licensed to NetFPGA C.I.C. (NetFPGA) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  NetFPGA licenses this
# file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at:
#
#   http://www.netfpga-cic.org
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
# @NETFPGA_LICENSE_HEADER_END@
#
#######################################################################
# General Clock
#######################################################################
set_property PACKAGE_PIN AY38 [get_ports sysclk_n];
set_property IOSTANDARD DIFF_SSTL12 [get_ports sysclk_n];
set_property PACKAGE_PIN AY37 [get_ports sysclk_p];
set_property IOSTANDARD DIFF_SSTL12 [get_ports sysclk_p];

#######################################################################
# PCIe
#######################################################################
set_property PACKAGE_PIN AM10 [get_ports pci_clk_n]
set_property PACKAGE_PIN AM11 [get_ports pci_clk_p]

set_property PULLUP true [get_ports pci_rst_n]
set_property IOSTANDARD LVCMOS12 [get_ports pci_rst_n]
set_property PACKAGE_PIN BD21 [get_ports pci_rst_n]
set_false_path -from [get_ports pci_rst_n]

#######################################################################
# CMAC
#######################################################################
# QSFP0_CLOCK
set_property PACKAGE_PIN K10 [get_ports QSFP0_CLOCK_N];
set_property PACKAGE_PIN K11 [get_ports QSFP0_CLOCK_P];

# QSFP0_PORT
set_property PACKAGE_PIN AT20 [get_ports QSFP0_FS[0]];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP0_FS[0]];
set_property PACKAGE_PIN AU22 [get_ports QSFP0_FS[1]];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP0_FS[1]];
set_property PACKAGE_PIN AT22 [get_ports QSFP0_RESET];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP0_RESET];

set_property PACKAGE_PIN BE21 [get_ports QSFP0_INTL];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP0_INTL];
set_property PACKAGE_PIN BD18 [get_ports QSFP0_LPMODE];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP0_LPMODE];
set_property PACKAGE_PIN BE20 [get_ports QSFP0_MODPRSL];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP0_MODPRSL];
set_property PACKAGE_PIN BE16 [get_ports QSFP0_MODSELL];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP0_MODSELL];
set_property PACKAGE_PIN BE17 [get_ports QSFP0_RESETL];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP0_RESETL];

# QSFP0_TX
set_property -dict { LOC K7 } [get_ports QSFP0_TX_P[3]]
set_property -dict { LOC K6 } [get_ports QSFP0_TX_N[3]]
set_property -dict { LOC L9 } [get_ports QSFP0_TX_P[2]]
set_property -dict { LOC L8 } [get_ports QSFP0_TX_N[2]]
set_property -dict { LOC M7 } [get_ports QSFP0_TX_P[1]]
set_property -dict { LOC M6 } [get_ports QSFP0_TX_N[1]]
set_property -dict { LOC N9 } [get_ports QSFP0_TX_P[0]]
set_property -dict { LOC N8 } [get_ports QSFP0_TX_N[0]]

# QSFP0_RX
set_property -dict { LOC K2 } [get_ports QSFP0_RX_P[3]]
set_property -dict { LOC K1 } [get_ports QSFP0_RX_N[3]]
set_property -dict { LOC L4 } [get_ports QSFP0_RX_P[2]]
set_property -dict { LOC L3 } [get_ports QSFP0_RX_N[2]]
set_property -dict { LOC M2 } [get_ports QSFP0_RX_P[1]]
set_property -dict { LOC M1 } [get_ports QSFP0_RX_N[1]]
set_property -dict { LOC N4 } [get_ports QSFP0_RX_P[0]]
set_property -dict { LOC N3 } [get_ports QSFP0_RX_N[0]]

# QSFP1_CLOCK
set_property PACKAGE_PIN P10 [get_ports QSFP1_CLOCK_N];
set_property PACKAGE_PIN P11 [get_ports QSFP1_CLOCK_P];

# QSFP1_PORT
set_property PACKAGE_PIN AR22 [get_ports QSFP1_FS[0]];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP1_FS[0]];
set_property PACKAGE_PIN AU20 [get_ports QSFP1_FS[1]];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP1_FS[1]];
set_property PACKAGE_PIN AR21 [get_ports QSFP1_RESET];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP1_RESET];
set_property PACKAGE_PIN AV21 [get_ports QSFP1_INTL];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP1_INTL];
set_property PACKAGE_PIN AV22 [get_ports QSFP1_LPMODE];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP1_LPMODE];
set_property PACKAGE_PIN BC19 [get_ports QSFP1_MODPRSL];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP1_MODPRSL];
set_property PACKAGE_PIN AY20 [get_ports QSFP1_MODSELL];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP1_MODSELL];
set_property PACKAGE_PIN BC18 [get_ports QSFP1_RESETL];
set_property IOSTANDARD LVCMOS12 [get_ports QSFP1_RESETL];

# QSFP1_TX
set_property -dict { LOC P7 } [get_ports QSFP1_TX_P[3]]
set_property -dict { LOC P6 } [get_ports QSFP1_TX_N[3]]
set_property -dict { LOC R9 } [get_ports QSFP1_TX_P[2]]
set_property -dict { LOC R8 } [get_ports QSFP1_TX_N[2]]
set_property -dict { LOC T7 } [get_ports QSFP1_TX_P[1]]
set_property -dict { LOC T6 } [get_ports QSFP1_TX_N[1]]
set_property -dict { LOC U9 } [get_ports QSFP1_TX_P[0]]
set_property -dict { LOC U8 } [get_ports QSFP1_TX_N[0]]

# QSFP1_RX
set_property -dict { LOC P2 } [get_ports QSFP1_RX_P[3]]
set_property -dict { LOC P1 } [get_ports QSFP1_RX_N[3]]
set_property -dict { LOC R4 } [get_ports QSFP1_RX_P[2]]
set_property -dict { LOC R3 } [get_ports QSFP1_RX_N[2]]
set_property -dict { LOC T2 } [get_ports QSFP1_RX_P[1]]
set_property -dict { LOC T1 } [get_ports QSFP1_RX_N[1]]
set_property -dict { LOC U4 } [get_ports QSFP1_RX_P[0]]
set_property -dict { LOC U3 } [get_ports QSFP1_RX_N[0]]

##########################################################################
# Timing
##########################################################################
create_clock -period 10.000 -name pci_clk -waveform {0.000 5.000} [get_ports pci_clk_p]

create_generated_clock -name reg_clk -source [get_pins u_nf_shell/xilinx_nic_shell/inst/qdma_subsystem_inst/qdma_wrapper_inst/clk_div_inst/inst/mmcme4_adv_inst/CLKIN1] -master_clock [get_clocks u_nf_shell/xilinx_nic_shell/inst/qdma_subsystem_inst/qdma_wrapper_inst/clk_div_inst/inst/clk_in1] [get_pins u_nf_shell/xilinx_nic_shell/inst/qdma_subsystem_inst/qdma_wrapper_inst/clk_div_inst/inst/mmcme4_adv_inst/CLKOUT0]
create_generated_clock -name dma_clk -source [get_pins u_nf_shell/xilinx_nic_shell/inst/qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4_ip_i/inst/qdma_no_sriov_pcie4_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/I] -master_clock [get_clocks u_nf_shell/xilinx_nic_shell/inst/qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4_ip_i/inst/qdma_no_sriov_pcie4_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/qdma_no_sriov_pcie4_ip_gt_i/inst/gen_gtwizard_gtye4_top.qdma_no_sriov_pcie4_ip_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[32].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK] [get_pins u_nf_shell/xilinx_nic_shell/inst/qdma_subsystem_inst/qdma_wrapper_inst/qdma_inst/inst/pcie4_ip_i/inst/qdma_no_sriov_pcie4_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/bufg_gt_userclk/O]
create_generated_clock -name sys_clk -source [get_pins u_clk_wiz_1/inst/mmcme4_adv_inst/CLKIN1] -master_clock [get_clocks sysclk_p] [get_pins u_clk_wiz_1/inst/mmcme4_adv_inst/CLKOUT0]
create_generated_clock -name mac0_clk -source [get_pins {u_nf_shell/xilinx_nic_shell/inst/cmac_port[0].cmac_subsystem_inst/cmac_wrapper_inst/cmac_inst/inst/cmac_usplus_0_gt_i/inst/gen_gtwizard_gtye4_top.cmac_usplus_0_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[35].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/QPLL0CLK}] -master_clock [get_clocks qpll0outclk_out[0]] [get_pins {u_nf_shell/xilinx_nic_shell/inst/cmac_port[0].cmac_subsystem_inst/cmac_wrapper_inst/cmac_inst/inst/cmac_usplus_0_gt_i/inst/gen_gtwizard_gtye4_top.cmac_usplus_0_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[35].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]
create_generated_clock -name mac1_clk -source [get_pins {u_nf_shell/xilinx_nic_shell/inst/cmac_port[1].cmac_subsystem_inst/cmac_wrapper_inst/cmac_inst/inst/cmac_usplus_1_gt_i/inst/gen_gtwizard_gtye4_top.cmac_usplus_1_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[36].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/QPLL0CLK}] -master_clock [get_clocks qpll0outclk_out[0]_1] [get_pins {u_nf_shell/xilinx_nic_shell/inst/cmac_port[1].cmac_subsystem_inst/cmac_wrapper_inst/cmac_inst/inst/cmac_usplus_1_gt_i/inst/gen_gtwizard_gtye4_top.cmac_usplus_1_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[36].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]

## ToDo sync regs
set_clock_groups -asynchronous -group [get_clocks reg_clk] -group [get_clocks sys_clk]
set_clock_groups -asynchronous -group [get_clocks sys_clk] -group [get_clocks reg_clk]
set_clock_groups -asynchronous -group [get_clocks reg_clk] -group [get_clocks dma_clk]
set_clock_groups -asynchronous -group [get_clocks dma_clk] -group [get_clocks reg_clk]
set_clock_groups -asynchronous -group [get_clocks reg_clk] -group [get_clocks mac0_clk]
set_clock_groups -asynchronous -group [get_clocks mac0_clk] -group [get_clocks reg_clk]
set_clock_groups -asynchronous -group [get_clocks reg_clk] -group [get_clocks mac1_clk]
set_clock_groups -asynchronous -group [get_clocks mac1_clk] -group [get_clocks reg_clk]

## Keep
set_clock_groups -asynchronous -group [get_clocks sys_clk] -group [get_clocks dma_clk]
set_clock_groups -asynchronous -group [get_clocks dma_clk] -group [get_clocks sys_clk]
set_clock_groups -asynchronous -group [get_clocks sys_clk] -group [get_clocks mac0_clk]
set_clock_groups -asynchronous -group [get_clocks mac0_clk] -group [get_clocks sys_clk]
set_clock_groups -asynchronous -group [get_clocks sys_clk] -group [get_clocks mac1_clk]
set_clock_groups -asynchronous -group [get_clocks mac1_clk] -group [get_clocks sys_clk]
