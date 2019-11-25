// pick a color from the list and then in changing jumps pick 255 more colors


module random_color_create 	
 ( 
	input	logic clk,
	input	logic resetN, 
	input	logic	[3:0] jump, // the jump in the list
	input logic [3:0] initColor, // the first color
	input logic make,
	
	output logic [7:0] dout,
	output logic [7:0] counter	
  ) ;
	
	logic [3:0] color = 3'd6;
	logic start_flag = 1'd0;
	logic [3:0] initColor_d = 4'd3;
	logic [3:0] jump_d = 4'd0;
	logic [3:0] tmp_color = 4'd6;
	logic [15:0] [7:0]	colors = { 

		8'hFC,    // yellow 		
		8'hE0,   // red 		
		8'h03,   // blue
		8'hFF,   // no color		
		8'h1C,   // green
		8'hFF,   // no color
		8'hFF,   // no color
		8'h6D,   // grey
		8'hFF,   // no color
		8'hE3,	// magenta		
		8'h1F,	// cyan
		8'hFF,   // no color
		8'hFF,   // no color
		8'hFF,   // no color
		8'h60,  // maroon
		8'h6C}; // olive
			
  
  always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			counter <= 8'd0;
			jump_d <= 4'd1;
			initColor_d = 4'd3;
			start_flag <= 1'd0;
			color <= 4'd1;
			tmp_color <= 4'd1;
		end
		
		else begin
			jump_d <= jump;
			initColor_d <= initColor;
			if ((jump_d != jump) && !start_flag) begin // if the jump input change start new counting
				start_flag <= 1'b1;
				color <= initColor;
				counter <= counter + 8'd1;
			end
			if (start_flag && (counter < 8'd255)) begin // if started count, keep doing until counter=255.
				tmp_color = color + jump;
				counter <= counter + 8'd1; 
				if (tmp_color > 4'd15) 
					color <= tmp_color - 4'd15;
				else 
					color <= tmp_color;
			end
			if(initColor_d != initColor)
				start_flag <= 1'd0;
		end
	end
	assign dout = colors[color]; //pick the color from the list.
endmodule	
		
		
		
		
		
		
		