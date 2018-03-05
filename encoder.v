module encoder(x,sdn1,sdn2,sdn3,sdn4);

input [7:0]x;
output [2:0]sdn1, sdn2, sdn3, sdn4; //single,double,negate
// output [8:0] PP1,PP2,PP3;

wire [2:0]xh,xm,xl,xxh;

assign xl[0]=1'b0;
assign xl[2:1]=x[1:0];
assign xm[2:0]=x[3:1];
assign xh[2:0]=x[5:3]; 
assign xxh[2:0]=x[7:5];

function [2:0]encoding;
input [2:0]a;
reg o1,o2,o3,o4,o5;

begin 

o1 = ~ a[0];
o2 = ~ a[1];
o3 = ~ a[2];

encoding[2] = (a[0]^a[1]); //single

o4 = ~(a[0] & a[1] & o3);
o5 = ~(a[2] & o1 & o2);
encoding[1] = ~(o4 & o5);//double

encoding[0]=a[2]; //negate

end
endfunction

assign sdn1[2:0]= encoding(xl);
assign sdn2[2:0]= encoding(xm);
assign sdn3[2:0]= encoding(xh);
assign sdn4[2:0]= encoding(xxh);

// decoder d1 (sdn1,y,PP1);
// decoder d2 (sdn2,y,PP2);
// decoder d3 (sdn3,y,PP3);

endmodule
