mkdir -p work
ghdl -a --work=work --workdir=work ../src/sync_fifo.vhd
ghdl -a --work=work --workdir=work tb_sync_fifo.vhd
ghdl -e --work=work --workdir=work tb_sync_fifo
ghdl -r --work=work --workdir=work tb_sync_fifo --wave=work/sim.ghw
gtkwave work/sim.ghw --save=work/waves.gtkw
