onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_axi4_lite_slave/U_DUT/S_AXI_ACLK
add wave -noupdate /tb_axi4_lite_slave/U_DUT/S_AXI_ARESETN
add wave -noupdate -group registers /tb_axi4_lite_slave/U_DUT/reg1
add wave -noupdate -group registers /tb_axi4_lite_slave/U_DUT/reg2
add wave -noupdate -group registers /tb_axi4_lite_slave/U_DUT/reg3
add wave -noupdate -group registers /tb_axi4_lite_slave/U_DUT/reg4
add wave -noupdate -group AR /tb_axi4_lite_slave/U_DUT/S_AXI_ARVALID
add wave -noupdate -group AR /tb_axi4_lite_slave/U_DUT/S_AXI_ARREADY
add wave -noupdate -group AR /tb_axi4_lite_slave/U_DUT/S_AXI_ARADDR
add wave -noupdate -group AR /tb_axi4_lite_slave/U_DUT/S_AXI_ARPROT
add wave -noupdate -group AW /tb_axi4_lite_slave/U_DUT/S_AXI_AWVALID
add wave -noupdate -group AW /tb_axi4_lite_slave/U_DUT/S_AXI_AWREADY
add wave -noupdate -group AW /tb_axi4_lite_slave/U_DUT/S_AXI_AWADDR
add wave -noupdate -group AW /tb_axi4_lite_slave/U_DUT/S_AXI_AWPROT
add wave -noupdate -group B /tb_axi4_lite_slave/U_DUT/S_AXI_BVALID
add wave -noupdate -group B /tb_axi4_lite_slave/U_DUT/S_AXI_BREADY
add wave -noupdate -group B /tb_axi4_lite_slave/U_DUT/S_AXI_BRESP
add wave -noupdate -group R /tb_axi4_lite_slave/U_DUT/S_AXI_RVALID
add wave -noupdate -group R /tb_axi4_lite_slave/U_DUT/S_AXI_RREADY
add wave -noupdate -group R /tb_axi4_lite_slave/U_DUT/S_AXI_RDATA
add wave -noupdate -group R /tb_axi4_lite_slave/U_DUT/S_AXI_RRESP
add wave -noupdate -group W /tb_axi4_lite_slave/U_DUT/S_AXI_WVALID
add wave -noupdate -group W /tb_axi4_lite_slave/U_DUT/S_AXI_WREADY
add wave -noupdate -group W /tb_axi4_lite_slave/U_DUT/S_AXI_WDATA
add wave -noupdate -group W /tb_axi4_lite_slave/U_DUT/S_AXI_WSTRB
add wave -noupdate -group READ /tb_axi4_lite_slave/U_DUT/axi_araddr
add wave -noupdate -group READ /tb_axi4_lite_slave/U_DUT/axi_arready
add wave -noupdate -group READ /tb_axi4_lite_slave/U_DUT/axi_rdata
add wave -noupdate -group READ /tb_axi4_lite_slave/U_DUT/axi_rresp
add wave -noupdate -group READ /tb_axi4_lite_slave/U_DUT/axi_rvalid
add wave -noupdate -group READ /tb_axi4_lite_slave/U_DUT/read_state
add wave -noupdate -group WRITE /tb_axi4_lite_slave/U_DUT/axi_awaddr
add wave -noupdate -group WRITE /tb_axi4_lite_slave/U_DUT/axi_awready
add wave -noupdate -group WRITE /tb_axi4_lite_slave/U_DUT/axi_wdata
add wave -noupdate -group WRITE /tb_axi4_lite_slave/U_DUT/axi_wready
add wave -noupdate -group WRITE /tb_axi4_lite_slave/U_DUT/axi_bresp
add wave -noupdate -group WRITE /tb_axi4_lite_slave/U_DUT/axi_bvalid
add wave -noupdate -group WRITE /tb_axi4_lite_slave/U_DUT/write_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {134 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
