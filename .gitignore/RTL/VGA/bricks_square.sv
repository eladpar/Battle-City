
module bricks_square	(	
					input	logic	clk,
					input	logic	resetN,
					input 	logic	[10:0] pixelX,// offset from top left  position 
					input 	logic	[10:0] pixelY,
					input 	logic	[1:0] random,//get the first map in random choise
					input		logic	[0:14] [0:19]		mat0,//4 options for the initial maps of the bricks
					input		logic	[0:14] [0:19]		mat1,
					input		logic	[0:14] [0:19]		mat2,
					input		logic	[0:14] [0:19]		mat3,
					input 	logic rocket1_collision,//indicator from each tank on collision
					input		logic start_of_frame,
					input 	logic rocket2_collision,
					input 	logic [1:0] lastkey1,//indicator from each tank on the last direction
					input 	logic [1:0] lastkey2,
					output 	logic [7:0] RGBout,
					output	logic drawingRequest, //output that the pixel should be dispalyed 
					output logic [10:0]offsetX,//tell the bitmap where to draw
					output logic [10:0]offsetY
					
);
logic [10:0]topLeftX;//the top in the real screen of the current cell at the map matrix
logic [10:0]topLeftY;
logic [10:0]lastpixelX;// flags uses to chek when we switch cell at the map matrix
logic [10:0]lastpixelY ;            
logic initial_screen = 1'b1;//uses to set initial map
logic [0:14] [0:19]tmp_mat;
logic drawingRequest_d = 1'b0;
logic [1:0] random_d = 3'b0;
const int	x_FRAME_SIZE	=	543;//640 dev32  20
const int	y_FRAME_SIZE	=	479;//480 dev32  15
const int	x_START	=	0;
const int	y_START	=	0;
// pipeline (ff) to get the pixel color from the array 	 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest_d <=	1'b0;
		initial_screen <= 1'b1;
	end
	
	else begin
		random_d <= random;
	  lastpixelX <= pixelX;
	  lastpixelY <= pixelY;
	   if (lastpixelX/32 != pixelX/32)
			topLeftX <= pixelX;
		if (lastpixelY/32 != pixelY/32)
			topLeftY <= pixelY;
	  offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner of the current brick
	  offsetY	<= (pixelY - topLeftY);
	  
		if (initial_screen == 1'b1) begin//initial the start map
			initial_screen <= 1'b0;
			case (random_d)
				2'd0: tmp_mat <= mat0;	//get value from bitmap 
				2'd1: tmp_mat <= mat1;	
				2'd2: tmp_mat <= mat2;
				2'd3: tmp_mat <= mat3;
			endcase
		end
	
		else begin 

			if ((rocket1_collision) || (rocket2_collision))  begin
			//this if fix the problem with the timing of the collision flag because of the fact that the screen draw fro left to right
				if(lastkey1 == 2'd1||lastkey2 == 2'd1)//the problematic case
					tmp_mat[pixelY/32][(pixelX-5)/32]<=1'b0;
				else//the default
					tmp_mat[pixelY/32][pixelX/32]<=1'b0;
			end
		end
	end 
	
end
assign RGBout=8'b11111111;
//conditions for draing request by if pixel is inside matrix and frame borders
assign drawingRequest = ((tmp_mat[pixelY/32][pixelX/32]) && (pixelX > x_START )&&(pixelY > y_START)&&// draw the brick just inside the borders
( pixelY < y_FRAME_SIZE)&& (pixelX < x_FRAME_SIZE))? 1'd1 : 1'd0;
endmodule