//
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 
// generating a number bitmap 



module matrice_init	(	
					output	logic	[0:14] [0:19]		mat_out0,
					output	logic	[0:14] [0:19]		mat_out1,
					output	logic	[0:14] [0:19]		mat_out2,
					output	logic	[0:14] [0:19]		mat_out3
);

//parameter  logic	[7:0] digit_color = 8'hff ; //set the color of the digit 



//15 lines of y
//20 lines of x

bit [0:14] [0:19] mat0  = 


{20'b	11000000000000000000000000000000,
20'b	01000000000000000000000000100000,
20'b	01000000000000000000000000000000,
20'b	01000000000000000000000000000000,
20'b	11000000000000000000000000000000,
20'b	11000000000000000000000000000000,
20'b	11000000000000000000000000000000,
20'b	01000000000000000000000000000000,
20'b	11000000000000000000000000000000,
20'b	11000000000000000000000000000000,
20'b	11000000000000000000000000000000,
20'b	01000000000000000000000000000000,
20'b	01000000000000000000000000000000,
20'b	11000000000000000000000000000000,
20'b	01000000000000000000000000000000
};
bit [0:14] [0:19] mat1  = 


{20'b	00000000000000000000000000000000,
20'b	01000000000000000000000000000000,
20'b	01000000000000000000000000000000,
20'b	01000000000000000000000000000000,
20'b	11000000000000000000000000000000,
20'b	11000000000001111111110000000000,
20'b	11000000000000000000000000100000,
20'b	01000000000000000000000000000000,
20'b	11000000111000000000001110000000,
20'b	11000000000000000000000000000000,
20'b	11000000000000000000000000000000,
20'b	01000000001111111111110000000000,
20'b	01000000000000000000000000000000,
20'b	11000000000000000000000000000000,
20'b	01000000000000000000000000000000
};
bit [0:14] [0:19] mat2  = 


{20'b	00000000000000000000000000000000,
20'b	01000000000000000000000000100000,
20'b	01000000000000000000000000000000,
20'b	01000000000000000000000000000000,
20'b	11000000000000000000000000000000,
20'b	11000000000000000000000000000000,
20'b	11000000000000000000000000100000,
20'b	01000000000000000000000000000000,
20'b	11000000111000000000001110000000,
20'b	11000000000000000000000000000000,
20'b	11000000000000000000000000000000,
20'b	01000000001111111111110000000000,
20'b	01000000001111111111110000000000,
20'b	11000000000000000000000000000000,
20'b	01000000000000000000000000000000
};
bit [0:14] [0:19] mat3  = 


{20'b	00000000000000000000,
20'b	11100000100000000000,
20'b	10100001100111110100,
20'b	11100010010001000100,
20'b	10100111110001000100,
20'b	11101000001001000111,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	01000000000000000000,
20'b	01000000001111111111,
20'b	11000000000000000000,
20'b	01000000000000000000
};															
 
																	
	assign mat_out0 = mat0 ;
	assign mat_out1 = mat1 ;
	assign mat_out2 = mat2 ;
	assign mat_out3 = mat3 ;





// pipeline (ff) to get the pixel color from the array 	 
/*
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest <=	1'b0;
	end
	else begin
			drawingRequest <= (number_bitmap[digit][offsetY][offsetX]) && (InsideRectangle == 1'b1 );	//get value from bitmap  
	end 
end

assign RGBout = digit_color ; // this is a fixed color */

endmodule