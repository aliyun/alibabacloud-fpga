//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom alite agent layer 
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
class aliyun_faas_alite_agent;
//===================================================================================
//members
//===================================================================================
//mailbox between agent and driver 
mailbox a2d_write_cmd_req;
mailbox d2a_write_cmd_ack;
mailbox a2d_read_cmd_req;
mailbox d2a_read_cmd_ack;
//mailbox between user and agent
mailbox u2a_write_cmd_req;
mailbox a2u_write_cmd_ack;
mailbox u2a_read_cmd_req;
mailbox a2u_read_cmd_ack; 
//mailbox between interrupt and agent
mailbox i2a_write_cmd_req;
mailbox a2i_write_cmd_ack;
mailbox i2a_read_cmd_req;
mailbox a2i_read_cmd_ack;
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
        alite_write_cmd_req_process();
        alite_write_cmd_ack_process();
        alite_read_cmd_req_process();
        alite_read_cmd_ack_process();
    join_none
endtask
//===================================================================================
//write_cmd__req_process
//===================================================================================
task alite_write_cmd_req_process();
    alite_write_package alite_wcache;
    while(`TRUE)
    begin
        if(u2a_write_cmd_req.num()) //detect the request from the user
        begin
            u2a_write_cmd_req.get(alite_wcache);
            a2d_write_cmd_req.put(alite_wcache);
        end
        if(i2a_write_cmd_req.num()) //detect the request from the interrupt
        begin
            i2a_write_cmd_req.get(alite_wcache);
            a2d_write_cmd_req.put(alite_wcache);
        end
        #1;
    end
endtask 
//===================================================================================
//write_cmd_ack_process
//===================================================================================
task alite_write_cmd_ack_process();
    alite_write_package alite_wcache;
    while(`TRUE)
    begin
        d2a_write_cmd_ack.get(alite_wcache);
        if(alite_wcache.write_flag==0)  //if the package is to user
            a2u_write_cmd_ack.put(alite_wcache);
        else                            //if the packeage is to interrupt
            a2i_write_cmd_ack.put(alite_wcache);
    end
endtask 
//===================================================================================
//read_cmd_req_process
//===================================================================================
task alite_read_cmd_req_process();
    alite_read_package alite_rcache;
    while(`TRUE)
    begin
        if(u2a_read_cmd_req.num())          //detect the request from the user
        begin
            u2a_read_cmd_req.get(alite_rcache);
            a2d_read_cmd_req.put(alite_rcache);
        end
        if(i2a_read_cmd_req.num())          //detect the request from the interrupt
        begin
            i2a_read_cmd_req.get(alite_rcache);
            a2d_read_cmd_req.put(alite_rcache);
        end
        #1;
    end
endtask
//===================================================================================
//read_cmd_ack_process
//===================================================================================
task alite_read_cmd_ack_process();
    alite_read_package alite_rcache;
    while(`TRUE)
    begin
        d2a_read_cmd_ack.get(alite_rcache);
        if(alite_rcache.read_flag==0)   //return the result to the user
            a2u_read_cmd_ack.put(alite_rcache);
        if(alite_rcache.read_flag==1)   //return the result to the interrupt
            a2i_read_cmd_ack.put(alite_rcache);
    end
endtask

endclass

