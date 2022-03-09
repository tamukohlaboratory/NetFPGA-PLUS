`timescale 1ns / 1ps
//-
// Copyright (c) 2015 Noa Zilberman
// Copyright (c) 2021 Yuta Tokusashi
// All rights reserved.
//
// This software was developed by Stanford University and the University of Cambridge Computer Laboratory 
// under National Science Foundation under Grant No. CNS-0855268,
// the University of Cambridge Computer Laboratory under EPSRC INTERNET Project EP/H040536/1 and
// by the University of Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-11-C-0249 ("MRC2"), 
// as part of the DARPA MRC research programme,
// and by the University of Cambridge Computer Laboratory under EPSRC EARL Project
// EP/P025374/1 alongside support from Xilinx Inc.
//
//  File:
//        nf_datapath.v
//
//  Module:
//        nf_datapath
//
//  Author: Noa Zilberman
//
//  Description:
//        NetFPGA user data path wrapper, wrapping input arbiter, output port lookup and output queues
//
//
// @NETFPGA_LICENSE_HEADER_START@
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// @NETFPGA_LICENSE_HEADER_END@
//


module nf_datapath #(
    //Slave AXI parameters
    parameter C_S_AXI_DATA_WIDTH    = 32,          
    parameter C_S_AXI_ADDR_WIDTH    = 32,          
    parameter C_BASEADDR            = 32'h00000000,

    // Master AXI Stream Data Width
    parameter C_M_AXIS_DATA_WIDTH=512,
    parameter C_S_AXIS_DATA_WIDTH=512,
    parameter C_M_AXIS_TUSER_WIDTH=128,
    parameter C_S_AXIS_TUSER_WIDTH=128,
    parameter NUM_QUEUES=5
) (
    //Datapath clock
    input                                     axis_aclk,
    input                                     axis_resetn,
    //Registers clock
    input                                     axi_aclk,
    input                                     axi_resetn,

    // Slave AXI Ports
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S0_AXI_AWADDR,
    input                                     S0_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S0_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S0_AXI_WSTRB,
    input                                     S0_AXI_WVALID,
    input                                     S0_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S0_AXI_ARADDR,
    input                                     S0_AXI_ARVALID,
    input                                     S0_AXI_RREADY,
    output                                    S0_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S0_AXI_RDATA,
    output     [1 : 0]                        S0_AXI_RRESP,
    output                                    S0_AXI_RVALID,
    output                                    S0_AXI_WREADY,
    output     [1 :0]                         S0_AXI_BRESP,
    output                                    S0_AXI_BVALID,
    output                                    S0_AXI_AWREADY,
    
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S1_AXI_AWADDR,
    input                                     S1_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S1_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S1_AXI_WSTRB,
    input                                     S1_AXI_WVALID,
    input                                     S1_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S1_AXI_ARADDR,
    input                                     S1_AXI_ARVALID,
    input                                     S1_AXI_RREADY,
    output                                    S1_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S1_AXI_RDATA,
    output     [1 : 0]                        S1_AXI_RRESP,
    output                                    S1_AXI_RVALID,
    output                                    S1_AXI_WREADY,
    output     [1 :0]                         S1_AXI_BRESP,
    output                                    S1_AXI_BVALID,
    output                                    S1_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S2_AXI_AWADDR,
    input                                     S2_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S2_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S2_AXI_WSTRB,
    input                                     S2_AXI_WVALID,
    input                                     S2_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S2_AXI_ARADDR,
    input                                     S2_AXI_ARVALID,
    input                                     S2_AXI_RREADY,
    output                                    S2_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S2_AXI_RDATA,
    output     [1 : 0]                        S2_AXI_RRESP,
    output                                    S2_AXI_RVALID,
    output                                    S2_AXI_WREADY,
    output     [1 :0]                         S2_AXI_BRESP,
    output                                    S2_AXI_BVALID,
    output                                    S2_AXI_AWREADY,

    
    // Slave Stream Ports (interface from Rx queues)
    input [C_S_AXIS_DATA_WIDTH - 1:0]         s_axis_0_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_0_tkeep,
    input [C_S_AXIS_TUSER_WIDTH-1:0]          s_axis_0_tuser,
    input                                     s_axis_0_tvalid,
    output                                    s_axis_0_tready,
    input                                     s_axis_0_tlast,
    input [C_S_AXIS_DATA_WIDTH - 1:0]         s_axis_1_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_1_tkeep,
    input [C_S_AXIS_TUSER_WIDTH-1:0]          s_axis_1_tuser,
    input                                     s_axis_1_tvalid,
    output                                    s_axis_1_tready,
    input                                     s_axis_1_tlast,
    input [C_S_AXIS_DATA_WIDTH - 1:0]         s_axis_2_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_2_tkeep,
    input [C_S_AXIS_TUSER_WIDTH-1:0]          s_axis_2_tuser,
    input                                     s_axis_2_tvalid,
    output                                    s_axis_2_tready,
    input                                     s_axis_2_tlast,


    // Master Stream Ports (interface to TX queues)
    output [C_M_AXIS_DATA_WIDTH - 1:0]         m_axis_0_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_0_tkeep,
    output [C_M_AXIS_TUSER_WIDTH-1:0]          m_axis_0_tuser,
    output                                     m_axis_0_tvalid,
    input                                      m_axis_0_tready,
    output                                     m_axis_0_tlast,
    output [C_M_AXIS_DATA_WIDTH - 1:0]         m_axis_1_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_1_tkeep,
    output [C_M_AXIS_TUSER_WIDTH-1:0]          m_axis_1_tuser,
    output                                     m_axis_1_tvalid,
    input                                      m_axis_1_tready,
    output                                     m_axis_1_tlast,
    output [C_M_AXIS_DATA_WIDTH - 1:0]         m_axis_2_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_2_tkeep,
    output [C_M_AXIS_TUSER_WIDTH-1:0]          m_axis_2_tuser,
    output                                     m_axis_2_tvalid,
    input                                      m_axis_2_tready,
    output                                     m_axis_2_tlast

    );
    
    //internal connectivity
    wire [C_S_AXI_ADDR_WIDTH-1 : 0]   M0_AXI_AWADDR;
    wire                              M0_AXI_AWVALID;
    wire [C_S_AXI_DATA_WIDTH-1 : 0]   M0_AXI_WDATA;
    wire [C_S_AXI_DATA_WIDTH/8-1 : 0] M0_AXI_WSTRB;
    wire                              M0_AXI_WVALID;
    wire                              M0_AXI_BREADY;
    wire [C_S_AXI_ADDR_WIDTH-1 : 0]   M0_AXI_ARADDR;
    wire                              M0_AXI_ARVALID;
    wire                              M0_AXI_RREADY;
    wire                              M0_AXI_ARREADY;
    wire [C_S_AXI_DATA_WIDTH-1 : 0]   M0_AXI_RDATA;
    wire [1 : 0]                      M0_AXI_RRESP;
    wire                              M0_AXI_RVALID;
    wire                              M0_AXI_WREADY;
    wire [1 :0]                       M0_AXI_BRESP;
    wire                              M0_AXI_BVALID;
    wire                              M0_AXI_AWREADY;
    wire [C_S_AXI_ADDR_WIDTH-1 : 0]   M2_AXI_AWADDR;
    wire                              M2_AXI_AWVALID;
    wire [C_S_AXI_DATA_WIDTH-1 : 0]   M2_AXI_WDATA;
    wire [C_S_AXI_DATA_WIDTH/8-1 : 0] M2_AXI_WSTRB;
    wire                              M2_AXI_WVALID;
    wire                              M2_AXI_BREADY;
    wire [C_S_AXI_ADDR_WIDTH-1 : 0]   M2_AXI_ARADDR;
    wire                              M2_AXI_ARVALID;
    wire                              M2_AXI_RREADY;
    wire                              M2_AXI_ARREADY;
    wire [C_S_AXI_DATA_WIDTH-1 : 0]   M2_AXI_RDATA;
    wire [1 : 0]                      M2_AXI_RRESP;
    wire                              M2_AXI_RVALID;
    wire                              M2_AXI_WREADY;
    wire [1 :0]                       M2_AXI_BRESP;
    wire                              M2_AXI_BVALID;
    wire                              M2_AXI_AWREADY;


    wire [C_M_AXIS_DATA_WIDTH - 1:0]         m_axis_opl_tdata;
    wire [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_opl_tkeep;
    wire [C_M_AXIS_TUSER_WIDTH-1:0]          m_axis_opl_tuser;
    wire                                     m_axis_opl_tvalid;
    wire                                     m_axis_opl_tready;
    wire                                     m_axis_opl_tlast;
    wire [C_M_AXIS_DATA_WIDTH - 1:0]         s_axis_opl_tdata;
    wire [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_opl_tkeep;
    wire [C_M_AXIS_TUSER_WIDTH-1:0]          s_axis_opl_tuser;
    wire                                     s_axis_opl_tvalid;
    wire                                     s_axis_opl_tready;
    wire                                     s_axis_opl_tlast;

  axi_clock_converter_ip #(
    // .C_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH),
    // .C_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)
  ) u_clk_conv_0 (
    .s_axi_aclk    (axi_aclk),
    .s_axi_aresetn (axi_resetn),
    .s_axi_awaddr  (S0_AXI_AWADDR),
    .s_axi_awprot  (3'b000),
    .s_axi_awvalid (S0_AXI_AWVALID),
    .s_axi_awready (S0_AXI_AWREADY),
    .s_axi_wdata   (S0_AXI_WDATA  ),
    .s_axi_wstrb   (S0_AXI_WSTRB  ),
    .s_axi_wvalid  (S0_AXI_WVALID),
    .s_axi_wready  (S0_AXI_WREADY),
    .s_axi_bresp   (S0_AXI_BRESP ),
    .s_axi_bvalid  (S0_AXI_BVALID),
    .s_axi_bready  (S0_AXI_BREADY),
    .s_axi_araddr  (S0_AXI_ARADDR),
    .s_axi_arprot  (3'b000),
    .s_axi_arvalid (S0_AXI_ARVALID),
    .s_axi_arready (S0_AXI_ARREADY),
    .s_axi_rdata   (S0_AXI_RDATA  ),
    .s_axi_rresp   (S0_AXI_RRESP  ),
    .s_axi_rvalid  (S0_AXI_RVALID ),
    .s_axi_rready  (S0_AXI_RREADY ),
    .m_axi_aclk    (axis_aclk),
    .m_axi_aresetn (axis_resetn),
    .m_axi_awaddr  (M0_AXI_AWADDR),
    .m_axi_awprot  (),
    .m_axi_awvalid (M0_AXI_AWVALID),
    .m_axi_awready (M0_AXI_AWREADY ),
    .m_axi_wdata   (M0_AXI_WDATA),
    .m_axi_wstrb   (M0_AXI_WSTRB),
    .m_axi_wvalid  (M0_AXI_WVALID),
    .m_axi_wready  (M0_AXI_WREADY),
    .m_axi_bresp   (M0_AXI_BRESP ),
    .m_axi_bvalid  (M0_AXI_BVALID),
    .m_axi_bready  (M0_AXI_BREADY),
    .m_axi_araddr  (M0_AXI_ARADDR),
    .m_axi_arprot  (),
    .m_axi_arvalid (M0_AXI_ARVALID),
    .m_axi_arready (M0_AXI_ARREADY),
    .m_axi_rdata   (M0_AXI_RDATA  ),
    .m_axi_rresp   (M0_AXI_RRESP  ),
    .m_axi_rvalid  (M0_AXI_RVALID ),
    .m_axi_rready  (M0_AXI_RREADY )
  );

  axi_clock_converter_ip #(
    // .C_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH),
    // .C_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH)
  ) u_clk_conv_2 (
    .s_axi_aclk    (axi_aclk),
    .s_axi_aresetn (axi_resetn),
    .s_axi_awaddr  (S2_AXI_AWADDR),
    .s_axi_awprot  (3'b000),
    .s_axi_awvalid (S2_AXI_AWVALID),
    .s_axi_awready (S2_AXI_AWREADY),
    .s_axi_wdata   (S2_AXI_WDATA  ),
    .s_axi_wstrb   (S2_AXI_WSTRB  ),
    .s_axi_wvalid  (S2_AXI_WVALID),
    .s_axi_wready  (S2_AXI_WREADY),
    .s_axi_bresp   (S2_AXI_BRESP ),
    .s_axi_bvalid  (S2_AXI_BVALID),
    .s_axi_bready  (S2_AXI_BREADY),
    .s_axi_araddr  (S2_AXI_ARADDR),
    .s_axi_arprot  (3'b000),
    .s_axi_arvalid (S2_AXI_ARVALID),
    .s_axi_arready (S2_AXI_ARREADY),
    .s_axi_rdata   (S2_AXI_RDATA  ),
    .s_axi_rresp   (S2_AXI_RRESP  ),
    .s_axi_rvalid  (S2_AXI_RVALID ),
    .s_axi_rready  (S2_AXI_RREADY ),
    .m_axi_aclk    (axis_aclk),
    .m_axi_aresetn (axis_resetn),
    .m_axi_awaddr  (M2_AXI_AWADDR),
    .m_axi_awprot  (),
    .m_axi_awvalid (M2_AXI_AWVALID),
    .m_axi_awready (M2_AXI_AWREADY ),
    .m_axi_wdata   (M2_AXI_WDATA),
    .m_axi_wstrb   (M2_AXI_WSTRB),
    .m_axi_wvalid  (M2_AXI_WVALID),
    .m_axi_wready  (M2_AXI_WREADY),
    .m_axi_bresp   (M2_AXI_BRESP ),
    .m_axi_bvalid  (M2_AXI_BVALID),
    .m_axi_bready  (M2_AXI_BREADY),
    .m_axi_araddr  (M2_AXI_ARADDR),
    .m_axi_arprot  (),
    .m_axi_arvalid (M2_AXI_ARVALID),
    .m_axi_arready (M2_AXI_ARREADY),
    .m_axi_rdata   (M2_AXI_RDATA  ),
    .m_axi_rresp   (M2_AXI_RRESP  ),
    .m_axi_rvalid  (M2_AXI_RVALID ),
    .m_axi_rready  (M2_AXI_RREADY )
  );


  //Input Arbiter
  input_arbiter_ip  input_arbiter_v1_0 (
      .axis_aclk(axis_aclk), 
      .axis_resetn(axis_resetn), 
      .m_axis_tdata (s_axis_opl_tdata), 
      .m_axis_tkeep (s_axis_opl_tkeep), 
      .m_axis_tuser (s_axis_opl_tuser), 
      .m_axis_tvalid(s_axis_opl_tvalid), 
      .m_axis_tready(s_axis_opl_tready), 
      .m_axis_tlast (s_axis_opl_tlast), 
      .s_axis_0_tdata (s_axis_0_tdata), 
      .s_axis_0_tkeep (s_axis_0_tkeep), 
      .s_axis_0_tuser (s_axis_0_tuser), 
      .s_axis_0_tvalid(s_axis_0_tvalid), 
      .s_axis_0_tready(s_axis_0_tready), 
      .s_axis_0_tlast (s_axis_0_tlast), 
      .s_axis_1_tdata (s_axis_1_tdata), 
      .s_axis_1_tkeep (s_axis_1_tkeep), 
      .s_axis_1_tuser (s_axis_1_tuser), 
      .s_axis_1_tvalid(s_axis_1_tvalid), 
      .s_axis_1_tready(s_axis_1_tready), 
      .s_axis_1_tlast (s_axis_1_tlast), 
      .s_axis_2_tdata (s_axis_2_tdata), 
      .s_axis_2_tkeep (s_axis_2_tkeep), 
      .s_axis_2_tuser (s_axis_2_tuser), 
      .s_axis_2_tvalid(s_axis_2_tvalid), 
      .s_axis_2_tready(s_axis_2_tready), 
      .s_axis_2_tlast (s_axis_2_tlast), 
      .S_AXI_AWADDR(M0_AXI_AWADDR), 
      .S_AXI_AWVALID(M0_AXI_AWVALID),
      .S_AXI_WDATA(M0_AXI_WDATA),  
      .S_AXI_WSTRB(M0_AXI_WSTRB),  
      .S_AXI_WVALID(M0_AXI_WVALID), 
      .S_AXI_BREADY(M0_AXI_BREADY), 
      .S_AXI_ARADDR(M0_AXI_ARADDR), 
      .S_AXI_ARVALID(M0_AXI_ARVALID),
      .S_AXI_RREADY(M0_AXI_RREADY), 
      .S_AXI_ARREADY(M0_AXI_ARREADY),
      .S_AXI_RDATA(M0_AXI_RDATA),  
      .S_AXI_RRESP(M0_AXI_RRESP),  
      .S_AXI_RVALID(M0_AXI_RVALID), 
      .S_AXI_WREADY(M0_AXI_WREADY), 
      .S_AXI_BRESP(M0_AXI_BRESP),  
      .S_AXI_BVALID(M0_AXI_BVALID), 
      .S_AXI_AWREADY(M0_AXI_AWREADY),
      .S_AXI_ACLK (axis_aclk), 
      .S_AXI_ARESETN(axis_resetn)
    );
    
     //Output Port Lookup  
       design_1 design_1_i (
      .axis_aclk(axis_aclk),
      .axis_resetn(axis_resetn),
      .M0_AXIS_tdata(m_axis_opl_tdata),
      .M0_AXIS_tkeep(m_axis_opl_tkeep),
      .M0_AXIS_tuser(m_axis_opl_tuser),
      .M0_AXIS_tvalid(m_axis_opl_tvalid),
      .M0_AXIS_tready(m_axis_opl_tready),
      .M0_AXIS_tlast(m_axis_opl_tlast),
      .S0_AXIS_tdata(s_axis_opl_tdata),
      .S0_AXIS_tkeep(s_axis_opl_tkeep),
      .S0_AXIS_tuser(s_axis_opl_tuser),
      .S0_AXIS_tvalid(s_axis_opl_tvalid),
      .S0_AXIS_tready(s_axis_opl_tready),
      .S0_AXIS_tlast(s_axis_opl_tlast),
      .axi_aclk(axi_aclk),
      .axi_aresetn(axi_resetn),
      .S00_AXI_awaddr(S1_AXI_AWADDR),
      .S00_AXI_awvalid(S1_AXI_AWVALID),
      .S00_AXI_wdata(S1_AXI_WDATA),
      .S00_AXI_wstrb(S1_AXI_WSTRB),
      .S00_AXI_wvalid(S1_AXI_WVALID),
      .S00_AXI_bready(S1_AXI_BREADY),
      .S00_AXI_araddr(S1_AXI_ARADDR),
      .S00_AXI_arvalid(S1_AXI_ARVALID),
      .S00_AXI_rready(S1_AXI_RREADY),
      .S00_AXI_arready(S1_AXI_ARREADY),
      .S00_AXI_rdata(S1_AXI_RDATA),
      .S00_AXI_rresp(S1_AXI_RRESP),
      .S00_AXI_rvalid(S1_AXI_RVALID),
      .S00_AXI_wready(S1_AXI_WREADY),
      .S00_AXI_bresp(S1_AXI_BRESP),
      .S00_AXI_bvalid(S1_AXI_BVALID),
      .S00_AXI_awready(S1_AXI_AWREADY)
  );


      //Output queues
       output_queues_ip  bram_output_queues_1 (
      .axis_aclk(axis_aclk), 
      .axis_resetn(axis_resetn), 
      .s_axis_tdata   (m_axis_opl_tdata), 
      .s_axis_tkeep   (m_axis_opl_tkeep), 
      .s_axis_tuser   (m_axis_opl_tuser), 
      .s_axis_tvalid  (m_axis_opl_tvalid), 
      .s_axis_tready  (m_axis_opl_tready), 
      .s_axis_tlast   (m_axis_opl_tlast), 
      .m_axis_0_tdata (m_axis_0_tdata), 
      .m_axis_0_tkeep (m_axis_0_tkeep), 
      .m_axis_0_tuser (m_axis_0_tuser), 
      .m_axis_0_tvalid(m_axis_0_tvalid), 
      .m_axis_0_tready(m_axis_0_tready), 
      .m_axis_0_tlast (m_axis_0_tlast), 
      .m_axis_1_tdata (m_axis_1_tdata), 
      .m_axis_1_tkeep (m_axis_1_tkeep), 
      .m_axis_1_tuser (m_axis_1_tuser), 
      .m_axis_1_tvalid(m_axis_1_tvalid), 
      .m_axis_1_tready(m_axis_1_tready), 
      .m_axis_1_tlast (m_axis_1_tlast), 
      .m_axis_2_tdata (m_axis_2_tdata), 
      .m_axis_2_tkeep (m_axis_2_tkeep), 
      .m_axis_2_tuser (m_axis_2_tuser), 
      .m_axis_2_tvalid(m_axis_2_tvalid), 
      .m_axis_2_tready(m_axis_2_tready), 
      .m_axis_2_tlast (m_axis_2_tlast), 
      .bytes_stored(), 
      .pkt_stored(), 
      .bytes_removed_0(), 
      .bytes_removed_1(), 
      .bytes_removed_2(), 
      .pkt_removed_0(), 
      .pkt_removed_1(), 
      .pkt_removed_2(), 
      .bytes_dropped(), 
      .pkt_dropped(), 

      .S_AXI_AWADDR(M2_AXI_AWADDR), 
      .S_AXI_AWVALID(M2_AXI_AWVALID),
      .S_AXI_WDATA(M2_AXI_WDATA),  
      .S_AXI_WSTRB(M2_AXI_WSTRB),  
      .S_AXI_WVALID(M2_AXI_WVALID), 
      .S_AXI_BREADY(M2_AXI_BREADY), 
      .S_AXI_ARADDR(M2_AXI_ARADDR), 
      .S_AXI_ARVALID(M2_AXI_ARVALID),
      .S_AXI_RREADY(M2_AXI_RREADY), 
      .S_AXI_ARREADY(M2_AXI_ARREADY),
      .S_AXI_RDATA(M2_AXI_RDATA),  
      .S_AXI_RRESP(M2_AXI_RRESP),  
      .S_AXI_RVALID(M2_AXI_RVALID), 
      .S_AXI_WREADY(M2_AXI_WREADY), 
      .S_AXI_BRESP(M2_AXI_BRESP),  
      .S_AXI_BVALID(M2_AXI_BVALID), 
      .S_AXI_AWREADY(M2_AXI_AWREADY),
      .S_AXI_ACLK (axis_aclk), 
      .S_AXI_ARESETN(axis_resetn)
    ); 
    
endmodule
