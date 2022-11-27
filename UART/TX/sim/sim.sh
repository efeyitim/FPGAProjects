mkdir -p work
ghdl -a --work=work --workdir=work ../src/uart_tx.vhd
ghdl -a --work=work --workdir=work tb_uart_tx.vhd
ghdl -e --work=work --workdir=work tb_uart_tx
ghdl -r --work=work --workdir=work tb_uart_tx --wave=work/sim.ghw
gtkwave work/sim.ghw --save=work/waves.gtkw
