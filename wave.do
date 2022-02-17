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

add wave -noupdate -expand -group {east_up[1]} {/tb_noc/east_up[1]/flit}
add wave -noupdate -expand -group {east_up[1]} {/tb_noc/east_up[1]/enable}
add wave -noupdate -expand -group {east_up[1]} {/tb_noc/east_up[1]/ack}

add wave -noupdate -expand -group {west_up[0]} {/tb_noc/west_up[0]/flit}
add wave -noupdate -expand -group {west_up[0]} {/tb_noc/west_up[0]/enable}
add wave -noupdate -expand -group {west_up[0]} {/tb_noc/west_up[0]/ack}

add wave -noupdate -expand -group {west_up[1]} {/tb_noc/west_up[1]/flit}
add wave -noupdate -expand -group {west_up[1]} {/tb_noc/west_up[1]/enable}
add wave -noupdate -expand -group {west_up[1]} {/tb_noc/west_up[1]/ack}

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

add wave -noupdate -expand -group {east_down[1]} {/tb_noc/east_down[1]/flit}
add wave -noupdate -expand -group {east_down[1]} {/tb_noc/east_down[1]/enable}
add wave -noupdate -expand -group {east_down[1]} {/tb_noc/east_down[1]/ack}

add wave -noupdate -expand -group {west_down[0]} {/tb_noc/west_down[0]/flit}
add wave -noupdate -expand -group {west_down[0]} {/tb_noc/west_down[0]/enable}
add wave -noupdate -expand -group {west_down[0]} {/tb_noc/west_down[0]/ack}

add wave -noupdate -expand -group {west_down[1]} {/tb_noc/west_down[1]/flit}
add wave -noupdate -expand -group {west_down[1]} {/tb_noc/west_down[1]/enable}
add wave -noupdate -expand -group {west_down[1]} {/tb_noc/west_down[1]/ack}

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 327
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {989050 ps} {989719 ps}
