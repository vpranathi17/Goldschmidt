// Verilog test bench for dividier
`timescale 1ns/100ps
`include "div.v"

module divider_tb;

   wire [7:0]x,y;
   wire [7:0]Q;
//    integer k=0;

   assign x[7:0] = 8'b00110100;
   assign y[7:0] = 8'b00110000;
   
div d1 (x,y,Q);

   initial begin

      $dumpfile("div.vcd");
      $dumpvars(0, divider_tb);

//       for (k=0; k<8; k=k+1)
//         #10 $display("done testing case %d", k);
//         #3000 $display("%b",Q);
		#20 $display("Quotient is %b",Q);
      $finish;

   end

endmodule