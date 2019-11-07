//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas simulation platfrom base package,include base config and some data struct
// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define TRUE 1
`define FALSE 0
//===================================================================================
//axi_lite bus config
//===================================================================================
`ifndef ALITE_BASE_PKG
    `define  ALITE_BASE_PKG
    `define  ALITE_AWADDR_WIDTH 32
    `define  ALITE_AWPORT_WIDTH 3
    `define  ALITE_WDATA_WIDTH 32
    `define  ALITE_WSTRB_WIDTH 4
    `define  ALITE_BRESP_WIDTH 2
    `define  ALITE_ARADDR_WIDTH 32
    `define  ALITE_ARPORT_WIDTH 3
    `define  ALITE_RDATA_WIDTH 32
    `define  ALITE_RRESP_WIDTH 2
    `define  AXI_LITE_CHECK_ENABLE `TRUE
    `define  ALITE_AWADDR_TIMEOUT 10000   //unit:cycle; 
    `define  ALITE_WDATA_TIMEOUT 10000    //unit:cycle;
    `define  ALITE_BRESP_TIMEOUT 10000    //unit:cycle;
    `define  ALITE_ARADDR_TIMEOUT 10000   //unit:cycle;
    `define  ALITE_RDATA_TIMEOUT 10000    //unit:cycle;
    `define  ALITE_RESET_CYCLE 1          //unit::cycle
    //===================================================================================
    //axi_lite data class
    //===================================================================================
    class alite_write_package;
        logic [`ALITE_AWADDR_WIDTH-1:0]    write_addr;
        logic [`ALITE_WDATA_WIDTH-1:0]     write_data;
        logic [`ALITE_BRESP_WIDTH-1:0]     write_state;
        logic                              write_flag;  //0:user channel,1:interrupt channel                         
        function new(input [`ALITE_AWADDR_WIDTH-1:0] waddr,
                     input [`ALITE_WDATA_WIDTH-1:0]  wdata,
                     input                           flag
                    );
            this.write_addr=waddr;
            this.write_data=wdata;
            this.write_flag=flag;
        endfunction 
    endclass 
   
    class alite_read_package;
        logic [`ALITE_ARADDR_WIDTH-1:0]    read_addr;
        logic [`ALITE_RDATA_WIDTH-1:0]     read_data;
        logic [`ALITE_RRESP_WIDTH-1:0]     read_state;
        logic                              read_flag;  //0:user channel,1:interrupt channel
        function new(input [`ALITE_ARADDR_WIDTH-1:0] raddr,
                     input                           flag
                    );
            this.read_addr=raddr;
            this.read_flag=flag;
        endfunction 
    endclass 
`endif 
//===================================================================================
//xdma base package
//===================================================================================
`ifndef XDMA_BASE_PKG
    `define XDMA_BASE_PKG
    
    `define XDMA_ARADDR_WIDTH    64 
    `define XDMA_ARBURST_WIDTH   2
    `define XDMA_ARCACHE_WIDTH   4
    `define XDMA_ARLOCK_WIDTH    1
    `define XDMA_ARPORT_WIDTH    3
    `define XDMA_ARQOS_WIDTH     4
    `define XDMA_ARREGION_WIDTH  4
    `define XDMA_ARID_WIDTH      4
    `define XDMA_ARLEN_WIDTH     8
    `define XDMA_ARSIZE_WIDTH    3
    `define XDMA_AWADDR_WIDTH    64
    `define XDMA_AWBURST_WIDTH   2
    `define XDMA_AWCACHE_WIDTH   4
    `define XDMA_AWLOCK_WIDTH    1
    `define XDMA_AWPORT_WIDTH    3
    `define XDMA_AWQOS_WIDTH     4
    `define XDMA_AWREGION_WIDTH  4
    `define XDMA_AWID_WIDTH      4
    `define XDMA_AWLEN_WIDTH     8
    `define XDMA_AWSIZE_WIDTH    3
    `define XDMA_BID_WIDTH       4
    `define XDMA_BRESP_WIDTH     2
    `define XDMA_RDATA_WIDTH     512
    `define XDMA_RID_WIDTH       4
    `define XDMA_RRESP_WIDTH     2
    `define XDMA_WDATA_WIDTH     512
    `define XDMA_WSTRB_WIDTH     64
    
    `define XDMA_AWSIZE          'b110
    `define XDMA_AWBURST         'b01
    `define XDMA_AWLEN_MAX       4096/(2**`XDMA_AWSIZE)-1
    `define XDMA_ARSIZE          'b110
    `define XDMA_ARBURST         'b01
    `define XDMA_ARLEN_MAX       4096/(2**`XDMA_ARSIZE)-1
    
    
    `define XDMA_CHECK_ENABLE    `TRUE
    `define XDMA_AWADDR_TIMEOUT  10000    //unit:cycle
    `define XDMA_WDATA_TIMEOUT   10000    //unit:cycle
    `define XDMA_BRESP_TIMEOUT   10000    //unit:cycle 
    `define XDMA_ARADDR_TIMEOUT  10000    //unit:cycle 
    `define XDMA_RESET_CYCLE     1        //unit:cycle
    class xdma_write_pkg;
        logic [`XDMA_AWADDR_WIDTH-1:0]       awaddr;
        byte unsigned                        wdata[$];
        logic [`XDMA_BRESP_WIDTH-1:0]        write_state;
        logic [`XDMA_AWLEN_WIDTH-1:0]        awlen;
        logic [(2**`XDMA_AWSIZE*8)-1:0]      wdata_align[$];
        logic [`XDMA_AWLEN_WIDTH-1:0]        last_pkg_size;
        logic                                write_flag;    //0:user channel,1:interrupt channel
        
        
        //constructor
        function new(input logic [`XDMA_AWADDR_WIDTH-1:0] awaddr,
                     input byte unsigned wdata[$],
                     input      flag
                     );
            this.awaddr=awaddr;
            this.wdata=wdata;
            this.write_flag=flag;
        endfunction 
        //align the data
        function data_pack();
            if(wdata.size()%(2**`XDMA_AWSIZE))
            begin
                this.awlen=wdata.size()/(2**`XDMA_AWSIZE)+1;
                this.last_pkg_size=wdata.size()%(2**`XDMA_AWSIZE);
                for(int i=0;i<(2**`XDMA_AWSIZE-this.last_pkg_size);i=i+1)
                begin
                   this.wdata.push_back(0);
                end
            end
            else
            begin
                this.awlen=wdata.size()/(2**`XDMA_AWSIZE); 
                this.last_pkg_size=2**`XDMA_AWSIZE;  
            end        
            for(int i=0;i<awlen;i++)
            begin
                for(int j=1;j<=2**`XDMA_AWSIZE;j++)
                    wdata_align[i][j*8-1-:8]=wdata[i*2**`XDMA_AWSIZE+j-1];
            end
        endfunction 
        
    endclass
    
    class xdma_read_araddr_pkg;
        logic [`XDMA_ARADDR_WIDTH-1:0]     araddr;
        logic [`XDMA_ARID_WIDTH-1:0]       arid;
        int                                length;
        logic                              read_flag; //0:user channel,1:interrupt channel
        //constructor
        function new(input logic [`XDMA_ARADDR_WIDTH-1:0] araddr,
                     input logic [`XDMA_ARID_WIDTH-1:0]   arid,
                     input int                            length,
                     input logic                          flag
                    );
            this.araddr=araddr;
            this.arid=arid;
            this.length=length;
            this.read_flag=flag;         
         endfunction 
         
         //axi4 len calculate
         function logic [`XDMA_ARLEN_WIDTH-1:0] arlen_cal();
            if(~this.length%(2**`XDMA_ARSIZE))
                return this.length/(2**`XDMA_ARSIZE)-1'b1;
            else
                return this.length/(2**`XDMA_ARSIZE);
         endfunction  
    endclass  
    
    class xdma_rdata_pkg;
        logic [`XDMA_ARADDR_WIDTH-1:0]     araddr;
        logic [`XDMA_ARID_WIDTH-1:0]       arid;
        byte unsigned                      rdata[];
        logic [12:0]                       index;
        logic [`XDMA_RRESP_WIDTH-1:0]      state;
        logic                              read_flag; //0:user channel,1:interrupt channel
        //constructor
        function new(input logic [`XDMA_ARADDR_WIDTH-1:0] araddr,
                     input logic [`XDMA_ARID_WIDTH-1:0]   arid,
                     input int                            length,
                     input logic                          flag
                     );
            this.araddr=araddr;
            this.arid=arid;
            this.index=0;
            this.rdata=new[length];
            this.read_flag=flag;
        endfunction
        // data recived process
        function rdata_process(input [`XDMA_RDATA_WIDTH-1:0] rdata_temp);
            for(byte unsigned i=0;i<(2**`XDMA_ARSIZE);i++)
            begin
                this.rdata[index]=rdata_temp>>(8*i);
                this.index++;
            end
        endfunction 
    endclass  
`endif
//===================================================================================
//dma base package
//===================================================================================
`ifndef DMA_BASE_PKG
    `define DMA_BASE_PKG
    
    `define DMA_ARADDR_WIDTH     64
    `define DMA_ARBURST_WIDTH    2
    `define DMA_ARID_WIDTH       5
    `define DMA_ARLEN_WIDTH      8
    `define DMA_ARSIZE_WIDTH     3
    `define DMA_AWADDR_WIDTH     64
    `define DMA_AWBURST_WIDTH    2
    `define DMA_AWID_WIDTH       5
    `define DMA_AWLEN_WIDTH      8
    `define DMA_AWSIZE_WIDTH     3
    `define DMA_BID_WIDTH        5
    `define DMA_BRESP_WIDTH      2
    `define DMA_RDATA_WIDTH      512
    `define DMA_RID_WIDTH        5
    `define DMA_RRESP_WIDTH      2
    `define DMA_WDATA_WIDTH      512
    `define DMA_WSTRB_WIDTH      64
    
    `define DMA_RESET_CYCLE      1
    //dma data package,used to transfer data between agent and application layer
    class dma_data_pkg;
        byte unsigned wdata[];
        logic [`DMA_AWADDR_WIDTH-1:0]   base_addr;
        int                             length;
        logic                           state;      //0:failed,1:succeed        
        function new();
            
        endfunction
        //addr check
        function addr_check();
            if((wdata.size()+base_addr)>=(2**(`DMA_AWADDR_WIDTH)))
            begin
                $display("CRITICAL ERROR: the dma operation address is invalid");
                $stop;
            end
        endfunction  
    endclass 
    //dma write data pkg
    class dma_write_pkg;
        logic [`DMA_AWADDR_WIDTH-1:0]       awaddr;
        byte unsigned                       wdata[];
        logic [12:0]                        payload_size;
        logic [12:0]                        index;
        byte unsigned                       byte_nums_per_cycle;
        logic [`DMA_BRESP_WIDTH-1:0]        write_state;
        
        function new(input logic [`DMA_AWADDR_WIDTH-1:0]       awaddr,
                     input logic [`DMA_AWSIZE_WIDTH-1:0]       awsize,
                     input logic [`DMA_AWLEN_WIDTH-1:0 ]       awlen
        );
            
            this.awaddr=awaddr;
            this.wdata=new[2**(awsize)*(awlen+1)];
            this.payload_size=2**(awsize)*(awlen+1);
            this.index=0;
            this.byte_nums_per_cycle=2**(awsize);
        endfunction 
        //data process from the dma wdata channel
        function logic data_process(input logic [`DMA_WDATA_WIDTH-1:0] data,
                                    input logic [`DMA_WSTRB_WIDTH-1:0] wstrb);
            if(this.index+byte_nums_per_cycle>this.payload_size) //check the nums of the data transfer
            begin
                $display("payload_size=%d\tindex=%d\tbyte_nums_per_cycle=%d",payload_size,index,byte_nums_per_cycle); 
                return `FALSE;
            end
            else
            begin
                for(byte unsigned i=0;i<byte_nums_per_cycle;i++)
                begin
                    this.wdata[index]=(wstrb[i])?data[i*8+:8]:'d0;
                    this.index++;
                end
                return `TRUE;
            end
        endfunction 
    endclass 
    
    //dma read data pkg
    class dma_read_pkg;
        logic [`DMA_ARADDR_WIDTH-1:0]   addr;
        logic [`DMA_ARID_WIDTH-1:0  ]   id;
        logic [12:0]                    payload_size;               //the number to read
        byte unsigned                   byte_nums_per_cycle;        //read bytes number per cycle       
        logic [`DMA_ARLEN_WIDTH-1:0 ]   length;
        byte unsigned                   rdata[];
        logic [`DMA_BRESP_WIDTH-1:0]    read_state;
        logic [12:0]                    index;                      //rdata index point
        //constructor
        function new (input [`DMA_ARADDR_WIDTH-1:0] araddr,
                      input [`DMA_ARID_WIDTH-1:0  ] arid,
                      input [`DMA_ARSIZE_WIDTH-1:0] arsize,
                      input [`DMA_ARLEN_WIDTH-1:0 ] arlen
                     );
            this.addr                   =araddr;
            this.id                     =arid;
            this.length                 =arlen+1;
            this.payload_size           =2**(arsize)*(arlen+1);
            this.byte_nums_per_cycle    =2**(arsize);
            this.index                  =0;
        endfunction 
        //rdata data malloc
        function data_malloc();
            this.rdata =new[this.payload_size];
        endfunction 
        
        //rdata generate
        function logic[`DMA_RDATA_WIDTH-1:0] rdata_generate();
            rdata_generate='d0;
            for(int i=0;i<byte_nums_per_cycle;i++)
            begin
                rdata_generate=(rdata_generate>>8)|{rdata[index],{(`DMA_RDATA_WIDTH-8){1'b0}}};
                index++;
            end
            $display("rdata_generate=%h",rdata_generate); 
            return rdata_generate;
        endfunction 
    endclass     
`endif
//===================================================================================
//ddr base package
//===================================================================================
`ifndef DDR_BASE_PKG
    `define DDR_BASE_PKG
    
    `define DDR_ARADDR_WIDTH    34
    `define DDR_ARBURST_WIDTH   2
    `define DDR_ARCACHE_WIDTH   4
    `define DDR_ARID_WIDTH      16
    `define DDR_ARLEN_WIDTH     8
    `define DDR_ARLOCK_WIDTH    1
    `define DDR_ARPORT_WIDTH    3
    `define DDR_ARQOS_WIDTH     4
    `define DDR_ARREGION_WIDTH  4
    `define DDR_ARSIZE_WIDTH    3
    `define DDR_AWADDR_WIDTH    34
    `define DDR_AWBURST_WIDTH   2
    `define DDR_AWCACHE_WIDTH   4
    `define DDR_AWID_WIDTH      16
    `define DDR_AWLEN_WIDTH     8
    `define DDR_AWLOCK_WIDTH    1
    `define DDR_AWPORT_WIDTH    3
    `define DDR_AWQOS_WIDTH     4
    `define DDR_AWREGION_WIDTH  4
    `define DDR_AWSIZE_WIDTH    3
    `define DDR_BID_WIDTH       16
    `define DDR_BRESP_WIDTH     2
    `define DDR_RDATA_WIDTH     512
    `define DDR_RID_WIDTH       16
    `define DDR_RRESP_WIDTH     2
    `define DDR_WDATA_WIDTH     512
    `define DDR_WSTRB_WIDTH     64
    
    `define DDR_BEHAV_MODE      `TRUE   //use the ddr behav model while true
    
    `define DDR_NUM             4
`endif
//===================================================================================
//Interrupt base package
//===================================================================================
`ifndef INT_BASE_PKG
    `define INT_BASE_PKG
    
    `define INTERRUPT_WIDTH     16
    
    //interrupt base class
    class interrupt_handle_pkg;
        logic                                   int_en;
        logic [$clog2(`INTERRUPT_WIDTH)-1:0]    int_num;
        logic                                   int_ack;
        //constructor
        function new(input logic int_en=1,
                     input logic [$clog2(`INTERRUPT_WIDTH)-1:0]    int_num
                    );
            this.int_en=int_en;
            this.int_num=int_num;
            this.int_ack='d0;
        endfunction 
       //clear int req states
       function int_flag_clear();
            this.int_ack='d1;
       endfunction 
    endclass
`endif
