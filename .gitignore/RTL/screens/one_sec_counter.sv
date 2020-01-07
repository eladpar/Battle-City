// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 


// Implements a slow clock as an one-second counter with
// a one-secound output pulse and a 0.5 Hz duty50 output
// Turbo input sets both outputs 10 times faster

module one_sec_counter      	
	(
   // Input, Output Ports
   input  logic clk, resetN, 
	input  logic turbo,
   output logic one_sec, duty50
   );
	
	localparam logic [25:0] oneSec = 26'd50000000; // For real one sec clock
	//localparam logic [25:0] oneSec = 26'd20;  //smaller parameter for simulation
	localparam logic [25:0] oneSecTurbo = oneSec/26'd10; 
	logic  [25:0] oneSecCount = 26'd0;
		
   always_ff @( posedge clk or negedge resetN )
   begin
	
      // Asynchronic reset
      if ( !resetN ) begin
			one_sec <= 1'b0;
			duty50 <= 1'b0;
			oneSecCount <= 26'd0;
		end //asynch
		
		// Synchronic logic	
      else begin
			oneSecCount <= oneSecCount + 26'd1;
						
			if (turbo == 1'b1)	
				if (oneSecCount >= oneSecTurbo) begin
					one_sec <= 1'b1;
					duty50 <= !duty50;
					oneSecCount <= 26'd0;
				end
				else 
					one_sec <= 1'b0;
			else
				if (oneSecCount >= oneSec) begin
					one_sec <= 1'b1;
					duty50 <= !duty50;
					oneSecCount <= 26'd0;
				end
				else 
					one_sec <= 1'b0;
		end //synch
	end // always
endmodule