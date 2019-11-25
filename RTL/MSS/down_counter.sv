// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 

// Implements a down counter 9 to 0 with enable and loadN data
// and count and tc outputs
// creates a delay and time durration for blaying sounds

module down_counter
	(
	input logic clk, resetN, ena, ena_cnt, loadN, 
	input logic [3:0] datain,
	output logic tc
   );

	logic [25:0] count = 26'd0;
// Down counter
always_ff @(posedge clk or negedge resetN)
   begin
	      
      if ( !resetN )	begin // Asynchronic reset
			count<=26'd0;
		end
				
      else 	begin		// Synchronic logic		
			if (!loadN && ena) count<=datain;
			else if (count==26'd0 && ena_cnt && ena ) count<=26'd10_000_000; // reseting counter when there is a collision 
			else if(ena && loadN && count > 26'd0) count<=count-26'd1;
			else count<=count;
		end //Synch
	end //always
	
	// Asynchronic tc
	assign tc = (count > 26'd0) ? 1'b1 : 1'b0 ;// output signal to enable sound only when counting down
				
					
endmodule

