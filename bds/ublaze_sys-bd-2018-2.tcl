
################################################################
# This is a generated script based on design: ublaze_sys
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
# source ublaze_sys_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# vec2bit_4, vec2bit_5, gpio_leds_bits, vec2bit_6, packer_header_vec2bit, sequencer_bits, spi_ldo_mux

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
set design_name ublaze_sys

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
xilinx.com:ip:axi_intc:4.1\
fnal.gov:user:cds_noncausal:1.0\
xilinx.com:ip:util_ds_buf:2.1\
xilinx.com:ip:xlconstant:1.1\
fnal.gov:user:eth_resync:1.0\
xilinx.com:ip:fit_timer:2.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:microblaze:10.0\
fnal.gov:user:packer:1.0\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:axi_bram_ctrl:4.0\
xilinx.com:ip:proc_sys_reset:5.0\
fnal.gov:user:sequencer:1.0\
fnal.gov:user:smart_buffer:1.0\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:axi_uartlite:2.0\
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
packer_header_vec2bit\
sequencer_bits\
spi_ldo_mux\
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


# Hierarchical cell: ublaze_mem
proc create_hier_cell_ublaze_mem { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ublaze_mem() - Empty argument(s)!"}
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
  set SPARE_SW4 [ create_bd_port -dir I -type rst SPARE_SW4 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $SPARE_SW4
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
  set VOLT_SW_DIN [ create_bd_port -dir O VOLT_SW_DIN ]
  set VOLT_SW_DOUT [ create_bd_port -dir I VOLT_SW_DOUT ]

  # Create instance: axi_intc, and set properties
  set axi_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc ]

  # Create instance: axi_periph, and set properties
  set axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {19} \
 ] $axi_periph

  # Create instance: cds_core_a, and set properties
  set cds_core_a [ create_bd_cell -type ip -vlnv fnal.gov:user:cds_noncausal:1.0 cds_core_a ]

  # Create instance: cds_core_b, and set properties
  set cds_core_b [ create_bd_cell -type ip -vlnv fnal.gov:user:cds_noncausal:1.0 cds_core_b ]

  # Create instance: cds_core_c, and set properties
  set cds_core_c [ create_bd_cell -type ip -vlnv fnal.gov:user:cds_noncausal:1.0 cds_core_c ]

  # Create instance: cds_core_d, and set properties
  set cds_core_d [ create_bd_cell -type ip -vlnv fnal.gov:user:cds_noncausal:1.0 cds_core_d ]

  # Create instance: clk_buf, and set properties
  set clk_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 clk_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {BUFG} \
 ] $clk_buf

  # Create instance: data_a, and set properties
  set data_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 data_a ]
  set_property -dict [ list \
   CONFIG.CONST_WIDTH {18} \
 ] $data_a

  # Create instance: data_b, and set properties
  set data_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 data_b ]
  set_property -dict [ list \
   CONFIG.CONST_WIDTH {18} \
 ] $data_b

  # Create instance: data_c, and set properties
  set data_c [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 data_c ]
  set_property -dict [ list \
   CONFIG.CONST_WIDTH {18} \
 ] $data_c

  # Create instance: data_d, and set properties
  set data_d [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 data_d ]
  set_property -dict [ list \
   CONFIG.CONST_WIDTH {18} \
 ] $data_d

  # Create instance: eth, and set properties
  set eth [ create_bd_cell -type ip -vlnv fnal.gov:user:eth_resync:1.0 eth ]

  # Create instance: fit_timer, and set properties
  set fit_timer [ create_bd_cell -type ip -vlnv xilinx.com:ip:fit_timer:2.0 fit_timer ]
  set_property -dict [ list \
   CONFIG.C_NO_CLOCKS {100000} \
 ] $fit_timer

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
  
  # Create instance: gpio_eth, and set properties
  set gpio_eth [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_eth ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {8} \
 ] $gpio_eth

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
  
  # Create instance: leds_gpio, and set properties
  set leds_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 leds_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {6} \
 ] $leds_gpio

  # Create instance: master_clock, and set properties
  set master_clock [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 master_clock ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {137.681} \
   CONFIG.CLKOUT1_PHASE_ERROR {105.461} \
   CONFIG.CLKOUT2_JITTER {153.276} \
   CONFIG.CLKOUT2_PHASE_ERROR {105.461} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {60} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {102.086} \
   CONFIG.CLKOUT3_PHASE_ERROR {87.180} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT3_USED {false} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {9.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {9.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {15} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIM_SOURCE {Global_buffer} \
 ] $master_clock

  # Create instance: mdm, and set properties
  set mdm [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm ]

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:10.0 microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_I_LMB {1} \
 ] $microblaze_0

  # Create instance: packer, and set properties
  set packer [ create_bd_cell -type ip -vlnv fnal.gov:user:packer:1.0 packer ]

  # Create instance: packer_header, and set properties
  set block_name packer_header_vec2bit
  set block_cell_name packer_header
  if { [catch {set packer_header [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $packer_header eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
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

  # Create instance: ready_a, and set properties
  set ready_a [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ready_a ]

  # Create instance: ready_b, and set properties
  set ready_b [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ready_b ]

  # Create instance: ready_c, and set properties
  set ready_c [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ready_c ]

  # Create instance: ready_d, and set properties
  set ready_d [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ready_d ]

  # Create instance: reset_ctrl, and set properties
  set reset_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_ctrl ]

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

  # Create instance: uart, and set properties
  set uart [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 uart ]

  # Create instance: ublaze_mem
  create_hier_cell_ublaze_mem [current_bd_instance .] ublaze_mem

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_intc_0_interrupt [get_bd_intf_pins axi_intc/interrupt] [get_bd_intf_pins microblaze_0/INTERRUPT]
  connect_bd_intf_net -intf_net axi_periph_M01_AXI [get_bd_intf_pins axi_intc/s_axi] [get_bd_intf_pins axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net axi_periph_M02_AXI [get_bd_intf_pins axi_periph/M02_AXI] [get_bd_intf_pins ram_eth_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_periph_M03_AXI [get_bd_intf_pins axi_periph/M03_AXI] [get_bd_intf_pins gpio_eth/S_AXI]
  connect_bd_intf_net -intf_net axi_periph_M04_AXI [get_bd_intf_pins axi_periph/M04_AXI] [get_bd_intf_pins spi_ldo/AXI_LITE]
  connect_bd_intf_net -intf_net axi_periph_M05_AXI [get_bd_intf_pins axi_periph/M05_AXI] [get_bd_intf_pins gpio_ldo/S_AXI]
  connect_bd_intf_net -intf_net axi_periph_M06_AXI [get_bd_intf_pins axi_periph/M06_AXI] [get_bd_intf_pins gpio_dac/S_AXI]
  connect_bd_intf_net -intf_net axi_periph_M07_AXI [get_bd_intf_pins axi_periph/M07_AXI] [get_bd_intf_pins spi_dac/AXI_LITE]
  connect_bd_intf_net -intf_net axi_periph_M08_AXI [get_bd_intf_pins axi_periph/M08_AXI] [get_bd_intf_pins leds_gpio/S_AXI]
  connect_bd_intf_net -intf_net axi_periph_M09_AXI [get_bd_intf_pins axi_periph/M09_AXI] [get_bd_intf_pins gpio_telemetry/S_AXI]
  connect_bd_intf_net -intf_net axi_periph_M10_AXI [get_bd_intf_pins axi_periph/M10_AXI] [get_bd_intf_pins spi_telemetry/AXI_LITE]
  connect_bd_intf_net -intf_net axi_periph_M11_AXI [get_bd_intf_pins axi_periph/M11_AXI] [get_bd_intf_pins spi_volt_sw/AXI_LITE]
  connect_bd_intf_net -intf_net axi_periph_M12_AXI [get_bd_intf_pins axi_periph/M12_AXI] [get_bd_intf_pins sequencer/s00_axi]
  connect_bd_intf_net -intf_net axi_periph_M13_AXI [get_bd_intf_pins axi_periph/M13_AXI] [get_bd_intf_pins packer/s00_axi]
  connect_bd_intf_net -intf_net axi_periph_M14_AXI [get_bd_intf_pins axi_periph/M14_AXI] [get_bd_intf_pins cds_core_d/s00_axi]
  connect_bd_intf_net -intf_net axi_periph_M15_AXI [get_bd_intf_pins axi_periph/M15_AXI] [get_bd_intf_pins cds_core_b/s00_axi]
  connect_bd_intf_net -intf_net axi_periph_M16_AXI [get_bd_intf_pins axi_periph/M16_AXI] [get_bd_intf_pins cds_core_a/s00_axi]
  connect_bd_intf_net -intf_net axi_periph_M17_AXI [get_bd_intf_pins axi_periph/M17_AXI] [get_bd_intf_pins cds_core_c/s00_axi]
  connect_bd_intf_net -intf_net axi_periph_M18_AXI [get_bd_intf_pins axi_periph/M18_AXI] [get_bd_intf_pins smart_buffer_0/s00_axi]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins axi_periph/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DP]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins axi_periph/M00_AXI] [get_bd_intf_pins uart/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins ublaze_mem/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins ublaze_mem/ILMB]
  connect_bd_intf_net -intf_net ram_eth_ctrl_BRAM_PORTA [get_bd_intf_pins ram_eth/BRAM_PORTA] [get_bd_intf_pins ram_eth_ctrl/BRAM_PORTA]

  # Create port connections
  connect_bd_net -net CCD_VDD_DIGPOT_SDO_1 [get_bd_ports CCD_VDD_DIGPOT_SDO] [get_bd_pins spi_ldo_mux/sdo1_in]
  connect_bd_net -net CCD_VDRAIN_DIGPOT_SDO_1 [get_bd_ports CCD_VDRAIN_DIGPOT_SDO] [get_bd_pins spi_ldo_mux/sdo0_in]
  connect_bd_net -net CCD_VR_DIGPOT_SDO_1 [get_bd_ports CCD_VR_DIGPOT_SDO] [get_bd_pins spi_ldo_mux/sdo2_in]
  connect_bd_net -net CCD_VSUB_DIGPOT_SDO_1 [get_bd_ports CCD_VSUB_DIGPOT_SDO] [get_bd_pins spi_ldo_mux/sdo3_in]
  connect_bd_net -net DAC_SDO_1 [get_bd_ports DAC_SDO] [get_bd_pins spi_dac/io1_i]
  connect_bd_net -net ENET_RX0_1 [get_bd_ports ENET_RX0] [get_bd_pins eth/ENET_RX0]
  connect_bd_net -net ENET_RX1_1 [get_bd_ports ENET_RX1] [get_bd_pins eth/ENET_RX1]
  connect_bd_net -net ENET_RX2_1 [get_bd_ports ENET_RX2] [get_bd_pins eth/ENET_RX2]
  connect_bd_net -net ENET_RX3_1 [get_bd_ports ENET_RX3] [get_bd_pins eth/ENET_RX3]
  connect_bd_net -net ENET_RX4_1 [get_bd_ports ENET_RX4] [get_bd_pins eth/ENET_RX4]
  connect_bd_net -net ENET_RX5_1 [get_bd_ports ENET_RX5] [get_bd_pins eth/ENET_RX5]
  connect_bd_net -net ENET_RX6_1 [get_bd_ports ENET_RX6] [get_bd_pins eth/ENET_RX6]
  connect_bd_net -net ENET_RX7_1 [get_bd_ports ENET_RX7] [get_bd_pins eth/ENET_RX7]
  connect_bd_net -net ENET_RXCLK_1 [get_bd_ports ENET_RXCLK] [get_bd_pins eth/ENET_RXCLK]
  connect_bd_net -net ENET_RXDV_1 [get_bd_ports ENET_RXDV] [get_bd_pins eth/ENET_RXDV]
  connect_bd_net -net Net [get_bd_pins cds_core_a/din_ready] [get_bd_pins packer/rready_a] [get_bd_pins ready_a/dout] [get_bd_pins smart_buffer_0/ready_in_a]
  connect_bd_net -net Net1 [get_bd_pins cds_core_a/din] [get_bd_pins data_a/dout] [get_bd_pins packer/rdata_a] [get_bd_pins smart_buffer_0/data_in_a]
  connect_bd_net -net Net2 [get_bd_pins cds_core_b/din_ready] [get_bd_pins packer/rready_b] [get_bd_pins ready_b/dout] [get_bd_pins smart_buffer_0/ready_in_b]
  connect_bd_net -net Net3 [get_bd_pins cds_core_b/din] [get_bd_pins data_b/dout] [get_bd_pins packer/rdata_b] [get_bd_pins smart_buffer_0/data_in_b]
  connect_bd_net -net Net4 [get_bd_pins cds_core_c/din_ready] [get_bd_pins packer/rready_c] [get_bd_pins ready_c/dout] [get_bd_pins smart_buffer_0/ready_in_c]
  connect_bd_net -net Net5 [get_bd_pins cds_core_c/din] [get_bd_pins data_c/dout] [get_bd_pins packer/rdata_c] [get_bd_pins smart_buffer_0/data_in_c]
  connect_bd_net -net Net6 [get_bd_pins cds_core_d/din_ready] [get_bd_pins packer/rready_d] [get_bd_pins ready_d/dout] [get_bd_pins smart_buffer_0/ready_in_d]
  connect_bd_net -net Net7 [get_bd_pins cds_core_d/din] [get_bd_pins data_d/dout] [get_bd_pins packer/rdata_d] [get_bd_pins smart_buffer_0/data_in_d]
  connect_bd_net -net SPARE_SW4_1 [get_bd_ports SPARE_SW4] [get_bd_pins eth/rst] [get_bd_pins master_clock/reset] [get_bd_pins ram_eth/rstb] [get_bd_pins reset_ctrl/ext_reset_in]
  connect_bd_net -net TEL_DOUT_1 [get_bd_ports TEL_DOUT] [get_bd_pins spi_telemetry/io1_i]
  connect_bd_net -net USB_UART_TX_1 [get_bd_ports USB_UART_TX] [get_bd_pins uart/rx]
  connect_bd_net -net USER_CLK_1 [get_bd_ports USER_CLK] [get_bd_pins clk_buf/BUFG_I]
  connect_bd_net -net VOLT_SW_DOUT_1 [get_bd_ports VOLT_SW_DOUT] [get_bd_pins spi_volt_sw/io1_i]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_ports USB_UART_RX] [get_bd_pins uart/tx]
  connect_bd_net -net cds_core_a_dout [get_bd_pins cds_core_a/dout] [get_bd_pins packer/pdata_a]
  connect_bd_net -net cds_core_a_dout_ready [get_bd_pins cds_core_a/dout_ready] [get_bd_pins packer/pready_a]
  connect_bd_net -net cds_core_b_dout [get_bd_pins cds_core_b/dout] [get_bd_pins packer/pdata_b]
  connect_bd_net -net cds_core_b_dout_ready [get_bd_pins cds_core_b/dout_ready] [get_bd_pins packer/pready_b]
  connect_bd_net -net cds_core_c_dout [get_bd_pins cds_core_c/dout] [get_bd_pins packer/pdata_c]
  connect_bd_net -net cds_core_c_dout_ready [get_bd_pins cds_core_c/dout_ready] [get_bd_pins packer/pready_c]
  connect_bd_net -net cds_core_d_dout [get_bd_pins cds_core_d/dout] [get_bd_pins packer/pdata_d]
  connect_bd_net -net cds_core_d_dout_ready [get_bd_pins cds_core_d/dout_ready] [get_bd_pins packer/pready_d]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins master_clock/locked] [get_bd_pins reset_ctrl/dcm_locked]
  connect_bd_net -net eth_addr [get_bd_pins eth/addr] [get_bd_pins ram_eth/addrb]
  connect_bd_net -net eth_clk_125_out [get_bd_pins eth/clk_125_out] [get_bd_pins ram_eth/clkb]
  connect_bd_net -net eth_data_out [get_bd_pins eth/data_out] [get_bd_pins ram_eth/dinb]
  connect_bd_net -net eth_resync_0_ENET_GTXCLK [get_bd_ports ENET_GTXCLK] [get_bd_pins eth/ENET_GTXCLK]
  connect_bd_net -net eth_resync_0_ENET_TX0 [get_bd_ports ENET_TX0] [get_bd_pins eth/ENET_TX0]
  connect_bd_net -net eth_resync_0_ENET_TX1 [get_bd_ports ENET_TX1] [get_bd_pins eth/ENET_TX1]
  connect_bd_net -net eth_resync_0_ENET_TX2 [get_bd_ports ENET_TX2] [get_bd_pins eth/ENET_TX2]
  connect_bd_net -net eth_resync_0_ENET_TX3 [get_bd_ports ENET_TX3] [get_bd_pins eth/ENET_TX3]
  connect_bd_net -net eth_resync_0_ENET_TX4 [get_bd_ports ENET_TX4] [get_bd_pins eth/ENET_TX4]
  connect_bd_net -net eth_resync_0_ENET_TX5 [get_bd_ports ENET_TX5] [get_bd_pins eth/ENET_TX5]
  connect_bd_net -net eth_resync_0_ENET_TX6 [get_bd_ports ENET_TX6] [get_bd_pins eth/ENET_TX6]
  connect_bd_net -net eth_resync_0_ENET_TX7 [get_bd_ports ENET_TX7] [get_bd_pins eth/ENET_TX7]
  connect_bd_net -net eth_resync_0_ENET_TXEN [get_bd_ports ENET_TXEN] [get_bd_pins eth/ENET_TXEN]
  connect_bd_net -net eth_resync_0_ENET_TXER [get_bd_ports ENET_TXER] [get_bd_pins eth/ENET_TXER]
  connect_bd_net -net eth_wren [get_bd_pins eth/wren] [get_bd_pins ram_eth/web]
  connect_bd_net -net fit_timer_0_Interrupt [get_bd_pins axi_intc/intr] [get_bd_pins fit_timer/Interrupt]
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
  connect_bd_net -net gpio_eth_gpio_io_o [get_bd_pins eth/user_addr] [get_bd_pins gpio_eth/gpio_io_o]
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
  connect_bd_net -net leds_gpio_gpio_io_o [get_bd_pins gpio_leds_bits/vec_in] [get_bd_pins leds_gpio/gpio_io_o]
  connect_bd_net -net master_clock_clk_out2 [get_bd_pins master_clock/clk_out2] [get_bd_pins spi_dac/ext_spi_clk] [get_bd_pins spi_ldo/ext_spi_clk] [get_bd_pins spi_telemetry/ext_spi_clk] [get_bd_pins spi_volt_sw/ext_spi_clk]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm/Debug_SYS_Rst] [get_bd_pins reset_ctrl/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins axi_intc/s_axi_aclk] [get_bd_pins axi_periph/ACLK] [get_bd_pins axi_periph/M00_ACLK] [get_bd_pins axi_periph/M01_ACLK] [get_bd_pins axi_periph/M02_ACLK] [get_bd_pins axi_periph/M03_ACLK] [get_bd_pins axi_periph/M04_ACLK] [get_bd_pins axi_periph/M05_ACLK] [get_bd_pins axi_periph/M06_ACLK] [get_bd_pins axi_periph/M07_ACLK] [get_bd_pins axi_periph/M08_ACLK] [get_bd_pins axi_periph/M09_ACLK] [get_bd_pins axi_periph/M10_ACLK] [get_bd_pins axi_periph/M11_ACLK] [get_bd_pins axi_periph/M12_ACLK] [get_bd_pins axi_periph/M13_ACLK] [get_bd_pins axi_periph/M14_ACLK] [get_bd_pins axi_periph/M15_ACLK] [get_bd_pins axi_periph/M16_ACLK] [get_bd_pins axi_periph/M17_ACLK] [get_bd_pins axi_periph/M18_ACLK] [get_bd_pins axi_periph/S00_ACLK] [get_bd_pins cds_core_a/s00_axi_aclk] [get_bd_pins cds_core_b/s00_axi_aclk] [get_bd_pins cds_core_c/s00_axi_aclk] [get_bd_pins cds_core_d/s00_axi_aclk] [get_bd_pins fit_timer/Clk] [get_bd_pins gpio_dac/s_axi_aclk] [get_bd_pins gpio_eth/s_axi_aclk] [get_bd_pins gpio_ldo/s_axi_aclk] [get_bd_pins gpio_telemetry/s_axi_aclk] [get_bd_pins leds_gpio/s_axi_aclk] [get_bd_pins master_clock/clk_out1] [get_bd_pins microblaze_0/Clk] [get_bd_pins packer/s00_axi_aclk] [get_bd_pins ram_eth_ctrl/s_axi_aclk] [get_bd_pins reset_ctrl/slowest_sync_clk] [get_bd_pins sequencer/s00_axi_aclk] [get_bd_pins smart_buffer_0/s00_axi_aclk] [get_bd_pins spi_dac/s_axi_aclk] [get_bd_pins spi_ldo/s_axi_aclk] [get_bd_pins spi_telemetry/s_axi_aclk] [get_bd_pins spi_volt_sw/s_axi_aclk] [get_bd_pins uart/s_axi_aclk] [get_bd_pins ublaze_mem/LMB_Clk]
  connect_bd_net -net packer_dout [get_bd_pins eth/b_data] [get_bd_pins packer/dout]
  connect_bd_net -net packer_dready [get_bd_pins eth/b_we] [get_bd_pins packer/dready]
  connect_bd_net -net packer_header_vec2bit_0_dout [get_bd_pins packer/header] [get_bd_pins packer_header/dout] [get_bd_pins smart_buffer_0/header]
  connect_bd_net -net ram_eth_doutb [get_bd_pins eth/data_in] [get_bd_pins ram_eth/doutb]
  connect_bd_net -net reset_ctrl_peripheral_reset [get_bd_pins fit_timer/Rst] [get_bd_pins reset_ctrl/peripheral_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins reset_ctrl/bus_struct_reset] [get_bd_pins ublaze_mem/SYS_Rst]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn [get_bd_pins axi_periph/ARESETN] [get_bd_pins reset_ctrl/interconnect_aresetn]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins reset_ctrl/mb_reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins axi_intc/s_axi_aresetn] [get_bd_pins axi_periph/M00_ARESETN] [get_bd_pins axi_periph/M01_ARESETN] [get_bd_pins axi_periph/M02_ARESETN] [get_bd_pins axi_periph/M03_ARESETN] [get_bd_pins axi_periph/M04_ARESETN] [get_bd_pins axi_periph/M05_ARESETN] [get_bd_pins axi_periph/M06_ARESETN] [get_bd_pins axi_periph/M07_ARESETN] [get_bd_pins axi_periph/M08_ARESETN] [get_bd_pins axi_periph/M09_ARESETN] [get_bd_pins axi_periph/M10_ARESETN] [get_bd_pins axi_periph/M11_ARESETN] [get_bd_pins axi_periph/M12_ARESETN] [get_bd_pins axi_periph/M13_ARESETN] [get_bd_pins axi_periph/M14_ARESETN] [get_bd_pins axi_periph/M15_ARESETN] [get_bd_pins axi_periph/M16_ARESETN] [get_bd_pins axi_periph/M17_ARESETN] [get_bd_pins axi_periph/M18_ARESETN] [get_bd_pins axi_periph/S00_ARESETN] [get_bd_pins cds_core_a/s00_axi_aresetn] [get_bd_pins cds_core_b/s00_axi_aresetn] [get_bd_pins cds_core_c/s00_axi_aresetn] [get_bd_pins cds_core_d/s00_axi_aresetn] [get_bd_pins gpio_dac/s_axi_aresetn] [get_bd_pins gpio_eth/s_axi_aresetn] [get_bd_pins gpio_ldo/s_axi_aresetn] [get_bd_pins gpio_telemetry/s_axi_aresetn] [get_bd_pins leds_gpio/s_axi_aresetn] [get_bd_pins packer/s00_axi_aresetn] [get_bd_pins ram_eth_ctrl/s_axi_aresetn] [get_bd_pins reset_ctrl/peripheral_aresetn] [get_bd_pins sequencer/s00_axi_aresetn] [get_bd_pins smart_buffer_0/s00_axi_aresetn] [get_bd_pins spi_dac/s_axi_aresetn] [get_bd_pins spi_ldo/s_axi_aresetn] [get_bd_pins spi_telemetry/s_axi_aresetn] [get_bd_pins spi_volt_sw/s_axi_aresetn] [get_bd_pins uart/s_axi_aresetn]
  connect_bd_net -net sequencer_bits_out0 [get_bd_ports TGL_DGA] [get_bd_pins sequencer_bits/out0]
  connect_bd_net -net sequencer_bits_out1 [get_bd_ports TGL_DGB] [get_bd_pins sequencer_bits/out1]
  connect_bd_net -net sequencer_bits_out2 [get_bd_ports TGL_H1A] [get_bd_pins sequencer_bits/out2]
  connect_bd_net -net sequencer_bits_out3 [get_bd_ports TGL_H1B] [get_bd_pins sequencer_bits/out3]
  connect_bd_net -net sequencer_bits_out4 [get_bd_ports TGL_H2C] [get_bd_pins sequencer_bits/out4]
  connect_bd_net -net sequencer_bits_out5 [get_bd_ports TGL_H3A] [get_bd_pins sequencer_bits/out5]
  connect_bd_net -net sequencer_bits_out6 [get_bd_ports TGL_H3B] [get_bd_pins sequencer_bits/out6]
  connect_bd_net -net sequencer_bits_out7 [get_bd_ports TGL_OGA] [get_bd_pins sequencer_bits/out7]
  connect_bd_net -net sequencer_bits_out8 [get_bd_ports TGL_OGB] [get_bd_pins sequencer_bits/out8]
  connect_bd_net -net sequencer_bits_out9 [get_bd_ports TGL_RGA] [get_bd_pins sequencer_bits/out9]
  connect_bd_net -net sequencer_bits_out10 [get_bd_ports TGL_RGB] [get_bd_pins sequencer_bits/out10]
  connect_bd_net -net sequencer_bits_out11 [get_bd_ports TGL_SWA] [get_bd_pins sequencer_bits/out11]
  connect_bd_net -net sequencer_bits_out12 [get_bd_ports TGL_SWB] [get_bd_pins sequencer_bits/out12]
  connect_bd_net -net sequencer_bits_out13 [get_bd_ports TGL_TGA] [get_bd_pins sequencer_bits/out13]
  connect_bd_net -net sequencer_bits_out14 [get_bd_ports TGL_TGB] [get_bd_pins sequencer_bits/out14]
  connect_bd_net -net sequencer_bits_out15 [get_bd_ports TGL_V1A] [get_bd_pins sequencer_bits/out15]
  connect_bd_net -net sequencer_bits_out16 [get_bd_ports TGL_V1B] [get_bd_pins sequencer_bits/out16]
  connect_bd_net -net sequencer_bits_out17 [get_bd_ports TGL_V2C] [get_bd_pins sequencer_bits/out17]
  connect_bd_net -net sequencer_bits_out18 [get_bd_ports TGL_V3A] [get_bd_pins sequencer_bits/out18]
  connect_bd_net -net sequencer_bits_out19 [get_bd_ports TGL_V3B] [get_bd_pins sequencer_bits/out19]
  connect_bd_net -net sequencer_bits_out21 [get_bd_pins sequencer_bits/out21] [get_bd_pins smart_buffer_0/capture_en_cha]
  connect_bd_net -net sequencer_bits_out22 [get_bd_pins sequencer_bits/out22] [get_bd_pins smart_buffer_0/capture_en_chb]
  connect_bd_net -net sequencer_bits_out23 [get_bd_pins sequencer_bits/out23] [get_bd_pins smart_buffer_0/capture_en_chc]
  connect_bd_net -net sequencer_bits_out24 [get_bd_pins sequencer_bits/out24] [get_bd_pins smart_buffer_0/capture_en_chd]
  connect_bd_net -net sequencer_bits_out25 [get_bd_pins cds_core_a/p] [get_bd_pins cds_core_b/p] [get_bd_pins cds_core_c/p] [get_bd_pins cds_core_d/p] [get_bd_pins packer_header/in_0] [get_bd_pins sequencer_bits/out25]
  connect_bd_net -net sequencer_bits_out26 [get_bd_pins cds_core_a/s] [get_bd_pins cds_core_b/s] [get_bd_pins cds_core_c/s] [get_bd_pins cds_core_d/s] [get_bd_pins packer_header/in_1] [get_bd_pins sequencer_bits/out26]
  connect_bd_net -net sequencer_seq_port_out [get_bd_pins sequencer/seq_port_out] [get_bd_pins sequencer_bits/vec_in]
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
  connect_bd_net -net util_ds_buf_0_BUFG_O [get_bd_pins clk_buf/BUFG_O] [get_bd_pins master_clock/clk_in1]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins ram_eth/enb] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins packer/dack] [get_bd_pins xlconstant_1/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_intc/S_AXI/Reg] SEG_axi_intc_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs spi_dac/AXI_LITE/Reg] SEG_axi_quad_spi_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A20000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs spi_telemetry/AXI_LITE/Reg] SEG_axi_quad_spi_0_Reg1
  create_bd_addr_seg -range 0x00010000 -offset 0x40600000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs uart/S_AXI/Reg] SEG_axi_uartlite_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A80000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs cds_core_a/s00_axi/reg0] SEG_cds_core_a_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A70000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs cds_core_b/s00_axi/reg0] SEG_cds_core_b_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A90000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs cds_core_c/s00_axi/reg0] SEG_cds_core_c_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A60000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs cds_core_d/s00_axi/reg0] SEG_cds_core_d_reg0
  create_bd_addr_seg -range 0x00040000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs ublaze_mem/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00010000 -offset 0x40020000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs gpio_dac/S_AXI/Reg] SEG_gpio_dac_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs gpio_eth/S_AXI/Reg] SEG_gpio_eth_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40010000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs gpio_ldo/S_AXI/Reg] SEG_gpio_ldo_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40040000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs gpio_telemetry/S_AXI/Reg] SEG_gpio_telemetry_Reg
  create_bd_addr_seg -range 0x00040000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs ublaze_mem/ilmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00010000 -offset 0x40030000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs leds_gpio/S_AXI/Reg] SEG_leds_gpio_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A50000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs packer/s00_axi/reg0] SEG_packer_reg0
  create_bd_addr_seg -range 0x00002000 -offset 0xC0000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs ram_eth_ctrl/S_AXI/Mem0] SEG_ram_eth_ctrl_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A40000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs sequencer/s00_axi/reg0] SEG_sequencer_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x44AA0000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs smart_buffer_0/s00_axi/reg0] SEG_smart_buffer_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs spi_ldo/AXI_LITE/Reg] SEG_spi_ldo_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x44A30000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs spi_volt_sw/AXI_LITE/Reg] SEG_spi_volt_sw_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   ExpandedHierarchyInLayout: "",
   guistr: "# # String gsaved with Nlview 6.8.5  2018-01-30 bk=1.4354 VDI=40 GEI=35 GUI=JA:1.6 non-TLS
#  -string -flagsOSRD
preplace port TGL_H1B -pg 1 -y -680 -defaultsOSRD
preplace port CCD_VDD_DIGPOT_SDO -pg 1 -y 1770 -defaultsOSRD -right
preplace port TEL_MUXA0 -pg 1 -y 3160 -defaultsOSRD
preplace port TEL_MUXA1 -pg 1 -y 3180 -defaultsOSRD
preplace port SPARE_SW4 -pg 1 -y 190 -defaultsOSRD
preplace port USB_UART_TX -pg 1 -y 370 -defaultsOSRD -right
preplace port TEL_MUXA2 -pg 1 -y 3200 -defaultsOSRD
preplace port CCD_VR_DIGPOT_SDO -pg 1 -y 1790 -defaultsOSRD -right
preplace port CCD_VDD_EN -pg 1 -y 1950 -defaultsOSRD
preplace port CCD_VR_DIGPOT_SYNCn -pg 1 -y 1640 -defaultsOSRD
preplace port TGL_DGA -pg 1 -y -740 -defaultsOSRD
preplace port DIGPOT_DIN -pg 1 -y 1490 -defaultsOSRD
preplace port TGL_TGA -pg 1 -y -480 -defaultsOSRD
preplace port TGL_DGB -pg 1 -y -720 -defaultsOSRD
preplace port DIGPOT_SCLK -pg 1 -y 1510 -defaultsOSRD
preplace port DAC_SDI -pg 1 -y 2560 -defaultsOSRD
preplace port TGL_TGB -pg 1 -y -460 -defaultsOSRD
preplace port TGL_OGA -pg 1 -y -600 -defaultsOSRD
preplace port TGL_OGB -pg 1 -y -580 -defaultsOSRD
preplace port DAC_CLRn -pg 1 -y 2260 -defaultsOSRD
preplace port ENET_RXDV -pg 1 -y 930 -defaultsOSRD
preplace port USB_UART_RX -pg 1 -y 390 -defaultsOSRD
preplace port CCD_VR_EN -pg 1 -y 1970 -defaultsOSRD
preplace port ENET_RX0 -pg 1 -y 910 -defaultsOSRD
preplace port TGL_RGA -pg 1 -y -560 -defaultsOSRD
preplace port DAC_SDO -pg 1 -y 2580 -defaultsOSRD -right
preplace port CCD_VDD_DIGPOT_SYNCn -pg 1 -y 1620 -defaultsOSRD
preplace port ENET_RX1 -pg 1 -y 890 -defaultsOSRD
preplace port TGL_RGB -pg 1 -y -540 -defaultsOSRD
preplace port ENET_RX2 -pg 1 -y 870 -defaultsOSRD
preplace port TGL_V2C -pg 1 -y -400 -defaultsOSRD
preplace port TGL_H2C -pg 1 -y -660 -defaultsOSRD
preplace port VOLT_SW_CLK -pg 1 -y 3740 -defaultsOSRD
preplace port ENET_RX3 -pg 1 -y 850 -defaultsOSRD
preplace port TGL_SWA -pg 1 -y -520 -defaultsOSRD
preplace port ENET_RX4 -pg 1 -y 830 -defaultsOSRD
preplace port TGL_SWB -pg 1 -y -500 -defaultsOSRD
preplace port ENET_RX5 -pg 1 -y 810 -defaultsOSRD
preplace port ENET_RXCLK -pg 1 -y 750 -defaultsOSRD
preplace port TEL_SCLK -pg 1 -y 3500 -defaultsOSRD
preplace port TEL_MUXEN0 -pg 1 -y 3100 -defaultsOSRD
preplace port ENET_RX6 -pg 1 -y 790 -defaultsOSRD
preplace port DIGPOT_RSTn -pg 1 -y 2010 -defaultsOSRD
preplace port TEL_MUXEN1 -pg 1 -y 3120 -defaultsOSRD
preplace port TEL_MUXEN2 -pg 1 -y 3140 -defaultsOSRD
preplace port ENET_RX7 -pg 1 -y 770 -defaultsOSRD
preplace port ENET_TXEN -pg 1 -y 930 -defaultsOSRD
preplace port VOLT_SW_DIN -pg 1 -y 3700 -defaultsOSRD
preplace port ENET_TXER -pg 1 -y 750 -defaultsOSRD
preplace port CCD_VSUB_EN -pg 1 -y 1990 -defaultsOSRD
preplace port LED0 -pg 1 -y 2800 -defaultsOSRD
preplace port LED1 -pg 1 -y 2820 -defaultsOSRD
preplace port LED2 -pg 1 -y 2840 -defaultsOSRD
preplace port CCD_VSUB_DIGPOT_SYNCn -pg 1 -y 1660 -defaultsOSRD
preplace port LED3 -pg 1 -y 2860 -defaultsOSRD
preplace port TEL_DIN -pg 1 -y 3460 -defaultsOSRD
preplace port TEL_DOUT -pg 1 -y 3480 -defaultsOSRD -right
preplace port LED4 -pg 1 -y 2880 -defaultsOSRD
preplace port TGL_V3A -pg 1 -y -380 -defaultsOSRD
preplace port TGL_H3A -pg 1 -y -640 -defaultsOSRD
preplace port CCD_VDRAIN_DIGPOT_SDO -pg 1 -y 1750 -defaultsOSRD -right
preplace port LED5 -pg 1 -y 2900 -defaultsOSRD
preplace port TGL_V3B -pg 1 -y -360 -defaultsOSRD
preplace port TGL_H3B -pg 1 -y -620 -defaultsOSRD
preplace port VOLT_SW_DOUT -pg 1 -y 3720 -defaultsOSRD -right
preplace port DAC_SCLK -pg 1 -y 2600 -defaultsOSRD
preplace port ENET_TX0 -pg 1 -y 910 -defaultsOSRD
preplace port USER_CLK -pg 1 -y 250 -defaultsOSRD
preplace port ENET_GTXCLK -pg 1 -y 730 -defaultsOSRD
preplace port ENET_TX1 -pg 1 -y 890 -defaultsOSRD
preplace port ENET_TX2 -pg 1 -y 950 -defaultsOSRD
preplace port CCD_VDRAIN_DIGPOT_SYNCn -pg 1 -y 1600 -defaultsOSRD
preplace port ENET_TX3 -pg 1 -y 850 -defaultsOSRD
preplace port ENET_TX4 -pg 1 -y 830 -defaultsOSRD
preplace port DAC_SW_EN -pg 1 -y 2300 -defaultsOSRD
preplace port ENET_TX5 -pg 1 -y 710 -defaultsOSRD
preplace port ENET_TX6 -pg 1 -y 690 -defaultsOSRD
preplace port TGL_V1A -pg 1 -y -440 -defaultsOSRD
preplace port ENET_TX7 -pg 1 -y 870 -defaultsOSRD
preplace port CCD_VSUB_DIGPOT_SDO -pg 1 -y 1810 -defaultsOSRD -right
preplace port CCD_VDRAIN_EN -pg 1 -y 1930 -defaultsOSRD
preplace port TGL_V1B -pg 1 -y -420 -defaultsOSRD
preplace port DAC_LDACn -pg 1 -y 2240 -defaultsOSRD
preplace port DAC_RESETn -pg 1 -y 2280 -defaultsOSRD
preplace port TGL_H1A -pg 1 -y -700 -defaultsOSRD
preplace portBus TEL_CSn -pg 1 -y 3520 -defaultsOSRD
preplace portBus DAC_SYNCn -pg 1 -y 2620 -defaultsOSRD
preplace inst ready_c -pg 1 -lvl 5 -y -1920 -defaultsOSRD
preplace inst packer_header -pg 1 -lvl 7 -y -700 -defaultsOSRD
preplace inst ready_d -pg 1 -lvl 5 -y -1680 -defaultsOSRD
preplace inst smart_buffer_0 -pg 1 -lvl 7 -y -2210 -defaultsOSRD
preplace inst master_clock -pg 1 -lvl 2 -y 240 -defaultsOSRD
preplace inst cds_core_a -pg 1 -lvl 7 -y -1830 -defaultsOSRD
preplace inst gpio_dac_bits -pg 1 -lvl 10 -y 2270 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 8 -y 1350 -defaultsOSRD
preplace inst eth -pg 1 -lvl 9 -y 980 -defaultsOSRD
preplace inst fit_timer -pg 1 -lvl 2 -y 40 -defaultsOSRD
preplace inst mdm -pg 1 -lvl 3 -y 210 -defaultsOSRD
preplace inst xlconstant_1 -pg 1 -lvl 7 -y -540 -defaultsOSRD
preplace inst cds_core_b -pg 1 -lvl 7 -y -1610 -defaultsOSRD
preplace inst sequencer_bits -pg 1 -lvl 9 -y -430 -defaultsOSRD
preplace inst spi_ldo_mux -pg 1 -lvl 10 -y 1640 -defaultsOSRD
preplace inst data_a -pg 1 -lvl 5 -y -2250 -defaultsOSRD
preplace inst cds_core_c -pg 1 -lvl 7 -y -1390 -defaultsOSRD
preplace inst sequencer -pg 1 -lvl 6 -y -430 -defaultsOSRD
preplace inst gpio_dac -pg 1 -lvl 6 -y 2260 -defaultsOSRD
preplace inst data_b -pg 1 -lvl 5 -y -2020 -defaultsOSRD
preplace inst cds_core_d -pg 1 -lvl 7 -y -1170 -defaultsOSRD
preplace inst gpio_telemetry -pg 1 -lvl 6 -y 3140 -defaultsOSRD
preplace inst gpio_leds_bits -pg 1 -lvl 10 -y 2850 -defaultsOSRD
preplace inst leds_gpio -pg 1 -lvl 6 -y 2840 -defaultsOSRD
preplace inst spi_ldo -pg 1 -lvl 6 -y 1570 -defaultsOSRD
preplace inst ram_eth_ctrl -pg 1 -lvl 7 -y 1240 -defaultsOSRD
preplace inst data_c -pg 1 -lvl 5 -y -1800 -defaultsOSRD
preplace inst uart -pg 1 -lvl 10 -y 380 -defaultsOSRD
preplace inst ublaze_mem -pg 1 -lvl 6 -y 340 -defaultsOSRD
preplace inst data_d -pg 1 -lvl 5 -y -1580 -defaultsOSRD
preplace inst gpio_ldo_bits -pg 1 -lvl 10 -y 1970 -defaultsOSRD
preplace inst ram_eth -pg 1 -lvl 9 -y 1300 -defaultsOSRD
preplace inst clk_buf -pg 1 -lvl 1 -y 250 -defaultsOSRD
preplace inst gpio_eth -pg 1 -lvl 7 -y 1090 -defaultsOSRD
preplace inst axi_periph -pg 1 -lvl 7 -y 430 -defaultsOSRD
preplace inst spi_telemetry -pg 1 -lvl 6 -y 3490 -defaultsOSRD
preplace inst gpio_telemetry_bits -pg 1 -lvl 10 -y 3150 -defaultsOSRD
preplace inst gpio_ldo -pg 1 -lvl 6 -y 1960 -defaultsOSRD
preplace inst axi_intc -pg 1 -lvl 3 -y 10 -defaultsOSRD
preplace inst reset_ctrl -pg 1 -lvl 4 -y 500 -defaultsOSRD
preplace inst microblaze_0 -pg 1 -lvl 4 -y 330 -defaultsOSRD
preplace inst packer -pg 1 -lvl 8 -y -720 -defaultsOSRD
preplace inst ready_a -pg 1 -lvl 5 -y -2350 -defaultsOSRD
preplace inst ready_b -pg 1 -lvl 5 -y -2130 -defaultsOSRD
preplace inst spi_volt_sw -pg 1 -lvl 6 -y 3720 -defaultsOSRD
preplace inst spi_dac -pg 1 -lvl 6 -y 2590 -defaultsOSRD
preplace netloc cds_core_b_dout_ready 1 7 1 2960
preplace netloc sequencer_bits_out16 1 9 2 N -420 NJ
preplace netloc spi_volt_sw_sck_o 1 6 5 N 3740 NJ 3740 NJ 3740 NJ 3740 NJ
preplace netloc gpio_telemetry_bits_out0 1 10 1 N
preplace netloc gpio_leds_bits_out4 1 10 1 N
preplace netloc sequencer_bits_out17 1 9 2 N -400 NJ
preplace netloc gpio_telemetry_bits_out1 1 10 1 N
preplace netloc gpio_leds_bits_out5 1 10 1 N
preplace netloc spi_ldo_mux_sdo_out 1 6 5 2330 1540 N 1540 N 1540 N 1540 4000
preplace netloc ENET_RX3_1 1 0 9 N 850 N 850 N 850 N 850 N 850 N 850 2140 960 N 960 N
preplace netloc sequencer_bits_out18 1 9 2 N -380 NJ
preplace netloc gpio_telemetry_bits_out2 1 10 1 N
preplace netloc sequencer_bits_out19 1 9 2 N -360 NJ
preplace netloc gpio_telemetry_bits_out3 1 10 1 N
preplace netloc eth_resync_0_ENET_TX0 1 9 2 3720 910 NJ
preplace netloc axi_periph_M12_AXI 1 5 3 1820J -510 2120J -480 2780J
preplace netloc gpio_telemetry_bits_out4 1 10 1 N
preplace netloc eth_resync_0_ENET_TX1 1 9 2 3690 930 4020J
preplace netloc gpio_telemetry_bits_out5 1 10 1 N
preplace netloc fit_timer_0_Interrupt 1 2 1 N
preplace netloc eth_resync_0_ENET_TX2 1 9 2 3680 950 NJ
preplace netloc CCD_VSUB_DIGPOT_SDO_1 1 9 2 3760 1810 N
preplace netloc eth_data_out 1 8 2 3400J 1460 3760
preplace netloc eth_resync_0_ENET_TX3 1 9 2 3740J 900 4000
preplace netloc axi_uartlite_0_tx 1 10 1 N
preplace netloc microblaze_0_axi_periph_M00_AXI 1 7 3 N 250 N 250 3700
preplace netloc microblaze_0_dlmb_1 1 4 2 N 310 N
preplace netloc eth_resync_0_ENET_TX4 1 9 2 3730J 880 3990
preplace netloc ENET_RX1_1 1 0 9 N 890 N 890 N 890 N 890 N 890 N 890 2120 920 N 920 N
preplace netloc eth_resync_0_ENET_TX5 1 9 2 3710 710 NJ
preplace netloc axi_periph_M04_AXI 1 5 3 1790J -130 NJ -130 2730J
preplace netloc microblaze_0_M_AXI_DP 1 4 3 1270 10 N 10 N
preplace netloc smart_buffer_0_data_out 1 7 1 2990
preplace netloc master_clock_clk_out2 1 2 4 370J 280 690J 220 N 220 1720
preplace netloc eth_resync_0_ENET_TX6 1 9 2 3700J 700 3990
preplace netloc rst_clk_wiz_1_100M_mb_reset 1 3 2 730 240 1260
preplace netloc eth_addr 1 8 2 3350J 1440 3720
preplace netloc axi_periph_M08_AXI 1 5 3 1780J -100 NJ -100 2740J
preplace netloc axi_periph_M07_AXI 1 5 3 1770J -110 NJ -110 2750J
preplace netloc cds_core_d_dout 1 7 1 2860
preplace netloc eth_resync_0_ENET_TX7 1 9 2 3770 920 4010J
preplace netloc leds_gpio_gpio_io_o 1 6 4 NJ 2850 NJ 2850 NJ 2850 N
preplace netloc axi_periph_M10_AXI 1 5 3 1820J -70 NJ -70 2700J
preplace netloc smart_buffer_0_ready_out 1 7 1 3000
preplace netloc rst_clk_wiz_1_100M_bus_struct_reset 1 4 2 1290 370 N
preplace netloc ENET_RX4_1 1 0 9 N 830 N 830 N 830 N 830 N 830 N 830 2150 980 N 980 N
preplace netloc gpio_bits_out0 1 10 1 N
preplace netloc axi_periph_M03_AXI 1 6 2 2340J -60 2680J
preplace netloc spi_ldo_sck_o 1 6 5 2270 1510 NJ 1510 NJ 1510 NJ 1510 NJ
preplace netloc spi_ldo_ss_o 1 6 4 N 1600 N 1600 N 1600 N
preplace netloc gpio_bits_out1 1 10 1 N
preplace netloc axi_periph_M16_AXI 1 6 2 2350 -1950 2810
preplace netloc microblaze_0_ilmb_1 1 4 2 N 330 N
preplace netloc xlconstant_1_dout 1 7 1 N
preplace netloc packer_header_vec2bit_0_dout 1 6 2 2300 -840 2850
preplace netloc spi_volt_sw_io0_o 1 6 5 NJ 3700 NJ 3700 NJ 3700 NJ 3700 N
preplace netloc gpio_bits_out2 1 10 1 N
preplace netloc ENET_RX6_1 1 0 9 -170 -170 N -170 N -170 N -170 N -170 N -170 N -170 N -170 3340
preplace netloc ENET_RXCLK_1 1 0 9 -190 -210 N -210 N -210 N -210 N -210 N -210 N -210 N -210 3390
preplace netloc sequencer_bits_out0 1 9 2 NJ -740 N
preplace netloc gpio_bits_out3 1 10 1 N
preplace netloc sequencer_bits_out1 1 9 2 N -720 NJ
preplace netloc mdm_1_debug_sys_rst 1 3 1 670
preplace netloc gpio_ldo_gpio_io_o 1 6 4 NJ 1970 NJ 1970 NJ 1970 N
preplace netloc gpio_bits_out4 1 10 1 N
preplace netloc USER_CLK_1 1 0 1 N
preplace netloc sequencer_bits_out2 1 9 2 N -700 NJ
preplace netloc ram_eth_doutb 1 8 1 3340
preplace netloc sequencer_bits_out3 1 9 2 N -680 NJ
preplace netloc sequencer_bits_out4 1 9 2 N -660 NJ
preplace netloc sequencer_bits_out5 1 9 2 N -640 NJ
preplace netloc microblaze_0_Clk 1 1 9 140 110 380 290 720 230 N 230 1730 -60 2170 -430 2970 -430 3380 -40 3750
preplace netloc axi_periph_M02_AXI 1 6 2 2350J -50 2670J
preplace netloc cds_core_c_dout 1 7 1 2880
preplace netloc sequencer_bits_out6 1 9 2 N -620 NJ
preplace netloc reset_ctrl_peripheral_reset 1 1 4 150 610 N 610 NJ 610 1260J
preplace netloc axi_periph_M11_AXI 1 5 3 1760J -90 NJ -90 2760J
preplace netloc sequencer_bits_out21 1 6 4 2270 -410 NJ -410 3320J -810 3690
preplace netloc cds_core_d_dout_ready 1 7 1 2870
preplace netloc packer_dout 1 8 1 3360
preplace netloc sequencer_bits_out7 1 9 2 N -600 NJ
preplace netloc TEL_DOUT_1 1 6 5 N 3480 NJ 3480 NJ 3480 NJ 3480 NJ
preplace netloc gpio_telemetry_gpio_io_o 1 6 4 N 3150 NJ 3150 NJ 3150 NJ
preplace netloc ENET_RX5_1 1 0 9 N 810 N 810 N 810 N 810 N 810 N 810 2160 990 N 990 3330
preplace netloc sequencer_bits_out22 1 6 4 2280 -190 NJ -190 3410J -50 3750
preplace netloc sequencer_bits_out8 1 9 2 N -580 NJ
preplace netloc spi_dac_ss_o 1 6 5 N 2620 NJ 2620 NJ 2620 NJ 2620 NJ
preplace netloc sequencer_bits_out23 1 6 4 2290 -1000 NJ -1000 NJ -1000 3710
preplace netloc cds_core_a_dout 1 7 1 2970
preplace netloc cds_core_c_dout_ready 1 7 1 2900
preplace netloc sequencer_bits_out9 1 9 2 N -560 NJ
preplace netloc spi_telemetry_sck_o 1 6 5 N 3500 NJ 3500 NJ 3500 NJ 3500 NJ
preplace netloc util_ds_buf_0_BUFG_O 1 1 1 N
preplace netloc eth_wren 1 8 2 3420J 1470 3740
preplace netloc axi_periph_M06_AXI 1 5 3 1750J -140 NJ -140 2770J
preplace netloc Net 1 5 3 N -2350 2230 -1970 3010
preplace netloc sequencer_bits_out24 1 6 4 2320 -1010 NJ -1010 NJ -1010 3760
preplace netloc spi_dac_sck_o 1 6 5 N 2600 NJ 2600 NJ 2600 NJ 2600 NJ
preplace netloc spi_ldo_io0_o 1 6 5 2170 1490 NJ 1490 NJ 1490 NJ 1490 NJ
preplace netloc eth_resync_0_ENET_GTXCLK 1 9 2 3750J 740 3990
preplace netloc CCD_VDD_DIGPOT_SDO_1 1 9 2 3710 1770 N
preplace netloc eth_resync_0_ENET_TXEN 1 9 2 3740 890 3990J
preplace netloc axi_periph_M14_AXI 1 6 2 2350 -1030 2790
preplace netloc Net1 1 5 3 N -2250 2210 -1980 3020
preplace netloc sequencer_bits_out25 1 6 4 2330 -770 2840J -440 3340J -800 3700
preplace netloc clk_wiz_1_locked 1 2 2 360 310 660
preplace netloc ENET_RX0_1 1 0 9 N 910 N 910 N 910 N 910 N 910 N 910 N 910 3000 900 N
preplace netloc microblaze_0_debug 1 3 1 700
preplace netloc Net2 1 5 3 N -2130 2190 -880 N
preplace netloc sequencer_bits_out26 1 6 4 2310 -180 NJ -180 3400J -60 3690
preplace netloc CCD_VDRAIN_DIGPOT_SDO_1 1 9 2 3690 1750 N
preplace netloc gpio_eth_gpio_io_o 1 7 2 N 1100 N
preplace netloc axi_periph_M05_AXI 1 5 3 1800J -120 NJ -120 2720J
preplace netloc ram_eth_ctrl_BRAM_PORTA 1 7 2 2850 1220 N
preplace netloc Net3 1 5 3 N -2020 2200 -860 N
preplace netloc spi_ldo_mux_ss0_out 1 10 1 NJ
preplace netloc SPARE_SW4_1 1 0 9 NJ 190 140 320 N 320 680 -160 N -160 N -160 N -160 N -160 3320
preplace netloc gpio_dac_gpio_io_o 1 6 4 NJ 2270 NJ 2270 NJ 2270 N
preplace netloc ENET_RX7_1 1 0 9 -180 -200 N -200 N -200 N -200 N -200 N -200 N -200 N -200 3350
preplace netloc Net4 1 5 3 N -1920 2220 -900 2920
preplace netloc eth_resync_0_ENET_TXER 1 9 2 3760 750 NJ
preplace netloc Net5 1 5 3 N -1800 2240 -910 2930
preplace netloc axi_periph_M17_AXI 1 6 2 2340 -890 2800
preplace netloc Net6 1 5 3 N -1680 2250 -1020 2940
preplace netloc spi_telemetry_io0_o 1 6 5 NJ 3460 NJ 3460 NJ 3460 NJ 3460 N
preplace netloc ENET_RXDV_1 1 0 9 N 930 N 930 N 930 N 930 N 930 N 930 N 930 2780 880 N
preplace netloc rst_clk_wiz_1_100M_interconnect_aresetn 1 4 3 1280 50 N 50 N
preplace netloc Net7 1 5 3 N -1580 2260 -1040 2950
preplace netloc DAC_SDO_1 1 6 5 N 2580 N 2580 N 2580 N 2580 N
preplace netloc sequencer_seq_port_out 1 6 3 2120 -400 NJ -400 3410J
preplace netloc VOLT_SW_DOUT_1 1 6 5 N 3720 NJ 3720 NJ 3720 NJ 3720 NJ
preplace netloc spi_dac_io0_o 1 6 5 NJ 2560 NJ 2560 NJ 2560 NJ 2560 N
preplace netloc spi_ldo_mux_ss2_out 1 10 1 NJ
preplace netloc packer_dready 1 8 1 3370
preplace netloc sequencer_bits_out10 1 9 2 N -540 NJ
preplace netloc CCD_VR_DIGPOT_SDO_1 1 9 2 3730 1790 N
preplace netloc sequencer_bits_out11 1 9 2 N -520 NJ
preplace netloc spi_telemetry_ss_o 1 6 5 N 3520 NJ 3520 NJ 3520 NJ 3520 NJ
preplace netloc spi_ldo_mux_ss3_out 1 10 1 NJ
preplace netloc xlconstant_0_dout 1 8 1 3330
preplace netloc sequencer_bits_out12 1 9 2 N -500 NJ
preplace netloc gpio_leds_bits_out0 1 10 1 N
preplace netloc gpio_dac_bits_out0 1 10 1 N
preplace netloc ENET_RX2_1 1 0 9 N 870 N 870 N 870 N 870 N 870 N 870 2130 940 N 940 N
preplace netloc cds_core_b_dout 1 7 1 2910
preplace netloc sequencer_bits_out13 1 9 2 N -480 NJ
preplace netloc gpio_leds_bits_out1 1 10 1 N
preplace netloc eth_clk_125_out 1 8 2 3370J 1450 3690
preplace netloc gpio_dac_bits_out1 1 10 1 N
preplace netloc USB_UART_TX_1 1 10 1 N
preplace netloc axi_periph_M13_AXI 1 7 1 2890J
preplace netloc axi_periph_M01_AXI 1 2 6 390 -150 N -150 N -150 NJ -150 NJ -150 2690J
preplace netloc sequencer_bits_out14 1 9 2 N -460 NJ
preplace netloc gpio_leds_bits_out2 1 10 1 N
preplace netloc gpio_dac_bits_out2 1 10 1 N
preplace netloc spi_ldo_mux_ss1_out 1 10 1 NJ
preplace netloc axi_periph_M18_AXI 1 6 2 2230 -2420 2830
preplace netloc axi_periph_M15_AXI 1 6 2 2340 -1960 2820
preplace netloc axi_periph_M09_AXI 1 5 3 1810J -80 NJ -80 2710J
preplace netloc axi_intc_0_interrupt 1 3 1 710J
preplace netloc cds_core_a_dout_ready 1 7 1 2980
preplace netloc sequencer_bits_out15 1 9 2 N -440 NJ
preplace netloc gpio_leds_bits_out3 1 10 1 N
preplace netloc gpio_dac_bits_out3 1 10 1 N
preplace netloc rst_clk_wiz_1_100M_peripheral_aresetn 1 2 8 390 600 N 600 1280 540 1740 -50 2180 -420 3010 -420 3420 -30 3690
levelinfo -pg 1 -210 20 270 540 1020 1640 1970 2520 3170 3550 3880 4040 -top -2490 -bot 4080
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


