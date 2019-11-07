//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom xdma agent layer
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
class aliyun_faas_xdma_agent;
//===================================================================================
//members
//===================================================================================
//mailbox between agent and driver
mailbox a2d_xdma_write_req;
mailbox d2a_xdma_write_ack;
mailbox a2d_xdma_read_req;
mailbox d2a_xdma_read_ack;
//mailbox between user and agent 
mailbox u2a_xdma_write_req;
mailbox a2u_xdma_write_ack;
mailbox u2a_xdma_read_req;
mailbox a2u_xdma_read_ack;
//mailbox between interrupt and agent
mailbox i2a_xdma_write_req;
mailbox a2i_xdma_write_ack;
mailbox i2a_xdma_read_req;
mailbox a2i_xdma_read_ack;
//===================================================================================
//constructor
//===================================================================================
function new();

endfunction  
//===================================================================================
//build
//===================================================================================
function build();

endfunction 
//===================================================================================
//run phase
//===================================================================================
task run();
    fork
        xdma_write_req_process();
        xdma_write_ack_process();
        xdma_read_req_process();
        xdma_read_ack_process();
    join_any
endtask 
//===================================================================================
//xdma_write_req_process
//===================================================================================
task xdma_write_req_process();
    xdma_write_pkg  xdma_wcache;
    while(`TRUE)
    begin
        if(u2a_xdma_write_req.num())                //detect the request from the user
        begin
            u2a_xdma_write_req.get(xdma_wcache);
            a2d_xdma_write_req.put(xdma_wcache);
        end
        if(i2a_xdma_write_req.num())                //detect the request from the interrupt
        begin
            i2a_xdma_write_req.get(xdma_wcache);
            a2d_xdma_write_req.put(xdma_wcache);
        end
        #1; 
    end
endtask 
//===================================================================================
//xdma_write_ack_process
//=================================================================================== 
task xdma_write_ack_process();
    xdma_write_pkg  xdma_wcache;
    while(`TRUE)
    begin
        d2a_xdma_write_ack.get(xdma_wcache);
        if(xdma_wcache.write_flag==0)   //return the result to the user
           a2u_xdma_write_ack.put(xdma_wcache);
        if(xdma_wcache.write_flag==1)   //return the result to the interrupt
           a2i_xdma_write_ack.put(xdma_wcache); 
    end
endtask
//===================================================================================
//xdma_read_req_process
//===================================================================================
task  xdma_read_req_process();
    xdma_read_araddr_pkg xdma_raddr_cache;
    while(`TRUE)
    begin
        if(u2a_xdma_read_req.num())                  //detect the request from the user
        begin
            u2a_xdma_read_req.get(xdma_raddr_cache);
            a2d_xdma_read_req.put(xdma_raddr_cache);
        end
        if(i2a_xdma_read_req.num())                  //detect the request from the interrupt
        begin
            i2a_xdma_read_req.get(xdma_raddr_cache);
            a2d_xdma_read_req.put(xdma_raddr_cache);
        end
        #1;
    end    
endtask
//===================================================================================
//xdma_read_ack_process
//===================================================================================
task xdma_read_ack_process();
    xdma_rdata_pkg xdma_rdata_cache;
    while(`TRUE)
    begin
        d2a_xdma_read_ack.get(xdma_rdata_cache);
        if(xdma_rdata_cache.read_flag==0)           //return the rdata to the user
            a2u_xdma_read_ack.put(xdma_rdata_cache);
        if(xdma_rdata_cache.read_flag==1)           //return the rdata to the interrupt
            a2i_xdma_read_ack.put(xdma_rdata_cache);
    end
endtask
endclass
