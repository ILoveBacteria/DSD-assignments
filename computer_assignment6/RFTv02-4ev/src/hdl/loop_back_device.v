`timescale 1ns / 1ps
module loop_back_device(
		input rst, 			
		input clk, 	    
		output reg tx_start, 	
		output reg [7:0] tx_data, 		 
		input [7:0] rx_data, 	
		input rx_ready,  
		input tx_ready,  
	
	
		//------------------------------------------------
		// test vector signals should be configured 
		// corresponding with the design
		// Should be updated
		//------------------------------------------------
		output cut_clk,
		output cut_rst_n,
		output reg [63:0] cut_plaintext,
		output reg [127:0] cut_key,
		input  [63:0] cut_ciphertext
	);

	//----------------------------------------------------------------
	// Number of input and output bits: 
	// Should be updated
	//----------------------------------------------------------------
	parameter InputSize  = 194; // number of input bits
	parameter OutputSize = 64;  // number of output bits
	//----------------------------------------------------------------
	
	
	parameter CHAR0 = 8'b00110000;
	parameter CHAR1 = 8'b00110001;
	parameter wait_for_data = 0;
  parameter wait_one_cycle = 1;
  parameter wait_after_input = 2;
  parameter wait_for_output = 3;
  parameter wait_after_output = 4;
  parameter send_output = 5;
  parameter send_equal = 6;
  parameter send_sharp = 7;	
 
	integer state;
	reg [7:0] input_reg [0:255];
  reg [7:0] output_reg [0:255];
	integer icntr, ocntr;
	function c2s(input [7:0] x); 
	begin
		if (x == CHAR0)
			c2s = 1'b0;
		else
			c2s = 1'b1;
  end
	endfunction
  
	function [7:0] s2c(input x); 
	begin
		if (x == 1'b0)
			s2c = CHAR0;
		else
			s2c = CHAR1;
	end
  endfunction

	always @(posedge clk)
	begin
		if (rst) 
    begin
			tx_data = 0;
			tx_start = 0;
			state = wait_for_data;
			icntr = 0;
			ocntr = 0;
    end
    else
    begin
      tx_start = 0;
      case (state)
      wait_for_data :
        if (rx_ready)
        begin
          tx_start = 1'b1;
          tx_data = rx_data;
          input_reg[icntr] = rx_data;
          if (icntr == (InputSize-1))
          begin
            icntr = 0;
            state = wait_after_input;
          end
          else
          begin
            icntr = icntr + 1;
            state = wait_one_cycle;
          end		
        end
      wait_one_cycle:
        state = wait_for_data;
      wait_after_input:
        if (!tx_ready)
        state = send_equal;
      send_equal:
        if (tx_ready)
        begin
          tx_start = 1'b1;
          tx_data = 8'b00111101; //0x3D (=)
          state = wait_for_output;
        end
        else
        begin
          state <= send_equal;
        end
      wait_for_output:
        if (tx_ready == 0)
          state = send_output;
      send_output:
        if (tx_ready)
        begin
          tx_start = 1'b1;
          tx_data = output_reg[OutputSize - ocntr - 1];
          if (ocntr == (OutputSize-1))
          begin
            ocntr = 0;
            state = wait_after_output;
          end
          else
          begin
            ocntr = ocntr + 1;
            state = wait_for_output;
          end
        end
        else
          state = send_output;
      wait_after_output:
        state = send_sharp;
      send_sharp:
        if (tx_ready)
        begin
          tx_start = 1'b1;
          tx_data = 8'b00100011; //0x23 (#)
          state = wait_for_data;
        end
        else
          state = send_sharp;
      default:
      begin  
        tx_start = 1'b0;
        tx_data = rx_data;
        state = wait_for_data;
      end
      endcase
		end
	end

	//------------------------------------------
	// Inteface with CUT: Should be updated
	// Should be updated
	//------------------------------------------

	// convert input characters to bits
  assign cut_clk = c2s(input_reg[0]);
  assign cut_rst_n = c2s(input_reg[1]);
  
  integer i;
  always @(*) begin
    for (i = 0; i < 64; i = i + 1) begin
      cut_plaintext[i] = c2s(input_reg[2 + 64 - 1 - i]);
    end

    for (i = 0; i < 128; i = i + 1) begin
      cut_key[i] = c2s(input_reg[2 + 64 + 128 - 1 - i]);
    end
  end

	// convert output bits to character
  always @(*) begin
    for (i = 0; i < 64; i = i + 1) begin
      output_reg[i] = s2c(cut_ciphertext[i]);
    end
  end

endmodule
