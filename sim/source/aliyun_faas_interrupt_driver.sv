//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom interrupt driver
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
class aliyun_faas_interrupt_driver;
//===================================================================================
//members
//===================================================================================
mailbox int_gen_req;
mailbox int_cmd_ack;
virtual faas_interrupt#(.INTERRUPT_WIDTH(`INTERRUPT_WIDTH)).tb int_driver;
logic [`INTERRUPT_WIDTH-1:0]    int_req_cache;
//===================================================================================
//int req interface cache
//===================================================================================
task int_req_monitor();
    while(`TRUE)
    begin
        @(negedge int_driver.interrupt_clk)
            int_req_cache=int_driver.usr_int_req;
    end 
endtask
//===================================================================================
//interrupt request generate
//===================================================================================
task int_gen_monitor();
    interrupt_handle_pkg int_pkg;
    while(`TRUE)
    begin
        for(int i=0;i<`INTERRUPT_WIDTH;i++)
        begin
            if(int_driver.usr_int_req[i]&&(~int_req_cache[i]))  //detect the rising edge
            begin
              int_pkg=new(int_driver.usr_int_en,i);            //generate the interrupt request to agent
              int_gen_req.put(int_pkg);              
            end
        end
        @(posedge int_driver.interrupt_clk);
    end
endtask 
//===================================================================================
//interrupt ack 
//===================================================================================
task int_ack_monitor();
    interrupt_handle_pkg int_ack_pkg;
    while(`TRUE)
    begin
        int_cmd_ack.get(int_ack_pkg);
        @(posedge int_driver.interrupt_clk)
        begin
            int_driver.usr_int_en<=int_ack_pkg.int_en;
            int_driver.usr_int_ack[int_ack_pkg.int_num]<=int_ack_pkg.int_ack;
        end
        @(posedge int_driver.interrupt_clk)
            int_driver.usr_int_ack[int_ack_pkg.int_num]<=1'b0;
    end
endtask
 
//===================================================================================
//constructor
//===================================================================================
function new( virtual faas_interrupt#(.INTERRUPT_WIDTH(`INTERRUPT_WIDTH)).tb int_driver);
    this.int_driver=int_driver;
endfunction 
//===================================================================================
//build
//===================================================================================
function build();
    int_driver.usr_int_en='b0;
    int_driver.usr_int_ack='d0;
endfunction 
//===================================================================================
//run phase
//===================================================================================
task run();
    fork
        int_req_monitor();
        int_gen_monitor();
        int_ack_monitor();
    join_none
endtask
endclass 
