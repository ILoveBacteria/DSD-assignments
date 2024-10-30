vlog -reportprogress 300 -work work D:/Workroom/verilog_works/mano/mano_core.v
vlog -reportprogress 300 -work work D:/Workroom/verilog_works/mano/mano_core_tb.v
vsim -gui work.mano_core_tb -voptargs=+acc
do wave.do
run 100ns