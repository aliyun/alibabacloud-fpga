`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom top,include simulation environment,dut,
//              and reference model
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 -File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "aliyun_faas_base_pkg.sv"
`include "aliyun_faas_interfaces.sv"
module aliyun_faas_sim_top();
//===================================================================================
//clocks
//===================================================================================
parameter KERNEL1_FREQ=300; //unit:MHz
parameter KERNEL2_FREQ=500; //unit:MHz
logic sys_alite_aclk=0;     //50MHz
logic pcie_axi_aclk=0;      //pcie core clk 250MHz
logic sys_clk_200m=0;       //200MHz,pll output
logic kernel_clk_300m=0;    //300Mhz mmcm output,reconfig clock
logic kernel2_clk_500m=0;   //500Mhz mmcm output,reconfig clock
logic c0_ddr4_ref_clk=0;     //ddr0 core clk
logic c1_ddr4_ref_clk=0;     //ddr1 core clk
logic c2_ddr4_ref_clk=0;     //ddr2 core clk
logic c3_ddr4_ref_clk=0;     //ddr3 core clk
//clock generation
always #10                          sys_alite_aclk=~sys_alite_aclk;
always #2                           pcie_axi_aclk=~pcie_axi_aclk;
always #2.5                         sys_clk_200m=~sys_clk_200m;
always #(10**3/(KERNEL1_FREQ*2))    kernel_clk_300m=~kernel_clk_300m;
always #(10**3/(KERNEL2_FREQ*2))    kernel2_clk_500m=~kernel2_clk_500m;
always #(3.284/2.0)                 c0_ddr4_ref_clk=~c0_ddr4_ref_clk;
always #(3.284/2.0)                 c1_ddr4_ref_clk=~c1_ddr4_ref_clk;
always #(3.284/2.0)                 c2_ddr4_ref_clk=~c2_ddr4_ref_clk;
always #(3.284/2.0)                 c3_ddr4_ref_clk=~c3_ddr4_ref_clk;
//===================================================================================
//reset signals
//===================================================================================
logic sys_clk_rstn;             //reset -active low
logic kernel_clk_rstn;          //reset -active low
logic kernel2_clk_rstn;         //reset -active low 
initial
begin
    sys_clk_rstn=0;
    kernel_clk_rstn=0;
    kernel2_clk_rstn=0;
    #10;
    sys_clk_rstn=1;
    kernel_clk_rstn=1;
    kernel2_clk_rstn=1;
end
//===================================================================================
//interface
//===================================================================================
axi_lite #(.AWADDR_WIDTH(`ALITE_AWADDR_WIDTH),
           .AWPORT_WIDTH(`ALITE_AWPORT_WIDTH),
           .WDATA_WIDTH(`ALITE_WDATA_WIDTH),
           .WSTRB_WIDTH(`ALITE_WSTRB_WIDTH),
           .BRESP_WIDTH(`ALITE_BRESP_WIDTH),
           .ARADDR_WIDTH(`ALITE_ARADDR_WIDTH),
           .ARPORT_WIDTH(`ALITE_ARPORT_WIDTH),
           .RDATA_WIDTH(`ALITE_RDATA_WIDTH),
           .RRESP_WIDTH(`ALITE_RRESP_WIDTH)
           ) user_alite_bus(sys_alite_aclk);
           
axi4#(     .ARADDR_WIDTH(`DMA_ARADDR_WIDTH),
           .ARBURST_WIDTH(`DMA_ARBURST_WIDTH),
           //.ARCACHE_WIDTH(),
           //.ARLOCK_WIDTH(),
           //.ARPORT_WIDTH(),
           //.ARQOS_WIDTH(),
           //.ARREGION_WIDTH(),
           .ARID_WIDTH(`DMA_ARID_WIDTH),
           .ARLEN_WIDTH(`DMA_ARLEN_WIDTH),
           .ARSIZE_WIDTH(`DMA_ARSIZE_WIDTH),
           .AWADDR_WIDTH(`DMA_AWADDR_WIDTH),
           .AWBURST_WIDTH(`DMA_AWBURST_WIDTH),
           //.AWCACHE_WIDTH(),
           //.AWLOCK_WIDTH(),
           //.AWPORT_WIDTH(),
           //.AWQOS_WIDTH(),
           //.AWREGION_WIDTH(),
           .AWID_WIDTH(`DMA_AWID_WIDTH),
           .AWLEN_WIDTH(`DMA_AWLEN_WIDTH),
           .AWSIZE_WIDTH(`DMA_AWSIZE_WIDTH),
           .BID_WIDTH(`DMA_BID_WIDTH),
           .BRESP_WIDTH(`DMA_BRESP_WIDTH),
           .RDATA_WIDTH(`DMA_RDATA_WIDTH),
           .RID_WIDTH(`DMA_RID_WIDTH),
           .RRESP_WIDTH(`DMA_RRESP_WIDTH),
           //.RUSER_WIDTH(),
           .WDATA_WIDTH(`DMA_WDATA_WIDTH),
           .WSTRB_WIDTH(`DMA_WSTRB_WIDTH)
           //.WUSER_WIDTH()
           ) dma_axi_bus(pcie_axi_aclk);
           
axi4#(     .ARADDR_WIDTH(`XDMA_ARADDR_WIDTH),
           .ARBURST_WIDTH(`XDMA_ARBURST_WIDTH),
           .ARCACHE_WIDTH(`XDMA_ARCACHE_WIDTH),
           .ARLOCK_WIDTH(`XDMA_ARLOCK_WIDTH),
           .ARPORT_WIDTH(`XDMA_ARPORT_WIDTH),
           .ARQOS_WIDTH(`XDMA_ARQOS_WIDTH),
           .ARREGION_WIDTH(`XDMA_ARREGION_WIDTH),
           .ARID_WIDTH(`XDMA_ARID_WIDTH),
           .ARLEN_WIDTH(`XDMA_ARLEN_WIDTH),
           .ARSIZE_WIDTH(`XDMA_ARSIZE_WIDTH),
           .AWADDR_WIDTH(`XDMA_AWADDR_WIDTH),
           .AWBURST_WIDTH(`XDMA_AWBURST_WIDTH),
           .AWCACHE_WIDTH(`XDMA_AWCACHE_WIDTH),
           .AWLOCK_WIDTH(`XDMA_AWLOCK_WIDTH),
           .AWPORT_WIDTH(`XDMA_AWPORT_WIDTH),
           .AWQOS_WIDTH(`XDMA_AWQOS_WIDTH),
           .AWREGION_WIDTH(`XDMA_AWREGION_WIDTH),
           .AWID_WIDTH(`XDMA_AWID_WIDTH),
           .AWLEN_WIDTH(`XDMA_AWLEN_WIDTH),
           .AWSIZE_WIDTH(`XDMA_AWSIZE_WIDTH),
           .BID_WIDTH(`XDMA_BID_WIDTH),
           .BRESP_WIDTH(`XDMA_BRESP_WIDTH),
           .RDATA_WIDTH(`XDMA_RDATA_WIDTH),
           .RID_WIDTH(`XDMA_RID_WIDTH),
           .RRESP_WIDTH(`XDMA_RRESP_WIDTH),
           //.RUSER_WIDTH(),
           .WDATA_WIDTH(`XDMA_WDATA_WIDTH),
           .WSTRB_WIDTH(`XDMA_WSTRB_WIDTH)
           //.WUSER_WIDTH()
           ) xdma_axi_bus(pcie_axi_aclk);
           
ddr_axi4#(  .ARADDR_WIDTH(`DDR_ARADDR_WIDTH),
            .ARBURST_WIDTH(`DDR_ARBURST_WIDTH),
            .ARCACHE_WIDTH(`DDR_ARCACHE_WIDTH),
            .ARLOCK_WIDTH(`DDR_ARLOCK_WIDTH),
            .ARPORT_WIDTH(`DDR_ARPORT_WIDTH),
            .ARQOS_WIDTH(`DDR_ARQOS_WIDTH),
            .ARREGION_WIDTH(`DDR_ARREGION_WIDTH),
            .ARID_WIDTH(`DDR_ARID_WIDTH),
            .ARLEN_WIDTH(`DDR_ARLEN_WIDTH),
            .ARSIZE_WIDTH(`DDR_ARSIZE_WIDTH),
            .AWADDR_WIDTH(`DDR_AWADDR_WIDTH),
            .AWBURST_WIDTH(`DDR_AWBURST_WIDTH),
            .AWCACHE_WIDTH(`DDR_AWCACHE_WIDTH),
            .AWLOCK_WIDTH(`DDR_AWLOCK_WIDTH),
            .AWPORT_WIDTH(`DDR_AWPORT_WIDTH),
            .AWQOS_WIDTH(`DDR_AWQOS_WIDTH),
            .AWREGION_WIDTH(`DDR_AWREGION_WIDTH),
            .AWID_WIDTH(`DDR_AWID_WIDTH),
            .AWLEN_WIDTH(`DDR_AWLEN_WIDTH),
            .AWSIZE_WIDTH(`DDR_AWSIZE_WIDTH),
            .BID_WIDTH(`DDR_BID_WIDTH),
            .BRESP_WIDTH(`DDR_BRESP_WIDTH),
            .RDATA_WIDTH(`DDR_RDATA_WIDTH),
            .RID_WIDTH(`DDR_RID_WIDTH),
            .RRESP_WIDTH(`DDR_RRESP_WIDTH),
            //.RUSER_WIDTH(),
            .WDATA_WIDTH(`DDR_WDATA_WIDTH),
            .WSTRB_WIDTH(`DDR_WSTRB_WIDTH)
            //.WUSER_WIDTH()
           )c0_ddr_bus(c0_ddr4_ref_clk);
           
ddr_axi4#(  .ARADDR_WIDTH(`DDR_ARADDR_WIDTH),
            .ARBURST_WIDTH(`DDR_ARBURST_WIDTH),
            .ARCACHE_WIDTH(`DDR_ARCACHE_WIDTH),
            .ARLOCK_WIDTH(`DDR_ARLOCK_WIDTH),
            .ARPORT_WIDTH(`DDR_ARPORT_WIDTH),
            .ARQOS_WIDTH(`DDR_ARQOS_WIDTH),
            .ARREGION_WIDTH(`DDR_ARREGION_WIDTH),
            .ARID_WIDTH(`DDR_ARID_WIDTH),
            .ARLEN_WIDTH(`DDR_ARLEN_WIDTH),
            .ARSIZE_WIDTH(`DDR_ARSIZE_WIDTH),
            .AWADDR_WIDTH(`DDR_AWADDR_WIDTH),
            .AWBURST_WIDTH(`DDR_AWBURST_WIDTH),
            .AWCACHE_WIDTH(`DDR_AWCACHE_WIDTH),
            .AWLOCK_WIDTH(`DDR_AWLOCK_WIDTH),
            .AWPORT_WIDTH(`DDR_AWPORT_WIDTH),
            .AWQOS_WIDTH(`DDR_AWQOS_WIDTH),
            .AWREGION_WIDTH(`DDR_AWREGION_WIDTH),
            .AWID_WIDTH(`DDR_AWID_WIDTH),
            .AWLEN_WIDTH(`DDR_AWLEN_WIDTH),
            .AWSIZE_WIDTH(`DDR_AWSIZE_WIDTH),
            .BID_WIDTH(`DDR_BID_WIDTH),
            .BRESP_WIDTH(`DDR_BRESP_WIDTH),
            .RDATA_WIDTH(`DDR_RDATA_WIDTH),
            .RID_WIDTH(`DDR_RID_WIDTH),
            .RRESP_WIDTH(`DDR_RRESP_WIDTH),
            //.RUSER_WIDTH(),
            .WDATA_WIDTH(`DDR_WDATA_WIDTH),
            .WSTRB_WIDTH(`DDR_WSTRB_WIDTH)
            //.WUSER_WIDTH()
            )c1_ddr_bus(c1_ddr4_ref_clk);
            
ddr_axi4#(  .ARADDR_WIDTH(`DDR_ARADDR_WIDTH),
            .ARBURST_WIDTH(`DDR_ARBURST_WIDTH),
            .ARCACHE_WIDTH(`DDR_ARCACHE_WIDTH),
            .ARLOCK_WIDTH(`DDR_ARLOCK_WIDTH),
            .ARPORT_WIDTH(`DDR_ARPORT_WIDTH),
            .ARQOS_WIDTH(`DDR_ARQOS_WIDTH),
            .ARREGION_WIDTH(`DDR_ARREGION_WIDTH),
            .ARID_WIDTH(`DDR_ARID_WIDTH),
            .ARLEN_WIDTH(`DDR_ARLEN_WIDTH),
            .ARSIZE_WIDTH(`DDR_ARSIZE_WIDTH),
            .AWADDR_WIDTH(`DDR_AWADDR_WIDTH),
            .AWBURST_WIDTH(`DDR_AWBURST_WIDTH),
            .AWCACHE_WIDTH(`DDR_AWCACHE_WIDTH),
            .AWLOCK_WIDTH(`DDR_AWLOCK_WIDTH),
            .AWPORT_WIDTH(`DDR_AWPORT_WIDTH),
            .AWQOS_WIDTH(`DDR_AWQOS_WIDTH),
            .AWREGION_WIDTH(`DDR_AWREGION_WIDTH),
            .AWID_WIDTH(`DDR_AWID_WIDTH),
            .AWLEN_WIDTH(`DDR_AWLEN_WIDTH),
            .AWSIZE_WIDTH(`DDR_AWSIZE_WIDTH),
            .BID_WIDTH(`DDR_BID_WIDTH),
            .BRESP_WIDTH(`DDR_BRESP_WIDTH),
            .RDATA_WIDTH(`DDR_RDATA_WIDTH),
            .RID_WIDTH(`DDR_RID_WIDTH),
            .RRESP_WIDTH(`DDR_RRESP_WIDTH),
            //.RUSER_WIDTH(),
            .WDATA_WIDTH(`DDR_WDATA_WIDTH),
            .WSTRB_WIDTH(`DDR_WSTRB_WIDTH)
            //.WUSER_WIDTH()
          )c2_ddr_bus(c2_ddr4_ref_clk);
          
ddr_axi4#(  .ARADDR_WIDTH(`DDR_ARADDR_WIDTH),
            .ARBURST_WIDTH(`DDR_ARBURST_WIDTH),
            .ARCACHE_WIDTH(`DDR_ARCACHE_WIDTH),
            .ARLOCK_WIDTH(`DDR_ARLOCK_WIDTH),
            .ARPORT_WIDTH(`DDR_ARPORT_WIDTH),
            .ARQOS_WIDTH(`DDR_ARQOS_WIDTH),
            .ARREGION_WIDTH(`DDR_ARREGION_WIDTH),
            .ARID_WIDTH(`DDR_ARID_WIDTH),
            .ARLEN_WIDTH(`DDR_ARLEN_WIDTH),
            .ARSIZE_WIDTH(`DDR_ARSIZE_WIDTH),
            .AWADDR_WIDTH(`DDR_AWADDR_WIDTH),
            .AWBURST_WIDTH(`DDR_AWBURST_WIDTH),
            .AWCACHE_WIDTH(`DDR_AWCACHE_WIDTH),
            .AWLOCK_WIDTH(`DDR_AWLOCK_WIDTH),
            .AWPORT_WIDTH(`DDR_AWPORT_WIDTH),
            .AWQOS_WIDTH(`DDR_AWQOS_WIDTH),
            .AWREGION_WIDTH(`DDR_AWREGION_WIDTH),
            .AWID_WIDTH(`DDR_AWID_WIDTH),
            .AWLEN_WIDTH(`DDR_AWLEN_WIDTH),
            .AWSIZE_WIDTH(`DDR_AWSIZE_WIDTH),
            .BID_WIDTH(`DDR_BID_WIDTH),
            .BRESP_WIDTH(`DDR_BRESP_WIDTH),
            .RDATA_WIDTH(`DDR_RDATA_WIDTH),
            .RID_WIDTH(`DDR_RID_WIDTH),
            .RRESP_WIDTH(`DDR_RRESP_WIDTH),
            //.RUSER_WIDTH(),
            .WDATA_WIDTH(`DDR_WDATA_WIDTH),
            .WSTRB_WIDTH(`DDR_WSTRB_WIDTH)
            //.WUSER_WIDTH()
           )c3_ddr_bus(c3_ddr4_ref_clk);
           
faas_interrupt#(.INTERRUPT_WIDTH(`INTERRUPT_WIDTH)
            )usr_int_bus(pcie_axi_aclk);
//===================================================================================
//simulation testbench
//===================================================================================
aliuyun_faas_sim_tb faas_sim_tb(user_alite_bus,
                                xdma_axi_bus,
                                dma_axi_bus,
                                usr_int_bus,
                                c0_ddr_bus,
                                c1_ddr_bus,
                                c2_ddr_bus,
                                c3_ddr_bus
                                );
//===================================================================================
//DUT
//===================================================================================
usr_top DUT(
        //clock & reset
        .sys_alite_aclk       (sys_alite_aclk),                     //50Mhz
        .sys_alite_aresetn    (user_alite_bus.dut.axi_lite_rstn),   //reset -active low
        .pcie_axi_aclk        (pcie_axi_aclk),                      //pcie core clk 250Mhz
        .pcie_axi_arstn       (xdma_axi_bus.slave.axi4_rstn),       //pcie core rstn      
        
        .sys_clk_200m         (sys_clk_200m) ,                      //200Mhz. pll output. 
        .sys_clk_rstn         (sys_clk_rstn) ,                      //reset -active low
        .kernel_clk_300m      (kernel_clk_300m) ,                   //300Mhz  mmcm output, reconfig clock
        .kernel_clk_rstn      (kernel_clk_rstn) ,                   //reset -active low
        .kernel2_clk_500m     (kernel2_clk_500m) ,                  //500Mhz  mmcm output, reconfig clock
        .kernel2_clk_rstn     (kernel2_clk_rstn) ,                  //reset -active low
        .c0_ddr4_ui_clk       (c0_ddr_bus.master.axi4_clk) ,        //ddr0 core clk
        .c1_ddr4_ui_clk       (c1_ddr_bus.master.axi4_clk) ,        //ddr1 core clk
        .c2_ddr4_ui_clk       (c2_ddr_bus.master.axi4_clk) ,        //ddr2 core clk
        .c3_ddr4_ui_clk       (c3_ddr_bus.master.axi4_clk) ,        //ddr3 core clk
        .c0_ddr4_rstn         (c0_ddr_bus.master.axi4_rstn) ,       //ddr0 reset_n 
        .c1_ddr4_rstn         (c1_ddr_bus.master.axi4_rstn) ,       //ddr1 reset_n
        .c2_ddr4_rstn         (c2_ddr_bus.master.axi4_rstn) ,       //ddr2 reset_n
        .c3_ddr4_rstn         (c3_ddr_bus.master.axi4_rstn) ,       //ddr3 reset_n     
        
        //alite register
        .usr_alite_awvalid    (user_alite_bus.dut.axi_lite_awvalid),  //the clock domain sys_alite_aclk
        .usr_alite_awready    (user_alite_bus.dut.axi_lite_awready),   
        .usr_alite_awaddr     (user_alite_bus.dut.axi_lite_awaddr), 
        .usr_alite_awprot     (user_alite_bus.dut.axi_lite_awport),
        .usr_alite_wvalid     (user_alite_bus.dut.axi_lite_wvalid),   
        .usr_alite_wready     (user_alite_bus.dut.axi_lite_wready),   
        .usr_alite_wdata      (user_alite_bus.dut.axi_lite_wdata),  
        .usr_alite_wstrb      (user_alite_bus.dut.axi_lite_wstrb), 
        .usr_alite_bvalid     (user_alite_bus.dut.axi_lite_bvalid),   
        .usr_alite_bready     (user_alite_bus.dut.axi_lite_bready),   
        .usr_alite_bresp      (user_alite_bus.dut.axi_lite_bresp),   
        .usr_alite_arvalid    (user_alite_bus.dut.axi_lite_arvalid),   
        .usr_alite_arready    (user_alite_bus.dut.axi_lite_arready),   
        .usr_alite_araddr     (user_alite_bus.dut.axi_lite_araddr), 
        .usr_alite_arprot     (user_alite_bus.dut.axi_lite_arport),
        .usr_alite_rvalid     (user_alite_bus.dut.axi_lite_rvalid),   
        .usr_alite_rready     (user_alite_bus.dut.axi_lite_rready),   
        .usr_alite_rdata      (user_alite_bus.dut.axi_lite_rdata),   
        .usr_alite_rresp      (user_alite_bus.dut.axi_lite_rresp), 
        //dma slave port
        .dma_axi_araddr       (dma_axi_bus.master.axi4_araddr),   //the pcie core clock domain. dma slave interface
        .dma_axi_arburst      (dma_axi_bus.master.axi4_arbusrt),   //
        .dma_axi_arid         (dma_axi_bus.master.axi4_arid),
        .dma_axi_arlen        (dma_axi_bus.master.axi4_arlen),
        .dma_axi_arready      (dma_axi_bus.master.axi4_arready),
        .dma_axi_arsize       (dma_axi_bus.master.axi4_arsize),
        .dma_axi_arvalid      (dma_axi_bus.master.axi4_arvalid),
        .dma_axi_awaddr       (dma_axi_bus.master.axi4_awaddr),
        .dma_axi_awburst      (dma_axi_bus.master.axi4_awburst),
        .dma_axi_awid         (dma_axi_bus.master.axi4_awid),
        .dma_axi_awlen        (dma_axi_bus.master.axi4_awlen),
        .dma_axi_awready      (dma_axi_bus.master.axi4_awready),
        .dma_axi_awsize       (dma_axi_bus.master.axi4_awsize),
        .dma_axi_awvalid      (dma_axi_bus.master.axi4_awvalid),
        .dma_axi_bid          (dma_axi_bus.master.axi4_bid),
        .dma_axi_bready       (dma_axi_bus.master.axi4_bready),
        .dma_axi_bresp        (dma_axi_bus.master.axi4_bresp),
        .dma_axi_bvalid       (dma_axi_bus.master.axi4_bvalid),
        .dma_axi_rdata        (dma_axi_bus.master.axi4_rdata),
        .dma_axi_rid          (dma_axi_bus.master.axi4_rid),
        .dma_axi_rlast        (dma_axi_bus.master.axi4_rlast),
        .dma_axi_rready       (dma_axi_bus.master.axi4_rready),
        .dma_axi_rresp        (dma_axi_bus.master.axi4_rresp),
        //input    [63:0] dma_axi_ruser                   ,
        .dma_axi_rvalid       (dma_axi_bus.master.axi4_rvalid),
        .dma_axi_wdata        (dma_axi_bus.master.axi4_wdata),
        .dma_axi_wlast        (dma_axi_bus.master.axi4_wlast),
        .dma_axi_wready       (dma_axi_bus.master.axi4_wready),
        .dma_axi_wstrb        (dma_axi_bus.master.axi4_wstrb),
        //output  [63:0]  dma_axi_wuser                   ,
        .dma_axi_wvalid       (dma_axi_bus.master.axi4_wvalid) ,
        .dma_axi_4k_r_err_flag(dma_axi_bus.master.axi4_4k_w_err) ,   //dma_axi_protocol_error
        .dma_axi_4k_w_err_flag(dma_axi_bus.master.axi4_4k_r_err) ,   //dma_axi_protocol_error
        
        .xdma_axi_araddr      (xdma_axi_bus.slave.axi4_araddr),   //the xdma/bypass master interface. the pcie core clock domain
        .xdma_axi_arburst     (xdma_axi_bus.slave.axi4_arbusrt),
        .xdma_axi_arcache     (xdma_axi_bus.slave.axi4_arcache),
        .xdma_axi_arid        (xdma_axi_bus.slave.axi4_arid),
        .xdma_axi_arlen       (xdma_axi_bus.slave.axi4_arlen),
        .xdma_axi_arlock      (xdma_axi_bus.slave.axi4_arlock),
        .xdma_axi_arprot      (xdma_axi_bus.slave.axi4_arport),
        .xdma_axi_arqos       (xdma_axi_bus.slave.axi4_arqos),
        .xdma_axi_arready     (xdma_axi_bus.slave.axi4_arready),
        .xdma_axi_arregion    (xdma_axi_bus.slave.axi4_arregion),
        .xdma_axi_arsize      (xdma_axi_bus.slave.axi4_arsize),
        .xdma_axi_arvalid     (xdma_axi_bus.slave.axi4_arvalid),
        .xdma_axi_awaddr      (xdma_axi_bus.slave.axi4_awaddr),
        .xdma_axi_awburst     (xdma_axi_bus.slave.axi4_awburst),
        .xdma_axi_awcache     (xdma_axi_bus.slave.axi4_awcache),
        .xdma_axi_awid        (xdma_axi_bus.slave.axi4_awid),
        .xdma_axi_awlen       (xdma_axi_bus.slave.axi4_awlen),
        .xdma_axi_awlock      (xdma_axi_bus.slave.axi4_awlock),
        .xdma_axi_awprot      (xdma_axi_bus.slave.axi4_awport),
        .xdma_axi_awqos       (xdma_axi_bus.slave.axi4_awqos),
        .xdma_axi_awready     (xdma_axi_bus.slave.axi4_awready),
        .xdma_axi_awregion    (xdma_axi_bus.slave.axi4_awregion),
        .xdma_axi_awsize      (xdma_axi_bus.slave.axi4_awsize),
        .xdma_axi_awvalid     (xdma_axi_bus.slave.axi4_awvalid),
        .xdma_axi_bid         (xdma_axi_bus.slave.axi4_bid),
        .xdma_axi_bready      (xdma_axi_bus.slave.axi4_bready),
        .xdma_axi_bresp       (xdma_axi_bus.slave.axi4_bresp),
        .xdma_axi_bvalid      (xdma_axi_bus.slave.axi4_bvalid),
        .xdma_axi_rdata       (xdma_axi_bus.slave.axi4_rdata),
        .xdma_axi_rid         (xdma_axi_bus.slave.axi4_rid),
        .xdma_axi_rlast       (xdma_axi_bus.slave.axi4_rlast),
        .xdma_axi_rready      (xdma_axi_bus.slave.axi4_rready),
        .xdma_axi_rresp       (xdma_axi_bus.slave.axi4_rresp),
        .xdma_axi_rvalid      (xdma_axi_bus.slave.axi4_rvalid),
        .xdma_axi_wdata       (xdma_axi_bus.slave.axi4_wdata),
        .xdma_axi_wlast       (xdma_axi_bus.slave.axi4_wlast),
        .xdma_axi_wready      (xdma_axi_bus.slave.axi4_wready),
        .xdma_axi_wstrb       (xdma_axi_bus.slave.axi4_wstrb),
        .xdma_axi_wvalid      (xdma_axi_bus.slave.axi4_wvalid),        
        
        .c0_ddr4_axi_araddr   (c0_ddr_bus.master.axi4_araddr),   //ddr0 core clk domain
        .c0_ddr4_axi_arburst  (c0_ddr_bus.master.axi4_arbusrt),
        .c0_ddr4_axi_arcache  (c0_ddr_bus.master.axi4_arcache),
        .c0_ddr4_axi_arid     (c0_ddr_bus.master.axi4_arid),
        .c0_ddr4_axi_arlen    (c0_ddr_bus.master.axi4_arlen),
        .c0_ddr4_axi_arlock   (c0_ddr_bus.master.axi4_arlock),
        .c0_ddr4_axi_arprot   (c0_ddr_bus.master.axi4_arport),
        .c0_ddr4_axi_arqos    (c0_ddr_bus.master.axi4_arqos),
        .c0_ddr4_axi_arready  (c0_ddr_bus.master.axi4_arready),
        .c0_ddr4_axi_arregion (c0_ddr_bus.master.axi4_arregion),
        .c0_ddr4_axi_arsize   (c0_ddr_bus.master.axi4_arsize),
        .c0_ddr4_axi_arvalid  (c0_ddr_bus.master.axi4_arvalid),
        .c0_ddr4_axi_awaddr   (c0_ddr_bus.master.axi4_awaddr),
        .c0_ddr4_axi_awburst  (c0_ddr_bus.master.axi4_awburst),
        .c0_ddr4_axi_awcache  (c0_ddr_bus.master.axi4_awcache),
        .c0_ddr4_axi_awid     (c0_ddr_bus.master.axi4_awid),
        .c0_ddr4_axi_awlen    (c0_ddr_bus.master.axi4_awlen),
        .c0_ddr4_axi_awlock   (c0_ddr_bus.master.axi4_awlock),
        .c0_ddr4_axi_awprot   (c0_ddr_bus.master.axi4_awport),
        .c0_ddr4_axi_awqos    (c0_ddr_bus.master.axi4_awqos),
        .c0_ddr4_axi_awready  (c0_ddr_bus.master.axi4_awready),
        .c0_ddr4_axi_awregion (c0_ddr_bus.master.axi4_awregion),
        .c0_ddr4_axi_awsize   (c0_ddr_bus.master.axi4_awsize),
        .c0_ddr4_axi_awvalid  (c0_ddr_bus.master.axi4_awvalid),
        .c0_ddr4_axi_bid      (c0_ddr_bus.master.axi4_bid),
        .c0_ddr4_axi_bready   (c0_ddr_bus.master.axi4_bready),
        .c0_ddr4_axi_bresp    (c0_ddr_bus.master.axi4_bresp),
        .c0_ddr4_axi_bvalid   (c0_ddr_bus.master.axi4_bvalid),
        .c0_ddr4_axi_rdata    (c0_ddr_bus.master.axi4_rdata),
        .c0_ddr4_axi_rid      (c0_ddr_bus.master.axi4_rid),
        .c0_ddr4_axi_rlast    (c0_ddr_bus.master.axi4_rlast),
        .c0_ddr4_axi_rready   (c0_ddr_bus.master.axi4_rready),
        .c0_ddr4_axi_rresp    (c0_ddr_bus.master.axi4_rresp),
        .c0_ddr4_axi_rvalid   (c0_ddr_bus.master.axi4_rvalid),
        .c0_ddr4_axi_wdata    (c0_ddr_bus.master.axi4_wdata),
        .c0_ddr4_axi_wlast    (c0_ddr_bus.master.axi4_wlast),
        .c0_ddr4_axi_wready   (c0_ddr_bus.master.axi4_wready),
        .c0_ddr4_axi_wstrb    (c0_ddr_bus.master.axi4_wstrb),
        .c0_ddr4_axi_wvalid   (c0_ddr_bus.master.axi4_wvalid),     
            
        .c1_ddr4_axi_araddr   (c1_ddr_bus.master.axi4_araddr),   //ddr1 core clk domain
        .c1_ddr4_axi_arburst  (c1_ddr_bus.master.axi4_arbusrt),  
        .c1_ddr4_axi_arcache  (c1_ddr_bus.master.axi4_arcache),  
        .c1_ddr4_axi_arid     (c1_ddr_bus.master.axi4_arid),     
        .c1_ddr4_axi_arlen    (c1_ddr_bus.master.axi4_arlen),    
        .c1_ddr4_axi_arlock   (c1_ddr_bus.master.axi4_arlock),   
        .c1_ddr4_axi_arprot   (c1_ddr_bus.master.axi4_arport),   
        .c1_ddr4_axi_arqos    (c1_ddr_bus.master.axi4_arqos),    
        .c1_ddr4_axi_arready  (c1_ddr_bus.master.axi4_arready),  
        .c1_ddr4_axi_arregion (c1_ddr_bus.master.axi4_arregion), 
        .c1_ddr4_axi_arsize   (c1_ddr_bus.master.axi4_arsize),   
        .c1_ddr4_axi_arvalid  (c1_ddr_bus.master.axi4_arvalid),  
        .c1_ddr4_axi_awaddr   (c1_ddr_bus.master.axi4_awaddr),   
        .c1_ddr4_axi_awburst  (c1_ddr_bus.master.axi4_awburst),  
        .c1_ddr4_axi_awcache  (c1_ddr_bus.master.axi4_awcache),  
        .c1_ddr4_axi_awid     (c1_ddr_bus.master.axi4_awid),     
        .c1_ddr4_axi_awlen    (c1_ddr_bus.master.axi4_awlen),    
        .c1_ddr4_axi_awlock   (c1_ddr_bus.master.axi4_awlock),   
        .c1_ddr4_axi_awprot   (c1_ddr_bus.master.axi4_awport),   
        .c1_ddr4_axi_awqos    (c1_ddr_bus.master.axi4_awqos),    
        .c1_ddr4_axi_awready  (c1_ddr_bus.master.axi4_awready),  
        .c1_ddr4_axi_awregion (c1_ddr_bus.master.axi4_awregion), 
        .c1_ddr4_axi_awsize   (c1_ddr_bus.master.axi4_awsize),   
        .c1_ddr4_axi_awvalid  (c1_ddr_bus.master.axi4_awvalid),  
        .c1_ddr4_axi_bid      (c1_ddr_bus.master.axi4_bid),      
        .c1_ddr4_axi_bready   (c1_ddr_bus.master.axi4_bready),   
        .c1_ddr4_axi_bresp    (c1_ddr_bus.master.axi4_bresp),    
        .c1_ddr4_axi_bvalid   (c1_ddr_bus.master.axi4_bvalid),   
        .c1_ddr4_axi_rdata    (c1_ddr_bus.master.axi4_rdata),    
        .c1_ddr4_axi_rid      (c1_ddr_bus.master.axi4_rid),      
        .c1_ddr4_axi_rlast    (c1_ddr_bus.master.axi4_rlast),    
        .c1_ddr4_axi_rready   (c1_ddr_bus.master.axi4_rready),   
        .c1_ddr4_axi_rresp    (c1_ddr_bus.master.axi4_rresp),    
        .c1_ddr4_axi_rvalid   (c1_ddr_bus.master.axi4_rvalid),   
        .c1_ddr4_axi_wdata    (c1_ddr_bus.master.axi4_wdata),    
        .c1_ddr4_axi_wlast    (c1_ddr_bus.master.axi4_wlast),    
        .c1_ddr4_axi_wready   (c1_ddr_bus.master.axi4_wready),   
        .c1_ddr4_axi_wstrb    (c1_ddr_bus.master.axi4_wstrb),    
        .c1_ddr4_axi_wvalid   (c1_ddr_bus.master.axi4_wvalid),   
            
        .c2_ddr4_axi_araddr   (c2_ddr_bus.master.axi4_araddr), //ddr2 core clk domain
        .c2_ddr4_axi_arburst  (c2_ddr_bus.master.axi4_arbusrt),  
        .c2_ddr4_axi_arcache  (c2_ddr_bus.master.axi4_arcache),  
        .c2_ddr4_axi_arid     (c2_ddr_bus.master.axi4_arid),     
        .c2_ddr4_axi_arlen    (c2_ddr_bus.master.axi4_arlen),    
        .c2_ddr4_axi_arlock   (c2_ddr_bus.master.axi4_arlock),   
        .c2_ddr4_axi_arprot   (c2_ddr_bus.master.axi4_arport),   
        .c2_ddr4_axi_arqos    (c2_ddr_bus.master.axi4_arqos),    
        .c2_ddr4_axi_arready  (c2_ddr_bus.master.axi4_arready),  
        .c2_ddr4_axi_arregion (c2_ddr_bus.master.axi4_arregion), 
        .c2_ddr4_axi_arsize   (c2_ddr_bus.master.axi4_arsize),   
        .c2_ddr4_axi_arvalid  (c2_ddr_bus.master.axi4_arvalid),  
        .c2_ddr4_axi_awaddr   (c2_ddr_bus.master.axi4_awaddr),   
        .c2_ddr4_axi_awburst  (c2_ddr_bus.master.axi4_awburst),  
        .c2_ddr4_axi_awcache  (c2_ddr_bus.master.axi4_awcache),  
        .c2_ddr4_axi_awid     (c2_ddr_bus.master.axi4_awid),     
        .c2_ddr4_axi_awlen    (c2_ddr_bus.master.axi4_awlen),    
        .c2_ddr4_axi_awlock   (c2_ddr_bus.master.axi4_awlock),   
        .c2_ddr4_axi_awprot   (c2_ddr_bus.master.axi4_awport),   
        .c2_ddr4_axi_awqos    (c2_ddr_bus.master.axi4_awqos),    
        .c2_ddr4_axi_awready  (c2_ddr_bus.master.axi4_awready),  
        .c2_ddr4_axi_awregion (c2_ddr_bus.master.axi4_awregion), 
        .c2_ddr4_axi_awsize   (c2_ddr_bus.master.axi4_awsize),   
        .c2_ddr4_axi_awvalid  (c2_ddr_bus.master.axi4_awvalid),  
        .c2_ddr4_axi_bid      (c2_ddr_bus.master.axi4_bid),      
        .c2_ddr4_axi_bready   (c2_ddr_bus.master.axi4_bready),   
        .c2_ddr4_axi_bresp    (c2_ddr_bus.master.axi4_bresp),    
        .c2_ddr4_axi_bvalid   (c2_ddr_bus.master.axi4_bvalid),   
        .c2_ddr4_axi_rdata    (c2_ddr_bus.master.axi4_rdata),    
        .c2_ddr4_axi_rid      (c2_ddr_bus.master.axi4_rid),      
        .c2_ddr4_axi_rlast    (c2_ddr_bus.master.axi4_rlast),    
        .c2_ddr4_axi_rready   (c2_ddr_bus.master.axi4_rready),   
        .c2_ddr4_axi_rresp    (c2_ddr_bus.master.axi4_rresp),    
        .c2_ddr4_axi_rvalid   (c2_ddr_bus.master.axi4_rvalid),   
        .c2_ddr4_axi_wdata    (c2_ddr_bus.master.axi4_wdata),    
        .c2_ddr4_axi_wlast    (c2_ddr_bus.master.axi4_wlast),    
        .c2_ddr4_axi_wready   (c2_ddr_bus.master.axi4_wready),   
        .c2_ddr4_axi_wstrb    (c2_ddr_bus.master.axi4_wstrb),    
        .c2_ddr4_axi_wvalid   (c2_ddr_bus.master.axi4_wvalid),   
            
        .c3_ddr4_axi_araddr   (c3_ddr_bus.master.axi4_araddr), //ddr3 core clk domain
        .c3_ddr4_axi_arburst  (c3_ddr_bus.master.axi4_arbusrt),
        .c3_ddr4_axi_arcache  (c3_ddr_bus.master.axi4_arcache),
        .c3_ddr4_axi_arid     (c3_ddr_bus.master.axi4_arid),   
        .c3_ddr4_axi_arlen    (c3_ddr_bus.master.axi4_arlen),  
        .c3_ddr4_axi_arlock   (c3_ddr_bus.master.axi4_arlock), 
        .c3_ddr4_axi_arprot   (c3_ddr_bus.master.axi4_arport), 
        .c3_ddr4_axi_arqos    (c3_ddr_bus.master.axi4_arqos),  
        .c3_ddr4_axi_arready  (c3_ddr_bus.master.axi4_arready),
        .c3_ddr4_axi_arregion (c3_ddr_bus.master.axi4_arregion),
        .c3_ddr4_axi_arsize   (c3_ddr_bus.master.axi4_arsize), 
        .c3_ddr4_axi_arvalid  (c3_ddr_bus.master.axi4_arvalid),
        .c3_ddr4_axi_awaddr   (c3_ddr_bus.master.axi4_awaddr), 
        .c3_ddr4_axi_awburst  (c3_ddr_bus.master.axi4_awburst),
        .c3_ddr4_axi_awcache  (c3_ddr_bus.master.axi4_awcache),
        .c3_ddr4_axi_awid     (c3_ddr_bus.master.axi4_awid),   
        .c3_ddr4_axi_awlen    (c3_ddr_bus.master.axi4_awlen),  
        .c3_ddr4_axi_awlock   (c3_ddr_bus.master.axi4_awlock), 
        .c3_ddr4_axi_awprot   (c3_ddr_bus.master.axi4_awport), 
        .c3_ddr4_axi_awqos    (c3_ddr_bus.master.axi4_awqos),  
        .c3_ddr4_axi_awready  (c3_ddr_bus.master.axi4_awready),
        .c3_ddr4_axi_awregion (c3_ddr_bus.master.axi4_awregion),
        .c3_ddr4_axi_awsize   (c3_ddr_bus.master.axi4_awsize), 
        .c3_ddr4_axi_awvalid  (c3_ddr_bus.master.axi4_awvalid),
        .c3_ddr4_axi_bid      (c3_ddr_bus.master.axi4_bid),    
        .c3_ddr4_axi_bready   (c3_ddr_bus.master.axi4_bready), 
        .c3_ddr4_axi_bresp    (c3_ddr_bus.master.axi4_bresp),  
        .c3_ddr4_axi_bvalid   (c3_ddr_bus.master.axi4_bvalid), 
        .c3_ddr4_axi_rdata    (c3_ddr_bus.master.axi4_rdata),  
        .c3_ddr4_axi_rid      (c3_ddr_bus.master.axi4_rid),    
        .c3_ddr4_axi_rlast    (c3_ddr_bus.master.axi4_rlast),  
        .c3_ddr4_axi_rready   (c3_ddr_bus.master.axi4_rready), 
        .c3_ddr4_axi_rresp    (c3_ddr_bus.master.axi4_rresp),  
        .c3_ddr4_axi_rvalid   (c3_ddr_bus.master.axi4_rvalid), 
        .c3_ddr4_axi_wdata    (c3_ddr_bus.master.axi4_wdata),  
        .c3_ddr4_axi_wlast    (c3_ddr_bus.master.axi4_wlast),  
        .c3_ddr4_axi_wready   (c3_ddr_bus.master.axi4_wready), 
        .c3_ddr4_axi_wstrb    (c3_ddr_bus.master.axi4_wstrb),  
        .c3_ddr4_axi_wvalid   (c3_ddr_bus.master.axi4_wvalid), 
        //ddr status
        .ddr_cal_done         ({c3_ddr_bus.master.ddr_cal_done,c2_ddr_bus.master.ddr_cal_done,c0_ddr_bus.master.ddr_cal_done,c0_ddr_bus.master.ddr_cal_done}),   //sys_alite_aclk clock domain 
        //interrupt
        .usr_int_en           (usr_int_bus.dut.usr_int_en)           ,   //pcie core clock domain
        .usr_int_req          (usr_int_bus.dut.usr_int_req)           ,
        .usr_int_ack          (usr_int_bus.dut.usr_int_ack)
); 
//===================================================================================
//reference model
//===================================================================================
aliyun_faas_card_model faas_card_model(
    .c0_ddr4(c0_ddr_bus.slave),
    .c1_ddr4(c1_ddr_bus.slave),
    .c2_ddr4(c2_ddr_bus.slave),
    .c3_ddr4(c3_ddr_bus.slave)
    );                              
endmodule
