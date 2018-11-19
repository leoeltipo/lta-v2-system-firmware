
################################################################
# This is a generated script based on design: design_1
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
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# vec2bit_4, vec2bit_5, gpio_leds_bits, vec2bit_6, vec2bit_2, packer_header_vec2bit, spi_ldo_mux, adc_bits, sequencer_bits

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a200tfbg484-2
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

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
fnal.gov:user:cds_noncausal:1.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:ila:6.2\
fnal.gov:user:packer:1.0\
fnal.gov:user:smart_buffer:1.0\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:xlconstant:1.1\
fnal.gov:user:serial_io:1.0\
fnal.gov:user:eth_resync:1.0\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:axi_bram_ctrl:4.0\
fnal.gov:user:sequencer:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:util_ds_buf:2.1\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:fit_timer:2.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:microblaze:10.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:lmb_v10:3.0\
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

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
vec2bit_4\
vec2bit_5\
gpio_leds_bits\
vec2bit_6\
vec2bit_2\
packer_header_vec2bit\
spi_ldo_mux\
adc_bits\
sequencer_bits\
"

   set list_mods_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_msg_id "BD_TCL-008" "INFO" "Please add source files for the missing module(s) above."
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


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB

  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $ilmb_bram_if_cntlr

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [ list \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ublaze_hie
proc create_hier_cell_ublaze_hie { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ublaze_hie() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_DP
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  # Create pins
  create_bd_pin -dir I -type rst CPU_RESET
  create_bd_pin -dir I -type clk Clk
  create_bd_pin -dir I dcm_locked
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn

  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]

  # Create instance: fit_timer_0, and set properties
  set fit_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fit_timer:2.0 fit_timer_0 ]
  set_property -dict [ list \
   CONFIG.C_NO_CLOCKS {100000} \
 ] $fit_timer_0

  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:10.0 microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_I_LMB {1} \
 ] $microblaze_0

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory $hier_obj microblaze_0_local_memory

  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_intc_0_interrupt [get_bd_intf_pins axi_intc_0/interrupt] [get_bd_intf_pins microblaze_0/INTERRUPT]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins M_AXI_DP] [get_bd_intf_pins microblaze_0/M_AXI_DP]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins s_axi] [get_bd_intf_pins axi_intc_0/s_axi]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]

  # Create port connections
  connect_bd_net -net CPU_RESET_1 [get_bd_pins CPU_RESET] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins dcm_locked] [get_bd_pins rst_clk_wiz_1_100M/dcm_locked]
  connect_bd_net -net fit_timer_0_Interrupt [get_bd_pins axi_intc_0/intr] [get_bd_pins fit_timer_0/Interrupt]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins Clk] [get_bd_pins axi_intc_0/s_axi_aclk] [get_bd_pins fit_timer_0/Clk] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn [get_bd_pins interconnect_aresetn] [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_reset [get_bd_pins fit_timer_0/Rst] [get_bd_pins rst_clk_wiz_1_100M/peripheral_reset]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sys_clk_hie
proc create_hier_cell_sys_clk_hie { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sys_clk_hie() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type rst CPU_RESET
  create_bd_pin -dir I -from 0 -to 0 -type clk USER_CLK
  create_bd_pin -dir O -type clk clk_out1
  create_bd_pin -dir O -type clk clk_out2
  create_bd_pin -dir O locked

  # Create instance: sys_clk, and set properties
  set sys_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 sys_clk ]
  set_property -dict [ list \
   CONFIG.CLKOUT2_JITTER {209.588} \
   CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {10} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {100} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIM_SOURCE {Global_buffer} \
 ] $sys_clk

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {BUFG} \
 ] $util_ds_buf_0

  # Create port connections
  connect_bd_net -net CPU_RESET_1 [get_bd_pins CPU_RESET] [get_bd_pins sys_clk/reset]
  connect_bd_net -net USER_CLK_1 [get_bd_pins USER_CLK] [get_bd_pins util_ds_buf_0/BUFG_I]
  connect_bd_net -net clk_wiz_1_clk_out2 [get_bd_pins clk_out2] [get_bd_pins sys_clk/clk_out2]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins locked] [get_bd_pins sys_clk/locked]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins clk_out1] [get_bd_pins sys_clk/clk_out1]
  connect_bd_net -net util_ds_buf_0_BUFG_O [get_bd_pins sys_clk/clk_in1] [get_bd_pins util_ds_buf_0/BUFG_O]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sequencer_hie
proc create_hier_cell_sequencer_hie { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sequencer_hie() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s00_axi

  # Create pins
  create_bd_pin -dir O TGL_DGA
  create_bd_pin -dir O TGL_DGB
  create_bd_pin -dir O TGL_H1A
  create_bd_pin -dir O TGL_H1B
  create_bd_pin -dir O TGL_H2C
  create_bd_pin -dir O TGL_H3A
  create_bd_pin -dir O TGL_H3B
  create_bd_pin -dir O TGL_OGA
  create_bd_pin -dir O TGL_OGB
  create_bd_pin -dir O TGL_RGA
  create_bd_pin -dir O TGL_RGB
  create_bd_pin -dir O TGL_SWA
  create_bd_pin -dir O TGL_SWB
  create_bd_pin -dir O TGL_TGA
  create_bd_pin -dir O TGL_TGB
  create_bd_pin -dir O TGL_V1A
  create_bd_pin -dir O TGL_V1B
  create_bd_pin -dir O TGL_V2C
  create_bd_pin -dir O TGL_V3A
  create_bd_pin -dir O TGL_V3B
  create_bd_pin -dir O out21
  create_bd_pin -dir O out22
  create_bd_pin -dir O out23
  create_bd_pin -dir O out24
  create_bd_pin -dir O out25
  create_bd_pin -dir O out26
  create_bd_pin -dir I -type clk s00_axi_aclk
  create_bd_pin -dir I -type rst s00_axi_aresetn

  # Create instance: sequencer, and set properties
  set sequencer [ create_bd_cell -type ip -vlnv fnal.gov:user:sequencer:1.0 sequencer ]

  # Create instance: sequencer_bits, and set properties
  set block_name sequencer_bits
  set block_cell_name sequencer_bits
  if { [catch {set sequencer_bits [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sequencer_bits eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M13_AXI [get_bd_intf_pins s00_axi] [get_bd_intf_pins sequencer/s00_axi]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins out25] [get_bd_pins sequencer_bits/out25]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins s00_axi_aclk] [get_bd_pins sequencer/s00_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins s00_axi_aresetn] [get_bd_pins sequencer/s00_axi_aresetn]
  connect_bd_net -net sequencer_bits_out0 [get_bd_pins TGL_V1A] [get_bd_pins sequencer_bits/out0]
  connect_bd_net -net sequencer_bits_out1 [get_bd_pins TGL_V1B] [get_bd_pins sequencer_bits/out1]
  connect_bd_net -net sequencer_bits_out2 [get_bd_pins TGL_V2C] [get_bd_pins sequencer_bits/out2]
  connect_bd_net -net sequencer_bits_out3 [get_bd_pins TGL_V3A] [get_bd_pins sequencer_bits/out3]
  connect_bd_net -net sequencer_bits_out4 [get_bd_pins TGL_V3B] [get_bd_pins sequencer_bits/out4]
  connect_bd_net -net sequencer_bits_out5 [get_bd_pins TGL_H1A] [get_bd_pins sequencer_bits/out5]
  connect_bd_net -net sequencer_bits_out6 [get_bd_pins TGL_H1B] [get_bd_pins sequencer_bits/out6]
  connect_bd_net -net sequencer_bits_out7 [get_bd_pins TGL_H2C] [get_bd_pins sequencer_bits/out7]
  connect_bd_net -net sequencer_bits_out8 [get_bd_pins TGL_H3A] [get_bd_pins sequencer_bits/out8]
  connect_bd_net -net sequencer_bits_out9 [get_bd_pins TGL_H3B] [get_bd_pins sequencer_bits/out9]
  connect_bd_net -net sequencer_bits_out10 [get_bd_pins TGL_SWA] [get_bd_pins sequencer_bits/out10]
  connect_bd_net -net sequencer_bits_out11 [get_bd_pins TGL_SWB] [get_bd_pins sequencer_bits/out11]
  connect_bd_net -net sequencer_bits_out12 [get_bd_pins TGL_RGA] [get_bd_pins sequencer_bits/out12]
  connect_bd_net -net sequencer_bits_out13 [get_bd_pins TGL_RGB] [get_bd_pins sequencer_bits/out13]
  connect_bd_net -net sequencer_bits_out14 [get_bd_pins TGL_OGA] [get_bd_pins sequencer_bits/out14]
  connect_bd_net -net sequencer_bits_out15 [get_bd_pins TGL_OGB] [get_bd_pins sequencer_bits/out15]
  connect_bd_net -net sequencer_bits_out16 [get_bd_pins TGL_DGA] [get_bd_pins sequencer_bits/out16]
  connect_bd_net -net sequencer_bits_out17 [get_bd_pins TGL_DGB] [get_bd_pins sequencer_bits/out17]
  connect_bd_net -net sequencer_bits_out18 [get_bd_pins TGL_TGA] [get_bd_pins sequencer_bits/out18]
  connect_bd_net -net sequencer_bits_out19 [get_bd_pins TGL_TGB] [get_bd_pins sequencer_bits/out19]
  connect_bd_net -net sequencer_bits_out21 [get_bd_pins out21] [get_bd_pins sequencer_bits/out21]
  connect_bd_net -net sequencer_bits_out22 [get_bd_pins out22] [get_bd_pins sequencer_bits/out22]
  connect_bd_net -net sequencer_bits_out23 [get_bd_pins out23] [get_bd_pins sequencer_bits/out23]
  connect_bd_net -net sequencer_bits_out24 [get_bd_pins out24] [get_bd_pins sequencer_bits/out24]
  connect_bd_net -net sequencer_bits_out26 [get_bd_pins out26] [get_bd_pins sequencer_bits/out26]
  connect_bd_net -net sequencer_seq_port_out [get_bd_pins sequencer/seq_port_out] [get_bd_pins sequencer_bits/vec_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: eth_hie
proc create_hier_cell_eth_hie { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_eth_hie() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI1

  # Create pins
  create_bd_pin -dir I -type rst CPU_RESET
  create_bd_pin -dir O ENET_GTXCLK
  create_bd_pin -dir I ENET_RX0
  create_bd_pin -dir I ENET_RX1
  create_bd_pin -dir I ENET_RX2
  create_bd_pin -dir I ENET_RX3
  create_bd_pin -dir I ENET_RX4
  create_bd_pin -dir I ENET_RX5
  create_bd_pin -dir I ENET_RX6
  create_bd_pin -dir I ENET_RX7
  create_bd_pin -dir I ENET_RXCLK
  create_bd_pin -dir I ENET_RXDV
  create_bd_pin -dir O ENET_TX0
  create_bd_pin -dir O ENET_TX1
  create_bd_pin -dir O ENET_TX2
  create_bd_pin -dir O ENET_TX3
  create_bd_pin -dir O ENET_TX4
  create_bd_pin -dir O ENET_TX5
  create_bd_pin -dir O ENET_TX6
  create_bd_pin -dir O ENET_TX7
  create_bd_pin -dir O ENET_TXEN
  create_bd_pin -dir O ENET_TXER
  create_bd_pin -dir I -from 63 -to 0 b_data
  create_bd_pin -dir I b_we
  create_bd_pin -dir I enb
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: eth, and set properties
  set eth [ create_bd_cell -type ip -vlnv fnal.gov:user:eth_resync:1.0 eth ]

  # Create instance: gpio_eth, and set properties
  set gpio_eth [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_eth ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {8} \
 ] $gpio_eth

  # Create instance: ram_eth, and set properties
  set ram_eth [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 ram_eth ]
  set_property -dict [ list \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
 ] $ram_eth

  # Create instance: ram_eth_ctrl, and set properties
  set ram_eth_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 ram_eth_ctrl ]
  set_property -dict [ list \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $ram_eth_ctrl

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M11_AXI [get_bd_intf_pins S_AXI1] [get_bd_intf_pins gpio_eth/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M12_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins ram_eth_ctrl/S_AXI]
  connect_bd_intf_net -intf_net ram_eth_ctrl_BRAM_PORTA [get_bd_intf_pins ram_eth/BRAM_PORTA] [get_bd_intf_pins ram_eth_ctrl/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net CPU_RESET_1 [get_bd_pins CPU_RESET] [get_bd_pins eth/rst]
  connect_bd_net -net ENET_RX0_1 [get_bd_pins ENET_RX0] [get_bd_pins eth/ENET_RX0]
  connect_bd_net -net ENET_RX1_1 [get_bd_pins ENET_RX1] [get_bd_pins eth/ENET_RX1]
  connect_bd_net -net ENET_RX2_1 [get_bd_pins ENET_RX2] [get_bd_pins eth/ENET_RX2]
  connect_bd_net -net ENET_RX3_1 [get_bd_pins ENET_RX3] [get_bd_pins eth/ENET_RX3]
  connect_bd_net -net ENET_RX4_1 [get_bd_pins ENET_RX4] [get_bd_pins eth/ENET_RX4]
  connect_bd_net -net ENET_RX5_1 [get_bd_pins ENET_RX5] [get_bd_pins eth/ENET_RX5]
  connect_bd_net -net ENET_RX6_1 [get_bd_pins ENET_RX6] [get_bd_pins eth/ENET_RX6]
  connect_bd_net -net ENET_RX7_1 [get_bd_pins ENET_RX7] [get_bd_pins eth/ENET_RX7]
  connect_bd_net -net ENET_RXCLK_1 [get_bd_pins ENET_RXCLK] [get_bd_pins eth/ENET_RXCLK]
  connect_bd_net -net ENET_RXDV_1 [get_bd_pins ENET_RXDV] [get_bd_pins eth/ENET_RXDV]
  connect_bd_net -net eth_addr [get_bd_pins eth/addr] [get_bd_pins ram_eth/addrb]
  connect_bd_net -net eth_clk_125_out [get_bd_pins eth/clk_125_out] [get_bd_pins ram_eth/clkb]
  connect_bd_net -net eth_data_out [get_bd_pins eth/data_out] [get_bd_pins ram_eth/dinb]
  connect_bd_net -net eth_resync_0_ENET_GTXCLK [get_bd_pins ENET_GTXCLK] [get_bd_pins eth/ENET_GTXCLK]
  connect_bd_net -net eth_resync_0_ENET_TX0 [get_bd_pins ENET_TX0] [get_bd_pins eth/ENET_TX0]
  connect_bd_net -net eth_resync_0_ENET_TX1 [get_bd_pins ENET_TX1] [get_bd_pins eth/ENET_TX1]
  connect_bd_net -net eth_resync_0_ENET_TX2 [get_bd_pins ENET_TX2] [get_bd_pins eth/ENET_TX2]
  connect_bd_net -net eth_resync_0_ENET_TX3 [get_bd_pins ENET_TX3] [get_bd_pins eth/ENET_TX3]
  connect_bd_net -net eth_resync_0_ENET_TX4 [get_bd_pins ENET_TX4] [get_bd_pins eth/ENET_TX4]
  connect_bd_net -net eth_resync_0_ENET_TX5 [get_bd_pins ENET_TX5] [get_bd_pins eth/ENET_TX5]
  connect_bd_net -net eth_resync_0_ENET_TX6 [get_bd_pins ENET_TX6] [get_bd_pins eth/ENET_TX6]
  connect_bd_net -net eth_resync_0_ENET_TX7 [get_bd_pins ENET_TX7] [get_bd_pins eth/ENET_TX7]
  connect_bd_net -net eth_resync_0_ENET_TXEN [get_bd_pins ENET_TXEN] [get_bd_pins eth/ENET_TXEN]
  connect_bd_net -net eth_resync_0_ENET_TXER [get_bd_pins ENET_TXER] [get_bd_pins eth/ENET_TXER]
  connect_bd_net -net eth_wren [get_bd_pins eth/wren] [get_bd_pins ram_eth/web]
  connect_bd_net -net gpio_eth_gpio_io_o [get_bd_pins eth/user_addr] [get_bd_pins gpio_eth/gpio_io_o]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins s_axi_aclk] [get_bd_pins gpio_eth/s_axi_aclk] [get_bd_pins ram_eth_ctrl/s_axi_aclk]
  connect_bd_net -net packer_0_dout [get_bd_pins b_data] [get_bd_pins eth/b_data]
  connect_bd_net -net packer_0_dready [get_bd_pins b_we] [get_bd_pins eth/b_we]
  connect_bd_net -net ram_eth_doutb [get_bd_pins eth/data_in] [get_bd_pins ram_eth/doutb]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins gpio_eth/s_axi_aresetn] [get_bd_pins ram_eth_ctrl/s_axi_aresetn]
  connect_bd_net -net xlconstant_0_dout1 [get_bd_pins enb] [get_bd_pins ram_eth/enb]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: adc
proc create_hier_cell_adc { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_adc() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  # Create pins
  create_bd_pin -dir O -from 0 -to 0 ADC_A_CLK_N
  create_bd_pin -dir O -from 0 -to 0 ADC_A_CLK_P
  create_bd_pin -dir O -from 0 -to 0 ADC_A_CNVRT_N
  create_bd_pin -dir O -from 0 -to 0 ADC_A_CNVRT_P
  create_bd_pin -dir I -from 1 -to 0 ADC_A_DATA_N
  create_bd_pin -dir I -from 1 -to 0 ADC_A_DATA_P
  create_bd_pin -dir O ADC_A_PWRDOWNn
  create_bd_pin -dir O ADC_A_TEST_PTRN
  create_bd_pin -dir O -from 0 -to 0 ADC_B_CLK_N
  create_bd_pin -dir O -from 0 -to 0 ADC_B_CLK_P
  create_bd_pin -dir O -from 0 -to 0 ADC_B_CNVRT_N
  create_bd_pin -dir O -from 0 -to 0 ADC_B_CNVRT_P
  create_bd_pin -dir I -from 1 -to 0 ADC_B_DATA_N
  create_bd_pin -dir I -from 1 -to 0 ADC_B_DATA_P
  create_bd_pin -dir O ADC_B_PWRDOWNn
  create_bd_pin -dir O ADC_B_TEST_PTRN
  create_bd_pin -dir I CPU_RESET
  create_bd_pin -dir I clk_100
  create_bd_pin -dir O -from 17 -to 0 dout
  create_bd_pin -dir O -from 17 -to 0 dout1
  create_bd_pin -dir O dout_strobe
  create_bd_pin -dir O dout_strobe1
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: adc_a, and set properties
  set adc_a [ create_bd_cell -type ip -vlnv fnal.gov:user:serial_io:1.0 adc_a ]

  # Create instance: adc_bits, and set properties
  set block_name adc_bits
  set block_cell_name adc_bits
  if { [catch {set adc_bits [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $adc_bits eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: gpio_adc, and set properties
  set gpio_adc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_adc ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {16} \
 ] $gpio_adc

  # Create instance: serial_io_0, and set properties
  set serial_io_0 [ create_bd_cell -type ip -vlnv fnal.gov:user:serial_io:1.0 serial_io_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins gpio_adc/S_AXI]

  # Create port connections
  connect_bd_net -net ADC_A_DATA_N_1 [get_bd_pins ADC_A_DATA_N] [get_bd_pins adc_a/din_n]
  connect_bd_net -net ADC_A_DATA_P_1 [get_bd_pins ADC_A_DATA_P] [get_bd_pins adc_a/din_p]
  connect_bd_net -net ADC_B_DATA_N_1 [get_bd_pins ADC_B_DATA_N] [get_bd_pins serial_io_0/din_n]
  connect_bd_net -net ADC_B_DATA_P_1 [get_bd_pins ADC_B_DATA_P] [get_bd_pins serial_io_0/din_p]
  connect_bd_net -net CPU_RESET_1 [get_bd_pins CPU_RESET] [get_bd_pins adc_a/reset] [get_bd_pins serial_io_0/reset]
  connect_bd_net -net adc_a_dout [get_bd_pins dout] [get_bd_pins adc_a/dout]
  connect_bd_net -net adc_a_dout_strobe [get_bd_pins dout_strobe] [get_bd_pins adc_a/dout_strobe]
  connect_bd_net -net adc_bits_out0 [get_bd_pins adc_a/acquire] [get_bd_pins adc_bits/out0]
  connect_bd_net -net adc_bits_out1 [get_bd_pins ADC_A_TEST_PTRN] [get_bd_pins adc_a/en_tst_ptrn] [get_bd_pins adc_bits/out1]
  connect_bd_net -net adc_bits_out2 [get_bd_pins adc_a/send_bitslip] [get_bd_pins adc_bits/out2]
  connect_bd_net -net adc_bits_out3 [get_bd_pins ADC_A_PWRDOWNn] [get_bd_pins adc_bits/out3]
  connect_bd_net -net adc_bits_out4 [get_bd_pins adc_bits/out4] [get_bd_pins serial_io_0/acquire]
  connect_bd_net -net adc_bits_out5 [get_bd_pins ADC_B_TEST_PTRN] [get_bd_pins adc_bits/out5] [get_bd_pins serial_io_0/en_tst_ptrn]
  connect_bd_net -net adc_bits_out6 [get_bd_pins adc_bits/out6] [get_bd_pins serial_io_0/send_bitslip]
  connect_bd_net -net adc_bits_out7 [get_bd_pins ADC_B_PWRDOWNn] [get_bd_pins adc_bits/out7]
  connect_bd_net -net gpio_adc_gpio_io_o [get_bd_pins adc_bits/vec_in] [get_bd_pins gpio_adc/gpio_io_o]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins clk_100] [get_bd_pins adc_a/clk_100] [get_bd_pins gpio_adc/s_axi_aclk] [get_bd_pins serial_io_0/clk_100]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins gpio_adc/s_axi_aresetn]
  connect_bd_net -net serial_io_0_adc_clk_n [get_bd_pins ADC_A_CLK_N] [get_bd_pins adc_a/adc_clk_n]
  connect_bd_net -net serial_io_0_adc_clk_n1 [get_bd_pins ADC_B_CLK_N] [get_bd_pins serial_io_0/adc_clk_n]
  connect_bd_net -net serial_io_0_adc_clk_p [get_bd_pins ADC_A_CLK_P] [get_bd_pins adc_a/adc_clk_p]
  connect_bd_net -net serial_io_0_adc_clk_p1 [get_bd_pins ADC_B_CLK_P] [get_bd_pins serial_io_0/adc_clk_p]
  connect_bd_net -net serial_io_0_adc_cnvrt_n [get_bd_pins ADC_A_CNVRT_N] [get_bd_pins adc_a/adc_cnvrt_n]
  connect_bd_net -net serial_io_0_adc_cnvrt_n1 [get_bd_pins ADC_B_CNVRT_N] [get_bd_pins serial_io_0/adc_cnvrt_n]
  connect_bd_net -net serial_io_0_adc_cnvrt_p [get_bd_pins ADC_A_CNVRT_P] [get_bd_pins adc_a/adc_cnvrt_p]
  connect_bd_net -net serial_io_0_adc_cnvrt_p1 [get_bd_pins ADC_B_CNVRT_P] [get_bd_pins serial_io_0/adc_cnvrt_p]
  connect_bd_net -net serial_io_0_dout [get_bd_pins dout1] [get_bd_pins serial_io_0/dout]
  connect_bd_net -net serial_io_0_dout_strobe [get_bd_pins dout_strobe1] [get_bd_pins serial_io_0/dout_strobe]

  # Restore current instance
  current_bd_instance $oldCurInst
}


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
  set ADC_A_CLK_N [ create_bd_port -dir O -from 0 -to 0 ADC_A_CLK_N ]
  set ADC_A_CLK_P [ create_bd_port -dir O -from 0 -to 0 ADC_A_CLK_P ]
  set ADC_A_CNVRT_N [ create_bd_port -dir O -from 0 -to 0 ADC_A_CNVRT_N ]
  set ADC_A_CNVRT_P [ create_bd_port -dir O -from 0 -to 0 ADC_A_CNVRT_P ]
  set ADC_A_DATA_N [ create_bd_port -dir I -from 1 -to 0 ADC_A_DATA_N ]
  set ADC_A_DATA_P [ create_bd_port -dir I -from 1 -to 0 ADC_A_DATA_P ]
  set ADC_A_PWRDOWNn [ create_bd_port -dir O ADC_A_PWRDOWNn ]
  set ADC_A_TEST_PTRN [ create_bd_port -dir O ADC_A_TEST_PTRN ]
  set ADC_A_TWO_LANES [ create_bd_port -dir O -from 0 -to 0 ADC_A_TWO_LANES ]
  set ADC_B_CLK_N [ create_bd_port -dir O -from 0 -to 0 ADC_B_CLK_N ]
  set ADC_B_CLK_P [ create_bd_port -dir O -from 0 -to 0 ADC_B_CLK_P ]
  set ADC_B_CNVRT_N [ create_bd_port -dir O -from 0 -to 0 ADC_B_CNVRT_N ]
  set ADC_B_CNVRT_P [ create_bd_port -dir O -from 0 -to 0 ADC_B_CNVRT_P ]
  set ADC_B_DATA_N [ create_bd_port -dir I -from 1 -to 0 ADC_B_DATA_N ]
  set ADC_B_DATA_P [ create_bd_port -dir I -from 1 -to 0 ADC_B_DATA_P ]
  set ADC_B_PWRDOWNn [ create_bd_port -dir O ADC_B_PWRDOWNn ]
  set ADC_B_TEST_PTRN [ create_bd_port -dir O ADC_B_TEST_PTRN ]
  set ADC_B_TWO_LANES [ create_bd_port -dir O -from 0 -to 0 ADC_B_TWO_LANES ]
  set CCD_VDD_DIGPOT_SDO [ create_bd_port -dir I CCD_VDD_DIGPOT_SDO ]
  set CCD_VDD_DIGPOT_SYNCn [ create_bd_port -dir O CCD_VDD_DIGPOT_SYNCn ]
  set CCD_VDD_EN [ create_bd_port -dir O CCD_VDD_EN ]
  set CCD_VDRAIN_DIGPOT_SDO [ create_bd_port -dir I CCD_VDRAIN_DIGPOT_SDO ]
  set CCD_VDRAIN_DIGPOT_SYNCn [ create_bd_port -dir O CCD_VDRAIN_DIGPOT_SYNCn ]
  set CCD_VDRAIN_EN [ create_bd_port -dir O CCD_VDRAIN_EN ]
  set CCD_VR_DIGPOT_SDO [ create_bd_port -dir I CCD_VR_DIGPOT_SDO ]
  set CCD_VR_DIGPOT_SYNCn [ create_bd_port -dir O CCD_VR_DIGPOT_SYNCn ]
  set CCD_VR_EN [ create_bd_port -dir O CCD_VR_EN ]
  set CCD_VSUB_DIGPOT_SDO [ create_bd_port -dir I CCD_VSUB_DIGPOT_SDO ]
  set CCD_VSUB_DIGPOT_SYNCn [ create_bd_port -dir O CCD_VSUB_DIGPOT_SYNCn ]
  set CCD_VSUB_EN [ create_bd_port -dir O CCD_VSUB_EN ]
  set CPU_RESET [ create_bd_port -dir I -type rst CPU_RESET ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $CPU_RESET
  set DAC_CLRn [ create_bd_port -dir O DAC_CLRn ]
  set DAC_LDACn [ create_bd_port -dir O DAC_LDACn ]
  set DAC_RESETn [ create_bd_port -dir O DAC_RESETn ]
  set DAC_SCLK [ create_bd_port -dir O DAC_SCLK ]
  set DAC_SDI [ create_bd_port -dir O DAC_SDI ]
  set DAC_SDO [ create_bd_port -dir I DAC_SDO ]
  set DAC_SW_EN [ create_bd_port -dir O DAC_SW_EN ]
  set DAC_SYNCn [ create_bd_port -dir O -from 0 -to 0 DAC_SYNCn ]
  set DIGPOT_DIN [ create_bd_port -dir O DIGPOT_DIN ]
  set DIGPOT_RSTn [ create_bd_port -dir O DIGPOT_RSTn ]
  set DIGPOT_SCLK [ create_bd_port -dir O DIGPOT_SCLK ]
  set ENET_GTXCLK [ create_bd_port -dir O ENET_GTXCLK ]
  set ENET_RX0 [ create_bd_port -dir I ENET_RX0 ]
  set ENET_RX1 [ create_bd_port -dir I ENET_RX1 ]
  set ENET_RX2 [ create_bd_port -dir I ENET_RX2 ]
  set ENET_RX3 [ create_bd_port -dir I ENET_RX3 ]
  set ENET_RX4 [ create_bd_port -dir I ENET_RX4 ]
  set ENET_RX5 [ create_bd_port -dir I ENET_RX5 ]
  set ENET_RX6 [ create_bd_port -dir I ENET_RX6 ]
  set ENET_RX7 [ create_bd_port -dir I ENET_RX7 ]
  set ENET_RXCLK [ create_bd_port -dir I ENET_RXCLK ]
  set ENET_RXDV [ create_bd_port -dir I ENET_RXDV ]
  set ENET_TX0 [ create_bd_port -dir O ENET_TX0 ]
  set ENET_TX1 [ create_bd_port -dir O ENET_TX1 ]
  set ENET_TX2 [ create_bd_port -dir O ENET_TX2 ]
  set ENET_TX3 [ create_bd_port -dir O ENET_TX3 ]
  set ENET_TX4 [ create_bd_port -dir O ENET_TX4 ]
  set ENET_TX5 [ create_bd_port -dir O ENET_TX5 ]
  set ENET_TX6 [ create_bd_port -dir O ENET_TX6 ]
  set ENET_TX7 [ create_bd_port -dir O ENET_TX7 ]
  set ENET_TXEN [ create_bd_port -dir O ENET_TXEN ]
  set ENET_TXER [ create_bd_port -dir O ENET_TXER ]
  set LED0 [ create_bd_port -dir O LED0 ]
  set LED1 [ create_bd_port -dir O LED1 ]
  set LED2 [ create_bd_port -dir O LED2 ]
  set LED3 [ create_bd_port -dir O LED3 ]
  set LED4 [ create_bd_port -dir O LED4 ]
  set LED5 [ create_bd_port -dir O LED5 ]
  set TEL_CSn [ create_bd_port -dir O -from 0 -to 0 TEL_CSn ]
  set TEL_DIN [ create_bd_port -dir O TEL_DIN ]
  set TEL_DOUT [ create_bd_port -dir I TEL_DOUT ]
  set TEL_MUXA0 [ create_bd_port -dir O TEL_MUXA0 ]
  set TEL_MUXA1 [ create_bd_port -dir O TEL_MUXA1 ]
  set TEL_MUXA2 [ create_bd_port -dir O TEL_MUXA2 ]
  set TEL_MUXEN0 [ create_bd_port -dir O TEL_MUXEN0 ]
  set TEL_MUXEN1 [ create_bd_port -dir O TEL_MUXEN1 ]
  set TEL_MUXEN2 [ create_bd_port -dir O TEL_MUXEN2 ]
  set TEL_SCLK [ create_bd_port -dir O TEL_SCLK ]
  set TGL_DGA [ create_bd_port -dir O TGL_DGA ]
  set TGL_DGB [ create_bd_port -dir O TGL_DGB ]
  set TGL_H1A [ create_bd_port -dir O TGL_H1A ]
  set TGL_H1B [ create_bd_port -dir O TGL_H1B ]
  set TGL_H2C [ create_bd_port -dir O TGL_H2C ]
  set TGL_H3A [ create_bd_port -dir O TGL_H3A ]
  set TGL_H3B [ create_bd_port -dir O TGL_H3B ]
  set TGL_OGA [ create_bd_port -dir O TGL_OGA ]
  set TGL_OGB [ create_bd_port -dir O TGL_OGB ]
  set TGL_RGA [ create_bd_port -dir O TGL_RGA ]
  set TGL_RGB [ create_bd_port -dir O TGL_RGB ]
  set TGL_SWA [ create_bd_port -dir O TGL_SWA ]
  set TGL_SWB [ create_bd_port -dir O TGL_SWB ]
  set TGL_TGA [ create_bd_port -dir O TGL_TGA ]
  set TGL_TGB [ create_bd_port -dir O TGL_TGB ]
  set TGL_V1A [ create_bd_port -dir O TGL_V1A ]
  set TGL_V1B [ create_bd_port -dir O TGL_V1B ]
  set TGL_V2C [ create_bd_port -dir O TGL_V2C ]
  set TGL_V3A [ create_bd_port -dir O TGL_V3A ]
  set TGL_V3B [ create_bd_port -dir O TGL_V3B ]
  set USB_UART_RX [ create_bd_port -dir O USB_UART_RX ]
  set USB_UART_TX [ create_bd_port -dir I USB_UART_TX ]
  set USER_CLK [ create_bd_port -dir I -type clk USER_CLK ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
 ] $USER_CLK
  set VOLT_SW_CLK [ create_bd_port -dir O VOLT_SW_CLK ]
  set VOLT_SW_CLR [ create_bd_port -dir O VOLT_SW_CLR ]
  set VOLT_SW_DIN [ create_bd_port -dir O VOLT_SW_DIN ]
  set VOLT_SW_DOUT [ create_bd_port -dir I VOLT_SW_DOUT ]
  set VOLT_SW_LEn [ create_bd_port -dir O VOLT_SW_LEn ]
  set V_100VP_SYNC [ create_bd_port -dir O -from 0 -to 0 V_100VP_SYNC ]
  set V_15VN_SYNC [ create_bd_port -dir O -from 0 -to 0 V_15VN_SYNC ]
  set V_15VP_SYNC [ create_bd_port -dir O -from 0 -to 0 V_15VP_SYNC ]
  set V_30VN_SYNC [ create_bd_port -dir O -from 0 -to 0 V_30VN_SYNC ]
  set V_5V5P_SYNC [ create_bd_port -dir O -from 0 -to 0 V_5V5P_SYNC ]

  # Create instance: adc
  create_hier_cell_adc [current_bd_instance .] adc

  # Create instance: cds_core_a, and set properties
  set cds_core_a [ create_bd_cell -type ip -vlnv fnal.gov:user:cds_noncausal:1.0 cds_core_a ]

  # Create instance: cds_core_b, and set properties
  set cds_core_b [ create_bd_cell -type ip -vlnv fnal.gov:user:cds_noncausal:1.0 cds_core_b ]

  # Create instance: cds_core_c, and set properties
  set cds_core_c [ create_bd_cell -type ip -vlnv fnal.gov:user:cds_noncausal:1.0 cds_core_c ]

  # Create instance: cds_core_d, and set properties
  set cds_core_d [ create_bd_cell -type ip -vlnv fnal.gov:user:cds_noncausal:1.0 cds_core_d ]

  # Create instance: eth_hie
  create_hier_cell_eth_hie [current_bd_instance .] eth_hie

  # Create instance: gpio_dac, and set properties
  set gpio_dac [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_dac ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {4} \
 ] $gpio_dac

  # Create instance: gpio_dac_bits, and set properties
  set block_name vec2bit_4
  set block_cell_name gpio_dac_bits
  if { [catch {set gpio_dac_bits [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gpio_dac_bits eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: gpio_ldo, and set properties
  set gpio_ldo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_ldo ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {5} \
 ] $gpio_ldo

  # Create instance: gpio_ldo_bits, and set properties
  set block_name vec2bit_5
  set block_cell_name gpio_ldo_bits
  if { [catch {set gpio_ldo_bits [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gpio_ldo_bits eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: gpio_leds_bits, and set properties
  set block_name gpio_leds_bits
  set block_cell_name gpio_leds_bits
  if { [catch {set gpio_leds_bits [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gpio_leds_bits eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: gpio_telemetry, and set properties
  set gpio_telemetry [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_telemetry ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {6} \
 ] $gpio_telemetry

  # Create instance: gpio_telemetry_bits, and set properties
  set block_name vec2bit_6
  set block_cell_name gpio_telemetry_bits
  if { [catch {set gpio_telemetry_bits [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gpio_telemetry_bits eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: gpio_volt_sw, and set properties
  set gpio_volt_sw [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_volt_sw ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {2} \
 ] $gpio_volt_sw

  # Create instance: gpio_volt_sw_bits, and set properties
  set block_name vec2bit_2
  set block_cell_name gpio_volt_sw_bits
  if { [catch {set gpio_volt_sw_bits [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $gpio_volt_sw_bits eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0 ]
  set_property -dict [ list \
   CONFIG.ALL_PROBE_SAME_MU_CNT {2} \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_EN_STRG_QUAL {1} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {4} \
   CONFIG.C_PROBE0_MU_CNT {2} \
   CONFIG.C_PROBE1_MU_CNT {2} \
   CONFIG.C_PROBE1_WIDTH {18} \
   CONFIG.C_PROBE2_MU_CNT {2} \
   CONFIG.C_PROBE3_MU_CNT {2} \
   CONFIG.C_PROBE3_WIDTH {18} \
 ] $ila_0

  # Create instance: leds_gpio, and set properties
  set leds_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 leds_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {6} \
 ] $leds_gpio

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {21} \
 ] $microblaze_0_axi_periph

  # Create instance: packer, and set properties
  set packer [ create_bd_cell -type ip -vlnv fnal.gov:user:packer:1.0 packer ]

  # Create instance: packet_header, and set properties
  set block_name packer_header_vec2bit
  set block_cell_name packet_header
  if { [catch {set packet_header [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $packet_header eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: sequencer_hie
  create_hier_cell_sequencer_hie [current_bd_instance .] sequencer_hie

  # Create instance: smart_buffer_0, and set properties
  set smart_buffer_0 [ create_bd_cell -type ip -vlnv fnal.gov:user:smart_buffer:1.0 smart_buffer_0 ]

  # Create instance: spi_dac, and set properties
  set spi_dac [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi_dac ]
  set_property -dict [ list \
   CONFIG.C_USE_STARTUP {0} \
   CONFIG.C_USE_STARTUP_INT {0} \
 ] $spi_dac

  # Create instance: spi_ldo, and set properties
  set spi_ldo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi_ldo ]
  set_property -dict [ list \
   CONFIG.C_NUM_SS_BITS {4} \
   CONFIG.C_USE_STARTUP {0} \
   CONFIG.C_USE_STARTUP_INT {0} \
 ] $spi_ldo

  # Create instance: spi_ldo_mux, and set properties
  set block_name spi_ldo_mux
  set block_cell_name spi_ldo_mux
  if { [catch {set spi_ldo_mux [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $spi_ldo_mux eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: spi_telemetry, and set properties
  set spi_telemetry [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi_telemetry ]
  set_property -dict [ list \
   CONFIG.C_USE_STARTUP {0} \
   CONFIG.C_USE_STARTUP_INT {0} \
 ] $spi_telemetry

  # Create instance: spi_volt_sw, and set properties
  set spi_volt_sw [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi_volt_sw ]
  set_property -dict [ list \
   CONFIG.C_USE_STARTUP {0} \
   CONFIG.C_USE_STARTUP_INT {0} \
 ] $spi_volt_sw

  # Create instance: sys_clk_hie
  create_hier_cell_sys_clk_hie [current_bd_instance .] sys_clk_hie

  # Create instance: uart, and set properties
  set uart [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 uart ]

  # Create instance: ublaze_hie
  create_hier_cell_ublaze_hie [current_bd_instance .] ublaze_hie

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI] [get_bd_intf_pins ublaze_hie/M_AXI_DP]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI] [get_bd_intf_pins uart/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI] [get_bd_intf_pins ublaze_hie/s_axi]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins gpio_dac/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins gpio_ldo/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins gpio_telemetry/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins gpio_volt_sw/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins leds_gpio/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M07_AXI [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI] [get_bd_intf_pins spi_dac/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M08_AXI [get_bd_intf_pins microblaze_0_axi_periph/M08_AXI] [get_bd_intf_pins spi_ldo/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M09_AXI [get_bd_intf_pins microblaze_0_axi_periph/M09_AXI] [get_bd_intf_pins spi_telemetry/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M10_AXI [get_bd_intf_pins microblaze_0_axi_periph/M10_AXI] [get_bd_intf_pins spi_volt_sw/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M11_AXI [get_bd_intf_pins eth_hie/S_AXI1] [get_bd_intf_pins microblaze_0_axi_periph/M11_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M12_AXI [get_bd_intf_pins eth_hie/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M12_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M13_AXI [get_bd_intf_pins microblaze_0_axi_periph/M13_AXI] [get_bd_intf_pins sequencer_hie/s00_axi]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M14_AXI [get_bd_intf_pins microblaze_0_axi_periph/M14_AXI] [get_bd_intf_pins packer/s00_axi]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M15_AXI [get_bd_intf_pins cds_core_a/s00_axi] [get_bd_intf_pins microblaze_0_axi_periph/M15_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M16_AXI [get_bd_intf_pins cds_core_b/s00_axi] [get_bd_intf_pins microblaze_0_axi_periph/M16_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M17_AXI [get_bd_intf_pins cds_core_c/s00_axi] [get_bd_intf_pins microblaze_0_axi_periph/M17_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M18_AXI [get_bd_intf_pins cds_core_d/s00_axi] [get_bd_intf_pins microblaze_0_axi_periph/M18_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M19_AXI [get_bd_intf_pins adc/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M19_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M20_AXI [get_bd_intf_pins microblaze_0_axi_periph/M20_AXI] [get_bd_intf_pins smart_buffer_0/s00_axi]

  # Create port connections
  connect_bd_net -net ADC_A_DATA_N_1 [get_bd_ports ADC_A_DATA_N] [get_bd_pins adc/ADC_A_DATA_N]
  connect_bd_net -net ADC_A_DATA_P_1 [get_bd_ports ADC_A_DATA_P] [get_bd_pins adc/ADC_A_DATA_P]
  connect_bd_net -net ADC_B_DATA_N_1 [get_bd_ports ADC_B_DATA_N] [get_bd_pins adc/ADC_B_DATA_N]
  connect_bd_net -net ADC_B_DATA_P_1 [get_bd_ports ADC_B_DATA_P] [get_bd_pins adc/ADC_B_DATA_P]
  connect_bd_net -net CCD_VDD_DIGPOT_SDO_1 [get_bd_ports CCD_VDD_DIGPOT_SDO] [get_bd_pins spi_ldo_mux/sdo1_in]
  connect_bd_net -net CCD_VDRAIN_DIGPOT_SDO_1 [get_bd_ports CCD_VDRAIN_DIGPOT_SDO] [get_bd_pins spi_ldo_mux/sdo0_in]
  connect_bd_net -net CCD_VR_DIGPOT_SDO_1 [get_bd_ports CCD_VR_DIGPOT_SDO] [get_bd_pins spi_ldo_mux/sdo2_in]
  connect_bd_net -net CCD_VSUB_DIGPOT_SDO_1 [get_bd_ports CCD_VSUB_DIGPOT_SDO] [get_bd_pins spi_ldo_mux/sdo3_in]
  connect_bd_net -net CPU_RESET_1 [get_bd_ports CPU_RESET] [get_bd_pins adc/CPU_RESET] [get_bd_pins eth_hie/CPU_RESET] [get_bd_pins sys_clk_hie/CPU_RESET] [get_bd_pins ublaze_hie/CPU_RESET]
  connect_bd_net -net DAC_SDO_1 [get_bd_ports DAC_SDO] [get_bd_pins spi_dac/io1_i]
  connect_bd_net -net ENET_RX0_1 [get_bd_ports ENET_RX0] [get_bd_pins eth_hie/ENET_RX0]
  connect_bd_net -net ENET_RX1_1 [get_bd_ports ENET_RX1] [get_bd_pins eth_hie/ENET_RX1]
  connect_bd_net -net ENET_RX2_1 [get_bd_ports ENET_RX2] [get_bd_pins eth_hie/ENET_RX2]
  connect_bd_net -net ENET_RX3_1 [get_bd_ports ENET_RX3] [get_bd_pins eth_hie/ENET_RX3]
  connect_bd_net -net ENET_RX4_1 [get_bd_ports ENET_RX4] [get_bd_pins eth_hie/ENET_RX4]
  connect_bd_net -net ENET_RX5_1 [get_bd_ports ENET_RX5] [get_bd_pins eth_hie/ENET_RX5]
  connect_bd_net -net ENET_RX6_1 [get_bd_ports ENET_RX6] [get_bd_pins eth_hie/ENET_RX6]
  connect_bd_net -net ENET_RX7_1 [get_bd_ports ENET_RX7] [get_bd_pins eth_hie/ENET_RX7]
  connect_bd_net -net ENET_RXCLK_1 [get_bd_ports ENET_RXCLK] [get_bd_pins eth_hie/ENET_RXCLK]
  connect_bd_net -net ENET_RXDV_1 [get_bd_ports ENET_RXDV] [get_bd_pins eth_hie/ENET_RXDV]
  connect_bd_net -net Net [get_bd_pins cds_core_a/p] [get_bd_pins cds_core_b/p] [get_bd_pins cds_core_c/p] [get_bd_pins cds_core_d/p] [get_bd_pins packet_header/in_0] [get_bd_pins sequencer_hie/out25]
  connect_bd_net -net TEL_DOUT_1 [get_bd_ports TEL_DOUT] [get_bd_pins spi_telemetry/io1_i]
  connect_bd_net -net USB_UART_TX_1 [get_bd_ports USB_UART_TX] [get_bd_pins uart/rx]
  connect_bd_net -net USER_CLK_1 [get_bd_ports USER_CLK] [get_bd_pins sys_clk_hie/USER_CLK]
  connect_bd_net -net VOLT_SW_DOUT_1 [get_bd_ports VOLT_SW_DOUT] [get_bd_pins spi_volt_sw/io1_i]
  connect_bd_net -net adc_ADC_A_PWRDOWNn [get_bd_ports ADC_A_PWRDOWNn] [get_bd_pins adc/ADC_A_PWRDOWNn]
  connect_bd_net -net adc_ADC_A_TEST_PTRN [get_bd_ports ADC_A_TEST_PTRN] [get_bd_pins adc/ADC_A_TEST_PTRN]
  connect_bd_net -net adc_ADC_B_CLK_N [get_bd_ports ADC_B_CLK_N] [get_bd_pins adc/ADC_B_CLK_N]
  connect_bd_net -net adc_ADC_B_CLK_P [get_bd_ports ADC_B_CLK_P] [get_bd_pins adc/ADC_B_CLK_P]
  connect_bd_net -net adc_ADC_B_CNVRT_N [get_bd_ports ADC_B_CNVRT_N] [get_bd_pins adc/ADC_B_CNVRT_N]
  connect_bd_net -net adc_ADC_B_CNVRT_P [get_bd_ports ADC_B_CNVRT_P] [get_bd_pins adc/ADC_B_CNVRT_P]
  connect_bd_net -net adc_ADC_B_PWRDOWNn [get_bd_ports ADC_B_PWRDOWNn] [get_bd_pins adc/ADC_B_PWRDOWNn]
  connect_bd_net -net adc_ADC_B_TEST_PTRN [get_bd_ports ADC_B_TEST_PTRN] [get_bd_pins adc/ADC_B_TEST_PTRN]
  connect_bd_net -net adc_dout [get_bd_pins adc/dout] [get_bd_pins cds_core_a/din] [get_bd_pins ila_0/probe1]
  connect_bd_net -net adc_dout1 [get_bd_pins adc/dout1] [get_bd_pins cds_core_b/din] [get_bd_pins ila_0/probe3]
  connect_bd_net -net adc_dout_strobe [get_bd_pins adc/dout_strobe] [get_bd_pins cds_core_a/din_ready] [get_bd_pins ila_0/probe0]
  connect_bd_net -net adc_dout_strobe1 [get_bd_pins adc/dout_strobe1] [get_bd_pins cds_core_b/din_ready] [get_bd_pins ila_0/probe2]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_ports USB_UART_RX] [get_bd_pins uart/tx]
  connect_bd_net -net cds_core_a_dout [get_bd_pins cds_core_a/dout] [get_bd_pins packer/pdata_a]
  connect_bd_net -net cds_core_a_dout_ready [get_bd_pins cds_core_a/dout_ready] [get_bd_pins packer/pready_a]
  connect_bd_net -net cds_core_b_dout [get_bd_pins cds_core_b/dout] [get_bd_pins packer/pdata_b]
  connect_bd_net -net cds_core_b_dout_ready [get_bd_pins cds_core_b/dout_ready] [get_bd_pins packer/pready_b]
  connect_bd_net -net cds_core_c_dout [get_bd_pins cds_core_c/dout] [get_bd_pins packer/pdata_c]
  connect_bd_net -net cds_core_c_dout_ready [get_bd_pins cds_core_c/dout_ready] [get_bd_pins packer/pready_c]
  connect_bd_net -net cds_core_d_dout [get_bd_pins cds_core_d/dout] [get_bd_pins packer/pdata_d]
  connect_bd_net -net cds_core_d_dout_ready [get_bd_pins cds_core_d/dout_ready] [get_bd_pins packer/pready_d]
  connect_bd_net -net clk_wiz_1_clk_out2 [get_bd_pins spi_dac/ext_spi_clk] [get_bd_pins spi_ldo/ext_spi_clk] [get_bd_pins spi_telemetry/ext_spi_clk] [get_bd_pins spi_volt_sw/ext_spi_clk] [get_bd_pins sys_clk_hie/clk_out2]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins sys_clk_hie/locked] [get_bd_pins ublaze_hie/dcm_locked]
  connect_bd_net -net eth_resync_0_ENET_GTXCLK [get_bd_ports ENET_GTXCLK] [get_bd_pins eth_hie/ENET_GTXCLK]
  connect_bd_net -net eth_resync_0_ENET_TX0 [get_bd_ports ENET_TX0] [get_bd_pins eth_hie/ENET_TX0]
  connect_bd_net -net eth_resync_0_ENET_TX1 [get_bd_ports ENET_TX1] [get_bd_pins eth_hie/ENET_TX1]
  connect_bd_net -net eth_resync_0_ENET_TX2 [get_bd_ports ENET_TX2] [get_bd_pins eth_hie/ENET_TX2]
  connect_bd_net -net eth_resync_0_ENET_TX3 [get_bd_ports ENET_TX3] [get_bd_pins eth_hie/ENET_TX3]
  connect_bd_net -net eth_resync_0_ENET_TX4 [get_bd_ports ENET_TX4] [get_bd_pins eth_hie/ENET_TX4]
  connect_bd_net -net eth_resync_0_ENET_TX5 [get_bd_ports ENET_TX5] [get_bd_pins eth_hie/ENET_TX5]
  connect_bd_net -net eth_resync_0_ENET_TX6 [get_bd_ports ENET_TX6] [get_bd_pins eth_hie/ENET_TX6]
  connect_bd_net -net eth_resync_0_ENET_TX7 [get_bd_ports ENET_TX7] [get_bd_pins eth_hie/ENET_TX7]
  connect_bd_net -net eth_resync_0_ENET_TXEN [get_bd_ports ENET_TXEN] [get_bd_pins eth_hie/ENET_TXEN]
  connect_bd_net -net eth_resync_0_ENET_TXER [get_bd_ports ENET_TXER] [get_bd_pins eth_hie/ENET_TXER]
  connect_bd_net -net gpio_bits_out0 [get_bd_ports CCD_VDRAIN_EN] [get_bd_pins gpio_ldo_bits/out0]
  connect_bd_net -net gpio_bits_out1 [get_bd_ports CCD_VDD_EN] [get_bd_pins gpio_ldo_bits/out1]
  connect_bd_net -net gpio_bits_out2 [get_bd_ports CCD_VR_EN] [get_bd_pins gpio_ldo_bits/out2]
  connect_bd_net -net gpio_bits_out3 [get_bd_ports CCD_VSUB_EN] [get_bd_pins gpio_ldo_bits/out3]
  connect_bd_net -net gpio_bits_out4 [get_bd_ports DIGPOT_RSTn] [get_bd_pins gpio_ldo_bits/out4]
  connect_bd_net -net gpio_dac_bits_out0 [get_bd_ports DAC_LDACn] [get_bd_pins gpio_dac_bits/out0]
  connect_bd_net -net gpio_dac_bits_out1 [get_bd_ports DAC_CLRn] [get_bd_pins gpio_dac_bits/out1]
  connect_bd_net -net gpio_dac_bits_out2 [get_bd_ports DAC_RESETn] [get_bd_pins gpio_dac_bits/out2]
  connect_bd_net -net gpio_dac_bits_out3 [get_bd_ports DAC_SW_EN] [get_bd_pins gpio_dac_bits/out3]
  connect_bd_net -net gpio_dac_gpio_io_o [get_bd_pins gpio_dac/gpio_io_o] [get_bd_pins gpio_dac_bits/vec_in]
  connect_bd_net -net gpio_ldo_gpio_io_o [get_bd_pins gpio_ldo/gpio_io_o] [get_bd_pins gpio_ldo_bits/vec_in]
  connect_bd_net -net gpio_leds_bits_out0 [get_bd_ports LED0] [get_bd_pins gpio_leds_bits/out0]
  connect_bd_net -net gpio_leds_bits_out1 [get_bd_ports LED1] [get_bd_pins gpio_leds_bits/out1]
  connect_bd_net -net gpio_leds_bits_out2 [get_bd_ports LED2] [get_bd_pins gpio_leds_bits/out2]
  connect_bd_net -net gpio_leds_bits_out3 [get_bd_ports LED3] [get_bd_pins gpio_leds_bits/out3]
  connect_bd_net -net gpio_leds_bits_out4 [get_bd_ports LED4] [get_bd_pins gpio_leds_bits/out4]
  connect_bd_net -net gpio_leds_bits_out5 [get_bd_ports LED5] [get_bd_pins gpio_leds_bits/out5]
  connect_bd_net -net gpio_telemetry_bits_out0 [get_bd_ports TEL_MUXEN0] [get_bd_pins gpio_telemetry_bits/out0]
  connect_bd_net -net gpio_telemetry_bits_out1 [get_bd_ports TEL_MUXEN1] [get_bd_pins gpio_telemetry_bits/out1]
  connect_bd_net -net gpio_telemetry_bits_out2 [get_bd_ports TEL_MUXEN2] [get_bd_pins gpio_telemetry_bits/out2]
  connect_bd_net -net gpio_telemetry_bits_out3 [get_bd_ports TEL_MUXA0] [get_bd_pins gpio_telemetry_bits/out3]
  connect_bd_net -net gpio_telemetry_bits_out4 [get_bd_ports TEL_MUXA1] [get_bd_pins gpio_telemetry_bits/out4]
  connect_bd_net -net gpio_telemetry_bits_out5 [get_bd_ports TEL_MUXA2] [get_bd_pins gpio_telemetry_bits/out5]
  connect_bd_net -net gpio_telemetry_gpio_io_o [get_bd_pins gpio_telemetry/gpio_io_o] [get_bd_pins gpio_telemetry_bits/vec_in]
  connect_bd_net -net gpio_volt_sw_gpio_io_o [get_bd_pins gpio_volt_sw/gpio_io_o] [get_bd_pins gpio_volt_sw_bits/vec_in]
  connect_bd_net -net leds_gpio_gpio_io_o [get_bd_pins gpio_leds_bits/vec_in] [get_bd_pins leds_gpio/gpio_io_o]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins adc/clk_100] [get_bd_pins cds_core_a/s00_axi_aclk] [get_bd_pins cds_core_b/s00_axi_aclk] [get_bd_pins cds_core_c/s00_axi_aclk] [get_bd_pins cds_core_d/s00_axi_aclk] [get_bd_pins eth_hie/s_axi_aclk] [get_bd_pins gpio_dac/s_axi_aclk] [get_bd_pins gpio_ldo/s_axi_aclk] [get_bd_pins gpio_telemetry/s_axi_aclk] [get_bd_pins gpio_volt_sw/s_axi_aclk] [get_bd_pins ila_0/clk] [get_bd_pins leds_gpio/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins microblaze_0_axi_periph/M07_ACLK] [get_bd_pins microblaze_0_axi_periph/M08_ACLK] [get_bd_pins microblaze_0_axi_periph/M09_ACLK] [get_bd_pins microblaze_0_axi_periph/M10_ACLK] [get_bd_pins microblaze_0_axi_periph/M11_ACLK] [get_bd_pins microblaze_0_axi_periph/M12_ACLK] [get_bd_pins microblaze_0_axi_periph/M13_ACLK] [get_bd_pins microblaze_0_axi_periph/M14_ACLK] [get_bd_pins microblaze_0_axi_periph/M15_ACLK] [get_bd_pins microblaze_0_axi_periph/M16_ACLK] [get_bd_pins microblaze_0_axi_periph/M17_ACLK] [get_bd_pins microblaze_0_axi_periph/M18_ACLK] [get_bd_pins microblaze_0_axi_periph/M19_ACLK] [get_bd_pins microblaze_0_axi_periph/M20_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins packer/s00_axi_aclk] [get_bd_pins sequencer_hie/s00_axi_aclk] [get_bd_pins smart_buffer_0/s00_axi_aclk] [get_bd_pins spi_dac/s_axi_aclk] [get_bd_pins spi_ldo/s_axi_aclk] [get_bd_pins spi_telemetry/s_axi_aclk] [get_bd_pins spi_volt_sw/s_axi_aclk] [get_bd_pins sys_clk_hie/clk_out1] [get_bd_pins uart/s_axi_aclk] [get_bd_pins ublaze_hie/Clk]
  connect_bd_net -net packer_0_dout [get_bd_pins eth_hie/b_data] [get_bd_pins packer/dout]
  connect_bd_net -net packer_0_dready [get_bd_pins eth_hie/b_we] [get_bd_pins packer/dready]
  connect_bd_net -net packer_header_vec2bit_0_dout [get_bd_pins packer/header] [get_bd_pins packet_header/dout]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins ublaze_hie/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins adc/s_axi_aresetn] [get_bd_pins cds_core_a/s00_axi_aresetn] [get_bd_pins cds_core_b/s00_axi_aresetn] [get_bd_pins cds_core_c/s00_axi_aresetn] [get_bd_pins cds_core_d/s00_axi_aresetn] [get_bd_pins eth_hie/s_axi_aresetn] [get_bd_pins gpio_dac/s_axi_aresetn] [get_bd_pins gpio_ldo/s_axi_aresetn] [get_bd_pins gpio_telemetry/s_axi_aresetn] [get_bd_pins gpio_volt_sw/s_axi_aresetn] [get_bd_pins leds_gpio/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins microblaze_0_axi_periph/M08_ARESETN] [get_bd_pins microblaze_0_axi_periph/M09_ARESETN] [get_bd_pins microblaze_0_axi_periph/M10_ARESETN] [get_bd_pins microblaze_0_axi_periph/M11_ARESETN] [get_bd_pins microblaze_0_axi_periph/M12_ARESETN] [get_bd_pins microblaze_0_axi_periph/M13_ARESETN] [get_bd_pins microblaze_0_axi_periph/M14_ARESETN] [get_bd_pins microblaze_0_axi_periph/M15_ARESETN] [get_bd_pins microblaze_0_axi_periph/M16_ARESETN] [get_bd_pins microblaze_0_axi_periph/M17_ARESETN] [get_bd_pins microblaze_0_axi_periph/M18_ARESETN] [get_bd_pins microblaze_0_axi_periph/M19_ARESETN] [get_bd_pins microblaze_0_axi_periph/M20_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins packer/s00_axi_aresetn] [get_bd_pins sequencer_hie/s00_axi_aresetn] [get_bd_pins smart_buffer_0/s00_axi_aresetn] [get_bd_pins spi_dac/s_axi_aresetn] [get_bd_pins spi_ldo/s_axi_aresetn] [get_bd_pins spi_telemetry/s_axi_aresetn] [get_bd_pins spi_volt_sw/s_axi_aresetn] [get_bd_pins uart/s_axi_aresetn] [get_bd_pins ublaze_hie/peripheral_aresetn]
  connect_bd_net -net sequencer_bits_out0 [get_bd_ports TGL_V1A] [get_bd_pins sequencer_hie/TGL_V1A]
  connect_bd_net -net sequencer_bits_out1 [get_bd_ports TGL_V1B] [get_bd_pins sequencer_hie/TGL_V1B]
  connect_bd_net -net sequencer_bits_out2 [get_bd_ports TGL_V2C] [get_bd_pins sequencer_hie/TGL_V2C]
  connect_bd_net -net sequencer_bits_out3 [get_bd_ports TGL_V3A] [get_bd_pins sequencer_hie/TGL_V3A]
  connect_bd_net -net sequencer_bits_out4 [get_bd_ports TGL_V3B] [get_bd_pins sequencer_hie/TGL_V3B]
  connect_bd_net -net sequencer_bits_out5 [get_bd_ports TGL_H1A] [get_bd_pins sequencer_hie/TGL_H1A]
  connect_bd_net -net sequencer_bits_out6 [get_bd_ports TGL_H1B] [get_bd_pins sequencer_hie/TGL_H1B]
  connect_bd_net -net sequencer_bits_out7 [get_bd_ports TGL_H2C] [get_bd_pins sequencer_hie/TGL_H2C]
  connect_bd_net -net sequencer_bits_out8 [get_bd_ports TGL_H3A] [get_bd_pins sequencer_hie/TGL_H3A]
  connect_bd_net -net sequencer_bits_out9 [get_bd_ports TGL_H3B] [get_bd_pins sequencer_hie/TGL_H3B]
  connect_bd_net -net sequencer_bits_out10 [get_bd_ports TGL_SWA] [get_bd_pins sequencer_hie/TGL_SWA]
  connect_bd_net -net sequencer_bits_out11 [get_bd_ports TGL_SWB] [get_bd_pins sequencer_hie/TGL_SWB]
  connect_bd_net -net sequencer_bits_out12 [get_bd_ports TGL_RGA] [get_bd_pins sequencer_hie/TGL_RGA]
  connect_bd_net -net sequencer_bits_out13 [get_bd_ports TGL_RGB] [get_bd_pins sequencer_hie/TGL_RGB]
  connect_bd_net -net sequencer_bits_out14 [get_bd_ports TGL_OGA] [get_bd_pins sequencer_hie/TGL_OGA]
  connect_bd_net -net sequencer_bits_out15 [get_bd_ports TGL_OGB] [get_bd_pins sequencer_hie/TGL_OGB]
  connect_bd_net -net sequencer_bits_out16 [get_bd_ports TGL_DGA] [get_bd_pins sequencer_hie/TGL_DGA]
  connect_bd_net -net sequencer_bits_out17 [get_bd_ports TGL_DGB] [get_bd_pins sequencer_hie/TGL_DGB]
  connect_bd_net -net sequencer_bits_out18 [get_bd_ports TGL_TGA] [get_bd_pins sequencer_hie/TGL_TGA]
  connect_bd_net -net sequencer_bits_out19 [get_bd_ports TGL_TGB] [get_bd_pins sequencer_hie/TGL_TGB]
  connect_bd_net -net sequencer_bits_out26 [get_bd_pins cds_core_a/s] [get_bd_pins cds_core_b/s] [get_bd_pins cds_core_c/s] [get_bd_pins cds_core_d/s] [get_bd_pins packet_header/in_1] [get_bd_pins sequencer_hie/out26]
  connect_bd_net -net serial_io_0_adc_clk_n [get_bd_ports ADC_A_CLK_N] [get_bd_pins adc/ADC_A_CLK_N]
  connect_bd_net -net serial_io_0_adc_clk_p [get_bd_ports ADC_A_CLK_P] [get_bd_pins adc/ADC_A_CLK_P]
  connect_bd_net -net serial_io_0_adc_cnvrt_n [get_bd_ports ADC_A_CNVRT_N] [get_bd_pins adc/ADC_A_CNVRT_N]
  connect_bd_net -net serial_io_0_adc_cnvrt_p [get_bd_ports ADC_A_CNVRT_P] [get_bd_pins adc/ADC_A_CNVRT_P]
  connect_bd_net -net smart_buffer_0_data_out [get_bd_pins packer/rdata_smart_bufffer] [get_bd_pins smart_buffer_0/data_out]
  connect_bd_net -net smart_buffer_0_ready_out [get_bd_pins packer/rready_smart_buffer] [get_bd_pins smart_buffer_0/ready_out]
  connect_bd_net -net spi_dac_io0_o [get_bd_ports DAC_SDI] [get_bd_pins spi_dac/io0_o]
  connect_bd_net -net spi_dac_sck_o [get_bd_ports DAC_SCLK] [get_bd_pins spi_dac/sck_o]
  connect_bd_net -net spi_dac_ss_o [get_bd_ports DAC_SYNCn] [get_bd_pins spi_dac/ss_o]
  connect_bd_net -net spi_ldo_io0_o [get_bd_ports DIGPOT_DIN] [get_bd_pins spi_ldo/io0_o]
  connect_bd_net -net spi_ldo_mux_sdo_out [get_bd_pins spi_ldo/io1_i] [get_bd_pins spi_ldo_mux/sdo_out]
  connect_bd_net -net spi_ldo_mux_ss0_out [get_bd_ports CCD_VDRAIN_DIGPOT_SYNCn] [get_bd_pins spi_ldo_mux/ss0_out]
  connect_bd_net -net spi_ldo_mux_ss1_out [get_bd_ports CCD_VDD_DIGPOT_SYNCn] [get_bd_pins spi_ldo_mux/ss1_out]
  connect_bd_net -net spi_ldo_mux_ss2_out [get_bd_ports CCD_VR_DIGPOT_SYNCn] [get_bd_pins spi_ldo_mux/ss2_out]
  connect_bd_net -net spi_ldo_mux_ss3_out [get_bd_ports CCD_VSUB_DIGPOT_SYNCn] [get_bd_pins spi_ldo_mux/ss3_out]
  connect_bd_net -net spi_ldo_sck_o [get_bd_ports DIGPOT_SCLK] [get_bd_pins spi_ldo/sck_o]
  connect_bd_net -net spi_ldo_ss_o [get_bd_pins spi_ldo/ss_o] [get_bd_pins spi_ldo_mux/ss_in]
  connect_bd_net -net spi_telemetry_io0_o [get_bd_ports TEL_DIN] [get_bd_pins spi_telemetry/io0_o]
  connect_bd_net -net spi_telemetry_sck_o [get_bd_ports TEL_SCLK] [get_bd_pins spi_telemetry/sck_o]
  connect_bd_net -net spi_telemetry_ss_o [get_bd_ports TEL_CSn] [get_bd_pins spi_telemetry/ss_o]
  connect_bd_net -net spi_volt_sw_io0_o [get_bd_ports VOLT_SW_DIN] [get_bd_pins spi_volt_sw/io0_o]
  connect_bd_net -net spi_volt_sw_sck_o [get_bd_ports VOLT_SW_CLK] [get_bd_pins spi_volt_sw/sck_o]
  connect_bd_net -net vec2bit_2_0_out0 [get_bd_ports VOLT_SW_CLR] [get_bd_pins gpio_volt_sw_bits/out0]
  connect_bd_net -net vec2bit_2_0_out1 [get_bd_ports VOLT_SW_LEn] [get_bd_pins gpio_volt_sw_bits/out1]
  connect_bd_net -net xlconstant_0_dout [get_bd_ports V_100VP_SYNC] [get_bd_ports V_15VN_SYNC] [get_bd_ports V_15VP_SYNC] [get_bd_ports V_30VN_SYNC] [get_bd_ports V_5V5P_SYNC] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_0_dout1 [get_bd_pins eth_hie/enb] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_ports ADC_A_TWO_LANES] [get_bd_ports ADC_B_TWO_LANES] [get_bd_pins xlconstant_2/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0x41200000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs ublaze_hie/axi_intc_0/S_AXI/Reg] SEG_axi_intc_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x40600000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs uart/S_AXI/Reg] SEG_axi_uartlite_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x44A60000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs cds_core_a/s00_axi/reg0] SEG_cds_core_a_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0x44A70000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs cds_core_b/s00_axi/reg0] SEG_cds_core_b_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0x44A80000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs cds_core_c/s00_axi/reg0] SEG_cds_core_c_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0x44A90000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs cds_core_d/s00_axi/reg0] SEG_cds_core_d_reg0
  create_bd_addr_seg -range 0x00040000 -offset 0x00000000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs ublaze_hie/microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00010000 -offset 0x40060000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs adc/gpio_adc/S_AXI/Reg] SEG_gpio_adc_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x40000000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs gpio_dac/S_AXI/Reg] SEG_gpio_dac_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x40050000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs eth_hie/gpio_eth/S_AXI/Reg] SEG_gpio_eth_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x40010000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs gpio_ldo/S_AXI/Reg] SEG_gpio_ldo_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x40020000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs gpio_telemetry/S_AXI/Reg] SEG_gpio_telemetry_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x40030000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs gpio_volt_sw/S_AXI/Reg] SEG_gpio_volt_sw_Reg
  create_bd_addr_seg -range 0x00040000 -offset 0x00000000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Instruction] [get_bd_addr_segs ublaze_hie/microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00001000 -offset 0x40040000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs leds_gpio/S_AXI/Reg] SEG_leds_gpio_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x44A50000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs packer/s00_axi/reg0] SEG_packer_0_reg0
  create_bd_addr_seg -range 0x00002000 -offset 0xC0000000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs eth_hie/ram_eth_ctrl/S_AXI/Mem0] SEG_ram_eth_ctrl_Mem0
  create_bd_addr_seg -range 0x00001000 -offset 0x44A40000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs sequencer_hie/sequencer/s00_axi/reg0] SEG_sequencer_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x44AA0000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs smart_buffer_0/s00_axi/reg0] SEG_smart_buffer_0_reg0
  create_bd_addr_seg -range 0x00001000 -offset 0x44A00000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs spi_dac/AXI_LITE/Reg] SEG_spi_dac_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x44A10000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs spi_ldo/AXI_LITE/Reg] SEG_spi_ldo_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x44A20000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs spi_telemetry/AXI_LITE/Reg] SEG_spi_telemetry_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0x44A30000 [get_bd_addr_spaces ublaze_hie/microblaze_0/Data] [get_bd_addr_segs spi_volt_sw/AXI_LITE/Reg] SEG_spi_volt_sw_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   ExpandedHierarchyInLayout: "",
   guistr: "# # String gsaved with Nlview 6.8.5  2018-01-30 bk=1.4354 VDI=40 GEI=35 GUI=JA:1.6 non-TLS
#  -string -flagsOSRD
preplace port TGL_H1B -pg 1 -y 1500 -defaultsOSRD
preplace port CCD_VDD_DIGPOT_SDO -pg 1 -y 4620 -defaultsOSRD -right
preplace port TEL_MUXA0 -pg 1 -y 3560 -defaultsOSRD
preplace port TEL_MUXA1 -pg 1 -y 3670 -defaultsOSRD
preplace port USB_UART_TX -pg 1 -y 360 -defaultsOSRD
preplace port TEL_MUXA2 -pg 1 -y 3600 -defaultsOSRD
preplace port CCD_VR_DIGPOT_SDO -pg 1 -y 4660 -defaultsOSRD -right
preplace port CCD_VR_DIGPOT_SYNCn -pg 1 -y 4520 -defaultsOSRD
preplace port CCD_VDD_EN -pg 1 -y 2940 -defaultsOSRD
preplace port DIGPOT_DIN -pg 1 -y 320 -defaultsOSRD
preplace port TGL_DGA -pg 1 -y 1440 -defaultsOSRD
preplace port DIGPOT_SCLK -pg 1 -y 360 -defaultsOSRD
preplace port DAC_SDI -pg 1 -y 260 -defaultsOSRD
preplace port TGL_TGA -pg 1 -y 1700 -defaultsOSRD
preplace port TGL_DGB -pg 1 -y 1460 -defaultsOSRD
preplace port ADC_B_TEST_PTRN -pg 1 -y -2440 -defaultsOSRD -left
preplace port TGL_TGB -pg 1 -y 1720 -defaultsOSRD
preplace port TGL_OGA -pg 1 -y 1580 -defaultsOSRD
preplace port TGL_OGB -pg 1 -y 1600 -defaultsOSRD
preplace port DAC_CLRn -pg 1 -y 4250 -defaultsOSRD
preplace port ENET_RXDV -pg 1 -y 1900 -defaultsOSRD -right
preplace port USB_UART_RX -pg 1 -y 1300 -defaultsOSRD
preplace port CCD_VR_EN -pg 1 -y 2960 -defaultsOSRD
preplace port ENET_RX0 -pg 1 -y 1920 -defaultsOSRD -right
preplace port CCD_VDD_DIGPOT_SYNCn -pg 1 -y 4470 -defaultsOSRD
preplace port TGL_RGA -pg 1 -y 1620 -defaultsOSRD
preplace port DAC_SDO -pg 1 -y 120 -defaultsOSRD
preplace port ENET_RX1 -pg 1 -y 1940 -defaultsOSRD -right
preplace port TGL_RGB -pg 1 -y 1640 -defaultsOSRD
preplace port ENET_RX2 -pg 1 -y 1960 -defaultsOSRD -right
preplace port VOLT_SW_CLK -pg 1 -y 5210 -defaultsOSRD
preplace port TGL_H2C -pg 1 -y 1520 -defaultsOSRD
preplace port ENET_RX3 -pg 1 -y 1980 -defaultsOSRD -right
preplace port TGL_V2C -pg 1 -y 1780 -defaultsOSRD
preplace port ENET_RX4 -pg 1 -y 2000 -defaultsOSRD -right
preplace port TGL_SWA -pg 1 -y 1660 -defaultsOSRD
preplace port TEL_SCLK -pg 1 -y 880 -defaultsOSRD
preplace port ENET_RX5 -pg 1 -y 2020 -defaultsOSRD -right
preplace port ENET_RXCLK -pg 1 -y 1880 -defaultsOSRD -right
preplace port TGL_SWB -pg 1 -y 1680 -defaultsOSRD
preplace port TEL_MUXEN0 -pg 1 -y 3620 -defaultsOSRD
preplace port ENET_RX6 -pg 1 -y 2040 -defaultsOSRD -right
preplace port DIGPOT_RSTn -pg 1 -y 3000 -defaultsOSRD
preplace port TEL_MUXEN1 -pg 1 -y 3580 -defaultsOSRD
preplace port TEL_MUXEN2 -pg 1 -y 3720 -defaultsOSRD
preplace port ENET_RX7 -pg 1 -y 2060 -defaultsOSRD -right
preplace port ADC_B_PWRDOWNn -pg 1 -y -2460 -defaultsOSRD -left
preplace port ENET_TXEN -pg 1 -y 2180 -defaultsOSRD
preplace port VOLT_SW_CLR -pg 1 -y 3990 -defaultsOSRD
preplace port VOLT_SW_DIN -pg 1 -y 5160 -defaultsOSRD
preplace port ENET_TXER -pg 1 -y 2200 -defaultsOSRD
preplace port CCD_VSUB_EN -pg 1 -y 2980 -defaultsOSRD
preplace port LED0 -pg 1 -y 3210 -defaultsOSRD
preplace port LED1 -pg 1 -y 3230 -defaultsOSRD
preplace port LED2 -pg 1 -y 3250 -defaultsOSRD
preplace port ADC_A_PWRDOWNn -pg 1 -y -2770 -defaultsOSRD -left
preplace port TEL_DIN -pg 1 -y 740 -defaultsOSRD
preplace port CCD_VSUB_DIGPOT_SYNCn -pg 1 -y 4550 -defaultsOSRD
preplace port LED3 -pg 1 -y 3270 -defaultsOSRD
preplace port TEL_DOUT -pg 1 -y 340 -defaultsOSRD
preplace port LED4 -pg 1 -y 3330 -defaultsOSRD
preplace port TGL_H3A -pg 1 -y 1540 -defaultsOSRD
preplace port CCD_VDRAIN_DIGPOT_SDO -pg 1 -y 4640 -defaultsOSRD -right
preplace port LED5 -pg 1 -y 3360 -defaultsOSRD
preplace port TGL_V3A -pg 1 -y 1800 -defaultsOSRD
preplace port TGL_H3B -pg 1 -y 1560 -defaultsOSRD
preplace port TGL_V3B -pg 1 -y 1820 -defaultsOSRD
preplace port VOLT_SW_DOUT -pg 1 -y 5190 -defaultsOSRD -right
preplace port VOLT_SW_LEn -pg 1 -y 4030 -defaultsOSRD
preplace port DAC_SCLK -pg 1 -y 240 -defaultsOSRD
preplace port ENET_TX0 -pg 1 -y 2220 -defaultsOSRD
preplace port USER_CLK -pg 1 -y 380 -defaultsOSRD
preplace port ENET_TX1 -pg 1 -y 2240 -defaultsOSRD
preplace port ENET_GTXCLK -pg 1 -y 2160 -defaultsOSRD
preplace port ADC_A_TEST_PTRN -pg 1 -y -2750 -defaultsOSRD -left
preplace port CCD_VDRAIN_DIGPOT_SYNCn -pg 1 -y 4490 -defaultsOSRD
preplace port ENET_TX2 -pg 1 -y 2260 -defaultsOSRD
preplace port CPU_RESET -pg 1 -y 100 -defaultsOSRD
preplace port ENET_TX3 -pg 1 -y 2280 -defaultsOSRD
preplace port ENET_TX4 -pg 1 -y 2300 -defaultsOSRD
preplace port DAC_SW_EN -pg 1 -y 4350 -defaultsOSRD
preplace port ENET_TX5 -pg 1 -y 2320 -defaultsOSRD
preplace port ENET_TX6 -pg 1 -y 2340 -defaultsOSRD
preplace port TGL_V1A -pg 1 -y 1740 -defaultsOSRD
preplace port ENET_TX7 -pg 1 -y 2360 -defaultsOSRD
preplace port CCD_VSUB_DIGPOT_SDO -pg 1 -y 4680 -defaultsOSRD -right
preplace port CCD_VDRAIN_EN -pg 1 -y 2920 -defaultsOSRD
preplace port TGL_V1B -pg 1 -y 1760 -defaultsOSRD
preplace port DAC_LDACn -pg 1 -y 4270 -defaultsOSRD
preplace port DAC_RESETn -pg 1 -y 4290 -defaultsOSRD
preplace port TGL_H1A -pg 1 -y 1480 -defaultsOSRD
preplace portBus ADC_B_CLK_N -pg 1 -y -2360 -defaultsOSRD -left
preplace portBus V_5V5P_SYNC -pg 1 -y -680 -defaultsOSRD
preplace portBus TEL_CSn -pg 1 -y 720 -defaultsOSRD
preplace portBus ADC_A_CLK_P -pg 1 -y -2680 -defaultsOSRD -left
preplace portBus V_30VN_SYNC -pg 1 -y -620 -defaultsOSRD
preplace portBus ADC_B_CLK_P -pg 1 -y -2380 -defaultsOSRD -left
preplace portBus V_100VP_SYNC -pg 1 -y -600 -defaultsOSRD
preplace portBus ADC_A_DATA_N -pg 1 -y -2600 -defaultsOSRD
preplace portBus ADC_A_CNVRT_N -pg 1 -y -2660 -defaultsOSRD -left
preplace portBus V_15VN_SYNC -pg 1 -y -660 -defaultsOSRD
preplace portBus ADC_B_CNVRT_N -pg 1 -y -2330 -defaultsOSRD -left
preplace portBus ADC_A_DATA_P -pg 1 -y -2580 -defaultsOSRD
preplace portBus ADC_A_CNVRT_P -pg 1 -y -2640 -defaultsOSRD -left
preplace portBus DAC_SYNCn -pg 1 -y 300 -defaultsOSRD
preplace portBus ADC_B_DATA_N -pg 1 -y -2250 -defaultsOSRD
preplace portBus ADC_B_CNVRT_P -pg 1 -y -2310 -defaultsOSRD -left
preplace portBus ADC_A_TWO_LANES -pg 1 -y -2730 -defaultsOSRD -left
preplace portBus V_15VP_SYNC -pg 1 -y -640 -defaultsOSRD
preplace portBus ADC_B_DATA_P -pg 1 -y -2270 -defaultsOSRD
preplace portBus ADC_B_TWO_LANES -pg 1 -y -2920 -defaultsOSRD
preplace portBus ADC_A_CLK_N -pg 1 -y -2700 -defaultsOSRD -left
preplace inst smart_buffer_0 -pg 1 -lvl 4 -y -2520 -defaultsOSRD
preplace inst adc|adc_bits -pg 1 -lvl 2 -y -2330 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 8 -y -630 -defaultsOSRD
preplace inst gpio_volt_sw_bits -pg 1 -lvl 7 -y 4020 -defaultsOSRD
preplace inst gpio_dac_bits -pg 1 -lvl 7 -y 4320 -defaultsOSRD
preplace inst eth_hie -pg 1 -lvl 6 -y 2330 -defaultsOSRD
preplace inst cds_core_a -pg 1 -lvl 4 -y -1880 -defaultsOSRD
preplace inst xlconstant_1 -pg 1 -lvl 3 -y 1500 -defaultsOSRD
preplace inst spi_ldo_mux -pg 1 -lvl 7 -y 4540 -defaultsOSRD
preplace inst cds_core_b -pg 1 -lvl 4 -y -1650 -defaultsOSRD
preplace inst xlconstant_2 -pg 1 -lvl 1 -y -2860 -defaultsOSRD
preplace inst microblaze_0_axi_periph -pg 1 -lvl 4 -y 2500 -defaultsOSRD
preplace inst gpio_dac -pg 1 -lvl 6 -y 4270 -defaultsOSRD
preplace inst cds_core_c -pg 1 -lvl 4 -y -1430 -defaultsOSRD
preplace inst adc|gpio_adc -pg 1 -lvl 1 -y -2700 -defaultsOSRD
preplace inst sys_clk_hie -pg 1 -lvl 2 -y 2684 -defaultsOSRD
preplace inst spi_ldo -pg 1 -lvl 6 -y 4620 -defaultsOSRD
preplace inst packet_header -pg 1 -lvl 4 -y -1010 -defaultsOSRD
preplace inst leds_gpio -pg 1 -lvl 6 -y 3350 -defaultsOSRD
preplace inst gpio_telemetry -pg 1 -lvl 6 -y 3710 -defaultsOSRD
preplace inst gpio_leds_bits -pg 1 -lvl 7 -y 3320 -defaultsOSRD
preplace inst cds_core_d -pg 1 -lvl 4 -y -1200 -defaultsOSRD
preplace inst uart -pg 1 -lvl 2 -y 1114 -defaultsOSRD
preplace inst ublaze_hie -pg 1 -lvl 3 -y 2140 -defaultsOSRD
preplace inst gpio_ldo_bits -pg 1 -lvl 7 -y 2960 -defaultsOSRD
preplace inst ila_0 -pg 1 -lvl 3 -y -2130 -defaultsOSRD
preplace inst gpio_volt_sw -pg 1 -lvl 6 -y 4070 -defaultsOSRD
preplace inst adc|serial_io_0 -pg 1 -lvl 3 -y -2320 -defaultsOSRD
preplace inst spi_telemetry -pg 1 -lvl 6 -y 4890 -defaultsOSRD
preplace inst gpio_telemetry_bits -pg 1 -lvl 7 -y 3710 -defaultsOSRD
preplace inst gpio_ldo -pg 1 -lvl 6 -y 2930 -defaultsOSRD
preplace inst packer -pg 1 -lvl 5 -y -1350 -defaultsOSRD
preplace inst sequencer_hie -pg 1 -lvl 6 -y 1560 -defaultsOSRD
preplace inst adc|adc_a -pg 1 -lvl 3 -y -2580 -defaultsOSRD
preplace inst adc -pg 1 -lvl 2 -y -2680 -defaultsOSRD
preplace inst spi_volt_sw -pg 1 -lvl 6 -y 5170 -defaultsOSRD
preplace inst spi_dac -pg 1 -lvl 3 -y 1090 -defaultsOSRD
preplace netloc microblaze_0_axi_periph_M16_AXI 1 3 2 1980 -2020 2450
preplace netloc microblaze_0_axi_periph_M02_AXI 1 4 2 NJ 2340 2970
preplace netloc spi_volt_sw_sck_o 1 6 3 NJ 5190 NJ 5190 5530J
preplace netloc sequencer_bits_out16 1 6 3 NJ 1310 NJ 1310 5710J
preplace netloc gpio_leds_bits_out4 1 7 2 4070J 3330 NJ
preplace netloc gpio_telemetry_bits_out0 1 7 2 4050J 3620 NJ
preplace netloc cds_core_b_dout_ready 1 4 1 2530
preplace netloc adc|serial_io_0_adc_cnvrt_n1 1 3 1 N
preplace netloc spi_ldo_mux_sdo_out 1 6 2 3560 4440 4040
preplace netloc sequencer_bits_out17 1 6 3 NJ 1330 NJ 1330 5700J
preplace netloc gpio_telemetry_bits_out1 1 7 2 4040J 3580 NJ
preplace netloc ENET_RX3_1 1 5 4 3080 1980 N 1980 N 1980 N
preplace netloc gpio_leds_bits_out5 1 7 2 4050J 3360 NJ
preplace netloc sequencer_bits_out18 1 6 3 NJ 1570 NJ 1570 5580J
preplace netloc gpio_telemetry_bits_out2 1 7 2 NJ 3700 5620J
preplace netloc microblaze_0_axi_periph_M03_AXI 1 4 2 NJ 2360 2980
preplace netloc sequencer_bits_out19 1 6 3 NJ 1590 NJ 1590 5570J
preplace netloc packer_0_dout 1 5 1 3010J
preplace netloc gpio_telemetry_bits_out3 1 7 2 4030J 3560 NJ
preplace netloc eth_resync_0_ENET_TX0 1 6 3 3420 2220 N 2220 N
preplace netloc adc|serial_io_0_adc_clk_p1 1 3 1 1170
preplace netloc microblaze_0_axi_periph_M01_AXI 1 2 3 1510 1440 1910 1960 2390J
preplace netloc gpio_telemetry_bits_out4 1 7 2 4070J 3670 NJ
preplace netloc eth_resync_0_ENET_TX1 1 6 3 3430 2240 N 2240 N
preplace netloc adc|ADC_A_DATA_N_1 1 0 3 NJ -2600 NJ -2600 N
preplace netloc adc_dout1 1 2 2 1470 -1630 N
preplace netloc adc_ADC_B_CLK_N 1 0 3 -220J -2970 NJ -2970 1440
preplace netloc adc_ADC_B_TEST_PTRN 1 0 3 -290J -3000 N -3000 1460
preplace netloc gpio_telemetry_bits_out5 1 7 2 4060J 3600 NJ
preplace netloc eth_resync_0_ENET_TX2 1 6 3 3440 2260 N 2260 N
preplace netloc CCD_VSUB_DIGPOT_SDO_1 1 6 3 3600 4680 N 4680 N
preplace netloc eth_resync_0_ENET_TX3 1 6 3 3470 2280 N 2280 N
preplace netloc axi_uartlite_0_tx 1 2 7 1390 1250 NJ 1250 NJ 1250 NJ 1250 NJ 1250 NJ 1250 5710J
preplace netloc adc|adc_bits_out0 1 2 1 820
preplace netloc microblaze_0_axi_periph_M00_AXI 1 1 4 10J 1204 NJ 1204 NJ 1204 2400
preplace netloc adc_ADC_B_CLK_P 1 0 3 -240J -2980 NJ -2980 1450
preplace netloc eth_resync_0_ENET_TX4 1 6 3 3500 2300 N 2300 N
preplace netloc adc|adc_bits_out1 1 2 2 810 -2700 1190J
preplace netloc adc|adc_a_dout 1 3 1 N
preplace netloc xlconstant_0_dout1 1 3 3 1900J 1970 N 1970 2990
preplace netloc ENET_RX1_1 1 5 4 3060 1940 N 1940 N 1940 N
preplace netloc eth_resync_0_ENET_TX5 1 6 3 3510 2320 N 2320 N
preplace netloc adc|adc_bits_out2 1 2 1 790
preplace netloc adc|gpio_adc_gpio_io_o 1 1 1 560
preplace netloc microblaze_0_axi_periph_M17_AXI 1 3 2 2000 -1080 2440
preplace netloc microblaze_0_M_AXI_DP 1 3 1 1900
preplace netloc smart_buffer_0_data_out 1 4 1 2570
preplace netloc eth_resync_0_ENET_TX6 1 6 3 3530 2340 N 2340 N
preplace netloc adc|serial_io_0_dout_strobe 1 3 1 N
preplace netloc adc|adc_bits_out3 1 2 2 830 -2710 1200J
preplace netloc serial_io_0_adc_clk_n 1 0 3 -300 -2960 N -2960 1420
preplace netloc eth_resync_0_ENET_TX7 1 6 3 3610 2360 N 2360 N
preplace netloc cds_core_d_dout 1 4 1 2490
preplace netloc adc|adc_bits_out4 1 2 1 870
preplace netloc adc|ADC_A_DATA_P_1 1 0 3 NJ -2580 NJ -2580 N
preplace netloc ADC_B_DATA_P_1 1 0 2 NJ -2270 -50
preplace netloc adc_ADC_B_CNVRT_N 1 0 3 -280J -3020 NJ -3020 1500
preplace netloc leds_gpio_gpio_io_o 1 6 1 3610
preplace netloc adc|Conn1 1 0 1 N
preplace netloc adc|adc_bits_out5 1 2 2 860 -2460 N
preplace netloc smart_buffer_0_ready_out 1 4 1 2580
preplace netloc serial_io_0_adc_clk_p 1 0 3 -270 -2950 N -2950 1410
preplace netloc adc|adc_bits_out6 1 2 1 790
preplace netloc microblaze_0_axi_periph_M14_AXI 1 4 1 2540
preplace netloc adc_ADC_B_CNVRT_P 1 0 3 -250J -3010 NJ -3010 1490
preplace netloc ENET_RX4_1 1 5 4 3090 2000 N 2000 N 2000 N
preplace netloc gpio_bits_out0 1 7 2 NJ 2920 NJ
preplace netloc adc|adc_bits_out7 1 2 2 820 -2440 NJ
preplace netloc spi_ldo_ss_o 1 6 1 3570
preplace netloc spi_ldo_sck_o 1 6 3 3480J 360 NJ 360 NJ
preplace netloc gpio_bits_out1 1 7 2 NJ 2940 NJ
preplace netloc microblaze_0_axi_periph_M12_AXI 1 4 2 2570 2160 N
preplace netloc microblaze_0_axi_periph_M08_AXI 1 4 2 N 2460 2910
preplace netloc spi_volt_sw_io0_o 1 6 3 NJ 5150 NJ 5150 5620J
preplace netloc packer_header_vec2bit_0_dout 1 4 1 2530
preplace netloc gpio_bits_out2 1 7 2 NJ 2960 NJ
preplace netloc ENET_RX6_1 1 5 4 3110 2040 N 2040 N 2040 N
preplace netloc ENET_RXCLK_1 1 5 4 3030 1880 N 1880 N 1880 N
preplace netloc adc_ADC_B_PWRDOWNn 1 0 3 -310J -3040 N -3040 1480
preplace netloc sequencer_bits_out0 1 6 3 NJ 1610 NJ 1610 5560J
preplace netloc CPU_RESET_1 1 0 6 NJ 100 -40 1980 1450 1980 NJ 1980 2490J 1990 3000
preplace netloc gpio_bits_out3 1 7 2 NJ 2980 NJ
preplace netloc sequencer_bits_out1 1 6 3 NJ 1630 NJ 1630 5550J
preplace netloc gpio_ldo_gpio_io_o 1 6 1 3500J
preplace netloc gpio_bits_out4 1 7 2 NJ 3000 NJ
preplace netloc USER_CLK_1 1 0 2 N 380 -50
preplace netloc microblaze_0_axi_periph_M13_AXI 1 4 2 2560 1980 2970
preplace netloc adc_dout 1 2 2 1510 -1860 N
preplace netloc sequencer_bits_out2 1 6 3 NJ 1650 NJ 1650 5540J
preplace netloc adc|serial_io_0_adc_clk_n 1 3 1 1140
preplace netloc microblaze_0_axi_periph_M18_AXI 1 3 2 1990 -2010 2460
preplace netloc sequencer_bits_out3 1 6 3 NJ 1670 NJ 1670 5530J
preplace netloc sequencer_bits_out4 1 6 3 NJ 1690 NJ 1690 5520J
preplace netloc gpio_volt_sw_gpio_io_o 1 6 1 3610
preplace netloc adc|serial_io_0_adc_clk_p 1 3 1 1150
preplace netloc sequencer_bits_out5 1 6 3 NJ 1350 NJ 1350 5690J
preplace netloc microblaze_0_Clk 1 1 5 0 -2100 1430 -1620 1930 -2030 2510 -1070 2950
preplace netloc adc_dout_strobe1 1 2 2 1490 -1870 1950
preplace netloc sequencer_bits_out6 1 6 3 NJ 1370 NJ 1370 5680J
preplace netloc cds_core_c_dout 1 4 1 2480
preplace netloc adc|ADC_B_DATA_P_1 1 0 3 280J -2560 NJ -2560 800
preplace netloc adc|serial_io_0_adc_cnvrt_n 1 3 1 1160
preplace netloc xlconstant_2_dout 1 0 9 -260 -2920 -50 -2920 N -2920 N -2920 N -2920 N -2920 N -2920 N -2920 N
preplace netloc sequencer_bits_out7 1 6 3 NJ 1390 NJ 1390 5670J
preplace netloc gpio_telemetry_gpio_io_o 1 6 1 3610
preplace netloc TEL_DOUT_1 1 0 7 NJ 340 N 340 N 340 N 340 N 340 N 340 3400
preplace netloc ENET_RX5_1 1 5 4 3100 2020 N 2020 N 2020 N
preplace netloc cds_core_d_dout_ready 1 4 1 2480
preplace netloc adc|serial_io_0_dout 1 3 1 1170
preplace netloc adc_ADC_A_TEST_PTRN 1 0 3 -320 -2990 N -2990 1430
preplace netloc spi_dac_ss_o 1 3 6 1980 300 NJ 300 NJ 300 NJ 300 NJ 300 NJ
preplace netloc sequencer_bits_out8 1 6 3 NJ 1410 NJ 1410 5660J
preplace netloc adc|serial_io_0_adc_cnvrt_p 1 3 1 1170
preplace netloc spi_telemetry_sck_o 1 6 3 3550J 880 NJ 880 NJ
preplace netloc sequencer_bits_out9 1 6 3 NJ 1430 NJ 1430 5650J
preplace netloc cds_core_a_dout 1 4 1 2550
preplace netloc cds_core_c_dout_ready 1 4 1 2490
preplace netloc spi_ldo_io0_o 1 6 3 3450J 320 NJ 320 NJ
preplace netloc spi_dac_sck_o 1 3 6 1910 240 NJ 240 NJ 240 NJ 240 NJ 240 NJ
preplace netloc packer_0_dready 1 5 1 3020J
preplace netloc eth_resync_0_ENET_GTXCLK 1 6 3 3410 2160 N 2160 N
preplace netloc Net 1 3 4 1960 -2040 N -2040 N -2040 3420
preplace netloc CCD_VDD_DIGPOT_SDO_1 1 6 3 3610 4640 4050 4620 N
preplace netloc eth_resync_0_ENET_TXEN 1 6 3 3460 2180 N 2180 N
preplace netloc adc|ADC_B_DATA_N_1 1 0 3 NJ -2500 570J -2550 840
preplace netloc microblaze_0_axi_periph_M11_AXI 1 4 2 2580J 2330 2970
preplace netloc microblaze_0_axi_periph_M10_AXI 1 4 2 N 2500 2890
preplace netloc serial_io_0_adc_cnvrt_n 1 0 3 -230 -2940 N -2940 1400
preplace netloc clk_wiz_1_locked 1 2 1 1520
preplace netloc ENET_RX0_1 1 5 4 3050 1920 N 1920 N 1920 N
preplace netloc microblaze_0_axi_periph_M09_AXI 1 4 2 N 2480 2900
preplace netloc adc_dout_strobe 1 2 2 1520 -1880 N
preplace netloc sequencer_bits_out26 1 3 4 1970 -940 N -940 N -940 3410
preplace netloc CCD_VDRAIN_DIGPOT_SDO_1 1 6 3 3580 4650 N 4650 5610
preplace netloc serial_io_0_adc_cnvrt_p 1 0 3 -210 -2930 N -2930 1390
preplace netloc spi_ldo_mux_ss0_out 1 7 2 4070J 4490 NJ
preplace netloc gpio_dac_gpio_io_o 1 6 1 3500
preplace netloc ENET_RX7_1 1 5 4 3120 2060 N 2060 N 2060 N
preplace netloc eth_resync_0_ENET_TXER 1 6 3 3490 2200 N 2200 N
preplace netloc adc|s_axi_aresetn_1 1 0 1 270
preplace netloc vec2bit_2_0_out0 1 7 2 4050 3990 N
preplace netloc spi_telemetry_io0_o 1 6 3 3520J 740 NJ 740 NJ
preplace netloc rst_clk_wiz_1_100M_interconnect_aresetn 1 3 1 1910
preplace netloc ENET_RXDV_1 1 5 4 3040 1900 N 1900 N 1900 N
preplace netloc adc|CPU_RESET_1 1 0 3 NJ -2540 NJ -2540 850
preplace netloc microblaze_0_axi_periph_M20_AXI 1 3 2 2000 -2730 2470
preplace netloc microblaze_0_axi_periph_M06_AXI 1 4 2 N 2420 2940
preplace netloc ADC_A_DATA_P_1 1 0 2 N -2580 N
preplace netloc vec2bit_2_0_out1 1 7 2 N 4030 N
preplace netloc clk_wiz_1_clk_out2 1 2 4 1470 3020 N 3020 N 3020 2880
preplace netloc DAC_SDO_1 1 0 4 NJ 120 NJ 120 NJ 120 1900
preplace netloc adc|serial_io_0_adc_clk_n1 1 3 1 N
preplace netloc spi_ldo_mux_ss2_out 1 7 2 4070J 4520 NJ
preplace netloc spi_dac_io0_o 1 3 6 1920 260 NJ 260 NJ 260 NJ 260 NJ 260 NJ
preplace netloc VOLT_SW_DOUT_1 1 6 3 N 5170 N 5170 5650
preplace netloc microblaze_0_axi_periph_M04_AXI 1 4 2 N 2380 2960
preplace netloc ADC_B_DATA_N_1 1 0 2 NJ -2250 -30
preplace netloc adc|serial_io_0_adc_cnvrt_p1 1 3 1 N
preplace netloc adc_ADC_A_PWRDOWNn 1 0 3 -330 -3030 N -3030 1470
preplace netloc ADC_A_DATA_N_1 1 0 2 N -2600 N
preplace netloc sequencer_bits_out10 1 6 3 NJ 1530 NJ 1530 5600J
preplace netloc CCD_VR_DIGPOT_SDO_1 1 6 3 3590 4660 N 4660 N
preplace netloc microblaze_0_axi_periph_M07_AXI 1 2 3 1510 1214 NJ 1214 2410
preplace netloc xlconstant_0_dout 1 8 1 5710
preplace netloc spi_telemetry_ss_o 1 6 3 3540J 720 NJ 720 NJ
preplace netloc spi_ldo_mux_ss3_out 1 7 2 4060J 4550 NJ
preplace netloc sequencer_bits_out11 1 6 3 NJ 1550 NJ 1550 5590J
preplace netloc microblaze_0_axi_periph_M19_AXI 1 1 4 -20 1224 N 1224 N 1224 2420
preplace netloc sequencer_bits_out12 1 6 3 NJ 1490 NJ 1490 5620J
preplace netloc ENET_RX2_1 1 5 4 3070 1960 N 1960 N 1960 N
preplace netloc gpio_dac_bits_out0 1 7 2 4060 4270 N
preplace netloc gpio_leds_bits_out0 1 7 2 4030J 3210 NJ
preplace netloc adc|adc_a_dout_strobe 1 3 1 1180
preplace netloc sequencer_bits_out13 1 6 3 NJ 1510 NJ 1510 5610J
preplace netloc cds_core_b_dout 1 4 1 2500
preplace netloc gpio_dac_bits_out1 1 7 2 4040 4250 N
preplace netloc gpio_leds_bits_out1 1 7 2 4040J 3230 NJ
preplace netloc USB_UART_TX_1 1 0 3 NJ 360 N 360 1390
preplace netloc adc|microblaze_0_Clk 1 0 3 270 -2780 NJ -2780 880
preplace netloc microblaze_0_axi_periph_M15_AXI 1 3 2 2000 -2000 2430
preplace netloc microblaze_0_axi_periph_M05_AXI 1 4 2 N 2400 2930
preplace netloc spi_ldo_mux_ss1_out 1 7 2 4060J 4470 NJ
preplace netloc sequencer_bits_out14 1 6 3 NJ 1450 NJ 1450 5640J
preplace netloc gpio_dac_bits_out2 1 7 2 4070 4290 N
preplace netloc gpio_leds_bits_out2 1 7 2 4050J 3250 NJ
preplace netloc sequencer_bits_out15 1 6 3 NJ 1470 NJ 1470 5630J
preplace netloc rst_clk_wiz_1_100M_peripheral_aresetn 1 1 5 -10 1214 1500 1234 1940 -2050 2520 -1060 2920
preplace netloc gpio_dac_bits_out3 1 7 2 N 4350 N
preplace netloc gpio_leds_bits_out3 1 7 2 4060J 3270 NJ
preplace netloc cds_core_a_dout_ready 1 4 1 2560
levelinfo -pg 1 -350 -130 380 1750 2240 2730 3260 3916 5440 5780 -top -3410 -bot 6170
levelinfo -hier adc * 420 680 1010 *
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""

