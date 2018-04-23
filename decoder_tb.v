module decoder_tb();
  logic [7:0] y, PPt,PP;
logic [2:0] sdn;
  logic [8:0] p;
logic [7:0] PPNeg;
assign y = 8'b00001000;
assign sdn = 3'b011;
assign p[0] = 0;
assign p[8:1] = y[7:0];
decoder decode(sdn,y,PP); 

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
genvar i;
for(i = 1; i<=8;i=i+1) 
begin
  always_comb begin
if(((sdn[1] == 1'b1) && (p[i-1] == 1'b1)) || ((sdn[2] == 1'b1)&&(p[i] == 1'b1))) begin
PPNeg[i-1] = 1'b1; end
else
PPNeg[i-1] = 1'b0;
  end end
always_comb begin
if (sdn[0] == 1'b1)
PPt[7:0] = out(PPNeg[7:0]);
else
PPt[7:0] = PPNeg[7:0];end
initial
begin
  a1:assert(PPt === PP) begin
#1 $display("The Partial product is correct. PPt = %b, PP = %b", PPt,PP); end
else #1 $error ("The Partial product is not correct. PPt = %b, PP = %b", PPt,PP);
end
endmodule
