set_property verilog_define {} [get_filesets sim_1]
set_property -name {questa.simulate.runtime} -value {300ns} -objects [get_filesets sim_1]
set_property -name {questa.simulate.custom_wave_do} -value {E:\TFG\poc_noc\wave_utils.do} -objects [get_filesets sim_1]

launch_simulation
