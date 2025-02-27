# *************************************************************************
#
# Copyright 2020 Xilinx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# *************************************************************************

set_false_path -through [get_ports pci_rst_n]

set axis_aclk [get_clocks -of_object [get_nets u_nf_shell/xilinx_nic_shell/axis_aclk]]

foreach cmac_clk [get_clocks -of_object [get_nets u_nf_shell/xilinx_nic_shell/cmac_clk*]] {
	set_max_delay -datapath_only -from $axis_aclk -to $cmac_clk 4.000
	set_max_delay -datapath_only -from $cmac_clk -to $axis_aclk 3.103
}
