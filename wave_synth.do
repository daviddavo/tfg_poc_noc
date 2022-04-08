onerror {resume}
quietly virtual signal -install {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node } { (context /tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node )&{\genblk2[3].dest_reg_reg[3][0] /D , \genblk2[3].dest_reg_reg[3][1] /D }} dest_reg_reg_3_D
quietly virtual signal -install {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node } { (context /tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node )&{\genblk2[3].dest_reg_reg[3][1] /D , \genblk2[3].dest_reg_reg[3][0] /D }} dest_reg_reg_3_D001
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
add wave -noupdate -group {west_down[0]} {/tb_noc/west_down[0]/flit}
add wave -noupdate -group {west_down[0]} {/tb_noc/west_down[0]/enable}
add wave -noupdate -group {west_down[0]} {/tb_noc/west_down[0]/ack}
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /clk}
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /rst}
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /cb/\dest[0] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /cb/\dest[1] }
add wave -noupdate -expand -group {node[0][0]} -color Orange {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /cb/\dest[2] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /cb/\dest[3] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /cb/\dest_en[0] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /cb/\dest_en[1] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /cb/\dest_en[2] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /cb/\dest_en[3] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /cb/\data_o_en[0] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /cb/\data_o_en[1] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /cb/\data_o_en[2] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /cb/\data_o_en[3] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /\genblk2[0].dest_reg_reg[0] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /\genblk2[1].dest_reg_reg[1] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /\genblk2[3].dest_reg_reg[3] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /\genblk2[2].dest_reg_reg[2] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /\genblk2[0].state_reg[0] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /\genblk2[1].state_reg[1] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /\genblk2[2].state_reg[2] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /\genblk2[3].state_reg[3] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /\ports_down[2]\.enable }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /\ports_down[2]\.flit[flit_type] }
add wave -noupdate -expand -group {node[0][0]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[0].node /\ports_down[2]\.flit[payload] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /cb/\dest[0] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /cb/\dest[1] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /cb/\dest[2] }
add wave -noupdate -expand -group {node[0][1]} -color Orange {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /cb/\dest[3] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /cb/\dest_en[0] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /cb/\dest_en[1] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /cb/\dest_en[2] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /cb/\dest_en[3] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /cb/\data_o_en[0] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /cb/\data_o_en[1] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /cb/\data_o_en[2] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /cb/\data_o_en[3] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /\genblk2[0].dest_reg_reg[0] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /\genblk2[1].dest_reg_reg[1] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /\genblk2[2].dest_reg_reg[2] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /\genblk2[3].dest_reg_reg[3] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /\genblk2[0].state_reg[0] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /\genblk2[1].state_reg[1] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /\genblk2[2].state_reg[2] }
add wave -noupdate -expand -group {node[0][1]} {/tb_noc/DUT/mesh/\nodes_h[0].nodes_w[1].node /\genblk2[3].state_reg[3] }
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11157032 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {11117018 ps} {11208391 ps}
