//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom environment
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 -File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`ifndef FAAS_SIM_ENV
    `define FAAS_SIM_ENV
    `include "aliyun_faas_agent.sv"
    `include "aliyun_faas_driver.sv"
    `include "aliyun_faas_interfaces.sv"
    `include "aliyun_faas_base_pkg.sv"
    `include "config.v"
`endif
class aliyun_faas_sim_env;
//===================================================================================
//members
//===================================================================================
//mailbox between agent and driver alite channel
mailbox a2d_alite_write_cmd_req;
mailbox d2a_alite_write_cmd_ack;
mailbox a2d_alite_read_cmd_req;
mailbox d2a_alite_read_cmd_ack;
//mailbox between user and agent alite channel
mailbox u2a_alite_write_cmd_req;
mailbox a2u_alite_write_cmd_ack;
mailbox u2a_alite_read_cmd_req;
mailbox a2u_alite_read_cmd_ack; 
//mailbox between interrupt and agent
mailbox i2a_alite_write_cmd_req;
mailbox a2i_alite_write_cmd_ack;
mailbox i2a_alite_read_cmd_req;
mailbox a2i_alite_read_cmd_ack;
//mailbox between agent and driver xdma channel
mailbox a2d_xdma_write_req;
mailbox d2a_xdma_write_ack;
mailbox a2d_xdma_read_req;
mailbox d2a_xdma_read_ack;
//mailbox between user and agent xdma channel
mailbox u2a_xdma_write_req;
mailbox a2u_xdma_write_ack;
mailbox u2a_xdma_read_req;
mailbox a2u_xdma_read_ack;
//mailbox between interrupt and agent xdma channel
mailbox i2a_xdma_write_req;
mailbox a2i_xdma_write_ack;
mailbox i2a_xdma_read_req;
mailbox a2i_xdma_read_ack;
//mailbox between agent and driver dma channel
mailbox d2a_dma_write_req;
mailbox a2d_dma_write_ack;
mailbox d2a_dma_read_req;
mailbox a2d_dma_read_ack;
//mailbox between user and agent  dma channel 
mailbox u2a_dma_write_req;
mailbox a2u_dma_write_ack;
mailbox u2a_dma_read_req;
mailbox a2u_dma_read_ack;  
//mailbox between user and interrupt dma channel
mailbox i2a_dma_write_req;
mailbox a2i_dma_write_ack;
mailbox i2a_dma_read_req;
mailbox a2i_dma_read_ack;
//mailbox between driver and agent interrupt channel
mailbox d2a_int_req;
mailbox a2d_int_ack;
//mailbox between interrupt and agent interrupt channel
mailbox a2i_int_req;
mailbox i2a_int_ack;
//mailbox between user and agent,used to open or close interrupt enable interrupt channel
mailbox u2a_int_req;

//interfaces
//virtual axi_lite.tb alite_driver;
//virtual axi4.master_tb xdma_driver;
//virtual axi4.slave_tb dma_driver;
//virtual faas_interrupt.tb int_driver;

virtual ddr_axi4.slave c0_ddr4_if;
virtual ddr_axi4.slave c1_ddr4_if;
virtual ddr_axi4.slave c2_ddr4_if;
virtual ddr_axi4.slave c3_ddr4_if;

//faas driver
aliyun_faas_driver  faas_driver;
//faas agent
aliyun_faas_agent   faas_agent;
//evnet array
event interrupt_trig[`INTERRUPT_WIDTH];
//event interrupt_done[`INTERRUPT_WIDTH];
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
             virtual axi4#(    .ARADDR_WIDTH(`DMA_ARADDR_WIDTH),
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
             virtual faas_interrupt#(.INTERRUPT_WIDTH(`INTERRUPT_WIDTH)).tb int_driver,
             virtual ddr_axi4.slave c0_ddr4_if,
             virtual ddr_axi4.slave c1_ddr4_if,
             virtual ddr_axi4.slave c2_ddr4_if,
             virtual ddr_axi4.slave c3_ddr4_if
            );
//    this.alite_driver=alite_driver;
//    this.xdma_driver=xdma_driver;
//    this.dma_driver=dma_driver;
//    this.int_driver=int_driver;
    this.c0_ddr4_if=c0_ddr4_if;
    this.c1_ddr4_if=c1_ddr4_if;
    this.c2_ddr4_if=c2_ddr4_if;
    this.c3_ddr4_if=c3_ddr4_if;
    
    faas_driver=new(alite_driver,xdma_driver,dma_driver,int_driver);
    faas_agent=new();
    
    a2d_alite_write_cmd_req=new();
    d2a_alite_write_cmd_ack=new();
    a2d_alite_read_cmd_req=new();
    d2a_alite_read_cmd_ack=new();
    
    u2a_alite_write_cmd_req=new();
    a2u_alite_write_cmd_ack=new();
    u2a_alite_read_cmd_req=new();
    a2u_alite_read_cmd_ack=new(); 

    i2a_alite_write_cmd_req=new();
    a2i_alite_write_cmd_ack=new();
    i2a_alite_read_cmd_req=new();
    a2i_alite_read_cmd_ack=new();

    a2d_xdma_write_req=new();
    d2a_xdma_write_ack=new();
    a2d_xdma_read_req=new();
    d2a_xdma_read_ack=new();

    u2a_xdma_write_req=new();
    a2u_xdma_write_ack=new();
    u2a_xdma_read_req=new();
    a2u_xdma_read_ack=new();

    i2a_xdma_write_req=new();
    a2i_xdma_write_ack=new();
    i2a_xdma_read_req=new();
    a2i_xdma_read_ack=new();

    d2a_dma_write_req=new();
    a2d_dma_write_ack=new();
    d2a_dma_read_req=new();
    a2d_dma_read_ack=new();

    u2a_dma_write_req=new();
    a2u_dma_write_ack=new();
    u2a_dma_read_req=new();
    a2u_dma_read_ack=new();

    i2a_dma_write_req=new();
    a2i_dma_write_ack=new();
    i2a_dma_read_req=new();
    a2i_dma_read_ack=new();

    d2a_int_req=new();
    a2d_int_ack=new();

    a2i_int_req=new();
    i2a_int_ack=new();

    u2a_int_req=new();
endfunction
//===================================================================================
//build                                                                      
//===================================================================================
task build();
    faas_agent.a2d_alite_write_cmd_req=a2d_alite_write_cmd_req;
    faas_agent.d2a_alite_write_cmd_ack=d2a_alite_write_cmd_ack;
    faas_agent.a2d_alite_read_cmd_req=a2d_alite_read_cmd_req;
    faas_agent.d2a_alite_read_cmd_ack=d2a_alite_read_cmd_ack;
    
    faas_agent.u2a_alite_write_cmd_req=u2a_alite_write_cmd_req;
    faas_agent.a2u_alite_write_cmd_ack=a2u_alite_write_cmd_ack;
    faas_agent.u2a_alite_read_cmd_req=u2a_alite_read_cmd_req;
    faas_agent.a2u_alite_read_cmd_ack=a2u_alite_read_cmd_ack;
    
    faas_agent.i2a_alite_write_cmd_req=i2a_alite_write_cmd_req;
    faas_agent.a2i_alite_write_cmd_ack=a2i_alite_write_cmd_ack;
    faas_agent.i2a_alite_read_cmd_req=i2a_alite_read_cmd_req;
    faas_agent.a2i_alite_read_cmd_ack=a2i_alite_read_cmd_ack;
    
    faas_agent.a2d_xdma_write_req=a2d_xdma_write_req;
    faas_agent.d2a_xdma_write_ack=d2a_xdma_write_ack;
    faas_agent.a2d_xdma_read_req=a2d_xdma_read_req;
    faas_agent.d2a_xdma_read_ack=d2a_xdma_read_ack;
    
    faas_agent.u2a_xdma_write_req=u2a_xdma_write_req;
    faas_agent.a2u_xdma_write_ack=a2u_xdma_write_ack;
    faas_agent.u2a_xdma_read_req=u2a_xdma_read_req;
    faas_agent.a2u_xdma_read_ack=a2u_xdma_read_ack;
    
    faas_agent.i2a_xdma_write_req=i2a_xdma_write_req;
    faas_agent.a2i_xdma_write_ack=a2i_xdma_write_ack;
    faas_agent.i2a_xdma_read_req=i2a_xdma_read_req;
    faas_agent.a2i_xdma_read_ack=a2i_xdma_read_ack;
    
    faas_agent.d2a_dma_write_req=d2a_dma_write_req;
    faas_agent.a2d_dma_write_ack=a2d_dma_write_ack;
    faas_agent.d2a_dma_read_req=d2a_dma_read_req;
    faas_agent.a2d_dma_read_ack=a2d_dma_read_ack;
    
    faas_agent.u2a_dma_write_req=u2a_dma_write_req;
    faas_agent.a2u_dma_write_ack=a2u_dma_write_ack;
    faas_agent.u2a_dma_read_req=u2a_dma_read_req;
    faas_agent.a2u_dma_read_ack=a2u_dma_read_ack;
    
    faas_agent.i2a_dma_write_req=i2a_dma_write_req;
    faas_agent.a2i_dma_write_ack=a2i_dma_write_ack;
    faas_agent.i2a_dma_read_req=i2a_dma_read_req;
    faas_agent.a2i_dma_read_ack=a2i_dma_read_ack;
    
    faas_agent.d2a_int_req=d2a_int_req;
    faas_agent.a2d_int_ack=a2d_int_ack;
    
    faas_agent.a2i_int_req=a2i_int_req;
    faas_agent.i2a_int_ack=i2a_int_ack;
    
    faas_agent.u2a_int_req=u2a_int_req;
    
    faas_agent.build();
    
    faas_driver.alite_write_cmd_req=a2d_alite_write_cmd_req;
    faas_driver.alite_write_cmd_ack=d2a_alite_write_cmd_ack;
    faas_driver.alite_read_cmd_req=a2d_alite_read_cmd_req;
    faas_driver.alite_read_cmd_ack=d2a_alite_read_cmd_ack;
    
    faas_driver.xdma_write_req=a2d_xdma_write_req;
    faas_driver.xdma_write_ack=d2a_xdma_write_ack;
    faas_driver.xdma_read_req=a2d_xdma_read_req;
    faas_driver.xdma_read_ack=d2a_xdma_read_ack;
    
    faas_driver.dma_write_req=d2a_dma_write_req;
    faas_driver.dma_write_ack=a2d_dma_write_ack;
    faas_driver.dma_read_req=d2a_dma_read_req;
    faas_driver.dma_read_ack=a2d_dma_read_ack;
    
    faas_driver.d2a_int_req=d2a_int_req;
    faas_driver.a2d_int_ack=a2d_int_ack;
    
    faas_driver.build();
endtask
//===================================================================================
//run pahse                                                                             
//=================================================================================== 
task run();
    fork
        faas_agent.run();
        faas_driver.run();
        interrupt_monitor();
    join_none
endtask 
//===================================================================================
//interrupt monitor                                                                           
//===================================================================================
task interrupt_monitor();
    interrupt_handle_pkg int_pkg_cache;
	//event int_done_event;
    while(`TRUE)
    begin
        a2i_int_req.get(int_pkg_cache);
        ->interrupt_trig[int_pkg_cache.int_num];   
    end
endtask
//===================================================================================
//user api:faas_int_flag_clear() 
//int_num:  interrupt number                                                                       
//===================================================================================
task automatic faas_int_flag_clear(input logic [$clog2(`INTERRUPT_WIDTH)-1:0]    int_num);
    interrupt_handle_pkg int_pkg_cache;
    int_pkg_cache=new(1,int_num);
    int_pkg_cache.int_flag_clear();
    i2a_int_ack.put(int_pkg_cache);
endtask
//===================================================================================
//user api:faas_alite_write() 
//waddr:    alite write addr
//wdata:    alite write data
//channel:  0:used to write in application
//          1:used to write in interrupt
//state     rerturn the write state,equal to ali_lite bresp signals                                                                         
//===================================================================================
task automatic  faas_alite_write(input [`ALITE_AWADDR_WIDTH-1:0] waddr,
                      input [`ALITE_WDATA_WIDTH-1:0]  wdata,
                      input                           channel,
                      output[`ALITE_BRESP_WIDTH-1:0]  state
                     );
    alite_write_package alite_write_pkg;
    alite_write_pkg=new(waddr,wdata,channel);
    if(channel==0)
    begin
        u2a_alite_write_cmd_req.put(alite_write_pkg);
        a2u_alite_write_cmd_ack.get(alite_write_pkg);
        state=alite_write_pkg.write_state;
    end
    else
    begin
        i2a_alite_write_cmd_req.put(alite_write_pkg);
        a2i_alite_write_cmd_ack.get(alite_write_pkg);
        state=alite_write_pkg.write_state;
    end
endtask
//===================================================================================
//user api:faas_alite_read() 
//raddr:    alite read addr
//rdata:    alite read data
//channel:  0:used to read in application
//          1:used to read in interrupt
//state     rerturn the read state,equal to ali_lite rresp signals                                                                         
//===================================================================================
task automatic faas_alite_read(input  [`ALITE_ARADDR_WIDTH-1:0] raddr,
                     input                            channel,
                     output [`ALITE_RRESP_WIDTH-1:0]  state,
                     output [`ALITE_RDATA_WIDTH-1:0]  rdata    
                    );
    alite_read_package alite_read_pkg;
    alite_read_pkg=new(raddr,channel);
    if(channel==0)
    begin
        u2a_alite_read_cmd_req.put(alite_read_pkg);
        a2u_alite_read_cmd_ack.get(alite_read_pkg);
    end
    else
    begin
        i2a_alite_read_cmd_req.put(alite_read_pkg);
        a2i_alite_read_cmd_ack.get(alite_read_pkg);        
    end
    rdata=alite_read_pkg.read_data;
    state=alite_read_pkg.read_state;
endtask
//===================================================================================
//user api:faas_xdma_write() 
//wdata:    xdma write data
//waddr:    xdma write addr
//channel:  0:used to write in application
//          1:used to write in interrupt
//state     rerturn the write state,equal to axi_xdma bresp signals                                                                         
//===================================================================================
task automatic faas_xdma_write(input byte unsigned  wdata[],
                     input [`XDMA_AWADDR_WIDTH-1:0] waddr,
                     input                          channel,
                     output[`XDMA_BRESP_WIDTH-1:0]  state           
                    );
    xdma_write_pkg                  xdma_wpkg[$];
    xdma_write_pkg                  xdma_wcache;
    byte unsigned                   data_cache[$]={wdata};
    byte unsigned                   data_cache2[$];
    logic [`XDMA_AWADDR_WIDTH-1:0]  start_addr;
    if((waddr+data_cache.size())<=((waddr/4096+1)*4096)) //data in 4k boundary
    begin
        xdma_wcache=new(waddr,data_cache,channel);
        xdma_wpkg.push_back(xdma_wcache);
    end
    else
    begin
       //first xdma pkg
       for(int i=0;i<(waddr/4096+1)*4096-waddr;i++)
       begin
            data_cache2.push_back(data_cache.pop_front);
       end
       xdma_wcache=new(waddr,data_cache2,channel);
       xdma_wpkg.push_back(xdma_wcache);
       start_addr=(waddr/4096+1)*4096;
       //other xdma pkg except the last pkg while the last data size is not divide by 4096
       while(data_cache.size()>4096)
       begin
           data_cache2={};
           for(int i=0;i<4096;i++)
           begin
                data_cache2.push_back(data_cache.pop_front);
           end
           xdma_wcache=new(start_addr,data_cache2,channel);
           xdma_wpkg.push_back(xdma_wcache);
           start_addr=start_addr+4096;
       end
       if(data_cache.size()!=0)
        begin
           xdma_wcache=new(start_addr,data_cache,channel);
           xdma_wpkg.push_back(xdma_wcache);
        end
    end
    //data transfer
    foreach(xdma_wpkg[i])
    begin
        if(channel==0)
        begin
            u2a_xdma_write_req.put(xdma_wpkg[i]);
            a2u_xdma_write_ack.get(xdma_wcache);
            state&=xdma_wcache.write_state;
        end
        else
        begin
            i2a_xdma_write_req.put(xdma_wpkg[i]);
            a2i_xdma_write_ack.get(xdma_wcache);
            state&=xdma_wcache.write_state;
        end
    end
endtask
//===================================================================================
//user api:faas_xdma_read() 
//raddr:    xdma read addr
//length:   read length,not exceed 4096
//id:       id number used in xdma read channel,euqal to arid
//channel:  0:used to write in application
//          1:used to write in interrupt
//rdata:    return the read data
//state     rerturn the write state,equal to axi_xdma rresp signals                                                                         
//===================================================================================
task automatic faas_xdma_read(input [`XDMA_ARADDR_WIDTH-1:0]    raddr,
                              input int                         length,
                              input [`XDMA_ARID_WIDTH-1:0]      id,                              
                              input                             channel,
                              output byte unsigned              rdata[],
                              output [`XDMA_RRESP_WIDTH-1:0]    state 
                             );
    xdma_read_araddr_pkg xdma_araddr_pkg;
    xdma_rdata_pkg xdma_rdata_pkg;
    if((raddr+length)>((raddr/4096+1)*4096))
    begin
        $display("ERROR:the data read range should be in 4K boundary! raddr=%d\t,length=%d.",raddr,length);
        $stop(); 
    end
    xdma_araddr_pkg=new(raddr,id,length,channel);
    if(channel==0)
    begin
        u2a_xdma_read_req.put(xdma_araddr_pkg);
        a2u_xdma_read_ack.get(xdma_rdata_pkg);
    end
    else
    begin
        i2a_xdma_read_req.put(xdma_araddr_pkg);
        a2i_xdma_read_ack.get(xdma_rdata_pkg);
    end
    rdata=xdma_rdata_pkg.rdata;
    state=xdma_rdata_pkg.state;
endtask
//===================================================================================
//user api:faas_int_enable() 
//enable the interrupt function                                                                        
//===================================================================================
task faas_int_enable();
   interrupt_handle_pkg  int_pkg;
   int_pkg=new(1,0);
   u2a_int_req.put(int_pkg);
endtask
//===================================================================================
//user api:faas_int_close() 
//close the interrupt function                                                                        
//===================================================================================
task faas_int_close();
    interrupt_handle_pkg  int_pkg;
    int_pkg=new(0,0);
    u2a_int_req.put(int_pkg);
endtask
//===================================================================================
//user api:faas_dma_wdata_fetch() 
//get the data write form the dma channel 
//waddr:    dma write addr
//length:   fetch data length
//channel:  0:used to write in application
//          1:used to write in interrupt
//wdata:    return the wdata dma write
//state:    return the state;                                                                     
//===================================================================================
task automatic faas_dma_wdata_fetch(input [`DMA_AWADDR_WIDTH-1:0] waddr,
                          input int                     length,
                          input                         channel,
                          output byte unsigned          wdata[],
                          output                        state
                         );
    dma_data_pkg    dma_pkg;
    dma_pkg=new();
    dma_pkg.base_addr=waddr;
    dma_pkg.length=length;
    if(channel)
    begin
        u2a_dma_read_req.put(dma_pkg); 
        a2u_dma_read_ack.get(dma_pkg);
        wdata=dma_pkg.wdata;
        state=dma_pkg.state; 
    end
    else
    begin
        i2a_dma_read_req.put(dma_pkg); 
        a2i_dma_read_ack.get(dma_pkg);
        wdata=dma_pkg.wdata;
        state=dma_pkg.state;  
    end
    
endtask
//===================================================================================
//user api:faas_dma_rdata_update() 
//get the data read ro the dma channel 
//raddr:    dma read addr
//rdata[]:  the rdata dma read
//channel:  0:used to read data update in application
//          1:used to read data update in interrupt
//state:    return the state;                                                                     
//===================================================================================
task automatic faas_dma_rdata_update(input [`DMA_AWADDR_WIDTH-1:0]    raddr,
                           input byte unsigned              rdata[],
                           input                            channel,
                           output                           state          
                          );
    dma_data_pkg    dma_pkg;
    dma_pkg=new();
    dma_pkg.wdata=rdata;
    dma_pkg.base_addr=raddr;
    if(channel==0)
    begin
        u2a_dma_write_req.put(dma_pkg);
        a2u_dma_write_ack.get(dma_pkg);
    end
    else
    begin
        i2a_dma_write_req.put(dma_pkg);
        a2i_dma_write_ack.get(dma_pkg);        
    end
    state=dma_pkg.state;
endtask
//===================================================================================
//user api:faas_wait_for_ddr_cal_done() 
//wait for the ddr reference model cal done                                                                    
//===================================================================================
task faas_wait_for_ddr_cal_done(); 
    fork
        begin //c0 ddr
            `ifdef DDR0
                wait(c0_ddr4_if.ddr_cal_done);
            `endif
        end
        begin //c1 ddr
            wait(c1_ddr4_if.ddr_cal_done);
        end
        begin //c2 ddr
            `ifdef DDR2
                wait(c2_ddr4_if.ddr_cal_done);
            `endif
        end
        begin //c3 ddr
            `ifdef DDR3
                wait(c3_ddr4_if.ddr_cal_done);
            `endif
        end                        
    join
endtask 
endclass
