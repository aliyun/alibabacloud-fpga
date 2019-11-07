//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom dma driver,used to read and write the dma bus.
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
class aliyun_faas_dma_driver;
//===================================================================================
//members
//===================================================================================
mailbox dma_write_req;
mailbox dma_write_ack;
mailbox dma_read_req;
mailbox dma_read_ack;
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
              ).slave_tb dma_driver;

dma_write_pkg dma_write_cache;
dma_read_pkg  dma_read_req_cache,dam_read_ack_cache;    //dma read cache
//===================================================================================
//dma awaddr operation
//===================================================================================
task dma_awaddr_op();
    @(posedge dma_driver.axi4_clk)
        dma_driver.axi4_awready<='d1; 
    //@(posedge dma_driver.axi4_clk);   
    /*while(~dma_driver.axi4_awvalid)
    begin
        @(posedge dma_driver.axi4_clk);
    end*/
    wait(dma_driver.axi4_awvalid);
    dma_write_cache=new(dma_driver.axi4_awaddr,dma_driver.axi4_awsize,dma_driver.axi4_awlen);
    @(posedge dma_driver.axi4_clk)
    begin//generate the dma_write_pkg object;
        dma_driver.axi4_awready<='d0;
    end
endtask
//===================================================================================
//dma wdata operation
//===================================================================================
task dma_wdata_op();
    dma_driver.axi4_wready<='b1;
    @(negedge dma_driver.axi4_clk);
    while(~dma_driver.axi4_wlast)
    begin
        if(~dma_driver.axi4_wvalid)
            @(negedge dma_driver.axi4_clk);
        else
        begin
            if(~dma_write_cache.data_process(dma_driver.axi4_wdata,dma_driver.axi4_wstrb))
            begin
                $display("CRITICAL ERROR: The number you write exceeds you set in dma awaddr channel");
                $stop();
            end
            @(negedge dma_driver.axi4_clk);
        end
    end
    if(~dma_write_cache.data_process(dma_driver.axi4_wdata,dma_driver.axi4_wstrb))
    begin
       $display("CRITICAL ERROR: The number you write exceeds you set in dma awaddr channel");
       $stop();
    end
    @(posedge dma_driver.axi4_clk)
        dma_driver.axi4_wready<='b0;
endtask
//===================================================================================
//dma bresp operation
//===================================================================================
task dma_bresp_op();
    begin
        dma_driver.axi4_bid<='d0;
        dma_driver.axi4_bresp<=dma_write_cache.write_state;
        dma_driver.axi4_bvalid<='d1;
    end
    while(~dma_driver.axi4_bready)
    begin
        @(posedge dma_driver.axi4_clk);
    end
endtask 
//===================================================================================
//dma write channel operation
//===================================================================================
task dma_write_op();
    while(`TRUE)
    begin
        dma_awaddr_op();                    //awaddr channel operation
        dma_wdata_op();                     //wdata channel operation
        dma_write_req.put(dma_write_cache); //transfer the write data to agent
        dma_write_ack.get(dma_write_cache); //get the write state message from the agent
        dma_bresp_op();                     //bresp channel operation
    end
endtask
//===================================================================================
//dma read araddr channel operation
//===================================================================================
task dma_araddr_op();
    while (`TRUE)
    begin
        @(posedge dma_driver.axi4_clk)
        begin
            dma_driver.axi4_arready<=1'b1;
        end
        //@(posedge dma_driver.axi4_clk);
        /*while(~dma_driver.axi4_arvalid) 
        begin
            @(posedge dma_driver.axi4_clk);
        end*/
        wait(dma_driver.axi4_arvalid);
        dma_read_req_cache=new(dma_driver.axi4_araddr,dma_driver.axi4_arid,dma_driver.axi4_arsize,dma_driver.axi4_arlen);       //generate read request pkg
        dma_read_req.put(dma_read_req_cache);   //send the dam read request to the agent
        @(posedge dma_driver.axi4_clk)
            dma_driver.axi4_arready<=1'b0;        
    end
endtask 
//===================================================================================
//dma read rdata channel operation
//===================================================================================
task dma_rdata_op();
    dma_driver.axi4_rvalid<=1'b1;
    repeat(dam_read_ack_cache.length-1)
    begin
        dma_driver.axi4_rdata<=dam_read_ack_cache.rdata_generate();
        dma_driver.axi4_rid<=dam_read_ack_cache.id;
        if(dma_driver.axi4_rready)
        begin
            @(posedge dma_driver.axi4_clk);
        end
        else
        begin 
            while(~dma_driver.axi4_rready)
                begin
                     @(posedge dma_driver.axi4_clk);
                end
        end
    end
    begin   //last data process
        dma_driver.axi4_rdata<=dam_read_ack_cache.rdata_generate();
        dma_driver.axi4_rid<=dam_read_ack_cache.id;
        dma_driver.axi4_rlast<='d1;
        dma_driver.axi4_rresp<=dam_read_ack_cache.read_state;
        if(dma_driver.axi4_rready)
        begin
            @(posedge dma_driver.axi4_clk);
        end
        else
        begin 
            while(~dma_driver.axi4_rready)
                begin
                     @(posedge dma_driver.axi4_clk);
                end
        end
        dma_driver.axi4_rlast<='d0; 
        dma_driver.axi4_rvalid<=1'b0;       
    end
endtask
//===================================================================================
//dma read operation
//===================================================================================
task dma_read_op();
    fork 
        begin   //araddr channel operation
            dma_araddr_op();
        end
        
        begin   //rdata channel operation
            while(`TRUE)
            begin
                dma_read_ack.get(dam_read_ack_cache);
                dma_rdata_op();
            end
        end
    join_none
endtask 
//===================================================================================
//constructor
//===================================================================================
function new(virtual axi4#(.ARADDR_WIDTH(`DMA_ARADDR_WIDTH),
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
                           ).slave_tb dma_driver);
    this.dma_driver=dma_driver;
endfunction 
//===================================================================================
//build phase
//===================================================================================
task build();
    dma_driver.axi4_awready<='d0;
    dma_driver.axi4_arready<='d0;
    dma_driver.axi4_bid<='d0;
    dma_driver.axi4_bresp<='d0;
    dma_driver.axi4_bvalid<='d0;
    dma_driver.axi4_rdata<='d0;
    dma_driver.axi4_rid<='d0;
    dma_driver.axi4_rlast<='d0;
    dma_driver.axi4_rresp<='d0;
    dma_driver.axi4_ruser<='d0;
    dma_driver.axi4_rvalid<='d0;
    dma_driver.axi4_wready<='d0;
    dma_driver.axi4_4k_w_err<='d0;
    dma_driver.axi4_4k_r_err<='d0;
    dma_driver.axi4_reset(`DMA_RESET_CYCLE);
endtask
//===================================================================================
//run phase
//===================================================================================
task run();
    fork
        dma_write_op();
        dma_read_op();
    join_none 
endtask
endclass 