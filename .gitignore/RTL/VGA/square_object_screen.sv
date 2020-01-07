
module	square_object_screen	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					//----------- all signals with initial n are disabled for game - the signals were used for editing memory
					
					input 	logic	[10:0] ntopLeftX, //position on the screen 
					input 	logic	[10:0] ntopLeftY,
					input 	logic	[10:0] nOBJECT_WIDTH_X,
					input 	logic	[10:0] nOBJECT_HEIGHT_Y,
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,
					output	logic	drawingRequest, // indicates pixel inside the bracket
					output	logic	[7:0]	 RGBout //optional color output for mux 
);

int OBJECT_WIDTH_X = 256;
int OBJECT_HEIGHT_Y = 256;
int topLeftX = 130;
int topLeftY = 100;
parameter  logic [7:0] OBJECT_COLOR = 8'h5b ; 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 int rightX ; //coordinates of the sides  
int bottomY ;
logic insideBracket ; 

//======--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries
assign rightX	= (topLeftX + OBJECT_WIDTH_X);
assign bottomY	= (topLeftY + OBJECT_HEIGHT_Y);


//======--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout			<=	8'b0;
		drawingRequest	<=	1'b0;
	end
	else begin 
		insideBracket  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < rightX) // ----- LEGAL BLOCKING ASSINGMENT in ALWAYS_FF CODE 
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY) )  ; 
		
		if (insideBracket ) // test if it is inside the rectangle 
		begin 
			RGBout  <= OBJECT_COLOR ;	// colors table 
			drawingRequest <= 1'b1 ;
			offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner
			offsetY	<= (pixelY - topLeftY);
		end 
		
		else begin  
			RGBout <= TRANSPARENT_ENCODING ; // transparent color
			drawingRequest <= 1'b0 ; // so it will not be displayed 
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
		end 
		
	end
end 
endmodule 