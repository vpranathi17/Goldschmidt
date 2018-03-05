module mux(xint,xjnew,select,xi);
input [7:0] xint, xjnew;
input select;
output [7:0] xi;
reg[7:0]xi;
always @ (xint or xjnew or select)
begin
if (select == 1'b0)
xi = xint;
else
xi = xjnew;
end
endmodule