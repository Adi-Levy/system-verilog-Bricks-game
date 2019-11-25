

// gets collision detection for bricks and the color of the brick that was hit and adds to the score
// outputs the current score in decimal for 7seg display and screen score display 

module gameScore 	
 ( 
	input	logic clk,
	input	logic resetN, 
	input	logic brikCollision,
	input logic [7:0] scoringColor,
	
	output logic [3:0] score1,
	output logic [3:0] score10,
	output logic [3:0] score100,
	output logic [3:0] score1000
  ) ;
  
  logic [4:0] score1temp = 5'd0;
  logic [4:0] score10temp = 5'd0;
  logic [4:0] score100temp = 5'd0;
  logic [4:0] score1000temp = 5'd0;
  
  logic [4:0] addedScore = 5'd0;
	
  always_ff @(posedge clk or negedge resetN)
	begin
		if (resetN == 1'b0) begin
			score1temp = 5'd0;
			score10temp = 5'd0;
			score100temp = 5'd0;
			score1000temp = 5'd0;
		end
		
		else begin
			// adding score according to the color that was hit
			case (scoringColor)
				8'h6C: addedScore = 5'd5;  	// olive
				8'hE0: addedScore = 5'd3;  	// red 
				8'h03: addedScore = 5'd4;  	// blue
				8'h1C: addedScore = 5'd4;  	// green
				8'h6D: addedScore = 5'd5;  	// grey
				8'hE3: addedScore = 5'd6;	   // magenta
				8'h1F: addedScore = 5'd4;  	// cyan
				8'h60: addedScore = 5'd3;  	// maroon
				8'hFC: addedScore = 5'd5;  	// yellow 
				default: addedScore = 5'd0;	// no color
			endcase
			
			// adding to the score
			if(brikCollision) begin											// counting ones
				if((score1temp + addedScore) <= 5'd9)
					score1temp <= (score1temp + addedScore); 
				else begin														// adding tens
					score1temp <= (score1temp + addedScore - 5'd10);
					if((score10temp + 5'd1) <= 5'd9)
						score10temp <= (score10temp + 5'd1);
					else begin 													// adding hundreds
						score10temp <= 5'd0;
						if((score100temp + 5'd1) <= 5'd9)
							score100temp <= (score100temp + 5'd1);
						else begin												// adding thousends
							score100temp <= 5'd0;
							score1000temp <= (score1000temp + 5'd1);
						end
					end
				end
			end
		end
	end
	
	//outputting the score
	assign score1 = score1temp [3:0];
	assign score10 = score10temp [3:0];
	assign score100 = score100temp [3:0];
	assign score1000 = score1000temp [3:0];
	
endmodule 