

module game_controller 	
 ( 
	input	logic clk,
	input	logic resetN, 
	input	logic ballReq,
	input	logic batReq,
	input logic brikReq,
	input logic [10:0] ballOffsetX,
	input logic [10:0] ballOffsetY,
	input logic startOfFrame,
	input logic [10:0] batOffSetX,
	output logic [4:0] ballCollision,
	output logic brikCollision,
	output logic [2:0] batCollision
  ) ;
  
  
  logic col;
  logic frame_flag = 1'b1;
  assign col = (brikReq || batReq);

	
  always_ff @(posedge clk or negedge resetN)
	begin
		if (resetN == 1'b0) begin
			ballCollision <= 5'd0;
			brikCollision <= 1'b0;
			frame_flag <= 1'b1;
			batCollision <= 3'd0;
		end
		
		else begin
			if (startOfFrame) frame_flag = 1'b1;
			if (ballReq && col && frame_flag) begin
				brikCollision <= brikReq;
				frame_flag <= 1'b0;
				if (ballOffsetX < 11'd7 && ballOffsetY <= 11'd10 && ballOffsetY >= 11'd3) ballCollision <= 5'b11000;       // hit right side of bat
				else if (ballOffsetX >= 11'd7 && ballOffsetY <= 11'd10 && ballOffsetY >= 11'd3) ballCollision <= 5'b10100; // hit left side of bat
				else if (ballOffsetY > 11'd10) begin // hit top side of bat
				
					ballCollision <= 5'b10010;
					if (batReq) begin
						if (batOffSetX < 11'd9) batCollision <= 3'b001;  // M30
						else if (batOffSetX < 11'd18) batCollision <= 3'b010; // M45
						else if (batOffSetX < 11'd27) batCollision <= 3'b011; // M60
						else if (batOffSetX < 11'd28) batCollision <= 3'b100; // ZERO
						else if (batOffSetX < 11'd37) batCollision <= 3'b101; // P60
						else if (batOffSetX < 11'd46) batCollision <= 3'b110; // P45
						else batCollision <= 3'b111; // P30
					end
					else batCollision <= 3'b000;
				end		
				else if (ballOffsetY < 11'd3) ballCollision <= 5'b10001;  // hit bottom side of bat
				else ballCollision <= 5'b10010;
			end
			else begin
				ballCollision <= 5'd0;
				brikCollision <= 1'b0;
				batCollision <= 3'b000;
			end
		end
	end
	
endmodule		 	