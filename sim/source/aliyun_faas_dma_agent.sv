//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom dma agent
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
class aliyun_faas_dma_agent;
//===================================================================================
//members
//===================================================================================
//mailbox between agent and driver
mailbox d2a_dma_write_req;
mailbox a2d_dma_write_ack;
mailbox d2a_dma_read_req;
mailbox a2d_dma_read_ack;
//mailbox between user and agent
mailbox u2a_dma_write_req;
mailbox a2u_dma_write_ack;
mailbox u2a_dma_read_req;
mailbox a2u_dma_read_ack;  
//mailbox between user and interrupt
mailbox i2a_dma_write_req;
mailbox a2i_dma_write_ack;
mailbox i2a_dma_read_req;
mailbox a2i_dma_read_ack;
//local memory cache
byte unsigned dma_memory_cache[bit [63:0]];
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
        dma_memory_write_update();
        d2a_dma_read_req_process();
        u2a_dma_read_req_process();
        i2a_dma_read_req_process();
    join_none
endtask 
//===================================================================================
//dma memory cache write process
//===================================================================================
task dma_memory_write_update();
    dma_data_pkg    app_dma_data_cache;
    dma_write_pkg   dri_dma_wcache;  
    while(`TRUE)
    begin
        if(d2a_dma_write_req.num()) //detect the write operation from the driver
        begin
            d2a_dma_write_req.get(dri_dma_wcache);
            //data copy
            for(int i=0;i<dri_dma_wcache.payload_size;i++)
            begin
                dma_memory_cache[dri_dma_wcache.awaddr+i]=dri_dma_wcache.wdata[i];
            end
            //set the bresp state and return to the dricer write ack channel
            dri_dma_wcache.write_state='d0;
            a2d_dma_write_ack.put(dri_dma_wcache);
        end   
        if(u2a_dma_write_req.num()) //detect the write operation from the user
        begin
            u2a_dma_write_req.get(app_dma_data_cache);
            //data copy
            for(int i=0;i<app_dma_data_cache.wdata.size();i++)
            begin
                dma_memory_cache[app_dma_data_cache.base_addr+i]=app_dma_data_cache.wdata[i];
            end
            //set the state flag and return to the user
            app_dma_data_cache.state='d1;  //succeed
            a2u_dma_write_ack.put(app_dma_data_cache);
        end
        if(i2a_dma_write_req.num()) //detect the write operation from the user
        begin
            i2a_dma_write_req.get(app_dma_data_cache);
            //data copy
            for(int i=0;i<app_dma_data_cache.wdata.size();i++)
            begin
                dma_memory_cache[app_dma_data_cache.base_addr+i]=app_dma_data_cache.wdata[i];
            end
           //set the state flag and return to the user
           app_dma_data_cache.state='d1;
           i2a_dma_write_req.put(app_dma_data_cache);
        end
        #1;
    end
endtask
//===================================================================================
//dma read req from the driver
//===================================================================================
task d2a_dma_read_req_process();
    dma_read_pkg    dma_read_cache;
    while(`TRUE)
    begin
        d2a_dma_read_req.get(dma_read_cache);
        //copy data
        dma_read_cache.data_malloc();
        for(int i=0;i<dma_read_cache.payload_size;i++)
        begin
            dma_read_cache.rdata[i]=dma_memory_cache[dma_read_cache.addr+i];
        end
        //return to the a2d_dma_read_ack channel
        dma_read_cache.read_state='d0;
        a2d_dma_read_ack.put(dma_read_cache); 
    end
endtask
//===================================================================================
//dma read req from the user
//===================================================================================
task u2a_dma_read_req_process();
    dma_data_pkg dma_data_cache;
    while(`TRUE)
    begin
        u2a_dma_read_req.get(dma_data_cache);
        dma_data_cache.wdata=new[dma_data_cache.length];
        //cpoy data
        for(int i=0;i<dma_data_cache.length;i++)
        begin
            dma_data_cache.wdata[i]=dma_memory_cache[dma_data_cache.base_addr+i];
        end
        dma_data_cache.state=1;
        a2u_dma_read_ack.put(dma_data_cache);
    end
endtask
//===================================================================================
//dma read req from the interrupt
//===================================================================================
task i2a_dma_read_req_process();
    dma_data_pkg dma_data_cache;
    while(`TRUE)
    begin
        i2a_dma_read_req.get(dma_data_cache);
        dma_data_cache.wdata=new[dma_data_cache.length];
        //cpoy data
        for(int i=0;i<dma_data_cache.length;i++)
        begin
            dma_data_cache.wdata[i]=dma_memory_cache[dma_data_cache.base_addr+i];
        end
        dma_data_cache.state=1;
        a2i_dma_read_ack.put(dma_data_cache);
    end
endtask    
endclass
