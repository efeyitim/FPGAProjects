onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /multiplicator_tb/DUT/clk
add wave -noupdate /multiplicator_tb/DUT/rst_n
add wave -noupdate /multiplicator_tb/DUT/en
add wave -noupdate /multiplicator_tb/DUT/multiplicand
add wave -noupdate /multiplicator_tb/DUT/multiplier
add wave -noupdate /multiplicator_tb/DUT/product
add wave -noupdate /multiplicator_tb/DUT/busy
add wave -noupdate /multiplicator_tb/DUT/done
add wave -noupdate /multiplicator_tb/DUT/en_buf
add wave -noupdate /multiplicator_tb/DUT/en_redge
add wave -noupdate /multiplicator_tb/DUT/state
add wave -noupdate /multiplicator_tb/DUT/accumulator
add wave -noupdate /multiplicator_tb/DUT/multiplier_buf
add wave -noupdate /multiplicator_tb/DUT/multiplicand_buf
add wave -noupdate /multiplicator_tb/DUT/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {97 ns} 0}
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
WaveRestoreZoom {0 ns} {1 us}
