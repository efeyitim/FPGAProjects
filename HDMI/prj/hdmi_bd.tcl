
################################################################
# This is a generated script based on design: hdmi_bd
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
# source hdmi_bd_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# axi_dynclk, axi_dynclk_conf, cdc_single_bit, dvi_test_pattern_gen, dvi_timing_gen, glitch_filter, glitch_filter, glitch_filter, glitch_filter, glitch_filter, leds, output_serdes, output_serdes, output_serdes, output_serdes, res_controller, res_update_cdc, reset_sync, reset_sync, reset_sync, tmds_encoder, tmds_encoder, tmds_encoder

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z010clg400-1
   set_property BOARD_PART digilentinc.com:zybo:part0:2.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name hdmi_bd

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
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:system_ila:1.1\
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

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
axi_dynclk\
axi_dynclk_conf\
cdc_single_bit\
dvi_test_pattern_gen\
dvi_timing_gen\
glitch_filter\
glitch_filter\
glitch_filter\
glitch_filter\
glitch_filter\
leds\
output_serdes\
output_serdes\
output_serdes\
output_serdes\
res_controller\
res_update_cdc\
reset_sync\
reset_sync\
reset_sync\
tmds_encoder\
tmds_encoder\
tmds_encoder\
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
  set HDMI_OUT_EN [ create_bd_port -dir O -from 0 -to 0 HDMI_OUT_EN ]
  set button0 [ create_bd_port -dir I button0 ]
  set hdmi_clk_n [ create_bd_port -dir O hdmi_clk_n ]
  set hdmi_clk_p [ create_bd_port -dir O hdmi_clk_p ]
  set hdmi_d0_n [ create_bd_port -dir O hdmi_d0_n ]
  set hdmi_d0_p [ create_bd_port -dir O hdmi_d0_p ]
  set hdmi_d1_n [ create_bd_port -dir O hdmi_d1_n ]
  set hdmi_d1_p [ create_bd_port -dir O hdmi_d1_p ]
  set hdmi_d2_n [ create_bd_port -dir O hdmi_d2_n ]
  set hdmi_d2_p [ create_bd_port -dir O hdmi_d2_p ]
  set leds [ create_bd_port -dir O -from 3 -to 0 leds ]
  set switch0 [ create_bd_port -dir I switch0 ]
  set switch1 [ create_bd_port -dir I switch1 ]
  set switch2 [ create_bd_port -dir I switch2 ]
  set switch3 [ create_bd_port -dir I switch3 ]
  set sysclk [ create_bd_port -dir I -type clk sysclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $sysclk

  # Create instance: axi_dynclk_0, and set properties
  set block_name axi_dynclk
  set block_cell_name axi_dynclk_0
  if { [catch {set axi_dynclk_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_dynclk_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_dynclk_conf_0, and set properties
  set block_name axi_dynclk_conf
  set block_cell_name axi_dynclk_conf_0
  if { [catch {set axi_dynclk_conf_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_dynclk_conf_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: cdc_single_bit_0, and set properties
  set block_name cdc_single_bit
  set block_cell_name cdc_single_bit_0
  if { [catch {set cdc_single_bit_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $cdc_single_bit_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {80.0} \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {237.312} \
   CONFIG.CLKOUT1_PHASE_ERROR {249.865} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
   CONFIG.CLKOUT2_DRIVES {BUFG} \
   CONFIG.CLKOUT2_JITTER {237.312} \
   CONFIG.CLKOUT2_PHASE_ERROR {249.865} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {742.5} \
   CONFIG.CLKOUT2_USED {false} \
   CONFIG.CLKOUT3_DRIVES {BUFG} \
   CONFIG.CLKOUT4_DRIVES {BUFG} \
   CONFIG.CLKOUT5_DRIVES {BUFG} \
   CONFIG.CLKOUT6_DRIVES {BUFG} \
   CONFIG.CLKOUT7_DRIVES {BUFG} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} \
   CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {36} \
   CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {9} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {1} \
   CONFIG.MMCM_COMPENSATION {ZHOLD} \
   CONFIG.MMCM_DIVCLK_DIVIDE {5} \
   CONFIG.NUM_OUT_CLKS {1} \
   CONFIG.OVERRIDE_MMCM {false} \
   CONFIG.PRIMITIVE {PLL} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: dvi_test_pattern_gen_0, and set properties
  set block_name dvi_test_pattern_gen
  set block_cell_name dvi_test_pattern_gen_0
  if { [catch {set dvi_test_pattern_gen_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dvi_test_pattern_gen_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: dvi_timing_gen_0, and set properties
  set block_name dvi_timing_gen
  set block_cell_name dvi_timing_gen_0
  if { [catch {set dvi_timing_gen_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dvi_timing_gen_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: glitch_filter_0, and set properties
  set block_name glitch_filter
  set block_cell_name glitch_filter_0
  if { [catch {set glitch_filter_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $glitch_filter_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.NUM_CYCLE {5000000} \
 ] $glitch_filter_0

  # Create instance: glitch_filter_1, and set properties
  set block_name glitch_filter
  set block_cell_name glitch_filter_1
  if { [catch {set glitch_filter_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $glitch_filter_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.NUM_CYCLE {5000000} \
 ] $glitch_filter_1

  # Create instance: glitch_filter_2, and set properties
  set block_name glitch_filter
  set block_cell_name glitch_filter_2
  if { [catch {set glitch_filter_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $glitch_filter_2 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.NUM_CYCLE {5000000} \
 ] $glitch_filter_2

  # Create instance: glitch_filter_3, and set properties
  set block_name glitch_filter
  set block_cell_name glitch_filter_3
  if { [catch {set glitch_filter_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $glitch_filter_3 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: glitch_filter_4, and set properties
  set block_name glitch_filter
  set block_cell_name glitch_filter_4
  if { [catch {set glitch_filter_4 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $glitch_filter_4 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: leds_0, and set properties
  set block_name leds
  set block_cell_name leds_0
  if { [catch {set leds_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $leds_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: output_serdes_0, and set properties
  set block_name output_serdes
  set block_cell_name output_serdes_0
  if { [catch {set output_serdes_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $output_serdes_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: output_serdes_1, and set properties
  set block_name output_serdes
  set block_cell_name output_serdes_1
  if { [catch {set output_serdes_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $output_serdes_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: output_serdes_2, and set properties
  set block_name output_serdes
  set block_cell_name output_serdes_2
  if { [catch {set output_serdes_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $output_serdes_2 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: output_serdes_3, and set properties
  set block_name output_serdes
  set block_cell_name output_serdes_3
  if { [catch {set output_serdes_3 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $output_serdes_3 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: res_controller_0, and set properties
  set block_name res_controller
  set block_cell_name res_controller_0
  if { [catch {set res_controller_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $res_controller_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: res_update_cdc_0, and set properties
  set block_name res_update_cdc
  set block_cell_name res_update_cdc_0
  if { [catch {set res_update_cdc_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $res_update_cdc_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: reset_sync_0, and set properties
  set block_name reset_sync
  set block_cell_name reset_sync_0
  if { [catch {set reset_sync_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $reset_sync_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: reset_sync_1, and set properties
  set block_name reset_sync
  set block_cell_name reset_sync_1
  if { [catch {set reset_sync_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $reset_sync_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: reset_sync_2, and set properties
  set block_name reset_sync
  set block_cell_name reset_sync_2
  if { [catch {set reset_sync_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $reset_sync_2 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_MON_TYPE {NATIVE} \
   CONFIG.C_NUM_OF_PROBES {5} \
   CONFIG.C_PROBE0_TYPE {0} \
   CONFIG.C_PROBE1_TYPE {0} \
   CONFIG.C_PROBE2_TYPE {0} \
   CONFIG.C_PROBE3_TYPE {0} \
   CONFIG.C_PROBE4_TYPE {0} \
 ] $system_ila_0

  # Create instance: tmds_encoder_0, and set properties
  set block_name tmds_encoder
  set block_cell_name tmds_encoder_0
  if { [catch {set tmds_encoder_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $tmds_encoder_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: tmds_encoder_1, and set properties
  set block_name tmds_encoder
  set block_cell_name tmds_encoder_1
  if { [catch {set tmds_encoder_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $tmds_encoder_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CH_NUM {1} \
 ] $tmds_encoder_1

  # Create instance: tmds_encoder_2, and set properties
  set block_name tmds_encoder
  set block_cell_name tmds_encoder_2
  if { [catch {set tmds_encoder_2 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $tmds_encoder_2 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.CH_NUM {2} \
 ] $tmds_encoder_2

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {2} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {4} \
 ] $xlconstant_3

  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]

  # Create instance: xlconstant_5, and set properties
  set xlconstant_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_5 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {992} \
   CONFIG.CONST_WIDTH {10} \
 ] $xlconstant_5

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {8} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {16} \
   CONFIG.DIN_WIDTH {24} \
   CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_2

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dynclk_conf_0_axi [get_bd_intf_pins axi_dynclk_0/s00_axi] [get_bd_intf_pins axi_dynclk_conf_0/axi]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins dvi_test_pattern_gen_0/active] [get_bd_pins dvi_timing_gen_0/active]
  connect_bd_net -net Net1 [get_bd_pins dvi_test_pattern_gen_0/rst_n] [get_bd_pins dvi_timing_gen_0/rst_n_out] [get_bd_pins output_serdes_0/rst_n] [get_bd_pins output_serdes_1/rst_n] [get_bd_pins output_serdes_2/rst_n] [get_bd_pins output_serdes_3/rst_n] [get_bd_pins tmds_encoder_0/rst_n] [get_bd_pins tmds_encoder_1/rst_n] [get_bd_pins tmds_encoder_2/rst_n]
  connect_bd_net -net Net2 [get_bd_pins dvi_test_pattern_gen_0/active_out] [get_bd_pins tmds_encoder_0/active] [get_bd_pins tmds_encoder_1/active] [get_bd_pins tmds_encoder_2/active]
  connect_bd_net -net Net3 [get_bd_pins glitch_filter_0/rst_n] [get_bd_pins glitch_filter_1/rst_n] [get_bd_pins glitch_filter_2/rst_n] [get_bd_pins reset_sync_2/rst_n]
  connect_bd_net -net Net4 [get_bd_pins axi_dynclk_0/PXL_CLK_5X_O] [get_bd_pins output_serdes_0/clk_serial] [get_bd_pins output_serdes_1/clk_serial] [get_bd_pins output_serdes_2/clk_serial] [get_bd_pins output_serdes_3/clk_serial]
  connect_bd_net -net axi_dynclk_0_LOCKED_O [get_bd_pins axi_dynclk_0/LOCKED_O] [get_bd_pins res_update_cdc_0/locked] [get_bd_pins reset_sync_1/async_rst_n] [get_bd_pins system_ila_0/probe2]
  set_property -dict [ list \
HDL_ATTRIBUTE.DEBUG {true} \
 ] [get_bd_nets axi_dynclk_0_LOCKED_O]
  connect_bd_net -net cdc_single_bit_0_dout [get_bd_pins cdc_single_bit_0/dout] [get_bd_pins dvi_timing_gen_0/format_upd]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins axi_dynclk_0/PXL_CLK_O] [get_bd_pins cdc_single_bit_0/clk] [get_bd_pins dvi_test_pattern_gen_0/clk_pixel] [get_bd_pins dvi_timing_gen_0/clk_pixel] [get_bd_pins glitch_filter_0/clk] [get_bd_pins glitch_filter_1/clk] [get_bd_pins glitch_filter_2/clk] [get_bd_pins glitch_filter_3/clk] [get_bd_pins leds_0/clk] [get_bd_pins output_serdes_0/clk_pixel] [get_bd_pins output_serdes_1/clk_pixel] [get_bd_pins output_serdes_2/clk_pixel] [get_bd_pins output_serdes_3/clk_pixel] [get_bd_pins reset_sync_1/clk] [get_bd_pins reset_sync_2/clk] [get_bd_pins tmds_encoder_0/clk_pixel] [get_bd_pins tmds_encoder_1/clk_pixel] [get_bd_pins tmds_encoder_2/clk_pixel]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins axi_dynclk_0/REF_CLK_I] [get_bd_pins axi_dynclk_0/s00_axi_aclk] [get_bd_pins axi_dynclk_conf_0/axi_aclk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins glitch_filter_4/clk] [get_bd_pins res_controller_0/clk] [get_bd_pins res_update_cdc_0/clk] [get_bd_pins reset_sync_0/clk] [get_bd_pins system_ila_0/clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins reset_sync_0/async_rst_n] [get_bd_pins reset_sync_2/async_rst_n]
  connect_bd_net -net din_0_1 [get_bd_ports switch0] [get_bd_pins glitch_filter_0/din]
  connect_bd_net -net din_0_2 [get_bd_ports switch2] [get_bd_pins glitch_filter_2/din]
  connect_bd_net -net din_0_3 [get_bd_ports switch3] [get_bd_pins glitch_filter_3/din]
  connect_bd_net -net din_0_4 [get_bd_ports button0] [get_bd_pins glitch_filter_4/din]
  connect_bd_net -net din_1_1 [get_bd_ports switch1] [get_bd_pins glitch_filter_1/din]
  connect_bd_net -net dvi_test_pattern_gen_0_rgb [get_bd_pins dvi_test_pattern_gen_0/rgb] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net dvi_timing_gen_0_act_line_num [get_bd_pins dvi_test_pattern_gen_0/act_line_num] [get_bd_pins dvi_timing_gen_0/act_line_num]
  connect_bd_net -net dvi_timing_gen_0_act_pixel_num [get_bd_pins dvi_test_pattern_gen_0/act_pixel_num] [get_bd_pins dvi_timing_gen_0/act_pixel_num]
  connect_bd_net -net dvi_timing_gen_0_hsync [get_bd_pins dvi_test_pattern_gen_0/hsync] [get_bd_pins dvi_timing_gen_0/hsync] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net dvi_timing_gen_0_vsync [get_bd_pins dvi_test_pattern_gen_0/vsync] [get_bd_pins dvi_timing_gen_0/vsync] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net glitch_filter_0_dout [get_bd_pins glitch_filter_0/dout] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net glitch_filter_1_dout [get_bd_pins glitch_filter_1/dout] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net glitch_filter_2_dout [get_bd_pins glitch_filter_2/dout] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net glitch_filter_3_dout [get_bd_pins dvi_test_pattern_gen_0/box_en] [get_bd_pins glitch_filter_3/dout]
  connect_bd_net -net glitch_filter_4_dout [get_bd_pins glitch_filter_4/dout] [get_bd_pins res_controller_0/button]
  connect_bd_net -net leds_0_leds [get_bd_ports leds] [get_bd_pins leds_0/leds_o]
  connect_bd_net -net output_serdes_0_sout_n [get_bd_ports hdmi_d0_n] [get_bd_pins output_serdes_0/sout_n]
  connect_bd_net -net output_serdes_0_sout_p [get_bd_ports hdmi_d0_p] [get_bd_pins output_serdes_0/sout_p]
  connect_bd_net -net output_serdes_1_sout_n [get_bd_ports hdmi_d1_n] [get_bd_pins output_serdes_1/sout_n]
  connect_bd_net -net output_serdes_1_sout_p [get_bd_ports hdmi_d1_p] [get_bd_pins output_serdes_1/sout_p]
  connect_bd_net -net output_serdes_2_sout_n [get_bd_ports hdmi_d2_n] [get_bd_pins output_serdes_2/sout_n]
  connect_bd_net -net output_serdes_2_sout_p [get_bd_ports hdmi_d2_p] [get_bd_pins output_serdes_2/sout_p]
  connect_bd_net -net output_serdes_3_sout_n [get_bd_ports hdmi_clk_n] [get_bd_pins output_serdes_3/sout_n]
  connect_bd_net -net output_serdes_3_sout_p [get_bd_ports hdmi_clk_p] [get_bd_pins output_serdes_3/sout_p]
  connect_bd_net -net res_controller_0_res_sel [get_bd_pins axi_dynclk_conf_0/res_sel] [get_bd_pins res_controller_0/res_sel] [get_bd_pins res_update_cdc_0/res_sel_in] [get_bd_pins system_ila_0/probe1]
  set_property -dict [ list \
HDL_ATTRIBUTE.DEBUG {true} \
 ] [get_bd_nets res_controller_0_res_sel]
  connect_bd_net -net res_controller_0_res_upd [get_bd_pins axi_dynclk_conf_0/res_upd] [get_bd_pins res_controller_0/res_upd] [get_bd_pins res_update_cdc_0/res_update_in] [get_bd_pins system_ila_0/probe0]
  set_property -dict [ list \
HDL_ATTRIBUTE.DEBUG {true} \
 ] [get_bd_nets res_controller_0_res_upd]
  connect_bd_net -net res_update_cdc_0_res_sel_out [get_bd_pins dvi_timing_gen_0/format_sel] [get_bd_pins res_update_cdc_0/res_sel_out] [get_bd_pins system_ila_0/probe4]
  set_property -dict [ list \
HDL_ATTRIBUTE.DEBUG {true} \
 ] [get_bd_nets res_update_cdc_0_res_sel_out]
  connect_bd_net -net res_update_cdc_0_res_update_out [get_bd_pins cdc_single_bit_0/din] [get_bd_pins res_update_cdc_0/res_update_out] [get_bd_pins system_ila_0/probe3]
  set_property -dict [ list \
HDL_ATTRIBUTE.DEBUG {true} \
 ] [get_bd_nets res_update_cdc_0_res_update_out]
  connect_bd_net -net reset_sync_0_rst_n [get_bd_pins cdc_single_bit_0/rst_n] [get_bd_pins dvi_timing_gen_0/rst_n] [get_bd_pins glitch_filter_3/rst_n] [get_bd_pins leds_0/rst_n] [get_bd_pins reset_sync_1/rst_n]
  connect_bd_net -net reset_sync_0_rst_n1 [get_bd_pins axi_dynclk_0/s00_axi_aresetn] [get_bd_pins axi_dynclk_conf_0/axi_aresetn] [get_bd_pins glitch_filter_4/rst_n] [get_bd_pins res_controller_0/rst_n] [get_bd_pins res_update_cdc_0/rst_n] [get_bd_pins reset_sync_0/rst_n]
  connect_bd_net -net sysclk [get_bd_ports sysclk] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net tmds_encoder_0_tmds [get_bd_pins output_serdes_0/pin] [get_bd_pins tmds_encoder_0/tmds]
  connect_bd_net -net tmds_encoder_1_tmds [get_bd_pins output_serdes_1/pin] [get_bd_pins tmds_encoder_1/tmds]
  connect_bd_net -net tmds_encoder_2_tmds [get_bd_pins output_serdes_2/pin] [get_bd_pins tmds_encoder_2/tmds]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins dvi_test_pattern_gen_0/tp_sel] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins tmds_encoder_0/ctrl_data] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins tmds_encoder_1/ctrl_data] [get_bd_pins tmds_encoder_2/ctrl_data] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins tmds_encoder_0/aux_data] [get_bd_pins tmds_encoder_1/aux_data] [get_bd_pins tmds_encoder_2/aux_data] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_4_dout [get_bd_ports HDMI_OUT_EN] [get_bd_pins xlconstant_4/dout]
  connect_bd_net -net xlconstant_5_dout [get_bd_pins output_serdes_3/pin] [get_bd_pins xlconstant_5/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins tmds_encoder_0/video_data] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins tmds_encoder_1/video_data] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins tmds_encoder_2/video_data] [get_bd_pins xlslice_2/Dout]

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


