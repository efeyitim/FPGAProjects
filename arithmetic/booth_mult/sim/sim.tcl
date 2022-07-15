vcom -work work -2002 -explicit -vopt -stats=none ../src/multiplicator.vhd

vcom -work work -2002 -explicit -vopt -stats=none ./multiplicator_tb.vhd

vsim work.multiplicator_tb -voptargs=+acc

do wave.do

run 5 us



