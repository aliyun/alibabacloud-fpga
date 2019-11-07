//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas ddr reference model,include ddr control ip and ddr behave model

// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 -File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module aliyun_faas_ddr_ref_model(
    ddr_axi4     ddr4_axi4  
    );
//===================================================================================
//signales
//===================================================================================
wire            ddr4_act_n;
wire [16:0]     ddr4_adr;
wire [1:0]      ddr4_ba;
wire [1:0]      ddr4_bg;
wire [1:0]      ddr4_cke;
wire [1:0]      ddr4_odt;
wire [1:0]      ddr4_cs_n;
wire [1:0]      ddr4_ck_t;
wire [1:0]      ddr4_ck_c;
wire            ddr4_reset_n;
wire [7:0]      ddr4_dm_dbi_n;
wire [63:0]     ddr4_dq;
wire [7:0]      ddr4_dqs_c;
wire [7:0]      ddr4_dqs_t;
wire            c0_ddr4_ui_clk_sync_rst;
//===================================================================================
//ddr4 ctrl instance
//===================================================================================
assign ddr4_axi4.axi4_rstn=~c0_ddr4_ui_clk_sync_rst;
ddr4_ctrl u_ddr4_ctrl(
   .sys_rst                            (1'b0),

   .c0_sys_clk_p                       (ddr4_axi4.ref_clk),
   .c0_sys_clk_n                       (~ddr4_axi4.ref_clk),
   .c0_init_calib_complete             (ddr4_axi4.ddr_cal_done),
  
   .c0_ddr4_act_n                      (ddr4_act_n),
   .c0_ddr4_adr                        (ddr4_adr),
   .c0_ddr4_ba                         (ddr4_ba),
   .c0_ddr4_bg                         (ddr4_bg),
   .c0_ddr4_cke                        (ddr4_cke),
   .c0_ddr4_odt                        (ddr4_odt),
   .c0_ddr4_cs_n                       (ddr4_cs_n),
   .c0_ddr4_ck_t                       (ddr4_ck_t),
   .c0_ddr4_ck_c                       (ddr4_ck_c),
   .c0_ddr4_reset_n                    (ddr4_reset_n),

   .c0_ddr4_dm_dbi_n                   (ddr4_dm_dbi_n),
   .c0_ddr4_dq                         (ddr4_dq),
   .c0_ddr4_dqs_c                      (ddr4_dqs_c),
   .c0_ddr4_dqs_t                      (ddr4_dqs_t),

   .c0_ddr4_ui_clk                     (ddr4_axi4.axi4_clk),
   .c0_ddr4_ui_clk_sync_rst            (c0_ddr4_ui_clk_sync_rst),
   .dbg_clk                            ( ),
  // Slave Interface Write Address Ports
  .c0_ddr4_aresetn                     (ddr4_axi4.axi4_rstn),
  .c0_ddr4_s_axi_awid                  (ddr4_axi4.axi4_awid),
  .c0_ddr4_s_axi_awaddr                (ddr4_axi4.axi4_awaddr),
  .c0_ddr4_s_axi_awlen                 (ddr4_axi4.axi4_awlen),
  .c0_ddr4_s_axi_awsize                (ddr4_axi4.axi4_awsize),
  .c0_ddr4_s_axi_awburst               (ddr4_axi4.axi4_awburst),
  .c0_ddr4_s_axi_awlock                (1'b0),
  .c0_ddr4_s_axi_awcache               (ddr4_axi4.axi4_awcache),
  .c0_ddr4_s_axi_awprot                (ddr4_axi4.axi4_awport),
  .c0_ddr4_s_axi_awqos                 (4'b0),
  .c0_ddr4_s_axi_awvalid               (ddr4_axi4.axi4_awvalid),
  .c0_ddr4_s_axi_awready               (ddr4_axi4.axi4_awready),
  // Slave Interface Write Data Ports
  .c0_ddr4_s_axi_wdata                 (ddr4_axi4.axi4_wdata),
  .c0_ddr4_s_axi_wstrb                 (ddr4_axi4.axi4_wstrb),
  .c0_ddr4_s_axi_wlast                 (ddr4_axi4.axi4_wlast),
  .c0_ddr4_s_axi_wvalid                (ddr4_axi4.axi4_wvalid),
  .c0_ddr4_s_axi_wready                (ddr4_axi4.axi4_wready),
  // Slave Interface Write Response Ports
  .c0_ddr4_s_axi_bid                   (ddr4_axi4.axi4_bid),
  .c0_ddr4_s_axi_bresp                 (ddr4_axi4.axi4_bresp),
  .c0_ddr4_s_axi_bvalid                (ddr4_axi4.axi4_bvalid),
  .c0_ddr4_s_axi_bready                (ddr4_axi4.axi4_bready),
  // Slave Interface Read Address Ports
  .c0_ddr4_s_axi_arid                  (ddr4_axi4.axi4_arid),
  .c0_ddr4_s_axi_araddr                (ddr4_axi4.axi4_araddr),
  .c0_ddr4_s_axi_arlen                 (ddr4_axi4.axi4_arlen),
  .c0_ddr4_s_axi_arsize                (ddr4_axi4.axi4_arsize),
  .c0_ddr4_s_axi_arburst               (ddr4_axi4.axi4_arbusrt),
  .c0_ddr4_s_axi_arlock                (1'b0),
  .c0_ddr4_s_axi_arcache               (ddr4_axi4.axi4_arcache),
  .c0_ddr4_s_axi_arprot                (3'b0),
  .c0_ddr4_s_axi_arqos                 (4'b0),
  .c0_ddr4_s_axi_arvalid               (ddr4_axi4.axi4_arvalid),
  .c0_ddr4_s_axi_arready               (ddr4_axi4.axi4_arready),
  // Slave Interface Read Data Ports
  .c0_ddr4_s_axi_rid                   (ddr4_axi4.axi4_rid),
  .c0_ddr4_s_axi_rdata                 (ddr4_axi4.axi4_rdata),
  .c0_ddr4_s_axi_rresp                 (ddr4_axi4.axi4_rresp),
  .c0_ddr4_s_axi_rlast                 (ddr4_axi4.axi4_rlast),
  .c0_ddr4_s_axi_rvalid                (ddr4_axi4.axi4_rvalid),
  .c0_ddr4_s_axi_rready                (ddr4_axi4.axi4_rready),
  
  // Debug Port
  .dbg_bus                             ( )                                                 
);
//===================================================================================
//ddr4 behav model instance
//===================================================================================
ddr_model ddr_behav_model(
    .c0_sys_clk_p                   (ddr4_axi4.ref_clk),
    .c0_sys_clk_n                   (~ddr4_axi4.ref_clk),
    .c0_ddr4_act_n                  (ddr4_act_n),
    .c0_ddr4_adr                    (ddr4_adr),
    .c0_ddr4_ba                     (ddr4_ba),
    .c0_ddr4_bg                     (ddr4_bg),
    .c0_ddr4_cke                    (ddr4_cke),
    .c0_ddr4_odt                    (ddr4_odt),
    .c0_ddr4_cs_n                   (ddr4_cs_n),
    .c0_ddr4_ck_t_int               (ddr4_ck_t),
    .c0_ddr4_ck_c_int               (ddr4_ck_c),
    .c0_ddr4_reset_n                (ddr4_reset_n),
    .c0_ddr4_dm_dbi_n               (ddr4_dm_dbi_n),
    .c0_ddr4_dq                     (ddr4_dq),
    .c0_ddr4_dqs_t                  (ddr4_dqs_t),
    .c0_ddr4_dqs_c                  (ddr4_dqs_c)
);
endmodule
