/// (c) Technion IIT, Department of Electrical Engineering 2019 
//-- This module is dividing the 50MHz CLOCK OSC, and sends clock
//-- enable it to the appropriate outputs in order to achieve
//-- operation at slower rate of individual modules (this is done
//-- to keep the whole system globally synchronous).
//-- All DACs output are set to 100 KHz. 

//-- Elad Paritzky Oct 2019

// SystemVerilog version Elad Paritzky Oct 2019

module	hit	(	

//		--////////////////////	Clock Input	 	////////////////////	
					input		logic	clk,
					input		logic	resetN,
					input		logic	drawing_request_tank1,
					input		logic	drawing_request_tank2,
					input		logic	drawing_request_blocks,
					input		logic	drawing_request_rocket1,
					input		logic	drawing_request_rocket2,
					input		logic	drawing_request_gold,
					input		logic	border,
					input		logic	drawing_request_mother1,
					input		logic	drawing_request_mother2,
					input		logic drawing_request_heart,
					input		logic	drawing_request_strongblocks,
					output	logic	tank1_blocks_collision, 
					output	logic	tank2_blocks_collision,
					output	logic	rocket1_blocks_collision,
					output	logic	rocket2_blocks_collision,
					output	logic	death1,
					output	logic	death2,
					output	logic	more_gold1,
					output	logic	more_gold2,
					output	logic	tanks_collision,
					output	logic	tank1_border_collision, 
					output	logic	tank2_border_collision,
					output	logic	tank1_mother2_collision, 
					output	logic	tank2_mother1_collision,
					output	logic	tank1_mother1_collision, 
					output	logic	tank2_mother2_collision,
					output	logic	more_life1,
					output	logic	more_life2,
					output	logic	tank1_strongblocks_collision, 
					output	logic	tank2_strongblocks_collision,
					output	logic	rocket1_strongblocks_collision, 
					output	logic	rocket2_strongblocks_collision
		);


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
		begin
				tank1_blocks_collision	<= 1'b0;
				tank2_blocks_collision	<= 1'b0;

		end
	
	else
		begin
		//deafaults
			tanks_collision	<= 1'b0;
			tank1_blocks_collision	<= 1'b0;
			 tank2_blocks_collision	<= 1'b0;
			 rocket1_blocks_collision	<= 1'b0;
			 rocket2_blocks_collision	<= 1'b0;
			 death1	<= 1'b0;
			 death2	<= 1'b0;
			 more_gold1	<= 1'b0;
			 more_gold2	<= 1'b0;
			 tank1_border_collision <= 1'b0; 
			 tank2_border_collision <= 1'b0;
			 tank1_mother2_collision <= 1'b0;
			 tank2_mother1_collision <= 1'b0;
			 tank1_mother1_collision <= 1'b0;
			 tank2_mother2_collision <= 1'b0;
			 more_life1	<= 1'b0;
			 more_life2	<= 1'b0;
			 tank1_strongblocks_collision	<= 1'b0;
			 tank2_strongblocks_collision	<= 1'b0;
			 rocket1_strongblocks_collision<= 1'b0;
			 rocket2_strongblocks_collision<= 1'b0;
			 //tank border collision
			if((border == 1'b1)&&(drawing_request_tank1 == 1'b1))
				tank1_border_collision	<= 1'b1;
			else if((border == 1'b1)&&(drawing_request_tank2 == 1'b1))
				tank2_border_collision	<= 1'b1;
				
				//tank and block collision
			else if((drawing_request_tank2 == 1'b1)&&(drawing_request_tank1 == 1'b1))
				tanks_collision	<= 1'b1;
			else if(((drawing_request_blocks==1'b1)||(border))&&(drawing_request_tank1 == 1'b1))
				tank1_blocks_collision	<= 1'b1;
			else if(((drawing_request_blocks==1'b1)||(border))&&(drawing_request_tank2 == 1'b1))
				tank2_blocks_collision	<= 1'b1;
			else if((drawing_request_strongblocks==1'b1)&&(drawing_request_tank1 == 1'b1))
				tank1_strongblocks_collision	<= 1'b1;
			else if((drawing_request_strongblocks==1'b1)&&(drawing_request_tank2 == 1'b1))
				tank2_strongblocks_collision	<= 1'b1;
				
				//rocket and block collision
			else if((drawing_request_blocks==1'b1)&&(drawing_request_rocket1 == 1'b1))
				rocket1_blocks_collision	<= 1'b1;
			else if((drawing_request_blocks==1'b1)&&(drawing_request_rocket2 == 1'b1))
				rocket2_blocks_collision	<= 1'b1;
			else if((drawing_request_strongblocks==1'b1)&&(drawing_request_rocket1 == 1'b1))
				rocket1_strongblocks_collision	<= 1'b1;
			else if((drawing_request_strongblocks==1'b1)&&(drawing_request_rocket2 == 1'b1))
				rocket2_strongblocks_collision	<= 1'b1;
				
				//tank rocket collision
			else if((drawing_request_tank2==1'b1)&&(drawing_request_rocket1 == 1'b1))
				death2	<= 1'b1;
			else if((drawing_request_tank1==1'b1)&&(drawing_request_rocket2 == 1'b1))
				death1	<= 1'b1;
				
				//tank and gold collision 
			else if((drawing_request_tank2==1'b1)&&(drawing_request_gold == 1'b1))
				more_gold2	<= 1'b1;
			else if((drawing_request_tank1==1'b1)&&(drawing_request_gold == 1'b1))
			   more_gold1	<= 1'b1;
				
			//tank 1 2 mother base collision
			else if((drawing_request_tank2==1'b1)&&(drawing_request_mother1 == 1'b1))
				tank2_mother1_collision <= 1'b1;
			else if((drawing_request_tank1==1'b1)&&(drawing_request_mother2 == 1'b1))
				tank1_mother2_collision <= 1'b1;
			//tank 1 2 mother selfbase collision
			else if((drawing_request_tank1==1'b1)&&(drawing_request_mother1 == 1'b1))
				tank1_mother1_collision <= 1'b1;
			else if((drawing_request_tank2==1'b1)&&(drawing_request_mother2 == 1'b1))
				tank2_mother2_collision <= 1'b1;	

				// tanks and heart prize collision
			else if((drawing_request_tank2==1'b1)&&(drawing_request_heart == 1'b1))
				more_life2	<= 1'b1;
			else if((drawing_request_tank1==1'b1)&&(drawing_request_heart == 1'b1))
			   more_life1	<= 1'b1;	

		end
end
endmodule