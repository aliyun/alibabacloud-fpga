//////////////////////////////////////////////////////////////////////////////////
// Company:     aliyun
// Engineer:    Yuqi
// 
// Description: faas card model,include ddr,cmac,serdes and so on

// 
// Dependencies: 
// 
// Revision:    V1.0
// Revision 0.01 -File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "config.v"
module aliyun_faas_card_model(
    ddr_axi4          c0_ddr4,
    ddr_axi4          c1_ddr4,
    ddr_axi4          c2_ddr4,
    ddr_axi4          c3_ddr4
    );
//===================================================================================
//ddr reference module
//===================================================================================
//DDR0
`ifdef DDR0
    aliyun_faas_ddr_ref_model c0_ddr4_model(
    .ddr4_axi4(c0_ddr4)  
    );
`endif
//DDR1
aliyun_faas_ddr_ref_model c1_ddr4_model(
    .ddr4_axi4(c1_ddr4)  
    );
//DDR2
`ifdef DDR2
    aliyun_faas_ddr_ref_model c2_ddr4_model(
    .ddr4_axi4(c2_ddr4)  
    );
`endif
`ifdef DDR3
    aliyun_faas_ddr_ref_model c3_ddr4_model(
    .ddr4_axi4(c3_ddr4)  
    );
`endif
//===================================================================================
//cmac reference module
//===================================================================================

//===================================================================================
//serdes reference module
//===================================================================================
endmodule
