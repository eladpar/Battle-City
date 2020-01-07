//-- Alex Grinshpun Apr 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018


module	VGA_Controller	(	//	Host Side
					input		logic [7:0]		Red,
					input		logic	[7:0]		Green,
					input		logic	[7:0]		Blue,
					output	logic	[10:0]	PixelX,
					output	logic	[10:0]	PixelY,
					output	logic			StartOfFrame,
						//	VGA Side
					output	logic	[7:0]	oVGA_R,
					output	logic	[7:0]	oVGA_G,
					output	logic	[7:0]	oVGA_B,
					output	logic			oVGA_HS,
					output	logic			oVGA_VS,
					output	logic			oVGA_SYNC,
					output	logic			oVGA_BLANK,
					output	logic			oVGA_CLOCK,
						//	Control Signal
					input		logic	clk,
					input		logic	resetN	);

//	Internal Registers
logic			[10:0]	H_Cont;
logic			[10:0]	V_Cont;
////////////////////////////////////////////////////////////
//	Horizontal	Parameter
const int	H_FRONT	=	16;
const int	H_SYNC	=	96;
const int	H_BACK	=	48;
const int	H_ACT	=	640;
const int	H_BLANK	=	H_FRONT+H_SYNC+H_BACK;
const int	H_TOTAL	=	H_FRONT+H_SYNC+H_BACK+H_ACT;
////////////////////////////////////////////////////////////
//	Vertical Parameter
const int	V_FRONT	=	11;
const int	V_SYNC	=	2;
const int	V_BACK	=	31;
const int	V_ACT	=	480;
const int	V_BLANK	=	V_FRONT+V_SYNC+V_BACK;
const int	V_TOTAL	=	V_FRONT+V_SYNC+V_BACK+V_ACT;

logic VGA_VS_pulse;
logic VGA_VS_d;
int VGA_VS_pulse_cnt;
logic			timer_done;

////////////////////////////////////////////////////////////
assign	oVGA_SYNC	=	1'b1;			//	This pin is unused.
assign	oVGA_BLANK	=	~((H_Cont<H_BLANK)||(V_Cont<V_BLANK));
assign	oVGA_CLOCK	=	~clk;
assign	oVGA_R		=	Red;
assign	oVGA_G		=	Green;
assign	oVGA_B		=	Blue;
assign	PixelX	=	(H_Cont>=H_BLANK)	?	H_Cont-H_BLANK	:	11'h0	;
assign	PixelY	=	(V_Cont>=V_BLANK)	?	V_Cont-V_BLANK	:	11'h0	;


//Dudy Bar-On Prescaler a 25 MHZ generator from 50 MHZ 
logic clk_25;
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		clk_25	<=	1'b0;
	end
	else
	begin
		clk_25 <=	!clk_25;
	end
end
	


//	Horizontal Generator: Refer to the pixel clock
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		H_Cont		<=	0;
		oVGA_HS		<=	1;
	end
	else
	begin
		if(H_Cont<H_TOTAL) begin
			if (clk_25== 1'b0) begin              //Dudy Bar-On
					H_Cont	<=	H_Cont+1'b1;
			end 
			end
		else
		H_Cont	<=	0;
		//	Horizontal Sync
		if(H_Cont==H_FRONT-1)			//	Front porch end
		oVGA_HS	<=	1'b0;
		if(H_Cont==H_FRONT+H_SYNC-1)	//	Sync pulse end
		oVGA_HS	<=	1'b1;
	end
end

//	Vertical Generator: Refer to the horizontal sync
always_ff@(posedge oVGA_HS or negedge resetN)
begin
	if(!resetN)
	begin
		V_Cont		<=	0;
		oVGA_VS		<=	1;
	end
	else
	begin
		if(V_Cont<V_TOTAL)
			V_Cont	<=	V_Cont+1'b1;
		else
			V_Cont	<=	0;
		//	Vertical Sync
		if(V_Cont==V_FRONT-1)			//	Front porch end
			oVGA_VS	<=	1'b0;
		if(V_Cont==V_FRONT+V_SYNC-1)	//	Sync pulse end
			oVGA_VS	<=	1'b1;
	end
end



//---- Timer -------
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		VGA_VS_d	<= 0;
	end
	else
	begin
		VGA_VS_d	<= oVGA_VS;
	end
end

assign VGA_VS_pulse	= !oVGA_VS && VGA_VS_d;



assign StartOfFrame	= VGA_VS_pulse;

endmodule