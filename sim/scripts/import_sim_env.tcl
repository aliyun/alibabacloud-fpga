# Get current directory, used throughout script
set scriptDir [file dirname [file normalize [info script]]]
set simplatformDir [file dirname $scriptDir]
set hdk_file [file dirname $simplatformDir]
puts $simplatformDir 
#set simDir [file dirname $scriptDir]

############### import Faas simulation platform #############
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_xdma_driver.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_dma_driver.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_sim_top.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_dma_agent.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_driver.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_agent.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_xdma_agent.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_interrupt_driver.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_interrupt_agent.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_sim_env.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_interfaces.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_alite_driver.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliuyun_faas_sim_tb.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_ddr_ref_model.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_base_pkg.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_alite_agent.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/source/aliyun_faas_card_model.sv

set_property file_type {Verilog Header} [get_files aliyun_faas_xdma_driver.sv]
set_property file_type {Verilog Header} [get_files aliyun_faas_dma_driver.sv]
set_property file_type {Verilog Header} [get_files aliyun_faas_dma_agent.sv]
set_property file_type {Verilog Header} [get_files aliyun_faas_driver.sv]
set_property file_type {Verilog Header} [get_files aliyun_faas_agent.sv]
set_property file_type {Verilog Header} [get_files aliyun_faas_xdma_agent.sv]
set_property file_type {Verilog Header} [get_files aliyun_faas_interrupt_driver.sv]
set_property file_type {Verilog Header} [get_files aliyun_faas_interrupt_agent.sv]
set_property file_type {Verilog Header} [get_files aliyun_faas_sim_env.sv]
set_property file_type {Verilog Header} [get_files aliyun_faas_interfaces.sv]
set_property file_type {Verilog Header} [get_files aliyun_faas_alite_driver.sv]
set_property file_type {Verilog Header} [get_files aliyun_faas_base_pkg.sv]
set_property file_type {Verilog Header} [get_files aliyun_faas_alite_agent.sv]

############### import ddr_ref_model files #############
import_files -fileset sim_1 -norecurse ${simplatformDir}/ddr_ref_model/timing_tasks.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/ddr_ref_model/StateTableCore.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/ddr_ref_model/StateTable.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/ddr_ref_model/proj_package.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/ddr_ref_model/MemoryArray.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/ddr_ref_model/interface.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/ddr_ref_model/ddr_model.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/ddr_ref_model/ddr4_sdram_model_wrapper.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/ddr_ref_model/ddr4_model.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/ddr_ref_model/arch_package.sv
import_files -fileset sim_1 -norecurse ${simplatformDir}/ddr_ref_model/arch_defines.v

set_property file_type {Verilog Header} [get_files StateTableCore.sv]
set_property file_type {Verilog Header} [get_files timing_tasks.sv]
set_property file_type {Verilog Header} [get_files arch_defines.v]
set_property file_type {Verilog Header} [get_files StateTable.sv]
set_property file_type {Verilog Header} [get_files MemoryArray.sv]
set_property file_type {Verilog Header} [get_files ddr4_sdram_model_wrapper.sv]
set_property file_type {Verilog Header} [get_files arch_package.sv]



############### import ddr ctrl ip #############
import_ip ${simplatformDir}/ip/ddr4_ctrl.xcix

############### import ddr config file #############
import_files -fileset sim_1 -norecurse ${hdk_file}/hw/sources/config/config.v
set_property file_type {Verilog Header} [get_files config.v]
