onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group tb /image_proc_tb/r_img_proc
add wave -noupdate -expand -group tb /image_proc_tb/done_flag
add wave -noupdate -expand -group tb /image_proc_tb/clk
add wave -noupdate -expand -group tb /image_proc_tb/rst_n
add wave -noupdate -expand -group tb /image_proc_tb/i_en
add wave -noupdate -expand -group tb /image_proc_tb/i_start
add wave -noupdate -expand -group tb /image_proc_tb/i_opcode
add wave -noupdate -expand -group tb /image_proc_tb/i_data
add wave -noupdate -expand -group tb /image_proc_tb/o_addr
add wave -noupdate -expand -group tb /image_proc_tb/o_addr_valid
add wave -noupdate -expand -group tb /image_proc_tb/o_data
add wave -noupdate -expand -group tb /image_proc_tb/o_data_valid
add wave -noupdate -expand -group tb /image_proc_tb/o_done
add wave -noupdate -expand -group tb /image_proc_tb/i_ram_en
add wave -noupdate -expand -group tb /image_proc_tb/i_read_en
add wave -noupdate -expand -group tb /image_proc_tb/i_write_en
add wave -noupdate -expand -group tb /image_proc_tb/i_ram_addr
add wave -noupdate -expand -group tb /image_proc_tb/i_ram_data
add wave -noupdate -expand -group tb /image_proc_tb/o_ram_data
add wave -noupdate -expand -group tb /image_proc_tb/o_ram_data_valid
add wave -noupdate -expand -group tb /image_proc_tb/data_counter
add wave -noupdate -expand -group tb /image_proc_tb/c_image_row
add wave -noupdate -expand -group tb /image_proc_tb/c_image_col
add wave -noupdate -expand -group tb /image_proc_tb/c_data_length
add wave -noupdate -expand -group tb /image_proc_tb/path_read
add wave -noupdate -expand -group tb /image_proc_tb/path_write
add wave -noupdate -expand -group tb /image_proc_tb/CLK_PERIOD
add wave -noupdate -expand -group tb /image_proc_tb/ram_depth
add wave -noupdate -expand -group tb /image_proc_tb/C_MIRROR
add wave -noupdate -expand -group tb /image_proc_tb/C_REVERSE
add wave -noupdate -expand -group tb /image_proc_tb/C_NEGATIVE
add wave -noupdate -expand -group tb /image_proc_tb/C_THRESHOLD
add wave -noupdate -expand -group tb /image_proc_tb/C_BRIGHTNESS_UP
add wave -noupdate -expand -group tb /image_proc_tb/C_BRIGHTNESS_DOWN
add wave -noupdate -expand -group tb /image_proc_tb/C_CONTRAST_UP
add wave -noupdate -expand -group tb /image_proc_tb/C_CONTRAST_DOWN
add wave -noupdate -group dut /image_proc_tb/DUT/c_image_row
add wave -noupdate -group dut /image_proc_tb/DUT/c_image_col
add wave -noupdate -group dut /image_proc_tb/DUT/c_data_length
add wave -noupdate -group dut /image_proc_tb/DUT/clk
add wave -noupdate -group dut /image_proc_tb/DUT/rst_n
add wave -noupdate -group dut /image_proc_tb/DUT/i_en
add wave -noupdate -group dut /image_proc_tb/DUT/i_start
add wave -noupdate -group dut /image_proc_tb/DUT/i_opcode
add wave -noupdate -group dut /image_proc_tb/DUT/i_data
add wave -noupdate -group dut /image_proc_tb/DUT/i_data_valid
add wave -noupdate -group dut /image_proc_tb/DUT/o_addr
add wave -noupdate -group dut /image_proc_tb/DUT/o_addr_valid
add wave -noupdate -group dut /image_proc_tb/DUT/o_data
add wave -noupdate -group dut /image_proc_tb/DUT/o_data_valid
add wave -noupdate -group dut /image_proc_tb/DUT/o_done
add wave -noupdate -group dut /image_proc_tb/DUT/r_img_proc
add wave -noupdate -group dut /image_proc_tb/DUT/r_i
add wave -noupdate -group dut /image_proc_tb/DUT/r_j
add wave -noupdate -group dut /image_proc_tb/DUT/r_addr
add wave -noupdate -group dut /image_proc_tb/DUT/r_addr_valid
add wave -noupdate -group dut /image_proc_tb/DUT/r_data
add wave -noupdate -group dut /image_proc_tb/DUT/r_data_valid
add wave -noupdate -group dut /image_proc_tb/DUT/r_done
add wave -noupdate -group dut /image_proc_tb/DUT/C_MIRROR
add wave -noupdate -group dut /image_proc_tb/DUT/C_REVERSE
add wave -noupdate -group dut /image_proc_tb/DUT/C_NEGATIVE
add wave -noupdate -group dut /image_proc_tb/DUT/C_THRESHOLD
add wave -noupdate -group dut /image_proc_tb/DUT/C_BRIGHTNESS_UP
add wave -noupdate -group dut /image_proc_tb/DUT/C_BRIGHTNESS_DOWN
add wave -noupdate -group dut /image_proc_tb/DUT/C_CONTRAST_UP
add wave -noupdate -group dut /image_proc_tb/DUT/C_CONTRAST_DOWN
add wave -noupdate -group dut /image_proc_tb/DUT/C_255
add wave -noupdate -group dut /image_proc_tb/DUT/C_45
add wave -noupdate -expand -group ram /image_proc_tb/block_ram_1/clk
add wave -noupdate -expand -group ram /image_proc_tb/block_ram_1/rst_n
add wave -noupdate -expand -group ram /image_proc_tb/block_ram_1/i_en
add wave -noupdate -expand -group ram /image_proc_tb/block_ram_1/i_read_en
add wave -noupdate -expand -group ram /image_proc_tb/block_ram_1/i_write_en
add wave -noupdate -expand -group ram /image_proc_tb/block_ram_1/i_addr
add wave -noupdate -expand -group ram /image_proc_tb/block_ram_1/i_data
add wave -noupdate -expand -group ram /image_proc_tb/block_ram_1/o_data
add wave -noupdate -expand -group ram /image_proc_tb/block_ram_1/o_data_valid
add wave -noupdate -expand -group ram /image_proc_tb/block_ram_1/r_BRAM_DATA
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1310508 ns} 0}
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
configure wave -timelineunits ms
update
WaveRestoreZoom {1310501 ns} {1310835 ns}
