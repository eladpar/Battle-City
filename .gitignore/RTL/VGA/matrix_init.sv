

module matrix_init	(	//this module creat 4 difrent maps of bricks and send them to the square
					output	logic	[0:14] [0:19]		mat_out0,
					output	logic	[0:14] [0:19]		mat_out1,
					output	logic	[0:14] [0:19]		mat_out2,
					output	logic	[0:14] [0:19]		mat_out3
);

//15 lines of y
//20 lines of x

bit [0:14] [0:19] mat0  = 
{
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h1,	1'h1,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,

};

/*{20'b	00000011011000000000,
20'b	00000001010000000000,
20'b	01100000111111111111,
20'b	01110000000000000000,
20'b	01111000000000000000,
20'b	01111100000000000000,
20'b	01111110000000000000,
20'b	01111111000011111110,
20'b	01111111100001111110,
20'b	00000000000000111110,
20'b	00000000000000011110,
20'b	00000000000000001110,
20'b	11111111111110000110,
20'b	00000000100000000000,
20'b	00000011011000100000
};*/
bit [0:14] [0:19] mat1  = 
{
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,

};

/*{20'b	00000001000001000000,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	00011111111111111000,
20'b	00000111111111100000,
20'b	00000011000011000000,
20'b	01111111000011000000,
20'b	00000011000011000000,
20'b	00000111111111100000,
20'b	00011111111111111000,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	00000010000000100000
};*/
bit [0:14] [0:19] mat2  = 
{
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h1,	1'h1,	1'h1,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h1,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,

};

/*{20'b	00000000000000000000,
20'b	11111110000111111100,
20'b	11000000000110000000,
20'b	11111110000111111100,
20'b	11000000000110000000,
20'b	11111110000111111100,
20'b	00000000000000000000,
20'b	00000000000000000000,
20'b	11000000000100011111,
20'b	11000000001100010001,
20'b	11000000010010011111,
20'b	11000000111110010001,
20'b	11111110100001011111,
20'b	00000000000000000000,
20'b	00000000000000000000
};*/
bit [0:14] [0:19] mat3  = 


{
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h1,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h1,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,
1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h1,	1'h0,	1'h1,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,	1'h0,

};															
 
																	
	assign mat_out0 = mat0 ;
	assign mat_out1 = mat1 ;
	assign mat_out2 = mat2 ;
	assign mat_out3 = mat3 ;

endmodule