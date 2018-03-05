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