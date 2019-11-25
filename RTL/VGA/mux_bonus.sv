

module mux_bonus
(
	input logic [10:0] topLeftPixelX,
	input logic [10:0] topLeftPixelY,
	input logic [10:0] topLeftMoveX,
	input logic [10:0] topLeftMoveY,
	input logic activate, // 1 in pre-start state
	
	output logic [10:0] topLeftX,
	output logic [10:0] topLeftY
  ) ;
  
  always_comb begin
	if (activate) begin
		topLeftX = topLeftPixelX;
		topLeftY = topLeftPixelY;
	end
	else begin
		topLeftX = topLeftMoveX;
		topLeftY = topLeftMoveY;
	end
  end
endmodule 