module encoder_tb();
  logic [7:0] x [0:10];
  logic [2:0] sdn1[0:10], sdn2[0:10], sdn3[0:10], sdn4[0:10],o1[0:10],o2[0:10],o3[0:10],o4[0:10];
  wire [2:0]xh[0:10],xm[0:10],xl[0:10],xxh[0:10];
  //assign x = 8'b00001010;
  
  function [2:0] breaking;
    input [2:0] a;
    logic o1,o2,o3;
    a1: if(a[2] == 1'b1) begin
      breaking[0] = 1'b1;
      //$display("breaking[0] is 1, breaking[0] = %b",breaking[0]);
    end
    else
      begin
        breaking[0] = 1'b0;
        //$display("breaking[0] is 0, breaking[0] = %b",breaking[0]);
      end
    a2: if(a[1] !== a[0]) begin
      breaking[2] = 1'b1;
      //$display("breaking[2] is 1, breaking[2] = %b",breaking[2]);
    end
    else
      begin
        breaking[2] = 1'b0;
        //$display("breaking[2] is 0, breaking[2] = %b",breaking[2]);
      end
    a3: if((a[1] === a[0]) && (a[1] !== a[2]) && (a[0] !== a[2])) begin
      breaking[1] = 1'b1;
      //$display("breaking[1] is 1, breaking[1] = %b",breaking[1]);
    end
    else
      begin
        breaking[1] = 1'b0;
        //$display("breaking[1] is 0, breaking[1] = %b",breaking[1]);
      end
  endfunction
  genvar i;
  for(i=1;i<=10;i++) begin
    assign x[i] = $urandom_range(8,15);
    assign xl[i][0]=1'b0;
    assign xl[i][1]=x[i][0];
    assign xl[i][2]=x[i][1];
    assign xm[i][2:0]=x[i][3:1];
    assign xh[i][2:0]=x[i][5:3]; 
    assign xxh[i][2:0]=x[i][7:5];
  /*initial begin
    #1 $display("xl = %b, xm = %b, xh = %b, xxh = %b", xl[i],xm[i],xh[i],xxh[i]); end*/
    encoder encode(x[i],sdn1[i],sdn2[i],sdn3[i],sdn4[i]);
    assign o1[i][2:0]= breaking(xl[i]);
    assign o2[i][2:0]= breaking(xm[i]);
    assign o3[i][2:0]= breaking(xh[i]);
    assign o4[i][2:0]= breaking(xxh[i]);
  initial
    begin
      #1 $display ("Encoded : %b,%b,%b,%b",o1[i],o2[i],o3[i],o4[i]);
      a4: assert (o1[i] == sdn1[i]) begin
        #1 $display("For x: %b; Correct sdn1 sdn1= %b, o1 = %b", x[i],sdn1[i], o1[i]);end
      else $error("Wrong sdn1 sdn1= %b, o1 = %b", sdn1[i], o1[i]);
      a5: assert (o2[i] == sdn2[i]) begin
        #1 $display("For x: %b; Correct sdn2 sdn2= %b, o2 = %b", x[i],sdn2[i], o2[i]);
  end
      else $error("Wrong sdn2 sdn2= %b, o2 = %b", sdn2[i], o2[i]);
      a6: assert (o3[i] == sdn3[i]) begin
        #1 $display("For x: %b; Correct sdn3 sdn3= %b, o3 = %b", x[i],sdn3[i], o3[i]);
  end
      else $error("Wrong sdn3 sdn3= %b, o3 = %b", sdn3[i], o3[i]);
      a7: assert (o4[i] == sdn4[i]) begin
        #1 $display("For x: %b; Correct sdn4 sdn4= %b, o4 = %b", x[i],sdn4[i], o4[i]);
  end
      else $error("Wrong sdn4 sdn4= %b, o4 = %b", sdn4[i], o4[i]); end
  end
endmodule
