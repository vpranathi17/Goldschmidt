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

module decoder (sdn,y,PP);
input [2:0]sdn;
input [7:0]y;
output [7:0]PP;
wire [7:0]cout;
wire cin,s1,s2;
wire [7:0]o1,o2,pp1,sum;
wire [8:0]p;
genvar j;
 
assign s1 = ~ sdn[2];
assign s2 = ~ sdn[1];
assign cin = sdn[0];
assign p[0] = 0;
assign p[8:1] = y[7:0];


for (j=1; j<=8;j=j+1) begin
assign o1[j-1] = (s1 & sdn[1] & p[j-1]);
assign o2[j-1] = (s2 & p[j] & sdn[2]);
assign pp1[j-1] = (o1[j-1] | o2[j-1]);
assign sum[j-1] = pp1[j-1] ^ sdn[0];
end

half h1 (PP[0],cout[0],sum[0],cin);
half h2 (PP[1],cout[1],sum[1],cout[0]);
half h3 (PP[2],cout[2],sum[2],cout[1]);
half h4 (PP[3],cout[3],sum[3],cout[2]);
half h5 (PP[4],cout[4],sum[4],cout[3]);
half h6 (PP[5],cout[5],sum[5],cout[4]);
half h7 (PP[6],cout[6],sum[6],cout[5]);
half h8 (PP[7],cout[7],sum[7],cout[6]);

// initial
// #700 $display ("%b",PP);

endmodule

module cla(a,b,cin,sum,cout);
	input [7:0] a,b;
	input cin;
	output [7:0] sum;
	output cout;
	wire [7:0] p,g,c;
	genvar j;
	for(j=0;j<=7;j=j+1)
	begin
	  assign p[j]=(a[j]^b[j]); //propogate stage
	  assign g[j]=(a[j]&b[j]); //generate stage
	  if (j==0)
	  	assign c[0]=cin;
	  else
	  	assign c[j]=g[j-1]|(p[j-1]&c[j-1]); // internal carry
	  
	  assign sum[j]=p[j]^c[j]; //sum generation
		end	
		assign cout=c[7];
endmodule

module multiplier(x,y,product);

input [7:0]x,y;
output [15:0]product;
wire [7:0]PP1,PP2,PP3,PP4,sum1,sum2,sum3,s1,s2,s3;
wire [2:0]sdn1,sdn2,sdn3,sdn4;
wire cin,c1,c2,c3;

encoder e (x,sdn1,sdn2,sdn3,sdn4);
decoder d1 (sdn1,y,PP1);
decoder d2 (sdn2,y,PP2);
decoder d3 (sdn3,y,PP3);
decoder d4 (sdn4,y,PP4);

assign cin = 1'b0;

function [7:0]extend;
input [7:0]PP;
begin
extend[7] = PP[7];
extend[6] = PP[7];
extend[5:0]= PP[7:2];
end
endfunction

assign cin = 1'b0;
assign product[1:0] = PP1[1:0];
assign s1 = extend(PP1);
cla cl1 (s1, PP2, cin, sum1, c1 );
assign product [3:2] = sum1[1:0];
assign s2 = extend(sum1);
cla cl2 (s2, PP3, cin, sum2, c2 );
assign product [5:4] = sum2 [1:0];
assign s3 = extend(sum2);
cla cl3 (s3, PP4, cin, sum3, c3 );
assign product [13:6] = sum3[7:0];
assign product[14] = product[13];
assign product[15] = product[13];
// 
// initial
// #90 $display("%b,%b,%b,%b,%b,%b,%b,%b",sdn1,sdn2,sdn3,sdn4,PP1,PP2,PP3,PP4);

endmodule

module half (sum,carry,a,b);
	output reg sum,carry;
	input a;
	input b;
	
	/*always @ (a,b,cin) begin
		 assign sum= a ^b ^cin;
		 assign carry =(a&b)|(b&cin)|(cin&a);end*/
		
	always @(a,b)
		begin
		case ({a,b})
			2'b00: begin
			        sum=0;
			        carry=0; end
			2'b01: begin
			        sum=1;
			        carry=0; end 
			2'b10: begin
			        sum=1;
			        carry=0; end
			2'b11: begin
			        sum=0;
			        carry=1; end 
		endcase
		end
		
// 		initial
// 		#200 $display("%b,%b",a,b);
endmodule

module divider(A,B,xi,C,D,xinew);

	input [7:0] A, B,xi;
	output [7:0] C,D, xinew;
	wire [7:0]Fi,exp;
	reg [7:0]neg;
	reg [7:0] two,down, E,F;
	wire [7:0] extra1,extra2,extra3,extra4; 
	wire [15:0] Ni,Di,xin;
	wire cin,cout,c1,c2,c3,c4,c5;
	reg [2:0] option1,ans1,ans;
	reg [3:0] sr1,sr2,shift,shift1,comp,ans2,shift2;
	wire [3:0] e1, e2,e3,e4, sum1,sum2,sum3,sum4,sum5,sum6 ,cp1,cp2;
	genvar i;
	
	assign cin = 1'b0;
	assign exp = 4'b1001; //-7 value
	
	assign extra1[7:4] = 4'b0000; // A value
	assign extra1[3] = 1'b1;
	assign extra1[2:0] = A[2:0];
	
	assign extra2[7:4] = 4'b0000; // B value
	assign extra2[3] = 1'b1;
	assign extra2[2:0] = B[2:0];
	
	assign extra3[7:4] = 4'b0000; // xi value
	assign extra3[3] = 1'b1;
	assign extra3[2:0] = xi[2:0];


function [3:0]out; // complement function
input [3:0] in;
reg [3:0] temp1;
integer j,k;
begin
out[0] = in[0];
temp1[3:0] = in[3:0];

for(j=1; j<=3; j=j+1)
begin
if (temp1[j-1]== 1'b1) begin
for (k=j; k<=3; k=k+1) begin
out[k] = ~ temp1[k]; end end
else if (temp1[j-1] == 1'b0 &(out[j] ==1'b1 || out[j] == 1'b0))
out[j] = out[j];
else
out[j] = temp1[j];

end

end
endfunction

function [3:0]sum; // cla function
input [3:0]a,b;
reg cin;
reg [3:0] p,g,c;
integer l;
begin
	cin = 1'b0;
	for(l=0;l<=3;l=l+1)
	begin
	  p[l]=(a[l]^b[l]); //propogate stage
	  g[l]=(a[l]&b[l]); //generate stage

	  if (l==0)
	  	c[0]=cin;
	  else
	  	c[l]=g[l-1]|(p[l-1]&c[l-1]); // internal carry
	  
	 sum[l]=p[l]^c[l]; //sum generation
		end	

end
endfunction
	
	multiplier m2 (extra2,extra3,Di);	 // Di multiplying
	multiplier m1 (extra1,extra3,Ni);    // Ni multiplying
	assign C[7] = B[7] ^ xi[7]; // Representing Di
	assign e1 = A[6:3];
	assign e2 = xi[6:3];
	assign e3 = B[6:3];
	assign sum1 = sum(e1,e2);
	assign sum2 = sum (e2,e3);
	assign sum3 = sum (sum1,exp);
	assign sum4 = sum (sum2,exp);
	assign C[6:3] = sum4[3:0];
	assign D[6:3] = sum3[3:0];
	assign D[7] = A[7] ^ xi[7]; // Representing Ni
	assign C[2:0] = Di[5:3];
	assign D[2:0] = Ni[5:3];
	
	always @ (C,D) begin
	two = 8'b01000000;
	E[7:4] = 3'b000;
	F[7:4] = 3'b000;	
	sr1 = two[6:3]; // exponent value of 2
	sr2 = C[6:3]; // exponent value of D	
	E[3:0] = sr2;
	F[3:0] = sr1;
	end
	
	always @ (sum1,sum2,sr1,sr2) begin // 2-Di functionality
// 	$display("%b,%b,%b,%b,%b,%b,%b",e1,e2,e3,sum1,sum2,sum3,sum4);
// 	$display("%b,%b",sr1,sr2);
	down[6:0] = C[6:0];
	down[7] = ~ C[7]; // -Di functionality by changing sign
	shift[3] = 1'b1;
	shift[2:0] = down[2:0];
	shift1[3] = 1'b1;
	shift1[2:0] = two[2:0];
	
	if (sr1 <= sr2) // adder answer sign
		neg[7] = down[7];
	else
		neg[7] = 1'b0;
		
	if (down[7] == 1'b1) begin	
		comp [3:0] = out(shift[3:0]);
// 		$display ("just shifted %b",comp); 
		end
	else begin	
		comp[3:0] = shift[3:0]; end
		
	while (sr1 > sr2) // shifting
	begin 
	comp[3:0] = comp[3:0] >> 1;	
	E[3:0] = sum (sr2,4'b0001);
	sr2 = E[3:0];
	down[6:3] = sr2; 
	down[2:0] = comp[2:0];
// 	$display ("down is %b,comp is %b",down[2:0],comp);
	end
// 	end
	
	while (sr2 > sr1) begin //shifting
	shift1[3:0] = shift1[3:0] >> 1;
	F[3:0] = sum (sr1,4'b0001);
	sr1 = F[3:0];
	two[6:3] = sr1;
	two[2:0] = shift1[2:0];
// 	#90 $display ("two is %b",two[2:0]);
	end
	end
	
// 	assign cp1 = shift1[3:0];
// 	assign cp2 = comp[3:0];
	
	always @ (down[7],shift1,comp) begin
	comp[3] = 1'b1;
	shift1[3] = 1'b1;
	
// 	neg[6:3] = sr2;
	ans2[3:0] = sum(shift1,comp);
	neg[2:0] = ans2[2:0];
	
	if (down[7] == 1'b1 && sr1 < sr2)
		ans = out(ans2);	
	else
		ans = ans2;
		
	if (ans[2] == 1'b1) begin
	 	neg[6:3] = sum(sr2,4'b1111);	
		ans = ans << 1; end
		
	else if (ans[2] == 1'b0 && ans[1] == 1'b1) begin
		neg[6:3] = sum(sr2,4'b1110);
		ans = ans <<1;
		ans = ans<<1; end
	else if (ans[2] == 1'b0 && ans[1] == 1'b0 && ans[0] == 1'b1) begin
		neg[6:3] = sum(sr2,4'b1101);
		ans = ans<<1;
		ans = ans<<1;
		ans = ans<<1; end
		end
	assign Fi[2:0] = ans; // Fi value
// 	assign Fi[6:3] = neg[6:3];
	assign Fi[7:3]= neg[7:3];
	
	assign extra4[7:4] = 4'b0000; // Fi value modified
	assign extra4[3] = 1'b1;
	assign extra4[2:0] = Fi[2:0];
	
	multiplier m3 (extra4,extra3,xin); // new xi value
	
	assign xinew[7] = Fi[7] ^ xi[7];
	assign e4 = Fi[6:3];
	assign sum5 = sum(e4,e2);
	assign sum6 = sum(sum5,exp);
	assign xinew[6:3] = sum6;
	assign xinew[2:0] = xin[5:3];

endmodule

module div (A,B,Q);
input [7:0]A,B;
output reg [7:0]Q;
wire [7:0] o1,o2,o3,i1,i2,x1,x2,i3,xout;
reg [7:0] e1,f1,inter,e2,f2,inter1,out;
wire [7:0] xin,a1,b1,x3;

// assign xin = 8'b00101100;
assign xin[7] = 1'b0;
assign xin[2:0] = 3'b000;
rom r1 (B[6:3],xin[6:3]);

always @ (A,B)
begin
if (B == 8'b00000000 ) begin
$display("Division impossible");
$finish;
end
else if(A == 8'b00000000) begin
$display("Q is 00000000");
$finish;
end
end

divider d1 (A,B,xin,o1,i1,x1);
always @ (o1,i1)
begin
// #400 $display("approx,o1,i1 is %b,%b,%b",xin,o1,i1);
if (o1 == 8'b00111000 || o1 == 8'b00110111 || o1 == 8'b00110100 || o1 == 8'b00110110 || x1 == 8'b00000000) begin
Q = i1;
$display("Q is %b; finished 1",Q);
$finish;
end
else  begin
Q =i1;
// inter = x1;
// #500 $display("Q is %b; nope 1",i1);
end
end


divider d2 (A,B,x1,o2,i2,x2);


always @ (o2,i2)
begin
$display("d1-C,d1-D,d1-xinew,xin,d1-Fi is %b,%b,%b,%b,%b",d1.C,d1.D,d1.xinew,xin,d1.Fi);
if (o2 == 8'b00111000 || o2 == 8'b00110111 || o2 == 8'b00110100 || o2 == 8'b00110110 ||x2 == 8'b00000000 ) begin
Q = i2;
$display("Q is %b; finished 2", Q);
$finish;
end
else begin
Q = i2;
// #2000 $display("Q is %b; nope 2", i2);
end
// end
end


divider d3 (A,B,x2,o3,i3,xout);


always @ (o3,i3)
begin
#1000 $display("o2,i2 is %b,%b",d2.C,d2.D);

Q = i3;
// 
// #9000 $display("Q is %b",i3);
end

endmodule

module rom(
exponent, // Exponent input
approx     // Approximate output
//read_en , // Read Enable 
//ce        // Chip Enable
);
input [3:0] exponent;
output reg [3:0] approx;
//input read_en;
//input ce;

// reg [2:0] data ;
       
always @ (exponent) //(ce or read_en or address)
begin
  case (exponent)
  		4'b0111: approx = 4'b0111;
  		4'b1000: approx = 4'b0110;
  		4'b1001: approx = 4'b0101;
  		4'b1010: approx = 4'b0100;
//   		4'b1011: approx = 4'b0010;
//   		4'b1100: approx = 
//   		4'b1101: approx =
//   		4'b1110: approx =
//   		4'b1111: approx =
  
//     3'b000 : data = 3'b111; //0.875
//     3'b001 : data = 3'b111; //0.875
//     3'b010 : data = 3'b110; //0.75 OR 111=0.875
//     3'b011 : data = 3'b110; //0.75
//     3'b100 : data = 3'b101; //0.625
//     3'b101 : data = 3'b101; //0.625
//     3'b110 : data = 3'b100; //0.5 OR 101=0.625
//     3'b111 : data = 3'b100; //0.5
  endcase
end

endmodule
