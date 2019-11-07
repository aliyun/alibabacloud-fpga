//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom testbench
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 -File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`ifndef FAAS_SIM_TB
    `define FAAS_SIM_TB
    `include "aliyun_faas_base_pkg.sv"
    `include "aliyun_faas_interfaces.sv"
    `include "aliyun_faas_sim_env.sv"
`endif
program aliuyun_faas_sim_tb(
    axi_lite.tb alite_driver,
    axi4.master_tb xdma_driver,
    axi4.slave_tb dma_driver,
    faas_interrupt.tb int_driver,
    
    ddr_axi4.slave c0_ddr4_if,
    ddr_axi4.slave c1_ddr4_if,
    ddr_axi4.slave c2_ddr4_if,
    ddr_axi4.slave c3_ddr4_if
    );
//===================================================================================
//members
//===================================================================================
aliyun_faas_sim_env faas_sim_env;
//===================================================================================
//platform init
//===================================================================================
initial
begin
    faas_sim_env=new(alite_driver,
                     xdma_driver,
                     dma_driver,
                     int_driver,
                     c0_ddr4_if,
                     c1_ddr4_if,
                     c2_ddr4_if,
                     c3_ddr4_if
                    );
   faas_sim_env.build();
   faas_sim_env.run(); 
end
//===================================================================================
//user application
//===================================================================================
initial
begin
    int state;
    logic [31:0] rdata;
    faas_sim_env.faas_wait_for_ddr_cal_done(); //about 5.2us
    //user code
    //xdma_test();
    //ddr_access_test();
    //dma_test();
    //$stop();
    interrupt_test();
end
//===================================================================================
//interrupt action
//===================================================================================
initial 
begin
	interrupt_ack();
    //user code

end
//===================================================================================
//xdma test simulation
//===================================================================================
task xdma_test();
    byte unsigned wdata[],rdata[];
    int state;
    wdata=new[4096];
    foreach (wdata[i])
        wdata[i]=$random()%256;
    foreach (wdata[i])
        $display("wadata[%d]=%h",i,wdata[i]); 
    //copy data from host to cl
    faas_sim_env.faas_xdma_write(wdata,'h0,0,state);
    $display("xdma write data complete,state code:%d",state);
    //copy data from cl to host
    faas_sim_env.faas_xdma_read('h0,4096,0,0,rdata,state);
    $display("xdma read data complete,state code:%d",state);
    //data check
    foreach(wdata[i])
    begin
        if(wdata[i]!=rdata[i])
        begin
            $display("data error:wdata[%d]=%d\t,rdata[%d]=%d",i,wdata[i],i,rdata[i]);
            $stop;
        end 
    end
    $display ("TEST PASSED!");
endtask
//===================================================================================
//DDR ACCESS TEST DEMO
//===================================================================================
task ddr_access_test();
    `define DDR_BASE        32'h00000
    `define PRBS_START      `DDR_BASE +  32'h1C
    `define PRBS_STOP       `DDR_BASE +  32'h20
    `define PRBS_CLPT       `DDR_BASE +  32'h28
    `define PRBS_ERR        `DDR_BASE +  32'h30
    
    `define C0_TXCMD_CNT    `DDR_BASE +  32'h40
    `define C0_RXCMD_CNT    `DDR_BASE +  32'h44
    `define C1_TXCMD_CNT    `DDR_BASE +  32'h48
    `define C1_RXCMD_CNT    `DDR_BASE +  32'h4c
    `define C2_TXCMD_CNT    `DDR_BASE +  32'h50
    `define C2_RXCMD_CNT    `DDR_BASE +  32'h54
    `define C3_TXCMD_CNT    `DDR_BASE +  32'h58
    `define C3_RXCMD_CNT    `DDR_BASE +  32'h5c
    
    int state;
    logic [`ALITE_RDATA_WIDTH-1:0] rdata;
    
    //start prbs test
    faas_sim_env.faas_alite_write(`PRBS_START,32'hf,0,state);
    $display("PRBS_START WRITE COMPLETE,STATE CODE:%d",state);
    #2us;
    //stop prbs test
    faas_sim_env.faas_alite_write(`PRBS_STOP,32'hf,0,state);
    $display("PRBS_STOP WRITE COMPLETE,STATE CODE:%d",state); 
    //tx and rx count
    faas_sim_env.faas_alite_read(`C0_TXCMD_CNT,0,state,rdata);
    $display("DDR0 tx counts:%d",rdata);
    faas_sim_env.faas_alite_read(`C0_RXCMD_CNT,0,state,rdata);
    $display("DDR0 rx counts:%d",rdata);
    faas_sim_env.faas_alite_read(`C1_TXCMD_CNT,0,state,rdata);
    $display("DDR1 tx counts:%d",rdata);
    faas_sim_env.faas_alite_read(`C1_RXCMD_CNT,0,state,rdata);
    $display("DDR1 rx counts:%d",rdata);   
    faas_sim_env.faas_alite_read(`C2_TXCMD_CNT,0,state,rdata);
    $display("DDR2 tx counts:%d",rdata);
    faas_sim_env.faas_alite_read(`C2_RXCMD_CNT,0,state,rdata);
    $display("DDR2 rx counts:%d",rdata);  
    faas_sim_env.faas_alite_read(`C3_TXCMD_CNT,0,state,rdata);
    $display("DDR3 tx counts:%d",rdata);
    faas_sim_env.faas_alite_read(`C3_RXCMD_CNT,0,state,rdata);
    $display("DDR3 rx counts:%d",rdata);     
endtask
//===================================================================================
//DMA TEST DEMO
//===================================================================================
task dma_test();
    `define BASE 32'h10000
    `define H2F             `BASE + 8'h14
    `define F2H             `BASE + 8'h1C
    `define H2F_RST         `BASE + 8'h18
    `define F2H_RST         `BASE + 8'h20
    `define ADDR_LOW        `BASE + 8'h24
    `define ADDR_HIGH       `BASE + 8'h28
    `define LEN             `BASE + 8'h2C
    `define COUNT           `BASE + 8'h30
    `define SIZE            `BASE + 8'h34
    `define REPEAT_NUM      `BASE + 8'h38
    `define TRANS_MODE      `BASE + 8'h50
    `define PKG_NUM         `BASE + 8'h54
    `define CLR_ERR         `BASE + 8'h58
    `define MODE            `BASE + 8'h5c
    `define MAXSIZE_LOW     `BASE + 8'h60
    `define MAXSIZE_HIGH    `BASE + 8'h64
    `define TX_COUNT        `BASE + 8'h80
    `define RX_COUNT        `BASE + 8'h88
    `define ERR_COUNT       `BASE + 8'h84
    `define SEND_CYC_HIGH   `BASE + 8'h8c
    `define SEND_CYC_LOW    `BASE + 8'h90 
    `define REC_CYC_HIGH    `BASE + 8'h8c
    `define REC_CYC_LOW     `BASE + 8'h90
    
    //TRANSFER MODE [7:4] IS LEN, TRANS_MODE [3:0] IS SIZE. LEN=4BITS SIZE=3BITS. 
    `define MODE_64       32'h06 // len 1 (b0000) * size 64B (b110)
    `define MODE_128       32'h16 // len 2 (b0001) * size 64B (b110)
    `define MODE_192       32'h26 
    `define MODE_256       32'h36 // len 4 (b0011) * size 64B (b110)
    `define MODE_320       32'h46 
    `define MODE_384       32'h56 
    `define MODE_448       32'h66 
    `define MODE_512       32'h76 // len 8 (b0111) * size 64B (b110)
    `define MODE_576       32'h86 
    `define MODE_640       32'h96 
    `define MODE_704       32'ha6 
    `define MODE_768       32'hb6 
    `define MODE_832       32'hc6 
    `define MODE_896       32'hd6 
    `define MODE_960       32'he6 
    `define MODE_1024   32'hf6 // len 16 (b1111) * size 64B (b110)
    
    logic[31:0] tx_pkg,rx_pkg,err_count;
    logic[63:0] sned_cyc_count,rec_cyc_count;
    int state;
    
    // configure pci_register to start backdoor host memory access via PCIeM
    faas_sim_env.faas_alite_write(`H2F_RST,32'h1,0,state);
    faas_sim_env.faas_alite_write(`F2H_RST,32'h1,0,state);
    faas_sim_env.faas_alite_write(`ADDR_LOW,32'h0,0,state);
    faas_sim_env.faas_alite_write(`ADDR_HIGH,32'h0,0,state);
    faas_sim_env.faas_alite_write(`MODE,32'h0,0,state);
    $display("START NORMAL TEST");
    faas_sim_env.faas_alite_write(`TRANS_MODE,`MODE_1024,0,state); 
    faas_sim_env.faas_alite_write(`PKG_NUM,32'h10,0,state); 
    //start writing data to host memory
    faas_sim_env.faas_alite_write(`F2H,32'h1,0,state);
    #2us;
    //start reading data from host memory
    faas_sim_env.faas_alite_write(`H2F,32'h1,0,state);
    #2us;
    faas_sim_env.faas_alite_read(`TX_COUNT,0,state,tx_pkg);
    faas_sim_env.faas_alite_read(`RX_COUNT,0,state,rx_pkg);
    faas_sim_env.faas_alite_read(`SEND_CYC_HIGH,0,state,sned_cyc_count[63:32]);
    faas_sim_env.faas_alite_read(`SEND_CYC_LOW,0,state,sned_cyc_count[31:0]);
    faas_sim_env.faas_alite_read(`REC_CYC_HIGH,0,state,rec_cyc_count[63:32]);
    faas_sim_env.faas_alite_read(`REC_CYC_LOW,0,state,rec_cyc_count[31:0]);
    $display("size:%d\ntx pkg number:%d\nrx_pkg_num=%d\ntx speed:%f GB/s\nrx speed:%f GB/s",64*(1+(`MODE_1024>>4)),tx_pkg,rx_pkg,64*(1+(`MODE_1024>>4))*tx_pkg/sned_cyc_count/3.3,64*(1+(`MODE_1024>>4))*tx_pkg/rec_cyc_count/3.3);        
endtask
//===================================================================================
//INTERRUPT TEST DEMO
//===================================================================================
task interrupt_test();
    int state;
    faas_sim_env.faas_int_enable();
    faas_sim_env.faas_alite_write(32'h60,32'h2,0,state);
    $display("trig interrupt 1"); 
endtask

task interrupt_ack();
    int state;
    logic [31:0] FAAS_VERSION;
    //event int_ack;			 
    @(faas_sim_env.interrupt_trig[1]);
    faas_sim_env.faas_alite_read(32'h0,1,state,FAAS_VERSION);
    $display ("FAAS VERSION is %h",FAAS_VERSION);
    faas_sim_env.faas_int_flag_clear(1);
    #500ns;
    faas_sim_env.faas_int_close();
    #10ns;
endtask

endprogram
