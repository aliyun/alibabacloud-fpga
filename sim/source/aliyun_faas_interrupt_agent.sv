//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom interrupt agent layer
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
class aliyun_faas_interrupt_agent;
//===================================================================================
//members
//===================================================================================
//mailbox between driver and agent
mailbox d2a_int_req;
mailbox a2d_int_ack;
//mailbox between interrupt and agent
mailbox a2i_int_req;
mailbox i2a_int_ack;
//mailbox between user and agent,used to open or close interrupt enable
mailbox u2a_int_req;
//interrupt enable
logic int_en;   
//===================================================================================
//constructor
//===================================================================================
function new();
    this.int_en=1'b0;
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
        int_ack_process();
        int_req_process();
    join_none
endtask
//===================================================================================
//interrupt ack process
//===================================================================================
task int_ack_process();
    interrupt_handle_pkg int_pkg;
    while(`TRUE)
    begin
        if(u2a_int_req.num())
        begin
            u2a_int_req.get(int_pkg);
            this.int_en=int_pkg.int_en;
            a2d_int_ack.put(int_pkg);
        end
        if(i2a_int_ack.num()&&this.int_en)
        begin
            i2a_int_ack.get(int_pkg);
            a2d_int_ack.put(int_pkg);
        end
        #1;
    end
endtask 
//===================================================================================
//interrupt req process
//===================================================================================
task int_req_process();
    interrupt_handle_pkg int_pkg;
    while(`TRUE)
    begin
        d2a_int_req.get(int_pkg);
        a2i_int_req.put(int_pkg);
    end    
endtask
endclass 
