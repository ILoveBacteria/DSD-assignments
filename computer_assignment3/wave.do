onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group input_signals /addr_tb/dut/start
add wave -noupdate -expand -group input_signals /addr_tb/dut/addsub
add wave -noupdate -expand -group input_signals /addr_tb/dut/clk
add wave -noupdate -expand -group input_signals /addr_tb/dut/nrst
add wave -noupdate -expand -group input_signals -radix unsigned /addr_tb/dut/a
add wave -noupdate -expand -group input_signals -radix unsigned /addr_tb/dut/b
add wave -noupdate -expand -group output_singnals -radix unsigned /addr_tb/dut/sum
add wave -noupdate -expand -group output_singnals /addr_tb/dut/cout
add wave -noupdate -expand -group output_singnals /addr_tb/dut/done
add wave -noupdate -expand -group local_registers -radix unsigned /addr_tb/dut/operand_a
add wave -noupdate -expand -group local_registers -radix unsigned /addr_tb/dut/operand_b
add wave -noupdate -expand -group local_registers -radix unsigned /addr_tb/dut/result_sum
add wave -noupdate -expand -group local_registers /addr_tb/dut/result_carry
add wave -noupdate -expand -group local_registers -radix hexadecimal /addr_tb/dut/shift_a
add wave -noupdate -expand -group local_registers -radix hexadecimal /addr_tb/dut/shift_b
add wave -noupdate -expand -group local_registers -radix unsigned /addr_tb/dut/serial_sum
add wave -noupdate -expand -group local_registers /addr_tb/dut/serial_carry
add wave -noupdate -expand -group local_registers /addr_tb/dut/count
add wave -noupdate -expand -group local_registers /addr_tb/dut/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {252 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 224
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
WaveRestoreZoom {119 ns} {310 ns}
