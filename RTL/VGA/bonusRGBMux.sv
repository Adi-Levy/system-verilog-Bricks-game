

module bonusRGBMux 
(
		input logic clk,
		input logic resetN,
		input logic [15:0][7:0] bonusRGB,
		input logic [15:0]bonusDrawReq,
		
		output logic [7:0]outRGB,
		output logic bonusMuxDrawReq
);


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			outRGB <= 8'b0;
			bonusMuxDrawReq <= 1'b0;
	end
	else begin
		if(bonusDrawReq == 16'd1) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[0];
		end
		else if(bonusDrawReq == 16'd2) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[1];
		end
		else if(bonusDrawReq == 16'd4) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[2];
		end
		else if(bonusDrawReq == 16'd8) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[3];
		end
		else if(bonusDrawReq == 16'd16) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[4];
		end
		else if(bonusDrawReq == 16'd32) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[5];
		end
		else if(bonusDrawReq == 16'd64) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[6];
		end
		else if(bonusDrawReq == 16'd128) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[7];
		end
		else if(bonusDrawReq == 16'd256) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[8];
		end
		else if(bonusDrawReq == 16'd512) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[9];
		end
		else if(bonusDrawReq == 16'd1024) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[10];
		end
		else if(bonusDrawReq == 16'd2048) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[11];
		end
		else if(bonusDrawReq == 16'd4096) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[12];
		end
		else if(bonusDrawReq == 16'd8192) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[13];
		end
		else if(bonusDrawReq == 16'd16384) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[14];
		end
		else if(bonusDrawReq == 16'd32768) begin
			bonusMuxDrawReq <= 1'b1;
			outRGB <= bonusRGB[15];
		end
		else
			bonusMuxDrawReq <= 1'b0;
	end
end
endmodule
