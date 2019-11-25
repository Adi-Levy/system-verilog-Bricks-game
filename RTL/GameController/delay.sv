

module delay      	
	(

   input  logic clk, resetN, start,
	input  logic [2:0] bgState,
   output logic dout
   );
	parameter logic [25:0] DelayTime = 26'd20_000_000; 
	logic [25:0] cntr = 26'd0;
	logic start_flag = 1'b0;
	
	always_ff@(posedge clk or negedge resetN) begin
		if (!resetN) begin
			cntr <= DelayTime;
			start_flag <= 1'b0;
		end
		
		else begin
			if (start && !start_flag && bgState == 3'd2)
				start_flag <= 1'b1;
			else if (cntr > 0 && start_flag)
				cntr <= (cntr - 26'd1);
		end
	end
	
	assign dout = (cntr == 26'd0) ? 1'd1 : 1'b0;
endmodule
