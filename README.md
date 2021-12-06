# Network on a Chip Proof of Concept
This projects is part of my Degree Final Project. Full work is available at [ogarnica/TFG2021-22_RISC-V_NoC](https://github.com/ogarnica/TFG2021-22_RISC-V_NoC)

## How to generate `vivado.tcl`

After creating/modifying the project, just run the following tcl command:
```
write_project_tcl -origin_dir_override . -paths_relative_to /home/davo/Documents/TFG/poc_noc/ -force /home/davo/Documents/TFG/poc_noc/vivado.tcl
```

## How to open `vivado.tcl`
Just use the following command in your shell:
```
vivado -source vivado.tcl
```
