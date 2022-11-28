mkdir -p work
ghdl -a --work=work --workdir=work ../src/glitch_filter.vhd
ghdl -a --work=work --workdir=work tb_glitch_filter.vhd
ghdl -e --work=work --workdir=work tb_glitch_filter
ghdl -r --work=work --workdir=work tb_glitch_filter --wave=work/sim.ghw
gtkwave work/sim.ghw --save=work/waves.gtkw
