//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom interfaces
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//===================================================================================
//axi_lite bus interface
//===================================================================================
interface axi_lite#(
    AWADDR_WIDTH=32,
    AWPORT_WIDTH=3,
    WDATA_WIDTH=32,
    WSTRB_WIDTH=4,
    BRESP_WIDTH=2,
    ARADDR_WIDTH=32,
    ARPORT_WIDTH=3,
    RDATA_WIDTH=32,
    RRESP_WIDTH=2
)(input axi_lite_clk);
logic                       axi_lite_rstn;
logic                       axi_lite_awvalid;
logic                       axi_lite_awready;
logic [AWADDR_WIDTH-1:0]    axi_lite_awaddr;
logic [AWPORT_WIDTH-1:0]    axi_lite_awport;
logic                       axi_lite_wvalid;
logic                       axi_lite_wready;
logic [WDATA_WIDTH-1:0]     axi_lite_wdata;
logic [WSTRB_WIDTH-1:0]     axi_lite_wstrb;
logic                       axi_lite_bvalid;
logic                       axi_lite_bready;
logic [BRESP_WIDTH-1:0]     axi_lite_bresp;
logic                       axi_lite_arvalid;
logic                       axi_lite_arready;
logic [ARADDR_WIDTH-1:0]    axi_lite_araddr;
logic [ARPORT_WIDTH-1:0]    axi_lite_arport;
logic                       axi_lite_rvalid;
logic                       axi_lite_rready;
logic [RDATA_WIDTH-1:0]     axi_lite_rdata;
logic [RRESP_WIDTH-1:0]     axi_lite_rresp;    

task axi_lite_reset(input int cycles);
    axi_lite_rstn=0;
    repeat(cycles)
        @(posedge axi_lite_clk); 
    axi_lite_rstn=1;   
endtask
//master port
modport tb (
input   axi_lite_clk,
        axi_lite_awready,
        axi_lite_wready,
        axi_lite_bvalid,
        axi_lite_bresp,
        axi_lite_arready,
        axi_lite_rvalid,
        axi_lite_rdata,
        axi_lite_rresp,
output  axi_lite_rstn,
        axi_lite_awvalid,
        axi_lite_awaddr,
        axi_lite_awport,
        axi_lite_wvalid,
        axi_lite_wdata,
        axi_lite_wstrb,
        axi_lite_bready,
        axi_lite_arvalid,
        axi_lite_araddr,
        axi_lite_arport,
        axi_lite_rready,
import  axi_lite_reset         
);
//slave port
modport dut (
output  axi_lite_awready,
        axi_lite_wready,
        axi_lite_bvalid,
        axi_lite_bresp,
        axi_lite_arready,
        axi_lite_rvalid,
        axi_lite_rdata,
        axi_lite_rresp,
input   axi_lite_clk,        
        axi_lite_rstn,
        axi_lite_awvalid,
        axi_lite_awaddr,
        axi_lite_awport,
        axi_lite_wvalid,
        axi_lite_wdata,
        axi_lite_wstrb,
        axi_lite_bready,
        axi_lite_arvalid,
        axi_lite_araddr,
        axi_lite_arport,
        axi_lite_rready         
);
endinterface

//===================================================================================
//axi4 bus interface
//===================================================================================
interface axi4#(
    ARADDR_WIDTH=64,
    ARBURST_WIDTH=2,
    ARCACHE_WIDTH=4,
    ARLOCK_WIDTH=1,
    ARPORT_WIDTH=3,
    ARQOS_WIDTH=4,
    ARREGION_WIDTH=4,
    ARID_WIDTH=4,
    ARLEN_WIDTH=8,
    ARSIZE_WIDTH=3,
    AWADDR_WIDTH=64,
    AWBURST_WIDTH=2,
    AWCACHE_WIDTH=4,
    AWLOCK_WIDTH=1,
    AWPORT_WIDTH=3,
    AWQOS_WIDTH=4,
    AWREGION_WIDTH=4,
    AWID_WIDTH=4,
    AWLEN_WIDTH=8,
    AWSIZE_WIDTH=3,
    BID_WIDTH=4,
    BRESP_WIDTH=2,
    RDATA_WIDTH=512,
    RID_WIDTH=4,
    RRESP_WIDTH=2,
    RUSER_WIDTH=64,
    WDATA_WIDTH=512,
    WSTRB_WIDTH=64,
    WUSER_WIDTH=64
)(input axi4_clk);

logic                         axi4_rstn;
logic [ARADDR_WIDTH-1:0]      axi4_araddr;
logic [ARBURST_WIDTH-1:0]     axi4_arbusrt;
logic [ARCACHE_WIDTH-1:0]     axi4_arcache;
logic [ARID_WIDTH-1:0]        axi4_arid;
logic [ARLEN_WIDTH-1:0]       axi4_arlen;
logic [ARLOCK_WIDTH-1:0]      axi4_arlock;
logic [ARPORT_WIDTH-1:0]      axi4_arport;
logic [ARQOS_WIDTH-1:0]       axi4_arqos;
logic                         axi4_arready;
logic [ARREGION_WIDTH-1:0]    axi4_arregion;
logic [ARSIZE_WIDTH-1:0]      axi4_arsize;
logic                         axi4_arvalid;
logic [AWADDR_WIDTH-1:0]      axi4_awaddr;
logic [AWBURST_WIDTH-1:0]     axi4_awburst;
logic [AWCACHE_WIDTH-1:0]     axi4_awcache;
logic [AWID_WIDTH-1:0]        axi4_awid;
logic [AWLEN_WIDTH-1:0]       axi4_awlen;
logic [AWLOCK_WIDTH-1:0]      axi4_awlock;
logic [AWPORT_WIDTH-1:0]      axi4_awport;
logic [AWQOS_WIDTH-1:0]       axi4_awqos;
logic                         axi4_awready;
logic [AWREGION_WIDTH-1:0]    axi4_awregion;
logic [AWSIZE_WIDTH-1:0]      axi4_awsize;
logic                         axi4_awvalid;
logic [BID_WIDTH-1:0]         axi4_bid;
logic                         axi4_bready;
logic [BRESP_WIDTH-1:0]       axi4_bresp;
logic                         axi4_bvalid;
logic [RDATA_WIDTH-1:0]       axi4_rdata;
logic [RID_WIDTH-1:0]         axi4_rid;
logic                         axi4_rlast;
logic                         axi4_rready;
logic [RRESP_WIDTH-1:0]       axi4_rresp;
logic [RUSER_WIDTH-1:0]       axi4_ruser;
logic                         axi4_rvalid;
logic [WDATA_WIDTH-1:0]       axi4_wdata;
logic                         axi4_wlast;
logic                         axi4_wready;
logic [WSTRB_WIDTH-1:0]       axi4_wstrb;
logic [WUSER_WIDTH-1:0]       axi4_wuser; 
logic                         axi4_wvalid;    
logic                         axi4_4k_r_err;
logic                         axi4_4k_w_err;                                                                                                                                                                                         

task axi4_reset(input int cycles=1);
    axi4_rstn=0;
    repeat(cycles)
        @(posedge axi4_clk);
    axi4_rstn=1;   
endtask
//master port
modport master(
input       axi4_clk,
            axi4_rstn,
            axi4_arready,
            axi4_awready,
            axi4_bid,
            axi4_bresp,
            axi4_bvalid,
            axi4_rdata,
            axi4_rid,
            axi4_rlast,
            axi4_rresp,
            axi4_ruser,
            axi4_rvalid,
            axi4_wready,
            axi4_4k_w_err,
            axi4_4k_r_err,
output      axi4_araddr,
            axi4_arbusrt,
            axi4_arcache,
            axi4_arid,
            axi4_arlen,
            axi4_arlock,
            axi4_arport,
            axi4_arqos,
            axi4_arregion,
            axi4_arsize,
            axi4_arvalid,
            axi4_awaddr,
            axi4_awburst,
            axi4_awcache,
            axi4_awid,
            axi4_awlen,
            axi4_awlock,
            axi4_awport,
            axi4_awqos,
            axi4_awregion,
            axi4_awsize,
            axi4_awvalid,
            axi4_bready,      
            axi4_rready,
            axi4_wdata,
            axi4_wlast,
            axi4_wstrb,
            axi4_wuser, 
            axi4_wvalid
);
//slave port
modport slave(
output      
            axi4_arready,
            axi4_awready,
            axi4_bid,
            axi4_bresp,
            axi4_bvalid,
            axi4_rdata,
            axi4_rid,
            axi4_rlast,
            axi4_rresp,
            axi4_ruser,
            axi4_rvalid,
            axi4_wready,
            axi4_4k_w_err,
            axi4_4k_r_err,
input       axi4_clk,
            axi4_rstn,
            axi4_araddr,
            axi4_arbusrt,
            axi4_arcache,
            axi4_arid,
            axi4_arlen,
            axi4_arlock,
            axi4_arport,
            axi4_arqos,
            axi4_arregion,
            axi4_arsize,
            axi4_arvalid,
            axi4_awaddr,
            axi4_awburst,
            axi4_awcache,
            axi4_awid,
            axi4_awlen,
            axi4_awlock,
            axi4_awport,
            axi4_awqos,
            axi4_awregion,
            axi4_awsize,
            axi4_awvalid,
            axi4_bready,      
            axi4_rready,
            axi4_wdata,
            axi4_wlast,
            axi4_wstrb,
            axi4_wuser, 
            axi4_wvalid
);
//tb master port
modport master_tb(
input       axi4_clk,
            axi4_arready,
            axi4_awready,
            axi4_bid,
            axi4_bresp,
            axi4_bvalid,
            axi4_rdata,
            axi4_rid,
            axi4_rlast,
            axi4_rresp,
            axi4_ruser,
            axi4_rvalid,
            axi4_wready,
            axi4_4k_w_err,
            axi4_4k_r_err,
output      axi4_rstn,
            axi4_araddr,
            axi4_arbusrt,
            axi4_arcache,
            axi4_arid,
            axi4_arlen,
            axi4_arlock,
            axi4_arport,
            axi4_arqos,
            axi4_arregion,
            axi4_arsize,
            axi4_arvalid,
            axi4_awaddr,
            axi4_awburst,
            axi4_awcache,
            axi4_awid,
            axi4_awlen,
            axi4_awlock,
            axi4_awport,
            axi4_awqos,
            axi4_awregion,
            axi4_awsize,
            axi4_awvalid,
            axi4_bready,      
            axi4_rready,
            axi4_wdata,
            axi4_wlast,
            axi4_wstrb,
            axi4_wuser, 
            axi4_wvalid,
import      axi4_reset
);
//tb slave port
modport slave_tb(
input       axi4_clk,
            axi4_araddr,
            axi4_arbusrt,
            axi4_arcache,
            axi4_arid,
            axi4_arlen,
            axi4_arlock,
            axi4_arport,
            axi4_arqos,
            axi4_arregion,
            axi4_arsize,
            axi4_arvalid,
            axi4_awaddr,
            axi4_awburst,
            axi4_awcache,
            axi4_awid,
            axi4_awlen,
            axi4_awlock,
            axi4_awport,
            axi4_awqos,
            axi4_awregion,
            axi4_awsize,
            axi4_awvalid,
            axi4_bready,      
            axi4_rready,
            axi4_wdata,
            axi4_wlast,
            axi4_wstrb,
            axi4_wuser, 
            axi4_wvalid,
output      axi4_rstn,
            axi4_arready,
            axi4_awready,
            axi4_bid,
            axi4_bresp,
            axi4_bvalid,
            axi4_rdata,
            axi4_rid,
            axi4_rlast,
            axi4_rresp,
            axi4_ruser,
            axi4_rvalid,
            axi4_wready,
            axi4_4k_w_err,
            axi4_4k_r_err,
import      axi4_reset        
);
endinterface    
//===================================================================================
//interrrupt interface
//===================================================================================
interface faas_interrupt#(INTERRUPT_WIDTH=16)(input interrupt_clk);                        
logic                           usr_int_en;
logic[INTERRUPT_WIDTH-1:0]      usr_int_req;
logic[INTERRUPT_WIDTH-1:0]      usr_int_ack;

modport dut(
input   interrupt_clk,
        usr_int_en,
        usr_int_ack,
output  usr_int_req
);

modport tb(
output  usr_int_en,
        usr_int_ack,
input   interrupt_clk,
        usr_int_req
);
endinterface 

//===================================================================================
//ddr ctrl interface
//===================================================================================
interface ddr_axi4#(
    ARADDR_WIDTH=34,
    ARBURST_WIDTH=2,
    ARCACHE_WIDTH=4,
    ARLOCK_WIDTH=1,
    ARPORT_WIDTH=3,
    ARQOS_WIDTH=4,
    ARREGION_WIDTH=4,
    ARID_WIDTH=16,
    ARLEN_WIDTH=8,
    ARSIZE_WIDTH=3,
    AWADDR_WIDTH=34,
    AWBURST_WIDTH=2,
    AWCACHE_WIDTH=4,
    AWLOCK_WIDTH=1,
    AWPORT_WIDTH=3,
    AWQOS_WIDTH=4,
    AWREGION_WIDTH=4,
    AWID_WIDTH=16,
    AWLEN_WIDTH=8,
    AWSIZE_WIDTH=3,
    BID_WIDTH=16,
    BRESP_WIDTH=2,
    RDATA_WIDTH=512,
    RID_WIDTH=16,
    RRESP_WIDTH=2,
    RUSER_WIDTH=64,
    WDATA_WIDTH=512,
    WSTRB_WIDTH=64,
    WUSER_WIDTH=64
)(input ref_clk);
logic                         axi4_clk;                                                 
logic                         axi4_rstn;
logic [ARADDR_WIDTH-1:0]      axi4_araddr;
logic [ARBURST_WIDTH-1:0]     axi4_arbusrt;
logic [ARCACHE_WIDTH-1:0]     axi4_arcache;
logic [ARID_WIDTH-1:0]        axi4_arid;
logic [ARLEN_WIDTH-1:0]       axi4_arlen;
logic [ARLOCK_WIDTH-1:0]      axi4_arlock;
logic [ARPORT_WIDTH-1:0]      axi4_arport;
logic [ARQOS_WIDTH-1:0]       axi4_arqos;
logic                         axi4_arready;
logic [ARREGION_WIDTH-1:0]    axi4_arregion;
logic [ARSIZE_WIDTH-1:0]      axi4_arsize;
logic                         axi4_arvalid;
logic [AWADDR_WIDTH-1:0]      axi4_awaddr;
logic [AWBURST_WIDTH-1:0]     axi4_awburst;
logic [AWCACHE_WIDTH-1:0]     axi4_awcache;
logic [AWID_WIDTH-1:0]        axi4_awid;
logic [AWLEN_WIDTH-1:0]       axi4_awlen;
logic [AWLOCK_WIDTH-1:0]      axi4_awlock;
logic [AWPORT_WIDTH-1:0]      axi4_awport;
logic [AWQOS_WIDTH-1:0]       axi4_awqos;
logic                         axi4_awready;
logic [AWREGION_WIDTH-1:0]    axi4_awregion;
logic [AWSIZE_WIDTH-1:0]      axi4_awsize;
logic                         axi4_awvalid;
logic [BID_WIDTH-1:0]         axi4_bid;
logic                         axi4_bready;
logic [BRESP_WIDTH-1:0]       axi4_bresp;
logic                         axi4_bvalid;
logic [RDATA_WIDTH-1:0]       axi4_rdata;
logic [RID_WIDTH-1:0]         axi4_rid;
logic                         axi4_rlast;
logic                         axi4_rready;
logic [RRESP_WIDTH-1:0]       axi4_rresp;
logic [RUSER_WIDTH-1:0]       axi4_ruser;
logic                         axi4_rvalid;
logic [WDATA_WIDTH-1:0]       axi4_wdata;
logic                         axi4_wlast;
logic                         axi4_wready;
logic [WSTRB_WIDTH-1:0]       axi4_wstrb;
logic [WUSER_WIDTH-1:0]       axi4_wuser; 
logic                         axi4_wvalid;    
logic                         ddr_cal_done;

modport master(
input       axi4_clk,
            axi4_rstn,
            axi4_arready,
            axi4_awready,
            axi4_bid,
            axi4_bresp,
            axi4_bvalid,
            axi4_rdata,
            axi4_rid,
            axi4_rlast,
            axi4_rresp,
            axi4_ruser,
            axi4_rvalid,
            axi4_wready,
            ddr_cal_done,
output      axi4_araddr,
            axi4_arbusrt,
            axi4_arcache,
            axi4_arid,
            axi4_arlen,
            axi4_arlock,
            axi4_arport,
            axi4_arqos,
            axi4_arregion,
            axi4_arsize,
            axi4_arvalid,
            axi4_awaddr,
            axi4_awburst,
            axi4_awcache,
            axi4_awid,
            axi4_awlen,
            axi4_awlock,
            axi4_awport,
            axi4_awqos,
            axi4_awregion,
            axi4_awsize,
            axi4_awvalid,
            axi4_bready,      
            axi4_rready,
            axi4_wdata,
            axi4_wlast,
            axi4_wstrb,
            axi4_wuser, 
            axi4_wvalid
);

modport slave(
output      axi4_clk,
            axi4_rstn,
            axi4_arready,
            axi4_awready,
            axi4_bid,
            axi4_bresp,
            axi4_bvalid,
            axi4_rdata,
            axi4_rid,
            axi4_rlast,
            axi4_rresp,
            axi4_ruser,
            axi4_rvalid,
            axi4_wready,
            ddr_cal_done,
input       ref_clk,
            axi4_araddr,
            axi4_arbusrt,
            axi4_arcache,
            axi4_arid,
            axi4_arlen,
            axi4_arlock,
            axi4_arport,
            axi4_arqos,
            axi4_arregion,
            axi4_arsize,
            axi4_arvalid,
            axi4_awaddr,
            axi4_awburst,
            axi4_awcache,
            axi4_awid,
            axi4_awlen,
            axi4_awlock,
            axi4_awport,
            axi4_awqos,
            axi4_awregion,
            axi4_awsize,
            axi4_awvalid,
            axi4_bready,      
            axi4_rready,
            axi4_wdata,
            axi4_wlast,
            axi4_wstrb,
            axi4_wuser, 
            axi4_wvalid 
);
endinterface 