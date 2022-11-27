mkdir -p work
ghdl -a --work=work --workdir=work ../src/uart_rx.vhd
ghdl -a --work=work --workdir=work tb_uart_rx.vhd
ghdl -e --work=work --workdir=work tb_uart_rx
ghdl -r --work=work --workdir=work tb_uart_rx --wave=work/sim.ghw
gtkwave work/sim.ghw
