
module	tankBitMap1	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
				   input logic	 upIsPressed,//directions of the tank
					input logic	 leftIsPressed,
					input logic	 downIsPressed,
					input logic	 rightIsPressed,
					output	logic	drawingRequest, //output that the pixel should be dispalyed
					output	logic	[1:0] last_key,	
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);
localparam  int OBJECT_HEIGHT_Y = 28;
localparam  int OBJECT_WIDTH_X = 28;
parameter int is_green=0;
logic	[7:0] RGBout_d;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
logic	 [1:0] lastkey = 2'd0;
// 4 matrixes for every direction
logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] yelow_up_tank = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hFE, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hF4, 8'h90, 8'h6C, 8'h6C, 8'h71, 8'hFF, 8'hFF, 8'hFF, 8'h95, 8'h6C, 8'hD9, 8'hD9, 8'h6C, 8'h95, 8'hFF, 8'hFF, 8'hFF, 8'hF5, 8'hD4, 8'h6C, 8'h6C, 8'h6C, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hF4, 8'hB0, 8'h6C, 8'h90, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hB1, 8'h8C, 8'hD9, 8'hD9, 8'h4C, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hD4, 8'hB0, 8'h8C, 8'h8C, 8'h6C, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hF9, 8'hF4, 8'hF9, 8'hFE, 8'hFE, 8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hF9, 8'hD9, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h6C, 8'hF4, 8'hF4, 8'hF4, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hB5, 8'hB0, 8'hB0, 8'hD5, 8'hF9, 8'hFA, 8'hF9, 8'hF9, 8'hF4, 8'hF4, 8'hF9, 8'hD9, 8'hB0, 8'h8C, 8'h4C, 8'h6C, 8'h6C, 8'h4C, 8'h6C, 8'hB0, 8'hB0, 8'hB0, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h4C, 8'h4C, 8'h4C, 8'hD0, 8'hF4, 8'hFA, 8'hFE, 8'hFE, 8'hF5, 8'hF4, 8'hF9, 8'hF9, 8'hF4, 8'hB0, 8'h4C, 8'h6C, 8'h6C, 8'h6C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hD9, 8'hD4, 8'hD0, 8'hF4, 8'hF4, 8'hFA, 8'hFA, 8'hFE, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hB0, 8'h4C, 8'h6C, 8'h6C, 8'h4C, 8'h6C, 8'hD0, 8'hD0, 8'hD0, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hFA, 8'hFA, 8'hFA, 8'hF5, 8'hF4, 8'hD4, 8'hD4, 8'hF4, 8'hB0, 8'h6C, 8'h6C, 8'h6C, 8'h4C, 8'h6C, 8'hD4, 8'hF4, 8'hF4, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h6C, 8'h6C, 8'h6C, 8'hD0, 8'hF4, 8'hFE, 8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'h6C, 8'h6C, 8'h6C, 8'h90, 8'hF4, 8'h90, 8'h4C, 8'h6C, 8'h6C, 8'h6C, 8'h6C, 8'h6C, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h70, 8'h90, 8'h8C, 8'hD4, 8'hF4, 8'hFE, 8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'h90, 8'h6C, 8'h4C, 8'h90, 8'hF4, 8'h90, 8'h4C, 8'h6C, 8'h6C, 8'h8C, 8'h8C, 8'h6C, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hFE, 8'hF9, 8'hF4, 8'hF9, 8'hFE, 8'hF4, 8'hD0, 8'h4C, 8'h90, 8'hF4, 8'h90, 8'h4C, 8'h4C, 8'h6C, 8'hF4, 8'hF4, 8'hF4, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hB5, 8'hB0, 8'hB0, 8'hD4, 8'hF4, 8'hFE, 8'hF9, 8'hF4, 8'hF9, 8'hFE, 8'hF4, 8'hD0, 8'h4C, 8'h90, 8'hF4, 8'h90, 8'h4C, 8'h4C, 8'h6C, 8'hB0, 8'hB0, 8'hB0, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h4C, 8'h4C, 8'h4C, 8'hD0, 8'hF4, 8'hFE, 8'hF9, 8'hF4, 8'hF9, 8'hFE, 8'hF4, 8'hD0, 8'h4C, 8'h90, 8'hF4, 8'h90, 8'h4C, 8'h6C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hD9, 8'hD4, 8'hD0, 8'hF4, 8'hF4, 8'hFE, 8'hF9, 8'hF4, 8'hF9, 8'hFE, 8'hF4, 8'hD0, 8'h4C, 8'h90, 8'hF4, 8'h90, 8'h4C, 8'h4C, 8'h6C, 8'hD0, 8'hD0, 8'hD0, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFA, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hFE, 8'hF9, 8'hF4, 8'hF9, 8'hFE, 8'hF4, 8'hD4, 8'h6C, 8'h90, 8'hF4, 8'h90, 8'h4C, 8'h4C, 8'h6C, 8'hD4, 8'hF4, 8'hF4, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h6C, 8'h6C, 8'h6C, 8'hD0, 8'hF4, 8'hFE, 8'hF9, 8'hF4, 8'hF9, 8'hFE, 8'hFA, 8'hF9, 8'hD4, 8'hF4, 8'hF4, 8'h90, 8'h4C, 8'h6C, 8'h6C, 8'h6C, 8'h6C, 8'h6C, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h70, 8'h90, 8'h8C, 8'hD4, 8'hF4, 8'hFE, 8'hF9, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'h90, 8'h4C, 8'h6C, 8'h6C, 8'h8C, 8'h8C, 8'h6C, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hFE, 8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'h90, 8'h4C, 8'h4C, 8'h6C, 8'hF4, 8'hF4, 8'hF4, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hB5, 8'hB0, 8'hB0, 8'hD5, 8'hF9, 8'hFA, 8'hF9, 8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hD0, 8'hB0, 8'h6C, 8'h4C, 8'h4C, 8'h6C, 8'hB0, 8'hB0, 8'hB0, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h4C, 8'h4C, 8'h4C, 8'hD9, 8'hFE, 8'hFA, 8'hFA, 8'hFE, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hB0, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hD9, 8'hD4, 8'hD0, 8'hF4, 8'hF9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD9, 8'hD5, 8'hD0, 8'hD0, 8'hD0, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hF5, 8'hF4, 8'hF4, 8'hF4, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFE, 8'hF9, 8'hF4, 8'hF4, 8'hF4, 8'hFF, 8'hFF, 8'hFF }
};

logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] green_up_tank = {
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h71, 8'h71, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h9A, 8'h9A, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h9A, 8'h9A, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h29, 8'h4D, 8'h08, 8'h08, 8'h08, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h9A, 8'h9A, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h04, 8'h08, 8'h08, 8'h04, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h96, 8'hBE, 8'h11, 8'h11, 8'h11, 8'h04, 8'h00, 8'h00, 8'h00, 8'h00, 8'h9A, 8'h9A, 8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h08, 8'h0C, 8'h11, 8'h11, 8'h0D, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h28, 8'h2D, 8'h0C, 8'h51, 8'h9A, 8'h29, 8'h00, 8'h00, 8'h00, 8'h00, 8'h9A, 8'h9A, 8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h08, 8'h08, 8'h0C, 8'h0C, 8'h08, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h08, 8'h2C, 8'h08, 8'h51, 8'hBF, 8'h29, 8'h00, 8'h00, 8'h00, 8'h00, 8'h9A, 8'h9A, 8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h08, 8'h08, 8'h08, 8'h08, 8'h08, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h96, 8'hBE, 8'h11, 8'h55, 8'hBF, 8'h29, 8'h00, 8'h08, 8'h08, 8'h08, 8'h9A, 8'h9A, 8'h08, 8'h08, 8'h08, 8'h00, 8'h00, 8'h08, 8'h0C, 8'h11, 8'h11, 8'h0C, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h4D, 8'h75, 8'h0C, 8'h55, 8'hBE, 8'h71, 8'h4D, 8'h51, 8'h31, 8'h0C, 8'h55, 8'h55, 8'h0C, 8'h0C, 8'h0C, 8'h04, 8'h04, 8'h08, 8'h0C, 8'h0C, 8'h0C, 8'h08, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h04, 8'h08, 8'h08, 8'h51, 8'hBE, 8'hBE, 8'hBF, 8'hBF, 8'h7A, 8'h11, 8'h11, 8'h11, 8'h11, 8'h11, 8'h11, 8'h0C, 8'h08, 8'h08, 8'h08, 8'h08, 8'h08, 8'h08, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h71, 8'h9A, 8'h11, 8'h55, 8'hBE, 8'hBE, 8'h9E, 8'h35, 8'h31, 8'h11, 8'h0C, 8'h08, 8'h08, 8'h0C, 8'h11, 8'h08, 8'h08, 8'h08, 8'h0C, 8'h11, 8'h11, 8'h0C, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h71, 8'h9A, 8'h11, 8'h55, 8'hBE, 8'hBE, 8'h9A, 8'h11, 8'h11, 8'h35, 8'h0C, 8'h08, 8'h08, 8'h0C, 8'h11, 8'h08, 8'h08, 8'h08, 8'h0C, 8'h11, 8'h11, 8'h0C, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h04, 8'h08, 8'h08, 8'h51, 8'hBE, 8'hBE, 8'h9A, 8'h11, 8'h55, 8'hBE, 8'h35, 8'h10, 8'h08, 8'h0C, 8'h11, 8'h08, 8'h08, 8'h08, 8'h08, 8'h08, 8'h08, 8'h08, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h4D, 8'h55, 8'h0C, 8'h55, 8'hBE, 8'hBE, 8'h9A, 8'h11, 8'h55, 8'hBE, 8'h35, 8'h10, 8'h08, 8'h0C, 8'h11, 8'h08, 8'h08, 8'h08, 8'h0C, 8'h0C, 8'h0C, 8'h08, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h96, 8'hBE, 8'h11, 8'h55, 8'hBE, 8'hBE, 8'h9A, 8'h11, 8'h55, 8'hBE, 8'h35, 8'h11, 8'h08, 8'h0C, 8'h11, 8'h08, 8'h08, 8'h08, 8'h0C, 8'h11, 8'h11, 8'h0C, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h08, 8'h2C, 8'h08, 8'h51, 8'hBE, 8'hBE, 8'h9E, 8'h11, 8'h55, 8'hBF, 8'hBE, 8'h7A, 8'h11, 8'h11, 8'h11, 8'h08, 8'h08, 8'h08, 8'h08, 8'h08, 8'h0C, 8'h08, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h28, 8'h2C, 8'h08, 8'h51, 8'hBE, 8'h9A, 8'h7A, 8'h35, 8'h55, 8'h9A, 8'h9A, 8'h7A, 8'h11, 8'h11, 8'h0C, 8'h08, 8'h08, 8'h08, 8'h08, 8'h0C, 8'h0C, 8'h08, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h96, 8'hBE, 8'h11, 8'h55, 8'hBE, 8'h35, 8'h31, 8'hBE, 8'h7A, 8'h10, 8'h11, 8'h11, 8'h11, 8'h0C, 8'h08, 8'h08, 8'h08, 8'h08, 8'h0C, 8'h11, 8'h11, 8'h0D, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h4D, 8'h51, 8'h0C, 8'h55, 8'hBF, 8'h2D, 8'h29, 8'hBE, 8'h9A, 8'h7A, 8'h31, 8'h11, 8'h11, 8'h11, 8'h0C, 8'h04, 8'h04, 8'h08, 8'h0C, 8'h0C, 8'h0C, 8'h08, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h08, 8'h08, 8'h08, 8'h51, 8'hBE, 8'h29, 8'h24, 8'hBA, 8'hBE, 8'hBE, 8'h31, 8'h11, 8'h11, 8'h11, 8'h11, 8'h00, 8'h00, 8'h08, 8'h08, 8'h08, 8'h08, 8'h08, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h76, 8'h9E, 8'h11, 8'h11, 8'h35, 8'h04, 8'h00, 8'h24, 8'h24, 8'h24, 8'h04, 8'h04, 8'h04, 8'h04, 8'h04, 8'h00, 8'h29, 8'hBE, 8'h55, 8'h11, 8'h11, 8'h0C, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h71, 8'h76, 8'h0D, 8'h0C, 8'h0C, 8'h04, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h24, 8'h96, 8'h51, 8'h0C, 8'h0D, 8'h08, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 }
};


// pipeline (ff) to get the pixel color from the array 	 

//======--------------------------------------------------------------------------------------------------------------=

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout_d <=	8'h00;
	end
	else begin
		if (InsideRectangle == 1'b1 ) begin  // inside an external bracket 
					if (upIsPressed && ~ downIsPressed && ~rightIsPressed && ~leftIsPressed) begin//draw the object according to the movement direction
				if(is_green)//in every if there is two options for green and yellow tank
				RGBout_d <= green_up_tank[offsetY][offsetX];
			else
				RGBout_d <= yelow_up_tank[offsetY][offsetX];
				lastkey <= 2'd0;
			end
			// using smart rotating of tanks to avoid using extra bitmaps
			
			else if (downIsPressed && ~ upIsPressed && ~rightIsPressed && ~leftIsPressed ) begin
			if(is_green)
				RGBout_d <= green_up_tank[((OBJECT_HEIGHT_Y-1)-offsetY)][((OBJECT_WIDTH_X-1)-offsetX)];
			else
				RGBout_d <= yelow_up_tank[((OBJECT_HEIGHT_Y-1)-offsetY)][((OBJECT_WIDTH_X-1)-offsetX)];
				lastkey <= 2'd2;
			end
						
			else if (rightIsPressed && ~ downIsPressed && ~upIsPressed && ~leftIsPressed) begin
				if(is_green)
				RGBout_d <= green_up_tank[((OBJECT_WIDTH_X-1)-offsetX)][offsetY];
			else
				RGBout_d <= yelow_up_tank[((OBJECT_WIDTH_X-1)-offsetX)][offsetY];
				lastkey <= 2'd3;
			end
			else if (leftIsPressed && ~ downIsPressed && ~rightIsPressed && ~upIsPressed) begin
				if(is_green)
				RGBout_d <= green_up_tank[offsetX][((OBJECT_HEIGHT_Y-1)-offsetY)];
			else
				RGBout_d <= yelow_up_tank[offsetX][((OBJECT_HEIGHT_Y-1)-offsetY)];
				lastkey <= 2'd1;
			end
			else begin// this else cause to the object stay in the last direction when there is not movement
				if (lastkey == 2'd0) begin
						if(is_green)
							RGBout_d <= green_up_tank[offsetY][offsetX];
						else
							RGBout_d <= yelow_up_tank[offsetY][offsetX];
				end
				else if (lastkey == 2'd2) begin
						if(is_green)
							RGBout_d <= green_up_tank[((OBJECT_HEIGHT_Y-1)-offsetY)][((OBJECT_WIDTH_X-1)-offsetX)];
						else
							RGBout_d <= yelow_up_tank[((OBJECT_HEIGHT_Y-1)-offsetY)][((OBJECT_WIDTH_X-1)-offsetX)];
				end
				else if (lastkey == 2'd3) begin
						if(is_green)
							RGBout_d <= green_up_tank[((OBJECT_WIDTH_X-1)-offsetX)][offsetY];
						else
							RGBout_d <= yelow_up_tank[((OBJECT_WIDTH_X-1)-offsetX)][offsetY];
				end
				else if (lastkey == 2'd1) begin
						if(is_green)
							RGBout_d <= green_up_tank[offsetX][((OBJECT_HEIGHT_Y-1)-offsetY)];
						else
							RGBout_d <= yelow_up_tank[offsetX][((OBJECT_HEIGHT_Y-1)-offsetY)];
				end
			end
		end
		else	
			RGBout_d <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end
//======--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = InsideRectangle;
assign last_key = lastkey;
assign RGBout = (RGBout_d == 8'hFF) ? 8'h00 :  RGBout_d ; 
endmodule