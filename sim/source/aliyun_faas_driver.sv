//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom  driver layer,include alite,xdma,dma,interrupt
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`ifndef FAAS_DRIVER
    `define FAAS_DRIVER
    `include "aliyun_faas_xdma_driver.sv"
    `include "aliyun_faas_interrupt_driver.sv"
    `include "aliyun_faas_alite_driver.sv"
    `include "aliyun_faas_dma_driver.sv"
`endif
class aliyun_faas_driver;
//===================================================================================
//members
//===================================================================================
//alite
mailbox alite_write_cmd_req;
mailbox alite_write_cmd_ack;
mailbox alite_read_cmd_req;
mailbox alite_read_cmd_ack;
//virtual axi_lite.tb alite_driver;
aliyun_faas_alite_driver alite_driver_layer;
//xdma
mailbox xdma_write_req;
mailbox xdma_write_ack;
mailbox xdma_read_req;
mailbox xdma_read_ack;
//virtual axi4.master_tb xdma_driver;
aliyun_faas_xdma_driver xdma_driver_layer;
//dma
mailbox dma_write_req;
mailbox dma_write_ack;
mailbox dma_read_req;
mailbox dma_read_ack;
//virtual axi4.slave_tb dma_driver;
aliyun_faas_dma_driver dma_driver_layer;
//interrupt
mailbox d2a_int_req;
mailbox a2d_int_ack;
//virtual faas_interrupt.tb int_driver;
aliyun_faas_interrupt_driver int_driver_layer;
//===================================================================================
//constructor
//===================================================================================
function new(virtual axi_lite#(.AWADDR_WIDTH(`ALITE_AWADDR_WIDTH),
                               .AWPORT_WIDTH(`ALITE_AWPORT_WIDTH),
                               .WDATA_WIDTH(`ALITE_WDATA_WIDTH),
                               .WSTRB_WIDTH(`ALITE_WSTRB_WIDTH),
                               .BRESP_WIDTH(`ALITE_BRESP_WIDTH),
                               .ARADDR_WIDTH(`ALITE_ARADDR_WIDTH),
                               .ARPORT_WIDTH(`ALITE_ARPORT_WIDTH),
                               .RDATA_WIDTH(`ALITE_RDATA_WIDTH),
                               .RRESP_WIDTH(`ALITE_RRESP_WIDTH)).tb alite_driver,
             virtual axi4#(     
                               .ARADDR_WIDTH(`XDMA_ARADDR_WIDTH),
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
                               ).master_tb xdma_driver,
             virtual axi4#(.ARADDR_WIDTH(`DMA_ARADDR_WIDTH),
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
                           ).slave_tb dma_driver,
             virtual faas_interrupt#(.INTERRUPT_WIDTH(`INTERRUPT_WIDTH)).tb int_driver
            );
   alite_driver_layer   =new(alite_driver);
   xdma_driver_layer    =new(xdma_driver);
   dma_driver_layer     =new(dma_driver);
   int_driver_layer     =new(int_driver); 
endfunction 
//===================================================================================
//build phase
//===================================================================================
task build();
    //mailbox bind
    alite_driver_layer.write_cmd_req=alite_write_cmd_req;
    alite_driver_layer.write_cmd_ack=alite_write_cmd_ack;
    alite_driver_layer.read_cmd_req=alite_read_cmd_req;
    alite_driver_layer.read_cmd_ack=alite_read_cmd_ack;
    
    xdma_driver_layer.xdma_write_req=xdma_write_req;
    xdma_driver_layer.xdma_write_ack=xdma_write_ack;
    xdma_driver_layer.xdma_read_req=xdma_read_req;
    xdma_driver_layer.xdma_read_ack=xdma_read_ack;
    
    dma_driver_layer.dma_write_req=dma_write_req;
    dma_driver_layer.dma_write_ack=dma_write_ack;
    dma_driver_layer.dma_read_req=dma_read_req;
    dma_driver_layer.dma_read_ack=dma_read_ack;
    
    int_driver_layer.int_gen_req=d2a_int_req;
    int_driver_layer.int_cmd_ack=a2d_int_ack;
    
    fork
        alite_driver_layer.build();
        xdma_driver_layer.build();
        dma_driver_layer.build();
        int_driver_layer.build();
    join 
endtask 
//===================================================================================
//run phase
//===================================================================================
task run();
    fork
        alite_driver_layer.run();
        xdma_driver_layer.run();
        dma_driver_layer.run();
        int_driver_layer.run();
    join_any
endtask
endclass
