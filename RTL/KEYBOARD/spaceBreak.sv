
// module for outputing when a key is released

module spaceBreak
(
	input logic resetN, clk, rise, pressed,
	output logic breakSpace
);

logic flag = 1'b0;

always_ff@(posedge clk or negedge resetN) begin
	if(!resetN)
		breakSpace <= 1'b0;
	
	else begin
		if(rise) flag <= 1'd1;
		
		if(flag && !pressed) begin
			breakSpace <= 1'b1;
			flag <= 1'b0;
		end
		
		if(!flag)
			breakSpace <= 1'd0;
	end
end
endmodule
