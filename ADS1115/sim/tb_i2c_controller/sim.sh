mkdir -p work
ghdl -a --work=work --workdir=work ../../../../../ip_repo/I2C_MASTER/src/i2c_interface.vhd
ghdl -a --work=work --workdir=work ../../src/i2c_controller_ads1115.vhd
ghdl -a --work=work --workdir=work tb_i2c_interface.vhd
ghdl -e --work=work --workdir=work tb_i2c_interface
ghdl -r --work=work --workdir=work tb_i2c_interface --wave=work/sim.ghw
gtkwave work/sim.ghw --save=work/waves.gtkw
