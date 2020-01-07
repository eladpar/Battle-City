//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// New bitmap dudy NOvember 2019
// (c) Technion IIT, Department of Electrical Engineering 2019 



module	goldBitMap	(	
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
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h91, 8'h90, 8'h90, 8'h90, 8'h90, 8'h90, 8'h90, 8'h91, 8'h92, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDA, 8'h48, 8'hB4, 8'hFC, 8'hFC, 8'hF8, 8'hF8, 8'hFC, 8'hFC, 8'hB4, 8'h44, 8'hDA, 8'hFF, 8'hFF },
{8'hFF, 8'h92, 8'h49, 8'hD8, 8'hFE, 8'hFE, 8'hF8, 8'h6C, 8'h6C, 8'hF8, 8'hF8, 8'hF4, 8'hD0, 8'h49, 8'h92, 8'hFF },
{8'h92, 8'h91, 8'hB4, 8'hFE, 8'hFE, 8'hD9, 8'h8C, 8'h48, 8'h48, 8'h8C, 8'hD4, 8'hF8, 8'hF4, 8'hAC, 8'h8D, 8'h92 },
{8'h24, 8'h90, 8'hFC, 8'hFF, 8'hF9, 8'hD4, 8'h25, 8'h48, 8'h48, 8'h48, 8'hD4, 8'hF8, 8'hF8, 8'hF4, 8'h8C, 8'h24 },
{8'h25, 8'h90, 8'hFC, 8'hF8, 8'hF8, 8'hD4, 8'h25, 8'hB4, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'h8C, 8'h25 },
{8'h25, 8'h90, 8'hFC, 8'hF8, 8'hF8, 8'hF8, 8'hB0, 8'h8C, 8'hB0, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'h8C, 8'h25 },
{8'h25, 8'h90, 8'hFC, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'h6C, 8'h6C, 8'hD4, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'h8C, 8'h25 },
{8'h25, 8'h90, 8'hFC, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hF8, 8'hB4, 8'h25, 8'hD4, 8'hF8, 8'hF8, 8'hF4, 8'h8C, 8'h25 },
{8'h25, 8'h90, 8'hFC, 8'hF8, 8'hF8, 8'hD4, 8'h6C, 8'h6C, 8'h68, 8'h25, 8'hD4, 8'hF8, 8'hF8, 8'hF4, 8'h8C, 8'h25 },
{8'h49, 8'h91, 8'hD8, 8'hF8, 8'hF8, 8'hD4, 8'h48, 8'h25, 8'h25, 8'h48, 8'hD4, 8'hF8, 8'hF8, 8'hD0, 8'h8D, 8'h49 },
{8'hFF, 8'h92, 8'h48, 8'hFC, 8'hF8, 8'hF8, 8'hF8, 8'h68, 8'h68, 8'hF8, 8'hF8, 8'hF8, 8'hF4, 8'h44, 8'h92, 8'hFF },
{8'hFF, 8'hDB, 8'hB6, 8'h6C, 8'hD0, 8'hF4, 8'hF4, 8'hD0, 8'hD0, 8'hF4, 8'hF4, 8'hD0, 8'h68, 8'hB6, 8'hDB, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h8C, 8'hD0, 8'hD0, 8'hD0, 8'hD0, 8'hD0, 8'hD0, 8'h8C, 8'h4D, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h24, 8'h25, 8'h25, 8'h25, 8'h25, 8'h24, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
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