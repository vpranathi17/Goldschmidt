module divider(A,B,xi,C,D,xinew);

	input [7:0] A, B,xi;
	output [7:0] C,D, xinew;
	wire [7:0]Fi,exp;
	wire [7:0] extra1,extra2,extra3, e1, e2,e3, sum1,sum2,sum3,sum4;
	wire [15:0] Ni,Di;
	wire cin,cout,c1,c2;
	genvar i;

	assign cin = 1'b0;
	assign exp = 8'b11111001;
	
	assign extra1[7:4] = 4'b0000;
	assign extra1[3] = 1'b1;
	assign extra1[2:0] = A[2:0];
	
	assign extra2[7:4] = 4'b0000;
	assign extra2[3] = 1'b1;
	assign extra2[2:0] = B[2:0];
	
	assign extra3[7:4] = 4'b0000;
	assign extra3[3] = 1'b1;
	assign extra3[2:0] = xi[2:0];


function [7:0]out;
input [7:0] in;
reg [7:0] temp1;
integer j,k;
begin
out[0] = in[0];
assign temp1[7:0] = in[7:0];

for(j=1; j<=7; j=j+1)
begin
if (temp1[j-1]== 1'b1) begin
for (k=j; k<=7; k=k+1) begin
out[k] = ~ temp1[k]; end end
else if (temp1[j-1] == 1'b0 &(out[j] ==1'b1 || out[j] == 1'b0))
out[j] = out[j];
else
out[j] = temp1[j];

end

end
endfunction
	
	multiplier m2 (extra2,extra3,Di);
	assign C[7] = A[7] ^ xi[7];
	assign e1[7:4] = 4'b0000;
	assign e2[7:4] = 4'b0000;
	assign e3[7:4] = 4'b0000;
	assign e1[3:0] = A[6:3];
	assign e2[3:0] = xi[6:3];
	assign e3[3:0] = B[6:3];
	cla cla1 (e1,e2,cin,sum1,c1);
	cla cla2 (e2,e3,cin,sum2,c2);
	cla cla3 (sum1,exp,cin,sum3,c3);
	cla cla4 (sum2,exp,cin,sum4,c4);
	assign C[6:3] = sum3[3:0];
	assign D[6:3] = sum4[3:0];
	multiplier m1 (extra1,extra3,Ni);
	assign D[7] = B[7] ^ xi[7];
	assign C[2:0] = Di[7:5];
	assign D[2:0] = Ni[7:5];
// 	assign G = Di[7:0];
// 	assign D = out(G);
// 	complement co (G,D);
// 	cla ca1 (8'b00000010,D,cin,Fi,cout);
// 	multiplier m3 (Fi,xi,xinew);
// 	initial
// 	# 120 $display("G , Ni[7:0] is %b,%b",G,Ni[7:0]);

	
endmodule

