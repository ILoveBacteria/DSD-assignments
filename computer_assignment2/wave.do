onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group Testbench /mano_core_tb/clk_t
add wave -noupdate -group Testbench /mano_core_tb/rst_t
add wave -noupdate -group Input_signals /mano_core_tb/U1/clk
add wave -noupdate -group Input_signals /mano_core_tb/U1/rst
add wave -noupdate -group Control_signals /mano_core_tb/U1/ar_ld
add wave -noupdate -group Control_signals /mano_core_tb/U1/ar_clr
add wave -noupdate -group Control_signals /mano_core_tb/U1/ac_ld
add wave -noupdate -group Control_signals /mano_core_tb/U1/ac_clr
add wave -noupdate -group Control_signals /mano_core_tb/U1/ac_inr
add wave -noupdate -group Control_signals /mano_core_tb/U1/dr_ld
add wave -noupdate -group Control_signals /mano_core_tb/U1/dr_clr
add wave -noupdate -group Control_signals /mano_core_tb/U1/tr_ld
add wave -noupdate -group Control_signals /mano_core_tb/U1/tr_clr
add wave -noupdate -group Control_signals /mano_core_tb/U1/pc_ld
add wave -noupdate -group Control_signals /mano_core_tb/U1/pc_clr
add wave -noupdate -group Control_signals /mano_core_tb/U1/pc_inr
add wave -noupdate -group Control_signals /mano_core_tb/U1/ir_ld
add wave -noupdate -group Control_signals /mano_core_tb/U1/sc_clr
add wave -noupdate -group Control_signals /mano_core_tb/U1/wr
add wave -noupdate -group Control_signals /mano_core_tb/U1/rd
add wave -noupdate -group Control_signals /mano_core_tb/U1/sc
add wave -noupdate -group Control_signals /mano_core_tb/U1/bus_sel
add wave -noupdate -group Control_signals /mano_core_tb/U1/alu_func
add wave -noupdate -group Buses /mano_core_tb/U1/mem_out
add wave -noupdate -group Buses /mano_core_tb/U1/alu_out
add wave -noupdate -group Buses /mano_core_tb/U1/abus
add wave -noupdate -expand -group Registers /mano_core_tb/U1/dr
add wave -noupdate -expand -group Registers /mano_core_tb/U1/ac
add wave -noupdate -expand -group Registers /mano_core_tb/U1/e
add wave -noupdate -expand -group Registers /mano_core_tb/U1/tr
add wave -noupdate -expand -group Registers /mano_core_tb/U1/ir
add wave -noupdate -expand -group Registers /mano_core_tb/U1/pc
add wave -noupdate -expand -group Registers /mano_core_tb/U1/ar
add wave -noupdate -expand -group Registers /mano_core_tb/U1/i
add wave -noupdate /mano_core_tb/U1/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {71 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 206
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
WaveRestoreZoom {44 ns} {149 ns}
