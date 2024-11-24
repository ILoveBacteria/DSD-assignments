onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tea_pipelined_tb/clk
add wave -noupdate /tea_pipelined_tb/rst_n
add wave -noupdate /tea_pipelined_tb/plaintext
add wave -noupdate /tea_pipelined_tb/key
add wave -noupdate /tea_pipelined_tb/ciphertext
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 202
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
WaveRestoreZoom {0 ns} {238 ns}
