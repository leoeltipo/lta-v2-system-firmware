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

// Sequencer signals.
reg clk = 0;
reg stop_sync;
wire [31:0] seq_port_out;


// AXI signals.
reg aclk = 0;
reg aresetn;

wire [31 : 0] m_axi_awaddr;
wire [7 : 0] m_axi_awlen;
wire [2 : 0] m_axi_awsize;
wire [1 : 0] m_axi_awburst;
wire [0 : 0] m_axi_awlock;
wire [3 : 0] m_axi_awcache;
wire [2 : 0] m_axi_awprot;
wire [3 : 0] m_axi_awregion;
wire [3 : 0] m_axi_awqos;
wire m_axi_awvalid;
reg m_axi_awready;
wire [31 : 0] m_axi_wdata;
wire [3 : 0] m_axi_wstrb;
wire m_axi_wlast;
wire m_axi_wvalid;
reg m_axi_wready;
reg [1 : 0] m_axi_bresp;
reg m_axi_bvalid;
wire m_axi_bready;
wire [31 : 0] m_axi_araddr;
wire [7 : 0] m_axi_arlen;
wire [2 : 0] m_axi_arsize;
wire [1 : 0] m_axi_arburst;
wire [0 : 0] m_axi_arlock;
wire [3 : 0] m_axi_arcache;
wire [2 : 0] m_axi_arprot;
wire [3 : 0] m_axi_arregion;
wire [3 : 0] m_axi_arqos;
wire m_axi_arvalid;
reg m_axi_arready;
reg [31 : 0] m_axi_rdata;
reg [1 : 0] m_axi_rresp;
reg m_axi_rlast = 1'b1; // Not connected in AXI4Lite. Must be forced to '1' for READ operation to complete on VIP.
reg m_axi_rvalid;
wire m_axi_rready;

xil_axi_ulong   addr_stop       = 32'h44A00000; // 0
xil_axi_ulong   addr_eos        = 32'h44A00004; // 1
xil_axi_ulong   addr_wea        = 32'h44A00008; // 2
xil_axi_ulong   addr_addr       = 32'h44A0000c; // 3
xil_axi_ulong   addr_data       = 32'h44A00010; // 4
xil_axi_ulong   addr_stop_src   = 32'h44A00018; // 6
xil_axi_prot_t  prot = 0;
reg[31:0]       data_wr=32'h01234567;
reg[31:0]       data_rd=32'h01234567;
xil_axi_resp_t  resp;

integer seq_[10] = '{7, 1248, 724, 1073741828, 537916091, 3, 537915547, 3, 1610612740, 2147483648};

// Instantiate VIP.
axi_vip_0 axi_vip_i (
  .aclk(aclk),                      // input wire aclk
  .aresetn(aresetn),                // input wire aresetn
  .m_axi_awaddr(m_axi_awaddr),      // output wire [31 : 0] m_axi_awaddr
  .m_axi_awlen(m_axi_awlen),        // output wire [7 : 0] m_axi_awlen
  .m_axi_awsize(m_axi_awsize),      // output wire [2 : 0] m_axi_awsize
  .m_axi_awburst(m_axi_awburst),    // output wire [1 : 0] m_axi_awburst
  .m_axi_awlock(m_axi_awlock),      // output wire [0 : 0] m_axi_awlock
  .m_axi_awcache(m_axi_awcache),    // output wire [3 : 0] m_axi_awcache
  .m_axi_awprot(m_axi_awprot),      // output wire [2 : 0] m_axi_awprot
  .m_axi_awregion(m_axi_awregion),  // output wire [3 : 0] m_axi_awregion
  .m_axi_awqos(m_axi_awqos),        // output wire [3 : 0] m_axi_awqos
  .m_axi_awvalid(m_axi_awvalid),    // output wire m_axi_awvalid
  .m_axi_awready(m_axi_awready),    // input wire m_axi_awready
  .m_axi_wdata(m_axi_wdata),        // output wire [31 : 0] m_axi_wdata
  .m_axi_wstrb(m_axi_wstrb),        // output wire [3 : 0] m_axi_wstrb
  .m_axi_wlast(m_axi_wlast),        // output wire m_axi_wlast
  .m_axi_wvalid(m_axi_wvalid),      // output wire m_axi_wvalid
  .m_axi_wready(m_axi_wready),      // input wire m_axi_wready
  .m_axi_bresp(m_axi_bresp),        // input wire [1 : 0] m_axi_bresp
  .m_axi_bvalid(m_axi_bvalid),      // input wire m_axi_bvalid
  .m_axi_bready(m_axi_bready),      // output wire m_axi_bready
  .m_axi_araddr(m_axi_araddr),      // output wire [31 : 0] m_axi_araddr
  .m_axi_arlen(m_axi_arlen),        // output wire [7 : 0] m_axi_arlen
  .m_axi_arsize(m_axi_arsize),      // output wire [2 : 0] m_axi_arsize
  .m_axi_arburst(m_axi_arburst),    // output wire [1 : 0] m_axi_arburst
  .m_axi_arlock(m_axi_arlock),      // output wire [0 : 0] m_axi_arlock
  .m_axi_arcache(m_axi_arcache),    // output wire [3 : 0] m_axi_arcache
  .m_axi_arprot(m_axi_arprot),      // output wire [2 : 0] m_axi_arprot
  .m_axi_arregion(m_axi_arregion),  // output wire [3 : 0] m_axi_arregion
  .m_axi_arqos(m_axi_arqos),        // output wire [3 : 0] m_axi_arqos
  .m_axi_arvalid(m_axi_arvalid),    // output wire m_axi_arvalid
  .m_axi_arready(m_axi_arready),    // input wire m_axi_arready
  .m_axi_rdata(m_axi_rdata),        // input wire [31 : 0] m_axi_rdata
  .m_axi_rresp(m_axi_rresp),        // input wire [1 : 0] m_axi_rresp
  .m_axi_rlast(m_axi_rlast),        // input wire m_axi_rlast
  .m_axi_rvalid(m_axi_rvalid),      // input wire m_axi_rvalid
  .m_axi_rready(m_axi_rready)      // output wire m_axi_rready
);

// Instantiate DUT.    
sequencer_v1_01 DUT (
    .clk(clk),
    .stop_sync(stop_sync),		
    .seq_port_out(seq_port_out),
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
    
    // Init stop_sync.
    stop_sync = 0;
    
    // Reset sequence.
    aresetn = 0;    
    #200;
    aresetn = 1;    

    // Load sequencer.
    // 0 7
    // 1 1248
    // 2 724
    // 3 1073741828
    // 4 537916091
    // 5 3
    // 6 537915547
    // 7 3
    // 8 1610612740
    // 9 2147483648
    #50;
    
    // Load sequencer memory.
    for (int i=0; i<10; i++) begin
        data_wr = i;
        mst_agent.AXI4LITE_WRITE_BURST(addr_addr,prot,data_wr,resp);
        #10;
        data_wr = seq_[i];
        mst_agent.AXI4LITE_WRITE_BURST(addr_data,prot,data_wr,resp);
        #10;
        data_wr = 1;
        mst_agent.AXI4LITE_WRITE_BURST(addr_wea,prot,data_wr,resp);
        #10
        data_wr = 0;
        mst_agent.AXI4LITE_WRITE_BURST(addr_wea,prot,data_wr,resp);
        #10;
    end
    
    // Start the sequencer.
    data_wr = 1;
    mst_agent.AXI4LITE_WRITE_BURST(addr_stop,prot,data_wr,resp);
    #10;
    
    // Wait until sequencer has finished.    
    while (data_rd != 1) begin
        mst_agent.AXI4LITE_READ_BURST(addr_eos,prot,data_rd,resp);
        #50;
    end
    
    // Stop the sequencer.
    data_wr = 0;
    mst_agent.AXI4LITE_WRITE_BURST(addr_stop,prot,data_wr,resp);
    #10;
        
    // Set stop source to external.    
    data_wr = 1;
    mst_agent.AXI4LITE_WRITE_BURST(addr_stop_src,prot,data_wr,resp);
    #10;
    
    #100;
    
    // Start the sequencer.
    stop_sync = 1;

    // Wait until sequencer has finished.    
    while (data_rd != 1) begin
        mst_agent.AXI4LITE_READ_BURST(addr_eos,prot,data_rd,resp);
        #50;
    end
            
    #100;
end

// clk.
always begin
    #11; clk = ~clk;
end

// aclk.
always begin
    #10; aclk = ~aclk;
end    

//always begin
//    stop_sync = 0;
//    #200;
//    stop_sync = 1;
//    #200;
//end
endmodule
