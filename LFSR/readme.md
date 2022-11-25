Generic LFSR in VHDL. poly and seed inputs should better be constants. Design is simulated using GHDL and waveform (lfsr.vcd) can be viewed using gtkwave.
ghdl -a lfsr_generic.vhd
ghdl -a tb_lfsr_generic.vhd
ghdl -e tb_lfsr_generic
ghdl -r tb_lfsr_generic --vcd=lfsr.vcd
gtkwave lfsr.vcd
