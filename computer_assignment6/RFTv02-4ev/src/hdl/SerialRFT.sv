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
    wire cut_rst_n;
    wire [63:0] cut_plaintext;
    wire [127:0] cut_key;
		wire [63:0] cut_ciphertext;
  
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
    .cut_rst_n(cut_rst_n), 
    .cut_plaintext(cut_plaintext), 
    .cut_key(cut_key), 
    .cut_ciphertext(cut_ciphertext)
  );
  
  //------------------------------------------
  // Port Mapping of  Circuit_Under_Test
  // Should be updated
  //------------------------------------------
  reg8 CUT (
    .clk(cut_clk), 
    .rst_n(cut_rst_n), 
    .plaintext(cut_plaintext), 
    .key(cut_key),
    .ciphertext(cut_ciphertext)
  );

endmodule