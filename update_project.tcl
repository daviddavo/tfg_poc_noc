# To be run with vivado -mode batch -source update_project.tcl

open_project -read_only /home/davo/Documents/TFG/poc_noc/vivado/poc_noc.xpr
write_project_tcl -origin_dir_override . -paths_relative_to /home/davo/Documents/TFG/poc_noc/ -force /home/davo/Documents/TFG/poc_noc/vivado.tcl
