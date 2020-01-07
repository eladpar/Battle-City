//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun Jul 2018
module	data_conversion	(	
//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	[15:0] data_in,
					output	logic	[15:0] data_out 
);


assign	data_out = 		(data_in[15] == 1'b0)	? data_in
							:	(data_in == 16'b1000000000000000)	? 16'b0111111111111111
							:	~data_in + 1'b1;


endmodule

