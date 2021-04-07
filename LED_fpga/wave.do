onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group tb /tb/clk
add wave -noupdate -expand -group tb /tb/button
add wave -noupdate -expand -group tb /tb/LEDs
add wave -noupdate -expand -group tb /tb/segments
add wave -noupdate -expand -group tb /tb/others
add wave -noupdate -expand -group dut /tb/dut/clk
add wave -noupdate -expand -group dut /tb/dut/button
add wave -noupdate -expand -group dut /tb/dut/LEDs
add wave -noupdate -expand -group dut /tb/dut/segments
add wave -noupdate -expand -group dut /tb/dut/others
add wave -noupdate -expand -group dut /tb/dut/STATE
add wave -noupdate -expand -group dut /tb/dut/NEXT
add wave -noupdate -expand -group dut /tb/dut/count
add wave -noupdate -expand -group dut /tb/dut/count_max
add wave -noupdate -expand -group dut /tb/dut/debounce_count
add wave -noupdate -expand -group dut /tb/dut/button_prev
add wave -noupdate -expand -group dut /tb/dut/debounce_control
add wave -noupdate -expand -group dut /tb/dut/debounce_done
add wave -noupdate -expand -group dut /tb/dut/debounce_success
add wave -noupdate -expand -group dut /tb/dut/button_state
add wave -noupdate -expand -group dut /tb/dut/button_pulse
add wave -noupdate -expand -group dut /tb/dut/button_press
add wave -noupdate -expand -group dut /tb/dut/button_release
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1218 ns} 0}
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
WaveRestoreZoom {0 ns} {291 ns}
