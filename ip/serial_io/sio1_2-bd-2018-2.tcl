
################################################################
# This is a generated script based on design: sio1_2
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source sio1_2_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a200tfbg484-2
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name sio1_2

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axis_clock_converter:1.1\
fnal.gov:user:bitslip:1.0\
xilinx.com:ip:clk_wiz:6.0\
fnal.gov:user:convert:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
fnal.gov:user:readout:1.0\
xilinx.com:ip:selectio_wiz:5.1\
xilinx.com:ip:util_ds_buf:2.1\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xlslice:1.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set acquire [ create_bd_port -dir I acquire ]
  set adc_clk_n [ create_bd_port -dir O -from 0 -to 0 -type clk adc_clk_n ]
  set adc_clk_p [ create_bd_port -dir O -from 0 -to 0 -type clk adc_clk_p ]
  set adc_cnvrt_n [ create_bd_port -dir O -from 0 -to 0 -type clk adc_cnvrt_n ]
  set adc_cnvrt_p [ create_bd_port -dir O -from 0 -to 0 -type clk adc_cnvrt_p ]
  set clk_100 [ create_bd_port -dir I -type clk clk_100 ]
  set din_n [ create_bd_port -dir I -from 1 -to 0 din_n ]
  set din_p [ create_bd_port -dir I -from 1 -to 0 din_p ]
  set dout [ create_bd_port -dir O -from 17 -to 0 dout ]
  set dout_strobe [ create_bd_port -dir O dout_strobe ]
  set en_tst_ptrn [ create_bd_port -dir I en_tst_ptrn ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset
  set send_bitslip [ create_bd_port -dir I send_bitslip ]

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]
  set_property -dict [ list \
   CONFIG.TDATA_NUM_BYTES {3} \
 ] $axis_clock_converter_0

  # Create instance: bitslip_0, and set properties
  set bitslip_0 [ create_bd_cell -type ip -vlnv fnal.gov:user:bitslip:1.0 bitslip_0 ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {127.220} \
   CONFIG.CLKOUT1_PHASE_ERROR {105.461} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {150.000} \
   CONFIG.CLKOUT2_DRIVES {BUFGCE} \
   CONFIG.CLKOUT2_JITTER {127.220} \
   CONFIG.CLKOUT2_PHASE_ERROR {105.461} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {150.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_DRIVES {BUFG} \
   CONFIG.CLKOUT3_JITTER {176.981} \
   CONFIG.CLKOUT3_PHASE_ERROR {105.461} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {30.000} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_DRIVES {BUFG} \
   CONFIG.CLKOUT5_DRIVES {BUFG} \
   CONFIG.CLKOUT6_DRIVES {BUFG} \
   CONFIG.CLKOUT7_DRIVES {BUFG} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {9} \
   CONFIG.MMCM_CLKIN1_PERIOD {10.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {6} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {6} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {30} \
   CONFIG.MMCM_COMPENSATION {ZHOLD} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.PRIMITIVE {PLL} \
   CONFIG.PRIM_SOURCE {Global_buffer} \
   CONFIG.USE_LOCKED {true} \
 ] $clk_wiz_0

  # Create instance: convert_0, and set properties
  set convert_0 [ create_bd_cell -type ip -vlnv fnal.gov:user:convert:1.0 convert_0 ]

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: readout_0, and set properties
  set readout_0 [ create_bd_cell -type ip -vlnv fnal.gov:user:readout:1.0 readout_0 ]

  # Create instance: selectio_wiz_0, and set properties
  set selectio_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:selectio_wiz:5.1 selectio_wiz_0 ]
  set_property -dict [ list \
   CONFIG.BUS_IO_STD {LVDS_25} \
   CONFIG.BUS_SIG_TYPE {DIFF} \
   CONFIG.CLK_FWD_IO_STD {LVDS_25} \
   CONFIG.CLK_FWD_SIG_TYPE {DIFF} \
   CONFIG.SELIO_ACTIVE_EDGE {DDR} \
   CONFIG.SELIO_CLK_BUF {MMCM} \
   CONFIG.SELIO_CLK_IO_STD {LVDS_25} \
   CONFIG.SELIO_CLK_SIG_TYPE {DIFF} \
   CONFIG.SELIO_INTERFACE_TYPE {NETWORKING} \
   CONFIG.SERIALIZATION_FACTOR {10} \
   CONFIG.SYSTEM_DATA_WIDTH {2} \
   CONFIG.USE_SERIALIZATION {true} \
 ] $selectio_wiz_0

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {OBUFDS} \
 ] $util_ds_buf_0

  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_1 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {OBUFDS} \
 ] $util_ds_buf_1

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {18} \
   CONFIG.IN1_WIDTH {6} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {6} \
 ] $xlconstant_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {17} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {18} \
 ] $xlslice_0

  # Create port connections
  connect_bd_net -net acquire_1 [get_bd_ports acquire] [get_bd_pins convert_0/acquire] [get_bd_pins readout_0/acquire]
  connect_bd_net -net axis_clock_converter_0_m_axis_tdata [get_bd_pins axis_clock_converter_0/m_axis_tdata] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net axis_clock_converter_0_m_axis_tvalid [get_bd_ports dout_strobe] [get_bd_pins axis_clock_converter_0/m_axis_tvalid]
  connect_bd_net -net bitslip_0_sio_wiz_bitslip [get_bd_pins bitslip_0/sio_wiz_bitslip] [get_bd_pins selectio_wiz_0/bitslip]
  connect_bd_net -net bitslip_0_sio_wiz_data_out [get_bd_pins bitslip_0/sio_wiz_data_out] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net clk_in1_1 [get_bd_ports clk_100] [get_bd_pins axis_clock_converter_0/m_axis_aclk] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins bitslip_0/clk_1] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins convert_0/clk_1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk] [get_bd_pins readout_0/clk_1] [get_bd_pins selectio_wiz_0/clk_in]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins util_ds_buf_0/OBUF_IN]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins bitslip_0/clk_3] [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins convert_0/clk_3] [get_bd_pins readout_0/clk_3] [get_bd_pins selectio_wiz_0/clk_div_in]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins proc_sys_reset_1/dcm_locked]
  connect_bd_net -net convert_0_adc_convert [get_bd_pins convert_0/adc_convert] [get_bd_pins util_ds_buf_1/OBUF_IN]
  connect_bd_net -net convert_0_convert_done [get_bd_pins convert_0/convert_done] [get_bd_pins readout_0/convert_done]
  connect_bd_net -net data_in_from_pins_n_1 [get_bd_ports din_n] [get_bd_pins selectio_wiz_0/data_in_from_pins_n]
  connect_bd_net -net data_in_from_pins_p_1 [get_bd_ports din_p] [get_bd_pins selectio_wiz_0/data_in_from_pins_p]
  connect_bd_net -net enable_test_pattern_1 [get_bd_ports en_tst_ptrn] [get_bd_pins bitslip_0/enable_test_pattern]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_pins bitslip_0/master_reset] [get_bd_pins convert_0/master_reset] [get_bd_pins proc_sys_reset_0/peripheral_reset] [get_bd_pins readout_0/master_reset]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins axis_clock_converter_0/m_axis_aresetn] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_reset [get_bd_pins proc_sys_reset_1/peripheral_reset] [get_bd_pins selectio_wiz_0/io_reset]
  connect_bd_net -net readout_0_adc_readout [get_bd_pins convert_0/readout_cycle] [get_bd_pins readout_0/adc_readout]
  connect_bd_net -net readout_0_clk_5_ce [get_bd_pins clk_wiz_0/clk_out2_ce] [get_bd_pins readout_0/clk_5_ce]
  connect_bd_net -net readout_1_0_sio_wiz_dstrobe [get_bd_pins axis_clock_converter_0/s_axis_tvalid] [get_bd_pins bitslip_0/check_test_pattern] [get_bd_pins readout_0/sio_wiz_dstrobe]
  connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins clk_wiz_0/reset] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net selectio_wiz_0_data_in_to_device [get_bd_pins bitslip_0/sio_wiz_data_in] [get_bd_pins selectio_wiz_0/data_in_to_device]
  connect_bd_net -net send_bitslip_0_1 [get_bd_ports send_bitslip] [get_bd_pins bitslip_0/send_bitslip_0] [get_bd_pins bitslip_0/send_bitslip_1]
  connect_bd_net -net util_ds_buf_0_OBUF_DS_N [get_bd_ports adc_clk_n] [get_bd_pins util_ds_buf_0/OBUF_DS_N]
  connect_bd_net -net util_ds_buf_0_OBUF_DS_P [get_bd_ports adc_clk_p] [get_bd_pins util_ds_buf_0/OBUF_DS_P]
  connect_bd_net -net util_ds_buf_1_OBUF_DS_N [get_bd_ports adc_cnvrt_n] [get_bd_pins util_ds_buf_1/OBUF_DS_N]
  connect_bd_net -net util_ds_buf_1_OBUF_DS_P [get_bd_ports adc_cnvrt_p] [get_bd_pins util_ds_buf_1/OBUF_DS_P]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins axis_clock_converter_0/s_axis_tdata] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_ports dout] [get_bd_pins xlslice_0/Dout]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_msg_id "BD_TCL-1000" "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

