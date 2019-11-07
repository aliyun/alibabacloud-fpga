//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom agent layer ,include the interrupt ,alite,xdma
//              dma agent layer
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`ifndef FAAS_AGENT
    `define FAAS_AGENT
    `include "aliyun_faas_alite_agent.sv"
    `include "aliyun_faas_dma_agent.sv"
    `include "aliyun_faas_xdma_agent.sv"
    `include "aliyun_faas_interrupt_agent.sv"
`endif
class aliyun_faas_agent;
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
//sub agent members
aliyun_faas_alite_agent     alite_agent_layer;
aliyun_faas_xdma_agent      xdma_agent_layer;
aliyun_faas_dma_agent       dma_agent_layer;
aliyun_faas_interrupt_agent int_agnet_alyer;
//===================================================================================
//constructor
//===================================================================================
function new();
    alite_agent_layer=new();
    xdma_agent_layer=new();
    dma_agent_layer=new();
    int_agnet_alyer=new();
endfunction 
//===================================================================================
//build
//===================================================================================
function build();
    alite_agent_layer.a2d_write_cmd_req=a2d_alite_write_cmd_req;
    alite_agent_layer.d2a_write_cmd_ack=d2a_alite_write_cmd_ack;
    alite_agent_layer.a2d_read_cmd_req=a2d_alite_read_cmd_req;
    alite_agent_layer.d2a_read_cmd_ack=d2a_alite_read_cmd_ack;
    alite_agent_layer.u2a_write_cmd_req=u2a_alite_write_cmd_req;
    alite_agent_layer.a2u_write_cmd_ack=a2u_alite_write_cmd_ack;
    alite_agent_layer.u2a_read_cmd_req=u2a_alite_read_cmd_req;
    alite_agent_layer.a2u_read_cmd_ack=a2u_alite_read_cmd_ack;
    alite_agent_layer.i2a_write_cmd_req=i2a_alite_write_cmd_req;
    alite_agent_layer.a2i_write_cmd_ack=a2i_alite_write_cmd_ack;
    alite_agent_layer.i2a_read_cmd_req=i2a_alite_read_cmd_req;
    alite_agent_layer.a2i_read_cmd_ack=a2i_alite_read_cmd_ack;
    
    xdma_agent_layer.a2d_xdma_write_req=a2d_xdma_write_req;
    xdma_agent_layer.d2a_xdma_write_ack=d2a_xdma_write_ack;
    xdma_agent_layer.a2d_xdma_read_req=a2d_xdma_read_req;
    xdma_agent_layer.d2a_xdma_read_ack=d2a_xdma_read_ack;
    xdma_agent_layer.u2a_xdma_write_req=u2a_xdma_write_req;
    xdma_agent_layer.a2u_xdma_write_ack=a2u_xdma_write_ack;
    xdma_agent_layer.u2a_xdma_read_req=u2a_xdma_read_req;
    xdma_agent_layer.a2u_xdma_read_ack=a2u_xdma_read_ack;
    xdma_agent_layer.i2a_xdma_write_req=i2a_xdma_write_req;
    xdma_agent_layer.a2i_xdma_write_ack=a2i_xdma_write_ack;
    xdma_agent_layer.i2a_xdma_read_req=i2a_xdma_read_req;
    xdma_agent_layer.a2i_xdma_read_ack=a2i_xdma_read_ack;
    
    dma_agent_layer.d2a_dma_write_req=d2a_dma_write_req;
    dma_agent_layer.a2d_dma_write_ack=a2d_dma_write_ack;
    dma_agent_layer.d2a_dma_read_req=d2a_dma_read_req;
    dma_agent_layer.a2d_dma_read_ack=a2d_dma_read_ack;
    dma_agent_layer.u2a_dma_write_req=u2a_dma_write_req;
    dma_agent_layer.a2u_dma_write_ack=a2u_dma_write_ack;
    dma_agent_layer.u2a_dma_read_req=u2a_dma_read_req;
    dma_agent_layer.a2u_dma_read_ack=a2u_dma_read_ack;
    dma_agent_layer.i2a_dma_write_req=i2a_dma_write_req;
    dma_agent_layer.a2i_dma_write_ack=a2i_dma_write_ack;
    dma_agent_layer.i2a_dma_read_req=i2a_dma_read_req;
    dma_agent_layer.a2i_dma_read_ack=a2i_dma_read_ack;
    
    int_agnet_alyer.d2a_int_req=d2a_int_req;
    int_agnet_alyer.a2d_int_ack=a2d_int_ack;
    int_agnet_alyer.a2i_int_req=a2i_int_req;
    int_agnet_alyer.i2a_int_ack=i2a_int_ack;
    int_agnet_alyer.u2a_int_req=u2a_int_req;
    
    alite_agent_layer.build();
    xdma_agent_layer.build();
    dma_agent_layer.build();
    int_agnet_alyer.build();
endfunction 
//===================================================================================
//run phase
//===================================================================================
task run();
    fork
        alite_agent_layer.run();
        xdma_agent_layer.run();
        dma_agent_layer.run();
        int_agnet_alyer.run();
    join_none
endtask 
endclass 
