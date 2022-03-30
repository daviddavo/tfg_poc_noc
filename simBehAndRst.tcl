set_property verilog_define {} [get_filesets sim_1]
set_property -name {questa.simulate.runtime} -value {-all} -objects [get_filesets sim_1]

launch_simulation

set_property verilog_define { POST_SYNTHESIS } [get_filesets sim_1]
set_property -name {questa.simulate.runtime} -value { 200ns } -objects [get_filesets sim_1]