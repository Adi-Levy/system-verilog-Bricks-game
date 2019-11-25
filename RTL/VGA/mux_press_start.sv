
// simple mux to set the ball location according to the game state


module mux_press_start 
(
	input logic [10:0] topLeftBatX,
	input logic [10:0] topLeftBatY,
	input logic [10:0] topLeftBallX,
	input logic [10:0] topLeftBallY,
	input logic selector, // 1 in pre-start state
	
	output logic [10:0] topLeftX,
	output logic [10:0] topLeftY
  ) ;
  
  always_comb begin
	// in preGame state clamping the ball to the bat
	if (selector) begin
		topLeftX = topLeftBatX + 11'd20;
		topLeftY = topLeftBatY - 11'd14;
	end
	// in game state letting the ball move in strait lines according to ball move module
	else begin
		topLeftX = topLeftBallX;
		topLeftY = topLeftBallY;
	end
  end
endmodule 