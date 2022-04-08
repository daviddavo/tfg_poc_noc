set_property verilog_define {} [get_filesets sim_1]
set_property -name {questa.simulate.runtime} -value {-all} -objects [get_filesets sim_1]
set_property -name {questa.simulate.custom_wave_do} -value {E:\TFG\poc_noc\wave.do} -objects [get_filesets sim_1]

launch_simulation

set_property verilog_define { POST_SYNTHESIS } [get_filesets sim_1]
set_property -name {questa.simulate.runtime} -value { 1us } -objects [get_filesets sim_1]
set_property -name {questa.simulate.custom_wave_do} -value {E:\TFG\poc_noc\wave_synth.do} -objects [get_filesets sim_1]