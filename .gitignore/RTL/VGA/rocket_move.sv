//-- Elad Paritzky Dec 2019

module	rocket_move	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	[1:0] last_direction,
					input	logic	collision,
					input   logic   shoot,
					input	logic	[10:0] tankX,
					input	logic	[10:0] tankY,
					input   logic   roc_bloc_collision,
					input   logic   tank_death,
					output	logic	[10:0] topLeftX,// output the top left corner 
					output	logic	[10:0] topLeftY,
					output	logic	[1:0] direction_tmp_out,
					output  logic   rocket_enable
					
); 

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 185;
parameter int XSPEED = 100;
parameter int YSPEED = 100;
parameter int Y_ACCEL = -1;

const int	MULTIPLIER	=	64;
const int	NO_SPEED = 0;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 
const int	x_FRAME_SIZE	=	543 * MULTIPLIER;
const int	y_FRAME_SIZE	=	479 * MULTIPLIER;

int Xspeed, topLeftX_tmp; // local parameters 
int Yspeed, topLeftY_tmp;
logic [1:0] direction_tmp; 
logic shoot_tmp;
logic no_rocket = 1'b1;
//  calculation x Axis speed 

//======--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
		Xspeed	<= NO_SPEED;
	else 	begin
			case (direction_tmp)
				2'd0: Yspeed	<= - YSPEED;
				2'd1: Xspeed	<= - XSPEED;
				2'd2: Yspeed	<= YSPEED;
				2'd3: Xspeed	<= XSPEED;
				default: begin
				    Xspeed	<= NO_SPEED;
					Yspeed	<= NO_SPEED;
				end
			endcase
	end
end
// position calculate 

//======--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_tmp	<= (tankX+12)* MULTIPLIER;
		topLeftY_tmp	<= (tankY+12)* MULTIPLIER;
		shoot_tmp	<= 1'b0;
		no_rocket   <= 1'b1;
	end
	else begin
	//shoot_tmp flag used for asyncronic logic (next clock)
	if(tank_death==1'b1)begin
			no_rocket <= 1'b1;
			shoot_tmp <= 1'b0;
		end
		//raise shoot flag
		if ((shoot == 1'b1) && ( no_rocket == 1'b1)) begin
			shoot_tmp	<= 1'b1;
			no_rocket   <= 1'b0;
		end
		//condition if brick hits tank
		if (roc_bloc_collision == 1'b1)  
			no_rocket <= 1'b1;
		if ((topLeftX_tmp <= 0) ||(topLeftX_tmp >= x_FRAME_SIZE)) begin
			topLeftX_tmp	<= (tankX+12)* MULTIPLIER;// initialize for next time
			no_rocket <= 1'b1;
		end
		if ((topLeftY_tmp <= 0) || ( topLeftY_tmp >= y_FRAME_SIZE)) begin
			topLeftY_tmp	<= (tankY+12)* MULTIPLIER;//initialize for next time
			no_rocket <= 1'b1;
		end
		//condition no_rocket used to disable on-screen display of rocket
			if (no_rocket == 1'b0) begin
				if ( shoot_tmp == 1'b1 ) begin
					topLeftX_tmp	<= (tankX+12)* MULTIPLIER;
					topLeftY_tmp	<= (tankY+12)* MULTIPLIER;
					shoot_tmp	<= 1'b0;
					direction_tmp <= last_direction;
				 end	
				 //condition SOF in order to prevent Smearing on screen
				else if(startOfFrame == 1'b1 ) begin			
					 if (direction_tmp == 2'd0 || direction_tmp == 2'd2) //select the direction 
							topLeftY_tmp  <= topLeftY_tmp + Yspeed; 
					 if (direction_tmp == 2'd1 || direction_tmp == 2'd3)
							topLeftX_tmp  <= topLeftX_tmp + Xspeed; 
				 end
			end
	 end
end

//======--------------------------------------------------------------------------------------------------------------=
//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note:  it must be 2^n 
assign 	topLeftY = topLeftY_tmp / MULTIPLIER ; 
// in order to use last direction of rocket for rotation of picture   
assign 	direction_tmp_out = direction_tmp ;
//rocket enable logic used for controlling rocket on screen by 3 states:
//  a. in air b. before shooting / after dissappearing c. first shooting
assign rocket_enable = (no_rocket) ? 1'b0 : 1'b1 ;
endmodule

