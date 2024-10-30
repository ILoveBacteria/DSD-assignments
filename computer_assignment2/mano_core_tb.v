
module mano_core_tb;
  reg clk_t = 0, rst_t = 1;
  integer i;
  
  mano_core U1 (clk_t, rst_t);
  initial
  begin
    rst_t = 1;
    #30 rst_t = 0; 
  end

  initial
  begin
    for(i = 0;i < 1000;i = i + 1)
      #5 clk_t = ! clk_t;
  end
endmodule
