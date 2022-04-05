onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_noc/clk
add wave -noupdate /tb_noc/rst
add wave -noupdate -expand -group {north_up[0]} {/tb_noc/north_up[0]/flit}
add wave -noupdate -expand -group {north_up[0]} {/tb_noc/north_up[0]/enable}
add wave -noupdate -expand -group {north_up[0]} {/tb_noc/north_up[0]/ack}
add wave -noupdate -expand -group {north_up[1]} {/tb_noc/north_up[1]/flit}
add wave -noupdate -expand -group {north_up[1]} {/tb_noc/north_up[1]/enable}
add wave -noupdate -expand -group {north_up[1]} {/tb_noc/north_up[1]/ack}
add wave -noupdate -expand -group {south_up[0]} {/tb_noc/south_up[0]/flit}
add wave -noupdate -expand -group {south_up[0]} {/tb_noc/south_up[0]/enable}
add wave -noupdate -expand -group {south_up[0]} {/tb_noc/south_up[0]/ack}
add wave -noupdate -expand -group {south_up[1]} {/tb_noc/south_up[1]/flit}
add wave -noupdate -expand -group {south_up[1]} {/tb_noc/south_up[1]/enable}
add wave -noupdate -expand -group {south_up[1]} {/tb_noc/south_up[1]/ack}
add wave -noupdate -expand -group {east_up[0]} {/tb_noc/east_up[0]/flit}
add wave -noupdate -expand -group {east_up[0]} {/tb_noc/east_up[0]/enable}
add wave -noupdate -expand -group {east_up[0]} {/tb_noc/east_up[0]/ack}
add wave -noupdate -expand -group {west_up[0]} {/tb_noc/west_up[0]/flit}
add wave -noupdate -expand -group {west_up[0]} {/tb_noc/west_up[0]/enable}
add wave -noupdate -expand -group {west_up[0]} {/tb_noc/west_up[0]/ack}
add wave -noupdate -expand -group {north_down[0]} {/tb_noc/north_down[0]/flit}
add wave -noupdate -expand -group {north_down[0]} {/tb_noc/north_down[0]/enable}
add wave -noupdate -expand -group {north_down[0]} {/tb_noc/north_down[0]/ack}
add wave -noupdate -expand -group {north_down[1]} {/tb_noc/north_down[1]/flit}
add wave -noupdate -expand -group {north_down[1]} {/tb_noc/north_down[1]/enable}
add wave -noupdate -expand -group {north_down[1]} {/tb_noc/north_down[1]/ack}
add wave -noupdate -expand -group {south_down[0]} {/tb_noc/south_down[0]/flit}
add wave -noupdate -expand -group {south_down[0]} {/tb_noc/south_down[0]/enable}
add wave -noupdate -expand -group {south_down[0]} {/tb_noc/south_down[0]/ack}
add wave -noupdate -expand -group {south_down[1]} {/tb_noc/south_down[1]/flit}
add wave -noupdate -expand -group {south_down[1]} {/tb_noc/south_down[1]/enable}
add wave -noupdate -expand -group {south_down[1]} {/tb_noc/south_down[1]/ack}
add wave -noupdate -expand -group {east_down[0]} {/tb_noc/east_down[0]/flit}
add wave -noupdate -expand -group {east_down[0]} {/tb_noc/east_down[0]/enable}
add wave -noupdate -expand -group {east_down[0]} {/tb_noc/east_down[0]/ack}
add wave -noupdate -expand -group {west_down[0]} {/tb_noc/west_down[0]/flit}
add wave -noupdate -expand -group {west_down[0]} {/tb_noc/west_down[0]/enable}
add wave -noupdate -expand -group {west_down[0]} {/tb_noc/west_down[0]/ack}
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/nodes_h[0]/nodes_w[1]/ports_down[0]/flit}
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/nodes_h[0]/nodes_w[1]/ports_down[1]/flit}
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/nodes_h[0]/nodes_w[1]/ports_down[2]/flit}
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/nodes_h[0]/nodes_w[1]/ports_down[3]/flit}
add wave -noupdate -expand -group {node[0][1]} -expand {/tb_noc/DUT/mesh/nodes_h[0]/nodes_w[1]/node/state}
add wave -noupdate -expand -group {node[0][1]} -expand {/tb_noc/DUT/mesh/nodes_h[0]/nodes_w[1]/node/nextstate}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {139715 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 312
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {200460 ps}
