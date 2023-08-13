set_property PACKAGE_PIN M14 [get_ports {leds[0]}]
set_property PACKAGE_PIN M15 [get_ports {leds[1]}]
set_property PACKAGE_PIN G14 [get_ports {leds[2]}]
set_property PACKAGE_PIN D18 [get_ports {leds[3]}]
set_property PACKAGE_PIN G15 [get_ports switch0]
set_property PACKAGE_PIN P15 [get_ports switch1]
set_property PACKAGE_PIN W13 [get_ports switch2]
set_property PACKAGE_PIN T16 [get_ports switch3]
set_property PACKAGE_PIN R18 [get_ports button0]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_d0_p]
set_property PACKAGE_PIN D19 [get_ports hdmi_d0_p]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_d1_p]
set_property PACKAGE_PIN C20 [get_ports hdmi_d1_p]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_d2_p]
set_property PACKAGE_PIN B19 [get_ports hdmi_d2_p]
set_property IOSTANDARD LVCMOS33 [get_ports sysclk]
set_property IOSTANDARD TMDS_33 [get_ports hdmi_clk_p]
set_property PACKAGE_PIN H16 [get_ports hdmi_clk_p]
set_property IOSTANDARD LVTTL [get_ports {leds[2]}]
set_property IOSTANDARD LVTTL [get_ports {leds[3]}]
set_property IOSTANDARD LVTTL [get_ports {leds[1]}]
set_property IOSTANDARD LVTTL [get_ports {leds[0]}]
set_property IOSTANDARD LVTTL [get_ports switch0]
set_property IOSTANDARD LVTTL [get_ports switch1]
set_property IOSTANDARD LVTTL [get_ports switch2]
set_property IOSTANDARD LVTTL [get_ports switch3]
set_property IOSTANDARD LVTTL [get_ports button0]

set_property PACKAGE_PIN F17 [get_ports {HDMI_OUT_EN[0]}]
set_property IOSTANDARD LVTTL [get_ports {HDMI_OUT_EN[0]}]






create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list hdmi_bd_i/axi_dynclk_0/U0/PXL_CLK_O]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 12 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_h[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_h[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_h[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_h[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_h[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_h[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_h[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_h[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_h[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_h[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_h[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_h[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 24 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[11]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[12]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[13]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[14]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[15]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[16]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[17]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[18]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[19]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[20]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[21]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[22]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/rgb[23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 12 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/pixel_counter[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/pixel_counter[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/pixel_counter[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/pixel_counter[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/pixel_counter[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/pixel_counter[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/pixel_counter[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/pixel_counter[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/pixel_counter[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/pixel_counter[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/pixel_counter[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/pixel_counter[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 12 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/line_counter[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/line_counter[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/line_counter[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/line_counter[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/line_counter[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/line_counter[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/line_counter[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/line_counter[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/line_counter[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/line_counter[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/line_counter[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/line_counter[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 12 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_v[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_v[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_v[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_v[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_v[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_v[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_v[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_v[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_v[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_v[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_v[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_v[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 12 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_h[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_h[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_h[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_h[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_h[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_h[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_h[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_h[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_h[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_h[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_h[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fourth_bar_limit_h[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 12 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_v[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_v[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_v[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_v[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_v[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_v[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_v[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_v[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_v[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_v[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_v[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_v[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 12 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_h[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_h[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_h[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_h[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_h[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_h[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_h[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_h[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_h[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_h[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_h[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/first_bar_limit_h[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 12 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_v[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_v[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_v[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_v[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_v[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_v[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_v[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_v[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_v[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_v[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_v[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_v[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 12 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_h[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_h[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_h[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_h[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_h[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_h[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_h[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_h[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_h[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_h[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_h[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/fifth_bar_limit_h[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 12 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_low[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_low[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_low[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_low[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_low[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_low[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_low[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_low[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_low[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_low[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_low[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_low[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 12 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_high[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_high[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_high[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_high[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_high[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_high[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_high[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_high[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_high[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_high[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_high[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_lim_high[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 12 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_low[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_low[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_low[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_low[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_low[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_low[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_low[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_low[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_low[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_low[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_low[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_low[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 12 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_high[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_high[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_high[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_high[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_high[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_high[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_high[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_high[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_high[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_high[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_high[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_lim_high[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 12 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_v[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_v[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_v[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_v[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_v[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_v[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_v[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_v[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_v[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_v[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_v[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/second_bar_limit_v[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 12 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_h[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_h[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_h[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_h[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_h[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_h[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_h[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_h[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_h[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_h[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_h[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_h[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 12 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_v[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_v[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_v[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_v[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_v[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_v[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_v[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_v[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_v[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_v[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_v[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/seventh_bar_limit_v[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 12 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_h[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_h[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_h[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_h[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_h[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_h[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_h[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_h[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_h[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_h[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_h[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_h[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 12 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_v[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_v[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_v[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_v[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_v[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_v[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_v[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_v[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_v[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_v[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_v[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/sixth_bar_limit_v[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 12 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {hdmi_bd_i/dvi_timing_gen_0/U0/v_active_video[0]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_active_video[1]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_active_video[2]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_active_video[3]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_active_video[4]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_active_video[5]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_active_video[6]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_active_video[7]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_active_video[8]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_active_video[9]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_active_video[10]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_active_video[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 12 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_h[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_h[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_h[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_h[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_h[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_h[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_h[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_h[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_h[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_h[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_h[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_h[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 12 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_v[0]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_v[1]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_v[2]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_v[3]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_v[4]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_v[5]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_v[6]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_v[7]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_v[8]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_v[9]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_v[10]} {hdmi_bd_i/dvi_test_pattern_gen_0/U0/third_bar_limit_v[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 12 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {hdmi_bd_i/dvi_timing_gen_0/U0/v_back_porch[0]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_back_porch[1]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_back_porch[2]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_back_porch[3]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_back_porch[4]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_back_porch[5]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_back_porch[6]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_back_porch[7]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_back_porch[8]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_back_porch[9]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_back_porch[10]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_back_porch[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 12 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {hdmi_bd_i/dvi_timing_gen_0/U0/act_pixel_num[0]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_pixel_num[1]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_pixel_num[2]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_pixel_num[3]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_pixel_num[4]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_pixel_num[5]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_pixel_num[6]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_pixel_num[7]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_pixel_num[8]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_pixel_num[9]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_pixel_num[10]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_pixel_num[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 12 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {hdmi_bd_i/dvi_timing_gen_0/U0/act_line_num[0]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_line_num[1]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_line_num[2]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_line_num[3]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_line_num[4]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_line_num[5]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_line_num[6]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_line_num[7]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_line_num[8]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_line_num[9]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_line_num[10]} {hdmi_bd_i/dvi_timing_gen_0/U0/act_line_num[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 2 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {hdmi_bd_i/dvi_timing_gen_0/U0/pixel_state[0]} {hdmi_bd_i/dvi_timing_gen_0/U0/pixel_state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 12 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {hdmi_bd_i/dvi_timing_gen_0/U0/pixel_counter[0]} {hdmi_bd_i/dvi_timing_gen_0/U0/pixel_counter[1]} {hdmi_bd_i/dvi_timing_gen_0/U0/pixel_counter[2]} {hdmi_bd_i/dvi_timing_gen_0/U0/pixel_counter[3]} {hdmi_bd_i/dvi_timing_gen_0/U0/pixel_counter[4]} {hdmi_bd_i/dvi_timing_gen_0/U0/pixel_counter[5]} {hdmi_bd_i/dvi_timing_gen_0/U0/pixel_counter[6]} {hdmi_bd_i/dvi_timing_gen_0/U0/pixel_counter[7]} {hdmi_bd_i/dvi_timing_gen_0/U0/pixel_counter[8]} {hdmi_bd_i/dvi_timing_gen_0/U0/pixel_counter[9]} {hdmi_bd_i/dvi_timing_gen_0/U0/pixel_counter[10]} {hdmi_bd_i/dvi_timing_gen_0/U0/pixel_counter[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 12 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {hdmi_bd_i/dvi_timing_gen_0/U0/line_counter[0]} {hdmi_bd_i/dvi_timing_gen_0/U0/line_counter[1]} {hdmi_bd_i/dvi_timing_gen_0/U0/line_counter[2]} {hdmi_bd_i/dvi_timing_gen_0/U0/line_counter[3]} {hdmi_bd_i/dvi_timing_gen_0/U0/line_counter[4]} {hdmi_bd_i/dvi_timing_gen_0/U0/line_counter[5]} {hdmi_bd_i/dvi_timing_gen_0/U0/line_counter[6]} {hdmi_bd_i/dvi_timing_gen_0/U0/line_counter[7]} {hdmi_bd_i/dvi_timing_gen_0/U0/line_counter[8]} {hdmi_bd_i/dvi_timing_gen_0/U0/line_counter[9]} {hdmi_bd_i/dvi_timing_gen_0/U0/line_counter[10]} {hdmi_bd_i/dvi_timing_gen_0/U0/line_counter[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 2 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {hdmi_bd_i/dvi_timing_gen_0/U0/line_state[0]} {hdmi_bd_i/dvi_timing_gen_0/U0/line_state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 12 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {hdmi_bd_i/dvi_timing_gen_0/U0/h_front_porch[0]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_front_porch[1]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_front_porch[2]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_front_porch[3]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_front_porch[4]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_front_porch[5]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_front_porch[6]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_front_porch[7]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_front_porch[8]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_front_porch[9]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_front_porch[10]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_front_porch[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 12 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {hdmi_bd_i/dvi_timing_gen_0/U0/h_back_porch[0]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_back_porch[1]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_back_porch[2]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_back_porch[3]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_back_porch[4]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_back_porch[5]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_back_porch[6]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_back_porch[7]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_back_porch[8]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_back_porch[9]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_back_porch[10]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_back_porch[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 12 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list {hdmi_bd_i/dvi_timing_gen_0/U0/h_sync_time[0]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_sync_time[1]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_sync_time[2]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_sync_time[3]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_sync_time[4]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_sync_time[5]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_sync_time[6]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_sync_time[7]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_sync_time[8]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_sync_time[9]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_sync_time[10]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_sync_time[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 12 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list {hdmi_bd_i/dvi_timing_gen_0/U0/h_active_video[0]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_active_video[1]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_active_video[2]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_active_video[3]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_active_video[4]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_active_video[5]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_active_video[6]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_active_video[7]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_active_video[8]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_active_video[9]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_active_video[10]} {hdmi_bd_i/dvi_timing_gen_0/U0/h_active_video[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 12 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list {hdmi_bd_i/dvi_timing_gen_0/U0/v_front_porch[0]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_front_porch[1]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_front_porch[2]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_front_porch[3]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_front_porch[4]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_front_porch[5]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_front_porch[6]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_front_porch[7]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_front_porch[8]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_front_porch[9]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_front_porch[10]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_front_porch[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 12 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list {hdmi_bd_i/dvi_timing_gen_0/U0/v_sync_time[0]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_sync_time[1]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_sync_time[2]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_sync_time[3]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_sync_time[4]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_sync_time[5]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_sync_time[6]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_sync_time[7]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_sync_time[8]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_sync_time[9]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_sync_time[10]} {hdmi_bd_i/dvi_timing_gen_0/U0/v_sync_time[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list hdmi_bd_i/dvi_timing_gen_0/U0/active]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list hdmi_bd_i/dvi_test_pattern_gen_0/U0/active_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_h_dir]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list hdmi_bd_i/dvi_test_pattern_gen_0/U0/box_v_dir]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list hdmi_bd_i/dvi_timing_gen_0/U0/format_upd_buf]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list hdmi_bd_i/dvi_timing_gen_0/U0/frame_active]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list hdmi_bd_i/dvi_test_pattern_gen_0/U0/frame_flag]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 1 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list hdmi_bd_i/dvi_timing_gen_0/U0/hsync]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
set_property port_width 1 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list hdmi_bd_i/dvi_test_pattern_gen_0/U0/hsync_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
set_property port_width 1 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list hdmi_bd_i/dvi_timing_gen_0/U0/line_active]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
set_property port_width 1 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list hdmi_bd_i/dvi_timing_gen_0/U0/rst_n_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
set_property port_width 1 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list hdmi_bd_i/dvi_timing_gen_0/U0/vsync]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe47]
set_property port_width 1 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list hdmi_bd_i/dvi_test_pattern_gen_0/U0/vsync_out]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
