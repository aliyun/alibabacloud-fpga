//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom xdma driver,used to read and write the xdma bus.
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
class aliyun_faas_xdma_driver;
//===================================================================================
//members
//===================================================================================
mailbox xdma_write_req;
mailbox xdma_write_ack;
mailbox xdma_read_req;
mailbox xdma_read_ack;
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
           ).master_tb xdma_driver;
//byte unsigned  xdma_rdata_cache[2**`XDMA_ARID_WIDTH-1][];
xdma_rdata_pkg xdma_rdata[2**`XDMA_ARID_WIDTH-1];
//===================================================================================
//write address channel
//===================================================================================
task xdma_awaddr_op(input [`XDMA_AWADDR_WIDTH-1:0] awddr,
                    input [`XDMA_AWLEN_WIDTH-1:0] awlen);
    @(posedge xdma_driver.axi4_clk)
    begin
        xdma_driver.axi4_awaddr<=awddr;
        xdma_driver.axi4_awburst<=`XDMA_AWBURST;
        xdma_driver.axi4_awid<='d0;
        xdma_driver.axi4_awlen<=awlen-1'b1;
        xdma_driver.axi4_awsize<=`XDMA_AWSIZE;
        xdma_driver.axi4_awvalid<=1'b1;
    end
    //@(posedge xdma_driver.axi4_clk);
    fork
        begin //wait for awready high
            while(~xdma_driver.axi4_awready)
            begin
                @(posedge xdma_driver.axi4_clk);
            end
        end
        begin //time out check
            if(`XDMA_CHECK_ENABLE)
            begin
                repeat (`XDMA_AWADDR_TIMEOUT)
                begin
                    @(posedge xdma_driver.axi4_clk);
                end
            end
            else
                while(`TRUE);
        end
    join_any
    if(~xdma_driver.axi4_awready)
    begin
        $display("CRITICAL ERROR:The design might have an error in xdma awaddr channel");
        $stop;
    end
    else
    begin
        @(posedge xdma_driver.axi4_clk)
        begin
            xdma_driver.axi4_awaddr<='d0;
            xdma_driver.axi4_awburst<='d0;
            xdma_driver.axi4_awid<='d0;
            xdma_driver.axi4_awlen<='d0;
            xdma_driver.axi4_awsize<='d0;
            xdma_driver.axi4_awvalid<='d0;
        end
    end
endtask
//===================================================================================
//write data channel operation
//===================================================================================
task xdma_wdata_op(input logic [`XDMA_WDATA_WIDTH-1:0] wdata[$],
                   input logic [`XDMA_AWLEN_WIDTH-1:0] length,
                   input logic [`XDMA_AWLEN_WIDTH-1:0] last_pkg_size);
    while(length>0)
    begin        
        begin
            xdma_driver.axi4_wdata<=wdata.pop_front();
            xdma_driver.axi4_wvalid<='b1;
            if(length==1)
            begin
                xdma_driver.axi4_wstrb<=(2**last_pkg_size-1);
                xdma_driver.axi4_wlast<=1'b1;
            end
            else
            begin
                xdma_driver.axi4_wstrb<=({2**`XDMA_AWSIZE{1'b1}});
                xdma_driver.axi4_wlast<=1'b0;
            end
        end
        
        @(posedge xdma_driver.axi4_clk);
        fork
            begin //check the wready state
                while(~xdma_driver.axi4_wready)
                    @(posedge xdma_driver.axi4_clk);
            end            
//            begin //time out check
//                if(`XDMA_CHECK_ENABLE)
//                    begin
//                        repeat (`XDMA_WDATA_TIMEOUT)
//                        begin
//                            @(posedge xdma_driver.axi4_clk);
//                        end
//                    end
//                else
//                   while(`TRUE);
//            end            
        join_any
        if(~xdma_driver.axi4_wready)
            begin
                $display("CRITICAL ERROR:The design might have an error in xdma wdata channel");
                $stop;
            end
        else
            length=length-1'b1;  
    end
    xdma_driver.axi4_wdata<='d0;
    xdma_driver.axi4_wvalid<='b0;
    xdma_driver.axi4_wstrb<='d0;
    xdma_driver.axi4_wlast<='b0;
endtask
//===================================================================================
//xdma bresp channel operation
//===================================================================================
task xdma_bresp_op(output [`XDMA_BRESP_WIDTH-1:0] write_state);
    begin
        xdma_driver.axi4_bready<=1'b1;
    end
    //@(posedge xdma_driver.axi4_clk);
    fork 
        begin //check the bvalid state
            while(~xdma_driver.axi4_bvalid)
                @(posedge xdma_driver.axi4_clk);
        end
        begin
            if(`XDMA_CHECK_ENABLE)
            begin
                repeat (`XDMA_BRESP_TIMEOUT)
                begin
                    @(posedge xdma_driver.axi4_clk);
                end        
            end
            else    
                while(`TRUE);
        end
    join_any 
    if(~xdma_driver.axi4_bvalid)
        begin
            $display("CRITICAL ERROR:The design might have an error in xdma bresp channel");
            $stop;            
        end
     else
        begin
            @(posedge xdma_driver.axi4_clk);
            xdma_driver.axi4_bready<=1'b0;
            write_state=xdma_driver.axi4_bresp;
        end
endtask
//===================================================================================
//xdma write channel operation
//===================================================================================
task xdma_write_op();
    xdma_write_pkg xdma_write_cache;
    while(`TRUE)
    begin
        xdma_write_req.get(xdma_write_cache); //get write request from the agent
        xdma_write_cache.data_pack();         //align the data
        xdma_awaddr_op(xdma_write_cache.awaddr,xdma_write_cache.awlen);
        xdma_wdata_op(xdma_write_cache.wdata_align,xdma_write_cache.awlen,xdma_write_cache.last_pkg_size);
        xdma_bresp_op(xdma_write_cache.write_state);
        xdma_write_ack.put(xdma_write_cache);
    end
endtask
//===================================================================================
//xdma raddr channel operation
//===================================================================================
task xdma_raddr_op(xdma_read_araddr_pkg araddr_cmd);
    @(posedge xdma_driver.axi4_clk)
    begin
        xdma_driver.axi4_arbusrt<=`XDMA_ARBURST;
        xdma_driver.axi4_araddr<=araddr_cmd.araddr;
        xdma_driver.axi4_arid<=araddr_cmd.arid;
        xdma_driver.axi4_arlen<=araddr_cmd.arlen_cal();
        xdma_driver.axi4_arsize<=`XDMA_ARSIZE;
        xdma_driver.axi4_arvalid<=1'b1;
    end
    fork
        begin //wait for the arready high
            while(~xdma_driver.axi4_arready)
                @(posedge xdma_driver.axi4_clk);
        end
        begin
            if(`XDMA_CHECK_ENABLE)
            begin
                repeat (`XDMA_ARADDR_TIMEOUT)
                begin
                    @(posedge xdma_driver.axi4_clk);
                end        
             end 
             else
                while(`TRUE);   
        end
    join_any
    if(~xdma_driver.axi4_arready)
        begin
            $display("CRITICAL ERROR:The design might have an error in xdma araddr channel");
            $stop;            
        end
    else
        begin
            @(posedge xdma_driver.axi4_clk);
            xdma_driver.axi4_arbusrt<=`XDMA_ARBURST;
            xdma_driver.axi4_araddr<=araddr_cmd.araddr;
            xdma_driver.axi4_arid<=araddr_cmd.arid;
            xdma_driver.axi4_arlen<='d0;
            xdma_driver.axi4_arsize<=`XDMA_ARSIZE;
            xdma_driver.axi4_arvalid<=1'b0;
        end
endtask
//===================================================================================
//xdma rdata channel operation
//===================================================================================
task xdma_rdata_op();
    while(`TRUE)
    begin
        @(posedge xdma_driver.axi4_clk)
        begin
            if(xdma_driver.axi4_rvalid)
            begin
                if(xdma_rdata[xdma_driver.axi4_rid]==null)
                begin
                    $display ("There are no read request for the rid=%d in xdma channel",xdma_driver.axi4_rid);
                    $stop();
                end
                xdma_rdata[xdma_driver.axi4_rid].rdata_process(xdma_driver.axi4_rdata);
                if(xdma_driver.axi4_rlast)  //return the data recived to agent
                begin
                    xdma_rdata[xdma_driver.axi4_rid].state=xdma_driver.axi4_rresp;
                    xdma_read_ack.put(xdma_rdata[xdma_driver.axi4_rid]);
                    xdma_rdata[xdma_driver.axi4_rid]=null; //clear the data object to recive the new data package
                end
            end
        end    
    end
endtask
//===================================================================================
//xdma readchannel operation
//===================================================================================
task xdam_read_op();
    fork
        begin//read_raddr_opeation
            xdma_read_araddr_pkg read_request;
            while(`TRUE)
            begin
                xdma_read_req.get(read_request);
                xdma_rdata[read_request.arid]=new(read_request.araddr,read_request.arid,read_request.length,read_request.read_flag);
                xdma_raddr_op(read_request);
            end
        end
        begin
            xdma_rdata_op();
        end
    join_none
endtask 
//===================================================================================
//constructor
//===================================================================================
function new(virtual axi4#(     
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
                            ).master_tb xdma_driver);
    this.xdma_driver=xdma_driver;
endfunction 
//===================================================================================
//build phase
//===================================================================================
task build();
    xdma_driver.axi4_araddr<='d0;
    xdma_driver.axi4_arbusrt<='d0;
    xdma_driver.axi4_arid<='d0;
    xdma_driver.axi4_arlen<='d0;
    xdma_driver.axi4_arcache<='d0;
    xdma_driver.axi4_arlock<='d0;
    xdma_driver.axi4_arport<='d0;
    xdma_driver.axi4_arqos<='d0;
    xdma_driver.axi4_arregion<='d0;
    xdma_driver.axi4_arsize<='d0;
    xdma_driver.axi4_arvalid<='d0;
    xdma_driver.axi4_awaddr<='d0;
    xdma_driver.axi4_awburst<='d0;
    xdma_driver.axi4_awcache<='d0;
    xdma_driver.axi4_awid<='d0;
    xdma_driver.axi4_awlen<='d0;
    xdma_driver.axi4_awlock<='d0;
    xdma_driver.axi4_awport<='d0;
    xdma_driver.axi4_awqos<='d0;
    xdma_driver.axi4_awregion<='d0;
    xdma_driver.axi4_awsize<='d0;
    xdma_driver.axi4_awvalid<='d0;
    xdma_driver.axi4_bready<='d0;
    xdma_driver.axi4_wdata<='d0;
    xdma_driver.axi4_wlast<='d0;
    xdma_driver.axi4_wstrb<='d0;
    xdma_driver.axi4_wvalid<='d0;
    xdma_driver.axi4_wuser<='d0;
    xdma_driver.axi4_rready<='d1;
    xdma_driver.axi4_reset(`XDMA_RESET_CYCLE);
endtask

//===================================================================================
//run phase
//===================================================================================
task run();
    fork
        xdam_read_op();
        xdma_write_op();
    join_none 
endtask 
endclass
