
//mux for choose the letter in its order


module game_name_letter_mux
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
		index = ((offsetX/32));
		outOffsetX <= (offsetX%32);
		outOffsetY <= (offsetY%64);
		case (index) //write the name of the game letter by letter acording to the list in GameNameLettersBitMap modul
			7'd0: letter <= 6'd14;
			7'd1: letter <= 6'd2;
			7'd2: letter <= 6'd12;
			7'd3: letter <= 6'd6;
			7'd4: letter <= 6'd15;
			7'd5: letter <= 6'd4;
			default: letter <= 6'd0;
		endcase
	end
end

endmodule
		