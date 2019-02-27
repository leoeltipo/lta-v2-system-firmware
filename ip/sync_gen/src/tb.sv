`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2019 01:38:28 PM
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import axi_vip_pkg::*;
import axi_vip_0_pkg::*;

module tb(
    );

// Sync Generator signals.
reg clk_low = 0;
reg clk_high = 0;
reg sel;
reg sync_in;
wire sync_out;
wire stop_sync;  

// AXI signals.
reg aclk = 0;
reg aresetn;
wire [31:0] m_axi_awaddr;
wire [2:0] m_axi_awprot;
wire m_axi_awvalid;
wire m_axi_awready;
wire [31:0] m_axi_wdata;
wire [3:0] m_axi_wstrb;
wire m_axi_wvalid;
wire m_axi_wready;
wire [1:0] m_axi_bresp;
wire m_axi_bvalid;
wire m_axi_bready;
wire [31:0] m_axi_araddr;
wire [2:0] m_axi_arprot;
wire m_axi_arvalid;
wire m_axi_arready;
wire [31:0] m_axi_rdata;
wire [1:0] m_axi_rresp;
wire m_axi_rvalid;
wire m_axi_rready;

xil_axi_ulong   addr_stop       = 32'h44A00000; // 0
xil_axi_ulong   addr_delay      = 32'h44A00004; // 1

xil_axi_prot_t  prot = 0;
reg[31:0]       data_wr=32'h01234567;
reg[31:0]       data_rd=32'h01234567;
xil_axi_resp_t  resp;

// Instantiate VIP.
axi_vip_0 axi_vip_i (
  .aclk(aclk),                    // input wire aclk
  .aresetn(aresetn),              // input wire aresetn
  .m_axi_awaddr(m_axi_awaddr),    // output wire [31 : 0] m_axi_awaddr
  .m_axi_awprot(m_axi_awprot),    // output wire [2 : 0] m_axi_awprot
  .m_axi_awvalid(m_axi_awvalid),  // output wire m_axi_awvalid
  .m_axi_awready(m_axi_awready),  // input wire m_axi_awready
  .m_axi_wdata(m_axi_wdata),      // output wire [31 : 0] m_axi_wdata
  .m_axi_wstrb(m_axi_wstrb),      // output wire [3 : 0] m_axi_wstrb
  .m_axi_wvalid(m_axi_wvalid),    // output wire m_axi_wvalid
  .m_axi_wready(m_axi_wready),    // input wire m_axi_wready
  .m_axi_bresp(m_axi_bresp),      // input wire [1 : 0] m_axi_bresp
  .m_axi_bvalid(m_axi_bvalid),    // input wire m_axi_bvalid
  .m_axi_bready(m_axi_bready),    // output wire m_axi_bready
  .m_axi_araddr(m_axi_araddr),    // output wire [31 : 0] m_axi_araddr
  .m_axi_arprot(m_axi_arprot),    // output wire [2 : 0] m_axi_arprot
  .m_axi_arvalid(m_axi_arvalid),  // output wire m_axi_arvalid
  .m_axi_arready(m_axi_arready),  // input wire m_axi_arready
  .m_axi_rdata(m_axi_rdata),      // input wire [31 : 0] m_axi_rdata
  .m_axi_rresp(m_axi_rresp),      // input wire [1 : 0] m_axi_rresp
  .m_axi_rvalid(m_axi_rvalid),    // input wire m_axi_rvalid
  .m_axi_rready(m_axi_rready)    // output wire m_axi_rready
);

// Instantiate DUT.    
sync_gen_v1_0 DUT (
    .clk_low(clk_low),
    .clk_high(clk_high),
    .sel(sel),
    .sync_in(sync_in),
    .sync_out(sync_out),
    .stop_sync(stop_sync),               
	.s00_axi_aclk(aclk),
	.s00_axi_aresetn(aresetn),
	.s00_axi_awaddr(m_axi_awaddr),
	.s00_axi_awprot(m_axi_awprot),
	.s00_axi_awvalid(m_axi_awvalid),
	.s00_axi_awready(m_axi_awready),
	.s00_axi_wdata(m_axi_wdata),
	.s00_axi_wstrb(m_axi_wstrb),
	.s00_axi_wvalid(m_axi_wvalid),
	.s00_axi_wready(m_axi_wready),
	.s00_axi_bresp(m_axi_bresp),
	.s00_axi_bvalid(m_axi_bvalid),
	.s00_axi_bready(m_axi_bready),
	.s00_axi_araddr(m_axi_araddr),
	.s00_axi_arprot(m_axi_arprot),
	.s00_axi_arvalid(m_axi_arvalid),
	.s00_axi_arready(m_axi_arready),
	.s00_axi_rdata(m_axi_rdata),
	.s00_axi_rresp(m_axi_rresp),
	.s00_axi_rvalid(m_axi_rvalid),
	.s00_axi_rready(m_axi_rready)
);

// Declare AXI master VIP agent.
axi_vip_0_mst_t mst_agent;

initial begin
    // Create an agent.
    mst_agent = new("master vip agent", axi_vip_i.inst.IF);
    
    // Set tag for agent to ease debug.
    mst_agent.set_agent_tag("Master VIP");
    
    // Set print verbosity level.
    mst_agent.set_verbosity(400);
    
    // Start the agent.
    mst_agent.start_master();
    
    // Init.
    sel = 0;
    sync_in = 0;
    
    // Reset sequence.
    aresetn = 0;    
    #200;
    aresetn = 1;    
    #200;
    
    // Set delay.
    data_wr = 5;
    mst_agent.AXI4LITE_WRITE_BURST(addr_delay,prot,data_wr,resp);
    #10;    
    
    // Start the sequencer.
    data_wr = 1;
    mst_agent.AXI4LITE_WRITE_BURST(addr_stop,prot,data_wr,resp);
    #10;
    
    #1000;
    
    // Stop the sequencer.
    data_wr = 0;
    mst_agent.AXI4LITE_WRITE_BURST(addr_stop,prot,data_wr,resp);
    #10;
    
    #500;
    
    // Change to slave mode.
    sel = 1;
    #10;    
    
    // Start the sequencer (should not have any effect).
    data_wr = 1;
    mst_agent.AXI4LITE_WRITE_BURST(addr_stop,prot,data_wr,resp);
    #10;  
    
    #800;
    
    // Start the sequencer with external trigger.
    sync_in = 1;
    #2500;
    
    // Stop the sequencer.
    sync_in = 0;
    #500;
          
    #100;
end

// clk_low.
always begin
    #100; clk_low = ~clk_low;
end

// clk_high.
always begin
    #10; clk_high = ~clk_high;
end

// aclk.
always begin
    #9; aclk = ~aclk;
end    

endmodule
