
//modul for choose the word to write according to the level(BGState)


module sentence_mux
(
	input logic clk,
	input logic resetN,
	input logic [2:0] bgState, //the background that nedded to displayd
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
		index = (((offsetY/16)*16) + (offsetX/8)); //the position to right the current pixel
		outOffsetX <= (offsetX%8);
		outOffsetY <= (offsetY%16);
		if(bgState == 3'd1) begin // press s to start
			case (index)
				7'd16: letter <= 6'd1;
				7'd17: letter <= 6'd2;
				7'd18: letter <= 6'd3;
				7'd19: letter <= 6'd4;
				7'd20: letter <= 6'd4;
				7'd22: letter <= 6'd4;
				7'd24: letter <= 6'd7;
				7'd25: letter <= 6'd8;
				7'd27: letter <= 6'd4;
				7'd28: letter <= 6'd7;
				7'd29: letter <= 6'd5;
				7'd30: letter <= 6'd2;
				7'd31: letter <= 6'd7;
				default: letter <= 6'd0;
			endcase
		end
		else if(bgState == 3'd2) begin // press space to randomize bricks
			case (index)
				7'd1: letter <= 6'd1;
				7'd2: letter <= 6'd2;
				7'd3: letter <= 6'd3;
				7'd4: letter <= 6'd4;
				7'd5: letter <= 6'd4;
				7'd7: letter <= 6'd4;
				7'd8: letter <= 6'd1;
				7'd9: letter <= 6'd5;
				7'd10: letter <= 6'd6;
				7'd11: letter <= 6'd3;
				7'd13: letter <= 6'd7;
				7'd14: letter <= 6'd8;
				7'd32: letter <= 6'd2;
				7'd33: letter <= 6'd5;
				7'd34: letter <= 6'd9;
				7'd35: letter <= 6'd10;
				7'd36: letter <= 6'd8;
				7'd37: letter <= 6'd11;
				7'd38: letter <= 6'd12;
				7'd39: letter <= 6'd13;
				7'd40: letter <= 6'd3;
				7'd42: letter <= 6'd14;
				7'd43: letter <= 6'd2;
				7'd44: letter <= 6'd12;
				7'd45: letter <= 6'd6;
				7'd46: letter <= 6'd15;
				7'd47: letter <= 6'd4;
				default: letter <= 6'd0;
			endcase
		end	
		else if(bgState == 3'd3) begin // you win
			case (index)
				7'd20: letter <= 6'd16;
				7'd21: letter <= 6'd8;
				7'd22: letter <= 6'd17;
				7'd24: letter <= 6'd18;
				7'd25: letter <= 6'd12;
				7'd26: letter <= 6'd9;
				default: letter <= 6'd0;
			endcase
		end
		else if(bgState == 3'd4) begin // you win
			case (index)
				7'd20: letter <= 6'd16;
				7'd21: letter <= 6'd8;
				7'd22: letter <= 6'd17;
				7'd24: letter <= 6'd19;
				7'd25: letter <= 6'd8;
				7'd26: letter <= 6'd4;
				7'd27: letter <= 6'd3;
				default: letter <= 6'd0;
			endcase
		end
		else
			letter <= 6'd0;
	end
end

endmodule
		