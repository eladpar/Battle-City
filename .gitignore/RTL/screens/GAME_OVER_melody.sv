// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Elad Paritzky Dec 2019


// module design fsm for playing a melody with 1 sec tone -- optional changing of melody by chaning tone_decoder arranging of freq
module GAME_OVER_melody 	
 ( 
	input	logic clk,
	input	logic resetN, 
	input	logic game_over,// game_over states defined by OR in upper hirarchy
	input	logic slowClken,//clock for counting secondes


	output  logic [3:0] note_num,
	output  logic enable_sound // enable signal designed to enable sound in game_over states
  ) ;


 enum  logic [3:0] {IDLE_ST,// initial state
					 ZERO_NOTE,
					 ONE_NOTE, 
					 TWO_NOTE, 
					 THREE_NOTE, 
					 FOUR_NOTE,
					 FIVE_NOTE, 
					 SIX_NOTE,
					 SEVEN_NOTE,
					 EIGHT_NOTE,
					 NINE_NOTE
					}  nxt_st, cur_st;
 
  
  localparam NUM_OF_BITS = 10 ;  // use for optional changing fsm   

	always_ff @(posedge clk or negedge resetN)
	begin: fsm_sync_proc
		if (resetN == 1'b0) begin 
			cur_st <= IDLE_ST;  
		end 	
		else begin 
			cur_st <= nxt_st;
			
		end ; 
	end // end fsm_sync_proc
  
always_comb 
begin
	// default values 
		nxt_st = cur_st ;
		note_num = 4'd13;
		enable_sound = 1'b1;
	case(cur_st)
	//---------------
	//State with no Sound Output
			IDLE_ST: begin	
			enable_sound = 1'b0;
			if(game_over == 1'b1)
				nxt_st = ZERO_NOTE;
			end
	//---------------
	//each State designed to output a Note (=freq) for a second
			ZERO_NOTE: begin
			note_num = 4'd0;
				if(slowClken == 1'b1) begin
				//	note_num = 4'd0;
					nxt_st = ONE_NOTE;
				end
			end
	//---------------
			 ONE_NOTE: begin
			 note_num = 4'd1;
				if(slowClken == 1'b1) begin
				//	note_num = 4'd1;
					nxt_st = TWO_NOTE;
				end
			end
	//---------------
			 TWO_NOTE: begin
			 note_num = 4'd2;
				if(slowClken == 1'b1) begin
					//note_num = 4'd2;
					nxt_st = THREE_NOTE;
				end
			end
	//---------------
			 THREE_NOTE: begin
			 note_num = 4'd3;
				if(slowClken == 1'b1) begin
					//note_num = 4'd3;
					nxt_st = FOUR_NOTE;
				end
			end
	//---------------
			 FOUR_NOTE: begin
			 note_num = 4'd4;
				if(slowClken == 1'b1) begin
					//note_num = 4'd4;
					nxt_st = FIVE_NOTE;
				end
			end
	//---------------
			 FIVE_NOTE: begin
			note_num = 4'd5; 
				if(slowClken == 1'b1) begin
					//note_num = 4'd5;
					nxt_st = SIX_NOTE;
				end
			end
	//---------------
			 SIX_NOTE: begin
			 note_num = 4'd6;
				if(slowClken == 1'b1) begin
					//note_num = 4'd6;
					nxt_st = SEVEN_NOTE;
				end
			end
	//---------------
			 SEVEN_NOTE: begin
			 note_num = 4'd7;
			 if(slowClken == 1'b1) begin
					//note_num = 4'd7;
					nxt_st = EIGHT_NOTE;
				end
			end
	//---------------
			 EIGHT_NOTE: begin
			 note_num = 4'd8;
				if(slowClken == 1'b1) begin
					//note_num = 4'd8;
					nxt_st = NINE_NOTE;
				end
			end
	//---------------
			 NINE_NOTE: begin
			 note_num = 4'd9;
				if(slowClken == 1'b1) begin
					//note_num = 4'd9;
					nxt_st = IDLE_ST;
				end
			end
	
		endcase  
				
end 

endmodule

