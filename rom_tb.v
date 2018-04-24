// Verilog test bench for rom
`timescale 1ns/100ps
`include "rom.v"

module rom_tb;

   wire [2:0]add,data;
//    integer k=0;

   assign add[2:0] = 3'b000;
   
rom r1 (add,data);

   initial begin

      $dumpfile("rom.vcd");
      $dumpvars(0, rom_tb);

//       for (k=0; k<8; k=k+1)
//         #10 $display("done testing case %d", k);
        #30$display("%b",data);
//         
//       $finish;

   end

endmodule