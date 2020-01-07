// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By David Bar-On  June 2018 

module bitrec 	
 ( 
	input	logic clk,
	input	logic resetN, 
	input	logic kbd_dat,
	input	logic kbd_clk,
	output  logic [7:0]	dout,	
	output  logic dout_new, 
	output  logic parity_ok
  ) ;


 enum  logic [2:0] {IDLE_ST, // initial state
					 LOW_CLK_ST, // after clock low 
					 HI_CLK_ST, // after clock hi 
					 CHK_DATA_ST, // after all bits recieved 
					 NEW_DATA_ST // if valid parity announce new data 
					}  nxt_st, cur_st;

  logic [3:0] cntr, nextCntr ; 
  logic [9:0] shift_reg, Next_Shift_Reg  ; 
  logic [7:0] Next_Dout  ; 
  
  localparam NUM_OF_BITS = 10 ;  // &&&&&&&&&&&&&&   

	always_ff @(posedge clk or negedge resetN)
	begin: fsm_sync_proc
		if (resetN == 1'b0) begin 
			cur_st <= IDLE_ST ; 
			cntr <= 4'h0  ;
			shift_reg <= 10'h000 ; 
			dout <= 8'h00 ; 
		end 	
		else begin 
			cur_st <= nxt_st;
			cntr <= nextCntr ; 
			shift_reg <= Next_Shift_Reg ;
			dout <= Next_Dout  ; 
			
		end ; 
	end // end fsm_sync_proc
  
always_comb 
begin
	// default values 
		nxt_st = cur_st ;
		nextCntr = cntr  ; 
		Next_Shift_Reg = shift_reg  ;
		Next_Dout = dout ; 
		dout_new = 1'b0 ; 

	case(cur_st)
			IDLE_ST: begin
//---------------
				nextCntr = 4'h0  ;
				if( (kbd_clk == 1'b0) && (kbd_dat == 1'b0))	
					nxt_st = LOW_CLK_ST;
			end  
				
			LOW_CLK_ST: begin
//---------------
				if (kbd_clk == 1'b1) begin
					Next_Shift_Reg = {kbd_dat,shift_reg [9:1]};
					if (cntr < NUM_OF_BITS) begin
						nextCntr = cntr + 1;
						nxt_st = HI_CLK_ST;
					end
					else begin
						nxt_st = CHK_DATA_ST;
					end
				end
			end  
				
			HI_CLK_ST: begin
//---------------
				if (kbd_clk == 1'b0) begin
					nxt_st = LOW_CLK_ST;
				end
			end  
			
			CHK_DATA_ST: begin 
//---------------
				if (parity_ok == 1'b1) begin 
					Next_Dout = shift_reg[7:0]; 
					nxt_st = NEW_DATA_ST;
				end
				else begin
					nxt_st = IDLE_ST;
				end

			end  

			NEW_DATA_ST: begin 
//---------------
				dout_new = 1'b1 ;
				nxt_st = IDLE_ST;

			end  
	
		endcase  
				
end 
// parity Calc 
assign parity_ok = shift_reg[8] ^ shift_reg[7] ^ shift_reg[6] ^ shift_reg[5] 
       ^ shift_reg[4] ^ shift_reg[3] ^ shift_reg[2] ^ shift_reg[1] ^ shift_reg[0];

endmodule

