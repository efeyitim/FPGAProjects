onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group tb /convolution_tb/clk
add wave -noupdate -expand -group tb /convolution_tb/rst_n
add wave -noupdate -expand -group tb /convolution_tb/i_en
add wave -noupdate -expand -group tb /convolution_tb/i_coef_valid
add wave -noupdate -expand -group tb /convolution_tb/i_coef_addr
add wave -noupdate -expand -group tb /convolution_tb/i_coef_data
add wave -noupdate -expand -group tb /convolution_tb/i_data
add wave -noupdate -expand -group tb /convolution_tb/i_data_valid
add wave -noupdate -expand -group tb -format Analog-Step -height 84 -max 1603776.0 -radix decimal /convolution_tb/o_data
add wave -noupdate -expand -group tb /convolution_tb/o_data_valid
add wave -noupdate -expand -group tb /convolution_tb/o_busy
add wave -noupdate -expand -group tb /convolution_tb/sample_clk
add wave -noupdate -expand -group tb -format Analog-Step -height 84 -max 2071489.9999999998 /convolution_tb/example_data
add wave -noupdate -expand -group tb /convolution_tb/clk_domain
add wave -noupdate -expand -group tb /convolution_tb/last_data
add wave -noupdate -expand -group tb /convolution_tb/r_coef_ctrl
add wave -noupdate -expand -group tb /convolution_tb/r_filter_coef
add wave -noupdate -expand -group tb /convolution_tb/coef_load
add wave -noupdate -expand -group tb /convolution_tb/i
add wave -noupdate -expand -group dut /convolution_tb/DUT/clk
add wave -noupdate -expand -group dut /convolution_tb/DUT/rst_n
add wave -noupdate -expand -group dut /convolution_tb/DUT/i_en
add wave -noupdate -expand -group dut /convolution_tb/DUT/i_coef_valid
add wave -noupdate -expand -group dut /convolution_tb/DUT/i_coef_addr
add wave -noupdate -expand -group dut /convolution_tb/DUT/i_coef_data
add wave -noupdate -expand -group dut /convolution_tb/DUT/i_data
add wave -noupdate -expand -group dut /convolution_tb/DUT/i_data_valid
add wave -noupdate -expand -group dut /convolution_tb/DUT/o_data
add wave -noupdate -expand -group dut /convolution_tb/DUT/o_data_valid
add wave -noupdate -expand -group dut /convolution_tb/DUT/o_busy
add wave -noupdate -expand -group dut /convolution_tb/DUT/r_shift_ctrl
add wave -noupdate -expand -group dut /convolution_tb/DUT/r_filter_calc
add wave -noupdate -expand -group dut /convolution_tb/DUT/r_coef_ram
add wave -noupdate -expand -group dut /convolution_tb/DUT/r_data_ram
add wave -noupdate -expand -group dut /convolution_tb/DUT/r_calc_start
add wave -noupdate -expand -group dut /convolution_tb/DUT/r_data
add wave -noupdate -expand -group dut /convolution_tb/DUT/r_sum
add wave -noupdate -expand -group dut /convolution_tb/DUT/r_data_out
add wave -noupdate -expand -group dut /convolution_tb/DUT/r_data_out_valid
add wave -noupdate -expand -group dut /convolution_tb/DUT/r_busy
add wave -noupdate -expand -group dut /convolution_tb/DUT/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {499305000 ns} 0}
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
WaveRestoreZoom {0 ns} {2100005250 ns}
