
//pick a random bonus


module randomBonus 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input	logic	 rise,
	output logic [2:0] dout	
  ) ;

// Generating a random number by latching a fast counter with the rising edge of an input ( e.g. key is rising )
  
parameter SIZE_BITS = 4;
parameter MIN_VAL = 0;  //set the min and max values 
parameter MAX_VAL = 15;

	int counter;
	logic rise_d;
	localparam	logic [0:15] [2:0]	bonuses = {3'd0, 3'd3, 3'd0, 3'd0, 3'd1, 3'd4, 3'd0, 3'd0, 3'd2, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0};
		//                                             FAST              LONG  SLOW              SHORT 
		   
	
always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			dout <= 0;
			counter <= MIN_VAL;
			rise_d <= 1'b0;
		end
		
		else begin
			counter <= counter+1;
			if ( counter > MAX_VAL ) 
				counter <=  MIN_VAL ; // set min and max mvalues 
			rise_d <= rise;
			if (rise && !rise_d) // rising edge 
				dout <= bonuses[counter]; //the bonus that chosen randomly from the list
			else
				dout <= 3'd0;
		end
	
	end
 
endmodule

