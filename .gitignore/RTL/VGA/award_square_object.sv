module	award_square_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					input 	logic   take1,//the award taeked by one of the players 
					input 	logic	take2,
					input 	logic   [4:0]randomX,// random position for the image 
					input 	logic	[4:0]randomY,
					input 	logic	up,//the award show
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,
					output	logic	drawingRequest, // indicates pixel inside the bracket
					output	logic	[7:0]	 RGBout,
				    output	logic	ena	//the award disapear 
);

parameter  int OBJECT_WIDTH_X = 100;
parameter  int OBJECT_HEIGHT_Y = 100;
logic    [10:0]topLeftX;
logic    [10:0]topLeftY;
parameter  logic [7:0] OBJECT_COLOR = 8'h5b ; 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
logic tmp_take;//avoid from long collision 
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
		tmp_take <= 1'b1;
	end
	else begin 
		topLeftX<= randomX*32;//expend the offset that arrive from the random
		topLeftY<= randomY*32;
		insideBracket  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < rightX) // ----- LEGAL BLOCKING ASSINGMENT in ALWAYS_FF CODE 
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY) )  ; 
		if (tmp_take || (take1) || (take2)) begin//the award need to disapear
			tmp_take <= 1'b1;
		end
		if(up)
		tmp_take <= 1'b0;//the award show
		else if (insideBracket ) // test if it is inside the rectangle 
		begin 
			RGBout  <= OBJECT_COLOR ;	// colors table 
			drawingRequest <= 1'b1 ;
			offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner
			offsetY	<= (pixelY - topLeftY);
		end 
		
		else begin  
			RGBout <= TRANSPARENT_ENCODING ; // so it will not be displayed 
			drawingRequest <= 1'b0 ;// transparent color 
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
		end 
		
	end
end 
assign ena=tmp_take;
endmodule 
