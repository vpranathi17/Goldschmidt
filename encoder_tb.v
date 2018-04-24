// Verilog test bench for encoder
`timescale 1ns/100ps
`include "encoder.v"

module encoder_tb;

   wire [7:0]x;
   wire [2:0]sdn1,sdn2,sdn3,sdn4;
   integer k=0;

   assign x[7:0] = 8'd13;
   
   encoder e1 (x,sdn1,sdn2,sdn3,sdn4);

   initial begin

      $dumpfile("encoder.vcd");
      $dumpvars(0, encoder_tb);

      for (k=0; k<8; k=k+1)
        #10 $display("done testing case %d", k);
        #10 $display("%b,%b,%b,%b",sdn1,sdn2,sdn3,sdn4);
        
      $finish;

   end

endmodule