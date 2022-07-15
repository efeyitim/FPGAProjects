vcom -work work -2002 -explicit -vopt -stats=none ../src/divisor.vhd

vcom -work work -2002 -explicit -vopt -stats=none ./divisor_tb.vhd

vsim work.divisor_tb -voptargs=+acc

do wave.do

run 5 us



