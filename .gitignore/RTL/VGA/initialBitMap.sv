//-- EE 2019




module	initialBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);
// generating a screen bitmap 

localparam  int OBJECT_HEIGHT_Y = 64;
localparam  int OBJECT_WIDTH_X = 64;

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 


logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] object_colors = {
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h00, 8'h00, 8'h00, 8'h00, 8'h44, 8'h64, 8'h64, 8'h20, 8'h00, 8'h00, 8'h00, 8'h20, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h20, 8'h00, 8'h40, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h44, 8'h00, 8'h20, 8'h64, 8'h64, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h40, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hC4, 8'hC9, 8'hC4, 8'hC8, 8'hC9, 8'hC4, 8'h20, 8'h00, 8'h00, 8'h00, 8'hA9, 8'hC4, 8'hED, 8'h64, 8'h00, 8'h00, 8'h00, 8'h40, 8'hC9, 8'hC8, 8'hC8, 8'hC9, 8'hC4, 8'hC9, 8'h20, 8'h00, 8'h84, 8'hCD, 8'hC4, 8'hC9, 8'hC4, 8'hC9, 8'h84, 8'h00, 8'h20, 8'hC9, 8'hC9, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h84, 8'hED, 8'hC4, 8'hC9, 8'hC4, 8'hC9, 8'h84, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hED, 8'hD2, 8'hD1, 8'hD1, 8'hD2, 8'hCD, 8'h20, 8'h00, 8'h00, 8'h00, 8'hAD, 8'hED, 8'hF2, 8'h69, 8'h00, 8'h00, 8'h00, 8'h44, 8'hF2, 8'hD1, 8'hD1, 8'hD2, 8'hD1, 8'hD2, 8'h24, 8'h00, 8'hA9, 8'hF2, 8'hCD, 8'hD2, 8'hCD, 8'hF2, 8'h89, 8'h00, 8'h24, 8'hF2, 8'hCD, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hF2, 8'hCD, 8'hD2, 8'hCD, 8'hF2, 8'hAD, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h65, 8'hF2, 8'hD1, 8'h6D, 8'h6D, 8'h92, 8'hD1, 8'h84, 8'h00, 8'h00, 8'h64, 8'hCD, 8'h8D, 8'hAD, 8'hAD, 8'h40, 8'h00, 8'h00, 8'h24, 8'h6D, 8'h92, 8'hD2, 8'hD1, 8'h8D, 8'h6D, 8'h24, 8'h00, 8'h49, 8'h6D, 8'hB2, 8'hF1, 8'hAD, 8'h6D, 8'h49, 8'h00, 8'h45, 8'hF2, 8'hCD, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hF1, 8'hAD, 8'h6D, 8'h6D, 8'h6D, 8'h49, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h40, 8'hE9, 8'hA4, 8'h00, 8'h00, 8'h25, 8'hC9, 8'hC4, 8'h20, 8'h00, 8'hA9, 8'hC4, 8'h44, 8'h64, 8'hED, 8'h64, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'hC9, 8'hA4, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hC4, 8'h64, 8'h00, 8'h00, 8'h00, 8'h45, 8'hC9, 8'hA4, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hC4, 8'h64, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h44, 8'hF2, 8'hAD, 8'h00, 8'h00, 8'h24, 8'hD1, 8'hCD, 8'h20, 8'h00, 8'hAD, 8'hED, 8'h44, 8'h89, 8'hF2, 8'h69, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'hD1, 8'hCD, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hED, 8'h69, 8'h00, 8'h00, 8'h00, 8'h45, 8'hD1, 8'hAD, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hED, 8'h64, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hF2, 8'hAD, 8'h00, 8'h00, 8'h20, 8'hD2, 8'hD2, 8'h24, 8'h64, 8'hCD, 8'h91, 8'h24, 8'h49, 8'hB1, 8'hAD, 8'h40, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD2, 8'hD2, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hF6, 8'h69, 8'h00, 8'h00, 8'h00, 8'h44, 8'hF2, 8'hD1, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hF6, 8'h69, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hC4, 8'h84, 8'h00, 8'h00, 8'h20, 8'hC4, 8'hC9, 8'h20, 8'hA9, 8'hC4, 8'h40, 8'h00, 8'h00, 8'h60, 8'hE9, 8'h84, 8'h00, 8'h00, 8'h00, 8'h20, 8'hC8, 8'hC9, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h80, 8'hE9, 8'h64, 8'h00, 8'h00, 8'h00, 8'h20, 8'hC8, 8'hA8, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h80, 8'hE9, 8'h60, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hF1, 8'hA9, 8'h00, 8'h00, 8'h20, 8'hCD, 8'hD1, 8'h24, 8'hB1, 8'hED, 8'h44, 8'h00, 8'h00, 8'h69, 8'hF2, 8'h89, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD1, 8'hD1, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hF2, 8'h69, 8'h00, 8'h00, 8'h00, 8'h24, 8'hF1, 8'hCD, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hF2, 8'h69, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h65, 8'hF6, 8'hCD, 8'h64, 8'h64, 8'h84, 8'hD2, 8'h6D, 8'h24, 8'hAD, 8'hF6, 8'h44, 8'h00, 8'h00, 8'h8D, 8'hF2, 8'h89, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD2, 8'hCD, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hF2, 8'h69, 8'h00, 8'h00, 8'h00, 8'h45, 8'hF2, 8'hCD, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hF1, 8'hAD, 8'h64, 8'h84, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h40, 8'hC9, 8'hC4, 8'hC8, 8'hC8, 8'hC8, 8'hC9, 8'h20, 8'h00, 8'hA4, 8'hC9, 8'h40, 8'h00, 8'h00, 8'h69, 8'hC4, 8'h80, 8'h00, 8'h00, 8'h00, 8'h24, 8'hC9, 8'hA4, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hC4, 8'h60, 8'h00, 8'h00, 8'h00, 8'h45, 8'hC8, 8'hA4, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hC4, 8'hC9, 8'hC4, 8'hE9, 8'h84, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h44, 8'hF2, 8'hD1, 8'hD1, 8'hD1, 8'hF1, 8'hD1, 8'h20, 8'h00, 8'hAD, 8'hF2, 8'h44, 8'h00, 8'h00, 8'h8D, 8'hF1, 8'h89, 8'h00, 8'h00, 8'h00, 8'h25, 8'hD1, 8'hCD, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hF1, 8'h69, 8'h00, 8'h00, 8'h00, 8'h45, 8'hF1, 8'hCD, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hED, 8'hF2, 8'hCD, 8'hF2, 8'h89, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hF1, 8'hCD, 8'h6D, 8'h6D, 8'h6D, 8'hD1, 8'h84, 8'h20, 8'hB1, 8'hF1, 8'h89, 8'h60, 8'h64, 8'hA9, 8'hF6, 8'h89, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD1, 8'hD1, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hF6, 8'h69, 8'h00, 8'h00, 8'h00, 8'h44, 8'hF2, 8'hD1, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hF6, 8'hAD, 8'h6D, 8'h6D, 8'h49, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hC4, 8'h84, 8'h00, 8'h00, 8'h20, 8'hC4, 8'hC9, 8'h20, 8'hA9, 8'hC4, 8'hCD, 8'hC4, 8'hCD, 8'hC4, 8'hC9, 8'h84, 8'h00, 8'h00, 8'h00, 8'h20, 8'hC8, 8'hC9, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h80, 8'hED, 8'h64, 8'h00, 8'h00, 8'h00, 8'h20, 8'hC9, 8'hA9, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h84, 8'hED, 8'h60, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hF1, 8'hA9, 8'h00, 8'h00, 8'h20, 8'hCD, 8'hD1, 8'h24, 8'hAD, 8'hCD, 8'hD2, 8'hCD, 8'hD2, 8'hCD, 8'hF2, 8'h89, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD1, 8'hD1, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hF2, 8'h69, 8'h00, 8'h00, 8'h00, 8'h24, 8'hF1, 8'hCD, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hF2, 8'h65, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h65, 8'hF6, 8'hAD, 8'h00, 8'h00, 8'h24, 8'hD2, 8'hD1, 8'h24, 8'hAD, 8'hF6, 8'h8D, 8'h6D, 8'h6D, 8'hB2, 8'hF2, 8'h89, 8'h00, 8'h00, 8'h00, 8'h25, 8'hD2, 8'hCD, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hF2, 8'h69, 8'h00, 8'h00, 8'h00, 8'h49, 8'hF2, 8'hCD, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hF2, 8'h69, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h40, 8'hE9, 8'hA4, 8'h00, 8'h00, 8'h24, 8'hC9, 8'hC4, 8'h20, 8'hA4, 8'hC9, 8'h40, 8'h00, 8'h00, 8'h69, 8'hC4, 8'h80, 8'h00, 8'h00, 8'h00, 8'h24, 8'hC9, 8'hA4, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hC4, 8'h60, 8'h00, 8'h00, 8'h00, 8'h45, 8'hC8, 8'hA0, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hC4, 8'h60, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h64, 8'hF2, 8'hAD, 8'h00, 8'h00, 8'h24, 8'hD2, 8'hCD, 8'h24, 8'hAD, 8'hF6, 8'h44, 8'h00, 8'h00, 8'h8D, 8'hF1, 8'h89, 8'h00, 8'h00, 8'h00, 8'h25, 8'hD2, 8'hCD, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hF1, 8'h69, 8'h00, 8'h00, 8'h00, 8'h49, 8'hF2, 8'hCD, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hF1, 8'h69, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hF1, 8'hCD, 8'h84, 8'h84, 8'h88, 8'hCD, 8'h6D, 8'h24, 8'hB1, 8'hED, 8'h44, 8'h00, 8'h00, 8'h69, 8'hF2, 8'h89, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD1, 8'hD1, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hF2, 8'h69, 8'h00, 8'h00, 8'h00, 8'h44, 8'hD1, 8'hCD, 8'h84, 8'h84, 8'h84, 8'h84, 8'h20, 8'h00, 8'h89, 8'hF2, 8'hA9, 8'h84, 8'h84, 8'h84, 8'h64, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hC4, 8'hC9, 8'hC8, 8'hC8, 8'hC9, 8'hC4, 8'h20, 8'h00, 8'hA9, 8'hC4, 8'h40, 8'h00, 8'h00, 8'h60, 8'hED, 8'h84, 8'h00, 8'h00, 8'h00, 8'h20, 8'hC8, 8'hC9, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h84, 8'hED, 8'h64, 8'h00, 8'h00, 8'h00, 8'h20, 8'hC9, 8'hC9, 8'hC8, 8'hC9, 8'hC4, 8'hC9, 8'h20, 8'h00, 8'h84, 8'hCD, 8'hC4, 8'hCD, 8'hC4, 8'hE9, 8'h84, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hCD, 8'hD1, 8'hD1, 8'hD1, 8'hD1, 8'hCD, 8'h20, 8'h00, 8'hB1, 8'hED, 8'h44, 8'h00, 8'h00, 8'h69, 8'hF2, 8'h89, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD1, 8'hD1, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hF2, 8'h69, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD1, 8'hD1, 8'hD1, 8'hD2, 8'hCD, 8'hD2, 8'h24, 8'h00, 8'h89, 8'hF2, 8'hCD, 8'hD2, 8'hCD, 8'hF2, 8'hAD, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h25, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h00, 8'h00, 8'h6D, 8'h6D, 8'h24, 8'h00, 8'h00, 8'h49, 8'h6D, 8'h49, 8'h00, 8'h00, 8'h00, 8'h24, 8'h6D, 8'h6D, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h49, 8'h6D, 8'h49, 8'h00, 8'h00, 8'h00, 8'h24, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h24, 8'h00, 8'h49, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h49, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h60, 8'h89, 8'h84, 8'h89, 8'h44, 8'h00, 8'h00, 8'h24, 8'h84, 8'h84, 8'h84, 8'h84, 8'h84, 8'h84, 8'h20, 8'h00, 8'h65, 8'h84, 8'h89, 8'h84, 8'h88, 8'h84, 8'h64, 8'h00, 8'h24, 8'h84, 8'h64, 8'h00, 8'h00, 8'h64, 8'h84, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h84, 8'hED, 8'hC4, 8'hED, 8'h84, 8'h00, 8'h00, 8'h45, 8'hC8, 8'hC8, 8'hC9, 8'hC4, 8'hC9, 8'hC4, 8'h20, 8'h00, 8'h89, 8'hC4, 8'hCD, 8'hC4, 8'hC9, 8'hC4, 8'h84, 8'h00, 8'h25, 8'hC9, 8'hC4, 8'h20, 8'h00, 8'hA9, 8'hC4, 8'h40, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hF6, 8'hD1, 8'hF6, 8'h89, 8'h00, 8'h00, 8'h45, 8'hD2, 8'hD2, 8'hD2, 8'hD1, 8'hD2, 8'hD1, 8'h24, 8'h00, 8'h8D, 8'hF1, 8'hD2, 8'hD1, 8'hD2, 8'hF1, 8'hAD, 8'h00, 8'h25, 8'hD2, 8'hCD, 8'h20, 8'h00, 8'hB2, 8'hF1, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h60, 8'hCD, 8'h8D, 8'h49, 8'h8D, 8'hCD, 8'h64, 8'h00, 8'h24, 8'h49, 8'h6D, 8'hD1, 8'hD2, 8'h6D, 8'h49, 8'h24, 8'h00, 8'h49, 8'h4D, 8'hAD, 8'hF2, 8'hAD, 8'h4D, 8'h49, 8'h00, 8'h24, 8'hD1, 8'hD1, 8'h20, 8'h00, 8'hAD, 8'hF2, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h84, 8'hED, 8'h40, 8'h00, 8'h60, 8'hE9, 8'h84, 8'h00, 8'h00, 8'h00, 8'h20, 8'hC4, 8'hC9, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h60, 8'hED, 8'h84, 8'h00, 8'h00, 8'h00, 8'h20, 8'hC8, 8'hC9, 8'h00, 8'h00, 8'hA4, 8'hCD, 8'h40, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hAD, 8'hF6, 8'h65, 8'h00, 8'h69, 8'hF2, 8'h8D, 8'h00, 8'h00, 8'h00, 8'h20, 8'hD1, 8'hD2, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hF6, 8'h89, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD1, 8'hD1, 8'h20, 8'h00, 8'hAD, 8'hF2, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h64, 8'hD1, 8'h8D, 8'h25, 8'h00, 8'h25, 8'h6D, 8'h49, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD2, 8'hCD, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hF1, 8'h89, 8'h00, 8'h00, 8'h00, 8'h25, 8'hD2, 8'hCD, 8'h20, 8'h00, 8'hD2, 8'hED, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hA4, 8'hE9, 8'h40, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'hC9, 8'hC4, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hC4, 8'h80, 8'h00, 8'h00, 8'h00, 8'h24, 8'hC9, 8'hA0, 8'h00, 8'h00, 8'hA9, 8'hC4, 8'h40, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hAD, 8'hF6, 8'h45, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD2, 8'hD1, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hF2, 8'h89, 8'h00, 8'h00, 8'h00, 8'h25, 8'hD2, 8'hCD, 8'h20, 8'h00, 8'hD2, 8'hF1, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hAD, 8'hED, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h20, 8'hCD, 8'hD1, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hF2, 8'h89, 8'h00, 8'h00, 8'h00, 8'h00, 8'h6D, 8'hCD, 8'h84, 8'h89, 8'hCD, 8'h6D, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hA9, 8'hC4, 8'h40, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h20, 8'hC8, 8'hC9, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h60, 8'hED, 8'h84, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'hC9, 8'hC4, 8'hC9, 8'hC4, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hB1, 8'hF1, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h20, 8'hD1, 8'hD2, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hF6, 8'h89, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD2, 8'hD1, 8'hF2, 8'hCD, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hAD, 8'hF2, 8'h44, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD2, 8'hCD, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hF1, 8'h89, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h6D, 8'hD2, 8'hCD, 8'h6D, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hA4, 8'hE9, 8'h40, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'hC9, 8'hC4, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hC4, 8'h80, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'hC9, 8'hC4, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hAD, 8'hF6, 8'h69, 8'h00, 8'h00, 8'h00, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD2, 8'hD1, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hF2, 8'h89, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD2, 8'hD1, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h49, 8'hAD, 8'hAD, 8'h40, 8'h00, 8'h40, 8'hA9, 8'h64, 8'h00, 8'h00, 8'h00, 8'h20, 8'hCD, 8'hD1, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hF2, 8'h89, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h20, 8'hCD, 8'hD1, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h84, 8'hED, 8'h60, 8'h00, 8'h60, 8'hED, 8'h84, 8'h00, 8'h00, 8'h00, 8'h20, 8'hC4, 8'hC9, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h60, 8'hED, 8'h84, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h20, 8'hC4, 8'hC9, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hF6, 8'h69, 8'h00, 8'h69, 8'hF6, 8'h8D, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD1, 8'hD2, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h69, 8'hF6, 8'h89, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h20, 8'hD1, 8'hD2, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h49, 8'hAD, 8'hAD, 8'h84, 8'hAD, 8'hAD, 8'h29, 8'h00, 8'h24, 8'h84, 8'h84, 8'hD1, 8'hCD, 8'h89, 8'h84, 8'h20, 8'h00, 8'h00, 8'h00, 8'h8D, 8'hED, 8'h89, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD1, 8'hCD, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h80, 8'hED, 8'hC4, 8'hED, 8'h84, 8'h00, 8'h00, 8'h45, 8'hC9, 8'hC9, 8'hC9, 8'hC4, 8'hC9, 8'hC4, 8'h20, 8'h00, 8'h00, 8'h00, 8'h89, 8'hC4, 8'h84, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'hC9, 8'hC4, 8'h20, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h89, 8'hD6, 8'hD1, 8'hD6, 8'h89, 8'h00, 8'h00, 8'h25, 8'hD2, 8'hD2, 8'hD2, 8'hD2, 8'hD2, 8'hD1, 8'h24, 8'h00, 8'h00, 8'h00, 8'h6D, 8'hF2, 8'h89, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'hD2, 8'hD1, 8'h24, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h49, 8'h4D, 8'h4D, 8'h4D, 8'h29, 8'h00, 8'h00, 8'h24, 8'h4D, 8'h4D, 8'h4D, 8'h4D, 8'h4D, 8'h4D, 8'h24, 8'h00, 8'h00, 8'h00, 8'h25, 8'h6D, 8'h29, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h49, 8'h4D, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 }
};


// pipeline (ff) to get the pixel color from the array 	 

//======--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		if (InsideRectangle == 1'b1 )  // inside an external bracket 
			RGBout <= object_colors[offsetY/4][offsetX/4];	//get RGB from the colors table  
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//======--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule