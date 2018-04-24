// Verilog test bench for cla
`timescale 1ns/100ps
`include "cla.v"

module cla_tb;

   wire signed [7:0]x,y;
   wire cin,cout;
   wire [7:0]sum;
   integer k=0;

   assign x[7:0] = 8'b11111110;
   assign y[7:0] = 8'b00000110;
   assign cin = 1'b0;
   
cla cc (x,y,cin,sum,cout);

   initial begin

      $dumpfile("cla.vcd");
      $dumpvars(0, cla_tb);

      for (k=0; k<8; k=k+1)
        #10 $display("done testing case %d", k);
        #10 $display("Sum is %b,Cout is %b",sum,cout);
        
      $finish;

   end

endmodule