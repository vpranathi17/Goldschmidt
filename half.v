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