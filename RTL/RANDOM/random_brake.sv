//get a random num 

module random_brake 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input logic  brake,
	
	output logic [SIZE_BITS-1:0] dout	
  ) ;

// Generating a random number by latching a fast counter with the release of key
  
parameter SIZE_BITS = 8;
parameter MIN_VAL = 0;  //set the min and max values 
parameter MAX_VAL = 479;

	logic [SIZE_BITS-1:0] counter; //the random output
	logic flag = 1'b0;
	
	
always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin 
			dout <= 0;
			counter <= MIN_VAL;
			flag <= 1'b0;
		end
		
		else begin
			counter <= counter+1; 
			if ( counter > MAX_VAL ) 
				counter <=  MIN_VAL ; // set min and max mvalues 
			if (brake && !flag) begin	// rising edge 
				dout <= counter;
				flag <= 1'b1;
			end
			else if (flag) // after the rising of the brake signal, get the counter in the output every clock.
				dout <= counter;
		end
	
	end
 
endmodule

