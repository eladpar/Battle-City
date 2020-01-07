//-- Elad Paritzky Dec 2019



//mux moudule designed to identify which screen RGB vector to assign according to Top game State Machine
module	screens_mux	(
					input  		logic initial_screen,
					input  		logic green_screen,
					input  		logic yellow_screen,
					input		logic	initialDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] initialRGB, 
					input		logic	yellowDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] yellowRGB, 
					input		logic	greenDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] greenRGB, 
					
					output	logic	[7:0] RGBOut,
					output logic screenDrawingRequest
					);
logic [7:0] tmpRGB;
logic screenDrawingRequest_d;

//======--------------------------------------------------------------------------------------------------------------=
always_comb begin
// battle  city initial screen bitmap
	if (initial_screen == 1'b1 ) begin 
			RGBOut = initialRGB;
			screenDrawingRequest = initialDrawingRequest;
		end
		// green wining screen bitmap
	else if (green_screen == 1'b1 ) begin	
			RGBOut = greenRGB;
			screenDrawingRequest = greenDrawingRequest;
		end
		// yellow wining screen bitmap
	else if (yellow_screen == 1'b1 ) begin 
			RGBOut = yellowRGB;
			screenDrawingRequest = yellowDrawingRequest;
		end
		// battle  city initial screen bitmap -- default
	else begin  
			RGBOut = initialRGB;
			screenDrawingRequest = 1'b0;
		end 
 
end

endmodule


