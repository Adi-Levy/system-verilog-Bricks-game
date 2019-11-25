
// holding and managing the brick matrices that are displayed according to the level
// printing the brick matrices by color
// holding the randomized brick matrix
// holding the number of bricks left on the board to finish the level


module	brik_mat	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] topX, // offset from top left  position 
					input logic	[10:0] topY,
					input logic [10:0] pixelX, // current scanned pixel
					input logic [10:0] pixelY,
					input logic collision, // input of a ball collision with a brick
					input logic random, // allowing to randomize the brick matrix
					input logic [7:0] randomColor, // input color to the matrix
					input logic [7:0] randomIndex, // count of how many colors were enteres so far
					input logic [1:0] lvl, // level of play currently
					//input logic tets,

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout,		//rgb value from the current matrix 
					output   logic [7:0] scoringColor, // the color that was colided with for score keeping
					output   logic noBricks, // signal to notify end of level
					output   logic [10:0] offsetX, // the offset from the top left of the current brick
					output   logic [10:0] offsetY
);
	
	
	localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 
	localparam  int BRIK_WIDTH = 32;
   localparam  int BRIK_HEIGHT = 16;
	localparam  int MAT_WIDTH = 16 * BRIK_WIDTH;
	localparam  int MAT_HEIGHT = 16 * BRIK_HEIGHT;
	
	// level matrices for the first 2 levels 
	localparam  logic [0:15] [0:15] [7:0] COLORSLVL1 =  {
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D},
		{8'hFF, 8'h1C, 8'h1C, 8'h1C, 8'h1C, 8'h1C, 8'h1C, 8'h1C, 8'h1C, 8'h1C, 8'h1C, 8'h1C, 8'h1C, 8'h1C, 8'h1C, 8'hFF},
		{8'hFF, 8'hFF, 8'hE3, 8'hE3, 8'hE3, 8'hE3, 8'hE3, 8'hE3, 8'hE3, 8'hE3, 8'hE3, 8'hE3, 8'hE3, 8'hE3, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'h6C, 8'h6C, 8'h6C, 8'h6C, 8'h6C, 8'h6C, 8'h6C, 8'h6C, 8'h6C, 8'h6C, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h03, 8'h03, 8'h03, 8'h03, 8'h03, 8'h03, 8'h03, 8'h03, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF} 
		};
		
	localparam  logic [0:15] [0:15] [7:0] COLORSLVL2 =  {
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFC, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'hFC, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFC, 8'h6D, 8'hE0, 8'h6D, 8'h6D, 8'hE0, 8'h6D, 8'hFC, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFC, 8'h6D, 8'hE0, 8'h6D, 8'h6D, 8'hE0, 8'h6D, 8'hFC, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFC, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'hFC, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'hFC, 8'h1F, 8'h1F, 8'h1F, 8'h1F, 8'hFC, 8'h6D, 8'h6D, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'h6D, 8'hFF, 8'hFF, 8'hFC, 8'h1F, 8'h1F, 8'h1F, 8'h1F, 8'hFC, 8'hFF, 8'hFF, 8'h6D, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFC, 8'h1F, 8'h1F, 8'h1F, 8'h1F, 8'hFC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hFF, 8'hFF, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'hFF, 8'hFF, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF} 
		};
		
	localparam  logic [0:15] [0:15] [7:0] COLORSLVLTETS =  {
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF},
		{8'hE0, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF} 
		};
	
	logic [0:15] [0:15] [7:0] object_colors = COLORSLVL1;
	logic insideBracket;
	logic enable_flag = 1'b0;
	logic lvl2_flag = 1'b0;
	logic lvl1_flag = 1'b0;
	logic lvl3_flag = 1'b0;
	logic [3:0] not_mod = 4'd0;
	logic [8:0] numBricks = 9'd0;
	logic random_d = 1'd0;
		
		// pipeline (ff) to get the pixel color from the array 	 

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <= TRANSPARENT_ENCODING;
		object_colors <= COLORSLVL1;
		enable_flag <= 1'b0;
		lvl2_flag <= 1'b0;
		numBricks <= 9'd0;
		lvl1_flag <= 1'b0;
		random_d <= 1'd0;
		lvl3_flag <= 1'b0;
	end
	else begin
		random_d <= random;
		
		// reseting the current brick matrix when moving levels
		if(lvl == 2'd1 && !lvl1_flag) begin
			numBricks <= 9'd60;
			lvl1_flag <= 1'b1;
			object_colors <= COLORSLVL1;
			lvl2_flag <= 1'b0;
			lvl3_flag <= 1'b0;
		end
		
		if(lvl == 2'd2 && !lvl2_flag) begin
			lvl2_flag <= 1'd1;
			numBricks <= 9'd96;
			object_colors <= COLORSLVL2;
			lvl1_flag <= 1'b0;
			lvl3_flag <= 1'b0;
		end
		
		if(lvl == 2'd3 && !lvl3_flag) begin
			numBricks <= 9'd0;
			lvl3_flag <= 1'b1;
		end
		
		// generating the random brick matrix
		if (random_d && (randomIndex < 8'd255)) begin
			lvl1_flag <= 1'b0;
			lvl2_flag <= 1'b0;
			
			// switching starting side every row
			if((randomIndex/16)%2 == 8'd0 ) 
				object_colors[randomIndex/16][randomIndex%16] <= randomColor;
			else if ((randomIndex/16)%2 == 8'd1 ) begin
				not_mod = (randomIndex%16);
				object_colors[randomIndex/16][~(not_mod)] <= randomColor;
			end
			
			// counting the number of bricks that were entered in the random matrix
			if(randomColor != TRANSPARENT_ENCODING)
				numBricks <= numBricks + 9'd1;
			
		end
		
		insideBracket  = 	 ( (pixelX  >= topX) &&  (pixelX < (MAT_WIDTH + topX)) // ----- LEGAL BLOCKING ASSINGMENT in ALWAYS_FF CODE 
								&& (pixelY  >= topY) &&  (pixelY < (MAT_HEIGHT + topY)) );
		
		if (insideBracket == 1'b1)   // inside an external bracket 
			RGBout <= object_colors[(pixelY-topY)/BRIK_HEIGHT][(pixelX-topX)/BRIK_WIDTH];	//get RGB from the colors table  
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
		
		if ((collision==1'b1)) begin
			// changing color and not breaking brick according to colors
			if(object_colors[(pixelY-topY)/BRIK_HEIGHT][(pixelX-11'b1-topX)/BRIK_WIDTH] == 8'hFC)
				object_colors[(pixelY-topY)/BRIK_HEIGHT][(pixelX-11'b1-topX)/BRIK_WIDTH] <= 8'h6C;
			else if(object_colors[(pixelY-topY)/BRIK_HEIGHT][(pixelX-11'b1-topX)/BRIK_WIDTH] == 8'hE0)
				object_colors[(pixelY-topY)/BRIK_HEIGHT][(pixelX-11'b1-topX)/BRIK_WIDTH] <= 8'h60;
			else if(object_colors[(pixelY-topY)/BRIK_HEIGHT][(pixelX-11'b1-topX)/BRIK_WIDTH] == 8'h1F)
				object_colors[(pixelY-topY)/BRIK_HEIGHT][(pixelX-11'b1-topX)/BRIK_WIDTH] <= 8'h03;
			// breaking brick and updating the brick count
			else begin
				object_colors[(pixelY-topY)/BRIK_HEIGHT][(pixelX-11'b1-topX)/BRIK_WIDTH] <= TRANSPARENT_ENCODING;
				numBricks <= numBricks -9'd1;
			end
		end
	end 
end
			

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

// give out the color that was hit
assign scoringColor = object_colors[(pixelY-topY)/BRIK_HEIGHT][(pixelX-11'b1-topX)/BRIK_WIDTH];

// find out if there are more bricks
assign noBricks = (numBricks == 9'd0) ? 1'b1 : 1'b0 ;

// send the ofset from top left of the current brick
assign offsetX = ((pixelX-topX)%32);
assign offsetY = ((pixelY-topY)%16);

endmodule

