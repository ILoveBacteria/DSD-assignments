onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /neural_tb/dut/clk
add wave -noupdate /neural_tb/dut/rst
add wave -noupdate /neural_tb/dut/start
add wave -noupdate /neural_tb/dut/in_features
add wave -noupdate /neural_tb/dut/prediction
add wave -noupdate /neural_tb/dut/done
add wave -noupdate /neural_tb/dut/features
add wave -noupdate /neural_tb/dut/state
add wave -noupdate /neural_tb/dut/count_clocks
add wave -noupdate /neural_tb/dut/i
add wave -noupdate /neural_tb/dut/j
add wave -noupdate /neural_tb/dut/new_prediction
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {157 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 212
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
WaveRestoreZoom {0 ns} {937 ns}
