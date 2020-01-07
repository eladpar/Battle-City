//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering  May 2019 

module	objects_mux	(
//		--------	Clock Input		
					input		logic	clk,
					input		logic	resetN,
					// inputs from every bitmap
					input		logic	smileyDrawingRequest, //-------tank RGB two set of inputs per unit
					input		logic	[7:0] smileyRGB, 
					input			logic rocket1DrawingRequest,
					input			logic [7:0] rocket1RGB,
					input		logic	[7:0] backGroundRGB, 
					input		logic	tank2DrawingRequest, // two set of inputs per unit
					input		logic	[7:0] tank2RGB, 
					input			logic rocket2DrawingRequest,
					input			logic [7:0] rocket2RGB,
					input			logic brickDrawingRequest,
					input			logic [7:0] brickRGB,
					input			logic heartCount1DrawingRequest,
					input			logic [7:0] heartCount1RGB,
					input			logic heartCount2DrawingRequest,
					input			logic [7:0] heartCount2RGB,
					input			logic goldDrawingRequest,
					input			logic [7:0] goldRGB,
					input			logic goldCount1DrawingRequest,
					input			logic [7:0] goldCount1RGB,
					input			logic goldCount2DrawingRequest,
					input			logic [7:0] goldCount2RGB,
					input			logic base1DrawingRequest,
					input			logic [7:0] base1RGB,
					input			logic base2DrawingRequest,
					input			logic [7:0] base2RGB,
					input			logic  screenDrawingRequest,
					input			logic [7:0] screenRGB,
					input			logic  enable_game,
					input			logic UPgoldCount1DrawingRequest,
					input			logic [7:0] UPgoldCount1RGB,
					input			logic DOWNgoldCount2DrawingRequest,
					input			logic [7:0] DOWNgoldCount2RGB,
					input			logic heartDrawingRequest,
					input			logic [7:0] heartRGB,
					input			logic strongbrickDrawingRequest,
					input			logic [7:0] strongbrickRGB,
					output	logic	[7:0] redOut, // full 24 bits color output
					output	logic	[7:0] greenOut, 
					output	logic	[7:0] blueOut 
);

logic [7:0] tmpRGB;


assign redOut	  = {tmpRGB[7:5], {5{tmpRGB[5]}}}; //--  extend LSB to create 10 bits per color  
assign greenOut  = {tmpRGB[4:2], {5{tmpRGB[2]}}};
assign blueOut	  = {tmpRGB[1:0], {6{tmpRGB[0]}}};

//======--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (enable_game == 1'b1) begin
			if (smileyDrawingRequest == 1'b1 )//1 priority   
					tmpRGB <= smileyRGB; 
			else if (brickDrawingRequest == 1'b1)//2 priority
				tmpRGB <= brickRGB;
			else if (strongbrickDrawingRequest == 1'b1)//3 priority
				tmpRGB <= strongbrickRGB;
			else if (tank2DrawingRequest == 1'b1 )   
				tmpRGB <= tank2RGB;  
			else if (rocket1DrawingRequest == 1'b1 )
				tmpRGB <= rocket1RGB;
			else if (rocket2DrawingRequest == 1'b1 )  
				tmpRGB <= rocket2RGB;
			else if (heartCount1DrawingRequest == 1'b1 )
				tmpRGB <= heartCount1RGB;
			
			else if (heartCount2DrawingRequest == 1'b1 )
				tmpRGB <= heartCount2RGB;
			else if (goldDrawingRequest == 1'b1 ) 
				tmpRGB <= goldRGB;
			else if (goldCount1DrawingRequest == 1'b1 ) 
				tmpRGB <= goldCount1RGB;
			else if (goldCount2DrawingRequest == 1'b1 ) 
				tmpRGB <= goldCount2RGB;
			else if (UPgoldCount1DrawingRequest == 1'b1 )  
				tmpRGB <= UPgoldCount1RGB;
			else if (DOWNgoldCount2DrawingRequest == 1'b1 ) 
				tmpRGB <= DOWNgoldCount2RGB;
			else if (base1DrawingRequest == 1'b1 ) 
				tmpRGB <= base1RGB;
			else if  (base2DrawingRequest == 1'b1 ) 
				tmpRGB <= base2RGB;
			else if (heartDrawingRequest == 1'b1 )  
				tmpRGB <= heartRGB;
			else
				tmpRGB <= backGroundRGB ; // last priority
		end
		// screen RGB genereted by TOP_Game_Control		
		else begin
			if (screenDrawingRequest == 1'b1 )   
					tmpRGB <= screenRGB; 
			else 
				tmpRGB <= backGroundRGB ;
		end
		
	end ; 
	
	end

endmodule


