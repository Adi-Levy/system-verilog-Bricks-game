

module bonus_Top
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input logic Start_of_frame,
	input logic [15:0] bonusCollision,
	input logic [2:0] bonusCode,
	input logic [10:0] pixelX,
	input logic [10:0] pixelY,
	input logic [10:0] ballX,
	input logic [10:0] ballY,

	
	output logic [15:0] bonusDrawReq,
	output logic [15:0] [7:0] bonusRGB,
	output logic [15:0] [2:0] outBonusCode
	
  ) ;


logic [3:0] bonusIndex;
logic [15:0] activate;
logic [2:0] bonusCode_d; //code with 1 clock delay

genvar i;
generate 
	for(i=0; i<16; i++)
	begin:shit
		oneBonus bonus(//inputs:
								.clk(clk), .resetN(resetN), .startOfFrame(Start_of_frame), .bonusCollision(bonusCollision[i]), 
								.bonusCode(bonusCode_d), .activate(activate[i]), .pixelX(pixelX), .pixelY(pixelY), .ballX(ballX), .ballY(ballY),
							//outputs:
								.bonusDrawReq(bonusDrawReq[i]), .bonusRGB(bonusRGB[i]), .outBonusCode(outBonusCode[i]));
	end 
endgenerate


always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			bonusIndex <= 4'b0;
			activate <= 16'b0;
		end
		else begin
			if(bonusCode != 3'd0)
			begin
				activate[bonusIndex] <= 1'b1;
				bonusIndex <= bonusIndex +1'b1;

			end
			else if((bonusCode == 3'd0) && (bonusCode_d == 3'd0)) begin //bonusCode is '0' for at least 2 clocks
				activate <= 16'b0;
			end
			else
			begin
				bonusIndex <= bonusIndex;
				activate <= activate;
			end
		bonusCode_d <= bonusCode; 
		end//else
end//alwaysff
 
endmodule

