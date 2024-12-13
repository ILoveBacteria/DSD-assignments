`timescale 1ns / 1ps

/// Remote FPGA Tester Designed by Ali Jahanian

module SerialRFT
    #(parameter int unsigned DIVIDER = 0) 
    (
      input  mclk, 
      input  rst, 
      input  rx, 
      output tx
    );

    wire tx_start, rx_ready, tx_ready; 
    wire [7:0] data_lb_uart, data_uart_lb;

     //************************************
     //  Cuitsuit Under Test Signals
     //************************************
    wire cut_clk;
    wire cut_rst;
    wire cut_en;
    wire [7:0] cut_din;
    wire [7:0] cut_dout;
  
  uart UART (
    .clk(mclk), 
    .rst(rst), 
    .start(tx_start), 
    .din(data_lb_uart), 
    .dout(data_uart_lb), 
    .rx_done(rx_ready), 
    .tx_rdy(tx_ready), 
    .rx(rx), 
    .tx(tx)
  );

  //------------------------------------------
  // Port Mapping of  loop_back_device
  // Should be updated
  //------------------------------------------
  loop_back_device LBD (
    .rst(rst), 
    .clk(mclk), 
    .tx_start(tx_start), 
    .tx_data(data_lb_uart), 
    .rx_data(data_uart_lb), 
    .rx_ready(rx_ready), 
    .tx_ready(tx_ready), 
    .cut_clk(cut_clk), 
    .cut_rst(cut_rst), 
    .cut_en(cut_en), 
    .cut_din(cut_din), 
    .cut_dout(cut_dout)
  );
  
  //------------------------------------------
  // Port Mapping of  Circuit_Under_Test
  // Should be updated
  //------------------------------------------
  reg8 CUT (
    .clk(cut_clk), 
    .rst(rst), 
    .en(cut_en), 
    .din(cut_din), 
    .dout(cut_dout)
  );

endmodule