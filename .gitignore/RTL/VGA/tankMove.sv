module	tankMove	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	up_direction,
					input	logic	down_direction,
					input	logic	right_direction,
					input	logic	left_direction,
					input	logic	collision,
					input logic was_shoot,
					output	logic	[10:0]	topLeftX,// output the top left corner 
					output	logic	[10:0]	topLeftY
					
);  

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 185;
parameter int XSPEED = 120;
parameter int YSPEED = 120;
parameter int Y_ACCEL = -1;

const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution
const int	collision_location = 40; 
const int	x_FRAME_SIZE	=	639 * MULTIPLIER;
const int	y_FRAME_SIZE	=	479 * MULTIPLIER;
logic upcoll;
logic downcoll;
logic rightcoll;
logic leftcoll;
logic [1:0]lastkey;
int   topLeftX_tmp;//flags top left x of object for asychronic logic  
int   topLeftY_tmp;// //flags top left y of object for asychronic logic 
logic tmp_upcoll; //flags upward collision tank & brick
logic tmp_downcoll; //flags downward collision tank & brick
logic tmp_rightcoll; //flags rightward collision tank & brick
logic tmp_leftcoll; //flags leftward collision tank & brick


//=====--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
	//default assigning
		topLeftX_tmp	<= INITIAL_X * MULTIPLIER;
		topLeftY_tmp	<= INITIAL_Y * MULTIPLIER;
		tmp_upcoll<=1'd0;
		tmp_rightcoll <= 1'd0;
		tmp_downcoll <= 1'd0;
		tmp_leftcoll <= 1'd0;
		 

	end
	else begin
      if (upcoll)begin//flags of collision information in order to avoid ongoing collision 
		topLeftY_tmp  <= topLeftY_tmp + collision_location;
		tmp_upcoll <= 1'd1;
		end
		else if (downcoll)begin
		topLeftY_tmp  <= topLeftY_tmp - collision_location;
		tmp_downcoll <= 1'd1;
		end
		else if (rightcoll)begin
		 topLeftX_tmp  <= topLeftX_tmp - collision_location;
		 tmp_rightcoll <= 1'd1;
		end
		else if (leftcoll)begin
		topLeftX_tmp  <= topLeftX_tmp + collision_location;
		tmp_leftcoll <= 1'd1;
		end	
		 if (startOfFrame == 1'b1 ) begin// perform only 30 times per second
		 
					//select the direction + other conditions to avoid continues collison
					if(was_shoot)begin
						tmp_rightcoll <= 1'd0;
						tmp_downcoll <= 1'd0;
						tmp_leftcoll <= 1'd0;
						tmp_upcoll <= 1'd0;
					end
				
					if (up_direction && ~right_direction && ~left_direction && ~down_direction &&~tmp_upcoll) begin  
								topLeftY_tmp  <= topLeftY_tmp - YSPEED;
								tmp_rightcoll <= 1'd0;
								tmp_downcoll <= 1'd0;
								tmp_leftcoll <= 1'd0;
								
					end
				
					else if (down_direction && ~right_direction && ~left_direction && ~up_direction && ~tmp_downcoll) begin
						topLeftY_tmp  <= topLeftY_tmp + YSPEED;
						tmp_rightcoll <= 1'd0;
						tmp_upcoll <= 1'd0;
						tmp_leftcoll <= 1'd0;
						end
				
					else if (right_direction && ~up_direction && ~left_direction && ~down_direction && ~tmp_rightcoll)begin
							topLeftX_tmp  <= topLeftX_tmp + XSPEED;
							tmp_upcoll <= 1'd0;
							tmp_downcoll <= 1'd0;
							tmp_leftcoll <= 1'd0;
						end
				
					else if (left_direction && ~right_direction && ~up_direction && ~down_direction && ~tmp_leftcoll)begin
						topLeftX_tmp  <= topLeftX_tmp - XSPEED;
						tmp_rightcoll <= 1'd0;
						tmp_downcoll <= 1'd0;
						tmp_upcoll <= 1'd0;
						end
				
				

			end		
	end
end

assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;// top of the square changes according to the state of the game   
assign 	topLeftY = topLeftY_tmp / MULTIPLIER ;
    
assign   upcoll = ((collision == 1'b1)&&(up_direction == 1'b1) )? 1'd1 : 1'd0;//update state of collison according the current direction of the tank
assign   rightcoll = ((collision == 1'b1)&&(right_direction == 1'b1) )? 1'd1 : 1'd0;
assign   downcoll = ((collision == 1'b1)&&(down_direction == 1'b1) )? 1'd1 : 1'd0;
assign   leftcoll = ((collision == 1'b1)&&(left_direction == 1'b1) )? 1'd1 : 1'd0;
endmodule
