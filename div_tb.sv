module testbench ();
  logic [7:0]q[0:50],a[0:50],b[0:50];
  genvar i;
  for(i=1;i<=50;i++)
      begin
        assign a[i] =$urandom_range(32,87);
        assign b[i] = $urandom_range(32,87);
        div d11 (a[i],b[i],q[i]);
        initial
          a1:assert (b[i] != 8'b00000000)
            #1 $display("%d:%b,%b,%b",i,a[i],b[i],q[i]);
        else $display("b is zero");
      end
endmodule
