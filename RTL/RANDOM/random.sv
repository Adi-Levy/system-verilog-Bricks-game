
//get a random num 

module random 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input	logic	 rise,
	output logic [SIZE_BITS-1:0] dout	
  ) ;

// Generating a random number by latching a fast counter with the rising edge of an input ( e.g. key rising )
  
parameter SIZE_BITS = 8;
parameter MIN_VAL = 0;  //set the min and max values 
parameter MAX_VAL = 479;

	logic [SIZE_BITS-1:0] counter;
	logic rise_d;
	
	
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
			if (rise && !rise_d) // when in the last clock rise = 0, and in this clock it is 1 , take it out  
				dout <= counter;
		end
	
	end
 
endmodule

