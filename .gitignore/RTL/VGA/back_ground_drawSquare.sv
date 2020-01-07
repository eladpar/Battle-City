//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	back_ground_drawSquare	(	

					input	logic	clk,
					input	logic	resetN,
					input 	logic	[10:0]	pixelX,
					input 	logic	[10:0]	pixelY,

					output	logic	[7:0]	BG_RGB,
					output	logic	border
);

const int	xFrameSize	=	543;
const int	yFrameSize	=	479;
const int	bracketOffset =	10;

logic [2:0] redBits;
logic [2:0] greenBits;
logic [1:0] blueBits;

localparam logic [2:0] DARK_COLOR = 3'b000 ;// bitmap of a dark color
localparam logic [2:0] LIGHT_COLOR = 3'b111 ;// bitmap of a light color

assign BG_RGB =  {redBits , greenBits , blueBits} ; //collect color nibbles to an 8 bit word 

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
				redBits <= DARK_COLOR ;	
				greenBits <= DARK_COLOR  ;	
				blueBits <= DARK_COLOR ;
				border<=1'd0;		
	end 
	else begin
	
	// defaults 
		greenBits <= DARK_COLOR ; 
		redBits <= DARK_COLOR ;
		blueBits <= DARK_COLOR;
		border<=1'd0;
					
	// draw the white borders 
		if ((pixelX == 0 && pixelY <= yFrameSize) || pixelY == 0  || (pixelX == xFrameSize && pixelY <= yFrameSize) || pixelY == yFrameSize)
			begin 
				redBits <= LIGHT_COLOR ;	
				greenBits <= LIGHT_COLOR ;	
				blueBits <= LIGHT_COLOR ;
			border<=1'd1;	// 3rd bit will be truncked
			end
		if ( pixelX > xFrameSize)
			begin 
				redBits <= 3'b011 ;	
				greenBits <= 3'b011 ;	
				blueBits <= 2'b01 ;	// 3rd bit will be truncked
			end
		

	
	// note numbers can be used inline if they appear only once 
			

	end; 	
end 

endmodule

