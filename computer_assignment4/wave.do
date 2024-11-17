onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group input /adder_tb/clk
add wave -noupdate -expand -group input /adder_tb/nrst
add wave -noupdate -expand -group input /adder_tb/addsub
add wave -noupdate -expand -group input /adder_tb/A
add wave -noupdate -expand -group input /adder_tb/B
add wave -noupdate -group output /adder_tb/SUM
add wave -noupdate -group output /adder_tb/cout
add wave -noupdate -group stage0 /adder_tb/uut/pipeline_A0
add wave -noupdate -group stage0 /adder_tb/uut/pipeline_B0
add wave -noupdate -group stage0 /adder_tb/uut/pipeline_SUM0
add wave -noupdate -group stage0 /adder_tb/uut/pipeline_cout0
add wave -noupdate -group stage1 /adder_tb/uut/pipeline_A1
add wave -noupdate -group stage1 /adder_tb/uut/pipeline_B1
add wave -noupdate -group stage1 /adder_tb/uut/pipeline_SUM1
add wave -noupdate -group stage1 /adder_tb/uut/pipeline_cout1
add wave -noupdate -group stage2 /adder_tb/uut/pipeline_A2
add wave -noupdate -group stage2 /adder_tb/uut/pipeline_B2
add wave -noupdate -group stage2 /adder_tb/uut/pipeline_SUM2
add wave -noupdate -group stage2 /adder_tb/uut/pipeline_cout2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 270
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
WaveRestoreZoom {0 ns} {186 ns}
