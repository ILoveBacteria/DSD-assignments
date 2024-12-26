onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /adder_tb/dut/start
add wave -noupdate /adder_tb/dut/clk
add wave -noupdate -radix unsigned /adder_tb/dut/a
add wave -noupdate -radix unsigned /adder_tb/dut/b
add wave -noupdate -radix unsigned /adder_tb/dut/sum
add wave -noupdate /adder_tb/dut/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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
