//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom alite bus driver,used to read and write the axi-lite bus.
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////  
class aliyun_faas_alite_driver;
//===================================================================================
//members
//===================================================================================
mailbox write_cmd_req;
mailbox write_cmd_ack;
mailbox read_cmd_req;
mailbox read_cmd_ack;
virtual axi_lite#(.AWADDR_WIDTH(`ALITE_AWADDR_WIDTH),
                  .AWPORT_WIDTH(`ALITE_AWPORT_WIDTH),
                  .WDATA_WIDTH(`ALITE_WDATA_WIDTH),
                  .WSTRB_WIDTH(`ALITE_WSTRB_WIDTH),
                  .BRESP_WIDTH(`ALITE_BRESP_WIDTH),
                  .ARADDR_WIDTH(`ALITE_ARADDR_WIDTH),
                  .ARPORT_WIDTH(`ALITE_ARPORT_WIDTH),
                  .RDATA_WIDTH(`ALITE_RDATA_WIDTH),
                  .RRESP_WIDTH(`ALITE_RRESP_WIDTH)).tb alite_driver;
//methods
//===================================================================================
//alite_write address operation
//===================================================================================
task alite_write_addr(input logic [`ALITE_AWADDR_WIDTH-1:0] write_addr);
    @(posedge alite_driver.axi_lite_clk)
    begin
        alite_driver.axi_lite_awvalid<=1'b1;
        alite_driver.axi_lite_awaddr<=write_addr;
    end
    fork
        begin
            while(~alite_driver.axi_lite_awready)
            begin
                @(posedge alite_driver.axi_lite_clk);
            end
        end
        begin
            if(`AXI_LITE_CHECK_ENABLE)
               repeat(`ALITE_AWADDR_TIMEOUT)
               begin
                  @(posedge alite_driver.axi_lite_clk);
               end
            else
               while(`TRUE);
        end
    join_any 
    if(~alite_driver.axi_lite_awready)
        begin
            $display("CRITICAL ERROR: The disign might have an error in alite write address channel");
            $stop;
        end
     else begin
        @(posedge alite_driver.axi_lite_clk)
        begin
            alite_driver.axi_lite_awvalid<=1'b0;
            alite_driver.axi_lite_awaddr<='d0;
        end
     end
endtask 
//===================================================================================
//alite_write data operation
//===================================================================================
task alite_write_data(input logic [`ALITE_WDATA_WIDTH-1:0] write_data);
    //@(posedge alite_driver.axi_lite_clk)
    begin
        alite_driver.axi_lite_wvalid<=1'b1;
        alite_driver.axi_lite_wstrb<={`ALITE_WSTRB_WIDTH{1'b1}};
        alite_driver.axi_lite_wdata<=write_data;        
    end
    fork
        begin
            while(~alite_driver.axi_lite_wready)
            begin
                @(posedge alite_driver.axi_lite_clk);
            end
        end
        begin
            if(`AXI_LITE_CHECK_ENABLE)
               repeat(`ALITE_WDATA_TIMEOUT)
               begin
                  @(posedge alite_driver.axi_lite_clk);
               end
             else
               while(`TRUE);
        end
    join_any
    if(~alite_driver.axi_lite_wready)
        begin
            $display("CRITICAL ERROR:The disign might have an error in alite write data channel");
            $stop;
        end
     else begin
        @(posedge alite_driver.axi_lite_clk)
        begin
            alite_driver.axi_lite_wvalid<=1'b0;
            alite_driver.axi_lite_wstrb<={`ALITE_WSTRB_WIDTH{1'b0}};
            alite_driver.axi_lite_wdata<='d0;   
        end 
     end 
endtask 
//===================================================================================
//alite_write bresp operation
//===================================================================================
task alite_write_bresp(output logic[`ALITE_BRESP_WIDTH-1:0] write_resp);
    //@(posedge alite_driver.axi_lite_clk)
    begin
        alite_driver.axi_lite_bready<=1'b1;        
    end
    fork
        begin 
            while(~alite_driver.axi_lite_bvalid)
            begin
                @(posedge alite_driver.axi_lite_clk);
            end
        end
        begin
            if(`AXI_LITE_CHECK_ENABLE)
                repeat(`ALITE_BRESP_TIMEOUT)
                begin
                    @(posedge alite_driver.axi_lite_clk);
                end
            else
                while(`TRUE);
        end
    join_any
    if(~alite_driver.axi_lite_bvalid)
        begin
            $display("CRITICAL ERROR:The disign might have an error in alite write bresp channel");
            $stop;
        end
     else
     begin
        @(posedge alite_driver.axi_lite_clk)
        begin
            alite_driver.axi_lite_bready<=1'b0;
            write_resp=alite_driver.axi_lite_bresp;
        end
     end     
endtask
//===================================================================================
//alite_write method
//===================================================================================
task alite_write_operation();
    alite_write_package write_data_cache;
    while(1)
    begin
        write_cmd_req.get(write_data_cache);                            //get write cmd from the agent
        alite_write_addr(write_data_cache.write_addr);                  //write address operation
        alite_write_data(write_data_cache.write_data);                  //write data operation
        alite_write_bresp(write_data_cache.write_state);                //write bresp operation
        write_cmd_ack.put(write_data_cache);                            //retrun the result to the agent
    end
endtask
//===================================================================================
//alite_read address operation
//===================================================================================
task alite_read_addr_opertaion(input [`ALITE_ARADDR_WIDTH-1:0] read_addr);
    @(posedge alite_driver.axi_lite_clk)
    begin
        alite_driver.axi_lite_arvalid<=1'b1;
        alite_driver.axi_lite_araddr<=read_addr;
    end
    fork
        begin
            while(~alite_driver.axi_lite_arready)
            begin
                @(posedge alite_driver.axi_lite_clk);
            end
        end
	begin
	    if(`AXI_LITE_CHECK_ENABLE)
                repeat(`ALITE_ARADDR_TIMEOUT)
                begin
                    @(posedge alite_driver.axi_lite_clk);
                end
            else
                while(`TRUE);
	end
    join_any 
    if(~alite_driver.axi_lite_arready)
        begin
            $display("CRITICAL ERROR:The disign might have an error in alite read address channel");
            $stop;
        end
     else begin
        @(posedge alite_driver.axi_lite_clk)
        begin
            alite_driver.axi_lite_arvalid<=1'b0;
            alite_driver.axi_lite_araddr<='d0;
        end
     end
endtask
//===================================================================================
//alite_read data and state operation
//===================================================================================
task alite_read_data_operation(output [`ALITE_RDATA_WIDTH-1:0] read_data,output [`ALITE_RRESP_WIDTH-1:0] read_state);
    //@(posedge alite_driver.axi_lite_clk)
    begin
        alite_driver.axi_lite_rready<=1'b1;
    end
    fork
        begin
            while(~alite_driver.axi_lite_rvalid)
            begin
                @(posedge alite_driver.axi_lite_clk);
            end
        end
	begin
	    if(`AXI_LITE_CHECK_ENABLE)
                repeat(`ALITE_RDATA_TIMEOUT)
                begin
                    @(posedge alite_driver.axi_lite_clk);
                end
            else
                while(`TRUE);
	end
    join_any
    if(~alite_driver.axi_lite_rvalid)
        begin
            $display("CRITICAL ERROR:The disign might have an error in alite read data channel");
	    $stop;
        end
    else
    begin
        @(posedge alite_driver.axi_lite_clk)
        begin
            read_data=alite_driver.axi_lite_rdata;
            read_state=alite_driver.axi_lite_rresp;
            alite_driver.axi_lite_rready<=1'b0;
        end
    end
endtask
//===================================================================================
//alite_read method
//===================================================================================
task alite_read_operation();
    alite_read_package read_cache;
    while(1)
    begin
        read_cmd_req.get(read_cache);                                                //get the read command from the agent
        alite_read_addr_opertaion(read_cache.read_addr);                             //read address operation
        alite_read_data_operation(read_cache.read_data,read_cache.read_state);       //read data and state opeation
        read_cmd_ack.put(read_cache);                                                //return the result to the agent
    end
endtask
//===================================================================================
//constructor
//===================================================================================
function new( virtual axi_lite#(.AWADDR_WIDTH(`ALITE_AWADDR_WIDTH),
                                .AWPORT_WIDTH(`ALITE_AWPORT_WIDTH),
                                .WDATA_WIDTH(`ALITE_WDATA_WIDTH),
                                .WSTRB_WIDTH(`ALITE_WSTRB_WIDTH),
                                .BRESP_WIDTH(`ALITE_BRESP_WIDTH),
                                .ARADDR_WIDTH(`ALITE_ARADDR_WIDTH),
                                .ARPORT_WIDTH(`ALITE_ARPORT_WIDTH),
                                .RDATA_WIDTH(`ALITE_RDATA_WIDTH),
                                .RRESP_WIDTH(`ALITE_RRESP_WIDTH)).tb alite_driver);
    this.alite_driver=alite_driver;
endfunction 
//===================================================================================
//build phase
//global reset the axi-lite bus
//===================================================================================
task build();
    alite_driver.axi_lite_awvalid   <='d0;
    alite_driver.axi_lite_awaddr    <='d0;
    alite_driver.axi_lite_awport    <='d0;
    alite_driver.axi_lite_wvalid    <='d0;
    alite_driver.axi_lite_wdata     <='d0;
    alite_driver.axi_lite_wstrb     <='d0;
    alite_driver.axi_lite_bready    <='d0;
    alite_driver.axi_lite_arvalid   <='d0;
    alite_driver.axi_lite_araddr    <='d0;
    alite_driver.axi_lite_arport    <='d0;
    alite_driver.axi_lite_rready    <='d0;
    alite_driver.axi_lite_reset(`ALITE_RESET_CYCLE);
endtask
//===================================================================================
//run phase
//===================================================================================
task run();
    fork
        alite_read_operation();
        alite_write_operation();
    join_none
endtask

endclass 
