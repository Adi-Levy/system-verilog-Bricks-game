
//dealing with collision


module collisionDetector 	
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
	input logic bonusDrawReq,
	input logic [2:0] legnth,
	output logic [4:0] ballCollision,
	output logic brikCollision,
	output logic [2:0] batCollision,
	output logic bonusCollision
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
			bonusCollision <= 1'b0;
		end
		
		else begin
			if (startOfFrame) frame_flag = 1'b1; //no more then one collision in a frame
			if (ballReq && col && frame_flag) begin //collision
				brikCollision <= brikReq;
				frame_flag <= 1'b0;
				if (ballOffsetX < 11'd7 && ballOffsetY <= 11'd10 && ballOffsetY >= 11'd3) ballCollision <= 5'b11000;       // hit right side of bat
				else if (ballOffsetX >= 11'd7 && ballOffsetY <= 11'd10 && ballOffsetY >= 11'd3) ballCollision <= 5'b10100; // hit left side of bat
				else if (ballOffsetY > 11'd10) begin // hit top side of bat
				
					ballCollision <= 5'b10010;
					if (batReq) begin //bat and ball collision
						if (batOffSetX < ((11'd4)<<(legnth/2))) batCollision <= 3'b001;  // hit the ball in angel of Minus 30
						else if (batOffSetX < ((11'd9)<<(legnth/2))) batCollision <= 3'b010; // angel of Minus 45
						else if (batOffSetX < ((11'd13)<<(legnth/2))) batCollision <= 3'b011; // angel of Minus 60
						else if (batOffSetX < ((11'd14)<<(legnth/2))) batCollision <= 3'b100; // angel of ZERO
						else if (batOffSetX < ((11'd18)<<(legnth/2))) batCollision <= 3'b101; // angel of Minus positive 60
						else if (batOffSetX < ((11'd23)<<(legnth/2))) batCollision <= 3'b110; // angel of Positive 45
						else batCollision <= 3'b111; // angel of positive 30
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
			
			if(batReq && bonusDrawReq) begin // bat bonus collision 
				bonusCollision <= 1'b1;
			end
			else begin
				bonusCollision <= 1'b0;
			end
		end
	end
	
endmodule	