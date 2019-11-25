/// (c) Technion IIT, Department of Electrical Engineering 2019 
//-- This module  generate the correet prescaler tones for a single ocatave 

//-- Dudy Feb 12 2019 

module	ToneDecoder	(	
					input logic resetN,
					input logic clk,
					input logic hitBottom,
					input logic brikCollision,
					input logic [2:0] batCollision,
					output	logic [9:0]	preScaleValue
		);

logic [3:0] tone = 4'd0;
		
logic [15:0] [9:0]	preScaleValueTable = { 

10'h2EA,   // decimal =746.55      Hz =261.62  do
10'h2C0,   // decimal =704.64      Hz =277.18  doD
10'h299,   // decimal =665.09      Hz =293.66  re
10'h273,   // decimal =627.77      Hz =311.12  reD
10'h250,   // decimal =592.53      Hz =329.62  mi
10'h22F,   // decimal =559.28      Hz =349.22  fa
10'h20F,   // decimal =527.87      Hz =370  faD
10'h1F2,   // decimal =498.24      Hz =392  sol
10'h1D6,   // decimal =470.29      Hz =415.3  solD
10'h1BB,   // decimal =443.89      Hz =440  La
10'h345,   // decimal =837.96      Hz =233.08  laD
10'h316} ; // decimal =790.93      Hz =246.94  si

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		tone <= 4'd0;
	end
	// diciding the tone according to the type of collision
	else begin
		if(brikCollision) tone <= 4'd5;
		else if(hitBottom) tone <= 4'd0;
		else if (batCollision != 3'd0) tone <= 4'd8;
	end
end

assign 	preScaleValue = preScaleValueTable [tone] ; 

endmodule
