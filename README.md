# alibabacloud-fpga
#该平台代码用于仅阿里云FaaS（FPGA as a Service）HDL逻辑仿真
#适用软件版本：Vivado-2018.2、Vivado-2019.1
#使用方式：
1、拷贝sim文件夹至hdl工程下与hw在同一目录下
2、在创建的vivado工程中执行sim/scripts/import_sim_env.tcl
3、在aliyun_faas_sim_tb.sv文件中创建用户个人testcase
#userapi
#在aliyun_faas_sim_env.sv文件中，aliyun_faas_sim_env class提供了调用仿真平台进行仿真的用户API接口，主要包含axi4-lite、xdma、dma、中断接口的使用：
#
#中断接口
#中断接口主要用于使能、关闭中断功能，及中断响应清除
//===================================================================================
//user api:faas_int_enable() 
//enable the interrupt function                                                                        
//===================================================================================
task faas_int_enable();
//===================================================================================
//user api:faas_int_close() 
//close the interrupt function                                                                        
//===================================================================================
task faas_int_close();
//===================================================================================
//user api: faas_int_flag_clear() 
//int_num:  interrupt number                                                         
//在中断处理函数中完成系统中断处理后清除中断号int_num对应的中断标志              
//===================================================================================
task automatic faas_int_flag_clear(input logic [$clog2(`INTERRUPT_WIDTH)-1:0]    int_num);

#AXI4-Lite总线读写
#ALITE API主要提供对alite接口的读写函数，用户无需关系ALITE时序细节，通过相应API即可完成数据的读写，
#所提供的两个读写函数中channel参数用于标识用于正常的testbench读写还是在中断处理中的读写。
//===================================================================================
//user api: faas_alite_write() 
//waddr:    alite write addr
//wdata:    alite write data
//channel:  0:used to write in application
//          1:used to write in interrupt
//state     rerturn the write state,equal to ali_lite bresp signals 
//在中断处理函数中调用faas_alite_write时channel指定为1，否则指定为0                                                                        
//===================================================================================
task automatic  faas_alite_write(input [`ALITE_AWADDR_WIDTH-1:0] waddr,
                      input [`ALITE_WDATA_WIDTH-1:0]  wdata,
                      input                           channel,
                      output[`ALITE_BRESP_WIDTH-1:0]  state
                     );
//===================================================================================
//user api:faas_alite_read() 
//raddr:    alite read addr
//rdata:    alite read data
//channel:  0:used to read in application
//          1:used to read in interrupt
//state     rerturn the read state,equal to ali_lite rresp signals  
//在中断处理函数中调用faas_alite_write时channel指定为1，否则指定为0                                                                           
//===================================================================================
task automatic faas_alite_read(input  [`ALITE_ARADDR_WIDTH-1:0] raddr,
                     input                            channel,
                     output [`ALITE_RRESP_WIDTH-1:0]  state,
                     output [`ALITE_RDATA_WIDTH-1:0]  rdata    
                    );
#XDMA接口读写
#faas_xdma_write() 函数用于用户对XDMA的写通道进行访问请求，其中参数wdata[]采用动态数组实现，数据格式
#为unsigned byte，用户无需关心axi4协议要求，只需注入待写入地址基址waddr及待写入数据wdata即可，FAAS SIM #ENV会自动进行数据的分割分发。同时针对不同类型的待写入数据（int、float等），用户可在此函数基础上进行二次开发。
#faas_xdma_read()函数用于用户对XMDA读通道进行数据访问请求，对于xdma读的乱序传输等要求，为给用户提供更大的
#自由度，此处用户应注意raddr及length的参数设置保证读取数据范围在4K边界范围内（平台中已添加地址检测）。同时
#针对不同类型的待写入数据（int、float等），用户可在此函数基础上进行二次开发。
#两个读写函数中channel参数用于标识用于正常的testbench读写还是在中断处理中的读写。
//===================================================================================
//user api:faas_xdma_write() 
//wdata:    xdma write data
//waddr:    xdma write addr
//channel:  0:used to write in application
//          1:used to write in interrupt
//state     rerturn the write state,equal to axi_xdma bresp signals   
//在中断处理函数中调用faas_alite_write时channel指定为1，否则指定为0                                                                        
//===================================================================================
task automatic faas_xdma_write(input byte unsigned  wdata[],
                     input [`XDMA_AWADDR_WIDTH-1:0] waddr,
                     input                          channel,
                     output[`XDMA_BRESP_WIDTH-1:0]  state           
                    );
//===================================================================================
//user api:faas_xdma_read() 
//raddr:    xdma read addr
//length:   read length,not exceed 4096
//id:       id number used in xdma read channel,euqal to arid
//channel:  0:used to write in application
//          1:used to write in interrupt
//rdata:    return the read data
//state     rerturn the write state,equal to axi_xdma rresp signals                                                                         
//===================================================================================
task automatic faas_xdma_read(input [`XDMA_ARADDR_WIDTH-1:0]    raddr,
                              input int                         length,
                              input [`XDMA_ARID_WIDTH-1:0]      id,                              
                              input                             channel,
                              output byte unsigned              rdata[],
                              output [`XDMA_RRESP_WIDTH-1:0]    state 
                             );
#DMA接口读写
#由于DMA操作仿真平台为slave port，故而DMA的读写操作由DUT发起，faas_dma_wdata_fetch()
#函数用于获取DMA写至host端的数据，而faas_dma_rdata_update()用于将待用于DMA读取的数据写至memory cache。
#由于两个函数读写对象为FAAS SIM ENV中的memory cache，故而对于地址及写入数据长度均无限制，针对不同类型的待
#写入数据（int、float等），用户可在此函数基础上进行二次开发。
#两个读写函数中channel参数用于标识用于正常的testbench读写还是在中断处理中的读写。
//===================================================================================
//user api:faas_dma_wdata_fetch() 
//get the data write form the dma channel 
//waddr:    dma write addr
//length:   fetch data length
//channel:  0:used to write in application
//          1:used to write in interrupt
//wdata:    return the wdata dma write
//state:    return the state;                                                                     
//===================================================================================
task automatic faas_dma_wdata_fetch(input [`DMA_AWADDR_WIDTH-1:0] waddr,
                          input int                     length,
                          input                         channel,
                          output byte unsigned          wdata[],
                          output                        state
                         );
//===================================================================================
//user api:faas_dma_rdata_update() 
//get the data read ro the dma channel 
//raddr:    dma read addr
//rdata[]:  the rdata dma read
//channel:  0:used to read data update in application
//          1:used to read data update in interrupt
//state:    return the state;                                                                     
//===================================================================================
task automatic faas_dma_rdata_update(input [`DMA_AWADDR_WIDTH-1:0]    raddr,
                           input byte unsigned              rdata[],
                           input                            channel,
                           output                           state          
                          );
#其他接口
//===================================================================================
//user api:faas_wait_for_ddr_cal_done() 
//wait for the ddr reference model cal done 
//用户的rtl设计中若使用了ddr接口，则在testcase中应首先调用该api等待ddr校准完成                                                                   
//===================================================================================
task faas_wait_for_ddr_cal_done(); 