onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tea_pipelined_tb/clk
add wave -noupdate /tea_pipelined_tb/rst_n
add wave -noupdate /tea_pipelined_tb/plaintext
add wave -noupdate /tea_pipelined_tb/key
add wave -noupdate /tea_pipelined_tb/ciphertext
add wave -noupdate {/tea_pipelined_tb/dut/genblk1[0]/v1_shift_l4}
add wave -noupdate {/tea_pipelined_tb/dut/genblk1[0]/v1_shift_r5}
add wave -noupdate {/tea_pipelined_tb/dut/genblk1[0]/v0_shift_l4}
add wave -noupdate {/tea_pipelined_tb/dut/genblk1[0]/v0_shift_r5}
add wave -noupdate {/tea_pipelined_tb/dut/genblk1[0]/next_pipe_v0}
add wave -noupdate {/tea_pipelined_tb/dut/genblk1[0]/next_pipe_v1}
add wave -noupdate {/tea_pipelined_tb/dut/genblk1[0]/next_pipe_sum}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 338
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
WaveRestoreZoom {0 ns} {203 ns}
