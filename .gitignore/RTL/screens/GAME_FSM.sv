// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Elad Paritzky Dec 2019

module GAME_FSM 	
 ( 
	input	logic clk,
	input	logic resetN, 
	input	logic enter_is_pressed,
	input	logic slowClken,
	input	logic [1:0] deathcount1,
	input   logic [1:0]	deathcount2,
	input	logic [2:0] num_of_gold1,
	input   logic [2:0]	num_of_gold2,
	input	logic mother_base_1,
	input   logic mother_base_2,
	output  logic enable_game, 
	output  logic initial_screen,
	output  logic green_screen,
	output  logic yellow_screen,
	output logic idle
  ) ;


 enum  logic [2:0] {IDLE_ST, // initial state
					 PLAY_ST, // after ENTER from IDLE ST
					 GREEN_WIN_ON_ST, //green player won on screen
					 GREEN_WIN_OFF_ST,// green player won off screen
					 YELLOW_WIN_ON_ST, // yellow player won on screen 
					 YELLOW_WIN_OFF_ST
					}  nxt_st, cur_st ;
 
  
  localparam NUM_OF_BITS = 10 ;  // &&&&&&&&&&&&&&   

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
		enable_game = 1'b0;
		initial_screen = 1'b0;
		green_screen = 1'b0;
		yellow_screen = 1'b0;
		idle = 1'b0;
	case(cur_st)
			IDLE_ST: begin
//---------------	
			initial_screen = 1'b1;
			if (enter_is_pressed) begin
				nxt_st = PLAY_ST;
				idle = 1'b1;
				end
			end    
			//the game is on	
			PLAY_ST: begin
//---------------
			enable_game = 1'b1;
		   if ((mother_base_1==1'b1))
				nxt_st = GREEN_WIN_ON_ST;
			if ((mother_base_2==1'b1))
				nxt_st = YELLOW_WIN_ON_ST;
			if ((num_of_gold1==3'd7))
				nxt_st = YELLOW_WIN_ON_ST;
			if ((num_of_gold2==3'd7))
				nxt_st = GREEN_WIN_ON_ST;
			if ((deathcount2==2'd3))
				nxt_st = YELLOW_WIN_ON_ST;
			if ((deathcount1==2'd3))
				nxt_st = GREEN_WIN_ON_ST;
			end  
			//game is over
			GREEN_WIN_ON_ST: begin 
//---------------
			green_screen = 1'b1;
			if (slowClken == 1'b1)
				nxt_st = GREEN_WIN_OFF_ST;
			end  

			GREEN_WIN_OFF_ST: begin 
//---------------
			if (slowClken == 1'b1)
				nxt_st = GREEN_WIN_ON_ST;
			end  
			YELLOW_WIN_ON_ST: begin 
//---------------
			yellow_screen = 1'b1;
			if (slowClken == 1'b1)
				nxt_st = YELLOW_WIN_OFF_ST;

			end  
			YELLOW_WIN_OFF_ST: begin 
//---------------
			if (slowClken == 1'b1)
				nxt_st = YELLOW_WIN_ON_ST;

			end 
	
		endcase  
				
end 

endmodule

