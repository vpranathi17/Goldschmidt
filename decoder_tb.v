// Verilog test bench for decoder
`timescale 1ns/100ps
`include "decoder.v"

module decoder_tb;

   wire signed [7:0]x,y;
   wire [2:0]sdn;
   wire[7:0] PP;
   integer k=0;

   assign x[7:0] = 8'b10101010;
   assign y[7:0] = 8'b00001101;
   assign sdn[2:0] = 3'b110;
   
   decoder d1 (sdn,y,PP);

   initial begin

      $dumpfile("decoder.vcd");
      $dumpvars(0, decoder_tb);

      for (k=0; k<8; k=k+1)
        #5000 $display("done testing case %d", k);
        #60000 $display("%b,%b",PP,d1.pp1);
        
      $finish;

   end

endmodule