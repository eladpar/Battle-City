

module up_counter 
	(
   // Input, Output Ports
   input logic clk, 
   input logic resetN,
   output logic [3:0] count,
   output logic up//when the award show	
   );
	
parameter  int START_VALUE= 0;
 	 
 
   always_ff @( posedge clk , negedge resetN )
   begin
      
      if ( !resetN ) begin 
			count <= START_VALUE;
			up <= 1'd0;
		end
		
		else begin
		if ( count==4'd15 ) begin//the award show for 5 seconds
				   up <= 1'd1;
					count <= 4'd0;
			end
		else begin
			if ( count==4'd5 ) begin
				   up <= 1'd0;
			end
				count <= count + 1;
		end
			
		end
   end // always
	 
endmodule

