module	baseBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);
// generating a  bitmap 

localparam  int OBJECT_HEIGHT_Y = 16;
localparam  int OBJECT_WIDTH_X = 16;

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
logic [7:0] RGBout4  ;// RGB in 7 bits 

logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] object_colors = {
{8'h45, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h45 },
{8'hB2, 8'hB6, 8'h25, 8'h00, 8'h00, 8'h00, 8'h25, 8'h25, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'hB6, 8'hB2 },
{8'h49, 8'hB6, 8'hB6, 8'h25, 8'h00, 8'h00, 8'h92, 8'hD6, 8'hB2, 8'h24, 8'h00, 8'h00, 8'h25, 8'hB6, 8'hB6, 8'h49 },
{8'hB6, 8'hB6, 8'hDA, 8'hB6, 8'h00, 8'h00, 8'h24, 8'hB6, 8'hA9, 8'h92, 8'h00, 8'h00, 8'hB6, 8'hD6, 8'hB6, 8'hB6 },
{8'h45, 8'hB6, 8'hDA, 8'hB6, 8'h24, 8'h00, 8'h24, 8'hB6, 8'hB6, 8'h24, 8'h00, 8'h25, 8'hB6, 8'hDA, 8'hB6, 8'h29 },
{8'hB6, 8'hB6, 8'hD6, 8'hD6, 8'hB6, 8'h96, 8'h25, 8'hB6, 8'hB6, 8'h25, 8'hB6, 8'hB6, 8'hD6, 8'hD6, 8'hB6, 8'hB6 },
{8'h24, 8'h25, 8'hB6, 8'hA9, 8'hD6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hD6, 8'hD6, 8'hA9, 8'hB6, 8'h25, 8'h24 },
{8'h24, 8'h92, 8'hB6, 8'hD2, 8'hA9, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hD6, 8'hA9, 8'hD2, 8'hD6, 8'h92, 8'h24 },
{8'h00, 8'h25, 8'hB6, 8'hD6, 8'hD6, 8'hD6, 8'hA9, 8'hD6, 8'hD6, 8'hA9, 8'hD6, 8'hD6, 8'hD6, 8'hB6, 8'h25, 8'h20 },
{8'h20, 8'h00, 8'hB6, 8'hBA, 8'hDA, 8'hD6, 8'hD2, 8'hD6, 8'hD6, 8'hD2, 8'hD6, 8'hDA, 8'hDA, 8'hB6, 8'h00, 8'h20 },
{8'h20, 8'h00, 8'h49, 8'hB6, 8'hBA, 8'hB6, 8'h49, 8'hB6, 8'hB6, 8'h49, 8'hB6, 8'hBA, 8'hB6, 8'h49, 8'h00, 8'h20 },
{8'h00, 8'h00, 8'h00, 8'h45, 8'h49, 8'h25, 8'h20, 8'hB6, 8'hB6, 8'h20, 8'h25, 8'h49, 8'h45, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h91, 8'hB6, 8'hB6, 8'h6D, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h20, 8'h00, 8'h00, 8'h00, 8'h6D, 8'h92, 8'hDA, 8'hD6, 8'hDA, 8'hDA, 8'h92, 8'h6D, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h20, 8'h00, 8'h00, 8'h24, 8'hB6, 8'hDA, 8'h6D, 8'hB6, 8'hB6, 8'h6D, 8'hDA, 8'hB6, 8'h24, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h49, 8'h49, 8'h00, 8'h49, 8'h49, 8'h00, 8'h49, 8'h49, 8'h00, 8'h00, 8'h00, 8'h00 }
};

// pipeline (ff) to get the pixel color from the array 	 

//======--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout4 <=	8'h00;
	end
	else begin
		if (InsideRectangle == 1'b1 )  // inside an external bracket 
		//using deviding by 2 for 
			RGBout4 <= object_colors[offsetY/2][offsetX/2];	//get RGB from the colors table  
		else 
			RGBout4 <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//======--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout4 != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

assign RGBout = RGBout4 ; //taking temporary RGB (RGB4) and  assigning to constant wire  


endmodule