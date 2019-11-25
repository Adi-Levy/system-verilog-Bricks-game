

//
// generating a brick bitmap 



module brickBitMap	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] offsetX,// offset from top left  position 
					input 	logic	[10:0] offsetY,
					input		logic	InsideRectangle, //input that the pixel is within a bracket 
					
					output	logic	drawingRequest //output that the pixel should be dispalyed 
);
// generating a brick bitmap 


bit [0:15] [0:31] brick_bitmap  = {


32'b	00000000000000000000000000000000,
32'b	00001111111111111111111111111000,
32'b	00001111111111111111111111111000,
32'b	00011111111111111111111111111100,
32'b	00111111111111111111111111111100,
32'b	00111111111111111111111111111110,
32'b	01111111111111111111111111111110,
32'b	01111111111111111111111111111110,
32'b	01111111111111111111111111111110,
32'b	01111111111111111111111111111110,
32'b	00111111111111111111111111111110,
32'b	00111111111111111111111111111100,
32'b	00011111111111111111111111111100,
32'b	00001111111111111111111111111000,
32'b	00001111111111111111111111111000,
32'b	00000000000000000000000000000000};

				


// pipeline (ff) to get the pixel drawing request from the array 	 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest <=	1'b0;
	end
	else begin
			drawingRequest <= (brick_bitmap[offsetY][offsetX]) && (InsideRectangle == 1'b1 );	//get value from bitmap  
	end 
end

endmodule
