// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By David Bar-On  June 2018 
// filters the output, ignores short glitches in the input 

module lpf 	
 #(parameter FILTER_SIZE = 4)
 
 ( 
 	input	   logic  clk,
	input	   logic  resetN, 
	input	   logic  in,
	
   output  logic 	out_filt	
 
  ) ;


 enum  logic [0:0] {ONE, ZERO}  nxt_st, cur_st; // the two states 

  logic [FILTER_SIZE-1:0] cntr, cntr_ns ; 

	always_ff @(posedge clk or negedge resetN)
	begin
		if (resetN == 1'b0) begin 
			cur_st <= ZERO ; 
			cntr <= {FILTER_SIZE{1'b0}}; ;
			end 	
		else begin 
			cur_st <= nxt_st;
			cntr <= cntr_ns ; 
		end ; 
	end // end fsm_sync_proc
 

 // the ocunter is incrementted every one,  if the are enought ones then the state changes 
 
 // Asynchronous Process
	always_comb 
	begin
		
		// default values 
		cntr_ns = cntr   ; 
		nxt_st = cur_st  ;
		
		if (in == 1'b1) begin 
			if (cntr <  {FILTER_SIZE{1'b1}} ) //bit extention  
					cntr_ns = cntr + {{(FILTER_SIZE-1){1'b0}},1'b1} ; // increment the counter if input is one 
			else 
					nxt_st = ONE;
		end
		else begin 
			if (cntr >  {FILTER_SIZE{1'b0}} )
					cntr_ns = cntr - {{(FILTER_SIZE-1){1'b0}},1'b1} ; 
			else  
				nxt_st = ZERO;
		end ; 

	// decoding the state to output logic 		
	
	 if (cur_st == ONE) 	
						out_filt <= 1'b1 ;	
		else 
						out_filt <= 1'b0 ;	
	
	end // end fsm_async_proc
 
 	

endmodule


