

module score_letter_mux
(
	input logic clk,
	input logic resetN,
	input logic [10:0] offsetX,
	input logic [10:0] offsetY,
	
	output logic [10:0] outOffsetX,
	output logic [10:0] outOffsetY,
	output logic [5:0] letter
);

logic [6:0] index;

always_ff@(posedge clk or negedge resetN) begin

	if(!resetN) begin
		letter <= 6'd0;
	end
	
	else begin
		index = (((offsetY/16)*16) + (offsetX/8));
		outOffsetX <= (offsetX%8);
		outOffsetY <= (offsetY%16);
		case (index)
			7'd0: letter <= 6'd4;
			7'd1: letter <= 6'd6;
			7'd2: letter <= 6'd8;
			7'd3: letter <= 6'd2;
			7'd4: letter <= 6'd3;
			default: letter <= 6'd0;
		endcase
	end
end

endmodule
		