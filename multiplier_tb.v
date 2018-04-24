// Verilog test bench for multiplier
`timescale 1ns/100ps
`include "multiplier.v"

module multiplier_tb;

   wire [7:0]x,y;
   wire [15:0]product;
   integer k=0;

   assign x[7:0] = 8'b00001110;
   assign y[7:0] = 8'b00001011;
   
multiplier m1 (x,y,product);

   initial begin

      $dumpfile("multiplier.vcd");
      $dumpvars(0, multiplier_tb);

//       for (k=0; k<8; k=k+1)
//         #10 $display("done testing case %d", k);
        #10 $display("Product is %b",product);
        
      $finish;

   end

endmodule