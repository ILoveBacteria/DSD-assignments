onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /axi_tb/axi/ACLK
add wave -noupdate /axi_tb/axi/ARESETN
add wave -noupdate /axi_tb/axi/S_ARADDR
add wave -noupdate /axi_tb/axi/S_ARVALID
add wave -noupdate /axi_tb/axi/S_RREADY
add wave -noupdate /axi_tb/axi/S_AWADDR
add wave -noupdate /axi_tb/axi/S_AWVALID
add wave -noupdate /axi_tb/axi/S_WDATA
add wave -noupdate /axi_tb/axi/S_WSTRB
add wave -noupdate /axi_tb/axi/S_WVALID
add wave -noupdate /axi_tb/axi/S_BREADY
add wave -noupdate /axi_tb/axi/S_ARREADY
add wave -noupdate /axi_tb/axi/S_RDATA
add wave -noupdate /axi_tb/axi/S_RRESP
add wave -noupdate /axi_tb/axi/S_RVALID
add wave -noupdate /axi_tb/axi/S_AWREADY
add wave -noupdate /axi_tb/axi/S_WREADY
add wave -noupdate /axi_tb/axi/S_BRESP
add wave -noupdate /axi_tb/axi/S_BVALID
add wave -noupdate /axi_tb/axi/start
add wave -noupdate /axi_tb/axi/clk
add wave -noupdate /axi_tb/axi/rst
add wave -noupdate /axi_tb/axi/a
add wave -noupdate /axi_tb/axi/b
add wave -noupdate /axi_tb/axi/sum
add wave -noupdate /axi_tb/axi/done
add wave -noupdate /axi_tb/axi/state
add wave -noupdate /axi_tb/axi/next_state
add wave -noupdate /axi_tb/axi/read_addr
add wave -noupdate /axi_tb/axi/S_ARADDR_T
add wave -noupdate /axi_tb/axi/S_AWADDR_T
add wave -noupdate /axi_tb/axi/result
add wave -noupdate /axi_tb/axi/k
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 216
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
WaveRestoreZoom {0 ns} {466 ns}
