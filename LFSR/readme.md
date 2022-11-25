Generic LFSR in VHDL. poly and seed inputs should better be constants. Design is simulated using GHDL and waveform (lfsr.vcd) can be viewed using gtkwave.<br/>
ghdl -a lfsr_generic.vhd<br/>
ghdl -a tb_lfsr_generic.vhd<br/>
ghdl -e tb_lfsr_generic<br/>
ghdl -r tb_lfsr_generic --vcd=lfsr.vcd<br/>
gtkwave lfsr.vcd<br/>
