module decoder_tb();
logic [7:0] y[0:10], PPt[0:10],PP[0:10];
logic [2:0] sdn[0:10];
logic [8:0] p[0:10];
logic [7:0] PPNeg[0:10];


function [7:0]out; // complement function
input [7:0] in;
reg [7:0] temp1;
integer j,k;
begin
out[0] = in[0];
temp1[7:0] = in[7:0];

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
genvar i,k;
for (k=1;k<=10;k++)
begin
assign y[k] = $urandom_range(8,15);
assign sdn[k] = $urandom_range(0,7);
assign p[k][0] = 0;
  assign p[k][8:1] = y[k][7:0];
decoder decode(sdn[k],y[k],PP[k]); 
for(i = 1; i<=8;i=i+1) 
begin
always_comb begin
if(((sdn[k][1] == 1'b1) && (p[k][i-1] == 1'b1)) || ((sdn[k][2] == 1'b1)&&(p[k][i] == 1'b1))) begin
PPNeg[k][i-1] = 1'b1; end
else
PPNeg[k][i-1] = 1'b0;
end end
always_comb begin
if (sdn[k][0] == 1'b1)
PPt[k][7:0] = out(PPNeg[k][7:0]);
else
PPt[k][7:0] = PPNeg[k][7:0];end
initial
begin
a1:assert(PPt[k] === PP[k]) begin
#1 $display("The Partial product is correct. PPt = %b, PP = %b", PPt[k],PP[k]); end
else #1 $error ("The Partial product is not correct. PPt = %b, PP = %b", PPt[k],PP[k]);
end
end
endmodule
