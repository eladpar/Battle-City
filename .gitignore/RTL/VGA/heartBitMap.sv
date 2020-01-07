

module	heartBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input	logic	gold_ena,
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);
// generating a smiley bitmap 

localparam  int OBJECT_HEIGHT_Y = 16;
localparam  int OBJECT_WIDTH_X = 16;

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
logic [7:0] RGBout4  ;// RGB in 4 bits 

logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h96, 8'h96, 8'hDB, 8'hFF, 8'hFF, 8'hB6, 8'h96, 8'h96, 8'hDB, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hB6, 8'h60, 8'h5C, 8'h5C, 8'h69, 8'hDB, 8'hB6, 8'h60, 8'h60, 8'h60, 8'h69, 8'hDB, 8'hFF, 8'hFF },
{8'hFF, 8'hB6, 8'h84, 8'hE0, 8'hF2, 8'hED, 8'hA0, 8'h69, 8'h84, 8'hE0, 8'hE0, 8'hE0, 8'hA0, 8'h69, 8'hDB, 8'hFF },
{8'hFF, 8'h49, 8'hA0, 8'hF2, 8'hFF, 8'hE9, 8'hE0, 8'hA0, 8'hC0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'h60, 8'hB6, 8'hFF },
{8'hFF, 8'h6D, 8'hA0, 8'hFB, 8'hE9, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'h60, 8'hB6, 8'hFF },
{8'hFF, 8'h6D, 8'hA0, 8'hE5, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'h60, 8'hB6, 8'hFF },
{8'hFF, 8'hDB, 8'h69, 8'hC0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'h80, 8'h92, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDB, 8'h65, 8'hC0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hA0, 8'h92, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h64, 8'hC0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hA0, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'h64, 8'hC0, 8'hE0, 8'hE0, 8'hA0, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h64, 8'hE0, 8'hA0, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h84, 8'h69, 8'hDF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
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
			RGBout4 <= object_colors[offsetY/2][offsetX/2];	//get RGB from the colors table  
		else 
			RGBout4 <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//======--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout4 != TRANSPARENT_ENCODING && (~gold_ena) ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

assign RGBout = RGBout4 ; // extend the bits to 8 bit   


endmodule