
// System-Verilog Elad Paritzky Dec 2019
// (c) Technion IIT, Department of Electrical Engineering 2019 



module	rocket_bitmap	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] offsetX,// offset from top left  position 
					input 	logic	[10:0] offsetY,
					input		logic	InsideRectangle, //input that the pixel is within a bracket 
					input 	logic [1:0] last_direction,
					input 	logic rocket_enable,
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);
// generating a smiley bitmap 

localparam  int OBJECT_HEIGHT_Y = 8;
localparam  int OBJECT_WIDTH_X = 8;

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] up_rocket = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hEE, 8'hE9, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hBB, 8'h77, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h7B, 8'h33, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h8E, 8'h6E, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hA0, 8'hA0, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h89, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};

// pipeline (ff) to get the pixel color from the array 	 

//======--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
	//inveting matrix logic used to minimize number of bitmaps
		if (InsideRectangle == 1'b1 ) begin  // inside an external bracket 
				if (last_direction == 2'd0) begin
						RGBout <= up_rocket[offsetY][offsetX];
				end
				if (last_direction == 2'd1) begin
						RGBout <= up_rocket[offsetX][7-offsetY];
				end
				if (last_direction == 2'd2) begin
						RGBout <= up_rocket[7-offsetY][7-offsetX];
				end
				if (last_direction == 2'd3) begin
						RGBout <= up_rocket[7-offsetX][offsetY];
				end
		end
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//======--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not
//logic of rocket_enable explained in rocket_move
assign drawingRequest = ((RGBout != TRANSPARENT_ENCODING) && (rocket_enable)) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule