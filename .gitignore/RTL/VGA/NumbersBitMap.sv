//
// coding convention elad paritzky Dec 2019
// (c) Technion IIT, Department of Electrical Engineering 2019 
// generating a number bitmap 



module NumbersBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input 	logic	[10:0] pixelX,// offset from top left  position 
					input 	logic	[10:0] pixelY,
					input 	logic	[1:0] random,
					input		logic	[0:14] [0:19]		mat0,
					input		logic	[0:14] [0:19]		mat1,
					input		logic	[0:14] [0:19]		mat2,
					input		logic	[0:14] [0:19]		mat3,
					input 	logic rocket1_collision,
					input		logic         start_of_frame,
					input 	logic rocket2_collision,
					
					input 	logic [1:0] lastkey1,
					input 	logic [1:0] lastkey2,
					output 	logic [7:0] RGBout,
					output	logic				drawingRequest, //output that the pixel should be dispalyed 
					output logic [10:0]offsetX,
					output logic [10:0]offsetY
					
);
logic [10:0]topLeftX;
logic [10:0]topLeftY;
logic [10:0]lastpixelX;
logic [10:0]lastpixelY ;            
logic initial_screen = 1'b1;
logic [0:14] [0:19]tmp_mat;
logic drawingRequest_d = 1'b0;
const int	x_FRAME_SIZE	=	543;//640 dev32  20
const int	y_FRAME_SIZE	=	479;//480 dev32  15
// pipeline (ff) to get the pixel color from the array 	 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest_d <=	1'b0;
		initial_screen <= 1'b1;
	end
	
	else begin
	  lastpixelX <= pixelX;
	  lastpixelY <= pixelY;
	   if (lastpixelX/32 != pixelX/32)
			topLeftX <= pixelX;
		if (lastpixelY/32 != pixelY/32)
			topLeftY <= pixelY;
	  offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner
	  offsetY	<= (pixelY - topLeftY);
	  
		if (initial_screen == 1'b1) begin
			initial_screen <= 1'b0;
			case (random)
				2'd0: tmp_mat <= mat0;	//get value from bitmap 
				2'd1: tmp_mat <= mat1;	
				2'd2: tmp_mat <= mat2;
				2'd3: tmp_mat <= mat3;
			endcase
			/*if (pixelX>x_FRAME_SIZE)  begin
				tmp_mat[pixelY/32][pixelX/32]<=1'b0;
			end*/
		end
	
		else begin 

			if ((rocket1_collision) || (rocket2_collision))  begin
				if(lastkey1 == 2'd1||lastkey2 == 2'd1)
					tmp_mat[pixelY/32][(pixelX-5)/32]<=1'b0;
				else
					tmp_mat[pixelY/32][pixelX/32]<=1'b0;
			end
			//if ((pixelX >= 0 ) && (pixelX <= x_FRAME_SIZE) && (pixelY >= 0 ) && ( pixelY <= y_FRAME_SIZE))
				//drawingRequest_d <=(tmp_mat[(pixelY/32)-1][(pixelX/32)-1]);
		//	else
				//drawingRequest_d <= 1'b0;
		end
	end 
	
end
assign RGBout=8'b11111111;
assign drawingRequest = ((tmp_mat[pixelY/32][pixelX/32]) && (pixelX > 0 )&&(pixelY > 0)&&
( pixelY < y_FRAME_SIZE)&& (pixelX < x_FRAME_SIZE))? 1'd1 : 1'd0;
endmodule