module	goldCount_square_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					input	   logic	[2:0]  more_gold,//counter of the amount of gold
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,
					output	logic	drawingRequest, // indicates pixel inside the bracket
					output	logic	[7:0]	 RGBout //optional color output for mux 
);

parameter  int OBJECT_WIDTH_X = 60;
parameter  int OBJECT_HEIGHT_Y = 16;
parameter  int top_X = 548;//position on the screen of the conter object
parameter  int top_Y = 30;
parameter  int ONE_OBJECT_SIZE = 20;//size of one object of the counter
parameter  int COUNTER_OFFSET = 20;//size of one object of the counter
parameter  logic [7:0] OBJECT_COLOR = 8'h5b ; 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 
int rightX ; //coordinates of the sides  
int bottomY ;
logic insideBracket ; 

//======--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries
assign rightX	= ( top_X+OBJECT_WIDTH_X+ONE_OBJECT_SIZE*(more_gold-COUNTER_OFFSET));
assign bottomY	= (top_Y+OBJECT_HEIGHT_Y);
//======--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout			<=	8'b0;
		drawingRequest	<=	1'b0;
	end
	else begin 
		//using blocking sentence inside an always_ff block and not waiting a clock to use the result  
		insideBracket  = 	 ( (pixelX  >= top_X) &&  (pixelX < rightX)&&(pixelX < (top_X+ONE_OBJECT_SIZE*4)) // ----- LEGAL BLOCKING ASSINGMENT in ALWAYS_FF CODE 
						   && (pixelY  >= top_Y) &&  (pixelY < bottomY) )  ; 
			if (insideBracket ) // test if it is inside the rectangle 
			begin 
				RGBout  <= OBJECT_COLOR ;	// colors table 
				drawingRequest <= 1'b1 ;
				offsetX	<= (pixelX - top_X); //calculate relative offsets from top left corner
				offsetY	<= (pixelY - top_Y);
			end 
		
			else begin  
				RGBout <= TRANSPARENT_ENCODING ; // so it will not be displayed 
				drawingRequest <= 1'b0 ;// transparent color 
				offsetX	<= 0; //no offset
				offsetY	<= 0; //no offset
			end 
		
	end
end 
endmodule 